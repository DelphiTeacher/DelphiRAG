unit ShopInfoEvaluateListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uSkinMaterial,
  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,

  ShopGoodsListFrame,
  ShopUserInfoFrame,
  uOpenClientCommon,
  uOpenCommon,
  uFrameContext,

//  uOpenCommon,
  uUIFunction,
  uSkinBufferBitmap,

  WaitingFrame,
  uTimerTask,


  uDrawPicture,
  uManager,
//  uOpenClientCommon,
  uBaseList,

  XSuperObject,
  uRestInterfaceCall,

  MessageBoxFrame,

  uDrawCanvas,

  uSkinItems,
  TakePictureMenuFrame,

  ListItemStyleFrame_ShopEvalvateFrame,


  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinFireMonkeyControl, uSkinPanelType,
  uSkinFireMonkeyPanel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinListViewType, uSkinFireMonkeyListView,
  uSkinButtonType, uSkinFireMonkeyButton;

type
  TFrameShopInfoEvaluateList = class(TFrame)
    lbList: TSkinFMXListBox;
    idpGoods: TSkinFMXItemDesignerPanel;
    lblGoodsName: TSkinFMXLabel;
    idpItem1: TSkinFMXItemDesignerPanel;
    lblAllScore: TSkinFMXLabel;
    lblAll: TSkinFMXLabel;
    lblSevice: TSkinFMXLabel;
    imgStar: TSkinFMXImage;
    imgStar1: TSkinFMXImage;
    imgStar2: TSkinFMXImage;
    imgStar3: TSkinFMXImage;
    imgStar4: TSkinFMXImage;
    lblSeviceValue: TSkinFMXLabel;
    lblGoodsValue: TSkinFMXLabel;
    imgGoodsStar4: TSkinFMXImage;
    imgGoodsStar3: TSkinFMXImage;
    imgGoodsStar2: TSkinFMXImage;
    imgGoodsStar: TSkinFMXImage;
    imgGoodsStar1: TSkinFMXImage;
    lblGoods: TSkinFMXLabel;
    idpFilter: TSkinFMXItemDesignerPanel;
    btnFilter: TSkinFMXButton;
    btnFilter1: TSkinFMXButton;
    btnFilter2: TSkinFMXButton;
    btnFilter3: TSkinFMXButton;
    btnFilter4: TSkinFMXButton;
    procedure lbListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure idpFilterResize(Sender: TObject);
    procedure btnFilterClick(Sender: TObject);
    procedure btnFilter1Click(Sender: TObject);
    procedure btnFilter2Click(Sender: TObject);
    procedure btnFilter3Click(Sender: TObject);
    procedure btnFilter4Click(Sender: TObject);
    procedure lbListPullDownRefresh(Sender: TObject);
    procedure lbListPullUpLoadMore(Sender: TObject);
  private
    

    //店铺
    FShop:TShop;

    FMinScore:String;
    FMaxScore:String;

    FHasPic:String;
    //店铺FID
    FShopFID:Integer;
    //评价显示
    procedure Show(ANumber1:Double;ANumber2:Double);
  private
    FPageIndex:Integer;
    FPageSize:Integer;
    //获取评论列表
    procedure DoGetEvaluateListExecute(ATimerTask:TObject);
    procedure DoGetEvaluateListExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    //同一个界面共用  传进来的
    FGlobalShopInfoFrame:TFrame;
    //清空
    procedure Clear;
    procedure Init(AShop:TShop;
                   AShopInfoFrame:TFrame);
    //获取评论列表
    procedure GetEvaluateList;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalEvaluateListFrame:TFrameShopInfoEvaluateList;

implementation

{$R *.fmx}
uses
  MAinForm,MainFrame,ShopInfoFrame;

{ TFrameEvaluateList }

procedure TFrameShopInfoEvaluateList.btnFilter1Click(Sender: TObject);
begin
  Self.btnFilter.Prop.IsPushed:=False;

  Self.btnFilter1.Prop.IsPushed:=True;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=False;

  FMinScore:='';
  FMaxScore:='';

  FHasPic:='1';

  GetEvaluateList;
end;

procedure TFrameShopInfoEvaluateList.btnFilter2Click(Sender: TObject);
begin
  Self.btnFilter.Prop.IsPushed:=False;

  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=True;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=False;

  FMinScore:='5';
  FMaxScore:='5';

  FHasPic:='';

  GetEvaluateList;
