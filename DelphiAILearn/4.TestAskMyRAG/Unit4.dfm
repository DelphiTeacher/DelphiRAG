object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Form4'
  ClientHeight = 441
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 32
    Top = 83
    Width = 26
    Height = 15
    Caption = #38382#39064
  end
  object Label2: TLabel
    Left = 32
    Top = 11
    Width = 39
    Height = 15
    Caption = #26381#21153#31471
  end
  object Label3: TLabel
    Left = 24
    Top = 37
    Width = 53
    Height = 15
    Caption = 'API Key'#65306
  end
  object edtQuestion: TEdit
    Left = 88
    Top = 80
    Width = 289
    Height = 23
    TabOrder = 0
    Text = 'DelphiGenAI'#26159#24178#20160#20040#29992#30340#65311
  end
  object Button1: TButton
    Left = 96
    Top = 128
    Width = 75
    Height = 25
    Caption = #38750#27969#24335#38382#31572
    TabOrder = 1
    OnClick = Button1Click
  end
  object memResponse: TMemo
    Left = 32
    Top = 168
    Width = 345
    Height = 249
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Button2: TButton
    Left = 246
    Top = 128
    Width = 75
    Height = 25
    Caption = #27969#24335#38382#31572
    TabOrder = 3
    OnClick = Button2Click
  end
  object edtAIServer: TEdit
    Left = 88
    Top = 8
    Width = 289
    Height = 23
    TabOrder = 4
    Text = 'http://localhost:80/v1/'
  end
  object edtAPIKey: TEdit
    Left = 88
    Top = 37
    Width = 177
    Height = 23
    TabOrder = 5
    Text = 'sk-5c2de62c553f41bdafa7357c390a0079'
  end
  object cmbModels: TComboBox
    Left = 296
    Top = 37
    Width = 81
    Height = 23
    ItemIndex = 0
    TabOrder = 6
    Text = 'qwen-plus'
    Items.Strings = (
      'qwen-plus'
      'qwen2-72b-instruct')
  end
end
