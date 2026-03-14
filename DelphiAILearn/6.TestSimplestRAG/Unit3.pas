unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,

  uDocSplit,
  uGenTextEmbedding,
  GenAI.Async.Promise,

  GenAI, GenAI.Types,

  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.ExtDlgs;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    edtKeyword: TEdit;
    FDConnection1: TFDConnection;
    NetHTTPClient1: TNetHTTPClient;
    Label3: TLabel;
    edtAPIKey: TEdit;
    FDQuery1: TFDQuery;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Memo1: TMemo;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button2: TButton;
    OpenTextFileDialog1: TOpenTextFileDialog;
    edtSim: TEdit;
    Label6: TLabel;
    Panel5: TPanel;
    edtQuestion: TEdit;
    Label7: TLabel;
    Button5: TButton;
    Button6: TButton;
    memSystemPrompt: TMemo;
    memResponse: TMemo;
    Label8: TLabel;
    Label9: TLabel;
    cmbModels: TComboBox;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    Client: IGenAI;
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  AChunks:TStrings;
  I: Integer;
begin
  AChunks:=SplitDoc(Self.Memo1.Text,1024);
  Self.ListBox1.Items.Clear;
  try
    for I := 0 to AChunks.Count-1 do
    Begin
      Self.ListBox1.Items.Add(AChunks[I]);
    End;

  finally
    AChunks.Free;
  end;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  if Self.OpenTextFileDialog1.Execute() then
  begin
    Self.Memo1.Lines.LoadFromFile(Self.OpenTextFileDialog1.FileName,TEncoding.UTF8);
  end;
end;

procedure TForm3.Button3Click(Sender: TObject);
var
  I: Integer;
//  ATempEmbeddingResp:TEmbeddingResponse;
var
  Value1:TEmbeddings;
begin
  //
  FDConnection1.Connected:=True;

  for I := 0 to Self.ListBox1.Items.Count-1 do
  begin
    //生成向量
//    ATempEmbeddingResp:=GetTextEmbedding(NetHTTPClient1,Self.ListBox1.Items[I],Self.edtAPIKey.Text);
    Value1 := Client.Embeddings.Create(
      procedure (Params: TEmbeddingsParams)
      begin
        Params.Input([Self.ListBox1.Items[I]]);
        Params.Model('text-embedding-v3');
        Params.Dimensions(1024);
        Params.EncodingFormat(TEncodingFormat.float);
      end);



    Self.FDQuery1.SQL.Text:='INSERT INTO delphiai.modeldata(vector,chunk) '
        +'values (ARRAY['+DoubleArrayToString(Value1.Data[0].Embedding)+'],:chunk)';


    //将向量保存到数据库中
    Self.FDQuery1.ParamByName('chunk').AsWideString:=Self.ListBox1.Items[I];

    FDQuery1.ExecSQL;

  end;

end;

procedure TForm3.Button4Click(Sender: TObject);
var
  I: Integer;
  AKeywordEmbeddingResp:TEmbeddingResponse;
