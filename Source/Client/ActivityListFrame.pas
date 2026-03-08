unit ActivityListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uConst,
  StrUtils,
  //翻译
  FMX.Consts,
  uBaseLog,

  Math,
  uAppCommon,
  uSkinItems,
  uSkinBufferBitmap,
  uFuncCommon,
  uFileCommon,
  uOpenClientCommon,
  uManager,
  uTimerTask,
  uDrawPicture,
  uUIFunction,
  uRestInterfaceCall,
  uSkinItemJsonHelper,
  MessageBoxFrame,
  WaitingFrame,
  HintFrame,
  uOpenCommon,
  WebBrowserFrame,
  ViewPictureListFrame,
  uSkinControlGestureManager,
//  ListItemStyleFrame_DelphiGift,
//  ListItemStyleFrame_PetchipArticle,
//  ListItemStyleFrame_PetchipGiftLost,
//  GiftInfoFrame,
//  ShareBarCodeFrame,
  uUrlPicture,
  uDownloadPictureManager,
  ListItemStyleFrame_GameGiftPackage,
  ListItemStyleFrame_GameActivity,

//  GiftPackageListFrame,

  uDrawCanvas,
  XSuperObject,
  XSuperJson,
  uMobileUtils,
  uBaseHttpControl,
  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,

  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinFireMonkeyImage,
  uSkinFireMonkeyLabel, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, uSkinFireMonkeyFrameImage, uSkinLabelType,
  uSkinImageType, uSkinFrameImageType,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinButtonType, uBaseSkinControl,
  uSkinPanelType, uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinCustomListType, uSkinVirtualListType, uSkinListViewType,
  uSkinFireMonkeyListView, uTimerTaskEvent;

type
  TFrameActivityList = class(TFrame)
    lvData: TSkinFMXListView;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    tteGetData: TTimerTaskEvent;
    tteUserTakeGift: TTimerTaskEvent;
    tmrInvalidate: TTimer;
    tmrLoad: TTimer;
    procedure lvDataPullDownRefresh(Sender: TObject);
    procedure lvDataPullUpLoadMore(Sender: TObject);
    procedure tteGetDataExecute(ATimerTask: TTimerTask);
    procedure tteGetDataExecuteEnd(ATimerTask: TTimerTask);
    procedure lvDataPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure lvDataGetItemBufferCacheTag(Sender: TObject; AItem: TSkinItem;
      var ACacheTag: Integer);
    procedure lvDataClickItemDesignerPanelChild(Sender: TObject;
      AItem: TBaseSkinItem; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
      AChild: TFmxObject);
    procedure tteUserTakeGiftBegin(ATimerTask: TTimerTask);
    procedure tteUserTakeGiftExecute(ATimerTask: TTimerTask);
    procedure tteUserTakeGiftExecuteEnd(ATimerTask: TTimerTask);
    procedure btnReturnClick(Sender: TObject);
    procedure pnlToolBarClick(Sender: TObject);
    procedure tmrLoadTimer(Sender: TObject);
  private
    FPageIndex:Integer;
    FGiftItem:TSkinItem;
    procedure DoReturnFrameFromGiftInfoFrame(AFrame:TFrame);

    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
  public
    FFilterGroupId:String;

    procedure Clear;
    procedure Load;
    { Public declarations }
  end;

procedure LoadGiftItem(AListViewItem:TSkinItem;ADataJson:ISuperObject;AListControl:TSkinVirtualList);

var
  GlobalActivityListFrame:TFrameActivityList;

implementation

uses
  MainForm,
  MainFrame,
//  UserInfoFrame,
//  GetUserInfoFrame,
  UserInfoFrame;

{$R *.fmx}

procedure LoadGiftItem(AListViewItem:TSkinItem;ADataJson: ISuperObject;AListControl:TSkinVirtualList);
begin
  AListViewItem.CreateOwnDataObject(TSkinItemJsonObject);
  GetItemJsonObject(AListViewItem).Json:=ADataJson;

  AListViewItem.ItemType:=sitDefault;

  //ItemCaption: 活动名称
  //ItemDetail:  活动详情
  //ItemDetail1: 活动奖励1
  //ItemDetail2: 活动奖励2
  //ItemDetail3: 活动奖励3

  //活动的LOGO和名称,介绍
  //AListViewItem.Icon.Url:=GetImageUrl(ADataJson.S['shop_logo_pic_path']);

  AListViewItem.Caption:=ADataJson.S['name'];
  AListViewItem.Detail:=ADataJson.S['description'];

  //礼包奖励数量
