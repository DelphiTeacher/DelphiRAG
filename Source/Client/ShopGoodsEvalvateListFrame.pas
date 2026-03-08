unit ShopGoodsEvalvateListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uUIFunction,
  uManager,
  uFrameContext,

  uOpenClientCommon,
  MessageBoxFrame,

  uDrawCanvas,
  uSkinItems,
  uSkinBufferBitmap,
  uBaseList,

  uOpenCommon,
  uTimerTask,
  uRestInterfaceCall,
  XSuperObject,

  WaitingFrame,

  uDrawPicture,

  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType,
  uSkinFireMonkeyListBox, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinImageType, uSkinFireMonkeyImage, uSkinListViewType,
  uSkinFireMonkeyListView;

type
  TFrameShopGoodsEvalvateList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbList: TSkinFMXListBox;
    idpList: TSkinFMXItemDesignerPanel;
    imgHead: TSkinFMXImage;
    lblUserName: TSkinFMXLabel;
    imgUserStar1: TSkinFMXImage;
    imgUserStar2: TSkinFMXImage;
    imgUserStar3: TSkinFMXImage;
    imgUserStar4: TSkinFMXImage;
    imgUserStar5: TSkinFMXImage;
    lblScoreValue: TSkinFMXLabel;
    lblScoreTime: TSkinFMXLabel;
    lblEvaluate: TSkinFMXLabel;
    lblShopReply: TSkinFMXLabel;
    lvGoodsName: TSkinFMXListView;
    imgScore: TSkinFMXImage;
    imgScorePic1: TSkinFMXImage;
    imgScorePic3: TSkinFMXImage;
    imgScorePic4: TSkinFMXImage;
    imgScorePic2: TSkinFMXImage;
    imgScorePic: TSkinFMXImage;
    idpGoods: TSkinFMXItemDesignerPanel;
    lblGoodsName: TSkinFMXLabel;
    idpFilter: TSkinFMXItemDesignerPanel;
    btnFilter: TSkinFMXButton;
    btnFilter1: TSkinFMXButton;
    btnFilter2: TSkinFMXButton;
    btnFilter3: TSkinFMXButton;
    btnFilter4: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lbListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure idpFilterResize(Sender: TObject);
    procedure btnFilterClick(Sender: TObject);
    procedure btnFilter2Click(Sender: TObject);
    procedure btnFilter3Click(Sender: TObject);
    procedure btnFilter4Click(Sender: TObject);
    procedure btnFilter1Click(Sender: TObject);
    procedure lbListPullDownRefresh(Sender: TObject);
    procedure lbListPullUpLoadMore(Sender: TObject);
  private
    

    //是否有图
    FHasPic:String;
    //评分范围
    FMinScore:String;
    FMaxScore:String;
    //商品FID
    FFilterGoodsFID:Integer;
    //店铺FID
    FFilterShopFID:Integer;
  private
    FPageIndex:Integer;
    FPageSize:Integer;
    //获取商品评论列表
    procedure DoShopperGetEvalvateExecute(ATimerTask:TObject);
    procedure DoShopperGetEvalvateExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    //清空
    procedure Clear;
    //加载
    procedure Load(AGoodsFID:Integer;
                   AShopFID:Integer;
                   AMinScore:String;
                   AMaxScore:String;
                   AHasPic:String);
    //获取评论列表
    procedure ShopGetEvalueList;
  public
    FrameHistroy: TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalShopGoodsEvalvateListFrame:TFrameShopGoodsEvalvateList;

implementation

{$R *.fmx}

{ TFrameEvalvateList }

procedure TFrameShopGoodsEvalvateList.btnFilter1Click(Sender: TObject);
begin
  Self.btnFilter.Prop.IsPushed:=False;

  Self.btnFilter1.Prop.IsPushed:=True;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=False;

  FMinScore:='';
  FMaxScore:='';

  FHasPic:='1';

  ShopGetEvalueList;
end;

