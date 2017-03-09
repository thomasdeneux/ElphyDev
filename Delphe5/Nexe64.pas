unit Nexe64;

{Version uniquement Win64 }

INTERFACE

uses classes,sysutils,
     util1,Ncdef2,debug0,Dgraphic,stmObj;


var
  StackSeg:pointer;
  stackSize:integer;

type
  TstartProc=procedure(var n1,n2,n3:integer) of object;
  TterminateProc=procedure (n1,n2,n3:integer) of object;

  TElphyDebugPg= procedure (p: PtUlex; NumP,adP:integer) of object;
var
  RefObjectStack:Tlist;
  RefObjectTypes:Tlist;

{RefObjectStack contient la liste des variables objets passées comme paramètres à la procédure
 utilisateur active.
 RefObjectTypes contient leurs types.

 CreatePgObject utilise ces listes pour vérifier que le constructeur utilisé correspond bien
 au type de l'objet.

}
procedure AllocateStack(size:integer);
function executerProg(cs,ds:pointer;Prog:pointer;var error,ad:integer;var finExeU1: boolean;
                       adp:PtabPointer1;stp:TstartProc;trm:TterminateProc;LocStrings,LocVariants:Tlist;
                       ElphyDebug: TElphyDebugPg): boolean;

function getStdError:AnsiString;
function getCurrentExeAd:integer;


var
  regSP:integer;
  regBP:integer;

  regSS:intG;
  regCS:intG;
  regDS:intG;


IMPLEMENTATION


function ptrG(base,offset:intG):pointer;
  begin
    ptrG:=pointer(base+offset);
  end;


type
  { Tstack }
  Tstack_item=(Tsi_struct,Tsi_ansi,Tsi_variant,Tsi_Seg,Tsi_AdAnsi);

  Tstack= object
            mem:pointer;
            pvalue:array of pointer;
            ptype: array of Tstack_item;

            TotSize:integer;
            Psize:integer;
            NumP:integer;

            procedure init(sz:integer);
            procedure reinit;
            function allocmem(sz:integer; const Atype:Tstack_item=Tsi_struct):pointer;
            function getPos:integer;
            function StoreStruct(p:pointer; sz:integer): pointer;
            function StoreAnsiString(st:AnsiString): pointer;
            function StoreAdAnsiString(p:pointer): pointer;

            function storeVariant(gv:TGvariant): pointer;
            procedure Clean(Apos:integer);
          end;
var
  stack0: Tstack;

{ Tstack }

procedure Tstack.init(sz: integer);
begin
  TotSize:=sz;
  getmem(mem,sz);

  reinit;
end;

procedure Tstack.reinit;
begin
  setLength(pvalue,1000);
  setLength(ptype,1000);

  Psize:=0;
  NumP:=0;
end;

function Tstack.Allocmem(sz: integer; Const Atype:Tstack_item=Tsi_struct ): pointer;
begin
  if Psize+sz<TotSize then
  begin
    result:=ptrG(intG(mem),Psize);

    pvalue[NumP]:=result;
    ptype[NumP]:=Atype;

    inc(Psize,sz);
    inc(NumP);
  end
  else sortieErreur('Stack G overflow');
end;

function Tstack.getPos: integer;
begin
  result:=NumP;
end;

function Tstack.StoreStruct(p: pointer; sz: integer): pointer;
begin
  result:=allocmem(sz);
  move(p^,result^,sz);
end;

function Tstack.StoreAnsiString(st: AnsiString): pointer;
begin
  result:=allocmem(sizeof(pointer),tsi_ansi);
  fillchar(result^,sizeof(pointer),0);
  Pansistring(result)^:=st;
end;

function Tstack.StoreAdAnsiString(p:pointer): pointer;
begin
  result:=allocmem(sizeof(pointer),tsi_Adansi);
  Ppointer(result)^:=p;
end;


function Tstack.storeVariant(gv: TGvariant): pointer;
begin
  result:=allocmem(sizeof(gv),tsi_variant);
  fillchar(result^,sizeof(gv),0);
  PGvariant(result)^:=gv;

  PGvariant(result)^.AdjustObject;
end;

procedure Tstack.Clean(Apos: integer);
var
  i:integer;
begin
  if Apos<Nump then
  begin
    for i:=Apos to NumP-1 do
    case ptype[i] of
      Tsi_ansi:     PansiString(pvalue[i])^:='';
      Tsi_variant:  PGvariant(pvalue[i])^.finalize;
      Tsi_AdAnsi:   PansiString(pvalue[i]^)^:='';
    end;
    NumP:=Apos;

    Psize:=intG(pvalue[NumP])-intG(mem);    {Le suivant moins le dÃ©but }
  end;
end;

var
  Plex: PtUlex;         // pointeur d'exécution
  FlagExit: boolean;    // mot Exit rencontré dans le code
  FlagBreak: boolean;   // mot break rencontré dans le code
  procUON: integer;     // incrémenté quand on entre dans une procédure, décrémenté en sortie
  CurrentProc: integer; // adresse de la procédure courante


var
  errorEXEMsg:string[80];

  adProc:PtabPointer1;

  terminateProc:TterminateProc;
  StartProc:TstartProc;
  LocalStrings:Tlist;
  LocalVariants:Tlist;
  ElphyDebugPg: TElphyDebugPg;


function evaluerI:longint;forward;
function evaluerInt64:int64;forward;

function evaluerR:float;forward;
function evaluerComp:TfloatComp;forward;
function evaluerB:boolean;forward;
function evaluerC:AnsiString;forward;
function evaluerChar:Ansichar;forward;

procedure evaluerVariant(var result:TGvariant);forward;
function evaluerDateTime:TdateTime;forward;

function evaluerDepArray:integer;forward;

function evaluerAd(var typ:typeNombre):pointer;overload; forward;
function evaluerAd(var typ:typeNombre; var len:integer):pointer;overload; forward;



procedure executerInstruction;forward;




type
  Tparam1=record
            IsReal: int64;
          case integer of
            1:(ii:int64);
            2:(dd:double);
            3:(ss: single);
          end;

  Tparam64 = array[1..100] of Tparam1;
  Pparam64=  ^Tparam64;

function CallAsm64(ad:pointer;nb:int64;var param:Tparam64): pointer;assembler;
var
  ad1:pointer;
  nb1:int64;
  param0,param1:pointer;
  stackInc: int64;
  cnt1: int64;
  rbx1: int64;
asm

       mov ad1,  ad       // ad
       mov nb1, nb        // nb
       mov param1,param   // param
       mov param0,param   // param

       mov  rbx1,rbx

       mov  rax, nb1
       add  rax, 1        // un mot de plus (?)
       test eax, 1        // si impair, ajouter 1
       jz   @@0
       inc  rax
  @@0: shl  rax,3         // multiplier par 8

       mov  StackInc, rax

       sub  rsp, StackInc // On retranche un multiple de 16
                          // La pile est déjà  alignée après le prologue
       cmp  nb1,0
       jz   @@1

       mov rbx,param1
       cmp [rbx],0       // Test type de Param1
       jnz  @@p1a
       add param1,8
       mov rbx, param1
       mov rcx, [rbx]     // param1 dans rcx
       jmp @@p1b
  @@p1a:
       add param1,8
       mov rbx, param1
       movq xmm0, double[rbx]   // param1 dans xmm0
  @@p1b:

       dec  nb1
       add  param1,8

       cmp  nb1,0
       jz   @@1

       mov rbx,param1
       cmp [rbx],0        // Test type de Param2
       jnz  @@p2a
       add param1,8
       mov rbx, param1
       mov rdx, [rbx]           // param2 dans rdx
       jmp  @@p2b
  @@p2a:
       add param1,8
       mov rbx, param1
       movq xmm1, double[rbx]   // param2 dans xmm1
  @@p2b:

       dec  nb1
       add  param1,8

       cmp  nb1,0
       jz   @@1

       mov rbx,param1
       cmp [rbx],0          // Test type de Param3
       jnz  @@p3a
       add param1,8
       mov rbx, param1
       mov r8, [rbx]            // param3 dans r8
       jmp  @@p3b
  @@p3a:
       add param1,8
       mov rbx, param1
       movq xmm2, double[rbx]   // param3 dans xmm2
  @@p3b:

       dec  nb1
       add  param1,8

       cmp  nb1,0
       jz   @@1

       mov rbx,param1
       cmp [rbx],0        // Test type de Param4
       jnz  @@p4a
       add param1,8
       mov rbx, param1
       mov r9, [rbx]      // param4 dans r9
       jmp  @@p4b
  @@p4a:
       add param1,8
       mov rbx, param1
       movq xmm3, double[rbx]   // param4 dans xmm3
  @@p4b:

       dec  nb1
       add  param1,16     // 16 pour sauter le type de param

       mov  cnt1,20h      // les autres params sont dans la pile

  @@2: cmp  nb1,0
       jz   @@1

       mov  rbx,param1
       mov  rax,[rbx]
       mov  rbx,cnt1

       mov  rsp[rbx], eax       // mov rsp[rbx],rax ne marche pas !!!!
       shr  rax,32
       mov  rsp[rbx+4], eax

       dec  nb1
       add  cnt1, 8
       add  param1,16
       jmp  @@2

  @@1:
       call ad1

//       mov  rbx,param0
//       cmp  [rbx],0
//       jz   @@fin

       mov  rbx,param0
       movsd double[rbx+8], xmm0

  @@fin:
       mov  rbx, stackInc       // remettre la pile dans le bon état
       add  rsp, rbx
       mov  rbx, rbx1


end;




procedure empilerAppel(var t;taille:integer);
  begin
    if taille>regSP then sortieErreur(E_pile);
    dec(regSP,taille);
    move(t,ptrG(regSS,regSP)^,taille);
  end;

procedure empilerStruct(var t; sz:integer);
var
  p:pointer;
