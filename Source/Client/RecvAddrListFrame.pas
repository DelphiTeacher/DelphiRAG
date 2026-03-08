unit RecvAddrListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinMaterial,
  uSkinBufferBitmap,

  uUIFunction,
  uTimerTask,
  uOpenCommon,

  uLang,
  uOpenClientCommon,
  uRestInterfaceCall,
  uManager,
  uBaseHttpControl,
  uSkinListBoxType,

  WaitingFrame,
  MessageBoxFrame,
  EasyServiceCommonMaterialDataMoudle,


  XSuperObject,
  XSuperJson,

  uDrawCanvas,
  uSkinItems,
  uBaseList,

  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyRadioButton,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, uSkinFireMonkeyMemo,
  uSkinFireMonkeyCheckBox, uSkinRadioButtonType, uSkinCheckBoxType,
  uSkinLabelType, uSkinItemDesignerPanelType, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinButtonType, uBaseSkinControl,
  uSkinPanelType, uSkinPageControlType, uSkinSwitchPageListPanelType,
  uSkinFireMonkeyPageControl, uSkinImageType, uSkinFireMonkeyImage,
  uFrameContext;

type
  TFrameRecvAddrList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlAddRecvAddr: TSkinFMXPanel;
    btnAddRecv: TSkinFMXButton;
    pcRecvList: TSkinFMXPageControl;
    tbPage1: TSkinTabSheet;
    pnlEmpty: TSkinFMXPanel;
    lblDetail: TSkinFMXLabel;
    lblDetail1: TSkinFMXLabel;
    lbAddrList: TSkinFMXListBox;
    idpItemDefault: TSkinFMXItemDesignerPanel;
    lblName: TSkinFMXLabel;
    lblPhone: TSkinFMXLabel;
    lblRecvAddr: TSkinFMXLabel;
    btnWrite: TSkinFMXButton;
    lbltag: TSkinFMXLabel;
    FrameContext1: TFrameContext;
    procedure btnReturnClick(Sender: TObject);
    procedure lbAddrListPullDownRefresh(Sender: TObject);
    procedure chkItemIsDefaultClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnAddRecvClick(Sender: TObject);
    procedure tbPage2Click(Sender: TObject);
    procedure btnWriteClick(Sender: TObject);
    procedure lbAddrListPrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinFMXItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRect);
    procedure lbAddrListClickItem(AItem: TSkinItem);
    procedure FrameContext1Load(Sender: TObject);
  private
    //页面使用类型
    FUseType:TFrameUseType;

  private
//    FHotel:THotel;

    //收货地址列表
    FUserRecvAddrList:TUserRecvAddrList;


    FUserFID:Integer;

    procedure Clear;

    //获取收货地址列表
    procedure DoGetRecvAddrListExecute(ATimerTask:TObject);
    procedure DoGetRecvAddrListExecuteEnd(ATimerTask:TObject);

  private
//    //删除收货地址返回
//    procedure OnModalResultFromDeleteHotelAddr(Frame:TObject);
    //编辑收货地址返回
    procedure OnReturnFrameFromEditRecvAddr(Frame:TFrame);
    //添加收货地址返回
    procedure OnReturnFrameFromAddRecvAddr(Frame:TFrame);

    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    FSelectedRecvAddrFID:Integer;
    FSelectedRecvAddr:TUserRecvAddr;
    procedure Load(
                    //标题
                    ACaption:String;
                    //使用类型,UserRecvAddManage,SelectUserRecvAdd
                    AUseType:TFrameUseType;
                    //选中的收货地址列表
                    ASelectedRecvAddrFID:Integer
                    );
    { Public declarations }
  end;


var
  GlobalRecvAddrListFrame:TFrameRecvAddrList;

implementation

{$R *.fmx}

uses
  MainForm,
  AddRecvAddrFrame;



