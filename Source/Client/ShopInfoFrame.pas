unit ShopInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Filter,
  System.Math,

  uSkinMaterial,
  HintFrame,
  uOpenCommon,
  uOpenClientCommon,
  uComponentType,
  uFrameContext,
  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,

  ShopUserInfoFrame,
  ShopGoodsListFrame,
  ShopInfoEvaluateListFrame,

  uUIFunction,
  DateUtils,
  uFuncCommon,

  WaitingFrame,
  uTimerTask,

  uManager,

  XSuperObject,
  uRestInterfaceCall,
  uBaseList,

  MessageBoxFrame,
  AddCarGoodsFrame,
  TakeOrderFrame,

  uDrawCanvas,

  uSkinItems,
  TakePictureMenuFrame,

  uSkinBufferBitmap,



  uSkinFireMonkeyControl, uSkinImageType, uSkinFireMonkeyImage, uSkinButtonType,
  uSkinFireMonkeyButton, uSkinPanelType, uSkinFireMonkeyPanel,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinFireMonkeyScrollBox,
  uSkinScrollBoxContentType, uSkinFireMonkeyScrollBoxContent,
  uSkinSwitchPageListPanelType, uSkinPageControlType, uSkinFireMonkeyPageControl,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinCustomListType,
  uSkinVirtualListType, uSkinListViewType, uSkinFireMonkeyListView,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinListBoxType, uSkinFireMonkeyListBox, uUrlPicture, uDownloadPictureManager,
  uDrawPicture, uSkinImageList, uSkinNotifyNumberIconType,
  uSkinFireMonkeyNotifyNumberIcon, uSkinImageListViewerType,
  uSkinFireMonkeyImageListViewer;

type
  TFrameShopInfo = class(TFrame)
    imgBackground: TSkinFMXImage;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnShowImg: TSkinFMXButton;
    sbContent: TSkinFMXScrollBox;
    sbcContent: TSkinFMXScrollBoxContent;
    pcShopInfo: TSkinFMXPageControl;
    imgShoplogo: TSkinFMXImage;
    pnlShopName: TSkinFMXPanel;
    tsGoods: TSkinTabSheet;
    tsEstimate: TSkinTabSheet;
    imgBrand: TSkinFMXImage;
    lblShopName: TSkinFMXLabel;
    pnlDetail: TSkinFMXPanel;
    imgStar: TSkinFMXImage;
    imgStar1: TSkinFMXImage;
    imgStar2: TSkinFMXImage;
    imgStar3: TSkinFMXImage;
    imgStar4: TSkinFMXImage;
    lblScore: TSkinFMXLabel;
    tsUser: TSkinTabSheet;
    lblMonth: TSkinFMXLabel;
    lblMonthValue: TSkinFMXLabel;
    lblDeliver: TSkinFMXLabel;
    lblDeliverValue: TSkinFMXLabel;
    lblDistence: TSkinFMXLabel;
    lblDistenceValue: TSkinFMXLabel;
    pnlAdv: TSkinFMXPanel;
    lblAdv: TSkinFMXLabel;
    lblAdvValue: TSkinFMXLabel;
    btnUpDown: TSkinFMXButton;
    pnlDetail2: TSkinFMXPanel;
    imgStr1: TSkinFMXImage;
    lblScore1: TSkinFMXLabel;
    imgStr2: TSkinFMXImage;
    imgStr3: TSkinFMXImage;
    imgStr4: TSkinFMXImage;
    imgStr5: TSkinFMXImage;
    lblMonthSale: TSkinFMXLabel;
    lblDis: TSkinFMXLabel;
    pnlCar: TSkinFMXPanel;
    btnPay: TSkinFMXButton;
    lblSelectedPay: TSkinFMXLabel;
    lblActv: TSkinFMXLabel;
    DownloadPictureManager1: TDownloadPictureManager;
    imglistcar: TSkinImageList;
    lblPay: TSkinFMXLabel;
    btnSearch: TSkinFMXButton;
    imgPic: TSkinFMXImage;
    nniUserCartNumber: TSkinFMXNotifyNumberIcon;
    pnlCoupon: TSkinFMXPanel;
    lvCoupon: TSkinFMXListView;
    idpCoupon: TSkinFMXItemDesignerPanel;
    lblCouponMoney1: TSkinFMXLabel;
    lblAllMoney: TSkinFMXLabel;
    btnRecv: TSkinFMXButton;
    lblCouponDetail1: TSkinFMXLabel;
    lbActvList: TSkinFMXListBox;
    idpOtherActv: TSkinFMXItemDesignerPanel;
    lblDiscount: TSkinFMXLabel;
    lblDiscountValue: TSkinFMXLabel;
    btnActvCount: TSkinFMXButton;
    imgSign: TSkinFMXImage;
    tmrTestGPSLocation: TTimer;
    pnlRest: TSkinFMXPanel;
    btnRest: TSkinFMXButton;
    btnSave: TSkinFMXButton;
    imgPlayer: TSkinFMXImageListViewer;
    bgIndicator: TSkinFMXButtonGroup;
    imglistPlayer: TSkinImageList;
    SkinFMXPanel1: TSkinFMXPanel;
    FrameContext1: TFrameContext;
    procedure pcShopInfoChange(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure lbActvListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure btnUpDownClick(Sender: TObject);
    procedure btnActvCountClick(Sender: TObject);
    procedure DownloadPictureManager1DownloadSucc(Sender: TObject;
      AUrlPicture: TUrlPicture);
    procedure sbContentVertScrollBarChange(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure imgPicClick(Sender: TObject);
    procedure btnRecvClick(Sender: TObject);
    procedure lvCouponPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure btnPayClick(Sender: TObject);
    procedure sbcContentResize(Sender: TObject);
    procedure tmrTestGPSLocationTimer(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure imgPlayerResize(Sender: TObject);
    procedure FrameContext1Load(Sender: TObject);
  private
    FAddCarGoodsFrame:TFrameAddCarGoods;
    FTakeOrderFrame:TFrameTakeOrder;

    //获取店铺详情
    procedure DoGetShopInfoExecute(ATimerTask:TObject);
    procedure DoGetShopInfoExecuteEnd(ATimerTask:TObject);
    //从购物车列表返回
    procedure OnReturnFromCarListFrame(AFrame:TFrame);
  private
    FActvList:TActivityList;
    //星星数量
    procedure GetShowStar(ANumber:Double);
  private
    //红包FID
    FFilterCouponFID:Integer;
    //用领取店铺红包
    procedure DoGetShopCouponExecute(ATimerTask:TObject);
    procedure DoGetShopCouponExecuteEnd(ATimerTask:TObject);
  private
    //收藏商家
    procedure DoCollectShopExecute(ATimerTask:TObject);
    procedure DoCollectShopExecuteEnd(ATimerTask:TObject);
  private
    //取消收藏
    procedure DoCancleCollectShopExecute(ATimerTask:TObject);
    procedure DoCancleCollectShopExecuteEnd(ATimerTask:TObject);

  private
    //店铺是否营业
    function IsDoBusiness(AShop:TShop):Boolean;
    //店铺营业时间
    function BusinessTime(AShop:TShop):String;
  private
    FShopUserInfoFrame:TFrameShopUserInfo;
    FEvaluateListFrame:TFrameShopInfoEvaluateList;
    //是否添加
    FIsAdd:Boolean;
    //是否去结算
    FIsPay:Boolean;

    //设置显示方式
    procedure SetingPosition(AIsUpDown:Boolean;AActvList:TActivityList);
  private
    //广告图片
    FHomeAdList:THomeAdList;

//    FCarShopList:TCarShopList;
    //获取购物车商品列表
    procedure DoGetUserCarGoodsListExecute(ATimerTask:TObject);
    procedure DoGetUserCarGoodsListExecuteEnd(ATimerTask:TObject);

     //获取平台商家广告图片
    procedure DoGetPlatformShopAdExecute(ATimerTask:TObject);
    procedure DoGetPlatformShopAdExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    //是否营业
    FIsDoBusiness:Boolean;
    FShop:TShop;
    FCarGoodList:TCarGoodList;
    FShopGoodsListFrame:TFrameShopGoodsList;
    FFilterShopFID:Integer;
    //是否显示返回按钮
    FIsShowBackBtn:Boolean;
    //同一个界面共用  传进来的
    FGlobalShopInfoFrame:TFrame;
    //加载页面
    procedure Load(AShopFID:Integer;
                   ACarGoodList:TCarGoodList;
                   AShopInfoFrame:TFrame);

    procedure IsShowBackBtn(IsShowBackBtn:Boolean=True);

    procedure AlignControls;

    //清除
    procedure Clear;

    procedure UpDataMyCar;

    //加载
    procedure UpDateShopInfo;


    procedure Init;

    procedure HideAddCarGoodsFrame;
  public
    FUserFID:String;

    //是否在线支付商品费用   暂时是平台商家使用
    FIsPayGoodsMoneyOnline:Integer;
    //是否平台商家
    FIsPlatFormShop:Integer;
    //商家配送方式
    FShopDeliverType:Integer;
    //满多少减免配送费/邮费
    FMinPostingPrice:Double;
    //是否包邮
    FIsNeedPostingFee:Integer;

    FAddUserCarFrameIsShow:Boolean;
    FFilterMinOrderAccount:Double;
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;




var
  //平台商家FID
  FPlatformShopFID:Integer;
  GlobalShopInfoFrame:TFrameShopInfo;
  GlobalPlatformShopInfoFrame:TFrameShopInfo;


implementation

{$R *.fmx}
uses
   MainForm,
   MainFrame,
   SearchGoodsFrame,
   LoginFrame;

{ TFrameShopInfo }

procedure TFrameShopInfo.AlignControls;
begin
  Self.pcShopInfo.Height:=Self.Height
                          -Self.pnlToolBar.Height
                          -Self.pnlCar.Height;

  Self.sbcContent.Height:=Self.pcShopInfo.Position.Y+Self.pcShopInfo.Height;
end;

procedure TFrameShopInfo.btnActvCountClick(Sender: TObject);
begin
  Self.SetingPosition(False,Self.FActvList);
end;

procedure TFrameShopInfo.btnPayClick(Sender: TObject);
var
  ACarShop:TCarShop;
  I: Integer;
begin

  Self.FIsPay:=True;

  //去支付
  ACarShop:=nil;
  if GlobalManager.UserCarShopList<>nil then
  begin
    for I := 0 to GlobalManager.UserCarShopList.Count-1 do
    begin
      if GlobalManager.UserCarShopList[I].fid=Self.FShop.fid then
      begin
        ACarShop:=GlobalManager.UserCarShopList[I];
        Break;
      end;
    end;
  end;

  if ACarShop<>nil then
  begin
    if FIsShowBackBtn then
    begin
      HideFrame;//(Self,hfcttBeforeShowFrame);
    end
    else
    begin
      HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
    end;
    //显示下单页面
    ShowFrame(TFrame(GlobalTakeOrderFrame),TFrameTakeOrder,frmMain,nil,nil,nil,Application);
//    GlobalTakeOrderFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalTakeOrderFrame.AddOrder(ACarShop,
                                  Self.FIsNeedPostingFee,
                                  Self.FShopDeliverType,
                                  Self.FIsPayGoodsMoneyOnline,
                                  Self.FIsPlatFormShop,
                                  Self.FMinPostingPrice);
  end;

end;

procedure TFrameShopInfo.btnRecvClick(Sender: TObject);
var
  AActivity:TActivity;
begin
  AActivity:=TActivity(Self.lvCoupon.Prop.InteractiveItem.Data);

  Self.FFilterCouponFID:=AActivity.fid;
  if GlobalManager.IsLogin=True then
  Begin
    //用户领取店铺红包
    ShowWaitingFrame(Self,'领取中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
               DoGetShopCouponExecute,
               DoGetShopCouponExecuteEnd,
               'GetShopCoupon');
  End
  else
  begin
    //去登录
    //隐藏
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
    //显示登录页面
    ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
//    GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
    //清除输入框
    GlobalLoginFrame.Clear;
  end;
end;

procedure TFrameShopInfo.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then Exit;

  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameShopInfo.btnSaveClick(Sender: TObject);
begin
  if GlobalManager.IsLogin=True then
  begin
    //收藏店铺
    Self.btnSave.Prop.IsPushed:=Not Self.btnSave.Prop.IsPushed;

    if Self.btnSave.Prop.IsPushed=True then
    begin
      //收藏
      uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoCollectShopExecute,
                 DoCollectShopExecuteEnd,
                 'CollectShop');
    end
    else
    begin
      //取消收藏
      uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoCancleCollectShopExecute,
                 DoCancleCollectShopExecuteEnd,
                 'CancleCollectShop');
    end;
  end
  else
  begin
    //跳转到登录界面
    //隐藏
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
    //显示登录页面
    ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
