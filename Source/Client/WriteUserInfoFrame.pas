unit WriteUserInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uOpenClientCommon,
  uOpenCommon,


  EasyServiceCommonMaterialDataMoudle,

  uManager,
//  uOpenClientCommon,
  uConst,
//  uOpenCommon,

  uFuncCommon,

  uUIFunction,
  uFrameContext,

  uTimerTask,
  uRestInterfaceCall,

  uThirdPartyAccountAuth,

    {$IFDEF SKIN_SUPEROBJECT}
    uSkinSuperObject,
    uSkinSuperJson,
    {$ELSE}
    XSuperObject,
    XSuperJson,
    {$ENDIF}

//  uGPSLocation,

  MessageBoxFrame,
  WaitingFrame,
  AddPictureListSubFrame,
  uAddPictureListSubFrame,

  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uBaseSkinControl, uSkinPanelType, uSkinFireMonkeyPanel,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinScrollBoxContentType, uSkinFireMonkeyScrollBoxContent,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinFireMonkeyScrollBox,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinCheckBoxType,
  uSkinFireMonkeyCheckBox;

type
  TFrameWriteUserInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    btnOK: TSkinFMXButton;
    pnlEmpty: TSkinFMXPanel;
    pnlSurePassward: TSkinFMXPanel;
    edtSurePassword: TSkinFMXEdit;
    pnlPassword: TSkinFMXPanel;
    edtPassword: TSkinFMXEdit;
    pnlUserName: TSkinFMXPanel;
    edtNickName: TSkinFMXEdit;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    pnlCode: TSkinFMXPanel;
    edtCode: TSkinFMXEdit;
    pnlPhone: TSkinFMXPanel;
    pnlEmail: TSkinFMXPanel;
    lblPhone: TSkinFMXLabel;
    lblEmail: TSkinFMXLabel;
    SkinFMXPanel3: TSkinFMXPanel;
    pnlRegisterProtocol: TSkinFMXPanel;
    lblProtocol: TSkinFMXLabel;
    chkAgree: TSkinFMXCheckBox;
    pnlHeader: TSkinFMXPanel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure lblProtocolClick(Sender: TObject);
  private
    //手机号码
    FPhone:String;
    //邮箱
    FEmail:String;
    //验证码
    FCaptcha:String;
    //名字
    FName:String;
    //密码
    FPassword:String;
    //邀请码
    FCode:String;
    //用户注册类型
    FLoginType:String;


//    FWxOpenID:String;
//    FWxAuthToken:String;
//
//
//    FAlipayOpenID:String;
//    FAlipayAuthToken:String;


    // 注册用户
    procedure DoRegisterUserExecute(ATimerTask: TObject);
    procedure DoRegisterUserExecuteEnd(ATimerTask: TObject);

  private
    //宠物头像
    FPetHeadPicFrame:TFrameAddPictureListSub;


    //注册成功
    procedure OnModalResultFromRegisterSucc(Frame: TObject);
    //是否放弃注册
    procedure OnModalResultBack(Frame :Tobject);
    { Private declarations }
  public
//    FrameHistroy: TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
  public
    //清除
    procedure Clear;

    //加载信息
    procedure Load(AEmail:String;
                   APhone:String;
                   ACaptcha:String;
                   ALoginType: String//;
//                   //三方平台的用户名
//                   AUserName:String;
//                   //三方平台的头像
//                   AUserHeadPicFilePath:String;
//                   AWxOpenID:String;
//                   AWxAuthToken:String;
//                   AAlipayOpenID:String;
//                   AAlipayAuthToken:String
                   );
    { Public declarations }
  end;



var
  GlobalWriteUserInfoFrame:TFrameWriteUserInfo;
  //是否显示注册协议
  GlobalIsShowRegisterProtocol:Boolean;

implementation

{$R *.fmx}

uses
  MainForm,
//  CertificateUserInfoFrame,
  {$IFDEF SHOP_APP}
  OpenShopFillInfoFrame,
  {$ENDIF}
  MainFrame,
  RegisterProtocolFrame;

