unit ShopAddUserCarFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinMaterial,
  uOpenClientCommon,
  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,
  uFrameContext,
  ShopGoodsListFrame,
  ShopUserInfoFrame,

  uUIFunction,

  WaitingFrame,
  uTimerTask,

  uManager,

  uOpenCommon,
  XSuperObject,
  uRestInterfaceCall,

  MessageBoxFrame,

  uSkinItems,


  uSkinFireMonkeyControl, uSkinPanelType, uSkinFireMonkeyPanel, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinImageType, uSkinFireMonkeyImage, uSkinButtonType,
  uSkinFireMonkeyButton, uSkinListBoxType, uSkinFireMonkeyListBox,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType, uSkinFireMonkeyListView, uSkinTreeViewType,
  uSkinFireMonkeyTreeView, uSkinMultiColorLabelType,
  uSkinFireMonkeyMultiColorLabel, uDrawCanvas;

type
  TFrameShopAddUserCar = class(TFrame)
    pnlBankGroud: TSkinFMXPanel;
    pnlGoods: TSkinFMXPanel;
    lvCategory: TSkinFMXListView;
    idpCategory: TSkinFMXItemDesignerPanel;
    lblCategory: TSkinFMXLabel;
    pnlAGood: TSkinFMXPanel;
    imgGood: TSkinFMXImage;
    lblName: TSkinFMXLabel;
    lblSpesc: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
    lblSpecial: TSkinFMXLabel;
    lblOrigi: TSkinFMXLabel;
    btnSelect: TSkinFMXButton;
    btnHide: TSkinFMXButton;
    lvAttr: TSkinFMXListView;
    idpAddr: TSkinFMXItemDesignerPanel;
    lblParent: TSkinFMXLabel;
    mclGoodsSpec: TSkinFMXMultiColorLabel;
    procedure lvCategoryClickItem(AItem: TSkinItem);
    procedure btnSelectClick(Sender: TObject);
    procedure btnHideClick(Sender: TObject);
    procedure lvAttrClickItem(AItem: TSkinItem);
  private
    //购物车商品
    FUserCarGoods:TCarGood;
    //店铺ID
    FFilterShopFID:Integer;
    //商品ID
    FFilterShopGoodsFID:Integer;

    FFilterOrderno:Double;

    FShopGoodsListFrame:TFrameShopGoodsList;

    //总价格
    FFilterSumPrice:Double;

    //添加购物车
    procedure DoAddUserCerExecute(ATimerTask:TObject);
    procedure DoAddUserCerExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    //商品规格
    FFilterSpecFID:Integer;
    //商品属性
    FFilterAttrValue:TStringList;



    //添加商品的数量
    FFilterCount:Integer;
    //添加商品的价格
    FFilterPrice:Double;
    //添加商品打包费
    FFilterPackFee:Double;
    //起送价
    FFilterMinOrderPrice:Double;
    //分辨
    FIntCount:Integer;
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure Clear;
    procedure Init(ACcount:Integer;AInt:Integer;AFilterMinOrderPrice:Double;AGoods:TShopGoods);
    { Public declarations }
  end;

var
  GlobalShopAddUserCarFrame:TFrameShopAddUserCar;


implementation

{$R *.fmx}
uses
  MAinForm,MainFrame,
  ShopInfoFrame;

{ TFrameShopAddUserCar }

procedure TFrameShopAddUserCar.btnHideClick(Sender: TObject);
begin
  HideFrame;//(Self,hfcttBeforeShowFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameShopAddUserCar.btnSelectClick(Sender: TObject);
var
  I: Integer;
begin
  Self.FFilterCount:=FFilterCount+1;

  FFilterAttrValue.Clear;

  for I := 0 to Self.lvAttr.Prop.Items.Count-1 do
  begin
    if Self.lvAttr.Prop.Items[I].Selected=True then
    begin
      Self.FFilterAttrValue.Add(Self.lvAttr.Prop.Items[I].Caption);
    end;
  end;

