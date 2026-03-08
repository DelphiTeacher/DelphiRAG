unit MyAttentionFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uOpenCommon,
  uFuncCommon,
  uOpenClientCommon,
  uDrawCanvas,
  uAPPCommon,

  uSkinItems,
  uDrawPicture,
  WebBrowserFrame,
  uSkinItemJsonHelper,

  WaitingFrame,
  MessageBoxFrame,
  PopupMenuFrame,
  uDataSetToJson,

  uManager,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uRestInterfaceCall,
  uBaseHttpControl,
  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,
  uContentOperation,
  uSkinFireMonkeyListView,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType,
  uSkinFireMonkeyListBox, uSkinImageType, uSkinFireMonkeyImage,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel, uSkinLabelType,
  uSkinFireMonkeyLabel;

type
  TFrameMyAttention = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbList: TSkinFMXListBox;
    idpUser: TSkinFMXItemDesignerPanel;
    imgHeader: TSkinFMXImage;
    lblName: TSkinFMXLabel;
    lbOrderState: TSkinFMXListBox;
    btnAddFoucs: TSkinFMXButton;
    lblsign: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure lbListPullDownRefresh(Sender: TObject);
    procedure lbOrderStateClickItem(AItem: TSkinItem);
    procedure lbListClickItem(AItem: TSkinItem);
    procedure btnAddFoucsClick(Sender: TObject);
    procedure lbListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
  private
    FFilterString:String;
    //获取已关注的列表
    procedure DoGetMyAttentionListExecute(ATimerTask:TObject);
    procedure DoGetMyAttentionListExecuteEnd(ATimerTask:TObject);
  private
    FFilterCancelFID:Integer;
    //取消关注
    procedure DoCancelAttentionExecute(ATimerTask:TObject);
    procedure DoCancelAttentionExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    FContentOperation:TContentOperation;
    FrameHistroy: TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    //清空
    procedure Clear;
    //加载列表
    procedure Load();
    { Public declarations }
  end;

var
  GlobalMyAttentionFrame:TFrameMyAttention;

implementation

uses
  MainForm,
  MainFrame,
  GetUserInfoFrame;

{$R *.fmx}

{ TFrameMyAttention }

procedure TFrameMyAttention.btnAddFoucsClick(Sender: TObject);
begin
//  //取消关注的人的FID
//  FFilterCancelFID:=GetItemJsonObject(Self.lbList.Prop.InteractiveItem).Json.S['focused_user_fid'].ToInteger;
//  //取消关注
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                          DoCancelAttentionExecute,
//                          DoCancelAttentionExecuteEnd);

  //关注用户
  if Self.lbList.Prop.InteractiveItem.Detail='+关注' then
  begin
    FContentOperation.FContentItem:=Self.lbList.Prop.InteractiveItem;
    FContentOperation.tteUserFocusPublisher.Run;
    lbList.Prop.StartPullDownRefresh;
  end;
end;

procedure TFrameMyAttention.btnReturnClick(Sender: TObject);
begin
  ClearOnReturnFrameEvent(Self);
  //返回
  HideFrame(Self, hfcttBeforeReturnFrame);
  ReturnFrame(Self.FrameHistroy);
end;

procedure TFrameMyAttention.Clear;
begin
  Self.lbList.Prop.Items.BeginUpdate;
  try
    Self.lbList.Prop.Items.Clear(True);
  finally
    Self.lbList.Prop.Items.EndUpdate();
  end;

  Self.lbOrderState.Prop.Items.FindItemByCaption('关注').Selected:=True;
  Self.lbOrderState.Prop.Items.FindItemByCaption('粉丝').Selected:=False;

  FFilterString:=Self.lbOrderState.Prop.Items.FindItemByCaption('关注').Caption;
end;

