program Precomp;
{$APPTYPE CONSOLE}

  (*
PreComp réalise une précompilation pour le langage Elphy
A partir du fichier X.fps, 4 fichiers sont créés:
  - X.prc qui est une table des procédures et fonctions.
  - X.cte qui est une table des constantes (inutilisée?)
  - X.adr qui contient une liste d'instructions 'empile' devant être
   incorporée dans le module compilateur.

  - X.als qui contient une liste des procédures avec les synonymes.

Le fichier X.fps doit être rédigé en obéissant …à la grammaire suivante:

DefProcedure= motProc corpsProcedure ';'
DefFonction=  motFonc CorpsProcedure ':' type ';'
CorpsProcedure= mot [ '(' listeVar { ';' listeVar } ')' ]
listeVar= [ motVAR ] mot { ',' mot } [ ':' type ]
type= motBoolean | motChar | motString | motReal | motInteger | motLongInt |
      Intervalle | motProcedure | motFunction | motObject
Intervalle=NomDeTrace pointDouble NomDeTrace

Les commentaires doivent être entre accolades.
*)

uses
  SysUtils,
  util1,Gdos,DUlex1,Ncompdef,procac1;


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
  maxTypes=200;
  nbtypes:integer=0;
var
  tbTypes:array[1..maxTypes] of string;
  depTypes:array[1..maxTypes] of integer;


var

  tbDef:typeTabDefProc;
  tp:typeLex;
  stMot,stMot0:ShortString;
  x0:float;
  vob:integer;
var
  vCS,vCP,vBP,vSS,vSP:word;
  errorRET:integer;

  NomFichier:string[80];

  fAlias:text;

  numRefProc:integer;

procedure imprimeAnc;
  var
    i:integer;
  begin
    {
    writeln('--ANC');
    for i:=1 to nbTypeObjet do writeln(i:2,tbancetre[i]:5);
    writeln;}
  end;

procedure imprime(var desc:setByte);
  var
    i:integer;
  begin
    {
    writeln('-----');
    for i:=0 to 255 do
      if i in desc then writeln(i);
    writeln;
    }
  end;

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
          tp:=motProcedure;
          numRefProc:=depTypes[i];
          writeln(tbTypes[i],'  ','numRefProc=',depTypes[i]);
          exit;
        end;


    if copy(st1,1,9)='PROCEDURE' then
      begin
        tp:=motPROCEDURE;
        delete(st1,1,9);
        if st1='' then NumrefProc:=0
        else
          begin
            val(st1,NumRefProc,code);
            if (code<>0) or (numRefProc<=0) then tp:=motNouveau;
          end;
      end
    else
    if st1='FUNCTION' then
      begin
        tp:=motFUNCTION;
        delete(st1,1,8);
        if st1='' then NumrefProc:=0
        else
          begin
            val(st1,NumRefProc,code);
            if (code<>0) or (numRefProc<=0) then tp:=motNouveau;
          end;
      end
    else
    if st1='PROPERTY' then tp:=motProperty
    else
    if st1='READONLY' then tp:=motReadOnly
    else
    if st1='VAR' then tp:=motVAR
    else
    if st1='REAL' then tp:=motREAL
    else
    if st1='INTEGER' then tp:=motINTEGER
    else
    if st1='LONGINT' then tp:=motLONGINT
    else
    if st1='BOOLEAN' then tp:=motBOOLEAN
    else
    if st1='STRING' then tp:=motSTRING
    else
    if st1='OBJECT' then tp:=TPobject
    else
    if st1='END' then tp:=motEnd
    else
    if st1='CONST' then tp:=motConst
    else
    if st1='TYPE' then tp:=motType
    else
    if st1='HPAGE' then tp:=motPage
    else
      begin
        with tbdef do
        for i:=1 to nbTypeObjet do
          if Fmaj(tbObjet^[i])=st1 then
            begin
              tp:=TPObject;
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

