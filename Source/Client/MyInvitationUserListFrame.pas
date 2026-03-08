unit MyInvitationUserListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  FastMsgCommonSkinMaterialFrame,
  EasyServiceCommonMaterialDataMoudle,
  uUIFunction,
  WaitingFrame,
  uLang,StrUtils,

  ListItemStyleFrame_SimpleContact,
  ListItemStyleFrame_SimpleInvitation,
  ListItemStyleFrame_IconCaptionMultiColor,

  FastMsg.Client.OEM,
  FastMsg.Client.Common,
  FastMsg.Client.BindingEvents,
  FastMsg.Client.Contacts,
  FastMsg.Client.Groups,

  {$IFDEF HAS_IM_DEPARTMENT}
  FastMsg.Client.Departments,
  {$ENDIF}

//  FastMsg.Client.CommonClass,
  FastMsg.Client,
//  FastMsg.Client.MsgBox,
  uIMClientCommon,

  uTimerTask,
  uRestInterfaceCall,
  uManager,
  uOpenCommon,
  XSuperObject,
  uOpenClientCommon,
  uBaseList,
  uSkinItemJsonHelper,
  MessageBoxFrame,

  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uDrawCanvas, uSkinItems, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinFireMonkeyListBox,
  uSkinFireMonkeyComboBox, uSkinFireMonkeyEdit, uSkinButtonType,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinPanelType,
  uSkinFireMonkeyPanel, FMX.ListBox, FMX.Edit, FMX.Controls.Presentation,
  uFrameContext, uTimerTaskEvent, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinImageType, uSkinFireMonkeyImage;

type
  TFrameMyInvitationUserList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbUserSearchResult: TSkinFMXListBox;
    ItemFooter: TSkinFMXItemDesignerPanel;
    btnLoadMore: TSkinFMXButton;
    btnCancel: TSkinFMXButton;
    tteGetData: TTimerTaskEvent;
    imgBackground: TSkinFMXImage;
    btnReturn: TSkinFMXButton;
    lblTop: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure tteGetDataBegin(ATimerTask: TTimerTask);
    procedure tteGetDataExecute(ATimerTask: TTimerTask);
    procedure tteGetDataExecuteEnd(ATimerTask: TTimerTask);
    procedure lbUserSearchResultClickItem(AItem: TSkinItem);
  private
    FPageIndex:Integer;
    AScore:Double;
    { Private declarations }
  public
    procedure ClearContacts;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Load;
    { Public declarations }
  end;

var
  GlobalMyInvitationUserListFrame:TFrameMyInvitationUserList;

implementation

{$R *.fmx}

uses
  MainForm,
  GetUserInfoFrame,
  MyInvitationCodeFrame,
  MainFrame;

constructor TFrameMyInvitationUserList.Create(AOwner: TComponent);
begin
  inherited;
  Self.lbUserSearchResult.Prop.Items.BeginUpdate;
  try
    Self.lbUserSearchResult.Prop.Items.ClearItemsByType(sitDefault);
    Self.lbUserSearchResult.Prop.Items.ClearItemsByType(sitItem1);
  finally
    Self.lbUserSearchResult.Prop.Items.EndUpdate;
  end;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

procedure TFrameMyInvitationUserList.Load;
begin
  //先清空
  ClearContacts;
  //再加载
  FPageIndex:=1;
  AScore:=GlobalMyInvitationCodeFrame.FScore;
  Self.tteGetData.Run();
end;

procedure TFrameMyInvitationUserList.ClearContacts;
var
  I: Integer;
begin
  Self.lbUserSearchResult.Prop.Items.BeginUpdate;
  try
    for I := 0 to Self.lbUserSearchResult.Prop.Items.Count-1 do
    begin
      if Self.lbUserSearchResult.Prop.Items[I].Data<>nil then
      begin
//        AObject:=TObject(Self.lbUserSearchResult.Prop.Items[I].Data);
        Self.lbUserSearchResult.Prop.Items[I].Data:=nil;
      end;
    end;
    Self.lbUserSearchResult.Prop.Items.ClearItemsByType(sitDefault);
  finally
    Self.lbUserSearchResult.Prop.Items.EndUpdate();
  end;
