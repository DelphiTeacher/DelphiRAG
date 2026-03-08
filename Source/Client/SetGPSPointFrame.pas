unit SetGPSPointFrame;

interface


uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  System.IOUtils,

  EasyServiceCommonMaterialDataMoudle,
//  uRestInterfaceCall,
  uBaseHttpControl,
  IdURI,

//  uAPPCommon,
  uDataSetToJson,

  uSkinItems,
  uFrameContext,

  StrUtils,
  uBaseLog,
  uGPSUtils,
  uGPSLocation,
  uUIFunction,
  uFuncCommon,
//  uCommonUtils,
  uTimerTask,
  uManager,
  XSuperObject,
  XSuperJson,

  PopupMenuFrame,
  TakePictureMenuFrame,
//  LookCertificationInfoFrame,

  WaitingFrame,
  MessageBoxFrame,
//  ClipHeadFrame,
  {$IFDEF USE_GOOGLE_ROUTE_PLAN}
  GoogleWebMapFrame,
  {$ELSE}
  BaiduWebMapFrame,
  {$ENDIF}


  uMapCommon,

  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyCheckBox, uSkinFireMonkeyLabel, FMX.Controls.Presentation,
  FMX.Edit, uSkinFireMonkeyEdit, uSkinFireMonkeyScrollBoxContent,
  uDrawPicture,
  uSkinImageList, uSkinFireMonkeyImage, uSkinImageType, uSkinButtonType,
  uSkinPanelType, uSkinScrollBoxContentType, uBaseSkinControl,
  uSkinScrollControlType, uSkinScrollBoxType, FMX.ListBox,
  uSkinFireMonkeyComboBox, uSkinRadioButtonType, uSkinFireMonkeyRadioButton,
  uSkinLabelType, uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinCustomListType, uSkinVirtualListType, uSkinListViewType,
  uSkinFireMonkeyListView, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyMemo,
  uDrawCanvas, FMX.Memo.Types;

type
  TFrameSetGPSPoint = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlClient: TSkinFMXPanel;
    pnlAddr: TSkinFMXPanel;
    pnlLocation: TSkinFMXPanel;
    edtLocation: TSkinFMXEdit;
    lvPosition: TSkinFMXListView;
    pnlSitItem1: TSkinFMXItemDesignerPanel;
    lblName: TSkinFMXLabel;
    chkColor5: TSkinFMXRadioButton;
    pnlSitDefault: TSkinFMXItemDesignerPanel;
    lblPositionName: TSkinFMXLabel;
    lblPositionDetil: TSkinFMXLabel;
    chkColor6: TSkinFMXRadioButton;
    btnOK: TSkinFMXButton;
    edtAddr: TSkinFMXMemo;
    pnlEmpty: TSkinFMXPanel;
    pnlEmpty6: TSkinFMXPanel;
    btnSearch: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure lvPositionClickItem(AItem: TSkinItem);
    procedure btnSearchClick(Sender: TObject);
//  private
//    //经纬度(用于获取附近的地址列表)
//    FLat:Double;
//    FLng:Double;
  private
    //从选择地址页面返回
    procedure OnReturnFromSelectAddrFrame(AFrame:TFrame);
  private
    //获取附近的地址列表//返回GCJ02格式的经纬度
    procedure DoGetNearbyAddrListFrame(ATimerTask:TObject);
    procedure DoGetNearbyAddrListFrameEnd(ATimerTask:TObject);
  private
    procedure DoMapFrameSetPoint(Sender:TObject;
                                ALocation:TLocation;
                                AAddr:String;
                                AAnnotation:TMapAnnotation);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    FMapAnnotation:TMapAnnotation;
    procedure Load(AMapAnnotation:TMapAnnotation;
                    //标题
                    AToolbarCaption:String;
                    //确定按钮的标题
                    AOKButtonCaption:String);
    //获取附近地址列表
    procedure GetNearbyAddrList;

  public
    //在地址中去掉省市区,因为我们省市区已经选择好了
    function RemoveProvince(AAddr:String):String;
    { Public declarations }
  end;





var
  GlobalSetGPSPointFrame:TFrameSetGPSPoint;

implementation

