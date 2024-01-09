object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Yandex Disk'
  ClientHeight = 400
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 460
    Height = 192
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
    ExplicitWidth = 437
    ExplicitHeight = 297
  end
  object Panel1: TPanel
    Left = 0
    Top = 192
    Width = 460
    Height = 105
    Align = alBottom
    BevelOuter = bvSpace
    TabOrder = 1
    ExplicitLeft = 8
    ExplicitTop = 303
    ExplicitWidth = 401
    DesignSize = (
      460
      105)
    object lbPassword: TLabel
      Left = 8
      Top = 73
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object lbUsername: TLabel
      Left = 8
      Top = 41
      Width = 48
      Height = 13
      Caption = 'Username'
    end
    object btnWebDAV: TButton
      Left = 348
      Top = 37
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'IdWebDAV'
      TabOrder = 0
      OnClick = btnWebDAVClick
      ExplicitLeft = 325
    end
    object btnNetHTTPClient: TButton
      Left = 348
      Top = 68
      Width = 97
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'NetHTTPClient'
      TabOrder = 1
      OnClick = btnNetHTTPClientClick
      ExplicitLeft = 325
    end
    object edUsername: TEdit
      Left = 65
      Top = 39
      Width = 267
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      ExplicitWidth = 240
    end
    object edPassword: TEdit
      Left = 65
      Top = 70
      Width = 267
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      ExplicitWidth = 240
    end
    object Edit1: TEdit
      Left = 8
      Top = 6
      Width = 330
      Height = 21
      ParentColor = True
      ReadOnly = True
      TabOrder = 4
      Text = 'https://id.yandex.ru/security/app-passwords     ('#1092#1072#1081#1083#1099' WebDav)'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 297
    Width = 460
    Height = 103
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 280
    ExplicitWidth = 437
    DesignSize = (
      460
      103)
    object lbToken: TLabel
      Left = 8
      Top = 45
      Width = 29
      Height = 13
      Caption = 'Token'
    end
    object btnCloudAPI: TButton
      Left = 348
      Top = 68
      Width = 97
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cloud API'
      TabOrder = 0
      OnClick = btnCloudAPIClick
      ExplicitLeft = 325
    end
    object edToken: TEdit
      Left = 43
      Top = 41
      Width = 402
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      ExplicitWidth = 379
    end
    object Edit2: TEdit
      Left = 8
      Top = 6
      Width = 330
      Height = 21
      ParentColor = True
      ReadOnly = True
      TabOrder = 2
      Text = 'https://yandex.ru/dev/disk/poligon/#     ('#1055#1086#1083#1091#1095#1080#1090#1100' '#1090#1086#1082#1077#1085')'
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 24
    Top = 25
  end
end
