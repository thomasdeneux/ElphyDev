unit Nexe3;

{ Nexe3 est identique à Nexe2 mais on introduit l'objet Tstack qui gère les paramètres
  transmis indirectement (structures, AnsiStrings et variants)

  Nexe3 n'est pas utilisée par WIN64

}

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


{ Dans les versions 32bits, les paramètres sont toujours transmis dans la pile. La même méthode
pouvait être utilisée pour les procédures utilisateurs ou externes.
  Dans les versions 64 bits, les paramètres sont transmis dans les registres du CPU, on a créé l'objet Tstack
pour gérer les paramètres empilés. Certains params sont dans les registres. POur d'autres, ils sont placés dans l'objet stack
et leur adresse est rangée dans la pile.
}

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

    Psize:=intG(pvalue[NumP])-intG(mem);    {Le suivant moins le début }
  end;
end;



(*
Const
  maxString=2000;
var
  ChaineEmpilee:array[1..maxString] of PshortString;
  nbChaineEmpilee:Integer;

  AnsiEmpilee:array[1..maxString] of pointer;
  nbAnsi:integer;

  VariantStack:array of TGvariant;
*)
var
  Plex: PtUlex;         // pointeur d'exécution
  FlagExit: boolean;    // mot Exit rencontré dans le code
  FlagBreak: boolean;   // mot break rencontré dans le code
  procUON: integer;     // incrémenté quand on entre dans une procédure, décrémenté en sortie
  CurrentProc: integer; // adresse de la procédure courante


var
  errorEXEMsg:string;

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
function evaluerChar:AnsiChar;forward;

procedure evaluerVariant(var result:TGvariant);forward;
function evaluerDateTime:TdateTime;forward;

function evaluerDepArray:integer;forward;

function evaluerAd(var typ:typeNombre):pointer;overload; forward;
function evaluerAd(var typ:typeNombre; var len:integer):pointer;overload; forward;

procedure executerInstruction;forward;





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

function AppelFoncInt64(ad:pointer;var blocParam;size:Integer):int64;assembler;pascal;
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


