unit HomeAddrFrame;

interface


//默认使用百度路线规划

//{$IFDEF MSWINDOWS}
//  //Windows下使用谷歌路线规划
//  {$DEFINE USE_GOOGLE_ROUTE_PLAN}
//{$ENDIF}

//{$IFDEF ANDROID}
//  //Android下使用谷歌路线规划
//  {$DEFINE USE_GOOGLE_ROUTE_PLAN}
//{$ENDIF}

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uBufferBitmap,
  uGPSLocation,
  uGPSUtils,

  uUIFunction,
  uTimerTask,
  uAppCommon,

  uSkinMaterial,
  uRestInterfaceCall,
  uManager,
  uBaseHttpControl,
  uSkinListBoxType,
  uOpenClientCommon,
  uOpenCommon,

  HintFrame,
  WaitingFrame,
  MessageBoxFrame,
  EasyServiceCommonMaterialDataMoudle,


  XSuperObject,
  XSuperJson,


  uDrawCanvas,
  uSkinItems,
  uBaseList,



  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollBoxContentType,
  uSkinFireMonkeyScrollBoxContent, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinFireMonkeyScrollBox, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinCustomListType, uSkinVirtualListType, uSkinFireMonkeyListBox,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinListViewType, uSkinFireMonkeyListView;

type
  TFrameHomeAddr = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    btnAddr: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlEmpty: TSkinFMXPanel;
    pnlEmpty6: TSkinFMXPanel;
    btnSearch: TSkinFMXButton;
    pnlCurrentAddr: TSkinFMXPanel;
    lblAddr: TSkinFMXLabel;
    lblAddrValue: TSkinFMXLabel;
    btnUpDateAddr: TSkinFMXButton;
    pnlAddrList: TSkinFMXPanel;
    lblRecv: TSkinFMXLabel;
    btnAdd: TSkinFMXButton;
    lbAddrList: TSkinFMXListBox;
    idpItem: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    lblDetail1: TSkinFMXLabel;
    lblDetail2: TSkinFMXLabel;
    lbltag: TSkinFMXLabel;
    lblDetail3: TSkinFMXLabel;
    pnlMore: TSkinFMXPanel;
    lblRecent: TSkinFMXLabel;
    btnMore: TSkinFMXButton;
    lvSome: TSkinFMXListView;
    idpSome: TSkinFMXItemDesignerPanel;
    lblTwo: TSkinFMXLabel;
    pnlSome: TSkinFMXPanel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnUpDateAddrClick(Sender: TObject);
    procedure btnAddrClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure lbAddrListClickItem(AItem: TSkinItem);
    procedure lblAddrValueClick(Sender: TObject);
    procedure lbAddrListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure FrameResize(Sender: TObject);
    procedure pnlSomeResize(Sender: TObject);
    procedure lvSomeClickItem(AItem: TSkinItem);
    procedure btnMoreClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
  private
    FIsNeedLocate:Boolean;

    //收货地址列表
    FUserRecvAddrList:TUserRecvAddrList;

    //设置高度
    procedure SetingFrameHeight;
  private
    //获取地址列表
    procedure DoGetAddrListExecute(ATimerTask:TObject);
    procedure DoGetAddrListExecuteEnd(ATimerTask:TObject);
  private
    //从添加收货地址返回
    procedure OnReturnFromAddAddrFrame(AFrame:TFrame);
    //从选择附近地址返回
    procedure OnReturnFromSelectAddrFrame(AFrame:TFrame);
    //从自动补全地址返回
    procedure OnReturnFromSelectAutoAddrFrame(AFrame:TFrame);
  private
    //定位
    procedure DoGetUserPositionExecute(ATimerTask:TObject);
    procedure DoGetUserPositionExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    FFilterUserAddr:String;
    //清空
    procedure Clear;
    //定位
    procedure Load;
    //加载收货地址列表
    procedure LoadRecvAddrList;

    //更新定位
    procedure SyncLocation;
  public
    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    //开始定位
    procedure DoStartLocation;
    //定位改变
    procedure DoLocationChange;
    //定位超时
    procedure DoLocationTimeout;
    //定位启动失败
    procedure DoLocationStartError;

    //地址改变
    procedure DoLocationAddrChange;
    //地址解析失败
    procedure DoGeocodeAddrError;
    //地址解析失败
    procedure DoGeocodeAddrTimeout;
    { Public declarations }
  end;

