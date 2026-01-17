unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,

  GenAI.Async.Promise,

  GenAI, GenAI.Types,



  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm4 = class(TForm)
    edtQuestion: TEdit;
    Button1: TButton;
    memResponse: TMemo;
    Label1: TLabel;
    Button2: TButton;
    edtAIServer: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtAPIKey: TEdit;
    cmbModels: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    Client: IGenAI;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
begin
  Client.BaseURL := Self.edtAIServer.Text;

  Client.Chat.AsyncAwaitCreate(
    procedure (Params: TChatParams)
    begin
      Params.Model(Self.cmbModels.Text);
      Params.Messages([
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
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  Client.BaseURL := Self.edtAIServer.Text;

  Client.Chat.CreateStream(
    procedure (Params: TChatParams)
    begin
      Params.Model(Self.cmbModels.Text);
      Params.Messages([
        FromUser(Self.edtQuestion.Text)
      ]);
      Params.Stream;
    end,
    procedure (var Chat: TChat; IsDone: Boolean; var Cancel: Boolean)
    begin
      if (not IsDone) and Assigned(Chat) then
        begin
          //将大模型回复的分块拼起来
          Self.memResponse.Text:=Self.memResponse.Text+Chat.Choices[0].Delta.Content;
          Application.ProcessMessages;

        end;
    end);

end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  Client := TGenAI.Create(Self.edtAPIKey.Text);
  Client.BaseURL := 'https://dashscope.aliyuncs.com/compatible-mode/v1';

end;

end.
