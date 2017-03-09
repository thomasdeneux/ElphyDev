unit Ncdef2;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses classes,sysutils,
     debug0,
     util1;



{ Il faut que les séquences nbByte..nbAnsiString               (dans typeNombre)
                            refByte..refAnsiString             (dans typeNombre)
                            motByte..motAnsiString             (dans typelex)
                            variByte..variAnsiString
                            variLocByte..variLocAnsiString
                            RefLocByte..RefLocAnsiString

  correspondent mot pour mot
  en particulier à cause de resToNb et variCompToVariR;

}
Const
  CodeExtraSize=10000;
  taillePgInit:integer=5000000;

type
  // Rem: typeNombre est très différent de typetypeG (dans util1)
  // Les types de nombre de Elphy correspondent à typetypeG  
  typeNombre=(nbNul,
              nbByte,nbShort,nbSmall,nbWord,nbLong,nbDword,nbInt64,
              nbSingle,nbdouble,nbExtended,
              nbSingleComp,nbDoubleComp,nbExtComp,
              nbVariant,nbDateTime,
              nbBoole,nbchar,nbChaine,nbANSIString,
              RefByte,RefShort,RefSmall,RefWord,RefLong,RefDword,refInt64,
              RefSingle,RefDouble,RefExtended,
              RefSingleComp,RefDoubleComp,RefExtComp,
              refVariant,refDateTime,
              RefBoole,RefChar,RefChaine,refANSIString,
              RefProcedure,
              refObject, RefVar,
              nbDef,RefDef,
              nbClass,refClass,
              nbAbs,
              refNil
              );

  Pnombre=^typeNombre;



{$J-}
{$IFDEF WIN64}
const
  tailleNombre:array[typeNombre] of byte=
             (0,
             1,1,2,2,4,4,8,
             4,8,8,               // réels extended=double
             8,16,16,             // complex
             17,8,                // variant dateTime                                    // A revoir
             1,1,4,8,

             8,8,8,8,8,8,8,
             8,8,8,
             8,8,8,
             8,8,
             8,8,8,8,
             8,
             8,8,
             8,8,
             8,8,
             0,0 );

  tailleParam:array[typeNombre] of byte=         {utilisé une fois dans symbac3}
             (0,
             4,4,4,4,4,4,8,
             4,8, 8,                  // extended=double
             8,8,8,                   // extended=double
             8,8,                     // variant dateTime
             4,4,8,8,

             8,8,8,8,8,8,8,
             8,8,8,
             8,8,8,
             8,8,
             8,8,8,8,
             8,
             8,8,
             8,8,
             8,8,
             0,0
             );

{$ELSE}

const
  tailleNombre:array[typeNombre] of byte=
             (0,
             1,1,2,2,4,4,8,
             4,8,10,
             8,16,20,
             29,8,
             1,1,4,4,

             4,4,4,4,4,4,4,
             4,4,4,
             4,4,4,
             4,4,
             4,4,4,4,
             4,
             4,4,
             4,4,
             4,4,
             0,0 );

  tailleParam:array[typeNombre] of byte=         {utilisé une fois dans symbac3}
             (0,
             4,4,4,4,4,4,8,
             4,8,12,
             8,16,20,
             32,8,
             4,4,4,4,

             4,4,4,4,4,4,4,
             4,4,4,
             4,4,4,
             4,4,
             4,4,4,4,
             4,
             4,4,
             4,4,
             4,4,
             0,0
             );

{$ENDIF}
{$J+}


{ mai 2012 : pour pouvoir introduire des nouveaux tokens, on déplace un certain nb de typelex
             vers typelex2

             Dans typelex2, on ne doit avoir que des tokens non utilisés dans le module d'exécution

}
type
  typeLex2=(
            motZero,
            motVar,
            motConst,
            motProgram,
            motFUNCTION,
            motPROCEDURE,
            motProcess,
            motInterface,
            motEndProcess,
            motInitProcess,
            motProcessCont,
            motInitProcess0,
            motImplementation,
            motInitialization,
            motProperty,
            motReadOnly,
            motDefault,
            motImplicit,
            motType,
            motRecord,
            motClass,
            motForward,
            motUnit,
            motUses
            );


