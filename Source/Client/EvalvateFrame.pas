unit EvalvateFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.StrUtils,
  System.IOUtils,
  uSkinListViewType,
  Math,
  uBaseList,
  uSkinBufferBitmap,

//  uOpenCommon,
  uComponentType,
  uDrawTextParam,
  uOpenClientCommon,
  uOpenCommon,
  uFrameContext,

  EvalvateManagerFrame,
  {$IFDEF CLIENT_APP}
  EvalvateGoodsManagerFrame,
  {$ENDIF}

  uManager,
//  uShopManager,
//  uFrameContext,
//  uOpenClientCommon,
  uTimerTask,
  uUIFunction,
  uFuncCommon,
  XSuperObject,
  XSuperJson,
  uAPPCommon,

  SelectPictureFrame,

  MessageBoxFrame,
  WaitingFrame,
  EasyServiceCommonMaterialDataMoudle,

  uBaseHttpControl,
  uRestInterfaceCall,
//  uCommonUtils,

  uSkinItems,

  IDURI,
  HzSpell,

  uDrawPicture,

  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinScrollControlType,
  uSkinScrollBoxType, uSkinFireMonkeyScrollBox, uSkinScrollBoxContentType,
  uSkinFireMonkeyScrollBoxContent, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinImageType, uSkinFireMonkeyImage;

type
  TFrameEvalvate = class(TFrame
                         ,IFrameVirtualKeyboardAutoProcessEvent
                         ,IFrameVirtualKeyboardEvent)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcContent: TSkinFMXScrollBoxContent;
    pnlArriveTime: TSkinFMXPanel;
    lblTime: TSkinFMXLabel;
    lblTimeValue: TSkinFMXLabel;
    SkinFMXPanel1: TSkinFMXPanel;
    btnOk: TSkinFMXButton;
    pnlShop: TSkinFMXPanel;
    imgShopPic: TSkinFMXImage;
    lblShopName: TSkinFMXLabel;
    procedure btnOkClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
  private
    //订单FID
    FOrderFID:Integer;
    //订单FID
    FShopOrderFID:Integer;

    //订单
    FOrder:TOrder;

    //评价FID
    FEvalvateFID:Integer;

    FFrameList:TBaseList;

    FEvalvateFrame:TFrameEvalvateManager;
    {$IFDEF CLIENT_APP}
    FGoodEvalvateFrame:TFrameEvalveteGoodsManager;
    {$ENDIF}
    FObjectArray:ISuperArray;
  private
    {$IFDEF CLIENT_APP}
    //获取订单详情
    procedure DoGetOrderInfoExecute(ATimerTask:TObject);
    procedure DoGetOrderInfoExecuteEnd(ATimerTask:TObject);
    {$ENDIF}

    //修改评价
    procedure DoChangeEvalvateInfoExecute(ATimerTask:TObject);
    procedure DoChangeEvalvateInfoExecuteEnd(ATimerTask:TObject);

    {$IFDEF SHOP_APP}
    //获取订单详情
    procedure DoGetShopOrderInfoExecute(ATimerTask:TObject);
    procedure DoGetShopOrderInfoExecuteEnd(ATimerTask:TObject);
    {$ENDIF}
  private
    //去评价
    procedure DoEvalvateOrderInfoExecute(ATimerTask:TObject);
    procedure DoEvalvateOrderInfoExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    {$IFDEF CLIENT_APP}
    //订单类型
    FRestInterfaceUrl:String;
    FStringList:TStringList;
    //客户端
    procedure LoadOrder(AOrder:TOrder);

    procedure LoadDeliveryOrder(ADeliveryOrder:TDeliveryOrder);
    //加载
    procedure Load(AOrderFID:Integer;AUrl:String);
    {$ENDIF}

    {$IFDEF SHOP_APP}
    //商家端
    procedure LoadShopOrder(AShopOrder:TShopOrder);

    //加载
    procedure LoadShop(AShopOrderFID:Integer);
    {$ENDIF}
    procedure Edit(ACaption:String;
                    AFID:Integer;
                    AShopFID:String;
                    ARiderFID:String;
                    AEvalvateFID:Integer;
                    AScore:Double;
                    Atags:String;
                    AContent:String;
                    AIsAnonymous:Boolean;
                    AOrder:TOrder);

    procedure Clear;


    //当前需要处理的控件
    function GetCurrentPorcessControl(AFocusedControl:TControl):TControl;
    function GetVirtualKeyboardControlParent:TControl;
    //获取虚拟键盘的高度校正
    function GetVirtualKeyboardHeightAdjustHeight:Double;
    //显示虚拟键盘
    procedure DoVirtualKeyboardShow(KeyboardVisible: Boolean; const Bounds: TRect);
    //隐藏虚拟键盘
    procedure DoVirtualKeyboardHide(KeyboardVisible: Boolean; const Bounds: TRect);
    { Public declarations }
  end;

