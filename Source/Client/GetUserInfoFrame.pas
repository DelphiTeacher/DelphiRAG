unit GetUserInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uOpenCommon,
  uOpenClientCommon,
  uDrawCanvas,
  uAPPCommon,
  uLang,

  HintFrame,
  uSkinItems,
  uDrawPicture,
  WebBrowserFrame,
  UpdateTextFrame,

  WaitingFrame,
  MessageBoxFrame,
  PopupMenuFrame,
  uDataSetToJson,
  uViewPictureListFrame,

  uManager,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  ViewPictureListFrame,
  uSkinItemJsonHelper,
  uRestInterfaceCall,
  uBaseHttpControl,
  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,
  ListItemStyleFrame_ThemeColorButton,
  ListItemStyleFrame_CaptionLeft_DetailRight_Accessory,



  {$IFDEF HAS_FASTMSG}
  uIMClientCommon,


  FastMsg.Client.OEM,
  FastMsg.Client.Common,
  FastMsg.Client.BindingEvents,
  FastMsg.Client.Contacts,
  FastMsg.Client.Groups,

  {$IFDEF HAS_IM_DEPARTMENT}
  FastMsg.Client.Departments,
  {$ENDIF}

  FastMsg.Client.Search,
  FastMsg.Client,
  FastMsg.Client.Protocol,
  FastMsg.Client.Notifications,
//  FastMsg.Client.CommonClass,
//  FastMsg.Client.RecentSessions,
//  FastMsg.Client.MsgBox,
  FastMsg.Client.TCPClient,
//  FastMsg.Client.SubCmdObjects,

//  FastMsg.Client.BindingEvents,
  FastMsg.Client.Paths,
//  FastMsg.Client,
  FastMsg.Client.ChatContent,
//  FastMsg.Client.CommonClass,


  {$ENDIF}



  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, FMX.Objects, uSkinFireMonkeyPopup,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinListViewType,
  uContentOperation ,
  uSkinFireMonkeyListView, uTimerTaskEvent, uSkinMaterial, uSkinPopupType,
  uFrameContext;

type
  TFrameGetUserInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnPop: TSkinFMXButton;
    lvGetUserInfo: TSkinFMXListView;
    pnlItem1: TSkinFMXItemDesignerPanel;
    imgUserPicture: TSkinFMXImage;
    lblUserPhoneNumber: TSkinFMXLabel;
    lblUserName: TSkinFMXLabel;
    lblUserPhone: TSkinFMXLabel;
    lblSign: TSkinFMXLabel;
    idpInfo: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    SkinFMXImage1: TSkinFMXImage;
    idpDef: TSkinFMXItemDesignerPanel;
    lblDeta: TSkinFMXLabel;
    tteShieldUser: TTimerTaskEvent;
    tteCancelShieldUser: TTimerTaskEvent;
    tteGetUserShieldState: TTimerTaskEvent;
    tteUserFocusPublisher: TTimerTaskEvent;
    tteUserCancelFocusPublisher: TTimerTaskEvent;
    tteGetUserFocusedState: TTimerTaskEvent;
    tteGetUser: TTimerTaskEvent;
    popGroup_Material: TSkinPopupDefaultMaterial;
    FrameContext1: TFrameContext;
    popScan: TSkinFMXPopup;
    lbFunction: TSkinFMXListBox;
    lblFastmsgUserId: TSkinFMXLabel;
    imgUserVip: TSkinFMXImage;
    tteGetUserByFastmsgUserId: TTimerTaskEvent;
    btnFocus: TSkinFMXButton;
    Item1: TSkinFMXItemDesignerPanel;
    btnFans: TSkinFMXButton;
    btnFocused: TSkinFMXButton;
    btnVisitors: TSkinFMXButton;
    ItemPic: TSkinFMXItemDesignerPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXButton2: TSkinFMXButton;
    img1: TSkinFMXImage;
    img3: TSkinFMXImage;
    img2: TSkinFMXImage;
    procedure btnReturnClick(Sender: TObject);
    procedure btnPopClick(Sender: TObject);
    procedure lvGetUserInfoClickItem(AItem: TSkinItem);
    procedure lbFunctionClickItem(AItem: TSkinItem);
    procedure tteShieldUserBegin(ATimerTask: TTimerTask);
    procedure tteShieldUserExecute(ATimerTask: TTimerTask);
    procedure tteShieldUserExecuteEnd(ATimerTask: TTimerTask);
    procedure tteCancelShieldUserBegin(ATimerTask: TTimerTask);
    procedure tteCancelShieldUserExecute(ATimerTask: TTimerTask);
    procedure tteCancelShieldUserExecuteEnd(ATimerTask: TTimerTask);
    procedure tteGetUserShieldStateBegin(ATimerTask: TTimerTask);
    procedure tteGetUserShieldStateExecute(ATimerTask: TTimerTask);
    procedure tteGetUserShieldStateExecuteEnd(ATimerTask: TTimerTask);
    procedure tteUserFocusPublisherBegin(ATimerTask: TTimerTask);
    procedure tteUserFocusPublisherExecute(ATimerTask: TTimerTask);
    procedure tteUserFocusPublisherExecuteEnd(ATimerTask: TTimerTask);
    procedure tteUserCancelFocusPublisherBegin(ATimerTask: TTimerTask);
    procedure tteUserCancelFocusPublisherExecute(ATimerTask: TTimerTask);
    procedure tteUserCancelFocusPublisherExecuteEnd(ATimerTask: TTimerTask);
    procedure tteGetUserFocusedStateBegin(ATimerTask: TTimerTask);
    procedure tteGetUserFocusedStateExecute(ATimerTask: TTimerTask);
    procedure tteGetUserFocusedStateExecuteEnd(ATimerTask: TTimerTask);
    procedure imgUserPictureClick(Sender: TObject);
    procedure tteGetUserBegin(ATimerTask: TTimerTask);
    procedure tteGetUserExecute(ATimerTask: TTimerTask);
    procedure tteGetUserExecuteEnd(ATimerTask: TTimerTask);
    procedure tteGetUserByFastmsgUserIdBegin(ATimerTask: TTimerTask);
    procedure tteGetUserByFastmsgUserIdExecute(ATimerTask: TTimerTask);
    procedure tteGetUserByFastmsgUserIdExecuteEnd(ATimerTask: TTimerTask);
    procedure FrameContext1Show(Sender: TObject);
    procedure FrameContext1CanReturn(Sender: TObject;
      var AIsCanReturn: TFrameReturnActionType);
    procedure lvGetUserInfoResize(Sender: TObject);
    procedure btnFocusClick(Sender: TObject);
    procedure btnFansClick(Sender: TObject);
    procedure btnFocusedClick(Sender: TObject);
    procedure btnVisitorsClick(Sender: TObject);
  private
