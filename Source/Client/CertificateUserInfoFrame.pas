unit CertificateUserInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  System.IOUtils,

  uComponentType,
  uOpenClientCommon,
  EasyServiceCommonMaterialDataMoudle,
  uRestInterfaceCall,
  uBaseHttpControl,
  IdURI,

  uUIFunction,
  uFrameContext,
  uFuncCommon,
  uOpenCommon,
//  uCommonUtils,
  uTimerTask,
  uManager,
//  uOpenClientCommon,
  XSuperObject,
  XSuperJson,

  PopupMenuFrame,
  TakePictureMenuFrame,
  LookCertificationInfoFrame,

  WaitingFrame,
  MessageBoxFrame,
//  ClipHeadFrame,

  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyCheckBox, uSkinFireMonkeyLabel, FMX.Controls.Presentation,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyScrollBoxContent,
  uDrawPicture,
  uSkinImageList, uSkinFireMonkeyImage, uSkinImageType, uSkinButtonType,
  uSkinPanelType, uSkinScrollBoxContentType, uBaseSkinControl,
  uSkinScrollControlType, uSkinScrollBoxType, FMX.ListBox,
  uSkinFireMonkeyComboBox;

type
  TFrameCertificateUserInfo = class(TFrame)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlEmpty2: TSkinFMXPanel;
    pnlIDCode: TSkinFMXPanel;
    edtIDCode: TSkinFMXEdit;
    btnOK: TSkinFMXButton;
    pnlEmpty: TSkinFMXPanel;
    pnlCardFrontPic: TSkinFMXPanel;
    imgCardFrontPic: TSkinFMXImage;
    pnlEmpty3: TSkinFMXPanel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlEmpty5: TSkinFMXPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    btnSelect: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure imgCardFrontPicClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
  private
    FOperType:String;
    FID_FrontPicPath:String;
  public
    FID_type:Integer;
    FID_Code:String;
    FID_FrontPic:String;
  private
    procedure DoEditPictureFromMenu(Sender: TObject;ABitmap:TBitmap);

    procedure DoGetIDPicPathExecute(ATimerTask:TObject);
    procedure DoGetIDPicPathExecuteEnd(ATimerTask:TObject);

    //从提示框返回
    procedure OnReturnFromOkButton(Frame:TObject);

    //从选择的弹出框返回
    procedure DoMenuClickFromPopupMenuFrame(APopupMenuFrame: TFrame);

    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
  public
    FPageIndex:Integer;
    procedure Clear;
    procedure Load(AUserCertInfo:TUserCertInfo);
    { Public declarations }
  end;



var
  GlobalCertificateUserInfoFrame:TFrameCertificateUserInfo;

implementation

{$R *.fmx}

uses
  MainForm,
  MainFrame,
  LoginFrame;

procedure TFrameCertificateUserInfo.btnOKClick(Sender: TObject);
var
  ABitmapCodecSaveParams:TBitmapCodecSaveParams;
begin
  HideVirtualKeyboard;

  if Self.btnSelect.Caption='' then
  begin
    ShowMessageBoxFrame(Self,'请选择证件类型!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Self.edtIDCode.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入您的证件号!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

//  if ValidatePID(Self.edtIDCode.text)<>'' then
//  begin
//    ShowMessageBoxFrame(Self,'您输入的身份证号不合法!','',TMsgDlgType.mtInformation,['确定'],nil);
//    Exit;
//  end;

  if Self.imgCardFrontPic.Prop.Picture.Url='' then
  begin
    if  Self.imgCardFrontPic.Prop.Picture.IsEmpty then
    begin
      ShowMessageBoxFrame(Self,'请上传您的证件照片!','',TMsgDlgType.mtInformation,['确定'],nil);
      Exit;
    end;
  end;

  FID_Code:=Trim(Self.edtIDCode.Text);

  ABitmapCodecSaveParams.Quality:=70;

  FID_FrontPicPath:='';
  if (Self.imgCardFrontPic.Prop.Picture.Width>0)
  AND (Self.imgCardFrontPic.Prop.Picture.Height>0) then
  begin
    FID_FrontPicPath:=CreateGUIDString+'.jpg';

    Self.imgCardFrontPic.Prop.Picture.SaveToFile(
                      //保存到文档目录
                      System.IOUtils.TPath.GetDocumentsPath+PathDelim+FID_FrontPicPath,//E:\aa\222.jpg
                      @ABitmapCodecSaveParams
                      );
  end;

  ShowWaitingFrame(Self,'上传中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                     DoGetIDPicPathExecute,
                                     DoGetIDPicPathExecuteEnd,
                                     'GetIDPicPath');

end;

procedure TFrameCertificateUserInfo.Clear;
begin
  Self.btnSelect.Caption:='';
  Self.edtIDCode.Text:='';
  Self.imgCardFrontPic.Prop.Picture.SetSize(0,0);
end;

constructor TFrameCertificateUserInfo.Create(AOwner: TComponent);
begin
  inherited;


  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);