var
  GlobalEvalvateFrame:TFrameEvalvate;

implementation

{$R *.fmx}

{ TFrameEvalvate }

procedure TFrameEvalvate.btnOkClick(Sender: TObject);
var
  I: Integer;


  {$IFDEF CLIENT_APP}
  AGoodFrame:TFrameEvalveteGoodsManager;
  {$ENDIF}


  AFrame:TFrameEvalvateManager;
//  AIndex:Integer;
begin

//  AIndex:=0;
//  FObjectArray:=TSuperArray.Create;
  //FMX.Types.Log.d('OrangeUI --btnOkClick- 1');


  {$IFDEF CLIENT_APP}
  FStringList.Clear;
  {$ENDIF}


  //FMX.Types.Log.d('OrangeUI --btnOkClick- 2');
  for I := 0 to Self.FFrameList.Count-1 do
  begin


      {$IFDEF CLIENT_APP}
      //FMX.Types.Log.d('OrangeUI --btnOkClick- 3');
      if FFrameList[I] is TFrameEvalveteGoodsManager then
      begin
        AGoodFrame:=TFrameEvalveteGoodsManager(FFrameList[I]);
        //FMX.Types.Log.d('OrangeUI --btnOkClick- 4');
        if Not AGoodFrame.CheckInputIsOK then
        begin
              //检查不通过
              Exit;
        end
        else
        begin
                AGoodFrame.FSelectPictureFrame.SaveToLocalTemp(100,'.jpg');
//              FObjectArray.O[AIndex]:=AGoodFrame.GetObjectJson;
//              //FMX.Types.Log.d('OrangeUI --btnOkClick- 5');
//              if FObjectArray.O[AIndex].S['pic1_path']<>'' then
//              begin
//                GlobalEvalvateFrame.FStringList.Add(FObjectArray.O[AIndex].S['pic1_path']);
//              end;
//
//              if FObjectArray.O[AIndex].S['pic2_path']<>'' then
//              begin
//                GlobalEvalvateFrame.FStringList.Add(FObjectArray.O[AIndex].S['pic2_path']);
//              end;
//
//              if FObjectArray.O[AIndex].S['pic3_path']<>'' then
//              begin
//                GlobalEvalvateFrame.FStringList.Add(FObjectArray.O[AIndex].S['pic3_path']);
//              end;
              //FMX.Types.Log.d('OrangeUI --btnOkClick- 6');
        end;
      end;
      {$ENDIF}



      //FMX.Types.Log.d('OrangeUI --btnOkClick- 7');
      if FFrameList[I] is TFrameEvalvateManager then
      begin
          //FMX.Types.Log.d('OrangeUI --btnOkClick- 8');
          AFrame:=TFrameEvalvateManager(FFrameList[I]);
          //FMX.Types.Log.d('OrangeUI --btnOkClick- 9');
          if Not AFrame.CheckInputIsOK then
          begin
                Exit;
          end
          else
          begin
//                //FMX.Types.Log.d('OrangeUI --btnOkClick- 10');
//                FObjectArray.O[AIndex]:=AFrame.GetObjectJson;
          end;
      end;



//      Inc(AIndex);


  end;



  //FMX.Types.Log.d('OrangeUI --btnOkClick- 11');

  ShowWaitingFrame(Self,'处理中...');
  if FEvalvateFID=0 then
  begin

    //去评价
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                    DoEvalvateOrderInfoExecute,
                    DoEvalvateOrderInfoExecuteEnd,
                    'EvalvateOrderInfo');
  end
  else
  begin
    //修改评价
    uTimerTask.GetGlobalTimerThread.RunTempTask(
                     DoChangeEvalvateInfoExecute,
                     DoChangeEvalvateInfoExecuteEnd,
                     'ChangeEvalvateInfo');
  end;

  //FMX.Types.Log.d('OrangeUI --btnOkClick- 12');

end;

procedure TFrameEvalvate.btnReturnClick(Sender: TObject);
begin
 if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

  //返回
  HideFrame;//();
  ReturnFrame();
end;

procedure TFrameEvalvate.Clear;
var
  I:Integer;
  {$IFDEF CLIENT_APP}
  AGoodFrame:TFrameEvalveteGoodsManager;
  {$ENDIF}
  AFrame:TFrameEvalvateManager;
