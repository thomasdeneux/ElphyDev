unit IIR1;

interface

uses util1, ippDefs17, ipps17, stmobj, ncdef2, stmPG, stmvec1, stmVecU1;

type
  TIIRfilter=
    class(typeUO)
      order: integer;
      FilterType: integer;
      f0: double;
      Ripple: double;
      BackAndForth: boolean;
      HighPass: boolean;

      taps:array[0..31] of double;

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;

      procedure initFilter(order1: integer;BF:boolean;Vec: Tvector);
      procedure installButterworth(HighP: boolean; order1: integer; BF:boolean; Fcut: float);
      procedure installChebyshev(HighP: boolean; order1: integer; BF:boolean; Fcut, Rip: float);
      procedure ActivateGenFilter(src: Tvector);

      procedure execute32f(src,dest: Tvector);
      procedure execute64f(src,dest: Tvector);
      procedure execute32f_BF(src,dest: Tvector);
      procedure execute64f_BF(src,dest: Tvector);

      procedure execute(src,dest: Tvector);

      procedure check(status,step: integer);
    end;

procedure proTIIRfilter_create(var pu:typeUO);pascal;

procedure proTIIRfilter_installUserFilter(order1: integer;BF: boolean; var vec: Tvector; var pu:typeUO);pascal;
procedure proTIIRfilter_installButterworth(HighP: boolean; order1: integer; BF:boolean; Fcut: float; var pu:typeUO);pascal;
procedure proTIIRfilter_installChebyshev(HighP: boolean; order1: integer; BF:boolean; Fcut, Rip: float; var pu:typeUO);pascal;

procedure proTIIRfilter_execute(var src,dest: Tvector; var pu:typeUO);pascal;


implementation

{ TIIRfilter }

constructor TIIRfilter.create;
begin
  inherited;

end;

destructor TIIRfilter.destroy;
begin

  inherited;
end;


class function TIIRfilter.stmClassName: AnsiString;
begin
  result:='IIRfilter';
end;



procedure TIIRfilter.execute32f(src, dest: Tvector);
var
  bufferSize: integer;
  Buf: pointer;
  IIRstate: PippsIIRstate64f_32f;
begin
  check( ippsIIRGetStateSize64f_32f(order, @bufferSize) ,1);
  Buf := ippsMalloc_8u(bufferSize);
  try
    check( ippsIIRInit64f_32f(IIRState, @taps[0], order, nil, Buf) ,2);
    check( ippsIIR64f_32f(src.tb, dest.tb, src.Icount, IIRState), 3);
  finally
    ippsFree(Buf);
  end;
end;


procedure TIIRfilter.execute32f_BF(src, dest: Tvector);
var
  bufferSize: integer;
  Buf: pointer;
  IIRstate: PippsIIRstate64f_32f;
begin
  check(ippsIIRIIRGetStateSize64f_32f(order, @bufferSize),1);
  Buf := ippsMalloc_8u(bufferSize);
  try
    check( ippsIIRIIRInit64f_32f(IIRState, @taps[0], order, nil, Buf),2);
    check( ippsIIRIIR64f_32f(src.tb, dest.tb, src.Icount, IIRState),3);
  finally
    ippsFree(Buf);
  end;;
end;


procedure TIIRfilter.execute64f(src, dest: Tvector);
var
  bufferSize: integer;
  Buf: pointer;
  IIRstate: PippsIIRstate_64f;
begin
  check( ippsIIRGetStateSize_64f(order, @bufferSize),1);
  Buf := ippsMalloc_8u(bufferSize);
  try
    check( ippsIIRInit_64f(IIRState, @taps[0], order, nil, Buf),2);
    check( ippsIIR_64f(src.tb, dest.tb, src.Icount, IIRState),3);
  finally
    ippsFree(Buf);
  end;;
end;

procedure TIIRfilter.execute64f_BF(src, dest: Tvector);
var
  bufferSize: integer;
  Buf: pointer;
  IIRstate: PippsIIRstate_64f;
  status: integer;
