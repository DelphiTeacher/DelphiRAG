unit UserBalanceFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Platform,DateUtils,

  uSkinMaterial,
  uBaseList,
  uManager,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uAPPCommon,

  uDataSetToJson,
  uOpenClientCommon,
  uFrameContext,
  uDrawCanvas,
  uConst,

  uOpenCommon,
  {$IFDEF HAS_WXPAY}
  uWeiChat,
  {$ENDIF HAS_WXPAY}

  {$IFDEF HAS_ALIPAY}
  uAlipayMobilePay,
  {$ENDIF HAS_ALIPAY}

  MessageBoxFrame,
  HintFrame,
  TakePictureMenuFrame,
  ClipHeadFrame,
  RegisterProtocolFrame,
  WaitingFrame,
  EasyServiceCommonMaterialDataMoudle,

  uBaseHttpControl,
  uRestInterfaceCall,
//  uCommonUtils,
  uFuncCommon,
  uSkinItems,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uTimerTaskEvent;

type
  TFrameUserBalance = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlBankGround: TSkinFMXPanel;
    pnlClient: TSkinFMXPanel;
    lblTitle: TSkinFMXLabel;
    lblBankCard: TSkinFMXLabel;
    lblNumber: TSkinFMXLabel;
    btnInfo: TSkinFMXButton;
    pnlDetail: TSkinFMXPanel;
    lblFilter: TSkinFMXLabel;
    btnHistary: TSkinFMXButton;
    lbFilter: TSkinFMXListBox;
    lbList: TSkinFMXListBox;
    idpFilter: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    idpContent: TSkinFMXItemDesignerPanel;
    lblType: TSkinFMXLabel;
    lblTime: TSkinFMXLabel;
    lblMoneyValue: TSkinFMXLabel;
    lblCash: TSkinFMXLabel;
    btnCashIn: TSkinFMXButton;
    btnCash: TSkinFMXButton;
    pnlMoneyInMessageBoxContent: TSkinFMXPanel;
    edtMoney: TSkinFMXEdit;
    btnWXPay: TSkinFMXButton;
    lblNotice: TSkinFMXLabel;
    btnAliPay: TSkinFMXButton;
    mcMoney: TSkinFMXMultiColorLabel;
    tmrGetUserBillMoneyPayState: TTimer;
    tteGetOrderPayState: TTimerTaskEvent;
    SkinFMXButton1: TSkinFMXButton;
    procedure lbFilterResize(Sender: TObject);
    procedure lbListPullDownRefresh(Sender: TObject);
    procedure lbListPullUpLoadMore(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure lbFilterClickItem(AItem: TSkinItem);
    procedure btnInfoClick(Sender: TObject);
    procedure lbListClickItem(AItem: TSkinItem);
    procedure btnCashClick(Sender: TObject);
    procedure lbListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure btnCashInClick(Sender: TObject);
    procedure btnWXPayClick(Sender: TObject);
    procedure btnAliPayClick(Sender: TObject);
    procedure pnlClientResize(Sender: TObject);
    procedure tmrGetUserBillMoneyPayStateTimer(Sender: TObject);
    procedure tteGetOrderPayStateExecute(ATimerTask: TTimerTask);
    procedure tteGetOrderPayStateExecuteEnd(ATimerTask: TTimerTask);
    procedure pnlMoneyInMessageBoxContentResize(Sender: TObject);
    procedure SkinFMXButton1Click(Sender: TObject);
  private
    FPageIndex:Integer;
    FFilterMoneyType:String;

//    FFilterStartDate:String;
//    FFilterEndDate:String;

    FGetOrderPayStateStartTime:TDateTime;
    FGetOrderPayStateCount:Integer;
    FGetOrderPayStateIsOver:Boolean;

    //用户资金往来列表
    FUserBillMoneyList:TUserBillMoneyList;
    procedure DoGetTransactionListExecute(ATimerTask:TObject);
    procedure DoGetTransactionListExecuteEnd(ATimerTask:TObject);
  private
    FBankCardList:TBankCardList;
    //获取银行卡
    procedure GetUserBankCardList;
    //获取银行卡列表
    procedure DoGetBankCardListExecute(ATimerTask:TObject);
    procedure DoGetBankCardListExecuteEnd(ATimerTask:TObject);

    //获取支付中心参数
    procedure DoGetPayCenterSettingExecute(ATimerTask:TObject);
//    procedure DoGetPayCenterSettingExecuteEnd(ATimerTask:TObject);

    //从提交申请页面返回
    procedure OnReturnFromWithDrawFrame(AFrame:TFrame);
    //获取用户余额
    procedure DoGetUserUsedMoneyExecute(ATimerTask:TObject);
    procedure DoGetUserUsedMoneyExecuteEnd(ATimerTask:TObject);

    //充值操作
    procedure DoPayMoneyExecute(ATimerTask:TObject);
    procedure DoPayMoneyExecuteEnd(ATimerTask:TObject);

    //从添加银行卡返回
    procedure OnReturnFromAddMyBankCard(AFrame:TFrame);
    //从查看银行卡列表返回
    procedure OnReturnFrameBankCardList(AFrame:TFrame);
    //从充值返回
    procedure OnCheckMoneyInMessageBoxModalResult(Sender: TObject);
  private
    //从绑定银行卡的弹出框返回
    procedure OnModalResultFromBandingBankCard(AFrame:TObject);
    { Private declarations }
  public
    //提现起提金额
    FWithDrawBeginMoney:Integer;

    //余额
    FUsedMoney:Double;
    //支付方式
    FPayType:String;
    //用户资金往来记录FID
    FUserBillMoneyFID:Integer;

    procedure Clear;
    procedure Init(AFilterMoney:Double);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalUserBalanceFrame:TFrameUserBalance;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame,
//  ShopBalanceInfoFrame,
  AddMyBankCardFrame,
  MyBankCardListFrame,
  WithDrawMoneyFrame;

procedure TFrameUserBalance.btnAliPayClick(Sender: TObject);
begin
  if Self.edtMoney.Text='' then
  begin
    ShowHintFrame(Self,'请输入充值金额!');
//    ShowMessageBoxFrame(Self,'请输入充值金额!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if StrToFloat(Self.edtMoney.Text)<1 then
  begin
    ShowHintFrame(Self,'最低充值额度为1元!');
//    ShowMessageBoxFrame(Self,'最低充值额度为1元!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  GlobalMessageBoxFrame.HideMessageBox;

  FPayType:=Const_PaymentType_Alipay;
  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                              DoPayMoneyExecute,
                              DoPayMoneyExecuteEnd,
                              'PayMoney');

