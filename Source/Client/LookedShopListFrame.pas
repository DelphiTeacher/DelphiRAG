unit LookedShopListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  DateUtils,
  uFuncCommon,
  uSkinItems,
  uBaseLog,
//  uOpenClientCommon,

  uBaseList,
  System.Math,

  uLang,

  EasyServiceCommonMaterialDataMoudle,
  MessageBoxFrame,
  WaitingFrame,

  uOpenCommon,
  uManager,
  uOpenClientCommon,
  uUIFunction,
  uTimerTask,
  XSuperObject,
  uRestInterfaceCall,
  uBaseHttpControl,

  uDataSetToJson,

  uDrawCanvas,


  uSkinFireMonkeyButton, uSkinCheckBoxType, uSkinFireMonkeyCheckBox,
  uSkinButtonType, uSkinNotifyNumberIconType, uSkinFireMonkeyNotifyNumberIcon,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox;

type
  TFrameLookedShopList = class(TFrame)
    lbShop: TSkinFMXListBox;
    idpShop: TSkinFMXItemDesignerPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    imgLogo: TSkinFMXImage;
    imgShopSign: TSkinFMXImage;
    imgStar1: TSkinFMXImage;
    imgStar2: TSkinFMXImage;
    imgStar3: TSkinFMXImage;
    imgStar4: TSkinFMXImage;
    imgStar5: TSkinFMXImage;
    lblDeliverFee: TSkinFMXLabel;
    lblDistance: TSkinFMXLabel;
    lblNumber: TSkinFMXLabel;
    lblScore: TSkinFMXLabel;
    lblShopName: TSkinFMXLabel;
    lbltag: TSkinFMXLabel;
    nniUserCartNumber: TSkinFMXNotifyNumberIcon;
    chkItemSelected: TSkinFMXCheckBox;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnEdit: TSkinFMXButton;
    btnOK: TSkinFMXButton;
    pnlDel: TSkinFMXPanel;
    chkEditAll: TSkinFMXCheckBox;
    btnDelete: TSkinFMXButton;
    lblTime: TSkinFMXLabel;
    procedure lbShopPullDownRefresh(Sender: TObject);
    procedure lbShopPullUpLoadMore(Sender: TObject);
    procedure lbShopPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure btnEditClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure lbShopClickItem(AItem: TSkinItem);
    procedure btnReturnClick(Sender: TObject);
    procedure chkEditAllChange(Sender: TObject);
  private
    FPageIndex:Integer;

    //我的足迹
    FFootPrintList:TFootPrintList;

    //购物车列表
    FCarShopList:TCarShopList;
    //删除
    FStringList:TStringList;
  private
    //获取购物车列表
    procedure GetUserCarGoodsList;
    //星星数量
    procedure GetShowStar(ANumber:Double);
    //从店铺详情返回
    procedure OnReturnFromShopInfoFrame(AFrame:TFrame);
  private
    //获取购物车列表
    procedure DoGetUserCarListExecute(ATimerTask:TObject);
    procedure DoGetUserCarListExecuteEnd(ATimerTask:TObject);
  private
    //获取足迹列表
    procedure DoGetFootListExecute(ATimerTask:TObject);
    procedure DoGetFootListExecuteEnd(ATimerTask:TObject);
  private
    //删除足迹
    procedure DoDelFootExecute(ATimerTask:TObject);
    procedure DoDelFootExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    //清除
    procedure Clear;
    //加载
    procedure Init;
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalLookedShopListFrame:TFrameLookedShopList;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame,
  ShopInfoFrame;

{ TFrameLookedShopList }

procedure TFrameLookedShopList.btnDeleteClick(Sender: TObject);
var
  ASelectNumber:Integer;
  I: Integer;
begin
  ASelectNumber:=0;
  FStringList.Clear;
  for I := 0 to Self.lbShop.Prop.Items.Count-1 do
  begin
    if Self.lbShop.Prop.Items[I].Checked=True then
    begin
      ASelectNumber:=ASelectNumber+1;
      FStringList.Add(Self.lbShop.Prop.Items[I].Detail4);
    end;
  end;

  FMX.Types.Log.d('OrangeUI TFrameLookedShopList '+FStringList.CommaText);

  if ASelectNumber=0 then
  begin
    ShowMessageBoxFrame(Self,'您还没有选择要删除的足迹!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  ShowWaitingFrame(Self,'删除中...');
  //删除收藏列表
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                DoDelFootExecute,
                DoDelFootExecuteEnd,
                'DelFoot');
