unit stmMatImage;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysutils,
     util1,Dgraphic,tbe0,stmdef,stmObj,stmDobj1,stmMat1,stmPg,Ncdef2,IPPI,IPPdefs;

const
  typesIMSupportes=[g_single,G_singleComp];


type
  TmatImage=
          class(Tmatrix)
            constructor create;override;
            class Function reverseTemp:boolean;override;

            procedure initTemp0(ad:pointer;n1,n2,m1,m2:longint;tNombre:typeTypeG);
            procedure initTemp(n1,n2,m1,m2:longint;tNombre:typeTypeG);override;
            procedure initTempEx(ad:pointer;n1,n2,m1,m2:longint;tNombre:typeTypeG);
            procedure modifyAd(ad:pointer);

            class function STMClassName:AnsiString;override;
            class function SupportType(t:typetypeG):boolean;

            function stepIPP:integer;override;
            function sizeIPP:IPPIsize;override;
            function sizeIPP(n1,n2:integer):IPPIsize;override;
            function rectIPP(x1,y1,w1,h1:integer):IPPIrect;override;

            procedure copyDataFrom(p:typeUO);override;
          end;

procedure proTmatImage_create(name:AnsiString;t:integer;ncol,nrow:longint;var pu:typeUO);pascal;
procedure proTmatImage_create_1(t:integer;ncol,nrow:longint;var pu:typeUO);pascal;

implementation

{ Timage }

constructor TmatImage.create;
begin
  inherited;
end;


class function TmatImage.SupportType(t: typetypeG): boolean;
begin
  result:= t in [g_single,G_singleComp];
end;


procedure TmatImage.initTemp0(ad:pointer;n1, n2, m1, m2: Integer; tNombre: typeTypeG);
var
  taille:longint;

begin

  data.free;
  data:=nil;

  prioAff:=1;
  nblig:=n2-n1+1;
  nbcol:=m2-m1+1;
  taille:=tailleTypeG[tNombre]*nbCol*nbLig;

  if inf.temp then freeTemp0;
  if ad<>nil then
  begin
    tbTemp:=ad;
    inf.tpNum:=tNombre;
    inf.temp:=false;
  end
  else TdataObj(self).initTemp0(tNombre,taille);

  with inf,visu do
  begin
    inf.imin:=n1;
    inf.imax:=n2;
    inf.jmin:=m1;
    inf.jmax:=m2;
  end;

  case tNombre of
    G_single:      data:=TdatatbSline.create(tb^,n1,n2,m1,m2);
    G_singleComp:  data:=TdataTbScompLine.create(tb^,n1,n2,m1,m2);
  end;

  if data<>nil then
    begin
      data.ax:=inf.dxu;
      data.bx:=inf.x0u;
      data.ay:=inf.dyu;
      data.by:=inf.y0u;
      data.az:=inf.dzu;
      data.bz:=inf.z0u;
    end;

  inverseY:=true;
  keepRatio:=true;
  palColor[1]:=7;
  palColor[2]:=7;


  invalidate;
end;

procedure TmatImage.initTemp(n1, n2, m1, m2: Integer; tNombre: typeTypeG);
begin
  { Si l'objet n'est pas Temp mais a son buffer alloué, c'est qu'il est utilisé de façon spéciale.
    Si un programme demande une réallocation du buffer avec des paramètres identiques,
    on ne fait rien.
    Sinon, on génère une erreur.

    Pour utiliser un mode spécial, il faut appeler initTemp0.
  }
  if (tb<>nil) and not inf.temp  then
  begin
    if (tNombre<>inf.tpNum) or (n1<>inf.imin) or (n2<>inf.imax) or (m1<>inf.jmin) or (m2<>inf.jmax)
      then sortieErreur('TmatImage : this object cannot be modified');
    invalidate;
    exit;
  end;

  initTemp0(nil,n1, n2, m1, m2, tNombre);
end;

procedure TmatImage.initTempEx(ad:pointer;n1, n2, m1, m2: Integer; tNombre: typeTypeG);
begin
  initTemp0(ad,n1, n2, m1, m2, tNombre);
end;

procedure TmatImage.modifyAd(ad:pointer);
begin
  tbTemp:=ad;
  data.modifyAd(ad);
end;

class function TmatImage.STMClassName: AnsiString;
begin
  result:='MatImage';
end;

function TMatImage.sizeIPP: IPPIsize;
begin
  result.width:=Icount;
  result.height:=Jcount;
end;

function TMatImage.stepIPP: integer;
begin
  result:=Icount*TailleTypeG[tpNum];
end;



procedure proTmatImage_create(name:AnsiString;
                   t:integer;ncol,nrow:longint;var pu:typeUO);
  begin
    if not (typeTypeG(t) in typesIMSupportes)
      then sortieErreur('Timage.create : invalid type');

    if (ncol<0) or (nrow<0) then  sortieErreur('Timage.create : bad dimension');

    createPgObject(name,pu,TmatImage);
    with TmatImage(pu) do
    begin
      initTemp(0,ncol-1,0,nrow-1,TypetypeG(t));
      autoscaleX;
      autoscaleY;
      setChildNames;
    end;
  end;

procedure proTmatImage_create_1(t:integer;ncol,nrow:longint;var pu:typeUO);
begin
  proTmatImage_create_1(t,ncol,nrow,pu);
end;


function TmatImage.rectIPP(x1, y1, w1, h1: integer): IPPIrect;
begin
  with result do
  begin
    x:=x1;
    y:=y1;
    width:=w1;
    height:=h1;
  end;
end;

function TmatImage.sizeIPP(n1, n2: integer): IPPIsize;
begin
  with result do
  begin
    width:=n1;
    height:=n2;
  end;
end;

procedure TmatImage.copyDataFrom(p: typeUO);
var
  p1:TmatImage;
begin
  p1:=TmatImage(p);
  if (p is Tmatimage) and
     ( not inf.temp and (tb<>nil) or not p1.inf.temp and (p1.tb<>nil) ) and
     (tpNum=p1.tpNum) and (Icount=p1.Icount) and (Jcount=p1.Jcount)
    then  move(p1.tb^,tb^,Icount*Jcount*tailleTypeG[tpNum])
    else  inherited;

end;

class function TmatImage.reverseTemp: boolean;
begin
  result:=true;
end;

Initialization
AffDebug('Initialization stmMatImage',0);

registerObject(TmatImage,data);

end.
