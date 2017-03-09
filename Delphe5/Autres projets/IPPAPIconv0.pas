unit IPPAPIconv0;

{ Utilitaire de conversion des interfaces IPP

  On traduit les fichiers .h de Intel pour créer des unités Delphi

  La première commmande fait une traduction simple (ex: ipps.h devient ipps.pas)
  La seconde crée un fichier de déclarations avec overload qui appelle la première unité
  (ex: on crée ippsovr.pas qui appelle ipps)
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,

  util1,Gdos,ippsovr;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }
    fs,fd:textFile;
    pcDef:integer;
    stMot,stMotMaj:string;
    errorRet:integer;

    Flist,FlistR,stImp:TstringList;

    stType,stParam:array of array of string;
    isVar:array of array of boolean;
    stResult:array of string;

    procedure AddName(stName1,stRes1:string);
    function nbName:integer;
    function posUnderScore(st:string):integer;

  public
    { Déclarations publiques }
    stA:string;
    stSource,stDest:string;
    cntSource:integer;

    procedure LireUlex;
    procedure analyseIPPAPI;
    procedure analyseIPPAPIoverload;

    procedure compterPar(st:string;var nbO,nbF:integer);
    procedure sortie(st:string);
    procedure sortieErreur(n:integer);

    procedure Analyse00;
    procedure AnalyseOverload;

    procedure Accepte(c:char);

    procedure BuildInit;
    procedure BuildIntro;
    procedure BuildImpOverload;
    procedure BuildIntroOverload;


    procedure SlashAndStars(var st:string);
    function validFunc:boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure Tform1.LireUlex;
var
  tp:typeLexBase;
  x:float;
  error:integer;
begin
  lireUlexBase(stA, pcDef, stMot, tp, x, error,[' ']);
  if error<>0 then sortieErreur(error);
  stmotMaj:=Fmaj(stmot);

end;


procedure TForm1.compterPar(st:string;var nbO, nbF: integer);
var
  i:integer;
begin
  for i:=1 to length(st) do
  begin
    if st[i]='(' then inc(nbO);
    if st[i]=')' then inc(nbF);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  stA:='';
  Flist:=TstringList.create;
  FlistR:=TstringList.create;

  stImp:=TstringList.create;
end;

procedure TForm1.sortie(st: string);
begin
  memo1.Lines.Add(st);
end;

