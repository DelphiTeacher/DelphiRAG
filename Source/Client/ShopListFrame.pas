unit ShopListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

//  uOpenCommon,
  uGPSLocation,
  uBaseList,
  uOpenClientCommon,
  uOpenCommon,

  DateUtils,
  uFuncCommon,
  uLang,

  uBaseHttpControl,

  uUIFunction,
  uManager,
//  uOpenClientCommon,
  uTimerTask,

  uSkinControlGestureManager,

  uDrawCanvas,
  WaitingFrame,

  uSkinItems,

  XSuperObject,
  uRestInterfaceCall,

  MessageBoxFrame,


  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,



  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinFireMonkeyListBox,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel, uSkinListBoxType,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinNotifyNumberIconType, uSkinFireMonkeyNotifyNumberIcon;

type
  TFrameShopList = class(TFrame)
    lbShopList: TSkinFMXListBox;
    idpShop: TSkinFMXItemDesignerPanel;
    imgLogo: TSkinFMXImage;
    lblShopName: TSkinFMXLabel;
    imgStar1: TSkinFMXImage;
    imgStar2: TSkinFMXImage;
    imgStar3: TSkinFMXImage;
    imgStar4: TSkinFMXImage;
    imgStar5: TSkinFMXImage;
    lblScore: TSkinFMXLabel;
    lblNumber: TSkinFMXLabel;
    lblDeliverFee: TSkinFMXLabel;
    lblDistance: TSkinFMXLabel;
    lblShopType: TSkinFMXLabel;
    lblFull: TSkinFMXLabel;
    lblFullValue: TSkinFMXLabel;
    imgPic: TSkinFMXImage;
    pnlbtns: TSkinFMXPanel;
    btnAll: TSkinFMXButton;
    btnFilter1: TSkinFMXButton;
    btnFilter2: TSkinFMXButton;
    btnFilter3: TSkinFMXButton;
    btnFilter4: TSkinFMXButton;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnSearch: TSkinFMXButton;
    btnKey: TSkinFMXButton;
    lblActv2: TSkinFMXLabel;
    lblActv2Value: TSkinFMXLabel;
    nniUserCartNumber: TSkinFMXNotifyNumberIcon;
    lbltag: TSkinFMXLabel;
    procedure lbShopListPullDownRefresh(Sender: TObject);
    procedure lbShopListPullUpLoadMore(Sender: TObject);
    procedure lbShopListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure btnAllClick(Sender: TObject);
    procedure btnFilter1Click(Sender: TObject);
    procedure btnFilter2Click(Sender: TObject);
    procedure btnFilter3Click(Sender: TObject);
    procedure btnFilter4Click(Sender: TObject);
    procedure pnlbtnsResize(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure btnKeyClick(Sender: TObject);
    procedure lbShopListClickItem(AItem: TSkinItem);
  private
    //搜索关键字
    FFilterKey:String;
    //是否显示搜索
    FIsShow:Boolean;
    //排序
    FSort:String;
    //页数
    FPageIndex:Integer;
    //店铺列表
    FShopList:TShopList;
    //活动类型
    FFilterPromotionType:String;
    //五星显示
    //热门搜索列表
    FStringList:TStringList;
    //历史搜索列表
    FHisStringList:TStringList;
    procedure GetShowStar(ANumber:Double);
    //从商品详情页面返回
    procedure OnFromShopInfoFrame(AFrame:TFrame);
  private
    FCarShopList:TCarShopList;
    //获取购物车商品列表
    procedure DoGetUserCarGoodsListExecute(ATimerTask:TObject);
    procedure DoGetUserCarGoodsListExecuteEnd(ATimerTask:TObject);
  private
    //加载活动商家列表
    procedure DoGetPromotionShopListExecute(ATimerTask:TObject);
    procedure DoGetPromotionShopListExecuteEnd(ATimerTask:TObject);
  private
    //从筛选页面返回
    procedure OnFromFFilterFrame(AFrame:TFrame);
    //从搜索页面返回
    procedure OnReturnSearchFrame(AFrame:TFrame);
    { Private declarations }
  public
    //清空列表
    procedure Clear;
    //加载店铺列表
    procedure LoadShopList(AFilterPromotionType:String;AFilterKey:String;AIsShow:Boolean);
    //初始化界面
    procedure InitView;
  public
    //获取用户购物车列表
    procedure GetUserCarGoods;

    //加载列表
    procedure LoadCarGoods(ACarShopList:TCarShopList);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;
var
  GlobalShopListFrame:TFrameShopList;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame,
  ShopInfoFrame,
  FFilterShopConditionFrame,
  SearchFrame;


procedure TFrameShopList.btnAllClick(Sender: TObject);
begin
  Self.FSort:='';

  Self.btnAll.Prop.IsPushed:=True;
  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=False;

    //显示筛选页面
//  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  ShowFrame(TFrame(GlobalFFilterShopConditionFrame),TFrameFFilterShopCondition,frmMain,nil,nil,OnFromFFilterFrame,Application,True,False,ufsefNone);
//  ShowFrame(TFrame(GlobalFFilterShopConditionFrame),TFrameFFilterShopCondition,OnFromFFilterFrame);
//  GlobalFFilterShopConditionFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalFFilterShopConditionFrame.Init(Self.btnAll.Caption);


//  Self.LoadShopList(FFilterPromotionType,Self.FFilterKey,FIsShow);
end;



procedure TFrameShopList.btnFilter1Click(Sender: TObject);
begin
  Self.FSort:=Const_SortType_HighOpinion;

  Self.btnAll.Prop.IsPushed:=False;
  Self.btnFilter1.Prop.IsPushed:=True;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=False;

  Self.LoadShopList(FFilterPromotionType,Self.FFilterKey,FIsShow);
end;


procedure TFrameShopList.btnFilter2Click(Sender: TObject);
begin
  Self.FSort:=Const_SortType_NearestDistance;

  Self.btnAll.Prop.IsPushed:=False;
  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=True;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=False;

  Self.LoadShopList(FFilterPromotionType,Self.FFilterKey,FIsShow);

end;



procedure TFrameShopList.btnFilter3Click(Sender: TObject);
begin
  Self.FSort:=Const_SortType_TopSales;

  Self.btnAll.Prop.IsPushed:=False;
  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=True;
  Self.btnFilter4.Prop.IsPushed:=False;


  Self.LoadShopList(FFilterPromotionType,Self.FFilterKey,FIsShow);

end;


procedure TFrameShopList.btnFilter4Click(Sender: TObject);
begin
  Self.FSort:=Const_SortType_LowestBidPrice;

  Self.btnAll.Prop.IsPushed:=False;
  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=True;


  Self.LoadShopList(FFilterPromotionType,Self.FFilterKey,FIsShow);

end;


procedure TFrameShopList.btnReturnClick(Sender: TObject);
begin
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameShopList.Clear;
begin
  Self.FPageIndex:=1;
  Self.FSort:='';
  Self.FFilterPromotionType:='';
  Self.FShopList.Clear(True);

  Self.pnlToolBar.Caption:='';

  Self.lbShopList.Prop.Items.Clear(True);
end;


constructor TFrameShopList.Create(AOwner: TComponent);
begin
  inherited;
  FShopList:=TShopList.Create;

  FCarShopList:=TCarShopList.Create;

  //热门搜索列表
  FStringList:=TStringList.Create;
  //历史搜索列表
  FHisStringList:=TStringList.Create;

  Self.lbShopList.Prop.Items.Clear(True);

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;


destructor TFrameShopList.Destroy;
begin
  FreeAndNil(FCarShopList);
  FreeAndNil(FStringList);
  FreeAndNil(FHisStringList);
  FreeAndNil(FShopList);
  inherited;
end;


procedure TFrameShopList.DoGetPromotionShopListExecute(ATimerTask: TObject);
var
  ADistance:String;
begin
  ADistance:='5000';
  if AppID=1004 then ADistance:=IntToStr(MaxInt);  //暂时先不写1000  不然没数据
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_client_face_list',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'longitude',
                                                      'latitude',
                                                      'distance',
                                                      'filter_app_business_category_fid',
                                                      'filter_keyword',
                                                      'filter_promotion_type',
                                                      'sort',
                                                      'is_need_ad_and_promotion',
                                                      'pageindex',
                                                      'pagesize'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      GlobalGPSLocation.Longitude,
                                                      GlobalGPSLocation.Latitude,
                                                      ADistance,
                                                      '',
                                                      Self.FFilterKey,
                                                      Self.FFilterPromotionType,  //活动类型
                                                      Self.FSort,  //排序方式  有常量 uOpenCommon单元中搜索  店铺列表过滤排序方式
                                                      '0',//不需要首页广告
                                                      Self.FPageIndex,
                                                      5],
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