//    GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
    //清除输入框
    GlobalLoginFrame.Clear;
  end;
end;

procedure TFrameShopInfo.btnSearchClick(Sender: TObject);
begin
  //搜索商家商品列表
  //隐藏
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

  //显示搜索历史搜索
  ShowFrame(TFrame(GlobalSearchGoodsFrame),TFrameSearchGoods,frmMain,nil,nil,nil,Application);
//  GlobalSearchGoodsFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalSearchGoodsFrame.Load(Self.btnSearch.Prop.HelpText,
                                'Goods',
                                Self.FShop,
                                SElf.FShop.fid,
                                Self.FIsDoBusiness,
                                GlobalManager.GoodsSearchHistoryList
                                );

end;

procedure TFrameShopInfo.btnUpDownClick(Sender: TObject);
begin
  Self.SetingPosition(True,Self.FActvList);
end;

function TFrameShopInfo.BusinessTime(AShop: TShop): String;
var
  I: Integer;
begin
  Result:='待营业';
  case DayofWeek(Now) of
    1:
    if AShop.sun_is_sale=1 then
    begin
      Result:='今天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_end_time))+'继续营业';
    
    end
    else if AShop.mon_is_sale=1 then
    begin
      Result:='明天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_end_time))+'继续营业';

    end
    else if Ashop.tues_is_sale=1 then
    begin
      Result:='后天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_end_time))+'继续营业';

    end
    else if AShop.wed_is_sale=1 then
    begin
      Result:='周三'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_end_time))+'继续营业';

    end
    else if AShop.thur_is_sale=1 then
    begin
      Result:='周四'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_end_time))+'继续营业';

    end
    else if AShop.fri_is_sale=1 then
    begin
      Result:='周五'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_end_time))+'继续营业';

    end
    else if AShop.sat_is_sale=1 then
    begin
      Result:='周六'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_end_time))+'继续营业';

    end;
    2:
    if AShop.mon_is_sale=1 then
    begin
      Result:='今天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_end_time))+'继续营业';

    end    
    else if Ashop.tues_is_sale=1 then
    begin
      Result:='明天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_end_time))+'继续营业';

    end
    else if AShop.wed_is_sale=1 then
    begin
      Result:='后天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_end_time))+'继续营业';

    end
    else if AShop.thur_is_sale=1 then
    begin
      Result:='周四'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_end_time))+'继续营业';

    end
    else if AShop.fri_is_sale=1 then
    begin
      Result:='周五'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_end_time))+'继续营业';

    end
    else if AShop.sat_is_sale=1 then
    begin
      Result:='周六'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_end_time))+'继续营业';

    end
    else if AShop.sun_is_sale=1 then
    begin
      Result:='周日'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_end_time))+'继续营业';

    end;
    3:
    if Ashop.tues_is_sale=1 then
    begin
      Result:='今天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_end_time))+'继续营业';

    end    
    else if AShop.wed_is_sale=1 then
    begin
      Result:='明天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_end_time))+'继续营业';

    end
    else if AShop.thur_is_sale=1 then
    begin
      Result:='后天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_end_time))+'继续营业';

    end
    else if AShop.fri_is_sale=1 then
    begin
      Result:='周五'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_end_time))+'继续营业';

    end
    else if AShop.sat_is_sale=1 then
    begin
      Result:='周六'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_end_time))+'继续营业';

    end
    else if AShop.sun_is_sale=1 then
    begin
      Result:='周日'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_end_time))+'继续营业';

    end    
    else if AShop.mon_is_sale=1 then
    begin
      Result:='下周一'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_end_time))+'继续营业';

    end;
    4:
    if AShop.wed_is_sale=1 then
    begin
      Result:='今天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_end_time))+'继续营业';

    end
    else if AShop.thur_is_sale=1 then
    begin
      Result:='明天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_end_time))+'继续营业';

    end
    else if AShop.fri_is_sale=1 then
    begin
      Result:='后天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_end_time))+'继续营业';

    end
    else if AShop.sat_is_sale=1 then
    begin
      Result:='周六'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_end_time))+'继续营业';

    end
    else if AShop.sun_is_sale=1 then
    begin
      Result:='周日'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_end_time))+'继续营业';

    end    
    else if AShop.mon_is_sale=1 then
    begin
      Result:='下周一'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_end_time))+'继续营业';

    end
    else if Ashop.tues_is_sale=1 then
    begin
      Result:='下周二'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_end_time))+'继续营业';

    end;       
    5:
    if AShop.thur_is_sale=1 then
    begin
      Result:='今天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_end_time))+'继续营业';

    end
    else if AShop.fri_is_sale=1 then
    begin
      Result:='明天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_end_time))+'继续营业';

    end
    else if AShop.sat_is_sale=1 then
    begin
      Result:='后天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_end_time))+'继续营业';

    end
    else if AShop.sun_is_sale=1 then
    begin
      Result:='周日'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_end_time))+'继续营业';

    end    
    else if AShop.mon_is_sale=1 then
    begin
      Result:='下周一'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_end_time))+'继续营业';

    end
    else if Ashop.tues_is_sale=1 then
    begin
      Result:='下周二'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_end_time))+'继续营业';

    end
    else if AShop.wed_is_sale=1 then
    begin
      Result:='下周三'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_end_time))+'继续营业';

    end;        
    6:
    if AShop.fri_is_sale=1 then
    begin
      Result:='今天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_end_time))+'继续营业';

    end
    else if AShop.sat_is_sale=1 then
    begin
      Result:='明天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_end_time))+'继续营业';

    end
    else if AShop.sun_is_sale=1 then
    begin
      Result:='周日'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_end_time))+'继续营业';

    end    
    else if AShop.mon_is_sale=1 then
    begin
      Result:='下周一'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_end_time))+'继续营业';

    end
    else if Ashop.tues_is_sale=1 then
    begin
      Result:='下周二'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_end_time))+'继续营业';

    end
    else if AShop.wed_is_sale=1 then
    begin
      Result:='下周三'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_end_time))+'继续营业';

    end
    else if AShop.thur_is_sale=1 then
    begin
      Result:='下周四'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_end_time))+'继续营业';

    end;           
    7:  
    if AShop.sat_is_sale=1 then
    begin
      Result:='今天'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_end_time))+'继续营业';

    end
    else if AShop.sun_is_sale=1 then
    begin
      Result:='周日'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_end_time))+'继续营业';

    end    
    else if AShop.mon_is_sale=1 then
    begin
      Result:='下周一'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_end_time))+'继续营业';

    end
    else if Ashop.tues_is_sale=1 then
    begin
      Result:='下周二'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_end_time))+'继续营业';

    end
    else if AShop.wed_is_sale=1 then
    begin
      Result:='下周三'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_end_time))+'继续营业';

    end
    else if AShop.thur_is_sale=1 then
    begin
      Result:='下周四'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_end_time))+'继续营业';

    end
    else if AShop.fri_is_sale=1 then
    begin
      Result:='下周五'+FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_start_time))
               +'-'+
               FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_end_time))+'继续营业';

    end;           
  end;

