unit ScoreRechargeFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Platform, FMX.Dialogs, FMX.StdCtrls,

  DateUtils,
  uConst,
  StrUtils,
  //翻译
  FMX.Consts,
  uBaseLog,

  uSkinMaterial,
  uDataSetToJson,
  {$IFDEF HAS_WXPAY}
  uWeiChat,
  {$ENDIF HAS_WXPAY}

  {$IFDEF HAS_ALIPAY}
  uAlipayMobilePay,
  {$ENDIF HAS_ALIPAY}

  Math,
  uAppCommon,
  uSkinItems,
  uSkinBufferBitmap,
  uFuncCommon,
  uFileCommon,
  uOpenClientCommon,
  uManager,
  uTimerTask,
  uDrawPicture,
  uUIFunction,
  uRestInterfaceCall,
  uSkinItemJsonHelper,
  MessageBoxFrame,
  WaitingFrame,
  HintFrame,
  uOpenCommon,
  WebBrowserFrame,
  ViewPictureListFrame,
  uSkinControlGestureManager,
  uUrlPicture,
  uDownloadPictureManager,
  ListItemStyleFrame_MyGameGiftPackage,

  uDrawCanvas,
  XSuperObject,
  XSuperJson,
  uMobileUtils,
  uBaseHttpControl,
  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,

  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinFireMonkeyImage,
  uSkinFireMonkeyLabel, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, uSkinFireMonkeyFrameImage, uSkinLabelType,
  uSkinImageType, uSkinFrameImageType,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinButtonType, uBaseSkinControl,
  uSkinPanelType, uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinCustomListType, uSkinVirtualListType, uSkinListViewType,
  uSkinFireMonkeyListView, uTimerTaskEvent, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit;

type
  TFrameScoreRecharge = class(TFrame)
    lvData: TSkinFMXListView;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlContainer: TSkinFMXPanel;
    lblHint: TSkinFMXLabel;
    pnlPayGroup: TSkinFMXPanel;
    btnAliPay: TSkinFMXButton;
    btnWxPay: TSkinFMXButton;
    btnWXPayInner: TSkinFMXButton;
    btnAliPayInner: TSkinFMXButton;
    btnOK: TSkinFMXButton;
    edtMoney: TSkinFMXEdit;
    tmrGetUserBillMoneyPayState: TTimer;
    tteGetOrderPayState: TTimerTaskEvent;
    procedure btnOKClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure tmrGetUserBillMoneyPayStateTimer(Sender: TObject);
    procedure tteGetOrderPayStateExecute(ATimerTask: TTimerTask);
    procedure tteGetOrderPayStateExecuteEnd(ATimerTask: TTimerTask);
  private
    //充值操作
    procedure DoPayMoneyExecute(ATimerTask:TObject);
    procedure DoPayMoneyExecuteEnd(ATimerTask:TObject);

  private
    //可用金额
    FUsedMoney:Double;

    FGetOrderPayStateStartTime:TDateTime;
    FGetOrderPayStateCount:Integer;
    FGetOrderPayStateIsOver:Boolean;
  public
    constructor Create(AOwner:TComponent);override;
  public
    //兑换比例
    FScoreRatio:Double;
    //支付方式
    FPayType:String;
    //用户资金往来记录FID
    FUserBillMoneyFID:Integer;

    FrameHistroy:TFrameHistroy;

    procedure Clear;
    procedure Load;
    { Public declarations }
  end;

var
  GlobalScoreRechargeFrame:TFrameScoreRecharge;

implementation

uses
  MainForm,
  MainFrame,
  UserInfoFrame;

{$R *.fmx}

{ TFrameScoreRecharge }

procedure TFrameScoreRecharge.btnOKClick(Sender: TObject);
begin
  //选择完毕后确认充值
  if lvData.Prop.SelectedItem <> nil then
  begin
    Self.edtMoney.Text:=lvData.Prop.SelectedItem.Detail1;
  end
  else
  begin
    ShowHintFrame(Self,'请选择要充值的金额!');
    Exit;
  end;

  //选择支付方式
  if btnWXPayInner.Properties.IsPushed=True then
  begin
    FPayType:=Const_PaymentType_WeiXinPay;
  end
  else if btnAliPayInner.Properties.IsPushed=True then
  begin
    FPayType:=Const_PaymentType_Alipay;
  end
  else if (btnWXPayInner.Properties.IsPushed=False) and (btnAliPayInner.Properties.IsPushed=False) then
  begin
    ShowHintFrame(Self,'请选择支付方式!');
    Exit;
  end;

  //全部选择完毕后执行充值
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                        DoPayMoneyExecute,
                        DoPayMoneyExecuteEnd,
                        'PayMoney');

end;

procedure TFrameScoreRecharge.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame();
  ReturnFrame();
end;

procedure TFrameScoreRecharge.Clear;
begin

