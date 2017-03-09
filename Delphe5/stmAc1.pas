unit stmAc1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows, classes, forms,
     graphics,
     util1,Gdos,
     varconf1,
     stmdef,stmObj,stmdata0,stmvec1,stmGraph,
     stmError,Ncdef2,debug0;


type
{ Tacquis1 contient les mémoire de calcul et les graphes de Acquis1
  C'est un bon exemple d'objet qui ne sert que de container pour d'autres objets.
}

  TAcquis1=class(Tdata0)
              mem:array[1..12] of Tvector;
              graphe:array[1..12] of Tgraph;

              constructor create;override;

              destructor destroy;override;

              class function STMClassName:AnsiString;override;


              procedure saveToStream(f:Tstream;Fdata:boolean);override;
              function  loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;

              function initialise(st:AnsiString):boolean;override;

              procedure RetablirReferences(list:Tlist);override;

              procedure setChildNames;override;
              procedure resetTitles;override;

            end;


{Méthodes Stm de Tacquis1}

procedure proTacquis1_c(i:integer;var p:typeUO;var pu:typeUO);pascal;
function fonctionTacquis1_c(i:smallInt;var pu:typeUO):pointer;pascal;

function fonctionTacquis1_c1(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_c2(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_c3(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_c4(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_c5(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_c6(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_c7(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_c8(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_c9(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_c10(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_c11(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_c12(var pu:typeUO):pointer;pascal;

procedure proTacquis1_g(i:integer;var p:typeUO;var pu:typeUO);pascal;
function fonctionTacquis1_g(i:smallInt;var pu:typeUO):pointer;pascal;

function fonctionTacquis1_g1(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_g2(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_g3(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_g4(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_g5(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_g6(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_g7(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_g8(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_g9(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_g10(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_g11(var pu:typeUO):pointer;pascal;
function fonctionTacquis1_g12(var pu:typeUO):pointer;pascal;

procedure proTacquis1_SetGraph(num:smallint;var s1,s2:Tvector;Ideb,Ifin:integer;
                      var pu:typeUO);pascal;
procedure proTacquis1_SetGraph1(num:smallint;var s1,s2,s3:Tvector;Ideb,Ifin:integer;
                      var pu:typeUO);pascal;

implementation

var
  E_affectation:integer;
  E_memC:integer;
  E_grapheC:integer;

constructor Tacquis1.create;
var
  i:integer;
begin
  inherited create;

  for i:=1 to 12 do
    begin
      mem[i]:=Tvector.create;
      mem[i].initTemp1(0,99,G_smallint);
      AddTochildList(mem[i]);
    end;

  for i:=1 to 12 do
    begin
      graphe[i]:=Tgraph.create;
      AddToChildList(graphe[i]);
    end;

end;


procedure Tacquis1.setChildNames;
var
  i:integer;
begin
  for i:=1 to 12 do
    begin
      mem[i].ident:=ident+'.c'+Istr(i);
      with mem[i],inf,visu do
      begin
        notPublished:=false;
      end;

      graphe[i].ident:=ident+'.g'+Istr(i);
      with graphe[i],visu do
      begin
        notPublished:=false;
      end;
    end;
end;

procedure Tacquis1.resetTitles;
var
  i:integer;
begin
  for i:=1 to 12 do
    begin
      mem[i].title:='';
      graphe[i].title:='';
    end;
end;


destructor Tacquis1.destroy;
var
  i:integer;
begin
  for i:=1 to 12 do
    begin
      mem[i].free;
      graphe[i].free;
    end;

  inherited destroy;
end;

class function Tacquis1.STMClassName:AnsiString;
begin
  STMClassName:='Acquis1';
end;



procedure Tacquis1.saveToStream(f:Tstream;Fdata:boolean);
var
  i:integer;
  IminDum,ImaxDum:integer;
begin
  inherited saveToStream(f,Fdata);

  for i:=1 to 12 do
    with mem[i] do
    begin
      {on modifie Imin et Imax dans inf pour que, au prochain chargement de cfg,
      la taille des mémoires soit minimale}
      IminDum:=inf.Imin;
      ImaxDum:=Inf.Imax;
      inf.Imin:=0;
      inf.Imax:=99;
      saveToStream(f,Fdata);
      inf.Imin:=IminDum;
      Inf.Imax:=ImaxDum;

    end;
  for i:=1 to 12 do graphe[i].saveToStream(f,Fdata);
end;

function Tacquis1.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
  var
    st1:string[255];
    posf:LongWord;
    posIni:LongWord;
    i:integer;
  begin
    result:=inherited loadFromStream(f,size,false);

    if not result then exit;

    if f.position>=f.size then
      begin
        result:=true;
        exit;
      end;

    for i:=1 to 12 do
      begin
        posIni:=f.position;
        st1:=readHeader(f,size);

        result:=(st1=Tvector.stmClassName) and
             (mem[i].loadFromStream(f,size,Fdata)) {and
             (mem[i].notPublished)};
        if not result then
          begin
             f.Position:=Posini;
             exit;
           end
        else
          begin
            mem[i].initTemp1(0,99,G_smallint);
            mem[i].readOnly:=false;
          end;

      end;

    for i:=1 to 12 do
      begin
        posIni:=f.position;
        st1:=readHeader(f,size);

        result:=(st1=Tgraph.stmClassName) and
             (graphe[i].loadFromStream(f,size,Fdata)) {and
             (graphe[i].notPublished)};
        if not result then
          begin
             f.Position:=Posini;
             exit;
           end;
      end;

    setChildNames;
  end;

function Tacquis1.initialise(st:AnsiString):boolean;
begin
  initialise:=inherited initialise(st);
  setChildNames;
end;

procedure Tacquis1.RetablirReferences(list:Tlist);
var
  i:integer;
begin
  for i:=1 to 12 do graphe[i].retablirReferences(list);
end;

                     { Méthodes stm}


{Les mémoires de calcul}

procedure proTacquis1_c(i:integer;var p:typeUO;var pu:typeUO);
begin
  sortieErreur(E_affectation);
end;

function fonctionTacquis1_c(i:smallInt;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  if (i<1) or (i>12) then sortieErreur(E_memC);
  with Tacquis1(pu) do fonctionTacquis1_c:=@mem[i];
end;

function fonctionTacquis1_c1(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_c1:=@mem[1];
end;

function fonctionTacquis1_c2(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_c2:=@mem[2];
end;

function fonctionTacquis1_c3(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_c3:=@mem[3];
end;

function fonctionTacquis1_c4(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_c4:=@mem[4];
end;

function fonctionTacquis1_c5(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_c5:=@mem[5];
end;

function fonctionTacquis1_c6(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_c6:=@mem[6];
end;

function fonctionTacquis1_c7(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_c7:=@mem[7];
end;

function fonctionTacquis1_c8(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_c8:=@mem[8];
end;

function fonctionTacquis1_c9(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_c9:=@mem[9];
end;

function fonctionTacquis1_c10(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_c10:=@mem[10];
end;

function fonctionTacquis1_c11(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_c11:=@mem[11];
end;

function fonctionTacquis1_c12(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_c12:=@mem[12];
end;



{Les graphes }

procedure proTacquis1_g(i:integer;var p:typeUO;var pu:typeUO);
begin
  sortieErreur(E_affectation);
end;

function fonctionTacquis1_g(i:smallInt;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  if (i<1) or (i>12) then sortieErreur(E_grapheC);
  with Tacquis1(pu) do fonctionTacquis1_g:=@graphe[i];
end;

function fonctionTacquis1_g1(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_g1:=@graphe[1];
end;

function fonctionTacquis1_g2(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_g2:=@graphe[2];
end;

function fonctionTacquis1_g3(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_g3:=@graphe[3];
end;

function fonctionTacquis1_g4(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_g4:=@graphe[4];
end;

function fonctionTacquis1_g5(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_g5:=@graphe[5];
end;

function fonctionTacquis1_g6(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_g6:=@graphe[6];
end;

function fonctionTacquis1_g7(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_g7:=@graphe[7];
end;

function fonctionTacquis1_g8(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_g8:=@graphe[8];
end;

function fonctionTacquis1_g9(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_g9:=@graphe[9];
end;

function fonctionTacquis1_g10(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_g10:=@graphe[10];
end;

function fonctionTacquis1_g11(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_g11:=@graphe[11];
end;

function fonctionTacquis1_g12(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tacquis1(pu) do fonctionTacquis1_g12:=@graphe[12];
end;


procedure proTacquis1_SetGraph(num:smallint;var s1,s2:Tvector;Ideb,Ifin:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (num<1) or (num>12) then sortieErreur(E_grapheC);
  verifierObjet(typeUO(s1));
  verifierObjet(typeUO(s2));
  with Tacquis1(pu) do
    graphe[num].initData(s1,s2,nil,Ideb,Ifin);

end;

procedure proTacquis1_SetGraph1(num:smallint;var s1,s2,s3:Tvector;Ideb,Ifin:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (num<1) or (num>12) then sortieErreur(E_grapheC);
  with Tacquis1(pu) do
    graphe[num].initData(s1,s2,s3,Ideb,Ifin);
end;



Initialization
AffDebug('Initialization stmAc1',0);

installError(E_memC,'AC1: Invalid memory number');
installError(E_affectation,'AC1: cannot modify this object');
installError(E_grapheC,'AC1: Invalid graph number');


registerObject(Tacquis1,sys);
 
end.
