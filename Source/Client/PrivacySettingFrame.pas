unit PrivacySettingFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uDrawCanvas, uSkinItems, uSkinImageType, uSkinFireMonkeyImage, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinFireMonkeyListBox,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl, uUIFunction,
  uTimerTask, uRestInterfaceCall, uOpenClientCommon, uManager, uOpenCommon,
  XSuperObject, MessageBoxFrame, WaitingFrame, uSkinPanelType,
  uSkinFireMonkeyPanel, uGraphicCommon;

type
  TFramePrivacySetting = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnShowImg: TSkinFMXButton;
    BtnSendPushNotificationTest: TSkinFMXButton;
    lbPrivacySetting: TSkinFMXListBox;
    ItemMenu: TSkinFMXItemDesignerPanel;
    lblItemMenuCaption: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    imgRight: TSkinFMXImage;
    idpLayout: TSkinFMXItemDesignerPanel;
    lblLayout: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure lbPrivacySettingClickItem(AItem: TSkinItem);
  private
    //获取隐私设置
    procedure DoGetPrivacySettingExecute(ATimerTask: TObject);
    procedure DoGetPrivacySettingExecuteEnd(ATimerTask: TObject);
    { Private declarations }
  public

    procedure Load;
  end;

var
  GlobalPrivacySettingFrame: TFramePrivacySetting;

implementation

uses
  MainForm,
  PriacyDetailSettingFrame,
  BlackListFrame;

{$R *.fmx}

{ TFramePrivacySetting }

procedure TFramePrivacySetting.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then
    Exit;

  //返回
  HideFrame; //(Self,hfcttBeforeReturnFrame);
  ReturnFrame; //(Self);
end;

procedure TFramePrivacySetting.DoGetPrivacySettingExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc := SimpleCallAPI('get_private_setting', nil, UserCenterInterfaceUrl, ['appid', 'user_fid', 'key'], [AppID, GlobalManager.User.fid, GlobalManager.User.key], GlobalRestAPISignType, GlobalRestAPIAppSecret);
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

procedure TFramePrivacySetting.DoGetPrivacySettingExecuteEnd(ATimerTask: TObject);
var
  ASuperObject: ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag = 0 then
    begin
      ASuperObject := TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code'] = 200 then
      begin
        GlobalManager.FMyFocusedPrivacySetting := ASuperObject.O['Data'].A['User'].O[0].S['my_focused_privacy_setting'];
        GlobalManager.FMyFansPrivateSetting := ASuperObject.O['Data'].A['User'].O[0].S['my_fans_private_setting'];
        GlobalManager.FMyVisitorPrivacySetting := ASuperObject.O['Data'].A['User'].O[0].S['my_visitor_privacy_setting'];
      end
      else
      begin
        //调用失败
        ShowMessageBoxFrame(Self, ASuperObject.S['Desc'], '', TMsgDlgType.mtInformation, ['确定'], nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag = 1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self, '网络异常,请检查您的网络连接!', TTimerTask(ATimerTask).TaskDesc, TMsgDlgType.mtInformation, ['确定'], nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

procedure TFramePrivacySetting.lbPrivacySettingClickItem(AItem: TSkinItem);
begin
  if AItem.Name = 'myFocused' then
  begin
    HideFrame; //(CurrentFrame,hfcttBeforeShowFrame);
    ShowFrame(TFrame(GlobalPriacyDetailSettingFrame), TFramePriacyDetailSetting, frmMain, nil, nil, nil, Application);
    GlobalPriacyDetailSettingFrame.EditMyFocusedPrivacySetting(AItem.Caption);
  end
  else
  if AItem.Name = 'myFans' then
  begin
    HideFrame; //(CurrentFrame,hfcttBeforeShowFrame);
    ShowFrame(TFrame(GlobalPriacyDetailSettingFrame), TFramePriacyDetailSetting, frmMain, nil, nil, nil, Application);
    GlobalPriacyDetailSettingFrame.EditMyFansPrivateSetting(AItem.Caption);
  end
  else
  if AItem.Name = 'myVisitors' then
  begin
    HideFrame; //(CurrentFrame,hfcttBeforeShowFrame);
    ShowFrame(TFrame(GlobalPriacyDetailSettingFrame), TFramePriacyDetailSetting, frmMain, nil, nil, nil, Application);
    GlobalPriacyDetailSettingFrame.EditMyVisitorPrivacySetting(AItem.Caption);
  end
  else
  if AItem.Name = 'blacklist' then
  begin
    //黑名单
    HideFrame;
    ShowFrame(TFrame(GlobalBlackListFrame), TBlackList);
    GlobalBlackListFrame.Load;
  end;

end;

procedure TFramePrivacySetting.Load;
begin
  //获取用户隐私设置
  uTimerTask.GetGlobalTimerThread.RunTempTask(DoGetPrivacySettingExecute, DoGetPrivacySettingExecuteEnd, 'GetPrivateSetting');
end;

end.

