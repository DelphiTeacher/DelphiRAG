unit ActivityCenterFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uConst,
  //翻译
  FMX.Consts,

  uBaseLog,
  HintFrame,
  uFuncCommon,
  uGPSLocation,
  uSkinItems,
  uSkinBufferBitmap,
  uOpenCommon,
  uOpenClientCommon,
  uManager,
  uTimerTask,
  uUIFunction,
  uRestInterfaceCall,
  MessageBoxFrame,
  WaitingFrame,
  SelectAreaFrame,
  ActivityListFrame,
//  MyGiftPackageListFrame,
//  GiftPackageListFrame,
  ScoreExchangeListFrame,
//  AddGiftFrame,

//  LostListFrame,
//  GiftListFrame,
  XSuperObject,
  XSuperJson,
  uMobileUtils,
  uBaseHttpControl,
  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,

  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox, uSkinFireMonkeyImage,
  uSkinFireMonkeyLabel, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, uSkinFireMonkeyFrameImage, uSkinLabelType,
  uSkinImageType, uSkinFrameImageType,
  uSkinScrollControlType, uSkinScrollBoxType, uSkinButtonType, uBaseSkinControl,
  uSkinPanelType, uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinCustomListType, uSkinVirtualListType, uSkinListViewType,
  uSkinFireMonkeyListView, uTimerTaskEvent, uSkinListBoxType,
  uSkinFireMonkeyListBox, uSkinPageControlType, uSkinFireMonkeyPageControl,
  uSkinSwitchPageListPanelType, uDrawCanvas, FMX.ListBox,
  uSkinFireMonkeyComboBox, uFrameContext;

type
  TFrameActivityCenter = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    lbOrderState: TSkinFMXListBox;
    pcMain: TSkinFMXPageControl;
    tsActivity: TSkinFMXTabSheet;
    tsMyGift: TSkinFMXTabSheet;
    btnPetLocation: TSkinFMXButton;
    btnAddr: TSkinFMXButton;
    btnReturn: TSkinFMXButton;
    pnlActivity: TSkinFMXPanel;
    SkinFMXPanel1: TSkinFMXPanel;
    btnMyActivityList: TSkinFMXButton;
    tteGetData: TTimerTaskEvent;
    cmbGroup: TSkinFMXComboBox;
    FrameContext1: TFrameContext;
    btnScoreExchange: TSkinFMXButton;
    procedure pcMainChange(Sender: TObject);
    procedure btnAddGiftClick(Sender: TObject);
    procedure lbOrderStateClickItem(AItem: TSkinItem);
    procedure btnPetLocationClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure tteGetDataExecute(ATimerTask: TTimerTask);
    procedure tteGetDataExecuteEnd(ATimerTask: TTimerTask);
    procedure FrameContext1Load(Sender: TObject);
    procedure cmbGroupChange(Sender: TObject);
    procedure btnScoreExchangeClick(Sender: TObject);
  private
    FGameGroupArray:ISuperArray;
    { Private declarations }
  public
    FActivityListFrame:TFrameActivityList;
//    FMyActivityListFrame:TFrameActivityList;
//    FGiftListFrame_NearBy:TFrameActivityList;
//    FLostListFrame:TFrameLostList;
    procedure Load;

    procedure ProcessCanNotLocation;
    procedure DoModalResultFromProcessCanNotLocationMessageBox(AMessageBoxFrame:TObject);
    procedure DoReturnFromAddGift(AFrame:TFrame);
    procedure DoReturnFrameFromSelectAreaFrame(AFrame:TFrame);
  public
    constructor Create(AOwner:TComponent);override;
  end;

var
  GlobalActivityCenterFrame:TFrameActivityCenter;

implementation

{$R *.fmx}

uses
  MainForm,
//  PetGPSLocationForm,
  MainFrame;

procedure TFrameActivityCenter.btnAddGiftClick(Sender: TObject);
begin
  if not GlobalManager.IsLogin then
  begin
    ShowLoginFrame(True);
    Exit;
  end;

end;

procedure TFrameActivityCenter.btnPetLocationClick(Sender: TObject);
begin
  if not GlobalManager.IsLogin then
  begin
    ShowLoginFrame(True);
    Exit;
  end;

end;

procedure TFrameActivityCenter.btnReturnClick(Sender: TObject);
begin
  if IsRepeatClickReturnButton(Self) then Exit;

  HideFrame;
  ReturnFrame;

end;

procedure TFrameActivityCenter.btnScoreExchangeClick(Sender: TObject);
begin
  //积分兑换
  HideFrame;
  ShowFrame(TFrame(GlobalScoreExchangeListFrame),TFrameScoreExchangeList);
  GlobalScoreExchangeListFrame.Load;

end;

procedure TFrameActivityCenter.cmbGroupChange(Sender: TObject);
begin
  //重新加载
  Self.cmbGroup.Width:=
    uSkinBufferBitmap.GetStringWidth(cmbGroup.GetText,14)
    +50;

  if Self.FActivityListFrame<>nil then
  begin
    if cmbGroup.ItemIndex<=0 then
    begin
      FActivityListFrame.FFilterGroupId:='';
    end
    else
    begin
      FActivityListFrame.FFilterGroupId:=Self.FGameGroupArray.O[cmbGroup.ItemIndex-1].S['Id'];
    end;
    FActivityListFrame.Load;
  end;

end;

constructor TFrameActivityCenter.Create(AOwner: TComponent);
begin
  inherited;

  //重新加载
  Self.cmbGroup.Width:=
    uSkinBufferBitmap.GetStringWidth(cmbGroup.GetText,14)
    +50;

end;

procedure TFrameActivityCenter.DoModalResultFromProcessCanNotLocationMessageBox(
  AMessageBoxFrame: TObject);
