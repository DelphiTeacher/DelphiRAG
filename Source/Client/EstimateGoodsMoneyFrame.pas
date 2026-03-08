unit EstimateGoodsMoneyFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uUIFunction,

  MessageBoxFrame,
  Math,
  uManager,
  uOpenClientCommon,

  uOpenCommon,

  uFuncCommon,
  uBaseList,

  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,

  uSkinBufferBitMap,

  XSuperObject,
  XSuperJson,

  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinFireMonkeyControl, uSkinPanelType, uSkinFireMonkeyPanel,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit;

type
  TFrameEstimateGoodsMoney = class(TFrame)
    pnlBankGroud: TSkinFMXPanel;
    pnlTop: TSkinFMXPanel;
    btnCancle: TSkinFMXButton;
    btnOk: TSkinFMXButton;
    lblName: TSkinFMXLabel;
    pnlInput: TSkinFMXPanel;
    lblRemark: TSkinFMXLabel;
    pnlBorder: TSkinFMXPanel;
    edtInput: TSkinFMXEdit;
    lblMax: TSkinFMXLabel;
    procedure btnCancleClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    FFilterMoney:String;
    //清空
    procedure Clear;
    //加载
    procedure Init(AFilterMoney:String);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalEstimateGoodsMoneyFrame:TFrameEstimateGoodsMoney;

implementation

{$R *.fmx}

{ TFrameEstimateGoodsMoney }

procedure TFrameEstimateGoodsMoney.btnCancleClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameEstimateGoodsMoney.btnOkClick(Sender: TObject);
var
  AMoney:Double;
begin

  if Self.edtInput.Text<>'' then
  begin
    AMoney:=StrToFloat(Self.edtInput.Text);
    if AMoney>500 then
    begin
      ShowMessageBoxFrame(Self,'超过了最高金额','',TMsgDlgType.mtInformation,['确定'],nil);
      Exit;
    end;
  end;

  Self.FFilterMoney:=Self.edtInput.Text;

  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameEstimateGoodsMoney.Clear;
begin
  Self.edtInput.Text:='';

  FFilterMoney:='';
end;

constructor TFrameEstimateGoodsMoney.Create(AOwner: TComponent);
begin
  inherited;
  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameEstimateGoodsMoney.Destroy;
begin

  inherited;
end;

procedure TFrameEstimateGoodsMoney.Init(AFilterMoney: String);
begin
  Clear;

  FFilterMoney:=AFilterMoney;

  Self.edtInput.Text:=AFilterMoney;
end;

end.
