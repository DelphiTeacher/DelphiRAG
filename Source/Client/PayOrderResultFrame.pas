unit PayOrderResultFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  EasyServiceCommonMaterialDataMoudle,
  MessageBoxFrame,
  WaitingFrame,

  uFrameContext,

  uLang,

  uManager,
  uOpenClientCommon,
  uOpenCommon,
  uUIFunction,
  uTimerTask,
  XSuperObject,
  uRestInterfaceCall,
  uBaseHttpControl,
//  uOpenCommon,
  //uOpenClientCommon,

  uSkinFireMonkeyControl, uSkinFireMonkeyImage, uSkinFireMonkeyLabel,
  uSkinFireMonkeyPanel, uSkinFireMonkeyButton, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyMultiColorLabel, uDrawPicture, uSkinImageList,
  uSkinMultiColorLabelType, uSkinLabelType, uSkinImageType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinButtonType, uSkinPanelType;

type
  TFramePayOrderResult = class(TFrame,IFrameHistroyReturnEvent)
    pnlToolBar: TSkinFMXPanel;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    imgPayOrderResult: TSkinFMXImage;
    pnlPayInfo: TSkinFMXPanel;
    pnlPayInfoCenter: TSkinFMXPanel;
    lblPayOrderResult: TSkinFMXLabel;
    lblPayHint: TSkinFMXLabel;
    btnOK: TSkinFMXButton;
    lblPaymentTypeHint: TSkinFMXLabel;
    lblPaymentType: TSkinFMXLabel;
    lblSumMoneyHint: TSkinFMXLabel;
    lblSumMoney: TSkinFMXMultiColorLabel;
    imglistPayOrderResult: TSkinImageList;
    pnlPhone: TSkinFMXPanel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    lblSendCount: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    btnViewOrder: TSkinFMXButton;
    SkinFMXButton1: TSkinFMXButton;
    procedure btnViewOrderClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    //是否可以返回上一个Frame
    function CanReturn:TFrameReturnActionType;
  private
//    FOrder:TOrder;

    //从完成提示框返回
    procedure OnReturnOkButton(Frame:TObject);
    { Private declarations }
  public
    procedure Load(//AOrder:TOrder;
                    ASumMoney:Double;
                    AClientBearPayFee:Double;
                    APayType:String;
                    APayState:String;
                    APayResult:String;
                    APayHint:String;
                    AIsNeedSeeOrderButton:Boolean=True);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalPayOrderResultFrame:TFramePayOrderResult;

implementation

uses
  MainForm,
  MainFrame
  ;

{$R *.fmx}

procedure TFramePayOrderResult.Load(//AOrder: TOrder;
                                    ASumMoney:Double;
                                    AClientBearPayFee:Double;
                                    APayType:String;
                                    APayState:String;
                                    APayResult:String;
                                    APayHint:String;
                                    AIsNeedSeeOrderButton:Boolean);
begin

//  FOrder.Assign(AOrder);



  Self.lblPayOrderResult.Caption:=APayResult;
  Self.lblPayHint.Caption:=APayHint;


  //是否支付成功
  if (APayState=Const_PayState_Payed)
//  OR (APayState=Const_PayState_PayTillDone)
  then
  begin
    Self.imgPayOrderResult.Prop.Picture.ImageIndex:=1;
  end
  else
  begin
    Self.imgPayOrderResult.Prop.Picture.ImageIndex:=0;
  end;


  //支付方式
  Self.lblPaymentType.Caption:=GetPaymentTypeStr(APayType);
  Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['unit'].Text:=Trans('￥');
  //支付金额
  Self.lblSumMoney.Prop.ColorTextCollection.ItemByName['SumMoney'].Text:=
    Format('%.2f',[ASumMoney,//FOrder.sum_money
                  //只需要加上客户承担的手续费就行了
                  +AClientBearPayFee//FOrder.client_bear_pay_fee
                  ]);

  //亿诚生活  如果金额为0  就不显示了
  //可以不影响外卖  所以就直接改了
  Self.lblPaymentTypeHint.Visible:=True;
  Self.lblPaymentType.Visible:=True;
  Self.lblSumMoneyHint.Visible:=True;
  Self.lblSumMoney.Visible:=True;
  Self.btnViewOrder.Position.Y:=83;  //设计面板上的Y
  if ASumMoney=0 then
  begin
    Self.lblPaymentTypeHint.Visible:=False;
    Self.lblPaymentType.Visible:=False;
    Self.lblSumMoneyHint.Visible:=False;
    Self.lblSumMoney.Visible:=False;

    Self.btnViewOrder.Position.Y:=Self.btnViewOrder.Position.Y-55;
  end;

  Self.btnViewOrder.Visible:=AIsNeedSeeOrderButton;

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;

procedure TFramePayOrderResult.OnReturnOkButton(Frame: TObject);
begin
//  if TFrameMessageBox(Frame).ModalResult='去添加' then
//  begin
//    HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);
//    ShowFrame(TFrame(GlobalMyBankCardListFrame),TFrameMyBankCardList,frmMain,nil,nil,OnReturnFrameAddBankCard,Application);
//    GlobalMyBankCardListFrame.FrameHistroy:=CurrentFrameHistroy;
//
//    GlobalMyBankCardListFrame.lbBankList.Prop.Items.Clear;
//    GlobalMyBankCardListFrame.Load('我的银行卡',futManage,0);
//
//  end;
//  if TFrameMessageBox(Frame).ModalResult='暂时不去' then
//  begin
//    //返回首页
//    GlobalMainFrame.ShowOrderFrame;
//  end;

  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalMainFrame),TFrameMain);

end;

procedure TFramePayOrderResult.btnOKClick(Sender: TObject);
begin
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalMainFrame),TFrameMain);
end;

procedure TFramePayOrderResult.btnViewOrderClick(Sender: TObject);
begin
  //查看订单列表
  GlobalMainFrame.ShowOrderFrame;
end;

function TFramePayOrderResult.CanReturn: TFrameReturnActionType;
begin
  Result:=TFrameReturnActionType.fratCanNotReturn;
end;

constructor TFramePayOrderResult.Create(AOwner: TComponent);
begin
  inherited;
//  FOrder:=TOrder.Create;
end;

destructor TFramePayOrderResult.Destroy;
begin
//  FreeAndNil(FOrder);

  inherited;
end;


end.