begin
  if 8>regSP then sortieErreur(E_pile);
  dec(regSP,8);

  p:=stack0.StoreStruct(@t,sz);            { Allouer sz octets dans stack0 et y ranger t }
  move(p ,ptrG(regSS,regSP)^,8);           { ranger l'adresse du bloc dans la pile }

end;


procedure empilerAnsiString(st:AnsiString);   { appelée uniquement par les procédures utilisateur }
var
  p:pointer;
begin
  if 8>regSP then sortieErreur(E_pile);
  dec(regSP,8);

  p:=ptrG(regSS,regSP);
  Ppointer(p)^:=nil;
  PansiString(p)^:=st;               { copie de st dans une variable chaine }
  stack0.StoreAdAnsiString(p);       { ranger l'adresse de la variable chaine }
end;


procedure empilerVariant(var vr:TGvariant);
var
  p:pointer;
begin
  p:=Stack0.storeVariant(vr);
  move(p,ptrG(regSS,regSP)^,8);           { ranger l'adresse du bloc dans la pile }
end;

function empilerStackSeg(nbParam: integer):Pparam64;
begin
  result:=Stack0.allocmem(nbParam*sizeof(Tparam1),tsi_seg);
  fillchar(result^,nbParam*sizeof(Tparam1),0);
end;



procedure nettoyerPileAppel(taille, StackPos:integer);
var
  i:integer;
begin
  inc(regSP,taille);
  stack0.Clean(StackPos);
end;




function evaluerDepArray:integer;
var
  i,n,nb:Integer;
  dep:integer;
  PA:ptUlex;
begin
  dep:=0;
  PA:=Plex;
  inc(intG(Plex),MotArraySize+Plex^.MAnbr*sizeof(typeMinMax));        { motArray }

  for i:=1 to PA^.MAnbR do
    begin
      n:=evaluerI;           { indice }
      with PA^.MA[i] do
      begin
        if (n<mini) or (n>maxi) then sortieErreur(E_indiceTableau);
        dep:=dep*(maxi-mini+1)+n-mini;
      end;
    end;
  evaluerDepArray:=dep*PA^.MAsize;;
end;


procedure empilerParametres(nbParam:smallInt;var tailleP, StackPos:integer);
   forward;

procedure empilerParam64(nbParam:Integer;RetPointer: pointer;var StackPos:integer;var param64:Pparam64;var nb64: integer);forward;

function evaluerFoncAd:pointer;
  var
    adresseV:pointer;
    nbparam:integer;
    nb64:integer;
    Apos:integer;
    param64:Pparam64;
  begin
    nbParam:=Plex^.nbParP;
    adresseV:=adProc^[Plex^.NumProced];

    inc(intG(Plex),FoncSize);

    empilerParam64(nbParam,nil,Apos,param64,nb64);
    result:= CallAsm64(adresseV,nb64, param64^);
    stack0.clean(Apos);
  end;


function evaluerDepChar:pointer;
var
  pst:Pshortstring;
  ind:integer;
  typ:typeNombre;
begin
  inc(intG(Plex));
  pst:=evaluerAd(typ);
  ind:=evaluerI;
  if (ind<1) or (ind>length(pst^)) then sortieErreur(E_indiceChaine);
  result:=@pst^[ind];
end;

var
  DefSize:integer;
  varNil:pointer;

{********************************** EVALUERAD *****************************************}

type
  TadFunction= function(var typ:typeNombre;var len:integer):pointer;
var
  tbEvaluerAd: array[typelex] of TadFunction;


function EvaluerAdStChar(var typ:typeNombre;var len:integer):pointer;
begin
  result:=evaluerDepChar;
  typ:=nbChar;
end;

function EvaluerAdvariByte(var typ:typeNombre;var len:integer): pointer;
var
  p:ptUlex;
begin
  p:=Plex;
  typ:=typeVar[Plex^.genre];
  result:=ptrG(regDS,Plex^.adv);
  inc(intG(Plex),variIsize);
  if Plex^.genre=motArray then
    inc(intG(result),evaluerDepArray);

  if (Plex^.genre=CV) and (p^.genre>=variSingleComp) and (p^.genre<=variExtComp) then
  begin
    inc(intG(result),Plex^.CVdep);
    typ:=Plex^.CVtp;
    inc(intG(Plex),CVsize);
  end;
end;

function EvaluerAdvariLocByte(var typ:typeNombre;var len:integer): pointer;
var
  p:ptUlex;
begin
  p:=Plex;
  typ:=typeVar[Plex^.genre];
  result:=ptrG(regSS,regBP+Plex^.dep);
  inc(intG(Plex), VariLocSize);
  if Plex^.genre=motArray then
    inc(intG(result),evaluerDepArray);
  if (Plex^.genre=CV) and (p^.genre>=variLocSingleComp) and (p^.genre<=variLocExtComp) then
  begin
    inc(intG(result),Plex^.CVdep);
    typ:=Plex^.CVtp;
    inc(intG(Plex),CVsize);
  end;
end;

function EvaluerAdrefLocByte(var typ:typeNombre;var len:integer): pointer;
var
  p:ptUlex;
begin
  p:=Plex;
  typ:=typeVar[Plex^.genre];
  result:=pointer(ptrG(regSS,regBP+Plex^.dep)^);
  inc(intG(Plex),refLocSize);
  if Plex^.genre=motArray then
    inc(intG(result),evaluerDepArray);
  if (Plex^.genre=CV) and (p^.genre>=refLocSingleComp) and (p^.genre<=refLocExtComp) then
  begin
    inc(intG(result),Plex^.CVdep);
    typ:=Plex^.CVtp;
    inc(intG(Plex),CVsize);
  end;
 end;

function EvaluerAdVariC(var typ:typeNombre;var len:integer): pointer;
var
  p:ptUlex;
begin
  p:=Plex;
  typ:=nbChaine;
  result:=ptrG(regDS,Plex^.adv);
  inc(intG(Plex),variCsize);
  if Plex^.genre=motArray then
    inc(intG(result),evaluerDepArray);
  len:=p^.longC;
end;

Function EvaluerAdvariLocC(var typ:typeNombre;var len:integer): pointer;
var
  p:ptUlex;
begin
  p:=Plex;
  typ:=nbChaine;
  result:=ptrG(regSS,regBP+Plex^.dep);
  inc(intG(Plex),VariLocCsize);
  if Plex^.genre=motArray then
     inc(intG(result),evaluerDepArray);
  len:=p^.longCloc;
end;

Function EvaluerAdrefLocC(var typ:typeNombre;var len:integer): pointer;
var
  p:ptUlex;
begin
  p:=Plex;
  typ:=nbChaine;
  if p^.longCloc1=0 then
    begin
      result:=pointer(ptrG(regSS,regBP+Plex^.dep+4)^);
      len:=Pinteger(ptrG(regSS,regBP+Plex^.dep))^-1;
    end
  else
    begin
      result:=pointer(ptrG(regSS,regBP+Plex^.dep)^);
      len:=255;
    end;
  inc(intG(Plex),refLocCsize);
  if Plex^.genre=motArray then
    inc(intG(result),evaluerDepArray);
end;


Function EvaluerAdvariDef(var typ:typeNombre;var len:integer): pointer;
begin
  typ:=nbDef;
  defSize:=Plex^.sz;
  result:=ptrG(regDS,Plex^.adDef);
  inc(intG(Plex),variDefSize);
  while (Plex^.genre=motArray) or (Plex^.genre=CV) or (Plex^.genre=cvObj) do
  begin
    if Plex^.genre=motArray then
      inc(intG(result),evaluerDepArray);
    if Plex^.genre=CV then
    begin
      inc(intG(result),Plex^.CVdep);
      typ:=Plex^.CVtp;
      defSize:=Plex^.CVsz;
      len:=defSize-1;           { pour nbChaine }
      inc(intG(Plex),CVsize);
    end;
    if Plex^.genre=CVobj then
    begin
      inc(intG(result),Plex^.CVdep);
      typ:=refObject;
      inc(intG(Plex),cvObjSize);
    end;
 end;
end;

Function EvaluerAdvariLocDef(var typ:typeNombre;var len:integer): pointer;
begin
  typ:=nbDef;
  defSize:=Plex^.sz1;      // sz1 , pas sz !!!
  result:=ptrG(regSS,regBP+Plex^.depDef);
  inc(intG(Plex),variLocDefSize);
  while (Plex^.genre=motArray) or (Plex^.genre=CV) or (Plex^.genre=cvObj) do
  begin
    if Plex^.genre=motArray then
      inc(intG(result),evaluerDepArray);
    if Plex^.genre=CV then
    begin
      inc(intG(result),Plex^.CVdep);
      typ:=Plex^.CVtp;
      defSize:=Plex^.CVsz;
      len:=defSize-1;           { pour nbChaine }
      inc(intG(Plex),CVsize);
    end;
    if Plex^.genre=CVobj then
    begin
      inc(intG(result),Plex^.CVdep);
      typ:=refObject;
      inc(intG(Plex),CVobjSize);
    end;
 end;
end;

Function EvaluerAdrefLocDef(var typ:typeNombre;var len:integer): pointer;
begin
  typ:=nbDef;
  defSize:=Plex^.sz1;      // sz1 , pas sz !!!
  result:=pointer(ptrG(regSS,regBP+Plex^.depDef)^);
  inc(intG(Plex),refLocDefSize);
  while (Plex^.genre=motArray) or (Plex^.genre=CV) or (Plex^.genre=cvObj) do
  begin
    if Plex^.genre=motArray then
     inc(intG(result),evaluerDepArray);
    if Plex^.genre=CV then
    begin
      inc(intG(result),Plex^.CVdep);
      typ:=Plex^.CVtp;
      defSize:=Plex^.CVsz;
      len:=defSize-1;           { pour nbChaine }
      inc(intG(Plex),CVsize);
    end;
    if Plex^.genre=CVobj then
    begin
      inc(intG(result),Plex^.CVdep);
      typ:=refObject;
      inc(intG(Plex),CVobjSize);
    end;
 end;
end;

Function EvaluerAdvariObject(var typ:typeNombre;var len:integer): pointer;
begin
  typ:=refObject;
  result:=ptrG(regDS,Plex^.adOb);
  inc(intG(Plex),variObjectSize);
  if Plex^.genre=motArray then
    inc(intG(result),evaluerDepArray);
end;

Function EvaluerAdrefAbs(var typ:typeNombre;var len:integer): pointer;
begin
  typ:=nbAbs;
  if Plex^.dep>0
    then result:=ptrG(regSS,Plex^.dep)
    else result:=ptrG(regSS,regBP+Plex^.dep);
  {Donne une adresse dans la pile}
  inc(intG(Plex),refAbsSize);
end;

Function EvaluerAdTPObjectInd(var typ:typeNombre;var len:integer): pointer;
begin
  typ:=refObject;
  if Plex^.depTPO>0
    then result:=Ppointer(regSS+Plex^.depTPO)^
    else result:=Ppointer(regSS+regBP+Plex^.depTPO)^;
  {Dans la pile se trouve le dÃ©placement d'une variable objet dans le
   segment de donnÃ©es}
  inc(intG(Plex),TpObjectIndSize);
end;

Function EvaluerAdTPInd(var typ:typeNombre;var len:integer): pointer;
begin
  typ:=Plex^.tpInd1;
  defSize:=Plex^.szInd;
  result:=Ppointer(regSS+regBP+Plex^.depInd)^;
  {Dans la pile se trouve le dÃ©placement d'une variable objet dans le
   segment de donnÃ©es}
  inc(intG(Plex),TPindSize);

  while (Plex^.genre=motArray) or (Plex^.genre=CV) or (Plex^.genre=cvObj) do
   begin
     if Plex^.genre=motArray then
       inc(intG(result),evaluerDepArray);
     if Plex^.genre=CV then
       begin
         inc(intG(result),Plex^.CVdep);
         typ:=Plex^.CVtp;
         defSize:=Plex^.CVsz;
         len:=defSize-1;
         inc(intG(Plex),CVsize);
       end;
     if Plex^.genre=CVobj then
       begin
         inc(intG(result),Plex^.CVdep);
         typ:=refObject;
         inc(intG(Plex),CVobjSize);
       end;
   end;
end;

Function EvaluerAdrefLocObject(var typ:typeNombre;var len:integer): pointer;
begin
  typ:=refObject;
  result:=pointer(ptrG(regSS,regBP+Plex^.dep)^);
  inc(intG(Plex),refLocObjectSize);
  if Plex^.genre=motArray then
    inc(intG(result),evaluerDepArray);
end;

Function EvaluerAdvariLocObject(var typ:typeNombre;var len:integer): pointer;
begin
  typ:=refObject;
  result:=ptrG(regSS,regBP+Plex^.dep);
  inc(intG(Plex),variLocObjectSize);
  if Plex^.genre=motArray then
    inc(intG(result),evaluerDepArray);
 end;

Function EvaluerAdfonc(var typ:typeNombre;var len:integer): pointer;
begin
  typ:=refProcedure;
  result:=evaluerFoncAd;
end;

Function EvaluerAdrefSys(var typ:typeNombre;var len:integer): pointer;
begin
  typ:=Plex^.tpSys;
  result:=Plex^.adSys;
  defSize:=Plex^.szSys;
  inc(intG(Plex),refSysSize);
end;

Function EvaluerAdmotNil(var typ:typeNombre;var len:integer): pointer;
begin
  result:=@VarNil;
  inc(intG(Plex));
end;

Function EvaluerAdcvVariantObject(var typ:typeNombre;var len:integer): pointer;
var
  p:ptUlex;
  Vob,Vob1:integer;
begin
  p:=Plex;
  Vob:=Plex^.VObVariant; {type souhaitÃ©}
  inc(intG(Plex),cvVariantObjectSize);
  result:=EvaluerAd(typ);
  result:=PGvariant(result)^.VarAddress;
  if not assigned(result) or not assigned(PPUO(result)^)
    then sortieErreur('Cannot convert variant');
  if not PPUO(result)^.PgChildOf(Vob)
    then sortieErreur('Invalid Object Type');

  typ:=refObject;
end;


function EvaluerAd(var typ:typeNombre;var len:integer):pointer;
begin
  result:=tbEvaluerAd[Plex^.genre](typ,len);
end;

procedure InitEvaluerAd;
var
  i:typelex;
begin
  tbEvaluerAd[ stChar ]:= EvaluerAdstChar;

  for i:= variByte to variChar do tbEvaluerAd[i]:= EvaluerAdvariByte;
  tbEvaluerAd[variAnsiString]:= EvaluerAdvariByte;

  for i:= variLocByte to variLocChar do tbEvaluerAd[i]:= EvaluerAdvariLocByte;
  tbEvaluerAd[variLocAnsiString]:= EvaluerAdvariLocByte;

  for i:= refLocByte to refLocChar do tbEvaluerAd[i]:= EvaluerAdrefLocByte;
  tbEvaluerAd[refLocAnsiString]:= EvaluerAdrefLocByte;

  tbEvaluerAd[ variC ]:= EvaluerAdvariC;

  tbEvaluerAd[ variLocC ]:= EvaluerAdvariLocC;

  tbEvaluerAd[ refLocC ]:= EvaluerAdrefLocC;

  tbEvaluerAd[ variDef ]:= EvaluerAdvariDef;

  tbEvaluerAd[ variLocDef ]:= EvaluerAdvariLocDef;

  tbEvaluerAd[ refLocDef ]:= EvaluerAdrefLocDef;

  tbEvaluerAd[ variObject ]:= EvaluerAdvariObject;

  tbEvaluerAd[ refAbs ]:= EvaluerAdrefAbs;

  tbEvaluerAd[ TPObjectInd ]:= EvaluerAdTPObjectInd;

  tbEvaluerAd[ TPInd ]:= EvaluerAdTPInd;

  tbEvaluerAd[ refLocObject ]:= EvaluerAdrefLocObject;

  tbEvaluerAd[ variLocObject ]:= EvaluerAdvariLocObject;

  tbEvaluerAd[ fonc ]:= EvaluerAdfonc;

  tbEvaluerAd[ refSys ]:= EvaluerAdrefSys;

  tbEvaluerAd[ motNil ]:= EvaluerAdmotNil;

  tbEvaluerAd[ cvVariantObject ]:= EvaluerAdcvVariantObject;


end;


function EvaluerAd(var typ:typeNombre):pointer;
var
  len:integer;
begin
  result:=EvaluerAd(typ,len);
end;


procedure empilerParam64(nbParam:Integer;RetPointer: pointer;var StackPos:integer;var param64:Pparam64;var nb64:integer);
var
  i:Integer;
  b1:boolean;
  c1:AnsiChar;
  st1:AnsiString;
  stShort:ShortString;
  tp:typeNombre;
  p:pointer;

  lenC:integer;

  Ib:byte;
  Ishort:shortint;
  Ismall:smallint;
  Iw:word;
  Ilong:longint;
  Id:longword;
  IInt64: int64;

  xs:single;
  x48:real48;
  xd:double;
  xf:float;

  zs:TsingleComp;
  zd:TdoubleComp;
  ze:TfloatComp;

  typ:typeNombre;
  pRefObj:pointer;

  Gvariant:TGvariant;
  dateTime:TdateTime;

  procedure empilerI(ii:int64);
  begin
    inc(nb64);
    param64^[nb64].ii:=ii;
    param64^[nb64].isReal:=0;
  end;

  procedure empilerD(dd: double);   { cas des singles ? }
  begin
    inc(nb64);
    param64^[nb64].dd:=dd;
    param64^[nb64].isReal:=1;
  end;

begin

  stackPos:=stack0.getPos;
  Param64:=empilerStackSeg(nbparam*2+1);  { deux fois le nb de params à cause de refchaine }
  nb64:=0;

  if retPointer<>nil then empilerI(int64(retPointer));

  for i:=1 to nbParam do
    begin
      tp:=Plex^.tpParam;
      inc(intG(Plex),ParamSize);
      case tp of
        RefByte..refChar,refAnsiString, refObject, refVar:
                    with Plex^ do
                      empilerI(intG(evaluerAd(typ)));

        refChaine:  with Plex^ do
                    begin
                      empilerI( intG(evaluerAd(typ,lenC)));
                      empilerI( lenC+1 );
                      {on empile la taille de la variable chaine}
                    end;

        nbByte..nbDword:  empilerI( evaluerI );

        nbInt64:    empilerI(evaluerInt64);

        nbSingle,                            { A résoudre nbSingle }
        nbdouble,nbExtended:
                    empilerD(evaluerR);      // extended=double


        nbSingleComp:
                    begin
                      ze:=evaluerComp;
                      zs.x:=ze.x;
                      zs.y:=ze.y;

                      p:=stack0.StoreStruct(@zs,sizeof(zs));
                      empilerI(intG(p));
                    end;

        nbDoubleComp, nbExtComp:             // extended=double
                    begin
                      ze:=evaluerComp;
                      zd.x:=ze.x;
                      zd.y:=ze.y;

                      p:=stack0.StoreStruct(@zd,sizeof(zd));
                      empilerI(intG(p));
                    end;


        nbvariant:  with Plex^ do
                    begin
                      gvariant.init;
                      EvaluerVariant(Gvariant);   {  }

                      p:=Stack0.storeVariant(Gvariant);
                      empilerI(intG(p));
                    end;

        nbDateTime: with Plex^ do
                      empilerD(double(EvaluerDateTime));

        nbBoole:    empilerI(ord(evaluerB));

        nbChar:     empilerI(byte(evaluerChar));

        nbChaine:   begin
                      stShort:=evaluerC;
                      p:=stack0.StoreStruct(@stShort,256);
                      empilerI(intG(p));
                    end;

        nbAnsiString:
                    begin
                      p:=stack0.StoreAnsiString(evaluerC);
                      empilerI(intG(p^));                       { A vérifier  p^}
                    end;


        refProcedure:
                    begin
                      case Plex^.genre of
                        motNil: begin
                                 ilong:=0;
                                 inc(intG(Plex));
                                end;
                        procU:  begin
                                  ilong:=Plex^.adU;
                                  inc(intG(Plex),procUsize);
                                end;
                        foncU:  begin
                                  ilong:=Plex^.adU;
                                  inc(intG(Plex),foncUsize);
                                end;
                      end;
                      empilerI(ilong);
                    end;

        refDef:     with Plex^ do
                    begin
                      empilerI( intG(evaluerAd(typ)));
                    end;

        nbDef:      with Plex^ do
                    begin
                      p:=stack0.StoreStruct(evaluerAd(typ),defsize);
                      empilerI(intG(p));
                    end;



      end;
    end;
end;

{
  Win64: empilerParametres est utilisé uniquement pour les procédures utilisateurs
}
procedure empilerParametres(nbParam:smallInt;var tailleP,StackPos:integer);
var
  i:Integer;
  b1:boolean;
  c1:AnsiChar;
  st1:AnsiString;
  stShort:ShortString;
  tp:typeNombre;
  p:pointer;

  lenC:integer;

  Ib:byte;
  Ishort:shortint;
  Ismall:smallint;
  Iw:word;
  Ilong:longint;
  Id:longword;
  IInt64: int64;

  xs:single;
  x48:real48;
  xd:double;
  xf:float;

  zs:TsingleComp;
  zd:TdoubleComp;
  ze:TfloatComp;
  
  typ:typeNombre;
  FlagRef:boolean;
  pRefObj:pointer;

  Gvariant:TGvariant;
  dateTime:TdateTime;
begin
  FlagRef:=false;
  tailleP:=0;
  stackPos:=stack0.getPos;

  for i:=1 to nbParam do
    begin
      tp:=Plex^.tpParam;
      inc(intG(Plex),ParamSize);
      case tp of
        RefByte..refChar,refAnsiString:
                    with Plex^ do
                    begin
                      p:=evaluerAd(typ);
                      empilerAppel(p,8);
                      inc(tailleP,8);
                    end;

        refObject:  with Plex^ do
                    begin
                      p:=evaluerAd(typ);

                      FlagRef:=true;
                      PrefObj:=p;

                      empilerAppel(p,8);
                      inc(tailleP,8);
                    end;

        refChaine:  with Plex^ do
                    begin
                      p:=evaluerAd(typ,lenC);

                      empilerAppel(p,8);
                      inc(tailleP,8);
                      {on empile la taille de la variable chaine}
                      inc(lenC);
                      empilerAppel(lenC,4);
                      inc(tailleP,4);
                    end;

        refVar:     with Plex^ do
                    begin
                      p:=evaluerAd(typ);
                      empilerAppel(p,8);
                      inc(tailleP,8);
                    end;


        nbByte:     begin
                      ib:=evaluerI;
                      empilerAppel(ib,4);
                      inc(tailleP,4);
                    end;

        nbShort:    begin
                      ishort:=evaluerI;
                      empilerAppel(ishort,4);
                      inc(tailleP,4);
                    end;

        nbWord:     begin
                      iw:=evaluerI;
                      empilerAppel(iw,4);
                      inc(tailleP,4);
                    end;

        nbSmall:    begin
                      ismall:=evaluerI;
                      if FlagRef then
                      begin
                        refObjectStack.Add(pRefObj);
                        refObjectTypes.add(pointer(ismall));
                        FlagRef:=false;
                        {Pour un variant, il n'y aura pas de vérification de refObjectType car
                         la variable est toujours assignée.}
                      end
                      else
                      begin
                        empilerAppel(ismall,4);
                        inc(tailleP,4);
                      end;
                    end;

        nbLong:    begin
                      ilong:=evaluerI;
                      empilerAppel(ilong,4);
                      inc(tailleP,4);
                    end;

        nbDword:    begin
                      iD:=evaluerI;
                      empilerAppel(iD,4);
                      inc(tailleP,4);
                    end;

        nbInt64:    begin
                      iint64:=evaluerInt64;
                      empilerAppel(iint64,8);
                      inc(tailleP,8);
                    end;

        nbSingle:   begin
                      xs:=evaluerR;
                      empilerAppel(xs,4);
                      inc(tailleP,4);
                    end;

        nbdouble, nbExtended:                 // extended=double
                    begin
                      xd:=evaluerR;
                      empilerAppel(xd,8);
                      inc(tailleP,8);
                    end;


        nbSingleComp:
                    begin
                      ze:=evaluerComp;
                      zs.x:=ze.x;
                      zs.y:=ze.y;

                      empilerStruct(zs,sizeof(zs));
                      inc(tailleP,8);                               // 4 le 18 mai
                    end;

        nbDoubleComp, nbExtComp:
                    begin
                      ze:=evaluerComp;
                      zd.x:=ze.x;
                      zd.y:=ze.y;

                      empilerStruct(zd, sizeof(zd));
                      inc(tailleP,8);                             // 4 le 18 mai
                    end;


        nbvariant:  with Plex^ do
                    begin
                      gvariant.init;
                      EvaluerVariant(Gvariant);   {  }
                      empilerVariant(Gvariant);   {  }

                      {variantStack[high(variantStack)].showStringInfo;}
                      inc(tailleP,8);
                    end;

        nbDateTime: with Plex^ do
                    begin
                      dateTime:=EvaluerDateTime;
                      empilerAppel(dateTime,8);
                      inc(tailleP,8);
                    end;

        nbBoole:    begin
                      b1:=evaluerB;
                      empilerAppel(b1,4);
                      inc(tailleP,4);
                    end;

        nbChar:     begin
                      c1:=evaluerChar;
                      empilerAppel(c1,4);
                      inc(tailleP,4);
                    end;


        nbChaine:   begin
                      stShort:=evaluerC;
                      empilerStruct(stShort,256);
                      inc(tailleP,8);                              // 4 le 18 mai
                    end;

        nbAnsiString:
                    begin
                      st1:=evaluerC;
                      empilerAnsiString(st1);
                      inc(tailleP,8);
                    end;


        refProcedure:
                    begin
                      case Plex^.genre of
                        motNil: begin
                                 ilong:=0;
                                 inc(intG(Plex));
                                end;
                        procU:  begin
                                  ilong:=Plex^.adU;
                                  inc(intG(Plex),procUsize);
                                end;
                        foncU:  begin
                                  ilong:=Plex^.adU;
                                  inc(intG(Plex),foncUsize);
                                end;
                      end;
                      empilerAppel(ilong,4);
                      inc(tailleP,4);
                    end;

        refDef:     with Plex^ do
                    begin
                      p:=evaluerAd(typ);
                      empilerAppel(p,8);           // 4 le 18 mai
                      inc(tailleP,8);
                    end;

        nbDef:      with Plex^ do
                    begin
                      p:=evaluerAd(typ);
                      empilerStruct(p^,defSize);
                      inc(tailleP,8);                // 4 le 18 mai
                    end;



      end;
    end;
end;

{ Après empilage des paramètres, BP prend la valeur de SP

  en BP + 0 se trouve le premier paramètre de taille tailleParam1
  en BP + tailleParam1 se trouve le second paramètre
  etc..

  Au retour, si Ffonc=true, resultat vaut BP et la valeur du résultat est en resultat-tailleResultat

  Les variables locales sont allouées en dessous de BP (dep négatif)
  Les paramètres ont un déplacement positif.

  Les paramÃ¨tres par valeur (dep>=0) et les variables locales (dep<0) sont des variloc
  Les paramètres par réfé©rence sont des refloc




}

function AppelprocU(Ffonc:boolean;var resultat:pointer;Const ResString:boolean=false;Const Pvariant:PGvariant=nil):AnsiString;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,tailleL,Apos:integer;
  exPlex:ptUlex;
  exCurrentProc:integer;
  exBP:integer;

  nbObj,nbSt,nbgvar:integer;
  oldRefObjectStack:Tlist;
  oldRefObjectTypes:Tlist;

begin
  inc(procUON);
  oldRefObjectStack:=RefObjectStack;
  oldRefObjectTypes:=RefObjectTypes;

  RefObjectStack:=Tlist.create;
  RefObjectTypes:=Tlist.create;


  TRY

  nbParam:=Plex^.nbParU;

  exCurrentProc:=CurrentProc;
  CurrentProc:=Plex^.adU;
  adresseV:=ptrG(regCS,CurrentProc);

  inc(intG(Plex),procUsize+ord(Ffonc));
  empilerParametres(nbParam,tailleP,Apos);

  exPlex:=Plex;
  exBP:=regBP;
  regBP:=regSP;

  Plex:=adresseV;

  tailleL:=Plex^.vnbl +4;
  if tailleL>regSP then sortieErreur(E_pile);

  dec(regSP,tailleL);
  fillchar(ptrG(regSS,regSP)^,tailleL,0);

  inc(intG(Plex),NblSize);


  try
    StartProc(nbObj,nbSt,nbgvar);
    while (Plex^.genre<>stop) and not FinExe and not FinExeU^ and not FlagExit and not FlagBreak do
    executerInstruction;

    resultat:=ptrG(regSS,regBP);
    if resString then
    begin
      result:= Pansistring(intG(resultat)-8)^;
      Pansistring(intG(resultat)-8)^:='';
    end
    else
    if Pvariant<>nil then CopyGvariant(PGvariant(intG(resultat)-sizeof(TGvariant))^, Pvariant^ );
  finally
    terminateProc(nbObj,nbSt,nbgvar);
  end;



  if finExe or FinExeU^ then fillchar(ptrG(regSS,regSP)^,tailleL,0);
                 { risque de NAN sur coprocesseur si finEXE }

  inc(regSP,tailleL);
  Plex:=exPlex;
  regBP:=exBP;

  nettoyerPileAppel(tailleP,Apos);
  flagExit:=false;

  dec(procUON);
  CurrentProc:=exCurrentProc;

  FINALLY
  RefObjectStack.free;
  RefObjectTypes.free;
  RefObjectStack:=oldRefObjectStack;
  RefObjectTypes:=oldRefObjectTypes;
  END;
end;

{***************************************************************************************}

{$B+}
function EvaluerIMoinsU:integer;
begin
   inc(intG(Plex));
   result:=-evaluerI;
end;

Function EvaluerIOpnot: integer;
begin
  inc(intG(Plex));
  result:=not evaluerI;
end;

Function EvaluerIPlus: integer;
begin
  inc(intG(Plex));
  result:=evaluerI+evaluerI;
end;

Function EvaluerIMoins: integer;
var
  i:integer;
begin
  inc(intG(Plex));
  i:=evaluerI;
  result:=i-evaluerI;
end;

Function EvaluerIMult: integer;
begin
  inc(intG(Plex));
  result:=evaluerI*evaluerI;
end;

Function EvaluerIOpdiv: integer;
var
  i,j:integer;
begin
  inc(intG(Plex));
  i:=evaluerI;
  j:=evaluerI;
  if j=0 then sortieErreur(200);
  result:=i div j;
end;

Function EvaluerIOpmod: integer;
var
  i,j:integer;
begin
  inc(intG(Plex));
  i:=evaluerI;
  j:=evaluerI;
  if j=0 then sortieErreur(200);
  result:=i mod j;
end;

Function EvaluerIOpAnd: integer;
begin
  inc(intG(Plex));
  result:=evaluerI and evaluerI;
end;

Function EvaluerIOpOr: integer;
begin
  inc(intG(Plex));
  result:=evaluerI or evaluerI;
end;

Function EvaluerIOpxor: integer;
begin
  inc(intG(Plex));
  result:=evaluerI xor evaluerI;
end;


Function EvaluerIOPshl: integer;
var
  i:integer;
begin
  inc(intG(Plex));
  i:=evaluerI;
  result:=i shl evaluerI;
end;

Function EvaluerIOpshr: integer;
var
  i:integer;
begin
  inc(intG(Plex));
  i:=evaluerI;
  result:=i shr evaluerI;
end;

Function EvaluerInbi: integer;
begin
  result:=Plex^.vnbi;
  inc(intG(Plex),NbiSize);
end;

Function EvaluerInbL: integer;
begin
  result:=Plex^.vnbl;
  inc(intG(Plex),NbLsize);
end;

Function EvaluerIvariByte: integer;
var
  adresseV: pointer;
  typ: typeNombre;
begin
  adresseV:=evaluerAd(typ);
  case typ of
    nbByte:  result:= Pbyte(adresseV)^;
    nbShort: result:= Pshort(adresseV)^;
    nbSmall: result:= Psmallint(adresseV)^;
    nbWord:  result:= Pword(adresseV)^;
    nbLong:  result:= Plongint(adresseV)^;
    nbDWord: result:= Plongword(adresseV)^;
    nbInt64: result:= Pint64(adresseV)^;
  end;
end;


Function EvaluerIfonc: integer;
var
  nbparam:integer;
  adresseV:pointer;
  Apos:integer;
  i,j:longint;
  p:pointer;
  tpR:typeNombre;
  typ:typeNombre;
  param64:Pparam64;
  nb64:integer;

begin
  nbParam:=Plex^.nbParP;
  tpR:=Plex^.tpRes;
  adresseV:=adProc^[Plex^.NumProced];
  inc(intG(Plex),foncSize);
  empilerParam64(nbParam,nil,Apos,param64,nb64);
  p:= CallAsm64(adresseV,nb64, param64^);
  case tpR of
    nbByte:  result:= byte(p);
    nbShort: result:= Shortint(p);
    nbSmall: result:= smallint(p);
    nbWord:  result:= word(p);
    nblong:  result:= longint(p);
    nbDword: result:= longword(p);
    nbInt64: result:= int64(p);
    else result:=0;
  end;
  stack0.clean(Apos);
end;

Function EvaluerIfoncU: integer;
var
  tpR: typeNombre;
  p: pointer;
begin
  tpR:=plex^.tpRes1;
  appelProcU(true,p);
  case tpR of
    nbSmall:  result:=Psmallint(intG(p)-2)^;
    nblong:   result:=Plongint(intG(p)-4)^;
    nbInt64:  result:=Pint64(intG(p)-8)^;
    else result:=0;
  end;
end;

Function EvaluerIOrdChar: integer;
begin
  inc(intG(Plex));
  result:=ord(evaluerChar);
end;

Function EvaluerIOrdBoole: integer;
begin
  inc(intG(Plex));
  result:=ord(evaluerB);
end;

Function EvaluerIcvVariantI: integer;
var
  gvariant: TGvariant;
begin
  try
    inc(intG(Plex));
    gvariant.init;
    EvaluerVariant(Gvariant);
    if gVariant.VType<>gvInteger then sortieErreur('Integer expected');
    result:=gvariant.Vinteger;
  finally
    gvariant.finalize;
  end;
end;

Function EvaluerIcvInt64I: integer;
begin
  inc(intG(Plex));
  result:=evaluerInt64;
end;


type
  TIfunction= function:integer;
var
  tbEvaluerI:array[typeLex] of TIfunction;

procedure InitEvaluerI;
var
  i:typeLex;
begin
  tbEvaluerI[MoinsU]:= EvaluerIMoinsU;

  tbEvaluerI[Opnot]:= EvaluerIOpnot;

  tbEvaluerI[Plus]:= EvaluerIPlus;

  tbEvaluerI[Moins]:= EvaluerIMoins;

  tbEvaluerI[Mult]:= EvaluerIMult;

  tbEvaluerI[Opdiv]:= EvaluerIOpdiv;

  tbEvaluerI[Opmod]:= EvaluerIOpmod;

  tbEvaluerI[OpAnd]:= EvaluerIOpAnd;

  tbEvaluerI[OpOr]:= EvaluerIOpOr;

  tbEvaluerI[Opxor]:= EvaluerIOpxor;

  tbEvaluerI[OPshl]:= EvaluerIOPshl;

  tbEvaluerI[Opshr]:= EvaluerIOpshr;

  tbEvaluerI[nbi]:= EvaluerInbi;

  tbEvaluerI[nbL]:= EvaluerInbL;

  for i:= variByte to refLocC do tbEvaluerI[i]:= EvaluerIvariByte;

  tbEvaluerI[variDef]:= EvaluerIvariByte;

  tbEvaluerI[variLocDef]:= EvaluerIvariByte;

  tbEvaluerI[refLocDef]:= EvaluerIvariByte;

  tbEvaluerI[tpInd]:= EvaluerIvariByte;

  tbEvaluerI[fonc]:= EvaluerIfonc;

  tbEvaluerI[foncU]:= EvaluerIfoncU;

  tbEvaluerI[OrdChar]:= EvaluerIOrdChar;

  tbEvaluerI[OrdBoole]:= EvaluerIOrdBoole;

  tbEvaluerI[cvVariantI]:= EvaluerIcvVariantI;

  tbEvaluerI[cvInt64I]:= EvaluerIcvInt64I;

end;


function evaluerI:longint;
begin
  result:=tbEvaluerI[Plex^.genre];
end;



{********************** EvaluerInt64 **************************************************************}

function EvaluerInt64MoinsU: int64;
begin
  inc(intG(Plex));
  result:=-evaluerInt64;
end;

function EvaluerInt64Opnot: int64;
begin
  inc(intG(Plex));
  result:=not evaluerInt64;
end;

function EvaluerInt64Plus: int64;
begin
  inc(intG(Plex));
  result:=evaluerInt64+evaluerInt64;
end;

function EvaluerInt64Moins: int64;
var
  i: int64;
begin
  inc(intG(Plex));
  i:=evaluerInt64;
  result:=i-evaluerInt64;
end;

function EvaluerInt64Mult: int64;
begin
  inc(intG(Plex));
  result:=evaluerInt64*evaluerInt64;
end;

function EvaluerInt64Opdiv: int64;
var
  i,j:int64;
begin
   inc(intG(Plex));
   i:=evaluerInt64;
   j:=evaluerInt64;
   if j=0 then sortieErreur(200);
   result:=i div j;
end;

function EvaluerInt64Opmod: int64;
var
  i,j:int64;
begin
  inc(intG(Plex));
  i:=evaluerInt64;
  j:=evaluerInt64;
  if j=0 then sortieErreur(200);
  result:=i mod j;
end;

function EvaluerInt64OpAnd: int64;
begin
  inc(intG(Plex));
  result:=evaluerInt64 and evaluerInt64;
end;

function EvaluerInt64OpOr: int64;
begin
  inc(intG(Plex));
  result:=evaluerInt64 or evaluerInt64;
end;

function EvaluerInt64Opxor: int64;
begin
  inc(intG(Plex));
  result:=evaluerInt64 xor evaluerInt64;
end;

function EvaluerInt64OPshl: int64;
var
  i:int64;
begin
  inc(intG(Plex));
  i:=evaluerInt64;
  result:=i shl evaluerInt64;
end;

function EvaluerInt64Opshr: int64;
var
  i:int64;
begin
  inc(intG(Plex));
  i:=evaluerInt64;
  result:=i shr evaluerInt64;
end;

function EvaluerInt64nbi: int64;
begin
  result:=Plex^.vnbi;
  inc(intG(Plex),nbiSize);
end;

function EvaluerInt64nbL: int64;
begin
  result:=Plex^.vnbl;
  inc(intG(Plex),nbLsize);
end;

function EvaluerInt64variByte: int64;
var
  adresseV:pointer;
  typ:typeNombre;
begin
  adresseV:=evaluerAd(typ);
  case typ of
    nbByte:  result:= Pbyte(adresseV)^;
    nbShort: result:= Pshort(adresseV)^;
    nbSmall: result:= Psmallint(adresseV)^;
    nbWord:  result:= Pword(adresseV)^;
    nbLong:  result:= Plongint(adresseV)^;
    nbDWord: result:= Plongword(adresseV)^;
    nbInt64: result:= Pint64(adresseV)^;
  end;
end;

function EvaluerInt64fonc: int64;
var
  nbParam, Apos,nb64:integer;
  param64:Pparam64;
  tpR:typeNombre;
  p,adresseV:pointer;

begin
   nbParam:=Plex^.nbParP;
   tpR:=Plex^.tpRes;
   adresseV:=adProc^[Plex^.NumProced];

   inc(intG(Plex), foncSize);

   empilerParam64(nbParam,nil,Apos,param64,nb64);
   p:= CallAsm64(adresseV,nb64, param64^);
   case tpR of
     nbByte:  result:= byte(p);
     nbShort: result:= Shortint(p);
     nbSmall: result:= smallint(p);
     nbWord:  result:= word(p);
     nblong:  result:= longint(p);
     nbDword: result:= longword(p);
     nbInt64: result:= int64(p);
     else result:=0;
   end;
   stack0.clean(Apos);
end;

function EvaluerInt64foncU: int64;
var
  tpR:typeNombre;
  p:pointer;
begin
  tpR:=plex^.tpRes1;
  appelProcU(true,p);
  case tpR of
    nbSmall:  result:=Psmallint(intG(p)-2)^;
    nblong:   result:=Plongint(intG(p)-4)^;
    nbInt64:  result:=Pint64(intG(p)-4)^;
    else result:=0;
  end;
end;

function EvaluerInt64OrdChar: int64;
begin
  inc(intG(Plex));
  result:=ord(evaluerChar);
end;

function EvaluerInt64OrdBoole: int64;
begin
  inc(intG(Plex));
  result:=ord(evaluerB);
end;

function EvaluerInt64cvVariantI: int64;
var
  gvariant:TGvariant;
begin
  try
    inc(intG(Plex));
    gvariant.init;
    EvaluerVariant(Gvariant);
    if gVariant.VType<>gvInteger then sortieErreur('Integer expected');
    result:=gvariant.Vinteger;
  finally
    gvariant.finalize;
  end;
end;

function EvaluerInt64cvIInt64: int64;
begin
  inc(intG(Plex));
  result:=evaluerI;
end;

type
  TfunctionI64= function:int64;
var
  tbEvaluerInt64: array[typeLex] of TFunctionI64;

procedure initEvaluerInt64;
var
  i:typeLex;
begin
  tbEvaluerInt64[MoinsU] := evaluerInt64MoinsU;

  tbEvaluerInt64[Opnot] := evaluerInt64Opnot;

  tbEvaluerInt64[Plus] := evaluerInt64Plus;

  tbEvaluerInt64[Moins] := evaluerInt64Moins;

  tbEvaluerInt64[Mult] := evaluerInt64Mult;

  tbEvaluerInt64[Opdiv] := evaluerInt64Opdiv;

  tbEvaluerInt64[Opmod] := evaluerInt64Opmod;

  tbEvaluerInt64[OpAnd] := evaluerInt64OpAnd;

  tbEvaluerInt64[OpOr] := evaluerInt64OpOr;

  tbEvaluerInt64[Opxor] := evaluerInt64Opxor;

  tbEvaluerInt64[OPshl] := evaluerInt64OPshl;

  tbEvaluerInt64[Opshr] := evaluerInt64Opshr;

  tbEvaluerInt64[nbi] := evaluerInt64nbi;

  tbEvaluerInt64[nbL] := evaluerInt64nbL;

  for i:= variByte to reflocC do  tbEvaluerInt64[i] := evaluerInt64variByte;

  tbEvaluerInt64[variDef] := evaluerInt64variByte;
  tbEvaluerInt64[variLocDef] := evaluerInt64variByte;
  tbEvaluerInt64[refLocDef] := evaluerInt64variByte;
  tbEvaluerInt64[tpInd] := evaluerInt64variByte;

  tbEvaluerInt64[fonc] := evaluerInt64fonc;

  tbEvaluerInt64[foncU] := evaluerInt64foncU;

  tbEvaluerInt64[OrdChar] := evaluerInt64OrdChar;

  tbEvaluerInt64[OrdBoole] := evaluerInt64OrdBoole;

  tbEvaluerInt64[cvVariantI] := evaluerInt64cvVariantI;

  tbEvaluerInt64[cvIInt64] := evaluerInt64cvIInt64;
end;

function EvaluerInt64: int64;
begin
  result:= tbEvaluerInt64[Plex^.genre];
end;

{*******************************  EvaluerR  ***********************************************************}

function EvaluerRmoinsU: float;
begin
  inc(intG(Plex));
  result:=-evaluerR;
end;

function EvaluerRplus: float;
var
  x,y:float;
begin
  inc(intG(Plex));
  x:=evaluerR;
  y:=evaluerR;
  result:=x+y;
end;

function EvaluerRmoins: float;
var
  x,y:float;
begin
  inc(intG(Plex));
  x:=evaluerR;
  y:=evaluerR;
  result:=x-y;
end;

function EvaluerRmult: float;
var
  x,y:float;
begin
  inc(intG(Plex));
  x:=evaluerR;
  y:=evaluerR;
  result:=x*y;
end;

function EvaluerRdivis: float;
var
  x,y:float;
begin
  inc(intG(Plex));
  x:=evaluerR;
  y:=evaluerR;
  result:=x/y;
end;

function EvaluerRnbR: float;
begin
  result:=Plex^.vnbr;
  inc(intG(Plex),nbRsize);
end;

function EvaluerRcvIR: float;
begin
  inc(intG(Plex));
  result:=evaluerI;
end;

function EvaluerRcvInt64R: float;
begin
  inc(intG(Plex));
  result:=evaluerInt64;
end;

function EvaluerRvariByte: float;
var
  adresseV:pointer;
  typ: typeNombre;
begin
   adresseV:=evaluerAD(typ);
   case typ of
     nbSingle:              result:= Psingle(adresseV)^;
     nbDouble,nbExtended:   result:= Pdouble(adresseV)^;            // extended=double
   end;
end;

function EvaluerRfonc: float;
var
  adresseV:pointer;
  nbParam,Apos,nb64: integer;
  param64: Pparam64;
  tpR:typeNombre;
  p:pointer;
  dd: double absolute p;
  ss: single absolute p;
begin
  nbParam:=Plex^.nbParP;
  tpR:=Plex^.tpRes;
  adresseV:=adProc^[Plex^.NumProced];

  inc(intG(Plex),foncSize);

  empilerParam64(nbParam,nil,Apos,param64,nb64);
  p:= CallAsm64(adresseV,nb64, param64^);
  case tpR of
    nbSingle:               result:= param64^[1].ss;     { A vérifier }
    nbDouble, nbExtended:   result:= param64^[1].dd;     { A vérifier }          // extended=double
  end;
  stack0.clean(Apos);
end;

function EvaluerRfoncU: float;
var
  tpR: typeNombre;
  p:pointer;
begin
  tpR:=plex^.tpRes1;
  appelProcU(true,p);
  case tpR of
    nbSingle:              result:=Psingle(intG(p)-4)^;
    nbDouble,nbExtended:   result:=Pdouble(intG(p)-8)^;        // extended=double
    else result:=0;
  end;
end;

function EvaluerRcvVariantR: float;
var
  gvariant:Tgvariant;
begin
  try
    inc(intG(Plex));
    gvariant.init;
    EvaluerVariant(Gvariant);
    if not (gVariant.VType in [gvInteger,gvFloat]) then sortieErreur('Real expected');
    if gVariant.Vtype=gvInteger
      then result:=Gvariant.Vinteger
      else result:=Gvariant.Vfloat;
  finally
    gvariant.finalize;
  end;
end;

type
  TfunctionR = function: float;

var
  tbEvaluerR: array[typelex] of TfunctionR;

procedure initEvaluerR;
var
  i:typelex;
begin
  tbEvaluerR[moinsU]:=evaluerRmoinsU;
  tbEvaluerR[plus]:=evaluerRplus;
  tbEvaluerR[moins]:=evaluerRmoins;
  tbEvaluerR[mult]:=evaluerRmult;
  tbEvaluerR[divis]:=evaluerRdivis;
  tbEvaluerR[nbR]:=evaluerRnbR;
  tbEvaluerR[cvIR]:=evaluerRcvIR;
  tbEvaluerR[cvInt64R]:=evaluerRcvInt64R;
  for i:= variByte to refLocC do tbEvaluerR[i]:=evaluerRvariByte;
  tbEvaluerR[variDef]:=evaluerRvariByte;
  tbEvaluerR[variLocDef]:=evaluerRvariByte;
  tbEvaluerR[refLocDef]:=evaluerRvariByte;
  tbEvaluerR[tpInd]:=evaluerRvariByte;
  tbEvaluerR[fonc]:=evaluerRfonc;
  tbEvaluerR[foncU]:=evaluerRfoncU;
  tbEvaluerR[cvVariantR]:=evaluerRcvVariantR;
end;

function evaluerR: float;
begin
  result:=tbEvaluerR[Plex^.genre];
end;

function evaluerComp:TfloatComp;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,Apos:integer;
  z1,z2:TfloatComp;
  Zsingle:TsingleComp;
  Zdouble:TdoubleComp;
  m:float;
  p:pointer;
  tpR:typeNombre;
  typ:typeNombre;
  Gvariant:TGvariant;
  param64: Pparam64;
  nb64: integer;

begin
  case Plex^.genre of
    moinsU:  begin
               inc(intG(Plex));
               result:=evaluerComp;
               result.x:=-result.x;
               result.y:=-result.y;
             end;

    plus:    begin
               inc(intG(Plex));
               z1:=evaluerComp;
               z2:=evaluerComp;
               result.x:=z1.x+z2.x;
               result.y:=z1.y+z2.y;
             end;

    moins:   begin
               inc(intG(Plex));
               z1:=evaluerComp;
               z2:=evaluerComp;
               result.x:=z1.x-z2.x;
               result.y:=z1.y-z2.y;
             end;

    mult:    begin
               inc(intG(Plex));
               z1:=evaluerComp;
               z2:=evaluerComp;
               result.x:=z1.x*z2.x-z1.y*z2.y;
               result.y:=z1.x*z2.y+z1.y*z2.x;
             end;

    divis:   begin
               inc(intG(Plex));
               z1:=evaluerComp;
               z2:=evaluerComp;
               m:=sqr(z2.x)+sqr(z2.y);
               result.x:=(z1.x*z2.x+z1.y*z2.y)/m;
               result.y:=(z1.y*z2.x-z1.x*z2.y)/m;
             end;

    {
    nbComp:  begin
               z:=Plex^.vnbr;
               inc(intG(Plex),11);
             end;
    }

    cvIComp: begin
               inc(intG(Plex));
               result.x:=evaluerI;
               result.y:=0;
             end;

    cvRComp: begin
               inc(intG(Plex));
               result.x:=evaluerR;
               result.y:=0;
             end;

    variByte..refLocC,variDef,variLocDef,refLocDef,tpInd:
             begin
               adresseV:=evaluerAd(typ);
               case typ of
                 nbSingleComp: begin
                                 result.x:=PsingleComp(AdresseV)^.x;
                                 result.y:=PsingleComp(AdresseV)^.y;
                               end;
                 nbDoubleComp, nbExtComp:
                               result:=PFloatComp(AdresseV)^;
               end;
             end;

    fonc:    begin
               nbParam:=Plex^.nbParP;
               tpR:=Plex^.tpRes;
               adresseV:=adProc^[Plex^.NumProced];
               inc(intG(Plex),foncSize);



               case tpR of
                 nbSingleComp: begin
                                 empilerParam64(nbParam,@Zsingle,Apos,param64,nb64);
                                 p:= CallAsm64(adresseV,nb64, param64^);
                                 result.x:=Zsingle.x;
                                 result.y:=Zsingle.y;
                               end;

                 nbDoubleComp,nbExtComp:
                               begin
                                 empilerParam64(nbParam,@Zdouble,Apos,param64,nb64);
                                 p:= CallAsm64(adresseV,nb64, param64^);

                                 result.x:=Zdouble.x;
                                 result.y:=Zdouble.y;
                               end;

               end;

               stack0.clean(Apos);

             end;

    foncU:   begin
               tpR:=plex^.tpRes1;
               appelProcU(true,p);
               case tpR of
                 nbSingleComp:
                   begin
                     Zsingle:=PsingleComp(intG(p)-8)^;
                     result.x:=Zsingle.x;
                     result.y:=Zsingle.y;
                   end;
                 nbDoubleComp,nbExtComp:
                   begin
                     Zdouble:=PdoubleComp(intG(p)-16)^;
                     result.x:=Zdouble.x;
                     result.y:=Zdouble.y;
                   end;
               end;
             end;

    cvVariantComp:
        try
          inc(intG(Plex));
          gvariant.init;
          EvaluerVariant(Gvariant);

          if not (gVariant.VType in [gvInteger,gvFloat,gvComplex]) then sortieErreur('Complex expected');

          case gVariant.Vtype of
            gvInteger: begin
                         result.x:=Gvariant.Vinteger;
                         result.y:=0;
                       end;
            gvFloat:   begin
                         result.x:=Gvariant.Vfloat;
                         result.y:=0;
                       end;
            gvComplex: result:=Gvariant.Vcomplex;
          end;

        finally
          gvariant.finalize;
        end;
  end;
end;


function evaluerB:boolean;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,Apos:integer;
  x,y:float;
  i:int64;
  p:pointer;
  dd:integer;
  typ:typeNombre;
  Gvariant:TGvariant;
  param64: Pparam64;
  nb64: integer;

begin
  case Plex^.genre of
    Opnot:   begin
               inc(intG(Plex));
               evaluerB:= not evaluerB;
             end;
    Opand:   begin
               inc(intG(Plex));
               evaluerB:= evaluerB and evaluerB;
             end;
    Opor:    begin
               inc(intG(Plex));
               evaluerB:= evaluerB or evaluerB;
             end;

    andBI:   begin
               dd:=Plex^.depLog;
               inc(intG(Plex),andBIsize);
               result:= evaluerB;
               if result
                 then result:=evaluerB
                 else inc(intG(Plex),dd);
             end;
    orBI:    begin
               dd:=Plex^.depLog;
               inc(intG(Plex), orBIsize);
               result:=evaluerB;
               if not result
                 then result:= evaluerB
                 else inc(intG(Plex),dd);
             end;


    Opxor:   begin
               inc(intG(Plex));
               evaluerB:= evaluerB xor evaluerB;
             end;

    egalI:   begin
               inc(intG(Plex));
               evaluerB:= (evaluerI=evaluerI);
             end;

    egalI64: begin
               inc(intG(Plex));
               evaluerB:= (evaluerInt64=evaluerInt64);
             end;

    egalR:   begin
               inc(intG(Plex));
               x:=evaluerR;
               y:=evaluerR;
               evaluerB:= (x=y);
             end;

    egalB:   begin
               inc(intG(Plex));
               evaluerB:= (evaluerB=evaluerB);
             end;

    egalC:   begin
               inc(intG(Plex));
               evaluerB:= (evaluerC=evaluerC);
             end;

    differentI:
             begin
               inc(intG(Plex));
               evaluerB:= (evaluerI<>evaluerI);
             end;

    differentI64:
             begin
               inc(intG(Plex));
               evaluerB:= (evaluerInt64<>evaluerInt64);
             end;

    differentR:
             begin
               inc(intG(Plex));
               x:=evaluerR;
               y:=evaluerR;
               evaluerB:= (x<>y);
             end;

    differentB:
             begin
               inc(intG(Plex));
               evaluerB:= (evaluerB<>evaluerB);
             end;

    differentC:
             begin
               inc(intG(Plex));
               evaluerB:= (evaluerC<>evaluerC);
             end;

    infI:   begin
               inc(intG(Plex));
               i:=evaluerI;
               evaluerB:= (i<evaluerI);
             end;

    infI64:  begin
               inc(intG(Plex));
               i:=evaluerInt64;
               evaluerB:= (i<evaluerInt64);
             end;

    infR:   begin
               inc(intG(Plex));
               x:=evaluerR;
               y:=evaluerR;
               evaluerB:= (x<y);
             end;

    infC:   begin
               inc(intG(Plex));
               evaluerB:= (evaluerC<evaluerC);
             end;

    infegalI:begin
               inc(intG(Plex));
               i:=evaluerI;
               evaluerB:= (i<=evaluerI);
             end;

    infegalI64:
             begin
               inc(intG(Plex));
               i:=evaluerInt64;
               evaluerB:= (i<=evaluerInt64);
             end;

    infegalR:begin
               inc(intG(Plex));
               x:=evaluerR;
               y:=evaluerR;
               evaluerB:= (x<=y);
             end;

    infegalC:begin
               inc(intG(Plex));
               evaluerB:= (evaluerC<=evaluerC);
             end;

    supI:    begin
               inc(intG(Plex));
               i:=evaluerI;
               evaluerB:= (i>evaluerI);
             end;

     supI64:  begin
               inc(intG(Plex));
               i:=evaluerInt64;
               evaluerB:= (i>evaluerInt64);
             end;

    supR:    begin
               inc(intG(Plex));
               x:=evaluerR;
               y:=evaluerR;
               evaluerB:= (x>y);
             end;

    supC:    begin
               inc(intG(Plex));
               evaluerB:= (evaluerC>evaluerC);
             end;

    supegalI:begin
               inc(intG(Plex));
               i:=evaluerI;
               evaluerB:= (i>=evaluerI);
             end;

   supegalI64:
             begin
               inc(intG(Plex));
               i:=evaluerInt64;
               evaluerB:= (i>=evaluerInt64);
             end;

    supegalR:begin
               inc(intG(Plex));
               x:=evaluerR;
               y:=evaluerR;
               evaluerB:= (x>=y);
             end;

    supegalC:begin
               inc(intG(Plex));
               evaluerB:= (evaluerC>=evaluerC);
             end;

    motTrue:
         begin
           evaluerB:=true;
           inc(intG(Plex));
         end;
    motFalse:
         begin
           evaluerB:=false;
           inc(intG(Plex));
         end;

    variB,variLocB,refLocB,variDef,variLocDef,refLocDef,tpInd:
           evaluerB:=Pboolean(evaluerAd(typ))^;

    fonc: begin
           nbParam:=Plex^.nbParP;
           adresseV:=adProc^[Plex^.NumProced];
           inc(intG(Plex),foncSize);

           empilerParam64(nbParam,nil,Apos,param64,nb64);
           result:= intG(CallAsm64(adresseV,nb64, param64^)) and $FF <>0;
           stack0.clean(Apos);
         end;

    foncU:begin
            appelProcU(true,p);
            dec(intG(p));
            evaluerB:=Pboolean(p)^;
          end;

    cvVariantBoole:
          try
            inc(intG(Plex));
            gvariant.init;
            EvaluerVariant(Gvariant);
            if not (gVariant.VType=gvBoolean) then sortieErreur('Boolean expected');
            result:=Gvariant.VBoolean;
          finally
            gvariant.finalize;
          end;

    else result:=false;
  end;
end;

function evaluerC:AnsiString;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,Apos:integer;
  stShort:ShortString;
  stWide:AnsiString;
  p:pointer;
  tpR:typeNombre;
  ind:integer;
  typ:typeNombre;
  gvariant:TGVariant;
  param64: PParam64;
  nb64: integer;

begin
  case Plex^.genre of
    plus:    begin
               inc(intG(Plex));
               stWide:=evaluerC;
               result:=stWide+evaluerC;
             end;
    chaineCar:
            begin
              result:=Plex^.st;
              inc(intG(Plex),chaineCarSize + length(Plex^.st));
            end;

    ConstCar:
            begin
              result:=Plex^.vc;
              inc(intG(Plex), ConstCarSize);
            end;

    variC,variLocC,refLocC,variDef,variLocDef,refLocDef:
            begin
               result:=PShortString(evaluerAd(typ))^;
            end;

    variANSIstring,varilocANSIstring,reflocANSIstring:
             begin
               result:=PansiString(evaluerAd(typ))^;
             end;

    variChar,variLocChar,refLocChar,tpInd:
            begin
               result:=Pchar0(evaluerAd(typ))^;
            end;

    stChar: begin
              inc(intG(Plex));
              stWide:=evaluerC;
              ind:=evaluerI;
              if (ind<1) or (ind>length(stWide)) then sortieErreur(E_indiceChaine);
              result:=stWide[ind];
            end;

    fonc:   begin
              nbParam:=Plex^.nbParP;
              tpR:=Plex^.tpRes;
              adresseV:=adProc^[Plex^.NumProced];
              inc(intG(Plex),foncSize);


              case tpR of
                nbChaine:
                  begin
                    empilerParam64(nbParam,@stShort,Apos,param64,nb64);
                    p:= CallAsm64(adresseV,nb64, param64^);
                    result:=stShort;
                    stack0.clean(Apos);
                  end;
                nbAnsiString:
                  begin
                    empilerParam64(nbParam,@stWide,Apos,param64,nb64);
                    p:= CallAsm64(adresseV,nb64, param64^);
                    result:= stWide;
                    stack0.clean(Apos);
                  end;
               nbChar:
                  begin
                    empilerParam64(nbParam,nil,Apos,param64,nb64);
                    p:= CallAsm64(adresseV,nb64, param64^);
                    result:=AnsiChar(p);
                    stack0.clean(Apos);
                  end;
              end;
            end;

    foncU:  begin
              tpR:=Plex^.tpRes1;

              case tpR of
                nbChar:       begin
                                appelProcU(true,p);
                                result:=Pchar0(intG(p)-1)^;
                              end;
                nbChaine:     begin
                                appelProcU(true,p);
                                result:=PShortString(intG(p)-256)^;
                              end;
                nbAnsiString: begin
                                result:=appelProcU(true,p,true);
                              end;
              end;
            end;

    cvVariantSt:
            try
              inc(intG(Plex));
              gvariant.init;
              EvaluerVariant(Gvariant);
              if gVariant.VType<>gvString then sortieErreur('String expected');
              result:=gvariant.VString;
            finally
              gvariant.finalize;
            end;
  end;
end;

{$B-}

function evaluerChar:Ansichar;
var
  nbParam:integer;
  adresseV:pointer;
  tailleP,Apos:integer;
  p:pointer;
  st1:shortString;
  ind:integer;
  typ:typeNombre;
  param64: Pparam64;
  nb64: integer;
begin
  case Plex^.genre of
    ConstCar:
            begin
              result:=Plex^.vc;
              inc(intG(Plex),ConstCarSize);
            end;

    variChar,variLocChar,refLocChar,variDef,variLocDef,refLocDef,tpInd:
            begin
              result:=Pchar0(evaluerAd(typ))^;
            end;

    stChar: begin
              inc(intG(Plex));
              st1:=evaluerC;
              ind:=evaluerI;
              if (ind<1) or (ind>length(st1)) then sortieErreur(E_indiceChaine);
              result:=st1[ind];
            end;

    fonc:   begin
              nbParam:=Plex^.nbParP;
              adresseV:=adProc^[Plex^.NumProced];

              inc(intG(Plex), foncSize);

              empilerParam64(nbParam,nil,Apos,param64,nb64);
              p:= CallAsm64(adresseV,nb64, param64^);
              result:=Ansichar(p);
              stack0.clean(Apos);
            end;

    foncU:  begin
              appelProcU(true,p);
              result:=Pchar0(intG(p)-1)^;
            end;

    else result:=#0;
  end;
end;




procedure evaluerVariant(var result:TGvariant);
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,Apos,nb64:integer;
  param64:Pparam64;
  p:pointer;
  typ:typeNombre;
  gvariant:TGVariant;

begin
  case Plex^.genre of
    CvIvariant:
            begin
              inc(intG(Plex));
              result.VInteger:=evaluerI;
            end;

    CvRvariant:
            begin
              inc(intG(Plex));
              result.Vfloat:=evaluerR;
            end;

    CvStvariant:
            begin
              inc(intG(Plex));
              result.Vstring:=evaluerC;
              {result.showStringInfo;}
            end;

    CvBooleVariant:
            begin
              inc(intG(Plex));
              result.Vboolean:=evaluerB;
            end;

    CvDateTimeVariant:
            begin
              inc(intG(Plex));
              result.VdateTime:=evaluerDateTime;
            end;

    CvObjectVariant:
            begin
              inc(intG(Plex));
              p:=evaluerAd(typ);
              result.Vobject:=PPUO(p)^;     { le variant référence l'objet p}
            end;

    fonc:   begin
              nbParam:=Plex^.nbParP;
              adresseV:=adProc^[Plex^.NumProced];
              inc(intG(Plex), foncSize);

              fillchar(gvariant,sizeof(gvariant),0);
              empilerParam64(nbParam,@gvariant,Apos,param64,nb64);
              p:= CallAsm64(adresseV,nb64, param64^);
              result:=gvariant;
              stack0.clean(Apos);
            end;

    foncU:   begin
               appelProcU(true,p,false,@result);

             end;

    variVariant,variLocVariant,refLocVariant:
            begin
               {copyGVariant(PGvariant(evaluerAd(typ))^,result); }
               result:=PGvariant(evaluerAd(typ))^;
                                        { le variant référence l'objet p}
            end;


    MoinsU:  begin
               inc(intG(Plex));
               evaluerVariant(result);
               case result.Vtype of
                 gvInteger: result.Vinteger:=-result.Vinteger;
                 gvFloat:   result.Vfloat:=  -result.Vfloat;
                 gvComplex: result.Vcomplex:= CpxNumber(-result.Vcomplex.x,-result.Vcomplex.y);
                 else sortieErreur('Real or integer value expected');
               end;
             end;


    Plus:    begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);

               try
               case result.Vtype of
                 gvInteger:  case gvariant.VType of
                               gvInteger: result.Vinteger:= result.Vinteger+gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=   result.Vinteger+gvariant.Vfloat;
                               gvComplex: result.Vcomplex:= CpxNumber(result.Vinteger+gvariant.Vcomplex.x,gvariant.Vcomplex.y);
                               else sortieErreur('Unexpected type');
                             end;

                 gvFloat:   case gvariant.VType of
                               gvInteger: result.Vfloat:=   result.Vfloat+gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=   result.Vfloat+gvariant.Vfloat;
                               gvComplex: result.Vcomplex:= CpxNumber(result.Vfloat+gvariant.Vcomplex.x,gvariant.Vcomplex.y);
                               else sortieErreur('Unexpected type');
                             end;

                 gvComplex:  case gvariant.VType of
                               gvInteger: result.Vcomplex:= CpxNumber(result.Vcomplex.x+gvariant.Vinteger,result.Vcomplex.y);
                               gvFloat:   result.Vcomplex:= CpxNumber(result.Vcomplex.x+gvariant.Vfloat,result.Vcomplex.y);
                               gvComplex: result.Vcomplex:= CpxNumber(result.Vcomplex.x+gvariant.Vcomplex.x,result.Vcomplex.y+gvariant.Vcomplex.y);
                               else sortieErreur('Unexpected type');
                             end;

                 gvString:   case gvariant.VType of
                               gvString:  result.Vstring:=result.Vstring+gvariant.Vstring;
                               else sortieErreur('Unexpected type');
                             end;

                 else sortieErreur('Unexpected type');
               end;
               finally
                 gvariant.finalize;
               end;
             end;

    moins:    begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);

               try
               case result.Vtype of
                 gvInteger:  case gvariant.VType of
                               gvInteger: result.Vinteger:= result.Vinteger-gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=   result.Vinteger-gvariant.Vfloat;
                               gvComplex: result.Vcomplex:= CpxNumber(result.Vinteger-gvariant.Vcomplex.x,gvariant.Vcomplex.y);
                               else sortieErreur('Unexpected type');
                             end;

                 gvFloat:   case gvariant.VType of
                               gvInteger: result.Vfloat:=   result.Vfloat-gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=   result.Vfloat-gvariant.Vfloat;
                               gvComplex: result.Vcomplex:= CpxNumber(result.Vfloat-gvariant.Vcomplex.x,gvariant.Vcomplex.y);
                               else sortieErreur('Unexpected type');
                             end;

                 gvComplex:  case gvariant.VType of
                               gvInteger: result.Vcomplex:= CpxNumber(result.Vcomplex.x-gvariant.Vinteger,result.Vcomplex.y);
                               gvFloat:   result.Vcomplex:= CpxNumber(result.Vcomplex.x-gvariant.Vfloat,result.Vcomplex.y);
                               gvComplex: result.Vcomplex:= CpxNumber(result.Vcomplex.x-gvariant.Vcomplex.x,result.Vcomplex.y-gvariant.Vcomplex.y);
                               else sortieErreur('Unexpected type');
                             end;

                 else sortieErreur('Unexpected type');
               end;
               finally
                 gvariant.finalize;
               end;
             end;

    mult:    begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);

               try

               case result.Vtype of
                 gvInteger:  case gvariant.VType of
                               gvInteger: result.Vinteger:= result.Vinteger*gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=   result.Vinteger*gvariant.Vfloat;
                               gvComplex: result.Vcomplex:= ProdCpx(FloatToCpx(result.Vinteger),gvariant.Vcomplex);
                               else sortieErreur('Unexpected type');
                             end;

                 gvFloat:   case gvariant.VType of
                               gvInteger: result.Vfloat:=   result.Vfloat*gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=   result.Vfloat*gvariant.Vfloat;
                               gvComplex: result.Vcomplex:= ProdCpx(FloatToCpx(result.Vfloat),gvariant.Vcomplex);
                               else sortieErreur('Unexpected type');
                             end;

                 gvComplex:  case gvariant.VType of
                               gvInteger: result.Vcomplex:= ProdCpx(result.Vcomplex, FloatToCpx(gvariant.Vinteger));
                               gvFloat:   result.Vcomplex:= ProdCpx(result.Vcomplex, FloatToCpx(gvariant.Vfloat));
                               gvComplex: result.Vcomplex:= ProdCpx(result.Vcomplex,gvariant.Vcomplex);
                               else sortieErreur('Unexpected type');
                             end;
               end;
               finally
                 gvariant.finalize;
               end;
             end;

    divis:   begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);
               try
               case result.Vtype of
                 gvInteger:  case gvariant.VType of
                               gvInteger: result.Vfloat:=   result.Vinteger/gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=   result.Vinteger/gvariant.Vfloat;
                               gvComplex: result.Vcomplex:= DivCpx(FloatToCpx(result.Vinteger),gvariant.Vcomplex);
                               else sortieErreur('Unexpected type');
                             end;
                 gvFloat:   case gvariant.VType of
                               gvInteger: result.Vfloat:=   result.Vfloat/gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=   result.Vfloat/gvariant.Vfloat;
                               gvComplex: result.Vcomplex:= DivCpx(FloatToCpx(result.Vfloat),gvariant.Vcomplex);
                               else sortieErreur('Unexpected type');
                             end;
                 gvComplex:  case gvariant.VType of
                               gvInteger: result.Vcomplex:= DivCpx(result.Vcomplex, FloatToCpx(gvariant.Vinteger));
                               gvFloat:   result.Vcomplex:= DivCpx(result.Vcomplex, FloatToCpx(gvariant.Vfloat));
                               gvComplex: result.Vcomplex:= DivCpx(result.Vcomplex,gvariant.Vcomplex);
                               else sortieErreur('Unexpected type');
                             end;


                 else sortieErreur('Unexpected type');
               end;
               finally
                 gvariant.finalize;
               end;
             end;

    Opnot:   begin
               inc(intG(Plex));
               EvaluerVariant(result);

               case result.Vtype of
                 gvInteger:   result.Vinteger:=not result.Vinteger;
                 gvBoolean:   result.Vboolean:=not result.Vboolean;
                 else sortieErreur('Boolean or integer value expected');
               end;

             end;


    Opdiv:   begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);
               try
               if (result.Vtype=gvInteger) and (gvariant.VType=gvInteger)
                 then result.Vinteger:=result.Vinteger div gvariant.Vinteger
                 else sortieErreur('Unexpected type');
               finally
                 gvariant.finalize;
               end;
             end;

    Opmod:   begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);
               try
               if (result.Vtype=gvInteger) and (gvariant.VType=gvInteger)
                 then result.Vinteger:=result.Vinteger mod gvariant.Vinteger
                 else sortieErreur('Unexpected type');
               finally
                 gvariant.finalize;
               end;
             end;

    OpAnd:   begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);

               try
               if (result.Vtype=gvInteger) and (gvariant.VType=gvInteger)
                 then result.Vinteger:=result.Vinteger and gvariant.Vinteger
               else
               if (result.Vtype=gvBoolean) and (gvariant.VType=gvBoolean)
                 then result.Vboolean:=result.Vboolean and gvariant.Vboolean

               else sortieErreur('Unexpected type');
               finally
                 gvariant.finalize;
               end;
             end;

    OpOr:    begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);

               try
               if (result.Vtype=gvInteger) and (gvariant.VType=gvInteger)
                 then result.Vinteger:=result.Vinteger OR gvariant.Vinteger
               else
               if (result.Vtype=gvBoolean) and (gvariant.VType=gvBoolean)
                 then result.Vboolean:=result.Vboolean OR gvariant.Vboolean
               else sortieErreur('Unexpected type');
               finally
                 gvariant.finalize;
               end;
             end;

    Opxor:   begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);

               try
               if (result.Vtype=gvInteger) and (gvariant.VType=gvInteger)
                 then result.Vinteger:=result.Vinteger XOR gvariant.Vinteger
               else
               if (result.Vtype=gvBoolean) and (gvariant.VType=gvBoolean)
                 then result.Vboolean:=result.Vboolean XOR gvariant.Vboolean
               else sortieErreur('Unexpected type');
               finally
                 gvariant.finalize;
               end;
             end;


    OPshl:   begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);

               try
               if (result.Vtype=gvInteger) and (gvariant.VType=gvInteger)
                 then result.Vinteger:=result.Vinteger SHL gvariant.Vinteger
               else sortieErreur('Unexpected type');
               finally
                 gvariant.finalize;
               end;
             end;

    Opshr:   begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);

               try
               if (result.Vtype=gvInteger) and (gvariant.VType=gvInteger)
                 then result.Vinteger:=result.Vinteger SHR gvariant.Vinteger
               else sortieErreur('Unexpected type');
               finally
                 gvariant.finalize;
               end;
             end;

    egalV:   begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);
               try
               case result.Vtype of
                 gvInteger:  case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vinteger=gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vinteger=gvariant.Vfloat;
                               gvComplex: result.Vboolean:=EqualCpx(FloatToCpx(result.Vinteger),gvariant.Vcomplex);
                               else sortieErreur('Unexpected type');
                             end;
                 gvFloat:    case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vfloat=gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vfloat=gvariant.Vfloat;
                               gvComplex: result.Vboolean:=EqualCpx(FloatToCpx(result.Vfloat),gvariant.Vcomplex);
                               else sortieErreur('Unexpected type');
                             end;
                 gvComplex:  case gvariant.VType of
                               gvInteger: result.Vboolean:=EqualCpx(result.Vcomplex,FloatToCpx(gvariant.Vinteger));
                               gvFloat:   result.Vboolean:=EqualCpx(result.Vcomplex,FloatToCpx(gvariant.Vfloat));
                               gvComplex: result.Vboolean:=EqualCpx(result.Vcomplex,gvariant.Vcomplex);
                               else sortieErreur('Unexpected type');
                             end;

                 gvBoolean:  case gvariant.VType of
                               gvBoolean: result.Vboolean:=result.Vboolean=gvariant.Vboolean;
                               else sortieErreur('Unexpected type');
                             end;
                 gvString:   case gvariant.VType of
                               gvString: result.Vboolean:=result.Vstring=gvariant.Vstring;
                               else sortieErreur('Unexpected type');
                             end;

                 else sortieErreur('Unexpected type');
               end;
               finally
                 gvariant.finalize;
               end;
             end;

    differentV:
             begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);

               try
               case result.Vtype of
                 gvInteger:  case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vinteger<>gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vinteger<>gvariant.Vfloat;
                               gvComplex: result.Vboolean:=not EqualCpx(FloatToCpx(result.Vinteger),gvariant.Vcomplex);
                               else sortieErreur('Unexpected type');
                             end;
                 gvFloat:    case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vfloat<>gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vfloat<>gvariant.Vfloat;
                               gvComplex: result.Vboolean:=not EqualCpx(FloatToCpx(result.Vfloat),gvariant.Vcomplex);
                               else sortieErreur('Unexpected type');
                             end;
                 gvComplex:  case gvariant.VType of
                               gvInteger: result.Vboolean:=not EqualCpx(result.Vcomplex,FloatToCpx(gvariant.Vinteger));
                               gvFloat:   result.Vboolean:=not EqualCpx(result.Vcomplex,FloatToCpx(gvariant.Vfloat));
                               gvComplex: result.Vboolean:=not EqualCpx(result.Vcomplex,gvariant.Vcomplex);
                               else sortieErreur('Unexpected type');
                             end;

                 gvBoolean:  case gvariant.VType of
                               gvBoolean: result.Vboolean:=result.Vboolean<>gvariant.Vboolean;
                               else sortieErreur('Unexpected type');
                             end;
                 gvString:   case gvariant.VType of
                               gvString: result.Vboolean:=result.Vstring<>gvariant.Vstring;
                               else sortieErreur('Unexpected type');
                             end;

                 else sortieErreur('Unexpected type');
               end;
               finally
                 gvariant.finalize;
               end;
             end;

    infV:   begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);

               try
               case result.Vtype of
                 gvInteger:  case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vinteger<gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vinteger<gvariant.Vfloat;
                               else sortieErreur('Unexpected type');
                             end;
                 gvFloat:    case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vfloat<gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vfloat<gvariant.Vfloat;
                               else sortieErreur('Unexpected type');
                             end;
                 gvString:   case gvariant.VType of
                               gvString: result.Vboolean:=result.Vstring<gvariant.Vstring;
                               else sortieErreur('Unexpected type');
                             end;

                 else sortieErreur('Unexpected type');
               end;
               finally
                 gvariant.finalize;
               end;
             end;


    infegalV:begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);

               try
               case result.Vtype of
                 gvInteger:  case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vinteger<=gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vinteger<=gvariant.Vfloat;
                               else sortieErreur('Unexpected type');
                             end;
                 gvFloat:    case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vfloat<=gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vfloat<=gvariant.Vfloat;
                               else sortieErreur('Unexpected type');
                             end;
                 gvString:   case gvariant.VType of
                               gvString: result.Vboolean:=result.Vstring<=gvariant.Vstring;
                               else sortieErreur('Unexpected type');
                             end;

                 else sortieErreur('Unexpected type');
               end;
               finally
                 gvariant.finalize;
               end;
             end;

    supV:    begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);

               try
               case result.Vtype of
                 gvInteger:  case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vinteger>gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vinteger>gvariant.Vfloat;
                               else sortieErreur('Unexpected type');
                             end;
                 gvFloat:    case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vfloat>gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vfloat>gvariant.Vfloat;
                               else sortieErreur('Unexpected type');
                             end;
                 gvString:   case gvariant.VType of
                               gvString: result.Vboolean:=result.Vstring>gvariant.Vstring;
                               else sortieErreur('Unexpected type');
                             end;

                 else sortieErreur('Unexpected type');
               end;
               finally
                 gvariant.finalize;
               end;
             end;

    supegalV:begin
               inc(intG(Plex));
               EvaluerVariant(result);
               gvariant.init;
               EvaluerVariant(Gvariant);

               try
               case result.Vtype of
                 gvInteger:  case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vinteger<=gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vinteger<=gvariant.Vfloat;
                               else sortieErreur('Unexpected type');
                             end;
                 gvFloat:    case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vfloat<=gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vfloat<=gvariant.Vfloat;
                               else sortieErreur('Unexpected type');
                             end;
                 gvString:   case gvariant.VType of
                               gvString: result.Vboolean:=result.Vstring<=gvariant.Vstring;
                               else sortieErreur('Unexpected type');
                             end;

                 else sortieErreur('Unexpected type');
               end;
               finally
                 gvariant.finalize;
               end;
             end;
  end;
