unit ShopUserInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  System.StrUtils,
  uBaseList,

  uManager,
  uDrawCanvas,
  uSkinItems,
  uFrameContext,

  uFuncCommon,

  uUIFunction,
  uSkinBufferBitmap,

  uDrawPicture,
  uOpenClientCommon,
  uViewPictureListFrame,


  uSkinFireMonkeyControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinFireMonkeyListBox,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinButtonType, uSkinFireMonkeyButton, uSkinPanelType,
  uSkinFireMonkeyPanel, uSkinImageType, uSkinFireMonkeyImage;

type
  TFrameShopUserInfo = class(TFrame)
    lbInfo: TSkinFMXListBox;
    idpItem: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    idpBtn: TSkinFMXItemDesignerPanel;
    btnCon: TSkinFMXButton;
    idpItem1: TSkinFMXItemDesignerPanel;
    lblName: TSkinFMXLabel;
    imgIn2: TSkinFMXImage;
    imgIn1: TSkinFMXImage;
    imgIn: TSkinFMXImage;
    imgDoor: TSkinFMXImage;
    lblNameValue: TSkinFMXLabel;
    procedure imgDoorClick(Sender: TObject);
  private
    FShowPic1:String;
    FShowPic2:String;
    FShowPic3:String;
    FShowPic4:String;

    Pic1:TDrawPicture;//"1.jpeg",
    Pic2:TDrawPicture;//"2.jpeg",
    Pic3:TDrawPicture;//"3.jpeg",
    Pic4:TDrawPicture;//"4.jpeg",

    PicList:TDrawPictureList;
    OriginPicUrlList:TStringList;
    { Private declarations }
  public
    //同一个界面共用  传进来的
    FGlobalShopInfoFrame:TFrame;
    //清空
    procedure Clear;
    //加载店铺详情
    procedure Init(AShop:TShop;AShopInfoFrame:TFrame);

  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalShopUserInfoFrame:TFrameShopUserInfo;

implementation

{$R *.fmx}

uses
  ShopInfoFrame,
  ViewPictureListFrame,
  MainFrame,
  MainForm;

{ TFrameShopUserInfo }

procedure TFrameShopUserInfo.Clear;
begin

  FShowPic1:='';
  FShowPic2:='';
  FShowPic3:='';
  FShowPic4:='';


  Self.lblNameValue.Caption:='';
  Self.imgDoor.Prop.Picture.Url:='';
  Self.imgIn.Prop.Picture.Url:='';
  Self.imgIn1.Prop.Picture.Url:='';
  Self.imgIn2.Prop.Picture.Url:='';
  Self.lbInfo.Prop.Items.FindItemByCaption('商家名称').Detail:='';
  Self.lbInfo.Prop.Items.FindItemByCaption('商家品类').Detail:='';
  Self.lbInfo.Prop.Items.FindItemByCaption('商家地址').Detail:='';
  Self.lbInfo.Prop.Items.FindItemByCaption('商家电话').Detail:='';
  Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:='';

end;

constructor TFrameShopUserInfo.Create(AOwner: TComponent);
begin
  inherited;
  Self.lbInfo.Prop.IsProcessGestureInScrollBox:=True;

  PicList:=TDrawPictureList.Create(ooReference);
  OriginPicUrlList:=TStringList.Create;

  Pic1:=TDrawPicture.Create('','');//"1.jpeg",
  Pic2:=TDrawPicture.Create('','');//"2.jpeg",
  Pic3:=TDrawPicture.Create('','');//"3.jpeg",
  Pic4:=TDrawPicture.Create('','');//"4.jpeg",

  PicList.Add(Pic1);
  PicList.Add(Pic2);
  PicList.Add(Pic3);
  PicList.Add(Pic4);

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameShopUserInfo.Destroy;
begin

  uFuncCommon.FreeAndNil(Pic1);
  uFuncCommon.FreeAndNil(Pic2);
  uFuncCommon.FreeAndNil(Pic3);
  uFuncCommon.FreeAndNil(Pic4);

  uFuncCommon.FreeAndNil(PicList);
  uFuncCommon.FreeAndNil(OriginPicUrlList);
  inherited;
end;

procedure TFrameShopUserInfo.imgDoorClick(Sender: TObject);
var
  AImageIndex:Integer;
begin
  {$IFNDEF IS_LISTVIEW_DEMO}
  //传入Index
