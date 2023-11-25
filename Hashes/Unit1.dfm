object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 311
  ClientWidth = 573
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnCalcHash: TButton
    Left = 275
    Top = 235
    Width = 118
    Height = 30
    Caption = #1042#1099#1095#1080#1089#1083#1080#1090#1100' '#1093#1077#1096
    TabOrder = 0
    OnClick = btnCalcHashClick
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 573
    Height = 177
    Align = alTop
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object ProgressBar1: TProgressBar
    AlignWithMargins = True
    Left = 3
    Top = 180
    Width = 567
    Height = 17
    Align = alTop
    TabOrder = 2
  end
  object clbHash: TCheckListBox
    Left = 3
    Top = 203
    Width = 246
    Height = 94
    Columns = 2
    ItemHeight = 13
    TabOrder = 3
  end
  object btnStop: TButton
    Left = 408
    Top = 235
    Width = 105
    Height = 30
    Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
    Enabled = False
    TabOrder = 4
    OnClick = btnStopClick
  end
  object OpenDialog1: TOpenDialog
    Left = 32
    Top = 208
  end
end