procedure creerType(var tpnb:typeNombre;var mini,maxi:integer);
  var
    tp1:typeLex;
  begin
    mini:=0;
    maxi:=0;
    tp1:=tp;
    case tp of
      motReal:    tpnb:=nbReel;
      motInteger: tpnb:=nbEntier;
      motLongint: tpnb:=nbLong;
      motBoolean: tpnb:=nbBoole;
      motString:  tpnb:=nbChaine;
      motProcedure:begin
                     tpnb:=refProcedure;
                     mini:=numRefProc;
                   end;
      motFunction: begin
                     tpnb:=refFunction;
                     mini:=numRefProc;
                   end;
      TPObject:    begin
                    tpnb:=refObject;
                    mini:=vob;
                  end;
      else
        begin
          {writeln('tp=',ord(tp),'  ',stMot);}
          errorRet:=200;
        end;
    end;
    if errorRet<>0 then sortie(ErrorRet);
    if tp1<>trace then lireUlex;
  end;


procedure creerListeVar;
  var
    i,nb,maxi,mini:integer;
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
        creerType(tpNb,mini,maxi);
        if flag then
          case tpNb of
            nbReel:  tpnb:=RefReel;
            nbEntier:tpnb:=RefEntier;
            nbLong:  tpnb:=RefLong;
            nbBoole: tpnb:=RefBoole;
            nbChaine:tpnb:=RefChaine;
          end;
      end
    else
    if flag then tpNb:=RefVar
    else accepte(deuxPoint);

    for i:=1 to nb do tbDef.setParam(tpNb,mini,maxi);
  end;


procedure creerCorps;
  var
    desc:setByte;
    flagObj:boolean;
    valOb:integer;
  begin
    flagObj:=false;
    if tp=TPobject then
      begin
        flagObj:=true;
        valOb:=vob;
        lireUlex;
        accepte(point);
        lireUlex;
      end;
    accepte(motNouveau);

    tbDef.nouveauSymbole(stMot,true);
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
  end;


procedure creerProcedure;
  begin
     lireUlex;
     creerCorps;
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
    mini,maxi:integer;
  begin
     lireUlex;
     creerCorps;
     accepte(DeuxPoint);
     lireUlex;
     creerType(tpnb,mini,maxi);
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
    mini,maxi:integer;
    FreadOnly:boolean;
  begin
     lireUlex;
     creerCorps;
     accepte(DeuxPoint);
     lireUlex;
     creerType(tpnb,mini,maxi);
     tbDef.setResult(tpNb,mini);

     FreadOnly:= (tp=motReadOnly);
     if FreadOnly then lireUlex;

     accepte(pointVirgule);
     lireUlex;
     inc(nbProp);
     if FreadOnly
       then tbDef.setProperty(prReadOnly)
       else tbDef.setProperty(prReadWrite);

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
      tbdef.tbObjet^[tbdef.nbTypeObjet]:=stMot;
      writeln('Objet==>'+stmot);
      lireUlex;
      if tp=parou then
        with tbdef do
        begin
          lireUlex;
          tbdef.tbAncetre^[nbTypeObjet]:=getNumObj(stMot);
          if tbAncetre^[nbTypeObjet]=255 then
            begin
              writeln(stMot);
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
    writeln(tbdef.nbTypeObjet,' objets' );
    imprimeANC;
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
               tbDef.setConstante(nbEntier,i);
             end;
        nbL: begin
               if Fmoins then l:=-roundL(x0)
                         else l:=roundL(x0);
               tbDef.setConstante(nbLong,l);
             end;
        nbR: begin
               if Fmoins then r:=-x0
                         else r:=x0;
               tbDef.setConstante(nbreel,r);
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
    mini,maxi:integer;
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
          creerCorps;
        end
      else
      if tp=motFunction then
        begin
          tp:=motNouveau;
          creerCorps;
          accepte(DeuxPoint);
          lireUlex;
          creerType(tpnb,mini,maxi);
          tbDef.setResult(tpNb,mini);
        end
      else sortie(800);

      with tbDef do DepTypes[nbTypes]:=intG(Pfin)-intG(adTab);
      writeln('tp=',ord(tp),' type=',tbTypes[nbTypes],'  dep=',DepTypes[nbTypes]);
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
        TPObject:     creerTypeObjet;
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
        writeln('Exception ',E.message);
        if errorRet=0 then
          begin
            raise;

          end;
      end;
  end;

  writeln('error='+Istr(errorRet));
  read(ch);

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
  begin
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
        if byte(P^.Vresult)<254 then
          begin
            st:=P^.nom;
            if P^.ValObj1<>255 then st:=tbObjet^[p^.valObj1+1]+'_'+p^.nom;

            if P^.propriete<>prNone then
              begin
                GwritelnT(f,'      empile(@fonction'+st+');');
                if P^.propriete=prReadWrite
                  then GwritelnT(f,'      empile(@pro'+st+');');
              end
            else
              begin
                if P^.Vresult=nbNul
                  then st:='pro'+st
                  else st:='Fonction'+st;
                GwritelnT(f,'      empile(@'+st+');')
              end;

          end;

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
      1:writeln('Allocation source impossible');
      2:writeln('Chargement source impossible');
    end;
    halt(1);
  end;

