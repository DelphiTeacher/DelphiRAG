unit BookableOrderTimeFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  System.DateUtils,

  uSkinItems,
  uUIFunction,

  MessageBoxFrame,
  Math,
  uManager,
  uOpenClientCommon,
  uFrameContext,

  uOpenCommon,

  uFuncCommon,
  uBaseList,

  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,

  uSkinBufferBitmap,

  XSuperObject,
  XSuperJson,


  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uDrawCanvas;

type
  TFrameBookableOrderTime = class(TFrame)
    pnlBankGroud: TSkinFMXPanel;
    pnlList: TSkinFMXPanel;
    lbParent: TSkinFMXListBox;
    lbChilds: TSkinFMXListBox;
    pnlTop: TSkinFMXPanel;
    lblName: TSkinFMXLabel;
    idpItem1: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    procedure pnlBankGroudClick(Sender: TObject);
    procedure lbParentClickItem(AItem: TSkinItem);
    procedure lbChildsClickItem(AItem: TSkinItem);
  private
    //配送耗时
    FDelivery_Time:Integer;
    { Private declarations }
  public
    //选中的参数
    FSelectedCaption:String;
    FSelectedDetail:String;

    //时间
    FWantArriveryTime:String;

    //日期
    FDateTime:String;
    //清空
    procedure Clear;
    //加载
    procedure Init(ADays:Integer;
                   ADelivery_Time:Integer;
                   AWantArriveryTime:String;
                   AMon_is_sale:Integer;
                   AMon_str_time:String;
                   AMon_end_time:String;
                   ATues_is_sale:Integer;
                   ATues_str_time:String;
                   ATues_end_time:String;
                   AWed_is_sale:Integer;
                   AWed_str_time:String;
                   AWed_end_time:String;
                   AThur_is_sale:Integer;
                   AThur_str_time:String;
                   AThur_end_time:String;
                   AFri_is_sale:Integer;
                   AFri_str_time:String;
                   AFri_end_time:String;
                   ASat_is_sale:Integer;
                   ASat_str_time:String;
                   ASat_end_time:String;
                   ASun_is_sale:Integer;
                   ASun_str_time:String;
                   ASun_end_time:String
                   );
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalBookableOrderTimeFrame:TFrameBookableOrderTime;

implementation

{$R *.fmx}

{ TFrameBookableOrderTime }

procedure TFrameBookableOrderTime.Clear;
begin
  FDelivery_Time:=0;

  FSelectedCaption:='';
  FSelectedDetail:='';

  FWantArriveryTime:='';

  FDateTime:=''; 
  
  Self.lbParent.Prop.Items.Clear(True);
  Self.lbChilds.Prop.Items.Clear(True);
end;

constructor TFrameBookableOrderTime.Create(AOwner: TComponent);
begin
  inherited;
  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameBookableOrderTime.Destroy;
begin

  inherited;
end;

procedure TFrameBookableOrderTime.Init(ADays:Integer;
                                       ADelivery_Time:Integer;
                                       AWantArriveryTime:String;
                                       AMon_is_sale:Integer;
                                       AMon_str_time:String;
                                       AMon_end_time:String;
                                       ATues_is_sale:Integer;
                                       ATues_str_time:String;
                                       ATues_end_time:String;
                                       AWed_is_sale:Integer;
                                       AWed_str_time:String;
                                       AWed_end_time:String;
                                       AThur_is_sale:Integer;
                                       AThur_str_time:String;
                                       AThur_end_time:String;
                                       AFri_is_sale:Integer;
                                       AFri_str_time:String;
                                       AFri_end_time:String;
                                       ASat_is_sale:Integer;
                                       ASat_str_time:String;
                                       ASat_end_time:String;
                                       ASun_is_sale:Integer;
                                       ASun_str_time:String;
                                       ASun_end_time:String
                                       );
var
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
  AString:String;
  AStratDateTime:TDateTime;
  AStartHour:String;
  AEndHour:String;
  J: Integer;
  ADateTime:TDateTime;
  AMinites:Double;
  ASameText:String;