var
  GlobalHomeAddrFrame:TFrameHomeAddr;

implementation

{$R *.fmx}
uses
  MainForm,
  MainFrame,
  GetAddrListFrame,
  AddRecvAddrFrame,
  RecvAddrListFrame;

procedure TFrameHomeAddr.btnAddClick(Sender: TObject);
begin
  //跳转到添加收货地址页面
  HideFrame(Self,hfcttBeforeShowFrame);
  ShowFrame(TFrame(GlobalAddRecvAddrFrame),TFrameAddRecvAddr,frmMain,nil,nil,OnReturnFromAddAddrFrame,Application);
//  GlobalAddRecvAddrFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalAddRecvAddrFrame.Clear;
  GlobalAddRecvAddrFrame.Add;
end;

procedure TFrameHomeAddr.btnAddrClick(Sender: TObject);
begin
  //跳转到收货地址列表
  //隐藏
  HideFrame(GlobalMainFrame,hfcttBeforeShowFrame);
  //显示收货地址列表
  ShowFrame(TFrame(GlobalRecvAddrListFrame),TFrameRecvAddrList,frmMain,nil,nil,OnReturnFromAddAddrFrame,Application);
//  GlobalRecvAddrListFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalRecvAddrListFrame.Clear;
  GlobalRecvAddrListFrame.Load(
                            '收货地址',
                            futManage,
                            -1
                            );
end;

procedure TFrameHomeAddr.btnMoreClick(Sender: TObject);
begin
  HideFrame(Self,hfcttBeforeShowframe);
  ShowFrame(TFrame(GlobalGetAddrListFrame),TFrameGetAddrList,frmMain,nil,nil,OnReturnFromSelectAddrFrame,Application);

//  GlobalGetAddrListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalGetAddrListFrame.Syc;
end;

procedure TFrameHomeAddr.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then Exit;

  //什么也不做
  //清空返回事件,也就是返回的时候不调用它
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

  HideFrame(Self,hfcttBeforeReturnFrame);
  ReturnFrame(Self.FrameHistroy);
end;

procedure TFrameHomeAddr.btnSearchClick(Sender: TObject);
begin
  HideFrame(Self,hfcttBeforeShowframe);
  ShowFrame(TFrame(GlobalGetAddrListFrame),TFrameGetAddrList,frmMain,nil,nil,OnReturnFromSelectAutoAddrFrame,Application);

//  GlobalGetAddrListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalGetAddrListFrame.Load(Self.btnSearch.Caption,
                              GlobalManager.Addr,
                              '',
                              '',
                              '',
                              '',
                              GlobalManager.Latitude,
                              GlobalManager.longitude,
                              True,
                              False,
                              True);
end;

procedure TFrameHomeAddr.btnUpDateAddrClick(Sender: TObject);
begin
  FIsNeedLocate:=True;
  frmMain.tmrStartLocation.Enabled:=True;
end;

procedure TFrameHomeAddr.Clear;
begin
//  Self.btnCity.Caption:='定位中...';
  Self.btnSearch.Caption:='';

  Self.lblAddrValue.Caption:='正在定位,请稍后...';

  Self.lbAddrList.Prop.Items.Clear(True);

  Self.lvSome.Prop.Items.Clear(True);


  Self.pnlAddrList.Visible:=False;

  Self.pnlSome.Visible:=False;

  Self.btnAddr.Visible:=False;
end;

constructor TFrameHomeAddr.Create(AOwner: TComponent);
begin
  inherited;
  Self.lbAddrList.Prop.Items.Clear(True);

  FUserRecvAddrList:=TUserRecvAddrList.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  Self.btnAdd.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;
  Self.lbltag.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;
  Self.lbltag.SelfOwnMaterialToDefault.BackColor.BorderColor.Color:=SkinThemeColor;
  Self.btnUpDateAddr.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;
