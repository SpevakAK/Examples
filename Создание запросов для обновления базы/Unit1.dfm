object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1080#1083#1080' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1087#1086#1083#1103
  ClientHeight = 522
  ClientWidth = 846
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SynEdit1: TSynEdit
    Left = 0
    Top = 147
    Width = 846
    Height = 375
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 0
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Highlighter = SynSQL
    FontSmoothing = fsmNone
  end
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 846
    Height = 147
    Align = alTop
    TabOrder = 1
    Tabs.Strings = (
      #1057#1086#1079#1076#1072#1085#1080#1077' '#1087#1086#1083#1103
      #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1090#1080#1087#1072' '#1087#1086#1083#1103)
    TabIndex = 0
    object lbTable: TLabel
      Left = 154
      Top = 44
      Width = 46
      Height = 13
      Caption = #1058#1072#1073#1083#1080#1094#1072':'
    end
    object lbField: TLabel
      Left = 154
      Top = 71
      Width = 29
      Height = 13
      Caption = #1055#1086#1083#1077':'
    end
    object lbType: TLabel
      Left = 154
      Top = 98
      Width = 64
      Height = 13
      Caption = #1058#1080#1087' '#1076#1072#1085#1085#1099#1093':'
    end
    object btnCreate: TButton
      Left = 712
      Top = 46
      Width = 119
      Height = 35
      Caption = #1057#1086#1079#1076#1072#1090#1100
      TabOrder = 0
      OnClick = btnCreateClick
    end
    object cbDefNull: TCheckBox
      Left = 375
      Top = 97
      Width = 85
      Height = 17
      Caption = 'DEFAULT null'
      TabOrder = 1
    end
    object cbDataType: TComboBox
      Left = 224
      Top = 95
      Width = 145
      Height = 21
      TabOrder = 2
      OnChange = cbDataTypeChange
    end
    object edField: TEdit
      Left = 224
      Top = 68
      Width = 121
      Height = 21
      TabOrder = 3
    end
    object edTable: TEdit
      Left = 224
      Top = 41
      Width = 121
      Height = 21
      TabOrder = 4
    end
    object rgDataBaseType: TRadioGroup
      Left = 25
      Top = 33
      Width = 120
      Height = 96
      Caption = #1057#1059#1041#1044':'
      ItemIndex = 0
      Items.Strings = (
        'Firebird'
        'Oracle')
      TabOrder = 5
      OnClick = rgDataBaseTypeClick
    end
    object GroupBox1: TGroupBox
      Left = 477
      Top = 29
      Width = 218
      Height = 100
      Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103
      TabOrder = 6
      object lbScale: TLabel
        Left = 11
        Top = 73
        Width = 45
        Height = 13
        Hint = #1055#1086#1089#1083#1077' '#1079#1072#1087#1103#1090#1086#1081
        Caption = #1052#1072#1089#1096#1090#1072#1073
        ParentShowHint = False
        ShowHint = True
      end
      object lbPrecision: TLabel
        Left = 11
        Top = 46
        Width = 47
        Height = 13
        Hint = #1055#1077#1088#1077#1076' '#1079#1072#1087#1103#1090#1086#1081
        Caption = #1058#1086#1095#1085#1086#1089#1090#1100
        ParentShowHint = False
        ShowHint = True
      end
      object cbNotUseRestrictions: TCheckBox
        Left = 11
        Top = 19
        Width = 177
        Height = 17
        Caption = #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103
        TabOrder = 0
        OnClick = cbNotUseRestrictionsClick
      end
      object sePrecision: TSpinEdit
        Left = 66
        Top = 42
        Width = 60
        Height = 22
        Hint = #1055#1077#1088#1077#1076' '#1079#1072#1087#1103#1090#1086#1081
        MaxValue = 0
        MinValue = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Value = 40
      end
      object seScale: TSpinEdit
        Left = 66
        Top = 70
        Width = 60
        Height = 22
        Hint = #1055#1086#1089#1083#1077' '#1079#1072#1087#1103#1090#1086#1081
        MaxValue = 0
        MinValue = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Value = 0
      end
      object cbChars: TCheckBox
        Left = 141
        Top = 44
        Width = 79
        Height = 17
        Caption = #1057#1080#1084#1074#1086#1083'('#1099')'
        TabOrder = 3
      end
    end
  end
  object SynSQL: TSynSQLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 400
    Top = 8
  end
end
