unit uThirdPartyAccountAuth;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
//  uFileCommon,
//  uComponentType,
//  IOUtils,
//  IdURI,


  uBaseLog,
  uOpenClientCommon,
  uOpenUISetting,
  uFuncCommon,
  uSkinItems,
  uFrameContext,

  {$IFDEF HAS_WXPAY}
  //微信登录
  uWeiChat,
  {$ENDIF}

  {$IFDEF HAS_ALIPAY}
  //支付宝登录
  uAlipayMobilePay,
  {$ENDIF}

//  {$IFDEF HAS_FACEBOOK}
//  FBLoginCommon,
//  {$ENDIF}

  {$IFDEF HAS_APPLESIGNIN}
  uAppleSignIn,
  uBaseNativeControl,
  {$ENDIF}

  WaitingFrame,
  MessageBoxFrame,

//  uAppleSignIn,
  uSkinListBoxType,
  uOpenCommon,

  uConst,
  uLang,

  uBaseThirdPartyAccountAuth,


  HintFrame,
  uManager,
//  uGetDeviceInfo,
  uRestInterfaceCall,
//  uCommonUtils,
  uTimerTask,
  uUIFunction,
    {$IFDEF SKIN_SUPEROBJECT}
    uSkinSuperObject,
    uSkinSuperJson,
    {$ELSE}
    XSuperObject,
    XSuperJson,
    {$ENDIF}
  uBaseHttpControl,

  System.ImageList, FMX.ImgList, uDrawPicture, uSkinImageList, uDrawCanvas;


type
  //rest接口实现
  TUserBindThirdPartyAccount=class(TBaseUserBindThirdPartyAccount)
  public
    //微信绑定和解绑
    procedure OnWeiXinBindingExecute(ATimerTask: TObject);override;
    procedure OnWeiXinBindingExecuteEnd(ATimerTask: TObject);override;

    //解除绑定
    procedure OnWeiXinnotBindingExecute(ATimerTask:TObject);override;
    procedure OnWeiXinnotBindingExecuteEnd(ATimerTask:TObject);override;
  public
    //支付宝绑定与解绑
    procedure OnGetAlipayAuthLoginUrlExecute(ATimerTask: TObject);override;
    procedure OnGetAlipayAuthLoginUrlExecuteEnd(ATimerTask: TObject);override;

    procedure OnAlipayBindingExecute(ATimerTask: TObject);override;
    procedure OnAlipayBindingExecuteEnd(ATimerTask: TObject);override;

    //解除绑定
    procedure OnAlipaynotBindingExecute(ATimerTask:TObject);override;
    procedure OnAlipaynotBindingExecuteEnd(ATimerTask:TObject);override;

    procedure DoCustomGetUserInfo(Sender:TObject;AAuthCode:String;var AUserId:String;var AAccessToken:String;var AUserInfoJsonStr:String);override;
  public
    //苹果的绑定和解绑
    procedure OnAppleBindingExecute(ATimerTask: TObject);override;
    procedure OnAppleBindingExecuteEnd(ATimerTask: TObject);override;

    //解除绑定
    procedure OnApplenotBindingExecute(ATimerTask:TObject);override;
    procedure OnApplenotBindingExecuteEnd(ATimerTask:TObject);override;
  public
    //推特的绑定和解绑
    procedure OnTwitterBindingExecute(ATimerTask: TObject);override;
    procedure OnTwitterBindingExecuteEnd(ATimerTask: TObject);override;

    //解除绑定
    procedure OnTwitternotBindingExecute(ATimerTask:TObject);override;
    procedure OnTwitternotBindingExecuteEnd(ATimerTask:TObject);override;
  public
    //Facebook的绑定和解绑
    procedure OnFacebookBindingExecute(ATimerTask: TObject);override;
    procedure OnFacebookBindingExecuteEnd(ATimerTask: TObject);override;

    //解除绑定
    procedure OnFacebooknotBindingExecute(ATimerTask:TObject);override;
    procedure OnFacebooknotBindingExecuteEnd(ATimerTask:TObject);override;

  public

    //调用判断三方账号是否存在接口
    procedure DoIsThirdPartyAccountExecute(ATimerTask:TObject);override;
    //判断三方账号是否存在事件
    procedure DoIsThirdPartyAccountExecuteEnd(ATimerTask:TObject);override;

    //调用登录接口
    procedure DoLoginExecute(ATimerTask:TObject);override;
    //统一的登录结束事件
    procedure DoLoginExecuteEnd(ATimerTask:TObject);override;
  end;



