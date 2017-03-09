unit dibForm0;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,

  dibG;

type
  TDibForm = class(TForm)
    procedure FormPaint(Sender: TObject);
  private
    { D�clarations priv�es }
    dib0:Tdib;
  public
    { D�clarations publiques }
    procedure showDib(dib:Tdib);
  end;

var
  DibForm: TDibForm;

implementation

{$R *.dfm}

procedure TdibForm.showDib(dib:Tdib);
begin
  Clientwidth:=dib.Width;
  ClientHeight:=dib.height;

  dib0:=dib;
  showModal;
end;


procedure TDibForm.FormPaint(Sender: TObject);
begin
  canvas.Draw(0,0,dib0);
end;

end.
