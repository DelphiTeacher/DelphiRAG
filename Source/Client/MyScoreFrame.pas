unit MyScoreFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Platform,DateUtils,

  uBaseList,
  uManager,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uAPPCommon,
  HintFrame,
  uOpenCommon,
  uFrameContext,

  uConst,
  uSkinMaterial,
  uOpenClientCommon,
  uDataSetToJson,
  {$IFDEF HAS_WXPAY}
  uWeiChat,
  {$ENDIF HAS_WXPAY}

  {$IFDEF HAS_ALIPAY}
  uAlipayMobilePay,
  {$ENDIF HAS_ALIPAY}

  MessageBoxFrame,
  TakePictureMenuFrame,
  ClipHeadFrame,
  WaitingFrame,
  RegisterProtocolFrame,
  EasyServiceCommonMaterialDataMoudle,

  uBaseHttpControl,
  uRestInterfaceCall,
//  uCommonUtils,
  uFuncCommon,
//  uOpenCommon,
  uSkinItems,
  uDrawCanvas,

  ScoreRechargeFrame,

  AddMyBankCardFrame,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uTimerTaskEvent, uSkinImageType, uSkinFireMonkeyImage;

type
  TFrameMyScore = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlBankGround: TSkinFMXPanel;
    pnlClient: TSkinFMXPanel;
    lblTitle: TSkinFMXLabel;
    mcMoney: TSkinFMXMultiColorLabel;
    btnCash: TSkinFMXButton;
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
    pnlMoneyInMessageBoxContent: TSkinFMXPanel;
    edtMoney: TSkinFMXEdit;
    lblNotice: TSkinFMXLabel;
    tmrGetUserBillMoneyPayState: TTimer;
    tteGetOrderPayState: TTimerTaskEvent;
    SkinFMXButton1: TSkinFMXButton;
    btnInfo: TSkinFMXButton;
    btnWxPay: TSkinFMXButton;
    btnWXPayInner: TSkinFMXButton;
    btnAliPay: TSkinFMXButton;
    btnAliPayInner: TSkinFMXButton;
    btnMoney1: TSkinFMXButton;
    btnMoney6: TSkinFMXButton;
    btnMoney10: TSkinFMXButton;
    btnMoney30: TSkinFMXButton;
    btnMoney50: TSkinFMXButton;
    btnMoney100: TSkinFMXButton;
    pnlMoneyGroup: TSkinFMXPanel;
    pnlPayGroup: TSkinFMXPanel;
    pnlContainer: TSkinFMXPanel;
    pnlTitle: TSkinFMXPanel;
    btnGetScore: TSkinFMXButton;
    pnlBtn: TSkinFMXPanel;
    btnScoreDetail: TSkinFMXButton;
    imgBackGround: TSkinFMXImage;
    SkinFMXPanel1: TSkinFMXPanel;
    lblBankCard: TSkinFMXLabel;
    lblNumber: TSkinFMXLabel;
    btnCheck: TSkinFMXButton;
    procedure lbFilterResize(Sender: TObject);
    procedure lbListPullDownRefresh(Sender: TObject);
    procedure lbListPullUpLoadMore(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure lbFilterClickItem(AItem: TSkinItem);
    procedure btnCheckClick(Sender: TObject);
    procedure lbListClickItem(AItem: TSkinItem);
    procedure lbListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure btnCashClick(Sender: TObject);
    procedure pnlClientResize(Sender: TObject);
    procedure btnCashInClick(Sender: TObject);
    procedure btnWXPayInnerClick(Sender: TObject);
    procedure btnAliPayInnerClick(Sender: TObject);
    procedure tmrGetUserBillMoneyPayStateTimer(Sender: TObject);
    procedure tteGetOrderPayStateExecute(ATimerTask: TTimerTask);
    procedure tteGetOrderPayStateExecuteEnd(ATimerTask: TTimerTask);
    procedure pnlMoneyInMessageBoxContentResize(Sender: TObject);
    procedure SkinFMXButton1Click(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure btnScoreDetailClick(Sender: TObject);
    procedure btnGetScoreClick(Sender: TObject);
  private
//    FPageIndex:Integer;
    FFilterMoneyType:String;

    FFilterStartDate:String;
    FFilterEndDate:String;
    //可用金额
    //FUsedMoney:Double;

    FGetOrderPayStateStartTime:TDateTime;
    FGetOrderPayStateCount:Integer;
    FGetOrderPayStateIsOver:Boolean;

//    FJson:String;
    FFilterRuleType:String;

    FBankCardList:TBankCardList;

    //提现起提金额
    FWithDrawBeginMoney:Integer;

    //用户积分往来列表
//    FUserBillMoneyList:TUserBillMoneyList;
//    procedure DoGetTransactionListExecute(ATimerTask:TObject);
//    procedure DoGetTransactionListExecuteEnd(ATimerTask:TObject);

  private
    //获取个人信息
    procedure DoGetUserInfoExecute(ATimerTask:TObject);
    procedure DoGetUserInfoExecuteEnd(ATimerTask:TObject);

    //充值操作
    procedure DoPayMoneyExecute(ATimerTask:TObject);
    procedure DoPayMoneyExecuteEnd(ATimerTask:TObject);

    //从绑定银行卡的弹出框返回
    procedure OnModalResultFromBandingBankCard(AFrame:TObject);
    //从添加银行卡返回
    procedure OnReturnFromAddMyBankCard(AFrame:TFrame);
    //从查看银行卡列表返回
    procedure OnReturnFrameBankCardList(AFrame:TFrame);
    //获取银行卡
    procedure GetUserBankCardList;
    //获取银行卡列表
    procedure DoGetBankCardListExecute(ATimerTask:TObject);
    procedure DoGetBankCardListExecuteEnd(ATimerTask:TObject);

  private
    //积分兑换比率  比如 10积分兑换1元
    FScoreRuly:Double;
    FScoreRulyFID:Integer;
    //积分兑换规则
    procedure DoGetExchangeScoreRulyExecute(ATimerTask:TObject);
    procedure DoGetExchangeScoreRulyExecuteEnd(ATimerTask:TObject);

    //从兑换积分申请返回
    procedure OnReturnFromWithDrawFrame(AFrame:TFrame);

//    procedure DoGetUserUsedMoneyExecute(ATimerTask: TObject);
//    procedure DoGetUserUsedMoneyExecuteEnd(ATimerTask: TObject);

    //从充值返回
    procedure OnCheckMoneyInMessageBoxModalResult(Sender: TObject);
    { Private declarations }
  public
    //支付方式
    FPayType:String;
    //用户资金往来记录FID
    FUserBillMoneyFID:Integer;
    procedure Clear;
    procedure Init;//(AScore:Double);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalMyScoreFrame:TFrameMyScore;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame,
  ScoreDetailFrame,
  ActivityCenterFrame,
//  ShopBalanceInfoFrame,
  ExchangeScoreFrame,
  MyBankCardListFrame,
  WithDrawMoneyFrame;

procedure TFrameMyScore.btnAliPayInnerClick(Sender: TObject);
begin

  {if Self.edtMoney.Text='' then
  begin
    ShowHintFrame(Self,'请输入充值积分对应的金额!');
//    ShowMessageBoxFrame(Self,'请输入充值积分对应的金额!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if StrToFloat(Self.edtMoney.Text)<1 then
  begin
    ShowHintFrame(Self,'最低充值额度为1元!');
//    ShowMessageBoxFrame(Self,'最低充值积分对应的金额为1元!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;}

  {GlobalMessageBoxFrame.HideMessageBox;

  FPayType:=Const_PaymentType_Alipay;
  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                              DoPayMoneyExecute,
                              DoPayMoneyExecuteEnd,
                              'PayMoney');}

//  ShowMessageBoxFrame(Self,'跳转支付宝支付界面...','',TMsgDlgType.mtInformation,['确定'],nil);
end;

procedure TFrameMyScore.OnModalResultFromBandingBankCard(AFrame: TObject);
begin
  if TFrameMessageBox(AFrame).ModalResult='去绑定' then
  begin
    //添加银行卡
    //隐藏
    HideFrame(Self,hfcttBeforeShowFrame);

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

procedure TFrameMyScore.OnReturnFromAddMyBankCard(AFrame: TFrame);
begin
  GetUserBankCardList;
end;

procedure TFrameMyScore.OnReturnFrameBankCardList(AFrame: TFrame);
begin
  GetUserBankCardList;
end;

procedure TFrameMyScore.GetUserBankCardList;
begin
  //获取银行卡列表
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                              DoGetBankCardListExecute,
                              DoGetBankCardListExecuteEnd,
                              'GetBankCardList');
end;

procedure TFrameMyScore.DoGetBankCardListExecute(ATimerTask: TObject);
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

procedure TFrameMyScore.DoGetBankCardListExecuteEnd(ATimerTask: TObject);
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
                Self.btnCheck.Caption:='详情';
                Self.lblNumber.Caption:=FBankCardList[I].account;
              end;
            end;
          end
          else
          begin
            Self.lblBankCard.Caption:='未绑定银行卡';
            Self.lblNumber.Caption:='';
            Self.btnCheck.Caption:='去绑定';
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

procedure TFrameMyScore.btnCashClick(Sender: TObject);
begin
  //积分兑换
//  if FUsedMoney>0 then
  if GlobalManager.User.score>0 then
  begin
    //积分不为0时可以提现
    //显示积分兑换页面
    //HideFrame(Self,hfcttBeforeShowFrame);

    //ShowFrame(TFrame(GlobalExchangeScoreFrame),TFrameExchangeScore,frmMain,nil,nil,OnReturnFromWithDrawFrame,Application);
//    GlobalExchangeScoreFrame.FrameHistroy:=CurrentFrameHistroy;
    //GlobalExchangeScoreFrame.Init(GlobalManager.User.score,FScoreRuly,FScoreRulyFID);

    if GlobalManager.UserBankCardList.Count=0 then
    begin
      ShowMessageBoxFrame(Self,'您该没有绑定银行卡,是否去绑定?','',TMsgDlgType.mtInformation,['去绑定','不了,谢谢'],OnModalResultFromBandingBankCard);
      Exit;
    end
    else
    begin

        if (FWithDrawBeginMoney>0) and (GlobalManager.User.score<FWithDrawBeginMoney) then
        begin
          //积分为零不提现
          ShowMessageBoxFrame(Self,'积分满'+IntToStr(FWithDrawBeginMoney)+'才可提现!','',TMsgDlgType.mtInformation,['确定'],nil);
          Exit;
        end;

        //显示提现申请页面
        HideFrame(Self,hfcttBeforeShowFrame);
        //显示交易列表
        ShowFrame(TFrame(GlobalWithDrawMoneyFrame),TFrameWithDrawMoney,frmMain,nil,nil,OnReturnFromWithDrawFrame,Application);
//        GlobalWithDrawMoneyFrame.FrameHistroy:=CurrentFrameHistroy;
        GlobalWithDrawMoneyFrame.Init(GlobalManager.User.score,
                                      FBankCardList,
                                      //是否限制最小提现金额
                                      Ord((FWithDrawBeginMoney>0)),
                                      FWithDrawBeginMoney);

    end;
  end
  else
  begin
    //余额为零不提现
    ShowMessageBoxFrame(Self,'您没有要兑换的积分!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
end;

procedure TFrameMyScore.btnCashInClick(Sender: TObject);
begin
  //充值积分
  HideVirtualKeyboard;
  Self.edtMoney.Text:='';
  //刚开始是隐藏的   用到的时候显示出来
  Self.lblNotice.Text:='提醒: 1人民币等于'+FloatToStr(Self.FScoreRuly)+'积分';

  Self.pnlMoneyInMessageBoxContent.Visible:=True;
  ShowMessageBoxFrame(frmMain,'','',TMsgDlgType.mtCustom,['确定','取消'],
                      OnCheckMoneyInMessageBoxModalResult,
                      Self.pnlMoneyInMessageBoxContent,
                      '积分充值');

  HideFrame;
  ShowFrame(TFrame(GlobalScoreRechargeFrame),TFrameScoreRecharge,OnReturnFromWithDrawFrame);
  GlobalScoreRechargeFrame.FScoreRatio:=FScoreRuly;
  GlobalScoreRechargeFrame.Load;
end;

procedure TFrameMyScore.btnGetScoreClick(Sender: TObject);
begin
  //显示活动页面
  //隐藏
  HideFrame();
  //显示活动明细页面
  ShowFrame(TFrame(GlobalActivityCenterFrame),TFrameActivityCenter);
  GlobalActivityCenterFrame.Load;

end;

procedure TFrameMyScore.btnCheckClick(Sender: TObject);
begin
  //查看积分说明
//  FreeAndNil(GlobalRegisterProtocolFrame);
  //查看活动规则
  //ShowFrame(TFrame(GlobalRegisterProtocolFrame),TFrameRegisterProtocol,frmMain,nil,nil,nil,Application,False,False,ufsefNone);
  //GlobalRegisterProtocolFrame.Load('积分说明',Const_OpenWebRoot+'/apps/'+IntToStr(AppID)+'/ScoreProtocol.html');
  if Self.btnCheck.Caption='去绑定' then
  begin
    //添加银行卡
    //隐藏
    HideFrame(Self,hfcttBeforeShowFrame);

    //我的银行卡
    ShowFrame(TFrame(GlobalAddMyBankCardFrame),TFrameAddMyBankCard,frmMain,nil,nil,OnReturnFromAddMyBankCard,Application);
//    GlobalAddMyBankCardFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalAddMyBankCardFrame.Add;
  end;

  if Self.btnCheck.Caption='详情' then
  begin
    //查看银行卡列表
    HideFrame(GlobalMainFrame,hfcttBeforeShowFrame);
    ShowFrame(TFrame(GlobalMyBankCardListFrame),TFrameMyBankCardList,frmMain,nil,nil,OnReturnFrameBankCardList,Application);
//    GlobalMyBankCardListFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalMyBankCardListFrame.Load('我的银行卡',futManage,0);
  end;
end;

procedure TFrameMyScore.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameMyScore.btnScoreDetailClick(Sender: TObject);
begin
   //隐藏
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

  //显示设置页面
  ShowFrame(TFrame(GlobalScoreDetailFrame),TFrameScoreDetail,frmMain,nil,nil,nil,Application);
  GlobalScoreDetailFrame.Init(GlobalManager.User.score);
end;

procedure TFrameMyScore.btnWXPayInnerClick(Sender: TObject);
begin
  {if Self.edtMoney.Text='' then
  begin
    ShowHintFrame(Self,'请输入充值积分对应的金额!');
//    ShowMessageBoxFrame(Self,'请输入充值金额!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if StrToFloat(Self.edtMoney.Text)<1 then
  begin
    ShowHintFrame(Self,'最低充值额度为1元!');
//    ShowMessageBoxFrame(Self,'最低充值额度为1元!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;}

//  GlobalMessageBoxFrame.HideMessageBox;

  {FPayType:=Const_PaymentType_WeiXinPay;
  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                              DoPayMoneyExecute,
                              DoPayMoneyExecuteEnd,
                              'PayMoney');}

//  ShowMessageBoxFrame(Self,'跳转微信支付界面...','',TMsgDlgType.mtInformation,['确定'],nil);
end;

procedure TFrameMyScore.Clear;
begin
  Self.mcMoney.Prop.Items[0].Text:='';
  Self.lbList.Prop.Items.Clear(True);

  FFilterStartDate:='';
  FFilterEndDate:='';

  Self.btnCheck.Caption:='';
  Self.lblNumber.Caption:='';

  Self.pnlMoneyInMessageBoxContent.Visible:=False;

//  Self.lblNumber.Caption:='';
//
//  Self.btnInfo.Visible:=False;
end;

constructor TFrameMyScore.Create(AOwner: TComponent);
begin
  inherited;
//  FUserBillMoneyList:=TUserBillMoneyList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

 // Self.pnlBankGround.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=SkinThemeColor;
  Self.lblCaption.SelfOwnMaterialToDefault.DrawCaptionParam.DrawEffectSetting.PushedEffect.FontColor.Color:=SkinThemeColor;
    Self.lblCaption.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.PushedEffect.BorderColor.Color:=SkinThemeColor;

  //设置最低100积分可提现
  FWithDrawBeginMoney:=100;

  FBankCardList:=TBankCardList.Create;
end;

destructor TFrameMyScore.Destroy;
begin
//  FreeAndNil(FUserBillMoneyList);
  inherited;
end;

procedure TFrameMyScore.DoGetExchangeScoreRulyExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_record_list',
                                                    nil,
                                                    TableRestCenterInterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'rest_name',
                                                    'pageindex',
                                                    'pagesize',
                                                    'where_key_json',
                                                    'order_by'],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    '',
                                                    'score_exchange_type',
                                                    0,
                                                    MaxInt,
                                                    '',
                                                    'createtime DESC'
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


procedure TFrameMyScore.DoGetExchangeScoreRulyExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I:Integer;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取积分兑换比率
        FScoreRuly:=10;
        FScoreRulyFID:=0;
        for I := ASuperObject.O['Data'].A['RecordList'].Length-1 downto 0 do
        begin
          //暂时先写死
          if ASuperObject.O['Data'].A['RecordList'].O[I].S['goods_name']='积分兑换余额' then
          begin
            FScoreRuly:=ASuperObject.O['Data'].A['RecordList'].O[I].F['score'];
            FScoreRulyFID:=ASuperObject.O['Data'].A['RecordList'].O[I].I['fid'];
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
  end;

end;
//
//procedure TFrameMyScore.DoGetTransactionListExecute(ATimerTask: TObject);
//var
//  AWhereSql:String;
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//
//  try
//
//
//
//    FJson:=GetWhereConditions(['appid','user_fid'],
//                      [AppID,GlobalManager.User.fid]);
//
//    AWhereSql:='';
//    if FFilterRuleType='1' then
//    begin
//      AWhereSql:=' AND (score>0) ';
//    end
//    else if FFilterRuleType='0' then
//    begin
//      AWhereSql:=' AND (score<0) ';
//    end;
//
//    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_record_list',
//                                                    nil,
//                                                    TableRestCenterInterfaceUrl,
//                                                    ['appid',
//                                                    'user_fid',
//                                                    'key',
//                                                    'rest_name',
//                                                    'pageindex',
//                                                    'pagesize',
//                                                    'where_key_json',
//                                                    'where_sql',
//                                                    'order_by'],
//                                                    [AppID,
//                                                    GlobalManager.User.fid,
//                                                    '',
//                                                    'user_score_inout_view',
//                                                    FPageIndex,
//                                                    20,
//                                                    FJson,
//                                                    AWhereSql,
//                                                    'createtime DESC'
//                                                    ]
//                                                    );
//    if TTimerTask(ATimerTask).TaskDesc<>'' then
//    begin
//      TTimerTask(ATimerTask).TaskTag:=0;
//    end;
//
//  except
//    on E:Exception do
//    begin
//      //异常
//      TTimerTask(ATimerTask).TaskDesc:=E.Message;
//    end;
//  end;
//
//end;
//
//procedure TFrameMyScore.DoGetTransactionListExecuteEnd(ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//  I: Integer;
//  AListBoxItem:TSkinListBoxItem;
//  ADateTime:TDateTime;
//  J: Integer;
//begin
//
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//
//        try
//
//          if FPageIndex=1 then
//          begin
//            Self.lbList.Prop.Items.Clear(True);
//          end;
//
////          //获取成功，加载列表
////          AUserBillMoneyList:=TUserBillMoneyList.Create(ooReference);
////          AUserBillMoneyList.ParseFromJsonArray(TUserBillMoney,ASuperObject.O['Data'].A['RecordList']);
////
//          if ASuperObject.O['Data'].A['RecordList'].Length<1 then
//          begin
//            Self.lbList.Prop.IsEmptyContent:=True;
//          end
//          else
//          begin
//            Self.lbList.Prop.IsEmptyContent:=False;
//
//            //加载流水列表
//            Self.lbList.Prop.Items.BeginUpdate;
//            try
//
//              for I := 0 to ASuperObject.O['Data'].A['RecordList'].Length-1 do
//              begin
//
//                AListBoxItem:=Self.lbList.Prop.Items.Add;
//                AListBoxItem.Data:=ASuperObject.O['Data'].A['RecordList'].O[I];
//                AListBoxItem.Caption:=GetScoreRuleTypeStr(ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']);
//
////                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_MyManConsumeMoney then
////                begin
////                  AListBoxItem.Caption:='好友下单赠送积分';
////                end;
////
////                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_ScoreReBack then
////                begin
////                  AListBoxItem.Caption:='订单取消,返还抵扣积分';
////                end;
////
////                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_IndianaGoods then
////                begin
////                  AListBoxItem.Caption:='积分夺宝';
////                end;
////
////                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_UsedScore then
////                begin
////                  AListBoxItem.Caption:='消费积分抵扣';
////                end;
////
////                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_ExchangeScore then
////                begin
////                  AListBoxItem.Caption:='积分兑换余额';
////                end;
////
////                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_InviteRegister then
////                begin
////                  AListBoxItem.Caption:='邀请好友注册';
////                end;
////
////                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_Register then
////                begin
////                  AListBoxItem.Caption:='新用户注册奖励';
////                end;
////
////                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_InvestScore then
////                begin
////                  AListBoxItem.Caption:='积分充值';
////                end;
//
//                AListBoxItem.Detail:='成功 '+ASuperObject.O['Data'].A['RecordList'].O[I].S['createtime'];
//
//
//                if ASuperObject.O['Data'].A['RecordList'].O[I].F['score']>0 then
//                begin
//                  AListBoxItem.Detail1:='+'+Format('%.2f',[ASuperObject.O['Data'].A['RecordList'].O[I].F['score']]);
//                end
//                else
//                begin
//                  AListBoxItem.Detail1:=Format('%.2f',[ASuperObject.O['Data'].A['RecordList'].O[I].F['score']]);
//                end;
//
////                AListBoxItem.Detail2:='积分: '+Format('%.2f',[AUserBillMoneyList[I].user_money]);
//
//
//              end;
//
//            finally
//              Self.lbList.Prop.Items.EndUpdate();
//            end;
//          end;
//        finally
//        end;
//      end
//      else
//      begin
//        //调用失败
//        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
//      end;
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    //停止刷新
//    if FPageIndex>1 then
//    begin
//      if (TTimerTask(ATimerTask).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['RecordList'].Length>0) then
//      begin
//        Self.lbList.Prop.StopPullUpLoadMore('加载成功!',0,True);
//      end
//      else
//      begin
//        Self.lbList.Prop.StopPullUpLoadMore('下面没有了!',600,False);
//      end;
//    end
//    else
//    begin
//      Self.lbList.Prop.StopPullDownRefresh('刷新成功!',600);
//    end;
//  end;
//end;

procedure TFrameMyScore.DoGetUserInfoExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_my_info',
                                                      nil,
                                                      UserCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key
                                                      ]
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