var
  GlobalUserBindThirdPartyAccount:TUserBindThirdPartyAccount;



implementation


{ TUserBindThirdPartyAccount }

procedure TUserBindThirdPartyAccount.OnWeiXinBindingExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try

    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('bind_thirdparty_account',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',

                                                    'wx_union_id',
                                                    'wx_open_id',
                                                    'wx_auth_token'//,

//                                                    'alipay_open_id',
//                                                    'alipay_auth_token'

                                                    ],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,

                                                    Self.FWxUnionID,
                                                    Self.FWxOpenID,
                                                    Self.FWxAuthToken//,

//                                                    Self.FAlipayOpenID,
//                                                    Self.FAlipayAuthToken
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

procedure TUserBindThirdPartyAccount.OnWeiXinBindingExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        GlobalManager.User.wx_union_id:=Self.FWxUnionID;
        GlobalManager.User.wx_open_id:=Self.FWxOpenID;
        GlobalManager.User.wx_auth_token:=Self.FWxAuthToken;

        //绑定成功
        ShowHintFrame(nil,Trans('微信绑定成功!'));

        if Assigned(OnChange) then
        begin
          OnChange(Self);
        end;


      end
      else
      begin
        //绑定失败
        ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

procedure TUserBindThirdPartyAccount.OnWeiXinnotBindingExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try

    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('unbind_thirdparty_account',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'account_type'],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    Const_RegisterLoginType_WeiXin],
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

procedure TUserBindThirdPartyAccount.OnWeiXinnotBindingExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        GlobalManager.User.wx_union_id:='';
        GlobalManager.User.wx_open_id:='';
        GlobalManager.User.wx_auth_token:='';


        //解除绑定成功,刷新界面
        if Assigned(OnChange) then
        begin
          OnChange(Self);
        end;


      end
      else
      begin
        //解除绑定失败
        ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

procedure TUserBindThirdPartyAccount.OnAlipayBindingExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try

    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('bind_thirdparty_account',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',

//                                                    'wx_union_id',
//                                                    'wx_open_id',
//                                                    'wx_auth_token'//,

                                                    'alipay_open_id',
                                                    'alipay_auth_token'

                                                    ],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,

//                                                    Self.FWxUnionID,
//                                                    Self.FWxOpenID,
//                                                    Self.FWxAuthToken//,

                                                    Self.FAlipayOpenID,
                                                    Self.FAlipayAuthToken
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

procedure TUserBindThirdPartyAccount.OnAlipayBindingExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        GlobalManager.User.alipay_open_id:=Self.FAlipayOpenID;
        GlobalManager.User.alipay_auth_token:=Self.FAlipayAuthToken;



        //绑定成功
        ShowHintFrame(nil,Trans('支付宝绑定成功!'));
        if Assigned(OnChange) then
        begin
          OnChange(Self);
        end;

      end
      else
      begin
        //绑定失败
        ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

procedure TUserBindThirdPartyAccount.OnAlipaynotBindingExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try

    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('unbind_thirdparty_account',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'account_type'],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    Const_RegisterLoginType_Alipay],
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

procedure TUserBindThirdPartyAccount.OnAlipaynotBindingExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


        GlobalManager.User.alipay_open_id:='';
        GlobalManager.User.alipay_auth_token:='';


        //解除绑定成功,刷新界面
        if Assigned(OnChange) then
        begin
          OnChange(Self);
        end;


      end
      else
      begin
        //解除绑定失败
        ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;


