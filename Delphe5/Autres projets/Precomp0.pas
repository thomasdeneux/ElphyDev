unit Precomp0;

INTERFACE

uses
  classes, SysUtils,
  util1,Gdos,Dgraphic,DUlex5,Ncdef2,procac2;

type
  Twriteln=procedure (st:string) of object;

var
  writeln1:Twriteln;

Const
  NparMax:integer =0;

Const
  DacVer:string='Dacver';

function precompile(stMain,stF:string):integer;
{ stMain est le nom du fichier source principal FPS (qui contient des fichiers inclus FPS )
  Les fichiers inclus sont dans le même répertoire.

  stF est le nom du fichier destination (l'extension est sans importance). On crée:
    - le fichier .PRC
    - le fichier .adr    (inclus dans dacadp2.pas )
    - le fichier .mph    (utilisé par hcw: liste de #define)


}
procedure DispVersion;

IMPLEMENTATION

var
  version:integer;
  repPAS:AnsiString;


var
  w,ch:char;

const
  pcDef:integer=-1;
  fin:boolean=false;
  error:integer=0;

  nbProcedure:integer=0;
  nbFonction:integer=0;
  nbProp:integer=0;
  nbMulti:integer=0;

var
  ligne,colonne:integer;

const
  motType= RefLocByte;
  NomDeType= RefLocShort;
  AnyProc= RefLocI;
  motProcedure0= RefLocWord;
  motFunction0= RefLocL;
  motType0= RefLocDword;
  motVar0= RefLocInt64;
  motConst0= RefLocSingle;
  motProperty0= RefLocDouble;
  motReadOnly0= RefLocR;
  motPage= RefLocSingleComp;
  motDefault0= RefLocDoubleComp;
  motImplicit0= RefLocExtComp;

  maxTypes=200;
  nbtypes:integer=0;
var
  tbTypes:array[1..maxTypes] of string;
  depTypes:array[1..maxTypes] of integer;


var

  tbDef:TTabDefProc;
  tp:typeLex;
  stMot,stMot0:Shortstring;
  x0:float;
  vob:integer;
var
  errorRET:integer;

  NomFichier:string;

  fAlias:text;

  numRefProc:integer;

  stList:TUtextFile;
  Ulex1:TUlex1;
  ligneC,colonneC,numInc:integer;

  checksum: integer;


{$O-}     {interdire l'optimisation}
procedure sortie(n:smallInt);
  var
    i:smallInt;
  begin
    i:=0;
    errorRet:=n;

    i:=10 div i;
  end;
{$O+}


procedure identifierMot(st1:string;var tp:typeLex;var Vob:integer);
  var
    i,code:integer;
  begin
    vob:=-1;

    st1:=Fmaj(st1);

    for i:=1 to nbtypes do
      if st1=tbTypes[i] then
        begin
          tp:=NomDeType;
          numRefProc:=depTypes[i];
          exit;
        end;


    if st1='PROCEDURE' then
      begin
        tp:=motPROCEDURE0;
        NumrefProc:=0
      end
    else
    if st1='FUNCTION' then
      begin
        tp:=motFUNCTION0;
        NumrefProc:=0;
      end
    else
    if st1='PROPERTY' then tp:=motProperty0
    else
    if st1='READONLY' then tp:=motReadOnly0
    else
    if st1='DEFAULT' then tp:=motDefault0
    else
    if st1='IMPLICIT' then tp:=motImplicit0
    else
    if st1='VAR' then tp:=motVAR0
    else
    if st1='BYTE' then tp:=motByte
    else
    if st1='SHORTINT' then tp:=motShortInt
    else
    if st1='SMALLINT' then tp:=motSmallInt
    else
    if st1='WORD' then tp:=motWord
    else
    if st1='INTEGER' then tp:=motLONGINT      {21 février 2002 passage au LONGINT}
    else
    if st1='LONGINT' then tp:=motLONGINT
    else
    if st1='LONGWORD' then tp:=motLongWord
    else
    if st1='INT64' then tp:=motInt64
    else

    if st1='SINGLE' then tp:=motSingle
    else
    if st1='DOUBLE' then tp:=motDouble
    else
    if st1='EXTENDED' then tp:=motExtended
    else
    if st1='REAL' then tp:=motExtended
    else
    if st1='SCOMPLEX' then tp:=motSingleComp
    else
    if st1='DCOMPLEX' then tp:=motDoubleComp
    else
    if st1='COMPLEX' then tp:=motExtComp
    else

    if st1='CHAR' then tp:=motChar
    else
    if st1='VARIANT' then tp:=motVariant
    else
    if st1='TDATETIME' then tp:=motDateTime
    else

    if st1='BOOLEAN' then tp:=motBOOLEAN
    else
    if st1='STRING' then tp:=motAnsiSTRING
    else
    if st1='SHORTSTRING' then tp:=motShortString
    else
    if st1='OBJECT' then tp:=TypeObjet
    else
    if st1='END' then tp:=motEnd
    else
    if st1='CONST' then tp:=motConst0
    else
    if st1='TYPE' then tp:=motType0
    else
    if st1='HPAGE' then tp:=motPage
    else
    if st1='TANYPROCEDURE' then tp:=anyProc
    else
      begin
        with tbdef do
        for i:=1 to nbTypeObjet do
          if Fmaj(tbObjet[i-1].stName)=st1 then
            begin
              tp:=TypeObjet;
              vob:=i-1;
              exit;
            end;
        tp:=motNouveau;
      end;

  end;



procedure LireUlex;
  var
    buf:PtabChar;
  begin
    repeat
      Ulex1.lire(stMot,tp,x0,errorRet,checksum);
      {lireUlex1(buf^,0,PcDef,stMot,tp,x0,errorRet);}
      if errorRet<>0 then sortie(errorRet);
      if tp=vid then identifierMot(stMot,tp,vob);
    until tp<>directive;
  end;


procedure accepte(tp1:typeLex);
  begin
    if tp<>tp1 then sortie(100+ord(tp1));
  end;

procedure creerType(var tpnb:typeNombre;var mini:integer);
  var
    tp1:typeLex;
  begin
    mini:=0;
    tp1:=tp;
    case tp of
      motByte..motChar:
        begin
          tpnb:=resTonb(tp);
          lireUlex;
          if tp=PointDouble then
          begin
            lireUlex;
            if tp>tp1
              then mini:=ord(tp)-ord(tp1)
              else sortie(200);
            lireUlex;
          end;

          exit;
        end;

      motShortString: tpnb:=nbChaine;
      motAnsiString:  tpnb:=nbAnsiString;

      nomDeType:   begin
                     tpnb:=refProcedure;
                     mini:=numRefProc;
                   end;

      TypeObjet:  begin
                    tpnb:=refObject;
                    mini:=vob;
                  end;

      anyProc:    begin
                    tpnb:=refProcedure;
                    mini:=-1;
                  end;

      else
        begin
          {writeln1('tp=',ord(tp),'  ',stMot);}
          errorRet:=200;
        end;
    end;
    if errorRet<>0 then sortie(ErrorRet);
    lireUlex;
  end;


function creerListeVar: integer;
  var
    i,nb,mini:integer;
    flag:boolean;
    tpnb:typeNombre;
  begin
    flag:=(tp=motVar0);
    if flag then lireUlex;
    accepte(motNouveau);
    nb:=1;
    lireUlex;
    while tp=virgule do
      begin
        lireUlex;
        accepte(motNouveau);
        inc(nb);
        lireUlex;
      end;

    if tp=deuxPoint then
      begin
        lireUlex;
        creerType(tpNb,mini);
        if flag then
        begin
          case tpNb of
            nbByte..nbAnsiString:
              byte(tpnb):=byte(tpnb)+(ord(refByte)-ord(nbByte));
          end;
          {if tpNb=refsmall then messageCentral('Var integer==>'+stMot0);}
        end;
      end
    else
    if flag then
      begin
        tpNb:=RefVar;
        {messageCentral('Var==>'+stMot0);}
      end
    else accepte(deuxPoint);

    for i:=1 to nb do result:=tbDef.setParam(tpNb,mini);
  end;


procedure creerCorps(proc:boolean);
  var
    desc:setByte;
    flagObj:boolean;
    valOb:integer;
    Npar:integer;
  begin
    Npar:=0;
    flagObj:=false;
    if tp=TypeObjet then
      begin
        flagObj:=true;
        valOb:=vob;
        lireUlex;
        accepte(pointL);
        lireUlex;
      end;
    accepte(motNouveau);

    tbDef.nouveauSymbole(stMot,proc);
    stMot0:=stMot;
    lireUlex;
    if tp=parou then
      begin
        lireUlex;
        Npar:= creerListeVar;
        while tp=pointVirgule do
          begin
            lireUlex;
            Npar:= creerListeVar;
          end;
        accepte(parfer);
        lireUlex;
      end;
    if flagObj then
      begin
        tbDef.setObj(valOb);
        tbDef.setLastObj(stMot0,valOb);
      end;
    tbDef.checkOverload;

    if Npar>NparMax then NparMax:=Npar;

   { if Npar>=10 then messageCentral( stMot0+Istr1(Npar,6) );}
  end;


procedure creerProcedure;
  begin
     lireUlex;
     creerCorps(true);
     accepte(pointVirgule);
     lireUlex;
     inc(nbProcedure);

     if tp=divis then
       begin
         lireUlex;
         accepte(motNouveau);
         tbdef.setalias(stMot,stMot0);
         lireUlex;
       end;

  end;

procedure creerFonction;
  var
    tpnb:typeNombre;
    mini:integer;
  begin
     lireUlex;
     creerCorps(true);
     accepte(DeuxPoint);
     lireUlex;
     creerType(tpnb,mini);
     tbDef.setResult(tpNb,mini);
     accepte(pointVirgule);
     lireUlex;
     inc(nbFonction);

     if tp=divis then
       begin
         lireUlex;
         accepte(motNouveau);
         tbdef.setalias(stMot,stMot0);
         lireUlex;
       end;
  end;

procedure creerPropriete;
  var
    tpnb:typeNombre;
    mini:integer;
    FreadOnly,Fdefault,Fimplicit:boolean;
  begin
     lireUlex;
     creerCorps(true);
     accepte(DeuxPoint);
     lireUlex;
     creerType(tpnb,mini);
     tbDef.setResult(tpNb,mini);

     FreadOnly:=false;
     Fdefault:=false;
     Fimplicit:=false;

     if tp=motReadOnly0 then
     begin
       FreadOnly:=true;
       lireUlex;
     end;

     if tp=motDefault0 then
     begin
       Fdefault:=true;
       lireUlex;
     end;

     if tp=motImplicit0 then
     begin
       Fimplicit:=true;
       lireUlex;
     end;

     accepte(pointVirgule);
     lireUlex;
     inc(nbProp);

     if FreadOnly
       then tbDef.setProperty(prReadOnly)
       else tbDef.setProperty(prReadWrite);

     if Fdefault then tbdef.setDefaultProp;

     if Fimplicit then tbdef.setImplicitProp;

     if tp=divis then
       begin
         lireUlex;
         accepte(motNouveau);
         tbdef.setalias(stMot,stMot0);
         lireUlex;
       end;
  end;



procedure CreerTypeObjet;
  begin
    lireUlex;
    while (tp=motNouveau) do
    begin
      inc(tbdef.nbTypeObjet);
      tbdef.tbObjet[tbdef.nbTypeObjet-1].stName:=stMot;
      writeln1('Objet==>'+stmot);
      lireUlex;
      if tp=parou then
        with tbdef do
        begin
          lireUlex;
          tbdef.tbAncetre^[nbTypeObjet]:=getNumObj1(stMot);
          if tbAncetre^[nbTypeObjet]=-1 then
            begin
              writeln1(stMot);
              sortie(300);
            end;
          lireUlex;
          accepte(parfer);
          lireUlex;
        end;
    end;
    accepte(motEnd);
    lireUlex;
    accepte(pointVirgule);
    lireUlex;
    writeln1(Istr(tbdef.nbTypeObjet)+' objets' );
  end;


Procedure creerConst;
  var
    Fmoins:boolean;
    i:integer;
    l:longint;
    r:float;
    stDum:string;
  const
    varTrue:boolean=true;
    varFalse:boolean=false;
  begin
    tbDef.setGroupeConst;

    lireUlex;
    accepte(motNouveau);
    while tp=motNouveau do
    begin
      Fmoins:=false;
      tbDef.NouveauSymbole(stMot,false);
      lireUlex;
      accepte(egal);
      lireUlex;
      if tp=moins then
        begin
          lireUlex;
          Fmoins:=true;
        end;
      case tp of
        nbi: begin
               if Fmoins then i:=-roundI(x0)
                         else i:=roundI(x0);
               tbDef.setConstante(nbSmall,i);
             end;
        nbL: begin
               if Fmoins then l:=-roundL(x0)
                         else l:=roundL(x0);
               tbDef.setConstante(nbLong,l);
             end;
        nbR: begin
               if Fmoins then r:=-x0
                         else r:=x0;
               tbDef.setConstante(nbExtended,r);
             end;
        ChaineCar:
             if not Fmoins then
             begin
               stDum:=stMot;
               tbDef.setConstante(nbChaine,stDum);
             end
             else sortie(400);
        motTrue:
             if not Fmoins then tbDef.setConstante(nbBoole,vartrue)
                           else sortie(400);
        motFalse:
             if not Fmoins then tbDef.setConstante(nbBoole,varfalse)
                           else sortie(400);
        else sortie(400);
      end;
      lireUlex;
      accepte(pointVirgule);
      lireUlex;
    end;
  end;

Procedure creerTypes;
  var
    tpnb:typeNombre;
    mini:integer;
  begin
    lireUlex;
    accepte(motNouveau);
    while tp=motNouveau do
    begin
      inc(nbTypes);
      tbTypes[nbTypes]:=Fmaj(stMot);


      lireUlex;
      accepte(egal);
      lireUlex;
      stMot:='#'+tbTypes[nbTypes];

      if tp=motProcedure0 then
        begin
          tp:=motNouveau;
          creerCorps(false);
        end
      else
      if tp=motFunction0 then
        begin
          tp:=motNouveau;
          creerCorps(false);
          accepte(DeuxPoint);
          lireUlex;
          creerType(tpnb,mini);
          tbDef.setResult(tpNb,mini);
        end
      else sortie(800);

      with tbDef do DepTypes[nbTypes]:=intG(Pfin)-intG(adTab);

      accepte(pointVirgule);
      lireUlex;
    end;
  end;


procedure creerPage;
begin
  repeat lireUlex until tp=pointVirgule;
  lireUlex;
end;

procedure creerTable;
  begin
    lireUlex;

    repeat
      case tp of
        motConst0:     creerConst;
        TypeObjet:     creerTypeObjet;
        motProcedure0: creerProcedure;
        motFunction0:  creerFonction;
        motProperty0:  creerPropriete;
        motType0:      creerTypes;
        motPage:       creerPage;
        finFich:       fin:=true;
        else sortie(201);
      end;
    until Fin;
  end;

procedure compiler;
begin
  try
    creerTable;
  except
    on E: Exception do
      begin
        if errorRet=0 then
          begin
            raise;

          end;
      end;
  end;
  error:=errorRet;
end;

procedure creerFichierEmpile(nom:string);
  var
    f:text;
    i,numO:integer;
    code:word;
    st,st1:string[80];
    P:PdefProc;
    po:Pbyte;
    stOvr:string;
    numOvr:integer;
  begin
    stOvr:='';
    numOvr:=0;

    with tbdef do
    begin
      P:=adTab;
      assign(f,nom);
      rewrite(f);
      writeln(f,'procedure initAdressesProcedure(nb:integer;var err:integer);');
      writeln(f,'  begin');
      writeln(f,'    with adresseProcedure do');
      writeln(f,'    begin');
      writeln(f,'      init(nb,err);');
      writeln(f,'      if err<>0 then exit;');

      while P^.nom<>'' do
      begin
        if numOvr=0
          then stOvr:=''
          else stOvr:='_'+Istr(numOvr);

        if byte(P^.Vresult)<254 then
          begin
            st:=P^.nom +stOvr;

            if P^.ValObj1<>-1 then st:=tbObjet[p^.valObj1].stName+'_'+st;

            if P^.propriete<>prNone then
              begin
                writeln(f,'      empile(@fonction'+st+');');
                if P^.propriete=prReadWrite
                  then writeln(f,'      empile(@pro'+st+');');
              end
            else
            if st[1]<>'#' then
              begin
                if P^.Vresult=nbNul
                  then st:='pro'+st
                  else st:='Fonction'+st;
                writeln(f,'      empile(@'+st+');')
              end;

          end;

        if p^.Foverload
          then inc(numOvr)
          else numOvr:=0;

        P:=procedureSuivante(P);
      end;
      writeln(f,'    end;');
      writeln(f,'  end;');
      closeFile(f);
    end;
  end;


procedure sortieErreur(n:integer);
  begin
    case n of
      1:writeln1('Allocation source impossible');
      2:writeln1('Chargement source impossible');
    end;
  end;

function traiterVersion:integer;
var
  f:text;
  st:string;
  x,code:integer;
begin
  x:=0;
  try
  assignFile(f,repPAS+dacver+'.pas');
  reset(f);
  readln(f,st);
  readln(f,st);
  closeFile(f);
  except
  messageCentral('Unable to read '+ Dacver+'.pas');
  {$I-}closeFile(f);{$I+}
  end;

  delete(st,1,pos('=',st));
  if pos(';',st)>0 then delete(st,pos(';',st),length(st));
  st:=Fsupespace(st);
  val(st,x,code);
  inc(x);

  try
  assignFile(f,repPAS+dacver+'.pas');
  rewrite(f);
  writeln(f,'Const');
  writeln(f,'  DacVersion='+Istr(x)+';');
  closeFile(f);
  except
  messageCentral('Unable to write '+Dacver +'.pas');
  {$I-}closeFile(f);{$I+}
  end;

  result:=x;
end;

procedure traiterVersion1;
var
  f:text;
begin
  tbDef.version:= checkSum;
  try
  assignFile(f,repPAS+dacver+'.pas');
  rewrite(f);
  writeln(f,'Const');
  writeln(f,'  DacVersion='+Istr(checksum)+';');
  closeFile(f);
  except
  messageCentral('Unable to write '+Dacver +'.pas');
  {$I-}closeFile(f);{$I+}
  end;

end;

function Precompile(stMain,stF:string):integer;
var
  stFile:string;
  i,w:integer;
begin
  repPAS:= extractFilePath(stF);

  pcDef:=-1;
  fin:=false;
  error:=0;

  nbProcedure:=0;
  nbFonction:=0;
  nbProp:=0;
  nbMulti:=0;

  nbtypes:=0;

  nomFichier:=stF;
  if pos('.',nomFichier)>0
    then delete(nomFichier,pos('.',nomFichier),4);

  if pos('.',stMain)>0
    then delete(stMain,pos('.',stMain),4);

  tbDef:=TtabDefProc.create;
  with tbDef do
  begin

    //version:=traiterVersion;

    StList:=TUtextFile.create(stMain+'.FPS');
    Ulex1:=TUlex1.create(stList);

    {initUlex1(stMain+'.FPS');}

    allouerTab(1000000);
    allouerObj(1000);

    checksum:= -1;
    try
    Compiler;
    except
    end;

    {doneUlex1;}

    result:=errorRet;
    if errorRet<>0 then
    begin
      stFile:=stMain+'.fps';
      Ulex1.getLastPos(ligneC,colonneC,stFile);
      writeln1('Erreur nø'+Istr(errorRet)+' in '+ stFile +
                  '  ligne '+Istr(ligneC)+'   col '+Istr(colonneC));
      Ulex1.free;
      stList.Free;
      exit;
    end;

    Ulex1.free;
    stList.Free;

    TraiterVersion1;

    writeln1(Istr(nbProcedure)+' procédures');
    writeln1(Istr(nbFonction)+' fonctions');
    writeln1(Istr(nbProp)+' propriétés');

    CheckDefaultProp;
    sauver(nomFichier+'.prc');

    creerFichierEmpile(nomFichier+'.adr');

    {creerFichierTOU;}
    creerMPH(nomFichier+'.mph',nbmulti);

    writeln1('maxC='+Istr(maxC));

    writeln1('nbMulti='+Istr(nbMulti));
    writeln1('nbSymb='+Istr(nbSymb));
    writeln1('nbAlias='+Istr(nbAlias));

  end;


end;

procedure DispVersion;
begin
  writeln1('CheckSum = '+Istr(checksum));
end;

end.
