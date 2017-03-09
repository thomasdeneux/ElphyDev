unit ncompil3;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

{
  mettre TEST_AFFECT_OBJECT dans les conditions du projet pour autoriser les affectations obj1:=obj2
}

{ Mécanisme des WITH
  Codage: quand on rencontre un with, on code la séquence:
            PushI
            AffectVar
            refAbs
            VariObject, refLocObject ou expression donnant l'adresse d'un objet

          en fin de with, on code popI

          A l'exécution:
          pushI réserve un emplacement dans la pile pour ranger une adresse.
          refAbs.dep pointe sur cet emplacement (déplacement dans SS)
          L'affectation range dans la pile l'adresse de la variable objet concernée
          .

          Chaque propriété ou méthode d'un objet touché par le With s'appliquera à
          TpObjectInd. TpObjectInd.deptpO  pointe dans la pile sur l'emplacement
          réservé (comme refAbs.dep)

  Compilation:
          Quand on détecte une propriété ou méthode d'un objet touché par le With, lireUlex
          place un TpObjectInd dans plex^ puis fixe nbRenvoyé=2.

          les 2 appels suivants de lireUlex renverront:
            - un point
            - la méthode ou propriété initiale

  With implicites:
          Le principe est le même mais les adresses calculées sont stockées au début de
          la pile.
          Si refabs.dep est positif, c'est donc un with implicite. Sinon c'est un with ordinaire.


}


uses windows,classes,sysUtils,Dialogs,forms,

     Dgraphic,
     util1,
     Gdos,
     Ncdef2,adproc2,DUlex5,
     procac2,symbac3,chrono0,
     memoForm,compBox,
     pgc0, MotRes1;



Const
  IsElphy2=true;


const
  maxWith=20;
type
  TwithRec=record
             dep:integer;
           case IsObj:boolean of
             true:( ob:integer);
             false:(symbW:PdefSymbole;
                    UnitW:byte  );
           end;