{$R *.fmx}

uses
  MainForm,
  GetAddrListFrame,
  MainFrame;

procedure TFrameSetGPSPoint.btnOKClick(Sender: TObject);
begin

  if (Self.FMapAnnotation.Location.Latitude=0) and (Self.FMapAnnotation.Location.Longitude=0) then
  begin
    ShowMessageBoxFrame(Self,'经纬度不能为空!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self);

end;

procedure TFrameSetGPSPoint.Load(AMapAnnotation:TMapAnnotation;
                                  AToolbarCaption:String;
                                  AOKButtonCaption:String);
begin

  uBaseLog.HandleException(nil,'TFrameSetGPSPoint.Load Begin');


  FMapAnnotation.Assign(AMapAnnotation);


  Self.edtLocation.Text:=FloatToStr(AMapAnnotation.Location.Longitude)+','
                        +FloatToStr(AMapAnnotation.Location.Latitude);

  Self.edtAddr.Text:=RemoveProvince(AMapAnnotation.Addr);


  Self.pnlToolBar.Caption:=AToolbarCaption;
  Self.btnOK.Caption:=AOKButtonCaption;

  uBaseLog.HandleException(nil,'TFrameSetGPSPoint.Load 1');


  if GlobalMapFrame=nil then
  begin
      uBaseLog.OutputDebugString('TFrameSetGPSPoint.Load CreateMapFrame Begin');

      {$IFDEF USE_GOOGLE_ROUTE_PLAN}
      GlobalMapFrame:=TFrameGoogleWebMap.Create(Self);
      {$ELSE}
      //百度网页地图
      GlobalMapFrame:=TFrameBaiduWebMap.Create(Self);
      {$ENDIF}

  end;
  SetFrameName(GlobalMapFrame);



  uBaseLog.HandleException(nil,'TFrameSetGPSPoint.Load 2');



  //不显示工具栏
  GlobalMapFrame.pnlToolBar.Visible:=False;

  //要显示一下,ReturnFrame的时候会被隐藏
  GlobalMapFrame.Visible:=True;
  GlobalMapFrame.Parent:=Self.pnlClient;
  GlobalMapFrame.Align:=TAlignLayout.Client;


  //设置事件
  GlobalMapFrame.OnClickMapScreenshot:=nil;
  GlobalMapFrame.OnReturnButtonClick:=nil;
  GlobalMapFrame.OnSetPoint:=Self.DoMapFrameSetPoint;



  uBaseLog.HandleException(nil,'TFrameSetGPSPoint.Load 3');



  //显示原生控件
  //GlobalMapFrame.ProcessNativeControlModalShowPanel1.IsEnableModalShow:=False;

  //不需要鱼骨控件和地图类型切换控件
  GlobalMapFrame.IsNeedMapControl:=True;


  //地图的缩放级别
  GlobalMapFrame.ZoomLevel:=16;

  //设置点模式
  GlobalMapFrame.ViewMode:=mfvmSetPoint;


  GlobalMapFrame.FMapAnnotationList.Clear(True);


  uBaseLog.HandleException(nil,'TFrameSetGPSPoint.Load 4');


  //之前设置的点
  GlobalMapFrame.SetPointAnnotation.Assign(AMapAnnotation);

  //设置视图中心点
  if AMapAnnotation.Location.HasData then
  begin
      //之前设置过
      GlobalMapFrame.Center:=AMapAnnotation.Location;
  end
  else
  begin
      //之前没有设置过
      if (GlobalGPSLocation<>nil) and (GlobalGPSLocation.HasLocated) then
      begin
        //如果定位到了,就默认为当前位置
        GlobalMapFrame.Center:=GlobalGPSLocation.Location;
      end
      else
      begin
        //如果没有定位到了,那么定位到北京吧
        GlobalMapFrame.Center:=TLocation.Create(116.38,39.90,gtGCJ02);
      end;
  end;


  uBaseLog.HandleException(nil,'TFrameSetGPSPoint.Load 5');


  //刷新地图
  GlobalMapFrame.Sync;


  uBaseLog.HandleException(nil,'TFrameSetGPSPoint.Load 6');


  //获取附近的地址列表
  GetNearbyAddrList(//Self.FMapAnnotation.Location.Latitude,
                    //Self.FMapAnnotation.Location.Longitude
                    );




  uBaseLog.HandleException(nil,'TFrameSetGPSPoint.Load End');
end;

procedure TFrameSetGPSPoint.lvPositionClickItem(AItem: TSkinItem);
var
  ASuperObject:ISuperObject;
begin

  if AItem.Detail6<>'' then
  begin
        ASuperObject:=TSuperObject.Create(AItem.Detail6);
        {$IFDEF USE_GOOGLE_ROUTE_PLAN}
        if ASuperObject.O['geometry'].Count>0 then
        begin
          FMapAnnotation.Location.Latitude:=GetJsonDoubleValue(ASuperObject.O['geometry'].O['location'],'lat');
          FMapAnnotation.Location.Longitude:=GetJsonDoubleValue(ASuperObject.O['geometry'].O['location'],'lng');
        end;
        {$ELSE}
        FMapAnnotation.Location.Latitude:=GetJsonDoubleValue(ASuperObject.O['point'],'y');
        FMapAnnotation.Location.Longitude:= GetJsonDoubleValue(ASuperObject.O['point'],'x');
        {$ENDIF}
  end;


  //要加上详细地址,不然只有店名或者详细
  Self.edtAddr.Text:=RemoveProvince(AItem.Detail+AItem.Caption);
  FMapAnnotation.Addr:=AItem.Detail+AItem.Caption;


  //在地图上显示这个点
  GlobalMapFrame.SetPointAnnotation.Assign(FMapAnnotation);
  GlobalMapFrame.Center:=FMapAnnotation.Location;
  //刷新地图
  GlobalMapFrame.Sync;


//  //返回
//  HideFrame;//(Self,hfcttBeforeReturnFrame);
//  ReturnFrame(Self);


end;

procedure TFrameSetGPSPoint.OnReturnFromSelectAddrFrame(AFrame: TFrame);
begin
  //从地址列表选择好地址返回

  Self.edtAddr.Text:=GlobalGetAddrListFrame.FSelectedAddr;


  FMapAnnotation.Addr:=Self.edtAddr.Text;
  FMapAnnotation.Location.Latitude:=GlobalGetAddrListFrame.FSelectedLat;
  FMapAnnotation.Location.Longitude:=GlobalGetAddrListFrame.FSelectedLng;

  Self.Load(FMapAnnotation,'设置区域','确定');


//  Self.GetNearbyAddrList(FMapAnnotation.Location.Latitude,FMapAnnotation.Location.Longitude);

end;

procedure TFrameSetGPSPoint.btnReturnClick(Sender: TObject);
begin
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame(Self);
end;

procedure TFrameSetGPSPoint.btnSearchClick(Sender: TObject);
begin
  //搜索地址
//  HideFrame;//(Self,hfcttBeforeShowframe);
//  ShowFrame(TFrame(GlobalGetAddrListFrame),TFrameGetNearbyAddrList,frmMain,nil,nil,OnReturnFromSelectAddrFrame,Application);
//
//  GlobalGetAddrListFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalGetAddrListFrame.Load(Self.btnSearch.Caption,
//                              '',
//                              '',
//                              '',
//                              '',
//                              '',
//                              0,
//                              0,
//                              False,
//                              True
//                              );


  HideFrame;//(Self,hfcttBeforeShowframe);
  ShowFrame(TFrame(GlobalGetAddrListFrame),TFrameGetAddrList,frmMain,nil,nil,OnReturnFromSelectAddrFrame,Application);

//  GlobalGetAddrListFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalGetAddrListFrame.Load(Self.btnSearch.Caption,
                              Self.FMapAnnotation.Addr,
                              Self.FMapAnnotation.Province,
                              Self.FMapAnnotation.City,
                              Self.FMapAnnotation.Area,
                              Self.FMapAnnotation.PostCode,
                              Self.FMapAnnotation.Location.Latitude,
                              Self.FMapAnnotation.Location.Longitude,
                              False,
                              False,
                              True);