end;


function evaluerDateTime:TdateTime;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,Apos,nb64:integer;
  param64: Pparam64;
  p:pointer;
  typ:typeNombre;
  gvariant:TGVariant;

begin
  fillchar(result,sizeof(result),0);
  case Plex^.genre of
    fonc:    begin
               nbParam:=Plex^.nbParP;
               adresseV:=adProc^[Plex^.NumProced];
               inc(intG(Plex),foncSize);

               empilerParam64(nbParam,nil,Apos,param64,nb64);
               p:= CallAsm64(adresseV,nb64, param64^) ;
               result:=param64^[1].dd;
               stack0.clean(Apos);
             end;

    foncU:   begin
               appelProcU(true,p);
               result:=PdateTime(intG(p)-8)^;
             end;

    variDateTime,variLocDateTime,refLocDateTime:
            begin
               result:=PdateTime(evaluerAd(typ))^;
            end;

    cvVariantDateTime:
           try
             inc(intG(Plex));
             gvariant.init;
             EvaluerVariant(gvariant);
             if gvariant.VType=gvDateTime
               then result:=gvariant.VdateTime
               else sortieErreur('TdateTime expected');
           finally
             gvariant.finalize;
           end;
  end;
end;



{***************************************************************************}
{*************************** ExÃ©cution *************************************}
{***************************************************************************}




