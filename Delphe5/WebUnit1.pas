unit WebUnit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OleCtrls, SHDocVw;

type
  TWebForm = class(TForm)
    WebBrowser1: TWebBrowser;
    Panel1: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  WebForm: TWebForm;

implementation

{$R *.dfm}

procedure TWebForm.Button1Click(Sender: TObject);
begin
  WebBrowser1.Navigate('http://www.google.fr/');
end;

end.
