unit tuo1;


INTERFACE

uses util1,debug0;

{ typeListeUO est une liste chaŒn‚e utilis‚e par le compilateur Ncompil.
  Elle recense tous les objets d‚clar‚s dans le programme.
  Tous les objets doivent descendre d'un mˆme ancˆtre mais la liste ne fait
  aucune hypothŠse sur leur type et manipule de simples pointeurs.

  Dans Acquis1, les objets descendent de typeUO (PUO=^typeUO).
  typeUO doit au minimum contenir un nom, ce nom doit pouvoir ˆtre renvoy‚
  par getIdent

  Chaque ‚l‚ment de la liste contient un pointeur ou un tableau de pointeur,
  ce qui correspond … la d‚claration d'une variable simple ou d'une variable
  tableau.

  Une application doit cr‚er une liste descendant de typeListeUO qui
  surchargera certaines m‚thodes, en particulier disposeUO et getIdent.
  La m‚thode VIDER permet de vider la liste en d‚truisant tous les objets.

  Le programme PG1 manipule les adresses des pointeurs. Une m‚thode PG1 re‡oit
  toujours l'adresse du pointeur comme paramŠtre et non pas le pointeur
  lui-mˆme, ce qui permet de contr“ler que l'objet a bien ‚t‚ cr‚‚.
  (Quand le pointeur vaut nil, l'objet n'a pas ‚t‚ cr‚‚)

  La liste contient un nombre vob qui identifie le type des objets.
  Avec ajoute(v,n) on ajoute n pointeurs valant nil dans la liste, avec le
  type v. Ajoute renvoie l'adresse de ce bloc de pointeurs (PPUO)

  disposeUO(p:pointer); est une m‚thode virtuelle qui doit contenir

      dispose(PUO(p),done)

  getIdent(p:pointer):string; est une m‚thode virtuelle qui doit contenir

      if PUO(p)^.ident=nil then getIdent:=''
      else  getIdent:=PUO(p)^.ident^;

  initRejouer et rejouer sont utilis‚s par la table des symboles au moment
  d'une recherche d'erreur: … ce moment, on recompile mais il ne faut pas
  modifier la liste des objets.

  getAd renvoie l'adresse d'un objet (PUO) connaissant un nom
                nil si l'objet n'existe pas.

  NbName renvoie le nombre d'objets initilis‚s et portant un nom.

  getFirst et getNext (PPUO) permettent de parcourir la liste. Typiquement:
      p:=getFirst;
      while p<>nil do
      begin
        ..... traitement
        p:=getNext;
      end;
}

type

  PLUO=^typeLUO;         {El‚ment de la liste UO}
  typeLUO=
         record
           suivant:PLUO;
           vob:smallInt;
           nbelt:smallInt;
           case smallInt of
            1:(p:pointer); {PUO}
            2:(pt:array[1..10000] of pointer); {PUO}
         end;

  typeListeUO=           {Liste des user objects}
         object
           ps:PLUO;
           ns:smallInt;
           premier:PLUO;
           pJ:pLUO;
           constructor init;
           function ajoute(v,n:smallInt):pointer; {PPUO}

           procedure InitRejouer;
           function rejouer(v,n:smallInt):pointer;

           procedure disposeUO(p:pointer);virtual;
           procedure vider;
           procedure libererObjet(pu:pointer);
           procedure EffacerObjet(pu:pointer);

           function getIdent(p:pointer):string;virtual;
           function getAd(st:string):pointer;          {PUO}
           function NbName:smallInt;

           function getFirst:pointer;          {PPUO}
           function getNext:pointer;           {PPUO}
         end;

  PlisteUO=^typeListeUO;

IMPLEMENTATION


{**************************** M‚thodes de typeListeUO ********************}

constructor typeListeUO.init;
  begin
    premier:=nil;
  end;

function typeListeUO.ajoute(v,n:smallInt):pointer;
  var
    p0,p1:pLUO;
  begin
    p0:=@self;
    p1:=premier;
    while (p1<>nil) do
    begin
      p0:=p1;
      p1:=p1^.suivant;
    end;

    getmem(p1,8+n*4);
    with p1^ do
    begin
      suivant:=nil;
      nbelt:=n;
      vob:=v;
      fillchar(p,n*4,0);
    end;

    if p0=@self then premier:=p1
                else p0^.suivant:=p1;

    ajoute:=@p1^.p;
  end;

procedure typeListeUO.initRejouer;
  begin
    pJ:=getFirst;
  end;

