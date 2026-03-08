unit AddCarGoodsFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  MessageBoxFrame,
  SelectAreaFrame,
  uUIFunction,
  uManager,
  uGPSLocation,
  uFrameContext,
  uBaseList,

  uOpenCommon,
  uOpenClientCommon,
  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,

  uSkinBufferBitmap,

  XSuperObject,
  XSuperJson,

  uSkinItems,

  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinTreeViewType, uSkinFireMonkeyTreeView, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinLabelType,
  uSkinFireMonkeyLabel, FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uDrawCanvas, uSkinListViewType;

type
  TFrameAddCarGoods = class(TFrame)
    pnlBankGroud: TSkinFMXPanel;
    tvGoods: TSkinFMXTreeView;
    idpCarShop: TSkinFMXItemDesignerPanel;
    btnSelected: TSkinFMXButton;
    btnDel: TSkinFMXButton;
    idpCarGoods: TSkinFMXItemDesignerPanel;
    lblGoodsName: TSkinFMXLabel;
    mclPrice: TSkinFMXMultiColorLabel;
    btnDesc: TSkinFMXButton;
    edtCount: TSkinFMXEdit;
    btnAdd: TSkinFMXButton;
    idpToolPrice: TSkinFMXItemDesignerPanel;
    lblSumDetail: TSkinFMXLabel;
    lblSum: TSkinFMXLabel;
    mclGoodsSpec: TSkinFMXMultiColorLabel;
    procedure btnDescClick(Sender: TObject);
    procedure pnlBankGroudClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
  private
    FCarShopList:TCarShopList;
    //获取购物车列表
    procedure DoGetUserCarGoodsListExecute(ATimerTask:TObject);
    procedure DoGetUserCarGoodsListExecuteEnd(ATimerTask:TObject);
  private
    FFilterDelShopFID:Integer;
    //删除商家购物车商品
    procedure DoDelCarShopExecute(ATimerTask:TObject);
    procedure DoDelCarShopExecuteEnd(ATimerTask:TObject);
  private
    //删除购物车商品
    FChildTreeViewItem:TBaseSkinTreeViewItem;
    FFilterDelFID:Integer;

    FFilterDelNumber:Integer;

    procedure DoDelUserCerGoodsExecute(ATimerTask:TObject);
    procedure DoDelUserCerGoodsExecuteEnd(ATimerTask:TObject);
  private
    FFilterShopFID:Integer;
    FFilterGoodsFID:Integer;
    FFilterSpecFID:Integer;
    FFilterAttrValue:String;
    FFilterOrderno:Double;
    FFilterNumber:Integer;
    //添加购物车
    procedure DoAddGoodsToUserCarExecute(ATimerTask:TObject);
    procedure DoAddGoodsToUserCarExecuteEnd(ATimerTask:TObject);


    { Private declarations }
  public
    //删除的商品价格
    FDelGoodsPrice:Double;
    //清空
    procedure Clear;
    procedure Init;


    //直接加载
    procedure Load(AShopInfoFrame:TFrame);
  public
    //同一个界面共用  传进来的
    FGlobalShopInfoFrame:TFrame;

//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalAddCarGoodsFrame:TFrameAddCarGoods;

implementation

{$R *.fmx}
uses
  ShopGoodsListFrame,
  ShopInfoFrame,
  MainForm,
  MainFrame;

{ TFrameAddCarGoods }

procedure TFrameAddCarGoods.btnAddClick(Sender: TObject);
var
  ACarGood:TCarGood;
begin
  //添加购物车
  FChildTreeViewItem:=Self.tvGoods.Prop.InteractiveItem;

  ACarGood:=TCarGood(FChildTreeViewItem.Data);

  FFilterShopFID:=ACarGood.shop_fid;
  FFilterGoodsFID:=ACarGood.shop_goods_fid;
  FFilterSpecFID:=ACarGood.shop_goods_spec_fid;
  FFilterAttrValue:=ACarGood.shop_goods_attrs;
  FFilterOrderno:=ACarGood.orderno;
  FFilterNumber:=ACarGood.number;

  GlobalMainFrame.AddGoodsToUserCart(Self.FFilterShopFID,
                                     Self.FFilterGoodsFID,
                                     Self.FFilterSpecFID,
                                     1,
                                     Self.FFilterAttrValue,
                                     Self.FFilterOrderno);

  if FChildTreeViewItem.Detail3<>'' then
  begin
    FChildTreeViewItem.Detail3:=IntToStr(StrToInt(FChildTreeViewItem.Detail3)+1);
  end;


