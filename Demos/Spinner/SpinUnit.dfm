object Form1: TForm1
  Left = 192
  Top = 107
  Caption = 'Form1'
  ClientHeight = 201
  ClientWidth = 310
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  TextHeight = 13
  object Label1: TLabel
    Left = 56
    Top = 24
    Width = 18
    Height = 13
    Caption = '100'
  end
  object Label2: TLabel
    Left = 32
    Top = 75
    Width = 20
    Height = 13
    Caption = 'Min:'
  end
  object Label3: TLabel
    Left = 32
    Top = 99
    Width = 23
    Height = 13
    Caption = 'Max:'
  end
  object Label4: TLabel
    Left = 32
    Top = 147
    Width = 38
    Height = 13
    Caption = 'Interval:'
  end
  object Label5: TLabel
    Left = 160
    Top = 148
    Width = 128
    Height = 13
    Caption = 'trigger speed of spin button'
  end
  object Label6: TLabel
    Left = 88
    Top = 24
    Width = 109
    Height = 13
    Caption = '(position of spin button)'
  end
  object Label7: TLabel
    Left = 32
    Top = 123
    Width = 50
    Height = 13
    Caption = 'Increment:'
  end
  object SCSpinButton1: TSCSpinButton
    Left = 32
    Top = 16
    Width = 18
    Height = 28
    Interval = 500
    Max = 200
    Min = 100
    Position = 100
    TabOrder = 0
    OnChange = SCSpinButton1Change
  end
  object SCIntSpinEdit1: TSCIntSpinEdit
    Left = 88
    Top = 72
    Width = 65
    Height = 21
    IntValue = 100
    TabOrder = 1
    OnChange = SCIntSpinEdit1Change
  end
  object SCIntSpinEdit2: TSCIntSpinEdit
    Left = 88
    Top = 96
    Width = 65
    Height = 21
    IntValue = 200
    TabOrder = 2
    OnChange = SCIntSpinEdit2Change
  end
  object SCIntSpinEdit3: TSCIntSpinEdit
    Left = 88
    Top = 144
    Width = 65
    Height = 21
    Increment = 100
    IntValue = 500
    TabOrder = 3
    OnChange = SCIntSpinEdit3Change
  end
  object SCIntSpinEdit4: TSCIntSpinEdit
    Left = 88
    Top = 120
    Width = 65
    Height = 21
    Increment = 5
    IntValue = 1
    MinValue = 1
    MaxValue = 1000
    TabOrder = 4
    OnChange = SCIntSpinEdit4Change
  end
end