procedure TFrameRecvAddrList.btnAddRecvClick(Sender: TObject);
begin
  //跳转到添加收货地址页面
  HideFrame;//(Self,hfcttBeforeShowFrame);
  ShowFrame(TFrame(GlobalAddRecvAddrFrame),TFrameAddRecvAddr,frmMain,nil,nil,OnReturnFrameFromAddRecvAddr,Application);
//  GlobalAddRecvAddrFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalAddRecvAddrFrame.Clear;
  GlobalAddRecvAddrFrame.Add;
end;


procedure TFrameRecvAddrList.btnEditClick(Sender: TObject);
var
  AUserRecvAdd:TUserRecvAddr;
begin
//  AUserRecvAdd:=Self.lbHotelAddrList.Prop.InteractiveItem.Data;
//
//  //编辑收货地址
//  HideFrame;//(Self,hfcttBeforeShowFrame);
//  ShowFrame(TFrame(GlobalAddUserRecvAddFrame),TFrameAddUserRecvAdd,frmMain,nil,nil,OnReturnFrameFromEditUserRecvAdd,Application);
//  GlobalAddUserRecvAddFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalAddUserRecvAddFrame.Edit(AUserRecvAdd);

end;

procedure TFrameRecvAddrList.btnAddClick(Sender: TObject);
begin
//
//  //添加收货地址
//  HideFrame;//(Self,hfcttBeforeShowFrame);
//
//  ShowFrame(TFrame(GlobalAddRecvAddrFrame),TFrameAddRecvAddr,frmMain,nil,nil,OnReturnFrameFromAddUserRecvAdd,Application);
//  GlobalAddRecvAddrFrame.FrameHistroy:=CurrentFrameHistroy;
//  GlobalAddRecvAddrFrame.Clear;
//  GlobalAddRecvAddrFrame.Clear;
//  GlobalAddRecvAddrFrame.Add(FHotelFID);


end;

procedure TFrameRecvAddrList.btnReturnClick(Sender: TObject);
begin
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;
  //返回
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;


procedure TFrameRecvAddrList.btnWriteClick(Sender: TObject);
var
  AUserRecvAddr:TUserRecvAddr;
begin
  AUserRecvAddr:=TUserRecvAddr(Self.lbAddrList.Prop.InteractiveItem.Data);
  //编辑收货地址
  HideFrame;//(Self,hfcttBeforeShowFrame);
  ShowFrame(TFrame(GlobalAddRecvAddrFrame),TFrameAddRecvAddr,frmMain,nil,nil,OnReturnFrameFromEditRecvAddr,Application);
//  GlobalAddRecvAddrFrame.FrameHistroy:=CurrentFrameHistroy;
  GlobalAddRecvAddrFrame.Edit(AUserRecvAddr);
end;

procedure TFrameRecvAddrList.Clear;
begin
  Self.lbAddrList.Prop.Items.BeginUpdate;
  try
    Self.lbAddrList.Prop.Items.Clear(True);
  finally
   Self.lbAddrList.Prop.Items.EndUpdate;
  end;
end;

constructor TFrameRecvAddrList.Create(AOwner: TComponent);
begin
  inherited;

  FUserRecvAddrList:=TUserRecvAddrList.Create;
//  Self.lbHotelAddrList.Prop.Items.Clear(True);

  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  Self.lbltag.SelfOwnMaterialToDefault.BackColor.BorderColor.Color:=SkinThemeColor;
  Self.lbltag.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;
  Self.btnAddRecv.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=SkinThemeColor;
end;


destructor TFrameRecvAddrList.Destroy;
begin
  FreeAndNil(FUserRecvAddrList);

  inherited;
end;



procedure TFrameRecvAddrList.DoGetRecvAddrListExecute(
  ATimerTask: TObject);
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