end;

constructor TFrameSetGPSPoint.Create(AOwner: TComponent);
begin
  inherited;
  FMapAnnotation:=TMapAnnotation.Create;

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameSetGPSPoint.Destroy;
begin
  FreeAndNil(FMapAnnotation);
  inherited;
end;

procedure TFrameSetGPSPoint.DoGetNearbyAddrListFrame(ATimerTask: TObject);
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
    TSystemHttpControl(AHttpControl).FNetHTTPClient.ConnectionTimeout:=10*1000;  //连接超时-五秒
    TSystemHttpControl(AHttpControl).FNetHTTPClient.ResponseTimeout:=10*1000;    //响应超时-五秒

    AResponseStream:=TStringStream.Create('',TEncoding.Utf8);
    try
        {$IFDEF USE_GOOGLE_ROUTE_PLAN}
        //国外
        //调谷歌接口
        AIsSuccProcess:=//AHttpControl.Get(
            GetWebUrl_From_OrangeUIServer(AHttpControl,
                  'https://maps.googleapis.com'
                          +'/maps/api/place/nearbysearch/json?'
                          +'location='+FloatToStr(Self.FMapAnnotation.Location.Latitude)
                                  +','+FloatToStr(Self.FMapAnnotation.Location.Longitude)//固定地址
                          +'&radius=500'
                          +'&sensor=true'
                          +'&key='+GoogleAPIKey,
                          AResponseStream
                  );
