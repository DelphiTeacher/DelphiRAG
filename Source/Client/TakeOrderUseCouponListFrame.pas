unit TakeOrderUseCouponListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  MessageBoxFrame,
  SelectAreaFrame,
  uUIFunction,
  uManager,
  uOpenClientCommon,
  uOpenCommon,
  uGPSLocation,

  uLang,
  uFrameContext,

  uFuncCommon,
//  uOpenClientCommon,

  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,

  uSkinBufferBitmap,

  XSuperObject,
  XSuperJson,

  uSkinItems,

  uDataSetToJson,

  uBaseList,
  uDrawCanvas,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinFireMonkeyListBox,
  uSkinCheckBoxType, uSkinFireMonkeyCheckBox;

type
  TFrameTakeOrderUseCouponList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbCoupon: TSkinFMXListBox;
    idpCoupon: TSkinFMXItemDesignerPanel;
    lblMoney: TSkinFMXLabel;
    lblName: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    lblfull: TSkinFMXLabel;
    idpNoUse: TSkinFMXItemDesignerPanel;
    lblNoUse: TSkinFMXLabel;
    cbSele: TSkinFMXCheckBox;
    cbItemSelect: TSkinFMXCheckBox;
    lblNoUseful: TSkinFMXLabel;
    lblNoUsefulReason: TSkinFMXLabel;
    imgNo: TSkinFMXImage;
    pnlDevice: TSkinFMXPanel;
    procedure btnReturnClick(Sender: TObject);
    procedure lbCouponClickItem(AItem: TSkinItem);
    procedure lbCouponPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
  private
    //引用
    FCouponList:TCouponList;

    procedure Load(ACouponList:TCouponList);
//    //获取红包列表
//    procedure DoGetCouponListExecute(ATimerTask:TObject);
//    procedure DoGetCouponListExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    //减免金额
    FDescMoney:Double;
    //红包FID
    FCouponFID:Integer;

    FSelectedCouponFID:Integer;
    //清空
    procedure Clear;
    //加载红包列表
    procedure Init(ATakeCouponList:TCouponList;AUserCouponFID:Integer);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalTakeOrderUseCouponListFrame:TFrameTakeOrderUseCouponList;


implementation

{$R *.fmx}

{ TFrameTakeOrderUseCouponList }

procedure TFrameTakeOrderUseCouponList.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;
  ReturnFrame();
end;

procedure TFrameTakeOrderUseCouponList.Clear;
begin
  Self.lbCoupon.Prop.Items.Clear(True);
end;

constructor TFrameTakeOrderUseCouponList.Create(AOwner: TComponent);
begin
  inherited;
//  FCouponList:=TCouponList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameTakeOrderUseCouponList.Destroy;
begin
//  FreeAndNil(FCouponList);
  inherited;
end;

