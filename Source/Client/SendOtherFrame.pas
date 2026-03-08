unit SendOtherFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uUIFunction,

  Math,

  uBaseList,

  uOpenCommon,
  uDrawCanvas,

  uSkinBufferBitmap,

  uSkinItems,
  uOpenClientCommon,

  WaitingFrame,
  MessageBoxFrame,
  PopupMenuFrame,
  uManager,
//  uOpenClientCommon,

  uDataSetToJson,

  uTimerTask,

  XSuperObject,
  XSuperJson,

  System.DateUtils,
  uFuncCommon,

  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,


  uSkinPageControlType, uSkinFireMonkeyControl, uSkinSwitchPageListPanelType,
  uSkinFireMonkeyPageControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListViewType, uSkinFireMonkeyListView,
  uSkinImageType, uSkinFireMonkeyImage, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel, uSkinButtonType,
  uSkinFireMonkeyButton, uSkinScrollBoxType, uSkinFireMonkeyScrollBox,
  uSkinScrollBoxContentType, uSkinFireMonkeyScrollBoxContent, uSkinPanelType,
  uSkinFireMonkeyPanel, uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel,
  uDrawPicture, uSkinImageList, uSkinImageListViewerType,
  uSkinFireMonkeyImageListViewer, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Memo, uSkinFireMonkeyMemo, FMX.Edit, uSkinFireMonkeyEdit;

type
  TFrameSendOther = class(TFrame)
    pcControl: TSkinFMXPageControl;
    tbSend: TSkinTabSheet;
    tbPrase: TSkinTabSheet;
    sbClient: TSkinFMXScrollBox;
    sbcContent: TSkinFMXScrollBoxContent;
    pnlstar: TSkinFMXPanel;
    btnStar: TSkinFMXButton;
    pnlEnd: TSkinFMXPanel;
    btnEnd: TSkinFMXButton;
    pnlTakeOrder: TSkinFMXPanel;
    btnTake: TSkinFMXButton;
    pnlSel: TSkinFMXPanel;
    btnTime: TSkinFMXButton;
    btnWeight: TSkinFMXButton;
    pnlCoupon: TSkinFMXPanel;
    lblCoupon: TSkinFMXLabel;
    mclDistance: TSkinFMXMultiColorLabel;
    imglistPlayer: TSkinImageList;
    pnlMome: TSkinFMXPanel;
    lblRemark: TSkinFMXLabel;
    edtRemark: TSkinFMXEdit;
    sbContent: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    imgPlayer: TSkinFMXImageListViewer;
    lvPicList: TSkinFMXImageListViewer;
    pnlOther: TSkinFMXPanel;
    memoBuyGoods: TSkinFMXMemo;
    lvList: TSkinFMXListView;
    idpDefault: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    lvSend: TSkinFMXListView;
    idpClass: TSkinFMXItemDesignerPanel;
    imgClassPic: TSkinFMXImage;
    lblClassName: TSkinFMXLabel;
    idpPao: TSkinFMXItemDesignerPanel;
    lblPao: TSkinFMXLabel;
    btnCoupon: TSkinFMXButton;
    mclMoney: TSkinFMXMultiColorLabel;
    btnTakeOrder: TSkinFMXButton;
    procedure btnStarClick(Sender: TObject);
    procedure btnEndClick(Sender: TObject);
    procedure btnTimeClick(Sender: TObject);
    procedure btnWeightClick(Sender: TObject);
    procedure btnTakeClick(Sender: TObject);
    procedure btnCouponClick(Sender: TObject);
    procedure btnTakeOrderClick(Sender: TObject);
    procedure lvListClickItem(AItem: TSkinItem);
    procedure pcControlChange(Sender: TObject);
  private
    //订单类型
    FOrderType:String;
    //物品估价
    FPrice:Double;

    //物品类型
    FGoodType:String;
    //物品类型FID
    FGoodTypeFID:Integer;

    //红包
    FCouponFID:Integer;
    //配送信息
    FUserSendAddr:TUserRecvAddr;
    //接收信息
    FUserRecvAddr:TUserRecvAddr;

    FWantTakeTime:String;
    FWantArrivedTime:Integer;

    //物品类型列表
    FGoodClassList:TGoodClassList;


    //物品重量
    FGoodsWeight:Double;
  private
    //获取物品类型
    procedure GetGoodClass;
  private
    procedure OnReturnFromStartAddr(AFrame:TFrame);

    procedure OnReturnFromEndAddr(AFrame:TFrame);

    //从取件时间返回
    procedure OnReturnFromSendTime(AFrame:TFrame);
    //从选择物品类型返回
    procedure OnReturnFromWeight(AFrame:TFrame);
    //用户选择红包返回
    procedure OnReturnFromSelectedCouponFrame(AFrame:TFrame);
  private
    //预下单
    procedure DoPrepareOrderExecute(ATimerTask:TObject);
    procedure DoPrepareOrderExecuteEnd(ATimerTask:TObject);
    //下单
    procedure DoTakeDeliverOrderExecute(ATimerTask:TObject);
    procedure DoTakeDeliverOrderExecuteEnd(ATimerTask:TObject);
  private
    //获取物品大类
    procedure DoGetGoodClassExecute(ATimerTask:TObject);
    procedure DoGetGoodClassExecuteEnd(ATimerTask:TObject);
  private
    FParentFID:Integer;
    //获取物品更深一层类型
    procedure DoGetGoodMoreClassListExecute(ATimerTask:TObject);
    procedure DoGetGoodMoreClassListExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    //初始化
    procedure Init;
    //清空
    procedure Clear;

    //预下单
    procedure PrepareOrder;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalSendOtherFrame:TFrameSendOther;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame,
  SelectedSomeFrame,
  PayOrderFrame,
  TakeOrderUseCouponListFrame,
  HelpBuySomethingFrame,
  RecvAddrListFrame;

