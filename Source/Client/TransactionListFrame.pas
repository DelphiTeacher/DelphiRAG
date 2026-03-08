unit TransactionListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  MessageBoxFrame,
  uUIFunction,
  uManager,
  uOpenClientCommon,
  uOpenCommon,

  uGPSLocation,

  uFuncCommon,
  uBaseList,
//  uOpenCommon,

  uTimerTask,
//  uOpenClientCommon,
  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,

  uBufferBitMap,

  XSuperObject,
  XSuperJson,

  uSkinItems,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType,
  uSkinFireMonkeyListBox, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel, uSkinImageType,
  uSkinFireMonkeyImage, uDrawCanvas;

type
  TFrameTransactionList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlFilter: TSkinFMXPanel;
    lbFilter: TSkinFMXListBox;
    btnDisplay: TSkinFMXButton;
    lbTransaction: TSkinFMXListBox;
    idpTransaction: TSkinFMXItemDesignerPanel;
    idpFilter: TSkinFMXItemDesignerPanel;
    lblFilter: TSkinFMXLabel;
    lblOption: TSkinFMXLabel;
    lblShopName: TSkinFMXLabel;
    lblTime: TSkinFMXLabel;
    lblMoney: TSkinFMXLabel;
    lblState: TSkinFMXLabel;
    imgSign: TSkinFMXImage;
    procedure btnReturnClick(Sender: TObject);
    procedure lbTransactionPullDownRefresh(Sender: TObject);
    procedure lbTransactionPullUpLoadMore(Sender: TObject);
    procedure lbFilterClickItem(AItem: TSkinItem);
    procedure lbTransactionClickItem(AItem: TSkinItem);
    procedure lbFilterResize(Sender: TObject);
    procedure btnDisplayClick(Sender: TObject);
  private
    FPageIndex:Integer;

    FFilterMoneyType:String;
    FFilterOrderType:String;

    //用户资金往来列表
    FUserBillMoneyList:TUserBillMoneyList;
  private
    //从筛选页面返回
    procedure OnReturnFromBillMoneyFrame(AFrame:TFrame);
    { Private declarations }
  public
    //清空列表
    procedure Clear;
    //获取交易列表
    procedure InitTransactionList(AFilterMoneyType:String;
                                  AFilterOrderType:String);

    //交易列表接口
    procedure DoGetTransactionListExecute(ATimerTask:TObject);
    procedure DoGetTransactionListExecuteEnd(ATimerTask:TObject);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalTransactionListFrame:TFrameTransactionList;

implementation

{$R *.fmx}
uses
  MainForm,MainFrame,TransactionInfoFrame,BillMoneyFilterFrame;

{ TFrameTransactionList }


procedure TFrameTransactionList.btnDisplayClick(Sender: TObject);
var
  I: Integer;
  AFilterString:String;
  AFilterMoneyType:String;
begin
  AFilterString:='';
  AFilterMoneyType:='';
  for I := 0 to Self.lbFilter.Prop.Items.Count-1 do
  begin
    if Self.lbFilter.Prop.Items[I].Selected=True then
    begin
      AFilterString:=Self.lbFilter.Prop.Items[I].Caption;
      AFilterMoneyType:=Self.lbFilter.Prop.Items[I].Name;
    end;
  end;
  ShowFrame(TFrame(GlobalBillMoneyFilterFrame),TFrameBillMoneyFilter,frmMain,nil,nil,OnReturnFromBillMoneyFrame,Application,True,False,ufsefNone);
//  GlobalBillMoneyFilterFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalBillMoneyFilterFrame.Load(AFilterString,AFilterMoneyType);
end;

procedure TFrameTransactionList.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameTransactionList.Clear;
begin
  Self.lbTransaction.Prop.Items.Clear(True);
end;

constructor TFrameTransactionList.Create(AOwner: TComponent);
begin
  inherited;
  FUserBillMoneyList:=TUserBillMoneyList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameTransactionList.Destroy;
begin
  FreeAndNil(FUserBillMoneyList);
  inherited;
end;