procedure TFrameMyScore.DoGetUserInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AUserObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        GlobalManager.User.score:=ASuperObject.O['Data'].A['User'].O[0].F['score'];
        Self.mcMoney.Prop.Items[0].Text:=Format('%.2f',[GlobalManager.User.score]);
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

//procedure TFrameMyScore.DoGetUserUsedMoneyExecute(ATimerTask: TObject);
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//
//  try
//    TTimerTask(ATimerTask).TaskDesc:=
//            SimpleCallAPI('get_user_money',
//                          nil,
//                          PayCenterInterfaceUrl,
//                          ['appid',
//                          'user_fid'
//                          ],
//                          [AppID,
//                          GlobalManager.User.fid
//                          ]
//                          );
//    if TTimerTask(ATimerTask).TaskDesc<>'' then
//    begin
//      TTimerTask(ATimerTask).TaskTag:=0;
//    end;
//
//  except
//    on E:Exception do
//    begin
//      //异常
//      TTimerTask(ATimerTask).TaskDesc:=E.Message;
//    end;
//  end;
//end;
//
//procedure TFrameMyScore.DoGetUserUsedMoneyExecuteEnd(ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//  AUserWalletObject:ISuperObject;
//begin
//
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//        AUserWalletObject:=ASuperObject.O['Data'].A['UserMoney'].O[0];
//
//        FUsedMoney:=GetJsonDoubleValue(AUserWalletObject,'money');
//
//        Self.mcMoney.Prop.Items[0].Text:=Format('%.2f',[FUsedMoney]);
//
//      end
//      else
//      begin
//        //调用失败
//        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
//      end;
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    HideWaitingFrame;
//  end;
//end;

