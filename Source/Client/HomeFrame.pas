
unit HomeFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.DeviceInfo,
  uOpenCommon,
  uFileCommon,
//  uYahooWeatherSDK,

  DateUtils,
  uFuncCommon,
  uAppCommon,
  uOpenClientCommon,
  uContentOperation,
  FMX.Filter,
  uDatasetToJson,

  Math,
  uLang,
  uConst,

  uGPSLocation,
  uBaseLog,

  uDrawParam,
  uDrawPictureParam,
  uSkinBufferBitmap,

  uBaseHttpControl,
  uBaseList,

  uUIFunction,
  uManager,
  uSkinItemJsonHelper,
//  uOpenClientCommon,
  uTimerTask,

  uSkinControlGestureManager,

  uDrawCanvas,
  uFrameContext,
  uGraphicCommon,
  WaitingFrame,
  uComponentType,

  uSkinItems,

  XSuperObject,
  uRestInterfaceCall,

  ListItemStyleFrame_4Buttons,
//  ListItemStyleFrame_XFOnlineNews,
  ListItemStyleFrame_HorzListBox,
//  ListItemStyleFrame_News,
  ListItemStyleFrame_ContentNews,
  ListItemStyleFrame_DelphiContent,
  ListItemStyleFrame_ShortVideo,
  ListItemStyleFrame_ImageListViewer,
  ListItemStyleFrame_IconCaption,
//  ListItemStyleFrame_IconCaptionMore,
  ListItemStyleFrame_IconCaption_RightGrayDetail,
  ListItemStyleFrame_ContentSuggestNews,
  ListItemStyleFrame_IconTopCenter_CaptionBottomCenterWhite,
  ListItemStyleFrame_IconTopCenterBackColor_CaptionBottomCenterBlack,

  MessageBoxFrame,
  WebBrowserFrame,
  ContentClassifyFrame,


  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,


  uSkinFireMonkeyControl, uSkinPanelType, uSkinFireMonkeyPanel, uSkinButtonType,
  uSkinFireMonkeyButton, uSkinLabelType, uSkinFireMonkeyLabel, uSkinImageType,
  uSkinFireMonkeyImage, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListViewType, uSkinFireMonkeyListView,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel, uDrawPicture,
  uSkinImageList, uSkinImageListViewerType, uSkinFireMonkeyImageListViewer,
  uSkinNotifyNumberIconType, uSkinFireMonkeyNotifyNumberIcon, uSkinListBoxType,
  uSkinFireMonkeyListBox, System.Notification, uSkinCalloutRectType,
  uSkinFireMonkeyPopup, uSkinMaterial;

