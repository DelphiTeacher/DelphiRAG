unit UserCarFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  MessageBoxFrame,
  SelectAreaFrame,
  uUIFunction,
  uManager,
  uOpenClientCommon,
  uOpenCommon,
  uGPSLocation,
  uFrameContext,
//  uOpenClientCommon,

  System.DateUtils,
  uFuncCommon,

  uLang,

//  uOpenCommon,
  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,

  uSkinBufferBitmap,

  XSuperObject,
  XSuperJson,

  uSkinItems,
  uDrawCanvas,

//  UserCarGoodsListFrame,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollControlType,
  uSkinScrollBoxType, uSkinFireMonkeyScrollBox, uSkinScrollBoxContentType,
  uSkinFireMonkeyScrollBoxContent, uSkinCustomListType, uSkinVirtualListType,
  uSkinTreeViewType, uSkinFireMonkeyTreeView, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinListViewType;

type
  TFrameUserCar = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    tvCar: TSkinFMXTreeView;
    idpCarShop: TSkinFMXItemDesignerPanel;
    btnShop: TSkinFMXButton;
    btnDel: TSkinFMXButton;
    idpCarGoods: TSkinFMXItemDesignerPanel;
    imgGoodsPic: TSkinFMXImage;
    lblGoodsName: TSkinFMXLabel;
    lblGoodsPrice: TSkinFMXLabel;
    idpAllPrice: TSkinFMXItemDesignerPanel;
    btnPay: TSkinFMXButton;
    mclGoodSpec: TSkinFMXMultiColorLabel;
    mclMoney: TSkinFMXMultiColorLabel;
    idpPack: TSkinFMXItemDesignerPanel;
    lblPack: TSkinFMXLabel;
    lblPackMoney: TSkinFMXLabel;
    idpcarGoods1: TSkinFMXItemDesignerPanel;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXMultiColorLabel1: TSkinFMXMultiColorLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnPayClick(Sender: TObject);
    procedure tvCarPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
  private
    //加载购物车店铺列表
    FCarShopList:TCarShopList;
    //获取购物车店铺列表
    procedure DoGetCarShopListExecute(ATimerTask:TObject);
    procedure DoGetCarShopListExecuteEnd(ATimerTask:TObject);
    //从弹出框返回
    procedure OnModalResultFromDelete(Frame: TObject);
  private
    FDelShopFID:Integer;

    FParentTreeViewItem:TBaseSkinTreeViewItem;
    //删除购物车店铺列表
    procedure DoDelCarShopExecute(ATimerTask:TObject);
    procedure DoDelCarShopExecuteEnd(ATimerTask:TObject);
  private
//    function IsDoBusiness(ACarShop:TCarShop):Boolean;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    //加载购物车列表
    procedure Init;
    //清空列表
    procedure Clear;
    { Public declarations }
  end;

var
  GlobalUserCarFrame:TFrameUserCar;

implementation


uses
  MainForm,
  TakeOrderFrame;

{$R *.fmx}

procedure TFrameUserCar.btnDelClick(Sender: TObject);
var
  ACarShop:TCarShop;
begin
  ACarShop:=TCarShop(Self.tvCar.Prop.InteractiveItem.Data);

  FParentTreeViewItem:=Self.tvCar.Prop.InteractiveItem;

  Self.FDelShopFID:=ACarShop.fid;
  //删除
  ShowMessageBoxFrame(Self,'确定删除?','',TMsgDlgType.mtInformation,['确定','取消'],OnModalResultFromDelete);
end;

procedure TFrameUserCar.btnPayClick(Sender: TObject);
var
  ACarShop:TCarShop;
begin
  ACarShop:=TCarShop(Self.tvCar.Prop.InteractiveItem.Data);

  if ACarShop.is_open=1 then
  begin
    if IsDoBusiness(ACarShop) then
    begin
      if (ACarShop.is_can_takeorder_but_only_self_take=0)
      AND (ACarShop.is_can_takeorder_and_delivery=0)
      AND (ACarShop.is_can_takeorder_but_only_eat_in_shop=0) then
      begin
        ShowMessageBoxFrame(Self,'该商家目前还不能下单!','',TMsgDlgType.mtInformation,['确定'],nil);
      end
      else
      begin
        HideFrame;//(Self);
        //下单
        ShowFrame(TFrame(GlobalTakeOrderFrame),TFrameTakeOrder);
