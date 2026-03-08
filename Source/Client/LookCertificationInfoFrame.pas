unit LookCertificationInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uUIFunction,
  uFrameContext,
  uManager,
  uOpenClientCommon,
  uBaseList,
  uSkinItems,
  uDrawPicture,
  uTimerTask,
//  uOpenClientCommon,
  EasyServiceCommonMaterialDataMoudle,

  XSuperObject,
  uRestInterfaceCall,
  MessageBoxFrame,

  uFuncCommon,
  WaitingFrame,
  uOpenCommon,

  System.StrUtils,

  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyImage, uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinImageType,
  uSkinLabelType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListBoxType, uSkinButtonType,
  uBaseSkinControl, uSkinPanelType, uDrawCanvas;

type
  TFrameLookCertificationInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbdata: TSkinFMXListBox;
    pnl2: TSkinFMXItemDesignerPanel;
    lblHead: TSkinFMXLabel;
    imgHead: TSkinFMXImage;
    pnl1: TSkinFMXItemDesignerPanel;
    lblItemName: TSkinFMXLabel;
    lblItemDetail: TSkinFMXLabel;
    btnEdit: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure lbdataClickItem(AItem: TSkinItem);
  private
    FPictureList: TDrawPictureList;

    //获取用户实名认证信息
    procedure DoGetUserCertInfoExecute(ATimerTask:TObject);
    procedure DoGetUserCertInfoExecuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public

    FUserCertInfo:TUserCertInfo;
    procedure Load(AUser:TUser;AIsShowBtnEdit:Boolean);
    procedure DoChangeClickFromFrame(Frame: TFrame);
    { Public declarations }
  end;

var
  GlobalLookCertificationInfoFrame:TFrameLookCertificationInfo;

implementation

uses
//  FillUserInfoFrame,
//  ViewPictureListFrame,
  MainForm,
  CertificateUserInfoFrame;

{$R *.fmx}

procedure TFrameLookCertificationInfo.btnReturnClick(Sender: TObject);
begin
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

constructor TFrameLookCertificationInfo.Create(AOwner: TComponent);
begin
  inherited;

  FPictureList:=TDrawPictureList.Create(ooReference);

  FUserCertInfo:=TUserCertInfo.Create;

  Self.lbdata.Prop.Items.FindItemByCaption('证件正面照').Icon.Clear;


  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

destructor TFrameLookCertificationInfo.Destroy;
begin
  FreeAndNil(FPictureList);
  FreeAndNil(FUserCertInfo);
  inherited;
end;

procedure TFrameLookCertificationInfo.DoChangeClickFromFrame(Frame: TFrame);
begin
  case GlobalCertificateUserInfoFrame.FID_type of
    0:Self.lbdata.Prop.Items.FindItemByCaption('证件').Detail:='驾照';
    1:Self.lbdata.Prop.Items.FindItemByCaption('证件').Detail:='护照';
    2:Self.lbdata.Prop.Items.FindItemByCaption('证件').Detail:='十八加卡';
    3:Self.lbdata.Prop.Items.FindItemByCaption('证件').Detail:='身份证';
  end;
  Self.lbdata.Prop.Items.FindItemByCaption('证件号码').Detail:=GlobalCertificateUserInfoFrame.FID_Code;
  Self.lbdata.Prop.Items.FindItemByCaption('证件正面照').Icon.Url:=ImageHttpServerUrl+'/'+ReplaceStr(GlobalCertificateUserInfoFrame.FID_FrontPic,'\','/');
end;

procedure TFrameLookCertificationInfo.DoGetUserCertInfoExecute(
  ATimerTask: TObject);
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=1;

  try
      TTimerTask(ATimerTask).TaskDesc:=SimpleCallAPI('get_cert_info',
                                                      nil,
                                                      UserCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'emp_fid'],
                                                      [AppID,
                                                      GlobalManager.User.fid,
                                                      GlobalManager.User.key,
                                                      0],
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

procedure TFrameLookCertificationInfo.DoGetUserCertInfoExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);

      Self.FUserCertInfo.ParseFromJson(ASuperObject.O['Data'].A['UserCertInfo'].O[0]);
      if ASuperObject.I['Code']=200 then
      begin
        //获取用户实名认证信息成功
        if GlobalManager.User.fid=FUserCertInfo.user_fid then
        begin
          //是自己,可以修改
          Self.btnEdit.Visible:=True;
        end
        else
        begin
          Self.btnEdit.Visible:=False;
        end;

        case FUserCertInfo.id_type of
          0:Self.lbdata.Prop.Items.FindItemByCaption('证件').Detail:='驾照';
          1:Self.lbdata.Prop.Items.FindItemByCaption('证件').Detail:='护照';
          2:Self.lbdata.Prop.Items.FindItemByCaption('证件').Detail:='十八加卡';
          3:Self.lbdata.Prop.Items.FindItemByCaption('证件').Detail:='身份证';
        end;

        Self.lbdata.Prop.Items.FindItemByCaption('证件号码').Detail:=FUserCertInfo.id_code;
        Self.lbdata.Prop.Items.FindItemByCaption('证件正面照').Icon.Url:=FUserCertInfo.GetIDFrontPicUrl;
        Self.lbdata.Prop.Items.FindItemByCaption('证件正面照').Icon.PictureDrawType:=TPictureDrawType.pdtAuto;

        Self.FPictureList.Clear(False);

        Self.FPictureList.Add(Self.lbdata.Prop.Items.FindItemByCaption('证件正面照').Icon);

      end
      else
      begin
        //注册失败
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


procedure TFrameLookCertificationInfo.lbdataClickItem(AItem: TSkinItem);
begin
  //显示照片

//  if AItem.ItemType=sitHeader then
//  begin
//    //查看照片信息
//    HideFrame;//(Self,hfcttBeforeShowFrame);
//    //查看照片信息
//    ShowFrame(TFrame(GlobalViewPictureListFrame),TFrameViewPictureList,frmMain,nil,nil,nil);
//
//
//    GlobalViewPictureListFrame.FrameHistroy:=CurrentFrameHistroy;
//
//    GlobalViewPictureListFrame.Init(AItem.Caption,
//                                      FPictureList,
//                                      AItem.Index-5);
//  end;
end;

procedure TFrameLookCertificationInfo.Load(AUser:TUser;AIsShowBtnEdit:Boolean);
var
  value:String;
begin

  Self.btnEdit.Visible:=AIsShowBtnEdit;
  Self.btnEdit.Enabled:=AIsShowBtnEdit;
  Self.btnEdit.Caption:='修改';
  if Not AIsShowBtnEdit then Self.btnEdit.Caption:='';


  //获取用户实名认证信息
  ShowWaitingFrame(Self,'获取中...');

  uTimerTask.GetGlobalTimerThread.RunTempTask(
          DoGetUserCertInfoExecute,
          DoGetUserCertInfoExecuteEnd,
          'GetUserCertInfo');

end;

procedure TFrameLookCertificationInfo.btnEditClick(Sender: TObject);
begin
  //隐藏
  HideFrame;//(Self,hfcttBeforeShowFrame);
  //显示实名认证提交界面
  ShowFrame(TFrame(GlobalCertificateUserInfoFrame),TFrameCertificateUserInfo,frmMain,nil,nil,DoChangeClickFromFrame,Application);
  GlobalCertificateUserInfoFrame.Load(Self.FUserCertInfo);
end;

end.
