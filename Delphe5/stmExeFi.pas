unit stmExeFi;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses sysUtils,forms,dialogs,filectrl,
     util1,Gdos,DdosFich,Dgraphic, debug0;

function FonctionPremierFichier(st:AnsiString):AnsiString;pascal;
function FonctionPremierFichier_1(st:AnsiString;exploreDir:boolean;var tm1:TdateTime;var size:longword;var att:integer):AnsiString;pascal;

function FonctionFichierSuivant:AnsiString;pascal;
function FonctionFichierSuivant_1(var tm1:TdateTime;var size:longword;var att:integer):AnsiString;pascal;

function FonctionFichierExiste(st:AnsiString):boolean;pascal;

function FonctionChoixFichier(var stgen,stFich,stHis:AnsiString):boolean;pascal;
function FonctionChoixFichier_1(var stgen:PgString;szGen:integer;
                                var stFich:PgString;szFich:integer;
                                var stHis:PgString;szHis:integer):boolean;pascal;

function FonctionSauverFichier(var stFich:AnsiString;ext:AnsiString):boolean;pascal;
function FonctionSauverFichier_1(var stFich:PgString;szFich:integer;ext:AnsiString):boolean;pascal;

function FonctionChooseFile(var stFich:AnsiString):boolean;pascal;
function FonctionChooseFile_1(var stFich:PgString;szFich:integer):boolean;pascal;
function FonctionChooseFile_2(var stFich:AnsiString;title1:AnsiString):boolean;pascal;
function FonctionChooseFile_3(var stFich:PgString;szFich:integer;title1:AnsiString):boolean;pascal;

function FonctionExtractFilePath(st:AnsiString):AnsiString;pascal;
function FonctionExtractFileName(st:AnsiString):AnsiString;pascal;
function FonctionExtractFileExt(st:AnsiString):AnsiString;pascal;

function FonctionElphyPath:AnsiString;pascal;
function FonctionStartPath:AnsiString;pascal;

function FonctionChooseDirectory(caption,root:AnsiString;var dir:AnsiString):boolean;pascal;

implementation

var
  SearchRec:array of TsearchRec;
  SearchRecNum:integer;
  exploreDir0:boolean;


function getFich(st:AnsiString;first,exploreDir:boolean;var tm:integer;var size:longword;var att:integer):AnsiString;
const
  path0:AnsiString='';
  st0:AnsiString='';
var
  DosError:integer;
  Attribut:integer;
  i:integer;

function CurPath(n:integer):AnsiString;
var
  i:integer;
