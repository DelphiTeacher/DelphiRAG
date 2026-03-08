unit ScoreExchangeListFrame;

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
//  ListItemStyleFrame_ScoreExchange,
  ListItemStyleFrame_ScoreExchangeActivity,


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
  TFrameScoreExchangeList = class(TFrame)
    lvData: TSkinFMXListView;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    tteGetData: TTimerTaskEvent;
    tteUserTakeGift: TTimerTaskEvent;
    tmrInvalidate: TTimer;
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
    procedure lvDataClickItem(AItem: TSkinItem);
    procedure lvDataResize(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure tmrInvalidateTimer(Sender: TObject);
    procedure pnlToolBarClick(Sender: TObject);
  private
    FPageIndex:Integer;
    FGiftItem:TSkinItem;
//    FIslblItemCaptionRegExClickItem:Boolean;
//
//    procedure DoMessageBoxFrameModalResultFromDeleteGift(Sender:TObject);
    procedure DoMessageBoxFrameModalResultFromSureScoreExchange(Sender:TObject);

    procedure DoReturnFrameFromGiftInfoFrame(AFrame:TFrame);

    //获取个人信息
    procedure DoGetUserInfoExecute(ATimerTask:TObject);
    procedure DoGetUserInfoExecuteEnd(ATimerTask:TObject);
//    procedure lblItemCaptionRegExClickItem(AItem: TSkinItem);
//    //处理手势冲突
//    procedure DoListBoxVertManagerPrepareDecidedFirstGestureKind(
//      Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
//      var AIsDecidedFirstGestureKind: Boolean;
//      var ADecidedFirstGestureKind:TGestureKind);

    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
  public
    FFilterGroupId:String;

    FFilterPromotionType:String;

//    //所在地址
//    FFilterProvince:String;
//    FFilterCity:String;
//    //是否推荐
//    FFilterIsBest:String;
//    //谁发布的内容
//    FFilterUserFID:String;
//    //谁发布的内容
//    FFilterPetFID:String;
//    //谁收藏的内容
//    FFilterFavUserFID:String;

    procedure Clear;
    procedure Load;
    { Public declarations }
  end;


procedure LoadGiftItem(AListViewItem:TSkinItem;ADataJson:ISuperObject;AListControl:TSkinVirtualList);


var
  GlobalScoreExchangeListFrame:TFrameScoreExchangeList;


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


  if ADataJson.S['promotion_type']='score_exchange' then
  begin
      //活动和积分兑换显示第一个商品的图标
      if ADataJson.Contains('GoodsInfo') and (ADataJson.A['GoodsInfo'].Length>0) then
      begin
        AListViewItem.Icon.Url:=GetImageUrl(ADataJson.A['GoodsInfo'].O[0].S['goods_pic1_path']);
        //能换取多少个
        AListViewItem.Detail3:=IntToStr(ADataJson.A['GoodsInfo'].O[0].I['gift_count']);
      end;
      //需要多少积分
      AListViewItem.Detail:=IntToStr(ADataJson.I['exchange_score'])+'积分';
      //本日限兑0/10
      AListViewItem.Detail1:='本日限兑'+IntToStr(ADataJson.I['my_daily_taked_count'])
                              +'/'+IntToStr(ADataJson.I['daily_get_coupon_count_per_user']);
  end
  else// if ADataJson.S['promotion_type']='gift' then
  begin
      //游戏礼包显示游戏的LOGO和名称,介绍
      AListViewItem.Icon.Url:=GetImageUrl(ADataJson.S['shop_logo_pic_path']);
      //1个礼包待领取
      AListViewItem.Detail:='';
      //礼包名称和描述
      AListViewItem.Detail1:=ADataJson.S['name'];
      AListViewItem.Detail2:=ADataJson.S['description'];


      AListViewItem.SubItems.Clear;
      AListViewItem.SubItems.Add('');
      AListViewItem.SubItems.Add('');
      AListViewItem.SubItems.Add('');
      //礼包的物品列表
      if ADataJson.A['GoodsInfo'].Length>0 then
      begin
        AListViewItem.Detail3:=ADataJson.A['GoodsInfo'].O[0].S['description'];
        AListViewItem.SubItems[0]:=GetImageUrl(ADataJson.A['GoodsInfo'].O[0].S['goods_pic1_path']);
      end;
      if ADataJson.A['GoodsInfo'].Length>1 then
      begin
        AListViewItem.Detail4:=ADataJson.A['GoodsInfo'].O[1].S['description'];
        AListViewItem.SubItems[1]:=GetImageUrl(ADataJson.A['GoodsInfo'].O[1].S['goods_pic1_path']);
      end;
      if ADataJson.A['GoodsInfo'].Length>2 then
      begin
        AListViewItem.Detail5:=ADataJson.A['GoodsInfo'].O[2].S['description'];
        AListViewItem.SubItems[2]:=GetImageUrl(ADataJson.A['GoodsInfo'].O[2].S['goods_pic1_path']);
      end;
  end;

  AListViewItem.Caption:=ADataJson.S['name'];










//  uBaseLog.OutputDebugString('AListViewItem.Height '+FloatToStr(AListViewItem.Height));
end;


procedure TFrameScoreExchangeList.DoGetUserInfoExecute(ATimerTask: TObject);
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

procedure TFrameScoreExchangeList.DoGetUserInfoExecuteEnd(ATimerTask: TObject);
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
        GlobalManager.User.score:=ASuperObject.O['Data'].A['User'].O[0].F['score'];
//        FUsedMoney:=ASuperObject.O['Data'].A['User'].O[0].F['score'];
//        Self.mcMoney.Prop.Items[0].Text:=Format('%.2f',[FUsedMoney]);
//        Self.lbList.Prop.StartPullDownRefresh;
        if Self.lvData.Prop.Items.FindItemByName('my_score')<>nil then
        begin
          Self.lvData.Prop.Items.FindItemByName('my_score').Caption:=FloatToStr(GlobalManager.User.score);
        end;


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

procedure TFrameScoreExchangeList.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then Exit;

  HideFrame;
  ReturnFrame;
end;

procedure TFrameScoreExchangeList.Clear;
begin
//  //所在地址
//  FFilterProvince:='';
//  FFilterCity:='';
//  //是否推荐
//  FFilterIsBest:='';
//  //谁发布的内容
//  FFilterUserFID:='';
//  //谁发布的内容
//  FFilterPetFID:='';
//  //谁收藏的内容
//  FFilterFavUserFID:='';

end;

constructor TFrameScoreExchangeList.Create(AOwner: TComponent);
begin
  inherited;

  Self.lvData.Prop.Items.BeginUpdate;
  try
    Self.lvData.Prop.Items.ClearItemsByType(sitDefault);
  finally
    Self.lvData.Prop.Items.EndUpdate;
  end;
  Self.lvData.Prop.FDefaultItemStyleSetting.IsUseCache:=True;


  FFilterPromotionType:='score_exchange';

//  //处理手势冲突
//  Self.lvData.Prop.VertControlGestureManager.IsNeedDecideFirstGestureKind:=True;
//  Self.lvData.Prop.VertControlGestureManager.OnPrepareDecidedFirstGestureKind:=
//    Self.DoListBoxVertManagerPrepareDecidedFirstGestureKind;

end;

//procedure TFrameGiftList.DoListBoxVertManagerPrepareDecidedFirstGestureKind(
//  Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
//  var AIsDecidedFirstGestureKind: Boolean;
//  var ADecidedFirstGestureKind: TGestureKind);
//var
//  AIsInImageListViewerRect:Boolean;
//  AImageListViewerRect:TRectF;
//  I: Integer;
//  ADrawRect:TRectF;
//  AItemDrawRect:TRectF;
//begin
//  //广告轮播Item的绘制区域
//  AIsInImageListViewerRect:=False;
//
//
//  ADrawRect:=RectF(0,0,Self.lvData.Width,Self.lvData.Height);
//  for I := 0 to Self.lvData.Prop.Items.Count-1 do
//  begin
//
//      AItemDrawRect:=Self.lvData.Prop.Items[I].ItemDrawRect;
//
//      if AItemDrawRect.IntersectsWith(ADrawRect) then
//      begin
//          AImageListViewerRect:=Self.lvData.Prop.Items[I].FDataRect;
//          OffsetRect(AImageListViewerRect,AItemDrawRect.Left,AItemDrawRect.Top);
//          if PtInRect(AImageListViewerRect,PointF(AMouseMoveX,AMouseMoveY)) then
//          begin
//              //在广告轮播控件内,那么要检查初始手势方向
//              AIsInImageListViewerRect:=True;
//              Exit;
//          end;
//      end;
//  end;
//
//
//  if not AIsInImageListViewerRect then
//  begin
//      //不在在广告轮播控件内,那么随意滑动
//      AIsDecidedFirstGestureKind:=True;
//      ADecidedFirstGestureKind:=TGestureKind.gmkVertical;
//  end;
//
//end;

//procedure TFrameScoreExchangeList.DoMessageBoxFrameModalResultFromDeleteGift(Sender: TObject);
//begin
//  if TFrameMessageBox(Sender).ModalResult='确定' then
//  begin
//    Self.tteUserDelGift.Run;
//  end;
//end;

procedure TFrameScoreExchangeList.DoMessageBoxFrameModalResultFromSureScoreExchange(
  Sender: TObject);
begin
  if TFrameMessageBox(Sender).ModalResult='确认兑换' then
  begin
    //有些红包可以领取多张
    //用户领取店铺红包
    Self.tteUserTakeGift.TaskOtherInfo.Values['promotion_fid']:=IntToStr(FGiftItem.Json.I['fid']);
    Self.tteUserTakeGift.Run();
  end;
end;

procedure TFrameScoreExchangeList.DoReturnFrameFromGiftInfoFrame(AFrame: TFrame);
begin
//  //如果在详情页面评论过或点赞收藏过要更新
//  if Self.lvData.Prop.InteractiveItem<>nil then
//  begin
//    //因为只有Prop变的时候,IsBufferNeedChange才会变,所以要加
//    Self.lvData.Prop.InteractiveItem.IsBufferNeedChange:=True;
//    LoadGiftItem(Self.lvData.Prop.InteractiveItem,GlobalGiftInfoFrame.FGiftDataJson,lvData);
//    Self.lvData.Invalidate;
//  end;
end;

//procedure TFrameGiftList.lblItemCaptionRegExClickItem(AItem: TSkinItem);
//var
//  AGiftJson:ISuperObject;
//begin
//  //
//  if AItem.Name='Link' then
//  begin
//      FIslblItemCaptionRegExClickItem:=True;
//
//      //是网页
//      //网页链接
//      HideFrame;
//
//      //显示网页界面
//      ShowFrame(TFrame(GlobalWebBrowserFrame),TFrameWebBrowser,frmMain,nil,nil,nil,Application);
//      GlobalWebBrowserFrame.LoadUrl(AItem.Caption);
//
//  end
//  else
//  begin
//
//      if CurrentFrame<>GlobalGiftInfoFrame then
//      begin
//          AGiftJson:=GetItemJsonObject(Self.lvData.Prop.InteractiveItem).Json;
//          //查看详情
//          //显示内容详情
//          HideFrame;
//          ShowFrame(TFrame(GlobalGiftInfoFrame),TFrameGiftInfo,DoReturnFrameFromGiftInfoFrame);
//          GlobalGiftInfoFrame.Load(
//              AGiftJson,
//              Self.lvData.OnPrepareDrawItem);
//          Exit;
//      end;
//
//  end;
//end;

procedure TFrameScoreExchangeList.Load;
begin
  if Self.lvData.Prop.Items.FindItemByName('my_score')<>nil then
  begin
    Self.lvData.Prop.Items.FindItemByName('my_score').Caption:=FloatToStr(GlobalManager.User.score);
  end;

//  Self.tmrLoad.Enabled:=False;

//  Self.lvData.Prop.StartPullDownRefresh;

  FPageIndex:=1;
  Self.tteGetData.Run;

//  Self.tmrLoad.Enabled:=True;


  //获取用户积分详情
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                          DoGetUserInfoExecute,
                          DoGetUserInfoExecuteEnd,
                          'GetUserInfo');

