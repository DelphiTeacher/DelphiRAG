unit UserListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uUIFunction,
  uFuncCommon,
  WaitingFrame,
  MessageBoxFrame,
  uFrameContext,

  uBaseList,
  HintFrame,

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
  EasyServiceCommonMaterialDataMoudle,


  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType,
  uSkinFireMonkeyListBox, uDrawPicture, uSkinImageList,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, uSkinImageType,
  uSkinFireMonkeyImage, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinListViewType, uSkinFireMonkeyListView;

type
  TFrameUserList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnSearch: TSkinFMXButton;
    lbData: TSkinFMXListView;
    procedure btnReturnClick(Sender: TObject);
    procedure lbDataPullDownRefresh(Sender: TObject);
    procedure lbDataPullUpLoadMore(Sender: TObject);
    procedure lbDataPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure lbDataClickItem(AItem: TSkinItem);
    procedure btnAddClick(Sender: TObject);
    procedure btnDescClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
  private
    FPageIndex:Integer;

    FUserList:TUserList;

//    FListBoxItem:TSkinItem;
//
//    //搜索关键字
//    FFilterKey:String;
//    //店铺fFID
//    FFilterShopFID:Integer;
//
//    //是否正常营业
//    FIsDoBusiness:Boolean;
//    //店铺商品FID
//    FFilterGoodsFID:Integer;
//    //商品顺序号
//    FFilterOrderno:Double;
//
//    FFilterGoodsSpecFID:Integer;
//
//    FFilterGoodsAttrValue:String;
//
//    FFilterDelGoodsFID:Integer;
//    FFilterDelNumber:Integer;
//
//    //店铺
//    Fshop:TShop;

    //获取搜索列表
    procedure DoGetUserListExecute(ATimerTask:TObject);
    procedure DoGetUserListExecuteEnd(ATimerTask:TObject);

//    //从商品详情页面返回
//    procedure OnReturnFromShopGoodInfoFrame(AFrame:TFrame);
//
//    //从添加多规格商品页面返回
//    procedure OnReturnFromGoodsInfoFrame(AFrame:TFrame);
//
//    //从购物车页面返回
//    procedure OnReturnFromUserCarFrame(AFrame:TFrame);
    { Private declarations }
  public
    //清空
    procedure Clear;
    //加载
    procedure Load;//(AFilterKey:String;AFilterShopFID:Integer;AIsDoBusiness:Boolean;Ashop:TShop);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalUserListFrame:TFrameUserList;

implementation

{$R *.fmx}

uses
  MainForm,
  LoginFrame,
//  UserCarFrame,
//  ShopAddUserCarFrame,
//  ShopGoodsInfoFrame,
  MainFrame;

{ TFrameUserList }

procedure TFrameUserList.btnAddClick(Sender: TObject);
//var
//  AShopGoods:TShopGoods;
//  Account:Integer;
begin
//  AShopGoods:=TShopGoods(Self.lbData.Prop.InteractiveItem.Data);
//
//  Self.FFilterGoodsFID:=AShopGoods.fid;
//
//  FFilterOrderno:=AShopGoods.orderno;
//
//  FListBoxItem:=Self.lbData.Prop.InteractiveItem;
//
//  if Self.FListBoxItem.Detail2<>'' then
//  begin
//    Account:=StrToInt(FListBoxItem.Detail2);
//  end
//  else
//  begin
//    Account:=0;
//  end;
//
//  if GlobalManager.IsLogin=True then
//  begin
//    if AShopGoods.GoodsSpecList.Count>0 then
//    begin
//      if (AShopGoods.GoodsSpecList.Count=1) and (AShopGoods.GoodsAttrList.Count=0) then
//      begin
//        Self.FFilterGoodsSpecFID:=AShopGoods.GoodsSpecList[0].fid;
//
//        Self.FFilterGoodsAttrValue:='';
//
//        GlobalMainFrame.AddGoodsToUserCart(Self.FFilterShopFID,AShopGoods.fid,AShopGoods.GoodsSpecList[0].fid,1,'',AShopGoods.orderno);
//
//
////        FListBoxItem.Detail2:=IntToStr(Account+1);
//
//
////        GlobalShopInfoFrame.UpDateShopInfo;
////        AddUserCar;
//      end
//      else
//      begin
//        ShowFrame(TFrame(GlobalShopAddUserCarFrame),TFrameShopAddUserCar,frmMain,nil,nil,OnReturnFromGoodsInfoFrame,Application,True,False,ufsefNone);
//        GlobalShopAddUserCarFrame.Clear;
//        GlobalShopAddUserCarFrame.Init(Account,1,0,AShopGoods);
//      end;
//    end;
////    else if AShopGoods.GoodsSpecList.Count=1 then
////    begin
////      Sum:=Sum+1;
////      Self.tvUserList.Prop.InteractiveItem.Detail2:=IntToStr(Sum);
////
////      Self.AddUserCar;
////    end;
//  end
//  else
//  begin
//    //去登录
//    //隐藏
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//    //显示登录页面
//    ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
////    GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
//    //清除输入框
//    GlobalLoginFrame.Clear;
//  end;