//        AIsSuccProcess:=AHttpControl.Get(
//              uBaseHttpControl.FixSupportIPV6URL('https://maps.googleapis.com')
//                          +'/maps/api/geocode/json?'
//                          +'latlng='+FloatToStr(GlobalGPSLocation.Latitude)
//                                  +','+FloatToStr(GlobalGPSLocation.Longitude)//固定地址
//                          +'&key='+uGPSLocation.GoogleAPIKey,
//                          AResponseStream
//                  );

        {$ELSE}
        //国内
        //调用百度接口
        //把返回的数据放入AResponseStream
        AIsSuccProcess:=AHttpControl.Get(
//            GetWebUrl_From_OrangeUIServer(AHttpControl,
                  'http://api.map.baidu.com'
                    +'/geocoder/v2/?'
//                    +'location='+FloatToStr(Self.FLat)
//                            +','+FloatToStr(Self.FLng)
                    +'location='+FloatToStr(Self.FMapAnnotation.Location.Latitude)
                            +','+FloatToStr(Self.FMapAnnotation.Location.Longitude)

                            //固定地址
                    +'&output=json'
                    +'&pois=1'
                    +'&radius=1000'//搜索附近1000米范围内
                    +'&coordtype=gcj02ll'
                    //返回GCJ02格式的经纬度
                    //返回GCJ02格式的经纬度
                    +'&ret_coordtype=gcj02ll'
                    +'&ak='+BaiduAPIKey
                    ,
                    AResponseStream
                    );

        {$ENDIF}



        TTimerTask(ATimerTask).TaskDesc:=AResponseStream.DataString;

        if AIsSuccProcess=True then
        begin
          TTimerTask(ATimerTask).TaskTag:=0;
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

procedure TFrameSetGPSPoint.DoGetNearbyAddrListFrameEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AListViewItem:TSkinListViewItem;
  ADetailHeight:Double;
  ACaptionHeight:Double;