procedure TFrameMyScore.DoPayMoneyExecute(ATimerTask: TObject);
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


procedure TFrameMyScore.DoPayMoneyExecuteEnd(ATimerTask: TObject);
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

procedure TFrameMyScore.FrameResize(Sender: TObject);
begin
  btnGetScore.Width:=(pnlBtn.Width-15)/2;
  btnScoreDetail.Width:=(pnlBtn.Width-15)/2;
end;

procedure TFrameMyScore.Init;//(AScore: Double);
var
  I: Integer;
begin
  Clear;

  FFilterStartDate:=FormatDateTime('YYYY-MM',Now)+'-01';
  FFilterEndDate:=FormatDateTime('YYYY-MM',Now)+'-30';


//  Self.lbFilter.Prop.ItemWidth:=Self.Width/3;

  //FUsedMoney:=AScore;


  Self.mcMoney.Prop.Items[0].Text:=Format('%.2f',[GlobalManager.User.score]);



////  Self.lblNumber.Caption:=GlobalManager.AsShop.Shop.bankcard_account;
//
//  for I := 0 to Self.lbFilter.Prop.Items.Count-1 do
//  begin
//    if I=0 then
//    begin
//      Self.lbFilter.Prop.Items[I].Selected:=True;
//      FFilterMoneyType:=Self.lbFilter.Prop.Items[I].Name;
//    end
//    else
//    begin
//      Self.lbFilter.Prop.Items[I].Selected:=False;
//    end;
//  end;



  uTimerTask.GetGlobalTimerThread.RunTempTask(
         DoGetExchangeScoreRulyExecute,
         DoGetExchangeScoreRulyExecuteEnd,
         'GetExchangeScoreRuly');



  FFilterRuleType:='';

  //获取银行卡列表
  GetUserBankCardList;

