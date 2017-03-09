unit ListG;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysutils,util1,Gdos;


{ TlistG est semblable à Tlist mais ne manipule pas forcément des pointeurs.

 Quand on appelle create, on fournit la taille T des éléments rangés dans la liste.
 Ensuite, les méthodes manipulent des pointeurs sur des éléments de taille T .

 Quand on appelle add(item), add effectue une copie de ce qui est pointé par item.
 Indexof(item) compare ce qui est pointé par item aux éléments de la liste.
 Etc..


 Avec getSortedItemDword, on suppose que l'un des champs de T est de type Dword et
que la liste est triée suivant les valeurs croissantes de ce champ.
  On donne comme argument le déplacement dep du champ dans T et une valeur particulière ad
de ce champ.
  La fonction renvoie un pointeur sur l'élément trouvé contenant ad s'il existe ou bien sur
l'élément se trouvant juste avant.
  La fonction renvoie donc toujours quelque chose. Si ad est inférieure à la première valeur
de la liste, c'est la première valeur qui est renvoyée.

 Read/write permettent de sauver/charger la liste.
 Utilisés actuellement par stmGraph2

 ATTENTION : la liste peut être réallouée après un certain nombre de manipulations, donc
les adresses sont toujours temporaires.

}

const
{ Maximum TlistG size }
  maxEltSize=1000;

//  MaxListSize = Maxint div (maxEltSize*2); modifié le 23 08 2010


{ TlistG class }

type
  TListSortCompare = function (Item1, Item2: Pointer): Integer;

  TlistG = class(TObject)
  private
    FList: PtabOctet;
    FCount: Integer;
    FCapacity: Integer;
    FeltSize:integer;
    Fsorted:boolean;
    MaxListSize:integer;
  protected
    function Get(Index: Integer): Pointer;
    procedure Put(Index: Integer; Item: Pointer);
    procedure Grow; virtual;
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetCount(NewCount: Integer);
  public
    constructor create(nb:integer);
    destructor Destroy; override;
    function Add(Item: Pointer): Integer;
    function AddEmpty:pointer;
    procedure Clear; virtual;
    procedure Delete(Index: Integer);

    procedure Error(Data: Integer);

    procedure Exchange(Index1, Index2: Integer);
    function Expand: TlistG;
    function Extract(Item: Pointer): Pointer;
    function First: Pointer;
    function IndexOf(Item: Pointer): Integer;
    procedure Insert(Index: Integer; Item: Pointer);
    function Last: Pointer;
    procedure Move(CurIndex, NewIndex: Integer);
    function Remove(Item: Pointer): Integer;
    procedure Pack;
    procedure Sort(Compare: TListSortCompare);
    procedure SortDword(dep:integer);
    property Capacity: Integer read FCapacity write SetCapacity;
    property Count: Integer read FCount write SetCount;
    property Items[Index: Integer]: Pointer read Get write Put; default;

    property Sorted: boolean read Fsorted write Fsorted;
    property EltSize:integer read FeltSize;

    function getPointer:PtabOctet;
    procedure fill(b:byte);

    function getSortedItemDword(ad:longword;dep:integer;var k:integer): pointer;
    function getSortedItemPointer(ad:pointer;dep:integer;var k:integer): pointer;



    function readFromStream(f: Tstream):boolean;virtual;
    procedure WriteToStream(f:Tstream);virtual;

    function read(var f: file):boolean;
    procedure write(var f:file);

    function WriteSize:integer;
  end;

{ThashList est utilisée par Motres1 }
{Il existe aussi ThashList2 dans Hlist0, utilisée par symbac3}


const
  HashListBlockSize=5000;

type
  ThashListRecord=record
                    next,prev:integer;
                    obj:pointer;
                    st:ShortString;
                  end;
  PhashListRecord=^ThashListRecord;

Const
  hashListRecordSize = sizeof(ThashListRecord)-255; // partie Fixe

type
  ThashList=class
            private
              tab:pointer;
              tabSize:integer;
              Kfirst,Klast:array[0..255] of integer;
              depFin:integer;
              Fnext:boolean;

              function Pfin:PhashListRecord;
              function Pcur(dep:integer):PhashListRecord;
            public
              constructor create;
              destructor destroy;override;

              procedure clear;
              procedure addShortString(const st1:ShortString;ob1:pointer);
              procedure addString(const st1:AnsiString;ob1:pointer);
              procedure deleteAfter(dep:integer);

              function getLastObj(var st1:ShortString):pointer;
              function getFirstObj(var st1:ShortString):pointer;
              function getNextObj:pointer;

              function MaxDepth:integer;
              procedure Pack;
              function getString(p0:pointer):AnsiString;
            end;

