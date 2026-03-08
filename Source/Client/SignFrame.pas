unit SignFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinImageType, uSkinFireMonkeyImage, uSkinFireMonkeyControl,
  WaitingFrame,
  MessageBoxFrame,
  uTimerTask,
  uRestInterfaceCall,
  uOpenClientCommon,
  ListItemStyleFrame_SignDay,
  uManager,
  uOpenCommon,
  XSuperObject,
  uUIFunction,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinFireMonkeyScrollBox,
  uDrawCanvas, uSkinItems, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinButtonType, uSkinFireMonkeyButton,
  uFrameContext, FMX.Effects, uSkinScrollBoxContentType,
  uSkinFireMonkeyScrollBoxContent, uSkinListViewType, uSkinFireMonkeyListView;

type
  TFrameSign = class(TFrame)
    btnSign: TSkinFMXButton;
    pnlBtn: TSkinFMXPanel;
    pnlBox: TSkinFMXPanel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    ShadowEffect1: TShadowEffect;
    btnDays: TSkinFMXButton;
    FrameContext1: TFrameContext;
    pnltop: TSkinFMXPanel;
    labTitle: TSkinFMXLabel;
    pnlScore: TSkinFMXPanel;
    lableft: TSkinFMXLabel;
    labscore: TSkinFMXLabel;
    btnClose: TSkinFMXButton;
    lstvcenter: TSkinFMXListView;
    imgbg: TSkinFMXImage;
    pnlclose: TSkinFMXPanel;
    labcontainer: TSkinFMXLabel;
    procedure lbRulePrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure btnSignClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure FrameContext1Load(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    //连续签到天数
    FSignDays:Integer;
    //签到领取的积分
    FGiftScore:Integer;
    //今天是否签到
    FIsSigned:Integer;
    //界面显示的积分
    FUsedMoney:Double;

    //调用签到接口
    procedure DoSignExecute(ATimerTask:TObject);
    procedure DoSignExecuteEnd(ATimerTask:TObject);


    procedure HidePanelBox(Sender:TObject);
    procedure LoadListRecord(ASuperObject:ISuperObject);

    //获取用户积分
    procedure DoGetUserInfoExecute(ATimerTask:TObject);
    procedure DoGetUserInfoExecuteEnd(ATimerTask:TObject);

    // 调用签到规则接口
    procedure DoSignRuleExecute(ATimerTask:TObject);
    procedure DoSignRuleExecuteEnd(ATimerTask:TObject);

    // 获取连续签到天数
    procedure DoSignDaysExecute(ATimerTask:TObject);
    procedure DoSignDaysExecuteEnd(ATimerTask:TObject);
  public
    procedure Load;
    { Public declarations }
  end;


var
  GlobalSignFrame:TFrameSign;

implementation
uses

  SignSucceedFrame;
{$R *.fmx}

procedure TFrameSign.btnCloseClick(Sender: TObject);
begin
  HideFrame;//(nil,hfcttAuto,ufsefAlpha);
  ReturnFrame;
end;

procedure TFrameSign.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then Exit;

  HideFrame;
  ReturnFrame;
end;

procedure TFrameSign.btnSignClick(Sender: TObject);
begin
  ShowWaitingFrame(Self,'签到中...');
  //登录
  uTimerTask.GetGlobalTimerThread.RunTempTask(
      DoSignExecute,
      DoSignExecuteEnd,
      'user_sign_in'
      );
end;

procedure TFrameSign.DoSignDaysExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
      SimpleCallAPI('get_keep_sign_in_days',
                    nil,
                    UserCenterInterfaceUrl,
                    ['appid',
                    'user_fid',
                    'key'
                    ],
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

procedure TFrameSign.DoSignDaysExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取连续签到天数
        FSignDays:=ASuperObject.O['Data'].I['Days'];
        //设置界面已签到天数
        if FSignDays <=7 then
        begin
          for I := 0 to FSignDays-1 do
          begin
            Self.lstvcenter.Prop.Items[I].Checked:=True;
          end;
        end
        else
        begin
          for I := 0 to (FSignDays mod 7)-1 do
          begin
            Self.lstvcenter.Prop.Items[I].Checked:=True;
          end;
        end;

        //获取今天是否签到
        FIsSigned:=ASuperObject.O['Data'].I['IsSigned'];
        btnDays.Caption:='已连续签到'+IntToStr(FSignDays)+'天';
        if FIsSigned=1 then
        begin
          btnSign.Caption:='今日已签到';
          btnSign.HitTest:=False;
          btnSign.SelfOwnMaterial.BackColor.FillColor.Color:=TAlphaColorRec.Gray;
        end else
        begin
          btnSign.Caption:='签到';
          btnSign.HitTest:=True;
          btnSign.SelfOwnMaterial.BackColor.FillColor.Color:=$FFFFCA4A;
        end;
      end else
      begin
        //获取失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;
    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',
                            UserCenterInterfaceUrl+#13#10
                            +TTimerTask(ATimerTask).TaskDesc,
                            TMsgDlgType.mtInformation,
                            ['确定'],nil);
    end;
  finally
//    HideWaitingFrame;
  end;
end;

procedure TFrameSign.DoSignExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
      SimpleCallAPI('user_sign_in',
                    nil,
                    UserCenterInterfaceUrl,
                    ['appid',
                    'user_fid',
                    'orderno',
                    'key'
                    ],
                    [AppID,
                     GlobalManager.User.fid,
                     0,
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

procedure TFrameSign.DoSignExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
//        FGiftScore:=ASuperObject.O['Data'].A['SignIn'].O[0].I['add_score'];
//        pnlBox.Visible:=True;

//        GlobalSignSucceedFrame:=TFrameSignSucceed.Create(Self);
//        SetFrameName(GlobalSignSucceedFrame);
//        GlobalSignSucceedFrame.Parent:=pnlBox;
//        GlobalSignSucceedFrame.Align:=TAlignLayout.Center;
//        GlobalSignSucceedFrame.FSignDays:=IntToStr(FSignDays+1);
//        GlobalSignSucceedFrame.FGiftScore:=IntToStr(FGiftScore);
//        GlobalSignSucceedFrame.Load;
//        GlobalSignSucceedFrame.btnOK.OnClick:=HidePanelBox;


//        ShowWaitingFrame(Self,'加载中...');
        //获取连续签到天数
        uTimerTask.GetGlobalTimerThread.RunTempTask(
            DoSignDaysExecute,
            DoSignDaysExecuteEnd,
            'get_keep_sign_in_days'
            );

      //  ShowWaitingFrame(Self,'加载中...');
        //获取用户积分详情
        uTimerTask.GetGlobalTimerThread.RunTempTask(
            DoGetUserInfoExecute,
            DoGetUserInfoExecuteEnd,
            'GetUserInfo');



      end
      else
//      if ASuperObject.I['Code']=400 then
//      begin
//        pnlBox.Visible:=True;
//        GlobalSignFrame:=TFrameSign.Create(Self);
//        GlobalSignFrame.Parent:=pnlBox;
//        GlobalSignFrame.Align:=TAlignLayout.Center;
////        GlobalSignFrame.btnOKClick();
//        GlobalSignFrame.btnOK.OnClick:=HidePanelBox;
//      end;
      begin
        //签到失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;
    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',
                            UserCenterInterfaceUrl+#13#10
                            +TTimerTask(ATimerTask).TaskDesc,
                            TMsgDlgType.mtInformation,
                            ['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

procedure TFrameSign.DoSignRuleExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
      SimpleCallAPI('get_app_score_rule_list',
                    nil,
                    ScoreCenterInterfaceUrl,
                    ['appid',
                    'emp_fid',
                    'key',
                    'filter_rule_type'
                    ],
                    [AppID,
                     GlobalManager.User.fid,
                     GlobalManager.User.key,
                     'user_sign_in'
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

procedure TFrameSign.DoSignRuleExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        LoadListRecord(ASuperObject);
//        FGiftScore:=ASuperObject.O['Data'].A['AppScoreRuleList']
      end else
      begin
        //获取失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;
    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',
                            UserCenterInterfaceUrl+#13#10
                            +TTimerTask(ATimerTask).TaskDesc,
                            TMsgDlgType.mtInformation,
                            ['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

procedure TFrameSign.DoGetUserInfoExecute(ATimerTask: TObject);
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

procedure TFrameSign.DoGetUserInfoExecuteEnd(ATimerTask: TObject);
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
        FUsedMoney:=ASuperObject.O['Data'].A['User'].O[0].F['score'];
        Self.labscore.Caption:=Format('%.0f',[FUsedMoney]);
        GlobalManager.User.score:=ASuperObject.O['Data'].A['User'].O[0].F['score'];
        //Self.lbList.Prop.StartPullDownRefresh;
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
//    HideWaitingFrame;
  end;
end;

procedure TFrameSign.FrameContext1Load(Sender: TObject);
var
  I:Integer;
begin
  //清空积分
  Self.labscore.Caption:=FloatToStr(GlobalManager.User.score);

  //设置设计面板全部为未选中状态
  Self.lstvcenter.Prop.Items.BeginUpdate;
  try
    for I := 0 to Self.lstvcenter.Prop.Items.Count-1 do
    begin
      Self.lstvcenter.Prop.Items[I].Checked:=False;
    end;
  finally
    Self.lstvcenter.Prop.Items.EndUpdate;
  end;

//  ShowWaitingFrame(Self,'加载中...');
//  //调用签到规则接口
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//      DoSignRuleExecute,
//      DoSignRuleExecuteEnd,
//      'get_app_score_rule_list'
//      );

//  ShowWaitingFrame(Self,'加载中...');
  //获取连续签到天数
  uTimerTask.GetGlobalTimerThread.RunTempTask(
      DoSignDaysExecute,
      DoSignDaysExecuteEnd,
      'get_keep_sign_in_days'
      );

//  ShowWaitingFrame(Self,'加载中...');
  //获取用户积分详情
  uTimerTask.GetGlobalTimerThread.RunTempTask(
      DoGetUserInfoExecute,
      DoGetUserInfoExecuteEnd,
      'GetUserInfo');

end;

procedure TFrameSign.HidePanelBox(Sender: TObject);
begin
//  pnlBox.Visible:=False;
//  btnSign.Caption:='今日已签到';
//  btnDays.Caption:='已连续签到'+IntToStr(FSignDays)+'天';
end;

procedure TFrameSign.lbRulePrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
//  if AItem.Index=lbRule.Prop.Items.Count-1 then
//  begin
//    ItemDefault.SelfOwnMaterial.BackColor.IsRound:=true;
//  end else
//  begin
//    ItemDefault.SelfOwnMaterial.BackColor.IsRound:=False;
//  end;
end;

procedure TFrameSign.Load;
begin
  //放到FrameContext.OnLoad中了
end;

procedure TFrameSign.LoadListRecord(ASuperObject:ISuperObject);
var
  aListBoxItem:TSkinItem;
  I:Integer;
begin
//  lbRule.Prop.Items.Clear(True);
//  aListBoxItem:=lbRule.Prop.Items.Add;
//  aListBoxItem.Caption:='签到规则';
//  aListBoxItem.ItemType:=sitHeader;
//
//  for I := 0 to ASuperObject.O['Data'].A['AppScoreRuleList'].Length-1 do
//  begin
//    aListBoxItem:=lbRule.Prop.Items.Add;
//    aListBoxItem.Caption:='0'+IntToStr(I+1);
//    aListBoxItem.Detail:=ASuperObject.O['Data'].A['AppScoreRuleList'].O[I].S['rule_describe'];
//    aListBoxItem.ItemType:=sitDefault;
//  end;
//
//  sbcClient.Height:=230+70*(I+1)+15;
end;

end.
