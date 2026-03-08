unit OrderInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinMaterial,
  uDataSetToJson,

  uUIFunction,
  HintFrame,
  WaitingFrame,
  MessageBoxFrame,
  uOpenClientCommon,
  uFrameContext,
  uManager,
  uDrawCanvas,
  uSkinItems,
  uTimerTask,
  uOpenCommon,
  uFuncCommon,
//  uEasyServiceCommon,
  XSuperObject,
  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,
  uMobileUtils,

  uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinFireMonkeyButton, uSkinFireMonkeyImage,
  uSkinImageType, uSkinLabelType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinButtonType, uBaseSkinControl, uSkinPanelType,
  uTimerTaskEvent;

type
  TFrameOrderInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbOrderInfo: TSkinFMXListBox;
    idpDefault: TSkinFMXItemDesignerPanel;
    lblItemName: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    btnReturn: TSkinFMXButton;
    btnViewDetail: TSkinFMXButton;
    idpItem2: TSkinFMXItemDesignerPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXButton1: TSkinFMXButton;
    pnlItemOper: TSkinFMXPanel;
    btnItemOper2: TSkinFMXButton;
    btnItemOper1: TSkinFMXButton;
    btnItemOper3: TSkinFMXButton;
    btnItemOper4: TSkinFMXButton;
    idtGroupHeader: TSkinFMXItemDesignerPanel;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXButton2: TSkinFMXButton;
    idpItemOrderFee: TSkinFMXItemDesignerPanel;
    lblFeeName: TSkinFMXLabel;
    lblFeeDesc: TSkinFMXLabel;
    lblFeeNum: TSkinFMXLabel;
    lblFeeMoney: TSkinFMXLabel;
    lblOriginFeeMoney: TSkinFMXLabel;
    SkinFMXImage1: TSkinFMXImage;
    tteCancelOrder: TTimerTaskEvent;
    btnCallDeliver: TSkinFMXButton;
    imgpic: TSkinFMXImage;
    tteGetGoods: TTimerTaskEvent;
    procedure btnReturnClick(Sender: TObject);
    procedure lbOrderInfoClickItem(AItem: TSkinItem);
    procedure btnItemOper1Click(Sender: TObject);
    procedure pnlItemOperResize(Sender: TObject);
    procedure lbOrderInfoPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure btnItemDetail3Click(Sender: TObject);
    procedure tteCancelOrderExecute(ATimerTask: TTimerTask);
    procedure tteCancelOrderExecuteEnd(ATimerTask: TTimerTask);
    procedure tteCancelOrderBegin(ATimerTask: TTimerTask);
    procedure btnCallDeliverClick(Sender: TObject);
    procedure tteGetGoodsBegin(ATimerTask: TTimerTask);
    procedure tteGetGoodsExecute(ATimerTask: TTimerTask);
    procedure tteGetGoodsExecuteEnd(ATimerTask: TTimerTask);
  private
    FOrder:TOrder;
    FOrderFID:Integer;
    //是否操作
    FIsOperate:Boolean;

    //用户购物车商品列表
    FCarGoodList:TCarGoodList;

    procedure Clear;

    //获取订单接口
    procedure DoGetOrderExecute(ATimerTask:TObject);
    procedure DoGetOrderExecuteEnd(ATimerTask:TObject);

    //骑手联系方式
    procedure OnModalResultFromRiderPhoneNumber(AFrame:TObject);
  private
    //骑手电话
    FRiderPhone:String;
    //获取骑手信息
    procedure DoGetRiderInfoExecute(ATimerTask:TObject);
    procedure DoGetRiderInfoExecuteEnd(ATimerTask:TObject);

  private
    //获取商家信息
    procedure DoGetShopInfoExecute(ATimerTask:TObject);
    procedure DoGetShopInfoExecuteEnd(ATimerTask:TObject);
  private
    //再来一单
    procedure DoAddUserCarExecute(ATimerTask:TObject);
    procedure DoAddUserCarExecuteEnd(ATimerTask:TObject);

//  private
//    FUser:TUser;
//    procedure DoGetOrderUserInfoExecute(ATimerTask:TObject);
//    procedure DoGetOrderUserInfoExecuteEnd(ATimerTask:TObject);
//
//  private
//    FHotel:THotel;
//    procedure DoGetOrderHotelInfoExecute(ATimerTask:TObject);
//    procedure DoGetOrderHotelInfoExecuteEnd(ATimerTask:TObject);
//  private
//    FPayIsManager:Integer;
//    FPayCommissionName:String;
//    //支付佣金接口
//    procedure DoPayOrderManagerCommissionExecute(ATimerTask:TObject);
//    procedure DoPayOrderManagerCommissionExecuteEnd(ATimerTask:TObject);
//
//    //返回刷新
//    procedure DoReturnPayCommissionFrame(Frame:TFrame);

  private
    //按钮个数
    FButtonCount:Integer;
    FItemButtonCaptionArray:Array[0..3] of String;
    FItemButtonNameArray:Array[0..3] of String;
    procedure DoOrderOper(AOper: String; AOrder: TOrder);
//  private
//    //编辑订单返回
//    procedure OnReturnFrameFromEditOrderFrame(Frame: TFrame);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Load(AOrder:TOrder);overload;
    procedure Load(AOrderFID:Integer);overload;
    procedure Sync;
    { Public declarations }
  end;


var
  GlobalOrderInfoFrame:TFrameOrderInfo;




implementation

uses
  MainForm,
  MainFrame,
  PayOrderFrame,
  GetEvalvateListFrame,
  ShopInfoFrame
//  AuditFrame,
//  TakeOrderFrame,
//  OrderGoodsListFrame,
//  CommissionPaymentInfoFrame,
//  OrderStateFrame,
//  OrderPayRecordFrame,
//  UserInfoFrame,
//  OrderDeliveryInfoFrame,
//  HotelInfoFrame,
//  AuditInfoFrame,
//  PayCommissionFrame
  ;

{$R *.fmx}


procedure TFrameOrderInfo.DoOrderOper(AOper:String;AOrder:TOrder);
var
  I: Integer;
begin
  //取消订单
  if AOper='cancel_order' then
  begin
    Self.tteCancelOrder.Run;
  end;

  //支付订单
  if AOper='pay_order' then
  begin

    //隐藏
    HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);

    //显示用户信息
    ShowFrame(TFrame(GlobalPayOrderFrame),TFramePayOrder,frmMain,nil,nil,nil,Application);