begin
  //清除原来的
  Self.lblShopName.Caption:='';

  FOrderFID:=0;
  //订单FID
  FShopOrderFID:=0;

  //评价FID
  FEvalvateFID:=0;

  Self.imgShopPic.Prop.Picture.Clear;
  Self.lblTimeValue.Caption:='';

  Self.pnlShop.Visible:=False;
  Self.pnlArriveTime.Visible:=False;

  for I := FFrameList.Count-1 downto 0 do
  begin
   {$IFDEF CLIENT_APP}
    if FFrameList[I] is TFrameEvalveteGoodsManager then
    begin
      AGoodFrame:=TFrameEvalveteGoodsManager(FFrameList[I]);
      FFrameList.Delete(I,False);
      AGoodFrame.Parent:=nil;
      FreeAndNil(AGoodFrame);
    end
    else if FFrameList[I] is TFrameEvalvateManager then
    begin
      AFrame:=TFrameEvalvateManager(FFrameList[I]);
      FFrameList.Delete(I,False);
      AFrame.Parent:=nil;
      FreeAndNil(AFrame);
    end;
    {$ENDIF}

   {$IFDEF SHOP_APP}
    if FFrameList[I] is TFrameEvalvateManager then
    begin
      AFrame:=TFrameEvalvateManager(FFrameList[I]);
      FFrameList.Delete(I,False);
      AFrame.Parent:=nil;
      FreeAndNil(AFrame);
    end;
    {$ENDIF}

  end;

  Self.sbClient.Prop.VertControlGestureManager.Position:=0;
end;

constructor TFrameEvalvate.Create(AOwner: TComponent);
begin
  inherited;
  FFrameList:=TBaseList.Create(ooReference);
  {$IFDEF CLIENT_APP}
  FStringList:=TStringList.Create;
  {$ENDIF}

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  Self.btnOk.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=SkinThemeColor;
  Self.lblTimeValue.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;
end;

destructor TFrameEvalvate.Destroy;
begin
  FreeAndNil(FFrameList);
  inherited;
end;