procedure executerProcU(isFunction:boolean);
var
  bid:pointer;
begin
  AppelProcU(isFunction,bid);
end;

procedure executerProcedure;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,Apos,nb64:integer;
  param64: Pparam64;
begin
  nbParam:=Plex^.nbParP;
  adresseV:=adProc^[Plex^.NumProced];

  if Plex^.genre=fonc
    then inc(intG(Plex),foncSize)
    else inc(intG(Plex),procedSize);

  empilerParam64(nbParam,nil,Apos,param64,nb64);
  CallAsm64(adresseV,nb64, param64^) ;
  stack0.clean(Apos);

end;


procedure executerFonc;
var
  i:  integer;
  i64:int64;
  x:  float;
  w:  TfloatComp;
  gv: Tgvariant;
  dt: TdateTime;
  b:  boolean;
  ch: AnsiChar;
  st: AnsiString;

begin
  case Plex^.tpRes of
    nbNul:                                        executerProcedure;
    nbByte,nbShort,nbSmall,nbWord,nbLong,nbDword: i:= evaluerI;
    nbInt64:                                      i64:= evaluerInt64;
    nbSingle,nbdouble,nbExtended:                 x:= evaluerR;
    nbSingleComp,nbDoubleComp,nbExtComp:          w:= evaluerComp;
    nbVariant:                                    evaluerVariant(gv);
    nbDateTime:                                   dt:= evaluerDateTime;
    nbBoole:                                      b := evaluerB;
    nbchar:                                       ch:= evaluerChar;
    nbChaine,nbAnsiString:                        st:= evaluerC;
  end;