//    GlobalPayOrderFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalPayOrderFrame.Load(AOrder,True);
  end;


  //确认收货
  if AOper='receive_order' then
  begin
    Self.tteGetGoods.Run;
  end;

  //再次购买
  if AOper='buy_again' then
  begin

    Self.FOrder:=AOrder;

    for I := 0 to FOrder.OrderGoodsList.Count-1 do
    begin
      if FOrder.shop_fid=FOrder.OrderGoodsList[I].shop_fid then
      begin
        GlobalMainFrame.AddGoodsToUserCart(FOrder.OrderGoodsList[I].shop_fid,
                                             FOrder.OrderGoodsList[I].shop_goods_fid,
                                             FOrder.OrderGoodsList[I].shop_goods_spec_fid,
                                             FOrder.OrderGoodsList[I].number,
                                             FOrder.OrderGoodsList[I].shop_goods_attrs,
                                             FOrder.OrderGoodsList[I].orderno);
      end;
    end;


    //加载店铺详情
    HideFrame;//();
    ShowFrame(TFrame(GlobalShopInfoFrame),TFrameShopInfo);
//    GlobalShopInfoFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalShopInfoFrame.Clear;
    GlobalShopInfoFrame.IsShowBackBtn;
    GlobalShopInfoFrame.Load(FOrder.shop_fid,FCarGoodList,GlobalShopInfoFrame);



//    uTimerTask.GetGlobalTimerThread.RunTempTask(
//          DoAddUserCarExecute,
//          DoAddUserCarExecuteEnd);
  end;

end;

//procedure TFrameOrderInfo.DoDelOrderExecute(ATimerTask: TObject);
//var
//  AHttpControl:THttpControl;
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//  AHttpControl:=TSystemHttpControl.Create;
//  try
//    try
//      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('del_user',
//                                                    AHttpControl,
//                                                    InterfaceUrl,
//                                                    [
//                                                    'appid',
//                                                    'emp_fid',
//                                                    'key',
//                                                    'man_fid'
//                                                    ],
//                                                    [AppID,
//                                                    GlobalManager.Order.fid,
//                                                    GlobalManager.Order.key,
//                                                    FOrder.fid
//                                                    ],
//                                        GlobalRestAPISignType,
//                                        GlobalRestAPIAppSecret
//                                                    );
//
//      if TTimerTask(ATimerTask).TaskDesc<>'' then
//      begin
//        TTimerTask(ATimerTask).TaskTag:=0;
//      end;
//
//
//    except
//      on E:Exception do
//      begin
//        //异常
//        TTimerTask(ATimerTask).TaskDesc:=E.Message;
//      end;
//    end;
//  finally
//    FreeAndNil(AHttpControl);
//  end;
//
//end;
//
//procedure TFrameOrderInfo.DoDelOrderExecuteEnd(ATimerTask: TObject);
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
//        //删除用户成功
//        HideFrame;//(Self,hfcttBeforeReturnFrame);
//        ReturnFrame(Self.FrameHistroy);
//
//
//      end
//      else
//      begin
//        //注册失败
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
//
//end;

destructor TFrameOrderInfo.Destroy;
begin
  FreeAndNil(FOrder);

  FreeAndNil(FCarGoodList);
//  FreeAndNil(FHotel);
  inherited;
end;

procedure TFrameOrderInfo.DoAddUserCarExecute(ATimerTask: TObject);
var
  I:Integer;
  ACarGood:TCarGood;
  ASuperObject:ISuperObject;
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
      Self.FCarGoodList.Clear(True);

      for I := 0 to FOrder.OrderGoodsList.Count-1 do
      begin
        if FOrder.shop_fid=FOrder.OrderGoodsList[I].shop_fid then
        begin

          TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('add_shop_goods_to_cart',
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
                                                          FOrder.OrderGoodsList[I].shop_fid,
                                                          GlobalManager.User.key,
                                                          FOrder.OrderGoodsList[I].shop_goods_fid,
                                                          FOrder.OrderGoodsList[I].shop_goods_spec_fid,
                                                          FOrder.OrderGoodsList[I].number,
                                                          FOrder.OrderGoodsList[I].orderno,
                                                          FOrder.OrderGoodsList[I].shop_goods_attrs
                                                          ],
                                        GlobalRestAPISignType,
                                        GlobalRestAPIAppSecret
                                                          );

          if TTimerTask(ATimerTask).TaskDesc <> '' then
          begin
            TTimerTask(ATimerTask).TaskTag := 0;

            ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

            try
              ACarGood:=TCarGood.Create;

              ACarGood.ParseFromJson(ASuperObject.O['Data'].A['ShopGoodsInCart'].O[0]);


              Self.FCarGoodList.Add(ACarGood);
            finally

            end;

          end;



        end;

      end;

  except
    on E: Exception do
    begin
      // 异常
      TTimerTask(ATimerTask).TaskDesc := E.Message;
    end;
  end;



end;

procedure TFrameOrderInfo.DoAddUserCarExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ACarGood:TCarGood;
begin

  try
    ACarGood:=TCarGood.Create;
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //添加成功

        //加载店铺详情
        HideFrame;//(Self,hfcttBeforeShowFrame);
        ShowFrame(TFrame(GlobalShopInfoFrame),TFrameShopInfo);
//        GlobalShopInfoFrame.FrameHistroy:=CurrentFrameHistroy;
        GlobalShopInfoFrame.Clear;
        GlobalShopInfoFrame.IsShowBackBtn;
        GlobalShopInfoFrame.Load(FOrder.shop_fid,
                                 FCarGoodList,
                                 GlobalShopInfoFrame);
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

