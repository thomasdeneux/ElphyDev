unit StmmvtX1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows,classes,graphics,controls,forms,

     util1,Dgraphic,Gdos,dtf0,
     Ncdef2,Daffmat,Dpalette,
     Stmdef,stmObj,Dprocess,stmObv0,StmStmX0,
     getOn0,getTr2,getRev1,selRF1,
     stmMat1,stmOdat2,
     editCont,defForm,
     varconf1,syspal32,
     debug0,
     stmPg;


type
  TonOff=    class(Tstim)
                constructor create;override;
                class function STMClassName:AnsiString;override;

                procedure initObvis;override;
                procedure doneMvt;override;

                function dialogForm:TclassGenForm;override;
                procedure installDialog(var form:Tgenform;var newF:boolean);
                            override;

                procedure completeDialog(var form:Tgenform);override;

                function getInfo:AnsiString;override;
             end;

  Ttrans=    class(TonOff)

                x0,y0:single;           { Coo initiales à t=t0 en DV}
                v0,theta0:single;       { v0 en DV/sec}
                                        { theta0 en degrés }

                initPos,orthogonal,BnForth:boolean;

                xf,yf:single;
                xa,ya:array[1..2] of integer;
                thetaA:float;
                rgn:array[1..2] of hRgn;
                NumCap:integer;
                dxMouse,dyMouse:integer;

                constructor create;override;
                class function STMClassName:AnsiString;override;


                procedure InitMvt; override;
                procedure calculeMvt; override;

                function dialogForm:TclassGenForm;override;
                procedure installDialog(var form:Tgenform;var newF:boolean);
                            override;

                procedure creerRegions;override;     {appelé par afficheC}
                procedure detruireRegions;override;  {appelé par effaceC}

                procedure affc1;
                procedure afficheC;override;

                procedure calculePos;

                function MouseDown(Button: TMouseButton;
                            Shift: TShiftState; X, Y: smallInt):boolean;override;
                     {renvoie true si l'objet est capturé}
                function MouseMove(Shift: TShiftState;
                                X, Y: smallInt):smallInt; override;
                     {renvoie:  0 si non concerné
                                1 si la position est modifiée
                                2 si la taille est modifiée }

                procedure MouseUp(Button: TMouseButton;
                            Shift: TShiftState; X, Y: smallInt);override;

                procedure ShowHandles;override;

                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;

                function getInfo:AnsiString;override;
              end;


type
  TRotation=  class(Ttrans)
                constructor create;override;
                class function STMClassName:AnsiString;override;


                procedure calculeMvt; override;

              end;



procedure proTonOff_create(var pu:typeUO);pascal;
procedure proTonOff_create_1(name:AnsiString;var pu:typeUO);pascal;

procedure proTonOff_CycleCount(ww:integer;var pu:typeUO);pascal;
function fonctionTonOff_CycleCount(var pu:typeUO):integer;pascal;
procedure proTonOff_dtON(ww:float;var pu:typeUO);pascal;
function fonctionTonOff_dtON(var pu:typeUO):float;pascal;

procedure proTonOff_dtOff(ww:float;var pu:typeUO);pascal;
function fonctionTonOff_dtOff(var pu:typeUO):float;pascal;

procedure proTonOff_Pause(ww:float;var pu:typeUO);pascal;
function fonctionTonOff_Pause(var pu:typeUO):float;pascal;


procedure proTtranslation_create(var pu:typeUO);pascal;
procedure proTtranslation_create_1(name:AnsiString;var pu:typeUO);pascal;

procedure proTtranslation_x0(ww:float;var pu:typeUO);pascal;
function fonctionTtranslation_x0(var pu:typeUO):float;pascal;

procedure proTtranslation_y0(ww:float;var pu:typeUO);pascal;
function fonctionTtranslation_y0(var pu:typeUO):float;pascal;

procedure proTtranslation_v0(ww:float;var pu:typeUO);pascal;
function fonctionTtranslation_v0(var pu:typeUO):float;pascal;

procedure proTtranslation_theta0(ww:float;var pu:typeUO);  pascal;
function fonctionTtranslation_theta0(var pu:typeUO):float; pascal;

procedure proTtranslation_orthogonal(ww:boolean;var pu:typeUO);  pascal;
function fonctionTtranslation_orthogonal(var pu:typeUO):boolean; pascal;

procedure proTtranslation_KeepInitialPos(ww:boolean;var pu:typeUO);  pascal;
function fonctionTtranslation_KeepInitialPos(var pu:typeUO):boolean; pascal;

procedure proTtranslation_BackAndForth(ww:boolean;var pu:typeUO);  pascal;
function fonctionTtranslation_BackAndForth(var pu:typeUO):boolean; pascal;


procedure proTtranslation_setParam(v0a,theta0a:float;x0a,y0a:float;var pu:typeUO);pascal;


IMPLEMENTATION

{*********************   Méthodes de TonOff  ************************}


constructor TonOff.create;
begin
  inherited create;
end;

class function TonOff.STMClassName:AnsiString;
begin
  STMClassName:='OnOff';
end;

procedure TonOff.initObvis;
begin
  if assigned(obvis) then obvis.prepareS;
  inherited;
end;

procedure TonOff.doneMvt;
begin
end;

function TonOff.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetOnOff1;
end;

procedure TonOff.installDialog(var form:Tgenform;var newF:boolean);
  begin
    installForm(form,newF);

    with TgetOnOff1(form) do
    begin
      enDelay.setVar(timeMan.tOrg,T_longInt);
      enDelay.setMinMax(0,maxEntierLong);
      enDelay.Dxu:=Tfreq/1E6;

      enDtON.setVar(timeMan.dtON,T_longInt);
      enDtON.setMinMax(0,maxEntierLong);
      enDtON.Dxu:=Tfreq/1E6;

      enDtOff.setVar(timeMan.dtOff,T_longInt);
      enDtOff.setMinMax(0,maxEntierLong);
      enDtOff.Dxu:=Tfreq/1E6;

      enCycleCount.setVar(timeMan.nbCycle,T_longInt);
      enCycleCount.setMinMax(0,maxEntierLong);

      initCBvisual(self,typeUO(obvis));
    end;
  end;

procedure TonOff.completeDialog(var form:Tgenform);
begin
  with TgetOnOff1(form) do cbVisual.itemIndex:=0;;
end;


function TonOff.getInfo:AnsiString;
begin
  result:=inherited getInfo;
  if obvis=nil
    then result:=result+'obvis=nil'+CRLF
    else result:=result+'obvis='+obvis.ident+CRLF;
  with timeMan do
  result:=result+
          'tOrg=   '+Jgauche(Istr(tOrg),5) +'   ==>'+Estr1(tOrg*Tfreq/1E6,12,6)+' sec'+CRLF+
          'DtOn=   '+Jgauche(Istr(DtOn),5) +'   ==>'+Estr1(DtOn*Tfreq/1E6,12,6)+' sec'+CRLF+
          'DtOff=  '+Jgauche(Istr(DtOff),5)+'   ==>'+Estr1(DtOff*Tfreq/1E6,12,6)+' sec'+CRLF+
          'Pause=  '+Jgauche(Istr(Pause),5)+'   ==>'+Estr1(Pause*Tfreq/1E6,12,6)+' sec'+CRLF+
          'Cycle count='+Istr(nbCycle);
end;

{*********************   Méthodes de Ttrans  ************************}

constructor Ttrans.create;
  begin
    inherited create;
    v0:=1;
  end;

class function Ttrans.STMClassName:AnsiString;
  begin
    STMClassName:='Translation';
  end;

procedure Ttrans.InitMvt;
  begin
    inherited;
    if initPos then
      begin
        x0:=obvis.deg.x;
        y0:=obvis.deg.y;
      end;
    if orthogonal then obvis.deg.theta:=theta0-90;

  end;

procedure Ttrans.calculeMvt;
  var
    t:double;
  begin
    if not bnForth then
      begin
        if timeS<dureeC*timeMan.nbCycle then
          begin
            obvis.deg.x:=v0*(timeS mod dureeC)*Xframe*cos(theta0*pi/180)+x0;
            obvis.deg.y:=v0*(timeS mod dureeC)*Xframe*sin(theta0*pi/180)+y0;
          end
        else
          begin
            obvis.deg.x:=v0*timeS*Xframe *cos(theta0*pi/180)+x0;
            obvis.deg.y:=v0*timeS*Xframe*sin(theta0*pi/180)+y0;
          end;
      end
    else
      begin
        t:=timeS mod dureeC;
        if (timeS div dureeC) mod 2=1 then t:=dureeC-t;
        obvis.deg.x:=v0*t*Xframe*cos(theta0*pi/180)+x0;
        obvis.deg.y:=v0*t*Xframe*sin(theta0*pi/180)+y0;
      end;
  end;

function Ttrans.dialogForm:TclassGenForm;
begin
  dialogForm:=TgetTranslation2;
end;

procedure Ttrans.installDialog(var form:Tgenform;var newF:boolean);
begin
  inherited;

  with TgetTranslation2(form) do
  begin
    enX.setVar(x0,T_single);
    enX.setMinMax(-degXmax,degXmax);
    enX.decimal:=2;
    sbX.setParams(roundL(x0*100),roundL(-degXmax*100),roundL(DegXmax*100));

    enY.setVar(y0,T_single);
    enY.setMinMax(-degXmax,degXmax);
    enY.decimal:=2;
    sbY.setParams(roundL(y0*100),roundL(-degYmax*100),roundL(DegYmax*100));

    env0.setVar(v0,T_single);
    env0.setMinMax(0,1000);
    env0.Decimal:=2;
    sbv0.setParams(roundL(v0*100),0,100000);

    enTheta0.setVar(theta0,T_single);
    enTheta0.setMinMax(-360,360);
    sbTheta0.setParams(roundI(theta0),-360,360);

    majPos:=self.majPos;
    onControlD:=SetOnControl;   {Ces procédures doivent être mises en place}
    onLockD:=setLocked;             {AVANT de modifier checked }

    CheckOnControl.checked:=onControl;
    CheckLocked.checked:=locked;

    CheckInitPos.setVar(initPos);
    CheckOrtho.setVar(orthogonal);
    CheckBNforth.setVar(BNforth);

  end;
end;

procedure tTrans.creerRegions;
var
  i:integer;
begin
  for i:=1 to 2 do
    begin
      if rgn[i]<>0 then deleteObject(rgn[i]);
      rgn[i]:=createRectRgn(xa[i]-3,ya[i]-3,xa[i]+3,ya[i]+3);
    end;
end;

procedure tTrans.detruireRegions;
var
  i:integer;
begin
  for i:=1 to 2 do
    if rgn[i]<>0 then
      begin
        deleteObject(rgn[i]);
        rgn[i]:=0;
      end;
end;

procedure tTrans.ShowHandles;
var
  i:integer;
begin
  with DXcontrol.canvas do
  begin
    pen.color:=clWhite;
    brush.color:=clWhite;
    brush.style:=bsSolid;
    for i:=1 to 2 do
         rectangle(xa[i]-2,ya[i]-2,xa[i]+2,ya[i]+2);
    brush.style:=bsClear;
  end;
end;


procedure Ttrans.affc1;
var
  i:integer;
  xh,yh,dxh,dyh:float;
begin
  with canvasGlb do
  begin
    pen.color:=clWhite;
    moveto(xa[1],ya[1]);
    lineto(xa[2],ya[2]);

    xh:=xa[2]-10*cos(thetaA*pi/180);
    yh:=ya[2]+10*sin(thetaA*pi/180);

    dxh:=-3*sin(thetaA*pi/180);
    dyh:=3*cos(thetaA*pi/180);

    lineto(roundI(xh-dxh),roundI(yh+dyh));
    lineto(roundI(xh+dxh),roundI(yh-dyh));

    lineto(xa[2],ya[2]);
  end;
end;

procedure Ttrans.afficheC;
  begin
    calculePos;
    affc1;
    creerRegions;
  end;

procedure Ttrans.calculePos;
  var
    tmax:float;
  begin
    xa[1]:=degToXC(x0);
    ya[1]:=degToYC(y0);
    thetaA:=theta0;

    with timeMan do
    begin
      tmax:=(DtOn+DtOff+pause)*Xframe;
      xf:=v0*tmax*cos(theta0*pi/180)+x0;
      xa[2]:=degToXC(xf);
      yf:=v0*tmax*sin(theta0*pi/180)+y0;
      ya[2]:=degToYC(yf);
    end;
  end;



function Ttrans.MouseDown(Button: TMouseButton;
                            Shift: TShiftState; X, Y: smallInt):boolean;
var
  i:integer;
begin
  mouseDown:=false;
  if not onControl then exit;

  if  button=mbLeft then
    begin
      for i:=1 to 2 do
      if PtInRegion(rgn[i],x,y) then
        begin
          dxMouse:=X-xa[i];
          dyMouse:=Y-ya[i];
          capture:=true;
          numCap:=i;
          mouseDown:=true;
          exit;
        end;
    end;
end;

function Ttrans.MouseMove(Shift: TShiftState; X, Y: smallInt):smallInt;
var
  d:float;
begin
  MouseMove:=0;
  if not onControl then exit;
  if not capture then exit;
  if locked then exit;

  case numcap of
    1: begin
         x0:=XCtoDeg(x-dxMouse);
         y0:=YCtoDeg(y-dyMouse);
       end;
    2: begin
         xf:=XCtoDeg(x-dxMouse);
         yf:=YCtoDeg(y-dyMouse);
       end;
  end;

  d:=sqrt(sqr(xf-x0)+sqr(yf-y0));
  with timeMan do
  begin
    DtON:=roundL(d/(v0*Xframe)-DtOff-pause);
    if DtOn<0 then
      begin
        DtOn:=0;
        capture:=false;
      end;
  end;

  theta0:=calculArg(xf-x0,yf-y0);

  majPos;
  MouseMove:=1;
end;

procedure Ttrans.MouseUp(Button: TMouseButton;Shift: TShiftState; X, Y: smallInt);
begin
  if not onControl then exit;

  if not capture then exit;
  capture:=false;

  majpos;
end;


procedure Ttrans.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    inherited;
    with conf do
    begin
      setVarConf('x0',x0,sizeof(x0));
      setVarConf('y0',y0,sizeof(y0));
      setVarConf('v0',v0,sizeof(v0));
      setVarConf('Theta0',theta0,sizeof(theta0));

      setVarConf('initPos',initPos,sizeof(initPos));
      setVarConf('Orthogonal',orthoGonal,sizeof(orthogonal));
      setVarConf('BNforth',bnForth,sizeof(bnForth));
    end;
  end;

function TTrans.getInfo:AnsiString;
begin
   result:=inherited getInfo+CRLF+
           'x0=    '+Estr1(x0,12,3)+CRLF+
           'y0=    '+Estr1(y0,12,3)+CRLF+
           'theta0='+Estr1(theta0,12,3)+CRLF+
           'InitPosition='+Bstr(InitPos)+CRLF+
           'Orthogonal=  '+Bstr(orthogonal)+CRLF+
           'BNforth=     '+Bstr(BNforth);

end;

procedure Ttrans.CompleteLoadInfo;
begin
  CheckOldIdent;
  majPos;
end;



{*********************   Méthodes de typeRotation  *************************}

constructor TRotation.create;
  begin
    inherited create;
  end;

class function Trotation.STMClassName:AnsiString;
  begin
    STMClassName:='Rotation';
  end;


procedure TRotation.calculeMvt;
  begin
    obvis.deg.theta:=v0*timeS+theta0;
  end;



{************** Méthodes STM  de TonOff *****************************}

procedure proTonOff_create(var pu:typeUO);
begin
  createPgObject('',pu,TonOff);
end;

procedure proTonOff_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TonOff);
end;