procedure TFrameRecvAddrList.DoGetRecvAddrListExecuteEnd(
  ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  AListBoxItem:TSkinListBoxItem;
  I:Integer;
  AHeight:Double;
  ARecvListAddr:TUserRecvAddrList;
begin
  AHeight:=0;
  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

//        if ASuperObject.O['Data'].A['UserRecvAddrList'].Length<1 then
//        begin
//          //加载page1页面
//          Self.pcRecvList.Prop.ActivePage:=Self.tbPage1;
//        end
//        else
//        begin
//          Self.pcRecvList.Prop.ActivePage:=Self.tbPage2;


          //加载列表
          ARecvListAddr:=TUserRecvAddrList.Create(ooReference);
          Self.FUserRecvAddrList.Clear(True);
          ARecvListAddr.ParseFromJsonArray(TUserRecvAddr,ASuperObject.O['Data'].A['UserRecvAddrList']);
          Self.lbAddrList.Prop.Items.BeginUpdate;
          try

            Self.lbAddrList.Prop.Items.ClearItemsByType(sitDefault);

            for I := 0 to ARecvListAddr.Count-1 do
            begin

              AListBoxItem:=Self.lbAddrList.Prop.Items.Add;
              AListBoxItem.Data:=ARecvListAddr[I];
              Self.FUserRecvAddrList.Add(ARecvListAddr[I]);
              if ARecvListAddr[I].sex=0 then
              begin
                AListBoxItem.Caption:=ARecvListAddr[I].name+
                                                   '  '+Trans('男士');
              end
              else if ARecvListAddr[I].sex=1 then
              begin
                AListBoxItem.Caption:=ARecvListAddr[I].name+
                                                   '  '+Trans('女士');
              end
              else
              begin
                AListBoxItem.Caption:=ARecvListAddr[I].name;

              end;

              AListBoxItem.Detail:=ARecvListAddr[I].phone;
              AListBoxItem.Detail1:=ARecvListAddr[I].addr;


              AListBoxItem.Detail2:=ARecvListAddr[I].tag;
               //计算高度
              AHeight:=uSkinBufferBitmap.GetStringHeight(ARecvListAddr[I].addr,
                                                       RectF(0,0,Self.Width-90,MaxInt),
                                                       Self.lblRecvAddr.SelfOwnMaterialToDefault.DrawCaptionParam);
              AListBoxItem.Height:=AHeight+60;
            end;

          finally
            Self.lbAddrList.Prop.Items.EndUpdate();
          end;

//        end;

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
    HideWaitingFrame;
    Self.lbAddrList.Prop.StopPullDownRefresh('刷新成功!',600);

    FreeAndNil(ARecvListAddr);
  end;
end;



procedure TFrameRecvAddrList.FrameContext1Load(Sender: TObject);
begin
  Self.lbAddrList.Prop.StartPullDownRefresh;
end;

procedure TFrameRecvAddrList.lbAddrListClickItem(AItem: TSkinItem);
var
  AUserRecvAddr:TUserRecvAddr;
begin


  AUserRecvAddr:=TUserRecvAddr(AItem.Data);


  //编辑收货地址
  if FUseType=futManage then
  begin
    //修改收货地址
    HideFrame;//(Self,hfcttBeforeShowFrame);
    ShowFrame(TFrame(GlobalAddRecvAddrFrame),TFrameAddRecvAddr,frmMain,nil,nil,OnReturnFrameFromEditRecvAddr,Application);
//    GlobalAddRecvAddrFrame.FrameHistroy:=CurrentFrameHistroy;
    GlobalAddRecvAddrFrame.Edit(TUserRecvAddr(AItem.Data));
  end;


  //选择收货地址
  if FUseType=futSelectList then
  begin
    FSelectedRecvAddr:=AUserRecvAddr;
    Self.FSelectedRecvAddrFID:=AUserRecvAddr.fid;

    //返回
    HideFrame;//(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(Self.FrameHistroy);

  end;
end;

procedure TFrameRecvAddrList.lbAddrListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
begin
  if AItem.Detail2='' then
  begin
    Self.lbltag.Visible:=False;
  end
  else
  begin
    Self.lbltag.Visible:=True;
    Self.lbltag.Caption:=AItem.Detail2;
  end;

  if AItem.Detail1<>'' then
  begin
    Self.lblRecvAddr.Height:=uSkinBufferBitmap.GetStringHeight(AItem.Detail1,
                                             RectF(0,0,Self.Width-90,MaxInt),
                                             Self.lblRecvAddr.SelfOwnMaterialToDefault.DrawCaptionParam);
  end;


end;

procedure TFrameRecvAddrList.lbAddrListPullDownRefresh(
  Sender: TObject);
begin
  //刷新
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                                         DoGetRecvAddrListExecute,
                                         DoGetRecvAddrListExecuteEnd,
                                         'GetRecvAddrList');