procedure TFrameShopList.DoGetPromotionShopListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I:Integer;
  AListBoxItem:TSkinListBoxItem;
  K: Integer;
  L:Integer;
  AShopList:TShopList;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      FMX.Types.Log.d('OrangeUI DoGetPromotionShopListExecuteEnd AJson'+ASuperObject.AsJSON);
      if ASuperObject.I['Code']=200 then
      begin
        //清空热门搜索列表
        FStringList.Clear;
        //加载搜索热门历史
        for L := 0 to ASuperObject.O['Data'].A['KeyWords'].Length-1 do
        begin
          Self.FStringList.Add(ASuperObject.O['Data'].A['KeyWords'].O[L].S['keyword']);
        end;


        AShopList:=TShopList.Create(ooReference);

        AShopList.ParseFromJsonArray(TShop,ASuperObject.O['Data'].A['ShopList']);



        Self.lbShopList.Prop.Items.BeginUpdate;
        try

          if FPageIndex=1 then
          begin
            //清空列表
            Self.FShopList.Clear(True);
            Self.lbShopList.Prop.Items.Clear(True);
          end;


          for I := 0 to AShopList.Count-1 do
          begin
            //亿诚商区  先不显示   不影响外卖
            if AShopList[I].is_platform_shop=1 then Continue;

            AListBoxItem:=Self.lbShopList.Prop.Items.Add;
            FShopList.Add(AShopList[I]);
            AListBoxItem.Data:=AShopList[I];
            if AShopList[I].ShopPromotionList.Count>1 then
            begin
              AListBoxItem.Height:=155;
            end
            else if AShopList[I].ShopPromotionList.Count=1 then
            begin
              AListBoxItem.Height:=135;
            end
            else
            begin
              AListBoxItem.Height:=110;
            end;

            //是否在店铺的营业时间


            AListBoxItem.Caption:=AShopList[I].name;
            AListBoxItem.Icon.Url:=AShopList[I].Getlogopicpath;
            AListBoxItem.Detail:=FloatToStr(AShopList[I].num_ratings);
            AListBoxItem.Detail1:='月售'+IntToStr(AShopList[I].recent_goods_popularity);
            AListBoxItem.Detail2:='起送价 '+Trans('￥')+FloatToStr(AShopList[I].deliver_min_order_amount);