procedure TFrameOrderInfo.DoGetOrderExecute(ATimerTask: TObject);
begin
  FMX.Types.Log.d('OrangeUI DoGetOrderExecute');
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
                          SimpleCallAPI('user_get_order',
                          nil,
                          ShopCenterInterfaceUrl,
                          [
                          'appid',
                          'user_fid',
                          'key',
                          'order_fid'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          GlobalManager.User.key,
                          FOrderFid
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

procedure TFrameOrderInfo.DoGetOrderExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

      FMX.Types.Log.d('OrangeUI ASuperObject'+ASuperObject.AsJSON);
      if ASuperObject.I['Code']=200 then
      begin
        FMX.Types.Log.d('OrangeUI Code:200');
        //刷新订单信息
        FOrder.ParseFromJson(ASuperObject.O['Data'].A['OrderInfo'].O[0]);

        Load(FOrder);

      end
      else
      begin
        //获取订单失败
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

procedure TFrameOrderInfo.DoGetRiderInfoExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_rider_info',
                                                      nil,
                                                      DeliveryCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'rider_fid'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      Self.FOrder.rider_user_fid
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

procedure TFrameOrderInfo.DoGetRiderInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

      FMX.Types.Log.d('OrangeUI ASuperObject'+ASuperObject.AsJSON);
      if ASuperObject.I['Code']=200 then
      begin
        FRiderPhone:=ASuperObject.O['Data'].A['User'].O[0].S['phone'];
        //获取成功                             .
        ShowMessageBoxFrame(Self,'电话: '+FRiderPhone,'',TMsgDlgType.mtInformation,['呼叫','取消'],OnModalResultFromRiderPhoneNumber);
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

procedure TFrameOrderInfo.DoGetShopInfoExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_shop_info',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'shop_fid',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      Self.FOrder.shop_fid,
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

procedure TFrameOrderInfo.DoGetShopInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

      FMX.Types.Log.d('OrangeUI ASuperObject'+ASuperObject.AsJSON);
      if ASuperObject.I['Code']=200 then
      begin
        FRiderPhone:=ASuperObject.O['Data'].A['ShopInfo'].O[0].S['phone'];
        //获取成功                             .
        ShowMessageBoxFrame(Self,'电话: '+FRiderPhone,'',TMsgDlgType.mtInformation,['呼叫','取消'],OnModalResultFromRiderPhoneNumber);
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

//procedure TFrameOrderInfo.DoGetOrderHotelInfoExecute(ATimerTask: TObject);
//var
//  AHttpControl:THttpControl;
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//  AHttpControl:=TSystemHttpControl.Create;
//  try
//    try
//      TTimerTask(ATimerTask).TaskDesc:=
//                              SimpleCallAPI('get_hotel',
//                              AHttpControl,
//                              InterfaceUrl,
//                              ['appid',
//                              'user_fid',
//                              'key',
//                              'hotel_fid'],
//                              [AppID,
//                              GlobalManager.User.fid,
//                              GlobalManager.User.key,
//                              FOrder.hotel_fid
//                              ],
//                                        GlobalRestAPISignType,
//                                        GlobalRestAPIAppSecret
//                              );
//
//      if TTimerTask(ATimerTask).TaskDesc<>'' then
//      begin
//        TTimerTask(ATimerTask).TaskTag:=0;
//      end;
//
//
//    except
//      on E:Exception do
//      begin
//        //异常
//        TTimerTask(ATimerTask).TaskDesc:=E.Message;
//      end;
//    end;
//  finally
//    FreeAndNil(AHttpControl);
//  end;
//
//end;
//
//procedure TFrameOrderInfo.DoGetOrderHotelInfoExecuteEnd(ATimerTask: TObject);
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
//        //获取酒店信息成功
//        FHotel.ParseFromJson(ASuperObject.O['Data'].A['Hotel'].O[0]);
//        //显示酒店信息
//        //隐藏
//        HideFrame;//(Self,hfcttBeforeShowFrame);
//
//        //审核意见
//        ShowFrame(TFrame(GlobalHotelInfoFrame),TFrameHotelInfo,frmMain,nil,nil,nil,Application);
//        GlobalHotelInfoFrame.Load(FHotel);
//        GlobalHotelInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//
//
//
//      end
//      else
//      begin
//        //获取失败
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
//
//procedure TFrameOrderInfo.DoGetOrderUserInfoExecute(ATimerTask: TObject);
//var
//  AHttpControl:THttpControl;
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//  AHttpControl:=TSystemHttpControl.Create;
//  try
//    try
//      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_user',
//                                                    AHttpControl,
//                                                    InterfaceUrl,
//                                                    [
//                                                    'appid',
//                                                    'emp_fid',
//                                                    'key',
//                                                    'man_fid'
//                                                    ],
//                                                    [AppID,
//                                                    GlobalManager.User.fid,
//                                                    GlobalManager.User.key,
//                                                    FOrder.user_fid
//                                                    ],
//                                        GlobalRestAPISignType,
//                                        GlobalRestAPIAppSecret
//                                                    );
//
//      if TTimerTask(ATimerTask).TaskDesc<>'' then
//      begin
//        TTimerTask(ATimerTask).TaskTag:=0;
//      end;
//
//
//    except
//      on E:Exception do
//      begin
//        //异常
//        TTimerTask(ATimerTask).TaskDesc:=E.Message;
//      end;
//    end;
//  finally
//    FreeAndNil(AHttpControl);
//  end;
//
//end;
//
//procedure TFrameOrderInfo.DoGetOrderUserInfoExecuteEnd(ATimerTask: TObject);
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
//        //获取用户信息成功
//
//        //刷新用户信息
//        FUser.ParseFromJson(ASuperObject.O['Data'].A['User'].O[0]);
//
//
//        //显示用户信息
//        //隐藏
//        HideFrame;//(Self,hfcttBeforeShowFrame);
//
//        ShowFrame(TFrame(GlobalUserInfoFrame),TFrameUserInfo,frmMain,nil,nil,nil,Application);
//        GlobalUserInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//
//        GlobalUserInfoFrame.Load(FUser);
//        GlobalUserInfoFrame.Sync;
//
//      end
//      else
//      begin
//        //获取失败
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
//
//procedure TFrameOrderInfo.DoPayOrderManagerCommissionExecute(
//  ATimerTask: TObject);
//var
//  AHttpControl:THttpControl;
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//  AHttpControl:=TSystemHttpControl.Create;
//  try
//    try
//      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_commission_accepter_account_info',
//                                                      AHttpControl,
//                                                      InterfaceUrl,
//                                                      ['appid',
//                                                      'user_fid',
//                                                      'key',
//                                                      'order_fid',
//                                                      'Is_pay_manager'],
//                                                      [AppID,
//                                                      GlobalManager.User.fid,
//                                                      GlobalManager.User.key,
//                                                      FOrder.fid,
//                                                      FPayIsManager
//                                                      ],
//                                        GlobalRestAPISignType,
//                                        GlobalRestAPIAppSecret
//                                                      );
//      if TTimerTask(ATimerTask).TaskDesc<>'' then
//      begin
//        TTimerTask(ATimerTask).TaskTag:=0;
//      end;
//
//    except
//      on E:Exception do
//      begin
//        //异常
//        TTimerTask(ATimerTask).TaskDesc:=E.Message;
//      end;
//    end;
//  finally
//    FreeAndNil(AHttpControl);
//  end;
//
//end;
//
//procedure TFrameOrderInfo.DoPayOrderManagerCommissionExecuteEnd(
//  ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//  AMessageObject:ISuperObject;
//begin
//
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//        AMessageObject:=ASuperObject.O['Data'].A['AccepterBankMessage'].O[0];
//
//        //若未完善银行卡信息，则提示
//        if AMessageObject.S['bank_account']='' then
//        begin
//          ShowMessageBoxFrame(frmMain,'该酒店经理未完善银行卡信息，无法进行支付操作！','',TMsgDlgType.mtInformation,['确定'],nil);
//        end
//        else
//        begin
//          //隐藏
//          HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
//
//          //支付经理佣金
//          ShowFrame(TFrame(GlobalPayCommissionFrame),TFramePayCommission,frmMain,nil,nil,DoReturnPayCommissionFrame,Application);
//          GlobalPayCommissionFrame.FrameHistroy:=CurrentFrameHistroy;
//          GlobalPayCommissionFrame.Clear;
//          GlobalPayCommissionFrame.Load(GetJsonDoubleValue(AMessageObject,'commission'),
//                                        AMessageObject.S['bill_code'],
//                                        AMessageObject.S['name'],
//                                        AMessageObject.S['bank_account'],
//                                        AMessageObject.S['bank_name'],
//                                        AMessageObject.I['is_manager'],
//                                        AMessageObject.I['order_fid'],
//                                        FPayCommissionName
//                                         );
//        end;
//
//      end
//      else
//      begin
//        //获取失败
//        ShowMessageBoxFrame(frmMain,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
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
//
//procedure TFrameOrderInfo.DoReturnPayCommissionFrame(Frame: TFrame);
//begin
//  Self.Sync;
//end;

procedure TFrameOrderInfo.lbOrderInfoClickItem(AItem: TSkinItem);
begin


  //我的评价
  if AItem.Name='my_evalvate' then
  begin
    //隐藏
    HideFrame;//(Self,hfcttBeforeShowFrame);

    //显示评价页面
    ShowFrame(TFrame(GlobalGetEvalvateListFrame),TFrameGetEvalvateList);
//    GlobalGetEvalvateListFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalGetEvalvateListFrame.LoadOrder(Self.FOrder);
    GlobalGetEvalvateListFrame.Load(Self.FOrder.fid,Self.FOrder.delivery_center_order_fid);
  end;


//  //查看订单状态
//  if AItem.Caption='订单状态' then
//  begin
//        //隐藏
//    HideFrame;//(Self,hfcttBeforeShowFrame);
//
//    //审核意见
//    ShowFrame(TFrame(GlobalOrderStateFrame),TFrameOrderState,frmMain,nil,nil,nil,Application);
//
//    GlobalOrderStateFrame.Clear;
//    GlobalOrderStateFrame.Load(FOrder);
//    GlobalOrderStateFrame.FrameHistroy:=CurrentFrameHistroy;
//  end;
//
//
//  //查看订单商品清单
//  if AItem.Caption='商品清单' then
//  begin
//      //隐藏
//    HideFrame;//(Self,hfcttBeforeShowFrame);
//
//    //商品清单列表
//    ShowFrame(TFrame(GlobalOrderGoodsListFrame),TFrameOrderGoodsList,frmMain,nil,nil,nil,Application);
//
//    GlobalOrderGoodsListFrame.Load(FOrder,3);
//    GlobalOrderGoodsListFrame.FrameHistroy:=CurrentFrameHistroy;
//  end;
//
//  //查看下单经理信息
//  if AItem.Caption='下单经理' then
//  begin
//    ShowWaitingFrame(Self,'加载中...');
//    uTimerTask.GetGlobalTimerThread.RunTempTask(
//                                   DoGetOrderUserInfoExecute,
//                                   DoGetOrderUserInfoExecuteEnd);
//  end;
//
//  //查看下单酒店信息
//  if AItem.Caption='下单酒店' then
//  begin
//    ShowWaitingFrame(Self,'加载中...');
//    uTimerTask.GetGlobalTimerThread.RunTempTask(
//                                 DoGetOrderHotelInfoExecute,
//                                 DoGetOrderHotelInfoExecuteEnd);
//  end;
//
//  //查看订单付款记录
//  if AItem.Caption='付款记录' then
//  begin
//
//
//
//    if FOrder.pay_state=Const_PayState_Payed then
//    begin
//        //隐藏
//      HideFrame;//(Self,hfcttBeforeShowFrame);
//
//      //审核意见
//      ShowFrame(TFrame(GlobalOrderPayRecordFrame),TFrameOrderPayRecord,frmMain,nil,nil,nil,Application);
//      GlobalOrderPayRecordFrame.Clear;
//      GlobalOrderPayRecordFrame.Load(FOrder);
//      GlobalOrderPayRecordFrame.FrameHistroy:=CurrentFrameHistroy;
//    end;
////    else
////    begin
////      if AItem.Detail='不需要付款' then
////      begin
////        ShowMessageBoxFrame(Self,'您不需要付款，所以没有付款记录!','',TMsgDlgType.mtInformation,['确定'],nil);
////        Exit;
////      end
////      else
////      begin
////        ShowMessageBoxFrame(Self,'您还未付款，所以没有付款记录，请您先去付款!','',TMsgDlgType.mtInformation,['确定'],nil);
////        Exit;
////      end;
////    end;
//
//  end;
//
//  if AItem.Caption='审核记录' then
//  begin
////      if (GetAuditStateStr(TAuditState(FOrder.audit_state))='审核通过')
////        or (GetAuditStateStr(TAuditState(FOrder.audit_state))='审核拒绝') then
//      if (FOrder.audit_state=Ord(asAuditPass))
//        or (FOrder.audit_state=Ord(asAuditReject)) then
//      begin
//        //隐藏
//        HideFrame;//(Self,hfcttBeforeShowFrame);
//
//        //审核意见
//        ShowFrame(TFrame(GlobalAuditInfoFrame),TFrameAuditInfo,frmMain,nil,nil,nil,Application);
//        GlobalAuditInfoFrame.Clear;
//        GlobalAuditInfoFrame.LoadOrder(FOrder);
//        GlobalAuditInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//      end;
//  end;
//
//  //查看订单发货记录
//  if AItem.Caption='发货记录' then
//  begin
//      if (FOrder.order_state=Const_OrderState_WaitReceive)
//        or (FOrder.order_state=Const_OrderState_Done) then
//      begin
////
////        if Self.lbOrderInfo.Prop.Items.FindItemByName('订单状态').Detail<>'已完成' then
////        begin
////          ShowMessageBoxFrame(Self,'您暂时没有发货记录!','',TMsgDlgType.mtInformation,['确定'],nil);
////          Exit;
////        end
////        else
////        begin
////          //隐藏
////          HideFrame;//(Self,hfcttBeforeShowFrame);
////
////          //发货记录
////          ShowFrame(TFrame(GlobalOrderDeliveryInfoFrame),TFrameOrderDelivery,frmMain,nil,nil,nil,Application);
////          GlobalOrderDeliveryInfoFrame.FrameHistroy:=CurrentFrameHistroy;
////
////          GlobalOrderDeliveryInfoFrame.Clear;
////          GlobalOrderDeliveryInfoFrame.Load(FOrder);
////        end;
////      end
////      else
////      begin
//        //隐藏
//        HideFrame;//(Self,hfcttBeforeShowFrame);
//
//        //发货记录
//        ShowFrame(TFrame(GlobalOrderDeliveryInfoFrame),TFrameOrderDeliveryInfo,frmMain,nil,nil,nil,Application);
//        GlobalOrderDeliveryInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//
//        GlobalOrderDeliveryInfoFrame.Load(FOrder);
//        GlobalOrderDeliveryInfoFrame.Sync;
//      end;
//
//  end;
//
//  if AItem.Caption='经理佣金' then
//  begin
//    if FOrder.is_pay_manager=1 then
//    begin
//      //隐藏
//      HideFrame;//(Self,hfcttBeforeShowFrame);
//
//      //审核意见
//      ShowFrame(TFrame(GlobalCommissionPaymentInfoFrame),TFrameCommissionPaymentInfo,frmMain,nil,nil,nil,Application);
//      GlobalCommissionPaymentInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//      GlobalCommissionPaymentInfoFrame.Clear;
//      GlobalCommissionPaymentInfoFrame.Load('经理佣金支付详情',
//                                            FOrder.fid,
//                                            0);
//    end
//    else
//    begin
//      if GlobalMAnager.UserHasAuthority('订单支付佣金权限') then
//      begin
//        FPayIsManager:=1;
//        FPayCommissionName:=FOrder.user_name;
//        uTimerTask.GetGlobalTimerThread.RunTempTask(
//                              DoPayOrderManagerCommissionExecute,
//                              DoPayOrderManagerCommissionExecuteEnd);
//      end;
//    end;
//
//  end;
//
//
//  if AItem.Caption='介绍人佣金' then
//  begin
//    if FOrder.is_pay_introducer=1 then
//    begin
//      //隐藏
//      HideFrame;//(Self,hfcttBeforeShowFrame);
//
//      //审核意见
//      ShowFrame(TFrame(GlobalCommissionPaymentInfoFrame),TFrameCommissionPaymentInfo,frmMain,nil,nil,nil,Application);
//      GlobalCommissionPaymentInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//      GlobalCommissionPaymentInfoFrame.Clear;
//      GlobalCommissionPaymentInfoFrame.Load('介绍人佣金支付详情',
//                                            FOrder.fid,
//                                            1);
//    end
//    else
//    begin
//      if GlobalMAnager.UserHasAuthority('订单支付佣金权限') then
//      begin
//        FPayIsManager:=0;
//        FPayCommissionName:=FOrder.introducer_name;
//        uTimerTask.GetGlobalTimerThread.RunTempTask(
//                              DoPayOrderManagerCommissionExecute,
//                              DoPayOrderManagerCommissionExecuteEnd);
//      end;
//    end;
//
//  end;



end;

procedure TFrameOrderInfo.lbOrderInfoPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin

  if (AItem.Name='DeliverUser') or (AItem.Name='sum_money') then
  begin
    Self.btnCallDeliver.Visible:=True;
    if AItem.Name='DeliverUser' then
    begin
      Self.btnCallDeliver.Caption:='联系骑手';
    end
    else
    begin
      Self.btnCallDeliver.Caption:='联系商家';
    end;
  end
  else
  begin
    Self.btnCallDeliver.Visible:=False;
  end;

end;

procedure TFrameOrderInfo.btnCallDeliverClick(Sender: TObject);
begin
  if Self.lbOrderInfo.Prop.InteractiveItem.Name='sum_money' then
  begin
    //获取店铺信息
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                    DoGetShopInfoExecute,
                    DoGetShopInfoExecuteEnd,
                    'GetShopInfo');
  end
  else
  begin
    //获取骑手信息
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                     DoGetRiderInfoExecute,
                     DoGetRiderInfoExecuteEnd,
                     'GetRiderInfo');
  end;
