unit D7_random1;

interface


function D7_randomR: double;stdCall;
function D7_randomI(n:integer): integer;stdCall;
procedure D7_randomize;stdCall;
procedure D7_setRandSeed(n:integer);stdCall;



implementation

function D7_randomR: double;
begin
  result:=random;
end;

function D7_randomI(n:integer): integer;
begin
  result:=random(n);
end;

procedure D7_randomize;
begin
  randomize;
end;

procedure D7_setRandSeed(n:integer);
begin
  randseed:=n;
end;



end.
