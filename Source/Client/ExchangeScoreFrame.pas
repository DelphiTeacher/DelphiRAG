unit ExchangeScoreFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinMaterial,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uAPPCommon,

  uTimerTask,

  MessageBoxFrame,
  uOpenClientCommon,

  EasyServiceCommonMaterialDataMoudle,
  CommonImageDataMoudle,

  uBaseHttpControl,
  uRestInterfaceCall,

  uManager,
  WaitingFrame,

  StrUtils,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollBoxContentType,
  uSkinFireMonkeyScrollBoxContent, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinFireMonkeyScrollBox, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinImageType, uSkinFireMonkeyImage, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel;

type
  TFrameExchangeScore = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlDevice1: TSkinFMXPanel;
    pnlWithDraw: TSkinFMXPanel;
    lblUsedMoney: TSkinFMXLabel;
    edtInputMoney: TSkinFMXEdit;
    btnAll: TSkinFMXButton;
    btnOk: TSkinFMXButton;
    mcNotice: TSkinFMXMultiColorLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure edtInputMoneyChangeTracking(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    //银行卡信息
    FFilterBankCardFID:Integer;

    FFilterName:String;
    FFilterBankCardName:String;
    FFilterBankCardAccount:String;
    //余额
//    FFilterMoney:Double;
    FBankCardList:TBankCardList;
    //积分兑换比率  比如 10积分兑换1元
    FScoreRuly:Double;
    FScoreRulyFID:Integer;
  private
    //积分兑换申请
    procedure DoInputWithDrawReplyExecute(ATimerTask:TObject);
    procedure DoInputWithDrawReplyExecuteEnd(ATimerTask:TObject);

    //从弹出框返回
    procedure OnModalResultFromSelf(Frame: TObject);
    { Private declarations }
  public
    //清空
    procedure Clear;
    //加载信息
    procedure Init(AScore:Double;
                    AScoreRuly:Double;
                    AScoreRulyFID:Integer);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalExchangeScoreFrame:TFrameExchangeScore;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame,
  MyBankCardListFrame;

procedure TFrameExchangeScore.btnAllClick(Sender: TObject);
begin
  Self.edtInputMoney.Text:=Format('%.2f',[GlobalManager.User.score]);
end;


procedure TFrameExchangeScore.btnOkClick(Sender: TObject);
begin

  if Self.edtInputMoney.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入要兑换的积分!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if StrToFloat(Self.edtInputMoney.Text)<FScoreRuly then
  begin
    ShowMessageBoxFrame(Self,'最低兑换'+FloatToStr(FScoreRuly)+'积分!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  GlobalManager.User.score:=StrToFloat(Self.edtInputMoney.Text);

  //提交提现申请
  ShowWaitingFrame(Self,'正在提交...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
             DoInputWithDrawReplyExecute,
             DoInputWithDrawReplyExecuteEnd,
             'InputWithDrawReply');
end;

procedure TFrameExchangeScore.btnReturnClick(Sender: TObject);
begin
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameExchangeScore.Clear;
begin
//  FFilterMoney:=0;

  Self.edtInputMoney.Text:='';

  Self.lblUsedMoney.Caption:='';
end;

constructor TFrameExchangeScore.Create(AOwner: TComponent);
begin
  inherited;
//  FBankCardList:=TBankCardList.Create;
//翻译部分先注释
//  RecordSubControlsLang(Self);
//  TranslateSubControlsLang(Self);
  Self.mcNotice.Prop.Items[1].DrawFont.Color:=SkinThemeColor;
  Self.btnAll.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;
  Self.edtInputMoney.TextSettings.FontColor:=SkinThemeColor;
end;

destructor TFrameExchangeScore.Destroy;
begin
//  FreeAndNil(FBankCardList);
  inherited;
end;

procedure TFrameExchangeScore.DoInputWithDrawReplyExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
          SimpleCallAPI('user_request_exchange_score',
                        nil,
                        ScoreCenterInterfaceUrl,
                        ['appid',
                        'user_fid',
                        'key',
                        'need_info',
                        'score',
                        'exchange_type_fid',
                        'goods_num',
                        'is_need_change_user_money',
                        'money'],
                        [AppID,
                        GlobalManager.User.fid,
                        GlobalManager.User.key,
                        '',
                        Self.edtInputMoney.Text,
                        FScoreRulyFID,
                        StrToFloat(Format('%.2f',[StrToFloat(Self.edtInputMoney.Text)/FScoreRuly])),
                        1,
                        StrToFloat(Format('%.2f',[StrToFloat(Self.edtInputMoney.Text)/FScoreRuly]))
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

procedure TFrameExchangeScore.DoInputWithDrawReplyExecuteEnd(
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
        //提交成功
        ShowMessageBoxFrame(Self,'提交成功,请耐心等待结果','',TMsgDlgType.mtInformation,['确定'],OnModalResultFromSelf);
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

procedure TFrameExchangeScore.edtInputMoneyChangeTracking(Sender: TObject);
var
  AMoney:Double;
begin
  AMoney:=0;
  if Self.edtInputMoney.Text<>'' then
  begin
    Self.btnOk.Enabled:=True;

    AMoney:=StrToFloat(Self.edtInputMoney.Text);

    //FFilterMoney:=StrToFloat(Format('%.2f',[FFilterMoney]));

    if AMoney<=GlobalManager.User.score then
    begin
      Self.lblUsedMoney.Caption:='积分为'+FloatToStr(GlobalManager.User.score);
      Self.lblUsedMoney.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
      Self.btnOk.Enabled:=True;
    end
    else
    begin
      Self.lblUsedMoney.Caption:='您没有这么多积分';
      Self.lblUsedMoney.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
      Self.btnOk.Enabled:=False;
    end;
  end
  else
  begin
    Self.btnOk.Enabled:=False;
  end;
end;

procedure TFrameExchangeScore.Init(AScore:Double;
                                    AScoreRuly:Double;
                                    AScoreRulyFID:Integer);
begin
  Self.Clear;

  //FFilterMoney:=AScore;

  Self.lblUsedMoney.Caption:='可用积分'+Format('%.2f',[GlobalManager.User.score]);
  Self.lblUsedMoney.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;

  Self.mcNotice.Prop.Items[1].Text:=Format('%.2f',[AScoreRuly])+'积分=1元人民币';

  FScoreRuly:=AScoreRuly;
  FScoreRulyFID:=AScoreRulyFID;
end;

procedure TFrameExchangeScore.OnModalResultFromSelf(Frame: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

end.

