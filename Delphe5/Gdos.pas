unit Gdos;           { Version DELPHI }


INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}



uses classes,sysutils,util1,debug0;



procedure  Fsplit(st:AnsiString;var chemin:AnsiString; var nom:AnsiString; var ext:AnsiString);


function NomDuFichier(st:AnsiString):AnsiString;
function NomDuFichier1(st:AnsiString):AnsiString;
function NouvelleExtension(st:AnsiString;ext:AnsiString):AnsiString;
function cheminDuFichier(st:AnsiString):AnsiString;
function ExtensionDuFichier(st:AnsiString):AnsiString;


function RepertoireExiste(st:AnsiString):boolean;
function FichierExiste(st:AnsiString):boolean;

function TrouverChemin(nom:AnsiString):AnsiString;
  { Cherche le chemin d'accès au fichier
      -dans le répertoire courant
      -dans le répertoire du programme exécuté
    Nom contient nom+extension ( 12 caractŠres ).
    le nom complet est TrouverChemin(nom)+nom.
    Si le chemin n'est pas trouvé, TrouverChemin='!'  }

function TrouverFichier(nom,parent:AnsiString):AnsiString;
  { si Nom existe, alors TrouverFichier=nom
    sinon on cherche dans le répertoire de parent.
    Si on ne trouve pas, on appelle TrouverChemin.
    Enfin, si on ne trouve pas du tout, TrouverChemin=''.
    La valeur renvoyée est un nom de fichier complet.

    Le PATH n'est plus utilisé dans les deux fonctions précédentes
  }

function espaceDisque(st:AnsiString):intG;
  { st est un fichier que l'on souhaite ‚crire ou bien le d‚but du chemin
    d'accŠs. La fonction renvoie l'espace disponible sur le disque }

function EffacerFichier(st:AnsiString):boolean;
function RenommerFichier(st1,st2:AnsiString):boolean;




function copierFichier(st1,st2:AnsiString):boolean;


procedure DecomposerNomFichier( st:AnsiString;var chemin:AnsiString;
                                var nom,numero:AnsiString;
                                var extension:AnsiString);

function fichierSuivant(st1:AnsiString):AnsiString;
function fichierPrecedent(st1:AnsiString):AnsiString;
function PremierNomDisponible(st:AnsiString):AnsiString;

function getTMPname(stg:AnsiString):AnsiString;
procedure resetTMPfiles(stg:AnsiString);

function GfileDateTime(stf:AnsiString):TdateTime;

function FonctionFileAge(st: AnsiString):TdateTime;pascal;
function FonctionFileAge_1(st: AnsiString; mode:integer):TdateTime;pascal;


procedure proSplitFileName( st:AnsiString; var chemin:AnsiString;var nom:AnsiString;var extension:AnsiString);pascal;
procedure proSplitFileName_1( st:AnsiString;
                            var chemin:PgString;sz1:integer;
                            var nom:PgString; sz2:integer;
                            var extension:PgString;sz4:integer);pascal;


procedure proSplitFileNameEx( st:AnsiString;var chemin,nom:AnsiString;var numero:integer;var extension:AnsiString);pascal;
procedure proSplitFileNameEx_1( st:AnsiString;
                              var chemin:PgString;sz1:integer;
                              var nom:PgString; sz2:integer;
                              var numero:integer;
                              var extension:PgString;sz4:integer);pascal;


function fonctionNextFileEx(st:AnsiString):AnsiString;pascal;
function fonctionPreviousFileEx(st:AnsiString):AnsiString;pascal;

function compareFiles(st1,st2:AnsiString):integer;
{ Compare deux fichiers de petite taille: ils doivent tenir en mémoire
  Renvoie 0  si les fichiers sont identiques
          -1 si leurs tailles sont différentes
          n  si le premier octet différent est à l'indice n
          -2 si erreur
}

IMPLEMENTATION

uses ncdef2;

procedure  Fsplit(st:AnsiString;var chemin:AnsiString;
                             var nom:AnsiString;
                             var ext:AnsiString);
var
  k:integer;
begin
  ext:=extractFileExt(st);
  chemin:=extractFilePath(st);
  nom:=extractFileName(st);

  k:=length(nom)-length(ext)+1;
  if k>0 then delete(nom,k,100);
end;



function RepertoireExiste(st:AnsiString):boolean;
begin
  result:=DirectoryExists(st);
end;

function FichierExiste(st:AnsiString):boolean;
begin
  result:=fileExists(st);
end;



function NomDuFichier(st:AnsiString):AnsiString;
begin
  result:=extractFileName(st);
end;

function NomDuFichier1(st:AnsiString):AnsiString;
begin
  result:=extractFileName(st);
  if pos('.',result)>0 then delete(result,pos('.',result),20);
end;


function cheminDuFichier(st:AnsiString):AnsiString;
begin
  result:=extractFilePath(st);
end;

function ExtensionDuFichier(st:AnsiString):AnsiString;
begin
  result:=extractFileExt(st);
end;

function TrouverChemin(nom:AnsiString):AnsiString;
  var
    rep1:AnsiString;
    name1:AnsiString;
    ext1:AnsiString;
  begin
    trouverChemin:='';
    if fichierExiste(nom) then exit;

    Fsplit(paramstr(0),rep1,name1,ext1);
    if fichierExiste(rep1+nom) then
      begin
        trouverChemin:=rep1;
        exit;
      end;

    trouverChemin:='!';

  end;

function TrouverFichier(nom,parent:AnsiString):AnsiString;
  var
    st:AnsiString;
  begin
    if not fichierExiste(nom) then
      begin
        st:=cheminDuFichier(parent)+nomDufichier(nom);
        if fichierExiste(st) then
          begin
            trouverFichier:=st;
            exit;
          end
      end
    else trouverFichier:=nom;
  end;

function espaceDisque(st:AnsiString):intG;
  var
    vol:byte;
  begin
    st:=Fmaj(st);
    if st[2]=':' then vol:=ord(st[1])-ord('A')+1
                 else vol:=0;
    EspaceDisque:=diskfree(vol);
  end;

function EffacerFichier(st:AnsiString):boolean;
begin
  result:=deleteFile(st);
end;

function RenommerFichier(st1,st2:AnsiString):boolean;
begin
  result:=renameFile(st1,st2);
end;

function NouvelleExtension(st:AnsiString;ext:AnsiString):AnsiString;
var
  st1:AnsiString;
  k:integer;
begin
  st1:=extractFileExt(st);
  k:=length(st)-length(st1)+1;
  if k>0 then delete(st,k,100);  // le point est aussi supprimé

  if (length(ext)>0) and (ext[1]<>'.') then ext:='.'+ext;
  result:=st+ext;
end;




function copierFichier(st1,st2:AnsiString):boolean;
var
  f1,f2: TfileStream;
begin
  result:=false;

  f1:=nil;
  f2:=nil;
  try
  f1:=TfileStream.create(st1,fmOpenRead);
  f2:=TfileStream.create(st2,fmCreate);

  f2.CopyFrom(f1,f1.size);
  f2.Free;
  f2:=nil;
  f1.Free;
  result:=true;

  except
  f2.free;
  f1.Free;
  end;
end;

procedure DecomposerNomFichier( st:AnsiString;var chemin:AnsiString;
                                var nom,numero:AnsiString;
                                var extension:AnsiString);
  var
    i:smallint;
    nom0:AnsiString;
  begin
    {supespace(st);}
    st:=Fmaj(st);
    Fsplit(st,chemin,nom0,extension);
    i:=length(nom0);
    while (i>0) and (nom0[i] in ['0'..'9']) do dec(i);
    if i>0 then nom:=copy(nom0,1,i)
           else nom:='';
    if i<length(nom0) then numero:=copy(nom0,i+1,length(nom0)-i)
                      else numero:='';
  end;


function fichierSuivant(st1:AnsiString):AnsiString;
  var
    code:integer;
    n0,n1,n2:longint;
    chemin1:AnsiString;
    nom1,num1:AnsiString;
    ext1:AnsiString;
    num2,num0:AnsiString;
    dirInfo:TsearchRec;
    doserror:smallint;
    nom,nomEnt:AnsiString;
  begin
    st1:=Fmaj(st1);
    fichierSuivant:=st1;
    decomposerNomFichier(st1,chemin1,nom1,num1,ext1);
    if num1='' then exit;
    val(num1,n1,code);

    dosError:=findfirst(chemin1+nom1+'*'+ext1,faarchive+fareadOnly,dirinfo);

    n0:=maxEntierLong;
    while doserror=0 do
    begin
        nom:=DirInfo.name;
        num2:=copy(nom,length(nom1)+1,
                length(nom) -length(nom1)-length(ext1));
        val(num2,n2,code);
        if (code=0) AND ( (n2>n1) or (n2=n1) AND (num2>num1) )
                    AND ( (n2<n0) or (n2=n0) AND (num2<num0) ) then
          begin
            num0:=num2;
            n0:=n2;
            nomEnt:=nom;
          end;

        dosError:=findNext(dirinfo);
      end;
    if n0<maxEntierLong then fichierSuivant:=chemin1+nomEnt;
    findClose(dirinfo);
  end;


function fichierPrecedent(st1:AnsiString):AnsiString;
  var
    code:integer;
    n0,n1,n2:longint;
    chemin1:AnsiString;
    nom1,num1:AnsiString;
    ext1:AnsiString;
    num2,num0:AnsiString;
    nom,nomEnt:AnsiString;

    dirInfo:TsearchRec;
    doserror:smallint;
  begin
    st1:=Fmaj(st1);
    fichierPrecedent:=st1;
    decomposerNomFichier(st1,chemin1,nom1,num1,ext1);
    if num1='' then exit;
    val(num1,n1,code);
    n0:=0;

    dosError:=findfirst(chemin1+nom1+'*'+ext1,faarchive+fareadOnly,dirinfo);
    while DosError=0 do
    begin
        nom:=DirInfo.name;
        num2:=copy(nom,length(nom1)+1,
                length(nom) -length(nom1)-length(ext1));
        val(num2,n2,code);
        if (code=0) AND ( (n2<n1) or (n2=n1) AND (num2<num1) )
                    AND ( (n2>n0) or (n2=n0) AND (num2>num0) )
        then
          begin
            n0:=n2;
            num0:=num2;
            nomEnt:=nom;
          end;
        doserror:=findNext(dirInfo);
    end;
    if n0>0 then fichierPrecedent:=chemin1+nomEnt;
    findClose(dirinfo);
  end;

function PremierNomDisponible(st:AnsiString):AnsiString;
  var
    chemin:AnsiString;
    nom,num,nom1:AnsiString;
    ext:AnsiString;
    n:longint;
    code:integer;
    i:integer;
  begin
    st:=Fmaj(st);
    premierNomDisponible:='';
    decomposerNomFichier(st,chemin,nom,num,ext);
    nom1:=nom;
    for i:=1 to 4 do nom1:=nom1+'9';

    if fichierExiste(chemin+nom1+ext) then exit;
    st:=fichierPrecedent(chemin+nom1+ext);
    if st=chemin+nom1+ext then
      premierNomDisponible:=chemin+nom+'1'+ext
    else
      begin
        DecomposerNomFichier(st,chemin,nom,num,ext);
        val(num,n,code);
        inc(n);
        str(n,num);
        premierNomDisponible:=chemin+nom+num+ext;
      end;
  end;


function getTMPname(stg:AnsiString):AnsiString;
  begin
    getTMPname:=premierNomDisponible(AppData+stg+'.TMP');
    {messageCentral('Creer '+result);}
  end;

procedure resetTMPfiles(stg:AnsiString);
  var
    st,st1:AnsiString;
  begin
    st1:=fichierSuivant(AppData+stg+'0.TMP');
    if not fichierExiste(st1) then exit;
    repeat
      st:=st1;
      effacerFichier(st);
      {affdebug('Effacer '+st);}
      st1:=fichierSuivant(st);
    until st1=st;
  end;

function GfileDateTime(stf:AnsiString):TdateTime;
begin
  if fichierExiste(stf)
    then result:=FileDateToDateTime(FileAge(stf))
    else result:=0;
end;

function FonctionFileAge_1(st: AnsiString; mode:integer):TdateTime;
begin
  if not fileExists(st) then sortieErreur('File not found');

  result:=FileDateToDateTime(UfileAge(st,mode));
end;

function FonctionFileAge(st: AnsiString):TdateTime;
begin
  result:=FonctionFileAge_1(st,1);
end;


procedure proSplitFileName( st:AnsiString; var chemin:AnsiString;var nom:AnsiString;var extension:AnsiString);
begin
  Fsplit(st,chemin,nom,extension);
end;

procedure proSplitFileName_1( st:AnsiString;
                            var chemin:PgString;sz1:integer;
                            var nom:PgString; sz2:integer;
                            var extension:PgString;sz4:integer);
var
  Xchemin:shortString absolute chemin;
  Xnom:shortString absolute nom;
  Xext:shortString absolute extension;

  chemin1,nom1,ext1:AnsiString;
begin
  Fsplit(st,chemin1,nom1,ext1);
  Xchemin:=copy(chemin1,1,sz1-1);
  Xnom:=copy(nom1,1,sz2-1);
  Xext:=copy(ext1,1,sz4-1);
end;

procedure proSplitFileNameEx( st:AnsiString;var chemin,nom:AnsiString;var numero:integer;var extension:AnsiString);
var
  num1:AnsiString;
  code:integer;
begin
  decomposerNomFichier(st,chemin,nom,num1,extension);

  val(num1,numero,code);
  if code<>0 then numero:=-1;
end;


procedure proSplitFileNameEx_1( st:AnsiString;
                              var chemin:PgString;sz1:integer;
                              var nom:PgString; sz2:integer;
                              var numero:integer;
                              var extension:PgString;sz4:integer);
var
  Xchemin:shortString absolute chemin;
  Xnom:shortString absolute nom;
  Xext:shortString absolute extension;

  chemin1,nom1,num1,ext1:AnsiString;
  code:integer;
begin
  decomposerNomFichier(st,chemin1,nom1,num1,ext1);
  Xchemin:=copy(chemin1,1,sz1-1);
  Xnom:=copy(nom1,1,sz2-1);
  Xext:=copy(ext1,1,sz4-1);

  val(num1,numero,code);
  if code<>0 then numero:=-1;
end;



function fonctionNextFileEx(st:AnsiString):AnsiString;
begin
  result:=fichierSuivant(st);
  if Fmaj(st)=Fmaj(result) then result:='';
end;

function fonctionPreviousFileEx(st:AnsiString):AnsiString;
begin
  result:=fichierPrecedent(st);
  if Fmaj(st)=Fmaj(result) then result:='';
end;


function compareFiles(st1,st2:AnsiString):integer;
var
  f:TfileStream;
  sz1,sz2,res:integer;
  i:integer;
  p1,p2:PtabOctet;
begin
  result:=-2;
  p1:=nil;
  p2:=nil;
  f:=nil;

  try
  f:=TfileStream.create(st1,fmOpenRead);
  sz1:=f.size;
  getmem(p1,sz1);
  f.read(p1^,sz1);
  f.free;
  f:=nil;

  f:=TfileStream.create(st2,fmOpenRead);
  sz2:=f.size;
  getmem(p2,sz2);
  f.read(p2^,sz2);
  f.free;
  f:=nil;

  if sz1<>sz2
    then result:=-1
    else result:=0;

  if result=0 then
  for i:=0 to sz1-1 do
  if p1^[i]<>p2^[i] then
    begin
      result:=i;
      break;
    end;

  freemem(p1);
  p1:=nil;
  freemem(p2);
  p2:=nil;

  except
  freemem(p1);
  freemem(p2);
  f.free;

  end;



end;




Initialization
AffDebug('Initialization Gdos',0);
  AppDir:= extractFilePath(paramstr(0));
  if DirectoryExists(AppDir+'AppData')
    then AppData:=AppDir+'AppData\'
    else AppData:=AppDir;
end.







