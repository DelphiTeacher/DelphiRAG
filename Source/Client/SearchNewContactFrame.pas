unit SearchNewContactFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 

//  ContactInfoFrame,
  FastMsgCommonSkinMaterialFrame,
  EasyServiceCommonMaterialDataMoudle,
  uUIFunction,
  WaitingFrame,
  uLang,
//  OrangeUI.SkinItems,
//  OrangeUI.SkinListBoxType,

  ListItemStyleFrame_SimpleContact,
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
  uFrameContext, uTimerTaskEvent, uSkinLabelType, uSkinFireMonkeyLabel;

type
  TFrameSearchNewContact = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlKeyword: TSkinFMXPanel;
    edtKeyword: TSkinFMXEdit;
    ClearEditButton1: TClearEditButton;
    btnSearch: TSkinFMXButton;
    pnlSearchType: TSkinFMXPanel;
    cmbSearchType: TSkinFMXComboBox;
    lbUserSearchResult: TSkinFMXListBox;
    ItemFooter: TSkinFMXItemDesignerPanel;
    btnLoadMore: TSkinFMXButton;
    btnCancel: TSkinFMXButton;
    FrameContext1: TFrameContext;
    tteGetData: TTimerTaskEvent;
    SkinFMXPanel1: TSkinFMXPanel;
    lblFastmsgUserId: TSkinFMXLabel;
    procedure btnSearchClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure btnLoadMoreClick(Sender: TObject);
    procedure lbUserSearchResultClickItem(Sender: TSkinItem);
    procedure edtKeywordChangeTracking(Sender: TObject);
    procedure FrameContext1ShowEx(Sender: TObject; AIsReturnShow: Boolean);
    procedure tteGetDataExecute(ATimerTask: TTimerTask);
    procedure tteGetDataExecuteEnd(ATimerTask: TTimerTask);
    procedure tteGetDataBegin(ATimerTask: TTimerTask);
  private
    FPageIndex:Integer;
//    FSearchResult_PageIndex_Contacts: Integer;
//    FSearchResult_PageIndex_Groups: Integer;
//
//    FOnCleint_OnSearchUsersResult: TBindingEvent;
//    FOnCleint_OnSearchGroupsResult: TBindingEvent;
//
//    procedure OnCleint_OnSearchUsersResultExecute(Sender: TBindingEvent);
//    procedure OnCleint_OnSearchGroupsResultExecute(Sender: TBindingEvent);
//
//    //安装绑定事件
//    procedure InstallBindingEvents;
//    //卸载绑定事件
//    procedure UnInstallBindingEvents;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
//    procedure SearchContacts(APageIndex:Integer);
    procedure ClearContacts;

    procedure LoadData;
//    procedure UnLoadData;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure DoFilter;
    { Public declarations }
  end;


var
  GlobalSearchNewContactFrame:TFrameSearchNewContact;


//const
//  MAX_PAGE_SIZE = 15;//5;//


implementation

{$R *.fmx}

uses
  MainForm,
  GetUserInfoFrame,
  MainFrame;

//procedure TFrameSearchNewContact.InstallBindingEvents;
//begin
////  FOnCleint_OnSearchUsersResult := TBindingEvent.Create(nil,'Client:OnSearchUsers_Result',True,OnCleint_OnSearchUsersResultExecute);
////  FOnCleint_OnSearchGroupsResult := TBindingEvent.Create(nil,'Client:OnSearchGroups_Result',True,OnCleint_OnSearchGroupsResultExecute);
//  UIBindingEvents.RegEvent(Self,'Client:OnSearchUsers_Result',OnCleint_OnSearchUsersResultExecute,True);
//  UIBindingEvents.RegEvent(Self,'Client:OnSearchGroups_Result',OnCleint_OnSearchGroupsResultExecute,True);
//end;

