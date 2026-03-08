unit UserOrderListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  System.DateUtils,

  uSkinMaterial,
  uOpenClientCommon,
  MessageBoxFrame,
  SelectAreaFrame,
  uUIFunction,
  uManager,
  uGPSLocation,
  uFrameContext,
  uConst,
  uLang,
  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  uBaseList,
  EasyServiceCommonMaterialDataMoudle,
  CommonImageDataMoudle,

  WaitingFrame,
  uSkinBufferBitmap,

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
  uSkinFireMonkeyItemDesignerPanel, uDrawPicture, uSkinImageList,
  uTimerTaskEvent;

type
  TFrameUserOrderList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    pcOrder: TSkinFMXPageControl;
    tsLogin: TSkinTabSheet;
    tsOrderList: TSkinTabSheet;
    lblLogin: TSkinFMXLabel;
    btnLogin: TSkinFMXButton;
    lbOrderList: TSkinFMXListBox;
    idpOrder: TSkinFMXItemDesignerPanel;
    imgLogo: TSkinFMXImage;
    lblState: TSkinFMXLabel;
    btnShopName: TSkinFMXButton;
    lblDeliverTime: TSkinFMXLabel;
    lblGoods: TSkinFMXLabel;
    lblPrice: TSkinFMXLabel;
    btnContinue: TSkinFMXButton;
    btnBook: TSkinFMXButton;
    lblShopName: TSkinFMXLabel;
    tsDeliverOrderList: TSkinTabSheet;
    lbDeliver: TSkinFMXListBox;
    imgList: TSkinImageList;
    idpDeliver: TSkinFMXItemDesignerPanel;
    pnlTag: TSkinFMXPanel;
    lblTag: TSkinFMXLabel;
    lblOrderState: TSkinFMXLabel;
    lblName: TSkinFMXLabel;
    pnlSendAddr: TSkinFMXPanel;
    imgTag: TSkinFMXImage;
    pnlContent: TSkinFMXPanel;
    lblDetail1: TSkinFMXLabel;
    lblDetail2: TSkinFMXLabel;
    lblDetail3: TSkinFMXLabel;
    pnlRecvAddr: TSkinFMXPanel;
    imgTag1: TSkinFMXImage;
    pnlContent1: TSkinFMXPanel;
    lblItemSetail1: TSkinFMXLabel;
    lblItemSetail2: TSkinFMXLabel;
    lblItemSetail3: TSkinFMXLabel;
    lblTime: TSkinFMXLabel;
    btnEvaRider: TSkinFMXButton;
    btnAgainBuy: TSkinFMXButton;
    tteAcceptGoods: TTimerTaskEvent;
    tteNoticeShoperAccepted: TTimerTaskEvent;
    lblCancelReason: TSkinFMXLabel;
    btnReturn: TSkinFMXButton;
    FrameContext1: TFrameContext;
    procedure lbOrderListPullDownRefresh(Sender: TObject);
    procedure lbOrderListPullUpLoadMore(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure lbOrderListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure lbOrderListClickItem(AItem: TSkinItem);
    procedure idpOrderResize(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure btnBookClick(Sender: TObject);
    procedure btnShopNameClick(Sender: TObject);
    procedure pcOrderChange(Sender: TObject);
    procedure lbDeliverPullDownRefresh(Sender: TObject);
    procedure lbDeliverPullUpLoadMore(Sender: TObject);
    procedure lbDeliverPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure btnEvaRiderClick(Sender: TObject);
    procedure tteAcceptGoodsExecute(ATimerTask: TTimerTask);
    procedure tteAcceptGoodsExecuteEnd(ATimerTask: TTimerTask);
    procedure tteAcceptGoodsBegin(ATimerTask: TTimerTask);
    procedure tteNoticeShoperAcceptedExecute(ATimerTask: TTimerTask);
    procedure tteNoticeShoperAcceptedExecuteEnd(ATimerTask: TTimerTask);
    procedure tteNoticeShoperAcceptedBegin(ATimerTask: TTimerTask);
    procedure btnReturnClick(Sender: TObject);
    procedure FrameContext1Load(Sender: TObject);
  private
    //用户订单列表
    FUserOrderList:TOrderList;
    //用户配送列表
    FDeliverOrderList:TDeliveryOrderList;
    //用户购物车商品列表
    FCarGoodList:TCarGoodList;
    FPageIndex:Integer;

    FOrder:TOrder;

    //按钮筛选
    FFilterButton:String;

    FOrderFid:Integer;
    //获取订单列表
    procedure DoGetUserOrderListExecute(ATimerTask:TObject);
    procedure DoGetUserOrderListExecuteEnd(ATimerTask:TObject);
    //获取配送单列表
    procedure DoGetDeliverOrderListExecute(ATimerTask:TObject);
    procedure DoGetDeliverOrderListExecuteEnd(ATimerTask:TObject);
  private
    //从评价页面返回
    procedure OnReturnFromEvalvateFrame(AFrame:TFrame);
    //从订单详情返回
    procedure OnReturnFromOrderInfoFrame(AFrame:TFrame);
  private
    FFilterShopFID:Integer;
    FFilterGoodFID:Integer;
    FFilterGoodsSpecFID:Integer;
    FFilterNumber:Integer;
    FFilterOrderno:Double;
    FFilterGoodsAttrValue:String;
    //添加购物车
    procedure DoAddUserCarExecute(ATimerTask:TObject);
    procedure DoAddUserCarExecuteEnd(ATimerTask:TObject);

  private
    //获取订单详情
    procedure DoGetOrderInfoExecute(ATimerTask:TObject);
    procedure DoGetOrderInfoExecuteEnd(ATimerTask:TObject);
  private
    //再次下单返回
    procedure OnReturnFromShopInfoFrame(AFrame:TFrame);
    //去支付返回
    procedure OnFromPayOrderFrame(AFrame:TFrame);
    { Private declarations }
  public
    FTitle:String;
    //未登录时跳到注册界面会用到
//    FHelpText:String;

    procedure Clear;
    //加载
    procedure Init;

  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalUserOrderListFrame:TFrameUserOrderList;

implementation

{$R *.fmx}
uses
  LoginFrame,
  OrderInfoFrame,
  EvalvateFrame,
  PayOrderFrame,
  MainForm,
  ShopInfoFrame,
  MainFrame;

{ TFrameUserOrderList }

procedure TFrameUserOrderList.btnBookClick(Sender: TObject);
var
  AOrder:TOrder;
begin
  AOrder:=TOrder(Self.lbOrderList.Prop.InteractiveItem.Data);


  FOrderFid:=AOrder.fid;

  if AOrder.order_state=Const_OrderState_WaitPay then
  begin
    FFilterButton:='Pay';
    //获取订单详情
    uTimerTask.GetGlobalTimerThread.RunTempTask(
             DoGetOrderInfoExecute,
             DoGetOrderInfoExecuteEnd,
             'GetOrderInfo');
  end;

  if AOrder.order_state=Const_OrderState_Sent then
  begin
    FFilterButton:='Receive';
    //用户确认收货操作
    Self.tteAcceptGoods.Run;
  end;

  if AOrder.order_state=Const_OrderState_Payed then
  begin
    FFilterButton:='notice';
    //催单操作
    Self.tteNoticeShoperAccepted.Run;
  end;

  if AOrder.order_state=Const_OrderState_Done then
  begin
    if AOrder.is_user_evaluated=0 then
    begin

      //隐藏
      HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

      //显示评价页面
      ShowFrame(TFrame(GlobalEvalvateFrame),TFrameEvalvate,OnReturnFromEvalvateFrame);
//      GlobalEvalvateFrame.FrameHistroy:=CurrentFrameHistroy;
      GlobalEvalvateFrame.Load(AOrder.fid,ShopCenterInterfaceUrl);
    end
    else
    begin
      //再来一单
      FFilterButton:='more';

      FOrderFid:=AOrder.fid;
      //获取订单详情
      uTimerTask.GetGlobalTimerThread.RunTempTask(
               DoGetOrderInfoExecute,
               DoGetOrderInfoExecuteEnd,
               'GetOrderInfo');
    end;
  end;

end;

procedure TFrameUserOrderList.btnContinueClick(Sender: TObject);
var
  AOrder:TOrder;
  ACarGood:TCarGood;
  I: Integer;
begin
  AOrder:=TOrder(Self.lbOrderList.Prop.InteractiveItem.Data);

  FFilterButton:='more';

  FOrderFid:=AOrder.fid;
  //获取订单详情
  uTimerTask.GetGlobalTimerThread.RunTempTask(
           DoGetOrderInfoExecute,
           DoGetOrderInfoExecuteEnd,
           'GetOrderInfo');
//  //加载店铺详情
//  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//  ShowFrame(TFrame(GlobalShopInfoFrame),TFrameShopInfo,OnReturnFromShopInfoFrame);
//  GlobalShopInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalShopInfoFrame.Clear;
//  GlobalShopInfoFrame.Load(AOrder.shop_fid,nil)



end;

procedure TFrameUserOrderList.btnEvaRiderClick(Sender: TObject);
var
  ADeliverOrder:TDeliveryOrder;
begin
   ADeliverOrder:=TDeliveryOrder(Self.lbDeliver.Prop.InteractiveItem.Data);
  //评价骑手
  //隐藏
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

  //显示评价页面
  ShowFrame(TFrame(GlobalEvalvateFrame),TFrameEvalvate);
//  GlobalEvalvateFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalEvalvateFrame.Load(ADeliverOrder.fid,DeliveryCenterInterfaceUrl);
end;

procedure TFrameUserOrderList.btnLoginClick(Sender: TObject);
begin
  //现在这个不起作用了
  if Not GlobalManager.IsLogin then
  begin
      //如果没有登录,去登录
      //隐藏
      HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
      //显示登录页面
      ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
  //    GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
      //清除输入框
      GlobalLoginFrame.Clear;//(Const_APPLoginType);//Self.FHelpText);
  end
  else
  begin
      //最近没有下单,去下单,显示主页面
      GlobalMainFrame.pcMain.prop.ActivePage:=GlobalMainFrame.tsHome;
  end;
end;

procedure TFrameUserOrderList.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame(Self);

end;

procedure TFrameUserOrderList.btnShopNameClick(Sender: TObject);
var
  AOrder:TOrder;
begin
  AOrder:=TOrder(Self.lbOrderList.Prop.InteractiveItem.Data);

  //加载店铺详情
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  ShowFrame(TFrame(GlobalShopInfoFrame),TFrameShopInfo,OnReturnFromShopInfoFrame);
//  GlobalShopInfoFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalShopInfoFrame.Clear;
  GlobalShopInfoFrame.IsShowBackBtn;
  GlobalShopInfoFrame.Load(AOrder.shop_fid,nil,GlobalShopInfoFrame)



end;

procedure TFrameUserOrderList.Clear;
begin
  Self.lbOrderList.Prop.Items.BeginUpdate;
  try
    Self.lbOrderList.Prop.Items.Clear(True);
  finally
    Self.lbOrderList.Prop.Items.EndUpdate;
  end;


  Self.lbDeliver.Prop.Items.BeginUpdate;
  try
    Self.lbDeliver.Prop.Items.Clear(True);
  finally
    Self.lbDeliver.Prop.Items.EndUpdate;
  end;


  FCarGoodList.Clear(True);


  FFilterButton:='';

  FFilterShopFID:=0;
  FFilterGoodFID:=0;
  FFilterGoodsSpecFID:=0;
  FFilterNumber:=0;
  FFilterOrderno:=0;
  FFilterGoodsAttrValue:='';

end;

constructor TFrameUserOrderList.Create(AOwner: TComponent);
begin
  inherited;
  FUserOrderList:=TOrderList.Create;

  FCarGoodList:=TCarGoodList.Create;

  FDeliverOrderList:=TDeliveryOrderList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  FTitle:=Trans('外卖');
//  //外卖默认是邮箱注册
//  Self.FHelpText:=Const_RegisterLoginType_Email;


  Self.lbOrderList.Prop.Items.BeginUpdate;
  try
    Self.lbOrderList.Prop.Items.Clear(True);
  finally
    Self.lbOrderList.Prop.Items.EndUpdate;
  end;


  Self.lbDeliver.Prop.Items.BeginUpdate;
  try
    Self.lbDeliver.Prop.Items.Clear(True);
  finally
    Self.lbDeliver.Prop.Items.EndUpdate;
  end;




  Self.pnlToolBar.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=SkinThemeColor;
  Self.btnLogin.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=SkinThemeColor;
end;

destructor TFrameUserOrderList.Destroy;
begin
  FreeAndNil(FUserOrderList);

  FreeAndNil(FCarGoodList);

  FreeAndNil(FDeliverOrderList);
  inherited;
end;


procedure TFrameUserOrderList.DoAddUserCarExecute(ATimerTask: TObject);
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
          Self.FFilterShopFID:=FOrder.OrderGoodsList[I].shop_fid;
          Self.FFilterGoodFID:=FOrder.OrderGoodsList[I].shop_goods_fid;
          Self.FFilterGoodsSpecFID:=FOrder.OrderGoodsList[I].shop_goods_spec_fid;
          Self.FFilterNumber:=FOrder.OrderGoodsList[I].number;
          Self.FFilterOrderno:=FOrder.OrderGoodsList[I].orderno;
          Self.FFilterGoodsAttrValue:=FOrder.OrderGoodsList[I].shop_goods_attrs;



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
                                                          FFilterShopFID,
                                                          GlobalManager.User.key,
                                                          FFilterGoodFID,
                                                          FFilterGoodsSpecFID,
                                                          FFilterNumber,
                                                          FFilterOrderno,
                                                          FFilterGoodsAttrValue
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

//              if GlobalManager.UserCartGoodsList.FindItemByFID(ACarGood.fid)<>nil then
//              begin
//                GlobalManager.UserCartGoodsList.FindItemByFID(ACarGood.fid).number:=ACarGood.number;
//              end
//              else
//              begin
//                GlobalManager.UserCartGoodsList.Add(ACarGood);
//              end;

              GlobalManager.Save;


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

procedure TFrameUserOrderList.DoAddUserCarExecuteEnd(ATimerTask: TObject);
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
        HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
        ShowFrame(TFrame(GlobalShopInfoFrame),TFrameShopInfo,OnReturnFromShopInfoFrame);
//        GlobalShopInfoFrame.FrameHistroy:=CurrentFrameHistroy;
        GlobalShopInfoFrame.Clear;
        GlobalShopInfoFrame.IsShowBackBtn;
        GlobalShopInfoFrame.Load(FOrder.shop_fid,FCarGoodList,GlobalShopInfoFrame);



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

procedure TFrameUserOrderList.DoGetDeliverOrderListExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('user_get_order_list',
                                                      nil,
                                                      DeliveryCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'filter_order_state',
                                                      'filter_is_need_customer_service',
                                                      'filter_is_shop_center_order',
                                                      'pageindex',
                                                      'pagesize'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      '',
                                                      '',
                                                      '0',
                                                      FPageIndex,
                                                      20],
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

procedure TFrameUserOrderList.DoGetDeliverOrderListExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AOrderList:TDeliveryOrderList;
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
  ASendAddrHeight:Double;
  ARecvAddrHeight:Double;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取成功

        ASendAddrHeight:=0;
        ARecvAddrHeight:=0;

        if Self.FPageIndex=1 then
        begin
          FDeliverOrderList.Clear(True);
          Self.lbDeliver.Prop.Items.Clear(True);
        end;

        AOrderList:=TDeliveryOrderList.Create(ooReference);
        AOrderList.ParseFromJsonArray(TDeliveryOrder,ASuperObject.O['Data'].A['UserOrderList']);

        Self.lbDeliver.Prop.Items.BeginUpdate;
        try
          for I := 0 to AOrderList.Count-1 do
          begin
            AListBoxItem:=Self.lbDeliver.Prop.Items.Add;
            AListBoxItem.Data:=AOrderList[I];
            FDeliverOrderList.Add(AOrderList[I]);
            if (AOrderList[I].order_state=Const_OrderState_Done) or
                (AOrderList[I].order_state=Const_OrderState_WaitPay) then
            begin
              AListBoxItem.Height:=210;
            end
            else
            begin
              AListBoxItem.Height:=179;
            end;
            AListBoxItem.Caption:=AOrderList[I].goods_name;
            AListBoxItem.Detail:=GetUserOrderStateStr(AOrderList[I].order_state);
            AListBoxItem.Detail1:='取送件';
            AListBoxItem.Icon.ImageIndex:=1;
            AListBoxItem.Pic.ImageIndex:=0;
            AListBoxItem.Detail2:=AOrderList[I].send_addr+' '+AOrderList[I].send_door_no;
            AListBoxItem.Detail3:=AOrderList[I].recv_addr+' '+AOrderList[I].recv_door_no;
            AListBoxItem.Detail4:=AOrderList[I].createtime;

            ASendAddrHeight:=uSkinBufferBitmap.GetStringHeight(AOrderList[I].send_addr+' '+AOrderList[I].send_door_no,
                                   RectF(20,0,Self.Width-10,MaxInt),
                                   Self.lblDetail1.SelfOwnMaterialToDefault.DrawCaptionParam)+10;

            ARecvAddrHeight:=uSkinBufferBitmap.GetStringHeight(AOrderList[I].recv_addr+' '+AOrderList[I].recv_door_no,
                                   RectF(20,0,Self.Width-10,MaxInt),
                                   Self.lblItemSetail1.SelfOwnMaterialToDefault.DrawCaptionParam)+10;

          end;
        finally
          Self.lbDeliver.Prop.Items.EndUpdate();
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
    //停止刷新
    if FPageIndex>1 then
    begin
      if (TTimerTask(ATimerTask).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['UserOrderList'].Length>0) then
      begin
        Self.lbDeliver.Prop.StopPullUpLoadMore('加载成功!',0,True);
      end
      else
      begin
        Self.lbDeliver.Prop.StopPullUpLoadMore('下面没有了!',600,False);
      end;
    end
    else
    begin
      Self.lbDeliver.Prop.StopPullDownRefresh('刷新成功!',600);
    end;
  end;
end;

procedure TFrameUserOrderList.DoGetOrderInfoExecute(ATimerTask: TObject);
begin
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

procedure TFrameUserOrderList.DoGetOrderInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AOrder:TOrder;
  ACarGood:TCarGood;
  I:Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

      FMX.Types.Log.d('OrangeUI ASuperObject'+ASuperObject.AsJSON);
      if ASuperObject.I['Code']=200 then
      begin

        try
//          FUserOrderList.Clear(True);
          AOrder:=TOrder.Create;
          //刷新订单信息
          AOrder.ParseFromJson(ASuperObject.O['Data'].A['OrderInfo'].O[0]);


          if FFilterButton='Pay' then
          begin
            //隐藏
            HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

            //显示用户信息
            ShowFrame(TFrame(GlobalPayOrderFrame),TFramePayOrder,OnFromPayOrderFrame);
//            GlobalPayOrderFrame.FrameHistroy:=CurrentFrameHistroy;
            GlobalPayOrderFrame.Load(AOrder,False);
          end;

          if FFilterButton='more' then
          begin

            Self.FOrder:=AOrder;

            for I := 0 to FOrder.OrderGoodsList.Count-1 do
            begin
              if FOrder.shop_fid=FOrder.OrderGoodsList[I].shop_fid then
              begin
                Self.FFilterShopFID:=FOrder.OrderGoodsList[I].shop_fid;
                Self.FFilterGoodFID:=FOrder.OrderGoodsList[I].shop_goods_fid;
                Self.FFilterGoodsSpecFID:=FOrder.OrderGoodsList[I].shop_goods_spec_fid;
                Self.FFilterNumber:=FOrder.OrderGoodsList[I].number;
                Self.FFilterOrderno:=FOrder.OrderGoodsList[I].orderno;
                Self.FFilterGoodsAttrValue:=FOrder.OrderGoodsList[I].shop_goods_attrs;


                GlobalMainFrame.AddGoodsToUserCart(FFilterShopFID,
                                                   FFilterGoodFID,
                                                   FFilterGoodsSpecFID,
                                                   FFilterNumber,
                                                   FFilterGoodsAttrValue,
                                                   FFilterOrderno);
              end;
            end;


            //加载店铺详情
            HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
            ShowFrame(TFrame(GlobalShopInfoFrame),TFrameShopInfo,OnReturnFromShopInfoFrame);
//            GlobalShopInfoFrame.FrameHistroy:=CurrentFrameHistroy;
            GlobalShopInfoFrame.Clear;
            GlobalShopInfoFrame.IsShowBackBtn;
            GlobalShopInfoFrame.Load(FOrder.shop_fid,FCarGoodList,GlobalShopInfoFrame);


//            uTimerTask.GetGlobalTimerThread.RunTempTask(
//                        DoAddUserCarExecute,
//                        DoAddUserCarExecuteEnd);

          end;


        finally
//           FreeAndNil(AOrder);
        end;

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


procedure TFrameUserOrderList.DoGetUserOrderListExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_user_order_list',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'filter_order_state',
                                                      'pageindex',
                                                      'pagesize'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      '',
                                                      FPageIndex,
                                                      20],
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

procedure TFrameUserOrderList.DoGetUserOrderListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
  AOrderList:TOrderList;
  AWidth:Double;
  ADetailWidth:Double;
begin
  AWidth:=0;
  ADetailWidth:=0;
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取成功

        if (Self.FPageIndex=1) and (ASuperObject.O['Data'].A['UserOrderList'].Length<1) then
        begin
          Self.pcOrder.Prop.ActivePage:=Self.tsLogin;
          Self.lblLogin.Caption:='最近没有订单';
          Self.btnLogin.Caption:='去下单';
        end
        else
        begin
          Self.pcOrder.Prop.ActivePage:=Self.tsOrderList;

          if Self.FPageIndex=1 then
          begin
            FUserOrderList.Clear(True);
            Self.lbOrderList.Prop.Items.Clear(True);
          end;

          AOrderList:=TOrderList.Create(ooReference);

          AOrderList.ParseFromJsonArray(TOrder,ASuperObject.O['Data'].A['UserOrderList']);

          Self.lbOrderList.Prop.Items.BeginUpdate;
          try
            for I := 0 to AOrderList.Count-1 do
            begin
              AListBoxItem:=Self.lbOrderList.Prop.Items.Add;
              Self.FUserOrderList.Add(AOrderList[I]);
              AListBoxItem.Data:=AOrderList[I];
              if (AOrderList[I].order_state=Const_OrderState_Done) or
                (AOrderList[I].order_state=Const_OrderState_WaitPay) then
              begin
                AListBoxItem.Height:=150;
              end
              else
              begin
                AListBoxItem.Height:=120;
              end;
              AListBoxItem.Caption:=AOrderList[I].shop_name;

              AListBoxItem.Icon.Url:=AOrderList[I].GetShopLogoPicUrl;
              AListBoxItem.Detail:=GetUserOrderStateStr(AOrderList[I].order_state_for_display,False);

              //订单取消原因
              if AOrderList[I].order_state=Const_OrderState_Cancelled then
                 AListBoxItem.Detail5:=AOrderList[I].cancel_reason;
              if AOrderList[I].order_state=Const_OrderState_Reject then
                 AListBoxItem.Detail5:=AOrderList[I].reject_reason;
              if Trim(AListBoxItem.Detail5)='' then AListBoxItem.Detail5:='未填写原因';


              //加了骑手端   暂时都用发货
              if (AListBoxItem.Detail='商家已出发')
              AND (AOrderList[I].deliver_type=Const_DeliverType_Express) then
                AListBoxItem.Detail:='商家已发货';


              ADetailWidth:=uSkinBufferBitmap.GetStringWidth(GetUserOrderStateStr(AOrderList[I].order_state),Self.lblState.Material.DrawCaptionParam.FontSize);

              if AOrderList[I].goods_type_num>1 then
              begin
                AListBoxItem.Detail2:=AOrderList[I].goods_name+'等'+IntToStr(AOrderList[I].goods_type_num)+'件商品';
              end
              else if AOrderList[I].goods_type_num=1 then
              begin
                AListBoxItem.Detail2:=AOrderList[I].goods_name;
              end
              else
              begin
                AListBoxItem.Detail2:='您没有选购商品';
              end;

              //时间(共计时间)

              AListBoxItem.Detail1:=GetTime(AOrderList[I].createtime);

              AListBoxItem.Detail3:='￥'+Format('%.2f',[AOrderList[I].sum_money]);

              AWidth:=0;

              AWidth:=uSkinBufferBitmap.GetStringWidth(AOrderList[I].shop_name,Self.btnShopName.Material.DrawCaptionParam.FontSize)+20;

              if AWidth>(Self.Width-ADetailWidth-65-5) then
              begin
                AListBoxItem.Detail6:=FloatToStr(Self.Width-ADetailWidth-65-5);
              end
              else
              begin
                AListBoxItem.Detail6:=FloatToStr(AWidth);
              end;
            end;
          finally
            Self.lbOrderList.Prop.Items.EndUpdate();
          end;

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
    //停止刷新
    if FPageIndex>1 then
    begin
        if (TTimerTask(ATimerTask).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['UserOrderList'].Length>0) then
        begin
          Self.lbOrderList.Prop.StopPullUpLoadMore('加载成功!',0,True);
        end
        else
        begin
          Self.lbOrderList.Prop.StopPullUpLoadMore('下面没有了!',600,False);
        end;
    end
    else
    begin
        Self.lbOrderList.Prop.StopPullDownRefresh('刷新成功!',600);
    end;

  end;
end;


procedure TFrameUserOrderList.FrameContext1Load(Sender: TObject);
begin
  if GlobalManager.IsLogin=False then
  begin
//    Self.tsLogin.Prop.TabVisible:=True;
//    //显示登录页
//    Self.pcOrder.Prop.ActivePage:=Self.tsLogin;
//
//    Self.lblLogin.Caption:='登录后查看'+FTitle+'订单';
//    Self.btnLogin.Caption:='立即登录';
//
//
//    Self.tsOrderList.Prop.TabVisible:=False;
//    Self.tsDeliverOrderList.Prop.TabVisible:=False;
//
//    Self.pcOrder.Prop.TabHeaderHeight:=0;
//
//    Self.lbOrderList.Visible:=False;
  end
  else
  begin
    //获取用户订单列表
    Self.Clear;

    Self.tsOrderList.Prop.TabVisible:=True;

    Self.pcOrder.Prop.ActivePage:=Self.tsOrderList;
    Self.pcOrder.OnChange(Self.pcOrder);

    Self.tsLogin.Prop.TabVisible:=False;

    Self.tsDeliverOrderList.Prop.TabVisible:=False;

    Self.lbOrderList.Visible:=True;

//    if Not DirectoryExists('E:\MyFiles') then
//    begin
      Self.tsDeliverOrderList.Prop.TabVisible:=False;
      Self.pcOrder.Prop.TabHeaderHeight:=0;
//    end
//    else
//    begin
//      Self.tsDeliverOrderList.Prop.TabVisible:=True;
//      Self.pcOrder.Prop.TabHeaderHeight:=40;
//    end;

    Self.lbOrderList.Prop.StartPullDownRefresh;

  end;
end;

procedure TFrameUserOrderList.idpOrderResize(Sender: TObject);
begin

  Self.btnContinue.Left:=Self.Width-81*2-20;

  Self.btnBook.Left:=Self.Width-91;

end;

procedure TFrameUserOrderList.Init;
begin
  if GlobalManager.IsLogin=False then
  begin
    Self.tsLogin.Prop.TabVisible:=True;
    //显示登录页
    Self.pcOrder.Prop.ActivePage:=Self.tsLogin;

    Self.lblLogin.Caption:='登录后查看'+FTitle+'订单';
    Self.btnLogin.Caption:='立即登录';


    Self.tsOrderList.Prop.TabVisible:=False;
    Self.tsDeliverOrderList.Prop.TabVisible:=False;

    Self.pcOrder.Prop.TabHeaderHeight:=0;

    Self.lbOrderList.Visible:=False;
  end
  else
  begin
//    //获取用户订单列表
//    Self.Clear;
//
//    Self.tsOrderList.Prop.TabVisible:=True;
//
//    Self.pcOrder.Prop.ActivePage:=Self.tsOrderList;
//    Self.pcOrder.OnChange(Self.pcOrder);
//
//    Self.tsLogin.Prop.TabVisible:=False;
//
//    Self.tsDeliverOrderList.Prop.TabVisible:=False;
//
//    Self.lbOrderList.Visible:=True;
//
////    if Not DirectoryExists('E:\MyFiles') then
////    begin
//      Self.tsDeliverOrderList.Prop.TabVisible:=False;
//      Self.pcOrder.Prop.TabHeaderHeight:=0;
////    end
////    else
////    begin
////      Self.tsDeliverOrderList.Prop.TabVisible:=True;
////      Self.pcOrder.Prop.TabHeaderHeight:=40;
////    end;
//
//    Self.lbOrderList.Prop.StartPullDownRefresh;

  end;
end;

procedure TFrameUserOrderList.lbDeliverPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  ADeliverOrder:TDeliveryOrder;
begin
  if AItem.Data<>nil then
  begin
    ADeliverOrder:=TDeliveryOrder(AItem.Data);
    if (ADeliverOrder.send_user_fid='0') or (ADeliverOrder.send_user_fid='') then
    begin
      Self.lblDetail2.Visible:=False;
      Self.lblDetail3.Visible:=False;
    end
    else
    begin
      Self.lblDetail2.Visible:=True;
      Self.lblDetail3.Visible:=True;

      Self.lblDetail2.Caption:=ADeliverOrder.send_name;
      Self.lblDetail3.Caption:=ADeliverOrder.send_phone;
    end;

    Self.lblItemSetail2.Caption:=ADeliverOrder.recv_name;
    Self.lblItemSetail3.Caption:=ADeliverOrder.recv_phone;

    if ADeliverOrder.order_state=Const_OrderState_Done then
    begin
      if ADeliverOrder.is_sender_evaluated=0 then
      begin
        Self.btnAgainBuy.Visible:=True;
        Self.btnEvaRider.Visible:=True;
        Self.btnEvaRider.Caption:='评价';

        Self.btnEvaRider.SelfOwnMaterialToDefault.BackColor.BorderColor.FColor:=TAlphaColorRec.Red;
        Self.btnEvaRider.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;


        Self.lblState.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Black;
      end
      else
      begin
        Self.btnAgainBuy.Visible:=False;
        Self.btnEvaRider.Visible:=True;

        Self.btnEvaRider.Caption:='再来一单';
        Self.btnEvaRider.SelfOwnMaterialToDefault.BackColor.BorderColor.FColor:=SkinThemeColor;
        Self.btnEvaRider.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;

        Self.lblState.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Black;

      end;
    end
    else if ADeliverOrder.order_state=Const_OrderState_WaitPay then
    begin
      Self.btnAgainBuy.Visible:=False;
      Self.btnEvaRider.Visible:=True;
      Self.btnEvaRider.Caption:='去付款';

      Self.btnEvaRider.SelfOwnMaterialToDefault.BackColor.BorderColor.FColor:=TAlphaColorRec.Red;
      Self.btnEvaRider.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;


      Self.lblState.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
    end
    else
    begin
      Self.btnAgainBuy.Visible:=False;
      Self.btnEvaRider.Visible:=False;
      Self.lblState.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
    end;
  end;
end;

procedure TFrameUserOrderList.lbDeliverPullDownRefresh(Sender: TObject);
begin
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoGetDeliverOrderListExecute,
                 DoGetDeliverOrderListExecuteEnd,
                 'GetDeliverOrderList');
