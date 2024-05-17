object form3: Tform3
  Left = 0
  Top = 0
  Caption = 'Configura'#231#245'es'
  ClientHeight = 437
  ClientWidth = 510
  Color = clWhite
  CustomTitleBar.CaptionAlignment = taCenter
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  DesignSize = (
    510
    437)
  TextHeight = 13
  object Button1: TButton
    Left = 196
    Top = 399
    Width = 118
    Height = 25
    Caption = 'Salvar'
    TabOrder = 0
    OnClick = Button1Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 511
    Height = 385
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Servidor'
      object Label2: TLabel
        Left = 265
        Top = 299
        Width = 30
        Height = 13
        Caption = 'Senha'
      end
      object Label3: TLabel
        Left = 15
        Top = 299
        Width = 66
        Height = 13
        Caption = 'Lista de cifras'
      end
      object Label6: TLabel
        Left = 16
        Top = 248
        Width = 26
        Height = 13
        Caption = 'Modo'
      end
      object Label7: TLabel
        Left = 16
        Top = 194
        Width = 36
        Height = 13
        Caption = 'M'#233'todo'
      end
      object Label8: TLabel
        Left = 462
        Top = 299
        Width = 26
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'Exibir'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = Label8Click
      end
      object Label5: TLabel
        Left = 340
        Top = 16
        Width = 145
        Height = 13
        Cursor = crHandPoint
        AutoSize = False
        BiDiMode = bdRightToLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentFont = False
        OnClick = Label5Click
      end
      object Label10: TLabel
        Left = 16
        Top = 90
        Width = 63
        Height = 13
        Caption = 'Porta padr'#227'o'
      end
      object Label11: TLabel
        Left = 128
        Top = 90
        Width = 54
        Height = 13
        Caption = 'Porta HTTP'
      end
      object Label12: TLabel
        Left = 234
        Top = 90
        Width = 60
        Height = 13
        Caption = 'Porta HTTPS'
      end
      object CheckBox1: TCheckBox
        Left = 15
        Top = 52
        Width = 86
        Height = 17
        Caption = 'Ativar servi'#231'o'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object CheckBox2: TCheckBox
        Left = 276
        Top = 52
        Width = 213
        Height = 17
        Caption = 'Iniciar automaticamente com o Windows'
        TabOrder = 1
      end
      object CheckBox5: TCheckBox
        Left = 128
        Top = 52
        Width = 118
        Height = 17
        Caption = 'Conex'#227'o persistente'
        TabOrder = 2
      end
      object Button2: TButton
        Left = 438
        Top = 213
        Width = 51
        Height = 21
        Caption = 'Cert..'
        TabOrder = 3
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 438
        Top = 240
        Width = 51
        Height = 21
        Caption = 'Key..'
        TabOrder = 4
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 438
        Top = 267
        Width = 51
        Height = 21
        Caption = 'Root..'
        TabOrder = 5
        OnClick = Button4Click
      end
      object CheckBox3: TCheckBox
        Left = 15
        Top = 155
        Width = 77
        Height = 17
        Caption = 'Ativar SSL'
        TabOrder = 6
      end
      object CheckBox6: TCheckBox
        Left = 98
        Top = 155
        Width = 70
        Height = 17
        Caption = 'For'#231'ar SSL'
        TabOrder = 7
      end
      object ComboBox1: TComboBox
        Left = 16
        Top = 213
        Width = 166
        Height = 21
        TabOrder = 8
        Items.Strings = (
          'Todos'
          'SSLv2'
          'SSLv23'
          'SSLv3'
          'TLSv1'
          'TLSv1_1'
          'TLSv1_2')
      end
      object ComboBox2: TComboBox
        Left = 16
        Top = 267
        Width = 166
        Height = 21
        TabOrder = 9
        Items.Strings = (
          'Both'
          'Client'
          'Server'
          'Unassigned')
      end
      object Edit1: TEdit
        Left = 211
        Top = 213
        Width = 221
        Height = 21
        TabOrder = 10
      end
      object Edit2: TEdit
        Left = 211
        Top = 240
        Width = 221
        Height = 21
        TabOrder = 11
      end
      object Edit3: TEdit
        Left = 211
        Top = 267
        Width = 221
        Height = 21
        TabOrder = 12
      end
      object Edit4: TEdit
        Left = 265
        Top = 318
        Width = 223
        Height = 21
        PasswordChar = '*'
        TabOrder = 13
      end
      object Edit5: TEdit
        Left = 15
        Top = 318
        Width = 232
        Height = 21
        TabOrder = 14
      end
      object portahttp: TEdit
        Left = 128
        Top = 109
        Width = 85
        Height = 21
        TabOrder = 15
      end
      object portahttps: TEdit
        Left = 234
        Top = 109
        Width = 85
        Height = 21
        TabOrder = 16
      end
      object portapadrao: TEdit
        Left = 16
        Top = 109
        Width = 85
        Height = 21
        TabOrder = 17
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'DDNS'
      ImageIndex = 1
      object Label1: TLabel
        Left = 14
        Top = 142
        Width = 90
        Height = 13
        Caption = 'Link de atualiza'#231#227'o'
      end
      object Label4: TLabel
        Left = 14
        Top = 88
        Width = 37
        Height = 13
        Caption = 'Dom'#237'nio'
      end
      object SpeedButton2: TSpeedButton
        Left = 406
        Top = 161
        Width = 83
        Height = 21
        Caption = 'Atualizar'
        OnClick = SpeedButton2Click
      end
      object SpeedButton3: TSpeedButton
        Left = 406
        Top = 107
        Width = 83
        Height = 21
        Caption = 'Testar dom'#237'nio'
        OnClick = SpeedButton3Click
      end
      object CheckBox4: TCheckBox
        Left = 14
        Top = 52
        Width = 77
        Height = 17
        Caption = 'Ativar DDNS'
        TabOrder = 0
      end
      object dominio: TEdit
        Left = 14
        Top = 107
        Width = 386
        Height = 21
        TabOrder = 1
      end
      object linkdeatualizacao: TEdit
        Left = 14
        Top = 161
        Width = 386
        Height = 21
        TabOrder = 2
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Server-side'
      ImageIndex = 2
      object SpeedButton1: TSpeedButton
        Left = 464
        Top = 71
        Width = 25
        Height = 22
        Caption = '..'
        OnClick = SpeedButton1Click
      end
      object Label9: TLabel
        Left = 13
        Top = 52
        Width = 40
        Height = 13
        Caption = 'PHP exe'
      end
      object Label13: TLabel
        Left = 13
        Top = 162
        Width = 202
        Height = 13
        Caption = 'Iniciar um programa automaticamente exe'
      end
      object SpeedButton4: TSpeedButton
        Left = 464
        Top = 181
        Width = 25
        Height = 22
        Caption = '..'
        OnClick = SpeedButton4Click
      end
      object Label14: TLabel
        Left = 13
        Top = 108
        Width = 55
        Height = 13
        Caption = 'Python exe'
      end
      object SpeedButton5: TSpeedButton
        Left = 464
        Top = 126
        Width = 25
        Height = 22
        Caption = '..'
        OnClick = SpeedButton5Click
      end
      object Edit6: TEdit
        Left = 13
        Top = 71
        Width = 445
        Height = 21
        TabOrder = 0
      end
      object Edit7: TEdit
        Left = 13
        Top = 181
        Width = 445
        Height = 21
        TabOrder = 1
      end
      object Edit8: TEdit
        Left = 13
        Top = 127
        Width = 445
        Height = 21
        TabOrder = 2
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 417
    Top = 405
  end
  object OpenDialog2: TOpenDialog
    Left = 373
    Top = 405
  end
  object Timer1: TTimer
    Interval = 300000
    OnTimer = Timer1Timer
    Left = 16
    Top = 400
  end
  object OpenDialog3: TOpenDialog
    Left = 64
    Top = 392
  end
  object OpenDialog4: TOpenDialog
    Left = 328
    Top = 392
  end
  object OpenDialog5: TOpenDialog
    Left = 128
    Top = 392
  end
end