end;

procedure TFrameOrderInfo.btnItemDetail3Click(Sender: TObject);
begin
//  //复制单号
//  MySetClipboard(
//              //Self.lbOrderInfo.Prop.Items.FindItemByName('订单状态').Detail2
//              FOrder.bill_code
//              );
//  ShowHintFrame(Self,'复制成功!');

end;

procedure TFrameOrderInfo.btnItemOper1Click(Sender: TObject);
begin
  DoOrderOper(FItemButtonNameArray[TSkinFMXButton(Sender).Tag],FOrder);
end;

procedure TFrameOrderInfo.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then Exit;

  if (GetFrameHistory(Self)<>nil) and (FIsOperate=False) then
  begin
    GetFrameHistory(Self).OnReturnFrame:=nil;
  end;
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameOrderInfo.Clear;
begin
  Self.lbOrderInfo.Prop.Items.ClearData('ItemDetail');
  Self.lbOrderInfo.Prop.Items.ClearData('ItemDetail1');
  Self.lbOrderInfo.Prop.Items.ClearData('ItemDetail2');
  Self.lbOrderInfo.Prop.Items.ClearData('ItemDetail3');
  Self.lbOrderInfo.Prop.Items.ClearData('ItemDetail4');
  Self.lbOrderInfo.Prop.Items.ClearData('ItemDetail5');
  Self.lbOrderInfo.Prop.Items.ClearData('ItemDetail6');

  FRiderPhone:='';