end;

procedure TFrameScoreExchangeList.lvDataClickItem(AItem: TSkinItem);
var
  APromotionJson:ISuperObject;
begin
  FGiftItem:=AItem;
  APromotionJson:=AItem.Json;

  if (APromotionJson<>nil)
    and (APromotionJson.I['my_daily_taked_count']<APromotionJson.I['daily_get_coupon_count_per_user'])
    and (APromotionJson.A['GoodsInfo'].Length>0) then
  begin
    //可领取
    ShowMessageBoxFrame(nil,
                        '确认用'+IntToStr(APromotionJson.I['exchange_score'])+'积分'
                        +'兑换'+APromotionJson.A['GoodsInfo'].O[0].S['goods_name']+'x'+IntToStr(APromotionJson.A['GoodsInfo'].O[0].I['gift_count']),
                        '',
                        TMsgDlgType.mtCustom,
                        ['暂时不换','确认兑换'],
                        DoMessageBoxFrameModalResultFromSureScoreExchange,
                        nil,
                        '确认兑换该奖励吗?'
                        );

  end;

//  //显示内容详情
//  HideFrame;
//  ShowFrame(TFrame(GlobalGiftInfoFrame),TFrameGiftInfo,DoReturnFrameFromGiftInfoFrame);
//  GlobalGiftInfoFrame.Load(
//        GetItemJsonObject(AItem).Json,
//        Self.lvData.OnPrepareDrawItem);
end;

procedure TFrameScoreExchangeList.lvDataClickItemDesignerPanelChild(
  Sender: TObject; AItem: TBaseSkinItem;
  AItemDesignerPanel: TSkinFMXItemDesignerPanel; AChild: TFmxObject);
//var
////  AUrlPicture:TUrlPicture;
//  AGiftJson:ISuperObject;
////  AThumbBitmap:TBitmap;

begin

//  if GetItemJsonObject(Self.lvData.Prop.InteractiveItem)=nil then Exit;
//  if GetItemJsonObject(Self.lvData.Prop.InteractiveItem).Json=nil then Exit;
//  AGiftJson:=GetItemJsonObject(Self.lvData.Prop.InteractiveItem).Json;
//
//
//  if (AChild.Name='btnTake') then
//  begin
//      if AGiftJson.I['is_taked']=0 then
//      begin
//          //领取礼包
//          FGiftItem:=Self.lvData.Prop.InteractiveItem;
//
//          //有些红包可以领取多张
//          //用户领取店铺红包
//          Self.tteUserTakeGift.TaskOtherInfo.Values['promotion_fid']:=IntToStr(AGiftJson.I['fid']);
//          Self.tteUserTakeGift.Run();
//
//      end;
//  end;