end;

procedure TFrameLookedShopList.btnEditClick(Sender: TObject);
var
  I: Integer;
begin
  //编辑
  Self.chkItemSelected.Visible:=True;

  Self.btnOK.Visible:=True;

  Self.btnEdit.Visible:=False;

  for I := 0 to Self.lbShop.Prop.Items.Count-1 do
  begin
    if Self.lbShop.Prop.Items[I].Checked=True then
    begin
      Self.lbShop.Prop.Items[I].Checked:=False;
    end;
  end;

  Self.pnlDel.Visible:=True;

  Self.chkEditAll.Prop.Checked:=False;
end;

procedure TFrameLookedShopList.btnOKClick(Sender: TObject);
var
  I: Integer;
begin
  //完成
  Self.chkItemSelected.Visible:=False;

  Self.btnOK.Visible:=False;

  Self.btnEdit.Visible:=True;

  Self.pnlDel.Visible:=False;

end;

procedure TFrameLookedShopList.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameLookedShopList.chkEditAllChange(Sender: TObject);
var
  I: Integer;
begin
  if Self.chkEditAll.Prop.Checked=True then
  begin
    for I := 0 to Self.lbShop.Prop.Items.Count-1 do
    begin
      if Self.lbShop.Prop.Items[I].Checked=False then
      begin
        Self.lbShop.Prop.Items[I].Checked:=True;
      end;
    end;
  end
  else
  begin
    for I := 0 to Self.lbShop.Prop.Items.Count-1 do
    begin
      if Self.lbShop.Prop.Items[I].Checked=True then
      begin
        Self.lbShop.Prop.Items[I].Checked:=False;
      end;
    end;
  end;
end;

procedure TFrameLookedShopList.Clear;
begin
  Self.lbShop.Prop.Items.Clear(True);

  Self.btnOK.Visible:=False;
  Self.btnEdit.Visible:=False;

  Self.pnlDel.Visible:=False;

  Self.chkItemSelected.Visible:=False;
end;

constructor TFrameLookedShopList.Create(AOwner: TComponent);
begin
  inherited;
  FFootPrintList:=TFootPrintList.Create;
  //购物车列表
  FCarShopList:=TCarShopList.Create;
  //删除
  FStringList:=TStringList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameLookedShopList.Destroy;
begin
  FreeAndNil(FFootPrintList);
  FreeAndNil(FCarShopList);
  FreeAndNil(FStringList);
  inherited;
end;

procedure TFrameLookedShopList.DoDelFootExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('del_footprint',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'footprint_fids'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      FStringList.CommaText],
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

procedure TFrameLookedShopList.DoDelFootExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I:Integer;
begin
  try

    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //删除成功
        for I :=Self.lbShop.Prop.Items.Count-1 downto 0 do
        begin
          if Self.lbShop.Prop.Items[I].Checked=True then
          begin
            Self.lbShop.Prop.Items.Remove(Self.lbShop.Prop.Items[I]);
          end;
        end;

        if Self.lbShop.Prop.Items.Count=0 then
        begin
          Self.btnEdit.Visible:=False;
          Self.btnOK.Visible:=False;
          Self.pnlDel.Visible:=False;
        end
        else
        begin
          Self.btnOK.Visible:=True;
          Self.pnlDel.Visible:=True;
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


procedure TFrameLookedShopList.DoGetFootListExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_footprint_list',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'pagesize',
                                                      'pageindex',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      20,
                                                      FPageIndex,
                                                      GlobalManager.User.key],
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

