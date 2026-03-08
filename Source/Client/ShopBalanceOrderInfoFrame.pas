unit ShopBalanceOrderInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uBaseList,
  uManager,
  uOpenClientCommon,
  uOpenCommon,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uAPPCommon,

  uDataSetToJson,
//  uOpenClientCommon,

  MessageBoxFrame,
  TakePictureMenuFrame,
  ClipHeadFrame,
  WaitingFrame,
  EasyServiceCommonMaterialDataMoudle,

  uBaseHttpControl,
  uRestInterfaceCall,
//  uCommonUtils,
  uFuncCommon,
  uSkinItems,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uDrawCanvas;

type
  TFrameShopBalanceOrderInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlSummary: TSkinFMXPanel;
    lblCount: TSkinFMXLabel;
    lblSum: TSkinFMXLabel;
    lblSumMoneyValue: TSkinFMXLabel;
    pnlCaption: TSkinFMXPanel;
    lblTitle3: TSkinFMXLabel;
    lblTitle2: TSkinFMXLabel;
    lblTitle: TSkinFMXLabel;
    lbSummary: TSkinFMXListBox;
    idpGoods: TSkinFMXItemDesignerPanel;
    lblHotelName: TSkinFMXLabel;
    lblHotelMoney: TSkinFMXLabel;
    lblHotelNumber: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
  private
    FFilterFID:Integer;

    //加载列表
    procedure DoGetBillMoneyDetailListExecute(ATimerTask:TObject);
    procedure DoGetBillMoneyDetailListExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    procedure Clear;
    //加载
    procedure Init(AFilterFID:Integer);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalShopBalanceOrderInfoFrame:TFrameShopBalanceOrderInfo;

implementation

{$R *.fmx}

{ TFrameShopBalanceOrderInfo }

procedure TFrameShopBalanceOrderInfo.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameShopBalanceOrderInfo.Clear;
begin
  Self.lblSum.Caption:='';
  Self.lblSumMoneyValue.Caption:='';

  Self.lbSummary.Prop.Items.Clear(True);
end;

constructor TFrameShopBalanceOrderInfo.Create(AOwner: TComponent);
begin
  inherited;
  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameShopBalanceOrderInfo.Destroy;
begin

  inherited;
end;

procedure TFrameShopBalanceOrderInfo.DoGetBillMoneyDetailListExecute(
  ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('get_user_bill_money_detail_list',
                          nil,
                          PayCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'money_fid'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          FFilterFID
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

procedure TFrameShopBalanceOrderInfo.DoGetBillMoneyDetailListExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AListBoxItem:TSkinListBoxItem;
  ASummaryObject:ISuperObject;
  I: Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        Self.lblSum.Caption:='共'+IntToStr(ASuperObject.O['Data'].I['Counts'])+'单';

        Self.lblSumMoneyValue.Caption:='+'+Format('%.2f',[GetJsonDoubleValue(ASuperObject.O['Data'],'SumMoney')]);
        //获取成功
        Self.lbSummary.Prop.Items.Clear(True);

        try
          Self.lbSummary.Prop.Items.BeginUpdate;
          for I := 0 to ASuperObject.O['Data'].A['UserBillMoneyDetailList'].Length-1 do
          begin
            ASummaryObject:=ASuperObject.O['Data'].A['UserBillMoneyDetailList'].O[I];
            AListBoxItem:=Self.lbSummary.Prop.Items.Add;
            AListBoxItem.Detail6:=ASummaryObject.AsJSON;
            AListBoxItem.Caption:=IntToStr(ASummaryObject.I['fid']);
            AListBoxItem.Detail:='+'+Format('%.2f',[GetJsonDoubleValue(ASummaryObject,'money')]);
            AListBoxItem.Detail1:=ASummaryObject.S['bill_code'];
          end;
        finally
          Self.lbSummary.Prop.Items.EndUpdate();
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


procedure TFrameShopBalanceOrderInfo.Init(AFilterFID: Integer);
begin
  FFilterFID:=AFilterFID;

  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                DoGetBillMoneyDetailListExecute,
                DoGetBillMoneyDetailListExecuteEnd,
                'GetBillMoneyDetailList');
end;

end.