//  AImageIndex:=StrToInt(ReplaceStr(TSkinFMXImage(Sender).Name,'imgPic',''))-1;
  //查看照片信息
  HideFrame();
  //查看照片信息
  ShowFrame(TFrame(GlobalViewPictureListFrame),TFrameViewPictureList,frmMain,nil,nil,nil);
//  GlobalViewPictureListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalViewPictureListFrame.Init('照片',
        PicList,
        0,
        //原图URL
        OriginPicUrlList
        );
  {$ENDIF}
end;

procedure TFrameShopUserInfo.Init(AShop: TShop;AShopInfoFrame:TFrame);
begin
  FGlobalShopInfoFrame:=AShopInfoFrame;
  TFrameShopInfo(FGlobalShopInfoFrame).pnlCar.Visible:=False;

  TFrameShopInfo(FGlobalShopInfoFrame).pnlRest.Visible:=False;

//  Self.lblNameValue.Caption:=Ashop.name;

//  FShowPic1:=AShop.Getlogopicpath;
//  FShowPic2:=AShop.Getinnerpicpath1;
//  FShowPic3:=AShop.Getinnerpicpath2;
//  FShowPic4:=AShop.Getinnerpicpath3;


  //详细信息
  Self.lbInfo.Prop.Items.FindItemByCaption('商家信息').Detail:=
      //测试超长描述
