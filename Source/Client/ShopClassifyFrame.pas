unit ShopClassifyFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

//  uOpenClientCommon,
  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,

  uUIFunction,
  uTimerTask,
  uManager,
  uOpenClientCommon,
  uOpenCommon,
  uFrameContext,

  uSkinItems,

  uRestInterfaceCall,

  XSuperObject,
  XSuperJson,

  MessageBoxFrame,
  WaitingFrame,


  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uBaseSkinControl, uSkinPanelType, uSkinFireMonkeyPanel,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinImageType, uSkinFireMonkeyImage, uDrawCanvas;

type
  TFrameShopClassify = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbCooperationList: TSkinFMXListBox;
    idpCooperation: TSkinFMXItemDesignerPanel;
    lblCooperation: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure lbCooperationListClickItem(AItem: TSkinItem);
  private

    //获取类型列表
    procedure DoGetShopClassifyExcute(ATimerTask:TObject);
    procedure DoGetShopClassifyExcuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    FrameHistroy: TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
  public
    //名称
    FSelectName:String;
    //FID
    FSelectFID:Integer;
    //清除
    procedure Clear;
    //加载
    procedure LoadShopClassify;
    { Public declarations }
  end;



var
  GlobalShopClassifyFrame:TFrameShopClassify;

implementation

{$R *.fmx}

procedure TFrameShopClassify.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self, hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;


procedure TFrameShopClassify.Clear;
begin
  Self.lbCooperationList.Prop.Items.Clear(True );
end;

constructor TFrameShopClassify.Create(AOwner: TComponent);
begin
  inherited;
  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);
end;

procedure TFrameShopClassify.DoGetShopClassifyExcute(
  ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_business_category_list',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',
                                                      'key',
                                                      'pageindex',
                                                      'pagesize'],
                                                      [AppID,
                                                       GlobalManager.User.fid,
                                                       GlobalManager.User.key,
                                                       1,
                                                       50],
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



procedure TFrameShopClassify.DoGetShopClassifyExcuteEnd(
  ATimerTask: TObject);
var
  ASuperObject: ISuperObject;
  AListBoxItem:TSkinListBoxItem;
  I:Integer;
  AGoodsCategroyObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag = 0 then
    begin
      ASuperObject := TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code'] = 200 then
      begin
        //获取成功
        Self.lbCooperationList.Prop.Items.Clear(True);

        Self.lbCooperationList.Prop.Items.BeginUpdate;
        try
          for I := 0 to ASuperObject.O['Data'].A['BusinessCategoryList'].Length-1 do
          begin
            AGoodsCategroyObject:=ASuperObject.O['Data'].A['BusinessCategoryList'].O[I];
            AListBoxItem:=Self.lbCooperationList.Prop.Items.Add;
            AListBoxItem.Detail6:=AGoodsCategroyObject.AsJSON;
            AListBoxItem.Caption:=AGoodsCategroyObject.S['name'];
          end;


        finally
          Self.lbCooperationList.Prop.Items.EndUpdate();
        end;

      end
      else
      begin
        //获取失败
        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
      end;

    end
    else if TTimerTask(ATimerTask).TaskTag = 1 then
    begin
      // 网络异常
      ShowMessageBoxFrame(Self, '网络异常,请检查您的网络连接!', TTimerTask(ATimerTask)
        .TaskDesc, TMsgDlgType.mtInformation, ['确定'], nil);
    end;
  finally
    HideWaitingFrame;
  end;

end;



procedure TFrameShopClassify.lbCooperationListClickItem(AItem: TSkinItem);
var
  AGoodsCategroyObject:ISuperObject;
begin
  AGoodsCategroyObject:=TSuperObject.Create(AItem.Detail6);

  Self.FSelectName:=AGoodsCategroyObject.S['name'];
  Self.FSelectFID:=AGoodsCategroyObject.I['fid'];
  //返回
  HideFrame;//(Self, hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;


procedure TFrameShopClassify.LoadShopClassify;
begin
  //获取分类列表
  ShowWaitingFrame(Self,'获取中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                       DoGetShopClassifyExcute,
                       DoGetShopClassifyExcuteEnd,
                       'GetShopClassify');
end;

end.
