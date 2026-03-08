unit MyInvitationCodeFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uMobileUtils,
  HintFrame,

  uUIFunction,
  uRestInterfaceCall,
  uFileCommon,
  uOpenClientCommon,
//  TestInterfaceForm,
  uTimerTask,
  uManager,

  uUrlPicture,
  uDownloadPictureManager,
  uSkinBufferBitmap,
  ShareBarCodeFrame,
  uConst,
  uContentOperation,
  CommonImageDataMoudle,
  uOpenCommon,

  MyInvitationUserListFrame,

  XSuperJSON,
  XSuperObject,

  WaitingFrame,
  MessageBoxFrame,
  DelphiZXingQRCode,
  uBaseHttpControl,
  EasyServiceCommonMaterialDataMoudle,

  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox, uSkinFireMonkeyScrollBoxContent, System.Actions,
  FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions, uSkinImageType,
  uSkinLabelType, uSkinScrollBoxContentType, uSkinScrollControlType,
  uSkinScrollBoxType, uSkinButtonType, uBaseSkinControl, uSkinPanelType,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit;

type
  TFrameMyInvitationCode = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlBox: TSkinFMXPanel;
    pnlMyInvitation: TSkinFMXPanel;
    lblQRCode: TSkinFMXLabel;
    imgQRCode: TSkinFMXImage;
    btnMyInvite: TSkinFMXButton;
    ActionList1: TActionList;
    ShowShareSheetAction1: TShowShareSheetAction;
    ShowShareSheetAction2: TShowShareSheetAction;
    SkinFMXPanel1: TSkinFMXPanel;
    lblCaption: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
    lblLink: TSkinFMXLabel;
    SkinFMXPanel2: TSkinFMXPanel;
    imgBackground: TSkinFMXImage;
    imgTop: TSkinFMXImage;
    btnOK: TSkinFMXButton;
    lblScore: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnSyncClick(Sender: TObject);
    procedure btnItemDetail3Click(Sender: TObject);
    procedure ShowShareSheetAction1BeforeExecute(Sender: TObject);
    procedure pnlBoxResize(Sender: TObject);
    procedure lblLinkClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnMyInviteClick(Sender: TObject);
  private
//    FCode:String;
//    Procedure DoGetMyInvitationCodeExecute(ATimerTask:TObject);
//    Procedure DoGetMyInvitationCodeExecuteEnd(ATimerTask:TObject);
  FContentOperation:TContentOperation;
  private
    procedure DoGetInviterRegisterLinkExecute(ATimerTask:TObject);
    procedure DoGetInviterRegisterLinkExecuteEnd(ATimerTask:TObject);

    // 调用签到规则接口
    procedure DoSignRuleExecute(ATimerTask:TObject);
    procedure DoSignRuleExecuteEnd(ATimerTask:TObject);

//    procedure DoShareSucc(Sender:TObject);
    { Private declarations }
  public
    FrameHistroy:TFrameHistroy;
    FScore:Double;

    constructor Create(AOwner:TComponent);override;
  public
    procedure Load;

    //清空
    procedure Clear;
    { Public declarations }
  end;

var
  GlobalMyInvitationCodeFrame:TFrameMyInvitationCode;

procedure SyncQRCode(ALink:String;AImage:TSkinFMXImage);

implementation

uses
  MainForm;

{$R *.fmx}

{ TFrameMyInvitationCode }

procedure TFrameMyInvitationCode.btnItemDetail3Click(Sender: TObject);
begin
  //复制邀请码
  MySetClipboard(
              Self.lblLink.Caption
              );
  ShowHintFrame(Self,'复制成功!');
end;

//显示已经邀请人员列表
procedure TFrameMyInvitationCode.btnMyInviteClick(Sender: TObject);
begin
  //隐藏
  HideFrame;
  ShowFrame(TFrame(GlobalMyInvitationUserListFrame),TFrameMyInvitationUserList);
  GlobalMyInvitationUserListFrame.Load;
end;

procedure TFrameMyInvitationCode.btnOKClick(Sender: TObject);
var
  AUrlPicture:TUrlPicture;
  AContentJson:ISuperObject;
  AThumbBitmap:TBitmap;