end;

procedure TFrameUserList.btnDescClick(Sender: TObject);
//var
//  AShopGoods:TShopGoods;
//  AIsMoreSpec:Integer;
//  I:Integer;
begin
//  AIsMoreSpec:=0;
//  AShopGoods:=TShopGoods(Self.lbData.Prop.InteractiveItem.Data);
//
//  for I := 0 to GlobalManager.UserCarShopList.FindItemByFID(Self.FShop.fid).FCarGoodList.Count-1 do
//  begin
//    if AShopGoods.fid=GlobalManager.UserCarShopList.FindItemByFID(Self.FShop.fid).FCarGoodList[I].shop_goods_fid then
//    begin
//
//      AIsMoreSpec:=AIsMoreSpec+1;
//
//    end;
//
//  end;
//
//  if AShopGoods.GoodsSpecList.Count>0 then
//  begin
//    if AIsMoreSpec<=1 then
//    begin
////      Self.Sum:=Self.Sum-1;
//
//      FListBoxItem:=Self.lbData.Prop.InteractiveItem;
//
//      if FListBoxItem.Detail5<>'' then
//      begin
//        Self.FFilterDelGoodsFID:=StrToInt(FListBoxItem.Detail5);
//      end
//      else
//      begin
//        Self.FFilterDelGoodsFID:=Self.GetGoodsCartFID(AShopGoods.fid);
//      end;
//
//      FFilterDelNumber:=StrToInt(FListBoxItem.Detail2)-1;
//
//      GlobalMainFrame.UpdateCartGoodsNumber(Self.FFilterDelGoodsFID,Self.FFilterDelNumber);
//
////      if Self.FFilterDelNumber<>0 then
////      begin
////        FListBoxItem.Detail2:=IntToStr(Self.FFilterDelNumber);
////      end
////      else
////      begin
////        FListBoxItem.Detail2:='';
////      end;
//
//
////      //修改购物车商品数量
////      ShowWaitingFrame(Self,'删除中...');
////      uTimerTask.GetGlobalTimerThread.RunTempTask(
////                  DoDelCarShopGoodExecute,
////                  DoDelCarShopGoodExecuteEnd);
//    end
//    else
//    begin
//      ShowHintFrame(Self,'多规格请在店铺的购物车列表中删除');
//    end;
//  end;
////  else
////  begin
////    //必须在列表里面删除
////    ShowMessage('请在下方购物车列表中删除');
////  end;
//

end;

procedure TFrameUserList.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then Exit;

  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameUserList.btnSearchClick(Sender: TObject);
begin
//  if GlobalManager.IsLogin=True then
//  begin
//    //购物车列表页面
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//
//    ShowFrame(TFrame(GlobalUserCarFrame),TFrameUserCar,OnReturnFromUserCarFrame);
////    GlobalUserCarFrame.FrameHistroy:=CurrentFrameHistroy;
//    GlobalUserCarFrame.Clear;
//    GlobalUserCarFrame.Init;
//  end
//  else
//  begin
//    //去登录
//    //隐藏
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//    //显示登录页面
//    ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application);
////    GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
//    //清除输入框
//    GlobalLoginFrame.Clear;
//
//  end;
end;

procedure TFrameUserList.Clear;
begin
  Self.lbData.Prop.Items.BeginUpdate;
  try
    Self.lbData.Prop.Items.Clear(True);
  finally
    Self.lbData.Prop.Items.EndUpdate;
  end;
end;

constructor TFrameUserList.Create(AOwner: TComponent);
begin
  inherited;
  FUserList:=TUserList.Create;


  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameUserList.Destroy;
