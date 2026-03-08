unit DelphiClientMainForm;

interface
{$I OpenPlatformClient.inc}

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uDrawTextParam,
  LoginFrame,
  uFireMonkeyDrawCanvas,
  EasyServiceCommonMaterialDataMoudle,
  CommonImageDataMoudle,
  uLang,
  uUIFunction,
  uSkinPicture,

//  uTBSSDK,
  uOpenCommon,
//  uDataInterface,
  uBasePageStructure,
  uRestHttpDataInterface,
//  uPageStructure,
//  uOpenClientCommon,
//  BasePageFrame,
//  uBasePageFrame,
//  BaseListPageFrame,


//  uAndroidDVSelectMedia,
//  uAndroidDmcBigSelectMedia,

  uConst,

  uManager,
//  uPageStructure,
  uDataInterface,
  uOpenClientCommon,

  {$IFDEF HAS_FASTMSG}
  uIMClientCommon,

  FastMsg.Client.BindingEvents,
  FastMsg.Client.Paths,
  FastMsg.Client,
  FastMsg.Client.OEM,
  FastMsg.Client.ChatContent,
//  FastMsg.Client.CommonClass,
  {$ENDIF}


  MainForm, uSkinButtonType, uSkinFireMonkeyButton, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyControl, uSkinPanelType,
  uSkinFireMonkeyPanel, FMX.Media, uTimerTaskEvent, FMX.Layouts, uGraphicCommon,
//  uSDKVersion, uBasePush, uXiaoMiPush,
  System.Notification, FMX.Edit,
  FMX.Controls.Presentation, uSkinFireMonkeyEdit, uSkinLabelType,
  uSkinFireMonkeyLabel;

type
  TfrmOrangeUIClientMain = class(TfrmMain)
    SkinTheme1: TSkinTheme;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
//    FTBSSDK:TTBSSDK;
    { Private declarations }
  protected
    //GlobalManager加载之后,加载了上次的用户信息
    procedure CustomLoadedGlobalManager;override;
//    //自定义登陆接口调用
//    procedure DoCustomAutoLoginExecute(ATimerTask:TObject);override;
    //手动登陆成功
    //调用登录接口成功
    procedure DoCallLoginAPISucc(
                                  //是否是自动登陆成功的
                                  AIsAutoLogin:Boolean;
                                  //是否需要显示主界面
                                  AIsNeedShowMainFrame:Boolean=True
                                  );override;
    //退出登录
    procedure Logout;override;
  public
    procedure MyInfoChange;override;

    //更新服务器设置
    procedure SyncServerSetting(AServer:String;APort:Integer);override;
    { Public declarations }
  end;




var
  frmOrangeUIClientMain: TfrmOrangeUIClientMain;

implementation

{$R *.fmx}

uses
  MainFrame;

procedure TfrmOrangeUIClientMain.Button1Click(Sender: TObject);
begin
  inherited;

  //
end;

procedure TfrmOrangeUIClientMain.CustomLoadedGlobalManager;
begin
  inherited;

//  if GlobalManager.IsLogin and (GlobalManager.User.fastmsg_user_id>0) then
//  begin
//    GlobalIMClient.OfflineLogin(GlobalManager.User.fastmsg_user_id);
//  end;

end;

procedure TfrmOrangeUIClientMain.DoCallLoginAPISucc(AIsAutoLogin,
  AIsNeedShowMainFrame: Boolean);
begin
//  //设置userPath
//  GlobalClient.CurrentUser.UserPath:=TClientPath.GetDataPath+PathDelim+IntToStr(GlobalManager.User.fastmsg_user_id);


  inherited;


  {$IFDEF HAS_FASTMSG}
  if GlobalManager.User.fastmsg_user_id>0 then
  begin
    //开放平台的用户fastmsg_user_id就是FastMsg中的username登录账号
    GlobalIMClient.Login(IntToStr(GlobalManager.User.fastmsg_user_id),'123456');
  end;
  {$ENDIF}

end;

procedure TfrmOrangeUIClientMain.FormCreate(Sender: TObject);
begin
  inherited;


//  IsDrawBitmapHignSpeed:=True;

  {$IFDEF HAS_FASTMSG}
  GlobalIMClient:=TIMClient.Create;

  {$ENDIF}

  MainForm.frmMain:=Self;

//  FTBSSDK:=TTBSSDK.Create(nil);

end;

procedure TfrmOrangeUIClientMain.FormDestroy(Sender: TObject);
begin
  inherited;


//  FreeAndNil(FTBSSDK);

  {$IFDEF HAS_FASTMSG}
  FreeAndNil(GlobalIMClient);
  {$ENDIF}