procedure TFrameSearchNewContact.lbUserSearchResultClickItem(Sender: TSkinItem);
begin
  if TSkinItem(Sender).ItemType=sitItem2 then
  begin
        //搜索,显示搜索到的好友列表
  //      Self.btnSearchClick(nil);
        FPageIndex:=1;
        Self.tteGetData.Run();
  end;
  if TSkinItem(Sender).ItemType=sitDefault then
  begin
//      HideFrame;//(Self);
//      //查看好友信息资料
//      ShowFrame(TFrame(GlobalContactInfoFrame),TFrameContactInfo,frmMain,nil,nil,nil,Application);
//  //    GlobalContactInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//      GlobalContactInfoFrame.Load(TContact(TSkinItem(Sender).Data));

        //个人信息页面
        HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrameet);
        ShowFrame(TFrame(GlobalGetUserInfoFrame),TFrameGetUserInfo,frmMain,nil,nil,nil,Application);
  //      GlobalUserInfoFrame.FrameHistroy:=CurrentFrameHistroy;
        GlobalGetUserInfoFrame.Clear;
        GlobalGetUserInfoFrame.Load(Sender.Json.V['fid'],
                                    Sender.Json.S['name'],
                                    Sender.Json.S['head_pic_path'],
                                    Sender.Json.S['province'],
                                    Sender.Json.S['city'],
                                    Sender.Json.I['fastmsg_user_id'],
                                    Sender.Json.I['is_vip']
                                    );
    //    GlobalUserInfoFrame.UserInfo;

  end;
end;

procedure TFrameSearchNewContact.LoadData;
begin
//  InstallBindingEvents;

  Self.edtKeyword.Text:='';
//  Self.cmbSearchType.ItemIndex:=0;

  //
  lblFastmsgUserId.Caption:=
    Trans('我的聊天帐号')+':'+IntToStr(GlobalClient.CurrentUser.UserId);


  DoFilter;
end;

