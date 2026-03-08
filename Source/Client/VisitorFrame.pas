unit VisitorFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uDrawCanvas, uSkinItems, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinItemDesignerPanelType, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyControl, uSkinScrollControlType, uSkinCustomListType,
  uTimerTask,uRestInterfaceCall, uManager,uLang,
  uOpenClientCommon, uSkinSuperObject,MessageBoxFrame,
  uUIFunction,
  uDatasetToJson,
  uSkinVirtualListType, uSkinListBoxType, uSkinFireMonkeyListBox,
  uSkinPanelType, uSkinFireMonkeyPanel;

type
  TFrameVisitor = class(TFrame)
    lbList: TSkinFMXListBox;
    idpUser: TSkinFMXItemDesignerPanel;
    imgHeader: TSkinFMXImage;
    lblName: TSkinFMXLabel;
    lblsign: TSkinFMXLabel;
    lblTime: TSkinFMXLabel;
    ItemDelete: TSkinFMXItemDesignerPanel;
    SkinFMXButton1: TSkinFMXButton;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
  private
    //访客记录
    procedure DoGetVisitorListExecute(ATimerTask:TObject);
    procedure DoGetVisitorListExecuteEnd(ATimerTask:TObject);
  public
    procedure Load;
    { Public declarations }
  end;

var
  GlobalVisitorFrame:TFrameVisitor;

implementation

{$R *.fmx}

uses MainForm,
  WaitingFrame;

{ TFrameVisitor }

procedure TFrameVisitor.btnReturnClick(Sender: TObject);
begin
  ClearOnReturnFrameEvent(Self);
  HideFrame;//(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameVisitor.DoGetVisitorListExecute(ATimerTask: TObject);
begin
  // 出错
  TTimerTask(ATimerTask).TaskTag := 1;
  try
    TTimerTask(ATimerTask).TaskDesc :=SimpleCallAPI('get_record_list',
                  nil,
                  TableRestCenterInterfaceUrl,
                  ['appid',
                  'user_fid',
                  'key',
                  'rest_name',
                  'pageindex',
                  'pagesize',
                  'where_key_json',
                  'order_by'],
                  [AppID,
                  GlobalManager.User.fid,
                  GlobalManager.User.key,
                  'user_homepage_visitor_history_view',
                  1,
                  20,
                  GetWhereConditions(['appid','user_fid'],[AppID,GlobalManager.User.fid]),
                  'createtime DESC'
                  ]
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

procedure TFrameVisitor.DoGetVisitorListExecuteEnd(ATimerTask: TObject);
var
  ASuperObject:ISuperObject;
  I: Integer;
  AListBoxItem:TSkinListBoxItem;
begin

  try
    if TTimerTask(ATimerTask).TaskTag=0 then
    begin
      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
      if ASuperObject.I['Code']=200 then
      begin

        Self.lbList.Prop.Items.Clear(True);


        Self.lbList.Prop.Items.BeginUpdate;
        try

          //获取成功
          for I := 0 to ASuperObject.O['Data'].A['RecordList'].Length-1 do
          begin
            //创建页面

            AListBoxItem:=Self.lbList.Prop.Items.Add;


//              AListBoxItem.Caption:=ASuperObject.O['Data'].A['RecordList'].O[I].S['focused_user_name'];
//              if ASuperObject.O['Data'].A['RecordList'].O[I].I['is_focused_eachother']=1 then
//                AListBoxItem.Detail:='相互关注'
//              else
//                AListBoxItem.Detail:='已关注';
//              AListBoxItem.Detail1:=ASuperObject.O['Data'].A['RecordList'].O[I].S['focused_user_sign'];
//              //用户头像
//              AListBoxItem.Icon.Url:=GetImageUrl(ASuperObject.O['Data'].A['RecordList'].O[I].S['focused_head_pic_path'],itUserHead);
//              AListBoxItem.Icon.PictureDrawType:=TPictureDrawType.pdtUrl;
//              AListBoxItem.Icon.IsClipRound:=True;



          end;

        finally
          Self.lbList.Prop.Items.EndUpdate();
        end;



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
    HideWaitingFrame;
  end;
end;

procedure TFrameVisitor.Load;
begin

  Self.lbList.Prop.Items.BeginUpdate;
  try
    Self.lbList.Prop.Items.Clear(True);
  finally
    Self.lbList.Prop.Items.EndUpdate();
  end;


   ShowWaitingFrame(Self,Trans('获取中...'));
    //
    uTimerTask.GetGlobalTimerThread.RunTempTask(
        DoGetVisitorListExecute,
        DoGetVisitorListExecuteEnd,
        'get_record_list'
        );
end;

end.
