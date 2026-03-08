unit ShopGoodsListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uUIFunction,
  uFuncCommon,
  WaitingFrame,
  MessageBoxFrame,

  uBaseList,
  HintFrame,
  uFrameContext,
  uOpenClientCommon,
  uSkinControlGestureManager,

  uManager,
  StrUtils,
  uDrawCanvas,
  uSkinItems,
  uTimerTask,
  uOpenCommon,
  XSuperObject,
  uRestInterfaceCall,
  uBaseHttpControl,
//  uCommonUtils,
  EasyServiceCommonMaterialDataMoudle,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinImageType, uSkinFireMonkeyImage,
  uSkinTreeViewType, uSkinFireMonkeyTreeView, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinPanelType, uSkinFireMonkeyPanel,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uDrawPicture,
  uSkinImageList, uSkinListViewType;

type
  TFrameShopGoodsList = class(TFrame)
    lbShopCategoryList: TSkinFMXListBox;
    idpCategory: TSkinFMXItemDesignerPanel;
    lblCategoryName: TSkinFMXLabel;
    tvShopGoodsList: TSkinFMXTreeView;
    idtParentCategory: TSkinFMXItemDesignerPanel;
    idpGoods: TSkinFMXItemDesignerPanel;
    lblGoodsName: TSkinFMXLabel;
    imgGoodsIcon: TSkinFMXImage;
    lblMonth: TSkinFMXLabel;
    btnDesc: TSkinFMXButton;
    btnAdd: TSkinFMXButton;
    edtCount: TSkinFMXEdit;
    lblRate: TSkinFMXLabel;
    mcPrice: TSkinFMXMultiColorLabel;
    imgGoodsSign: TSkinFMXImage;
    imglistAdd: TSkinImageList;
    mclblCategory: TSkinFMXMultiColorLabel;
    procedure lbShopCategoryListClickItem(AItem: TSkinItem);
    procedure tvShopGoodsListClickItem(AItem: TSkinItem);
    procedure btnAddClick(Sender: TObject);
    procedure btnDescClick(Sender: TObject);
    procedure tvShopGoodsListPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRect);
    procedure tvShopGoodsListPullUpLoadMore(Sender: TObject);
    procedure lbShopCategoryListPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRect);
  private
    FShop:TShop;//只是引用
    Sum:Integer;


    FFilterGoodsFID:Integer;
    FFilterCategoryFID:Integer;

    FPageIndex:Integer;


    FDeliverMinOrderAccount:Double;

    FFilterPrice:Double;
    //是否营业中
    FIsDoBusiness:Boolean;

    FShopGoodsList:TShopGoodsList;

  private
    FChildTreeViewItem:TBaseSkinTreeViewItem;

    //从商品详情页面返回
    procedure OnReturnFromShopGoodInfoFrame(AFrame:TFrame);

  public
    //添加购物车
    procedure AddCar(AIsAdd:Boolean;APrice:Double);

    //更新列表
    procedure UpDateShopListFrame(ACarShopList:TCarShopList);

  private
    FFilterGoodsSpecFID:Integer;
    FFilterGoodsAttrValue:String;

    FFilterOrderno:Double;
    //从商品详情页面返回
    procedure OnReturnFromGoodsInfoFrame(AFrame:TFrame);
    { Private declarations }
  private
    //添加到购物车
    procedure AddUserCar;

    procedure DoAddGoodsToCarExecute(ATimerTask:TObject);
    procedure DoAddGoodsToCarExecuteEnd(ATimerTask:TObject);
  private
    FFilterDelGoodsFID:Integer;
    FFilterDelNumber:Integer;
    //删除购物车商品
    procedure DoDelCarShopGoodExecute(ATimerTask:TObject);
    procedure DoDelCarShopGoodExecuteEnd(ATimerTask:TObject);

  private
    FPreParentTreeViewItem:TSkinTreeViewItem;
    //加载分页商品
    procedure DoGetPageGoodsListExecute(ATimerTask:TObject);
    procedure DoGetPageGoodsListExecuteEnd(ATimerTask:TObject);

  public
    //清理
    procedure Clear;
    procedure Load(AShop:TShop;
                   //ACarGoodList:TCarGoodList;
                   AIsDoBusiness:Boolean;
                   AShopInfoFrame:TFrame);
  public
//    FrameHistroy:TFrameHistroy;
    //同一个界面共用  传进来的
    FGlobalShopInfoFrame:TFrame;

    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;



var
  GlobalShopGoodsListFrame:TFrameShopGoodsList;

implementation

{$R *.fmx}

uses
  ShopGoodsInfoFrame,
  MainForm,
  MainFrame,
  ShopInfoFrame,
  ShopAddUserCarFrame,
  LoginFrame;


{ TFrameShopGoodsList }

procedure TFrameShopGoodsList.AddUserCar;
begin
  ShowWaitingFrame(Self,'添加商品中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                   DoAddGoodsToCarExecute,
                   DoAddGoodsToCarExecuteEnd,
                   'AddGoodsToCar');
end;

procedure TFrameShopGoodsList.btnAddClick(Sender: TObject);
var
  AShopGoods:TShopGoods;
  Account:Integer;