type
  TFrameHome = class(TFrame,IFramePaintSetting)
    lvHome: TSkinFMXListView;
    pnlToolBar: TSkinFMXPanel;
    btnAddr: TSkinFMXButton;
    pnlTemp: TSkinFMXPanel;
    lblTempValue: TSkinFMXLabel;
    lblTempExplain: TSkinFMXLabel;
    pnlTempPic: TSkinFMXPanel;
    imgTemp: TSkinFMXImage;
    imgUserHead: TSkinFMXImage;
    lblMy: TSkinFMXLabel;
    btnScode: TSkinFMXButton;
    tmrInvalidate: TTimer;
    btnInfo: TSkinFMXButton;
    imgBackGround: TSkinFMXImage;
    imgSearchBar: TSkinFMXImage;
    imgSearchIcon: TSkinFMXImage;
    lblSearchCaption: TSkinFMXLabel;
    btnSign: TSkinFMXButton;
    btnAddContent: TSkinFMXButton;
    imglistFunctionIcon: TSkinImageList;
    lbNewsContentClassify: TSkinFMXListBox;
    imglistOthers: TSkinImageList;
    popuAdd: TSkinFMXPopup;
    lbAddList: TSkinFMXListBox;
    procedure imgPlayerResize(Sender: TObject);
    procedure lvHomeResize(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure btnFilter1Click(Sender: TObject);
    procedure btnFilter2Click(Sender: TObject);
    procedure btnFilter3Click(Sender: TObject);
    procedure btnFilter4Click(Sender: TObject);
    procedure lvHomePullDownRefresh(Sender: TObject);
    procedure lvHomePullUpLoadMore(Sender: TObject);
    procedure lvHomePrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure btnAddrClick(Sender: TObject);
    procedure lvHomeClickItem(AItem: TSkinItem);
    procedure btnSearchClick(Sender: TObject);
    procedure btnOrderCarClick(Sender: TObject);
    procedure lbKeyClickItem(AItem: TSkinItem);
    procedure imgTempClick(Sender: TObject);
    procedure btnScodeClick(Sender: TObject);
    procedure tmrInvalidateTimer(Sender: TObject);
    procedure lvHomeClickItemDesignerPanelChild(Sender: TObject;
      AItem: TBaseSkinItem; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
      AChild: TFmxObject);
    procedure btnSignClick(Sender: TObject);
    procedure lbFilterClassifyClickItem(AItem: TSkinItem);
    procedure lvHomeVertScrollBarChange(Sender: TObject);
    procedure imgSearchBarClick(Sender: TObject);
    procedure imgUserHeadClick(Sender: TObject);
    procedure FramePaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure lbNewsContentClassifyClickItem(AItem: TSkinItem);
    procedure btnAddContentClick(Sender: TObject);
    procedure lbAddListClickItem(AItem: TSkinItem);
  private
    //背景色(在Frame上绘制,Frame.OnPainting)
    function GetFillColor:TDelphiColor;
    function GetFormColor:TDelphiColor;
  private

    FContentOperation:TContentOperation;

//    FIsFirst:Boolean;


//    FCarShopList:TCarShopList;


//    //关键字
//    FFilterKey:String;


//    //热门搜索
//    FStringList:TStringList;

//    //排序方式
//    FSort:String;
    FPageIndex:Integer;



//    //广告图片
//    FHomeAdList:THomeAdList;
    FHomeAdArray:ISuperArray;
    FHomeAdItem:TSkinItem;
    FListItemStyleFrame_ImageListViewer:TFrameImageListViewerListItemStyle;


//    FNewFilterClassifyHorzListBoxItem:TSkinItem;
//    FListItemStyleFrame_HorzListBox:TFrameListItemStyle_HorzListBox;

//    FButtonsItem:TSkinItem;
//    FListItemStyle_4ButtonsFrame:TFrameListItemStyle_4Buttons;
//
//    FButtonsItem2:TSkinItem;
//    FListItemStyle_4ButtonsFrame2:TFrameListItemStyle_4Buttons;

    FHotSuggestItem:TSkinItem;
    FIconCaption_RightGrayDetailListItemStyleFrame:TFrameIconCaption_RightGrayDetailListItemStyle;

//    //活动类型
//    FFilter_promotion_type:String;

  private
//    //从商品详情页面返回
//    procedure OnFromShopInfoFrame(AFrame:TFrame);
//    //从用户购物车页面返回
//    procedure OnReturnFromUserCarFrame(AFrame:TFrame);
//
//    //从选择地址返回
//    procedure OnReturnFromHomeAddrFrame(AFrame:TFrame);
//    //从搜索店铺列表返回
//    procedure OnReturnFromShopListFrame(AFrame:TFrame);
//    //从选择活动返回
//    procedure OnFromShopListFrame(AFrame:TFrame);
  private
    //获取首页信息
    procedure DoGetHomeFrameInfoExecute(ATimerTask:TObject);
    procedure DoGetHomeFrameInfoExecuteEnd(ATimerTask:TObject);
    //获取新闻
    procedure DoGetNewsListExecute(ATimerTask:TObject);
    procedure DoGetNewsListExecuteEnd(ATimerTask:TObject);

//  private
//    //星星数量
//    procedure GetShowStar(ANumber:Double);
  private
//    //从筛选页面返回
//    procedure OnFromFFilterFrame(AFarme:TFrame);
//
//    //从弹出框返回
//    procedure OnModalResultFromLeaveOrder(AFrame:TObject);
//
//    //添加Item
//    procedure AddItem;
  private
    //处理手势冲突
    procedure DoListBoxVertManagerPrepareDecidedFirstGestureKind(
      Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
      var AIsDecidedFirstGestureKind: Boolean;
      var ADecidedFirstGestureKind:TGestureKind);
    { Private declarations }
//  public
//     procedure SetingButtonWidth(ACaption:String);
  public
//    //店铺列表
//    FShopList:TShopList;
//
//    FIsOnlyUpdateShopList:Boolean;
//    //历史搜索
//    FHisStringList:TStringList;
//    procedure SyncWaitProcessCount(ASort:String;
//                                   AFilter_promotion_type:String;
//                                   AFilterKey:String);
    procedure Clear;

//  public
//    procedure Init(ACarShopList:TCarShopList);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Load;
    procedure ShowUserHeadImage;
  public
    //当前登录的用户ID,用于重新登录时判断是否需要重新加载
    FUserFID:String;
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
    //地址解析失败
    procedure DoGeocodeAddrError;
    //地址解析超时
    procedure DoGeocodeAddrTimeout;
    { Public declarations }
  end;





implementation

{$R *.fmx}

uses
//  SearchFrame,
//  UserCarFrame,
//  ShopListFrame,
//  ShopInfoFrame,
//  FFilterShopConditionFrame,
//  HomeAddrFrame,
//  GameOnLineMainForm,
  SignFrame,
  SignSucceedFrame,
  AddContentFrame,
//  CaptchaFrame,
  MyScoreFrame,
  ContentListFrame,
//  MyInvitationCodeFrame,
  UserSuggectionFrame,
//  GiftPackageCenterFrame,
//  GiftPackageListFrame,
  ActivityCenterFrame,
  ActivityListFrame,
  LoginFrame,
  MainForm,
  MainFrame,
  HintFrame;


type
  TProtectedControl=class(TControl);


//procedure TFrameHome.AddItem;
//begin
//
//end;

procedure TFrameHome.btnAddContentClick(Sender: TObject);
var
  AButton:TControl;
begin
  if not GlobalManager.IsLogin then
  begin
    ShowLoginFrame(True);
    Exit;
  end;


//  HideFrame;
//  ShowFrame(TFrame(GlobalAddContentFrame),TFrameAddContent,DoReturnFromAddContent);
//  GlobalAddContentFrame.Clear;
//  Exit;


  AButton:=TControl(Sender);

  if Not Self.popuAdd.IsOpen then
  begin
    //设置弹出框绝对位置
    Self.popuAdd.PlacementRectangle.Left:=
          TProtectedControl(AButton.Parent).LocalToScreen(PointF(Self.btnAddContent.Position.X+Self.btnAddContent.Width,0)).X
          -Self.popuAdd.Width
//          -10
          -4
          ;
    Self.popuAdd.PlacementRectangle.Top:=
          TProtectedControl(AButton.Parent).LocalToScreen(PointF(0,Self.pnlToolBar.Height)).Y
          -10;
    Self.popuAdd.IsOpen:=True;
  end
  else
  begin
    Self.popuAdd.IsOpen:=False;
  end;


end;

procedure TFrameHome.btnAddrClick(Sender: TObject);
begin
//  //选择地址
//  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//  ShowFrame(TFrame(GlobalHomeAddrFrame),TFrameHomeAddr,OnReturnFromHomeAddrFrame);
//  GlobalHomeAddrFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalHomeAddrFrame.Clear;
//  //加载收货地址
//  GlobalHomeAddrFrame.LoadRecvAddrList;
//  //
//  GlobalHomeAddrFrame.Load;

end;

procedure TFrameHome.btnAllClick(Sender: TObject);
begin
//  Self.FSort:='';
//
//  Self.btnAll.Prop.IsPushed:=True;
//  Self.btnFilter1.Prop.IsPushed:=False;
//  Self.btnFilter2.Prop.IsPushed:=False;
//  Self.btnFilter3.Prop.IsPushed:=False;
//  Self.btnFilter4.Prop.IsPushed:=False;
//
//  Self.lvHome.VertScrollBar.Prop.Position:=
//             Self.lvHome.Prop.Items.FindItemByType(sitSearchBar).ItemRect.Top;
//  //显示筛选页面
//  ShowFrame(TFrame(GlobalFFilterShopConditionFrame),TFrameFFilterShopCondition,frmMain,nil,nil,OnFromFFilterFrame,Application,True,False,ufsefNone);
//  GlobalFFilterShopConditionFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalFFilterShopConditionFrame.Init(Self.btnAll.Caption);



end;

procedure TFrameHome.btnFilter1Click(Sender: TObject);
begin
//  Self.FSort:=Const_SortType_HighOpinion;
//
//  Self.btnAll.Prop.IsPushed:=False;
//  Self.btnFilter1.Prop.IsPushed:=True;
//  Self.btnFilter2.Prop.IsPushed:=False;
//  Self.btnFilter3.Prop.IsPushed:=False;
//  Self.btnFilter4.Prop.IsPushed:=False;
//
//  FIsOnlyUpdateShopList:=True;
//
//  Self.lvHome.VertScrollBar.Prop.Position:=
//             Self.lvHome.Prop.Items.FindItemByType(sitSearchBar).ItemRect.Top;
//
//  Self.SyncWaitProcessCount(Self.FSort,Self.FFilter_promotion_type,Self.FFilterKey);
end;

procedure TFrameHome.btnFilter2Click(Sender: TObject);
begin
//  Self.FSort:=Const_SortType_NearestDistance;
//
//  Self.btnAll.Prop.IsPushed:=False;
//  Self.btnFilter1.Prop.IsPushed:=False;
//  Self.btnFilter2.Prop.IsPushed:=True;
//  Self.btnFilter3.Prop.IsPushed:=False;
//  Self.btnFilter4.Prop.IsPushed:=False;
//
//  FIsOnlyUpdateShopList:=True;
//
//  Self.lvHome.VertScrollBar.Prop.Position:=
//             Self.lvHome.Prop.Items.FindItemByType(sitSearchBar).ItemRect.Top;
//
//  Self.SyncWaitProcessCount(Self.FSort,Self.FFilter_promotion_type,Self.FFilterKey);
end;

procedure TFrameHome.btnFilter3Click(Sender: TObject);
begin
//  Self.FSort:=Const_SortType_TopSales;
//
//  Self.btnAll.Prop.IsPushed:=False;
//  Self.btnFilter1.Prop.IsPushed:=False;
//  Self.btnFilter2.Prop.IsPushed:=False;
//  Self.btnFilter3.Prop.IsPushed:=True;
//  Self.btnFilter4.Prop.IsPushed:=False;
//
//  FIsOnlyUpdateShopList:=True;
//
//  Self.lvHome.VertScrollBar.Prop.Position:=
//             Self.lvHome.Prop.Items.FindItemByType(sitSearchBar).ItemRect.Top;
//
//  Self.SyncWaitProcessCount(Self.FSort,Self.FFilter_promotion_type,Self.FFilterKey);
end;

procedure TFrameHome.btnFilter4Click(Sender: TObject);
begin

//  Self.FSort:=Const_SortType_LowestBidPrice;
//
//  Self.btnAll.Prop.IsPushed:=False;
//  Self.btnFilter1.Prop.IsPushed:=False;
//  Self.btnFilter2.Prop.IsPushed:=False;
//  Self.btnFilter3.Prop.IsPushed:=False;
//  Self.btnFilter4.Prop.IsPushed:=True;
//
//  FIsOnlyUpdateShopList:=True;
//
//  Self.SyncWaitProcessCount(Self.FSort,Self.FFilter_promotion_type,Self.FFilterKey);
end;

procedure TFrameHome.btnOrderCarClick(Sender: TObject);
begin
//  if GlobalManager.IsLogin=True then
//  begin
//    //购物车列表页面
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//    ShowFrame(TFrame(GlobalUserCarFrame),TFrameUserCar,OnReturnFromUserCarFrame);
//    GlobalUserCarFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalUserCarFrame.Clear;
//    GlobalUserCarFrame.Init;
//  end
//  else
//  begin
//    //去登录
//    //隐藏
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//    //显示登录页面
//    ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
//    GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
//    //清除输入框
//    GlobalLoginFrame.Clear;
//
//  end;
end;

procedure TFrameHome.btnScodeClick(Sender: TObject);
begin
  frmMain.ScanQRCode;
end;

procedure TFrameHome.btnSearchClick(Sender: TObject);
begin
//  //搜索
//  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//  ShowFrame(TFrame(GlobalSearchFrame),TFrameSearch);
//  GlobalSearchFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalSearchFrame.Clear;
//  GlobalSearchFrame.Load(Self.FFilterKey,Self.FStringList,GlobalManager.ShopSearchHistoryList,'home');

end;

procedure TFrameHome.btnSignClick(Sender: TObject);
begin
  if not GlobalManager.IsLogin then
  begin
    ShowLoginFrame(True);
    Exit;
  end;

  //HideFrame;
//  ShowFrame(TFrame(GlobalSignFrame),TFrameSign,Application.MainForm,nil,nil,nil,Application,True,True,ufsefMoveVertAndAlpha);
  ShowFrame(TFrame(GlobalSignFrame),TFrameSign,Application.MainForm,nil,nil,nil,Application,True,True,ufsefAlpha);
  GlobalSignFrame.Load;
end;

procedure TFrameHome.Clear;
begin
  Self.lvHome.Prop.Items.BeginUpdate;
  try
    Self.lvHome.Prop.Items.Clear(True);
  finally
    Self.lvHome.Prop.Items.EndUpdate;
  end;

//  Self.btnOrderCar.Visible:=False;

//  Self.lbltag.Visible:=False;
end;

constructor TFrameHome.Create(AOwner: TComponent);
var
  ADrawMargin:Integer;
//  filter:TFilter;
begin
  inherited;

//  //图片下载成功
//  filter :=TFilterManager.FilterByName('GaussianBlur');
//  filter.ValuesAsFloat['BlurAmount'] :=3;   //BlurAmount 是高斯模糊参数的名称, 默认值是 1(0.1..10)
//  filter.ValuesAsBitmap['input'] :=Self.imgBackground.Prop.Picture;
//  Self.imgBackground.Prop.Picture.Assign(filter.ValuesAsBitmap['output']);


  FContentOperation:=TContentOperation.Create;
  FContentOperation.FContentListBox:=Self.lvHome;


  //App名称
  Self.lblMy.Caption:=Const_APPName;



//  Self.FFilterKey:='';
//  Self.FFilter_promotion_type:='';
//  Self.FSort:='';



//  Self.imglistPlayer.PictureList.Clear(True);

//  Self.lbKey.Prop.Items.Clear(True);
//
//  Self.btnAll.Caption:='综合排序';

//  FIsOnlyUpdateShopList:=False;



  lbNewsContentClassify.Prop.Items.BeginUpdate;
  try
    lbNewsContentClassify.Prop.Items.Clear();
  finally
    lbNewsContentClassify.Prop.Items.EndUpdate();
  end;


  Self.lvHome.Prop.Items.BeginUpdate;
  try
  //    Self.lvHome.Prop.Items.Clear;
      Self.lvHome.Prop.Items.ClearItemsByType(sitDefault);
      Self.lvHome.Prop.Items.ClearItemsByType(sitItem3);


//      Self.lvHome.Prop.Items[0].IsNotNeedDrawDevide:=True;




//      //功能按钮
//      FButtonsItem:=Self.lvHome.Prop.Items.FindItemByName('function_buttons');
//      FListItemStyle_4ButtonsFrame:=nil;
//      if FButtonsItem<>nil then
//      begin
//        FButtonsItem.Height:=80;
//
//       // FButtonsItem.Height:=50;
//        FButtonsItem.IsNotNeedDrawDevide:=True;
//
//  //      AListItemStyle_4ButtonsFrame:=Self.lvHome.Prop.
//        FListItemStyle_4ButtonsFrame:=
//          TFrameListItemStyle_4Buttons(
//            Self.lvHome.Prop.FListItemTypeStyleSettingList
//              .FindByItemType(FButtonsItem.ItemType).GetItemStyleFrameCache(FButtonsItem).FItemStyleFrame);
//      end;
//      if FListItemStyle_4ButtonsFrame<>nil then
//      begin
//        FListItemStyle_4ButtonsFrame.ItemDesignerPanel.Material.IsTransparent:=False;
//        FListItemStyle_4ButtonsFrame.ItemDesignerPanel.Material.BackColor.IsFill:=True;
//        FListItemStyle_4ButtonsFrame.ItemDesignerPanel.Material.BackColor.FillColor.Color:=Self.imgBackground.Material.BackColor.FillColor.Color;//TAlphaColorRec.White;
//
////        FListItemStyle_4ButtonsFrame.btnButton1.Caption:='验证码';
////        FListItemStyle_4ButtonsFrame.btnButton1.Prop.Icon.Clear;
////        FListItemStyle_4ButtonsFrame.btnButton1.Prop.Icon.SkinImageList:=Self.imglistFunctionIcon;
////        FListItemStyle_4ButtonsFrame.btnButton1.Prop.Icon.ImageName:='button-code';
//
//        FListItemStyle_4ButtonsFrame.btnButton1.Caption:='扫码';
//        FListItemStyle_4ButtonsFrame.btnButton1.Prop.Icon.Clear;
//        FListItemStyle_4ButtonsFrame.btnButton1.Prop.Icon.SkinImageList:=Self.imglistFunctionIcon;
//        FListItemStyle_4ButtonsFrame.btnButton1.Prop.Icon.ImageName:='button-scan';
//
//
////        FListItemStyle_4ButtonsFrame.btnButton2.Caption:='礼包';
////        FListItemStyle_4ButtonsFrame.btnButton2.Prop.Icon.Clear;
////        FListItemStyle_4ButtonsFrame.btnButton2.Prop.Icon.SkinImageList:=Self.imglistFunctionIcon;
////        FListItemStyle_4ButtonsFrame.btnButton2.Prop.Icon.ImageName:='button-gift';
//
//        FListItemStyle_4ButtonsFrame.btnButton2.Caption:='打卡';
//        FListItemStyle_4ButtonsFrame.btnButton2.Prop.Icon.Clear;
//        FListItemStyle_4ButtonsFrame.btnButton2.Prop.Icon.SkinImageList:=Self.imglistFunctionIcon;
//        FListItemStyle_4ButtonsFrame.btnButton2.Prop.Icon.ImageName:='button-clocked';
//
//
//        FListItemStyle_4ButtonsFrame.btnButton3.Caption:='积分';
//        FListItemStyle_4ButtonsFrame.btnButton3.Prop.Icon.Clear;
//        FListItemStyle_4ButtonsFrame.btnButton3.Prop.Icon.SkinImageList:=Self.imglistFunctionIcon;
//        FListItemStyle_4ButtonsFrame.btnButton3.Prop.Icon.ImageName:='button-integral';
//
////        FListItemStyle_4ButtonsFrame.btnButton4.Caption:='活动';
//        FListItemStyle_4ButtonsFrame.btnButton4.Caption:='反馈';//'活动';
//        FListItemStyle_4ButtonsFrame.btnButton4.Prop.Icon.Clear;
//        FListItemStyle_4ButtonsFrame.btnButton4.Prop.Icon.SkinImageList:=Self.imglistFunctionIcon;
//        FListItemStyle_4ButtonsFrame.btnButton4.Prop.Icon.ImageName:='button-return';
//
//      end;
//
//
//
//
//      //功能按钮2
//      FButtonsItem2:=Self.lvHome.Prop.Items.FindItemByName('function_buttons2');
//      FListItemStyle_4ButtonsFrame2:=nil;
//      if FButtonsItem2<>nil then
//      begin
//        FButtonsItem2.Height:=80;
//
//        FButtonsItem2.IsNotNeedDrawDevide:=True;
//
//        FListItemStyle_4ButtonsFrame2:=
//          TFrameListItemStyle_4Buttons(
//            Self.lvHome.Prop.FListItemTypeStyleSettingList
//              .FindByItemType(FButtonsItem2.ItemType).GetItemStyleFrameCache(FButtonsItem2).FItemStyleFrame);
//      end;
//      if FListItemStyle_4ButtonsFrame2<>nil then
//      begin
//        FListItemStyle_4ButtonsFrame2.ItemDesignerPanel.Material.IsTransparent:=False;
//        FListItemStyle_4ButtonsFrame2.ItemDesignerPanel.Material.BackColor.IsFill:=True;
//        FListItemStyle_4ButtonsFrame2.ItemDesignerPanel.Material.BackColor.FillColor.Color:=Self.imgBackground.Material.BackColor.FillColor.Color;//TAlphaColorRec.White;
//
//
//        FListItemStyle_4ButtonsFrame2.btnButton1.Caption:='扫码';
//        FListItemStyle_4ButtonsFrame2.btnButton1.Prop.Icon.Clear;
//        FListItemStyle_4ButtonsFrame2.btnButton1.Prop.Icon.SkinImageList:=Self.imglistFunctionIcon;
//        FListItemStyle_4ButtonsFrame2.btnButton1.Prop.Icon.ImageName:='button-scan';
//
//        FListItemStyle_4ButtonsFrame2.btnButton2.Caption:='打卡';
//        FListItemStyle_4ButtonsFrame2.btnButton2.Prop.Icon.Clear;
//        FListItemStyle_4ButtonsFrame2.btnButton2.Prop.Icon.SkinImageList:=Self.imglistFunctionIcon;
//        FListItemStyle_4ButtonsFrame2.btnButton2.Prop.Icon.ImageName:='button-clocked';
//
//        FListItemStyle_4ButtonsFrame2.btnButton3.Caption:='邀请';
//        FListItemStyle_4ButtonsFrame2.btnButton3.Prop.Icon.Clear;
//        FListItemStyle_4ButtonsFrame2.btnButton3.Prop.Icon.SkinImageList:=Self.imglistFunctionIcon;
//        FListItemStyle_4ButtonsFrame2.btnButton3.Prop.Icon.ImageName:='button-invite';
//
//        FListItemStyle_4ButtonsFrame2.btnButton4.Caption:='任务';;
//        FListItemStyle_4ButtonsFrame2.btnButton4.Prop.Icon.Clear;
//        FListItemStyle_4ButtonsFrame2.btnButton4.Prop.Icon.SkinImageList:=Self.imglistFunctionIcon;
//        FListItemStyle_4ButtonsFrame2.btnButton4.Prop.Icon.ImageName:='button-task';
//
//      end;





//      //新闻分类
//      FNewFilterClassifyHorzListBoxItem:=nil;
//      //news_filter_classify
//      FNewFilterClassifyHorzListBoxItem:=Self.lvHome.Prop.Items.FindItemByName('news_filter_classify');
//      if FNewFilterClassifyHorzListBoxItem<>nil then
//      begin
//        FNewFilterClassifyHorzListBoxItem.IsNotNeedDrawDevide:=True;
//        //获取该Item到列表项样式的Frame
//        FListItemStyleFrame_HorzListBox:=
//          TFrameListItemStyle_HorzListBox(
//            Self.lvHome.Prop.FListItemTypeStyleSettingList
//              .FindByItemType(FNewFilterClassifyHorzListBoxItem.ItemType).GetItemStyleFrameCache(FNewFilterClassifyHorzListBoxItem).FItemStyleFrame);
//      end;
//      if FListItemStyleFrame_HorzListBox<>nil then
//      begin
//        //设置新闻分类切换事件
//        FListItemStyleFrame_HorzListBox.lbData.OnClickItem:=lbFilterClassifyClickItem;
//        FListItemStyleFrame_HorzListBox.lbData.Material.BackColor.FillColor.Color:=
//          Self.lvHome.Material.BackColor.FillColor.Color;
//        FListItemStyleFrame_HorzListBox.lbData.Prop.Items.BeginUpdate;
//        try
//          FListItemStyleFrame_HorzListBox.lbData.Prop.Items.Clear();
//        finally
//          FListItemStyleFrame_HorzListBox.lbData.Prop.Items.EndUpdate();
//        end;
//      end;



      //广告轮播图片
      FHomeAdItem:=nil;
      FListItemStyleFrame_ImageListViewer:=nil;
      FHomeAdItem:=Self.lvHome.Prop.Items.FindItemByName('home_ad');
      if FHomeAdItem<>nil then
      begin
        FListItemStyleFrame_ImageListViewer:=TFrameImageListViewerListItemStyle(Self.lvHome.Prop.FListItemTypeStyleSettingList
              .FindByItemType(FHomeAdItem.ItemType).GetItemStyleFrameCache(FHomeAdItem).FItemStyleFrame);

      end;

      if FListItemStyleFrame_ImageListViewer<>nil then
      begin
        FListItemStyleFrame_ImageListViewer.imgBackground.Prop.Picture.SkinImageList:=Self.imglistOthers;
        FListItemStyleFrame_ImageListViewer.imgBackground.Prop.Picture.ImageName:='banner-bj2';
        FListItemStyleFrame_ImageListViewer.imgBackground.Material.DrawPictureParam.IsStretch:=True;
        FListItemStyleFrame_ImageListViewer.imgBackground.Material.DrawPictureParam.StretchStyle:=TPictureStretchStyle.issSquarePro;
        FListItemStyleFrame_ImageListViewer.imgBackground.Material.DrawPictureParam.StretchMargins.SetBounds(46,46,46,46);
        ADrawMargin:=30;
        FListItemStyleFrame_ImageListViewer.imgBackground.Material.DrawPictureParam.DestDrawStretchMargins.SetBounds(ADrawMargin,ADrawMargin,ADrawMargin,ADrawMargin);


        FListItemStyleFrame_ImageListViewer.imgBackground.Margins.Left:=0;
        FListItemStyleFrame_ImageListViewer.imgBackground.Margins.Right:=0;
        FListItemStyleFrame_ImageListViewer.imgBackground.Margins.Top:=0;
        FListItemStyleFrame_ImageListViewer.imgBackground.Margins.Bottom:=0;



        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.DrawRoundOutSideRectParam.FillColor.Color:=
                Self.lvHome.Material.BackColor.FillColor.Color;
        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.IsTransparent:=False;



        FListItemStyleFrame_ImageListViewer.imgPlayer.Margins.Left:=ADrawMargin-7;
        FListItemStyleFrame_ImageListViewer.imgPlayer.Margins.Right:=ADrawMargin-7;
        FListItemStyleFrame_ImageListViewer.imgPlayer.Margins.Top:=ADrawMargin-7;
        FListItemStyleFrame_ImageListViewer.imgPlayer.Margins.Bottom:=ADrawMargin-7;


//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.BackColor.FillColor.Color:=TAlphaColorRec.White;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.BackColor.IsFill:=True;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.BackColor.IsRound:=True;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.BackColor.RoundWidth:=12;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.BackColor.RoundHeight:=12;
//
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.DrawPictureParam.DrawRectSetting.Left:=5;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.DrawPictureParam.DrawRectSetting.Top:=5;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.DrawPictureParam.DrawRectSetting.Right:=5;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.DrawPictureParam.DrawRectSetting.Bottom:=5;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.DrawPictureParam.DrawRectSetting.SizeType:=TDPSizeType.dpstPixel;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.DrawPictureParam.DrawRectSetting.Enabled:=True;
//
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.DrawRoundOutSideRectParam.DrawRectSetting.Left:=5;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.DrawRoundOutSideRectParam.DrawRectSetting.Top:=5;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.DrawRoundOutSideRectParam.DrawRectSetting.Right:=5;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.DrawRoundOutSideRectParam.DrawRectSetting.Bottom:=5;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.DrawRoundOutSideRectParam.DrawRectSetting.SizeType:=TDPSizeType.dpstPixel;
//        FListItemStyleFrame_ImageListViewer.imgPlayer.Material.DrawRoundOutSideRectParam.DrawRectSetting.Enabled:=True;


//        FListItemStyleFrame_ImageListViewer.ItemDesignerPanel.Material.IsTransparent:=False;
//        FListItemStyleFrame_ImageListViewer.ItemDesignerPanel.Material.BackColor.FillColor.Color:=TAlphaColorRec.White;
//        FListItemStyleFrame_ImageListViewer.ItemDesignerPanel.Material.BackColor.IsFill:=True;
//        FListItemStyleFrame_ImageListViewer.ItemDesignerPanel.Material.BackColor.IsRound:=True;
//        FListItemStyleFrame_ImageListViewer.ItemDesignerPanel.Material.BackColor.RoundWidth:=10;
//        FListItemStyleFrame_ImageListViewer.ItemDesignerPanel.Material.BackColor.RoundHeight:=10;


        FHomeAdItem.IsNotNeedDrawDevide:=True;

        FHomeAdItem.SubItems.Clear;
        FHomeAdItem.IsBufferNeedChange:=True;
      end;



      //推荐
      FHotSuggestItem:=nil;
      FIconCaption_RightGrayDetailListItemStyleFrame:=nil;
      FHotSuggestItem:=Self.lvHome.Prop.Items.FindItemByName('hot_suggest');
      if FHotSuggestItem<>nil then
      begin
        FHotSuggestItem.Visible:=False;
        FHotSuggestItem.IsNotNeedDrawDevide:=True;
//        Self.lvHome.Prop.FooterItemStyleConfig.Add('lblItemCaption.SelfOwnMaterial.DrawCaptionParam.FontSize:=16');
//        Self.lvHome.Prop.FooterItemStyleConfig.Add('lblItemCaption.SelfOwnMaterial.DrawBackColorParam.FillColor:=$FFFFFFFF');
//        Self.lvHome.Prop.FooterItemStyleConfig.Add('lblItemCaption.SelfOwnMaterial.DrawBackColorParam.IsFill:=True');
//        Self.lvHome.Prop.FooterItemStyleConfig.Add('lblItemCaption.SelfOwnMaterial.IsTransparent:=False');

        FIconCaption_RightGrayDetailListItemStyleFrame:=TFrameIconCaption_RightGrayDetailListItemStyle(Self.lvHome.Prop.FListItemTypeStyleSettingList
              .FindByItemType(FHotSuggestItem.ItemType).GetItemStyleFrameCache(FHotSuggestItem).FItemStyleFrame);
      end;
      if FIconCaption_RightGrayDetailListItemStyleFrame<>nil then
      begin
        FIconCaption_RightGrayDetailListItemStyleFrame.ItemDesignerPanel.Material.IsTransparent:=False;
        FIconCaption_RightGrayDetailListItemStyleFrame.ItemDesignerPanel.Material.BackColor.IsFill:=True;
        FIconCaption_RightGrayDetailListItemStyleFrame.ItemDesignerPanel.Material.BackColor.FillColor.Color:=Self.imgBackground.Material.BackColor.FillColor.Color;//TAlphaColorRec.White;

        FIconCaption_RightGrayDetailListItemStyleFrame.lblItemCaption.Material.DrawCaptionParam.FontSize:=16;

        FIconCaption_RightGrayDetailListItemStyleFrame.imgItemIcon.Margins.Top:=10;
        FIconCaption_RightGrayDetailListItemStyleFrame.imgItemIcon.Margins.Bottom:=10;
      end;


  finally
    Self.lvHome.Prop.Items.EndUpdate;
  end;



//  FIsFirst:=False;




//  FWeatherTimerThread:=TTimerThread.Create(False);

//  SyncAddrButton;




  //处理手势冲突
  Self.lvHome.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
  Self.lvHome.Prop.VertControlGestureManager.OnPrepareDecidedFirstGestureKind:=
                            Self.DoListBoxVertManagerPrepareDecidedFirstGestureKind;



//  Self.btnAll.Prop.IsPushed:=True;
//  Self.btnFilter1.Prop.IsPushed:=False;
//  Self.btnFilter2.Prop.IsPushed:=False;
//  Self.btnFilter3.Prop.IsPushed:=False;
//  Self.btnFilter4.Prop.IsPushed:=False;





//  Self.lblFull.Visible:=False;
//  Self.lblFullValue.Visible:=False;
//  Self.lblSpical.Visible:=False;
//  Self.lblSpicalValue.Visible:=False;




//  FHomeAdList:=THomeAdList.Create;
//  FShopList:=TShopList.Create;
//  FStringList:=TStringList.Create;

  Self.imgBackGround.Prop.Picture.SkinImageList:=dmCommonImageDataMoudle.imglistOthers;


  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);