//  Self.lbOrderInfo.Prop.Items.FindItemByName('订单状态').Detail:='';
//  Self.lbOrderInfo.Prop.Items.FindItemByName('订单状态').Detail2:='';
//  Self.lbOrderInfo.Prop.Items.FindItemByName('订单状态').Detail4:='';
//
//  Self.lbOrderInfo.Prop.Items.FindItemByName('下单酒店').Detail:='';
//  Self.lbOrderInfo.Prop.Items.FindItemByName('下单经理').Detail:='';
//  Self.lbOrderInfo.Prop.Items.FindItemByName('商品清单').Detail:='';
//
//
//  Self.lbOrderInfo.Prop.Items.FindItemByName('订单金额').Detail:='';
//  Self.lbOrderInfo.Prop.Items.FindItemByName('订单金额').Detail2:='';
//  Self.lbOrderInfo.Prop.Items.FindItemByName('付款记录').Detail:='';
//
//  Self.lbOrderInfo.Prop.Items.FindItemByName('审核记录').Detail:='';
//
//  Self.lbOrderInfo.Prop.Items.FindItemByName('发货记录').Detail:='';
//  Self.lbOrderInfo.Prop.Items.FindItemByName('收货人信息').Detail1:='';
//  Self.lbOrderInfo.Prop.Items.FindItemByName('收货人信息').Detail2:='';
//  Self.lbOrderInfo.Prop.Items.FindItemByName('收货人信息').Detail4:='';
//
//  Self.lbOrderInfo.Prop.Items.FindItemByName('备注').Detail:='';
end;