//        GlobalTakeOrderFrame.FrameHistroy:=CurrentFrameHistroy;
        GlobalTakeOrderFrame.AddOrder(ACarShop);
      end;
    end
    else
    begin
      ShowMessageBoxFrame(Self,'商家休息中!','',TMsgDlgType.mtInformation,['确定'],nil);
    end;
  end
  else
  begin
    ShowMessageBoxFrame(Self,'该商家已暂停营业!','',TMsgDlgType.mtInformation,['确定'],nil);
  end;

end;

procedure TFrameUserCar.btnReturnClick(Sender: TObject);
begin
//  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameUserCar.Clear;
begin
  Self.tvCar.Prop.Items.Clear(True);
end;

constructor TFrameUserCar.Create(AOwner: TComponent);
begin
  inherited;
  FCarShopList:=TCarShopList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameUserCar.Destroy;
begin
  FreeAndNil(FCarShopList);
  inherited;
end;

procedure TFrameUserCar.DoDelCarShopExecute(ATimerTask: TObject);
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
                                                      Self.FDelShopFID
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

procedure TFrameUserCar.DoDelCarShopExecuteEnd(ATimerTask: TObject);
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
        Self.tvCar.Prop.Items.Remove(FParentTreeViewItem);
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


procedure TFrameUserCar.DoGetCarShopListExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=
      SimpleCallAPI('get_user_cart_goods_list',
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


procedure TFrameUserCar.DoGetCarShopListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AParentTreeViewItem:TSkinTreeViewItem;
  AChildTreeViewItem:TSkinTreeViewItem;
  I: Integer;
  J: Integer;
  ASumPrice:Double;
  AStringList:TStringList;
  h: Integer;
  AWidth:Double;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取成功
        Self.FCarShopList.Clear(True);
        Self.FCarShopList.ParseFromJsonArray(TCarShop,ASuperObject.O['Data'].A['CartGoodsList']);

        Self.tvCar.Prop.Items.Clear(True);

        Self.tvCar.Prop.Items.BeginUpdate;
        try
          AStringList:=TStringList.Create;
          for I := 0 to Self.FCarShopList.Count-1 do
          begin
            ASumPrice:=0;
            AParentTreeViewItem:=Self.tvCar.Prop.Items.Add;
            AParentTreeViewItem.Height:=33;
            AParentTreeViewItem.IsParent:=True;
            AParentTreeViewItem.Data:=Self.FCarShopList[I];
            AParentTreeViewItem.Caption:=Self.FCarShopList[I].name;
            AWidth:=0;
            AWidth:=uSkinBufferBitmap.GetStringWidth(Self.FCarShopList[I].name,Self.btnShop.Material.DrawCaptionParam.FontSize)+10;

            AParentTreeViewItem.Detail6:=FloatToStr(AWidth);
            //加载商品列表
            for J := 0 to Self.FCarShopList[I].FCarGoodList.Count-1 do
            begin
              AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
              {$IFDEF NZ}
              AChildTreeViewItem.ItemType:=sitDefault;
              {$ELSE}
              AChildTreeViewItem.ItemType:=sitItem3;
              AChildTreeViewItem.Height:=46;
              {$ENDIF}
              AChildTreeViewItem.Data:=Self.FCarShopList[I].FCarGoodList[J];
              AChildTreeViewItem.Caption:=Self.FCarShopList[I].FCarGoodList[J].shop_goods_spec_name+'-'+Self.FCarShopList[I].FCarGoodList[J].goods_name;
              AChildTreeViewItem.Icon.Url:=Self.FCarShopList[I].FCarGoodList[J].GetGoodsPic1path;
              AChildTreeViewItem.Detail:=Self.FCarShopList[I].FCarGoodList[J].shop_goods_spec_name+'/';
              AStringList.CommaText:=Self.FCarShopList[I].FCarGoodList[J].shop_goods_attrs;
              for h := 0 to AStringList.Count-1 do
              begin
                if h<AStringList.Count-1 then
                begin
                  AChildTreeViewItem.Detail2:=AChildTreeViewItem.Detail2+AStringList[h]+'/';
                end
                else
                begin
                  AChildTreeViewItem.Detail2:=AChildTreeViewItem.Detail2+AStringList[h];
                end;
              end;
              AChildTreeViewItem.Detail3:='x'+IntToStr(Self.FCarShopList[I].FCarGoodList[J].number);
              if Self.FCarShopList[I].FCarGoodList[J].special_price<>0 then
              begin
                ASumPrice:=ASumPrice+Self.FCarShopList[I].FCarGoodList[J].special_price*Self.FCarShopList[I].FCarGoodList[J].number;
                AChildTreeViewItem.Detail1:=Trans('￥')+Format('%.2f',[Self.FCarShopList[I].FCarGoodList[J].special_price*Self.FCarShopList[I].FCarGoodList[J].number]);
              end
              else
              begin
                ASumPrice:=ASumPrice+Self.FCarShopList[I].FCarGoodList[J].origin_price*Self.FCarShopList[I].FCarGoodList[J].number;
                AChildTreeViewItem.Detail1:=Trans('￥')+Format('%.2f',[Self.FCarShopList[I].FCarGoodList[J].origin_price*Self.FCarShopList[I].FCarGoodList[J].number]);
              end;
            end;

            if FCarShopList[I].paking_fee<>0 then
            begin
              //餐盒费
              AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
              AChildTreeViewItem.ItemType:=sitItem2;
              AChildTreeViewItem.Height:=33;
              AChildTreeViewItem.Caption:='餐盒';
              AChildTreeViewItem.Detail:=Trans('￥')+Format('%.2f',[FCarShopList[I].paking_fee]);
              ASumPrice:=ASumPrice+FCarShopList[I].paking_fee;
            end;


            //合计金额
            AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
            AChildTreeViewItem.ItemType:=sitItem1;
            AChildTreeViewItem.Height:=40;
            AChildTreeViewItem.Detail1:=Trans('￥')+Format('%.2f',[ASumPrice]);
            AChildTreeViewItem.Data:=Self.FCarShopList[I];

          end;

        finally
          Self.tvCar.Prop.Items.EndUpdate();
          FreeAndNil(AStringList);
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

procedure TFrameUserCar.Init;
begin


  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
               DoGetCarShopListExecute,
               DoGetCarShopListExecuteEnd,
               'GetCarShopList');
