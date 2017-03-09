unit tops32;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses winTypes,winProcs,QTthunkG;

procedure initTopSync(numLPT:smallInt;dureeTop:longint);
procedure PulseSync;


implementation
var
  DLLhandle:Thandle;
  ad:array[1..2] of pointer;

procedure initTopSync(numLPT:smallInt;dureeTop:longint);
begin
  Call16BitG(ad[1],[numLPT,dureeTop],[2,4]);

end;

procedure PulseSync;
begin
  Call16BitG(ad[2],[0],[0]);
end;

Initialization
AffDebug('Initialization Tops32',0);
DLLhandle:=loadLib16('TOPS32.DLL');

ad[1] := GetProcAddress16(DLLHandle,'initTopSync' );
ad[2] := GetProcAddress16(DLLHandle,'PulseSync' );

finalization
freeLibrary16(DLLhandle);


end.