procedure TFrameShopGoodsEvalvateList.btnFilter2Click(Sender: TObject);
begin
  Self.btnFilter.Prop.IsPushed:=False;

  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=True;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=False;

  FMinScore:='5';
  FMaxScore:='5';

  FHasPic:='';

  ShopGetEvalueList;
end;

procedure TFrameShopGoodsEvalvateList.btnFilter3Click(Sender: TObject);
begin
  Self.btnFilter.Prop.IsPushed:=False;

  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=True;
  Self.btnFilter4.Prop.IsPushed:=False;

  FMinScore:='3';
  FMaxScore:='4';

  FHasPic:='';

  ShopGetEvalueList;
end;

procedure TFrameShopGoodsEvalvateList.btnFilter4Click(Sender: TObject);
begin
  Self.btnFilter.Prop.IsPushed:=False;

  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=True;

  FMinScore:='1';
  FMaxScore:='2';

  FHasPic:='';

  ShopGetEvalueList;
end;

procedure TFrameShopGoodsEvalvateList.btnFilterClick(Sender: TObject);
begin
  Self.btnFilter.Prop.IsPushed:=True;

  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=False;

  FMinScore:='';
  FMaxScore:='';

  FHasPic:='';

  ShopGetEvalueList;
end;

procedure TFrameShopGoodsEvalvateList.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self, hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;


procedure TFrameShopGoodsEvalvateList.Clear;
begin
  //评分范围
  FMinScore:='';
  FMaxScore:='';

  //是否有图
  FHasPic:='';

  FFilterGoodsFID:=0;
  FFilterShopFID:=0;


  Self.btnFilter.Prop.IsPushed:=False;
  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=False;

  Self.lbList.Prop.Items.ClearItemsByTypeNot(sitHeader);
end;

constructor TFrameShopGoodsEvalvateList.Create(AOwner: TComponent);
begin
  inherited;

  FPageIndex:=1;
  FPageSize:=20;

//  FEvaluateList:=TEvaluateList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  Self.btnFilter.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.PushedEffect.FillColor.Color:=SkinThemeColor;
  Self.btnFilter1.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.PushedEffect.FillColor.Color:=SkinThemeColor;
  Self.btnFilter2.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.PushedEffect.FillColor.Color:=SkinThemeColor;
  Self.btnFilter3.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.PushedEffect.FillColor.Color:=SkinThemeColor;
  Self.btnFilter4.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.PushedEffect.FillColor.Color:=SkinThemeColor;

  {$IFDEF YC}
  Self.lblGoodsName.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=$FFB0EACA;

  Self.btnFilter.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=$FFB0EACA;
  Self.btnFilter1.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=$FFB0EACA;
  Self.btnFilter2.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=$FFB0EACA;
  Self.btnFilter3.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=$FFB0EACA;
  Self.btnFilter4.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=$FFB0EACA;
  {$ENDIF}

end;


destructor TFrameShopGoodsEvalvateList.Destroy;
begin
//  FreeAndNil(FEvaluateList);
  inherited;
end;

procedure TFrameShopGoodsEvalvateList.DoShopperGetEvalvateExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_evaluate_object_list',
                                                      nil,
                                                      EvaluateCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'evaluate_type',
                                                      'filter_to_fid',
                                                      'filter_to_sub_fid',
                                                      'filter_score_area_min',
                                                      'filter_score_area_max',
                                                      'filter_has_pic',
                                                      'pageindex',
                                                      'pagesize'],
                                                      [AppID,
                                                       GlobalManager.User.fid,
                                                       'user_evaluate_order_goods',
                                                       FFilterShopFID,
                                                       FFilterGoodsFID,
                                                       FMinScore,
                                                       FMaxScore,
                                                       FHasPic,
                                                       FPageIndex,
                                                       FPageSize
                                                       ],
                                        GlobalRestAPISignType,
                                        GlobalRestAPIAppSecret
                                        );
    if TTimerTask(ATimerTask).TaskDesc <> '' then
    begin
      TTimerTask(ATimerTask).TaskTag := 0;
    end;

  except
    on E: Exception do
    begin
      // 异常
      TTimerTask(ATimerTask).TaskDesc := E.Message;
    end;
  end;
