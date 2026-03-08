unit ShopGoodsInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uOpenClientCommon,
  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,
  uFrameContext,
  ShopGoodsListFrame,
  ShopUserInfoFrame,
  uOpenCommon,

  uUIFunction,

  WaitingFrame,
  uTimerTask,

  uManager,

  XSuperObject,
  uRestInterfaceCall,

  MessageBoxFrame,

  uSkinItems,

  HintFrame,


  uSkinImageType, uSkinFireMonkeyImage, uSkinScrollBoxContentType,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyControl,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinFireMonkeyScrollBox,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinPanelType, uSkinFireMonkeyPanel,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinFireMonkeyListBox,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinListViewType, uSkinFireMonkeyListView, uSkinAnimator,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, FMX.Objects,
  uDrawPicture, uSkinImageList, uSkinImageListViewerType,
  uSkinFireMonkeyImageListViewer, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyMemo,
  FMX.Memo.Types;

type
  TFrameShopGoodsInfo = class(TFrame)
    sbBottom: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    imgGoodsPic: TSkinFMXImage;
    pnlMoney: TSkinFMXPanel;
    lblMoney: TSkinFMXLabel;
    btnAdd: TSkinFMXButton;
    pnlName: TSkinFMXPanel;
    lblGoodsName: TSkinFMXLabel;
    lblMonthSale: TSkinFMXLabel;
    pnlScore: TSkinFMXPanel;
    btnScore: TSkinFMXButton;
    btnHide: TSkinFMXButton;
    pnlBankGroud: TSkinFMXPanel;
    lblOrigi: TSkinFMXLabel;
    edtCount: TSkinFMXEdit;
    btnDesc: TSkinFMXButton;
    lblRate: TSkinFMXLabel;
    imglistAdd: TSkinImageList;
    imgListView: TSkinFMXImageListViewer;
    imgListGoodsPic: TSkinImageList;
    bgIndicator: TSkinFMXButtonGroup;
    MemoGoodsDesc: TSkinFMXMemo;
    procedure btnHideClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDescClick(Sender: TObject);
    procedure sbBottomResize(Sender: TObject);
    procedure pnlBankGroudClick(Sender: TObject);
    procedure btnScoreClick(Sender: TObject);
    procedure imgListViewResize(Sender: TObject);
  private
    //购物车商品
    FUserCarGoods:TUserCartGoods;
    //店铺FID
    FFilterShopFID:Integer;
    //商品FID
    FGoodsFID:Integer;
    //热度
    FFilterOrderno:Double;
    //起送价
    FFilterMin:Double;
    //商品
    FGoods:TShopGoods;
    procedure DoGetShopGoodsInfoExecute(ATimerTask:TObject);
    procedure DoGetShopGoodsInfoExecuteEnd(ATimerTask:TObject);
  private
    //添加购物车
    procedure DoAddUserCerExecute(ATimerTask:TObject);
    procedure DoAddUserCerExecuteEnd(ATimerTask:TObject);

    //删除购物车商品
    procedure DoDelCarShopGoodExecute(ATimerTask:TObject);
    procedure DoDelCarShopGoodExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    //商品规格
    FFilterSpecFID:Integer;
    //商品属性
    FFilterAttrValue:String;

    //打包费
    FFilterPackFee:Double;

    //添加商品的数量
    FFilterCount:Integer;
    //添加商品的价格
    FFilterPrice:Double;

    //购物车商品FID
    FFilterCarGoodFID:Integer;

    //是否增加
    FIsAdd:String;

    //清空
    procedure Clear;
    procedure Init(ACcount:String;
                   AFilterCarGoodFID:Integer;
                   AFilterMin:Double;
                   AShopGoods:TShopGoods;
                   AIsDoBusiness:Boolean;
                   AIsTakeOrder:Boolean);

  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalShopGoodsInfoFrame:TFrameShopGoodsInfo;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame,
  ShopAddUserCarFrame,
  ShopInfoFrame,
  ShopGoodsEvalvateListFrame,
  LoginFrame;

{ TFrameShopGoodsInfo }


procedure TFrameShopGoodsInfo.btnAddClick(Sender: TObject);
begin

  if GlobalManager.IsLogin=True then
  begin
    if Self.FGoods.GoodsSpecList.Count>0 then
    begin
      if (Self.FGoods.GoodsSpecList.Count=1) and (Self.FGoods.GoodsAttrList.Count=0) then
      begin
        FFilterCount:=FFilterCount+1;


        Self.FFilterSpecFID:=Self.FGoods.GoodsSpecList[0].fid;
        Self.FFilterAttrValue:='';
        //添加购物车

        GlobalMainFrame.AddGoodsToUserCart(Self.FFilterShopFID,
                                           Self.FGoodsFID,
                                           Self.FFilterSpecFID,
                                           1,
                                           Self.FFilterAttrValue,
                                           Self.FFilterOrderno
                                           );

        if Self.FGoods.GoodsSpecList[0].is_offsell=0 then
        begin
          Self.edtCount.Text:=IntToStr(Self.FFilterCount);
          Self.edtCount.Visible:=True;
          Self.btnDesc.Visible:=True;
        end
        else
        begin
          Self.edtCount.Text:='';
          Self.edtCount.Visible:=False;
          Self.btnDesc.Visible:=False;
        end;