end;

procedure TFrameUserOrderList.lbDeliverPullUpLoadMore(Sender: TObject);
begin
  FPageIndex:=FPageIndex+1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoGetDeliverOrderListExecute,
                 DoGetDeliverOrderListExecuteEnd,
                 'GetDeliverOrderList');
end;

procedure TFrameUserOrderList.lbOrderListClickItem(AItem: TSkinItem);
begin
  FMX.Types.Log.d('OrangeUI OrderInfo');
  //查看订单详情
  HideFrame;//();

  ShowFrame(TFrame(GlobalOrderInfoFrame),TFrameOrderInfo,OnReturnFromOrderInfoFrame);
//  GlobalOrderInfoFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalOrderInfoFrame.Load(TOrder(AItem.Data));
  GlobalOrderInfoFrame.Sync;
end;

procedure TFrameUserOrderList.lbOrderListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AOrder:TOrder;
begin
  if AItem.Data<>nil then
  begin
    AOrder:=TOrder(AItem.Data);

    Self.btnShopName.Width:=StrToFloat(AItem.Detail6);

    if AOrder.order_state=Const_OrderState_Done then
    begin
      if AOrder.is_user_evaluated=0 then
      begin
        Self.btnContinue.Visible:=True;
        Self.btnBook.Visible:=True;  //评价显示
        Self.btnBook.Caption:='评价';
        Self.btnBook.Position.Y:=AItem.Height-38;
        //不显示评价时  修改再来一单的位置