end;

procedure TFrameShopInfoEvaluateList.btnFilter3Click(Sender: TObject);
begin
  Self.btnFilter.Prop.IsPushed:=False;

  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=True;
  Self.btnFilter4.Prop.IsPushed:=False;

  FMinScore:='3';
  FMaxScore:='4';

  FHasPic:='';

  GetEvaluateList;
end;

procedure TFrameShopInfoEvaluateList.btnFilter4Click(Sender: TObject);
begin
  Self.btnFilter.Prop.IsPushed:=False;

  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=True;

  FMinScore:='1';
  FMaxScore:='2';

  FHasPic:='';

  GetEvaluateList;
end;

procedure TFrameShopInfoEvaluateList.btnFilterClick(Sender: TObject);
begin
  Self.btnFilter.Prop.IsPushed:=True;

  Self.btnFilter1.Prop.IsPushed:=False;
  Self.btnFilter2.Prop.IsPushed:=False;
  Self.btnFilter3.Prop.IsPushed:=False;
  Self.btnFilter4.Prop.IsPushed:=False;

  FMinScore:='';
  FMaxScore:='';

  FHasPic:='';

  GetEvaluateList;
end;

procedure TFrameShopInfoEvaluateList.Clear;
begin
  Self.lbList.Prop.Items.Clear(True);

  FShopFID:=0;

  FMinScore:='';
  FMaxScore:='';

  FHasPic:='';

//  Self.imgUserStar1.Prop.Picture.ImageIndex:=1;
//  Self.imgUserStar2.Prop.Picture.ImageIndex:=1;
//  Self.imgUserStar3.Prop.Picture.ImageIndex:=1;
//  Self.imgUserStar4.Prop.Picture.ImageIndex:=1;
//  Self.imgUserStar5.Prop.Picture.ImageIndex:=1;


  Self.imgStar.Prop.Picture.ImageIndex:=1;
  Self.imgStar1.Prop.Picture.ImageIndex:=1;
  Self.imgStar2.Prop.Picture.ImageIndex:=1;
  Self.imgStar3.Prop.Picture.ImageIndex:=1;
  Self.imgStar4.Prop.Picture.ImageIndex:=1;


  Self.imgGoodsStar.Prop.Picture.ImageIndex:=1;
  Self.imgGoodsStar1.Prop.Picture.ImageIndex:=1;
  Self.imgGoodsStar2.Prop.Picture.ImageIndex:=1;
  Self.imgGoodsStar3.Prop.Picture.ImageIndex:=1;
  Self.imgGoodsStar4.Prop.Picture.ImageIndex:=1;
end;

constructor TFrameShopInfoEvaluateList.Create(AOwner: TComponent);
begin
  inherited;
  Self.lbList.Prop.IsProcessGestureInScrollBox:=True;

//  TFrameShopInfo(FGlobalShopInfoFrame).pnlCar.Visible:=False;
//  FEvaluateList:=TEvaluateList.Create;

  //不需要创建和释放
//  FShop:=TShop.Create;

  FPageIndex:=1;
  FPageSize:=20;

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

destructor TFrameShopInfoEvaluateList.Destroy;
begin

//  FreeAndNil(FShop);
  inherited;
end;