end;

destructor TFrameHomeAddr.Destroy;
begin
  FreeAndNil(FUserRecvAddrList);
  inherited;
end;

procedure TFrameHomeAddr.DoGetAddrListExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('get_user_recv_addr_list',
                          nil,
                          UserCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'key'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          GlobalManager.User.key
                          ],
                                        GlobalRestAPISignType,
                                        GlobalRestAPIAppSecret
                          );
    if TTimerTask(ATimerTask).TaskDesc<>'' then
    begin
      TTimerTask(ATimerTask).TaskTag:=0;
    end;

  except
    on E:Exception do
    begin
    //异常
    TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;

end;

procedure TFrameHomeAddr.DoGetAddrListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AListBoxItem:TSkinListBoxItem;
  I:Integer;
  AHeight:Double;
  AWidth:Double;
  ACaptionHeight:Double;
begin
  AHeight:=0;
  AWidth:=0;
  ACaptionHeight:=0;
  if TTimerTask(ATimerTask).TaskTag=0 then
  begin
    ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
    if ASuperObject.I['Code']=200 then
    begin

      if ASuperObject.O['Data'].A['UserRecvAddrList'].Length<1 then
      begin
//        //加载page1页面
//        Self.pcRecvList.Prop.ActivePage:=Self.tbPage1;
          Self.SetingFrameHeight;
      end
      else
      begin
        //加载列表
        Self.FUserRecvAddrList.ParseFromJsonArray(TUserRecvAddr,ASuperObject.O['Data'].A['UserRecvAddrList']);
        Self.lbAddrList.Prop.Items.BeginUpdate;
        try

          Self.lbAddrList.Prop.Items.Clear(True);

          for I := 0 to ASuperObject.O['Data'].A['UserRecvAddrList'].Length-1 do
          begin

            AListBoxItem:=Self.lbAddrList.Prop.Items.Add;
            AListBoxItem.Data:=FUserRecvAddrList[I];
            if ASuperObject.O['Data'].A['UserRecvAddrList'].O[I].I['sex']=0 then
            begin
              AListBoxItem.Detail2:=ASuperObject.O['Data'].A['UserRecvAddrList'].O[I].S['name']+
                                                 '  '+'男士';
            end
            else if ASuperObject.O['Data'].A['UserRecvAddrList'].O[I].I['sex']=1 then
            begin
              AListBoxItem.Detail2:=ASuperObject.O['Data'].A['UserRecvAddrList'].O[I].S['name']+
                                                 '  '+'女士';
            end
            else
            begin
              AListBoxItem.Detail2:=ASuperObject.O['Data'].A['UserRecvAddrList'].O[I].S['name'];

            end;

            AListBoxItem.Detail3:=ASuperObject.O['Data'].A['UserRecvAddrList'].O[I].S['phone'];
            AListBoxItem.Caption:=ASuperObject.O['Data'].A['UserRecvAddrList'].O[I].S['street'];

            ACaptionHeight:=uBufferBitmap.GetStringHeight(ASuperObject.O['Data'].A['UserRecvAddrList'].O[I].S['street'],
                                                          RectF(0,0,Self.Width-100,MaxInt),
                                                          Self.lblCaption.SelfOwnMaterialToDefault.DrawCaptionParam);

            FMX.Types.Log.d('OrangeUI ACaptionHeight'+FloatToStr(ACaptionHeight));



            AWidth:=uBufferBitmap.GetStringWidth(ASuperObject.O['Data'].A['UserRecvAddrList'].O[I].S['addr'],Self.lblCaption.Material.DrawCaptionParam.FontSize);

            if AWidth>Self.Width then
            begin
              AListBoxItem.Detail6:=FloatToStr(Self.Width-10);
            end
            else
            begin
              AListBoxItem.Detail6:=FloatToStr(AWidth+10);
            end;


            AListBoxItem.Detail1:=ASuperObject.O['Data'].A['UserRecvAddrList'].O[I].S['addr'];

            AHeight:=uBufferBitmap.GetStringHeight(ASuperObject.O['Data'].A['UserRecvAddrList'].O[I].S['addr'],
                                                          RectF(0,0,Self.Width-60,MaxInt),
                                                          Self.lblDetail1.SelfOwnMaterialToDefault.DrawCaptionParam);


            FMX.Types.Log.d('OrangeUI AHeight'+FloatToStr(AHeight));

            AListBoxItem.Detail:=ASuperObject.O['Data'].A['UserRecvAddrList'].O[I].S['tag'];


            AListBoxItem.Height:=ACaptionHeight+AHeight+50;

            FMX.Types.Log.d('OrangeUI AListBoxItem Height'+FloatToStr(AListBoxItem.Height));
          end;

        finally
          Self.lbAddrList.Prop.Items.EndUpdate();
        end;

        Self.SetingFrameHeight;

      end;

    end
    else
    begin
      //获取失败
      ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
    end;

  end
  else if TTimerTask(ATimerTask).TaskTag=1 then
  begin
    //网络异常
    ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
  end;


