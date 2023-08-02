object MainMenuForm: TMainMenuForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1052#1086#1088#1089#1082#1086#1081' '#1073#1086#1081
  ClientHeight = 406
  ClientWidth = 438
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  Visible = True
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object NameLabel: TLabel
    Left = 138
    Top = 24
    Width = 174
    Height = 35
    Caption = #1052#1086#1088#1089#1082#1086#1081' '#1073#1086#1081
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -29
    Font.Name = 'Bahnschrift'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object SinglePlayerButton: TButton
    Left = 73
    Top = 88
    Width = 280
    Height = 57
    Caption = #1054#1076#1080#1085#1086#1095#1085#1072#1103' '#1080#1075#1088#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = SinglePlayerButtonClick
    OnKeyDown = FormKeyDown
    OnKeyPress = FormKeyPress
  end
  object TwoPlayersButton: TButton
    Left = 73
    Top = 155
    Width = 280
    Height = 57
    Caption = #1048#1075#1088#1072' '#1074#1076#1074#1086#1105#1084
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = TwoPlayersButtonClick
    OnKeyDown = FormKeyDown
    OnKeyPress = FormKeyPress
  end
  object SettingsButton: TButton
    Left = 73
    Top = 289
    Width = 280
    Height = 57
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = SettingsButtonClick
    OnKeyDown = FormKeyDown
    OnKeyPress = FormKeyPress
  end
  object ContinueButton: TButton
    Left = 73
    Top = 222
    Width = 280
    Height = 57
    Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100' '#1080#1075#1088#1091
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = ContinueButtonClick
    OnKeyDown = FormKeyDown
    OnKeyPress = FormKeyPress
  end
  object MainMenu: TMainMenu
    Left = 16
    Top = 8
    object InstructionMenu: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      OnClick = InstructionMenuClick
    end
    object DeveloperMenu: TMenuItem
      Caption = #1054' '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082#1077
      OnClick = DeveloperMenuClick
    end
  end
end
