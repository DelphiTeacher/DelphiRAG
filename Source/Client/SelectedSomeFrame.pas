unit SelectedSomeFrame;

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


  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uDrawCanvas;

type
  TFrameSelectedSome = class(TFrame)
    pnlTop: TSkinFMXPanel;
    btnCancle: TSkinFMXButton;
    btnOk: TSkinFMXButton;
    lblName: TSkinFMXLabel;
    pnlList: TSkinFMXPanel;
    lbParent: TSkinFMXListBox;
    lbChilds: TSkinFMXListBox;
    idpItem1: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    pnlBankGroud: TSkinFMXPanel;
    procedure lbParentClickItem(AItem: TSkinItem);
    procedure lbChildsClickItem(AItem: TSkinItem);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancleClick(Sender: TObject);
    procedure pnlBankGroudClick(Sender: TObject);
  private
    { Private declarations }
  public
    FSelectedCaption:String;
    FSelectedDetail:String;

    FSelectedFID:Integer;

    FSelectedName:String;
    //清空
    procedure Clear;
    //加载
    procedure Init(AName:String;
                   AStringList1:TStringList;
                   AGoodClassList:TGoodClassList);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalSelectedSomeFrame:TFrameSelectedSome;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame;

{ TFrameSelectedSome }

procedure TFrameSelectedSome.btnCancleClick(Sender: TObject);
begin
  Self.FSelectedCaption:='';
  Self.FSelectedDetail:='';
  Self.FSelectedFID:=0;
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameSelectedSome.btnOkClick(Sender: TObject);
var
  ALbParentISSelect:Boolean;
  I: Integer;
begin

  ALbParentISSelect:=False;

  for I := 0 to Self.lbParent.Prop.Items.Count-1 do
  begin
    if Self.lbParent.Prop.Items[I].Selected=True then
    begin
      ALbParentISSelect:=True;
      Self.FSelectedCaption:=Self.lbParent.Prop.Items[I].Caption;
    end;
  end;

  for I := 0 to Self.lbChilds.Prop.Items.Count-1 do
  begin
    if Self.lbChilds.Prop.Items[I].Selected=True then
    begin
      Self.FSelectedDetail:=Self.lbChilds.Prop.Items[I].Caption;
      Self.FSelectedName:=Self.lbChilds.Prop.Items[I].Name;
    end;
  end;

  if Self.lblName.Caption='物品类型' then
  begin
    if ALbParentISSelect=False then
    begin
      ShowMessageBoxFrame(Self,'请选择物品类型!','',TMsgDlgType.mtInformation,['确定'],nil);
      Exit;
    end;
  end;
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameSelectedSome.Clear;
begin
  Self.lblName.Caption:='';

  FSelectedCaption:='';
  FSelectedDetail:='';

  Self.lbParent.Prop.Items.Clear(True);
  Self.lbChilds.Prop.Items.Clear(True);
end;

constructor TFrameSelectedSome.Create(AOwner: TComponent);
begin
  inherited;
  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;


destructor TFrameSelectedSome.Destroy;
begin

  inherited;
end;

procedure TFrameSelectedSome.Init(AName: String; AStringList1: TStringList;
                                  AGoodClassList:TGoodClassList);
var
  I: Integer;
  J: Integer;
  AListBoxItem:TSkinListBoxItem;
  AHourTime:String;
  AMinites:Double;
  ANumber:Integer;