{ TdeleteList contient une liste de nombres entiers
  Ces nombres sont des numéros supprimés dans une liste.
  Add ajoute une valeur en la classant.
  RelToAbs convertit une position relative en position absolue.
  AbsToRel convertit une position absolue en position relative.
}

  TdeleteList=class(Tlist)
              protected
                function Get(Index: Integer): integer;
                procedure Put(Index: Integer; Item: integer);
              public
                property items[i:integer]:integer read get write put;
                procedure add(n:integer);
                function RelToAbs(nR:integer):integer;
                function AbsToRel(nA:integer):integer;
              end;

implementation

{ TListG }

type
  TitemMax=array[0..maxEltSize-1] of byte;

constructor TlistG.create(nb:integer);
begin
  if (nb<=0) or (nb>maxEltSize) then error(0);
  MaxListSize:=maxInt div (nb*2);

  FeltSize:=nb;

end;

destructor TlistG.Destroy;
begin
  Clear;
end;

function TlistG.Add(Item: Pointer): Integer;
begin
  Result := FCount;
  if Result = FCapacity then Grow;
  {FList^[Result] := Item;}
  system.move(item^,Flist^[result*FeltSize],FeltSize);
  Inc(FCount);
end;

function TlistG.AddEmpty: pointer;
begin
  if Fcount = FCapacity then Grow;
  Inc(FCount);
  result:=last;
end;

procedure TlistG.Clear;
begin
  SetCount(0);
  SetCapacity(0);
end;

procedure TlistG.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then Error(Index);

  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[(Index + 1)*FeltSize], FList^[Index*FeltSize],
      (FCount - Index) * FeltSize);
end;


procedure TlistG.Error(Data: Integer);
begin
  raise Exception.Create ( Format ('TlistG error: %x', [ data ] ) ) ;
end;

procedure TlistG.Exchange(Index1, Index2: Integer);
var
  Item: TitemMax;
begin
  if (Index1 < 0) or (Index1 >= FCount) then Error(Index1);
  if (Index2 < 0) or (Index2 >= FCount) then Error(Index2);

  {Item := FList^[Index1];}
  system.move(Flist^[index1*FeltSize],item,FeltSize);

  {FList^[Index1] := FList^[Index2];}
  system.move(Flist^[index2*FeltSize],Flist^[index1*FeltSize],FeltSize);

  {FList^[Index2] := Item;}
  system.move(item,Flist^[index2*FeltSize],FeltSize);
end;

function TlistG.Expand: TlistG;
begin
  if FCount = FCapacity then Grow;
  Result := Self;
end;

function TlistG.First: Pointer;
begin
  Result := Get(0);
end;

function TlistG.Get(Index: Integer): Pointer;
begin
  if (Index < 0) or (Index >= FCount) then Error(Index);

  Result := @FList^[Index*FeltSize];
end;

procedure TlistG.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then Delta := FCapacity div 4
  else
  if FCapacity > 8 then Delta := 16
  else Delta := 4;

  SetCapacity(FCapacity + Delta);
end;

function TlistG.IndexOf(Item: Pointer): Integer;
begin
  Result := 0;
  while (Result < FCount) and not compareMem(@FList^[Result*FeltSize],Item,FeltSize)
  do Inc(Result);

  if Result = FCount then Result := -1;
end;



procedure TlistG.Insert(Index: Integer; Item: Pointer);
begin
  if (Index < 0) or (Index > FCount) then Error(Index);

  if FCount = FCapacity then  Grow;

  if Index < FCount then
    System.Move(FList^[Index*FeltSize], FList^[(Index + 1)*FeltSize],
      (FCount - Index) * FeltSize );

  {FList^[Index] := Item;}
  System.Move(item^, FList^[Index*FeltSize], FeltSize );
  Inc(FCount);
end;

function TlistG.Last: Pointer;
begin
  Result := Get(FCount - 1);
end;

