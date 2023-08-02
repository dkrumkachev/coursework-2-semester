object InstructionForm: TInstructionForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1057#1087#1088#1072#1074#1082#1072
  ClientHeight = 428
  ClientWidth = 790
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
    Left = 14
    Top = 49
    Width = 761
    Height = 232
    Caption = 
      #1048#1075#1088#1086#1082#1080' '#1087#1086' '#1086#1095#1077#1088#1077#1076#1080' '#1088#1072#1089#1089#1090#1072#1074#1083#1103#1102#1090' '#1082#1086#1088#1072#1073#1083#1080' '#1085#1072' '#1089#1074#1086#1105#1084' '#1087#1086#1083#1077'. '#1055#1088#1080' '#1088#1072#1079#1084#1077#1097#1077 +
      #1085#1080#1080' '#1082#1086#1088#1072#1073#1083#1080' '#1085#1077' '#1084#1086#1075#1091#1090' '#1082#1072#1089#1072#1090#1100#1089#1103' '#1076#1088#1091#1075' '#1076#1088#1091#1075#1072' '#1089#1090#1086#1088#1086#1085#1072#1084#1080' '#1080' '#1091#1075#1083#1072#1084#1080'. '#1055#1086#1089 +
      #1083#1077' '#1088#1072#1079#1084#1077#1097#1077#1085#1080#1103' '#1082#1086#1088#1072#1073#1083#1077#1081' '#1080#1075#1088#1086#1082#1080' '#1087#1086' '#1086#1095#1077#1088#1077#1076#1080' "'#1089#1090#1088#1077#1083#1103#1102#1090'" '#1087#1086' '#1087#1086#1083#1102' '#1087#1088#1086#1090 +
      #1080#1074#1085#1080#1082#1072' '#1089' '#1094#1077#1083#1100#1102' '#1091#1085#1080#1095#1090#1086#1078#1080#1090#1100' '#1077#1075#1086' '#1082#1086#1088#1072#1073#1083#1080'. '#1055#1088#1080' '#1087#1086#1087#1072#1076#1072#1085#1080#1080' '#1087#1086' '#1082#1086#1088#1072#1073#1083#1102' ' +
      #1082#1083#1077#1090#1082#1072' '#1086#1090#1084#1077#1095#1072#1077#1090#1089#1103' '#1082#1088#1077#1089#1090#1080#1082#1086#1084', '#1087#1088#1080' '#1087#1088#1086#1084#1072#1093#1077' - '#1090#1086#1095#1082#1086#1081'.  '#1045#1089#1083#1080' '#1080#1075#1088#1086#1082' '#1087 +
      #1086#1087#1072#1083' '#1074' '#1082#1086#1088#1072#1073#1083#1100' '#1087#1088#1086#1090#1080#1074#1085#1080#1082#1072', '#1086#1085' '#1076#1077#1083#1072#1077#1090' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1093' '#1093#1086#1076'. '#1048#1075#1088#1072' '#1079#1072 +
      #1082#1072#1085#1095#1080#1074#1072#1077#1090#1089#1103', '#1082#1086#1075#1076#1072' '#1086#1076#1080#1085' '#1080#1079' '#1080#1075#1088#1086#1082#1086#1074' '#1091#1085#1080#1095#1090#1086#1078#1080#1090' '#1074#1089#1077' '#1082#1086#1088#1072#1073#1083#1080' '#1076#1088#1091#1075#1086#1075#1086 +
      '.'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -24
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    WordWrap = True
    StyleElements = [seClient, seBorder]
  end
  object YearLabel: TLabel
    Left = 301
    Top = 8
    Width = 188
    Height = 35
    Caption = #1055#1088#1072#1074#1080#1083#1072' '#1080#1075#1088#1099
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
  object Label1: TLabel
    Left = 14
    Top = 316
    Width = 761
    Height = 29
    Caption = #1042' '#1084#1077#1085#1102' '#1085#1072#1089#1090#1088#1086#1077#1082' '#1084#1086#1078#1085#1086' '#1074#1099#1073#1088#1072#1090#1100' '#1088#1072#1079#1084#1077#1088' '#1087#1086#1083#1103' '#1080' '#1089#1083#1086#1078#1085#1086#1089#1090#1100' '#1073#1086#1090#1072'.'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -24
    Font.Name = 'Bahnschrift'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    WordWrap = True
    StyleElements = [seClient, seBorder]
  end
  object ReturnButton: TButton
    Left = 342
    Top = 377
    Width = 106
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