begin
    //分享

    {AUrlPicture:=GetGlobalDownloadPictureManager.FindUrlPicture(
            GetImageUrl(AContentJson.S['pic1_path']));
    if (AUrlPicture=nil)
      or (AUrlPicture.Picture=nil)
      or (AUrlPicture.Picture.IsEmpty) then
    begin
      ShowHintFrame(Self,'图片正在下载中,请稍候...');
      exit;
    end;}

    //生成缩略图
    AThumbBitmap:=TBitmap.Create;
    try
      //100的太模糊,但是大小刚合适
      uSkinBufferBitmap.CreateThumbBitmap(dmCommonImageDataMoudle.imglistAppIcon.PictureList[0],AThumbBitmap,100,100);
      AThumbBitmap.SaveToFile(GetApplicationPath+'share_thumb.jpg');
    finally
      FreeAndNil(AThumbBitmap);
    end;

    //微信分享   弹出分享选择框   链接+小图标+自定义文本
    ShowFrame(TFrame(GlobalShareBarCodeFrame),TFrameShareBarCode,frmMain,nil,nil,nil,Self,False,True,ufsefNone);
    GlobalShareBarCodeFrame.Load(Self.lblLink.Caption,
                                 '告别跑路，传情赔付！',
                                 '快来注册吧！',
                                 GetApplicationPath+'share_thumb.jpg',
                                 nil
                                 );
    GlobalShareBarCodeFrame.ShowMenu;
    Exit;
end;

procedure TFrameMyInvitationCode.btnReturnClick(Sender: TObject);
begin
  HideFrame(Self,hfcttBeforeReturnFrame);
  ReturnFrame(Self.FrameHistroy);
end;

procedure TFrameMyInvitationCode.btnSyncClick(Sender: TObject);
begin
  Self.Load;
end;

procedure TFrameMyInvitationCode.Clear;
begin
  Self.lblLink.Text:='';
  //Self.lblPhone.Caption:='';
end;

constructor TFrameMyInvitationCode.Create(AOwner: TComponent);
begin
  inherited;
  //Self.lblInvitationCode.Caption:='';
  Self.imgQRCode.Prop.Picture.Clear;
end;