//    //获取用户的宠物列表
//    procedure GetUserPetList;

    procedure SyncButtonState;
  public
    FFastmsgUserFID:Integer;


    FUserFID:String;
    //是否屏蔽
    FIsShield:Boolean;
    //是否关注了
    FIsFocused:Boolean;
    FUserName: String;
    FUserPicture:TDrawPicture;

    FFastMsgUserId:Integer;
    FIsVIP:Integer;


    FIsDeletedContact:Boolean;

//    FOtherUser:TOtherUser;

//    //获取宠物列表接口
//    procedure DoGetUserPetListExecute(ATimerTask:TObject);
//    procedure DoGetUserPetListExecuteEnd(ATimerTask:TObject);
  {$IFDEF HAS_FASTMSG}
    //安装绑定事件
    procedure InstallBindingEvents;
    //卸载绑定事件
    procedure UnInstallBindingEvents;

    procedure OnClient_GetUserJoinSettingExecute(Sender: TBindingEvent);
  {$ENDIF}
    //从发送请求页面返回
    procedure OnReturnFromSendRequestFrame(Frame:TFrame);

    procedure DoReturnFromUpdateTextFrame(AFrame:TFrame);
    { Private declarations }
  public
    FContentOperation:TContentOperation;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Clear;
//    procedure Load(AUserFID:Integer);

    //加载用户(加载自己?),AUserJson.V['user_fid']
    procedure Load(AUserJson:ISuperObject);overload;
    procedure Load(AUser:TUser);overload;

    //加载用户
    procedure Load(AUserFID:String;
                    AUserName:String;
                    AHeadPicPath:String;
                    ASign:String;
                    ACity:String;
                    AFastMsgUserId:Integer;
                    AIsVIP:Integer;
                    AJson:ISuperObject = nil
                    );overload;
    //加载用户
    procedure Load(AUserFID:String);overload;
    //根据FastmsgUserId来获取用户信息
    procedure LoadByFastmsgUserId(AFastmsgUserFID:Integer);

    //更新IM用户信息
    procedure SyncIMUserInfo;


//    //加载我关注的用户
//    procedure LoadFocuesdUser(AUserJson:ISuperObject;AIsFocused:Boolean);
    { Public declarations }
  end;




var
  GlobalGetUserInfoFrame:TFrameGetUserInfo;

implementation

uses
  MainForm,
  {$IFDEF HAS_FASTMSG}
  ChatFrame,
  SendAddContactRequestFrame,
  {$ENDIF}
//  ContentListFrame,
//  UserPetchipInfoFrame,

  ComplainUserFrame,
  MainFrame;

{$R *.fmx}

{ TFrameGetUserInfo }

procedure TFrameGetUserInfo.btnPopClick(Sender: TObject);
begin

  Self.popScan.Height:=Self.lbFunction.Prop.GetContentHeight+Self.popScan.Padding.Top+Self.popScan.Padding.Bottom;
  //弹出菜单
  if not popScan.IsOpen then
  begin
    //绝对位置
    popScan.PlacementRectangle.Left:=Self.LocalToScreen(
          PointF(Self.btnPop.Position.X+Self.btnPop.Width,
                Self.btnPop.Position.Y)
                ).X
                -Self.popScan.Width
                -5;
    popScan.PlacementRectangle.Top:=Self.LocalToScreen(PointF(0,Self.pnlToolBar.Height+10)).Y-25;
    popScan.IsOpen := True;
  end
  else
  begin
    popScan.IsOpen := False;
  end;
end;

procedure TFrameGetUserInfo.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then Exit;

  //返回
  HideFrame;//();
  ReturnFrame();
end;

procedure TFrameGetUserInfo.btnVisitorsClick(Sender: TObject);
begin
  //

end;

procedure TFrameGetUserInfo.Clear;
var
  AItem:TSkinItem;
begin
  FUserFID:='';
  FUserName:='';
  FUserPicture.Url:='';

  FFastmsgUserId:=0;


  FIsShield:=False;
  FIsFocused:=False;


  FIsDeletedContact:=False;


  AItem:=Self.lvGetUserInfo.Prop.Items.FindItemByType(sitHeader);
  //头像
  AItem.Icon.Url:='';
  AItem.Icon.IsClipRound:=True;
  AItem.Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
  //昵称
  AItem.Caption:='';
  //所在区域
  AItem.Detail:='';


  //清除宠物
//  Self.lvGetUserInfo.Prop.Items.ClearItemsByType(sitItem2);


  Self.btnPop.Visible:=False;

end;
  {$IFDEF HAS_FASTMSG}

procedure TFrameGetUserInfo.InstallBindingEvents;
begin
  UIBindingEvents.RegEvent(Self,'Client:OnGetJoinSetting',OnClient_GetUserJoinSettingExecute,True);
//  UIBindingEvents.RegEvent(Self,'Client:OnValidateJoinQuestion',OnClient_ValidateUserJoinQuestionExecute,True);

end;


procedure TFrameGetUserInfo.UnInstallBindingEvents;
begin
//  if FOnClient_GetUserJoinSetting <> nil then FreeAndNil(FOnClient_GetUserJoinSetting);
//  if FOnClient_ValidateUserJoinQuestion <> nil then FreeAndNil(FOnClient_ValidateUserJoinQuestion);
  UIBindingEvents.UnRegEvent(Self,OnClient_GetUserJoinSettingExecute);