//procedure TFrameSearchNewContact.UnInstallBindingEvents;
//begin
////  FreeAndNil(FOnCleint_OnSearchUsersResult);
////  FreeAndNil(FOnCleint_OnSearchGroupsResult);
//  UIBindingEvents.UnRegEvent(Self,OnCleint_OnSearchUsersResultExecute);
//  UIBindingEvents.UnRegEvent(Self,OnCleint_OnSearchGroupsResultExecute);
//end;
//
//procedure TFrameSearchNewContact.UnLoadData;
//begin
//  ClearContacts;
//
//  UnInstallBindingEvents;
//end;
//
//procedure TFrameSearchNewContact.OnCleint_OnSearchGroupsResultExecute(Sender: TBindingEvent);
//var
//  i: Integer;
////  objZone: TZone;
////  objZoneList: TZoneList;
//  objGroup: TGroup;
//  lSearchResultCount: Integer;
//begin
//  lSearchResultCount := GlobalClient.Search.GroupsResultList.Count;
//
////  if lSearchResultCount > 0 then
////    lblGroups_SearchResult.Caption := '以下是查找到的群组:'
////  else
////    lblGroups_SearchResult.Caption := '没有找到！';
////  lblCurPageInfo_Groups.Caption := '当前第' + IntToStr(FSearchResult_PageIndex_Groups) + '页,共搜索到'+IntToStr(lSearchResultCount)+'个';
////
////  lblPrevPage_Groups.Enabled := FSearchResult_PageIndex_Groups > 1;
////  lblNextPage_Groups.Enabled := lSearchResultCount >= MAX_PAGE_SIZE;
////
////  zvGroups.BeginUpdate();
////  objZoneList := zvGroups.LockZoneList();
////  try
////    objZoneList.Clear();
////
////    for i := 0 to FastMsgClient.Search.GroupsResultList.Count - 1 do
////    begin
////      objGroup := TGroup(FastMsgClient.Search.GroupsResultList.Items[i]);
////
////      objZone := objZoneList.Add();
////      objZone.Height := 56;
////      objZone.Data := objGroup;
////    end;
////  finally
////    zvGroups.UnLockZoneList();
////    zvGroups.EndUpdate();
////  end;
//  HideWaitingFrame;
//end;
//
//procedure TFrameSearch.OnCleint_OnSearchOrgansResultExecute(Sender: TObject);
//var
//  i: Integer;
////  objZone: TZone;
////  objZoneList: TZoneList;
////  objOrgan: TOrgan;
//  lSearchResultCount: Integer;
//begin
//  lSearchResultCount := FastMsgClient.Search.OrgansResultList.Count;
//
//  if lSearchResultCount > 0 then
//    lblOrgans_SearchResult.Caption := '以下是查找到的组织机构:'
//  else
//    lblOrgans_SearchResult.Caption := '没有找到！';
//  lblCurPageInfo_Organs.Caption := '当前第' + IntToStr(FSearchResult_PageIndex_Organs) + '页,共搜索到'+IntToStr(lSearchResultCount)+'个';
//
//  lblPrevPage_Organs.Enabled := FSearchResult_PageIndex_Organs > 1;
//  lblNextPage_Organs.Enabled := lSearchResultCount >= MAX_PAGE_SIZE;
//
//  zvOrgans.BeginUpdate();
//  objZoneList := zvOrgans.LockZoneList();
//  try
//    objZoneList.Clear();
//
//    for i := 0 to FastMsgClient.Search.OrgansResultList.Count - 1 do
//    begin
//      objOrgan := TOrgan(FastMsgClient.Search.OrgansResultList.Items[i]);
//
//      objZone := objZoneList.Add();
//      objZone.Height := 56;
//      objZone.Data := objOrgan;
//    end;
//  finally
//    zvOrgans.UnLockZoneList();
//    zvOrgans.EndUpdate();
//  end;
//end;
//
//procedure TFrameSearchNewContact.OnCleint_OnSearchUsersResultExecute(Sender: TBindingEvent);
//var
//  i: Integer;
////  objZone: TSkinListBoxItem;
////  objZoneList: TZoneList;
////  objContact: TContact;
//  lSearchResultCount: Integer;
//begin
//  lSearchResultCount := GlobalClient.Search.UsersResultList.Count;
//
////  if lSearchResultCount > 0 then
////    lblContacts_SearchResult.Caption := '以下是查找到的联系人:'
////  else
////    lblContacts_SearchResult.Caption := '没有找到！';
////
////  lblCurPageInfo_Contacts.Caption := '当前第' + IntToStr(FSearchResult_PageIndex_Contacts) + '页,共搜索到'+IntToStr(lSearchResultCount)+'个';
////
////  lblPrevPage_Contacts.Enabled := FSearchResult_PageIndex_Contacts > 1;
////  lblNextPage_Contacts.Enabled := lSearchResultCount >= MAX_PAGE_SIZE;
////  lblNextPage_Contacts.Enabled := lSearchResultCount >= MAX_PAGE_SIZE;
//
//  Self.lbUserSearchResult.Prop.Items.BeginUpdate();
//  try
//
//    Self.lbUserSearchResult.Prop.Items.ClearItemsByType(sitFooter);
//    Self.lbUserSearchResult.Prop.Items.ClearItemsByType(sitItem1);
//    Self.lbUserSearchResult.Prop.Items.FindItemByType(sitItem2).Visible:=False;
//
//    for i := 0 to GlobalClient.Search.UsersResultList.Count - 1 do
//    begin
//      LoadContactToSkinItem(TContact(GlobalClient.Search.UsersResultList.Items[i]),
//                            Self.lbUserSearchResult.Prop.Items.Add());
//    end;
//
////    if lSearchResultCount >= MAX_PAGE_SIZE then
////    begin
////      //要显示加载更多
////      Self.lbUserSearchResult.Prop.Items.Add.ItemType:=sitFooter;
////    end
////    else
////    begin
//////      //没有更多
//////      Self.lbUserSearchResult.Prop.Items.Add.ItemType:=sitItem1;
////    end;
//
//  finally
//    Self.lbUserSearchResult.Prop.Items.EndUpdate();
//  end;
//
//  HideWaitingFrame;
//end;
//
//
//procedure TFrameSearchNewContact.SearchContacts(APageIndex:Integer);
////var
////  param_userid: Integer;
////  param_username: String;
////  param_nickname: String;
////  param_actualname: String;
////  param_country: SmallInt;
////  param_province: SmallInt;
////  param_city: SmallInt;
////  param_area: SmallInt;
////  param_sex: SmallInt;
////  param_age: SmallInt;
////  param_online: SmallInt;
////  pagesize: Integer;
////  pageindex: Integer;
//begin
//  Self.tteGetData.Run();
////  ShowWaitingFrame(Self,'正在查找...');
////
////  FSearchResult_PageIndex_Contacts := APageIndex;
////
//////  //搜索
//////  lblContacts_SearchResult.Caption := '正在查找...';
////
////  param_userid := -1;
////  param_username:='';
////  param_nickname := '';
////  param_actualname := '';
////  param_country := -1;
////  param_province := -1;
////  param_city := -1;
////  param_area := -1;
////  param_sex := -1;
////  param_age := -1;
////  param_online := -1;
////  pagesize := MAX_PAGE_SIZE;
////  pageindex := FSearchResult_PageIndex_Contacts;
////
////
////
////  //按用户ID查找
////  //按用户名查找
////  //按昵称查找
////  //按真实姓名查找
////  //按条件查找
//////  if Self.cmbSearchType.GetText='按用户ID查找' then
//////  begin
////    Param_UserId:=-1;
////    TryStrToInt(Trim(Self.edtKeyword.Text),Param_UserId);
//////  end
//////  else if Self.cmbSearchType.GetText='按用户名查找' then
//////  begin
//////    param_username := Trim(edtKeyword.Text);
//////  end
//////  else if Self.cmbSearchType.GetText='按昵称查找' then
//////  begin
//////    Param_NickName := Trim(edtKeyword.Text);
//////  end
//////  else if Self.cmbSearchType.GetText='按真实姓名查找' then
//////  begin
//////    param_actualname := Trim(edtKeyword.Text);
//////  end
//////  else if btnByWhere.Checked then
//////  begin
//////    if cbProvince.ItemIndex > 0 then Param_Province := cbProvince.ItemIndex;
//////    if cbCity.ItemIndex > 0 then Param_City := cbCity.ItemIndex;
//////    if cbArea.ItemIndex > 0 then Param_Area := cbArea.ItemIndex;
//////    if cbSex.ItemIndex > 0 then Param_Sex := cbSex.ItemIndex;
//////    if cbAge.ItemIndex > 0 then Param_Age := cbAge.ItemIndex;
//////
//////    if chkOnline.Checked then Param_Online := 1;
//////  end
//////  ;
////
////  GlobalClient.Search.SearchUsers(
////                                        param_userid,
////                                        param_username,
////                                        param_nickname,
////                      //                  param_actualname,
////                                        '',
////                                        '',
////                      //                  '',
////                      //                  param_country,
////                      //                  param_province,
////                      //                  param_city,
////                      //                  param_area,
////                                        param_sex,
////                      //                  param_age,
////                                        param_online,
////                                        pagesize,
////                                        pageindex);
////
//end;

