unit ScoreDetailFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uFrameContext,
  uDatasetToJson,
  uDrawCanvas, uSkinItems, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinButtonType,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinPanelType,
  uUIFunction, uOpenClientCommon,
  uSkinFireMonkeyPanel;

type
  TFrameScoreDetail = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnShowImg: TSkinFMXButton;
    BtnSendPushNotificationTest: TSkinFMXButton;
    lbList: TSkinFMXListBox;
    idpContent: TSkinFMXItemDesignerPanel;
    lblType: TSkinFMXLabel;
    lblTime: TSkinFMXLabel;
    lblMoneyValue: TSkinFMXLabel;
    lblCash: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure lbListPullDownRefresh(Sender: TObject);
    procedure lbListPullUpLoadMore(Sender: TObject);
  private
    FJson:String;
    FFilterRuleType:String;
    FPageIndex:Integer;
    //用户积分往来列表
    FUserBillMoneyList:TUserBillMoneyList;
    procedure DoGetTransactionListExecute(ATimerTask:TObject);
    procedure DoGetTransactionListExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    procedure Init(AFilterMoney:Double);
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalScoreDetailFrame:TFrameScoreDetail;

implementation
uses uTimerTask,uRestInterfaceCall,uManager,XSuperObject,uOpenCommon,MessageBoxFrame;
{$R *.fmx}

procedure TFrameScoreDetail.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then Exit;

  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self);
end;

constructor TFrameScoreDetail.Create(AOwner: TComponent);
begin
  inherited;
  FUserBillMoneyList:=TUserBillMoneyList.Create;
  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameScoreDetail.Destroy;
begin
  FreeAndNil(FUserBillMoneyList);
  inherited;
end;

procedure TFrameScoreDetail.DoGetTransactionListExecute(ATimerTask: TObject);
var
  AWhereSql:String;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try



    FJson:=GetWhereConditions(['appid','user_fid'],
                      [AppID,GlobalManager.User.fid]);

    AWhereSql:='';
    if FFilterRuleType='1' then
    begin
      AWhereSql:=' AND (score>0) ';
    end
    else if FFilterRuleType='0' then
    begin
      AWhereSql:=' AND (score<0) ';
    end;

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
                                                    'where_sql',
                                                    'order_by'],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    '',
                                                    'user_score_inout_view',
                                                    FPageIndex,
                                                    20,
                                                    FJson,
                                                    AWhereSql,
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

procedure TFrameScoreDetail.DoGetTransactionListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
  ADateTime:TDateTime;
  J: Integer;
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
          end;

//          //获取成功，加载列表
//          AUserBillMoneyList:=TUserBillMoneyList.Create(ooReference);
//          AUserBillMoneyList.ParseFromJsonArray(TUserBillMoney,ASuperObject.O['Data'].A['RecordList']);
//
          if ASuperObject.O['Data'].A['RecordList'].Length<1 then
          begin
            Self.lbList.Prop.IsEmptyContent:=True;
          end
          else
          begin
            Self.lbList.Prop.IsEmptyContent:=False;

            //加载流水列表
            Self.lbList.Prop.Items.BeginUpdate;
            try

              for I := 0 to ASuperObject.O['Data'].A['RecordList'].Length-1 do
              begin

                AListBoxItem:=Self.lbList.Prop.Items.Add;
                AListBoxItem.Data:=ASuperObject.O['Data'].A['RecordList'].O[I];
                AListBoxItem.Caption:=GetScoreRuleTypeStr(ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']);

//                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_MyManConsumeMoney then
//                begin
//                  AListBoxItem.Caption:='好友下单赠送积分';
//                end;
//
//                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_ScoreReBack then
//                begin
//                  AListBoxItem.Caption:='订单取消,返还抵扣积分';
//                end;
//
//                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_IndianaGoods then
//                begin
//                  AListBoxItem.Caption:='积分夺宝';
//                end;
//
//                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_UsedScore then
//                begin
//                  AListBoxItem.Caption:='消费积分抵扣';
//                end;
//
//                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_ExchangeScore then
//                begin
//                  AListBoxItem.Caption:='积分兑换余额';
//                end;
//
//                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_InviteRegister then
//                begin
//                  AListBoxItem.Caption:='邀请好友注册';
//                end;
//
//                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_Register then
//                begin
//                  AListBoxItem.Caption:='新用户注册奖励';
//                end;
//
//                if ASuperObject.O['Data'].A['RecordList'].O[I].S['rule_type']=Const_RuleType_InvestScore then
//                begin
//                  AListBoxItem.Caption:='积分充值';
//                end;

                AListBoxItem.Detail:='成功 '+ASuperObject.O['Data'].A['RecordList'].O[I].S['createtime'];


                if ASuperObject.O['Data'].A['RecordList'].O[I].F['score']>0 then
                begin
                  AListBoxItem.Detail1:='+'+Format('%.2f',[ASuperObject.O['Data'].A['RecordList'].O[I].F['score']]);
                end
                else
                begin
                  AListBoxItem.Detail1:=Format('%.2f',[ASuperObject.O['Data'].A['RecordList'].O[I].F['score']]);
                end;

//                AListBoxItem.Detail2:='积分: '+Format('%.2f',[AUserBillMoneyList[I].user_money]);


              end;

            finally
              Self.lbList.Prop.Items.EndUpdate();
            end;
          end;
        finally
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
      if (TTimerTask(ATimerTask).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['RecordList'].Length>0) then
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

procedure TFrameScoreDetail.Init(AFilterMoney: Double);
var
  I: Integer;
begin
  Self.lbList.Prop.Items.Clear(True);

//  FFilterStartDate:=FormatDateTime('YYYY-MM',Now)+'-01';
//  FFilterEndDate:=FormatDateTime('YYYY-MM',Now)+'-30';
//
//
//
//  FUsedMoney:=AFilterMoney;




  FFilterRuleType:='';

  Self.lbList.Prop.StartPullDownRefresh;
end;

procedure TFrameScoreDetail.lbListPullDownRefresh(Sender: TObject);
begin
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                   DoGetTransactionListExecute,
                   DoGetTransactionListExecuteEnd,
                   'GetTransactionList');
end;

procedure TFrameScoreDetail.lbListPullUpLoadMore(Sender: TObject);
begin
  FPageIndex:=FPageIndex+1;

  uTimerTask.GetGlobalTimerThread.RunTempTask(
                   DoGetTransactionListExecute,
                   DoGetTransactionListExecuteEnd,
                   'GetTransactionList');
end;

end.
