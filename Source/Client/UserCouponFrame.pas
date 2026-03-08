unit UserCouponFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  MessageBoxFrame,
  SelectAreaFrame,
  uUIFunction,
//  uOpenClientCommon,

  uFuncCommon,
  uManager,
  uOpenClientCommon,
  uOpenCommon,
  uGPSLocation,
  uLang,

  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,

  uSkinBufferBitMap,

  XSuperObject,
  XSuperJson,

  uSkinItems,

  uDataSetToJson,


  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType,
  uSkinFireMonkeyListBox, uSkinPageControlType, uSkinSwitchPageListPanelType,
  uSkinFireMonkeyPageControl, uSkinImageType, uSkinFireMonkeyImage,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uDrawCanvas;

type
  TFrameUserCoupon = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbCoupon: TSkinFMXListBox;
    idpItem1: TSkinFMXItemDesignerPanel;
    lblDescMoney: TSkinFMXLabel;
    lblShopName: TSkinFMXLabel;
    lblDate: TSkinFMXLabel;
    lblCondition: TSkinFMXLabel;
    lblFullMoney: TSkinFMXLabel;
    SkinFMXLabel6: TSkinFMXLabel;
    SkinFMXImage2: TSkinFMXImage;
    lblShopLimit: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure SkinFMXLabel6Click(Sender: TObject);
  private

    procedure DoGetUserCouponListExecute(ATimerTask:TObject);
    procedure DoGetUserCouponListExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    FFilterKey:String;
    //清空列表
    procedure Clear;
    //加载页面
    procedure Load;

  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalUserCouponFrame:TFrameUserCoupon;

implementation

uses
  MainForm,
  MainFrame,
  ShopInfoFrame;

{$R *.fmx}

procedure TFrameUserCoupon.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameUserCoupon.Clear;
begin
  Self.lbCoupon.Prop.Items.Clear(True);
end;

constructor TFrameUserCoupon.Create(AOwner: TComponent);
begin
  inherited;
  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameUserCoupon.Destroy;
begin

  inherited;
end;


procedure TFrameUserCoupon.DoGetUserCouponListExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_my_coupon_list',
                                                      nil,
                                                      PromotionCenterInterfaceUrl,
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

procedure TFrameUserCoupon.DoGetUserCouponListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
  ACouponObject:ISuperObject;
  ADateTime:TDateTime;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取成功
        Self.lbCoupon.Prop.Items.Clear(True);

        //加载列表
        Self.lbCoupon.Prop.Items.BeginUpdate;
        try
          for I := 0 to ASuperObject.O['Data'].A['MyCouponList'].Length-1 do
          begin
            ACouponObject:=ASuperObject.O['Data'].A['MyCouponList'].O[I];
            //是红包
//            if ACouponObject.I['is_coupon']=1 then
//            begin
              AListBoxItem:=Self.lbCoupon.Prop.Items.Add;
              AListBoxItem.ItemType:=sitItem1;
              AListBoxItem.Height:=100;
              AListBoxItem.Detail6:=ACouponObject.AsJSON;
              AListBoxItem.Caption:=ACouponObject.S['shop_name'];
              AListBoxItem.Detail1:=FormatDateTime('YYYY-MM-DD',StandardStrToDateTime(ACouponObject.S['start_date']))+'至'
                                    +FormatDateTime('YYYY-MM-DD',StandardStrToDateTime(ACouponObject.S['end_date']));

              AListBoxItem.Detail3:='仅限本店铺使用';
              AListBoxItem.Detail2:='仅限在线支付';
              AListBoxItem.Detail4:=Trans('￥')+FloatToStr(GetJsonDoubleValue(ACouponObject,'dec_money1'));
              AListBoxItem.Detail:='满'+FloatToStr(GetJsonDoubleValue(ACouponObject,'full_money1'))+'元可用';

//            end;
          end;
        finally
          Self.lbCoupon.Prop.Items.EndUpdate();
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

procedure TFrameUserCoupon.Load;
begin
  Self.Clear;

  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                  DoGetUserCouponListExecute,
                  DoGetUserCouponListExecuteEnd,
                  'GetUserCouponList');
end;

procedure TFrameUserCoupon.SkinFMXLabel6Click(Sender: TObject);
var
  ACouponObject:ISuperObject;
begin
  //获取到当前列表项的Json字符串
  ACouponObject:=TSuperObject.Create(Self.lbCoupon.Prop.InteractiveItem.Detail6);
  //进店使用
  //加载店铺详情
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
  ShowFrame(TFrame(GlobalShopInfoFrame),TFrameShopInfo);
  GlobalShopInfoFrame.Clear;
  GlobalShopInfoFrame.Load(ACouponObject.I['shop_fid'],
                            nil,
                            GlobalShopInfoFrame);
end;

end.
