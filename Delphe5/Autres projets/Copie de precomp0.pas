unit Precomp0;

INTERFACE

uses
  SysUtils,
  util1,Gdos,Dgraphic,DUlex1,Ncdef2,procac2;

type
  Twriteln=procedure (st:string) of object;

var
  writeln1:Twriteln;

function precompile(stMain,stF:string):integer;
{ stMain est le nom du fichier source principal FPS (qui contient des fichiers inclus FPS )
  Les fichiers inclus sont dans le même répertoire.

  stF est le nom du fichier destination (l'extension est sans importance). On crée:
    - le fichier .PRC
    - le fichier .adr    (inclus dans dacadp2.pas )
    - le fichier .mph    (utilisé par hcw: liste de #define)


}

IMPLEMENTATION

var
  version:integer;

const
  motPage=motProcess;

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
  motType=motEndProcess;
  NomDeType=motInitProcess;
  AnyProc=motInitProcess0;

  maxTypes=200;
  nbtypes:integer=0;
var
  tbTypes:array[1..maxTypes] of string;
  depTypes:array[1..maxTypes] of integer;


var

  tbDef:TTabDefProc;
  tp:typeLex;
  stMot,stMot0:String;
  x0:float;
  vob:integer;
var
  errorRET:integer;

  NomFichier:string;

  fAlias:text;

  numRefProc:integer;



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
        tp:=motPROCEDURE;
        NumrefProc:=0
      end
    else
    if st1='FUNCTION' then
      begin
        tp:=motFUNCTION;
        NumrefProc:=0;
      end
    else
    if st1='PROPERTY' then tp:=motProperty
    else
    if st1='READONLY' then tp:=motReadOnly
    else
    if st1='DEFAULT' then tp:=motDefault
    else
    if st1='IMPLICIT' then tp:=motImplicit
    else
    if st1='VAR' then tp:=motVAR
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
    if st1='CONST' then tp:=motConst
    else
    if st1='TYPE' then tp:=motType
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
      lireUlex1(buf^,0,PcDef,stMot,tp,x0,errorRet);
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


procedure creerListeVar;
  var
    i,nb,mini:integer;
    flag:boolean;
    tpnb:typeNombre;
  begin
    flag:=(tp=motVar);
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

    for i:=1 to nb do tbDef.setParam(tpNb,mini);
  end;


procedure creerCorps(proc:boolean);
  var
    desc:setByte;
    flagObj:boolean;
    valOb:integer;
  begin
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
        creerListeVar;
        while tp=pointVirgule do
          begin
            lireUlex;
            creerListeVar;
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

     if tp=motReadOnly then
     begin
       FreadOnly:=true;
       lireUlex;
     end;

     if tp=motDefault then
     begin
       Fdefault:=true;
       lireUlex;
     end;

     if tp=motImplicit then
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
             if not Fmoins then tbDef.setConstante(nbChaine,stMot)
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

      if tp=motProcedure then
        begin
          tp:=motNouveau;
          creerCorps(false);
        end
      else
      if tp=motFunction then
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
        motConst:     creerConst;
        TypeObjet:    creerTypeObjet;
        motProcedure: creerProcedure;
        motFunction:  creerFonction;
        motProperty:  creerPropriete;
        motType:      creerTypes;
        motPage:      creerPage;
        finFich:      fin:=true;
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
      GrewriteT(f);
      GwritelnT(f,'procedure initAdressesProcedure(nb:integer;var err:integer);');
      GwritelnT(f,'  begin');
      GwritelnT(f,'    with adresseProcedure do');
      GwritelnT(f,'    begin');
      GwritelnT(f,'      init(nb,err);');
      GwritelnT(f,'      if err<>0 then exit;');

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
                GwritelnT(f,'      empile(@fonction'+st+');');
                if P^.propriete=prReadWrite
                  then GwritelnT(f,'      empile(@pro'+st+');');
              end
            else
            if st[1]<>'#' then
              begin
                if P^.Vresult=nbNul
                  then st:='pro'+st
                  else st:='Fonction'+st;
                GwritelnT(f,'      empile(@'+st+');')
              end;

          end;

        if p^.Foverload
          then inc(numOvr)
          else numOvr:=0;

        P:=procedureSuivante(P);
      end;
      GwritelnT(f,'    end;');
      GwritelnT(f,'  end;');
      GcloseT(f);
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
  assignFile(f,debugPath+'dacver.pas');
  GresetT(f);
  GreadlnT(f,st);
  GreadlnT(f,st);
  GcloseT(f);
  if GIO<>0 then messageCentral('Impossible de lire dacver.pas');

  delete(st,1,pos('=',st));
  if pos(';',st)>0 then delete(st,pos(';',st),length(st));
  st:=Fsupespace(st);
  val(st,x,code);
  inc(x);
  if code<>0 then

  assignFile(f,debugPath+'dacver.pas');
  GrewriteT(f);
  GwritelnT(f,'Const');
  GwritelnT(f,'  DacVersion='+Istr(x)+';');
  GcloseT(f);
  if GIO<>0 then messageCentral('Impossible d''écrire dacver.pas');

  result:=x;
end;

function Precompile(stMain,stF:string):integer;
begin
  nomFichier:=stF;
  if pos('.',nomFichier)>0
    then delete(nomFichier,pos('.',nomFichier),4);

  if pos('.',stMain)>0
    then delete(stMain,pos('.',stMain),4);

  tbDef:=TtabDefProc.create;
  with tbDef do
  begin
    version:=traiterVersion;
    initUlex1(stMain+'.FPS');
    allouerTab(1000000);
    allouerObj(1000);

    Compiler;
    
    doneUlex1;

    result:=errorRet;
    if errorRet<>0 then
      if Finclus then
        begin
          coordonneesFinclus;
          writeln1('Erreur nø'+Istr(errorRet)+' '+nomFinclus+
                  '  ligne '+Istr(ligInclus)+'   col '+Istr(colInclus));
          exit;
        end
      else
        begin
          coordonneesF(pcdef,ligne,colonne);
          writeln1('Erreur nø'+Istr(errorRet)+'  ligne '+Istr(ligne)+'   col '+Istr(colonne));
          exit;
        end;


    writeln1(Istr(nbProcedure)+' procédures');
    writeln1(Istr(nbFonction)+' fonctions');
    writeln1(Istr(nbProp)+' propriétés');

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

end.