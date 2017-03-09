unit Dutil1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1;

{Ces 3 fonctions permettent de ranger et retirer des sous-chaînes dans une chaîne,
les sous-chaînes étant séparées par des '|' .
}

function getItemSt(st:AnsiString;num:integer):AnsiString;
{renvoie la sous-chaînes de rang num (de 1 à n) }

function nbItemSt(st:AnsiString):integer;
{renvoie le nombre de sous-chaînes}

function addItemSt(st1,st:AnsiString):AnsiString;
{ajoute une sous-chaîne au début de st . Si la sous-chaîne existe déjà, elle ne sera
pas répétée. Deux sous-chaînes sont égales si elles sont identiques une fois converties en
majuscules.
}

implementation

function getItemSt(st:AnsiString;num:integer):AnsiString;
var
  i,k:integer;
begin
  k:=0;
  while k<num do
  begin
    i:=pos('|',st);
    inc(k);
    if i>0
      then result:=copy(st,1,i-1)
      else result:=st;
    if (i=0) and (result='') then exit;
    delete(st,1,i);
  end;
end;

function nbItemSt(st:AnsiString):integer;
var
  i:integer;
begin
  result:=1;
  for i:=1 to length(st) do
    if st[i]='|' then inc(result);
end;

function addItemSt(st1,st:AnsiString):AnsiString;
var
  i:integer;
  stX,stM:AnsiString;

begin
  result:=st1;

  stM:=Fmaj(st1);

  for i:=1 to nbItemSt(st) do
    begin
      stX:=getItemSt(st,i);
      if Fmaj(stX)<>stM then result:=result+'|'+stX;
    end;
end;



end.
 