//        Self.btnContinue.Left:=Self.Width-91;

        Self.btnBook.SelfOwnMaterialToDefault.BackColor.BorderColor.FColor:=TAlphaColorRec.Red;
        Self.btnBook.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;


        Self.lblState.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Black;
      end
      else
      begin
        Self.btnContinue.Visible:=False;
        Self.btnBook.Visible:=True;

        Self.btnBook.Caption:='再来一单';
        Self.btnBook.SelfOwnMaterialToDefault.BackColor.BorderColor.FColor:=SkinThemeColor;
        Self.btnBook.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;

        Self.lblState.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Black;

      end;
    end
    else if AOrder.order_state=Const_OrderState_WaitPay then
    begin
      Self.btnContinue.Visible:=False;
      Self.btnBook.Visible:=True;
      Self.btnBook.Caption:='去付款';

      Self.btnBook.SelfOwnMaterialToDefault.BackColor.BorderColor.FColor:=TAlphaColorRec.Red;
      Self.btnBook.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;


      Self.lblState.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
    end
    //商家未接单  催单
    else if AOrder.order_state=Const_OrderState_Payed then
    begin
      Self.btnContinue.Visible:=False;
      Self.btnBook.Visible:=True;
      Self.btnBook.Caption:='催单';
      Self.btnBook.Position.Y:=AItem.Height-38;

      Self.btnBook.SelfOwnMaterialToDefault.BackColor.BorderColor.FColor:=TAlphaColorRec.Red;
      Self.btnBook.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;


      Self.lblState.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
    end
    else
    begin
      Self.btnContinue.Visible:=False;
      Self.btnBook.Visible:=False;
      Self.lblState.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;

      //其他状态  已接单  并且配送方式是快递的   显示确认收货  Const_DeliverType_Express
      //((AOrder.order_state=Const_OrderState_Accepted) OR (
      if (AOrder.deliver_type=Const_DeliverType_Express)
      AND (AOrder.order_state=Const_OrderState_Sent) then
      begin
        Self.btnBook.Visible:=True;
        //不知道为什么跑起来  Y会往下跑
        Self.btnBook.Position.Y:=AItem.Height-38;
        Self.btnBook.Caption:='确认收货';
        Self.btnBook.SelfOwnMaterialToDefault.BackColor.BorderColor.FColor:=SkinThemeColor;
        Self.btnBook.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;
      end;
    end;

    //订单取消或拒绝
    Self.lblCancelReason.Visible:=False;
    if (AOrder.order_state=Const_OrderState_Reject)
    OR (AOrder.order_state=Const_OrderState_Cancelled) then
        Self.lblCancelReason.Visible:=True;

  end;