end;


procedure TFrameShopGoodsEvalvateList.DoShopperGetEvalvateExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AListViewItem:TSkinListViewItem;
  AListBoxItem:TSkinListBoxItem;
  I: Integer;
  J: Integer;
  AGoodsStringList:TStringList;
  AHasPicNumber:Integer;
  AWellNumber:Integer;
  AGeneralNumber:Integer;
  ABadNumber:Integer;

  //评论列表
  FEvaluateList:TEvaluateList;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        FEvaluateList:=TEvaluateList.Create(ooReference);

        if Self.FPageIndex=1 then Self.lbList.Prop.Items.ClearItemsByTypeNot(sitHeader);

        //获取成功
        FEvaluateList.ParseFromJsonArray(TEvaluate,ASuperObject.O['Data'].A['EvaluateObjectList']);

        Self.lbList.Prop.Items.BeginUpdate;
        try
          if (Self.FHasPic='') and (Self.FMinScore='') and (Self.FMaxScore='') then
          begin

            AHasPicNumber:=0;
            AWellNumber:=0;
            AGeneralNumber:=0;
            ABadNumber:=0;

            Self.btnFilter.Caption:='全部'+IntToStr(FEvaluateList.Count);

            for I := 0 to FEvaluateList.Count-1 do
            begin
              if (FEvaluateList[I].score>=1) and (FEvaluateList[I].score<=2) then
              begin
                ABadNumber:=ABadNumber+1;
              end;

              if (FEvaluateList[I].score>=3) and (FEvaluateList[I].score<=4) then
              begin
                AGeneralNumber:=AGeneralNumber+1;
              end;

              if (FEvaluateList[I].score=5) and (FEvaluateList[I].score=5) then
              begin
                AWellNumber:=AWellNumber+1;
              end;

              if FEvaluateList[I].pic1_path<>'' then
              begin
                AHasPicNumber:=AHasPicNumber+1;
              end;
            end;

            Self.btnFilter1.Caption:='有图'+IntToStr(AHasPicNumber);
            Self.btnFilter2.Caption:='好评'+IntToStr(AWellNumber);
            Self.btnFilter3.Caption:='一般'+IntToStr(AGeneralNumber);
            Self.btnFilter4.Caption:='差评'+IntToStr(ABadNumber);

          end;


          for I := 0 to FEvaluateList.Count-1 do
          begin
            AListBoxItem:=Self.lbList.Prop.Items.Add;
            AListBoxItem.Height:=345;
            AListBoxItem.Data:=FEvaluateList[I];
            if FEvaluateList[I].is_anonymous=1 then
            begin
              AListBoxItem.Caption:='匿名用户';
            end
            else
            begin
              AListBoxItem.Caption:=FEvaluateList[I].from_name;
            end;

            AListBoxItem.Icon.ImageIndex:=0;
            AListBoxItem.Detail:=FEvaluateList[I].createtime;
            AListBoxItem.Detail1:=FEvaluateList[I].tags+' '+FEvaluateList[I].content;
            AListBoxItem.Detail5:=FEvaluateList[I].goods_name;

            for J := 0 to FEvaluateList[I].EvaluateReplyList.Count-1 do
            begin
              if J=0 then
              begin
                AListBoxItem.Detail2:=FEvaluateList[I].EvaluateReplyList[J].content;
              end;
            end;

            AListBoxItem.Detail6:=FloatToStr(FEvaluateList[I].score);


          end;


        finally
          Self.lbList.Prop.Items.EndUpdate();
          FreeAndNil(FEvaluateList);
        end;

         Self.lvGoodsName.Height:=Self.lvGoodsName.Prop.GetContentHeight;

      end
      else
      begin
        //调用失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
    if FPageIndex>1 then
    begin
      if (TTimerTask(ATimerTask).TaskTag=TASK_SUCC) and (ASuperObject.O['Data'].A['EvaluateObjectList'].Length>0) then
      begin
        Self.lbList.Prop.StopPullUpLoadMore('加载成功!',0,True);
      end
      else
      begin
        Self.lbList.Prop.StopPullUpLoadMore('下面没有了!',600,False);
      end;
    end
    else
    begin
      Self.lbList.Prop.StopPullDownRefresh('刷新成功!',600);
    end;
  end;

