object frmDLLExport: TfrmDLLExport
  Left = 206
  Top = 154
  Caption = 'View DLL Export'
  ClientHeight = 523
  ClientWidth = 492
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 450
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 486
    Width = 492
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 6
      Top = 11
      Width = 42
      Height = 13
      Caption = #1060#1080#1083#1100#1090#1088':'
    end
    object edFilter: TEdit
      Left = 54
      Top = 9
      Width = 220
      Height = 21
      TabOrder = 0
      OnChange = edFilterChange
    end
    object btSelectDLL: TButton
      Left = 378
      Top = 0
      Width = 114
      Height = 37
      Align = alRight
      Caption = #1054#1073#1079#1086#1088
      TabOrder = 1
      OnClick = btSelectDLLClick
    end
  end
  object lbView: TListBox
    Left = 0
    Top = 0
    Width = 492
    Height = 486
    Align = alClient
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 1
    OnDblClick = lbViewDblClick
    OnKeyDown = lbViewKeyDown
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 520
    Top = 8
  end
end
