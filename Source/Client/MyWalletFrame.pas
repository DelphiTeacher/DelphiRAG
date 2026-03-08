//客户端提现
unit MyWalletFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  MessageBoxFrame,
  uUIFunction,
  uManager,
  uOpenClientCommon,
  uOpenCommon,
  uGPSLocation,

  uLang,

  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  RegisterProtocolFrame,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,

  uBufferBitMap,

  XSuperObject,
  XSuperJson,

  uSkinItems,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollBoxContentType,
  uSkinFireMonkeyScrollBoxContent, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinFireMonkeyScrollBox, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinLabelType, uSkinFireMonkeyLabel, uDrawCanvas;

type
  TFrameMyWallet = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbWallet: TSkinFMXListBox;
    idpItem1: TSkinFMXItemDesignerPanel;
    lblMyMoney: TSkinFMXLabel;
    imgPic: TSkinFMXImage;
    lblMoney: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    imgSign: TSkinFMXImage;
    idpDefault: TSkinFMXItemDesignerPanel;
    imgPic1: TSkinFMXImage;
    lblCaption: TSkinFMXLabel;
    imgSign1: TSkinFMXImage;
    btnInfo: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lbWalletClickItem(AItem: TSkinItem);
    procedure btnInfoClick(Sender: TObject);
  private
    //账户余额
    FFilterMoney:Double;
    //从我的余额页面返回
    procedure OnFrameBalanceFrame(AFrame:TFrame);
    { Private declarations }
  public
    procedure Clear;
    //用户获取账户余额
    procedure Init(AFilterMoney:Double);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;




var
  GlobalMyWalletFrame:TFrameMyWallet;

implementation

{$R *.fmx}
uses
  MainForm,MainFrame,TransactionListFrame,UserBalanceFrame;

{ TFrameMyWallet }

procedure TFrameMyWallet.btnInfoClick(Sender: TObject);
begin
  //查看余额详情
  FreeAndNil(GlobalRegisterProtocolFrame);
  //查看活动规则
  ShowFrame(TFrame(GlobalRegisterProtocolFrame),TFrameRegisterProtocol,frmMain,nil,nil,nil,Application,False,False,ufsefNone);
  GlobalRegisterProtocolFrame.Load('钱包说明',
                                    'http://'+ServerHost+'/open/apps/'+IntToStr(AppID)+'/UserWalletProtocol.html');

end;

procedure TFrameMyWallet.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameMyWallet.Clear;
begin
  Self.FFilterMoney:=0;
  Self.lbWallet.Prop.Items.FindItemByType(sitItem1).Detail:='';
  Self.lbWallet.Prop.Items.FindItemByType(sitItem1).Detail1:='';
end;

constructor TFrameMyWallet.Create(AOwner: TComponent);
begin
  inherited;
  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameMyWallet.Destroy;
begin

  inherited;
end;

procedure TFrameMyWallet.Init(AFilterMoney:Double);
begin
  Clear;

  FFilterMoney:=AFilterMoney;
  Self.lbWallet.Prop.Items.FindItemByType(sitItem1).Detail:=Trans('￥')+Format('%.2f',[AFilterMoney]);

  if AFilterMoney<>0 then
  begin
    Self.lbWallet.Prop.Items.FindItemByType(sitItem1).Detail1:='提现';
    Self.imgSign.Visible:=True;
  end
  else
  begin
    Self.lbWallet.Prop.Items.FindItemByType(sitItem1).Detail1:='不可提现';
    Self.imgSign.Visible:=False;
  end;
end;

procedure TFrameMyWallet.lbWalletClickItem(AItem: TSkinItem);
begin
  if AItem.Caption='交易明细' then
  begin

    //隐藏
    HideFrame;//(Self,hfcttBeforeShowFrame);
    //显示交易列表
    ShowFrame(TFrame(GlobalTransactionListFrame),TFrameTransactionList,frmMain,nil,nil,nil,Application);
//    GlobalTransactionListFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalTransactionListFrame.InitTransactionList('','');
  end;

  if AItem.Caption='我的余额' then
  begin
    if FFilterMoney<>0 then
    begin
      //隐藏
      HideFrame;//(Self,hfcttBeforeShowFrame);
      //显示交易列表
      ShowFrame(TFrame(GlobalUserBalanceFrame),TFrameUserBalance,frmMain,nil,nil,OnFrameBalanceFrame,Application);
//      GlobalUserBalanceFrame.FrameHistroy:=CurrentFrameHistroy;
      GlobalUserBalanceFrame.Init(FFilterMoney);
    end;
  end;
end;

procedure TFrameMyWallet.OnFrameBalanceFrame(AFrame: TFrame);
begin

  FFilterMoney:=GlobalUserBalanceFrame.FUsedMoney;
  Self.lbWallet.Prop.Items.FindItemByType(sitItem1).Detail:=
          Trans('￥')+Format('%.2f',[GlobalUserBalanceFrame.FUsedMoney]);

end;

end.