begin
  result:=path0;
  for i:=0 to n do
  begin
    if (searchrec[i].Attr and faDirectory)<>0
      then result:=result+searchrec[i].Name ;

    if (length(result)>0) and (result[length(result)]<>'\')
      then result:=result+'\';
  end;
end;

begin
   if first then
     begin
       i:=length(st);
       while (i>0) and (st[i]<>'\') and (st[i]<>':') do dec(i);

       st0:=copy(st,i+1,length(st));
       path0:=copy(st,1,i);

       searchRecNum:=0;
       for i:=0 to high(SearchRec) do FindClose(searchRec[i]);
       setlength(searchRec,1);

       if exploreDir
         then attribut:=FaAnyFile
         else attribut:= faReadOnly+faHidden+faSysFile+faArchive;

       DosError:=FindFirst(st,attribut,searchRec[0]);
     end
   else DosError:=FindNext(searchrec[SearchRecNum]);


   result:='';
   while (SearchRecNum>=0) and ((dosError<>0) or
                                (searchrec[searchrecNum].name='.') or
                                (searchrec[searchrecNum].name='..') or
                                (searchrec[searchrecNum].Attr and faDirectory<>0)
                                )
   do
   begin
     if DosError<>0 then
     begin
       FindClose(searchRec[searchrecNum]);
       setlength(searchrec,searchrecNum);
       dec(searchRecNum);

       if searchRecNum>=0 then DosError:=FindNext(searchRec[searchRecNum]);
     end
     else
     if (searchrec[SearchRecNum].Attr and faDirectory<>0) and
        (searchrec[searchrecNum].name<>'.') and (searchrec[searchrecNum].name<>'..')  then
     begin
       inc(SearchRecNum);
       setlength(searchrec,searchrecNum+1);
       DosError:=FindFirst(curPath(searchrecNum-1)+st0,faAnyFile,searchRec[searchRecNum]);
     end
     else DosError:=FindNext(searchRec[searchRecNum]);
   end;

   if (dosError=0) and (searchrecNum>=0) then
   begin
     result:=curPath(searchRecNum-1)+searchrec[searchRecNum].name;

     tm:=searchRec[SearchRecNum].Time;
     size:=searchRec[SearchRecNum].Size;
     att:=searchRec[SearchRecNum].Attr;
   end
   else
   begin
     result:='';
     tm:=0;
     size:=0;
     att:=0;
   end;
end;

function FonctionPremierFichier(st:AnsiString):AnsiString;
var
  tm:integer;
  size:longword;
  att:integer;
begin
  result:=getFich(st,true,false,tm,size,att);
end;

function FonctionPremierFichier_1(st:AnsiString;exploreDir:boolean;var tm1:TdateTime;var size:longword;var att:integer):AnsiString;
var
  tm:integer;
begin
  result:=getFich(st,true,exploreDir,tm,size,att);
  try
    if tm<>0
      then tm1:=fileDateToDateTime(tm)
      else tm1:=0;
  except
  end;
end;


function FonctionFichierSuivant:AnsiString;
var
  tm:integer;
  size:longword;
  att:integer;
begin
  result:=getFich('',false,false,tm,size,att);
end;

function FonctionFichierSuivant_1(var tm1:TdateTime;var size:longword;var att:integer):AnsiString;
var
  tm:integer;
begin
  result:=getFich('',false,false,tm,size,att);
  try
    if tm<>0
      then tm1:=fileDateToDateTime(tm)
      else tm1:=0;
  except
  end;
end;


function FonctionFichierExiste(st:AnsiString):boolean;
  begin
    FonctionFichierExiste:=FichierExiste(st);
  end;

function FonctionChoixFichier(var stgen, stFich, stHis:AnsiString):boolean;
begin
  result:=ChoixFichierStandard(stgen,stFich,nil);
end;

function FonctionChoixFichier_1(var stgen:PgString;szGen:integer;
                              var stFich:PgString;szFich:integer;
                              var stHis:PgString;szHis:integer):boolean;
  var
    stgen1:shortString Absolute stgen;
    stFich1:shortString Absolute stFich;

    stgen0:AnsiString;
    stFich0:AnsiString;
    stHis0:AnsiString;
  begin
    stGen0:=stgen1;
    stFich0:=stFich1;

    result:=ChoixFichierStandard(stgen0,stFich0,nil);

    stGen1:=copy(stGen0,1,szGen-1);
    stFich1:=copy(stFich0,1,szFich-1);

  end;


function FonctionChooseFile(var stFich:AnsiString):boolean;
begin
  result:=FonctionChooseFile_2(stFich,'');
end;

function FonctionChooseFile_2(var stFich:AnsiString;title1:AnsiString):boolean;
var
  dialog:TopenDialog;
begin
  dialog:=TopenDialog.create(nil);
  with dialog do
  begin
    title:=title1;
    initialDir:=cheminDuFichier(stFich);
    FileName:=stfich;
    result:=execute;
    if result
      then stFich:=fileName;
  end;
  dialog.free;
end;

function FonctionChooseFile_1(var stFich:PgString;szFich:integer):boolean;
var
  stFich1:shortString Absolute stFich;
  stgen0:shortstring;
  stFich0:shortstring;
begin
  result:=FonctionChooseFile_3(stFich,szFich,'');
end;

function FonctionChooseFile_3(var stFich:PgString;szFich:integer;title1:AnsiString):boolean;
var
  dialog:TopenDialog;
  stFich1:shortString Absolute stFich;
begin
  dialog:=TopenDialog.create(nil);
  with dialog do
  begin
    title:=title1;
    initialDir:=cheminDuFichier(stFich1);
    FileName:=stfich1;
    result:=execute;
    if result
      then stFich1:=copy(fileName,1,szFich-1);
  end;
  dialog.free;
end;



function FonctionSauverFichier(var stFich:AnsiString;ext:AnsiString):boolean;
begin
  result:=SauverFichierStandard(stFich,ext);
end;

function FonctionSauverFichier_1(var stFich:PgString;szFich:integer;ext:AnsiString):boolean;
var
  stFich1:shortString Absolute stFich;
  stFich0:AnsiString;
begin
  stFich0:=stFich1;
  result:=SauverFichierStandard(stFich0,ext);
  stFich1:=copy(stFich0,1,szFich-1);
end;


function FonctionExtractFilePath(st:AnsiString):AnsiString;
begin
  result:=extractFilePath(st);
end;

function FonctionExtractFileName(st:AnsiString):AnsiString;
var
  k:integer;
begin
  result:=extractFileName(st);
  k:=pos('.',result);
  if k>0 then delete(result,k,100);
end;

function FonctionExtractFileExt(st:AnsiString):AnsiString;
begin
  result:=extractFileExt(st);
end;

function FonctionElphyPath:AnsiString;
begin
  result:=extractFilePath(application.exeName);
end;

var
  startDir:AnsiString;

function FonctionStartPath:AnsiString;
begin
  result:=StartDir+'\';
end;

function FonctionChooseDirectory(caption,root:AnsiString;var dir:AnsiString):boolean;
begin
  result:= GChooseDirectory(caption,root, dir);
end;


Initialization
AffDebug('Initialization stmExeFi',0);
StartDir:=getCurrentDir;

end.