procedure TFrameSearchNewContact.tteGetDataBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(nil,Trans('加载中...'));
end;

procedure TFrameSearchNewContact.tteGetDataExecute(ATimerTask: TTimerTask);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_user_list',
                                                    nil,
                                                    UserCenterInterfaceUrl,
                                                    ['appid',
                                                    'emp_fid',
                                                    'key',
                                                    'filter_fastmsg_user_account',
                                                    'pageindex',
                                                    'pagesize'
                                                    ],
                                                    [AppID,
                                                    GlobalManager.User.fid,
                                                    GlobalManager.User.key,
                                                    Self.edtKeyword.Text,//FastmsgUserId
                                                    FPageIndex,
                                                    10],
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

procedure TFrameSearchNewContact.tteGetDataExecuteEnd(ATimerTask: TTimerTask);
var
  I:Integer;
  ASuperObject:ISuperObject;
  AUserJson:ISuperObject;
//  ANoticeList:TNoticeList;
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
                Self.lbUserSearchResult.Prop.Items.FindItemByType(sitItem2).Visible:=False;
              end;

              for I := 0 to ASuperObject.O['Data'].A['UserList'].Length-1 do
              begin
                AUserJson:=ASuperObject.O['Data'].A['UserList'].O[I];

                ASkinItem:=Self.lbUserSearchResult.Prop.Items.Add;
                ASkinItem.Json:=AUserJson;
  //              ASkinItem.Data:=AContact;

                //标题
                ASkinItem.Caption:=AUserJson.S['name'];//True);
  //              ASkinItem.Detail:=''//'['+GetOtherUserLoginStatusString(AContact.LoginStatus_Android)+']'
  //                                +AContact.Introduction;
                ASkinItem.Tag:=AUserJson.I['fastmsg_user_id'];
              //  ASkinItem.IconRefPicture:=GetOtherUserHeadPicture(AContact);
              //  ASkinItem.Icon.RefPicture:=GetOtherUserHeadPicture(AContact);
                ASkinItem.Icon.Url:=GetImageUrl(AUserJson.S['head_pic_path'],itUserHead);

  //              SetContactHeadPicture(AContact,ASkinItem.Icon);


              end;



  //            for i := 0 to GlobalClient.Search.UsersResultList.Count - 1 do
  //            begin
  //              LoadContactToSkinItem(TContact(GlobalClient.Search.UsersResultList.Items[i]),
  //                                    Self.lbUserSearchResult.Prop.Items.Add());
  //            end;

              //    if lSearchResultCount >= MAX_PAGE_SIZE then
              //    begin
              //      //要显示加载更多
              //      Self.lbUserSearchResult.Prop.Items.Add.ItemType:=sitFooter;
              //    end
              //    else
              //    begin
              ////      //没有更多
              ////      Self.lbUserSearchResult.Prop.Items.Add.ItemType:=sitItem1;
              //    end;

          finally
            Self.lbUserSearchResult.Prop.Items.EndUpdate();
          end;