procedure TFrameWriteUserInfo.btnOKClick(Sender: TObject);
begin
  if Self.edtNickName.Text='' then
  begin
    ShowMessageBoxFrame(Self, '请输入名称!', '', TMsgDlgType.mtInformation,
      ['确定'], nil);
    Exit;
  end;

  if Self.edtPassword.Text='' then
  begin
    ShowMessageBoxFrame(Self, '请输入密码!', '', TMsgDlgType.mtInformation,
      ['确定'], nil);
    Exit;
  end;

  if Self.edtSurePassword.Text='' then
  begin
    ShowMessageBoxFrame(Self, '请确认密码!', '', TMsgDlgType.mtInformation,
      ['确定'], nil);
    Exit;
  end;

  if Self.edtPassword.Text<>Self.edtSurePassword.Text then
  begin
    ShowMessageBoxFrame(Self, '两次密码不一致!', '', TMsgDlgType.mtInformation,
      ['确定'], nil);
    Exit;
  end;

  //需要阅读注册协议
  if (Self.pnlRegisterProtocol.Visible) AND (Not Self.chkAgree.Prop.Checked) then
  begin
    ShowMessageBoxFrame(Self, '请先阅读并同意注册协议!', '', TMsgDlgType.mtInformation,
      ['确定'], nil);
    Exit;
  end;



  Self.FName:=Self.edtNickName.Text;
  Self.FPassword:=Self.edtPassword.Text;
  Self.FCode:=Trim(Self.edtCode.Text);

  //先将图片保存到本地目录
  Self.FPetHeadPicFrame.SaveToLocalTemp(70,'.png');



  ShowWaitingFrame(Self, '注册中...');

  uTimerTask.GetGlobalTimerThread.RunTempTask(DoRegisterUserExecute,
                                          DoRegisterUserExecuteEnd,
                                          'RegisterUser');

end;

procedure TFrameWriteUserInfo.btnReturnClick(Sender: TObject);
begin
  ShowMessageBoxFrame(frmMain, '放弃注册?', '', TMsgDlgType.mtInformation,
              ['确定','取消'], OnModalResultBack);
  //返回
//  HideFrame;//(Self, hfcttBeforeReturnFrame);
//  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameWriteUserInfo.Clear;
begin
  Self.edtNickName.Text:='';

  Self.edtPassword.Text:='';
  Self.edtSurePassword.Text:='';

  Self.lblPhone.Caption:='';
  Self.lblEmail.Caption:='';

  //默认不勾选同意
  Self.chkAgree.Prop.Checked:=False;




  //宠物头像
  FPetHeadPicFrame.Init(
                        '',
                        [],
                        [],
                        True,//要裁剪
                        100,
                        100,
                        1     //最多1张
                        );



end;

constructor TFrameWriteUserInfo.Create(AOwner: TComponent);
begin
  inherited;
  FPetHeadPicFrame:=TFrameAddPictureListSub.Create(AOwner);
  //要设置Name,不然会报错
  SetFrameName(FPetHeadPicFrame);
//  FPetHeadPicFrame.Parent:=Self;//.pnlHeader;
//  FPetHeadPicFrame.Align:=TAlignLayout.Top;
  FPetHeadPicFrame.Parent:=Self.pnlHeader;
  FPetHeadPicFrame.Align:=TAlignLayout.HorzCenter;
  FPetHeadPicFrame.Width:=FPetHeadPicFrame.lvPictures.Prop.ItemWidth+8;
  FPetHeadPicFrame.pnlToolBar.Visible:=False;
  FPetHeadPicFrame.lvPictures.Align:=TAlignLayout.Client;
  FPetHeadPicFrame.lvPictures.Margins.Left:=0;


  Self.pnlHeader.Visible:=False;


  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  Self.pnlRegisterProtocol.Visible:=GlobalIsShowRegisterProtocol;

  Self.lblProtocol.Caption:='《'+Const_APPName+'注册协议》';
end;

procedure TFrameWriteUserInfo.DoRegisterUserExecute(ATimerTask: TObject);
var
  AServerResponse:String;