//  ShowMessageBoxFrame(Self,'跳转支付宝支付界面...','',TMsgDlgType.mtInformation,['确定'],nil);
end;

procedure TFrameUserBalance.btnCashClick(Sender: TObject);
begin
  if Self.FUsedMoney>0 then
  begin
    if GlobalManager.UserBankCardList.Count=0 then
    begin
      ShowMessageBoxFrame(Self,'您该没有绑定银行卡,是否去绑定?','',TMsgDlgType.mtInformation,['去绑定','不了,谢谢'],OnModalResultFromBandingBankCard);
      Exit;
    end
    else
    begin

        if (FWithDrawBeginMoney>0) and (Self.FUsedMoney<FWithDrawBeginMoney) then
        begin
          //余额为零不提现
          ShowMessageBoxFrame(Self,'余额满'+IntToStr(FWithDrawBeginMoney)+'才可提现!','',TMsgDlgType.mtInformation,['确定'],nil);
          Exit;
        end;

        //显示提现申请页面
        HideFrame;//(Self,hfcttBeforeShowFrame);
        //显示交易列表
        ShowFrame(TFrame(GlobalWithDrawMoneyFrame),TFrameWithDrawMoney,frmMain,nil,nil,OnReturnFromWithDrawFrame,Application);
//        GlobalWithDrawMoneyFrame.FrameHistroy:=CurrentFrameHistroy;
        GlobalWithDrawMoneyFrame.Init(FUsedMoney,
                                      FBankCardList,
                                      //是否限制最小提现金额
                                      Ord((FWithDrawBeginMoney>0)),
                                      FWithDrawBeginMoney);

    end;
  end
  else
  begin
    //余额为零不提现
    ShowMessageBoxFrame(Self,'您没有要提现的余额!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
end;

procedure TFrameUserBalance.btnCashInClick(Sender: TObject);
begin
 //充值
  HideVirtualKeyboard;
  //刚开始是隐藏的   用到的时候显示出来
  Self.pnlMoneyInMessageBoxContent.Visible:=True;
  Self.edtMoney.Text:='';
  ShowMessageBoxFrame(frmMain,'','',TMsgDlgType.mtCustom,['取消'],
                      OnCheckMoneyInMessageBoxModalResult,
                      Self.pnlMoneyInMessageBoxContent,
                      '余额充值');
end;

procedure TFrameUserBalance.OnCheckMoneyInMessageBoxModalResult(Sender: TObject);
begin
 if TFrameMessageBox(Sender).ModalResult='确定' then
  begin
    //相关操作
  end;
end;

procedure TFrameUserBalance.btnInfoClick(Sender: TObject);
begin
  if Self.btnInfo.Caption='去绑定' then
  begin
    //添加银行卡
    //隐藏
    HideFrame;//(Self,hfcttBeforeShowFrame);

    //我的银行卡
    ShowFrame(TFrame(GlobalAddMyBankCardFrame),TFrameAddMyBankCard,frmMain,nil,nil,OnReturnFromAddMyBankCard,Application);
//    GlobalAddMyBankCardFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalAddMyBankCardFrame.Add;
  end;

  if Self.btnInfo.Caption='详情' then
  begin
    //查看银行卡列表
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
    ShowFrame(TFrame(GlobalMyBankCardListFrame),TFrameMyBankCardList,frmMain,nil,nil,OnReturnFrameBankCardList,Application);
//    GlobalMyBankCardListFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalMyBankCardListFrame.Load('我的银行卡',futManage,0);
  end;
end;

procedure TFrameUserBalance.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then Exit;

  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameUserBalance.btnWXPayClick(Sender: TObject);
begin
  if Self.edtMoney.Text='' then
  begin
    ShowHintFrame(Self,'请输入充值金额!');
//    ShowMessageBoxFrame(Self,'请输入充值金额!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if StrToFloat(Self.edtMoney.Text)<1 then
  begin
    ShowHintFrame(Self,'最低充值额度为1元!');
//    ShowMessageBoxFrame(Self,'最低充值额度为1元!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  GlobalMessageBoxFrame.HideMessageBox;

  FPayType:=Const_PaymentType_WeiXinPay;
  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                              DoPayMoneyExecute,
                              DoPayMoneyExecuteEnd,
                              'PayMoney');

