unit TakeOrderFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  System.DateUtils,

  uOpenClientCommon,
  uGetDeviceInfo,
  FMX.DeviceInfo,
  EasyServiceCommonMaterialDataMoudle,
  CommonImageDataMoudle,
  uFrameContext,
  Math,
  uSkinBufferBitmap,

//  uCommonUtils,
  uOpenCommon,
  uGPSLocation,
  uDataSetToJson,
  uRestInterfaceCall,
  uBaseHttpControl,
  uTimerTask,
  WaitingFrame,
  MessageBoxFrame,
  PopupMenuFrame,
  PayOrderCommonFrame,

  uSkinItems,

  uUIFunction,
  XSuperObject,
  XSuperJson,
  uFuncCommon,

  uManager,
  uMobileUtils,
  uSkinListViewType,
  uSkinListBoxType,

  uBaseList,


  uSkinFireMonkeyCheckBox, uSkinFireMonkeyLabel, FMX.Controls.Presentation,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinFireMonkeyButton,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, uSkinFireMonkeyRadioButton, uSkinMaterial,
  uSkinButtonType, uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyCustomList, uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView,
  uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyListBox,
  uSkinMultiColorLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uSkinCustomListType, uSkinVirtualListType, uSkinLabelType, uSkinPanelType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uDrawCanvas, uDrawPicture, uSkinImageList, uSkinRadioButtonType,
  FMX.Memo.Types;


const
  Const_DeliverType_Caption:Array [0..2] of String=
    ('需要配送','自取','堂食');
  Const_DeliverType_Names:Array [0..2] of String=
    (Const_DeliverType_NeedDeliver,Const_DeliverType_SelfTake,Const_DeliverType_EatInShop);

  Const_DeliverType1_Caption:Array [0..1] of String=
    ('需要配送','自取');
  Const_DeliverType1_Names:Array [0..1] of String=
    (Const_DeliverType_NeedDeliver,Const_DeliverType_SelfTake);

  Const_DeliverType2_Caption:Array [0..1] of String=
    ('需要配送','堂食');
  Const_DeliverType2_Names:Array [0..1] of String=
    (Const_DeliverType_NeedDeliver,Const_DeliverType_EatInShop);

  Const_No_DeliverType_Caption:Array [0..1] of String=
    ('自取','堂食');
  Const_No_DeliverType_Names:Array [0..1] of String=
    (Const_DeliverType_SelfTake,Const_DeliverType_EatInShop);

type
  TFrameTakeOrder = class(TFrame
                          ,IFrameVirtualKeyboardAutoProcessEvent
                          ,IFrameVirtualKeyboardEvent
                          )
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlEmptyBottom: TSkinFMXPanel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlRecvAddr: TSkinFMXPanel;
    pnlRemark: TSkinFMXPanel;
    memRemark: TSkinFMXMemo;
    pnlUserCoupon: TSkinFMXPanel;
    btnSelectUserCoupon: TSkinFMXButton;
    pnlOrderFees: TSkinFMXPanel;
    lbOrderFees: TSkinFMXListBox;
    idpItemOrderFee: TSkinFMXItemDesignerPanel;
    SkinFMXPanel5: TSkinFMXPanel;
    btnSelectRecvAddr: TSkinFMXButton;
    lblRecvAddr: TSkinFMXLabel;
    SkinFMXPanel6: TSkinFMXPanel;
    lblRecvName: TSkinFMXLabel;
    lblRecvPhone: TSkinFMXLabel;
    pnlBottomBar: TSkinFMXPanel;
    btnOK: TSkinFMXButton;
    lblSumMoney: TSkinFMXMultiColorLabel;
    SkinFMXPanel1: TSkinFMXPanel;
    pnlSubTotal: TSkinFMXPanel;
    lblFeeName: TSkinFMXLabel;
    lblFeeDesc: TSkinFMXLabel;
    lblFeeNum: TSkinFMXLabel;
    pnlTablewareQuantity: TSkinFMXPanel;
    btnSelectTablewareQuantity: TSkinFMXButton;
    pnlShopName: TSkinFMXPanel;
    lblSubTotal: TSkinFMXMultiColorLabel;
    pnlSelectDeliverType: TSkinFMXPanel;
    btnSelectDeliverType: TSkinFMXButton;
    SkinFMXPanel2: TSkinFMXPanel;
    lblShopName: TSkinFMXLabel;
    DrawCanvasSetting1: TDrawCanvasSetting;
    lblFeeMoney: TSkinFMXLabel;
    lblOriginFeeMoney: TSkinFMXLabel;
    imgButton: TSkinImageList;
    pnlArriveTime: TSkinFMXPanel;
    btnTime: TSkinFMXButton;
    lblDistence: TSkinFMXLabel;
    btnLook: TSkinFMXButton;
    pnlScoreCut: TSkinFMXPanel;
    mcUserScore: TSkinFMXMultiColorLabel;
    rbUseScore: TSkinFMXRadioButton;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXPanel3: TSkinFMXPanel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnSelectUserCouponStayClick(Sender: TObject);
    procedure btnSelectDeliverTypeClick(Sender: TObject);
    procedure btnSelectTablewareQuantityClick(Sender: TObject);
    procedure btnSelectRecvAddrClick(Sender: TObject);
    procedure btnSelectUserCouponClick(Sender: TObject);
    procedure btnTimeClick(Sender: TObject);
    procedure lbOrderFeesPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure btnLookClick(Sender: TObject);
    procedure rbUseScoreClick(Sender: TObject);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
    //获取虚拟键盘的高度校正
    function GetVirtualKeyboardHeightAdjustHeight:Double;
  private
    //显示虚拟键盘
    procedure DoVirtualKeyboardShow(KeyboardVisible: Boolean; const Bounds: TRect);
    //隐藏虚拟键盘
    procedure DoVirtualKeyboardHide(KeyboardVisible: Boolean; const Bounds: TRect);
  private
    FCouponList:TCouponList;
    //商家
    FCarShop:TCarShop;
    //红包FID
    FCouponFID:Integer;

    //配送费用计算
    FDistance_free: Double;
		FWeather_free: Double;
		FWeight_free: Double;
		FTime_free: Double;
		FBasic_free: Double;
		FVolum_free: Double;

    //想要送达时间
    FWant_Arrived_Time:String;

    //送达时间
    FDelivery_Time:Integer;

    //是否预定单
    FIs_Book:Integer;

    //可用红包FID
    FUserCouponFID:Integer;

    //配送类型
    FDelivery_Type:String;

    //下单的购物车商品有
//    FBuyGoodsList:TBuyGoodsList;

    //预下单返回的费用列表
//    FPrepareOrderFeeList:TPrepareOrderFeeList;

    //收货地址
    FUserRecvAddr:TUserRecvAddr;

    //收货地址经纬度
    FLongitude:Double;
    FLatitude:Double;
    //积分兑换比列
    FScoreUnit:Double;

  private
    //获取用户收货地址列表,刚进入到这个页面,就要自动填上用户的收货地址
    procedure DoGetRecvAddrListExecute(ATimerTask:TObject);
    procedure DoGetRecvAddrListExecuteEnd(ATimerTask:TObject);
  private
    //从选择使用红包界面返回
    procedure OnReturnFromSelectedCouponFrame(AFrame:TFrame);
    //从选择预定配送时间返回
    procedure OnReturnDeliveryTimeFrame(AFrame:TFrame);
  private
    //准备下单
    procedure DoPrepareOrderExecute(ATimerTask:TObject);
    procedure DoPrepareOrderExecuteEnd(ATimerTask:TObject);

    //下单
    procedure DoTakeOrderExecute(ATimerTask:TObject);
    procedure DoTakeOrderExecuteEnd(ATimerTask:TObject);

  private
    //放弃订单
    procedure OnModalResultFromLeaveOrder(Frame:TObject);
  private
    //弹出框菜单点击
    //选择配送方式
    procedure DoSelectDeliverTypeFromPopupMenuFrame(APopupMenuFrame:TFrame);
    //选择餐具份数
    procedure DoSelectTablewareQuantityFromPopupMenuFrame(APopupMenuFrame:TFrame);

  private
