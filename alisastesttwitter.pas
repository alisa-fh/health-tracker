unit alisastesttwitter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IPPeerClient, Vcl.StdCtrls, REST.Client,
  REST.Authenticator.OAuth, Data.Bind.Components, Data.Bind.ObjectScope,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter;

type
  TForm1 = class(TForm)
    RESTClientPOSTpan: TRESTClient;
    RESTRequestPOST: TRESTRequest;
    RESTResponsePOST: TRESTResponse;
    OAuth1AuthenticatorPOST: TOAuth1Authenticator;
    Edit1: TEdit;
    Button1: TButton;
    RESTClientGET: TRESTClient;
    RESTRequestGET: TRESTRequest;
    RESTResponseGET: TRESTResponse;
    OAuth1AuthenticatorGET: TOAuth1Authenticator;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
RESTRequestPOST.Params.AddItem('status', edit1.Text);
RESTRequestPOST.Execute;

RESTRequestGET.Execute;

Screen.Cursor:= crDefault;
end;

end.
