object OptionForm: TOptionForm
  Left = 759
  Top = 321
  BorderStyle = bsDialog
  Caption = 'Code Smells - Options'
  ClientHeight = 363
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 144
  TextHeight = 21
  object LogoImage: TImage
    Left = 454
    Top = 13
    Width = 207
    Height = 207
    Proportional = True
    Stretch = True
  end
  object EnabledLabel: TLabel
    Left = 13
    Top = 8
    Width = 134
    Height = 21
    Caption = '&Fart on build error'
    FocusControl = EnabledCheckBox
  end
  object FartTypeLabel: TLabel
    Left = 13
    Top = 99
    Width = 136
    Height = 21
    Caption = 'Choose a fart &type'
    FocusControl = FartTypeBox
  end
  object SaveButton: TButton
    Left = 454
    Top = 255
    Width = 207
    Height = 41
    Caption = '&Save'
    Default = True
    TabOrder = 2
    OnClick = SaveButtonClick
  end
  object CancelButton: TButton
    Left = 454
    Top = 305
    Width = 207
    Height = 41
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = CancelButtonClick
  end
  object EnabledCheckBox: TCheckBox
    Left = 13
    Top = 39
    Width = 415
    Height = 27
    Caption = '&Enabled'
    TabOrder = 0
  end
  object FartTypeBox: TComboBox
    Left = 13
    Top = 129
    Width = 415
    Height = 29
    Style = csDropDownList
    ItemHeight = 21
    TabOrder = 1
  end
end
