
unit procac2;


INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes, sysUtils,
     util1,Ncdef2,Dgraphic;


const
  IDH_types=10000;
  IDH_const=11000;
  IDH_multi=12000;
type

  {Dans la version Delphi, seul minP est utilisé et contient:
     le numéro d'objet
     le numéro de type de procédure
     l'intervalle des types autorisés pour variables entières ou réelles
   }
  typeParam=record
              tp:typeNombre;
              minP:Integer;
            end;

  PParam=^typeParam;


  TypeInfoConst=record
                  case tp:typeNombre of
                    nbSmall:   (i:smallInt);
                    nbLong:    (l:longint);
                    nbExtended:(r:float);
                    nbBoole:   (b:boolean);
                    nbchar:    (c:char);
                    nbChaine: (stc:String[255]);
                  end;
  PInfoConst=^TypeInfoConst;

  Tpropriete=(prNone,prReadWrite,prReadOnly);

  typeDefProc=object
                numero:integer;    { numéro d'ordre permettant de trouver }
                                   { l'adresse dans la table des adresses }
                                   { des procédures. }
                                   { Pour un alias, contient le déplacement }
                                   { de la procédure modèle }
                                   { Pour une constante, contient un numéro }
                                   { de groupe utile pour l'aide en ligne }
                next:integer;      { indique le suivant dans la recherche}
                                   { avec fonction de hachage }
                                   { =-1 pour le dernier }
                nbParam:byte;      { nombre de paramètres }
                ValObj1:smallint;  { Objet associé à la méthode }
                                   { -1=procédure ou fonction ordinaire }
                valObj2:smallint;  { Objet redéclarant la même méthode. La méthode
                                     ne s'appliquera donc qu'aux descendants de
                                     valObj1 de numéro < valObj2 }
                propriete:Tpropriete;
                                   { une propriété  est stockée comme une }
                                   { méthode fonction, mais avec ce flag }
                                   { en plus }
                Vresult:typeNombre;{ type du résultat pour les fonctions }
                                   { nbNul pour les procédures }
                                   { =255 s'il s'agit d'un alias }
                                   { =254 pour une constante }

                Obresult:integer;  { type d'objet quand Vresult=refObject }
                                   { index procedure si Vresult=refProcedure}
                                   { -1 pour TanyProcedure }
                Foverload:boolean; { signale que la déclaration suivante est identique }

                nom:shortString;   { nom de la procédure }
                { Immédiatement après la chaîne on a:
                  param:array[1..nbparam] of typeParam;
                  ou typeInfoConst
                }

                procedure init(NomP:AnsiString;num:Integer);
                function setParam(t:typeNombre;min:integer):integer;
                procedure setObj(val:integer);
                procedure setResult(res:typeNombre;resObj:integer);
                function getParam(n:integer):PParam;
                procedure setConstante(t:typeNombre;var x);
                function getConstante:PinfoConst;
                procedure setProperty(pr:Tpropriete);
              end;

const
  Kdep:integer=21;    { taille de la partie fixe de typeDefProc }
                      { on inclut l'octet longueur de chaine de nom }
                      { la taille de typeDefProc est
                          Kdep+length(nom)+word(nbParam)*sizeof(typeParam) }

  NbCle=500;
  nbCleO=128;

{
type
  tabString=array[1..2000] of Pshortstring;
  PtabString=^tabString;
}

type
  PdefProc=^typeDefProc;

  TobjectInfo=record
                stName:string[25];
                defaultProc:integer;
                ImplicitProc:integer;
              end;

  TTabDefProc=
             class
               tbCle:array[0..nbCle-1] of integer; { table des adresses des premiers }
                                           { éléments de la liste hachée }
               adTab:pointer;              { début de la table }
               nbSymb:Integer;             { nombre de symboles }
               nbPrc:Integer;              { nombre de procédures}
               nbAlias:integer;
               tailleTab:integer;          { taille du bloc alloué }
               Pfin:PdefProc;
               Plast:PdefProc;

               nbTypeObjet:Integer;
               nbTypeObMax:Integer;
               tbObjet:array of TobjectInfo;
               tbAncetre:PtabEntier1;

               nbOc:PtabOctet1;          {nombres d'occurences d'un mot}
               tailleNbOc:integer;

               version:integer;
               GroupeConst:integer;


               tbCleO:array[0..nbCleO-1] of TstringList;


               constructor create;
               destructor destroy;override;
               procedure allouerTab(t:integer);
               procedure allouerObj(nb:integer);

               procedure liberer;
               function procedureSuivante(Pdef:PdefProc):PdefProc;
               function getNumProc1(nomP:AnsiString;var Pdef:PdefProc;
                                    ValOb:Integer):Integer;
                 { recherche avec fonction de hachage
                   ValOb=-1 pour procédure ou fonction ordinaire }

               function getNumDefault(var Pdef:PdefProc;ValOb:Integer):Integer;
               function getNumImplicit(var Pdef:PdefProc;ValOb:Integer):Integer;

               function getNumProcHlp(nomP:AnsiString):Integer;
                 {renvoie le numéro de la première occurence}
               function getHlp(nomP:AnsiString;var nbFound:integer):integer;
                 {renvoie le numéro de la première occurence et le nombre
                  d'occurences }

               function getHTMLhlp(nomP:AnsiString;stList:TstringList):boolean;
               function getNumProcI(dep:integer):PdefProc;

               function sauver(nom:AnsiString): boolean;
               function charger(nom:AnsiString):boolean;

               procedure nouveauSymbole(st:AnsiString;proc:boolean);
               procedure SetAlias(st,st0:AnsiString);
               function setParam(t:typeNombre;min:Integer): integer;
               procedure setResult(res:typeNombre;resObj:integer);

               procedure setGroupeConst;
               procedure setConstante(t:typeNombre;var x);

               procedure creerFichierConstante(nom:AnsiString);
               procedure creerFichierMaxProc(nom:AnsiString);
               procedure creerFichierAlias(nom:AnsiString);

               function cle(st:AnsiString):integer;
               function maxC:Integer;
               procedure setObj(val:integer);
               procedure setProperty(pr:Tpropriete);

               function getNumObj(st:AnsiString):Integer;
               {renvoie un numéro d'objet compris entre 0 et nbtypeObjet-1
                renvoie -1 si l'objet n'existe pas}
               {procedure Descendants(ob:smallInt;var desc:setByte);}

               function ObjectName(num:integer):AnsiString;
               {num est compris entre 0 et  nbtypeObjet-1
                renvoie le nom dans la table}

               function getNumObj1(st:AnsiString):Integer;
               {Idem sans utiliser hachage}

               procedure BuildNbOc;
               procedure creerMPH(nom:AnsiString;var nbMulti:integer);


               function IsChild(a,b:integer):boolean;
               procedure setLastObj(stMot:AnsiString;vob:integer);

               function cleO(st:AnsiString):integer;
               procedure checkOverload;
               function numberOfOverload(p:PdefProc):integer;

               procedure setDefaultProp;
               procedure setImplicitProp;

               procedure CheckDefaultProp;

             end;



IMPLEMENTATION

{******************** Méthodes de typeDefProc ******************************}

procedure typeDefProc.init(NomP:AnsiString;num:Integer);
  begin
    numero:=num;
    next:=-1;
    Vresult:=nbNul;
    ObResult:=0;
    nbParam:=0;
    ValObj1:=-1;
    ValObj2:=-1;

    nom:=nomP;
    nom:=Fmaj(nom);
    propriete:=prNone;

  end;

function typeDefProc.setParam(t:typeNombre;min:Integer): integer;
  var
    p:PParam;
  begin
    p:=@numero;
    inc(intG(p),Kdep+length(nom)+word(nbParam)*sizeof(typeParam));
    inc(nbParam);
    with p^ do
    begin
      tp:=t;
      minP:=min;
    end;
    result:=nbparam;
  end;

procedure typeDefProc.setObj(val:integer);
  begin
    valObj1:=val;
  end;


procedure typeDefProc.setResult(res:typeNombre;resObj:integer);
  begin
    Vresult:=res;
    Obresult:=resObj;
  end;

procedure typeDefProc.setConstante(t:typeNombre;var x);
  var
    p:PInfoConst;
  begin
    byte(Vresult):=254;
    p:=@numero;
    inc(intG(p),Kdep+length(nom));
    P^.tp:=t;
    case t of
      nbSmall:     P^.i:=smallInt(x);
      nbLong:      P^.l:=longint(x);
      nbExtended:  P^.r:=float(x);
      nbchar:      P^.c:=char(x);
      nbchaine:    P^.stc:=AnsiString(x);
      nbBoole:     P^.b:=boolean(x);
    end;
  end;

function typeDefProc.getConstante:PinfoConst;
  var
    p:PInfoConst;
  begin
    p:=@numero;
    inc(intG(p),Kdep+length(nom));
    getConstante:=p;
  end;

function typeDefProc.getParam(n:integer):PParam;
  var
    p:PParam;
  begin
    p:=@numero;
    inc(intG(p),Kdep+length(nom)+(n-1)*sizeof(typeParam));
    getParam:=p;
  end;

procedure typeDefProc.setProperty(pr:Tpropriete);
  begin
    propriete:=pr;
  end;

{******************** Méthodes de TTabDefProc ***************************}

constructor TtabDefProc.create;
var
  i:integer;

begin
  for i:=0 to nbcle-1 do tbCle[i]:=-1;
  adTab:=nil;
  nbSymb:=0;
  nbPrc:=0;
  nbAlias:=0;
  tailleTab:=0;
  Pfin:=nil;

  nbTypeObMax:=0;
  nbTypeObjet:=0;
  
  tbAncetre:=nil;
  nbOc:=nil;

  for i:=0 to nbCleO-1 do tbCleO[i]:=TstringList.create;
end;

destructor TtabDefProc.destroy;
var
  i:integer;
begin
  for i:=0 to nbCleO-1 do tbCleO[i].free;
  liberer;
  inherited;
end;

procedure TtabDefProc.allouerTab(t:integer);
  begin
    if t<maxAvail then
      begin
        getmem(adtab,t);
        tailleTab:=t;
        fillchar(adTab^,t,0);
        Pfin:=adTab;
      end;
  end;

procedure TtabDefProc.allouerObj(nb:integer);
  var
    i:integer;
  begin
    nbTypeObMax:=0;

    setLength(tbObjet,nb);
    for i:=0 to nb-1 do
    with tbObjet[i] do
    begin
      stName:='';
      defaultProc:=-1;
      implicitProc:=-1;
    end;

    getmem(tbAncetre,sizeof(smallint)*nb);
    for i:=1 to nb do tbAncetre^[i]:=-1;

    nbTypeObMax:=nb;
  end;

procedure TtabDefProc.liberer;
  begin
    if tailleTab<>0 then
      begin
        freemem(adTab,tailleTab);
        tailletab:=0;
        adtab:=nil;
      end;

    setlength(tbObjet,0);

    if nbOc<>nil then
      begin
        freemem(nbOc,tailleNbOc);
        nbOc:=nil;
      end;
  end;

function TtabDefProc.procedureSuivante(Pdef:PdefProc):PdefProc;
  var
    k:Integer;
    p:PInfoConst;
  begin
    with Pdef^ do
    begin
      k:=Kdep+length(nom)+word(nbParam)*sizeof(typeParam);
      if byte(Vresult)=254 then
        begin
          p:=pointer(Pdef);
          inc(intG(p),k);
          case p^.tp of
            nbSmall:       k:=k+3;
            nbLong:        k:=k+5;
            nbExtended:    k:=k+11;
            nbBoole,nbchar:k:=k+2;
            nbChaine:      k:=k+2+length(p^.stc);
          end;
        end;
      inc(intG(Pdef),k);
    end;

    procedureSuivante:=Pdef;
  end;


function TtabDefProc.getNumProc1(nomP:AnsiString;var Pdef:PdefProc;
                                    ValOb:integer):integer;
  var
    i,j:Integer;
    Pdef0,Pmod,oldPdef:PdefProc;
    n:Integer;
  const
    cnt:integer=0;

  begin
    inc(cnt);
    getNumProc1:=0;
    Pdef0:=nil;
    Pdef:=nil;

    nomp:=Fmaj(nomP);

    i:=tbCle[cle(nomP)];
    if i=-1 then exit;


    while i<>-1 do
    begin
      oldPdef:=nil;
      Pdef0:=adTab;
      inc(intG(Pdef0),i);
      if Pdef0^.nom=nomp then
        begin
          if byte(Pdef0^.Vresult)=255 then   {Alias}
            begin
              oldPdef:=Pdef0;
              Pmod:=adtab;
              inc(intG(Pmod),Pdef0^.numero); {sauter directement à la vraie procédure }
              Pdef0:=Pmod;
            end;

          if (valOb=-1) and (Pdef0^.valObj1=-1) then {procédure ordinaire }
            begin
              getNumProc1:=Pdef0^.numero;
              Pdef:=Pdef0;
              exit;
            end
          else
          if valOb>=0 then                            {méthode}
            begin
              if IsChild(valOb,pdef0^.valObj1) and
                 not(assigned(Pdef) and (Pdef^.nom=Pdef0^.nom) and (Pdef^.valObj1=Pdef0^.valObj1)) then
              begin
                getNumProc1:=Pdef0^.numero;
                Pdef:=Pdef0;
              end;

             { on continue la recherche. La table peut contenir deux noms identiques}
            end;
        end;
      if oldPdef<>nil then Pdef0:=oldPdef;
      i:=Pdef0^.next;
    end;
  end;


function TtabDefProc.getNumProcI(dep:integer):PdefProc;
begin
  result:=pointer( intG(adTab)+dep);
end;



function TtabDefProc.sauver(nom:AnsiString): boolean;
var
  f:TfileStream;
  tailleSauve:integer;
  nbId:integer;
begin
  Pfin:=adTab;
  while Pfin^.nom<>'' do Pfin:=procedureSuivante(Pfin);

  f:=nil;
  result:=false;
  try
    f:=TfileStream.create(nom,fmCreate);

    f.Write(version,sizeof(version));

    f.Write(tbCle,sizeof(tbCle));
    f.Write(nbPrc,sizeof(nbPrc));
    f.Write(nbSymb,sizeof(nbSymb));
    tailleSauve:=intG(Pfin)-intG(adTab)+4;

    f.Write(tailleSauve,sizeof(tailleSauve));
    f.Write(adTab^,tailleSauve);

    f.Write(nbTypeObjet,sizeof(nbTypeObjet));
    f.Write(tbObjet[0],sizeof(TObjectInfo)*nbTypeObjet);
    f.Write(tbAncetre^,nbtypeObjet*sizeof(smallint));

    f.free;
    result:=true;
  except
    f.free;
  end;
end;

function TtabDefProc.charger(nom:AnsiString): boolean;
  var
    f:TfileStream;
    res:intG;
    t:int64;
    tailleSauve:Integer;
    i:integer;
    nbId: integer;
    ft:text;
  begin
    f:=nil;
    result:=false;
    try
    f:=TfileStream.create(nom,fmOpenRead);
    t:=f.size;

    f.Read(version,sizeof(version));

    f.Read(tbCle,sizeof(tbCle));
    f.Read(nbprc,sizeof(nbprc));
    f.Read(nbsymb,sizeof(nbsymb));
    f.Read(tailleSauve,sizeof(tailleSauve));
    allouerTab(tailleSauve);
    if tailletab=0 then exit;
    f.Read(adTab^,tailleTab);

    f.Read(nbTypeObjet,sizeof(nbTypeObjet));
    if nbTypeObjet<>0 then
      begin
        allouerObj(nbTypeObjet);
        if nbTypeObMax=0 then
          begin
            liberer;
            exit;
          end;

        f.Read(tbObjet[0],sizeof(TObjectInfo)*nbTypeObjet);
        f.Read(tbAncetre^,nbtypeObjet*sizeof(smallint));
      end;
    f.Free;
    result:=true;
    except
    f.free;
    end;

    Pfin:=adTab;
    inc(intG(Pfin),tailleTab-4);
    {
    assign(ft,debugPath+'objets.txt');
    GrewriteT(ft);
    for i:=1 to nbtypeObjet do
      GwritelnT(ft,tbObjet^[i]);
    GcloseT(ft);
    }
    for i:=1 to nbTypeObjet do
        tbCleO[cleO(Fmaj(tbObjet[i-1].stName))].addObject(Fmaj(tbObjet[i-1].stName),pointer(i-1));

    //CheckDefaultProp;
  end;


procedure TtabDefProc.nouveauSymbole(st:AnsiString;proc:boolean);
  var
    last:PdefProc;
    cle0:Integer;
    st1:shortString;
  begin
    st1:=Fmaj(st);
    cle0:=cle(st1);
    last:=nil;

    Plast:=Pfin;
    Pfin:=adTab;

    while Pfin^.nom<>'' do
    begin
      if cle(Pfin^.nom)=cle0 then last:=Pfin;
      Pfin:=procedureSuivante(Pfin);
    end;
    inc(nbSymb);
    if proc then
      begin
        inc(nbprc);
        Pfin^.init(st1,nbPrc);
      end
    else Pfin^.init(st1,-1);
    if last=nil then tbCle[cle0]:=intG(Pfin)-intG(adTab)
                else last^.next:= intG(Pfin)-intG(adTab);

  end;
(*
procedure TtabDefProc.SetAlias(st,st0:AnsiString);
  var
    last:PdefProc;
    cle0:Integer;
    Pmod:PdefProc;
    stN:AnsiString;
  begin
    inc(nbAlias);
    stN:=st;
    st:=Fmaj(st);
    st0:=Fmaj(st0);
    cle0:=cle(st);
    last:=nil;
    Pfin:=adTab;
    while Pfin^.nom<>'' do
    begin
      if cle(Pfin^.nom)=cle0 then last:=Pfin;
      if Pfin^.nom=st0 then
        begin
          Pmod:=Pfin;
        end;
      Pfin:=procedureSuivante(Pfin);
    end;
    Pfin^.init(st,intG(Pmod)-intG(adtab));
    byte(Pfin^.Vresult):=255;
    if last=nil then tbCle[cle0]:=intG(Pfin)-intG(adTab)
                else last^.next:= intG(Pfin)-intG(adTab);
  end;
*)
procedure TtabDefProc.SetAlias(st,st0:AnsiString);
  var
    last:PdefProc;
    cle0:Integer;
    Pmod:PdefProc;
    stN:AnsiString;
  begin
    inc(nbAlias);
    stN:=st;
    st:=Fmaj(st);
    st0:=Fmaj(st0);
    cle0:=cle(st);
    last:=nil;

    Plast:=Pfin;       {Pfin pointe sur le dernier modèle}
    Pmod:=nil;         {On cherche le 1er modèle de la liste des overload}

    Pfin:=adTab;
    while Pfin^.nom<>'' do
    begin
      if cle(Pfin^.nom)=cle0 then last:=Pfin;

      if (Pmod=nil) and (Plast<>nil) and (Pfin^.nom=Plast^.nom) and (Pfin^.ValObj1=Plast^.ValObj1)
        then Pmod:=Pfin;

      Pfin:=procedureSuivante(Pfin);
    end;

    Pfin^.init(st,intG(Pmod)-intG(adtab));
    byte(Pfin^.Vresult):=255;
    if last=nil then tbCle[cle0]:=intG(Pfin)-intG(adTab)
                else last^.next:= intG(Pfin)-intG(adTab);
  end;



function TtabDefProc.setParam(t:typeNombre;min:integer): integer;
  begin
    result:= Pfin^.setParam(t,min);
  end;

procedure TtabDefProc.setObj(val:integer);
  begin
    Pfin^.setObj(val);
  end;


procedure TtabDefProc.setLastObj(stMot:AnsiString;vob:integer);
  var
    pdef:PdefProc;
  begin
    stMot:=Fmaj(stMot);
    Pdef:=adTab;
    while Pdef^.nom<>'' do
    begin
      if (Pdef^.nom=stMot) and IsChild(vob,Pdef^.valObj1)
        and (vob<>Pdef^.valObj1) and (Pdef^.valObj2=-1) then
        begin
          Pdef^.valObj2:=vob;
          {messageCentral(stMot+' '+Istr(vob)+' '+tbObjet^[vob+1]);}
        end;
      Pdef:=procedureSuivante(Pdef);
    end;
  end;

procedure TtabDefProc.setResult(res:typeNombre;resObj:integer);
  begin
    Pfin^.setResult(res,resObj);
  end;

procedure TtabDefProc.setGroupeConst;
begin
  inc(groupeConst);
end;

procedure TtabDefProc.setConstante(t:typeNombre;var x);
  var
    p,p1:pdefProc;
    st:AnsiString;
  begin
    Pfin^.setConstante(t,x);
                               {Il vaudrait mieux que chaque groupe Const
                                définisse un nouveau groupe.
                                Donc, ajouter setConstGroup.
                                }

    Pfin^.numero:=IDH_const+groupeConst;

  end;

procedure TtabDefProc.setProperty(pr:Tpropriete);
  begin
    Pfin^.setProperty(pr);
    if pr=prReadWrite then inc(nbprc);
  end;

procedure TtabDefProc.creerFichierConstante(nom:AnsiString);
  var
    f:text;
    num:Integer;
    P:PdefProc;
    st:shortString;
  begin
    num:=1;
    P:=adTab;

    try
    assignFile(f,nom);
    rewrite(f);
    writeln(f,'Const');
    while P^.nom<>'' do
    begin
      if (byte(P^.Vresult)<254) and (P^.ValObj1=-1) then
        begin
          st:=P^.nom;
          if pos('.',st)>0 then st[pos('.',st)]:='_';
          if P^.numero<255
            then writeln(f,'  PF_'+st+'='+Istr(P^.numero)+';');
        end;
      P:=procedureSuivante(P);
      inc(num);
    end;
    closeFile(f);
    except
    closefile(f);
    end;
  end;


procedure TtabDefProc.creerFichierAlias(nom:AnsiString);
  var
    f:text;
    P,P1:PdefProc;
  begin
    P:=adTab;

    try
    assignFile(f,nom);
    rewrite(f);

    while P^.nom<>'' do
    begin
      p1:=p;
      P:=procedureSuivante(P);
      if byte(P^.Vresult)=255
        then writeln(f,Jgauche(P1^.nom,40)+Jgauche(P^.nom,40));
    end;
    closeFile(f);
    except
    closeFile(f);
    end;
    
  end;

procedure TtabDefProc.creerFichierMaxProc(nom:AnsiString);
  var
    f:text;
  begin
    try
    assignFile(f,nom);
    rewrite(f);
    writeln(f,'Const');
    writeln(f,'  MaxProcedure='+Istr(nbPrc)+';');
    closeFile(f);
    except
    closeFile(f);
    end;
  end;

function TtabDefProc.cle(st:AnsiString):integer;
type
  Tdd=record
        x,y:longWord;
      end;
var
  w:Tdd;
  ww:double absolute w;
  st1:string[7] absolute w;
  begin
    ww:=0;
    st1:=st;
    result:=(w.x+w.y) mod nbcle;
  end;

function TtabDefProc.cleO(st:AnsiString):integer;
type
  Tdd=record
        x,y:longWord;
      end;
var
  w:Tdd;
  ww:double absolute w;
  st1:string[7] absolute w;
  begin
    ww:=0;
    st1:=st;
    result:=(w.x+w.y) mod nbcleO;
  end;


function TtabDefProc.maxC:integer;
  var
    i,j,n,max:integer;
    Pdef:PdefProc;
    f:text;
  begin
    try
    assignFile(f,debugPath+'cle.txt');
    rewrite(f);
    max:=0;

    for j:=0 to nbCle-1 do
      begin
        i:=tbCle[j];
        n:=0;
        while i<>-1 do
        begin
          Pdef:=adTab;
          inc(intG(Pdef),i);
          i:=Pdef^.next;
          inc(n);
        end;
        if n>max then max:=n;
        writeln(f,Istr(n));
      end;
    maxC:=max;
    closeFile(f);

    except
    closeFile(f);
    end;
  end;

function TtabDefProc.getNumObj(st:AnsiString):integer;
var
  cle1,i:integer;
begin
  st:=Fmaj(st);
  cle1:=cleO(st);

  with tbCleO[cle1] do
  begin
    result:=indexof(st);
    if result>=0
      then result:=intG(objects[result]);
  end;
end;

function TtabDefProc.ObjectName(num:integer):AnsiString;
begin
  result:=tbObjet[num].stName;
end;

function TtabDefProc.getNumObj1(st:AnsiString):integer;
var
  i:integer;
begin
  st:=Fmaj(st);
  result:=-1;
  for i:=1 to nbTypeObjet do
    if Fmaj(tbObjet[i-1].stName)=st then
      begin
        result:=i-1;
        exit;
      end;
end;


(*
procedure TtabDefProc.Descendants(ob:smallInt;var desc:setByte);
  var
    i:smallInt;
  begin
    {writeln('ob=',ob);}
    desc:=[ob];
    for i:=1 to nbTypeObjet do
      if (tbAncetre^[i]<>-1) and (tbAncetre^[i] in desc)
        then desc:=desc+[i-1];
  end;
*)

procedure TtabDefProc.BuildNbOc;
  var
    p:PdefProc;
    i:integer;

  procedure traiter(p0:pdefProc);
  var
    p:PdefProc;
    num:integer;
  begin
    p:=adTab;
    num:=1;
    while P^.nom<>P0^.nom do
    begin
      inc(num);
      P:=procedureSuivante(P);
    end;

    inc(nboc^[num]);
  end;

  begin
    tailleNbOc:=0;
    p:=adtab;
    while p^.nom<>'' do
    begin
      inc(tailleNbOc);
      p:=procedureSuivante(p);
    end;

    getmem(nbOc,tailleNbOc);
    fillchar(nbOc^,tailleNbOc,0);

    P:=adTab;
    while P^.nom<>'' do
    begin
      traiter(p);
      P:=procedureSuivante(P);
    end;


  end;

procedure TtabDefProc.creerMPH(nom:AnsiString;var nbMulti:integer);
  var
    f:text;
    st,stCom:AnsiString;
    P,P1,Pmod:PdefProc;
    numO,i:integer;
    oldStConst:AnsiString;
    pob:Pbyte;
  begin
    oldStConst:='';

    try
    assignFile(f,nom);
    rewrite(f);

    for i:=1 to nbTypeObjet do
      writeln(f,'#define IDH_'+Jgauche(tbObjet[i-1].stName,40)+Istr(IDH_types+i));
    writeln(f,'');

    P:=adTab;

    numO:=0;
    nbMulti:=0;

    buildNbOc;

    while P^.nom<>'' do
    begin
      st:=P^.nom;
      inc(numO);

      if nbOc^[numO]>1 then
        begin
          stCom:='      // '+Istr(nbOc^[numO]);
          inc(nbMulti);
        end
      else stCom:='';

      if byte(P^.Vresult)<254 then { proc‚dures}
        begin
          pob:=pointer(P);
          with P^ do
            inc(intG(pob),Kdep+length(nom)+word(nbParam)*sizeof(typeParam));

          P1:=procedureSuivante(P);
          if byte(p1^.Vresult)=255 then st:=p1^.nom;

          if (P^.valObj1<>-1) then st:=tbObjet[P^.valObj1].stName+'_'+st;

          writeln(f,'#define IDH_'+Jgauche(st,40)+Istr(P^.numero)+stCom);
          if nbOc^[numO]>1 then
            writeln(f,'#define IDH_'+Jgauche(st+'_MULTI',40)+Istr(P^.numero+IDH_multi));
        end
      else
      if byte(P^.Vresult)=254 then { Constantes}
        begin
          {On ne fait rien  }
        end;

      P:=procedureSuivante(P);
    end;

    closeFile(f);
    except
    closeFile(f);
    end;

  end;


function TtabDefProc.IsChild(a,b:integer):boolean;
begin
  repeat
    if a=b then
      begin
        IsChild:=true;
        exit;
      end;
    a:=tbAncetre^[a+1];
  until (a=-1);

  IsChild:=false;
end;

function TtabDefProc.getNumProcHlp(nomP:AnsiString):integer;
  var
    i:integer;
    Pdef,Pmod:PdefProc;
  begin
    i:=getNumObj(nomP);
    if i>=0 then
      begin
        getNumProcHlp:=IDH_types+i+1;
        exit;
      end;

    getNumProcHlp:=0;
    nomp:=Fmaj(nomP);

    i:=tbCle[cle(nomP)];
    if i=-1 then exit;


    while i<>-1 do
    begin
      Pdef:=adTab;
      inc(intG(Pdef),i);
      if Pdef^.nom=nomp then
        begin
          if byte(Pdef^.Vresult)=255 then   {Alias}
            begin
              Pmod:=adtab;
              inc(intG(Pmod),Pdef^.numero);
              {sauter directement à la vraie procédure }
              Pdef:=Pmod;
            end;

          getNumProcHlp:=Pdef^.numero;
          exit;
        end;
      i:=Pdef^.next;
    end;
  end;

function TtabDefProc.getHlp(nomP:AnsiString;var nbFound:integer):integer;
  var
    i:integer;
    Pdef,Pmod,oldPdef:PdefProc;
    res:integer;
  begin
    i:=getNumObj(nomP);
    if i>=0 then
      begin
        getHlp:=IDH_types+i+1;
        nbFound:=1;
        exit;
      end;

    nomp:=Fmaj(nomP);
    nbFound:=0;
    res:=0;

    i:=tbCle[cle(nomP)];
    if i=-1 then exit;

    while i<>-1 do
    begin
      oldPdef:=nil;
      Pdef:=adTab;
      inc(intG(Pdef),i);
      if Pdef^.nom=nomp then
        begin
          if byte(Pdef^.Vresult)=255 then   {Alias}
            begin
              oldPdef:=Pdef;
              Pmod:=adtab;
              inc(intG(Pmod),Pdef^.numero);
              {sauter directement à la vraie procédure }
              Pdef:=Pmod;
            end;

          inc(nbFound);
          if nbFound=1 then res:=Pdef^.numero;
        end;
      if oldPdef<>nil then Pdef:=oldPdef;
      i:=Pdef^.next;
    end;

    if nbFound>1 then res:=res+IDH_multi;
    getHlp:=res;
  end;

function TTabDefProc.getHTMLhlp(nomP:AnsiString;stList:TstringList):boolean;
var
  i:integer;
  Pdef,Pmod,Pnext:PdefProc;
  stName:AnsiString;
  FlagO:boolean;
begin
  stList.clear;

  i:=getNumObj(nomP);
  if i>=0 then
    begin
      stList.Add(tbObjet[i].stName);
      result:=true;
      exit;
    end;

  nomp:=Fmaj(nomP);

  i:=tbCle[cle(nomP)];
  if i=-1 then
  begin
    result:=false;
    exit;
  end;

  FlagO:=false;
  while i<>-1 do
  begin
    Pdef:=adTab;
    inc(intG(Pdef),i);
    if Pdef^.nom=nomp then
      begin
        Pnext:=Proceduresuivante(Pdef);
        if assigned(Pnext) and (byte(Pnext^.Vresult)=255)  {Alias}
          then Pmod:=Pnext
          else Pmod:=Pdef;

        if Pmod^.ValObj1=-1
          then stName:=Pmod^.nom
          else stName:=tbObjet[Pmod^.ValObj1].stName+'.'+Pmod^.nom;

        if not FlagO then stList.Add(stName);

        FlagO:=Pmod^.Foverload;
      end;
    i:=Pdef^.next;
  end;
  result:=true;

end;



procedure TTabDefProc.checkOverload;
begin
  if (Plast<>nil) and (Plast^.nom=Pfin^.nom) and (Plast^.ValObj1=Pfin^.ValObj1)
    then Plast^.Foverload:=true;
end;

function TTabDefProc.numberOfOverload(p: PdefProc): integer;
var
  p1:PdefProc;
begin
  p1:=p;
  result:=0;
  while (p1<>nil) and (p1^.nom=p^.nom) and (p1^.ValObj1=p^.ValObj1) do
  begin
    inc(result);
    p1:=procedureSuivante(p1);
  end;
end;

procedure TTabDefProc.setDefaultProp;
begin
  with Pfin^ do
    if tbObjet[valObj1].defaultProc=-1
      then tbObjet[valObj1].defaultProc:=intG(Pfin)-intG(adtab);
end;

function TtabDefProc.getNumDefault(var Pdef:PdefProc;ValOb:integer):integer;
begin
  with tbObjet[valob] do
    if defaultProc>=0 then
    begin
      Pdef:=pointer(intG(adtab)+defaultProc);
      result:=Pdef^.numero;
    end
    else result:=-1;
end;

procedure TTabDefProc.setImplicitProp;
begin
  with Pfin^ do tbObjet[valObj1].ImplicitProc:=intG(Pfin)-intG(adtab);
end;

function TtabDefProc.getNumImplicit(var Pdef:PdefProc;ValOb:integer):integer;
begin
  with tbObjet[valob] do
  if ImplicitProc>=0 then
  begin
    Pdef:=pointer(intG(adtab)+ImplicitProc);
    result:=Pdef^.numero;
  end
  else result:=-1;
end;


procedure TTabDefProc.CheckDefaultProp;
var
  i,n:integer;
begin
  for i:=0 to nbTypeObjet-1 do
  begin
    if tbObjet[i].defaultProc = -1 then
    begin
      n:=i;
      while tbAncetre^[n+1]>=0 do
      begin
        n:= tbAncetre^[n+1];
        if tbObjet[n].defaultProc>=0 then
        begin
          tbObjet[i].defaultProc:= tbObjet[n].defaultProc;
          break;
        end;
      end;
    end;
  end;
end;


end.