//  FYahooWeatherSDK:=TYahooWeatherSDK.Create(nil);
end;

destructor TFrameHome.Destroy;
begin
//  FreeAndNil(FHomeAdList);


//  FreeAndNil(FShopList);
//  FreeAndNil(FStringList);


//  FWeatherTimerThread.Terminate;
//  FWeatherTimerThread.WaitFor;
//  FreeAndNil(FWeatherTimerThread);
//
//
//  FreeAndNil(FYahooWeatherSDK);

  FreeAndNil(FContentOperation);

  inherited;
end;


procedure TFrameHome.DoGetHomeFrameInfoExecute(ATimerTask: TObject);
var
  AClassifyIndex:String;
  AFirstNewsFilterClassifyJson:ISuperObject;
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    if FPageIndex=1 then
    begin
          AClassifyIndex:='';
//          if Self.FListItemStyleFrame_HorzListBox.lbData.Prop.SelectedItem<>nil then
//          begin
//            AClassifyIndex:=IntToStr(Self.FListItemStyleFrame_HorzListBox.lbData.Prop.SelectedItem.Index);
//          end;
          if Self.lbNewsContentClassify.Prop.SelectedItem<>nil then
          begin
            AClassifyIndex:=IntToStr(Self.lbNewsContentClassify.Prop.SelectedItem.Index);
          end;



          //首页
          TTimerTask(ATimerTask).TaskDesc :=
            SimpleCallAPI(
//                            'get_xfapp_home_page_list_v2',
                            'get_home_page_list_v3',
                            nil,
//                            ShopCenterInterfaceUrl,
                            ContentCenterInterfaceUrl,
                            ['appid',
                            'user_fid',
                            'key',
                            'pageindex',
                            'pagesize',
                            'is_tourist',
                            'classify_index'
                            ],
                            [AppID,
                            GlobalManager.User.fid,
                            GlobalManager.User.key,
                            Self.FPageIndex,
                            20,
                            //是否是游客模式,游客模式不显示一些敏感的信息,主要是为了过审核
                            Ord(  (GlobalManager.User.phone='18957901025')
                                  or not GlobalManager.IsLogin ),
                            AClassifyIndex
                            ],
                            GlobalRestAPISignType,
                            GlobalRestAPIAppSecret
                            );

    end
    else
    begin
          //第二页
//          if Self.FListItemStyleFrame_HorzListBox<>nil then
//          begin
//              //获取当前选择的新闻分类
//              AFirstNewsFilterClassifyJson:=FListItemStyleFrame_HorzListBox.lbData.Prop.SelectedItem.Json;


              //获取当前选择的新闻分类
              AFirstNewsFilterClassifyJson:=lbNewsContentClassify.Prop.SelectedItem.Json;
              TTimerTask(ATimerTask).TaskDesc :=
                  SimpleCallAPI('get_content_list',
                      nil,
                      ContentCenterInterfaceUrl,
                      ['appid',
                      'user_fid',
                      'key',
                      'pageindex',
                      'pagesize',

                      'filter_big_type',
                      //导航菜单名称
                      'filter_name',

                      'filter_is_nearby',
                      'filter_province',
                      'filter_city',
                      'filter_longitude',
                      'filter_latitude',


                      'filter_type',

                      'filter_is_best',
                      'filter_is_hot',
                      'filter_is_famous_man_published',

                      'filter_user_fid',

                      'filter_is_small_video',
                      'filter_topic',
                      'filter_keyword',
                      //其他过滤参数
                      'filter_classify_json',

                      'filter_fav_user_fid',

                      'is_no_detail'
                      ],
                      [AppID,
                      GlobalManager.User.fid,
                      GlobalManager.User.key,
                      FPageIndex,
                      20,

                      AFirstNewsFilterClassifyJson.S['big_type'],
                      AFirstNewsFilterClassifyJson.S['filter_name'],

                      AFirstNewsFilterClassifyJson.S['is_nearby'],
                      '',
                      '',
                      '',
                      '',

                      AFirstNewsFilterClassifyJson.S['type'],


                      AFirstNewsFilterClassifyJson.S['is_best'],
                      AFirstNewsFilterClassifyJson.S['is_hot'],
                      AFirstNewsFilterClassifyJson.S['is_famous_man_published'],

                      '',//AFirstNewsFilterClassifyJson.S['user_fid'],

                      AFirstNewsFilterClassifyJson.S['is_small_video'],
                      AFirstNewsFilterClassifyJson.S['topic'],
                      AFirstNewsFilterClassifyJson.S['keyword'],
                      AFirstNewsFilterClassifyJson.AsJson,

                      '',
                      AFirstNewsFilterClassifyJson.S['is_no_detail']//'1'
                      ],
                      GlobalRestAPISignType,
                      GlobalRestAPIAppSecret
                      );