begin
  AShopGoods:=TShopGoods(Self.tvShopGoodsList.Prop.InteractiveItem.Data);

  Self.FFilterGoodsFID:=AShopGoods.fid;

  FFilterOrderno:=AShopGoods.orderno;

  FChildTreeViewItem:=Self.tvShopGoodsList.Prop.InteractiveItem;

  if Self.FChildTreeViewItem.Detail2<>'' then
  begin
    Account:=StrToInt(FChildTreeViewItem.Detail2);
  end
  else
  begin
    Account:=0;
  end;

  if GlobalManager.IsLogin=True then
  begin
      if AShopGoods.GoodsSpecList.Count>0 then
      begin
        if (AShopGoods.GoodsSpecList.Count=1) and (AShopGoods.GoodsAttrList.Count=0) then
        begin
          Self.FFilterGoodsSpecFID:=AShopGoods.GoodsSpecList[0].fid;

          Self.FFilterGoodsAttrValue:='';

          GlobalMainFrame.AddGoodsToUserCart(Self.FShop.fid,Self.FFilterGoodsFID,FFilterGoodsSpecFID,1,Self.FFilterGoodsAttrValue,Self.FFilterOrderno);

  //        Self.FChildTreeViewItem.Detail2:=IntToStr(Account+1);


  //        GlobalShopInfoFrame.UpDateShopInfo;
  //        AddUserCar;
        end
        else
        begin
          ShowFrame(TFrame(GlobalShopAddUserCarFrame),TFrameShopAddUserCar,frmMain,nil,nil,OnReturnFromGoodsInfoFrame,Application,True,False,ufsefNone);
          GlobalShopAddUserCarFrame.Clear;
          GlobalShopAddUserCarFrame.Init(Account,1,Self.FDeliverMinOrderAccount,AShopGoods);
        end;
      end;
  //    else if AShopGoods.GoodsSpecList.Count=1 then
  //    begin
  //      Sum:=Sum+1;
  //      Self.tvShopGoodsList.Prop.InteractiveItem.Detail2:=IntToStr(Sum);
  //
  //      Self.AddUserCar;
  //    end;
  end
  else
  begin
      //去登录
      //隐藏
      HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
      //显示登录页面
      ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
  //    GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
      //清除输入框
      GlobalLoginFrame.Clear;
  end;

end;

procedure TFrameShopGoodsList.btnDescClick(Sender: TObject);
var
  AShopGoods:TShopGoods;
  I: Integer;
  AIsMoreSpec:Integer;
  J: Integer;
begin


  AIsMoreSpec:=0;

  AShopGoods:=TShopGoods(Self.tvShopGoodsList.Prop.InteractiveItem.Data);

  for I := 0 to GlobalManager.UserCarShopList.FindItemByFID(Self.FShop.fid).FCarGoodList.Count-1 do
  begin
    if AShopGoods.fid=GlobalManager.UserCarShopList.FindItemByFID(Self.FShop.fid).FCarGoodList[I].shop_goods_fid then
    begin

      AIsMoreSpec:=AIsMoreSpec+1;

    end;

  end;

  if AShopGoods.GoodsSpecList.Count>0 then
  begin
    if AIsMoreSpec<=1 then
    begin
      Self.Sum:=Self.Sum-1;

      FChildTreeViewItem:=Self.tvShopGoodsList.Prop.InteractiveItem;

      if FChildTreeViewItem.Detail5<>'' then
      begin
        Self.FFilterDelGoodsFID:=StrToInt(FChildTreeViewItem.Detail5);
      end;

      FFilterDelNumber:=StrToInt(FChildTreeViewItem.Detail2)-1;

      GlobalMainFrame.UpdateCartGoodsNumber(Self.FFilterDelGoodsFID,Self.FFilterDelNumber);

//      if Self.FFilterDelNumber<>0 then
//      begin
//        FChildTreeViewItem.Detail2:=IntToStr(Self.FFilterDelNumber);
//      end
//      else
//      begin
//        FChildTreeViewItem.Detail2:='';
//      end;


//      //修改购物车商品数量
//      ShowWaitingFrame(Self,'删除中...');
//      uTimerTask.GetGlobalTimerThread.RunTempTask(
//                  DoDelCarShopGoodExecute,
//                  DoDelCarShopGoodExecuteEnd);
    end
    else
    begin
      ShowHintFrame(Self,'请在下方购物车列表中删除');
    end;
  end;
//  else
//  begin
//    //必须在列表里面删除
//    ShowMessage('请在下方购物车列表中删除');
//  end;


end;


procedure TFrameShopGoodsList.Clear;
begin
  Self.lbShopCategoryList.Prop.Items.Clear(True);
  Self.tvShopGoodsList.Prop.Items.Clear(True);

  Self.FFilterPrice:=0;

end;

constructor TFrameShopGoodsList.Create(AOwner: TComponent);
begin
  inherited;
  Sum:=0;
  Self.FFilterPrice:=0;
  Self.btnDesc.Visible:=False;
  Self.edtCount.Visible:=False;

//  FShop:=TShop.Create;

//  GlobalShopInfoFrame.pnlCar.Visible:=True;

  FShopGoodsList:=TShopGoodsList.Create;

  Self.lbShopCategoryList.Prop.IsProcessGestureInScrollBox:=True;
  Self.tvShopGoodsList.Prop.IsProcessGestureInScrollBox:=True;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;


destructor TFrameShopGoodsList.Destroy;
begin
//  FreeAndNil(FShop);

  FreeAndNil(FShopGoodsList);
  inherited;
end;


