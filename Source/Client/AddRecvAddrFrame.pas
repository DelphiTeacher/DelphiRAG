//OK
unit AddRecvAddrFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinMaterial,
  MessageBoxFrame,
  SelectAreaFrame,
  uUIFunction,
  uManager,
  uGPSLocation,
  uOpenClientCommon,
  uGPSUtils,
  uFrameContext,

  uBaseList,
  uBaseLog,
  uAppCommon,
  uMapCommon,
  uOpenCommon,


  uSkinItems,
  uFuncCommon,
//  uCommonUtils,

  uDataSetToJson,

  uComponentType,

  uTimerTask,
  uRestInterfaceCall,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  WaitingFrame,
  RecvAddrListFrame,

  GetAddrListFrame,

  XSuperObject,
  XSuperJson,

  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinFireMonkeyRadioButton, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, uSkinFireMonkeyCheckBox, uSkinCheckBoxType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinButtonType, uBaseSkinControl, uSkinPanelType, uSkinRadioButtonType;

type
  TFrameAddRecvAddr = class(TFrame,IFrameVirtualKeyboardAutoProcessEvent)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlName: TSkinFMXPanel;
    edtName: TSkinFMXEdit;
    pnlEmpty: TSkinFMXPanel;
    pnlPhoneNumber: TSkinFMXPanel;
    edtPhone: TSkinFMXEdit;
    pnlEmpty6: TSkinFMXPanel;
    btnOk: TSkinFMXButton;
    rbMr: TSkinFMXRadioButton;
    rbMs: TSkinFMXRadioButton;
    pnlBuilding: TSkinFMXPanel;
    edtBuilding: TSkinFMXEdit;
    pnlSign: TSkinFMXPanel;
    rbHome: TSkinFMXRadioButton;
    rbCompany: TSkinFMXRadioButton;
    rbSchool: TSkinFMXRadioButton;
    btnDel: TSkinFMXButton;
    pnlProvince: TSkinFMXPanel;
    btnSelectProvince: TSkinFMXButton;
    pnlStreet: TSkinFMXPanel;
    pnlPostCode: TSkinFMXPanel;
    edtPostCode: TSkinFMXEdit;
    pnlOther: TSkinFMXPanel;
    edtOther: TSkinFMXEdit;
    btnStreet: TSkinFMXButton;
    procedure btnOKClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure rbMrClick(Sender: TObject);
    procedure rbHomeChange(Sender: TObject);
    procedure rbCompanyChange(Sender: TObject);
    procedure rbSchoolChange(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnSelectProvinceClick(Sender: TObject);
    procedure rbMsClick(Sender: TObject);
    procedure btnStreetClick(Sender: TObject);
  private
    FUserFID:String;

    //是否需要获取经纬度
    FIsNeedLatLng:Boolean;

    //经纬度
    FLat:Double;
    FLng:Double;

    //街道地址
    FShortAddr:String;

    FLocation:TLocation;
//    FFrameList:TBaseList;

//    FAddrListFrame:TFrameGetAddrList;

  private
    //从选择具体地址返回
    procedure OnReturnFromSelectAddrFrame(AFrame:TFrame);

    //从设置区域返回(GCJ02格式)
    procedure DoReturnFrameFromSetPointMapFrame(AFrame:TFrame);

  private
    //添加用户收货地址
    procedure DoAddRecvAddrExecute(ATimerTask:TObject);
    procedure DoAddRecvAddrExecuteEnd(ATimerTask:TObject);

//  private
//    //获取经纬度
//    procedure DoGetAddrLatLngExecute(ATimerTask:TObject);
//    procedure DoGetAddrLatLngExecuteEnd(ATimerTask:TObject);

  private
    //修改收货地址
    procedure DoUpdateRecvAddrExecute(ATimerTask:TObject);
    procedure DoUpdateRecvAddrExecuteEnd(ATimerTask:TObject);
  private
    //删除收货地址
    procedure DoDeleteAddrExecute(ATimerTask:TObject);
    procedure DoDeleteAddrExecuteEnd(ATimerTask:TObject);

//  private
//    procedure OnReturnNotice(Sender:TObject);

    { Private declarations }

  private
    //选择省市返回
    procedure OnReturnFrameFromSelectArea(Frame:TFrame);
    //从删除收货地址返回
    procedure OnModalResultFromDeleteAddr(Frame:TObject);

    procedure LoadUserRecvAddrToUI(AUserRecvAddr:TUserRecvAddr);
  private
    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
    //获取虚拟键盘的高度校正
    function GetVirtualKeyboardHeightAdjustHeight:Double;
  public
    FUserRecvAddr:TUserRecvAddr;
    procedure Clear;
    //修改收货地址
    procedure Edit(AUserRecvAddr:TUserRecvAddr);
    //添加收货地址
    procedure Add;
//    //新增酒店的的时候填写收货地址
//    procedure Input(AUserRecvAddr:TUserRecvAddr);
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;


var
  GlobalIsRecvAddrChanged:Boolean;
  GlobalAddRecvAddrFrame:TFrameAddRecvAddr;

implementation

{$R *.fmx}

uses
  MainForm,
  SetGPSPointFrame,
  MainFrame;



procedure TFrameAddRecvAddr.btnDelClick(Sender: TObject);
begin
  //删除收货地址
  ShowMessageBoxFrame(Self,'确定删除该收货地址?','',TMsgDlgType.mtInformation,['确定','取消'],OnModalResultFromDeleteAddr);

end;

procedure TFrameAddRecvAddr.btnOKClick(Sender: TObject);
var
  AAddr:String;
begin
  HideVirtualKeyboard;

  AAddr:='';

  if Self.edtName.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入姓名!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;
  if Self.edtPhone.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入电话号码!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  if Not IsMobPhone(Self.edtPhone.Text) then
  begin
    ShowMessageBoxFrame(Self,'手机号码格式不正确!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  if Self.btnStreet.Caption='' then
  begin
    ShowMessageBoxFrame(Self,'请填写街道地址!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;


  if Self.btnSelectProvince.Caption='' then
  begin
    ShowMessageBoxFrame(Self,'请选择省份城市区域!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

//  if Self.edtPostCode.Text='' then
//  begin
//    ShowMessageBoxFrame(Self,'请填写邮政编码!','',TMsgDlgType.mtInformation,['确定'],nil);
//    Exit;
//  end;


  if Self.rbMr.Prop.Checked=True then
  begin
    Self.FUserRecvAddr.sex:=0;
  end
  else if Self.rbMs.Prop.Checked=True then
   begin
     Self.FUserRecvAddr.sex:=1;
   end;

  if Self.rbHome.Prop.Checked=True then
  begin
    Self.FUserRecvAddr.tag:=Self.rbHome.Caption;
  end
  else if Self.rbCompany.Prop.Checked=True then
   begin
     Self.FUserRecvAddr.tag:=Self.rbCompany.Caption;
   end
   else if Self.rbSchool.Prop.Checked=True then
   begin
     Self.FUserRecvAddr.tag:=Self.rbSchool.Caption;
   end;



  Self.FUserRecvAddr.name:=Self.edtName.Text;
  Self.FUserRecvAddr.phone:=Self.edtPhone.Text;

  Self.FUserRecvAddr.building:=Self.edtBuilding.Text;

  Self.FUserRecvAddr.addr_line3:=Self.edtOther.Text;

  Self.FUserRecvAddr.postcode:=Self.edtPostCode.Text;

  Self.FUserRecvAddr.street:=Self.btnStreet.Caption;


//  if Self.FUserRecvAddr.street<>'' then
//  begin
//    FMX.Types.Log.d('OrangeUI Get');
//
//    if Self.btnStreet.Caption<>Self.FUserRecvAddr.street then
//    begin
//      Self.FUserRecvAddr.street:=Self.btnStreet.Caption;
//      FIsNeedLatLng:=True;
//    end
//    else
//    begin
//      FIsNeedLatLng:=False;
//    end;
//  end
//  else
//  begin
//    FMX.Types.Log.d('OrangeUI Get');
//    Self.FUserRecvAddr.street:=Self.btnStreet.Caption;
//    FIsNeedLatLng:=True;
//  end;




  if Self.edtBuilding.Text<>'' then
  begin
    AAddr:=Self.btnStreet.Caption
                             +Self.edtBuilding.Text
                             +Self.btnSelectProvince.Caption
                             +Self.edtPostCode.Text;
  end
  else
  begin
    //拼接地址换过位置  邮编暂时不需要
    AAddr:=Self.btnSelectProvince.Caption
                             +Self.btnStreet.Caption;
//                             +','+Self.edtPostCode.Text;
  end;

//  if FUserRecvAddr.addr<>AAddr then
//  begin
    FUserRecvAddr.addr:=AAddr;
//    FIsNeedLatLng:=True;
//  end
//  else
//  begin
//    FIsNeedLatLng:=False;
//  end;



  if FUserRecvAddr.fid=0 then
  begin
    //添加收货地址时删除按钮不显示
    Self.btnDel.Visible:=False;
    //添加收货地址
    ShowWaitingFrame(Self,'添加中');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                             DoAddRecvAddrExecute,
                                             DoAddRecvAddrExecuteEnd,
                                             'AddRecvAddr');
    Exit;
  end;


  if FUserRecvAddr.fid<>0 then
  begin
    //修改收货地址显示删除按钮
    Self.btnDel.Visible:=True;
    //修改收货地址
    ShowWaitingFrame(Self,'加载中');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                                          DoUpdateRecvAddrExecute,
                                          DoUpdateRecvAddrExecuteEnd,
                                          'UpdateRecvAddr');

    Exit;
  end;

end;


procedure TFrameAddRecvAddr.btnReturnClick(Sender: TObject);
begin

  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameAddRecvAddr.btnSelectProvinceClick(Sender: TObject);
begin
//  FMX.Types.Log.d('OrangeUI Country'+GlobalCountryString);
  {$IFDEF NZ}
//  if GlobalCountryString='NZ' then
//  begin
    //选择所在地区
    HideFrame;//(Self,hfcttBeforeShowFrame);

    ShowFrame(TFrame(GlobalSelectAreaFrame),TFrameSelectArea,frmMain,nil,nil,OnReturnFrameFromSelectArea,Application);
//    GlobalSelectAreaFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalSelectAreaFrame.LoadDataFromWeb(BasicDataManageInterfaceUrl,'New Zealand');
    GlobalSelectAreaFrame.Init(FUserRecvAddr.province,FUserRecvAddr.city,FUserRecvAddr.area,False,True);

//  end
//  else
//  begin
  {$ELSE}
      //选择所在地区
      HideFrame;//(Self,hfcttBeforeShowFrame);

      ShowFrame(TFrame(GlobalSelectAreaFrame),TFrameSelectArea,frmMain,nil,nil,OnReturnFrameFromSelectArea,Application);
//      GlobalSelectAreaFrame.FrameHistroy:=CurrentFrameHistroy;
      GlobalSelectAreaFrame.LoadData;
      GlobalSelectAreaFrame.Init(FUserRecvAddr.province,FUserRecvAddr.city,FUserRecvAddr.area,False,False);

      if GlobalGPSLocation<>nil then
      begin
        GlobalSelectAreaFrame.SetGPSLocation(GlobalGPSLocation.Province,
                                             GlobalGPSLocation.City,
                                             GlobalGPSLocation.District
                                              );
        GlobalSelectAreaFrame.FIsClickGPSAddrThenOK:=False;
      end;
//  end;
  {$ENDIF}
end;

procedure TFrameAddRecvAddr.btnStreetClick(Sender: TObject);
var
  AMapAnnotation:TMapAnnotation;
//  ALat:Double;
//  ALng:Double;
begin
  if Self.btnSelectProvince.Caption='' then
  begin
    ShowMessageBoxFrame(Self,'请选择城市!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

//  HideFrame;//(Self,hfcttBeforeShowframe);
//  ShowFrame(TFrame(GlobalGetAddrListFrame),TFrameGetAddrList,frmMain,nil,nil,OnReturnFromSelectAddrFrame,Application);
//
//  GlobalGetAddrListFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalGetAddrListFrame.Load(Self.btnStreet.Caption,
//                              FUserRecvAddr.addr,
//                              FUserRecvAddr.province,
//                              FUserRecvAddr.city,
//                              FUserRecvAddr.area,
//                              FUserRecvAddr.postcode,
//                              FUserRecvAddr.latitude,
//                              FUserRecvAddr.longitude,
//                              False,
//                              True);

  //设置点模式获取经纬度




  //单独页面的模式
  HideFrame;//();
  ShowFrame(TFrame(GlobalSetGPSPointFrame),TFrameSetGPSPoint,DoReturnFrameFromSetPointMapFrame);


//  Gcj02_bd09ll(FLat,FLng,ALat,ALng);

  uBaseLog.HandleException(nil,'TFrameAddRecvAddr.btnStreetClick Begin');

  AMapAnnotation:=TMapAnnotation.Create;
  try
//     AMapAnnotation.Location:=TLocation.Create(
//          ALat,
//          ALng,
//          gtBD09LL
//          );


     AMapAnnotation.Location:=TLocation.Create(
                                                FLat,
                                                FLng,
                                                gtGCJ02
                                                );

    AMapAnnotation.Addr:=FShortAddr;
    AMapAnnotation.Province:=Self.FUserRecvAddr.province;
    AMapAnnotation.City:=Self.FUserRecvAddr.city;
    AMapAnnotation.Area:=Self.FUserRecvAddr.area;

    uBaseLog.HandleException(nil,'TFrameAddRecvAddr.btnStreetClick GlobalSetGPSPointFrame.Load');
    GlobalSetGPSPointFrame.Load(AMapAnnotation,
                                '设置区域',
                                '确定'
                                );



    //获取附近的地址列表
    if AMapAnnotation.Location.HasData then
    begin

      uBaseLog.HandleException(nil,'TFrameAddRecvAddr.btnStreetClick GlobalSetGPSPointFrame.GetNearbyAddrList');
      GlobalSetGPSPointFrame.GetNearbyAddrList;
    end;


  finally
    FreeAndNil(AMapAnnotation);
  end;



  uBaseLog.HandleException(nil,'TFrameAddRecvAddr.btnStreetClick End');


end;

procedure TFrameAddRecvAddr.Clear;
var
  AFrame:TFrameGetAddrList;
  I:Integer;
begin
  uBaseLog.HandleException(nil,'TFrameAddRecvAddr.Clear Begin');

  Self.FUserRecvAddr.Clear;
  Self.FUserFID:='';

//  FAddrListFrame.Visible:=False;

  FIsNeedLatLng:=False;

//  Self.chkIsDefault.Prop.Checked:=False;
//  Self.memAddr.Text:='';
  Self.edtName.Text:='';
  Self.edtPhone.Text:='';
  Self.btnSelectProvince.Caption:='';

  Self.btnStreet.Caption:='';
  Self.edtPostCode.Text:='';
  Self.edtBuilding.Text:='';
  Self.edtOther.Text:='';


  FShortAddr:='';

  FLat:=0;
  FLng:=0;



//  //清除原来的
//  if Self.FFrameList<>nil then
//  begin
//    for I := FFrameList.Count-1 downto 0 do
//    begin
//      AFrame:=TFrameGetAddrList(FFrameList[I]);
//      FFrameList.Delete(I,False);
//      AFrame.Parent:=nil;
//      FreeAndNil(AFrame);
//    end;
//  end;

  Self.btnDel.Visible:=False;

  Self.rbMr.Prop.Checked:=False;
  Self.rbMs.Prop.Checked:=False;

  Self.rbHome.Prop.Checked:=False;
  Self.rbCompany.Prop.Checked:=False;
  Self.rbSchool.Prop.Checked:=False;


//  FMX.Types.Log.d('OrangeUI GlobalCountryString'+GlobalCountryString);

  Self.edtBuilding.Text:='';

//  Self.pnlIsDefault.Visible:=True;

  Self.pnlToolBar.Caption:='新增地址';

  uBaseLog.HandleException(nil,'TFrameAddRecvAddr.Clear End');
end;


constructor TFrameAddRecvAddr.Create(AOwner: TComponent);
begin
  inherited;

  Self.FUserRecvAddr:=TUserRecvAddr.Create;



//  FAddrListFrame:=TFrameGetAddrList.Create(Self);
//  FAddrListFrame.Parent:=Self.sbcClient;
//  FAddrListFrame.Clear;
//  FAddrListFrame.OnReturnNotice:=Self.OnReturnNotice;
//  FAddrListFrame.Height:=40;
//  FAddrListFrame.lvPosition.Prop.EnableAutoPullDownRefreshPanel:=False;
//  FAddrListFrame.lvPosition.Prop.EnableAutoPullUpLoadMorePanel:=False;
//
//  FAddrListFrame.Visible:=False;

//  FFrameList:=TBaseList.Create(ooReference);

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  Self.rbMr.SelfOwnMaterialToDefault.DrawCaptionParam.DrawEffectSetting.PushedEffect.FontColor.Color:=SkinThemeColor;
  Self.rbMs.SelfOwnMaterialToDefault.DrawCaptionParam.DrawEffectSetting.PushedEffect.FontColor.Color:=SkinThemeColor;
  Self.rbHome.SelfOwnMaterialToDefault.DrawCaptionParam.DrawEffectSetting.PushedEffect.FontColor.Color:=SkinThemeColor;
  Self.rbCompany.SelfOwnMaterialToDefault.DrawCaptionParam.DrawEffectSetting.PushedEffect.FontColor.Color:=SkinThemeColor;
  Self.rbSchool.SelfOwnMaterialToDefault.DrawCaptionParam.DrawEffectSetting.PushedEffect.FontColor.Color:=SkinThemeColor;

  Self.rbMr.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.PushedEffect.BorderColor.Color:=SkinThemeColor;
  Self.rbMs.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.PushedEffect.BorderColor.Color:=SkinThemeColor;
  Self.rbHome.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.PushedEffect.BorderColor.Color:=SkinThemeColor;
  Self.rbCompany.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.PushedEffect.BorderColor.Color:=SkinThemeColor;
  Self.rbSchool.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.PushedEffect.BorderColor.Color:=SkinThemeColor;

end;

destructor TFrameAddRecvAddr.Destroy;
begin
  FreeAndNil(FUserRecvAddr);

//  FreeAndNil(FFrameList);
  inherited;
end;

procedure TFrameAddRecvAddr.DoAddRecvAddrExecute(ATimerTask: TObject);
var
//  AResponseStream:TStringStream;
  AHttpControl:THttpControl;
//  AIsSuccProcess:Boolean;
  ASuperObject:ISuperObject;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
//    if FIsNeedLatLng=True then
//    begin
//      FMX.Types.Log.d('OrangeUI DoAddRecvAddrExecute GetLatLng');
//      AIsSuccProcess:=False;
//
//      AHttpControl:=TSystemHttpControl.Create;
//      AResponseStream:=TStringStream.Create('',TEncoding.Utf8);
//      try
//          {$IFDEF USE_GOOGLE_ROUTE_PLAN}
//          //国外
//          //调谷歌接口                                  v
//          AIsSuccProcess:=//AHttpControl.Get(
//                  GetWebUrl_From_OrangeUIServer(AHttpControl,
//                            'https://maps.googleapis.com'
//                            +'/maps/api/geocode/json?'
//                            +'address='+Self.FUserRecvAddr.addr //输入地址
//                            +'&key='+GoogleAPIKey,
//                            AResponseStream
//                    );
//
//          {$ELSE}
//          //国内
//          //调百度接口
//          AIsSuccProcess:=//AHttpControl.Get(
//                  GetWebUrl_From_OrangeUIServer(AHttpControl,
//                            'http://api.map.baidu.com'
//                            +'/geocoder/v2/?'
//                            +'address='+Self.FUserRecvAddr.addr //输入地址
//                            +'&output=json'
//                            +'&ak='+BaiduAPIKey,
//                            AResponseStream
//                    );
//          {$ENDIF}
//
//          if AIsSuccProcess=True then
//          begin
//            FMX.Types.Log.d('OrangeUI DoAddRecvAddrExecute Success');
//
//            //获取成功
//            ASuperObject:=TSuperObject.Create(AResponseStream.DataString);
//            {$IFDEF USE_GOOGLE_ROUTE_PLAN}
//            if ASuperObject.S['status']='OK' then
//            begin
//              if ASuperObject.A['results'].O[0].O['geometry'].S['location_type']='ROOFTOP' then
//              begin
//                FUserRecvAddr.latitude:=GetJsonDoubleValue(ASuperObject.A['results'].O[0].O['geometry'].O['location'],'lat');
//                FUserRecvAddr.longitude:=GetJsonDoubleValue(ASuperObject.A['results'].O[0].O['geometry'].O['location'],'lng');
//              end
//              else
//              begin
//                FMX.Types.Log.d('OrangeUI DoAddRecvAddrExecute Fail');
//                TTimerTask(ATimerTask).TaskTag:=2;
//                //经纬度获取失败
//                ShowMessageBoxFrame(Self,'输入地址有误,不能精确定位!','',TMsgDlgType.mtInformation,['确定'],nil);
//                Exit;
//              end;
//
//            end
//
//            {$ELSE}
//            if ASuperObject.I['status']=0 then
//            begin
//
//              FUserRecvAddr.latitude:=GetJsonDoubleValue(ASuperObject.O['result'].O['location'],'lat');
//              FUserRecvAddr.longitude:=GetJsonDoubleValue(ASuperObject.O['result'].O['location'],'lng');
//
//            end
//            else
//            begin
//
//              FMX.Types.Log.d('OrangeUI DoAddRecvAddrExecute Fail');
//              TTimerTask(ATimerTask).TaskTag:=2;
//              //经纬度获取失败
//              ShowMessageBoxFrame(Self,'获取经纬度失败!','',TMsgDlgType.mtInformation,['确定'],nil);
//              Exit;
//            end;
//            {$ENDIF}
//          end
//          else
//          begin
//            if (FUserRecvAddr.latitude=0) OR (FUserRecvAddr.longitude=0) then
//            begin
//              FMX.Types.Log.d('OrangeUI DoAddRecvAddrExecute Fail');
//              TTimerTask(ATimerTask).TaskTag:=2;
//              //经纬度获取失败
//              ShowMessageBoxFrame(Self,'获取经纬度失败!','',TMsgDlgType.mtInformation,['确定'],nil);
//              Exit;
//            end;
//          end;
//
//      finally
//        AResponseStream.Free;
//        FreeAndNil(AHttpControl);
//      end;
//    end;


    FMX.Types.Log.d('OrangeUI DoAddRecvAddrExecute Flongitude'+FloatToStr(FUserRecvAddr.longitude));
    FMX.Types.Log.d('OrangeUI DoAddRecvAddrExecuteEnd FLatitude'+FloatToStr(FUserRecvAddr.latitude));


    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('add_user_recv_addr',
                          nil,
                          UserCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'key',
                          'name',
                          'phone',
                          'country',
                          'province',
                          'city',
                          'area',
                          'addr',
                          'street',
                          'building',
                          'addr_line3',
                          'postcode',
                          'tag',
                          'latitude',
                          'longitude',
                          'is_default',
                          'sex'],
                          [AppID,
                          GlobalManager.User.fid,
                          GlobalManager.User.key,
                          Self.FUserRecvAddr.name,
                          Self.FUserRecvAddr.phone,
                          Self.FUserRecvAddr.country,
                          Self.FUserRecvAddr.province,
                          Self.FUserRecvAddr.city,
                          Self.FUserRecvAddr.area,
                          Self.FUserRecvAddr.addr,
                          Self.FUserRecvAddr.street,
                          '',//Self.FUserRecvAddr.building,
                          Self.FUserRecvAddr.addr_line3,
                          '',//Self.FUserRecvAddr.postcode,
                          Self.FUserRecvAddr.tag,

                          //GCJ02
                          Self.FUserRecvAddr.latitude,
                          Self.FUserRecvAddr.longitude,

                          Self.FUserRecvAddr.is_default,
                          Self.FUserRecvAddr.sex
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

procedure TFrameAddRecvAddr.DoAddRecvAddrExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        //添加过收货地址,返回需要刷新
        GlobalIsRecvAddrChanged:=True;

        //添加收货地址返回
        HideFrame;//(Self,hfcttBeforeReturnFrame);
        ReturnFrame;//(Self.FrameHistroy);


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

procedure TFrameAddRecvAddr.DoDeleteAddrExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
    TTimerTask(ATimerTask).TaskDesc:=
            SimpleCallAPI('del_user_recv_addr',
                            nil,
                            UserCenterInterfaceUrl,
                            ['appid',
                            'user_fid',
                            'key',
                            'user_recv_addr_fid'],
                            [AppID,
                            GlobalManager.User.fid,
                            GlobalManager.User.key,
                            Self.FUserRecvAddr.fid],
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


procedure TFrameAddRecvAddr.DoDeleteAddrExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          //删除过收货地址,返回需要刷新
          GlobalIsRecvAddrChanged:=True;

          //返回
          HideFrame;//(Self,hfcttBeforeReturnFrame);
          ReturnFrame;//(Self.FrameHistroy);

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



//procedure TFrameAddRecvAddr.DoGetAddrLatLngExecute(ATimerTask: TObject);
//var
//  AResponseStream:TStringStream;
//  AHttpControl:THttpControl;
//  AIsSuccProcess:Boolean;
//begin
//  try
//    AIsSuccProcess:=False;
//    //出错
//    TTimerTask(ATimerTask).TaskTag:=1;
//
//    AHttpControl:=TSystemHttpControl.Create;
//    AResponseStream:=TStringStream.Create('',TEncoding.Utf8);
//    try
//        {$IFDEF USE_GOOGLE_ROUTE_PLAN}
//        //国外
//        //调谷歌接口
////        AIsSuccProcess:=AHttpControl.Get(
////              uBaseHttpControl.FixSupportIPV6URL('https://maps.googleapis.com')
////                          +'/maps/api/geocode/json?'
////                          +'address='+Self.edtAddr.Text+Self.btnSelectProvince.Caption  //输入地址
////                          +'&key='+uGPSLocation.GoogleAPIKey,
////                          AResponseStream
////                  );
//
//        {$ELSE}
//
//        //调用其他
//
//        {$ENDIF}
//
//        TTimerTask(ATimerTask).TaskDesc:=AResponseStream.DataString;
//
//        if AIsSuccProcess=True then
//        begin
//          TTimerTask(ATimerTask).TaskTag:=0;
//        end
//        else
//        begin
//          TTimerTask(ATimerTask).TaskTag:=1;
//        end;
//
//    finally
//      AResponseStream.Free;
//      FreeAndNil(AHttpControl);
//    end;
//  except
//    on E:Exception do
//    begin
//      //异常
//      TTimerTask(ATimerTask).TaskDesc:=E.Message;
//    end;
//  end;
//end;
//
//
//procedure TFrameAddRecvAddr.DoGetAddrLatLngExecuteEnd(ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//begin
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      {$IFDEF USE_GOOGLE_ROUTE_PLAN}
//      if ASuperObject.S['status']='OK' then
//      begin
//        FUserRecvAddr.latitude:=GetJsonDoubleValue(ASuperObject.A['results'].O[0].O['geometry'].O['location'],'lat');
//        FUserRecvAddr.longitude:=GetJsonDoubleValue(ASuperObject.A['results'].O[0].O['geometry'].O['location'],'lng');
//      end;
//      {$ELSE}
//
//      {$ENDIF}
//      FMX.Types.Log.d('OrangeUI DoGetAddrLatLngExecute Flongitude'+FloatToStr(FUserRecvAddr.longitude));
//      FMX.Types.Log.d('OrangeUI DoGetAddrLatLngExecuteEnd FLatitude'+FloatToStr(FUserRecvAddr.latitude));
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    HideWaitingFrame;
//  end;
//end;

procedure TFrameAddRecvAddr.DoReturnFrameFromSetPointMapFrame(AFrame: TFrame);
begin
  Self.FUserRecvAddr.latitude:=GlobalSetGPSPointFrame.FMapAnnotation.Location.ConvertToGCJ02.Latitude;
  Self.FUserRecvAddr.longitude:=GlobalSetGPSPointFrame.FMapAnnotation.Location.ConvertToGCJ02.Longitude;



  FLat:=GlobalSetGPSPointFrame.FMapAnnotation.Location.ConvertToGCJ02.Latitude;
  FLng:=GlobalSetGPSPointFrame.FMapAnnotation.Location.ConvertToGCJ02.Longitude;


//  bd09ll_Gcj02(GlobalSetGPSPointFrame.FSelectedLat,
//                GlobalSetGPSPointFrame.FSelectedLng,
//                FUserRecvAddr.latitude,
//                FUserRecvAddr.longitude);

//  Self.FLocation:=GlobalSetGPSPointFrame.FLocation;

  FShortAddr:=GlobalSetGPSPointFrame.edtAddr.Text;

  Self.FUserRecvAddr.street:=GlobalSetGPSPointFrame.edtAddr.Text;
  Self.btnStreet.Caption:=GlobalSetGPSPointFrame.edtAddr.Text;
end;

procedure TFrameAddRecvAddr.DoUpdateRecvAddrExecute(
  ATimerTask: TObject);
var
//  AResponseStream:TStringStream;
  AHttpControl:THttpControl;
//  AIsSuccProcess:Boolean;
  ASuperObject:ISuperObject;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
//    if FIsNeedLatLng=True then
//    begin
//      AIsSuccProcess:=False;
//      //出错
//
//      AHttpControl:=TSystemHttpControl.Create;
//      AResponseStream:=TStringStream.Create('',TEncoding.Utf8);
//      try
//          {$IFDEF USE_GOOGLE_ROUTE_PLAN}
//          //国外
//          //调谷歌接口
//          AIsSuccProcess:=//AHttpControl.Get(
//                  GetWebUrl_From_OrangeUIServer(AHttpControl,
//                    'https://maps.googleapis.com'
//                            +'/maps/api/geocode/json?'
//                            +'address='+Self.FUserRecvAddr.addr //输入地址
//                            +'&key='+GoogleAPIKey,
//                            AResponseStream
//                    );
//
//          {$ELSE}
//          //国内
//          //调百度接口
//          AIsSuccProcess:=//AHttpControl.Get(
//                  GetWebUrl_From_OrangeUIServer(AHttpControl,
//                            'http://api.map.baidu.com'
//                            +'/geocoder/v2/?'
//                            +'address='+Self.FUserRecvAddr.addr //输入地址
//                            +'&output=json'
//                            +'&ak='+BaiduAPIKey,
//                            AResponseStream
//                    );
//          {$ENDIF}
//
//          if AIsSuccProcess=True then
//          begin
//            //获取成功
//
//            ASuperObject:=TSuperObject.Create(AResponseStream.DataString);
//            {$IFDEF USE_GOOGLE_ROUTE_PLAN}
//            if ASuperObject.S['status']='OK' then
//            begin
//              if ASuperObject.A['results'].O[0].O['geometry'].S['location_type']='ROOFTOP' then
//              begin
//                FUserRecvAddr.latitude:=GetJsonDoubleValue(ASuperObject.A['results'].O[0].O['geometry'].O['location'],'lat');
//                FUserRecvAddr.longitude:=GetJsonDoubleValue(ASuperObject.A['results'].O[0].O['geometry'].O['location'],'lng');
//              end
//              else
//              begin
//                FMX.Types.Log.d('OrangeUI DoAddRecvAddrExecute Fail');
//                TTimerTask(ATimerTask).TaskTag:=2;
//                //经纬度获取失败
//                ShowMessageBoxFrame(Self,'输入地址有误,不能精确定位!','',TMsgDlgType.mtInformation,['确定'],nil);
//                Exit;
//              end;
//            end;
//            {$ELSE}
//             if ASuperObject.I['status']=0 then
//              begin
//
//                FUserRecvAddr.latitude:=GetJsonDoubleValue(ASuperObject.O['result'].O['location'],'lat');
//                FUserRecvAddr.longitude:=GetJsonDoubleValue(ASuperObject.O['result'].O['location'],'lng');
//
//              end
//              else
//              begin
//
//                FMX.Types.Log.d('OrangeUI DoAddRecvAddrExecute Fail');
//                TTimerTask(ATimerTask).TaskTag:=2;
//                //经纬度获取失败
//                ShowMessageBoxFrame(Self,'获取经纬度失败!','',TMsgDlgType.mtInformation,['确定'],nil);
//                Exit;
//              end;
//            {$ENDIF}
//          end
//          else
//          begin
//            //经纬度获取失败
//            ShowMessageBoxFrame(Self,'经纬度获取失败!','',TMsgDlgType.mtInformation,['确定'],nil);
//            Exit;
//          end;
//
//      finally
//        AResponseStream.Free;
//        FreeAndNil(AHttpControl);
//      end;
//    end;

    TTimerTask(ATimerTask).TaskDesc:=
                  SimpleCallAPI('update_user_recv_addr',
                                nil,
                                UserCenterInterfaceUrl,
                                ['appid',
                                'user_fid',
                                'key',
                                'user_recv_addr_fid',
                                'name',
                                'phone',
                                'country',
                                'province',
                                'city',
                                'area',
                                'addr',
                                'street',
                                'building',
                                'addr_line3',
                                'postcode',
                                'tag',
                                'latitude',
                                'longitude',
                                'is_default',
                                'sex'],
                                [AppID,
                                GlobalManager.User.fid,
                                GlobalManager.User.key,
                                Self.FUserRecvAddr.fid,
                                Self.FUserRecvAddr.name,
                                Self.FUserRecvAddr.phone,
                                Self.FUserRecvAddr.country,
                                Self.FUserRecvAddr.province,
                                Self.FUserRecvAddr.city,
                                Self.FUserRecvAddr.area,
                                Self.FUserRecvAddr.addr,
                                Self.FUserRecvAddr.street,
                                '',//Self.FUserRecvAddr.building,
                                Self.FUserRecvAddr.addr_line3,
                                '',//Self.FUserRecvAddr.postcode,
                                Self.FUserRecvAddr.Tag,
                                Self.FUserRecvAddr.latitude,
                                Self.FUserRecvAddr.longitude,
                                Self.FUserRecvAddr.is_default,
                                Self.FUserRecvAddr.sex
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


procedure TFrameAddRecvAddr.DoUpdateRecvAddrExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

          //修改过收货地址,返回需要刷新
          GlobalIsRecvAddrChanged:=True;

          //返回
          HideFrame;//(Self,hfcttBeforeReturnFrame);
          ReturnFrame;//(Self.FrameHistroy);

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


procedure TFrameAddRecvAddr.Edit(AUserRecvAddr:TUserRecvAddr);
begin

  Self.pnlToolBar.Caption:='修改地址';

  Self.FUserRecvAddr.Assign(AUserRecvAddr);

  Self.btnDel.Visible:=True;

  Self.FUserFID:=AUserRecvAddr.user_fid;



  Self.FLat:=AUserRecvAddr.latitude;
  Self.FLng:=AUserRecvAddr.longitude;

//  Gcj02_bd09ll(AUserRecvAddr.latitude,
//              AUserRecvAddr.longitude,
//              FLat,FLng);

  Self.FShortAddr:=AUserRecvAddr.street;

  LoadUserRecvAddrToUI(AUserRecvAddr);

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
end;



function TFrameAddRecvAddr.GetCurrentPorcessControl(
  AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameAddRecvAddr.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;


function TFrameAddRecvAddr.GetVirtualKeyboardHeightAdjustHeight: Double;
begin
  Result:=0;
end;

//procedure TFrameAddRecvAddr.Input(AUserRecvAddr:TUserRecvAddr);
//begin
////  Self.pnlToolBar.Caption:='填写收货地址';
////
////  FUserRecvAdd.Assign(AUserRecvAdd);
////
////  LoadUserRecvAddToUI(AUserRecvAdd);
////
////  //添加酒店时输入收货地址,
////  //本身就是做为默认地址
////  //不用选择
////  Self.pnlIsDefault.Visible:=False;
////
////  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
//end;


procedure TFrameAddRecvAddr.LoadUserRecvAddrToUI(AUserRecvAddr:TUserRecvAddr);
begin
  Self.edtName.Text:=AUserRecvAddr.name;
  Self.edtPhone.Text:=AUserRecvAddr.phone;

  if AUserRecvAddr.sex=0 then
  begin
    Self.rbMr.Prop.Checked:=True;
  end
  else
  begin
    Self.rbMs.Prop.Checked:=True;
  end;

  if AUserRecvAddr.tag='家' then
  begin
    Self.rbHome.Prop.Checked:=True;
  end
  else if AUserRecvAddr.tag='公司' then
   begin
     Self.rbCompany.Prop.Checked:=True;
   end
   else if AUserRecvAddr.tag='学校' then
   begin
     Self.rbSchool.Prop.Checked:=True;
   end;

   Self.btnSelectProvince.Caption:=AUserRecvAddr.GetArea;//.area+AUserRecvAddr.city+AUserRecvAddr.province;

   Self.edtBuilding.Text:=AUserRecvAddr.building;

   Self.btnStreet.Caption:=AUserRecvAddr.street;

   Self.edtPostCode.Text:=AUserRecvAddr.postcode;

   Self.edtOther.Text:=AUserRecvAddr.addr_line3;

//  Self.edtAddr.Text:=AUserRecvAddr.addr;
//  Self.memAddr.Text:=AUserRecvAdd.addr;

//  Self.chkIsDefault.Prop.Checked:=(AUserRecvAdd.is_default=1);

end;



procedure TFrameAddRecvAddr.OnModalResultFromDeleteAddr(Frame: TObject);
begin
  if TFrameMessageBox(Frame).ModalResult='确定' then
  begin
    //删除
    ShowWaitingFrame(Self,'删除中...');
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                     DoDeleteAddrExecute,
                     DoDeleteAddrExecuteEnd,
                     'DeleteAddr');
  end
  else
  begin
    //留在本页面
  end;
end;


procedure TFrameAddRecvAddr.OnReturnFrameFromSelectArea(Frame: TFrame);
begin
  FUserRecvAddr.province:='';
  FUserRecvAddr.city:='';
  FUserRecvAddr.area:='';


  //选择省市返回
  if GlobalSelectAreaFrame.lbProvience.Prop.SelectedItem<>nil then
  begin
    FUserRecvAddr.province:=GlobalSelectAreaFrame.lbProvience.Prop.SelectedItem.Caption;
  end;
  if GlobalSelectAreaFrame.lbCity.Prop.SelectedItem<>nil then
  begin
    FUserRecvAddr.city:=GlobalSelectAreaFrame.lbCity.Prop.SelectedItem.Caption;
  end;
  if GlobalSelectAreaFrame.lbCounty.Prop.SelectedItem<>nil then
  begin
    FUserRecvAddr.area:=GlobalSelectAreaFrame.lbCounty.Prop.SelectedItem.Caption;
  end;



//  FUserRecvAddr.province:=GlobalSelectAreaFrame.FSelectedProvince;
//  FUserRecvAddr.city:=GlobalSelectAreaFrame.FSelectedCity;
//  FUserRecvAddr.area:=GlobalSelectAreaFrame.FSelectedArea;

  if (GlobalSelectAreaFrame.lbProvience.Prop.SelectedItem<>nil)
    or (GlobalSelectAreaFrame.lbCity.Prop.SelectedItem<>nil) then
  begin
    Self.btnSelectProvince.Caption:=FUserRecvAddr.GetArea;
  end
  else
  begin
    Self.btnSelectProvince.Caption:='';
  end;

end;


procedure TFrameAddRecvAddr.OnReturnFromSelectAddrFrame(AFrame: TFrame);
begin

//  FUserRecvAddr.street:=GlobalGetAddrListFrame.FSelectedAddr;

  Self.btnStreet.Caption:=GlobalGetAddrListFrame.FSelectedAddr;

  FUserRecvAddr.latitude:=GlobalGetAddrListFrame.FSelectedLat;
  FUserRecvAddr.longitude:=GlobalGetAddrListFrame.FSelectedLng;

  FUserRecvAddr.province:=GlobalGetAddrListFrame.FProvince;
  FUserRecvAddr.city:=GlobalGetAddrListFrame.FCity;
  FUserRecvAddr.area:=GlobalGetAddrListFrame.FArea;

  FUserRecvAddr.postcode:=GlobalGetAddrListFrame.FPostCode;

//  FUserRecvAddr.addr:=GlobalGetAddrListFrame.FSelectedAddrDetail;

  if (FUserRecvAddr.Province<>'') or (FUserRecvAddr.City<>'') then
  begin
    if FUserRecvAddr.Area<>'' then
    begin
      Self.btnSelectProvince.Caption:=FUserRecvAddr.GetArea;

    end
    else
    begin
      Self.btnSelectProvince.Caption:=FUserRecvAddr.City+','+FUserRecvAddr.Province;

    end;
  end;


  Self.edtPostCode.Text:=GlobalGetAddrListFrame.FPostCode;

//  FUserRecvAddr.addr:=GlobalGetAddrListFrame.FSelectedAddrDetail;
//  if Self.edtBuilding.Text<>'' then
//  begin
//    FUserRecvAddr.addr:=Self.btnStreet.Caption
//                               +','+Self.edtBuilding.Text
//                               +','+Self.btnSelectProvince.Caption
//                               +','+Self.edtPostCode.Text;
//  end
//  else
//  begin
//    //拼接值换过位置  邮编暂时不需要
//    FUserRecvAddr.addr:=Self.btnSelectProvince.Caption
//                               +','+Self.btnStreet.Caption;
////                               +','+Self.edtPostCode.Text;
//  end;

end;


//procedure TFrameAddRecvAddr.OnReturnNotice(Sender: TObject);
//begin
//
////  if FAddrListFrame.FSelectedAddr<>'' then
////  begin
////    FUserRecvAddr.street:=FAddrListFrame.FSelectedAddr;
////
////    Self.edtStreet.Text:=FAddrListFrame.FSelectedAddr;
////
////    FUserRecvAddr.latitude:=FAddrListFrame.FSelectedLat;
////    FUserRecvAddr.longitude:=FAddrListFrame.FSelectedLng;
////
////    FUserRecvAddr.province:=FAddrListFrame.FProvince;
////    FUserRecvAddr.city:=FAddrListFrame.FCity;
////    FUserRecvAddr.area:=FAddrListFrame.FArea;
////
////    FUserRecvAddr.postcode:=FAddrListFrame.FPostCode;
////
////    FUserRecvAddr.addr:=FAddrListFrame.FSelectedAddrDetail;
////
////    if FAddrListFrame.FArea<>'' then
////    begin
////      Self.btnSelectProvince.Caption:=FAddrListFrame.FArea+','+FAddrListFrame.FCity+','+FAddrListFrame.FProvince;
////
////    end
////    else
////    begin
////      Self.btnSelectProvince.Caption:=FAddrListFrame.FCity+','+FAddrListFrame.FProvince;
////
////    end;
////
////    Self.edtPostCode.Text:=FAddrListFrame.FPostCode;
////
////
////  end
////  else
////  begin
////
////    Self.edtStreet.Text:=FAddrListFrame.edtSearch.Text;
////  end;
////
////  FAddrListFrame.Visible:=False;
////
////  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);
//end;


procedure TFrameAddRecvAddr.rbCompanyChange(Sender: TObject);
begin
  Self.FUserRecvAddr.tag:=Self.rbCompany.Caption;
end;

procedure TFrameAddRecvAddr.rbHomeChange(Sender: TObject);
begin
  Self.FUserRecvAddr.tag:=Self.rbHome.Caption;
end;

procedure TFrameAddRecvAddr.rbMrClick(Sender: TObject);
begin
  Self.FUserRecvAddr.sex:=0;
end;

procedure TFrameAddRecvAddr.rbMsClick(Sender: TObject);
begin
  Self.FUserRecvAddr.sex:=1;
end;

procedure TFrameAddRecvAddr.rbSchoolChange(Sender: TObject);
begin
  Self.FUserRecvAddr.tag:=Self.rbSchool.Caption;
end;

procedure TFrameAddRecvAddr.Add;
begin
  uBaseLog.HandleException(nil,'TFrameAddRecvAddr.Add Begin');

  Self.pnlToolBar.Caption:='新增地址';

  Self.btnDel.Visible:=False;

  Self.FUserFID:=GlobalManager.User.fid;

//  Gcj02_bd09ll(GlobalGPSLocation.Latitude,
//              GlobalGPSLocation.Longitude,
//              FLat,FLng);




  //默认取定位到的地址
  if GlobalGPSLocation<>nil then
  begin
    FShortAddr:=GlobalGPSLocation.RegionName;

    FLat:=GlobalGPSLocation.Latitude;
    FLng:=GlobalGPSLocation.Longitude;

  end;



  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);


  uBaseLog.HandleException(nil,'TFrameAddRecvAddr.Add End');

end;

end.