//  GlobalShopInfoFrame.FShopGoodsListFrame.Load(GlobalShopInfoFrame.FShop,nil,GlobalShopInfoFrame.FIsDoBusiness);


//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                 DoAddGoodsToUserCarExecute,
//                 DoAddGoodsToUserCarExecuteEnd);

end;

procedure TFrameAddCarGoods.btnDelClick(Sender: TObject);
var
  ACarShop:TCarShop;
begin
  ACarShop:=TCarShop(Self.tvGoods.Prop.InteractiveItem.Data);

  FFilterDelShopFID:=ACarShop.fid;
  //清空
  ShowWaitingFrame(Self,'删除中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                 DoDelCarShopExecute,
                 DoDelCarShopExecuteEnd,
                 'DelCarShop');
end;

procedure TFrameAddCarGoods.btnDescClick(Sender: TObject);
var
  ACarGood:TCarGood;
begin
  //从购物车中删除商品
  FChildTreeViewItem:=Self.tvGoods.Prop.InteractiveItem;

  ACarGood:=TCarGood(FChildTreeViewItem.Data);

  Self.FFilterDelFID:=ACarGood.fid;

  FFilterDelNumber:=StrToInt(FChildTreeViewItem.Detail3)-1;

  GlobalMainFrame.UpdateCartGoodsNumber(Self.FFilterDelFID,Self.FFilterDelNumber);


  if Self.FFilterDelNumber<>0 then
  begin
    FChildTreeViewItem.Detail3:=IntToStr(Self.FFilterDelNumber);
  end
  else
  begin
    FChildTreeViewItem.Detail3:='';
  end;

//  if TFrameShopInfo(FGlobalShopInfoFrame).FShopGoodsListFrame<>nil then
//  begin
//    TFrameShopInfo(FGlobalShopInfoFrame).FShopGoodsListFrame.Load(TFrameShopInfo(FGlobalShopInfoFrame).FShop,nil,TFrameShopInfo(FGlobalShopInfoFrame).FIsDoBusiness,TFrameShopInfo(FGlobalShopInfoFrame));
//  end;


//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                DoDelUserCerGoodsExecute,
//                DoDelUserCerGoodsExecuteEnd);
end;

procedure TFrameAddCarGoods.Clear;
begin
  FFilterShopFID:=0;
  FFilterGoodsFID:=0;
  FFilterSpecFID:=0;
  FFilterAttrValue:='';
  FFilterOrderno:=0;
  FFilterNumber:=0;

  Self.tvGoods.Prop.Items.Clear(True);

  Self.tvGoods.Height:=0;

  Self.pnlBankGroud.Visible:=False;

end;

constructor TFrameAddCarGoods.Create(AOwner: TComponent);
begin
  inherited;
  FCarShopList:=TCarShopList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;



destructor TFrameAddCarGoods.Destroy;
begin
  FreeAndNil(FCarShopList);
  inherited;
end;



procedure TFrameAddCarGoods.DoAddGoodsToUserCarExecute(ATimerTask: TObject);
begin
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
                                                      Self.FFilterShopFID,
                                                      GlobalManager.User.key,
                                                      Self.FFilterGoodsFID,
                                                      Self.FFilterSpecFID,
                                                      1,
                                                      Self.FFilterOrderno,
                                                      Self.FFilterAttrValue
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
end;

procedure TFrameAddCarGoods.DoAddGoodsToUserCarExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ASumPrice:Double;
  ACarGood:TCarGood;
  BCarGood:TCarGood;
  ANumber:Integer;
  I:Integer;
  APackFee:Double;
begin
  ANumber:=0;
  APackFee:=0;
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //添加成功
//        ACarGood:=TCarGood(FChildTreeViewItem.Data);


        Self.Init;

//        GlobalManager.UserCartGoodsList.Add(ACarGood);

