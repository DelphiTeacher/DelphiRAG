unit SelectContractFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 

//  uOpenClientCommon,
  CommonImageDataMoudle,
  EasyServiceCommonMaterialDataMoudle,

  uUIFunction,
  uTimerTask,
  uManager,
  uOpenClientCommon,
  uOpenCommon,

  uSkinItems,

  uRestInterfaceCall,

  XSuperObject,
  XSuperJson,
  uFrameContext,

  uDrawCanvas,

  uDrawTextParam,

  MessageBoxFrame,
  WaitingFrame,
//  uOpenCommon,
  uDataSetToJson,



  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinPanelType, uSkinFireMonkeyPanel,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyControl, uBaseSkinControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox, uSkinRadioButtonType,
  uSkinFireMonkeyRadioButton, uSkinMaterial;

type
  TFrameSelectContract = class(TFrame)
    lbContractList: TSkinFMXListBox;
    idpCooperation: TSkinFMXItemDesignerPanel;
    lblCooperation: TSkinFMXLabel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lblScript: TSkinFMXLabel;
    lblSend: TSkinFMXLabel;
    lblSendRate: TSkinFMXLabel;
    lblSendFee: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel2: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    rbItemSelected: TSkinFMXRadioButton;
    lblNoDelive: TSkinFMXLabel;
    lblIslNoDelive: TSkinFMXLabel;
    lblDelive: TSkinFMXLabel;
    lblIsDelive: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure lbContractListClickItem(AItem: TSkinItem);
    procedure lbContractListPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRect);
  private

    FSelected_fid:Integer;
    FSelected_name:String;

    //获取合同方案列表
    procedure DoGetContractListExcute(ATimerTask:TObject);
    procedure DoGetContractListExcuteEnd(ATimerTask:TObject);
    { Private declarations }
  public
    FrameHistroy: TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
  public
    //FID
    FSelectedContractFID:Integer;
    //名称
    FSelectedContractName:String;
    //配送类型
    FSelectedContractDeliveType:Integer;
    //是否显示能否堂食自取
    FIsShowEatType:Boolean;
    //是否平台上商家
    FIsPlatFormShop:Integer;

    //清除
    procedure Clear;
    //加载合作方案
    procedure LoadContract(Selected_fid:Integer;
                           Selected_name:String;
                           Select_delivetype:Integer;
                           IsPlatFormShop:Integer=1;    //外卖不区分
                           IsShowEatType:Boolean=True); //外卖默认显示是否堂食/自取   亿诚不显示
    { Public declarations }
  end;

var
  GlobalSelectContractFrame:TFrameSelectContract;

implementation

{$R *.fmx}

procedure TFrameSelectContract.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self, hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameSelectContract.Clear;
begin
  Self.lbContractList.Prop.Items.Clear(True);
end;

constructor TFrameSelectContract.Create(AOwner: TComponent);
begin
  inherited;
  RecordSubControlsLang(Self);
  TranslateSubControlsLang(Self);

  TSkinRadioButtonColorMaterial(Self.rbItemSelected.SelfOwnMaterialToDefault).DrawCheckStateParam.DrawEffectSetting.PushedEffect.FillColor.Color:=SkinThemeColor;
  TSkinRadioButtonColorMaterial(Self.rbItemSelected.SelfOwnMaterialToDefault).DrawCheckRectParam.DrawEffectSetting.PushedEffect.BorderColor.Color:=SkinThemeColor;
end;