procedure TFrameShopInfoEvaluateList.DoGetEvaluateListExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    FMX.Types.Log.d('OrangeUI ShopInfoEvaluateListFrame get_evaluate_object_list begin');
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_evaluate_object_list',
                                                      nil,
                                                      EvaluateCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'evaluate_type',
                                                      'filter_is_reply',
                                                      'filter_to_fid',
                                                      'filter_score_area_min',
                                                      'filter_score_area_max',
                                                      'filter_has_pic',
                                                      'pageindex',
                                                      'pagesize'],
                                                      [AppID,
                                                       GlobalManager.User.fid,
                                                       'user_evaluate_order_shop',
                                                       '',
                                                       FShopFID,
                                                       Self.FMinScore,
                                                       Self.FMaxScore,
                                                       Self.FHasPic,
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



procedure TFrameShopInfoEvaluateList.DoGetEvaluateListExecuteEnd(ATimerTask: TObject);
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

      FMX.Types.Log.d('OrangeUI EvalvateList AJson:'+ASuperObject.AsJSON);
      if ASuperObject.I['Code']=200 then
      begin
        FEvaluateList:=TEvaluateList.Create(ooReference);

        if Self.FPageIndex=1 then
        begin
          Self.lbList.Prop.Items.Clear(True);
        end;

        //获取成功
//        FEvaluateList.Clear(True);
        FEvaluateList.ParseFromJsonArray(TEvaluate,ASuperObject.O['Data'].A['EvaluateObjectList']);

        Self.lbList.Prop.Items.BeginUpdate;
        try

          if Self.FPageIndex=1 then
          begin

            AListBoxItem:=Self.lbList.Prop.Items.Add;
            AListBoxItem.Height:=105;
            AListBoxItem.ItemType:=sitItem1;
            AListBoxItem.Caption:=FloatToStr(Self.FShop.rating_score);
            AListBoxItem.Detail:=FloatToStr(Self.FShop.service_rating_score);
            AListBoxItem.Detail1:=FloatToStr(Self.FShop.goods_rating_score);

            AListBoxItem:=Self.lbList.Prop.Items.Add;
            AListBoxItem.Height:=87;
            FMX.Types.Log.d('OrangeUI ShopInfoEvaluateListFrame ItemType ');
            AListBoxItem.ItemType:=sitItem2;
            FMX.Types.Log.d('OrangeUI ShopInfoEvaluateListFrame ItemType 3');
          end;

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

            FMX.Types.Log.d('OrangeUI ShopInfoEvaluateListFrame List  FEvaluateList');



          for I := 0 to FEvaluateList.Count-1 do
          begin
            AListBoxItem:=Self.lbList.Prop.Items.Add;
            AListBoxItem.Height:=345;
            AListBoxItem.ItemType:=sitDefault;
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
            AListBoxItem.Detail5:=FEvaluateList[I].user_custom_data;

            FMX.Types.Log.d('OrangeUI EvalvateList User_Custom_Data:'+FEvaluateList[I].user_custom_data);

            for J := 0 to FEvaluateList[I].EvaluateReplyList.Count-1 do
            begin
              if J=0 then
              begin
                AListBoxItem.Detail2:=FEvaluateList[I].EvaluateReplyList[J].content;
              end;
            end;

            AListBoxItem.Detail6:=FloatToStr(FEvaluateList[I].score);


          end;

          FMX.Types.Log.d('OrangeUI ShopInfoEvaluateListFrame List  FEvaluateList  End');


        finally
          Self.lbList.Prop.Items.EndUpdate();
          FreeAndNil(FEvaluateList);
        end;
//
        FMX.Types.Log.d('OrangeUI ShopInfoEvaluateListFrame List  FEvaluateList EndUpdate');
//
//        Self.lvGoodsName.Height:=Self.lvGoodsName.Prop.GetContentHeight;

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



procedure TFrameShopInfoEvaluateList.GetEvaluateList;
begin
  //获取评论列表
  ShowWaitingFrame(Self,'获取中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
             DoGetEvaluateListExecute,
             DoGetEvaluateListExecuteEnd,
             'GetEvaluateList');
end;

procedure TFrameShopInfoEvaluateList.idpFilterResize(Sender: TObject);
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

      Self.lbList.Prop.Items.FindItemByType(sitItem2).Height:=45;
    end
    else
    begin
      Self.btnFilter4.Left:=20;
      Self.btnFilter4.Top:=Self.btnFilter.Top+Self.btnFilter.Height+10;

      Self.lbList.Prop.Items.FindItemByType(sitItem2).Height:=87;
    end;

  end
  else
  begin
    Self.btnFilter3.Left:=20;
    Self.btnFilter3.Top:=Self.btnFilter.Top+Self.btnFilter.Height+10;

    Self.btnFilter4.Left:=Self.btnFilter3.Left+Self.btnFilter3.Width+10;
    Self.btnFilter4.Top:=Self.btnFilter3.Top;

    Self.lbList.Prop.Items.FindItemByType(sitItem2).Height:=87;
  end;
end;

procedure TFrameShopInfoEvaluateList.Init(AShop:TShop;
                                          AShopInfoFrame:TFrame);
var
  AListBoxItem:TSkinListBoxItem;
begin

//  Self.Clear;

  FShop:=AShop;

  FGlobalShopInfoFrame:=AShopInfoFrame;

  TFrameShopInfo(FGlobalShopInfoFrame).pnlCar.Visible:=False;

//  GlobalShopInfoFrame.pnlRest.Visible:=False;

  FMinScore:='';
  FMaxScore:='';

  FHasPic:='';

  FShopFID:=AShop.fid;


  Self.Show(AShop.service_rating_score,AShop.goods_rating_score);

  GetEvaluateList;

end;


procedure TFrameShopInfoEvaluateList.lbListPrepareDrawItem(Sender: TObject;
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
  AGoodsArray:ISuperArray;

  AListItemStyle_ShopEvalvateFrame:TFrameListItemStyle_ShopEvalvate;
begin
  ANumber:=0;
  ATagHeight:=0;
  AContentHeight:=0;
  ABottomHeight:=60;

  if (AItem.ItemType=sitDefault) and (AItem.Data<>nil) then
  begin
        AListItemStyle_ShopEvalvateFrame:=TFrameListItemStyle_ShopEvalvate(AItemDesignerPanel.Parent);

        AEvaluate:=TEvaluate(AItem.Data);
        AListItemStyle_ShopEvalvateFrame.lblEvaluate.Visible:=True;
        if AItem.Detail1<>'' then
        begin
          ATagHeight:=uSkinBufferBitmap.GetStringHeight(AItem.Detail1,
                                              RectF(60,0,AListItemStyle_ShopEvalvateFrame.Width-10,MaxInt),
                                              AListItemStyle_ShopEvalvateFrame.lblEvaluate.SelfOwnMaterialToDefault.DrawCaptionParam
                                              );
          AListItemStyle_ShopEvalvateFrame.lblEvaluate.Height:=ATagHeight+10;

          ABottomHeight:=AListItemStyle_ShopEvalvateFrame.lblEvaluate.Top+AListItemStyle_ShopEvalvateFrame.lblEvaluate.Height+10;
        end
        else
        begin
          AListItemStyle_ShopEvalvateFrame.lblEvaluate.Visible:=False;
        end;


        if AItem.Detail2<>'' then
        begin
          AContentHeight:=uSkinBufferBitmap.GetStringHeight(AItem.Detail2,
                                              RectF(60,0,AListItemStyle_ShopEvalvateFrame.Width-10,MaxInt),
                                              AListItemStyle_ShopEvalvateFrame.lblShopReply.SelfOwnMaterialToDefault.DrawCaptionParam
                                              );
          AListItemStyle_ShopEvalvateFrame.lblShopReply.Height:=AContentHeight+10;

          ABottomHeight:=AListItemStyle_ShopEvalvateFrame.lblShopReply.Top+AListItemStyle_ShopEvalvateFrame.lblShopReply.Height+10;
        end
        else
        begin
          AListItemStyle_ShopEvalvateFrame.lblShopReply.Visible:=False;
        end;




        if AEvaluate.pic1_path='' then
        begin
          AListItemStyle_ShopEvalvateFrame.imgScorePic.Visible:=False;
          AListItemStyle_ShopEvalvateFrame.imgScorePic1.Visible:=False;
          AListItemStyle_ShopEvalvateFrame.imgScorePic2.Visible:=False;
          AListItemStyle_ShopEvalvateFrame.imgScorePic3.Visible:=False;
          AListItemStyle_ShopEvalvateFrame.imgScorePic4.Visible:=False;
        end
        else if AEvaluate.pic2_path='' then
        begin
          AListItemStyle_ShopEvalvateFrame.imgScorePic1.Visible:=False;
          AListItemStyle_ShopEvalvateFrame.imgScorePic2.Visible:=False;
          AListItemStyle_ShopEvalvateFrame.imgScorePic3.Visible:=False;
          AListItemStyle_ShopEvalvateFrame.imgScorePic4.Visible:=False;

          AListItemStyle_ShopEvalvateFrame.imgScorePic.Visible:=True;

          AListItemStyle_ShopEvalvateFrame.imgScorePic.Top:=ABottomHeight;

          AListItemStyle_ShopEvalvateFrame.imgScorePic.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
//          AListItemStyle_ShopEvalvateFrame.imgScorePic.Prop.Picture.StaticRefDrawPicture:=AEvaluate.Pic1;

          ABottomHeight:=AListItemStyle_ShopEvalvateFrame.imgScorePic.Top+AListItemStyle_ShopEvalvateFrame.imgScorePic.Height;
        end
        else
        begin
          AListItemStyle_ShopEvalvateFrame.imgScorePic.Visible:=False;

          AListItemStyle_ShopEvalvateFrame.imgScorePic1.Visible:=(AEvaluate.pic1_path<>'');
          AListItemStyle_ShopEvalvateFrame.imgScorePic2.Visible:=(AEvaluate.pic2_path<>'');
          AListItemStyle_ShopEvalvateFrame.imgScorePic3.Visible:=(AEvaluate.pic3_path<>'');
          AListItemStyle_ShopEvalvateFrame.imgScorePic4.Visible:=False;


          AListItemStyle_ShopEvalvateFrame.imgScorePic1.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
          AListItemStyle_ShopEvalvateFrame.imgScorePic2.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;
          AListItemStyle_ShopEvalvateFrame.imgScorePic3.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtRefDrawPicture;


//          AListItemStyle_ShopEvalvateFrame.imgScorePic1.Prop.Picture.StaticRefDrawPicture:=AEvaluate.Pic1;
//          AListItemStyle_ShopEvalvateFrame.imgScorePic2.Prop.Picture.StaticRefDrawPicture:=AEvaluate.Pic2;
//          AListItemStyle_ShopEvalvateFrame.imgScorePic3.Prop.Picture.StaticRefDrawPicture:=AEvaluate.Pic3;



          AListItemStyle_ShopEvalvateFrame.imgScorePic1.Top:=ABottomHeight+10;
          AListItemStyle_ShopEvalvateFrame.imgScorePic2.Top:=AListItemStyle_ShopEvalvateFrame.imgScorePic1.Top;

          ABottomHeight:=AListItemStyle_ShopEvalvateFrame.imgScorePic1.Top+AListItemStyle_ShopEvalvateFrame.imgScorePic1.Height;

          AListItemStyle_ShopEvalvateFrame.imgScorePic3.Top:=AListItemStyle_ShopEvalvateFrame.imgScorePic1.Top+AListItemStyle_ShopEvalvateFrame.imgScorePic1.Height+10;
          AListItemStyle_ShopEvalvateFrame.imgScorePic4.Top:=AListItemStyle_ShopEvalvateFrame.imgScorePic3.Top;

          if AListItemStyle_ShopEvalvateFrame.imgScorePic3.Visible=True then
          begin
            ABottomHeight:=AListItemStyle_ShopEvalvateFrame.imgScorePic3.Top+AListItemStyle_ShopEvalvateFrame.imgScorePic3.Height;
          end;
        end;


        if AItem.Detail5<>'' then
        begin
          AListItemStyle_ShopEvalvateFrame.imgScore.Visible:= True;

          AListItemStyle_ShopEvalvateFrame.lvGoodsName.Visible:=True;

          AListItemStyle_ShopEvalvateFrame.imgScore.Top:= ABottomHeight+10;

          AListItemStyle_ShopEvalvateFrame.lvGoodsName.Top:=AListItemStyle_ShopEvalvateFrame.imgScore.Top-5;

          AListItemStyle_ShopEvalvateFrame.lvGoodsName.Prop.Items.BeginUpdate;
          try
            AListItemStyle_ShopEvalvateFrame.lvGoodsName.Prop.Items.Clear(True);
            try
              AGoodsArray:=TSuperArray.Create(AItem.Detail5);

    //        AGoodsStringList:=TStringList.Create;
    //
    //        AGoodsStringList.CommaText:=AItem.Detail5;

              for I := 0 to AGoodsArray.Length-1 do
              begin

                if I<5 then
                begin
                  AListViewItem:=AListItemStyle_ShopEvalvateFrame.lvGoodsName.Prop.Items.Add;
                  AListViewItem.Caption:=AGoodsArray.O[I].S['shop_goods_name'];
                  AListViewItem.Height:=30;
                  AListViewItem.Width:=uSkinBufferBitmap.GetStringWidth(
                                      AGoodsArray.O[I].S['shop_goods_name'],
                                      Self.lblGoodsName.SelfOwnMaterialToDefault.DrawCaptionParam.FontSize)
                                      +10;
                end;
              end;




            except on E:Exception do
              begin
                ShowMessageBoxFrame(AListItemStyle_ShopEvalvateFrame,E.Message+'--'+AItem.Detail5);
              end;
            end;


//            if AListItemStyle_ShopEvalvateFrame.lvGoodsName.Prop.GetContentWidth<=(AListItemStyle_ShopEvalvateFrame.Width-AListItemStyle_ShopEvalvateFrame.imgScore.Left-AListItemStyle_ShopEvalvateFrame.imgScore.Width-5) then
//            begin
//              AListItemStyle_ShopEvalvateFrame.lvGoodsName.Width:=AListItemStyle_ShopEvalvateFrame.lvGoodsName.Prop.GetContentWidth;
//            end
//            else
//            begin
//              AListItemStyle_ShopEvalvateFrame.lvGoodsName.Width:=AListItemStyle_ShopEvalvateFrame.Width-AListItemStyle_ShopEvalvateFrame.imgScore.Left-AListItemStyle_ShopEvalvateFrame.imgScore.Width-5;
//            end;


            AListItemStyle_ShopEvalvateFrame.lvGoodsName.Height:=AListItemStyle_ShopEvalvateFrame.lvGoodsName.Prop.GetContentHeight;

          finally
            AListItemStyle_ShopEvalvateFrame.lvGoodsName.Prop.Items.EndUpdate();

    //        FreeAndNil(AGoodsStringList);
          end;

          ABottomHeight:=AListItemStyle_ShopEvalvateFrame.lvGoodsName.Top+AListItemStyle_ShopEvalvateFrame.lvGoodsName.Height+10;
        end
        else
        begin
          AListItemStyle_ShopEvalvateFrame.imgScore.Visible:= False;

          AListItemStyle_ShopEvalvateFrame.lvGoodsName.Visible:=False;
        end;




        ANumber:=StrToFloat(AItem.Detail6);
        //对商家服务态度评分

        if (ANumber>=1) and (ANumber<=2) then
        begin
          AListItemStyle_ShopEvalvateFrame.lblScoreValue.Caption:='很差';
        end;

        if (ANumber>=3) and (ANumber<=4) then
        begin
          AListItemStyle_ShopEvalvateFrame.lblScoreValue.Caption:='一般';
        end;

        if ANumber=5 then
        begin
          AListItemStyle_ShopEvalvateFrame.lblScoreValue.Caption:='很赞';
        end;

        if (ANumber>0) and (ANumber<1) then
        begin
          AListItemStyle_ShopEvalvateFrame.imgUserStar1.Prop.Picture.ImageIndex:=1;
          AListItemStyle_ShopEvalvateFrame.imgUserStar2.Prop.Picture.ImageIndex:=1;
          AListItemStyle_ShopEvalvateFrame.imgUserStar3.Prop.Picture.ImageIndex:=1;
          AListItemStyle_ShopEvalvateFrame.imgUserStar4.Prop.Picture.ImageIndex:=1;
          AListItemStyle_ShopEvalvateFrame.imgUserStar5.Prop.Picture.ImageIndex:=1;
        end;

        if (ANumber>=1) and (ANumber<2) then
        begin
          AListItemStyle_ShopEvalvateFrame.imgUserStar1.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar2.Prop.Picture.ImageIndex:=1;
          AListItemStyle_ShopEvalvateFrame.imgUserStar3.Prop.Picture.ImageIndex:=1;
          AListItemStyle_ShopEvalvateFrame.imgUserStar4.Prop.Picture.ImageIndex:=1;
          AListItemStyle_ShopEvalvateFrame.imgUserStar5.Prop.Picture.ImageIndex:=1;
        end;


        if (ANumber>=2) and (ANumber<3) then
        begin
          AListItemStyle_ShopEvalvateFrame.imgUserStar1.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar2.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar3.Prop.Picture.ImageIndex:=1;
          AListItemStyle_ShopEvalvateFrame.imgUserStar4.Prop.Picture.ImageIndex:=1;
          AListItemStyle_ShopEvalvateFrame.imgUserStar5.Prop.Picture.ImageIndex:=1;
        end;

        if (ANumber>=3) and (ANumber<4) then
        begin
          AListItemStyle_ShopEvalvateFrame.imgUserStar1.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar2.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar3.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar4.Prop.Picture.ImageIndex:=1;
          AListItemStyle_ShopEvalvateFrame.imgUserStar5.Prop.Picture.ImageIndex:=1;
        end;

        if (ANumber>=4) and (ANumber<5) then
        begin
          AListItemStyle_ShopEvalvateFrame.imgUserStar1.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar2.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar3.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar4.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar5.Prop.Picture.ImageIndex:=1;
        end;

        if ANumber>=5 then
        begin
          AListItemStyle_ShopEvalvateFrame.imgUserStar1.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar2.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar3.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar4.Prop.Picture.ImageIndex:=0;
          AListItemStyle_ShopEvalvateFrame.imgUserStar5.Prop.Picture.ImageIndex:=0;
        end;

        AItem.Height:=ABottomHeight;

  end;

end;


procedure TFrameShopInfoEvaluateList.lbListPullDownRefresh(Sender: TObject);
begin
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
             DoGetEvaluateListExecute,
             DoGetEvaluateListExecuteEnd,
             'GetEvaluateList');
end;

procedure TFrameShopInfoEvaluateList.lbListPullUpLoadMore(Sender: TObject);
begin
  FPageIndex:=FPageIndex+1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
             DoGetEvaluateListExecute,
             DoGetEvaluateListExecuteEnd,
             'GetEvaluateList');
