unit EvalvateManagerFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  MessageBoxFrame,
  XSuperObject,
  uOpenClientCommon,
  uOpenCommon,

  uManager,
//  uOpenClientCommon,
  uUIFunction,
  uFrameContext,

//  uOpenCommon,

  SelectPictureFrame,

  uSkinFireMonkeyControl, uSkinPanelType, uSkinFireMonkeyPanel, uSkinButtonType,
  uSkinFireMonkeyButton, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinRadioButtonType, uSkinFireMonkeyRadioButton, uSkinCheckBoxType,
  uSkinFireMonkeyCheckBox, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, FMX.Memo.Types;

type
  TFrameEvalvateManager = class(TFrame)
    pnlContent: TSkinFMXPanel;
    pnlTopic: TSkinFMXPanel;
    lblName: TSkinFMXLabel;
    rbEvalvate1: TSkinFMXRadioButton;
    rbEvalvate3: TSkinFMXRadioButton;
    rbEvalvate2: TSkinFMXRadioButton;
    pnlEvalist: TSkinFMXPanel;
    cbEv1: TSkinFMXCheckBox;
    memoAdd: TSkinFMXMemo;
    cbEv2: TSkinFMXCheckBox;
    cbEv3: TSkinFMXCheckBox;
    cbEv4: TSkinFMXCheckBox;
    cbEv5: TSkinFMXCheckBox;
    cbEv6: TSkinFMXCheckBox;
    rbIsAnonymous: TSkinFMXRadioButton;
    lblBad: TSkinFMXLabel;
    lblOrdinary: TSkinFMXLabel;
    lblSatisfied: TSkinFMXLabel;
    procedure cbEv1Click(Sender: TObject);
    procedure cbEv2Click(Sender: TObject);
    procedure cbEv3Click(Sender: TObject);
    procedure cbEv4Click(Sender: TObject);
    procedure cbEv5Click(Sender: TObject);
    procedure cbEv6Click(Sender: TObject);
    procedure rbEvalvate3Click(Sender: TObject);
    procedure rbEvalvate2Click(Sender: TObject);
    procedure rbEvalvate1Click(Sender: TObject);
    procedure pnlEvalistResize(Sender: TObject);
    procedure rbIsAnonymousClick(Sender: TObject);
  private
    FOrderFID:Integer;
    FShopFID:String;
    FRiderFID:String;
    FGoodFID:Integer;

    //订单
    FOrder:TOrder;
  private
    FSelectPictureFrame:TFrameSelectPicture;
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
  public
    procedure AutoSize;
    procedure Load(ACaption:String;
                   AEvaString1:String;
                   AEvaString2:String;
                   AEvaString3:String;
                   AEvaString4:String;
                   AEvaString5:String;
                   AEvaString6:String;
                   AOrderFID:Integer;
                   AShopFID:String;
                   ARiderFID:String;
                   AGoodFID:Integer;
                   AOrder:TOrder);

    procedure Clear;

    procedure Edit(ACaption:String;
                   AScore:Double;
                   ATags:String;
                   AContent:String;
                   AIsAnonymous:Boolean);

    function CheckInputIsOK:Boolean;

    //拼成Json
    function GetObjectJson:ISuperObject;
    { Public declarations }
  end;

var
  GlobalEvalvateManagerFrame:TFrameEvalvateManager;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame,
  {$IFDEF CLIENT_APP}
  EvalvateGoodsManagerFrame,
  {$ENDIF}
  EvalvateFrame;


{ TFrameEvalvateManager }

procedure TFrameEvalvateManager.AutoSize;
var
  AHeight:Double;
begin
  AHeight:=0;

  AHeight:=AHeight+Self.pnlTopic.Height+Self.pnlEvalist.Height+Self.memoAdd.Height;

  Self.Height:=AHeight+15;
end;

procedure TFrameEvalvateManager.cbEv1Click(Sender: TObject);
begin
  Self.cbEv1.Prop.Checked:=Not Self.cbEv1.Prop.Checked;
end;

procedure TFrameEvalvateManager.cbEv2Click(Sender: TObject);
begin
  Self.cbEv2.Prop.Checked:=Not Self.cbEv2.Prop.Checked;
end;

procedure TFrameEvalvateManager.cbEv3Click(Sender: TObject);
begin
  Self.cbEv3.Prop.Checked:=Not Self.cbEv3.Prop.Checked;
end;