end;

procedure TFrameHomeAddr.DoGetUserPositionExecute(ATimerTask: TObject);
var
  AResponseStream:TStringStream;
  AHttpControl:THttpControl;
  AIsSuccProcess:Boolean;
begin
  try
    AIsSuccProcess:=False;
    //出错
    TTimerTask(ATimerTask).TaskTag:=1;

    AHttpControl:=TSystemHttpControl.Create;
    AResponseStream:=TStringStream.Create('',TEncoding.Utf8);
    try
        {$IFDEF USE_GOOGLE_ROUTE_PLAN}
        //国外
        //调谷歌接口
        AIsSuccProcess:=//AHttpControl.Get(
            GetWebUrl_From_OrangeUIServer(AHttpControl,
                      'https://maps.googleapis.com'
                          +'/maps/api/geocode/json?'
                          +'latlng='+FloatToStr(GlobalGPSLocation.Latitude)
                                  +','+FloatToStr(GlobalGPSLocation.Longitude)//固定地址
                          +'&key='+GoogleAPIKey,
                          AResponseStream
                  );

        {$ELSE}
        //国内
        //调用百度接口
        //把返回的数据放入AResponseStream
        AIsSuccProcess:=AHttpControl.Get(
//            GetWebUrl_From_OrangeUIServer(AHttpControl,
                  'http://api.map.baidu.com'
                    +'/geocoder/v2/?'
                    +'location='+FloatToStr(GlobalGPSLocation.Latitude)
                            +','+FloatToStr(GlobalGPSLocation.Longitude)//固定地址
                    +'&output=json'
                    +'&pois=1'
                    +'&radius=1000'
                    +'&coordtype=gcj02ll'
                    +'&ak='+BaiduAPIKey
                    ,
                    AResponseStream
                    );
        {$ENDIF}



        TTimerTask(ATimerTask).TaskDesc:=AResponseStream.DataString;

        if AIsSuccProcess=True then
        begin
          TTimerTask(ATimerTask).TaskTag:=0;
        end
        else
        begin
          TTimerTask(ATimerTask).TaskTag:=1;
        end;

    finally
      AResponseStream.Free;
      FreeAndNil(AHttpControl);
    end;
  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;
end;

procedure TFrameHomeAddr.DoGetUserPositionExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AListViewItem:TSkinListViewItem;
  ANumber:Integer;
  J: Integer;
