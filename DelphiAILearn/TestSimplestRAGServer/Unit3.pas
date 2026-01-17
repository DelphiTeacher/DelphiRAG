unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,

  uDocSplit,
  uGenTextEmbedding,
  GenAI.Async.Promise,

  GenAI, GenAI.Types,
  System.JSON,

  DateUtils,
  StrUtils,
  uOpenAIStreamServerHelper,

  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.ExtDlgs,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer,IdGlobal,IdContext;

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
    IdHTTPServer1: TIdHTTPServer;
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
    procedure IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure IdHTTPServer1ParseAuthentication(AContext: TIdContext; const AAuthType, AAuthData: string; var VUsername, VPassword: string; var VHandled: Boolean);
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
//  LChar: Char;
//  LDelta: TJSONObject;
//  LChoice: TJSONObject;


procedure TForm3.IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
  AResponseInfo: TIdHTTPResponseInfo);
var
  AStringStream:TStringStream;
  LJSON, LMessage: TJSONObject;
  LMessages: TJSONArray;
  LStream: Boolean;
  LModel, LContent: string;
  I: Integer;
  S:String;
  Msg:String;
  Value:TChat;
  AJsonStr:String;
  AChatJson:TJSONObject;
begin
  // 只处理 POST /v1/chat/completions
  if (ARequestInfo.Command <> 'POST') or
     (ARequestInfo.Document <> '/v1/chat/completions') then
  begin
    AResponseInfo.ResponseNo := 404;
    Exit;
  end;

  // 解析请求 JSON
  try
    AStringStream:=TStringStream.Create('',TEncoding.UTF8);
    AStringStream.LoadFromStream(ARequestInfo.PostStream);

    LJSON := TJSONObject.ParseJSONValue(AStringStream.DataString) as TJSONObject;
    try
      LStream := False;
      if LJSON.GetValue('stream') is TJSONBool then
        LStream := TJSONBool(LJSON.GetValue('stream')).AsBoolean;

      LModel := 'gpt-3.5-turbo';
      if LJSON.GetValue('model') <> nil then
        LModel := LJSON.GetValue('model').Value;

      LMessages := LJSON.GetValue('messages') as TJSONArray;

      // 提取用户消息（简化示例，取最后一条）
      if LMessages.Count > 0 then
      begin
        LMessage := LMessages.Items[LMessages.Count - 1] as TJSONObject;
        LContent := LMessage.GetValue('content').Value;
      end;

      // 流式响应
      if LStream then
      begin
//          // ===== Header =====
//          AResponseInfo.ResponseNo := 200;
//          AResponseInfo.ContentType := 'text/event-stream; charset=UTF-8';
//          AResponseInfo.CacheControl := 'no-cache';
//          AResponseInfo.ContentLength := -1;
//          AResponseInfo.TransferEncoding := 'chunked';
//
//          // 立即发送 Header
//          AResponseInfo.WriteHeader;
//
//          Msg := 'Hello,World!';
//
//          for I := 1 to Length(Msg) do
//          begin
//            S :=
//              'data: {"choices":[{"delta":{"content":"' +
//              Msg[I] +
//              '"}}]}' + #13#10#13#10;
//
//            WriteChunk(AContext,S);
//
//            // 模拟生成延迟
//            Sleep(200);
//          end;
//
//          // 结束标志
//          //AI内容传输完了
//          S:='data: [DONE]' + #13#10#13#10;
//          WriteChunk(AContext,S);
//
//          //发送结束
//          S:='';
//          WriteChunk(AContext,S);