end;




procedure executerAffectVAR;
var
  Pdest:ptUlex;
  z1:TfloatComp;
  adresseV,adresseV1:pointer;
  lenC:integer;
  typ:typeNombre;

begin
  inc(intG(Plex));
  Pdest:=Plex;

  adresseV:=evaluerAd(typ,lenC);        { Adresse destination }
  case typ of
     nbByte:    Pbyte(adresseV)^:=evaluerI;
     nbShort:   Pshort(adresseV)^:=evaluerI;
     nbSmall:   Psmallint(adresseV)^:=evaluerI;
     nbWord:    Pword(adresseV)^:=evaluerI;
     nbLong:    Plongint(adresseV)^:=evaluerI;
     nbDWord:   Plongword(adresseV)^:=evaluerI;

     nbInt64:   Pint64(adresseV)^:=evaluerInt64;

     nbSingle:  Psingle(adresseV)^:=evaluerR;
     nbDouble:  Pdouble(adresseV)^:=evaluerR;
     nbExtended:Pfloat(adresseV)^:=evaluerR;

     nbSingleComp: begin
                     z1:=evaluerComp;
                     PsingleComp(adresseV)^.x:=z1.x;
                     PsingleComp(adresseV)^.y:=z1.y;
                   end;
     nbDoubleComp, nbExtComp:
                   begin
                     z1:=evaluerComp;
                     PfloatComp(adresseV)^:=z1
                   end;

     nbvariant:    begin
                     if Pdest^.dep<0 then localVariants.add(adresseV); {variable locale Variant}

                     evaluerVariant(PGvariant(adresseV)^);
                     PGvariant(adresseV)^.AdjustObject;
                   end;

     nbDateTime:    begin
                     PdateTime(adresseV)^:=evaluerDateTime;
                   end;

     nbBoole:  Pboolean(adresseV)^:=evaluerB;
     nbChar:   Pchar0(adresseV)^:=evaluerChar;
     nbChaine: PShortString(adresseV)^:=copy(evaluerC,1,lenC);

     nbAnsiString:
               begin
                 if (Pdest^.genre =variLocANSIstring) and (Pdest^.dep<0) and (localStrings.IndexOf(adresseV)<0)
                   then localStrings.add(adresseV);         {variable locale AnsiString }
                 PansiString(adresseV)^:=evaluerC;
               end;
     nbDef:    begin
                 adresseV1:=evaluerAd(typ);
                 move(adresseV1^,adresseV^,defSize);
               end;

     nbAbs:    Ppointer(adresseV)^:=evaluerAd(typ);
               {permet de calculer l'ad d'un objet indirect }

  end;