//procedure TFrameTakeOrderUseCouponList.DoGetCouponListExecute(
//  ATimerTask: TObject);
//begin
//  // 出错
//  TTimerTask(ATimerTask).TaskTag := 1;
//  try
//    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_my_coupon_list',
//                                                      nil,
//                                                      PromotionCenterInterfaceUrl,
//                                                      ['appid',
//                                                      'user_fid',
//                                                      'key'],
//                                                      [AppID,
//                                                      GlobalManager.User.fid,
//                                                      GlobalManager.User.key
//                                                      ],
//                                        GlobalRestAPISignType,
//                                        GlobalRestAPIAppSecret
//                                                      );
//    if TTimerTask(ATimerTask).TaskDesc <> '' then
//    begin
//      TTimerTask(ATimerTask).TaskTag := 0;
//    end;
//
//  except
//    on E: Exception do
//    begin
//      // 异常
//      TTimerTask(ATimerTask).TaskDesc := E.Message;
//    end;
//  end;
//end;
//
//procedure TFrameTakeOrderUseCouponList.DoGetCouponListExecuteEnd(
//  ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//  I: Integer;
//  AListBoxItem:TSkinListBoxItem;
//  ADateTime:TDateTime;
//  ACouponList:TCouponList;
//  J: Integer;
//begin
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//        //获取成功
//        Self.lbCoupon.Prop.Items.Clear(True);
//
////        FCouponList.Clear(True);
//
//        ACouponList:=TCouponList.Create(ooReference);
//
//        ACouponList.ParseFromJsonArray(TCoupon,ASuperObject.O['Data'].A['MyCouponList']);
//        //加载列表
//        Self.lbCoupon.Prop.Items.BeginUpdate;
//        try
//
//          AListBoxItem:=Self.lbCoupon.Prop.Items.Add;
//          AListBoxItem.Height:=40;
//          AListBoxItem.ItemType:=sitItem1;
//          AListBoxItem.Data:=nil;
//          AListBoxItem.Selected:=True;
//
//
//          for I := 0 to ACouponList.Count-1 do
//          begin
//
//              //是红包
//              if (ACouponList[I].is_coupon=1) and (ACouponList[I].is_used=0) then
//              begin
//                AListBoxItem:=Self.lbCoupon.Prop.Items.Add;
//                AListBoxItem.Data:=ACouponList[I];
//  //              FCouponList.Add(ACouponList[I]);
//                for J := 0 to Self.FCouponList.Count-1 do
//                begin
//                    if ACouponList[I].shop_fid=Self.FCouponList[J].shop_fid then
//                    begin
//                        AListBoxItem.Height:=80;
//                        AListBoxItem.Accessory:=satNone;
//
//                        if (StandardStrToDateTime(ACouponList[I].end_time)>=Now) or (StandardStrToDateTime(ACouponList[I].end_date)>=Now) then
//                        begin
//                          //有效
//                          AListBoxItem.Height:=80;
//                          AListBoxItem.Accessory:=satNone;
//                        end
//                        else
//                        begin
//                          //无效
//                          AListBoxItem.Height:=120;
//                          AListBoxItem.Accessory:=satMore;
//                        end;
//                    end
//                    else
//                    begin
//                        AListBoxItem.Height:=120;
//                        AListBoxItem.Accessory:=satMore;
//                    end;
//                  end;
//
//
//
//                  AListBoxItem.Caption:=ACouponList[I].name;
//                  ADateTime:=StandardStrToDateTime(ACouponList[I].end_date);
//                  AListBoxItem.Detail:=FormatDateTime('YYYY-MM-DD',ADateTime)+'到期';
//                  AListBoxItem.Detail2:=Trans('￥')+FloatToStr(ACouponList[I].dec_money1);
//                  AListBoxItem.Detail3:='满'+FloatToStr(ACouponList[I].full_money1)+'元可用';
//                  AListBoxItem.Detail6:=IntToStr(ACouponList[I].fid);
//              end;
//
//          end;
//        finally
//          Self.lbCoupon.Prop.Items.EndUpdate();
//        end;
//
//
//        for J := 0 to Self.lbCoupon.Prop.Items.Count-1 do
//        begin
//          if Self.FSelectedCouponFID=0 then
//          begin
//            if Self.lbCoupon.Prop.Items[J].ItemType=sitItem1 then
//            begin
//              Self.lbCoupon.Prop.Items[J].Selected:=True;
//            end
//            else
//            begin
//              Self.lbCoupon.Prop.Items[J].Selected:=False;
//            end;
//
//          end
//          else
//          begin
//            if Self.lbCoupon.Prop.Items[J].Detail6=IntToStr(FSelectedCouponFID) then
//            begin
//              Self.lbCoupon.Prop.Items[J].Selected:=True;
//            end
//            else
//            begin
//              Self.lbCoupon.Prop.Items[J].Selected:=False;
//            end;
//          end;
//        end;
//
//      end
//      else
//      begin
//        //调用失败
//        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
//      end;
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    HideWaitingFrame;
//
//    FreeAndNil(ACouponList);
//  end;
//end;

procedure TFrameTakeOrderUseCouponList.Init(ATakeCouponList:TCouponList;AUserCouponFID:Integer);
begin

  Self.pnlDevice.Visible:=False;
  Self.imgNo.Visible:=False;
  Self.lblNoUseful.Visible:=False;
  Self.lblNoUsefulReason.Visible:=False;

  FCouponList:=ATakeCouponList;

  FSelectedCouponFID:=AUserCouponFID;


  Load(FCouponList);

//  //加载红包列表
//  ShowWaitingFrame(Self,'加载中...');
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//              DoGetCouponListExecute,
//              DoGetCouponListExecuteEnd,
//              'GetCouponList');
end;

procedure TFrameTakeOrderUseCouponList.lbCouponClickItem(AItem: TSkinItem);
var
  I: Integer;
  ACoupon:TCoupon;
begin


  for I := 0 to Self.lbCoupon.Prop.Items.Count-1 do
  begin
    if AItem.ItemType<>Self.lbCoupon.Prop.Items[I].ItemType then
    begin
      Self.lbCoupon.Prop.Items[I].Selected:=False;
    end
    else
    begin
      if Self.lbCoupon.Prop.Items[I].Detail6<>AItem.Detail6 then
      begin
        Self.lbCoupon.Prop.Items[I].Selected:=False;
      end;
    end;
  end;

  if (AItem.ItemType<>sitItem1) and (AItem.Accessory=satNone) then
  begin
    ACoupon:=TCoupon(AItem.Data);


    AItem.Selected:=True;

    FDescMoney:=ACoupon.dec_money1;
    FCouponFID:=ACoupon.fid;

    //返回
    HideFrame;//();
    ReturnFrame;//();
  end
  else
  begin
    FDescMoney:=0;
    FCouponFID:=0;

    AItem.Selected:=False;
  end;