//          ANoticeList:=TNoticeList.Create(ooReference);
//          ANoticeList.ParseFromJsonArray(TNotice,ASuperObject.O['Data'].A['NoticeList']);
//
//          Self.lbNoticeList.Prop.Items.BeginUpdate;
//          try
//            if FPageIndex=1 then
//            begin
//              Self.lbNoticeList.Prop.Items.ClearItemsByType(sitDefault);
//              Self.lbNoticeList.Prop.Items.ClearItemsByType(sitItem1);
//              FNoticeList.Clear(True);
//            end;
//
//            for I := 0 to ANoticeList.Count-1 do
//            begin
//
//              FNoticeList.Add(ANoticeList[I]);
//
//              AListBoxItem:=Self.lbNoticeList.Prop.Items.Add;
//              if ANoticeList[I].notice_classify='system' then
//              begin
//                AListBoxItem.ItemType:=sitItem1;
//
//                Self.chkItemSelected.Visible:=False;
//                Self.btnEdit.Visible:=False;
//              end
//              else
//              begin
//                AListBoxItem.ItemType:=sitDefault;
//
//                Self.chkItemSelected.Visible:=True;
//                Self.btnEdit.Visible:=True;
//                //非编辑状态下不显示checkBox
//                if Self.btnEdit.Caption='编辑' then
//                begin
//                  Self.chkOrderItemSelected.Visible:=False;
//                end
//                else
//                begin
//                  Self.chkOrderItemSelected.Visible:=True;
//                end;
//              end;
//
//              AListBoxItem.Data:=ANoticeList[I];
//
//              AListBoxItem.Caption:=ANoticeList[I].caption;
//              AListBoxItem.Detail:=ANoticeList[I].createtime;
//              AListBoxItem.Detail1:=ANoticeList[I].content;
//
//              //全选中后再获取更多通知时统一
//              if Self.chkSelectedAllItem.Prop.Checked then
//              begin
//                AListBoxItem.Checked:=True;
//              end
//              else
//              begin
//                AListBoxItem.Checked:=False;
//              end;
//            end;
//
//          finally
//            Self.lbNoticeList.Prop.Items.EndUpdate();
//            FreeAndNil(ANoticeList);
//          end;

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

