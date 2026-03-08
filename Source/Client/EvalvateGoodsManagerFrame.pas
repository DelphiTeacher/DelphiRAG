unit EvalvateGoodsManagerFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  SelectPictureFrame,

  System.StrUtils,
  System.IOUtils,
  uSkinListViewType,
  uSkinListBoxType,
  Math,
  uSkinBufferBitmap,
  uOpenClientCommon,
  uOpenCommon,
  uFrameContext,

  uDrawTextParam,

  uBaseList,
  uManager,
//  uOpenClientCommon,
  uTimerTask,
  uUIFunction,
  XSuperObject,
  XSuperJson,
  uAPPCommon,

  MessageBoxFrame,
  WaitingFrame,
  EasyServiceCommonMaterialDataMoudle,


  uBaseHttpControl,
  uRestInterfaceCall,
//  uCommonUtils,
  uFuncCommon,
  uSkinItems,

  IDURI,
  HzSpell,

//  uOpenCommon,

  uSkinRadioButtonType, uSkinFireMonkeyRadioButton, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyMemo, uSkinCheckBoxType,
  uSkinFireMonkeyCheckBox, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinFireMonkeyControl, uSkinPanelType, uSkinFireMonkeyPanel, FMX.Memo.Types;

type
  TFrameEvalveteGoodsManager = class(TFrame)
    pnlContent: TSkinFMXPanel;
    pnlTopic: TSkinFMXPanel;
    lblName: TSkinFMXLabel;
    pnlEvalist: TSkinFMXPanel;
    cbEv1: TSkinFMXCheckBox;
    cbEv2: TSkinFMXCheckBox;
    cbEv3: TSkinFMXCheckBox;
    cbEv4: TSkinFMXCheckBox;
    cbEv5: TSkinFMXCheckBox;
    cbEv6: TSkinFMXCheckBox;
    memoAdd: TSkinFMXMemo;
    pnlGoods: TSkinFMXPanel;
    rbEvalvate3: TSkinFMXRadioButton;
    rbEvalvate2: TSkinFMXRadioButton;
    rbEvalvate1: TSkinFMXRadioButton;
    lblGoodsName: TSkinFMXLabel;
    pnlPic: TSkinFMXPanel;
    lblAddPic: TSkinFMXLabel;
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
    //订单FID
    FOrderFID:Integer;
    FRiderFID:String;
    //店铺FID
    FShopFID:Integer;
    //商品FID
    FGoodFID:Integer;

    //是否第一次
    FIsFirst:Boolean;

    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure AutoSize;
    //清空
    procedure Clear;
  public
    FSelectPictureFrame:TFrameSelectPicture;
    procedure Load(ACaption:String;
                   ANames:TStringArray;
                   AUrls:TStringArray;
                   AOrderFID:Integer;
                   AShopFID:Integer;
                   ARiderFID:String;
                   AGoodFID:Integer;
                   AIsFirst:Boolean);
    //检测输入是否正确
    function CheckInputIsOK:Boolean;

    //拼成Json
    function GetObjectJson:ISuperObject;
    { Public declarations }
  end;

var
  GlobalEvalvateGoodsManagerFrame:TFrameEvalveteGoodsManager;

implementation

{$R *.fmx}
uses
  EvalvateFrame;

{ TFrameEvalveteGoodsManager }

procedure TFrameEvalveteGoodsManager.AutoSize;
var
  AHeight:Double;
begin

  AHeight:=0;

  AHeight:=AHeight+Self.pnlTopic.Height+Self.pnlGoods.Height+Self.pnlEvalist.Height+Self.memoAdd.Height
                  +Self.pnlPic.Height+90;

  Self.pnlContent.Height:=AHeight;

  Self.Height:=AHeight+10;

end;

procedure TFrameEvalveteGoodsManager.cbEv1Click(Sender: TObject);
begin
  Self.cbEv1.Prop.Checked:=Not Self.cbEv1.Prop.Checked;
end;

procedure TFrameEvalveteGoodsManager.cbEv2Click(Sender: TObject);
begin
  Self.cbEv2.Prop.Checked:=Not Self.cbEv2.Prop.Checked;
end;

procedure TFrameEvalveteGoodsManager.cbEv3Click(Sender: TObject);
begin
  Self.cbEv3.Prop.Checked:=Not Self.cbEv3.Prop.Checked;
end;

procedure TFrameEvalveteGoodsManager.cbEv4Click(Sender: TObject);
begin
  Self.cbEv4.Prop.Checked:=Not Self.cbEv4.Prop.Checked;
end;

