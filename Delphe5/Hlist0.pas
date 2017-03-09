unit Hlist0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Gdos,classes;

{  THashList2 permet de gérer une table d'informations, en particulier la
table des symboles du compilateur.

  Une information comprend une chaine de caractères (mot-clé) + un bloc de données.
  La taille du bloc de données est inférieure à 64K.

  La table est compacte: tous les blocs se suivent de façon contigue.
  La mémoire réservée (pointeur tab) croit par incrément de HashListBlockSize (octets).

  Pour placer une info, on appelle addString(st,DataSize) ou addShortString(st,DataSize),
ce qui réserve un bloc de taille DataSize. Ensuite, il faut utiliser la propriété pointeur lastData
pour écrire effectivement les infos.
  On peut modifier la taille réservée avec modifyLastSize.

  Ensuite, les fonctions de recherche, basées sur une méthode de hachage, sont très efficaces.

  getLastObj(st) et getFirstObj(st) renvoie l'adresse des données du premier bloc de mot clé st,
la recherche commençant au début ou à la fin de la table.

  getNextObj et getPrevObj continuent la recherche jusqu'au bloc ayant le même mot clé.

  getLastObj1(st,I) et getFirstObj1(st,I) travaillent comme getLastObj(st) et getFirstObj(st) mais
en limitant la recherche avant  (resp. après) l'indice I .

  On peut accéder aussi à la liste de façon linéaire en utilisant les propriétés data[n]
ou strings[n], n variant de 0 à count-1.
  Count est le nombre de blocs de la liste.
}

Const
    MaxKey = 255;
    //MaxKey = 2047;

