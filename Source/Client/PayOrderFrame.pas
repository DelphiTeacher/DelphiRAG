unit PayOrderFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,


  DateUtils,
  uFuncCommon,
  uSkinItems,
  FMX.Platform,
  uBaseLog,
  uSkinTreeViewType,
  uFrameContext,
  EasyServiceCommonMaterialDataMoudle,
  MessageBoxFrame,
  WaitingFrame,

  uOpenCommon,
  uOpenClientCommon,
  uManager,
  uUIFunction,
  uTimerTask,
  XSuperObject,
  uRestInterfaceCall,
  uBaseHttpControl,
  uMobileUtils,

  uDataSetToJson,


  {$IFDEF HAS_WXPAY}
  uWeiChat,
  {$ENDIF HAS_WXPAY}

  {$IFDEF HAS_ALIPAY}
  uAlipayMobilePay,
  {$ENDIF HAS_ALIPAY}


  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyLabel, uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox,
  uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyImage,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyCheckBox, uDrawPicture, uSkinImageList,
  uSkinFireMonkeyRadioButton, uSkinRadioButtonType, uSkinItemDesignerPanelType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType,
  uSkinMultiColorLabelType, uSkinLabelType, uSkinImageType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinButtonType, uSkinPanelType, uTimerTaskEvent, uDrawCanvas;



type
  TFramePayOrder = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlTakeOrderResult: TSkinFMXPanel;
    imglistTakeOrderState: TSkinImageList;
    imgTakeOrderResult: TSkinFMXImage;
    lblTakeOrderResult: TSkinFMXLabel;
    pnlSumMoney: TSkinFMXPanel;
    lblSumMoney: TSkinFMXMultiColorLabel;
    btnOK: TSkinFMXButton;
    pnlEmpty2: TSkinFMXPanel;
    SkinFMXPanel3: TSkinFMXPanel;
    pnlPaymentType: TSkinFMXPanel;
    lbPaymentTypeList: TSkinFMXListBox;
    idpDefault: TSkinFMXItemDesignerPanel;
    lblItemCaption: TSkinFMXLabel;
    imgItemIcon: TSkinFMXImage;
    chkItemDefaultIsSelected: TSkinFMXRadioButton;
    lblItemDetail: TSkinFMXLabel;
    SkinFMXPanel2: TSkinFMXPanel;
    tteUserPrePayOrder: TTimerTaskEvent;
    tmrGetOrderPayState: TTimer;
    tteSimulatorOrderAlipaySucc: TTimerTaskEvent;
    tteGetOrderPayState: TTimerTaskEvent;
    tteSimulatorOrderWxpaySucc: TTimerTaskEvent;
    ttePayByAccountBalance: TTimerTaskEvent;
    tteSimulatorOrderPxpaySucc: TTimerTaskEvent;
    SkinFMXPanel4: TSkinFMXPanel;
    tteOrderTillDone: TTimerTaskEvent;
    SkinFMXPanel1: TSkinFMXPanel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure tteUserPrePayOrderBegin(Sender: TTimerTask);
    procedure tteUserPrePayOrderExecute(ATimerTask: TTimerTask);
    procedure tteUserPrePayOrderExecuteEnd(ATimerTask: TTimerTask);
    procedure tmrGetOrderPayStateTimer(Sender: TObject);
    procedure tteSimulatorOrderAlipaySuccExecute(ATimerTask: TTimerTask);
    procedure tteSimulatorOrderWxpaySuccExecute(ATimerTask: TTimerTask);
    procedure ttePayByAccountBalanceExecute(ATimerTask: TTimerTask);
    procedure ttePayByAccountBalanceBegin(ATimerTask: TTimerTask);
    procedure tteSimulatorOrderWxpaySuccBegin(ATimerTask: TTimerTask);
    procedure tteSimulatorOrderAlipaySuccBegin(ATimerTask: TTimerTask);
    procedure tteSimulatorOrderPxpaySuccBegin(ATimerTask: TTimerTask);
    procedure ttePayByAccountBalanceExecuteEnd(ATimerTask: TTimerTask);
    procedure tteSimulatorOrderWxpaySuccExecuteEnd(ATimerTask: TTimerTask);
    procedure tteSimulatorOrderAlipaySuccExecuteEnd(ATimerTask: TTimerTask);
    procedure tteGetOrderPayStateExecute(ATimerTask: TTimerTask);
    procedure tteGetOrderPayStateExecuteEnd(ATimerTask: TTimerTask);
    procedure tteSimulatorOrderPxpaySuccExecuteEnd(ATimerTask: TTimerTask);
    procedure tteSimulatorOrderPxpaySuccExecute(ATimerTask: TTimerTask);
    procedure lbPaymentTypeListClickItem(AItem: TSkinItem);
    procedure tteOrderTillDoneExecute(ATimerTask: TTimerTask);
    procedure tteOrderTillDoneExecuteEnd(ATimerTask: TTimerTask);
    procedure tteOrderTillDoneBegin(ATimerTask: TTimerTask);
  private
    FUserBillMoneyFID:Integer;


    FGetOrderPayStateStartTime:TDateTime;
    FGetOrderPayStateCount:Integer;
    FGetOrderPayStateIsOver:Boolean;


    FOrder:TOrder;
    //是否是刚下的订单
    FIsNewOrder:Boolean;
    FMoneyFID:Integer;
  private
    //获取用户账户余额
    procedure DoGetUserWalletExecute(ATimerTask:TObject);
    procedure DoGetUserWalletExecuteEnd(ATimerTask:TObject);
  private
    //计算手续费
    procedure DoGetChargeFreeExecute(ATimerTask:TObject);
    procedure DoGetChargeFreeExecuteEnd(ATimerTask:TObject);
  private
    //获取平台支持的支付方式列表
    procedure DoGetAppPayTypeListExecute(ATimerTask:TObject);
    procedure DoGetAppPayTypeListExecuteEnd(ATimerTask:TObject);
  private
    //取消付款
    procedure OnModalResultFromCancelPay(Frame:TObject);
  private
    //微信支付返回
    procedure Do_WeiChat_PayResult(Sender:TObject;
                              AResponseCode:Integer;
                              AIsSucc:Boolean;
                              AError:String);
  private
    //支付结果回调事件
    procedure Do_AlipayMobilePay_OnPayResult(Sender:TObject;
                                     APayResultJson:String;
                                     APayResultStatus:String;
                                     APayResultDesc:String;
                                     APayResultMemo:String;
                                     AIsPaySucc:Boolean);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  public
    procedure Load(AOrder:TOrder;AIsNewOrder:Boolean);
    //获取用户余额
    procedure GetUserMoney;
  end;