procedure TFrameShopGoodsList.DoAddGoodsToCarExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('add_shop_goods_to_cart',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'shop_fid',
                                                      'key',
                                                      'shop_goods_fid',
                                                      'shop_goods_spec_fid',
                                                      'number',
                                                      'orderno',
                                                      'shop_goods_attrs'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      Self.FShop.fid,
                                                      GlobalManager.User.key,
                                                      Self.FFilterGoodsFID,
                                                      Self.FFilterGoodsSpecFID,
                                                      1,
                                                      Self.FFilterOrderno,
                                                      Self.FFilterGoodsAttrValue
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

procedure TFrameShopGoodsList.DoAddGoodsToCarExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ASumPrice:Double;
  AGoods:TShopGoods;
  ACarGood:TCarGood;
  ASumCount:Integer;
begin
  ASumCount:=0;
  try
    ACarGood:=TCarGood.Create;
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //添加成功

        FChildTreeViewItem.Detail5:=IntToStr(ASuperObject.O['Data'].A['ShopGoodsInCart'].O[0].I['fid']);

        AGoods:=TShopGoods(FChildTreeViewItem.Data);

        if FChildTreeViewItem.Detail2<>'' then
        begin
          ASumCount:=StrToInt(FChildTreeViewItem.Detail2);
        end
        else
        begin
          ASumCount:=0;
        end;


        FChildTreeViewItem.Detail2:=IntToStr(ASumCount+1);
//
//        try
//          ACarGood:=TCarGood.Create;
//
//          ACarGood.ParseFromJson(ASuperObject.O['Data'].A['ShopGoodsInCart'].O[0]);
//
//          if GlobalManager.UserCartGoodsList.FindItemByFID(ACarGood.fid)<>nil then
//          begin
//            GlobalManager.UserCartGoodsList.FindItemByFID(ACarGood.fid).number:=ACarGood.number;
//          end
//          else
//          begin
//            GlobalManager.UserCartGoodsList.Add(ACarGood);
//          end;
//
//          GlobalManager.Save;
//        finally
//          FreeAndNil(ACarGood);
//        end;
//
        ASumPrice:=0;


        if FChildTreeViewItem.Detail6<>'没有价格' then
        begin
          ASumPrice:=StrToFloat(FChildTreeViewItem.Detail6)+AGoods.GoodsSpecList[0].packing_fee;
        end;


//        GlobalShopInfoFrame.UpDataMyCar;


        Self.AddCar(True,ASumPrice);

        TFrameShopInfo(TFrameShopInfo(FGlobalShopInfoFrame)).nniUserCartNumber.Prop.Number:=TFrameShopInfo(TFrameShopInfo(FGlobalShopInfoFrame)).nniUserCartNumber.Prop.Number+1;

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

procedure TFrameShopGoodsList.DoDelCarShopGoodExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('update_user_cart_goods_number',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'user_cart_goods_fid',
                                                      'number',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      FFilterDelGoodsFID,
                                                      FFilterDelNumber,
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


procedure TFrameShopGoodsList.DoDelCarShopGoodExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ASumPrice:Double;
  AIndex:Integer;
  I: Integer;
  AGoods:TShopGoods;
begin
  ASumPrice:=0;
  AIndex:=0;
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //删除成功
        AGoods:=TShopGoods(FChildTreeViewItem.Data);

        if FFilterDelNumber>0 then
        begin

          FChildTreeViewItem.Detail2:=IntToStr(FFilterDelNumber);
        end
        else
        begin
          FChildTreeViewItem.Detail2:='';

          AIndex:=0;
        end;

        ASumPrice:=StrToFloat(FChildTreeViewItem.Detail6)+AGoods.GoodsSpecList[0].packing_fee;

//        for I := 0 to GlobalManager.UserCartGoodsList.Count-1 do
//        begin
//          if FFilterDelGoodsFID=GlobalManager.UserCartGoodsList[I].fid then
//          begin
//            GlobalManager.UserCartGoodsList.Remove(GlobalManager.UserCartGoodsList[I]);
//          end;
//        end;

//          GlobalShopInfoFrame.UpDataMyCar;

        Self.AddCar(False,ASumPrice);

        TFrameShopInfo(TFrameShopInfo(FGlobalShopInfoFrame)).nniUserCartNumber.Prop.Number:=TFrameShopInfo(TFrameShopInfo(FGlobalShopInfoFrame)).nniUserCartNumber.Prop.Number-1;
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



procedure TFrameShopGoodsList.DoGetPageGoodsListExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_goods_list',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'shop_fid',
                                                      'key',
                                                      'pageindex',
                                                      'pagesize',
                                                      'filter_goods_category_fid'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      Self.FShop.fid,
                                                      '',
                                                      FPageIndex,
                                                      20,
                                                      FFilterCategoryFID
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

procedure TFrameShopGoodsList.DoGetPageGoodsListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AListBoxItem:TSkinListBoxItem;
  I: Integer;
  J:Integer;
  K:Integer;
  h:Integer;
  l:Integer;
  ANumber:Integer;
  AParentTreeViewItem:TSkinTreeViewItem;
  AChildTreeViewItem:TSkinTreeViewItem;
  AShopGoodsCategory:TShopGoodsCategory;
  AMinSpecialPrice:Double;
  AMinOriginPrice:Double;
  g: Integer;
  ASumPrice:Double;
  AIsOffsell:Boolean;
  AIsShowCateGory:Boolean;
  ADesc:String;
  AShopGoodsList:TShopGoodsList;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      //FMX.Types.Log.d('OrangeUI ShopGoodsList Get ASuperObject ');
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      //FMX.Types.Log.d('OrangeUI ShopGoodsList Get ASuperObject end');
      if ASuperObject.I['Code']=200 then
      begin
        //获取成功
        //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin ');
        AShopGoodsList:=TShopGoodsList.Create(ooReference);
        //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --1');
        AShopGoodsList.ParseFromJsonArray(TShopGoods,ASuperObject.O['Data'].A['GoodsList']);


        //FMX.Types.Log.d('OrangeUI ShopGoodsList Count '+IntToStr(AShopGoodsList.Count));

        for I := 0 to Self.lbShopCategoryList.Prop.Items.Count-1 do
        begin
          if Self.lbShopCategoryList.Prop.Items[I].Selected=True then
          begin
            AShopGoodsCategory:=TShopGoodsCategory(Self.lbShopCategoryList.Prop.Items[I].Data);
          end;
        end;
        //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --2');

        Self.tvShopGoodsList.Prop.Items.BeginUpdate;
        try
          if Self.FPageIndex=1 then
          begin
            Self.FShopGoodsList.Clear(True);
            Self.tvShopGoodsList.Prop.Items.Clear(True);
          end;

          //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --3');
          if AShopGoodsCategory<>nil then
          begin

            if Self.FPageIndex=1 then
            begin
              //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --4');
              AParentTreeViewItem:=Self.tvShopGoodsList.Prop.Items.Add;
              AParentTreeViewItem.Caption:=AShopGoodsCategory.name;
              //有换行会卡死
        //      ADesc:=ReplaceStr(#13#10,'',AShopGoodsCategory.category_desc);
        //      ADesc:=ReplaceStr(#13,'',ADesc);
        //      ADesc:=ReplaceStr(#10,'',ADesc);
        //      AParentTreeViewItem.Detail:='  '+ADesc;
              AParentTreeViewItem.Name:=IntToStr(AShopGoodsCategory.fid);
              AParentTreeViewItem.IsParent:=True;
              AParentTreeViewItem.Data:=AShopGoodsCategory;

              FPreParentTreeViewItem:=AParentTreeViewItem;

              //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --5');

//              AIsShowCateGory:=True;
            end
            else
            begin
              AParentTreeViewItem:=FPreParentTreeViewItem;
//              AParentTreeViewItem.Height:=0;
            end;


//            for J := 0 to AShopGoodsCategoryList[I].Count-1 do
//            begin

//            AIsOffsell:=True;
            //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --6');
            for I := 0 to AShopGoodsList.Count-1 do
            begin
              FShopGoodsList.Add(AShopGoodsList[I]);


              AIsOffsell:=True;
              for J := 0 to AShopGoodsList[I].GoodsSpecList.Count-1 do
              begin
                if AShopGoodsList[I].GoodsSpecList[J].is_offsell=0 then
                begin
                  //上架
                  AIsOffsell:=False;
                  Break;
                end;
              end;

              //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --7 --'+IntToStr(I));
              if AIsOffsell=False then
              begin

//                  AIsShowCateGory:=True;
                  AParentTreeViewItem.Visible:=True;
                  AParentTreeViewItem.Height:=0;
//                  FPreParentTreeViewItem:=AParentTreeViewItem;
                  //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --7 --'+IntToStr(I)+'--1');
                  AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
                  AChildTreeViewItem.Caption:=AShopGoodsList[I].name;
                  AChildTreeViewItem.Name:=IntToStr(AShopGoodsList[I].fid);
                  if AShopGoodsList[I].GoodsSpecList.Count>0 then
                  begin
                    AMinSpecialPrice:=0;
                    AMinOriginPrice:=0;
                    //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --7 --'+IntToStr(I)+'--2');
                    if AShopGoodsList[I].GoodsSpecList[0].special_price<>0 then
                    begin
                      //活动价
                      AMinSpecialPrice:=AShopGoodsList[I].GoodsSpecList[0].special_price;
                      AMinOriginPrice:=AShopGoodsList[I].GoodsSpecList[0].price;
                    end
                    else
                    begin
                      //原价
                      AMinSpecialPrice:=AShopGoodsList[I].GoodsSpecList[0].price;
                      AMinOriginPrice:=0;
                    end;
                    //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --7 --'+IntToStr(I)+'--3');
                    for g := 0 to AShopGoodsList[I].GoodsSpecList.Count-1 do
                    begin
                      if AShopGoodsList[I].GoodsSpecList[g].special_price<>0 then
                      begin
                        //比活动价
                        if AMinSpecialPrice>=AShopGoodsList[I].GoodsSpecList[g].special_price then
                        begin
                          AMinSpecialPrice:=AShopGoodsList[I].GoodsSpecList[g].special_price;
                          AMinOriginPrice:=AShopGoodsList[I].GoodsSpecList[g].price;
                        end;
                      end
                      else
                      begin
                        //比原价
                        if AMinSpecialPrice>=AShopGoodsList[I].GoodsSpecList[g].price then
                        begin
                          AMinSpecialPrice:=AShopGoodsList[I].GoodsSpecList[g].price;
                          AMinOriginPrice:=0;
                        end;
                      end;

                    end;
                    //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --7 --'+IntToStr(I)+'--4');
                    AChildTreeViewItem.Detail:='￥'+Format('%.2f',[AMinSpecialPrice]);
                    if AMinOriginPrice<>0 then
                    begin
                      AChildTreeViewItem.Detail4:=Format('%.2f',[AMinOriginPrice]);
                    end
                    else
                    begin
                      AChildTreeViewItem.Detail4:='';
                    end;
                    AChildTreeViewItem.Detail6:=Format('%.2f',[AMinSpecialPrice]);
                    //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --7 --'+IntToStr(I)+'--5');
                  end
                  else
                  begin
                    AChildTreeViewItem.Detail:='没有标价';
                  end;
                  AChildTreeViewItem.Detail1:='月售'+IntToStr(AShopGoodsList[I].month_sales);
                  AChildTreeViewItem.Detail3:='好评率'+FloatToStr(AShopGoodsList[I].satisfy_rate*100)+'%';
                  AChildTreeViewItem.Data:=AShopGoodsList[I];
                  AChildTreeViewItem.Icon.Url:=AShopGoodsList[I].GetPic1Url;
                  //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --7 --'+IntToStr(I)+'--6');
                  if Self.FIsDoBusiness=True then
                  begin

                     Self.UpDateShopListFrame(GlobalManager.UserCarShopList);
                  end;
                  //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --7 --'+IntToStr(I)+'--7');
                  if AShopGoodsList[I].is_new=1 then
                  begin
                    AChildTreeViewItem.Pic.ImageIndex:=0;
                  end
                  else if AShopGoodsList[I].is_featured=1 then
                  begin
                    AChildTreeViewItem.Pic.ImageIndex:=1;
                  end
                  else
                  begin
                    AChildTreeViewItem.Pic.ImageIndex:=-1;
                  end;
                  //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --7 --'+IntToStr(I)+'--8');
//                end;

              end;
            end;

          end;

        finally
          Self.tvShopGoodsList.Prop.Items.EndUpdate();
          FreeAndNil(AShopGoodsList);
        end;

        Self.tvShopGoodsList.Prop.VertControlGestureManager.Position:=0;
        //FMX.Types.Log.d('OrangeUI ShopGoodsList result begin --8 ');
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
    //结束加载
    if FPageIndex>1 then
    begin
      if (TTimerTask(ATimerTask).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['GoodsList'].Length>0) then
      begin
        Self.tvShopGoodsList.Prop.StopPullUpLoadMore('加载成功!',0,True);
      end
      else
      begin
        Self.tvShopGoodsList.Prop.StopPullUpLoadMore('下面没有了!',600,False);
      end;
    end
    else
    begin
      Self.tvShopGoodsList.Prop.StopPullDownRefresh('刷新成功!',600);
    end;
  end;
end;

procedure TFrameShopGoodsList.lbShopCategoryListClickItem(AItem: TSkinItem);
begin
  //FMX.Types.Log.d('OrangeUI ---Category  Click --1');
  if Self.FShop.has_lot_goods=0 then
  begin
    //FMX.Types.Log.d('OrangeUI ---Category  Click --2');
    Self.tvShopGoodsList.Prop.ScrollToItem(Self.tvShopGoodsList.Prop.Items.FindItemByName(AItem.Detail6));
  end
  else
  begin
    //FMX.Types.Log.d('OrangeUI ---Category  Click --3');
    FFilterCategoryFID:=StrToInt(AItem.Detail6);

    Self.FPageIndex:=1;
    //FMX.Types.Log.d('OrangeUI ---Category  Click --4');
    Self.tvShopGoodsList.Prop.VertControlGestureManager.Position:=
              Self.tvShopGoodsList.Prop.VertControlGestureManager.Max;

    //FMX.Types.Log.d('OrangeUI ---Category  Click --5');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                  DoGetPageGoodsListExecute,
                  DoGetPageGoodsListExecuteEnd,
                  'GetPageGoodsList');
    //FMX.Types.Log.d('OrangeUI ---Category  Click --6');
  end;
end;


procedure TFrameShopGoodsList.lbShopCategoryListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
//  //FMX.Types.Log.d('OrangeUI ---Category  Prepare DrawItem --1');
 Self.lblCategoryName.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Alpha or TAlphaColor(HexToInt(AItem.Detail5));
end;

procedure TFrameShopGoodsList.AddCar(AIsAdd:Boolean;APrice:Double);
begin

  if AIsAdd=True then
  begin
    Self.FFilterPrice:=Self.FFilterPrice+APrice;
  end
  else
  begin
    Self.FFilterPrice:=Self.FFilterPrice-APrice;
  end;



  if FFilterPrice<>0 then
  begin
    TFrameShopInfo(FGlobalShopInfoFrame).imgPic.Prop.Picture.ImageIndex:=1;
    TFrameShopInfo(FGlobalShopInfoFrame).lblSelectedPay.Caption:='￥'+Format('%.2f',[FFilterPrice]);
    TFrameShopInfo(FGlobalShopInfoFrame).lblSelectedPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.White;

    if FDeliverMinOrderAccount>FFilterPrice then
    begin
      TFrameShopInfo(FGlobalShopInfoFrame).lblPay.Visible:=True;
      TFrameShopInfo(FGlobalShopInfoFrame).lblPay.Caption:='还差 ￥'+Format('%.2f',[FDeliverMinOrderAccount-FFilterPrice]);
      TFrameShopInfo(FGlobalShopInfoFrame).btnPay.Visible:=False;
    end
    else
    begin
      TFrameShopInfo(FGlobalShopInfoFrame).lblPay.Visible:=False;
      TFrameShopInfo(FGlobalShopInfoFrame).btnPay.Visible:=True;
    end;

  end
  else
  begin
    TFrameShopInfo(FGlobalShopInfoFrame).imgPic.Prop.Picture.ImageIndex:=0;

    TFrameShopInfo(FGlobalShopInfoFrame).lblSelectedPay.Caption:='未选购的商品';
    TFrameShopInfo(FGlobalShopInfoFrame).lblSelectedPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Lightgray;
    TFrameShopInfo(FGlobalShopInfoFrame).lblPay.Visible:=True;
    TFrameShopInfo(FGlobalShopInfoFrame).lblPay.Caption:='￥'+FloatToStr(FDeliverMinOrderAccount)+'起送';
    TFrameShopInfo(FGlobalShopInfoFrame).btnPay.Visible:=False;

  end;
end;

procedure TFrameShopGoodsList.Load(AShop:TShop;
                                   //ACarGoodList:TCarGoodList;
                                   AIsDoBusiness:Boolean;
                                   AShopInfoFrame:TFrame);
var
  AListBoxItem:TSkinListBoxItem;
  I: Integer;
  J:Integer;
  K:Integer;
  h:Integer;
  l:Integer;
  ANumber:Integer;
  AParentTreeViewItem:TSkinTreeViewItem;
  AChildTreeViewItem:TSkinTreeViewItem;
  AShopGoodsCategory:TShopGoodsCategory;
  AMinSpecialPrice:Double;
  AMinOriginPrice:Double;
  g: Integer;
  ASumPrice:Double;
  AIsOffsell:Boolean;
  AIsShowCateGory:Boolean;
  ADesc:String;

  ATempImgPath:String;
  ATempIndex:Integer;
begin
  //原来在Create方法里的
  FGlobalShopInfoFrame:=AShopInfoFrame;
  TFrameShopInfo(FGlobalShopInfoFrame).pnlCar.Visible:=AIsDoBusiness;

  Self.FShop:=AShop;

  FIsDoBusiness:=AIsDoBusiness;


  FDeliverMinOrderAccount:=AShop.deliver_min_order_amount;

  Self.lbShopCategoryList.Prop.Items.Clear(True);




  Self.lbShopCategoryList.Prop.Items.BeginUpdate;
  try

    for J := 0 to AShop.ShopGoodsCategoryList.Count-1 do
    begin

      AListBoxItem:=Self.lbShopCategoryList.Prop.Items.Add;

      AListBoxItem.Data:=AShop.ShopGoodsCategoryList[J];
      AListBoxItem.Caption:=AShop.ShopGoodsCategoryList[J].name;
      AListBoxItem.Detail6:=IntToStr(AShop.ShopGoodsCategoryList[J].fid);
      //分类颜色
      AListBoxItem.Detail5:=AShop.ShopGoodsCategoryList[J].name_color;

      //默认选中第一个
      if J=0 then
      begin
        AListBoxItem.Selected:=True;
        Self.FFilterCategoryFID:=AShop.ShopGoodsCategoryList[J].fid;
      end;

    end;
  finally
    Self.lbShopCategoryList.Prop.Items.EndUpdate();
  end;

  //FMX.Types.Log.d('OrangeUI ShopGoodsList Count '+IntToStr(AShop.ShopGoodsList.Count));

//  if AShop.has_lot_goods=0 then
//  begin

//    Self.tvShopGoodsList.Prop.EnableAutoPullDownRefreshPanel:=False;
//    Self.tvShopGoodsList.Prop.EnableAutoPullUpLoadMorePanel:=False;

  Self.tvShopGoodsList.Prop.Items.BeginUpdate;
  try
    Self.tvShopGoodsList.Prop.Items.Clear(True);


    for I := 0 to AShop.ShopGoodsCategoryList.Count-1 do
    begin

      AShopGoodsCategory:=AShop.ShopGoodsCategoryList[I];

      AParentTreeViewItem:=Self.tvShopGoodsList.Prop.Items.Add;
      AParentTreeViewItem.Caption:=AShopGoodsCategory.name;
      //有换行会卡死
//      ADesc:=ReplaceStr(#13#10,'',AShopGoodsCategory.category_desc);
//      ADesc:=ReplaceStr(#13,'',ADesc);
//      ADesc:=ReplaceStr(#10,'',ADesc);
//      AParentTreeViewItem.Detail:='  '+ADesc;
      AParentTreeViewItem.Name:=IntToStr(AShopGoodsCategory.fid);
      AParentTreeViewItem.IsParent:=True;
      AParentTreeViewItem.Data:=AShop.ShopGoodsCategoryList[I];

//      AParentTreeViewItem.Visible:=True;
      FPreParentTreeViewItem:=AParentTreeViewItem;

      AIsShowCateGory:=False;
      for K := 0 to AShop.ShopGoodsList.Count-1 do
      begin

        AIsOffsell:=True;

        for l := 0 to AShop.ShopGoodsList[K].GoodsSpecList.Count-1 do
        begin
          if AShop.ShopGoodsList[K].GoodsSpecList[l].is_offsell=0 then
          begin
            //上架
            AIsOffsell:=False;
          end;
        end;

        if AIsOffsell=False then
        begin

          if AShopGoodsCategory.fid=AShop.ShopGoodsList[K].shop_goods_category_fid then
          begin

            AIsShowCateGory:=True;

            AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
            AChildTreeViewItem.Caption:=AShop.ShopGoodsList[K].name;
            AChildTreeViewItem.Name:=IntToStr(AShop.ShopGoodsList[K].fid);
            if AShop.ShopGoodsList[K].GoodsSpecList.Count>0 then
            begin
              AMinSpecialPrice:=0;
              AMinOriginPrice:=0;

              if AShop.ShopGoodsList[K].GoodsSpecList[0].special_price<>0 then
              begin
                //活动价
                AMinSpecialPrice:=AShop.ShopGoodsList[K].GoodsSpecList[0].special_price;
                AMinOriginPrice:=AShop.ShopGoodsList[K].GoodsSpecList[0].price;
              end
              else
              begin
                //原价
                AMinSpecialPrice:=AShop.ShopGoodsList[K].GoodsSpecList[0].price;
                AMinOriginPrice:=0;
              end;

              for g := 0 to AShop.ShopGoodsList[K].GoodsSpecList.Count-1 do
              begin
                if AShop.ShopGoodsList[K].GoodsSpecList[g].special_price<>0 then
                begin
                  //比活动价
                  if AMinSpecialPrice>=AShop.ShopGoodsList[K].GoodsSpecList[g].special_price then
                  begin
                    AMinSpecialPrice:=AShop.ShopGoodsList[K].GoodsSpecList[g].special_price;
                    AMinOriginPrice:=AShop.ShopGoodsList[K].GoodsSpecList[g].price;
                  end;
                end
                else
                begin
                  //比原价
                  if AMinSpecialPrice>=AShop.ShopGoodsList[K].GoodsSpecList[g].price then
                  begin
                    AMinSpecialPrice:=AShop.ShopGoodsList[K].GoodsSpecList[g].price;
                    AMinOriginPrice:=0;
                  end;
                end;

              end;

              AChildTreeViewItem.Detail:='￥'+Format('%.2f',[AMinSpecialPrice]);
              if AMinOriginPrice<>0 then
              begin
                AChildTreeViewItem.Detail4:=Format('%.2f',[AMinOriginPrice]);
              end
              else
              begin
                AChildTreeViewItem.Detail4:='';
              end;
              AChildTreeViewItem.Detail6:=Format('%.2f',[AMinSpecialPrice]);

            end
            else
            begin
              AChildTreeViewItem.Detail:='没有标价';
            end;
            AChildTreeViewItem.Detail1:='月售'+IntToStr(AShop.ShopGoodsList[K].month_sales);
            AChildTreeViewItem.Detail3:='好评率'+FloatToStr(AShop.ShopGoodsList[K].satisfy_rate*100)+'%';
            AChildTreeViewItem.Data:=AShop.ShopGoodsList[K];
            //原图的路径
            ATempImgPath:=AShop.ShopGoodsList[K].GetPic1Url;
//            //处理下  改成缩略图的路径    原图占内存太大了
//            ATempIndex:=ATempImgPath.LastIndexOf('/');
//            ATempImgPath:=ATempImgPath.Substring(0,ATempIndex+1)
//                          +'thumb_'
//                          +ATempImgPath.Substring(ATempIndex+1);
            AChildTreeViewItem.Icon.Url:=ATempImgPath;

            if AIsDoBusiness=True then
            begin
              Self.UpDateShopListFrame(GlobalManager.UserCarShopList);
            end;

            if Ashop.ShopGoodsList[K].is_new=1 then
            begin
              AChildTreeViewItem.Pic.ImageIndex:=0;
            end
            else if AShop.ShopGoodsList[K].is_featured=1 then
            begin
              AChildTreeViewItem.Pic.ImageIndex:=1;
            end
            else
            begin
              AChildTreeViewItem.Pic.ImageIndex:=-1;
            end;

          end;

        end;
      end;

      AParentTreeViewItem.Visible:=AIsShowCateGory;

    end;

  finally
    Self.tvShopGoodsList.Prop.Items.EndUpdate();
  end;

  if AShop.has_lot_goods=0 then
  begin
//    Self.tvShopGoodsList.Prop.EnableAutoPullUpLoadMorePanel:=False;
    Self.tvShopGoodsList.Properties.VertCanOverRangeTypes:=[];
  end
  else
  begin
    Self.FPageIndex:=1;
//    Self.tvShopGoodsList.Prop.EnableAutoPullUpLoadMorePanel:=True;
    Self.tvShopGoodsList.Properties.VertCanOverRangeTypes:=[cortMax];
  end;


  if AIsDoBusiness=True then
  begin

//    GlobalShopInfoFrame.UpDateShopInfo;
//    if ACarGoodList<>nil then
//    begin
//      ASumPrice:=0;
//      GlobalShopInfoFrame.nniUserCartNumber.Prop.Number:=0;
//      for h := 0 to ACarGoodList.Count-1 do
//      begin
//        if ACarGoodList[h].special_price<>0 then
//        begin
//          ASumPrice:=ACarGoodList[h].special_price*ACarGoodList[h].number;
//  //        Self.AddCar(True,ACarGoodList[h].special_price*ACarGoodList[h].number);
//        end
//        else
//        begin
//          ASumPrice:=ACarGoodList[h].origin_price*ACarGoodList[h].number;
//  //        Self.AddCar(True,ACarGoodList[h].origin_price*ACarGoodList[h].number);
//        end;
//
//        ASumPrice:=ASumPrice+ACarGoodList[h].shop_goods_spec_packing_fee*ACarGoodList[h].number;
//
//        Self.AddCar(True,ASumPrice);
//
//        GlobalShopInfoFrame.nniUserCartNumber.Prop.Number:=
//            GlobalShopInfoFrame.nniUserCartNumber.Prop.Number+ACarGoodList[h].number;
//      end;
//    end
//    else
//    begin
//
//      GlobalShopInfoFrame.imgPic.Prop.Picture.ImageIndex:=0;
//
//      GlobalShopInfoFrame.nniUserCartNumber.Prop.Number:=0;
//
//      GlobalShopInfoFrame.lblSelectedPay.Caption:='未选购的商品';
//      GlobalShopInfoFrame.lblSelectedPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Lightgray;
//      GlobalShopInfoFrame.lblPay.Visible:=True;
//      GlobalShopInfoFrame.lblPay.Caption:='￥'+FloatToStr(AShop.deliver_min_order_amount)+'起送';
//      GlobalShopInfoFrame.btnPay.Visible:=False;
//    end;
  end;

  if Self.FIsDoBusiness=True then
  begin
//    if (AShop.is_can_takeorder_but_only_self_take=0)
//    AND (AShop.is_can_takeorder_and_delivery=0)
//    AND (AShop.is_can_takeorder_but_only_eat_in_shop=0) then
//    begin
//      Self.btnAdd.Prop.Icon.ImageIndex:=1;
//
//      Self.btnAdd.Enabled:=False;
//      Self.btnDesc.Visible:=False;
//      Self.edtCount.Visible:=False;
//
//      TFrameShopInfo(FGlobalShopInfoFrame).pnlCar.Visible:=False;
//      TFrameShopInfo(FGlobalShopInfoFrame).pnlRest.Visible:=True;
//    end
//    else
//    begin
      Self.btnAdd.Prop.Icon.ImageIndex:=0;

      Self.btnAdd.Enabled:=True;
      Self.btnDesc.Visible:=True;
      Self.edtCount.Visible:=True;

      TFrameShopInfo(FGlobalShopInfoFrame).pnlCar.Visible:=True;
      TFrameShopInfo(FGlobalShopInfoFrame).pnlRest.Visible:=False;
//    end;

  end
  else
  begin
    Self.btnAdd.Prop.Icon.ImageIndex:=1;

    Self.btnAdd.Enabled:=False;
    Self.btnDesc.Visible:=False;
    Self.edtCount.Visible:=False;

//    GlobalShopInfoFrame.pnlCar.Visible:=False;
//    GlobalShopInfoFrame.pnlRest.Visible:=True;
  end;

  Self.tvShopGoodsList.Prop.VertControlGestureManager.Position:=0;

end;


procedure TFrameShopGoodsList.OnReturnFromGoodsInfoFrame(AFrame: TFrame);
begin


//  GlobalShopInfoFrame.UpDataMyCar;

//  Self.FFilterGoodsSpecFID:=GlobalShopAddUserCarFrame.FFilterSpecFID;
//  Self.FFilterGoodsAttrValue:=GlobalShopAddUserCarFrame.FFilterAttrValue.CommaText;
//
//  if GlobalShopAddUserCarFrame.FFilterCount<>0 then
//  begin
//    FChildTreeViewItem.Detail2:=IntToStr(GlobalShopAddUserCarFrame.FFilterCount);
//    GlobalShopInfoFrame.nniUserCartNumber.Prop.Number:=
//                      GlobalShopInfoFrame.nniUserCartNumber.Prop.Number+1;
//
//    Self.AddCar(True,GlobalShopAddUserCarFrame.FFilterPrice+GlobalShopAddUserCarFrame.FFilterPackFee);
//  end
//  else
//  begin
//    FChildTreeViewItem.Detail2:='';
//  end;


  TFrameShopInfo(FGlobalShopInfoFrame).FAddUserCarFrameIsShow:=False;

//  if GlobalShopAddUserCarFrame.FFilterPrice<>0 then
//  begin
//    FChildTreeViewItem.Detail6:=FloatToStr(GlobalShopAddUserCarFrame.FFilterPrice);
//  end
//  else
//  begin
//    FChildTreeViewItem.Detail6:='';
//  end;

//  Self.Sum:=GlobalShopAddUserCarFrame.FFilterCount;

//  //记录添加数
//  Self.tvShopGoodsList.Prop.InteractiveItem.Detail2:=IntToStr(GlobalShopGoodsInfoFrame.FFilterCount);

end;


procedure TFrameShopGoodsList.OnReturnFromShopGoodInfoFrame(AFrame: TFrame);
begin
//  GlobalShopInfoFrame.UpDataMyCar;

//  if GlobalShopGoodsInfoFrame.FFilterCount<>0 then
//  begin
//    FChildTreeViewItem.Detail2:=IntToStr(GlobalShopGoodsInfoFrame.FFilterCount);
//  end
//  else
//  begin
//    FChildTreeViewItem.Detail2:='';
//  end;

end;

procedure TFrameShopGoodsList.tvShopGoodsListClickItem(AItem: TSkinItem);
var
  AShopGoods:TShopGoods;
  ACarGoodFID:Integer;
  AIsTakeOrder:Boolean;
begin
  //FMX.Types.Log.d('OrangeUI Goods Click --1');
  if AItem.Data<>nil then
  begin
    AIsTakeOrder:=False;
    //FMX.Types.Log.d('OrangeUI Goods Click --2');
    if (FShop.is_can_takeorder_but_only_self_take=0)
    AND (FShop.is_can_takeorder_and_delivery=0)
    AND (FShop.is_can_takeorder_but_only_eat_in_shop=0) then
    begin
       AIsTakeOrder:=False;
    end
    else
    begin
       AIsTakeOrder:=True;
    end;
    //FMX.Types.Log.d('OrangeUI Goods Click --3');
    FChildTreeViewItem:=TSkinTreeViewItem(AItem);

    if FChildTreeViewItem.Detail5<>'' then
    begin
      ACarGoodFID:=StrToInt(FChildTreeViewItem.Detail5);
    end
    else
    begin
      ACarGoodFID:=0;
    end;

    //FMX.Types.Log.d('OrangeUI Goods Click --4');
    if TSkinTreeViewItem(AItem).IsParent=False then
    begin
      //FMX.Types.Log.d('OrangeUI Goods Click --4--1');
      AShopGoods:=TShopGoods(TSkinTreeViewItem(AItem).Data);
      //FMX.Types.Log.d('OrangeUI Goods Click --4--2');
      ShowFrame(TFrame(GlobalShopGoodsInfoFrame),TFrameShopGoodsInfo,frmMain,nil,nil,OnReturnFromShopGoodInfoFrame,Application,True,False,ufsefNone);
      //FMX.Types.Log.d('OrangeUI Goods Click --4--3');
      GlobalShopGoodsInfoFrame.Clear;
      //FMX.Types.Log.d('OrangeUI Goods Click --4--4');
      GlobalShopGoodsInfoFrame.Init(AItem.Detail2,ACarGoodFID,Self.FDeliverMinOrderAccount,AShopGoods,FIsDoBusiness,AIsTakeOrder);

    end;
  end;
  //FMX.Types.Log.d('OrangeUI Goods Click --5');
end;

procedure TFrameShopGoodsList.tvShopGoodsListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AShopGoods:TShopGoods;
begin
//  //FMX.Types.Log.d('OrangeUI Goods Prepare DrawItem --1');
  if AItem.Detail2='' then
  begin
    Self.btnDesc.Visible:=False;
    Self.edtCount.Visible:=False;
  end
  else
  begin
    if (FShop.is_can_takeorder_but_only_self_take=0)
    AND (FShop.is_can_takeorder_and_delivery=0)
    AND (FShop.is_can_takeorder_but_only_eat_in_shop=0) then
    begin
      Self.edtCount.Visible:=False;
      Self.btnDesc.Visible:=False;
    end
    else
    begin
      Self.edtCount.Visible:=True;
      Self.btnDesc.Visible:=True;
    end;
  end;
// //FMX.Types.Log.d('OrangeUI Goods Prepare DrawItem --2');
end;

procedure TFrameShopGoodsList.tvShopGoodsListPullUpLoadMore(Sender: TObject);
begin
  FPageIndex:=FPageIndex+1;

  uTimerTask.GetGlobalTimerThread.RunTempTask(
                DoGetPageGoodsListExecute,
                DoGetPageGoodsListExecuteEnd,
                'GetPageGoodsList');
end;

procedure TFrameShopGoodsList.UpDateShopListFrame(ACarShopList: TCarShopList);
var
  I: Integer;
  AShopGoods:TShopGoods;
  J: Integer;
  k: Integer;
  h: Integer;
  ANumber:Integer;
begin
  if ACarShopList<>nil then
  begin
    ANumber:=0;


    for I := 0 to Self.tvShopGoodsList.Prop.Items.Count-1 do
    begin


      for J := 0 to Self.tvShopGoodsList.Prop.Items[I].Childs.Count-1 do
      begin

         Self.tvShopGoodsList.Prop.Items[I].Childs[J].Detail2:='';

        if Self.tvShopGoodsList.Prop.Items[I].Childs[J].Data<>nil then
        begin
          AShopGoods:=TShopGoods(Self.tvShopGoodsList.Prop.Items[I].Childs[J].Data);

          for k := 0 to ACarShopList.Count-1 do
          begin
            for h := 0 to ACarShopList[k].FCarGoodList.Count-1 do
            begin
              if AShopGoods.fid=ACarShopList[k].FCarGoodList[h].shop_goods_fid then
              begin

                Self.tvShopGoodsList.Prop.Items[I].Childs[J].Detail2:=IntToStr(ACarShopList[k].FCarGoodList[h].number);
                Self.tvShopGoodsList.Prop.Items[I].Childs[J].Detail5:=IntToStr(ACarShopList[k].FCarGoodList[h].fid);

              end;
            end;

          end;
        end;

      end;


    end;


  end;
end;

end.
