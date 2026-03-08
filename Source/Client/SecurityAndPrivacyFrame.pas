unit SecurityAndPrivacyFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinNotifyNumberIconType, uSkinFireMonkeyNotifyNumberIcon, uSkinButtonType,
  uSkinFireMonkeyButton, uSkinLabelType, uSkinFireMonkeyLabel,

  uUIFunction,
  BlackListFrame,

  uSkinFireMonkeyControl, uSkinPanelType, uSkinFireMonkeyPanel, uDrawCanvas,
  uSkinItems, uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType, uSkinFireMonkeyListView, uSkinImageType,
  uSkinFireMonkeyImage, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel;

type
  TSecurityAndPrivacy = class(TFrame)
    lvMy: TSkinFMXListView;
    idpItem3: TSkinFMXItemDesignerPanel;
    imgPicture: TSkinFMXImage;
    lblName: TSkinFMXLabel;
    idpMy: TSkinFMXItemDesignerPanel;
    imgUserHead: TSkinFMXImage;
    lblUserName: TSkinFMXLabel;
    lblUserDetail: TSkinFMXLabel;
    imgSign: TSkinFMXImage;
    ItemMenu: TSkinFMXItemDesignerPanel;
    imgItemMenuIcon: TSkinFMXImage;
    lblItemMenuCaption: TSkinFMXLabel;
    idpItem4: TSkinFMXItemDesignerPanel;
    lblNammeCaption: TSkinFMXLabel;
    lblNameDetail: TSkinFMXLabel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnInfo: TSkinFMXButton;
    procedure lvMyClickItem(AItem: TSkinItem);
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GlobalSecurityAndPrivacyFrame:TSecurityAndPrivacy;

implementation

{$R *.fmx}


procedure TSecurityAndPrivacy.btnReturnClick(Sender: TObject);
begin
  //·µ»Ø
  HideFrame;
  ReturnFrame;
end;

procedure TSecurityAndPrivacy.lvMyClickItem(AItem: TSkinItem);
begin
  if AItem.Caption='ºÚÃûµ¥' then
  begin
    HideFrame;
    ShowFrame(TFrame(GlobalBlackListFrame),TBlackList);
    GlobalBlackListFrame.Load;
  end;
end;

end.