//  Self.FUserCarGoods.shop_goods_attrs:=FFilterAttrValue.CommaText;
//
//  Self.FUserCarGoods.shop_goods_spec_name:=Self.mclGoodsSpec.Prop.Items[0].Text;

  GlobalMainFrame.AddGoodsToUserCart(Self.FFilterShopFID,
                                     Self.FFilterShopGoodsFID,
                                     Self.FFilterSpecFID,
                                     1,
                                     Self.FFilterAttrValue.CommaText,
                                     Self.FFilterOrderno);


  //返回
  HideFrame;//(Self,hfcttBeforeShowFrame);
  ReturnFrame;//(Self.FrameHistroy);

end;

procedure TFrameShopAddUserCar.Clear;
begin
  Self.imgGood.Prop.Picture.Clear;

  Self.lblName.Caption:='';
//  Self.lblSpesc.Caption:='';
  Self.lblSpecial.Caption:='';
  Self.lblOrigi.Caption:='';

  Self.lvCategory.Prop.Items.Clear(True);

  Self.lvAttr.Prop.Items.Clear(True);

  Self.FFilterCount:=0;

  FFilterAttrValue.Clear;
end;

constructor TFrameShopAddUserCar.Create(AOwner: TComponent);
begin
  inherited;
  FUserCarGoods:=TCarGood.Create;
  FFilterAttrValue:=TStringList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  Self.btnSelect.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=SkinThemeColor;
  Self.lblCategory.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.PushedEffect.FillColor.Color:=SkinThemeColor;
end;

destructor TFrameShopAddUserCar.Destroy;
begin
  FreeAndNil(FUserCarGoods);
  FreeAndNil(FFilterAttrValue);
  inherited;
end;

procedure TFrameShopAddUserCar.DoAddUserCerExecute(ATimerTask: TObject);
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
                                                      Self.FFilterShopGoodsFID,
                                                      Self.FFilterSpecFID,
                                                      1,
                                                      Self.FFilterOrderno,
                                                      Self.FFilterAttrValue.CommaText
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

procedure TFrameShopAddUserCar.DoAddUserCerExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ASumPrice:Double;
  ACarGood:TCarGood;
begin
  ASumPrice:=0;

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //添加成功
//        try
//          ACarGood:=TCarGood.Create;
//
//          ACarGood.ParseFromJson(ASuperObject.O['Data'].A['ShopGoodsInCart'].O[0]);

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


         if FIntCount=1 then
        begin
          HideFrame;//(Self,hfcttBeforeShowFrame);
          ReturnFrame;//(Self.FrameHistroy);
        end;

        if FIntCount=0 then
        begin
          HideFrame;//(Self,hfcttBeforeShowFrame);

          ASumPrice:=Self.FFilterCount*Self.FFilterPrice+FFilterCount*FFilterPackFee;

          GlobalShopInfoFrame.nniUserCartNumber.Prop.Number:=
                      GlobalShopInfoFrame.nniUserCartNumber.Prop.Number+1;


          if Self.FFilterCount>0 then
          begin

            GlobalShopInfoFrame.imgPic.Prop.Picture.ImageIndex:=1;
            //添加成功
            GlobalShopInfoFrame.lblSelectedPay.Caption:='￥'+Format('%.2f',[ASumPrice]);
            GlobalShopInfoFrame.lblSelectedPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.White;
            if FFilterMinOrderPrice<=ASumPrice then
            begin
              GlobalShopInfoFrame.lblPay.Visible:=False;
              GlobalShopInfoFrame.btnPay.Visible:=True;
            end
            else
            begin
              GlobalShopInfoFrame.lblPay.Visible:=True;
              GlobalShopInfoFrame.lblPay.Caption:='还差 ￥'+Format('%.2f',[FFilterMinOrderPrice-ASumPrice]);
              GlobalShopInfoFrame.btnPay.Visible:=False;
            end;

            GlobalShopInfoFrame.FShopGoodsListFrame.tvShopGoodsList.Prop.Items.FindItemByName(IntToStr(Self.FFilterShopGoodsFID)).Detail2:=IntToStr(FFilterCount);

          end
          else
          begin
            GlobalShopInfoFrame.lblSelectedPay.Caption:='未选购的商品';
            GlobalShopInfoFrame.lblSelectedPay.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.Lightgray;
            GlobalShopInfoFrame.lblPay.Visible:=True;
            GlobalShopInfoFrame.lblPay.Caption:='￥'+Format('%.2f',[FFilterMinOrderPrice])+'起送';
            GlobalShopInfoFrame.btnPay.Visible:=False;

            GlobalShopInfoFrame.FShopGoodsListFrame.tvShopGoodsList.Prop.Items.FindItemByName(IntToStr(Self.FFilterShopGoodsFID)).Detail2:='';

          end;
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

