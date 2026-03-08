unit MainFrame;

interface

{$I OpenPlatformClient.inc}

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  Math,
  uBaseLog,
  uTimerTask,
  XSuperObject,
  XSuperJson,
  uManager,
  uConst,
  uFrameContext,
  uComponentType,
//  uOpenClientCommon,
  uBaseHttpControl,
  uRestInterfaceCall,
  uDataSetToJson,
  IniFiles,
  uFileCommon,
  uOpenUISetting,
  uContentOperation,
  uSkinControlGestureManager,

//  ContentWebBrowserFrame,

  uDataInterface,
  uBasePageStructure,
//  uPageStructure,
  uOpenClientCommon,
//  BasePageFrame,
//  uBasePageFrame,
//  BaseListPageFrame,

//  MyGameInfoFrame,

//  uIMClientCommon,


  {$IFDEF HAS_FASTMSG}
  uIMClientCommon,
  FastMsg.Client.BindingEvents,
  FastMsg.Client.Paths,
  FastMsg.Client,
  FastMsg.Client.ChatContent,
//  FastMsg.Client.CommonClass,
  RecentContactFrame,
  IMClassifyFrame,
  ContactsListFrame,
  {$ENDIF}



  HomeFrame,
//  ShopInfoFrame,
  SideMenuFrame,
  WebBrowserFrame,
//  UserOrderListFrame,
//  QRCodeScannerFrame,

//  TelMainFrame,
//  AddContentFrame,
  ContentClassifyFrame,
//  ShopingFrame,
//  EmpHomeFrame,
  MyFrame,
//  UserListFrame,
  NoticeClassifyListFrame,
//  GoodsListFrame,
//  GoodsInfoFrame,
//  HotelListFrame,
//  BuyGoodsListFrame,
//  UserCartFrame,
//  OrderListFrame,
  HintFrame,
//  OrderInfoFrame,
  MessageBoxFrame,
  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,
//  AuditInfoFrame,

  uUIFunction,
  uFuncCommon,
  uSkinListBoxType,
  WaitingFrame,
//  SystemNotificationInfoFrame,


  uSkinFireMonkeyPageControl, uSkinFireMonkeyControl,
  uSkinFireMonkeySwitchPageListPanel, uDrawPicture, uSkinImageList,
  System.Notification, uSkinFireMonkeyButton, uSkinFireMonkeyNotifyNumberIcon,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyMemo,
  uSkinFireMonkeyPanel, uSkinMaterial, uSkinSwitchPageListPanelType,
  uSkinPageControlType, uSkinPanelType, uSkinButtonType,
  uSkinNotifyNumberIconType, uBaseSkinControl, uGPSLocation, uUrlPicture,
  uDownloadPictureManager, FMX.MultiView, uSkinImageType, uSkinFireMonkeyImage,
  uSkinLabelType, uSkinFireMonkeyLabel;

type
  TFrameMain = class(TFrame)
    pcMain: TSkinFMXPageControl;
    tsHome: TSkinFMXTabSheet;
    tsMy: TSkinFMXTabSheet;
    dpmShopGoodsPic: TDownloadPictureManager;
    tmrReLocation: TTimer;
    tmrFreeNoUseUrlPicture: TTimer;
    pnlToolBar1: TSkinFMXPanel;
    btnShowSideBar: TSkinFMXButton;
    btnWorkState: TSkinFMXButton;
    btnNotice: TSkinFMXButton;
    imgUserHead: TSkinFMXImage;
    btnAddr: TSkinFMXButton;
    lblMy: TSkinFMXLabel;
    tsRecentContact: TSkinTabSheet;
    tsContactsList: TSkinTabSheet;
    imgHomeIcons: TSkinImageList;
    nniSessionUnReadMsg: TSkinFMXNotifyNumberIcon;
    tmrSyncUnReadMsgCount: TTimer;
    tsCommunity: TSkinTabSheet;
    tsShop: TSkinTabSheet;
    tmrDelayLoad: TTimer;
    procedure pcMainChange(Sender: TObject);
    procedure tmrGetMyInfoTimer(Sender: TObject);
    procedure tmrFreeNoUseUrlPictureTimer(Sender: TObject);
    procedure tmrReLocationTimer(Sender: TObject);
    procedure btnAddContentClick(Sender: TObject);
    procedure imgUserHeadClick(Sender: TObject);
    procedure ccbsBarCodeScanComletedCallbackEvent(Sender: TObject;
      const ResultCode: Integer; const ResultString: string);
    procedure tmrDelayLoadTimer(Sender: TObject);
  private
    FContentOperation:TContentOperation;

//    FCarShopList:TCarShopList;
    //获取购物车商品列表
    procedure DoGetUserCarGoodsListExecute(ATimerTask:TObject);
    procedure DoGetUserCarGoodsListExecuteEnd(ATimerTask:TObject);
  private
    //IOS下
//    ccbsBarCode:TCCBarcodeScanner;


//    FFilterShopFID:Integer;
//    FFilterGoodsFID:Integer;
//    FFilterGoodsCategoryFID:Integer;
//    FFilterAttrValue:String;
//    FFilterNumber:Integer;
//    FFilterOrderno:Double;

    //添加商品到购物车
    procedure DoAddUserCartExecute(ATimerTask:TObject);
    procedure DoAddUserCartExecuteEnd(ATimerTask:TObject);
  private
    FFilterCartGodsFID:Integer;

    FNumber:Integer;
    //修改购物车商品数量
    procedure DoUpDateCartGoodsNumberExecute(ATimerTask:TObject);
    procedure DoUpDateCartGoodsNumberExecuteEnd(ATimerTask:TObject);
  private
//    //是否刚启动
//    FIsFirstStart:Boolean;
    //平台商家
    FShop:TShop;
    FPlatformShopFID:Integer;
    //获取平台商家信息
    procedure DoGetPlatformShopInfoExecute(ATimerTask:TObject);
    procedure DoGetPlatformShopInfoExecuteEnd(ATimerTask:TObject);

  private
//    procedure DoGetNoticeOrderExecute(ATimerTask: TObject);
//    procedure DoGetNoticeOrderExecuteEnd(ATimerTask: TObject);
//    //刷新每个页面
//    procedure LoadFrame;

    //刷新购物车数量
    procedure UpDateUserCartCount(AShopGoodsList:TCarShopList);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    FUserFID:String;
//    FMyVIPListPage:TPage;
//    FMyVIPListPageFrame:TFrameBasePage;


    //主页面
    FHomeFrame:TFrameHome;
//    FHomeFrame:TFrameContentClassify;

//    //店铺详情页面
//    FShopInfoFrame:TFrameShopInfo;


    //我的页面
    FMyFrame:TFrameMy;


//    //好友列表页面
//    FContactsListFrame:TFrameContactsList;
//    //商城页面
//    FShopingFrame:TFrameShoping;


    //D区内容分类
    FContentClassifyFrame:TFrameContentClassify;

//    //游戏角色
//    FUserGameInfo:TMyGameInfoFrame;

//    FTelMainFrame:TFrameTelMain;
//    //订单页面
//    FUserOrderListFrame:TFrameUserOrderList;
//    FBackgroundTimerThread:TTimerThread;
//    //侧边栏
//    FSideMenuFrame:TFrameSideMenu;


    procedure ShowSideMenuFrame;

    //登陆初始
    procedure Login(AIsOnlineLogin:Boolean);
    //退出
    procedure Logout;

    //点击推送后触发的事件
    procedure ClickPushNotification(AUserCustomJson:ISuperObject;
                                    ATitle:String;
                                    ABody:String;
                                    AIsAtBackground:Boolean);
    //延迟(登录之后)显示点击的推送消息详情
    procedure DoDelayViewClickPushNotificationJson;

    procedure ProcessGetNotice(ANotice:TNotice;ASuperObject:ISuperObject);

    procedure PorcessGetUserNoticeUnReadCount(ANoticeUnReadCount:Integer);

  public
    {$IFDEF HAS_FASTMSG}
    //最近会话页面
//    FRecentContactFrame:TFrameRecentContact;
    FIMClassifyFrame:TFrameIMClassify;
    procedure OnAddRecentItem(ABindingEvent: TBindingEvent);
    procedure LoadContactsListFrame;
    procedure SyncRecentContactFrameCaption(ARecentContactCaption:String='最近会话');
    procedure LoadRecentContactFrame;
    {$ENDIF}



  public
    procedure LoadMyFrame;
//    //刷新购物车商品
//    procedure UpDateMyCar;
//
//    //根据角色分配权限设置主页面
//    procedure SetUserPowers;
//  public
//    FBackgroundTimerThread:TTimerThread;
//    //通知详情
//    FNoticeFID:Integer;
//    FNotice:TNotice;
//    FOrder:TOrder;
//    FNoticeClassify:TNoticeClassify;
//
//    //详情
//    procedure DoGetNoticeExecute(ATimerTask:TObject);
//    procedure DoGetNoticeExecuteEnd(ATimerTask:TObject);
//  public
//    //获取订单接口
//    procedure DoGetNoticeOrderExecute(ATimerTask:TObject);
//    procedure DoGetNoticeOrderExecuteEnd(ATimerTask:TObject);
//  public
//      //根据不同通知跳转详情界面
//    procedure GetNoticeInfo(Frame:TFrame;ANotice:TNotice);
//  public
//    //获取未读通知数
//    procedure GetUserNoticeUnReadCount;
//    procedure DoGetUserNoticeUnReadCountExecute(ATimerTask:TObject);
//    procedure DoGetUserNoticeUnReadCountExecuteEnd(ATimerTask:TObject);
    { Public declarations }
  public
