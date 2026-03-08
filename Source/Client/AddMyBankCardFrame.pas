unit AddMyBankCardFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  EasyServiceCommonMaterialDataMoudle,

  uTimerTask,
  uManager,
  uOpenClientCommon,
  uOpenCommon,
  uFrameContext,
//  uCommonUtils,
//  uOpenClientCommon,

  uFuncCommon,
  uBaseList,
  uSkinItems,

  WaitingFrame,
  MessageBoxFrame,
  uSkinListBoxType,

  uRestInterfaceCall,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uBaseHttpControl,

  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyLabel, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyRadioButton, uSkinFireMonkeyCheckBox, uSkinCheckBoxType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinButtonType, uSkinPanelType;

type
  TFrameAddMyBankCard = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlName: TSkinFMXPanel;
    pnlEmpty: TSkinFMXPanel;
    pnlAccount: TSkinFMXPanel;
    pnlEmpty3: TSkinFMXPanel;
    pnlEmpty4: TSkinFMXPanel;
    pnlBankName: TSkinFMXPanel;
    pnlPhoneNumber: TSkinFMXPanel;
    edtName: TSkinFMXEdit;
    edtAccountNumber: TSkinFMXEdit;
    edtPhone: TSkinFMXEdit;
    pnlRadiobutton: TSkinFMXPanel;
    btnBankNAme: TSkinFMXButton;
    chkIsDefault: TSkinFMXCheckBox;
    btnDel: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    btnOk: TSkinFMXButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure btnBankNAmeClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure chkIsDefaultClick(Sender: TObject);
  private
    FName:String;
    FAccount:String;
    FBankName:String;
    FPhone:String;
    FIs_default:Integer;
    FBankCardFID:Integer;
    FBankCard:TBankCard;
    FIsClickedChk:Boolean;

    //添加银行卡
    procedure DoAddBankCardExecute(ATimerTask:TObject);
    procedure DoAddBankCardExecuteEnd(ATimerTask:TObject);
  private
    //选择银行列表页面返回
    procedure OnReturnFrameFromSingleSelectBankName(Frame:TFrame);
    //删除银行卡页面返回
    procedure OnModalResultFromDeleteBankCard(Frame:TObject);

  private
    //修改银行卡信息
    procedure DoUpdateBankCardExecute(ATimerTask:TObject);
    procedure DoUpdateBankCardExecuteEnd(ATimerTask:TObject);

  private
    //删除银行卡
    procedure DoDelBankCardExecute(ATimerTask:TObject);
    procedure DoDelBankCardExecuteEnd(ATimerTask:TObject);

  private
    //获取银行列表
    procedure DoGetBankNameListExecute(ATimerTask:TObject);
    procedure DoGetBankNameListExecuteEnd(ATimerTask:TObject);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
    //获取虚拟键盘的高度校正
    function GetVirtualKeyboardHeightAdjustHeight:Double;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Clear;

    //添加
    procedure Add;
    //修改
    procedure Edit(ABankCard:TBankCard);
    { Public declarations }
  end;




var


  GlobalIsAddMyBankCardChanged:Boolean;
  GlobalAddMyBankCardFrame:TFrameAddMyBankCard;



implementation

{$R *.fmx}

uses
  MainForm,
  SingleSelectFrame;

procedure TFrameAddMyBankCard.Add;
begin
  Clear;

  Self.pnlToolBar.Caption:='绑定银行卡';

  Self.btnOk.Caption:='绑定';

  Self.btnDel.Visible:=False;

end;

procedure TFrameAddMyBankCard.btnBankNAmeClick(Sender: TObject);
begin
  ShowWaitingFrame(Self,'获取中...');
  uTImerTask.GetGlobalTimerThread.RunTempTask(
                                      DoGetBankNameListExecute,
                                      DoGetBankNameListExecuteEnd,
                                      'GetBankNameList');

end;

procedure TFrameAddMyBankCard.btnDelClick(Sender: TObject);
begin
  HideVirtualKeyboard;

  if FBankCard.is_default=1 then
  begin
    ShowMessageBoxFrame(Self,'您当前为默认卡，请更改默认设置!','',TMsgDlgType.mtInformation,['确定'],nil);
  end
  else
  begin
    ShowMessageBoxFrame(Self,'确定删除?','',TMsgDlgType.mtInformation,['确定','取消'],OnModalResultFromDeleteBankCard);
  end;
end;