end;

procedure TfrmOrangeUIClientMain.FormShow(Sender: TObject);
begin
  inherited;

//  //自定义素材
//  dmEasyServiceCommonMaterial.pnlToolBarMaterial.DrawCaptionParam.DrawRectSetting.Enabled:=False;
//  dmEasyServiceCommonMaterial.pnlToolBarMaterial.DrawCaptionParam.FontHorzAlign:=
//    TFontHorzAlign.fhaCenter;











  //通用导航栏,灰色
  dmEasyServiceCommonMaterial.pnlToolBarMaterial.BackColor.FillColor.UseThemeColor:=TUseThemeColorType.ctNone;
  dmEasyServiceCommonMaterial.pnlToolBarMaterial.BackColor.FillColor.Color:=$FFEDEDED;//4293783021
  dmEasyServiceCommonMaterial.pnlToolBarMaterial.DrawCaptionParam.FontColor:=TAlphaColorRec.Black;
  dmEasyServiceCommonMaterial.pnlToolBarMaterial.DrawCaptionParam.DrawRectSetting.Enabled:=False;
  dmEasyServiceCommonMaterial.pnlToolBarMaterial.DrawCaptionParam.FontHorzAlign:=TFontHorzAlign.fhaCenter;

//  dmEasyServiceCommonMaterial.pnlToolBarMaterial.BackColor.FillColor.UseThemeColor:=TUseThemeColorType.ctNone;
//  dmEasyServiceCommonMaterial.pnlToolBarMaterial.BackColor.FillColor.Color:=$FFFF4F4E;//4294922062;
//  dmEasyServiceCommonMaterial.pnlToolBarMaterial.DrawCaptionParam.FontColor:=TAlphaColorRec.Black;
//  dmEasyServiceCommonMaterial.pnlToolBarMaterial.DrawCaptionParam.DrawRectSetting.Enabled:=False;
//  dmEasyServiceCommonMaterial.pnlToolBarMaterial.DrawCaptionParam.FontHorzAlign:=TFontHorzAlign.fhaCenter;
//  dmEasyServiceCommonMaterial.pnlToolBarMaterial.CreateBackgroundPicture;
//  dmEasyServiceCommonMaterial.pnlToolBarMaterial.FBackgroundPicture.SkinImageList:=dmCommonImageDataMoudle.imglistOthers;
//  dmEasyServiceCommonMaterial.pnlToolBarMaterial.FBackgroundPicture.ImageName:='toolbar_background';
//  dmEasyServiceCommonMaterial.pnlToolBarMaterial.FDrawPictureParam.IsStretch:=True;


  //导航栏变成灰色，那么上面的按钮需要变成黑色
  dmEasyServiceCommonMaterial.btnTransparentWhiteCaptionButtonMaterial.DrawCaptionParam.FontColor:=TAlphaColorRec.Black;


  //专用导航栏,红色背景和图片
  dmCommonImageDataMoudle.pnlToolBarMaterial.BackColor.FillColor.UseThemeColor:=TUseThemeColorType.ctNone;
  dmCommonImageDataMoudle.pnlToolBarMaterial.BackColor.FillColor.Color:=$FFFF4F4E;//4294922062;
  dmCommonImageDataMoudle.pnlToolBarMaterial.DrawCaptionParam.FontColor:=TAlphaColorRec.Black;
  dmCommonImageDataMoudle.pnlToolBarMaterial.DrawCaptionParam.DrawRectSetting.Enabled:=False;
  dmCommonImageDataMoudle.pnlToolBarMaterial.DrawCaptionParam.FontHorzAlign:=TFontHorzAlign.fhaCenter;
  dmCommonImageDataMoudle.pnlToolBarMaterial.CreateBackgroundPicture;
  dmCommonImageDataMoudle.pnlToolBarMaterial.FBackgroundPicture.SkinImageList:=dmCommonImageDataMoudle.imglistOthers;
  dmCommonImageDataMoudle.pnlToolBarMaterial.FBackgroundPicture.ImageName:='toolbar_background';
  dmCommonImageDataMoudle.pnlToolBarMaterial.FDrawPictureParam.IsStretch:=True;




  //返回按钮,为黑色
  dmEasyServiceCommonMaterial.bdmReturnButton.NormalPicture.Assign(dmEasyServiceCommonMaterial.imglistArrow.PictureList[0]);





  //
  //dmEasyServiceCommonMaterial.pcOrder_Material.BackColor.FillColor.Color:=$FFEDEDED;




  //滚动框
  dmEasyServiceCommonMaterial.sbDefaultColorBackgroundScrollBoxMaterial.BackColor.FillColor.Color:=$FFEDEDED;







  //默认的按钮