{$IFDEF FPC}
function AppelFoncString(ad:pointer;var blocParam;size:integer):AnsiString; assembler;pascal;
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
  if 4>regSP then sortieErreur(E_pile);
  dec(regSP,4);

  p:=stack0.StoreStruct(@t,sz);            { Allouer sz octets dans stack0 et y ranger t }
  move(p ,ptrG(regSS,regSP)^,4);           { ranger l'adresse du bloc dans la pile }

end;


procedure empilerAnsiString(st:AnsiString;isProcU:boolean);
var
  p:pointer;
begin
  if 4>regSP then sortieErreur(E_pile);
  dec(regSP,4);

  if isProcU then
  begin
    
    p:=ptrG(regSS,regSP);
    Ppointer(p)^:=nil;
    PansiString(p)^:=st;               { copie de st dans une variable chaine }
    stack0.StoreAdAnsiString(p);
  end
  else
  begin
    p:=stack0.StoreAnsiString(st);
    move(p^,ptrG(regSS,regSP)^,4);     { ranger la chaine dans la pile , pas l'adresse de la chaine}
  end;

  (*
  p:=ptrG(regSS,regSP);
  Ppointer(p)^:=nil;
  PansiString(p)^:=st;               { copie de st dans une variable chaine }

  inc(nbAnsi);
  if nbAnsi>maxString then sortieErreur('Too many ANSI strings in stack');
  AnsiEmpilee[nbAnsi]:=p;            { on garde l'adresse de la chaine pour pouvoir la libérer plus tard }
  *)
end;


procedure empilerVariant(var vr:TGvariant);
var
  p:pointer;
begin
  if 4>regSP then sortieErreur(E_pile);
  dec(regSP,4);

  p:=Stack0.storeVariant(vr);
  move(p,ptrG(regSS,regSP)^,4);           { ranger l'adresse du variant dans la pile }

  {
  setlength(variantStack,length(variantStack)+1);
  fillchar(variantStack[high(variantStack)],sizeof(TGvariant),0);

  variantStack[high(variantStack)]:=vr;
  variantStack[high(variantStack)].AdjustObject;

  p:=@variantStack[high(variantStack)];
  empilerAppel(p,4);
  }
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


procedure empilerParametres(nbParam:smallInt;var tailleP, StackPos:integer;isProcU:boolean);
   forward;

function evaluerFoncAd:pointer;
  var
    adresseV:pointer;
    nbparam:integer;
    tailleP,Apos:integer;
  begin
    nbParam:=Plex^.nbParP;
    adresseV:=adProc^[Plex^.NumProced];

    inc(intG(Plex),FoncSize);
    empilerParametres(nbParam,tailleP,Apos,false);

    evaluerFoncAd:=pointer(AppelFoncLong(adresseV,ptrG(regSS,regSP)^,tailleP));

    nettoyerPileAppel(tailleP,Apos);
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
                 inc(intG(adresseV),evaluerDepArray);

               if (Plex^.genre=CV) and (p^.genre>=variSingleComp) and (p^.genre<=variExtComp) then
                 begin
                   inc(intG(adresseV),Plex^.CVdep);
                   typ:=Plex^.CVtp;
                   inc(intG(Plex),CVsize);
                 end;
             end;

    variLocByte..variLocChar,variLocAnsiString:
             begin
               typ:=typeVar[Plex^.genre];
               adresseV:=ptrG(regSS,regBP+Plex^.dep);
               inc(intG(Plex), VariLocSize);
               if Plex^.genre=motArray then
                 inc(intG(adresseV),evaluerDepArray);
               if (Plex^.genre=CV) and (p^.genre>=variLocSingleComp) and (p^.genre<=variLocExtComp) then
                 begin
                   inc(intG(adresseV),Plex^.CVdep);
                   typ:=Plex^.CVtp;
                   inc(intG(Plex),CVsize);
                 end;
             end;

    refLocByte..refLocChar,refLocAnsiString:
             begin
               typ:=typeVar[Plex^.genre];
               adresseV:=pointer(ptrG(regSS,regBP+Plex^.dep)^);
               inc(intG(Plex),refLocSize);
               if Plex^.genre=motArray then
                 inc(intG(adresseV),evaluerDepArray);
               if (Plex^.genre=CV) and (p^.genre>=refLocSingleComp) and (p^.genre<=refLocExtComp) then
                 begin
                   inc(intG(adresseV),Plex^.CVdep);
                   typ:=Plex^.CVtp;
                   inc(intG(Plex),CVsize);
                 end;
             end;

    variC:  begin
               typ:=nbChaine;
               adresseV:=ptrG(regDS,Plex^.adv);
               inc(intG(Plex),variCsize);
               if Plex^.genre=motArray then
                 inc(intG(adresseV),evaluerDepArray);
               len:=p^.longC;
             end;

    variLocC:
            begin
              typ:=nbChaine;
              adresseV:=ptrG(regSS,regBP+Plex^.dep);
              inc(intG(Plex),variLocCsize);
              if Plex^.genre=motArray then
                 inc(intG(adresseV),evaluerDepArray);
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
              inc(intG(Plex),refLocCsize);
              if Plex^.genre=motArray then
                inc(intG(adresseV),evaluerDepArray);
            end;


    variDef:
             begin
               typ:=nbDef;
               defSize:=Plex^.sz;
               adresseV:=ptrG(regDS,Plex^.adDef);
               inc(intG(Plex),variDefSize);
               while (Plex^.genre=motArray) or (Plex^.genre=CV) or (Plex^.genre=cvObj) do
               begin
                 if Plex^.genre=motArray then
                   inc(intG(adresseV),evaluerDepArray);
                 if Plex^.genre=CV then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=Plex^.CVtp;
                     defSize:=Plex^.CVsz;
                     len:=defSize-1;           { pour nbChaine }
                     inc(intG(Plex),CVsize);
                   end;
                 if Plex^.genre=CVobj then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=refObject;
                     inc(intG(Plex),cvObjSize);
                   end;
               end;
             end;

    variLocDef:
             begin
               typ:=nbDef;
               defSize:=Plex^.sz;
               adresseV:=ptrG(regSS,regBP+Plex^.depDef);
               inc(intG(Plex),variLocDefSize);
               while (Plex^.genre=motArray) or (Plex^.genre=CV) or (Plex^.genre=cvObj) do
               begin
                 if Plex^.genre=motArray then
                   inc(intG(adresseV),evaluerDepArray);
                 if Plex^.genre=CV then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=Plex^.CVtp;
                     defSize:=Plex^.CVsz;
                     len:=defSize-1;           { pour nbChaine }
                     inc(intG(Plex),CVsize);
                   end;
                 if Plex^.genre=CVobj then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=refObject;
                     inc(intG(Plex),CVobjSize);
                   end;
               end;
             end;

    refLocDef:
             begin
               typ:=nbDef;
               defSize:=Plex^.sz1;
               adresseV:=pointer(ptrG(regSS,regBP+Plex^.depdef)^);
               inc(intG(Plex),refLocDefSize);
                while (Plex^.genre=motArray) or (Plex^.genre=CV) or (Plex^.genre=cvObj) do
               begin
                 if Plex^.genre=motArray then
                   inc(intG(adresseV),evaluerDepArray);
                 if Plex^.genre=CV then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=Plex^.CVtp;
                     defSize:=Plex^.CVsz;
                     len:=defSize-1;           { pour nbChaine }
                     inc(intG(Plex),CVsize);
                   end;
                 if Plex^.genre=CVobj then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=refObject;
                     inc(intG(Plex),CVobjSize);
                   end;
               end;
             end;


    variObject:
            begin
              typ:=refObject;
              adresseV:=ptrG(regDS,Plex^.adOb);
              inc(intG(Plex),variObjectSize);
              if Plex^.genre=motArray then
                inc(intG(adresseV),evaluerDepArray);
            end;

    refAbs:
            begin
              typ:=nbAbs;
              if Plex^.dep>0
                then adresseV:=ptrG(regSS,Plex^.dep)
                else adresseV:=ptrG(regSS,regBP+Plex^.dep);
              {Donne une adresse dans la pile}
              inc(intG(Plex),refAbsSize);
            end;

    TPObjectInd:
            begin
              typ:=refObject;
              if Plex^.depTPO>0
                then adresseV:=Ppointer(regSS+Plex^.depTPO)^
                else adresseV:=Ppointer(regSS+regBP+Plex^.depTPO)^;
              {Dans la pile se trouve le déplacement d'une variable objet dans le
               segment de données}
              inc(intG(Plex),TpObjectIndSize);
            end;
    TPInd:
            begin
              typ:=Plex^.tpInd1;
              defSize:=Plex^.szInd;
              adresseV:=Ppointer(regSS+regBP+Plex^.depInd)^;
              {Dans la pile se trouve le déplacement d'une variable objet dans le
               segment de données}
              inc(intG(Plex),TPIndSize);

              while (Plex^.genre=motArray) or (Plex^.genre=CV) or (Plex^.genre=cvObj) do
               begin
                 if Plex^.genre=motArray then
                   inc(intG(adresseV),evaluerDepArray);
                 if Plex^.genre=CV then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=Plex^.CVtp;
                     defSize:=Plex^.CVsz;
                     len:=defSize-1;
                     inc(intG(Plex),CVsize);
                   end;
                 if Plex^.genre=CVobj then
                   begin
                     inc(intG(adresseV),Plex^.CVdep);
                     typ:=refObject;
                     inc(intG(Plex),CVobjSize);
                   end;
               end;
            end;

    refLocObject:
            begin
              typ:=refObject;
              adresseV:=pointer(ptrG(regSS,regBP+Plex^.dep)^);
              inc(intG(Plex),refLocObjectSize);
              if Plex^.genre=motArray then
                inc(intG(adresseV),evaluerDepArray);
             end;

    variLocObject:
            begin
              typ:=refObject;
              adresseV:=ptrG(regSS,regBP+Plex^.dep);
              inc(intG(Plex),variLocObjectSize);
              if Plex^.genre=motArray then
                inc(intG(adresseV),evaluerDepArray);
             end;

    fonc:  begin
             typ:=refProcedure;
             adresseV:=evaluerFoncAd;
           end;

    refSys:begin
             typ:=Plex^.tpSys;
             adresseV:=Plex^.adSys;
             defSize:=Plex^.szSys;
             inc(intG(Plex),refSysSize);
           end;

    motNil:begin
             adresseV:=@VarNil;
             inc(intG(Plex));
           end;

    cvVariantObject:
           begin
             Vob:=Plex^.VObVariant; {type souhaité}
             inc(intG(Plex),cvVariantObjectSize);
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

{ isProcU vaut TRUE pour les procédures utilisateurs uniquement
}
procedure empilerParametres(nbParam:smallInt;var tailleP,StackPos:integer;isProcU:boolean);
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
                      empilerAppel(p,4);
                      inc(tailleP,4);
                    end;

        refObject:  with Plex^ do
                    begin
                      p:=evaluerAd(typ);

                      if isProcU then
                      begin
                        FlagRef:=true;
                        PrefObj:=p;
                      end;

                      empilerAppel(p,4);
                      inc(tailleP,4);
                    end;

        refChaine:  with Plex^ do
                    begin
                      p:=evaluerAd(typ,lenC);

                      empilerAppel(p,4);
                      inc(tailleP,4);
                      {on empile la taille de la variable chaine}
                      inc(lenC);
                      empilerAppel(lenC,4);
                      inc(tailleP,4);
                    end;

        refVar:     with Plex^ do
                    begin
                      p:=evaluerAd(typ);
                      empilerAppel(p,4);
                      inc(tailleP,4);
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

        nbdouble:   begin
                      xd:=evaluerR;
                      empilerAppel(xd,8);
                      inc(tailleP,8);
                    end;

        nbExtended: begin
                      xf:=evaluerR;
                      empilerAppel(xf,12);
                      inc(tailleP,12);
                    end;

        nbSingleComp:
                    begin
                      ze:=evaluerComp;
                      zs.x:=ze.x;
                      zs.y:=ze.y;

                      empilerStruct(zs,sizeof(zs));
                      inc(tailleP,4);
                    end;

        nbDoubleComp:
                    begin
                      ze:=evaluerComp;
                      zd.x:=ze.x;
                      zd.y:=ze.y;

                      empilerStruct(zd, sizeof(zd));
                      inc(tailleP,4);
                    end;

        nbExtComp:  begin
                      ze:=evaluerComp;

                      empilerStruct(ze,sizeof(ze));
                      inc(tailleP,4);
                    end;

        nbvariant:  with Plex^ do
                    begin
                      gvariant.init;
                      EvaluerVariant(Gvariant);   {  }
                      empilerVariant(Gvariant);   {  }

                      {variantStack[high(variantStack)].showStringInfo;}
                      inc(tailleP,4);
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
                      inc(tailleP,4);
                    end;

        nbAnsiString:
                    begin
                      st1:=evaluerC;
                      empilerAnsiString(st1,isProcU);
                      inc(tailleP,4);
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

                      empilerAppel(p,4);
                      inc(tailleP,4);
                    end;

        nbDef:      with Plex^ do
                    begin
                      p:=evaluerAd(typ);
                      empilerStruct(p^,defSize);
                      inc(tailleP,4);
                    end;



      end;
    end;
end;

{ AprÃ¨s empilage des paramÃ¨tres, BP prend la valeur de SP

  en BP + 0 se trouve le premier paramÃ¨tre de taille tailleParam1
  en BP + tailleParam1 se trouve le second paramÃ¨tre
  etc..

  Au retour, si Ffonc=true, resultat vaut BP et la valeur du rÃ©sultat est en resultat-tailleResultat

  Les variables locales sont allouÃ©es en dessous de BP (dep nÃ©gatif)
  Les paramÃ¨tres ont un dÃ©placement positif.

  Les paramÃ¨tres par valeur (dep>=0) et les variables locales (dep<0) sont des variloc
  Les paramÃ¨tres par rÃ©fÃ©rence sont des refloc




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

  nbParam:=Plex^.nbParU;           // Plex pointe sur ProcU (adU,nbparU,numUnitProc)

  exCurrentProc:=CurrentProc;
  CurrentProc:=Plex^.adU;
  adresseV:=ptrG(regCS,CurrentProc);

  inc(intG(Plex),procUsize+ord(Ffonc));
  empilerParametres(nbParam,tailleP,Apos,true);

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
      result:= Pansistring(intG(resultat)-4)^;
      Pansistring(intG(resultat)-4)^:='';
    end
    else
    if Pvariant<>nil then CopyGvariant(PGvariant(intG(resultat)-sizeof(TGvariant))^, Pvariant^ );
  finally
    terminateProc(nbObj,nbSt,nbgvar);
  end;



  if finExe or finExeU^ then fillchar(ptrG(regSS,regSP)^,tailleL,0);
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


{$B+}


function evaluerI:longint;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,Apos:integer;
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
               inc(intG(Plex),nbiSize);
             end;

    nbL:     begin
               evaluerI:=Plex^.vnbl;
               inc(intG(Plex),nbLsize);
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

               inc(intG(Plex),foncSize);
               empilerParametres(nbParam,tailleP,Apos,false);
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
               nettoyerPileAppel(tailleP,Apos);
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
  tailleP,Apos:integer;
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
               inc(intG(Plex),nbiSize);
             end;

    nbL:     begin
               evaluerInt64:=Plex^.vnbl;
               inc(intG(Plex),nbLsize);
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

               inc(intG(Plex),foncSize);
               empilerParametres(nbParam,tailleP,Apos,false);
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
               nettoyerPileAppel(tailleP,Apos);
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

    cvVariantI64:
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
  tailleP,Apos:integer;
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
               inc(intG(Plex),nbRsize);
             end;

    cvIR:    begin
               inc(intG(Plex));
               result:=evaluerI;
             end;

    cvInt64R:begin
               inc(intG(Plex));
               result:=evaluerInt64;
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

               inc(intG(Plex),foncSize);
               empilerParametres(nbParam,tailleP,Apos,false);
               case tpR of
                 nbSingle:   result:=AppelFoncSingle(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbDouble:   result:=AppelFoncDouble(adresseV,ptrG(regSS,regSP)^,tailleP);
                 nbExtended: result:=AppelFoncExtended(adresseV,ptrG(regSS,regSP)^,tailleP);
                 else result:=0;
               end;
               nettoyerPileAppel(tailleP,Apos);
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
  tailleP,Apos:integer;
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

               inc(intG(Plex),foncSize);
               empilerParametres(nbParam,tailleP,Apos,false);
               case tpR of
                 nbSingleComp:
                   begin
                     p:=@Zsingle;
                     empilerAppel(p,4);
                     inc(tailleP,4);
                     AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
                     result.x:=Zsingle.x;
                     result.y:=Zsingle.y;
                   end;
                 nbDoubleComp:
                   begin
                     p:=@Zdouble;
                     empilerAppel(p,4);
                     inc(tailleP,4);
                     AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
                     result.x:=Zdouble.x;
                     result.y:=Zdouble.y;
                   end;
                 nbExtComp:
                   begin
                     p:=@Z1;
                     empilerAppel(p,4);
                     inc(tailleP,4);
                     AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
                     result.x:=Z1.x;
                     result.y:=Z1.y;
                   end;
               end;
               nettoyerPileAppel(tailleP,Apos);
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
  i:integer;
  i64: int64;
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
               inc(intG(Plex),andBIsize);
               result:= evaluerB;
               if result
                 then result:=evaluerB
                 else inc(intG(Plex),dd);
             end;
    orBI:    begin
               dd:=Plex^.depLog;
               inc(intG(Plex),orBIsize);
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
               i64:=evaluerInt64;
               evaluerB:= (i64<evaluerInt64);
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
               i64:=evaluerInt64;
               evaluerB:= (i64<=evaluerInt64);
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
               i64:=evaluerInt64;
               evaluerB:= (i64>evaluerInt64);
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
               i64:=evaluerInt64;
               evaluerB:= (i64>=evaluerInt64);
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
           empilerParametres(nbParam,tailleP,Apos,false);
           evaluerB:=AppelFoncB(adresseV,ptrG(regSS,regSP)^,tailleP);
           nettoyerPileAppel(tailleP,Apos);
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
              inc(intG(Plex),ChaineCarSize+length(Plex^.st));
            end;

    ConstCar:
            begin
              result:=Plex^.vc;
              inc(intG(Plex),ConstCarSize);
            end;

    variC,variLocC,refLocC,variDef,variLocDef,refLocDef:
            begin
               p:= evaluerAd(typ);
               if typ = nbchar
                 then result:= Pchar0(p)^
                 else result:= PshortString(p)^;
               //result:=PShortString(evaluerAd(typ))^;
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
              empilerParametres(nbParam,tailleP,Apos,false);
              case tpR of
                nbChaine:
                    begin
                      p:=@stShort;
                      empilerAppel(p,4);
                      inc(tailleP,4);
                      AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
                      result:=stShort;
                      nettoyerPileAppel(tailleP,Apos);
                    end;
                nbANSIString:
                    begin
                      // on empile une variable destinée à recevoir le résultat
                      stWide:='';
                      p:=@stWide;
                      empilerAppel(p,4);
                      inc(tailleP,4);

                      AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
                      result:=stWide;
                      nettoyerPileAppel(tailleP,Apos);
                    end;
                nbChar:
                    begin
                      result:=AnsiChar(AppelFoncByte(adresseV,ptrG(regSS,regSP)^,tailleP));
                      nettoyerPileAppel(tailleP,Apos);
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

function evaluerChar:AnsiChar;
var
  nbParam:integer;
  adresseV:pointer;
  tailleP,Apos:integer;
  p:pointer;
  st1:shortString;
  ind:integer;
  typ:typeNombre;
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

              inc(intG(Plex),foncSize);
              empilerParametres(nbParam,tailleP,Apos,false);
              result:=AnsiChar(AppelFoncByte(adresseV,ptrG(regSS,regSP)^,tailleP));
              nettoyerPileAppel(tailleP,Apos);
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
  tailleP,Apos:integer;
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
    CvI64variant:
            begin
              inc(intG(Plex));
              result.VInteger:=evaluerInt64;
            end;

    CvRvariant:
            begin
              inc(intG(Plex));
              result.Vfloat:=evaluerR;
            end;

    CvCompVariant:
            begin
              inc(intG(Plex));
              result.Vcomplex:=evaluerComp;
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

              inc(intG(Plex),foncSize);
              empilerParametres(nbParam,tailleP,Apos,false);

              fillchar(gvariant,sizeof(gvariant),0);
              p:=@gvariant;
              empilerAppel(p,4);
              inc(tailleP,4);
              AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
              nettoyerPileAppel(tailleP,Apos);
              result:=gvariant;
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
  tailleP,Apos:integer;
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

               empilerParametres(nbParam,tailleP,Apos,false);
               result:=TdateTime(AppelFoncDouble(adresseV,ptrG(regSS,regSP)^,tailleP));
               nettoyerPileAppel(tailleP,Apos);
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


procedure executerProcedure;
var
  nbParam:smallInt;
  adresseV:pointer;
  tailleP,Apos:integer;
  st:AnsiString;
begin
  nbParam:=Plex^.nbParP;
  adresseV:=adProc^[Plex^.NumProced];

  if Plex^.genre=fonc
    then inc(intG(Plex),foncSize)
    else inc(intG(Plex),procedSize);
  empilerParametres(nbParam,tailleP,Apos,false);

  AppelProc(adresseV,ptrG(regSS,regSP)^,tailleP);
  nettoyerPileAppel(tailleP,Apos);
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


procedure AffectObject(dest, src: pointer);      // dest et src sont les adresses de deux variables objets
var                                              // mais peuvent aussi être les adresses de myAd dans un object du genre v1, v2
  uoSrc, uoDest: typeUO;
begin

  uoSrc:= Ppointer(src)^;
  uoDest:= Ppointer(dest)^;

  if assigned(uoDest) then uoDest.freeVar(dest);
  Ppointer(dest)^:=Ppointer(src)^;
  if assigned(uoSrc) then uoSrc.AddVar(dest);

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

     {$IFDEF TEST_AFFECT_OBJECT}
     refObject: AffectObject(adresseV,evaluerAd(typ));
     {$ENDIF}
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

    if w and not flagExit and not FlagBreak and not FinExe and not FinExeU^  then
    begin
      Plex:=Pstart;
      while  (intG(Plex)<intG(Pend)) and not FinEXE and not FinExeU^ and not flagExit and not FlagBreak do
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
      while  (Plex<>PlexFinI) and not FinExe and not FinExeU^  and not flagExit and not FlagBreak do
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
    if finEXE or finExeU^ then exit;
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
    until finEXE or finExeU^;

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
  oldprocUON: integer;
  oldCurrentProc: integer;

  oldregCS, oldregDS, oldregSP, oldRegBP:integer;
  oldAdP:PtabPointer1;
  oldExeOn:boolean;

  oldStartProc:TstartProc;
  oldTerminateProc:TTerminateProc;
  oldLocalStrings,oldLocalVariants:Tlist;

  oldStackPos:integer;
  OldElphyDebugPg: TelphyDebugPg;

begin
  if stackSize=0 then allocateStack(5000000);
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
  Plex:= prog;  // ptrG(regCS,prog);
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
AffDebug('Initialization Nexe3',0);

finalization

freemem(stackSeg);

end.