procedure TFrameEvalveteGoodsManager.cbEv5Click(Sender: TObject);
begin
  Self.cbEv5.Prop.Checked:=Not Self.cbEv5.Prop.Checked;
end;

procedure TFrameEvalveteGoodsManager.cbEv6Click(Sender: TObject);
begin
  Self.cbEv6.Prop.Checked:=Not Self.cbEv6.Prop.Checked;
end;

function TFrameEvalveteGoodsManager.CheckInputIsOK: Boolean;
begin
  Result:=False;

  if (Self.rbEvalvate1.Prop.Checked=False)
      and (Self.rbEvalvate2.Prop.Checked=False)
      and (Self.rbEvalvate3.Prop.Checked=False) then
  begin
    ShowMessageBoxFrame(Application.MainForm,'请选择满意程度!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

//  if (Self.cbEv1.Prop.Checked=False)
//      and (Self.cbEv2.Prop.Checked=False)
//      and (Self.cbEv3.Prop.Checked=False)
//      and (Self.cbEv4.Prop.Checked=False)
//      and (Self.cbEv5.Prop.Checked=False)
//      and (Self.cbEv6.Prop.Checked=False) then
//  begin
//    ShowMessageBoxFrame(Application.MainForm,'请选择评价语!','',TMsgDlgType.mtInformation,['确定'],nil);
//    Exit;
//  end;

  Result:=True;
end;

procedure TFrameEvalveteGoodsManager.Clear;
begin
  Self.lblGoodsName.Caption:='';


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
  FRiderFID:='0';
  FShopFID:=0;
  FGoodFID:=0;

  Self.lblBad.Visible:=False;

  Self.lblOrdinary.Visible:=False;
  Self.lblSatisfied.Visible:=False;

end;

constructor TFrameEvalveteGoodsManager.Create(AOwner: TComponent);
begin
  inherited;

  //选择商品图片
  FSelectPictureFrame:=TFrameSelectPicture.Create(Self);
  FSelectPictureFrame.Parent:=Self.pnlContent;
  FSelectPictureFrame.Align:=TAlignLayout.Top;
  FSelectPictureFrame.Margins.Top:=10;
  FSelectPictureFrame.Position.Y:=
    Self.pnlPic.Position.Y
    +Self.pnlPic.Height
    -1;

  FIsFirst:=False;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  TSkinRadioButtonColorMaterial(Self.rbIsAnonymous.SelfOwnMaterialToDefault).DrawCheckStateParam.FillColor.Color:=SkinThemeColor;
  TSkinRadioButtonColorMaterial(Self.rbIsAnonymous.SelfOwnMaterialToDefault).DrawCheckRectParam.DrawEffectSetting.PushedEffect.BorderColor.Color:=SkinThemeColor;

  {$IFDEF YC}
  Self.cbEv2.Caption:='未过期';
  {$ENDIF}
end;

destructor TFrameEvalveteGoodsManager.Destroy;
begin

  inherited;
end;

function TFrameEvalveteGoodsManager.GetObjectJson: ISuperObject;
var
  AGoodObject:ISuperObject;
  AStringList:TStringList;
  APicUploadSucc:Boolean;
  AServerResponseDesc:String;
begin
  Result:=nil;
  //FMX.Types.Log.d('OrangeUI --GetObjectJson- 1');
  AGoodObject:=TSuperObject.Create;
  AGoodObject.S['evaluate_type']:=Const_EvaluateType_UserEvaluateGoods;
  //FMX.Types.Log.d('OrangeUI --GetObjectJson- 2');
  if Self.rbIsAnonymous.Prop.Checked=True then
  begin
    AGoodObject.I['is_anonymous']:=1;
  end
  else
  begin
    AGoodObject.I['is_anonymous']:=0;
  end;
  //FMX.Types.Log.d('OrangeUI --GetObjectJson- 3');
  AGoodObject.S['from_fid']:=GlobalManager.User.fid;

  AGoodObject.I['order_fid']:=FOrderFID;

  AGoodObject.S['order_type']:='shop_center';
  AGoodObject.I['to_fid']:=FShopFID;
  AGoodObject.I['to_sub_fid']:=FGoodFID;
  //FMX.Types.Log.d('OrangeUI --GetObjectJson- 4');
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
  //FMX.Types.Log.d('OrangeUI --GetObjectJson- 5');
  AGoodObject.F['max_score']:=5;


  //节省空间
  if Self.memoAdd.Text<>'' then
  begin
    AGoodObject.S['content']:=Self.memoAdd.Text;
  end;


  try
    AStringList:=TStringList.Create;
    //FMX.Types.Log.d('OrangeUI --GetObjectJson- 6');
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
    //FMX.Types.Log.d('OrangeUI --GetObjectJson- 7');
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
    //FMX.Types.Log.d('OrangeUI --GetObjectJson- 8');
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

    //FMX.Types.Log.d('OrangeUI --GetObjectJson- 9');
    AGoodObject.S['tags']:=AStringList.CommaText;


    //不能放在这里,这里是线程调用的,保存成本地文件会报错
//    //图片
//    Self.FSelectPictureFrame.SaveToLocalTemp(100,'.jpg');



    //FMX.Types.Log.d('OrangeUI --GetObjectJson- 10');
    APicUploadSucc:=Self.FSelectPictureFrame.Upload(
                             ImageHttpServerUrl+'/upload'
                             +'?appid='+(AppID)
                             +'&filename='+'%s'
                             +'&filedir='+'Evaluate_Pic'
                             +'&fileext='+'.jpg',
                             AServerResponseDesc
                            );
    //FMX.Types.Log.d('OrangeUI --GetObjectJson- 11');
    //图片上传成功
    if (APicUploadSucc=True) then
    begin
      AGoodObject.S['pic1_path']:=Self.FSelectPictureFrame.GetServerFileNameArray(4)[0];
      if Self.FSelectPictureFrame.GetServerFileNameArray(4)[1]<>'' then
      begin
        AGoodObject.S['pic2_path']:=Self.FSelectPictureFrame.GetServerFileNameArray(4)[1];
      end;
      if Self.FSelectPictureFrame.GetServerFileNameArray(4)[2]<>'' then
      begin
        AGoodObject.S['pic3_path']:=Self.FSelectPictureFrame.GetServerFileNameArray(4)[2];
      end;

    end;
    //FMX.Types.Log.d('OrangeUI --GetObjectJson- 12');
  finally
    FreeAndNil(AStringList);
  end;

  Result:=AGoodObject;
end;

procedure TFrameEvalveteGoodsManager.Load(ACaption:String;
                                          ANames, AUrls: TStringArray;
                                          AOrderFID:Integer;
                                          AShopFID:Integer;
                                          ARiderFID:String;
                                          AGoodFID:Integer;
                                          AIsFirst:Boolean);
begin

  Clear;

  FOrderFID:=AOrderFID;
  FRiderFID:=ARiderFID;
  FShopFID:=AShopFID;
  FGoodFID:=AGoodFID;

  Self.pnlTopic.Visible:=AIsFirst;


  Self.lblGoodsName.Caption:=ACaption;


  FSelectPictureFrame.Init(ANames,AUrls,False,0,0,3,False,False,'');


  //默认要打上星星为满意
  Self.rbEvalvate1.Prop.Checked:=True;


  AutoSize;
end;

procedure TFrameEvalveteGoodsManager.pnlEvalistResize(Sender: TObject);
var
    AWidth:Double;
begin
  Self.cbEv1.Position.X:=10;

  Self.cbEv2.Position.X:=Self.cbEv1.Position.X+Self.cbEv1.Width+10;
  Self.cbEv2.Position.Y:=Self.cbEv1.Position.Y;

  Self.cbEv3.Position.X:=Self.cbEv2.Position.X+Self.cbEv2.Width+10;
  Self.cbEv3.Position.Y:=Self.cbEv2.Position.Y;
  AWidth:=Self.Width-Self.cbEv3.Position.X-Self.cbEv3.Width-10;

  if (Self.Width-AWidth-10-10)<Self.cbEv4.Width then
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


procedure TFrameEvalveteGoodsManager.rbEvalvate1Click(Sender: TObject);
begin
  Self.rbEvalvate1.Prop.Checked:=True;

  Self.lblBad.Visible:=False;

  Self.lblOrdinary.Visible:=False;
  Self.lblSatisfied.Visible:=True;

end;

procedure TFrameEvalveteGoodsManager.rbEvalvate2Click(Sender: TObject);
begin
  Self.rbEvalvate2.Prop.Checked:=True;

  Self.lblBad.Visible:=False;

  Self.lblOrdinary.Visible:=True;
  Self.lblSatisfied.Visible:=False;

end;

procedure TFrameEvalveteGoodsManager.rbEvalvate3Click(Sender: TObject);
begin
  Self.rbEvalvate3.Prop.Checked:=True;

  Self.lblBad.Visible:=True;

  Self.lblOrdinary.Visible:=False;
  Self.lblSatisfied.Visible:=False;

end;

procedure TFrameEvalveteGoodsManager.rbIsAnonymousClick(Sender: TObject);
begin
  Self.rbIsAnonymous.Prop.Checked:=Not Self.rbIsAnonymous.Prop.Checked;
end;

end.