//            AListBoxItem.Detail3:=FloatToStr(FShopList[I].distance)+'km';

            if (AShopList[I].distance<1000) and (AShopList[I].distance>=0) then
            begin
              AListBoxItem.Detail3:=FloatToStr(AShopList[I].distance)+'m';
            end
            else
            begin
              AListBoxItem.Detail3:=FloatToStr(AShopList[I].distance/1000)+'km';
            end;

            AListBoxItem.Detail4:=AShopList[I].app_business_category_name;

            if AShopList[I].ShopPromotionList.Count>0 then
            begin
              if (AShopList[I].ShopPromotionList[0].promotion_type='full_dec_money')
                or (AShopList[I].ShopPromotionList[0].promotion_type='coupon') then
              begin
                if AShopList[I].ShopPromotionList[0].promotion_type='full_dec_money' then
                begin
                  AListBoxItem.Detail5:='满减';
                end
                else
                begin
                  AListBoxItem.Detail5:='红包';
                end;

                AListBoxItem.Detail6:=GetActivityRules(AShopList[I].ShopPromotionList[0].full_money1,
                                                       AShopList[I].ShopPromotionList[0].dec_money1,
                                                       AShopList[I].ShopPromotionList[0].full_money2,
                                                       AShopList[I].ShopPromotionList[0].dec_money2,
                                                       AShopList[I].ShopPromotionList[0].full_money3,
                                                       AShopList[I].ShopPromotionList[0].dec_money3);


              end
              else if (AShopList[I].ShopPromotionList[0].promotion_type='special_price_goods')
                or (AShopList[I].ShopPromotionList[0].promotion_type='discount') then
              begin
                if AShopList[I].ShopPromotionList[0].promotion_type='special_price_goods' then
                begin
                  AListBoxItem.Detail5:='特价';
                  AListBoxItem.Detail6:='活动价仅'+FloatToStr(AShopList[I].ShopPromotionList[0].special_price);
                end
                else
                begin
                  AListBoxItem.Detail5:='打折';
                  AListBoxItem.Detail6:=FloatToStr(AShopList[I].ShopPromotionList[0].discount)+'折';
                end;


              end;
            end;

          end;

          if GlobalManager.IsLogin=True then
          begin
            GetUserCarGoods;
          end;

        finally
          Self.lbShopList.Prop.Items.EndUpdate();
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
    if FPageIndex>1 then
    begin
        if ASuperObject.O['Data'].A['ShopList'].Length>0 then
        begin
          Self.lbShopList.Prop.StopPullUpLoadMore('加载成功!',0,True);
        end
        else
        begin
          Self.lbShopList.Prop.StopPullUpLoadMore('下面没有了!',600,False);
        end;
    end
    else
    begin
        Self.lbShopList.Prop.StopPullDownRefresh('刷新成功!',600);
    end;

  end;
