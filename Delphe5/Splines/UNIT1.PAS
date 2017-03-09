unit Unit1;
{
  This program has been designed and is CopyLefted by:

* Han de Bruijn; Systems for Research "A little bit of Physics would be  (===)
* and Education (DTO/SOO), Mekelweg 6  NO Idleness in Mathematics"(HdB) @-O^O-@
* 2628 CD Delft, The Netherlands  http://huizen.dto.tudelft.nl/deBruijn  #/_\#
* E-mail: Han.deBruijn@DTO.TUDelft.NL  Tel: +31 15 27 82751. Fax: 81722   ###

All I ask is to be credited when it is appropriate.
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Splines;

type
  TForm1 = class(TForm)
    Image1: TImage;
    procedure schepping(Sender: TObject);
    procedure MuisOmlaag(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

type
  punt = record
    x : integer;
    y : integer;
  end;
var
  onthou : array[0..1] of punt;
  het : integer;
  nieuw : boolean;
  Lengte : double;

procedure SchermSchoon;
{
  Clear graphics screen
}
begin
  Form1.Image1.Canvas.Brush.Color := clWhite;
  with Form1.Image1 do
    Canvas.Fillrect(rect(0,0,Width,Height));
  Form1.Image1.Canvas.Pen.Color := clSilver;
end;

procedure TForm1.schepping(Sender: TObject);
{
  Initializer
}
begin
  Screen.Cursor := crDefault;
  SchermSchoon;
  Splines.Test;
  Splines.Definitie(Form1.Image1);
  Form1.Image1.Cursor := crCross;
  nieuw := true;
  Lengte := 0;
end;

procedure TForm1.MuisOmlaag(Sender: TObject; Button: TMouseButton;
                            Shift: TShiftState; X, Y: Integer); {
  Mouse event handler
  ------------------- }
begin
{ Place a dot: }
  Form1.Image1.Canvas.Ellipse(X-1,Y-1,X+1,Y+1);
{ New curve, or prolongation of existing one: }
  if nieuw then Form1.Image1.Canvas.MoveTo(X,Y)
           else Form1.Image1.Canvas.LineTo(X,Y);
{ Determine the exact length: }
  Lengte := Lengte + Splines.BuigLijn(X,Y,nieuw);
{ Start a new curve: }
  nieuw := false;
{ Remember first two points: }
  if het < 2 then
  begin
    onthou[het].x := X;
    onthou[het].y := Y;
    het := het + 1;
  end;
{ Curve prolongation: }
  if Button = mbLeft then Exit;
{ Right Mouse Button 
  means End of curve: }
  X := onthou[0].x;
  Y := onthou[0].y;
  Form1.Image1.Canvas.LineTo(X,Y);
  Lengte := Lengte + Splines.BuigLijn(X,Y,nieuw);
  X := onthou[1].x;
  Y := onthou[1].y;
{ Finishing touch: }
  Lengte := Lengte + Splines.BuigLijn(X,Y,nieuw);
  nieuw := true;
  Writeln('Length = ',Lengte);
  Lengte := 0;
  het := 0;
end;

end.
