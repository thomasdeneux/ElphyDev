unit precomp2;

INTERFACE

uses
  SysUtils,
  util1,Gdos,DUlex1,Ncdef2,procac2;

type
  Twriteln=procedure (st:string) of object;

var
  writeln1:Twriteln;

function precompile(stF:string):integer;

IMPLEMENTATION

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

  maxTypes=200;
  nbtypes:integer=0;
var
  tbTypes:array[1..maxTypes] of string;
  depTypes:array[1..maxTypes] of integer;


var

  tbDef:TTabDefProc;
  tp:typeLex;
  stMot,stMot0:ShortString;
  x0:float;
  vob:integer;
var
  errorRET:integer;

  NomFichier:string[80];

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
      nomDeType:  begin
                     tpnb:=refProcedure;
                     mini:=numRefProc;
                   end;
      {motFunction: begin
                     tpnb:=refFunction;
                     mini:=numRefProc;
                   end;}
      TPObject:    begin
                    tpnb:=refObject;
                    mini:=vob;
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


procedure creerCorps(proc:boolean);
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
    mini,maxi:integer;
  begin
     lireUlex;
     creerCorps(true);
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
     creerCorps(true);
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
      writeln1('Objet==>'+stmot);
      lireUlex;
      if tp=parou then
        with tbdef do
        begin
          lireUlex;
          tbdef.tbAncetre^[nbTypeObjet]:=getNumObj(stMot);
          if tbAncetre^[nbTypeObjet]=255 then
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
          creerCorps(false);
        end
      else
      if tp=motFunction then
        begin
          tp:=motNouveau;
          creerCorps(false);
          accepte(DeuxPoint);
          lireUlex;
          creerType(tpnb,mini,maxi);
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
            if st[1]<>'#' then
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
      1:writeln1('Allocation source impossible');
      2:writeln1('Chargement source impossible');
    end;
  end;


function Precompile(stF:string):integer;
begin
  nomFichier:=stF;
  if pos('.',nomFichier)=0 then nomFichier:=nomFichier+'.FPS';


  delete(nomFichier,pos('.',nomFichier),4);


  tbDef:=TtabDefProc.create;
  with tbDef do
  begin
    initTabString;
    initUlex1(nomFichier+'.FPS');
    allouerTab(50000);
    allouerObj(100);

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

    creerFichierConstante(nomFichier+'.cte');
    creerFichierEmpile(nomFichier+'.adr');
    creerFichierMaxProc(nomFichier+'.mpr');
    creerFichierAlias(nomFichier+'.als');

    {creerFichierTOU;}
    creerMPH(nomFichier+'.mph',nbmulti);
    creerIndexProc(nomFichier+'.IPR');

    freeTabString;
    writeln1('maxC='+Istr(maxC));

    writeln1('nbMulti='+Istr(nbMulti));
    writeln1('nbSymb='+Istr(nbSymb));
    writeln1('nbAlias='+Istr(nbAlias));

  end;


end;

end.