var
  GlobalPayOrderFrame:TFramePayOrder;


implementation


{$R *.fmx}

uses
  MainForm,
  MainFrame,
  PayOrderResultFrame
  ;


procedure TFramePayOrder.btnOKClick(Sender: TObject);
begin
  HideVirtualKeyboard;

  //获取预付信息
  Self.tteUserPrePayOrder.Run;


end;

procedure TFramePayOrder.btnReturnClick(Sender: TObject);
begin
  //判断是否可以返回
  //如果是下单成功之后,如果按返回,则跳转到主界面

  if FIsNewOrder then
  begin
    ShowMessageBoxFrame(Self,'是否取消付款?','',TMsgDlgType.mtInformation,['确定','取消'],OnModalResultFromCancelPay);

  end
  else
  begin
    //返回
    HideFrame;//(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);
  end;

end;


constructor TFramePayOrder.Create(AOwner: TComponent);
begin
  inherited;

  FOrder:=TOrder.Create;

//  //暂时不支持微信支付和支付宝支付
//  Self.lbPaymentTypeList.Prop.Items.FindItemByCaption('支付宝').Visible:=
//    False;
//  Self.lbPaymentTypeList.Prop.Items.FindItemByCaption('微信支付').Visible:=
//    False;


//  //申请微信支付,需要显示微信支付图标
//  if GlobalManager.ServerHost='www.orangeui.cn' then
//  begin
////    Self.lbPaymentTypeList.Prop.Items.FindItemByCaption('支付宝').Visible:=
////      True;
//    Self.lbPaymentTypeList.Prop.Items.FindItemByCaption('微信支付').Visible:=
//      True;
//  end;


  Self.lbPaymentTypeList.Height:=lbPaymentTypeList.Prop.GetContentHeight;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

end;

destructor TFramePayOrder.Destroy;
begin
  FreeAndNil(FOrder);

  inherited;
end;