end;

procedure TFrameShopInfo.Clear;
begin
  //默认添加
  FIsAdd:=True;

  Self.btnSearch.Opacity:=0;

  Self.pnlRest.Visible:=False;

  Self.nniUserCartNumber.Prop.Number:=0;

  FFilterMinOrderAccount:=0;

  Self.pnlCar.Visible:=False;

  Self.FCarGoodList.Clear(True);

  Self.btnSave.Prop.IsPushed:=False;

  Self.lblAdvValue.Caption:='';

  Self.imgBrand.Prop.Picture.ImageIndex:=-1;

  Self.lblDis.Caption:='';

  Self.btnUpDown.Visible:=False;
  Self.pnlDetail.Visible:=False;
  Self.btnPay.Visible:=False;

  Self.imgPic.Prop.Picture.ImageIndex:=0;
  Self.lblSelectedPay.Caption:='未选购商品';
  Self.lblPay.Visible:=True;
  Self.lblPay.Caption:='￥0起送';



  Self.lblDeliver.Caption:='';
  Self.lblDeliverValue.Caption:='';


  self.lblShopName.Caption:='';

  Self.imgStr1.Prop.Picture.ImageIndex:=1;
  Self.imgStr2.Prop.Picture.ImageIndex:=1;
  Self.imgStr3.Prop.Picture.ImageIndex:=1;
  Self.imgStr4.Prop.Picture.ImageIndex:=1;
  Self.imgStr5.Prop.Picture.ImageIndex:=1;

  Self.lblScore1.Caption:='';

  Self.lblMonthSale.Caption:='';

  Self.lvCoupon.Prop.Items.Clear(True);

  Self.lbActvList.Prop.Items.Clear(True);

  if Self.FShopGoodsListFrame<>nil then
  begin
    Self.FShopGoodsListFrame.Clear;
  end;


//  Self.pcShopInfo.Prop.ActivePage:=Self.tsGoods;
//
//  Self.pcShopInfoChange(Self.pcShopInfo);

end;

constructor TFrameShopInfo.Create(AOwner: TComponent);
begin
  inherited;

  tmrTestGPSLocation.Enabled:=True;

  FIsPay:=False;

  Self.btnUpDown.Visible:=False;
  Self.pnlDetail.Visible:=False;
  Self.btnPay.Visible:=False;

  FAddUserCarFrameIsShow:=False;


  FCarGoodList:=TCarGoodList.Create;

  FShop:=TShop.Create;

  FIsPayGoodsMoneyOnline:=0;
  FIsPlatFormShop:=0;
  FShopDeliverType:=2; //代表自己配送

  FMinPostingPrice:=0;
  FIsNeedPostingFee:=0;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  FHomeAdList:=THomeAdList.Create();


  imglistPlayer.PictureList.Clear();

  //先不显示评价
//  tsEstimate.Prop.PageControl:=nil;

  Self.btnPay.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=SkinThemeColor;
  Self.pcShopInfo.SelfOwnMaterialToDefault.DrawTabBackColorParam.DrawEffectSetting.PushedEffect.FillColor.Color:=SkinThemeColor;
end;

destructor TFrameShopInfo.Destroy;
begin

  FreeAndNil(FCarGoodList);

  FreeAndNil(FShop);

  FreeAndNil(FHomeAdList);

  inherited;
end;

