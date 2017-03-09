unit Nexe2;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysutils,
     util1,Ncdef2,debug0,Dgraphic,stmObj;


var
  StackSeg:pointer;
  stackSize:integer;

type
  TstartProc=procedure(var n1,n2,n3:integer) of object;
  TterminateProc=procedure (n1,n2,n3:integer) of object;

var
  RefObjectStack:Tlist;
  RefObjectTypes:Tlist;

{RefObjectStack contient la liste des variables objets passées comme paramètres à la procédure
 utilisateur active.
 RefObjectTypes contient leurs types.

 CreatePgObject utilise ces listes pour vérifier que le constructeur utilisé correspond bien
 au type de l'objet.

}
procedure AllocateStack(size:integer);
procedure executerProg(cs,ds:pointer;Prog:integer;var error,ad:integer;adp:PtabPointer1;
                       stp:TstartProc;trm:TterminateProc;LocStrings,LocVariants:Tlist);

function getStdError:string;
function getCurrentExeAd:integer;

procedure executerExtProc(prog:pointer);
function evaluerExtRfunc(prog:pointer):float;

var
  regSP:integer;
  regBP:integer;

  regSS:intG;
  regCS:intG;
  regDS:intG;


IMPLEMENTATION


Const
  maxString=2000;
var
  ChaineEmpilee:array[1..maxString] of PshortString;
  nbChaineEmpilee:Integer;

  AnsiEmpilee:array[1..maxString] of pointer;
  nbAnsi:integer;

  VariantStack:array of TGvariant;

  Plex:PtUlex;
  FlagExit:boolean;
  procUON:integer;



var
  errorEXEMsg:string[80];

  adProc:PtabPointer1;

  terminateProc:TterminateProc;
  StartProc:TstartProc;
  LocalStrings:Tlist;
  LocalVariants:Tlist;


function evaluerI:longint;forward;
function evaluerInt64:int64;forward;

function evaluerR:float;forward;
function evaluerComp:TfloatComp;forward;
function evaluerB:boolean;forward;
function evaluerC:String;forward;
function evaluerChar:char;forward;

procedure evaluerVariant(var result:TGvariant);forward;
function evaluerDateTime:TdateTime;forward;

function evaluerDep:integer;forward;

function evaluerAd(var typ:typeNombre):pointer;overload; forward;
function evaluerAd(var typ:typeNombre; var len:integer):pointer;overload; forward;



procedure executerInstruction;forward;



function ptrG(base,offset:intG):pointer;
  begin
    ptrG:=pointer(base+offset);
  end;


{$IFDEF WIN64}

type
  Tparam1=record
            case integer of
              1:(i:int64);
              2:(d:double);
            end;


  Tparam=array[1..40] of Tparam1;

function CallAsm64(ad:pointer;nb:int64;var param:Tparam): pointer;assembler;
var
  ad1:pointer;
  nb1:int64;
  param1:pointer;
  stackInc: int64;
  cnt1: int64;
asm
       mov ad1,  ad       // ad
       mov nb1, nb        // nb
       mov param1,param   // param


       mov  rax, nb1
       add  rax, 1        // un mot de plus (?)
       test eax, 1        // si impair, ajouter 1
       jz   @@0
       inc  rax
  @@0: shl  rax,3         // multiplier par 8

       mov  StackInc, rax

       sub  rsp, StackInc // On retranche un multiple de 16
                          // La pile est déjà alignée après le prologue
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
       movd xmm0, [rbx]   // param1 dans xmm0
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
       mov rdx, [rbx]     // param2 dans rdx
       jmp  @@p2b
  @@p2a:
       add param1,8
       mov rbx, param1
       movd xmm1, [rbx]   // param2 dans xmm1
  @@p2b:

       dec  nb1
       add  param1,8

       cmp  nb1,0
       jz   @@1

       mov rbx,param1
       cmp [rbx],0        // Test type de Param3
       jnz  @@p3a
       add param1,8
       mov rbx, param1
       mov r8, [rbx]      // param3 dans r8
       jmp  @@p3b
  @@p3a:
       add param1,8
       mov rbx, param1
       movd xmm2, [rbx]   // param3 dans xmm2
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
       movd xmm3, [rbx]   // param4 dans xmm3
  @@p4b:

       dec  nb1
       add  param1,16     // 16 pour sauter le type de param

       mov  cnt1,20h      // les autres params sont dans la pile

  @@2: cmp  nb1,0
       jz   @@1

       mov  rbx,param1
       mov  rax,[rbx]
       mov  rbx,cnt1

       mov  rsp[rbx], eax        // mov rsp[rbx],rax ne marche pas !!!!
       shr  rax,32
       mov  rsp[rbx+4], eax

       dec  nb1
       add  cnt1, 8
       add  param1,16
       jmp  @@2

  @@1:
       call ad1
       mov  rbx, stackInc
       add  rsp, rbx
end;

{$ENDIF}


procedure AppelProc(ad:pointer;var blocParam;size:Integer);assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;


function AppelFoncByte(ad:pointer;var blocParam;size:Integer):byte;assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;

function AppelFoncShort(ad:pointer;var blocParam;size:Integer):shortint;assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;

function AppelFoncSmall(ad:pointer;var blocParam;size:Integer):smallint;assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;

function AppelFoncWord(ad:pointer;var blocParam;size:Integer):word;assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;

function AppelFoncLong(ad:pointer;var blocParam;size:integer):longint; assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;

function AppelFoncDword(ad:pointer;var blocParam;size:Integer):longword;assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;

function AppelFoncInt64(ad:pointer;var blocParam;size:Integer):longword;assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;


function AppelFoncSingle(ad:pointer;var blocParam;size:Integer):single;assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;

function AppelFoncReal48(ad:pointer;var blocParam;size:Integer):real48;assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;

function AppelFoncDouble(ad:pointer;var blocParam;size:Integer):double;assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;

function AppelFoncExtended(ad:pointer;var blocParam;size:Integer):extended;assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;

function AppelFoncSingleComp(ad:pointer;var blocParam;size:Integer):TsingleComp;assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;

function AppelFoncDoubleComp(ad:pointer;var blocParam;size:Integer):TdoubleComp;assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;


function AppelFoncB(ad:pointer;var blocParam;size:Integer):boolean;assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;

(* jamais utilisée
function AppelFoncC(ad:pointer;var blocParam;size:Integer):ShortString;assembler;pascal;
asm
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
end;
*)

{$IFDEF FPC}
function AppelFoncString(ad:pointer;var blocParam;size:integer):string; assembler;pascal;
asm
{$IFNDEF WIN64}
    mov   edx, size
    mov   ecx,blocParam
  @@1:
    cmp   edx, 0
    jle    @@2
    dec   edx
    dec   edx

    mov   ax, word ptr ds:[ecx+edx]
    push  ax
    jmp   @@1
  @@2:
    call  ad
{$ENDIF}
end;
{$ENDIF}