//    //显示订单页面(从付款页面返回)
//    procedure ShowOrderFrame;
//  public
//    procedure Load;
  public
//    //添加到购物车
//    procedure AddGoodsToUserCart(AShopFID:Integer;
//                                 AGoodsFID:Integer;
//                                 AGoodsCategoryFID:Integer;
//                                 ANumber:Integer;
//                                 AAttrValue:String;
//                                 AOrderno:Double);
//    //修改购物车商品数量
//    procedure UpdateCartGoodsNumber(ACartGoodsFID:Integer;ANumber:Integer);

  public
    procedure ScanQRCode;
    procedure DoReturnFrameFromQRCodeScannerFrame(AFrame:TFrame);
  public
    //获取并刷新未读消息数
    function SyncUnReadMsgCount:Integer;

  public
    //订单支付完显示订单界面
    procedure ShowOrderFrame;

    //更新我的购物车
    procedure UpDateMyCar;
    //添加到购物车
    procedure AddGoodsToUserCart(AShopFID:Integer;
                                 AGoodsFID:Integer;
                                 AGoodsCategoryFID:Integer;
                                 ANumber:Integer;
                                 AAttrValue:String;
                                 AOrderno:Double);
    //修改购物车商品数量
    procedure UpdateCartGoodsNumber(ACartGoodsFID:Integer;ANumber:Integer);

  public
    //开始定位
    procedure DoStartLocation;
    //定位改变
    procedure DoLocationChange;
    //定位超时
    procedure DoLocationTimeout;
    //定位启动失败
    procedure DoLocationStartError;

    //地址改变
    procedure DoLocationAddrChange;
    //地址解析失败了
    procedure DoGeocodeAddrError;
    //地址解析超时了
    procedure DoGeocodeAddrTimeout;
  end;




var
  GlobalMainFrame:TFrameMain;
  //订单是否修改过
  GlobalIsOrderInfoChanged:Boolean;


implementation

{$R *.fmx}

uses
  MainForm,
  LoginFrame,
//  OrderInfoFrame,
  NoticeListFrame,
//  TakeOrderFrame,
  ShopInfoFrame,
  uOpenCommon,
//  GoodsListFrame,
  RegisterProtocolFrame,
  SystemNotificationInfoFrame;


//procedure TFrameMain.AddGoodsToUserCart(AShopFID:Integer;
//                                 AGoodsFID:Integer;
//                                 AGoodsCategoryFID:Integer;
//                                 ANumber:Integer;
//                                 AAttrValue:String;
//                                 AOrderno:Double);
//var
//  ATimerTask:TTimerTask;
//begin
//  ATimerTask:=TTimerTask.Create;
//  ATimerTask.OnExecute:=DoAddUserCartExecute;
//  ATimerTask.OnExecuteEnd:=DoAddUserCartExecuteEnd;
//
//
////  Self.FFilterShopFID:=AShopFID;
////  Self.FFilterGoodsFID:=AGoodsFID;
////  Self.FFilterGoodsCategoryFID:=AGoodsCategoryFID;
////  Self.FFilterAttrValue:=AAttrValue;
////  Self.FFilterNumber:=ANumber;
////  Self.FFilterOrderno:=AOrderno;
//
//
//  ATimerTask.TaskOtherInfo.Values['FFilterShopFID']:=IntToStr(AShopFID);
//  ATimerTask.TaskOtherInfo.Values['FFilterGoodsFID']:=IntToStr(AGoodsFID);
//  ATimerTask.TaskOtherInfo.Values['FFilterGoodsCategoryFID']:=IntToStr(AGoodsCategoryFID);
//  ATimerTask.TaskOtherInfo.Values['FFilterAttrValue']:=AAttrValue;
//  ATimerTask.TaskOtherInfo.Values['FFilterNumber']:=IntToStr(ANumber);
//  ATimerTask.TaskOtherInfo.Values['FFilterOrderno']:=FloatToStr(AOrderno);
//
//
//  ShowWaitingFrame(Self,'添加中...');
//  uTimerTask.GetGlobalTimerThread.RunTask(ATimerTask);
//
//
//end;


procedure TFrameMain.AddGoodsToUserCart(AShopFID, AGoodsFID, AGoodsCategoryFID,
  ANumber: Integer; AAttrValue: String; AOrderno: Double);
var
  ATimerTask:TTimerTask;
begin
  ATimerTask:=TTimerTask.Create;
  ATimerTask.OnExecute:=DoAddUserCartExecute;
  ATimerTask.OnExecuteEnd:=DoAddUserCartExecuteEnd;


//  Self.FFilterShopFID:=AShopFID;
//  Self.FFilterGoodsFID:=AGoodsFID;
//  Self.FFilterGoodsCategoryFID:=AGoodsCategoryFID;
//  Self.FFilterAttrValue:=AAttrValue;
//  Self.FFilterNumber:=ANumber;
//  Self.FFilterOrderno:=AOrderno;


  ATimerTask.TaskOtherInfo.Values['FFilterShopFID']:=IntToStr(AShopFID);
  ATimerTask.TaskOtherInfo.Values['FFilterGoodsFID']:=IntToStr(AGoodsFID);
  ATimerTask.TaskOtherInfo.Values['FFilterGoodsCategoryFID']:=IntToStr(AGoodsCategoryFID);
  ATimerTask.TaskOtherInfo.Values['FFilterAttrValue']:=AAttrValue;
  ATimerTask.TaskOtherInfo.Values['FFilterNumber']:=IntToStr(ANumber);
  ATimerTask.TaskOtherInfo.Values['FFilterOrderno']:=FloatToStr(AOrderno);


  ShowWaitingFrame(Self,'添加中...');
  uTimerTask.GetGlobalTimerThread.RunTask(ATimerTask);



end;

procedure TFrameMain.btnAddContentClick(Sender: TObject);
begin
  //
  if not GlobalManager.IsLogin then
  begin
    ShowLoginFrame(True);
    Exit;
  end;


//  HideFrame;//(CurrentFrame);
//  ShowFrame(TFrame(GlobalAddContentFrame),TFrameAddContent,Self.FContentClassifyFrame.DoReturnFromAddContent);
//  GlobalAddContentFrame.Clear;
end;

procedure TFrameMain.ccbsBarCodeScanComletedCallbackEvent(Sender: TObject;
  const ResultCode: Integer; const ResultString: string);
begin
//  Self.pnlToolBar.Caption := '[' + formatdatetime('HH:mm:ss', now) + ']' + ResultString;



  //是网页
  //网页链接
  HideFrame;

  //显示网页界面
  ShowFrame(TFrame(GlobalWebBrowserFrame),TFrameWebBrowser,frmMain,nil,nil,nil,Application);
  GlobalWebBrowserFrame.LoadUrl(ResultString);

  FMX.Types.Log.d('OrnageUI Result:'+ResultString);

end;

procedure TFrameMain.ClickPushNotification(AUserCustomJson:ISuperObject;
                                            ATitle:String;
                                            ABody:String;
                                            AIsAtBackground:Boolean);
var
  AContentJson:ISuperObject;
begin

//  ShowMessage(AUserCustomJson.AsJSON);


  {"user_fid":571,"content_fid":234,"reply_to_comment_fid":0,"notice_sub_type":"comment_my_content"}
  if (AUserCustomJson<>nil)
    and AUserCustomJson.Contains('notice_sub_type')
    and ((AUserCustomJson.S['notice_sub_type']='comment_my_content')
        or (AUserCustomJson.S['notice_sub_type']='like_my_content')) then
  begin
      //跳转到动态详情
      //查看详情
      //显示内容详情
      frmMain.FDelayViewClickPushUserCustomJson:=AUserCustomJson;
      Self.DoDelayViewClickPushNotificationJson;

  end
  {"sender_userid":60157,"sender_username":"悟能","notice_sub_type":"fastmsg_chat"}
  else
  if (AUserCustomJson<>nil)
    and AUserCustomJson.Contains('notice_sub_type')
    and (AUserCustomJson.S['notice_sub_type']='fastmsg_chat') then
  begin
      //聊天消息
      frmMain.FDelayViewClickPushUserCustomJson:=AUserCustomJson;
      Self.DoDelayViewClickPushNotificationJson;

  end;
//      if (AOS='IOS') and Not AIsAtBackground then
//      begin
//          //在前台收到的消息
//          //弹出对话框
//          //播放声音
//    //      ShowMessage('您收到一条通知!'+#13#10+'('+ABody+')');
//          ShowMessage(ATitle+#13#10+'('+ABody+')');
//      end
//      else
//      begin
//          //点击在后台收到的消息
//
//
//      end;

end;