//          end;


    end;
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

procedure TFrameHome.DoGetHomeFrameInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ADrawPicture:TDrawPicture;
  I:Integer;
  AListViewItem:TSkinItem;
  AHomeAd:ISuperObject;
  ARecordJson:ISuperObject;
  ASuperArray:ISuperArray;
  ANewsArray:ISuperArray;
  lbFilterClassify:TSkinListBox;
  AListItemTypeStyleSetting:TListItemTypeStyleSetting;
  AOldSelectIndex:Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


          Self.lvHome.Prop.Items.BeginUpdate;
          try



              //主页信息获取成功
              //加载信息
              if FPageIndex=1 then
              begin
                  Self.lvHome.Prop.Items.ClearItemsByType(sitDefault);
                  Self.lvHome.Prop.Items.ClearItemsByType(sitItem3);



                  //加载首页广告图片
                  FHomeAdArray:=ASuperObject.O['Data'].A['HomeAdList'];

                  AHomeAd:=LocateJsonArray(ASuperObject.O['Data'].A['RecordList'],
                                          'type',
                                          'home_ad'
                                          );
                  //判断是否存在广告
                  if (FHomeAdItem<>nil) and (FHomeAdArray<>nil) and (FHomeAdArray.Length>0) then
                  begin
                      //判断是否存在广告
                      FHomeAdItem.Json:=AHomeAd;
//                      FHomeAdItem.Height:=
//                              Self.lvHome.Width/FHomeAdItem.Json.F['size_rate'];
                      FHomeAdItem.SubItems.Clear;
                      for I := 0 to FHomeAdArray.Length-1 do
                      begin
                        FHomeAdItem.SubItems.Add(GetImageUrl(FHomeAdArray.O[I].S['picpath']));
                      end;
                      FHomeAdItem.IsBufferNeedChange:=True;

                      lvHomeResize(nil);
                  end;



                  //获取列表成功
                  ASuperArray:=ASuperObject.O['Data'].A['NewsFilterClassifyList'];
//                  if (FNewFilterClassifyHorzListBoxItem<>nil)
//                    and (ASuperArray.Length>0)
//                    and (FListItemStyleFrame_HorzListBox.lbData.Prop.Items.Count<>ASuperArray.Length) then
//                  begin
//
//                      //添加新闻分类
//                      //添加过了就不用再添加了
//                      FListItemStyleFrame_HorzListBox.lbData.Prop.Items.BeginUpdate;
//                      try
//                        FListItemStyleFrame_HorzListBox.lbData.Prop.Items.Clear;
//
//                        for I := 0 to ASuperArray.Length-1 do
//                        begin
//                          AListViewItem:=FListItemStyleFrame_HorzListBox.lbData.Prop.Items.Add;
//                          AListViewItem.Json:=ASuperArray.O[I];
//
//                          //分类名称
//                          AListViewItem.Caption:=ASuperArray.O[I].S['filter_name'];
//                        end;
//
//                      finally
//                        FListItemStyleFrame_HorzListBox.lbData.Prop.Items.EndUpdate();
//                      end;
//
//
//                      //默认加载第一页
//                      if FListItemStyleFrame_HorzListBox.lbData.Prop.Items.Count>0 then
//                      begin
//                        FListItemStyleFrame_HorzListBox.lbData.Prop.Items[0].Selected:=True;
//                      end;
//
//                  end;

                  AOldSelectIndex:=0;
                  if Self.lbNewsContentClassify.Prop.SelectedItem<>nil then
                  begin
                    AOldSelectIndex:=Self.lbNewsContentClassify.Prop.SelectedItem.Index;
                  end;
                  if (ASuperArray.Length>0)
                    //and (Self.lbNewsContentClassify.Prop.Items.Count<>ASuperArray.Length)
                     then
                  begin

                      //添加新闻分类
                      //添加过了就不用再添加了
                      Self.lbNewsContentClassify.Prop.Items.BeginUpdate;
                      try
                        Self.lbNewsContentClassify.Prop.Items.Clear;

                        for I := 0 to ASuperArray.Length-1 do
                        begin
                          AListViewItem:=Self.lbNewsContentClassify.Prop.Items.Add;
                          AListViewItem.Json:=ASuperArray.O[I];

                          //分类名称
                          AListViewItem.Caption:=ASuperArray.O[I].S['filter_name'];
                        end;

                      finally
                        Self.lbNewsContentClassify.Prop.Items.EndUpdate();
                      end;


                      //默认加载第一页
                      if Self.lbNewsContentClassify.Prop.Items.Count>0 then
                      begin
                        Self.lbNewsContentClassify.Prop.Items[AOldSelectIndex].Selected:=True;
                      end;

                  end;
//                  Self.FButtonsItem.Visible:=(AOldSelectIndex=0);
                  //Self.FButtonsItem2.Visible:=(AOldSelectIndex=0);
                  FHotSuggestItem.Visible:=(AOldSelectIndex=0);

                  if Self.lbNewsContentClassify.Prop.SelectedItem=nil then
                  begin
                    Exit;
                  end;
                  //先设置Item的样式,以便确定Item的高度
//                  SetListViewForContentFilterClassify(lvHome,
//                                    Self.lbNewsContentClassify.Prop.SelectedItem.Json);






                  if ASuperObject.O['Data'].Contains('RecordList') then
                  begin
                    ANewsArray:=ASuperObject.O['Data'].A['RecordList'];
                  end;

                  if ASuperObject.O['Data'].Contains('NewsList') then
                  begin
                    ANewsArray:=ASuperObject.O['Data'].A['NewsList'];
                  end;


                  //保存第一页缓存到本地
                  ASuperObject.B['IsCache']:=True;
                  SaveStringToFile(ASuperObject.AsJSON,GlobalManager.GetUserLocalDir+'home_cache.json',TEncoding.UTF8);

              end
              else
              begin
                  ANewsArray:=ASuperObject.O['Data'].A['RecordList'];
              end;




              //加载新闻列表
              for I := 0 to ANewsArray.Length-1 do
              begin

                AListViewItem:=Self.lvHome.Prop.Items.Add;
                LoadContentItem(AListViewItem,
                                ANewsArray.O[I],
                                lvHome,
                                Self.lbNewsContentClassify.Prop.SelectedItem.Json,
                                False);

                AListViewItem.Width:=-2;


              end;


          finally
            Self.lvHome.Prop.Items.EndUpdate();
          end;


      end
      else
      begin
        //获取失败
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
//      HideWaitingFrame;

      if FPageIndex>1 then
      begin
//        if (TTimerTask(ATimerTask).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['ShopList'].Length>0) then
//        begin
          Self.lvHome.Prop.StopPullUpLoadMore('加载成功!',0,True);
//        end
//        else
//        begin
//          Self.lvHome.Prop.StopPullUpLoadMore('下面没有了!',600,False);
//        end;
      end
      else
      begin
        Self.lvHome.Prop.StopPullDownRefresh('刷新成功!',600);
      end;


  end;
end;


procedure TFrameHome.DoGetNewsListExecute(ATimerTask: TObject);
var
  AFirstNewsFilterClassifyJson:ISuperObject;
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try

//    if Self.FListItemStyleFrame_HorzListBox<>nil then
//    begin
//      //获取到当前选择的新闻分类
//      AFirstNewsFilterClassifyJson:=FListItemStyleFrame_HorzListBox.lbData.Prop.SelectedItem.Json;

      //获取到当前选择的新闻分类
      AFirstNewsFilterClassifyJson:=Self.lbNewsContentClassify.Prop.SelectedItem.Json;

      TTimerTask(ATimerTask).TaskDesc :=
          SimpleCallAPI('get_content_list',
              nil,
              ContentCenterInterfaceUrl,
              ['appid',
              'user_fid',
              'key',
              'pageindex',
              'pagesize',

              'filter_big_type',
              //导航菜单名称
              'filter_name',

              'filter_is_nearby',
              'filter_province',
              'filter_city',
              'filter_longitude',
              'filter_latitude',


              'filter_type',

              'filter_is_best',
              'filter_is_hot',
              'filter_is_famous_man_published',

              'filter_user_fid',

              'filter_is_small_video',
              'filter_topic',
              'filter_keyword',
              //其他过滤参数
              'filter_classify_json',

              'filter_fav_user_fid',
              'is_no_detail'
              ],
              [AppID,
              GlobalManager.User.fid,
              GlobalManager.User.key,
              FPageIndex,
              20,

              AFirstNewsFilterClassifyJson.S['big_type'],
              AFirstNewsFilterClassifyJson.S['filter_name'],

              AFirstNewsFilterClassifyJson.S['is_nearby'],
              '',
              '',
              '',
              '',

              AFirstNewsFilterClassifyJson.S['type'],


              AFirstNewsFilterClassifyJson.S['is_best'],
              AFirstNewsFilterClassifyJson.S['is_hot'],
              AFirstNewsFilterClassifyJson.S['is_famous_man_published'],

              '',//AFirstNewsFilterClassifyJson.S['user_fid'],

              AFirstNewsFilterClassifyJson.S['is_small_video'],
              AFirstNewsFilterClassifyJson.S['topic'],
              AFirstNewsFilterClassifyJson.S['keyword'],
              AFirstNewsFilterClassifyJson.AsJson,

              '',
              AFirstNewsFilterClassifyJson.S['is_no_detail']
              ],
              GlobalRestAPISignType,
              GlobalRestAPIAppSecret
              );

      if TTimerTask(ATimerTask).TaskDesc <> '' then
      begin
        TTimerTask(ATimerTask).TaskTag := 0;
      end;

//    end;
  except
    on E: Exception do
    begin
      // 异常
      TTimerTask(ATimerTask).TaskDesc := E.Message;
    end;
  end;


end;

procedure TFrameHome.DoGetNewsListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I:Integer;
  AListViewItem:TSkinItem;
  ANewsArray:ISuperArray;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


          Self.lvHome.Prop.Items.BeginUpdate;
          try


                //先设置Item的样式,以便确定Item的高度
//              if (FListItemStyleFrame_HorzListBox<>nil)
//                and (FListItemStyleFrame_HorzListBox.lbData.Prop.SelectedItem<>nil)
//                and (FListItemStyleFrame_HorzListBox.lbData.Prop.SelectedItem.Caption='直播')
//                then
//              begin
                SetListViewForContentFilterClassify(lvHome,
                                  Self.lbNewsContentClassify.Prop.SelectedItem.Json);
//              end
//              else
//              begin
//                lvHome.Prop.ItemHeight:=88;
//              end;



              //加载信息
              if FPageIndex=1 then
              begin
                lvHome.Prop.Items.ClearItemsByType(sitDefault);
                lvHome.Prop.Items.ClearItemsByType(sitItem3);

                //只有第一个分类有功能按钮
//                Self.FButtonsItem.Visible:=(Self.lbNewsContentClassify.Prop.SelectedItem.Index=0);
                //Self.FButtonsItem2.Visible:=(Self.lbNewsContentClassify.Prop.SelectedItem.Index=0);

                FHotSuggestItem.Visible:=(Self.lbNewsContentClassify.Prop.SelectedItem.Index=0);

              end;
              ANewsArray:=ASuperObject.O['Data'].A['RecordList'];


              //加载新闻列表
              for I := 0 to ANewsArray.Length-1 do
              begin
//                AListViewItem:=TSkinJsonItem.Create;
//                Self.lvHome.Prop.Items.Add(AListViewItem);//Insert(APromotionTypeIndex+1);
//                AListViewItem.Json:=ANewsArray.O[I];

                AListViewItem:=Self.lvHome.Prop.Items.Add;
                LoadContentItem(AListViewItem,
                                ANewsArray.O[I],
                                lvHome,
                                Self.lbNewsContentClassify.Prop.SelectedItem.Json,
                                False);


//                if (FListItemStyleFrame_HorzListBox<>nil)
//                  and (FListItemStyleFrame_HorzListBox.lbData.Prop.SelectedItem<>nil)
//                  and (FListItemStyleFrame_HorzListBox.lbData.Prop.SelectedItem.Caption='直播')
//                  then
//                begin
//
////                  lvHome.Prop.ItemHeight:=120;
//                end
//                else
//                begin
                  AListViewItem.Width:=-2;
////                  lvHome.Prop.ItemHeight:=88;
//                end;





                //大图片
              //  //大图片
              //  AListViewItem.Detail3:=GetImageUrl(ADataJson.S['pic1_path'],itNone,True);
                AListViewItem.Pic.Url:=GetImageUrl(ANewsArray.O[I].S['pic1_path'],itNone,False);//True);
                AListViewItem.Pic.PictureDrawType:=TPictureDrawType.pdtUrl;
              //  AListViewItem.Pic.IsClipRound:=True;
                //先直接下载
//                GetGlobalDownloadPictureManager.DownloadPicture(AListViewItem.Pic.Url);

              end;





          finally
            Self.lvHome.Prop.Items.EndUpdate();
          end;

      end
      else
      begin
        //获取失败
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

      if FPageIndex>1 then
      begin
//        if (TTimerTask(ATimerTask).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['ShopList'].Length>0) then
//        begin
          Self.lvHome.Prop.StopPullUpLoadMore('加载成功!',0,True);
//        end
//        else
//        begin
//          Self.lvHome.Prop.StopPullUpLoadMore('下面没有了!',600,False);
//        end;
      end
      else
      begin
        Self.lvHome.Prop.StopPullDownRefresh('刷新成功!',600);
      end;

  end;

end;