end;


procedure TFrameShopList.DoGetUserCarGoodsListExecute(ATimerTask: TObject);
begin
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_user_cart_goods_list',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'longitude',
                                                      'latitude'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      GlobalMAnager.Longitude,
                                                      GlobalManager.Latitude
//                                                      119.648994,
//                                                      29.076664
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

procedure TFrameShopList.DoGetUserCarGoodsListExecuteEnd(ATimerTask: TObject);
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
        FCarShopList.Clear(True);
        //获取成功
        FCarShopList.ParseFromJsonArray(TCarShop,ASuperObject.O['Data'].A['CartGoodsList']);

        LoadCarGoods(FCarShopList);
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

  end;
end;

procedure TFrameShopList.GetShowStar(ANumber: Double);
begin
  if (ANumber>0) and (ANumber<1) then
  begin
    Self.imgStar1.Prop.Picture.ImageIndex:=1;
    Self.imgStar2.Prop.Picture.ImageIndex:=1;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;
    Self.imgStar5.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber>=1) and (ANumber<2) then
  begin
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=1;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;
    Self.imgStar5.Prop.Picture.ImageIndex:=1;
  end;


  if (ANumber>=2) and (ANumber<3) then
  begin
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;
    Self.imgStar5.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber>=3) and (ANumber<4) then
  begin
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=0;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;
    Self.imgStar5.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber>=4) and (ANumber<5) then
  begin
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=0;
    Self.imgStar4.Prop.Picture.ImageIndex:=0;
    Self.imgStar5.Prop.Picture.ImageIndex:=1;
  end;

  if ANumber>=5 then
  begin
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=0;
    Self.imgStar4.Prop.Picture.ImageIndex:=0;
    Self.imgStar5.Prop.Picture.ImageIndex:=0;
  end;
end;

procedure TFrameShopList.GetUserCarGoods;
begin
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                  DoGetUserCarGoodsListExecute,
                  DoGetUserCarGoodsListExecuteEnd,
                  'GetUserCarGoodsList');
end;

procedure TFrameShopList.InitView;
begin
  //恢复到初始界面
  //不加的话  第一次进来点了其中一个  后面进来默认的还是之前点击的那个
  Self.FSort:='';
  Self.btnAll.Prop.IsPushed:=True;
  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=False;
end;

procedure TFrameShopList.lbShopListClickItem(AItem: TSkinItem);
var
  AShop:TShop;
begin
  AShop:=TShop(AItem.Data);
  //加载店铺详情   GlobalMainFrame
  HideFrame;//(Self,hfcttBeforeShowFrame);
  ShowFrame(TFrame(GlobalShopInfoFrame),TFrameShopInfo,OnFromShopInfoFrame);
