unit stmDetector1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,stmdef,stmObj,stmVec1,NcDef2,stmPg,debug0;


type
  Tdetector= class(typeUO)
             private
                  mode: integer;  { 1: crossings  2: Timer }

                  hhUp,hhDw:single;
                  stateUp:boolean;
                  dlInhib,dlInhib0:integer;
                  Fup,Fdw:boolean;

                  lastI:integer;             // last processed sample

                  Vsource,Vdest:Tvector;     // source and destination
                  Fdisp:boolean;             // if true, we display the new samples of dest

                  OnDetect:array of Tpg2Event;
                  FDetDelay:array of float;
                  DetDelayI:array of integer;
                  Idet:array of integer;

                  DTtimer,T0Timer: float;
                  DT,T0: integer;
                  ILastDet: integer;

                  procedure SetDetDelay(n:integer;w:float);
                  function GetDetDelay(n:integer):float;

                  procedure SetAllLengths(n:integer);
                  procedure SetSecondVars;

                  procedure updateCrossings(ind:integer);
                  procedure updateTimer(ind:integer);
             public
                  constructor create;override;
                  destructor destroy;override;

                  class function STMClassName:AnsiString;override;
                  procedure processMessage(id:integer;source:typeUO;p:pointer);override;

                  property DetDelay[n:integer]:float read getDetDelay write SetDetDelay;

                  procedure initCrossings(src,dest:Tvector;Fup1,Fdw1:boolean; h1,h2,linhib:float;yinit:float;Fdisp1:boolean);
                  procedure InitTimer(src: Tvector; DT1,T1:float);

                  procedure update(ind:integer);

                  procedure setThUp(w:float);
                  procedure setThDw(w:float);

                  procedure Reinit(x:float);

                  function getAcqChannel:integer;
                end;


procedure proTdetector_create(var pu:typeUO);pascal;
procedure proTdetector_InitCrossings(var src, dest: Tvector;Fup1,Fdw1:boolean;h1,h2,linhib:float;yinit:float;Fdisp1:boolean;var pu:typeUO);pascal;
procedure proTdetector_InitTimer(var src1: Tvector;DT1: float;var pu:typeUO);pascal;
procedure proTdetector_InitTimer_1(var src1: Tvector;DT1,T1: float;var pu:typeUO);pascal;

procedure proTdetector_Update(index: integer;var pu:typeUO);pascal;

procedure proTdetector_Reinit(x:float;var pu:typeUO);pascal;

procedure proTdetector_ThresholdUp(w:float;var pu:typeUO);pascal;
function fonctionTdetector_ThresholdUp(var pu:typeUO):float;pascal;

procedure proTdetector_ThresholdDw(w:float;var pu:typeUO);pascal;
function fonctionTdetector_ThresholdDw(var pu:typeUO):float;pascal;

procedure proTdetector_AddEvent(p:integer; w:float; var pu:typeUO);pascal;

procedure proTdetector_OnDetect(p:integer;var pu:typeUO);pascal;
function fonctionTdetector_OnDetect(var pu:typeUO):integer;pascal;

procedure proTdetector_Delay(w:float;var pu:typeUO);pascal;
function fonctionTdetector_Delay(var pu:typeUO):float;pascal;


implementation

{ Tdetector }

constructor Tdetector.create;
begin
  inherited;

end;

destructor Tdetector.destroy;
begin
  derefObjet(typeUO(Vsource));
  derefObjet(typeUO(Vdest));

  inherited;
end;

class function Tdetector.STMClassName: AnsiString;
begin
  result:='Integrator';
end;


procedure Tdetector.processMessage(id: integer; source: typeUO; p: pointer);
begin
  case id of
    UOmsg_destroy:
      begin
        if Vsource=source then
          begin
            Vsource:=nil;
            derefObjet(source);
          end;
        if Vdest=source then
          begin
            Vdest:=nil;
            derefObjet(source);
          end;
      end;
  end;
end;


procedure Tdetector.initCrossings(src, dest: Tvector;  Fup1,Fdw1:boolean;h1,h2,linhib:float;yinit:float;Fdisp1:boolean);
var
  i:integer;