procedure TFramePayOrder.DoGetAppPayTypeListExecute(ATimerTask: TObject);
begin
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('get_app_pay_type_list',
                          nil,
                          PayCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'key',
                          'order_fid'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          '',
                          FOrder.fid
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

procedure TFramePayOrder.DoGetAppPayTypeListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AItem:TSkinListBoxItem;
  J: Integer;
  AHasAccountBalance:Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        AHasAccountBalance:=0;
        Self.lbPaymentTypeList.Prop.Items.Clear();
        Self.lbPaymentTypeList.Prop.Items.BeginUpdate;
        try
          for I := 0 to ASuperObject.O['Data'].A['AppPayTypeList'].Length-1 do
          begin

            //配送单不支持到店付款方式
            if (FOrder.deliver_type=Const_DeliverType_NeedDeliver)
            AND (ASuperObject.O['Data'].A['AppPayTypeList'].O[I].S['pay_type']=Const_PaymentType_PayAtStore) then
            begin
            end
            else
            begin
              //自取或堂食不支持刷POS机
              if (FOrder.deliver_type<>Const_DeliverType_NeedDeliver)
              AND ((ASuperObject.O['Data'].A['AppPayTypeList'].O[I].S['pay_type']=Const_PaymentType_PosDebitCard)
              OR (ASuperObject.O['Data'].A['AppPayTypeList'].O[I].S['pay_type']=Const_PaymentType_PosCreditCard)) then
              begin
              end
              else
              begin

                //暂时先改成付款金额为0时只显示余额支付
                //不为0时显示所有支付方式
                if FOrder.sum_money>0 then
                begin
                  AItem:=Self.lbPaymentTypeList.Prop.Items.Add;
                  AItem.Caption:=ASuperObject.O['Data'].A['AppPayTypeList'].O[I].S['pay_type_name'];
                  AItem.Name:=ASuperObject.O['Data'].A['AppPayTypeList'].O[I].S['pay_type'];
                end
                else
                begin
                  //等于0的情况
                  if ASuperObject.O['Data'].A['AppPayTypeList'].O[I].S['pay_type']=Const_PaymentType_AccountBalance then
                  begin
                    AItem:=Self.lbPaymentTypeList.Prop.Items.Add;
                    AItem.Caption:=ASuperObject.O['Data'].A['AppPayTypeList'].O[I].S['pay_type_name'];
                    AItem.Name:=ASuperObject.O['Data'].A['AppPayTypeList'].O[I].S['pay_type'];
                  end;
                end;


                //支付方式的名称与描述不同时都显示   相同时只显示名称
                if ASuperObject.O['Data'].A['AppPayTypeList'].O[I].S['pay_type_name']
                   <>ASuperObject.O['Data'].A['AppPayTypeList'].O[I].S['pay_type_desc'] then
                begin
                  AItem.Caption:=ASuperObject.O['Data'].A['AppPayTypeList'].O[I].S['pay_type_name']
                                 +'('
                                 +ASuperObject.O['Data'].A['AppPayTypeList'].O[I].S['pay_type_desc']
                                 +')';
                end;

                //余额支付不显示费率和基础费  其他方式显示
                if ASuperObject.O['Data'].A['AppPayTypeList'].O[I].S['pay_type']<>Const_PaymentType_AccountBalance then
                begin
                  //用户承担手续费才显示费率和基础费
                  AItem.Detail:='';
                  if ASuperObject.O['Data'].S['poundage_undertaker']<>Const_ServiceFree_Shop then
                  begin
//                    AItem.Detail:='基础费:'
//                                  +FloatToStr(ASuperObject.O['Data'].A['AppPayTypeList'].O[I].F['basic_service_fee'])
//                                  +'  费率:'
//                                  +FloatToStr(ASuperObject.O['Data'].A['AppPayTypeList'].O[I].F['service_fee_rate']*100)
//                                  +'%';
                  end;
                end
                else
                begin
                  AHasAccountBalance:=1;
                end;

                //设置支付方式对应的图标
                for J := 0 to dmEasyServiceCommonMaterial.imgPayTypePicList.PictureList.Count-1 do
                begin
                  if AItem.Name
                     =dmEasyServiceCommonMaterial.imgPayTypePicList.PictureList.Items[J].ImageName then
                  begin
                    AItem.Icon.ImageIndex:=J;
                  end;
                end;
              end;
            end;

          end;
        finally
          Self.lbPaymentTypeList.Prop.Items.EndUpdate();
        end;
        //调整高度
        Self.lbPaymentTypeList.Height:=lbPaymentTypeList.Prop.GetContentHeight;
        //滑动
        Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);

        //获取到支付方式列表  显示到列表上
        if Self.lbPaymentTypeList.Prop.Items.Count>0 then
        begin
          Self.lbPaymentTypeList.Prop.Items.Items[0].Selected:=True;
        end;

        if AHasAccountBalance=1 then
        begin
          //获取余额
          GetUserMoney;
        end;

//        ShowWaitingFrame(Self,'加载中...');
//        //进入界面时加载默认支付方式的手续费
//        //调用获取手续费接口
//        uTimerTask.GetGlobalTimerThread.RunTempTask(
//                                    DoGetChargeFreeExecute,
//                                    DoGetChargeFreeExecuteEnd);

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

procedure TFramePayOrder.DoGetChargeFreeExecute(ATimerTask: TObject);
begin
//出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('get_transfer_fee',
                          nil,
                          PayCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'order_fid',
                          'order_type',
                          'pay_type'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          FOrder.fid,
                          Const_OrderType_ShopCenter,
                          Self.lbPaymentTypeList.Prop.SelectedItem.Name
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

