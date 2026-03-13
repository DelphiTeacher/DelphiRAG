program testConsole;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Classes,
  System.SysUtils,
  DocumentReader,
  NativePDFDocumentReader,
  TokenTextSplitter,
  RagServer;


procedure testSpliter;
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




begin
  try
    { TODO -oUser -cConsole Main : Insert code here }

    WriteLn('Hello World!');

    // 启动Rag服务
    GlobalRagServer:=TRagServer.Create(nil);
    GlobalRagServer.FDBModule.DBConfigFileName:='RagCenterDBConfig.ini';
    GlobalRagServer.FDBModule.DBConfig.FDBDataBaseName:='rag_center';
    GlobalRagServer.Start;


    // 创建知识库

    // 添加文档、分片、向量化

    // 处理向量化

    // 知识库搜索功能


    // 添加模型




    
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