//    '商家信息商家信息商家信息商家信息商家信息商家信息商家信息商家信息商家信息商家信息商家信息商家信息商家信息商家信息';
      AShop.shop_desc;



  Self.Pic1.Url:=AShop.Getdoorfacepicpath;
  Self.Pic2.Url:=AShop.Getinnerpicpath1;
  Self.Pic3.Url:=AShop.Getinnerpicpath2;
  Self.Pic4.Url:=AShop.Getinnerpicpath3;

  if (AShop.door_face_pic_path='') and (AShop.inner_pic_path1='')
  and (AShop.inner_pic_path2='') and (AShop.inner_pic_path3='') then
  begin
      //不存在商家图片
      Self.imgDoor.Visible:=False;
      Self.imgIn.Visible:=False;
      Self.imgIn1.Visible:=False;
      Self.imgIn2.Visible:=False;
      Self.lbInfo.Prop.Items.FindItemByCaption('商家信息').Height:=89
          +uSkinBufferBitmap.CalcStringHeight(AShop.shop_desc,Width,lblNameValue.Material.DrawCaptionParam)
          -10;
  end
  else
  begin
      //存在商家图片
      Self.lbInfo.Prop.Items.FindItemByCaption('商家信息').Height:=145
          +uSkinBufferBitmap.CalcStringHeight(AShop.shop_desc,Width,lblNameValue.Material.DrawCaptionParam)
          -10;
      if AShop.door_face_pic_path<>'' then
      begin
        Self.imgDoor.Visible:=True;
        Self.imgDoor.Margins.Left:=10;
        Self.imgDoor.Prop.Picture.Url:=AShop.Getdoorfacepicpath;
        Self.imgDoor.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtUrl;
      end
      else
      begin
        Self.imgDoor.Visible:=False;
        Self.imgDoor.Margins.Left:=0;
        Self.imgDoor.Prop.Picture.Url:='';
      end;

      if AShop.inner_pic_path1<>'' then
      begin
        Self.imgIn.Visible:=True;
        if AShop.door_face_pic_path='' then
        begin
          Self.imgIn.Margins.Left:=10;
        end
        else
        begin
          Self.imgIn.Margins.Left:=5;
        end;
        Self.imgIn.Prop.Picture.Url:=AShop.Getinnerpicpath1;
        Self.imgIn.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtUrl;
      end;

      if AShop.inner_pic_path2<>'' then
      begin
        Self.imgIn1.Visible:=True;

        if (AShop.logo_pic_path='') and (AShop.inner_pic_path1='') then
        begin
          Self.imgIn1.Margins.Left:=10;
        end
        else
        begin
          Self.imgIn1.Margins.Left:=5;
        end;
        Self.imgIn1.Prop.Picture.Url:=AShop.Getinnerpicpath2;
        Self.imgIn1.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtUrl;
      end;

      if AShop.inner_pic_path3<>'' then
      begin
        Self.imgIn2.Visible:=True;

        if (AShop.logo_pic_path='') and (AShop.inner_pic_path1='') and (AShop.inner_pic_path2='') then
        begin
          Self.imgIn2.Margins.Left:=10;
        end
        else
        begin
          Self.imgIn2.Margins.Left:=5;
        end;
        Self.imgIn2.Prop.Picture.Url:=AShop.Getinnerpicpath3;
        Self.imgIn2.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtUrl;
      end;
  end;


  Self.lbInfo.Prop.Items.FindItemByCaption('商家名称').Detail:=AShop.name;
  Self.lbInfo.Prop.Items.FindItemByCaption('商家品类').Detail:=AShop.app_business_category_name;
  Self.lbInfo.Prop.Items.FindItemByCaption('商家地址').Detail:=ReplaceStr(AShop.addr,',',#13#10);//AShop.addr;
  Self.lbInfo.Prop.Items.FindItemByCaption('商家地址').Height:=
                                GetSuitContentHeight(Self.lblDetail.Width,
                                            Self.lbInfo.Prop.Items.FindItemByCaption('商家地址').Detail,
                                            12,
                                            Self.lbInfo.Prop.ItemHeight
                                                );

  Self.lbInfo.Prop.Items.FindItemByCaption('商家电话').Detail:=AShop.phone;
  Self.lbInfo.Prop.Items.FindItemByCaption('商家描述').Detail:=AShop.shop_desc;
  Self.lbInfo.Prop.Items.FindItemByCaption('商家描述').Height:=
                                GetSuitContentHeight(Self.lblDetail.Width,
                                            AShop.shop_desc,
                                            12,
                                            Self.lbInfo.Prop.ItemHeight
                                                );


  Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=uOpenClientCommon.GetBusinessTime(AShop);

//  if AShop.mon_is_sale=1 then
//  begin
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail+'周一'+' '+
//       FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_start_time))
//       +'-'
//       +FormatDateTime('HH:MM',StandardStrToDateTime(AShop.mon_end_time));
//
//  end;
//
//  if AShop.tues_is_sale=1 then
//  begin
//    if Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail<>'' then
//    begin
//      Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=
//                        Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail+#13#10;
//    end;
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail+'周二'+' '+
//       FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_start_time))
//       +'-'
//       +FormatDateTime('HH:MM',StandardStrToDateTime(AShop.tues_end_time));
//
//  end;
//
//  if AShop.wed_is_sale=1 then
//  begin
//    if Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail<>'' then
//    begin
//      Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=
//                        Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail+#13#10;
//    end;
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail+'周三'+' '+
//       FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_start_time))
//       +'-'
//       +FormatDateTime('HH:MM',StandardStrToDateTime(AShop.wed_end_time));
//
//  end;
//
//  if AShop.thur_is_sale=1 then
//  begin
//    if Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail<>'' then
//    begin
//      Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=
//                        Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail+#13#10;
//    end;
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail+'周四'+' '+
//       FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_start_time))
//       +'-'
//       +FormatDateTime('HH:MM',StandardStrToDateTime(AShop.thur_end_time));
//
//  end;
//
//  if AShop.fri_is_sale=1 then
//  begin
//    if Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail<>'' then
//    begin
//      Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=
//                        Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail+#13#10;
//    end;
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail+'周五'+' '+
//       FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_start_time))
//       +'-'
//       +FormatDateTime('HH:MM',StandardStrToDateTime(AShop.fri_end_time));
//
//  end;
//
//  if AShop.sat_is_sale=1 then
//  begin
//    if Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail<>'' then
//    begin
//      Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=
//                        Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail+#13#10;
//    end;
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail+'周六'+' '+
//       FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_start_time))
//       +'-'
//       +FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sat_end_time));
//
//  end;
//
//  if AShop.sun_is_sale=1 then
//  begin
//    if Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail<>'' then
//    begin
//      Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=
//                        Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail+#13#10;
//    end;
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail:=
//    Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail+'周日'+' '+
//       FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_start_time))
//       +'-'
//       +FormatDateTime('HH:MM',StandardStrToDateTime(AShop.sun_end_time));
//
//  end;

  Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Height:=
                                GetSuitContentHeight(Self.lblDetail.Width,
                                            Self.lbInfo.Prop.Items.FindItemByCaption('营业时间').Detail,
                                            12,
                                            Self.lbInfo.Prop.ItemHeight
                                                );
end;

end.