procedure empilerAppel(var t;taille:integer;chaine:boolean);
  begin
    if taille>regSP then sortieErreur(E_pile);
    dec(regSP,taille);
    move(t,ptrG(regSS,regSP)^,taille);
    if chaine then
      begin
        inc(nbChaineEmpilee);
        if nbChaineEmpilee>maxString then sortieErreur('Too many strings in stack');
        ChaineEmpilee[nbChaineEmpilee]:=pointer(t);
      end;
  end;


procedure empilerAnsiString(st:string);
var
  p:pointer;
begin
  if 4>regSP then sortieErreur(E_pile);
  dec(regSP,4);
  p:=ptrG(regSS,regSP);
  Ppointer(p)^:=nil;
  PansiString(p)^:=st;

  inc(nbAnsi);
  if nbAnsi>maxString then sortieErreur('Too many ANSI strings in stack');
  AnsiEmpilee[nbAnsi]:=p;
end;



procedure nettoyerPileAppel(taille,nbCh1,nbch2,nbvr:integer);
var
  i:integer;
begin
  inc(regSP,taille);

  for i:=nbChaineEmpilee downTo nbChaineEmpilee-nbCh1+1 do
    freemem(chaineEmpilee[i]);
  dec(nbChaineEmpilee,nbCh1);

  for i:=nbAnsi downto nbAnsi-nbCh2+1 do
    PAnsiString(AnsiEmpilee[i])^:='';

  dec(nbAnsi,nbCh2);

  for i:=high(variantStack) downto high(variantStack)-nbvr+1 do
  begin
    {variantStack[i].showStringInfo;}
    variantStack[i].finalize;
  end;
  setlength(variantStack,length(variantStack)-nbvr);
end;




procedure empilerVariant(var vr:TGvariant);
var
  p:pointer;
begin
  setlength(variantStack,length(variantStack)+1);
  fillchar(variantStack[high(variantStack)],sizeof(TGvariant),0);

  variantStack[high(variantStack)]:=vr;
  {move(vr,variantStack[high(variantStack)],sizeof(vr));}

  variantStack[high(variantStack)].AdjustObject;

  {variantStack[high(variantStack)].showStringInfo;}

  p:=@variantStack[high(variantStack)];
  empilerAppel(p,4,false);
end;


(*
function evaluerDep:integer;
  var
    i,n,nb:Integer;
    mini,maxi:Integer;
    dep:integer;
  begin
    dep:=0;
    inc(intG(Plex));        { motArray }
    nb:=Plex^.vnbi;            { nbRang   }
    inc(intG(Plex),3);
    for i:=1 to nb do
      begin
        mini:=Plex^.vnbi;      { min }
        inc(intG(Plex),3);
        maxi:=Plex^.vnbi;      { max }
        inc(intG(Plex),3);
        n:=evaluerI;           { indice }
        if (n<mini) or (n>maxi) then sortieErreur(E_indiceTableau);
        dep:=dep*(maxi-mini+1)+n-mini;
      end;
    evaluerDep:=dep;
  end;
*)

function evaluerDep:integer;
var
  i,n,nb:Integer;
  dep:integer;
  PA:ptUlex;
begin
  dep:=0;
  PA:=Plex;
  inc(intG(Plex),9+Plex^.MAnbr*sizeof(typeMinMax));        { motArray }

  for i:=1 to PA^.MAnbR do
    begin
      n:=evaluerI;           { indice }
      with PA^.MA[i] do
      begin
        if (n<mini) or (n>maxi) then sortieErreur(E_indiceTableau);
        dep:=dep*(maxi-mini+1)+n-mini;
      end;
    end;
  evaluerDep:=dep*PA^.MAsize;;
end;


procedure empilerParametres(nbParam:smallInt;var tailleP,nbCh1,nbCh2,nbvr:integer;verifObj:boolean);
   forward;

function evaluerFoncAd:pointer;
  var
    adresseV:pointer;
    nbparam:integer;
    tailleP,nbCh1,nbch2,nbvr:integer;
  begin
    nbParam:=Plex^.nbParP;
    adresseV:=adProc^[Plex^.NumProced];
    {Pour code relogé: adresseV:=pointer(Plex^.NumProced); }
    inc(intG(Plex),7);
    empilerParametres(nbParam,tailleP,nbCh1,nbch2,nbvr,false);

    evaluerFoncAd:=pointer(AppelFoncLong(adresseV,ptrG(regSS,regSP)^,tailleP));

    nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
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

function EvaluerAd(var typ:typeNombre;var len:integer):pointer;
var
  adresseV:pointer;
  p:ptUlex;
  Vob,Vob1:integer;
