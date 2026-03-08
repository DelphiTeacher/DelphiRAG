//交易详情

unit TransactionInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  MessageBoxFrame,
  Math,
  uUIFunction,
  uManager,
  uGPSLocation,

  uFuncCommon,
  uBaseList,

  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  uOpenClientCommon,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,

  uBufferBitMap,

  XSuperObject,
  XSuperJson,

  uSkinItems,

  uOpenCommon,


  uSkinLabelType, uSkinFireMonkeyLabel, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinFireMonkeyControl, uSkinPanelType, uSkinFireMonkeyPanel,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uDrawCanvas;

type
  TFrameTransactionInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lblOption: TSkinFMXLabel;
    lbInfo: TSkinFMXListBox;
    idpInfo: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    idpItem1: TSkinFMXItemDesignerPanel;
    lblMoney: TSkinFMXLabel;
    lblDetailMoney: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
  private
    FUserBillMoney:TUserBillMoney;
    procedure DoGetTransactionInfoExecute(ATimerTask:TObject);
    procedure DoGetTransactionInfoExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    FFilterMoneyFID:Integer;
    //清空列表
    procedure Clear;
    //获取交易详情
    procedure GetTransactionInfo(AFilterMoneyFID:Integer);

    //加载列表
    procedure Load(AUserBillMoney:TUserBillMoney);

  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;



var
  GlobalTransactionInfoFrame:TFrameTransactionInfo;

implementation

{$R *.fmx}

procedure TFrameTransactionInfo.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameTransactionInfo.Clear;
begin
  Self.lbInfo.Prop.Items.FindItemByCaption('支付金额').Detail:=FloatToStr(0.00);


  Self.lbInfo.Prop.Items.FindItemByCaption('支付状态').Detail:='';



  Self.lbInfo.Prop.Items.FindItemByCaption('支付方式').Detail:='';


  Self.lbInfo.Prop.Items.FindItemByCaption('支付创建时间').Detail:='';
  Self.lbInfo.Prop.Items.FindItemByCaption('R4U订单号').Detail:='';
  Self.lbInfo.Prop.Items.FindItemByCaption('交易流水号').Detail:='';

end;

constructor TFrameTransactionInfo.Create(AOwner: TComponent);
begin
  inherited;
  FUserBillMoney:=TUserBillMoney.Create;
end;

destructor TFrameTransactionInfo.Destroy;
begin
  FreeAndNil(FUserBillMoney);
  inherited;
end;

procedure TFrameTransactionInfo.DoGetTransactionInfoExecute(
  ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('get_user_bill_money_detail',
                          nil,
                          PayCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'money_fid'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          FFilterMoneyFID
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

procedure TFrameTransactionInfo.DoGetTransactionInfoExecuteEnd(
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
        //获取成功
        FUserBillMoney.ParseFromJson(ASuperObject.O['Data'].A['UserBillMoneyInfo'].O[0]);

        Load(FUserBillMoney);

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


procedure TFrameTransactionInfo.GetTransactionInfo(AFilterMoneyFID:Integer);
begin
  FFilterMoneyFID:=AFilterMoneyFID;

  Self.Clear;

  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                   DoGetTransactionInfoExecute,
                   DoGetTransactionInfoExecuteEnd,
                   'GetTransactionInfo');
end;

procedure TFrameTransactionInfo.Load(AUserBillMoney: TUserBillMoney);
begin

  Self.lbInfo.Prop.Items.FindItemByCaption('支付金额').Detail:=Format('%.2f',[abs(AUserBillMoney.money)]);

//  if AUserBillMoney.pay_state='payed' then
//  begin
//    Self.lbInfo.Prop.Items.FindItemByCaption('支付状态').Detail:='支付成功';
//  end
//  else if AUserBillMoney.pay_state='refuned' then
//  begin
//    Self.lbInfo.Prop.Items.FindItemByCaption('支付状态').Detail:='退款成功';
//  end
//  else if AUserBillMoney.pay_state='' then
//  begin
//    if AUserBillMoney.money_type='consume' then
//    begin
//      Self.lbInfo.Prop.Items.FindItemByCaption('支付状态').Detail:='等待支付';
//    end
//    else if AUserBillMoney.money_type='refund' then
//    begin
//      Self.lbInfo.Prop.Items.FindItemByCaption('支付状态').Detail:='等待退款';
//    end;
//  end;

  Self.lbInfo.Prop.Items.FindItemByCaption('支付状态').Detail:=GetPayStateStr(AUserBillMoney.pay_state);

//  if AUserBillMoney.pay_type='wxpay' then
//  begin
//    Self.lbInfo.Prop.Items.FindItemByCaption('支付方式').Detail:='微信';
//  end
//  else if AUserBillMoney.pay_type='alipay' then
//  begin
//    Self.lbInfo.Prop.Items.FindItemByCaption('支付方式').Detail:='支付宝';
//  end
//  else if AUserBillMoney.pay_type='account_balance' then
//  begin
//    Self.lbInfo.Prop.Items.FindItemByCaption('支付方式').Detail:='余额';
//  end
//  else if AUserBillMoney.pay_type='bank_transer' then
//  begin
//    Self.lbInfo.Prop.Items.FindItemByCaption('支付方式').Detail:='线下转账';
//  end;

  Self.lbInfo.Prop.Items.FindItemByCaption('支付方式').Detail:=GetPaymentTypeStr(AUserBillMoney.pay_type);


  Self.lbInfo.Prop.Items.FindItemByCaption('支付创建时间').Detail:=AUserBillMoney.createtime;
  Self.lbInfo.Prop.Items.FindItemByCaption('R4U订单号').Detail:=AUserBillMoney.bill_code;
  Self.lbInfo.Prop.Items.FindItemByCaption('交易流水号').Detail:=IntToStr(AUserBillMoney.order_fid);
  Self.lbInfo.Prop.Items.FindItemByCaption('第三方交易号').Detail:=AUserBillMoney.third_pay_no;

end;

end.

