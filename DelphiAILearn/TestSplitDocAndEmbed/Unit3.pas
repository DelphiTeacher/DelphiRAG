unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,

  uDocSplit,
  uGenTextEmbedding,


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
    procedure Button1Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
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
  ATempEmbeddingResp:TEmbeddingResponse;
begin
  //
  FDConnection1.Connected:=True;

  for I := 0 to Self.ListBox1.Items.Count-1 do
  begin
    //生成向量
    ATempEmbeddingResp:=GetTextEmbedding(NetHTTPClient1,Self.ListBox1.Items[I],Self.edtAPIKey.Text);


    Self.FDQuery1.SQL.Text:='INSERT INTO delphiai.modeldata(vector,chunk) '
        +'values (ARRAY['+DoubleArrayToString(ATempEmbeddingResp.Data[0].Embedding)+'],:chunk)';


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

procedure TForm3.FormResize(Sender: TObject);
begin
  Self.Panel2.Width:=Self.ClientWidth div 3;
  Self.Panel3.Width:=Self.ClientWidth div 3;
  Self.Panel4.Width:=Self.ClientWidth div 3;
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