procedure TFrameShopInfo.DoCancleCollectShopExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('cancel_shop_collection',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'shop_fid',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      Self.FShop.fid,
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

procedure TFrameShopInfo.DoCancleCollectShopExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try

    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //收藏成功
         ShowHintFrame(Self,'已取消');

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

procedure TFrameShopInfo.DoCollectShopExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('add_shop_collection',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'shop_fid',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      Self.FShop.fid,
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

procedure TFrameShopInfo.DoCollectShopExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try

    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //收藏成功
        ShowHintFrame(Self,'已收藏');

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

procedure TFrameShopInfo.DoGetPlatformShopAdExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_shop_home_page',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'shop_fid',
                                                      'is_need_shop_goods_list',
                                                      'key',
                                                      'pageindex',
                                                      'pagesize'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      FFilterShopFID,
                                                      False,
                                                      GlobalManager.User.key,
                                                      1,50],
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

procedure TFrameShopInfo.DoGetPlatformShopAdExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ADrawPicture:TDrawPicture;
  I:Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        Self.imglistPlayer.PictureList.Clear(True);
        Self.FHomeAdList.Clear(True);
        FHomeAdList.ParseFromJsonArray(THomeAd,ASuperObject.O['Data'].A['HomeAdList']);

        //广告图片轮播
        for I := 0 to FHomeAdList.Count-1 do
        begin
          ADrawPicture:=Self.imglistPlayer.PictureList.Add;
          ADrawPicture.Url:=FHomeAdList[I].GetPicUrl;
          //立即下载
          ADrawPicture.WebUrlPicture;
          ADrawPicture.Data:=FHomeAdList[I];
        end;

        //显示第一页
        Self.imgPlayer.Prop.Picture.ImageIndex:=-1;
        if Self.imglistPlayer.PictureList.Count>0 then
        begin
          Self.imgPlayer.Prop.Picture.ImageIndex:=0;
        end;

        //排列按钮分组的位置
        Self.imgPlayerResize(imgPlayer);
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
  end;

end;

procedure TFrameShopInfo.DoGetShopCouponExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_shop_coupon',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'shop_fid',
                                                      'shop_promotion_fid',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      Self.FShop.fid,
                                                      FFilterCouponFID,
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

procedure TFrameShopInfo.DoGetShopCouponExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try

    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //领取成功,刷新页面
        Self.Init;

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


procedure TFrameShopInfo.DoGetShopInfoExecute(ATimerTask: TObject);
begin
  FMX.Types.Log.d('OrangeUI ShopInfoFrame DoGetShopInfoExecute');

  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_shop_all_info',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'shop_fid',
                                                      'APageindex',
                                                      'APagesize',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      Self.FFilterShopFID,
                                                      1,
                                                      20,
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
      FMX.Types.Log.d('OrangeUI ShopInfoFrame DoGetShopInfoExecute Exception');
      // 异常
      TTimerTask(ATimerTask).TaskDesc := E.Message;
    end;
  end;
end;

procedure TFrameShopInfo.DoGetShopInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  FMX.Types.Log.d('OrangeUI ShopInfoFrame DoGetShopInfoExecuteEnd');
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        FMX.Types.Log.d('OrangeUI ShopInfoFrame DoGetShopInfoExecuteEnd JSON'+ASuperObject.AsJSON);
        Self.FShop.Clear;
        //获取成功
        Self.FShop.ParseFromJson(ASuperObject.O['Data'].A['ShopAllInfo'].O[0]);

        FIsPayGoodsMoneyOnline:=Self.FShop.is_pay_goods_money_online;
        FIsPlatFormShop:=Self.FShop.is_platform_shop;

        FShopDeliverType:=Self.FShop.app_deliver_type;

        FMinPostingPrice:=Self.FShop.min_posting_price;

        FIsNeedPostingFee:=Self.FShop.is_need_posting_price;

        Self.FActvList:=Self.FShop.ShopPromotionList;

        Self.imgShoplogo.Prop.Picture.Url:=Self.FShop.Getlogopicpath;

        Self.imgBrand.Prop.Picture.ImageIndex:=2;

        Self.lblShopName.Caption:=Self.FShop.name;

        if FShop.is_collected=1 then
        begin
          Self.btnSave.Prop.IsPushed:=True;
        end
        else
        begin
          Self.btnSave.Prop.IsPushed:=False;
        end;

        Self.FIsDoBusiness:=Self.IsDoBusiness(FShop);

        if Self.FIsDoBusiness=False then
        begin
          if FShop.status=1 then
          begin
            Self.btnRest.Caption:='商家休息中('+Self.BusinessTime(FShop)+')';
          end
          else
          begin
            Self.btnRest.Caption:='暂停营业';
          end;
        end
        else
        begin
//          if (FShop.is_can_takeorder_but_only_self_take=0)
//          AND (FShop.is_can_takeorder_but_only_eat_in_shop=0)
//          AND (FShop.is_can_takeorder_and_delivery=0) then
//          begin
//            Self.btnRest.Caption:='该商家不支持下单';
//          end;
        end;

        if FShop.promotion_info<>'' then
        begin

          Self.lblAdvValue.Caption:=Self.FShop.promotion_info;

          Self.pnlAdv.Height:=uSkinBufferBitmap.GetStringHeight(FShop.promotion_info,
                                                          RectF(0,0,Self.Width-30,MaxInt),
                                                          Self.lblAdvValue.SelfOwnMaterialToDefault.DrawCaptionParam);

        end
        else
        begin
          Self.lblAdvValue.Caption:='欢迎光临,用餐高峰期请提前下单,谢谢';
          Self.pnlAdv.Height:=22;
        end;

        Self.GetShowStar(Self.FShop.rating_score);

        FMX.Types.Log.d('OrangeUI ShopInfoFrame DoGetShopInfoExecuteEnd JSON 0');

        Self.lblScore.Caption:=FloatToStr(Self.FShop.rating_score);
        Self.lblScore1.Caption:=FloatToStr(Self.FShop.rating_score);



//        if (Self.FShop.is_can_takeorder_but_only_self_take=0)
//        AND (Self.FShop.is_can_takeorder_and_delivery=0)
//        AND (Self.FShop.is_can_takeorder_but_only_eat_in_shop=0) then
//        begin
//          Self.lblDis.Caption:='不能下单';
//
//          Self.lblDeliverValue.Caption:='不能下单';
//        end
//        else if (Self.FShop.is_can_takeorder_but_only_self_take=0)
//        AND (Self.FShop.is_can_takeorder_but_only_eat_in_shop=0)
//        AND (Self.FShop.is_can_takeorder_and_delivery=1) then
//        begin
//          Self.lblDis.Caption:='配送';
//
//          Self.lblDeliverValue.Caption:='配送';
//        end
//        else if (Self.FShop.is_can_takeorder_but_only_self_take=1)
//        AND (Self.FShop.is_can_takeorder_but_only_eat_in_shop=0)
//        AND (Self.FShop.is_can_takeorder_and_delivery=1) then
//        begin
//          Self.lblDis.Caption:='配送/自取';
//
//          Self.lblDeliverValue.Caption:='配送/自取';
//        end
//        else if (Self.FShop.is_can_takeorder_but_only_self_take=0)
//        AND (Self.FShop.is_can_takeorder_but_only_eat_in_shop=1)
//        AND (Self.FShop.is_can_takeorder_and_delivery=1) then
//        begin
//          Self.lblDis.Caption:='配送/堂食';
//
//          Self.lblDeliverValue.Caption:='配送/堂食';
//        end
//        else if (Self.FShop.is_can_takeorder_but_only_self_take=0)
//        AND (Self.FShop.is_can_takeorder_but_only_eat_in_shop=1)
//        AND (Self.FShop.is_can_takeorder_and_delivery=0) then
//        begin
//          Self.lblDis.Caption:='堂食';
//
//          Self.lblDeliverValue.Caption:='堂食';
//        end
//        else if (Self.FShop.is_can_takeorder_but_only_self_take=1)
//        AND (Self.FShop.is_can_takeorder_but_only_eat_in_shop=0)
//        AND (Self.FShop.is_can_takeorder_and_delivery=0) then
//        begin
//          Self.lblDis.Caption:='自取';
//
//          Self.lblDeliverValue.Caption:='自取';
//        end
//        else if (Self.FShop.is_can_takeorder_but_only_self_take=1)
//        AND (Self.FShop.is_can_takeorder_but_only_eat_in_shop=1)
//        AND (Self.FShop.is_can_takeorder_and_delivery=0) then
//        begin
//          Self.lblDis.Caption:='堂食/自取';
//
//          Self.lblDeliverValue.Caption:='堂食/自取';
//        end
//        else if (Self.FShop.is_can_takeorder_but_only_self_take=1)
//        AND (Self.FShop.is_can_takeorder_but_only_eat_in_shop=1)
//        AND (Self.FShop.is_can_takeorder_and_delivery=1) then
//        begin
//          Self.lblDis.Caption:='配送/堂食/自取';
//
//          Self.lblDeliverValue.Caption:='配送/堂食/自取';
//        end;






        FMX.Types.Log.d('OrangeUI ShopInfoFrame DoGetShopInfoExecuteEnd JSON  1');
        Self.lblDeliverValue.Width:=uSkinBufferBitmap.GetStringWidth(
                                        Self.lblDeliverValue.Caption,12);

        Self.lblDeliver.Caption:='提示信息';

        Self.lblMonthValue.Caption:=IntToStr(Self.FShop.recent_goods_popularity);
        Self.lblMonthSale.Caption:='月售'+IntToStr(Self.FShop.recent_goods_popularity);

//        Self.lblDistenceValue.Caption:=FloatToStr(Self.FShop.distance);

        if (Self.FShop.distance<1000) and (Self.FShop.distance>=0) then
        begin
          Self.lblDistenceValue.Caption:=FloatToStr(Self.FShop.distance)+'m';
        end
        else
        begin
          Self.lblDistenceValue.Caption:=FloatToStr(SimpleRoundTo(Self.FShop.distance/1000,-1))+'km';
        end;

        FMX.Types.Log.d('OrangeUI ShopInfoFrame DoGetShopInfoExecuteEnd JSON 2');


//        Self.lblPay.Caption:='￥'+FloatToStr(Self.FShop.deliver_min_order_amount)+'起送';

        Self.UpDateShopInfo;

        FFilterMinOrderAccount:=FShop.deliver_min_order_amount;


        Self.SetingPosition(True,Self.FShop.ShopPromotionList);

        Self.pcShopInfo.Prop.ActivePage:=Self.tsGoods;

        Self.pcShopInfoChange(Self.pcShopInfo);

        FMX.Types.Log.d('OrangeUI ShopInfoFrame DoGetShopInfoExecuteEnd JSON 3');

        Self.AlignControls;

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


procedure TFrameShopInfo.DoGetUserCarGoodsListExecute(ATimerTask:TObject);
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

procedure TFrameShopInfo.DoGetUserCarGoodsListExecuteEnd(ATimerTask:TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  ACarShop:TCarShop;
begin
  try

    if TTimerTask(ATimerTask).TaskTag=0 then
    begin

      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


          if ASuperObject.O['Data'].A['CartGoodsList'].Length>0 then
          begin

              for I := 0 to ASuperObject.O['Data'].A['CartGoodsList'].Length-1 do
              begin

                if Self.FShop.fid=ASuperObject.O['Data'].A['CartGoodsList'].O[I].I['fid'] then
                begin

                  FCarGoodList.Clear(True);
                  FCarGoodList.ParseFromJsonArray(TCarGood,ASuperObject.O['Data'].A['CartGoodsList'].O[I].A['AddedShopGoodsList']);

                end;
              end;
          end
          else
          begin
              FCarGoodList.Clear(True);
          end;

          if Self.FIsPay=True then
          begin
              Self.FIsPay:=False;
              ACarShop:=TCarShop(Self.FShop);

              ACarShop.FCarGoodList.Assign(Self.FCarGoodList,TCarGood);
              HideFrame;//(Self,hfcttBeforeShowFrame);
              //显示登录页面
              ShowFrame(TFrame(GlobalTakeOrderFrame),TFrameTakeOrder,frmMain,nil,nil,nil,Application);
//              GlobalTakeOrderFrame.FrameHistroy:=CurrentFrameHistroy;
              GlobalTakeOrderFrame.AddOrder(ACarShop,Self.FIsNeedPostingFee);
          end;


          if Self.FShopGoodsListFrame<>nil then
          begin
              FShopGoodsListFrame.Clear;
              Self.FShopGoodsListFrame.Load(Self.FShop,//FCarGoodList,
                                            FIsDoBusiness,FShopGoodsListFrame);
          end;



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

procedure TFrameShopInfo.DownloadPictureManager1DownloadSucc(Sender: TObject;
  AUrlPicture: TUrlPicture);
begin
//  TThread.Synchronize(nil,procedure
//  var
//    ASrcBitMap:TBitMap;
//    ADestBitmap:TBitMap;
//    ATempBitmap:TBitmap;
//  var
//    filter:TFilter;
//  begin
//    ASrcBitMap:=TBitMap.Create;
//    ADestBitmap:=TBitMap.Create;
//    ATempBitmap:=nil;
//    filter:=nil;
//    try
//
//
//        ASrcBitMap.LoadFromFile(AUrlPicture.GetOriginFilePath);
//
//        ADestBitmap.SetSize(ASrcBitMap.Width,ASrcBitMap.Height);
//
//
//        ADestBitmap.Canvas.BeginScene();
//        try
//          ADestBitmap.Canvas.Clear(0);
//
//
//          ADestBitmap.Canvas.DrawBitmap(
//                  ASrcBitmap,
//                  RectF((ASrcBitmap.Width/2)-(ASrcBitmap.Width/2)/2/2,(ASrcBitmap.Height/2)-(ASrcBitmap.Height/2)/2/2,(ASrcBitmap.Width/2)+(ASrcBitmap.Width/2)/2/2,(ASrcBitmap.Height/2)+(ASrcBitmap.Height/2)/2/2),
//                  RectF(0,0,ADestBitmap.Width,ADestBitmap.Height),
//                  1
//                  );
//
//        finally
//          ADestBitmap.Canvas.EndScene;
//        end;
//        Self.imgBackground.Prop.Picture.Assign(ADestBitmap);
//
//        //图片下载成功
//        filter :=TFilterManager.FilterByName('GaussianBlur');
//        filter.ValuesAsFloat['BlurAmount'] :=3;   //BlurAmount 是高斯模糊参数的名称, 默认值是 1(0.1..10)
//        filter.ValuesAsBitmap['input'] :=Self.imgBackground.Prop.Picture;
//
//        ATempBitmap:=filter.ValuesAsBitmap['output'];
//        Self.imgBackground.Prop.Picture.Assign(ATempBitmap);
//
//      //  Self.imgBackground.Prop.Picture.SaveToFile('E:\1.png',
//      //                                             nil);
//
//        Self.imgBackground.Invalidate;
//    finally
//      FreeAndNil(ASrcBitMap);
//      FreeAndNil(ADestBitmap);
//      FreeAndNil(ATempBitmap);
//    end;
//
//
//
//  end);
end;

procedure TFrameShopInfo.FrameContext1Load(Sender: TObject);
begin
//  FMX.Types.Log.d('OrangeUI ShopInfoFrame Init');
//  if FIsShowBackBtn then ShowWaitingFrame(Self,'获取中...');
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                       DoGetShopInfoExecute,
//                       DoGetShopInfoExecuteEnd,
//                       'GetShopInfo');
//
//  //不显示返回按钮时  才加载轮播图
//  if Not FIsShowBackBtn then
//  begin
//    uTimerTask.GetGlobalTimerThread.RunTempTask(
//                         DoGetPlatformShopAdExecute,
//                         DoGetPlatformShopAdExecuteEnd,
//                         'GetPlatformShopAd');
//  end;

end;

procedure TFrameShopInfo.FrameResize(Sender: TObject);
begin
  Self.AlignControls;
end;


procedure TFrameShopInfo.GetShowStar(ANumber: Double);
begin
  if (ANumber>=0) and (ANumber<1) then
  begin
    Self.imgStar.Prop.Picture.ImageIndex:=1;
    Self.imgStar1.Prop.Picture.ImageIndex:=1;
    Self.imgStar2.Prop.Picture.ImageIndex:=1;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;

    Self.imgStr1.Prop.Picture.ImageIndex:=1;
    Self.imgStr2.Prop.Picture.ImageIndex:=1;
    Self.imgStr3.Prop.Picture.ImageIndex:=1;
    Self.imgStr4.Prop.Picture.ImageIndex:=1;
    Self.imgStr5.Prop.Picture.ImageIndex:=1;


  end;

  if (ANumber>=1) and (ANumber<2) then
  begin
    Self.imgStar.Prop.Picture.ImageIndex:=0;
    Self.imgStar1.Prop.Picture.ImageIndex:=1;
    Self.imgStar2.Prop.Picture.ImageIndex:=1;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;


    Self.imgStr1.Prop.Picture.ImageIndex:=0;
    Self.imgStr2.Prop.Picture.ImageIndex:=1;
    Self.imgStr3.Prop.Picture.ImageIndex:=1;
    Self.imgStr4.Prop.Picture.ImageIndex:=1;
    Self.imgStr5.Prop.Picture.ImageIndex:=1;
  end;


  if (ANumber>=2) and (ANumber<3) then
  begin
    Self.imgStar.Prop.Picture.ImageIndex:=0;
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=1;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;


    Self.imgStr1.Prop.Picture.ImageIndex:=0;
    Self.imgStr2.Prop.Picture.ImageIndex:=0;
    Self.imgStr3.Prop.Picture.ImageIndex:=1;
    Self.imgStr4.Prop.Picture.ImageIndex:=1;
    Self.imgStr5.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber>=3) and (ANumber<4) then
  begin
    Self.imgStar.Prop.Picture.ImageIndex:=0;
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;


    Self.imgStr1.Prop.Picture.ImageIndex:=0;
    Self.imgStr2.Prop.Picture.ImageIndex:=0;
    Self.imgStr3.Prop.Picture.ImageIndex:=0;
    Self.imgStr4.Prop.Picture.ImageIndex:=1;
    Self.imgStr5.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber>=4) and (ANumber<5) then
  begin
    Self.imgStar.Prop.Picture.ImageIndex:=0;
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=0;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;


    Self.imgStr1.Prop.Picture.ImageIndex:=0;
    Self.imgStr2.Prop.Picture.ImageIndex:=0;
    Self.imgStr3.Prop.Picture.ImageIndex:=0;
    Self.imgStr4.Prop.Picture.ImageIndex:=0;
    Self.imgStr5.Prop.Picture.ImageIndex:=1;
  end;

  if ANumber>=5 then
  begin
    Self.imgStar.Prop.Picture.ImageIndex:=0;
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=0;
    Self.imgStar4.Prop.Picture.ImageIndex:=0;


    Self.imgStr1.Prop.Picture.ImageIndex:=0;
    Self.imgStr2.Prop.Picture.ImageIndex:=0;
    Self.imgStr3.Prop.Picture.ImageIndex:=0;
    Self.imgStr4.Prop.Picture.ImageIndex:=0;
    Self.imgStr5.Prop.Picture.ImageIndex:=0;
  end;