//  //这些操作需要登录才能的操作
//  if (AChild.Name='btnFocus')
//    or (AChild.Name='btnFocused')
//    or (AChild.Name='btnFavState')
//    or (AChild.Name='btnLikeState')
//    or (AChild.Name='lblDelete')
//    or (AChild.Name='btnFind')
//    then
//  begin
//
//          //这些操作需要登录才能的操作
//          if not GlobalManager.IsLogin then
//          begin
//              ShowLoginFrame(True);
//              Exit;
//          end
//          else
//          begin
//              if AChild.Name='btnFocus' then
//              begin
//                  //关注用户
//                  Self.tteUserFocusPublisher.Run;
//                  Exit;
//              end
//              else
//              if AChild.Name='btnFocused' then
//              begin
//                  //取消关注用户
//                  Self.tteUserCancelFocusPublisher.Run;
//                  Exit;
//              end
////              else
////              if AChild.Name='btnFind' then
////              begin
////                  //标记为已寻获
//////                  Self.tteUserFindGiftPet.Run;
////                  if (GetItemJsonObject(Self.lvData.Prop.InteractiveItem).Json.S['type']='_lost') then
////                  begin
////                    //宠物丢失
////                    ShowMessageBoxFrame(Self,
////                                          '是否已寻获?',
////                                          '',
////                                          TMsgDlgType.mtInformation,
////                                          ['确定','取消'],
////                                          Self.DoModalResultFromFindPetMessageBoxFrame,
////                                          nil,
////                                          '',
////                                          ConvertToStringDynArray(['ok','cancel'])
////                                          );
////                  end
////                  else
////                  begin
////                    //宠物寻获
////                    ShowMessageBoxFrame(Self,
////                                          '是否已找到认领失主?',
////                                          '',
////                                          TMsgDlgType.mtInformation,
////                                          ['确定','取消'],
////                                          Self.DoModalResultFromFindPetMessageBoxFrame,
////                                          nil,
////                                          '',
////                                          ConvertToStringDynArray(['ok','cancel'])
////                                          );
////
////                  end;
////                  Exit;
////              end
//              else
//              if AChild.Name='btnFavState' then
//              begin
//                  //收藏和取消收藏
//                  if AGiftJson.O['UserState'].I['is_fav']=0 then
//                  begin
//                    //收藏
//                    Self.tteUserFavGift.Run;
//                  end
//                  else
//                  begin
//                    //取消收藏
//                    Self.tteUserUnFavGift.Run;
//                  end;
//                  Exit;
//              end
//              else
//              if AChild.Name='btnLikeState' then
//              begin
//                  //点赞和取消点赞
//                  if AGiftJson.O['UserState'].I['is_like']=0 then
//                  begin
//                    //点赞
//                    Self.tteUserLikeGift.Run;
//                  end
//                  else
//                  begin
//                    //取消点赞
//                    Self.tteUserUnLikeGift.Run;
//                  end;
//                  Exit;
//              end
//              else if AChild.Name='lblDelete' then
//              begin
//
//                  //隐藏地图
//
//
//
////                  ShowMessageBoxFrame(Self,'确认删除此内容?','',TMsgDlgType.mtInformation,
////                                      ['确定','取消'],
////                                      DoMessageBoxFrameModalResultFromDeleteGift);
//            //      Self.tteUserDelGift.Run;
//                  Exit;
//              end;
//
//          end;
//  end;
//
//
//
//
//  //不需要登录就能的操作
//  if (AChild.Name='imgItemIcon') or (AChild.Name='lblItemDetail') then
//  begin
//      if AGiftJson.V['user_fid']=GlobalManager.User.fid then
//      begin
//           //调到我的账户与安全页面
//           //隐藏
//           HideFrame;//(CurrentFrame);
//           //显示个人信息页面
//           ShowFrame(TFrame(GlobalUserInfoFrame),TFrameUserInfo,frmMain,nil,nil,nil,Application);
//           GlobalUserInfoFrame.FrameHistroy:=CurrentFrameHistroy;
//           GlobalUserInfoFrame.Load(GlobalManager.User);
//           GlobalUserInfoFrame.Sync;
//           Exit;
//      end
//      else
//      begin
////            //查看用户信息
////        //    HideFrame;
////            HideFrame;//(CurrentFrame,hfcttBeforeShowFrame);
////            ShowFrame(TFrame(GlobalGetUserInfoFrame),TFrameGetUserInfo);
////            GlobalGetUserInfoFrame.Load(AGiftJson);
////            Exit;
//      end;
//  end
//  else if (AChild.Name='lblItemCaptionRegEx') and (TSkinListView(AChild).Prop.MouseOverItem<>nil) then
//  begin
//      //点击了内容
////      if TSkinListView(AChild).Prop.MouseOverItem=nil then
////      begin
////
////      end;
//
//      //是网页
//      //网页链接
//      HideFrame;
//
//      //显示网页界面
//      ShowFrame(TFrame(GlobalWebBrowserFrame),TFrameWebBrowser,frmMain,nil,nil,nil,Application);
//      GlobalWebBrowserFrame.LoadUrl(TSkinItem(TSkinListView(AChild).Prop.MouseOverItem).Caption);
//
//  end
//  else if (AChild.Name='btnTransmit') then
//  begin
//      //转发
//  //    HideFrame;
//
//      AUrlPicture:=GetGlobalDownloadPictureManager.FindUrlPicture(
//              GetImageUrl(AGiftJson.S['pic1_path']));
//      if (AUrlPicture=nil)
//        or (AUrlPicture.Picture=nil)
//        or (AUrlPicture.Picture.IsEmpty) then
//      begin
//        ShowHintFrame(nil,'图片正在下载中,请稍候...');
//        exit;
//      end;
//      //生成缩略图
//      AThumbBitmap:=TBitmap.Create;
//      try
//        //100的太模糊,但是大小刚合适
//        uSkinBufferBitmap.CreateThumbBitmap(AUrlPicture.Picture,AThumbBitmap,100,100);
//        AThumbBitmap.SaveToFile(GetApplicationPath+'share_thumb.jpg');
//      finally
//        FreeAndNil(AThumbBitmap);
//      end;
//
////      //微信分享   弹出分享选择框   链接+小图标+自定义文本
////      ShowFrame(TFrame(GlobalShareBarCodeFrame),TFrameShareBarCode,frmMain,nil,nil,nil,Self,False,True,ufsefNone);
////      GlobalShareBarCodeFrame.Load('http://'+ServerHost+'/'+'open/d_community/content.php?appid='+IntToStr(AppID)+'&content_fid='+IntToStr(AGiftJson.I['fid']),
////                                   AGiftJson.S['content'],
////                                   'D区,最前沿的Delphier开发者社区',
////                                   GetApplicationPath+'share_thumb.jpg'
////                                   );
////      GlobalShareBarCodeFrame.ShowMenu;
//      Exit;
//  end
//  else
//  if AChild.Name='btnComment' then
//  begin
////      //显示内容详情
////      HideFrame;
////      ShowFrame(TFrame(GlobalGiftInfoFrame),TFrameGiftInfo,DoReturnFrameFromGiftInfoFrame);
////      GlobalGiftInfoFrame.Load(
////          AGiftJson,
////          Self.lvData.OnPrepareDrawItem);
//      Exit;
//  end
//  else if AChild.Name='lblExpand' then
//  begin
//      //展开/收拢科普短文
//      Self.lvData.Prop.InteractiveItem.Selected:=
//        not Self.lvData.Prop.InteractiveItem.Selected;
//      Self.lvData.Prop.InteractiveItem.Height:=
//          Self.lvData.Prop.CalcItemAutoSize(
//            Self.lvData.Prop.InteractiveItem).cy;
//      Exit;
//  end
//  else
//  if (AChild.Name='imgItemBigPic')
//    or (AChild.Name='imglistviewItemBigPic') then
//  begin
//      //查看图片详情
//      {$IFNDEF IS_LISTVIEW_DEMO}
//      //查看照片信息
//      HideFrame;//(CurrentFrame);
//      //查看照片信息
//      ShowFrame(TFrame(GlobalViewPictureListFrame),TFrameViewPictureList,frmMain,nil,nil,nil);
//      GlobalViewPictureListFrame.Init('照片',
//            nil,
//            0,
//            //原图URL
//            nil
//            );
//      if AGiftJson.S['pic1_path']<>'' then
//      begin
//        GlobalViewPictureListFrame.AddPicture(GetImageUrl(AGiftJson.S['pic1_path']));
//      end;
//      if AGiftJson.S['pic2_path']<>'' then
//      begin
//        GlobalViewPictureListFrame.AddPicture(GetImageUrl(AGiftJson.S['pic2_path']));
//      end;
//      if AGiftJson.S['pic3_path']<>'' then
//      begin
//        GlobalViewPictureListFrame.AddPicture(GetImageUrl(AGiftJson.S['pic3_path']));
//      end;
//      if AGiftJson.S['pic4_path']<>'' then
//      begin
//        GlobalViewPictureListFrame.AddPicture(GetImageUrl(AGiftJson.S['pic4_path']));
//      end;
//      if AGiftJson.S['pic5_path']<>'' then
//      begin
//        GlobalViewPictureListFrame.AddPicture(GetImageUrl(AGiftJson.S['pic5_path']));
//      end;
//      if AGiftJson.S['pic6_path']<>'' then
//      begin
//        GlobalViewPictureListFrame.AddPicture(GetImageUrl(AGiftJson.S['pic6_path']));
//      end;
//      if AGiftJson.S['pic7_path']<>'' then
//      begin
//        GlobalViewPictureListFrame.AddPicture(GetImageUrl(AGiftJson.S['pic7_path']));
//      end;
//      if AGiftJson.S['pic8_path']<>'' then
//      begin
//        GlobalViewPictureListFrame.AddPicture(GetImageUrl(AGiftJson.S['pic8_path']));
//      end;
//      if AGiftJson.S['pic9_path']<>'' then
//      begin
//        GlobalViewPictureListFrame.AddPicture(GetImageUrl(AGiftJson.S['pic9_path']));
//      end;
//      GlobalViewPictureListFrame.ShowPicture('照片',0);
//      {$ENDIF}
//      Exit;
//  end
//  else
//  //点击其他所有的内容
////  if (AChild.Name='imgItemBigPic') or (AChild.Name='lbLikeList') then
//  begin
//      //查看详情
//      //显示内容详情
////      HideFrame;
////      ShowFrame(TFrame(GlobalGiftInfoFrame),TFrameGiftInfo,DoReturnFrameFromGiftInfoFrame);
////      GlobalGiftInfoFrame.Load(
////          AGiftJson,
////          Self.lvData.OnPrepareDrawItem);
//      Exit;
//  end;


