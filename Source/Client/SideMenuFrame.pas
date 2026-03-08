unit SideMenuFrame;

interface


uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  System.DateUtils,


  MessageBoxFrame,
  SelectAreaFrame,
  uUIFunction,
  uManager,
  uGPSLocation,
  uConst,
  uLang,
//  uMyVIPListPage,
  uFrameContext,
//  uOpenCommon,
  uDataInterface,
  uBasePageStructure,
//  uPageStructure,
  uOpenClientCommon,
//  BasePageFrame,
//  uBasePageFrame,
//  BaseListPageFrame,

  ListItemStyleFrame_UserSerivceGoodsVIPFrame,
  ListItemStyleFrame_UserSerivceGoodsVIPRightsFrame,


  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  uBaseList,
  EasyServiceCommonMaterialDataMoudle,
  CommonImageDataMoudle,

  ShopInfoFrame,
  WaitingFrame,
  MyFrame,

  XSuperObject,
  XSuperJson,
  uOpenCommon,

  uDrawCanvas,
  uSkinItems,

  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinPanelType, uSkinFireMonkeyPanel,
  uSkinPageControlType, uSkinSwitchPageListPanelType, uSkinFireMonkeyPageControl,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinImageType, uSkinFireMonkeyImage, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType,
  uSkinFireMonkeyListBox, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinRoundImageType,
  uSkinFireMonkeyRoundImage, uSkinCheckBoxType, uSkinFireMonkeyCheckBox;

type
  TFrameSideMenu = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbMenu: TSkinFMXListBox;
    ItemDefault: TSkinFMXItemDesignerPanel;
    idpItem2: TSkinFMXItemDesignerPanel;
    imgItemDefaultIcon: TSkinFMXImage;
    lblItemDefaultName: TSkinFMXLabel;
    lblItem2Caption: TSkinFMXLabel;
    Item1: TSkinFMXItemDesignerPanel;
    lblItem1Caption: TSkinFMXLabel;
    imgItem1Icon: TSkinFMXRoundImage;
    lblItem1Detail1: TSkinFMXLabel;
    chkChangeWorkState: TSkinFMXCheckBox;
    procedure chkChangeWorkStateClick(Sender: TObject);
    procedure lbMenuClickItem(AItem: TSkinItem);
  private
    procedure OnReturnFromOkButton(Frame:TObject);
    procedure OnReturnFromCertUserInnfoFrame(AFrame: TFrame);
    procedure DoReturnFromMyUserInfoFrame(AFrame:TFrame);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
  public
    procedure Load;
    { Public declarations }
  end;




implementation

uses
  MainForm,
  MainFrame,
  LoginFrame,
  DelphiClientMainForm,
//  CertificateUserInfoFrame,
//  LookCertificationInfoFrame,
  UserInfoFrame,
  AboutUsFrame,
//  RiderSettingFrame,
  SettingFrame,
//  ShopBalanceFrame,
//  RiderWalletFrame,
//  EvalvateListFrame,
  UserSuggectionFrame,
//  MyBankCardListFrame,
  NoticeClassifyListFrame
//  RiderWorkSettingFrame,
//  RiderWorkSummaryFrame
  ;

{$R *.fmx}

procedure TFrameSideMenu.chkChangeWorkStateClick(Sender: TObject);
begin
//  //切换工作状态
//  if chkChangeWorkState.Prop.Checked then
//  begin
//    chkChangeWorkState.Prop.Checked:=True;
//    //收工
//    GlobalMainFrame.StopWork;
//  end
//  else
//  begin
//    //开工
//    if GlobalManager.AsRider.RiderInfo.cert_audit_state<>Ord(asAuditPass) then chkChangeWorkState.Prop.Checked:=False;
//    GlobalMainFrame.StartWork;
//  end;
end;

constructor TFrameSideMenu.Create(AOwner: TComponent);
begin
  inherited;





  RecordSubControlsLang(Self);
  //翻译子控件
  TranslateSubControlsLang(Self);

  //调整速度
  Self.lbMenu.Prop.VertControlGestureManager.InertiaScrollAnimator.Speed:=1.0;
end;

procedure TFrameSideMenu.DoReturnFromMyUserInfoFrame(AFrame: TFrame);
begin
  //刷新用户信息
  Load;
end;

procedure TFrameSideMenu.lbMenuClickItem(AItem: TSkinItem);
begin
//  //隐藏侧滑面板
//  GlobalMainFrame.MultiView1.HideMaster;



  if AItem.Name='suggestion' then
  begin
    //意见反馈
    //隐藏
    HideFrame;//(GlobalMainFrame);
    //显示收藏列表
    ShowFrame(TFrame(GlobalUserSuggectionFrame),TFrameUserSuggection,frmMain,nil,nil,nil,Application);