//        FChildTreeViewItem.Detail3:=IntToStr(StrToInt(FChildTreeViewItem.Detail3)+1);
//
//        if ACarGood.special_price<>0 then
//        begin
//          FChildTreeViewItem.Detail1:='￥'+FloatToStr(ACarGood.special_price);
//          FChildTreeViewItem.Detail2:='￥'+FloatToStr(ACarGood.origin_price);
//        end
//        else
//        begin
//          FChildTreeViewItem.Detail1:='￥'+FloatToStr(ACarGood.origin_price);
//          FChildTreeViewItem.Detail2:='';
//        end;
//
//        if Self.tvGoods.Prop.Items.FindItemByCaption('餐盒')<>nil then
//        begin
//          Self.tvGoods.Prop.Items.FindItemByCaption('餐盒').Detail6:=FloatToStr(StrToFloat(Self.tvGoods.Prop.Items.FindItemByCaption('餐盒').Detail6)+ACarGood.shop_goods_spec_packing_fee);
//          Self.tvGoods.Prop.Items.FindItemByCaption('餐盒').Detail:='￥'+Self.tvGoods.Prop.Items.FindItemByCaption('餐盒').Detail6;
//        end;
//
//
        TFrameShopInfo(FGlobalShopInfoFrame).nniUserCartNumber.Prop.Number:=
                              TFrameShopInfo(FGlobalShopInfoFrame).nniUserCartNumber.Prop.Number+1;
//        GlobalShopInfoFrame.UpDataMyCar;

//        ASumPrice:=0;
//        for I := 0 to Self.tvGoods.Prop.Items.FindItemByCaption('已选商品').Childs.count-1 do
//        begin
//          if Self.tvGoods.Prop.Items.FindItemByCaption('已选商品').Childs[I].Data<>nil then
//          begin
//            BCarGood:=TCarGood(Self.tvGoods.Prop.Items.FindItemByCaption('已选商品').Childs[I].Data);
//            if BCarGood.special_price<>0 then
//            begin
//              ASumPrice:=ASumPrice+BCarGood.special_price*StrToInt(Self.tvGoods.Prop.Items.FindItemByCaption('已选商品').Childs[I].Detail3);
//            end
//            else
//            begin
//              ASumPrice:=ASumPrice+BCarGood.origin_price*StrToInt(Self.tvGoods.Prop.Items.FindItemByCaption('已选商品').Childs[I].Detail3);
//            end;
//
//            ASumPrice:=ASumPrice+StrToFloat(Self.tvGoods.Prop.Items.FindItemByCaption('餐盒').Detail6);
//
//          end;
//
//        end;
//
//
//
//        GlobalShopInfoFrame.imgPic.Prop.Picture.ImageIndex:=1;
//        GlobalShopInfoFrame.lblSelectedPay.Caption:='￥'+Format('%.2f',[ASumPrice]);
//        GlobalShopInfoFrame.lblSelectedPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.White;
//
//        if GlobalShopInfoFrame.FFilterMinOrderAccount>ASumPrice then
//        begin
//          GlobalShopInfoFrame.lblPay.Visible:=True;
//          GlobalShopInfoFrame.lblPay.Caption:='还差 ￥'+Format('%.2f',[GlobalShopInfoFrame.FFilterMinOrderAccount-ASumPrice]);
//          GlobalShopInfoFrame.btnPay.Visible:=False;
//        end
//        else
//        begin
//          GlobalShopInfoFrame.lblPay.Visible:=False;
//          GlobalShopInfoFrame.btnPay.Visible:=True;
//        end;


//        GlobalShopInfoFrame.UpDataMyCar;


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