//  Self.lbList.Prop.StartPullDownRefresh;
end;

procedure TFrameMyScore.lbFilterClickItem(AItem: TSkinItem);
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

  FFilterRuleType:=AItem.Name;

  Self.lbList.Prop.StartPullDownRefresh;
end;

procedure TFrameMyScore.lbFilterResize(Sender: TObject);
begin
  Self.lbFilter.Prop.ItemWidth:=Self.Width/3;
end;

procedure TFrameMyScore.lbListClickItem(AItem: TSkinItem);
//var
//  AUserBillMoney:TUserBillMoney;
begin
  //先不跳转
//  AUserBillMoney:=TUserBillMoney(AItem.Data);
//  //隐藏
//  HideFrame(Self,hfcttBeforeShowFrame);
 //显示交易信息详情
//  ShowFrame(TFrame(GlobalShopBalanceInfoFrame),TFrameMyScoreInfo,frmMain,nil,nil,nil,Application);
//  GlobalShopBalanceInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalShopBalanceInfoFrame.Init(AUserBillMoney.fid);
end;

procedure TFrameMyScore.lbListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
  if AItem.Detail1<>'' then
  begin
    if StrToFloat(AItem.Detail1)>0 then
    begin
      Self.lblCash.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Lightgreen;
    end
    else
    begin
      Self.lblCash.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Orange;
    end;
  end;