//  UIBindingEvents.UnRegEvent(Self,OnClient_ValidateUserJoinQuestionExecute);
end;
  {$ENDIF}

constructor TFrameGetUserInfo.Create(AOwner: TComponent);
begin
  inherited;
  FUserPicture:=TDrawPicture.Create;

  FContentOperation:=TContentOperation.Create;
  FContentOperation.FContentListBox:=Self.lvGetUserInfo;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  {$IFDEF HAS_FASTMSG}
  {$ENDIF}

end;

destructor TFrameGetUserInfo.Destroy;
begin
  FreeAndNil(FContentOperation);
  FreeAndNil(FUserPicture);
  inherited;
end;

procedure TFrameGetUserInfo.DoReturnFromUpdateTextFrame(AFrame: TFrame);
  {$IFDEF HAS_FASTMSG}
var
  AOtherUser:TContact;
  {$ENDIF}
begin
  {$IFDEF HAS_FASTMSG}
  //最终都是调用这个
  if FFastMsgUserId>0 then
  begin
    AOtherUser:=GlobalClient.ContactManager.FindContactByUserId(Self.FFastMsgUserId);
    if AOtherUser<>nil then
    begin
      GlobalClient.ContactManager.ChangeContactRemarkName(
              Self.FFastMsgUserId,
              TFrameUpdateText(AFrame).edtText.Text);
    end;
  end;
  {$ENDIF}
end;

procedure TFrameGetUserInfo.FrameContext1CanReturn(Sender: TObject;
  var AIsCanReturn: TFrameReturnActionType);
begin
  {$IFDEF HAS_FASTMSG}
  UnInstallBindingEvents;
  {$ENDIF}
end;

procedure TFrameGetUserInfo.FrameContext1Show(Sender: TObject);
begin

end;

//procedure TFrameGetUserInfo.DoGetUserPetListExecute(ATimerTask: TObject);
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//
//  try
//
//    TTimerTask(ATimerTask).TaskDesc:=
//      SimpleCallAPI('get_record_list',
//                    nil,
//                    TableRestCenterInterfaceUrl,
//                    ['appid',
//                    'user_fid',
//                    'key',
//                    'rest_name',
//                    'pageindex',
//                    'pagesize',
//                    'where_key_json',
//                    'order_by',
//                    'is_need_sub_query_list'],
//                    [AppID,
//                    GlobalManager.User.fid,
//                    '',
//                    'user_pet',
//                    1,
//                    MaxInt,
//                    GetWhereConditions(['appid','user_fid'],
//                              [AppID,FUserFID]),
//                    'createtime DESC',
//                    1
//                    ]
//                    );
//    if TTimerTask(ATimerTask).TaskDesc<>'' then
//    begin
//      TTimerTask(ATimerTask).TaskTag:=0;
//    end;
//
//  except
//    on E:Exception do
//    begin
//      //异常
//      TTimerTask(ATimerTask).TaskDesc:=E.Message;
//    end;
//  end;
//end;
//
//procedure TFrameGetUserInfo.DoGetUserPetListExecuteEnd(ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//  I: Integer;
//  AListViewItem:TSkinListViewItem;
//begin
//
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//
//        Self.lvGetUserInfo.Prop.Items.FindItemByType(sitItem3).Visible:=
//                 ASuperObject.O['Data'].A['RecordList'].Length<>0;
//
//
//
//        //获取成功
//        for I := 0 to ASuperObject.O['Data'].A['RecordList'].Length-1 do
//        begin
//          //创建页面
//
//          AListViewItem:=Self.lvGetUserInfo.Prop.Items.Insert(
//                        Self.lvGetUserInfo.Prop.Items.FindItemByType(sitDefault).Index-1);
//
//
//          AListViewItem.ItemType:=sitItem2;
//          //赋值
//          AListViewItem.CreateOwnDataObject(TSkinItemJsonObject);
//          GetItemJsonObject(AListViewItem).Json:=ASuperObject.O['Data'].A['RecordList'].O[I];
//
//
//          if ASuperObject.O['Data'].A['RecordList'].Length>1 then
//          begin
//            AListViewItem.Width:=-1;
//          end
//          else
//          begin
//            AListViewItem.Width:=-2;
//          end;
//          //宠名
//          AListViewItem.Caption:=ASuperObject.O['Data'].A['RecordList'].O[I].S['name'];
//          //宠物品种
//          AListViewItem.Detail:=ASuperObject.O['Data'].A['RecordList'].O[I].S['variety'];
//          //宠物头像
//          AListViewItem.Icon.Url:=GetImageUrl(ASuperObject.O['Data'].A['RecordList'].O[I].S['head_pic_path']);
//          AListViewItem.Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
//          AListViewItem.Icon.IsClipRound:=True;
//        end;
//
//
//      end
//      else
//      begin
//        //生成失败
//        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
//      end;
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    HideWaitingFrame;
//  end;
//end;
//
//procedure TFrameGetUserInfo.GetUserPetList;
//begin
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                            DoGetUserPetListExecute,
//                            DoGetUserPetListExecuteEnd);
//end;

procedure TFrameGetUserInfo.imgUserPictureClick(Sender: TObject);
begin
  //查看头像大图
  HideFrame;//();
  //查看照片信息
  ShowFrame(TFrame(GlobalViewPictureListFrame),TFrameViewPictureList,frmMain,nil,nil,nil);
//  GlobalViewPictureListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalViewPictureListFrame.Init(FUserName+'的头像',
        FUserPicture,
        //原图URL
        Self.lvGetUserInfo.Prop.InteractiveItem.Icon.Url
        );

end;