//procedure TFrameHome.DoGetWeatherExecute(ATimerTask: TObject);
////var
////  AHttpControl:THttpControl;
////  AResponseStream:TStringStream;
//begin
//  // 出错
//  TTimerTask(ATimerTask).TaskTag := 1;
////  AHttpControl:=TSystemHttpControl.Create;
////  AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
//  try
//      try
//
//
//          TTimerTask(ATimerTask).TaskDesc :=
//              FYahooWeatherSDK.GetWeatherResponseByGPS(GlobalGPSLocation.Longitude,
//                                                        GlobalGPSLocation.Latitude);
//
//          if Pos('yahoo:error',TTimerTask(ATimerTask).TaskDesc)>0 then
//          begin
//            //调用失败
//            TTimerTask(ATimerTask).TaskDesc:='';
//          end;
//
//
//  //          GetWebUrl_From_OrangeUIServer(AHttpControl,
////            SimpleCallAPI('',
////                          nil,
////                          'https://query.yahooapis.com/v1/public/yql'
////                         +'?q=select * from weather.forecast '
////                         +'where woeid in (select woeid from '
////                         +'geo.places(1) where text='''+GlobalGPSLocation.City
////                         +''')&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys',
////                          [],
////                          []);
////                        AResponseStream);
////        TTimerTask(ATimerTask).TaskDesc :=AResponseStream.DataString;
//
//
//          if TTimerTask(ATimerTask).TaskDesc <> '' then
//          begin
//            TTimerTask(ATimerTask).TaskTag := 0;
//          end;
//
//      except
//        on E: Exception do
//        begin
//          // 异常
//          TTimerTask(ATimerTask).TaskDesc := E.Message;
//        end;
//      end;
//  finally
////    FreeAndNil(AHttpControl);
////    FreeAndNil(AResponseStream);
//  end;
//end;
//
//procedure TFrameHome.DoGetWeatherExecuteEnd(ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//  AWeatherCode:Integer;
//  ATemp:String;
//begin
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//          GlobalManager.WeatherType:='';
//
//          ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//          if ASuperObject.Contains('current_observation') then
//          begin
//              //	"current_observation": {
//              //		"wind": {
//              //			"chill": 57,
//              //			"direction": 295,
//              //			"speed": 2.49
//              //		},
//              //		"atmosphere": {
//              //			"humidity": 83,
//              //			"visibility": 10.0,
//              //			"pressure": 29.77,
//              //			"rising": 0
//              //		},
//              //		"astronomy": {
//              //			"sunrise": "6:28 am",
//              //			"sunset": "7:47 pm"
//              //		},
//              //		"condition": {
//              //			"text": "Mostly Cloudy",
//              //			"code": 27,
//              //			"temperature": 57
//              //		},
//              //		"pubDate": 1555668000
//              //	},
////              //温度  摄氏度
//              ATemp:=IntToStr((ASuperObject.O['current_observation'].O['condition'].I['temperature']));
//              ATemp:=FormatFloat('0',((StrToInt(ATemp)-32)/1.8))+'℃';
//              Self.lblTempValue.Text:=ATemp;
//
//
//              //天气情况
//              AWeatherCode:=ASuperObject.O['current_observation'].O['condition'].I['code'];
//              Self.imgTemp.Prop.Picture:=Self.imgListWeather.PictureList.Items[WeatherIcon(AWeatherCode)];
//              Self.lblTempExplain.Text:=WeatherString(AWeatherCode);
//
//              if WeatherString(AWeatherCode)<>'晴天' then
//              begin
//                GlobalManager.WeatherType:='bad';
//              end
//              else
//              begin
//                GlobalManager.WeatherType:='good';
//              end;
//
//              GlobalManager.Save;
//
//          end;
//
//
////          if ASuperObject.Contains('error') then
////          begin
////              GlobalManager.WeatherType:='';
////              //获取失败
////      //        ShowMessageBoxFrame(Self,ASuperObject.O['error'].AsJSON+'99','',TMsgDlgType.mtInformation,['确定'],nil);
////          end
////          else
////          begin
////              //{"code":"26","date":"Thu, 05 Jul 2018 12:00 PM CST","temp":"91","text":"Cloudy"}
////              //温度  摄氏度
////              ATemp:=ASuperObject.O['query'].O['results'].O['channel'].O['item'].O['condition'].S['temp'];
////              ATemp:=FormatFloat('0',((StrToInt(ATemp)-32)/1.8))+'℃';
////              Self.lblTempValue.Text:=ATemp;
//
////              //天气情况
////              AWeatherCode:=StrToInt(ASuperObject.O['query'].O['results'].O['channel'].O['item'].O['condition'].S['code']);
////              Self.imgTemp.Prop.Picture:=Self.imgListWeather.PictureList.Items[WeatherIcon(AWeatherCode)];
////              Self.lblTempExplain.Text:=WeatherString(AWeatherCode);
////
////              if WeatherString(AWeatherCode)<>'晴天' then
////              begin
////                GlobalManager.WeatherType:='bad';
////              end
////              else
////              begin
////                GlobalManager.WeatherType:='good';
////              end;
////
////              GlobalManager.Save;
////
////          end;
//
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常(天气接口偶尔会取不到报错)
////      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    //不需要
////    HideWaitingFrame;
//  end;
//end;

//procedure TFrameHome.DoGetUserCarGoodsListExecute(ATimerTask: TObject);
//begin
//  // 出错
//  TTimerTask(ATimerTask).TaskTag := 1;
//  try
//    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_user_cart_goods_list',
//                                                      nil,
//                                                      ShopCenterInterfaceUrl,
//                                                      ['appid',
//                                                      'user_fid',
//                                                      'key',
//                                                      'longitude',
//                                                      'latitude'],
//                                                      [AppID,
//                                                      GlobalManager.User.fid,
//                                                      GlobalManager.User.key,
//                                                      119.648994,
//                                                      29.076664
//                                                      ]
//                                                      );
//    if TTimerTask(ATimerTask).TaskDesc <> '' then
//    begin
//      TTimerTask(ATimerTask).TaskTag := 0;
//    end;
//
//  except
//    on E: Exception do
//    begin
//      // 异常
//      TTimerTask(ATimerTask).TaskDesc := E.Message;
//    end;
//  end;
//end;
//
//procedure TFrameHome.DoGetUserCarGoodsListExecuteEnd(ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//  I: Integer;
//begin
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//        //获取成功
//        Self.FCarShopList.ParseFromJsonArray(TCarShop,ASuperObject.O['Data'].A['CartGoodsList']);
//
//        for I := 0 to self.FCarShopList.Count-1 do
//        begin
//          Self.lvHome.Prop.Items.FindItemByDetail6(IntToStr(Self.FCarShopList[I].fid)).Detail5:=
//                                          IntToStr(Self.FCarShopList[I].FCarGoodList.Count);
//        end;
//
//      end
//      else
//      begin
//        //调用失败
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
//
//  end;
//end;


procedure TFrameHome.DoListBoxVertManagerPrepareDecidedFirstGestureKind(
  Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
  var AIsDecidedFirstGestureKind: Boolean;
  var ADecidedFirstGestureKind: TGestureKind);
var
  AFirstItemRect:TRectF;
begin
  //广告轮播Item的绘制区域
  if Self.lvHome.Prop.Items.FindItemByName('home_ad')<>nil then
  begin
      AFirstItemRect:=Self.lvHome.Prop.Items.FindItemByName('home_ad').ItemDrawRect;
      if PtInRect(AFirstItemRect,PointF(AMouseMoveX,AMouseMoveY)) then
      begin
          //在广告轮播控件内,那么要检查初始手势方向
      end
      else
      begin
          //不在在广告轮播控件内,那么随意滑动
          AIsDecidedFirstGestureKind:=True;
          ADecidedFirstGestureKind:=TGestureKind.gmkVertical;
      end;
  end
  else
  begin

          //不在在广告轮播控件内,那么随意滑动
          AIsDecidedFirstGestureKind:=True;
          ADecidedFirstGestureKind:=TGestureKind.gmkVertical;

  end;

end;

procedure TFrameHome.DoLocationAddrChange;
begin
  OutputDebugString('OrangeUI TFrameHome.DoLocationAddrChange IsGPSLocated:'+BoolToStr(GlobalManager.IsGPSLocated));

//  Self.btnAddr.Caption:=GlobalManager.RegionName;
//  Self.SetingButtonWidth(Self.btnAddr.Caption);
//
//  Self.lvHome.Prop.StartPullDownRefresh;

end;

procedure TFrameHome.DoLocationChange;
begin
  OutputDebugString('OrangeUI TFrameHome.DoLocationChange');



//  OutputDebugString('OrangeUI TFrameHome.DoLocationChange LocationAddrChange'+' ThreadID:'+IntToStr(TThread.CurrentThread.ThreadID));
//
//
//  //刷新
//  Self.FIsOnlyUpdateShopList:=False;
//
//  OutputDebugString('OrangeUI TFrameHome.DoLocationChange SyncWaitProcessCount'+' ThreadID:'+IntToStr(TThread.CurrentThread.ThreadID));
//  Self.SyncWaitProcessCount('','','');
//
//
//  if (GlobalHomeAddrFrame<>nil) and (CurrentFrame=GlobalHomeAddrFrame) then
//  begin
//    OutputDebugString('OrangeUI TFrameHome.DoLocationChange GlobalHomeAddrFrame.DoLocationAddrChange');
//    GlobalHomeAddrFrame.DoLocationChange;
//  end;


end;

procedure TFrameHome.DoGeocodeAddrError;
begin
  OutputDebugString('OrangeUI TFrameHome.DoGeocodeAddrError');

//  Self.btnAddr.Caption:='地址解析出错了...';
//  Self.SetingButtonWidth(Self.btnAddr.Caption);
//
//  if (GlobalHomeAddrFrame<>nil) and (CurrentFrame=GlobalHomeAddrFrame) then
//  begin
//    GlobalHomeAddrFrame.DoGeocodeAddrError;
//  end;
end;

procedure TFrameHome.DoGeocodeAddrTimeout;
begin
  OutputDebugString('OrangeUI TFrameHome.DoGeocodeAddrTimeout');

//  Self.btnAddr.Caption:='地址解析超时了...';
//  Self.SetingButtonWidth(Self.btnAddr.Caption);

end;

procedure TFrameHome.DoLocationStartError;
begin
  OutputDebugString('OrangeUI TFrameHome.DoLocationStartError');

//  Self.btnAddr.Caption:='定位启动出错了...';
//  Self.SetingButtonWidth(Self.btnAddr.Caption);
////  HideWaitingFrame;
//
//  if (GlobalHomeAddrFrame<>nil) and (CurrentFrame=GlobalHomeAddrFrame) then
//  begin
//    GlobalHomeAddrFrame.DoLocationStartError;
//  end;
//
//
//  //加载
//  ShowMessageBoxFrame(Self,
//                      '定位服务未开启',
//                      '请在设置->隐私->定位服务中开启定位服务,R4U需要您的位置才能提供更好的服务~',
//                      TMsgDlgType.mtInformation,
//                      ['手动搜索地址','取消'],
//                      OnModalResultFromLeaveOrder);
end;

procedure TFrameHome.DoLocationTimeout;
begin
  OutputDebugString('OrangeUI TFrameHome.DoLocationTimeout');

//  Self.btnAddr.Caption:='定位超时了...';
//  Self.SetingButtonWidth(Self.btnAddr.Caption);
////  HideWaitingFrame;
//
//  if (GlobalHomeAddrFrame<>nil) and (CurrentFrame=GlobalHomeAddrFrame) then
//  begin
//    GlobalHomeAddrFrame.DoLocationTimeout;
//  end;
//
//  //加载
//  ShowMessageBoxFrame(Self,
//                      '定位服务未开启',
//                      '请在设置->隐私->定位服务中开启定位服务,R4U需要您的位置才能提供更好的服务~',
//                      TMsgDlgType.mtInformation,
//                      ['手动搜索地址','取消'],
//                      OnModalResultFromLeaveOrder);
end;

procedure TFrameHome.DoStartLocation;
begin
  OutputDebugString('OrangeUI TFrameHome.DoStartLocation Begin');

//  ShowWaitingFrame(frmMain,'定位中...');

//  OutputDebugString('OrangeUI TFrameHome.DoStartLocation 1');
//
//
//  Self.btnAddr.Caption:='正在识别地址...';
//  Self.SetingButtonWidth(Self.btnAddr.Caption);
//
//  OutputDebugString('OrangeUI TFrameHome.DoStartLocation 2');
//
//  //未定位成功,不能让他下拉上拉刷新
////  Self.lvHome.Prop.EnableAutoPullDownRefreshPanel:=False;
////  Self.lvHome.Prop.EnableAutoPullUpLoadMorePanel:=False;
//
//  OutputDebugString('OrangeUI TFrameHome.DoStartLocation End');
//
//
//  if (GlobalHomeAddrFrame<>nil) and (CurrentFrame=GlobalHomeAddrFrame) then
//  begin
//    GlobalHomeAddrFrame.DoStartLocation;
//  end;

end;

procedure TFrameHome.FramePaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
   //播放视频退出后，如果窗体不是竖立，调整为竖立状态
//    if not IsPortraitOrientation then  SetPortraitOrientation;
end;

function TFrameHome.GetFillColor: TDelphiColor;
begin
  Result:=uGraphicCommon.SkinThemeColor;
end;

function TFrameHome.GetFormColor: TDelphiColor;
begin
  Result:=uGraphicCommon.SkinThemeColor;
end;

