unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,

  XSuperObject,
  System.JSON,
  uGenTextEmbedding,

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}



procedure TForm2.Button1Click(Sender: TObject);
var
  ASuperObject1,ASuperObject2:ISuperObject;
  AStringStream:TStringStream;
  ARequest1Stream:TStringStream;
  ARequest2Stream:TStringStream;
  AResponse1Stream:TStringStream;
  AResponse2Stream:TStringStream;
  ASim:Double;
  APostJson:ISuperObject;
  AHeaders: TNetHeaders;
  Response1: TEmbeddingResponse;
  Response2: TEmbeddingResponse;
begin

  APostJson:=SO();
  APostJson.S['model']:='text-embedding-v3';
  AResponse1Stream:=TStringStream.Create('',TEncoding.UTF8);
  AResponse2Stream:=TStringStream.Create('',TEncoding.UTF8);
  SetLength(AHeaders,2);
  AHeaders[0].Name:='Content-Type';
  AHeaders[0].Value:='application/json';
  AHeaders[1].Name:='Authorization';
  AHeaders[1].Value:='Bearer '+Self.edtAPIKey.Text;


  APostJson.S['input']:=Self.Edit1.Text;
  ARequest1Stream:=TStringStream.Create(APostJson.AsJSON(),TEncoding.UTF8);
  NetHTTPClient1.Post('https://dashscope.aliyuncs.com/compatible-mode/v1/embeddings',ARequest1Stream,AResponse1Stream,AHeaders);
  AResponse1Stream.SaveToFile('D:\helloworld.json');


  APostJson.S['input']:=Self.Edit2.Text;
  ARequest2Stream:=TStringStream.Create(APostJson.AsJSON(),TEncoding.UTF8);
  NetHTTPClient1.Post('https://dashscope.aliyuncs.com/compatible-mode/v1/embeddings',ARequest2Stream,AResponse2Stream,AHeaders);
  AResponse2Stream.SaveToFile('D:\你好世界.json');


  //计算两个向量的相似度
//  AStringStream:=TStringStream.Create('',TEncoding.UTF8);
//  AStringStream.LoadFromFile('D:\helloworld.json');
//  ASuperObject1:=SO(AResponse1Stream.DataString);
  Response1.FromJSON(AResponse1Stream.DataString);

//  AStringStream.LoadFromFile('D:\你好世界.json');
  Response2.FromJSON(AResponse2Stream.DataString);

//  ASim:=CosineSimilarity(ASuperObject1.A['data'].O[0].A['embedding'],ASuperObject2.A['data'].O[0].A['embedding']);
  ASim:=CosineSimilarity(Response1.Data[0].Embedding,Response2.Data[0].Embedding);

  ShowMessage(FloatToStr(ASim));
  AStringStream.Free;
  ARequest1Stream.Free;
  ARequest2Stream.Free;
  AResponse1Stream.Free;
  AResponse2Stream.Free;


  Self.Memo1.Lines.Add(Self.Edit1.Text+'--------'+Self.Edit2.Text+'--------相似度：'+FloatToStr(Round(ASim*100)/100));
//  Self.Memo1.Lines.Add(Self.Edit2.Text);
//  Self.Memo1.Lines.Add('相似度：'+FloatToStr(Round(ASim*100)/100));

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

end.
