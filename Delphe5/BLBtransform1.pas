unit BLBtransform1;

interface

uses classes, sysutils,
     util1, stmdef,stmObj, stmObv0, stmMvtX1, cuda1, stmPG, sysPal32, Direct3D9G, ncdef2,
     stmstmX0, Dprocess, stmVSBM1,
     debug0,stmvec1,
     stmTransform1;

type
{ obvis(dest) et obSource ont le même rapport longueur/nb pixels
  on copy src dans dest avec les règles suivantes:

  modeAlpha = 1: copie directe de alpha
            = 2: src= 0 signifie ne rien faire

  modeLum   = 1: copie directe
            = 2: Lum src contient des numéros 1,2,3...
                 chaque numéro est remplacé par Lum1, Lum2, Lum3...
}

  TVSBlt = class(TVStransform)

                   Alpha,Lum: array[1..4] of single ;
                   x0D, y0D, theta0D: single;
                   AlphaMode,LumMode: integer;
                   DestResource: pointer;
                   DestWidth, DestHeight:integer;


                   constructor create;override;
                   destructor destroy;override;
                   class function stmClassName: AnsiString;override;

                   procedure Init(x, y, theta: float; modeA, modeL: integer);

                   procedure DoTransform1;override;

                   function MaxTrajParams: integer;override;
                   function AddTraj(st:AnsiString;vec:Tvector):integer;override;
                   procedure updateTraj(numCycle:integer);override;
                 end;


procedure proTVSBlt_create(var pu:typeUO);pascal;
procedure proTVSBlt_create_1(x,y,theta:float;var pu:typeUO);pascal;

procedure proTVSBlt_AlphaMode(w:integer; var pu:typeUO);pascal;
function fonctionTVSBlt_AlphaMode(var pu:typeUO): integer;pascal;

procedure proTVSBlt_LumMode(w:integer; var pu:typeUO);pascal;
function fonctionTVSBlt_LumMode(var pu:typeUO): integer;pascal;


procedure proTVSBlt_AlphaValue(n:integer;w:float; var pu:typeUO);pascal;
function fonctionTVSBlt_AlphaValue(n:integer;var pu:typeUO): float;pascal;

procedure proTVSBlt_LumValue(n:integer;w:float; var pu:typeUO);pascal;
function fonctionTVSBlt_LumValue(n:integer;var pu:typeUO): float;pascal;

procedure proTVSBlt_X0(w:float; var pu:typeUO);pascal;
function fonctionTVSBlt_X0(var pu:typeUO): float;pascal;

procedure proTVSBlt_Y0(w:float; var pu:typeUO);pascal;
function fonctionTVSBlt_Y0(var pu:typeUO): float;pascal;

procedure proTVSBlt_Theta0(w:float; var pu:typeUO);pascal;
function fonctionTVSBlt_Theta0(var pu:typeUO): float;pascal;


implementation

{ TVSBlt }


constructor TVSBlt.create;
begin
  inherited;

end;

destructor TVSBlt.destroy;
begin
  inherited;
end;


procedure TVSBlt.DoTransform1;
var
  p:pointer;
  i,res:integer;
  x0,y0: integer;
  tCycle,numCycle:integer;

  AlphaArray,LumArray: array[1..4] of integer;

  ax,ay: single;
begin
  for i:=1 to 4 do
  begin
    if Alpha[i]>=0 then AlphaArray[i]:= round(255*Alpha[i]) else AlphaArray[i]:=-1;
    if Lum[i]>=0 then LumArray[i]:= syspal.LumIndex(Lum[i]) else LumArray[i]:=-1;
  end;

  x0:= round(wDest/DxDest*x0D);
  y0:= round(hDest/DyDest*y0D);

  ax:= DxDest/wdest / DxSrc* wSrc;
  ay:= DyDest/hdest / DySrc* hSrc;


  res:= BltSurface(  tf,
                     x0,-y0, theta0D*pi/180, ax, ay,
                     AlphaMode,LumMode,@AlphaArray[1],@LumArray[1], CudaRgbMask);

  if res<>0 then WarningList.add('BltSurface='+Istr(res));
end;

procedure TVSBlt.updateTraj(numCycle: integer);
var
  base:integer;
begin
  if length(paramvalue)>0 then
  begin
    inherited UpdateTraj(numCycle);
    base:= inherited MaxTrajParams;
    if length(paramvalue[base +0])>numCycle then x0D:=paramValue[base +0,numCycle];
    if length(paramvalue[base +1])>numCycle then y0D:=paramValue[base +1,numCycle];
    if length(paramvalue[base +2])>numCycle then theta0D:=paramValue[base +2,numCycle];

    if length(paramvalue[base +3])>numCycle then AlphaMode:=     round(paramValue[base +3,numCycle]);
    if length(paramvalue[base +4])>numCycle then LumMode:=       round(paramValue[base +4,numCycle]);
    if length(paramvalue[base +5])>numCycle then Alpha[1]:= paramValue[base +5,numCycle];
    if length(paramvalue[base +6])>numCycle then Alpha[2]:= paramValue[base +6,numCycle];
    if length(paramvalue[base +7])>numCycle then Alpha[3]:= paramValue[base +7,numCycle];
    if length(paramvalue[base +8])>numCycle then Lum[1]:=   paramValue[base +8,numCycle];
    if length(paramvalue[base +9])>numCycle then Lum[2]:=   paramValue[base +9,numCycle];
    if length(paramvalue[base +10])>numCycle then Lum[3]:=  paramValue[base +10,numCycle];
  end;
