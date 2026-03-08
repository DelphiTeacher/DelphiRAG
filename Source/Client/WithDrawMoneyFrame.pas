unit WithDrawMoneyFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinMaterial,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uAPPCommon,
  uFuncCommon,
  uFrameContext,

  uTimerTask,

  MessageBoxFrame,
//  uOpenClientCommon,

  EasyServiceCommonMaterialDataMoudle,
  CommonImageDataMoudle,

  uBaseHttpControl,
  uRestInterfaceCall,

  uManager,
  uOpenClientCommon,
  uOpenCommon,

  WaitingFrame,

  StrUtils,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollBoxContentType,
  uSkinFireMonkeyScrollBoxContent, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinFireMonkeyScrollBox, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinImageType, uSkinFireMonkeyImage, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit;

type
  TFrameWithDrawMoney = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlBankCard: TSkinFMXPanel;
    pnlDevice: TSkinFMXPanel;
    imgBank: TSkinFMXImage;
    btnSelectBankCard: TSkinFMXButton;
    pnlDevice1: TSkinFMXPanel;
    pnlWithDraw: TSkinFMXPanel;
    lblMoney: TSkinFMXLabel;
    lblUsedMoney: TSkinFMXLabel;
    pnlMoney: TSkinFMXPanel;
    imgMoney: TSkinFMXImage;
    edtInputMoney: TSkinFMXEdit;
    btnAll: TSkinFMXButton;
    btnOk: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure edtInputMoneyChangeTracking(Sender: TObject);
    procedure btnSelectBankCardClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    //银行卡信息
    FFilterBankCardFID:Integer;

    FFilterName:String;
    FFilterBankCardName:String;
    FFilterBankCardAccount:String;
    //余额
    FFUserMonkey:Double;
    FBankCardList:TBankCardList;
  private
    //从选择银行卡列表返回
    procedure OnReturnFrameSelectedBankCardList(AFrame:TFrame);
  private
    //提现申请
    procedure DoInputWithDrawReplyExecute(ATimerTask:TObject);
    procedure DoInputWithDrawReplyExecuteEnd(ATimerTask:TObject);
    //从弹出框返回
    procedure OnModalResultFromSelf(Frame: TObject);
    { Private declarations }
  public
    //是否限制最低提现金额   外卖的不区分
    //0  不限制  1  限制   如果限制的话  设置的最低金额才有效
    FIsLimitWithDrawMoney:Integer;
    //最低提现金额
    FMinWithDrawMoney:Double;
    //清空
    procedure Clear;
    //加载信息
    procedure Init(AUsedMoney:Double;
                   ABankCardList:TBankCardList;
                   AIsLimitWithDrawMoney:Integer=0;
                   AMinWithDrawMoney:Double=0);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalWithDrawMoneyFrame:TFrameWithDrawMoney;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame,
  MyBankCardListFrame;

procedure TFrameWithDrawMoney.btnAllClick(Sender: TObject);
begin
  Self.edtInputMoney.Text:=Format('%.2f',[FFUserMonkey]);
end;