end;

procedure TFrameShopInfo.HideAddCarGoodsFrame;
begin
  if FAddCarGoodsFrame<>nil then
  begin
    FAddUserCarFrameIsShow:=False;
    HideFrame;//(FAddCarGoodsFrame);
  end;
end;

procedure TFrameShopInfo.imgPicClick(Sender: TObject);
begin
  if Self.imgPic.Prop.Picture.ImageIndex=1 then
  begin
    if (FAddCarGoodsFrame=nil) or (FAddUserCarFrameIsShow=False) then
    begin
      FAddUserCarFrameIsShow:=True;
      //加载购物车列表
      ShowFrame(TFrame(FAddCarGoodsFrame),TFrameAddCarGoods,frmMain,nil,nil,OnReturnFromCarListFrame,Application,False,False,ufsefNone);
      FAddCarGoodsFrame.Clear;
      FAddCarGoodsFrame.Load(Self.FGlobalShopInfoFrame);
      FAddCarGoodsFrame.Margins.Rect:=RectF(0,0,0,pnlCar.Height);
      if IsIPhoneX(TForm(Application.MainForm)) then
      begin
        FAddCarGoodsFrame.Margins.Rect:=RectF(0,0,0,pnlCar.Height+GlobalIPhoneXBottomBarHeight);
      end;

      if Not FIsShowBackBtn then
      begin
        FAddCarGoodsFrame.Margins.Rect:=RectF(0,0,0,pnlCar.Height+60);
      end;
    end
    else
    begin
      FAddUserCarFrameIsShow:=False;
      HideFrame;//(FAddCarGoodsFrame);
    end;
  end;