procedure TlistG.Move(CurIndex, NewIndex: Integer);
begin
  if CurIndex <> NewIndex then
  begin
    if (NewIndex < 0) or (NewIndex >= FCount) then Error(NewIndex);
    if (CurIndex < 0) or (CurIndex >= FCount) then Error(CurIndex);

    System.Move(FList^[CurIndex*FeltSize], FList^[NewIndex*FeltSize],FeltSize );
    fillchar(FList^[CurIndex*FeltSize],FeltSize,0);

  end;
end;

procedure TlistG.Put(Index: Integer; Item: Pointer);
begin
  if (Index < 0) or (Index >= FCount) then Error(Index);
  System.Move(item^, FList^[Index*FeltSize],FeltSize );
end;

function TlistG.Remove(Item: Pointer): Integer;
begin
  Result := IndexOf(Item);
  if Result >= 0 then Delete(Result);
end;

function isZero(p:pointer;nb:integer):boolean;
var
  i:integer;
begin
  result:=false;
  for i:=0 to nb-1 do
    if Pbyte(p)^<>0 then exit;
  result:=true;
end;

procedure TlistG.Pack;
var
  I: Integer;
  zero:array of byte;
begin
  setlength(zero,FeltSize);
  fillchar(zero[0],FeltSize,0);
  for I := FCount - 1 downto 0 do
    if comparemem(items[I],@zero[0],FeltSize) then
      Delete(I);
end;

procedure TlistG.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then Error(NewCapacity);
  if NewCapacity <> FCapacity then
  begin
    ReallocMem(FList, NewCapacity * FeltSize);
    FCapacity := NewCapacity;
  end;
end;

procedure TlistG.SetCount(NewCount: Integer);
var
  I: Integer;
begin
  if (NewCount < 0) or (NewCount > MaxListSize) then  Error(NewCount);

  if NewCount > FCapacity then SetCapacity(NewCount);

  if NewCount > FCount then
    FillChar(FList^[FCount*FeltSize], (NewCount - FCount) * FeltSize, 0)
  else
    for I := FCount - 1 downto NewCount do  Delete(I);

  FCount := NewCount;
end;

procedure QuickSort(SortList: PtabOctet; L, R,FeltSize: Integer;
  SCompare: TListSortCompare);
var
  I, J: Integer;
  P, T: TitemMax;
begin
  repeat
    I := L;
    J := R;
    {P := SortList^[(L + R) shr 1];}
    System.Move(SortList^[((L+R) div 2)*FeltSize ], P,FeltSize );

    repeat
      while SCompare(@SortList^[I*FeltSize], @P) < 0 do Inc(I);

      while SCompare(@SortList^[J*FeltSize], @P) > 0 do Dec(J);

      if I <= J then
      begin
        {T := SortList^[I];}
        System.Move(SortList^[I*FeltSize ], T,FeltSize );
        {SortList^[I] := SortList^[J];}
        System.Move(SortList^[J*FeltSize ], SortList^[I*FeltSize ],FeltSize );
        {SortList^[J] := T;}
        System.Move(T, SortList^[J*FeltSize ],FeltSize );

        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(SortList, L, J,FeltSize, SCompare);
    L := I;
  until I >= R;
end;

procedure TlistG.Sort(Compare: TListSortCompare);
begin
  if (FList <> nil) and (Count > 0) then
    QuickSort(FList, 0, Count - 1, FeltSize,Compare);
end;

var
  dep2:integer;

function compareDword(Item1, Item2: Pointer): Integer;
var
  k1,k2:integer;
begin
  k1:= Plongword(intG(item1)+dep2)^;
  k2:= PlongWord(intG(item2)+dep2)^;

  if k1<k2 then result:=-1
  else
  if k1=k2 then result:=0
  else result:=1;
end;

procedure TlistG.SortDword(dep:integer);
begin
  dep2:=dep;
  if (FList <> nil) and (Count > 0) then
    QuickSort(FList, 0, Count - 1, FeltSize,CompareDword);
end;



function TlistG.Extract(Item: Pointer): Pointer;
var
  I: Integer;
begin
  Result := nil;
  I := IndexOf(Item);
  if I >= 0 then
  begin
    Result := Item;
    Delete(I);
  end;
end;

function TlistG.getPointer:PtabOctet;
begin
  result:=Flist;
end;