end;

procedure TFrameScoreExchangeList.lvDataGetItemBufferCacheTag(Sender: TObject;
  AItem: TSkinItem; var ACacheTag: Integer);
begin
  ACacheTag:=Integer(AItem);
end;


  function RemoveUnicodeProxyChar(AStr:String):String;
  var
    I:Integer;
  begin
    //if(Unicode第一个字节 >=0xD8 && Unicode <=0xDB){
    //    //这是代理区域，表示第1——16平面的字符。每四个字节表示一个单元
    //}
    //else{
    //    //这是正常映射区域，表示第0个平面。每两个字节表示一个单元。
    //}
    Result:=AStr;
//    for I := 0 to Result.Length-1 do
//    begin
//        {$IFDEF MSWINDOWS}
//            if (Result[I+1]=Char($D83D)) then
//            begin
//              Result[I+1]:='?';
//              Result[I+2]:='?';
//            end;
//        {$ELSE}
//            if (Result[I]=Char($D83D)) then
//            begin
//              Result[I]:='?';
//              Result[I+1]:='?';
//            end;
//        {$ENDIF}
//    end;
  end;



procedure TFrameScoreExchangeList.lvDataPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AListStyleFrame:TFrameListItemStyle_ScoreExchangeActivity;
////  AArticleStyleFrame:TFramePetchipArticleListItemStyle;
////  ALostStyleFrame:TFrameListItemStyle_PetchipGiftLost;
//  I: Integer;
  AItemDataJson:ISuperObject;
//  APic1Width:Integer;
//  APic1Height:Integer;
//  APicCount:Integer;
//  APicturesHeight:Double;
//  AGiftHeight:Double;
//  AOneLineHeight:Double;
//  AIsLongGift:Boolean;
//  ADrawPicture:TDrawPicture;
//  AComment:String;
//  AStr:String;
begin
  if AItem.DataObject=nil then Exit;
  if TSkinItemJsonObject(AItem.DataObject).Json=nil then Exit;

  AItemDataJson:=GetItemJsonObject(AItem).Json;



  //准备控件
  if (AItemDesignerPanel<>nil)
    //设计面板是内容内容
    and (AItemDesignerPanel.Parent is TFrameListItemStyle_ScoreExchangeActivity) then
  begin

      AListStyleFrame:=TFrameListItemStyle_ScoreExchangeActivity(AItemDesignerPanel.Parent);

      if AItemDataJson.I['my_daily_taked_count']<AItemDataJson.I['daily_get_coupon_count_per_user'] then
      begin
        AListStyleFrame.imgBackGround.Prop.Picture.ImageIndex:=0;
      end
      else
      begin
        AListStyleFrame.imgBackGround.Prop.Picture.ImageIndex:=1;
      end;



//      AListStyleFrame.imgGoods1.Visible:=(AItem.Detail3<>'');
////      AListStyleFrame.imgGoods2.Visible:=(AItem.Detail4<>'');
////      AListStyleFrame.imgGoods3.Visible:=(AItem.Detail5<>'');
//
//
//
//      //礼包的物品列表
//      AListStyleFrame.imgGoods1.Prop.Picture.PictureDrawType:=pdtUrl;
//      AListStyleFrame.imgGoods1.Prop.Picture.Url:=AItem.SubItems[0];
////      FMX.Types.Log.d('OrangeUI imgGoods1 '+AItem.SubItems[0]);
//
////      AListStyleFrame.imgGoods2.Prop.Picture.PictureDrawType:=pdtUrl;
////      AListStyleFrame.imgGoods2.Prop.Picture.Url:=AItem.SubItems[1];
////      FMX.Types.Log.d('OrangeUI imgGoods2 '+AItem.SubItems[1]);
////
////      AListStyleFrame.imgGoods3.Prop.Picture.PictureDrawType:=pdtUrl;
////      AListStyleFrame.imgGoods3.Prop.Picture.Url:=AItem.SubItems[2];
////      FMX.Types.Log.d('OrangeUI imgGoods3 '+AItem.SubItems[2]);
//
//
//
//      //礼包是否可以被领取
//      if AItemDataJson.I['is_taked']=0 then
//      begin
//        AListStyleFrame.btnTake.Prop.IsPushed:=False;
//        AListStyleFrame.btnTake.Caption:='可领取';
//      end
//      else
//      begin
//        AListStyleFrame.btnTake.Prop.IsPushed:=True;
//        AListStyleFrame.btnTake.Caption:='已领取';
//      end;



  end;