procedure TFrameGetUserInfo.tteUserCancelFocusPublisherBegin(
  ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(nil,Trans('处理中...'));

end;

procedure TFrameGetUserInfo.tteUserCancelFocusPublisherExecute(
  ATimerTask: TTimerTask);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=TASK_FAIL;
  try
    TTimerTask(ATimerTask).TaskDesc:=
        SimpleCallAPI('user_unfocused_user',
            nil,
            ContentCenterInterfaceUrl,
            ['appid',
            'user_fid',
            'key',
            'focused_user_fid'
            ],
            [AppID,
            GlobalManager.User.fid,
            GlobalManager.User.key,
            Self.FUserFID
            ],
                                        GlobalRestAPISignType,
                                        GlobalRestAPIAppSecret
            );
    if TTimerTask(ATimerTask).TaskDesc<>'' then
    begin
      TTimerTask(ATimerTask).TaskTag:=TASK_SUCC;
    end;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;

end;

procedure TFrameGetUserInfo.tteUserCancelFocusPublisherExecuteEnd(
  ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
//  I: Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=TASK_SUCC then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

//          //关注用户成功
//          for I := 0 to Self.lvData.Prop.Items.Count-1 do
//          begin
//            if GetItemJsonObject(Self.lvData.Prop.Items[I]).Json.V['user_fid']=
//                GetItemJsonObject(Self.lvData.Prop.InteractiveItem).Json.V['user_fid'] then
//            begin
//              GetItemJsonObject(Self.lvData.Prop.Items[I]).Json.I['is_user_focused']:=1;
//              //需要重新缓存
//              Self.lvData.Prop.Items[I].IsBufferNeedChange:=True;
//            end;
//          end;

          ShowHintFrame(nil,Trans('取消关注成功!'));


          Self.FIsFocused:=False;

          Self.SyncButtonState;

      end
      else
      begin
          //调用接口失败
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

procedure TFrameGetUserInfo.tteUserFocusPublisherBegin(
  ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(nil,Trans('处理中...'));
end;

procedure TFrameGetUserInfo.tteUserFocusPublisherExecute(
  ATimerTask: TTimerTask);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=TASK_FAIL;
  try
    TTimerTask(ATimerTask).TaskDesc:=
        SimpleCallAPI('user_focused_user',
            nil,
            ContentCenterInterfaceUrl,
            ['appid',
            'user_fid',
            'key',
            'focused_user_fid'
            ],
            [AppID,
            GlobalManager.User.fid,
            GlobalManager.User.key,
            FUserFID
            ],
                                        GlobalRestAPISignType,
                                        GlobalRestAPIAppSecret
            );
    if TTimerTask(ATimerTask).TaskDesc<>'' then
    begin
      TTimerTask(ATimerTask).TaskTag:=TASK_SUCC;
    end;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;

end;

procedure TFrameGetUserInfo.tteUserFocusPublisherExecuteEnd(
  ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
//  I: Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=TASK_SUCC then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

//          //关注用户成功
//          for I := 0 to Self.lvData.Prop.Items.Count-1 do
//          begin
//            if GetItemJsonObject(Self.lvData.Prop.Items[I]).Json.V['user_fid']=
//                GetItemJsonObject(Self.lvData.Prop.InteractiveItem).Json.V['user_fid'] then
//            begin
//              GetItemJsonObject(Self.lvData.Prop.Items[I]).Json.I['is_user_focused']:=1;
//              //需要重新缓存
//              Self.lvData.Prop.Items[I].IsBufferNeedChange:=True;
//            end;
//          end;


          ShowHintFrame(nil,Trans('关注成功!'));


          Self.FIsFocused:=True;

          Self.SyncButtonState;

      end
      else
      begin
          //调用接口失败
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

procedure TFrameGetUserInfo.lbFunctionClickItem(AItem: TSkinItem);
begin
  Self.popScan.IsOpen:=False;


  if not GlobalManager.IsLogin then
  begin
    ShowLoginFrame(True);
    Exit;
  end;



  if AItem.Name='shield_user' then
  begin
    //屏蔽用户
    Self.tteShieldUser.Run;
  end;
  if AItem.Name='cancel_shield_user' then
  begin
    //取消屏蔽用户
    Self.tteCancelShieldUser.Run;
  end;

  if AItem.Name='focus_user' then
  begin
    //关注用户
    Self.tteUserFocusPublisher.Run;
  end;
  if AItem.Name='cancel_focus_user' then
  begin
    //取消关注用户
    Self.tteUserCancelFocusPublisher.Run;
  end;

  if AItem.Name='complain_user' then
  begin
    //投诉用户
    HideFrame;//();
    ShowFrame(TFrame(GlobalComplainUserFrame),TFrameComplainUser,frmMain,nil,nil,nil,Application);
    Self.popScan.IsOpen:=False;
    GlobalComplainUserFrame.clear;
    GlobalComplainUserFrame.Load(FUserFID);
  end;
  {$IFDEF HAS_FASTMSG}
  if AItem.Name='delete_contact' then
  begin
    //删除好友
    GlobalClient.ContactManager.RemoveContact(Self.FFastMsgUserId,True);

    FIsDeletedContact:=True;


  end;
  {$ENDIF}


end;

procedure TFrameGetUserInfo.Load(AUserFID:String;
                                  AUserName:String;
                                  AHeadPicPath:String;
                                  ASign:String;
                                  ACity:String;
                                  AFastMsgUserId:Integer;
                                  AIsVIP:Integer ;
                                  AJson:ISuperObject = nil
                                  );
var
  AItem:TSkinItem;
begin
  //最终都是调用这个

  FUserFID:=AUserFID;
  FUserName:=AUserName;
  FUserPicture.Url:=GetImageUrl(AHeadPicPath,itUserHead);

  FFastMsgUserId:=AFastMsgUserId;


  FIsShield:=False;
 // FIsFocused:=False;
  FIsVIP:=AIsVIP;



  AItem:=Self.lvGetUserInfo.Prop.Items.FindItemByType(sitHeader);
  //头像
  AItem.Icon.Url:=GetImageUrl(AHeadPicPath,itUserHead);
  AItem.Icon.IsClipRound:=True;
  AItem.Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
  //昵称
  AItem.Caption:=AUserName;
  //所在区域
  AItem.Detail:=ASign;
  AItem.Detail1:=IntToStr(Self.FFastMsgUserId);

  AItem.Json:=AJson;

  Self.lvGetUserInfo.Prop.Items.ClearItemsByType(sitItem2);

 // btnFocus.Visible := not FIsFocused;

  SyncIMUserInfo;

//  if GlobalManager.IsLogin then
//  begin
//
//      //获取屏蔽状态
//      Self.tteGetUserShieldState.Run;
//
//      //获取关注状态
//      Self.tteGetUserFocusedState.Run;
//
//  end;



  Self.SyncButtonState;


  {$IFDEF HAS_FASTMSG}
  InstallBindingEvents;
  {$ENDIF}
end;

procedure TFrameGetUserInfo.Load(AUserJson: ISuperObject);
//var
//  AItem:TSkinItem;
begin
  Load(AUserJson.V['user_fid'],
        AUserJson.S['user_name'],
        AUserJson.S['user_head_pic_path'],
        AUserJson.S['user_province'],
        AUserJson.S['user_city'],
        AUserJson.I['fastmsg_user_id'],
        AUserJson.I['is_vip'],
        AUserJson
        );


//  if AUserJson.V['is_user_focused'] = 0 then
//    FIsFocused:=False
//  else
//    FIsFocused:=True;
//  btnFocused.Visible:=not FIsFocused;
//  FUserFID:=AUserJson.V['user_fid'];
//
//  AItem:=Self.lvGetUserInfo.Prop.Items.FindItemByType(sitItem1);
//  //头像
//  AItem.Icon.Url:=GetImageUrl(AUserJson.S['user_head_pic_path'],itUserHead);
//  AItem.Icon.IsClipRound:=True;
//  AItem.Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
//  //昵称
//  AItem.Caption:=AUserJson.S['user_name'];
//  //所在区域
//  AItem.Detail:=AUserJson.S['province']+' '+AUserJson.S['city'];
//
//  Self.lvGetUserInfo.Prop.Items.ClearItemsByType(sitItem2);
//
//
//
//  //获取用户宠物列表
//  GetUserPetList;
//
//
//  //
//  Self.tteGetUserShieldState.Run;
//
//
//  Self.SyncButtonState;
end;


//procedure TFrameGetUserInfo.LoadFocuesdUser(AUserJson: ISuperObject;AIsFocused:Boolean);
//var
//  AItem:TSkinItem;
//  AListBoxItem:TSkinListBoxItem;
//begin
//
//
//  if AIsFocused=True then
//  begin
//
////      //我关注的用户
////      FUserFID:=AUserJson.I['focused_user_fid'];
////
////      AItem:=Self.lvGetUserInfo.Prop.Items.FindItemByType(sitItem1);
////      //头像
////      AItem.Icon.Url:=GetImageUrl(AUserJson.S['focused_head_pic_path'],itUserHead);
////      AItem.Icon.IsClipRound:=True;
////      AItem.Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
////      //昵称
////      AItem.Caption:=AUserJson.S['focused_user_name'];
//
//      Load(AUserJson.I['focused_user_fid'],
//          AUserJson.S['focused_user_name'],
//          AUserJson.S['focused_head_pic_path'],
//          '',
//          ''
//          );
//
//
//
//  //    //所在区域
//  //    AItem.Detail:=AUserJson.S['province']+' '+AUserJson.S['city'];
//
//  end
//  else
//  begin
//
//      //关注我的用户,粉丝
//      FUserFID:=AUserJson.V['user_fid'];
//
//      AItem:=Self.lvGetUserInfo.Prop.Items.FindItemByType(sitItem1);
//      //头像
//      AItem.Icon.Url:=GetImageUrl(AUserJson.S['head_pic_path'],itUserHead);
//      AItem.Icon.IsClipRound:=True;
//      AItem.Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
//      //昵称
//      AItem.Caption:=AUserJson.S['user_name'];
//
//  end;
//
//
//  Self.lvGetUserInfo.Prop.Items.ClearItemsByType(sitItem2);
//
//  //获取用户宠物列表
//  GetUserPetList;
//
//
//  Self.btnPop.Visible:=(FUserFID<>GlobalManager.User.fid);
//end;

function LastFrame(AFrame:TFrame):TFrame;
var
  I: Integer;
begin
  Result:=nil;
  for I := GlobalFrameHistoryLogList.Count-1 downto 0 do
  begin
    if GlobalFrameHistoryLogList[I].FrameHistory.ToFrame=AFrame then
    begin
      if I>0 then
      begin
        Result:=GlobalFrameHistoryLogList[I-1].FrameHistory.ToFrame;
      end;
      Break;
    end;
  end;
end;

procedure TFrameGetUserInfo.lvGetUserInfoClickItem(AItem: TSkinItem);
begin
  if AItem.ItemType=sitItem4 then
  begin
      {$IFDEF HAS_FASTMSG}
      if AItem.Name='send_msg' then
      begin

        //如果正在聊天,那么返回
        if (GlobalChatFrame<>nil)
          and (LastFrame(CurrentFrame)=GlobalChatFrame)
          and (GlobalChatFrame.FContact.UserId=Self.FFastMsgUserId) then
        begin
            HideFrame;
            ReturnFrame;
        end
        else
        begin
            //跳转好友聊天界面
            HideFrame;//(Self,hfcttBeforeShowFrame);
            ShowFrame(TFrame(GlobalChatFrame),TFrameChat,frmMain,nil,nil,nil,Application);
        //    GlobalChatFrame.FrameHistroy:=CurrentFrameHistroy;
        //    GlobalChatFrame.Clear;
            GlobalChatFrame.Load(GlobalClient.ContactManager.FindContactByUserId(Self.FFastMsgUserId),0);
        end;

      end;
      if AItem.Name='add_contact' then
      begin

          ShowWaitingFrame(nil,Trans('加载中...'));

          //获取验证设置
          GlobalClient.Search.GetJoinSetting(Self.FFastMsgUserId);

      end;
      {$ENDIF}
//      //查看宠物信息
//      HideFrame;//();
//      ShowFrame(TFrame(GlobalUserPetchipInfoFrame),TFrameUserPetchipInfo);
//      GlobalUserPetchipInfoFrame.LoadPet(
//          GetItemJsonObject(AItem).Json);
  end;

//  if AItem.Caption='动态' then
//  begin
//      //隐藏
//      HideFrame;//();
//      //显示发布列表
//      ShowFrame(TFrame(GlobalContentListFrame),TFrameContentList,frmMain,nil,nil,nil,Application);
//      GlobalContentListFrame.Clear;
//      GlobalContentListFrame.FFilterUserFID:=FUserFID;
//      GlobalContentListFrame.FFilterFavUserFID:='';
//      GlobalContentListFrame.pnlToolBar.Caption:=AItem.Caption;
//      GlobalContentListFrame.Load;
//  end;

  if AItem.Name='remark' then
  begin
      //修改好友备注
      HideFrame;
      ShowFrame(TFrame(GlobalUpdateTextFrame),TFrameUpdateText,DoReturnFromUpdateTextFrame);
      //修改
      GlobalUpdateTextFrame.EditName(AItem.Caption,AItem.Detail);


  end;

end;

procedure TFrameGetUserInfo.lvGetUserInfoResize(Sender: TObject);
begin
  btnFans.Width:=trunc(lvGetUserInfo.Width-30)/3;
  btnFocused.Width:=trunc(lvGetUserInfo.Width-30)/3;
  btnVisitors.Width:=trunc(lvGetUserInfo.Width-30)/3;
end;

  {$IFDEF HAS_FASTMSG}
procedure TFrameGetUserInfo.OnClient_GetUserJoinSettingExecute(
  Sender: TBindingEvent);
var
  objBindingEvent: TBindingEvent;
  objUserJoinSettingData: TUserJoinSettingData;
begin
  objBindingEvent := TBindingEvent(Sender);
  objUserJoinSettingData := TUserJoinSettingData(objBindingEvent.FParam1);

  if objUserJoinSettingData.UserId <> FFastMsgUserId then Exit;
  try



    //  //停止超时检测
    //  tmGetUserJoinSettionTimeOut.Enabled := False;
    //
    //  FJoinSetting := objUserJoinSettingData.JoinSetting;
    //  FJoinQuestion := objUserJoinSettingData.JoinQuestion;
    //
    //  //验证问题
    //  lblQuestion.Caption := objUserJoinSettingData.JoinQuestion;


      case objUserJoinSettingData.JoinSetting of
        jmsAllowAll:
        begin

            //默认是不需要验证的
            //所以直接加好友
            GlobalClient.ContactManager.AddContact(CONTACTGROUPID_MYCONTACTS,
                                                    FFastMsgUserId,
                                                    FUserName
                                                    );

            GlobalClient.Search.SendJoinResponse(FFastMsgUserId,'',1);


//            GlobalIMClient.SendHelloMsg(FFastMsgUserId,FUserName,FUserName);
            GlobalIMClient.FAcceptedJoinOtherUserList.Add(IntToStr(FFastMsgUserId));


            ShowHintFrame(nil,Trans('已添加!'));

            HideFrame;
            ReturnFrame;


//          //直接添加
//          Self.lblJoinAll.Caption := '通过验证。请选择要添加的联系人分组:';
//          Self.btnAdd.Visible:=True;
//          Self.btnAdd.Caption:='添加';
//          Self.pcClient.Prop.ActivePage:=tsAllowAll;
    //      lblContactGroup.Visible := True;
    //      cbContactGroup.Visible := True;
    //      lblRemarkName.Visible := True;
    //      edtRemarkName.Visible := True;
    //      pgctrlClient.ActivePageIndex := 3;
    //      btnNext.Visible := True;
    //      btnNext.Caption := '添加';
    //      btnNext.Tag := 1;
        end;
        jmsNotAllow:
         begin
//          //不允许添加
//          Self.lblNotAllow.Caption := '对方不允许任何人添加。';
//          Self.pcClient.Prop.ActivePage:=tsNotAllow;
            ShowHintFrame(nil,Trans('对方不允许任何人添加。'));
    //      Self.btnAdd.Visible:=True;
    //      Self.btnAdd.Caption:='完成';
    //      lblContactGroup.Visible := False;
    //      cbContactGroup.Visible := False;
    //      lblRemarkName.Visible := False;
    //      edtRemarkName.Visible := False;
    //      pgctrlClient.ActivePageIndex := 3;
    //      btnNext.Visible := False;
    //      btnCancel.Caption := '完成';
        end;
        jmsNeedConfirm:
        begin
            //需要好友确认
            //打个招呼

            //发送请求页面
            HideFrame;//(Self,hfcttBeforeShowFrame);
            ShowFrame(TFrame(GlobalSendAddContactRequestFrame),TFrameSendAddContactRequest,frmMain,nil,nil,OnReturnFromSendRequestFrame,Application);
        //    GlobalSendAddContactRequestFrame.FrameHistroy:=CurrentFrameHistroy;
            GlobalSendAddContactRequestFrame.Clear;

            GlobalSendAddContactRequestFrame.Load(
//                                                  FOtherUser
                                                  FFastmsgUserId,
                                                  FUserName
                                                  );


//          Self.btnAdd.Visible:=True;
//          Self.btnAdd.Caption:='发送';
//          Self.pcClient.Prop.ActivePage:=tsNeedConfirm;
    //      pgctrlClient.ActivePageIndex := 1;
    //      btnNext.Visible := True;
    //      btnNext.Caption := '下一步';
    //      btnNext.Tag := 2;
        end;
        jmsNeedAnswer:
        begin
//          //需要回答问题
//          Self.btnAdd.Visible:=True;
//          Self.btnAdd.Caption:='验证';
//          Self.pcClient.Prop.ActivePage:=tsNeedAnswer;
    //      pgctrlClient.ActivePageIndex := 2;
    //      btnNext.Visible := True;
    //      btnNext.Caption := '下一步';
    //      btnNext.Tag := 3;
        end;
      end;//case

  finally
    HideWaitingFrame;
  end;
end;
  {$ENDIF}

procedure TFrameGetUserInfo.OnReturnFromSendRequestFrame(Frame: TFrame);
begin
  ShowHintFrame(nil,Trans('已发送!'));
end;

procedure TFrameGetUserInfo.btnFansClick(Sender: TObject);
begin
  //

end;

procedure TFrameGetUserInfo.btnFocusClick(Sender: TObject);
begin
//关注用户
  FContentOperation.FContentItem:=Self.lvGetUserInfo.Prop.InteractiveItem;
  FContentOperation.tteUserFocusPublisher.Run;
//  lvGetUserInfo.Prop.StartPullDownRefresh;
end;

procedure TFrameGetUserInfo.btnFocusedClick(Sender: TObject);
begin
  //
end;

procedure TFrameGetUserInfo.SyncButtonState;
begin
  if (FUserFID<>GlobalManager.User.fid) then
  begin
      //不是查看自己的详细信息
      Self.btnPop.Visible:=True;


      //屏蔽的菜单是否显示
      Self.lbFunction.Prop.Items.FindItemByName('shield_user').Visible:=
          not Self.FIsShield;
      //取消屏蔽的菜单是否显示
      Self.lbFunction.Prop.Items.FindItemByName('cancel_shield_user').Visible:=
          Self.FIsShield;


//      //关注的菜单是否显示
//      Self.lbFunction.Prop.Items.FindItemByName('focus_user').Visible:=
//          not Self.FIsFocused;
//      //取消关注的菜单是否显示
//      Self.lbFunction.Prop.Items.FindItemByName('cancel_focus_user').Visible:=
//          Self.FIsFocused;


  end
  else
  begin
      //对自己没有任何操作
      Self.btnPop.Visible:=False;

  end;
end;

procedure TFrameGetUserInfo.SyncIMUserInfo;
  {$IFDEF HAS_FASTMSG}
var
  AContact:TContact;
  {$ENDIF}
begin

  {$IFDEF HAS_FASTMSG}

  AContact:=GlobalClient.ContactManager.FindContactByUserId(Self.FFastMsgUserId);

  if AContact<>nil then
  begin
    //备注名
    Self.lvGetUserInfo.Prop.Items.FindItemByName('remark').Detail:=AContact.RemarkName;
  end;

  Self.lvGetUserInfo.Prop.Items.FindItemByName('remark').Visible:=(AContact<>nil);


  //发消息的按钮是否显示
  Self.lvGetUserInfo.Prop.Items.FindItemByName('send_msg').Visible:=(AContact<>nil);
  //添加到通讯录的按钮是否显示
  Self.lvGetUserInfo.Prop.Items.FindItemByName('add_contact').Visible:=(AContact=nil);



  //判断是否显示认证图标
//  if (AOtherUser.FUserInfo<>nil) and (AOtherUser.FUserInfo.isvip=1) then
//  begin
    imgUserVip.Visible:=(FIsVIP=1);
//  end
//  else// if AContact.FUserInfo.isvip=0 then
//  begin
//    imgUserVip.Visible:=False;
//  end;



  //可以删除好友
  Self.lbFunction.Prop.Items.FindItemByName('delete_contact').Visible:=(AContact<>nil);
  {$ELSE}
  //发消息的按钮是否显示
  Self.lvGetUserInfo.Prop.Items.FindItemByName('send_msg').Visible:=False;
  //添加到通讯录的按钮是否显示
  Self.lvGetUserInfo.Prop.Items.FindItemByName('add_contact').Visible:=False;

  //可以删除好友
  Self.lbFunction.Prop.Items.FindItemByName('delete_contact').Visible:=False;
  {$ENDIF}

end;

procedure TFrameGetUserInfo.tteCancelShieldUserBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,Trans('处理中...'));
end;

procedure TFrameGetUserInfo.tteCancelShieldUserExecute(ATimerTask: TTimerTask);
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

procedure TFrameGetUserInfo.tteCancelShieldUserExecuteEnd(
  ATimerTask: TTimerTask);
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

//          //屏蔽的菜单是否显示
//          Self.lbFunction.Prop.Items.FindItemByName('shield_user').Visible:=True;
//          //取消屏蔽的菜单是否显示
//          Self.lbFunction.Prop.Items.FindItemByName('cancel_shield_user').Visible:=False;


          Self.FIsShield:=False;

          Self.SyncButtonState;

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

procedure TFrameGetUserInfo.tteGetUserBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,Trans('加载中...'));

end;

procedure TFrameGetUserInfo.tteGetUserExecute(ATimerTask: TTimerTask);
begin
  try
      //出错
      TTimerTask(ATimerTask).TaskTag:=1;

      TTimerTask(ATimerTask).TaskDesc:=
          SimpleCallAPI('get_record',
                        nil,
                        TableRestCenterInterfaceUrl,
                        ['appid',
                        'user_fid',
                        'key',
                        'rest_name',
                        'where_key_json'],
                        [AppID,
                        GlobalManager.User.fid,
                        '',
                        'user',
                        GetWhereConditions(['appid','fid'],
                                            [AppID,FUserFID])
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

procedure TFrameGetUserInfo.tteGetUserExecuteEnd(ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          Load(ASuperObject.O['Data'].V['fid'],
                ASuperObject.O['Data'].S['name'],
                ASuperObject.O['Data'].S['head_pic_path'],
                ASuperObject.O['Data'].S['province'],
                ASuperObject.O['Data'].S['city'],
                ASuperObject.O['Data'].I['fastmsg_user_id'],
                ASuperObject.O['Data'].I['is_vip']
                );


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

procedure TFrameGetUserInfo.tteGetUserByFastmsgUserIdBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,Trans('加载中...'));

end;

procedure TFrameGetUserInfo.tteGetUserByFastmsgUserIdExecute(ATimerTask: TTimerTask);
begin
  try
      //出错
      TTimerTask(ATimerTask).TaskTag:=1;

      TTimerTask(ATimerTask).TaskDesc:=
          SimpleCallAPI('get_record',
                        nil,
                        TableRestCenterInterfaceUrl,
                        ['appid',
                        'user_fid',
                        'key',
                        'rest_name',
                        'where_key_json'],
                        [AppID,
                        GlobalManager.User.fid,
                        '',
                        'user',
                        GetWhereConditions(['appid','fastmsg_user_id'],
                                            [AppID,FFastmsgUserFID])
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

procedure TFrameGetUserInfo.tteGetUserByFastmsgUserIdExecuteEnd(ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          Load(ASuperObject.O['Data'].V['fid'],
                ASuperObject.O['Data'].S['name'],
                ASuperObject.O['Data'].S['head_pic_path'],
                ASuperObject.O['Data'].S['province'],
                ASuperObject.O['Data'].S['city'],
                ASuperObject.O['Data'].I['fastmsg_user_id'],
                ASuperObject.O['Data'].I['is_vip']
                );


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

procedure TFrameGetUserInfo.tteGetUserFocusedStateBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,Trans('加载中...'));

end;

procedure TFrameGetUserInfo.tteGetUserFocusedStateExecute(
  ATimerTask: TTimerTask);
begin
  try
      //出错
      TTimerTask(ATimerTask).TaskTag:=1;

      TTimerTask(ATimerTask).TaskDesc:=
          SimpleCallAPI('get_record_list',
                        nil,
                        TableRestCenterInterfaceUrl,
                        ['appid',
                        'user_fid',
                        'key',
                        'rest_name',
                        'pageindex',
                        'pagesize',
                        'where_key_json'],
                        [AppID,
                        GlobalManager.User.fid,
                        '',
                        'focused_user',
                        1,
                        MaxInt,
                        GetWhereConditions(['appid','user_fid','focused_user_fid'],
                                            [AppID,GlobalManager.User.fid,FUserFID])
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

procedure TFrameGetUserInfo.tteGetUserFocusedStateExecuteEnd(
  ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
          //获取关注状态

          Self.FIsFocused:=(ASuperObject.O['Data'].A['RecordList'].Length>0);

//          //屏蔽的菜单是否显示
//          Self.lbFunction.Prop.Items.FindItemByName('shield_user').Visible:=
//              ASuperObject.O['Data'].A['RecordList'].Length=0;
//          //取消屏蔽的菜单是否显示
//          Self.lbFunction.Prop.Items.FindItemByName('cancel_shield_user').Visible:=
//              ASuperObject.O['Data'].A['RecordList'].Length>0;

          Self.SyncButtonState;

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

procedure TFrameGetUserInfo.tteGetUserShieldStateBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,Trans('加载中...'));
end;

procedure TFrameGetUserInfo.tteGetUserShieldStateExecute(
  ATimerTask: TTimerTask);
begin
  try
      //出错
      TTimerTask(ATimerTask).TaskTag:=1;

      TTimerTask(ATimerTask).TaskDesc:=
          SimpleCallAPI('get_record_list',
                        nil,
                        TableRestCenterInterfaceUrl,
                        ['appid',
                        'user_fid',
                        'key',
                        'rest_name',
                        'pageindex',
                        'pagesize',
                        'where_key_json'],
                        [AppID,
                        GlobalManager.User.fid,
                        '',
                        'shield_user',
                        1,
                        MaxInt,
                        GetWhereConditions(['appid','user_fid','shield_user_fid'],
                                            [AppID,GlobalManager.User.fid,FUserFID])
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

procedure TFrameGetUserInfo.tteGetUserShieldStateExecuteEnd(
  ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
          //获取屏蔽状态

          Self.FIsShield:=ASuperObject.O['Data'].A['RecordList'].Length>0;

//          //屏蔽的菜单是否显示
//          Self.lbFunction.Prop.Items.FindItemByName('shield_user').Visible:=
//              ASuperObject.O['Data'].A['RecordList'].Length=0;
//          //取消屏蔽的菜单是否显示
//          Self.lbFunction.Prop.Items.FindItemByName('cancel_shield_user').Visible:=
//              ASuperObject.O['Data'].A['RecordList'].Length>0;

          Self.SyncButtonState;

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

procedure TFrameGetUserInfo.tteShieldUserBegin(ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(Self,Trans('处理中...'));
end;

procedure TFrameGetUserInfo.tteShieldUserExecute(ATimerTask: TTimerTask);
var
  ARecordDataJson:ISuperObject;
begin
  try
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;


    ARecordDataJson:=TSuperObject.Create;
    ARecordDataJson.I['appid']:=StrToInt(AppID);
    ARecordDataJson.V['user_fid']:=GlobalManager.User.fid;
    ARecordDataJson.V['shield_user_fid']:=FUserFID;


    TTimerTask(ATimerTask).TaskDesc:=
      SimpleCallAPI('add_record',
                    nil,
                    TableRestCenterInterfaceUrl,
                    ['appid',
                    'user_fid',
                    'key',
                    'rest_name',
                    'record_data_json'],
                    [AppID,
                    GlobalManager.User.fid,
                    '',
                    'shield_user',
                    ARecordDataJson.AsJSON
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

procedure TFrameGetUserInfo.tteShieldUserExecuteEnd(ATimerTask: TTimerTask);
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
          GlobalClient.ContactManager.MoveToBlackList(Self.FFastMsgUserId);
  {$ENDIF}


          //屏蔽成功
          ShowHintFrame(nil,Trans('屏蔽成功!'));



//          //屏蔽的菜单是否显示
//          Self.lbFunction.Prop.Items.FindItemByName('shield_user').Visible:=False;
//          //取消屏蔽的菜单是否显示
//          Self.lbFunction.Prop.Items.FindItemByName('cancel_shield_user').Visible:=True;

          Self.FIsShield:=True;

          Self.SyncButtonState;


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

procedure TFrameGetUserInfo.Load(AUserFID: String);
begin
  Clear;


  FUserFID:=AUserFID;
  Self.tteGetUser.Run;
end;

procedure TFrameGetUserInfo.LoadByFastmsgUserId(AFastmsgUserFID: Integer);
begin
  Clear;


  FFastmsgUserFID:=AFastmsgUserFID;
  Self.tteGetUserByFastmsgUserId.Run;

end;

procedure TFrameGetUserInfo.Load(AUser: TUser);
begin
  Load(AUser.fid,
        AUser.name,
        AUser.head_pic_path,
        '',//AUser.province,
        '',//AUser.city
        AUser.fastmsg_user_id,
        AUser.isvip
        );

end;

end.