end;

procedure executerGoto;
begin
  {intG(Plex):=Plex^.adresse;}
  inc(intG(Plex),Plex^.adresse);
end;

procedure executerIf;
begin
  inc(intG(Plex));
  if evaluerB then inc(intG(Plex),gotoSize);
end;

procedure executerWhile;
var
  i:longint;
  ad:pointer;
  long:boolean;
  Pcondition, Pstart, Pend: PtUlex;
  w:boolean;
  i1,i2:longint;
  typ:typeNombre;
begin
  Pcondition:=Plex;
  inc(intG(Pcondition),WhileSize);

  Pstart:=Plex;
  inc(intG(Pstart),Plex^.StartWhile);

  Pend:=Plex;
  inc(intG(Pend),Plex^.EndWhile);

  repeat
    Plex:=Pcondition;
    w:= evaluerB;

    if w and not flagExit and not FlagBreak and not FinExe and not FinExeU^ then
    begin
      Plex:=Pstart;
      while  (intG(Plex)<intG(Pend)) and not FinEXE and not flagExit and not FlagBreak do
      executerInstruction;
    end
    else break;
  until false;
  FlagBreak:=false;
  Plex:=Pend;
end;

procedure executerRepeat;
var
  Pstart, Pfinal, Pend: PtUlex;
  w:boolean;
  typ:typeNombre;
