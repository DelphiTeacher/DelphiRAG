unit ShareBarCodeFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 

  uBaseList,
  uSkinItems,
  uSkinListViewType,
  uSkinListBoxType,
  uRestInterfaceCall,
  uOpenClientCommon,
  uFileCommon,
  uManager,

//  DataMoudleCommonMaterial,
  MessageBoxFrame,
  WaitingFrame,
  HintFrame,
  ComplainUserFrame,


  {$IFDEF HAS_WXPAY}
  //微信支付
  uWeiChat,
  {$ENDIF HAS_WXPAY}

  uUIFunction,
  uTimerTask,
  XSuperObject,
//  uInterfaceClass,
  uBaseHttpControl,
//  uInterfaceHttpControl,

//  uInterfaceManager,
//  uInterfaceData,

    {$IFDEF HAS_CCBARCODESCANNER}
    {$ENDIF}

  DelphiZXingQRCode,
  uMobileUtils,

  //  AndroidApi.Helpers,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, FMX.Controls.Presentation,
  uSkinAnimator, uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, FMX.MediaLibrary.Actions, System.Actions,
  FMX.ActnList, FMX.StdActns, FMX.Edit, uSkinFireMonkeyEdit, uSkinMaterial,
  uSkinButtonType, uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyListView,
  uSkinFireMonkeySwitchPageListPanel, uSkinFireMonkeyPageControl, FMX.Objects,
  uSkinFireMonkeyCustomList, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinPageControlType, uSkinSwitchPageListPanelType,
  uSkinPanelType, uDrawCanvas;