procedure TFrameSearchNewContact.btnLoadMoreClick(Sender: TObject);
begin
//  //加载更多
//  SearchContacts(FSearchResult_PageIndex_Contacts+1);
end;

procedure TFrameSearchNewContact.btnReturnClick(Sender: TObject);
begin
//  UnLoadData;

  HideFrame;//();
  ReturnFrame();

end;

procedure TFrameSearchNewContact.btnSearchClick(Sender: TObject);
begin
//  ClearContacts;
//  SearchContacts(1);
  Self.tteGetData.Run()

end;

procedure TFrameSearchNewContact.ClearContacts;
var
  I: Integer;
//  AObject:TObject;
begin
//  FSearchResult_PageIndex_Contacts := 1;

  Self.lbUserSearchResult.Prop.Items.BeginUpdate;
  try
    for I := 0 to Self.lbUserSearchResult.Prop.Items.Count-1 do
    begin
      if Self.lbUserSearchResult.Prop.Items[I].Data<>nil then
      begin
//        AObject:=TObject(Self.lbUserSearchResult.Prop.Items[I].Data);
        Self.lbUserSearchResult.Prop.Items[I].Data:=nil;
//        FreeAndNil(AObject);
      end;
    end;
    Self.lbUserSearchResult.Prop.Items.ClearItemsByType(sitDefault);
  finally
    Self.lbUserSearchResult.Prop.Items.EndUpdate();
  end;
end;

constructor TFrameSearchNewContact.Create(AOwner: TComponent);
begin
  inherited;
  Self.lbUserSearchResult.Prop.Items.BeginUpdate;
  try
    Self.lbUserSearchResult.Prop.Items.ClearItemsByType(sitDefault);
    Self.lbUserSearchResult.Prop.Items.ClearItemsByType(sitItem1);
    Self.lbUserSearchResult.Prop.Items.FindItemByType(sitItem2).Visible:=False;
  finally
    Self.lbUserSearchResult.Prop.Items.EndUpdate;
  end;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameSearchNewContact.Destroy;
begin
  inherited;
end;

procedure TFrameSearchNewContact.DoFilter;
begin
  if Trim(Self.edtKeyword.Text)<>'' then
  begin
    Self.lbUserSearchResult.Prop.Items.FindItemByType(sitItem2).Visible:=True;
    Self.lbUserSearchResult.Prop.Items.FindItemByType(sitItem2).Detail:=Self.edtKeyword.Text;
  end
  else
  begin
    Self.lbUserSearchResult.Prop.Items.FindItemByType(sitItem2).Visible:=False;
  end;
  ClearContacts;
end;

procedure TFrameSearchNewContact.edtKeywordChangeTracking(Sender: TObject);
begin
  DoFilter;
end;

procedure TFrameSearchNewContact.FrameContext1ShowEx(Sender: TObject;
  AIsReturnShow: Boolean);
begin
  if not AIsReturnShow then
  begin
    if Self.edtKeyword.CanFocus then
    begin
      Self.edtKeyword.SetFocus;
    end;
  end;
end;

end.