//  ShowMessageBoxFrame(Self,'跳转微信支付界面...','',TMsgDlgType.mtInformation,['确定'],nil);
end;

procedure TFrameUserBalance.Clear;
begin
  Self.mcMoney.Prop.Items[0].Text:='';

//  FFilterStartDate:='';
//  FFilterEndDate:='';

  Self.btnInfo.Caption:='';

  Self.lblNumber.Caption:='';
  Self.lbList.Prop.Items.Clear(True);
  FUsedMoney:=0;
end;

constructor TFrameUserBalance.Create(AOwner: TComponent);
begin
  inherited;
  FUserBillMoneyList:=TUserBillMoneyList.Create;
  FBankCardList:=TBankCardList.Create;

    //隐藏充值界面
  Self.pnlMoneyInMessageBoxContent.Visible:=False;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  Self.pnlBankGround.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=SkinThemeColor;
  Self.lblCaption.SelfOwnMaterialToDefault.DrawCaptionParam.DrawEffectSetting.PushedEffect.FontColor.Color:=SkinThemeColor;
  Self.lblCaption.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.PushedEffect.BorderColor.Color:=SkinThemeColor;

  //
  FWithDrawBeginMoney:=100;


end;

destructor TFrameUserBalance.Destroy;
begin
  FreeAndNil(FUserBillMoneyList);
  FreeAndNil(FBankCardList);
  inherited;
end;