procedure TFramePayOrder.DoGetChargeFreeExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        // '{"Code":200,
        //   "Desc":"uFF01",
        //   "Data":{"goods_charge_free":0.1,
                  //"delivery_charge_free":0,
                  //"sum_charge_free":0.1,
                  //"sum_money":10.1
                  //}}'
        //总金额
        Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
          Format('%.2f',[ASuperObject.O['Data'].F['sum_money']]);
//        Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['ChargeFree'].Text:=
//          Format('%.2f',[ASuperObject.O['Data'].F['sum_charge_free']]);
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
  end;

end;

procedure TFramePayOrder.DoGetUserWalletExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('get_user_money',
                          nil,
                          PayCenterInterfaceUrl,
                          ['appid',
                          'user_fid'
                          ],
                          [AppID,
                          GlobalManager.User.fid
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

procedure TFramePayOrder.DoGetUserWalletExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AUserWalletObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        AUserWalletObject:=ASuperObject.O['Data'].A['UserMoney'].O[0];

        Self.lbPaymentTypeList.Prop.Items.FindItemByName('account_balance').Detail:='余额为'+Format('%.2f',[GetJsonDoubleValue(AUserWalletObject,'money')])+'元';


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

procedure TFramePayOrder.Do_AlipayMobilePay_OnPayResult(Sender: TObject;
                                     APayResultJson:String;
                                     APayResultStatus:String;
                                     APayResultDesc:String;
                                     APayResultMemo:String;
                                     AIsPaySucc:Boolean);
begin
  {$IFDEF HAS_ALIPAY}
//  //支付结果
//  ShowMessageBoxFrame(frmMain,GetPayResultStatusDesc(GlobalAlipayMobilePay.FPayResultStatus));
//  Self.memPayResult.Lines.Insert(0,
//                        GetPayResultStatusDesc(FAlipayMobilePay.FPayResultStatus)
//                        );
//
//  Self.memPayResult.Lines.Insert(1,'');
  {$ENDIF HAS_ALIPAY}
  //刷新订单的支付状态    同微信回调
  if Not FGetOrderPayStateIsOver then tmrGetOrderPayStateTimer(nil);
end;

procedure TFramePayOrder.Do_WeiChat_PayResult(Sender: TObject;
                              AResponseCode:Integer;
                              AIsSucc:Boolean;
                              AError:String);
begin
  {$IFDEF HAS_WXPAY}
//  //支付返回
//  if GlobalWeiChat.FResponseCode=0 then
//  begin
////    ShowMessage('支付成功');
//
////    查询下服务器的支付结果
////    查询下开放平台,订单有没有支付成功
////    查询下宜服系统,订单有没有支付成功
////    ShowWaitingFrame(Self,'加载中...');
////    uTimerTask.GetGlobalTimerThread.RunTempTask(
////                    DoGetOrderPaymentInfoExecute,
////                    DoGetOrderPaymentInfoExecuteEnd);
////    ShowWaitingFrame(Self,'获取支付结果...');
////    Self.tteGetOrderPayState.Run;
//
//  end;
  {$ENDIF HAS_WXPAY}
  //刷新订单的支付状态
  //下单付完后  FGetOrderPayStateIsOver 是False    获取到状态后  是True
  //下过单  之后进行积分充值  回调会到这里   不判断的话会跳出订单支付完成界面
  if Not FGetOrderPayStateIsOver then tmrGetOrderPayStateTimer(nil);
end;

procedure TFramePayOrder.GetUserMoney;
begin
  uTimerTask.GetGlobalTimerThread.RunTempTask(
             DoGetUserWalletExecute,
             DoGetUserWalletExecuteEnd,
             'GetUserWallet');
end;

procedure TFramePayOrder.lbPaymentTypeListClickItem(AItem: TSkinItem);
begin
//  ShowWaitingFrame(Self,'加载中...');
  //调用获取手续费接口
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                              DoGetChargeFreeExecute,
//                              DoGetChargeFreeExecuteEnd);

end;

procedure TFramePayOrder.Load(AOrder: TOrder;AIsNewOrder:Boolean);
begin


  {$IFDEF HAS_ALIPAY}
//  if GlobalAlipayMobilePay=nil then
//  begin
//    GlobalAlipayMobilePay:=TAlipayMobilePay.Create(nil);
//
//    //IOS系统中的框架
//    GlobalAlipayMobilePay.IOSSchema:='alisdkdemo';
//

    //支付回调
    GlobalAlipayMobilePay.OnPayResult:=Do_AlipayMobilePay_OnPayResult;
//  end;
  {$ENDIF HAS_ALIPAY}


  {$IFDEF HAS_WXPAY}
//  GlobalWeiChat:=TWeiChat.Create(nil);
//
//  //宜服,微信支付的示例
//  GlobalWeiChat.AppID:='wx8e8f30be080c6177';
//  GlobalWeiChat.AppSecret:='9858d03544b6c6e377b03aa297a3afb7';
//
  GlobalWeiChat.OnPayResult:=Self.Do_WeiChat_PayResult;
//
//  //注册
//  GlobalWeiChat.RegisterWeiChat;
  {$ENDIF HAS_WXPAY}



  FOrder.Assign(AOrder);
  FIsNewOrder:=AIsNewOrder;

  //总金额
  Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
    Format('%.2f',[FOrder.sum_money]);

  //订单金额大于0 需要支付     暂时先修改成订单金额为0时只显示余额支付
//  if FOrder.sum_money>0 then
//  begin
    Self.lbPaymentTypeList.Prop.Items.Clear();

    Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);

    ShowWaitingFrame(Self,'加载支付方式中...');
    //从服务器获取平台支持的支付方式
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                DoGetAppPayTypeListExecute,
                                DoGetAppPayTypeListExecuteEnd,
                                'GetAppPayTypeList');