//        ShowWaitingFrame(Self,'添加中...');
//        uTimerTask.GetGlobalTimerThread.RunTempTask(
//                    DoAddUserCerExecute,
//                    DoAddUserCerExecuteEnd);

      end
      else
      begin
        //先反回
        HideFrame;//(Self,hfcttBeforeShowFrame);
        ReturnFrame;//(Self.FrameHistroy);
        //再显示
        HideFrame;//(Self,hfcttBeforeShowFrame);
        ShowFrame(TFrame(GlobalShopAddUserCarFrame),TFrameShopAddUserCar,frmMain,nil,nil,nil,Application,True,False,ufsefNone);
        GlobalShopAddUserCarFrame.Clear;
        GlobalShopAddUserCarFrame.Init(Self.FFilterCount,0,Self.FFilterOrderno,FGoods);
      end;
    end;

  end
  else
  begin
    //登录
    //隐藏
    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
    //显示登录页面
    ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
//    GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
    //清除输入框
    GlobalLoginFrame.Clear;
  end;


end;

procedure TFrameShopGoodsInfo.btnDescClick(Sender: TObject);
var
  AIsMoreSpec:Integer;
  I:Integer;
begin

  AIsMoreSpec:=0;

  for I := 0 to GlobalManager.UserCarShopList.FindItemByFID(FGoods.shop_fid).FCarGoodList.Count-1 do
  begin
    if FGoods.fid=GlobalManager.UserCarShopList.FindItemByFID(FGoods.shop_fid).FCarGoodList[I].shop_goods_fid then
    begin

      AIsMoreSpec:=AIsMoreSpec+1;

    end;

  end;

  if Self.FGoods.GoodsSpecList.Count>0 then
  begin
    if AIsMoreSpec<=1 then
    begin
      Self.FFilterCount:=Self.FFilterCount-1;

      if Self.FFilterCarGoodFID=0 then
      begin
        for I := 0 to GlobalManager.UserCarShopList.FindItemByFID(FGoods.shop_fid).FCarGoodList.Count-1 do
        begin
          if FGoods.fid=GlobalManager.UserCarShopList.FindItemByFID(FGoods.shop_fid).FCarGoodList[I].shop_goods_fid then
          begin

            FFilterCarGoodFID:=GlobalManager.UserCarShopList.FindItemByFID(FGoods.shop_fid).FCarGoodList[I].fid;

          end;

        end;
      end;

      GlobalMainFrame.UpdateCartGoodsNumber(Self.FFilterCarGoodFID,Self.FFilterCount);



      Self.edtCount.Text:=IntToStr(Self.FFilterCount);

      if (Self.FFilterCount=0) then
      begin
        Self.edtCount.Visible:=False;
        Self.btnDesc.Visible:=False;
      end;

//      //删除购物车商品
//      ShowWaitingFrame(Self,'删除中...');
//      uTimerTask.GetGlobalTimerThread.RunTempTask(
//                  DoDelCarShopGoodExecute,
//                  DoDelCarShopGoodExecuteEnd);
    end
    else
    begin
      ShowHintFrame(Self,'多规格只能去购物车中删除');
    end;
  end;



end;

procedure TFrameShopGoodsInfo.btnHideClick(Sender: TObject);
begin
  HideFrame;//(Self,hfcttBeforeShowFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameShopGoodsInfo.btnScoreClick(Sender: TObject);
begin
  //商品评价页面
  //评价列表页面
  //隐藏
  HideFrame;//(Self);//GlobalMainFrame);
  //显示交易列表
  ShowFrame(TFrame(GlobalShopGoodsEvalvateListFrame),TFrameShopGoodsEvalvateList,frmMain,nil,nil,nil,Application);
//  GlobalShopGoodsEvalvateListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalShopGoodsEvalvateListFrame.Load(FGoods.fid,FGoods.shop_fid,'','','');
end;

procedure TFrameShopGoodsInfo.Clear;
begin
  //这个现在不用了
  Self.imgGoodsPic.Prop.Picture.Clear;

  Self.imgListGoodsPic.PictureList.Clear(True);

  Self.lblGoodsName.Caption:='';
  Self.lblMonthSale.Caption:='';

  Self.lblOrigi.Caption:='';

  FFilterPackFee:=0;