end;

procedure TFrameCertificateUserInfo.DoEditPictureFromMenu(Sender: TObject;ABitmap: TBitmap);
begin
  if FOperType='ID_FrontPic' then
  begin
    Self.imgCardFrontPic.Prop.Picture.Clear;
    Self.imgCardFrontPic.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtAuto;
    CopyBitmap(ABitmap,Self.imgCardFrontPic.Prop.Picture);
  end;

end;

procedure TFrameCertificateUserInfo.DoGetIDPicPathExecute(ATimerTask: TObject);
var
  AID_FrontPicStream:TMemoryStream;
  AID_BackPicStream:TMemoryStream;
  AID_WithManPicStream:TMemoryStream;
  AResponseStream:TStringStream;
  APicUpLoadSucc:Boolean;
  ASuperObject:ISuperObject;
  AHttpControl:THttpControl;
begin
  //先上传照片

  TTimerTask(ATimerTask).TaskTag:=1;

  AID_FrontPicStream:=TMemoryStream.Create;
  AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
  AHttpControl:=TSystemHttpControl.Create;

  if FID_FrontPicPath<>'' then
  begin
    AID_FrontPicStream.LoadFromFile(System.IOUtils.TPath.GetDocumentsPath+PathDelim+FID_FrontPicPath);
  end;

  try

    try
      if FID_FrontPicPath<>'' then
      begin
        if  AHttpControl.Post(
                              TIdURI.URLEncode(
                              ImageHttpServerUrl
                              +'/upload'
                                +'?appid='+(AppID)
                                +'&filename='+FID_FrontPicPath
                                +'&filedir='+'ID_Pic'
                                +'&fileext='+'.png'),
                              //图片文件
                              AID_FrontPicStream,
                              //返回数据流
                              AResponseStream
                              ) then
                    begin
                      AResponseStream.Position:=0;
                      ASuperObject:=TSuperObject.Create(AResponseStream.DataString);
                      FID_FrontPic:=ASuperObject.O['Data'].S['RemoteFilePath'];
                   end
                   else
                   begin
                    //上传失败
                     ShowMessage('身份证正面照片上传失败');
                   end;

      end;


        TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('complete_user_cert',
                      nil,
                      UserCenterInterfaceUrl,
                      ['appid',
                      'user_fid',
                      'id_type',
                      'id_code',
                      'id_front_picpath',
                      'id_back_picpath',
                      'id_withman_picpath',
                      'key'],
                      [AppID,
                      GlobalManager.User.fid,
                      FID_type,
                      FID_Code,
                      FID_FrontPic,
                      '',
                      '',
                      ''],
                                        GlobalRestAPISignType,
                                        GlobalRestAPIAppSecret
                      );

        if TTimerTask(ATimerTask).TaskDesc<>'' then
        begin
          TTimerTask(ATimerTask).TaskTag:=0;
        end;



    except
      on E:Exception do
      begin
        //异常
        TTimerTask(ATimerTask).TaskDesc:=E.Message;
      end;
    end;

  finally
    FreeAndNil(AID_FrontPicStream);
    FreeAndNil(AResponseStream);
    FreeAndNil(AHttpControl);
  end;

