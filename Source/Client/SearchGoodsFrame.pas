unit SearchGoodsFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit,

  uManager,
    uOpenClientCommon,

  uSkinItems,
  uUIFunction,

  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,

  uSkinFireMonkeyEdit, uSkinPanelType,
  uSkinFireMonkeyPanel, uSkinButtonType, uSkinFireMonkeyButton, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType, uSkinFireMonkeyListView, uDrawCanvas;

type
  TFrameSearchGoods = class(TFrame)
    lvSearchHistory: TSkinFMXListView;
    ItemDefault: TSkinFMXItemDesignerPanel;
    lblItemDefaultCaption: TSkinFMXLabel;
    ItemHeader: TSkinFMXItemDesignerPanel;
    lblItemHeaderCaption: TSkinFMXLabel;
    ItemFooter: TSkinFMXItemDesignerPanel;
    btnClearHistory: TSkinFMXButton;
    pnlToolBar: TSkinFMXPanel;
    edtSearch: TSkinFMXEdit;
    btnReturn: TSkinFMXButton;
    btnSearch: TSkinFMXButton;
    procedure btnClearHistoryClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure lvSearchHistoryClickItem(AItem: TSkinItem);
  private
    FSearchType:String;
    FSearchHistoryList:TStringList;

    FIsDoBusiness:Boolean;

    FShop:TShop;

    FFieldFID:Integer;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure Load(ACaption:String;
                    ASearchType:String;
                    AShop:TShop;
                    AFiledFID:Integer;
                    AIsDoBusiness:Boolean;
                    ASearchHistoryList:TStringList);
    { Public declarations }
  end;

var
  GlobalSearchGoodsFrame:TFrameSearchGoods;

implementation

{$R *.fmx}
uses
  MainFrame,
  GoodsListFrame,
  MainForm;

procedure TFrameSearchGoods.btnClearHistoryClick(Sender: TObject);
begin
  //清空历史记录
  FSearchHistoryList.Clear;
  GlobalManager.Save;
  Load(Self.edtSearch.Prop.HelpText,
        FSearchType,
        Self.FShop,
        Self.FFieldFID,
        FIsDoBusiness,
        FSearchHistoryList);
end;

procedure TFrameSearchGoods.btnReturnClick(Sender: TObject);
begin
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameSearchGoods.btnSearchClick(Sender: TObject);
begin
  HideVirtualKeyboard;

  //隐藏
  HideFrame;//(Self,hfcttBeforeShowFrame);
  //补货
  ShowFrame(TFrame(GlobalGoodsListFrame),TFrameGoodsList,frmMain,nil,nil,nil,Application);
//  GlobalGoodsListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalGoodsListFrame.Load(Self.edtSearch.Text,Self.FFieldFID,FIsDoBusiness,FShop);

  //跳转搜索页面

    if (Trim(Self.edtSearch.Text)<>'')
    and (FSearchHistoryList.IndexOf(Self.edtSearch.Text)=-1) then
  begin
    //添加到搜索历史
    FSearchHistoryList.Insert(0,Self.edtSearch.Text);
    //保存
    GlobalManager.SaveUserConfig;
//    Load(Self.edtSearch.Prop.HelpText,
//          FSearchType,
//          FSearchHistoryList);

  end;
end;

procedure TFrameSearchGoods.Load(ACaption, ASearchType: String;AShop:TShop;
  AFiledFID:Integer;AIsDoBusiness:Boolean;ASearchHistoryList: TStringList);
var
  I: Integer;
  AListViewItem:TSkinListViewItem;
begin
  Self.edtSearch.Prop.HelpText:=ACaption;
  FSearchType:=ASearchType;
  FSearchHistoryList:=ASearchHistoryList;
  FFieldFID:=AFiledFID;
  Self.FIsDoBusiness:=AIsDoBusiness;

  FShop:=AShop;

  Self.edtSearch.Text:='';

  Self.lvSearchHistory.Prop.Items.BeginUpdate;
  try
    Self.lvSearchHistory.Prop.Items.ClearItemsByType(sitDefault);

    for I := 0 to FSearchHistoryList.Count-1 do
    begin

      AListViewItem:=Self.lvSearchHistory.Prop.Items.Insert(I+1);
      AListViewItem.Caption:=FSearchHistoryList[I];

    end;

    Self.lvSearchHistory.Prop.Items.FindItemByType(sitItem1).Visible:=
      FSearchHistoryList.Count=0;

    Self.lvSearchHistory.Prop.Items.FindItemByType(sitFooter).Visible:=
      FSearchHistoryList.Count>0;

  finally
    Self.lvSearchHistory.Prop.Items.EndUpdate();
  end;
end;

procedure TFrameSearchGoods.lvSearchHistoryClickItem(AItem: TSkinItem);
begin
  if AItem.ItemType=sitDefault then
  begin
    Self.edtSearch.Text:=AItem.Caption;
    btnSearchClick(Self);
  end;
end;

end.


