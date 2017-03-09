unit StmGrid2;

{ TVSgrid est utilisé par stmGaborDense1
  obvisA contient des modèles d'objets. Ces objets sont référencés par VSgrid.
  VSgrid permet l'affichage avec recouvrement.

}

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,sysUtils,
     util1,debug0,
     {$IFDEF DX11}
     {$ELSE}
     Direct3D9G,
     {$ENDIF}
     DibG,
     stmdef,stmObj,stmObv0,
     stmPg,syspal32;

type
  TVSgrid=class(Tresizable)
            nX,nY,Nc:smallInt;
            posX,posY:array of array of integer;
            posC:array of array of byte;
            obvisA:array[0..20] of Tresizable;



            nx1,ny1,Nc1:smallint;
            obvisA1:array[0..20] of Tresizable; {mémorise obvisA, utilisé par ResourceNeeded}

            degPave:typeDegre;
            xminPave,xmaxPave,yminPave,ymaxPave: integer;
            DxPaveEx,DyPaveEx: integer;
            polyPave:typePoly5;

            constructor create;override;
            destructor destroy;override;
            class function STMClassName:AnsiString;override;
            procedure freeRef;override;

            procedure CalculPosXPosY;
            procedure initGrid(nbx,nby:integer);
            procedure resetGrid;
            procedure addObject(uo:Tresizable);

            function ResourceNeeded:boolean;override;
            procedure BuildResource;override;
            procedure Blt(const degV: typeDegre);override;

            procedure setStatus(i,j,n:integer);
            function getStatus(i,j:integer):integer;
            property status[i,j:integer]:integer read getStatus write setStatus;

            procedure processMessage(id:integer;source:typeUO;p:pointer);override;

          end;


procedure proTVSgrid_create(var pu:typeUO);pascal;
procedure proTVSgrid_create_1(st:AnsiString; var pu:typeUO);pascal;

procedure proTVSgrid_initGrid(nbx,nby:integer; var pu:typeUO);pascal;
procedure proTVSgrid_AddObject(var puOb, pu:typeUO);pascal;

procedure proTVSgrid_Status(i,j,n:integer; var pu:typeUO);pascal;
function fonctionTVSgrid_Status(i,j:integer; var pu:typeUO):integer;pascal;

implementation


{*********************   Méthodes de Tgrid   ***************************}


constructor TVSgrid.create;
var
  i:integer;
begin
  inherited create;
end;

destructor TVSgrid.destroy;
var
  i:integer;
begin
  for i:=1 to nc do
    derefObjet(typeUO(obvisA[i]));

  inherited destroy;
end;

class function TVSgrid.STMClassName:AnsiString;
begin
  STMClassName:='VSGrid';
end;

procedure TVSgrid.freeRef;
var
  i:integer;
begin
  for i:=1 to nc do
    derefObjet(typeUO(obvisA[i]));
end;

procedure TVSgrid.CalculPosXPosY;
var
  i,j:integer;
  x0,y0:float;
  xc,yc:float;

begin
  for i:=0 to nx do
  for j:=0 to ny do
  begin
    x0 := (i-nX/2) * degPave.dX;
    y0 := (j-nY/2) * degPave.dY;
    DegRotationR(x0,y0,xc,yc,0,0,deg.theta);
    posX[i,j]:=degToX(xc+deg.x)-dxPaveEx div 2;
    posY[i,j]:=degToY(yc+deg.y)-dyPaveEx div 2;
  end;

  deg1:=deg;
end;

procedure TVSgrid.initGrid(nbx,nby:integer);
var
  i,j:integer;

begin
  resetGrid;

  nx:=nbx;
  ny:=nby;
  nc:=0;

  setLength(posX,nx+1,ny+1);
  setLength(posY,nx+1,ny+1);
  for i:=0 to nx do
  for j:=0 to ny do
  begin
    posX[i,j]:=0;
    posY[i,j]:=0;
  end;

  setLength(posC,nx+2,ny+2);
  for i:=0 to nx+1 do
  for j:=0 to ny+1 do
    posC[i,j]:=0;

end;

procedure TVSgrid.resetGrid;
var
  i:integer;
begin
  for i:=1 to nc do derefObjet(typeUO(obvisA[i]));
  fillchar(obvisA,sizeof(obvisA),0);
  nc:=0;
  freeBM;
end;

procedure TVSgrid.addObject(uo:Tresizable);
begin
  if (nc>=20) or not assigned(uo) then exit;

  inc(nc);
  obvisA[nc]:=uo;
  refObjet(uo);
end;


function TVSgrid.ResourceNeeded: boolean;
begin
  result:= (deg.dx<>deg1.dx) or (deg.dy<>deg1.dy) or (deg.theta<>deg1.theta) or
           (nx<>nx1) or
           (ny<>ny1) or
           (nc<>nc1) or
           not compareMem(@obvisA[0],@obvisA1[0],sizeof(obvisA));
end;


{ BuildResource construit un grand bitmap contenant toutes les combinaisons de recouvrement
de quatre pavés.
  Il est beaucoup plus rapide de faire les calculs en mémoire du PC plutôt qu'en mémoire vidéo.
On utilise donc des dibs plutôt que des surfaces directX.
  obvisA contient les modèles d'objets. On les copie dans dibA.
  DibDraft sert à construire un pavé. Le pavé s'obtient en affichant les quatres dibA aux
quatres coins du pavé (incliné).
  DibMask sert à masquer le résultat en mettant à zéro les points en dehors du pavé.
  Une fois DibDraft calculé, on l'affiche dans HardDib.

  Finalement, on copie HardDib dans la mémoire vidéo, on obtient HardBM.
}
procedure TVSgrid.BuildResource;
begin
end;

procedure TVSgrid.Blt(const degV: typeDegre);
begin
end;

procedure TVSgrid.processMessage(id: integer; source: typeUO; p: pointer);
var
  i:integer;
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
        for i:=1 to nc do
        if (obvisA[i]=source) then
          begin
            obvisA[i]:=nil;
            derefObjet(source);
          end;
      end;
  end;
end;


function TVSgrid.getStatus(i, j: integer): integer;
begin
  if (i>=0) and (i<length(posC)) and (j>=0) and (j<length(posC[0]))
    then result:=posC[i,j]
    else result:=0;
end;

procedure TVSgrid.setStatus(i, j, n: integer);
begin
  if (i>=0) and (i<length(posC)) and (j>=0) and (j<length(posC[0])) and (n>=0) and (n<=nc)
    then posC[i,j]:=n;
end;



{****************************** Méthodes STM ***************************************}

procedure proTVSgrid_create(var pu:typeUO);
begin
  createPgObject('',pu,TVSgrid);
end;

procedure proTVSgrid_create_1(st:AnsiString; var pu:typeUO);
begin
  createPgObject(st,pu,TVSgrid);
end;


procedure proTVSgrid_initGrid(nbx,nby:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSgrid(pu) do
    initgrid(nbx,nby);

end;

procedure proTVSgrid_AddObject(var puOb, pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(puOb);
  TVSgrid(pu).addObject(Tresizable(puOb));

end;

procedure proTVSgrid_Status(i,j,n:integer; var pu:typeUO);
begin
  verifierObjet(pu);

  TVSgrid(pu).status[i,j]:=n;
  TVSgrid(pu).majPos;
end;

function fonctionTVSgrid_Status(i,j:integer; var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TVSgrid(pu).status[i,j];
end;


Initialization
AffDebug('Initialization stmGrid2',0);
if TestUnic then
  registerObject(TVSgrid,obvis);


end.
