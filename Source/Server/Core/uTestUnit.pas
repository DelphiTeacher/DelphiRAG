unit uTestUnit;

interface


uses
  Classes,
  SysUtils,
  uFuncCommon,
  XSuperObject,
  DocumentReader,
  NativePDFDocumentReader,
  TokenTextSplitter,
  UploadFile,
  uDatasetCollectionProcessTask,
  uTableCommonRestCenter,
  RagServer;

function testSpliter(var ADesc:String):Boolean;
// 测试添加知识库到数据库
function testAddDatasetToDB(var ADesc:String):Boolean;

// 上传文件
function testUploadFile(AFilePath:String;var ADesc:String):Boolean;

// 上传文件并创建一个数据集
function testCreateCollectionByFile(AFileId:String;ADatasetId:String;var ADesc:String):Boolean;


function testProcessDatasetCollectionTask(var ADesc:String):Boolean;


implementation




function testProcessDatasetCollectionTask(var ADesc:String):Boolean;
begin
  ProcessDatasetCollectionTask();
end;


function testUploadFile(AFilePath:String;var ADesc:String):Boolean;
var
  ADataJson:ISuperObject;
  AMemoryStream:TMemoryStream;
begin
  AMemoryStream:=TMemoryStream.Create;
  try
    AMemoryStream.LoadFromFile(AFilePath);
    AMemoryStream.Position:=0;

    UploadFile.ProcessUploadFileStream(ExtractFileName(AFilePath),AMemoryStream,'dataset',ADesc,ADataJson);
  finally
    AMemoryStream.Free;
  end;
end;

function testCreateCollectionByFile(AFileId:String;ADatasetId:String;var ADesc:String):Boolean;
var
  ACode:Integer;
  // ADesc:String;
  ADataJson:ISuperObject;
  AStringStream:TStringStream;
  ARecordJson:ISuperObject;

  AIntfItem:TCommonRestIntfItem;
begin
  ARecordJson:=SO();
//  ARecordJson.S['_id']:=CreateGUIDString();
  ARecordJson.S['teamId']:='1044';
  ARecordJson.S['tmbId']:='admin';
  ARecordJson.S['datasetId']:=ADatasetId;
  ARecordJson.S['type']:='file';
  ARecordJson.S['name']:='spring_ai_alibaba_quickstart.pdf';
  ARecordJson.B['forbid']:=False;
  // 分片设置
  ARecordJson.S['trainingType']:='chunk';
  ARecordJson.S['chunkSettingMode']:='auto';
  ARecordJson.S['chunkSplitMode']:='size';
  ARecordJson.I['chunkSize']:=1024;
  ARecordJson.I['indexSize']:=1024;
  
  ARecordJson.S['fileId']:=AFileId;
  ARecordJson.S['state']:='wait';

  AIntfItem:=GlobalCommonRestIntfList.Find('dataset_collections');
  if AIntfItem=nil then
  begin
    ADesc:='不存在dataset_collections接口';
    Exit;
  end;
  //新增
  AIntfItem.AddRecord(AIntfItem.DBModule,
                      nil,
                      '',
                      ARecordJson,
                      nil,
                      ACode,
                      ADesc,
                      ADataJson
                      );



end;


function testAddDatasetToDB(var ADesc:String):Boolean;
var
  ACode:Integer;
  // ADesc:String;
  ADataJson:ISuperObject;
  AStringStream:TStringStream;
  ARecordJson:ISuperObject;

  AIntfItem:TCommonRestIntfItem;
begin
  ARecordJson:=SO();
//  ARecordJson.S['_id']:=CreateGUIDString();
  ARecordJson.S['teamId']:='1044';
  ARecordJson.S['tmbId']:='admin';
  ARecordJson.S['type']:='file';
  ARecordJson.S['status']:='activate';
  ARecordJson.S['vectorModel']:='text-embedding-v3';
  ARecordJson.S['intro']:='test';

  AIntfItem:=GlobalCommonRestIntfList.Find('datasets');
  if AIntfItem=nil then
  begin
    ADesc:='不存在datasets接口';
    Exit;
  end;
  //新增
  AIntfItem.AddRecord(AIntfItem.DBModule,
                      nil,
                      '',
                      ARecordJson,
                      nil,
                      ACode,
                      ADesc,
                      ADataJson
                      );

end;


function testSpliter(var ADesc:String):Boolean;
var
  I:Integer;
  pdfreader:TNativePDFDocumentReader;
  parseResult:TParseDocumentResult;
  spliter:TTokenTextSplitter;
  spliterResult:TStringList;begin
  // 测试PDF文档的解析
  pdfreader:= TNativePDFDocumentReader.Create;
  parseResult:=pdfreader.Read('D:\DelphiRAG\Source\Win32\Debug\spring_ai_alibaba_quickstart.pdf');
  WriteLn(parseResult.MarkdownContent);

  // 文档分片
  spliter:=TTokenTextSplitter.Create();
  spliterResult:=spliter.Split(parseResult.MarkdownContent);
  for i := 0 to spliterResult.Count-1 do
  begin
    WriteLn('------------分片'+IntToStr(i+1)+'--------------');
    WriteLn(spliterResult[i]);
  end;
  spliter.Free;
  spliterResult.Free;



  pdfreader.Free;
  parseResult.Free;

end;


end.