//procedure TFrameHome.GetShowStar(ANumber: Double);
//begin
//  if (ANumber>=0) and (ANumber<1) then
//  begin
//    Self.imgStar1.Prop.Picture.ImageIndex:=1;
//    Self.imgStar2.Prop.Picture.ImageIndex:=1;
//    Self.imgStar3.Prop.Picture.ImageIndex:=1;
//    Self.imgStar4.Prop.Picture.ImageIndex:=1;
//    Self.imgStar5.Prop.Picture.ImageIndex:=1;
//  end;
//
//  if (ANumber>=1) and (ANumber<2) then
//  begin
//    Self.imgStar1.Prop.Picture.ImageIndex:=0;
//    Self.imgStar2.Prop.Picture.ImageIndex:=1;
//    Self.imgStar3.Prop.Picture.ImageIndex:=1;
//    Self.imgStar4.Prop.Picture.ImageIndex:=1;
//    Self.imgStar5.Prop.Picture.ImageIndex:=1;
//  end;
//
//
//  if (ANumber>=2) and (ANumber<3) then
//  begin
//    Self.imgStar1.Prop.Picture.ImageIndex:=0;
//    Self.imgStar2.Prop.Picture.ImageIndex:=0;
//    Self.imgStar3.Prop.Picture.ImageIndex:=1;
//    Self.imgStar4.Prop.Picture.ImageIndex:=1;
//    Self.imgStar5.Prop.Picture.ImageIndex:=1;
//  end;
//
//  if (ANumber>=3) and (ANumber<4) then
//  begin
//    Self.imgStar1.Prop.Picture.ImageIndex:=0;
//    Self.imgStar2.Prop.Picture.ImageIndex:=0;
//    Self.imgStar3.Prop.Picture.ImageIndex:=0;
//    Self.imgStar4.Prop.Picture.ImageIndex:=1;
//    Self.imgStar5.Prop.Picture.ImageIndex:=1;
//  end;
//
//  if (ANumber>=4) and (ANumber<5) then
//  begin
//    Self.imgStar1.Prop.Picture.ImageIndex:=0;
//    Self.imgStar2.Prop.Picture.ImageIndex:=0;
//    Self.imgStar3.Prop.Picture.ImageIndex:=0;
//    Self.imgStar4.Prop.Picture.ImageIndex:=0;
//    Self.imgStar5.Prop.Picture.ImageIndex:=1;
//  end;
//
//  if ANumber>=5 then
//  begin
//    Self.imgStar1.Prop.Picture.ImageIndex:=0;
//    Self.imgStar2.Prop.Picture.ImageIndex:=0;
//    Self.imgStar3.Prop.Picture.ImageIndex:=0;
//    Self.imgStar4.Prop.Picture.ImageIndex:=0;
//    Self.imgStar5.Prop.Picture.ImageIndex:=0;
//  end;
//end;

procedure TFrameHome.imgPlayerResize(Sender: TObject);
begin
//  //设置按钮分组的位置
//  Self.bgIndicator.Position.X:=Self.imgPlayer.Width
//                                -Self.imglistPlayer.Count*bgIndicator.Height-20;
//  Self.bgIndicator.Position.Y:=Self.imgPlayer.Height-20;

end;

procedure TFrameHome.imgSearchBarClick(Sender: TObject);
begin

  //搜索新闻
  HideFrame;
  ShowFrame(TFrame(GlobalSearchContentClassifyFrame),TFrameContentClassify);//,Self.tsCommunity,nil,nil,nil,Self,False,True,ufsefNone);
  GlobalSearchContentClassifyFrame.Load('news',
                                      'ContentNews',
                                      88,
                                      True,
                                      False,
                                      True);
end;

procedure TFrameHome.imgTempClick(Sender: TObject);
//var
//  ANotification:TNotification;
begin
//  ANotification:=NotificationCenter1.CreateNotification;
//  ANotification.Title:='111';
//  ANotification.AlertBody:='2222';
//  ANotification.EnableSound:=True;
//  NotificationCenter1.PresentNotification(ANotification);

//  ShowMessage('aa');
end;

procedure TFrameHome.imgUserHeadClick(Sender: TObject);
begin
  GlobalMainFrame.ShowSideMenuFrame;
end;

//procedure TFrameHome.Init(ACarShopList: TCarShopList);
////var
////  I:Integer;
////  ANumber:Integer;
////  J: Integer;
////  K:Integer;
//begin
//  FMX.Types.Log.d('OrangeUI TFrameHome Init ');
//
////  Self.FCarShopList:=ACarShopList;
////
////  if GlobalManager.IsLogin=True then
////  begin
////    if ACarShopList.Count>0 then
////    begin
////      Self.btnOrderCar.Prop.Icon.ImageIndex:=2;
////    end
////    else
////    begin
////      Self.btnOrderCar.Prop.Icon.ImageIndex:=1;
////    end;
////  end
////  else
////  begin
////    Self.btnOrderCar.Prop.Icon.ImageIndex:=1;
////  end;
////
////  for I := 0 to Self.lvHome.Prop.Items.Count-1 do
////  begin
////    if Self.lvHome.Prop.Items[I].ItemType=sitDefault then
////    begin
////      if (Self.lvHome.Prop.Items[I].Tag1=1) and (Self.lvHome.Prop.Items[I].Tag=1) then
////      begin
////        Self.lvHome.Prop.Items[I].Detail5:='0';
////
////        if Self.FCarShopList<>nil then
////        begin
////          for J := 0 to self.FCarShopList.Count-1 do
////          begin
////            ANumber:=0;
////            for K := 0 to Self.FCarShopList[J].FCarGoodList.Count-1 do
////            begin
////              ANumber:=ANumber+Self.FCarShopList[J].FCarGoodList[K].number;
////            end;
////            FMX.Types.Log.d('OrangeUI TFrameHome UserCarGoodsCount  ANumber'+IntToStr(ANumber));
////            if StrToInt(Self.lvHome.Prop.Items[I].Detail6)=Self.FCarShopList[J].fid then
////            begin
////              Self.lvHome.Prop.Items[I].Detail5:=IntToStr(ANumber);
////            end;
////          end;
////        end;
////      end
////      else
////      begin
////         ANumber:=0;
////         Self.lvHome.Prop.Items[I].Detail5:=IntToStr(ANumber);
////      end;
////    end;
////  end;
//
//end;

procedure TFrameHome.lbAddListClickItem(AItem: TSkinItem);
begin
  Self.popuAdd.IsOpen:=False;

  if not GlobalManager.IsLogin then
  begin
    ShowLoginFrame(True);
    Exit;
  end;



  if AItem.Caption=Trans('动态') then
  begin
    //跳转发布动态页面
    HideFrame;//();
    ShowFrame(TFrame(GlobalAddContentFrame),TFrameAddContent);
    GlobalAddContentFrame.Load(cptCommunity);//'dt');
  end;

  if AItem.Caption=Trans('帖子') then
  begin
    //跳转发布帖子页面
    HideFrame;//();
    ShowFrame(TFrame(GlobalAddContentFrame),TFrameAddContent);
    GlobalAddContentFrame.Load(cptGroup);//'tz');
  end;

  if AItem.Caption=Trans('资讯') then
  begin
    //跳转发布资讯页面
    HideFrame;//();
    ShowFrame(TFrame(GlobalAddContentFrame),TFrameAddContent);
    GlobalAddContentFrame.Load(cptNews);//'zx');
  end;

end;

procedure TFrameHome.lbFilterClassifyClickItem(AItem: TSkinItem);
begin
  ShowWaitingFrame(nil,'加载中...');
  //ShowHintFrame(Self,AItem.caption);
  //选择新闻列表
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoGetNewsListExecute,
                 DoGetNewsListExecuteEnd,
                 'GetNewsList');

end;

procedure TFrameHome.lbKeyClickItem(AItem: TSkinItem);
begin
//  //搜索店铺列表，加载店铺
//  Self.FFilter_promotion_type:='';
//  Self.FFilterKey:=AItem.Caption;
//  //显示已搜索到的店铺列表
//  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//  ShowFrame(TFrame(GlobalShopListFrame),TFrameShopList,OnReturnFromShopListFrame);
//  GlobalShopListFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalShopListFrame.Clear;
//  GlobalShopListFrame.LoadShopList(FFilter_promotion_type,FFilterKey,True);
end;

procedure TFrameHome.lbNewsContentClassifyClickItem(AItem: TSkinItem);
begin
  ShowWaitingFrame(nil,'加载中...');
  //ShowHintFrame(Self,AItem.caption);
  //选择新闻列表
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoGetNewsListExecute,
                 DoGetNewsListExecuteEnd,
                 'GetNewsList');
end;

procedure TFrameHome.Load;
var
  ATimerTask:TTimerTask;
begin
//  ShowWaitingFrame(frmMain,'加载中...');

  FUserFID:=GlobalManager.User.fid;
  FPageIndex:=1;


  //头像
  imgUserHead.Prop.Picture.ImageIndex:=-1;
  imgUserHead.Prop.Picture.Url:=GlobalManager.User.GetHeadPicUrl;
  imgUserHead.Prop.Picture.IsClipRound:=True;


  //加载上次首页缓存
  if FileExists(GlobalManager.GetUserLocalDir+'home_cache.json') then
  begin
    ATimerTask:=TTimerTask.Create;
    ATimerTask.TaskDesc:=GetStringFromFile(GlobalManager.GetUserLocalDir()+'home_cache.json',
                                          TEncoding.UTF8);
    ATimerTask.TaskTag:=TASK_SUCC;
    Self.DoGetHomeFrameInfoExecuteEnd(ATimerTask);
  end;



  OutputDebugString('OrangeUI TFrameHome.Load 2');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
               DoGetHomeFrameInfoExecute,
               DoGetHomeFrameInfoExecuteEnd,
               'GetHomeFrameInfo');

end;

procedure TFrameHome.lvHomeClickItem(AItem: TSkinItem);
//var
//  I: Integer;
//var
//  AFilterCalssifyJson:ISuperObject;
begin

    if (AItem.Json<>nil)
      and AItem.Json.Contains('big_type')
       then
    begin

        FContentOperation.ViewContent(AItem.Json,nil,AItem);

//      //查看新闻
//      //网页链接
//      HideFrame;
//
//      //显示网页界面
//      ShowFrame(TFrame(GlobalWebBrowserFrame),TFrameWebBrowser);
//      GlobalWebBrowserFrame.LoadUrl(
//                                    Const_OpenWebRoot+'/community/content.php?'
//                                    +'appid='+IntToStr(AppID)
//                                    +'&user_fid='+GlobalManager.User.fid
//                                    +'&content_fid='+IntToStr(AItem.Json.I['fid']),
//                                    AItem.Json.S['caption']
//                                    );
    end
    else if AItem=FHotSuggestItem then
    begin

      //更多
      HideFrame;
      ShowFrame(TFrame(GlobalContentListFrame),TFrameContentList);
//      AFilterCalssifyJson:=TSuperObject.Create(Self.lbNewsContentClassify.Prop.SelectedItem.Json.AsJSON);
//      AFilterCalssifyJson.S['filter_name']:='更多';
      GlobalContentListFrame.Load(Self.lbNewsContentClassify.Prop.SelectedItem.Json);


    end;








//  if AItem.Json<>nil then
//  begin
//    if (AItem.Name='home_ad')
////      and AItem.Json.Contains('action')
////      and (AItem.Json.S['action']<>'')
//      then
//    begin
//
//
//        if (AItem.Json.S['action']='jump_to_url') then
//        begin
//
//
//
//            //跳转到网页
//            //是网页
//            //网页链接
//            HideFrame;
//
//            //显示网页界面
//            ShowFrame(TFrame(GlobalWebBrowserFrame),TFrameWebBrowser);
//            if (AItem.Json.S['url']<>'') then
//            begin
//                //显示自定义网页
//                GlobalWebBrowserFrame.LoadUrl(AItem.Json.S['url'],AItem.Json.S['caption']);
//            end
//            else
//            begin
//                //显示网页模板
//                GlobalWebBrowserFrame.LoadUrl(Const_News_Url+IntToStr(AItem.Json.I['fid']));
//
//            end;
//
//
//        end
//        else
//        if (AItem.Json.S['action']='jump_to_page') then
//        begin
//
//            //剩下的这些功能要登录才能使用
//            if not GlobalManager.IsLogin then
//            begin
//              ShowLoginFrame(True);
//              Exit;
//            end;
//
//            if (AItem.Json.S['name']='gift_package') then
//            begin
//                //显示礼包中心
//                //隐藏
//                HideFrame();
//                //显示礼包中心页面
//                ShowFrame(TFrame(GlobalGiftPackageCenterFrame),TFrameGiftPackageCenter);
//                GlobalGiftPackageCenterFrame.Load;
//            end
//            else if (AItem.Json.S['name']='my_score') then
//            begin
//                //显示积分页面
//                //隐藏
//                HideFrame();
//                //显示积分明细页面
//                ShowFrame(TFrame(GlobalMyScoreFrame),TFrameMyScore);
//                GlobalMyScoreFrame.Init(GlobalManager.User.score);
//            end
//            else if (AItem.Json.S['name']='user_suggestion') then
//            begin
//                //用户反馈
//                 //隐藏
//                 HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//                 //显示收藏列表
//                 ShowFrame(TFrame(GlobalUserSuggectionFrame),TFrameUserSuggection,frmMain,nil,nil,nil,Application);
//      //           GlobalUserSuggectionFrame.FrameHistroy:=CurrentFrameHistroy;
//                 GlobalUserSuggectionFrame.Add;
//            end
//            else if (AItem.Json.S['name']='captcha') then
//            begin
//                //显示验证码页面
//                //隐藏
//                HideFrame();
//                //显示验证码明细页面
//                ShowFrame(TFrame(GlobalCaptchaFrame),TFrameCaptcha);
//                GlobalCaptchaFrame.Load;
//            end
//            else if (AItem.Json.S['name']='activity') then
//            begin
//                //显示活动页面
//                //隐藏
//                HideFrame();
//                //显示活动明细页面
//                ShowFrame(TFrame(GlobalActivityListFrame),TFrameActivityList);
//                GlobalActivityListFrame.Load;
//            end;
//
//        end;
//
//    end
//    else
//
//    if (AItem.Json<>nil)
//      and AItem.Json.Contains('big_type')
////      and (AItem.Json.S['big_type']='news')
//       then
//    begin
//
//        FContentOperation.ViewContent(AItem.Json,nil,AItem);
//
////      //查看新闻
////      //网页链接
////      HideFrame;
////
////      //显示网页界面
////      ShowFrame(TFrame(GlobalWebBrowserFrame),TFrameWebBrowser);
////      GlobalWebBrowserFrame.LoadUrl(
////                                    Const_OpenWebRoot+'/community/content.php?'
////                                    +'appid='+IntToStr(AppID)
////                                    +'&user_fid='+GlobalManager.User.fid
////                                    +'&content_fid='+IntToStr(AItem.Json.I['fid']),
////                                    AItem.Json.S['caption']
////                                    );
//    end
//
//
//
//  end;


