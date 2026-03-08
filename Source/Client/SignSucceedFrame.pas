unit SignSucceedFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinButtonType, uSkinFireMonkeyButton,
  uUIFunction,
  uSkinFireMonkeyControl, uSkinImageType, uSkinFireMonkeyImage;

type
  TFrameSignSucceed = class(TFrame)
    imgSign: TSkinFMXImage;
    btnOK: TSkinFMXButton;
    pnlOK: TSkinFMXPanel;
    btnDays: TSkinFMXButton;
    procedure btnOKClick(Sender: TObject);
  private

    { Private declarations }
  public
    FSignDays:string;  //连续签到天数
    FGiftScore:string; //获取积分
    procedure Load;
    { Public declarations }
  end;

var
  GlobalSignSucceedFrame:TFrameSignSucceed;

implementation

{$R *.fmx}

procedure TFrameSignSucceed.btnOKClick(Sender: TObject);
begin
  HideFrame;//(Self,hfcttBeforeReturnFrame);
 // ReturnFrame;//(Self);
end;

procedure TFrameSignSucceed.Load;
begin
  btnDays.Caption:='恭喜你，获得'+FGiftScore+'积分';
  btnDays.Detail:='已经成功签到'+FSignDays+'天';

end;

end.
