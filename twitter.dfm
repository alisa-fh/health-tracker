object form_twitter: Tform_twitter
  Left = 0
  Top = 0
  Caption = 'form_twitter'
  ClientHeight = 522
  ClientWidth = 1070
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 320
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 455
    Top = 24
    Width = 75
    Height = 25
    Caption = 'tweet'
    TabOrder = 1
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 24
    Top = 304
    Width = 845
    Height = 184
    DataSource = DataSource1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DBNavigator1: TDBNavigator
    Left = 136
    Top = 8
    Width = 136
    Height = 25
    DataSource = DataSource1
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    ConfirmDelete = False
    TabOrder = 3
  end
  object RESTClientPOSTpan: TRESTClient
    Authenticator = OAuth1AuthenticatorPOST
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'https://api.twitter.com'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 48
    Top = 16
  end
  object RESTRequestPOST: TRESTRequest
    Client = RESTClientPOSTpan
    Method = rmPOST
    Params = <
      item
        name = 'status'
        Value = 'test...send tweet...'
      end>
    Resource = '1.1/statuses/update.json'
    Response = RESTResponsePOST
    SynchronizedEvents = False
    Left = 56
    Top = 72
  end
  object RESTResponsePOST: TRESTResponse
    Left = 64
    Top = 128
  end
  object OAuth1AuthenticatorPOST: TOAuth1Authenticator
    AccessToken = '810435181844791297-AB0HIPuk3Gk664o3Q769TbhmKrIAwBq'
    AccessTokenSecret = 'tl4kyKsGTm8WkVFHEfZEvx12RhaptbCWVdq4Y56m1rguD'
    ConsumerKey = 'UskAmRV4To7e2vQySNK0sFWyd'
    ConsumerSecret = 'seoZehGfyjzYBHsoQcNiT7Vsyxf75SwFDk25kbNTb3n9evQjfh'
    Left = 48
    Top = 200
    ConsumerSecrect = 'seoZehGfyjzYBHsoQcNiT7Vsyxf75SwFDk25kbNTb3n9evQjfh'
  end
  object RESTClientGET: TRESTClient
    Authenticator = OAuth1AuthenticatorGET
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'https://api.twitter.com/1.1/statuses/home_timeline.json'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 280
    Top = 40
  end
  object RESTRequestGET: TRESTRequest
    Client = RESTClientGET
    Params = <>
    Response = RESTResponseGET
    SynchronizedEvents = False
    Left = 304
    Top = 96
  end
  object RESTResponseGET: TRESTResponse
    ContentType = 'application/json'
    Left = 304
    Top = 144
  end
  object OAuth1AuthenticatorGET: TOAuth1Authenticator
    AccessToken = '929912508487426048-bjVhqmHrkcNPMpJLXk6qQuxHX2RIZNn'
    AccessTokenSecret = '7S0p4r0ziaEsctZuS5rJTttBwVqKO2gKyaCZldEsw1w29'
    ConsumerKey = 'uuivOdd4cGORi65OA2ADPznkC'
    ConsumerSecret = '2AXljJjq9IFNB4iGFXoE7tg14NzsRjfERmt9AfcSPl43A8kw71'
    Left = 304
    Top = 184
    ConsumerSecrect = '2AXljJjq9IFNB4iGFXoE7tg14NzsRjfERmt9AfcSPl43A8kw71'
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Dataset = FDMemTable1
    FieldDefs = <>
    Response = RESTResponseGET
    Left = 432
    Top = 72
  end
  object FDMemTable1: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 440
    Top = 152
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 440
    Top = 216
  end
end