constructor TFrameOrderInfo.Create(AOwner: TComponent);
begin
  inherited;
  FOrder:=TOrder.Create;
//  FUser:=TUser.Create;
//  FHotel:=THotel.Create;
  FCarGoodList:=TCarGoodList.Create;

  Self.btnCallDeliver.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;


  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

procedure TFrameOrderInfo.Load(AOrderFID:Integer);
begin
  FOrderFID:=AOrderFID;

  Self.FIsOperate:=False;

  Clear;
  //加载订单
  //刷新
  ShowWaitingFrame(Self,'加载中...');
  //下拉刷新
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                               DoGetOrderExecute,
                               DoGetOrderExecuteEnd,
                               'GetOrder');


end;

procedure TFrameOrderInfo.OnModalResultFromRiderPhoneNumber(AFrame: TObject);
begin
  if TFrameMessageBox(AFrame).ModalResult='呼叫' then
  begin

    uMobileUtils.Dail(FRiderPhone);

  end
  else
  begin
    //留在页面
  end;
end;

procedure TFrameOrderInfo.Load(AOrder:TOrder);
var
  AListBoxItem:TSkinListBoxItem;
  I: Integer;
var
  AItemButtonIndex:Integer;
begin
  Clear;

  FOrderFID:=AOrder.fid;
  FOrder.Assign(AOrder);

  FMX.Types.Log.d('OrangeUI Load AOrder');

  Self.lbOrderInfo.Prop.Items.BeginUpdate;
  try
      //订单状态
      Self.lbOrderInfo.Prop.Items.FindItemByName('order_state').Detail:=
          GetUserOrderStateStr(AOrder.order_state_for_display,False);

      //商家信息
      Self.lbOrderInfo.Prop.Items.FindItemByName('shop_name').Caption:=
        AOrder.shop_name;
      Self.lbOrderInfo.Prop.Items.FindItemByName('shop_name').Tag:=
        AOrder.shop_fid;




      //加载费用列表
      Self.lbOrderInfo.Prop.Items.ClearItemsByType(sitItem4);
      for I := 0 to AOrder.OrderFees.Count-1 do
      begin
        //先不显示包装费
        if AOrder.OrderFees[I].name<>'包装费' then
        begin



          AListBoxItem:=Self.lbOrderInfo.Prop.Items.Insert(Self.lbOrderInfo.Prop.Items.FindItemByName('shop_name').Index+I+1);
          AListBoxItem.ItemType:=sitItem4;
          AListBoxItem.Caption:=AOrder.OrderFees[I].name;
          if (AOrder.deliver_type=Const_DeliverType_Express)
          AND (AOrder.OrderFees[I].name='配送费') then AListBoxItem.Caption:='邮费';
          //金额
          AListBoxItem.Detail:='¥'+Format('%.2f',[AOrder.OrderFees[I].money]);
//          if
//              //减免
//              (AOrder.OrderFees[I].money<0)
//              //原价和现价不一样
//            or (AOrder.OrderFees[I].origin_money>0)
//                and IsNotSameDouble(GetJsonDoubleValue(AOrderFeeJson,'money'),
//                                    GetJsonDoubleValue(AOrderFeeJson,'origin_money'))
//             then
//          begin
//            AListBoxItem.Color:=$FFFB3437;
//          end;
          if AOrder.OrderFees[I].fee_type=Const_FeeType_GoodsMoney then
          begin
            //数量
            AListBoxItem.Detail1:='x'+IntToStr(AOrder.OrderFees[I].num);
          end;
          //费用描述
//          AListBoxItem.Detail2:=AOrder.OrderFees[I].fee_desc;
//          if AOrder.OrderFees[I].fee_desc<>'' then
//          begin
            //有描述,比如商品规格和属性,那么就要高一点
            AListBoxItem.Height:=90;
//          end;

          AListBoxItem.Icon.Url:=AOrder.OrderFees[I].GetPicUrl;

