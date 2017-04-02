unit IIR1;

interface

uses util1, ipps, stmobj, ncdef2, stmPG, stmvec1, stmVecU1;

type
  TIIRfilter=
    class(typeUO)
      order: integer;
      taps:array of single;

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;
      procedure installButterworth;
      procedure initFilter(order1: integer;Vec: Tvector);
      procedure execute(srcdest: Tvector);
    end;

procedure proTIIRfilter_create(var pu:typeUO);pascal;
procedure proTIIRfilter_init(order1: integer;var vec: Tvector; var pu:typeUO);pascal;
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

procedure TIIRfilter.execute(srcdest: Tvector);
var
  bufferSize: integer;
  Buf: pointer;
  IIRstate: PippsIIRstate_32f;
  status: integer;
begin
  status := ippsIIRGetStateSize_32f(order, @bufferSize);
  Buf := ippsMalloc_8u(bufferSize);
  status := ippsIIRInit_32f(IIRState, @taps[0], order, nil, Buf);

  status := ippsIIR_32f_I(srcDest.tb, srcDest.Icount, IIRState);

  ippsFree(Buf);
  Buf:= Nil;

  status:= ippsIIRfree_32f(IIRstate);

end;

procedure TIIRfilter.initFilter(order1: integer; Vec: Tvector);
var
  i: integer;
begin
  order:= order1;
  setLength(taps,2*(order+1));

  for i:=0 to 2*(order+1)-1 do
    taps[i]:= Vec[Vec.Istart+i];
end;

procedure TIIRfilter.installButterworth;
begin

end;


procedure proTIIRfilter_create(var pu:typeUO);
begin
  createPgObject('',pu,TIIRfilter);

  with TIIRfilter(pu) do
  begin
    ; // Nothing?
  end;
end;

procedure proTIIRfilter_init(order1: integer;var vec: Tvector; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  if vec.Icount< 2*(order1+1) then sortieErreur('TIIRfilter.init : not enough values in vector');


  TIIRfilter(pu).initFilter(order1,vec);
end;

procedure proTIIRfilter_execute(var src,dest: Tvector; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(src);
  verifierVecteurTemp(dest);
  if dest<>src then
  begin
    dest.modify(g_single,src.Istart,src.Iend);
    proVcopy1(src,dest);
  end
  else
  if dest.tpNum<>g_single then sortieErreur('TIIRfilter.execute : bad NumType');
  // on accepte src=dest seulement si le type est single 

  TIIRfilter(pu).execute(dest);
end;


end.