begin
  p:=Plex;
  case Plex^.genre of
    stChar:  begin
               adresseV:=evaluerDepChar;
               typ:=nbChar;
             end;

    variByte..variChar,variAnsiString:
             begin
               typ:=typeVar[Plex^.genre];
               adresseV:=ptrG(regDS,Plex^.adv);
               inc(intG(Plex),variIsize);
               if Plex^.genre=motArray then
                 inc(intG(adresseV),evaluerDep);

               if (Plex^.genre=CV) and (p^.genre>=variSingleComp) and (p^.genre<=variExtComp) then
                 begin
                   inc(intG(adresseV),Plex^.CVdep);
                   typ:=Plex^.CVtp;
                   inc(intG(Plex),10);
                 end;
             end;

    variLocByte..variLocChar,variLocAnsiString:
             begin
               typ:=typeVar[Plex^.genre];
               adresseV:=ptrG(regSS,regBP+Plex^.dep);
               inc(intG(Plex),5);
               if Plex^.genre=motArray then
                 inc(intG(adresseV),evaluerDep);
               if (Plex^.genre=CV) and (p^.genre>=variLocSingleComp) and (p^.genre<=variLocExtComp) then
                 begin
                   inc(intG(adresseV),Plex^.CVdep);
                   typ:=Plex^.CVtp;
                   inc(intG(Plex),10);
                 end;
             end;

    refLocByte..refLocChar,refLocAnsiString:
             begin
               typ:=typeVar[Plex^.genre];
               adresseV:=pointer(ptrG(regSS,regBP+Plex^.dep)^);
               inc(intG(Plex),5);
               if Plex^.genre=motArray then
                 inc(intG(adresseV),evaluerDep);
               if (Plex^.genre=CV) and (p^.genre>=refLocSingleComp) and (p^.genre<=refLocExtComp) then
                 begin
                   inc(intG(adresseV),Plex^.CVdep);
                   typ:=Plex^.CVtp;
                   inc(intG(Plex),10);
                 end;
             end;

    variC:  begin
               typ:=nbChaine;
               adresseV:=ptrG(regDS,Plex^.adv);
               inc(intG(Plex),variCsize);
               if Plex^.genre=motArray then
                 inc(intG(adresseV),evaluerDep);
               len:=p^.longC;
             end;

    variLocC:
            begin
              typ:=nbChaine;
              adresseV:=ptrG(regSS,regBP+Plex^.dep);
              inc(intG(Plex),6);
              if Plex^.genre=motArray then
                 inc(intG(adresseV),evaluerDep);
              len:=p^.longCloc;
            end;

    refLocC:
            begin
              typ:=nbChaine;
              if p^.longCloc1=0 then
                begin
                  adresseV:=pointer(ptrG(regSS,regBP+Plex^.dep+4)^);
                  len:=Pinteger(ptrG(regSS,regBP+Plex^.dep))^-1;
                end
              else
                begin
                  adresseV:=pointer(ptrG(regSS,regBP+Plex^.dep)^);
                  len:=255;
                end;
              inc(intG(Plex),6);
              if Plex^.genre=motArray then
                inc(intG(adresseV),evaluerDep);
            end;


    variDef:
             begin
               typ:=nbDef;
               defSize:=Plex^.sz;
               adresseV:=ptrG(regDS,Plex^.adv);
               inc(intG(Plex),10);
               while (Plex^.genre=motArray) or (Plex^.genre=CV) or (Plex^.genre=cvObj) do
               begin
                 if Plex^.genre=motArray then
                   inc(intG(adresseV),evaluerDep);
                 if Plex^.genre=CV then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=Plex^.CVtp;
                     defSize:=Plex^.CVsz;
                     len:=defSize-1;           { pour nbChaine }
                     inc(intG(Plex),10);
                   end;
                 if Plex^.genre=CVobj then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=refObject;
                     inc(intG(Plex),7);
                   end;
               end;
             end;

    variLocDef:
             begin
               typ:=nbDef;
               defSize:=Plex^.sz;
               adresseV:=ptrG(regSS,regBP+Plex^.dep);
               inc(intG(Plex),9);
                while (Plex^.genre=motArray) or (Plex^.genre=CV) or (Plex^.genre=cvObj) do
               begin
                 if Plex^.genre=motArray then
                   inc(intG(adresseV),evaluerDep);
                 if Plex^.genre=CV then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=Plex^.CVtp;
                     defSize:=Plex^.CVsz;
                     len:=defSize-1;           { pour nbChaine }
                     inc(intG(Plex),10);
                   end;
                 if Plex^.genre=CVobj then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=refObject;
                     inc(intG(Plex),7);
                   end;
               end;
             end;

    refLocDef:
             begin
               typ:=nbDef;
               defSize:=Plex^.sz;
               adresseV:=pointer(ptrG(regSS,regBP+Plex^.dep)^);
               inc(intG(Plex),9);
                while (Plex^.genre=motArray) or (Plex^.genre=CV) or (Plex^.genre=cvObj) do
               begin
                 if Plex^.genre=motArray then
                   inc(intG(adresseV),evaluerDep);
                 if Plex^.genre=CV then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=Plex^.CVtp;
                     defSize:=Plex^.CVsz;
                     len:=defSize-1;           { pour nbChaine }
                     inc(intG(Plex),10);
                   end;
                 if Plex^.genre=CVobj then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=refObject;
                     inc(intG(Plex),7);
                   end;
               end;
             end;


    variObject:
            begin
              typ:=refObject;
              adresseV:=ptrG(regDS,Plex^.adOb);
              inc(intG(Plex),7);
              if Plex^.genre=motArray then
                inc(intG(adresseV),evaluerDep);
            end;

    refAbs:
            begin
              typ:=nbAbs;
              if Plex^.dep>0
                then adresseV:=ptrG(regSS,Plex^.dep)
                else adresseV:=ptrG(regSS,regBP+Plex^.dep);
              {Donne une adresse dans la pile}
              inc(intG(Plex),5);
            end;

    TPObjectInd:
            begin
              typ:=refObject;
              if Plex^.depTPO>0
                then adresseV:=Ppointer(regSS+Plex^.depTPO)^
                else adresseV:=Ppointer(regSS+regBP+Plex^.depTPO)^;
              {Dans la pile se trouve le déplacement d'une variable objet dans le
               segment de données}
              inc(intG(Plex),5);
            end;
    TPInd:
            begin
              typ:=Plex^.tpInd1;
              defSize:=Plex^.szInd;
              adresseV:=Ppointer(regSS+regBP+Plex^.depInd)^;
              {Dans la pile se trouve le déplacement d'une variable objet dans le
               segment de données}
              inc(intG(Plex),10);

              while (Plex^.genre=motArray) or (Plex^.genre=CV) or (Plex^.genre=cvObj) do
               begin
                 if Plex^.genre=motArray then
                   inc(intG(adresseV),evaluerDep);
                 if Plex^.genre=CV then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=Plex^.CVtp;
                     defSize:=Plex^.CVsz;
                     len:=defSize-1;
                     inc(intG(Plex),10);
                   end;
                 if Plex^.genre=CVobj then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=refObject;
                     inc(intG(Plex),7);
                   end;
               end;
            end;

    refLocObject:
            begin
              typ:=refObject;
              adresseV:=pointer(ptrG(regSS,regBP+Plex^.dep)^);
              inc(intG(Plex),6);
              if Plex^.genre=motArray then
                inc(intG(adresseV),evaluerDep);
             end;

    variLocObject:
            begin
              typ:=refObject;
              adresseV:=ptrG(regSS,regBP+Plex^.dep);
              inc(intG(Plex),6);
              if Plex^.genre=motArray then
                inc(intG(adresseV),evaluerDep);
             end;

    fonc:  begin
             typ:=refProcedure;
             adresseV:=evaluerFoncAd;
           end;

    refSys:begin
             typ:=Plex^.tpSys;
             adresseV:=Plex^.adSys;
             defSize:=Plex^.szSys;
             inc(intG(Plex),10);
           end;

    motNil:begin
             adresseV:=@VarNil;
             inc(intG(Plex));
           end;

    cvVariantObject:
           begin
             Vob:=Plex^.VObVariant; {type souhaité}
             inc(intG(Plex),2);
             adresseV:=EvaluerAd(typ);
             adresseV:=PGvariant(adresseV)^.VarAddress;
             if not assigned(adresseV) or not assigned(PPUO(adresseV)^)
               then sortieErreur('Cannot convert variant');
             if not PPUO(adresseV)^.PgChildOf(Vob)
               then sortieErreur('Invalid Object Type');

             typ:=refObject;
           end;

    else adresseV:=nil;

  end;

  Result:=adresseV;
end;

function EvaluerAd(var typ:typeNombre):pointer;
var
  len:integer;
begin
  result:=EvaluerAd(typ,len);
end;


{ VerifObj vaut TRUE pour les procédures utilisateurs uniquement
}
procedure empilerParametres(nbParam:smallInt;var tailleP,nbCh1,nbch2,nbvr:integer;VerifObj:boolean);
var
  i:Integer;
  b1:boolean;
  c1:char;
  st1:String;
  pst:^ShortString;
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

  pzs:PsingleComp;
  pzd:PdoubleComp;
  pze:PfloatComp;

  typ:typeNombre;
  FlagRef:boolean;
  pRefObj:pointer;

  Gvariant:TGvariant;
  dateTime:TdateTime;