end;

procedure TFrameShopInfo.imgPlayerResize(Sender: TObject);
begin
  Self.bgIndicator.Position.X:=Self.imgPlayer.Width-Self.bgIndicator.Width-20;
  imgPlayer.Height:=imgPlayer.Width*2/5;
end;

procedure TFrameShopInfo.Init;
begin


  FMX.Types.Log.d('OrangeUI ShopInfoFrame Init');
  if FIsShowBackBtn then ShowWaitingFrame(Self,'获取中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                       DoGetShopInfoExecute,
                       DoGetShopInfoExecuteEnd,
                       'GetShopInfo');

  //不显示返回按钮时  才加载轮播图
  if Not FIsShowBackBtn then
  begin
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                         DoGetPlatformShopAdExecute,
                         DoGetPlatformShopAdExecuteEnd,
                         'GetPlatformShopAd');
  end;
end;

function TFrameShopInfo.IsDoBusiness(AShop: TShop): Boolean;
begin
  Result:=False;

  if AShop.status=1 then
  begin

      case DayofWeek(Now) of
        1:
         if AShop.sun_is_sale=1 then
         begin
           if (CompareTime(Now,StandardStrToDateTime(AShop.sun_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.sun_end_time))=-1) then
           begin
             Result:=True;
           end;
         end;
        2:
         if AShop.mon_is_sale=1 then
         begin
           if (CompareTime(Now,StandardStrToDateTime(AShop.mon_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.mon_end_time))=-1) then
           begin
             Result:=True;
           end;
         end;

        3:
         if AShop.tues_is_sale=1 then
         begin
           if (CompareTime(Now,StandardStrToDateTime(AShop.tues_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.tues_end_time))=-1) then
           begin
             Result:=True;
           end;
         end;

        4:
         if AShop.wed_is_sale=1 then
         begin
           if (CompareTime(Now,StandardStrToDateTime(AShop.wed_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.wed_end_time))=-1) then
           begin
             Result:=True;
           end;
         end;

        5:
         if AShop.thur_is_sale=1 then
         begin
           if (CompareTime(Now,StandardStrToDateTime(AShop.thur_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.thur_end_time))=-1) then
           begin
             Result:=True;
           end;
         end;

        6:
         if AShop.fri_is_sale=1 then
         begin
           if (CompareTime(Now,StandardStrToDateTime(AShop.fri_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.fri_end_time))=-1) then
           begin
             Result:=True;
           end;
         end;

        7:
         if AShop.sat_is_sale=1 then
         begin
           if (CompareTime(Now,StandardStrToDateTime(AShop.sat_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.sat_end_time))=-1) then
           begin
             Result:=True;
           end;
         end;

      end;
  end
  else
  begin
      Result:=False;
  end;
end;

procedure TFrameShopInfo.IsShowBackBtn(IsShowBackBtn: Boolean=True);
begin
  FIsShowBackBtn:=IsShowBackBtn;
  Self.btnReturn.Visible:=IsShowBackBtn;
  //不显示返回按钮  也不显示店铺图标
  Self.imgShoplogo.Visible:=True;
  Self.imgPlayer.Visible:=False;

  Self.SkinFMXPanel1.Visible:=True;
  Self.SkinFMXPanel1.Height:=90;

  Self.pnlToolBar.SelfOwnMaterialToDefault.BackColor.IsFill:=False;
  Self.btnSearch.Margins.Left:=0;
  if Not IsShowBackBtn then
  begin
    Self.imgShoplogo.Visible:=False;
    Self.imgPlayer.Visible:=True;

    Self.SkinFMXPanel1.Visible:=False;

    Self.pnlToolBar.SelfOwnMaterialToDefault.BackColor.IsFill:=True;
    Self.pnlToolBar.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=SkinThemeColor;

    Self.btnSearch.Margins.Left:=10;

  end;

end;

procedure TFrameShopInfo.lbActvListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
  if AItem.Data<>nil then
  begin
    if AItem.Index=0 then
    begin
      Self.btnActvCount.Visible:=True;
    end
    else
    begin
      Self.btnActvCount.Visible:=False;
    end;
  end;
end;

procedure TFrameShopInfo.Load(AShopFID:Integer;
                              ACarGoodList:TCarGoodList;
                              AShopInfoFrame:TFrame);
begin

  FUserFID:=GlobalManager.User.fid;

  FIsPay:=False;
  Self.imgBackground.Prop.Picture.Clear;
  Self.imgShoplogo.Prop.Picture.Clear;

  FGlobalShopInfoFrame:=AShopInfoFrame;

  Self.sbContent.Prop.VertControlGestureManager.Position:=0;

  FFilterShopFID:=AShopFID;

  FCarGoodList.Assign(ACarGoodList,TCarGood);

  Self.Init;

  AlignControls;

  GlobalMainFrame.UpDateMyCar;

  Self.btnReturn.Visible:=FIsShowBackBtn;
end;

procedure TFrameShopInfo.lvCouponPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
  if AItem.Tag=0 then
  begin
    Self.btnRecv.Enabled:=True;
  end
  else
  begin
    Self.btnRecv.Enabled:=False;
  end;
end;