begin
  mode:=1;

  Vsource:=src;
  refObjet(src);

  Vdest:=dest;
  refObjet(dest);
  Vdest.initEventList(G_longint,Vsource.Dxu);
  Vdest.Fexpand:=true;
  Vdest.invalidate;

  Fdisp:=Fdisp1;


  Fup:=Fup1;
  Fdw:=Fdw1;

  hhUp:=h1;
  hhDw:=h2;

  stateUp:=(yinit>=hhUp);

  dlinhib0:=Vsource.invConvX(lInhib)-Vsource.invConvX(0);
  dlInhib:=0;

  setSecondVars;

  lastI:=Vsource.Istart-1;
end;

procedure Tdetector.initTimer(src: Tvector; DT1,T1:float);
begin
  mode:=2;

  Vsource:=src;
  refObjet(src);

  DTtimer:=DT1;
  T0Timer:=T1;

  setSecondVars;
  lastI:=Vsource.Istart-1;
end;

procedure Tdetector.Reinit(x: float);
var
  i:integer;
begin
  lastI:=Vsource.invconvx(x);
  
  if not assigned(Vdest) then exit;

  Vdest.initEventList(G_longint,Vsource.Dxu);
  Vdest.Fexpand:=true;
  Vdest.invalidate;

  for i:=0 to high(OnDetect) do Idet[i]:=Vdest.Istart;
  

  stateUp:=(Vsource[lastI]>=hhUp);
end;


procedure Tdetector.updateCrossings(ind:integer);
var
  i:integer;
  ii:integer;
  w:single;
begin
  if not assigned(Vsource) or not assigned(Vdest) then exit;

  for ii:=lastI+1 to ind do
  begin
     w:=Vsource.data.getE(ii);

     if not stateUp then
     begin
       if w>=hhUp then
       begin
         stateUp:=true;
         if Fup and (dlInhib<=0) then
         begin
           Vdest.addToList(Vsource.convx(ii));
           dlInhib:=dlInhib0+1;
         end;
       end;
     end
     else
     begin
       if w<hhDw then
       begin
         stateUp:=false;
         if Fdw and (dlInhib<=0) then
         begin
           Vdest.addToList(Vsource.convx(ii));
           dlInhib:=dlInhib0+1;
         end;
       end;
     end;
     dec(dlinhib);

     for i:=0 to high(OnDetect) do
     with onDetect[i] do
     if valid and (Idet[i]>=Vdest.Istart) and (Idet[i]<=Vdest.Iend) and (Vsource.invconvx(Vdest[Idet[i]])=ii-DetDelayI[i]) then
     begin
       pg.executerProcedure1(ad,Idet[i]);
       if pg.LastError<>0 then finExe:=true;
       inc(Idet[i]);
     end;

     if finExe then exit;
  end;

  if Fdisp then Vdest.doImDisplay;
  lastI:=Ind;
end;

procedure Tdetector.updateTimer(ind:integer);
var
  i:integer;
  ii:integer;
  w:single;
begin
  if not assigned(Vsource) then exit;

  for ii:=lastI+1 to ind do
  begin
     if (ii>0) and (ii>=T0) and ((ii-T0) mod DT=0) then ILastDet:=ii;

     if IlastDet>0 then
     for i:=0 to high(OnDetect) do
     with onDetect[i] do
     if valid and (ii = IlastDet+DetDelayI[i]) then
     begin
       inc(Idet[i]);
       pg.executerProcedure1(ad,Idet[i]);
       if pg.LastError<>0 then finExe:=true;
     end;

     if finExe then exit;
  end;

  if Fdisp then Vdest.doImDisplay;
  lastI:=Ind;
end;

procedure Tdetector.update(ind:integer);
begin
  case mode of
    1: updateCrossings(ind);
    2: updateTimer(ind);
  end;
end;