end;

procedure TFrameUserOrderList.lbOrderListPullDownRefresh(Sender: TObject);
begin
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoGetUserOrderListExecute,
                 DoGetUserOrderListExecuteEnd,
                 'GetUserOrderList');
end;

procedure TFrameUserOrderList.lbOrderListPullUpLoadMore(Sender: TObject);
begin
  FPageIndex:=FPageIndex+1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoGetUserOrderListExecute,
                 DoGetUserOrderListExecuteEnd,
                 'GetUserOrderList');
end;

procedure TFrameUserOrderList.OnFromPayOrderFrame(AFrame: TFrame);
begin
  //刷新
  Self.lbOrderList.Prop.StartPullDownRefresh;
end;

procedure TFrameUserOrderList.OnReturnFromEvalvateFrame(AFrame: TFrame);
begin
  Clear;

  Self.lbOrderList.Prop.StartPullDownRefresh;
end;

procedure TFrameUserOrderList.OnReturnFromOrderInfoFrame(AFrame: TFrame);
begin
  //刷新
  Self.lbOrderList.Prop.StartPullDownRefresh;
end;

procedure TFrameUserOrderList.OnReturnFromShopInfoFrame(AFrame: TFrame);
begin
  //刷新
  Self.lbOrderList.Prop.StartPullDownRefresh;