end;

procedure TFrameMyScore.lbListPullDownRefresh(Sender: TObject);
begin
//  FPageIndex:=1;
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                   DoGetTransactionListExecute,
//                   DoGetTransactionListExecuteEnd,
//                   'GetTransactionList');
end;

procedure TFrameMyScore.lbListPullUpLoadMore(Sender: TObject);
begin
//  FPageIndex:=FPageIndex+1;
//
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                   DoGetTransactionListExecute,
//                   DoGetTransactionListExecuteEnd,
//                   'GetTransactionList');
end;

procedure TFrameMyScore.OnCheckMoneyInMessageBoxModalResult(Sender: TObject);
begin
  if TFrameMessageBox(Sender).ModalResult='确定' then
  begin
    //选择充值金额
    if btnMoney1.Properties.IsPushed=True then
    begin
      Self.edtMoney.Text:='1';
    end
    else if btnMoney6.Properties.IsPushed=True then
    begin
      Self.edtMoney.Text:='6';
    end
    else if btnMoney10.Properties.IsPushed=True then
    begin
      Self.edtMoney.Text:='10';
    end
    else if btnMoney30.Properties.IsPushed=True then
    begin
      Self.edtMoney.Text:='30';
    end
    else if btnMoney50.Properties.IsPushed=True then
    begin
      Self.edtMoney.Text:='50';
    end
    else if btnMoney100.Properties.IsPushed=True then
    begin
      Self.edtMoney.Text:='100';
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

    //执行支付
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                            DoPayMoneyExecute,
                            DoPayMoneyExecuteEnd,
                            'PayMoney');
  end;