constructor TFrameMain.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited;

  FContentOperation:=TContentOperation.Create;


//  FBackgroundTimerThread:=TTimerThread.Create(True);
//  FNoticeClassify:=TNoticeClassify.Create;

//  FCarShopList:=TCarShopList.Create;

//  FOrder:=TOrder.Create;

  OutputDebugString('OrangeUI TFrameMain.Create');

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  Self.pcMain.SelfOwnMaterialToDefault.DrawTabCaptionParam.DrawEffectSetting.PushedEffect.FontColor.Color:=SkinThemeColor;

  FShop:=TShop.Create;

//  FIsFirstStart:=True;
//  //获取平台商家信息
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//               DoGetPlatformShopInfoExecute,
//               DoGetPlatformShopInfoExecuteEnd,
//               'GetPlatformShopInfo');


//  FSideMenuFrame:=TFrameSideMenu.Create(Self);
//  FSideMenuFrame.Parent:=Self.MultiView1;
//  FSideMenuFrame.Align:=TAlignLayout.Client;



//  MultiView1.Mode:=TMultiViewMode.Drawer;
//
////  Self.MultiView1.MasterButton:=Self.imgUserHead;//Self.btnShowSideBar;
//  MultiView1.TargetControl:=Self;
//
//
//
//  //暂时隐藏这四个分页
//  Self.pcMain.Prop.TabHeaderHeight:=0;



  Self.nniSessionUnReadMsg.Prop.Number:=0;

  

//  Self.pcMain.Prop.SwitchPageControlGestureManager.IsNeedDecideFirstGestureKind:=True;



//  //处理手势冲突
//  Self.lvHome.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
//  Self.lvHome.Prop.VertControlGestureManager.OnPrepareDecidedFirstGestureKind:=
//                                              Self.DoListBoxVertManagerPrepareDecidedFirstGestureKind;



//  tsHome.ParentMouseEvent:=True;
//  tsRecentContact.ParentMouseEvent:=True;
//  tsContactsList.ParentMouseEvent:=True;
//  tsMy.ParentMouseEvent:=True;
//


//  //双数的图片列表设置为跟随主题色变换
//  for I := 0 to Self.imgHomeIcons.PictureList.Count-1 do
//  begin
//    if I mod 2=1 then
//    begin
//      imgHomeIcons.PictureList[I].SkinThemeColor:=$FFFFCA4A;//SkinThemeColor;//
//      imgHomeIcons.PictureList[I].SkinThemeColorChange:=True;
//    end;
//  end;



end;

destructor TFrameMain.Destroy;
begin
//  FreeAndNil(FNoticeClassify);
//  FreeAndNil(FBackgroundTimerThread);

//  FreeAndNil(FOrder);

//  FreeAndNil(FCarShopList);

  FreeAndNil(FShop);

  FreeAndNil(FContentOperation);

  inherited;
end;


