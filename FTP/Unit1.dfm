object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Uploader FTP/SFTP'
  ClientHeight = 335
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 16
    Top = 11
    Width = 37
    Height = 13
    Caption = 'Adress:'
  end
  object Label4: TLabel
    Left = 240
    Top = 11
    Width = 24
    Height = 13
    Caption = 'Port:'
  end
  object Label5: TLabel
    Left = 16
    Top = 35
    Width = 56
    Height = 13
    Caption = 'User Name:'
  end
  object Label6: TLabel
    Left = 16
    Top = 62
    Width = 50
    Height = 13
    Caption = 'Password:'
  end
  object lbFileName: TLabel
    Left = 16
    Top = 89
    Width = 47
    Height = 13
    Caption = 'FileName:'
  end
  object sbSelectFile: TSpeedButton
    Left = 511
    Top = 83
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = sbSelectFileClick
  end
  object edURL: TEdit
    Left = 82
    Top = 8
    Width = 151
    Height = 21
    TabOrder = 0
    Text = '192.168.8.1'
  end
  object edUserName: TEdit
    Left = 82
    Top = 32
    Width = 246
    Height = 21
    TabOrder = 1
    Text = 'anonymous'
  end
  object edPassword: TEdit
    Left = 82
    Top = 57
    Width = 246
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
    Text = 'anonymous'
  end
  object btnFTP: TButton
    Left = 16
    Top = 301
    Width = 75
    Height = 25
    Caption = 'FTP'
    TabOrder = 3
    OnClick = btnFTPClick
  end
  object sePort: TSpinEdit
    Left = 270
    Top = 8
    Width = 58
    Height = 22
    MaxValue = 65535
    MinValue = 0
    TabOrder = 4
    Value = 21
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 111
    Width = 518
    Height = 17
    TabOrder = 5
  end
  object btnsFTP: TButton
    Left = 109
    Top = 301
    Width = 75
    Height = 25
    Caption = 'SFTP'
    TabOrder = 6
    OnClick = btnsFTPClick
  end
  object Button1: TButton
    Left = 459
    Top = 301
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 7
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 134
    Width = 518
    Height = 161
    ScrollBars = ssBoth
    TabOrder = 8
  end
  object edFIleName: TEdit
    Left = 82
    Top = 84
    Width = 423
    Height = 21
    TabOrder = 9
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 496
    Top = 8
  end
end