procedure TFrameUserBalance.DoGetBankCardListExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
          SimpleCallAPI('get_user_bankcard_list',
                        nil,
                        UserCenterInterfaceUrl,
                        ['appid',
                        'user_fid',
                        'key'],
                        [AppID,
                        GlobalManager.User.fid,
                        GlobalManager.User.key
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

procedure TFrameUserBalance.DoGetBankCardListExecuteEnd(ATimerTask: TObject);
var
  I:Integer;
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
          FBankCardList.Clear(True);
          GlobalManager.UserBankCardList.Clear;
          FBankCardList.ParseFromJsonArray(TBankCard,ASuperObject.O['Data'].A['UserBankcardList']);

          if FBankCardList.Count>0 then
          begin
            for I := 0 to FBankCardList.Count-1 do
            begin
              GlobalManager.UserBankCardList.Add(FBankCardList[I].account);
              if FBankCardList[I].is_default=1 then
              begin
                Self.lblBankCard.Caption:='已绑定银行卡';
                Self.btnInfo.Caption:='详情';
                Self.lblNumber.Caption:=FBankCardList[I].account;
              end;
            end;
          end
          else
          begin
            Self.lblBankCard.Caption:='未绑定银行卡';
            Self.lblNumber.Caption:='';
            Self.btnInfo.Caption:='去绑定';
          end;

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

procedure TFrameUserBalance.DoGetPayCenterSettingExecute(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
      SimpleCallAPI('get_record',
                    nil,
                    TableRestCenterInterfaceUrl,
                    ['appid',
                    'user_fid',
                    'key',
                    'rest_name',
                    'where_key_json',
                    'is_must_exist'],
                    [AppID,
                    GlobalManager.User.fid,
                    '',
                    'pay_center_setting',
                    GetWhereConditions(['appid'],[AppID]),
                    //不是必须存在
                    '0'],
                                        GlobalRestAPISignType,
                                        GlobalRestAPIAppSecret
                    );

    if TTimerTask(ATimerTask).TaskDesc<>'' then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

      if (ASuperObject.I['Code']=SUCC) and ASuperObject.Contains('Data') then
      begin
        case AppUserType of
          utClient:Self.FWithDrawBeginMoney:=ASuperObject.O['Data'].I['client_withdraw_begin_money'];
          utShop:Self.FWithDrawBeginMoney:=ASuperObject.O['Data'].I['shop_withdraw_begin_money'];
          utRider:Self.FWithDrawBeginMoney:=ASuperObject.O['Data'].I['rider_withdraw_begin_money'];
        end;

      end;
      

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

procedure TFrameUserBalance.DoGetTransactionListExecute(ATimerTask: TObject);
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
//                          'filter_start_date',
//                          'filter_end_date',
                          'filter_is_chang_balance',
                          'filter_income_and_outcome',
                          'filter_money_type',
                          'filter_order_type',
                          'pageindex',
                          'pagesize'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
//                          Self.FFilterStartDate,
//                          Self.FFilterEndDate,
                          '1',
                          FFilterMoneyType,   //filter_income_and_outcome
                          '',
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

procedure TFrameUserBalance.DoGetTransactionListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AUserBillMoneyList:TUserBillMoneyList;
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
  ADateTime:TDateTime;
//  ANumber:Integer;
//  J: Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        try

          if FPageIndex=1 then
          begin
            Self.lbList.Prop.Items.Clear(True);
            Self.FUserBillMoneyList.Clear(True);
          end;

          //获取成功，加载列表
          AUserBillMoneyList:=TUserBillMoneyList.Create(ooReference);
          AUserBillMoneyList.ParseFromJsonArray(TUserBillMoney,ASuperObject.O['Data'].A['UserBillMoneyList']);

//          ANumber:=0;
//          for J := 0 to AUserBillMoneyList.Count-1 do
//          begin
//            if (AUserBillMoneyList[J].money_type='withdraw')
//             or (AUserBillMoneyList[J].money_type='consume')
//             or (AUserBillMoneyList[J].money_type='score_exchange')
//             or (AUserBillMoneyList[J].money_type='refund')
//             or (AUserBillMoneyList[J].money_type='reback')
//             or (AUserBillMoneyList[J].money_type='my_man_consume_money') then
//            begin
//              ANumber:=ANumber+1;
//            end;
//          end;


//          if ANumber<1 then
//          begin
//            Self.lbList.Prop.IsEmptyContent:=True;
//          end
//          else
//          begin
            Self.lbList.Prop.IsEmptyContent:=False;

            //加载流水列表
            Self.lbList.Prop.Items.BeginUpdate;
            try

              for I := 0 to AUserBillMoneyList.Count-1 do
              begin
//                if ((AUserBillMoneyList[I].money_type='withdraw')
//                 or (AUserBillMoneyList[I].money_type='consume')
//                 or (AUserBillMoneyList[I].money_type='score_exchange')
//                 or (AUserBillMoneyList[I].money_type='refund')
//                 or (AUserBillMoneyList[I].money_type='reback')
//                 or (AUserBillMoneyList[I].money_type='my_man_consume_money'))
//                 AND (AUserBillMoneyList[I].order_type<>'invest_score')
//                 AND (AUserBillMoneyList[I].pay_state<>'wait_pay') then
//                begin
                  AListBoxItem:=Self.lbList.Prop.Items.Add;
                  Self.FUserBillMoneyList.Add(AUserBillMoneyList[I]);
                  AListBoxItem.Data:=AUserBillMoneyList[I];

                  AListBoxItem.Caption:=AUserBillMoneyList[I].name;
                  if AUserBillMoneyList[I].money_type='withdraw' then
                  begin
                    AListBoxItem.Detail:='待审核';
                    if AUserBillMoneyList[I].is_succ=1 then AListBoxItem.Detail:='提现成功 ';
                    if AUserBillMoneyList[I].is_succ=2 then AListBoxItem.Detail:='提现失败 ';
                  end;
//                  else
//                  begin
//                    ADateTime:=StandardStrToDateTime(AUserBillMoneyList[I].createtime);
//                    AListBoxItem.Caption:=FormatDateTime('MM-DD',ADateTime)+'日账单';
//                  end;

                  if AUserBillMoneyList[I].money_type='reback' then
                  begin
                    AListBoxItem.Detail:='已返还';
                  end;

                  if (AUserBillMoneyList[I].order_type='exchange_score') then
                  begin
                    AListBoxItem.Detail:=AUserBillMoneyList[I].order_desc;
                  end;

                  if AUserBillMoneyList[I].pay_state='wait_pay' then
                  begin
                    AListBoxItem.Detail:='待支付 ';
                  end;

                  if AUserBillMoneyList[I].pay_state='refuned' then
                  begin
                    AListBoxItem.Detail:='已退款 ';
                  end;

                  if (AUserBillMoneyList[I].pay_state='payed')
                  OR (AUserBillMoneyList[I].money_type='my_man_consume_money') then
                  begin
                    AListBoxItem.Detail:='已支付 ';//+AUserBillMoneyList[I].createtime;
                  end
                  else if AUserBillMoneyList[I].pay_state='' then
                  begin
                    if AUserBillMoneyList[I].money_type='consume' then
                    begin
                      AListBoxItem.Detail:='进行中 ';//+AUserBillMoneyList[I].createtime;
                    end;
                  end;

                  if AUserBillMoneyList[I].money>0 then
                  begin
                    AListBoxItem.Detail1:='+'+Format('%.2f',[AUserBillMoneyList[I].money]);
                  end
                  else
                  begin
                    AListBoxItem.Detail1:=Format('%.2f',[AUserBillMoneyList[I].money]);
                  end;

                  AListBoxItem.Detail2:=AUserBillMoneyList[I].createtime;
//                  AListBoxItem.Detail2:='余额: '+Format('%.2f',[AUserBillMoneyList[I].user_money]);
//                end;
              end;

            finally
              Self.lbList.Prop.Items.EndUpdate();
            end;
//          end;
        finally
          FreeAndNil(AUserBillMoneyList);
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
      if (TTimerTask(ATimerTask).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['UserBillMoneyList'].Length>0) then
      begin
        Self.lbList.Prop.StopPullUpLoadMore('加载成功!',0,True);
      end
      else
      begin
        Self.lbList.Prop.StopPullUpLoadMore('下面没有了!',600,False);
      end;
    end
    else
    begin
      Self.lbList.Prop.StopPullDownRefresh('刷新成功!',600);
    end;
  end;
end;

procedure TFrameUserBalance.DoGetUserUsedMoneyExecute(ATimerTask: TObject);
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

procedure TFrameUserBalance.DoGetUserUsedMoneyExecuteEnd(ATimerTask: TObject);
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

        FUsedMoney:=GetJsonDoubleValue(AUserWalletObject,'money');

        Self.mcMoney.Prop.Items[0].Text:=Format('%.2f',[FUsedMoney]);

        //刷新余额流水列表
        Self.lbList.Prop.StartPullDownRefresh;
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

procedure TFrameUserBalance.DoPayMoneyExecute(ATimerTask: TObject);
begin
//出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('prepare_pay',
                          nil,
                          PayCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'money',
                          'order_type',
                          'pay_type',
                          'name',
                          'desc'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          StrToFloat(Self.edtMoney.Text),
                          Const_OrderType_InvestMoney,
                          FPayType,
                          '余额充值',
                          '余额充值'+Self.edtMoney.Text+'元'
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

procedure TFrameUserBalance.GetUserBankCardList;
begin
  //获取银行卡列表
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                              DoGetBankCardListExecute,
                              DoGetBankCardListExecuteEnd,
                              'GetBankCardList');
end;

procedure TFrameUserBalance.Init(AFilterMoney: Double);
var
  I: Integer;
begin
  Clear;

//  FFilterStartDate:=FormatDateTime('YYYY-MM',Now)+'-01';
//  FFilterEndDate:=FormatDateTime('YYYY-MM',Now)+'-30';


  Self.lbFilter.Prop.ItemWidth:=Self.Width/3;

  FUsedMoney:=AFilterMoney;

  Self.mcMoney.Prop.Items[0].Text:=Format('%.2f',[AFilterMoney]);
  Self.mcMoney.Prop.Items[1].Text:='元';

  for I := 0 to Self.lbFilter.Prop.Items.Count-1 do
  begin
    if I=0 then
    begin
      Self.lbFilter.Prop.Items[I].Selected:=True;
      FFilterMoneyType:=Self.lbFilter.Prop.Items[I].Name;
    end
    else
    begin
      Self.lbFilter.Prop.Items[I].Selected:=False;
    end;
  end;


  //获取最小起提金额
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                              DoGetPayCenterSettingExecute,
                              nil,
                              'GetPayCenterSetting');
  //获取银行卡列表
  GetUserBankCardList;

  Self.lbList.Prop.StartPullDownRefresh;
end;

procedure TFrameUserBalance.lbFilterClickItem(AItem: TSkinItem);
var
  I: Integer;
begin
  AItem.Selected:=True;
  for I := 0 to Self.lbFilter.Prop.Items.Count-1 do
  begin
    if Self.lbFilter.Prop.Items[I].Caption<>AItem.Caption then
    begin
      Self.lbFilter.Prop.Items[I].Selected:=False;
    end
    else
    begin
      Self.lbFilter.Prop.Items[I].Selected:=True;
    end;
  end;

  FFilterMoneyType:=AItem.Name;

  Self.lbList.Prop.StartPullDownRefresh;

  //收入分充值 积分兑换   支出  购物消费   提现   先不换
end;

procedure TFrameUserBalance.lbFilterResize(Sender: TObject);
begin
  Self.lbFilter.Prop.ItemWidth:=Self.Width/3;
end;

procedure TFrameUserBalance.lbListClickItem(AItem: TSkinItem);
//var
//  AUserBillMoney:TUserBillMoney;
begin
  //先不跳转
//  AUserBillMoney:=TUserBillMoney(AItem.Data);
//  //隐藏
//  HideFrame;//(Self,hfcttBeforeShowFrame);
// //显示交易信息详情
//  ShowFrame(TFrame(GlobalShopBalanceInfoFrame),TFrameShopBalanceInfo,frmMain,nil,nil,nil,Application);
//  GlobalShopBalanceInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalShopBalanceInfoFrame.Init(AUserBillMoney.fid);
end;

procedure TFrameUserBalance.lbListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AUserBillMoney:TUserBillMoney;
begin
  if AItem.Data<>nil then
  begin
    AUserBillMoney:=TUserBillMoney(AItem.Data);

    if AUserBillMoney.money>0 then
    begin
      Self.lblCash.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Lightgreen;
    end
    else
    begin
      Self.lblCash.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Orange;
    end;
  end;
end;

procedure TFrameUserBalance.lbListPullDownRefresh(Sender: TObject);
begin
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                   DoGetTransactionListExecute,
                   DoGetTransactionListExecuteEnd,
                   'GetTransactionList');
