object SettingsForm: TSettingsForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 194
  ClientWidth = 442
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object SizeLabel: TLabel
    Left = 24
    Top = 64
    Width = 123
    Height = 24
    Caption = #1056#1072#1079#1084#1077#1088' '#1087#1086#1083#1103':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentFont = False
  end
  object TextLabel: TLabel
    Left = 104
    Top = 18
    Width = 249
    Height = 24
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1091#1078#1085#1099#1081' '#1074#1072#1088#1080#1072#1085#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentFont = False
  end
  object DifficultyLabel: TLabel
    Left = 24
    Top = 104
    Width = 152
    Height = 24
    Caption = #1057#1083#1086#1078#1085#1086#1089#1090#1100' '#1073#1086#1090#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentFont = False
  end
  object RadioButton10: TRadioButton
    Left = 272
    Top = 70
    Width = 74
    Height = 17
    Caption = '10x10'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TabStop = True
    OnKeyPress = FormKeyPress
  end
  object RadioButton8: TRadioButton
    Left = 192
    Top = 70
    Width = 74
    Height = 17
    Caption = '8x8'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnKeyPress = FormKeyPress
  end
  object RadioButton12: TRadioButton
    Left = 352
    Top = 70
    Width = 65
    Height = 17
    Caption = '12x12'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnKeyPress = FormKeyPress
  end
  object DifficultyTrackBar: TTrackBar
    Left = 192
    Top = 109
    Width = 225
    Height = 28
    Max = 3
    ParentShowHint = False
    ShowHint = False
    TabOrder = 3
    OnKeyPress = FormKeyPress
  end
end