//  GlobalShopInfoFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalShopInfoFrame.Clear;

  GlobalShopInfoFrame.IsShowBackBtn;
  if GlobalManager.IsLogin=True then
  begin
    if Self.FCarShopList.Count>0 then
    begin

      if Self.FCarShopList.FindItemByFID(AShop.fid)<>nil then
      begin
        GlobalShopInfoFrame.Load(AShop.fid,
                                  Self.FCarShopList.FindItemByFID(AShop.fid).FCarGoodList,
                                  GlobalShopInfoFrame);
      end
      else
      begin
        GlobalShopInfoFrame.Load(AShop.fid,
                                      nil,
                                      GlobalShopInfoFrame);
      end;

    end
    else
    begin
      GlobalShopInfoFrame.Load(AShop.fid,
                              nil,
                              GlobalShopInfoFrame);
    end;
  end
  else
  begin
    GlobalShopInfoFrame.Load(AShop.fid,
                              nil,
                              GlobalShopInfoFrame);
  end;



end;

procedure TFrameShopList.lbShopListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AShop:TShop;
begin
  if AItem.Data<>nil then
  begin
    AShop:=TShop(AItem.Data);
    Self.GetShowStar(AShop.num_ratings);

    if AShop.status=1 then
    begin
      if AItem.Tag=1 then
      begin
        Self.lbltag.Visible:=False;
      end
      else
      begin
        Self.lbltag.Visible:=True;
        Self.lbltag.Caption:='商家休息中';
      end;
    end
    else
    begin
      Self.lbltag.Visible:=True;
      Self.lbltag.Caption:='暂停营业';
    end;

    if Self.lbltag.Visible=False then
    begin
      AItem.Tag:=1;
      Self.imgPic.Left:=Self.lblDeliverFee.Left;
      Self.lblShopType.Left:=Self.imgPic.Left+Self.imgPic.Width;
    end
    else
    begin
      AItem.Tag:=0;
      Self.lbltag.Left:=Self.lblDeliverFee.Left;

      Self.imgPic.Left:=Self.lbltag.Left+Self.lbltag.Width+5;
      Self.lblShopType.Left:=Self.imgPic.Left+Self.imgPic.Width;
    end;

    if AShop.ShopPromotionList.Count>0 then
    begin
      Self.lblFull.Visible:=True;
      if AShop.ShopPromotionList.Count>1 then
      begin
        Self.lblActv2.Visible:=True;
        Self.lblActv2Value.Visible:=True;
        if (AShop.ShopPromotionList[1].promotion_type='full_dec_money')
          or (AShop.ShopPromotionList[1].promotion_type='coupon') then
        begin
          if AShop.ShopPromotionList[1].promotion_type='full_dec_money' then
          begin
            Self.lblActv2.Caption:='满减';
          end
          else
          begin
            Self.lblActv2.Caption:='红包';
          end;

          Self.lblActv2Value.Caption:=GetActivityRules(AShop.ShopPromotionList[1].full_money1,
                                                 AShop.ShopPromotionList[1].dec_money1,
                                                 AShop.ShopPromotionList[1].full_money2,
                                                 AShop.ShopPromotionList[1].dec_money2,
                                                 AShop.ShopPromotionList[1].full_money3,
                                                 AShop.ShopPromotionList[1].dec_money3);


        end
        else if (AShop.ShopPromotionList[1].promotion_type='special_price_goods')
          or (AShop.ShopPromotionList[1].promotion_type='discount') then
        begin
          if AShop.ShopPromotionList[1].promotion_type='special_price_goods' then
          begin
            Self.lblActv2.Caption:='特价';
            Self.lblActv2Value.Caption:='活动价仅'+FloatToStr(AShop.ShopPromotionList[1].special_price);
          end
          else
          begin
            Self.lblActv2.Caption:='打折';
            Self.lblActv2Value.Caption:=FloatToStr(AShop.ShopPromotionList[1].discount)+'折';
          end;
        end;


      end
      else
      begin
        Self.lblActv2.Visible:=False;
        Self.lblActv2Value.Visible:=False;
      end;
    end
    else
    begin
      Self.lblFull.Visible:=False;
      Self.lblActv2.Visible:=False;
      Self.lblActv2Value.Visible:=False;
    end;


    Self.nniUserCartNumber.Prop.Number:=AItem.Tag1;
  end;


end;