//  if AItem.ItemType=sitItem2 then
//  begin
//      //点击活动入口
//      Self.FFilter_promotion_type:=AItem.Name;
//
//      //加载页面
//      HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//      ShowFrame(TFrame(GlobalShopListFrame),TFrameShopList,OnFromShopListFrame);
//      GlobalShopListFrame.FrameHistroy:=CurrentFrameHistroy;
//      GlobalShopListFrame.Clear;
//      GlobalShopListFrame.LoadShopList(FFilter_promotion_type,AItem.Caption,False);
//  end;
//
//
//
//  if AItem.ItemType=sitDefault then
//  begin
//
//      //加载店铺详情
//      HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//      ShowFrame(TFrame(GlobalShopInfoFrame),TFrameShopInfo,OnFromShopInfoFrame);
//      GlobalShopInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//      GlobalShopInfoFrame.Clear;
//
//      if GlobalManager.IsLogin=True then
//      begin
//
//        if Self.FCarShopList<>nil then
//        begin
//
//          if Self.FCarShopList.FindItemByFID(StrToInt(AItem.Detail6))<>nil then
//          begin
//            GlobalShopInfoFrame.Load(StrToInt(AItem.Detail6),
//                                      Self.FCarShopList.FindItemByFID(StrToInt(AItem.Detail6)).FCarGoodList
//                                      );
//          end
//          else
//          begin
//            GlobalShopInfoFrame.Load(StrToInt(AItem.Detail6)
//                                      ,nil
//                                      );
//          end;
//
//        end
//        else
//        begin
//          GlobalShopInfoFrame.Load(StrToInt(AItem.Detail6)
//                                  ,nil
//                                  );
//        end;
//      end
//      else
//      begin
//        GlobalShopInfoFrame.Load(StrToInt(AItem.Detail6)
//                                  ,nil
//                                  );
//      end;
//
//  end;

end;

procedure TFrameHome.lvHomeClickItemDesignerPanelChild(Sender: TObject;
  AItem: TBaseSkinItem; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AChild: TFmxObject);
var
  AHomeAd:ISuperObject;
  ASkinButton:TSkinButton;
  imgPlayer: TSkinFMXImageListViewer;
begin
  //首页广告点击
  //imgPlayer
  if (AChild.Name='imgPlayer')
    and (AChild is TSkinFMXImageListViewer)
    and (FHomeAdArray<>nil)
    and (FHomeAdArray.Length>0) then
  begin

      imgPlayer:=TSkinFMXImageListViewer(AChild);
      AHomeAd:=nil;
      if (imgPlayer.Prop.Picture.ImageIndex>=0)
        and (imgPlayer.Prop.Picture.ImageIndex<Self.FHomeAdArray.Length)
        then
      begin
        AHomeAd:=Self.FHomeAdArray.O[imgPlayer.Prop.Picture.ImageIndex];
      end;

      if (AHomeAd<>nil) and (AHomeAd.S['url']<>'') then
      begin
          //跳转到网页
          //是网页
          //网页链接
          HideFrame;

          //显示网页界面
          ShowFrame(TFrame(GlobalWebBrowserFrame),TFrameWebBrowser);
          GlobalWebBrowserFrame.LoadUrl(AHomeAd.S['url'],
                                        AHomeAd.S['name']
                                        );
      end;

  end
  else if (AChild.Name='btnButton1')
          or (AChild.Name='btnButton2')
          or (AChild.Name='btnButton3')
          or (AChild.Name='btnButton4') then
  begin

            ASkinButton:=TSkinButton(AChild);
            //剩下的这些功能要登录才能使用
            if not GlobalManager.IsLogin then
            begin
              ShowLoginFrame(True);
              Exit;
            end;

            if (ASkinButton.Caption='礼包') then
            begin
//                //显示礼包中心
//                //隐藏
//                HideFrame();
//                //显示礼包中心页面
//                ShowFrame(TFrame(GlobalGiftPackageCenterFrame),TFrameGiftPackageCenter);
//                GlobalGiftPackageCenterFrame.Load;
            end
            else if (ASkinButton.Caption='积分') then
            begin
                //显示积分页面
                //隐藏
                HideFrame();
                //显示积分明细页面
                ShowFrame(TFrame(GlobalMyScoreFrame),TFrameMyScore);
                GlobalMyScoreFrame.Init;//(GlobalManager.User.score);
            end
            else if (ASkinButton.Caption='反馈') then
            begin
                //用户反馈
                 //隐藏
                 HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
                 //显示收藏列表
                 ShowFrame(TFrame(GlobalUserSuggectionFrame),TFrameUserSuggection,frmMain,nil,nil,nil,Application);
      //           GlobalUserSuggectionFrame.FrameHistroy:=CurrentFrameHistroy;
                 GlobalUserSuggectionFrame.Add;
            end
            else if (ASkinButton.Caption='验证码') then
            begin
//                //显示验证码页面
//                //隐藏
//                HideFrame();
//                //显示验证码明细页面
//                ShowFrame(TFrame(GlobalCaptchaFrame),TFrameCaptcha);
//                GlobalCaptchaFrame.Load;
            end
            else if (ASkinButton.Caption='活动') then
            begin
                //显示活动页面
                //隐藏
                HideFrame();
                //显示活动明细页面
                ShowFrame(TFrame(GlobalActivityCenterFrame),TFrameActivityCenter);
                GlobalActivityCenterFrame.Load;
            end
            else if (ASkinButton.Caption='扫码') then
            begin
                //扫码
                frmMain.ScanQRCode;
            end
            else if (ASkinButton.Caption='任务') then
            begin
                //我的任务
                //显示活动页面
                //隐藏
                HideFrame();
                //显示活动明细页面
                ShowFrame(TFrame(GlobalActivityCenterFrame),TFrameActivityCenter);
                GlobalActivityCenterFrame.Load;
            end
//            else if (ASkinButton.Caption='邀请') then
//            begin
//                //邀请
//                //隐藏
//                HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//                //显示邀请好友
//                ShowFrame(TFrame(GlobalMyInvitationCodeFrame),TFrameMyInvitationCode);
//                GlobalMyInvitationCodeFrame.Load;
//            end
            else if (ASkinButton.Caption='打卡') then
            begin
                ShowFrame(TFrame(GlobalSignFrame),TFrameSign,Application.MainForm,nil,nil,nil,Application,True,True,ufsefAlpha);
                GlobalSignFrame.Load;
            end
            ;

  end
  else if (TSkinItem(AItem).Json<>nil) and TSkinItem(AItem).Json.Contains('big_type') then
  begin
        //查看内容
        FContentOperation.ViewContent(TSkinItem(AItem).Json,nil,TSkinItem(AItem));

  end;
end;

procedure TFrameHome.lvHomePrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
//var
//  AShop:TShop;
//  I: Integer;
//var
//AFrameShortVideoListItemStyle:TFrameShortVideoListItemStyle;
//StrLength:Double;
begin
// //短视频人物性别图标
//  if (AItemDesignerPanel<>nil) and (AItemDesignerPanel.Parent is TFrameShortVideoListItemStyle) then
//  begin
//      AFrameShortVideoListItemStyle:=TFrameShortVideoListItemStyle(AItemDesignerPanel.Parent);
//      StrLength:=GetStringWidth(AFrameShortVideoListItemStyle.lblItemDetail.Caption,18);
//      AFrameShortVideoListItemStyle.lblItemDetail.Width:=Ceil(StrLength);
//      AFrameShortVideoListItemStyle.imgItemGender.Position.X:=ceil(StrLength)-6;
//  end;
//  if AItem.Data<>nil then
//  begin
//    AShop:=TShop(AItem.Data);
//    Self.GetShowStar(AShop.rating_score);
//    if AItem.Tag1=1 then
//    begin
//      if AItem.Tag=1 then
//      begin
//        Self.lbltag.Visible:=False;
//      end
//      else
//      begin
//        Self.lbltag.Visible:=True;
//        Self.lbltag.Caption:='商家休息中';
//      end;
//    end
//    else
//    begin
//      Self.lbltag.Visible:=True;
//      Self.lbltag.Caption:='暂停营业';
//    end;
//
//    if Self.lbltag.Visible=False then
//    begin
//      AItem.Tag:=1;
//      Self.imgPic.Left:=Self.lblDeliverFee.Left;
//      Self.lblShopType.Left:=Self.imgPic.Left+Self.imgPic.Width;
//    end
//    else
//    begin
//      AItem.Tag:=0;
//      Self.lbltag.Left:=Self.lblDeliverFee.Left;
//
//      Self.imgPic.Left:=Self.lbltag.Left+Self.lbltag.Width+5;
//      Self.lblShopType.Left:=Self.imgPic.Left+Self.imgPic.Width;
//    end;
//
//    if AShop.ShopPromotionList.Count=0 then
//    begin
//      Self.lblFull.Visible:=False;
//      Self.lblFullValue.Visible:=False;
//      Self.lblSpical.Visible:=False;
//      Self.lblSpicalValue.Visible:=False;
//      AItem.Height:=110;
//    end
//    else
//    begin
//      if AShop.ShopPromotionList.Count=1 then
//      begin
//        Self.lblFull.Visible:=True;
//        Self.lblFullValue.Visible:=True;
//        Self.lblSpical.Visible:=False;
//        Self.lblSpicalValue.Visible:=False;
//        AItem.Height:=140;
//      end
//      else
//      begin
//        Self.lblFull.Visible:=True;
//        Self.lblFullValue.Visible:=True;
//
//        Self.lblSpical.Visible:=True;
//        Self.lblSpicalValue.Visible:=True;
//
//        AItem.Height:=160;
//      end;
//
//      for I := 0 to AShop.ShopPromotionList.Count-1 do
//      begin
//        if I=0 then
//        begin
//          if (Ashop.ShopPromotionList[I].promotion_type='full_dec_money')
//             or (Ashop.ShopPromotionList[I].promotion_type='coupon') then
//          begin
//            if AShop.ShopPromotionList[I].promotion_type='full_dec_money' then
//            begin
//              Self.lblFull.Caption:='満减';
//            end
//            else
//            begin
//              Self.lblFull.Caption:='红包';
//            end;
//            Self.lblFullValue.Caption:=GetActivityRules(Ashop.ShopPromotionList[I].full_money1,Ashop.ShopPromotionList[I].dec_money1,
//                                                        Ashop.ShopPromotionList[I].full_money2,Ashop.ShopPromotionList[I].dec_money2,
//                                                        Ashop.ShopPromotionList[I].full_money3,Ashop.ShopPromotionList[I].dec_money3);
//          end
//          else if (Ashop.ShopPromotionList[I].promotion_type='special_price_goods')
//                       or (Ashop.ShopPromotionList[I].promotion_type='discount')  then
//          begin
//            if Ashop.ShopPromotionList[I].promotion_type='special_price_goods' then
//            begin
//              Self.lblFull.Caption:='特价';
//            end
//            else
//            begin
//              Self.lblFull.Caption:='打折';
//            end;
//
//            Self.lblFullValue.Caption:='活动价仅'+FloatToStr(Ashop.ShopPromotionList[I].special_price);
//          end;
//        end
//        else if I=1 then
//        begin
//          if (Ashop.ShopPromotionList[I].promotion_type='full_dec_money')
//             or (Ashop.ShopPromotionList[I].promotion_type='coupon') then
//          begin
//            if AShop.ShopPromotionList[I].promotion_type='full_dec_money' then
//            begin
//              Self.lblSpical.Caption:='満减';
//            end
//            else
//            begin
//              Self.lblSpical.Caption:='红包';
//            end;
//            Self.lblSpicalValue.Caption:=GetActivityRules(Ashop.ShopPromotionList[I].full_money1,Ashop.ShopPromotionList[I].dec_money1,
//                                                        Ashop.ShopPromotionList[I].full_money2,Ashop.ShopPromotionList[I].dec_money2,
//                                                        Ashop.ShopPromotionList[I].full_money3,Ashop.ShopPromotionList[I].dec_money3);
//          end
//          else if (Ashop.ShopPromotionList[I].promotion_type='special_price_goods')
//                       or (Ashop.ShopPromotionList[I].promotion_type='discount')  then
//          begin
//            if Ashop.ShopPromotionList[I].promotion_type='special_price_goods' then
//            begin
//              Self.lblSpical.Caption:='特价';
//            end
//            else
//            begin
//              Self.lblSpical.Caption:='打折';
//            end;
//
//            Self.lblSpicalValue.Caption:='活动价仅'+FloatToStr(Ashop.ShopPromotionList[I].special_price);
//          end;
//        end;
//      end;
//    end;
//
//  end;
end;

