unit HelpBuySomethingFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uUIFunction,
  Math,
//  uOpenCommon,
  uDrawCanvas,

//  uOpenClientCommon,
  uSkinBufferBitmap,
  uMapCommon,
  uGPSUtils,
  uSkinItems,
  WaitingFrame,
  MessageBoxFrame,
  PopupMenuFrame,
  uManager,
  uOpenClientCommon,
  uOpenCommon,
  uDataSetToJson,
  uTimerTask,

  uLang,

  XSuperObject,
  XSuperJson,
  System.DateUtils,
  uFuncCommon,
  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollControlType,
  uSkinScrollBoxType, uSkinFireMonkeyScrollBox, uSkinScrollBoxContentType,
  uSkinFireMonkeyScrollBoxContent, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Memo, uSkinFireMonkeyMemo, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType, uSkinFireMonkeyListView, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinListBoxType, uSkinFireMonkeyListBox,
  uSkinLabelType, uSkinFireMonkeyLabel, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel;

type
  TFrameHelpBuySomething = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcContent: TSkinFMXScrollBoxContent;
    memoGoods: TSkinFMXMemo;
    lvGoods: TSkinFMXListView;
    idpGood: TSkinFMXItemDesignerPanel;
    lblName: TSkinFMXLabel;
    pnlGoodsMoney: TSkinFMXPanel;
    lblDetail: TSkinFMXLabel;
    btnMoney: TSkinFMXButton;
    pnlBuy: TSkinFMXPanel;
    pnlSelect: TSkinFMXPanel;
    btnAppoint: TSkinFMXButton;
    btnRandom: TSkinFMXButton;
    btnSelectAddr: TSkinFMXButton;
    pnlstar: TSkinFMXPanel;
    btnStar: TSkinFMXButton;
    pnlCoupon: TSkinFMXPanel;
    lblCoupon: TSkinFMXLabel;
    btnCoupon: TSkinFMXButton;
    pnlMome: TSkinFMXPanel;
    lblRemark: TSkinFMXLabel;
    edtRemark: TSkinFMXEdit;
    pnlTakeOrder: TSkinFMXPanel;
    btnTake: TSkinFMXButton;
    mclDistance: TSkinFMXMultiColorLabel;
    mclMoney: TSkinFMXMultiColorLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnRandomClick(Sender: TObject);
    procedure btnAppointClick(Sender: TObject);
    procedure btnStarClick(Sender: TObject);
    procedure btnMoneyClick(Sender: TObject);
    procedure lvGoodsClickItem(AItem: TSkinItem);
    procedure btnSelectAddrClick(Sender: TObject);
    procedure btnCouponClick(Sender: TObject);
    procedure btnTakeClick(Sender: TObject);
  private
    //预估金额
    FFilterMoney:String;
    //经纬度
    FLongtitude:Double;
    FLatitude:Double;
    //地址
    FAddr:String;
    //订单类型
    FFilterOrderType:String;

    //红包
    FCouponFID:Integer;

    //接收信息
    FUserRecvAddr:TUserRecvAddr;

    FWantTakeTime:String;
    FWantArrivedTime:Integer;

    //物品重量
    FGoodsWeight:Double;
    //物品类型
    FFilterGoodClassFID:Integer;

  private
    //从选择收货地址返回
    procedure OnReturnFromRecvAddr(AFrame:TFrame);
    //预估商品金额返回
    procedure OnReturnFromEstimateGoods(AFrame:TFrame);
    //从选择地址返回
    procedure OnReturnFrameFromSetPointMapFrame(AFrame:TFrame);
    //从选择红包返回
    procedure OnReturnFromSelectedCouponFrame(AFrame:TFrame);
  private
    //预下单
    procedure PrepareOrder;
  private
    //预下单接口
    procedure DoHelpBuyPrepareOrderExecute(ATimerTask:TObject);
    procedure DoHelpBuyPrepareOrderExecuteEnd(ATimerTask:TObject);
    //下单接口
    procedure DoTakeHelpBuyOrderExecute(ATimerTask:TObject);
    procedure DoTakeHelpBuyOrderExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    //清空
    procedure Clear;
    //加载订单
    procedure Init(AText:String;
                   AHelpText:String;
                   AOrderType:String;
                   AGoodClassList:TGoodClassList);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalHelpBuySomethingFrame:TFrameHelpBuySomething;

