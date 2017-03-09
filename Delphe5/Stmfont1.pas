unit stmFont1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses graphics,
     util1,stmdef,stmObj;


{ Gestion de l'objet PG2 Tfont

  font est un objet Delphi Tfont

  Rappel: quand l'objet est une propriété d'un autre objet, il n'est pas nécessaire
  d'utiliser var pu:typeUO
  Il faut que la fonction owner_font renvoie directement un Tfont
}

procedure proTfont_Name(st:AnsiString;font:Tfont);pascal;
function fonctionTfont_Name(font:Tfont):AnsiString;pascal;

procedure proTfont_Size(n:smallint;font:Tfont);pascal;
function fonctionTfont_Size(font:Tfont):smallint;pascal;

procedure proTfont_Color(n:integer;font:Tfont);pascal;
function fonctionTfont_Color(font:Tfont):integer;pascal;

procedure proTfont_Style(n:smallint;font:Tfont);pascal;
function fonctionTfont_Style(font:Tfont):smallint;pascal;



implementation


procedure proTfont_Name(st:AnsiString;font:Tfont);
begin
  if assigned(font) then font.name:=st;
end;

function fonctionTfont_Name(font:Tfont):AnsiString;
begin
  if assigned(font) then result:=font.name;
end;


procedure proTfont_Size(n:smallint;font:Tfont);
begin
  if assigned(font) then font.size:=n;
end;

function fonctionTfont_Size(font:Tfont):smallint;
begin
  if assigned(font) then result:=font.size;
end;


procedure proTfont_Color(n:integer;font:Tfont);
begin
  if assigned(font) then font.color:=n;
end;

function fonctionTfont_Color(font:Tfont):integer;
begin
  if assigned(font) then result:=font.Color;
end;

procedure proTfont_Style(n:smallint;font:Tfont);
var
  sty:TFontStyles;
begin
  if assigned(font) then
  begin
    sty:=[];
    if n and 1<>0 then sty:=sty+[fsBold];
    if n and 2<>0 then sty:=sty+[fsItalic];
    if n and 4<>0 then sty:=sty+[fsUnderLine];
    if n and 8<>0 then sty:=sty+[fsStrikeOut];

    font.style:=sty;
  end;
end;

function fonctionTfont_Style(font:Tfont):smallint;
var
  n:integer;
begin
  if assigned(font) then
  with font do
  begin
    n:=0;
    if fsBold in style then inc(n);
    if fsItalic in style then inc(n,2);
    if fsUnderLine in style then inc(n,4);
    if fsStrikeOut in style then inc(n,8);

    result:=n;
  end;
end;




end.
