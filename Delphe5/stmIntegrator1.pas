unit stmIntegrator1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,stmdef,stmObj,stmVec1,NcDef2,stmPg,debug0;

type
  Tintegrator= class(typeUO)


                  buf:array of single;       // Big Buffer, for the mean
                  CtM:integer;               // its size
                  bufMa:array of single;     // Small buffer, for integration
                  CtI:integer;               // its size

                  l:integer;                 // storage index in buf
                  lma:integer;               // storage index in bufMa
                  m:single;                  // sum of buf values
                  ma:single;                 // sum of bufMa values

                  lastI:integer;             // last processed sample

                  Vsource,Vdest:Tvector;     // source and destination
                  Fdisp:boolean;             // if true, we display the new samples of dest

                  constructor create;override;
                  destructor destroy;override;

                  class function STMClassName:AnsiString;override;
                  procedure processMessage(id:integer;source:typeUO;p:pointer);override;

                  procedure init(src,dest:Tvector; ctI1,ctM1:float;yinit:float;Fdisp1:boolean);
                  procedure update(ind:integer);

                  procedure setCtM(w:float);
                  function getCtM:float;

                  procedure setCtI(w:float);
                  function getCtI:float;

                end;


procedure proTintegrator_create(var pu:typeUO);pascal;
procedure proTintegrator_Init(var src, dest: Tvector; ctI1, ctM1: float;yinit:float;Fdisp1:boolean;var pu:typeUO);pascal;
procedure proTintegrator_Update(index: integer;var pu:typeUO);pascal;

procedure proTintegrator_IntLength(w:float;var pu:typeUO);pascal;
function fonctionTintegrator_IntLength(var pu:typeUO):float;pascal;

procedure proTintegrator_MeanLength(w:float;var pu:typeUO);pascal;
function fonctionTintegrator_MeanLength(var pu:typeUO):float;pascal;


implementation

{ Tintegrator }

constructor Tintegrator.create;
begin
  inherited;

end;

destructor Tintegrator.destroy;
begin
  derefObjet(typeUO(Vsource));
  derefObjet(typeUO(Vdest));

  inherited;
end;

class function Tintegrator.STMClassName: AnsiString;
begin
  result:='Integrator';
end;


procedure Tintegrator.processMessage(id: integer; source: typeUO; p: pointer);
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


procedure Tintegrator.init(src, dest: Tvector; ctI1, ctM1: float;yinit:float;Fdisp1:boolean);
var
  i:integer;
begin
  Vsource:=src;
  refObjet(src);

  Vdest:=dest;
  refObjet(dest);
  Vdest.modify(Vdest.tpNum,0,-1);
  Vdest.Fexpand:=true;
  Vdest.invalidate;

  Fdisp:=Fdisp1;

  ctM:= round(ctM1/src.Dxu);
  setlength(buf,ctM);
  for i:=0 to high(buf) do
    buf[i]:=yinit;

  ctI:=round(ctI1/src.Dxu);
  setLength(bufMa,ctI);
  fillchar(bufMa[0],sizeof(bufMa[0])*ctI,0);
  lastI:=src.Istart-1;

  l:=0;
  m:=yinit*ctM;
  ma:=0;
  lma:=0;

end;

procedure Tintegrator.update(ind:integer);
var
  ii,k:integer;
begin
  if not assigned(Vsource) or not assigned(Vdest) then exit;

  for ii:=lastI+1 to ind do
  begin
    begin
      m:=m-buf[l];
      buf[l]:=Vsource.data.getE(ii);
      m:=m+buf[l];

      ma:=ma-bufma[lma];
      bufma[lma]:=abs(buf[l]-m /CtM);
      ma:=ma+bufma[lma];

      inc(lma);
      if lma=ctI then lma:=0;

      inc(l);
      if l=CtM then l:=0;

      for k:=Vdest.Iend+1 to ii-CtI div 2 do
        Vdest.Yvalue[k]:=ma/CtI;
    end;
  end;

  if Fdisp then Vdest.doImDisplay;
  lastI:=Ind;


end;

procedure Tintegrator.setCtI(w: float);
var
  i:integer;
begin
  CtI:=round(w/Vsource.Dxu);
  if ctI=0 then ctI:=1;

  setLength(bufMa,ctI);
  ma:=0;
  for i:=0 to ctI-1 do
  begin
    if lastI-i>=Vsource.Istart
      then bufMa[i]:=abs(Vsource[lastI-i]-m/ctM)
      else bufMa[i]:=0;
    ma:=ma+bufMa[i];
  end;
  lma:=0;

end;

procedure Tintegrator.setCtM(w: float);
var
  i:integer;
  oldMoy:float;
begin
  oldMoy:=m/ctM;

  CtM:=round(w/Vsource.Dxu);
  if ctM=0 then ctM:=1;

  setLength(buf,ctM);
  m:=0;
  for i:=0 to ctM-1 do
  begin
    if lastI-i>=Vsource.Istart
      then buf[i]:=Vsource[lastI-i]
      else buf[i]:=oldMoy;
    m:=m+buf[i];
  end;
  l:=0;
end;

function Tintegrator.getCtI: float;
begin
  if assigned(Vsource)
    then result:=ctI*Vsource.Dxu
    else result:=0;
end;

function Tintegrator.getCtM: float;
begin
  if assigned(Vsource)
    then result:=ctM*Vsource.Dxu
    else result:=0;
end;


{*************************** Méthodes STM **************************}
procedure proTintegrator_create(var pu:typeUO);
begin
  createPgObject('',pu,Tintegrator);

end;


procedure proTintegrator_Init(var src, dest: Tvector; ctI1, ctM1: float;yinit:float;Fdisp1:boolean;var pu:typeUO);
const
  max=10000000;
begin
  verifierObjet(pu);
  verifierVecteur(src);
  verifierVecteurTemp(dest);

  if (ctI1<=0) or (ctI1>max) then sortieErreur('Tintegrator : ctI out of range');
  if (ctM1<=0) or (ctM1>max) then sortieErreur('Tintegrator : ctM out of range');


  with Tintegrator(pu) do init(src,dest,ctI1,ctM1,yinit,Fdisp1);
end;

procedure proTintegrator_Update(index: integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tintegrator(pu).update(index);
end;


procedure proTintegrator_IntLength(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  if w<=0 then sortieErreur('Tdetector : IntLength must be positive');

  Tintegrator(pu).setCtI(w);
end;

function fonctionTintegrator_IntLength(var pu:typeUO):float;
begin
  verifierObjet(pu);

  result:=Tintegrator(pu).getCtI;
end;

procedure proTintegrator_MeanLength(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  if w<=0 then sortieErreur('Tdetector : MeanLength must be positive');

  Tintegrator(pu).setCtM(w);
end;

function fonctionTintegrator_MeanLength(var pu:typeUO):float;
begin
  verifierObjet(pu);

  result:=Tintegrator(pu).getCtM;
end;





Initialization
AffDebug('Initialization stmIntegrator1',0);
registerObject(Tintegrator,data);

end.
