unit StmExeAc;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses sysUtils,
     util1,Gdos,DdosFich,Dgraphic,clock0,
     stmdef,stmObj,
     stmPlot1, stmDplot, stmDobj1 ,stmVec1;

function fonctionGetUnitX(var source:TdataObj):AnsiString;pascal;
function fonctionGetUnitY(var source:TdataObj):AnsiString;pascal;

function fonctionXdebutMem(var t:Tvector):float;pascal;
function fonctionXfinMem(var t:Tvector):float;pascal;

function fonctiongetV(var source:Tvector;x:float):float;pascal;
function fonctionGetVI(var source:Tvector;i:longint):smallint;pascal;

procedure proSetV(var source:Tvector;x,y:float);pascal;
procedure proSetVI(var source:Tvector;i:longint;j:smallint);pascal;

function fonctionConvX(var source:TdataObj;i:longint):float;pascal;
function fonctionConvY(var source:TdataObj;i:smallint):float;pascal;

function fonctionInvConvX(var source:TdataObj;x:float):longint;pascal;
function fonctionInvConvY(var source:TdataObj;y:float):longint;pascal;

procedure proSetScaleX(var source:TdataObj;Dx,x0:float;ux:AnsiString);pascal;
procedure proSetScaleY(var source:TdataObj;Dy,y0:float;uy:AnsiString);pascal;

procedure proSetWorldT(var t:TdataObj;x1,y1,x2,y2:float);pascal;
procedure proSetStyleT(var t:TdataObj;mode,taille:smallint;
                    logX,logY,grille:boolean;color:smallint);pascal;

procedure proGetWorldT(var t:TdataObj;var x1,y1,x2,y2:float);pascal;

function fonctionGetColorT(var t:TdataObj):longint;pascal;

procedure proFichierMem(num:integer);pascal;

implementation

function fonctionGetUnitX(var source:TdataObj):AnsiString;
begin
  verifierObjet(typeUO(source));
  fonctionGetUnitX:=source.visu.uX;
end;

function fonctionGetUnitY(var source:TdataObj):AnsiString;
begin
  verifierObjet(typeUO(source));
  fonctionGetUnitY:=source.visu.uY;
end;

function fonctionXdebutMem(var t:Tvector):float;
  begin
    verifierObjet(typeUO(t));
    fonctionXdebutMem:= t.Xstart;
  end;

function fonctionXfinMem(var t:Tvector):float;
  begin
    verifierObjet(typeUO(t));
    fonctionXfinMem:= t.Xend;
  end;


function fonctiongetV(var source:Tvector;x:float):float;
begin
  fonctiongetV:= fonctionTVector_Rvalue(x,typeUO(source));
end;

function fonctionGetVI(var source:Tvector;i:longint):smallint;
begin
  fonctiongetVI:= fonctionTVector_Jvalue(i,typeUO(source));
end;

procedure proSetV(var source:Tvector;x,y:float);
begin
  proTVector_Rvalue(x,y,typeUO(source));
end;

procedure proSetVI(var source:Tvector;i:longint;j:smallint);
begin
  proTVector_Jvalue(i,j,typeUO(source));
end;

function fonctionConvX(var source:TdataObj;i:longint):float;
begin
  fonctionConvX:=FonctionTdataObject_convX(i,typeUO(source));
end;

function fonctionConvY(var source:TdataObj;i:smallint):float;
begin
  fonctionConvY:=FonctionTdataObject_convY(i,typeUO(source));
end;

function fonctionInvConvX(var source:TdataObj;x:float):longint;
begin
  fonctionInvConvX:=FonctionTdataObject_invconvX(x,typeUO(source));
end;

function fonctionInvConvY(var source:TdataObj;y:float):longint;
begin
  fonctionInvConvY:=FonctionTdataObject_invconvY(y,typeUO(source));
end;

procedure proSetScaleX(var source:TdataObj;Dx,x0:float;ux:AnsiString);
begin
  verifierObjet(typeUO(source));
  with source do
  begin
    Dxu:=Dx;
    x0u:=x0;
    unitX:=ux;
  end;
end;

procedure proSetScaleY(var source:TdataObj;Dy,y0:float;uy:AnsiString);
begin
  verifierObjet(typeUO(source));
  with source do
  begin
    Dyu:=Dy;
    y0u:=y0;
    unitY:=uy;
  end;
end;

procedure proSetWorldT(var t:TdataObj;x1,y1,x2,y2:float);
begin
  proTdataPlot_SetWorld(x1,y1,x2,y2,typeUO(t));
end;

procedure proSetStyleT(var t:TdataObj;mode,taille:smallint;
                    logX,logY,grille:boolean;color:smallint);
begin
  verifierObjet(typeUO(t));
  with t do
  begin
    visu.modeT:=mode;
    visu.tailleT:=taille;
    visu.modeLogX:=logX;
    visu.modeLogY:=logY;
    visu.grille:=grille;
    visu.color:=color;
  end;
end;

procedure proGetWorldT(var t:TdataObj;var x1,y1,x2,y2:float);
begin
  proTdataPlot_GetWorld(x1,y1,x2,y2,typeUO(t));
end;

function fonctionGetColorT(var t:TdataObj):longint;
begin
  verifierObjet(typeUO(t));
  fonctionGetColorT:=t.visu.color;
end;

procedure proFichierMem(num:integer);
begin
end;

end.