procedure TFrameLookedShopList.DoGetFootListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AFootPrintList:TFootPrintList;
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin
  try

    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //获取成功
        if FPageIndex=1 then
        begin
          Self.lbShop.Prop.Items.Clear(True);
          FFootPrintList.Clear(True);
        end;

        AFootPrintList:=TFootPrintList.Create(ooReference);

        AFootPrintList.ParseFromJsonArray(TFootPrint,ASuperObject.O['Data'].A['FootPrintList']);

        if AFootPrintList.Count>0 then
        begin
          Self.btnEdit.Visible:=True;
        end
        else
        begin
          Self.btnEdit.Visible:=False;
        end;

        Self.lbShop.Prop.Items.BeginUpdate;
        try
          for I := 0 to AFootPrintList.Count-1 do
          begin
            AListBoxItem:=Self.lbShop.Prop.Items.Add;
            AListBoxItem.Data:=AFootPrintList[I];
            FFootPrintList.Add(AFootPrintList[I]);
            AListBoxItem.Caption:=AFootPrintList[I].FShop.name;
            AListBoxItem.Icon.Url:=AFootPrintList[I].FShop.Getlogopicpath;
            if AFootPrintList[I].FShop.is_new=1 then
            begin
              AListBoxItem.Pic.ImageIndex:=2;
            end
            else
            begin
              AListBoxItem.Pic.ImageIndex:=-1;
            end;
            AListBoxItem.Detail:=FloatToStr(AFootPrintList[I].FShop.num_ratings);
            AListBoxItem.Detail1:='月售'+IntToStr(AFootPrintList[I].FShop.recent_goods_popularity);
            AListBoxItem.Detail2:='起送价 '+Trans('￥')+FloatToStr(AFootPrintList[I].FShop.deliver_min_order_amount);
//            if (AFootPrintList[I].FShop.distance<1000) and (AFootPrintList[I].FShop.distance>=0) then
//            begin
//              AListBoxItem.Detail3:=FloatToStr(AFootPrintList[I].FShop.distance)+'m';
//            end
//            else
//            begin
//              AListBoxItem.Detail3:=FloatToStr(SimpleRoundTo(AFootPrintList[I].FShop.distance/1000,-1))+'km';
//            end;
            AListBoxItem.Detail4:=IntToStr(AFootPrintList[I].fid);
            AListBoxItem.Detail6:=IntToStr(AFootPrintList[I].FShop.fid);


            //当前是否正在营业
            AListBoxItem.Tag:=Ord(IsDoBusiness(AFootPrintList[I].FShop));


//            case DayofWeek(Now) of
//              1:
//               if AFootPrintList[I].FShop.sun_is_sale=1 then
//               begin
//                 if (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.sun_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.sun_end_time))=-1) then
//                 begin
//                   AListBoxItem.Tag:=1;
//                 end;
//               end
//               else
//               begin
//                 AListBoxItem.Tag:=0;
//               end;
//              2:
//               if AFootPrintList[I].FShop.mon_is_sale=1 then
//               begin
//                 if (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.mon_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.mon_end_time))=-1) then
//                 begin
//                   AListBoxItem.Tag:=1;
//                 end;
//               end
//               else
//               begin
//                 AListBoxItem.Tag:=0;
//               end;
//
//              3:
//               if AFootPrintList[I].FShop.tues_is_sale=1 then
//               begin
//                 if (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.tues_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.tues_end_time))=-1) then
//                 begin
//                   AListBoxItem.Tag:=1;
//                 end;
//               end
//               else
//               begin
//                 AListBoxItem.Tag:=0;
//               end;
//
//              4:
//               if AFootPrintList[I].FShop.wed_is_sale=1 then
//               begin
//                 if (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.wed_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.wed_end_time))=-1) then
//                 begin
//                   AListBoxItem.Tag:=1;
//                 end;
//               end
//               else
//               begin
//                 AListBoxItem.Tag:=0;
//               end;
//
//              5:
//               if AFootPrintList[I].FShop.thur_is_sale=1 then
//               begin
//                 if (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.thur_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.thur_end_time))=-1) then
//                 begin
//                   AListBoxItem.Tag:=1;
//                 end;
//               end
//               else
//               begin
//                 AListBoxItem.Tag:=0;
//               end;
//
//              6:
//               if AFootPrintList[I].FShop.fri_is_sale=1 then
//               begin
//                 if (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.fri_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.fri_end_time))=-1) then
//                 begin
//                   AListBoxItem.Tag:=1;
//                 end;
//               end
//               else
//               begin
//                 AListBoxItem.Tag:=0;
//               end;
//
//              7:
//               if AFootPrintList[I].FShop.sat_is_sale=1 then
//               begin
//                 if (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.sat_start_time))=1)and (CompareTime(Now,StandardStrToDateTime(AFootPrintList[I].FShop.sat_end_time))=-1) then
//                 begin
//                   AListBoxItem.Tag:=1;
//                 end;
//               end
//               else
//               begin
//                 AListBoxItem.Tag:=0;
//               end;
//
//            end;

            AListBoxItem.Tag1:=AFootPrintList[I].FShop.status;

          end;
        finally
          Self.lbShop.Prop.Items.EndUpdate();
        end;

        GetUserCarGoodsList;
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
    if FPageIndex>1 then
    begin
      if ASuperObject.O['Data'].A['FootPrintList'].Length>0 then
      begin
        Self.lbShop.Prop.StopPullUpLoadMore('加载成功!',0,True);
      end
      else
      begin
        Self.lbShop.Prop.StopPullUpLoadMore('下面没有了!',600,False);
      end;
    end
    else
    begin
      Self.lbShop.Prop.StopPullDownRefresh('刷新成功!',600);
    end;
  end;
