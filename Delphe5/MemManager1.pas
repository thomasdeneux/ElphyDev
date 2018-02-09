unit MemManager1;

interface

uses classes, math,
     util1, ipps17;


type
  TmemRec= object
              p:pointer;               { adresse vraie du bloc mémoire }
              size:integer;            { taille du bloc }
              index:integer;           { index du TmemRec dans list }
              pf: procedure of object;
              function Pend:pointer;   { pointe juste après le bloc }
           end;
  PmemRec=^TmemRec;

  TmemManager =  class
                 private
                   Pmem0, Pmem: pointer;
                   MemSize:integer;
                   list: Tlist;
                   IsComp:boolean;
                   AllocSize:integer;

                   function allocBlock1(sz:integer): PmemRec;
                 public
                   constructor create(sz:integer);
                   destructor destroy;

                   function allocBlock(sz:integer): PmemRec;
                   function ReallocBlock(var p:PmemRec;size:integer; Fzero:boolean): boolean;
                   function freeBlock( p:PmemRec): boolean;
                   procedure compress;
                   function Info:AnsiString;
                 end;

function MemManager: TmemManager;

implementation

Var
  FmemManager: TmemManager;


function MemManager: TmemManager;
begin
  if not assigned(FmemManager) then FmemManager:=TmemManager.create(MemManagerSize*1024*1024);
  result:= FmemManager;
end;

{ TmemManager }

function TmemManager.allocBlock1(sz: integer): PmemRec;
var
  i,ind:integer;
  d:integer;
  memRec:PmemRec;
  sz1:integer;
begin
  sz1:=ceil(sz/32)*32;

  ind:=0;
  if list.count=0
    then d:= MemSize
    else d:= intG(PmemRec(list[0])^.p)-intG(Pmem);     {taille disponible avant le premier bloc }

  if d<sz1 then
  for i:=0 to list.count-2 do
  begin
    d:=intG(PmemRec(list[i+1])^.p)- intG(PmemRec(list[i])^.Pend); {taille disponible entre deux blocs }
    ind:=i+1;
    if d>=sz1 then break;
  end;
  if (d<sz1) and (list.Count>0) then
  begin
    d:=intG(PMem)+MemSize-intG(PmemRec(list[list.Count-1])^.Pend); {taille après le dernier bloc}
    ind:=list.Count;
  end;

  if d>=sz1 then
  begin
    new(memRec);
    if (list.count=0) or (ind=0)
      then memRec^.p:= Pmem
      else memRec^.p:= PmemRec(list[ind-1])^.Pend;
    result:=memRec;
    memRec^.size:= sz1;
    memRec^.index:=ind;
    memRec^.pf:=nil;
    list.Insert(ind,memRec);
    for i:=ind to list.Count-1 do PmemRec(list[i])^.index:=i;
  end
  else result:=nil;
end;

function TmemManager.allocBlock(sz: integer): PmemRec;
begin
  if MemSize=0 then
  begin
    result:=nil;
    exit;
  end;

  result:=AllocBlock1(sz);
  if result=nil then
  begin
    compress;
    result:=AllocBlock1(sz);
  end;
  if result<>nil then AllocSize:=AllocSize + ceil(sz/32)*32;
end;

procedure TmemManager.compress;
var
  i:integer;
  ps: pointer;
begin
  if IsComp then exit;

  ps:=Pmem;
  for i:=0 to list.Count-1 do
  with Pmemrec(list[i])^ do
  begin
    if ps<>p then
    begin
      move(p^,ps^,size);
      p:=ps;
      if assigned(pf) then pf();
    end;
    intG(ps) := intG(ps)+size;
  end;
  IsComp:=true;
end;

constructor TmemManager.create(sz: integer);
begin
  if sz<>0 then
  begin
    getmem(Pmem0,sz+32);
    if longword(Pmem0) and 31=0
      then Pmem:=Pmem0
      else Pmem:=pointer(longword(Pmem0) and $FFFFFFE0 +32);
  end;
  MemSize:=sz;
  list:=Tlist.Create;
  IsComp:=true;
end;

destructor TmemManager.destroy;
begin
  list.free;
end;

function TmemManager.freeBlock(p: PmemRec): boolean;
var
  pp:PmemRec;
  i,k:integer;
  st:AnsiString;
begin
  result:=false;
  if assigned(p) and (p^.index>=0) and (p^.index< list.count) then
  begin
    k:= p^.index;
    IsComp:=(k=list.Count-1);
    AllocSize:=AllocSize-p^.size;

    dispose(PmemRec(list[k]));
    list.Delete(k);
    for i:=k to list.count-1 do
      PmemRec(list[i])^.index:=i;

    result:=true;
  end
  else
  begin
    st:='FreeBlock error p='+ Pstr(p);
    if assigned(p) then st:=st+' index='+Istr(p^.index);
    st:=st+' count='+Istr(list.count);
    messageCentral(st)  ;
  end;
end;

function TmemManager.ReallocBlock(var p: PmemRec; size: integer; Fzero: boolean): boolean;
var
  Pnew:Pmemrec;
begin
  result:=true;
  if size>p^.size then
  begin
    Pnew:=allocBlock(size);
    if Pnew<>nil then
    begin
      move(p^.p, pNew^.p,p^.size);
      if Fzero then ippsZero_8u(Pbyte(@PtabOctet(Pnew^.p)^[p^.size]),Size - p^.size);
      FreeBlock(p);
      p:=Pnew;
    end
    else
    begin
      messageCentral('Unable to realloc block size='+Istr(size));
      result:=false;
    end  
  end
  else p^.size:=size;

end;

function TmemManager.Info: AnsiString;
begin
  result:='Managed Memory =   ' + Estr1(MemSize/1E6,12,6)  +' Mb'+crlf+
          'AllocSize      =   ' + Estr1(AllocSize/1E6,12,6)+' Mb'+crlf+
          'Count          =   ' + Istr(list.Count);
end;

{ TmemRec }

function TmemRec.Pend: pointer;
begin
  result:=pointer(intG(p)+size);
end;


end.
