unit TestForm1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DisplayFrame1,

  util1, Menus;

type
  TTestForm = class(TForm)
    TDispFrame1: TDispFrame;
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    Coordinates1: TMenuItem;
    ColorDialog1: TColorDialog;
    Color1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Coordinates1Click(Sender: TObject);
    procedure Color1Click(Sender: TObject);
  private
    { Déclarations privées }
    tab:array[0..999] of single;
  public
    { Déclarations publiques }
  end;

var
  TestForm: TTestForm;

implementation

{$R *.dfm}

procedure TTestForm.FormCreate(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to 999 do tab[i]:=100*sin(2*pi/100*i);
  Tdispframe1.InstallArray(@tab,g_single,0,999);
end;

procedure TTestForm.Coordinates1Click(Sender: TObject);
begin
  Tdispframe1.coo;
end;

procedure TTestForm.Color1Click(Sender: TObject);
begin
  ColorDialog1.Color:=Tdispframe1.color0;
  if ColorDialog1.execute then
    begin
      Tdispframe1.color0:=ColorDialog1.Color;
      Tdispframe1.invalidate;
    end;
end;

end.
