unit BlackListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,

  uUIFunction,

  {$IFDEF HAS_FASTMSG}
  FastMsg.Client,
  FastMsg.Client.Protocol,
  uIMClientCommon,
  FastMsg.Client.Contacts,
  {$ENDIF}
  HintFrame,
  WaitingFrame,
  MessageBoxFrame,
  uLang,
  uTimerTask,
  uRestInterfaceCall,
  uOpenClientCommon,
  uManager,
  uOpenCommon,
  XSuperObject,

  uSkinPanelType, uSkinFireMonkeyPanel, uDrawCanvas, uSkinItems, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinListViewType,
  uSkinFireMonkeyListView, uTimerTaskEvent;

type
  TBlackList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnSearch: TSkinFMXButton;
    btnAdd: TSkinFMXButton;
    btnTitle: TSkinFMXButton;
    btnReturn: TSkinFMXButton;
    lbContact: TSkinFMXListBox;
    idpItemPanDrag: TSkinFMXItemDesignerPanel;
    btnDelete: TSkinFMXButton;
    tteCancelShieldUser: TTimerTaskEvent;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure tteCancelShieldUserBegin(ATimerTask: TTimerTask);
    procedure tteCancelShieldUserExecute(ATimerTask: TTimerTask);
    procedure tteCancelShieldUserExecuteEnd(ATimerTask: TTimerTask);
  private
    { Private declarations }
  public
    FUserFID:String;
    FFastMsgUserId:Integer;
    FIsShield:Boolean;
    constructor Create(AOwner:TComponent);override;
    procedure Load;
    { Public declarations }
  end;

var
  GlobalBlackListFrame: TBlackList;

implementation

{$R *.fmx}

constructor TBlackList.Create(AOwner: TComponent);
begin
  inherited;

  Self.lbContact.Prop.Items.BeginUpdate;
  try

//    Self.lbContact.Prop.Items.FindItemByType(sitItem1).Visible:=False;

    Self.lbContact.Prop.Items.ClearItemsByType(sitDefault);
  finally
    Self.lbContact.Prop.Items.EndUpdate;
  end;

//  InstallBindingEvents;
  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

procedure TBlackList.Load;
var
  I, J: Integer;
  ASkinItem:TSkinItem;
begin
  try

    Self.lbContact.Prop.Items.Clear(True);

    {$IFDEF HAS_FASTMSG}
    //获取黑名单列表
    for I := 0 to GlobalClient.ContactManager.ContactGroups.Count-1 do
    begin
      if GlobalClient.ContactManager.ContactGroups[I].ContactGroupId = CONTACTGROUPID_BLACKLIST then
      begin
        for J := 0 to GlobalClient.ContactManager.ContactGroups[I].ContactList.Count-1 do
        begin
          ASkinItem:=Self.lbContact.Prop.Items.Add;
          LoadContactToSkinItem(GlobalClient.ContactManager.ContactGroups[I].ContactList[J],ASkinItem);
        end;
      end;
    end;
    {$ENDIF}

  finally
    Self.lbContact.Prop.Items.EndUpdate;

    //FreeAndNil(AContactList);
  end;

end;

procedure TBlackList.tteCancelShieldUserBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,Trans('处理中...'));
end;

procedure TBlackList.tteCancelShieldUserExecute(ATimerTask: TTimerTask);
begin
  try
      //出错
      TTimerTask(ATimerTask).TaskTag:=1;

      TTimerTask(ATimerTask).TaskDesc:=

      SimpleCallAPI('del_record',
                    nil,
                    TableRestCenterInterfaceUrl,
                    ['appid',
                    'user_fid',
                    'key',
                    'rest_name',
                    'where_key_json'
                    ],
                    [AppID,
                    GlobalManager.User.fid,
                    '',
                    'shield_user',
                    GetWhereConditions(['appid','user_fid','shield_user_fid'],
                                        [AppID,GlobalManager.User.fid,FUserFID])
                    ],
                                        GlobalRestAPISignType,
                                        GlobalRestAPIAppSecret
                    );

      TTimerTask(ATimerTask).TaskTag:=0;
  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;

end;

procedure TBlackList.tteCancelShieldUserExecuteEnd(ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          {$IFDEF HAS_FASTMSG}
          GlobalClient.ContactManager.MoveContact(Self.FFastMsgUserId,CONTACTGROUPID_MYCONTACTS);
          {$ENDIF}

          //取消屏蔽成功
          ShowHintFrame(nil,Trans('取消屏蔽成功!'));

          Self.FIsShield:=False;

          //Self.SyncButtonState;

      end
      else
      begin
          //生成失败
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

procedure TBlackList.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;
  ReturnFrame;
end;

//从黑名单移出
procedure TBlackList.btnDeleteClick(Sender: TObject);
begin
  if Self.lbContact.Prop.InteractiveItem<>nil then
  begin
    {$IFDEF HAS_FASTMSG}
    Self.FFastMsgUserId:=TContact(Self.lbContact.Prop.InteractiveItem.Data).UserId;
    {$ENDIF}
    Self.tteCancelShieldUser.Run;
    //从列表移除
    Self.lbContact.Prop.Items.Remove(Self.lbContact.Prop.InteractiveItem);
    //刷新
    //Self.Load;
  end;
end;

end.
