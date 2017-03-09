unit wlab;

interface

uses windows,util1,clock0,Dgraphic;

type
  T16bytes=array[1..16] of byte;

function DriverName:Pchar;stdCall;

procedure Init;stdCall;
procedure Lancer(periode:double;    {Période en microsecondes}
   realTab1,realtab2,{buffer DMA}
   nbpt1,nbpt2,      {taille du buffer DMA en points}
   nbvoie,           {nombre de voies}
   canalDMA1,canalDMA2:integer;
                     {canaux DMA: 5, 6 ou 7}
   voieAcq,          {tableau des voies physiques}
   GainAcq:T16bytes; {tableau des gains}
   dac1,dac2,TrigExterne:boolean  {programmer le DAC}
   );stdCall;
procedure Terminer;stdCall;




implementation

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


function DriverName:Pchar;
begin
  result:='Labmaster DMA 100';
end;

procedure init;
begin
  CalculTempoIO;
end;

procedure lancer (periode:double;    {Période en microsecondes}
                     realTab1,realtab2,
                                       {buffer DMA}
                     nbpt1,nbpt2,      {taille du buffer DMA en points}
                     nbvoie,           {nombre de voies}
                     canalDMA1,canalDMA2:integer;
                                       {canaux DMA: 5, 6 ou 7}
                     voieAcq,          {tableau des voies physiques}
                     GainAcq:T16bytes; {tableau des gains}
                     dac1,dac2,TrigExterne:boolean  {programmer le DAC}
                     );
var
  x,y:word;
  i:integer;
  tempo1:integer;
  multi:integer;

  adBaseBuf:word;
  PageBuf:byte;
  DMAintWord:word;
  ad:longint;
  offsBuf,segBuf:word;

begin
  tempo1:=roundL(periode);

  multi:=1;
  while (tempo1>65535) and (multi<5) do
  begin
    tempo1:=tempo1 div 10;
    inc(multi);
  end;

  ad:=loword(realtab1)+hiword(realtab1)*16;
  offsBuf:=ad and $FFFF;
  segBuf:=ad shr 16;

  asm
                mov  dx,719h
                mov  al,17h            {master mode reg}
                call wout
                dec  dx
                mov  al,0B0h
                call wout
                mov  al,8Ah
                call wout

                mov  dx,719h
                mov  al,5              {timer 5}
                call wout
                dec  dx
                mov  al,21h
                call wout

                mov  al,0Ah            {no gating}
                add  al,byte ptr multi
                call wout

                mov  ax,word ptr tempo1{période}
                call wout
                xchg al,ah
                call wout


                mov  dx,719h
                mov  al,1              {timer 1}
                call wout
                dec  dx
                mov  al,21h
                call wout
                mov  al,0              {source=sortie 5}
                call wout

                mov  ax,word ptr Nbpt1
                call wout
                xchg al,ah
                call wout

                mov  dx,719h
                mov  al,2               {timer 2}
                call wout
                dec  dx
                mov  al,29h             {incrémente}
                call wout
                mov  al,0h              {source= out 1}
                call wout

                mov  ax,0               {commence à zéro}
                call wout
                xchg al,ah
                call wout


                mov   al,5              {07h           ;masquer canal DMA nø1}
                mov   dx,0Ah
                call  wout

                mov   dx,008h           {lire etat DMA}
                in    al,dx

                mov   al,80h            {AD/IRQ control}
                mov   dx,714h
                out   dx,al

                mov   al,0              {DMA control}
                mov   dx,71Ah
                out   dx,al

                mov   dx,715h           {canal 255}
                mov   al,255
                out   dx,al

                mov   dx,716h           {reset done}
                in    al,dx
                out   dx,al             {go}

                mov   dx,714h           {une conversion qui positionne}
  @@1:          in    al,dx             {multiplexeur}
                rol   al,1
                jae   @@1

                mov   dx,716h
                in    al,dx             {reset done}



                mov   ax,SegBuf         {Page canal 1}
                mov   dx,083h           {082h}
                call  wout

                mov   al,0              {Flip Flop à zéro}
                mov   dx,0Ch
                call  wout

                mov   ax,offsBuf        {Base DMA}
                mov   dx,02h            {06h}
                call  wout
                xchg  al,ah
                call  wout

                mov   al,0              {Flip Flop à zéro}
                mov   dx,0Ch
                call  wout

                mov   ax,word ptr nbpt1  {Count DMA}
                shl   ax,1
                dec   ax
                mov   dx,03h            {07h}
                call  wout
                xchg  al,ah
                call  wout

                mov   al,05+40h+10h     {Mode DMA  auto-init canal 1}
                mov   dx,0Bh
                call  wout


                mov  dx,714h
                mov  al,4               {enable external trigger}
                cmp  nbVoie,1          {si 1 voie, pas d'auto-incrément}
                jne  @@2
                add  al,80h

  @@2:          call wout

                mov  al,1+4
                mov  dx,71Ah             {enable DMA}
                call wout

                mov  ax,16
                sub  ax,word ptr nbvoie
                mov  dx,715h
                call wout                {numero voie=16-Qnbvoie}

                inc  dx
                in   al,dx               {reset done overrun}


                mov   al,01h             {03h   ;supprimer masquage canal 1}
                mov   dx,0Ah
                call  wout

                mov  dx,719h
                mov  al,77h              {load and arm timers 1,2,3 et 5}
                call wout
  end;
  {
  messageCentral('Periode='+Estr(periode,3)+#10+
                 'nbpt1='+Istr(nbpt1)+#10+
                 'nbvoie='+Istr(nbvoie)
                 );
  }
end;


procedure Terminer;
begin
  asm
                mov  dx,719h
                mov  al,90h
                call wout              {disarm and save timer 5}

                mov   al,05h           {07h     ;masquer le canal DMA nø1}
                mov   dx,0Ah

                mov   al,80h           {AD/IRQ control}
                mov   dx,714h
                out   dx,al

                mov   al,0             {DMA control}
                mov   dx,71Ah
                out   dx,al

                mov   dx,715h          {canal 255}
                mov   al,255
                out   dx,al

                mov   dx,716h          {reset done}
                in    al,dx
                out   dx,al            {go}

                mov   dx,714h          {une conversion qui positionne}
  @@1:          in    al,dx            {multiplexeur}
                rol   al,1
                jae   @@1

                mov   dx,716h
                in    al,dx            {reset done}

                mov   dx,715h          {canal 255}
                mov   al,255
                out   dx,al

                mov   dx,716h          {reset done}
                in    al,dx
                out   dx,al            {go}

  end;
end;


end.