////      AArticleStyleFrame:=nil;
////      ALostStyleFrame:=nil;
//
//      AListStyleFrame:=TFrameDelphiGiftListItemStyle(AItemDesignerPanel.Parent);
////      if AListStyleFrame is TFramePetchipArticleListItemStyle then
////      begin
////        //是内容文章
////        AArticleStyleFrame:=TFramePetchipArticleListItemStyle(AListStyleFrame);
////      end;
////      if AListStyleFrame is TFrameListItemStyle_PetchipGiftLost then
////      begin
////        //是丢失寻获
////        ALostStyleFrame:=TFrameListItemStyle_PetchipGiftLost(AListStyleFrame);
////      end;
////
////
////
////      //是否需要显示宠物信息
////      //有pet_fid就显示宠物信息
////      AListStyleFrame.lblPetInfo.Visible:=(AItemDataJson.I['pet_fid']<>0);
////      AListStyleFrame.lblPetInfo.Width:=
////                      uSkinBufferBitmap.GetStringWidth(AListStyleFrame.lblPetInfo.Caption,
////                          RectF(0,0,MaxInt,MaxInt),
////                          AListStyleFrame.lblPetInfo.Material.DrawCaptionParam)
////                          +40;
//
//
//          AListStyleFrame.btnFocus.Visible:=False;
//          AListStyleFrame.btnFocused.Visible:=False;
////      if AItemDataJson.V['user_fid']=GlobalManager.User.fid then
////      begin
////          //自己发布的内容,不需要显示"关注状态"
////          AListStyleFrame.btnFocus.Visible:=False;
////          AListStyleFrame.btnFocused.Visible:=False;
////      end
////      else
////      begin
////          //查看别人发布的内容
////          //当前用户关注发布者的状态
////          if AItemDataJson.I['is_user_focused']=1 then
////          begin
////            AListStyleFrame.btnFocus.Visible:=False;
////
////            AListStyleFrame.btnFocused.Visible:=True;
////            AListStyleFrame.btnFocused.Caption:='取消关注';
////          end
////          else
////          begin
////            AListStyleFrame.btnFocused.Visible:=False;
////
////            AListStyleFrame.btnFocus.Visible:=True;
////            AListStyleFrame.btnFocus.Caption:='关注';
////          end;
////      end;
//
//
//
//
//
//      //内容
//      if AItem.Detail4<>'' then
//      begin
//            //if(Unicode第一个字节 >=0xD8 && Unicode <=0xDB){
//            //    //这是代理区域，表示第1——16平面的字符。每四个字节表示一个单元
//            //}
//            //else{
//            //    //这是正常映射区域，表示第0个平面。每两个字节表示一个单元。
//            //}
//
//            // if(Unicode第一个字节 >=0xD8 && Unicode <=0xDB)
//            //AStr:=Char($D83D);
////            AListStyleFrame.lblItemCaptionRegEx.Text:=ReplaceStr(AItem.Detail4,AStr,'');
//            AListStyleFrame.lblItemCaptionRegEx.Text:=RemoveUnicodeProxyChar(AItem.Detail4);//ReplaceStr(AItem.Detail4,AStr,'');
////            AListStyleFrame.lblItemCaptionRegEx.OnClickItem:=lblItemCaptionRegExClickItem;
//
//
//            //内容内容,或者文章内容
//            AListStyleFrame.lblItemCaptionRegEx.Height:=AListStyleFrame.lblItemCaptionRegEx.Prop.GetGiftHeight;
//            AGiftHeight:=AListStyleFrame.lblItemCaptionRegEx.Prop.GetGiftHeight;
////                      uSkinBufferBitmap.GetStringHeight(AItem.Detail4,
////                          RectF(0,0,AListStyleFrame.lblItemCaptionRegEx.Width,MaxInt),
////                          AListStyleFrame.lblItemCaptionRegEx.Material.DrawCaptionParam);
//
////            if AItem.ItemType=sitItem1 then
////            begin
////                //Item1是文章内容
////                AOneLineHeight:=
////                          uSkinBufferBitmap.GetStringHeight('悟能',
////                              RectF(0,0,AListStyleFrame.lblItemCaptionRegEx.Width,MaxInt),
////                              AListStyleFrame.lblItemCaptionRegEx.Material.DrawCaptionParam);
////
////                //是不是超长的内容
////                //超过3行就是超长的内容了
////                AIsLongGift:=False;
////                if (AGiftHeight / AOneLineHeight > 3) then
////                begin
////                    AIsLongGift:=True;
////                    //没有展开
////                    if not AItem.Selected then
////                    begin
////                      //没有展开
////                      AGiftHeight:=3*AOneLineHeight;
////                      AArticleStyleFrame.lblExpand.Caption:='展开全文...';
////                    end
////                    else
////                    begin
////                      //已展开
////                      AGiftHeight:=AGiftHeight
////                        //加上每行的误差
////                        +(AGiftHeight / AOneLineHeight)
////                        *{$IFDEF MSWINDOWS}2.5{$ELSE}1{$ENDIF};
////                      AArticleStyleFrame.lblExpand.Caption:='收拢...';
////                    end;
////                end;
////                AArticleStyleFrame.lblExpand.Visible:=AIsLongGift;//False;//not AItem.Selected;
////            end;
//
//      end
//      else
//      begin
//            //没有文本内容
//            AGiftHeight:=0;
//      end;
//      //弥补误差
//      AListStyleFrame.lblItemCaptionRegEx.Height:=AGiftHeight+5;
////      uBaseLog.OutputDebugString('AListStyleFrame.lblItemCaptionRegEx.Height '+FloatToStr(AGiftHeight+10));
//
//
//
//
//
//
//      AListStyleFrame.imgItemBigPic.Width:=Self.lvData.Width-20;
//      AListStyleFrame.imglistviewItemBigPic.Width:=Self.lvData.Width-20;
//
//      if AItem.Tag1=1 then
//      begin
//            //多图模式
//            AListStyleFrame.imglistviewItemBigPic.Visible:=True;
//            AListStyleFrame.imgItemBigPic.Visible:=False;
//            //第一张图片的尺寸
//            APic1Width:=AItemDataJson.I['pic1_width'];
//            APic1Height:=AItemDataJson.I['pic1_height'];
//            //只有一张图片
//            APicturesHeight:=160;
////            if APic1Width=0 then
////            begin
////              //没有宽度,那么使用默认的高度
////              APicturesHeight:=320;
////            end
////            else
////            begin
////              //根据宽度比例,计算出高度
////              APicturesHeight:=(APic1Height/APic1Width)
////                                *AListStyleFrame.imglistviewItemBigPic.Width;
////            end;
//
//
//            AListStyleFrame.imglistviewItemBigPic.Prop.Picture.ImageIndex:=0;
//            AListStyleFrame.imglistGift.PictureList.Clear(True);
//            //广告图片轮播
//            if AItemDataJson.S['pic1_path']<>'' then
//            begin
//              ADrawPicture:=AListStyleFrame.imglistGift.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic1_path']);
//            end;
//            if AItemDataJson.S['pic2_path']<>'' then
//            begin
//              ADrawPicture:=AListStyleFrame.imglistGift.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic2_path']);
//            end;
//            if AItemDataJson.S['pic3_path']<>'' then
//            begin
//              ADrawPicture:=AListStyleFrame.imglistGift.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic3_path']);
//            end;
//            if AItemDataJson.S['pic4_path']<>'' then
//            begin
//              ADrawPicture:=AListStyleFrame.imglistGift.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic4_path']);
//            end;
//            if AItemDataJson.S['pic5_path']<>'' then
//            begin
//              ADrawPicture:=AListStyleFrame.imglistGift.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic5_path']);
//            end;
//            if AItemDataJson.S['pic6_path']<>'' then
//            begin
//              ADrawPicture:=AListStyleFrame.imglistGift.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic6_path']);
//            end;
//            if AItemDataJson.S['pic7_path']<>'' then
//            begin
//              ADrawPicture:=AListStyleFrame.imglistGift.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic7_path']);
//            end;
//            if AItemDataJson.S['pic8_path']<>'' then
//            begin
//              ADrawPicture:=AListStyleFrame.imglistGift.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic8_path']);
//            end;
//            if AItemDataJson.S['pic9_path']<>'' then
//            begin
//              ADrawPicture:=AListStyleFrame.imglistGift.PictureList.Add;
//              ADrawPicture.Url:=GetImageUrl(AItemDataJson.S['pic9_path']);
//            end;
//            AListStyleFrame.imglistviewItemBigPic.Prop.Picture.ImageIndex:=0;
//            AListStyleFrame.pnlBottomBar.Visible:=
//                                (AListStyleFrame.imglistGift.PictureList.Count>1);
//            AListStyleFrame.imglistviewItemBigPic.Prop.CanGestureSwitch:=
//                                (AListStyleFrame.imglistGift.PictureList.Count>1);
//            //保存FDrawRect,需要使用
//            AItem.FDataRect:=RectF(AListStyleFrame.imglistviewItemBigPic.Left,
//                                  AListStyleFrame.imglistviewItemBigPic.Top,
//                                  AListStyleFrame.imglistviewItemBigPic.Left+AListStyleFrame.imglistviewItemBigPic.Width,
//                                  AListStyleFrame.imglistviewItemBigPic.Top+AListStyleFrame.imglistviewItemBigPic.Height);
//      end
//      else
//      begin
//            //单图模式
//            AListStyleFrame.imglistviewItemBigPic.Visible:=False;
//            AListStyleFrame.imgItemBigPic.Visible:=True;
//            //第一张图片的尺寸
//            APic1Width:=AItemDataJson.I['pic1_width'];
//            APic1Height:=AItemDataJson.I['pic1_height'];
//            APicturesHeight:=160;
//            //只有一张图片
////            if APic1Width=0 then
////            begin
////              //没有宽度,那么使用默认的高度
////              APicturesHeight:=320;
////            end
////            else
////            begin
////              //根据宽度比例,计算出高度
////              APicturesHeight:=(APic1Height/APic1Width)
////                    *AListStyleFrame.imgItemBigPic.Width;
////
////
////            end;
//            AListStyleFrame.imgItemBigPic.Prop.Picture.Url:=GetImageUrl(AItemDataJson.S['pic1_path']);
////            AListStyleFrame.imgItemBigPic.Prop.Picture.ClipRoundXRadis:=20;
////            AListStyleFrame.imgItemBigPic.Prop.Picture.ClipRoundYRadis:=20;
////            AListStyleFrame.imgItemBigPic.Prop.Picture.IsClipRound:=True;
//      end;
//      //图片框不能太高,限制其最大高度
//      if APicturesHeight>320 then
//      begin
//        APicturesHeight:=320;
//      end;
//      AListStyleFrame.imglistviewItemBigPic.Height:=APicturesHeight;
//      AListStyleFrame.imgItemBigPic.Height:=APicturesHeight;
//      //显示图片数量
//      APicCount:=Ord(AItemDataJson.S['pic1_path']<>'')
//                 +Ord(AItemDataJson.S['pic2_path']<>'')
//                 +Ord(AItemDataJson.S['pic3_path']<>'')
//                 +Ord(AItemDataJson.S['pic4_path']<>'')
//                 +Ord(AItemDataJson.S['pic5_path']<>'')
//                 +Ord(AItemDataJson.S['pic6_path']<>'')
//                 +Ord(AItemDataJson.S['pic7_path']<>'')
//                 +Ord(AItemDataJson.S['pic8_path']<>'')
//                 +Ord(AItemDataJson.S['pic9_path']<>'');
//      AListStyleFrame.btnPicCount.Caption:=IntToStr(APicCount);
//
//
//
//
//
//
//
//
//
//      //显示前三个点赞的头像列表
//      AListStyleFrame.lbLikeList.Prop.Items.BeginUpdate;
//      try
//          for I := 0 to AListStyleFrame.lbLikeList.Prop.Items.Count-2 do
//          begin
//            //"fid": 3,
//            //"appid": 1005,
//            //"content_fid": 2,
//            //"user_fid": 138,
//            //"is_like": 1,
//            //"like_time": "2018-10-27 01:57:04",
//            //"is_read": 0,
//            //"read_time": "",
//            //"is_fav": 0,
//            //"fav_time": "",
//            //"createtime": "2018-10-27 01:57:05",
//            //"is_deleted": 0,
//            //"orderno": 0,
//            //"is_comment": 0,
//            //"comment_time": "",
//            //"user_name": "悟能",
//            //"user_head_pic_path": "/Upload/1005/userhead_Pic/2018/2018-10-22/26B3FD7D7C59410792A5B5F7D2C5BB60.jpg"
//            if I<AItemDataJson.A['LikeList'].Length then
//            begin
//                AListStyleFrame.lbLikeList.Prop.Items[I].Visible:=True;
//                AListStyleFrame.lbLikeList.Prop.Items[I].Icon.IsClipRound:=True;
//                AListStyleFrame.lbLikeList.Prop.Items[I].Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
//                AListStyleFrame.lbLikeList.Prop.Items[I].Icon.Url:=
//                  GetImageUrl(AItemDataJson.A['LikeList'].O[I].S['user_head_pic_path'],itUserHead);
//            end
//            else
//            begin
//                AListStyleFrame.lbLikeList.Prop.Items[I].Visible:=False;
//            end;
//          end;
//          AListStyleFrame.lbLikeList.Prop.Items[AListStyleFrame.lbLikeList.Prop.Items.Count-1].Caption:=
//            IntToStr(AItemDataJson.I['like_count'])+'赞';
//
//      finally
//        AListStyleFrame.lbLikeList.Prop.Items.EndUpdate;
//      end;
//      //是否已赞
//      AListStyleFrame.btnFavState.Prop.IsPushed:=(AItemDataJson.O['UserState'].I['is_fav']=1);
//      //是否已赞
//      AListStyleFrame.btnLikeState.Prop.IsPushed:=(AItemDataJson.O['UserState'].I['is_like']=1);
//
//
//
//
//
//
//
//
//
//
//      //显示前三条评论
//      AListStyleFrame.lbCommentList.Prop.Items.BeginUpdate;
//      try
//        for I := 0 to AListStyleFrame.lbCommentList.Prop.Items.Count-1 do
//        begin
//          if I<AItemDataJson.A['CommentList'].Length then
//          begin
//              AListStyleFrame.lbCommentList.Prop.Items[I].Visible:=True;
//              //"fid": 13,
//              //"appid": 1005,
//              //"content_fid": 1,
//              //"user_fid": 138,
//              //"reply_to_user_fid": 138,
//              //"reply_to_comment_fid": 1,
//              //"comment": "你的评论不错!",
//              //"createtime": "2018-10-29 21:33:32",
//              //"is_deleted": 0,
//              //"orderno": 0,
//              //"user_name": "悟能",
//              //"user_head_pic_path": "/Upload/1005/userhead_Pic/2018/2018-10-22/26B3FD7D7C59410792A5B5F7D2C5BB60.jpg"
//              AListStyleFrame.lbCommentList.Prop.Items[I].Caption:=
//                  AItemDataJson.A['CommentList'].O[I].S['user_name'];
//              AComment:=ReplaceStr(AItemDataJson.A['CommentList'].O[I].S['comment'],#13#10,'');
//              AComment:=ReplaceStr(AComment,#13,'');
//              AComment:=ReplaceStr(AComment,#10,'');
//              AListStyleFrame.lbCommentList.Prop.Items[I].Detail:=AComment;
//
//
//
//              AListStyleFrame.lbCommentList.Prop.Items[I].Detail1:='';
//              AListStyleFrame.lbCommentList.Prop.Items[I].Detail2:='';
//              if AItemDataJson.A['CommentList'].O[I].I['reply_to_user_fid']<>0 then
//              begin
//                AListStyleFrame.lbCommentList.Prop.Items[I].Detail1:='回复';
//                AListStyleFrame.lbCommentList.Prop.Items[I].Detail2:=
//                  AItemDataJson.A['CommentList'].O[I].S['reply_to_user_name'];
//              end;
//
//          end
//          else
//          begin
//              AListStyleFrame.lbCommentList.Prop.Items[I].Visible:=False;
//          end;
//        end;
//      finally
//        AListStyleFrame.lbCommentList.Prop.Items.EndUpdate();
//      end;
//      //评论数
//      if AItemDataJson.I['comment_count']>0 then
//      begin
//          AListStyleFrame.lblCommentCount.StaticCaption:=
//            '查看所有'+IntToStr(AItemDataJson.I['comment_count'])+'条评论';
//      end
//      else
//      begin
//          AListStyleFrame.lblCommentCount.StaticCaption:='暂无评论';
//      end;
//      AListStyleFrame.lblCommentCount.Height:=22;
//      AListStyleFrame.lbCommentList.Height:=
//        AListStyleFrame.lbCommentList.Prop.GetGiftHeight;
////      uBaseLog.OutputDebugString('AListStyleFrame.lbCommentList.Height '+FloatToStr(AListStyleFrame.lbCommentList.Height));
////      AListStyleFrame.lblCommentCount.Visible:=AItemDataJson.I['comment_count']>0;
//      if AItemDataJson.I['comment_count']>0 then
//      begin
//        AListStyleFrame.lblCommentCount.Height:=22;
//      end
//      else
//      begin
//        AListStyleFrame.lblCommentCount.Height:=0;
//      end;
//
//
//
//
//
//      if AItem.ItemType=sitDefault then
//      begin
//          //内容
//          //排列控件
//          //文本
//          //图片在文本下面
//          AListStyleFrame.imglistviewItemBigPic.Position.Y:=
//                AListStyleFrame.lblItemCaptionRegEx.Position.Y
//                +AListStyleFrame.lblItemCaptionRegEx.Height
//                +5;
//          AListStyleFrame.imgItemBigPic.Position.Y:=
//                AListStyleFrame.lblItemCaptionRegEx.Position.Y
//                +AListStyleFrame.lblItemCaptionRegEx.Height
//                +5;
//          //按钮区在图片下面
//          AListStyleFrame.pnlButtons.Position.Y:=
//                AListStyleFrame.imglistviewItemBigPic.Position.Y
//                +AListStyleFrame.imglistviewItemBigPic.Height
//                ;//+5;
//          //评论
//          AListStyleFrame.lbCommentList.Position.Y:=
//                AListStyleFrame.pnlButtons.Position.Y
//                +AListStyleFrame.pnlButtons.Height
//                ;//+5;
//          //评论数
//          AListStyleFrame.lblCommentCount.Position.Y:=
//                AListStyleFrame.lbCommentList.Position.Y
//                +AListStyleFrame.lbCommentList.Height
////                +5
//                ;
//          AListStyleFrame.btnPicCount.Position.Y:=AListStyleFrame.imgItemBigPic.Top
//                                                  +AListStyleFrame.imgItemBigPic.Height
//                                                  -30;
//
////        uBaseLog.OutputDebugString('AListStyleFrame.lblCommentCount.Height '+FloatToStr(AListStyleFrame.lblCommentCount.Height));
////        uBaseLog.OutputDebugString('AListStyleFrame.lblCommentCount.Position.Y '+FloatToStr(AListStyleFrame.lblCommentCount.Position.Y));
//      end;
////      if AItem.ItemType=sitItem1 then
////      begin
////          //科普短文
////          //排列控件
////          //按钮区
////          AListStyleFrame.pnlButtons.Position.Y:=
////                AListStyleFrame.imglistviewItemBigPic.Position.Y
////                +AListStyleFrame.imglistviewItemBigPic.Height
////                +5;
////          //标题
////          AArticleStyleFrame.lblItemDetail5.Position.Y:=
////                AListStyleFrame.pnlButtons.Position.Y
////                +AListStyleFrame.pnlButtons.Height
////                +5;
////          //文本内容
////          AListStyleFrame.lblItemCaptionRegEx.Position.Y:=
////                AArticleStyleFrame.lblItemDetail5.Position.Y
////                +AArticleStyleFrame.lblItemDetail5.Height
////                +5;
////          //是不是超长的内容
////          if AArticleStyleFrame.lblExpand.Visible then
////          begin
////              //超长内容,没有展开,要显示
////              AArticleStyleFrame.lblExpand.Position.Y:=
////                    AArticleStyleFrame.lblItemCaptionRegEx.Position.Y
////                    +AArticleStyleFrame.lblItemCaptionRegEx.Height
////                    +5;
////              //评论
////              AListStyleFrame.lbCommentList.Position.Y:=
////                    AArticleStyleFrame.lblExpand.Position.Y
////                    +AArticleStyleFrame.lblExpand.Height
////                    +5;
////
////          end
////          else
////          begin
////              AListStyleFrame.lbCommentList.Position.Y:=
////                    AArticleStyleFrame.lblItemCaptionRegEx.Position.Y
////                    +AArticleStyleFrame.lblItemCaptionRegEx.Height
////                    +5;
////          end;
////          //评论数
////          AListStyleFrame.lblCommentCount.Position.Y:=
////                AListStyleFrame.lbCommentList.Position.Y
////                +AListStyleFrame.lbCommentList.Height
////                +5;
////
////      end;
////      if AItem.ItemType=sitItem2 then
////      begin
////          //宠物丢失或寻获
////          //标题只有一行
////          //弥补误差
////          AListStyleFrame.lblItemCaptionRegEx.Height:=24;
////
////
////
////          //加载特有的属性
////          if AItemDataJson.S['type']='_lost' then
////          begin
////              //宠物丢失的知道宠名等其他信息的
////              ALostStyleFrame.lblItemCaptionRegEx.Caption:='丢失';
////
////              //宠名
////              ALostStyleFrame.lblPetName.Caption:=AItem.Detail1;
////              //品种
////              ALostStyleFrame.lblPetVariety.Caption:=AItem.Detail2;
//////              //性别
//////              ALostStyleFrame.lblPetSex.Caption:=
//////                  GetPetSexStr(AItemDataJson.I['pet_sex']);
//////                  //丢失不需要显示是否已绝育
////////                  +'('+GetIsSterilizedStr(AItemDataJson.I['pet_is_sterilized'])+')';
//////              //年龄
//////              ALostStyleFrame.lblPetAge.Caption:=
//////                  GetAgeAndMonth(StdStrToDateTime(AItemDataJson.S['pet_birth']));
////              //丢失时间
////              ALostStyleFrame.lblPetLostTimeHint.Caption:='丢失时间:';
////              ALostStyleFrame.lblPetLostTime.Caption:=
////                  FormatDateTime('',StdStrToDateTime(AItemDataJson.S['pet_lost_time']));
////              //特点
////              ALostStyleFrame.lblPetPoint.Caption:=
////                  '特点: '+AItemDataJson.S['content'];
////
////
////              //丢失地点
////              ALostStyleFrame.lblPetAddr.Caption:=
////                  '丢失地点: '+AItemDataJson.S['pet_addr'];
////
////
////              ALostStyleFrame.btnIsFound.Caption:='已寻获宠物';
////              ALostStyleFrame.btnFind.Caption:='标记已寻获';
////          end
////          else
////          begin
////              //宠物寻获的
////              //不知道宠名等其他信息
////              ALostStyleFrame.lblItemCaptionRegEx.Caption:='寻获';
//////              ALostStyleFrame.lblPetName.Visible:=False;
//////              ALostStyleFrame.lblPetNameHint.Visible:=False;
////
////
////              //宠名
////              ALostStyleFrame.lblPetName.Caption:='未知';
////              //品种
////              ALostStyleFrame.lblPetVariety.Caption:=AItem.Detail2;
//////              //性别
//////              ALostStyleFrame.lblPetSex.Caption:=
//////                  GetPetSexStr(AItemDataJson.I['pet_sex']);
//////                  //寻获不需要显示是否已绝育
////////                  +'('+GetIsSterilizedStr(AItemDataJson.I['pet_is_sterilized'])+')';
////              //年龄
////              ALostStyleFrame.lblPetAge.Caption:='未知';
//////                  GetAgeAndMonth(StdStrToDateTime(AItemDataJson.S['pet_birth']));
////              //寻获时间
////              ALostStyleFrame.lblPetLostTimeHint.Caption:='寻获时间:';
////              ALostStyleFrame.lblPetLostTime.Caption:=
////                  FormatDateTime('',StdStrToDateTime(AItemDataJson.S['pet_lost_time']));
////              //特点
////              ALostStyleFrame.lblPetPoint.Caption:=
////                  '特点: '+AItemDataJson.S['content'];
////              //寻获地点
////              ALostStyleFrame.lblPetAddr.Caption:=
////                  '寻获地点: '+AItemDataJson.S['pet_addr'];
////
////              ALostStyleFrame.btnIsFound.Caption:='已认领失主';
////              ALostStyleFrame.btnFind.Caption:='标记已认领';
////          end;
////          //特点的高度
////          ALostStyleFrame.lblPetPoint.Height:=
////                      uSkinBufferBitmap.GetStringHeight(ALostStyleFrame.lblPetPoint.Caption,
////                          RectF(0,0,ALostStyleFrame.lblPetPoint.Width,MaxInt),
////                          ALostStyleFrame.lblPetPoint.Material.DrawCaptionParam)
////                          +10;
////          ALostStyleFrame.lblPetAddr.Height:=
////                      uSkinBufferBitmap.GetStringHeight(ALostStyleFrame.lblPetAddr.Caption,
////                          RectF(0,0,ALostStyleFrame.lblPetAddr.Width,MaxInt),
////                          ALostStyleFrame.lblPetAddr.Material.DrawCaptionParam)
////                          +10;
////          ALostStyleFrame.lblPetAddr.Position.Y:=
////                ALostStyleFrame.lblPetPoint.Position.Y
////                +ALostStyleFrame.lblPetPoint.Height
////                +5;
////          ALostStyleFrame.pnlLostInfo.Height:=
////                      ALostStyleFrame.lblPetPoint.Top
////                      +ALostStyleFrame.lblPetPoint.Height
////                      +5
////                      +ALostStyleFrame.lblPetAddr.Height;
////
////
////          ALostStyleFrame.btnIsFound.Visible:=(AItemDataJson.I['is_found']=1);
////          ALostStyleFrame.btnIsFound.Top:=ALostStyleFrame.btnFind.Top;
////          ALostStyleFrame.btnFind.Visible:=(AItemDataJson.I['is_found']=0)
////                                              and (AItemDataJson.V['user_fid']=GlobalManager.User.fid);
////
////
////          //丢失寻获
////          //排列控件
////          //按钮区
////          AListStyleFrame.pnlButtons.Position.Y:=
////                AListStyleFrame.imglistviewItemBigPic.Position.Y
////                +AListStyleFrame.imglistviewItemBigPic.Height
////                +5;
////          //文本
////          AListStyleFrame.lblItemCaptionRegEx.Position.Y:=
////                AListStyleFrame.pnlButtons.Position.Y
////                +AListStyleFrame.pnlButtons.Height
////                +5;
////          //丢失信息区
////          ALostStyleFrame.pnlLostInfo.Position.Y:=
////                AListStyleFrame.lblItemCaptionRegEx.Position.Y
////                +AListStyleFrame.lblItemCaptionRegEx.Height
////                +5;
////          //地图区
////          ALostStyleFrame.imgMapPosition.Position.Y:=
////                ALostStyleFrame.pnlLostInfo.Position.Y
////                +ALostStyleFrame.pnlLostInfo.Height
////                +5;
////          //将地图的纵坐标记录在AItem当中
////          AItem.Tag:=Ceil(ALostStyleFrame.imgMapPosition.Position.Y);
////
////          //在详情页面才显示
////          if (CurrentFrame is TFrameGiftInfo)
////            and ((AItemDataJson.S['type']='_lost')
////            or (AItemDataJson.S['type']='_find')) then
////          begin
////            ALostStyleFrame.imgMapPosition.Height:=200;
////          end
////          else
////          begin
////            ALostStyleFrame.imgMapPosition.Height:=0;
////          end;
////
////
////
////          //评论列表
////          AListStyleFrame.lbCommentList.Position.Y:=
////                ALostStyleFrame.imgMapPosition.Position.Y
////                +ALostStyleFrame.imgMapPosition.Height
////                +5;
////          //评论数
////          AListStyleFrame.lblCommentCount.Position.Y:=
////                AListStyleFrame.lbCommentList.Position.Y
////                +AListStyleFrame.lbCommentList.Height
////                +5;
////
////      end;
//
//
//
//
//      //删除按钮
//      AListStyleFrame.lblDelete.Visible:=
//        (AItemDataJson.V['user_fid']=GlobalManager.User.fid)//;
////          or (GlobalManager.User.fid=269)
////          or (GlobalManager.User.fid=243)
//          or (GlobalManager.User.phone='18957901025');
//      AListStyleFrame.lblDelete.Position.Y:=
//            AListStyleFrame.lblCommentCount.Position.Y
//            +AListStyleFrame.lblCommentCount.Height
////            +5
//            ;
////      uBaseLog.OutputDebugString('AListStyleFrame.lblDelete.Position.Y '+FloatToStr(AListStyleFrame.lblDelete.Position.Y));
//
//
//
//  end;
end;