//  AListViewItem.Detail1:=IntToStr(ADataJson.I['gift_score']);
//  AListViewItem.Detail2:=IntToStr(ADataJson.I['gift_score']);
//  AListViewItem.Detail3:=IntToStr(ADataJson.I['gift_score']);

  AListViewItem.SubItems.Clear;
  AListViewItem.SubItems.Add('');
  AListViewItem.SubItems.Add('');
  AListViewItem.SubItems.Add('');
  //礼包的物品列表
  if ADataJson.A['GoodsInfo'].Length>0 then
  begin
    AListViewItem.Detail1:=IntToStr(ADataJson.A['GoodsInfo'].O[0].I['gift_count']);
    AListViewItem.SubItems[0]:=GetImageUrl(ADataJson.A['GoodsInfo'].O[0].S['goods_pic1_path']);
  end;
  if ADataJson.A['GoodsInfo'].Length>1 then
  begin
    AListViewItem.Detail2:=IntToStr(ADataJson.A['GoodsInfo'].O[1].I['gift_count']);
    AListViewItem.SubItems[1]:=GetImageUrl(ADataJson.A['GoodsInfo'].O[1].S['goods_pic1_path']);
  end;
  if ADataJson.A['GoodsInfo'].Length>2 then
  begin
    AListViewItem.Detail3:=IntToStr(ADataJson.A['GoodsInfo'].O[2].I['gift_count']);
    AListViewItem.SubItems[2]:=GetImageUrl(ADataJson.A['GoodsInfo'].O[2].S['goods_pic1_path']);
  end;

//  uBaseLog.OutputDebugString('AListViewItem.Height '+FloatToStr(AListViewItem.Height));
end;

procedure TFrameActivityList.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then Exit;

  HideFrame;
  ReturnFrame;
end;

procedure TFrameActivityList.Clear;
begin

end;

constructor TFrameActivityList.Create(AOwner: TComponent);
begin
  inherited;

  Self.lvData.Prop.Items.BeginUpdate;
  try
    Self.lvData.Prop.Items.Clear(True);
  finally
    Self.lvData.Prop.Items.EndUpdate;
  end;
  Self.lvData.Prop.FDefaultItemStyleSetting.IsUseCache:=True;

end;

procedure TFrameActivityList.DoReturnFrameFromGiftInfoFrame(AFrame: TFrame);
begin

end;

procedure TFrameActivityList.Load;
begin
  tteGetData.Run();
end;

procedure TFrameActivityList.lvDataClickItemDesignerPanelChild(
  Sender: TObject; AItem: TBaseSkinItem;
  AItemDesignerPanel: TSkinFMXItemDesignerPanel; AChild: TFmxObject);
var
//  AUrlPicture:TUrlPicture;
  AGiftJson:ISuperObject;
//  AThumbBitmap:TBitmap;

begin

  if GetItemJsonObject(Self.lvData.Prop.InteractiveItem)=nil then Exit;
  if GetItemJsonObject(Self.lvData.Prop.InteractiveItem).Json=nil then Exit;
  AGiftJson:=GetItemJsonObject(Self.lvData.Prop.InteractiveItem).Json;

  if (AChild.Name='btnTake') then
  begin
      if (AGiftJson.I['is_finished']=1) and (AGiftJson.I['is_taked']=0) then
      begin
        //领取礼包
        FGiftItem:=Self.lvData.Prop.InteractiveItem;

        //有些红包可以领取多张
        //用户领取店铺红包
        Self.tteUserTakeGift.TaskOtherInfo.Values['promotion_fid']:=IntToStr(AGiftJson.I['fid']);
        Self.tteUserTakeGift.TaskOtherInfo.Values['promotion_Score']:=IntToStr(AGiftJson.A['GoodsInfo'].O[0].I['gift_count']);
        Self.tteUserTakeGift.Run();

        //ShowMessage('领取中！');

      end
      else if AGiftJson.I['is_taked']=1 then
      begin
          ShowMessage('您已领取过此活动奖励，请勿重复领取！');
      end
      else if AGiftJson.I['is_finished']=0 then
      begin
          //ShowMessage('您未完成此活动，请完成后再领取！');
          //ShowFrame(TFrame(GlobalActivityTipFrame),TFrameActivityTip,Application.MainForm,nil,nil,nil,Application,True,True,ufsefAlpha);

          //ShowMessageBoxFrame(CurrentFrame,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
          ShowMessageBoxFrame(nil,AGiftJson.S['description'],'',TMsgDlgType.mtCustom,['确定'],nil,nil,'任务提示');
      end;

  end;