end;


//function TFrameUserCar.IsDoBusiness(ACarShop: TCarShop): Boolean;
//begin
//  Result:=False;
//
//  case DayofWeek(Now) of
//    1:
//     if ACarShop.sun_is_sale=1 then
//     begin
//       if (CompareTime(Now,StandardStrToDateTime(ACarShop.sun_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(ACarShop.sun_end_time))=-1) then
//       begin
//         Result:=True;
//       end;
//     end;
//    2:
//     if ACarShop.mon_is_sale=1 then
//     begin
//       if (CompareTime(Now,StandardStrToDateTime(ACarShop.mon_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(ACarShop.mon_end_time))=-1) then
//       begin
//         Result:=True;
//       end;
//     end;
//
//    3:
//     if ACarShop.tues_is_sale=1 then
//     begin
//       if (CompareTime(Now,StandardStrToDateTime(ACarShop.tues_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(ACarShop.tues_end_time))=-1) then
//       begin
//         Result:=True;
//       end;
//     end;
//
//    4:
//     if ACarShop.wed_is_sale=1 then
//     begin
//       if (CompareTime(Now,StandardStrToDateTime(ACarShop.wed_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(ACarShop.wed_end_time))=-1) then
//       begin
//         Result:=True;
//       end;
//     end;
//
//    5:
//     if ACarShop.thur_is_sale=1 then
//     begin
//       if (CompareTime(Now,StandardStrToDateTime(ACarShop.thur_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(ACarShop.thur_end_time))=-1) then
//       begin
//         Result:=True;
//       end;
//     end;
//
//    6:
//     if ACarShop.fri_is_sale=1 then
//     begin
//       if (CompareTime(Now,StandardStrToDateTime(ACarShop.fri_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(ACarShop.fri_end_time))=-1) then
//       begin
//         Result:=True;
//       end;
//     end;
//
//    7:
//     if ACarShop.sat_is_sale=1 then
//     begin
//       if (CompareTime(Now,StandardStrToDateTime(ACarShop.sat_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(ACarShop.sat_end_time))=-1) then
//       begin
//         Result:=True;
//       end;
//     end;
//
//  end;
//
//end;

procedure TFrameUserCar.OnModalResultFromDelete(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='确定' then
  begin
    //删除购物车列表
    ShowWaitingFrame(Self,'删除中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                   DoDelCarShopExecute,
                   DoDelCarShopExecuteEnd,
                   'DelCarShop');
  end
  else
  begin
    //留在本页面
  end;
end;

procedure TFrameUserCar.tvCarPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
  if TSkinTreeViewItem(AItem).IsParent=True then
  begin
    if TSkinTreeViewItem(AItem).Data<>nil then
    begin
      Self.btnShop.Width:=StrToFloat(TSkinTreeViewItem(AItem).Detail6);
    end;
  end;
end;

end.

