unit chrono0;

{Version Delphi}
INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses SysUtils,
     util1;



procedure initChrono;overload;
  { Initialise un chronomètre }

procedure initChrono(var tt:TdateTime);overload;

function chrono:AnsiString;overload;
  { Renvoie le temps écoulé depuis l'initialisation  du chronomètre
    sous la forme d'une chaîne de caractères.
    Exemple: '12h 18mn 32s 17c' }

function chrono(tt:TdateTime):AnsiString;overload;



IMPLEMENTATION


var
  t0:TdateTime;



procedure initChrono(var tt:TdateTime);
begin
  tt:=now;
end;

procedure initChrono;
begin
  t0:=Now;
end;


function chrono(tt:TdateTime):AnsiString;
  var
    t:TdateTime;
    h,m,s,c:word;
    dd:integer;
    sh,sm,ss,sc:string[12];
    st:AnsiString;
  begin
    t:=Now;
    decodeTime(t-tt,h,m,s,c);
    dd:=trunc(t-tt);

    Str(h+dd*24,sh);  Str(m,sm);  Str(s,ss);  Str(c div 10,sc);
    if h<>0 then st:=sh+'h ';
    if (h<>0) or (m<>0) then st:=st+sm+'mn ';
    if (h<>0) or (m<>0) or (s<>0) then st:=st+ss+'s ';
    st:=st+sc+'c';
    result:=st;
  end;

function chrono:AnsiString;
begin
  result:=chrono(t0);
end;



end.