begin
  Clear;

  FDelivery_Time:=ADelivery_Time;

  FWantArriveryTime:=AWantArriveryTime;
  //加载预定天数
  Self.lbParent.Prop.Items.BeginUpdate;
  try
    for I := 0 to ADays do
    begin

      AString:='';

      if I=0 then
      begin
        AString:='今天';
      end
      else if I=1 then
      begin
        AString:='明天';
      end
      else
      begin
        AString:=FormatDateTime('MM-DD',Now);
      end;

      case DayOfWeek(Now+I) of
        1:
        if ASun_is_sale=1 then
        begin
          AListBoxItem:=Self.lbParent.Prop.Items.Add;
          AListBoxItem.Caption:=AString+'(周日)';
          AListBoxItem.Detail:=FormatDateTime('YYYY-MM-DD',Now+I);
          AListBoxItem.Detail5:=ASun_str_time;
          AListBoxItem.Detail6:=ASun_end_time;
        end;

        2:
        if AMon_is_sale=1 then
        begin
          AListBoxItem:=Self.lbParent.Prop.Items.Add;
          AListBoxItem.Caption:=AString+'(周一)';
          AListBoxItem.Detail:=FormatDateTime('YYYY-MM-DD',Now+I);
          AListBoxItem.Detail5:=AMon_str_time;
          AListBoxItem.Detail6:=AMon_end_time;
        end;

        3:
        if ATues_is_sale=1 then
        begin
          AListBoxItem:=Self.lbParent.Prop.Items.Add;
          AListBoxItem.Caption:=AString+'(周二)';
          AListBoxItem.Detail:=FormatDateTime('YYYY-MM-DD',Now+I);
          AListBoxItem.Detail5:=ATues_str_time;
          AListBoxItem.Detail6:=ATues_end_time;
        end;

        4:
        if AWed_is_sale=1 then
        begin
          AListBoxItem:=Self.lbParent.Prop.Items.Add;
          AListBoxItem.Caption:=AString+'(周三)';
          AListBoxItem.Detail:=FormatDateTime('YYYY-MM-DD',Now+I);
          AListBoxItem.Detail5:=AWed_str_time;
          AListBoxItem.Detail6:=AWed_end_time;
        end;

        5:
        if AThur_is_sale=1 then
        begin
          AListBoxItem:=Self.lbParent.Prop.Items.Add;
          AListBoxItem.Caption:=AString+'(周四)';
          AListBoxItem.Detail:=FormatDateTime('YYYY-MM-DD',Now+I);
          AListBoxItem.Detail5:=AThur_str_time;
          AListBoxItem.Detail6:=AThur_end_time;
        end;

        6:
        if AFri_is_sale=1 then
        begin
          AListBoxItem:=Self.lbParent.Prop.Items.Add;
          AListBoxItem.Caption:=AString+'(周五)';
          AListBoxItem.Detail:=FormatDateTime('YYYY-MM-DD',Now+I);
          AListBoxItem.Detail5:=AFri_str_time;
          AListBoxItem.Detail6:=AFri_end_time;
        end;

        7:
        if ASat_is_sale=1 then
        begin
          AListBoxItem:=Self.lbParent.Prop.Items.Add;
          AListBoxItem.Caption:=AString+'(周六)';
          AListBoxItem.Detail:=FormatDateTime('YYYY-MM-DD',Now+I);
          AListBoxItem.Detail5:=ASat_str_time;
          AListBoxItem.Detail6:=ASat_end_time;
        end;

      end;

    end;

  finally
    Self.lbParent.Prop.Items.EndUpdate();
  end;


  for I := 0 to Self.lbParent.Prop.Items.Count-1 do
  begin
    if Self.lbParent.Prop.Items[I].Detail=FormatDateTime('YYYY-MM-DD',StandardStrToDateTime(AWantArriveryTime)) then
    begin
      Self.lbParent.Prop.Items[I].Selected:=True;
      Self.FSelectedCaption:=Self.lbParent.Prop.Items[I].Caption;
      Self.FDateTime:=FormatDateTime('YYYY-MM-DD',StandardStrToDateTime(AWantArriveryTime));

    end;
  end;




  //加载预定具体时间
  Self.lbChilds.Prop.Items.BeginUpdate;
  try

    if FormatDateTime('YYYY-MM-DD',IncMinute(Now,ADelivery_Time))=FormatDateTime('YYYY-MM-DD',StandardStrToDateTime(AWantArriveryTime)) then
    begin

      AListBoxItem:=Self.lbChilds.Prop.Items.Add;
      AListBoxItem.Caption:='预计时间'+FormatDateTime('HH:MM',IncMinute(Now,ADelivery_Time));
      AListBoxItem.Detail:=FormatDateTime('HH:MM',IncMinute(Now,ADelivery_Time));
      AListBoxItem.Selected:=True;
      Self.FSelectedDetail:=FormatDateTime('HH:MM',IncMinute(Now,ADelivery_Time));

      ADateTime:=IncMinute(Now,ADelivery_Time);

      AStratDateTime:=StandardStrToDateTime(Self.lbParent.Prop.Items[0].Detail6);

      AEndHour:=FormatDateTime('HH',AStratDateTime);
      AStartHour:=FormatDateTime('HH',IncMinute(Now,ADelivery_Time));
    end
    else
    begin

      AStratDateTime:=StandardStrToDateTime(Self.lbParent.Prop.Items[0].Detail5);

      ADateTime:=AStratDateTime;

      AEndHour:=FormatDateTime('HH',StandardStrToDateTime(Self.lbParent.Prop.Items[0].Detail6));
      AStartHour:=FormatDateTime('HH',AStratDateTime);
    end;



    for I := 0 to 60-MinuteOf(ADateTime)-1 do
    begin
      if (StrToInt(FormatDateTime('HH',ADateTime))<(StrToInt(AStartHour)+1)) then
      begin
        if MinuteOf(ADateTime) mod 15=0 then
        begin

          if Self.lbChilds.Prop.Items.Count>0 then
          begin
            if Self.lbChilds.Prop.Items[0].Detail<>FormatDateTime('HH:MM',ADateTime) then
            begin
              AListBoxItem:=Self.lbChilds.Prop.Items.Add;
              AListBoxItem.Caption:=FormatDateTime('HH:MM',ADateTime);
              ADateTime:=IncMinute(ADateTime,15);
            end;
          end
          else
          begin
            AListBoxItem:=Self.lbChilds.Prop.Items.Add;
            AListBoxItem.Caption:=FormatDateTime('HH:MM',ADateTime);
            ADateTime:=IncMinute(ADateTime,15);
          end;