implementation

{$R *.fmx}

uses
  MainForm,
  MainFrame,
  PayOrderFrame,
  EstimateGoodsMoneyFrame,
  TakeOrderUseCouponListFrame,
  SetGPSPointFrame,
  RecvAddrListFrame;

{ TFrameHelpBuySomething }

procedure TFrameHelpBuySomething.btnAppointClick(Sender: TObject);
begin
  Self.btnAppoint.Prop.IsPushed:=True;
  Self.btnRandom.Prop.IsPushed:=False;

  Self.btnSelectAddr.Visible:=True;
  Self.pnlBuy.Height:=80;
end;

procedure TFrameHelpBuySomething.btnCouponClick(Sender: TObject);
begin
   //选择红包
   //隐藏
   HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
   //显示个人信息页面
   ShowFrame(TFrame(GlobalTakeOrderUseCouponListFrame),TFrameTakeOrderUseCouponList,frmMain,nil,nil,OnReturnFromSelectedCouponFrame,Application);
//   GlobalTakeOrderUseCouponListFrame.FrameHistroy:=CurrentFrameHistroy;
   GlobalTakeOrderUseCouponListFrame.Clear;
   GlobalTakeOrderUseCouponListFrame.Init(nil,0);
end;

procedure TFrameHelpBuySomething.btnMoneyClick(Sender: TObject);
begin
  ShowFrame(TFrame(GlobalEstimateGoodsMoneyFrame),TFrameEstimateGoodsMoney,frmMain,nil,nil,OnReturnFromEstimateGoods,Application,True,False,ufsefNone);
  GlobalEstimateGoodsMoneyFrame.Init(FFilterMoney);
end;

procedure TFrameHelpBuySomething.btnRandomClick(Sender: TObject);
begin
  Self.btnAppoint.Prop.IsPushed:=False;
  Self.btnRandom.Prop.IsPushed:=True;

  Self.btnSelectAddr.Visible:=False;
  Self.pnlBuy.Height:=41;
end;

procedure TFrameHelpBuySomething.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameHelpBuySomething.btnSelectAddrClick(Sender: TObject);
var
  AMapAnnotation:TMapAnnotation;
begin
  //单独页面的模式
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalSetGPSPointFrame),TFrameSetGPSPoint,OnReturnFrameFromSetPointMapFrame);

  AMapAnnotation:=TMapAnnotation.Create;

  try

    AMapAnnotation.Location:=TLocation.Create(
          FLatitude,
          FLongtitude,
          gtGCJ02
          );
    AMapAnnotation.Addr:=FAddr;

    GlobalSetGPSPointFrame.Load(AMapAnnotation,
                                '所在区域',
                                '设置购买区域'
                                );



  finally
    FreeAndNil(AMapAnnotation);
  end;

end;

procedure TFrameHelpBuySomething.btnStarClick(Sender: TObject);
begin
  //选择收货地址
  //隐藏
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  //显示收货地址列表
  ShowFrame(TFrame(GlobalRecvAddrListFrame),TFrameRecvAddrList,frmMain,nil,nil,OnReturnFromRecvAddr,Application);
//  GlobalRecvAddrListFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalRecvAddrListFrame.Clear;
  GlobalRecvAddrListFrame.Load(
                            '发件地址',
                            futSelectList,
                            -1
                            );
end;

procedure TFrameHelpBuySomething.btnTakeClick(Sender: TObject);
begin
  //提交订单
  if Self.memoGoods.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入购买商品','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Self.btnAppoint.Prop.IsPushed=True then
  begin
    if Self.btnSelectAddr.Caption='' then
    begin
      ShowMessageBoxFrame(Self,'请选择购买的指定地点','',TMsgDlgType.mtInformation,['确定'],nil);
      Exit;
    end;
  end;

  if Self.btnStar.Caption='' then
  begin
    ShowMessageBoxFrame(Self,'请选择收货地址','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  ShowWaitingFrame(Self,'提交中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                    DoTakeHelpBuyOrderExecute,
                    DoTakeHelpBuyOrderExecuteEnd,
                    'TakeHelpBuyOrder');
