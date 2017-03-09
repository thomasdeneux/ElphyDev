unit Slave;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  util1;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    Vmsg,Vmsg1:integer;
  public
    { Déclarations publiques }
    procedure GetAd(message:Tmessage);
    procedure wndProc(var Message: TMessage); override;


  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.GetAd(message: Tmessage);
begin

end;

procedure Proc;stdCall;
begin
  form1.Label1.Caption:='PROC';
end;

procedure TForm1.wndProc(var Message: TMessage);
begin
  if Message.msg=Vmsg then
  begin
    messageCentral('Result:='+Istr(integer(@proc)));
    Label1.Caption:='GetAD';
    postMessage(HWND_BROADCAST,Vmsg1,integer(@proc),0);
  end
  else inherited;

end;                                           

procedure TForm1.FormCreate(Sender: TObject);
begin
  Vmsg:=RegisterWindowMessage('RTNRN_getAd');
  Vmsg1:=RegisterWindowMessage('RTNRN_setAd');

end;

end.