procedure Tdetector.setThUp(w: float);
begin
  hhUp:=w;
  if assigned(Vsource) and (lastI>=Vsource.Istart) and (lastI<=Vsource.Iend) and (Vsource[lastI]>=hhUp)
    then stateUp:=true;
  { on ne provoque pas le changement d'état vers le bas }
end;

procedure Tdetector.setThDw(w: float);
begin
  hhDw:=w;
  if assigned(Vsource) and (lastI>=Vsource.Istart) and (lastI<=Vsource.Iend) and (Vsource[lastI]<hhDw)
    then stateUp:=false;
  { on ne provoque pas le changement d'état vers le haut }
end;

procedure Tdetector.SetDetDelay(n: integer; w: float);
begin
  FDetDelay[n]:=w;
  if assigned(Vsource)
    then DetDelayI[n]:=Vsource.invConvX(FDetDelay[n])-Vsource.invConvX(0);
end;

function Tdetector.GetDetDelay(n: integer): float;
begin
  if (n>=0) and (n<length(FdetDelay))
    then result:= FdetDelay[n]
    else result:=0;
end;


procedure Tdetector.SetAllLengths(n: integer);
begin
  setlength(Ondetect, n);
  OnDetect[n-1].numero:=0;

  setlength(FDetDelay, n);
  FdetDelay[n-1]:=0;

  setlength(DetDelayI, n);
  DetDelayI[n-1]:=0;

  setlength(Idet, n);
  if assigned(Vdest)
    then Idet[n-1]:=Vdest.Istart
    else Idet[n-1]:=0;
end;

procedure Tdetector.SetSecondVars;
var
  i:integer;
begin
  for i:=0 to high(OnDetect) do
    if assigned(Vsource) then DetDelayI[i]:= Vsource.invConvX(FDetDelay[i])-Vsource.invConvX(0);

  for i:=0 to high(OnDetect) do
    if assigned(Vdest)
      then Idet[i]:=Vdest.Istart
      else Idet[i]:=0;

  if assigned(Vsource) then
  begin
    DT:= Vsource.invConvX(DTtimer);
    T0:= Vsource.invConvX(T0Timer);
  end;
end;

function Tdetector.getAcqChannel: integer;
begin

end;

{*************************** Méthodes STM **************************}
procedure proTdetector_create(var pu:typeUO);
begin
  createPgObject('',pu,Tdetector);

end;


procedure proTdetector_InitCrossings(var src, dest: Tvector; Fup1,Fdw1:boolean;h1,h2,linhib:float;yinit:float;Fdisp1:boolean ;var pu:typeUO);
const
  max=10000000;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(src));
  verifierVecteurTemp(dest);


  with Tdetector(pu) do initCrossings(src,dest,Fup1,Fdw1,h1,h2,linhib,yinit,Fdisp1);
end;


procedure proTdetector_InitTimer_1(var src1: Tvector;DT1,T1: float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(src1));

  if (DT1<src1.Dxu) or (T1<0) then sortieErreur('Tdetector.InitTimer : bad parameter');

  with Tdetector(pu) do initTimer(src1,DT1,T1);
end;

procedure proTdetector_InitTimer(var src1: Tvector;DT1: float;var pu:typeUO);
begin
  proTdetector_InitTimer_1(src1 ,DT1, 0, pu);
end;



procedure proTdetector_Update(index: integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tdetector(pu).update(index);
end;


procedure proTdetector_ThresholdUp(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  Tdetector(pu).setThUp(w);
end;

function fonctionTdetector_ThresholdUp(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tdetector(pu).hhUp;
end;


procedure proTdetector_ThresholdDw(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  Tdetector(pu).setThDw(w);
end;

function fonctionTdetector_ThresholdDw(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tdetector(pu).hhDw;
end;

procedure proTdetector_OnDetect(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdetector(pu) do
  begin
    if length(OnDetect)=0 then setAllLengths(1);

    onDetect[0].setAd(p);
  end;
end;

function fonctionTdetector_OnDetect(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tdetector(pu) do
  if length(OnDetect)>0
    then result:=OnDetect[0].ad
    else result:=0;
end;

procedure proTdetector_Delay(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdetector(pu) do
  begin
    if length(OnDetect)=0 then setAllLengths(1);

    DetDelay[0]:=w;
  end;
end;

function fonctionTdetector_Delay(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tdetector(pu) do
  if length(OnDetect)>0
    then result:=Tdetector(pu).DetDelay[0]
    else result:=0;
end;

procedure proTdetector_AddEvent(p:integer; w:float; var pu:typeUO);

begin
  verifierObjet(pu);
  with Tdetector(pu) do
  begin
    setAlllengths( length(OnDetect)+1);

    onDetect[high(OnDetect)].setAd(p);
    detDelay[high(FdetDelay)]:=w;

    setSecondVars;
  end;
end;

procedure proTdetector_Reinit(x:float;var pu:typeUO);pascal;
begin
  verifierObjet(pu);
  Tdetector(pu).Reinit(x);
end;




Initialization
AffDebug('Initialization stmDetector1',0);
registerObject(Tdetector,data);

end.
