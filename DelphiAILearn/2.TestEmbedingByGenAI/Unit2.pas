unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,

  XSuperObject,
  System.JSON,
  uGenTextEmbedding,


  GenAI.Async.Promise,

  GenAI, GenAI.Types,

  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent;

type


  TForm2 = class(TForm)
    Button1: TButton;
    NetHTTPClient1: TNetHTTPClient;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    edtKeyword: TEdit;
    Button2: TButton;
    Memo3: TMemo;
    edtAPIKey: TEdit;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    Client: IGenAI;
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}



procedure TForm2.Button1Click(Sender: TObject);
var
  ASim:Double;
  Value1:TEmbeddings;
  Value2:TEmbeddings;
begin
  Value1 := Client.Embeddings.Create(
    procedure (Params: TEmbeddingsParams)
    begin
      Params.Input([Self.Edit1.Text]);
      Params.Model('text-embedding-v3');
      Params.Dimensions(1024);
      Params.EncodingFormat(TEncodingFormat.float);
    end);

  Value2 := Client.Embeddings.Create(
    procedure (Params: TEmbeddingsParams)
    begin
      Params.Input([Self.Edit2.Text]);
      Params.Model('text-embedding-v3');
      Params.Dimensions(1024);
      Params.EncodingFormat(TEncodingFormat.float);
    end);

  ASim:=CosineSimilarity(Value1.Data[0].Embedding,Value2.Data[0].Embedding);


  Self.Memo1.Lines.Add(Self.Edit1.Text+'--------'+Self.Edit2.Text
    +'--------相似度：'+FloatToStr(Round(ASim*100)/100));

end;

procedure TForm2.Button2Click(Sender: TObject);
var
  I: Integer;
  AKeywordEmbeddingResp:TEmbeddingResponse;
  ATempEmbeddingResp:TEmbeddingResponse;
  AStringStream:TStringStream;
  ASim:Double;
begin
  Self.Memo3.Lines.Clear;

  AKeywordEmbeddingResp:=GetTextEmbedding(NetHTTPClient1,Self.edtKeyword.Text,Self.edtAPIKey.Text);


  AStringStream:=TStringStream.Create(DoubleArrayToString(AKeywordEmbeddingResp.Data[0].Embedding),TEncoding.UTF8);
  AStringStream.SaveToFile('D:\double.txt');
  AStringStream.Free;

  for I := 0 to Self.Memo2.Lines.Count-1 do
  begin
    ATempEmbeddingResp:=GetTextEmbedding(NetHTTPClient1,Self.Memo2.Lines[I],Self.edtAPIKey.Text);
    ASim:=CosineSimilarity(AKeywordEmbeddingResp.Data[0].Embedding,ATempEmbeddingResp.Data[0].Embedding);
//    if ASim>0.5 then
//    begin
      Self.Memo3.Lines.Add('相关性：'+FloatToStr(ASim)+' '+Self.Memo2.Lines[I])
//    end;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Client := TGenAI.Create(Self.edtAPIKey.Text);
  Client.BaseURL := 'https://dashscope.aliyuncs.com/compatible-mode/v1';

end;

end.