end;

procedure TFrameUserBalance.lbListPullUpLoadMore(Sender: TObject);
begin
  FPageIndex:=FPageIndex+1;

  uTimerTask.GetGlobalTimerThread.RunTempTask(
                   DoGetTransactionListExecute,
                   DoGetTransactionListExecuteEnd,
                   'GetTransactionList');
end;

procedure TFrameUserBalance.OnModalResultFromBandingBankCard(AFrame: TObject);
begin
  if TFrameMessageBox(AFrame).ModalResult='去绑定' then
  begin
    //添加银行卡
    //隐藏
    HideFrame;//(Self,hfcttBeforeShowFrame);

    //我的银行卡
    ShowFrame(TFrame(GlobalAddMyBankCardFrame),TFrameAddMyBankCard,frmMain,nil,nil,OnReturnFromAddMyBankCard,Application);
//    GlobalAddMyBankCardFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalAddMyBankCardFrame.Add;
  end;
  if TFrameMessageBox(AFrame).ModalResult='不了,谢谢' then
  begin
    //留在银行卡信息页面
  end;
end;

procedure TFrameUserBalance.OnReturnFrameBankCardList(AFrame: TFrame);
begin
  GetUserBankCardList;
end;

procedure TFrameUserBalance.OnReturnFromAddMyBankCard(AFrame: TFrame);
begin
  GetUserBankCardList;
