unit message2;

INTERFACE


uses util1,
     comlpt32,
     clock0,Ncdef2,stmPg;



procedure proinitComLPT(num:integer;maitre:boolean);   pascal;
Function fonctionGetErrorComLPT:integer;               pascal;
function FonctionContactLPT(duree:float):boolean;      pascal;

function FonctionEmetVar(var x;nb:integer;tpn:word):boolean;   pascal;
function FonctionRecoitVar(var x;nb:integer;tpn:word):boolean; pascal;

procedure proInitBloc;                    pascal;
procedure proSetBloc(var x;nb:integer;tpn:word);  pascal;
function FonctionEmetBloc:boolean;        pascal;
function FonctionRecoitBloc:boolean;      pascal;


IMPLEMENTATION

procedure proinitComLPT(num:integer;maitre:boolean);
  begin
    initComLPT(num,maitre);
  end;

Function fonctionGetErrorComLPT:integer;
  begin
    fonctionGetErrorComLPT:=GetErrorComLPT;
  end;

function FonctionContactLPT(duree:float):boolean;
  var
    ok,rep:boolean;
    n,max:integer;
  begin
    max:=roundI(duree/0.05);
    n:=0;
    repeat
      ok:=contact0(rep);
      if not rep then inc(n);
    until ok or (n>=max) or testerFinPg;
    FonctionContactLPT:=ok;
  end;


function FonctionEmetVar(var x;nb:integer;tpn:word):boolean;
  begin
    FonctionEmetVar:=EmetBloc(x,nb);
  end;

function FonctionRecoitVar(var x;nb:integer;tpn:word):boolean;
  begin
    FonctionRecoitVar:=RecBloc(x,nb);
  end;

const
  max=50;

var
  adresse:array[1..max] of pointer;
  taille:array[1..max] of word;
  nbad:integer;

procedure proInitBloc;
  begin
    nbad:=0;
  end;

procedure proSetBloc(var x;nb:integer;tpn:word);
  var
    i:integer;
  begin
    if nbad<max then
      begin
        inc(nbad);
        adresse[nbad]:=@x;
        taille[nbad]:=nb;
      end
    else sortieErreur(E_BlocComLPT);
  end;

function FonctionEmetBloc:boolean;
  var
    buf:ptaboctet;
    i,k:longint;

  begin
    k:=0;
    for i:=1 to nbad do k:=k+taille[i];
    if k>maxavail-5000 then sortieErreur(E_BlocComLPT);

    getmem(buf,k);
    k:=0;
    for i:=1 to nbad do
      begin
        move(adresse[i]^,buf^[k],taille[i]);
        k:=k+taille[i];
      end;

    FonctionEmetBloc:=emetBloc(buf^,k);
    freemem(buf,k);
  end;

function FonctionRecoitBloc:boolean;
  var
    buf:ptabOctet;
    i,k:longint;
    ok:boolean;
    tot:longint;
  begin
    tot:=0;
    for i:=1 to nbad do tot:=tot+taille[i];
    if tot>maxavail-5000 then sortieErreur(E_BlocComLPT);
    getmem(buf,tot+10);

    ok:=recBloc(buf^,tot);
    if not ok then
      begin
        freemem(buf,tot+10);
        FonctionRecoitBloc:=false;
        exit;
      end;

    k:=0;
    for i:=1 to nbad do
      begin
        move(buf^[k],adresse[i]^,taille[i]);
        k:=k+taille[i];
      end;

    freemem(buf,tot+10);
    FonctionRecoitBloc:=true;
  end;


end.