procedure test;
var
  numeroProc:integer;
  Pdef:PdefProc;
begin
  writeln;
  NumeroProc:=TbDef.getNumProc1('clBlue',Pdef,-1);

  writeln(Pdef^.nom,'   numeroProc=',numeroProc);
  if NumeroProc<>0 then
    begin
       with Pdef^.getConstante^ do writeln('tp=',ord(tp),'  l= ',l);
    end;

end;

begin
   writeln;
  if paramCount=0 then
    begin
      writeln('Syntaxe: PRECOMP nomFichier');
      writeln(
    'PreComp1 réalise une précompilation pour le langage de Acquis1.');
      writeln(
    'A partir du fichier nomFichier, 4 fichiers sont créés:');
      writeln(
    '- NomFichier.prc qui est une table des procédures et fonctions.');
      writeln(
    '-NomFichier.cte qui est une table des constantes utilisées par instac1.');
      writeln(
    '-NomFichier.adr qui contient une liste d''instructions "empile" devant ');
      writeln(
    ' être incorporée dans le module de compilation.');

    read(ch);
    exit;
    end;

  nomFichier:=paramStr(1);
  if pos('.',nomFichier)=0 then nomFichier:=nomFichier+'.FPS';


  delete(nomFichier,pos('.',nomFichier),4);


  with tbDef do
  begin
    init;
    initTabString;
    initUlex1(nomFichier+'.FPS');
    allouerTab(50000);
    allouerObj(100);

    Compiler;


    doneUlex1;

    if errorRet<>0 then
      if Finclus then
        begin
          coordonneesFinclus;
          writeln('Erreur nø',errorRet,' ',nomFinclus,
                  '  ligne ',ligInclus,'   col ',colInclus);

          readln(ch);
          halt(1);
        end
      else
        begin
          coordonneesF(pcdef,ligne,colonne);
          writeln('Erreur nø',errorRet,'  ligne ',ligne,'   col ',colonne);
          {pcDef:=adDebutLigne(pcDef);
          writeln(stLigne(pcdef));}
          readln(ch);
          halt(1);
        end;

    writeln('ErrorRet=',errorRet);

    writeln(nbProcedure,' procédures');
    writeln(nbFonction,' fonctions');
    writeln(nbProp,' propriétés');

    sauver(nomFichier+'.prc');

    creerFichierConstante(nomFichier+'.cte');
    creerFichierEmpile(nomFichier+'.adr');
    creerFichierMaxProc(nomFichier+'.mpr');
    creerFichierAlias(nomFichier+'.als');

    {creerFichierTOU;}
    creerMPH(nomFichier+'.mph',nbmulti);
    creerIndexProc(nomFichier+'.IPR');

    freeTabString;
    writeln('maxC=',maxC);

    writeln('nbMulti='+Istr(nbMulti));
    writeln('nbSymb='+Istr(nbSymb));
    writeln('nbAlias='+Istr(nbAlias));


    readln(ch);
    
  end;


end.