begin
  FlagRef:=false;
  tailleP:=0;
  nbCh1:=0;
  nbCh2:=0;
  nbvr:=0;
  for i:=1 to nbParam do
    begin
      tp:=Plex^.tpParam;
      inc(intG(Plex),2);
      case tp of
        RefByte..refChar,refAnsiString:
                    with Plex^ do
                    begin
                      p:=evaluerAd(typ);
                      empilerAppel(p,4,false);
                      inc(tailleP,4);
                    end;

        refObject:  with Plex^ do
                    begin
                      p:=evaluerAd(typ);

                      if VerifObj then
                      begin
                        FlagRef:=true;
                        PrefObj:=p;
                      end;

                      empilerAppel(p,4,false);
                      inc(tailleP,4);
                    end;

        refChaine:  with Plex^ do
                    begin
                      p:=evaluerAd(typ,lenC);

                      empilerAppel(p,4,false);
                      inc(tailleP,4);
                      {on empile la taille de la variable chaine}
                      inc(lenC);
                      empilerAppel(lenC,4,false);
                      inc(tailleP,4);
                    end;

        refVar:     with Plex^ do
                    begin
                      p:=evaluerAd(typ);
                      empilerAppel(p,4,false);
                      inc(tailleP,4);
                    end;


        nbByte:     begin
                      ib:=evaluerI;
                      empilerAppel(ib,4,false);
                      inc(tailleP,4);
                    end;

        nbShort:    begin
                      ishort:=evaluerI;
                      empilerAppel(ishort,4,false);
                      inc(tailleP,4);
                    end;

        nbWord:     begin
                      iw:=evaluerI;
                      empilerAppel(iw,4,false);
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
                        empilerAppel(ismall,4,false);
                        inc(tailleP,4);
                      end;
                    end;

        nbLong:    begin
                      ilong:=evaluerI;
                      empilerAppel(ilong,4,false);
                      inc(tailleP,4);
                    end;

        nbDword:    begin
                      iD:=evaluerI;
                      empilerAppel(iD,4,false);
                      inc(tailleP,4);
                    end;

        nbInt64:    begin
                      iint64:=evaluerInt64;
                      empilerAppel(iint64,8,false);
                      inc(tailleP,8);
                    end;

        nbSingle:   begin
                      xs:=evaluerR;
                      empilerAppel(xs,4,false);
                      inc(tailleP,4);
                    end;

        nbdouble:   begin
                      xd:=evaluerR;
                      empilerAppel(xd,8,false);
                      inc(tailleP,8);
                    end;

        nbExtended: begin
                      xf:=evaluerR;
                      empilerAppel(xf,12,false);
                      inc(tailleP,12);
                    end;

        nbSingleComp:
                    begin
                      ze:=evaluerComp;
                      zs.x:=ze.x;
                      zs.y:=ze.y;

                      getmem(pZs,sizeof(zs));
                      pZs^:=zs;
                      empilerAppel(pzs,4,true);
                      inc(tailleP,4);
                      inc(nbCh1);
                    end;

        nbDoubleComp:
                    begin
                      ze:=evaluerComp;
                      zd.x:=ze.x;
                      zd.y:=ze.y;

                      getmem(pZd,sizeof(zd));
                      pZd^:=zd;
                      empilerAppel(pzd,4,true);
                      inc(tailleP,4);
                      inc(nbCh1);
                    end;

        nbExtComp:  begin
                      ze:=evaluerComp;

                      getmem(pZe,sizeof(ze));
                      pZe^:=ze;
                      empilerAppel(pze,4,true);
                      inc(tailleP,4);
                      inc(nbCh1);
                    end;

        nbvariant:  with Plex^ do
                    begin
                      gvariant.init;
                      EvaluerVariant(Gvariant);   {  }
                      empilerVariant(Gvariant);   {  }

                      {variantStack[high(variantStack)].showStringInfo;}
                      inc(tailleP,4);
                      inc(nbvr);
                    end;

        nbDateTime: with Plex^ do
                    begin
                      dateTime:=EvaluerDateTime;
                      empilerAppel(dateTime,8,false);
                      inc(tailleP,8);
                    end;

        nbBoole:    begin
                      b1:=evaluerB;
                      empilerAppel(b1,4,false);
                      inc(tailleP,4);
                    end;

        nbChar:     begin
                      c1:=evaluerChar;
                      empilerAppel(c1,4,false);
                      inc(tailleP,4);
                    end;


        nbChaine:   begin
                      st1:=evaluerC;
                      getmem(pst,256);
                      pst^:=st1;
                      empilerAppel(pst,4,true);
                      inc(tailleP,4);
                      inc(nbCh1);
                    end;

        nbAnsiString:
                    begin
                      st1:=evaluerC;
                      empilerAnsiString(st1);
                      inc(tailleP,4);
                      inc(nbCh2);
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
                      empilerAppel(ilong,4,false);
                      inc(tailleP,4);
                    end;

        refDef:     with Plex^ do
                    begin
                      p:=evaluerAd(typ);
                      empilerAppel(p,4,false);
                      inc(tailleP,4);
                    end;

        nbDef:      with Plex^ do
                    begin
                      p:=evaluerAd(typ);
                      getmem(pst,defSize);
                      move(p^,pst^,defSize);
                      empilerAppel(pst,4,true);
                      inc(tailleP,4);
                      inc(nbch1);
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

  Les paramètres par valeur (dep>=0) et les variables locales (dep<0) sont des variloc
  Les paramètres par référence sont des refloc




}

function AppelprocU(Ffonc:boolean;var resultat:pointer;ResString:boolean):string;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,tailleL,nbCh1,nbch2,nbvr:integer;
  exPlex:ptUlex;
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
  adresseV:=ptrG(regCS,Plex^.adU);
  {Pour Code Relogé: adresseV:=pointer(Plex^.adU);}
  inc(intG(Plex),procUsize+ord(Ffonc));
  empilerParametres(nbParam,tailleP,nbCh1,nbch2,nbvr,true);

  exPlex:=Plex;
  exBP:=regBP;
  regBP:=regSP;

  Plex:=adresseV;

  tailleL:=Plex^.vnbi;
  if tailleL>regSP then sortieErreur(E_pile);

  dec(regSP,tailleL);
  fillchar(ptrG(regSS,regSP)^,tailleL,0);

  inc(intG(Plex),3);


  try
    StartProc(nbObj,nbSt,nbgvar);
    while (Plex^.genre<>stop) and not FinExe and not FlagExit do
    executerInstruction;

    resultat:=ptrG(regSS,regBP);
    if resString then
    begin
      result:= Pstring(intG(resultat)-4)^;
      Pstring(intG(resultat)-4)^:='';
    end;
  finally
    terminateProc(nbObj,nbSt,nbgvar);
  end;



  if finExe then fillchar(ptrG(regSS,regSP)^,tailleL,0);
                 { risque de NAN sur coprocesseur si finEXE }

  inc(regSP,tailleL);
  Plex:=exPlex;
  regBP:=exBP;

  nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
  flagExit:=false;

  dec(procUON);

  FINALLY
  RefObjectStack.free;
  RefObjectTypes.free;
  RefObjectStack:=oldRefObjectStack;
  RefObjectTypes:=oldRefObjectTypes;
  END;
end;


{$B+}


function evaluerI:longint;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,nbCh1,nbch2,nbvr:integer;
  i,j:longint;
  p:pointer;
  tpR:typeNombre;
  typ:typeNombre;
  Gvariant:TGvariant;

