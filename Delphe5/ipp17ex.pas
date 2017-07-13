// Doit contenir des fonctions qui facilitent la transition de ipp 7 vers ipp 2017


unit ipp17ex;
{$Z+,A+}

interface

uses util1, ippdefs17, ipps17;

procedure Conv32f(src1: pointer; nb1: integer;src2: pointer; nb2: integer; dest: pointer);
procedure Conv64f(src1: pointer; nb1: integer;src2: pointer; nb2: integer; dest: pointer);

procedure RandUniform16s(noise: Psmallint; nb: integer; mu,sigma: smallint; Seed: longword);
procedure RandUniform32f(noise: Psingle; nb: integer; mu,sigma: single; Seed: longword);
procedure RandUniform64f(noise: PDouble; nb: integer; mu,sigma: double; Seed: longword);

procedure RandGauss16s(noise: Psmallint; nb: integer; mu,sigma: smallint; Seed: longword);
procedure RandGauss32f(noise: Psingle; nb: integer; mu,sigma: single; Seed: longword);
procedure RandGauss64f(noise: PDouble; nb: integer; mu,sigma: double; Seed: longword);

procedure DFT32fc(src,dest:PsingleComp; nb:integer; fwd: boolean);
procedure DFT64fc(src,dest:PdoubleComp; nb:integer; fwd: boolean);

procedure FFT32fc(src,dest:PsingleComp; nb:integer; fwd: boolean);
procedure FFT64fc(src,dest:PdoubleComp; nb:integer; fwd: boolean);

procedure RealFFT64f(src:Pdouble;dest:PdoubleComp; nb:integer);
procedure RealFFT32f(src:Psingle;dest:PsingleComp; nb:integer);

procedure RealFFTinv64f(src:PdoubleComp;dest:Pdouble; nb:integer);
procedure RealFFTinv32f(src:PsingleComp;dest:Psingle; nb:integer);

procedure RealDFT64f(src:Pdouble;dest:PdoubleComp; nb:integer);
procedure RealDFT32f(src:Psingle;dest:PsingleComp; nb:integer);

procedure RealDFTinv64f(src:PdoubleComp;dest:Pdouble; nb:integer);
procedure RealDFTinv32f(src:PsingleComp;dest:Psingle; nb:integer);

procedure Hilbert32f(src: Psingle; nbpt: integer);

implementation

procedure Conv32f(src1: pointer; nb1: integer;src2: pointer; nb2: integer; dest: pointer);
var
  status: integer;
  bufSize:integer;
begin
  status := ippsConvolveGetBufferSize(nb1, nb2, _ipp32f, ippAlgAuto, @bufSize);
  if status =0 then updateIppsBuffer1(bufSize) ;

  status := ippsConvolve_32f(Src1, nb1, Src2, nb2, Dest,ippAlgAuto, ippsBuffer1);
end;


procedure Conv64f(src1: pointer; nb1: integer;src2: pointer; nb2: integer; dest: pointer);
var
  status: integer;
  bufSize:integer;
begin
  status := ippsConvolveGetBufferSize(nb1, nb2, _ipp64f, ippAlgAuto, @bufSize);
  if status =0 then updateIppsBuffer1(bufSize) ;

  status := ippsConvolve_64f(Src1, nb1, Src2, nb2, Dest,ippAlgAuto, ippsBuffer1);
end;


// Générer des nombres aléatoires
// Avec ces versions , on perd l'état du générateur
// Utile seulement pour un vecteur



procedure RandUniform16s(noise: Psmallint; nb: integer; mu,sigma: smallint; Seed: longword);
var
  state: pointer;
  stateSize: integer;
begin
  ippsRandUniformGetSize_16s( @StateSize);
  state:= ippsMalloc_8u(stateSize);

  ippsRandUniformInit_16s(State, mu, sigma,  seed);
  ippsRandUniform_16s(noise, nb, State);
  ippsFree(state);
end;


procedure RandUniform32f(noise: Psingle; nb: integer; mu,sigma: single; Seed: longword);
var
  state: pointer;
  stateSize: integer;
begin
  ippsRandUniformGetSize_32f( @StateSize);
  state:= ippsMalloc_8u(stateSize);

  ippsRandUniformInit_32f(State, mu, sigma,  seed);
  ippsRandUniform_32f(noise, nb, State);
  ippsFree(state);
end;


procedure RandUniform64f(noise: PDouble; nb: integer; mu,sigma: double; Seed: longword);
var
  state: pointer;
  stateSize: integer;