//  dmEasyServiceCommonMaterial.btnBlueColorButtonMaterial.NormalPicture.Assign(Self.imglistSkin.PictureList[0]);
//  dmEasyServiceCommonMaterial.btnBlueColorButtonMaterial.DrawPictureParam.IsStretch:=True;
//  dmEasyServiceCommonMaterial.btnBlueColorButtonMaterial.DrawPictureParam.StretchStyle:=TPictureStretchStyle.issTensile;
//  dmEasyServiceCommonMaterial.btnBlueColorButtonMaterial.DrawPictureParam.StretchStyle:=TPictureStretchStyle.issSquare;
//  dmEasyServiceCommonMaterial.btnBlueColorButtonMaterial.DrawPictureParam.StretchMargins.SetBounds(8,8,8,8);

//  dmEasyServiceCommonMaterial.btnRedColorButtonMaterial.NormalPicture.Assign(Self.imglistSkin.PictureList[0]);
//  dmEasyServiceCommonMaterial.btnRedColorButtonMaterial.DrawPictureParam.IsStretch:=True;
//  dmEasyServiceCommonMaterial.btnRedColorButtonMaterial.DrawPictureParam.StretchStyle:=TPictureStretchStyle.issTensile;
//  dmEasyServiceCommonMaterial.btnRedColorButtonMaterial.DrawPictureParam.StretchStyle:=TPictureStretchStyle.issSquare;
//  dmEasyServiceCommonMaterial.btnRedColorButtonMaterial.DrawPictureParam.StretchMargins.SetBounds(8,8,8,8);


//  dmEasyServiceCommonMaterial.btnOrangeRedBorderWhiteBackButtonMaterial.NormalPicture.Assign(Self.imglistSkin.PictureList[0]);
//  dmEasyServiceCommonMaterial.btnOrangeRedBorderWhiteBackButtonMaterial.DrawPictureParam.IsStretch:=True;
//  dmEasyServiceCommonMaterial.btnOrangeRedBorderWhiteBackButtonMaterial.DrawPictureParam.StretchStyle:=TPictureStretchStyle.issTensile;
//  dmEasyServiceCommonMaterial.btnOrangeRedBorderWhiteBackButtonMaterial.DrawPictureParam.StretchStyle:=TPictureStretchStyle.issSquare;
//  dmEasyServiceCommonMaterial.btnOrangeRedBorderWhiteBackButtonMaterial.DrawPictureParam.StretchMargins.SetBounds(8,8,8,8);





//  //更改图片素材为主题色
//  ChangeSkinPictureListColor(GlobalChangedColorBySkinThemePictureList,SkinTheme1.SkinThemeColor);


end;

procedure TfrmOrangeUIClientMain.Logout;
begin
  inherited;

  {$IFDEF HAS_FASTMSG}
  //注销IM
  GlobalIMClient.Logout;
  {$ENDIF}

end;

procedure TfrmOrangeUIClientMain.MyInfoChange;
begin
//  if GlobalMainFrame<>nil then
//  begin
//    GlobalMainFrame.SyncMyInfo;
//  end;
end;

procedure TfrmOrangeUIClientMain.SyncServerSetting(AServer: String;APort: Integer);
begin
//  //写死？
//  AServer:=Const_Server_Host_IOS;
//  APort:=Const_Server_Port;


  Inherited SyncServerSetting(AServer,APort);


  {$IFDEF HAS_FASTMSG}
  OEM_DEFAULT_HOST:=Const_Server_Host_IM;
  GlobalClient.Config.NetworkOptions.Items[0].Host:=Const_Server_Host_IM;
  {$ENDIF}



//  GlobalMainProgramSetting.OpenPlatformAppID:='1000';
//  //服务端接口地址
//  GlobalMainProgramSetting.OpenPlatformServerUrl:='http://'+AServer+':'+IntToStr(APort)+'/';
//  //图片上传下载地址
//  GlobalMainProgramSetting.OpenPlatformImageUrl:='http://'+AServer+':'+IntToStr(APort+1)+'/';
//
//
//  GlobalMainProgramSetting.AppID:=AppID;
//  GlobalMainProgramSetting.ProgramTemplateName:='open_platform';
//  GlobalMainProgramSetting.DataIntfServerUrl:=InterfaceUrl+'/';
//  GlobalMainProgramSetting.DataIntfImageUrl:=ImageHttpServerUrl+'/';




  //开放平台页面框架的接口类型
  GlobalDataInterfaceClass:=TTableCommonRestHttpDataInterface;
end;

end.