//procedure TFrameMain.DoGetNoticeExecute(ATimerTask: TObject);
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//
//  try
//    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_user_notice',
//                                                    nil,
//                                                    UserCenterInterfaceUrl,
//                                                    ['appid',
//                                                    'user_fid',
//                                                    'key',
//                                                    'notice_fid'
//                                                    ],
//                                                    [AppID,
//                                                    GlobalManager.User.fid,
//                                                    GlobalManager.User.key,
//                                                    FNoticeFID
//                                                    ],
//                                        GlobalRestAPISignType,
//                                        GlobalRestAPIAppSecret
//                                                    );
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
//
//end;
//
//procedure TFrameMain.DoGetNoticeExecuteEnd(ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//begin
//
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//
//          if FNotice.is_readed=1 then
//          begin
//            FNoticeClassify.notice_classify_unread_count:=FNoticeClassify.notice_classify_unread_count;
//          end
//          else
//          begin
//            //未读设置为已读
//            FNoticeClassify.notice_classify_unread_count:=FNoticeClassify.notice_classify_unread_count-1;
//
//            //返回需要刷新
//            GlobalIsNoticeListChanged:=True;
//          end;
//
//
//          FNotice.ParseFromJson(ASuperObject.O['Data'].A['Notice'].O[0]);
//          ASuperObject:=TSuperObject.Create(FNotice.custom_data_json);
//
//          //订单消息
//          if FNotice.notice_classify='order' then
//          begin
//            if ASuperObject.Contains('order_fid') then
//            begin
//                //是订单消息
//                FOrder.fid:=ASuperObject.I['order_fid'];
//
//                //订单详情
//                uTimerTask.GetGlobalTimerThread.RunTempTask(
//                              DoGetNoticeOrderExecute,
//                              DoGetNoticeOrderExecuteEnd);
//                //
//
//
//            end;
//          end
//          //其他消息
//          else if FNotice.notice_classify='other' then
//          begin
////            //酒店审核结果    FNotice.notice_sub_type='hotel_audit_result'
////            //挂钩信息、实名认证等
////            //有要用的属性就先借用了
////            FHotel.audit_user_name:=ASuperObject.S['audit_user_name'];
////            FHotel.audit_state:=ASuperObject.I['audit_state'];
////            FHotel.audit_remark:=ASuperObject.S['audit_remark'];
////            FHotel.audit_time:=FNotice.createtime;
////
////            //隐藏
////            HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
////
////            //审核意见
////            ShowFrame(TFrame(GlobalAuditInfoFrame),TFrameAuditInfo,frmMain,nil,nil,nil,Application);
////            GlobalAuditInfoFrame.Clear;
////            GlobalAuditInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//
//          end
//          else
//          begin
//
//            //隐藏
//            HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
//            //详情界面
//            ShowFrame(TFrame(GlobalSystemNotificationInfoFrame),TFrameSystemNotificationInfo,frmMain,nil,nil,nil,Application);
//            GlobalSystemNotificationInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//            //系统通知
//            if FNotice.notice_classify='system' then
//            begin
//              GlobalSystemNotificationInfoFrame.Load('公告详情',FNotice);
//            end
//            //站内信
//            else if FNotice.notice_classify='mail' then
//            begin
//              GlobalSystemNotificationInfoFrame.Load('消息详情',FNotice);
//            end;
//          end;
//
//      end
//      else
//      begin
//        //获取失败
//        ShowMessageBoxFrame(frmMain,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
//
//      end;
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(frmMain,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    HideWaitingFrame;
//  end;
//end;


//procedure TFrameMain.DoGetNoticeOrderExecute(ATimerTask: TObject);
//begin
//  FMX.Types.Log.d('OrangeUI DoGetOrderExecute');
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//  try
//    TTimerTask(ATimerTask).TaskDesc:=
//                          SimpleCallAPI('user_get_order',
//                          nil,
//                          ShopCenterInterfaceUrl,
//                          [
//                          'appid',
//                          'user_fid',
//                          'key',
//                          'order_fid'
//                          ],
//                          [AppID,
//                          GlobalManager.User.fid,
//                          GlobalManager.User.key,
//                          Self.FOrder.fid
//                          ],
//                                        GlobalRestAPISignType,
//                                        GlobalRestAPIAppSecret
//                          );
//
//    if TTimerTask(ATimerTask).TaskDesc<>'' then
//    begin
//      TTimerTask(ATimerTask).TaskTag:=0;
//    end;
//
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
//procedure TFrameMain.DoGetNoticeOrderExecuteEnd(ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//begin
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//
//      FMX.Types.Log.d('OrangeUI ASuperObject'+ASuperObject.AsJSON);
//      if ASuperObject.I['Code']=200 then
//      begin
//        FMX.Types.Log.d('OrangeUI Code:200');
//        //刷新订单信息
//        FOrder.ParseFromJson(ASuperObject.O['Data'].A['OrderInfo'].O[0]);
//
//        //订单详情
//        //隐藏
//        HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
//
//
////        ShowFrame(TFrame(GlobalOrderInfoFrame),TFrameOrderInfo);
////        GlobalOrderInfoFrame.FrameHistroy:=CurrentFrameHistroy;
////        GlobalOrderInfoFrame.Load(FOrder);
////        GlobalOrderInfoFrame.Sync;
//
////        FNotice.is_readed:=1;
//
//      end
//      else
//      begin
//        //获取订单失败
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
//  end;
//end;

procedure TFrameMain.DoGetPlatformShopInfoExecute(ATimerTask: TObject);
begin
// 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=
      SimpleCallAPI('get_platform_shop',
                      nil,
                      ShopCenterInterfaceUrl,
                      ['appid',
                      'user_fid',
                      'key'],
                      [AppID,
                      GlobalManager.User.fid,
                      GlobalManager.User.key],
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

procedure TFrameMain.DoGetPlatformShopInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        FShop.ParseFromJSON(ASuperObject.O['Data'].A['PlatformShopInfo'].O[0]);
        //平台商家信息
        FPlatformShopFID:=ASuperObject.O['Data'].A['PlatformShopInfo'].O[0].I['fid'];
//        Self.lbProList.Prop.StartPullDownRefresh;
//
//        Self.FIsDoBusiness:=Self.IsDoBusiness(FShop);
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
    //不需要
    HideWaitingFrame;

//    //假如这一次也没取到的话  至少能跳转界面
//    //第一次没取到平台商家FID  切换界面的时候重新取完跳转界面
//    if Not FIsFirstStart then
//    begin
//      FShopInfoFrame.Load(FPlatformShopFID,nil,FShopInfoFrame);
//    end;
  end;


end;

procedure TFrameMain.DoGetUserCarGoodsListExecute(ATimerTask:TObject);
begin
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_user_cart_goods_list',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'longitude',
                                                      'latitude'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      GlobalManager.Longitude,
                                                      GlobalManager.Latitude
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

procedure TFrameMain.DoGetUserCarGoodsListExecuteEnd(ATimerTask:TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag= 0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        GlobalManager.UserCarShopList.Clear(True);
        GlobalManager.UserCarShopList.ParseFromJsonArray(TCarShop,ASuperObject.O['Data'].A['CartGoodsList']);

        //更新购物车数量
        UpDateUserCartCount(GlobalManager.UserCarShopList);

        if GlobalShopInfoFrame<>nil then
        begin
          GlobalShopInfoFrame.UpDateShopInfo;
        end;

        if GlobalPlatformShopInfoFrame<>nil then
        begin
          GlobalPlatformShopInfoFrame.UpDateShopInfo;
        end;

//        if FShopInfoFrame<>nil then
//        begin
//          FShopInfoFrame.UpDateShopInfo;
//        end;

//        if GlobalGoodsListFrame<>nil then
//        begin
//          GlobalGoodsListFrame.UpdateMyCarFrame;
//        end;

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

  end;
end;

//procedure TFrameMain.DoGetUserNoticeUnReadCountExecute(ATimerTask: TObject);
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//  try
//    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_user_notice_unread_count',
//                                                    nil,
//                                                    UserCenterInterfaceUrl,
//                                                    ['appid',
//                                                    'user_fid',
//                                                    'key'],
//                                                    [AppID,
//                                                    GlobalManager.User.fid,
//                                                    GlobalManager.User.key
//                                                    ],
//                                        GlobalRestAPISignType,
//                                        GlobalRestAPIAppSecret
//                                                    );
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
//procedure TFrameMain.DoGetUserNoticeUnReadCountExecuteEnd(ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//begin
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//
//        //获取未读通知数
//        GlobalManager.User.notice_unread_count:=ASuperObject.O['Data'].I['notice_unread_count'];
//
//        if FMyFrame<>nil then
//        begin
//          FMyFrame.nniNumber.Prop.Number:=GlobalManager.User.notice_unread_count;
//        end;
////        if FOrderListFrame<>nil then
////        begin
////          FOrderListFrame.nniNumber.Prop.Number:=GlobalManager.User.notice_unread_count;
////        end;
////        if FHomeFrame<>nil then
////        begin
////          FHomeFrame.nniNumber.Prop.Number:=GlobalManager.User.notice_unread_count;
////        end;
////        if FEmpHomeFrame<>nil then
////        begin
////          FEmpHomeFrame.nniNumber.Prop.Number:=GlobalManager.User.notice_unread_count;
////        end;
//
//
//      end;
//
//    end;
//  finally
//
//  end;
//
//end;


//procedure TFrameMain.GetNoticeInfo(Frame: TFrame; ANotice: TNotice);
//begin
//  ShowWaitingFrame(Frame,'加载中...');
//  FNoticeFID:=ANotice.fid;
//  FNotice:=ANotice;
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                                              DoGetNoticeExecute,
//                                              DoGetNoticeExecuteEnd);
//end;
//
//procedure TFrameMain.GetUserNoticeUnReadCount;
//begin
//  if GlobalManager.IsLogin then
//  begin
//    FBackgroundTimerThread.RunTempTask(
//                               DoGetUserNoticeUnReadCountExecute,
//                               DoGetUserNoticeUnReadCountExecuteEnd);
//  end;
//end;

//procedure TFrameMain.Load;
//begin
//  //显示首页
//  Self.pcMain.Prop.ActivePage:=GlobalMainFrame.tsHome;
//  Self.pcMainChange(Self.pcMain);
//
//end;

//procedure TFrameMain.LoadFrame;
//begin
////  AIsUpDate:=False;
////
//  if GlobalManager.IsLogin=False then
//  begin
//
//      if Self.FMyFrame<>nil then
//      begin
//        Self.FMyFrame.Load;
//      end;
//
//      if Self.FHomeFrame<>nil then
//      begin
//        Self.FHomeFrame.Init(nil);
//      end;
//
//
////      if Self.FUserOrderListFrame<>nil then
////      begin
////        Self.FUserOrderListFrame.Init;
////      end;
//
//      if Self.FContentClassifyFrame<>nil then
//      begin
//        Self.FContentClassifyFrame.Init;
//      end;
//
//  end
//  else
//  begin
//      //获取未读通知数
//      frmMain.GetUserNoticeUnReadCount;
//
////      if Self.FMyFrame<>nil then
////      begin
////        //刷新红包个数
////        Self.FMyFrame.GetCouponCount;
////      end;
//  end;
//end;
{$IFDEF HAS_FASTMSG}

procedure TFrameMain.LoadContactsListFrame;
begin
//    IsFirstCreate:=FContactsListFrame=nil;
//    if IsFirstCreate then
//    begin
//      //加载缓存数据
//      GlobalClient.ContactManager.LoadFromCacheDataBase;
//    end;
//
//    ShowFrame(TFrame(FContactsListFrame),TFrameContactsList,Self.tsContactsList,nil,nil,nil,Self,False,True,ufsefNone);
////    if IsFirstCreate then
//    FContactsListFrame.Load(False);
////    FContactsListFrame.lbContact.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;


  if (FIMClassifyFrame<>nil) and (FIMClassifyFrame.FContactsListFrame<>nil) then
  begin
    FIMClassifyFrame.FContactsListFrame.Load(FIMClassifyFrame.FContactsListFrame.btnReturn.Visible);
  end;

//    ShowFrame(TFrame(FIMClassifyFrame),TFrameIMClassify,Self.tsContactsList,nil,nil,nil,Self,False,True,ufsefNone);
////    if IsFirstCreate then
//    FIMClassifyFrame.Load;//(False);


//    FContactsListFrame.lbContact.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;

end;

procedure TFrameMain.LoadRecentContactFrame;
begin
//    IsFirstCreate:=FContactsListFrame=nil;
//    if IsFirstCreate then
//    begin
//      //加载缓存数据
//      GlobalClient.ContactManager.LoadFromCacheDataBase;
//    end;

//    ShowFrame(TFrame(FRecentContactFrame),TFrameRecentContact,Self.tsRecentContact,nil,nil,nil,Self,False,True,ufsefNone);
////    if IsFirstCreate then
//    FRecentContactFrame.Load(False);

//    ShowFrame(TFrame(FIMClassifyFrame),TFrameIMClassify,Self.tsRecentContact,nil,nil,nil,Self,False,True,ufsefNone);
////    if IsFirstCreate then
//    FIMClassifyFrame.Load;//(False);

  if (FIMClassifyFrame<>nil) and (FIMClassifyFrame.FRecentContactFrame<>nil) then
  begin
    FIMClassifyFrame.FRecentContactFrame.Load(FIMClassifyFrame.FRecentContactFrame.btnReturn.Visible);
  end;


//      if (GlobalMainFrame<>nil) and (GlobalMainFrame.FRecentContactFrame<>nil) then
//      begin
//        GlobalMainFrame.FRecentContactFrame.Load(GlobalMainFrame.FRecentContactFrame.btnReturn.Visible);
//      end;

end;

procedure TFrameMain.SyncRecentContactFrameCaption(ARecentContactCaption:String='最近会话');
begin
//    IsFirstCreate:=FContactsListFrame=nil;
//    if IsFirstCreate then
//    begin
//      //加载缓存数据
//      GlobalClient.ContactManager.LoadFromCacheDataBase;
//    end;

//    ShowFrame(TFrame(FRecentContactFrame),TFrameRecentContact,Self.tsRecentContact,nil,nil,nil,Self,False,True,ufsefNone);
////    if IsFirstCreate then
//    FRecentContactFrame.Load(False);

//    ShowFrame(TFrame(FIMClassifyFrame),TFrameIMClassify,Self.tsRecentContact,nil,nil,nil,Self,False,True,ufsefNone);
////    if IsFirstCreate then
//    FIMClassifyFrame.Load;//(False);

  if (FIMClassifyFrame<>nil) and (FIMClassifyFrame.FRecentContactFrame<>nil) then
  begin
    FIMClassifyFrame.FRecentContactFrame.pnlToolBar.Caption:=ARecentContactCaption;
  end;


//      if (GlobalMainFrame<>nil) and (GlobalMainFrame.FRecentContactFrame<>nil) then
//      begin
//        GlobalMainFrame.FRecentContactFrame.Load(GlobalMainFrame.FRecentContactFrame.btnReturn.Visible);
//      end;

end;

procedure TFrameMain.OnAddRecentItem(ABindingEvent: TBindingEvent);
begin
  if (Self.FIMClassifyFrame<>nil) and (FIMClassifyFrame.FRecentContactFrame<>nil) then
  begin
    FIMClassifyFrame.FRecentContactFrame.OnAddRecentItem(ABindingEvent);
  end;
end;

{$ENDIF}

procedure TFrameMain.LoadMyFrame;
begin
//    IsFirstCreate:=FMyFrame=nil;
    ShowFrame(TFrame(FMyFrame),TFrameMy,Self.tsMy,nil,nil,nil,Self,False,True,ufsefNone);
//    if IsFirstCreate then
//    begin
      FMyFrame.Load;
//    end
//    else
//    begin
////      FMyFrame.GetWallet;
////      FMyFrame.GetUserInfo;
//    end;
//    FMyFrame.lvMy.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;

end;

procedure TFrameMain.Login(AIsOnlineLogin:Boolean);
//var
//  AIsFirst:Boolean;
begin
  //避免重复登录
  if (FUserFID<>'') and (FUserFID=GlobalManager.User.fid) then
  begin
    Exit;
  end;
//  LoadFrame;
  FUserFID:=GlobalManager.User.fid;





//  if FHomeFrame<>nil then
//  begin
//    Self.FHomeFrame.Load('news');
//  end;


//  AIsFirst:=(FContentClassifyFrame=nil);




  //头像
  imgUserHead.Prop.Picture.ImageIndex:=-1;
  imgUserHead.Prop.Picture.Url:=GlobalManager.User.GetHeadPicUrl;
  imgUserHead.Prop.Picture.IsClipRound:=True;


  Self.pcMain.Prop.ActivePage:=nil;
  Self.pcMain.Prop.ActivePage:=Self.tsHome;

  if FHomeFrame<>nil then
  begin
    Self.FHomeFrame.ShowUserHeadImage;
  end;


  if FHomeFrame=nil then
  begin
    //显示首页
    Self.tsHome.TabVisible:=False;
//    Self.pcMain.Prop.ActivePage:=Self.tsHome;
    Self.pcMain.Prop.ActivePage:=Self.tsCommunity;
  end;

  Self.pcMainChange(Self.pcMain);



  //是否需要平台商城分页
  Self.tsShop.Prop.TabVisible:=GlobalIsNeedPlatformShopPage;



//  if Not DirectoryExists('E:\MyFiles') then
//  begin
//    Self.tsSend.Prop.TabVisible:=False;
//  end
//  else
//  begin
//    Self.tsSend.Prop.TabVisible:=True;
//  end;

//  if not AIsFirst and (FContentClassifyFrame<>nil) and (FContentClassifyFrame.FContentListFrame_Best<>nil) then
//  begin
//    Self.FContentClassifyFrame.FContentListFrame_Best.Load;
//  end;


  tmrDelayLoad.Enabled:=True;
end;

procedure TFrameMain.Logout;
begin
  //头像
  imgUserHead.Prop.Picture.ImageIndex:=0;
  imgUserHead.Prop.Picture.Url:='';



//  FSideMenuFrame.Load;

  if FHomeFrame<>nil then
  begin
    Self.FHomeFrame.Load;
  end;




//  if (FContentClassifyFrame<>nil) and (FContentClassifyFrame.FContentListFrame_Best<>nil) then
//  begin
//    Self.FContentClassifyFrame.FContentListFrame_Best.Load;
//  end;


//  FreeAndNil(FContentClassifyFrame);


//  //停止更新个人信息
//  tmrGetMyInfo.Enabled:=False;
  //退出登录  清空密码
//  uManager.GlobalManager.LastLoginCapcha:='';
//  //保存INI
//  uManager.GlobalManager.Save;

end;

procedure TFrameMain.pcMainChange(Sender: TObject);
var
  IsFirstCreate:Boolean;
//var
//  ADesc:String;
//  ALoadDataSetting:TLoadDataSetting;
//  AFieldControlSetting:TFieldControlSetting;
//  AListItemBindingItem:TListItemBindingItem;
//  I: Integer;
begin

//  LoadFrame;



//  Exit;
//  Self.pcMain.Prop.CanGesutreSwitch:=True;
//  tsHome.ParentMouseEvent:=True;
//  tsRecentContact.ParentMouseEvent:=True;
//  tsContactsList.ParentMouseEvent:=True;
//  tsMy.ParentMouseEvent:=True;
//  Exit;





  //首页
  if Self.pcMain.Prop.ActivePage=tsHome then
  begin
      IsFirstCreate:=FHomeFrame=nil;
      ShowFrame(TFrame(FHomeFrame),TFrameHome,Self.tsHome,nil,nil,nil,Self,False,True,ufsefNone);
      if IsFirstCreate or (FHomeFrame.FUserFID<>GlobalManager.User.fid) then
      begin
        FHomeFrame.Load;
      end;

      FHomeFrame.lbNewsContentClassify.RefMaterial:=dmCommonImageDataMoudle.lbNewsContentClassify_Material;
      FHomeFrame.lbNewsContentClassify.MaterialUseKind:=TMaterialUseKind.mukRef;

      FHomeFrame.btnAddContent.RefMaterial:=dmCommonImageDataMoudle.btnAddContent_Material;
      FHomeFrame.btnAddContent.MaterialUseKind:=TMaterialUseKind.mukRef;

//      ShowFrame(TFrame(FHomeFrame),TFrameContentClassify,Self.tsHome,nil,nil,nil,Self,False,True,ufsefNone);
//      if IsFirstCreate then FHomeFrame.Load
//                                            ('news',
//                                            'ContentNews',
//                                            88,
//                                            True,
//                                            False);

//      FHomeFrame.lvHome.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
      Exit;

  end;



  //社区
  if Self.pcMain.Prop.ActivePage=tsCommunity then
  begin
    IsFirstCreate:=FContentClassifyFrame=nil;
    ShowFrame(TFrame(FContentClassifyFrame),TFrameContentClassify,Self.tsCommunity,nil,nil,nil,Self,False,True,ufsefNone);

    FContentClassifyFrame.pnlToolbar.RefMaterial:=dmCommonImageDataMoudle.pnlToolBarMaterial;

    FContentClassifyFrame.btnAddContent.Prop.Icon.Clear;
    FContentClassifyFrame.btnAddContent.Prop.Icon.SkinImageList:=dmCommonImageDataMoudle.imglistOthers;
    FContentClassifyFrame.btnAddContent.Prop.Icon.ImageName:='add_content';

    FContentClassifyFrame.btnJumpToSearch.Prop.Icon.Clear;
    FContentClassifyFrame.btnJumpToSearch.Prop.Icon.SkinImageList:=dmCommonImageDataMoudle.imglistOthers;
    FContentClassifyFrame.btnJumpToSearch.Prop.Icon.ImageName:='search_content';


    FContentClassifyFrame.btnAddContent.RefMaterial:=dmCommonImageDataMoudle.btnAddContent_Material;
    FContentClassifyFrame.btnAddContent.MaterialUseKind:=TMaterialUseKind.mukRef;


    FContentClassifyFrame.lbFilterClassify.RefMaterial:=dmCommonImageDataMoudle.lbNewsContentClassify_Material;
    FContentClassifyFrame.lbFilterClassify.MaterialUseKind:=TMaterialUseKind.mukRef;

    if IsFirstCreate or (FContentClassifyFrame.FUserFID<>GlobalManager.User.fid) then
    begin
      FContentClassifyFrame.Load;
    end;


  end;




  {$IFDEF HAS_FASTMSG}
  //最近会话
  if Self.pcMain.Prop.ActivePage=tsRecentContact then
  begin


//    IsFirstCreate:=FContactsListFrame=nil;
////    if IsFirstCreate then
////    begin
////      //加载缓存数据
////      GlobalClient.ContactManager.LoadFromCacheDataBase;
////    end;
//    ShowFrame(TFrame(FRecentContactFrame),TFrameRecentContact,Self.tsRecentContact,nil,nil,nil,Self,False,True,ufsefNone);
////    if IsFirstCreate then
//    FRecentContactFrame.Load(False);


//    LoadRecentContactFrame;
    ShowFrame(TFrame(FIMClassifyFrame),TFrameIMClassify,Self.tsRecentContact,nil,nil,nil,Self,False,True,ufsefNone);

    FIMClassifyFrame.pnlToolbar.RefMaterial:=dmCommonImageDataMoudle.pnlToolBarMaterial;

    FIMClassifyFrame.lbFilterClassify.RefMaterial:=dmCommonImageDataMoudle.lbNewsContentClassify_Material;
    FIMClassifyFrame.lbFilterClassify.MaterialUseKind:=TMaterialUseKind.mukRef;

                                     //add_contact
//    if IsFirstCreate then
    FIMClassifyFrame.Load;//(False);


    FIMClassifyFrame.FRecentContactFrame.btnAdd.Prop.Icon.Clear;
    FIMClassifyFrame.FRecentContactFrame.btnAdd.Prop.Icon.SkinImageList:=dmCommonImageDataMoudle.imglistOthers;
    FIMClassifyFrame.FRecentContactFrame.btnAdd.Prop.Icon.ImageName:='add_contact';

//    FRecentContactFrame.lbContact.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
  end;

  {$ENDIF}



  //商店
  if Self.pcMain.Prop.ActivePage=tsShop then
  begin
      if FPlatformShopFID<>0 then
      begin
          IsFirstCreate:=GlobalPlatformShopInfoFrame=nil;
    //    ShowFrame(TFrame(FUserGameInfo),TMyGameInfoFrame,Self.tsMyGame,nil,nil,nil,Self,False,True,ufsefNone);
    //    if IsFirstCreate then FUserGameInfo.Load;

    //      HideFrame;//(GlobalMainFrame);

          ShowFrame(TFrame(GlobalPlatformShopInfoFrame),TFrameShopInfo,Self.tsShop,nil,nil,nil,Self,False,True,ufsefNone);
          GlobalPlatformShopInfoFrame.pnlToolbar.RefMaterial:=dmCommonImageDataMoudle.pnlToolBarMaterial;
          GlobalPlatformShopInfoFrame.pnlToolbar.MaterialUseKind:=mukRef;


          if IsFirstCreate or (GlobalPlatformShopInfoFrame.FUserFID<>GlobalManager.User.fid) then
          begin
    //      GlobalPlatformShopInfoFrame.FrameHistroy:=CurrentFrameHistroy;
            //下面这一句要去掉  问题待修改
      //      GlobalShopInfoFrame:=FShopInfoFrame;
            GlobalPlatformShopInfoFrame.Clear;
            GlobalPlatformShopInfoFrame.IsShowBackBtn(False);
            //FPlatformShopFID:=85;
              GlobalPlatformShopInfoFrame.Load(FPlatformShopFID,nil,GlobalPlatformShopInfoFrame);
          end;
      end;

      if Self.FPlatformShopFID=0 then
      begin
//        FIsFirstStart:=False;
        //获取平台商家信息
        uTimerTask.GetGlobalTimerThread.RunTempTask(
                     DoGetPlatformShopInfoExecute,
                     DoGetPlatformShopInfoExecuteEnd,
                     'GetPlatformShopInfo');
      end;

      Exit;
  end;



//  //通讯录
//  if Self.pcMain.Prop.ActivePage=tsContactsList then
//  begin
//
////    IsFirstCreate:=FContactsListFrame=nil;
//////    if IsFirstCreate then
//////    begin
//////      //加载缓存数据
//////      GlobalClient.ContactManager.LoadFromCacheDataBase;
//////    end;
////    ShowFrame(TFrame(FContactsListFrame),TFrameContactsList,Self.tsContactsList,nil,nil,nil,Self,False,True,ufsefNone);
//////    if IsFirstCreate then
////    FContactsListFrame.Load(False);
//////    FContactsListFrame.lbContact.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
//
//
////    LoadContactsListFrame;
//
//  end;


  //我的
  if Self.pcMain.Prop.ActivePage=tsMy then
  begin
//    IsFirstCreate:=FMyFrame=nil;
//    ShowFrame(TFrame(FMyFrame),TFrameMy,Self.tsMy,nil,nil,nil,Self,False,True,ufsefNone);
////    if IsFirstCreate then
////    begin
//      FMyFrame.Load;
////    end
////    else
////    begin
//////      FMyFrame.GetWallet;
//////      FMyFrame.GetUserInfo;
////    end;
////    FMyFrame.lvMy.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;

    LoadMyFrame;

  end;



//  if Self.pcMain.Prop.ActivePage=tsOrder then
//  begin
//    IsFirstCreate:=FUserOrderListFrame=nil;
//    ShowFrame(TFrame(FUserOrderListFrame),TFrameUserOrderList,Self.tsOrder,nil,nil,nil,Self,False,True,ufsefNone);
//    FUserOrderListFrame.FTitle:='一公里';
//    FUserOrderListFrame.FHelpText:=Const_RegisterLoginType_PhoneNum;
//    if IsFirstCreate then FUserOrderListFrame.Init;
//  end;


//  if Self.pcMain.Prop.ActivePage=tsTel then
//  begin
//    IsFirstCreate:=FTelMainFrame=nil;
//    ShowFrame(TFrame(FTelMainFrame),TFrameTelMain,Self.tsTel,nil,nil,nil,Self,False,True,ufsefNone);
//    FTelMainFrame.Load;
//  end;





//  if Self.pcMain.Prop.ActivePage=tsShoping then
//  begin
//      //跳到店铺详情界面
//      IsFirstCreate:=FShopInfoFrame=nil;
//      ShowFrame(TFrame(FShopInfoFrame),TFrameShopInfo,Self.tsShoping,nil,nil,nil,Self,False,True,ufsefNone);
//      if IsFirstCreate then
//      begin
//        //下面这一句要去掉  问题待修改
//  //      GlobalShopInfoFrame:=FShopInfoFrame;
//        FShopInfoFrame.Clear;
//        FShopInfoFrame.IsShowBackBtn(False);
//        if FPlatformShopFID<>0 then FShopInfoFrame.Load(FPlatformShopFID,nil,FShopInfoFrame);
//        if FPlatformShopFID=0 then
//        begin
//          FIsFirstStart:=False;
//          //获取平台商家信息
//          uTimerTask.GetGlobalTimerThread.RunTempTask(
//                       DoGetPlatformShopInfoExecute,
//                       DoGetPlatformShopInfoExecuteEnd,
//                       'GetPlatformShopInfo');
//        end;
//      end;
//  //    FShopInfoFrame.IsShowBackBtn(False);
//  //    FShopInfoFrame.Load(FPlatformShopFID,nil,FShopInfoFrame);
//
//  //    IsFirstCreate:=FShopingFrame=nil;
//  //    ShowFrame(TFrame(FShopingFrame),TFrameShoping,Self.tsShoping,nil,nil,nil,Self,False,True,ufsefNone);
//  //    if IsFirstCreate then FShopingFrame.Init;
//  end
//  else
//  begin
//      //在平台商家界面点击下方购物车弹出AddCarGoodsFrame后再点pcControl时要隐藏
//      if FShopInfoFrame<>nil then
//      begin
//        FShopInfoFrame.HideAddCarGoodsFrame;
//      end;
//  end;

end;

procedure TFrameMain.PorcessGetUserNoticeUnReadCount(ANoticeUnReadCount: Integer);
begin

end;

procedure TFrameMain.ProcessGetNotice(ANotice: TNotice;ASuperObject: ISuperObject);
begin
//  //订单消息
//  if ANotice.notice_classify='order' then
//  begin
//    if ASuperObject.Contains('order_fid') then
//    begin
//        //是订单消息
//        FOrder.fid:=ASuperObject.I['order_fid'];
//
//        //订单详情
//        uTimerTask.GetGlobalTimerThread.RunTempTask(
//                      DoGetNoticeOrderExecute,
//                      DoGetNoticeOrderExecuteEnd,
//                      'GetNoticeOrder');
//    end;
//  end
//  //其他消息
//  else if ANotice.notice_classify='other' then
//  begin
////            //酒店审核结果    ANotice.notice_sub_type='hotel_audit_result'
////            //挂钩信息、实名认证等
////            //有要用的属性就先借用了
////            FHotel.audit_user_name:=ASuperObject.S['audit_user_name'];
////            FHotel.audit_state:=ASuperObject.I['audit_state'];
////            FHotel.audit_remark:=ASuperObject.S['audit_remark'];
////            FHotel.audit_time:=ANotice.createtime;
////
////            //隐藏
////            HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
////
////            //审核意见
////            ShowFrame(TFrame(GlobalAuditInfoFrame),TFrameAuditInfo,frmMain,nil,nil,nil,Application);
////            GlobalAuditInfoFrame.Clear;
////            GlobalAuditInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//
//  end
//  else
//  begin
//
//    //隐藏
//    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
//    //详情界面
//    ShowFrame(TFrame(GlobalSystemNotificationInfoFrame),TFrameSystemNotificationInfo,frmMain,nil,nil,nil,Application);
////    GlobalSystemNotificationInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//    //系统通知
//    if ANotice.notice_classify='system' then
//    begin
//      GlobalSystemNotificationInfoFrame.Load('公告详情',ANotice);
//    end
//    //站内信
//    else if ANotice.notice_classify='mail' then
//    begin
//      GlobalSystemNotificationInfoFrame.Load('消息详情',ANotice);
//    end
//    else
//    begin
//      GlobalSystemNotificationInfoFrame.Load('消息详情',ANotice);
//    end;
//  end;
end;

procedure TFrameMain.ScanQRCode;
begin
  FMX.Types.Log.d('OrangeUI TFrameMain.ScanQRCode');


//  {$IFDEF IOS}
//    if ccbsBarCode=nil then
//    begin
//      ccbsBarCode:=TCCBarcodeScanner.Create(Self);
//    end;
//
////  object ccbsBarCode: TCCBarcodeScanner
////    SdkConfig.ShowScanFromPhotoButton = True
////    SdkConfig.Scan_Title = #20108#32500#30721'/'#26465#30721
////    SdkConfig.Scan_Tips = #23558#20108#32500#30721'/'#26465#30721#25918#20837#26694#20869#65292#21363#21487#33258#21160#25195#25551
////    SdkConfig.Flashlight = False
////    SdkConfig.Vibrate = True
////    SdkConfig.VibrateDuartion = 200
////    SdkConfig.PlayVoice = True
////    SdkConfig.Voice_Scan_Succeeded = 'scan_succeeded.mp3'
////    SdkConfig.ToastResult = True
////    SdkConfig.ScreenOrientation = Portrait
////    OnScanComletedCallbackEvent = ccbsBarCodeScanComletedCallbackEvent
////    Left = 233
////    Top = 122
////  end
//
//
//  //扫描二维码
//  ccbsBarCode.SdkConfig.Scan_Title := '二维码扫描';
//  ccbsBarCode.SdkConfig.Scan_Tips := '将二维码放入框内，即可自动扫描';
//  ccbsBarCode.SdkConfig.Vibrate := True;
//  ccbsBarCode.SdkConfig.PlayVoice := True;
//  ccbsBarCode.SdkConfig.ToastResult := True;
//
//  ccbsBarCode.SdkConfig.Flashlight := False;
//
//  self.ccbsBarCode.StartScan(); // 结果在事件中返回
//
//  {$ELSE}
//
////  ShowFrame(TFrame(GlobalQRCodeScannerFrame),TFrameQRCodeScanner//);
////        ,Application.MainForm,nil,nil,DoReturnFrameFromQRCodeScannerFrame,nil,True,
////        True,ufsefNone);
////  GlobalQRCodeScannerFrame.StartScan;
//
//  {$ENDIF}
end;

procedure TFrameMain.ShowOrderFrame;
begin

end;

procedure TFrameMain.ShowSideMenuFrame;
begin
//  if not GlobalManager.IsLogin then
//  begin
//    ShowLoginFrame(True);
//    Exit;
//  end;
//
//  if FSideMenuFrame=nil then
//  begin
//    FSideMenuFrame:=TFrameSideMenu.Create(Self);
//    FSideMenuFrame.Parent:=Self.MultiView1;
//    FSideMenuFrame.Align:=TAlignLayout.Client;
//  end;
//  //
//  Self.FSideMenuFrame.Load;
//
//  Self.MultiView1.ShowMaster;
//  Self.MultiView1.Visible:=True;

end;

function TFrameMain.SyncUnReadMsgCount:Integer;
begin
  Result:=0;

  {$IFDEF HAS_FASTMSG}
  //更新首页的未读数
  Result:=
    GlobalClient.Notifications.ChatMsgs.UnReadCount
    +GlobalClient.Notifications.GroupChatMsgs.UnReadCount;

  Self.nniSessionUnReadMsg.Prop.Number:=Result;



  //wn
//  if (GlobalMainFrame<>nil) and (GlobalMainFrame.FRecentContactFrame<>nil) then
//  begin
//    GlobalMainFrame.FRecentContactFrame.SyncUnReadMsgCount;
//  end;
  if (Self.FIMClassifyFrame<>nil) and (FIMClassifyFrame.FRecentContactFrame<>nil) then
  begin
    FIMClassifyFrame.FRecentContactFrame.SyncUnReadMsgCount;
  end;


//    GlobalClient.Notifications.GetUnReadCount;
  {$ENDIF}

end;

//procedure TFrameMain.ShowOrderFrame;
//begin
//  //隐藏
//  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
//
//  //显示主界面
//  ShowFrame(TFrame(GlobalMainFrame),TFrameMain,frmMain,nil,nil,nil,Application,True,True,ufsefNone);
////  GlobalMainFrame.FrameHistroy:=CurrentFrameHistroy;
//
//
////  GlobalMainFrame.pcMain.Prop.ActivePage:=tsOrder;
//
//
//
//
////  ShowFrame(TFrame(GlobalUserOrderListFrame),TFrameUserOrderList,frmMain,nil,nil,nil,Self,False,True,ufsefNone);
////  GlobalUserOrderListFrame.FTitle:='一公里';
//////  GlobalUserOrderListFrame.FHelpText:=Const_RegisterLoginType_PhoneNum;
////  GlobalUserOrderListFrame.Init;
////  GlobalUserOrderListFrame.btnReturn.Visible:=True;
//
//
//
//
////  //刷新订单页面
////  if FUserOrderListFrame<>nil then
////  begin
////    FUserOrderListFrame.Init;
////  end;
//end;

procedure TFrameMain.tmrDelayLoadTimer(Sender: TObject);
begin
    tmrDelayLoad.Enabled:=False;



    if GlobalManager.AppJson<>nil then
    begin
      tmrDelayLoad.Enabled:=False;
      //初始MainFrame
      //          GlobalMainFrame.Load(ASuperObject.O['Data']);

      if (GlobalManager.AppJson.S['nonce']<>'') and (GlobalManager.LastNonce<>GlobalManager.AppJson.S['nonce']) then
      begin
        //有新公告
        ShowMessageBoxFrame(Application.MainForm,
                            GlobalManager.AppJson.S['nonce'],
                            '',
                            TMsgDlgType.mtCustom,
                            ['确定'],
                            nil,
                            nil,
                            '公告'
                            );

        uManager.GlobalManager.LastNonce:=GlobalManager.AppJson.S['nonce'];
        GlobalManager.Save;
      end;

    end;



    //根据配置文件判断是否显示注册协议
    GlobalManager.Load;
    if GlobalManager.IsFirstStart=True then
    begin

        //个别用户显示不出这个按钮
        //选择同意，保存变量，销毁页面
        GlobalManager.IsFirstStart:=False;
        GlobalManager.Save;


        HideVirtualKeyboard;

//              FreeAndNil(GlobalRegisterProtocolFrame);//不释放,可能会报错
        //查看协议
        ShowFrame(TFrame(GlobalRegisterProtocolFrame),TFrameRegisterProtocol,GlobalMainFrame,nil,nil,nil,Application,False,False,ufsefNone);
        GlobalRegisterProtocolFrame.Load(Const_APPName+'APP注册协议',
                                        //'http://'+Const_Server_Host_Other+'/open/apps/'+IntToStr(AppID)+'/'+'ClientRegisterProtocol.html');
                                        Const_RegisterProtocolUrl);//'http://www.orangeui.cn/open/apps/1011/ClientRegisterProtocol.html');

    end
    else
    begin
    end;



    //设置cookie
    if GlobalWebBrowserFrame=nil then
    begin
      GlobalWebBrowserFrame:=TFrameWebBrowser.Create(Application);
    end;
    GlobalWebBrowserFrame.DoLoadUrl(Const_OpenWebRoot+'/setcookie.php?user_fid='+GlobalManager.User.fid);

//    if GlobalContentWebBrowserFrame=nil then
//    begin
//      GlobalContentWebBrowserFrame:=TFrameContentWebBrowser.Create(Application);
//    end;
//    GlobalContentWebBrowserFrame.DoLoadUrl(Const_OpenWebRoot+'/setcookie.php?user_fid='+GlobalManager.User.fid);




    //获取平台商家信息
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoGetPlatformShopInfoExecute,
                 DoGetPlatformShopInfoExecuteEnd,
                 'GetPlatformShopInfo');



end;

procedure TFrameMain.tmrFreeNoUseUrlPictureTimer(Sender: TObject);
begin
  //释放超过10秒种不再绘制的图片
  //dpmShopGoodsPic.FreeNoUsePicture(10);

end;

procedure TFrameMain.tmrGetMyInfoTimer(Sender: TObject);
begin
//  //刷新个人信息,主要是审核状态,
//  //不然迟迟不能下单
//  GetMyInfoInBackGround;

  //刷新未读消息数
  frmMain.GetUserNoticeUnReadCount;

//  //刷新首页的待处理数量
//  //加载首页
//  if FHomeFrame<>nil then
//  begin
//    FHomeFrame.SyncWaitProcessCount;
//  end;
//  if FEmpHomeFrame<>nil then
//  begin
//    FEmpHomeFrame.SyncWaitProcessCount;
//  end;

end;

procedure TFrameMain.tmrReLocationTimer(Sender: TObject);
begin
  tmrReLocation.Enabled:=False;


  GlobalGPSLocation.StartLocation;

  //通知首页开始定位
  GlobalMainFrame.DoStartLocation;

end;


procedure TFrameMain.UpdateCartGoodsNumber(ACartGoodsFID, ANumber: Integer);
begin
  if GlobalManager.IsLogin=True then
  begin
    Self.FFilterCartGodsFID:=ACartGoodsFID;
    Self.FNumber:=ANumber;

    uTimerTask.GetGlobalTimerThread.RunTempTask(
                    DoUpDateCartGoodsNumberExecute,
                    DoUpDateCartGoodsNumberExecuteEnd,
                    'UpDateCartGoodsNumber');
  end;

end;

procedure TFrameMain.UpDateMyCar;
begin

  if GlobalManager.IsLogin=True then
  begin
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                    DoGetUserCarGoodsListExecute,
                    DoGetUserCarGoodsListExecuteEnd,
                    'GetUserCarGoodsList');
  end;

end;

//procedure TFrameMain.UpdateCartGoodsNumber(ACartGoodsFID, ANumber: Integer);
//begin
//  if GlobalManager.IsLogin=True then
//  begin
//    Self.FFilterCartGodsFID:=ACartGoodsFID;
//    Self.FNumber:=ANumber;
//
//    uTimerTask.GetGlobalTimerThread.RunTempTask(
//                    DoUpDateCartGoodsNumberExecute,
//                    DoUpDateCartGoodsNumberExecuteEnd,
//                    'UpDateCartGoodsNumber');
//  end;
//end;
//
//procedure TFrameMain.UpDateMyCar;
//begin
//
//  if GlobalManager.IsLogin=True then
//  begin
//    uTimerTask.GetGlobalTimerThread.RunTempTask(
//                    DoGetUserCarGoodsListExecute,
//                    DoGetUserCarGoodsListExecuteEnd,
//                    'GetUserCarGoodsList');
//  end;
//end;

procedure TFrameMain.UpDateUserCartCount(AShopGoodsList: TCarShopList);
begin
//  if FHomeFrame<>nil then
//  begin
//    Self.FHomeFrame.Init(AShopGoodsList);
//  end;
end;

procedure TFrameMain.DoLocationAddrChange;
begin
  OutputDebugString('OrangeUI TFrameMain.DoLocationAddrChange Begin');


  GlobalManager.Addr:=GlobalGPSLocation.Addr;
  GlobalManager.RegionName:=GlobalGPSLocation.City;
//  {$IFDEF NZ}
//  GlobalManager.RegionName:=GlobalGPSLocation.City+' '+GlobalGPSLocation.Province;
//  {$ELSE}
//  GlobalManager.RegionName:=GlobalGPSLocation.Province+GlobalGPSLocation.City;
//  {$ENDIF}
  GlobalManager.Save;


//  if FHomeFrame<>nil then
//  begin
//    FHomeFrame.DoLocationAddrChange;
//  end;

  OutputDebugString('OrangeUI TFrameMain.DoLocationAddrChange End');
end;

procedure TFrameMain.DoLocationChange;
begin
  OutputDebugString('OrangeUI TFrameMain.DoLocationChange Begin');

  if Not GlobalManager.IsGPSLocated then
  begin
      //只定位一次

      OutputDebugString('OrangeUI TFrameMain.DoLocationChange IsGPSLocated:False');
      GlobalManager.IsGPSLocated:=True;


      //经纬度
      GlobalManager.Longitude:=GlobalGPSLocation.Longitude;
      GlobalManager.Latitude:=GlobalGPSLocation.Latitude;

      GlobalManager.Save;



//      //上传用户定位
//      if FHomeFrame<>nil then
//      begin
//        FHomeFrame.DoLocationChange;
//      end;



      //过个几个分钟停止定位
      OutputDebugString('OrangeUI TFrameMain.DoLocationChange GlobalGPSLocation.StopLocation');
      //取到地址了,那么停止定位
      GlobalGPSLocation.StopLocation;



      //获取详细地址
      GlobalGPSLocation.GeocodeAddr;


      //启动重新定位的定时器
      tmrReLocation.Enabled:=True;


  end;

  OutputDebugString('OrangeUI TFrameMain.DoLocationChange End');
end;

procedure TFrameMain.DoUpDateCartGoodsNumberExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('update_user_cart_goods_number',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'user_cart_goods_fid',
                                                      'number',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      Self.FFilterCartGodsFID,
                                                      Self.FNumber,
                                                      GlobalManager.User.key
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

procedure TFrameMain.DoUpDateCartGoodsNumberExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //修改成功

        //更新购物车
        Self.UpDateMyCar;
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


procedure TFrameMain.imgUserHeadClick(Sender: TObject);
begin

//  if not GlobalManager.IsLogin then
//  begin
//    ShowLoginFrame(True);
//    Exit;
//  end;

{
  if FSideMenuFrame<>nil then FSideMenuFrame.Load;

  if not GlobalManager.IsLogin then
  begin
    ShowLoginFrame(True);
    Exit;
  end;
//
  Self.MultiView1.ShowMaster;
  Self.MultiView1.Width:=Trunc(Self.Width*0.7); }
end;

procedure TFrameMain.DoDelayViewClickPushNotificationJson;
var
  AContentJson:ISuperObject;
begin
  if GlobalManager.IsLogin
    and (frmMain.FDelayViewClickPushUserCustomJson<>nil) then
  begin

      //查看内容
      if frmMain.FDelayViewClickPushUserCustomJson.Contains('notice_sub_type')
        and ((frmMain.FDelayViewClickPushUserCustomJson.S['notice_sub_type']='comment_my_content')
            or (frmMain.FDelayViewClickPushUserCustomJson.S['notice_sub_type']='like_my_content')) then
      begin
        AContentJson:=TSuperObject.Create;
        AContentJson.I['fid']:=frmMain.FDelayViewClickPushUserCustomJson.I['content_fid'];
        FContentOperation.ViewContent(AContentJson,
                                      nil,
                                      nil
                                      );
      end;


      {$IFDEF HAS_FASTMSG}
      //查看聊天
      //好友消息
      {"sender_userid":80000155,"sender_username":"悟能","notice_sub_type":"fastmsg_chat"}
      if frmMain.FDelayViewClickPushUserCustomJson.Contains('notice_sub_type')
        and (frmMain.FDelayViewClickPushUserCustomJson.S['notice_sub_type']='fastmsg_chat') then
      begin
        if GlobalClient.Logined then
        begin
          GlobalIMClient.OpenChat(frmMain.FDelayViewClickPushUserCustomJson.I['sender_userid']);
        end;
      end;

      {$ENDIF}

      frmMain.FDelayViewClickPushUserCustomJson:=nil;


      frmMain.tmrSyncBadgeTimer(nil);


  end;
end;

procedure TFrameMain.DoGeocodeAddrError;
begin
  OutputDebugString('OrangeUI TFrameMain.DoGeocodeAddrError Begin');
//  if FHomeFrame<>nil then
//  begin
//    FHomeFrame.DoGeocodeAddrError;
//  end;
  OutputDebugString('OrangeUI TFrameMain.DoGeocodeAddrError End');
end;

procedure TFrameMain.DoGeocodeAddrTimeout;
begin
  OutputDebugString('OrangeUI TFrameMain.DoGeocodeAddrTimeout Begin');
//  if FHomeFrame<>nil then
//  begin
//    FHomeFrame.DoGeocodeAddrTimeout;
//  end;
  OutputDebugString('OrangeUI TFrameMain.DoGeocodeAddrTimeout End');
end;

procedure TFrameMain.DoLocationStartError;
begin
  OutputDebugString('OrangeUI TFrameMain.DoLocationStartError Begin');
//  if FHomeFrame<>nil then
//  begin
//    FHomeFrame.DoLocationStartError;
//  end;
  OutputDebugString('OrangeUI TFrameMain.DoLocationStartError End');
end;

procedure TFrameMain.DoLocationTimeout;
begin
  OutputDebugString('OrangeUI TFrameMain.DoLocationTimeout Begin');
//  if FHomeFrame<>nil then
//  begin
//    FHomeFrame.DoLocationTimeout;
//  end;
  OutputDebugString('OrangeUI TFrameMain.DoLocationTimeout End');
end;

procedure TFrameMain.DoReturnFrameFromQRCodeScannerFrame(AFrame: TFrame);
begin
//  ccbsBarCodeScanComletedCallbackEvent(Self,0,TFrameQRCodeScanner(AFrame).ResultString);
end;

procedure TFrameMain.DoStartLocation;
begin
  OutputDebugString('OrangeUI TFrameMain.DoStartLocation Begin');

  //初始,表示未定位过
  if GlobalManager<>nil then
  begin
    GlobalManager.IsGPSLocated:=False;
  end;

//  if FHomeFrame<>nil then
//  begin
//    FHomeFrame.DoStartLocation;
//  end;
  OutputDebugString('OrangeUI TFrameMain.DoStartLocation End');
end;

procedure TFrameMain.DoAddUserCartExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=
          SimpleCallAPI('add_shop_goods_to_cart',
                        nil,
                        ShopCenterInterfaceUrl,
                        ['appid',
                        'user_fid',
                        'shop_fid',
                        'key',

                        'shop_goods_fid',
                        'shop_goods_spec_fid',
                        'number',
                        'orderno',
                        'shop_goods_attrs'],
                        [AppID,
                        GlobalManager.User.fid,
                        TTimerTask(ATimerTask).TaskOtherInfo.Values['FFilterShopFID'],
                        GlobalManager.User.key,

                        TTimerTask(ATimerTask).TaskOtherInfo.Values['FFilterGoodsFID'],
                        TTimerTask(ATimerTask).TaskOtherInfo.Values['FFilterGoodsCategoryFID'],
                        TTimerTask(ATimerTask).TaskOtherInfo.Values['FFilterNumber'],
                        TTimerTask(ATimerTask).TaskOtherInfo.Values['FFilterOrderno'],
                        TTimerTask(ATimerTask).TaskOtherInfo.Values['FFilterAttrValue']
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

procedure TFrameMain.DoAddUserCartExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //添加成功

        //更新购物车
        Self.UpDateMyCar;
      end
      else
      begin
        //调用失败
        ShowMessageBoxFrame(CurrentFrame,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
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