end;



procedure TFrameShopGoodsEvalvateList.idpFilterResize(Sender: TObject);
begin
  Self.btnFilter.Left:=20;

  Self.btnFilter1.Left:=Self.btnFilter.Left+Self.btnFilter.Width+10;
  Self.btnFilter1.Top:=Self.btnFilter.Top;

  Self.btnFilter2.Left:=Self.btnFilter1.Left+Self.btnFilter1.Width+10;
  Self.btnFilter2.Top:=Self.btnFilter.Top;

  if (Self.Width-Self.btnFilter2.Left-Self.btnFilter2.Width-30)>Self.btnFilter3.Width then
  begin
    Self.btnFilter3.Left:=Self.btnFilter2.Left+Self.btnFilter2.Width+10;
    Self.btnFilter3.Top:=Self.btnFilter.Top;

    if (Self.Width-Self.btnFilter3.Left-Self.btnFilter3.Width-30)>Self.btnFilter4.Width then
    begin
      Self.btnFilter4.Left:=Self.btnFilter3.Left+Self.btnFilter3.Width+10;
      Self.btnFilter4.Top:=Self.btnFilter.Top;

      Self.lbList.Prop.Items.FindItemByType(sitHeader).Height:=45;
    end
    else
    begin
      Self.btnFilter4.Left:=20;
      Self.btnFilter4.Top:=Self.btnFilter.Top+Self.btnFilter.Height+10;

      Self.lbList.Prop.Items.FindItemByType(sitHeader).Height:=87;
    end;

  end
  else
  begin
    Self.btnFilter3.Left:=20;
    Self.btnFilter3.Top:=Self.btnFilter.Top+Self.btnFilter.Height+10;

    Self.btnFilter4.Left:=Self.btnFilter3.Left+Self.btnFilter3.Width+10;
    Self.btnFilter4.Top:=Self.btnFilter3.Top;

    Self.lbList.Prop.Items.FindItemByType(sitHeader).Height:=87;
  end;

end;

procedure TFrameShopGoodsEvalvateList.lbListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AEvaluate:TEvaluate;
  ANumber:Double;
  ATagHeight:Double;
  AContentHeight:Double;
  I: Integer;
  ABottomHeight:Double;
  AGoodsStringList:TStringList;
  AListViewItem:TSkinListViewItem;
begin
  ANumber:=0;
  ATagHeight:=0;
  AContentHeight:=0;
  ABottomHeight:=60;

  if AItem.Data<>nil then
  begin

    AEvaluate:=TEvaluate(AItem.Data);
    Self.lblEvaluate.Visible:=True;
    if AItem.Detail1<>'' then
    begin
      ATagHeight:=uSkinBufferBitmap.GetStringHeight(AItem.Detail1,
                                          RectF(60,0,Self.Width-10,MaxInt),
                                          Self.lblEvaluate.SelfOwnMaterialToDefault.DrawCaptionParam
                                          );
      Self.lblEvaluate.Height:=ATagHeight;

      ABottomHeight:=Self.lblEvaluate.Top+Self.lblEvaluate.Height+10;
    end
    else
    begin
      Self.lblEvaluate.Visible:=False;
    end;


    if AItem.Detail2<>'' then
    begin
      AContentHeight:=uSkinBufferBitmap.GetStringHeight(AItem.Detail2,
                                          RectF(90,0,0,MaxInt),
                                          Self.lblShopReply.SelfOwnMaterialToDefault.DrawCaptionParam
                                          );
      Self.lblShopReply.Height:=AContentHeight;

      ABottomHeight:=Self.lblShopReply.Top+Self.lblShopReply.Height+10;
    end
    else
    begin
      Self.lblShopReply.Visible:=False;
    end;




    if AEvaluate.pic1_path='' then
    begin
      Self.imgScorePic.Visible:=False;
      Self.imgScorePic1.Visible:=False;
      Self.imgScorePic2.Visible:=False;
      Self.imgScorePic3.Visible:=False;
      Self.imgScorePic4.Visible:=False;
    end
    else if AEvaluate.pic2_path='' then
    begin
      Self.imgScorePic1.Visible:=False;
      Self.imgScorePic2.Visible:=False;
      Self.imgScorePic3.Visible:=False;
      Self.imgScorePic4.Visible:=False;

      Self.imgScorePic.Visible:=True;

      Self.imgScorePic.Top:=ABottomHeight;

      Self.imgScorePic.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
