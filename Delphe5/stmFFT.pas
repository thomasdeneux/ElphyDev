unit stmFFT;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Dgraphic,dtf0,debug0,
     Ncdef2,stmvec1,stmError,
     ipps,ippsOvr,ippDefs;




procedure ProFFT(var source,dest:Tvector;x1,x2:float;Nb:integer);pascal;
procedure ProFFT1(var source,module,phase:Tvector;x1,x2:float;Nb:integer);pascal;
procedure ProFFT2(var source,dest1,dest2:Tvector;x1,x2:float;Nb:integer);pascal;
procedure ProComplexFFT(var source1,source2,dest1,dest2:Tvector;x1,x2:float;
                        Nb:integer;inverse:boolean);pascal;

function GetOrder2(N:integer;var order:integer):boolean;

procedure ippsFFT(src,dest:PdoubleComp; nb:integer; fwd: boolean);overload;
procedure ippsFFT(src,dest:PsingleComp; nb:integer; fwd: boolean);overload;

procedure ippsFFTfwd(src:Psingle;dest:PsingleComp; nb:integer);overload;
procedure ippsFFTinv(src:PsingleComp;dest:Psingle; nb:integer);overload;

procedure ippsFFTfwd(src:Pdouble;dest:PdoubleComp; nb:integer);overload;
procedure ippsFFTinv(src:PdoubleComp;dest:Pdouble; nb:integer);overload;

IMPLEMENTATION

var
  E_nb:integer;
  E_nbptData:integer;
  E_source2:integer;
  E_readOnly:integer;

Function PuissanceDeDeux(n:integer):boolean;
begin
  if n=0 then
  begin
    result:= false;
    exit;
  end;

  while n mod 2=0 do n:=n div 2;
  result:=(n=1);
end;

function GetOrder2(N:integer;var order:integer):boolean;
var
  k:integer;
begin
  order:=0;
  k:=1;
  repeat
    k:=k*2;
    inc(order);
  until k>=N;

  result:=(k=N);
end;



procedure ippsFFT(src,dest:PdoubleComp; nb:integer; fwd: boolean);
var
  pFFTSpec:PIppsFFTSpec_C_64fc;
  size:integer;
  work: array of byte;
  order:integer;
