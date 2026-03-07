program testConsole;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DocumentReader,
  NativePDFDocumentReader;

var
  pdfreader:TNativePDFDocumentReader;
  parseResult:TParseDocumentResult;
begin
  try
    { TODO -oUser -cConsole Main : Insert code here }

    WriteLn('Hello World!');

    // 测试PDF文档的解析
    pdfreader:= TNativePDFDocumentReader.Create;
    parseResult:=pdfreader.Read('D:\DelphiRAG\Source\Win32\Debug\spring_ai_alibaba_quickstart.pdf');
    WriteLn(parseResult.MarkdownContent);
    pdfreader.Free;
    parseResult.Free;



    
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