begin
  ippsRandUniformGetSize_64f( @StateSize);
  state:= ippsMalloc_8u(stateSize);

  ippsRandUniformInit_64f(State, mu, sigma,  seed);
  ippsRandUniform_64f(noise, nb, State);
  ippsFree(state);
end;



procedure RandGauss16s(noise: Psmallint; nb: integer; mu,sigma: smallint; Seed: longword);
var
  state: pointer;
  stateSize: integer;
begin
  ippsRandGaussGetSize_16s( @StateSize);
  state:= ippsMalloc_8u(stateSize);

  ippsRandGaussInit_16s(State, mu, sigma,  seed);
  ippsRandGauss_16s(noise, nb, State);
  ippsFree(state);
end;


procedure RandGauss32f(noise: Psingle; nb: integer; mu,sigma: single; Seed: longword);
var
  state: pointer;
  stateSize: integer;
begin
  ippsRandGaussGetSize_32f( @StateSize);
  state:= ippsMalloc_8u(stateSize);

  ippsRandGaussInit_32f(State, mu, sigma,  seed);
  ippsRandGauss_32f(noise, nb, State);
  ippsFree(state);
end;


procedure RandGauss64f(noise: PDouble; nb: integer; mu,sigma: double; Seed: longword);
var
  state: pointer;
  stateSize: integer;
begin
  ippsRandGaussGetSize_64f( @StateSize);
  state:= ippsMalloc_8u(stateSize);

  ippsRandGaussInit_64f(State, mu, sigma,  seed);
  ippsRandGauss_64f(noise, nb, State);
  ippsFree(state);
end;


procedure DFT32fc(src,dest:PsingleComp; nb:integer; fwd: boolean);
var
  SizeSpec, SizeInit, SizeBuf: integer;
  Spec,BufInit,Buf: pointer;

begin
  ippsDFTGetSize_C_32fc(nb,IPP_FFT_DIV_INV_BY_N,  ippAlgHintNone, @SizeSpec, @SizeInit, @SizeBuf);

  Spec:= ippsMalloc(SizeSpec);
  BufInit:= ippsMalloc(SizeInit);
  Buf:= ippsMalloc(sizeBuf);

  ippsDFTInit_C_32fc( nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone, Spec, BufInit) ;

  if fwd
    then ippsDFTFwd_CToC_32fc(Src, Dest, Spec, Buf)
    else ippsDFTinv_CToC_32fc(Src, Dest, Spec, Buf);

  ippsFree(Spec);
  ippsFree(BufInit);
  ippsFree(Buf);
end;


procedure DFT64fc(src,dest:PdoubleComp; nb:integer; fwd: boolean);
var
  SizeSpec, SizeInit, SizeBuf: integer;
  Spec,BufInit,Buf: pointer;

begin
  ippsDFTGetSize_C_64fc(nb,IPP_FFT_DIV_INV_BY_N,  ippAlgHintNone, @SizeSpec, @SizeInit, @SizeBuf);

  Spec:= ippsMalloc(SizeSpec);
  BufInit:= ippsMalloc(SizeInit);
  Buf:= ippsMalloc(sizeBuf);

  ippsDFTInit_C_64fc( nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone, Spec, BufInit) ;

  if fwd
    then ippsDFTFwd_CToC_64fc(Src, Dest, Spec, Buf)
    else ippsDFTinv_CToC_64fc(Src, Dest, Spec, Buf);

  ippsFree(Spec);
  ippsFree(BufInit);
  ippsFree(Buf);
end;


{ renvoie true si N est une puissance de 2
  Dans ce cas, N= 2 puissance order
}
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


procedure FFT32fc(src,dest:PsingleComp; nb:integer; fwd: boolean);
var
  pFFTSpec:PIppsFFTSpec_C_32fc;
  order:integer;
  SizeSpec, SizeInit, SizeBuf: integer;
  Spec,BufInit,Buf: pointer;

begin
  if not getorder2(nb,order) then exit;

  ippsFFTGetSize_C_32f(order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone,  @SizeSpec, @SizeInit, @SizeBuf);

  Spec:= ippsMalloc(SizeSpec);
  BufInit:= ippsMalloc(SizeInit);
  Buf:= ippsMalloc(sizeBuf);

  pFFTSpec:= nil;
  ippsFFTInit_C_32fc(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone, Spec, BufInit);
  //la valeur renvoyée de pFFTspec est en général identique à spec mais pas toujours!

  if fwd
    then ippsFFTFwd_CToC_32fc(Src, Dest, pFFTSpec, Buf)
    else ippsFFTinv_CToC_32fc(Src, Dest, pFFTSpec, Buf);

  ippsFree(Spec);
  ippsFree(BufInit);
  ippsFree(Buf);