begin
  if not getOrder2(nb,order) then exit;

  ippsFFTInitAlloc_C(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsFFTgetBufSize_C(pFFTspec,@size);
  setLength(work,size);

  if fwd
    then ippsFFTfwd_CtoC(src,dest,PFFTspec,@work[0])
    else ippsFFTinv_CtoC(src,dest,PFFTspec,@work[0]);

  ippsFFTfree_C(pFFTspec);
end;

procedure ippsFFT(src,dest:PsingleComp; nb:integer; fwd: boolean);
var
  pFFTSpec:PIppsFFTSpec_C_32fc;
  size:integer;
  work: array of byte;
  order:integer;
begin
  if not getOrder2(nb,order) then exit;

  ippsFFTInitAlloc_C(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsFFTgetBufSize_C(pFFTspec,@size);
  setLength(work,size);

  if fwd
    then ippsFFTfwd_CtoC(src,dest,PFFTspec,@work[0])
    else ippsFFTinv_CtoC(src,dest,PFFTspec,@work[0]);

  ippsFFTfree_C(pFFTspec);
end;

procedure ippsFFTfwd(src:Psingle;dest:PsingleComp; nb:integer);
var
  pFFTSpec:PIppsFFTSpec_C_32fc;
  Vaux:array of TsingleComp;
  i:integer;
  size:integer;
  work: array of byte;
  order:integer;
begin
  if not getOrder2(nb,order) then exit;
  setLength(Vaux,Nb);
  fillChar(Vaux[0],sizeof(TsingleComp)*Nb,0);
  for i:=0 to Nb-1 do
    Vaux[i].x:=PtabSingle(src)^[i];

  ippsFFTInitAlloc_C(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsFFTgetBufSize_C(pFFTspec,@size);
  setLength(work,size);

  ippsFFTfwd_CtoC(PsingleComp(@Vaux[0]),dest,PFFTspec,@work[0]);
  ippsFFTfree_C(pFFTspec);
end;

procedure ippsFFTfwd(src:Pdouble;dest:PdoubleComp; nb:integer);
var
  pFFTSpec:PIppsFFTSpec_C_64fc;
  Vaux:array of TdoubleComp;
  i:integer;
  size:integer;
  work: array of byte;
  order:integer;
begin
  if not getOrder2(nb,order) then exit;
  setLength(Vaux,Nb);
  fillChar(Vaux[0],sizeof(TsingleComp)*Nb,0);
  for i:=0 to Nb-1 do
    Vaux[i].x:=PtabSingle(src)^[i];

  ippsFFTInitAlloc_C(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsFFTgetBufSize_C(pFFTspec,@size);
  setLength(work,size);

  ippsFFTfwd_CtoC(PdoubleComp(@Vaux[0]),dest,pFFTspec,@work[0]);
  ippsFFTfree_C(pFFTspec);
end;

procedure ippsFFTinv(src:PsingleComp;dest:Psingle; nb:integer);
var
  pFFTSpec:PIppsFFTSpec_C_32fc;
  Vaux:array of TsingleComp;
  i:integer;
  size:integer;
  work: array of byte;
  order:integer;
begin
  if not getOrder2(nb,order) then exit;
  setLength(Vaux,Nb);
  fillChar(Vaux[0],sizeof(TsingleComp)*Nb,0);

  ippsFFTInitAlloc_C(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsFFTgetBufSize_C(pFFTspec,@size);
  setLength(work,size);

  ippsFFTfwd_CtoC(src,PsingleComp(@Vaux[0]),PFFTspec,@work[0]);
  ippsFFTfree_C(pFFTspec);

  for i:=0 to Nb-1 do
    PtabSingle(src)^[i]:=Vaux[i].x;
end;

procedure ippsFFTinv(src:PdoubleComp;dest:Pdouble; nb:integer);
var
  pFFTSpec:PIppsFFTSpec_C_64fc;
  Vaux:array of TdoubleComp;
  i:integer;
  size:integer;
  work: array of byte;
  order:integer;
begin
  if not getOrder2(nb,order) then exit;
  setLength(Vaux,Nb);
  fillChar(Vaux[0],sizeof(TdoubleComp)*Nb,0);

  ippsFFTInitAlloc_C(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsFFTgetBufSize_C(pFFTspec,@size);
  setLength(work,size);

  ippsFFTfwd_CtoC(src,PdoubleComp(@Vaux[0]),PFFTspec,@work[0]);
  ippsFFTfree_C(pFFTspec);

  for i:=0 to Nb-1 do
    PtabDouble(src)^[i]:=Vaux[i].x;
end;

procedure GFFT(source1,source2,dest1,dest2:Tvector;x1,x2:float;Nb:integer;
               mode:integer;inverse:boolean);
{ mode 0: FFT             dest1=module
       1: FFT1            dest1=module   dest2:phase
       2: FFT2            dest1=P.réelle dest2:P.im
       3: ComplexFFT      dest1=P.réelle dest2:P.im   source2=P.im
}
var
  i,j,k:integer;
  i1,i2:integer;

  z1FFT,z2FFT:array of TDoubleComp;
  ok:boolean;
  max:integer;
  ph:float;

  order:integer;
begin
  IPPStest;

  verifierVecteur(source1);
  if mode=3 then verifierVecteur(source2);

  verifierVecteur(dest1);
  if mode<>0 then verifierVecteur(dest2);

  if not GetOrder2(Nb, order)
    then sortieErreur(E_nb);

  if dest1.inf.readOnly then sortieErreur(E_readOnly);
  if not dest1.extendDim1(0,nb-1,dest1.tpnum)
    then dest1.extendDim1(1,nb,dest1.tpnum);

  if mode<>0 then
    begin
      if dest2.inf.readOnly then sortieErreur(E_readOnly);
      if not dest2.extendDim1(0,nb-1,dest2.tpnum)
        then dest2.extendDim1(1,nb,dest2.tpnum);
    end;

  i1:=source1.invconvx(x1);
  i2:=source1.invconvx(x2);
  source1.cadrageX(i1,i2);
  if mode=3 then source2.cadrageX(i1,i2);


  k:=1;
  while k*nb<i2-i1+1 do inc(k);
  if k>1 then dec(k);

  if source1.unitX='ms'
    then Dest1.Dxu:=1000/(k*source1.dxu*nb)
    else Dest1.Dxu:=1.0/(k*source1.dxu*nb);

  Dest1.x0u:=0;
  Dest1.unitX:='Hz';

  if mode<>0 then
    begin
      if source1.unitX='ms'
        then Dest2.Dxu:=1000/(k*source1.dxu*nb)
        else Dest2.Dxu:=1.0/(k*source1.dxu*nb);

      Dest2.x0u:=0;
      Dest2.unitX:='Hz';
    end;

  setLength(z1FFT,nb);
  setLength(z2FFT,nb);

  fillchar(z1fft[0],nb*8,0);

  i:=0;
  j:=i1;
  while (i<nb) and (j<=i2) do
  begin
    z1FFT[i].x:=source1.Yvalue[j];
    if mode =3
      then z1FFT[i].y:=source2.Yvalue[j];

    inc(i);
    j:=j+k;
  end;



  ippsFFT(PdoubleComp(@z1FFT[0]), PdoubleComp(@z2FFT[0]), nb, true);


  max:=nb-1;
  if max>dest1.Iend-dest1.Istart then max:=dest1.Iend-dest1.Istart;

  case mode of
    0:   for i:=0 to max do
           dest1.Yvalue[dest1.Istart+i]:=sqrt( sqr(z2FFT[i].x) + sqr(z2FFT[i].y) );
    1:   for i:=0 to max do
           begin
             dest1.Yvalue[dest1.Istart+i]:=sqrt( sqr(z2FFT[i].x) + sqr(z2FFT[i].y) );
             if z2FFT[i].x<>0
               then ph:=arcTan(z2FFT[i].y/z2FFT[i].x)
               else ph:=pi/2;
               if z2FFT[i].x<0 then ph:=ph+pi;
               dest2.Yvalue[i]:=ph;
           end;
     2,3:for i:=0 to max do
           begin
             dest1.Yvalue[dest1.Istart+i]:=z2FFT[i].x;
             dest2.Yvalue[dest1.Istart+i]:=z2FFT[i].y;
           end;
  end;

  IPPSend;
end;



procedure ProFFT(var source,dest:Tvector;x1,x2:float;Nb:integer);
begin
  GFFT(source,nil,dest,nil,x1,x2,nb,0,false);
end;

procedure ProFFT1(var source,module,phase:Tvector;x1,x2:float;Nb:integer);
begin
  GFFT(source,nil,module,phase,x1,x2,nb,1,false);
end;

procedure ProFFT2(var source,dest1,dest2:Tvector;x1,x2:float;Nb:integer);
begin
  GFFT(source,nil,dest1,dest2,x1,x2,nb,2,false);
end;

procedure ProComplexFFT(var source1,source2,dest1,dest2:Tvector;x1,x2:float;
                        Nb:integer;inverse:boolean);
begin
  GFFT(source1,source2,dest1,dest2,x1,x2,nb,3,inverse);
end;


Initialization
AffDebug('Initialization stmFFT',0);

installError(E_nb,'FFT: count must be a power of 2');
installError(E_nbptData,'FFT: not enough data points');
installError(E_source2,'FFT: source2 parameters does not match source1 parameters ');


end.