//      Self.imgScorePic.Prop.Picture.StaticRefDrawPicture:=AEvaluate.Pic1;

      ABottomHeight:=Self.imgScorePic.Top+Self.imgScorePic.Height;
    end
    else
    begin
      Self.imgScorePic.Visible:=False;

      Self.imgScorePic1.Visible:=(AEvaluate.pic1_path<>'');
      Self.imgScorePic2.Visible:=(AEvaluate.pic2_path<>'');
      Self.imgScorePic3.Visible:=(AEvaluate.pic3_path<>'');
      Self.imgScorePic4.Visible:=False;


      Self.imgScorePic1.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
      Self.imgScorePic2.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
      Self.imgScorePic3.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;


//      Self.imgScorePic1.Prop.Picture.StaticRefDrawPicture:=AEvaluate.Pic1;
//      Self.imgScorePic2.Prop.Picture.StaticRefDrawPicture:=AEvaluate.Pic2;
//      Self.imgScorePic3.Prop.Picture.StaticRefDrawPicture:=AEvaluate.Pic3;



      Self.imgScorePic1.Top:=ABottomHeight+10;
      Self.imgScorePic2.Top:=imgScorePic1.Top;

      ABottomHeight:=Self.imgScorePic1.Top+Self.imgScorePic1.Height;

      Self.imgScorePic3.Top:=imgScorePic1.Top+imgScorePic1.Height+10;
      Self.imgScorePic4.Top:=imgScorePic3.Top;

      if Self.imgScorePic3.Visible=True then
      begin
        ABottomHeight:=Self.imgScorePic3.Top+Self.imgScorePic3.Height;
      end;
    end;


    if AItem.Detail5<>'' then
    begin
      Self.imgScore.Visible:= True;

      Self.lvGoodsName.Visible:=True;

      Self.imgScore.Top:= ABottomHeight+10;

      Self.lvGoodsName.Top:=Self.imgScore.Top-5;

      Self.lvGoodsName.Prop.Items.BeginUpdate;
      try
        Self.lvGoodsName.Prop.Items.Clear(True);

        AGoodsStringList:=TStringList.Create;

        AGoodsStringList.CommaText:=AItem.Detail5;

        for I := 0 to AGoodsStringList.Count-1 do
        begin

          AListViewItem:=Self.lvGoodsName.Prop.Items.Add;
          AListViewItem.Caption:=AGoodsStringList[I];
          AListViewItem.Height:=33;
          AListViewItem.Width:=uSkinBufferBitmap.GetStringWidth(AGoodsStringList[I],
                                                           Self.lblGoodsName.SelfOwnMaterialToDefault.DrawCaptionParam.FontSize);

        end;

        Self.lvGoodsName.Width:=Self.lvGoodsName.Prop.GetContentWidth;

        Self.lvGoodsName.Height:=Self.lvGoodsName.Prop.GetContentHeight;

      finally
        Self.lvGoodsName.Prop.Items.EndUpdate();

        FreeAndNil(AGoodsStringList);

      end;

      ABottomHeight:=Self.lvGoodsName.Top+Self.lvGoodsName.Height+10;
    end
    else
    begin
      Self.imgScore.Visible:= False;

      Self.lvGoodsName.Visible:=False;
    end;




    ANumber:=StrToFloat(AItem.Detail6);
    //对商家服务态度评分

    if (ANumber>=1) and (ANumber<=2) then
    begin
      Self.lblScoreValue.Caption:='很差';
    end;

    if (ANumber>=3) and (ANumber<=4) then
    begin
      Self.lblScoreValue.Caption:='一般';
    end;

    if ANumber=5 then
    begin
      Self.lblScoreValue.Caption:='很赞';
    end;

    if (ANumber>0) and (ANumber<1) then
    begin
      Self.imgUserStar1.Prop.Picture.ImageIndex:=1;
      Self.imgUserStar2.Prop.Picture.ImageIndex:=1;
      Self.imgUserStar3.Prop.Picture.ImageIndex:=1;
      Self.imgUserStar4.Prop.Picture.ImageIndex:=1;
      Self.imgUserStar5.Prop.Picture.ImageIndex:=1;
    end;

    if (ANumber>=1) and (ANumber<2) then
    begin
      Self.imgUserStar1.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar2.Prop.Picture.ImageIndex:=1;
      Self.imgUserStar3.Prop.Picture.ImageIndex:=1;
      Self.imgUserStar4.Prop.Picture.ImageIndex:=1;
      Self.imgUserStar5.Prop.Picture.ImageIndex:=1;
    end;


    if (ANumber>=2) and (ANumber<3) then
    begin
      Self.imgUserStar1.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar2.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar3.Prop.Picture.ImageIndex:=1;
      Self.imgUserStar4.Prop.Picture.ImageIndex:=1;
      Self.imgUserStar5.Prop.Picture.ImageIndex:=1;
    end;

    if (ANumber>=3) and (ANumber<4) then
    begin
      Self.imgUserStar1.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar2.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar3.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar4.Prop.Picture.ImageIndex:=1;
      Self.imgUserStar5.Prop.Picture.ImageIndex:=1;
    end;

    if (ANumber>=4) and (ANumber<5) then
    begin
      Self.imgUserStar1.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar2.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar3.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar4.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar5.Prop.Picture.ImageIndex:=1;
    end;

    if ANumber>=5 then
    begin
      Self.imgUserStar1.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar2.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar3.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar4.Prop.Picture.ImageIndex:=0;
      Self.imgUserStar5.Prop.Picture.ImageIndex:=0;
    end;

    AItem.Height:=ABottomHeight;

  end;


