unit ShopingFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinMaterial,
  uOpenCommon,
  uFrameContext,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinPanelType, uSkinFireMonkeyPanel,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinFireMonkeyListBox, uDrawPicture,
  uSkinImageList, uSkinImageListViewerType, uSkinFireMonkeyImageListViewer,
  uSkinImageListPlayerType, uSkinFireMonkeyImageListPlayer,
  uTimerTask,uRestInterfaceCall,uOpenClientCommon,uManager,
  XSuperObject,uSkinListViewType,MessageBoxFrame,WaitingFrame,
  uSkinItems,uBaseList,uUIFunction, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit,System.DateUtils,uFuncCommon, uDrawCanvas;

type
  TFrameShoping = class(TFrame)
    imgListNew: TSkinImageList;
    lbProList: TSkinFMXListBox;
    idpProInfoList: TSkinFMXItemDesignerPanel;
    imgProPicture: TSkinFMXImage;
    lblProName: TSkinFMXLabel;
    mclPrice: TSkinFMXMultiColorLabel;
    lblPrice: TSkinFMXLabel;
    imgIsNew: TSkinFMXImage;
    imgIsRecommend: TSkinFMXImage;
    lblGoodsModel: TSkinFMXLabel;
    lblGoodsModelNumber: TSkinFMXLabel;
    lblWaitingSell: TSkinFMXLabel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnAdd: TSkinFMXButton;
    btnScanBarCode: TSkinFMXButton;
    idpImageListViewer: TSkinFMXItemDesignerPanel;
    imgPlayer: TSkinFMXImageListViewer;
    bgIndicator: TSkinFMXButtonGroup;
    imglistPlayer: TSkinImageList;
    BtnSearchGoodsHistory: TSkinFMXButton;
    procedure btnSearchGoodsHistoryClick(Sender: TObject);
    procedure lbProListPullDownRefresh(Sender: TObject);
    procedure lbProListPullUpLoadMore(Sender: TObject);
    procedure imgPlayerResize(Sender: TObject);
    procedure lbProListClickItem(AItem: TSkinItem);
    procedure etdSearchGoodsHistoryChange(Sender: TObject);
  private
    { Private declarations }
    //平台商家FID
    FPlatformShopFID:Integer;
    //平台商家
    FShop:TShop;
    //分页 页数
    FPageIndex:Integer;
    //只更新列表
    FIsOnlyUpdateShopList:Boolean;
    //广告图片
    FHomeAdList:THomeAdList;
    //商品列表
    FShopGoodsList:TShopGoodsList;
    //是否营业
    FIsDoBusiness:Boolean;
    //获取平台商家信息
    procedure DoGetPlatformShopInfoExecute(ATimerTask:TObject);
    procedure DoGetPlatformShopInfoExecuteEnd(ATimerTask:TObject);
    //获取平台商家首页
    procedure DoGetShopingFrameInfoExecute(ATimerTask:TObject);
    procedure DoGetShopingFrameInfoExecuteEnd(ATimerTask:TObject);
    //商家是否营业
    function IsDoBusiness(AShop: TShop): Boolean;
  public
    { Public declarations }
    procedure init();

    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  end;

implementation

uses EasyServiceCommonMaterialDataMoudle,
     ShopInfoFrame,
     MainFrame,
     SearchGoodsFrame, MainForm;

{$R *.fmx}

{ TFrameShoping }
function TFrameShoping.IsDoBusiness(AShop: TShop): Boolean;
begin
  Result:=False;

  if AShop.status=1 then
  begin

    case DayofWeek(Now) of
      1:
       if AShop.sun_is_sale=1 then
       begin
         if (CompareTime(Now,StandardStrToDateTime(AShop.sun_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.sun_end_time))=-1) then
         begin
           Result:=True;
         end;
       end;
      2:
       if AShop.mon_is_sale=1 then
       begin
         if (CompareTime(Now,StandardStrToDateTime(AShop.mon_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.mon_end_time))=-1) then
         begin
           Result:=True;
         end;
       end;

      3:
       if AShop.tues_is_sale=1 then
       begin
         if (CompareTime(Now,StandardStrToDateTime(AShop.tues_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.tues_end_time))=-1) then
         begin
           Result:=True;
         end;
       end;

      4:
       if AShop.wed_is_sale=1 then
       begin
         if (CompareTime(Now,StandardStrToDateTime(AShop.wed_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.wed_end_time))=-1) then
         begin
           Result:=True;
         end;
       end;

      5:
       if AShop.thur_is_sale=1 then
       begin
         if (CompareTime(Now,StandardStrToDateTime(AShop.thur_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.thur_end_time))=-1) then
         begin
           Result:=True;
         end;
       end;

      6:
       if AShop.fri_is_sale=1 then
       begin
         if (CompareTime(Now,StandardStrToDateTime(AShop.fri_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.fri_end_time))=-1) then
         begin
           Result:=True;
         end;
       end;

      7:
       if AShop.sat_is_sale=1 then
       begin
         if (CompareTime(Now,StandardStrToDateTime(AShop.sat_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AShop.sat_end_time))=-1) then
         begin
           Result:=True;
         end;
       end;

    end;
  end
  else
  begin
    Result:=False;
  end;
