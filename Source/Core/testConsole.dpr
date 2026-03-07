program testConsole;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Classes,
  System.SysUtils,
  DocumentReader,
  NativePDFDocumentReader,
  TokenTextSplitter;

var
  I:Integer;
  pdfreader:TNativePDFDocumentReader;
  parseResult:TParseDocumentResult;
  spliter:TTokenTextSplitter;
  spliterResult:TStringList;
begin
  try
    { TODO -oUser -cConsole Main : Insert code here }

    WriteLn('Hello World!');

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



    
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