end;

procedure TFrameMyInvitationUserList.tteGetDataBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(nil,Trans('加载中...'));
end;

procedure TFrameMyInvitationUserList.tteGetDataExecute(ATimerTask: TTimerTask);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_invite_user_list',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'emp_fid',
                                                    'key',
                                                    'pageindex',
                                                    'pagesize'
                                                    ],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    FPageIndex,
                                                    20],
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

procedure TFrameMyInvitationUserList.tteGetDataExecuteEnd(ATimerTask: TTimerTask);
var
  I,Num:Integer;
  ASuperObject:ISuperObject;
  AUserJson:ISuperObject;
  ASkinItem:TSkinItem;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          Self.lbUserSearchResult.Prop.Items.BeginUpdate();
          try

              if Self.FPageIndex=1 then
              begin
                Self.lbUserSearchResult.Prop.Items.ClearItemsByType(sitFooter);
                Self.lbUserSearchResult.Prop.Items.ClearItemsByType(sitItem1);
                //Self.lbUserSearchResult.Prop.Items.FindItemByType(sitItem2).Visible:=False;
              end;

              //已邀请人数和奖励积分
              Num:=ASuperObject.O['Data'].I['Counts'];
              Self.lblTop.Caption:='已邀请 ' + IntToStr(Num) + ' 个好友，奖励 ' + FloatToStr(Num*AScore) + ' 积分！';

              for I := 0 to ASuperObject.O['Data'].A['InviteUserList'].Length-1 do
              begin
                AUserJson:=ASuperObject.O['Data'].A['InviteUserList'].O[I];

                ASkinItem:=Self.lbUserSearchResult.Prop.Items.Add;
                ASkinItem.Json:=AUserJson;

                //标题
                ASkinItem.Caption:=AUserJson.S['name'];
                ASkinItem.Detail:=LeftStr(AUserJson.S['phone'],3) + '****' + RightStr(AUserJson.S['phone'],3);
                ASkinItem.Detail1:=AUserJson.S['createtime'];

                ASkinItem.Icon.Url:=GetImageUrl(AUserJson.S['head_pic_path'],itUserHead);
              end;

              //最后加上加载
              if Num<>0 then
              begin
                ASkinItem:=Self.lbUserSearchResult.Prop.Items.Add;
                ASkinItem.Caption:='加载更多';
                ASkinItem.ItemType:=sitFooter;
                ASkinItem.Height:=50;
              end;

          finally
            Self.lbUserSearchResult.Prop.Items.EndUpdate();
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

    if FPageIndex>1 then
    begin
        //加载更多
        if (TTimerTask(ATimerTask).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['NoticeList'].Length>0) then
        begin
          Self.lbUserSearchResult.Prop.StopPullUpLoadMore('加载成功!',0,True);
        end
        else
        begin
          //先把原来的按钮删除了
          Self.lbUserSearchResult.Prop.Items.ClearItemsByType(sitFooter);
          //在最后加上加载
          ASkinItem:=Self.lbUserSearchResult.Prop.Items.Add;
          ASkinItem.Caption:='加载更多';
          ASkinItem.ItemType:=sitFooter;
          ASkinItem.Height:=50;

          Self.lbUserSearchResult.Prop.StopPullUpLoadMore('下面没有了!',600,False);
        end;
    end
    else
    begin
      //刷新
      Self.lbUserSearchResult.Prop.StopPullDownRefresh('刷新成功!',600);
    end;

  end;

end;

procedure TFrameMyInvitationUserList.lbUserSearchResultClickItem(
  AItem: TSkinItem);
begin
  if AItem.Caption='加载更多' then
  begin
    FPageIndex:=FPageIndex+1;
    Self.tteGetData.Run();
    //ShowMessage('666');
  end;
end;

//返回上一页
procedure TFrameMyInvitationUserList.btnReturnClick(Sender: TObject);
begin
  HideFrame;
  ReturnFrame();
end;

destructor TFrameMyInvitationUserList.Destroy;
begin
  inherited;
end;

end.