end;

procedure TFrameUserBalance.OnReturnFromWithDrawFrame(AFrame: TFrame);
begin
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                DoGetUserUsedMoneyExecute,
                DoGetUserUsedMoneyExecuteEnd,
                'GetUserUsedMoney');

end;

procedure TFrameUserBalance.pnlClientResize(Sender: TObject);
begin
  //提现按钮
  Self.btnCash.Left:=5;
  Self.btnCash.Width:=Self.pnlClient.Width-10;
  //充值按钮
//  Self.btnCashIn.Left:=Self.pnlClient.Width/2+5;
//  Self.btnCashIn.Width:=Self.pnlClient.Width/2-10;
end;

procedure TFrameUserBalance.pnlMoneyInMessageBoxContentResize(Sender: TObject);
var
  ATempWidth:Double;
begin
  ATempWidth:=(Self.pnlMoneyInMessageBoxContent.Width-Self.btnWXPay.Width-Self.btnAliPay.Width)/3;
  Self.btnWXPay.Position.X:=ATempWidth;
  Self.btnAliPay.Position.X:=Self.btnWXPay.Width+ATempWidth*2;
end;

procedure TFrameUserBalance.SkinFMXButton1Click(Sender: TObject);
begin
  //查看余额详情
  FreeAndNil(GlobalRegisterProtocolFrame);
  //查看活动规则
  ShowFrame(TFrame(GlobalRegisterProtocolFrame),TFrameRegisterProtocol,frmMain,nil,nil,nil,Application,False,False,ufsefNone);
  GlobalRegisterProtocolFrame.Load('钱包说明',
                                    Const_OpenWebRoot+'/apps/'+(AppID)+'/UserWalletProtocol.html');