end;

procedure TFrameShopInfoEvaluateList.Show(ANumber1:Double;ANumber2:Double);
begin
  if (ANumber2>0) and (ANumber2<1) then
  begin
    Self.imgGoodsStar.Prop.Picture.ImageIndex:=1;
    Self.imgGoodsStar1.Prop.Picture.ImageIndex:=1;
    Self.imgGoodsStar2.Prop.Picture.ImageIndex:=1;
    Self.imgGoodsStar3.Prop.Picture.ImageIndex:=1;
    Self.imgGoodsStar4.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber2>=1) and (ANumber2<2) then
  begin
    Self.imgGoodsStar.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar1.Prop.Picture.ImageIndex:=1;
    Self.imgGoodsStar2.Prop.Picture.ImageIndex:=1;
    Self.imgGoodsStar3.Prop.Picture.ImageIndex:=1;
    Self.imgGoodsStar4.Prop.Picture.ImageIndex:=1;
  end;


  if (ANumber2>=2) and (ANumber2<3) then
  begin
    Self.imgGoodsStar.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar1.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar2.Prop.Picture.ImageIndex:=1;
    Self.imgGoodsStar3.Prop.Picture.ImageIndex:=1;
    Self.imgGoodsStar4.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber2>=3) and (ANumber2<4) then
  begin
    Self.imgGoodsStar.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar1.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar2.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar3.Prop.Picture.ImageIndex:=1;
    Self.imgGoodsStar4.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber2>=4) and (ANumber2<5) then
  begin
    Self.imgGoodsStar.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar1.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar2.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar3.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar4.Prop.Picture.ImageIndex:=1;
  end;

  if ANumber2>=5 then
  begin
    Self.imgGoodsStar.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar1.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar2.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar3.Prop.Picture.ImageIndex:=0;
    Self.imgGoodsStar4.Prop.Picture.ImageIndex:=0;
  end;



  if (ANumber1>0) and (ANumber1<1) then
  begin
    Self.imgStar.Prop.Picture.ImageIndex:=1;
    Self.imgStar1.Prop.Picture.ImageIndex:=1;
    Self.imgStar2.Prop.Picture.ImageIndex:=1;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber1>=1) and (ANumber1<2) then
  begin
    Self.imgStar.Prop.Picture.ImageIndex:=0;
    Self.imgStar1.Prop.Picture.ImageIndex:=1;
    Self.imgStar2.Prop.Picture.ImageIndex:=1;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;
  end;


  if (ANumber1>=2) and (ANumber1<3) then
  begin
    Self.imgStar.Prop.Picture.ImageIndex:=0;
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=1;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber1>=3) and (ANumber1<4) then
  begin
    Self.imgStar.Prop.Picture.ImageIndex:=0;
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber1>=4) and (ANumber1<5) then
  begin
    Self.imgStar.Prop.Picture.ImageIndex:=0;
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=0;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;
  end;

  if ANumber1>=5 then
  begin
    Self.imgStar.Prop.Picture.ImageIndex:=0;
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=0;
    Self.imgStar4.Prop.Picture.ImageIndex:=0;
  end;
end;

end.
