unit Heap0;

interface

uses windows, util1;

{
  getmemG, reallocmemG et FreememG ont le même rôle que les procédures système
  mais ne génèrent pas d'erreur

  En 32 bits, la valeur demandée size peut être supérieure  2 GB
}


procedure freememG(p: pointer);
function getmemG(var p: pointer; size: int64): boolean;
function reallocmemG(var P: Pointer; Size: Int64): boolean;


procedure testHeap0;
implementation

procedure testHeap0;
var
  p:PtabOctet;
  size:int64;
begin
  size:= int64(1) shl 32;
  getmem(p,size);
  fillchar(p^,size,1);
  messageCentral('Hello '+Int64str(size)+'  '+Istr(p^[size-1]));
  freemem(p);
end;

procedure freememG(p: pointer);
begin
  if p=nil then exit;
  freemem(p);
end;

function getmemG(var p: pointer; size: int64): boolean;
begin
  result:=true;
  if size=0 then p:=nil
  else
  try
    if size>=maxmem
      then result:= false
      else getmem(p,size);
  except
    result:= false;
    p:=nil;
  end;
end;

function reallocmemG(var P: Pointer; Size: Int64): boolean;
begin
  if size>maxmem then
  begin
    result:= false;
    exit;
  end;

  result:=true;
  try
  reallocmem(p,size);
  except
  result:=false;
  end;
end;


end.