begin
  Pstart:=Plex;
  inc(intG(Pstart),RepeatSize);

  Pend:=Plex;
  inc(intG(Pend),Plex^.EndRepeat);

  Pfinal:=Plex;
  inc(intG(Pfinal),Plex^.FinalRepeat);

  repeat
    Plex:=Pstart;
    while  (intG(Plex)<intG(Pend)) and not FinEXE and not FinExeU^ and not flagExit and not FlagBreak do
      executerInstruction;
    if not FinEXE and not FinExeU^ and not flagExit and not FlagBreak then w:=evaluerB;
  until  w or flagExit or FlagBreak or FinExe or FinExeU^;

  FlagBreak:=false;
  Plex:=Pfinal;
end;


procedure executerForUp;
var
  i:longint;
  ad:pointer;
  long:boolean;
  Pfin:ptUlex;
  P1:ptUlex;
  i1,i2:longint;
  typ:typeNombre;
begin
  Pfin:=Plex;
  inc(intG(Pfin),Plex^.depfin);
  inc(intG(Plex),forSize);

  long:=(Plex^.genre=variL) or
        (Plex^.genre=variLocL) or (Plex^.genre=refLocL);
  ad:=evaluerAd(typ);

  i1:=evaluerI;
  i2:=evaluerI;
  P1:=Plex;

  i:=i1;
  while (i<=i2) and not flagExit and not FlagBreak and not FinExe and not FinExeU^ do
  begin
    Plex:=P1;
    if long then Plongint(ad)^:=i
            else Psmallint(ad)^:=i;
    while  (intG(Plex)<intG(Pfin)) and not FinEXE and not FinExeU^ and not flagExit and not FlagBreak do
      executerInstruction;
    i:=i+1;
  end;
  FlagBreak:=false;
  Plex:=Pfin;