end;

procedure TFrameCertificateUserInfo.DoGetIDPicPathExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        ShowMessageBoxFrame(Self,'提交成功，请耐心等待审核!','',TMsgDlgType.mtInformation,['确定'],OnReturnFromOkButton);
      end
      else
      begin
        //调用失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=2 then
    begin
      //照片上传失败
      ShowMessageBoxFrame(Self,'照片上传失败!','',TMsgDlgType.mtInformation,['确定'],nil);
    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

procedure TFrameCertificateUserInfo.DoMenuClickFromPopupMenuFrame(
  APopupMenuFrame: TFrame);
begin
  if TFramePopupMenu(APopupMenuFrame).ModalResult='驾照' then
  begin
    Self.btnSelect.Caption:='驾照';
    Self.FID_type:=0;
  end;

  if TFramePopupMenu(APopupMenuFrame).ModalResult='护照' then
  begin
    Self.btnSelect.Caption:='护照';
    Self.FID_type:=1;
  end;

  if TFramePopupMenu(APopupMenuFrame).ModalResult='十八加卡' then
  begin
    Self.btnSelect.Caption:='十八加卡';
    Self.FID_type:=2;
  end;

  if TFramePopupMenu(APopupMenuFrame).ModalResult='身份证' then
  begin
    Self.btnSelect.Caption:='身份证';
    Self.FID_type:=3;
  end;

end;

procedure TFrameCertificateUserInfo.imgCardFrontPicClick(Sender: TObject);
begin
  //身份证正面照片
  FOperType:='ID_FrontPic';
  HideVirtualKeyboard;
  ShowFrame(TFrame(GlobalTakePictureMenuFrame),TFrameTakePictureMenu,frmMain,nil,nil,nil,Application,True,False,ufsefNone);
//  GlobalTakePictureMenuFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalTakePictureMenuFrame.OnTakedPicture:=DoEditPictureFromMenu;
  GlobalTakePictureMenuFrame.ShowMenu;
end;

procedure TFrameCertificateUserInfo.Load(AUserCertInfo:TUserCertInfo);
begin

  case AUserCertInfo.id_type of
    {$IFDEF NZ}
    0:Self.btnSelect.Caption:='驾照';
    1:Self.btnSelect.Caption:='护照';
    2:Self.btnSelect.Caption:='十八加卡';
    {$ENDIF}
    3:Self.btnSelect.Caption:='身份证';
  end;

  Self.edtIDCode.Text:=AUserCertInfo.id_code;

  Self.imgCardFrontPic.Prop.Picture.Url:=AUserCertInfo.GetIDFrontPicUrl;
  Self.imgCardFrontPic.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtUrl;

  Self.FID_type:=AUserCertInfo.id_type;
  Self.FID_Code:=AUserCertInfo.id_code;
  Self.FID_FrontPic:=AUserCertInfo.id_front_picpath;

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;

procedure TFrameCertificateUserInfo.OnReturnFromOkButton(Frame: TObject);
begin
  //实名认证之后返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
//  //重新获取骑手实名信息
//  GlobalMainFrame.tteGetRiderInfo.Run;
end;

procedure TFrameCertificateUserInfo.btnReturnClick(Sender: TObject);
begin
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

      HideFrame;//(Self,hfcttBeforeReturnFrame);
      ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameCertificateUserInfo.btnSelectClick(Sender: TObject);
begin
  ShowFrame(TFrame(GlobalPopupMenuFrame),TFramePopupMenu,frmMain,nil,nil,DoMenuClickFromPopupMenuFrame,Application,True,True,ufsefNone);
  GlobalPopupMenuFrame.Init('证件类型',[{$IFDEF NZ}'驾照','护照','十八加卡',{$ENDIF}'身份证']);
//  GlobalPopupMenuFrame.SetProp(1,200);
end;

end.