function typeListeUO.rejouer(v,n:smallInt):pointer;
  var
    i:smallInt;
  begin
    rejouer:=pJ;
    for i:=1 to n do pJ:=getNext;
  end;


procedure typeListeUO.disposeUO(p:pointer);
  begin
    {doit contenir dispose(PUO(p),done)}
  end;

{
procedure typeListeUO.vider;
  var
    p1,p2:pLUO;
    i,nb:smallInt;
  begin
    p1:=premier;

    while (p1<>nil) do
    begin
      nb:=p1^.nbElt;
      for i:=1 to p1^.nbElt do
        if p1^.pt[i]<>nil then disposeUO(p1^.pt[i]);
      p2:=p1^.suivant;
      freemem(p1,8+4*nb);
      p1:=p2;
    end;
    premier:=nil;
  end;
}
procedure typeListeUO.vider;
  var
    p1,p2:pLUO;
    i,nb:smallInt;
  begin

    {Vider d'abord le contenu}
    p1:=premier;
    while (p1<>nil) do
    begin
      nb:=p1^.nbElt;
      for i:=1 to p1^.nbElt do
        if p1^.pt[i]<>nil then
          begin
            disposeUO(p1^.pt[i]);
            p1^.pt[i]:=nil;
          end;
      p1:=p1^.suivant;
    end;

    {Détruire ensuite}
    p1:=premier;

    while (p1<>nil) do
    begin
      nb:=p1^.nbElt;
      p2:=p1^.suivant;
      freemem(p1,8+4*nb);
      p1:=p2;
    end;

    premier:=nil;
  end;

procedure typeListeUO.libererObjet(pu:pointer);
  var
    p1:pLUO;
    i,nb:smallInt;
  begin
    if pu=nil then exit;
    p1:=premier;

    while (p1<>nil) do
    begin
      nb:=p1^.nbElt;
      for i:=1 to p1^.nbElt do
        if p1^.pt[i]=pu then
          begin
            disposeUO(p1^.pt[i]);
            p1^.pt[i]:=nil;
          end;
      p1:=p1^.suivant;
    end;
  end;

procedure typeListeUO.EffacerObjet(pu:pointer);
  var
    p1:pLUO;
    i,nb:smallInt;
  begin
    if pu=nil then exit;
    p1:=premier;

    while (p1<>nil) do
    begin
      nb:=p1^.nbElt;
      for i:=1 to p1^.nbElt do
        if p1^.pt[i]=pu then
          begin
            p1^.pt[i]:=nil;
          end;
      p1:=p1^.suivant;
    end;
  end;



function typeListeUO.getIdent(p:pointer):string;
  begin
    {doit contenir
      if PUO(p)^.ident=nil then getIdent:=''
      else  getIdent:=PUO(p)^.ident^;
    }
  end;

function typeListeUO.getAd(st:string):pointer;
  var
    p1:pLUO;
    i:smallInt;
  begin
    getAd:=nil;
    p1:=premier;
    while (p1<>nil) do
    begin
      for i:=1 to p1^.nbElt do
        if (p1^.pt[i]<>nil)
            and (Fmaj(getIdent(p1^.pt[i]))=Fmaj(st)) then
           begin
             getAd:=p1^.pt[i];
             exit;
           end;
      p1:=p1^.suivant;
    end;
  end;

function typeListeUO.NbName:smallInt;
  var
    p1,p2:pLUO;
    i,nb,n:smallInt;
  begin
    p1:=premier;

    n:=0;
    while (p1<>nil) do
    begin
      nb:=p1^.nbElt;
      for i:=1 to p1^.nbElt do
        if (p1^.pt[i]<>nil) and (getIdent(p1^.pt[i])<>'') then inc(n);
      p2:=p1^.suivant;
      p1:=p2;
    end;
    nbName:=n;
  end;


function typeListeUO.getFirst:pointer;
  begin
    ps:=premier;
    ns:=1;
    if ps=nil
      then getFirst:=nil
      else getFirst:=@ps^.pt[ns];
  end;

function typeListeUO.getNext:pointer;
  begin
    if ps=nil then
      begin
        getNext:=nil;
        exit;
      end;
    if ns<ps^.nbElt then
      begin
        inc(ns);
        getNext:=@ps^.pt[ns];
      end
    else
      begin
        ns:=1;
        ps:=ps^.suivant;
        if ps=nil
          then getNext:=nil
          else getNext:=@ps^.pt[ns];
      end;
  end;

end.