unit Pdma160;

interface

uses winTypes,winProcs,
     Messages, Classes, Graphics, Controls,
     Forms, Dialogs, StdCtrls,

     util1,dtf0,Dgraphic,stmDef,
     DirectD0,PDMA1632,
     debug0;

{
La carte PDMA16 permet l'acquisition de 16 entrées logiques en mode DMA.
Le buffer DMA est alloué par le programme PDMA-win qui doit être appelé dans
Autoexec.bat.
La taille du buffer est fixée à 8192 octets et la cadence d'acquisition est
fixée à 1 milliseconde. Il faut donc 4 secondes pour qu'il y ait un débordement
du buffer, ce qui est largement suffisant.

Pour piloter la carte, il suffit d'appeler LancerAcq et TerminerAcq.
La fonction getCountAcq renvoie le nombre de spikes détectés depuis le dernier
appel et range les spikes (transitions montantes sur une entrée) dans le
buffer evt.

evt est un tableau pouvant contenir jusqu'à 100000 spikes
}


procedure lancerAcq;
procedure terminerAcq;
function getCountAcq:longint;


{setTopSync permet d'ouvrir ou fermer la porte de sortie des tops synchro }
procedure setTopSync(Von:boolean);

{rangerSpike range un spike dans le tampon Evt }
procedure rangerSpike(code:word;t:longint);

{getNbSpike donne le nb de spikes entre 2 dates. Est utilisé par Replay}
function getNbSpike(t1,t2:float):longint;

{procédures pour debug}
procedure testCompteur;
procedure inspectTab;

implementation


const
  dma3:boolean=false;       { La carte peut utiliser DMA1 ou DMA3}

  NbPt=4096;
  tailleDmaBuf=nbPt*2;
  DmaCount=tailleDmaBuf-1;
  maxMask=$0FFF;            {= 4096-1 }

var
  oldCount:longint;
  nbtmp:longint;

  etatAB:word;


function inPort(n:word):byte;assembler;pascal;
asm
  mov  dx,n
  in   al,dx
end;

function inPortW(n:word):word;assembler;pascal;
asm
  mov  dx,n
  in   ax,dx
end;


procedure outPort(n:word;b:byte);assembler;pascal;
asm
  mov  dx,n
  mov  al,b
  out  dx,al
end;

var
  current302:byte;

procedure initAcq;
  var
    b:byte;
  begin
    b:=inport(8);                       {lire etat DMA}
    outport(BaseAddress+2,0);           {DMA reg}
    outPort(BaseAddress+3,0);           {INT reg}

    outPort(BaseAddress+7,$03A);        {programmation Timer0 en mode 5}
    outPort(BaseAddress+6,0);           {empêche son fonctionnement}
    outPort(BaseAddress+6,0);

    current302:=0;
  end;


procedure progTimers;
  begin
    outPort(BaseAddress+7,$03A);        {programmation Timer0 en mode 5}
    outPort(BaseAddress+6,0);           {empêche son fonctionnement}
    outPort(BaseAddress+6,0);

    outPort(BaseAddress+7,$0B4);        {programmation Timer2}
    outPort(BaseAddress+6,lo(tailleDmaBuf));
    outPort(BaseAddress+6,hi(tailleDmaBuf));

    outPort(BaseAddress+7,$074);        {programmation Timer1}
    outPort(BaseAddress+5,2);           {divise par 2}
    outPort(BaseAddress+5,0);           {donc sortie= 1 ms}

    outPort(BaseAddress+7,$034);        {programmation Timer0}
    outPort(BaseAddress+4,lo(5000));
    outPort(BaseAddress+4,hi(5000));    {sortie= 0.5 milliseconde}
  end;


procedure LancerAcq;
  var
    b:byte;
  begin
    nbEvt:=0;
    nbtmp:=0;
    oldCount:=-1;
    etatAB:=inportW(baseAddress);

    outPort($0A,5+2*ord(dma3));   {masquer}

    b:=inport(08);                {lire etat DMA}

    outPort($83-ord(dma3),segBuf);{Page canal 1}

    outPort($0C,0);               {Flip Flop à zéro}

    outPort(2+4*ord(dma3),lo(offsbuf));
    outPort(2+4*ord(dma3),hi(offsbuf));

    outPort($0C,0);               {Flip Flop à zéro}

    outPort(3+4*ord(dma3),lo(DmaCount));  {Count DMA}
    outPort(3+4*ord(dma3),hi(DmaCount));

    outPort($0B,5+$40+$10);       {Mode DMA  auto-init canal 1}

    current302:=$80+8+4;
    outPort(BaseAddress+2,current302);      {DMA enable+ source=timer +word}

    progTimers;

    outPort($0A,1+2*ord(dma3));   {démasquer DMA}
  end;

procedure setTopSync(Von:boolean);
begin
  if Von
    then outPort(BaseAddress+2,current302+$10)
    else outPort(BaseAddress+2,current302);
  topSynchro:=Von; {topSynchro est utilisé uniquement par la simulation}
end;


function lire2:word;assembler;pascal;
  asm
    mov  dx,BaseAddress
    add  dx,7
    mov  al,80h
    out  dx,al
    dec  dx
    in   al,dx
    xchg ah,al
    in   al,dx
    xchg ah,al
  end;

procedure testCompteur;
var
  i:integer;
begin
  progTimers;
  for i:=1 to 10000 do
   { affDebug(Istr(lire2));}
end;

procedure TerminerAcq;
  begin
    outPort($0A,5+2*ord(dma3));  {masquer canal DMA }

    initAcq;
  end;


procedure rangerSpike(code:word;t:longint);
  begin
    {affdebug('ranger '+Istr(nbevt));}
    if nbEvt>=maxNbEvt then exit;

    with evt^[nbEvt] do
    begin
      x:=code;
      date:=t;
    end;
    inc(nbEvt);
  end;

function getNbSpike(t1,t2:float):longint;
  const
    old:longint=0;
  var
    n,nb:longint;
  begin
    nb:=0;
    getNbSpike:=0;
    if old>=nbEvt then old:=0;
    with evt^[old]do
      if date<=t1 then n:=old
                  else n:=0;
    while (n<nbEvt) and (evt^[n].date<t1)
      do inc(n);
    if n=nbEvt then exit;

    while n<nbEvt do
    with evt^[n] do
    begin
      if (date<t2) and (x and TrackMask<>0) then inc(nb)
      else
        begin
          getNbSpike:=nb;
          old:=n-1;
          if old<0 then old:=0;
          exit;
        end;
      inc(n);
    end;

    getNbSpike:=nb;
  end;



function getCountAcq:longint;
  var
    n,nb:longint;
    x,y:word;
  begin
    n:=nbtmp*nbpt+nbpt-lire2 div 2;
    if n<oldCount then
      begin
        inc(n,nbpt);
        inc(nbtmp);
      end;
    {affdebug('n='+Istr(n));}

    nb:=0;
    while oldCount<n do
    begin
      inc(oldCount);
      x:=tab^[oldCount and maxMask];
      x:=x and ChannelMask;

      y:=not etatAB and x;
      if y<>0 then
        begin
          rangerSpike(y,oldCount);
          if y and TrackMask<>0 then inc(nb);
        end;
      etatAB:=x;
    end;

    getCountAcq:=nb;
  end;




{
procedure allocateDmaBuffer;
  var
    p:array[1..2000] of longint;
        i,n:integer;
    ad:longint;

  begin
    fillchar(p,sizeof(p),0);
    DmaBuf:=0;
    n:=0;
    repeat
      inc(n);
      if DmaBuf<>0 then globalDosFree(word(dmaBuf));
      p[n]:=globalDosAlloc(32);
      DmaBuf:=globalDosAlloc(tailleDmaBuf);
      ad:=longint(hiword(dmabuf))*16;
    until (DmaBuf=0) or (ad div (64*1024) -(ad+tailleDmabuf) div (64*1024)=0)
          or (n>=2000);

    for i:=1 to n do
      if p[i]<>0 then globalDosFree(word(p[i]));

    if (DmaBuf=0) or (n>=2000) then
      begin
        messageCentral('Unable to allocate DMA buffer');
        halt;
      end;

    offsBuf:=ad and $FFFF;
    segBuf:=ad shr 16;
    tab:=ptr(word(dmaBuf),0);
    fillchar(tab^,tailleDmaBuf,0);
  end;

procedure freeDmaBuffer;
  begin
    globalDosFree(word(DmaBuf));
  end;
}


procedure inspectTab;
  var
    st:string;
    i:integer;
  begin
    i:=0;
    repeat
      inc(i)
    until (i>=nbpt) or (tab^[i]<>0);
    messageCentral('i='+Istr(i));


    st:='';

    for i:=0 to 100 do
      begin
        st:=st+Istr(tab^[i])+' ';
        if i mod 10=0 then st:=st+#13;
      end;
    messageCentral(st);
    messageCentral(Istr(oldCount));
  end;


initialization


end.