{$O-}     {interdire l'optimisation}
procedure Tform1.sortieErreur(n:integer);
var
  i:Integer;
begin
  i:=0;
  errorRet:=n;
  i:=10 div i;
end;
{$O+}


procedure TForm1.Accepte(c: char);
begin
  if stMot<>c then
  begin
    sortie(c +' expected line '+Istr(cntSource));
    sortieErreur(100);
  end;
end;

{ Analyse d'une macro IPPAPI du genre:

IPPAPI(IppStatus, ippsAddC_16s_I,     (Ipp16s  val, Ipp16s*  pSrcDst, int len))

on a:
IPPAPI(type_résultat , Nom_fonction , (liste des paramètres) )
}
procedure TForm1.analyseIPPAPI;
var
  stRes:string;
  stName:string;
  stDec:string;
  i:integer;

function nbP:integer;
begin
  result:=length(stparam[nbName-1]);
end;

procedure incNbP;
begin
  setLength(stType[nbName-1],length(stType[nbName-1])+1);
  setLength(stParam[nbName-1],length(stParam[nbName-1])+1);
  setLength(isVar[nbName-1],length(isVar[nbName-1])+1);
end;

procedure decNbP;
begin
  setLength(stType[nbName-1],length(stType[nbName-1])-1);
  setLength(stParam[nbName-1],length(stParam[nbName-1])-1);
  setLength(isVar[nbName-1],length(isVar[nbName-1])-1);
end;


begin
  pcDef:=0;

  lireULex;                                {IPPAPI}
  lireUlex;
  accepte('(');

  lireUlex;
  if stmotMaj='CONST' then lireUlex;       {type résultat}
  stRes:=stmot;

  lireUlex;
  while stmot='*' do
  begin
    stRes:='P'+stRes;
    lireUlex;
  end;
  accepte(',');

  lireUlex;
  stName:=stMot;                            {Nom fonction}
  AddName(stName,stRes);

  lireUlex;
  accepte(',');

  lireUlex;
  accepte('(');                             {Début des paramètres}

  repeat
    lireUlex;                               { type param }
    if stmotMaj='CONST' then lireUlex;

    incNbP;
    isvar[nbName-1,nbP-1]:=false;

    if stmotMaj='UNSIGNED' then
    begin
      lireUlex;
      if stMotMaj='INT' then stType[nbName-1,nbP-1]:='longWord'
      else
      if stMotMaj='SHORT' then stType[nbName-1,nbP-1]:='word'
      else
      if stMotMaj='CHAR' then stType[nbName-1,nbP-1]:='byte'
      else stType[nbName-1,nbP-1]:=stMot;
    end
    else
    begin
      if stMotMaj='INT' then stType[nbName-1,nbP-1]:='longint'
      else
      if stMotMaj='SHORT' then stType[nbName-1,nbP-1]:='smallint'
      else
      if stMotMaj='FLOAT' then stType[nbName-1,nbP-1]:='single'
      else
      stType[nbName-1,nbP-1]:=stMot;
    end;

    lireUlex;                               { type param Pointeur}
    if stmot='*' then
    begin
      stType[nbName-1,nbP-1]:='P'+stType[nbName-1,nbP-1];  {On ajoute P devant le type }
      if Fmaj(stType[nbName-1,nbP-1])='PVOID' then stType[nbName-1,nbP-1]:='pointer';
      lireUlex;
    end;
    if stmot='*' then                       { Param pointeur }
    begin
      isvar[nbName-1,nbP-1]:=true;
      lireUlex;
    end;
    if stmotMaj='CONST' then lireUlex;

    if Fmaj(stType[nbName-1,nbP-1])='VOID' then
    begin
      decNbP;
      break;
    end;

    stParam[nbName-1,nbP-1]:=stMot;         { Param name }
    lireUlex;
    if stmot='[' then
    begin
      while stmot='[' do
      begin
        lireUlex;                        {exemple:  freq[2]  on vire les crochets}
        lireUlex;
        lireUlex;
      end;
      isvar[nbName-1,nbP-1]:=true;       {et on ajoute VAR . A vérifier !  }
    end;
  until stMot<>',' ;

  accepte(')');                                {Fin des paramètres}

  lireUlex;
  accepte(')');

  stDec:='  '+stName+': ';               { Ecriture de la fonction }
  if Fmaj(stRes)='VOID'
    then stDec:=stDec+'procedure'
    else stDec:=stDec+'function';

  if nbP>0 then stDec:=stDec+'(';
  for i:=0 to nbP-1 do
  begin
    if isvar[nbName-1,i] then stDec:=stDec+'var ';
    stDec:=stDec+stParam[nbName-1,i]+':'+stType[nbName-1,i];
    if i<>nbP-1
      then stDec:=stDec+';'
      else stDec:=stDec+')'
  end;

  if Fmaj(stRes)='VOID'
    then stDec:=stDec+';'
    else stDec:=stDec+':'+stRes+';';


  GwritelnT(fD,stDec);
end;

function Tform1.validFunc:boolean;
var
  i,j:integer;
  st:string;
  idx:integer;
  egal:boolean;
begin
  result:=true;
  if FlistR.count=0 then exit;

  result:=false;
  idx:=FlistR.count-1;
  st:=FlistR[idx];

  for i:=0 to FlistR.Count-2 do
  if (st=FlistR[i]) and (length(stType[i])=length(stType[idx])) then
  begin
    egal:=true;
    for j:=0 to high(stType[idx]) do
      if Fmaj(stType[i,j])<>Fmaj(stType[idx,j]) then
      begin
        egal:=false;
        break;
      end;
    if egal then exit;
  end;

  result:=true;
end;

function TForm1.posUnderScore(st:string):integer;
var
  k:integer;
begin
  result:=pos('_',st);
  if (result<length(st)) and (st[result+1] in ['0'..'9']) then exit;
  if result<1 then exit;

  inc(result);
  while (result<length(st)) and (st[result]<>'_') do inc(result);

  if st[result]<>'_' then result:=0;
end;

procedure TForm1.analyseIPPAPIoverload;
var
  stRes:string;
  stName,stName1:string;
  stDec:string;
  i,k:integer;
  stP:string;
  VF:boolean;


function nbP:integer;
begin
  result:=length(stparam[nbName-1]);
end;

procedure incNbP;
begin
  setLength(stType[nbName-1],length(stType[nbName-1])+1);
  setLength(stParam[nbName-1],length(stParam[nbName-1])+1);
  setLength(isVar[nbName-1],length(isVar[nbName-1])+1);
end;

procedure decNbP;
begin
  setLength(stType[nbName-1],length(stType[nbName-1])-1);
  setLength(stParam[nbName-1],length(stParam[nbName-1])-1);
  setLength(isVar[nbName-1],length(isVar[nbName-1])-1);
end;


begin
  pcDef:=0;

  lireULex;                                {IPPAPI}
  lireUlex;
  accepte('(');

  lireUlex;
  if stmotMaj='CONST' then lireUlex;       {type résultat}
  stRes:=stmot;

  lireUlex;
  while stmot='*' do
  begin
    stRes:='P'+stRes;
    lireUlex;
  end;
  accepte(',');

  lireUlex;
  stName:=stMot;                            {Nom fonction}
  AddName(stName,stRes);

  lireUlex;
  accepte(',');

  lireUlex;
  accepte('(');                             {Début des paramètres}

  repeat
    lireUlex;                               { type param }
    if stmotMaj='CONST' then lireUlex;

    incNbP;
    isvar[nbName-1,nbP-1]:=false;

    if stmotMaj='UNSIGNED' then
    begin
      lireUlex;
      if stMotMaj='INT' then stType[nbName-1,nbP-1]:='longWord'
      else
      if stMotMaj='SHORT' then stType[nbName-1,nbP-1]:='word'
      else
      if stMotMaj='CHAR' then stType[nbName-1,nbP-1]:='byte'
      else stType[nbName-1,nbP-1]:=stMot;
    end
    else
    begin
      if stMotMaj='INT' then stType[nbName-1,nbP-1]:='longint'
      else
      if stMotMaj='SHORT' then stType[nbName-1,nbP-1]:='smallint'
      else
      if stMotMaj='FLOAT' then stType[nbName-1,nbP-1]:='single'
      else
      stType[nbName-1,nbP-1]:=stMot;
    end;

    lireUlex;                                       { param }
    if stmot='*' then
    begin
      stType[nbName-1,nbP-1]:='P'+stType[nbName-1,nbP-1];
      if Fmaj(stType[nbName-1,nbP-1])='PVOID' then stType[nbName-1,nbP-1]:='pointer';
      lireUlex;
    end;
    if stmot='*' then
    begin
      isvar[nbName-1,nbP-1]:=true;
      lireUlex;
    end;
    if stmotMaj='CONST' then lireUlex;

    if Fmaj(stType[nbName-1,nbP-1])='VOID' then
    begin
      decNbP;
      break;
    end;

    stParam[nbName-1,nbP-1]:=stMot;
    lireUlex;
    if stmot='[' then
    begin
      while stmot='[' do
      begin
        lireUlex;                        {exemple:  freq[2]  on vire les crochets}
        lireUlex;
        lireUlex;
      end;
      isvar[nbName-1,nbP-1]:=true;       {et on ajoute VAR . A vérifier !  }
    end;
  until stMot<>',' ;

  accepte(')');                                {Fin des paramètres}

  lireUlex;
  accepte(')');

  VF:=validFunc;
                                               { Ecriture de la fonction }
  k:=posUnderScore(stName);
  if (k>1) and VF
    then stName1:=copy(stName,1,k-1)
    else stName1:=stName;

  if Fmaj(stRes)='VOID'
    then stDec:='procedure '+stName1
    else stDec:='function '+stName1;

  if nbP>0 then stDec:=stDec+'(';
  for i:=0 to nbP-1 do
  begin
    if isvar[nbName-1,i] then stDec:=stDec+'var ';
    stDec:=stDec+stParam[nbName-1,i]+':'+stType[nbName-1,i];
    if i<>nbP-1
      then stDec:=stDec+';'
      else stDec:=stDec+')'
  end;

  if Fmaj(stRes)='VOID'
    then stDec:=stDec+';'
    else stDec:=stDec+':'+stRes+';';

  

  if (k>1) and VF then
  begin
    stDec:=stDec;
    GwritelnT(fD,stDec+'overload;');

    with stImp do                               { Ecriture de l'implémentation }
    begin
      add(stDec);
      add('begin');
      if Fmaj(stRes)<>'VOID'
        then stP:='result:='+stName
        else stP:=stName;

      if nbP>0 then stP:=stP+'(';
      for i:=0 to nbP-1 do
      begin
        stP:=stP+stParam[nbName-1,i];
        if i<>nbP-1
          then stP:=stP+','
          else stP:=stP+');'
      end;
      add('  '+stP);

      add('end;');
      add('');
    end
  end
  else GwritelnT(fD,'{ '+stDec+' }');


end;



procedure Tform1.BuildInit;
var
  i:integer;
begin
  GwritelnT(fD,'');
  GwritelnT(fD,'function Init'+Fmaj(nomduFichier1(stDest))+':boolean;');
  GwritelnT(fD,'');
  GwritelnT(fD,'IMPLEMENTATION');
  GwritelnT(fD,'');
  GwritelnT(fD,'var');
  GwritelnT(fD,'  hh:integer;');
  GwritelnT(fD,'');
  GwritelnT(fD,'');
  GwritelnT(fD,'function getProc(hh:Thandle;st:string):pointer;');
  GwritelnT(fD,'begin');
  GwritelnT(fD,'  result:=GetProcAddress(hh,Pchar(st));');
  GwritelnT(fD,'  if result=nil then messageCentral(st+''=nil'');');
  GwritelnT(fD,'               {else messageCentral(st+'' OK'');}');
  GwritelnT(fD,'end;');
  GwritelnT(fD,'');
  GwritelnT(fD,'function Init'+Fmaj(nomduFichier1(stDest))+':boolean;');
  GwritelnT(fD,'begin');
  GwritelnT(fD,'  result:=true;');
  GwritelnT(fD,'  if hh<>0 then exit;');
  GwritelnT(fD,'');
  GwritelnT(fD,'  hh:=GloadLibrary(DLLname);');
  GwritelnT(fD,'');
  GwritelnT(fD,'  result:=(hh<>0);');
  GwritelnT(fD,'  if not result then exit;');
  GwritelnT(fD,'');
  GwritelnT(fD,'');

  with Flist do
  for i:=0 to count-1 do
    GwritelnT(fD,'  '+strings[i]+':=getProc(hh,'''+strings[i]+''');');
  GwritelnT(fD,'end;');


  GwritelnT(fD,'end.');

end;

procedure TForm1.BuildIntro;
begin
  GwritelnT(fD,'Unit '+nomDuFichier1(stDest)+';');
  GwritelnT(fD,'');
  GwritelnT(fD,'INTERFACE');
  GwritelnT(fD,'');
  GwritelnT(fD,'uses ippdefs;');
  GwritelnT(fD,'');
end;


procedure TForm1.Analyse00;
var

  st:string;
  nbO,nbF:integer;
begin
  Flist.clear;
  FlistR.Clear;
  setLength(stParam,0,0);
  setLength(stType,0,0);
  setLength(isVar,0,0);
  setLength(stResult,0);


  if paramCount>=1
    then stSource:=paramStr(1)
    else stSource:='c:\program files\intel\ipp40\include\ipps.h';

  stDest:=debugPath+nomDuFichier1(stSource)+'.ele';

  AssignFile(fS,stSource);
  AssignFile(fD,stDest);

  GresetT(fS);
  GrewriteT(fD);

  memo1.Lines.Add('Début');

  BuildIntro;

  while not Geof(fS) do
  begin
    GreadlnT(fS,st);
    SlashAndStars(st);
    inc(cntSource);

    if pos('IPPAPI',st)>0 then
    begin
      stA:='';
      nbO:=0;
      nbF:=0;
      repeat
        stA:=stA+st;
        compterPar(st,nbO,nbF);
        if nbO>nbF then
        begin
          GreadlnT(fS,st);
          SlashAndStars(st);
          inc(cntSource);
        end;
        st:=' '+st;
      until nbO<=nbF;
      if nbO<nbF then
      begin
        sortie('nbO<nbF line '+Istr(cntSource));
        GwritelnT(fD,'=========================================> Translation error' );
      end
      else AnalyseIPPAPI;

    end
    else GwritelnT(fD,st);
  end;

  BuildInit;
  sortie('Terminé');

  GcloseT(fS);
  GcloseT(fD);
end;

procedure TForm1.AnalyseOverload;
var
  st:string;
  nbO,nbF:integer;
begin
  Flist.clear;
  FlistR.clear;

  stImp.clear;

  setLength(stParam,0,0);
  setLength(stType,0,0);
  setLength(isVar,0,0);
  setLength(stResult,0);

  if paramCount>=1
    then stSource:=paramStr(1)
    else stSource:='c:\program files\intel\ipp40\include\ipps.h';

  stDest:=debugPath+nomDuFichier1(stSource)+'.ovl';

  AssignFile(fS,stSource);
  AssignFile(fD,stDest);

  GresetT(fS);
  GrewriteT(fD);

  memo1.Lines.Add('Début overload');

  BuildIntroOverload;

  while not Geof(fS) do
  begin
    GreadlnT(fS,st);
    SlashAndStars(st);
    inc(cntSource);

    if pos('IPPAPI',st)>0 then
    begin
      stA:='';
      nbO:=0;
      nbF:=0;
      repeat
        stA:=stA+st;
        compterPar(st,nbO,nbF);
        if nbO>nbF then
        begin
          GreadlnT(fS,st);
          SlashAndStars(st);
          inc(cntSource);
        end;
        st:=' '+st;
      until nbO<=nbF;
      if nbO<nbF then
      begin
        sortie('nbO<nbF line '+Istr(cntSource));
        GwritelnT(fD,'=========================================> Translation error' );
      end
      else AnalyseIPPAPIoverload;

    end
    else GwritelnT(fD,st);
  end;

  BuildImpOverload;;
  sortie('Terminé Overload');

  GcloseT(fS);
  GcloseT(fD);
end;





procedure TForm1.SlashAndStars(var st: string);
var
  i:integer;
begin
  if Fmaj(copy(st,1,3))='#IF' then st:='(*   '+st
  else
  if Fmaj(copy(st,1,6))='#ENDIF' then st:=st+'  *)'
  else
  begin
    for i:=1 to length(st)-1 do
    if (st[i]='/') and (st[i+1]='*') then st[i]:='(';

    for i:=1 to length(st)-1 do
    if (st[i]='*') and (st[i+1]='/') then st[i+1]:=')';
  end;
end;


procedure TForm1.AddName(stName1,stRes1:string);
var
  k:integer;
begin
  Flist.Add(stName1);

  setLength(stResult,nbName);
  stResult[nbName-1]:=stRes1;

  setLength(stType,nbName);
  setLength(stParam,nbName);
  setLength(isVar,nbName);

  k:=posUnderScore(stName1);
  if k>1
    then FlistR.add(copy(stName1,1,k-1))
    else FlistR.Add(stName1);
end;

function TForm1.nbName: integer;
begin
  result:=Flist.count;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Analyse00;
end;



procedure TForm1.BuildImpOverload;
var
  i:integer;
begin
  GwritelnT(fD,'');
  GwritelnT(fD,'IMPLEMENTATION');
  GwritelnT(fD,'');

  with stimp do
  for i:=0 to count-1 do
    GwritelnT(fD,strings[i]);

  GwritelnT(fD,'end.');

end;


procedure TForm1.BuildIntroOverload;
begin
  GwritelnT(fD,'Unit '+nomDuFichier1(stDest)+';');
  GwritelnT(fD,'');
  GwritelnT(fD,'INTERFACE');
  GwritelnT(fD,'');
  GwritelnT(fD,'uses ippdefs;');
  GwritelnT(fD,'');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  AnalyseOverload;
end;

end.