end;



procedure TFrameShoping.btnSearchGoodsHistoryClick(Sender: TObject);
begin
  //点击跳转到搜索界面
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  //显示交易列表
  ShowFrame(TFrame(GlobalSearchGoodsFrame),TFrameSearchGoods,frmMain,nil,nil,nil,Application);
//  GlobalSearchGoodsFrame.FrameHistroy:=CurrentFrameHistroy;
  if FShop<>nil then
  begin
    GlobalSearchGoodsFrame.Load(Self.BtnSearchGoodsHistory.Prop.HelpText,
                                  'Goods',
                                  Self.FShop,
                                  SElf.FShop.fid,
                                  Self.FIsDoBusiness,
                                  GlobalManager.GoodsSearchHistoryList);
  end;
end;

constructor TFrameShoping.Create(AOwner: TComponent);
begin
  inherited;

  FHomeAdList:=THomeAdList.Create();

  FShopGoodsList:=TShopGoodsList.Create();

  FIsOnlyUpdateShopList:=False;

  Self.lbProList.Prop.Items.Clear(True);

  Self.pnlToolBar.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=SkinThemeColor;


  FShop:=TShop.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameShoping.Destroy;
begin
  FreeAndNil(FShop);

  FreeAndNil(FHomeAdList);
  FreeAndNil(FShopGoodsList);
  inherited;
end;