end;

procedure TFrameMyScore.OnReturnFromWithDrawFrame(AFrame: TFrame);
begin
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                       DoGetUserInfoExecute,
                       DoGetUserInfoExecuteEnd,
                       'GetUserInfo');

  Self.lbList.Prop.StartPullDownRefresh;
end;

procedure TFrameMyScore.pnlClientResize(Sender: TObject);
begin
  //兑换按钮
//  Self.btnCash.Left:=5;
//  Self.btnCash.Width:=Self.pnlClient.Width/2-10;
  //充值按钮
//  Self.btnCashIn.Left:=Self.pnlClient.Width/2+5;
//  Self.btnCashIn.Width:=Self.pnlClient.Width/2-10;
  Self.btnCashIn.Left:=5;
  Self.btnCashIn.Width:=Self.pnlClient.Width-10;
end;

procedure TFrameMyScore.pnlMoneyInMessageBoxContentResize(Sender: TObject);
var
  ATempWidth:Double;
begin
  ATempWidth:=(Self.pnlMoneyInMessageBoxContent.Width-Self.btnWXPay.Width-Self.btnAliPay.Width)/3;
  Self.btnWXPay.Position.X:=ATempWidth;
  Self.btnAliPay.Position.X:=Self.btnWXPay.Width+ATempWidth*2;