begin
  case Plex^.genre of
    MoinsU:  begin
               inc(intG(Plex));
               evaluerI:=-evaluerI;
             end;

    Opnot:   begin
               inc(intG(Plex));
               evaluerI:=not evaluerI;
             end;

    Plus:    begin
               inc(intG(Plex));
               evaluerI:=evaluerI+evaluerI;
             end;

    Moins:   begin
               inc(intG(Plex));
               i:=evaluerI;
               evaluerI:=i-evaluerI;
             end;

    Mult:    begin
               inc(intG(Plex));
               evaluerI:=evaluerI*evaluerI;
             end;

    Opdiv:   begin
               inc(intG(Plex));
               i:=evaluerI;
               j:=evaluerI;
               if j=0 then sortieErreur(200);
               evaluerI:=i div j;
             end;

    Opmod:   begin
               inc(intG(Plex));
               i:=evaluerI;
               j:=evaluerI;
               if j=0 then sortieErreur(200);
               evaluerI:=i mod j;
             end;

    OpAnd:   begin
               inc(intG(Plex));
               evaluerI:=evaluerI and evaluerI;
             end;

    OpOr:    begin
               inc(intG(Plex));
               evaluerI:=evaluerI or evaluerI;
             end;

    Opxor:   begin
               inc(intG(Plex));
               evaluerI:=evaluerI xor evaluerI;
             end;


    OPshl:   begin
               inc(intG(Plex));
               i:=evaluerI;
               evaluerI:=i shl evaluerI;
             end;

    Opshr:   begin
               inc(intG(Plex));
               i:=evaluerI;
               evaluerI:=i shr evaluerI;
             end;

    nbi:     begin
               evaluerI:=Plex^.vnbi;
               inc(intG(Plex),3);
             end;

    nbL:     begin
               evaluerI:=Plex^.vnbl;
               inc(intG(Plex),5);
             end;

    variByte..refLocC,variDef,variLocDef,refLocDef,tpInd:
             begin
               adresseV:=evaluerAd(typ);
               case typ of
                 nbByte:  evaluerI:= Pbyte(adresseV)^;
                 nbShort: evaluerI:= Pshort(adresseV)^;
                 nbSmall: evaluerI:= Psmallint(adresseV)^;
                 nbWord:  evaluerI:= Pword(adresseV)^;
                 nbLong:  evaluerI:= Plongint(adresseV)^;
                 nbDWord: evaluerI:= Plongword(adresseV)^;
                 nbInt64: evaluerI:= Pint64(adresseV)^;
               end;
             end;

    fonc:    begin
               nbParam:=Plex^.nbParP;
               tpR:=Plex^.tpRes;
               adresseV:=adProc^[Plex^.NumProced];
               {Pour code Relogé: adresseV:=pointer(Plex^.NumProced);}
               inc(intG(Plex),7);
               empilerParametres(nbParam,tailleP,nbCh1,nbch2,nbvr,false);
               case tpR of
                 nbByte:  result:=AppelFoncByte(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbShort: result:=AppelFoncShort(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbSmall: result:=AppelFoncSmall(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbWord:  result:=AppelFoncWord(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nblong:  result:=AppelFoncLong(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbDword: result:=AppelFoncDWord(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbInt64: result:=AppelFoncInt64(adresseV,ptrG(regSS,regSP)^,tailleP);
                 else result:=0;
               end;
               nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
             end;

    foncU:   begin
               tpR:=plex^.tpRes1;
               appelProcU(true,p,false);
               case tpR of
                 nbSmall:  evaluerI:=Psmallint(intG(p)-2)^;
                 nblong:   evaluerI:=Plongint(intG(p)-4)^;
                 nbInt64:  evaluerI:=Pint64(intG(p)-8)^;
                 else result:=0;
               end;
             end;

    OrdChar: begin
               inc(intG(Plex));
               result:=ord(evaluerChar);
             end;

    OrdBoole:begin
               inc(intG(Plex));
               result:=ord(evaluerB);
             end;

    cvVariantI:
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

    cvInt64I:
        begin
          inc(intG(Plex));
          result:=evaluerInt64; 
        end;
    else result:=0;
  end;
end;

function evaluerInt64: int64;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,nbCh1,nbch2,nbvr:integer;
  i,j: int64;
  p:pointer;
  tpR:typeNombre;
  typ:typeNombre;
  Gvariant:TGvariant;

begin
  case Plex^.genre of
    MoinsU:  begin
               inc(intG(Plex));
               evaluerInt64:=-evaluerInt64;
             end;

    Opnot:   begin
               inc(intG(Plex));
               evaluerInt64:=not evaluerInt64;
             end;

    Plus:    begin
               inc(intG(Plex));
               evaluerInt64:=evaluerInt64+evaluerInt64;
             end;

    Moins:   begin
               inc(intG(Plex));
               i:=evaluerInt64;
               evaluerInt64:=i-evaluerInt64;
             end;

    Mult:    begin
               inc(intG(Plex));
               evaluerInt64:=evaluerInt64*evaluerInt64;
             end;

    Opdiv:   begin
               inc(intG(Plex));
               i:=evaluerInt64;
               j:=evaluerInt64;
               if j=0 then sortieErreur(200);
               evaluerInt64:=i div j;
             end;

    Opmod:   begin
               inc(intG(Plex));
               i:=evaluerInt64;
               j:=evaluerInt64;
               if j=0 then sortieErreur(200);
               evaluerInt64:=i mod j;
             end;

    OpAnd:   begin
               inc(intG(Plex));
               evaluerInt64:=evaluerInt64 and evaluerInt64;
             end;

    OpOr:    begin
               inc(intG(Plex));
               evaluerInt64:=evaluerInt64 or evaluerInt64;
             end;

    Opxor:   begin
               inc(intG(Plex));
               evaluerInt64:=evaluerInt64 xor evaluerInt64;
             end;


    OPshl:   begin
               inc(intG(Plex));
               i:=evaluerInt64;
               evaluerInt64:=i shl evaluerInt64;
             end;

    Opshr:   begin
               inc(intG(Plex));
               i:=evaluerInt64;
               evaluerInt64:=i shr evaluerInt64;
             end;

    nbi:     begin
               evaluerInt64:=Plex^.vnbi;
               inc(intG(Plex),3);
             end;

    nbL:     begin
               evaluerInt64:=Plex^.vnbl;
               inc(intG(Plex),5);
             end;

    variByte..refLocC,variDef,variLocDef,refLocDef,tpInd:
             begin
               adresseV:=evaluerAd(typ);
               case typ of
                 nbByte:  evaluerInt64:= Pbyte(adresseV)^;
                 nbShort: evaluerInt64:= Pshort(adresseV)^;
                 nbSmall: evaluerInt64:= Psmallint(adresseV)^;
                 nbWord:  evaluerInt64:= Pword(adresseV)^;
                 nbLong:  evaluerInt64:= Plongint(adresseV)^;
                 nbDWord: evaluerInt64:= Plongword(adresseV)^;
                 nbInt64: evaluerInt64:= Pint64(adresseV)^;
               end;
             end;

    fonc:    begin
               nbParam:=Plex^.nbParP;
               tpR:=Plex^.tpRes;
               adresseV:=adProc^[Plex^.NumProced];
               {Pour code Relogé: adresseV:=pointer(Plex^.NumProced);}
               inc(intG(Plex),7);
               empilerParametres(nbParam,tailleP,nbCh1,nbch2,nbvr,false);
               case tpR of
                 nbByte:  result:=AppelFoncByte(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbShort: result:=AppelFoncShort(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbSmall: result:=AppelFoncSmall(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbWord:  result:=AppelFoncWord(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nblong:  result:=AppelFoncLong(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbDword: result:=AppelFoncDWord(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbInt64: result:=AppelFoncInt64(adresseV,ptrG(regSS,regSP)^,tailleP);
                 else result:=0;
               end;
               nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
             end;

    foncU:   begin
               tpR:=plex^.tpRes1;
               appelProcU(true,p,false);
               case tpR of
                 nbSmall:  evaluerInt64:=Psmallint(intG(p)-2)^;
                 nblong:   evaluerInt64:=Plongint(intG(p)-4)^;
                 nbInt64:  evaluerInt64:=Pint64(intG(p)-4)^;
                 else result:=0;
               end;
             end;

    OrdChar: begin
               inc(intG(Plex));
               result:=ord(evaluerChar);
             end;

    OrdBoole:begin
               inc(intG(Plex));
               result:=ord(evaluerB);
             end;

    cvVariantI:
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

    cvIInt64:begin
               inc(intG(Plex));
               result:=evaluerI;
             end;

    else result:=0;
  end;
end;


function evaluerR:float;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,nbCh1,nbch2,nbvr:integer;
  x,y:float;
  p:pointer;
  tpR:typeNombre;
  typ:typeNombre;
  Gvariant:TGvariant;

begin
  case Plex^.genre of
    moinsU:  begin
               inc(intG(Plex));
               result:=-evaluerR;
             end;

    plus:    begin
               inc(intG(Plex));
               x:=evaluerR;
               y:=evaluerR;
               result:=x+y;
             end;

    moins:   begin
               inc(intG(Plex));
               x:=evaluerR;
               y:=evaluerR;
               result:=x-y;
             end;

    mult:    begin
               inc(intG(Plex));
               x:=evaluerR;
               y:=evaluerR;
               result:=x*y;
             end;

    divis:   begin
               inc(intG(Plex));
               x:=evaluerR;
               y:=evaluerR;
               result:=x/y;
             end;

    nbR:     begin
               result:=Plex^.vnbr;
               inc(intG(Plex),11);
             end;

    cvIR:    begin
               inc(intG(Plex));
               result:=evaluerI;
             end;

    variByte..refLocC,variDef,variLocDef,refLocDef,tpInd:
             begin
               adresseV:=evaluerAD(typ);
               case typ of
                 nbSingle:   evaluerR:= Psingle(adresseV)^;
                 nbDouble:   evaluerR:= Pdouble(adresseV)^;
                 nbExtended: evaluerR:= Pfloat(adresseV)^;
               end;
             end;

    fonc:    begin
               nbParam:=Plex^.nbParP;
               tpR:=Plex^.tpRes;
               adresseV:=adProc^[Plex^.NumProced];
               {Pour code Relogé: adresseV:=pointer(Plex^.NumProced);}
               inc(intG(Plex),7);
               empilerParametres(nbParam,tailleP,nbCh1,nbch2,nbvr,false);
               case tpR of
                 nbSingle:   result:=AppelFoncSingle(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbDouble:   result:=AppelFoncDouble(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbExtended: result:=AppelFoncExtended(adresseV,ptrG(regSS,regSP)^,tailleP);
                 else result:=0;
               end;
               nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
             end;

    foncU:   begin
               tpR:=plex^.tpRes1;
               appelProcU(true,p,false);
               case tpR of
                 nbSingle:   result:=Psingle(intG(p)-4)^;
                 nbDouble:   result:=Pdouble(intG(p)-8)^;
                 nbExtended: result:=Pextended(intG(p)-10)^;
                 else result:=0;
               end;
             end;

    cvVariantR:
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

    else result:=0;
  end;
end;

function evaluerComp:TfloatComp;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,nbCh1,nbch2,nbvr:integer;
  z1,z2:TfloatComp;
  Zsingle:TsingleComp;
  Zdouble:TdoubleComp;
  m:float;
  p:pointer;
  tpR:typeNombre;
  typ:typeNombre;
  Gvariant:TGvariant;

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
                 nbDoubleComp: begin
                                 result.x:=PdoubleComp(AdresseV)^.x;
                                 result.y:=PdoubleComp(AdresseV)^.y;
                               end;
                 nbExtComp:    result:=PFloatComp(AdresseV)^;
               end;
             end;

    fonc:    begin
               nbParam:=Plex^.nbParP;
               tpR:=Plex^.tpRes;
               adresseV:=adProc^[Plex^.NumProced];
               {Pour code Relogé: adresseV:=pointer(Plex^.NumProced);}
               inc(intG(Plex),7);
               empilerParametres(nbParam,tailleP,nbCh1,nbch2,nbvr,false);
               case tpR of
                 nbSingleComp:
                   begin
                     p:=@Zsingle;
                     empilerAppel(p,4,false);
                     inc(tailleP,4);
                     AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
                     result.x:=Zsingle.x;
                     result.y:=Zsingle.y;
                   end;
                 nbDoubleComp:
                   begin
                     p:=@Zdouble;
                     empilerAppel(p,4,false);
                     inc(tailleP,4);
                     AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
                     result.x:=Zdouble.x;
                     result.y:=Zdouble.y;
                   end;
                 nbExtComp:
                   begin
                     p:=@Z1;
                     empilerAppel(p,4,false);
                     inc(tailleP,4);
                     AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
                     result.x:=Z1.x;
                     result.y:=Z1.y;
                   end;
               end;
               nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
             end;

    foncU:   begin
               tpR:=plex^.tpRes1;
               appelProcU(true,p,false);
               case tpR of
                 nbSingleComp:
                   begin
                     Zsingle:=PsingleComp(intG(p)-8)^;
                     result.x:=Zsingle.x;
                     result.y:=Zsingle.y;
                   end;
                 nbDoubleComp:
                   begin
                     Zdouble:=PdoubleComp(intG(p)-16)^;
                     result.x:=Zdouble.x;
                     result.y:=Zdouble.y;
                   end;
                 nbExtComp:
                   begin
                     result:=PfloatComp(intG(p)-20)^;
                   end;

               end;
             end;

    cvVariantComp:
        try
          inc(intG(Plex));
          gvariant.init;
          EvaluerVariant(Gvariant);
          if not (gVariant.VType in [gvInteger,gvFloat]) then sortieErreur('Complex expected');

          if gVariant.Vtype=gvInteger
            then result.x:=Gvariant.Vinteger
            else result.x:=Gvariant.Vfloat;
          result.y:=0;
        finally
          gvariant.finalize;
        end;

  end;
end;


function evaluerB:boolean;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,nbCh1,nbch2,nbvr:integer;
  x,y:float;
  i:integer;
  p:pointer;
  dd:integer;
  typ:typeNombre;
  Gvariant:TGvariant;

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
               inc(intG(Plex),5);
               result:= evaluerB;
               if result
                 then result:=evaluerB
                 else inc(intG(Plex),dd);
             end;
    orBI:    begin
               dd:=Plex^.depLog;
               inc(intG(Plex),5);
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
           {pour code Relogé: adresseV:=pointer(Plex^.NumProced);}
           inc(intG(Plex),7);
           empilerParametres(nbParam,tailleP,nbCh1,nbch2,nbvr,false);
           evaluerB:=AppelFoncB(adresseV,ptrG(regSS,regSP)^,tailleP);
           nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
         end;

    foncU:begin
            appelProcU(true,p,false);
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

function evaluerC:String;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,nbCh1,nbch2,nbvr:integer;
  stShort:ShortString;
  stWide:string;
  p:pointer;
  tpR:typeNombre;
  ind:integer;
  typ:typeNombre;
  gvariant:TGVariant;

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
              inc(intG(Plex),2+length(Plex^.st));
            end;

    ConstCar:
            begin
              result:=Plex^.vc;
              inc(intG(Plex),2);
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
              {pour code relogé: adresseV:=pointer(Plex^.NumProced);}
              inc(intG(Plex),7);
              empilerParametres(nbParam,tailleP,nbCh1,nbch2,nbvr,false);
              case tpR of
                nbChaine:
                    begin
                      p:=@stShort;
                      empilerAppel(p,4,false);
                      inc(tailleP,4);
                      AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
                      result:=stShort;
                      nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
                    end;
                nbANSIString:
                    begin
                      {$IFDEF FPC}

                      // eax contient la chaine résultat ( contraire à ce que dit la doc }
                      result:= AppelFoncString(adresseV,ptrG(regSS,regSP)^,tailleP);
                      nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
                      {$ELSE}

                      // on empile une variable destinée à recevoir le résultat
                      stWide:='';
                      p:=@stWide;
                      empilerAppel(p,4,false);
                      inc(tailleP,4);

                      AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
                      result:=stWide;
                      nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
                      {$ENDIF}
                    end;
                nbChar:
                    begin
                      result:=char(AppelFoncByte(adresseV,ptrG(regSS,regSP)^,tailleP));
                      nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
                    end;
              end;
            end;

    foncU:  begin
              tpR:=Plex^.tpRes1;

              case tpR of
                nbChar:       begin
                                appelProcU(true,p,false);
                                result:=Pchar0(intG(p)-1)^;
                              end;
                nbChaine:     begin
                                appelProcU(true,p,false);
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

function evaluerChar:char;
var
  nbParam:integer;
  adresseV:pointer;
  tailleP,nbCh1,nbch2,nbvr:integer;
  p:pointer;
  st1:shortString;
  ind:integer;
  typ:typeNombre;
begin
  case Plex^.genre of
    ConstCar:
            begin
              result:=Plex^.vc;
              inc(intG(Plex),2);
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
              {pour code relogé: adresseV:=pointer(Plex^.NumProced);}
              inc(intG(Plex),7);
              empilerParametres(nbParam,tailleP,nbCh1,nbch2,nbvr,false);
              result:=char(AppelFoncByte(adresseV,ptrG(regSS,regSP)^,tailleP));
              nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
            end;

    foncU:  begin
              appelProcU(true,p,false);
              result:=Pchar0(intG(p)-1)^;
            end;

    else result:=#0;
  end;
end;




procedure evaluerVariant(var result:TGvariant);
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,nbCh1,nbch2,nbvr:integer;
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
              {pour code relogé: adresseV:=pointer(Plex^.NumProced);}
              inc(intG(Plex),7);
              empilerParametres(nbParam,tailleP,nbCh1,nbch2,nbvr,false);

              fillchar(gvariant,sizeof(gvariant),0);
              p:=@gvariant;
              empilerAppel(p,4,false);
              inc(tailleP,4);
              AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
              nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
              result:=gvariant;
            end;

    foncU:   begin
               appelProcU(true,p,false);
               {copyGVariant(PGvariant(intG(p)-15)^,result); }
               result:=PGvariant(intG(p)-15)^;
                                        { le variant référence l'objet p}
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
                 gvFloat:   result.Vfloat:=-result.Vfloat;
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
                               gvInteger: result.Vinteger:=result.Vinteger+gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=result.Vinteger+gvariant.Vfloat;
                               else sortieErreur('Unexpected type');
                             end;

                 gvFloat:   case gvariant.VType of
                               gvInteger: result.Vfloat:=result.Vfloat+gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=result.Vfloat+gvariant.Vfloat;
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
                               gvInteger: result.Vinteger:=result.Vinteger-gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=result.Vinteger-gvariant.Vfloat;
                               else sortieErreur('Unexpected type');
                             end;
                 gvFloat:   case gvariant.VType of
                               gvInteger: result.Vfloat:=result.Vfloat-gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=result.Vfloat-gvariant.Vfloat;
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
                               gvInteger: result.Vinteger:=result.Vinteger*gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=result.Vinteger*gvariant.Vfloat;
                               else sortieErreur('Unexpected type');
                             end;
                 gvFloat:   case gvariant.VType of
                               gvInteger: result.Vfloat:=result.Vfloat*gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=result.Vfloat*gvariant.Vfloat;
                               else sortieErreur('Unexpected type');
                             end;

                 else sortieErreur('Unexpected type');
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
                               gvInteger: result.Vfloat:=result.Vinteger/gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=result.Vinteger/gvariant.Vfloat;
                               else sortieErreur('Unexpected type');
                             end;
                 gvFloat:   case gvariant.VType of
                               gvInteger: result.Vfloat:=result.Vfloat/gvariant.Vinteger;
                               gvFloat:   result.Vfloat:=result.Vfloat/gvariant.Vfloat;
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
                               else sortieErreur('Unexpected type');
                             end;
                 gvFloat:    case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vfloat=gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vfloat=gvariant.Vfloat;
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
                               else sortieErreur('Unexpected type');
                             end;
                 gvFloat:    case gvariant.VType of
                               gvInteger: result.Vboolean:=result.Vfloat<>gvariant.Vinteger;
                               gvFloat:   result.Vboolean:=result.Vfloat<>gvariant.Vfloat;
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
  tailleP,nbCh1,nbch2,nbvr:integer;
  p:pointer;
  typ:typeNombre;
  gvariant:TGVariant;

begin
  fillchar(result,sizeof(result),0);
  case Plex^.genre of
    fonc:    begin
               nbParam:=Plex^.nbParP;
               adresseV:=adProc^[Plex^.NumProced];
               inc(intG(Plex),7);

               empilerParametres(nbParam,tailleP,nbCh1,nbch2,nbvr,false);
               result:=TdateTime(AppelFoncDouble(adresseV,ptrG(regSS,regSP)^,tailleP));
               nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
             end;

    foncU:   begin
               appelProcU(true,p,false);
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
{*************************** Exécution *************************************}
{***************************************************************************}




procedure executerProcU(isFunction:boolean);
var
  bid:pointer;
begin
  AppelProcU(isFunction,bid,false);
end;


{ Appel de FoncC en tant que procédure simple}
procedure executerFoncC;
var
  nbParam:smallInt;
  adresseV:pointer;
  tpR:typeNombre;
  tailleP,nbCh1,nbch2,nbvr:integer;
  stShort:shortString;
  stWide:string;
  p:pointer;
begin
  nbParam:=Plex^.nbParP;
  tpR:=Plex^.tpRes;
  adresseV:=adProc^[Plex^.NumProced];
  {pour code Relogé: adresseV:=pointer(Plex^.NumProced);}
  inc(intG(Plex),7);
  empilerParametres(nbParam,tailleP,nbCh1,nbch2,nbvr,false);
  case tpR of
    nbChaine:     p:=@stShort;
    nbAnsiString: p:=@stWide;
  end;
  empilerAppel(p,4,false);
  inc(tailleP,4);
  AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
  nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
end;

procedure executerProcedure;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,nbCh1,nbch2,nbvr:integer;
begin
  with Plex^ do
  if (genre=fonc) and ( (tpRes=nbChaine) or (tpRes=nbAnsiString)) then
    begin
      executerFoncC;
      exit;
    end;

  nbParam:=Plex^.nbParP;
  adresseV:=adProc^[Plex^.NumProced];
  {pour code Relogé: adresseV:=pointer(Plex^.NumProced);}
  if Plex^.genre=fonc
    then inc(intG(Plex),7)
    else inc(intG(Plex),6);
  empilerParametres(nbParam,tailleP,nbCh1,nbch2,nbvr,false);

  AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
  nettoyerPileAppel(tailleP,nbCh1,nbch2,nbvr);
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
     nbDoubleComp: begin
                     z1:=evaluerComp;
                     PdoubleComp(adresseV)^.x:=z1.x;
                     PdoubleComp(adresseV)^.y:=z1.y;
                   end;
     nbExtComp:    begin
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
  inc(intG(Plex),5);

  long:=(Plex^.genre=variL) or
        (Plex^.genre=variLocL) or (Plex^.genre=refLocL);
  ad:=evaluerAd(typ);

  i1:=evaluerI;
  i2:=evaluerI;
  P1:=Plex;

  i:=i1;
  while (i<=i2) and not flagExit and not FinExe do
  begin
    Plex:=P1;
    if long then Plongint(ad)^:=i
            else Psmallint(ad)^:=i;
    while  (intG(Plex)<intG(Pfin)) and not FinEXE and not flagExit do
      executerInstruction;
    i:=i+1;
  end;
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
  inc(intG(Plex),5);

  long:=(Plex^.genre=variL) or
        (Plex^.genre=variLocL) or (Plex^.genre=refLocL);
  ad:=evaluerAd(typ);

  i1:=evaluerI;
  i2:=evaluerI;
  P1:=Plex;

  i:=i1;
  while (i>=i2) and not flagExit and not FinExe do
  begin
    Plex:=P1;
    if long then Plongint(ad)^:=i
            else Psmallint(ad)^:=i;
    while (intG(Plex)<intG(Pfin)) and not FinEXE do
      executerInstruction;
    i:=i-1;
  end;
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

  inc(intG(Plex),5);
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
  if adresse<>adresseCase then    { égal si pas de else }
    begin
      Plex:=adresse;
      while  (Plex<>PlexFinI) and not FinExe  and not flagExit do
        executerInstruction;
    end;

  Plex:=pointer(PCase);
  inc(intG(Plex),13+Pcase^.nbCase*sizeof(typecas));
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
    if finEXE then exit;

    case Plex^.genre of
      AffectVar:   executerAffectVAR;
      proced,fonc: executerProcedure;
      procU:       executerProcU(false);
      foncU:       executerProcU(true);
      motgoto:     executerGoto;
      motIF:       executerIF;
      forUp:       executerForUp;
      forDw:       executerForDw;
      motCase:     executerCase;

      motInc:      executerInc;
      motDec:      executerDec;

      stop:        finEXE:=true;
      motExit:     if procUON>0
                      then flagExit:=true
                      else finExe:=true;

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
        finExeU:=true;
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
end;

procedure executerProg0;
begin
  try
    repeat
      executerInstruction;
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

procedure executerProg(cs,ds:pointer;prog:integer;var error,ad:integer;
                       adp:PtabPointer1;stp:TstartProc;trm:TterminateProc;LocStrings,LocVariants:Tlist);
var
  oldPlex:PtUlex;
  oldfinEXE,oldflagExit:boolean;
  oldprocUON:integer;

  oldregCS, oldregDS, oldregSP, oldRegBP:integer;
  oldAdP:PtabPointer1;
  oldExeOn:boolean;

  oldStartProc:TstartProc;
  oldTerminateProc:TTerminateProc;
  oldLocalStrings,oldLocalVariants:Tlist;

  oldAnsi,oldString:integer;
begin
  if stackSize=0 then allocateStack(50000);
  if not assigned(testerFinExe) then testerFinExe:=rien;

  oldfinEXE:=finExe;
  oldflagExit:=flagExit;
  oldprocUON:=procUon;

  oldregCS:=regCS;
  oldregDS:=regDS;
  oldregSP:=regSP;
  oldregBP:=regBP;

  oldPlex:=Plex;
  oldAdp:=adProc;
  oldExeOn:=exeOn;

  oldAnsi:=nbAnsi;
  oldString:=nbChaineEmpilee;

  oldStartProc:=StartProc;
  oldTerminateProc:=TerminateProc;
  oldLocalStrings:=LocalStrings;
  oldLocalVariants:=LocalVariants;

  StartProc:=stp;
  TerminateProc:=trm;
  LocalStrings:=LocStrings;
  LocalVariants:=LocVariants;

  finEXE:=false;
  finExeU:=false;
  flagExit:=false;
  procUON:=0;
  exeON:=true;

  regCS:=intG(cs);
  regDS:=intG(ds);
  Plex:=ptrG(regCS,prog);
  adProc:=adP;

  errorExe:=0;
  errorOut:=0;

  executerProg0;

  error:=errorExe;
  ad:=intG(adresseErreurExe)-regCS-1;

  finEXE:=oldfinExe;
  flagExit:=oldflagExit;
  procUON:=oldprocUon;

  regCS:=oldregCS;
  regDS:=oldregDS;
  regSP:=oldRegSP;
  regBP:=oldRegBP;

  nettoyerPileAppel(0,nbChaineEmpilee,nbAnsi,length(variantStack));

  StartProc:=oldStartProc;
  TerminateProc:=oldTerminateProc;
  LocalStrings:=oldLocalStrings;
  LocalVariants:=oldLocalVariants;

  Plex:=oldPlex;
  adProc:=oldAdP;
  exeOn:=oldExeOn;

  nbAnsi:=OldAnsi;
  nbChaineEmpilee:=oldString;

end;

function getStdError:string;
begin
  result:=errorExeMsg;
end;

function getCurrentExeAd:integer;
begin
  result:=intG(Plex)-regCS-1;
end;

procedure executerExtProc(prog:pointer);
var
  oldPlex:PtUlex;
begin
  oldPlex:=Plex;

  Plex:=prog;
  executerInstruction;
  Plex:=oldPlex;

end;

function evaluerExtRfunc(prog:pointer):float;
var
  oldPlex:PtUlex;
begin
  oldPlex:=Plex;

  Plex:=prog;
  result:=evaluerR;
  Plex:=oldPlex;
end;


Initialization
AffDebug('Initialization Nexe2',0);

finalization

freemem(stackSeg);

end.