procedure proTonOff_CycleCount(ww:integer;var pu:typeUO);
begin
    verifierObjet(pu);
    TonOff(pu).TimeMan.nbCycle:=ww;
  end;

function fonctionTonOff_CycleCount(var pu:typeUO):integer;
begin
    verifierObjet(pu);
    fonctionTonOff_cycleCount:=TonOff(pu).TimeMan.nbCycle;
  end;


procedure proTonOff_dtON(ww:float;var pu:typeUO);
begin
    verifierObjet(pu);
    TonOff(pu).TimeMan.dtON:=roundL(ww/Tfreq*1E6);
  end;

function fonctionTonOff_dtON(var pu:typeUO):float;
begin
    verifierObjet(pu);
    fonctionTonOff_dtON:=TonOff(pu).TimeMan.dtON*Tfreq/1E6;
  end;


procedure proTonOff_dtOff(ww:float;var pu:typeUO);
begin
    verifierObjet(pu);
    TonOff(pu).TimeMan.dtOff:=roundL(ww/Tfreq*1E6);
  end;

function fonctionTonOff_dtOff(var pu:typeUO):float;
begin
    verifierObjet(pu);
    fonctionTonOff_dtOff:=TonOff(pu).TimeMan.dtOff*Tfreq/1E6;
end;