procedure TFrameShopInfo.OnReturnFromCarListFrame(AFrame: TFrame);
begin
//  Self.UpDataMyCar;

//   Self.FShopGoodsListFrame.Load(Self.FShop,nil,FIsDoBusiness);
end;

procedure TFrameShopInfo.pcShopInfoChange(Sender: TObject);
var
  IsFirstCreate:Boolean;
begin
  if Self.pcShopInfo.Prop.ActivePage=Self.tsGoods then
  begin
    FMX.Types.Log.d('OrangeUI ShopInfoFrame tsGoods');

    IsFirstCreate:=FShopGoodsListFrame=nil;
    ShowFrame(TFrame(FShopGoodsListFrame),TFrameShopGoodsList,Self.tsGoods,nil,nil,nil,Self,False,True,ufsefNone);
    FShopGoodsListFrame.Clear;
    FShopGoodsListFrame.Load(FShop,//FCarGoodList,
                            FIsDoBusiness,FGlobalShopInfoFrame);
    //下载图片管理
    FShopGoodsListFrame.tvShopGoodsList.Prop.DownloadPictureManager:=GlobalMainFrame.dpmShopGoodsPic;

  end;

  if Self.pcShopInfo.Prop.ActivePage=Self.tsUser then
  begin
    FMX.Types.Log.d('OrangeUI ShopInfoFrame tsUser');

    IsFirstCreate:=FShopUserInfoFrame=nil;
    ShowFrame(TFrame(FShopUserInfoFrame),TFrameShopUserInfo,Self.tsUser,nil,nil,nil,Self,False,True,ufsefNone);
    FShopUserInfoFrame.Clear;
    FShopUserInfoFrame.Init(FShop,FGlobalShopInfoFrame);
  end;

  if Self.pcShopInfo.Prop.ActivePage=Self.tsEstimate then
  begin

    FMX.Types.Log.d('OrangeUI ShopInfoFrame tsEstimate');

    IsFirstCreate:=FEvaluateListFrame=nil;
    ShowFrame(TFrame(FEvaluateListFrame),TFrameShopInfoEvaluateList,Self.tsEstimate,nil,nil,nil,Self,False,True,ufsefNone);
    FEvaluateListFrame.Clear;
    FEvaluateListFrame.Init(FShop,Self.FGlobalShopInfoFrame);
  end;

end;

procedure TFrameShopInfo.sbcContentResize(Sender: TObject);
begin
  Self.imgBrand.Left:=(Self.Width-260)/2;
//  Self.lblShopName.Left:=Self.imgBrand.Left+Self.imgBrand.Width;

  Self.imgStar.Left:=(Self.Width-300)/2;
  Self.imgStar1.Left:=Self.imgStar.Left+Self.imgStar.Width;
  Self.imgStar2.Left:=Self.imgStar1.Left+Self.imgStar1.Width;
  Self.imgStar3.Left:=Self.imgStar2.Left+Self.imgStar2.Width;
  Self.imgStar4.Left:=Self.imgStar3.Left+Self.imgStar3.Width;

  Self.lblMonth.Left:=Self.imgStar4.Left+Self.imgStar4.Width+10;
  Self.lblDeliver.Left:=Self.lblMonth.Left+Self.lblMonth.Width+10;
  Self.lblDistence.Left:=Self.lblDeliver.Left+Self.lblDeliver.Width+10;

  Self.lblScore.Left:=(Self.Width-300)/2;

  Self.lblMonthValue.Left:=Self.lblMonth.Left;
  Self.lblDeliverValue.Left:=Self.lblMonthValue.Left+Self.lblMonthValue.Width+10;
  Self.lblDistenceValue.Left:=Self.lblDeliverValue.Left+Self.lblDeliverValue.Width+10;

  Self.imgStr1.Left:=(Self.Width-300)/2;
  Self.imgStr2.Left:=Self.imgStr1.Left+Self.imgStr1.Width;
  Self.imgStr3.Left:=Self.imgStr2.Left+Self.imgStr2.Width;
  Self.imgStr4.Left:=Self.imgStr3.Left+Self.imgStr3.Width;
  Self.imgStr5.Left:=Self.imgStr4.Left+Self.imgStr4.Width;

  Self.lblScore1.Left:=Self.imgStr5.Left+Self.imgStr5.Width;
  Self.lblMonthSale.Left:=Self.lblScore1.Left+Self.lblScore1.Width+10;
  Self.lblDis.Left:=Self.lblMonthSale.Left+Self.lblMonthSale.Width+10;

//  Self.btnSave.Top:=Self.imgShoplogo.Top+Self.imgShoplogo.Height/3;
end;

procedure TFrameShopInfo.sbContentVertScrollBarChange(Sender: TObject);
var
  APercent:Double;
begin
  //设置滚动条事件
  APercent:=Self.sbContent.Prop.VertControlGestureManager.Position/30;

  if APercent>1 then
  begin
    APercent:=1;
  end;

  //平台商家界面一直显示搜索框
  if FIsShowBackBtn then
  begin
    Self.btnSearch.Opacity:=APercent;
    Self.imgShoplogo.SelfOwnMaterialToDefault.DrawPictureParam.DrawRectSetting.Height:=(1-APercent)*100;
    Self.imgShoplogo.Opacity:=1-APercent;
  end
  else
  begin
    Self.btnSearch.Opacity:=1;
    Self.imgShoplogo.SelfOwnMaterialToDefault.DrawPictureParam.DrawRectSetting.Height:=0;
    Self.imgShoplogo.Opacity:=0;
  end;
end;

procedure TFrameShopInfo.SetingPosition(AIsUpDown: Boolean;AActvList:TActivityList);
var
  I: Integer;
  AListViewItem:TSkinListViewItem;
  AListBoxItem:TSkinListBoxItem;
  J: Integer;
  ACount:Integer;
begin
  ACount:=0;
  Self.lvCoupon.Prop.Items.Clear(True);


  Self.lvCoupon.Prop.Items.BeginUpdate;
  try
    for I := 0 to AActvList.Count-1 do
    begin
      if AActvList[I].promotion_type='coupon' then
      begin
        AListViewItem:=Self.lvCoupon.Prop.Items.Add;
        AListViewItem.Data:=AActvList[I];
        AListViewItem.Caption:='￥'+FloatToStr(AActvList[I].dec_money1);
        AListViewItem.Detail:='满'+FloatToStr(AActvList[I].full_money1)+'可用';
        if AActvList[I].is_taked=0 then
        begin
          AListViewItem.Detail1:='领取';
        end
        else
        begin
          AListViewItem.Detail1:='已领';
        end;

        AListViewItem.Tag:=AActvList[I].is_taked;
        ACount:=ACount+1;
      end;
    end;
  finally
    Self.lvCoupon.Prop.Items.EndUpdate();
  end;



  Self.lvCoupon.Height:=Self.lvCoupon.Prop.GetContentHeight;

  Self.lbActvList.Prop.Items.Clear(True);

  Self.lbActvList.Prop.Items.BeginUpdate;
  try
    for J := 0 to AActvList.Count-1 do
    begin
      if AActvList[J].promotion_type<>'coupon' then
      begin
        AListBoxItem:=Self.lbActvList.Prop.Items.Add;
        AListBoxItem.Data:=AActvList[I];
        if AActvList[J].promotion_type='full_dec_money' then
        begin
          AListBoxItem.Caption:='満减';
          AListBoxItem.Detail:=GetActivityRules(AActvList[J].full_money1,
                                                AActvList[J].dec_money1,
                                                AActvList[J].full_money2,
                                                AActvList[J].dec_money2,
                                                AActvList[J].full_money3,
                                                AActvList[J].dec_money3);
        end
        else
        begin
          if AActvList[J].promotion_type='special_price_goods' then
          begin
            AListBoxItem.Caption:='特价';
          end
          else if AActvList[J].promotion_type='discount' then
          begin
            AListBoxItem.Caption:='打折';
          end;

          AListBoxItem.Detail:='特价仅'+FloatToStr(AActvList[J].special_price)+'元';
        end;

      end;

      if Self.lbActvList.Prop.Items.Count>0 then
      begin
        Self.lbActvList.Prop.Items[0].Detail1:=IntToStr(AActvList.Count)+'个优惠';
      end;

    end;
  finally
    Self.lbActvList.Prop.Items.EndUpdate();
  end;