procedure TFrameScoreExchangeList.lvDataPullDownRefresh(Sender: TObject);
begin
  FPageIndex:=1;
  Self.tteGetData.Run;
end;

procedure TFrameScoreExchangeList.lvDataPullUpLoadMore(Sender: TObject);
begin
  FPageIndex:=FPageIndex+1;
  Self.tteGetData.Run;
end;

procedure TFrameScoreExchangeList.lvDataResize(Sender: TObject);
//var
//  I: Integer;
begin
//  Self.lvData.Prop.Items.BeginUpdate;
//  try
//    for I := 0 to Self.lvData.Prop.Items.Count-1 do
//    begin
//      if (Self.lvData.Prop.Items[I].ItemType=sitDefault)
//        or (Self.lvData.Prop.Items[I].ItemType=sitItem1)
//        or (Self.lvData.Prop.Items[I].ItemType=sitItem2)
//        or (Self.lvData.Prop.Items[I].ItemType=sitItem3) then
//      begin
//        //计算高度
//        Self.lvData.Prop.Items[I].Height:=
//            Self.lvData.Prop.CalcItemAutoSize(Self.lvData.Prop.Items[I]).cy;
//      end;
//    end;
//  finally
//    Self.lvData.Prop.Items.EndUpdate;
//  end;
end;

