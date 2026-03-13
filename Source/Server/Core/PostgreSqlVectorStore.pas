unit PostgreSqlVectorStore;

interface

uses
  System.SysUtils, System.Classes, System.Math, System.Generics.Collections,
  VectorStore, uBaseList, uGenTextEmbedding, uUniDBHelper, Data.DB, ServerDataBaseModule;

type
  TPostgreSqlVectorStore = class(TInterfacedObject, IVectorStore)
  private
    FTableName: string;
    FDBModule: TDataBaseModule;
    procedure EnsureTableExists;
    function VectorToString(const AVector: TArray<Double>): string;
    function StringToVector(const AStr: string): TArray<Double>;
  public
    constructor Create(ATableName: string = 'modelData');
    destructor Destroy; override;
    
    procedure Add(AChunks: TStrings);
    procedure Delete(AChunkId: String);
    function SimilaritySearch(ASearchRequest: TSearchRequest): TSearchResultList;
  end;

implementation

{ TPostgreSqlVectorStore }

constructor TPostgreSqlVectorStore.Create(ATableName: string = 'modelData');
begin
  inherited Create;
  FDBModule:=TServerDataBaseModule.Create;
  FTableName := ATableName;
  EnsureTableExists;
end;

destructor TPostgreSqlVectorStore.Destroy;
begin
  FreeAndNil(FDBModule);
  inherited;
end;

procedure TPostgreSqlVectorStore.EnsureTableExists;
var
  SQL: string;
  ASQLDBHelper: TBaseDBHelper;
begin
  if not FDBModule.GetDBHelperFromPool(ASQLDBHelper,ADesc) then
  begin
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
    Exit;
  end;
  try

    SQL := Format(
      'CREATE TABLE IF NOT EXISTS %s (' +
      '  id SERIAL PRIMARY KEY,' +
      '  chunk_id VARCHAR(255) UNIQUE NOT NULL,' +
      '  content TEXT NOT NULL,' +
      '  embedding vector(1536),' +
      '  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP' +
      ')', [FTableName]);

    try
      FDBHelper.ExecuteSQL(SQL);
    except
      on E: Exception do
        raise Exception.Create('Failed to create vector table: ' + E.Message);
    end;

  finally
    FDBModule.FreeDBHelperToPool(ASQLDBHelper);
  end;

end;

function TPostgreSqlVectorStore.VectorToString(const AVector: TArray<Double>): string;
begin
  Result := DoubleArrayToString(AVector);
end;

function TPostgreSqlVectorStore.StringToVector(const AStr: string): TArray<Double>;
var
  Parts: TArray<string>;
  i: Integer;
begin
  Parts := AStr.Split([',']);
  SetLength(Result, Length(Parts));
  for i := 0 to High(Parts) do
  begin
    Result[i] := StrToFloatDef(Trim(Parts[i]), 0.0);
  end;
end;

procedure TPostgreSqlVectorStore.Add(AChunks: TStrings);
var
  i: Integer;
  ChunkId: string;
  Content: string;
  Embedding: TArray<Double>;
  EmbeddingStr: string;
  SQL: string;
  ASQLDBHelper: TBaseDBHelper;
begin
  if not FDBModule.GetDBHelperFromPool(ASQLDBHelper,ADesc) then
  begin
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
    Exit;
  end;
  try


    for i := 0 to AChunks.Count - 1 do
    begin
      Content := AChunks[i];
      ChunkId := Format('chunk_%d_%d', [i, GetTickCount]);
      
      // TODO: Call embedding service to generate vector
      // For now, create a placeholder vector
      SetLength(Embedding, 1536);
      FillChar(Embedding[0], Length(Embedding) * SizeOf(Double), 0);
      
      EmbeddingStr := VectorToString(Embedding);
      
      SQL := Format(
        'INSERT INTO %s (chunk_id, content, embedding) VALUES (%s, %s, %s) ' +
        'ON CONFLICT (chunk_id) DO UPDATE SET content = EXCLUDED.content, embedding = EXCLUDED.embedding',
        [FTableName,
        QuotedStr(ChunkId),
        QuotedStr(Content),
        QuotedStr(EmbeddingStr)]);
      
      try
        FDBHelper.ExecuteSQL(SQL);
      except
        on E: Exception do
          raise Exception.Create('Failed to insert chunk: ' + E.Message);
      end;
    end;

  finally
    FDBModule.FreeDBHelperToPool(ASQLDBHelper);
  end;
end;

procedure TPostgreSqlVectorStore.Delete(AChunkId: String);
var
  SQL: string;
  ASQLDBHelper: TBaseDBHelper;
begin
  if not FDBModule.GetDBHelperFromPool(ASQLDBHelper,ADesc) then
  begin
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
    Exit;
  end;
  try


    SQL := Format('DELETE FROM %s WHERE chunk_id = %s', [FTableName, QuotedStr(AChunkId)]);
    
    try
      FDBHelper.ExecuteSQL(SQL);
    except
      on E: Exception do
        raise Exception.Create('Failed to delete chunk: ' + E.Message);
    end;

  finally
    FDBModule.FreeDBHelperToPool(ASQLDBHelper);
  end;
end;

function TPostgreSqlVectorStore.SimilaritySearch(ASearchRequest: TSearchRequest): TSearchResultList;
var
  SQL: string;
  QueryDataSet: TDataSet;
  Embedding: TArray<Double>;
  EmbeddingStr: string;
  Similarity: Double;
  ResultItem: TSearchResult;
  ASQLDBHelper: TBaseDBHelper;
begin
  Result:=nil;
  if not FDBModule.GetDBHelperFromPool(ASQLDBHelper,ADesc) then
  begin
    Result:=ReturnJson(ACode,ADesc,ADataJson).AsJSON;
    Exit;
  end;
  try

    Result := TSearchResultList.Create;
    


    // TODO: Call embedding service to generate query vector
    SetLength(Embedding, 1536);
    FillChar(Embedding[0], Length(Embedding) * SizeOf(Double), 0);
    
    EmbeddingStr := VectorToString(Embedding);
    
    SQL := Format(
      'SELECT chunk_id, content, embedding, ' +
      '1 - (embedding <-> %s::vector) / 2 as similarity ' +
      'FROM %s ' +
      'WHERE (1 - (embedding <-> %s::vector) / 2) > %f ' +
      'ORDER BY similarity DESC ' +
      'LIMIT %d',
      [QuotedStr(EmbeddingStr),
      FTableName,
      QuotedStr(EmbeddingStr),
      ASearchRequest.Threshold,
      ASearchRequest.TopK]);
    
    try
      QueryDataSet := FDBHelper.QuerySQL(SQL);
      if QueryDataSet <> nil then
      begin
        QueryDataSet.First;
        while not QueryDataSet.Eof do
        begin
          ResultItem := TSearchResult.Create;
          // TODO: Populate ResultItem with data from QueryDataSet
          Result.Add(ResultItem);
          QueryDataSet.Next;
        end;
        QueryDataSet.Free;
      end;
    except
      on E: Exception do
        raise Exception.Create('Failed to search: ' + E.Message);
    end;
  finally
    FDBModule.FreeDBHelperToPool(ASQLDBHelper);
  end;
end;

end.
