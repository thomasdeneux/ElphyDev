unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls;

type
  TFormTest = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    Display1: TMenuItem;
    procedure BOKClick(Sender: TObject);
    procedure BcancelClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FormTest: TFormTest;

implementation

{$R *.dfm}

procedure TFormTest.BOKClick(Sender: TObject);
begin
  close;
end;

procedure TFormTest.BcancelClick(Sender: TObject);
begin
  label1.font.Color:= clRed;
end;

end.
