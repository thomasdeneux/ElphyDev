unit matrix0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,tbe0;

type
  typeMatrice=TdataTbB;

procedure MatInv( t:typeMatrice;var det:float);
procedure MatProd( t1,t2,t:typeMatrice);
function MatAff( t:typeMatrice;champ,deci:integer):AnsiString;
Procedure MatCopy( t1,t2:typeMatrice);

implementation


{  Calcul de l'inverse d'une matrice carrée symétrique de dimension n }
{  renvoie det=0 si la matrice n'est pas inversible, sinon det=1      }
{  n'utilise aucune variable globale }

{ Rem: il semble que la procédure fonctionne quand la matrice n'est pas
  symétrique }

procedure MatInv( t:typeMatrice;var det:float);
var
  n:integer;
  i,j,k,l:integer;
  Ik,Jk:array of integer;
  amax,s:float;
  i0,j0:integer;
begin
  n:=t.nblig;
  if n<>t.nbcol then exit;
  i0:=t.Imin;
  j0:=t.Jmin;

  setLength(IK,n);
  setLength(JK,n);

  det:=1;
  for k:=0 to n-1 do
    begin
                       { trouver le plus grand élément du tableau }
      amax:=0;
      for i:=k to n-1 do
        for j:=k to n-1 do
          if abs(amax)<=abs(t[i0+i,j0+j]) then
            begin
              amax:=t[i0+i,j0+j];
              Ik[k]:=i;
              Jk[k]:=j;
            end;

                       { intervertir rangées et colonnes pour avoir amax }
                       { dans t[k,k] }
      if amax=0 then
        begin
          det:=0;
          exit;
        end;
      i:=Ik[k];
      if i>k then
        for j:=0 to n-1 do
          begin
            s:=t[i0+k,j0+j];
            t[i0+k,j0+j]:=t[i0+i,j0+j];
            t[i0+i,j0+j]:=-s;
          end;
      j:=Jk[k];
      if j>k then
        for i:=0 to n-1 do
          begin
            s:=t[i0+i,j0+k];
            t[i0+i,j0+k]:=t[i0+i,j0+j];
            t[i0+i,j0+j]:=-s;
          end;
                       { accumuler les éléments de la matrice inverse }
      for i:=0 to n-1 do
        if i<>k then t[i0+i,j0+k]:=-t[i0+i,j0+k]/amax;
      for i:=0 to n-1 do
        for j:=0 to n-1 do
          if (i<>k) and (j<>k) then t[i0+i,j0+j]:=t[i0+i,j0+j]+t[i0+i,j0+k]*t[i0+k,j0+j];

      for j:=0 to n-1 do
        if j<>k then t[i0+k,j0+j]:=t[i0+k,j0+j]/amax;
      t[i0+k,j0+k]:=1.0/amax;
    end;
                       { remettre la matrice en ordre }
    for l:=0 to n-1 do
      begin
        k:=n-l-1;
        j:=Ik[k];
        if j>k then
          for i:=0 to n-1 do
            begin
              s:=t[i0+i,j0+k];
              t[i0+i,j0+k]:=-t[i0+i,j0+j];
              t[i0+i,j0+j]:=s;
            end;
        i:=Jk[k];
        if i>k then
          for j:=0 to n-1 do
            begin
              s:=t[i0+k,j0+j];
              t[i0+k,j0+j]:=-t[i0+i,j0+j];
              t[i0+i,j0+j]:=s;
            end;
      end;
end;

procedure MatProd( t1,t2,t:typeMatrice);
var
  i,j,k:integer;
  w:double;
begin
  for i:=t1.Imin to t1.Imax do
  for j:=t1.Jmin to t1.Jmax do
    begin
      w:=0;
      for k:=t1.Jmin to t1.Jmax do w:=w+t1[i,k]*t2[k,j];
      t[i,j]:=w;
    end;
end;

function MatAff( t:typeMatrice;champ,deci:integer):AnsiString;
var
  i,j,n:integer;
begin
  result:='';
  n:=t.nblig;
  for j:=t.Jmin to t.Jmax do
  begin
    for i:=t.Imin to t.Imax do
      result:=result+' '+Estr1(t[i,j],champ,deci);
    result:=result+crlf;
  end;
end;

Procedure MatCopy( t1,t2:typeMatrice);
var
  i,j,n:integer;
begin
  for i:=t1.Imin to t1.Imax do
  for j:=t1.Jmin to t1.Jmax do
    t2[i,j]:=t1[i,j];
end;


end.
