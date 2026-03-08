unit GetEvalvateListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uUIFunction,
  uManager,

  uOpenCommon,
  uFrameContext,

  MessageBoxFrame,
  uOpenClientCommon,

  uDrawCanvas,
  uSkinItems,
  uSkinBufferBitmap,

  uTimerTask,
  uRestInterfaceCall,
  XSuperObject,

  WaitingFrame,

  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType,
  uSkinFireMonkeyListBox, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinImageType, uSkinFireMonkeyImage, uSkinTreeViewType,
  uSkinFireMonkeyTreeView, uDrawPicture, uSkinImageList, uSkinListViewType;

type
  TFrameGetEvalvateList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    tvEvalvate: TSkinFMXTreeView;
    idpShopName: TSkinFMXItemDesignerPanel;
    imgShipPic: TSkinFMXImage;
    lblShopName: TSkinFMXLabel;
    idpEva: TSkinFMXItemDesignerPanel;
    pnlTop: TSkinFMXPanel;
    lblUserName: TSkinFMXLabel;
    pnlTop1: TSkinFMXPanel;
    lblTag: TSkinFMXLabel;
    pnlTop2: TSkinFMXPanel;
    lblContent: TSkinFMXLabel;
    imgTag: TSkinFMXImage;
    imglistPic: TSkinImageList;
    idpEvaType: TSkinFMXItemDesignerPanel;
    lblType: TSkinFMXLabel;
    idpGoods: TSkinFMXItemDesignerPanel;
    lblGoodName: TSkinFMXLabel;
    idpChange: TSkinFMXItemDesignerPanel;
    btnChange: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lbEvalvatePrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure btnChangeClick(Sender: TObject);
    procedure tvEvalvatePrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
  private
    //订单
    FOrder:TOrder;

    //返回
    procedure OnReturnFromEvalueFrame(AFrame:TFrame);
  private
    //商家评论列表
    FShopEvaluateList:TEvaluateList;
    //骑手评论列表
    FRiderEvalvateList:TEvaluateList;


    FOrderFID:Integer;
    FDeliverCenterFID:Integer;
    //商家获取评论列表
    procedure DoShopperGetEvalvateExecute(ATimerTask:TObject);
    procedure DoShopperGetEvalvateExecuteEnd(ATimerTask:TObject);
    //获取骑手评论列表
    procedure DoGetRiderEvalvateListExecute(ATimerTask:TObject);
    procedure DoGetRiderEvalvateListExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    //清空
    procedure Clear;
    //加载订单
    procedure LoadOrder(AOrder:TOrder);
    //加载
    procedure Load(AOrderFID:Integer;ADeliverCenterFID:Integer);
  public
    FrameHistroy: TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalGetEvalvateListFrame:TFrameGetEvalvateList;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame,
  EvalvateFrame;

{ TFrameEvalvateList }

procedure TFrameGetEvalvateList.btnChangeClick(Sender: TObject);
var
  AEvalvate:TEvaluate;
  AIsAnonymous:Boolean;
  I: Integer;
begin

  for I := 0 to Self.tvEvalvate.Prop.InteractiveItem.Parent.Childs.Count-1 do
  begin
    if Self.tvEvalvate.Prop.InteractiveItem.Parent.Childs[I].ItemType=sitItem2 then
    begin
      AEvalvate:=TEvaluate(Self.tvEvalvate.Prop.InteractiveItem.Parent.Childs[I].Data);
    end;
  end;



  if AEvalvate.is_anonymous=1 then
  begin
    AIsAnonymous:=True;
  end
  else
  begin
    AIsAnonymous:=False;
  end;

  //隐藏
  HideFrame;//(Self,hfcttBeforeShowFrame);

  //显示评价页面
  ShowFrame(TFrame(GlobalEvalvateFrame),TFrameEvalvate,OnReturnFromEvalueFrame);