end;


procedure FFT64fc(src,dest:PdoubleComp; nb:integer; fwd: boolean);
var
  pFFTSpec:PIppsFFTSpec_C_64fc;
  order:integer;
  SizeSpec, SizeInit, SizeBuf: integer;
  Spec,BufInit,Buf: pointer;

begin
  if not getorder2(nb,order) then exit;

  ippsFFTGetSize_C_64f(order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone,  @SizeSpec, @SizeInit, @SizeBuf);

  Spec:= ippsMalloc(SizeSpec);
  BufInit:= ippsMalloc(SizeInit);
  Buf:= ippsMalloc(sizeBuf);

  pFFTSpec:= nil;
  ippsFFTInit_C_64fc(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone, Spec, BufInit);
  //la valeur renvoyée de pFFTspec est en général identique à spec mais pas toujours!

  if fwd
    then ippsFFTFwd_CToC_64fc(Src, Dest, pFFTSpec, Buf)
    else ippsFFTinv_CToC_64fc(Src, Dest, pFFTSpec, Buf);

  ippsFree(Spec);
  ippsFree(BufInit);
  ippsFree(Buf);
end;





procedure RealFFT64f(src:Pdouble;dest:PdoubleComp; nb:integer);
var
  pFFTSpec:PIppsFFTSpec_R_64f;
  order:integer;
  SizeSpec, SizeInit, SizeBuf: integer;
  Spec,BufInit,Buf: pointer;

begin
  if not getorder2(nb,order) then exit;

  ippsFFTGetSize_R_64f(order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone,  @SizeSpec, @SizeInit, @SizeBuf);

  Spec:= ippsMalloc(SizeSpec);
  BufInit:= ippsMalloc(SizeInit);
  Buf:= ippsMalloc(sizeBuf);

  pFFTSpec:= nil;
  ippsFFTInit_R_64f(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone, Spec, BufInit);
  //la valeur renvoyée de pFFTspec est en général identique à spec mais pas toujours!
  ippsFFTFwd_RToCCS_64f(Src, Pdouble(dest), pFFTSpec, Buf );

  ippsFree(Spec);
  ippsFree(BufInit);
  ippsFree(Buf);
end;

procedure RealFFT32f(src:Psingle;dest:PsingleComp; nb:integer);
var
  pFFTSpec:PIppsFFTSpec_R_32f;
  order:integer;
  SizeSpec, SizeInit, SizeBuf: integer;
  Spec,BufInit,Buf: pointer;

begin
  if not getorder2(nb,order) then exit;

  ippsFFTGetSize_R_32f(order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone,  @SizeSpec, @SizeInit, @SizeBuf);

  Spec:= ippsMalloc(SizeSpec);
  BufInit:= ippsMalloc(SizeInit);
  Buf:= ippsMalloc(sizeBuf);

  pFFTSpec:= nil;
  ippsFFTInit_R_32f(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone, Spec, BufInit);
  //la valeur renvoyée de pFFTspec est en général identique à spec mais pas toujours!
  ippsFFTFwd_RToCCS_32f(Src, Psingle(dest), pFFTspec, Buf  );

  ippsFree(Spec);
  ippsFree(BufInit);
  ippsFree(Buf);
end;


procedure RealFFTinv64f(src:PdoubleComp;dest:Pdouble; nb:integer);
var
  pFFTSpec:PIppsFFTSpec_R_64f;
  order:integer;
  SizeSpec, SizeInit, SizeBuf: integer;
  Spec,BufInit,Buf: pointer;

begin
  if not getorder2(nb,order) then exit;

  ippsFFTGetSize_R_64f(order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone,  @SizeSpec, @SizeInit, @SizeBuf);

  Spec:= ippsMalloc(SizeSpec);
  BufInit:= ippsMalloc(SizeInit);
  Buf:= ippsMalloc(sizeBuf);

  pFFTSpec:= nil;
  ippsFFTInit_R_64f(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone, Spec, BufInit);
  ippsFFTinv_CCStoR_64f(Pdouble(src), dest, pFFTSpec, Buf );

  ippsFree(Spec);
  ippsFree(BufInit);
  ippsFree(Buf);

end;

procedure RealFFTinv32f(src:PsingleComp;dest:Psingle; nb:integer);
var
  pFFTSpec:PIppsFFTSpec_R_32f;
  order:integer;
  SizeSpec, SizeInit, SizeBuf: integer;
  Spec,BufInit,Buf: pointer;