procedure TFrameEvalvate.DoChangeEvalvateInfoExecute(ATimerTask: TObject);
var
  I: Integer;


  {$IFDEF CLIENT_APP}
  AGoodFrame:TFrameEvalveteGoodsManager;
  {$ENDIF}


  AFrame:TFrameEvalvateManager;
  AIndex:Integer;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try

      AIndex:=0;
      //FMX.Types.Log.d('OrangeUI --btnOkClick- 1');
      FObjectArray:=TSuperArray.Create;


      {$IFDEF CLIENT_APP}
      FStringList.Clear;
      {$ENDIF}


      //FMX.Types.Log.d('OrangeUI --btnOkClick- 2');
      for I := 0 to Self.FFrameList.Count-1 do
      begin


          {$IFDEF CLIENT_APP}
          //FMX.Types.Log.d('OrangeUI --btnOkClick- 3');
          if FFrameList[I] is TFrameEvalveteGoodsManager then
          begin
            AGoodFrame:=TFrameEvalveteGoodsManager(FFrameList[I]);
            //FMX.Types.Log.d('OrangeUI --btnOkClick- 4');
            if Not AGoodFrame.CheckInputIsOK then
            begin
                  //检查不通过
                  Exit;
            end
            else
            begin
                  FObjectArray.O[AIndex]:=AGoodFrame.GetObjectJson;
                  //FMX.Types.Log.d('OrangeUI --btnOkClick- 5');
                  if FObjectArray.O[AIndex].S['pic1_path']<>'' then
                  begin
                    GlobalEvalvateFrame.FStringList.Add(FObjectArray.O[AIndex].S['pic1_path']);
                  end;

                  if FObjectArray.O[AIndex].S['pic2_path']<>'' then
                  begin
                    GlobalEvalvateFrame.FStringList.Add(FObjectArray.O[AIndex].S['pic2_path']);
                  end;

                  if FObjectArray.O[AIndex].S['pic3_path']<>'' then
                  begin
                    GlobalEvalvateFrame.FStringList.Add(FObjectArray.O[AIndex].S['pic3_path']);
                  end;
                  //FMX.Types.Log.d('OrangeUI --btnOkClick- 6');
            end;
          end;
          {$ENDIF}



          //FMX.Types.Log.d('OrangeUI --btnOkClick- 7');
          if FFrameList[I] is TFrameEvalvateManager then
          begin
              //FMX.Types.Log.d('OrangeUI --btnOkClick- 8');
              AFrame:=TFrameEvalvateManager(FFrameList[I]);
              //FMX.Types.Log.d('OrangeUI --btnOkClick- 9');
              if Not AFrame.CheckInputIsOK then
              begin
                    Exit;
              end
              else
              begin
                    //FMX.Types.Log.d('OrangeUI --btnOkClick- 10');
                    FObjectArray.O[AIndex]:=AFrame.GetObjectJson;
              end;
          end;



          Inc(AIndex);


      end;



    TTimerTask(ATimerTask).TaskDesc:=
                          SimpleCallAPI('update_evaluate_object',
                          nil,
                          EvaluateCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'object_fid',
                          'score',
                          'orderno',
                          'content',
                          'tags',
                          'pic1_path',
                          'pic2_path',
                          'pic3_path'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          Self.FEvalvateFID,
                          FObjectArray.O[0].F['score'],
                          FObjectArray.O[0].F['orderno'],
                          FObjectArray.O[0].S['content'],
                          FObjectArray.O[0].S['tags'],
                          FObjectArray.O[0].S['pic1_path'],
                          FObjectArray.O[0].S['pic2_path'],
                          FObjectArray.O[0].S['pic3_path']
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

procedure TFrameEvalvate.DoChangeEvalvateInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AOrder:TOrder;
  ACarGood:TCarGood;
  I:Integer;
begin
  try
      if TTimerTask(ATimerTask).TaskTag=0 then
      begin
        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

        //FMX.Types.Log.d('OrangeUI ASuperObject'+ASuperObject.AsJSON);
        if ASuperObject.I['Code']=200 then
        begin
          //评价成功,返回
          HideFrame;//();
          ReturnFrame();
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

procedure TFrameEvalvate.DoEvalvateOrderInfoExecute(ATimerTask: TObject);
var
  I: Integer;


  {$IFDEF CLIENT_APP}
  AGoodFrame:TFrameEvalveteGoodsManager;
  {$ENDIF}


  AFrame:TFrameEvalvateManager;
  AIndex:Integer;
  AStringStream:TStringStream;
  AHttpControl:TSystemHttpControl;
  AResponseStream:TStringStream;
  AFileUploadSucc:Boolean;
  ASuperObject:ISuperObject;
  AServerFileName:String;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try



      AIndex:=0;
      //FMX.Types.Log.d('OrangeUI --btnOkClick- 1');
      FObjectArray:=TSuperArray.Create;


      {$IFDEF CLIENT_APP}
      FStringList.Clear;
      {$ENDIF}


      //FMX.Types.Log.d('OrangeUI --btnOkClick- 2');
      for I := 0 to Self.FFrameList.Count-1 do
      begin


          {$IFDEF CLIENT_APP}
          //FMX.Types.Log.d('OrangeUI --btnOkClick- 3');
          if FFrameList[I] is TFrameEvalveteGoodsManager then
          begin
            AGoodFrame:=TFrameEvalveteGoodsManager(FFrameList[I]);
            //FMX.Types.Log.d('OrangeUI --btnOkClick- 4');
            if Not AGoodFrame.CheckInputIsOK then
            begin
                  //检查不通过
                  Exit;
            end
            else
            begin
                  FObjectArray.O[AIndex]:=AGoodFrame.GetObjectJson;
                  //FMX.Types.Log.d('OrangeUI --btnOkClick- 5');
                  if FObjectArray.O[AIndex].S['pic1_path']<>'' then
                  begin
                    GlobalEvalvateFrame.FStringList.Add(FObjectArray.O[AIndex].S['pic1_path']);
                  end;

                  if FObjectArray.O[AIndex].S['pic2_path']<>'' then
                  begin
                    GlobalEvalvateFrame.FStringList.Add(FObjectArray.O[AIndex].S['pic2_path']);
                  end;

                  if FObjectArray.O[AIndex].S['pic3_path']<>'' then
                  begin
                    GlobalEvalvateFrame.FStringList.Add(FObjectArray.O[AIndex].S['pic3_path']);
                  end;
                  //FMX.Types.Log.d('OrangeUI --btnOkClick- 6');
            end;
          end;
          {$ENDIF}



          //FMX.Types.Log.d('OrangeUI --btnOkClick- 7');
          if FFrameList[I] is TFrameEvalvateManager then
          begin
              //FMX.Types.Log.d('OrangeUI --btnOkClick- 8');
              AFrame:=TFrameEvalvateManager(FFrameList[I]);
              //FMX.Types.Log.d('OrangeUI --btnOkClick- 9');
              if Not AFrame.CheckInputIsOK then
              begin
                    Exit;
              end
              else
              begin
                    //FMX.Types.Log.d('OrangeUI --btnOkClick- 10');
                    FObjectArray.O[AIndex]:=AFrame.GetObjectJson;
              end;
          end;



          Inc(AIndex);


      end;




      //体积太大,保存成文件上传
      AServerFileName:='';
      AStringStream:=TStringStream.Create('',TEncoding.UTF8);
      AHttpControl:=TSystemHttpControl.Create;
      AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
      try
          AStringStream.WriteString(FObjectArray.AsJSON);
          AStringStream.Position:=0;

          AFileUploadSucc:=AHttpControl.Post(
                TIdURI.URLEncode(
//                             'http://www.orangeui.cn:10001'//测试
                             ImageHttpServerUrl
                             +'/upload'
                             +'?appid='+(AppID)
                             +'&filedir='+'Evaluate_Json'
                             +'&fileext='+'.txt'

                  ),
                  AStringStream,AResponseStream);


          if AFileUploadSucc then
          begin
            AResponseStream.Position:=0;
            ASuperObject:=TSuperObject.Create(AResponseStream.DataString);
            if ASuperObject.I['Code']=200 then
            begin
              //上传成功
              AServerFileName:=ASuperObject.O['Data'].S['RemoteFilePath'];
              //'Upload\1004\Evaluate_Json\2019\2019-10-11\7A4A473C63024CD78F9E4293FC7B7CFA.txt'
            end
            else
            begin
              //上传失败
              //AServerResponseDesc:=ASuperObject.S['Desc'];
            end;

          end;


      finally
        FreeAndNil(AStringStream);
        FreeAndNil(AHttpControl);
        FreeAndNil(AResponseStream);
      end;




      TTimerTask(ATimerTask).TaskDesc:=
                            SimpleCallAPI('evaluate_object',
                            nil,
//                            'http://www.orangeui.cn:10000/evaluatecenter/',
                            EvaluateCenterInterfaceUrl,
                            ['appid',
                            'user_fid',
                            'evaluate_items_json',
                            'evaluate_items_json_file_path'],
                            [AppID,
                            GlobalManager.User.fid,
                            '',
                            AServerFileName
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

procedure TFrameEvalvate.DoEvalvateOrderInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AOrder:TOrder;
  ACarGood:TCarGood;
  I:Integer;
begin
  try
      if TTimerTask(ATimerTask).TaskTag=0 then
      begin
        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
        //FMX.Types.Log.d('OrangeUI --DoEvalvateOrderInfoExecuteEnd- 1');
        //FMX.Types.Log.d('OrangeUI ASuperObject'+ASuperObject.AsJSON);
        if ASuperObject.I['Code']=200 then
        begin
          //评价成功,返回
          HideFrame;//();
          ReturnFrame();
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

{$IFDEF CLIENT_APP}
procedure TFrameEvalvate.DoGetOrderInfoExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
                          SimpleCallAPI('user_get_order',
                          nil,
                          FRestInterfaceUrl,
                          [
                          'appid',
                          'user_fid',
                          'key',
                          'order_fid'
                          ],
                          [AppID,
                          GlobalManager.User.fid,
                          GlobalManager.User.key,
                          FOrderFid
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

procedure TFrameEvalvate.DoGetOrderInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AOrder:TOrder;
  ACarGood:TCarGood;
  ADeliveryOrder:TDeliveryOrder;
  I:Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

      //FMX.Types.Log.d('OrangeUI ASuperObject'+ASuperObject.AsJSON);
      if ASuperObject.I['Code']=200 then
      begin

        try
//          FUserOrderList.Clear(True);
          if FRestInterfaceUrl=ShopCenterInterfaceUrl then
          begin
              AOrder:=TOrder.Create;
              //刷新订单信息
              AOrder.ParseFromJson(ASuperObject.O['Data'].A['OrderInfo'].O[0]);
              LoadOrder(AOrder);
          end
          else
          begin
              ADeliveryOrder:=TDeliveryOrder.Create;
              ADeliveryOrder.ParseFromJson(ASuperObject.O['Data'].A['OrderInfo'].O[0]);
              LoadDeliveryOrder(ADeliveryOrder);
          end;



        finally
//           FreeAndNil(AOrder);
        end;

      end
      else
      begin
        //获取订单失败
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

procedure TFrameEvalvate.DoVirtualKeyboardHide(KeyboardVisible: Boolean;
  const Bounds: TRect);
begin
  Self.SkinFMXPanel1.Visible:=True;
end;

procedure TFrameEvalvate.DoVirtualKeyboardShow(KeyboardVisible: Boolean;
  const Bounds: TRect);
begin
  Self.SkinFMXPanel1.Visible:=False;;
end;

{$ENDIF}

procedure TFrameEvalvate.Edit(ACaption: String;AFID:Integer;AShopFID:String;ARiderFID:String;
                              AEvalvateFID:Integer;
                              AScore: Double; Atags,
                              AContent: String; AIsAnonymous: Boolean;AOrder:TOrder);
var
  AFrame:TFrameEvalvateManager;
begin
  Self.Clear;


  FEvalvateFID:=AEvalvateFID;

  Self.pnlShop.Visible:=False;
  Self.pnlArriveTime.Visible:=False;

  AFrame:=TFrameEvalvateManager.Create(Self);
  SetFrameName(AFrame);
  AFrame.Parent:=Self.sbcContent;
  AFrame.Align:=TAlignLayout.Top;
  AFrame.AutoSize;
  AFrame.Position.Y:=10;


  if ACaption='评价商家服务' then
  begin
    //商家服务评价
    AFrame.Load('评价商家服务',
                '配送快',
                '准时送达',
                '送货上门',
                {$IFNDEF YC}
                '餐品保存完好',
                {$ENDIF}
                {$IFDEF YC}
                '商品保存完好',
                {$ENDIF}
                '主动联系',
                '态度很好',
                AFID,
                AShopFID,
                ARiderFID,
                0,
                AOrder);
  end
  else
  begin
    AFrame.Load('评价配送服务',
                '衣着整洁',
                {$IFNDEF YC}
                '餐品完好',
                {$ENDIF}
                {$IFDEF YC}
                '商品完好',
                {$ENDIF}
                '准时到达',
                '服务态度好',
                {$IFNDEF YC}
                '送餐快',
                {$ENDIF}
                {$IFDEF YC}
                '送货快',
                {$ENDIF}
                '穿着专业',
                AFID,
                AShopFID,
                ARiderFID,
                0,
                AOrder);
  end;

  AFrame.Edit(ACaption,AScore,Atags,AContent,AIsAnonymous);

  Self.FFrameList.Add(AFrame);
end;

function TFrameEvalvate.GetCurrentPorcessControl(
  AFocusedControl: TControl): TControl;
begin
  Result:=AFocusedControl;
end;

function TFrameEvalvate.GetVirtualKeyboardControlParent: TControl;
begin
  Result:=Self;
end;

function TFrameEvalvate.GetVirtualKeyboardHeightAdjustHeight: Double;
begin
  Result:=0;
end;

{$IFDEF SHOP_APP}
procedure TFrameEvalvate.DoGetShopOrderInfoExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
                          SimpleCallAPI('shop_get_order',
                          nil,
                          ShopCenterInterfaceUrl,
                          ['appid',
                          'user_fid',
                          'key',
                          'order_fid',
                          'shop_fid'],
                          [AppID,
                          GlobalManager.User.fid,
                          GlobalManager.User.key,
                          FShopOrderFID,
                          GlobalManager.AsShop.Shop.fid
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

procedure TFrameEvalvate.DoGetShopOrderInfoExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AShopOrder:TShopOrder;
  ACarGood:TCarGood;
  I:Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

      //FMX.Types.Log.d('OrangeUI ASuperObject'+ASuperObject.AsJSON);
      if ASuperObject.I['Code']=200 then
      begin

        try
//          FUserOrderList.Clear(True);
          AShopOrder:=TShopOrder.Create;
          //刷新订单信息
          AShopOrder.ParseFromJson(ASuperObject.O['Data'].A['OrderInfo'].O[0]);


          LoadShopOrder(AShopOrder);

        finally
//           FreeAndNil(AOrder);
        end;

      end
      else
      begin
        //获取订单失败
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
procedure TFrameEvalvate.DoVirtualKeyboardHide(KeyboardVisible: Boolean;
  const Bounds: TRect);
begin
  Self.SkinFMXPanel1.Visible:=True;
end;

procedure TFrameEvalvate.DoVirtualKeyboardShow(KeyboardVisible: Boolean;
  const Bounds: TRect);
begin
  Self.SkinFMXPanel1.Visible:=False;
end;

{$ENDIF}

{$IFDEF CLIENT_APP}
procedure TFrameEvalvate.Load(AOrderFID: Integer;AUrl:String);
begin

  Self.Clear;

  FOrderFID:=AOrderFID;

  FRestInterfaceUrl:=AUrl;


  //获取订单详情
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                DoGetOrderInfoExecute,
                DoGetOrderInfoExecuteEnd,
                'GetOrderInfo');


end;
procedure TFrameEvalvate.LoadDeliveryOrder(ADeliveryOrder: TDeliveryOrder);
var
  AFrame:TFrameEvalvateManager;
begin

  Self.Clear;

  Self.pnlShop.Visible:=False;
  Self.pnlArriveTime.Visible:=True;


  AFrame:=TFrameEvalvateManager.Create(Self);
  SetFrameName(AFrame);
  AFrame.Parent:=Self.sbcContent;
  AFrame.Align:=TAlignLayout.Top;
  AFrame.AutoSize;
  AFrame.Position.Y:=Self.pnlToolBar.Position.Y+10;
  //商家服务评价
  AFrame.Load('评价商家服务',
              '配送快',
              '准时送达',
              '送货上门',
              {$IFNDEF YC}
              '餐品保存完好',
              {$ENDIF}
              {$IFDEF YC}
              '商品保存完好',
              {$ENDIF}
              '主动联系',
              '态度很好',
              ADeliveryOrder.fid,
              '0',
              ADeliveryOrder.user_fid,
              0,
              nil);




  FFrameList.Add(AFrame);

  Self.pnlArriveTime.Position.Y:=AFrame.Position.Y+10;

  //送达时间
  Self.lblTimeValue.Caption:=FormatDateTime('MM-DD HH:MM',StandardStrToDateTime(ADeliveryOrder.want_arrive_time));




end;

{$ENDIF}

{$IFDEF SHOP_APP}
procedure TFrameEvalvate.LoadShop(AShopOrderFID: Integer);
begin
  Self.Clear;
  FShopOrderFID:=AShopOrderFID;

  //获取订单详情
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                DoGetShopOrderInfoExecute,
                DoGetShopOrderInfoExecuteEnd,
                'GetShopOrderInfo');
end;


procedure TFrameEvalvate.LoadShopOrder(AShopOrder: TShopOrder);
var
  AFrame:TFrameEvalvateManager;
begin

  Clear;

  FEvalvateFID:=0;

  Self.pnlShop.Visible:=True;
  Self.pnlArriveTime.Visible:=True;

  Self.imgShopPic.Prop.Picture.Url:=AShopOrder.GetShopLogoPicUrl;
  Self.imgShopPic.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtUrl;

  //店铺名称
  Self.lblShopName.Caption:=AShopOrder.shop_name;

  //配送服务评价
  AFrame:=TFrameEvalvateManager.Create(Self);
  SetFrameName(AFrame);
  AFrame.Parent:=Self.sbcContent;
  AFrame.Align:=TAlignLayout.Top;
  AFrame.AutoSize;
  AFrame.Position.Y:=+10;
  //配送服务评价
//  AFrame.Load('评价配送服务',
//              '衣着整洁',
//              {$IFNDEF YC}
//              '餐品完好',
//              {$ENDIF}
//              {$IFDEF YC}
//              '商品完好',
//              {$ENDIF}
//              '准时到达',
//              '服务态度好',
//              '送餐快',
//              '穿着专业',
//              AShopOrder.fid,
//              AShopOrder.shop_fid,
//              AShopOrder.rider_user_fid,
//              0,
//              FOrder);
  FFrameList.Add(AFrame);


  Self.pnlArriveTime.Position.Y:=AFrame.Position.Y+20;

  //送达时间
  Self.lblTimeValue.Caption:=FormatDateTime('MM-DD HH:MM',StandardStrToDateTime(AShopOrder.want_arrive_time));



  Self.sbcContent.Height:=GetSuitScrollContentHeight(Self.sbcContent);

end;
{$ENDIF}

{$IFDEF CLIENT_APP}
procedure TFrameEvalvate.LoadOrder(AOrder: TOrder);
var
  I: Integer;
  AFrame1:TFrameEvalvateManager;
  AFrame2:TFrameEvalvateManager;
  AGoodsFrame:TFrameEvalveteGoodsManager;
  ANames:TStringArray;
  AUrls:TStringArray;
  J: Integer;
  AHeight:Double;
  AIsFirst:Boolean;
  AIndex:Integer;
  AMaxIndex:Integer;
begin


//  Self.Clear;

  AHeight:=0;

  AIndex:=0;
  AMaxIndex:=0;

  FEvalvateFID:=0;


  //从费用列表中获取商品列表
  for J := 0 to AOrder.OrderFees.Count-1 do
  begin
    if AOrder.OrderFees[J].fee_type='goods_money' then
    begin
      AMaxIndex:=AMaxIndex+1;
    end;
  end;

  SetLength(ANames,1);
  SetLength(AUrls,1);

  FOrder:=AOrder;

  Self.pnlShop.Visible:=True;
  Self.pnlArriveTime.Visible:=True;

  Self.imgShopPic.Prop.Picture.Url:=AOrder.GetShopLogoPicUrl;
  Self.imgShopPic.Prop.Picture.PictureDrawType:=TPictureDrawType.pdtUrl;

  //店铺名称
  Self.lblShopName.Caption:=AOrder.shop_name;

//  AHeight:=Self.pnlShop.Position.Y+Self.pnlShop.Height;
  //商品评价
  if AOrder.OrderFees.Count>0 then
  begin
    for I := 0 to AOrder.OrderFees.Count-1 do
    begin
      if AOrder.OrderFees[I].fee_type='goods_money' then
      begin

            //创建评价Frame
            AIndex:=AIndex+1;
            AGoodsFrame:=TFrameEvalveteGoodsManager.Create(Self);
            SetFrameName(AGoodsFrame);
            AGoodsFrame.Parent:=Self.sbcContent;
            AGoodsFrame.Align:=TAlignLayout.MostTop;
            AGoodsFrame.Position.Y:=Self.pnlShop.Position.Y+Self.pnlShop.Height;

    //        AHeight:=AGoodsFrame.Position.Y+AGoodsFrame.Height;

            if AOrder.OrderFees[I].pic1_path<>'' then
            begin
              ANames[0]:=AOrder.OrderFees[I].pic1_path;
              AUrls[0]:=ImageHttpServerUrl+'/'+ReplaceStr(ANames[0],'\','/');
            end;

            if AIndex=AMaxIndex then
            begin
              AIsFirst:=True;
            end
            else
            begin
              AIsFirst:=False;
            end;

            AGoodsFrame.Load(AOrder.OrderFees[I].name{$IFNDEF YC}+'('+AOrder.OrderFees[I].fee_desc+')'{$ENDIF},
                            ANames,
                            AUrls,
                            FOrderFID,
                            AOrder.shop_fid,
                            AOrder.rider_user_fid,
                            AOrder.OrderFees[I].shop_goods_fid,
                            AIsFirst);

            AGoodsFrame.AutoSize;

            FFrameList.Add(AGoodsFrame);
      end;


//      AHeight:=TFrameEvalveteGoodsManager(Self.FFrameList[Self.FFrameList.Count]).Position.Y
//             +TFrameEvalveteGoodsManager(Self.FFrameList[Self.FFrameList.Count]).Height;

    end;

  end;


// if Self.FFrameList.Count>0 then
// begin

//    for I := 0 to Self.FFrameList.Count-1 do
//    begin
//      AHeight:=AHeight+TFrameEvalveteGoodsManager(Self.FFrameList[I]).Height;
//    end;
//    AHeight:=TFrameEvalveteGoodsManager(Self.FFrameList[0]).Position.Y
//             +TFrameEvalveteGoodsManager(Self.FFrameList[0]).Height;
// end
// else
// begin
//    AHeight:=Self.pnlShop.Position.Y+Self.pnlShop.Height;
// end;
//
//  AHeight:=AHeight+Self.pnlShop.Height+10;
//

  //亿诚 区分平台商家(快递  不用评价骑手)  普通商家
  if AOrder.delivery_center_order_fid>0 then
  begin
  {$IFNDEF YC}   //亿诚加了骑手端
   //配送服务评价
    AFrame2:=TFrameEvalvateManager.Create(Self);
    SetFrameName(AFrame2);
    AFrame2.Parent:=Self.sbcContent;
    AFrame2.Align:=TAlignLayout.Top;
    AFrame2.AutoSize;
  //  AFrame2.Position.Y:=AFrame1.Height+AFrame1.Position.Y;
    //配送服务评价
    AFrame2.Load('评价配送服务',
                '衣着整洁',
                {$IFNDEF YC}
                '餐品完好',
                {$ENDIF}
                {$IFDEF YC}
                '商品完好',
                {$ENDIF}
                '准时到达',
                '服务态度好',
                {$IFNDEF YC}
                '送餐快',
                {$ENDIF}
                {$IFDEF YC}
                '送货快',
                {$ENDIF}
                '穿着专业',
                AOrder.delivery_center_order_fid,
                IntToStr(AOrder.shop_fid),
                AOrder.rider_user_fid,
                0,
                AOrder);
    FFrameList.Add(AFrame2);
    {$ENDIF}
  end;


  AFrame1:=TFrameEvalvateManager.Create(Self);
  SetFrameName(AFrame1);
  AFrame1.Parent:=Self.sbcContent;
  AFrame1.Align:=TAlignLayout.Top;
  AFrame1.AutoSize;
//  AFrame1.Position.Y:=AHeight;
  //商家服务评价
  AFrame1.Load('评价商家服务',
              '配送快',
              '准时送达',
              '送货上门',
              {$IFNDEF YC}
              '餐品保存完好',
              {$ENDIF}
              {$IFDEF YC}
              '商品保存完好',
              {$ENDIF}
              '主动联系',
              '态度很好',
              AOrder.fid,
              IntToStr(AOrder.shop_fid),
              AOrder.rider_user_fid,
              0,
              AOrder);
  FFrameList.Add(AFrame1);


//  Self.pnlArriveTime.Position.Y:=AHeight+AFrame1.Height+AFrame2.Height;

  //送达时间
  Self.lblTimeValue.Caption:=FormatDateTime('MM-DD HH:MM',StandardStrToDateTime(AOrder.want_arrive_time));



  Self.sbcContent.Height:=GetSuitScrollContentHeight(Self.sbcContent);

end;

{$ENDIF}

end.
