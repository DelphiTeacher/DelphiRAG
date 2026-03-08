unit UserInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  IOUtils,
  IdURI,
  uAPPCommon,

//  {$IFDEF HAS_WXPAY}
//  uWeiChat,
//  {$ENDIF HAS_WXPAY}
//
//
//  {$IFDEF HAS_ALIPAY}
//  uAlipayMobilePay,
//  {$ENDIF HAS_ALIPAY}
//
//  {$IFDEF HAS_APPLESIGNIN}
//  uAppleSignIn,
//  {$ENDIF HAS_APPLESIGNIN}

  uBaseLog,
  uLang,

  uSkinMaterial,
  uOpenClientCommon,
  uOpenCommon,
  uFrameContext,
  uOpenUISetting,
  uUIFunction,
  uFuncCommon,
  WaitingFrame,
  HintFrame,
  MessageBoxFrame,
  uBaseThirdPartyAccountAuth,
  uThirdPartyAccountAuth,

  uManager,
  uDrawCanvas,
  uSkinItems,
  uTimerTask,
//  uOpenCommon,
  {$IFDEF FPC}
  uSkinSuperObject,
  {$ELSE}
    {$IF CompilerVersion <= 21.0} // XE or older
    SuperObject,
    superobjecthelper,
    {$ELSE}
      {$IFDEF SKIN_SUPEROBJECT}
      uSkinSuperObject,
      {$ELSE}
      XSuperObject,
      XSuperJson,
      {$ENDIF}
    {$IFEND}
  {$ENDIF}
  uRestInterfaceCall,
  uBaseHttpControl,
//  ApplyIntroducerFrame,
  EasyServiceCommonMaterialDataMoudle,

  uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinFireMonkeyButton, uSkinFireMonkeyImage,
  uDrawPicture, uSkinImageList, uSkinImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinButtonType, uBaseSkinControl,
  uSkinPanelType, FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList,
  FMX.StdActns, FMX.DateTimeCtrls, uSkinFireMonkeyDateEdit, FMX.MediaLibrary;

type

  TFrameUserInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbUserInfo: TSkinFMXListBox;
    idpDefault: TSkinFMXItemDesignerPanel;
    lblItemName: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    btnReturn: TSkinFMXButton;
    imgLookInfo: TSkinFMXImage;
    idpHead: TSkinFMXItemDesignerPanel;
    lblUserHead: TSkinFMXLabel;
    imgHead: TSkinFMXImage;
    idpType: TSkinFMXItemDesignerPanel;
    lblBinding: TSkinFMXLabel;
    idpName: TSkinFMXItemDesignerPanel;
    imgPicture: TSkinFMXImage;
    lblName: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    ActionList1: TActionList;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    imgSex: TSkinFMXImage;
    ImgListSex: TSkinImageList;
    DateBirth: TSkinFMXDateEdit;
    procedure btnReturnClick(Sender: TObject);
    procedure lbUserInfoPrepareDrawItem2(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRectF);
    procedure lbUserInfoClickItem(AItem: TSkinItem);
    procedure DateBirthChange(Sender: TObject);
    procedure lbUserInfoPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
  private
    //用户头像
    FUserHead:String;
    //获取用户接口
    procedure DoGetUserExecute(ATimerTask:TObject);
    procedure DoGetUserExecuteEnd(ATimerTask:TObject);
