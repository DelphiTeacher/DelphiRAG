//余额详情

unit ShopBalanceInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  MessageBoxFrame,
  Math,
  uUIFunction,
  uManager,
  uOpenClientCommon,
  uOpenCommon,
  uGPSLocation,
//  uOpenClientCommon,

//  uOpenCommon,

  uFuncCommon,
  uBaseList,
  uLang,

  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,

  uBufferBitMap,

  XSuperObject,
  XSuperJson,

  uSkinItems,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinPanelType, uSkinFireMonkeyPanel,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uDrawCanvas;

type
  TFrameShopBalanceInfo = class(TFrame)
    lbInfo: TSkinFMXListBox;
    idpInfo: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    idpItem1: TSkinFMXItemDesignerPanel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lblOption: TSkinFMXLabel;
    btnLook: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lbInfoClickItem(AItem: TSkinItem);
  private
    FFilterMoneyFID:Integer;

    FUserBillMoney:TUserBillMoney;

    //获取交易明细详情
    procedure DoGetTransactionInfoExecute(ATimerTask:TObject);
    procedure DoGetTransactionInfoExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    procedure Clear;
    //加载
    procedure Init(AFilterMoneyFID:Integer);

    //加载列表
    procedure Load(AUserBillMoney:TUserBillMoney);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalShopBalanceInfoFrame:TFrameShopBalanceInfo;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame,
  ShopBalanceOrderInfoFrame;




{ TFrameShopBalanceInfo }

procedure TFrameShopBalanceInfo.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameShopBalanceInfo.Clear;
var
  I: Integer;
begin
  FFilterMoneyFID:=0;

  for I := 0 to Self.lbInfo.Prop.Items.Count-1 do
  begin
    if Self.lbInfo.Prop.Items[I].ItemType=sitDefault then
    begin
      Self.lbInfo.Prop.Items[I].Detail:='';
    end;
  end;
end;

constructor TFrameShopBalanceInfo.Create(AOwner: TComponent);
begin
  inherited;
  FUserBillMoney:=TUserBillMoney.Create;


  {$IFDEF CLIENT_APP}
  //客户端不显示查看账单
  Self.lbInfo.Prop.Items.FindItemByName('check_bill').Visible:=False;
  {$ENDIF CLIENT_APP}


  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameShopBalanceInfo.Destroy;
begin
  FreeAndNil(FUserBillMoney);
  inherited;
end;

procedure TFrameShopBalanceInfo.DoGetTransactionInfoExecute(
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

procedure TFrameShopBalanceInfo.DoGetTransactionInfoExecuteEnd(
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

procedure TFrameShopBalanceInfo.Init(AFilterMoneyFID:Integer);
begin
  Clear;

  FFilterMoneyFID:=AFilterMoneyFID;

  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                   DoGetTransactionInfoExecute,
                   DoGetTransactionInfoExecuteEnd,
                   'GetTransactionInfo');
end;

procedure TFrameShopBalanceInfo.lbInfoClickItem(AItem: TSkinItem);
begin
  if AItem.ItemType=sitItem1 then
  begin
    //显示列表
    //隐藏
    HideFrame;//(Self,hfcttBeforeShowFrame);
   //显示交易信息详情
    ShowFrame(TFrame(GlobalShopBalanceOrderInfoFrame),TFrameShopBalanceOrderInfo,frmMain,nil,nil,nil,Application);
//    GlobalShopBalanceOrderInfoFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalShopBalanceOrderInfoFrame.Init(FUserBillMoney.fid);
  end;
end;

procedure TFrameShopBalanceInfo.Load(AUserBillMoney: TUserBillMoney);
begin

  //只保留两位小数
  if AUserBillMoney.money<0 then
  begin
    Self.lbInfo.Prop.Items.FindItemByCaption('金额').Detail:=Format('%.2f',[AUserBillMoney.money]);
  end
  else
  begin
    Self.lbInfo.Prop.Items.FindItemByCaption('金额').Detail:='+'+Format('%.2f',[AUserBillMoney.money]);
  end;



  Self.lbInfo.Prop.Items.FindItemByCaption('类型').Detail:=GetBillMoneyType(AUserBillMoney.money_type);

  Self.lbInfo.Prop.Items.FindItemByCaption('描述').Detail:=AUserBillMoney.order_desc;

  //只保留两位小数
  Self.lbInfo.Prop.Items.FindItemByCaption('余额').Detail:=Trans('￥')+Format('%.2f',[AUserBillMoney.user_money]);


  Self.lbInfo.Prop.Items.FindItemByCaption('备注').Detail:=AUserBillMoney.name;


  Self.lbInfo.Prop.Items.FindItemByCaption('创建时间').Detail:=AUserBillMoney.createtime;
  Self.lbInfo.Prop.Items.FindItemByCaption('交易流水号').Detail:=IntToStr(AUserBillMoney.order_fid);



end;

end.