//    GlobalUserSuggectionFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalUserSuggectionFrame.Add;
    Exit;
  end;


  if AItem.Name='scan_qrcode' then
  begin
    //二维码扫描

    //隐藏
    frmMain.ScanQRCode;



    Exit;
  end;


  //OrangeUI平台商家,不登录也能访问
  if AItem.name='platform_shop' then
  begin
        if FPlatformShopFID<>0 then
        begin
            HideFrame;//(GlobalMainFrame);

            ShowFrame(TFrame(GlobalPlatformShopInfoFrame),TFrameShopInfo);
      //      GlobalPlatformShopInfoFrame.FrameHistroy:=CurrentFrameHistroy;
              //下面这一句要去掉  问题待修改
        //      GlobalShopInfoFrame:=FShopInfoFrame;
              GlobalPlatformShopInfoFrame.Clear;
              GlobalPlatformShopInfoFrame.IsShowBackBtn(True);//False);
              FPlatformShopFID:=85;
                GlobalPlatformShopInfoFrame.Load(FPlatformShopFID,nil,GlobalPlatformShopInfoFrame);
        //      if Self.FPlatformShopFID=0 then
        //      begin
        //        FIsFirstStart:=False;
        //        //获取平台商家信息
        //        uTimerTask.GetGlobalTimerThread.RunTempTask(
        //                     DoGetPlatformShopInfoExecute,
        //                     DoGetPlatformShopInfoExecuteEnd,
        //                     'GetPlatformShopInfo');
        //      end;
        end;
      Exit;
  end;


  if AItem.name='about_us' then
  begin
    //显示关于页面
    //隐藏
    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
    //显示登录页面
    ShowFrame(TFrame(GlobalAboutUsFrame),TFrameAboutUs,frmMain,nil,nil,nil,Application);
    GlobalAboutUsFrame.Load(Const_CopyrightCompany,
                            Const_CopyrightTime,
                            //隐私协议
                            Const_RegisterProtocolUrl,
                            ''
                            );
    Exit;
  end;



  if not GlobalManager.IsLogin then
  begin
    ShowLoginFrame(True);
    Exit;
  end;



  //下面这些功能需要登录

  if (AItem.name='my_info') or (AItem.name='account') then
  begin
    HideFrame;//(GlobalMainFrame);
    //显示我的
    ShowFrame(TFrame(GlobalMyFrame),TFrameMy,frmMain,nil,nil,DoReturnFromMyUserInfoFrame,Application);
//    GlobalMyFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalMyFrame.Load;//(GlobalManager.User);
  end;
//  if AItem.name='account' then
//  begin
//    //跳到我的账户与安全页面
//    //隐藏
//    HideFrame;//(GlobalMainFrame);
//    //显示登录页面
//    ShowFrame(TFrame(GlobalUserInfoFrame),TFrameUserInfo,frmMain,nil,nil,DoReturnFromMyUserInfoFrame,Application);
//    GlobalUserInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalUserInfoFrame.Load(GlobalManager.User);
//
//    GlobalUserInfoFrame.Sync;
//  end;

  if AItem.name='notice_center' then
  begin
    //通知中心
    HideFrame;//(GlobalMainFrame);
    ShowFrame(TFrame(GlobalNoticeClassifyListFrame),TFrameNoticeClassifyList);
    GlobalNoticeClassifyListFrame.Load;
  end;

//  if AItem.Name='my_vip' then
//  begin
////    TfrmOrangeUIClientMain(frmMain).
//    ShowMyVIPListPage;
//  end;

//  if AItem.name='work_summary' then
//  begin
//    //工作汇总
//    HideFrame;//(GlobalMainFrame);
//    ShowFrame(TFrame(GlobalRiderWorkSummaryFrame),TFrameRiderWorkSummary);
//    GlobalRiderWorkSummaryFrame.Load;
//  end;
//
//  if AItem.name='my_bankcard' then
//  begin
//    //我的银行卡
//    HideFrame;//(GlobalMainFrame);
//    ShowFrame(TFrame(GlobalMyBankCardListFrame),TFrameMyBankCardList,frmMain,nil,nil,nil,Application);
//    GlobalMyBankCardListFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalMyBankCardListFrame.Load('我的银行卡',futManage,-1);
//  end;
//
//  if AItem.name='work_setting' then
//  begin
//    //设置
//    HideFrame;//(GlobalMainFrame);
//    //到设置页面
//    ShowFrame(TFrame(GlobalRiderWorkSettingFrame),TFrameRiderWorkSetting);
//    GlobalRiderWorkSettingFrame.Load;
//  end;
//
//  if AItem.Name='evalvate' then
//  begin
//    //评价
//    HideFrame;//(GlobalMainFrame);
//    //到评价页面
//    ShowFrame(TFrame(GlobalEvalvateListFrame),TFrameEvalvateList);
//    GlobalEvalvateListFrame.Load;
//  end;