begin
  ANumber:=0;
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

        FMX.Types.Log.d('OrangeUI DoGetUserPositionExecuteEnd'+ASuperObject.AsJSON);
        Self.lvSome.Prop.Items.BeginUpdate;
        Self.lvSome.Prop.Items.Clear(True);
        try
            {$IFDEF USE_GOOGLE_ROUTE_PLAN}
              //谷歌地址解析
              if ASuperObject.S['status']='OK' then
              begin

                  if ASuperObject.A['results'].Length>=4 then
                  begin
                    ANumber:=3;
                  end
                  else
                  begin
                    ANumber:=ASuperObject.A['results'].Length;
                  end;

                  for J := 0 to ANumber do
                  begin
                    AListViewItem:=Self.lvSome.Prop.Items.Add;
                    AListViewItem.Caption:=ASuperObject.A['results'].O[J].A['address_components'].O[0].S['long_name'];
                    AListViewItem.Detail6:=ASuperObject.A['results'].O[J].AsJSON;
                    AListViewItem.Width:=uBufferBitmap.GetStringWidth(ASuperObject.A['results'].O[J].A['address_components'].O[0].S['long_name'],12)+40;

                  end;

              end;

            {$ELSE}
                //百度地址解析
                //加载附近地址
                if ASuperObject.O['result'].A['pois'].Length>=4 then
                begin
                  ANumber:=3;
                end
                else
                begin
                  ANumber:=ASuperObject.O['result'].A['pois'].Length;
                end;


                for I := 0 to ANumber do
                begin
                  AListViewItem:=Self.lvSome.Prop.Items.Add;
                  AListViewItem.Caption:=ASuperObject.O['result'].A['pois'].O[I].S['name'];
                  AListViewItem.Detail6:=ASuperObject.O['result'].A['pois'].O[I].AsJSON;
                  AListViewItem.Width:=uBufferBitmap.GetStringWidth(ASuperObject.O['result'].A['pois'].O[I].S['name'],12)+40;
                end;

            {$ENDIF}

        finally
          Self.lvSome.Prop.Items.EndUpdate();
        end;



        SetingFrameHeight;

    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowHintFrame(Self,'网络异常,请检查您的网络连接!');//,TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;


procedure TFrameHomeAddr.DoLocationAddrChange;
begin
  FMX.Types.Log.d('OrangeUI TFrameHomeAddr.DoLocationAddrChange Begin');



  FMX.Types.Log.d('OrangeUI TFrameHomeAddr.DoLocationAddrChange End');
end;

procedure TFrameHomeAddr.DoLocationChange;
begin
  SyncLocation;

  //点击重新定位,只获取一次
  if FIsNeedLocate then
  begin
    FIsNeedLocate:=False;

    //不需要重新加载收货地址
//    Self.LoadRecvAddrList;

    Self.Load;
  end;
end;

procedure TFrameHomeAddr.DoGeocodeAddrError;
begin
  lblAddrValue.Caption:='地址解析出错了...';
  ShowMessageBoxFrame(frmMain,'地址解析失败!');
end;

procedure TFrameHomeAddr.DoGeocodeAddrTimeout;
begin
  lblAddrValue.Caption:='地址解析超时了...';
  ShowMessageBoxFrame(frmMain,'地址解析超时!');
end;

procedure TFrameHomeAddr.DoLocationStartError;
begin
  lblAddrValue.Caption:='地址出错了...';
  ShowMessageBoxFrame(frmMain,'定位失败!');
end;

procedure TFrameHomeAddr.DoLocationTimeout;
begin
  lblAddrValue.Caption:='地址出错了...';
  ShowHintFrame(frmMain,'定位超时!');
end;

procedure TFrameHomeAddr.DoStartLocation;
begin

end;

procedure TFrameHomeAddr.FrameResize(Sender: TObject);
begin
  Self.lvSome.Height:=Self.lvSome.Prop.GetContentHeight+40;

  Self.pnlSome.Height:=Self.pnlMore.Height+Self.lvSome.Height;

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;

procedure TFrameHomeAddr.lbAddrListClickItem(AItem: TSkinItem);
var
  AUserRecvAddr:TUserRecvAddr;
begin
  if AItem.Data<>nil then
  begin
    AUserRecvAddr:=TUserRecvAddr(AItem.Data);

    FFilterUserAddr:=AUserRecvAddr.addr;

    GlobalManager.IsGPSLocated:=True;

    GlobalManager.Addr:=AUserRecvAddr.addr;
    GlobalManager.RegionName:=AUserRecvAddr.addr;

    GlobalManager.Longitude:=AUserRecvAddr.longitude;
    GlobalManager.Latitude:=AUserRecvAddr.latitude;
  end;
  //返回，刷新地址
  HideFrame(Self,hfcttBeforeReturnFrame);
  ReturnFrame(Self.FrameHistroy);
