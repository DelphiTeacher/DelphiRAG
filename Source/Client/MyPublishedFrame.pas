unit MyPublishedFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uUIFunction,XSuperObject,uManager,
  ContentListFrame,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinPageControlType,
  uSkinFireMonkeyPageControl;

type
  TFrameMyPublished = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pcMain: TSkinFMXPageControl;
    tsDynamic: TSkinFMXTabSheet;
    tsPost: TSkinTabSheet;
    tsNews: TSkinFMXTabSheet;
    procedure btnReturnClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
  private
    FNewsContentListFrame:TFrameContentList;
    FCommunityContentListFrame:TFrameContentList;
    FCircleContentListFrame:TFrameContentList;
    { Private declarations }
  public
//    FrameHistroy: TFrameHistroy;
    procedure Load(ABigType:String);
    { Public declarations }
  end;

var
  GlobalMyPublishedFrame:TFrameMyPublished;

implementation
//uses ContentListFrame;
{$R *.fmx}

procedure TFrameMyPublished.btnReturnClick(Sender: TObject);
begin
  ClearOnReturnFrameEvent(Self);
  //返回
  HideFrame;//(Self, hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameMyPublished.Load(ABigType:String);
//var
//  AContentListFrame:TFrameContentList;
begin
//  Self.pcMain.Prop.ActivePage:=tsNews ;
//  AContentListFrame:=nil;
//  ShowFrame(TFrame(AContentListFrame),TFrameContentList,Self.tsNews,
////        //不加入到页面跳转历史
//        nil,nil,nil,nil,False,False,ufsefNone);
//  AContentListFrame.Clear;
//  AContentListFrame.pnlToolBar.Visible:=False;
//  AContentListFrame.FFilterUserFID:=GlobalManager.User.fid;
//  AContentListFrame.FFilterFavUserFID:='';
//  AContentListFrame.FFilterBigType:='news';
//  AContentListFrame.Load;

  if ABigType='news' then
  begin
    Self.pcMain.Prop.ActivePage:=tsNews;
  end else
  if ABigType='community' then
  begin
    Self.pcMain.Prop.ActivePage:=tsDynamic;
  end
  else
  //if Self.pcMain.Prop.ActivePage=tsPost then
  begin
    Self.pcMain.Prop.ActivePage:=tsPost;
    //AContentListFrame.FFilterBigType:='circle';
  end;
  pcMainChange(nil);

end;

procedure TFrameMyPublished.pcMainChange(Sender: TObject);
var
//  AContentFilterClassifyJson:ISuperObject;
  AContentListFrame:TFrameContentList;
begin
  AContentListFrame:=nil;

  if Self.pcMain.Prop.ActivePage=tsNews then
  begin
//    AContentListFrame.FFilterBigType:='news';
    ShowFrame(TFrame(FNewsContentListFrame),TFrameContentList,Self.pcMain.Prop.ActivePage,
        //不加入到页面跳转历史
        nil,nil,nil,nil,False,False,ufsefNone);
    AContentListFrame:=FNewsContentListFrame;
  end else
  if Self.pcMain.Prop.ActivePage=tsDynamic then
  begin
//    AContentListFrame.FFilterBigType:='community';
    ShowFrame(TFrame(FCommunityContentListFrame),TFrameContentList,Self.pcMain.Prop.ActivePage,
        //不加入到页面跳转历史
        nil,nil,nil,nil,False,False,ufsefNone);
    AContentListFrame:=FCommunityContentListFrame;
  end else
//  if Self.pcMain.Prop.ActivePage=tsPost then
  begin
//    AContentListFrame.FFilterBigType:='circle';
    ShowFrame(TFrame(FCircleContentListFrame),TFrameContentList,Self.pcMain.Prop.ActivePage,
        //不加入到页面跳转历史
        nil,nil,nil,nil,False,False,ufsefNone);
    AContentListFrame:=FCircleContentListFrame;
  end;



  AContentListFrame.Clear;
  AContentListFrame.pnlToolBar.Visible:=False;
  AContentListFrame.FFilterUserFID:=GlobalManager.User.fid;
  AContentListFrame.FFilterFavUserFID:='';
  if Self.pcMain.Prop.ActivePage=tsNews then
  begin
    AContentListFrame.FFilterBigType:='news';
  end else
  if Self.pcMain.Prop.ActivePage=tsDynamic then
  begin
    AContentListFrame.FFilterBigType:='community';
  end else
  if Self.pcMain.Prop.ActivePage=tsPost then
  begin
    AContentListFrame.FFilterBigType:='circle';
  end;

  AContentListFrame.Load;

end;

end.