procedure TlistG.fill(b:byte);
begin
  fillchar(Flist^,count*FeltSize,b);
end;

function TlistG.getSortedItemDword(ad:longword;dep:integer;var k:integer): pointer;
var
  min,max:integer;
  d:longword;
begin
  if count=0 then
    begin
      k:=-1;
      result:=nil;
      exit;
    end;

  min:=0;
  max:=count-1;

  if ad>=Plongword(intG(items[max])+dep)^ then
    begin
      k:=max;
      result:=last;
      exit;
    end;

  repeat
    k:=(max+min) div 2;
    d:=Plongword(intG(items[k])+dep)^;
    if d<ad then min:=k
    else
    if d>ad then max:=k;
  until (max-min<=1) or (ad=d);

  if ad<>d then k:=min;
  result:=items[k];
end;

function TlistG.getSortedItemPointer(ad: pointer;dep:integer;var k:integer): pointer;
var
  min,max:integer;
  d: intG;
begin
  if count=0 then
    begin
      k:=-1;
      result:=nil;
      exit;
    end;

  min:=0;
  max:=count-1;

  if intG(ad)>=PintG(intG(items[max])+dep)^ then
    begin
      k:=max;
      result:=last;
      exit;
    end;

  repeat
    k:=(max+min) div 2;
    d:=PintG(intG(items[k])+dep)^;
    if d<intG(ad) then min:=k
    else
    if d>intG(ad) then max:=k;
  until (max-min<=1) or (intG(ad)=d);

  if intG(ad)<>d then k:=min;
  result:=items[k];
end;


function TlistG.readFromStream(f: Tstream):boolean;
var
  EltSz,Cnt:integer;
  res:integer;
  st:string[5];
begin
  result:=false;
  st:='';
  EltSz:=0;
  cnt:=0;

  res:=f.Read(st,sizeof(st));         {Lire le mot clé}
  if st<>'LISTG' then exit;

  res:=f.Read(EltSz,sizeof(EltSz));   {Lire FeltSize}
  res:=f.Read(cnt,sizeof(cnt));       {Puis Count}

  if (EltSz>0) and (EltSz<=MaxEltSize) then
  begin
    FeltSize:=EltSz;
    Count:=cnt;
    if assigned(Flist)
      then res:=f.Read(Flist^,FeltSize*count)       {Lire les données}
      else res:=0;
    result:=(res=FeltSize*count);
  end;

end;

function TlistG.read(var f: file):boolean;
var
  stream:ThandleStream;
begin
  stream:=nil;
  try
    stream:=ThandleStream.create(TfileRec(f).handle);
    ReadFromStream(stream);
  finally
    stream.free;
  end;
end;


procedure TlistG.writeToStream(f: Tstream);
var
  sz:integer;
  res:integer;
  st:string[5];
begin
  st:='LISTG';
  f.WriteBuffer(st,sizeof(st));             {Ecrire le mot clé}
  f.WriteBuffer(FeltSize,sizeof(FeltSize));   {Ecrire FeltSize}
  sz:=count;
  f.WriteBuffer(sz,sizeof(sz));             {Puis Count}
  if assigned(Flist) then
    f.WriteBuffer(Flist^,FeltSize*count);    {Puis les données}
end;

procedure TlistG.write(var f:file);
var
  stream:ThandleStream;
begin
  stream:=nil;
  try
    stream:=ThandleStream.create(TfileRec(f).handle);
    writeToStream(stream);
  finally
    stream.free;
  end;
end;

function TlistG.WriteSize:integer;
begin
  result:=6+4+4+FeltSize*Count;                  {Nb octets à écrire}
end;


{ ThashList }

function cle255(var st: shortString): integer;
begin
  result:=(length(st)+ord(st[1])*37+ord(st[length(st)])*59) mod 255;
  {result:=length(st);}
end;

constructor ThashList.create;
begin
  clear;

end;

destructor ThashList.destroy;
begin
  freemem(tab);
  inherited;
end;

procedure ThashList.clear;
var
  i:integer;
begin
  reallocmem(tab,HashListBlockSize);
  fillchar(tab^,HashListBlockSize,0);
  TabSize:=HashListBlockSize;

  for i:=0 to 255 do
  begin
    Kfirst[i]:=-1;
    Klast[i]:=-1;
  end;

  depFin:=0;