procedure TFrameAddCarGoods.DoDelCarShopExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('del_user_cart_goods_by_shop',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'shop_fid'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FFilterDelShopFID
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

procedure TFrameAddCarGoods.DoDelCarShopExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //删除成功
        HideFrame;//(Self);
//        ReturnFrame(Self.FrameHistroy);
        GlobalMainFrame.UpDateMyCar;
//        GlobalShopInfoFrame.UpDataMyCar;

//        GlobalShopInfoFrame.FAddUserCarFrameIsShow:=False;
//
//
//        GlobalShopInfoFrame.imgPic.Prop.Picture.ImageIndex:=0;
//
//        GlobalShopInfoFrame.nniUserCartNumber.Prop.Number:=0;
//
//        GlobalShopInfoFrame.lblSelectedPay.Caption:='未选购的商品';
//        GlobalShopInfoFrame.lblSelectedPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Lightgray;
//        GlobalShopInfoFrame.lblPay.Visible:=True;
//        GlobalShopInfoFrame.lblPay.Caption:='￥'+FloatToStr(GlobalShopInfoFrame.FFilterMinOrderAccount)+'起送';
//        GlobalShopInfoFrame.btnPay.Visible:=False;
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

procedure TFrameAddCarGoods.DoDelUserCerGoodsExecute(ATimerTask: TObject);
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
                                                      Self.FFilterDelFID,
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

procedure TFrameAddCarGoods.DoDelUserCerGoodsExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ACarGood:TCarGood;
  ANumber:Double;
  I: Integer;
  ASumPrice:Double;
  APackFee:Double;
begin
  ANumber:=0;
  APackFee:=0;
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //删除成功
        ACarGood:=TCarGood(FChildTreeViewItem.Data);

//        if GlobalManager.UserCartGoodsList<>nil then
//        begin
//          for I := 0 to GlobalManager.UserCartGoodsList.Count-1 do
//          begin
//            if GlobalManager.UserCartGoodsList[I].fid=ACarGood.fid then
//            begin
//              GlobalManager.UserCartGoodsList.Remove(GlobalManager.UserCartGoodsList[I]);
//            end;
//          end;
//        end;

          Self.Init;


//        ANumber:=StrToInt(FChildTreeViewItem.Detail3);
//
//        if ACarGood.special_price<>0 then
//        begin
//          FDelGoodsPrice:=ACarGood.special_price;
//        end
//        else
//        begin
//          FDelGoodsPrice:=ACarGood.origin_price;
//        end;
//
//        if ANumber-1>0 then
//        begin
//          Self.FChildTreeViewItem.Detail3:=FloatToStr(ANumber-1);
//        end
//        else
//        begin
//          Self.tvGoods.Prop.Items[0].Childs.Remove(FChildTreeViewItem);
//          Self.tvGoods.Height:=Self.tvGoods.Height-60;
//        end;
//
//        if Self.tvGoods.Prop.Items.FindItemByCaption('餐盒')<>nil then
//        begin
//          Self.tvGoods.Prop.Items.FindItemByCaption('餐盒').Detail6:=FloatToStr(StrToFloat(Self.tvGoods.Prop.Items.FindItemByCaption('餐盒').Detail6)-ACarGood.shop_goods_spec_packing_fee);
//          Self.tvGoods.Prop.Items.FindItemByCaption('餐盒').Detail:='￥'+Self.tvGoods.Prop.Items.FindItemByCaption('餐盒').Detail6;
//        end;
//
//
//
        TFrameShopInfo(FGlobalShopInfoFrame).nniUserCartNumber.Prop.Number:=
                              TFrameShopInfo(FGlobalShopInfoFrame).nniUserCartNumber.Prop.Number-1;
//        if Self.tvGoods.Prop.Items[0].Childs.count=1  then
//        begin
//          HideFrame;//(Self);
////          ReturnFrame(Self.FrameHistroy);
//          GlobalShopInfoFrame.FAddUserCarFrameIsShow:=False;
//
//
//          GlobalShopInfoFrame.imgPic.Prop.Picture.ImageIndex:=0;
//
//          GlobalShopInfoFrame.lblSelectedPay.Caption:='未选购的商品';
//          GlobalShopInfoFrame.lblSelectedPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Lightgray;
//          GlobalShopInfoFrame.lblPay.Visible:=True;
//          GlobalShopInfoFrame.lblPay.Caption:='￥'+FloatToStr(GlobalShopInfoFrame.FFilterMinOrderAccount)+'起送';
//          GlobalShopInfoFrame.btnPay.Visible:=False;
//
//        end
//        else
//        begin
//          ASumPrice:=0;
//          GlobalShopInfoFrame.FAddUserCarFrameIsShow:=True;
//
//          for I := 0 to Self.tvGoods.Prop.Items.FindItemByCaption('已选商品').Childs.count-1 do
//          begin
//            if Self.tvGoods.Prop.Items.FindItemByCaption('已选商品').Childs[I].Data<>nil then
//            begin
//              if Self.tvGoods.Prop.Items.FindItemByCaption('已选商品').Childs[I].Detail3='' then
//              begin
//                Self.tvGoods.Prop.Items.FindItemByCaption('已选商品').Childs[I].Detail3:='0';
//              end;
//
//              ACarGood:=TCarGood(Self.tvGoods.Prop.Items.FindItemByCaption('已选商品').Childs[I].Data);
//              if ACarGood.special_price<>0 then
//              begin
//                ASumPrice:=ASumPrice+ACarGood.special_price*StrToInt(Self.tvGoods.Prop.Items.FindItemByCaption('已选商品').Childs[I].Detail3);
//              end
//              else
//              begin
//                ASumPrice:=ASumPrice+ACarGood.origin_price*StrToInt(Self.tvGoods.Prop.Items.FindItemByCaption('已选商品').Childs[I].Detail3);
//              end;
//
//
////              Self.tvGoods.Prop.Items.FindItemByCaption('餐盒').Detail6:=FloatToStr(StrToFloat(Self.tvGoods.Prop.Items.FindItemByCaption('餐盒').Detail6)+AcarGood.shop_goods_spec_packing_fee*StrToInt(Self.tvGoods.Prop.Items.FindItemByCaption('已选商品').Childs[I].Detail3));
//
//              ASumPrice:=ASumPrice+StrToFloat(Self.tvGoods.Prop.Items.FindItemByCaption('餐盒').Detail6);
//            end;
//          end;
////          ASumPrice:=ASumPrice+StrToFloat(Self.tvGoods.Prop.Items.FindItemByCaption('餐盒').Detail6);
//
//          GlobalShopInfoFrame.imgPic.Prop.Picture.ImageIndex:=1;
//          GlobalShopInfoFrame.lblSelectedPay.Caption:='￥'+Format('%.2f',[ASumPrice]);
//          GlobalShopInfoFrame.lblSelectedPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.White;
//
//          if GlobalShopInfoFrame.FFilterMinOrderAccount>ASumPrice then
//          begin
//            GlobalShopInfoFrame.lblPay.Visible:=True;
//            GlobalShopInfoFrame.lblPay.Caption:='还差 ￥'+Format('%.2f',[GlobalShopInfoFrame.FFilterMinOrderAccount-ASumPrice]);
//            GlobalShopInfoFrame.btnPay.Visible:=False;
//          end
//          else
//          begin
//            GlobalShopInfoFrame.lblPay.Visible:=False;
//            GlobalShopInfoFrame.btnPay.Visible:=True;
//          end;
//        end;

//        GlobalShopInfoFrame.UpDataMyCar;
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


procedure TFrameAddCarGoods.DoGetUserCarGoodsListExecute(ATimerTask: TObject);
begin
  // 出错
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
                                                      GlobalManager.Longitude,
                                                      GlobalManager.Latitude
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



procedure TFrameAddCarGoods.DoGetUserCarGoodsListExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AParentTreeViewItem:TSkinTreeViewItem;
  AChildTreeViewItem:TSkinTreeViewItem;
  I: Integer;
  J: Integer;
  ASumPrice:Double;
  AHeight:Double;
  l: Integer;
  d: Integer;
  h:Integer;
  AStringList:TStringList;
  ACarGoodList:TCarGoodList;
  AIsHide:Boolean;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取成功

        Self.FCarShopList.Clear(True);
        Self.pnlBankGroud.Visible:=True;
        Self.FCarShopList.ParseFromJsonArray(TCarShop,ASuperObject.O['Data'].A['CartGoodsList']);


        TFrameShopInfo(FGlobalShopInfoFrame).FShopGoodsListFrame.UpDateShopListFrame(FCarShopList);

        Self.tvGoods.Prop.Items.Clear(True);

        ASumPrice:=0;

        Self.tvGoods.Prop.Items.BeginUpdate;
        try
          AStringList:=TStringList.Create;
          AIsHide:=False;
          for I := 0 to Self.FCarShopList.Count-1 do
          begin
            if TFrameShopInfo(FGlobalShopInfoFrame).FShop.fid=Self.FCarShopList[I].fid then
            begin
              AIsHide:=True;
              AParentTreeViewItem:=Self.tvGoods.Prop.Items.Add;
              AParentTreeViewItem.Height:=30;
              AParentTreeViewItem.IsParent:=True;
              AParentTreeViewItem.Data:=Self.FCarShopList[I];
              AParentTreeViewItem.Caption:='已选商品';

              //加载商品列表

              AHeight:=0;

              for J := 0 to Self.FCarShopList[I].FCarGoodList.Count-1 do
              begin

                AHeight:=AHeight+60;
                AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
                AChildTreeViewItem.Data:=Self.FCarShopList[I].FCarGoodList[J];
                AChildTreeViewItem.Caption:=Self.FCarShopList[I].FCarGoodList[J].goods_name;
                AChildTreeViewItem.Icon.Url:=Self.FCarShopList[I].FCarGoodList[J].GetGoodsPic1path;

//                if Self.FCarShopList[I].FCarGoodList[J].shop_goods_attrs<>'' then
//                begin
//                  AChildTreeViewItem.Detail:=Self.FCarShopList[I].FCarGoodList[J].shop_goods_spec_name+'/';
//                end
//                else
//                begin
//                  AChildTreeViewItem.Detail:=Self.FCarShopList[I].FCarGoodList[J].shop_goods_spec_name;
//                end;

                AStringList.CommaText:=Self.FCarShopList[I].FCarGoodList[J].shop_goods_attrs;
                for h := 0 to AStringList.Count-1 do
                begin
                  if h<AStringList.Count-1 then
                  begin
                    AChildTreeViewItem.Detail4:=AChildTreeViewItem.Detail4+AStringList[h]+'/';
                  end
                  else
                  begin
                    AChildTreeViewItem.Detail4:=AChildTreeViewItem.Detail4+AStringList[h];
                  end;
                end;

  //              AChildTreeViewItem.Detail4:=Self.FCarShopList[I].FCarGoodList[J].shop_goods_attrs;
                AChildTreeViewItem.Detail3:=IntToStr(Self.FCarShopList[I].FCarGoodList[J].number);
                if (Self.FCarShopList[I].FCarGoodList[J].special_price<>0) and (Self.FCarShopList[I].FCarGoodList[J].special_price<>Self.FCarShopList[I].FCarGoodList[J].origin_price) then
                begin
                  ASumPrice:=ASumPrice+Self.FCarShopList[I].FCarGoodList[J].special_price*Self.FCarShopList[I].FCarGoodList[J].number;
                  AChildTreeViewItem.Detail1:='￥'+FloatToStr(Self.FCarShopList[I].FCarGoodList[J].special_price);
                  AChildTreeViewItem.Detail2:='￥'+FloatToStr(Self.FCarShopList[I].FCarGoodList[J].origin_price);
                  AChildTreeViewItem.Detail6:=FloatToStr(Self.FCarShopList[I].FCarGoodList[J].special_price);
                end
                else
                begin
                  ASumPrice:=ASumPrice+Self.FCarShopList[I].FCarGoodList[J].origin_price*Self.FCarShopList[I].FCarGoodList[J].number;
                  AChildTreeViewItem.Detail1:='￥'+FloatToStr(Self.FCarShopList[I].FCarGoodList[J].origin_price);
                  AChildTreeViewItem.Detail2:='';
                  AChildTreeViewItem.Detail6:=FloatToStr(Self.FCarShopList[I].FCarGoodList[J].origin_price);
                end;
              end;


              //餐盒费
//              AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
//              AChildTreeViewItem.ItemType:=sitItem1;
//              AChildTreeViewItem.Height:=40;
//              AChildTreeViewItem.Caption:='餐盒';
//              AChildTreeViewItem.Detail:='￥'+FloatToStr(FCarShopList[I].paking_fee);
//              AChildTreeViewItem.Detail6:=FloatToStr(FCarShopList[I].paking_fee);

              ASumPrice:=ASumPrice;//+FCarShopList[I].paking_fee;
//              //合计金额
//              AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
//              AChildTreeViewItem.ItemType:=sitItem1;
//              AChildTreeViewItem.Height:=40;
//              AChildTreeViewItem.Caption:='￥'+FloatToStr(2);
//              AChildTreeViewItem.Data:=Self.FCarShopList[I];
            end;


          end;

        finally
          Self.tvGoods.Prop.Items.EndUpdate();
          FreeAndNil(AStringList);
        end;



        if AIsHide=True then
        begin
          if AHeight<(Self.Height/2) then
          begin
            Self.tvGoods.Height:=AHeight+30;//+40;
          end
          else
          begin
            Self.tvGoods.Height:=Self.Height/2;
          end;

          TFrameShopInfo(FGlobalShopInfoFrame).imgPic.Prop.Picture.ImageIndex:=1;
          TFrameShopInfo(FGlobalShopInfoFrame).lblSelectedPay.Caption:='￥'+Format('%.2f',[ASumPrice]);
          TFrameShopInfo(FGlobalShopInfoFrame).lblSelectedPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.White;

          if TFrameShopInfo(FGlobalShopInfoFrame).FFilterMinOrderAccount>ASumPrice then
          begin
            TFrameShopInfo(FGlobalShopInfoFrame).lblPay.Visible:=True;
            TFrameShopInfo(FGlobalShopInfoFrame).lblPay.Caption:='还差 ￥'+Format('%.2f',[TFrameShopInfo(FGlobalShopInfoFrame).FFilterMinOrderAccount-ASumPrice]);
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
          HideFrame;//(Self,hfcttBeforeReturnFrame,ufsefNone);

          TFrameShopInfo(FGlobalShopInfoFrame).imgPic.Prop.Picture.ImageIndex:=0;

          TFrameShopInfo(FGlobalShopInfoFrame).lblSelectedPay.Caption:='未选购的商品';
          TFrameShopInfo(FGlobalShopInfoFrame).lblSelectedPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Lightgray;
          TFrameShopInfo(FGlobalShopInfoFrame).lblPay.Visible:=True;
          TFrameShopInfo(FGlobalShopInfoFrame).lblPay.Caption:='￥'+FloatToStr(TFrameShopInfo(FGlobalShopInfoFrame).FFilterMinOrderAccount)+'起送';
          TFrameShopInfo(FGlobalShopInfoFrame).btnPay.Visible:=False;

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

  end;
end;



procedure TFrameAddCarGoods.Init;
begin
//  //获取购物车列表
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                       DoGetUserCarGoodsListExecute,
//                       DoGetUserCarGoodsListExecuteEnd);
end;

procedure TFrameAddCarGoods.Load(AShopInfoFrame:TFrame);
var
  AParentTreeViewItem:TSkinTreeViewItem;
  AChildTreeViewItem:TSkinTreeViewItem;
  I: Integer;
  J: Integer;
  ASumPrice:Double;
  AHeight:Double;
  l: Integer;
  d: Integer;
  h:Integer;
  AStringList:TStringList;
  ACarGoodList:TCarGoodList;
  AIsHide:Boolean;
begin
  Self.pnlBankGroud.Visible:=True;
  //加载购物车
  Self.tvGoods.Prop.Items.Clear(True);

  ASumPrice:=0;

  FGlobalShopInfoFrame:=AShopInfoFrame;

  Self.tvGoods.Prop.Items.BeginUpdate;
  try
    AStringList:=TStringList.Create;
    AIsHide:=False;
    for I := 0 to GlobalManager.UserCarShopList.Count-1 do
    begin
      if TFrameShopInfo(FGlobalShopInfoFrame).FShop.fid=GlobalManager.UserCarShopList[I].fid then
      begin
        AIsHide:=True;
        AParentTreeViewItem:=Self.tvGoods.Prop.Items.Add;
        AParentTreeViewItem.Height:=30;
        AParentTreeViewItem.IsParent:=True;
        AParentTreeViewItem.Data:=GlobalManager.UserCarShopList[I];
        AParentTreeViewItem.Caption:='已选商品';

        //加载商品列表

        AHeight:=0;

        for J := 0 to GlobalManager.UserCarShopList[I].FCarGoodList.Count-1 do
        begin

          AHeight:=AHeight+60;
          AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
          AChildTreeViewItem.Data:=GlobalManager.UserCarShopList[I].FCarGoodList[J];
          AChildTreeViewItem.Caption:=GlobalManager.UserCarShopList[I].FCarGoodList[J].goods_name;
          AChildTreeViewItem.Icon.Url:=GlobalManager.UserCarShopList[I].FCarGoodList[J].GetGoodsPic1path;

//          if GlobalManager.UserCarShopList[I].FCarGoodList[J].shop_goods_attrs<>'' then
//          begin
//            AChildTreeViewItem.Detail:=GlobalManager.UserCarShopList[I].FCarGoodList[J].shop_goods_spec_name+'/';
//          end
//          else
//          begin
//            AChildTreeViewItem.Detail:=GlobalManager.UserCarShopList[I].FCarGoodList[J].shop_goods_spec_name;
//          end;

          AStringList.CommaText:=GlobalManager.UserCarShopList[I].FCarGoodList[J].shop_goods_attrs;
          for h := 0 to AStringList.Count-1 do
          begin
            if h<AStringList.Count-1 then
            begin
              AChildTreeViewItem.Detail4:=AChildTreeViewItem.Detail4+AStringList[h]+'/';
            end
            else
            begin
              AChildTreeViewItem.Detail4:=AChildTreeViewItem.Detail4+AStringList[h];
            end;
          end;

//              AChildTreeViewItem.Detail4:=Self.FCarShopList[I].FCarGoodList[J].shop_goods_attrs;
          AChildTreeViewItem.Detail3:=IntToStr(GlobalManager.UserCarShopList[I].FCarGoodList[J].number);
          if (GlobalManager.UserCarShopList[I].FCarGoodList[J].special_price<>0) and (GlobalManager.UserCarShopList[I].FCarGoodList[J].special_price<>GlobalManager.UserCarShopList[I].FCarGoodList[J].origin_price) then
          begin
            ASumPrice:=ASumPrice+GlobalManager.UserCarShopList[I].FCarGoodList[J].special_price*GlobalManager.UserCarShopList[I].FCarGoodList[J].number;
            AChildTreeViewItem.Detail1:='￥'+FloatToStr(GlobalManager.UserCarShopList[I].FCarGoodList[J].special_price);
            AChildTreeViewItem.Detail2:='￥'+FloatToStr(GlobalManager.UserCarShopList[I].FCarGoodList[J].origin_price);
            AChildTreeViewItem.Detail6:=FloatToStr(GlobalManager.UserCarShopList[I].FCarGoodList[J].special_price);
          end
          else
          begin
            ASumPrice:=ASumPrice+GlobalManager.UserCarShopList[I].FCarGoodList[J].origin_price*GlobalManager.UserCarShopList[I].FCarGoodList[J].number;
            AChildTreeViewItem.Detail1:='￥'+FloatToStr(GlobalManager.UserCarShopList[I].FCarGoodList[J].origin_price);
            AChildTreeViewItem.Detail2:='';
            AChildTreeViewItem.Detail6:=FloatToStr(GlobalManager.UserCarShopList[I].FCarGoodList[J].origin_price);
          end;
        end;


        //餐盒费
//        AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
//        AChildTreeViewItem.ItemType:=sitItem1;
//        AChildTreeViewItem.Height:=40;
//        AChildTreeViewItem.Caption:='餐盒';
//        AChildTreeViewItem.Detail:='￥'+FloatToStr(GlobalManager.UserCarShopList[I].paking_fee);
//        AChildTreeViewItem.Detail6:=FloatToStr(GlobalManager.UserCarShopList[I].paking_fee);

        ASumPrice:=ASumPrice;//+GlobalManager.UserCarShopList[I].paking_fee;
//              //合计金额
//              AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
//              AChildTreeViewItem.ItemType:=sitItem1;
//              AChildTreeViewItem.Height:=40;
//              AChildTreeViewItem.Caption:='￥'+FloatToStr(2);
//              AChildTreeViewItem.Data:=Self.FCarShopList[I];


      end;


    end;

  finally
    Self.tvGoods.Prop.Items.EndUpdate();
    FreeAndNil(AStringList);
  end;

  if AIsHide=True then
  begin
    if AHeight<(Self.Height/2) then
    begin
      Self.tvGoods.Height:=AHeight+30;//+40;
    end
    else
    begin
      Self.tvGoods.Height:=Self.Height/2;
    end;
  end
  else
  begin
    HideFrame;//(Self,hfcttBeforeReturnFrame,ufsefNone);
  end;

end;

procedure TFrameAddCarGoods.pnlBankGroudClick(Sender: TObject);
begin
  TFrameShopInfo(FGlobalShopInfoFrame).FAddUserCarFrameIsShow:=False;

//  GlobalShopInfoFrame.UpDataMyCar;
  //按空白区域则返回上一页
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

  HideFrame;//(Self,hfcttBeforeReturnFrame,ufsefNone);
//  ReturnFrame(Self);
end;

end.