//          // 设置响应头
//          AResponseInfo.ResponseNo := 200;
//          AResponseInfo.ResponseText := 'OK';
//          AResponseInfo.ContentType := 'text/event-stream';
//          AResponseInfo.CacheControl := 'no-cache';
//          AResponseInfo.Connection := 'keep-alive';
//          AResponseInfo.TransferEncoding := 'chunked'; // 启用Chunked传输
//
//          // 获取连接
//          with AContext.Connection.IOHandler do
//          begin
//            // 先发送HTTP响应头
//            WriteLn('HTTP/1.1 200 OK');
//            WriteLn('Content-Type: text/event-stream');
//            WriteLn('Transfer-Encoding: chunked');
//            WriteLn('Cache-Control: no-cache');
//            WriteLn('Connection: keep-alive');
//            WriteLn('');
//
//            try
//              // 模拟OpenAI流式响应
//              for i := 1 to 10 do
//              begin
//                // 模拟生成数据
//                chunkData := Format('data: {"id":"chat_%d","object":"chat.completion.chunk",' +
//                                   '"created":%d,"model":"gpt-3.5-turbo","choices":[{"delta":' +
//                                   '{"content":"这是第%d个流式响应块。"}}]}' + #13#10#13#10,
//                                   [i, DateTimeToUnix(Now), i]);
//
//                // 发送chunked数据格式: [chunk-size]\r\n[chunk-data]\r\n
//                WriteLn(IntToHex(Length(chunkData), 0)); // 发送chunk大小(16进制)
//                WriteLn(chunkData); // 发送chunk数据
//                WriteLn(''); // 结束当前chunk
//
//                // 模拟处理延迟
//                Sleep(1000);
//
//                // 检查连接是否还活跃
//                if not AContext.Connection.Connected then
//                  Break;
//              end;
//
//              // 发送结束标记: 0长度的chunk
//              WriteLn('0');
//              WriteLn('');
//
//            except
//              on E: Exception do
//                // 处理异常
//            end;
//          end;



          // ===== Header =====
          AResponseInfo.ResponseNo := 200;
          AResponseInfo.ContentType := 'text/event-stream; charset=UTF-8';
          AResponseInfo.CacheControl := 'no-cache';
          AResponseInfo.ContentLength := -1;
          AResponseInfo.TransferEncoding := 'chunked';

          // 立即发送 Header
          AResponseInfo.WriteHeader;


          Client.Chat.CreateStream(
            procedure (Params: TChatParams)
            begin
              Params.Model(Self.cmbModels.Text);
              Params.Messages([
                FromSystem(Self.memSystemPrompt.Text),
                FromUser(LContent)
                  ]);
              Params.Stream;
            end,
            //这个事件是收到大模型返回的数据的回调事件，IsDone表示是否接收到了[DONE],表示接收结束
            procedure (var Chat: TChat; IsDone: Boolean; var Cancel: Boolean)
            begin
              if (not IsDone) and Assigned(Chat) then
                begin
                  //转发大模型返回的分块
//                  OutputDebugString(PWideChar(Chat.JsonResponse));
                  AChatJSON := TJSONObject.ParseJSONValue(Chat.JsonResponse) as TJSONObject;
                  try
                    //将中文编码后
                    AJsonStr:=AChatJSON.ToJSON();
                    OutputDebugString(PWideChar(AJsonStr));
                    WriteChunk(AContext,'data: '+ ReplaceStr(AJsonStr,#13#10,'')+ #13#10#13#10);

                  finally
                    AChatJSON.Free;
                  end;

                end
                else
                begin
                  // 结束标志
                  //AI内容传输完了
                  S:='data: [DONE]';
                  WriteChunk(AContext,S);

                  //发送结束
                  S:='';
                  WriteChunk(AContext,S);

                end;
            end);


//
//        // 发送 SSE 格式的响应
//        SendSSEEvent(AContext, '', '{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1677652288,"model":"' + LModel + '","choices":[{"index":0,"delta":{"role":"assistant"},"finish_reason":null}]}' + #13#10);
//
//        // 模拟流式返回消息内容
//        for I := 1 to Length(LContent) do
//        begin
//          LChar := LContent[I];
//
//          // 构建 delta 响应
//          LDelta := TJSONObject.Create;
//          LChoice := TJSONObject.Create;
//          try
//            LDelta.AddPair('content', LChar);
//
//            LChoice.AddPair('index', TJSONNumber.Create(0));
//            LChoice.AddPair('delta', LDelta);
//            LChoice.AddPair('finish_reason', TJSONNull.Create);
//
//            SendSSEEvent(AContext, '',
//              '{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1677652288,"model":"' + LModel + '","choices":[' + LChoice.ToJSON + ']}' + #13#10);
//
//            Sleep(50); // 模拟生成延迟
//          finally
////            LDelta.Free;
//            LChoice.Free;
//          end;
//        end;
//
//
//
//        // 发送结束标记
//        SendSSEEvent(AContext, '', '{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1677652288,"model":"' + LModel + '","choices":[{"index":0,"delta":{},"finish_reason":"stop"}]}' + #13#10);
//
//        SendSSEEvent(AContext, '', '[DONE]' + #13#10);


      end
      else
      begin

        // 非流式响应
        AResponseInfo.ContentType := 'application/json; charset=utf-8';

        Value := Client.Chat.Create(
          procedure (Params: TChatParams)
          begin
            Params.Model(LModel);
            Params.Messages([
              FromSystem(Self.memSystemPrompt.Text),
              FromUser(LContent)
            ]);
          end);

        AResponseInfo.ContentText := Value.JSONResponse;

      end;


    finally
      LJSON.Free;
      AStringStream.Free;
    end;
  except
    on E: Exception do
    begin
      AResponseInfo.ResponseNo := 500;
      AResponseInfo.ContentText := '{"error":"' + E.Message + '"}';
    end;
  end;
end;

procedure TForm3.IdHTTPServer1ParseAuthentication(AContext: TIdContext; const AAuthType, AAuthData: string;
  var VUsername, VPassword: string; var VHandled: Boolean);
begin
  //验证通过
  VHandled:=True;
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