{ TFrameSendOther }

procedure TFrameSendOther.btnCouponClick(Sender: TObject);
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

procedure TFrameSendOther.btnEndClick(Sender: TObject);
begin
  //选择收货地址
  //隐藏
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  //显示收货地址列表
  ShowFrame(TFrame(GlobalRecvAddrListFrame),TFrameRecvAddrList,frmMain,nil,nil,OnReturnFromEndAddr,Application);
//  GlobalRecvAddrListFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalRecvAddrListFrame.Clear;
  GlobalRecvAddrListFrame.Load(
                            '收件地址',
                            futSelectList,
                            -1
                            );
end;

procedure TFrameSendOther.btnStarClick(Sender: TObject);
begin
  //选择发货地址
  //隐藏
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  //显示收货地址列表
  ShowFrame(TFrame(GlobalRecvAddrListFrame),TFrameRecvAddrList,frmMain,nil,nil,OnReturnFromStartAddr,Application);
//  GlobalRecvAddrListFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalRecvAddrListFrame.Clear;
  GlobalRecvAddrListFrame.Load(
                            '发件地址',
                            futSelectList,
                            -1
                            );

end;

procedure TFrameSendOther.btnTakeClick(Sender: TObject);
begin

  if Self.btnStar.Caption='' then
  begin
    ShowMessageBoxFrame(Self,'物品从哪里出发？!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Self.btnEnd.Caption='' then
  begin
    ShowMessageBoxFrame(Self,'物品送到哪里去？!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Self.btnWeight.Caption='' then
  begin
    ShowMessageBoxFrame(Self,'请选择物品类型、重量!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  //下单
  ShowWaitingFrame(Self,'下单中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                       DoTakeDeliverOrderExecute,
                       DoTakeDeliverOrderExecuteEnd,
                       'TakeDeliverOrder');
end;

procedure TFrameSendOther.btnTakeOrderClick(Sender: TObject);

begin

  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  //显示下单页面
  ShowFrame(TFrame(GlobalHelpBuySomethingFrame),TFrameHelpBuySomething,frmMain,nil,nil,nil,Application);
//  GlobalHelpBuySomethingFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalHelpBuySomethingFrame.Init(Self.memoBuyGoods.Text,'我想吃...',FOrderType,nil);

end;

procedure TFrameSendOther.btnTimeClick(Sender: TObject);
var
  AStringList:TStringList;
begin
  try
    AStringList:=TStringList.Create;

    AStringList.CommaText:='今天,明天';

    //取件时间
    ShowFrame(TFrame(GlobalSelectedSomeFrame),TFrameSelectedSome,frmMain,nil,nil,OnReturnFromSendTime,Application,True,False,ufsefNone);
    GlobalSelectedSomeFrame.Init('取件时间',AStringList,nil);
  finally
    FreeAndNil(AStringList);
  end;

end;

procedure TFrameSendOther.btnWeightClick(Sender: TObject);
begin
  GetGoodClass;
end;

procedure TFrameSendOther.Clear;
begin
  Self.btnStar.Caption:='';
  Self.btnEnd.Caption:='';

  Self.btnWeight.Caption:='';
  Self.btnTime.Caption:='立即取件';

  FOrderType:='';

  FGoodType:='';
  FGoodTypeFID:=0;

  FPrice:=0;

  FParentFID:=0;

  Self.lvList.Prop.Items.Clear(True);


  //红包
  FCouponFID:=0;
//  //配送信息
//  FUserSendAddr.user_fid:=0;
//  FUserSendAddr.name:='';
//  FUserSendAddr.sex:=0;
//  FUserSendAddr.latitude:=0;
//  FUserSendAddr.longitude:=0;
//  FUserSendAddr.phone:='';
//  FUserSendAddr.province:='';
//  FUserSendAddr.city:='';
//  FUserSendAddr.addr:='';
//  FUserSendAddr.area:='';
//  FUserSendAddr.door_no:='';
//  //接收信息
//  FUserRecvAddr.user_fid:=0;
//  FUserRecvAddr.name:='';
//  FUserRecvAddr.sex:=0;
//  FUserRecvAddr.latitude:=0;
//  FUserRecvAddr.longitude:=0;
//  FUserRecvAddr.phone:='';
//  FUserRecvAddr.province:='';
//  FUserRecvAddr.city:='';
//  FUserRecvAddr.addr:='';
//  FUserRecvAddr.area:='';
//  FUserRecvAddr.door_no:='';


  FWantTakeTime:='';
  FWantArrivedTime:=0;

  //物品重量
  FGoodsWeight:=0;
end;

constructor TFrameSendOther.Create(AOwner: TComponent);
begin
  inherited;
  //配送信息
  FUserSendAddr:=TUserRecvAddr.Create;
  //接收信息
  FUserRecvAddr:=TUserRecvAddr.Create;

  //物品类型
  FGoodClassList:=TGoodClassList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameSendOther.Destroy;
begin
  FreeAndNil(FUserSendAddr);
  FreeAndNil(FUserRecvAddr);
  FreeAndNil(FGoodClassList);
  inherited;
end;

procedure TFrameSendOther.DoGetGoodClassExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('get_goods_category_list',
                          nil,
                          DeliveryCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'key',
                          'filter_parent_fid'],
                          [AppID,
                          GlobalManager.User.fid,
                          GlobalManager.User.key,
                          '0'
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

procedure TFrameSendOther.DoGetGoodClassExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AListViewItem:TSkinListViewItem;
  I: Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取物品种类成功
        FGoodClassList.Clear(True);
        FGoodClassList.ParseFromJsonArray(TGoodClass,ASuperObject.O['Data'].A['GoodsCategoryList']);
        if Self.pcControl.Prop.ActivePage=tbSend then
        begin
          //物品类型
          ShowFrame(TFrame(GlobalSelectedSomeFrame),TFrameSelectedSome,frmMain,nil,nil,OnReturnFromWeight,Application,True,False,ufsefNone);
          GlobalSelectedSomeFrame.Init('物品类型',nil,FGoodClassList);
        end;

        if Self.pcControl.Prop.ActivePage=tbPrase then
        begin
          Self.lvList.Prop.Items.Clear(True);

          Self.lvList.Prop.Items.BeginUpdate;
          try
            for I := 0 to FGoodClassList.Count-1 do
            begin
              AListViewItem:=Self.lvList.Prop.Items.Add;
              AListViewItem.Caption:=FGoodClassList[I].name;
              AListViewItem.Data:=FGoodClassList[I];
            end;
          finally
            Self.lvList.Prop.Items.EndUpdate();
          end;

          Self.lvList.Height:=Self.lvList.Prop.GetContentHeight+10;

          Self.pnlOther.Height:=97+Self.lvList.Height;
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



procedure TFrameSendOther.DoGetGoodMoreClassListExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('get_goods_category_list',
                          nil,
                          DeliveryCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'key',
                          'filter_parent_fid'],
                          [AppID,
                          GlobalManager.User.fid,
                          GlobalManager.User.key,
                          FParentFID
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

procedure TFrameSendOther.DoGetGoodMoreClassListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AGoodClassList:TGoodClassList;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        try
          AGoodClassList:=TGoodClassList.Create(ooReference);
          AGoodClassList.ParseFromJsonArray(TGoodClass,ASuperObject.O['Data'].A['GoodsCategoryList']);

          HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
          //显示下单页面
          ShowFrame(TFrame(GlobalHelpBuySomethingFrame),TFrameHelpBuySomething,frmMain,nil,nil,nil,Application);
//          GlobalHelpBuySomethingFrame.FrameHistroy:=CurrentFrameHistroy;
          GlobalHelpBuySomethingFrame.Init(Self.memoBuyGoods.Text,'点击输入你的商品要求...',FOrderType,AGoodClassList);

        finally
          FreeAndNil(AGoodClassList);
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
    HideWaitingFrame;
  end;

end;


procedure TFrameSendOther.DoPrepareOrderExecute(ATimerTask: TObject);
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
                          FOrderType,
                          FUserSendAddr.longitude,
                          FUserSendAddr.latitude,
                          FUserRecvAddr.longitude,
                          FUserRecvAddr.latitude,
                          0,
                          FWantTakeTime,
                          FWantArrivedTime,
                          FGoodType,
                          0,
                          0,
                          FGoodsWeight,
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

procedure TFrameSendOther.DoPrepareOrderExecuteEnd(ATimerTask: TObject);
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

procedure TFrameSendOther.DoTakeDeliverOrderExecute(ATimerTask: TObject);
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
                          FOrderType,
                          FUserSendAddr.longitude,
                          FUserSendAddr.latitude,
                          FUserRecvAddr.longitude,
                          FUserRecvAddr.latitude,

                          FUserSendAddr.user_fid,
                          FUserSendAddr.name,
                          FUserSendAddr.sex,
                          FUserSendAddr.phone,
                          '',
                          FUserSendAddr.province,
                          FUserSendAddr.city,
                          FUserSendAddr.area,
                          FUserSendAddr.addr,
                          '',//FUserSendAddr.door_no,

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
                          FPrice,
                          0,
                          FGoodsWeight,
                          0,
                          0,
                          0,
                          GlobalManager.WeatherType,
                          0,
                          Self.FGoodTypeFID,
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

procedure TFrameSendOther.DoTakeDeliverOrderExecuteEnd(ATimerTask: TObject);
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
//            GlobalPayOrderFrame.FrameHistroy:=CurrentFrameHistroy;
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

procedure TFrameSendOther.GetGoodClass;
begin
  //获取物品类型
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                     DoGetGoodClassExecute,
                     DoGetGoodClassExecuteEnd,
                     'GetGoodClass');
end;

procedure TFrameSendOther.Init;
begin
  Clear;

  Self.pcControl.Prop.ActivePage:=tbSend;
  FOrderType:=Const_OrderType_RunErrands;

  Self.sbcContent.Height:=GetSuitScrollContentHeight(Self.sbcContent);
end;

procedure TFrameSendOther.lvListClickItem(AItem: TSkinItem);
var
  AGoodClass:TGoodClass;
begin

  AGoodClass:=TGoodClass(AItem.Data);

  FParentFID:=AGoodClass.fid;

  //获取物品详细分类
  uTimerTask.GetGlobalTimerThread.RunTempTask(
               DoGetGoodMoreClassListExecute,
               DoGetGoodMoreClassListExecuteEnd,
               'GetGoodMoreClassList');

end;

procedure TFrameSendOther.OnReturnFromEndAddr(AFrame: TFrame);
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

    Self.btnEnd.Caption:=AString;

    Self.btnEnd.Height:=uSkinBufferBitMap.GetStringHeight(AString,
                                                     RectF(40,0,Self.Width-40,MaxInt),
                                                     Self.btnEnd.SelfOwnMaterialToDefault.DrawCaptionParam)+10;
    Self.pnlEnd.Height:=Self.btnEnd.Height+10;

    FUserRecvAddr:=GlobalRecvAddrListFrame.FSelectedRecvAddr;
  end
  else
  begin
    Self.btnEnd.Caption:='';
  end;

  PrepareOrder;

  Self.sbcContent.Height:=GetSuitScrollContentHeight(Self.sbcContent);
end;

procedure TFrameSendOther.OnReturnFromSelectedCouponFrame(AFrame: TFrame);
begin
  if GlobalTakeOrderUseCouponListFrame.FDescMoney<>0 then
  begin
    Self.btnCoupon.Caption:='¥-'+FloatToStr(GlobalTakeOrderUseCouponListFrame.FDescMoney);
  end;

  FCouponFID:=GlobalTakeOrderUseCouponListFrame.FCouponFID;

  PrepareOrder;

end;

procedure TFrameSendOther.OnReturnFromSendTime(AFrame: TFrame);
begin
  if GlobalSelectedSomeFrame.FSelectedDetail='立即取件' then
  begin
    Self.btnTime.Caption:='立即取件';
    FWantTakeTime:=FormatDateTime('YYYY-MM-DD HH:MM:SS',Now);
  end
  else
  begin
    Self.btnTime.Caption:=GlobalSelectedSomeFrame.FSelectedCaption+GlobalSelectedSomeFrame.FSelectedDetail;

    if GlobalSelectedSomeFrame.FSelectedCaption='今天' then
    begin
      FWantTakeTime:=FormatDateTime('YYYY-MM-DD',Now)+' '+GlobalSelectedSomeFrame.FSelectedDetail+':00';
    end
    else
    begin
      FWantTakeTime:=FormatDateTime('YYYY-MM-DD',Now+1)+' '+GlobalSelectedSomeFrame.FSelectedDetail+':00';
    end;
  end;

  PrepareOrder;
end;

procedure TFrameSendOther.OnReturnFromStartAddr(AFrame: TFrame);
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

    FUserSendAddr:=GlobalRecvAddrListFrame.FSelectedRecvAddr;
  end
  else
  begin
    Self.btnStar.Caption:='';
  end;

  PrepareOrder;

  Self.sbcContent.Height:=GetSuitScrollContentHeight(Self.sbcContent);
end;

procedure TFrameSendOther.OnReturnFromWeight(AFrame: TFrame);
begin
  Self.btnWeight.Caption:=GlobalSelectedSomeFrame.FSelectedCaption+'，'+GlobalSelectedSomeFrame.FSelectedDetail;

  FGoodType:=GlobalSelectedSomeFrame.FSelectedCaption;

  FGoodTypeFID:=GlobalSelectedSomeFrame.FSelectedFID;

  Self.FGoodsWeight:=StrToFloat(GlobalSelectedSomeFrame.FSelectedName);

  PrepareOrder;
end;

procedure TFrameSendOther.pcControlChange(Sender: TObject);
begin
  if Self.pcControl.Prop.ActivePage=Self.tbSend then
  begin
    FOrderType:=Const_OrderType_RunErrands;
  end
  else
  begin
    GetGoodClass;
    FOrderType:=Const_OrderType_HelpBuy;
  end;
end;

procedure TFrameSendOther.PrepareOrder;
begin
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                     DoPrepareOrderExecute,
                     DoPrepareOrderExecuteEnd,
                     'PrepareOrder');
end;

end.