type
  ThashListRecord2=
        record
          sz:word;
          st:ShortString;
        end;
  PhashListRecord2=^ThashListRecord2;

  ThashListRecord1=
        record
          next,prev:integer;
          depRec:integer;
          depDat:integer;
        end;
  PhashListRecord1=^ThashListRecord1;



  ThashList2=class
        private
          tab:pointer;
          tabSize:integer;
          Kfirst,Klast:array[0..MaxKey] of integer;

          depFin:integer;

          LastSearch:integer;

          Dep:array of ThashListRecord1;
          RecCount:integer;


          function Pfin:PhashListRecord2;
          function Prec(dep:integer):PhashListRecord2;

          function getData(n:integer):pointer;
          function getDepData(n:integer):integer;
          function getString(n:integer):AnsiString;
          function getRec(n:integer):PhashListRecord2;

          function getLastData:pointer;
          function getLastRec:PhashListRecord2;



        public
          constructor create;
          destructor destroy;override;

          procedure clear;
          function addShortString(const st1:ShortString;sz1:integer):integer;
          {Renvoie le déplacement de data}
          function addString(const st1:AnsiString;sz1:integer):integer;
          {Renvoie le déplacement de data}

          procedure deleteLast;
          procedure deleteAfter(n:integer);
          {Supprime les éléments d'indices n et au delà }

          Procedure modifyLastSize(sz1:integer);

          {Fonctions de recherche. Renvoient un pointeur sur Data}
          function getLastObj(const st1:ShortString):pointer;
          function getFirstObj(const st1:ShortString):pointer;overload;
          function getFirstObj(const st1:ShortString;var size:integer):pointer;overload;

          function getNextObj:pointer;
          function getPrevObj:pointer;

          function getLastObj1(const st1:ShortString;I0:integer):pointer;
          function getFirstObj1(const st1:ShortString;I0:integer):pointer;

          function MaxDepth:integer;
          procedure Pack;

          property data[n:integer]:pointer read getData;
          property strings[n:integer]:AnsiString read getString;
          property depData[n:integer]:integer read getDepData;
          property Rec[n:integer]:PhashListRecord2 read getRec;


          property Count:integer read RecCount;
          property lastData:pointer read getlastData;
          property lastRec:PhashListRecord2 read getlastRec;


          function depToP(D:integer):pointer;
          property tableSize:integer read depFin;
          property Table:pointer read tab;
          property Ifound:integer read LastSearch;

          procedure saveToStream(f:Tstream);
          procedure loadFromStream(f:Tstream);


          procedure copier(p:PhashListRecord2);
          {p est dans une autre liste. On ajoute l'élément à la liste}

          procedure modifySize(index,NewSize:integer);
          procedure modifyFirstChar(index:integer;CodeInc:integer);
        end;



(* Objet permettant d'améliorer une Tlist ordinaire.
   A faire ?

  THList = class(TObject)
  private
    lists:array of Tlist;
    Fcount:integer;
    function Get(Index: Integer): Pointer;
    procedure Put(Index: Integer; Item: Pointer);

  public
    constructor create(Nlist:integer);
    destructor Destroy; override;
    function Add(Item: Pointer): Integer;
    procedure Clear; virtual;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    function First: Pointer;
    function IndexOf(Item: Pointer): Integer;
    procedure Insert(Index: Integer; Item: Pointer);
    function Last: Pointer;
    procedure Move(CurIndex, NewIndex: Integer);
    function Remove(Item: Pointer): Integer;
    procedure Pack;
    property Count: Integer read FCount;
    property Items[Index: Integer]: Pointer read Get write Put; default;
  end;
*)


implementation

const
  HashListBlockSize=5000;
  DepBlockSize=200;


function cle255(const st: shortString): integer;
begin
  result:=(length(st)+ord(st[1])*37+ord(st[length(st)])*59) mod 255;
  {result:=length(st);}
end;

function cle2048(const st: shortString): integer;
begin
  result:=(length(st)*100+ord(st[1])*37+ord(st[length(st)])*59) mod 2048 ;
end;

{ ThashList2 }

constructor ThashList2.create;
begin
  clear;;

end;

destructor ThashList2.destroy;
begin
  freemem(tab);
  inherited;
end;

procedure ThashList2.clear;
var
  i:integer;
begin
  reallocmem(tab,HashListBlockSize);
  fillchar(tab^,HashListBlockSize,0);
  TabSize:=HashListBlockSize;

  for i:=0 to MaxKey do
  begin
    Kfirst[i]:=-1;
    Klast[i]:=-1;
  end;

  depFin:=0;
  recCount:=0;

  setLength(dep,DepBlockSize);
  fillchar(dep[0],(high(dep)+1)*sizeof(dep[0]),0);
end;


function ThashList2.addShortString(const st1:ShortString; sz1: integer):integer;
var
  c,D:integer;
begin
  if sz1>65535 then messageCentral('ThashList2.addShortString : sz1>64K ');

  if tabSize-depfin<length(st1)+3+sz1 then {Faire croitre la table si nécessaire}
  begin
    while tabSize-depfin<length(st1)+3+sz1 do inc(tabSize,HashListBlockSize);
    reallocmem(tab,tabSize);
  end;

  if recCount-1>=high(dep) then            {faire croitre dep}
    setLength(dep,(high(dep)+1+DepBlockSize));

  with Pfin^ do                            {Remplir le dernier élément}
  begin
    st:=st1;
    sz:=sz1;
  end;

  with dep[recCount] do
  begin
    next:=-1;                               {il manque seulement Prev}
    depRec:=depFin;
    depDat:=depfin+3+length(st1);
    result:=depDat;
  end;


  c:=cle255(Pfin^.st);                      {Calculer Prev}
  D:=Klast[c];
  dep[recCount].prev:=D;

  Klast[c]:=recCount;                       { Pfin est le dernier de la chaine}

  if D=-1                                   { Mettre à jour l'élément précédent}
    then Kfirst[c]:=recCount
    else Dep[D].next:=recCount;

  inc(RecCount);                            { mettre à jour dep }


  inc(depfin,length(st1)+3+sz1);            {Mettre à jour depfin}

end;

function ThashList2.addString(const st1:AnsiString; sz1:integer):integer;
begin
  result:=addShortString(st1,sz1);
end;

procedure ThashList2.deleteLast;
var
  n,c:integer;
begin
  n:=count-1;
  if n<0 then exit;

  c:=cle255(strings[n]);

  with dep[n] do
  begin
    Klast[c]:=prev;
    if prev>=0
      then dep[prev].next:=-1
      else Kfirst[c]:=-1;
  end;

  depfin:=dep[n].deprec;
  dec(recCount);

end;

procedure ThashList2.deleteAfter(n: integer);
var
  i:integer;
begin
  for i:=n to count-1 do deleteLast;
end;


function ThashList2.getFirstObj(const st1:ShortString): pointer;
var
  c,D:integer;
  p:PhashListRecord2;
begin
  c:=cle255(st1);
  D:=Kfirst[c];
  p:=pointer(intG(tab)+Dep[D].depRec);
  while (D>=0) and (P^.st<>st1) do
  begin
    D:=dep[D].next;
    p:=pointer(intG(tab)+Dep[D].depRec);
  end;

  if D>=0
    then result:=pointer(intG(P)+3+length(p^.st))
    else result:=nil;

  LastSearch:=D;
end;

function ThashList2.getFirstObj(const st1:ShortString;var size:integer):pointer;
var
  c,D:integer;
  p:PhashListRecord2;
begin
  c:=cle255(st1);
  D:=Kfirst[c];
  p:=pointer(intG(tab)+Dep[D].depRec);
  while (D>=0) and (P^.st<>st1) do
  begin
    D:=dep[D].next;
    p:=pointer(intG(tab)+Dep[D].depRec);
  end;

  if D>=0 then
  begin
    size:=P^.sz;
    result:=pointer(intG(P)+3+length(p^.st));
  end
  else
  begin
    size:=0;
    result:=nil;
  end;
  
  LastSearch:=D;
end;




function ThashList2.getLastObj(const st1:ShortString): pointer;
var
  c,D:integer;
  p:PhashListRecord2;
begin
  c:=cle255(st1);
  D:=Klast[c];
  p:=pointer(intG(tab)+Dep[D].depRec);
  while (D>=0) and (P^.st<>st1) do
  begin
    D:=dep[D].prev;
    p:=pointer(intG(tab)+Dep[D].depRec);
  end;

  if D>=0
    then result:=pointer(intG(P)+3+length(p^.st))
    else result:=nil;

  LastSearch:=D;
end;


function ThashList2.getNextObj: pointer;
var
  c,D:integer;
  p:PhashListRecord2;
  st1:shortstring;

begin
  if LastSearch>=0 then
    with dep[lastSearch] do
    begin
      D:=next;
      st1:=prec(deprec)^.st;
    end
  else
    begin
      result:=nil;
      exit;
    end;

  p:=pointer(intG(tab)+Dep[D].depRec);
  while (D>=0) and (P^.st<>st1) do
  begin
    D:=dep[D].next;
    p:=pointer(intG(tab)+Dep[D].depRec);
  end;

  if D>=0
    then result:=pointer(intG(P)+3+length(p^.st))
    else result:=nil;

  LastSearch:=D;
end;


function ThashList2.getPrevObj: pointer;
var
  c,D:integer;
  p:PhashListRecord2;
  st1:shortstring;

begin
  if LastSearch>0 then
    with dep[lastSearch] do
    begin
      D:=prev;
      st1:=Prec(depRec)^.st;
    end
  else
    begin
      result:=nil;
      exit;
    end;

  p:=pointer(intG(tab)+Dep[D].depRec);
  while (D>=0) and (P^.st<>st1) do
  begin
    D:=dep[D].prev;
    p:=pointer(intG(tab)+Dep[D].depRec);
  end;

  if D>=0
    then result:=pointer(intG(P)+3+length(p^.st))
    else result:=nil;

  LastSearch:=D;

end;

function ThashList2.getLastObj1(const st1:ShortString;I0:integer):pointer;
var
  c,D:integer;
  p:PhashListRecord2;
begin
  c:=cle255(st1);
  D:=Klast[c];
  p:=pointer(intG(tab)+Dep[D].depRec);
  while (D>=0) and ((P^.st<>st1) OR (D>=I0)) do
  begin
    D:=dep[D].prev;
    p:=pointer(intG(tab)+Dep[D].depRec);
  end;

  if D>=0
    then result:=pointer(intG(P)+3+length(p^.st))
    else result:=nil;

  LastSearch:=D;
end;

function ThashList2.getFirstObj1(const st1:ShortString;I0:integer):pointer;
var
  c,D:integer;
  p:PhashListRecord2;
begin
  c:=cle255(st1);
  D:=Kfirst[c];
  p:=pointer(intG(tab)+Dep[D].depRec);
  while (D>=0) and ((P^.st<>st1) or (D>=I0)) do
  begin
    D:=dep[D].next;
    p:=pointer(intG(tab)+Dep[D].depRec);
  end;

  if D>=0
    then result:=pointer(intG(P)+3+length(p^.st))
    else result:=nil;

  LastSearch:=D;
end;

function ThashList2.Prec(dep: integer): PhashListRecord2;
begin
  result:=pointer(intG(tab)+dep);
end;

function ThashList2.Pfin: PhashListRecord2;
begin
  result:=pointer(intG(tab)+depFin);
end;




function ThashList2.MaxDepth: integer;
var
  i,D:integer;
  nb,nbmax:integer;
begin
  result:=0;
  for i:=0 to MaxKey do
  begin
    nb:=0;
    D:=Kfirst[i];
    while (D>=0) do
    begin
      D:=dep[D].next;
      inc(nb);
    end;
    if nb>result then result:=nb;
  end;
end;

procedure ThashList2.Pack;
var
  p:PhashListRecord2;
  i:integer;
begin
  reallocmem(tab,depfin);
  tabSize:=depfin;
end;


procedure ThashList2.modifyLastSize(sz1: integer);
begin
  rec[count-1].sz:=sz1;
  depFin:=dep[count-1].depDat+sz1;
end;



function ThashList2.getData(n: integer): pointer;
begin
  result:=pointer(intG(tab)+dep[n].depDat);
end;

function ThashList2.getDepData(n:integer):integer;
begin
  result:=dep[n].depDat;
end;


function ThashList2.getString(n: integer): AnsiString;
begin
  result:=Prec(dep[n].depRec)^.st;
end;


function ThashList2.depToP(D: integer): pointer;
begin
  result:=pointer(intG(tab)+D);
end;



function ThashList2.getRec(n: integer): PhashListRecord2;
begin
  result:=Prec(dep[n].depRec);
end;

procedure ThashList2.loadFromStream(f: Tstream);
var
  p,pmax: PhashListRecord2;
begin
  clear;

  // On charge d'abord les données dans tab^
  f.Read(depFin,Sizeof(integer));

  if depFin>0 then
  begin
    Reallocmem(tab,depFin);
    f.Read(tab^,depFin);
    tabSize:=depFin;
  end
  else exit;

  // Puis on reconstitue le tableau dep
  p:=tab;
  pmax:=tab;
  inc(intG(pmax),depfin);

  depfin:=0;
  recCount:=0;
  while intG(p)<intG(pmax) do
  with p^ do
  begin
    addShortString(st,sz);
    inc(intG(p),3+length(st)+sz);
  end;
end;

// Seules les données contenues dans tab^ sont sauvées
procedure ThashList2.saveToStream(f: Tstream);
begin
  f.Write(depFin,Sizeof(integer));
  if depFin>0 then
    f.Write(table^,depFin);
end;


procedure ThashList2.modifySize(index, NewSize: integer);
var
  i,dd: integer;
  p,NewP: PhashListRecord2;
begin
  with rec[index]^ do
  begin
    dd:= NewSize-sz;
    sz:=NewSize;
  end;

  // En principe dd sera négatif
  // Sinon, il faut agrandir la table si nécessaire}
  if tabSize-depfin<dd then
  begin
    while tabSize-depfin< dd do inc(tabSize,HashListBlockSize);
    reallocmem(tab,tabSize);
  end;

  if index<count-1 then
  begin
    p:=rec[index+1];

    NewP:=p;
    inc(intG(NewP),dd);
    move(p^,NewP^,intG(Pfin)-intG(p));
  end;

  inc(depFin,dd);

  for i:=index+1 to count-1 do
  with dep[i] do
  begin
    inc(depRec,dd);
    inc(depDat,dd);
  end;

end;




procedure ThashList2.copier(p:PhashListRecord2);
begin
  with p^ do
  begin
    addShortString(st,sz);
    move(pointer(intG(p)+3+length(st))^,lastData^,sz);
  end;
end;

function ThashList2.getLastData: pointer;
begin
  if count>0
    then result:=data[count-1]
    else result:=nil;
end;

function ThashList2.getLastRec: PhashListRecord2;
begin
  if count>0
    then result:=rec[count-1]
    else result:=nil;
end;


procedure ThashList2.modifyFirstChar(index: integer;CodeInc:integer);
var
  k:integer;
begin
  with Prec(dep[index].depRec)^ do st[1]:= AnsiChar(ord(st[1])+CodeInc);
end;


end.
