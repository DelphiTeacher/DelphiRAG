program DelphiRagServer;



uses
  Vcl.Forms,
  SysUtils,
  uFileCommon,
  uServerLogicCommon in 'uServerLogicCommon.pas',
  UserCenterRestService in 'UserCenterRestService.pas' {srvUserCenterRestService: TkbmMWCustomSmartService},
  FileManageRestService in 'FileManageRestService.pas' {srvFileManageRestService: TkbmMWCustomSmartService},
  uOpenPlatformServerManager in 'uOpenPlatformServerManager.pas',
  ServerMainForm in 'ServerMainForm.pas' {frmServerMain},
  TableCommonRestService in 'TableCommonRestService.pas',
  WebFileHttpService in 'WebFileHttpService.pas',
  RagCenterRestService in 'RagCenterRestService.pas',
  DocumentReader in 'Core\DocumentReader.pas',
  uDocSplit in 'Core\uDocSplit.pas',
  TextSplitter in 'Core\TextSplitter.pas',
  TokenTextSplitter in 'Core\TokenTextSplitter.pas',
  NativePDFDocumentReader in 'Core\NativePDFDocumentReader.pas',
  ServerDataBaseModule in 'Core\ServerDataBaseModule.pas',
  uTableCommonRestCenter in 'Core\uTableCommonRestCenter.pas',
  RagServer in 'Core\RagServer.pas',
  UploadFile in 'Core\UploadFile.pas',
  FileIndyHttpServerModule in 'Core\FileIndyHttpServerModule.pas',
  uGenerateThumb in 'Core\uGenerateThumb.pas',
  uDatasetCollectionProcessTask in 'Core\uDatasetCollectionProcessTask.pas',
  uDataEmbeddingProcessTask in 'Core\uDataEmbeddingProcessTask.pas',
  VectorStore in 'Core\VectorStore.pas',
  PostgreSqlVectorStore in 'Core\PostgreSqlVectorStore.pas';

{$R *.res}


var
  //服务端端口号
  AConfigFileName:String;
begin

//  GlobalDataBaseCharset:='utf8';
//  GlobalDataBaseCharset:='utf8mb4';

  //默认服务的标题
  GlobalServiceProject.Name:='开放平台';
  GlobalServiceProject.IsNeedLoadAppList:=True;


  GlobalServiceProject.IsEnableRestAPICheckAccessToken:=True;
//  GlobalServiceProject.IsEnableRestAPICheckAccessToken:=False;


  //获取命令行的参数
  //第一个参数为服务端端口号
  AConfigFileName:='';
  if ParamCount > 0 then
  begin
    AConfigFileName:=ParamStr(1);

    if FileExists(GetApplicationPath+AConfigFileName) then
    begin

      GlobalServiceProject.FConfigFileName:=AConfigFileName;

    end;

  end;





  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  //  Application.CreateForm(TdmFileIndyHttpServer, dmFileIndyHttpServer);
//  Application.CreateForm(TdmImageIndyHttpServer, dmImageIndyHttpServer);
//  Application.CreateForm(TdmImageIndyHttpServer, dmImageIndyHttpServer);
//  Application.CreateForm(TdmWxpayIndyHttpServer, dmWxpayIndyHttpServer);
//  Application.CreateForm(TdmAlipayIndyHttpServer, dmAlipayIndyHttpServer);
  Application.CreateForm(TfrmServerMain, frmServerMain);
  //指定配置文件,里面有端口号、服务名称、AppID这些



  Application.Run;
end.