begin
  FreeAndNil(FUserList);
  inherited;
end;

procedure TFrameUserList.DoGetUserListExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_user_list',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
//                                                      'shop_fid',
                                                      'key',
                                                      'pageindex',
                                                      'pagesize'//,
//                                                      'filter_goods_category_fid',
//                                                      'filter_goods_name'
                                                      ],
                                                      [AppID,
                                                      GlobalManager.User.fid,
//                                                      Self.FFilterShopFID,
                                                      '',
                                                      Self.FPageIndex,
                                                      20//,
//                                                      '',
//                                                      Self.FFilterKey
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

procedure TFrameUserList.DoGetUserListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AUserList:TUserList;
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
//  h: Integer;
//  AMinSpecialPrice:Double;
//  AMinOriginPrice:Double;
//  J: Integer;
//  k:Integer;
//  g:Integer;
//  ASumPrice:Double;
//  AIsOffsell:Boolean;
//  ANumber:Integer;
begin

  try

    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取成功
        Self.lbData.prop.Items.BeginUpdate;
        AUserList:=TUserList.Create(ooReference);
        try

            if Self.FPageIndex=1 then
            begin
              Self.FUserList.Clear(True);
              Self.lbData.Prop.Items.Clear(True);
            end;


            AUserList.ParseFromJsonArray(TShopGoods,ASuperObject.O['Data'].A['UserList']);




//           AIsOffsell:=True;

            for I := 0 to AUserList.Count-1 do
            begin
                Self.FUserList.Add(AUserList[I]);

//              for J := 0 to AUserList[I].GoodsSpecList.Count-1 do
//              begin
//                if AUserList[I].GoodsSpecList[J].is_offsell=0 then
//                begin
//                  //上架
//                  AIsOffsell:=False;
//                end;
//              end;
//
//
//              if AIsOffsell=False then
//              begin
//
//                  AListBoxItem:=Self.lbData.Prop.Items.Add;
//                  AListBoxItem.Data:=AUserList[I];
//                  Self.FUserList.Add(AUserList[I]);
//                  AListBoxItem.Caption:=AUserList[I].name;
//                  AListBoxItem.Icon.Url:=AUserList[I].GetPic1Url;
//
//                  if AUserList[I].GoodsSpecList.Count>0 then
//                  begin
//                    AMinSpecialPrice:=0;
//                    AMinOriginPrice:=0;
//
//                    if AUserList[I].GoodsSpecList[0].special_price<>0 then
//                    begin
//                      //活动价
//                      AMinSpecialPrice:=AUserList[I].GoodsSpecList[0].special_price;
//                      AMinOriginPrice:=AUserList[I].GoodsSpecList[0].price;
//                    end
//                    else
//                    begin
//                      //原价
//                      AMinSpecialPrice:=AUserList[I].GoodsSpecList[0].price;
//                      AMinOriginPrice:=0;
//                    end;
//
//                    for g := 0 to AUserList[I].GoodsSpecList.Count-1 do
//                    begin
//                      if AUserList[I].GoodsSpecList[g].special_price<>0 then
//                      begin
//                        //比活动价
//                        if AMinSpecialPrice>=AUserList[I].GoodsSpecList[g].special_price then
//                        begin
//                          AMinSpecialPrice:=AUserList[I].GoodsSpecList[g].special_price;
//                          AMinOriginPrice:=AUserList[I].GoodsSpecList[g].price;
//                        end;
//                      end
//                      else
//                      begin
//                        //比原价
//                        if AMinSpecialPrice>=AUserList[I].GoodsSpecList[g].price then
//                        begin
//                          AMinSpecialPrice:=AUserList[I].GoodsSpecList[g].price;
//                          AMinOriginPrice:=0;
//                        end;
//                      end;
//
//                    end;
//
//                    AListBoxItem.Detail:='￥'+Format('%.2f',[AMinSpecialPrice]);
//                    if AMinOriginPrice<>0 then
//                    begin
//                      AListBoxItem.Detail4:=Format('%.2f',[AMinOriginPrice]);
//                    end
//                    else
//                    begin
//                      AListBoxItem.Detail4:='';
//                    end;
//                    AListBoxItem.Detail6:=Format('%.2f',[AMinSpecialPrice]);
//
//                  end
//                  else
//                  begin
//                    AListBoxItem.Detail:='没有标价';
//                  end;
//                  AListBoxItem.Detail1:='月售'+IntToStr(AUserList[I].month_sales);
//                  AListBoxItem.Detail3:='好评率'+FloatToStr(AUserList[I].satisfy_rate*100)+'%';
//                  AListBoxItem.Icon.Url:=AUserList[I].GetPic1Url;
//
//                  if Self.FIsDoBusiness=True then
//                  begin
//
//                    UpdateMyCarFrame;
////                    if GlobalManager.UserCarShopList<>nil then
////                    begin
////                      ANumber:=0;
////                      if GlobalManager.UserCarShopList.Count>0 then
////                      begin
////                        for k := 0 to GlobalManager.UserCarShopList.Count-1 do
////                        begin
////
////                          for h := 0 to GlobalManager.UserCarShopList[k].FCarGoodList.Count-1 do
////                          begin
////                            if AUserList[I].fid=GlobalManager.UserCarShopList[k].FCarGoodList[h].shop_goods_fid then
////                            begin
////                              AListBoxItem.Detail5:=IntToStr(GlobalManager.UserCarShopList[k].FCarGoodList[h].fid);
////                              if AListBoxItem.Detail2='' then
////                              begin
////                                ANumber:=0;
////                              end
////                              else
////                              begin
////                                ANumber:=StrToInt(AListBoxItem.Detail2);
////                              end;
////                              AListBoxItem.Detail2:=IntToStr(ANumber+GlobalManager.UserCarShopList[k].FCarGoodList[h].number);
////                            end;
////                          end;
////
////                        end;
////                      end;
////                    end;
//                  end;
//
//                  if AUserList[I].is_new=1 then
//                  begin
//                    AListBoxItem.Pic.ImageIndex:=0;
//                  end
//                  else if AUserList[I].is_featured=1 then
//                  begin
//                    AListBoxItem.Pic.ImageIndex:=1;
//                  end
//                  else
//                  begin
//                    AListBoxItem.Pic.ImageIndex:=-1;
//                  end;
//              end;
            end;


        finally
          Self.lbData.Prop.Items.EndUpdate();
          FreeAndNil(AUserList);
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

    //结束加载
    if FPageIndex>1 then
    begin
      if (TTimerTask(ATimerTask).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['UserList'].Length>0) then
      begin
        Self.lbData.Prop.StopPullUpLoadMore('加载成功!',0,True);
      end
      else
      begin
        Self.lbData.Prop.StopPullUpLoadMore('下面没有了!',600,False);
      end;
    end
    else
    begin
      Self.lbData.Prop.StopPullDownRefresh('刷新成功!',600);
    end;

  end;
end;

//function TFrameUserList.GetGoodsCartFID(AShopGoodsFID: Integer): Integer;
//var
//  J:Integer;
//  k:Integer;
//begin
//  Result:=0;
//
//  for J := 0 to GlobalManager.UserCarShopList.Count-1 do
//  begin
//    for k := 0 to GlobalManager.UserCarShopList[J].FCarGoodList.Count-1 do
//    begin
//      if AShopGoodsFID=GlobalManager.UserCarShopList[J].FCarGoodList[k].shop_goods_fid then
//      begin
//        Result:=GlobalManager.UserCarShopList[J].FCarGoodList[k].fid;
//      end;
//    end;
//  end;
//end;

procedure TFrameUserList.lbDataClickItem(AItem: TSkinItem);
//var
//  AShopGoods:TShopGoods;
//  ACarGoodFID:Integer;
//  AIsTakeOrder:Boolean;
begin
//  if AItem.Data<>nil then
//  begin
//    AIsTakeOrder:=False;
//
//    if (FShop.is_can_takeorder_but_only_self_take=0)
//    AND (FShop.is_can_takeorder_and_delivery=0)
//    AND (FShop.is_can_takeorder_but_only_eat_in_shop=0) then
//    begin
//       AIsTakeOrder:=False;
//    end
//    else
//    begin
//       AIsTakeOrder:=True;
//    end;
//
//    FListBoxItem:=TSkinListBoxItem(AItem);
//
//    if FListBoxItem.Detail5<>'' then
//    begin
//      ACarGoodFID:=StrToInt(FListBoxItem.Detail5);
//    end
//    else
//    begin
//      ACarGoodFID:=0;
//    end;
//
//    AShopGoods:=TShopGoods(AItem.Data);
//    ShowFrame(TFrame(GlobalShopGoodsInfoFrame),TFrameShopGoodsInfo,frmMain,nil,nil,OnReturnFromShopGoodInfoFrame,Application,True,False,ufsefNone);
//    GlobalShopGoodsInfoFrame.Clear;
//    GlobalShopGoodsInfoFrame.Init(AItem.Detail2,ACarGoodFID,0,AShopGoods,Self.FIsDoBusiness,AIsTakeOrder);
//
//  end;
end;


procedure TFrameUserList.lbDataPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
//  if AItem.Data<>nil then
//  begin
//    if (AItem.Detail2='') or (AItem.Detail2='0') then
//    begin
//      Self.btnDesc.Visible:=False;
//      Self.edtCount.Visible:=False;
//    end
//    else
//    begin
//      Self.btnDesc.Visible:=True;
//      Self.edtCount.Visible:=True;
//    end;
//  end;
end;

procedure TFrameUserList.lbDataPullDownRefresh(Sender: TObject);
begin
  Self.FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                          DoGetUserListExecute,
                          DoGetUserListExecuteEnd,
                          'GetUserList');