end;

procedure TFrameTakeOrderUseCouponList.lbCouponPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
//var
//  ACoupon:TCoupon;
//  I: Integer;
begin
//  if AItem.Data<>nil then
//  begin
//    ACoupon:=TCoupon(AItem.Data);
//
//    for I := 0 to Self.FCouponList.Count-1 do
//    begin
//      if ACoupon.shop_fid=Self.FCouponList[I].shop_fid then
//      begin
////        AItem.Height:=80;
//        Self.idpCoupon.Enabled:=True;
//
////        Self.idpCoupon.HitTest:=False;
////        AItem.Accessory:=satNone;
//
//        Self.cbSele.Visible:=True;
//
//        Self.pnlDevice.Visible:=False;
//        Self.imgNo.Visible:=False;
//        Self.lblNoUseful.Visible:=False;
//        Self.lblNoUsefulReason.Visible:=False;
//      end
//      else
//      begin
////        AItem.Height:=120;
//        Self.idpCoupon.Enabled:=False;
//
////        Self.idpCoupon.HitTest:=True;
////        AItem.Accessory:=satMore;
//
//        Self.cbSele.Visible:=False;
//
//        Self.pnlDevice.Visible:=True;
//        Self.imgNo.Visible:=True;
//        Self.lblNoUseful.Visible:=True;
//        Self.lblNoUsefulReason.Visible:=True;
//        Self.lblNoUsefulReason.Caption:='不能在该店铺使用';
//      end;
//    end;
//  end;
end;

procedure TFrameTakeOrderUseCouponList.Load(ACouponList: TCouponList);
var
//  ASuperObject:ISuperObject;
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
  ADateTime:TDateTime;
//  J: Integer;
begin
        //加载列表
        Self.lbCoupon.Prop.Items.BeginUpdate;
        try
          Self.lbCoupon.Prop.Items.Clear(True);

          AListBoxItem:=Self.lbCoupon.Prop.Items.Add;
          AListBoxItem.Height:=40;
          AListBoxItem.ItemType:=sitItem1;
          AListBoxItem.Data:=nil;
          AListBoxItem.Selected:=True;


          for I := 0 to ACouponList.Count-1 do
          begin

//              //是红包
//              if (ACouponList[I].is_coupon=1) and (ACouponList[I].is_used=0) then
//              begin
                AListBoxItem:=Self.lbCoupon.Prop.Items.Add;
                AListBoxItem.Data:=ACouponList[I];
//                for J := 0 to Self.FCouponList.Count-1 do
//                begin
//                    if ACouponList[I].shop_fid=Self.FCouponList[J].shop_fid then
//                    begin
                        AListBoxItem.Height:=80;
                        AListBoxItem.Accessory:=satNone;

//                        if (StandardStrToDateTime(ACouponList[I].end_time)>=Now) or (StandardStrToDateTime(ACouponList[I].end_date)>=Now) then
//                        begin
//                          //有效
//                          AListBoxItem.Height:=80;
//                          AListBoxItem.Accessory:=satNone;
//                        end
//                        else
//                        begin
//                          //无效
//                          AListBoxItem.Height:=120;
//                          AListBoxItem.Accessory:=satMore;
//                        end;
//                    end
//                    else
//                    begin
//                        AListBoxItem.Height:=120;
//                        AListBoxItem.Accessory:=satMore;
//                    end;
//                  end;



                  AListBoxItem.Caption:=ACouponList[I].name;
                  ADateTime:=StandardStrToDateTime(ACouponList[I].end_date);
                  AListBoxItem.Detail:=FormatDateTime('YYYY-MM-DD',ADateTime)+'到期';
                  AListBoxItem.Detail2:=Trans('￥')+FloatToStr(ACouponList[I].dec_money1);
                  AListBoxItem.Detail3:='满'+FloatToStr(ACouponList[I].full_money1)+'元可用';
                  AListBoxItem.Detail6:=IntToStr(ACouponList[I].fid);
//              end;

          end;
        finally
          Self.lbCoupon.Prop.Items.EndUpdate();
        end;


        for I := 0 to Self.lbCoupon.Prop.Items.Count-1 do
        begin
          if Self.FSelectedCouponFID=0 then
          begin
            if Self.lbCoupon.Prop.Items[I].ItemType=sitItem1 then
            begin
              Self.lbCoupon.Prop.Items[I].Selected:=True;
            end
            else
            begin
              Self.lbCoupon.Prop.Items[I].Selected:=False;
            end;

          end
          else
          begin
            if Self.lbCoupon.Prop.Items[I].Detail6=IntToStr(FSelectedCouponFID) then
            begin
              Self.lbCoupon.Prop.Items[I].Selected:=True;
            end
            else
            begin
              Self.lbCoupon.Prop.Items[I].Selected:=False;
            end;
          end;
        end;


end;

end.
