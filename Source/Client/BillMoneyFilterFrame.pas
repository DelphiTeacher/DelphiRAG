unit BillMoneyFilterFrame;

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

  uFuncCommon,
  uBaseList,

  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,

  uBufferBitMap,

  XSuperObject,
  XSuperJson,

  uSkinItems,


  uSkinFireMonkeyControl, uSkinPanelType, uSkinFireMonkeyPanel,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType, uSkinFireMonkeyListView, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinButtonType, uSkinFireMonkeyButton, uDrawCanvas;

type
  TFrameBillMoneyFilter = class(TFrame)
    pnlBankGroud: TSkinFMXPanel;
    lvFilter: TSkinFMXListView;
    idpOption: TSkinFMXItemDesignerPanel;
    idpFilter: TSkinFMXItemDesignerPanel;
    lblFilter: TSkinFMXLabel;
    lblName: TSkinFMXLabel;
    btnDel: TSkinFMXButton;
    procedure btnDelClick(Sender: TObject);
    procedure lvFilterClickItem(AItem: TSkinItem);
  private
    { Private declarations }
  public
    FFilterString:String;

    FFilterMoneyType:String;

    //º”‘ÿ
    procedure Load(AFilterString:String;AFilterMoneyType:String);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalBillMoneyFilterFrame:TFrameBillMoneyFilter;

implementation

{$R *.fmx}

uses
  TransactionListFrame;

{ TFrameBillMoneyFilter }

procedure TFrameBillMoneyFilter.btnDelClick(Sender: TObject);
begin
  //∑µªÿ
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

constructor TFrameBillMoneyFilter.Create(AOwner: TComponent);
begin
  inherited;
  FFilterString:='';

  FFilterMoneyType:='';

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameBillMoneyFilter.Destroy;
begin

  inherited;
end;

procedure TFrameBillMoneyFilter.Load(AFilterString,AFilterMoneyType: String);
var
  I: Integer;
begin
  FFilterString:=AFilterString;

  FFilterMoneyType:=AFilterMoneyType;

  for I := 0 to Self.lvFilter.Prop.Items.Count-1 do
  begin
    if Self.lvFilter.Prop.Items[I].Name=AFilterMoneyType then
    begin
      Self.lvFilter.Prop.Items[I].Selected:=True;
    end
    else
    begin
      Self.lvFilter.Prop.Items[I].Selected:=False;
    end;
  end;

  Self.pnlBankGroud.Margins.Top:=GlobalTransactionListFrame.pnlToolBar.Height;
end;

procedure TFrameBillMoneyFilter.lvFilterClickItem(AItem: TSkinItem);
var
  I: Integer;
begin
  FFilterString:=AItem.Caption;

  FFilterMoneyType:=AItem.Name;

  AItem.Selected:=True;
  for I := 0 to Self.lvFilter.Prop.Items.Count-1 do
  begin
    if AItem.Caption<>Self.lvFilter.Prop.Items[I].Caption then
    begin
      Self.lvFilter.Prop.Items[I].Selected:=False;
    end;
  end;

  //∑µªÿ
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

end.