//  Self.lvCategory.Prop.Items.Clear(True);

  Self.lblMoney.Caption:='';

  Self.btnAdd.Prop.Icon.ImageIndex:=0;

  Self.FFilterCarGoodFID:=0;
end;

constructor TFrameShopGoodsInfo.Create(AOwner: TComponent);
begin
  inherited;
  FUserCarGoods:=TUserCartGoods.Create;
  FGoods:=TShopGoods.Create;



  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameShopGoodsInfo.Destroy;
begin
  FreeAndNil(FUserCarGoods);
  FreeAndNil(FGoods);
  inherited;
end;

procedure TFrameShopGoodsInfo.DoAddUserCerExecute(ATimerTask: TObject);
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
                                                      Self.FGoods.shop_fid,
                                                      GlobalManager.User.key,
                                                      Self.FGoods.fid,
                                                      Self.FGoods.GoodsSpecList[0].fid,
                                                      1,
                                                      Self.FGoods.orderno,
                                                      ''
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


procedure TFrameShopGoodsInfo.DoAddUserCerExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ACarGood:TCarGood;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        FIsAdd:='Add';
        Self.edtCount.Text:=IntToStr(Self.FFilterCount);


        GlobalShopInfoFrame.nniUserCartNumber.Prop.Number:=
                          GlobalShopInfoFrame.nniUserCartNumber.Prop.Number+1;

        if GlobalShopInfoFrame.FShopGoodsListFrame<>nil then
        begin
          GlobalShopInfoFrame.FShopGoodsListFrame.AddCar(True,FFilterPrice+FFilterPackFee);
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


procedure TFrameShopGoodsInfo.DoDelCarShopGoodExecute(ATimerTask: TObject);
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
                                                      FFilterCarGoodFID,
                                                      FFilterCount,
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


procedure TFrameShopGoodsInfo.DoDelCarShopGoodExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  ASumPrice:Double;
  I:Integer;
begin
  ASumPrice:=0;

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //删除成功
        FIsAdd:='Desc';
        if Self.FFilterCount>0 then
        begin
          Self.edtCount.Text:=IntToStr(Self.FFilterCount);
        end
        else
        begin
          Self.btnDesc.Visible:=False;
          Self.edtCount.Visible:=False;
        end;

        GlobalShopInfoFrame.nniUserCartNumber.Prop.Number:=
                          GlobalShopInfoFrame.nniUserCartNumber.Prop.Number-1;

        if GlobalShopInfoFrame.FShopGoodsListFrame<>nil then
        begin
          GlobalShopInfoFrame.FShopGoodsListFrame.AddCar(False,FFilterPrice+FFilterPackFee);
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

procedure TFrameShopGoodsInfo.DoGetShopGoodsInfoExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_goods_info',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'shop_fid',
                                                      'shop_goods_fid',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      Self.FFilterShopFID,
                                                      Self.FGoodsFID,
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

procedure TFrameShopGoodsInfo.DoGetShopGoodsInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AListViewItem:TSkinListViewItem;
  J: Integer;
  AListBoxItem:TSkinListBoxItem;
  AMinPrice:Double;
  AminSpicel:Double;
  ADrawPicture:TDrawPicture;
begin
  AMinPrice:=0;
  AminSpicel:=0;
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取成功
        FGoods.ParseFromJson(ASuperObject.O['Data'].A['Goods'].O[0]);

        Self.imgListGoodsPic.PictureList.Clear(True);
        //商品图片
        if Self.FGoods.pic1_path<>'' then
        begin
          ADrawPicture:=Self.imgListGoodsPic.PictureList.Add;
          ADrawPicture.Url:=Self.FGoods.GetPic1Url;
          //立即下载
          ADrawPicture.WebUrlPicture;
        end;

        if Self.FGoods.pic2_path<>'' then
        begin
          ADrawPicture:=Self.imgListGoodsPic.PictureList.Add;
          ADrawPicture.Url:=Self.FGoods.GetPic2Url;
          //立即下载
          ADrawPicture.WebUrlPicture;
        end;

        if Self.FGoods.pic3_path<>'' then
        begin
          ADrawPicture:=Self.imgListGoodsPic.PictureList.Add;
          ADrawPicture.Url:=Self.FGoods.GetPic3Url;
          //立即下载
          ADrawPicture.WebUrlPicture;
        end;

        //显示第一页
        Self.imgListView.Prop.Picture.ImageIndex:=-1;
        if Self.imgListGoodsPic.PictureList.Count>0 then
        begin
          Self.imgListView.Prop.Picture.ImageIndex:=0;
        end;
        //排列按钮分组的位置
        Self.imgListViewResize(imgListView);

        Self.MemoGoodsDesc.Text:=Self.FGoods.goods_desc;
