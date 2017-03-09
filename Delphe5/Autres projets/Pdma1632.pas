unit Pdma1632;

INTERFACE

uses util1,winTypes,winprocs,QTthunkG,Dgraphic,debug0;


const
  { Le buffer d'acquisition était installé par le driver NNiosWin }
  { Le driver Pdma-win a pour rôle d'installer ce buffer }
  { la dll pdma1632 permet la conversion en adresses linéaires }
  { installPointers  initialise les  variables ci-dessous }

  offsBuf:word=0;
  segBuf:word=0;
  tab:ptabEntier=nil;


procedure installPointers;


IMPLEMENTATION

var
  DLLhandle:Thandle;
  ad:array[1..3] of pointer;


procedure installPointers;
var
  ad1:longint;
begin
  call16bitG(ad[1],[0],[0]);                        { Init }
  longint(tab):=call16bitG(ad[3],[0],[0]);          { getRealTab }

  {messageCentral('tab='+chaineHexa(tab));}

  ad1:=longint(hiword(longint(tab)))*16+word(tab);
  offsBuf:=loWord(longint(ad1));
  segBuf:=hiword(longint(ad1));

  longint(tab):=call16bitG(ad[2],[0],[0]);          { getTab }
  {messageCentral('tabProt='+chaineHexa(tab));}

  tab:=ptr16to32(tab);
  {messageCentral('tabProt='+chaineHexa(tab)+' tab^[0]='+Istr(tab^[0]));}
end;


initialization
{affdebug('initialization Pdma1632');}

DLLhandle:=loadLib16('PDMA1632.DLL');
{messageCentral('DllHandle='+Istr(DLLhandle));}

ad[1] :=GetProcAddress16(DLLHandle,'init' );
ad[2] :=GetProcAddress16(DLLHandle,'getTab' );
ad[3] :=GetProcAddress16(DLLHandle,'getRealTab' );

installPointers;


finalization
freeLibrary16(DLLhandle);
affdebug('finalization Pdma1632');

end.
