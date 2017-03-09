unit EvtAcq1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

var
  shiftDigi:word;
  maskDigi:word;


procedure init;
function GetEvent(x,v:smallint):smallint;pascal;


implementation

uses acqDef2,acqInf2 ,
     AcqBrd1;

var
  Jthreshold:  array[0..15] of smallint;
  JthresholdH: array[0..15] of smallint;

  LastValue:   array[0..15] of boolean;
  Erising:     array[0..15] of boolean;


procedure init;
var
  i:integer;
begin
  shiftDigi:=board.tagShift;
  maskDigi:=1 shl shiftDigi-1;


  with AcqInf do
  if DFformat=ElphyFormat1 then
  for i:=1 to Qnbvoie do
  begin
    LastValue[i-1]:=false;
    Erising[i-1]:=Frising[i];
    if Frising[i] then
      begin
        Jthreshold[i-1]:=round((EvtThreshold[i]-Y0u(i))/Dyu(i));
        JthresholdH[i-1]:=Jthreshold[i-1]-abs(round((EvtHysteresis[i])/Dyu(i)));
      end
    else
      begin
        Jthreshold[i-1]:=round((EvtThreshold[i]-Y0u(i))/Dyu(i));
        JthresholdH[i-1]:=Jthreshold[i-1]+abs(round((EvtHysteresis[i])/Dyu(i)));
      end;
  end;
end;


{ GetEvent reçoit en entrée un échantillon 16 bits et un numéro de voie
           sort la valeur 1 s'il y a eu un franchissement de seuil dans le bon sens

  utilise les variables globales LastValue, Jthreshold, JthresholdH, Erising
}
function GetEvent(x,v:smallint):smallint;pascal;assembler;
asm
{$IFNDEF WIN64}
     push  edi
     push  bx

     mov  bx,0

     mov  ax,x
     mov  edx,0
     mov  dx,v

     mov  edi,offset ERising     {Tester Rising}
     add  edi,edx
     cmp  byte ptr [edi],0
     je  @@04                    {On traite séparément les fronts descendants}


     mov  edi,offset LastValue   {Tester LastValue}
     add  edi,edx
     cmp  byte ptr [edi],0
     je  @@01

     mov  edi,offset JthresholdH {Si LastValue>0, comparer ax au seuil bas }
     add  edi,edx
     add  edi,edx
     cmp  ax, [edi]
     jg   @@02                   {S'il est plus grand, on ne fait rien}

     mov  edi,offset LastValue   {S'il est plus bas, on passe à l'état Bas}
     add  edi,edx
     mov  byte ptr [edi],0
     jmp  @@02

@@01:mov  edi,offset Jthreshold  {Si LastValue=0, comparer ax au seuil Haut }
     add  edi,edx
     add  edi,edx
     cmp  ax, [edi]
     jl   @@02

     mov  edi,offset LastValue   {Si ax est au dessus, on passe à l'état Haut}
     add  edi,edx
     mov  byte ptr [edi],1

     mov   bx,1                  { et on range 1 dans bx}
     jmp   @@02


@@04:mov  edi,offset LastValue   {Tester LastValue}
     add  edi,edx
     cmp  byte ptr [edi],0
     je  @@06

     mov  edi,offset JthresholdH {Si LastValue>0, comparer ax au seuil Haut }
     add  edi,edx
     add  edi,edx
     cmp  ax, [edi]
     jl   @@02                   {S'il est plus petit, on ne fait rien}

     mov  edi,offset LastValue   {S'il est plus grand, on passe à l'état Bas}
     add  edi,edx
     mov  byte ptr [edi],0
     jmp  @@02

@@06:mov  edi,offset Jthreshold  {Si LastValue=0, comparer ax au seuil Bas }
     add  edi,edx
     add  edi,edx
     cmp  ax, [edi]
     jg   @@02

     mov  edi,offset LastValue   {Si ax est en dessous, on passe à l'état Haut}
     add  edi,edx
     mov  byte ptr [edi],1

     mov   bx,1                  {et on range 1 dans bx}


@@02:mov   eax,0
     mov   ax,bx

     pop   bx
     pop   edi

{$ELSE}
     push  rdi
     push  rbx

     mov  rbx,0

     mov  ax,x
     mov  cx,v
     mov  rdx,0
     mov  dx,cx

     mov  rdi, offset ERising     {Tester Rising}
     add  rdi,rdx
     cmp  byte ptr [rdi],0
     je  @@04                    {On traite séparément les fronts descendants}


     mov  rdi,offset LastValue   {Tester LastValue}
     add  rdi,rdx
     cmp  byte ptr [rdi],0
     je  @@01

     mov  rdi,offset JthresholdH {Si LastValue>0, comparer ax au seuil bas }
     add  rdi,rdx
     add  rdi,rdx
     cmp  ax, [rdi]
     jg   @@02                   {S'il est plus grand, on ne fait rien}

     mov  rdi,offset LastValue   {S'il est plus bas, on passe à l'état Bas}
     add  rdi,rdx
     mov  byte ptr [rdi],0
     jmp  @@02

@@01:mov  rdi,offset Jthreshold  {Si LastValue=0, comparer ax au seuil Haut }
     add  rdi,rdx
     add  rdi,rdx
     cmp  ax, [rdi]
     jl   @@02

     mov  rdi,offset LastValue   {Si ax est au dessus, on passe à l'état Haut}
     add  rdi,rdx
     mov  byte ptr [rdi],1

     mov   rbx,1                  { et on range 1 dans bx}
     jmp   @@02


@@04:mov  rdi,offset LastValue   {Tester LastValue}
     add  rdi,rdx
     cmp  byte ptr [rdi],0
     je  @@06

     mov  rdi,offset JthresholdH {Si LastValue>0, comparer ax au seuil Haut }
     add  rdi,rdx
     add  rdi,rdx
     cmp  ax, [rdi]
     jl   @@02                   {S'il est plus petit, on ne fait rien}

     mov  rdi,offset LastValue   {S'il est plus grand, on passe à l'état Bas}
     add  rdi,rdx
     mov  byte ptr [rdi],0
     jmp  @@02

@@06:mov  rdi,offset Jthreshold  {Si LastValue=0, comparer ax au seuil Bas }
     add  rdi,rdx
     add  rdi,rdx
     cmp  ax, [rdi]
     jg   @@02

     mov  rdi,offset LastValue   {Si ax est en dessous, on passe à l'état Haut}
     add  rdi,rdx
     mov  byte ptr [rdi],1

     mov   rbx,1                  {et on range 1 dans bx}


@@02:mov   rax,0
     mov   rax,rbx

     pop   rbx
     pop   rdi


{$ENDIF}
end;



end.