end;

procedure TFrameHomeAddr.lbAddrListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AUserRecvAddr:TUserRecvAddr;
begin
//  Self.lblCaption.Width:=StrToFloat(AItem.Detail6);
  if AItem.Data<>nil then
  begin
    AUserRecvAddr:=TUserRecvAddr(AItem.Data);

    if Trim(AUserRecvAddr.tag)='' then
    begin
      Self.lbltag.Visible:=False;
    end
    else
    begin
      Self.lbltag.Visible:=True;
    end;


    if AItem.Caption<>'' then
    begin
      Self.lblCaption.Height:=uBufferBitmap.GetStringHeight(AItem.Caption,
                                                            RectF(0,0,Self.Width-100,MaxInt),
                                                            Self.lblCaption.SelfOwnMaterialToDefault.DrawCaptionParam)+10;

    end;

    if AItem.Detail1<>'' then
    begin

      Self.lblDetail1.Height:=uBufferBitmap.GetStringHeight(AItem.Detail1,
                                                          RectF(0,0,Self.Width-60,MaxInt),
                                                          Self.lblDetail1.SelfOwnMaterialToDefault.DrawCaptionParam)+10;

    end;
  end;
end;

procedure TFrameHomeAddr.lblAddrValueClick(Sender: TObject);
begin
  if GlobalManager.IsGPSLocated then
  begin


    GlobalManager.Addr:=GlobalGPSLocation.Addr;
//    {$IFDEF NZ}
//    GlobalManager.RegionName:=GlobalGPSLocation.City+' '+GlobalGPSLocation.Province;
//    {$ELSE}
//    GlobalManager.RegionName:=GlobalGPSLocation.Province+GlobalGPSLocation.City;
//    {$ENDIF}
    GlobalManager.RegionName:=GlobalGPSLocation.RegionName;


    //返回，刷新地址
    HideFrame(Self,hfcttBeforeReturnFrame);
    ReturnFrame(Self.FrameHistroy);
  end;
end;

procedure TFrameHomeAddr.Load;
begin
  Self.pnlSome.Visible:=True;

  //调用定位接口
  if GlobalGPSLocation.HasLocated=True then
  begin
    //获取地址
    ShowWaitingFrame(Self,'获取中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                DoGetUserPositionExecute,
                DoGetUserPositionExecuteEnd,
                'GetUserPosition');
  end;
end;

procedure TFrameHomeAddr.LoadRecvAddrList;
begin

  SyncLocation;

  if GlobalManager.IsLogin=True then
  begin
    Self.pnlAddrList.Visible:=True;

    Self.btnAddr.Visible:=True;

    //获取地址列表
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                   DoGetAddrListExecute,
                   DoGetAddrListExecuteEnd,
                   'GetAddrList');
  end
  else
  begin
    Self.btnAddr.Visible:=False;

    Self.pnlAddrList.Visible:=False;
  end;

  SetingFrameHeight;
end;

procedure TFrameHomeAddr.lvSomeClickItem(AItem: TSkinItem);
var
  ASuperObject:ISuperObject;
begin

  ASuperObject:=TSuperObject.Create(AItem.Detail6);


  GlobalManager.IsGPSLocated:=True;
  GlobalManager.Addr:=AItem.Caption;
  GlobalManager.RegionName:=AItem.Caption;

  {$IFDEF USE_GOOGLE_ROUTE_PLAN}
  //谷歌地址解析
  GlobalManager.Longitude:=ASuperObject.O['geometry'].O['location'].F['lng'];
  GlobalManager.Latitude:=ASuperObject.O['geometry'].O['location'].F['lat'];
  {$ELSE}
  //百度地址解析
  GlobalManager.Longitude:=ASuperObject.O['point'].F['x'];
  GlobalManager.Latitude:=ASuperObject.O['point'].F['y'];
  {$ENDIF}

  bd09ll_Gcj02(GlobalManager.Latitude,GlobalManager.Longitude,GlobalManager.Latitude,GlobalManager.Longitude);

  HideFrame(Self,hfcttBeforeReturnFrame);
  ReturnFrame(Self.FrameHistroy);