type
  TFrameShareBarCode = class(TFrame)
    pnlBackground: TSkinFMXPanel;
    pnlBottom: TSkinFMXPanel;
    scmaPopup: TSkinControlMoveAnimator;
    pnlContent: TSkinFMXPanel;
    pcTop: TSkinFMXPageControl;
    lvMenus: TSkinFMXListView;
    btnBarCode: TSkinFMXButton;
    pnlDevide: TSkinFMXPanel;
    btnCancel: TSkinFMXButton;
    tsShareProduct: TSkinFMXTabSheet;
    pnlProductShareHint: TSkinFMXPanel;
    pnlBottomLine2: TSkinFMXPanel;
    pnlBottomLine1: TSkinFMXPanel;
    lvOtherMenu: TSkinFMXListView;
    pnlBottomLine3: TSkinFMXPanel;
    procedure FrameResize(Sender: TObject);
    procedure pnlBackgroundClick(Sender: TObject);
    procedure scmaPopupAnimateEnd(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure lvMenusClickItem(Sender: TSkinItem);
    procedure lvOtherMenuClickItem(AItem: TSkinItem);
    { Private declarations }
  protected
    FLink:String;
    FCaption:String;
    FDesc:String;
    FIconPicPath:String;
    FOnShareSucc:TNotifyEvent;
    FDataJson:ISuperObject;

    procedure DoWeichat_ShareResult(Sender:TObject);
  public
    procedure HideMenu;
    procedure ShowMenu;
  public
    //刷新二维码
    procedure SyncQRCode(ALink:String);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  public
//    IsShareSuss:Boolean;
    procedure Load(
                  //要分享的链接
                  ALink:String;
                  //分享的标题
                  ACaption:String;
                  //分享的描述
                  ADesc:String;
                  //分享的图标
                  AIconPicPath:String;
                  //分享成功之后所要调用的事件
                  AOnShareSucc:TNotifyEvent;
                  //自定义的数据,比如内容的数据json,举报要用
                  ADataJson:ISuperObject=nil);


//  private
//    //获取邀请链接
//    procedure DoGetInviterRegisterLinkExecute(ATimerTask:TObject);
//    procedure DoGetInviterRegisterLinkExecuteEnd(ATimerTask:TObject);
  end;




var
  GlobalShareBarCodeFrame:TFrameShareBarCode;

implementation

uses
  MainForm;

{$R *.fmx}


procedure TFrameShareBarCode.HideMenu;
begin
//  scmaPopup.GoForward;
  HideFrame;
  ReturnFrame;

end;


procedure TFrameShareBarCode.Load(ALink,
                                  ACaption,
                                  ADesc,
                                  AIconPicPath: String;
                                  AOnShareSucc:TNotifyEvent;
                                  ADataJson:ISuperObject);
begin
  FLink:=ALink;
  FCaption:=ACaption;
  FDesc:=ADesc;
  FIconPicPath:=AIconPicPath;

  FOnShareSucc:=AOnShareSucc;
  FDataJson:=ADataJson;


//  pnlContent.Align:=TAlignLayout.None;
//  pnlContent.Position.Y:=Self.pnlBottom.Height;

end;

procedure TFrameShareBarCode.lvMenusClickItem(Sender: TSkinItem);
begin
  if (Sender.Caption='微信好友')
    or (Sender.Name='weixin_friend') then
  begin
      HideMenu;
      FMX.Types.Log.d('OrangeUI click item friend');
      {$IFDEF HAS_WXPAY}
        GlobalWeiChat.OnShareResult:=Self.DoWeichat_ShareResult;
        //最后一个参数  分享的场景
        GlobalWeiChat.SendLink(Self.FLink,
                                FCaption,
                                FDesc,
                                Self.FIconPicPath,
                                0);
        {$IFDEF MSWINDOWS}
        //测试
        DoWeichat_ShareResult(Self);
        {$ENDIF MSWINDOWS}
      {$ENDIF HAS_WXPAY}
  end;
  if (Sender.Caption='朋友圈')
    or (Sender.Name='weixin_friendcircle') then
  begin
      HideMenu;
      FMX.Types.Log.d('OrangeUI click item share');
      {$IFDEF HAS_WXPAY}
        GlobalWeiChat.OnShareResult:=Self.DoWeichat_ShareResult;
        GlobalWeiChat.SendLink(Self.FLink,
                              FCaption,
                              FDesc,
                              FIconPicPath,
                              1);
        {$IFDEF MSWINDOWS}
        //测试
        DoWeichat_ShareResult(Self);
        {$ENDIF MSWINDOWS}
      {$ENDIF HAS_WXPAY}
  end;

  if (Sender.Caption='复制链接')
    or (Sender.Name='copy_link') then
  begin
      HideMenu;
      FMX.Types.Log.d('OrangeUI click item copy link');
      MySetClipboard(Self.FLink);
      ShowHintFrame(Self,'链接复制成功');
  end;



//  OpenWebBrowserAndNavigateURL('http://www.baidu.com');
end;

procedure TFrameShareBarCode.lvOtherMenuClickItem(AItem: TSkinItem);
begin

  if (AItem.Caption='举报')
    or (AItem.Name='complain') then
  begin
      HideMenu;
      FMX.Types.Log.d('OrangeUI click item complain');


      //举报内容
      HideFrame;//();
      ShowFrame(TFrame(GlobalComplainUserFrame),TFrameComplainUser);//,frmMain,nil,nil,nil,Application);
  //    Self.popScan.IsOpen:=False;
      GlobalComplainUserFrame.clear;
      GlobalComplainUserFrame.Load(
                                  FDataJson);


//      MySetClipboard(Self.FLink);
//      ShowHintFrame(Self,'链接复制成功');
  end;


end;

procedure TFrameShareBarCode.ShowMenu;
begin
  pnlContent.Caption:='';

  Self.pnlContent.Align:=TAlignLayout.None;
  Self.pnlContent.Anchors:=[TAnchorKind.akLeft,TAnchorKind.akRight,TAnchorKind.akTop];

  Self.pnlBackground.Visible:=True;
  Self.pnlBackground.Align:=TAlignLayout.{$IF CompilerVersion >= 34.0}{$ELSE}al{$ENDIF}None;
  Self.pnlBackground.SetBounds(0,0,Width,Height);
  Self.pnlContent.Width:=Width;
  Self.pnlBackground.BringToFront;



//  scmaPopup.GoBackward;
end;

procedure TFrameShareBarCode.SyncQRCode(ALink: String);
begin

end;

//procedure TFrameShareBarCode.SyncQRCode(ALink: String);
//var
//  QRCode:TDelphiZXingQRCode;
//  QRCodeBitmap:TBitmap;
//  Row, Column, ScaleRow, ScaleColumn: Integer;
//  Data: TBitmapData;
//  Scale : integer;
//begin
//
//  QRCodeBitmap := TBitmap.Create;
//  QRCode := TDelphiZXingQRCode.Create;
//  try
//    QRCode.Data := ALink;
//    QRCode.Encoding := TQRCodeEncoding.qrAuto;
//    // QuietZone 是四周的白边。
//    QRCode.QuietZone := 4;
//    //QRCode.QuietZone := 0; //just test
//    QRCode.ErrorLevels := TQRErrorLevels.ecL;
//    //型号，或者说规模。
//    QRCode.ModelVersion := 0;
//
//    Scale := 6;
//
//    QRCodeBitmap.SetSize(Scale * QRCode.Rows, Scale * QRCode.Columns);
//    QRCodeBitmap.Clear(TAlphaColorRec.White);
//
//    QRCodeBitmap.Map(TMapAccess.ReadWrite, Data);
//    try
//      for Row := 0 to QRCode.Rows - 1 do
//      begin
//        for Column := 0 to QRCode.Columns - 1 do
//        begin
//          if (QRCode.IsBlack[Row, Column]) then
//          begin
//            //开始缩放。
//            for ScaleRow := 0 to Scale - 1 do
//            begin
//              for ScaleColumn := 0 to Scale - 1 do
//              begin
//                Data.SetPixel(Column * Scale + ScaleColumn, Row * Scale + ScaleRow, TAlphaColorRec.Black);
//              end;
//            end;
//          end;
//        end;
//      end;
//    finally
//      QRCodeBitmap.Unmap(Data);
//    end;
//
//    Self.btnBarCode.Prop.Icon.Assign(QRCodeBitmap);
//  finally
//    FreeAndNil(QRCode);
//    FreeAndNil(QRCodeBitmap);
//  end;
//
//end;

procedure TFrameShareBarCode.scmaPopupAnimateEnd(Sender: TObject);
begin
  if Self.scmaPopup.DirectionType=adtForward then
  begin
    Self.pnlBackground.Visible:=False;
    Self.Visible:=False;

//    HideFrame;//(Self,hfcttBeforeReturnFrame,ufsefNone);
//    ReturnFrame(FrameHistroy);
  end;
end;

constructor TFrameShareBarCode.Create(AOwner: TComponent);
begin
  inherited;
  Self.pcTop.Prop.TabHeaderHeight:=0;

//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                     DoGetInviterRegisterLinkExecute,
//                     DoGetInviterRegisterLinkExecuteEnd);
end;

procedure TFrameShareBarCode.DoWeichat_ShareResult(Sender: TObject);
begin
//  IsShareSuss:=True;
  if Assigned(FOnShareSucc) then
  begin
    FOnShareSucc(Self);
  end;

//  if GlobalWeiChat.FResponseCode=0 then
//  begin
//    ShowMessage('分享成功!');
//  end
//  else
//  begin
//    ShowMessage('分享失败!');
//  end;

end;

//procedure TFrameShareBarCode.DoGetInviterRegisterLinkExecute(
//  ATimerTask: TObject);
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//  try
//    try
//      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('user_get_invite_register_info',
//                                                      nil,
//                                                      TeaEcologyInterfaceUrl,
//                                                      ['appid',
//                                                      'user_fid',
//                                                      'key'],
//                                                      [AppID,
//                                                      GlobalManager.User.fid,
//                                                      '']
//                                                      );
//      if TTimerTask(ATimerTask).TaskDesc<>'' then
//      begin
//        TTimerTask(ATimerTask).TaskTag:=0;
//      end;
//
//    except
//      on E:Exception do
//      begin
//        //异常
//        TTimerTask(ATimerTask).TaskDesc:=E.Message;
//      end;
//    end;
//  finally
//
//  end;
//end;
//
//procedure TFrameShareBarCode.DoGetInviterRegisterLinkExecuteEnd(
//  ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//begin
//
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//        //获取成功
//        Self.FLink:=ASuperObject.O['Data'].S['Register_Url'];
//      end
//      else
//      begin
//        //生成失败
//        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
//      end;
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


procedure TFrameShareBarCode.FrameResize(Sender: TObject);
begin
  Self.pnlBackground.SetBounds(0,0,Width,Height);
  Self.pnlContent.Width:=Width;
end;

procedure TFrameShareBarCode.pnlBackgroundClick(Sender: TObject);
begin
  //取消
  HideMenu;
end;

procedure TFrameShareBarCode.btnCancelClick(Sender: TObject);
begin
  //取消
  HideMenu;
end;

end.