procedure TFrameHome.lvHomePullDownRefresh(Sender: TObject);
begin
  //下拉刷新
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoGetHomeFrameInfoExecute,
                 DoGetHomeFrameInfoExecuteEnd,
                 'GetHomeFrameInfo');
end;

procedure TFrameHome.lvHomePullUpLoadMore(Sender: TObject);
begin
  //上拉加载更多
  FPageIndex:=FPageIndex+1;
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                 DoGetHomeFrameInfoExecute,
//                 DoGetHomeFrameInfoExecuteEnd,
//                 'GetHomeFrameInfo');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoGetNewsListExecute,
                 DoGetNewsListExecuteEnd,
                 'GetNewsList');
end;

procedure TFrameHome.lvHomeResize(Sender: TObject);
var
  I: Integer;
//var
//  AWidth:Double;
//  I: Integer;
begin
  for I := 0 to Self.lvHome.Prop.Items.Count-1 do
  begin
    if (Self.lvHome.Prop.Items[I].Json<>nil)
      and (Self.lvHome.Prop.Items[I].Json.Contains('size_rate'))
      and BiggerDouble(Self.lvHome.Prop.Items[I].Json.F['size_rate'],0) then
    begin


      if FListItemStyleFrame_ImageListViewer<>nil then
      begin
        Self.lvHome.Prop.Items.Items[I].Height:=
          (Self.lvHome.Width
                -FListItemStyleFrame_ImageListViewer.imgPlayer.Margins.Left
                -FListItemStyleFrame_ImageListViewer.imgPlayer.Margins.Right)/Self.lvHome.Prop.Items[I].Json.F['size_rate']
          +FListItemStyleFrame_ImageListViewer.imgPlayer.Margins.Top
          +FListItemStyleFrame_ImageListViewer.imgPlayer.Margins.Bottom;
      end
      else
      begin
        Self.lvHome.Prop.Items.Items[I].Height:=
          Self.lvHome.Width/Self.lvHome.Prop.Items[I].Json.F['size_rate'];

      end;

    end;
  end;

//  //广告图片轮播保持一个5:2的比例
//  if Self.lvHome.Prop.Items.FindItemByType(sitItem1)<>nil then
//  begin
//    Self.lvHome.Prop.Items.FindItemByType(sitItem1).Height:=
//      Self.lvHome.Width/5*2;
//  end;

//  AWidth:=0;
//
//  if Self.lbKey<>nil then
//  begin
//    for I := 0 to Self.lbKey.Prop.Items.Count-1 do
//    begin
//      AWidth:=AWidth+Self.lbKey.Prop.Items[I].Width;
//    end;
//
//    Self.lbKey.Prop.ItemSpace:=(Self.Width-AWidth)/11;
//  end;
//
//
//  Self.btnAll.Width:=Width/4;
//  Self.btnFilter1.Width:=Width/4;
//  Self.btnFilter2.Width:=Width/4;
//  Self.btnFilter3.Width:=Width/4;
////  Self.btnFilter4.Width:=Width/5;
//
//  Self.btnOrderCar.Left:=Self.Width-60;
//
//  Self.btnOrderCar.Position.Y:=Self.Height-120;
end;


procedure TFrameHome.lvHomeVertScrollBarChange(Sender: TObject);
//var
//  AFirstItem:TSkinItem;
//  I: Integer;
begin
//  if (FNewFilterClassifyHorzListBoxItem<>nil) and (FListItemStyleFrame_HorzListBox<>nil) then
//  begin
//      if FNewFilterClassifyHorzListBoxItem.ItemDrawRect.Top<0 then
//      begin
//        //如果新闻分类Item滚到了很上面显示不出来了
//        //就把这个设计面板直接显示在ListBox的控件上面了
//        FListItemStyleFrame_HorzListBox.Parent:=Self.lvHome;
//        FListItemStyleFrame_HorzListBox.Align:=TAlignLayout.Top;
//        FListItemStyleFrame_HorzListBox.Visible:=True;
//        FListItemStyleFrame_HorzListBox.Height:=FNewFilterClassifyHorzListBoxItem.Height;
//        FListItemStyleFrame_HorzListBox.ItemDesignerPanel.Visible:=True;
//        FListItemStyleFrame_HorzListBox.ItemDesignerPanel.Align:=TAlignLayout.Client;
//      end
//      else
//      begin
//        //反之,则隐藏
//        FListItemStyleFrame_HorzListBox.Parent:=nil;
//        FListItemStyleFrame_HorzListBox.Align:=TAlignLayout.None;
//        FListItemStyleFrame_HorzListBox.Visible:=False;
//      end;
//
//  end;
//
//
//
//  //第一个Item的高度
//  if lvHome.Prop.Items.Count>0 then
//  begin
//      //home_ad
//      AFirstItem:=nil;
////      AFirstItem:=lvHome.Prop.Items.FindItemByName('home_ad');
//      AFirstItem:=lvHome.Prop.Items[0];
////      for I := 0 to lvHome.Prop.Items.Count-1 do
////      begin
////        if lvHome.Prop.Items[I].Width=-2 then
//////        if lvHome.Prop.Items[I].Name='captcha' then
////        begin
////          AFirstItem:=lvHome.Prop.Items[I];
////          Break;
////        end;
////      end;
//
//      if AFirstItem<>nil then
//      begin
//          if AFirstItem.ItemDrawRect.Top<0 then
//          begin
////            Self.lvHome.Material.BackColor.DrawRectSetting.Top:=0;
//            Self.imgBackGround.Material.DrawPictureParam.DrawRectSetting.Height:=70+Self.pnlToolBar.Height;
//          end
//          else if (AFirstItem.ItemDrawRect.Top=0) and (AFirstItem.ItemDrawRect.Bottom=0) then
//          begin
//    //        Self.lvHome.Material.BackColor.DrawRectSetting.Top:=FLast_FirstItemHeight;
//          end
//          else
//          begin
//            Self.imgBackGround.Material.DrawPictureParam.DrawRectSetting.Height:=70+Self.pnlToolBar.Height+AFirstItem.ItemDrawRect.Top;
//          end;
//      end;
//
//  end
//  else
//  begin
//      //Self.lvHome.Material.BackColor.DrawRectSetting.Top:=FLast_FirstItemHeight;
//  end;

end;

procedure TFrameHome.ShowUserHeadImage;
begin

  imgUserHead.Prop.Picture.ImageIndex:=-1;
  imgUserHead.Prop.Picture.Url:=GlobalManager.User.GetHeadPicUrl;
  imgUserHead.Prop.Picture.IsClipRound:=True;

end;

procedure TFrameHome.tmrInvalidateTimer(Sender: TObject);
begin

  if Self.FHomeAdItem<>nil then
  begin
    FHomeAdItem.IsBufferNeedChange:=True;
  end;

  Self.lvHome.Invalidate;


end;

//procedure TFrameHome.OnFromFFilterFrame(AFarme: TFrame);
//begin
//  FSort:=GlobalFFilterShopConditionFrame.FFilterName;
//
//  Self.btnAll.Caption:=GlobalFFilterShopConditionFrame.FFilterKey;
//
//  FIsOnlyUpdateShopList:=True;
//
//  Self.SyncWaitProcessCount(Self.FSort,Self.FFilter_promotion_type,Self.FFilterKey);
//
//end;

//procedure TFrameHome.OnFromShopInfoFrame(AFrame: TFrame);
//begin
////  GlobalMainFrame.UpDateMyCar;
//end;
//
//procedure TFrameHome.OnFromShopListFrame(AFrame: TFrame);
//begin
////  Self.FFilter_promotion_type:='';
//
////  Self.SyncWaitProcessCount(Self.FSort,Self.FFilter_promotion_type,Self.FFilterKey);
//
//end;
//
//procedure TFrameHome.OnModalResultFromLeaveOrder(AFrame: TObject);
//begin
//  if TFrameMessageBox(AFrame).ModalResult='手动搜索地址' then
//  begin
//    //选择地址
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//    ShowFrame(TFrame(GlobalHomeAddrFrame),TFrameHomeAddr,OnReturnFromHomeAddrFrame);
//    GlobalHomeAddrFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalHomeAddrFrame.Clear;
//    //加载收货地址
//    GlobalHomeAddrFrame.LoadRecvAddrList;
//    //
//    GlobalHomeAddrFrame.Load;
//  end;
//  if TFrameMessageBox(AFrame).ModalResult='取消' then
//  begin
//    //留在酒店信息页面
//  end;
//end;

//procedure TFrameHome.OnReturnFromHomeAddrFrame(AFrame: TFrame);
//begin
////  if GlobalManager.IsGPSLocated then
////  begin
//
//    //刷新
////    Self.FIsOnlyUpdateShopList:=False;
//
//    Self.DoLocationAddrChange;
//
////    Self.SyncWaitProcessCount(Self.FSort,Self.FFilter_promotion_type,Self.FFilterKey);
////  end;
//end;
//
//procedure TFrameHome.OnReturnFromShopListFrame(AFrame: TFrame);
//begin
////  Self.FFilterKey:='';
//
////  Self.SyncWaitProcessCount(Self.FSort,Self.FFilter_promotion_type,Self.FFilterKey);
//end;

//procedure TFrameHome.OnReturnFromUserCarFrame(AFrame: TFrame);
//begin
//  GlobalMainFrame.UpDateMyCar;
//end;

//procedure TFrameHome.SetingButtonWidth(ACaption: String);
//var
//  AWidth:Double;
//begin
//  AWidth:=0;
//  try
//
//      AWidth:=uBufferBitmap.GetStringWidth(
//            ACaption,
//              Self.btnAddr.SelfOwnMaterialToDefault.DrawCaptionParam.FontSize)
//              +Length(ACaption);//*3;//加上误差
//
//
//
//      if (AWidth
//          +btnAddr.SelfOwnMaterialToDefault.DrawCaptionParam.DrawRectSetting.Left
//          +btnAddr.SelfOwnMaterialToDefault.DrawCaptionParam.DrawRectSetting.Right)
//          >(Self.Width-80) then
//      begin
//          //最大宽度
//          Self.btnAddr.Width:=(Self.Width-80);
//      end
//      else
//      begin
//          Self.btnAddr.Width:=AWidth
//              +btnAddr.SelfOwnMaterialToDefault.DrawCaptionParam.DrawRectSetting.Left
//              +btnAddr.SelfOwnMaterialToDefault.DrawCaptionParam.DrawRectSetting.Right;
//      end;
//
//  except
//    on E:Exception do
//    begin
//      OutputDebugString('OrangeUI TFrameHome.SetingButtonWidth Error:'+E.Message);
//    end;
//  end;
//end;

//procedure TFrameHome.SyncAddrButton;
//begin
//  Self.btnAddr.Caption:='正在识别地址...';
//
//  if GlobalManager.IsGPSLocated=True then
//  begin
//      Self.btnAddr.Caption:=GlobalManager.RegionName;
//  end
//  else
//  begin
//      if (GlobalGPSLocation<>nil) then
//      begin
//          if GlobalGPSLocation.IsLocationTimeout then
//          begin
//            Self.btnAddr.Caption:='定位超时了...';
//          end;
//          if GlobalGPSLocation.IsStartError then
//          begin
//            Self.btnAddr.Caption:='定位启动失败了...';
//          end;
//
//
//          if GlobalGPSLocation.IsGeocodeAddrTimeout then
//          begin
//            Self.btnAddr.Caption:='地址解析超时了...';
//          end;
//          if GlobalGPSLocation.IsGeocodeAddrError then
//          begin
//            Self.btnAddr.Caption:='地址解析出错了...';
//          end;
//      end;
//  end;
//
//  Self.SetingButtonWidth(Self.btnAddr.Caption);
//end;

//procedure TFrameHome.SyncWaitProcessCount(ASort:String;
//                                           AFilter_promotion_type:String;
//                                           AFilterKey:String);
//begin
//  FSort:=ASort;
//  FFilterKey:=AFilterKey;
//  Self.FFilter_promotion_type:=AFilter_promotion_type;
//
//  OutputDebugString('OrangeUI TFrameHome.SyncWaitProcessCount 1');
//
//
//  if FIsOnlyUpdateShopList=True then
//  begin
//      ShowWaitingFrame(frmMain,'加载中...');
//
//      OutputDebugString('OrangeUI TFrameHome.SyncWaitProcessCount 2');
//      uTimerTask.GetGlobalTimerThread.RunTempTask(
//                   DoGetHomeFrameInfoExecute,
//                   DoGetHomeFrameInfoExecuteEnd,
//                   'GetHomeFrameInfo');
//  end
//  else
//  begin
//
//      OutputDebugString('OrangeUI TFrameHome.SyncWaitProcessCount 3');
//      if GlobalManager.IsGPSLocated=True then
//      begin
//
//          OutputDebugString('OrangeUI TFrameHome.SyncWaitProcessCount 4');
//
//          try
//              //会报错
//              Self.lvHome.Prop.StartPullDownRefresh;
//          except
//            on E:Exception do
//            begin
//              OutputDebugString('OrangeUI TFrameHome.SyncWaitProcessCount 4 Error:'+E.Message);
//            end;
//          end;
//
//
//          OutputDebugString('OrangeUI TFrameHome.SyncWaitProcessCount 5');
//      end
//      else
//      begin
//          OutputDebugString('OrangeUI TFrameHome.SyncWaitProcessCount 6');
//          Self.Clear;
//      end;
//
//  end;
//
//  OutputDebugString('OrangeUI TFrameHome.SyncWaitProcessCount 7');
//
//end;


end.