//  AServerFileName:String;
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try




    //上传宠物头像
    if not Self.FPetHeadPicFrame.Upload(
        ImageHttpServerUrl+'/upload'
                         +'?appid='+(AppID)
                         +'&filename='+'%s'
                         +'&filedir='+'userhead_pic'
                         +'&fileext='+'.png',
        AServerResponse) then
    begin
      TTimerTask(ATimerTask).TaskDesc:=AServerResponse;
      Exit;
    end;



    TTimerTask(ATimerTask).TaskDesc := SimpleCallAPI(
      'register_user',
      nil,
      UserCenterInterfaceUrl,
      ['appid',
      'user_type',
      'register_type',
      'email',
      'phone',
      'captcha',
      'name',
      'password',
      'invite_code',


      //注册的省市
      'province',
      'city',


      'head_pic_path',

      'wx_union_id',
      'wx_open_id',
      'wx_auth_token',

      'alipay_open_id',
      'alipay_auth_token',

      'third_party_username',
      'third_party_userhead'
      ],
      [AppID,
      APPUserType,
      FLoginType,
      FEmail,
      FPhone,
      FCaptcha,
      FName,
      FPassword,
      FCode,

      //注册的省市
      '',//GlobalGPSLocation.Province,
      '',//GlobalGPSLocation.City,


      FPetHeadPicFrame.GetServerFileName(0),//如果不存在,不会发生越界错误

      GlobalUserBindThirdPartyAccount.FWxUnionID,
      GlobalUserBindThirdPartyAccount.FWxOpenID,
      GlobalUserBindThirdPartyAccount.FWxAuthToken,

      GlobalUserBindThirdPartyAccount.FAlipayOpenID,
      GlobalUserBindThirdPartyAccount.FAlipayAuthToken,

      GlobalUserBindThirdPartyAccount.FUserName,
      GlobalUserBindThirdPartyAccount.FUserHeadUrl
      ],
                                        GlobalRestAPISignType,
                                        GlobalRestAPIAppSecret
                                        );

    if TTimerTask(ATimerTask).TaskDesc <> '' then
    begin
      TTimerTask(ATimerTask).TaskTag := 0;
    end;

  except
    on E: Exception do
    begin
      // 异常
      TTimerTask(ATimerTask).TaskDesc := E.Message;
    end;
  end;

end;

procedure TFrameWriteUserInfo.DoRegisterUserExecuteEnd(ATimerTask: TObject);
var
  ASuperObject: ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag = 0 then
    begin
      ASuperObject := TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code'] = 200 then
      begin





            //注册用户的接口返回格式改了
            GlobalManager.User.ParseFromJson(ASuperObject.O['Data']);

            //保存用户登录key,用于下次自动登陆
            GlobalManager.LastLoginKey:=ASuperObject.O['Data'].S['login_key'];

//            //登录状态
//            uManager.GlobalManager.IsLogin:=True;
//            //保存上次登陆的用户名密码
//            uManager.GlobalManager.Save;
//            //保存这次登录的用户信息
//            uManager.GlobalManager.SaveLastLoginInfo;




            //登陆成功,统一使用,显示主页MainFrame
            frmMain.DoCallLoginAPISucc(False,True);



//            // 注册成功
//            if (APPUserType=utClient) or (APPUserType=utRider) then
//            begin
//
//                //注册成功之后，进入主界面
//      //          uFuncCommon.FreeAndNil(GlobalMainFrame);
//                GlobalManager.IsLogin:=True;
//                //显示主界面
//                ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,Application,True,True,ufsefNone);
//                GlobalMainFrame.FrameHistroy:=CurrentFrameHistroy;
//                GlobalMainFrame.Login;
//
//      //          ShowMessageBoxFrame(frmMain, '注册成功!', '', TMsgDlgType.mtInformation,
//      //            ['确定'], OnModalResultFromRegisterSucc);
//            end;