type
  TgenreSymb=(GSnone,GSmotRes,GSunit,GSsymb0,GSsymbN,GSfps);

  TatomType=(ATnothing,    // indique une erreur
             ATvar,        // élément affectable , possède un type
             ATvarArray,
             ATfonc,       // élément non affectable , possède un type
             ATproc);      // élément non affectable , sans type

  Texp1Set= record
              IsExp1:boolean;
              n1Exp1:ptUlex;
              isVarExp1:boolean;
              numObExp1:integer;
              symbExp1:PdefSymbole;
              typExp1:typeNombre;
              vszExp1:integer;
            end;  

  Tcompil=class
          private
            tabProc:TTabDefProc;          {fourni pendant create}
            adresseProcedure:TtabAdresse; {fourni pendant create}
            tableSymbole:TtableSymbole;   {fourni pendant Init}
            pgC:TpgContext;               {fourni pendant Init}

            ErrComp:Integer;
            ligneC,colonneC:integer;
            ErrorFile:AnsiString;

            BadUnitError:AnsiString;
            BadUnitLine,BadUnitCol:integer;
            BadUnitFile:AnsiString;

            Fsymbole:TgenreSymb;
            Symbole:PdefSymbole;     {dernier symbole ramené par tableSymbole}
            NumUnit:integer;         {Unité de ce dernier symbole}
            LastTable:TtableSymbole; {Table correspondant à NumUnit }

            stMotUlex:shortString;    { Le dernier mot ramené par lireUlex }
            stMotUlexMaj:shortString; { ID en majuscules }
            

            BlocTraitementExiste,BlocInitExiste,
            BlocInit0Existe,BlocContExiste,BlocFinExiste:boolean;

            Plex:ptUlex;           {pointeur d'écriture du code}
            PlexFin:ptUlex;        {recoit Plex en fin de compilation}

            FlagArray:boolean;
            TailleLastVar:integer;
            NumeroProc:Integer;    { Permet de transmettre
                                    le numéro de procédure }

            Renvoye:Integer;
            ObjRenvoye:boolean;

            tbWith:array[1..maxWith] of TWithRec;
            nbWith:integer;
            nbWithImp:integer;
            Qualifie:boolean;


            pgSimple:boolean;

            {Source}
            stList:TUgetText;

            {WITH implicites}
            stImplicit:TstringList;

            {Debug info}
            OldLine:integer;

            maxTables:integer;


            Ulex1:TUlex1;

            stError: AnsiString;
            genericError:AnsiString;

            DollarBplus:boolean;

            TailleLocale:integer;

            BuildMode:boolean;
            ExtraMode:boolean;
            { variables utilisées par creerExp1
            IsExp1:boolean;
            n1Exp1:ptUlex;
            isVarExp1:boolean;
            numObExp1:integer;
            symbExp1:PdefSymbole;
            typExp1:typeNombre;
            vszExp1:integer; }

            FlagCondition,FlagCompile:boolean;
            DefineList:TstringList;

            fileName: AnsiString;

            procedure sortie(n:integer);overload;
            procedure sortie(st:AnsiString);overload;

            procedure setDebugInfo;
            procedure suivant;
            procedure Inserer1(n:ptUlex;t:typeLex);
            procedure Inserer2(rac:ptUlex;nb:integer);
            function insererTokenConv(n1:ptUlex;tp1,tp:typeNombre):boolean;

            function depToPlex(d:integer):PtUlex;
            function PlexToDep(p:PtUlex):integer;

            procedure accepte(tp:typeLex);overload;
            procedure accepte(tp:typeLex; tp2:typeLex2);overload;

            function accepteType0(tpSouhaite,tp:typeNombre):boolean;
            procedure accepteType(tpSouhaite,tp:typeNombre);
            procedure accepteTypeDef(DefSouhaite:integer;tp:typeNombre;tpO:integer);

            procedure accepteReference(tp:typeNombre;typ:typeNombre;nbtp:integer);
            function typeResultat(t1,t2:typeNombre;op:typeLex):typeNombre;

            function  getCompilerString(err:integer):AnsiString;
            procedure BuildExtraStError;

            function traiterSlash(st:shortString):boolean;virtual;

            procedure identifierSymbole(var Ulex:typeUlex);
            procedure identifierMot(var Ulex:typeUlex);


            procedure accepteRefObjet(pp:typeParam;Vob:Integer);
            procedure accepteRefObjet1(minP:Integer;Vob:integer);

            procedure controleRefProc(num:integer);

            procedure analyseDirective(st:AnsiString);virtual;
            procedure lireUlex;
            procedure creerLex;
            procedure inserer(rac:ptUlex);
            procedure InsererUlex(t:typeLex);
            procedure creerVariableTableau(Atable:TtableSymbole;sz:integer);
            procedure creerStChar(n:ptUlex);
            procedure creerComplexQualif(n1:ptUlex;var typ:typeNombre;var vsz:integer);

            procedure creerRefDef(var typ:typeNombre;var vsz,numOb:integer);

            procedure creerMotOrd(var typ:typeNombre);
            procedure creerAtome(var typ:typeNombre;var vsz:integer);
            procedure creerReferenceVar(var typ:typeNombre;var vsize:integer;flagVarSansType:boolean);

            procedure creerFacteur(var typ:typeNombre;var vsz:integer);
            procedure creerTerme(var typ:typeNombre;var vsz:integer);
            procedure creerExpSimple(var typ:typeNombre;var vsz:integer);
            procedure creerExp(var typ:typeNombre;var vsz:integer);

            procedure creerFacteur1(var typ:typeNombre;var vsz:integer;var ww: Texp1set);
            procedure creerTerme1(var typ:typeNombre;var vsz:integer;var ww: Texp1set);
            procedure creerExpSimple1(var typ:typeNombre;var vsz:integer;var ww: Texp1set);
            procedure creerExp1_(var typ:typeNombre;var vsz:integer;var ww: Texp1set);
            procedure creerExp1(var typ:typeNombre;var vsz:integer;var ww: Texp1set);

            procedure creerRefObjet(var typ:typeNombre;var Vob:Integer);

            procedure creerListeParam(p:PdefProc;pnb:PtUlex);
            procedure creerListeParam1(var p:PdefProc;pnb,p0:PtUlex);

            procedure creerAppelProcedure;
            procedure creerListeParamU(TablePDefSymbole:TtableSymbole;p:PdefSymbole;pnb:PtUlex);
            procedure creerAppelProcU;
            function creerAppelFoncU(var typ:typeNombre): integer;
            procedure creerAppelFonction(var typ:typeNombre;var obres:integer);
            procedure creerAppelTransTypage(var typ:typeNombre;var obres:integer);

            procedure creerAffectation1(n1:ptUlex;typ:typeNombre;symb:PdefSymbole);

            procedure creerInstComposee;
            procedure creerInstIF;
            Procedure creerInstRepeat;
            Procedure creerInstWhile;
            Procedure creerInstFor;
            procedure creerInstCase;
            procedure creerWith;

            procedure creerIncDec;

            function creerInstruction: typeNombre;
            function creerInst1:typeNombre;
            procedure creerInstructionSimple;
            procedure compilerPgSimple;

            function ValidIdentiFier(Flocal:boolean):boolean;
            Procedure creerConstPart(Ssymb:typeSymbole);
            procedure creerArray;
            Procedure creerVarPart(Ssymb:typeSymbole);


            Procedure CreerTypeSimple(stTypeName:AnsiString;Typeline:integer);
            Procedure creerTypeRecord(stTypeName:AnsiString;Typeline:integer);
            Procedure creerTypeClass(stTypeName:AnsiString;Typeline:integer);
            Procedure creerTypeArray(stTypeName:AnsiString;Typeline:integer);
            Procedure CreerTypeEnum(stTypeName:AnsiString;Typeline:integer);
            Procedure CreerTypeAlias(stTypeName:AnsiString;Typeline:integer);
            Procedure creerTypePart(Flocal:boolean);

            procedure creerCorpsBloc;
            Procedure creerTraitPart;
            Procedure creerInit0Part;
            Procedure creerInitPart;
            Procedure creerContPart;
            Procedure creerFinPart;
            Procedure creerProgPart;
            procedure creerNomDeTypeSimple(var tpnb:typeNombre);
            procedure creerNomDeType(var tpnb:typeNombre;var attribut:integer);
            procedure creerListeParamFormels(NewProc:boolean);
            procedure creerCorpsDeclaration(newProc:boolean);
            procedure creerCorpsProcedure;
            procedure creerProcU;
            procedure creerFoncU;
            procedure compilerPgComplexe;

            procedure compiler;
            procedure compilerExtra(Pdata:pointer);

            procedure compilerPg1;
            procedure compilerPg1Extra(Pcode,Pdata:pointer);

            procedure DisplayErrorMessage;

            procedure OpenBox;
            procedure CloseBox;

            procedure TraiterRenvoye;
            function ajouteWith(v:byte;U:integer;symb:PdefSymbole):integer;
            function ajouteWithImp(v:byte):integer;
            procedure supprimeWith(nb:Integer);
            function traiterWith:boolean;
            function getWithVob(d:integer):integer;
            function DepToWithRec(d:integer):Twithrec;

            procedure initWith;virtual;

            function nbTypeObjet:integer;
            function nomObjet(n:integer):AnsiString;

            procedure ajouteImplicit(st1:AnsiString);

            procedure setFreeThisObject(p:TFreeThisObject);

            procedure installeImplicit;


            procedure creerUses;
            procedure creerBlocInterface;
            procedure creerBlocImplementation;
            procedure creerUnit;

            procedure coderObjet(n1:ptUlex;
                             var AT: TatomType;var typ:typeNombre;
                             var vsize:integer;var numOb:integer;
                             var symb:PdefSymbole);
            procedure coderDef(n1:ptUlex;
                             var AT:TatomType;var typ:typeNombre;
                             var vsize:integer;var numOb:integer;
                             var symb:PdefSymbole);
            procedure coderAtome0(n1:ptUlex;
                             var AT: TatomType;var typ:typeNombre;
                             var vsize:integer;var numOb:integer;
                             var symb:PdefSymbole);
            procedure coderAtome(var n1:ptUlex;
                             var AT: TatomType;var typ:typeNombre;
                             var vsize:integer;var numOb:integer;
                             var symb:PdefSymbole);


            function getConditionValue(st:AnsiString):boolean;
            procedure addCondition(st:AnsiString;Fdef:boolean);
            procedure SwapCondition;
            procedure RemoveCondition;

            function Tables:PtablesSymbole;

            procedure NouveauSymbole(id: typeSymbole;st:AnsiString;lineNum:integer);

          public
            ownerForm:Tform;
            ownerName:AnsiString;

            UnitName:AnsiString;
            CurrentPrefix: AnsiString;

            constructor create(tbPrc:TtabDefProc;tbAdr:TtabAdresse);
            destructor destroy;override;

            procedure init(stSource:TUgetText;pgContext:TpgContext);

            procedure resetPg;virtual;
            procedure compilerPg(var stError1:AnsiString;var lig,col:integer;var ErrFile:AnsiString; Fbuild:boolean;Pcode: pointer;Pdata:pointer; var Pend:pointer);

            procedure NewSource;
            function getNumProcHlp(st:AnsiString):integer;

            procedure resetImplicit;
            procedure setImplicit(st:AnsiString);


            property freeThisObject: TfreeThisObject write setFreeThisObject;
            function lastError:AnsiString;


          end;


IMPLEMENTATION

uses stmPg;

type
  Ecompil=class(exception);


constructor Tcompil.create(tbPrc:TtabDefProc;tbAdr:TtabAdresse);
begin

  tabProc:=tbPrc;
  adresseProcedure:=tbAdr;

  stImplicit:=TstringList.create;
  defineList:=TstringList.create;
end;

destructor Tcompil.destroy;
begin
  stImplicit.free;
  defineList.Free;
end;

procedure Tcompil.init(stsource:TUgetText;pgContext:TpgContext);
begin
  stList:=stSource;
  fileName:= extractFileName(stSource.fileName);
  fileName:= changeFileExt(filename,'');

  pgC:=pgContext;
  tableSymbole:=pgc.tableSymbole;
  MaxTables:=0;
  Tables[0]:=pgc.tableSymbole;
end;



function Tcompil.traiterSlash(st:shortString):boolean;
  begin
    traiterSlash:=false;
  end;







const
  E_IdentificateurTropLong       =1;
  E_NombreReel                   =2;
  E_CaractereInconnu             =3;
  E_Chaine                       =4;

  E_IncludeFile                  =10;

  E_generic                      =99;

  E_baseLex                      =100;
  E_baseTypeSouhaite             =300;
  E_baseReference                =500;

  E_TypeOperandes                =601;
  E_tailleTampon                 =602;
  E_traceInconnue                =603;
  E_objet                        =604;
  E_operandeEntierOuBoolean      =605;
  E_TraceNonAffectable           =606;
  E_expressionBooleenne          =607;
  E_variableEntiere              =608;
  E_expressionEntiere            =609;
  E_Instruction                  =610;
  E_instructionSimple            =611;
  E_tamponSymbole                =612;
  E_constante                    =613;
  E_longueurDeChaine             =615;
  E_NomDeType                    =616;
  E_blocTraitementExiste         =617;
  E_blocInitExiste               =618;
  E_blocFinExiste                =619;
  E_NbProgram                    =620;
  E_LongueurNomProgram           =621;
  E_bloc                         =622;
  E_nomDeTypeAttendu             =623;
  E_referenceVariable            =624;
  E_traceNonManipulable          =625;
  E_directive                    =626;
  E_nomProgram                   =627;

  E_blocInit0Existe              =628;
  E_blocContExiste               =629;

  E_segmentDS                    =630;
  E_indiceTableau                =631;
  E_methodeAttendue              =632;
  E_Chargeprc                    =633;
  E_AllouerPrc                   =634;
  E_with                         =635;

  E_refProcedure                 =650;

  E_tableSymb                    =651;
  E_allouerDS                    =652;
  E_allouerCS                    =653;
  E_ulex1                        =654;

  E_refObjectExpected            =655;
  E_nomUnite                     =656;
  E_ProcNonConforme              =657;
  E_UnitNotLoaded                =658;

  E_IdentInconnu                 =659;
  E_RpartImPart                  =660;

  E_typeDef                      =661;
  E_simpleVariable               =662;
  E_fieldExpected                =663;
  E_noObjField                   =664;
  E_defExpected                  =665;
  E_badDefTYpe                   =666;
  E_ObjOrDef                     =667;

  E_UndefinedProc                =668;

const
  EnteteBloc=[motVAR,motCONST,motPROCEDURE,motFUNCTION,
              motPROGRAM,
              motProcess,motEndProcess,motInitProcess,
              motProcessCont,motInitProcess0,
              motType];





procedure Tcompil.sortie(n:integer);
begin                                                                                                       
  errComp:=n;
  raise  Ecompil.create('');
end;

procedure Tcompil.sortie(st:AnsiString);
begin
  errComp:=E_generic;
  GenericError:=st;

   raise Ecompil.create(st);
end;


procedure Tcompil.setDebugInfo;
var
  p:TAdListRecord;
  line,col:integer;
  stFile:AnsiString;
begin
  Ulex1.getLastPos(line,col,stFile);
  if line<>oldLine then
    begin
      p.ad :=intG(Plex)-intG(pgc.cs);
      p.num:=line;
      pgc.AdList.add(@p);

      oldLine:=line;
      {messageCentral(Istr(ligneC)+' '+Istr(intG(Plex)-intG(pgc.cs)));}

      if (line mod 1000=0) and assigned(CompilBox)
        then compilBox.progressBar1.position:=stList.getPos;
    end;
end;

{
  LireUlex ne modifie pas Plex. Après lireUlex, Plex pointe sur l'Ulex lue.
  Suivant fait avancer Plex.
  CreerLex appelle Suivant et lireUlex .
}

procedure Tcompil.suivant;
begin
  Plex:=UlexSuivant(Plex);
end;


function Tcompil.depToPlex(d:integer):PtUlex;
begin
  result:= pointer(intG(pgc.cs)+d);
end;

function Tcompil.PlexToDep(p:PtUlex):integer;
begin
  result:=intG(P)-intG(pgc.cs);
end;

procedure Tcompil.identifierSymbole(var Ulex:typeUlex);
begin
  with Ulex do
  begin
    case symbole^.ident of
      Sneant: begin
                genre:=motNouveau;
                st:=stMotUlexMaj;
              end;

      Svar:   with Symbole^.infV do
              begin
                adV:=LastTable.symbDep(symbole);
                {On range le déplacement du symbole, pas le déplacement de la variable}
                numUnitVar:=numUnit;
                FlagArray:=(depTab>=0);

                tailleLastVar:=LastTable.VariableSize(Symbole,true);

                case tp of
                  nbByte..nbChar,nbAnsiString: genre:=typeLex(ord(variByte)+ord(tp)-ord(nbByte));

                  nbChaine:  begin
                               genre:=variC;
                               longC:=att0;
                             end;

                  refObject: begin
                               genre:=variObject;
                               Vob:=att0;
                             end;

                  nbDef: begin
                           genre:=variDef;
                           sz:=LastTable.VariableSize(symbole,false);
                           adDef:=LastTable.symbDep(symbole);
                           numUnitDef:=numUnit;
                         end;
                end;
              end;

      SvarLoc:with Symbole^.infV do
              begin
                dep:=deplacement;
                FlagArray:=(depTab>=0);
                tailleLastVar:=LastTable.VariableSize(Symbole,true);
                case tp of
                  nbByte..nbExtended,nbBoole,nbChar,nbAnsiString,nbDateTime:
                    genre:=typeLex(ord(variLocByte)+ord(tp)-ord(nbByte));
                  nbSingleComp,nbDoubleComp,nbExtComp,nbvariant:
                    begin
                      if dep<0
                        then genre:=typeLex(ord(variLocByte)+ord(tp)-ord(nbByte))
                        else genre:=typeLex(ord(RefLocByte)+ord(tp)-ord(nbByte))
                    end;
                  nbDef:     begin
                               if dep<0
                                 then genre:=variLocDef
                                 else genre:=refLocDef;
                               sz1:=LastTable.VariableSize(symbole,false);
                               // sz1 pas sz !!!
                               depDef:=Deplacement;
                             end;
                  nbChaine:  begin
                               if dep<0 then genre:=variLocC
                                        else genre:=refLocC;
                               longCloc:=att0;
                             end;
                  refByte..refChar,refAnsiString:
                    genre:=typeLex(ord(RefLocByte)+ord(tp)-ord(refByte));

                  refChaine: begin
                               genre:=refLocC;
                               longCloc:=att0;
                             end;
                  refObject: begin
                               if dep<0 then genre:=variLocObject
                                        else genre:=refLocObject;
                               VobLoc:=att0;
                               dep:=deplacement;
                             end;
                  refDef:    begin
                               genre:=refLocDef;
                               sz1:=LastTable.VariableSize(symbole,false);
                               depDef:=Deplacement;
                             end;
                end;
              end;

      Sconst,SconstLoc:
              with Symbole^.infC do
              begin
                case tp of
                  nbSmall:  begin
                               genre:=nbI;
                               vnbi:=i;
                             end;
                  nbLong:    begin
                               genre:=nbL;
                               vnbl:=l;
                             end;
                  nbExtended:begin
                               genre:=nbR;
                               vnbR:=r;
                             end;
                  nbBoole:   if b then genre:=motTRUE
                                  else genre:=motFALSE;
                  nbchar:    begin
                               genre:=constCar;
                               vc:=c;
                             end;
                  nbChaine:  begin
                               st:=stc;
                               genre:=ChaineCar;
                             end;
                end;
              end;

      SprocU: with Symbole^.infP do
              begin
                if result1=nbNul then genre:=procU
                                else genre:=foncU;
                tpRes1:=result1;
                numUnitProc:=numUnit;
                adU:=LastTable.symbDep(symbole);
                {On range le déplacement du symbole, pas le déplacement de la procedure}
                nbParU:=symbole^.infP.nbParam;
              end;

      Stype: with Symbole^.infoType do
             begin

               case TNgenre of
                 TNsimple: genre:=nbtores(tpSimple);
                 else genre:=Utype;
               end;
             end;
    end; { of case symbole }
  end;
end;

procedure Tcompil.identifierMot(var Ulex:typeUlex);
var
  n:integer;
begin

  with Ulex do
  begin
    {D'abord les mots réservés}
    getLexRes(stMotUlexMaj, genre, Vlex2);
    if genre<>vid then
    begin
      Fsymbole:=GSmotres;
      exit;
    end;

    {Les noms d'unité}
    n:=pgc.UsesList.IndexOf(stMotUlexMaj);
    if n>=0 then
    begin
      genre:=UnitN;
      numU:=n+1;
      Fsymbole:=GSunit;
      exit;
    end;


    {La table de symboles principale}
    numUnit:=0;
    LastTable:=TableSymbole;

    symbole:=nil;
    if CurrentPrefix<>'' then symbole:=tablesymbole.getSymbole(CurrentPrefix + stMotUlexMaj);
    if not assigned(symbole) then symbole:=tablesymbole.getSymbole(stMotUlexMaj);

    {Les tables de symboles des unités}
    if not assigned(symbole) and (maxTables>0) then
      begin
        numUnit:=maxTables+1;
        repeat
          dec(numUnit);
          LastTable:=tables[numUnit];
          symbole:=LastTable.getSymboleINT(stMotUlexMaj);
        until (numUnit=1) or assigned(symbole);
      end;

    if assigned(symbole) then
      begin
        if NumUnit=0
          then Fsymbole:=GSsymb0
          else Fsymbole:=GSsymbN;
        identifierSymbole(Ulex);
        exit;
      end
    else
    begin
      numUnit:=0;
      LastTable:=tableSymbole;
    end;

    {La table PRC}
    NumeroProc:=TabProc.getNumProc1(stMotUlexMaj,PdefProc(NumProced),-1);

    if NumeroProc<>0 then
      begin
        Fsymbole:=GSfps;
        if PdefProc(NumProced)^.Vresult=nbNul  then genre:=Proced
        else
        if byte(PdefProc(NumProced)^.Vresult)=254  then
          begin
              with PdefProc(NumProced)^.getConstante^ do
              begin
                case tp of
                  nbSmall:  begin
                               genre:=nbI;
                               vnbi:=i;
                             end;
                  nbLong:    begin
                               genre:=nbL;
                               vnbl:=l;
                             end;
                  nbExtended:begin
                               genre:=nbR;
                               vnbR:=r;
                             end;
                  nbBoole:   if b then genre:=motTRUE
                                  else genre:=motFALSE;
                  nbChaine:  begin
                               st:=stc;
                               if length(st)=1
                                 then genre:=ConstCar
                                 else genre:=ChaineCar;
                             end;
                end;
              end;
          end
        else
        begin
          genre:=Fonc;
          tpRes:=PdefProc(NumProced)^.Vresult;
        end;
        exit;
      end;

    {La table PRC pour les noms d'objets}
    n:=tabProc.getNumObj(stMotUlexMaj);
    if n>=0 then
      begin
        Fsymbole:=GSfps;
        genre:=TypeObjet;
        VobTO:=n;
        exit;
      end;


    genre:=motNouveau;
    st:=stMotUlexMaj;
    Fsymbole:=GSnone;

  end; { of with Ulex }
end;

function Tcompil.getConditionValue(st:AnsiString):boolean;
begin
  st:=Fmaj(st);

  if st='ELPHY2' then result:=IsElphy2
  else
  result:= (DefineList.indexof(st)>=0);
end;

procedure Tcompil.addCondition(st:AnsiString;Fdef:boolean);
begin
  if FlagCondition then sortie('Unexpected conditional directive');

  FlagCondition:=true;
  FlagCompile:=getConditionValue(st);
  if not Fdef then FlagCompile:=not FlagCompile;
end;

procedure Tcompil.swapCondition;
begin
  if not FlagCondition then sortie('Unexpected ELSE directive');

  FlagCompile:=not FlagCompile;
end;

procedure Tcompil.RemoveCondition;
begin
  if not FlagCondition then sortie('Unexpected ENDIF directive');

  FlagCondition:=false;
end;


procedure Tcompil.analyseDirective(st:AnsiString);
var
  ii, code: integer;
begin
  st:=Fmaj(st);
  if (length(st)>=2) and (st[1]='B') then
  case st[2] of
    '+':DollarBplus:=true;
    '-':DollarBplus:=false;
  end
  else
  if Fmaj(copy(st,1,6))='IFDEF ' then
  begin
    delete(st,1,6);
    st:=sortirMot([],st);
    if st<>'' then addCondition(st,true);
  end
  else
  if Fmaj(copy(st,1,7))='IFNDEF ' then
  begin
    delete(st,1,7);
    st:=sortirMot([],st);
    if st<>'' then addCondition(st,false);
  end
  else
  if (Fmaj(copy(st,1,4))='ELSE') and ((length(st)=4) or (st[5]=' '))
    then SwapCondition
  else
  if (Fmaj(copy(st,1,5))='ENDIF') and ((length(st)=5) or (st[6]=' '))
    then RemoveCondition
  else
  if (Fmaj(copy(st,1,7))='DEFINE ') then
  begin
    delete(st,1,7);
    st:=sortirMot([],st);
    defineList.add(Fmaj(st));
  end;
end;



function Tcompil.ajouteWith(v:byte;U:integer;symb:PdefSymbole):integer;
  begin
    if nbWith>=maxWith then sortie('Too many WITH instructions');
    inc(nbWith);
    with tbWith[nbWith] do
    begin
      isObj:=(v>0);
      if isObj then Ob:=v
      else
      begin
        unitW:=U;
        symbW:=symb;
      end;
      dep:=-(nbWith-nbWithImp)*8-tailleLocale;
      result:=dep;
    end;
  end;

function Tcompil.ajouteWithImp(v:byte):integer;
  begin
    if nbWith>=maxWith then sortie('Too many WITH instructions');
    inc(nbWith);
    inc(nbWIthImp);
    with tbWith[nbWith] do
    begin
      isObj:=true;
      Ob:=v;
      dep:=(nbwithImp-1)*8+4;
      result:=dep;
    end;
  end;

function Tcompil.getWithVob(d:integer):integer;
begin
  if d>0
    then d:=(d-4) div 8+1
    else d:=(-d-tailleLocale) div 8 +nbWithImp;

  result:=tbWith[d].ob;
end;

function Tcompil.DepToWithRec(d:integer):Twithrec;
begin
  if d>0
    then d:=(d-4) div 8+1
    else d:=(-d-tailleLocale) div 8 +nbWithImp;

  result:=tbWith[d];
end;

procedure Tcompil.supprimeWith(nb:integer);
  begin
    if nb>nbWith then nb:=nbWith;
    nbWith:=nbWith-nb;
  end;

procedure Tcompil.initWith;
  begin
    nbWith:=0;
  end;

procedure Tcompil.TraiterRenvoye;
  begin
    if renvoye=2 then
      begin
        Plex^.genre:=pointL;
        dec(renvoye);
      end
    else
    if renvoye=1 then
      begin
        identifierMot(Plex^);
        dec(renvoye);
      end;

  end;



function Tcompil.traiterWith:boolean;
  var
    i,num:Integer;
    Pdef:PdefProc;
    Symb:PdefSymbole;
    typeTable:TtableSymbole;
  begin
    traiterWith:=false;
    if (nbWith=0) or Qualifie then exit;

    i:=nbWith;
    symb:=nil;
    num:=0;
    while (i>0) and (num=0) and (symb=nil) do
    with tbWith[i] do
    begin
      if isObj
        then Num:=TabProc.getNumProc1(stMotUlexMaj,Pdef,Ob)
        else Symb:=tables[UnitW].getField(symbW,stMotUlexMaj,typeTable);
      dec(i);
    end;
    if (num=0) and (symb=nil) then exit;

    if num>0 then
    begin
      Plex^.genre:=TpObjectInd;
      Plex^.depTPO:=tbWith[i+1].dep;
      renvoye:=2;
      ObjRenvoye:=true;
    end
    else
    begin
      Plex^.genre:=TpInd;
      Plex^.depInd:=tbWith[i+1].dep;

      // 23 fev 20016 : Ces deux lignes sont absurdes car symbW est un Stype
      // Plex^.tpInd1:=tbWith[i+1].symbW.infV.tp;
      // Plex^.szInd:=tbWith[i+1].symbW.infV.varSize;
      // Pas d'importance en général. Mais on remplace par les lignes suivantes
      
      with tbWith[i+1] do
      begin
        Plex^.tpInd1:= nbdef;
        Plex^.szInd:= tables[unitW].typeSize(symbW);
      end;

      renvoye:=2;
      ObjRenvoye:=false;
    end;

    traiterWith:=true;
  end;

procedure Tcompil.lireUlex;
  var
    x0:float;

  begin
    flagArray:=false;

    if renvoye>0 then
       begin
         TraiterRenvoye;
         {messageCentral(nomLex(plex^.genre));}
         exit;
       end;

    Fsymbole:=GSnone;
    repeat
      with Plex^ do
      begin
        if FlagCondition and not FlagCompile
          then Ulex1.lireIgnore(stMotUlex,genre,x0,errComp)
          else Ulex1.lire(stMotUlex,genre,x0,errComp);
        stMotUlexMaj:=Fmaj(stMotUlex);
        {messageCentral(Istr(intG(Plex))+'  '+stmotUlex+'  '+nomlex(Plex^.genre));}
        if errComp<>0 then sortie(errComp);
        case genre of
          nbi:       vnbi:=roundI(x0);
          nbL:       vnbL:=roundL(x0);
          nbR:       vnbR:=x0;
          chaineCar:   {$IFDEF FPC}
                       st:=AnsiToUTF8(stMotUlex);
                       {$ELSE}
                       st:=stMotUlex;
                       {$ENDIF}


          constCar:   {$IFDEF FPC}
                      vc:=AnsiToUTF8(stMotUlex[1])[1];
                      {$ELSE}
                      vc:=stMotUlex[1];
                      {$ENDIF}
        end;
        if genre=vid then
          if not TraiterWith
            then identifierMot(Plex^);
      end;

      if Plex^.genre=directive then AnalyseDirective(stMotUlex);
    until Plex^.genre<>directive;
    {messageCentral(nomLex(plex^.genre));}

    if Plex^.genre=UnitN then
    begin
      NumUnit:=Plex^.numU;
      Ulex1.lire(stMotUlex,Plex^.genre,x0,errComp);
      if errComp<>0 then sortie(errComp);
      accepte(pointL);

      Ulex1.lire(stMotUlex,Plex^.genre,x0,errComp);
      if errComp<>0 then sortie(errComp);
      stMotUlexMaj:=Fmaj(stMotUlex);

      LastTable:=tables[numUnit];
      symbole:=LastTable.getSymbole(stMotUlexMaj);
      if NumUnit=0
          then Fsymbole:=GSsymb0
          else Fsymbole:=GSsymbN;
      if assigned(symbole)
        then identifierSymbole(Plex^)
        else sortie(E_identInconnu);
    end;
  end;


procedure Tcompil.accepte(tp:typeLex);
begin
  if pLex^.genre<>tp then sortie(E_baseLex+ord(tp));
end;

procedure Tcompil.accepte(tp:typeLex; tp2:typeLex2);
begin
  if (pLex^.genre<>tp) or (pLex^.Vlex2<>tp2)  then sortie(E_baseLex+ord(tp));
end;

function Tcompil.accepteType0(tpSouhaite,tp:typeNombre):boolean;
begin
  if (tp=nbVariant) or (tpSouhaite=nbvariant) then result:=true
  else
  if (tp=tpSouhaite) then result:=true
  else
  case tpSouhaite of
    nbByte..nbint64:      result:=(tp>=nbByte) and (tp<=nbInt64);
    nbsingle..nbExtended: result:=(tp>=nbByte) and (tp<=nbExtended);

    nbSingleComp..nbExtComp:
                          result:=(tp>=nbByte) and (tp<=nbExtComp);

    nbChaine,nbANSIString:
                    result:=(tp=nbChaine) or (tp=nbANSIString) or (tp=nbChar);

    else result:=false;
  end;
end;

procedure Tcompil.accepteType(tpSouhaite,tp:typeNombre);
begin
  if not accepteType0(tpSouhaite,tp) then sortie(E_baseTypeSouhaite+ord(tpSouhaite));
end;

procedure Tcompil.accepteTypeDef(DefSouhaite:integer;tp:typeNombre;tpO:integer);
begin
  if not (tp in [nbDef,refDef])
     or
     (DefSOuhaite<>tpO)
   then sortie(E_badDefTYpe);
end;

procedure Tcompil.accepteReference(tp:typeNombre;typ:typeNombre;nbtp:integer);
begin
  byte(typ):=byte(typ)+(ord(refByte)-ord(nbByte));

  if (typ<tp) OR (ord(typ)>ord(tp)+nbtp)
    then sortie(E_baseReference+ord(tp));
end;


function Tcompil.typeResultat(t1,t2:typeNombre;op:typeLex):typeNombre;
  begin
    typeResultat:=t1;

    if (t1=nbvariant) OR (t2=nbvariant) then
    begin
      if op in [ plus,moins,mult,divis,OpDiv,OpMod,OpAnd,OpOr,OpXor, OpShl,OpShr]
        then result:=nbvariant
        else result:= nbBoole;
    end
    else
    if (t1 in [nbchar,nbChaine,nbAnsiString]) and (t2 in [nbchar,nbChaine,nbAnsiString]) and (op=Plus)
      then result:=nbchaine
    else
    case op of
      plus,moins,mult:
        if (t1>=nbByte) and (t1<=nbExtComp) and
           (t2>=nbByte) and (t2<=nbExtComp) then
           begin
             if t2>t1 then result:=t2;
           end
        else sortie(E_TypeOperandes);

      divis:
        if (t1>=nbByte) and (t1<=nbExtended) and
           (t2>=nbByte) and (t2<=nbExtended) then  result:=nbExtended
        else
        if (t1>=nbByte) and (t1<=nbExtComp) and
           (t2>=nbByte) and (t2<=nbExtComp) then result:=nbExtComp
        else sortie(E_TypeOperandes);

      OpDiv,OpMod,OpAnd,OpOr,OpXor:
        if (t1>=nbByte) and (t1<=nbInt64) and
           (t2>=nbByte) and (t2<=nbInt64)
           or
           (t1=nbBoole) and (t2=nbBoole) and (op in [OpAnd,OpOr,OpXor])
          then
            begin
              if t2>t1 then result:=t2;
            end
        else sortie(E_TypeOperandes);

      OpShl,OpShr:
        if (t1>=nbByte) and (t1<=nbInt64) and
           (t2>=nbByte) and (t2<=nbInt64) then exit
        else sortie(E_TypeOperandes);

      egal,inf,infEgal,sup,supEgal,different:
        if (t1>=nbByte) and (t1<=nbExtComp) and (t2>=nbByte) and (t2<=nbExtComp)
           or
           (t1=nbBoole) and (t2=nbBoole)
           or
           (t1=nbChar) and (t2=nbChar)
           or
           (t1 in [nbchar,nbChaine,nbAnsiString]) and (t2 in [nbchar,nbChaine,nbAnsiString])
          then result:=nbBoole
          else sortie(E_TypeOperandes);

      else sortie(E_TypeOperandes);
    end;
  end;

procedure Tcompil.creerLex;
  begin
    Suivant;
    if intG(Plex)-intG(pgC.CS)>pgC.CodeSize+codeExtraSize-300 then sortie(E_tailleTampon);
    lireUlex;
  end;

procedure Tcompil.inserer(rac:ptUlex);        { L'opérateur pointé par Plex}
  var                                         { est inséré à la racine     }
    a:typeLex;                                { Ensuite, Plex pointe sur   }
  begin                                       { un nouvel élément          }
    a:=Plex^.genre;
    move(rac^,rac^.vnbi,intG(Plex)-intG(rac));
    rac^.genre:=a;
    inc(intG(Plex),sizeof(typelex));
    lireUlex;
  end;



procedure Tcompil.InsererUlex(t:typeLex);
         { L'unité désignée par Plex est }
         { déplacée afin d'aménager une place pour un élément de genre t }
         { Une chaineCar ou un motNouveau ne peut être inséré de cette fa‡on }
         { Plex n'est pas modifié }
  var
    taille:Integer;
    U:typeUlex;
    n1:ptUlex;
  begin
    U.genre:=t;
    taille:=tailleUlex(U);
    n1:=Plex;
    inc(intG(n1),taille);
    move(Plex^,n1^,tailleUlex(Plex^));
    Plex^.genre:=t;
  end;

procedure Tcompil.Inserer1(n:ptUlex;t:typeLex);
         { Les unités comprises entre n et Plex sont }
         { déplacées afin d'aménager une place pour un élément de genre t }
         { Une chaineCar ou un motNouveau ne peut être inséré de cette façon }
         { Plex est modifié }
  var
    taille:Integer;
    U:typeUlex;
    n1:pointer;
  begin
    U.genre:=t;
    taille:=tailleUlex(U);
    n1:=n;
    inc(intG(n1),taille);
    move(n^,n1^,intG(UlexSuivant(Plex))-intG(n));
    n^.genre:=t;
    inc(intG(Plex),taille);
  end;

{Insertion de nb octets en rac^. Plex est incrémenté de nb }
procedure Tcompil.inserer2(rac:ptUlex;nb:integer);
var
  p:ptULex;
begin
  p:=rac;
  inc(intG(p),nb);
  move(rac^,p^,intG(UlexSuivant(Plex))-intG(rac));
  inc(intG(Plex),nb);
end;


{convertir tp1 en tp}
function Tcompil.insererTokenConv(n1:ptUlex;tp1,tp:typeNombre):boolean;
begin
  result:=true;
  case tp of
     nbSingleComp..nbExtComp:
       case tp1 of
         nbByte..nbDword:        inserer1(n1,cvIComp);
         nbSingle..nbExtended:   inserer1(n1,cvRComp);
         nbvariant:              inserer1(n1,cvVariantComp);
         else result:=false;
       end;

     nbSingle..nbExtended:
       case tp1 of
         nbByte..nbDword:        inserer1(n1,cvIR);

         nbInt64:                inserer1(n1,cvInt64R);

         nbvariant:              inserer1(n1,cvVariantR);
         else result:=false;
       end;

     nbByte..nbDword:
       case tp1 of
         nbInt64:   inserer1(n1,cvInt64I);
         nbvariant: inserer1(n1,cvVariantI);
         else result:=false;
       end;

     nbInt64:
       case tp1 of
         nbByte..nbDword:        inserer1(n1,cvIInt64);
         nbvariant:              inserer1(n1,cvVariantI64);
         else result:=false;
       end;

     nbChaine,nbAnsiString,nbChar:
       if tp1=nbVariant
         then inserer1(n1,cvVariantSt)
         else result:=false;

     nbBoole:
       if tp1=nbVariant
         then inserer1(n1,cvVariantBoole)
         else result:=false;

     nbDateTime:
       if tp1=nbVariant
         then inserer1(n1,cvVariantDateTime)
         else result:=false;

     nbVariant:
       case tp1 of
         nbByte..nbDword:             inserer1(n1,cvIVariant);
         nbInt64:                     inserer1(n1,cvI64Variant);
         nbSingle..nbExtended:        inserer1(n1,cvRVariant);
         nbSingleComp..nbExtComp:     inserer1(n1,cvCompVariant);
         nbChaine,nbAnsiString:       inserer1(n1,cvStVariant);
         nbBoole:                     inserer1(n1,cvBooleVariant);
         nbDateTime:                  inserer1(n1,cvDateTimeVariant);
         refObject:                   inserer1(n1,cvObjectVariant);
         else result:=false;
       end;

      refObject:
        if tp1=nbvariant
          then inserer1(n1,cvVariantObject)
          else result:=false;
     else result:=false;
  end;
end;

{ Ne modifie que les opérateurs de comparaison }
procedure changerOperateur(var t:typeLex;typ:typeNombre);
  begin
    case t of
      egal:  case typ of
               nbByte..nbDword:              t:=egalI;
               nbInt64:                      t:=egalI64;
               nbSingle..nbExtended:         t:=egalR;
               nbSingleComp..nbExtComp:      t:=egalComp;
               nbBoole:                      t:=egalB;
               nbChar,nbChaine,nbAnsiString: t:=egalC;
               nbvariant:                    t:=egalV;
             end;
      different:
             case typ of
               nbByte..nbDword:              t:=differentI;
               nbInt64:                      t:=differentI64;
               nbSingle..nbExtended:         t:=differentR;
               nbSingleComp..nbExtComp:      t:=DifferentComp;
               nbBoole:                      t:=differentB;
               nbChar,nbChaine,nbAnsiString: t:=differentC;
               nbVariant:                    t:=differentV;
             end;
      inf:   case typ of
               nbByte..nbDword:              t:=infI;
               nbInt64:                      t:=infI64;
               nbSingle..nbExtended:         t:=infR;
               nbSingleComp..nbExtComp:      t:=InfComp;
               nbChar,nbChaine,nbAnsiString: t:=infC;
               nbVariant:                    t:=infV;
             end;
      sup:   case typ of
               nbByte..nbDword:              t:=supI;
               nbInt64:                      t:=supI64;
               nbSingle..nbExtended:         t:=supR;
               nbSingleComp..nbExtComp:      t:=SupComp;
               nbChar,nbChaine,nbAnsiString: t:=supC;
               nbVariant:                    t:=supV;
             end;
      infegal:
             case typ of
               nbByte..nbDword:              t:=infEgalI;
               nbInt64:                      t:=infEgalI64;
               nbSingle..nbExtended:         t:=infEgalR;
               nbSingleComp..nbExtComp:      t:=infEgalComp;
               nbChar,nbChaine,nbAnsiString: t:=infegalC;
               nbVariant:                    t:=infegalV;
             end;
      supegal:
             case typ of
               nbByte..nbDword:              t:=supEgalI;
               nbInt64:                      t:=supEgalI64;
               nbSingle..nbExtended:         t:=supEgalR;
               nbSingleComp..nbExtComp:      t:=supEgalComp;
               nbChar,nbChaine,nbAnsiString: t:=supegalC;
               nbVariant:                    t:=supegalV;
             end;

    end;
  end;



procedure Tcompil.creerVariableTableau(Atable:TtableSymbole; sz:integer);
  var
    i:integer;
    typ1:typeNombre;
    infoTab:PinfoTab;
    sz1:integer;
  begin
    accepte(croOu);

    infoTab:=Atable.getInfoTab(symbole);

    flagArray:=false;

    Plex:=Plex;
    Plex^.genre:=motArray;          { motArray }
    Plex^.MAnbr:=infoTab^.nbrang;   { nbrang }
    Plex^.MAsize:=sz;               { size }

    for i:=1 to infotab^.nbrang do
      begin
        Plex^.MA[i].mini:=infoTab^.r[i].minT;
        Plex^.MA[i].maxi:=infoTab^.r[i].maxT;
      end;
    creerLex;

    for i:=1 to infotab^.nbrang do
      begin
        creerExp(typ1,sz1);
        accepteType(nbSmall,typ1);

        if i<>infoTab^.nbrang
          then accepte(virgule)
          else accepte(croFer);
        lireUlex;
      end;

  end;

procedure Tcompil.creerStChar(n:ptUlex);
var
  typ:typeNombre;
  sz:integer;
begin
  accepte(croOu);
  lireUlex;            {écraser croOu}
  inserer1(n,stChar);
  creerExp(typ,sz);

  if typ<>nbLong then sortie(E_expressionEntiere);

  accepte(croFer);
  lireUlex;            {écraser croFer}
end;



procedure Tcompil.creerMotOrd(var typ:typeNombre);
var
  n0:ptUlex;
  sz:integer;
begin
  n0:=Plex;
  Creerlex;               { ORD }
  accepte(parou);
  lireUlex;               {écraser ( }
  creerExp(typ,sz);
  if typ<>nbBoole         {s'applique à booléen ou char}
    then accepteType(nbChar,typ);

  if typ=nbBoole
    then n0.genre:=OrdBoole
    else n0.genre:=OrdChar;

  accepte(parfer);        {écraser ) }
  lireUlex;
  typ:=nbByte;
end;

procedure Tcompil.creerComplexQualif(n1:ptUlex;var typ:typeNombre;var vsz:integer);
var
  PR:boolean;
begin
  accepte(pointL);
  qualifie:=true;
  lireUlex;            {écraser Point}
  qualifie:=false;

  if stMotUlexMaj='X' then PR:=true
  else
  if stMotUlexMaj='Y' then PR:=false
  else sortie(E_RpartImPart);

  with Plex^ do            {Remplacer X ou Y par CV }
  begin
    genre:=CV;
    case typ of
      nbSIngleComp: CVtp:=nbSingle;
      nbDoubleComp: CVtp:=nbDouble;
      nbExtComp:    CVtp:=nbExtended;
    end;
    vsz:=tailleNombre[typ];
    CVsz:=vsz;

    typ:=CVtp;
    if PR then CVdep:=0
          else CVdep:=tailleNombre[CVtp];
  end;
  suivant;
  lireUlex;
end;


procedure Tcompil.creerRefDef(var typ:typeNombre;var vsz,numOb:integer);
var
  n1:ptUlex;
  AT:TatomType;
  symb:PdefSymbole;
begin
  coderAtome(n1,AT,typ,vsz,numOb,symb);
  if not (typ in [nbDef..refDef]) then sortie('Record type expected');
end;


{ creerAtome crée un élément de base dans une expression.
  Est appelée seulement par creerFacteur
  renvoie le type du résultat: toujours nb jamais ref, sauf refObjet
  15 mai 2007:   Le résultat peut être un objet.
}

procedure Tcompil.creerAtome(var typ:typeNombre;var vsz:integer);
var
  n1:ptUlex;
  AT: TatomType;
  numOb:integer;
  symb:PdefSymbole;
begin
  coderAtome(n1,AT,typ,vsz,numOb,symb);
  if not (typ in [nbByte..nbANSIString, refObject,nbDef]) then sortie('Identifier expected')
  else
  if (AT=ATvarArray) then sortie('[  expected');
end;


{ creerReferenceVar crée un bloc qui donne l'adresse d'une variable qui n'est pas un objet
}
procedure Tcompil.creerReferenceVar(var typ:typeNombre;var vsize:integer;flagVarSansType:boolean);
var
  n1:ptUlex;
  AT: TatomType;
  numOb:integer;
  symb:PdefSymbole;
begin
  coderAtome(n1,AT,typ,vsize,numOb,symb);
  if not( (AT in [ATVar,ATvarArray]) and (typ in [nbByte..nbANSIstring])
          OR
          (AT=ATVar) and (typ=nbdef) and (symb<>nil) and flagVarSansType
         ) then sortie(E_referenceVariable);
end;

{creerRefObjet crée un bloc qui donne l'adresse d'un objet
 entrée: Plex pointe sur TPobject ou TPobjectInd
         cet élément peut être suivi par un descripteur de tableau
         ou par des propriétés objet.
         on peut avoir x[i,j]
                       x[i,j].y.z
         si y est un objet, le type du résultat est le type de y

 15-05-07: on ajoute le type Variant
}
procedure Tcompil.creerRefObjet(var typ:typeNombre;var Vob:Integer);
var
  n1:ptUlex;
  AT:TatomType;
  symb:PdefSymbole;
  vsize:integer;
begin
  coderAtome(n1,AT,typ,vsize,VOb,symb);
  if not(typ in [refObject,nbVariant, refNil]) then sortie(E_refObjectExpected);
end;


{******************************************************************************}
{ Codage de tout ce qui commence par un objet
  Exemples:
    v1.show;
    Vspk[i].VU[j].show;
    v1.Xmax:=12;

 L'affectation de propriété est incluse dans coderObjet   
}
{******************************************************************************}


procedure Tcompil.coderObjet(n1:ptUlex;
                             var AT: TatomType;var typ:typeNombre;
                             var vsize:integer;var numOb:integer;
                             var symb:PdefSymbole);
var
  flag:boolean;
  Pdef:PdefProc;
  pnb:ptUlex;
  n2,n3,nU,po, p0:ptUlex;
  nmem:pointer;
  typ1:typeNombre;
  vsz1:integer;
  szMem:integer;
  UlexDum:typeUlex;
  flagDefault:boolean;
  flagImplicit:boolean;
  stImplicit:AnsiString;

  flagProp:boolean;

begin
  AT:= ATvar;

  typ:=refObject;
  vsize:=4;

  case Plex^.genre of
    variObject:
      begin
        numOb:=ord(Plex^.vob);
        flag:=flagArray;
        creerLex;
        if flag then creerVariableTableau(LastTable,sizeof(pointer));
      end;

    TPobjectInd:
      begin
        numOb:=getWithVob(Plex^.depTPO);
        creerLex;
      end;

    refLocObject,variLocObject:
      begin
        numob:=ord(Plex^.vobLoc);
        flag:=flagArray;
        creerLex;
        if flag then creerVariableTableau(LastTable,sizeof(pointer));
      end;

    Fonc: creerAppelFonction(typ,numOb);

    typeObjet:creerAppelTranstypage(typ,numOb);
  end;


  while (typ=refObject) and (Plex^.genre in [pointL,croOu])  do
  begin
    if (Plex^.genre=croOu)  then
    begin
      NumeroProc:=tabProc.getNumDefault(Pdef,numOb);             {Propriété par défaut}
      if NumeroProc<=0 then sortie('. expected');
      flagDefault:=true;
      flagImplicit:=false;
    end
    else
    begin
      qualifie:=true;
      lireUlex;         {écraser le point }
      qualifie:=false;

      {Chercher la méthode associée à numOb}
      NumeroProc:=TabProc.getNumProc1(stMotUlexMaj,Pdef,numOb);

      flagImplicit:=false;
      flagDefault:=false;

      if NumeroProc<=0 then
      begin
        NumeroProc:=TabProc.getNumImplicit(Pdef,numOb);
        if NumeroProc<0
          then sortie(E_methodeAttendue);

        flagImplicit:=true;
        stImplicit:=stMotUlex;
      end;
    end;

    with Plex^ do
    begin
      genre:=fonc;               { on code fonc même pour une procédure }
      NumProced:=NumeroProc;
      nbParP:=pdef^.nbParam;
      tpres:=pdef^.Vresult;
    end;

    typ:=pdef^.Vresult;
    numOb:=pdef^.obResult;

    FlagProp:= (Pdef^.Vresult<>nbNul) and (Pdef^.propriete=prReadWrite);;

    if typ=nbNul then AT:=ATproc
    else
    if typ<>refObject then AT:=ATfonc;

    pnb:=Plex;                   {pnb pointe sur fonc}

    if pdef^.Foverload then
    begin
      p0:=Plex;
      if flagDefault then
      begin
        suivant;
        Plex^.genre:=croOu;
      end
      else creerlex;

      creerListeParam1(pdef,pnb,p0);
      typ:=pdef^.Vresult;
      numOb:=pdef^.obResult;
      FlagProp:= (Pdef^.Vresult<>nbNul) and (Pdef^.propriete=prReadWrite);
    end
    else
    begin
      if flagImplicit then suivant     { avancer}
      else
      if flagDefault then
      begin
        suivant;                       { avancer et garder le crochet ouvert }
        Plex^.genre:=croOu;
      end
      else creerLex;  { avancer et écraser le nom de méthode }


      if flagImplicit then
      begin
         Plex^.genre:=Param;         {ajouter un paramètre chaine Ansi}
         Plex^.tpParam:=nbAnsiString;
         suivant;

         Plex^.genre:=chainecar;     {ajouter la chaine}
         Plex^.st:=stImplicit;
         creerLex;                   { et lire l'ulex suivante}
      end
      else
      if pdef^.nbParam>0 then      {créer la liste de paramètres }
      begin
        if (pdef^.propriete<>prNone) then accepte(croOu) else accepte(parou);
        lireUlex;
        creerListeParam(pdef,pnb);
        if (pdef^.propriete<>prNone) then accepte(croFer) else accepte(parfer);
        lireUlex;
      end;
    end;

    UlexDum:=Plex^;

    Plex^.genre:=Param;         {ajouter un paramètre objet}
    Plex^.tpParam:=refObject;
    Po:=Plex;                   {noter la position de ce paramètre}
    suivant;

    inc(pnb^.nbparP);           {incrémenter le nb de paramètres}

                                {faire passer l'objet n1 à la fin}
    move(n1^,Plex^,intG(pnb)-intG(n1));
    move(pnb^,n1^,intG(Plex)-intG(n1));
                                { On avait Objet|proc|param|p1|param|p2|param
                                           |     |                      |
                                           n1    pnb                    po
                                  On obtient proc|param|p1|param|p2|param|Objet }
    { en n1, on a donc proc }

    Plex^:=UlexDum;
  end;

  {S'il s'agit de l'affectation d'une propriété, il faut faire passer la valeur affectée
  comme avant-dernier paramètre}
  if (Plex^.genre=DeuxPointEgal) and FlagProp then
  begin
    n1^.tpres:=nbNul;
    inc(n1^.numProced);         {incrémenter le numéro de procédure}
    inc(n1^.nbParP);            {incrémenter le nb de paramètres}

    nU:=n1;
    inc(intG(nU),intG(Po)-intG(pnb)); {pointe sur le paramètre objet}

    Plex^.genre:=Param;
    Plex^.tpParam:=Pdef^.Vresult;
    n2:=Plex;

    creerLex;

    if (Pdef^.Vresult=Refprocedure) then
      begin
        with Plex^ do
        begin
          controleRefProc(Pdef^.Obresult);
          creerLex;
        end;
      end
    else
      begin
        n3:=Plex;
        creerExp(typ1,vsz1);
        accepteType(Pdef^.Vresult,typ1);
        if typ1<>Pdef^.Vresult then insererTokenConv(n3,typ1,Pdef^.Vresult);
      end;


    SzMem:=intG(n2)-intG(nU);
    getmem(nmem,szmem);
    move(nu^,nmem^,szMem);                     { copier le segment nU-n2 }
    move(n2^,nU^,intG(Plex)-intG(n2));   { Décaler le segment n2-Plex }
    inc(intG(nU),intG(Plex)-intG(n2));
    move(nmem^,nU^,szMem);                     {copier à la suite le 1er segment}
    freemem(nmem);

    { On avait proc|param|p1|param|p2|param|Objet|param|pN
               |                      |           |     |
               n1                     nU          n2    Plex
      On obtient proc|param|p1|param|p2|param|pN|param|Objet
    }
    typ:=nbNul;
    AT:=ATproc;
  end;

end;

{  CoderDef doit renvoyer le symb correspondant au type

}
procedure Tcompil.coderDef(n1:ptUlex;
                             var AT: TatomType;var typ:typeNombre;
                             var vsize:integer;var numOb:integer;
                             var symb:PdefSymbole);
var
  flag,flagTab:boolean;
  curTable:TtableSymbole;
  withRec:TwithRec;

begin
  curTable:=LastTable;
  if Plex^.genre=tpInd then
    begin
      withRec:=depToWithRec(Plex^.depInd);
      typ:=nbDef;
      vsize:=Plex^.szInd;
      symb:=withRec.symbW;
      curTable:=tables[withRec.UnitW];
      numOb:=symb^.infV.att0;

      creerLex;
    end
  else
    begin                                   { variDef,variLocDef ou RefLocDef }
      typ:=nbdef;

      case Plex^.genre of
        variDef:                vsize:=Plex^.sz;
        variLocDef, RefLocDef:  vsize:=Plex^.sz1;
      end;
      numOb:=symbole^.infV.att0;


      symb:=symbole;

      flagTab:=flagArray;
      creerLex;
      if flagTab then
      begin
        if (Plex^.genre=croOu)
          then creerVariableTableau(LastTable,vsize)
        else
          begin
            vSize:=symbole^.infV.varSize;
              {On sort avec  le type de base du tableau
               Cas d'un paramètre refvar. Y-a-t-il d'autres cas ?
              }
            AT:=ATvarArray;
          end;
        insererUlex(cv);
        with Plex^ do
        begin
          genre:=CV;
          CVsz:=vsize;
          CVtp:=nbDef;
          CVdep:=0;
        end;
        suivant;
      end;
    end;

  flag:=false;
  { symb contient le symbole de la variable de départ, pas le symbole du type }

  while (typ=nbDef) and ((Plex^.genre=pointL) OR (Plex^.genre=croOU)) and not flag do
  begin
    if Plex^.genre=croOU then
    begin
      Symb:=CurTable.getField(symb,stMotUlexMaj,CurTable);
      { symbole Stype TNgenre=TNarray }

      if not assigned(Symb) or  not ((symb^.ident=Stype) and (symb^.infoType.TNgenre=TNarray))
        then sortie('Unexpected symbol: [ ');

      symbole:=symb;

      typ:=symb^.infoType.tpA;
      if typ=nbdef then
      begin
        symb:= curTable.getTNarrayBaseSymbol(symb);
        vsize:=curTable.TypeSize(symb);
        creerVariableTableau(LastTable,vsize);
        insererUlex(cv);
        with Plex^ do
        begin
          genre:=CV;
          CVsz:=vsize;
          CVtp:=typ;
          CVdep:=0;
        end;
        suivant;
      end
      else
      begin
        vsize:= tailleNombre[typ];
        insererUlex(cv);
        with Plex^ do
        begin
          genre:=CV;
          CVsz:=vsize;
          CVtp:=typ;
          CVdep:=0;
        end;
        suivant;
        creerVariableTableau(LastTable,vsize);
      end;


    end
    else
    begin
      Qualifie:=true;
      lireUlex;            {écraser Point, lire qualificateur}
      Qualifie:=false;

      Symb:=curTable.getField(symb,stMotUlexMaj,CurTable);
      if not assigned(Symb) then sortie(E_fieldExpected);

      with Plex^ do
      begin
        typ:=symb^.infV.tp;
        vsize:=curTable.VariableSize(symb,false);
        numOb:=symb^.infV.att0;

        if symb^.infV.tp=refObject then
        begin
          genre:=CVobj;
          cvo:=numOb;
          flag:=true;
        end
        else
        begin
          genre:=CV;
          CVsz:=vsize;
        end;

        CVtp:=typ;
        CVdep:=symb^.infV.deplacement;
      end;

      creerlex;
      if symb^.infV.depTab>=0 then
      begin
        symbole:=symb;
        creervariableTableau(CurTable,vsize);
      end;
    end;
  end;

  symb:=curTable.getBaseSymbole(symb);// symbole du type

  if flag then coderObjet(n1,AT,typ,vsize,numOb,symb)
  else
    begin
      AT:=ATvar;
      if (typ in [nbSingleComp..nbExtComp]) and (Plex^.genre=pointL)
          then creerComplexQualif(n1,typ,vsize);
    end;
end;


procedure Tcompil.coderAtome0(n1:ptUlex;
                              var AT: TatomType;var typ:typeNombre;
                              var vsize:integer;var numOb:integer;
                              var symb:PdefSymbole);
var
  flag:boolean;
  i,num:integer;
  Pdef:PdefProc;
begin
  case Plex^.genre of
    motNouveau:
       begin
         { Si un objet avec propriété implicite fait partie des With, on cherche à le traiter }
          i:=nbWith;
          num:=-1;
          while (i>0) and (num=-1) do
          with tbWith[i] do
          begin
            if isObj then Num:=TabProc.getNumImplicit(Pdef,Ob);
            dec(i);
          end;
          if num>=0 then
          begin
            Plex^.genre:=TpObjectInd;
            Plex^.depTPO:=tbWith[i+1].dep;
            renvoye:=2;
            ObjRenvoye:=true;
            coderObjet(n1,AT,typ,vsize,numOb,symb);
          end

       end;
    nbI,nbL:
      begin
        AT:=ATfonc;
        typ:=nblong;
        creerLex;
      end;
    nbR:
      begin
        AT:=ATfonc;
        typ:=nbExtended;
        creerLex;
      end;
    motTrue,motFalse:
      begin
        AT:=ATfonc;
        typ:=nbBoole;
        creerLex;
      end;
    constCar:
      begin
        AT:=ATfonc;
        typ:=nbChar;
        creerLex;
      end;
    chainecar:
      begin
        AT:=ATfonc;
        typ:=nbChaine;
        creerLex;
        if (Plex^.genre=croOu) then
          begin
            CreerStChar(n1);

            typ:=nbChar;
          end;
      end;

    variByte..refLocAnsiString:
      begin
        AT:=ATvar;
        typ:=typeVar[Plex^.genre];
        case Plex^.genre of
          variC:    vsize:=Plex^.longC+1;
          variLocC: vsize:=Plex^.longCLoc+1;
          refLocC:  vsize:=Plex^.longCloc1+1;
          else vsize:=tailleNombre[typ];
        end;

        flag:=flagArray;
        creerLex;
        if flag then
        begin
          if (Plex^.genre=croOu)
            then creerVariableTableau(LastTable,vsize)
          else
            begin
              {typ:=nbDef;     supprimé le 8-10-04        }
              vSize:=symbole^.infV.varSize;
              {On sort avec  le type de base du tableau
               Cas d'un paramètre refvar. Y-a-t-il d'autres cas ?
              }
              AT:=ATvarArray;
            end;
        end;
        if (typ in [nbChaine,nbAnsiString]) and (Plex^.genre=croOu) then
        begin
          CreerStChar(n1);
          typ:=nbChar;
          vsize:=1;
        end
        else
        if (typ in [nbSingleComp..nbExtComp]) and (Plex^.genre=pointL)
          then creerComplexQualif(n1,typ,vsize);
      end;

    variObject,variLocObject,TPobjectInd,refLocObject,
    typeObjet { Fonction de Transtypage } :             coderObjet(n1,AT,typ,vsize,numOb,symb);

    motNil: begin
              AT:=ATfonc;
              typ:=refNil;
              numOb:=0;
              creerLex;
            end;

    {
    proced: creerAppelProcedure;
    procU:  creerAppelProcU;
    }


    Fonc:  begin
             if Plex^.tpRes=refObject
               then coderObjet(n1,AT,typ,vsize,numOb,symb)
               else
               begin
                 creerAppelFonction(typ,numOb);
                 AT:=ATfonc;
               end;
             vsize:=tailleNombre[typ];
           end;

    FoncU: begin
             creerAppelFoncU(typ);
             vsize:=tailleNombre[typ];
             AT:=ATfonc;
           end;
    motOrd:begin
             CreerMotOrd(typ);
             vSize:=1;
             AT:=ATfonc;
           end;

    variDef,variLocDef,RefLocDef,tpInd: coderDef(n1,AT,typ,vsize,numOb,symb);

  end;
end;

{ CoderAtome code:
    - les nombres , les constantes
    - les variables (qualifiées ou tableaux)
    - les procédures et fonctions
    - les objets suivis de méthodes ou propriétés.
  CoderAtome ne code pas
    - les expressions (on s'arrête quand on rencontre un opérateur)
    - les instructions (on s'arrête quand on rencontre un mot clé ou un séparateur.

  Renvoie n1: Adresse du premier élément du bloc codé
          AT : atom type
          typ : le type de l'atome
          vsize: la taille de la variable
          numOb: le type de l'objet
          symb: pointeur sur la définition du symbole (utilisé seulement par coderDef)
}

procedure Tcompil.coderAtome(var n1:ptUlex;
                             var AT: TatomType;var typ:typeNombre;
                             var vsize:integer;var numOb:integer;
                             var symb:PdefSymbole);
begin
  n1:=Plex;
  AT:=ATnothing;
  typ:=nbNul;
  vsize:=0;
  numOb:=0;
  symb:=nil;

  coderAtome0(n1,AT,typ,vsize,numOb,symb);
end;


{******************************************************************************}


procedure Tcompil.creerFacteur(var typ:typeNombre;var vsz:integer);
  var
     n1:ptUlex;
  begin
    n1:=Plex;
    if Plex^.genre=parou then
      begin
        lireUlex;
        creerExp(typ,vsz);
        accepte(parfer);
        lireUlex;
      end
    else
    if Plex^.genre=OpNot then
      begin
        creerLex;
        creerFacteur(typ,vsz);
        if not (typ in [nbLong,nbBoole])
            then sortie(E_operandeEntierOuBoolean);
      end
    else
    begin
      creerAtome(typ,vsz);
      if typ in [nbByte..nbLong] then typ:=NbLong; {Passage au long}
    end;

end; { of creerFacteur }


procedure Tcompil.creerTerme(var typ:typeNombre;var vsz:integer);
  var
    n0,n1,n2:ptUlex;
    typ1,typ2:typeNombre;
  begin
    n0:=Plex;
    creerFacteur(typ,vsz);
    while Plex^.genre in [mult,divis,OpDiv,OpMod,OpAnd,OpShl,OpShr] do
    begin
      typ1:=typ;
      inserer(n0);
      n1:=n0;
      inc(intG(n1),sizeof(typelex));
      n2:=Plex;
      creerFacteur(typ2,vsz);
      typ:=typeResultat(typ1,typ2,n0^.genre);

      if insererTokenConv(n1,typ1,typ)
        then inc(intG(n2),sizeof(typelex));
      insererTokenConv(n2,typ2,typ);

      if not DollarBplus and (n0^.genre=OpAnd) and (typ=nbBoole) then
      begin
        inserer2(n0,4);
        n0^.genre:=andBI;
        n0^.depLog:=intG(Plex)-intG(n2)-4;
      end;
    end;
  end;

procedure Tcompil.creerExpSimple(var typ:typeNombre;var vsz:integer);
  var
    n0,n1,n2:ptUlex;
    typ1,typ2:typeNombre;
  begin
    n0:=Plex;

    if Plex^.genre=plus then
      begin
        lireUlex;
        creerTerme(typ,vsz);
      end
    else
    if Plex^.genre=moins then
      begin
        Plex^.genre:=moinsU;
        n1:=Plex;
        creerLex;
        if Plex^.genre in [nbi,nbL,nbR] then
          begin
            move(Plex^,n1^,11);
            Plex:=n1;
            with Plex^ do
              case genre of
                nbi:vnbi:=-vnbi;
                nbL:vnbL:=-vnbL;
                nbR:vnbR:=-vnbR;
              end;
          end;
        creerTerme(typ,vsz);
      end
    else
    creerTerme(typ,vsz);

    while Plex^.genre in [plus,moins,opOR,opXor] do
    begin
      typ1:=typ;
      inserer(n0);
      n1:=n0;
      inc(intG(n1),sizeof(typelex));
      n2:=Plex;
      creerTerme(typ2,vsz);
      typ:=typeResultat(typ1,typ2,n0^.genre);

      if insererTokenConv(n1,typ1,typ)
        then inc(intG(n2),sizeof(typelex));
      insererTokenConv(n2,typ2,typ);


      if not DollarBplus and (n0^.genre=OpOr) and (typ=nbBoole) then
      begin
        inserer2(n0,4);
        n0^.genre:=orBI;
        n0^.depLog:=intG(Plex)-intG(n2)-4;
      end;

    end;
  end;

procedure Tcompil.creerExp(var typ:typeNombre;var vsz:integer);
  var
    n0,n1,n2:ptUlex;
    typ1,typ2:typeNombre;
  begin
    n0:=Plex;

    creerExpSimple(typ,vsz);

    if Plex^.genre in [egal,inf,infEgal,sup,supEgal,different] then
      begin
        typ1:=typ;
        inserer(n0);
        n1:=n0;
        inc(intG(n1),sizeof(typelex));
        n2:=Plex;
        creerExpSimple(typ2,vsz);
        typ:=typeResultat(typ1,typ2,n0^.genre);
                   
        if typ1<typ2 then
          begin
            insererTokenConv(n1,typ1,typ2);
            ChangerOperateur(n0^.genre,typ2);
            if typ2=nbvariant then insererTokenConv(n0,nbvariant,nbBoole);
          end
        else
        if typ2<typ1 then
          begin
            insererTokenConv(n2,typ2,typ1);
            ChangerOperateur(n0^.genre,typ1);
            if typ1=nbvariant then insererTokenConv(n0,nbvariant,nbBoole);
          end
        else ChangerOperateur(n0^.genre,typ1);
      end;
  end;


{******************************************************************************}


procedure Tcompil.creerFacteur1(var typ:typeNombre;var vsz:integer;var ww: Texp1set);
var
  AT:TatomType;
begin
  with ww do
  begin
    n1Exp1:=Plex;
    if Plex^.genre=parou then
      begin
        IsExp1:=true;
        lireUlex;
        creerExp1(typ,vsz,ww);
        accepte(parfer);
        lireUlex;
      end
    else
    if Plex^.genre=OpNot then
      begin
        IsExp1:=true;
        creerLex;
        creerFacteur1(typ,vsz,ww);
        if not (typ in [nbLong,nbBoole])
            then sortie(E_operandeEntierOuBoolean);
        changerOperateur(n1Exp1^.genre,typ);
      end
    else
    begin
      coderAtome(n1Exp1,AT,typExp1,vszExp1,numObExp1,symbExp1);
      isVarExp1:=(AT=ATvar) or (AT=ATvarArray);
      typ:=typExp1;
      vsz:=vszExp1;

      if typ in [nbByte..nbLong] then typ:=NbLong; {Passage au long}
    end;
  end
end; { of creerFacteur }


procedure Tcompil.creerTerme1(var typ:typeNombre;var vsz:integer;var ww: Texp1set);
var
  n0,n1,n2:ptUlex;
  typ1,typ2:typeNombre;
begin
  with ww do
  begin
    n0:=Plex;
    creerFacteur1(typ,vsz,ww);
    while Plex^.genre in [mult,divis,OpDiv,OpMod,OpAnd,OpShl,OpShr] do
    begin
      IsExp1:=true;
      typ1:=typ;
      inserer(n0);
      n1:=n0;
      inc(intG(n1),sizeof(typelex));
      n2:=Plex;
      creerFacteur1(typ2,vsz,ww);
      typ:=typeResultat(typ1,typ2,n0^.genre);

      if insererTokenConv(n1,typ1,typ)
        then inc(intG(n2),sizeof(typelex));
      insererTokenConv(n2,typ2,typ);

      ChangerOperateur(n0^.genre,typ);

      if not DollarBplus and (n0^.genre=OpAnd) and (typ=nbBoole) then
      begin
        inserer2(n0,4);
        n0^.genre:=andBI;
        n0^.depLog:=intG(Plex)-intG(n2)-4;
      end;
    end;
  end;
end;

procedure Tcompil.creerExpSimple1(var typ:typeNombre;var vsz:integer;var ww: Texp1set);
var
  n0,n1,n2:ptUlex;
  typ1,typ2:typeNombre;
begin
  with ww do
  begin
    n0:=Plex;

    if Plex^.genre=plus then
      begin
        lireUlex;
        creerTerme1(typ,vsz,ww);
        IsExp1:=true;
      end
    else
    if Plex^.genre=moins then
      begin
        IsExp1:=true;
        Plex^.genre:=moinsU;
        n1:=Plex;
        creerLex;
        if Plex^.genre in [nbi,nbL,nbR] then
          begin
            move(Plex^,n1^,11);
            Plex:=n1;
            with Plex^ do
              case genre of
                nbi:vnbi:=-vnbi;
                nbL:vnbL:=-vnbL;
                nbR:vnbR:=-vnbR;
              end;
          end;
        creerTerme1(typ,vsz,ww);
        if n1^.genre=moinsU then changerOperateur(n1^.genre,typ);
      end
    else
    creerTerme1(typ,vsz,ww);

    while Plex^.genre in [plus,moins,opOR,opXor] do
    begin
      IsExp1:=true;
      typ1:=typ;
      inserer(n0);
      n1:=n0;
      inc(intG(n1),sizeof(typelex));
      n2:=Plex;
      creerTerme1(typ2,vsz,ww);
      typ:=typeResultat(typ1,typ2,n0^.genre);

      if insererTokenConv(n1,typ1,typ)
        then inc(intG(n2),sizeof(typelex));
      insererTokenConv(n2,typ2,typ);

      ChangerOperateur(n0^.genre,typ);

      if not DollarBplus and (n0^.genre=OpOr) and (typ=nbBoole) then
      begin
        inserer2(n0,4);
        n0^.genre:=orBI;
        n0^.depLog:=intG(Plex)-intG(n2)-4;
      end;

    end;
  end;
end;

procedure Tcompil.creerExp1_(var typ:typeNombre;var vsz:integer;var ww: Texp1set);
var
  n0,n1,n2:ptUlex;
  typ1,typ2:typeNombre;
begin
  with ww do
  begin
    n0:=Plex;
    creerExpSimple1(typ,vsz,ww);

    if Plex^.genre in [egal,inf,infEgal,sup,supEgal,different] then
      begin
        IsExp1:=true;
        typ1:=typ;
        inserer(n0);
        n1:=n0;
        inc(intG(n1),sizeof(typelex));
        n2:=Plex;
        creerExpSimple1(typ2,vsz,ww);
        typ:=typeResultat(typ1,typ2,n0^.genre);

        if typ1<typ2 then
          begin
            insererTokenConv(n1,typ1,typ2);
            ChangerOperateur(n0^.genre,typ2);
          end
        else
        if typ2<typ1 then
          begin
            insererTokenConv(n2,typ2,typ1);
            ChangerOperateur(n0^.genre,typ1);
          end
        else ChangerOperateur(n0^.genre,typ1);
      end;
  end;
end;

{ Crée une expression comme CreerExp mais en remplissant au passage quelques variables:
  IsExp1, n1Exp1, IsVarExp1, etc...
  Est utilisée par creerListeParam1
}
procedure Tcompil.creerExp1(var typ:typeNombre;var vsz:integer;var ww: Texp1set);
begin
  ww.IsExp1:=false;
  creerExp1_(typ,vsz,ww);
end;

procedure Tcompil.accepteRefObjet(pp:typeParam;Vob:Integer);
  begin
    {tabProc.descendants(pp.minP,desc);}
    if not ( (pp.tp=refObject) and tabproc.IsChild(Vob,pp.minP)  )
           then sortie(E_baseReference+ord(pp.tp));
  end;

procedure Tcompil.accepteRefObjet1(minP:integer;Vob:Integer);
  begin
    {messageCentral('accepteRefObjet1='+ Istr(minP));}
    if Vob=0 then exit; { correspond à Tnil, compatible avec tout objet}

    {tabProc.descendants(minP,desc);}

    with tabProc do
      if not IsChild(Vob,minP)  then sortie(objectName(minP)+' expected' );
  end;

procedure Tcompil.controleRefProc(num:integer);
var
  pdef:PdefProc;
  i:integer;
  ok:boolean;
begin
  {messageCentral(Istr(num));}
  if Plex^.genre=motNil then exit;

  if num=-1 then
    with plex^ do
      ok:=(genre=procU) or (genre=foncU)
  else
    begin
      pdef:=tabProc.getNumProcI(num);
      ok:=assigned(pdef);
      if ok then
      with plex^ do
      begin
        ok:=(genre=procU) and (pdef^.Vresult=nbNul) or
            (genre=foncU) and (pdef.Vresult=symbole^.infP.result1);

        ok:=ok and ((pdef^.nbparam=symbole^.infP.nbparam) OR (pdef^.nbparam=-1));

        if ok then
        for i:=1 to symbole^.infP.nbparam do
        begin
          ok:=ok and (pdef^.getparam(i).tp=symbole^.infP.parametre[i].tp);
          if ok and (pdef^.getparam(i).tp = refObject)
            then ok:= tabProc.isChild(symbole^.infP.parametre[i].numOb , pdef^.getparam(i).minP);
        end;
      end;
    end;
  if not ok then sortie(E_refprocedure);
end;



procedure Tcompil.creerListeParam(p:PdefProc;pnb:PtUlex);
  var
    i:Integer;
    pp:PParam;
    typ1:typeNombre;
    vsz1:integer;
    P1,P2,n1:ptUlex;
    Vob:integer;
  begin
    with p^ do
    begin
      for i:=1 to p^.nbParam do
        begin
          pp:=getParam(i);
          with pp^ do
          begin
            P1:=Plex;
            inc(intG(P1), ParamSize);
            move(Plex^,P1^,tailleUlex(Plex^));
            Plex^.genre:=param;
            Plex^.tpParam:=tp;

            suivant;
            case tp of
              RefByte..RefAnsiString:
                begin
                  creerReferenceVar(typ1,vsz1,false);
                  accepteReference(pp^.tp,typ1,pp^.minP );

                  if pp^.minP>0 then
                  begin
                    p2:=Plex;

                    inserer1(Plex,param);        { pour le type }
                    inserer1(Plex,nbi);

                    P2^.genre:=param;            { empiler son type }
                    P2^.tpParam:=nbSmall;        { Mal transmis le 1-12-03}
                    inc(intG(P2),ParamSize);
                    P2^.genre:=nbi;
                    P2^.vnbi:=ord(typ1);
                    inc(pnb^.nbParP);
                  end;
                end;

              refObject:
                begin
                  if Plex^.genre=motNil then creerlex
                  else
                    begin
                      n1:=Plex;
                      creerRefObjet(typ1,Vob);
                      qualifie:=false;
                      {accepteRefObjet(pp^,Vob);}
                      if typ1=refObject
                        then accepteRefObjet1(pp^.minP,Vob)
                        else
                        begin
                          insererTokenConv(n1,typ1,tp);
                          n1^.VObVariant:=pp^.minP;
                        end;
                    end;
                end;
              nbByte..nbAnsiString:
                begin
                  n1:=Plex;
                  creerExp(typ1,vsz1);
                  accepteType(tp,typ1);
                  if typ1<>tp then insererTokenConv(n1,typ1,tp);
                end;

              refProcedure:
                begin
                  with Plex^ do
                  begin
                    controleRefProc(minP);
                    creerLex;
                  end;
                end;

              refVar:
                begin
                  creerReferenceVar(typ1,vsz1,true);

                  if typ1=nbAnsiString
                    then sortie('an ANSI String cannot be used as a reference parameter');

                  p2:=Plex;

                  inserer1(Plex,param);       {pour la taille}
                  inserer1(Plex,nbl);

                  inserer1(Plex,param);        { pour le type }
                  inserer1(Plex,nbi);

                  P2^.genre:=param;            { empiler la taille }
                  P2^.tpParam:=nbLong;         { de la variable }
                  inc(intG(P2), ParamSize);
                  P2^.genre:=nbl;
                  P2^.vnbl:=vsz1;
                  inc(pnb^.nbParP);

                  inc(intG(P2), NbLsize);


                  P2^.genre:=param;            { empiler son type }
                  P2^.tpParam:=nbSmall;
                  inc(intG(P2), ParamSize);
                  P2^.genre:=nbi;
                  P2^.vnbi:=ord(typ1);
                  inc(pnb^.nbParP);

                end;
            end;
          end;
          if i<nbParam then
            begin
              accepte(virgule);
              lireUlex;
            end;
        end;
    end;
  end;


{ creerListeParam1 crée le code pour les procédures standard avec overload
  En entrée, Plex est sur genre proced
}
procedure Tcompil.creerListeParam1(var p:PdefProc;pnb,p0:PtUlex);
type
  TrecAtome= record
               p1,n1,n2: ptUlex;
               isExp: boolean;
               isvar:boolean;
               typ: typeNombre;
               vsize: integer;
               numOb: integer;
               symb: PdefSymbole;
             end;
var
  recs:array[1..100] of TrecAtome;
  nbParAct: integer;
  ok,fini:boolean;
  i:integer;
  pp:Pparam;
  typA:typeNombre;
  vszA:integer;
  n1a,p1a,p2 {,p0}:ptULex;
  tp1:typeNombre;
  par1,par2:typelex;
  ww:Texp1set;

begin
  if p^.propriete <> prNone then
  begin
    par1:=croou;
    par2:=crofer;
  end
  else
  begin
    par1:=parou;
    par2:=parfer;
  end;
  (*
  p0:=Plex;        {on pointe sur proced }

  creerLex;        {avancer et lire éventuellement parou }
  *)
  nbParAct:=0;

  if Plex^.genre=par1 then                  {lire les paramètres tout en codant comme ça vient}
  begin
    lireUlex;
    while Plex^.genre<>par2 do
    begin
      inc(nbParAct);
      P1a:=Plex;
      inc(intG(P1a), ParamSize);             {faire la place pour param}
      move(Plex^,P1a^,tailleUlex(Plex^));
      Plex^.genre:=param;

      p1a:=Plex;               {p1a pointe sur param}
      inc(intG(Plex),ParamSize);
      n1A:=Plex;               {n1a pointe sur le bloc paramètre}
      creerExp1(typA,vszA,ww);
      with recs[nbParAct],ww do
      begin
        p1:=p1a;
        n1:=n1a;               { n1= début du bloc param }
        n2:=Plex;              { n2= fin du bloc param }
        isVar:=not IsExp1 and isVarExp1;
        isExp:=IsExp1;

        if isExp then typ:=typA
                 else typ:=typExp1;
        vsize:=vszExp1;
        numOb:=numObExp1;
        symb:=symbExp1;
      end;

      if Plex^.genre<>par2 then
      begin
        accepte(virgule);
        lireUlex;
      end;
    end;
    lireUlex; {Ecraser parfer}
  end;

  Fini:=false;                              {trouver la bonne déclaration}
  repeat
    with p0^ do
    begin
      NumProced:=p^.numero;                 {on suppose que le genre fonc, proced ne change pas}
      nbParP:=p^.nbParam;
      if (genre=fonc) then tpRes:=p^.Vresult;
    end;

    ok:=(nbparAct=p^.nbParam);
    i:=1;
    while ok and (i<= p^.nbParam) do
    begin
      pp:=p^.getParam(i);
      with pp^,recs[i] do
      begin
        case tp of
          RefByte..RefAnsiString :
                begin
                  tp1:=typeNombre(ord(tp)+ord(nbByte)-ord(refByte));
                  ok:=isVar and (typ>=tp1) and (ord(typ)<=ord(tp1)+minP);
                end;

          refObject:
                ok:=(typ=refObject) and
                    ((numOb=0) or (tabproc.IsChild(numOb,minP)))
                    OR (typ=refNil)
                    OR (typ=nbvariant);

          nbByte..nbAnsiString:
                ok:=accepteType0(tp,typ);

          refProcedure:
              begin
              end;

          refVar:  ok:=isvar;
        end;
      end;
      inc(i);
    end;

    if not ok and p.Foverload
      then p:=tabProc.procedureSuivante(p)
      else Fini:=true;
  until ok or Fini;

  if not ok then sortie('There is no declaration with this set of parameters');


  if ok then                                { insérer les éléments manquants }
    with p^ do
    for i:=p^.nbParam downto 1 do
    begin
      pp:=getParam(i);
      with pp^,recs[i] do
      begin
        p1^.tpParam:=tp;
        case tp of
            RefByte..RefAnsiString:
                if pp^.minP>0 then
                begin
                  p2:=n2;

                  inserer1(n2,param);       { pour le type }
                  inserer1(n2,nbi);

                  P2^.genre:=param;         { empiler son type }
                  P2^.tpParam:=nbSmall;     { Mal transmis le 1-12-03}
                  inc(intG(P2),ParamSize);
                  P2^.genre:=nbi;
                  P2^.vnbi:=ord(typ);
                  inc(pnb^.nbParP);
                end;

            nbByte..nbAnsiString:
              begin
                if typ<>tp then insererTokenConv(n1,typ,tp);
              end;

            refObject:
              if typ=nbvariant then
              begin
                insererTokenConv(n1,typ,tp);
                n1^.VObVariant:=numOb;
              end;

            refVar:
              begin
                n1:=UlexSuivant(n1);
                p2:=n1;

                inserer1(n1,param);        {pour le type}
                inserer1(n1,nbi);

                inserer1(n1,param);        { pour la taille }
                inserer1(n1,nbl);          { c'est l'ordre inverse par rapport à creerListeParam}

                P2^.genre:=param;          { empiler la taille }
                P2^.tpParam:=nbLong;       { de la variable }
                inc(intG(P2),ParamSize);
                P2^.genre:=nbl;
                P2^.vnbl:=vsize;
                inc(pnb^.nbParP);

                inc(intG(P2), NbLsize);


                P2^.genre:=param;            { empiler son type }
                P2^.tpParam:=nbSmall;
                inc(intG(P2), ParamSize);
                P2^.genre:=nbi;
                P2^.vnbi:=ord(typ);
                inc(pnb^.nbParP);

              end;
        end;
      end;
    end;
end;


procedure Tcompil.creerAppelProcedure; { en entrée, Plex^.genre=proced uniquement }
  var
    p:pDefProc;
    pnb,p0:PtUlex;
  begin
    p:= pointer(Plex^.NumProced);
    pnb:=Plex;

    with Plex^ do
    begin
      NumProced:=NumeroProc;
      nbParP:=p^.nbParam;
    end;

    if p^.Foverload then
    begin
      p0:=Plex;
      creerLex;
      creerListeParam1(p,pnb,p0);
      exit;
    end;

    creerLex;

    if p^.nbParam=0 then exit;

    accepte(parou);
    lireUlex;
    creerListeParam(p,pnb);
    accepte(parfer);
    lireUlex;
  end;



procedure Tcompil.creerListeParamU(TablePDefSymbole:TtableSymbole;p:PdefSymbole;pnb:PtUlex);
  var
    i:Integer;
    typ1:typeNombre;
    vsz1:integer;
    P1,n1:ptUlex;
    vob:Integer;
    PVob,PnumOb:TtableSymbole;
    P2:ptUlex;

  begin
    with p^.infP do
    begin
      for i:=1 to nbParam do
        begin
          P1:=Plex;
          inc(intG(P1),ParamSize);
          move(Plex^,P1^,tailleUlex(Plex^));
          Plex^.genre:=param;
          Plex^.tpParam:=parametre[i].tp;
          inc(intG(Plex), ParamSize);
          case parametre[i].tp of
            refByte..refAnsiString:
              begin
                creerReferenceVar(typ1,vsz1,false);
                if ord(typ1)+ord(RefByte)-ord(nbByte)<>ord(parametre[i].tp)
                  then sortie(E_baseReference+ord(parametre[i].tp));
              end;

            refObject:
                begin
                  n1:=Plex;
                  creerRefObjet(typ1,Vob);
                  qualifie:=false;

                  if (typ1=refObject) or (typ1=refNil)
                    then accepteRefObjet1(parametre[i].numOb,Vob)
                    else
                    begin
                      insererTokenConv(n1,typ1,parametre[i].tp);
                      n1^.VObVariant:=parametre[i].numOb;
                    end;

                  p2:=Plex;

                  inserer1(Plex,param);        { pour le type }
                  inserer1(Plex,nbi);

                  P2^.genre:=param;            { empiler son type }
                  P2^.tpParam:=nbSmall;
                  inc(intG(P2), ParamSize);
                  P2^.genre:=nbi;
                  P2^.vnbi:=Vob;
                  inc(pnb^.nbParU);

                end;

            nbByte..nbAnsiString:
              begin
                n1:=Plex;
                creerExp(typ1,vsz1);
                accepteType(parametre[i].tp,typ1);
                if typ1<>parametre[i].tp
                  then insererTokenConv(n1,typ1,parametre[i].tp);
              end;

            nbDef,refDef:
              begin
                creerRefDef(typ1, vsz1,VOb);

                PVob:=tables[Vob shr 24];
                 {table ou est déclaré le type de la variable}
                PnumOb:=TablePDefSymbole.tables[parametre[i].numOb shr 24];
                 {table ou est déclaré le type du paramètre }

                if (typ1<>nbdef) or (PVob<>PnumOb)
                    or
                    (Vob and $FFFFFF<>parametre[i].numOb and $FFFFFF)
                  then sortie('Invalid type');

              end;


          end;
          if i<nbParam then
            begin
              accepte(virgule);
              lireUlex;
            end;
        end;
    end;
  end;

function Tcompil.creerAppelFoncU(var typ:typeNombre): integer;
var
  p:PdefSymbole;
  pnb:PtUlex;
begin
  pnb:=Plex;

  p:=symbole;
  with Plex^ do
  begin
    typ:=symbole^.infP.result1;
  end;

  creerLex;
  result:=p^.infP.nbParam;

  if p^.infP.nbParam=0 then exit;

  if Plex^.genre=parou then
  begin
    lireUlex;
    creerListeParamU(LastTable,p,pnb);
    accepte(parfer);
    lireUlex;
  end
  else typ:=RefProcedure;
  { A améliorer:
    si on appelle la procédure avec zéro params alors qu'il y en a, c'est le plantage
  }
end;


procedure Tcompil.creerAppelProcU;
  var
    typ:typeNombre;
    nbparam:integer;
  begin
    nbparam:= creerAppelFoncU(typ);
    if (typ=RefProcedure) and (nbParam>0) then sortie('Parameter list expected');
  end;


procedure Tcompil.creerAppelFonction(var typ:typeNombre;var obres:integer);
  var
    p:pDefProc;
    pnb,p0:PtUlex;
  begin
    p:= pointer(Plex^.NumProced);
    pnb:=Plex;
    with Plex^ do
    begin
      NumProced:=numeroProc;
      nbParF:=p^.nbParam;
      typ:=p^.Vresult;
      obres:=p^.Obresult;
    end;

    if p^.Foverload then
    begin
      p0:=Plex;
      creerlex;
      
      creerListeParam1(p,pnb,p0);
      if assigned(p) then
      begin
        typ:=p^.Vresult;
        obres:=p^.Obresult;
      end;
      exit;
    end;

    creerLex;
    if p^.nbParam=0 then exit;

    accepte(parou);
    lireUlex;
    creerListeParam(p,pnb);
    accepte(parfer);
    lireUlex;
  end;

procedure Tcompil.creerAppelTransTypage(var typ:typeNombre;var obres:integer);
  var
    n1:PtULex;
    typ1:typeNombre;
    vsz1:integer;
    pfonc,ptpParam:ptUlex;
  begin
    typ:=refObject;                             { Plex = typeObjet }
    obres:=Plex^.VobTO;

    with Plex^ do                               { Remplacer par appel fonction }
    begin
      genre:=fonc;
      NumFonc:=NumTransType1;                   { de numéro TransType1 }
      nbparF:=2;
      tpRes:=refObject;
    end;
    pfonc:=Plex;

    creerLex;

    accepte(parou);
                                                { on attend une chaine de caractères }
    Plex^.genre:=param;                         {remplacer parou par param nbAnsiString }
    Plex^.tpParam:=nbAnsiString;
    ptpParam:=Plex;
    inc(intG(Plex),ParamSize);
    lireUlex;                                   { lire la suite }

    n1:=Plex;
    creerExp(typ1,vsz1);

    if typ1=refObject then
    begin
      pfonc^.NumFonc:=NumTranstype2;
      ptpParam^.tpParam:=refObject;
    end
    else
    begin
      accepteType(nbAnsiString,typ1);
      if typ1<>nbAnsiString then insererTokenConv(n1,typ1,nbAnsiString);
    end;

    accepte(parfer);

    Plex^.genre:=param;                         { Ajouter paramètre entier }
    Plex^.tpParam:=nbLong;                     { contenant le type d'objet }
    inc(intG(Plex), ParamSize);
    Plex^.genre:=nbI;
    Plex^.vnbi:=obres;
    suivant;

    lireUlex;
  end;



procedure Tcompil.creerAffectation1(n1:ptUlex;typ:typeNombre;symb:PdefSymbole);
var
  n11,n2:ptUlex;
  typ1:typeNombre;
  vsz1:integer;
  AT:TatomType;
  numOb1:integer;
  symb1:PdefSymbole;
begin
  accepte(DeuxPointEgal);

  Plex^.genre:=AffectVar;
  inserer(n1);

  if typ=nbDef then
  begin
    coderAtome(n2,AT,typ1,vsz1,numOb1,symb1);
    if not ((typ1=nbDef) and (symb=symb1))
      then sortie(E_badDefTYpe);
  end
  else
  begin
    n2:=Plex;
    creerExp(typ1,vsz1);
    accepteType(typ,typ1);
    if typ1<>typ then insererTokenConv(n2,typ1,typ);
  end;
end;


procedure Tcompil.creerInstComposee;
  begin
    lireUlex;                     { Ecraser BEGIN }
    while Plex^.genre<>motEnd do
      begin
        creerInstruction;         { INST }
        accepte(pointVirgule);    { ; }
        lireUlex;                 { Ecraser ; }
      end;
    lireUlex;                     { Ecraser END }
  end;

procedure Tcompil.creerInstIF;
  var
    P1:ptUlex;
    typ:typeNombre;
    vsz:integer;
  begin
    creerLex;                          { IF }
    creerExp(typ,vsz);                 { EXP }
    if typ<>nbBoole then sortie(E_expressionBooleenne);
    accepte(motThen);                  { THEN }
    Plex^.genre:=motGoto;              { remplacé par GOTO }
    P1:=Plex;                          { garder position du Goto }
    creerLex;
    creerInstruction;                  { INST }
    if Plex^.genre=motElse then        { ELSE }
      begin
        Plex^.genre:=motGoto;          { remplacé par Goto }
        P1^.adresse:=intG(Plex)+GotoSize-intG(P1);
                                       { la non-condition doit renvoyer }
        P1:=Plex;                      { après ce Goto }
        creerLex;                      { garder position du Goto }
        creerInstruction;              { INST }
        P1^.adresse:=intG(Plex)-intG(P1);
                                       { après exécution de la condition }
      end                              { on saute ici }
    else P1^.adresse:=intG(Plex)-intG(P1);
                                       { si pas de Else, on saute ici }
  end;
(*
Procedure Tcompil.creerInstRepeat;
  var
    P1, Pbreak:ptUlex;
    typ:typeNombre;
    vsz:integer;
  begin
    P1:=Plex;                          { garder adresse de boucle }
    Plex^.genre:=IfBreak;              { écraser REPEAT avec IfBreak}
    Pbreak:=Plex;
    creerLex;                          { Lire la suite d'instructions }
    while Plex^.genre<>motUNTIL do
      begin
        creerInstruction;              { INST }
        if Plex^.genre<>motUntil then
          begin
            accepte(pointVirgule);     { ; }
            lireUlex;                  { Ecraser ; }
          end;
      end;

    Plex^.genre:=motIF;                { remplacer Until par IF }
    creerLex;
    creerExp(typ,vsz);                 { expression }
    if typ<>nbBoole                    { bool‚enne }
      then sortie(E_expressionBooleenne);
    insererUlex(motGoto);              { insérer GOTO }
    Plex^.adresse:=intG(P1)-intG(Plex);{ P1 }
    suivant;
    Pbreak.Adresse:=intG(Plex)-intG(Pbreak);
  end;
*)

Procedure Tcompil.creerInstRepeat;
  var
    P1, Pbreak:ptUlex;
    typ:typeNombre;
    vsz:integer;
  begin
    P1:=Plex;                          { garder adresse du repeat }
    creerLex;                          { Lire la suite d'instructions }
    while Plex^.genre<>motUNTIL do
      begin
        creerInstruction;              { INST }
        if Plex^.genre<>motUntil then
          begin
            accepte(pointVirgule);     { ; }
            lireUlex;                  { Ecraser ; }
          end;
      end;

    lireULex;                          { écraser UNTIL }
    P1^.EndRepeat:=intG(Plex)-intG(P1);
    creerExp(typ,vsz);                 { expression }
    if typ<>nbBoole                    { booléenne }
      then sortie(E_expressionBooleenne);
    P1^.FinalRepeat:=intG(Plex)-intG(P1);
  end;


Procedure Tcompil.creerInstWhile;
  var
    Pwhile:ptUlex;
    typ:typeNombre;
    vsz:integer;
  begin
    Pwhile:=Plex;                      { garder adresse de boucle }
    creerLex;
    creerExp(typ,vsz);                 { expression }
    if typ<>nbBoole                    { booléenne }
      then sortie(E_expressionBooleenne);
    accepte(motDO);                    { DO }
    Pwhile^.StartWhile:= intG(Plex)-intG(Pwhile);  { adresse début }
    lireUlex;                          {Ecraser DO}

    creerInstruction;

    Pwhile^.EndWhile:=intG(Plex)-intG(Pwhile);     { adresse fin }
  end;
(*
Procedure Tcompil.creerInstWhile;
  var
    P1,P2:ptUlex;
    typ:typeNombre;
    vsz:integer;
  begin
    P1:=Plex;                          { garder adresse de boucle }
    Plex^.genre:=IfBreak;              { écraser While avec IfBreak}
    suivant;
    Plex^.genre:=motIf;                { écrire IF }
    creerLex;
    creerExp(typ,vsz);                 { expression }
    if typ<>nbBoole                    { booléenne }
      then sortie(E_expressionBooleenne);
    accepte(motDO);                    { DO }
    Plex^.genre:=motGoto;              { remplacer DO par GOTO }
    P2:=Plex;                          { garder adresse du GOTO }
    creerLex;
    creerInstruction;
    insererUlex(motGoto);
    Plex^.adresse:=intG(P1)-intG(Plex);{ P1 }
    suivant;
    P2^.adresse:=intG(Plex)-intG(P2);
    P1^.Adresse:=intG(Plex)-intG(P1);
  end;
 *)

Procedure Tcompil.creerWith;
  var
    P1,P2:ptUlex;
    valOb:Integer;
    nb:Integer;

    AT:TatomType;
    typ:typeNombre;
    vsize:integer;
    symb:PdefSymbole;

  begin
    nb:=0;

    repeat
      P1:=Plex;                        { garder adresse de départ }
      lireULex;                        { écraser With ou virgule}

      coderAtome(p1,AT,typ,vsize,valOb,symb);
      if not ( (typ=refObject)
                or
               (typ=nbDef)
             ) then sortie(E_ObjOrDef);

      qualifie:=false;

      p2:=p1;                          { inserer PushI+AffectVar+refAbs}
      inc(intG(p2), sizeof(typeLex) + sizeof(typeLex)+ refAbsSize );             { soit 7 octets }
      move(p1^,p2^,intG(UlexSuivant(Plex))-intG(p1));
      inc(intG(Plex),sizeof(typeLex) + sizeof(typeLex)+ refAbsSize );

      p1^.genre:=pushI;
      inc(intG(p1), sizeof(typelex));
      p1^.genre:=affectVar;
      inc(intG(p1), sizeof(typelex));
      p1^.genre:=refAbs;
      if typ=refObject
        then p1^.dep:=ajouteWith(valOb,0,nil)       { dep sera calculé à l'exécution }
        else p1^.dep:=ajouteWith(0,0,symb);

      inc(nb);
    until  plex^.genre<>virgule;

    accepte(motDO);
    lireUlex;                           { écraser DO }
    creerInstruction;

    supprimeWith(nb);
    insererUlex(popI);
    Plex^.genre:=popI;
    suivant;
  end;

Procedure Tcompil.creerInstFor;
  var
    Pfor:ptUlex;
    typ:typeNombre;
    vsz:integer;
  begin
    Pfor:=Plex;
    Plex^.genre:=forUp;
    creerLex;
    if not( Plex^.genre in [variByte..variDWord,
                            variLocByte..variLocDWord] )
      then sortie(E_variableEntiere);

    if flagArray then sortie(E_simpleVariable);
    creerLex;

    accepte(DeuxPointegal);
    lireUlex;

    creerExp(typ,vsz);
    if not(( typ =nbLong ) or (typ=nbInt64)) then sortie(E_expressionEntiere);

    if Plex^.genre<>motDownTo then accepte(motTO)
                              else Pfor^.genre:=ForDW;
    lireUlex;

    creerExp(typ,vsz);
    if not (( typ =nbLong ) or (typ=nbInt64)) then sortie(E_expressionEntiere);

    accepte(motDO);
    lireUlex;
    creerInstruction;
    Pfor^.depFin:=intG(Plex)-intG(Pfor);
  end;



{Instruction case. On trouve
  motCase (token + depfin)
  Expression entière
  Code option 1
  Code option 2
  etc..
  Code option Else
  TableCase

}
procedure Tcompil.creerInstCase;
var
  n0:ptUlex;
  typ:typeNombre;
  vsz:integer;
  i,k:integer;
  cas:array[1..1000] of typecas;
  cas1,cas2:integer;
  nbcase,depElse,depFinCase:integer;
  fini:boolean;
  Fmoins:boolean;
begin
  n0:=Plex;                                               { motCase }
  creerLex;

  creerExp(typ,vsz);
  if not(( typ=nbLong ) or (typ=nbInt64)) then sortie(E_expressionEntiere);  { Integer exp }

  accepte(motOF);                                         { of }

  lireUlex;
  nbcase:=0;
  depElse:=0;

  repeat
    cas1:=nbcase+1;
    repeat
      Fmoins:=false;
      if Plex^.genre=moins then
        begin
          lireUlex;
          Fmoins:=true;
        end;
      if Plex^.genre<>nbl then accepte(nbi);                { Cte entière }
      if Plex^.genre=nbi
        then k:=Plex^.vnbi
        else k:=Plex^.vnbl;
      if Fmoins then k:=-k;
      inc(nbcase);

      with cas[nbcase] do
      begin
        cte1:=k;
        cte2:=k;
        adk1:=intG(Plex)-intG(n0);
      end;

      lireUlex;
      if Plex^.genre=pointDouble then                        { .. }
        begin
          lireUlex;
          Fmoins:=false;
          if Plex^.genre=moins then
            begin
              lireUlex;
              Fmoins:=true;
            end;
          if Plex^.genre<>nbl then accepte(nbi);                { Cte entière }
          if Plex^.genre=nbi
            then k:=Plex^.vnbi
            else k:=Plex^.vnbl;
          if Fmoins then k:=-k;

          cas[nbcase].cte2:=k;
          with cas[nbcase] do
            if cte1>cte2 then sortie(E_indiceTableau);
          lireUlex;
        end;

      Fini:= (Plex^.genre<>virgule);   { si virgule, continuer pour le même code}

      if not Fini then lireUlex;
    until Fini;

    accepte(deuxPoint);
    lireUlex;
    creerInstruction;
    for i:=cas1 to nbcase do
      cas[i].adk2:=intG(Plex)-intG(n0);
    accepte(pointVirgule);
    lireUlex;

  until (Plex^.genre=motElse) or (Plex^.genre=motEnd);

  if Plex^.genre=motElse then
    begin
      lireUlex;
      depElse:=intG(Plex)-intG(n0);
      creerInstruction;
      accepte(pointVirgule);
      lireUlex;
      accepte(motEnd);
    end;

  depFinCase:=intG(Plex)-intG(n0);

  n0^.depFin:=intG(Plex)-intG(n0);
  Plex^.genre:=tableCase;
  Plex^.nbcase:=nbcase;
  Plex^.depElse:=depElse;
  Plex^.depFinCase:=depFinCase;
  inc(intG(Plex),tableCaseSize);
  move(cas,Plex^,nbcase*sizeof(typeCas));
  inc(intG(Plex),nbcase*sizeof(typeCas));

  lireUlex;
end;

procedure Tcompil.creerIncDec;
var
  typ:typeNombre;
  vsz:integer;
begin
  Creerlex;               { INC ou DEC}
  accepte(parou);
  lireUlex;               {écraser ( }
  creerReferenceVar(typ,vsz,false);
  accepteType(nbLong,typ);
  accepte(parfer);        {écraser ) }
  lireUlex;
end;


function Tcompil.creerInst1: typeNombre;
var
  n1:ptUlex;
  AT:TatomType;
  numOb:integer;
  symb:PdefSymbole;
  vsize:integer;
  typ:typeNombre;

begin
  coderAtome(n1,AT,typ,vsize,numOb,symb);
  if (AT=ATvar)  {$IFNDEF TEST_AFFECT_OBJECT} and (typ<>refObject) {$ENDIF} then
  begin
    creerAffectation1(n1,typ,symb);  {Affectation variable}
    typ:=nbNul;
  end
  else
  if AT=ATvarArray then sortie('[ expected')
  else
  if AT=ATnothing then sortie(E_Instruction);

  result:=typ;
end;

function Tcompil.creerInstruction : typeNombre;
  begin
    result:= nbNul;
    setDebugInfo;
    case Plex^.genre of
      motBreak:     creerLex;
      motExit:      creerLex;
      procU,foncU:        creerAppelProcU;      //foncU ajouté le 191212
      proced:       creerAppelProcedure;
      motBegin:     creerInstComposee;
      motIF:        creerInstIf;
      motRepeat:    creerInstRepeat;
      motWhile:     creerInstWhile;
      motFOR:       creerInstFor;
      motCASE:      creerInstCase;
      motWith:      creerWith;
      motInc,motDec:creerIncDec;

      else          result:=creerInst1;
    end;
  end;

procedure Tcompil.creerInstructionSimple;
  begin
    case Plex^.genre of
      proced:       creerAppelProcedure;
      else          sortie(E_instructionSimple);
    end;
  end;

procedure Tcompil.compilerPgSimple;
  begin
    PgSimple:=true;
    pgC.PlexTrait:=PlexToDep(Plex);
    while Plex^.genre<>finfich do
      begin
        creerInstructionSimple;
        accepte(pointVirgule);
        lireUlex;
      end;
    Plex^.genre:=stop;

    Suivant;
    Plex^.genre:=finFich;
    suivant;
  end;

function Tcompil.ValidIdentiFier(Flocal:boolean):boolean;
begin
  result:=(Plex^.genre=motNouveau)
          OR
          (Fsymbole in [GSsymbN,GSfps])
           OR
          Flocal AND (Fsymbole=GSsymb0) AND (symbole^.ident in [Svar,Sconst,Stype]);
end;

Procedure Tcompil.creerConstPart(Ssymb:typeSymbole);
  var
    Fmoins:boolean;
    i:Integer;
    l:longint;
    r:float;
    Flocal,ok:boolean;
    lineNum,ColNum:integer;
    stDum:AnsiString;
  const
    varTrue:boolean=true;
    varFalse:boolean=false;
  begin
    Flocal:=(Ssymb=SconstLoc);

    lireUlex;

    OK:= ValidIdentifier(Flocal);
    if not OK then accepte(motNouveau);

    while OK do
    begin
      Ulex1.getLastPos(lineNum,colNum,stDum);
      Fmoins:=false;
      NouveauSymbole(Ssymb,stMotUlexMaj,lineNum);
      lireUlex;
      accepte(egal);
      lireUlex;
      if Plex^.genre=moins then
        begin
          lireUlex;
          Fmoins:=true;
        end;
      case Plex^.genre of
        nbi: begin
               if Fmoins then i:=-Plex^.vnbi
                         else i:=Plex^.vnbi;
               tableSymbole.setConstante(nbSmall,i);
             end;
        nbL: begin
               if Fmoins then l:=-Plex^.vnbl
                         else l:=Plex^.vnbl;
               tableSymbole.setConstante(nbLong,l);
             end;
        nbR: begin
               if Fmoins then r:=-Plex^.vnbr
                         else r:=Plex^.vnbr;
               tableSymbole.setConstante(nbExtended,r);
             end;
        ConstCar:
             if not Fmoins then tableSymbole.setConstante(nbChar,Plex^.vc)
                           else sortie(E_constante);
        ChaineCar:
             if not Fmoins then tableSymbole.setStringConst(Plex^.st)
                           else sortie(E_constante);
        motTrue:
             if not Fmoins then tableSymbole.setConstante(nbBoole,vartrue)
                           else sortie(E_constante);
        motFalse:
             if not Fmoins then tableSymbole.setConstante(nbBoole,varfalse)
                           else sortie(E_constante);
        else sortie(E_constante);
      end;
      lireUlex;
      accepte(pointVirgule);
      lireUlex;

      ok:=ValidIdentifier(Flocal);
    end;
  end;


procedure Tcompil.creerArray;
  var
    i1,i2:Integer;
    Fmoins:boolean;
    lineNum,ColNum:integer;
    stDum:AnsiString;
  begin
    NouveauSymbole(Stab,'++',0);
    lireUlex;               {Ecarter Array}
    accepte(croOu);         {Crochet ouvert}
    repeat
      lireUlex;

      if Plex^.genre=moins then
        begin
          lireUlex;
          Fmoins:=true;
        end
      else Fmoins:=false;

      if Plex^.genre=nbi then
      begin
        if Fmoins then i1:=-Plex^.vnbi else i1:=Plex^.vnbi;
      end
      else
      begin
        accepte(nbL);
        if Fmoins then i1:=-Plex^.vnbl else i1:=Plex^.vnbl;
      end;

      lireUlex;
      accepte(PointDouble);
      lireUlex;

      if Plex^.genre=moins then
        begin
          lireUlex;
          Fmoins:=true;
        end
      else Fmoins:=false;

      if Plex^.genre=nbi then
      begin
        if Fmoins then i2:=-Plex^.vnbi else i2:=Plex^.vnbi;
      end
      else
      begin
        accepte(nbL);
        if Fmoins then i2:=-Plex^.vnbl else i2:=Plex^.vnbl;
      end;

      if i1>i2 then sortie(E_indiceTableau);

      tableSymbole.setIndiceTab(i1,i2);
      lireUlex;
    until Plex^.genre<>virgule;
    accepte(croFer);
    lireUlex;
    accepte(motOF);
    lireUlex;
  end;


Procedure Tcompil.creerVarPart(Ssymb:typeSymbole);
  var
    flagChaine:boolean;
    longueur:Integer;
    Flocal:boolean;
    ok:boolean;
    Prefix:AnsiString;
    lineNum,ColNum:integer;
    stDum:AnsiString;
  begin
    Flocal:=(Ssymb<>Svar);

    if Ssymb=Sfield then Prefix:=#1;
    lireUlex;                                     {Ecraser VAR}
    ok:=validIdentifier(Flocal);
    if not ok then accepte(motNouveau);           {Identificateur}

    while ok do
    begin
      tableSymbole.setFirstVar;

      Ulex1.getLastPos(lineNum,colNum,stDum);
      NouveauSymbole(Ssymb,Prefix+stMotUlexMaj,lineNum);
      lireUlex;
      while Plex^.genre=Virgule do               { virgule }
      begin
        lireUlex;
        ok:=validIdentifier(Flocal);             {Identificateur}
        if not ok then accepte(motNouveau);

        Ulex1.getLastPos(lineNum,colNum,stDum);
        NouveauSymbole(Ssymb,Prefix+stMotUlexMaj, lineNum);
        lireUlex;
      end;
      accepte(DeuxPoint);                        {deux points }
      lireUlex;
      if Plex^.genre=motArray then creerArray;   {ARRAY éventuellement}
      flagChaine:=false;

      case Plex^.genre of                        {puis type }

        motByte..motChar:     tableSymbole.setType(ResToNb(Plex^.genre),0);

        motShortString:
                    begin                        {SHORTSTRING}
                      lireUlex;
                      longueur:=255;
                      flagChaine:=true;
                      if Plex^.genre=croOu then
                        begin
                          lireUlex;
                          accepte(nbi);
                          if (Plex^.vnbi>0) and (Plex^.vnbi<=255)
                            then longueur:=Plex^.vnbi
                            else sortie(E_longueurDeChaine);
                          lireUlex;
                          accepte(croFer);
                          lireUlex;
                        end;
                      tableSymbole.setType(nbChaine,longueur);
                    end;

        motANSIstring:
                    begin
                      lireUlex;
                      flagChaine:=true;
                      if Plex^.genre=croOu then
                        begin
                          lireUlex;
                          accepte(nbi);
                          if (Plex^.vnbi>0) and (Plex^.vnbi<=255)
                            then longueur:=Plex^.vnbi
                            else sortie(E_longueurDeChaine);
                          lireUlex;
                          accepte(croFer);
                          lireUlex;
                          tableSymbole.setType(nbChaine,longueur);
                        end
                      else tableSymbole.setType(nbANSIstring,0);
                    end;

        TypeObjet:  {if sSymb=Svar then}
                      begin
                        tableSymbole.setType(refObject,Plex^.VobTO);
                      end;
                      {else sortie(E_NomDeType);}

        Utype:      begin
                      tableSymbole.setType(nbDef,LastTable.symbDep(symbole)
                                                 +numUnit shl 24);
                    end;
        else sortie(E_NomDeType);
      end;
      if not FlagChaine then lireUlex;
      accepte(pointVirgule);                     {point virgule}
      lireUlex;
      ok:=validIdentifier(Flocal);
    end;
  end;

Procedure Tcompil.CreerTypeSimple(stTypeName:AnsiString;Typeline:integer);
begin                               {ex: Ttruc = integer; }
  NouveauSymbole(Stype,stTypeName, typeLine);

  tableSymbole.setSimpleType(restonb(Plex^.genre));

  lireUlex;
  accepte(pointVirgule);
  lireUlex;
end;

Procedure Tcompil.creerTypeRecord(stTypeName:AnsiString;Typeline:integer);
var
  flagChaine:boolean;
  longueur:Integer;
  ok:boolean;
  LineNum,ColNum:integer;
  stDum:AnsiString;

function validIdentifier:boolean;
begin
  result:=(Plex^.genre=motNouveau)
          OR
          not(Fsymbole in [GSnone,GSmotRes]);

end;

begin
  lireUlex;                                     {Ecraser RECORD}
  ok:=validIdentifier;
  if not ok then accepte(motNouveau);           {Identificateur}

  tableSymbole.beginRecord;
  while ok do
  begin
    tableSymbole.setFirstVar;
    Ulex1.getLastPos(lineNum,ColNum,stDum);
    NouveauSymbole(Sfield,#1+stMotUlexMaj,lineNum);
    lireUlex;
    while Plex^.genre=Virgule do               { virgule }
    begin
      lireUlex;
      ok:=validIdentifier;                     {Identificateur}
      if not ok then accepte(motNouveau);
      Ulex1.getLastPos(lineNum,ColNum,stDum);
      NouveauSymbole(Sfield,#1+stMotUlexMaj,lineNum);
      lireUlex;
    end;
    accepte(DeuxPoint);                        {deux points }
    lireUlex;
    if Plex^.genre=motArray then creerArray;   {ARRAY éventuellement}
    flagChaine:=false;
    case Plex^.genre of                        {puis type }
      motByte..motChar:     tableSymbole.setType(ResToNb(Plex^.genre),0);
      motShortString:                          { SHORTSTRING }
                  begin
                    lireUlex;
                    longueur:=255;
                    flagChaine:=true;
                    if Plex^.genre=croOu then
                      begin
                        lireUlex;
                        accepte(nbi);
                        if (Plex^.vnbi>0) and (Plex^.vnbi<=255)
                          then longueur:=Plex^.vnbi
                          else sortie(E_longueurDeChaine);
                        lireUlex;
                        accepte(croFer);
                        lireUlex;
                      end;
                    tableSymbole.setType(nbChaine,longueur);
                  end;
      motAnsiString:                           { AnsiString }
                  begin
                    lireUlex;
                    flagChaine:=true;
                    Accepte(croOu);            { Obligatoirement AnsiString[ xxx ] }
                                               { On interdit les AnsiString }
                    lireUlex;
                    accepte(nbi);
                    if (Plex^.vnbi>0) and (Plex^.vnbi<=255)
                      then longueur:=Plex^.vnbi
                      else sortie(E_longueurDeChaine);
                    lireUlex;
                    accepte(croFer);
                    lireUlex;

                    tableSymbole.setType(nbChaine,longueur);
                  end;

      {TypeObjet:  tableSymbole.setType(refObject,Plex^.Vob);
       On interdit les objets
      }

      Utype:      begin
                      tableSymbole.setType(nbDef,LastTable.symbDep(symbole)
                                                 +numUnit shl 24  );
                  end;
      else sortie(E_NomDeType);
    end;
    if not FlagChaine then lireUlex;
    accepte(pointVirgule);                     {point virgule}
    lireUlex;
    ok:=validIdentifier;
  end;
  accepte(motEnd);
  lireUlex;
  accepte(pointVirgule);
  lireUlex;

  tableSymbole.EndRecord(stTypeName,typeLine);
end;


Procedure Tcompil.creerTypeClass(stTypeName:AnsiString; typeLine:integer);
var
  flagChaine:boolean;
  longueur:Integer;
  ok:boolean;

  symbAncestor:PdefSymbole;
  UnitAncestor:integer;
  ClassLine,Unum:integer;
  st:AnsiString;

function validIdentifier:boolean;
begin
  result:=(Plex^.genre=motNouveau)
          OR
          not(Fsymbole in [GSnone,GSmotRes]);

end;

begin
  Ulex1.getLastPos(ClassLine,Unum,st);
  lireUlex;                                     {Ecraser le mot CLASS}
  if Plex^.genre=parou then                     {  (  }
  begin
    lireUlex;                                   { Other Class }
    if not(assigned(symbole) and (symbole^.ident=Stype) and (symbole^.infoType.TNgenre=TNclass))
      then sortie('Class Name Expected');
    symbAncestor:=symbole;
    UnitAncestor:=NumUnit;
    lireUlex;
    accepte(parfer);                            {  )  }
    lireUlex;
  end;

  tableSymbole.beginClass;
  renvoye:=1;
  creervarpart(Sfield);

  accepte(motEnd);
  lireUlex;
  accepte(pointvirgule);
  lireUlex;

  tableSymbole.EndClass(stTypeName,SymbAncestor,UnitAncestor,ClassLine);
end;


Procedure Tcompil.creerTypeArray(stTypeName:AnsiString;typeLine:integer);
var
  flagChaine:boolean;
  longueur:integer;
  st:AnsiString;
begin
  creerArray;
  flagChaine:=false;
  case Plex^.genre of                        {puis type }
    motByte..motChar:     tableSymbole.setTypeArray(stTypeName,ResToNb(Plex^.genre),0,TypeLine);
    motShortString:
                 begin
                  lireUlex;
                  longueur:=255;
                  flagChaine:=true;
                  if Plex^.genre=croOu then
                    begin
                      lireUlex;
                      accepte(nbi);
                      if (Plex^.vnbi>0) and (Plex^.vnbi<=255)
                        then longueur:=Plex^.vnbi
                        else sortie(E_longueurDeChaine);
                      lireUlex;
                      accepte(croFer);
                      lireUlex;
                    end;
                  tableSymbole.setTypeArray(stTypeName,nbChaine,longueur,typeLine);
                end;
    TypeObjet:  tableSymbole.setTypeArray(stTypeName,refObject,Plex^.VobTO,TypeLine);

    Utype:      begin
                  tableSymbole.setTypeArray(stTypeName,nbDef,LastTable.symbDep(symbole)
                                             +numUnit shl 24, typeLine);
                end;
    else sortie(E_NomDeType);
  end;
  if not FlagChaine then lireUlex;
  accepte(pointVirgule);                     {point virgule}
  lireUlex;
end;

Procedure Tcompil.CreerTypeEnum(stTypeName:AnsiString;typeline:integer);
begin
end;

Procedure Tcompil.CreerTypeAlias(stTypeName:AnsiString;typeLine:integer);
begin
  NouveauSymbole(Stype,stTypeName,typeLine);           { Ttruc = Tchose }

  tableSymbole.setAliasType(NumUnit,symbole);

  lireUlex;
  accepte(pointVirgule);
  lireUlex;
end;

Procedure Tcompil.creerTypePart(Flocal:boolean);
var
  st:AnsiString;
  ok:boolean;
  lineNum,colNum: integer;
  stDum: AnsiString;
begin
  lireUlex;                       {Ecraser le mot TYPE }
  ok:=validIdentifier(Flocal);
  if not ok then accepte(motNouveau);

  while ok do
  begin
    st:=stMotUlexMaj;             {Ranger le nom de type }
    Ulex1.getLastPos(lineNum,colNum,stDum);
    lireUlex;                     {Ecraser le nom du type }
    accepte(egal);
    lireUlex;                     {Ecraser =}
    case Plex^.genre of
      motByte..motANSIString: CreerTypeSimple(st,lineNum);
      lex2:  case Plex^.Vlex2 of
               motRecord: creerTypeRecord(st,lineNum);
               motClass:  creerTypeClass(st,lineNum);
               else sortie(E_typeDef);
             end;
      motArray:  creerTypeArray(st,lineNum);
      {parou:     creerTypeEnum(st);  }
      Utype:     creerTypeAlias(st,lineNum);
      else sortie(E_typeDef);
    end;

    ok:=validIdentifier(Flocal);
  end;
end;

function IsEnteteBloc(Plex: PtUlex): boolean;
begin
  result:= (Plex^.genre=lex2) and (Plex^.Vlex2 in EnteteBloc);
end;

procedure Tcompil.creerCorpsBloc;
  begin
    repeat
      creerInstruction;
      accepte(pointVirgule);
      lireUlex;
    until IsEnteteBloc(Plex) or (Plex^.genre=finfich);

    insererUlex(Stop);
    suivant;
  end;


Procedure Tcompil.creerTraitPart;
  begin
    if BlocTraitementExiste then sortie(E_blocTraitementExiste);
    lireUlex;
    pgC.PlexTrait:=PlexToDep(Plex);
    creerCorpsBloc;
  end;

Procedure Tcompil.creerInit0Part;
  begin
    if BlocInit0Existe then sortie(E_blocInit0Existe);
    lireUlex;
    pgc.PlexInit0:=PlexToDep(Plex);
    creerCorpsBloc;
  end;


Procedure Tcompil.creerInitPart;
  begin
    if BlocInitExiste then sortie(E_blocInitExiste);
    lireUlex;
    pgc.PlexInit:=PlexToDep(Plex);
    creerCorpsBloc;
  end;

Procedure Tcompil.creerContPart;
  begin
    if BlocContExiste then sortie(E_blocContExiste);
    lireUlex;
    pgc.PlexCont:=PlexToDep(Plex);
    creerCorpsBloc;
  end;



Procedure Tcompil.creerFinPart;
  begin
    if BlocFinExiste then sortie(E_blocFinExiste);
    lireUlex;
    pgc.PlexFin:=PlexToDep(Plex);
    creerCorpsBloc;
  end;

Procedure Tcompil.creerProgPart;

  procedure accepteNomDeProgramme;
  var
    i:Integer;
  begin
    if stMotUlex='' then sortie(E_NomProgram);
    with pgc.PlexProgram do
    for i:=0 to count-1 do
      if (stMotUlex=Strings[i]) and (stMotUlex<>'-') then sortie(E_NomProgram);
  end;

begin
  lireUlex;

  accepteNomDeProgramme;
  pgc.PlexProgram.addObject(stMotUlex,pointer(PlexToDep(Plex)));

  lireUlex;

  if (Plex^.genre=divis) then
    begin
      lireUlex;
      if not traiterSlash(stMotUlexMaj) then sortie(E_directive);
      lireUlex;
    end;

  creerCorpsBloc;
end;

{types résultat de fonction}
procedure Tcompil.creerNomDeTypeSimple(var tpnb:typeNombre);
  begin
    case Plex^.genre of
      motByte..motANSIstring: tpnb:=restoNb(Plex^.genre);
      else                    sortie(E_nomDeTypeAttendu);
    end;
    lireUlex;
  end;

{types utilisés dans les listes de paramètres formels}
procedure Tcompil.creerNomDeType(var tpnb:typeNombre;var attribut:integer);
  begin
    case Plex^.genre of
      motByte..motANSIstring:tpnb:=restoNb(Plex^.genre);
      typeObjet:   begin
                     tpnb:=refObject;
                     attribut:=Plex^.vobTO;
                   end;
      Utype:       begin
                     tpnb:=nbDef;
                     attribut:=LastTable.symbDep(symbole) +numUnit shl 24;
                   end;
      else         sortie(E_nomDeTypeAttendu);
    end;
    lireUlex;
  end;


procedure Tcompil.creerListeParamFormels(NewProc:boolean);
var
  i,nb:Integer;
  flag:boolean;
  tpnb:typeNombre;
  tpOb:integer;
  lineNum,ColNum:integer;
  stDum:AnsiString;
begin
  NEWPROC:=TRUE;

  flag:=(Plex^.genre=lex2) and (Plex^.Vlex2= motVar);
  if flag then lireUlex;

  if not newProc and (stMotUlexMaj<>'') then StMotUlexMaj:= stMotUlexMaj+'#'
  else
  if not(Plex^.genre in UlexGlobales) then accepte(motNouveau);

  tableSymbole.setFirstVar;
  Ulex1.getLastPos(lineNum,ColNum,stDum);
  NouveauSymbole(Svarloc,stMotUlexMaj,lineNum);

  nb:=1;
  lireUlex;
  while Plex^.genre=virgule do
    begin
      lireUlex;

      if not newProc and (stMotUlexMaj<>'') then stMotUlexMaj:=stMotUlexMaj+'#'
      else
      if not(Plex^.genre in UlexGlobales) then accepte(motNouveau);

      Ulex1.getLastPos(lineNum,ColNum,stDum);
      NouveauSymbole(Svarloc,stMotUlexMaj,lineNum);
      inc(nb);
      lireUlex;
    end;
  accepte(deuxPoint);
  lireUlex;
  creerNomDeType(tpNb,tpOb);

  if not flag and (tpnb=refObject) then sortie(E_refObjectExpected);

  if flag and (tpNb>=nbByte) and (tpNb<=nbAnsiString)
    then tpnb:=typeNombre(ord(tpnb)+ord(refByte)-ord(nbByte));
  if flag and (tpNb=nbDef) then tpnb:=RefDef;

  for i:=1 to nb do tableSymbole.setParam(tpNb,tpOb);

  if tpnb=refObject
    then TableSymbole.setType(RefObject,tpOb)
  else
  if (tpnb=nbDef) or (tpnb=refDef)
    then TableSymbole.setType(tpNb,tpOb)
  else
  if tpnb=nbChaine
    then TableSymbole.setType(tpNb,255)
  else
  if tpnb=refChaine
    then TableSymbole.setType(tpNb,0)
  else TableSymbole.setType(tpNb,255);
end;


procedure Tcompil.creerCorpsDeclaration(NewProc:boolean);
var
  lineNum,ColNum:integer;
  stDum:AnsiString;
begin
  accepte(motNouveau);
  Ulex1.getLastPos(lineNum,ColNum,stDum);
  NouveauSymbole(SprocU,Plex^.st,lineNum);
  lireUlex;
  if Plex^.genre=parou then
    begin
      lireUlex;
      creerListeParamFormels(newProc);
      while Plex^.genre=pointVirgule do
        begin
          lireUlex;
          creerListeParamFormels(newProc);
        end;
      accepte(parfer);
      lireUlex;
    end;

end;



procedure Tcompil.creerCorpsProcedure;
begin
  {}

  while (Plex^.genre=lex2) and ((Plex^.Vlex2 = motConst) or (Plex^.Vlex2=motVar) or (Plex^.Vlex2=motType)) do
  case Plex^.Vlex2 of
    motConst: creerConstPart(SconstLoc);
    motVar:   creerVarPart(SvarLoc);
    motType:  creerTypePart(true);
  end;

  accepte(motBegin);

  TailleLocale:=TableSymbole.setDeplacement;

  TableSymbole.setAdresse(intG(Plex)-intG(pgc.CS));

  Plex^.genre:=nbl;             { 9 déc 2011: nbi remplacé par nbl }
  Plex^.vnbl:=TailleLocale;
  inc(intG(Plex),NbLsize);

  lireUlex;
  while Plex^.genre<>motEnd do
  begin
    creerInstruction;
    accepte(pointVirgule);
    lireUlex;
  end;
  Plex^.genre:=stop;
  creerLex;
  accepte(pointVirgule);
  lireUlex;
  TableSymbole.resetLocal;
  tailleLocale:=0;
end;

procedure Tcompil.creerProcU;
var
  p:PdefSymbole;
  stProc:AnsiString;
begin
  lireUlex;                       {Ecraser mot procedure}
  p:=Symbole;

  stProc:=stMotUlexMaj;

  if Plex^.genre=motNouveau then  {Nouvelle procedure }
    begin
      CurrentPrefix:=stProc+'.';
      creerCorpsDeclaration(true);
      accepte(pointVirgule);
      lireUlex;
      if (Plex^.genre=lex2) and (Plex^.Vlex2 =motForward) then
      begin
        tableSymbole.EndInterfaceProc;
        lireUlex;
        accepte(pointVirgule);
        lireUlex;
      end
      else
      begin
        TableSymbole.initDeplacement;
        creerCorpsProcedure;
      end;
    end
  else                           { Procedure déjà déclarée dans interface ou avec forward }
  if (Plex^.genre=procU) and (symbole^.infP.adresse=-1) then
  begin
    tableSymbole.StartProcedureImp(p);   // modifie les identificateurs de la première déclaration

    Plex^.genre:=motNouveau;
    Plex^.st:=stMotUlex;

    CurrentPrefix:=stProc+'.';
    creerCorpsDeclaration(false);
    if not tableSymbole.ProcedureConforme then sortie(E_ProcNonConforme);
    accepte(pointVirgule);

    lireUlex;
    TableSymbole.initDeplacement;

    creerCorpsProcedure;
    tableSymbole.EndProcedureImp;
  end

  else accepte(motNouveau);
  CurrentPrefix:='';
end;

procedure Tcompil.creerFoncU;
var
  p:PdefSymbole;
  tpnb:typeNombre;
  stProc: AnsiString;
  st:Ansistring;
  resline,col:integer;
begin
  lireUlex;                    {Ecraser mot function}
  p:=Symbole;

  stProc:=stMotUlexMaj;

  if Plex^.genre=motNouveau then { Nouvelle fonction }
    begin
      CurrentPrefix:=stProc+'.';
      creerCorpsDeclaration(true);
      accepte(DeuxPoint);
      lireUlex;
      creerNomDeTypeSimple(tpnb);
      Ulex1.getLastPos(resLine,col,st);


      accepte(pointVirgule);
      lireUlex;
      if (Plex^.genre=lex2) and (Plex^.Vlex2=motForward) then
      begin
        tableSymbole.setResult(tpNb,true,resline);
        tableSymbole.EndInterfaceProc;
        lireUlex;
        accepte(pointVirgule);
        lireUlex;
      end
      else
      begin
        TableSymbole.initDeplacement;
        tableSymbole.setResult(tpNb,false,resline);
        creerCorpsProcedure;
      end;
    end
  else                          { fonction déjà déclarée dans interface ou avec forward }
  if (Plex^.genre=foncU) and (symbole^.infP.adresse=-1) then
  begin
    Plex^.genre:=motNouveau;
    Plex^.st:=stMotUlexMaj;
    tableSymbole.StartProcedureImp(p);

    CurrentPrefix:=stProc+'.';
    creerCorpsDeclaration(false);

    accepte(DeuxPoint);
    lireUlex;
    creerNomDeTypeSimple(tpnb);
    Ulex1.getLastPos(resLine,col,st);
    TableSymbole.initDeplacement;
    tableSymbole.setResult(tpNb,false,resline);
    if not tableSymbole.ProcedureConforme then sortie(E_ProcNonConforme);

    accepte(pointVirgule);
    lireUlex;

    creerCorpsProcedure;

    tableSymbole.EndProcedureImp;
  end

  else accepte(motNouveau);

  CurrentPrefix:='';
end;


procedure Tcompil.creerUses;
var
  p:TpgContext;
  isComp:boolean;
begin
  repeat
    lireUlex;                 {écraser Uses ou virgule}

    p:=pgc.loadUnit(stMotUlexMaj,BadUnitError,BadUnitLine,BadUnitCol,BadUnitFile,BuildMode, isComp);
    if not assigned(p) then sortie(E_UnitNotLoaded);

    inc(maxTables);
    tables[maxTables]:=p.tableSymbole;
    tableSymbole.tables[maxTables]:=p.tableSymbole;

    lireUlex;
    if not (Plex^.genre in [virgule,pointVirgule]) then accepte(virgule);
  until Plex^.genre=pointVirgule;

  lireUlex;
end;

procedure Tcompil.creerBlocInterface;
var
  fin:boolean;
  tpnb:typeNombre;
  resline,col:integer;
  st:Ansistring;
begin
  fin:=false;
  repeat
    case Plex^.genre of
      lex2: case Plex^.Vlex2 of
              motCONST:         creerConstPart(Sconst);
              motVAR:            creerVarPart(Svar);
              motType:           creerTypePart(false);

              motProcedure:      begin
                                   lireUlex;
                                   tableSymbole.BeginInterfaceProc;
                                   CurrentPrefix:=stMotUlexMaj+'.';
                                   creerCorpsDeclaration(true);
                                   CurrentPrefix:='';
                                   tableSymbole.EndInterfaceProc;
                                   accepte(pointVirgule);
                                   lireUlex;
                                 end;
              motFunction:       begin
                                   lireUlex;
                                   tableSymbole.BeginInterfaceProc;
                                   CurrentPrefix:=stMotUlexMaj+'.';
                                   creerCorpsDeclaration(true);
                                   CurrentPrefix:='';
                                   accepte(DeuxPoint);
                                   lireUlex;
                                   creerNomDeTypeSimple(tpnb);
                                   Ulex1.getLastPos(resLine,col,st);
                                   tableSymbole.setResult(tpNb,true,resline);

                                   tableSymbole.EndInterfaceProc;
                                   accepte(pointVirgule);
                                   lireUlex;
                                 end;
              else fin:=true;
            end;
      else fin:=true;
    end;
  until fin;
end;

procedure Tcompil.creerBlocImplementation;
var
  fin:boolean;
  st:AnsiString;
begin
  fin:=false;
  repeat
    if Plex^.genre=lex2 then
    case Plex^.Vlex2 of
      motCONST:          creerConstPart(Sconst);
      motVAR:            creerVarPart(Svar);
      motType:           creerTypePart(false);

      motProcedure:      creerProcU;
      motFunction:       creerFoncU;

      else fin:=true;
    end
    else fin:=true;
  until fin;

  if Plex^.genre=motEnd then
  begin
    lireUlex;
    accepte(pointL);
  end
  else accepte(finFich);

  st:=tableSymbole.EndImplementation;

  if st<>''
    then  sortie('Undefined declaration: '+st );

end;




procedure Tcompil.creerUnit;

  procedure accepteNomUnit;
  var
    i:integer;
  begin
    if stMotUlexMaj='' then sortie(E_NomUnite);
    for i:=1 to length(stMotUlexMaj) do
      if not (stMotUlexMaj[i] in ['A'..'Z','a'..'z','0'..'9','_'])
        then sortie(E_NomUnite);

    if Fmaj(filename)<> stMotUlexMaj then sortie('Unit Name must match file name');
    UnitName:=stMotUlexMaj;

    tableSymbole.setUnit(unitName);
    pgc.Funit:=true;
  end;

begin
                             {en entrée, Plex contient Unit}
  lireUlex;                  {lire le nom et écraser Unit}
  accepteNomUnit;

  lireUlex;                  { ; }
  accepte(PointVirgule);
  lireUlex;                  { Interface}
  accepte(lex2, motInterface);
  lireUlex;

  if (Plex^.genre=lex2) and (Plex^.Vlex2=motUses)     {USES...}
    then CreerUses;

  CreerBlocInterface;

  accepte(lex2,motImplementation);
  lireUlex;
  tableSymbole.setImplementation;
  creerBlocImplementation;
end;


procedure Tcompil.compilerPgComplexe;
  begin
    BlocTraitementExiste:=false;
    BlocInitExiste:=false;
    BlocInit0Existe:=false;
    BlocFinExiste:=false;
    PgSimple:=false;

    if (Plex^.genre=lex2) and (Plex^.Vlex2= motUnit) then creerUnit              { Unité }
    else
    begin
      if (Plex^.genre=lex2) and (Plex^.Vlex2=motUses) then CreerUses;            {Programme}

      while Plex^.genre<>finFich do
      begin
        if Plex^.genre=lex2 then
        case Plex^.Vlex2 of
          motType:           creerTypePart(false);
          motCONST:          creerConstPart(Sconst);
          motVAR:            creerVarPart(Svar);
          motProcess:        creerTraitPart;
          motInitProcess:    creerInitPart;
          motInitProcess0:   creerInit0Part;
          motProcessCont:    creerContPart;
          motEndProcess:     creerFinPart;
          motProgram:        creerProgPart;
          motProcedure:      creerProcU;
          motFunction:       creerFoncU;
          else sortie(E_bloc);
        end
        else sortie(E_bloc);
      end;
    end;
    Plex^.genre:=stop;
    Suivant;
    Plex^.genre:=finFich;
    suivant;
  end;


procedure Tcompil.compiler;
  begin
    lireUlex;
    if not (isEnteteBloc(Plex) or (Plex^.genre=lex2) and (Plex^.Vlex2 in [motUnit,motUses]))
      then compilerPgSimple
      else compilerPgComplexe;
    PlexFin:=Plex;

    if FlagCondition then sortie('A conditional directive is not terminated');
  end;

procedure Tcompil.resetPg;
begin
  pgc.reset;
end;


procedure Tcompil.compilerPg1;
begin
  UnitName:='';
  CurrentPrefix:='';

  initWith;
  Qualifie:=false;
  Renvoye:=0;

  resetPg;

  MaxTables:=0;
  Tables[0]:=pgc.tableSymbole;
  TableSymbole.Tables[0]:=pgc.tableSymbole;

  oldLine:=0;
  BadUnitFile:='';
  BadUnitError:='';
  errComp:=0;

  Ulex1:=TUlex1.create(stList);

  reallocmem(pgc.cs,taillePgInit+codeExtraSize);
  pgc.codeSize:=taillePgInit;
  Plex:=pgc.CS;

  installeImplicit;

  try
     compiler;
  except
    on E: Exception do
      begin
        if errComp=0 then raise;
        Ulex1.getLastPos(ligneC,ColonneC,ErrorFile);
      end;
  end;

  Ulex1.free;

  if BadUnitError<>'' then
  begin
    ligneC:= BadUnitLine;
    ColonneC:= BadUnitCol;
    ErrorFile:=BadUnitFile;

    stError:=  BadUnitError +crlf+
              'Compiler error  in '+ErrorFile +crlf+
              'line '+Istr(ligneC)+'  column '+Istr(ColonneC);
    resetPg;
  end
  else
  if ErrComp<>0 then
  begin
    stError:=  getCompilerString(ErrComp) +crlf+
              'Compiler error  in '+ ErrorFile +crlf+
              'line '+Istr(ligneC)+'  column '+Istr(ColonneC);

    resetPg;
  end
  else
  begin
    pgc.codeSize:=intG(Plex)-intG(pgc.cs);
    reallocmem(pgc.cs,pgc.codeSize+codeExtraSize);
    pgc.compileOK:=true;
  end;
end;

procedure Tcompil.compilerExtra(Pdata: pointer);
var
  n0,n1:ptUlex;
  isVar,isProp:boolean;
  typ:typeNombre;
  vsize:integer;
  numOb:integer;
  symb:PdefSymbole;

  genre:typelex;
  Again:boolean;
  OldNbWith:integer;

  AT:TatomType;
begin
  Again:=false;
  n0:=Plex;
  OldNbWith:=nbWith;

  { On essaie de creer une instruction complète }
  TRY
  lireUlex;
  typ := creerInstruction;
  except
    errComp:=0;
    Again:=true;
  end;

  {Si c'est un échec, on essaie de créer une expression}
  if Again or (typ<>nbNul) then
  begin
    Again:=false;
    Plex:=n0;              { Réinitialiser le pointeur d'écriture }
    n1:=Plex;

    Ulex1.Free;            { Réinitialiser l'analyseur lexical }
    Ulex1:=TUlex1.create(stList);

    nbWith:=OldNbWith;     { Réinitialiser le mécanisme des With }
    Qualifie:=false;
    Renvoye:=0;

    lireUlex;
    creerExp(typ,vsize);   { Créer l'expression }

    case typ of
      nbByte..nbChar,nbAnsiString,nbChaine:  genre:=refSys;
      nbdef:                                 begin
                                               genre:=vid;
                                               Again:=true;
                                             end;
      else                                   genre:=vid;
    end;

    if genre<>vid then
    begin
      inserer1(n1,genre);

      with n1^ do                { Insérer RefSys }
      begin
        adSys:=Pdata;
        tpSys:=typ;
        szSys:=vsize;
      end;

      Plex^.genre:=AffectVar;    { et AffectVar }
      inserer(n1);
    end
    else
    begin
      Plex:=n0;
    end;
  end;

  if Again then
  begin
    Plex:=n0;              { Réinitialiser le pointeur d'écriture }
    n1:=Plex;

    Ulex1.Free;            { Réinitialiser l'analyseur lexical }
    Ulex1:=TUlex1.create(stList);

    nbWith:=OldNbWith;     { Réinitialiser le mécanisme des With }
    Qualifie:=false;
    Renvoye:=0;

    lireUlex;
    coderAtome(n1,AT,typ,vsize,numOb,symb); { Créer atome }

    if typ=nbdef then
    begin
      inserer1(n1,refSys);

      with n1^ do                { Insérer RefSys }
      begin
        adSys:=Pdata;
        tpSys:=typ;
        szSys:=vsize;
      end;

      Plex^.genre:=AffectVar;    { et AffectVar }
      inserer(n1);
    end
    else
    begin
      Plex:=n0;
    end;
  end;

  Plex^.genre:=stop;
  Suivant;
  Plex^.genre:=finFich;
  suivant;
end;


procedure Tcompil.compilerPg1Extra(Pcode,Pdata:pointer);
begin
  UnitName:='';

  initWith;
  Qualifie:=false;
  Renvoye:=0;

  oldLine:=0;
  BadUnitFile:='';
  errComp:=0;

  Ulex1:=TUlex1.create(stList);

  Plex:=Pcode;
  installeImplicit;    { il faut remplir tbWith }
  Plex:=Pcode;         { mais on n'a pas besoin du code d'initialisation }

  try
    compilerExtra(Pdata);
  except
    on E: Exception do
      begin
        if errComp=0 then raise;
        Ulex1.getLastPos(ligneC,ColonneC,ErrorFile);
      end;
  end;

  Ulex1.free;

  if BadUnitError<>'' then
  begin
    ligneC:= BadUnitLine;
    ColonneC:= BadUnitCol;
    ErrorFile:=BadUnitFile;

    stError:=  BadUnitError +crlf+
              'Compiler error  in '+ErrorFile +crlf+
              'line '+Istr(ligneC)+'  column '+Istr(ColonneC);
    stError:= 'Compiler error : ' + BadUnitError ;
    if ErrorFile<>'' then stError:= stError+' in '+ErrorFile;
    stError:=stError+  ' column '+Istr(colonneC);
  end
  else
  if ErrComp<>0 then
  begin
    stError:= 'Compiler error : ' + getCompilerString(errComp) ;
    if ErrorFile<>'' then stError:= stError+' in '+ErrorFile;
    stError:=stError+  ' column '+Istr(colonneC);
  end;


end;


function  Tcompil.getCompilerString(err:integer):AnsiString;
const
  expec=' expected';
  expr=' expression ';
  ref='Reference ';
begin
  result:='';
  case Err of

    E_generic: result:=GenericError;

    E_IdentificateurTropLong:
      result:='Identifier too long';
    E_NombreReel:
      result:='Real number out of range';
    E_CaractereInconnu:
      result:='Unknown character';
    E_Chaine:
      result:='shortString too long';
    E_includeFile: result:='Include file not found';

    E_baseLex+ord(croOu):
      result:='['+expec;
    E_baseLex+ord(crofer):
      result:=']'+expec;
    E_baseLex+ord(parOu):
      result:='('+expec;
    E_baseLex+ord(parFer):
      result:=')'+expec;
    E_baseLex+ord(virgule):
      result:=','+expec;
    E_baseLex+ord(PointVirgule):
      result:=';'+expec;
    E_baseLex+ord(Egal):
      result:='='+expec;
    E_baseLex+ord(DeuxPoint):
      result:='='+expec;
    E_baseLex+ord(MotNouveau):
      result:='Identifier'+expec;
    E_baseLex+ord(motThen):
      result:='THEN'+expec;
    E_baseLex+ord(motDO):
      result:='DO'+expec;
    E_baseLex+ord(motTO):
      result:='TO'+expec;
    E_baseLex+ord(motBEGIN):
      result:='BEGIN'+expec;
    E_baseLex+ord(nbi):
      result:='integer value'+expec;

    E_baseTypeSouhaite+ord(nbSmall),E_baseTypeSouhaite+ord(nbLong):
      result:='integer'+Expr+expec;
    E_baseTypeSouhaite+ord(nbExtended):
      result:='Real or integer'+expr+expec;


    E_baseTypeSouhaite+ord(nbBoole):
      result:='Boolean'+expr+expec;
    E_baseTypeSouhaite+ord(nbChar):
      result:='char'+Expr+expec;

    E_baseTypeSouhaite+ord(nbChaine):
      result:='shortString'+Expr+expec;

    E_baseReference+ord(nbSmall):
      result:='integer'+ref+expec;
    E_baseReference+ord(nblong):
      result:='Longint'+ref+expec;
    E_baseReference+ord(nbExtended):
      result:='Real'+ref+expec;

    E_baseReference+ord(nbBoole):
      result:='Boolean'+Ref+expec;
    E_baseReference+ord(nbChar):
      result:='Char'+Ref+expec;

    E_baseReference+ord(nbChaine):
      result:='AnsiString'+Ref+expec;

    E_baseReference+ord(refSmall):
      result:='integer'+ref+expec;
    E_baseReference+ord(reflong):
      result:='Longint'+ref+expec;
    E_baseReference+ord(refExtended):
      result:='Real'+ref+expec;


    E_baseReference+ord(refBoole):
      result:='Boolean'+Ref+expec;
    E_baseReference+ord(refChaine):
      result:='AnsiString'+Ref+expec;

    E_baseReference+ord(refObject):
      result:='Object'+Ref+expec;

    E_TypeOperandes:
      result:='Operand types do not match operator';
    E_tailleTampon:
      result:='Code segment too large';
    E_traceInconnue:
      result:='Trace does not exist';
    E_objet:
      result:='Identifier'+expec;
    E_operandeEntierOuBoolean:
      result:='integer or boolean operand'+ expec;
    E_TraceNonAffectable:
      result:='Trace cannot be affected';
    E_expressionBooleenne:
      result:='Boolean'+Expr+expec;
    E_variableEntiere:
      result:='Integer variable'+expec;
    E_expressionEntiere:
      result:='Integer expression'+expec;
    E_Instruction:
      result:='Instruction'+expec;
    E_instructionSimple:
      result:='Simple instruction'+expec;
    E_tamponSymbole:
      result:='Too many symbols';
    E_constante:
      result:='Constant'+expec;
    E_longueurDeChaine:
      result:='AnsiString length too long';
    E_NomDeType:
      result:='Type name'+expec;
    E_blocTraitementExiste:
      result:='Process block already exists';
    E_blocInitExiste:
      result:='InitProcess block already exists';
    E_blocFinExiste:
      result:='EndProcess block already exists';
    E_NbProgram:
      result:='Too many programs';
    E_LongueurNomProgram:
      result:='Program name too long';
    E_bloc:
      result:='Block header'+expec;
    E_nomDeTypeAttendu:
      result:='Type name'+expec;
    E_referenceVariable:
      result:='Variable'+expec;

    E_traceNonManipulable:
      result:='Operand cannot be a trace';
    E_directive:
      result:='Unknown Directive';
    E_nomProgram:
      result:='Illegal program name';

    E_blocInit0Existe:
      result:='InitProcess0 block already exists';

    E_segmentDS:
      result:='Data segment too large';
    E_indiceTableau:
      result:='Lower bound greater than upper bound';
    E_methodeAttendue:
      result:='Method expected';

    E_nomUnite:
      result:='Bad unit name';
    E_ProcNonConforme:
      result:='Implementation doesn''t match declaration';
    E_UnitNotLoaded:
      result:='Unit not loaded';

    E_typeDef:
      result:='Type definition expected';

    E_simpleVariable:
      result:='Simple variable expected';
    E_fieldExpected:
      result:='Field expected';
    E_noObjField:
      result:='Field type cannot be an object type';
    E_ObjOrDef:
      result:='Object or Record expected';
  end;
end;




procedure Tcompil.BuildExtraStError;
begin
{
  stError:= 'Compiler error : ' + getCompilerString(errComp) ;
  if ErrorFile<>'' then stError:= stError+' in '+extractFileName(ErrorFile);
  stError:=stError+  ' column '+Istr(colonneC);
}
end;

procedure Tcompil.DisplayErrorMessage;
begin
  MessageDlg(stError, mtInformation,[mbOk], 0);
end;



procedure Tcompil.compilerPg(var stError1:AnsiString;var lig,col:integer;var errFile:AnsiString;Fbuild:boolean; Pcode:pointer; Pdata:pointer; var Pend:pointer);
begin
  BuildMode:=Fbuild;
  ExtraMode:=(Pdata<>nil);

  if extraMode then
  begin
    compilerPg1Extra(Pcode,Pdata);
    Pend:=Plex;
    if ErrComp>0 then BuildExtraStError;
  end
  else
  begin
    OpenBox;
    compilerPg1;
    CloseBox;
    if (ErrComp>0) and (BadUnitError='') then DisplayErrorMessage;
  end;

  StError1:=stError;
  lig:=ligneC;
  col:=colonneC;
  errFile:=errorFile;
end;









procedure Tcompil.OpenBox;
begin
  if not assigned(ownerForm) then exit;

  if not assigned(compilBox) then compilBox:=TcompilBox.create(ownerform);

  with CompilBox do
  begin
    caption:=ownerName;
    panel1.caption:='Compiling';

    progressbar1.max:=stList.posMax;
    progressbar1.position:=0;

    show;
    update;
  end;
end;

procedure Tcompil.CloseBox;
begin
  if assigned(compilBox) then CompilBox.hide;
end;


function Tcompil.nbTypeObjet:integer;
begin
  nbTypeObjet:=tabproc.nbTypeObjet;
end;

function Tcompil.nomObjet(n:integer):AnsiString;
begin
  with tabProc do
    if (n>0) and (n<=nbTypeObjet)  then nomObjet:=tbObjet[n-1].stName
  else nomObjet:='';
end;

procedure Tcompil.NewSource;
begin
  pgc.compileOK:=false;
end;

function Tcompil.getNumProcHlp(st:AnsiString):integer;
begin
  result:=tabProc.getNumProcHlp(st);
end;



procedure Tcompil.ajouteImplicit(st1:AnsiString);
var
  Pdef:PdefProc;
  num:integer;
begin
  num:=tabProc.getNumProc1(st1,Pdef,-1);
  if num<0 then
    begin
      messageCentral('Erreur AjouteImplicit '+st1+' ');
      exit;
    end;

  with Plex^ do genre:=AffectVar;
  suivant;

  with Plex^ do
  begin
    Genre:=refAbs;
    dep:= ajouteWithImp(pdef^.Obresult);
  end;
  suivant;

  with Plex^ do
  begin
    genre:=fonc;
    NumFonc:=num;
    nbParF:=pdef^.nbParam;
    tpRes:=pdef^.Vresult;
  end;
  suivant;


end;

procedure Tcompil.installeImplicit;
var
  i:integer;
begin
  for i:=0 to stImplicit.count-1 do ajouteImplicit(stImplicit.strings[i]);

  Plex^.genre:=stop;
  suivant;
end;

procedure Tcompil.resetImplicit;
begin
  stImplicit.clear;
end;

procedure Tcompil.setImplicit(st:AnsiString);
begin
  stImplicit.add(st);
end;




procedure Tcompil.setFreeThisObject(p:TFreeThisObject);
begin
  tableSymbole.FreeThisObject:=p;
end;


function Tcompil.lastError: AnsiString;
begin
  result:=stError;
end;

function Tcompil.Tables: PtablesSymbole;
begin
   result:=@tableSymbole.tables;
end;

procedure Tcompil.NouveauSymbole(id: typeSymbole; st: AnsiString;lineNum:integer);
begin
  if id in [Svarloc,SconstLoc] then st:= CurrentPrefix+st;               // voir aussi Stype Sfield

  TableSymbole.Nouveau(id,st,lineNum);
end;

end.