//    //选择介绍人返回
//    procedure OnReturnFrameFromSelectManager(Frame:TFrame);
//    //选择酒店返回
//    procedure OnReturnFrameFromSelectHotel(Frame:TFrame);
    //选择用户收货地址返回
    procedure OnReturnFrameFromSelectRecvAddr(Frame:TFrame);

    { Private declarations }
  private
    procedure Clear;

    procedure AlignControls;

    function GetCartShopGoodsListJson:ISuperArray;

    //预下订单
    procedure PrepareOrder;
    procedure GetUserSuitRecvAddrList;

    procedure SyncSummary;
    //清除收货地址
    procedure ClearUserRecvAddr;
    procedure SyncDeliverTypeSelection;
    //加载收货地址
    procedure LoadUserRecvAddToUI(AUserRecvAdd:TUserRecvAddr);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    //是否在线支付 暂时平台商家使用
    //加了骑手端  统一都在线支付
    FIsPayGoodsMoneyOnline:Integer;
    //是否平台商家
    FIsPlatFormShop:Integer;
    //商家配送方式
    FShopDeliverType:Integer;
    //满多少包邮
    FMinPostingPrice:Double;
    //是否包邮
    FIsNeedPostingFee:Integer;

    //添加订单
    procedure AddOrder(ACarShop:TCarShop;
                       AIsNeedPostingFee:Integer=0;
                       AShopDeliverType:Integer=2;
                       AIsPayGoodsMoneyOnline:Integer=0;
                       AIsPlatFormShop:Integer=0;
                       AMinPostingPrice:Double=0);
    { Public declarations }
  end;


var
  GlobalTakeOrderFrame:TFrameTakeOrder;


implementation

{$R *.fmx}

uses
//  UserListFrame,
//  OrderGoodsListFrame,
//  PayOrderFrame,
//  AddMyBankCardFrame,
//  SelectUserListFrame,
  TakeOrderUseCouponListFrame,
  BookableOrderTimeFrame,
  RecvAddrListFrame,
  PayOrderFrame,
//  HotelListFrame,
  MainFrame,
  MainForm;



procedure TFrameTakeOrder.Clear;
begin

  Self.FCarShop:=nil;

  FCouponFID:=0;

  FUserCouponFID:=0;

  FDelivery_Time:=0;


  //配送费用计算
  FDistance_free:=0;
  FWeather_free:=0;
  FWeight_free:=0;
  FTime_free:=0;
  FBasic_free:=0;
  FVolum_free:=0;

  FWant_Arrived_Time:='';

  FIs_Book:=0;

  //配送方式
  Self.btnSelectDeliverType.Caption:=Const_DeliverType_Names[0];
  FDelivery_Type:=Const_DeliverType_Names[0];

  Self.pnlArriveTime.Caption:='预计送达时间';
//  Self.btnSelectDeliverType.Tag:=0;
  Self.SyncDeliverTypeSelection;


  //清除收货信息
  ClearUserRecvAddr;



  Self.lblShopName.Caption:='';

  Self.btnTime.Caption:='';


//  FOrder:=nil;

//  Self.btnViewBuyGoodsList.Caption:='';
  Self.lbOrderFees.Prop.Items.Clear(True);


  //红包
  Self.btnSelectUserCoupon.Caption:='';
  Self.btnSelectUserCoupon.Tag:=0;


  //小计
  Self.lblSubTotal.Prop.ColorTextCollection.Items[0].Text:='小计:';
  Self.lblSubTotal.Prop.ColorTextCollection.Items[1].Text:='¥';
  Self.lblSubTotal.Prop.ColorTextCollection.ItemByName['SubTotal'].Text:=
      Format('%.2f',[0.00]);



  //餐具份数
  Self.btnSelectTablewareQuantity.Caption:='';
  Self.btnSelectTablewareQuantity.Tag:=0;


  //备注
  Self.memRemark.Text:='';


  //合计
  Self.lblSumMoney.Prop.ColorTextCollection.Items[0].Text:='合计:';
  Self.lblSumMoney.Prop.ColorTextCollection.Items[1].Text:='¥';
  Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
    Format('%.2f',[0.00]);
  //减免金额
  Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['DecMoney'].Text:='';


  AlignControls;

  Self.sbClient.VertScrollBar.Prop.Position:=0;
end;

procedure TFrameTakeOrder.ClearUserRecvAddr;
begin
  Self.lblRecvName.Caption:='';
  Self.lblRecvPhone.Caption:='';
  Self.lblRecvAddr.Caption:='';

  Self.lblDistence.Caption:='';

  Self.FLongitude:=0;
  Self.FLatitude:=0;

  Self.FUserRecvAddr.Clear;
end;

constructor TFrameTakeOrder.Create(AOwner: TComponent);
begin
  inherited;

//  FShop:=TShop.Create;
//  FBuyGoodsList:=TBuyGoodsList.Create();
  FUserRecvAddr:=TUserRecvAddr.Create;

  FCouponList:=TCouponList.Create;
//  FPrepareOrderFeeList:=TPrepareOrderFeeList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameTakeOrder.Destroy;
begin
//  FreeAndNil(FShop);
//  FreeAndNil(FBuyGoodsList);
//  FreeAndNil(FPrepareOrderFeeList);
  FreeAndNil(FUserRecvAddr);

  FreeAndNil(FCouponList);
  inherited;
end;

procedure TFrameTakeOrder.DoTakeOrderExecute(ATimerTask: TObject);
var
  ATempScoreMoney:Double;
  ATempIsOnlyPayDeliveryFee:Integer;
begin
  ATempScoreMoney:=0;
  if Self.mcUserScore.Prop.Items[3].Text<>'' then
  begin
    ATempScoreMoney:=StrToFloat(Self.mcUserScore.Prop.Items[3].Text);
  end;

  ATempIsOnlyPayDeliveryFee:=1;
  if Self.FIsPayGoodsMoneyOnline=1 then
  begin
    ATempIsOnlyPayDeliveryFee:=0;
  end;

  //配送方式  (dtSelf 2 自己配送)  (dtPosting 3 快递)
  if (FShopDeliverType=Ord(dtSelf)) OR (FShopDeliverType=Ord(dtExpress)) then FDelivery_Type:=Const_DeliverType_NeedDeliver;
  if FShopDeliverType=Ord(dtPosting) then FDelivery_Type:=Const_DeliverType_Express;

