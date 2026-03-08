unit PriacyDetailSettingFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uDrawCanvas, uSkinItems, uSkinRadioButtonType, uSkinFireMonkeyRadioButton,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinFireMonkeyListBox,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uUIFunction,uTimerTask,uRestInterfaceCall, uOpenClientCommon,
  uManager, uOpenCommon,XSuperObject, MessageBoxFrame, WaitingFrame,
  uSkinPanelType, uSkinFireMonkeyPanel;

type
  TFramePriacyDetailSetting = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnShowImg: TSkinFMXButton;
    BtnSendPushNotificationTest: TSkinFMXButton;
    lbPrivacySetting: TSkinFMXListBox;
    idpLayout: TSkinFMXItemDesignerPanel;
    lblLayout: TSkinFMXLabel;
    ItemDefault: TSkinFMXItemDesignerPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    RadioBtn: TSkinFMXRadioButton;
    procedure btnReturnClick(Sender: TObject);
    procedure RadioBtnClick(Sender: TObject);
  private
    FIsFocusedPrivacySetting: Boolean;
    FIsFansPrivateSetting: Boolean;
    FIsVisitorPrivacySetting: Boolean;

    procedure SetCaption(aType:string);
    procedure SetRadioState(aSetStr:string);

    function SetPrivateSetting:string;

    //修改隐私设置
    procedure DoChangePrivacySettingExecute(ATimerTask:TObject);
    procedure DoChangePrivacySettingExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    //修改
    procedure EditMyFocusedPrivacySetting(aType:String);
    procedure EditMyFansPrivateSetting(aType:String);
    procedure EditMyVisitorPrivacySetting(aType:String);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalPriacyDetailSettingFrame:TFramePriacyDetailSetting;

implementation

{$R *.fmx}

procedure TFramePriacyDetailSetting.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then Exit;

  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self);
end;


constructor TFramePriacyDetailSetting.Create(AOwner: TComponent);
begin
  inherited;
  FIsFocusedPrivacySetting:=False;
  FIsFansPrivateSetting:= False;
  FIsVisitorPrivacySetting:= False;
end;

procedure TFramePriacyDetailSetting.DoChangePrivacySettingExecute(
  ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('update_private_setting',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'my_focused_privacy_setting',
                                                    'my_fans_private_setting',
                                                    'my_visitor_privacy_setting'],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    GlobalManager.FMyFocusedPrivacySetting,
                                                    GlobalManager.FMyFansPrivateSetting,
                                                    GlobalManager.FMyVisitorPrivacySetting],
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

procedure TFramePriacyDetailSetting.DoChangePrivacySettingExecuteEnd(
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
        //修改信息成功
        GlobalManager.User.ParseFromJson(ASuperObject.O['Data'].A['User'].O[0]);
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

procedure TFramePriacyDetailSetting.EditMyFansPrivateSetting(aType: String);
begin
  SetCaption(aType);
  FIsFocusedPrivacySetting:=False;
  FIsFansPrivateSetting:=True;
  FIsVisitorPrivacySetting:=False;
  SetRadioState(GlobalManager.FMyFansPrivateSetting);
end;

procedure TFramePriacyDetailSetting.EditMyFocusedPrivacySetting(aType: String);
begin
  SetCaption(aType);
  FIsFocusedPrivacySetting:=True;
  FIsFansPrivateSetting:=False;
  FIsVisitorPrivacySetting:=False;
  SetRadioState(GlobalManager.FMyFocusedPrivacySetting);
end;

procedure TFramePriacyDetailSetting.EditMyVisitorPrivacySetting(aType: String);
begin
  SetCaption(aType);
  FIsFocusedPrivacySetting:=False;
  FIsFansPrivateSetting:=False;
  FIsVisitorPrivacySetting:=True;
  SetRadioState(GlobalManager.FMyVisitorPrivacySetting);
end;

function TFramePriacyDetailSetting.SetPrivateSetting: string;
begin
  Result:='';

  if lbPrivacySetting.Prop.Items.FindItemByName('my_contact').Checked then
    Result:=Result+',my_contact';

  if lbPrivacySetting.Prop.Items.FindItemByName('my_focused').Checked then
    Result:=Result+',my_focused';

  if lbPrivacySetting.Prop.Items.FindItemByName('my_fans').Checked then
    Result:=Result+',my_fans';

  if lbPrivacySetting.Prop.Items.FindItemByName('stranger').Checked then
    Result:=Result+',stranger';

end;

procedure TFramePriacyDetailSetting.RadioBtnClick(Sender: TObject);
begin
  if lbPrivacySetting.Prop.InteractiveItem<>nil then
  begin
    lbPrivacySetting.Prop.InteractiveItem.Checked:=not RadioBtn.Prop.Checked;
    if FIsFocusedPrivacySetting then    //
      GlobalManager.FMyFocusedPrivacySetting:=SetPrivateSetting;
    if FIsFansPrivateSetting then
      GlobalManager.FMyFansPrivateSetting:= SetPrivateSetting;
    if FIsVisitorPrivacySetting then
      GlobalManager.FMyVisitorPrivacySetting:=SetPrivateSetting;


    //ShowWaitingFrame(Self,'修改中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                DoChangePrivacySettingExecute,
                DoChangePrivacySettingExecuteEnd,
                'update_private_setting');
  end;

end;

procedure TFramePriacyDetailSetting.SetCaption(aType: string);
begin
  pnlToolBar.Caption:=aType;
  lbPrivacySetting.Prop.Items.Items[0].Caption:='设置哪些联系人可以查看'+aType;
end;

procedure TFramePriacyDetailSetting.SetRadioState(aSetStr: string);
begin
  //我的好友
  if Pos('my_contact',aSetStr)>0 then
    lbPrivacySetting.Prop.Items.FindItemByName('my_contact').Checked:=True
  else
   lbPrivacySetting.Prop.Items.FindItemByName('my_contact').Checked:=False;
  //我的关注
  if Pos('my_focused',aSetStr)>0 then
  lbPrivacySetting.Prop.Items.FindItemByName('my_focused').Checked:=True
  else
   lbPrivacySetting.Prop.Items.FindItemByName('my_focused').Checked:=False;
  //我的粉丝
  if Pos('my_fans',aSetStr)>0 then
  lbPrivacySetting.Prop.Items.FindItemByName('my_fans').Checked:=True
  else
   lbPrivacySetting.Prop.Items.FindItemByName('my_fans').Checked:=False;
  //陌生人
  if Pos('stranger',aSetStr)>0 then
  lbPrivacySetting.Prop.Items.FindItemByName('stranger').Checked:=True
  else
   lbPrivacySetting.Prop.Items.FindItemByName('stranger').Checked:=False;
end;

end.