end;

procedure TFrameUserBalance.tmrGetUserBillMoneyPayStateTimer(Sender: TObject);
begin
  Self.tmrGetUserBillMoneyPayState.Enabled:=False;

  FGetOrderPayStateCount:=0;
  FGetOrderPayStateIsOver:=False;


  //获取订单详情,判断是否支付成功
  ShowWaitingFrame(Self,'获取支付结果...');
  Self.tteGetOrderPayState.Run;
end;

procedure TFrameUserBalance.tteGetOrderPayStateExecute(ATimerTask: TTimerTask);
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

procedure TFrameUserBalance.tteGetOrderPayStateExecuteEnd(
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
//                      HideFrame;//(Self,hfcttBeforeShowFrame);

                      //获取用户余额详情
                      uTimerTask.GetGlobalTimerThread.RunTempTask(
                                              DoGetUserUsedMoneyExecute,
                                              DoGetUserUsedMoneyExecuteEnd,
                                              'GetUserUsedMoney');

                      FGetOrderPayStateIsOver:=True;
                  end
                  else
                  begin
                      //支付未结束,或者没有支付成功
                      if DateUtils.SecondsBetween(Now,FGetOrderPayStateStartTime)<30 then
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
//                        HideFrame;//(Self,hfcttBeforeShowFrame);

                        //获取用户余额详情
                        uTimerTask.GetGlobalTimerThread.RunTempTask(
                                              DoGetUserUsedMoneyExecute,
                                              DoGetUserUsedMoneyExecuteEnd,
                                              'GetUserUsedMoney');

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

procedure TFrameUserBalance.DoPayMoneyExecuteEnd(ATimerTask: TObject);
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

          //刷新订单的支付状态
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



end.