procedure TFrameWithDrawMoney.btnOkClick(Sender: TObject);
begin
  if Self.btnSelectBankCard.Caption='' then
  begin
    ShowMessageBoxFrame(Self,'请选择银行卡!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Self.edtInputMoney.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入提现金额!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  FFUserMonkey:=StrToFloat(Self.edtInputMoney.Text);

  //提交提现申请
  ShowWaitingFrame(Self,'正在提交...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
             DoInputWithDrawReplyExecute,
             DoInputWithDrawReplyExecuteEnd,
             'InputWithDrawReply');
end;

procedure TFrameWithDrawMoney.btnReturnClick(Sender: TObject);
begin
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameWithDrawMoney.btnSelectBankCardClick(Sender: TObject);
begin
  //查看银行卡列表
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  ShowFrame(TFrame(GlobalMyBankCardListFrame),TFrameMyBankCardList,frmMain,nil,nil,OnReturnFrameSelectedBankCardList,Application);
//  GlobalMyBankCardListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalMyBankCardListFrame.Load('我的银行卡',futSelectList,FFilterBankCardFID);
end;

procedure TFrameWithDrawMoney.Clear;
begin
  FFUserMonkey:=0;

  Self.imgBank.Prop.Picture.ImageIndex:=-1;
  Self.btnSelectBankCard.Caption:='';

  Self.edtInputMoney.Text:='';

  Self.lblUsedMoney.Caption:='';
end;

constructor TFrameWithDrawMoney.Create(AOwner: TComponent);
begin
  inherited;
//  FBankCardList:=TBankCardList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  Self.btnAll.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;
  Self.edtInputMoney.TextSettings.FontColor:=SkinThemeColor;
end;

destructor TFrameWithDrawMoney.Destroy;
begin
//  FreeAndNil(FBankCardList);
  inherited;
end;


procedure TFrameWithDrawMoney.DoInputWithDrawReplyExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
          SimpleCallAPI('user_request_withdraw',
                        nil,
                        PayCenterInterfaceUrl,
                        ['appid',
                        'user_fid',
                        'key',
                        'accept_bankaccount_name',
                        'accept_bankaccount_bankname',
                        'accept_bankaccount_account',
                        'money'],
                        [AppID,
                        GlobalManager.User.fid,
                        GlobalManager.User.key,
                        FFilterName,
                        FFilterBankCardName,
                        FFilterBankCardAccount,
                        FFUserMonkey
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

procedure TFrameWithDrawMoney.DoInputWithDrawReplyExecuteEnd(
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

procedure TFrameWithDrawMoney.edtInputMoneyChangeTracking(Sender: TObject);
var
  AMoney:Double;
begin
  AMoney:=0;
  if Self.edtInputMoney.Text<>'' then
  begin
    Self.btnOk.Enabled:=True;
    try
      TryStrToFloat(Self.edtInputMoney.Text,AMoney);

      FFUserMonkey:=StrToFloat(Format('%.2f',[FFUserMonkey]));

      if SmallerEqualDouble(AMoney,FFUserMonkey) then
      begin
          Self.lblUsedMoney.Caption:='余额为'+FloatToStr(FFUserMonkey)+'元';
          Self.lblUsedMoney.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;

          if ((FIsLimitWithDrawMoney=1) AND (AMoney<FMinWithDrawMoney)) then
          begin
              Self.btnOk.Enabled:=False;
          end;
      end
      else
      begin
        Self.lblUsedMoney.Caption:='您没有这么多余额';
        Self.lblUsedMoney.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Red;
        Self.btnOk.Enabled:=False;
      end;
    except on E:exception do
      //
    end;
  end
  else
  begin
    Self.btnOk.Enabled:=False;
  end;
end;

procedure TFrameWithDrawMoney.Init(AUsedMoney: Double;
                                   ABankCardList:TBankCardList;
                                   AIsLimitWithDrawMoney:Integer=0;
                                   AMinWithDrawMoney:Double=0);
var
  I:Integer;
begin
  Self.Clear;

  FFUserMonkey:=AUsedMoney;
  FIsLimitWithDrawMoney:=AIsLimitWithDrawMoney;
  FMinWithDrawMoney:=AMinWithDrawMoney;



  for I := 0 to ABankCardList.Count-1 do
  begin
    if ABankCardList[I].is_default=1 then
    begin
      FFilterBankCardFID:=ABankCardList[I].fid;

      FFilterName:=ABankCardList[I].name;
      FFilterBankCardName:=ABankCardList[I].bankname;
      FFilterBankCardAccount:=ABankCardList[I].account;

      Self.imgBank.Prop.Picture.ImageIndex:=GetBankIconIndex(ABankCardList[I].bankname);

      Self.btnSelectBankCard.Caption:=ABankCardList[I].bankname+'(尾号'+RightStr(ABankCardList[I].account,4)+')';
    end;
  end;

  Self.lblUsedMoney.Caption:='可用余额'+Format('%.2f',[AUsedMoney])+'元';
  Self.lblUsedMoney.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;

end;

procedure TFrameWithDrawMoney.OnModalResultFromSelf(Frame: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameWithDrawMoney.OnReturnFrameSelectedBankCardList(AFrame: TFrame);
begin
  if GlobalMyBankCardListFrame.FSelectedBankCardFID<>0 then
  begin
    Self.FFilterBankCardFID:=GlobalMyBankCardListFrame.FSelectedBankCardFID;
  end;

  if GlobalMyBankCardListFrame.FSelectedBankCard<>nil then
  begin
    Self.imgBank.Prop.Picture.ImageIndex:=GetBankIconIndex(GlobalMyBankCardListFrame.FSelectedBankCard.bankname);
    Self.btnSelectBankCard.Caption:=GlobalMyBankCardListFrame.FSelectedBankCard.bankname+'(尾号'+RightStr(GlobalMyBankCardListFrame.FSelectedBankCard.account,4)+')';

    FFilterName:=GlobalMyBankCardListFrame.FSelectedBankCard.name;
    FFilterBankCardName:=GlobalMyBankCardListFrame.FSelectedBankCard.bankname;
    FFilterBankCardAccount:=GlobalMyBankCardListFrame.FSelectedBankCard.account;

  end;
end;

end.