end;

procedure TFrameActivityList.lvDataGetItemBufferCacheTag(Sender: TObject;
  AItem: TSkinItem; var ACacheTag: Integer);
begin
  ACacheTag:=Integer(AItem);
end;

  function RemoveUnicodeProxyChar(AStr:String):String;
  var
    I:Integer;
  begin
    Result:=AStr;

  end;

procedure TFrameActivityList.lvDataPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AListStyleFrame:TFrameListItemStyle_GameActivity;
  AItemDataJson:ISuperObject;

begin
  if AItem.DataObject=nil then Exit;
  if TSkinItemJsonObject(AItem.DataObject).Json=nil then Exit;

  AItemDataJson:=GetItemJsonObject(AItem).Json;

  //准备控件
  if (AItemDesignerPanel<>nil)
    //设计面板是内容内容
    and (AItemDesignerPanel.Parent is TFrameListItemStyle_GameActivity) then
  begin

      AListStyleFrame:=TFrameListItemStyle_GameActivity(AItemDesignerPanel.Parent);

      AListStyleFrame.imgGoods1.Visible:=(AItem.Detail1<>'');
      AListStyleFrame.imgGoods2.Visible:=(AItem.Detail2<>'');
      AListStyleFrame.imgGoods3.Visible:=(AItem.Detail3<>'');

      //礼包的物品列表
      AListStyleFrame.imgGoods1.Prop.Picture.PictureDrawType:=pdtUrl;
      AListStyleFrame.imgGoods1.Prop.Picture.Url:=AItem.SubItems[0];
      FMX.Types.Log.d('OrangeUI imgGoods1 '+AItem.SubItems[0]);

      AListStyleFrame.imgGoods2.Prop.Picture.PictureDrawType:=pdtUrl;
      AListStyleFrame.imgGoods2.Prop.Picture.Url:=AItem.SubItems[1];
      FMX.Types.Log.d('OrangeUI imgGoods2 '+AItem.SubItems[1]);

      AListStyleFrame.imgGoods3.Prop.Picture.PictureDrawType:=pdtUrl;
      AListStyleFrame.imgGoods3.Prop.Picture.Url:=AItem.SubItems[2];
      FMX.Types.Log.d('OrangeUI imgGoods3 '+AItem.SubItems[2]);

      //活动是否已领取
      AListStyleFrame.btnTake.Enabled:=True;

      if AItemDataJson.I['is_taked']=1 then
      begin
        AListStyleFrame.btnTake.Prop.IsPushed:=True;
        AListStyleFrame.btnTake.Caption:='已领取';
        AListStyleFrame.btnTake.Enabled:=False;
        AListStyleFrame.btnTake.SelfOwnMaterial.BackColor.FillColor.Color:=$FFebebeb;
        AListStyleFrame.btnTake.SelfOwnMaterial.BackColor.BorderWidth:=0;
        //AListStyleFrame.btnTake.SelfOwnMaterial.BackColor.BorderColor.Color:=TAlphaColorRec.Gray;
        AListStyleFrame.btnTake.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.Gray;
        exit;
      end;

      //活动是否已完成
      if AItemDataJson.I['is_finished']=1 then
      begin
        AListStyleFrame.btnTake.Prop.IsPushed:=False;
        AListStyleFrame.btnTake.Caption:='领取';
        AListStyleFrame.btnTake.SelfOwnMaterial.BackColor.FillColor.Color:=$FFFAC864;
        AListStyleFrame.btnTake.Material.DrawCaptionParam.FontColor:=TAlphaColorRec.White;
      end;

      //活动是否已完成
      if AItemDataJson.I['is_finished']=0 then
      begin
        AListStyleFrame.btnTake.Prop.IsPushed:=False;
        AListStyleFrame.btnTake.Caption:='去完成';
      end;

  end;

