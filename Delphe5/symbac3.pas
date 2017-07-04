unit symbac3;

{ 29-01-02: Bug Delphi ?
            La directive Alignement=1 n'a pas exactement le même effet que
            l'utilisation de Packed record.

            Il faut donc utiliser Packed record plutot que Align=1 pour obtenir
            un vrai compactage.


}
{ typeU défini par Déplacement + numéro unité (3 octets +1 octet)= longint

}

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,
     classes,sysutils,stdCtrls,
     util1,Dgraphic,Gdos,listG,Hlist0,
     Ncdef2,
     debug0,
     memoForm,
     stmObj;



type
  typeSymbole=(Sneant,Sconst,SconstLoc,Svar,SvarLoc,SprocU,Stab,
                      Sproc,SAlias,Sobject,Sreserved,Stype,Sfield);

const
  IdName:array[typeSymbole] of AnsiString=
    ('Nil','SConst','SconstLoc','Svar','SvarLoc','SprocU','Stab',
           'Sproc','Salias','Sobject','Sreserved','Stype','Sfield');

type
  TypeInfoConst=Packed record                        { pour Sconst ou SconstLoc }
                  numH:word;
                  case tp:typeNombre of
                    nbSmall:   (i:smallInt);
                    nbLong:    (l:longint);
                    nbExtended:(r:float);
                    nbBoole:   (b:boolean);
                    nbchar:    (c:Ansichar);
                    nbChaine:  (stc:String[255]);
                  end;


  typeRecTab=Packed record
               minT,maxT:integer;            { indices mini et maxi }
             end;

  typeInfoVar=Packed record                  { pour Svar, SvarLoc ou Sfield }
                tp:typeNombre;
                att0:integer;                { longueur de chaine, numéro objet ou Ad Def }
                deplacement:Integer;
                depTab:integer;              { position des infos tableau dans la table}
                varSize:integer;
              end;

  typeInfoTab=Packed record
                nbrang:byte;
                r:array[1..255] of typeRecTab;
              end;
  PinfoTab=^typeInfoTab;

  typeParamU=Packed record
               tp:typeNombre;
               numOb:integer;               { Numéro objet ou Ad Def}
             end;

  typeInfoProcU=Packed record                        { pour ProcU }
                  nbParam:byte;
                  result1:typeNombre;
                  adresse:integer;
                  TailleLoc:integer;
                  parametre:array[1..255] of typeParamU;
                end;

  Tpropriete=(propNone,propReadWrite,propReadOnly);

  typeInfoProc=Packed record
                 numero:integer;    { numéro d'ordre permettant de trouver }
                                    { l'adresse dans la table des adresses }
                                    { des procédures. }
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
                 Vresult:typeNombre; { type du résultat pour les fonctions }
                                    { nbNul pour les procédures }
                                    { =255 s'il s'agit d'un alias }
                                    { =254 pour une constante }

                 Obresult:word;     { type d'objet quand Vresult=refObject }

                 parametre:array[1..255] of typeParamU;
               end;

  typeInfoAlias= Packed record
                   DepModele:integer;
                 end;

  typeInfoRes= Packed record
                 Att:typeLex;
               end;

  typeInfoObjet= Packed record
                   num:word;
                 end;

  TNtype=(TNsimple,TNrecord,TNarray,TNenum,TNalias,TNclass);

const
  TNtypeName: array[TNtype] of string[10]=( 'TNsimple','TNrecord','TNarray','TNenum','TNalias','TNclass');

type
  typeInfoType=  Packed Record
                   case TNgenre:TNtype of
                     TNsimple: ( tpSimple:typeNombre);                             { Ttype = integer }
                     TNrecord: ( nbF:word; Field:array[1..1000] of integer);      { Ttype = record... }
                     TNarray:  ( tpA:typeNombre;                                  { Ttype = array[1..10] of .. }
                                 attA:integer;
                                 depTabA:integer;
                               );
                     TNenum:   ( nbE:word;                                        { Ttype = (point , virgule, ...) }
                                 stE:shortString;
                               );
                     TNalias:  ( AdDef:integer);                                  { Ttype = Type défini ailleurs , éventuellement dans une autre table }
                     TNclass:  ( nbFclass:word; Fclass:array[1..1000] of integer);{ Ttype = class... }
                 end;



  typeDefSymbole=Packed record
                 stLen:byte;             {Permet de remonter au nom du symbole: retirer stLen+3 à data }
                 LineNum:integer;
                 UnitNum:byte;           {Numéro d'unité absolu dans le primary file }
                 case ident:typeSymbole of
                    Sconst,SconstLoc:(infC:typeInfoConst);
                    Svar,SvarLoc,Sfield:
                                     (infV:typeInfoVar);
                    SprocU:          (infP:typeInfoProcU);
                    Stab:            (infT:typeInfoTab);
                    Sproc:           (infFPS:typeInfoProc);
                    Salias:          (infA:typeInfoAlias);
                    Sobject:         (infO:typeInfoObjet);
                    Sreserved:       (infoR:typeInfoRes);
                    Stype:           (infoType:typeInfoType);
                 end;

  PdefSymbole=^typeDefSymbole;

  TfreeThisObject=procedure (var p:pointer) of object;
  TObjectHasName=function (p:pointer;st:AnsiString):boolean of object;

  TobjectRec=Packed record
               ad:pointer;     {adresse de la variable }
               typ:word;       {type d'objet }
               stN:AnsiString;     {nom de l'objet}
             end;
  PobjectRec=^TobjectRec;

  PrecSymbole=PhashListRecord2;

type
  TtableSymbole=class;
  TtablesSymbole=array[0..255] of TtableSymbole;
  PtablesSymbole = ^TtablesSymbole;

  TtableSymbole=
               class (ThashList2)
               private
                 ObjList:TlistG;
                 DS0:pointer;


                 Idep0:integer;     { Déplacement zéro }
                                    { mis en place par initDeplacement}
                 IdebLocal:integer; { Début des var locales          }
                                    { mis en place par nouveau(procU)}
                 Iproc:integer;     { Procedure ou fonction }
                                    { mis en place par nouveau(procU)}

                 IfirstVar:integer; { mis en place par setFirstVar}
                 Itab0:integer;     { position du dernier bloc tableau           }
                                    { mis en place par nouveau(Stab) }
                                    { remis à 0 par setType        }

                 nomProc:AnsiString;    { garde le nom de la proc ou fonc courante }
                                    { permet d'ajouter la varloc supplémentaire }
                                    { des fonctions }

                 finDS:integer;     { déplacement dans DS. Initialisé à 0 }
                                    { incrémenté par setType }
                 finRec:integer;    { idem pour les records }

                 finClass:integer;


                 IdebImplement:integer;{Dep de l'implémentation}
                 UnitName:AnsiString;
                 Funit:boolean;
                 Ideclare:integer;

                 linkPos:integer;
                 Freplace:boolean;

                 IdebRecord:integer;
                 IdebClass:integer;

                 procedure FinalizeSymbSize;
                 function symbolSize(p:pdefSymbole):integer;
                 procedure setType0(n:integer;tpV:typeNombre;att:integer);
                 procedure afficherInfo(i:integer;stL: TstringList;pdef:PdefSymbole);

                 function nbElementsTab(dep:integer):integer;
                 function tailleEmpilee(n:integer):integer;
                 function symb(i:integer):PdefSymbole;

                 function SymbName(p:PdefSymbole):AnsiString;
               Public

                 freeThisObject: TfreeThisObject;
                 ObjectHasName:TObjectHasName;
                 Tables:TtablesSymbole;           // Unités utilisées
                                                  // Tables[0] = self
                 MainNum: integer;                // reçoit le numéro absolu au moment du link;

                 constructor create;
                 destructor destroy;override;

                 procedure AddToObjList(p:PdefSymbole;base:intG;baseName:AnsiString);
                 procedure BuildObjList(ds:pointer);


                 procedure reset;

                 procedure setFirstVar;
                 procedure nouveau(id:typeSymbole;st:AnsiString;line:integer);


                 procedure setType(tpV:typeNombre;att:integer);
                 {att est la longueur de chaine ou le type d'objet}
                 procedure setIndiceTab(i1,i2:integer);

                 procedure setConstante(t:typeNombre;var x);
                 procedure setStringConst(x:AnsiString);

                 procedure setParam(t:typeNombre;tob:integer);
                 procedure setResult(res:typeNombre;Fdeclaration:boolean;lineNum:integer);
                 procedure setAdresse(ad:integer);

                 procedure resetLocal;
                 procedure initDeplacement;
                 function setDeplacement:integer;

                 function getSymbole(const st:AnsiString):PdefSymbole;
                 function getSymboleINT(const st:AnsiString):PdefSymbole;


                 procedure DisplayTable;

                 procedure allouerDS(var p:pointer;var size:integer);

                 procedure ClearObject(p:pointer);
                 procedure FreeObjects;
                 procedure FreeStrings;
                 procedure FreeVariants;
                 procedure FreeObjNames;
                 procedure FreeVars;


                 function getInfoTab(p:PdefSymbole):PinfoTab;
                 procedure finalize;

                 function read(var f:TfileStream):boolean;
                 procedure write(var f:TfileStream);

                 function ObjetExiste(st:AnsiString):boolean;
                 function getVariableName(p:pointer):AnsiString;
                 function getVariableType(p:pointer):integer;

                 procedure setUnit(st:AnsiString);
                 procedure setImplementation;
                 procedure StartProcedureImp(p:pdefSymbole);
                 procedure EndProcedureImp;
                 function procedureConforme:boolean;
                 procedure ModifyDec(CodeInc:integer);

                 procedure BeginInterfaceProc;
                 procedure EndInterfaceProc;
                 function EndImplementation:AnsiString;


                 function objectCount:integer;

                 function symbDep(p:PdefSymbole):integer;
                {Convertit une adresse en déplacement étendu}
                 function symbAbs(dep:integer):PdefSymbole;
                 function symbAbs0(dep:integer):PdefSymbole;
                 {Convertit un déplacement étendu en adresse}

                 procedure replaceAdbyAbs(code:integer);
                 procedure replaceAbsbyAd(code,InitPos:integer);
                 function copierSymbole(listeSec,listeDep:Tlist;
                            Pdef:PdefSymbole;source:TtableSymbole;dep:integer):integer;
                 procedure initierSymbole(listeSec,listeDep:Tlist);

                 procedure setLinkPosition(p:integer);
                 function dataSize:integer;

                 function getProcInfo(ad:integer):PdefSymbole;
                 function getProcStringInfo(p:PdefSymbole):AnsiString;

                 procedure setSimpleType(tp:typeNombre);
                 procedure setAliasType(numU:integer; Symb: PdefSymbole);

                 procedure BeginRecord;
                 procedure EndRecord(stRec:AnsiString;lineNum:integer);
                 procedure setTypeArray(stN:AnsiString;tpV:typeNombre;att:integer;lineNum:integer);

                 procedure BeginClass;
                 procedure EndClass(stClass:AnsiString;PAncestor:PdefSymbole;AncestorUnit,lineNum:integer);


                 function FieldSize(p:PdefSymbole):integer;
                 function TypeSize(p:PdefSymbole):integer;
                 function VariableSize(p:PdefSymbole;withTab:boolean):integer;
                 function ParameterSize(p:PdefSymbole):integer;

                 function getField(p:PdefSymbole;st:AnsiString;var TypeTable:TtableSymbole):PdefSymbole;
                 function getTNarrayBaseSymbol(p: PdefSymbole): PdefSymbole;
                 function getBaseSymbole(p: PdefSymbole): PdefSymbole;
                 procedure ResetUnitAtt;

                 function GetProcedureName(ad:integer):AnsiString;
                 procedure GetProcList(list:Tlist);

                 function getSymboleInfo(Pdef: PdefSymbole; objNameList: TstringList):string;

                 function Next(Pdef: PdefSymbole): PdefSymbole;
               end;



procedure getSimplifiedType(var table:TtableSymbole; var p:PdefSymbole);

IMPLEMENTATION

uses stmDplot;

function tailleVariableSimple(tp:typeNombre;long:integer):integer;
  begin
    if tp=nbChaine
      then result:=long+1
      else result:=tailleNombre[tp];
  end;


constructor TtableSymbole.create;
begin
  inherited;
  objList:=TlistG.create(sizeof(TobjectRec));
  tables[0]:=self;
  IdebClass:=-1;
end;

destructor TtableSymbole.destroy;
begin
  freeObjects;
  freeObjNames;
  ObjList.free;
  FreeStrings;
  FreeVariants;
  inherited;
end;


procedure TtableSymbole.reset;
begin
  freeObjNames;
  FreeObjects;
  FreeStrings;
  FreeVariants;

  clear;

  Idep0:=-1;
  IdebLocal:=-1;
  Iproc:=-1;
  Itab0:=-1;
  finDS:=0;

  Objlist.clear;
  DS0:=nil;

  Funit:=false;
  Ideclare:=-1;
  UnitName:='';



  Freplace:=false;
end;

function TtableSymbole.symbolSize(p:pdefSymbole):integer;
begin
  with p^ do
  begin
     case ident of
       Sconst,SconstLoc:
          case infC.tp of
            nbSmall: result:=sizeof(stlen)+sizeof(infC.numH)+sizeof(ident)+sizeof(infC.tp)
                              +sizeof(infC.i);
            nbLong:   result:=sizeof(stlen)+sizeof(infC.numH)+sizeof(ident)+sizeof(infC.tp)
                              +sizeof(infC.l);
            nbExtended:   result:=sizeof(stlen)+sizeof(infC.numH)+sizeof(ident)+sizeof(infC.tp)
                              +sizeof(infC.r);
            nbBoole,nbchar: result:=sizeof(stlen)+sizeof(infC.numH)+sizeof(ident)+sizeof(infC.tp)
                              +sizeof(infC.b);
            nbChaine: result:=sizeof(stlen)+sizeof(infC.numH)+sizeof(ident)+sizeof(infC.tp)
                              +1+length(infC.stc);
          end;
       Svar,SvarLoc,Sfield:
           result:=sizeof(stlen)+
                   sizeof(ident)+
                   sizeof(infV.tp)+
                   sizeof(infV.att0)+
                   sizeof(infV.deplacement)+
                   sizeof(infV.depTab)+
                   sizeof(infV.varSize);

       Stab:
           result:=sizeof(stlen)+
                   sizeof(ident)+
                   sizeof(infT.nbrang)+
                   infT.nbrang*sizeof(typeRecTab);
       SprocU:
           result:=sizeof(stlen)+
                   sizeof(ident)+
                   sizeof(infP.nbParam)+
                   sizeof(infP.result1)+
                   sizeof(infP.adresse)+
                   sizeof(infP.tailleLoc)+
                   infP.nbparam*sizeof(typeParamU);


       Stype:
          begin
            result:=sizeof(stlen)+sizeof(ident)+sizeof(infoType.TNgenre);
            with infoType do
            case TNgenre of
              TNsimple: result:=result+sizeof(tpSimple);
              TNrecord: result:=result+sizeof( nbF)+nbF*sizeof(integer);
              TNarray:  result:=result+sizeof(tpA)+
                                       sizeof(attA)+
                                       sizeof(depTabA);

              TNenum:   result:=result + sizeof(nbE)+
                                         length(stE)+1;

              TNalias:  result:=result +  sizeof(AdDef);
              TNclass:  result:=result+sizeof( nbFclass)+nbFclass*sizeof(integer);
            end;
          end
       else result:=0;
     end;
     result:=result+sizeof(lineNum)+sizeof(UnitNum);
  end;


end;


procedure TtableSymbole.setFirstVar;
begin
  IfirstVar:=count; {Indice du prochain symbole}
end;

procedure TtableSymbole.nouveau(id:typeSymbole;st:AnsiString;line:integer);
begin
  addString(st,sizeof(typeDefSymbole));

  with PdefSymbole(lastData)^ do
  begin
    ident:=id;
    stLen:=length(st);
    LineNum:=line;
    UnitNum:=0;      // modifié au moment du link
  end;

  case id of
    Sconst, SconstLoc:begin end;
    Svar,SvarLoc,Sfield:
        begin
          PdefSymbole(lastData)^.infV.depTab:=-1;
          FinalizeSymbSize;
          {La taille du bloc est parfaitement définie}
        end;
    Stab:
        begin
          PdefSymbole(lastData)^.infT.nbrang:=0;
          Itab0:=count-1;
        end;
    SprocU:
        begin
          PdefSymbole(lastData)^.infP.result1:=nbNul;
          PdefSymbole(lastData)^.infP.nbParam:=0;
          PdefSymbole(lastData)^.infP.adresse:=0;

          NomProc:=st;

          Iproc:=count-1;
          IdebLocal:=count;
          {La taille maximale possible est allouée. Cette place
           sera récupérée avec resetLocal}
        end;
  end;
  {messageCentral(st+' '+Istr(intG(Pfin)-intG(tab)));}
end;


procedure TtableSymbole.setIndiceTab(i1,i2:integer);
begin
  {messageCentral('setIndiceTab '+Istr(intG(Pfin)-intG(tab)));}
  with PdefSymbole(lastData)^,infT do
  begin
    inc(nbrang);
    r[nbrang].minT:=i1;
    r[nbrang].maxT:=i2;
  end;
end;

function TtableSymbole.nbElementsTab(dep:integer):longint;
var
  i:integer;
  p:PdefSymbole;
begin
  if dep<0 then
    begin
      result:=1;
      exit;
    end;

  p:=symbAbs(dep);
  result:=1;
  with P^,infT do
    for i:=1 to nbrang do result:=result*(longint(r[i].maxT)-r[i].minT+1);
end;

function TtableSymbole.getInfoTab(p:PdefSymbole):PinfoTab;
var
  dep:integer;
  p1:PdefSymbole;
begin
  if p^.ident=Stype
    then dep:=p^.infoType.depTabA
    else dep:=p^.infV.depTab;

  if dep>=0 then
  begin
    {$IFDEF FPC}
    p1:=symbAbs(dep);
    result:=@p1^.infT;
    {$ELSE}
    result:=@symbAbs(dep)^.infT;
    {$ENDIF}
  end
  else result:=nil;
end;


procedure TtableSymbole.setType0(n:integer;tpV:typeNombre;att:integer);
var
  st:AnsiString;
  i,k:integer;
  P:PdefSymbole;
begin
  p:=data[n];
  if (P^.ident<>Svar) and (P^.ident<>SvarLoc) and (P^.ident<>Sfield) then exit;

  with P^,infV do
  begin
    tp:=tpV;
    att0:=att;
    if Itab0>=0
      then deptab:=DepData[Itab0]
      else deptab:=-1;

    varSize:=variableSize(p,true);  {vrai pour var varloc ou field }

    if IdebClass>=0 then
    begin
      deplacement:=finClass;
      finClass:=finClass+varSize;
    end
    else
    if (ident=Svar) then
      begin
        deplacement:=finDS;
        finDS:=finDS+varSize;
      end
    else
    if ident=Sfield then
      begin
        deplacement:=finRec;
        finRec:=finRec+varSize;
      end;
  end;
end;

type
  Tindex=array[1..255] of integer;

function nextIndex(var ind:Tindex;p:PinfoTab):AnsiString;
var
  i:integer;
  fini:boolean;
begin
  result:='[';
  with p^ do
  begin
    for i:=1 to nbrang-1 do
      result:=result+Istr(r[i].minT+ind[i])+',';
    result:=result+Istr(r[nbrang].minT+ind[nbrang])+']';
  end;

  fini:=false;

  with p^ do
  begin
    i:=nbrang;
    while not fini and (i>=1) do
    begin
      inc(ind[i]);
      with r[i] do
        fini:= ind[i]<=maxT-minT;
      if not fini then ind[i]:=0;
      dec(i);
    end;
  end;
end;


procedure TtableSymbole.AddToObjList(p:PdefSymbole;base:intG;baseName:AnsiString);
var
  i,k:integer;
  p1:PdefSymbole;
  rec:TobjectRec;
  baseSize:integer;
  index:Tindex;
  tabInfo:PInfoTab;
  st:AnsiString;
begin
  if (p^.ident=Stype) and (p^.infoType.TNgenre=TNrecord) then
  with p^.infoType do
  for i:=1 to nbF do
    begin
      p1:=symbAbs0(field[i]);
      AddToObjList(p1,base,baseName);
    end
  else
  if (p^.ident=Stype) and (p^.infoType.TNgenre=TNarray) and (p^.infoType.tpA=nbdef) then
  with p^.infoType do
  begin
    baseSize:=variableSize(p,false);
    tabInfo:=getInfoTab(p);
    fillchar(index,sizeof(index),0);
    for k:=0 to nbElementsTab(depTabA)-1 do
    begin
      st:=baseName+nextIndex(index,tabInfo);
      p1:=SymbAbs0(p^.infoType.attA);
      AddToObjList(p1,base+k*baseSize,st);
    end;
  end
  else
  if (p^.ident=Stype) and (p^.infoType.TNgenre=TNarray) and (p^.infoType.tpA=refObject) then
  with p^.infoType do
  begin
    tabInfo:=getInfoTab(p);
    fillchar(index,sizeof(index),0);

    baseSize:=variableSize(p,false);
    for k:=0 to nbElementsTab(depTabA)-1 do
      begin
        rec.ad:=pointer(base+baseSize*k);
        rec.typ:=attA;
        {On ne touche pas à rec.stN}
        st:=baseName+nextIndex(index,tabInfo);
        objList.add(@rec);
        PobjectRec( objList.last)^.stN:=st;
        {On affecte directement la chaine longue }
      end;
  end
  else
  if (p^.ident=Sfield) and (p^.infV.tp=nbDef) then  { champ x:Ttruc ou x:array[1..10] of Ttruc}
  begin
    baseSize:=variableSize(p,false);
    baseName:=baseName+'.'+copy(symbName(p),2,1000);
    tabInfo:=getInfoTab(p);
    fillchar(index,sizeof(index),0);
    for k:=0 to nbElementsTab(p^.infV.depTab)-1 do
    begin
      st:=baseName;
      if assigned(tabInfo) then
         st:=st+nextIndex(index,tabInfo);
      p1:=SymbAbs0(p^.infV.att0);
      AddToObjList(p1,base+p^.infV.deplacement+k*baseSize,st);
    end;
  end
  else
  if (p^.ident=Sfield) and (p^.infV.tp=refObject) then
  with p^,infV do
  begin
    tabInfo:=getInfoTab(p);
    fillchar(index,sizeof(index),0);

    baseName:=baseName+'.'+copy(symbName(p),2,1000);
    baseSize:=variableSize(p,false);
    for k:=0 to nbElementsTab(depTab)-1 do
      begin
        rec.ad:=pointer(base+deplacement+baseSize*k);
        rec.typ:=att0;
        {On ne touche pas à rec.stN}
        st:=baseName;
        if assigned(tabInfo) then
          st:=st+nextIndex(index,tabInfo);
        objList.add(@rec);
        PobjectRec( objList.last)^.stN:=st;
        {On affecte directement la chaine longue }
      end;
  end
end;



procedure TtableSymbole.BuildObjList(ds:pointer);
var
  p:PdefSymbole;
  i,k:integer;
  rec:TobjectRec;
  base: intG;
  baseSize:integer;
  p1:PdefSymbole;
  index:Tindex;
  tabInfo:PInfoTab;
  st:AnsiString;

begin
  freeObjNames;
  freeObjects;
  Objlist.clear;

  for i:=0 to count-1 do
  begin
    p:=PdefSymbole(data[i]);
    if (p^.ident=Svar) and (p^.infV.tp=RefObject) then
      with p^,infV do
      begin
        tabInfo:=getInfoTab(p);

        fillchar(index,sizeof(index),0);
        for k:=0 to nbElementsTab(depTab)-1 do
          begin
            rec.ad:=pointer(intG(ds)+deplacement+sizeof(pointer)*k);
            rec.typ:=att0;
            {On ne touche pas à rec.stN}
            st:=symbName(p);
            if assigned(tabInfo) then
              st:=st+nextIndex(index,tabInfo);
            objList.add(@rec);
            PobjectRec( objList.last)^.stN:=st;
            {On affecte directement la chaine longue }
          end;
      end
    else
    if (p^.ident=Svar) and (p^.infV.tp=nbDef) then
    begin
      baseSize:=variableSize(p,false);
      base:=intG(ds)+ p^.infV.deplacement;
      tabInfo:=getInfoTab(p);
      fillchar(index,sizeof(index),0);
      for k:=0 to nbElementsTab(p^.infV.depTab)-1 do
      begin
        st:=symbName(p);
        if assigned(tabInfo) then
           st:=st+nextIndex(index,tabInfo);
        p1:=SymbAbs0(p^.infV.att0);
        AddToObjList(p1,base+k*baseSize,st);
      end;
    end;
  end;
end;


procedure TtableSymbole.setType(tpV:typeNombre;att:integer);
var
  i:integer;
begin
  for i:=IfirstVar to count-1 do
    setType0(i,tpV,att);

  if Itab0>=0 then
    begin
      FinalizeSymbSize;
      Itab0:=-1;
    end;
end;


procedure TtableSymbole.initDeplacement;
begin
  Idep0:=count;
  finalizeSymbSize;
end;

function TtableSymbole.FieldSize(p:PdefSymbole):integer;
begin

end;

function TtableSymbole.TypeSize(p:PdefSymbole):integer;
var
  i:integer;
begin
  with p^.infoType do
  case TNgenre of
     TNsimple: result:= tailleNombre[tpSimple];
     TNrecord: begin
                 result:=0;
                 for i:=1 to nbF do
                   result:=result + variableSize(SymbAbs(field[i]),true);
               end;
     TNarray:  begin
                 case tpA of
                   nbdef: result:=TypeSize(symbAbs(attA));
                   nbChaine: result:=attA+1;
                   else result:=tailleNombre[tpA];
                 end;
                 result:=result*nbElementsTab(depTabA);
               end;
     TNenum:   result:=1;
     TNalias:    begin
                 if AdDef<=$FFFFFF then
                   result:=TypeSize(symbAbs(ADdef));
               end;
     TNclass:  result:=4;
  end;
end;

function TtableSymbole.VariableSize(p:PdefSymbole;withTab:boolean):integer;
begin
  with p^.infV do
  begin
    case tp of
      nbdef,refDef:    result:=tables[att0 shr 24].TypeSize(symbAbs(att0));
      nbChaine: result:=att0+1;
      else result:=tailleNombre[tp];
    end;

    if withtab
      then result:=result*nbElementsTab(depTab);
  end;
end;


function TtableSymbole.ParameterSize(p:PdefSymbole):integer;
begin

end;


function TtableSymbole.tailleEmpilee(n:integer):integer;
var
  t:longint;
  p:pdefSymbole;
begin
  p:=data[n];

  if n<Idep0 then {Paramètres}
    with P^.infV do
    begin
      result:=tailleParam[tp];
      {s'il s'agit d'une référence de chaine, la taille est aussi empilée sur 4 octets}
      if (tp=refChaine) and (att0=0) then inc(result,4);
    end
  else            {Variables locales}
  result:=P^.infV.varSize;

end;


function TtableSymbole.setDeplacement:integer;
var
  i,T:integer;
  Pvar:integer;
  Pdef:PdefSymbole;
  taille,taille0:integer;

begin
  taille0:=0;

  for Pvar:=IdebLocal to Idep0-1 do
    begin
      Pdef:=PdefSymbole(data[Pvar]);
      if Pdef^.ident=Svarloc then inc(taille0,tailleEmpilee(Pvar));
    end;

  taille:=taille0;
  Pvar:=IdebLocal;

  for Pvar:=IdebLocal to count-1 do
  begin
    Pdef:=PdefSymbole(data[Pvar]);
    if Pdef^.ident=Svarloc then
      begin
        dec(taille,tailleEmpilee(Pvar));
        Pdef^.infV.deplacement:=taille;
      end;
  end;

  PdefSymbole(data[Iproc])^.infP.TailleLoc:=-taille;
  if Ideclare>=0
    then PdefSymbole(data[Ideclare])^.infP.TailleLoc:=-taille;
  setDeplacement:=-taille;
end;


procedure TtableSymbole.resetLocal;
var
  st:ShortString;
  i:integer;
  pp:pointer;
begin
  {On écrase ce qui suit la procédure: paramètres et variables locales}
  {Pour implementation, on efface aussi la procedure}
  {19-06-02: on range aussi les noms des paramètres dans les extra infos
   sous la forme d'une chaine du genre AA|BB|CC }

  modifySize(Iproc,symbolSize(symb(Iproc)));

  (*
  if Ideclare>=0 then deleteAfter(Iproc)
  else
    begin

      st:='';
      with symb(Iproc)^ do
      if infP.nbParam>0 then
        begin
          st:=strings[Iproc+1];
          for i:=2 to infP.nbParam do
           st:=st+'|'+strings[Iproc+i];

          pp:=symb(Iproc);
          inc(intG(pp),symbolSize(symb(Iproc)));
          infP.extraInfo:=length(st)+1;
          move(st,pp^,infP.extraInfo);
        end;

      deleteAfter(Iproc+1);
      FinalizeSymbSize;

    end;
  *)
  Iproc:=-1;
end;


procedure TtableSymbole.setConstante(t:typeNombre;var x);
begin
  with PdefSymbole(lastData)^.infC do
  begin
    tp:=t;
    case t of
      nbSmall:    i:=smallInt(x);
      nbLong:     l:=longint(x);
      nbExtended: r:=float(x);
      nbBoole:    b:=boolean(x);
      nbchar:     c:=Ansichar(x);
    end;
  end;
  FinalizeSymbSize;
end;

procedure TtableSymbole.setStringConst(x:AnsiString);
begin
  with PdefSymbole(lastData)^.infC do
  begin
    tp:=nbChaine;
    stc:=x;
  end;
  FinalizeSymbSize;
end;


procedure TtableSymbole.setParam(t:typeNombre;tob:integer);
begin
  with PdefSymbole(data[Iproc])^,infP do
  begin
    inc(nbParam);
    parametre[nbParam].tp:=t;
    parametre[nbParam].numob:=tob;
  end;
end;


procedure TtableSymbole.setResult(res:typeNombre;Fdeclaration:boolean;lineNum:integer);
begin
  PdefSymbole(data[Iproc])^.infP.result1:=res;

  if not Fdeclaration then
  begin
    setFirstVar;
    if nomProc[length(nomProc)]='#'
      then delete(nomProc,length(nomProc),1);
    nouveau(SvarLoc,nomProc+'.'+nomProc,lineNum);
    setType(res,255);
  end;
end;

procedure TtableSymbole.setAdresse(ad:integer);
begin
  PdefSymbole(data[Iproc])^.infP.adresse:=ad;
  if Ideclare>=0 then PdefSymbole(data[Ideclare])^.infP.adresse:=ad;
end;


function TtableSymbole.getSymbole(const st:AnsiString):PdefSymbole;
begin
  result:=getLastObj(st);
end;

function TtableSymbole.getSymboleINT(const st:AnsiString):PdefSymbole;
begin
  result:=getLastObj1(st,IdebImplement);
end;


procedure TtableSymbole.afficherInfo(i:integer;stL: TstringList;pdef:PdefSymbole);
const
  StDec='        ';
var
  j:integer;
  P:PdefSymbole;
  nom:AnsiString;
  st:AnsiString;


begin
  nom:=symbName(Pdef);
  p:=Pdef;

  with p^ do
  stL.add(Istr1(depdata[i],5)+'   '+ nom+' : '+IdName[ident]);

  case p^.ident of
    Sconst,SconstLoc:
      with p^.infC do
      begin
        case tp of
          nbSmall:    stL.add(stDec+'i='+Istr(i));
          nbLong:     stL.add(stDec+'l='+Istr(l));
          nbExtended: stL.add(stDec+'r='+Estr(r,3));
          nbBoole:    stL.add(stDec+'b='+Bstr(b));
          nbChar:     stL.add(stDec+'c='+c);

          nbChaine: stL.add(stDec+'stc='+stc);
        end;
      end;

    Svar,SvarLoc,Sfield:
      with P^.infV do
      begin
        stL.add(stDec+'tp='+ tpNumName[tp]+'  size='+Istr(varSize));
        stL.add(stDec+'Att= '+Istr(att0 shr 24)+'/'+Istr(att0 and $FFFFFF));
        stL.add(stDec+'dep='+Istr(deplacement));
        if deptab>=0 then stL.add(stDec+'depTab='+Istr(deptab));
      end;

    Stab:
      with p^.infT do
      begin
        stL.add(stDec+'Nrang='+Istr(nbrang));
        st:='';
        for j:=1 to nbrang do st:=st+Istr(r[j].minT)+'/'+Istr(r[j].maxT)+'   ';
        stL.add(stDec+st);
      end;
    SprocU:
      with P^.infP do
      begin
        stL.add(stDec+'nbParam='+Istr(nbParam));
        stL.add(stDec+'result='+Istr(ord(result1)));
        stL.add(stDec+'adresse='+Istr(adresse));
        stL.add(stDec+'Tailleloc='+Istr(TailleLoc));
        for j:=1 to nbParam do
          stL.add(stDec+'param='+ tpNumName[parametre[j].tp]+' / '+Istr(parametre[j].numOb));
        stL.add(stDec+getProcStringInfo(P));
      end;

    Stype:
      with P^.infoType do
      begin
        stL.add(stDec+'TNgenre='+TNtypeName[TNgenre]);
        case TNgenre of
          TNsimple: stL.add(stDec+'tpSimple='+ tpNumName[tpSimple] );
          TNrecord: begin
                       stL.add(stDec+'nbF='+Istr(nbF));
                       st:='';
                       for j:=1 to nbF do st:=st+Istr(field[j])+'  ';
                       stL.add(stDec+st);
                     end;
          TNarray:   begin
                       stL.add(stDec+'tpA='+tpNumName[tpA]);
                       stL.add(stDec+'AttA='+Istr(attA shr 24)+'/'+Istr(attA and $ffffff));
                       stL.add(stDec+'DepTabA='+Istr(depTabA));
                     end;
          TNenum:    begin
                       stL.add(stDec+'nbE='+Istr(nbE));
                       stL.add(stDec+'stE='+stE);
                     end;
          TNalias:     stL.add(stDec+'AdDef='+Istr(AdDef));
          TNclass: begin
                       stL.add(stDec+'nbFclass='+Istr(nbFclass));
                       st:='';
                       for j:=1 to nbFclass do st:=st+Istr(Fclass[j])+'  ';
                       stL.add(stDec+st);
                     end;
        end;
      end;
  end;
end;

procedure TtableSymbole.DisplayTable;
var
  viewText:TviewText;
  i:integer;
  stL:TstringList;
begin
  stL:=TstringList.create;

  for i:=0 to count-1 do afficherInfo(i,stL,symb(i));

  viewText:=TviewText.create(nil);
  ViewText.caption:='Symbols';

  ViewText.memo1.Text:=stL.Text;
  stL.Free;


  ViewText.showModal;
  ViewText.free;
end;


procedure TtableSymbole.allouerDS(var p:pointer;var size:integer);
var
  i:integer;
begin
  size:=finDS;
  p:=allocmem(size);
  {messageCentral('DS='+Istr(intG(FDS))+'  DSsize='+Istr(FDSsize));}

  buildObjList(p);
  DS0:=p;
end;

procedure TtableSymbole.ClearObject(p:pointer);
var
  k:integer;
  prec:PobjectRec;
begin
  prec:=ObjList.getSortedItemPointer(p,0,k);
  if assigned(prec) and (prec^.ad=p)
    then PobjectRec(Prec)^.ad:=nil;
end;

procedure TtableSymbole.FreeObjects;
var
  i:integer;
  tt: integer;
begin
  tt:= getTickCount;

  BlockCouplings;
  if assigned(DS0) then
    with ObjList do
    for i:=0 to count-1 do
      freeThisObject(pointer(PObjectRec(items[i])^.ad^));
  ReBuildCouplings;

  //messageCentral('FreeObj = '+Estr((getTickCount-tt)/1000,3));
end;

procedure TtableSymbole.FreeObjNames;
var
  i:integer;
begin
  with ObjList do
  for i:=0 to count-1 do
    PObjectRec(items[i])^.stN:='';
end;


procedure TtableSymbole.FreeVars;
begin
  if assigned(DS0) then
  begin
    freeStrings;
    FreeVariants;
    fillchar(ds0^,finDS,0);
  end;
end;


procedure TtableSymbole.finalize;
begin
  Pack;
end;

procedure TtableSymbole.write(var f:TfileStream);
begin
  saveToStream(f);

  if tableSize>0 then
    begin
      f.Write(finDS,sizeof(finDS));
      f.Write(IdebImplement,sizeof(IdebImplement));
    end;
end;


function TtableSymbole.read(var f:TfileStream):boolean;
begin
  reset;
  result:=true;

  try
  LoadFromStream(f);

  if tableSize>0 then
    begin
      f.Read(finDS,sizeof(finDS));
      f.Read(IdebImplement,sizeof(IdebImplement));
    end;

  except
  result:=false;
  end;

end;

function TtableSymbole.ObjetExiste(st:AnsiString):boolean;
var
  i:integer;
begin
  result:=true;

  with ObjList do
  for i:=0 to count-1 do
    with PobjectRec(items[i])^ do
      if assigned(pointer(ad^)) and ObjectHasName(ad,st) then exit;

  result:=false;
end;


function TtableSymbole.getVariableName(p:pointer):AnsiString;
var
  k:integer;
  prec:PobjectRec;
begin
  prec:=ObjList.getSortedItemPointer(p,0,k);
  if assigned(prec) and (prec^.ad=p)
    then result:=PobjectRec(Prec)^.stN
    else result:='';
end;

function TtableSymbole.getVariableType(p:pointer):integer;
var
  k:integer;
  prec:PobjectRec;
begin
  prec:=ObjList.getSortedItemPointer(p,0,k);
  if assigned(prec) and (prec^.ad=p)
    then result:=prec^.typ
    else result:=-1;
end;


procedure TtableSymbole.setUnit(st:AnsiString);
begin
  UnitName:=st;
  Funit:=True;
end;

procedure TtableSymbole.setImplementation;
begin
  IdebImplement:=count;
end;

procedure TtableSymbole.StartProcedureImp(p:pdefSymbole);
begin
  Ideclare:=Ifound;
  ModifyDec(+128);          // Neutralise la déclaration dans l'interface
end;

function TtableSymbole.procedureConforme:boolean;
var
  i:integer;
  Sdeclare,Sproc:PdefSymbole;
begin
  Sdeclare:=symb(Ideclare);
  Sproc:=symb(Iproc);
  result:=(Sdeclare^.infP.nbParam = Sproc^.infP.nbParam)
           and
          (Sdeclare^.infP.result1 = Sproc^.infP.result1);

  for i:=1 to Sdeclare^.infP.nbParam do
    result:=result
            and
            (Sdeclare^.infP.parametre[i].tp = Sproc^.infP.parametre[i].tp)
            and
            ((Sdeclare^.infP.parametre[i].tp<>refObject) or  (Sdeclare^.infP.parametre[i].numOb = Sproc^.infP.parametre[i].numOb));

end;

procedure TtableSymbole.ModifyDec(CodeInc: integer);
var
  i:integer;
  Sdeclare:PdefSymbole;
begin
  Sdeclare:=symb(Ideclare);

  modifyFirstChar(Ideclare, CodeInc);
  for i:=1 to Sdeclare^.infP.nbParam do
    modifyFirstChar(Ideclare+i, CodeInc);

end;


procedure TtableSymbole.EndProcedureImp;
begin
  ModifyDec(-128);          // Réactive la déclaration de l'interface
  Ideclare:=-1;
  // On pourrait neutraliser la déclaration de l'implémentation mais ça n'apporte rien (?)
end;

procedure TtableSymbole.BeginInterfaceProc;
begin
end;

procedure TtableSymbole.EndInterfaceProc;
begin
  Symb(Iproc)^.infP.adresse:=-1;
  resetLocal;
end;

function TtableSymbole.objectCount: integer;
begin
  result:=objList.Count;
end;


function TtableSymbole.symbDep(p: PdefSymbole): integer;
begin
  result:=intG(p)-intG(table);
end;

function TtableSymbole.symbAbs(dep: integer): PdefSymbole;
begin
  if dep shr 24=0
    then result:=pointer(intG(table)+dep)
    else result:=tables[dep shr 24].symbabs(dep and $FFFFFF);
end;

function TtableSymbole.symbAbs0(dep: integer): PdefSymbole;
begin
  result:=pointer(intG(table)+ dep and $FFFFFF);
end;


{ Remplacement des adresses par des adresses absolues }

procedure TtableSymbole.replaceAdbyAbs(code:integer);
var
  i:integer;
begin
  if Freplace then exit;

  for i:=0 to count-1 do
    with Symb(i)^ do
    case ident of
      Svar:   infV.deplacement:=LinkPos+infV.deplacement;
      SprocU: infP.adresse:=code+infP.adresse;
    end;

  Freplace:=true;
end;

procedure TtableSymbole.replaceAbsbyAd(code,initPos:integer);
var
  i,k:integer;
begin
  if not Freplace then exit;

  for i:=initPos to count-1 do
    with symb(i)^ do
    case ident of
      Svar:   infV.deplacement:=infV.deplacement-linkPos;
      SprocU: infP.adresse:=infP.adresse-code;
    end;

  Freplace:=false;
end;

procedure TtableSymbole.initierSymbole(listeSec,listeDep:Tlist);
var
  i,j:integer;
  src:TtableSymbole;
  NumUT:integer;

begin
  for j:=0 to count-1 do
  with symb(j)^ do
  begin
    case ident of
     SprocU:
          with infP do
          begin
            for i:=1 to nbParam do
              with parametre[i] do
              if (tp=nbdef) or (tp=refdef) and (numOb shr 24<>0) then
                begin
                  NumUT:=numOb shr 24;
                  src:=tables[numOb shr 24];
                  numOb:=copierSymbole(listeSec,listeDep,symbAbs(numOb),src, 0);
                end;
          end;
     Svar,Sfield:
          begin
            if (infV.tp=nbDef) and (infV.att0 shr 24<>0) then
            begin
              NumUT:= infV.att0 shr 24;
              src:=tables[infV.att0 shr 24];
              infV.att0:=copierSymbole(listeSec,listeDep,src.symbAbs(infV.att0 and $FFFFFF),src,0);
            end;
          end;
     Stype:
          begin
            case infoType.TNgenre of
              TNrecord:
                  for i:=1 to infoType.nbF do
                    if infoType.field[i] shr 24<>0 then
                    infoType.field[i]:=copierSymbole(listeSec,listeDep,symbAbs(infoType.field[i]),self,0);

              TNarray:
                    if infoType.attA shr 24<>0 then
                    begin
                      src:=tables[infoType.attA shr 24];
                      infoType.attA:=copierSymbole(listeSec,listeDep,src.symbAbs(infoType.attA and $FFFFFF),src,0);
                    end;

              TNalias:if infoType.adDef shr 24<>0 then
                    begin
                      src:=tables[infoType.adDef shr 24];
                      infoType.adDef:=copierSymbole(listeSec,listeDep,src.symbAbs(infoType.adDef),src,0);
                    end;
            end;
          end;
    end;

  end;
end;


function TtableSymbole.copierSymbole(listeSec,listeDep:Tlist;
             Pdef:PdefSymbole;source:TtableSymbole;dep:integer):integer;
var
  Ps:PrecSymbole;
  i,k,posV,posF:integer;
  src:TtableSymbole;
begin
  Affdebug('CopierSymbole 1 '+source.symbName(Pdef),111);
  i:=listeSec.indexof(Pdef);
  if i>=0 then
    begin
      k:= intG(listeDep[i]);
      result:= depdata[k];
      exit;
    end
  else
    begin
      listeSec.add(Pdef);
      listeDep.add(pointer(count));
    end;

  Ps:=pointer(Pdef);
  dec(intG(ps),Pdef^.stLen+3);
  copier(Ps);

  result:=depData[count-1];

  with PdefSymbole(lastData)^ do
  begin
    UnitNum:= source.MainNum;
    case ident of
      SprocU:  infP.adresse:=dep;  {écrire la nouvelle adresse}
      Svar:    begin
                 infV.deplacement:=finDS;
                 inc(finDS,infV.varSize);
               end;
    end;

    case ident of
     SprocU:
          with infP do
          begin
            for i:=1 to nbParam do
              with parametre[i] do
              if (tp=nbdef) or (tp=refdef) then
                begin
                  src:=source.tables[numOb shr 24];
                  numOb:=copierSymbole(listeSec,listeDep,src.symbAbs(numOb and $FFFFFF),src,0);
                end;
          end;
     Svar,Sfield:
          begin
            if (infV.depTab>=0) then
              infV.depTab:=copierSymbole(listeSec,listeDep,source.symbAbs(infV.depTab),source,0);

            if infV.tp=nbDef then
            begin
              src:=source.tables[infV.att0 shr 24];
              infV.att0:=copierSymbole(listeSec,listeDep,src.symbAbs(infV.att0 and $FFFFFF),src,0);
            end;
          end;
     Stype:
          begin
            case infoType.TNgenre of
              TNrecord:
                  for i:=1 to infoType.nbF do
                    infoType.field[i]:=copierSymbole(listeSec,listeDep,source.symbAbs(infoType.field[i]),source,0);

              TNarray:
                    begin
                      src:=source.tables[infoType.attA shr 24];
                      infoType.attA:=copierSymbole(listeSec,listeDep,src.symbAbs(infoType.attA and $FFFFFF),src,0);
                      infoType.depTabA:=copierSymbole(listeSec,listeDep,source.symbAbs(infoType.depTabA),source,0);
                    end;

              TNalias:begin
                      src:=source.tables[infoType.adDef shr 24];
                      infoType.adDef:=copierSymbole(listeSec,listeDep,src.symbAbs(infoType.adDef and $FFFFFF),src,0);
                    end;
            end;
          end;
    end;

  end;
  Affdebug('CopierSymbole 2 '+source.symbName(Pdef),111);
end;

procedure TtableSymbole.setLinkPosition(p:integer);
begin
  linkPos:=p;
end;

function TtableSymbole.dataSize: integer;
begin
  result:=finDS;
end;

function TtableSymbole.symb(i: integer): PdefSymbole;
begin
  result:=PdefSymbole(data[i]);
end;

procedure TtableSymbole.FinalizeSymbSize;
begin
  modifyLastSize(symbolSize(lastData));
end;

function TtableSymbole.getProcInfo(ad: integer): PdefSymbole;
var
  i:integer;
begin
  for i:=0 to count-1 do
  with symb(i)^ do
    if (ident=SprocU) and (infP.adresse=ad) then
    begin
      result:=symb(i);
      exit;
    end;

  result:=nil;
end;


procedure TtableSymbole.setSimpleType(tp: typeNombre);
begin
  with PdefSymbole(lastData)^.infoType do
  begin
    TNgenre:=TNsimple;
    tpSimple:=tp;
  end;
  FinalizeSymbSize;
end;

procedure TtableSymbole.setAliasType( numU:integer; Symb: PdefSymbole);
begin
  with PdefSymbole(lastData)^.infoType do
  begin
    TNgenre:=TNalias;
    adDef:=tables[numU].SymbDep(symb) or (numU shl 24);
  end;
  FinalizeSymbSize;
end;

procedure TtableSymbole.BeginRecord;
begin
  IdebRecord:=count;
  FinRec:=0;
end;

procedure TtableSymbole.EndRecord(stRec:AnsiString;lineNum:integer);
var
  nbTot,i:integer;
begin
  nbTot:=count-IdebRecord;
  nouveau(Stype,Fmaj(stRec),lineNum);
  with PdefSymbole(lastData)^.infoType do
  begin
    TNgenre:=TNrecord;
    nbF:=0;
    for i:=1 to nbTot do
    if PdefSymbole(data[IdebRecord+i-1])^.ident=Sfield then
    begin
      inc(nbF);
      field[nbF]:=depData[IdebRecord+i-1];
    end;
  end;
  FinalizeSymbSize;
  IdebRecord:=-1;
end;


procedure TtableSymbole.BeginClass;
begin
  IdebClass:=count;
  FinClass:=0;
end;

procedure TtableSymbole.EndClass(stClass:AnsiString;PAncestor:PdefSymbole;AncestorUnit,lineNum:integer);
var
  nbTot,i:integer;
begin
  nbTot:=count-IdebClass;
  nouveau(Stype,Fmaj(stClass),lineNum);
  with PdefSymbole(lastData)^.infoType do
  begin
    TNgenre:=TNclass;
    nbFclass:=0;
    for i:=1 to nbTot do
    if PdefSymbole(data[IdebClass+i-1])^.ident=Sfield then
    begin
      inc(nbFclass);
      field[nbFclass]:=depData[IdebClass+i-1];
    end;
  end;
  FinalizeSymbSize;
  IdebClass:=-1;
end;

{ si p est est un symbole Stype de genre TNalias dans la table table , on saute au symbole
 équivalent qui peut se trouver dans une autre table.
}
procedure getSimplifiedType(var table:TtableSymbole; var p:PdefSymbole);
var
  numU:integer;
begin
  while assigned(p) and (p^.ident = Stype) and (p^.infoType.TNgenre=TNalias) do
    begin
      numU:= (p^.infoType.AdDef shr 24);
      table:=table.tables[numU];
      p:= Table.symbAbs(p^.infoType.AdDef and $FFFFFF);
    end;
end;


function TtableSymbole.SymbName(p:PdefSymbole):AnsiString;
begin
  result:=PshortString( intG(p)-p^.stLen-1)^;
end;

{ Y a-t-il un champ correspondant à p de nom st ? }
function TtableSymbole.getField(p: PdefSymbole; st: AnsiString;var TypeTable:TtableSymbole): PdefSymbole;
var
  p1:PdefSymbole;
  i:integer;
  uniteType:integer;
begin
  result:=nil;
  if not assigned(p) then exit;

  if (p^.ident in [Svar,SvarLoc,Sfield]) and (p^.infV.tp in [nbdef,refDef]) then
  begin
    uniteType:=p^.infV.att0 shr 24;
    p:=SymbAbs(p^.infV.att0);               { symbole Stype associé }
  end
  else uniteType:=0;
  TypeTable:=tables[uniteType];

  getSimplifiedType(typetable,p);

  if (p^.ident=Stype) and (p^.infoType.TNgenre=TNrecord) then
  with p^.infoType do
  for i:=1 to nbF do
  begin
    p1:=TypeTable.symbAbs(field[i]);
    if symbName(p1)=#1+st then
      begin
        result:=p1;
        exit;
      end;
  end
  else
  if (p^.ident=Stype) and (p^.infoType.TNgenre=TNclass) then
  with p^.infoType do
  for i:=1 to nbFclass do
  begin
    p1:=TypeTable.symbAbs(Fclass[i]);
    if symbName(p1)=#1+st then
      begin
        result:=p1;
        exit;
      end;
  end
  else
  if (p^.ident=Stype) and (p^.infoType.TNgenre=TNarray) then result:=p;
end;


function TtableSymbole.getTNarrayBaseSymbol(p: PdefSymbole): PdefSymbole;
begin
  if assigned(p) and (p^.ident=Stype) and (p^.infoType.TNgenre=TNarray) and (p^.infoType.tpA=nbdef)
    then result:=symbAbs(p^.infoType.attA)
    else result:=nil;
end;

function TtableSymbole.EndImplementation: AnsiString;
var
  i:integer;
begin
  for i:=0 to count-1 do
    with symb(i)^ do
    if (ident=SprocU) and (infP.adresse<0) then
      begin
        result:=strings[i];
        exit;
      end;

  result:='';
end;

procedure TtableSymbole.ResetUnitAtt;
var
  i,j:integer;
begin
  for j:=0 to count-1 do
    with symb(j)^ do
    case ident of
      SprocU:
          with infP do
          begin
            for i:=1 to nbParam do
              with parametre[i] do
              if (tp=nbdef) or (tp=refdef) then
                  numOb:=numOb and $FFFFFF;
          end;
      Svar,Sfield:
          begin
            if infV.tp=nbDef then
              infV.att0:=infV.att0 and $FFFFFF;
          end;
      Stype:
          begin
            case infoType.TNgenre of
              TNrecord:
                  for i:=1 to infoType.nbF do
                    infoType.field[i]:= infoType.field[i] and $FFFFFF;

              TNarray:
                    begin
                      infoType.attA:=infoType.attA and $FFFFFF;
                    end;

              TNalias:begin
                      infoType.adDef:=infoType.adDef and $FFFFFF;
                    end;
            end;
          end;
    end;
end;

procedure TtableSymbole.setTypeArray(stN: AnsiString; tpV: typeNombre; att: integer;lineNum:integer);
begin
  FinalizeSymbSize;

  nouveau(Stype,Fmaj(stN),lineNum);
  with PdefSymbole(lastData)^.infoType do
  begin
    TNgenre:=TNarray;
    tpA:=tpV;
    attA:=att;
    deptabA:=DepData[Itab0];
  end;

  FinalizeSymbSize;
  Itab0:=-1;
end;


procedure TtableSymbole.FreeStrings;
var
  p:PdefSymbole;
  i,k:integer;
  ad:PansiString;
begin
  if assigned(ds0) then
  for i:=0 to count-1 do
  begin
    p:= PdefSymbole(data[i]);
    with p^ do
    if (ident=Svar) and (infV.tp=nbAnsiString) then
      with p^,infV do
      begin
        for k:=0 to nbElementsTab(depTab)-1 do
        begin
          ad:=pointer(intG(ds0)+deplacement+sizeof(pointer)*k);
          ad^:='';
        end;
      end;
  end;
end;

procedure TtableSymbole.FreeVariants;
var
  p:PdefSymbole;
  i,k:integer;
  ad:PGvariant;
begin
  if assigned(ds0) then
  for i:=0 to count-1 do
  begin
    p:= PdefSymbole(data[i]);
    with p^ do
    if (ident=Svar) and (infV.tp=nbVariant) then
      with p^,infV do
      begin
        for k:=0 to nbElementsTab(depTab)-1 do
        begin
          ad:=pointer(intG(ds0)+deplacement+GvariantSize*k);
          ad^.finalize;
        end;
      end;
  end;
end;



function TtableSymbole.getBaseSymbole(p: PdefSymbole): PdefSymbole;
begin
  if (p^.ident in [Svar,SvarLoc,Sfield]) and (p^.infV.tp in [nbdef,refDef])
    then result:=SymbAbs(p^.infV.att0)               { symbole Stype associé }
    else result:=p;

end;

function TtableSymbole.GetProcedureName(ad: integer): AnsiString;
var
  i:integer;
begin
  for i:=0 to count-1 do
  with symb(i)^ do
    if (ident=SprocU) and (infP.adresse=ad) then
    begin
      result:= strings[i];
      exit;
    end;

  result:='';
end;

procedure TtableSymbole.GetProcList(list: Tlist);
var
  i: integer;
begin
  for i:=0 to count-1 do
    with symb(i)^ do
    if ident=SprocU then list.Add(pointer(infP.adresse));
end;

function TtableSymbole.getSymboleInfo(Pdef: PdefSymbole; objNameList: TstringList): string;
const
  StDec='        ';
var
  j:integer;
  P:PdefSymbole;
  nom:AnsiString;
  st:AnsiString;

begin
  nom:=symbName(Pdef);
  p:=Pdef;

  case p^.ident of
    Sconst,SconstLoc:
      with p^.infC do
      begin
        case tp of
          nbSmall:    result:='Const '+nom+'= '+Istr(i);
          nbLong:     result:='Const '+nom+'= '+Istr(l);
          nbExtended: result:='Const '+nom+'= '+Estr(r,3);
          nbBoole:    result:='Const '+nom+'= '+Bstr(b);
          nbChar:     result:='Const '+nom+'= '+c;

          nbChaine:   result:='Const '+nom+'= '+''''+stc+'''';
        end;
      end;

    Svar,SvarLoc,Sfield:
      with P^.infV do
      begin
        if tp=refObject
          then result:='Var '+nom+': '+ ObjNameList[att0]
          else result:='Var '+nom+': '+ tpNumUserName[tp];
        {
        stL.add(  stDec+'tp='+ tpNumUserName[tp]+'  size='+Istr(varSize));
        stL.add(stDec+'Att= '+Istr(att0 shr 24)+'/'+Istr(att0 and $FFFFFF));
        stL.add(stDec+'dep='+Istr(deplacement));
        if deptab>=0 then stL.add(stDec+'depTab='+Istr(deptab));
        }
      end;
    {
    Stab:
      with p^.infT do
      begin
        stL.add(stDec+'Nrang='+Istr(nbrang));
        st:='';
        for j:=1 to nbrang do st:=st+Istr(r[j].minT)+'/'+Istr(r[j].maxT)+'   ';
        stL.add(stDec+st);
      end;
      }
    SprocU:
      with P^.infP do
      begin
        if result1=nbNul
          then result:='Procedure '+nom
          else result:='Function '+nom+': '+ tpNumUserName[result1];
        {
        stL.add(stDec+'nbParam='+Istr(nbParam));
        stL.add(stDec+'result='+Istr(ord(result)));
        stL.add(stDec+'adresse='+Istr(adresse));
        stL.add(stDec+'Tailleloc='+Istr(TailleLoc));
        for j:=1 to nbParam do
          stL.add(stDec+'param='+ tpNumName[parametre[j].tp]+' / '+Istr(parametre[j].numOb));
        stL.add(stDec+getProcStringInfo(P));
        }
      end;

    Stype:
      with P^.infoType do
      begin
        result:='Type '+nom;
        {
        stL.add(stDec+'TNgenre='+TNtypeName[TNgenre]);
        case TNgenre of
          TNsimple: stL.add(stDec+'tpSimple='+ tpNumName[tpSimple] );
          TNrecord: begin
                       stL.add(stDec+'nbF='+Istr(nbF));
                       st:='';
                       for j:=1 to nbF do st:=st+Istr(field[j])+'  ';
                       stL.add(stDec+st);
                     end;
          TNarray:   begin
                       stL.add(stDec+'tpA='+tpNumName[tpA]);
                       stL.add(stDec+'AttA='+Istr(attA shr 24)+'/'+Istr(attA and $ffffff));
                       stL.add(stDec+'DepTabA='+Istr(depTabA));
                     end;
          TNenum:    begin
                       stL.add(stDec+'nbE='+Istr(nbE));
                       stL.add(stDec+'stE='+stE);
                     end;
          TNalias:     stL.add(stDec+'AdDef='+Istr(AdDef));
          TNclass: begin
                       stL.add(stDec+'nbFclass='+Istr(nbFclass));
                       st:='';
                       for j:=1 to nbFclass do st:=st+Istr(Fclass[j])+'  ';
                       stL.add(stDec+st);
                     end;
        end;
        }
      end;
  end;
end;

function TtableSymbole.Next(Pdef: PdefSymbole): PdefSymbole;
var
  nextP: PhashListRecord2;
begin
  nextP:= pointer(intG(Pdef)+symbolSize(Pdef));
  result:= pointer( intG(nextP)+length(nextP^.st)+3);
end;

function TtableSymbole.getProcStringInfo(p:PdefSymbole):AnsiString;
var
  nb1:integer;
  i:integer;
  st:string;
begin
  result:='';
  if p^.ident<>SprocU then exit;

  nb1:= p^.infP.nbParam;
  for i:=1 to nb1 do
    begin
      p:=next(p);
      st:= symbName(p);
      while pos('.',st)>0 do delete(st,1,pos('.',st));
      result:=result+st;
      if i<>nb1 then result:=result+'|';
    end;

end;


end.