end;

procedure TFrameMyScore.SkinFMXButton1Click(Sender: TObject);
begin
  //获取用户积分详情
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                          DoGetUserInfoExecute,
                          DoGetUserInfoExecuteEnd,
                          'GetUserInfo');
end;

procedure TFrameMyScore.tmrGetUserBillMoneyPayStateTimer(Sender: TObject);
begin
  Self.tmrGetUserBillMoneyPayState.Enabled:=False;

  FGetOrderPayStateCount:=0;
  FGetOrderPayStateIsOver:=False;


  //获取订单详情,判断是否支付成功
  ShowWaitingFrame(Self,'获取支付结果...');
  Self.tteGetOrderPayState.Run;
end;

procedure TFrameMyScore.tteGetOrderPayStateExecute(ATimerTask: TTimerTask);
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

procedure TFrameMyScore.tteGetOrderPayStateExecuteEnd(ATimerTask: TTimerTask);
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
                      uTimerTask.GetGlobalTimerThread.RunTempTask(
                                              DoGetUserInfoExecute,
                                              DoGetUserInfoExecuteEnd,
                                              'GetUserInfo');

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
                        uTimerTask.GetGlobalTimerThread.RunTempTask(
                                              DoGetUserInfoExecute,
                                              DoGetUserInfoExecuteEnd,
                                              'GetUserInfo');

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