procedure TUserBindThirdPartyAccount.OnGetAlipayAuthLoginUrlExecute(
  ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try

    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('new_auth_login_url_by_app',
                                                    nil,
                                                    AlipayCenterInterfaceUrl,
                                                    ['appid'
                                                    ],
                                                    [AppID
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

procedure TUserBindThirdPartyAccount.OnGetAlipayAuthLoginUrlExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        {$IFDEF HAS_ALIPAY}
        if not GlobalAlipayMobilePay.AuthLogin(ASuperObject.O['Data'].S['AuthLoginUrl']) then
        begin
          ShowMessageBoxFrame(nil,Trans('发送请求给支付宝失败!'));
        end;
        {$ENDIF HAS_ALIPAY}

      end
      else
      begin
        //绑定失败
        ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
//    HideWaitingFrame;
  end;
end;


procedure TUserBindThirdPartyAccount.DoCustomGetUserInfo(Sender: TObject; AAuthCode: String;
  var AUserId, AAccessToken, AUserInfoJsonStr: String);
var
  AResponse:String;
  ASuperObject:ISuperObject;
begin
  //出错
  try

    AResponse:=SimpleCallAPI('get_auth_login_user_info',
                                                    nil,
                                                    AlipayCenterInterfaceUrl,
                                                    ['appid',
                                                    'auth_code'
                                                    ],
                                                    [AppID,
                                                    AAuthCode
                                                    ],
                                                    GlobalRestAPISignType,
                                                    GlobalRestAPIAppSecret
                                                    );
    if AResponse<>'' then
    begin
      ASuperObject:=TSuperObject.Create(AResponse);
      if ASuperObject.I['Code']=SUCC then
      begin
        AUserId:=ASuperObject.O['Data'].S['UserId'];
        AAccessToken:=ASuperObject.O['Data'].S['AccessToken'];
        AUserInfoJsonStr:=ASuperObject.O['Data'].S['UserInfo'];
      end;
    end;

  except
    on E:Exception do
    begin
      //异常
      uBaseLog.HandleException(E,'DoCustomGetUserInfo');
    end;
  end;

end;

procedure TUserBindThirdPartyAccount.OnAppleBindingExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try

    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('bind_thirdparty_account',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'apple_open_id',
                                                    'apple_auth_token'
                                                    ],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,

                                                    Self.FAppleOpenID,
                                                    Self.FAppleAuthToken
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

procedure TUserBindThirdPartyAccount.OnAppleBindingExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        GlobalManager.User.apple_open_id:=Self.FAppleOpenID;
        GlobalManager.User.apple_auth_token:=Self.FAppleAuthToken;

        //绑定成功
        ShowHintFrame(nil,Trans('Apple绑定成功!'));

        if Assigned(OnChange) then
        begin
          OnChange(Self);
        end;


      end
      else
      begin
        //绑定失败
        ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

procedure TUserBindThirdPartyAccount.OnApplenotBindingExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try

    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('unbind_thirdparty_account',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'account_type'],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    Const_RegisterLoginType_Apple],
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

procedure TUserBindThirdPartyAccount.OnApplenotBindingExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        GlobalManager.User.apple_open_id:='';
        GlobalManager.User.apple_auth_token:='';



        //解除绑定成功,刷新界面
        if Assigned(OnChange) then
        begin
          OnChange(Self);
        end;


      end
      else
      begin
        //解除绑定失败
        ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

procedure TUserBindThirdPartyAccount.DoLoginExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try

    TTimerTask(ATimerTask).TaskDesc:=
      SimpleCallAPI('login',
                    nil,
                    UserCenterInterfaceUrl,
                    ['appid',
                    'user_type',
                    'login_type',
                    'username',
                    'password',
                    'captcha',
                    'version',
                    'phone_imei',
                    'phone_uuid',
                    'phone_type',
                    'os',
                    'os_version',

                    'fb_open_id',
                    'fb_auth_token',

                    'wx_union_id',
                    'wx_open_id',
                    'wx_auth_token',

                    'alipay_open_id',
                    'alipay_auth_token',

                    'apple_open_id',
                    'apple_auth_token',

                    'third_party_username',
                    'third_party_userhead'
                    ],
                    [AppID,
                    APPUserType,
                    Self.FLoginType,
                    '',//Self.FLoginUser,
                    '',//FLoginPassword,
                    '',
                    '',
                    '',//GetIMEI,
                    '',//GetUUID,
                    '',//GetPhoneType,
                    '',//GetOS,
                    '',//GetOSVersion,

                    FFacebookOpenId,
                    FFacebookAuthToken,

                    Self.FWxUnionId,
                    Self.FWxOpenId,
                    Self.FWxAuthToken,

                    Self.FAlipayOpenId,
                    Self.FAlipayAuthToken,

                    Self.FAppleOpenId,
                    Self.FAppleAuthToken,

                    Self.FUserName,
                    Self.FUserHeadUrl

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

procedure TUserBindThirdPartyAccount.DoLoginExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


          GlobalManager.User.ParseFromJson(ASuperObject.O['Data'].A['User'].O[0]);


          //登录令牌,用于确认用户已经登录
          GlobalManager.User.key:=ASuperObject.O['Data'].S['Key'];

          //保存用户登录key,用于下次自动登陆
          GlobalManager.LastLoginKey:=ASuperObject.O['Data'].S['login_key'];

          //登录成功,显示主界面
          if Assigned(OnLoginSucc) then
          begin
            OnLoginSucc(Self);
          end;


      end
      else
      begin
        //登录失败
        ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

procedure TUserBindThirdPartyAccount.DoIsThirdPartyAccountExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try

    TTimerTask(ATimerTask).TaskDesc:=
      SimpleCallAPI('is_third_party_account_exist',
                    nil,
                    UserCenterInterfaceUrl,
                    ['appid',
                    'user_type',

                    'fb_open_id',
                    'fb_auth_token',

                    'wx_union_id',
                    'wx_open_id',
                    'wx_auth_token',

                    'alipay_open_id',
                    'alipay_auth_token',

                    'apple_open_id',
                    'apple_auth_token'
                    ],
                    [AppID,
                    APPUserType,
                    FFacebookOpenId,
                    FFacebookAuthToken,

                    Self.FWxUnionId,
                    Self.FWxOpenId,
                    Self.FWxAuthToken,

                    Self.FAlipayOpenID,
                    Self.FAlipayAuthToken,

                    Self.FAppleOpenID,
                    Self.FAppleAuthToken
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

procedure TUserBindThirdPartyAccount.DoIsThirdPartyAccountExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
          if (ASuperObject.O['Data'].I['is_exist']=1)
            //如果是苹果授权登录,那么必须直接登录,不需要绑定手机
            or (Self.FAppleOpenID<>'') then
          begin


              //已经存在该三方账号,则登录
              ShowWaitingFrame(nil,'登录中...');
              //微信登录
              uTimerTask.GetGlobalTimerThread.RunTempTask(
                                                     DoLoginExecute,
                                                     DoLoginExecuteEnd,
                                                     'Login'
                                                     );


          end
          else
          begin



              //不存在,有些APP需要完善手机号再注册
              if Assigned(OnThirdPartyAccountNoExist) then
              begin
                OnThirdPartyAccountNoExist(Self);
              end;


//              //注册,跳转到完善手机号码页面,进行手机验证
//              //注册          1
//              HideFrame;//(nil,hfcttBeforeShowFrame);
//              ShowFrame(TFrame(GlobalRegisterFrame),TFrameRegister,frmMain,nil,nil,nil,Application);
//              GlobalRegisterFrame.FrameHistroy:=CurrentFrameHistroy;
//              GlobalRegisterFrame.Clear;//(Self.FRegisterLoginType);
//              GlobalRegisterFrame.pnlToolBar.Caption:='手机验证';
//
//
//              GlobalRegisterFrame.FUserName:=FUserName;
//              GlobalRegisterFrame.FUserHeadPicFilePath:=Self.FUserHeadPicFilePath;
//              GlobalRegisterFrame.FWxUnionID:=FWxUnionID;
//              GlobalRegisterFrame.FWxOpenID:=FWxOpenID;
//              GlobalRegisterFrame.FWxAuthToken:=FWxAuthToken;
//              GlobalRegisterFrame.FAlipayOpenID:=FAlipayOpenID;
//              GlobalRegisterFrame.FAlipayAuthToken:=FAlipayAuthToken;
//              GlobalRegisterFrame.Load(FUserName,FUserHeadPicFilePath,
//                                      FWxOpenID,FWxAuthToken,
//                                      FAlipayOpenID,FAlipayAuthToken
//                                      );


          end;
      end
      else
      begin
        //登录失败
        ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;

end;

procedure TUserBindThirdPartyAccount.OnTwitterBindingExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try

//    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('bind_thirdparty_account',
//                                                    nil,
//                                                    UserCenterInterfaceUrl,
//                                                    ['appid',
//                                                    'user_fid',
//                                                    'key',
//                                                    'apple_open_id',
//                                                    'apple_auth_token'
//                                                    ],
//                                                    [AppID,
//                                                    GlobalManager.User.fid,
//                                                    GlobalManager.User.key,
//
//                                                    Self.FTwitterOpenID,
//                                                    Self.FTwitterAuthToken
//                                                    ],
//                                                    GlobalRestAPISignType,
//                                                    GlobalRestAPIAppSecret
//                                                    );
//    if TTimerTask(ATimerTask).TaskDesc<>'' then
//    begin
//      TTimerTask(ATimerTask).TaskTag:=0;
//    end;


  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TUserBindThirdPartyAccount.OnTwitterBindingExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//        GlobalManager.User.tw_open_id:=Self.FTwitterOpenID;
//        GlobalManager.User.tw_auth_token:=Self.FTwitterAuthToken;
//
//        //绑定成功
//        ShowHintFrame(nil,Trans('Twitter绑定成功!'));
//
//        if Assigned(OnChange) then
//        begin
//          OnChange(Self);
//        end;
//
//
//      end
//      else
//      begin
//        //绑定失败
//        ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
//      end;
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    HideWaitingFrame;
//  end;
end;

procedure TUserBindThirdPartyAccount.OnTwitternotBindingExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try

    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('unbind_thirdparty_account',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'account_type'],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    Const_RegisterLoginType_Twitter],
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

procedure TUserBindThirdPartyAccount.OnTwitternotBindingExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        GlobalManager.User.apple_open_id:='';
        GlobalManager.User.apple_auth_token:='';



        //解除绑定成功,刷新界面
        if Assigned(OnChange) then
        begin
          OnChange(Self);
        end;


      end
      else
      begin
        //解除绑定失败
        ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;



procedure TUserBindThirdPartyAccount.OnFacebookBindingExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try

    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('bind_thirdparty_account',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'apple_open_id',
                                                    'apple_auth_token'
                                                    ],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,

                                                    Self.FFacebookOpenID,
                                                    Self.FFacebookAuthToken
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

procedure TUserBindThirdPartyAccount.OnFacebookBindingExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        GlobalManager.User.apple_open_id:=Self.FFacebookOpenID;
        GlobalManager.User.apple_auth_token:=Self.FFacebookAuthToken;

        //绑定成功
        ShowHintFrame(nil,Trans('Facebook绑定成功!'));

        if Assigned(OnChange) then
        begin
          OnChange(Self);
        end;


      end
      else
      begin
        //绑定失败
        ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

procedure TUserBindThirdPartyAccount.OnFacebooknotBindingExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try

    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('unbind_thirdparty_account',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'account_type'],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    Const_RegisterLoginType_Facebook],
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

procedure TUserBindThirdPartyAccount.OnFacebooknotBindingExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        GlobalManager.User.apple_open_id:='';
        GlobalManager.User.apple_auth_token:='';



        //解除绑定成功,刷新界面
        if Assigned(OnChange) then
        begin
          OnChange(Self);
        end;


      end
      else
      begin
        //解除绑定失败
        ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;



initialization
  GlobalUserBindThirdPartyAccount:=TUserBindThirdPartyAccount.Create;


finalization
  FreeAndNil(GlobalUserBindThirdPartyAccount);

end.