begin

  Clear;

  Self.lblName.Caption:=AName;

  if AStringList1<>nil then
  begin
    try
      Self.lbParent.Prop.Items.Clear(True);

      Self.lbParent.Prop.Items.BeginUpdate;
      for I := 0 to AStringList1.Count-1 do
      begin
        AListBoxItem:=Self.lbParent.Prop.Items.Add;
        AListBoxItem.Caption:=AStringList1[I];
        if AName='取件时间' then
        begin
          if I=0 then
          begin
            AListBoxItem.Selected:=True;
            FSelectedCaption:=AStringList1[I];
          end;
        end;

      end;
    finally
      Self.lbParent.Prop.Items.EndUpdate();
    end;
  end;


  if AGoodClassList<>nil then
  begin
    try
      Self.lbParent.Prop.Items.Clear(True);

      Self.lbParent.Prop.Items.BeginUpdate;
      for I := 0 to AGoodClassList.Count-1 do
      begin
        AListBoxItem:=Self.lbParent.Prop.Items.Add;
        AListBoxItem.Data:=AGoodClassList[I];
        AListBoxItem.Caption:=AGoodClassList[I].name;
        AListBoxItem.Detail6:=IntToStr(AGoodClassList[I].fid);

        FSelectedCaption:='';


      end;
    finally
      Self.lbParent.Prop.Items.EndUpdate();
    end;
  end;


  try
    Self.lbChilds.Prop.Items.Clear(True);

    Self.lbChilds.Prop.Items.BeginUpdate;

    if AName='取件时间' then
    begin
      AListBoxItem:=Self.lbChilds.Prop.Items.Add;
      AListBoxItem.Caption:='立即取件';
      AListBoxItem.Selected:=True;

      AHourTime:=FormatDateTime('HH',Now);
      for I := 0 to 23-StrToInt(AHourTime)-1 do
      begin
        AHourTime:=IntToStr(StrToInt(AHourTime)+1);
        if StrToInt(AHourTime)<=23 then
        begin
          AMinites:=10;
          for J := 0 to 4 do
          begin
            AListBoxItem:=Self.lbChilds.Prop.Items.Add;
            AListBoxItem.Caption:=AHourTime+':'+FloatToStr(AMinites);
            AMinites:=AMinites+10;
          end;
        end;
      end;
    end;

    if AName='物品类型' then
    begin
      AListBoxItem:=Self.lbChilds.Prop.Items.Add;
      AListBoxItem.Caption:='小于5kg';
      AListBoxItem.Name:='2.5';
      AListBoxItem.Selected:=True;
      ANumber:=5;
      for I := 0 to 15 do
      begin
        AListBoxItem:=Self.lbChilds.Prop.Items.Add;
        AListBoxItem.Caption:=IntToStr(ANumber)+'kg';
        AListBoxItem.Name:=IntToStr(ANumber);
        ANumber:=ANumber+1;
      end;
    end;


  finally
    Self.lbChilds.Prop.Items.EndUpdate();
  end;


end;

procedure TFrameSelectedSome.lbChildsClickItem(AItem: TSkinItem);
begin
  FSelectedDetail:=AItem.Caption;

  FSelectedName:=AItem.Name;
  AItem.Selected:=True;
end;


procedure TFrameSelectedSome.lbParentClickItem(AItem: TSkinItem);
var
  I: Integer;
  J:Integer;
  AListBoxItem:TSkinListBoxItem;
  AHourTime:String;
  AMinites:Integer;
  ANumber:Integer;
begin
  FSelectedCaption:=AItem.Caption;
  AItem.Selected:=True;
  if Self.lblName.Caption='物品类型' then
  begin
    FSelectedFID:=StrToInt(AItem.Detail6);
  end;

  Self.lbChilds.Prop.Items.BeginUpdate;
  try
     if AItem.Caption='明天' then
     begin
        Self.lbChilds.Prop.Items.Clear(True);
        AHourTime:='00';
        for I := 0 to 23 do
        begin
          if StrToInt(AHourTime)<=23 then
          begin
            AMinites:=10;
            for J := 0 to 4 do
            begin
              AListBoxItem:=Self.lbChilds.Prop.Items.Add;
              AListBoxItem.Caption:=AHourTime+':'+FloatToStr(AMinites);
              if (I=0) and (J=0) then
              begin
                AListBoxItem.Selected:=True;
              end;
              AMinites:=AMinites+10;
            end;
          end;
          if (StrToInt(AHourTime)+1)<10 then
          begin
            AHourTime:='0'+IntToStr(StrToInt(AHourTime)+1);
          end
          else
          begin
            AHourTime:=IntToStr(StrToInt(AHourTime)+1);
          end;

        end;
     end;


     if AItem.Caption='今天' then
     begin
        Self.lbChilds.Prop.Items.Clear(True);
        AListBoxItem:=Self.lbChilds.Prop.Items.Add;
        AListBoxItem.Caption:='立即取件';
        AListBoxItem.Selected:=True;
        AHourTime:=FormatDateTime('HH',Now);
        for I := 0 to 23-StrToInt(AHourTime)-1 do
        begin
          AHourTime:=IntToStr(StrToInt(AHourTime)+1);
          if StrToInt(AHourTime)<=23 then
          begin
            AMinites:=10;
            for J := 0 to 4 do
            begin
              AListBoxItem:=Self.lbChilds.Prop.Items.Add;
              AListBoxItem.Caption:=AHourTime+':'+FloatToStr(AMinites);
              AMinites:=AMinites+10;
            end;
          end;
        end;
     end;

  finally
    Self.lbChilds.Prop.Items.EndUpdate();
  end;

end;

procedure TFrameSelectedSome.pnlBankGroudClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

end.