begin
  ADetailHeight:=0;
  ACaptionHeight:=0;
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

      Self.lvPosition.Prop.Items.BeginUpdate;
      try
          {$IFDEF USE_GOOGLE_ROUTE_PLAN}
          for I := 0 to ASuperObject.A['results'].Length-1 do
          begin
            if (FSelectedAddr<>ASuperObject.A['results'].O[I].S['name'])
            and (Self.lvPosition.Prop.Items.FindItemByCaption(ASuperObject.A['results'].O[I].S['name'])=nil) then
            begin
              AListViewItem:=Self.lvPosition.Prop.Items.Add;
              AListViewItem.Caption:=ASuperObject.A['results'].O[I].S['name'];
              AListViewItem.Detail6:=ASuperObject.A['results'].O[I].AsJSON;
              AListViewItem.Detail:=ASuperObject.A['results'].O[I].S['vicinity'];

              ADetailHeight:=GetSuitContentHeight(Self.lblPositionDetil.Width,
                                              ASuperObject.A['results'].O[I].S['vicinity'],
                                              12,
                                              Self.lvPosition.Prop.ItemHeight/2
                                                  );

              ACaptionHeight:=GetSuitContentHeight(Self.lblPositionDetil.Width,
                                             ASuperObject.A['results'].O[I].S['name'],
                                              14,
                                              Self.lvPosition.Prop.ItemHeight/2
                                                  );
              AListViewItem.Height:=ACaptionHeight+ADetailHeight;
            end;
          end;

          {$ELSE}
          for I := 0 to ASuperObject.O['result'].A['pois'].Length-1 do
          begin

            if Self.lvPosition.Prop.Items.FindItemByCaption(ASuperObject.O['result'].A['pois'].O[I].S['name'])=nil then
            begin

              AListViewItem:=Self.lvPosition.Prop.Items.Add;
              AListViewItem.Caption:=ASuperObject.O['result'].A['pois'].O[I].S['name'];
              AListViewItem.Detail:=ASuperObject.O['result'].A['pois'].O[I].S['addr'];
              AListViewItem.Detail6:=ASuperObject.O['result'].A['pois'].O[I].AsJSON;

              ADetailHeight:=GetSuitContentHeight(Self.lblPositionDetil.Width,
                                              ASuperObject.O['result'].A['pois'].O[I].S['addr'],
                                              12,
                                              Self.lvPosition.Prop.ItemHeight/2
                                                  );

              ACaptionHeight:=GetSuitContentHeight(Self.lblPositionDetil.Width,
                                             ASuperObject.O['result'].A['pois'].O[I].S['name'],
                                              14,
                                              Self.lvPosition.Prop.ItemHeight/2
                                                  );
              AListViewItem.Height:=ACaptionHeight+ADetailHeight;
            end;

          end;
         {$ENDIF}

      finally
        Self.lvPosition.Prop.Items.EndUpdate;
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

procedure TFrameSetGPSPoint.DoMapFrameSetPoint(Sender: TObject;
  ALocation: TLocation;
  AAddr: String;
  AAnnotation:TMapAnnotation);
begin
  FMapAnnotation.Assign(AAnnotation);

  Self.edtLocation.Text:=FloatToStr(ALocation.Longitude)+','
                        +FloatToStr(ALocation.Latitude);


  Self.GetNearbyAddrList(//ALocation.ConvertToBD09.Latitude,
                          //ALocation.ConvertToBD09.Longitude
                          );

  Self.edtAddr.Text:=RemoveProvince(FMapAnnotation.Addr+FMapAnnotation.RegionName);
end;

function TFrameSetGPSPoint.RemoveProvince(AAddr:String): String;
var
  ATempAddr:String;
  ACityIndex:Integer;
  AAreaIndex:Integer;
begin
  ATempAddr:=AAddr;
  //去掉省市区
  ACityIndex:=ATempAddr.IndexOf('市');
  AAreaIndex:=ATempAddr.IndexOf('区');
  if (ACityIndex>0)
    and (AAreaIndex>0) then
  begin
    ATempAddr:=ATempAddr.Substring(AAreaIndex+1);
  end;
  Result:=ATempAddr;
end;

procedure TFrameSetGPSPoint.GetNearbyAddrList(
//    ALat:Double;ALng:Double
    );
begin
  Self.lvPosition.Prop.Items.BeginUpdate;
  try
    Self.lvPosition.Prop.Items.Clear(True);
  finally
    Self.lvPosition.Prop.Items.EndUpdate();
  end;


//  Self.FLat:=ALat;
//  Self.FLng:=ALng;
  //获取附近地址
//  ShowWaitngFrame(Self,'获取中...');

  if FMapAnnotation.Location.HasData then
  begin
      uBaseLog.HandleException(nil,'TFrameSetGPSPoint.GetNearbyAddrList');
      uTimerTask.GetGlobalTimerThread.RunTempTask(
                     DoGetNearbyAddrListFrame,
                     DoGetNearbyAddrListFrameEnd,
                     'GetNearbyAddrList');
  end;
end;

end.