procedure TFrameShoping.DoGetPlatformShopInfoExecute(ATimerTask: TObject);
begin
// 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=
      SimpleCallAPI('get_platform_shop',
                      nil,
                      ShopCenterInterfaceUrl,
                      ['appid',
                      'user_fid',
                      'key'],
                      [AppID,
                      GlobalManager.User.fid,
                      GlobalManager.User.key],
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

procedure TFrameShoping.DoGetPlatformShopInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //FShop:=TShop.Create;
        FShop.ParseFromJson(ASuperObject.O['Data'].A['PlatformShopInfo'].O[0]);
        //平台商家信息
        FPlatformShopFID:=ASuperObject.O['Data'].A['PlatformShopInfo'].O[0].I['fid'];

        Self.lbProList.Prop.StartPullDownRefresh;

        Self.FIsDoBusiness:=Self.IsDoBusiness(FShop);
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
    //不需要
    HideWaitingFrame;
  end;

end;

procedure TFrameShoping.DoGetShopingFrameInfoExecute(ATimerTask: TObject);
begin
// 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=
      SimpleCallAPI('get_shop_home_page',
                      nil,
                      ShopCenterInterfaceUrl,
                      ['appid',
                      'user_fid',
                      'key',
                      'shop_fid',
                      'is_need_shop_goods_list',
                      'pageindex',
                      'pagesize'],
                      [AppID,
                      GlobalManager.User.fid,
                      GlobalManager.User.key,
                      FPlatformShopFID,
                      1,
                      FPageIndex,
                      20],
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

procedure TFrameShoping.DoGetShopingFrameInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ADrawPicture:TDrawPicture;
  AListBoxItem:TSkinListBoxItem;
  I,K: Integer;
  AShopGoodsList:TShopGoodsList;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        Self.lbProList.Prop.Items.BeginUpdate;
        try
            //主页信息获取成功
            //加载信息
            if FPageIndex=1 then
            begin

              if FIsOnlyUpdateShopList=False then
              begin
                  Self.lbProList.Prop.Items.Clear(True);

                  //加载首页广告图片
                  Self.imglistPlayer.PictureList.Clear(True);
                  Self.FHomeAdList.Clear(True);

                  FHomeAdList.ParseFromJsonArray(THomeAd,ASuperObject.O['Data'].A['HomeAdList']);

                  //广告图片轮播
                  AListBoxItem:=Self.lbProList.Prop.Items.Add;
                  AListBoxItem.ItemType:=sitItem1;
                  AListBoxItem.Height:=120;
                  AListBoxItem.Width:=-1;

                  //广告图片轮播
                  for I := 0 to FHomeAdList.Count-1 do
                  begin
                    ADrawPicture:=Self.imglistPlayer.PictureList.Add;
                    ADrawPicture.Url:=FHomeAdList[I].GetPicUrl;
                    //立即下载
                    ADrawPicture.WebUrlPicture;
                    ADrawPicture.Data:=FHomeAdList[I];
                  end;

                  //显示第一页
                  if Self.imglistPlayer.PictureList.Count>0 then
                  begin
                    Self.imgPlayer.Prop.Picture.ImageIndex:=0;
                  end
                  else
                  begin
                    Self.imgPlayer.Prop.Picture.ImageIndex:=-1;
                  end;

                  //排列按钮分组的位置
                  Self.imgPlayerResize(nil);
              end;


              Self.FShopGoodsList.Clear(True);
              //清除店铺列表
              Self.lbProList.Prop.Items.ClearItemsByType(sitDefault);

            end;

            AShopGoodsList:=TShopGoodsList.Create(ooReference);

            AShopGoodsList.ParseFromJsonArray(TShopGoods,ASuperObject.O['Data'].A['GoodsList']);

            for K := 0 to AShopGoodsList.Count-1 do
            begin
              AListBoxItem:=Self.lbProList.Prop.Items.Add;
              AListBoxItem.ItemType:=sitDefault;
              AListBoxItem.Height:=-1;
              AListBoxItem.Width:=-1;

              Self.FShopGoodsList.Add(AShopGoodsList[K]);

              AListBoxItem.Data:=AShopGoodsList[K];

              AListBoxItem.Caption:=AShopGoodsList[K].name;
              AListBoxItem.Icon.Url:=AShopGoodsList[K].GetPic1Url;
              //价格
              AListBoxItem.Detail1:=FloatToStr(AShopGoodsList[K].GoodsSpecList[0].price);
              //单位
              AListBoxItem.Detail2:='份';
              if (AShopGoodsList[K].GoodsSpecList[0].name<>'')
              AND (UpperCase(AShopGoodsList[K].GoodsSpecList[0].name)<>'DEFAULT') then
                AListBoxItem.Detail2:=AShopGoodsList[K].GoodsSpecList[0].name;
              //状态
              AListBoxItem.Detail4:='在售';
            end;


        finally
          Self.lbProList.Prop.Items.EndUpdate();
          FreeAndNil(AShopGoodsList);
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
    //不需要
    HideWaitingFrame;

    if FPageIndex>1 then
    begin
      if (TTimerTask(ATimerTask).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['ShopList'].Length>0) then
      begin
        Self.lbProList.Prop.StopPullUpLoadMore('加载成功!',0,True);
      end
      else
      begin
        Self.lbProList.Prop.StopPullUpLoadMore('下面没有了!',600,False);
      end;
    end
    else
    begin
      Self.lbProList.Prop.StopPullDownRefresh('刷新成功!',600);
    end;

  end;

end;

procedure TFrameShoping.etdSearchGoodsHistoryChange(Sender: TObject);
begin
  //搜索栏
end;

procedure TFrameShoping.imgPlayerResize(Sender: TObject);
begin
  //设置按钮分组的位置
  Self.bgIndicator.Position.X:=Self.imgPlayer.Width
                                -Self.imglistPlayer.Count*bgIndicator.Height-20;
  Self.bgIndicator.Position.Y:=Self.imgPlayer.Height-20;
end;

procedure TFrameShoping.init;
begin
  //
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoGetPlatformShopInfoExecute,
                 DoGetPlatformShopInfoExecuteEnd,
                 'GetPlatformShopInfo');


end;

procedure TFrameShoping.lbProListClickItem(AItem: TSkinItem);
begin
  //点击某一个商品
  if AItem.ItemType=sitDefault then
  begin
    //加载店铺详情
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
    ShowFrame(TFrame(GlobalShopInfoFrame),TFrameShopInfo,nil);
//    GlobalShopInfoFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalShopInfoFrame.Clear;

    GlobalShopInfoFrame.Load(FPlatformShopFID,nil,GlobalShopInfoFrame);
  end;
end;

procedure TFrameShoping.lbProListPullDownRefresh(Sender: TObject);
begin
  //下拉刷新
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoGetShopingFrameInfoExecute,
                 DoGetShopingFrameInfoExecuteEnd,
                 'GetShopingFrameInfo');
end;

procedure TFrameShoping.lbProListPullUpLoadMore(Sender: TObject);
begin
  //上拉加载更多
  FPageIndex:=FPageIndex+1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoGetShopingFrameInfoExecute,
                 DoGetShopingFrameInfoExecuteEnd,
                 'GetShopingFrameInfo');
end;

end.