begin
  if SameText(TFrameMessageBox(AMessageBoxFrame).ModalResultName,'Setting') then
  begin
    JumpToLocaitonSettingPage;
  end;
end;

procedure TFrameActivityCenter.DoReturnFrameFromSelectAreaFrame(AFrame: TFrame);
begin
  GlobalManager.Province:=GlobalSelectAreaFrame.FSelectedProvince;
  GlobalManager.City:=GlobalSelectAreaFrame.FSelectedCity;
  GlobalManager.IsGPSLocated:=True;
  GlobalManager.Save;

  Self.btnAddr.Caption:=GlobalSelectAreaFrame.FSelectedCity;

end;

procedure TFrameActivityCenter.DoReturnFromAddGift(AFrame: TFrame);
begin

  //刷新精选
  if Self.FActivityListFrame<>nil then
  begin
    FActivityListFrame.Load;
  end;

end;

procedure TFrameActivityCenter.FrameContext1Load(Sender: TObject);
begin
  Self.tteGetData.Run();
end;

procedure TFrameActivityCenter.lbOrderStateClickItem(AItem: TSkinItem);
begin
  Self.pcMain.Prop.ActivePageIndex:=AItem.Index;
end;

procedure TFrameActivityCenter.Load;
begin

  //第一次显示礼包列表
  Self.pcMain.Prop.ActivePage:=nil;
  Self.pcMain.Prop.ActivePage:=tsActivity;

//  HideFrame;
//  ShowFrame(TFrame(GlobalActivityListFrame),TFrameActivityList);
//  GlobalActivityListFrame.Load;

end;

procedure TFrameActivityCenter.pcMainChange(Sender: TObject);
var
  AIsFirstCreate:Boolean;
begin
  if Self.pcMain.Prop.ActivePage=Self.tsActivity then
  begin

      //精选
      AIsFirstCreate:=(FActivityListFrame=nil);
      ShowFrame(TFrame(FActivityListFrame),TFrameActivityList,
          pnlActivity,
//          tsActivity,
          nil,nil,nil,nil,False,False,ufsefNone);
      FActivityListFrame.pnlToolBar.Visible:=False;
      FActivityListFrame.lvData.Material.IsTransparent:=True;
      FActivityListFrame.Margins.Rect:=RectF(5,5,5,5);

//      FActivityListFrame.FFilterIsBest:='1';
      //if AIsFirstCreate then
      FActivityListFrame.Load;

  end;
  if Self.pcMain.Prop.ActivePage=Self.tsMyGift then
  begin

      //我的礼包
//      AIsFirstCreate:=(FMyActivityListFrame=nil);
//      ShowFrame(TFrame(FMyActivityListFrame),TFrameMyGiftPackageList,tsMyGift,
//          nil,nil,nil,nil,False,False,ufsefNone);
//      FMyActivityListFrame.pnlToolBar.Visible:=False;
////      FMyActivityListFrame.FFilterIsBest:='1';
//      if AIsFirstCreate then FMyActivityListFrame.Load;
  end;

end;

procedure TFrameActivityCenter.ProcessCanNotLocation;
begin

end;

procedure TFrameActivityCenter.tteGetDataExecute(ATimerTask: TTimerTask);
//var
//  ASuperObject:ISuperObject;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=TASK_FAIL;
  try
    TTimerTask(ATimerTask).TaskDesc:=
        SimpleCallAPI('get_record_list',
            nil,
            TableRestCenterInterfaceUrl,
            [
            'appid',
            'user_fid',
            'key',
            'pageindex',
            'pagesize',
            'rest_name',
            //时间戳
            'timestamp',
            //随机字符串,保证在90秒内请求不可重复
            'nonce'
            ],
            [
            AppID,
            GlobalManager.User.fid,
            '',
            1,
            MaxInt,
            'xf_group',
            timeIntervalSince1970(Now),
            IntToStr(timeIntervalSince1970(Now))+IntToStr(Random(99999))
            ],
            GlobalRestAPISignType,
            GlobalRestAPIAppSecret
            );
    if TTimerTask(ATimerTask).TaskDesc<>'' then
    begin
        TTimerTask(ATimerTask).TaskTag:=TASK_SUCC;

    end;

  except
    on E:Exception do
    begin
      //异常
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
    end;
  end;

end;

procedure TFrameActivityCenter.tteGetDataExecuteEnd(ATimerTask: TTimerTask);
var
  I:Integer;
  ALastText:String;
  ASuperObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag=TASK_SUCC then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin
          //获取列表成功
          FGameGroupArray:=ASuperObject.O['Data'].A['RecordList'];

          Self.cmbGroup.OnChange:=nil;
          ALastText:=Self.cmbGroup.GetText;
          Self.cmbGroup.Items.BeginUpdate;
          try

            cmbGroup.Items.Clear;
            cmbGroup.Items.Add('全部');
            if Self.cmbGroup.Items.IndexOf(ALastText)<>-1 then
            begin
              Self.cmbGroup.ItemIndex:=Self.cmbGroup.Items.IndexOf(ALastText);
            end;

            for I := 0 to FGameGroupArray.Length-1 do
            begin
              cmbGroup.Items.Add(FGameGroupArray.O[I].S['groupName']);
            end;

          finally
            Self.cmbGroup.Items.EndUpdate();
          end;
          Self.cmbGroup.OnChange:=Self.cmbGroupChange;

          if Self.cmbGroup.Items.IndexOf(ALastText)=-1 then
          begin
            Self.cmbGroup.ItemIndex:=0;
          end
          else
          begin
            Self.cmbGroup.ItemIndex:=Self.cmbGroup.Items.IndexOf(ALastText);
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
  finally
  end;

end;

end.