end;

function TVSBlt.MaxTrajParams: integer;
begin
  result:= inherited MaxTrajParams +11;
end;

function TVSBlt.AddTraj(st: AnsiString; vec: Tvector):integer;
var
  base:integer;
begin
  st:=UpperCase(st);
  result:= inherited AddTraj(st,vec);

  if result<0 then
  begin
    base:= inherited MaxTrajParams;
    if st='X0' then result:= base +0
    else
    if st='Y0' then result:= base +1
    else
    if st='THETA0' then result:= base +2
    else
    if st='ALPHAMODE' then result:= base +3
    else
    if st='LUMMODE' then result:= base +4
    else
    if st='ALPHAVALUE1' then result:= base +5
    else
    if st='ALPHAVALUE2' then result:= base +6
    else
    if st='ALPHAVALUE3' then result:= base +7
    else
    if st='LUMVALUE1' then result:= base +8
    else
    if st='LUMVALUE2' then result:= base +9
    else
    if st='LUMVALUE3' then result:= base +10;

    if result>=0 then AddTraj1(result,vec);
  end;

end;

procedure TVSBlt.Init(x, y, theta: float; modeA, modeL: integer);
begin
  x0D:= x;
  y0D:= y;
  theta0D:= theta;

  AlphaMode:= modeA;
  LumMode:= modeL;
end;


class function TVSBlt.stmClassName: AnsiString;
begin
  result:='VSBlt';
end;

procedure proTVSBlt_create(var pu:typeUO);
begin
  createPgObject('',pu,TVSBlt);
  TVSBlt(pu).Init(0,0,0,1,1);
end;


procedure proTVSBlt_create_1(x,y,theta:float;var pu:typeUO);pascal;
begin
  createPgObject('',pu,TVSBlt);
  TVSBlt(pu).Init(x,y,theta,1,1);
end;


procedure proTVSBlt_AlphaMode(w:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSBlt(pu).AlphaMode:=w;
end;

function fonctionTVSBlt_AlphaMode(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:= TVSBlt(pu).AlphaMode;
end;

procedure proTVSBlt_LumMode(w:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSBlt(pu).LumMode:=w;
end;

function fonctionTVSBlt_LumMode(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:= TVSBlt(pu).LumMode;
end;

procedure proTVSBlt_AlphaValue(n:integer;w:float; var pu:typeUO);
begin
  verifierObjet(pu);
  if (n<1) or (n>3) then sortieErreur('TVSBlt.AlphaValue : index out of range');
  TVSBlt(pu).Alpha[n]:=w;
end;

function fonctionTVSBlt_AlphaValue(n:integer;var pu:typeUO): float;
begin
  verifierObjet(pu);
    if (n<1) or (n>3) then sortieErreur('TVSBlt.AlphaValue : index out of range');
  result:= TVSBlt(pu).Alpha[n];
end;

procedure proTVSBlt_LumValue(n:integer;w:float; var pu:typeUO);
begin
  verifierObjet(pu);
  if (n<1) or (n>3) then sortieErreur('TVSBlt.LumValue : index out of range');
  TVSBlt(pu).Lum[n]:=w;
end;

function fonctionTVSBlt_LumValue(n:integer;var pu:typeUO): float;
begin
  verifierObjet(pu);
    if (n<1) or (n>3) then sortieErreur('TVSBlt.LumValue : index out of range');
  result:= TVSBlt(pu).Lum[n];
end;

procedure proTVSBlt_X0(w:float; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSBlt(pu).x0D:=w;
end;

function fonctionTVSBlt_X0(var pu:typeUO): float;
begin
  verifierObjet(pu);
  result:= TVSBlt(pu).x0D;
end;


procedure proTVSBlt_Y0(w:float; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSBlt(pu).y0D:=w;
end;

function fonctionTVSBlt_Y0(var pu:typeUO): float;
begin
  verifierObjet(pu);
  result:= TVSBlt(pu).y0D;
end;


procedure proTVSBlt_Theta0(w:float; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSBlt(pu).theta0D:=w;
end;

function fonctionTVSBlt_Theta0(var pu:typeUO): float;
begin
  verifierObjet(pu);
  result:= TVSBlt(pu).theta0D;
end;




end.
