object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 500
  ClientWidth = 1137
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 675
    Top = 13
    Width = 65
    Height = 15
    Caption = #30149#21382#21015#34920#65306
  end
  object Label2: TLabel
    Left = 675
    Top = 248
    Width = 52
    Height = 15
    Caption = #20851#38190#35789#65306
  end
  object Label3: TLabel
    Left = 32
    Top = 8
    Width = 53
    Height = 15
    Caption = 'API Key'#65306
  end
  object Button1: TButton
    Left = 224
    Top = 168
    Width = 75
    Height = 25
    Caption = #21028#26029#30456#20284#24230
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 24
    Top = 56
    Width = 553
    Height = 23
    TabOrder = 1
    Text = 'Hello World!'
  end
  object Edit2: TEdit
    Left = 24
    Top = 104
    Width = 553
    Height = 23
    TabOrder = 2
    Text = #20320#22909#65292#19990#30028#65281
  end
  object Memo1: TMemo
    Left = 24
    Top = 216
    Width = 545
    Height = 276
    TabOrder = 3
  end
  object Memo2: TMemo
    Left = 675
    Top = 34
    Width = 409
    Height = 193
    Lines.Strings = (
      '1. '#24739#32773#22240#27969#28053#12289#21693#30171#20276#20302#28909#20004#22825#21069#26469#23601#35786#12290
      '2. '#35813#30149#20154#33258#36848#20986#29616#40763#22622#12289#21683#22013#21450#20840#36523#32908#32905#37240#30171#30340#30151#29366#12290
      '3. '#24739#20799#34920#29616#20026#25171#21943#22159#12289#21897#21657#19981#36866#65292#24182#20276#26377#36731#24494#22836#30171#12290
      '1. '#24739#32773#22240#24038#33181#20851#33410#25345#32493#32959#30171#20276#26216#20725#23601#35786#65292'X'#20809#29255#26174#31034#20851#33410#38388#38553#29421#31364#12290
      '2. '#19968#21517#32769#24180#22899#24615#21491#25163#22810#20010#25351#38388#20851#33410#20986#29616#23545#31216#24615#26797#24418#33192#22823#65292#27963#21160#21463#38480#12290
      '3. '#36816#21160#21592#21491#32920#20851#33410#22312#36807#24230#20351#29992#21518#20986#29616#32418#32959#28909#30171#65292#27963#21160#26102#21487#38395#21450#25705#25830#38899#12290
      '1. '#24739#32773#32972#37096#20986#29616#22810#20010#20197#27611#22218#20026#20013#24515#30340#32418#33394#28814#24615#19992#30137#65292#37096#20998#39030#31471#26377#33043#28857#12290
      '2. '#20854#25163#33218#21644#36527#24178#25955#21457#22810#22788#22659#30028#28165#26224#30340#21365#22278#24418#28129#32418#26001#65292#19978#35206#23569#37327#32454#30862#40158#23633#12290
      '3. '#24739#32773#36275#36286#38388#30382#32932#28024#28173#21457#30333#12289#33073#30382#65292#20276#26377#26126#26174#30233#30162#12290)
    TabOrder = 4
    WordWrap = False
  end
  object edtKeyword: TEdit
    Left = 733
    Top = 245
    Width = 196
    Height = 23
    TabOrder = 5
    Text = #24863#20882
  end
  object Button2: TButton
    Left = 968
    Top = 244
    Width = 116
    Height = 25
    Caption = #25991#26412#30456#20851#24615#25628#32034
    TabOrder = 6
    OnClick = Button2Click
  end
  object Memo3: TMemo
    Left = 675
    Top = 288
    Width = 409
    Height = 204
    TabOrder = 7
    WordWrap = False
  end
  object edtAPIKey: TEdit
    Left = 96
    Top = 8
    Width = 177
    Height = 23
    TabOrder = 8
    Text = 'sk-5c2de62c553f41bdafa7357c390a0079'
  end
  object NetHTTPClient1: TNetHTTPClient
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 480
    Top = 144
  end
end