procedure TFrameTransactionList.DoGetTransactionListExecute(
  ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('get_user_bill_money_list',
                          nil,
                          PayCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'filter_start_date',
                          'filter_end_date',
                          'filter_money_type',
                          'filter_order_type',
                          'pageindex',
                          'pagesize'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          '',
                          '',
                          FFilterMoneyType,
                          '',
                          FPageIndex,
                          20
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

procedure TFrameTransactionList.DoGetTransactionListExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AUserBillMoneyList:TUserBillMoneyList;
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
  ADateTime:TDateTime;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        if FPageIndex=1 then
        begin
          Self.lbTransaction.Prop.Items.Clear(True);
          Self.FUserBillMoneyList.Clear(True);
        end;
        //获取成功，加载列表
        AUserBillMoneyList:=TUserBillMoneyList.Create(ooReference);
        AUserBillMoneyList.ParseFromJsonArray(TUserBillMoney,ASuperObject.O['Data'].A['UserBillMoneyList']);

        Self.lbTransaction.Prop.Items.BeginUpdate;
        try
          for I := 0 to AUserBillMoneyList.Count-1 do
          begin
            AListBoxItem:=Self.lbTransaction.Prop.Items.Add;
            Self.FUserBillMoneyList.Add(AUserBillMoneyList[I]);
            AListBoxItem.Data:=AUserBillMoneyList[I];
            AListBoxItem.Caption:=AUserBillMoneyList[I].name;
            ADateTime:=StandardStrToDateTime(AUserBillMoneyList[I].createtime);
            AListBoxItem.Detail:=FormatDateTime('YYYY-MM-DD HH:MM',ADateTime);
            if AUserBillMoneyList[I].money>0 then
            begin
              AListBoxItem.Detail1:='+'+Format('%.2f',[AUserBillMoneyList[I].money]);
            end
            else
            begin
              AListBoxItem.Detail1:=Format('%.2f',[AUserBillMoneyList[I].money]);
            end;



            AListBoxItem.Detail2:=GetPayStateStr(AUserBillMoneyList[I].pay_state);
//            if AUserBillMoneyList[I].pay_state='payed' then
//            begin
//              AListBoxItem.Detail2:='支付完成';
//            end
//            else if AUserBillMoneyList[I].pay_state='refuned' then
//            begin
//              AListBoxItem.Detail2:='已退款';
//            end
//            else if AUserBillMoneyList[I].pay_state='' then
//            begin
//              if AUserBillMoneyList[I].money_type='consume' then
//              begin
//                AListBoxItem.Detail2:='等待支付';
//              end
//              else if AUserBillMoneyList[I].money_type='refund' then
//              begin
//                AListBoxItem.Detail2:='已退款';
//              end;
//            end;

          end;
        finally
          Self.lbTransaction.Prop.Items.EndUpdate();
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
      if ASuperObject.O['Data'].A['UserBillMoneyList'].Length>0 then
      begin
        Self.lbTransaction.Prop.StopPullUpLoadMore('加载成功!',0,True);
      end
      else
      begin
        Self.lbTransaction.Prop.StopPullUpLoadMore('下面没有了!',600,False);
      end;
    end
    else
    begin
      Self.lbTransaction.Prop.StopPullDownRefresh('刷新成功!',600);
    end;

    FreeAndNil(AUserBillMoneyList);
  end;
end;

procedure TFrameTransactionList.InitTransactionList(AFilterMoneyType:String;
                                  AFilterOrderType:String);
begin
  Self.Clear;

  FFilterMoneyType:=AFilterMoneyType;

  FFilterOrderType:=AFilterOrderType;

  Self.lbTransaction.Prop.StartPullDownRefresh;

end;

procedure TFrameTransactionList.lbFilterClickItem(AItem: TSkinItem);
var
  I: Integer;
begin
  AItem.Selected:=True;

  FFilterMoneyType:=AItem.Name;

  for I := 0 to Self.lbTransaction.Prop.Items.Count-1 do
  begin
    if AItem.Caption<>Self.lbTransaction.Prop.Items[I].Caption then
    begin
      Self.lbTransaction.Prop.Items[I].Selected:=False;
    end;
  end;

  Self.lbTransaction.Prop.StartPullDownRefresh;
end;

procedure TFrameTransactionList.lbFilterResize(Sender: TObject);
begin

  if Self.Width>Self.lbFilter.Prop.Items.Count*70 then
  begin
    Self.lbFilter.Prop.ItemSpace:=(Self.Width-Self.lbFilter.Prop.Items.Count*70-20)/6;
  end
  else
  begin
    Self.lbFilter.Prop.ItemSpace:=0;
  end;

end;

procedure TFrameTransactionList.lbTransactionClickItem(AItem: TSkinItem);
var
  AUserBillMoney:TUserBillMoney;
begin
  AUserBillMoney:=TUserBillMoney(AItem.Data);
  //隐藏
  HideFrame;//(Self,hfcttBeforeShowFrame);
 //显示交易信息详情
  ShowFrame(TFrame(GlobalTransactionInfoFrame),TFrameTransactionInfo,frmMain,nil,nil,nil,Application);
//  GlobalTransactionInfoFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalTransactionInfoFrame.GetTransactionInfo(AUserBillMoney.fid);
end;

procedure TFrameTransactionList.lbTransactionPullDownRefresh(Sender: TObject);
begin
  FPageIndex:=1;

  uTimerTask.GetGlobalTimerThread.RunTempTask(
                   DoGetTransactionListExecute,
                   DoGetTransactionListExecuteEnd,
                   'GetTransactionList');
end;

procedure TFrameTransactionList.lbTransactionPullUpLoadMore(Sender: TObject);
begin
  FPageIndex:=FPageIndex+1;

  uTimerTask.GetGlobalTimerThread.RunTempTask(
                   DoGetTransactionListExecute,
                   DoGetTransactionListExecuteEnd,
                   'GetTransactionList');
end;

procedure TFrameTransactionList.OnReturnFromBillMoneyFrame(AFrame: TFrame);
var
  I: Integer;
begin
  for I := 0 to Self.lbFilter.Prop.Items.Count-1 do
  begin
    if Self.lbFilter.Prop.Items[I].Name=GlobalBillMoneyFilterFrame.FFilterMoneyType then
    begin
      Self.lbFilter.Prop.Items[I].Selected:=True;
    end
    else
    begin
      Self.lbFilter.Prop.Items[I].Selected:=False;
    end;
  end;

  FFilterMoneyType:=GlobalBillMoneyFilterFrame.FFilterMoneyType;

  Self.lbTransaction.Prop.StartPullDownRefresh;
end;

end.