procedure TFrameAddMyBankCard.btnOkClick(Sender: TObject);
begin
  HideVirtualKeyboard;

  if Self.edtName.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入持卡人姓名!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.edtAccountNumber.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入银行卡号!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  if Not checkBankCardNo(Self.edtAccountNumber.Text) then
  begin
    ShowMessageBoxFrame(Self,'银行卡号格式不正确!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  if Self.btnBankNAme.Caption='' then
  begin
    ShowMessageBoxFrame(Self,'请选择银行名称!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.edtPhone.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入手机号码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Not IsMobPhone(Self.edtPhone.Text) then
  begin
    ShowMessageBoxFrame(Self,'手机号码格式不正确!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  FName:=Trim(Self.edtName.Text);
  FAccount:=Trim(Self.edtAccountNumber.Text);
  FBankName:=Trim(Self.btnBankNAme.Caption);
  FPhone:=Trim(Self.edtPhone.Text);
  if Self.chkIsDefault.Prop.Checked=True then
  begin
    FIs_default:=1;
  end
  else
  begin
    FIs_default:=0;
  end;


  if FBankCardFID=0 then
  begin
    ShowWaitingFrame(Self,'添加中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                         DoAddBankCardExecute,
                                         DoAddBankCardExecuteEnd,
                                         'AddBankCard');
  end;
  if FBankCardFID<>0then
  begin
    ShowWaitingFrame(Self,'修改中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                     DoUpdateBankCardExecute,
                                     DoUpdateBankCardExecuteEnd,
                                     'UpdateBankCard');

  end;

end;

procedure TFrameAddMyBankCard.btnReturnClick(Sender: TObject);
begin
  //修改了默认状态则返回刷新
  if FIsClickedChk=Self.chkIsDefault.Prop.Checked then
  begin
    if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;
  end;

  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameAddMyBankCard.chkIsDefaultClick(Sender: TObject);
begin
  Self.chkIsDefault.Prop.Checked:=Not Self.chkIsDefault.Prop.Checked;
end;

procedure TFrameAddMyBankCard.Clear;
begin
  Self.pnlToolBar.Caption:='';
  Self.btnOk.Caption:='';

  FBankCardFID:=0;
  FName:='';
  FAccount:='';
  FBankName:='';
  FPhone:='';
  FIs_default:=0;
  Self.edtName.Text:='';
  Self.edtAccountNumber.Text:='';
  Self.btnBankNAme.Caption:='';
  Self.edtPhone.Text:='';

  //恢复可编辑状态
  Self.btnOk.Visible:=True;
  Self.edtName.HitTest:=True;
  Self.edtAccountNumber.HitTest:=True;
  Self.btnBankNAme.HitTest:=True;
  Self.edtPhone.HitTest:=True;
  //右箭头显示
  Self.btnBankNAme.Prop.IsPushed:=False;

  // 没有银行卡则设置为默认
  if GlobalManager.UserBankCardList.Count>0 then
  begin
    Self.chkIsDefault.Prop.Checked:=False;
    Self.chkIsDefault.HitTest:=True;
  end
  else
  begin
    Self.chkIsDefault.Prop.Checked:=True;
    Self.chkIsDefault.HitTest:=False;
  end;

end;

constructor TFrameAddMyBankCard.Create(AOwner: TComponent);
begin
  inherited;
//  FBankCard:=TBankCard.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

end;

destructor TFrameAddMyBankCard.Destroy;
begin
//  FreeAndNil(FBankCard);

  inherited;
end;

procedure TFrameAddMyBankCard.DoAddBankCardExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('add_user_bankcard',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'user_bankcard_account',
                                                    'user_bankcard_name',
                                                    'user_bankcard_type',
                                                    'is_default'],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    FAccount,
                                                    FName,
                                                    FBankName,
                                                    FIs_default
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

procedure TFrameAddMyBankCard.DoAddBankCardExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //返回并刷新我的银行卡列表

        HideFrame;//(Self,hfcttBeforeReturnFrame);
        ReturnFrame;//(Self.FrameHistroy);
      end
      else
      begin
        //添加失败
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

procedure TFrameAddMyBankCard.DoDelBankCardExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('del_user_bankcard_info',
                                                      nil,
                                                      UserCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'bankcard_fid'
                                                      ],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FBankCardFID
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

procedure TFrameAddMyBankCard.DoDelBankCardExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //返回并刷新我的银行卡列表


        HideFrame;//(Self,hfcttBeforeReturnFrame);
        ReturnFrame;//(Self.FrameHistroy);

//        HideFrame;//(Self,hfcttBeforeShowFrame);
//        ShowFrame(TFrame(GlobalMyBankCardFrame),TFrameMyBankCard,frmMain,nil,nil,nil,Application);
//        GlobalMyBankCardFrame.FrameHistroy:=CurrentFrameHistroy;
//
//        GlobalMyBankCardFrame.Load;


      end
      else
      begin
        //删除失败
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


procedure TFrameAddMyBankCard.DoUpdateBankCardExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('change_user_bankcard',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'user_fid',
                                                    'key',
                                                    'bankcard_fid',
                                                    'user_bankcard_account',
                                                    'user_bankcard_name',
                                                    'user_bankcard_type',
                                                    'is_default'
                                                    ],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    FBankCardFID,
                                                    FAccount,
                                                    FName,
                                                    FBankName,
                                                    FIs_default
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
procedure TFrameAddMyBankCard.DoUpdateBankCardExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //返回并刷新我的银行卡列表

        HideFrame;//(Self,hfcttBeforeReturnFrame);
        ReturnFrame;//(Self.FrameHistroy);
      end
      else
      begin
        //添加失败
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

procedure TFrameAddMyBankCard.DoGetBankNameListExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_bank_list',
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


procedure TFrameAddMyBankCard.DoGetBankNameListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I:Integer;
  AStringList:TStringList;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          AStringList:=TStringList.Create;
          try
            for I := 0 to ASuperObject.O['Data'].A['BankList'].Length-1 do
            begin
              AStringList.Add(ASuperObject.O['Data'].A['BankList'].O[I].S['name']);
            end;

            //选择银行
            HideFrame;//(Self,hfcttBeforeShowFrame);
            ShowFrame(TFrame(GlobalSingleSelectFrame),TFrameSingleSelect,frmMain,nil,nil,OnReturnFrameFromSingleSelectBankName,Application);
//            GlobalSingleSelectFrame.FrameHistroy:=CurrentFrameHistroy;
            GlobalSingleSelectFrame.Init('请选择银行名称',AStringList,'');

          finally
            FreeAndNil(AStringList);
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


function TFrameAddMyBankCard.GetCurrentPorcessControl(
  AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameAddMyBankCard.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

function TFrameAddMyBankCard.GetVirtualKeyboardHeightAdjustHeight: Double;
begin
  Result:=0;
end;

procedure TFrameAddMyBankCard.Edit(ABankCard: TBankCard);
begin

  Clear;

  Self.pnlToolBar.Caption:='银行卡信息';

  Self.btnOk.Caption:='确定';

  Self.btnDel.Visible:=True;

  FBankCard:=ABankCard;

  FBankCardFID:=ABankCard.fid;
  FName:=ABankCard.name;
  FBankName:=ABankCard.bankname;
  FAccount:=ABankCard.account;
  FIs_default:=ABankCard.is_default;


  Self.edtName.Text:=ABankCard.name;
  Self.edtAccountNumber.Text:=ABankCard.account;
  Self.edtPhone.Text:=GlobalManager.User.phone;
  Self.btnBankNAme.Caption:=ABankCard.bankname;

  //银行卡信息编辑
  Self.btnOk.Visible:=True;
//  Self.edtName.HitTest:=False;
//  Self.edtAccountNumber.HitTest:=False;
//  Self.btnBankNAme.HitTest:=False;
//  Self.edtPhone.HitTest:=False;
  //右箭头不显示
  Self.btnBankNAme.Prop.IsPushed:=True;

  //默认银行卡不可删除 不可编辑状态
  if ABankCard.is_default =1 then
  begin
    Self.chkIsDefault.Prop.Checked:=True;
    Self.btnDel.Visible:=False;
//    Self.chkIsDefault.HitTest:=False;
  end
  else
  begin
    Self.chkIsDefault.Prop.Checked:=False;
    Self.btnDel.Visible:=True;
//    Self.chkIsDefault.HitTest:=True;
  end;

  //记下初始是否选中
  FIsClickedChk:=Self.chkIsDefault.Prop.Checked;

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;

procedure TFrameAddMyBankCard.OnModalResultFromDeleteBankCard(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='确定' then
  begin
    FBankCardFID:=FBankCard.fid;
    FIs_default:=FBankCard.is_default;

    ShowWaitingFrame(Self,'删除中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                    DoDelBankCardExecute,
                                    DoDelBankCardExecuteEnd,
                                    'DelBankCard');

  end;
  if TFrameMessageBox(Frame).ModalResult='取消' then
  begin
    //留在银行卡信息页面
  end;
end;

procedure TFrameAddMyBankCard.OnReturnFrameFromSingleSelectBankName(
  Frame: TFrame);
begin
  FBankName:=GlobalSingleSelectFrame.Selected;
  Self.btnBankNAme.Caption:=GlobalSingleSelectFrame.Selected;
end;

end.