end;


procedure TFrameShopGoodsEvalvateList.lbListPullDownRefresh(Sender: TObject);
begin
  Self.FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
              DoShopperGetEvalvateExecute,
              DoShopperGetEvalvateExecuteEnd,
              'ShopperGetEvalvate');
end;

procedure TFrameShopGoodsEvalvateList.lbListPullUpLoadMore(Sender: TObject);
begin
  Self.FPageIndex:=Self.FPageIndex+1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
              DoShopperGetEvalvateExecute,
              DoShopperGetEvalvateExecuteEnd,
              'ShopperGetEvalvate');
end;

procedure TFrameShopGoodsEvalvateList.Load(AGoodsFID:Integer;
                                           AShopFID:Integer;
                                           AMinScore:String;
                                           AMaxScore:String;
                                           AHasPic:String);
begin
  Clear;

  Self.btnFilter.Prop.IsPushed:=True;

  FFilterGoodsFID:=AGoodsFID;

  FFilterShopFID:=AShopFID;

  //评分范围
  FMinScore:=AMinScore;
  FMaxScore:=AMaxScore;
  //是否有图
  FHasPic:=AHasPic;

  //获取商品评论列表
  ShopGetEvalueList;
end;

procedure TFrameShopGoodsEvalvateList.ShopGetEvalueList;
begin
  ShowWaitingFrame(Self,'获取中...');
  //商家获取评论列表
  uTimerTask.GetGlobalTimerThread.RunTempTask(
              DoShopperGetEvalvateExecute,
              DoShopperGetEvalvateExecuteEnd,
              'ShopperGetEvalvate');
end;

end.