end;

procedure TFrameHomeAddr.OnReturnFromAddAddrFrame(AFrame: TFrame);
begin
  LoadRecvAddrList;
end;

procedure TFrameHomeAddr.OnReturnFromSelectAddrFrame(AFrame: TFrame);
begin
  if GlobalGetAddrListFrame.FSelectedAddr<>'' then
  begin
    GlobalManager.IsGPSLocated:=True;

    GlobalManager.RegionName:=GlobalGetAddrListFrame.FSelectedAddr;


    GlobalManager.Addr:=GlobalGetAddrListFrame.FSelectedAddr;
    GlobalManager.Latitude:=GlobalGetAddrListFrame.FSelectedLat;
    GlobalManager.Longitude:=GlobalGetAddrListFrame.FSelectedLng;


    bd09ll_Gcj02(GlobalManager.Latitude,GlobalManager.Longitude,GlobalManager.Latitude,GlobalManager.Longitude);


    //返回
    HideFrame(Self,hfcttBeforeReturnFrame);
    ReturnFrame(Self.FrameHistroy);
  end;
end;

procedure TFrameHomeAddr.OnReturnFromSelectAutoAddrFrame(AFrame: TFrame);
begin
  GlobalManager.Addr:=GlobalGetAddrListFrame.FSelectedAddr;
  GlobalManager.RegionName:=GlobalGetAddrListFrame.FCity;

  Self.FFilterUserAddr:=GlobalGetAddrListFrame.FSelectedAddr;

  GlobalManager.Latitude:=GlobalGetAddrListFrame.FSelectedLat;
  GlobalManager.Longitude:=GlobalGetAddrListFrame.FSelectedLng;

//  Self.btnCity.Caption:=GlobalGetAddrListFrame.FCity;

  Self.btnSearch.Caption:=GlobalGetAddrListFrame.FSelectedAddr;

  //返回，刷新地址
  HideFrame(Self,hfcttBeforeReturnFrame);
  ReturnFrame(Self.FrameHistroy);
end;

procedure TFrameHomeAddr.pnlSomeResize(Sender: TObject);
begin
  Self.lvSome.Height:=Self.lvSome.Prop.GetContentHeight+40;

  Self.pnlSome.Height:=Self.pnlMore.Height+Self.lvSome.Height;


  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;

procedure TFrameHomeAddr.SetingFrameHeight;
begin

  Self.lbAddrList.Height:=Self.lbAddrList.Prop.GetContentHeight;

  Self.pnlAddrList.Height:=33+Self.lbAddrList.Height+48;


  Self.sbcClient.Height:=Self.lvSome.Position.Y+Self.lvSome.Height;

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;

procedure TFrameHomeAddr.SyncLocation;
begin
//  Self.btnCity.Caption:=GlobalGPSLocation.City;


  //用于测试,显示经纬度,以便把用户的经纬度告知我们
  Self.lblAddr.Caption:='当前地址'
                        +'('
                        +FloatToStr(GlobalGPSLocation.Longitude)+','
                        +FloatToStr(GlobalGPSLocation.Latitude)+')';



  if GlobalGPSLocation.IsLocationTimeout then
  begin
      Self.lblAddrValue.Caption:='定位超时...';
  end
  else if GlobalGPSLocation.IsGeocodeAddrError then
  begin
      Self.lblAddrValue.Caption:='地址解析出错...';
  end
  else if GlobalGPSLocation.IsStartError then
  begin
      Self.lblAddrValue.Caption:='定位启动失败...';
  end
  else if not GlobalGPSLocation.HasLocated then
  begin
      Self.lblAddrValue.Caption:='正在识别地址...';
  end
  else
  begin
      Self.lblAddrValue.Caption:=GlobalGPSLocation.RegionName;
  end;

end;

end.