end;

procedure TFrameUserOrderList.pcOrderChange(Sender: TObject);
begin

  if Self.pcOrder.Prop.ActivePage=Self.tsOrderList then
  begin
    Self.lbOrderList.Prop.StartPullDownRefresh;
  end;

  if Self.pcOrder.Prop.ActivePage=Self.tsDeliverOrderList then
  begin
    Self.lbDeliver.Prop.StartPullDownRefresh;
  end;
end;

procedure TFrameUserOrderList.tteAcceptGoodsBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,'确认中...');
end;

procedure TFrameUserOrderList.tteAcceptGoodsExecute(ATimerTask: TTimerTask);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
      SimpleCallAPI('user_get_goods',
                    nil,
                    UserCenterInterfaceUrl,
                    ['appid',
                    'user_fid',
                    'key',
                    'order_fid'],
                    [AppID,
                    GlobalManager.User.fid,   //用户确认收货
                    GlobalManager.User.key,
                    FOrderFid
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

procedure TFrameUserOrderList.tteAcceptGoodsExecuteEnd(ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;

  AIntroducerFID:Integer;
  AOrderFID,AShopFID:Integer;
  AGiftScore:Double;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin

      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //确认收货成功
        Self.lbOrderList.Prop.StartPullDownRefresh;
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

procedure TFrameUserOrderList.tteNoticeShoperAcceptedBegin(
  ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,'催单中...');
end;

procedure TFrameUserOrderList.tteNoticeShoperAcceptedExecute(
  ATimerTask: TTimerTask);
begin
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
      SimpleCallAPI('notice_user',
                    nil,
                    UserCenterInterfaceUrl,
                    ['appid',
                    'user_fid',
                    'key',
                    'sender_fid',
                    'notice_classify',
                    'notice_sub_type',
                    'caption',
                    'content',
                    'custom_data_json'],
                    [AppID,
                    TOrder(Self.lbOrderList.Prop.InteractiveItem.Data).shoper_fid,  //ShoperFID,
                    GlobalManager.User.key,
                    GlobalManager.User.fid,
                    Const_NoticeCalssify_Order,
                    Const_NoticeSubType_NoticeShoperAccept,
                    '快来接单了',
                    '有用户催单了,请查看!',
                    '{"order_fid":'+IntToStr(FOrderFid)+',"notice_sub_type":"'+Const_NoticeSubType_NoticeShoperAccept+'"}'
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

procedure TFrameUserOrderList.tteNoticeShoperAcceptedExecuteEnd(
  ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin

      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //催单成功
        ShowMessageBoxFrame(Self,'催单成功!');
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