{ Liste des unités lexicales }
type
  typeLex= (vid,
            moinsU,       { opérateurs unaires }
            OpNot,

            plus,         { opérateurs binaires }
            moins,
            mult,         { Un op binaire peut être testé par la }
            divis,        { condition  plus<= op <=different }
            expos,

            OpOr,
            OpAnd,
            OpXor,
            OpDiv,
            OpMod,
            Opshl,
            OpShr,

            egal,
            inf,
            infEgal,
            sup,
            supEgal,
            Different,

            parou,        { parenthèse ouverte }
            parfer,       { parenthèse fermée }
            croOu,        { crochet ouvert }
            croFer,       { crochet fermé }

            Apos,         { apostrophe }
            pointL,
            DeuxPoint,
            virgule,
            pointVirgule,
            pointDouble,
            DeuxPointEgal,

            FinFich,

            nbi,          { nombre entier }
            nbL,          { nombre entier long }
            nbr,          { nombre réel }

            chaineCar,
            ConstCar,
            directive,

            variByte,
            variShort,
            variI,
            variWord,
            variL,
            variDword,
            variInt64,

            variSingle,
            variDouble,
            variR,

            variSingleComp,
            variDoubleComp,
            variExtComp,

            variVariant,
            variDateTime,

            variB,
            variChar,
            variC,
            variANSIString,

            variLocByte,
            variLocShort,
            variLocI,
            variLocWord,
            variLocL,
            variLocDword,
            variLocInt64,

            variLocSingle,
            variLocDouble,
            variLocR,

            variLocSingleComp,
            variLocDoubleComp,
            variLocExtComp,

            variLocVariant,
            variLocDateTime,

            variLocB,
            variLocChar,
            variLocC,
            variLocANSIString,

            RefLocByte,
            RefLocShort,
            RefLocI,
            RefLocWord,
            RefLocL,
            RefLocDword,
            RefLocInt64,

            RefLocSingle,
            RefLocDouble,
            RefLocR,

            RefLocSingleComp,
            RefLocDoubleComp,
            RefLocExtComp,

            refLocVariant,
            refLocDateTime,

            RefLocB,
            RefLocChar,
            RefLocC,
            RefLocANSIString,

            VariObject,
            VariLocObject,

            csDep,


            MotNouveau,

            AffectVar,    { affectation d'une variable }

            procU,
            foncU,

            motDO,        { mots réservés }
            motIF,
            motIN,
            motOF,
            motTO,
            motEND,
            motFOR,

            motCASE,
            motELSE,
            motGOTO,
            motTHEN,


            motTRUE,
            motWITH,

            motARRAY,
            motBEGIN,

            motUNTIL,
            motWHILE,
            motFALSE,
            motDOWNTO,
            motREPEAT,


            motByte,
            motShortInt,
            motSmallInt,
            motWord,
            motLongInt,
            motLongWord,
            motInt64,

            motSingle,
            motDouble,
            motExtended,

            motSingleComp,
            motDoubleComp,
            motExtComp,

            motVariant,
            motDateTime,

            motBOOLEAN,
            motCHAR,
            motShortSTRING,
            motANSIString,

            motExit,
            motBreak,
            IfBreak,
            motOrd,
            motInc,
            motDec,

            stop,

            proced,
            fonc,
            param,
            forUp,
            forDw,

            cvIInt64,
            cvInt64I,
            cvIR,
            cvInt64R,
            cvIComp,
            cvRcomp,

            cvVariantComp,
            cvVariantR,
            cvVariantI,
            cvVariantI64,
            cvVariantSt,
            cvVariantBoole,
            cvVariantDateTime,
            cvVariantObject,

            cvCompVariant,
            cvRVariant,
            cvIVariant,
            cvI64Variant,
            cvStVariant,
            cvBooleVariant,
            cvDateTimeVariant,
            cvObjectVariant,

            cv,
            cvObj,

            StChar,

            andBI,
            orBI,

            egalI,
            egalR,
            egalComp,
            egalB,
            egalC,
            egalV,
            egalI64,

            differentI,
            differentR,
            differentComp,
            differentB,
            differentC,
            differentV,
            differentI64,

            infI,
            infR,
            infComp,
            infC,
            infV,
            infI64,

            supI,
            supR,
            supComp,
            supC,
            supV,
            supI64,

            supegalI,
            supegalR,
            supegalComp,
            supegalC,
            supegalV,
            supEgalI64,

            infegalI,
            infegalR,
            infegalComp,
            infegalC,
            infegalV,
            infEgalI64,

            tableCase,
            typeObjet,    {renvoyé par identifierMot si le mot est un nom de }
                          {type d'objet }

            TPobjectInd,  {permet de traiter les with }
            tpInd,
            refLocObject,      {paramètre de procédure }



            RefSys,

            pushI,
            popI,

            motNil,

            ordChar,
            ordBoole,

            variDef,
            variLocDef,
            refLocDef,

            variClass,
            variLocClass,
            refLocClass,

            refAbs,
            UnitN,
            Utype,
            Lex2

            );

  typeCas=record
            cte1,cte2:Integer;
            adk1,adk2:Integer;
          end;

  typeMinMax=record
               mini,maxi:integer;
             end;

  typeCase=record
             tok:byte;
             nbcase:Integer;
             depElse:Integer;
             depfinCase:Integer;
             cas:array[1..10000] of typeCas;
           end;
  PtrCase=^typeCase;

  ptUlex=^typeUlex ;

  PtypeUlex=^typeUlex;

  typeUlex=record
            case genre:typeLex of
               nbr:               (vnbr:float);
               nbi:               (vnbi:smallInt);
               nbL:               (vnbL:longint);
               constCar:          (vc:AnsiChar);
               chaineCar,
               motNouveau,
               directive:         (st:string[255]);

               proced:            (NumProced:intG;
                                   nbParP:byte);
               Fonc:              (NumFonc:intG;
                                   nbParF:byte;
                                   tpRes:typeNombre;);
               param:             (tpParam:typeNombre);
               motGOTO,IfBreak:   (Adresse:Integer);
               forUp,ForDw,motCase:(depFin:integer);

               variI,variL,variByte,variShort,variWord,variDword,variInt64,
               variR,variSingle,variDouble,
               variSingleComp,variDoubleComp,variExtComp,
               variB,variANSIstring:
                                  (adV:intG;numUnitvar:byte);
               variC:             (adVc:intG;numUnitvar1:byte;
                                   longC:byte);

               VariObject:        (adOb:intG;numUnitOb:byte;Vob:byte);
               { A l'exécution, Vob n'est jamais utilisé }

               variLocI,variLocL,variLocByte,variLocShort,variLocWord,variLocDword,variLocInt64,
               variLocR,variLocSingle,variLocDouble,
               variLocSingleComp,variLocDoubleComp,variLocExtComp,
               variLocB,refAbs,
               variLocANSIstring: (dep:integer);

               variLocC:          (dep1:integer;longCloc:byte);

               RefLocI,RefLocL,RefLocByte,RefLocShort,RefLocWord,RefLocDword,RefLocInt64,
               RefLocR,RefLocSingle,RefLocDouble,
               RefLocSingleComp,RefLocDoubleComp,RefLocExtComp,
               RefLocB,refLocANSIstring:
                                  (dep2:integer);
               RefLocC:           (dep3:integer;longCloc1:byte);

               refLocObject,VariLocObject: (dep4:integer;VobLoc:byte);

               procU:             (adU:intG;nbParU,numUnitProc:byte);
               foncU:             (adU1:intG;nbParU1,numUnitProc1:byte;
                                   tpRes1:typeNombre);
               csDep:             (adU2:intG;numUnitProc2:byte);

               tableCase:         (nbcase:Integer;
                                   depElse:Integer;
                                   depfinCase:Integer
                                   {cas:array[1..10000] of typeCas});

               TPobjectInd:       (depTPO:integer);         {déplacement dans CS}
               tpInd:             (depInd:integer;tpInd1:typeNombre;szInd:integer);
               refSys:            (adSys:pointer;tpSys:typeNombre;szSys:integer);

               andBI,orBI:        (depLog:integer);
               UnitN:             (NumU:integer);

               cv:                (CVtp:typeNombre;CVdep,CVsz:integer);
               cvObj:             (CVtp1:typeNombre;CVdep1:integer;cvO:byte);

               variDef:           (sz: integer; adDef:intG;numUnitDef:byte);     // 8 décembre 2015 : on peut confondre sz et sz1
               variLocDef,                                                       // mais attention adDef ne peut pas être confondu avec adv
               refLocDef:         (sz1: integer; DepDef:integer);

               variClass:         (adClass:intG;numUnitClass:byte;ClassDef:integer);
               variLocClass,
               refLocClass:       (DepClass:integer;ClassDef1:integer);


               motArray:          (MAnbR,MAsize:integer;
                                   MA:array[1..1000] of typeMinMax;
                                       );
               cvVariantObject:   (VObVariant:byte);

               motWhile:          (StartWhile, EndWhile: integer);
               motRepeat:         (EndRepeat, FinalRepeat: integer);

               lex2:              (Vlex2: typeLex2);
               typeObjet:         (VobTO: smallint);
            end;

  { En cas d'ajout, ne pas oublier de modifier tailleUlex  }



const
  NbiSize =      sizeof(typelex)+ sizeof(smallint);
  NbLSize =      sizeof(typelex)+ sizeof(longint);
  NbRSize =      sizeof(typelex)+ sizeof(float);

  ChaineCarSize= sizeof(typelex)+ sizeof(byte); // ajouter la longueur de chaine
  ConstCarSize=  sizeof(typelex)+ sizeof(AnsiChar);


  procedSize =  sizeof(typelex)+ sizeof(intG) +sizeof(byte);
  FoncSize =    sizeof(typelex)+ sizeof(intG) +sizeof(byte) + sizeof(typeNombre);
  paramSize =   sizeof(typelex)+ sizeof(typeNombre);
  GOTOsize =    sizeof(typelex)+ sizeof(integer);
  forSize =     sizeof(typelex)+ sizeof(integer);
  CaseSize =    sizeof(typelex)+ sizeof(integer);

  variIsize =   sizeof(typelex)+ sizeof(intG)+ sizeof(byte);
  variCsize =   sizeof(typelex)+ sizeof(intG)+ sizeof(byte)+ sizeof(byte);

  VariObjectSize = sizeof(typelex)+ sizeof(intG)+ sizeof(byte)+ sizeof(byte);


  variLocSize=     sizeof(typelex)+ sizeof(integer);
  variLocCsize =   sizeof(typelex)+ sizeof(integer)+ sizeof(byte);

  refLocSize=   sizeof(typelex)+ sizeof(integer);
  refLocCsize = sizeof(typelex)+ sizeof(integer)+ sizeof(byte);

  refLocObjectSize  = sizeof(typelex)+ sizeof(integer)+ sizeof(byte);
  VariLocObjectSize = sizeof(typelex)+ sizeof(integer)+ sizeof(byte);

  procUsize =  sizeof(typelex)+ sizeof(intG)+ sizeof(byte)+ sizeof(byte);
  foncUsize =  sizeof(typelex)+ sizeof(intG)+ sizeof(byte)+ sizeof(byte)+ sizeof(typeNombre);

  csDepSize =  sizeof(typelex)+ sizeof(intG)+sizeof(byte);

  tableCaseSize =   sizeof(typelex)+ sizeof(Integer)*3;   // sans la table elle même

  TPobjectIndSize = sizeof(typelex)+ sizeof(integer);
  tpIndSize =       sizeof(typelex)+ sizeof(integer)+sizeof(typeNombre)+sizeof(integer);
  refSysSize =      sizeof(typelex)+ sizeof(pointer) +sizeof(typeNombre) + sizeof(integer);

  andBIsize =       sizeof(typelex)+ sizeof(integer);
  orBIsize =        sizeof(typelex)+ sizeof(integer);

  UnitNsize =       sizeof(typelex)+ sizeof(integer);

  cvSize =         sizeof(typelex)+ sizeof(typeNombre)+sizeof(integer)+sizeof(integer);
  cvObjSize =      sizeof(typelex)+ sizeof(typeNombre) +sizeof(integer)+ sizeof(byte);

  variDefSize =    sizeof(typelex)+ sizeof(intG) +sizeof(integer)+sizeof(byte);
  variLocDefSize = sizeof(typelex)+ sizeof(integer) + sizeof(integer);
  refLocDefSize =  sizeof(typelex)+ sizeof(integer) + sizeof(integer);

  variClassSize =    sizeof(typelex)+ sizeof(intG) + sizeof(byte) +sizeof(integer);
  variLocClassSize = sizeof(typelex)+ sizeof(integer) +sizeof(integer);


  motArraySize = sizeof(typelex)+ sizeof(integer)*2; // sans le tableau des indices

  cvVariantObjectSize = sizeof(typelex)+ sizeof(byte);

  refAbsSize =   sizeof(typelex)+ sizeof(integer);

  WhileSize =    sizeof(typelex)+ sizeof(integer)*2;
  RepeatSize =    sizeof(typelex)+ sizeof(integer)*2;

{$J-}
const
  UlexGlobales=[variByte..variAnsiString,variobject,variDef];

  (* Not used
  tailleVar:array[variByte..refLocAnsiString] of smallInt=
                (1,1,2,2,4,4,8,4,8,10,8,16,20,15,8,1,1,0,4,
                 1,1,2,2,4,4,8,4,8,10,8,16,20,15,8,1,1,0,4,
                 1,1,2,2,4,4,8,4,8,10,8,16,20,15,8,1,1,0,4);
  *)
  TypeVar:array[variByte..refLocAnsiString] of typeNombre=
                (nbByte,nbShort,nbSmall,nbWord,nbLOng,nbDWord,nbInt64,
                 nbSingle,nbDouble,nbExtended,
                 nbSingleComp,nbDoubleComp,nbExtComp,
                 nbVariant,nbDateTime,
                 nbBoole,nbChar,nbChaine,nbANSIString,
                 nbByte,nbShort,nbSmall,nbWord,nbLOng,nbDWord,nbInt64,
                 nbSingle,nbDouble,nbExtended,
                 nbSingleComp,nbDoubleComp,nbExtComp,
                 nbVariant,nbDateTime,
                 nbBoole,nbChar,nbChaine,nbANSIString,
                 nbByte,nbShort,nbSmall,nbWord,nbLOng,nbDWord,nbInt64,
                 nbSingle,nbDouble,nbExtended,
                 nbSingleComp,nbDoubleComp,nbExtComp,
                 nbVariant,nbDateTime,
                 nbBoole,nbChar,nbChaine,nbAnsiString);

  tpNumName:array[typeNombre] of string[13]=(
              'nbNul',
              'nbByte','nbShort','nbSmall','nbWord','nbLong','nbDword','nbInt64',
              'nbSingle','nbdouble','nbExtended',
              'nbSingleComp','nbDoubleComp','nbExtComp',
              'nbVariant','nbDateTime',
              'nbBoole','nbchar','nbChaine','nbANSIString',
              'RefByte','RefShort','RefSmall','RefWord','RefLong','RefDword','RefInt64',
              'RefSingle','RefDouble','RefExtended',
              'RefSingleComp','RefDoubleComp','RefExtComp',
              'refVariant','refDateTime',
              'RefBoole','RefChar','RefChaine','RefANSIString',
              'RefProcedure',
              'refObject','RefVar',
              'nbDef', 'RefDef',
              'nbClass','RefClass',
              'nbAbs', 'Nil'
              );

  tpNumUserName:array[typeNombre] of string[13]=(
              'Nul',
              'Byte','Shortint','Smallint','Word','Longint','longword','Int64',
              'Single','double','Extended',
              'SingleComp','DoubleComp','ExtComp',
              'Variant','TDateTime',
              'Boolean','char','Shorstring','String',
              'Byte','Shortint','Smallint','Word','Longint','longword','Int64',
              'Single','double','Extended',
              'SingleComp','DoubleComp','ExtComp',
              'Variant','TDateTime',
              'Boolean','char','Shorstring','String',
              'Procedure',
              'Object','Var',
              'Def', 'Def',
              'Class','Class',
              'Abs', 'Nil'
              );
{$J+}


var
  EXEon:boolean;
  FinExeDum: boolean;
  finExeU:Pboolean;           { finExeU est positionné par Shift-Escape
                                Novembre 2012: finExeU devient un pointeur sur un champ de TPG2
                                Par défaut, on fait pointer vers FinExeDum qui est false;
                               }
  finExe:boolean;              { finExe est positionné par Shift-Escape
                                                       par Halt ou exit (dans le corps du Pg)
                                                       par la fin du  bloc programme
                               }
  errorExe:integer;
  AdresseErreurExe:pointer;


var
  E_parametre             :integer;
  E_mem                   :integer;
  E_NumFichier            :integer;
  E_lecture               :integer;
  E_FichierNonConforme    :integer;
  E_FichierNonOuvert      :integer;
  E_TamponMoyenneNonAlloue:integer;
  E_IndiceTableau         :integer;
  E_pile                  :integer;
  E_fenetre               :integer;
  E_FichierDejaOuvert     :integer;
  E_NomDeFichierIncorrect :integer;
  E_fichierInexistant     :integer;
  E_ChargementImpossible  :integer;
  E_tableauNonAlloue      :integer;
  E_allocationPile        :integer;
  E_memoireNonAllouee     :integer;
  E_allouerFit            :integer;
  E_menu                  :integer;
  E_popMoy                :integer;
  E_modeleFit             :integer;
  E_DACnonAlloue          :integer;
  E_MemDynamique          :integer;
  E_ecriture              :integer;
  E_periodeAcq            :integer;
  E_typeAcquis1           :integer;
  E_typeFichier           :integer;
  E_refTab                :integer;


  E_Affmat                :integer;
  E_objetInexistant       :integer;
  E_PasDeFichierEvt       :integer;
  E_typeObjetAc1          :integer;
  E_typeObjetIncompatible :integer;

  E_bufPostSeq            :integer;
  E_fileInfo              :integer;
  E_phaseExe              :integer;
  E_ModifFichier          :integer;

  E_pasDeFichierData      :integer;

  E_create                :integer;
  E_indiceChaine          :integer;

  E_invalidObjectName     :integer;

var
  errorOut:Integer;

var
  testerFinExe:function:boolean;


var
  GenericExeError:AnsiString;


function testerFinExe1:boolean;

procedure SortieErreur(num:Integer);overLoad;
procedure SortieErreur(st:AnsiString);overLoad;


function tailleUlex(var U:typeUlex):integer;
function UlexSuivant(p:ptUlex):ptUlex;

procedure controleParametre(x,x1,x2:float);

procedure controleParam(x,x1,x2:float;var error:integer);overLoad;
procedure controleParam(x,x1,x2:float;st:AnsiString);overLoad;


function resToNb(motRes:typeLex):typeNombre;
function NbToRes(tp:typeNombre):typelex;

function IsVariable(tp:typeLex):boolean;
function variCompToVariR(tp:typeLex):typeLex;

function Nomlex(tp:typeLex):AnsiString;

function tpnbToString(tp:typeNombre;p:pointer;nbdeci:integer):AnsiString;

function getIntegerWithTp(var x;tp:typeNombre):integer;
procedure setIntegerWithTp(var x;tp:typeNombre;w:integer);



IMPLEMENTATION

uses MotRes1;


type
  Eexe=class(exception);

procedure SortieErreur(num:Integer);
begin
  if not ExeON then exit;
  errorOut:=num;

  raise Eexe.Create('Exe Error');
end;

procedure SortieErreur(st:AnsiString);
begin
  GenericExeError:=st;
  SortieErreur(999);
end;


function tailleUlex(var U:typeUlex):integer;
  begin
    case U.genre of
       vid:                 result:=sizeof(typelex);
       nbr:                 result:= nbRsize;
       nbi:                 result:= nbiSize;
       nbL:                 result:= nbLsize;
       chaineCar,motNouveau:result:= ChaineCarSize + length(U.st);
       ConstCar:            result:= ConstCarSize;
       variByte..variChar,variAnsiString:
                            result:= variIsize;
       variC:               result:= variCsize;
       proced:              result:= procedSize; // 6;
       Fonc:                result:= FoncSize; //7;
       param:               result:= ParamSize; //2;
       forUp,forDw:         result:= forSize;//5;
       motCase:             result:= CaseSize; //5;

       motGoto,IfBreak:     result:= GotoSize;

       variLocByte..variLocChar,variLocAnsiString:
                            result:= variLocSize; //5;
       refLocByte..refLocChar,refLocAnsiString:
                            result:= variLocSize; //5;
       refLocObject,variLocObject:  result:= refLocObjectSize; //6;
       variLocC,refLocC:    result:= variLocCsize; //6;
       procU:               result:= procUsize;
       foncU:               result:= foncUsize;
       tableCase:           result:= tableCaseSize {13}+sizeof(typeCas)*U.nbcase;
       variObject:          result:= variObjectSize; //7;

       TPobjectInd:         result:= tpObjectIndSize; //5;
       tpInd:               result:= tpIndSize; //10;
       refSys:              result:= refSysSize; //10;

       andBI,orBI:          result:= andBIsize; //5;
       UnitN:               result:= unitNsize; //5;
       csDep:               result:= csDepSize; //6;

       cv:                  result:= cvSize; //10;
       cvObj:               result:= cvObjSize; //7;

       variDef:             result:= variDefSize; //10;
       variLocDef, refLocDef:
                            result:= variLocDefSize; //9;
       variClass:           result:= variClassSize; //10;
       variLocClass, refLocClass:
                            result:= variLocClassSize; //9;


       motArray:            result:= motArraySize {9}+U.MAnbr*sizeof(typeMinMax);

       refAbs:              result:= refAbsSize; //5;
       cvVariantObject:     result:= cvVariantObjectSize; //2;

       motWhile:            result:= WhileSize;  // 9;
       motRepeat:           result:= RepeatSize; // 9;
       lex2:                result:= sizeof(typelex) +  sizeof(typelex2) ;

       typeObjet:           result:= sizeof(typelex) +  sizeof(typelex) ;

       else                 result:= sizeof(typelex);
    end;
  end;


function UlexSuivant(p:ptUlex):ptUlex;
begin
  inc(intG(p),tailleUlex(p^));
  UlexSuivant:=p;
end;

procedure controleParametre(x,x1,x2:float);
begin
  if (x<x1) or (x>x2) then sortieErreur(E_parametre);
end;

procedure controleParam(x,x1,x2:float;var error:integer);
begin
  if (x<x1) or (x>x2) then sortieErreur(error);
end;

procedure controleParam(x,x1,x2:float;st:AnsiString);
begin
  if (x<x1) or (x>x2) then sortieErreur(st);
end;


function testerFinExe1:boolean;
begin
  result:= testerFinExe;
  if result then finExe:=true;
end;



{******************************************************************************}

function resToNb(motRes:typeLex):typeNombre;
begin
  result:=typeNombre(ord(nbByte)+ord(motRes)-ord(motByte));
end;

function NbToRes(tp:typeNombre):typelex;
begin
  result:=typeLex(ord(motByte)+ord(tp)-ord(nbByte));
end;


function IsVariable(tp:typeLex):boolean;
begin
  result:=(tp>=variByte) and (tp<=VariLocObject);
end;

function variCompToVariR(tp:typeLex):typeLex;
begin
  if typeVar[tp]=nbSingleComp
    then result:=typeLex(ord(tp)-4)
    else result:=typeLex(ord(tp)-3);
end;

function Nomlex(tp:typeLex):AnsiString;
  begin
    case tp of
      vid:         nomLex:='';
      moinsU:      nomLex:='!';
      OpNot:       nomLex:='NOT';

      plus:        nomLex:='+';
      moins:       nomLex:='-';
      mult:        nomLex:='*';
      divis:       nomLex:='/';
      expos:       nomLex:='^';

      OpOr:        nomLex:='OR';
      OpAnd:       nomLex:='AND';
      OpXor:       nomLex:='XOR';
      OpDiv:       nomLex:='DIV';
      OpMod:       nomLex:='MOD';
      Opshl:       nomLex:='SHL';
      OpShr:       nomLex:='SHR';

      egal:        nomLex:='=';
      inf:         nomLex:='<';
      infEgal:     nomLex:='<=';
      sup:         nomLex:='>';
      supEgal:     nomLex:='>=';
      Different:   nomLex:='<>';

      parou:       nomLex:='(';
      parfer:      nomLex:=')';
      croOu:       nomLex:='[';
      croFer:      nomLex:=']';

      Apos:        nomLex:='''';
      pointL:       nomLex:='.';
      DeuxPoint:   nomLex:=':';
      virgule:     nomLex:=',';
      pointVirgule:nomLex:=';';
      pointDouble: nomLex:='..';

      FinFich:     nomLex:='END';

      nbi:         nomLex:='NBI';
      nbL:         nomLex:='NBL';
      nbr:         nomLex:='NBR';
      constCar:    nomlex:='CAR';
      chaineCar:   nomLex:='CHAINE';

      variByte:         nomlex:='variByte';
      variShort:        nomlex:='variShort';
      variI:            nomlex:='variI';
      variWord:         nomlex:='variWord';
      variL:            nomlex:='variL';
      variDword:        nomlex:='variDword';
      variInt64:        nomlex:='variInt64';

      variSingle:       nomlex:='variSingle';
      variDouble:       nomlex:='variDouble';
      variR:            nomlex:='variR';

      variSingleComp:   nomlex:='variSingleComp';
      variDoubleComp:   nomlex:='variDoubleComp';
      variExtComp:      nomLex:='variExtComp';

      variVariant:      nomlex:='variVariant';
      variDateTime:     nomlex:='variDateTime';

      variB:            nomlex:='variB';
      variChar:         nomlex:='variChar';
      variC:            nomlex:='variC';
      variAnsiString:   nomlex:='variAnsiString';

      variLocByte:      nomlex:='variLocByte';
      variLocShort:     nomlex:='variLocShort';
      variLocI:         nomlex:='variLocI';
      variLocWord:      nomlex:='variLocWord';
      variLocL:         nomlex:='variLocL';
      variLocDword:     nomlex:='variLocDword';
      variLocInt64:     nomlex:='variLocInt64';

      variLocSingle:    nomlex:='variLocSingle';
      variLocDouble:    nomlex:='variLocDouble';
      variLocR:         nomlex:='variLocR';

      variLocSingleComp:   nomlex:='variLocSingleComp';
      variLocDoubleComp:   nomlex:='variLocDoubleComp';
      variLocExtComp:      nomlex:='variLocExtComp';

      variLocVariant:      nomlex:='variLocVariant';
      variLocDateTime:     nomlex:='variLocDateTime';

      variLocB:         nomlex:='variLocB';
      variLocChar:      nomlex:='variLocChar';
      variLocC:         nomlex:='variLocC';
      variLocAnsiString:nomlex:='variLocAnsiString';

      RefLocByte:       nomlex:='RefLocByte';
      RefLocShort:      nomlex:='RefLocShort';
      RefLocI:          nomlex:='RefLocI';
      RefLocWord:       nomlex:='RefLocWord';
      RefLocL:          nomlex:='RefLocL';
      RefLocDword:      nomlex:='RefLocDword';
      RefLocInt64:      nomlex:='RefLocInt64';

      RefLocSingle:     nomlex:='RefLocSingle';
      RefLocDouble:     nomlex:='RefLocDouble';
      RefLocR:          nomlex:='RefLocR';

      RefLocSingleComp:   nomlex:='RefLocSingleComp';
      RefLocDoubleComp:   nomlex:='RefLocDoubleComp';
      RefLocExtComp:      nomlex:='RefLocExtComp';

      refLocVariant:      nomlex:='refLocVariant';
      refLocDateTime:     nomlex:='refLocDateTime';

      RefLocB:          nomlex:='RefLocB';
      RefLocChar:       nomlex:='RefLocChar';
      RefLocC:          nomlex:='RefLocC';
      RefLocAnsiString: nomlex:='refLocAnsiString';

      variDef:          nomlex:='VariDef';
      variLocDef:       nomlex:='VariLocDef';
      RefLocDef:        nomlex:='RefLocDef';

      variClass:        nomLex:='Class';
      variLocClass:     nomLex:='Class';
      refLocClass:      nomLex:='Class';

      MotNouveau:  nomLex:='MotNouveau';

      AffectVar:   nomLex:='AffectVar';

      motDO..motDec:    nomLex:=getResName(tp,motZero);


      stop:        nomLex:='STOP';

      proced:      nomLex:='AppelProcedure';
      fonc:        nomLex:='AppelFonction';

      procU:       nomLex:='AppelProcU';
      foncU:       nomLex:='AppelFoncU';

      param:       nomLex:='Param';

      forUp:       nomLex:='ForUp';
      forDw:       nomLex:='ForDw';

      cvIInt64:    nomlex:='CvIInt64';
      cvIR:        nomLex:='CvIR';
      cvIComp:     nomLex:='CvIComp';
      cvRComp:     nomLex:='CvRComp';
      stChar:      nomlex:='StChar';


      andBI:       nomLex:='andBI';
      orBI:        nomLex:='orBI';

      egalI:       nomLex:='egalI';
      egalR:       nomLex:='egalR';
      egalB:       nomLex:='egalB';
      egalC:       nomLex:='egalC';
      egalV:       nomLex:='egalV';
      egalI64:     nomLex:='egalI64';

      differentI:  nomLex:='diffI';
      differentR:  nomLex:='diffR';
      differentB:  nomLex:='diffB';
      differentC:  nomLex:='diffC';
      differentV:  nomLex:='diffV';
      differentI64:nomLex:='diffI64';

      infI:        nomLex:='infI';
      infR:        nomLex:='infR';
      infC:        nomLex:='infC';
      infV:        nomLex:='infV';
      infI64:      nomlex:='infI64';

      supI:        nomLex:='supI';
      supR:        nomLex:='supR';
      supC:        nomLex:='supC';
      supV:        nomLex:='supV';
      supI64:      nomLex:='supI64';

      supegalI:    nomLex:='supEgalI';
      supegalR:    nomLex:='supegalR';
      supegalC:    nomLex:='supegalC';
      supegalV:    nomLex:='supegalV';
      supegalI64:    nomLex:='supEgalI64';

      infegalI:    nomLex:='infegalI';
      infegalR:    nomLex:='infegalR';
      infegalC:    nomLex:='infEgalC';
      infegalV:    nomLex:='infEgalV';
      infegalI64:  nomLex:='infegalI64';

      tableCase:   nomLex:='Tcase';
      variObject:  nomLex:='Object';
      variLocObject:
                   nomLex:='ObjectLoc';

      refLocObject:     nomLex:='refLocObject';

      TPobjectInd: nomLex:='ObjectInd';
      refAbs:      nomlex:='refAbs';

      pushI:       nomlex:='Push';
      popI:        nomlex:='Pop';

      cv:          nomlex:='CV';
      cvObj:       nomlex:='CVobj';

      motNil:      nomlex:='NIL';

      OrdBoole:    nomLex:='ORDBoole';
      OrdChar:     nomLex:='ORDChar';

      cvVariantComp:      nomlex:='cvVariantComp';
      cvVariantR:         nomlex:='cvVariantR';
      cvVariantI:         nomlex:='cvVariantI';
      cvVariantI64:       nomlex:='cvVariantI64';

      cvVariantSt:        nomlex:='cvVariantSt';
      cvVariantBoole:     nomlex:='cvVariantBool';
      cvVariantDateTime:  nomlex:='cvVariantDateTime';
      cvVariantObject:    nomlex:='cvVariantObject';

      cvCompVariant:      nomlex:='cvCompVariant';
      cvRVariant:         nomlex:='cvRVariant';
      cvIVariant:         nomlex:='cvIVariant';
      cvI64Variant:       nomlex:='cvI64Variant';
      cvStVariant:        nomlex:='cvStVariant';
      cvBooleVariant:     nomlex:='cvBoolVariant';
      cvDateTimeVariant:  nomlex:='cvDateTimeVariant';
      cvObjectVariant:    nomlex:='cvObjectVariant';

      tpInd: nomlex:='tpInd';

      else         nomLex:='?'+Istr(ord(tp));
    end;
  end;

function tpnbToString(tp:typeNombre;p:pointer;nbdeci:integer):AnsiString;
begin
  case tp of
    nbByte:         result:=Istr(Pbyte(p)^);
    nbShort:        result:=Istr(Pshort(p)^);
    nbSmall:        result:=Istr(Psmallint(p)^);
    nbWord:         result:=Istr(Pword(p)^);
    nbLong:         result:=Istr(Plongint(p)^);
    nbDword:        result:=Istr(Plongword(p)^);
    nbInt64:        result:=Istr(Pint64(p)^);
    nbSingle:       result:=Estr(Psingle(p)^,nbdeci);
    nbdouble:       result:=Estr(Pdouble(p)^,nbdeci);
    nbExtended:     result:=Estr(Pextended(p)^,nbdeci);
    nbSingleComp:   result:=Estr(PsingleComp(p)^.x,nbdeci)+' '+Estr(PsingleComp(p)^.x,nbdeci);
    nbDoubleComp:   result:=Estr(PdoubleComp(p)^.x,nbdeci)+' '+Estr(PdoubleComp(p)^.x,nbdeci);
    nbExtComp:      result:=Estr(PFloatComp(p)^.x,nbdeci)+' '+Estr(PFloatComp(p)^.x,nbdeci);
    nbBoole:        result:=Bstr(Pboolean(p)^);
    nbchar:         result:=AnsiChar(p^);
    nbChaine:       result:=PshortString(p)^;
  end
end;

function getIntegerWithTp(var x;tp:typeNombre):integer;
begin
  case tp of
    nbByte:      result:=byte(x);
    nbShort:     result:=shortInt(x);
    nbSmall:     result:=smallint(x);
    nbWord:      result:=Word(x);
    nbLong:      result:=LongInt(x);
  end;
end;

procedure setIntegerWithTp(var x;tp:typeNombre;w:integer);
begin
  case tp of
    nbByte:      byte(x):=w;
    nbShort:     shortInt(x):=w;
    nbSmall:     smallint(x):=w;
    nbWord:      Word(x):=w;
    nbLong:      LongInt(x):=w;
  end;
end;


initialization
FinExeU:= @FinExeDum;


end.
