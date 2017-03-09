unit stmSpkDetector1;

Interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,stmdef,stmObj,stmVec1,stmVecSpk1,stmdf0,NcDef2,stmPg, debug0;

type
  TSpkDetector=
           class(typeUO)
             private

                  lastI:array of array of integer;                 // last processed sample

                  Vsource:array of array of Tvector;     // source and destination

                  OnDetectSpk:Tpg2Event;
                  FDetDelay:float;

                  procedure SetDetDelay(w:float);
             public
                  constructor create;override;
                  destructor destroy;override;

                  class function STMClassName:AnsiString;override;
                  procedure processMessage(id:integer;source:typeUO;p:pointer);override;

                  property DetDelay:float read FdetDelay write SetDetDelay;

                  procedure initSpks(df:TdataFile);
                  procedure update(tt:float);


                end;


procedure proTSpkDetector_create(var pu:typeUO);pascal;
procedure proTSpkDetector_InitSpks(var df:TdataFile;var pu:typeUO);pascal;
procedure proTSpkDetector_Update(tt:float;var pu:typeUO);pascal;


procedure proTSpkDetector_OnDetectSpk(p:integer;var pu:typeUO);pascal;
function fonctionTSpkDetector_OnDetectSpk(var pu:typeUO):integer;pascal;

procedure proTSpkDetector_Delay(w:float;var pu:typeUO);pascal;
function fonctionTSpkDetector_Delay(var pu:typeUO):float;pascal;


implementation

{ TspkDetector }

constructor TspkDetector.create;
begin
  inherited;

end;

destructor TspkDetector.destroy;
var
  i,j:integer;
begin
  for i:=0 to high(Vsource) do
  for j:=0 to high(Vsource[i]) do
    derefObjet(typeUO(Vsource[i,j]));

  inherited;
end;

class function TspkDetector.STMClassName: AnsiString;
begin
  result:='SpkDetector';
end;


procedure TspkDetector.processMessage(id: integer; source: typeUO; p: pointer);
var
  i,j:integer;
begin
  case id of
    UOmsg_destroy:
      begin
        for i:=0 to high(Vsource) do
        for j:=0 to high(Vsource[i]) do
          if Vsource[i,j]=source then
          begin
            Vsource[i,j]:=nil;
            derefObjet(source);
          end;
      end;
  end;
end;


procedure TspkDetector.initSpks(df:TdataFile);
var
  i,j:integer;
begin

  for i:=0 to high(Vsource) do
  for j:=0 to high(Vsource[i]) do
    derefObjet(typeUO(Vsource[i,j]));

  if df.SpkCount>0 then
  begin
    setLength(Vsource,df.SpkCount,df.Vspk(1).VUcount);
    setlength(LastI,df.SpkCount,df.Vspk(1).VUcount);
  end
  else
  begin
    setLength(Vsource,0);
    setLength(LastI,0);
  end;

  for i:=0 to high(Vsource) do
  for j:=0 to high(Vsource[i]) do
  begin
    Vsource[i,j]:=df.Vspk(i+1).VUnit[j];
    refObjet(df.Vspk(i+1).VUnit[j]);
    LastI[i,j]:=df.Vspk(i+1).VUnit[j].Istart-1;
  end;
end;

procedure TspkDetector.update(tt:float);
var
  i,j,ii:integer;
begin
  for i:=0 to high(Vsource) do
  for j:=0 to high(Vsource[i]) do
  with Vsource[i,j] do
  begin
    for ii:=lastI[i,j]+1 to Iend do
    if Vsource[i,j][ii]+DetDelay<=tt then
    begin
      with onDetectSpk do
      if valid then
        pg.executerProcedure2I1F(ad,i+1,j,Vsource[i,j][ii]);
      lastI[i,j]:=ii;
    end
    else break;
  end;
end;



procedure TspkDetector.SetDetDelay(w: float);
begin
  FDetDelay:=w;
end;


{*************************** Méthodes STM **************************}
procedure proTspkDetector_create(var pu:typeUO);
begin
  createPgObject('',pu,TspkDetector);

end;


procedure proTspkDetector_InitSpks(var df: TdataFile ;var pu:typeUO);
begin
  verifierObjet(typeUO(df));
  verifierObjet(pu);

  with TspkDetector(pu) do initSpks(df);
end;

procedure proTspkDetector_Update(tt:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TspkDetector(pu).update(tt);
end;



procedure proTspkDetector_OnDetectSpk(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TspkDetector(pu).onDetectSpk do setAd(p);
end;

function fonctionTspkDetector_OnDetectSpk(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TspkDetector(pu).OnDetectSpk.ad;
end;

procedure proTspkDetector_Delay(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TspkDetector(pu).DetDelay:=w;
end;

function fonctionTspkDetector_Delay(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TspkDetector(pu).DetDelay;
end;


Initialization
AffDebug('Initialization stmSpkDetector1',0);
registerObject(TspkDetector,data);

end.