end;

procedure TFrameUserList.lbDataPullUpLoadMore(Sender: TObject);
begin
  Self.FPageIndex:=FPageIndex+1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                          DoGetUserListExecute,
                          DoGetUserListExecuteEnd,
                          'GetUserList');
end;

procedure TFrameUserList.Load;//(AFilterKey: String;AFilterShopFID:Integer;AIsDoBusiness:Boolean;Ashop:TShop);
begin
//  //搜索关键字
//  FFilterKey:=AFilterKey;
//  //店铺fFID
//  FFilterShopFID:=AFilterShopFID;
//
//  if AFilterKey<>'' then
//  begin
//    Self.pnlToolBar.Caption:=AFilterKey;
//  end
//  else
//  begin
//    Self.pnlToolBar.Caption:='全部商品';
//  end;
//
//
//  GlobalMainFrame.UpDateMyCar;
//
//  Self.Fshop:=AShop;
//
//  Self.FIsDoBusiness:=AIsDoBusiness;

  Self.lbData.Prop.StartPullDownRefresh;
//
//  ShowWaitingFrame(Self,'加载中...');
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                          DoGetUserListExecute,
//                          DoGetUserListExecuteEnd);
end;

//procedure TFrameUserList.OnReturnFromGoodsInfoFrame(AFrame: TFrame);
//begin
//  Self.FListBoxItem.Detail2:=IntToStr(GlobalShopAddUserCarFrame.FFilterCount);
//end;
//
//procedure TFrameUserList.OnReturnFromShopGoodInfoFrame(AFrame: TFrame);
//begin
////    if GlobalShopGoodsInfoFrame.FFilterCount<>0 then
////  begin
////    FListBoxItem.Detail2:=IntToStr(GlobalShopGoodsInfoFrame.FFilterCount);
////  end
////  else
////  begin
////    FListBoxItem.Detail2:='';
////  end;
//end;
//
//procedure TFrameUserList.OnReturnFromUserCarFrame(AFrame: TFrame);
//begin
//  GlobalMainFrame.UpDateMyCar;
//end;


//procedure TFrameUserList.UpdateMyCarFrame;
//var
//  AShopGoods:TShopGoods;
//  I: Integer;
//  J: Integer;
//begin
//  for I := 0 to Self.lbData.Prop.Items.Count-1 do
//  begin
//    if Self.lbData.Prop.Items[I].Data<>nil then
//    begin
//      AShopGoods:=TShopGoods(Self.lbData.Prop.Items[I].Data);
//
//      Self.lbData.Prop.Items[I].Detail2:='';
//
//      if GlobalManager.UserCarShopList.FindItemByFID(AShopGoods.shop_fid)<>nil then
//      begin
//        for J := 0 to GlobalManager.UserCarShopList.FindItemByFID(AShopGoods.shop_fid).FCarGoodList.Count-1 do
//        begin
//          if AShopGoods.fid=GlobalManager.UserCarShopList.FindItemByFID(AShopGoods.shop_fid).FCarGoodList[J].shop_goods_fid then
//          begin
//            Self.lbData.Prop.Items[I].Detail2:=IntToStr(GlobalManager.UserCarShopList.FindItemByFID(AShopGoods.shop_fid).FCarGoodList[J].number);
//          end;
//        end;
//      end;
//    end;
//  end;
//end;

end.