//  //普通商家都是配送   平台商家是快递
//  FDelivery_Type:=Const_DeliverType_NeedDeliver;
//  if FIsPlatFormShop=1 then
//  begin
//    FDelivery_Type:=Const_DeliverType_Express;
//  end;

  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
              SimpleCallAPI('take_order',
              nil,
              ShopCenterInterfaceUrl,
              [
              'appid',
              'user_fid',
              'key',

              'deliver_type',

              'recv_longitude',
              'recv_latitude',
              'recv_name',
              'recv_sex',
              'recv_phone',
              'recv_province',
              'recv_city',
              'recv_area',
              'recv_addr',
              'recv_door_no',

              'shop_fid',
              'shop_goods_list_json',

              'use_coupon_fid',

              'want_arrive_time',
              'is_book',

              'weather_type',

              'tableware_quantity',
              'taste_tags',
              'memo',
              'is_used_score',
              'used_score',
              'is_only_pay_delivery_fee',
              'is_used_straight_line_distance'
              ],
              [AppID,
              GlobalManager.User.fid,
              GlobalManager.User.key,

              //配送方式
              FDelivery_Type,

              //用户收货地址
              Self.FUserRecvAddr.longitude, //'120.496104',//
              Self.FUserRecvAddr.latitude,  //'30.103408',//
              FUserRecvAddr.name,
              FUserRecvAddr.sex,
              FUserRecvAddr.phone,
              FUserRecvAddr.province,
              FUserRecvAddr.city,
              FUserRecvAddr.area,
              FUserRecvAddr.addr,
              '',//FUserRecvAddr.door_no,



              //商家
              Self.FCarShop.fid,
              //所选商家商品
              Self.GetCartShopGoodsListJson.AsJSON,

              0,//FUserCouponFID,//所使用的红包

              Self.FWant_Arrived_Time,//想要送达时间
              Self.FIs_Book,//是否是预订单

              GlobalManager.WeatherType,//天气类型

              0,//Self.btnSelectTablewareQuantity.Tag,
              '',
              Self.memRemark.Text,
              Ord(Self.rbUseScore.Prop.Checked),
              FScoreUnit*ATempScoreMoney,
              ATempIsOnlyPayDeliveryFee,
              '1'
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

procedure TFrameTakeOrder.DoTakeOrderExecuteEnd(ATimerTask: TObject);
var
  AOrder:TOrder;
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin


          //下单成功,跳转到付款页面
          AOrder:=TOrder.Create;
          try
            AOrder.ParseFromJson(ASuperObject.O['Data'].A['OrderInfo'].O[0]);

            //界面上改过来
//            AOrder.sum_money:=StrToFloat(Self.lblSumMoney.Prop.Items[2].Text);

//            //隐藏
//            HideFrame;//(Self,hfcttBeforeShowFrame);
//
//            //付款
//            ShowFrame(TFrame(GlobalPayOrderFrame),TFramePayOrder,frmMain,nil,nil,nil,Application);
////            GlobalPayOrderFrame.FrameHistroy:=CurrentFrameHistroy;
//            GlobalPayOrderFrame.Load(AOrder,True);



            //跳转到支付页面
            HideFrame(Self);
            ShowFrame(TFrame(GlobalPayOrderCommonFrame),TFramePayOrderCommon);
            GlobalPayOrderCommonFrame.Load(AOrder.fid,
                                           Const_OrderType_ShopCenter,
                                           AOrder.sum_money,
                                           '',
                                           '订单支付',
                                           AOrder.bill_code,
                                           True,
                                           False);



            GlobalMainFrame.UpDateMyCar;


          finally
            FreeAndNil(AOrder);
          end;


      end
      else
      begin
        //下单失败
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

procedure TFrameTakeOrder.DoVirtualKeyboardHide(KeyboardVisible: Boolean;
  const Bounds: TRect);
begin
  Self.pnlBottomBar.Visible:=True;
end;

procedure TFrameTakeOrder.DoVirtualKeyboardShow(KeyboardVisible: Boolean;
  const Bounds: TRect);
begin
  Self.pnlBottomBar.Visible:=False;
end;

function TFrameTakeOrder.GetCurrentPorcessControl(AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

procedure TFrameTakeOrder.GetUserSuitRecvAddrList;
begin
  FMX.Types.Log.d('OrangeUI GetUserSuitRecvAddrList');
  ShowWaitingFrame(Self,'加载中...');
  //设置好默认的收货地址
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                   DoGetRecvAddrListExecute,
                   DoGetRecvAddrListExecuteEnd,
                   'GetRecvAddrList');

end;

function TFrameTakeOrder.GetCartShopGoodsListJson: ISuperArray;
var
  I: Integer;
begin
  Result:=TSuperArray.Create();

  //测试
//  for I := 0 to 0 do
//  begin
//    Result.O[I].I['shop_fid']:=4;//王能的早餐店
//    Result.O[I].I['shop_goods_fid']:=16;//油条
//    Result.O[I].I['shop_goods_spec_fid']:=44;
//    Result.O[I].S['shop_goods_attrs']:='';
//    Result.O[I].I['number']:=2;
//  end;

  for I := 0 to Self.FCarShop.FCarGoodList.Count-1 do
  begin
    Result.O[I].I['shop_fid']:=Self.FCarShop.FCarGoodList[I].shop_fid;//王能的早餐店
    Result.O[I].I['shop_goods_fid']:=Self.FCarShop.FCarGoodList[I].shop_goods_fid;//油条
    Result.O[I].I['shop_goods_spec_fid']:=Self.FCarShop.FCarGoodList[I].shop_goods_spec_fid;
    Result.O[I].S['shop_goods_attrs']:=Self.FCarShop.FCarGoodList[I].shop_goods_attrs;
    Result.O[I].I['number']:=Self.FCarShop.FCarGoodList[I].number;
    Result.O[I].F['orderno']:=I;
  end;

end;

function TFrameTakeOrder.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

function TFrameTakeOrder.GetVirtualKeyboardHeightAdjustHeight: Double;
begin
  Result:=0;
end;

procedure TFrameTakeOrder.lbOrderFeesPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
  if (Self.FDelivery_Type=Const_DeliverType_NeedDeliver)
  OR (Self.FDelivery_Type=Const_DeliverType_Express) then
  begin
    if (AItem.Caption='配送费')
    OR (AItem.Caption='邮费') then
    begin
      Self.btnLook.Visible:=True;
    end
    else
    begin
      Self.btnLook.Visible:=False;
    end;
  end
  else
  begin
    Self.btnLook.Visible:=False;
  end;
end;

procedure TFrameTakeOrder.DoGetRecvAddrListExecute(
  ATimerTask: TObject);
begin
  FMX.Types.Log.d('OrangeUI DoGetRecvAddrListExecute');
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_user_recv_addr_list',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
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

procedure TFrameTakeOrder.DoGetRecvAddrListExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ARecvAddr:TUserRecvAddr;
  ARecvAddrList:TUserRecvAddrList;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

      FMX.Types.Log.d('OrangeUI DoGetRecvAddrListExecuteEnd  AJosn '+ASuperObject.AsJSON);

      if ASuperObject.I['Code']=200 then
      begin
            FMX.Types.Log.d('OrangeUI DoGetRecvAddrListExecuteEnd  Code:200');

            //获取用户收货地址列表成功
            ARecvAddrList:=TUserRecvAddrList.Create();
            ARecvAddrList.ParseFromJsonArray(TUserRecvAddr,ASuperObject.O['Data'].A['UserRecvAddrList']);
            FMX.Types.Log.d('OrangeUI DoGetRecvAddrListExecuteEnd  ARecvAddrList'+IntToStr(ARecvAddrList.Count));

            try

              ARecvAddr:=nil;
//              //如果只有一个地址就显示为默认地址
//              if ARecvAddrList.Count=1 then
//              begin
//                ARecvAddr:=ARecvAddrList[0];
//              end
//              else
//              begin
//                  if GlobalGPSLocation<>nil then
//                  begin
//                      //默认取一个在商家的配送范围，且离我的位置最近的收货地址
//                      ARecvAddr:=ARecvAddrList.GetNearestRecvAddr(
//                                      FCarShop.longitude,
//                                      FCarShop.latitude,
//                                      FCarShop.deliver_max_distance,
//                                      GlobalGPSLocation.Longitude,
//                                      GlobalGPSLocation.Latitude
//                                      );
//                  end;
//              end;
              if ARecvAddrList.Count>0 then
              begin
                ARecvAddr:=ARecvAddrList[0];
              end;

              FMX.Types.Log.d('OrangeUI DoGetRecvAddrListExecuteEnd  ARecvAddr');

              if ARecvAddr<>nil then
              begin
                Self.FUserRecvAddr.Assign(ARecvAddr);

                LoadUserRecvAddToUI(FUserRecvAddr);
              end
              else
              begin
                FMX.Types.Log.d('OrangeUI DoGetRecvAddrListExecuteEnd  ClearUserRecvAddr');

                Self.ClearUserRecvAddr;
    //            ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);

              end;

              PrepareOrder;

            finally
              FreeAndNil(ARecvAddrList);
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
    HideWaitingFrame;
  end;
end;

procedure TFrameTakeOrder.OnReturnDeliveryTimeFrame(AFrame:TFrame);
begin

  Self.FWant_Arrived_Time:=GlobalBookableOrderTimeFrame.FDateTime+' '+GlobalBookableOrderTimeFrame.FSelectedDetail+':00';

  if (FormatDateTime('YYYY-MM-DD',IncMinute(Now,Self.FDelivery_Time+Self.FCarShop.make_food_spent))=GlobalBookableOrderTimeFrame.FDateTime)
    and (FormatDateTime('HH:MM',IncMinute(Now,Self.FDelivery_Time+Self.FCarShop.make_food_spent))=GlobalBookableOrderTimeFrame.FSelectedDetail) then
  begin
    Self.btnTime.Caption:='预计时间('+GlobalBookableOrderTimeFrame.FSelectedDetail+')';
    FIs_Book:=0;
  end
  else
  begin
    Self.btnTime.Caption:=GlobalBookableOrderTimeFrame.FSelectedCaption+' '+GlobalBookableOrderTimeFrame.FSelectedDetail;
    FIs_Book:=1;
  end;
end;

procedure TFrameTakeOrder.OnReturnFrameFromSelectRecvAddr(Frame:TFrame);
begin
  //选择收货地址返回
  if GlobalRecvAddrListFrame.FSelectedRecvAddr<>nil then
  begin
    Self.FUserRecvAddr.Assign(GlobalRecvAddrListFrame.FSelectedRecvAddr);
    LoadUserRecvAddToUI(FUserRecvAddr);

    Self.FLongitude:=FUserRecvAddr.longitude;
    Self.FLatitude:=FUserRecvAddr.latitude;
    //收货地址变了,距离也就变了
    //重新预下单
    PrepareOrder;
  end
  else
  begin
    Self.ClearUserRecvAddr;
  end;
end;

procedure TFrameTakeOrder.OnReturnFromSelectedCouponFrame(AFrame: TFrame);
begin
  if GlobalTakeOrderUseCouponListFrame.FDescMoney<>0 then
  begin
    Self.btnSelectUserCoupon.Caption:='¥-'+Format('%.2f',[GlobalTakeOrderUseCouponListFrame.FDescMoney]);
  end;

  Self.FCouponFID:=GlobalTakeOrderUseCouponListFrame.FCouponFID;

  //刷新
  Self.PrepareOrder;
end;

procedure TFrameTakeOrder.PrepareOrder;
begin
  FMX.Types.Log.d('OrangeUI PrepareOrder');
  ShowWaitingFrame(Self,'加载中...');
  GetGlobalTimerThread.RunTempTask(
        Self.DoPrepareOrderExecute,
        Self.DoPrepareOrderExecuteEnd,
        'PrepareOrder'
        );
end;

procedure TFrameTakeOrder.rbUseScoreClick(Sender: TObject);
begin
  Self.rbUseScore.Prop.Checked:=Not Self.rbUseScore.Prop.Checked;
  //是否选中  影响付款价格
  if (StrToFloat(Self.mcUserScore.Prop.Items[3].Text)>0) then
  begin
    Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
      Self.lblSubTotal.Prop.ColorTextCollection.ItemByName['SubTotal'].Text;
    if Self.rbUseScore.Prop.Checked then
    begin
      Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
      Format('%.2f',[StrToFloat(Self.lblSubTotal.Prop.ColorTextCollection.ItemByName['SubTotal'].Text)-StrToFloat(Self.mcUserScore.Prop.Items[3].Text)]);
    end;
  end;
end;

procedure TFrameTakeOrder.SyncDeliverTypeSelection;
begin

  //配送方式
  if (FCarShop<>nil) and IsTakeAwayFoodShop(Self.FCarShop) then
  begin

      if FDelivery_Type=Const_DeliverType_NeedDeliver then
      begin
    //      //需要配送
    //      Self.pnlRecvAddr.Visible:=True;
    //      //选择默认的收货地址
    //      //原来的
    //      Self.pnlRecvAddr.Position.Y:=Self.pnlSelectDeliverType.Position.Y+Self.pnlSelectDeliverType.Height;

          Self.pnlRecvAddr.Position.Y:=Self.pnlArriveTime.Position.Y+Self.pnlArriveTime.Height;


          Self.pnlArriveTime.Caption:='预计到达时间';
      end
      else
      begin
    //      //不需要配送,不需要收货地址
    //      Self.pnlRecvAddr.Visible:=False;
    //      Self.ClearUserRecvAddr;

          if FDelivery_Type=Const_DeliverType_SelfTake then
          begin
            Self.pnlArriveTime.Caption:='自取时间';
          end
          else
          begin
            Self.pnlArriveTime.Caption:='堂食时间';
          end;
      end;

  end;






end;

procedure TFrameTakeOrder.SyncSummary;
var
  ASumMoney:Double;
begin
//  if TryStrToFloat(Self.edtReduce.Text,FReduce) then
//  begin
//    //订单总金额=商品总金额-减免
//    ASumMoney:=StrToFloat(Self.lblGoodsSumMoney.Text)-FReduce;
//
//    Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
//      Format('%.2f',[ASumMoney]);
//  end;

end;

//procedure TFrameTakeOrder.OnFirstOrderMessageBoxModalResult(Sender: TObject);
//begin
//
//end;

procedure TFrameTakeOrder.OnModalResultFromLeaveOrder(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='确定' then
  begin

    if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;


    //返回
    HideFrame;//(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);

  end;
  if TFrameMessageBox(Frame).ModalResult='取消' then
  begin
    //留在酒店信息页面
  end;
end;

procedure TFrameTakeOrder.btnReturnClick(Sender: TObject);
begin
  ShowMessageBoxFrame(Self,
                      '是否放弃此订单?',
                      '',
                      TMsgDlgType.mtInformation,
                      ['确定','取消'],
                      OnModalResultFromLeaveOrder);
end;

procedure TFrameTakeOrder.btnSelectDeliverTypeClick(Sender: TObject);
begin
  if (Self.FCarShop.is_can_takeorder_but_only_self_take=1)
  AND (Self.FCarShop.is_can_takeorder_and_delivery=1)
  AND (Self.FCarShop.is_can_takeorder_but_only_eat_in_shop=1) then
  begin
    //请选择配送方式
    ShowFrame(TFrame(GlobalPopupMenuFrame),TFramePopupMenu,frmMain,nil,nil,DoSelectDeliverTypeFromPopupMenuFrame,Application,True,True,ufsefNone);
    GlobalPopupMenuFrame.Init('请选择用餐方式',Const_DeliverType_Caption,Const_DeliverType_Names);
  end
  else if (Self.FCarShop.is_can_takeorder_but_only_self_take=0)
  AND (Self.FCarShop.is_can_takeorder_and_delivery=1)
  AND (Self.FCarShop.is_can_takeorder_but_only_eat_in_shop=1) then
  begin
    //请选择配送方式
    ShowFrame(TFrame(GlobalPopupMenuFrame),TFramePopupMenu,frmMain,nil,nil,DoSelectDeliverTypeFromPopupMenuFrame,Application,True,True,ufsefNone);
    GlobalPopupMenuFrame.Init('请选择用餐方式',Const_DeliverType2_Caption,Const_DeliverType2_Names);
  end
  else if (Self.FCarShop.is_can_takeorder_but_only_self_take=1)
  AND (Self.FCarShop.is_can_takeorder_and_delivery=1)
  AND (Self.FCarShop.is_can_takeorder_but_only_eat_in_shop=0) then
  begin
    //请选择配送方式
    ShowFrame(TFrame(GlobalPopupMenuFrame),TFramePopupMenu,frmMain,nil,nil,DoSelectDeliverTypeFromPopupMenuFrame,Application,True,True,ufsefNone);
    GlobalPopupMenuFrame.Init('请选择用餐方式',Const_DeliverType1_Caption,Const_DeliverType1_Names);
  end
  else if (Self.FCarShop.is_can_takeorder_but_only_self_take=1)
  AND (Self.FCarShop.is_can_takeorder_and_delivery=0)
  AND (Self.FCarShop.is_can_takeorder_but_only_eat_in_shop=1) then
  begin
    //请选择配送方式
    ShowFrame(TFrame(GlobalPopupMenuFrame),TFramePopupMenu,frmMain,nil,nil,DoSelectDeliverTypeFromPopupMenuFrame,Application,True,True,ufsefNone);
    GlobalPopupMenuFrame.Init('请选择用餐方式',Const_No_DeliverType_Caption,Const_No_DeliverType_Names);
  end
  else if (Self.FCarShop.is_can_takeorder_but_only_self_take=1)
  AND (Self.FCarShop.is_can_takeorder_and_delivery=0)
  AND (Self.FCarShop.is_can_takeorder_but_only_eat_in_shop=0) then
  begin
    ShowMessageBoxFrame(Self,'商家只能自取!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end
  else if (Self.FCarShop.is_can_takeorder_but_only_self_take=0)
  AND (Self.FCarShop.is_can_takeorder_and_delivery=0)
  AND (Self.FCarShop.is_can_takeorder_but_only_eat_in_shop=1) then
  begin
    ShowMessageBoxFrame(Self,'商家只能堂食!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end
  else if (Self.FCarShop.is_can_takeorder_but_only_self_take=0)
  AND (Self.FCarShop.is_can_takeorder_and_delivery=1)
  AND (Self.FCarShop.is_can_takeorder_but_only_eat_in_shop=0) then
  begin
    ShowMessageBoxFrame(Self,'商家只能配送!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
end;

procedure TFrameTakeOrder.btnSelectUserCouponClick(Sender: TObject);
begin
  //如果有红包,选择红包

  if Self.btnSelectUserCoupon.Caption<>'没有可用红包' then
  begin
     //隐藏
     HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
     //显示个人信息页面
     ShowFrame(TFrame(GlobalTakeOrderUseCouponListFrame),TFrameTakeOrderUseCouponList,frmMain,nil,nil,OnReturnFromSelectedCouponFrame,Application);
//     GlobalTakeOrderUseCouponListFrame.FrameHistroy:=CurrentFrameHistroy;
     GlobalTakeOrderUseCouponListFrame.Clear;
     GlobalTakeOrderUseCouponListFrame.Init(FCouponList,FUserCouponFID);
  end;

end;

procedure TFrameTakeOrder.btnSelectUserCouponStayClick(Sender: TObject);
begin
//  //选择酒店
//  //隐藏
//  HideFrame;//(Self,hfcttBeforeShowFrame);
//
//  //选择酒店
//  ShowFrame(TFrame(GlobalHotelListFrame),TFrameHotelList,frmMain,nil,nil,OnReturnFrameFromSelectHotel,Application);
//  GlobalHotelListFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalHotelListFrame.Load('选择酒店',
//                              futSelectList,
//                              IntToStr(FSelectedManagerFID),
//                              IntToStr(Ord(asAuditPass)),
//                              FSelectedHotelFID,
//                              True,
//                              '',
//                              0,
//                              '');
//
end;

procedure TFrameTakeOrder.btnTimeClick(Sender: TObject);
begin
  if ((Self.FUserRecvAddr.name='')
    or (Self.FUserRecvAddr.phone='')
    or (Self.FUserRecvAddr.addr='') )
    and (Self.btnSelectDeliverType.Caption='需要配送')
     then
  begin
    ShowMessageBoxFrame(Self,'请选择收货地址!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end
  else
  begin

    if Self.FCarShop.is_bookable=1 then
    begin
      //送达时间
      ShowFrame(TFrame(GlobalBookableOrderTimeFrame),TFrameBookableOrderTime,frmMain,nil,nil,OnReturnDeliveryTimeFrame,Application,True,False,ufsefNone);
      GlobalBookableOrderTimeFrame.Init(Self.FCarShop.can_book_days,
                                        Self.FDelivery_Time,
                                        Self.FWant_Arrived_Time,
                                        Self.FCarShop.mon_is_sale,
                                        Self.FCarShop.mon_start_time,
                                        Self.FCarShop.mon_end_time,
                                        Self.FCarShop.tues_is_sale,
                                        Self.FCarShop.tues_start_time,
                                        Self.FCarShop.tues_end_time,
                                        Self.FCarShop.wed_is_sale,
                                        Self.FCarShop.wed_start_time,
                                        Self.FCarShop.wed_end_time,
                                        Self.FCarShop.thur_is_sale,
                                        Self.FCarShop.thur_start_time,
                                        Self.FCarShop.thur_end_time,
                                        Self.FCarShop.fri_is_sale,
                                        Self.FCarShop.fri_start_time,
                                        Self.FCarShop.fri_end_time,
                                        Self.FCarShop.sat_is_sale,
                                        Self.FCarShop.sat_start_time,
                                        Self.FCarShop.sat_end_time,
                                        Self.FCarShop.sun_is_sale,
                                        Self.FCarShop.sun_start_time,
                                        Self.FCarShop.sun_end_time
                                        );
    end
    else
    begin
      ShowMessageBoxFrame(Self,'该商家不接受预定!','',TMsgDlgType.mtInformation,['确定'],nil);
      Exit;
    end;

  end;
end;

procedure TFrameTakeOrder.btnSelectRecvAddrClick(Sender: TObject);
begin
  //选择收货地址
  HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalRecvAddrListFrame),TFrameRecvAddrList,frmMain,nil,nil,OnReturnFrameFromSelectRecvAddr,Application);
//  GlobalRecvAddrListFrame.FrameHistroy:=CurrentFrameHistroy;

  GlobalRecvAddrListFrame.Load('选择收货地址',
                                futSelectList,
                                FUserRecvAddr.fid);

end;

procedure TFrameTakeOrder.btnSelectTablewareQuantityClick(Sender: TObject);
begin
  //请选择餐具份数
  ShowFrame(TFrame(GlobalPopupMenuFrame),TFramePopupMenu,frmMain,nil,nil,DoSelectTablewareQuantityFromPopupMenuFrame,Application,True,True,ufsefNone);
  GlobalPopupMenuFrame.Init('请选择用餐人数',
    ['无需餐具','1人','2人','3人','4人','5人','6人']);

end;

//procedure TFrameTakeOrder.LoadBuyGoodsList(AShop:TShop;ABuyGoodsList:TBuyGoodsList);
//var
//  I: Integer;
//  ASumMoney:Double;
//  ASumNumber:Integer;
//  ABuyGoods:TBuyGoods;
//  AListBoxItem:TSkinListBoxItem;
//begin
//
//  //加载商品列表
//  Self.lbOrderFees.Prop.Items.BeginUpdate;
//  try
//
//    Self.FBuyGoodsList.Clear(True);
//    Self.lbOrderFees.Prop.Items.Clear(True);
//
//
//    //总金额
//    ASumMoney:=0;
//    ASumNumber:=0;
//    for I := 0 to ABuyGoodsList.Count-1 do
//    begin
//      ABuyGoods:=TBuyGoods(ABuyGoodsList[I].ClassType.Create);
//      ABuyGoods.Assign(ABuyGoodsList[I]);
//      FBuyGoodsList.Add(ABuyGoods);
//
//      ASumMoney:=ASumMoney+ABuyGoods.number*ABuyGoods.price;
//      ASumNumber:=ASumNumber+ABuyGoods.number;
//
//      AListBoxItem:=Self.lbOrderFees.Prop.Items.Add;
//      AListBoxItem.Data:=ABuyGoods;
//
//      AListBoxItem.Icon.Url:=ABuyGoods.GetPic1Url;
//    end;
//
//  finally
//    Self.lbOrderFees.Prop.Items.EndUpdate();
//  end;
//
//
//
//  //总金额根据商品来计算
//  Self.lblGoodsSumMoney.Text:=
//    Format('%.2f',[ASumMoney]);
//
//  Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
//    Format('%.2f',[ASumMoney]);
//
//  Self.btnViewBuyGoodsList.Caption:='共'+IntToStr(FBuyGoodsList.Count)+'种'
//                                    +IntToStr(ASumNumber)+'个商品';
//
//
//end;

procedure TFrameTakeOrder.LoadUserRecvAddToUI(AUserRecvAdd:TUserRecvAddr);
begin
  if AUserRecvAdd<>nil then
  begin
    Self.lblRecvName.Caption:=AUserRecvAdd.name;
    Self.lblRecvPhone.Caption:=AUserRecvAdd.phone;
    Self.lblRecvAddr.Caption:=AUserRecvAdd.addr;

    Self.FLongitude:=AUserRecvAdd.longitude;
    Self.FLatitude:=AUserRecvAdd.latitude;
  end;
end;

//procedure TFrameTakeOrder.LoadOrder(AOrder: TOrder);
//begin
//  FOrder:=AOrder;
//
//
//  //订单的酒店经理
//  Self.FSelectedManagerFID:=AOrder.user_fid;
//  Self.btnSelectManager.Caption:=AOrder.user_name;
//
//  //订单的酒店
//  Self.FSelectedHotelFID:=AOrder.hotel_fid;
//  Self.btnSelectHotel.Caption:=AOrder.hotel_name;
//
//
//  //收货地址
//  Self.FUserRecvAddr.name:=AOrder.recv_name;
//  Self.FUserRecvAddr.phone:=AOrder.recv_phone;
//  Self.FUserRecvAddr.province:=AOrder.recv_province;
//  Self.FUserRecvAddr.city:=AOrder.recv_city;
//  Self.FUserRecvAddr.area:=AOrder.recv_area;
//  Self.FUserRecvAddr.addr:=AOrder.recv_addr;
//  Self.LoadUserRecvAddToUI(FUserRecvAddr);
//
//  //备注
//  Self.memRemark.Text:=AOrder.remark;
//
//  //减免金额
//  Self.edtReduce.Text:=Format('%.2f',[AOrder.reduce]);
//
//
//  //加载订单商品列表
//  LoadBuyGoodsList(AOrder.OrderGoodsList);
//
//
//  Self.SyncSummary;
//
//end;

procedure TFrameTakeOrder.AddOrder(ACarShop:TCarShop;
                                   AIsNeedPostingFee:Integer=0;
                                   AShopDeliverType:Integer=2;
                                   AIsPayGoodsMoneyOnline:Integer=0;
                                   AIsPlatFormShop:Integer=0;
                                   AMinPostingPrice:Double=0); //0  不包邮
begin
  Clear;

  Self.pnlToolBar.Caption:='确认下单';

  //商店
  FCarShop:=ACarShop;

  //店铺名称
  Self.lblShopName.Caption:=FCarShop.name;

  FMX.Types.Log.d('OrangeUI 确认下单');

  Self.FIsPayGoodsMoneyOnline:=AIsPayGoodsMoneyOnline;
  Self.FIsPlatFormShop:=AIsPlatFormShop;

  Self.FShopDeliverType:=AShopDeliverType;

  Self.FMinPostingPrice:=AMinPostingPrice;
  Self.FIsNeedPostingFee:=AIsNeedPostingFee;

  //从购物车界面过来
  Self.FIsPayGoodsMoneyOnline:=1;
  if FCarShop.is_platform_shop=1 then
  begin
//    Self.FIsPayGoodsMoneyOnline:=1;
    Self.FIsPlatFormShop:=FCarShop.is_platform_shop;
    Self.FShopDeliverType:=3;
    Self.FMinPostingPrice:=FCarShop.min_posting_price;
    Self.FIsNeedPostingFee:=FCarShop.is_need_posting_price;
  end;

  Self.SkinFMXLabel1.Caption:='1.商品费用需在线支付.';//+#13#10
//                             +'2.当前商家购物满'+Format('%.2f',[FMinPostingPrice])+'元免配送费.';
//                             +'2.若您购买的商品无质量问题，退货时，您将承担来回邮费!';
  if (FIsPayGoodsMoneyOnline=1)
  AND (FShopDeliverType=Ord(dtPosting)) then
  begin
    //包邮
    if FIsNeedPostingFee=1 then
    begin
      Self.SkinFMXLabel1.Caption:='1.当前商家购物满'+Format('%.2f',[FMinPostingPrice])+'元包邮.'+#13#10
                                 +'2.若您购买的商品无质量问题，退货时，您将承担来回邮费!';
    end
    else
    begin
      Self.SkinFMXLabel1.Caption:='1.当前商家购物不包邮.'+#13#10
                                 +'2.若您购买的商品无质量问题，退货时，您将承担来回邮费!';
    end;
  end;

  //平台商家   快递方式  不显示预计到达时间
  Self.pnlArriveTime.Visible:=True;
  if FShopDeliverType=Ord(dtPosting) then
//  if AIsPlatFormShop=1 then
  begin
    Self.pnlArriveTime.Visible:=False;
  end;

  //默认选择需要配送
  if ACarShop.is_can_takeorder_and_delivery=1 then
  begin
    Self.btnSelectDeliverType.Caption:=Const_DeliverType_Caption[0];
    FDelivery_Type:=Const_DeliverType_Names[0];
    Self.pnlArriveTime.Caption:='预计送达时间';
  end
  else
  begin

    Self.btnSelectDeliverType.Caption:=Const_No_DeliverType_Caption[0];
    FDelivery_Type:=Const_No_DeliverType_Names[0];

    Self.pnlArriveTime.Caption:='自取时间';
  end;
  Self.SyncDeliverTypeSelection;

  Self.btnSelectDeliverType.Tag:=0;
  Self.SyncDeliverTypeSelection;

  FMX.Types.Log.d('OrangeUI 地址');

  //获取合适的收货地址列表
  GetUserSuitRecvAddrList;


  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);

end;

procedure TFrameTakeOrder.AlignControls;
begin
  //费用列表
  Self.pnlOrderFees.Height:=
    Self.pnlShopName.Height
    +Self.lbOrderFees.Prop.GetContentHeight;


  SetSuitScrollContentHeight(sbcClient);

end;

procedure TFrameTakeOrder.btnLookClick(Sender: TObject);
var
  AResult:String;
  AText:String;
begin

  AResult:='';

  if FDelivery_Type=Const_DeliverType_Names[0] then
  begin
    if (Self.FUserRecvAddr.name='')
      or (Self.FUserRecvAddr.phone='')
      or (Self.FUserRecvAddr.addr='') then
    begin
      ShowMessageBoxFrame(Self,'请选择收货地址!','',TMsgDlgType.mtInformation,['确定'],nil);
      Exit;
    end
    else
    begin
      AResult:=GetFeeCountString(FDistance_free,
                                 FWeather_free,
                                 FWeight_free,
                                 FTime_free,
                                 FBasic_free,
                                 FVolum_free);
      if AResult<>'' then
      begin
        //显示配送费的计算
        ShowMessageBoxFrame(Self,AResult,'',TMsgDlgType.mtInformation,['确定'],nil);
        Exit;
      end
      else
      begin
        //没有配送费
        AText:='没有配送费用';
        if FShopDeliverType=Ord(dtPosting) then  AText:='没有邮费';
        ShowMessageBoxFrame(Self,AText,'',TMsgDlgType.mtInformation,['确定'],nil);
        Exit;
      end;
    end;
  end;

end;

procedure TFrameTakeOrder.btnOKClick(Sender: TObject);
begin
  HideVirtualKeyboard;



//  if Self.FBuyGoodsList.Count=0 then
//  begin
//    ShowMessageBoxFrame(Self,'请选择商品!','',TMsgDlgType.mtInformation,['确定'],nil);
//    Exit;
//  end;

//  if FSelectedManagerFID=0 then
//  begin
//    ShowMessageBoxFrame(Self,'请选择酒店经理!','',TMsgDlgType.mtInformation,['确定'],nil);
//    Exit;
//  end;
//
//  if FSelectedHotelFID=0 then
//  begin
//    ShowMessageBoxFrame(Self,'请选择酒店!','',TMsgDlgType.mtInformation,['确定'],nil);
//    Exit;
//  end;

  if FDelivery_Type=Const_DeliverType_Names[0] then
  begin
    if (Self.FUserRecvAddr.name='')
      or (Self.FUserRecvAddr.phone='')
      or (Self.FUserRecvAddr.addr='') then
    begin
      ShowMessageBoxFrame(Self,'请选择收货地址!','',TMsgDlgType.mtInformation,['确定'],nil);
      Exit;
    end;
  end;

  ShowWaitingFrame(Self,'提交中...');
//
//  if FOrder=nil then
//  begin


    //下单
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                 DoTakeOrderExecute,
                                 DoTakeOrderExecuteEnd,
                                 'TakeOrder');


//  end
//  else
//  begin
//    //修改订单
//    uTimerTask.GetGlobalTimerThread.RunTempTask(
//                                 DoUpdateOrderExecute,
//                                 DoUpdateOrderExecuteEnd);
//  end;

end;

procedure TFrameTakeOrder.DoPrepareOrderExecute(ATimerTask: TObject);
var
  ANeedPayGoodsFee:String;
begin
   FMX.Types.Log.d('OrangeUI DoPrepareOrderExecute FLongitude'+FloatToStr(FLongitude));
   FMX.Types.Log.d('OrangeUI DoPrepareOrderExecute FLatitude'+FloatToStr(FLatitude));
   ANeedPayGoodsFee:='0';
   if FIsPayGoodsMoneyOnline=1 then
   begin
     ANeedPayGoodsFee:='1';
   end;

  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
              SimpleCallAPI('prepare_order',
              nil,
              ShopCenterInterfaceUrl,
              [
              'appid',
              'user_fid',
              'key',

              'deliver_type',
              'recv_longitude',
              'recv_latitude',

              'shop_fid',
              'shop_goods_list_json',

              'use_coupon_fid',

              'want_arrive_time',
              'is_book',

              'weather_type',
              'is_used_score',

//              ,'is_only_pay_delivery_fee'
              'is_used_straight_line_distance'
              ],
              [AppID,
              GlobalManager.User.fid,
              GlobalManager.User.key,

              //配送方式
              FDelivery_Type,
              //用户收货地址
              FLongitude,   //
              FLatitude,    // 测试模拟地址

              //商家
              Self.FCarShop.fid,
              //所选商家商品
              Self.GetCartShopGoodsListJson.AsJSON,

              FCouponFID,
              FWant_Arrived_Time,
              Self.FIs_Book,

              GlobalManager.WeatherType,
              1,
              '1'
//              ,ANeedPayGoodsFee
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

procedure TFrameTakeOrder.DoPrepareOrderExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AOrderFeeJson:ISuperObject;
  AListBoxItem:TSkinListBoxItem;
  ACouponList:TCouponList;
  g: Integer;
  f: Integer;
  ACouponDecMoney:Double;
  AUsefulNum:Integer;
  ADeliveryMoney:String;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

      FMX.Types.Log.d('OrangeUI DoPrepareOrderExecuteEnd AJSON'+ASuperObject.AsJSON);

      if ASuperObject.I['Code']=200 then
      begin
          ACouponDecMoney:=0;
          //预下单成功
          //加载费用列表
          Self.lbOrderFees.Prop.Items.BeginUpdate;
          try
            Self.lbOrderFees.Prop.Items.Clear(True);
            for I := 0 to ASuperObject.O['Data'].A['OrderFees'].Length-1 do
            begin
              AOrderFeeJson:=ASuperObject.O['Data'].A['OrderFees'].O[I];
              //是否红包
              if AOrderFeeJson.S['fee_type']<>'coupon_dec' then
              begin
                //亿诚生活加的判断  不显示积分   包装费
                if (AOrderFeeJson.S['fee_type']<>'user_score')
                AND (AOrderFeeJson.S['name']<>'包装费')then
                begin

                  AListBoxItem:=Self.lbOrderFees.Prop.Items.Add;
                  AListBoxItem.Caption:=AOrderFeeJson.S['name'];

                  //记下配送费
                  ADeliveryMoney:='0';
                  if AOrderFeeJson.S['name']='配送费' then
                  begin
                    ADeliveryMoney:=Format('%.2f',[GetJsonDoubleValue(AOrderFeeJson,'money')]);
                    //平台商家 叫邮费    快递方式
//                    if FIsPlatFormShop=1 then AListBoxItem.Caption:='邮费';
                    if FShopDeliverType=Ord(dtPosting)  then AListBoxItem.Caption:='邮费';
                  end;

                  //金额
                  AListBoxItem.Detail:='¥'+Format('%.2f',[GetJsonDoubleValue(AOrderFeeJson,'money')]);
                  if
                      //减免
                      (GetJsonDoubleValue(AOrderFeeJson,'money')<0)
                      //原价和现价不一样
                    or AOrderFeeJson.Contains('origin_money')
                        and IsNotSameDouble(GetJsonDoubleValue(AOrderFeeJson,'money'),
                                            GetJsonDoubleValue(AOrderFeeJson,'origin_money'))
                     then
                  begin
                    AListBoxItem.Color:=$FFFB3437;
                  end;
                  if AOrderFeeJson.S['fee_type']=Const_FeeType_GoodsMoney then
                  begin
                    //数量
                    AListBoxItem.Detail1:='x'+IntToStr(AOrderFeeJson.I['num']);
                  end;
                  //费用描述
                  AListBoxItem.Detail2:='';//AOrderFeeJson.S['fee_desc'];
                  AListBoxItem.Height:=30;
//                  if AOrderFeeJson.S['fee_desc']<>'' then
//                  begin
//                    AListBoxItem.Height:=55;
//                  end;
                end;
              end
              else
              begin
                ACouponDecMoney:=GetJsonDoubleValue(AOrderFeeJson,'money');
                FUserCouponFID:=AOrderFeeJson.I['user_coupon_fid'];
              end;

              //亿诚生活
              Self.mcUserScore.Prop.Items[0].Text:='';
              Self.mcUserScore.Prop.Items[1].Text:='没有可用积分';
              Self.mcUserScore.Prop.Items[2].Text:='';
              Self.mcUserScore.Prop.Items[3].Text:='';
              Self.mcUserScore.Prop.Items[4].Text:='';
              Self.rbUseScore.Visible:=False;
              Self.rbUseScore.Prop.Checked:=False;
              Self.mcUserScore.SelfOwnMaterialToDefault.DrawCaptionParam.DrawRectSetting.Enabled:=True;
              if (AOrderFeeJson.S['fee_type']='user_score')
              AND (AOrderFeeJson.F['money']<>0) then
              begin
                //积分兑换比列
                FScoreUnit:=AOrderFeeJson.F['unit'];

                Self.mcUserScore.Prop.Items[0].Text:='共有';
                Self.mcUserScore.Prop.Items[1].Text:=Format('%.2f',[AOrderFeeJson.F['score']]);
                Self.mcUserScore.Prop.Items[2].Text:='积分  本单可抵用';

                Self.mcUserScore.Prop.Items[3].Text:=Format('%.2f',[AOrderFeeJson.F['money']]);
                //积分抵扣大于配送费    订单金额  ASuperObject.O['Data'].F['sum_money']
                if AOrderFeeJson.F['money']>StrToFloat(ADeliveryMoney) then
                  Self.mcUserScore.Prop.Items[3].Text:=ADeliveryMoney;//Format('%.2f',[ASuperObject.O['Data'].F['sum_money']]);
                if Self.FIsPayGoodsMoneyOnline=1 then
                begin
                  //积分抵扣大于配送费    订单金额  ASuperObject.O['Data'].F['sum_money']   改为抵扣一半  cut_part比例服务端返回
//                  if AOrderFeeJson.F['money']>=ASuperObject.O['Data'].F['sum_money'] then
                  Self.mcUserScore.Prop.Items[3].Text:=Format('%.2f',[ASuperObject.O['Data'].F['sum_money']
                                                                      *AOrderFeeJson.F['cut_part']]);
                  if ASuperObject.O['Data'].F['sum_money']*AOrderFeeJson.F['cut_part']>AOrderFeeJson.F['money'] then
                     Self.mcUserScore.Prop.Items[3].Text:=Format('%.2f',[AOrderFeeJson.F['money']]);

                end;




                Self.mcUserScore.Prop.Items[4].Text:='元';
                Self.rbUseScore.Visible:=True;
                Self.mcUserScore.SelfOwnMaterialToDefault.DrawCaptionParam.DrawRectSetting.Enabled:=False;

                Self.rbUseScore.Prop.Checked:=True;
              end;

//              //原价
//              if AOrderFeeJson.Contains('origin_price')
//                and (AOrderFeeJson.F['origin_price']<>AOrderFeeJson.F['origin_price']) then
//              begin
//                AListBoxItem.Detail3:='¥'+FloatToStr(GetJsonDoubleValue(AOrderFeeJson,'origin_price'));
//              end;


            end;

          finally
            Self.lbOrderFees.Prop.Items.EndUpdate();
          end;

          //小计
          Self.lblSubTotal.Prop.ColorTextCollection.ItemByName['SubTotal'].Text:=ADeliveryMoney;
          //加载总费用
          Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=ADeliveryMoney;
          if Self.FIsPayGoodsMoneyOnline=1 then
          begin
            Self.lblSubTotal.Prop.ColorTextCollection.ItemByName['SubTotal'].Text:=
                Format('%.2f',[ASuperObject.O['Data'].F['sum_money']]);

            Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
                Format('%.2f',[ASuperObject.O['Data'].F['sum_money']]);
          end;

          //亿诚生活加的
          if (Self.rbUseScore.Prop.Checked)
          AND (StrToFloat(Self.mcUserScore.Prop.Items[3].Text)>0) then
          begin
            //小计
//            Self.lblSubTotal.Prop.ColorTextCollection.ItemByName['SubTotal'].Text:=
//            Format('%.2f',[ASuperObject.O['Data'].F['sum_money']-StrToFloat(Self.mcUserScore.Prop.Items[2].Text)]);
            //加载总费用
            Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
            Format('%.2f',[StrToFloat(Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text)
            -StrToFloat(Self.mcUserScore.Prop.Items[3].Text)]);
          end;

          // | 已优惠¥12.01
          if BiggerDouble(ASuperObject.O['Data'].F['discount_money'],0) then
          begin
            Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['DecMoney'].Text:=
              ' | 已优惠¥'+Format('%.2f',[ASuperObject.O['Data'].F['discount_money']]);
          end
          else
          begin
            Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['DecMoney'].Text:='';
          end;

          if (ASuperObject.O['Data'].I['delivery_distance']<1000) and (ASuperObject.O['Data'].I['delivery_distance']>=0) then
          begin
            Self.lblDistence.Caption:=IntToStr(ASuperObject.O['Data'].I['delivery_distance'])+'m';
          end
          else
          begin
             Self.lblDistence.Caption:=FloatToStr(SimpleRoundTo(ASuperObject.O['Data'].I['delivery_distance']/1000,-1))+'km';
          end;

//          Self.lblRecvAddr.Height:=uSkinBufferBitmap.GetStringHeight(
//                                      Self.lblRecvAddr.Caption,
//                                      RectF(0,0,0,MaxInt),
//                                      Self.lblRecvAddr.CurrentUseMaterialToDefault.DrawCaptionParam
//                                      );
//
//          Self.pnlRecvAddr.Height:=Self.lblRecvAddr.Height+32;


          FCouponList.Clear(True);
          ACouponList:=TCouponList.Create(ooReference);
          //可用红包个数
          AUsefulNum:=0;

          ACouponList.ParseFromJsonArray(TCoupon,ASuperObject.O['Data'].A['CouponList']);
//
//          for g := 0 to ACouponList.Count-1 do
//          begin
//            FCouponList.Add(ACouponList[I]);
//          end;
          //加载可用的红包
          if ACouponDecMoney=0 then
          begin
            for g := 0 to ASuperObject.O['Data'].A['CouponList'].Length-1 do
            begin
              if ASuperObject.O['Data'].A['CouponList'].O[g].I['is_useful']=1 then
              begin
                FCouponList.Add(ACouponList[g]);
                AUsefulNum:=AUsefulNum+1;
              end;
            end;

//            if FUserCouponFID=0 then
//            begin
              if AUsefulNum>0 then
              begin
                Self.btnSelectUserCoupon.Caption:='有'+IntToStr(AUsefulNum)+'个红包可用';
                Self.btnSelectUserCoupon.SelfOwnMaterialToDefault.NormalPicture.ImageIndex:=0;
                Self.btnSelectUserCoupon.SelfOwnMaterialToDefault.DrawCaptionParam.DrawRectSetting.Right:=30;
              end
              else
              begin
                Self.btnSelectUserCoupon.Caption:='没有可用红包';
                Self.btnSelectUserCoupon.SelfOwnMaterialToDefault.NormalPicture.ImageIndex:=-1;
                Self.btnSelectUserCoupon.SelfOwnMaterialToDefault.DrawCaptionParam.DrawRectSetting.Right:=10;
              end;

//            end
//            else
//            begin
//              Self.btnSelectUserCoupon.Caption:='有'+IntToStr(AUsefulNum)+'个红包可用';
//              Self.btnSelectUserCoupon.SelfOwnMaterialToDefault.NormalPicture.ImageIndex:=0;
//              Self.btnSelectUserCoupon.SelfOwnMaterialToDefault.DrawCaptionParam.DrawRectSetting.Right:=30;
//            end;
          end
          else
          begin
            Self.btnSelectUserCoupon.Caption:='¥'+Format('%.2f',[ACouponDecMoney]);
          end;

          //加载预计送达时间
          if Self.btnSelectDeliverType.Caption='需要配送' then
          begin
            FDelivery_Time:=ASuperObject.O['Data'].I['delivery_time']+FCarShop.make_food_spent;
            Self.btnTime.Caption:='预计时间('+FormatDateTime('HH:MM',IncMinute(Now,ASuperObject.O['Data'].I['delivery_time']+FCarShop.make_food_spent))+')';
            FWant_Arrived_Time:=FormatDateTime('YYYY-MM-DD HH:MM:SS',IncMinute(Now,ASuperObject.O['Data'].I['delivery_time']+FCarShop.make_food_spent));
          end
          else
          begin
            FDelivery_Time:=Self.FCarShop.make_food_spent;
            Self.btnTime.Caption:='预计时间('+FormatDateTime('HH:MM',IncMinute(Now,FCarShop.make_food_spent))+')';
            FWant_Arrived_Time:=FormatDateTime('YYYY-MM-DD HH:MM:SS',IncMinute(Now,FCarShop.make_food_spent));

          end;

          //配送费用计算
          FDistance_free:=ASuperObject.O['Data'].F['distance_free'];
          FWeather_free:=ASuperObject.O['Data'].F['weather_free'];
          FWeight_free:=ASuperObject.O['Data'].F['weight_free'];
          FTime_free:=ASuperObject.O['Data'].F['time_free'];
          FBasic_free:=ASuperObject.O['Data'].F['basic_free'];
          FVolum_free:=ASuperObject.O['Data'].F['volum_free'];


          Self.AlignControls;


      end
      else
      begin
        //预下单失败
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

    FreeAndNil(ACouponList);
  end;
end;

procedure TFrameTakeOrder.DoSelectDeliverTypeFromPopupMenuFrame(APopupMenuFrame: TFrame);
begin
  if Self.btnSelectDeliverType.Caption<>TFramePopupMenu(APopupMenuFrame).ModalResult then
  begin
    Self.btnSelectDeliverType.Caption:=TFramePopupMenu(APopupMenuFrame).ModalResult;
    FDelivery_Type:=TFramePopupMenu(APopupMenuFrame).ModalResultName;

    Self.SyncDeliverTypeSelection;
    if TFramePopupMenu(APopupMenuFrame).ModalResultName=Const_DeliverType_NeedDeliver then
    begin
      //获取用户合适的收货地址
      Self.GetUserSuitRecvAddrList;
    end
    else
    begin
      //调用预下单接口,更新费用列表
      Self.PrepareOrder;
    end;

//    if TFramePopupMenu(APopupMenuFrame).ModalResult='需要配送' then
//    begin
//      //获取用户合适的收货地址
//      Self.GetUserSuitRecvAddrList;
//    end
//    else
//    begin
//      //调用预下单接口,更新费用列表
//      Self.PrepareOrder;
//    end;
  end;
end;

procedure TFrameTakeOrder.DoSelectTablewareQuantityFromPopupMenuFrame(
  APopupMenuFrame: TFrame);
begin
  //用餐人数
  Self.btnSelectTablewareQuantity.Caption:=TFramePopupMenu(APopupMenuFrame).ModalResult;
  Self.btnSelectTablewareQuantity.Tag:=TFramePopupMenu(APopupMenuFrame).ModalResultIndex;
end;

end.




