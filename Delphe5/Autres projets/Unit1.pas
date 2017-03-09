unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls;



type
  TForm1 = class(TForm)
    MainMenu: TMainMenu;
    Fichier: TMenuItem;
    Affichage: TMenuItem;
    Saisie: TMenuItem;
    Quitter: TMenuItem;
    PaintBox1: TPaintBox;
    procedure QuitterClick(Sender: TObject);
    procedure SaisieClick(Sender: TObject);
    procedure AffichageClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;


implementation

uses Unit2, classmseq;

{$R *.DFM}

procedure TForm1.QuitterClick(Sender: TObject);
begin
 close;
end;

procedure TForm1.SaisieClick(Sender: TObject);
begin
 Dialogue.showModal;
end;

procedure TForm1.AffichageClick(Sender: TObject);
var
  i:cardinal;
  j:integer;

begin
  for i:=1 to mseq.l do
                     begin
                     j:=integer(mseq.R^[i]);
                     Paintbox1.canvas.textout(10+i, 40, inttostr(j));
                     end;
end;

end.