end;

procedure TFrameActivityList.lvDataPullDownRefresh(Sender: TObject);
begin
  Self.tteGetData.Run;
end;

procedure TFrameActivityList.lvDataPullUpLoadMore(Sender: TObject);
begin
  Self.tteGetData.Run;
end;

procedure TFrameActivityList.pnlToolBarClick(Sender: TObject);
begin
  //
end;

procedure TFrameActivityList.tmrLoadTimer(Sender: TObject);
begin
  Self.tmrLoad.Enabled:=False;

  Self.lvData.Prop.StartPullDownRefresh;

end;

procedure TFrameActivityList.tteGetDataExecute(ATimerTask: TTimerTask);
begin

  //出错
  TTimerTask(ATimerTask).TaskTag:=TASK_FAIL;
  try
    TTimerTask(ATimerTask).TaskDesc:=
        SimpleCallAPI('get_user_shop_promotions',
            nil,
            ContentCenterInterfaceUrl,
            ['appid',
            'user_fid',
            'key',
            'filter_state'
            ],
            [AppID,
            GlobalManager.User.fid,
            GlobalManager.User.key,
            //进行中的礼包活动
            'ongoing'
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

procedure TFrameActivityList.tteGetDataExecuteEnd(ATimerTask: TTimerTask);
var
  I:Integer;
  ASuperObject:ISuperObject;
  ASuperArray:ISuperArray;
  AListViewItem:TSkinListViewItem;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=TASK_SUCC then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
          //获取列表成功
          ASuperArray:=ASuperObject.O['Data'].A['ShopPromotionList'];

          Self.lvData.Prop.Items.BeginUpdate;
          try
            //if FPageIndex=0 then
            //begin
              Self.lvData.Prop.Items.Clear(True);
            //end;

            for I := 0 to ASuperArray.Length-1 do
            begin
                AListViewItem:=Self.lvData.Prop.Items.Add;
                LoadGiftItem(AListViewItem,ASuperArray.O[I],lvData);

            end;

          finally
            Self.lvData.Prop.Items.EndUpdate();
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

    //刷新
    Self.lvData.Prop.StopPullDownRefresh('刷新成功!',600);

  end;

end;

procedure TFrameActivityList.tteUserTakeGiftBegin(
  ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(nil,'处理中...');
end;

procedure TFrameActivityList.tteUserTakeGiftExecute(
  ATimerTask: TTimerTask);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=
        SimpleCallAPI('user_take_finished',
                      nil,
                      ContentCenterInterfaceUrl,
                      ['appid',
                      'user_fid',
                      'key',
                      'shop_promotion_fid',
                      'shop_promotion_score'],     //活动奖励的积分额度
                      [AppID,
                      GlobalManager.User.fid,
                      GlobalManager.User.key,
                      //红包活动FID
                      ATimerTask.TaskOtherInfo.Values['promotion_fid'],
                      ATimerTask.TaskOtherInfo.Values['promotion_score']
                      ],
                                        GlobalRestAPISignType,
                                        GlobalRestAPIAppSecret
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

procedure TFrameActivityList.tteUserTakeGiftExecuteEnd(
  ATimerTask: TTimerTask);
var
  ASuperObject:ISuperObject;
  AGiftJson:ISuperObject;
begin
  try

    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          if GetItemJsonObject(FGiftItem)=nil then Exit;
          if GetItemJsonObject(FGiftItem).Json=nil then Exit;
          AGiftJson:=GetItemJsonObject(FGiftItem).Json;

          AGiftJson.I['is_taked']:=1;
          FGiftItem.IsBufferNeedChange:=True;
          Self.lvData.Invalidate;

          //领取成功,刷新页面
          ShowHintFrame(nil,'领取成功!');

  //        //刷新已领取的优惠券
  //        Self.tteGetUserShopCouponList.Run;

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

end.