begin
  if not getorder2(nb,order) then exit;

  ippsFFTGetSize_R_32f(order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone,  @SizeSpec, @SizeInit, @SizeBuf);

  Spec:= ippsMalloc(SizeSpec);
  BufInit:= ippsMalloc(SizeInit);
  Buf:= ippsMalloc(sizeBuf);

  pFFTSpec:= nil;
  ippsFFTInit_R_32f(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone, Spec, BufInit);
  ippsFFTinv_CCStoR_32f(Psingle(src), dest, pFFTSpec, Buf );

  ippsFree(Spec);
  ippsFree(BufInit);
  ippsFree(Buf);

end;


procedure RealDFT64f(src:Pdouble;dest:PdoubleComp; nb:integer);
var
  SizeSpec, SizeInit, SizeBuf: integer;
  Spec,BufInit,Buf: pointer;

begin
  ippsDFTGetSize_R_64f(nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone,  @SizeSpec, @SizeInit, @SizeBuf);

  Spec:= ippsMalloc(SizeSpec);
  BufInit:= ippsMalloc(SizeInit);
  Buf:= ippsMalloc(sizeBuf);

  ippsDFTInit_R_64f( nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone, Spec, BufInit);
  ippsDFTFwd_RToCCS_64f(Src, Pdouble(dest), Spec, Buf );

  ippsFree(Spec);
  ippsFree(BufInit);
  ippsFree(Buf);
end;

procedure RealDFT32f(src:Psingle;dest:PsingleComp; nb:integer);
var
  SizeSpec, SizeInit, SizeBuf: integer;
  Spec,BufInit,Buf: pointer;

begin
  ippsDFTGetSize_R_32f(nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone,  @SizeSpec, @SizeInit, @SizeBuf);

  Spec:= ippsMalloc(SizeSpec);
  BufInit:= ippsMalloc(SizeInit);
  Buf:= ippsMalloc(sizeBuf);

  ippsDFTInit_R_32f( nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone, Spec, BufInit);
  ippsDFTFwd_RToCCS_32f(Src, Psingle(dest), Spec, Buf );

  ippsFree(Spec);
  ippsFree(BufInit);
  ippsFree(Buf);
end;

procedure RealDFTinv64f(src:PdoubleComp;dest:Pdouble; nb:integer);
var
  SizeSpec, SizeInit, SizeBuf: integer;
  Spec,BufInit,Buf: pointer;

begin
  ippsDFTGetSize_R_64f(nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone,  @SizeSpec, @SizeInit, @SizeBuf);

  Spec:= ippsMalloc(SizeSpec);
  BufInit:= ippsMalloc(SizeInit);
  Buf:= ippsMalloc(sizeBuf);

  ippsDFTInit_R_64f(nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone, Spec, BufInit);
  ippsDFTinv_CCStoR_64f(Pdouble(src), dest, Spec, Buf );

  ippsFree(Spec);
  ippsFree(BufInit);
  ippsFree(Buf);
end;

procedure RealDFTinv32f(src:PsingleComp;dest:Psingle; nb:integer);
var
  SizeSpec, SizeInit, SizeBuf: integer;
  Spec,BufInit,Buf: pointer;

begin
  ippsDFTGetSize_R_32f(nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone,  @SizeSpec, @SizeInit, @SizeBuf);

  Spec:= ippsMalloc(SizeSpec);
  BufInit:= ippsMalloc(SizeInit);
  Buf:= ippsMalloc(sizeBuf);

  ippsDFTInit_R_32f(nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone, Spec, BufInit);
  ippsDFTinv_CCStoR_32f(Psingle(src), dest, Spec, Buf );

  ippsFree(Spec);
  ippsFree(BufInit);
  ippsFree(Buf);
end;


procedure Hilbert32f(src: Psingle; nbpt: integer);
var
  spec, buffer: pointer ;  { la version 64f n'existe pas! }
  sizespec, sizebuf: integer;
  status:integer;
  p2: array of TsingleComp;
begin
  setLength(p2, nbpt);

  status := ippsHilbertGetSize_32f32fc(nbpt, ippAlgHintNone, @sizeSpec, @sizeBuf);
  Spec := ippsMalloc_8u(sizeSpec);
  Buffer := ippsMalloc_8u(sizeBuf);
  status := ippsHilbertInit_32f32fc(nbpt, ippAlgHintNone, Spec, Buffer);
  status := ippsHilbert_32f32fc( src,@p2[0], Spec, Buffer);
  ippsFree(Spec);
  ippsFree(Buffer);

  ippsimag_32fc(PsingleComp(@p2[0]),src,nbpt);
end;



end.