end;

procedure TFrameHelpBuySomething.Clear;
begin
  Self.memoGoods.Text:='';

  FFilterOrderType:='';

  FLongtitude:=0;
  FLatitude:=0;
  FAddr:='';

  FFilterMoney:='';

  //红包
  FCouponFID:=0;

  FFilterGoodClassFID:=0;

  FWantArrivedTime:=0;

  Self.lvGoods.Prop.Items.Clear(True);

  Self.lvGoods.Height:=Self.lvGoods.Prop.GetContentHeight;

  Self.btnMoney.Caption:='';
  Self.btnAppoint.Prop.IsPushed:=True;
  Self.btnRandom.Prop.IsPushed:=False;

  Self.btnSelectAddr.Visible:=True;
  Self.pnlBuy.Height:=80;

  Self.btnCoupon.Caption:='';

  Self.edtRemark.Text:='';
end;

constructor TFrameHelpBuySomething.Create(AOwner: TComponent);
begin
  inherited;

  //接收信息
  FUserRecvAddr:=TUserRecvAddr.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameHelpBuySomething.Destroy;
begin
  FreeAndNil(FUserRecvAddr);
  inherited;
end;

procedure TFrameHelpBuySomething.DoHelpBuyPrepareOrderExecute(
  ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('prepare_order',
                          nil,
                          DeliveryCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'key',
                          'order_type',
                          'send_longitude',
                          'send_latitude',
                          'recv_longitude',
                          'recv_latitude',
                          'is_book',
                          'want_take_time',
                          'want_arrive_time',
                          'goods_name',
                          'goods_money',
                          'is_need_pay_goods_money',
                          'goods_weight',
                          'goods_length',
                          'goods_width',
                          'goods_height',
                          'weather_type',
                          'use_coupon_fid',
                          'is_used_score'],
                          [AppID,
                          GlobalManager.User.fid,
                          GlobalManager.User.key,
                          FFilterOrderType,
                          FLongtitude,
                          FLatitude,
                          FUserRecvAddr.longitude,
                          FUserRecvAddr.latitude,
                          0,
                          '',
                          FWantArrivedTime,
                          '',
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          GlobalManager.WeatherType,
                          0,
                          0
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

procedure TFrameHelpBuySomething.DoHelpBuyPrepareOrderExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取运费成功
        if (GetJsonDoubleValue(ASuperObject.O['Data'],'distance')<1000) and (GetJsonDoubleValue(ASuperObject.O['Data'],'distance')>=0) then
        begin
          Self.mclDistance.Prop.Items[0].Text:=FloatToStr(GetJsonDoubleValue(ASuperObject.O['Data'],'distance'))+'m';
        end
        else
        begin
          Self.mclDistance.Prop.Items[0].Text:=FloatToStr(SimpleRoundTo(GetJsonDoubleValue(ASuperObject.O['Data'],'distance')/1000,-1))+'km';
        end;

        //预计到达时间
        Self.mclDistance.Prop.Items[2].Text:='预计'+IntToStr(ASuperObject.O['Data'].I['delivery_time'])+'分钟到达';
        Self.FWantArrivedTime:=ASuperObject.O['Data'].I['delivery_time'];
        //配送费用
        Self.mclMoney.Prop.Items[0].Text:=Format('%.2f',[GetJsonDoubleValue(ASuperObject.O['Data'],'delivery_fee')]);
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

procedure TFrameHelpBuySomething.DoTakeHelpBuyOrderExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('take_order',
                          nil,
                          DeliveryCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'key',
                          'order_type',
                          'send_longitude',
                          'send_latitude',
                          'recv_longitude',
                          'recv_latitude',
                          'send_user_fid',
                          'send_name',
                          'send_sex',
                          'send_phone',
                          'send_addr_name',
                          'send_province',
                          'send_city',
                          'send_area',
                          'send_addr',
                          'send_door_no',
                          'recv_user_fid',
                          'recv_name',
                          'recv_sex',
                          'recv_phone',
                          'recv_addr_name',
                          'recv_province',
                          'recv_city',
                          'recv_area',
                          'recv_addr',
                          'recv_door_no',
                          'is_book',
                          'want_take_time',
                          'want_arrive_time',
                          'goods_name',
                          'goods_money',
                          'goods_judge',
                          'is_need_pay_goods_money',
                          'goods_weight',
                          'goods_length',
                          'goods_width',
                          'goods_height',
                          'weather_type',
                          'use_coupon_fid',
                          'goods_category_fid',
                          'memo',
                          'is_used_score',
                          'used_score',
                          'is_only_pay_delivery_fee'],
                          [AppID,
                          GlobalManager.User.fid,
                          GlobalManager.User.key,
                          FFilterOrderType,
                          FLongtitude,
                          FLatitude,
                          FUserRecvAddr.longitude,
                          FUserRecvAddr.latitude,

                          0,
                          '',
                          '',
                          '',
                          '',
                          '',
                          '',
                          FAddr,
                          '',

                          FUserRecvAddr.user_fid,
                          FUserRecvAddr.name,
                          FUserRecvAddr.sex,
                          FUserRecvAddr.phone,
                          '',
                          FUserRecvAddr.province,
                          FUserRecvAddr.city,
                          FUserRecvAddr.area,
                          FUserRecvAddr.addr,
                          '',//FUserRecvAddr.door_no,

                          0,

                          FWantTakeTime,
                          IntToStr(FWantArrivedTime),
                          '',
                          0,
                          StrToFloat(FFilterMoney),
                          0,
                          FGoodsWeight,
                          0,
                          0,
                          0,
                          GlobalManager.WeatherType,
                          0,
                          FFilterGoodClassFID,
                          Self.edtRemark.Text,
                          0,0,0
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

procedure TFrameHelpBuySomething.DoTakeHelpBuyOrderExecuteEnd(
  ATimerTask: TObject);
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

          //隐藏
          HideFrame;//(Self,hfcttBeforeShowFrame);

          //付款
          ShowFrame(TFrame(GlobalPayOrderFrame),TFramePayOrder,frmMain,nil,nil,nil,Application);
//          GlobalPayOrderFrame.FrameHistroy:=CurrentFrameHistroy;
          GlobalPayOrderFrame.Load(AOrder,True);


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

procedure TFrameHelpBuySomething.Init(AText,AHelpText: String;
  AOrderType:String;AGoodClassList: TGoodClassList);
var
  I: Integer;
  AListViewItem:TSkinListViewItem;
begin

  Clear;

  FLongtitude:=GlobalManager.Longitude;
  FLatitude:=GlobalManager.Latitude;
  FAddr:=GlobalManager.Addr;

  FFilterOrderType:=AOrderType;

  Self.memoGoods.Text:=AText;

  Self.memoGoods.Prop.HelpText:=AHelpText;


  Self.lvGoods.Prop.Items.BeginUpdate;
  try
    if AGoodClassList<>nil then
    begin
      for I := 0 to AGoodClassList.Count-1 do
      begin
        AListViewItem:=Self.lvGoods.Prop.Items.Add;
        AListViewItem.Width:=uSkinBufferBitmap.GetStringWidth(AGoodClassList[I].name,
                                                  Self.lblName.SelfOwnMaterialToDefault.DrawCaptionParam.FontSize)+10;
        AListViewItem.Caption:=AGoodClassList[I].name;
        AListViewItem.Data:=AGoodClassList[I];
        if FFilterGoodClassFID=0 then
        begin
          FFilterGoodClassFID:=AGoodClassList[I].parent_fid;
        end;
      end;
    end;

    AListViewItem:=Self.lvGoods.Prop.Items.Add;
    AListViewItem.Width:=uSkinBufferBitMap.GetStringWidth('与我联系',
                                                  Self.lblName.SelfOwnMaterialToDefault.DrawCaptionParam.FontSize)+10;
    AListViewItem.Caption:='与我联系';

    AListViewItem:=Self.lvGoods.Prop.Items.Add;
    AListViewItem.Width:=uSkinBufferBitMap.GetStringWidth('需要小票',
                                                  Self.lblName.SelfOwnMaterialToDefault.DrawCaptionParam.FontSize)+10;
    AListViewItem.Caption:='需要小票';


  finally
    Self.lvGoods.Prop.Items.EndUpdate();
  end;


  Self.lvGoods.Height:=Self.lvGoods.Prop.GetContentHeight;

  Self.sbcContent.Height:=GetSuitScrollContentHeight(Self.sbcContent);
end;

procedure TFrameHelpBuySomething.lvGoodsClickItem(AItem: TSkinItem);
begin
  if Self.memoGoods.Text='' then
  begin
    Self.memoGoods.Text:=Self.memoGoods.Text+AItem.Caption+' ';
  end
  else
  begin
    Self.memoGoods.Text:=Self.memoGoods.Text+' '+AItem.Caption;
  end;
end;

procedure TFrameHelpBuySomething.OnReturnFrameFromSetPointMapFrame(
  AFrame: TFrame);
var
  AHeight:Double;
begin
  Self.btnSelectAddr.Caption:=GlobalSetGPSPointFrame.FMapAnnotation.Addr;

  Self.FLongtitude:=GlobalSetGPSPointFrame.FMapAnnotation.Location.Longitude;
  Self.FLatitude:=GlobalSetGPSPointFrame.FMapAnnotation.Location.Latitude;
  Self.FAddr:=GlobalSetGPSPointFrame.FMapAnnotation.Addr;


  AHeight:=0;

  AHeight:=uSkinBufferBitMap.GetStringHeight(
                      GlobalSetGPSPointFrame.FMapAnnotation.Addr,
                      RectF(80,0,Self.Width-15,MAxInt),
                      Self.btnSelectAddr.SelfOwnMaterialToDefault.DrawCaptionParam)+10;

  Self.btnSelectAddr.Height:=AHeight;

  Self.pnlBuy.Height:=41+AHeight;

  PrepareOrder;
end;

procedure TFrameHelpBuySomething.OnReturnFromEstimateGoods(AFrame: TFrame);
var
  AMoney:Double;
begin
  if GlobalEstimateGoodsMoneyFrame.FFilterMoney='' then
  begin
    Self.btnMoney.Caption:='';
    FFilterMoney:='';
  end
  else
  begin
    AMoney:=StrToFloat(GlobalEstimateGoodsMoneyFrame.FFilterMoney);

    Self.btnMoney.Caption:='预估'+Trans('￥')+Format('%.2f',[AMoney]);

    FFilterMoney:=Format('%.2f',[AMoney]);
  end;
end;

procedure TFrameHelpBuySomething.OnReturnFromRecvAddr(AFrame: TFrame);
var
  AString:String;
begin
  if GlobalRecvAddrListFrame.FSelectedRecvAddr<>nil then
  begin
    AString:=GlobalRecvAddrListFrame.FSelectedRecvAddr.addr
                           +'  '
                           +'('
                           +GlobalRecvAddrListFrame.FSelectedRecvAddr.name
                           +' '
                           +GlobalRecvAddrListFrame.FSelectedRecvAddr.phone
                           +')';

    Self.btnStar.Caption:=AString;

    Self.btnStar.Height:=uSkinBufferBitMap.GetStringHeight(AString,
                                                     RectF(40,0,Self.Width-40,MaxInt),
                                                     Self.btnStar.SelfOwnMaterialToDefault.DrawCaptionParam)+10;
    Self.pnlstar.Height:=Self.btnStar.Height+10;

    FUserRecvAddr:=GlobalRecvAddrListFrame.FSelectedRecvAddr;
  end
  else
  begin
    Self.btnStar.Caption:='';
  end;

  PrepareOrder;

  Self.sbcContent.Height:=GetSuitScrollContentHeight(Self.sbcContent);
end;
procedure TFrameHelpBuySomething.OnReturnFromSelectedCouponFrame(
  AFrame: TFrame);
begin
  if GlobalTakeOrderUseCouponListFrame.FDescMoney<>0 then
  begin
    Self.btnCoupon.Caption:='¥-'+FloatToStr(GlobalTakeOrderUseCouponListFrame.FDescMoney);
  end;

  FCouponFID:=GlobalTakeOrderUseCouponListFrame.FCouponFID;

  PrepareOrder;
end;

procedure TFrameHelpBuySomething.PrepareOrder;
begin
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                     DoHelpBuyPrepareOrderExecute,
                     DoHelpBuyPrepareOrderExecuteEnd,
                     'HelpBuyPrepareOrder');
end;

end.