end;


procedure TFrameLookedShopList.DoGetUserCarListExecute(ATimerTask: TObject);
begin
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_user_cart_goods_list',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'longitude',
                                                      'latitude'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      GlobalManager.Longitude,
                                                      GlobalManager.Latitude
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

procedure TFrameLookedShopList.DoGetUserCarListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  ANumber:Integer;
  J:Integer;
  K:Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        FCarShopList.Clear(True);
        //获取成功
        FCarShopList.ParseFromJsonArray(TCarShop,ASuperObject.O['Data'].A['CartGoodsList']);

        if Self.lbShop.Prop.Items.Count>0 then
        begin
          for I := 0 to Self.lbShop.Prop.Items.Count-1 do
          begin
            if (Self.lbShop.Prop.Items[I].Tag1=1)
                 and (Self.lbShop.Prop.Items[I].Tag=1) then
            begin
              for J := 0 to Self.FCarShopList.Count-1 do
              begin
                 ANumber:=0;
                 for K := 0 to Self.FCarShopList[J].FCarGoodList.Count-1 do
                 begin
                   ANumber:=ANumber+Self.FCarShopList[J].FCarGoodList[K].number;
                 end;

                 if StrToInt(Self.lbShop.Prop.Items[I].Detail6)=Self.FCarShopList[J].fid then
                 begin
                   Self.lbShop.Prop.Items[I].Detail5:=IntToStr(ANumber);
                 end;

              end;
            end
            else
            begin
              ANumber:=0;
              Self.lbShop.Prop.Items[I].Detail5:=IntToStr(ANumber);
            end;
          end;
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

  end;
end;


procedure TFrameLookedShopList.GetShowStar(ANumber: Double);
begin

  if (ANumber>=0) and (ANumber<1) then
  begin
    Self.imgStar1.Prop.Picture.ImageIndex:=1;
    Self.imgStar2.Prop.Picture.ImageIndex:=1;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;
    Self.imgStar5.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber>=1) and (ANumber<2) then
  begin
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=1;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;
    Self.imgStar5.Prop.Picture.ImageIndex:=1;
  end;


  if (ANumber>=2) and (ANumber<3) then
  begin
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=1;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;
    Self.imgStar5.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber>=3) and (ANumber<4) then
  begin
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=0;
    Self.imgStar4.Prop.Picture.ImageIndex:=1;
    Self.imgStar5.Prop.Picture.ImageIndex:=1;
  end;

  if (ANumber>=4) and (ANumber<5) then
  begin
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=0;
    Self.imgStar4.Prop.Picture.ImageIndex:=0;
    Self.imgStar5.Prop.Picture.ImageIndex:=1;
  end;

  if ANumber>=5 then
  begin
    Self.imgStar1.Prop.Picture.ImageIndex:=0;
    Self.imgStar2.Prop.Picture.ImageIndex:=0;
    Self.imgStar3.Prop.Picture.ImageIndex:=0;
    Self.imgStar4.Prop.Picture.ImageIndex:=0;
    Self.imgStar5.Prop.Picture.ImageIndex:=0;
  end;