procedure TFrameShopAddUserCar.Init(ACcount,AInt:Integer;AFilterMinOrderPrice:Double;AGoods: TShopGoods);
var
  AListBoxItem:TSkinListBoxItem;
  AListViewItem:TSkinListViewItem;
  I:Integer;
  J:Integer;
  AMinOriginPrice:Double;
  AMinSpecialPrice:Double;
  ASelectedFID:Integer;
  AStringList:TStringList;
  K: Integer;
  APackingFee:Double;
begin

  FFilterMinOrderPrice:=AFilterMinOrderPrice;
  Self.FFilterCount:=ACcount;
//  Self.FFilterPrice:=0;


//  FUserCarGoods.orderno:=AGoods.orderno;
//  FUserCarGoods.shop_goods_fid:=AGoods.fid;

  Self.FIntCount:=AInt;

  FFilterOrderno:=AGoods.orderno;

  Self.FFilterShopFID:=AGoods.shop_fid;
  Self.FFilterShopGoodsFID:=AGoods.fid;

  Self.imgGood.Prop.Picture.Url:=AGoods.GetPic1Url;

  Self.lblName.Caption:=AGoods.name;


  Self.lvCategory.Position.Y:=Self.pnlAGood.Position.Y+Self.pnlAGood.Height;


  Self.lvCategory.Prop.Items.BeginUpdate;
  try
    AMinOriginPrice:=0;
    AMinSpecialPrice:=0;
    ASelectedFID:=0;
    APackingFee:=0;

    AMinOriginPrice:=AGoods.GoodsSpecList[0].price;

    if AGoods.GoodsSpecList.Count<>0 then
    begin
      AListViewItem:=Self.lvCategory.Prop.Items.Add;
      AListViewItem.ItemType:=sitItem1;
      AListViewItem.Height:=20;
      AListViewItem.Width:=-2;
      AListViewItem.Caption:='规格';
    end;

    for I := 0 to AGoods.GoodsSpecList.Count-1 do
    begin

      if AGoods.GoodsSpecList[I].is_offsell=0 then
      begin
        AListViewItem:=Self.lvCategory.Prop.Items.Add;
        AListViewItem.Data:=AGoods.GoodsSpecList[I];
        AListViewItem.Caption:=AGoods.GoodsSpecList[I].name;
        AListViewItem.Detail6:=IntToStr(AGoods.GoodsSpecList[I].fid);


        if AMinOriginPrice>=AGoods.GoodsSpecList[I].price then
        begin
          ASelectedFID:=AGoods.GoodsSpecList[I].fid;
          AMinOriginPrice:=AGoods.GoodsSpecList[I].price;
          AMinSpecialPrice:=AGoods.GoodsSpecList[I].special_price;
          Self.FFilterSpecFID:=AGoods.GoodsSpecList[I].fid;

          APackingFee:=AGoods.GoodsSpecList[I].packing_fee;
        end;



        Self.mclGoodsSpec.Prop.Items[0].Text:=Self.lvCategory.Prop.Items.FindItemByDetail6(IntToStr(ASelectedFID)).Caption;

        Self.lvCategory.Prop.Items.FindItemByDetail6(IntToStr(ASelectedFID)).Selected:=True;

        FFilterPackFee:=APackingFee;

        if AMinSpecialPrice<>0 then
        begin
          Self.lblOrigi.Caption:='￥'+Format('%.2f',[AMinOriginPrice]);
          Self.lblSpecial.Caption:='￥'+Format('%.2f',[AMinSpecialPrice]);
          FFilterPrice:=AMinSpecialPrice;
        end
        else
        begin
          Self.lblOrigi.Caption:='';
          Self.lblSpecial.Caption:='￥'+Format('%.2f',[AMinOriginPrice]);
          FFilterPrice:=AMinOriginPrice;
        end;


      end;

    end;

  finally
    Self.lvCategory.Prop.Items.EndUpdate();
  end;

  Self.lvCategory.Height:=Self.lvCategory.Prop.GetContentHeight;

  //加载属性
  Self.lvAttr.Prop.Items.Clear(True);
  Self.lvAttr.Position.Y:=Self.lvCategory.Position.Y+Self.lvCategory.Height;
  Self.lvAttr.Prop.Items.BeginUpdate;

  try
    AStringList:=TStringList.Create;
    for J := 0 to AGoods.GoodsAttrList.Count-1 do
    begin
      AStringList.Clear;
      AListViewItem:=Self.lvAttr.Prop.Items.Add;
      AListViewItem.ItemType:=sitItem1;
      AListViewItem.Height:=20;
      AListViewItem.Width:=-2;
      AListViewItem.Caption:=AGoods.GoodsAttrList[J].name;
      AStringList.CommaText:=AGoods.GoodsAttrList[J].value_list;
      for K := 0 to AStringList.Count-1 do
      begin
       AListViewItem:=Self.lvAttr.Prop.Items.Add;
       AListViewItem.Caption:=AStringList[K];
       AListViewItem.Detail6:=IntToStr(AGoods.GoodsAttrList[J].fid);
        if K=0 then
        begin
          //默认选中第一个
          AListViewItem.Selected:=True;
          Self.FFilterAttrValue.Add(AStringList[K]);

        end;
      end;

    end;

    Self.mclGoodsSpec.Prop.Items[1].Text:='/'+FFilterAttrValue.CommaText;

