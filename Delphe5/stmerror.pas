unit Stmerror;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     util1,Dgraphic,Ncdef2,debug0;

var
  E_InvalidObjectNam:integer;
  E_InvalidObjectType:integer;
  E_InvalidVariable:integer;

procedure AfficherMessageErreurEXE(num:integer);
procedure InstallError(var num:integer;st:AnsiString);

function getErrorString(num:integer):AnsiString;

procedure AfficherMessageErreurEXE2(num:integer;stError:AnsiString);

IMPLEMENTATION

const
  ErrorList:TstringList=nil;


procedure InstallError(var num:integer;st:AnsiString);
var
  i:integer;
begin
  if not assigned(ErrorList) then
  begin
    errorList:=TstringList.create;
    errorList.add('');
  end;

  num:=errorList.add(st) +10000;
end;

function getErrorString(num:integer):AnsiString;
begin
  if num=999 then
  begin
    result:=GenericExeError;
    exit;
  end;

  num:=num-10000;
  with errorList do
  begin
    if (num>0) and (num<count)
      then result:=strings[num]
      else result:='';
  end;
end;

procedure AfficherMessageErreurEXE(num:integer);
var
  i:integer;
  BoiteInfo:typeBoiteInfo;
  st:AnsiString;
begin
{
  st:='';
  if num=1 then st:=errorEXEMsg
  else
  with errorList do
  begin
    i:=indexOfObject(pointer(num));
    if i>=0 then st:=strings[i];
  end;

  with Boiteinfo do
  begin
    init('ERROR');
    writeln('Run-time error '+Istr(num));
    writeln(st);
    done(formStm.handle);
  end;
  }
end;

procedure AfficherMessageErreurEXE2(num:integer;stError:AnsiString);
var
  i:integer;
  BoiteInfo:typeBoiteInfo;
  st:AnsiString;
begin
  st:='';
  if num=1 then st:=stError
  else
  with errorList do
  begin
    i:=indexOfObject(pointer(num));
    if i>=0 then st:=strings[i];
  end;

  with Boiteinfo do
  begin
    init('ERROR');
    writeln('Run-time error '+Istr(num));
    writeln(st);
    done;
  end;
end;


procedure InstallStdErrors;
begin
  installError( E_parametre,'Invalid parameter');
  installError( E_mem,'Not enough memory to perform operation');
  installError( E_NumFichier,'Invalid file number');
  installError( E_lecture,'Read error');
  installError( E_FichierNonConforme,'Invalid Acquis1 data file');
  installError( E_FichierNonOuvert,'File not open');
  installError( E_TamponMoyenneNonAlloue,'Average buffer not allocated');
  installError( E_pile,'Stack overflow');
  installError( E_fenetre,'Invalid window parameters or too many windows');
  installError( E_FichierDejaOuvert,'File already open');
  installError( E_NomDeFichierIncorrect,'Invalid file name');
  installError( E_fichierInexistant,'File does not exist');
  installError( E_ChargementImpossible,'Unable to load data file');
  installError( E_tableauNonAlloue,'Spreadsheet buffer not allocated');
  installError( E_allocationPile,'Unable to create stack buffer');
  installError( E_memoireNonAllouee,'Episode memory not allocated');
  installError( E_allouerFit,'Unable to create buffers for Fit operation');
  installError( E_menu,'Unable to create dialog box');

  installError( E_popMoy,'PopMoy error');
  installError( E_modeleFit,'error in Fit model');
  installError( E_DACnonAlloue,'DAC buffer not allocated');
  installError( E_MemDynamique,'Not enough dynamic memory');
  installError( E_ecriture,'Disk write error');
  installError( E_periodeAcq,'Invalid acquisition period');
  installError( E_typeAcquis1,'Acquis1 data file expected');
  installError( E_typeFichier,'Unrecognized data file');

  installError( E_objetInexistant,'Invalid object');

  installError( E_InvalidObjectName,'Invalid object name');
  installError( E_InvalidObjectType,'Invalid object type');
  installError( E_InvalidVariable,'Invalid variable');

  installError( E_IndiceTableau,'Array Index out of range');
  installError( E_indiceChaine,'String index out of range');



end;

Initialization
AffDebug('Initialization stmerror',0);


InstallStdErrors;

end.