procedure TFrameShopList.lbShopListPullDownRefresh(Sender: TObject);
begin
  Self.FPageIndex:=1;

  uTimerTask.GetGlobalTimerThread.RunTempTask(
                DoGetPromotionShopListExecute,
                DoGetPromotionShopListExecuteEnd,
                'GetPromotionShopList');
end;


procedure TFrameShopList.lbShopListPullUpLoadMore(Sender: TObject);
begin
  Self.FPageIndex:=FPageIndex+1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                DoGetPromotionShopListExecute,
                DoGetPromotionShopListExecuteEnd,
                'GetPromotionShopList');
end;


procedure TFrameShopList.LoadCarGoods(ACarShopList: TCarShopList);
var
  I:Integer;
  ANumber:Integer;
  J: Integer;
  AShop:TShop;
begin

  for I := 0 to Self.lbShopList.Prop.Items.Count-1 do
  begin
    AShop:=TShop(Self.lbShopList.Prop.Items[I].Data);
    if (AShop.status=1) and (Self.lbShopList.Prop.Items[I].Tag=1) then
    begin
      for J := 0 to ACarShopList.Count-1 do
      begin
        if ACarShopList[J].fid=AShop.fid then
        begin
          Self.lbShopList.Prop.Items[I].Tag1:=ACarShopList[J].FCarGoodList.Count;
        end;
      end;
    end;

  end;

end;

procedure TFrameShopList.LoadShopList(AFilterPromotionType:String;AFilterKey:String;AIsShow:Boolean);
begin
  FMX.Types.Log.d('OrangeUI ShopList');
  Self.FFilterPromotionType:=AFilterPromotionType;

  Self.FFilterKey:=AFilterKey;

  Self.btnSearch.Visible:=AIsShow;
  Self.btnKey.Visible:=AIsShow;

  FIsShow:=AIsShow;

  if AIsShow=False then
  begin
    Self.pnlToolBar.Caption:=AFilterKey;
  end
  else
  begin
    Self.pnlToolBar.Caption:='';
  end;

  if  AFilterKey='' then
  begin
    Self.btnKey.Caption:='搜索商家、店铺名称';
  end
  else
  begin
    Self.btnKey.Caption:=AFilterKey;
  end;



  Self.lbShopList.Prop.StartPullDownRefresh;
end;


procedure TFrameShopList.OnFromFFilterFrame(AFrame: TFrame);
begin
  FSort:=GlobalFFilterShopConditionFrame.FFilterName;

  Self.btnAll.Caption:=GlobalFFilterShopConditionFrame.FFilterKey;

  Self.lbShopList.Prop.StartPullDownRefresh;

end;

procedure TFrameShopList.OnFromShopInfoFrame(AFrame: TFrame);
begin
  if GlobalManager.IsLogin=True then
  begin
    GetUserCarGoods;
  end;
end;

procedure TFrameShopList.OnReturnSearchFrame(AFrame: TFrame);
begin
  Self.FFilterKey:=GlobalSearchFrame.FKeyWords;

  Self.btnKey.Caption:=GlobalSearchFrame.FKeyWords;

  Self.lbShopList.Prop.StartPullDownRefresh;
end;

procedure TFrameShopList.pnlbtnsResize(Sender: TObject);
begin
  Self.btnAll.Width:=Width/4;
  Self.btnFilter1.Width:=Width/4;
  Self.btnFilter2.Width:=Width/4;
  Self.btnFilter3.Width:=Width/4;
//  Self.btnFilter4.Width:=Width/5;
end;

procedure TFrameShopList.btnKeyClick(Sender: TObject);
begin
  FHisStringList.Clear;

  if Self.btnKey.Caption='搜索商家、店铺名称' then
  begin
    Self.FFilterKey:='';
  end
  else
  begin
    Self.FFilterKey:=Self.btnKey.Caption;
  end;

  HideFrame;//(Self,hfcttBeforeShowFrame);

  ShowFrame(TFrame(GlobalSearchFrame),TFrameSearch,OnReturnSearchFrame);
//  GlobalSearchFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalSearchFrame.Clear;
  GlobalSearchFrame.Load(Self.FFilterKey,Self.FStringList,GlobalManager.ShopSearchHistoryList,'shoplist');

end;

end.