//              //原价
//              if AOrderFeeJson.Contains('origin_price')
//                and (AOrderFeeJson.F['origin_price']<>AOrderFeeJson.F['origin_price']) then
//              begin
//                AListBoxItem.Detail3:='¥'+FloatToStr(GetJsonDoubleValue(AOrderFeeJson,'origin_price'));
//              end;
        end;
      end;
      //总金额
      Self.lbOrderInfo.Prop.Items.FindItemByName('sum_money').Detail:=
        '¥'+Format('%.2f',[AOrder.goods_money]);




      //我的评价
      if AOrder.is_user_evaluated=1 then
      begin
        Self.lbOrderInfo.Prop.Items.FindItemByName('my_evalvate').Visible:=True;
      end
      else
      begin
        Self.lbOrderInfo.Prop.Items.FindItemByName('my_evalvate').Visible:=False;
      end;

      if AOrder.deliver_type=Const_DeliverType_NeedDeliver then
      begin
        Self.lbOrderInfo.Prop.Items.FindItemByName('want_arrive_time').Caption:='配送时间';
      end
      else
      begin
        Self.lbOrderInfo.Prop.Items.FindItemByName('want_arrive_time').Caption:=GetDeliverTypeStr(AOrder.deliver_type)+'时间';
      end;


      //配送信息
      if AOrder.is_book=0 then
      begin

        if AOrder.deliver_type=Const_DeliverType_NeedDeliver then
        begin
          //非预订,立即送达
          Self.lbOrderInfo.Prop.Items.FindItemByName('want_arrive_time').Detail:=
            '立即送达['+FormatDateTime('HH:MM',StandardStrToDateTime(AOrder.want_arrive_time))+']';
        end
        else
        begin
          Self.lbOrderInfo.Prop.Items.FindItemByName('want_arrive_time').Detail:=
            GetDeliverTypeStr(AOrder.deliver_type)+'时间['+FormatDateTime('HH:MM',StandardStrToDateTime(AOrder.want_arrive_time))+']';

        end;
      end
      else
      begin
        //预订
        Self.lbOrderInfo.Prop.Items.FindItemByName('want_arrive_time').Detail:=
          '预订['+AOrder.want_arrive_time+']';
      end;



      //配送方式
      Self.lbOrderInfo.Prop.Items.FindItemByName('deliver_type').Detail:=
        GetDeliverTypeStr(AOrder.deliver_type);


      //如果需要配送,则显示配送信息
      if AOrder.deliver_type=Const_DeliverType_NeedDeliver then
      begin

        Self.lbOrderInfo.Prop.Items.FindItemByName('recv_info').Visible:=True;

        Self.lbOrderInfo.Prop.Items.FindItemByName('DeliverUser').Visible:=True;

        //收货地址
        Self.lbOrderInfo.Prop.Items.FindItemByName('recv_info').Detail:=
                  AOrder.recv_addr+AOrder.recv_door_no+#13#10
                  +AOrder.recv_name+' '+AOrder.recv_phone;
        //配送骑手
        if (AOrder.rider_user_fid<>'') and (AOrder.rider_user_fid<>'0') AND (AppID<>'1004') then   // AND (AppID<>1004)  亿诚没加骑手
        begin
          Self.lbOrderInfo.Prop.Items.FindItemByName('DeliverUser').Visible:=True;
          Self.lbOrderInfo.Prop.Items.FindItemByName('DeliverUser').Detail:=AOrder.rider_name;
        end
        else
        begin
          Self.lbOrderInfo.Prop.Items.FindItemByName('DeliverUser').Visible:=False;
        end;
      end
      else
      begin
        Self.lbOrderInfo.Prop.Items.FindItemByName('recv_info').Visible:=False;

        Self.lbOrderInfo.Prop.Items.FindItemByName('DeliverUser').Visible:=False;
      end;



      //订单信息
      Self.lbOrderInfo.Prop.Items.FindItemByName('bill_code').Detail:=
        AOrder.bill_code;
      //支付方式
      Self.lbOrderInfo.Prop.Items.FindItemByName('pay_type').Detail:=
        GetPaymentTypeStr(AOrder.pay_type)+'('+GetPayStateStr(AOrder.pay_state)+')';
      //下单时间
      Self.lbOrderInfo.Prop.Items.FindItemByName('createtime').Detail:=
        AOrder.createtime;
      //备注
      Self.lbOrderInfo.Prop.Items.FindItemByName('memo').Detail:=
        AOrder.memo;
      Self.lbOrderInfo.Prop.Items.FindItemByName('memo').Height:=
                                    GetSuitContentHeight(lblItemDetail.Width,
                                                AOrder.memo,
                                                14,
                                                Self.lbOrderInfo.Prop.ItemHeight
                                                );




      Self.lbOrderInfo.VertScrollBar.Prop.Position:=0;




      AItemButtonIndex:=-1;
      FItemButtonCaptionArray[0]:='';
      FItemButtonCaptionArray[1]:='';
      FItemButtonCaptionArray[2]:='';
      FItemButtonCaptionArray[3]:='';

      FItemButtonNameArray[0]:='';
      FItemButtonNameArray[1]:='';
      FItemButtonNameArray[2]:='';
      FItemButtonNameArray[3]:='';
      //待付款
      if (AOrder.order_state=Const_OrderState_WaitPay)or (AOrder.order_state=Const_OrderState_PayTillDown) then
      begin
        //酒店经理
        //去付款、取消订单
        Inc(AItemButtonIndex);
        FItemButtonCaptionArray[AItemButtonIndex]:='去付款';
        FItemButtonNameArray[AItemButtonIndex]:='pay_order';
        Inc(AItemButtonIndex);
        FItemButtonCaptionArray[AItemButtonIndex]:='取消订单';
        FItemButtonNameArray[AItemButtonIndex]:='cancel_order';
      end;


      //已取消
      if AOrder.order_state=Const_OrderState_Cancelled then
      begin
        //再次购买、删除订单
        Inc(AItemButtonIndex);
        FItemButtonCaptionArray[AItemButtonIndex]:='再次购买';
        FItemButtonNameArray[AItemButtonIndex]:='buy_again';
//        Inc(AItemButtonIndex);
//        FItemButtonCaptionArray[AItemButtonIndex]:='删除订单';
//        FItemButtonNameArray[AItemButtonIndex]:='hide_order';
      end;


      //已支付
      if AOrder.order_state=Const_OrderState_Payed then
      begin
        Inc(AItemButtonIndex);
        FItemButtonCaptionArray[AItemButtonIndex]:='取消订单';
        FItemButtonNameArray[AItemButtonIndex]:='cancel_order';

        //确认收货
        Inc(AItemButtonIndex);
        FItemButtonCaptionArray[AItemButtonIndex]:='确认收货';
        FItemButtonNameArray[AItemButtonIndex]:='receive_order';
      end;


      //商家拒单
      if AOrder.order_state=Const_OrderState_Reject then
      begin
        Inc(AItemButtonIndex);
        FItemButtonCaptionArray[AItemButtonIndex]:='再次购买';
        FItemButtonNameArray[AItemButtonIndex]:='buy_again';
      end;


      //商家已接单
      if AOrder.order_state=Const_OrderState_Accepted then
      begin
        Inc(AItemButtonIndex);
        FItemButtonCaptionArray[AItemButtonIndex]:='取消订单';
        FItemButtonNameArray[AItemButtonIndex]:='cancel_order';
      end;


      //商家已出餐
      if AOrder.order_state=Const_OrderState_Sent then
      begin
        //确认收货
        Inc(AItemButtonIndex);
        FItemButtonCaptionArray[AItemButtonIndex]:='确认收货';
        FItemButtonNameArray[AItemButtonIndex]:='receive_order';
      end;

      //已完成
      if AOrder.order_state=Const_OrderState_Done then
      begin
        //再次购买
        Inc(AItemButtonIndex);
        FItemButtonCaptionArray[AItemButtonIndex]:='再次购买';
        FItemButtonNameArray[AItemButtonIndex]:='buy_again';
      end;


      Self.btnItemOper1.Caption:=FItemButtonCaptionArray[0];
      Self.btnItemOper1.Visible:=AItemButtonIndex>=0;
      Self.btnItemOper1.Tag:=0;

      Self.btnItemOper2.Caption:=FItemButtonCaptionArray[1];
      Self.btnItemOper2.Visible:=AItemButtonIndex>=1;
      Self.btnItemOper2.Tag:=1;

      Self.btnItemOper3.Caption:=FItemButtonCaptionArray[2];
      Self.btnItemOper3.Visible:=AItemButtonIndex>=2;
      Self.btnItemOper3.Tag:=2;

      Self.btnItemOper4.Caption:=FItemButtonCaptionArray[3];
      Self.btnItemOper4.Visible:=AItemButtonIndex>=3;
      Self.btnItemOper4.Tag:=3;

      FButtonCount:=AItemButtonIndex+1;

      Self.pnlItemOper.Visible:=FButtonCount>0;
      pnlItemOperResize(pnlItemOper);



      if FButtonCount=0 then
      begin
        Self.lbOrderInfo.Prop.Items.FindItemByName('order_state').Height:=80;
      end
      else
      begin
        Self.lbOrderInfo.Prop.Items.FindItemByName('order_state').Height:=100;
      end;



  finally
    Self.lbOrderInfo.Prop.Items.EndUpdate();
  end;


