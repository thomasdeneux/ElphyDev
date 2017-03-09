unit wdigi1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

{ Gestion de la digidata 1200
  Utilisé par AcqBrd1
}

uses windows,
     util1,clock0,Dgraphic,stmDef;



procedure Init;
procedure Lancer(periode1,periode2:double;    {Période en microsecondes}
   realTab1,realtab2,{buffer DMA}
   nbpt1,nbpt2,      {taille du buffer DMA en points}
   nbvoie,           {nombre de voies}
   canalDMA1,canalDMA2:integer;
                     {canaux DMA: 5, 6 ou 7}
   voieAcq,          {tableau des voies physiques}
   GainAcq:T16bytes; {tableau des gains}
   dac1,dac2,TrigExterne:boolean  {programmer le DAC}
   );
procedure Terminer;

function GetCount:integer;

function InADC(n:integer):smallint;pascal;
procedure OutDIO(j:word);
function InDIO:smallint;
procedure OutDAC(num,j:word);

procedure StopDAC;
procedure RearmDAC;

IMPLEMENTATION

type
  Tcount=record
           case integer of
             1:(l,h:word);
             2:(ii:integer);
         end;

var
  count0:Tcount;


var
  tempoIO:word;                  { règle la vitesse d'accès au 9513}

  { il faut environ tempoIO=10 sur Pentium 100 }
  { pour obtenir 1 µs }

procedure testTempo;assembler;pascal;
  asm
       mov   ecx,0
       mov   cx,tempoIO
  @@1: xchg  ah,al
       xchg  ah,al
       loop  @@1
  end;


procedure CalculTempoIO;
  begin
    tempoIO:=5000;
    initTimer2;
    testTempo;
    tempoIO:=roundI(tempoIO/ getTimer2*3);    { 3 æs souhait‚ }
    if tempoIO<10 then tempoIO:=10;
    {messageCentral('tempo='+Istr(tempoIO));} { on trouve 115 sur Pentium 333 }
    tempoIO:=200;
  end;

procedure VTempo;assembler;pascal;
  asm
       push  ecx
       mov   ecx,0
       mov   cx,tempoIO
  @@1: xchg  ah,al
       xchg  ah,al
       loop  @@1
       pop   ecx
  end;


procedure wout;assembler;pascal;
  asm
                        { ralentissement des op‚rations }
       out   dx,al      { d'‚criture pour timer }

       push  ecx
       mov   ecx,0
       mov   cx,tempoIO
  @@1: xchg  ah,al
       xchg  ah,al
       loop  @@1
       pop   ecx
  end;

function win:word;assembler;pascal;
  asm
                        { ralentissement des op‚rations }
       in    al,dx      { de lecture pour timer }

       push  ecx
       mov   ecx,0
       mov   cx,tempoIO
  @@1: xchg  ah,al
       xchg  ah,al
       loop  @@1
       pop   ecx

  end;


function inB(ad:word):byte;assembler;pascal;
asm
  mov eax,0
  mov dx,ad
  in  al,dx
end;

function inW(ad:word):word;assembler;pascal;
asm
  mov dx,ad
  in  ax,dx
end;


procedure outB(ad:word;b:byte);assembler;pascal;
asm
  mov dx,ad
  mov al,b
  out dx,al
end;

procedure outW(ad:word;w:word);assembler;pascal;
asm
  mov dx,ad
  mov ax,w
  out dx,ax
end;


var
  canalDMA:byte;
  canalDADMA:byte;


Const

   Bit0  = $1;
   Bit1  = $2;
   Bit2  = $4;
   Bit3  = $8;
   Bit4  = $10;
   Bit5  = $20;
   Bit6  = $40;
   Bit7  = $80;
   Bit8  = $100;
   Bit9  = $200;
   Bit10 = $400;
   Bit11 = $800;
   Bit12 = $1000;
   Bit13 = $2000;
   Bit14 = $4000;
   Bit15 = $8000;

{ OFFSETs des registres de la DIGI1200 }

const
   DACdata =  $320;
   ADCdata =  $320;
   IDreg   =  $322;
   TMdata  =  $324;
   TMcsr   =  $326;
   TrigCtrl=  $328;
   DMAint  =  $32A;
   asDIO   =  $32C;
   ScanList=  $32E;
   TH0     =  $330;
   TH1     =  $332;
   TH2     =  $334;
   THctrl  =  $336;
   ADstatus=  $338;
   ClearReg=  $33A;


{ DMA register constants  }

	PageReg5 = $8B 	; (* DMA Page Select, channel 5 *)
	PageReg6 = $89 	; (* DMA Page Select, channel 6 *)
	PageReg7 = $8A 	; (* DMA Page Select, channel 7 *)
	BaseReg5 = $C4  ; (* Base Address, channel 5	*)
	CountReg5 = $C6 ; (* Word Count, channel 5      *)
	BaseReg6 = $C8  ; (* Base Address, channel 6  	*)
	CountReg6 = $CA ; (* Word Count, channel 6 	*)
	BaseReg7 = $CC  ; (* Base Address, channel 7	*)
	CountReg7 = $CE ; (* Word Count, channel 7	*)
	MaskReg	= $D4	; (* Mask Register		*)
	ModeReg = $D6	; (* Mode Register		*)
	FlipFlop = $D8  ; (* Byte Pointer Flip/Flop	*)

        PageReg:array[5..7] of byte=(PageReg5,PageReg6,PageReg7);
        BaseReg:array[5..7] of byte=(BaseReg5,BaseReg6,BaseReg7);
        CountReg:array[5..7] of byte=(CountReg5,CountReg6,CountReg7);


(* Interrupt register constants *)

	IntCommandMaster = $20 ; (* Command register address for master 8259 *)
	IntCommandSlave = $A0 ;  (* Command register address for slave 8259  *)
	IntEOI = $20         ;   (* Non-specific END OF INTERRUPT command    *)

(* Interrupt definitions pre-defined for interrupt level 15 (FC) *)

	IntMaskReg      : integer = $A1  ; (* 8259 Mask Register address *)
	IntVectorCode   : integer = $2577; (* Set Vector Code and number *)
	IRQline	: integer = $80  ; (* IRQ bit value of Mask      *)


{programmation du 9513}

const
  highTcPulse=1;
  TCtoggle=2;
  HighImpedance=4;
  LowTCpulse=5;

  up=8;
  dw=0;

  binary=0;
  bcd=$10;

  Conce=0;
  Crepeat=$20;

  srcTC=0;
  src1=1;
  src2=2;
  src3=3;
  src4=4;
  src5=5;
  gate1=6;
  gate2=7;
  gate3=8;
  gate4=9;
  gate5=10;
  f1=11;
  f2=12;
  f3=13;
  f4=14;
  f5=15;

  RisingEdge=0;
  FallingEdge=$10;

  NoGating=0;
  gatingTC=$20;
  gatingHGNp1=$40;
  gatingHGNm1=$60;
  gatingHGN=$80;
  gatingLGN=$A0;
  gatingHedgeN=$C0;
  gatingLedgeN=$E0;


{ *************************************************************************}
{ *******************   Gestion de l'horloge Temps réel    ****************}
{ *************************************************************************}

{ Les 3 compteurs sont mont‚s en cascade.
  Le 0 est activ‚ par une horloge … 4 MHz. On lui donne une valeur compteur
  de 40. Sa sortie bascule toutes les 10 microsecondes.
  Le 1 et le 2 re‡oivent une valeur compteur de 0. Leur lecture combin‚e
  donne un temps en dizaines de microsecondes. Maximum= 4E7 ms=10 heures.

}




procedure prog0(n:word);assembler;pascal;
 asm
    mov  dx,THctrl
    mov  al,34h
    out  dx,al
    mov  dx,TH0
    mov  ax,n
    out  dx,al
    xchg ah,al
    out  dx,al
 end;

procedure prog1(n:word);assembler;pascal;
 asm
    mov  dx,THctrl
    mov  al,74h
    out  dx,al
    mov  dx,TH1
    mov  ax,n
    out  dx,al
    xchg ah,al
    out  dx,al
 end;

procedure prog2(n:word);assembler;pascal;
 asm
    mov  dx,THctrl
    mov  al,0B4h
    out  dx,al
    mov  dx,TH2
    mov  ax,n
    out  dx,al
    xchg ah,al
    out  dx,al
 end;

function lire0:word;assembler;pascal;
  asm
    mov  dx,THctrl
    mov  al,0h
    out  dx,al
    mov  dx,TH0
    in   al,dx
    xchg ah,al
    in   al,dx
    xchg ah,al
  end;

function lire1:word;assembler;pascal;
  asm
    mov  dx,THctrl
    mov  al,40h
    out  dx,al
    mov  dx,TH1
    in   al,dx
    xchg ah,al
    in   al,dx
    xchg ah,al
  end;

function lire2:word;assembler;pascal;
  asm
    mov  dx,THctrl
    mov  al,80h
    out  dx,al
    mov  dx,TH2
    in   al,dx
    xchg ah,al
    in   al,dx
    xchg ah,al
  end;

procedure resetTH;assembler;pascal;
  asm
    mov  dx,THctrl
    mov  al,0B0h
    out  dx,al
    mov  dx,TH2

    mov  ax,0
    out  dx,al
    xchg ah,al
    out  dx,al

    mov  dx,THctrl
    mov  al,74h
    out  dx,al
    mov  dx,TH1
    mov  ax,1h
    out  dx,al
    xchg ah,al
    out  dx,al

    mov  dx,THctrl
    mov  al,34h
    out  dx,al
    mov  dx,TH0
    mov  ax,40
    out  dx,al
    xchg ah,al
    out  dx,al

  @@1:call lire2
    cmp  ax,0
    jne  @@1

    mov  dx,THctrl
    mov  al,74h
    out  dx,al
    mov  dx,TH1
    mov  ax,0
    out  dx,al
    xchg ah,al
    out  dx,al

  @@2:call lire1
    cmp  ax,0
    jne  @@2
 end;


function dateTH:longint;assembler;pascal;
  asm
    @@1:
    call lire2
    dec  ax
    not  ax
    push ax
    call lire1
    dec  ax
    not  ax
    pop  dx

    push ax
    push dx
    call lire2
    dec  ax
    not  ax
    mov  bx,ax
    pop  dx
    pop  ax

    cmp  bx,dx
    jne  @@1

    cmp  ax,0FFFFh
    je   @@1

    xchg ax,dx          {on range ax-dx dans eax. On peut sûrement faire mieux }
    mov  cl,16
    shl  eax,cl
    mov  ax,dx
  end;


function DriverName:Pchar;
begin
  result:='DigiData 1200';
end;



procedure Init;
  begin
    CalculTempoIO;

    outDac(0,0);
    outDac(1,0);
    outDIO(0);

    asm
      mov  dx,ClearReg      { Reset Digi }
      mov  ax,0FF7Fh
      out  dx,ax            { cette instruction ne modifie pas les sorties }

      call Vtempo
    end;
  end;

{ *************************************************************************}


function pageDMA(tb:longint):byte;
  var ad:longint;
  begin
    ad:=hiword(tb)*16+loword(tb);
    pageDMA:=(ad shr 16) AND $E;
  end;

function baseDMA(tb:longint):word;
  var ad:longint;
  begin
    ad:=hiword(tb)*16+loword(tb);
    baseDMA:=(ad shr 1) AND $FFFF;
  end;


function lireAD:smallint;assembler;pascal;
  asm
           mov   dx,ClearReg           { soft trigger }
           mov   ax,bit7
           out   dx,ax
           call  Vtempo

   @@1:    mov   dx,ADstatus           { attendre conversion }
           in    al,dx
           and   al,bit6
           jne   @@2
           mov   dx,asDIO
           in    al,dx                 { on teste l'entr‚e 1 }
           and   al,2                  { si elle vaut 1, on sort. }
           je    @@1

   @@2:    mov   dx,ADCdata            { lire data }
           in    ax,dx

           mov   dx,cx
           mov   cl,4
           sar   ax,cl                 { shift 16 }
           mov   cx,dx

           push  ax
           mov   dx,clearReg
           mov   ax,bit4
           out   dx,ax
           call  Vtempo
           pop   ax
   end;




function inADC(n:integer):smallint;assembler;
  asm
           mov  dx,TMcsr               { reset du 9513 }
           mov  al,0FFh
           call wout

           mov  dx,TrigCtrl            { Prog Scan List }
           mov  ax,bit4+bit3
           call wout

           mov  dx,Scanlist
           mov  al,0
           mov  ah,byte ptr n
           or   ax,bit15
           out  dx,ax
           call Vtempo

           mov  dx,TrigCtrl
           mov  ax,+bit3
           call wout

           mov  dx,ClearReg            { reset AD FIFO }
           mov  ax,bit4
           call wout

           call  lireAD
  end;



procedure delai;
var
  i:integer;
begin
  for i:=1 to 20000 do Vtempo;  {60 ms}
end;

procedure progTM(num,lbyte,hbyte:byte;tempo:word);
begin
  outB(TMcsr,num);
  outW(TMdata,word(hbyte) shl 8+lbyte);

  outW(TMdata,tempo);
end;


procedure setOutPut(n:byte;b:boolean);
begin
  outB(TMcsr,$E0+n+8*ord(b));
end;

procedure loadAndArm(b1,b2,b3,b4,b5:boolean);
begin
  outB(TMcsr,$60+ord(b5)*$10+
                +ord(b4)*8+
                +ord(b3)*4+
                +ord(b2)*2+
                +ord(b1)
  );
end;


var
  tempo1,tempo2:integer;
  multi:integer;

  _realtab2,_nbpt2:integer;
  _dac1,_dac2:boolean;


procedure Lancer(periode1,periode2:double;realTab1,realtab2,nbpt1,nbpt2,
                     nbvoie,canalDMA1,canalDMA2:integer;
                     voieAcq,GainAcq:T16bytes;
                     dac1,dac2,TrigExterne:boolean
                     );
  var
    x,y:word;
    i:integer;

    adBaseBuf:word;
    PageBuf:byte;
    DMAintWord:word;

  begin
    {messageCentral('nbvoie DLL='+Istr(nbvoie));}
    count0.ii:=0;

    {Controler voieAcq: de 0 à 15}
    {Controler GainAcq: de 0 à 3}

    for i:=1 to nbvoie do
      begin
        voieAcq[i]:=voieAcq[i] and $F;
        gainAcq[i]:=(gainAcq[i]-1) and 3;
      end;

    _realTab2:=realTab2;
    _nbpt2:=nbpt2;
    _dac1:=dac1;
    _dac2:=dac2;

    canalDMA:=canalDMA1;
    canalDADMA:=canalDMA2;

    tempo1:=roundL(periode1*4);
    tempo2:=roundL(periode2*4);

    if not (dac1 or dac2) then tempo2:=tempo1;

    multi:=1;
    while ((tempo1>65535) or (tempo2>65535)) and (multi<5) do
    begin
      tempo1:=tempo1 div 10;
      tempo2:=tempo2 div 10;

      inc(multi);
    end;


    {Programmer les timers}
    outW(clearReg,$0F7F);     { Reset Digi }
    outB(TMcsr,$FF);          { reset du 9513 }
    Vtempo;
    outB(TMcsr,$17);          { master mode reg }
    Vtempo;
    outB(TMdata,$B0);         { source F1 }
    Vtempo;
    outB(TMdata,$AA);         { BCD   diviseur Fout=10  mode 16bits }
    Vtempo;

    { Timer 2 pilote ADC
      Timer 1 pilote DAC
      Les 2 timers sont lancés en même temps si trig interne. Sinon, timer 1
      est sensible au gate1 qui est relié à OUT4. Timer4 a lui-même son gate
      relié à l'entrée Start du boitier DigiData.
      Timer3 compte les pulses envoyés par Timer2
    }

    progTM(4,TCtoggle+Conce,f1+gatingHedgeN,10); {timer 4}
    setOutPut(4,false);               { set output 4=low }

    x:=$0A+multi;
    progTM(2,highTcPulse+Crepeat,x,tempo1);     {timer 2 }

    if trigExterne then x:=x+gatingHGN;
    progTM(1,highTcPulse+Crepeat,x,tempo2);     {timer 1 }

    progTM(3,highTCpulse+up+Crepeat,srcTC,0);  {timer 3}


    { programmer le premier DMA }
    adBaseBuf:=BaseDMA(realtab1);
    PageBuf:=PageDMA(realtab1);

    outB(ModeReg ,$15+canalDMA-5);   { $15 }   { auto-init + écriture }
    outB(FlipFlop , 0);
    outB(BaseReg[canalDMA] , LO(adBaseBuf));
    outB(BaseReg[canalDMA] , HI(adbaseBuf));
    outB(CountReg[canalDMA] , LO(nbpt1-1)) ;
    outB(CountReg[canalDMA] ,HI(nbpt1-1));
    outB(PageReg[canalDMA] , PageBuf);
    outB(MaskReg , canalDMA-4) {1};

    { programmer le 2ème DMA }
    if dac1 or dac2 then
      begin
        adBaseBuf:=BaseDMA(realtab2);
        PageBuf:=PageDMA(realtab2);

        outB(ModeReg ,$18+canalDADMA-4);      { auto-init + lecture }
        outB(FlipFlop , 0);
        outB(BaseReg[canalDADMA] , LO(adBaseBuf));
        outB(BaseReg[canalDADMA] , HI(adBaseBuf));
        outB(CountReg[canalDADMA] , LO(nbpt2-1));
        outB(CountReg[canalDADMA] ,HI(nbpt2-1));
        outB(PageReg[canalDADMA] , PageBuf);
        outB(MaskReg , canalDADMA-4) {1};
      end;


    outW(TrigCtrl,bit4);    { programmer Scan list }
    for i:=1 to nbvoie-1 do
      begin
        outW(ScanList,i-1+word(voieAcq[i]) shl 8
                          +word(gainAcq[i]) shl 13);
      end;
    outW(ScanList,nbvoie-1
                     +word(voieAcq[nbvoie]) shl 8
                     +word(gainAcq[nbvoie]) shl 13
                     +bit15);
    outW(TrigCtrl,0);

    x:=bit5+bit6;         {bit5 établit les liaisons OUT3-GATE2 et OUT4-GATE1}
    if dac1 or dac2 then  {bit6 est le mode normal digidata}
      begin
        if dac1 then
          begin
            x:=x+bit0;
            outW(TrigCtrl,x );
          end;
        if dac2 then x:=x+bit1;
      end;

    x:=x+bit2;             {bit2=DAC commandé par timer1}

    outW(TrigCtrl,x );

    case CanalDMA of
      5: DMAintWord:=$11;
              {01 pour transfert par blocs }
      6: DMAintWord:=$12;
      7: DMAintWord:=$13;
      else  DMAintWord:=$11;
    end;

    if dac1 or dac2 then
    case canalDADMA of
      5: DMAintWord:=DMAintWord+4;
      6: DMAintWord:=DMAintWord+$8;
      7: DMAintWord:=DMAintWord+$0C;
    end;

    outW(DMAint,DMAintWord);   {cette instruction dure 9 millisecondes}
                               {quand le DAC est programmé}

    if dac1 or dac2
      then x:=$7F              { load and arm 1 à 5}
      else x:=$66;             { load and arm 2 et 3}
    outB(TMcsr,x);

  end;

procedure terminer;
begin
  asm
        mov   dx,MaskReg      { masquer DMA }
        mov   al,canalDMA {5}
        out   dx,al

        mov   dx,MaskReg      { masquer DMA 2}
        mov   al,canalDADMA
        out   dx,al

        mov  dx,ClearReg      { reset carte }
        mov  al,7Fh
        call wout

        mov  dx,TMcsr         { reset du 9513 }
        mov  al,0FFh
        call wout

        mov  dx,DMAint
        mov  ax, 0            { ADC DMA  disable }
        out  dx,ax
  end;
end;

procedure StopDAC;
begin
  outB(TMcsr,$C9);              { disarm counter 1 et 4}
  outB(MaskReg,canalDADMA);     { masquer DMA 2}
end;

procedure RearmDac;
  var
    x,y:word;
    i:integer;

    adBaseBuf:word;
    PageBuf:byte;
    DMAintWord:word;

  begin

    progTM(4,TCtoggle+Conce,f1+gatingHedgeN,10); {timer 4}
    setOutPut(4,false);               { set output 4=low }

    x:=$0A+multi+gatingHGN;
    progTM(1,highTcPulse+Crepeat,x,tempo2);     {timer 1 }

    { programmer le 2ème DMA }
    adBaseBuf:=BaseDMA(_realtab2);
    PageBuf:=PageDMA(_realtab2);

    outB(ModeReg ,$18+canalDADMA-4);      { auto-init + lecture }
    outB(FlipFlop , 0);
    outB(BaseReg[canalDADMA] , LO(adBaseBuf));
    outB(BaseReg[canalDADMA] , HI(adBaseBuf));
    outB(CountReg[canalDADMA] , LO(_nbpt2-1));
    outB(CountReg[canalDADMA] ,HI(_nbpt2-1));
    outB(PageReg[canalDADMA] , PageBuf);
    outB(MaskReg , canalDADMA-4) {1};


    case CanalDMA of
      5: DMAintWord:=$11;
              {01 pour transfert par blocs }
      6: DMAintWord:=$12;
      7: DMAintWord:=$13;
      else  DMAintWord:=$11;
    end;

    case canalDADMA of
      5: DMAintWord:=DMAintWord+4;
      6: DMAintWord:=DMAintWord+$8;
      7: DMAintWord:=DMAintWord+$0C;
    end;

    outW(ClearReg,bit3);       {clear DA FIFO }


    x:=bit5+bit6+bit2;
    outW(TrigCtrl,x );

    x:=x+bit0;
    outW(TrigCtrl,x );

    if _dac2 then x:=x+bit1;
    outW(TrigCtrl,x );


    outW(DMAint,DMAintWord);   {cette instruction dure 9 millisecondes}
                               {quand le DAC est programmé}

    outB(TMcsr,$69);           { load and arm 1 et 4}
  end;


function GetCount:integer;
var
  w:word;
begin
  outB(TMcsr,$A4);         {save timer 3}
  Vtempo;
  outB(TMcsr,$13);
  Vtempo;
  w:=inW(TMdata);

  if w<count0.l then inc(count0.h);
  count0.l:=w;
  result:=count0.ii-1;
  if result<0 then result:=0;
end;



procedure outDIO(j:word);
begin
  asm
    mov  ax,bit5+bit6+bit3
    mov  dx,TrigCtrl
    out  dx,al

    mov  dx,asDIO
    mov  ax,j
    call wout
  end;
end;

function inDIO:smallint;
begin
  asm
    mov  dx,asDIO
    in  al,dx
    mov ah,0
  end;
end;


{num vaut 0 ou 1}
procedure OutDAC(num,j:word);
begin
  asm
    mov  ax,num
    inc  ax
    and  ax,3
    add  ax,bit5+bit6+bit2
    mov  dx,TrigCtrl
    out  dx,al

    mov  dx,DACdata
    mov  ax,j
    sal  ax,4
    out  dx,ax

    mov  ax,bit5+bit6
    mov  dx,TrigCtrl
    out  dx,al

  end;
end;


end.