procedure TFrameMyInvitationCode.DoGetInviterRegisterLinkExecute(
  ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('user_get_invite_register_info',
                                                      nil,
//                                                      TeaEcologyInterfaceUrl,
                                                      UserCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      '']
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
  finally

  end;
end;

procedure TFrameMyInvitationCode.DoGetInviterRegisterLinkExecuteEnd(
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
        //获取成功
        Self.lblLink.Caption:=ASuperObject.O['Data'].S['Register_Url'];

        //刷新二维码
        SyncQRCode(ASuperObject.O['Data'].S['Register_Url'],Self.imgQRCode);
      end
      else
      begin
        //生成失败
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

//procedure TFrameMyInvitationCode.DoShareSucc(Sender: TObject);
//begin
//  Self.FContentOperation.tteUserShareContent.Run();
//end;

procedure TFrameMyInvitationCode.DoSignRuleExecute(ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;
  try
    TTimerTask(ATimerTask).TaskDesc:=
      SimpleCallAPI('get_app_score_rule_list',
                    nil,
                    ScoreCenterInterfaceUrl,
                    ['appid',
                    'emp_fid',
                    'key',
                    'filter_rule_type'
                    ],
                    [AppID,
                     GlobalManager.User.fid,
                     GlobalManager.User.key,
                     'invite_regist'
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

procedure TFrameMyInvitationCode.DoSignRuleExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
        //LoadListRecord(ASuperObject);
        FScore:= ASuperObject.O['Data'].A['AppScoreRuleList'].O[0].F['gift_introducer_score'];
        lblScore.Caption:=FloatToStr(FScore);
      end else
      begin
        //获取失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;
    end
    else if TTimerTask(ATimerTask).TaskTag=1 then
    begin
      //网络异常
      ShowMessageBoxFrame(Self,'网络异常,请检查您的网络连接!',
                            UserCenterInterfaceUrl+#13#10
                            +TTimerTask(ATimerTask).TaskDesc,
                            TMsgDlgType.mtInformation,
                            ['确定'],nil);
    end;
  finally
    HideWaitingFrame;
  end;
end;

//点击分享链接
procedure TFrameMyInvitationCode.lblLinkClick(Sender: TObject);
begin
//  MySetClipboard(
//              Self.lblLink.Caption
//              );
//  ShowHintFrame(Self,'复制成功!');
end;

//procedure TFrameMyInvitationCode.DoGetMyInvitationCodeExecute(
//  ATimerTask: TObject);
//begin
//  //出错
//  TTimerTask(ATimerTask).TaskTag:=1;
//  try
//    try
//      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('generate_bind_code',
//                                                      nil,
//                                                      TeaEcologyInterfaceUrl,
//                                                      ['appid',
//                                                      'user_fid'],
//                                                      [AppID,
//                                                      GlobalManager.User.fid]
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
//procedure TFrameMyInvitationCode.DoGetMyInvitationCodeExecuteEnd(
//  ATimerTask: TObject);
//var
//  ASuperObject:ISuperObject;
//
//begin
//
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//      if ASuperObject.I['Code']=200 then
//      begin
//          //邀请码
//          Self.lblInvitationCode.Text:=ASuperObject.O['Data'].S['BindCode'];
//
//          FCode:=ASuperObject.O['Data'].S['BindCode'];
//          //有效期
//          Self.lblTimeOut.Text:='有效期:'+ASuperObject.O['Data'].S['TimeOut'];
//
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

procedure TFrameMyInvitationCode.Load;
begin

  Self.Clear;

  //Self.lblPhone.Caption:=GlobalManager.User.phone;

  Self.sbcClient.Height:=GetSuitScrollContentHeight(Self.sbcClient);

  ShowWaitingFrame(Self,'加载中...');

  //调用链接转二维码接口生成二维码
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                     DoGetInviterRegisterLinkExecute,
                     DoGetInviterRegisterLinkExecuteEnd,
                     'GetInviterRegisterLink');

  //调用邀请规则接口加载奖励积分
  uTimerTask.GetGlobalTimerThread.RunTempTask(
      DoSignRuleExecute,
      DoSignRuleExecuteEnd,
      'get_app_score_rule_list'
      );

end;

procedure TFrameMyInvitationCode.pnlBoxResize(Sender: TObject);
begin
  Self.pnlMyInvitation.Left:=10;

  Self.pnlMyInvitation.Width:=(Self.Width-30)/2;

  //Self.pnlPhone.Left:=Self.pnlMyInvitation.Left+Self.pnlMyInvitation.Width+10;
  //Self.pnlPhone.Width:=(Self.Width-30)/2;
end;

procedure TFrameMyInvitationCode.ShowShareSheetAction1BeforeExecute(
  Sender: TObject);
begin
  ShowShareSheetAction1.Bitmap.Assign(Self.imgQRCode.Prop.Picture);
end;

procedure SyncQRCode(ALink: String;AImage:TSkinFMXImage);
var
  QRCode:TDelphiZXingQRCode;
  QRCodeBitmap:TBitmap;
  Row, Column, ScaleRow, ScaleColumn: Integer;
  Data: TBitmapData;
  Scale : integer;
begin

  QRCodeBitmap := TBitmap.Create;
  QRCode := TDelphiZXingQRCode.Create;
  try
    QRCode.Data := ALink;
    QRCode.Encoding := TQRCodeEncoding.qrAuto;
    // QuietZone 是四周的白边。
    QRCode.QuietZone := 3;
    //QRCode.QuietZone := 0; //just test
//    QRCode.ErrorLevels := TQRErrorLevels.ecM;
    QRCode.ErrorLevels := TQRErrorLevels.ecH;
    //型号，或者说规模。
    QRCode.ModelVersion := 0;

    Scale := 6;

    QRCodeBitmap.SetSize(Scale * QRCode.Rows, Scale * QRCode.Columns);
    QRCodeBitmap.Clear(TAlphaColorRec.White);

    QRCodeBitmap.Map(TMapAccess.ReadWrite, Data);
    try
      for Row := 0 to QRCode.Rows - 1 do
      begin
        for Column := 0 to QRCode.Columns - 1 do
        begin
          if (QRCode.IsBlack[Row, Column]) then
          begin
            //开始缩放。
            for ScaleRow := 0 to Scale - 1 do
            begin
              for ScaleColumn := 0 to Scale - 1 do
              begin
                Data.SetPixel(Column * Scale + ScaleColumn, Row * Scale + ScaleRow, TAlphaColorRec.Black);
              end;
            end;
          end;
        end;
      end;
    finally
      QRCodeBitmap.Unmap(Data);
    end;

    AImage.Prop.Picture.Assign(QRCodeBitmap);

    //保存测试
    {$IFDEF MSWINDOWS}
    QRCodeBitmap.SaveToFile(GetApplicationPath+'QRCodeBitmap.png');
    {$ENDIF}
  finally
    FreeAndNil(QRCode);
    FreeAndNil(QRCodeBitmap);
  end;

end;

end.