procedure TFrameEvalvateManager.cbEv4Click(Sender: TObject);
begin
  Self.cbEv4.Prop.Checked:=Not Self.cbEv4.Prop.Checked;
end;

procedure TFrameEvalvateManager.cbEv5Click(Sender: TObject);
begin
  Self.cbEv5.Prop.Checked:=Not Self.cbEv5.Prop.Checked;
end;

procedure TFrameEvalvateManager.cbEv6Click(Sender: TObject);
begin
  Self.cbEv6.Prop.Checked:=Not Self.cbEv6.Prop.Checked;
end;


function TFrameEvalvateManager.CheckInputIsOK: Boolean;
begin
  Result:=False;

  if (Self.rbEvalvate1.Prop.Checked=False) and (Self.rbEvalvate2.Prop.Checked=False)
      and (Self.rbEvalvate2.Prop.Checked=False) then
  begin
    ShowMessageBoxFrame(Application.MainForm,'请选择满意程度!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

//  if (Self.cbEv1.Prop.Checked=False) and (Self.cbEv2.Prop.Checked=False)
//      and (Self.cbEv3.Prop.Checked=False) and (Self.cbEv4.Prop.Checked=False)
//      and (Self.cbEv5.Prop.Checked=False) and (Self.cbEv6.Prop.Checked=False) then
//  begin
//    ShowMessageBoxFrame(Application.MainForm,'请选择评价语!','',TMsgDlgType.mtInformation,['确定'],nil);
//    Exit;
//  end;

  Result:=True;
end;

procedure TFrameEvalvateManager.Clear;
begin
  Self.lblName.Caption:='';

  Self.cbEv1.Caption:='';
  Self.cbEv2.Caption:='';
  Self.cbEv3.Caption:='';
  Self.cbEv4.Caption:='';
  Self.cbEv5.Caption:='';
  Self.cbEv6.Caption:='';

  Self.cbEv1.Prop.Checked:=False;
  Self.cbEv2.Prop.Checked:=False;
  Self.cbEv3.Prop.Checked:=False;
  Self.cbEv4.Prop.Checked:=False;
  Self.cbEv5.Prop.Checked:=False;
  Self.cbEv6.Prop.Checked:=False;

  Self.rbEvalvate1.Prop.Checked:=False;
  Self.rbEvalvate2.Prop.Checked:=False;
  Self.rbEvalvate3.Prop.Checked:=False;

  FOrderFID:=0;
  FShopFID:='0';
  FRiderFID:='0';
  FGoodFID:=0;

  Self.lblBad.Visible:=False;

  Self.lblOrdinary.Visible:=False;
  Self.lblSatisfied.Visible:=False;

end;

constructor TFrameEvalvateManager.Create(AOwner: TComponent);
begin
  inherited;
  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  TSkinRadioButtonColorMaterial(Self.rbIsAnonymous.SelfOwnMaterialToDefault).DrawCheckStateParam.FillColor.Color:=SkinThemeColor;
  TSkinRadioButtonColorMaterial(Self.rbIsAnonymous.SelfOwnMaterialToDefault).DrawCheckRectParam.DrawEffectSetting.PushedEffect.BorderColor.Color:=SkinThemeColor;
end;

procedure TFrameEvalvateManager.Edit(ACaption: String; AScore: Double; ATags,
  AContent: String;AIsAnonymous:Boolean);
var
  AStringList:TStringList;
  I: Integer;
begin

  Self.lblName.Caption:=ACaption;

  Self.rbIsAnonymous.Prop.Checked:=AIsAnonymous;

  if AScore=1 then
  begin
    Self.rbEvalvate3.Prop.Checked:=True;
    Self.lblName.Visible:=True;
  end
  else if AScore=3 then
  begin
    Self.rbEvalvate2.Prop.Checked:=True;
    Self.lblOrdinary.Visible:=True;
  end
  else
  begin
    Self.rbEvalvate1.Prop.Checked:=True;
    Self.lblSatisfied.Visible:=True;
  end;

  AStringList:=TStringList.Create;
  try
    AStringList.CommaText:=ATags;

    for I := 0 to AStringList.Count-1 do
    begin
      if AStringList[I]=Self.cbEv1.Caption then
      begin
        Self.cbEv1.Prop.Checked:=True;
      end;

      if AStringList[I]=Self.cbEv2.Caption then
      begin
        Self.cbEv2.Prop.Checked:=True;
      end;

      if AStringList[I]=Self.cbEv3.Caption then
      begin
        Self.cbEv3.Prop.Checked:=True;
      end;

      if AStringList[I]=Self.cbEv4.Caption then
      begin
        Self.cbEv4.Prop.Checked:=True;
      end;

      if AStringList[I]=Self.cbEv5.Caption then
      begin
        Self.cbEv5.Prop.Checked:=True;
      end;

      if AStringList[I]=Self.cbEv6.Caption then
      begin
        Self.cbEv6.Prop.Checked:=True;
      end;
    end;

  finally
    AStringList.Free;
  end;

  Self.memoAdd.Text:=AContent;

end;

function TFrameEvalvateManager.GetObjectJson: ISuperObject;
var
  AGoodObject:ISuperObject;
  AObject:ISuperObject;
  AObjectArray:ISuperArray;
  AStringList:TStringList;
  APicUploadSucc:Boolean;
  AServerResponseDesc:String;
  I: Integer;
begin
  Result:=nil;

  AGoodObject:=TSuperObject.Create;

  //客户端
  if APPUserType=utClient then
  begin
    if Self.lblName.Caption='评价商家服务' then
    begin
      AGoodObject.S['evaluate_type']:=Const_EvaluateType_UserEvaluateShop;
      AGoodObject.S['order_type']:='shop_center';

      AGoodObject.V['to_fid']:=FShopFID;



      if Self.FOrder<>nil then
      begin
         AObjectArray:=TSuperArray.Create;

        for I := 0 to FOrder.OrderGoodsList.Count-1 do
        begin
          AObject:=TSuperObject.Create;
          AObject.I['shop_goods_fid']:=FOrder.OrderGoodsList[I].shop_goods_fid;
          AObject.S['shop_goods_name']:=FOrder.OrderGoodsList[I].goods_name;

          AObjectArray.O[I]:=AObject;

        end;

         AGoodObject.S['user_custom_data']:=AObjectArray.AsJSON;
      end;



       {$IFDEF CLIENT_APP}
      if GlobalEvalvateFrame.FStringList.Count>0 then
      begin
        for I := 0 to GlobalEvalvateFrame.FStringList.Count-1 do
        begin
          if I=0 then
          begin
            AGoodObject.S['pic1_path']:=GlobalEvalvateFrame.FStringList[0];
          end;

          if I=1 then
          begin
            AGoodObject.S['pic2_path']:=GlobalEvalvateFrame.FStringList[1];
          end;

          if I=2 then
          begin
            AGoodObject.S['pic3_path']:=GlobalEvalvateFrame.FStringList[2];
          end;
        end;

      end
      else
      begin
        AGoodObject.S['pic1_path']:='';
        AGoodObject.S['pic2_path']:='';
        AGoodObject.S['pic3_path']:='';
      end;
      {$ENDIF}

      {$IFDEF SHOP_APP}
        AGoodObject.S['pic1_path']:='';
        AGoodObject.S['pic2_path']:='';
        AGoodObject.S['pic3_path']:='';
      {$ENDIF}

    end
    else
    begin
      AGoodObject.S['evaluate_type']:=Const_EvaluateType_UserEvaluateRider;
      AGoodObject.S['order_type']:='delivery_center';

      AGoodObject.V['to_fid']:=FRiderFID;

      AGoodObject.S['pic1_path']:='';
      AGoodObject.S['pic2_path']:='';
      AGoodObject.S['pic3_path']:='';

    end;

//    //图片
//    Self.FSelectPictureFrame.SaveToLocalTemp(100,'.jpg');
//
//
//    APicUploadSucc:=Self.FSelectPictureFrame.Upload(
//                             ImageHttpServerUrl+'/upload'
//                             +'?appid=1002'
//                             +'&filename'+'%s'
//                             +'&filedir='+'Evaluate_Pic'
//                             +'&fileext='+'.jpg',
//                             AServerResponseDesc
//                            );
//
//    //图片上传成功
//    if (APicUploadSucc=True) then
//    begin
//      AGoodObject.S['pic1_path']:=Self.FSelectPictureFrame.GetServerFileNameArray(4)[0];
//      AGoodObject.S['pic2_path']:=Self.FSelectPictureFrame.GetServerFileNameArray(4)[1];
//      AGoodObject.S['pic3_path']:=Self.FSelectPictureFrame.GetServerFileNameArray(4)[2];
//    end;



  end;

  //商家端
  if APPUserType=utShop then
  begin
    AGoodObject.S['evaluate_type']:=Const_EvaluateType_ShopEvaluateRider;
    AGoodObject.S['order_type']:='shop_center';

    AGoodObject.V['to_fid']:=FRiderFID;

    AGoodObject.S['pic1_path']:='';
    AGoodObject.S['pic2_path']:='';
    AGoodObject.S['pic3_path']:='';
  end;

  AGoodObject.I['to_sub_fid']:=FGoodFID;

  AGoodObject.S['from_fid']:=GlobalManager.User.fid;

  AGoodObject.I['order_fid']:=FOrderFID;

  if Self.rbIsAnonymous.Prop.Checked=True then
  begin
    AGoodObject.I['is_anonymous']:=1;
  end
  else
  begin
    AGoodObject.I['is_anonymous']:=0;
  end;


  if Self.rbEvalvate3.Prop.Checked=True then
  begin
    AGoodObject.F['score']:=1;
  end
  else if Self.rbEvalvate2.Prop.Checked=True then
  begin
    AGoodObject.F['score']:=3;
  end
  else if Self.rbEvalvate1.Prop.Checked=True then
  begin
    AGoodObject.F['score']:=5;
  end;

  AGoodObject.F['max_score']:=5;
  AGoodObject.S['content']:=Self.memoAdd.Text;

  try
    AStringList:=TStringList.Create;

    if Self.cbEv1.Prop.Checked=True then
    begin
      AStringList.Add(Self.cbEv1.Caption);
    end
    else
    begin
      if AStringList.IndexOf(Self.cbEv1.Caption)<>-1 then
      begin
        AStringList.Delete(AStringList.IndexOf(Self.cbEv1.Caption));
      end;
    end;

    if Self.cbEv2.Prop.Checked=True then
    begin
      AStringList.Add(Self.cbEv2.Caption);
    end
    else
    begin
      if AStringList.IndexOf(Self.cbEv2.Caption)<>-1 then
      begin
        AStringList.Delete(AStringList.IndexOf(Self.cbEv2.Caption));
      end;
    end;

    if Self.cbEv3.Prop.Checked=True then
    begin
      AStringList.Add(Self.cbEv3.Caption);
    end
    else
    begin
      if AStringList.IndexOf(Self.cbEv3.Caption)<>-1 then
      begin
        AStringList.Delete(AStringList.IndexOf(Self.cbEv3.Caption));
      end;
    end;

    if Self.cbEv4.Prop.Checked=True then
    begin
      AStringList.Add(Self.cbEv4.Caption);
    end
    else
    begin
      if AStringList.IndexOf(Self.cbEv4.Caption)<>-1 then
      begin
        AStringList.Delete(AStringList.IndexOf(Self.cbEv4.Caption));
      end;
    end;

    if Self.cbEv5.Prop.Checked=True then
    begin
      AStringList.Add(Self.cbEv5.Caption);
    end
    else
    begin
      if AStringList.IndexOf(Self.cbEv5.Caption)<>-1 then
      begin
        AStringList.Delete(AStringList.IndexOf(Self.cbEv5.Caption));
      end;
    end;

    if Self.cbEv6.Prop.Checked=True then
    begin
      AStringList.Add(Self.cbEv6.Caption);
    end
    else
    begin
      if AStringList.IndexOf(Self.cbEv6.Caption)<>-1 then
      begin
        AStringList.Delete(AStringList.IndexOf(Self.cbEv6.Caption));
      end;
    end;


    AGoodObject.S['tags']:=AStringList.CommaText;


  finally
    FreeAndNil(AStringList);
  end;


  Result:=AGoodObject;
end;

procedure TFrameEvalvateManager.Load(ACaption, AEvaString1, AEvaString2,
  AEvaString3, AEvaString4, AEvaString5, AEvaString6: String;
 AOrderFID:Integer;
 AShopFID:String;
 ARiderFID:String;
 AGoodFID:Integer;
 AOrder:TOrder);
begin

  Clear;

  FOrder:=AOrder;

  Self.lblName.Caption:=ACaption;


  FOrderFID:=AOrderFID;
  FShopFID:=AShopFID;
  FRiderFID:=ARiderFID;
  FGoodFID:=AGoodFID;

  Self.rbEvalvate1.Prop.Checked:=True;

  Self.cbEv1.Caption:=AEvaString1;
  Self.cbEv2.Caption:=AEvaString2;
  Self.cbEv3.Caption:=AEvaString3;
  Self.cbEv4.Caption:=AEvaString4;
  Self.cbEv5.Caption:=AEvaString5;
  Self.cbEv6.Caption:=AEvaString6;
end;

procedure TFrameEvalvateManager.pnlEvalistResize(Sender: TObject);
var
  AWidth:Double;
begin
  Self.cbEv1.Position.X:=10;

  Self.cbEv2.Position.X:=Self.cbEv1.Position.X+Self.cbEv1.Width+10;
  Self.cbEv2.Position.Y:=Self.cbEv1.Position.Y;

  Self.cbEv3.Position.X:=Self.cbEv2.Position.X+Self.cbEv2.Width+10;
  Self.cbEv3.Position.Y:=Self.cbEv2.Position.Y;

  if (Self.Width-Self.cbEv3.Position.X-Self.cbEv3.Width-10)<Self.cbEv4.Width then
  begin
    Self.cbEv4.Position.Y:=Self.cbEv1.Position.Y+Self.cbEv1.Height+6;
    Self.cbEv4.Position.X:=10;

    Self.cbEv5.Position.X:=Self.cbEv4.Position.X+Self.cbEv4.Width+10;
    Self.cbEv5.Position.Y:=Self.cbEv4.Position.Y;

    Self.cbEv6.Position.X:=Self.cbEv5.Position.X+Self.cbEv5.Width+10;
    Self.cbEv6.Position.Y:=Self.cbEv5.Position.Y;

    Self.pnlEvalist.Height:=80;
  end
  else
  begin
    Self.cbEv4.Position.X:=Self.cbEv3.Position.X+Self.cbEv3.Width+10;
    Self.cbEv4.Position.Y:=Self.cbEv1.Position.Y;

    if (Self.Width-Self.cbEv4.Position.X-Self.cbEv4.Width-10)<Self.cbEv5.Width then
    begin
      Self.cbEv5.Position.Y:=Self.cbEv1.Position.Y+Self.cbEv1.Height+6;
      Self.cbEv5.Position.X:=10;

      Self.cbEv6.Position.X:=Self.cbEv5.Position.X+Self.cbEv5.Width+10;
      Self.cbEv6.Position.Y:=Self.cbEv5.Position.Y;

      Self.pnlEvalist.Height:=80;

    end
    else
    begin
      Self.cbEv5.Position.X:=Self.cbEv4.Position.X+Self.cbEv4.Width+10;
      Self.cbEv5.Position.Y:=Self.cbEv1.Position.Y;

      if (Self.Width-Self.cbEv5.Position.X-Self.cbEv5.Width-10)<Self.cbEv6.Width then
      begin
        Self.cbEv6.Position.Y:=Self.cbEv1.Position.Y+Self.cbEv1.Height+6;
        Self.cbEv6.Position.X:=10;

        Self.pnlEvalist.Height:=80;
      end
      else
      begin
        Self.cbEv6.Position.X:=Self.cbEv5.Position.X+Self.cbEv5.Width+10;
        Self.cbEv6.Position.Y:=Self.cbEv1.Position.Y;

        Self.pnlEvalist.Height:=44;
      end;
    end;
  end;
end;

procedure TFrameEvalvateManager.rbEvalvate1Click(Sender: TObject);
begin
  Self.rbEvalvate1.Prop.Checked:=True;

  Self.lblBad.Visible:=False;

  Self.lblOrdinary.Visible:=False;
  Self.lblSatisfied.Visible:=True;
end;

procedure TFrameEvalvateManager.rbEvalvate2Click(Sender: TObject);
begin
  Self.rbEvalvate2.Prop.Checked:=True;

  Self.lblBad.Visible:=False;

  Self.lblOrdinary.Visible:=True;
  Self.lblSatisfied.Visible:=False;
end;

procedure TFrameEvalvateManager.rbEvalvate3Click(Sender: TObject);
begin
  Self.rbEvalvate3.Prop.Checked:=True;

  Self.lblBad.Visible:=True;

  Self.lblOrdinary.Visible:=False;
  Self.lblSatisfied.Visible:=False;
end;

procedure TFrameEvalvateManager.rbIsAnonymousClick(Sender: TObject);
begin
  Self.rbIsAnonymous.Prop.Checked:=Not Self.rbIsAnonymous.Prop.Checked;
end;

end.