begin
  FDConnection1.Connected:=True;
  //
  AKeywordEmbeddingResp:=GetTextEmbedding(NetHTTPClient1,Self.edtKeyword.Text,Self.edtAPIKey.Text);
  Self.FDQuery1.Active:=False;
  Self.FDQuery1.SQL.Text:='SELECT id, chunk,inner_product(vector , ARRAY['+DoubleArrayToString(AKeywordEmbeddingResp.Data[0].Embedding)+']::vector) AS score FROM delphiai.modeldata ORDER BY score desc LIMIT 100;';
  Self.FDQuery1.Active:=True;

  Self.ListBox2.Items.Clear;
  while not Self.FDQuery1.Eof do
  begin
    if Self.FDQuery1.FieldByName('score').AsFloat>=StrToFloat(Self.edtSim.Text) then
    begin
      Self.ListBox2.Items.Add('文本相关度：'+FloatToStr(Self.FDQuery1.FieldByName('score').AsFloat)+#13+#10+#13+#10+Self.FDQuery1.FieldByName('chunk').AsString);
    end;
    Self.FDQuery1.Next;
  end;
end;

procedure TForm3.Button5Click(Sender: TObject);
var
  AText:String;
  ARefrenceText:String;
  I: Integer;
begin
  Button4Click(nil);

  ARefrenceText:='';
  for I := 0 to Self.ListBox2.Items.Count-1 do
  begin
    ARefrenceText:=ARefrenceText+'{'+#13#10
                                  +'  "sourceName": "Delphi_10_Seattle_手册_简体中文版.pdf",'+#13#10
                                  +'  "content": "'+#13#10+Self.ListBox2.Items[I]+#13#10+'"'+#13#10
                                  +'}'+#13#10  
  end;
  AText:='使用 <Reference></Reference> 标记中的内容作为本次对话的参考:'+#13#10
        +''+#13#10
        +'<Reference>'+#13#10
//        +'{'+#13#10
//        +'  "sourceName": "文档名称",'+#13#10
//        +'  "content": "片断1内容"'+#13#10
//        +'}'+#13#10
//        +'{'+#13#10
//        +'  "sourceName": "文档名称",'+#13#10
//        +'  "content": "片断2内容"'+#13#10
//        +'}'+#13#10
//        +''+#13#10
        +ARefrenceText
        +'</Reference>'+#13#10
        +''+#13#10
        +''+#13#10
        +'回答要求：'+#13#10
        +'- 如果你不清楚答案，你需要澄清。'+#13#10
        +'- 避免提及你是从 <Reference></Reference> 获取的知识。'+#13#10
        +'- 保持答案与 <Reference></Reference> 中描述的一致。'+#13#10
        +'- 使用与问题相同的语言回答。'+#13#10;

  Self.memSystemPrompt.Text:=AText;

end;

procedure TForm3.Button6Click(Sender: TObject);
begin

  Client.Chat.AsyncAwaitCreate(
    procedure (Params: TChatParams)
    begin
      Params.Model(Self.cmbModels.Text);
      Params.Messages([
        FromSystem(Self.memSystemPrompt.Text),
        FromUser(Self.edtQuestion.Text)
      ]);
    end,
    function : TPromiseChat
    begin
    end)
    .&Then<String>(
      function (Value:TChat):string
      begin
        Self.memResponse.Text:=Value.Choices[0].Message.Content;
      end
      )
    .&Catch(
      procedure (E: Exception)
      begin
        //报错处理
      end);

//var
//  Value:TChat;
//begin
//  Value := Client.Chat.Create(
//    procedure (Params: TChatParams)
//    begin
//      Params.Model(Self.cmbModels.Text);
//      Params.Messages([
//        FromSystem(Self.memSystemPrompt.Text),
//        FromUser(Self.edtQuestion.Text)
//      ]);
//    end);
//  Self.memResponse.Text:=Value.Choices[0].Message.Content;
//
end;

procedure TForm3.Button7Click(Sender: TObject);
begin
  Client.Chat.CreateStream(
    procedure (Params: TChatParams)
    begin
      Params.Model(Self.cmbModels.Text);
      Params.Messages([
        FromSystem(Self.memSystemPrompt.Text),
        FromUser(Self.edtQuestion.Text)
          ]);
      //Params.Store(True);  // to store chat completion
      Params.Stream;
//      TutorialHub.JSONRequest := Params.ToFormat();
    end,
    procedure (var Chat: TChat; IsDone: Boolean; var Cancel: Boolean)
    begin
      if (not IsDone) and Assigned(Chat) then
        begin
//          DisplayStream(TutorialHub, Chat);
//          Self.memResponse.Text:=Chat.JSONResponse;
          Self.memResponse.Text:=Self.memResponse.Text+Chat.JSONResponse+#13#10;//.Choices[0].Delta.Content;
//          Self.memResponse.Text:=Self.memResponse.Text+Chat.Choices[0].Delta.Content;
          Application.ProcessMessages;

        end;
    end);
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Client := TGenAI.Create(Self.edtAPIKey.Text);
  Client.BaseURL := 'https://dashscope.aliyuncs.com/compatible-mode/v1';


end;

procedure TForm3.FormResize(Sender: TObject);
begin
//  Self.Panel2.Width:=Self.ClientWidth div 3;
//  Self.Panel3.Width:=Self.ClientWidth div 3;
//  Self.Panel4.Width:=Self.ClientWidth div 3;
end;

procedure TForm3.ListBox1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  AStr:String;
  AListBox:TListBox;
begin
  AListBox:=TListBox(Control);
//  ListBox1.Canvas.TextOut(Rect.Left,Rect.Top,Self.ListBox1.Items[Index]);
  if Index mod 2=1 then
  begin
    AListBox.Canvas.Brush.Style:=bsSolid;
    AListBox.Canvas.Brush.Color:=$EDEDED;
    AListBox.Canvas.FillRect(Rect);
  end;
  AStr:=AListBox.Items[Index];
  AListBox.Canvas.TextRect(Rect,AStr,[tfEndEllipsis])
end;

end.