end;

procedure TFrameLookedShopList.GetUserCarGoodsList;
begin
  //获取购物车列表
  uTimerTask.GetGlobalTimerThread.RunTempTask(
               DoGetUserCarListExecute,
               DoGetUserCarListExecuteEnd,
               'GetUserCarList');
end;

procedure TFrameLookedShopList.Init;
begin
  Self.Clear;

  Self.lbShop.Prop.StartPullDownRefresh;
end;

procedure TFrameLookedShopList.lbShopClickItem(AItem: TSkinItem);
begin
  if Self.chkItemSelected.Visible=False then
  begin
    //查看店铺详情
    //加载店铺详情
    HideFrame;//(Self,hfcttBeforeShowFrame);
    ShowFrame(TFrame(GlobalShopInfoFrame),TFrameShopInfo,OnReturnFromShopInfoFrame);
//    GlobalShopInfoFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalShopInfoFrame.Clear;
    if Self.FCarShopList.Count>0 then
    begin

      if Self.FCarShopList.FindItemByFID(StrToInt(AItem.Detail6))<>nil then
      begin
        GlobalShopInfoFrame.Load(StrToInt(AItem.Detail6),
                                Self.FCarShopList.FindItemByFID(StrToInt(AItem.Detail6)).FCarGoodList,
                                GlobalShopInfoFrame);
      end
      else
      begin
        GlobalShopInfoFrame.Load(StrToInt(AItem.Detail6),
                                  nil,
                                  GlobalShopInfoFrame);
      end;

    end
    else
    begin
      GlobalShopInfoFrame.Load(StrToInt(AItem.Detail6),
                              nil,
                              GlobalShopInfoFrame);
    end;
  end
  else
  begin
    AItem.Checked:=Not AItem.Checked;
  end;
end;

procedure TFrameLookedShopList.lbShopPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AFootPrint:TFootPrint;
begin
  if AItem.Data<>nil then
  begin
    AFootPrint:=TFootPrint(AItem.Data);
    GetShowStar(AFootPrint.FShop.num_ratings);
    if AItem.Tag1=1 then
    begin
      if AItem.Tag=1 then
      begin
        Self.lbltag.Visible:=False;
      end
      else
      begin
        Self.lbltag.Visible:=True;
        Self.lbltag.Caption:='商家休息中';
      end;
    end
    else
    begin
      Self.lbltag.Visible:=True;
      Self.lbltag.Caption:='暂停营业';
    end;

    if (DaysBetween(Now,StandardStrToDateTime(AFootPrint.createtime))>=0)
     and (DaysBetween(Now,StandardStrToDateTime(AFootPrint.createtime))<1) then
    begin
      Self.lblTime.Caption:='今天';
    end
    else if (DaysBetween(Now,StandardStrToDateTime(AFootPrint.createtime))>=1)
     and (DaysBetween(Now,StandardStrToDateTime(AFootPrint.createtime))<2) then
    begin
      Self.lblTime.Caption:='昨天';
    end
    else
    begin
      Self.lblTime.Caption:=AFootPrint.createtime;
    end;

  end;
end;


procedure TFrameLookedShopList.lbShopPullDownRefresh(Sender: TObject);
begin
  //获取足迹列表
  FPageIndex:=1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                DoGetFootListExecute,
                DoGetFootListExecuteEnd,
                'GetFootList');
end;

procedure TFrameLookedShopList.lbShopPullUpLoadMore(Sender: TObject);
begin
  //获取足迹列表
  FPageIndex:=FPageIndex+1;
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                DoGetFootListExecute,
                DoGetFootListExecuteEnd,
                'GetFootList');
end;

procedure TFrameLookedShopList.OnReturnFromShopInfoFrame(AFrame: TFrame);
begin
  GetUserCarGoodsList;
end;

end.