procedure proTonOff_Pause(ww:float;var pu:typeUO);
begin
    verifierObjet(pu);
    TonOff(pu).TimeMan.Pause:=roundL(ww/Tfreq*1E6);
  end;

function fonctionTonOff_Pause(var pu:typeUO):float;
begin
    verifierObjet(pu);
    fonctionTonOff_Pause:=TonOff(pu).TimeMan.pause*Tfreq/1E6;
  end;


{************** Méthodes STM  de Ttrans *****************************}

procedure proTtranslation_create(var pu:typeUO);
begin
  createPgObject('',pu,Ttrans);
end;

procedure proTtranslation_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,Ttrans);
end;


procedure proTtranslation_x0(ww:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Ttrans(pu).x0:=ww;
  end;

function fonctionTtranslation_x0(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTtranslation_x0:=Ttrans(pu).x0;
  end;

procedure proTtranslation_y0(ww:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Ttrans(pu).y0:=ww;
  end;

function fonctionTtranslation_y0(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTtranslation_y0:=Ttrans(pu).y0;
  end;

procedure proTtranslation_v0(ww:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Ttrans(pu).v0:=ww;
  end;

function fonctionTtranslation_v0(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTtranslation_v0:=Ttrans(pu).v0;
  end;

procedure proTtranslation_theta0(ww:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Ttrans(pu).theta0:=ww;
  end;

function fonctionTtranslation_theta0(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTtranslation_theta0:=Ttrans(pu).theta0;
  end;

procedure proTtranslation_orthogonal(ww:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    Ttrans(pu).orthogonal:=ww;
  end;


function fonctionTtranslation_orthogonal(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    fonctionTtranslation_orthogonal:=Ttrans(pu).orthogonal;
  end;


procedure proTtranslation_KeepInitialPos(ww:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    Ttrans(pu).InitPos:=ww;
  end;

function fonctionTtranslation_KeepInitialPos(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    fonctionTtranslation_KeepInitialPos:=Ttrans(pu).InitPos;
  end;


procedure proTtranslation_BackAndForth(ww:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    Ttrans(pu).BnForth:=ww;
  end;

function fonctionTtranslation_BackAndForth(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    fonctionTtranslation_BackAndForth:=Ttrans(pu).BnForth;
  end;




procedure proTtranslation_setParam(v0a,theta0a:float;x0a,y0a:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Ttrans(pu) do
    begin
      v0:=v0a;
      theta0:=theta0a;
      x0:=x0a;
      y0:=y0a;
    end;
  end;



Initialization
AffDebug('Initialization StmmvtX1',0);

if TestUnic then
begin
  registerObject(TonOff,stim);
  registerObject(Ttrans,stim);
  registerObject(Trotation,stim);
end;

end.
