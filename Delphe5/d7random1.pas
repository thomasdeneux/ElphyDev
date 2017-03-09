unit D7random1;

{$IFDEF FPC} {$mode delphi}{$H+} {$ENDIF}

interface

uses Windows,Util1;

function Grandom:double;overload;
function Grandom(n:integer):integer;overload;
procedure Grandomize;
procedure GsetRandSeed(n:integer);


implementation

{$IFDEF FPC}

const
  seed: integer=0;

function Rnd(maxValue:integer): integer;
var
  i: int64;

begin
  seed:=seed* $8088405 + 1;

  i := longword(seed) * int64(maxValue);
  i:=  i shr 32;

  result:= i;
end;


function Grandom:double;
begin
  result:= Grandom(maxEntierLong)/maxEntierLong;
end;

function Grandom(n:integer):integer;
var
  i: int64;
begin
  seed:=seed* $8088405 + 1;

  i := longword(seed) * int64(n);
  i:=  i shr 32;

  result:= i;
end;

procedure Grandomize;
begin
  seed:= GetTickCount;
end;

procedure GsetRandSeed(n:integer);
begin
  seed:=n;
end;

{$ELSE}

function Grandom:double;
begin
  result:= random;
end;

function Grandom(n:integer):integer;
begin
  result:=random(n);
end;

procedure Grandomize;
begin
  randomize;
end;

procedure GsetRandSeed(n:integer);
begin
  RandSeed:=n;
end;

{$ENDIF}

end.

