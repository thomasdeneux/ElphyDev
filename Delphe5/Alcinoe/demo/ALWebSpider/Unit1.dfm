object Form1: TForm1
  Left = 473
  Top = 288
  Width = 561
  Height = 339
  Caption = 'ALWebSpider'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 37
    Top = 19
    Width = 76
    Height = 13
    Caption = 'URL to Crawl'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 28
    Top = 43
    Width = 85
    Height = 13
    Caption = 'Save Directory'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 20
    Top = 67
    Width = 93
    Height = 13
    Caption = 'Max Deep Level'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ButtonStop: TButton
    Left = 200
    Top = 181
    Width = 75
    Height = 25
    Caption = 'Stop'
    Enabled = False
    TabOrder = 12
    OnClick = ButtonStopClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 274
    Width = 553
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 100
      end>
  end
  object editURL2Crawl: TEdit
    Left = 120
    Top = 16
    Width = 362
    Height = 19
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    Text = 'http://www.arkadia.com'
  end
  object ButtonStart: TButton
    Left = 120
    Top = 181
    Width = 75
    Height = 25
    Caption = 'Start'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = ButtonStartClick
  end
  object EditSaveDirectory: TEdit
    Left = 120
    Top = 40
    Width = 345
    Height = 19
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 8
  end
  object EditMaxDeepLevel: TEdit
    Left = 120
    Top = 64
    Width = 65
    Height = 19
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    Text = '-1'
  end
  object UpDownMaxDeepLevel: TUpDown
    Left = 185
    Top = 64
    Width = 15
    Height = 19
    Associate = EditMaxDeepLevel
    Min = -1
    Max = 10000
    Position = -1
    TabOrder = 3
  end
  object CheckBoxDownloadImage: TCheckBox
    Left = 120
    Top = 96
    Width = 105
    Height = 17
    Caption = 'Download image'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object CheckBoxUpdateHref: TCheckBox
    Left = 120
    Top = 120
    Width = 169
    Height = 17
    Caption = 'Update Href to local FileName'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object CheckBoxStayInStartSite: TCheckBox
    Left = 120
    Top = 144
    Width = 105
    Height = 17
    Caption = 'Stay in Start Site'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object StatusBar2: TStatusBar
    Left = 0
    Top = 293
    Width = 553
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object BtnChooseSaveDirectory: TButton
    Left = 465
    Top = 40
    Width = 17
    Height = 19
    Caption = '...'
    TabOrder = 1
    OnClick = BtnChooseSaveDirectoryClick
  end
  object MemoErrorMsg: TMemo
    Left = 0
    Top = 222
    Width = 553
    Height = 52
    Align = alBottom
    Ctl3D = True
    ParentCtl3D = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 9
    WordWrap = False
  end
  object Panel1: TPanel
    Left = 325
    Top = 96
    Width = 200
    Height = 70
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Panel1'
    Ctl3D = False
    ParentColor = True
    ParentCtl3D = False
    TabOrder = 13
    object Label5: TLabel
      Left = 5
      Top = 8
      Width = 189
      Height = 52
      Caption = 
        'Please add in your website a link to http://www.arkadia.com or s' +
        'end me an email to svanderclock@arkadia.com if you like this com' +
        'ponent!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
  end
  object MainWebSpider: TAlWebSpider
    OnCrawlDownloadSuccess = MainWebSpiderCrawlDownloadSuccess
    OnCrawlDownloadRedirect = MainWebSpiderCrawlDownloadRedirect
    OnCrawlDownloadError = MainWebSpiderCrawlDownloadError
    OnCrawlGetNextLink = MainWebSpiderCrawlGetNextLink
    OnCrawlFindLink = MainWebSpiderCrawlFindLink
    OnUpdateLinkToLocalPathGetNextFile = MainWebSpiderUpdateLinkToLocalPathGetNextFile
    OnUpdateLinkToLocalPathFindLink = MainWebSpiderUpdateLinkToLocalPathFindLink
    HttpClient = MainHttpClient
    Left = 16
    Top = 88
  end
  object MainHttpClient: TALWinHttpClient
    InternetOptions = [wHttpIo_REFRESH, wHttpIo_Keep_connection, wHttpIo_No_auto_redirect]
    Left = 48
    Top = 88
  end
end