//          AListBoxItem:=Self.lbChilds.Prop.Items.Add;
//          AListBoxItem.Caption:=FormatDateTime('HH:MM',ADateTime);
//          ADateTime:=IncMinute(ADateTime,15);
        end
        else
        begin
          ADateTime:=IncMinute(ADateTime,1);
        end;
      end;

      if AListBoxItem.Caption=FormatDateTime('HH:MM',StandardStrToDateTime(AWantArriveryTime)) then
      begin
        AListBoxItem.Selected:=True;
        Self.FSelectedDetail:=FormatDateTime('HH:MM',StandardStrToDateTime(AWantArriveryTime));
      end;
    end;

    for I := StrToInt(AStartHour)+1 to StrToInt(AEndHour) do
    begin

      if StrToInt(AStartHour)<=23 then
      begin
        AStartHour:=(IntToStr(StrToInt(AStartHour)+1));
        AMinites:=0;
        for J := 0 to 3 do
        begin

          AListBoxItem:=Self.lbChilds.Prop.Items.Add;

          if AMinites=0 then
          begin
            AListBoxItem.Caption:=AStartHour+':'+FloatToStr(AMinites)+'0';
          end
          else
          begin
            AListBoxItem.Caption:=AStartHour+':'+FloatToStr(AMinites);
          end;

          if (AMinites+15)=60 then
          begin
            AMinites:=0;
          end
          else
          begin
            AMinites:=AMinites+15;
          end;

          if AListBoxItem.Caption=FormatDateTime('HH:MM',StandardStrToDateTime(AWantArriveryTime)) then
          begin
            AListBoxItem.Selected:=True;
            Self.FSelectedDetail:=FormatDateTime('HH:MM',StandardStrToDateTime(AWantArriveryTime));
          end;

        end;
      end;


    end;

  finally
    Self.lbChilds.Prop.Items.EndUpdate();
  end;



end;

procedure TFrameBookableOrderTime.lbChildsClickItem(AItem: TSkinItem);
var
  I: Integer;
begin
  //选择成功之后返回
  for I := 0 to Self.lbParent.Prop.Items.Count-1 do
  begin
    if Self.lbParent.Prop.Items[I].Selected=True then
    begin
      Self.FSelectedCaption:=Self.lbParent.Prop.Items[I].Caption;
      FDateTime:=Self.lbParent.Prop.Items[I].Detail;
    end;
  end;


  if AItem.Index<>0 then
  begin
    Self.FSelectedDetail:=AItem.Caption;
  end
  else
  begin
    Self.FSelectedDetail:=FormatDateTime('HH:MM',IncMinute(Now,FDelivery_Time));
  end;

  //返回
  HideFrame();
  ReturnFrame();
end;

procedure TFrameBookableOrderTime.lbParentClickItem(AItem: TSkinItem);
var
  AStartDateTime:TDateTime;
  AEndDateTime:TDateTime;
  ADateTime:TDateTime;
  AEndHour:String;
  AStartHour:String;
  I:Integer;
  J:Integer; 
  AListBoxItem:TSkinListBoxItem; 
  AMinites:Double;
  ASameText:String;
