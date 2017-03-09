unit Binac1;

{Versions Delphi}

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes, sysutils, util1,Gdos,Ncdef2;

procedure proReset(numF:integer;st:AnsiString);pascal;
procedure proRewrite(numF:integer;st:AnsiString);pascal;
procedure proBlockread(numF:integer;var x;taille:integer;tpn:word;var res:integer);pascal;
procedure proBlockwrite(numF:integer;var x;taille:integer;tpn:word);pascal;
procedure proClose(numF:integer);pascal;
procedure proSeek(numF:integer;n:longint);pascal;
function fonctionFileSize(numF:integer):longint;pascal;
procedure proBlockreadReal(numF:integer;var x;taille:integer;tpn:word;var res:integer);pascal;
procedure proBlockwriteReal(numF:integer;var x;taille:integer;tpn:word);pascal;

IMPLEMENTATION


const
  maxFichierPg=20;
var
  fichierBin:array[1..maxFichierPg] of TfileStream;


procedure open(numF:integer;st:AnsiString;Vreset:boolean);
  begin
    if (numF<1) or (numF>maxFichierPg) then sortieErreur(E_NumFichier);
    if st='' then sortieErreur(E_NomDeFichierIncorrect);

    fichierBin[numF].Free;
    fichierBin[numF]:=nil;

    try
    if Vreset
      then fichierBin[numF]:=TfileStream.create(st,fmOpenReadWrite)
      else fichierBin[numF]:=TfileStream.create(st,fmCreate);

    except
      fichierBin[numF]:=nil;
      sortieErreur('Error opening '+st);
    end;
  end;

procedure proReset(numF:integer;st:AnsiString);
  begin
    open(numF,st,true);
  end;


procedure proRewrite(numF:integer;st:AnsiString);
  begin
    open(numF,st,false);
  end;

procedure controleF(numF:integer);
  begin
    if (numF<1) or (numF>maxFichierPg) then sortieErreur(E_NumFichier);
    if fichierBin[numF]=nil then sortieErreur('File not open');
  end;

procedure proBlockwrite(numF:integer;var x;taille:integer;tpn:word);
begin
  controleF(numF);
  try
  fichierBin[numF].Write(x,taille);
  except
  sortieErreur('BlockWrite Error');
  end;
end;

procedure proBlockread(numF:integer;var x;taille:integer;tpn:word;var res:integer);
begin
  controleF(numF);
  try
  fichierBin[numF].read(x,taille);
  except
  sortieErreur('BlockRead error');
  end;
end;

procedure proClose(numF:integer);
begin
  controleF(numF);
  fichierBin[numF].Free;
  fichierBin[numF]:=nil;
end;

procedure proSeek(numF:integer;n:longint);
begin
  controleF(numF);
  try
  fichierBin[numF].Position:=n;
  except
  sortieErreur('Seek error');
  end;
end;

function fonctionFileSize(numF:integer):longint;
begin
  controleF(numF);
  try
    result:= fichierBin[numF].Size;
  except
    sortieErreur('FileSize error');
  end;
end;

procedure proBlockreadReal(numF:integer;var x;taille:integer;tpn:word;var res:integer);
var
  buf:typeTabFloat1 ABSOLUTE x;
  y:single;
  i:integer;
begin
  controleF(numF);
  with fichierBin[numF] do
  begin
    for i:=1 to taille div 10 do
       if read(y,4)=4 then
          buf[i]:=y;;
  end;
end;

procedure proBlockwriteReal(numF:integer;var x;taille:integer;tpn:word);
  var
    buf:typeTabFloat1 ABSOLUTE x;
    y:single;
    i:integer;
  begin
    controleF(numF);
    with fichierBin[numF] do
    begin
      for i:=1 to taille div 10 do
        begin
          y:=buf[i];
          write(y,4);
        end;
    end;
  end;


end.