procedure TFrameScoreExchangeList.pnlToolBarClick(Sender: TObject);
begin
  //
end;

procedure TFrameScoreExchangeList.tmrInvalidateTimer(Sender: TObject);
//var
//  I: Integer;
begin
//  for I := 0 to Self.lvData.Prop.Items.Count-1 do
//  begin
//    Self.lvData.Prop.Items[I].IsBufferNeedChange:=True;
//  end;
//  Self.lvData.Invalidate;
end;

procedure TFrameScoreExchangeList.tteGetDataExecute(ATimerTask: TTimerTask);
begin

  //出错
  TTimerTask(ATimerTask).TaskTag:=TASK_FAIL;
  try
    TTimerTask(ATimerTask).TaskDesc:=
        SimpleCallAPI('get_shop_promotion_list',
            nil,
            PromotionCenterInterfaceUrl,
            ['appid',
            'user_fid',
            'key',
            'pageindex',
            'pagesize',
            'filter_state',
            'filter_promotion_type',
            'filter_group_id'
            ],
            [AppID,
            GlobalManager.User.fid,
            GlobalManager.User.key,
            FPageIndex,
            40,
            //进行中的礼包活动
            'ongoing',
            Self.FFilterPromotionType,
            Self.FFilterGroupId
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

procedure TFrameScoreExchangeList.tteGetDataExecuteEnd(ATimerTask: TTimerTask);
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
            if FPageIndex=1 then
            begin
//              Self.lvData.Prop.Items.Clear(True);//ItemsByType(sitDefault);
              Self.lvData.Prop.Items.ClearItemsByType(sitDefault);
            end;

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

    if FPageIndex>1 then
    begin
        //加载更多
        if (TTimerTask(ATimerTask).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['RecordList'].Length>0) then
        begin
          Self.lvData.Prop.StopPullUpLoadMore('加载成功!',0,True);
        end
        else
        begin
          Self.lvData.Prop.StopPullUpLoadMore('下面没有了!',600,False);
        end;
    end
    else
    begin
        //刷新
        Self.lvData.Prop.StopPullDownRefresh('刷新成功!',600);
    end;

  end;

end;

procedure TFrameScoreExchangeList.tteUserTakeGiftBegin(
  ATimerTask: TTimerTask);
begin
  ShowWaitingFrame(nil,'处理中...');
end;

procedure TFrameScoreExchangeList.tteUserTakeGiftExecute(
  ATimerTask: TTimerTask);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=
        SimpleCallAPI('take_shop_coupon',
                      nil,
                      PromotionCenterInterfaceUrl,
                      ['appid',
                      'user_fid',
                      'key',
                      'shop_promotion_fid'],
                      [AppID,
                      GlobalManager.User.fid,
                      GlobalManager.User.key,
                      //红包活动FID
                      ATimerTask.TaskOtherInfo.Values['promotion_fid']
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

procedure TFrameScoreExchangeList.tteUserTakeGiftExecuteEnd(
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

//          if GetItemJsonObject(FGiftItem)=nil then Exit;
//          if GetItemJsonObject(FGiftItem).Json=nil then Exit;
//          AGiftJson:=GetItemJsonObject(FGiftItem).Json;
//
//          AGiftJson.I['is_taked']:=1;
//          FGiftItem.IsBufferNeedChange:=True;
//          Self.lvData.Invalidate;



          //领取成功,刷新页面
          ShowHintFrame(nil,'领取成功!');


          Self.Load;



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