constructor TFrameMyAttention.Create(AOwner: TComponent);
begin
  inherited;
  FContentOperation:=TContentOperation.Create;
  FContentOperation.FContentListBox:=TSkinFMXListView(Self.lbList);

  Self.lbList.Prop.Items.BeginUpdate;
  try
    Self.lbList.Prop.Items.Clear(True);
  finally
    Self.lbList.Prop.Items.EndUpdate();
  end;



end;

destructor TFrameMyAttention.Destroy;
begin
  FreeAndNil(FContentOperation);
  inherited;
end;

procedure TFrameMyAttention.DoCancelAttentionExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try

    TTimerTask(ATimerTask).TaskDesc:=
      SimpleCallAPI('user_unfocused_user',
                    nil,
                    ContentCenterInterfaceUrl,
                    ['appid',
                    'user_fid',
                    'key',
                    'focused_user_fid'],
                    [AppID,
                    GlobalManager.User.fid,
                    '',
                    FFilterCancelFID
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

procedure TFrameMyAttention.DoCancelAttentionExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin

  if TTimerTask(ATimerTask).TaskTag=0 then
  begin
    ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
    if ASuperObject.I['Code']=200 then
    begin

      //取消成功,刷新列表
      Load;

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

end;

procedure TFrameMyAttention.DoGetMyAttentionListExecute(ATimerTask: TObject);
var
  AWhereKeyJson:String;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try

    if FFilterString='关注' then
    begin
      AWhereKeyJson:=GetWhereConditions(['appid','user_fid'],
                [AppID,GlobalManager.User.fid]);
    end
    else
    begin
      AWhereKeyJson:=GetWhereConditions(['appid','focused_user_fid'],
                [AppID,GlobalManager.User.fid]);
    end;

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
                    'where_key_json',
                    'order_by',
                    'is_need_sub_query_list'],
                    [AppID,
                    GlobalManager.User.fid,
                    '',
                    'focused_user',
                    1,
                    MaxInt,
                    AWhereKeyJson,
                    'createtime DESC',
                    1
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

procedure TFrameMyAttention.DoGetMyAttentionListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        Self.lbList.Prop.Items.Clear(True);


        Self.lbList.Prop.Items.BeginUpdate;
        try

          //获取成功
          for I := 0 to ASuperObject.O['Data'].A['RecordList'].Length-1 do
          begin
            //创建页面

            AListBoxItem:=Self.lbList.Prop.Items.Add;

            AListBoxItem.CreateOwnDataObject(TSkinItemJsonObject);
            GetItemJsonObject(AListBoxItem).Json:=ASuperObject.O['Data'].A['RecordList'].O[I];


            //赋值
            if FFilterString='关注' then
            begin
              //关注的人
              //Self.btnCancel.Visible:=True;
              //用户名
              AListBoxItem.Caption:=ASuperObject.O['Data'].A['RecordList'].O[I].S['focused_user_name'];
              if ASuperObject.O['Data'].A['RecordList'].O[I].I['is_focused_eachother']=1 then
                AListBoxItem.Detail:='相互关注'
              else
                AListBoxItem.Detail:='已关注';
              AListBoxItem.Detail1:=ASuperObject.O['Data'].A['RecordList'].O[I].S['focused_user_sign'];
              //用户头像
              AListBoxItem.Icon.Url:=GetImageUrl(ASuperObject.O['Data'].A['RecordList'].O[I].S['focused_head_pic_path'],itUserHead);
              AListBoxItem.Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
              AListBoxItem.Icon.IsClipRound:=True;
            end
            else
            begin
              //粉丝
//              Self.btnCancel.Visible:=False;
              //用户名
              AListBoxItem.Caption:=ASuperObject.O['Data'].A['RecordList'].O[I].S['user_name'];
              if ASuperObject.O['Data'].A['RecordList'].O[I].I['is_focused_eachother']=1 then
                AListBoxItem.Detail:='相互关注'
              else
                AListBoxItem.Detail:='+关注';
              AListBoxItem.Detail1:=ASuperObject.O['Data'].A['RecordList'].O[I].S['sign'];
              //用户头像
              AListBoxItem.Icon.Url:=GetImageUrl(ASuperObject.O['Data'].A['RecordList'].O[I].S['head_pic_path'],itUserHead);
              AListBoxItem.Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
              AListBoxItem.Icon.IsClipRound:=True;
            end;

          end;

        finally
          Self.lbList.Prop.Items.EndUpdate();
        end;



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
    //停止刷新
    Self.lbList.Prop.StopPullDownRefresh();
  end;
end;

procedure TFrameMyAttention.lbListClickItem(AItem: TSkinItem);
var
  AIsFocused:Boolean;
  ASuperObject:ISuperObject;
begin
  //查看用户详情
  HideFrame(Self,hfcttBeforeShowFrame);
  ShowFrame(TFrame(GlobalGetUserInfoFrame),TFrameGetUserInfo);

  ASuperObject:=GetItemJsonObject(AItem).Json;
  if Self.FFilterString='关注' then
  begin
    AIsFocused:=True;

    //我关注的用户
    GlobalGetUserInfoFrame.Clear;
    GlobalGetUserInfoFrame.FIsFocused:=AIsFocused;
    GlobalGetUserInfoFrame.Load(
        ASuperObject.s['focused_user_fid'],
        ASuperObject.S['focused_user_name'],
        ASuperObject.S['focused_head_pic_path'],
        ASuperObject.S['focused_user_sign'],
        '',
        ASuperObject.I['fastmsg_user_id'],
        ASuperObject.I['is_vip'] ,
        ASuperObject
        );

  end
  else
  begin
    AIsFocused:=False;
    if ASuperObject.I['is_focused_eachother']=1 then
      GlobalGetUserInfoFrame.FIsFocused:=true
    else
      GlobalGetUserInfoFrame.FIsFocused:=False;
//    //粉丝,关注我的用户
    GlobalGetUserInfoFrame.Load(
        ASuperObject.S['user_fid'],
        ASuperObject.S['user_name'],
        ASuperObject.S['head_pic_path'],
        ASuperObject.S['sign'],
        '',
        ASuperObject.I['fastmsg_user_id'],
        ASuperObject.I['is_vip'] ,
        ASuperObject
        );
  end;


//  GlobalGetUserInfoFrame.LoadFocuesdUser(
//    GetItemJsonObject(AItem).Json,AIsFocused);
end;

procedure TFrameMyAttention.lbListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
  if AItem.Detail='+关注' then
  begin
    btnAddFoucs.SelfOwnMaterialToDefault.BackColor.BorderWidth:=0;
    btnAddFoucs.SelfOwnMaterialToDefault.BackColor.IsFill:=True;
    btnAddFoucs.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColors.White;

  end else
  begin
    btnAddFoucs.SelfOwnMaterialToDefault.BackColor.BorderWidth:=1;
    btnAddFoucs.SelfOwnMaterialToDefault.BackColor.IsFill:=False;
    btnAddFoucs.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColors.Gray;
  end;
end;

procedure TFrameMyAttention.lbListPullDownRefresh(Sender: TObject);
begin
  //下拉刷新
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                       DoGetMyAttentionListExecute,
                       DoGetMyAttentionListExecuteEnd);
end;

procedure TFrameMyAttention.lbOrderStateClickItem(AItem: TSkinItem);
begin
  Load;
end;

procedure TFrameMyAttention.Load;
var
  I: Integer;
begin
  for I := 0 to Self.lbOrderState.Prop.Items.Count-1 do
  begin
    if Self.lbOrderState.Prop.Items[I].Selected=True then
    begin
      FFilterString:=Self.lbOrderState.Prop.Items[I].Caption;
      pnlToolBar.Caption:=FFilterString;
    end;
  end;

  Self.lbList.Prop.StartPullDownRefresh;
end;

end.