//    Self.lblSpesc.Caption:=Self.lvCategory.Prop.Items.FindItemByDetail6(IntToStr(ASelectedFID)).Caption+'('+FFilterAttrValue.CommaText+')';


  finally
    FreeAndNil(AStringList);

    Self.lvAttr.Prop.Items.EndUpdate();
  end;

  Self.lvAttr.Height:=Self.lvAttr.Prop.GetContentHeight;

  Self.pnlGoods.Height:=Self.btnSelect.Position.Y+Self.btnSelect.Height+15;

end;


procedure TFrameShopAddUserCar.lvAttrClickItem(AItem: TSkinItem);
var
  I: Integer;
  J: Integer;
begin
  if AItem.ItemType=sitDefault then
  begin
    AItem.Selected:=True;

    Self.FFilterAttrValue.Clear;

    for I := 0 to Self.lvAttr.Prop.Items.Count-1 do
    begin
      if (AItem.Caption<>Self.lvAttr.Prop.Items[I].Caption) and (AItem.Detail6=Self.lvAttr.Prop.Items[I].Detail6) then
      begin
        Self.lvAttr.Prop.Items[I].Selected:=False;
      end;
    end;

    for J := 0 to Self.lvAttr.Prop.Items.Count-1 do
    begin
      if Self.lvAttr.Prop.Items[J].Selected=True then
      begin
        Self.FFilterAttrValue.Add(Self.lvAttr.Prop.Items[J].Caption);
      end;
    end;

    Self.mclGoodsSpec.Prop.Items[1].Text:='/'+FFilterAttrValue.CommaText;
  end;


end;

procedure TFrameShopAddUserCar.lvCategoryClickItem(AItem: TSkinItem);
var
  AShopGoodsSpec:TShopGoodsSpec;
begin
  if AItem.ItemType=sitDefault then
  begin
    AShopGoodsSpec:=TShopGoodsSpec(AItem.Data);
    Self.FFilterSpecFID:=AShopGoodsSpec.fid;
    Self.mclGoodsSpec.Prop.Items[0].Text:=AShopGoodsSpec.name;

    if AShopGoodsSpec.special_price<>0 then
    begin
      Self.lblSpecial.Caption:='￥'+Format('%.2f',[AShopGoodsSpec.special_price]);
      Self.lblOrigi.Caption:='￥'+Format('%.2f',[AShopGoodsSpec.origin_price]);
      FFilterPrice:=AShopGoodsSpec.special_price;
    end
    else
    begin
      Self.lblSpecial.Caption:='￥'+Format('%.2f',[AShopGoodsSpec.price]);
      Self.lblOrigi.Caption:='';
      FFilterPrice:=AShopGoodsSpec.price;
    end;

    FFilterPackFee:=AShopGoodsSpec.packing_fee;
  end;

end;

end.
