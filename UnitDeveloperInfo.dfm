object DeveloperForm: TDeveloperForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1054' '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082#1077
  ClientHeight = 198
  ClientWidth = 581
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnKeyPress = ReturnButtonKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object NameLabel: TLabel
    Left = 20
    Top = 8
    Width = 541
    Height = 33
    Caption = #1057#1090#1091#1076#1077#1085#1090' '#1075#1088#1091#1087#1087#1099' 151002 '#1050#1088#1091#1084#1082#1072#1095#1105#1074' '#1044#1084#1080#1090#1088#1080#1081
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -27
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object SpecialityLabel: TLabel
    Left = 151
    Top = 47
    Width = 279
    Height = 33
    Caption = #1060#1050#1057#1080#1057', '#1082#1072#1092#1077#1076#1088#1072' '#1055#1054#1048#1058
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -27
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object YearLabel: TLabel
    Left = 262
    Top = 86
    Width = 57
    Height = 33
    Caption = '2022'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -27
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    StyleElements = [seClient, seBorder]
  end
  object ReturnButton: TButton
    Left = 238
    Top = 150
    Width = 105
    Height = 37
    Caption = #1053#1072#1079#1072#1076
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = ReturnButtonClick
    OnKeyPress = ReturnButtonKeyPress
  end
end
