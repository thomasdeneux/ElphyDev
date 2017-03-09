unit stmUpal0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses sysutils,
     util1,visu0,varconf1, debug0,
     stmdef,stmObj,stmDplot,matCooD0,
     Ncdef2,stmError,stmPg;

type
  TcolorMap=class(TdataPlot)
                  PalName:AnsiString;
                  Dir:integer;
                  Ncol:integer;
                  degP:typeDegre;

                  procedure setXmin(x:double);override;
                  procedure setXmax(x:double);override;
                  procedure setYmin(x:double);override;
                  procedure setYmax(x:double);override;
                  procedure setZmin(x:double);override;
                  procedure setZmax(x:double);override;

                  constructor create;override;

                  class function STMClassName:AnsiString;override;

                  procedure display; override;
                  procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);
                                     override;

                  function ChooseCoo1:boolean;override;
                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;

             end;

procedure proTcolorMap_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTcolorMap_create_1(var pu:typeUO);pascal;


function fonctionTcolorMap_gamma(var pu:typeUO):float;pascal;
procedure proTcolorMap_gamma(x:float;var pu:typeUO);pascal;

function fonctionTcolorMap_TwoColors(var pu:typeUO):boolean;pascal;
procedure proTcolorMap_TwoColors(x:boolean;var pu:typeUO);pascal;

function fonctionTcolorMap_PalColor(n:smallint;var pu:typeUO):smallInt;pascal;
procedure proTcolorMap_PalColor(n:smallInt;x:smallInt;var pu:typeUO);pascal;

procedure proTcolorMap_PalName(x:AnsiString;var pu:typeUO);pascal;
function fonctionTcolorMap_PalName(var pu:typeUO):AnsiString;pascal;

function fonctionTcolorMap_Direction(var pu:typeUO):smallint;pascal;
procedure proTcolorMap_Direction(x:smallint;var pu:typeUO);pascal;

function fonctionTcolorMap_ColCount(var pu:typeUO):smallint;pascal;
procedure proTcolorMap_ColCount(x:smallint;var pu:typeUO);pascal;

implementation

constructor TcolorMap.create;
begin
  inherited;
  Ncol:=256;
  with visu do
  begin
    color:=longint(2) shl 16+1;
    echY:=false;
    FtickY:=false;
    CompletX:=false;
    CompletY:=false;
  end;
end;

class function TcolorMap.STMClassName:AnsiString;
begin
  result:='ColorMap';
end;

procedure TcolorMap.display;
begin
  visu.displayColorMap(PalName,dir,Ncol);
end;


procedure TcolorMap.displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);
begin
  visu.displayColorMap0(PalName,dir,Ncol);
end;

function TcolorMap.ChooseCoo1:boolean;
  var
    chg:boolean;
    title0:AnsiString;
    palName0:AnsiString;
    
  begin
    InitVisu0;

    title0:=title;
    palName0:=PalName;

    if Matcood.choose(title0,visu0^,palName0,nil,degP,cadrerX,cadrerY,cadrerZ,cadrerC) then
      begin
        chg:= not visu.compare(visu0^) or (title<>title0)
              or (palName0<>PalName);
        visu.assign(visu0^);
        title:=title0;
        PalName:=palName0;
      end
    else chg:=false;

    DoneVisu0;
    chooseCoo1:=chg;
  end;

procedure TcolorMap.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    setStringConf('PalName',PalName);
    setVarConf('Dir',dir,sizeof(dir));
    setVarConf('Ncol',Ncol,sizeof(Ncol));

  end;
end;

procedure TcolorMap.setXmin(x:double);
begin
  inherited;
  if dir mod 2=0
    then inherited setZmin(x);
end;

procedure TcolorMap.setXmax(x:double);
begin
  inherited;
  if dir mod 2=0
    then inherited setZmax(x);
end;

procedure TcolorMap.setYmin(x:double);
begin
  inherited;
  if dir mod 2=1
    then inherited setZmin(x);
end;

procedure TcolorMap.setYmax(x:double);
begin
  inherited;
  if dir mod 2=1
    then inherited setZmax(x);
end;

procedure TcolorMap.setZmin(x:double);
begin
  inherited;
  if dir mod 2=0
    then inherited setXmin(x)
    else inherited setYmin(x);
end;

procedure TcolorMap.setZmax(x:double);
begin
  inherited;
  if dir mod 2=0
    then inherited setXmax(x)
    else inherited setYmax(x);
end;


{*********************** Méthodes STM ***********************************}

var
  E_nbcol:integer;
  E_palColor:integer;



procedure proTcolorMap_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TcolorMap);
end;

procedure proTcolorMap_create_1(var pu:typeUO);
begin
  proTcolorMap_create('', pu);
end;

function fonctionTcolorMap_gamma(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TcolorMap(pu).visu.gamma;
end;

procedure proTcolorMap_gamma(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TcolorMap(pu).visu.gamma:=x;
end;

function fonctionTcolorMap_TwoColors(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TcolorMap(pu).visu.TwoCol;
end;

procedure proTcolorMap_TwoColors(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TcolorMap(pu).visu.TwoCol:=x;
end;

function fonctionTcolorMap_PalColor(n:smallint;var pu:typeUO):smallInt;
begin
  verifierObjet(pu);
  controleParam(n,1,2,E_palColor);
  case n of
    1:result:=TmatColor(TcolorMap(pu).visu.Color).col1;
    2:result:=TmatColor(TcolorMap(pu).visu.Color).col2;
  end;
end;

procedure proTcolorMap_PalColor(n:smallint;x:smallInt;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(n,1,2,E_palColor);
  case n of
    1: TmatColor(TcolorMap(pu).visu.Color).col1:=  x;
    2: TmatColor(TcolorMap(pu).visu.Color).col2:=  x;
  end;
end;

procedure proTcolorMap_PalName(x:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TcolorMap(pu).PalName:=x;
end;

function fonctionTcolorMap_PalName(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TcolorMap(pu).PalName;
end;

function fonctionTcolorMap_Direction(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  result:=TcolorMap(pu).dir;
end;

procedure proTcolorMap_Direction(x:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  with TcolorMap(pu) do
  begin
    dir:=x;
    visu.inverseX:=(x=2);
    visu.inverseY:=(x=3);

    visu.echX:=(dir=0) or (dir=2);
    visu.echY:=(dir=1) or (dir=3);

    visu.FtickX:=(dir=0) or (dir=2);
    visu.FtickY:=(dir=1) or (dir=3);

    CompletX:=false;
    CompletY:=false;
  end;
end;

function fonctionTcolorMap_ColCount(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  result:=TcolorMap(pu).Ncol;
end;

procedure proTcolorMap_ColCount(x:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(x,1,256,E_nbcol);
  with TcolorMap(pu) do Ncol:=x;
end;

Initialization
AffDebug('Initialization stmUpal0',0);
installError(E_nbcol,'TcolorMap: Color count out of range');
installError(E_palColor,'TcolorMap: PalColor index count out of range');

registerObject(TcolorMap,data);
end.