//  GlobalEvalvateFrame.FrameHistroy:=CurrentFrameHistroy;

  if AEvalvate.evaluate_type=Const_EvaluateType_UserEvaluateShop then
  begin

    //用户评价商家服务
    GlobalEvalvateFrame.Edit(Self.tvEvalvate.Prop.InteractiveItem.Parent.Caption,
                             AEvalvate.order_fid,
                             AEvalvate.to_fid,
                             '0',
                             AEvalvate.fid,
                             AEvalvate.score,
                             AEvalvate.tags,
                             AEvalvate.content,
                             AIsAnonymous,
                             FOrder
                             );
  end;

  if AEvalvate.evaluate_type=Const_EvaluateType_UserEvaluateRider then
  begin
    //用户评价骑手服务
    GlobalEvalvateFrame.Edit(Self.tvEvalvate.Prop.InteractiveItem.Parent.Caption,
                             AEvalvate.order_fid,
                             '0',
                             AEvalvate.to_fid,
                             AEvalvate.fid,
                             AEvalvate.score,
                             AEvalvate.tags,
                             AEvalvate.content,
                             AIsAnonymous,
                             FOrder
                             );
  end;

end;


procedure TFrameGetEvalvateList.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self, hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;


procedure TFrameGetEvalvateList.Clear;
begin
  FOrderFID:=0;
  FDeliverCenterFID:=0;

  Self.tvEvalvate.Prop.Items.Clear(True);
end;

constructor TFrameGetEvalvateList.Create(AOwner: TComponent);
begin
  inherited;

  //商家评论列表
  FShopEvaluateList:=TEvaluateList.Create;
  //骑手评论列表
  FRiderEvalvateList:=TEvaluateList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;


destructor TFrameGetEvalvateList.Destroy;
begin
  FreeAndNil(FShopEvaluateList);
  FreeAndNil(FRiderEvalvateList);
  inherited;
end;