procedure TFrameSelectContract.DoGetContractListExcute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_coop_scheme_list',
                                                      nil,
                                                      ShopCenterInterfaceUrl,
                                                      ['appid',
                                                      'user_fid',  //取员工ID输入框的值
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

procedure TFrameSelectContract.DoGetContractListExcuteEnd(ATimerTask: TObject);
var
  ASuperObject: ISuperObject;
  AListBoxItem:TSkinListBoxItem;
  I:Integer;
  AContractObject:ISuperObject;
begin
  try
    if TTimerTask(ATimerTask).TaskTag = 0 then
    begin
      ASuperObject := TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code'] = 200 then
      begin
        //获取成功

        Self.lbContractList.Prop.Items.BeginUpdate;
        try

            Self.lbContractList.Prop.Items.Clear(True);

            for I := 0 to ASuperObject.O['Data'].A['CoopSchemeList'].Length-1 do
            begin
                AContractObject:=ASuperObject.O['Data'].A['CoopSchemeList'].O[I];


                if Self.FIsPlatFormShop=0 then
                begin
                    //不是平台商家,不能选择快递的配送方式
                    //只有平台商家才能选择快递这种配送方式
                    if TCoopSchemeDeliverType(AContractObject.I['deliver_type'])<>dtPosting then
                    begin
                      AListBoxItem:=Self.lbContractList.Prop.Items.Add;
                    end
                    else
                    begin
                      Continue;
                    end;
                end
                else
                begin
                    //平台商家
                    AListBoxItem:=Self.lbContractList.Prop.Items.Add;
                end;


                AListBoxItem.Detail6:=AContractObject.AsJSON;
                AListBoxItem.Caption:=AContractObject.S['name'];
                AListBoxItem.Detail:=AContractObject.S['createtime'];
                AListBoxItem.Detail1:=AContractObject.S['scheme_desc'];
                AListBoxItem.Detail2:=GetCoopSchemeDeliverTypeStr(TCoopSchemeDeliverType(AContractObject.I['deliver_type']));

                AListBoxItem.Detail3:=Format('%.2f',[GetJsonDoubleValue(AContractObject,'service_fee_rate')]);
                AListBoxItem.Detail4:=Format('%.2f',[GetJsonDoubleValue(AContractObject,'service_fee_base_price')]);

                AListBoxItem.Selected:=(AContractObject.I['fid']=FSelected_fid);


            end;


        finally
          Self.lbContractList.Prop.Items.EndUpdate();
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


procedure TFrameSelectContract.lbContractListClickItem(AItem: TSkinItem);
var
  AContractObject:ISuperObject;
begin
  AContractObject:=TSuperObject.Create(AItem.Detail6);
  Self.FSelectedContractFID:=AContractObject.I['fid'];
  Self.FSelectedContractName:=AContractObject.S['name'];
  Self.FSelectedContractDeliveType:=AContractObject.I['deliver_type'];
  //返回
  HideFrame;//(Self, hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameSelectContract.lbContractListPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinFMXItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AContractObject:ISuperObject;
  AIsCanSelfTake,AIsCanEatInShop:String;
begin
  if AItem.Detail6<>'' then
  begin
    AContractObject:=TSuperObject.Create(AItem.Detail6);

    //是否支持自取
    AIsCanSelfTake:='不能';
    if AContractObject.I['is_can_takeorder_but_only_self_take']=1 then
    begin
      AIsCanSelfTake:='能';
    end;


    //是否支持堂食
    AIsCanEatInShop:='不能';
    if AContractObject.I['is_can_takeorder_but_only_eat_in_shop']=1 then
    begin
      AIsCanEatInShop:='能';
    end;


    Self.lblIslNoDelive.Caption:=AIsCanEatInShop+'/'+AIsCanSelfTake;


    //是否允许配送
    if AContractObject.I['is_can_takeorder_and_delivery']=1 then
    begin
      Self.lblIsDelive.Caption:='能';
    end
    else
    begin
      Self.lblIsDelive.Caption:='不能';
    end;



    //亿诚生活加的
    Self.lblNoDelive.Visible:=FIsShowEatType;
    Self.lblIslNoDelive.Visible:=FIsShowEatType;
    Self.lblDelive.Position.X:=Self.SkinFMXLabel3.Position.X;
    Self.lblDelive.Width:=Self.SkinFMXLabel3.Width;
    Self.lblDelive.SelfOwnMaterialToDefault.DrawCaptionParam.FontHorzAlign:=TFontHorzAlign.fhaRight;
    if Not FIsShowEatType then
    begin
      Self.lblDelive.Position.X:=7;
      Self.lblDelive.Width:=70;
      Self.lblDelive.SelfOwnMaterialToDefault.DrawCaptionParam.FontHorzAlign:=TFontHorzAlign.fhaLeft;
    end;
    Self.lblIsDelive.Position.X:=Self.lblDelive.Position.X+Self.lblDelive.Width+3;
  end;
end;

procedure TFrameSelectContract.LoadContract(Selected_fid:Integer;
                                            Selected_name:String;
                                            Select_delivetype:Integer;
                                            IsPlatFormShop:Integer=1;
                                            IsShowEatType:Boolean=True);
begin
  Self.FSelected_fid:=Selected_fid;
  Self.FSelected_name:=Selected_name;

  Self.FIsShowEatType:=IsShowEatType;

  Self.FIsPlatFormShop:=IsPlatFormShop;

  Self.FSelectedContractFID:=FSelected_fid;
  Self.FSelectedContractName:=Self.FSelected_name;
  Self.FSelectedContractDeliveType:=Select_delivetype;

  ShowWaitingFrame(Self,'加载中...');
  uTimerTask.GetGlobalTimerThread.RunTempTask(
                              DoGetContractListExcute,
                              DoGetContractListExcuteEnd,
                              'GetContractList');
end;

end.