//  private
//    //解除绑定接口
//    procedure DoUnBindPhoneExecute(ATimerTask:TObject);
//    procedure DoUnBindPhoneExecuteEnd(ATimerTask:TObject);
  private
    //用户修改信息
    procedure UserChangeInfoExecute(ATimerTask:TObject);
    procedure UserChangeInfoExecuteEnd(ATimerTask:TObject);

    //上传头像
    procedure DoUpLoadUserHeaderExecute(ATimerTask:TObject);
    procedure DoUpLoadUserHeaderExecuteEnd(ATimerTask:TObject);


  private
    FHeadPic:String;
    FBitmap:TBitmap;

    procedure DoEditSexFromMenu(Sender: TObject;Asex:string);
    //从修改性别
    procedure OnReturnFromUpdateSex(AFrame:TFrame);

    procedure DoEditPictureFromMenu(Sender: TObject;ABitmap:TBitmap);

    //从裁剪照片返回
    procedure DoReturnFrameFromClipAddHeadFrame(Frame: TFrame);
    //从修改昵称返回
    procedure OnReturnFromUpdateNameFrame(AFrame:TFrame);
    //从修改个性签名返回
    procedure OnReturnFromUpdateSignFrame(AFrame:TFrame);

    procedure DoReturnFrameFromBindPhoneNumberFrame(AFrame:TFrame);

    procedure DoReturnFrameFromChangePhoneNumberFrame(AFrame:TFrame);

    procedure DoBindThirdPartyAccountChange(Sender:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    FUser:TUser;

    //当前使用此页面的软件名称
    FAppName:string;

    procedure Clear;

    //加载用户信息
    procedure Load(AUser:TUser);

    //更新用户信息
    procedure Sync;

    //隐藏菜单
    procedure HideMenu;

    { Public declarations }
  end;



var
  GlobalIsUserInfoChanged:Boolean;
  GlobalUserInfoFrame:TFrameUserInfo;


implementation

uses
  MainForm,
  MainFrame,
  LoginFrame,
  UpdateNameFrame,
  PopupMenuFrame,
  SexFrame,
//  AuditFrame,
//  HotelListFrame,
//  OrderListFrame,
//  LookCertificationInfoFrame,
//  CertificateUserInfoFrame,
  BindPhoneNumberFrame,
  ChangePhoneNumberFrame,
  TakePictureMenuFrame,
  ClipHeadFrame;
//  SettingAuthorityFrame,
//  AddUserFrame;


{$R *.fmx}



procedure TFrameUserInfo.Clear;
var
  I: Integer;
begin
  for I := 0 to Self.lbUserInfo.Prop.Items.Count-1 do
  begin
    if Self.lbUserInfo.Prop.Items[I].Caption<>Trans('头像') then
    begin
      Self.lbUserInfo.Prop.Items[I].Detail:='';
    end
    else
    begin
      Self.lbUserInfo.Prop.Items[I].Icon.ImageIndex:=-1;
    end;
  end;
end;

constructor TFrameUserInfo.Create(AOwner: TComponent);
begin
  inherited;

  Self.FAppName:= '';

  if Self.lbUserInfo.Prop.Items.FindItemByName('weichat')<>nil then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('weichat').Visible:=
      GlobalIsEnabledWeichatLogin;
  end;


  if Self.lbUserInfo.Prop.Items.FindItemByName('alipay')<>nil then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('alipay').Visible:=
      GlobalIsEnabledAlipayLogin;
  end;

  if Self.lbUserInfo.Prop.Items.FindItemByName('apple')<>nil then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('apple').Visible:=
      GlobalIsEnabledAppleLogin;
  end;

  if Self.lbUserInfo.Prop.Items.FindItemByName('facebook')<>nil then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('facebook').Visible:=
      GlobalIsEnabledFacebookLogin;
  end;

  if Self.lbUserInfo.Prop.Items.FindItemByName('twitter')<>nil then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('twitter').Visible:=
      GlobalIsEnabledTwitterLogin;
  end;



  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

procedure TFrameUserInfo.DateBirthChange(Sender: TObject);
begin
  Self.lbUserInfo.Prop.Items.FindItemByName('birth').Detail:=FormatDateTime('yyyy-mm-dd',DateBirth.Date);
  GlobalManager.User.Json.S['birth']:=Self.lbUserInfo.Prop.Items.FindItemByName('birth').Detail;
  //修改我的信息
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                  UserChangeInfoExecute,
                  UserChangeInfoExecuteEnd,
                  'UserChangeInfo');
end;

destructor TFrameUserInfo.Destroy;
begin
  inherited;