procedure TFrameGetEvalvateList.DoGetRiderEvalvateListExecute(ATimerTask: TObject);
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
                                                      'filter_order_fid',
                                                      'filter_order_type',
                                                      'filter_from_fid',
                                                      'pageindex',
                                                      'pagesize'],
                                                      [AppID,
                                                       GlobalManager.User.fid,
                                                       '',
                                                       FDeliverCenterFID,
                                                       'delivery_center',
                                                       GlobalManager.User.fid,
                                                       1,20
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

procedure TFrameGetEvalvateList.DoGetRiderEvalvateListExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AParentTreeViewItem:TSkinTreeViewItem;
  ATreeViewItem:TSkinTreeViewItem;
  AChildTreeViewItem:TSkinTreeViewItem;
  ATagHeight:Double;
  AContentHeight:Double;
  I:Integer;
  J: Integer;
  K:Integer;
  AIsHaveRider:Boolean;
begin
  ATagHeight:=0;
  AContentHeight:=0;

  AIsHaveRider:=False;
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        FRiderEvalvateList.Clear(True);

        FRiderEvalvateList.ParseFromJsonArray(TEvaluate,ASuperObject.O['Data'].A['EvaluateObjectList']);

        Self.tvEvalvate.Prop.Items.BeginUpdate;
        try

          for I := 0 to Self.FRiderEvalvateList.Count-1 do
          begin
            if Self.FRiderEvalvateList[I].evaluate_type='user_evaluate_order_rider' then
            begin
              AIsHaveRider:=True;
            end
            else
            begin
              AIsHaveRider:=False;
            end;
          end;


          if AIsHaveRider=True then
          begin
            ATreeViewItem:=Self.tvEvalvate.Prop.Items.Add;
            ATreeViewItem.ItemType:=sitSpace;
            ATreeViewItem.Height:=10;

            AParentTreeViewItem:=Self.tvEvalvate.Prop.Items.Add;
            AParentTreeViewItem.ItemType:=sitDefault;
            AParentTreeViewItem.IsParent:=True;
            AParentTreeViewItem.Caption:='评价骑手服务';

            for K := 0 to Self.FRiderEvalvateList.Count-1 do
            begin
              if Self.FRiderEvalvateList[K].evaluate_type='user_evaluate_order_rider' then
              begin

                AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
                AChildTreeViewItem.ItemType:=sitItem2;
                AChildTreeViewItem.Data:=FRiderEvalvateList[K];
                if FRiderEvalvateList[K].score=1 then
                begin
                  AChildTreeViewItem.Caption:='很差';
                  AChildTreeViewItem.Pic.ImageIndex:=0;
                end;

                if FRiderEvalvateList[K].score=3 then
                begin
                  AChildTreeViewItem.Caption:='一般';
                  AChildTreeViewItem.Pic.ImageIndex:=1;
                end;

                if FRiderEvalvateList[K].score=5 then
                begin
                  AChildTreeViewItem.Caption:='满意';
                  AChildTreeViewItem.Pic.ImageIndex:=2;
                end;

                if FRiderEvalvateList[K].tags<>'' then
                begin
                  ATagHeight:=uSkinBufferBitmap.GetStringHeight(Self.FRiderEvalvateList[K].tags,
                                       RectF(40,0,Self.Width,MaxInt),
                                       Self.lblTag.SelfOwnMaterialToDefault.DrawCaptionParam)+20;
                end;

                if FRiderEvalvateList[K].content<>'' then
                begin
                  AContentHeight:=uSkinBufferBitmap.GetStringHeight(Self.FRiderEvalvateList[K].content,
                                       RectF(40,0,Self.Width,MaxInt),
                                       Self.lblContent.SelfOwnMaterialToDefault.DrawCaptionParam)+20;
                end;

                AChildTreeViewItem.Detail:=FRiderEvalvateList[K].tags;
                AChildTreeViewItem.Detail1:=FRiderEvalvateList[K].content;

                AChildTreeViewItem.Height:=30+ATagHeight+AContentHeight;

                AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
                AChildTreeViewItem.ItemType:=sitItem4;
                AChildTreeViewItem.Height:=40;
              end;

            end;
          end;

        finally
          Self.tvEvalvate.Prop.Items.EndUpdate();
        end;

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
  end;

end;
procedure TFrameGetEvalvateList.DoShopperGetEvalvateExecute(ATimerTask: TObject);
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
                                                      'filter_order_fid',
                                                      'filter_order_type',
                                                      'filter_from_fid',
                                                      'pageindex',
                                                      'pagesize'],
                                                      [AppID,
                                                       GlobalManager.User.fid,
                                                       '',
                                                       FOrderFID,
                                                       'shop_center',
                                                       GlobalManager.User.fid,
                                                       1,
                                                       20
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


procedure TFrameGetEvalvateList.DoShopperGetEvalvateExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AParentTreeViewItem:TSkinTreeViewItem;
  ATreeViewItem:TSkinTreeViewItem;
  AChildTreeViewItem:TSkinTreeViewItem;
  ATagHeight:Double;
  AContentHeight:Double;
  I:Integer;
  J: Integer;
  K:Integer;
  AIsHaveGood:Boolean;
  AIsHaveShop:Boolean;
begin
  ATagHeight:=0;
  AContentHeight:=0;
  AIsHaveGood:=False;
  AIsHaveShop:=False;
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        FShopEvaluateList.Clear(True);

        FShopEvaluateList.ParseFromJsonArray(TEvaluate,ASuperObject.O['Data'].A['EvaluateObjectList']);

        Self.tvEvalvate.Prop.Items.BeginUpdate;
        try

          for J := 0 to Self.FShopEvaluateList.Count-1 do
          begin
            if Self.FShopEvaluateList[J].evaluate_type='user_evaluate_order_shop' then
            begin
              AIsHaveShop:=True;
            end;

            if Self.FShopEvaluateList[J].evaluate_type='user_evaluate_order_goods' then
            begin
               AIsHaveGood:=True;
            end;

            if J=0 then
            begin
              ATreeViewItem:=Self.tvEvalvate.Prop.Items.Add;
              ATreeViewItem.ItemType:=sitHeader;
              ATreeViewItem.Caption:=FShopEvaluateList[J].shop_name;
              ATreeViewItem.Icon.Url:=FShopEvaluateList[J].GetShopPicPath;

              ATreeViewItem:=Self.tvEvalvate.Prop.Items.Add;
              ATreeViewItem.ItemType:=sitSpace;
              ATreeViewItem.Height:=10;
            end;
          end;

          if AIsHaveGood=True then
          begin
            AParentTreeViewItem:=Self.tvEvalvate.Prop.Items.Add;
            AParentTreeViewItem.ItemType:=sitDefault;
            AParentTreeViewItem.IsParent:=True;
            AParentTreeViewItem.Caption:='评价商品';

            for I := 0 to Self.FShopEvaluateList.Count-1 do
            begin
              if Self.FShopEvaluateList[I].evaluate_type='user_evaluate_order_goods' then
              begin

                AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
                AChildTreeViewItem.ItemType:=sitItem3;
                AChildTreeViewItem.Height:=30;
                AChildTreeViewItem.Caption:=FShopEvaluateList[I].goods_name;

                AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
                AChildTreeViewItem.ItemType:=sitItem2;
                AChildTreeViewItem.Data:=FShopEvaluateList[I];
                if FShopEvaluateList[I].score=1 then
                begin
                  AChildTreeViewItem.Caption:='很差';
                  AChildTreeViewItem.Pic.ImageIndex:=0;
                end;

                if FShopEvaluateList[I].score=3 then
                begin
                  AChildTreeViewItem.Caption:='一般';
                  AChildTreeViewItem.Pic.ImageIndex:=1;
                end;

                if FShopEvaluateList[I].score=5 then
                begin
                  AChildTreeViewItem.Caption:='满意';
                  AChildTreeViewItem.Pic.ImageIndex:=2;
                end;

                if FShopEvaluateList[I].tags<>'' then
                begin
                  ATagHeight:=uSkinBufferBitmap.GetStringHeight(Self.FShopEvaluateList[I].tags,
                                       RectF(40,0,Self.Width,MaxInt),
                                       Self.lblTag.SelfOwnMaterialToDefault.DrawCaptionParam)+20;
                end;

                AContentHeight:=0;
                if FShopEvaluateList[I].content<>'' then
                begin
                  AContentHeight:=uSkinBufferBitmap.GetStringHeight(Self.FShopEvaluateList[I].content,
                                       RectF(40,0,Self.Width,MaxInt),
                                       Self.lblContent.SelfOwnMaterialToDefault.DrawCaptionParam)+20;
                end;

                AChildTreeViewItem.Detail:=FShopEvaluateList[I].tags;
                AChildTreeViewItem.Detail1:=FShopEvaluateList[I].content;

                AChildTreeViewItem.Height:=30+ATagHeight+AContentHeight;


              end;
            end;

            ATreeViewItem:=Self.tvEvalvate.Prop.Items.Add;
            ATreeViewItem.ItemType:=sitSpace;
            ATreeViewItem.Height:=10;

          end;

          if AIsHaveShop=True then
          begin
            AParentTreeViewItem:=Self.tvEvalvate.Prop.Items.Add;
            AParentTreeViewItem.ItemType:=sitDefault;
            AParentTreeViewItem.IsParent:=True;
            AParentTreeViewItem.Caption:='评价商家服务';

            for K := 0 to Self.FShopEvaluateList.Count-1 do
            begin
              if Self.FShopEvaluateList[K].evaluate_type='user_evaluate_order_shop' then
              begin
                AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
                AChildTreeViewItem.ItemType:=sitItem2;
                AChildTreeViewItem.Data:=FShopEvaluateList[K];
                if FShopEvaluateList[K].score=1 then
                begin
                  AChildTreeViewItem.Caption:='很差';
                  AChildTreeViewItem.Pic.ImageIndex:=0;
                end;

                if FShopEvaluateList[K].score=3 then
                begin
                  AChildTreeViewItem.Caption:='一般';
                  AChildTreeViewItem.Pic.ImageIndex:=1;
                end;

                if FShopEvaluateList[K].score=5 then
                begin
                  AChildTreeViewItem.Caption:='满意';
                  AChildTreeViewItem.Pic.ImageIndex:=2;
                end;

                if FShopEvaluateList[K].tags<>'' then
                begin
                  ATagHeight:=uSkinBufferBitmap.GetStringHeight(Self.FShopEvaluateList[K].tags,
                                       RectF(40,0,Self.Width,MaxInt),
                                       Self.lblTag.SelfOwnMaterialToDefault.DrawCaptionParam)+20;
                end;

                AContentHeight:=0;
                if FShopEvaluateList[K].content<>'' then
                begin
                  AContentHeight:=uSkinBufferBitmap.GetStringHeight(Self.FShopEvaluateList[K].content,
                                       RectF(40,0,Self.Width,MaxInt),
                                       Self.lblContent.SelfOwnMaterialToDefault.DrawCaptionParam)+20;
                end;

                AChildTreeViewItem.Detail:=FShopEvaluateList[K].tags;
                AChildTreeViewItem.Detail1:=FShopEvaluateList[K].content;

                AChildTreeViewItem.Height:=30+ATagHeight+AContentHeight;

                AChildTreeViewItem:=AParentTreeViewItem.Childs.Add;
                AChildTreeViewItem.ItemType:=sitItem4;
                AChildTreeViewItem.Height:=40;
              end;
            end;
          end;

        finally
          Self.tvEvalvate.Prop.Items.EndUpdate();
        end;

        {$IFNDEF YC}  //亿诚加了骑手端
        uTimerTask.GetGlobalTimerThread.RunTempTask(
                          DoGetRiderEvalvateListExecute,
                          DoGetRiderEvalvateListExecuteEnd,
                          'GetRiderEvalvateList');
        {$ENDIF}
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
  end;

end;

procedure TFrameGetEvalvateList.lbEvalvatePrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
  if AItem.Data<>nil then
  begin

    if AItem.Detail2='' then
    begin
      Self.pnlTop2.Visible:=False;
    end
    else
    begin
      Self.pnlTop2.Visible:=True;
    end;

    Self.pnlTop1.Height:=uSkinBufferBitmap.GetStringHeight(AItem.Detail1,
                           RectF(40,0,Self.Width-10,MaxInt),
                           Self.lblTag.SelfOwnMaterialToDefault.DrawCaptionParam);

    Self.pnlTop2.Height:=uSkinBufferBitmap.GetStringHeight(AItem.Detail2,
                           RectF(20,0,Self.Width-10,MaxInt),
                           Self.lblContent.SelfOwnMaterialToDefault.DrawCaptionParam);
  end;

end;

procedure TFrameGetEvalvateList.LoadOrder(AOrder: TOrder);
begin
  FOrder:=AOrder;
end;

procedure TFrameGetEvalvateList.OnReturnFromEvalueFrame(AFrame: TFrame);
begin
  Self.Load(Self.FOrder.fid,Self.FOrder.delivery_center_order_fid);
end;

procedure TFrameGetEvalvateList.Load(AOrderFID:Integer;ADeliverCenterFID:Integer);
begin
  Clear;

  FOrderFID:=AOrderFID;
  FDeliverCenterFID:=ADeliverCenterFID;
  //用户获取订单评论列表
  uTimerTask.GetGlobalTimerThread.RunTempTask(
              DoShopperGetEvalvateExecute,
              DoShopperGetEvalvateExecuteEnd,
              'ShopperGetEvalvate');
end;

procedure TFrameGetEvalvateList.tvEvalvatePrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
  if AItem.Data<>nil then
  begin
    if AItem.ItemType=sitItem2 then
    begin



        Self.lblTag.Height:=uSkinBufferBitmap.GetStringHeight(AItem.Detail,
                           RectF(40,0,Self.Width,MaxInt),
                           Self.lblTag.SelfOwnMaterialToDefault.DrawCaptionParam)+20;



        Self.lblContent.Height:=uSkinBufferBitmap.GetStringHeight(AItem.Detail1,
                           RectF(40,0,Self.Width,MaxInt),
                           Self.lblContent.SelfOwnMaterialToDefault.DrawCaptionParam)+20;


    end;
  end;
end;

end.
