object Form2: TForm2
  Left = 1471
  Top = 923
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'DNS Update executed'
  ClientHeight = 64
  ClientWidth = 198
  Color = clActiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 181
    Height = 13
    Caption = 'DNS Update has refreshed host'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 136
    Top = 32
  end
end