begin
  check( ippsIIRIIRGetStateSize_64f(order, @bufferSize),1);
  Buf := ippsMalloc_8u(bufferSize);
  try
    check( ippsIIRIIRInit_64f(IIRState, @taps[0], order, nil, Buf),2);
    check( ippsIIRIIR_64f(src.tb, dest.tb, src.Icount, IIRState),3);
  finally
    ippsFree(Buf);
  end;
end;


procedure TIIRfilter.execute(src,dest: Tvector);
begin
  ActivateGenFilter(src);

  if BackAndForth then
    case src.tpNum of
      g_single: execute32f_BF(src,dest);
      g_double: execute64f_BF(src,dest);
    end
  else
    case src.tpNum of
      g_single: execute32f(src,dest);
      g_double: execute64f(src,dest);
    end;
end;


procedure TIIRfilter.ActivateGenFilter(src: Tvector);
var
  bufferSize: integer;
  Buf: pointer;
  ft: IppsIIRFilterType;
  cutoff, rip: double;

begin
  case FilterType of
    1: ft:= ippButterworth;
    2: ft:= ippChebyshev1;
    else exit;
  end;

  cutoff:= f0 *src.dxu;
  if Fmaj(src.unitX)='MS' then cutoff:= cutoff/1000;

  Rip:= Ripple;     // Pas de modif ?

  bufferSize:=1000;
  check( ippsIIRGenGetBufferSize( order, @bufferSize),11);
  Buf:= ippsMalloc_8u(bufferSize);
  try
    if HighPass
      then check( ippsIIRGenHighpass_64f( cutoff, Rip, order, @Taps, ft, buf),12)
      else check( ippsIIRGenLowpass_64f( cutoff, Rip, order, @Taps, ft, buf),12);
  finally
    ippsFree(buf);
  end;
end;


procedure TIIRfilter.initFilter(order1: integer; BF: boolean; Vec: Tvector);
var
  i: integer;
begin
  FilterType:=0;
  order:= order1;
  BackAndForth:= BF;

  for i:=0 to 2*(order+1)-1 do
    taps[i]:= Vec[Vec.Istart+i];
end;

procedure TIIRfilter.installButterworth(HighP: boolean; order1: integer; BF: boolean; Fcut: float);
begin
  FilterType:=1;
  HighPass:= HighP;
  order:= order1;
  BackAndForth:= BF;

  f0:= Fcut;
end;

procedure TIIRfilter.installChebyshev(HighP: boolean; order1: integer; BF: boolean; Fcut, Rip: float);
begin
  FilterType:=2;
  HighPass:= HighP;
  order:= order1;
  BackAndForth:= BF;

  f0:= Fcut;
  Ripple:= Rip;
end;


procedure proTIIRfilter_create(var pu:typeUO);
begin
  createPgObject('',pu,TIIRfilter);

  with TIIRfilter(pu) do
  begin
    ; // Nothing?
  end;
end;

procedure proTIIRfilter_installUserFilter(order1: integer;BF: boolean; var vec: Tvector; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  if vec.Icount< 2*(order1+1) then sortieErreur('TIIRfilter.init : not enough values in vector');


  TIIRfilter(pu).initFilter(order1,BF,vec);
end;

procedure proTIIRfilter_installButterworth(HighP: boolean; order1: integer; BF:boolean; Fcut: float; var pu:typeUO);
begin
  verifierObjet(pu);

  TIIRfilter(pu).installButterworth(HighP, order1, BF, Fcut);
end;

procedure proTIIRfilter_installChebyshev(HighP: boolean; order1: integer; BF:boolean; Fcut, Rip: float; var pu:typeUO);
begin
  verifierObjet(pu);

  TIIRfilter(pu).installChebyshev(HighP, order1, BF, Fcut, Rip);
end;



procedure proTIIRfilter_execute(var src,dest: Tvector; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(src);
  verifierVecteurTemp(dest);
  refuseSrcEqDest(src,dest);

  if not (src.tpNum in [g_single, g_double]) then sortieErreur('TIIRfilter.execute : bad data type');

  dest.modify(src.tpNum,src.Istart,src.Iend);
  VcopyXscale(src,dest);

  TIIRfilter(pu).execute(src, dest);
end;


procedure TIIRfilter.check(status,step: integer);
begin
  if status<>0 then sortieErreur('IIRfilter error '+Istr(status)+' step '+Istr(step));
end;

end.