end;

procedure TFrameUserInfo.DoBindThirdPartyAccountChange(Sender: TObject);
begin
  Sync;
end;

procedure TFrameUserInfo.DoEditPictureFromMenu(Sender: TObject;
  ABitmap: TBitmap);
begin

  //头像裁剪成正方形
  HideFrame;//(Self,hfcttBeforeShowframe);
  ShowFrame(TFrame(GlobalClipHeadFrame),TFrameClipHead,Application.MainForm,nil,nil,DoReturnFrameFromClipAddHeadFrame,Application);
  GlobalClipHeadFrame.Init(ABitmap,200,200);

end;

procedure TFrameUserInfo.DoEditSexFromMenu(Sender: TObject;Asex:string);
begin
  // 性别
  if Asex='男' then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('sex').Detail:='男';
    imgSex.Prop.Picture.ImageIndex:=0;
    GlobalManager.User.sex:=0 ;
  end else
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('sex').Detail:='女';
    imgSex.Prop.Picture.ImageIndex:=1;
     GlobalManager.User.sex:=1;
  end;
  //修改我的信息
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                  UserChangeInfoExecute,
                  UserChangeInfoExecuteEnd,
                  'UserChangeInfo');
end;

procedure TFrameUserInfo.DoGetUserExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
          SimpleCallAPI('get_my_info',
                        nil,
                        UserCenterInterfaceUrl,
                        [
                        'appid',
                        'user_fid',
                        'key'
                        ],
                        [AppID,
                        GlobalManager.User.fid,
                        GlobalManager.User.key
                        ],
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
end;

procedure TFrameUserInfo.DoGetUserExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取用户信息成功

        //刷新用户信息
        FUser.ParseFromJson(ASuperObject.O['Data'].A['User'].O[0]);

        Load(FUser);

        frmMain.MyInfoChange;
      end
      else
      begin
        //注册失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

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

procedure TFrameUserInfo.DoReturnFrameFromBindPhoneNumberFrame(AFrame: TFrame);
begin
  Sync;
end;

procedure TFrameUserInfo.DoReturnFrameFromChangePhoneNumberFrame(AFrame: TFrame);
begin
  Sync;
end;

procedure TFrameUserInfo.DoReturnFrameFromClipAddHeadFrame(Frame: TFrame);
var
  ABitmap:TBitmap;
  AHeadPic:String;
  ABitmapCodecSaveParams:TBitmapCodecSaveParams; 
begin

  FBitmap:=GlobalClipHeadFrame.GetClipBitmap;

  Self.lbUserInfo.Prop.Items.FindItemByName('head').Icon.ImageIndex:=-1;
  Self.lbUserInfo.Prop.Items.FindItemByName('head').Icon.Url:='';


  //上传图片
  FHeadPic:=CreateGUIDString+'.jpg';
  ABitmapCodecSaveParams.Quality:=70;


  FBitmap.SaveToFile(
                     //保存到目录文档
                     System.IOUtils.TPath.GetDocumentsPath+PathDelim+FHeadPic,
                     @ABitmapCodecSaveParams);

  ShowWaitingFrame(Self,Trans('上传中...'));
  //上传头像
  uTimerTask.GetGlobalTimerThread.RunTempTask(
              DoUpLoadUserHeaderExecute,
              DoUpLoadUserHeaderExecuteEnd,
              'UpLoadUserHeader');

end;

//procedure TFrameUserInfo.DoUnBindPhoneExecute(ATimerTask: TObject);
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//  try
//    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('unbind_phone',
//                                                  nil,
//                                                  InterfaceUrl,
//                                                  [
//                                                  'appid',
//                                                  'emp_fid',
//                                                  'user_fid',
//                                                  'key'
//                                                  ],
//                                                  [AppID,
//                                                  GlobalManager.User.fid,
//                                                  FUser.fid,
//                                                  GlobalManager.User.key
//                                                  ],
//                                        GlobalRestAPISignType,
//                                        GlobalRestAPIAppSecret
//                                                  );
//
//    if TTimerTask(ATimerTask).TaskDesc<>'' then
//    begin
//      TTimerTask(ATimerTask).TaskTag:=0;
//    end;
//
//  except
//    on E:Exception do
//    begin
//      //异常
//      TTimerTask(ATimerTask).TaskDesc:=E.Message;
//    end;
//  end;
//end;
//
//procedure TFrameUserInfo.DoUnBindPhoneExecuteEnd(ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//begin
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//        //刷新
//        Sync;
//        //解除手机绑定成功
//        ShowMessageBoxFrame(Self,'解除手机绑定成功','',TMsgDlgType.mtInformation,['确定'],nil);
//      end
//      else
//      begin
//        //解绑失败
//        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
//      end;
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    HideWaitingFrame;
//    Self.lbUserInfo.Prop.StopPullDownRefresh();
//  end;
//end;

procedure TFrameUserInfo.DoUpLoadUserHeaderExecute(ATimerTask: TObject);
var
  AHttpControl:THttpControl;
  AResponseStream:TStringStream;
  AUserPicStream:TMemoryStream;
  ASuperObject:ISuperObject;
begin

  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try

    try
      AHttpControl:=TSystemHttpControl.Create;

      AResponseStream:=TStringStream.Create('',TEncoding.UTF8);

      AUserPicStream:=TMemoryStream.Create;
      AUserPicStream.LoadFromFile(System.IOUtils.TPath.GetDocumentsPath+PathDelim+FHeadPic);

      if  AHttpControl.Post(
                            TIdURI.URLEncode(
                            ImageHttpServerUrl
                            +'/upload'
                              +'?appid='+(AppID)
                              +'&filename='+FHeadPic
                              +'&filedir='+'userhead_Pic'
                              +'&fileext='+'.png'),
                            //图片文件
                            AUserPicStream,
                            //返回数据流
                            AResponseStream
                            ) then
                  begin
                    AResponseStream.Position:=0;
                    TTimerTask(ATimerTask).TaskDesc:=AResponseStream.DataString;

//                    CopyBitmap(ABitmap,Self.lbUserInfo.Prop.Items.FindItemByName('head').Icon);

                 end
                 else
                 begin
                  TTimerTask(ATimerTask).TaskTag:=2;
                  //上传失败
                  ShowMessageBoxFrame(Self,'头像上传失败!','',TMsgDlgType.mtInformation,['确定'],nil);
                  Exit;

                 end;
        
    finally
      FreeAndNil(AUserPicStream);
      FreeAndNil(AResponseStream);  
      FreeAndNil(AHttpControl);
    end;


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


end;

procedure TFrameUserInfo.DoUpLoadUserHeaderExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
          //上传成功
          FUserHead:=ASuperObject.O['Data'].S['RemoteFilePath'];

          //修改我的信息
          uTimerTask.GetGlobalTimerThread.RunTempTask(
                          UserChangeInfoExecute,
                          UserChangeInfoExecuteEnd,
                          'UserChangeInfo');
      end
      else
      begin
        //调用失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

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

procedure TFrameUserInfo.HideMenu;
var
  I:Integer;
begin

  //如果是急救达人，就隐藏个性签名
  if Self.FAppName = 'firstaid' then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByCaption('个性签名').Visible:= False;
  end;

end;

procedure TFrameUserInfo.lbUserInfoClickItem(AItem: TSkinItem);
begin
  if AItem.ItemType=sitItem1 then
  begin
      ShowFrame(TFrame(GlobalTakePictureMenuFrame),TFrameTakePictureMenu,frmMain,nil,nil,nil,Application,True,False,ufsefNone);
//      GlobalTakePictureMenuFrame.FrameHistroy:=CurrentFrameHistroy;
      GlobalTakePictureMenuFrame.OnTakedPicture:=DoEditPictureFromMenu;
      GlobalTakePictureMenuFrame.ShowMenu;
  end;

  if AItem.Name='sex' then
  begin
    ShowFrame(TFrame(GlobalSexMenuFrame),TFrameSex,frmMain,nil,nil,OnReturnFromUpdateSex,Application,True,False,ufsefNone);
    GlobalSexMenuFrame.OnTakedSex:=DoEditSexFromMenu;
    GlobalSexMenuFrame.ShowMenu;
  end;

  if AItem.Name='name' then
  begin
      HideFrame;
      ShowFrame(TFrame(GlobalUpdateNameFrame),TFrameUpDateName,OnReturnFromUpdateNameFrame);
      //修改
      GlobalUpdateNameFrame.FAppName:= Self.FAppName;
      GlobalUpdateNameFrame.EditName(True,AItem.Caption,AItem.Detail);
  end;

  if AItem.Name='birth' then
  begin
    DateBirth.OpenPicker;
  end;

  if AItem.Name='sign' then
  begin
      HideFrame;
      ShowFrame(TFrame(GlobalUpdateNameFrame),TFrameUpDateName,OnReturnFromUpdateSignFrame);
      if AItem.Detail<>'' then
        //修改
        GlobalUpdateNameFrame.AddSign(True,AItem.Caption,AItem.Detail)
      else
        GlobalUpdateNameFrame.AddSign(false,AItem.Caption,AItem.Detail);
  end;

  if AItem.name='weichat' then
  begin
//      {$IFDEF HAS_WXPAY}
      if AItem.Detail=Trans('未绑定') then
      begin
        GlobalUserBindThirdPartyAccount.OnChange:=DoBindThirdPartyAccountChange;
        GlobalUserBindThirdPartyAccount.WeiChatAction(tpaatBind);//'binding');
      end;
//      else if AItem.Detail='已绑定' then
//      begin
//        ShowMessageBoxFrame(Self,'您确定要解除绑定吗？','',TMsgDlgType.mtInformation,['确定','取消'],OnModalResultFromCancelBindingWeixin);
//      end;
//      {$ENDIF HAS_WXPAY}
  end;

  if AItem.name='alipay' then
  begin
//      {$IFDEF HAS_ALIPAY}
      if AItem.Detail=Trans('未绑定') then
      begin
        GlobalUserBindThirdPartyAccount.OnChange:=DoBindThirdPartyAccountChange;
        GlobalUserBindThirdPartyAccount.AlipayAction(tpaatBind);//'binding');
      end;
//      else if AItem.Detail='已绑定' then
//      begin
//        ShowMessageBoxFrame(Self,'您确定要解除绑定吗？','',TMsgDlgType.mtInformation,['确定','取消'],OnModalResultFromCancelBindingAlipay);
//      end;
//      {$ENDIF HAS_ALIPAY}
  end;

  if AItem.name='apple' then
  begin
//      {$IFDEF HAS_APPLESIGNIN}
      if AItem.Detail=Trans('未绑定') then
      begin
        GlobalUserBindThirdPartyAccount.OnChange:=DoBindThirdPartyAccountChange;
        GlobalUserBindThirdPartyAccount.AppleAction(tpaatBind);//'binding');
      end;
//      else if AItem.Detail='已绑定' then
//      begin
//        ShowMessageBoxFrame(Self,'您确定要解除绑定吗？','',TMsgDlgType.mtInformation,['确定','取消'],OnModalResultFromCancelBindingAlipay);
//      end;
//      {$ENDIF HAS_APPLESIGNIN}
  end;

  if AItem.name='facebook' then
  begin
//      {$IFDEF HAS_APPLESIGNIN}
      if AItem.Detail=Trans('未绑定') then
      begin
        GlobalUserBindThirdPartyAccount.OnChange:=DoBindThirdPartyAccountChange;
        GlobalUserBindThirdPartyAccount.FacebookAction(tpaatBind);//'binding');
      end;
//      else if AItem.Detail='已绑定' then
//      begin
//        ShowMessageBoxFrame(Self,'您确定要解除绑定吗？','',TMsgDlgType.mtInformation,['确定','取消'],OnModalResultFromCancelBindingAlipay);
//      end;
//      {$ENDIF HAS_APPLESIGNIN}
  end;

  if AItem.name='twitter' then
  begin
//      {$IFDEF HAS_APPLESIGNIN}
      if AItem.Detail=Trans('未绑定') then
      begin
        GlobalUserBindThirdPartyAccount.OnChange:=DoBindThirdPartyAccountChange;
//        GlobalUserBindThirdPartyAccount.TwitterAction(tpaatBind);//'binding');
      end;
//      else if AItem.Detail='已绑定' then
//      begin
//        ShowMessageBoxFrame(Self,'您确定要解除绑定吗？','',TMsgDlgType.mtInformation,['确定','取消'],OnModalResultFromCancelBindingAlipay);
//      end;
//      {$ENDIF HAS_APPLESIGNIN}
  end;


  if AItem.name='phone' then
  begin
      if (AItem.Detail='') or (AItem.Detail=Trans('未绑定')) then
      begin
        //当前没有手机号
        //绑定手机号
        HideFrame;//();
        ShowFrame(TFrame(GlobalBindPhoneNumberFrame),TFrameBindPhoneNumber,DoReturnFrameFromBindPhoneNumberFrame);
        GlobalBindPhoneNumberFrame.Clear;
        GlobalBindPhoneNumberFrame.btnReturn.Visible:=True;
      end
      else
      begin
//        //更换手机号
//        HideFrame;//();
//        ShowFrame(TFrame(GlobalChangePhoneNumberFrame),TFrameChangePhoneNumber,DoReturnFrameFromChangePhoneNumberFrame);
      end;
  end;


  if AItem.Caption=Trans('实名认证') then
  begin
  //    if (GlobalManager.User.cert_audit_state=0)
  //      or (GlobalManager.User.cert_audit_state=2) then
  //    begin
  //      //隐藏
  //      HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  //      //显示实名认证提交界面
  //      ShowFrame(TFrame(GlobalCertificateUserInfoFrame),TFrameCertificateUserInfo,frmMain,nil,nil,nil,Application);
  //
  //      if GlobalManager.User.cert_audit_state=0 then
  //      begin
  //        GlobalCertificateUserInfoFrame.Clear;
  //      end;
  //    end
  //    else
  //    begin
  //       //隐藏
  //      HideFrame;//(Self,hfcttBeforeShowFrame);
  //      //显示实名认证查看界面
  //      ShowFrame(TFrame(GlobalLookCertificationInfoFrame),TFrameLookCertificationInfo,frmMain,nil,nil,nil,Application);
  //      GlobalLookCertificationInfoFrame.Load(FUser);
  //    end;

  end;

end;


procedure TFrameUserInfo.lbUserInfoPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
//  if (AItem.ItemType=sitItem3)
//      //and (AItem.Caption<>'手机')
//      and (AItem.Detail=Trans('未绑定')) then
//  begin
//    Self.lblDetail.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;
//  end
//  else
//  begin
//    Self.lblDetail.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
//  end;
//
//  if (AItem.ItemType=sitDefault) and (AItem.Caption<>'账号') then
//  begin
//    Self.lblItemDetail.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;
//  end
//  else
//  begin
//    Self.lblItemDetail.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
//  end;

  if AItem.Name='phone' then
  begin
    if (AItem.Detail=Trans('未绑定')) then
    begin
      AItem.Accessory:=satMore;
    end else
    begin
      AItem.Accessory:=satNone;
    end;
  end;
  if AItem.Name='sex' then
  begin
    imgSex.Visible:=True;
  end else
  begin
    imgSex.Visible:=False;
  end;

end;

procedure TFrameUserInfo.lbUserInfoPrepareDrawItem2(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRectF);
begin
//  if (AItem.ItemType=sitItem3)
//      //and (AItem.Caption<>'手机')
//      and (AItem.Detail=Trans('未绑定')) then
//  begin
//    Self.lblDetail.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;
//  end
//  else
//  begin
//    Self.lblDetail.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
//  end;
//
//  if (AItem.ItemType=sitDefault) and (AItem.Caption<>'账号') then
//  begin
//    Self.lblItemDetail.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;
//  end
//  else
//  begin
//    Self.lblItemDetail.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
//  end;

  if AItem.Name='phone' then
  begin
    if (AItem.Detail=Trans('未绑定')) then
    begin
      AItem.Accessory:=satMore;
    end else
    begin
      AItem.Accessory:=satNone;
    end;
  end;
  if AItem.Name='sex' then
  begin
    imgSex.Visible:=True;
  end else
  begin
    imgSex.Visible:=False;
  end;
end;

procedure TFrameUserInfo.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then Exit;

  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameUserInfo.Load(AUser:TUser);
begin
  Clear;

  FUser:=AUser;

  Self.lbUserInfo.Prop.Items.FindItemByName('head').Icon.ImageIndex:=-1;

  Self.lbUserInfo.Prop.Items.FindItemByName('head').Icon.IsClipRound:=True;

  Self.lbUserInfo.Prop.Items.FindItemByName('head').Icon.Url:=AUser.GetHeadPicUrl;
  Self.lbUserInfo.Prop.Items.FindItemByName('head').Icon.PictureDrawType:=TPictureDrawType.pdtAuto;




  FUserHead:=AUser.GetHeadPicUrl;


  //昵称
  Self.lbUserInfo.Prop.Items.FindItemByName('name').Detail:=AUser.name;


  Self.lbUserInfo.Prop.Items.FindItemByName('phone').Detail:=AUser.phone;
  {$IFDEF NZ}
  //新西兰的不需要手机
  Self.lbUserInfo.Prop.Items.FindItemByName('phone').Visible:=False;
  {$ELSE}
  //国内需要手机
  Self.lbUserInfo.Prop.Items.FindItemByName('phone').Visible:=True;
  {$ENDIF}
  if (AUser.phone='') then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('phone').Detail:=Trans('未绑定');
//  end
//  else
//  begin
//    Self.lbUserInfo.Prop.Items.FindItemByName('phone').Detail:=Trans('已绑定');
  end;



  //聊天ID
  Self.lbUserInfo.Prop.Items.FindItemByName('fastmsg_user_id').Visible:=(AUser.fastmsg_user_id<>0);
  Self.lbUserInfo.Prop.Items.FindItemByName('fastmsg_user_id').Detail:=IntToStr(AUser.fastmsg_user_id);



  //性别
  if AUser.sex=1 then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('sex').Detail:='男';
    imgSex.Prop.Picture.ImageIndex:=0;
  end else
  if AUser.sex=2 then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('sex').Detail:='男';
    imgSex.Prop.Picture.ImageIndex:=0;
  end else
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('sex').Detail:='未知';
    imgSex.Prop.Picture.ImageIndex:=-1;
  end;


  //生日
  Self.lbUserInfo.Prop.Items.FindItemByName('birth').Detail:=Copy(AUser.Json.s['birth'],0,10);
  Self.lbUserInfo.Prop.Items.FindItemByName('sign').Detail:=AUser.Json.s['sign'];

  //注册日期
  Self.lbUserInfo.Prop.Items.FindItemByName('create_time').Detail:=AUser.createtime;

  Self.lbUserInfo.Prop.Items.FindItemByName('email').Detail:=AUser.email;
  {$IFDEF NZ}
  //新西兰的需要邮箱
  Self.lbUserInfo.Prop.Items.FindItemByName('email').Visible:=True;
  {$ELSE}
  //国内的不需要邮箱
  Self.lbUserInfo.Prop.Items.FindItemByName('email').Visible:=False;
  {$ENDIF}





//  if (AUser.phone='') or (AUser.wx_open_id='') then
  if (AUser.wx_open_id='') then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('weichat').Detail:=Trans('未绑定');
  end
  else
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('weichat').Detail:=Trans('已绑定');
  end;




  if (AUser.alipay_open_id='') then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('alipay').Detail:=Trans('未绑定');
  end
  else
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('alipay').Detail:=Trans('已绑定');
  end;



  if (AUser.apple_open_id='') then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('apple').Detail:=Trans('未绑定');
  end
  else
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('apple').Detail:=Trans('已绑定');
  end;


  if (AUser.fb_open_id='') then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('facebook').Detail:=Trans('未绑定');
  end
  else
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('facebook').Detail:=Trans('已绑定');
  end;


  if (AUser.tw_open_id='') then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('twitter').Detail:=Trans('未绑定');
  end
  else
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('twitter').Detail:=Trans('已绑定');
  end;




  if AUser.cert_audit_state=Ord(asDefault) then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('certification').Detail:=Trans('未实名');
  end
  else if AUser.cert_audit_state=Ord(asAuditReject) then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('certification').Detail:=Trans('已拒绝');
  end
  else if AUser.cert_audit_state=Ord(asAuditPass) then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('certification').Detail:=Trans('已实名');
  end
  else if AUser.cert_audit_state=Ord(asRequestAudit) then
  begin
    Self.lbUserInfo.Prop.Items.FindItemByName('certification').Detail:=Trans('待审核');
  end;



//  if AUser.password<>'' then
//  begin
//    Self.lbUserInfo.Prop.Items.FindItemByCaption('登录密码').Detail:=Trans('已设置');
//  end
//  else
//  begin
//    Self.lbUserInfo.Prop.Items.FindItemByCaption('登录密码').Detail:=Trans('未设置');
//  end;
//


//  Self.lbUserInfo.Prop.Items.FindItemByCaption('支付密码').Detail:=Trans('未设置');
//
//  Self.lbUserInfo.Prop.Items.FindItemByCaption('小额免密码支付').Detail:=Trans('未设置');


end;

procedure TFrameUserInfo.OnReturnFromUpdateNameFrame(AFrame: TFrame);
begin
  Self.lbUserInfo.Prop.Items.FindItemByName('name').Detail:=GlobalUpdateNameFrame.FFilterText;
end;

procedure TFrameUserInfo.OnReturnFromUpdateSex(AFrame: TFrame);
begin
  Sync;
end;

procedure TFrameUserInfo.OnReturnFromUpdateSignFrame(AFrame: TFrame);
begin
  Self.lbUserInfo.Prop.Items.FindItemByName('sign').Detail:=GlobalUpdateNameFrame.FSignText;
end;

procedure TFrameUserInfo.Sync;
begin
  ShowWaitingFrame(Self,Trans('加载中...'));

  //刷新
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                               DoGetUserExecute,
                               DoGetUserExecuteEnd,
                               'GetUser');
end;

procedure TFrameUserInfo.UserChangeInfoExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try

    TTimerTask(ATimerTask).TaskDesc:=
              SimpleCallAPI('update_my_info',
                              nil,
                              UserCenterInterfaceUrl,
                              ['appid',
                              'user_fid',
                              'key',
                              'head_img',
                              'name',
                              'user_sign',
                              'birth',
                              'sex',
                              'second_contactor_name',
                              'second_contactor_phone'],
                              [AppID,
                              GlobalManager.User.fid,
                              GlobalManager.User.key,
                              Self.FUserHead,
                              GlobalManager.User.name,
                              GlobalManager.User.Json.S['sign'],
                              GlobalManager.User.Json.S['birth'],
                              GlobalManager.User.sex,
                              GlobalManager.User.second_contactor_name,
                              GlobalManager.User.second_contactor_phone],
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
end;

procedure TFrameUserInfo.UserChangeInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
          //修改信息成功
          FUser.ParseFromJson(ASuperObject.O['Data'].A['User'].O[0]);
          Self.Load(FUser);

          frmMain.MyInfoChange;

      end
      else
      begin
        //调用失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

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




end.