end;

constructor TFrameScoreRecharge.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TFrameScoreRecharge.DoPayMoneyExecute(ATimerTask: TObject);
begin
//出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('prepare_pay_order', //
                          nil,
                          PayCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'order_fid',//
                          'money',
                          'order_type',
                          'bill_code',//
                          'pay_type',
                          'name',
                          'desc'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          0,  //
                          StrToFloat(Self.edtMoney.Text),
                          Const_OrderType_InvestScore,
                          '',  //
                          FPayType,
                          '积分充值',
                          '积分充值对应金额'+Self.edtMoney.Text+'元'
                          ]
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

procedure TFrameScoreRecharge.DoPayMoneyExecuteEnd(ATimerTask: TObject);
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
        //调起相关的支付
        FUserBillMoneyFID:=ASuperObject.O['Data'].A['UserBillMoney'].O[0].I['fid'];

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

          //刷新订单的支付状态  微信回来没效果  先注释了
          Self.tmrGetUserBillMoneyPayState.Enabled:=True;
          {$ENDIF HAS_WXPAY}

//          //在Windows下面模拟微信支付
//          {$IFDEF MSWINDOWS}
//          tteSimulatorOrderWxpaySucc.Run;
//          {$ENDIF MSWINDOWS}
        end;

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
                Self.tmrGetUserBillMoneyPayState.Enabled:=True;
                {$ENDIF MSWINDOWS}
              {$ENDIF HAS_ALIPAY}

//              //在Windows下面模拟支付宝支付
//              {$IFDEF MSWINDOWS}
//              tteSimulatorOrderAlipaySucc.Run;
//              {$ENDIF MSWINDOWS}

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

procedure TFrameScoreRecharge.Load;
var
  I:Integer;
begin
  //遍历Items添加兑换积分比例
  for I := 0 to lvData.Prop.Items.Count-1 do
  begin
    lvData.Prop.Items[I].Detail:=FloatToStr( lvData.Prop.Items[I].Detail1.ToInteger * FScoreRatio ) + '积分';
  end;
end;

procedure TFrameScoreRecharge.tmrGetUserBillMoneyPayStateTimer(Sender: TObject);
begin
  Self.tmrGetUserBillMoneyPayState.Enabled:=False;

  FGetOrderPayStateCount:=0;
  FGetOrderPayStateIsOver:=False;

  //获取订单详情,判断是否支付成功
  ShowWaitingFrame(Self,'获取支付结果...');
  Self.tteGetOrderPayState.Run;
end;

procedure TFrameScoreRecharge.tteGetOrderPayStateExecute(
  ATimerTask: TTimerTask);
begin
//出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try

    //3秒中查一次
    Sleep(3000);

    TTimerTask(ATimerTask).TaskDesc:=
        SimpleCallAPI('get_user_bill_money_detail',
                      nil,
                      PayCenterInterfaceUrl,
                      ['appid',
                      'user_fid',
                      'money_fid'],
                      [AppID,
                      GlobalManager.User.fid,
                      FUserBillMoneyFID//资金往来FID
                      ]
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

procedure TFrameScoreRecharge.tteGetOrderPayStateExecuteEnd(
  ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;

  AOrderState:String;
begin
  try
    if FGetOrderPayStateIsOver then Exit;

    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
        if ASuperObject.I['Code']=200 then
        begin

            AOrderState:=ASuperObject.O['Data'].A['UserBillMoneyInfo'].O[0].S['pay_state'];

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

                  if (AOrderState=Const_PayState_Payed) then
                  begin
                      //付款成功
                      HideWaitingFrame;

                      //如果支付完,APP从后台转到前台,会出现白屏的问题
//                      HideFrame(Self,hfcttBeforeShowFrame);

                      //获取用户积分详情
                      {uTimerTask.GetGlobalTimerThread.RunTempTask(
                                              DoGetUserInfoExecute,
                                              DoGetUserInfoExecuteEnd,
                                              'GetUserInfo');}

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
//                        HideFrame(Self,hfcttBeforeShowFrame);

                        //获取用户积分详情
                        {uTimerTask.GetGlobalTimerThread.RunTempTask(
                                              DoGetUserInfoExecute,
                                              DoGetUserInfoExecuteEnd,
                                              'GetUserInfo');}

                        FGetOrderPayStateIsOver:=True;

                      end;
                  end;

            end
            else
            begin
                //在后台
                //继续获取,没有超时的概念
                //获取订单详情,判断是否支付成功
                Self.tteGetOrderPayState.Run;
            end;
//
        end
        else
        begin
          //获取订单支付信息失败
          ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
          HideWaitingFrame;

          FGetOrderPayStateIsOver:=True;
       end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
      HideWaitingFrame;

      FGetOrderPayStateIsOver:=True;
    end;
  finally
    //去掉了
    //HideWaitingFrame
  end;
end;

end.
