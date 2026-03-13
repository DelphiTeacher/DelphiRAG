program testConsole;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Classes,
  kbmMWGlobal,
  System.SysUtils,
  DocumentReader,
  NativePDFDocumentReader,
  TokenTextSplitter,
  RagServer,
  uTestUnit in 'uTestUnit.pas';





var
  ADesc:String;
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
//    testAddDatasetToDB(ADesc);
//    WriteLn('testAddDatasetToDB '+ADesc);



    // 添加文档



    // 分片、向量化

    // 处理向量化

    // 知识库搜索功能


    // 添加模型


    ReadLn;



    
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