end;

procedure executerForDw;
var
  i:longint;
  ad:pointer;
  long:boolean;
  Pfin:ptUlex;
  P1:ptUlex;
  i1,i2:longint;
  typ:typeNombre;
begin
  Pfin:=Plex;
  inc(intG(Pfin),Plex^.depfin);
  inc(intG(Plex),forSize);

  long:=(Plex^.genre=variL) or
        (Plex^.genre=variLocL) or (Plex^.genre=refLocL);
  ad:=evaluerAd(typ);

  i1:=evaluerI;
  i2:=evaluerI;
  P1:=Plex;

  i:=i1;
  while (i>=i2) and not flagExit and not flagBreak and not FinExe and not FinExeU^ do
  begin
    Plex:=P1;
    if long then Plongint(ad)^:=i
            else Psmallint(ad)^:=i;
    while (intG(Plex)<intG(Pfin)) and not FinEXE and not FinExeU^ and not flagExit and not flagBreak do
      executerInstruction;
    i:=i-1;
  end;
  FlagBreak:=false;
  Plex:=Pfin;
end;


procedure ExecuterCase;
var
  Pcase:PtrCase;
  i,k:integer;
  adresse,adresseCase,PlexFinI:ptUlex;
begin
  adresseCase:=Plex;

  Pcase:=pointer(Plex);
  inc(intG(Pcase),Plex^.depfin);

  adresse:=Plex;
  PlexFinI:=Plex;

  inc(intG(Plex),caseSize);
  k:=evaluerI;

  with Pcase^ do
  begin
    {messageCentral(Istr(nbcase)+' '+Istr(depElse)+' '+Istr(depFinCase) );}
    i:=1;
    while (i<=nbcase) and ((k<cas[i].cte1) or (k>cas[i].cte2)) do inc(i);
    if i>nbcase then
      begin
        inc(intG(adresse),depElse);
        inc(intG(PlexFinI),depFinCase);
      end
    else
      begin
        inc(intG(adresse),cas[i].adk1);
        inc(intG(PlexFinI),cas[i].adk2);
      end;
  end;
  if adresse<>adresseCase then    { Ã©gal si pas de else }
    begin
      Plex:=adresse;
      while  (Plex<>PlexFinI) and not FinExe and not FinExeU^ and not flagExit and not FlagBreak do
        executerInstruction;
    end;

  Plex:=pointer(PCase);
  inc(intG(Plex),TableCaseSize+Pcase^.nbCase*sizeof(typecas));
end;

procedure ExecuterInc;
var
  P:ptUlex;
  adresseV:pointer;
  typ:typeNombre;
begin
  inc(intG(Plex));
  P:=Plex;

  adresseV:=evaluerAd(typ);

  case typ of
    nbByte:   inc( Pbyte(adresseV)^);
    nbShort:  inc( Pshort(adresseV)^);
    nbSmall:  inc( Psmallint(adresseV)^);
    nbWord:   inc( Pword(adresseV)^);
    nbLong:   inc( Plongint(adresseV)^);
    nbDWord:  inc( Plongword(adresseV)^);
  end;
end;

procedure ExecuterDec;
var
  P:ptUlex;
  adresseV:pointer;
  typ:typeNombre;
begin
  inc(intG(Plex));
  P:=Plex;

  adresseV:=evaluerAd(typ);

  case typ of
    nbByte:   dec( Pbyte(adresseV)^);
    nbShort:  dec( Pshort(adresseV)^);
    nbSmall:  dec( Psmallint(adresseV)^);
    nbWord:   dec( Pword(adresseV)^);
    nbLong:   dec( Plongint(adresseV)^);
    nbDWord:  dec( Plongword(adresseV)^);
  end;
end;

procedure executerInstruction;
  begin
    if finEXE or FinExeU^ then exit;
    if assigned(ElphyDebugPg) then
    begin
      ElphyDebugPg(Plex,ProcUON,CurrentProc);
      if finExe or finExeU^ then exit;
    end;

    case Plex^.genre of
      AffectVar:   executerAffectVAR;
      proced:      executerProcedure;
      fonc:        executerFonc;
      procU:       executerProcU(false);
      foncU:       executerProcU(true);
      motgoto:     executerGoto;
      motIF:       executerIF;
      forUp:       executerForUp;
      forDw:       executerForDw;
      motWhile:    executerWhile;
      motRepeat:   executerRepeat;
      motCase:     executerCase;

      motInc:      executerInc;
      motDec:      executerDec;

      stop:        finEXE:=true;
      motExit:     if procUON>0
                      then flagExit:=true
                      else finExe:=true;

      motBreak:    begin
                     FlagBreak:=true;
                     inc(IntG(Plex));
                   end;
      IfBreak:     if FlagBreak then
                   begin
                     FlagBreak:=false;
                     ExecuterGoto;
                   end
                   else inc(intG(Plex),5);

      pushI:       begin
                     dec(regSP,8);
                     inc(intG(Plex));
                   end;

      popI:        begin
                     inc(regSP,8);
                     inc(intG(Plex));
                   end;
    end;

    if testerFinExe then
      begin
        finExe:=true;
        finExeU^:=true;
      end;
  end;


procedure AllocateStack(size:integer);
begin
  stackSize:=size;
  getmem(stackSeg,stackSize);
  regSS:=intG(stackseg);
  regSP:=stackSize;
  regBP:=regSP;
  {messageCentral('StackSeg='+longToHexa(intG(stackSeg)));}

  stack0.init(10000);
end;

procedure executerProg0;
begin
  try
    repeat
      executerInstruction;
    until finEXE or FinExeU^;

  except
    on E:exception do
      begin

        if errorOut=0 then ErrorExe:=1 else errorExe:=errorOut;
        errorEXEMsg:= E.Message;
        AdresseErreurEXE:=Plex;
      end;
  end;
end;

function rien:boolean;
begin
  result:=false;
end;

(*
type
  TthreadExe=class(Tthread)
                constructor create;
                procedure DoInst;
                procedure Execute; override;
             end;

var
  ThreadExe:TthreadExe;

constructor TthreadExe.create;
begin
  FreeOnTerminate:=true;
  inherited create(false);
end;

procedure TthreadExe.DoInst;
begin
  executerInstruction;
end;

procedure TthreadExe.Execute;
begin
  try
    repeat
      synchronize(DoInst);
    until finEXE;

  except
    on E:exception do
      begin
        if errorOut=0 then ErrorExe:=1 else errorExe:=errorOut;
        errorEXEMsg:= E.Message;
        AdresseErreurEXE:=Plex;
      end;
  end;

end;

procedure ExecuterProg0Thread;
begin
  ThreadExe:=TthreadExe.Create;
end;
*)


function executerProg(cs,ds:pointer;prog:pointer;var error,ad:integer;var finExeU1: boolean;
                       adp:PtabPointer1;stp:TstartProc;trm:TterminateProc;LocStrings,LocVariants:Tlist;
                       ElphyDebug: TElphyDebugPg): boolean;
var
  oldPlex:PtUlex;
  oldfinEXE,oldflagExit, oldFlagBreak:boolean;
  oldprocUON:integer;
  oldCurrentProc: integer;

  oldregCS, oldregDS, oldregSP, oldRegBP:intG;
  oldAdP:PtabPointer1;
  oldExeOn:boolean;

  oldStartProc:TstartProc;
  oldTerminateProc:TTerminateProc;
  oldLocalStrings,oldLocalVariants:Tlist;

  oldStackPos:integer;
  OldElphyDebugPg: TelphyDebugPg;
begin
  if stackSize=0 then allocateStack(500000);
  if not assigned(testerFinExe) then testerFinExe:=rien;

  oldfinEXE:=finExe;
  oldflagExit:=flagExit;
  oldflagBreak:=flagBreak;
  oldprocUON:=procUon;
  oldCurrentProc:= CurrentProc;

  oldregCS:=regCS;
  oldregDS:=regDS;
  oldregSP:=regSP;
  oldregBP:=regBP;

  oldPlex:=Plex;
  oldAdp:=adProc;
  oldExeOn:=exeOn;

  oldStackPos:=stack0.getPos;

  oldStartProc:=StartProc;
  oldTerminateProc:=TerminateProc;
  oldLocalStrings:=LocalStrings;
  oldLocalVariants:=LocalVariants;

  StartProc:=stp;
  TerminateProc:=trm;
  LocalStrings:=LocStrings;
  LocalVariants:=LocVariants;

  finEXE:=false;
  finExeU:=@finExeU1;
  flagExit:=false;
  flagBreak:=false;
  procUON:=0;
  CurrentProc:=0;
  exeON:=true;

  regCS:=intG(cs);
  regDS:=intG(ds);
  Plex:= prog; //ptrG(regCS,prog);
  adProc:=adP;

  errorExe:=0;
  errorOut:=0;

  OldElphyDebugPg:= ElphyDebugPg;
  ElphyDebugPg:= ElphyDebug;

  executerProg0;

  error:=errorExe;
  ad:=intG(adresseErreurExe)-regCS-1;

  finEXE:=oldfinExe;
  flagExit:=oldflagExit;
  flagBreak:=oldflagBreak;

  procUON:=oldprocUon;
  CurrentProc:= OldCurrentProc;

  regCS:=oldregCS;
  regDS:=oldregDS;
  regSP:=oldRegSP;
  regBP:=oldRegBP;

  nettoyerPileAppel(0,OldStackPos);

  StartProc:=oldStartProc;
  TerminateProc:=oldTerminateProc;
  LocalStrings:=oldLocalStrings;
  LocalVariants:=oldLocalVariants;

  Plex:=oldPlex;
  adProc:=oldAdP;
  exeOn:=oldExeOn;

  ElphyDebugPg:= OldElphyDebugPg;
{  stack0.Clean(OldStackPos);}
end;

function getStdError:AnsiString;
begin
  result:=errorExeMsg;
end;

function getCurrentExeAd:integer;
begin
  result:=intG(Plex)-regCS-1;
end;


Initialization
AffDebug('Initialization Nexe64',0);

InitEvaluerAd;
InitEvaluerI;
InitEvaluerInt64;
InitEvaluerR;

finalization

freemem(stackSeg);

end.