end;


procedure ThashList.addShortString(const st1:ShortString; ob1: pointer);
var
  c,D:integer;
begin
  if tabSize-depfin<length(st1)+20 then  {Faire croitre la table si nécessaire}
  begin
    inc(tabSize,HashListBlockSize);
    reallocmem(tab,tabSize);
  end;

  with Pfin^ do                           { Remplir le dernier élément}
  begin
    st:=st1;
    obj:=ob1;
    next:=-1;                             {il manque seulement Prev}
  end;

  c:=cle255(Pfin^.st);                       {Calculer Prev}
  D:=Klast[c];
  Pfin^.prev:=D;

  Klast[c]:=depFin;                       {Pfin est le dernier de la chaine}

  if D=-1                                 {Mettre à jour l'élément précédent}
    then Kfirst[c]:=depFin
    else Pcur(D)^.next:=depfin;

  inc(depfin,length(st1)+ hashListRecordSize);         {Mettre à jour depfin}
end;

procedure ThashList.addString(const st1:AnsiString; ob1: pointer);
begin
  addShortString(st1,ob1);
end;


procedure ThashList.deleteAfter(dep: integer);
begin

end;


function ThashList.getFirstObj(var st1:ShortString): pointer;
var
  c,D:integer;
  p:PhashListRecord;
begin

  c:=cle255(st1);
  D:=Kfirst[c];
  p:=pointer(intG(tab)+D);
  while (D>=0) and (P^.st<>st1) do
  begin
    D:=P^.next;
    p:=pointer(intG(tab)+D);
  end;

  if D>=0
    then result:=P^.obj
    else result:=nil;
end;

function ThashList.getLastObj(var st1:ShortString): pointer;
begin

end;

function ThashList.getNextObj: pointer;
begin

end;

function ThashList.Pcur(dep: integer): PhashListRecord;
begin
  result:=pointer(intG(tab)+dep);
end;

function ThashList.Pfin: PhashListRecord;
begin
  result:=pointer(intG(tab)+depFin);
end;



function ThashList.MaxDepth: integer;
var
  i,D:integer;
  nb,nbmax:integer;
begin
  result:=0;
  for i:=0 to 255 do
  begin
    nb:=0;
    D:=Kfirst[i];
    while (D>=0) do
    begin
      D:=Pcur(D)^.next;
      inc(nb);
    end;
    if nb>result then result:=nb;
  end;
end;

procedure ThashList.Pack;
var
  p:PhashListRecord;
  i:integer;
begin
  reallocmem(tab,depfin);
  tabSize:=depfin;
end;

function ThashList.getString(p0:pointer):AnsiString;
var
  p:PhashListRecord;
begin
  p:=tab;

  while intG(p)<intG(Pfin) do
  begin
    if p^.obj=p0 then
    begin
      result:=p^.st;
      exit;
    end;
    inc(intG(p),length(p^.st)+ hashListRecordSize);
  end;

  result:='';
end;

{ TdeleteList }


procedure TdeleteList.add(n: integer);
var
  i:integer;
begin
  i:=0;
  while (i<count) and (items[i]<n) do inc(i);
  if (i=count) or (items[i]<>n) then insert(i,pointer(n));
  {on classe n sans accepter les doublons}
end;

{ Dans la suite nA = 1 2 3 4 5 6 7..., nA est le numéro absolu
  Si on a marqué des suppressions (exemple 2 et 5), les numéros supérieurs
  se retrouvent décalés vers le bas (exemple 7 se retrouve en 5)
  Ce nouveau numéro est le numéro relatif.
}

function TdeleteList.AbsToRel(nA: integer): integer;
var
  i:integer;
begin
  {On suppose que nA n'a pas été marqué}
  result:=nA;
  for i:=0 to count-1 do
    if items[i]<nA
      then dec(result)
      else break;
end;


function TdeleteList.RelToAbs(nR: integer): integer;
var
  i:integer;
begin
  result:=nR;
  for i:=0 to count-1 do
  begin
    if items[i]<=result then inc(result);
    if result<items[i] then break;
  end;

end;


function TdeleteList.Get(Index: Integer): integer;
begin
  result:=intG(inherited get(index));
end;

procedure TdeleteList.Put(Index, Item: integer);
begin
  inherited put(index,pointer(item));
end;

end.