//  end
//  else
//  begin
//    //订单金额为0 则先默认余额支付后跳到支付结果界面
//    Self.tteUserPrePayOrder.Run;
//  end;


  AlignControls(SkinFMXPanel2,
                pnlTakeOrderResult,
                SkinFMXPanel1,
                pnlSumMoney,
                SkinFMXPanel3,
                pnlPaymentType,
                lbPaymentTypeList,
                pnlEmpty2,
                btnOK
                );

end;

procedure TFramePayOrder.OnModalResultFromCancelPay(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='确定' then
  begin

    //查看订单
    HideFrame;//(Self);
    ShowFrame(TFrame(GlobalMainFrame),TFrameMain);

  end;
  if TFrameMessageBox(Frame).ModalResult='取消' then
  begin
    //留在酒店信息页面
  end;

end;

procedure TFramePayOrder.tteSimulatorOrderAlipaySuccBegin(
  ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,'支付宝支付中...');

end;

procedure TFramePayOrder.tteSimulatorOrderAlipaySuccExecute(ATimerTask: TTimerTask);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
        SimpleCallAPI('simulator_order_alipay_succ',
                      nil,
                      InterfaceUrl+'alipayservice/',
                      ['appid',
                      'order_fid',
                      'order_type'],
                      [AppID,
                      FUserBillMoneyFID,//资金往来FID
                      'shop_center'
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

procedure TFramePayOrder.tteSimulatorOrderAlipaySuccExecuteEnd(
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

        //刷新订单的支付状态
        tmrGetOrderPayStateTimer(nil);
//        Self.tmrGetOrderPayState.Enabled:=True;

      end
      else
      begin
        //模拟支付宝失败失败
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

procedure TFramePayOrder.tteSimulatorOrderPxpaySuccBegin(
  ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,'Pxpay支付中...');
end;

procedure TFramePayOrder.tteSimulatorOrderPxpaySuccExecute(
  ATimerTask: TTimerTask);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
        SimpleCallAPI('get_pxpay_link',
                      nil,
                      InterfaceUrl+'pxpay/',
                      ['appid',
                      'user_fid',
                      'quantity',
                      'billingId',
                      'unit_price',
                      'reference',
                      'address1',
                      'address2'],
                      [AppID,
                      GlobalManager.User.fid,
                      1,
                      FUserBillMoneyFID,//资金往来FID
                      FOrder.sum_money,
                      '','',''],
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

procedure TFramePayOrder.tteSimulatorOrderPxpaySuccExecuteEnd(
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
        //调起浏览器
        OpenWebBrowserAndNavigateURL(ASuperObject.O['Data'].S['Link']);
        //刷新订单的支付状态
        tmrGetOrderPayStateTimer(nil);
//        Self.tmrGetOrderPayState.Enabled:=True;
      end
      else
      begin
        //模拟PxPay支付失败
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

procedure TFramePayOrder.tteSimulatorOrderWxpaySuccBegin(
  ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,'微信支付中...');
end;

procedure TFramePayOrder.tteSimulatorOrderWxpaySuccExecute(
  ATimerTask: TTimerTask);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
        SimpleCallAPI('simulator_order_wxpay_succ',
                      nil,
                      InterfaceUrl+'wxpayservice/',
                      ['appid',
                      'order_fid',
                      'order_type'],
                      [AppID,
                      FUserBillMoneyFID,//资金往来FID
                      'shop_center'
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

procedure TFramePayOrder.tteSimulatorOrderWxpaySuccExecuteEnd(
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

        //刷新订单的支付状态
        tmrGetOrderPayStateTimer(nil);
//        Self.tmrGetOrderPayState.Enabled:=True;

      end
      else
      begin
        //模拟微信支付失败
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

procedure TFramePayOrder.tmrGetOrderPayStateTimer(Sender: TObject);
begin
  Self.tmrGetOrderPayState.Enabled:=False;

  FGetOrderPayStateCount:=0;
  FGetOrderPayStateIsOver:=False;


  //获取订单详情,判断是否支付成功
  ShowWaitingFrame(Self,'获取支付结果...');
  Self.tteGetOrderPayState.Run;

end;

procedure TFramePayOrder.tteGetOrderPayStateExecute(ATimerTask: TTimerTask);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try

    //3秒中查一次
    Sleep(3000);

    TTimerTask(ATimerTask).TaskDesc:=
        SimpleCallAPI('user_get_order',
                      nil,
                      ShopCenterInterfaceUrl,
                      ['appid',
                      'user_fid',
                      'order_fid'],
                      [AppID,
                      GlobalManager.User.fid,
                      FOrder.fid//订单FID
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

procedure TFramePayOrder.tteGetOrderPayStateExecuteEnd(ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
begin
  try
    if FGetOrderPayStateIsOver then Exit;


    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
        if ASuperObject.I['Code']=200 then
        begin

            Self.FOrder.ParseFromJson(ASuperObject.O['Data'].A['OrderInfo'].O[0]);

            uBaseLog.OutputDebugString('OrangeUI TFramePayOrder.tteGetOrderPayStateExecuteEnd PayState '+FOrder.pay_state);


            //在前台的情况下,不在后台,在前台
            if (GlobalApplicationState<>TApplicationEvent.EnteredBackground)
              and (GlobalApplicationState<>TApplicationEvent.WillBecomeInactive) then
            begin

                  if FGetOrderPayStateCount=0 then
                  begin
                    //开始计时
                    FGetOrderPayStateStartTime:=Now;
                  end;


                  //支付完成后,APP从后台返回到了前台,开始计数
                  Inc(FGetOrderPayStateCount);


                  uBaseLog.OutputDebugString('OrangeUI TFramePayOrder.tteGetOrderPayStateExecuteEnd Foreground');

                  if (FOrder.pay_state=Const_PayState_Payed) then
                  begin
                      //付款成功
                      HideWaitingFrame;

                      //如果支付完,APP从后台转到前台,会出现白屏的问题
                      HideFrame;//(Self,hfcttBeforeShowFrame);
                      ShowFrame(TFrame(GlobalPayOrderResultFrame),TFramePayOrderResult);
//                      GlobalPayOrderResultFrame.FrameHistroy:=CurrentFrameHistroy;
                      GlobalPayOrderResultFrame.Load(FOrder.sum_money,
                                                FOrder.client_bear_pay_fee,
                                                Self.lbPaymentTypeList.Prop.SelectedItem.Name,
                                                Const_PayState_Payed,
                                                '付款成功',
                                                '');
                      FGetOrderPayStateIsOver:=True;

//                      //下完单后刷新我的界面 余额 积分 等数据
//                      if GlobalMainFrame.FMyFrame<>nil then
//                      begin
//                        if FOrder.pay_type=Const_PaymentType_AccountBalance then GlobalMainFrame.FMyFrame.GetWallet;
//                        GlobalMainFrame.FMyFrame.GetUserInfo;
//                      end;
                  end
                  else if (FOrder.pay_state=Const_PayState_PayTillDone) then
                  begin
                      HideWaitingFrame;


                      //如果支付完,APP从后台转到前台,会出现白屏的问题
                      HideFrame;//(Self,hfcttBeforeShowFrame);
                      ShowFrame(TFrame(GlobalPayOrderResultFrame),TFramePayOrderResult);
//                      GlobalPayOrderResultFrame.FrameHistroy:=CurrentFrameHistroy;
                      GlobalPayOrderResultFrame.Load(FOrder.sum_money,
                                                FOrder.client_bear_pay_fee,
                                                Self.lbPaymentTypeList.Prop.SelectedItem.Name,
                                                Const_PayState_Payed,
                                                '下单成功',
                                                '');
                      FGetOrderPayStateIsOver:=True;
                  end
                  else
                  begin
                      //支付未结束,或者没有支付成功
                      if DateUtils.SecondsBetween(Now,FGetOrderPayStateStartTime)<10 then
                      begin

                          //没有超时
                          //继续获取
                          //获取订单详情,判断是否支付成功
                          Self.tteGetOrderPayState.Run;
                      end
                      else
                      begin
                          //超出一定次数,超时了
                          HideWaitingFrame;

                          //获取订单支付结果失败
                          HideFrame;//(Self,hfcttBeforeShowFrame);
                          ShowFrame(TFrame(GlobalPayOrderResultFrame),TFramePayOrderResult);
//                          GlobalPayOrderResultFrame.FrameHistroy:=CurrentFrameHistroy;
                          GlobalPayOrderResultFrame.Load(FOrder.sum_money,
                                      FOrder.client_bear_pay_fee,
                                      Self.lbPaymentTypeList.Prop.SelectedItem.Name,
                                      '',
                                      '获取订单支付结果失败!',
                                      '');

                          FGetOrderPayStateIsOver:=True;

                      end;
                  end;
            end
            else
            begin
                uBaseLog.OutputDebugString('OrangeUI TFramePayOrder.tteGetOrderPayStateExecuteEnd Background');

                //在后台
                //继续获取,没有超时的概念
                //获取订单详情,判断是否支付成功
                Self.tteGetOrderPayState.Run;
            end;

        end
        else
        begin
            //获取订单支付信息失败
            ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
            HideWaitingFrame;

            //获取订单支付结果失败
            HideFrame;//(Self,hfcttBeforeShowFrame);
            ShowFrame(TFrame(GlobalPayOrderResultFrame),TFramePayOrderResult);
//            GlobalPayOrderResultFrame.FrameHistroy:=CurrentFrameHistroy;
            GlobalPayOrderResultFrame.Load(FOrder.sum_money,
                                          FOrder.client_bear_pay_fee,
                                          Self.lbPaymentTypeList.Prop.SelectedItem.Name,'','获取订单支付结果失败!','');


            FGetOrderPayStateIsOver:=True;
       end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
        //网络异常
        ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
        HideWaitingFrame;

        //获取订单支付结果失败
        HideFrame;//(Self,hfcttBeforeShowFrame);
        ShowFrame(TFrame(GlobalPayOrderResultFrame),TFramePayOrderResult);
//        GlobalPayOrderResultFrame.FrameHistroy:=CurrentFrameHistroy;
        GlobalPayOrderResultFrame.Load(FOrder.sum_money,
                                      FOrder.client_bear_pay_fee,
                                      Self.lbPaymentTypeList.Prop.SelectedItem.Name,'','获取订单支付结果失败!','');


        FGetOrderPayStateIsOver:=True;
    end;
  finally
    //去掉了
    //HideWaitingFrame
  end;

end;

procedure TFramePayOrder.tteOrderTillDoneBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,'正在处理...');
end;

procedure TFramePayOrder.tteOrderTillDoneExecute(ATimerTask: TTimerTask);
begin
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('money_payed',
                          nil,
                          PayCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'money_fid',
                          'third_pay_no'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          FMoneyFID,
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

procedure TFramePayOrder.tteOrderTillDoneExecuteEnd(ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //刷新订单状态
        tmrGetOrderPayStateTimer(nil);
//        Self.tmrGetOrderPayState.Enabled:=True;
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

procedure TFramePayOrder.ttePayByAccountBalanceBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,'余额支付中...');
end;

procedure TFramePayOrder.ttePayByAccountBalanceExecute(ATimerTask: TTimerTask);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
        SimpleCallAPI('pay_by_user_money',
                      nil,
                      PayCenterInterfaceUrl,
                      ['appid',
                      'user_fid',
                      'money_fid'],
                      [AppID,
                      GlobalManager.User.fid,
                      FUserBillMoneyFID//资金往来FID
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

procedure TFramePayOrder.ttePayByAccountBalanceExecuteEnd(
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

        //刷新订单的支付状态
        tmrGetOrderPayStateTimer(nil);
//        Self.tmrGetOrderPayState.Enabled:=True;

      end
      else
      begin
        //用户余额支付失败
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

procedure TFramePayOrder.tteUserPrePayOrderBegin(Sender: TTimerTask);
begin
  ShowWaitingFrame(Self,'加载中...');
end;

procedure TFramePayOrder.tteUserPrePayOrderExecute(ATimerTask: TTimerTask);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
        SimpleCallAPI('user_prepay_order',
                      nil,
                      ShopCenterInterfaceUrl,
                      ['appid',
                      'user_fid',
                      'key',
                      'order_fid',
                      'pay_type'],
                      [AppID,
                      GlobalManager.User.fid,
                      GlobalManager.User.key,
                      FOrder.fid,//订单FID
                      //支付类型
                      Self.lbPaymentTypeList.Prop.SelectedItem.Name
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


procedure TFramePayOrder.tteUserPrePayOrderExecuteEnd(ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
              //调起相关的支付
              FUserBillMoneyFID:=ASuperObject.O['Data'].A['UserBillMoney'].O[0].I['fid'];

              if ASuperObject.O['Data'].Contains('AppPayTypeInfo')
                and (ASuperObject.O['Data'].O['AppPayTypeInfo'].I['is_common_web_pay']=1)
                and ASuperObject.O['Data'].Contains('PayInfo')
                and (ASuperObject.O['Data'].O['PayInfo'].S['PayUrl']<>'') then
              begin

                    //直接跳转到浏览器进行支付
                    //调起浏览器
                    OpenWebBrowserAndNavigateURL(
                      ASuperObject.O['Data'].O['PayInfo'].S['PayUrl']);
                    //刷新订单的支付状态
                    tmrGetOrderPayStateTimer(nil);

              end
              else
              if ASuperObject.O['Data'].Contains('WxPayBack') then
              begin
                {$IFDEF HAS_WXPAY}
                GlobalWeiChat.DirectPay(
                      ASuperObject.O['Data'].O['WxPayBack'].S['AppID'],
                      ASuperObject.O['Data'].O['WxPayBack'].S['PartnerID'],
                      ASuperObject.O['Data'].O['WxPayBack'].S['PrepayId'],
                      ASuperObject.O['Data'].O['WxPayBack'].S['NonceStr'],
                      ASuperObject.O['Data'].O['WxPayBack'].I['TimeStamp'],
                      ASuperObject.O['Data'].O['WxPayBack'].S['Sign']
                      );

                //刷新订单的支付状态
                Self.tmrGetOrderPayState.Enabled:=True;
                {$ENDIF HAS_WXPAY}

                //在Windows下面模拟微信支付
                {$IFDEF MSWINDOWS}
                tteSimulatorOrderWxpaySucc.Run;
                {$ENDIF MSWINDOWS}
              end
              else
              if ASuperObject.O['Data'].Contains('AliPayBack') then
              begin
                    //支付宝支付
                    //"AliPayBack": {
                    //  "PayOrderUrl": "app_id=2017080908103143&biz_content={"
                    //  timeout_express ":"
                    //  30 m ","
                    //  product_code ":"
                    //  QUICK_MSECURITY_PAY ","
                    //  total_amount ":"
                    //  901 ","
                    //  subject ":"\
                    //  u8BA2\ u535524\ u652F\ u4ED8\ u4E2D...","
                    //  body ":"\
                    //  u8BA2\ u5355\ u53F7: DH - 20180508 - 0029 + \u7684\ u8BA2\ u5355\ u6B63\ u5728\ u4ED8\ u6B3E...","
                    //  out_trade_no ":"
                    //  C00DF1ABD083492588AB053472144A5A "}&charset=utf-8&method=alipay.trade.app.pay&notify_url=http://www.orangeui.cn:10004&sign_type=RSA&timestamp=2018-05-10+13:00:17&version=1.0&sign=LpxwENudcLY8GJUnaFAx5Tn8KBQDUvjpV9CtjWOJLipcTYt8Bs0kAZ8aXPhFsNIicxo/+29IAGqFyWi7gEXIAdrVLO+lxpITE5EQaMDPqeIQTqoLuaH19Gt+eIxZKfm2hylR/VRSSmfYKDOP1b2y06QIxwOaebjJ62h4zqrR1T4="
                    //}


                    {$IFDEF HAS_ALIPAY}
                      {$IFNDEF MSWINDOWS}
                      GlobalAlipayMobilePay.DirectPay(ASuperObject.O['Data'].O['AliPayBack'].S['PayOrderUrl']);
                      //刷新订单的支付状态
                      Self.tmrGetOrderPayState.Enabled:=True;
                      {$ENDIF MSWINDOWS}
                    {$ENDIF HAS_ALIPAY}


                    //在Windows下面模拟支付宝支付
                    {$IFDEF MSWINDOWS}
                    tteSimulatorOrderAlipaySucc.Run;
                    {$ENDIF MSWINDOWS}


              end
              else
              //PxPay支付
              if ASuperObject.O['Data'].Contains('PxPayBack') then
              begin
                    tteSimulatorOrderPxpaySucc.Run;
              end
              else
              //使用账户余额支付
              if Self.lbPaymentTypeList.Prop.SelectedItem.Name=Const_PaymentType_AccountBalance then
              begin
                    Self.ttePayByAccountBalance.Run;
              end
              else
              //货到付款 pos机刷卡
              if ASuperObject.O['Data'].Contains('OffLinePayBack') then
              begin
                    //调用类似支付完成的接口
                    //ADataJson.O['OffLinePayBack'].I['money_fid']:=AMoneyFID;
                    FMoneyFID:=ASuperObject.O['Data'].O['OffLinePayBack'].I['money_fid'];

                    Self.tteOrderTillDone.Run;

              end;

      end

      else
      begin
        //获取订单预付信息失败
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

