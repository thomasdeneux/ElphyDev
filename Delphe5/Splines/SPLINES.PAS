Unit Splines;
{
  This program has been designed and is CopyLefted by:

* Han de Bruijn; Systems for Research "A little bit of Physics would be  (===)
* and Education (DTO/SOO), Mekelweg 6  NO Idleness in Mathematics"(HdB) @-O^O-@
* 2628 CD Delft, The Netherlands  http://huizen.dto.tudelft.nl/deBruijn  #/_\#
* E-mail: Han.deBruijn@DTO.TUDelft.NL  Tel: +31 15 27 82751. Fax: 81722   ###

All I ask is to be credited when it is appropriate.
}
interface

Uses Controls, Graphics, Extctrls;

procedure Test;
procedure Definitie(Scherm : TImage);
function BuigLijn(X,Y : integer ; start : boolean) : double;

implementation

type
  vektor = record
    x : double;
    y : double;
  end;

const
  Grens = 7;
var
{ Initial 
  position,
  velocity,
  acceleration: }
  s,v,a : vektor;
{ Control points of spline: }
  z,C : array[0..2] of vektor;
{ Recursion depth: }
  Diepst : integer;
{ Upper / Lower bounds for Length: }
  boven,onder : array[0..Grens] of double;
{ Computer Graphics: }
  grafisch : boolean;
  Beeld : TImage;
{ Increments: }
  t : integer;

procedure Omzet;
{
  Translate Geometry into Analysis
}
begin
  s.x := (z[0].x + 2*z[1].x + z[2].x)/4;
  s.y := (z[0].y + 2*z[1].y + z[2].y)/4;
  v.x := z[2].x - z[0].x;
  v.y := z[2].y - z[0].y;
  a.x := 2*(z[0].x - 2*z[1].x + z[2].x);
  a.y := 2*(z[0].y - 2*z[1].y + z[2].y);
end;

function L(t : double) : double;
{
  Exact Length of a Conic Spline
  ------------------------------
  (see accompanying TeX document)
}
var
  La,D,w,r,I : double;
begin
  La := sqr(a.x) + sqr(a.y);
  L := sqrt(sqr(v.x) + sqr(v.y)) * t;
  if La = 0 then Exit;
  D := v.x*a.y - v.y*a.x;
  I := a.x*v.x + a.y*v.y;
  L := sqrt(La) * (sqr(t)/2 + I*t/La);
  if D = 0 then Exit;
  w := (La*t + I)/D;
  La := La*sqrt(La);
  r := sqrt(1+sqr(w));
  L := sqr(D)/La * (w*r + ln(w+r)) / 2;
end;

procedure NeemWat;
{
  Some points
}
var
  k : integer;
begin
  for k := 0 to 2 do
  begin
    z[k].x := Random;
    z[k].y := Random;
  end;
end;

procedure Schrijf(p : array of vektor);
{
  Writeup
}
var
  k : integer;
begin
  if Length(p) <> 3 then Exit;
  for k := 0 to 2 do
    Writeln(' (',p[k].x:8:5,',',p[k].y:8:5,')');
  Writeln;
end;

procedure Voorbeeld(keer : integer);
{
  Example
}
var
  k : integer;
begin
  for k := 1 to keer do
  begin
    NeemWat;
    Omzet;
    Writeln(L(1/2)-L(-1/2));
  end;
  Schrijf(z);
end;

function H(p,q : vektor) : double;
{
  Distance between two points
}
begin
  H := sqrt(sqr(p.x-q.x) + sqr(p.y-q.y));
end;

procedure Halveer(p : array of vektor ; diep : integer);
{
  Recursive procedure for defining a spline
}
var
  q : array[0..2] of vektor;
  x,y : integer;
begin
{ Erroneous input: }
  if Length(p) <> 3 then Exit;
{ End of recursion: }
  if diep > Diepst then Exit;

  if not grafisch then
  begin
    Write(diep,' ');
  { Upper and Lower bounds on Length: }
    boven[diep] := boven[diep] + H(p[0],p[1]) + H(p[1],p[2]);
    onder[diep] := onder[diep] + H(p[0],p[2]);
  end;

  if diep = Diepst then
  if grafisch then
  begin
    x := Round(p[2].x);
    y := Round(p[2].y);
    Beeld.Canvas.LineTo(x,y);
  end;

{ Left half of spline: }
  q[0] := p[0];
  q[1].x := (p[0].x + p[1].x)/2;
  q[1].y := (p[0].y + p[1].y)/2;
  q[2].x := (p[0].x + 2*p[1].x + p[2].x)/4;
  q[2].y := (p[0].y + 2*p[1].y + p[2].y)/4;
{ Recursion: }
  Halveer(q,diep+1);

{ Right half of spline: }
  q[0] := q[2];
  q[1].x := (p[2].x + p[1].x)/2;
  q[1].y := (p[2].y + p[1].y)/2;
  q[2] := p[2];
{ Recursion: }
  Halveer(q,diep+1);

{ Pieces will come out
  in the right order ! }
end;

procedure Recursief(plotten : boolean);
{
  Test on Recursion
}
var
  k : integer;
  berekend : double;
begin
  for k := 0 to Grens do
  begin
    onder[k] := 0;
    boven[k] := 0;
  end;
  Diepst := Grens;
  Halveer(z,0);
  Writeln;
{ Exact Length in between
  Upper and Lower bounds: }
  berekend := L(1/2)-L(-1/2);
  for k := 0 to Grens do
    Writeln(k,' : ',onder[k],' < ',berekend,' < ',boven[k]);
end;

procedure Test;
begin
  Voorbeeld(3);
  Recursief(false);
end;

procedure Definitie;
{
  Image Definition
}
begin
  Beeld := Scherm;
  grafisch := true;
end;

function log2(n : integer) : integer;
{
  Logarithm base 2
  ---------------- }
var
  k, L : byte;
begin
  log2 := 0;
  if n <= 0 then Exit;
  for k := 1 to 32 do
  begin
    n := n div 2 ; L := k;
    if n = 0 then Break ;
  end;
  log2 := L;
end;

function BuigLijn;
{
  Draw the Conic Splines
  ----------------------
  Determine total Length
}
var
  m,n : integer;
  hoog,laag : double;
  px,py : integer;

  function half(a,b : vektor) : vektor;
  begin
    half.x := (a.x + b.x)/2;
    half.y := (a.y + b.y)/2;
  end;

begin
  BuigLijn := 0;
  if start then t := 0;
  m := (t mod 3);
{ Store three
  successive points: }
  C[m].x := X;
  C[m].y := Y;
  t := t + 1;
  if t < 3 then Exit;

{ Spline Control Points: }
  m := ((t-3) mod 3);
  n := ((t-2) mod 3);
  z[0] := half(C[m],C[n]);
  z[1] := C[n];
  m := ((t-1) mod 3);
  z[2] := half(C[n],C[m]);

{ Bound on number of points needed: }
  hoog := H(z[0],z[1]) + H(z[1],z[2]);
  laag := H(z[0],z[2]);
  Diepst := log2(Round((hoog+laag)/2));
{ Writeln('Depth = ',Diepst); }
  px := Round(z[0].x);
  py := Round(z[0].y);
  Beeld.Canvas.MoveTo(px,py);
  Beeld.Canvas.Pen.Color := clRed;
{ Recursion: }
  Halveer(z,0);
  Beeld.Canvas.MoveTo(X,Y);
  Beeld.Canvas.Pen.Color := clSilver;

{ Length calculation: }
  Omzet;
  BuigLijn := abs(L(1/2)-L(-1/2));
end;

end.