//        Self.lblGoodsDesc.Text:=Self.FGoods.goods_desc;

//        Self.imgGoodsPic.Prop.Picture.Url:=Self.FGoods.GetPic1Url;
        Self.lblGoodsName.Caption:=Self.FGoods.name;
        Self.lblMonthSale.Caption:='月售'+IntToStr(Self.FGoods.month_sales);

        Self.lblRate.Caption:='好评率为'+FloatToStr(Self.FGoods.satisfy_rate*100)+'%';

        if Self.FGoods.GoodsSpecList.Count>0 then
        begin
          if Self.FGoods.GoodsSpecList[0].special_price<>0 then
          begin
            AminSpicel:=Self.FGoods.GoodsSpecList[0].special_price;
            AMinPrice:=Self.FGoods.GoodsSpecList[0].price;
          end
          else
          begin
            AminSpicel:=Self.FGoods.GoodsSpecList[0].price;
            AMinPrice:=0;
          end;

          Self.FFilterPackFee:=Self.FGoods.GoodsSpecList[0].packing_fee;
        end;

        for I := 0 to Self.FGoods.GoodsSpecList.Count-1 do
        begin
          if Self.FGoods.GoodsSpecList[I].special_price<>0 then
          begin
            if AminSpicel>=Self.FGoods.GoodsSpecList[I].special_price then
            begin
              AminSpicel:=Self.FGoods.GoodsSpecList[I].special_price;
              AMinPrice:=Self.FGoods.GoodsSpecList[I].price;
            end;
          end
          else
          begin
            if AminSpicel>=Self.FGoods.GoodsSpecList[I].price then
            begin
              AminSpicel:=Self.FGoods.GoodsSpecList[I].price;
              AMinPrice:=0;
            end;
          end;
        end;

        if AMinPrice<>0 then
        begin
          Self.lblOrigi.Caption:='￥'+Format('%.2f',[AMinPrice]);
          Self.lblMoney.Caption:='￥'+Format('%.2f',[AminSpicel]);

        end
        else
        begin
          Self.lblOrigi.Caption:='';
          Self.lblMoney.Caption:='￥'+Format('%.2f',[AminSpicel]);

        end;

        Self.FFilterPrice:=AminSpicel;

        Self.FFilterPrice:=AminSpicel;

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


procedure TFrameShopGoodsInfo.imgListViewResize(Sender: TObject);
begin
  Self.bgIndicator.Position.X:=Self.imgListView.Width-Self.bgIndicator.Width-20;
end;

procedure TFrameShopGoodsInfo.Init(ACcount:String;
                                   AFilterCarGoodFID:Integer;
                                   AFilterMin:Double;
                                   AShopGoods:TShopGoods;
                                   AIsDoBusiness:Boolean;
                                   AIsTakeOrder:Boolean);
begin

  FIsAdd:='';

  Self.FFilterShopFID:=AShopGoods.shop_fid;
  Self.FGoodsFID:=AShopGoods.fid;

  Self.FFilterOrderno:=AShopGoods.orderno;

  FFilterCarGoodFID:=AFilterCarGoodFID;

  if AIsDoBusiness=True then
  begin
    if AIsTakeOrder=False then
    begin
      Self.btnAdd.Prop.Icon.ImageIndex:=1;

      Self.btnDesc.Visible:=False;
      Self.edtCount.Visible:=False;

      Self.btnAdd.Enabled:=False;
    end
    else
    begin
      Self.btnAdd.Prop.Icon.ImageIndex:=0;
      Self.btnAdd.Enabled:=True;
      if ACcount<>'' then
      begin
        FFilterCount:=StrToInt(ACcount);
        Self.btnDesc.Visible:=True;
        Self.edtCount.Visible:=True;
        Self.edtCount.Text:=ACcount;
      end
      else
      begin
        FFilterCount:=0;
        Self.btnDesc.Visible:=False;
        Self.edtCount.Visible:=False;
      end;
    end;
  end
  else
  begin
    Self.btnAdd.Prop.Icon.ImageIndex:=1;

    Self.btnDesc.Visible:=False;
    Self.edtCount.Visible:=False;

    Self.btnAdd.Enabled:=False;
  end;


  FFilterPrice:=0;
  FFilterMin:=AFilterMin;
  //获取商品详情
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                   DoGetShopGoodsInfoExecute,
                   DoGetShopGoodsInfoExecuteEnd,
                   'GetShopGoodsInfo');
end;

procedure TFrameShopGoodsInfo.pnlBankGroudClick(Sender: TObject);
begin
  HideFrame;//(Self,hfcttBeforeShowFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameShopGoodsInfo.sbBottomResize(Sender: TObject);
begin
  Self.imgGoodsPic.Width:=Self.Width;
end;

end.