//  if AItem.Name='cert' then
//  begin
//    //实名认证
//    //实名认证状态  跳转对应界面
//    //未提交
//    if GlobalManager.AsRider.RiderInfo.cert_audit_state=Ord(asDefault) then
//    begin
//      //显示实名认证
//      HideFrame;//(GlobalMainFrame);
//      ShowFrame(TFrame(GlobalCertificateUserInfoFrame),TFrameCertificateUserInfo,frmMain,nil,nil,OnReturnFromCertUserInnfoFrame,Application);
//      GlobalCertificateUserInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//      GlobalCertificateUserInfoFrame.Clear;
//    end;
//
//    //审核通过
//    if GlobalManager.AsRider.RiderInfo.cert_audit_state=Ord(asAuditPass) then
//    begin
//      //隐藏
//      HideFrame;//(GlobalMainFrame);
//      ShowFrame(TFrame(GlobalLookCertificationInfoFrame),TFrameLookCertificationInfo,frmMain,nil,nil,nil,Application);
//      GlobalLookCertificationInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//      GlobalLookCertificationInfoFrame.Load(GlobalManager.User,False);
//    end;
//
//    //审核拒绝
//    if GlobalManager.AsRider.RiderInfo.cert_audit_state=Ord(asAuditReject) then
//    begin
//      ShowMessageBoxFrame(GlobalMainFrame,'认证信息审核未通过,请修改后重新提交!','',TMsgDlgType.mtInformation,['确定'],OnReturnFromOkButton);
//    end;
//
//    //待审核
//    if GlobalManager.AsRider.RiderInfo.cert_audit_state=Ord(asRequestAudit) then
//    begin
//      ShowMessageBoxFrame(GlobalMainFrame,'认证信息正在审核,请耐心等待!');
//    end;
//
//  end;

  if AItem.name='setting' then
  begin
    //设置
    HideFrame;//(GlobalMainFrame);
//    //到设置页面
//    ShowFrame(TFrame(GlobalRiderSettingFrame),TFrameRiderSetting);

    ShowFrame(TFrame(GlobalSettingFrame),TFrameSetting);
    GlobalSettingFrame.Load;
  end;

  if AItem.name='logout' then
  begin
    //退出登录
    frmMain.Logout;
    HideFrame;//(GlobalMainFrame);
    //到登录页面
    ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin);
  end;


//  if (GlobalManager.AsRider.RiderInfo.cert_audit_state<>Ord(asRequestAudit))
//  AND (GlobalManager.AsRider.RiderInfo.cert_audit_state<>Ord(asAuditReject)) then
end;

procedure TFrameSideMenu.Load;
begin
  //翻译子控件
  TranslateSubControlsLang(Self);


  if not GlobalManager.IsLogin then
  begin

      //加载用户名和手机号
      Self.lbMenu.Prop.Items.FindItemByType(sitItem1).Caption:=Trans('立即登录');
      //国内用手机
      Self.lbMenu.Prop.Items.FindItemByType(sitItem1).Detail:='';


  end
  else
  begin

      //加载用户名和手机号
      Self.lbMenu.Prop.Items.FindItemByType(sitItem1).Caption:=GlobalManager.User.name;
      //国内用手机
      Self.lbMenu.Prop.Items.FindItemByType(sitItem1).Detail:=GlobalManager.User.phone;

  end;

  Self.lbMenu.Prop.Items.FindItemByType(sitItem1).Icon.ImageIndex:=-1;

  Self.lbMenu.Prop.Items.FindItemByType(sitItem1).Icon.Url:=GlobalManager.User.GetHeadPicUrl;

//  {$IFDEF IOS}
//  Self.lbMenu.Prop.Items.FindItemByName('platform_shop').Visible:=False;
//  Self.lbMenu.Prop.Items.FindItemByName('my_vip').Visible:=False;
//  {$ELSE}
//  Self.lbMenu.Prop.Items.FindItemByName('platform_shop').Visible:=True;
//  Self.lbMenu.Prop.Items.FindItemByName('my_vip').Visible:=True;
//  {$ENDIF IOS}



end;

procedure TFrameSideMenu.OnReturnFromCertUserInnfoFrame(AFrame: TFrame);
begin
//  //重新获取骑手实名信息
//  GlobalMainFrame.tteGetRiderInfo.Run;
end;

procedure TFrameSideMenu.OnReturnFromOkButton(Frame: TObject);
begin
//  GlobalMainFrame.MultiView1.HideMaster;
//  //隐藏
//  HideFrame;//(GlobalMainFrame);
//  ShowFrame(TFrame(GlobalLookCertificationInfoFrame),TFrameLookCertificationInfo,frmMain,nil,nil,OnReturnFromCertUserInnfoFrame,Application);
//  GlobalLookCertificationInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalLookCertificationInfoFrame.Load(GlobalManager.User,True);
end;

end.
