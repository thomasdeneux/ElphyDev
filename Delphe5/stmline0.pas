unit Stmline0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,controls,forms,
     util1,Dgraphic,editCont, Debug0,
     stmDef,stmObj,stmObv0,defForm,
     syspal32,
     lineForm, stmPg;


type
  TVSline=class(Tresizable)
            ControlStyle:TpenStyle;

            seg,seg1:Trect;     { segment affiché et avant-dernier segment }
            segAff:Trect;       { segment sur controle }
            xa,ya:Integer;      { poignée }

            rgn:hRgn;

            constructor create;override;
            class function STMClassName:AnsiString;override;

            procedure creerRegions;override;
            procedure detruireRegions;override;
            procedure ShowHandles;override;

            procedure aff;
            procedure afficheS;override;
            procedure afficheC;override;

            procedure calculePos;

            function MouseDown(Button: TMouseButton;
                            Shift: TShiftState; X, Y: smallInt):boolean;override;
            function MouseMove(Shift: TShiftState;
                            X, Y: smallInt):smallInt; override;
            procedure MouseUp(Button: TMouseButton;
                            Shift: TShiftState; X, Y: smallInt);override;

            function DialogForm:TclassGenForm;override;

            procedure installDialog(var form:Tgenform;var newF:boolean);
                                                                     override;
            procedure AlignOnVisualObject(ob:TvisualObject;numO,num:smallInt);
                                                                     override;
        end;


procedure proTVSline_create(var pu:typeUO);pascal;
procedure proTVSline_create_1(name:AnsiString;var pu:typeUO);pascal;

procedure proTVSline_x0(ww:float;var pu:typeUO);pascal;
function fonctionTVSline_x0(var pu:typeUO):float;pascal;

procedure proTVSline_y0(ww:float;var pu:typeUO);pascal;
function fonctionTVSline_y0(var pu:typeUO):float;pascal;

procedure proTVSline_theta(ww:float;var pu:typeUO);pascal;
function fonctionTVSline_theta(var pu:typeUO):float;pascal;



implementation


constructor TVSline.create;
begin
  inherited create;
  deg.x:=320;
  deg.y:=240;

  deg.lum:=20;
  controlColor:=rgb(128,128,128);
end;

class function TVSline.STMClassName:AnsiString;
begin
  STMClassName:='VSLine';
end;


procedure TVSline.creerRegions;
begin
  if rgn<>0 then deleteObject(rgn);

  rgn:=createRectRgn(xa-2,ya-2,xa+2,ya+2);
end;

procedure TVSline.detruireRegions;
begin
  if rgn<>0 then
    begin
      deleteObject(rgn);
      rgn:=0;
    end;
end;

procedure TVSline.ShowHandles;
begin
  drawHandle(xa,ya);
end;


procedure TVSline.afficheS;
var
  k:integer;
begin
end;


procedure TVSline.aff;
begin
  with canvasGlb do
  begin
      pen.color:=clwhite;
      with segAff do
      begin
        moveto(left,top);
        Lineto(right,bottom);
      end;
  end;
end;



procedure TVSline.afficheC;
begin
  calculePos;
  aff;
  creerRegions;
end;


procedure TVSline.calculePos;
var
  a,b,xr1,yr1,xr2,yr2:float;
  cos0:float;
begin
  seg1:=seg;

  cos0:=cos(pi/180*deg.theta);
  if abs(cos0)<0.001 then
    begin
      xr1:=deg.x;
      xr2:=deg.x;
      yr1:=0;
      yr2:=SSheight;
    end
  else
    begin
      a:=sin(pi/180*deg.theta)/cos0;
      b:=deg.y-a*deg.x;
      LineToSegment(a,b,-degXmax,-degYmax,degXmax,degYmax,xr1,yr1,xr2,yr2);
    end;

  seg.left:=degToX(xr1);
  seg.top:=degToY(yr1);
  seg.right:=degToX(xr2);
  seg.bottom:=degToY(yr2);

  segAff.left:=degToXC(xr1);
  segAff.top:=degToYC(yr1);
  segAff.right:=degToXC(xr2);
  segAff.bottom:=degToYC(yr2);

  xa:=degToXC(deg.x);
  ya:=degToYC(deg.y);
end;


function TVSline.MouseDown(Button: TMouseButton;
                            Shift: TShiftState; X, Y: smallInt):boolean;
var
  i:smallInt;
begin
  mouseDown:=false;
  if not onControl then exit;

  if  (button=mbLeft) and PtInRegion(rgn,x,y) then
    begin
      capture:=true;
      mouseDown:=true;
      exit;
    end;
end;

function TVSline.MouseMove(Shift: TShiftState; X, Y: smallInt):smallInt;
begin
  MouseMove:=0;
  if not onControl then exit;

  if not capture then exit;

  if not locked then
    begin
      deg.x:=XCtoDeg(x);
      deg.y:=YCtoDeg(y);
      majPos;
      MouseMove:=1;
    end;
end;

procedure TVSline.MouseUp(Button: TMouseButton;Shift: TShiftState; X, Y: smallInt);
begin
  if not onControl then exit;

  if not capture then exit;
  capture:=false;

  majpos;
end;


function TVSline.DialogForm:TclassGenForm;
begin
  DialogForm:=TlineForm;
end;


procedure TVSline.installDialog(var form:Tgenform;var newF:boolean);
var
  i:smallInt;
begin
  majPos;

  installForm(form,newF);

  TlineForm(Form).onScreenD:=SetOnScreen;
  TlineForm(Form).onControlD:=SetonControl;
  TlineForm(Form).onlockD:=setLocked;
  TlineForm(Form).majpos:=majpos;

  with TlineForm(Form) do
  begin
    enX.setVar(deg.x,T_single);
    enX.Decimal:=2;
    sbX.setParams(roundL(deg.x*100),-roundL(degXmax*100),roundL(degXmax*100));

    enY.setVar(deg.y,T_single);
    enY.Decimal:=2;
    sbY.setParams(roundL(deg.y*100),-roundL(degYmax*100),roundL(degYmax*100));

    enTheta.setVar(deg.theta,T_single);
    enTheta.setMinMax(-360,360);
    sbTheta.setParams(roundI(deg.theta),-360,360);

    CheckOnScreen.checked:=onScreen;
    CheckOnControl.checked:=onControl;
    CheckLocked.checked:=locked;
  end;
end;

procedure TVSline.AlignOnVisualObject(ob:TvisualObject;numO,num:smallInt);
begin

end;


{********************** Méthodes STM de TVSline ********************************}

procedure proTVSline_create(var pu:typeUO);
begin
  createPgObject('',pu,TVSline);
end;

procedure proTVSline_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TVSline);
end;

procedure proTVSline_x0(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSline(pu) do
  if deg.x<>ww then
    begin
      deg.x:=ww;
      majPos;
    end;
end;

function fonctionTVSline_x0(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TVSline(pu).deg.x;
end;

procedure proTVSline_y0(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSline(pu) do
  if deg.y<>ww then
    begin
      deg.y:=ww;
      majPos;
    end;
end;

function fonctionTVSline_y0(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TVSline(pu).deg.y;
end;


procedure proTVSline_theta(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSline(pu) do
  if deg.theta<>ww then
    begin
      deg.theta:=ww;
      majPos;
    end;
end;

function fonctionTVSline_theta(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TVSline(pu).deg.theta;
end;


Initialization
AffDebug('Initialization Stmline0',0);
registerObject(TVSline,obvis);

end.
