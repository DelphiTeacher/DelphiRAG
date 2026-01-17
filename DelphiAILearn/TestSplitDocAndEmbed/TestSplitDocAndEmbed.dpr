program TestSplitDocAndEmbed;

uses
  Vcl.Forms,
  Unit3 in 'Unit3.pas' {Form3},
  uDocSplit in '..\DelphiAICommon\uDocSplit.pas',
  uGenTextEmbedding in '..\DelphiAICommon\uGenTextEmbedding.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
