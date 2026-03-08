unit FFilterShopConditionFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  MessageBoxFrame,
  SelectAreaFrame,
  uUIFunction,
  uManager,
  uGPSLocation,

  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,

  uSkinBufferBitMap,

  XSuperObject,
  XSuperJson,

  uSkinItems,

  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinRadioButtonType, uSkinFireMonkeyRadioButton, FMX.ListBox,
  uSkinFireMonkeyComboBox, uSkinCheckBoxType, uSkinFireMonkeyCheckBox,
  uDrawCanvas;

type
  TFrameFFilterShopCondition = class(TFrame)
    pnlBankGroud: TSkinFMXPanel;
    lbFilter: TSkinFMXListBox;
    idpFilter: TSkinFMXItemDesignerPanel;
    lblFilter: TSkinFMXLabel;
    cbSelected: TSkinFMXCheckBox;
    procedure pnlBankGroudClick(Sender: TObject);
    procedure lbFilterClickItem(AItem: TSkinItem);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    FFilterKey:String;
    FFilterName:String;
    procedure Init(AFilterKey:String);
    { Public declarations }
  end;

var
  GlobalFFilterShopConditionFrame:TFrameFFilterShopCondition;

implementation

{$R *.fmx}

procedure TFrameFFilterShopCondition.Init(AFilterKey:String);
begin
  Self.lbFilter.Prop.Items.FindItemByCaption(AFilterKey).Selected:=True;
  Self.lbFilter.Height:=Self.lbFilter.Prop.Items.Count*30;
end;

procedure TFrameFFilterShopCondition.lbFilterClickItem(AItem: TSkinItem);
var
  I: Integer;
begin
  AItem.Selected:=True;
  for I := 0 to Self.lbFilter.Prop.Items.Count-1 do
  begin
    if Self.lbFilter.Prop.Items[I].Caption<>AItem.Caption then
    begin
      Self.lbFilter.Prop.Items[I].Selected:=False;
    end;
  end;

  FFilterKey:=AItem.Caption;
  FFilterName:=AItem.Name;

  HideFrame;//(Self,hfcttBeforeReturnFrame,ufsefNone);
  ReturnFrame(Self);
end;

procedure TFrameFFilterShopCondition.pnlBankGroudClick(Sender: TObject);
begin
  //按空白区域则返回上一页
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

  HideFrame;//(Self,hfcttBeforeReturnFrame,ufsefNone);
  ReturnFrame(Self);
end;

end.