begin

  Self.lbChilds.Prop.Items.Clear(True);

  Self.lbChilds.Prop.Items.BeginUpdate;
  try

    AStartDateTime:=StandardStrToDateTime(AItem.Detail5);
    AEndDateTime:=StandardStrToDateTime(AItem.Detail6);

    AEndHour:=FormatDateTime('HH',AEndDateTime);

    if AItem.Index=0 then
    begin  
      AStartHour:=FormatDateTime('HH',IncMinute(Now,FDelivery_Time));

      AListBoxItem:=Self.lbChilds.Prop.Items.Add;
      AListBoxItem.Caption:='预计时间'+FormatDateTime('HH:MM',IncMinute(Now,FDelivery_Time));
      AListBoxItem.Detail:=FormatDateTime('HH:MM',IncMinute(Now,FDelivery_Time));
      ADateTime:=IncMinute(Now,FDelivery_Time);
      if AItem.Selected=True then
      begin
        AListBoxItem.Selected:=True;
      end;
//      AListBoxItem.Selected:=True;
    end
    else
    begin
      AStartHour:=FormatDateTime('HH',AStartDateTime);
      ADateTime:=AStartDateTime;    
    end;
   

    for I := 0 to 60-MinuteOf(ADateTime)-1 do
    begin
      if StrToInt(FormatDateTime('HH',ADateTime))<(StrToInt(AStartHour)+1) then
      begin
        if MinuteOf(ADateTime) mod 15=0 then
        begin

          if Self.lbChilds.Prop.Items.Count>0 then
          begin
            if Self.lbChilds.Prop.Items[0].Detail<>FormatDateTime('HH:MM',ADateTime) then
            begin
              AListBoxItem:=Self.lbChilds.Prop.Items.Add;
              AListBoxItem.Caption:=FormatDateTime('HH:MM',ADateTime);
              ADateTime:=IncMinute(ADateTime,15);
            end;
          end
          else
          begin
            AListBoxItem:=Self.lbChilds.Prop.Items.Add;
            AListBoxItem.Caption:=FormatDateTime('HH:MM',ADateTime);
            ADateTime:=IncMinute(ADateTime,15);
          end;
//          AListBoxItem:=Self.lbChilds.Prop.Items.Add;
//          AListBoxItem.Caption:=FormatDateTime('HH:MM',ADateTime);
//          ADateTime:=IncMinute(ADateTime,15);
        end
        else
        begin
          ADateTime:=IncMinute(ADateTime,1);
        end;
      end;
    end;

    for I := StrToInt(AStartHour)+1 to StrToInt(AEndHour) do
    begin
      AStartHour:=(IntToStr(StrToInt(AStartHour)+1));
      if StrToInt(AStartHour)<=23 then
      begin
        AMinites:=0;
        ASameText:='';
        for J := 0 to 3 do
        begin

          AListBoxItem:=Self.lbChilds.Prop.Items.Add;
          if AMinites=0 then
          begin
            AListBoxItem.Caption:=AStartHour+':'+FloatToStr(AMinites)+'0';
          end
          else
          begin
            AListBoxItem.Caption:=AStartHour+':'+FloatToStr(AMinites);
          end;


          if (AMinites+15)=60 then
          begin
            AMinites:=0;
          end
          else
          begin
            AMinites:=AMinites+15;
          end;

        end;
      end;


    end;    
  
  finally
    Self.lbChilds.Prop.Items.EndUpdate();
  end;


  for I := 0 to Self.lbChilds.Prop.Items.Count-1 do
  begin
    if AItem.Detail=FormatDateTime('YYYY-MM-DD',StandardStrToDateTime(Self.FWantArriveryTime)) then
    begin
      if FormatDateTime('HH:MM',IncMinute(Now,FDelivery_Time))=FormatDateTime('HH:MM',StandardStrToDateTime(FWantArriveryTime)) then
      begin
        Self.lbChilds.Prop.Items[0].Selected:=True;
      end
      else
      begin
        if Self.lbChilds.Prop.Items[I].Caption=FormatDateTime('HH:MM',StandardStrToDateTime(FWantArriveryTime)) then
        begin
          Self.lbChilds.Prop.Items[I].Selected:=True;
        end;
      end;

    end
    else
    begin
      Self.lbChilds.Prop.Items[I].Selected:=False;
    end;
  end;

end;

procedure TFrameBookableOrderTime.pnlBankGroudClick(Sender: TObject);
begin
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

  //返回
  HideFrame();
  ReturnFrame();
end;

end.