end;

procedure TFrameRecvAddrList.Load(
                    //标题
                    ACaption:String;
                    //使用类型,UserRecvAddManage,SelectUserRecvAdd
                    AUseType:TFrameUseType;
                    //选中的收货地址列表
                    ASelectedRecvAddrFID:Integer);
begin
  Self.Clear;

  FUseType:=AUseType;
  FSelectedRecvAddrFID:=ASelectedRecvAddrFID;
  FSelectedRecvAddr:=nil;


  Self.pnlToolBar.Caption:=ACaption;

  //收货地址管理
  if FUseType=futManage then
  begin
//    Self.chkItemIsDefault.Visible:=True;

//    Self.rbItemSelected.Visible:=False;
    Self.btnWrite.Visible:=True;
  end;

  //选择收货地址
  if FUseType=futSelectList then
  begin
//    Self.chkItemIsDefault.Visible:=False;

//    Self.rbItemSelected.Visible:=True;
    Self.btnWrite.Visible:=False;
  end;



end;

procedure TFrameRecvAddrList.OnReturnFrameFromAddRecvAddr(Frame: TFrame);
begin
  //添加收货地址返回刷新
  if GlobalIsRecvAddrChanged then
  begin
    GlobalIsRecvAddrChanged:=False;

    Self.lbAddrList.Prop.StartPullDownRefresh;
  end;
end;

procedure TFrameRecvAddrList.OnReturnFrameFromEditRecvAddr(
  Frame: TFrame);
begin
  //编辑收货地址返回
  if GlobalIsRecvAddrChanged then
  begin
    GlobalIsRecvAddrChanged:=False;

    Self.lbAddrList.Prop.StartPullDownRefresh;
  end;
end;

procedure TFrameRecvAddrList.tbPage2Click(Sender: TObject);
begin

end;

//procedure TFrameRecvAddrList.OnModalResultFromDeleteHotelAddr(
//  Frame: TObject);
//begin
//  if TFrameMessageBox(Frame).ModalResult='确定' then
//  begin
//    ShowWaitingFrame(Self,'删除中...');
//    uTimerTask.GetGlobalTimerThread.RunTempTask(
//                                  DoDelUserRecvAddExecute,
//                                  DoDelUserRecvAddExecuteEnd);
//  end;
//  if TFrameMessageBox(Frame).ModalResult='取消' then
//  begin
//    //留在酒店信息页面
//  end;
//
//end;

procedure TFrameRecvAddrList.chkItemIsDefaultClick(Sender: TObject);
var
  AHotelRecAddr:TUserRecvAddr;
begin
  //设置收货地址为默认
//
//  AHotelRecAddr:=Self.lbAddrList.Prop.InteractiveItem.Data;
//  FNeedSetIsDefaultRecvAddrFID:=AHotelRecAddr.fid;
//  FNeedSetIsDefaultItem:=Self.lbAddrList.Prop.InteractiveItem;
//
//
//  if AHotelRecAddr.is_default=0 then
//  begin
//    ShowWaitingFrame(Self,'处理中...');
//    uTimerTask.GetGlobalTimerThread.RunTempTask(
//                                          DoSetUserRecvAddIsDefaultExecute,
//                                          DoSetUserRecvAddIsDefaultExecuteEnd);
//  end;

end;

end.