//  Self.btnActvCount.Caption:=IntToStr(AActvList.Count)+'个优惠';

  if AIsUpDown=True then
  begin

    Self.btnUpDown.Visible:=False;
    Self.pnlDetail.Visible:=False;

    Self.pnlDetail2.Visible:=True;

    Self.imgSign.Visible:=True;
    Self.btnActvCount.Margins.Right:=0;


    Self.pnlDetail2.Position.Y:=Self.pnlShopName.Position.Y+Self.pnlShopName.Height;

//    Self.lvCoupon.Height:=46;

    Self.lblAdv.Visible:=False;

    Self.lblActv.Visible:=False;

    Self.lblCouponDetail1.Visible:=False;
    Self.lvCoupon.Prop.ItemHeight:=30;

    if Self.lvCoupon.Prop.Items.Count>0 then
    begin
      if Self.lvCoupon.Prop.Items.Count<=4 then
      begin
//        Self.lvCoupon.Height:=(Self.lvCoupon.Prop.Items.Count/2)*30+(Self.lvCoupon.Prop.Items.Count mod 2)*30;
        Self.lvCoupon.Height:=Self.lvCoupon.Prop.GetContentHeight;
      end
      else
      begin
        Self.lvCoupon.Height:=80;
      end;
      Self.pnlCoupon.Height:=Self.lvCoupon.Height+10;
    end
    else
    begin
      Self.lvCoupon.Height:=Self.lvCoupon.Prop.GetContentHeight;
      Self.pnlCoupon.Height:=Self.lvCoupon.Height;
    end;

    if ACount=1 then
    begin
      Self.lvCoupon.Prop.ItemCountPerLine:=1;
      Self.lvCoupon.Width:=180;
    end
    else
    begin
      Self.lvCoupon.Prop.ItemCountPerLine:=2;
      Self.lvCoupon.Width:=300;
    end;

    Self.lbActvList.Height:=Self.lbActvList.Prop.ItemHeight;

//    Self.pnlActv.Height:=Self.lbActvList.Height+5;

    Self.pcShopInfo.Visible:=True;


//    Self.pnlCar.Visible:=FIsDoBusiness;
//
//    Self.pnlRest.Visible:=Not FIsDoBusiness;

    if FIsDoBusiness=True then
    begin
      if (FShop.is_can_takeorder_but_only_self_take=0)
      AND (FShop.is_can_takeorder_and_delivery=0)
      AND (FShop.is_can_takeorder_but_only_eat_in_shop=0) then
      begin
        Self.pnlCar.Visible:=False;
        Self.pnlRest.Visible:=True;
      end
      else
      begin
        Self.pnlCar.Visible:=True;
        Self.pnlRest.Visible:=False;
      end;
    end
    else
    begin
      Self.pnlCar.Visible:=False;
      Self.pnlRest.Visible:=True;
    end;




//    Self.pcShopInfo.Position.Y:=Self.lbActvList.Position.Y+Self.lbActvList.Height;

//    Self.sbcContent.Height:=GetSuitScrollContentHeight(Self.sbcContent);

  end
  else
  begin
    Self.btnUpDown.Visible:=True;
    Self.pnlDetail2.Visible:=False;


    Self.imgSign.Visible:=False;

    Self.btnActvCount.Margins.Right:=15;

    Self.pnlDetail.Visible:=True;
    Self.pnlDetail.Position.Y:=Self.pnlShopName.Position.Y+Self.pnlShopName.Height;


    Self.lblAdv.Visible:=True;

    Self.lblAdv.Position.Y:=Self.pnlDetail.Position.Y+Self.pnlDetail.Height;

    Self.lblActv.Visible:=True;

    Self.lblActv.Position.Y:=Self.pnlAdv.Position.Y+Self.pnlAdv.Height;

    Self.lblCouponDetail1.Visible:=True;
    Self.lvCoupon.Prop.ItemHeight:=60;
    Self.lvCoupon.Height:=Self.lvCoupon.Prop.GetContentHeight;

    Self.pnlCoupon.Height:=Self.lvCoupon.Height+10;

    if ACount=1 then
    begin
      Self.lvCoupon.Prop.ItemCountPerLine:=1;
      Self.lvCoupon.Width:=240;
    end
    else
    begin
      Self.lvCoupon.Prop.ItemCountPerLine:=2;
      Self.lvCoupon.Width:=300;
    end;

    Self.lbActvList.Height:=Self.lbActvList.Prop.GetContentHeight;

//    Self.pnlActv.Height:=Self.lbActvList.Height+5;

    Self.pcShopInfo.Visible:=False;

    Self.pnlCar.Visible:=False;

    Self.pnlRest.Visible:=False;

//    Self.sbcContent.Height:=GetSuitScrollContentHeight(Self.sbcContent);


  end;

end;

procedure TFrameShopInfo.tmrTestGPSLocationTimer(Sender: TObject);
begin
  tmrTestGPSLocation.Enabled:=True;

  Self.sbContent.Invalidate;
  Self.sbcContent.Invalidate;
  Self.imgBackground.Invalidate;
  Self.imgShoplogo.Invalidate;
end;

procedure TFrameShopInfo.UpDataMyCar;
begin

  uTimerTask.GetGlobalTimerThread.RunTempTask(
                     DoGetUserCarGoodsListExecute,
                     DoGetUserCarGoodsListExecuteEnd,
                     'GetUserCarGoodsList');
end;

procedure TFrameShopInfo.UpDateShopInfo;
var
  I: Integer;
  J:Integer;
  ASumPrice:Double;
  ANumber:Integer;
begin
  ASumPrice:=0;
  nniUserCartNumber.Prop.Number:=0;
  for I := 0 to GlobalManager.UserCarShopList.Count-1 do
  begin
    if FShop.fid=GlobalManager.UserCarShopList[I].fid then
    begin
      for J := 0 to GlobalManager.UserCarShopList[I].FCarGoodList.Count-1 do
      begin
        nniUserCartNumber.Prop.Number:=nniUserCartNumber.Prop.Number+GlobalManager.UserCarShopList[I].FCarGoodList[J].number;

        if GlobalManager.UserCarShopList[I].FCarGoodList[J].special_price<>0 then
        begin
          ASumPrice:=ASumPrice+GlobalManager.UserCarShopList[I].FCarGoodList[J].special_price*GlobalManager.UserCarShopList[I].FCarGoodList[J].number;
        end
        else
        begin
          ASumPrice:=ASumPrice+GlobalManager.UserCarShopList[I].FCarGoodList[J].origin_price*GlobalManager.UserCarShopList[I].FCarGoodList[J].number;
        end;
      end;

//      nniUserCartNumber.Prop.Number:=ANumber;
    end;
  end;

  if ASumPrice<>0 then
  begin
    imgPic.Prop.Picture.ImageIndex:=1;
    lblSelectedPay.Caption:='￥'+Format('%.2f',[ASumPrice]);
    lblSelectedPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.White;

    if FShop.deliver_min_order_amount>ASumPrice then
    begin
      lblPay.Visible:=True;
      lblPay.Caption:='还差 ￥'+Format('%.2f',[FShop.deliver_min_order_amount-ASumPrice]);
      btnPay.Visible:=False;
    end
    else
    begin
      lblPay.Visible:=False;
      btnPay.Visible:=True;
    end;

  end
  else
  begin
    imgPic.Prop.Picture.ImageIndex:=0;

    lblSelectedPay.Caption:='未选购商品';
    lblSelectedPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Lightgray;
    lblPay.Visible:=True;
    lblPay.Caption:='￥'+FloatToStr(FShop.deliver_min_order_amount)+'起送';
    btnPay.Visible:=False;

  end;


  if Self.FShopGoodsListFrame<>nil then
  begin
//    FShopGoodsListFrame.Load(Self.FShop,nil,Self.FIsDoBusiness,FGlobalShopInfoFrame);

    Self.FShopGoodsListFrame.UpDateShopListFrame(GlobalManager.UserCarShopList);
  end;


  if Self.FAddCarGoodsFrame<>nil then
  begin
    Self.FAddCarGoodsFrame.Load(Self.FGlobalShopInfoFrame);
  end;

end;

end.





