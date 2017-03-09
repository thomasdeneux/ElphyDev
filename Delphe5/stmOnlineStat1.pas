unit stmOnlineStat1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,stmdef,stmObj,stmVec1,NcDef2,stmPg,debug0,
     ippdefs,ipps,ippsovr ;

type
  TonlineStat= class(typeUO)

                  Xbuf:array of single;        // buffer circulaire
                  N:integer;                   // Number of samples in this buffer

                  l:integer;                   // storage index in buf
                  Sx:float;                    // sum of buf values
                  Sx2:float;                   // sum of sqr(values)

                  lastI:integer;               // last processed sample

                  Vsource:Tvector;             // source and destination

                  constructor create;override;
                  destructor destroy;override;

                  class function STMClassName:AnsiString;override;
                  procedure processMessage(id:integer;source:typeUO;p:pointer);override;

                  procedure init(src:Tvector; len1:float);
                  procedure update(ind:integer);

                  function getMean:float;
                  function getStdDev:float;
                  function getMin:float;
                  function getMax:float;
                end;


procedure proTonlineStat_create(var pu:typeUO);pascal;
procedure proTonlineStat_Init(var src: Tvector; len1: float;var pu:typeUO);pascal;
procedure proTonlineStat_Update(index: integer;var pu:typeUO);pascal;

function fonctionTonlineStat_Mean(var pu:typeUO):float;pascal;
function fonctionTonlineStat_StdDev(var pu:typeUO):float;pascal;
function fonctionTonlineStat_Min(var pu:typeUO):float;pascal;
function fonctionTonlineStat_Max(var pu:typeUO):float;pascal;



implementation

{ TonlineStat }

constructor TonlineStat.create;
begin
  inherited;

end;

destructor TonlineStat.destroy;
begin
  derefObjet(typeUO(Vsource));
  inherited;
end;

class function TonlineStat.STMClassName: AnsiString;
begin
  result:='OnlineStat';
end;


procedure TonlineStat.processMessage(id: integer; source: typeUO; p: pointer);
begin
  case id of
    UOmsg_destroy:
      begin
        if Vsource=source then
          begin
            Vsource:=nil;
            derefObjet(source);
          end;
      end;
  end;
end;


procedure TonlineStat.init(src: Tvector; len1: float);
var
  i:integer;
begin
  Vsource:=src;
  refObjet(src);

  N:= round(len1/src.Dxu);
  setlength(Xbuf,N);
  fillchar(Xbuf[0],4*N,0);

  lastI:=src.Istart-1;

  l:=0;
  Sx:=0;
  Sx2:=0;
end;

procedure TonlineStat.update(ind:integer);
var
  ii,k:integer;
  y:single;
begin
  if not assigned(Vsource)  then exit;

  for ii:=lastI+1 to ind do
  begin
    begin
      y:=Xbuf[l];
      Sx:=Sx-y;
      Sx2:=Sx2-sqr(y);

      Xbuf[l]:=Vsource.data.getE(ii);

      y:=Xbuf[l];
      Sx:=Sx+y;
      Sx2:=Sx2+sqr(y);

      inc(l);
      if l=N then l:=0;
    end;
  end;

  lastI:=Ind;
end;

function TonlineStat.getMean: float;
var
  N1:integer;
begin
  if lastI<N then N1:=lastI+1 else N1:=N;

  if N1>0
    then result:=Sx/N1
    else result:=0;
end;

function TonlineStat.getStdDev: float;
var
  N1:integer;
begin
  if lastI<N then N1:=lastI+1 else N1:=N;
  if N1>1
    then result:= sqrt((sx2-sqr(Sx)/N1)/(N1-1))
    else result:=0;
end;

function TonlineStat.getMax: float;
var
  y:single;
  N1:integer;
begin
  if lastI<N then N1:=lastI+1 else N1:=N;

  if N1>1 then
  begin
    IPPStest;
    ippsmax(Psingle(@Xbuf[0]),N1,@y);
    ippsEnd;
    result:=y;
  end
  else result:=0;
end;

function TonlineStat.getMin: float;
var
  y:single;
  N1:integer;
begin
  if lastI<N then N1:=lastI+1 else N1:=N;

  if N1>1 then
  begin
    IPPStest;
    ippsmin(Psingle(@Xbuf[0]),N1,@y);
    ippsEnd;
    result:=y;
  end
  else result:=0;
end;


{*************************** Méthodes STM **************************}
procedure proTonlineStat_create(var pu:typeUO);
begin
  createPgObject('',pu,TonlineStat);

end;


procedure proTonlineStat_Init(var src: Tvector; len1:float;var pu:typeUO);
const
  max=10000000;
begin
  verifierObjet(pu);
  verifierVecteur(src);

  if (len1<=0) or (round(len1/src.Dxu)>max) then sortieErreur('TonlineStat : len1 out of range');

  with TonlineStat(pu) do init(src,len1);
end;

procedure proTonlineStat_Update(index: integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TonlineStat(pu).update(index);
end;

function fonctionTonlineStat_Mean(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TonlineStat(pu).getMean;
end;

function fonctionTonlineStat_StdDev(var pu:typeUO):float;pascal;
begin
  verifierObjet(pu);
  result:=TonlineStat(pu).getStdDev;
end;

function fonctionTonlineStat_Min(var pu:typeUO):float;pascal;
begin
  verifierObjet(pu);
  result:=TonlineStat(pu).getMin;
end;

function fonctionTonlineStat_Max(var pu:typeUO):float;pascal;
begin
  verifierObjet(pu);
  result:=TonlineStat(pu).getMax;
end;



Initialization
AffDebug('Initialization stmOnlineStat1',0);
registerObject(TonlineStat,data);

end.