end;

//procedure TFrameOrderInfo.OnReturnFrameFromEditOrderFrame(Frame: TFrame);
//begin
//  Self.Load(FOrder);
//end;

procedure TFrameOrderInfo.pnlItemOperResize(Sender: TObject);
begin
//  if FButtonCount=0 then
//  begin
//
//  end;
//  if FButtonCount=1 then
//  begin
//    Self.btnItemOper1.Width:=(Self.Width-(FButtonCount+1)*20)/FButtonCount;
//    Self.btnItemOper1.Left:=Width-Self.btnItemOper1.Width-20;
//  end;
//  if FButtonCount=2 then
//  begin
//    Self.btnItemOper1.Width:=(Self.Width-(FButtonCount+1)*20)/FButtonCount;
//    Self.btnItemOper1.Left:=Width-Self.btnItemOper1.Width-20;
//
//    Self.btnItemOper2.Width:=Self.btnItemOper1.Width;
//    Self.btnItemOper2.Left:=Self.btnItemOper1.Left-Self.btnItemOper1.Width-20;
//  end;
//  if FButtonCount=3 then
//  begin
//    Self.btnItemOper1.Width:=(Self.Width-(FButtonCount+1)*20)/FButtonCount;
//    Self.btnItemOper1.Left:=Width-Self.btnItemOper1.Width-20;
//
//    Self.btnItemOper2.Width:=Self.btnItemOper1.Width;
//    Self.btnItemOper2.Left:=Self.btnItemOper1.Left-Self.btnItemOper1.Width-20;
//
//    Self.btnItemOper3.Width:=Self.btnItemOper1.Width;
//    Self.btnItemOper3.Left:=Self.btnItemOper2.Left-Self.btnItemOper2.Width-20;
//  end;
//  if FButtonCount=4 then
//  begin
    Self.btnItemOper1.Width:=(Self.Width-(FButtonCount+1)*20)/4;
    Self.btnItemOper1.Left:=20;

    Self.btnItemOper2.Width:=Self.btnItemOper1.Width;
    Self.btnItemOper2.Left:=Self.btnItemOper1.Left+Self.btnItemOper1.Width+20;

    Self.btnItemOper3.Width:=Self.btnItemOper1.Width;
    Self.btnItemOper3.Left:=Self.btnItemOper2.Left+Self.btnItemOper2.Width+20;

    Self.btnItemOper4.Width:=Self.btnItemOper1.Width;
    Self.btnItemOper4.Left:=Self.btnItemOper3.Left+Self.btnItemOper3.Width+20;
//  end;
end;

procedure TFrameOrderInfo.Sync;
begin

  Self.FIsOperate:=False;

  FMX.Types.Log.d('OrangeUI Sync');
  //刷新
  ShowWaitingFrame(Self,'加载中...');
  //下拉刷新
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                               DoGetOrderExecute,
                               DoGetOrderExecuteEnd,
                               'GetOrder');


end;

procedure TFrameOrderInfo.tteCancelOrderBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,'取消中...');
end;

procedure TFrameOrderInfo.tteCancelOrderExecute(ATimerTask: TTimerTask);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
                          SimpleCallAPI('user_cancel_order',
                          nil,
                          ShopCenterInterfaceUrl,
                          [
                          'appid',
                          'user_fid',
                          'key',
                          'order_fid',
                          'cancel_code',
                          'cancel_reason'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          GlobalManager.User.key,
                          FOrderFid,
                          'user_cancel',
                          '用户取消订单'
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

procedure TFrameOrderInfo.tteCancelOrderExecuteEnd(ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //刷新订单信息
        FOrder.ParseFromJson(ASuperObject.O['Data'].A['OrderInfo'].O[0]);

        FIsOperate:=True;

        Load(FOrder);

//        //取消订单后刷新我的界面 余额 积分 等数据
//        if GlobalMainFrame.FMyFrame<>nil then
//        begin
//          if FOrder.pay_type=Const_PaymentType_AccountBalance then GlobalMainFrame.FMyFrame.GetWallet;
//          GlobalMainFrame.FMyFrame.GetUserInfo;
//        end;

      end
      else
      begin
        //获取订单失败
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

procedure TFrameOrderInfo.tteGetGoodsBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,'确认收货中...');

end;

procedure TFrameOrderInfo.tteGetGoodsExecute(ATimerTask: TTimerTask);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
                          SimpleCallAPI('user_get_goods',
                          nil,
                          ShopCenterInterfaceUrl,
                          [
                          'appid',
                          'user_fid',
                          'key',
                          'order_fid'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          GlobalManager.User.key,
                          FOrderFid
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

procedure TFrameOrderInfo.tteGetGoodsExecuteEnd(ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //刷新订单信息
        FOrder.ParseFromJson(ASuperObject.O['Data'].A['OrderInfo'].O[0]);

        FIsOperate:=True;

        Load(FOrder);

//        //取消订单后刷新我的界面 余额 积分 等数据
//        if GlobalMainFrame.FMyFrame<>nil then
//        begin
//          if FOrder.pay_type=Const_PaymentType_AccountBalance then GlobalMainFrame.FMyFrame.GetWallet;
//          GlobalMainFrame.FMyFrame.GetUserInfo;
//        end;

      end
      else
      begin
        //获取订单失败
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