//            if APPUserType=utShop then
//            begin
//              {$IFDEF SHOP_APP}
//              //刚注册,显示开店页面
//              HideFrame;//(Self,hfcttBeforeShowFrame);
//              ShowFrame(TFrame(GlobalOpenShopFillInfoFrame),TFrameOpenShopFillInfo,frmMain,nil,nil,nil,Application);
//              GlobalOpenShopFillInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//              GlobalOpenShopFillInfoFrame.Clear;
//              {$ENDIF}
//            end;
//
//            if APPUserType=utClient then
//            begin
//              {$IFDEF CLIENT_APP}
//              //显示主页面,但要更新我的信息
//              HideFrame;//(Self,hfcttBeforeShowFrame);
//              ShowFrame(TFrame(GlobalMainFrame),TFrameMain);
//              GlobalMainFrame.FrameHistroy:=CurrentFrameHistroy;
//              GlobalMainFrame.pcMain.Prop.ActivePage:=GlobalMainFrame.tsMy;
//              GlobalMainFrame.FMyFrame.Load;
//              {$ENDIF}
//            end;


      end
      else
      begin
        // 注册失败
        ShowMessageBoxFrame(Self, ASuperObject.S['Desc'], '',
          TMsgDlgType.mtInformation, ['确定'], nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag = 1 then
    begin
      // 网络异常
      ShowMessageBoxFrame(Self, '网络异常,请检查您的网络连接!', TTimerTask(ATimerTask)
        .TaskDesc, TMsgDlgType.mtInformation, ['确定'], nil);
    end;
  finally
    HideWaitingFrame;
  end;

end;

procedure TFrameWriteUserInfo.lblProtocolClick(Sender: TObject);
begin
  HideVirtualKeyboard;

//  FreeAndNil(GlobalRegisterProtocolFrame);
  //查看协议
  ShowFrame(TFrame(GlobalRegisterProtocolFrame),TFrameRegisterProtocol,frmMain,nil,nil,nil,Application,False,False,ufsefNone);
  GlobalRegisterProtocolFrame.Load;

end;

procedure TFrameWriteUserInfo.Load(AEmail:String;
                                    APhone, ACaptcha, ALoginType: String//;
//                                   //三方平台的用户名
//                                   AUserName:String;
//                                   //三方平台的头像
//                                   AUserHeadPicFilePath:String;
//                                   AWxOpenID:String;
//                                   AWxAuthToken:String;
//                                   AAlipayOpenID:String;
//                                   AAlipayAuthToken:String
                                   );
var
  ANames:TStringDynArray;
  AUrls:TStringDynArray;
begin
  Self.FPhone:=APhone;
  Self.FCaptcha:=ACaptcha;
  Self.FLoginType:=ALoginType;
  Self.FEmail:=AEmail;

  Self.lblPhone.Caption:=APhone;
  Self.lblEmail.Caption:=AEmail;



  Self.edtNickName.Text:=GlobalUserBindThirdPartyAccount.FUserName;

//  FWxOpenID:=AWxOpenID;
//  FWxAuthToken:=AWxAuthToken;


//  Self.pnlRegisterProtocol.Visible:=AIsShowProtocol;
//  if ALoginType=Const_RegisterLoginType_PhoneNum then Self.pnlRegisterProtocol.Visible:=True;



  //默认不勾选同意
  Self.chkAgree.Prop.Checked:=False;


  //宠物头像
  if GlobalUserBindThirdPartyAccount.FUserHeadPicFilePath<>'' then
  begin
      SetLength(ANames,0);
      SetLength(AUrls,0);

//      SetLength(ANames,1);
//      SetLength(AUrls,1);
//      if AUserHeadPicFilePath<>'' then
//      begin
//        ANames[0]:=AUserHeadPicFilePath;
//        AUrls[0]:=AUserHeadPicFilePath;
//      end;


      FPetHeadPicFrame.Init(
                            '',
                            ANames,
                            AUrls,
                            True, //裁剪
                            100,
                            100,
                            1     //最多1张
                            );

      FPetHeadPicFrame.AddPicture(GlobalUserBindThirdPartyAccount.FUserHeadPicFilePath);
  end;

end;

procedure TFrameWriteUserInfo.OnModalResultBack(Frame: Tobject);
begin
  if TFrameMessageBox(Frame).ModalResult='确定' then
  begin
    HideFrame;//(Self, hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);
  end;
end;

procedure TFrameWriteUserInfo.OnModalResultFromRegisterSucc(Frame: TObject);
begin
//  //注册成功之后，进入主界面
//  uFuncCommon.FreeAndNil(GlobalMainFrame);
//  GlobalManager.IsLogin:=True;
//  //显示主界面
//  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,Application,True,True,ufsefNone);
//  GlobalMainFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalMainFrame.Login;
end;

initialization
  //默认是外卖的
  //初始在这里,要改的话,在各自项目的MainForm中改
  //是否显示注册协议
  GlobalIsShowRegisterProtocol:=False;


end.





