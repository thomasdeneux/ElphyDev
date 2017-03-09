unit txtac1;

{ Version Delphi}

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Gdos,Ncdef2;



procedure proOpenText(numF:integer;st:AnsiString;lect:boolean);pascal;
procedure proAppendText(numF:integer;st:AnsiString);pascal;
procedure proWriteText(numF:integer;st:AnsiString);pascal;
procedure proWritelnText(numF:integer;st:AnsiString);pascal;

procedure proReadlnText(numF:integer;var st:AnsiString);pascal;
procedure proReadlnText_1(numF:integer;var st:PgString;sz:integer);pascal;

procedure proCloseText(numF:integer);pascal;
function fonctionEofText(numF:integer):boolean;pascal;

IMPLEMENTATION

type
  typeModeFichier=(ecriture,Ajout,Lecture);
  typeFichierTxt=record
                   f:text;
                   {ouvert:boolean;}
                   mode:typeModeFichier;
                   {nom:pathStr;}
                 end;


const
  maxFichierPg=20;
var
  fichierTxt:array[1..maxFichierPg] of ^typeFichierTxt;

procedure proOpenText(numF:integer;st:AnsiString;lect:boolean);
  begin
    if (numF<1) or (numF>maxFichierPg) then sortieErreur(E_NumFichier);
    if st='' then sortieErreur(E_NomDeFichierIncorrect);

    if fichierTxt[numF]<>nil then
      with fichierTxt[numF]^ do {$I-} close(f) {$I+}
      else new(fichierTxt[numF]);


    with fichierTxt[numF]^ do
    try
    begin
      if lect
        then mode:=lecture
        else mode:=ecriture;
      assign(f,st);
      if lect
        then reset(f)
        else rewrite(f);
    end;
    except
    {$I-} close(f); {$I+}
    dispose(fichierTxt[numF]);
    fichierTxt[numF]:=nil;
    sortieErreur('Unable to open file '+st);
    end;
  end;


procedure proAppendText(numF:integer;st:AnsiString);
  begin
    if (numF<1) or (numF>maxFichierPg) then sortieErreur(E_NumFichier);
    if st='' then sortieErreur(E_NomDeFichierIncorrect);

    if fichierTxt[numF]<>nil then
      with fichierTxt[numF]^ do {$I-}close(f) {$I+}
      else new(fichierTxt[numF]);

    new(fichierTxt[numF]);
    with fichierTxt[numF]^ do
    begin
      mode:=ecriture;
      try
      assign(f,st);
      append(f);
      except
      sortieErreur('Unable to Append File '+st);
      end;
    end;
  end;

procedure proWriteText(numF:integer;st:AnsiString);
  begin
    if (numF<1) or (numF>maxFichierPg) then sortieErreur(E_NumFichier);
    if fichierTxt[numF]=nil then sortieErreur(E_FichierNonOuvert);

    with fichierTxt[numF]^ do
    begin
      if (mode<>ecriture) then sortieErreur(E_FichierNonOuvert);
      try
      write(f,st);
      except
      sortieErreur('WriteText error');
      end;
    end;
  end;

procedure proWritelnText(numF:integer;st:AnsiString);
  begin
    if (numF<1) or (numF>maxFichierPg) then sortieErreur(E_NumFichier);
    if fichierTxt[numF]=nil then sortieErreur(E_FichierNonOuvert);

    with fichierTxt[numF]^ do
    begin
      if (mode<>ecriture) then sortieErreur(E_FichierNonOuvert);
      try
      writeln(f,st);
      except
      sortieErreur('WritelnText error');
      end;
    end;
  end;

procedure proReadlnText(numF:integer;var st:AnsiString);
begin
  if (numF<1) or (numF>maxFichierPg) then sortieErreur(E_NumFichier);
  if fichierTxt[numF]=nil then sortieErreur(E_FichierNonOuvert);

  with fichierTxt[numF]^ do
  begin
    if (mode<>lecture) then sortieErreur(E_FichierNonOuvert);
    try
      readln(f,st);
    except
      sortieErreur('ReadlnText error');
    end;
  end;
end;


procedure proReadlnText_1(numF:integer;var st:PgString;sz:integer);
  var
    st1:shortstring absolute st;
    st0:shortString;

  begin
    if (numF<1) or (numF>maxFichierPg) then sortieErreur(E_NumFichier);
    if fichierTxt[numF]=nil then sortieErreur(E_FichierNonOuvert);

    with fichierTxt[numF]^ do
    begin
      if (mode<>lecture) then sortieErreur(E_FichierNonOuvert);
      try
        readln(f,st0);
        st1:=copy(st0,1,sz-1);
      except
        sortieErreur('ReadlnText error');
      end;
    end;
  end;

procedure proCloseText(numF:integer);
  begin
    if (numF<1) or (numF>maxFichierPg) then sortieErreur(E_NumFichier);
    if fichierTxt[numF]=nil then sortieErreur(E_fichierNonOuvert);

    with fichierTxt[numF]^ do
    begin
      {$I-} close(f); {$I+}
    end;
    dispose(fichierTxt[numF]);
    fichierTxt[numF]:=nil;
  end;

function fonctionEofText(numF:integer):boolean;
  begin
    if (numF<1) or (numF>maxFichierPg) then sortieErreur(E_NumFichier);

    if fichierTxt[numF]=nil then sortieErreur(E_fichierNonOuvert);
    with fichierTxt[numF]^ do
    begin
      try
      result:=eof(f);
      except
      sortieErreur('eof error');
      end;
    end;
  end;


end.
