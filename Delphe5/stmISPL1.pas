unit stmISPL1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses math,
     util1,Dgraphic,
     ipps,ippsovr,ippdefs,
     NcDef2,
     stmDef,stmObj,stmvec1,stmMat1,stmError,debug0,
     stmFFT;

var
  E_ISPL:integer;
  E_dataTypeNotValid:integer;

  E_FirFreq:integer;
  E_FirTapsLen:integer;
  E_FirWinType:integer;
  E_power2:integer;


const
  w_hamming=1;
  w_hann=2;
  w_blackmann=3;
  w_bartlett=4;
  w_kaiser=5;

function fonctionRandUni(var vec:Tvector;Seed: integer; Low, High:float): integer;pascal;
function fonctionRandUni_1(var mat: Tmatrix;Seed: integer; Low, High:float): integer;pascal;

function fonctionRandGauss(var vec:Tvector;Seed: integer; Mean,stdDev:float): integer;pascal;
function fonctionRandGauss_1(var mat:Tmatrix;Seed: integer; Mean,stdDev:float):integer;pascal;

procedure proTriangle(var vec:Tvector;period,phase,Mag,asym:float);pascal;

procedure proWinHamming(var src,dest : Tvector);pascal;
procedure proWinHann(var src,dest : Tvector);pascal;
procedure proWinBlackMan(var src,dest : Tvector;alpha:float);pascal;
procedure proWinKaiser(var src,dest : Tvector;beta:float);pascal;
procedure proWinBartlett(var src,dest : Tvector);pascal;


procedure ippsDFT(src,dest:PdoubleComp; nb:integer; fwd: boolean);overload;
procedure ippsDFT(src,dest:PsingleComp; nb:integer; fwd: boolean);overload;
procedure ippsDFTfwd(src:Psingle;dest:PsingleComp; nb:integer);overload;
procedure ippsDFTinv(src:PsingleComp;dest:Psingle; nb:integer);overload;
procedure ippsDFTfwd(src:Pdouble;dest:PdoubleComp; nb:integer);overload;
procedure ippsDFTinv(src:PdoubleComp;dest:Pdouble; nb:integer);overload;

procedure ippsRealFFT(src:Pdouble;dest:PdoubleComp; nb:integer);overload;
procedure ippsRealFFT(src:Psingle;dest:PsingleComp; nb:integer);overload;
procedure ippsRealFFTinv(src:PdoubleComp;dest:Pdouble; nb:integer);overload;
procedure ippsRealFFTinv(src:PsingleComp;dest:Psingle; nb:integer);overload;

procedure ippsRealDFT(src:Pdouble;dest:PdoubleComp; nb:integer);overload;
procedure ippsRealDFT(src:Psingle;dest:PsingleComp; nb:integer);overload;
procedure ippsRealDFTinv(src:PdoubleComp;dest:Pdouble; nb:integer);overload;
procedure ippsRealDFTinv(src:PsingleComp;dest:Psingle; nb:integer);overload;

procedure proDFT(var src,dest : Tvector;FWD:boolean);pascal;
procedure proCFFT(var src,dest: Tvector; FWD:boolean);pascal;

procedure proRealFFT(var src,dest: Tvector; FWD:boolean);pascal;
procedure proRealDFT(var src,dest: Tvector; FWD:boolean);pascal;

procedure proConvolve(var src,hf,dest: Tvector);pascal;
procedure proCirConv(var src,hf,dest: Tvector);pascal;
procedure proConvolveGauss(var source,dest:Tvector;sig:float);pascal;


procedure proSFFT(var src:Tvector;var dest:Tmatrix;delta:float;Nfft,WM:integer);pascal;

{function fonctionPowerSpectrum(var src,dest:Tvector;x1,x2,delta:float;Nfft,WM:integer):integer;pascal;}

function fonctionPowerSpectrum(var src,dest:Tvector;x1,x2,Len,delta:float;WM:integer):integer;pascal;
function fonctionPowerSpectrum_1(var src,dest:Tvector;x1,x2,Len,delta:float;WM:integer; OneSide:boolean):integer;pascal;

function fonctionCrossSpectrum(var src1,src2,dest:Tvector;x1,x2,Len,delta:float;WM:integer):integer;pascal;
function fonctionCrossSpectrum_1(var src1,src2,dest:Tvector;x1,x2,Len,delta:float;WM:integer; OneSide: boolean):integer;pascal;

function fonctionCoherence(var src1,src2,dest:Tvector;x1,x2,Len,delta:float;WM:integer):integer;pascal;
function fonctionCoherence_1(var src1,src2,dest:Tvector;x1,x2,Len,delta:float;WM:integer; OneSide:boolean):integer;pascal;

function GetOrder2(N:integer;var order:integer):boolean;



procedure proVSample(var src:Tvector;xa1,xa2,dx:float;var dest:Tvector);pascal;
procedure proVSample_1(var src:Tvector;dx:float;var dest:Tvector);pascal;


implementation

uses stmVecU1;


function RandUniG(p:pointer;tp:typetypeG;Nb:integer;Seed: integer; Low, High:float):integer;
var
  seedL:integer;

begin
  IPPStest;
  try
    case tp of
      G_smallint:
        begin
          seedL:=round(seed);
          ippsRandUniform_Direct_16s(p, Nb, round(low), round(high), @seedL);
        end;

      G_single:
         begin
          seedL:=round(seed);
          ippsRandUniform_Direct_32f(p, Nb, low, high, @seedL);
        end;

      G_double:
        begin
          seedL:=round(seed);
          ippsRandUniform_Direct_64f(p, Nb, low, high, @seedL);
        end;

      else sortieErreur(E_dataTypeNotValid);
    end;
    result:=seedL;
  finally
    IPPSend;
  end;
end;


function fonctionRandUni(var vec:Tvector;Seed: integer; Low, High:float):integer;
var
  tb: array of single;
  i:integer;
begin
  VerifierVecteurTemp(vec);
  if vec.tpNum in [G_smallint, G_single, G_double] then result:= RandUniG(vec.tb, vec.tpNum, vec.Icount, seed, Low, high)
  else
  begin
    setLength(tb,vec.Icount);
    result:= RandUniG(@tb[0], g_single, vec.Icount, seed, Low, high);
    for i:= vec.Istart to vec.Iend do vec[i]:=tb[i-vec.Istart];
  end;

end;

function fonctionRandUni_1(var mat: Tmatrix; Seed: integer; Low, High:float):integer;
var
  tb: array of single;
  i,j:integer;
begin
  VerifierMatrice(mat);
  if mat.tpNum in [G_smallint, G_single, G_double] then result:= RandUniG(mat.tb, mat.tpNum, mat.Icount*mat.Jcount, seed, Low, high)
  else
  begin
    setLength(tb,mat.Icount*mat.Jcount);
    result:= RandUniG(@tb[0], g_single, mat.Icount*mat.Jcount, seed, Low, high);
    for i:= mat.Istart to mat.Iend do
    for j:= mat.Jstart to mat.Jend do
      mat[i,j]:=tb[ (j-mat.Jstart)+ (i-mat.Istart)*mat.Jcount];
  end;
end;

function RandGaussG( p:pointer; tp:typetypeG; nb:integer;Seed: integer ;Mean,stdDev:float):integer;
var
  seedL:integer;

begin
  IPPStest;
  try
    case tp of
      G_smallint:
        begin
          seedL:=round(seed);
          ippsRandGauss_Direct_16s(p, nb, round(mean), round(stddev), @seedL);
        end;

      G_single:
         begin
          seedL:=round(seed);
          ippsRandGauss_Direct_32f(p, nb, mean, stdDev, @seedL);
        end;

      G_double:
        begin
          seedL:=round(seed);
          ippsRandGauss_Direct_64f(p, nb, mean, stdDev, @seedL);
        end;

      else sortieErreur(E_dataTypeNotValid);
    end;
    result:=seedL;
  finally
    IPPSend;
  end;
end;

function fonctionRandGauss(var vec:Tvector;Seed: integer ;Mean,stdDev:float):integer;
var
  tb: array of single;
  i:integer;
begin
  VerifierVecteurTemp(vec);
  if vec.tpNum in [G_smallint, G_single, G_double] then result:= RandGaussG(vec.tb, vec.tpNum, vec.Icount,seed, mean, stdDev )
  else
  begin
    setLength(tb,vec.Icount);
    result:= RandGaussG(@tb[0], g_single, vec.Icount, seed, mean, stdDev);
    for i:= vec.Istart to vec.Iend do
      vec[i]:=tb[ i-vec.Istart];
  end;
end;

function fonctionRandGauss_1(var mat:Tmatrix;Seed: integer ;Mean,stdDev:float):integer;
var
  tb: array of single;
  i,j: integer;
begin
  VerifierMatrice(mat);
  if mat.tpNum in [G_smallint, G_single, G_double] then result:= RandGaussG(mat.tb, mat.tpNum, mat.Icount*mat.Jcount, seed, mean, stdDev )
  else
  begin
    setLength(tb,mat.Icount*mat.Jcount);
    result:= RandGaussG(@tb[0], g_single, mat.Icount*mat.Jcount, seed, mean, stdDev);
    for i:= mat.Istart to mat.Iend do
    for j:= mat.Jstart to mat.Jend do
      mat[i,j]:=tb[ (j-mat.Jstart)+ (i-mat.Istart)*mat.Jcount];
  end;
end;


var
  E_Triangle1:integer;
  E_Triangle2:integer;

procedure proTriangle(var vec:Tvector;period,phase,Mag,asym:float);
var
  Rfreq:single;
  phaseS: single;
  phaseD: double;
begin
  VerifierVecteurTemp(vec);
  if period< 2*vec.dxu then sortieErreur( E_Triangle1);
  if mag<=0 then sortieErreur( E_Triangle2);

  Rfreq:=1/(period/vec.Dxu);
  phase:=frac(phase/(2*pi)) *2*pi;
  if phase<0 then phase:=phase+2*pi;
  asym:=frac(asym/pi);

  IPPStest;
  try

    case vec.tpNum of
      G_smallint:
        begin
          phaseS:=phase;
          ippsTriangle_Direct(Psmallint(vec.tb),vec.Icount,round(mag),rFreq,asym, @PhaseS);
        end;

      G_single:
        begin
          phaseS:=phase;
          ippsTriangle_Direct(vec.tbS,vec.Icount,mag,rFreq,asym, @PhaseS);
        end;

      G_double:
        begin
          phaseD:=phase;
          ippsTriangle_Direct(vec.tbD,vec.Icount,mag,rFreq,asym, @PhaseD);
        end;

      G_singleComp:
        begin
          phaseS:=phase;
          ippsTriangle_Direct(vec.tbSC,vec.Icount,mag,rFreq,asym, @PhaseS);
        end;

      G_doubleComp:
        begin
          phaseD:=phase;
          ippsTriangle_Direct(vec.tbDC,vec.Icount,mag,rFreq,asym, @PhaseD);
        end;

      else sortieErreur(E_dataTypeNotValid);
    end;
  finally
    IPPSend;
  end;
end;



procedure proWinHamming(var src,dest : Tvector);
begin
  IPPStest;
  try
    VerifierVecteurTemp(src);
    VerifierVecteurTemp(dest);
    controleVsourceVdest(src,dest,src.tpNum);

    if src=dest then
     case src.tpNum of
      G_smallint:    ippsWinHamming(Psmallint(src.tb),src.Icount);
      G_single:      ippsWinHamming(src.tbS,src.Icount);
      G_double:      ippsWinHamming(src.tbD,src.Icount);
      G_singleComp:  ippsWinHamming(src.tbSC,src.Icount);
      G_doubleComp:  ippsWinHamming(src.tbDC,src.Icount);

      else sortieErreur(E_dataTypeNotValid);
    end

    else
    case src.tpNum of
      G_smallint: ippsWinHamming(Psmallint(src.tb),Psmallint(dest.tb),src.Icount);
      G_single:  ippsWinHamming(src.tbS,dest.tbS,src.Icount);
      G_double:  ippsWinHamming(src.tbD,dest.tbD,src.Icount);
      G_singleComp:  ippsWinHamming(src.tbSC,dest.tbSC,src.Icount);
      G_doubleComp:  ippsWinHamming(src.tbDC,dest.tbDC,src.Icount);

      else sortieErreur(E_dataTypeNotValid);
    end;
  finally
    IPPSend;
  end;
end;

procedure proWinHann(var src,dest : Tvector);
begin
  IPPStest;
  try
    VerifierVecteurTemp(src);
    VerifierVecteurTemp(dest);
    controleVsourceVdest(src,dest,src.tpNum);

    if src=dest then
     case src.tpNum of
      G_smallint:    ippsWinHann(Psmallint(src.tb),src.Icount);
      G_single:      ippsWinHann(src.tbS,src.Icount);
      G_double:      ippsWinHann(src.tbD,src.Icount);
      G_singleComp:  ippsWinHann(src.tbSC,src.Icount);
      G_doubleComp:  ippsWinHann(src.tbDC,src.Icount);

      else sortieErreur(E_dataTypeNotValid);
    end

    else
    case src.tpNum of
      G_smallint: ippsWinHann(Psmallint(src.tb),Psmallint(dest.tb),src.Icount);
      G_single:  ippsWinHann(src.tbS,dest.tbS,src.Icount);
      G_double:  ippsWinHann(src.tbD,dest.tbD,src.Icount);
      G_singleComp:  ippsWinHann(src.tbSC,dest.tbSC,src.Icount);
      G_doubleComp:  ippsWinHann(src.tbDC,dest.tbDC,src.Icount);

      else sortieErreur(E_dataTypeNotValid);
    end;
  finally
    IPPSend;
  end;
end;

procedure proWinBlackMan(var src,dest : Tvector;alpha:float);
begin
  IPPStest;
  try
    VerifierVecteurTemp(src);
    VerifierVecteurTemp(dest);
    controleVsourceVdest(src,dest,src.tpNum);

    if src=dest then
     case src.tpNum of
      G_smallint:    ippsWinBlackMan(Psmallint(src.tb),src.Icount,alpha);
      G_single:      ippsWinBlackMan(src.tbS,src.Icount, alpha);
      G_double:      ippsWinBlackMan(src.tbD,src.Icount, alpha);
      G_singleComp:  ippsWinBlackMan(src.tbSC,src.Icount, alpha);
      G_doubleComp:  ippsWinBlackMan(src.tbDC,src.Icount, alpha);

      else sortieErreur(E_dataTypeNotValid);
    end

    else
    case src.tpNum of
      G_smallint: ippsWinBlackMan(Psmallint(src.tb),Psmallint(dest.tb),src.Icount, alpha);
      G_single:  ippsWinBlackMan(src.tbS,dest.tbS,src.Icount, alpha);
      G_double:  ippsWinBlackMan(src.tbD,dest.tbD,src.Icount, alpha);
      G_singleComp:  ippsWinBlackMan(src.tbSC,dest.tbSC,src.Icount, alpha);
      G_doubleComp:  ippsWinBlackMan(src.tbDC,dest.tbDC,src.Icount, alpha);

      else sortieErreur(E_dataTypeNotValid);
    end;
  finally
    IPPSend;
  end;
end;

procedure proWinKaiser(var src,dest : Tvector;beta:float);
begin
  IPPStest;
  try
    VerifierVecteurTemp(src);
    VerifierVecteurTemp(dest);
    controleVsourceVdest(src,dest,src.tpNum);

    if src=dest then
     case src.tpNum of
      G_smallint:    ippsWinKaiser(Psmallint(src.tb),src.Icount, beta);
      G_single:      ippsWinKaiser(src.tbS,src.Icount, beta);
      G_double:      ippsWinKaiser(src.tbD,src.Icount, beta);
      G_singleComp:  ippsWinKaiser(src.tbSC,src.Icount, beta);
      G_doubleComp:  ippsWinKaiser(src.tbDC,src.Icount, beta);

      else sortieErreur(E_dataTypeNotValid);
    end

    else
    case src.tpNum of
      G_smallint: ippsWinKaiser(Psmallint(src.tb),Psmallint(dest.tb),src.Icount, beta);
      G_single:  ippsWinKaiser(src.tbS,dest.tbS,src.Icount, beta);
      G_double:  ippsWinKaiser(src.tbD,dest.tbD,src.Icount, beta);
      G_singleComp:  ippsWinKaiser(src.tbSC,dest.tbSC,src.Icount, beta);
      G_doubleComp:  ippsWinKaiser(src.tbDC,dest.tbDC,src.Icount, beta);

      else sortieErreur(E_dataTypeNotValid);
    end;
  finally
    IPPSend;
  end;
end;

procedure proWinBartlett(var src,dest : Tvector);
begin
  IPPStest;
  try
    VerifierVecteurTemp(src);
    VerifierVecteurTemp(dest);
    controleVsourceVdest(src,dest,src.tpNum);

    if src=dest then
     case src.tpNum of
      G_smallint:    ippsWinBartlett(Psmallint(src.tb),src.Icount);
      G_single:      ippsWinBartlett(src.tbS,src.Icount);
      G_double:      ippsWinBartlett(src.tbD,src.Icount);
      G_singleComp:  ippsWinBartlett(src.tbSC,src.Icount);
      G_doubleComp:  ippsWinBartlett(src.tbDC,src.Icount);

      else sortieErreur(E_dataTypeNotValid);
    end

    else
    case src.tpNum of
      G_smallint: ippsWinBartlett(Psmallint(src.tb),Psmallint(dest.tb),src.Icount);
      G_single:  ippsWinBartlett(src.tbS,dest.tbS,src.Icount);
      G_double:  ippsWinBartlett(src.tbD,dest.tbD,src.Icount);
      G_singleComp:  ippsWinBartlett(src.tbSC,dest.tbSC,src.Icount);
      G_doubleComp:  ippsWinBartlett(src.tbDC,dest.tbDC,src.Icount);

      else sortieErreur(E_dataTypeNotValid);
    end;
  finally
    IPPSend;
  end;
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


procedure ippsDFT(src,dest:PdoubleComp; nb:integer; fwd: boolean);
var
  pFFTSpec:PippsDFTSpec_C_64fc;
  size:integer;
  work: array of byte;
begin
  ippsDFTInitAlloc_C(pFFTSpec, nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsDFTgetBufSize_C(pFFTspec,@size);
  setLength(work,size);

  if fwd
    then ippsDFTfwd_CtoC(src,dest,PFFTspec,@work[0])
    else ippsDFTinv_CtoC(src,dest,PFFTspec,@work[0]);

  ippsDFTfree_C(pFFTspec);
end;

procedure ippsDFT(src,dest:PsingleComp; nb:integer; fwd: boolean);
var
  pFFTSpec:PippsDFTSpec_C_32fc;
  size:integer;
  work: array of byte;
begin
  ippsDFTInitAlloc_C(pFFTSpec, nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsDFTgetBufSize_C(pFFTspec,@size);
  setLength(work,size);

  if fwd
    then ippsDFTfwd_CtoC(src,dest,PFFTspec,@work[0])
    else ippsDFTinv_CtoC(src,dest,PFFTspec,@work[0]);

  ippsDFTfree_C(pFFTspec);
end;

procedure ippsDFTfwd(src:Psingle;dest:PsingleComp; nb:integer);
var
  pFFTSpec:PippsDFTSpec_C_32fc;
  Vaux:array of TsingleComp;
  i:integer;
  size:integer;
  work: array of byte;
begin
  setLength(Vaux,Nb);
  fillChar(Vaux[0],sizeof(TsingleComp)*Nb,0);
  for i:=0 to Nb-1 do
    Vaux[i].x:=PtabSingle(src)^[i];

  ippsDFTInitAlloc_C(pFFTSpec, nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsDFTgetBufSize_C(pFFTspec,@size);
  setLength(work,size);

  ippsDFTfwd_CtoC(PsingleComp(@Vaux[0]),dest,PFFTspec,@work[0]);
  ippsDFTfree_C(pFFTspec);
end;

procedure ippsDFTfwd(src:Pdouble;dest:PdoubleComp; nb:integer);
var
  pFFTSpec:PippsDFTSpec_C_64fc;
  Vaux:array of TdoubleComp;
  i:integer;
  size:integer;
  work: array of byte;
begin
  setLength(Vaux,Nb);
  fillChar(Vaux[0],sizeof(TsingleComp)*Nb,0);
  for i:=0 to Nb-1 do
    Vaux[i].x:=PtabSingle(src)^[i];

  ippsDFTInitAlloc_C(pFFTSpec, nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsDFTgetBufSize_C(pFFTspec,@size);
  setLength(work,size);

  ippsDFTfwd_CtoC(PdoubleComp(@Vaux[0]),dest,pFFTspec,@work[0]);
  ippsDFTfree_C(pFFTspec);
end;

procedure ippsDFTinv(src:PsingleComp;dest:Psingle; nb:integer);
var
  pFFTSpec:PippsDFTSpec_C_32fc;
  Vaux:array of TsingleComp;
  i:integer;
  size:integer;
  work: array of byte;
begin
  setLength(Vaux,Nb);
  fillChar(Vaux[0],sizeof(TsingleComp)*Nb,0);

  ippsDFTInitAlloc_C(pFFTSpec, nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsDFTgetBufSize_C(pFFTspec,@size);
  setLength(work,size);

  ippsDFTfwd_CtoC(src,PsingleComp(@Vaux[0]),PFFTspec,@work[0]);
  ippsDFTfree_C(pFFTspec);

  for i:=0 to Nb-1 do
    PtabSingle(src)^[i]:=Vaux[i].x;
end;

procedure ippsDFTinv(src:PdoubleComp;dest:Pdouble; nb:integer);
var
  pFFTSpec:PippsDFTSpec_C_64fc;
  Vaux:array of TdoubleComp;
  i:integer;
  size:integer;
  work: array of byte;
begin
  setLength(Vaux,Nb);
  fillChar(Vaux[0],sizeof(TdoubleComp)*Nb,0);

  ippsDFTInitAlloc_C(pFFTSpec, nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsDFTgetBufSize_C(pFFTspec,@size);
  setLength(work,size);

  ippsDFTfwd_CtoC(src,PdoubleComp(@Vaux[0]),PFFTspec,@work[0]);
  ippsDFTfree_C(pFFTspec);

  for i:=0 to Nb-1 do
    PtabDouble(src)^[i]:=Vaux[i].x;
end;


procedure proDFT(var src,dest: Tvector; FWD:boolean);
var
  tbTempS:array of TsingleComp;
  tbTempD:array of TdoubleComp;
  i,i0,order:integer;
begin
  VerifierVecteur(src);
  VerifierVecteurTemp(dest);
  if getOrder2(src.Icount,order) then  { Pour les puissances de deux, utiliser CFFT}
    begin
      proCFFT(src,dest,FWD);
      exit;
    end;

  IPPStest;
  try                                  { Destination en G_singleComp ou G_doubleComp }
    if src.tpNum in [G_double,G_doubleComp,G_extended,G_ExtComp]
      then dest.initTemp1(0,src.Icount-1,G_doubleComp )
      else dest.initTemp1(0,src.Icount-1,G_singleComp );


    if (src.tpNum=G_singleComp) and src.inf.temp      { singleComp - singleComp }
      then ippsDFT(src.tbSC,dest.tbSC,src.Icount,fwd)
    else
    if (src.tpNum=G_doubleComp) and src.inf.temp      { doubleComp - doubleComp }
      then ippsDFT(src.tbDC,dest.tbDC,src.Icount,fwd)
    else
    if dest.tpNum=G_singleComp then                   { réel - singleComp }
    begin
      setLength(tbTempS,src.Icount);
      fillchar(tbTempS[0],length(tbTempS)*sizeof(TsingleComp),0);
      i0:=src.Istart;

      for i:=0 to high(tbTempS) do
        tbTempS[i].x:=src.Yvalue[i+i0];
      if src.isComplex then
      for i:=0 to high(tbTempS) do
        tbTempS[i].y:=src.Imvalue[i+i0];

      ippsDFT(@tbTempS[0],dest.tbSC,src.Icount,fwd);
    end
    else
    if dest.tpNum=G_doubleComp then                   { réel - doubleComp }
    begin
      setLength(tbTempD,src.Icount);
      fillchar(tbTempD[0],length(tbTempD)*sizeof(TdoubleComp),0);
      i0:=src.Istart;

      for i:=0 to high(tbTempD) do
        tbTempD[i].x:=src.Yvalue[i+i0];
      if src.isComplex then
      for i:=0 to high(tbTempD) do
        tbTempD[i].y:=src.Imvalue[i+i0];

      ippsDFT(@tbTempD[0],dest.tbDC,src.Icount,fwd);
    end;

  if FWD then
  begin
    if Fmaj(src.unitX)='MS'
      then Dest.Dxu:=1000/(src.dxu*src.Icount)
      else Dest.Dxu:=1/(src.dxu*src.Icount);

    Dest.x0u:=0;
    Dest.unitX:='Hz';
    Dest.unitY:='';
  end;
  finally
    IPPSend;
  end;
end;

procedure proCFFT(var src,dest: Tvector; FWD:boolean);
var
  tbTempS:array of TsingleComp;
  tbTempD:array of TdoubleComp;

  i,i0:integer;
  order:integer;
begin
  VerifierVecteur(src);
  VerifierVecteurTemp(dest);
  if not GetOrder2(src.Icount,order)
    then sortieErreur(E_power2);

  IPPStest;
  try                                  { Destination en G_singleComp ou G_doubleComp }
    if src.tpNum in [G_double,G_doubleComp,G_extended,G_ExtComp]
      then dest.initTemp1(0,src.Icount-1,G_doubleComp )
      else dest.initTemp1(0,src.Icount-1,G_singleComp );


    if (src.tpNum=G_singleComp) and src.inf.temp      { singleComp - singleComp }
      then ippsFFT(src.tbSC,dest.tbSC,src.Icount,fwd)
    else
    if (src.tpNum=G_doubleComp) and src.inf.temp      { doubleComp - doubleComp }
      then ippsFFT(src.tbDC,dest.tbDC,src.Icount,fwd)
    else
    if dest.tpNum=G_singleComp then                   { réel - singleComp }
    begin
      setLength(tbTempS,src.Icount);
      fillchar(tbTempS[0],length(tbTempS)*sizeof(TsingleComp),0);
      i0:=src.Istart;

      for i:=0 to high(tbTempS) do
        tbTempS[i].x:=src.Yvalue[i+i0];
      if src.isComplex then
      for i:=0 to high(tbTempS) do
        tbTempS[i].y:=src.Imvalue[i+i0];

      ippsFFT(@tbTempS[0],dest.tbSC,src.Icount,fwd);
    end
    else
    if dest.tpNum=G_doubleComp then                   { réel - doubleComp }
    begin
      setLength(tbTempD,src.Icount);
      fillchar(tbTempD[0],length(tbTempD)*sizeof(TdoubleComp),0);
      i0:=src.Istart;

      for i:=0 to high(tbTempD) do
        tbTempD[i].x:=src.Yvalue[i+i0];
      if src.isComplex then
      for i:=0 to high(tbTempD) do
        tbTempD[i].y:=src.Imvalue[i+i0];

      ippsFFT(@tbTempD[0],dest.tbDC,src.Icount,fwd);
    end;

  if FWD then
  begin
    if Fmaj(src.unitX)='MS'
      then Dest.Dxu:=1000/(src.dxu*src.Icount)
      else Dest.Dxu:=1/(src.dxu*src.Icount);

    Dest.x0u:=0;
    Dest.unitX:='Hz';
    Dest.unitY:='';
  end;
  finally
    IPPSend;
  end;
end;

{************************************************ Real FFT ******************************************}

procedure ippsRealFFT(src:Pdouble;dest:PdoubleComp; nb:integer);overload;
var
  pFFTSpec:PIppsFFTSpec_R_64f;
  size:integer;
  work: array of byte;
  order:integer;
begin
  if not getorder2(nb,order) then exit;

  ippsFFTInitAlloc_R_64f(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsFFTgetBufSize_R_64f(pFFTspec,@size);
  setLength(work,size);

  ippsFFTFwd_RToCCS_64f(Src, Pdouble(dest), pFFTSpec, @work[0]);


  ippsFFTfree_R_64f(pFFTspec);
end;

procedure ippsRealFFT(src:Psingle;dest:PsingleComp; nb:integer);overload;
var
  pFFTSpec:PIppsFFTSpec_R_32f;
  size:integer;
  work: array of byte;
  order:integer;
begin
  if not getorder2(nb,order) then exit;

  ippsFFTInitAlloc_R_32f(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsFFTgetBufSize_R_32f(pFFTspec,@size);
  setLength(work,size);

  ippsFFTFwd_RToCCS_32f(Src, Psingle(dest), pFFTSpec, @work[0]);


  ippsFFTfree_R_32f(pFFTspec);
end;

procedure ippsRealFFTinv(src:PdoubleComp;dest:Pdouble; nb:integer);overload;
var
  pFFTSpec:PIppsFFTSpec_R_64f;
  size:integer;
  work: array of byte;
  order:integer;
begin
  if not getorder2(nb,order) then exit;
  ippsFFTInitAlloc_R_64f(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsFFTgetBufSize_R_64f(pFFTspec,@size);
  setLength(work,size);

  ippsFFTinv_CCStoR_64f(Pdouble(Src), dest, pFFTSpec, @work[0]);

  ippsFFTfree_R_64f(pFFTspec);
end;

procedure ippsRealFFTinv(src:PsingleComp;dest:Psingle; nb:integer);overload;
var
  pFFTSpec:PIppsFFTSpec_R_32f;
  size:integer;
  work: array of byte;
  order:integer;
begin
  if not getorder2(nb,order) then exit;
  ippsFFTInitAlloc_R_32f(pFFTSpec, order, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsFFTgetBufSize_R_32f(pFFTspec,@size);
  setLength(work,size);

  ippsFFTinv_CCStoR_32f(Psingle(Src), dest, pFFTSpec, @work[0]);

  ippsFFTfree_R_32f(pFFTspec);
end;



procedure proRealFFT(var src,dest: Tvector; FWD:boolean);
var
  order:integer;
begin
  IPPStest;
  VerifierVecteurTemp(src);
  VerifierVecteurTemp(dest);

  TRY
    if FWD then
      begin
        case src.tpNum of
          G_single:
            begin
              if not GetOrder2(src.Icount,order)
                then sortieErreur(E_power2);
              dest.initTemp1(0,src.Icount div 2,G_singleComp);  {N div 2 +1 points }
              ippsRealFFT(src.tbS,dest.tbSC,src.Icount);
            end;

          G_double:
            begin
              if not GetOrder2(src.Icount,order)
                then sortieErreur(E_power2);
              dest.initTemp1(0,src.Icount div 2,G_doubleComp);
              ippsRealFFT(src.tbD,dest.tbDC,src.Icount);
            end;

          else sortieErreur(E_dataTypeNotValid);
        end;
      end
    else
      begin
        case src.tpNum of
          G_singleComp:
            begin
              if not GetOrder2((src.Icount-1)*2,order)
                then sortieErreur(E_power2);
              dest.initTemp1(0,(src.Icount-1)*2,G_single);
              ippsRealFFTinv(src.tbSC,dest.tbS,dest.Icount);
            end;

          G_doubleComp:
            begin
              if not GetOrder2((src.Icount-1)*2,order)
                then sortieErreur(E_power2);
              dest.initTemp1(0,(src.Icount-1)*2-1,G_double);
              ippsRealFFTinv(src.tbDC,dest.tbD,dest.Icount);
            end;

          else sortieErreur(E_dataTypeNotValid);
        end;
      end;
  FINALLY
    IPPSend;
  END;

  if FWD then
  begin
    if Fmaj(src.unitX)='MS'
      then Dest.Dxu:=1000/(src.dxu*src.Icount)
      else Dest.Dxu:=1/(src.dxu*src.Icount);

    Dest.x0u:=0;
    Dest.unitX:='Hz';
    Dest.unitY:='';
  end;

end;

{********************************************* Real DFT **********************************************}

procedure ippsRealDFT(src:Pdouble;dest:PdoubleComp; nb:integer);overload;
var
  pDFTSpec:PIppsDFTSpec_R_64f;
  size:integer;
  work: array of byte;
begin
  ippsDFTInitAlloc_R_64f(pDFTSpec, nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsDFTgetBufSize_R_64f(pDFTspec,@size);
  setLength(work,size);

  ippsDFTFwd_RToCCS_64f(Src, Pdouble(dest), pDFTSpec, @work[0]);


  ippsDFTfree_R_64f(pDFTspec);
end;

procedure ippsRealDFT(src:Psingle;dest:PsingleComp; nb:integer);overload;
var
  pDFTSpec:PIppsDFTSpec_R_32f;
  size:integer;
  work: array of byte;
begin
  ippsDFTInitAlloc_R_32f(pDFTSpec, nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsDFTgetBufSize_R_32f(pDFTspec,@size);
  setLength(work,size);

  ippsDFTFwd_RToCCS_32f(Src, Psingle(dest), pDFTSpec, @work[0]);

  ippsDFTfree_R_32f(pDFTspec);
end;

procedure ippsRealDFTinv(src:PdoubleComp;dest:Pdouble; nb:integer);overload;
var
  pDFTSpec:PIppsDFTSpec_R_64f;
  size:integer;
  work: array of byte;
begin
  ippsDFTInitAlloc_R_64f(pDFTSpec, nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsDFTgetBufSize_R_64f(pDFTspec,@size);
  setLength(work,size);

  ippsDFTinv_CCStoR_64f(Pdouble(Src), dest, pDFTSpec, @work[0]);

  ippsDFTfree_R_64f(pDFTspec);
end;

procedure ippsRealDFTinv(src:PsingleComp;dest:Psingle; nb:integer);overload;
var
  pDFTSpec:PIppsDFTSpec_R_32f;
  size:integer;
  work: array of byte;
begin
  ippsDFTInitAlloc_R_32f(pDFTSpec, nb, IPP_FFT_DIV_INV_BY_N, ippAlgHintNone);
  ippsDFTgetBufSize_R_32f(pDFTspec,@size);
  setLength(work,size);

  ippsDFTinv_CCStoR_32f(Psingle(Src), dest, pDFTSpec, @work[0]);

  ippsDFTfree_R_32f(pDFTspec);
end;



procedure proRealDFT(var src,dest: Tvector; FWD:boolean);
var
  nb:integer;
begin
  IPPStest;
  VerifierVecteurTemp(src);
  VerifierVecteurTemp(dest);

  TRY
    if FWD then
      begin
        nb:=src.Icount div 2 +1;

        case src.tpNum of
          G_single:
            begin
              dest.initTemp1(0,src.Icount div 2,G_singleComp);      { N div 2 +1 points }
              ippsRealDFT(src.tbS,dest.tbSC,(src.Icount div 2)*2);  { Si impair, on prend le nombre pair inférieur }
            end;

          G_double:
            begin
              dest.initTemp1(0,src.Icount div 2,G_doubleComp);
              ippsRealDFT(src.tbD,dest.tbDC,(src.Icount div 2)*2);
            end;

          else sortieErreur(E_dataTypeNotValid);
        end;
      end
    else
      begin
        case src.tpNum of
          G_singleComp:
            begin
              dest.initTemp1(0,(src.Icount-1)*2-1,G_single);
              ippsRealDFTinv(src.tbSC,dest.tbS,dest.Icount);
            end;

          G_doubleComp:
            begin
              dest.initTemp1(0,(src.Icount-1)*2-1,G_double);
              ippsRealDFTinv(src.tbDC,dest.tbD,dest.Icount);
            end;

          else sortieErreur(E_dataTypeNotValid);
        end;
      end;
  FINALLY
    IPPSend;
  END;

  if FWD then
  begin
    if Fmaj(src.unitX)='MS'
      then Dest.Dxu:=1000/(src.dxu*src.Icount)
      else Dest.Dxu:=1/(src.dxu*src.Icount);

    Dest.x0u:=0;
    Dest.unitX:='Hz';
    Dest.unitY:='';
  end;

end;



{********************************************* SFFT ****************************************************}

procedure proSFFT(var src:Tvector;var dest:Tmatrix;delta:float;Nfft,WM:integer);
var
  i,j,i1:integer;
  nx,ny,order,flags:integer;
  x:real;
  vec1:Tvector;
  tb:array of TSingleComp;
  x1,x2:float;
begin
  IPPStest;
  VerifierVecteur(src);
  VerifierObjet(typeUO(dest));

  x1:=src.Xstart;
  x2:=src.Xend;

  if not GetOrder2(Nfft,order)
    then sortieErreur(E_power2);

  nx:=trunc( (x2-x1-Nfft*src.Dxu)/delta);
  ny:=Nfft div 2+1;

  if nx<2 then sortieErreur(E_parametre);


  vec1:=Tvector.create;
  vec1.Dxu:=src.Dxu;
  vec1.initTemp1(0,Nfft-1,G_single);

  dest.initTemp(0,nx-1,0,ny-1,G_singleComp);
  setLength(tb,ny);

  try

    x:=x1;
    i:=0;
    repeat
      i1:=src.invconvx(x);
      vec1.copyDataFromVec(src,i1,i1+Nfft-1,0);
      case WM of
        w_bartlett:   ippsWinBartlett(vec1.tbS,vec1.Icount);
        w_blackmann:  ippsWinBlackmanOpt(vec1.tbS,vec1.Icount);
        w_hamming:    ippsWinHamming(vec1.tbS,vec1.Icount);
        w_hann:       ippsWinHann(vec1.tbS,vec1.Icount);
      end;

      ippsRealFft(vec1.tbS, @tb[0], order);

      for j:=0 to ny-1 do
        with PtabSingleComp(dest.tb)^[ny*i+j] do
        begin
          x:=tb[j].x;
          y:=tb[j].y;
        end;
      x:=x+delta;
      inc(i);
    until i>=nx;

  finally
    vec1.Free;
    IPPSend;
  end;

  if Fmaj(src.unitX)='MS'
    then Dest.Dyu:=1000/(src.dxu*NFFT)
    else Dest.Dyu:=1/(src.dxu*NFFT);
  Dest.Y0u:=0;
  Dest.unitY:='Hz';

  Dest.Dxu:=delta;
  Dest.X0u:=src.x0u;
  Dest.unitX:=src.unitX;

end;


(*
function fonctionPowerSpectrum(var src,dest:Tvector;x1,x2,delta:float;Nfft,WM:integer):integer;
var
  i,j,i1:integer;
  nx,ny,order,flags:integer;
  x:real;
  vec1:Tvector;
  tb:array of TSCplx;
begin
  IPPStest;
  VerifierVecteur(src);
  VerifierVecteur(dest);

  if not GetOrder2(Nfft,order)
    then sortieErreur(E_power2);

  nx:=trunc( (x2-x1-Nfft*src.Dxu)/delta);
  result:=nx;

  if nx<2 then sortieErreur(E_parametre);

  vec1:=Tvector.create;
  vec1.Dxu:=src.Dxu;
  vec1.initTemp1(0,Nfft,G_single);       {Nfft+1 points}

  dest.X0u:=0;

  if FsupEspace(Fmaj(src.unitX))='MS'
    then dest.Dxu:=1000/(NFFT*src.Dxu)
    else dest.Dxu:=1/(NFFT*src.Dxu);

  dest.initTemp1(0,Nfft div 2,G_single);
  setLength(tb,Nfft div 2+1);

  try
    flags:=NSP_Forw;
    x:=x1;
    i:=0;
    repeat
      i1:=src.invconvx(x);
      vec1.copyDataFromVec(src,i1,i1+Nfft-1,0);
      case WM of
        1:  nspsWinBartlett(vec1.tb,vec1.Icount);
        2:  nspsWinBlackmanOpt(vec1.tb,vec1.Icount);
        3:  nspsWinHamming(vec1.tb,vec1.Icount);
        4:  nspsWinHann(vec1.tb,vec1.Icount);
      end;

      nspsRealFftNip(vec1.tb,
                     @tb[0],
                     Order,Flags);

      for j:=0 to Nfft div 2-1 do
        PtabSingle(dest.tb)^[j]:=PtabSingle(dest.tb)^[j]+ sqr(tb[j].x)+sqr(tb[j].y);
      x:=x+delta;
      inc(i);
    until i>=nx;

  finally
    vec1.Free;
    IPPSend;
  end;
end;
*)


function LenFFT(src:Tvector;len:float):float;
var
  n,nbpt:integer;
begin
  nbpt:=round(len/src.Dxu);
  n:=1;
  while (n<nbpt) do n:=n*2;
  if n>nbpt then n:=n div 2;
  result:=src.Dxu*n;
end;


function fonctionCrossSpectrum0(var src1,src2,dest:Tvector;x1,x2,Len,delta:float;WM:integer; Const mode:integer=1):integer;
var
  i,j,i1,i2:integer;
  nx,ny,order,flags:integer;
  x:float;
  vec1,vec2:Tvector;
  tb1,tb2:array of TDoubleComp;
  nbpt, nbU:integer;

procedure incpx(var z,z1,z2:TdoubleComp);
begin
  z.x:=z.x+z1.x*z2.x+z1.y*z2.y;          { z:=z +z1*conj(z2) }
  z.y:=z.y-z1.x*z2.y+z1.y*z2.x;
end;


begin
  IPPStest;
  VerifierVecteur(src1);
  VerifierVecteur(src2);

  VerifierVecteur(dest);

  if x1<src1.Xstart then x1:= src1.Xstart;
  if x1<src2.Xstart then x1:= src2.Xstart;

  if x2>src1.Xend then x2:= src1.Xend;
  if x2>src2.Xend then x2:= src2.Xend;

  if x2-x1+src1.dxu < Len then sortieErreur('CrossSpectrum: Analyzis Length Too large');

  if (x2-x1<len+delta) then nx:=1
  else
  nx:=trunc( (x2-x1-Len)/delta);
  result:=nx;

  if nx<1 then sortieErreur(E_parametre);

  nbpt:=round(len/src1.Dxu);
  if mode=1 then nbU:=nbpt else nbU:=nbpt div 2;

  vec1:=Tvector.create;
  vec1.Dxu:=src1.Dxu;
  vec1.initTemp1(0,nbpt-1,G_doubleComp);

  vec2:=Tvector.create;
  vec2.Dxu:=src1.Dxu;
  vec2.initTemp1(0,nbpt-1,G_doubleComp);

  dest.X0u:=0;

  if FsupEspace(Fmaj(src1.unitX))='MS'
    then dest.Dxu:=1000/(nbpt*src1.Dxu)
    else dest.Dxu:=1/(Nbpt*src1.Dxu);

  dest.initTemp1(0,nbU-1,G_doubleComp);

  setLength(tb1,nbpt);
  setLength(tb2,nbpt);
  fillchar(tb1[0],nbpt*sizeof(TDoubleComp),0);
  fillchar(tb2[0],nbpt*sizeof(TDoubleComp),0);


  try
    x:=x1;
    i:=0;
    i1:=src1.invconvx(x);
    i2:=src1.invconvx(x2);

    repeat
      i1:=src1.invconvx(x);
      vec1.copyDataFromVec(src1,i1,i1+Nbpt-1,0);
      case WM of
        1:  ippsWinBartlett(vec1.tbDC,vec1.Icount);
        2:  ippsWinBlackmanOpt(vec1.tbDC,vec1.Icount);
        3:  ippsWinHamming(vec1.tbDC,vec1.Icount);
        4:  ippsWinHann(vec1.tbDC,vec1.Icount);
      end;
      ippsDft(vec1.tbDC, @tb1[0], nbpt,true);

      vec2.copyDataFromVec(src2,i1,i1+Nbpt-1,0);
      case WM of
        1:  ippsWinBartlett(vec2.tbDC,vec2.Icount);
        2:  ippsWinBlackmanOpt(vec2.tbDC,vec2.Icount);
        3:  ippsWinHamming(vec2.tbDC,vec2.Icount);
        4:  ippsWinHann(vec2.tbDC,vec2.Icount);
      end;
      ippsDft(vec2.tbDC, @tb2[0], nbpt,true);

      for j:=0 to nbU-1 do
        inCpx(PtabDoubleComp(dest.tb)^[j],tb1[j],tb2[j]);

      x:=x+delta;
      i1:=src1.invconvx(x);
      inc(i);
    {until (x+nbpt*src1.dxu>=x2) or (i>=nx+1);}
    until (i1+nbpt-1>i2);

    case mode of
      1: ippsMulC(1/i,dest.tbD,nbU*2);
      2: ippsMulC(2/i,dest.tbD,nbU*2);
    end;

    result:=i;

  finally
    vec1.Free;
    vec2.free;
    IPPSend;
  end;
end;

function fonctionCrossSpectrum(var src1,src2,dest:Tvector;x1,x2,Len,delta:float;WM:integer):integer;
begin
  result:= fonctionCrossSpectrum0( src1,src2,dest, x1,x2,Len,delta, WM);
end;

function fonctionCrossSpectrum_1(var src1,src2,dest:Tvector;x1,x2,Len,delta:float;WM:integer; OneSide:boolean):integer;
begin
  result:= fonctionCrossSpectrum0( src1,src2,dest, x1,x2,Len,delta, WM, ord(OneSide)+1);
end;




{  mode= 1 : on calcule le module de la DFT
         2 : idem  en one-sided . On multiplie le résultat par 2

}

function fonctionPowerSpectrum0(var src,dest:Tvector;x1,x2,Len,delta:float;WM:integer;const mode:integer=1):integer;
var
  i,j,i1,i2:integer;
  nx,ny,order,flags:integer;
  x:float;
  vec:Tvector;
  tb:array of TDoubleComp;
  nbpt,nbU:integer;

procedure incpx(var z:double;z1:TdoubleComp);
begin
  z:=z + sqr(z1.x)+sqr(z1.y);          { z:=z +z1*conj(z1) }
end;


begin
  IPPStest;
  VerifierVecteur(src);
  VerifierVecteur(dest);

  if (x2-x1>=len) and (x2-x1<len+delta) then nx:=1
  else
  nx:=trunc( (x2-x1-Len)/delta);
  result:=nx;

  if nx<1 then sortieErreur(E_parametre);

  nbpt:=round(len/src.Dxu);
  if mode=1 then nbU:=nbpt else nbU:=nbpt div 2;

  vec:=Tvector.create;
  vec.Dxu:=src.Dxu;
  vec.initTemp1(0,nbpt-1,G_doubleComp);

  dest.X0u:=0;

  if FsupEspace(Fmaj(src.unitX))='MS'
    then dest.Dxu:=1000/(nbpt*src.Dxu)
    else dest.Dxu:=1/(Nbpt*src.Dxu);

  dest.initTemp1(0,nbU-1,G_double);

  setLength(tb,nbpt);
  fillchar(tb[0],nbpt*sizeof(TDoubleComp),0);

  try

    x:=x1;
    i:=0;
    i1:=src.invconvx(x);
    i2:=src.invconvx(x2);
    repeat
      i1:=src.invconvx(x);
      vec.copyDataFromVec(src,i1,i1+Nbpt-1,0);
      case WM of
        1:  ippsWinBartlett(vec.tbDC,vec.Icount);
        2:  ippsWinBlackmanOpt(vec.tbDC,vec.Icount);
        3:  ippsWinHamming(vec.tbDC,vec.Icount);
        4:  ippsWinHann(vec.tbDC,vec.Icount);
      end;
      ippsDft(vec.tbDC, @tb[0], nbpt,true);

      for j:=0 to nbU-1 do
        inCpx(PtabDouble(dest.tb)^[j],tb[j]);
      x:=x+delta;
      i1:=src.invconvx(x);
      inc(i);
    until (i1+nbpt-1>i2);

    case mode of
      1: ippsMulC(1/i,dest.tbD,nbU);
      2: ippsMulC(2/i,dest.tbD,nbU);
    end;
    result:=i;

  finally
    vec.Free;
    IPPSend;
  end;
end;

function fonctionPowerSpectrum(var src,dest:Tvector;x1,x2,Len,delta:float;WM:integer):integer;
begin
  result:= fonctionPowerSpectrum0(src,dest,x1,x2,Len,delta,WM);
end;

function fonctionPowerSpectrum_1(var src,dest:Tvector;x1,x2,Len,delta:float;WM:integer; OneSide: boolean):integer;
begin
  result:= fonctionPowerSpectrum0(src,dest,x1,x2,Len,delta,WM, ord(OneSide)+1);
end;

function fonctionCoherence_1(var src1,src2,dest:Tvector;x1,x2,Len,delta:float;WM:integer; OneSide:boolean):integer;
var
  vec1,vec2,vec3:Tvector;
begin
  vec1:=Tvector.create;
  vec1.initTemp1(0,0,g_double);
  vec2:=Tvector.create;
  vec2.initTemp1(0,0,g_double);
  vec3:=Tvector.create;
  vec3.initTemp1(0,0,g_double);

  try
  result:=fonctionPowerSpectrum_1(src1,vec1,x1,x2,Len,delta,WM,OneSide);
  result:=fonctionPowerSpectrum_1(src2,vec2,x1,x2,Len,delta,WM,OneSide);
  fonctionCrossSpectrum_1(src1,src2,vec3,x1,x2,Len,delta,WM,OneSide);

  proVpower(vec3,dest);
  proVrealPart(dest,dest);

  proVdiv(dest,vec1,dest);
  proVdiv(dest,vec2,dest);

  finally
  vec1.free;
  vec2.free;
  vec3.Free;
  end;
end;

function fonctionCoherence(var src1,src2,dest:Tvector;x1,x2,Len,delta:float;WM:integer):integer;
begin
  result:= fonctionCoherence_1(src1,src2,dest,x1,x2,Len,delta,WM,false);
end;

{BH est un tableau de single
I1h et I2h sont les indices du tableau initial
I1h est négatif ou nul
}

Procedure convolveHFsingle(var src,dest:Tvector;BH:Pointer;I1H,I2H:integer);
const
  maxTb=10000;
var
  delayD:Array of single;

  tbS,tbD:array of single;

  i,j,k,w,res:integer;
  pState: PIppsFIRState_32f;
  tapsLen:integer;
  Istart,Iend:integer;
begin
  Istart:=src.Istart;
  Iend:=src.Iend;

  if src.isCpx
    then dest.initTemp1(src.Istart,src.Iend,G_singleComp)
    else dest.initTemp1(src.Istart,src.Iend,G_single);
  dest.X0u:=src.X0u;
  dest.Dxu:=src.Dxu;

  tapslen:=I2H-I1H+1;

  setLength(delayD,tapsLen);
  fillchar(delayD[0],tapsLen*4,0);

  setLength(tbS,maxtb);
  setLength(tbD,maxtb);


  ippsFIRInitAlloc_32f( pState, BH, tapsLen, @delayD[0]);

  j:=0;
  k:=Istart+I1h;
  for i:=src.Istart to src.Iend-I1h do
  begin
    if i<=Iend
      then tbS[j]:=src.data.getE(i)
      else tbS[j]:=0;
    j:=(j+1) mod maxtb;
    if j=0 then
      begin
        ippsFir_32f(@tbS[0],@tbD[0],maxTb,pState);
        for w:=0 to maxtb-1 do
          if k+w>=Istart then
            dest.data.setE(k+w,tbD[w]);
        k:=k+maxTb;
      end;
  end;

  if j>0 then
    begin
      ippsFir_32f(@tbS[0],@tbD[0],j,pState);
      for w:=0 to j-1 do
        if k+w>=Istart then
          dest.data.setE(k+w,tbD[w]);
    end;

  ippsFirFree_32f(pState);

  if src.isCpx then
  begin
    ippsFIRInitAlloc_32f( pState, BH, tapsLen, @delayD[0]);

    j:=0;
    k:=Istart+I1h;
    for i:=src.Istart to src.Iend-I1h do
    begin
      if i<=Iend
        then tbS[j]:=src.data.getIm(i)
        else tbS[j]:=0;
      j:=(j+1) mod maxtb;
      if j=0 then
        begin
          ippsFir_32f(@tbS[0],@tbD[0],maxTb,pState);
          for w:=0 to maxtb-1 do
            if k+w>=Istart then
              dest.data.setIm(k+w,tbD[w]);
          k:=k+maxTb;
        end;
    end;

    if j>0 then
      begin
        ippsFir_32f(@tbS[0],@tbD[0],j,pState);
        for w:=0 to j-1 do
          if k+w>=Istart then
            dest.data.setIm(k+w,tbD[w]);
      end;

    ippsFirFree_32f(pState);

  end;
end;


Procedure convolveHFdouble(var src,dest:Tvector;BH:Pointer;I1H,I2H:integer);
const
  maxTb=10000;
var
  delayD:Array of double;

  tbS,tbD:array of double;

  i,j,k,w,res:integer;
  pState: PIppsFIRState_64f;
  tapsLen:integer;
  Istart,Iend:integer;
begin
  Istart:=src.Istart;
  Iend:=src.Iend;

  if src.isCpx
    then dest.initTemp1(src.Istart,src.Iend,G_doubleComp)
    else dest.initTemp1(src.Istart,src.Iend,G_double);
  dest.X0u:=src.X0u;
  dest.Dxu:=src.Dxu;

  tapslen:=I2H-I1H+1;

  setLength(delayD,tapsLen);
  fillchar(delayD[0],tapsLen*4,0);

  setLength(tbS,maxtb);
  setLength(tbD,maxtb);


  ippsFIRInitAlloc_64f( pState, BH, tapsLen, @delayD[0]);

  j:=0;
  k:=Istart+I1h;
  for i:=src.Istart to src.Iend-I1h do
  begin
    if i<=Iend
      then tbS[j]:=src.data.getE(i)
      else tbS[j]:=0;
    j:=(j+1) mod maxtb;
    if j=0 then
      begin
        ippsFir_64f(@tbS[0],@tbD[0],maxTb,pState);
        for w:=0 to maxtb-1 do
          if k+w>=Istart then
            dest.data.setE(k+w,tbD[w]);
        k:=k+maxTb;
      end;
  end;

  if j>0 then
    begin
      ippsFir_64f(@tbS[0],@tbD[0],j,pState);
      for w:=0 to j-1 do
        if k+w>=Istart then
          dest.data.setE(k+w,tbD[w]);
    end;

  ippsFirFree_64f(pState);

  if src.isCpx then
  begin
    ippsFIRInitAlloc_64f( pState, BH, tapsLen, @delayD[0]);

    j:=0;
    k:=Istart+I1h;
    for i:=src.Istart to src.Iend-I1h do
    begin
      if i<=Iend
        then tbS[j]:=src.data.getIm(i)
        else tbS[j]:=0;
      j:=(j+1) mod maxtb;
      if j=0 then
        begin
          ippsFir_64f(@tbS[0],@tbD[0],maxTb,pState);
          for w:=0 to maxtb-1 do
            if k+w>=Istart then
              dest.data.setIm(k+w,tbD[w]);
          k:=k+maxTb;
        end;
    end;

    if j>0 then
      begin
        ippsFir_64f(@tbS[0],@tbD[0],j,pState);
        for w:=0 to j-1 do
          if k+w>=Istart then
            dest.data.setIm(k+w,tbD[w]);
      end;

    ippsFirFree_64f(pState);

  end;
end;


Procedure convolveHFsingleComp(var src,dest:Tvector;BH:Pointer;I1H,I2H:integer);
const
  maxTb=10000;
var
  delayD:Array of TsingleComp;

  tbS,tbD:array of TsingleComp;

  i,j,k,w,res:integer;
  pState: PIppsFIRState_32fc;
  tapsLen:integer;
  Istart,Iend:integer;
begin
  Istart:=src.Istart;
  Iend:=src.Iend;

  dest.initTemp1(src.Istart,src.Iend,G_singleComp);
  dest.X0u:=src.X0u;
  dest.Dxu:=src.Dxu;

  tapslen:=I2H-I1H+1;

  setLength(delayD,tapsLen);
  fillchar(delayD[0],tapsLen*4,0);

  setLength(tbS,maxtb);
  setLength(tbD,maxtb);


  ippsFIRInitAlloc_32fc( pState, BH, tapsLen, @delayD[0]);

  j:=0;
  k:=Istart+I1h;
  for i:=src.Istart to src.Iend-I1h do
  begin
    if i<=Iend
      then tbS[j]:=singleComp(src.Yvalue[i],src.ImValue[i])
      else tbS[j]:=singleComp(0,0);
    j:=(j+1) mod maxtb;
    if j=0 then
      begin
        ippsFir_32fc(@tbS[0],@tbD[0],maxTb,pState);
        for w:=0 to maxtb-1 do
          if k+w>=Istart then
            dest.CpxValue[k+w]:= FloatComp(tbD[w].x,tbD[w].y);
        k:=k+maxTb;
      end;
  end;

  if j>0 then
    begin
      ippsFir_32fc(@tbS[0],@tbD[0],j,pState);
      for w:=0 to j-1 do
        if k+w>=Istart then
          dest.CpxValue[k+w]:= FloatComp(tbD[w].x,tbD[w].y);
    end;

  ippsFirFree_32fc(pState);

end;


Procedure convolveHFdoubleComp(var src,dest:Tvector;BH:Pointer;I1H,I2H:integer);
const
  maxTb=10000;
var
  delayD:Array of TdoubleComp;

  tbS,tbD:array of TdoubleComp;

  i,j,k,w,res:integer;
  pState: PIppsFIRState_64fc;
  tapsLen:integer;
  Istart,Iend:integer;
begin
  Istart:=src.Istart;
  Iend:=src.Iend;

  dest.initTemp1(src.Istart,src.Iend,G_doubleComp);
  dest.X0u:=src.X0u;
  dest.Dxu:=src.Dxu;

  tapslen:=I2H-I1H+1;

  setLength(delayD,tapsLen);
  fillchar(delayD[0],tapsLen*4,0);

  setLength(tbS,maxtb);
  setLength(tbD,maxtb);


  ippsFIRInitAlloc_64fc( pState, BH, tapsLen, @delayD[0]);

  j:=0;
  k:=Istart+I1h;
  for i:=src.Istart to src.Iend-I1h do
  begin
    if i<=Iend
      then tbS[j]:=doubleComp(src.Yvalue[i],src.ImValue[i])
      else tbS[j]:=doubleComp(0,0);
    j:=(j+1) mod maxtb;
    if j=0 then
      begin
        ippsFir_64fc(@tbS[0],@tbD[0],maxTb,pState);
        for w:=0 to maxtb-1 do
          if k+w>=Istart then
            dest.CpxValue[k+w]:= FloatComp(tbD[w].x,tbD[w].y);
        k:=k+maxTb;
      end;
  end;

  if j>0 then
    begin
      ippsFir_64fc(@tbS[0],@tbD[0],j,pState);
      for w:=0 to j-1 do
        if k+w>=Istart then
          dest.CpxValue[k+w]:= FloatComp(tbD[w].x,tbD[w].y);
    end;

  ippsFirFree_64fc(pState);
end;


procedure Convolve1(var src,hf,dest: Tvector);
var
  i:integer;
  BHsingle:array of single;
  BHdouble:array of double;
  BHsingleComp: array of TSingleComp;
  BHdoubleComp: array of TdoubleComp;

begin

  case hf.tpNum of
    G_single:
      begin
        setLength(BHsingle,hf.Iend-hf.Istart+1);
        for i:=hf.Istart to hf.Iend do
          BHsingle[i-hf.Istart]:=hf.Yvalue[i];

        convolveHFsingle(src,dest,@BHsingle[0],hf.Istart,hf.Iend);
      end;
    G_double:
      begin
        setLength(BHdouble,hf.Iend-hf.Istart+1);
        for i:=hf.Istart to hf.Iend do
          BHdouble[i-hf.Istart]:=hf.Yvalue[i];

        convolveHFdouble(src,dest,@BHdouble[0],hf.Istart,hf.Iend);
      end;

    G_singleComp:
      begin
        setLength(BHsingleComp,hf.Iend-hf.Istart+1);
        for i:=hf.Istart to hf.Iend do
          BHsingleComp[i-hf.Istart]:=singleComp(hf.Yvalue[i],hf.ImValue[i]);

        convolveHFsingleComp(src,dest,@BHsingleComp[0],hf.Istart,hf.Iend);
      end;

    G_doubleComp:
      begin
        setLength(BHdoubleComp,hf.Iend-hf.Istart+1);
        for i:=hf.Istart to hf.Iend do
          BHdoubleComp[i-hf.Istart]:=doubleComp(hf.Yvalue[i],hf.ImValue[i]);

        convolveHFdoubleComp(src,dest,@BHdoubleComp[0],hf.Istart,hf.Iend);
      end;
  end;
end;

procedure proConvolve(var src,hf,dest: Tvector);
begin
  IPPStest;

  VerifierVecteur(src);
  VerifierVecteur(hf);
  VerifierVecteurTemp(dest);

 { Avec IPP , conv ne traite que single-single et double-double }

  if src.inf.temp and hf.inf.temp and (src.tpNum=G_single) and (hf.tpNum=G_single) then
  begin
    try
      dest.X0u:=src.X0u;
      dest.Dxu:=src.Dxu;

      dest.initTemp1(src.Istart,src.Iend,G_single);
      dest.ModifyTemp(dest.totSize+hf.Icount*4);
      {dest.totSize n'est pas affecté par ModifyTemp }
      ippsConv(src.tbS,src.Icount,hf.tbS,hf.Icount,dest.tbS);
      if hf.Istart<0
        then move(dest.tbSingle^[-hf.Istart],dest.tb^,dest.totSize);

    finally
      dest.restoreTemp;

      IPPSend;
    end
  end
  else
  if src.inf.temp and hf.inf.temp and (src.tpNum =G_double) and (hf.tpNum=G_double) then
  begin
    try
      dest.X0u:=src.X0u;
      dest.Dxu:=src.Dxu;

      dest.initTemp1(src.Istart,src.Iend,G_double);
      dest.ModifyTemp(dest.totSize+hf.Icount*8);
      ippsConv(src.tbD,src.Icount,hf.tbD,hf.Icount,dest.tbD);
      if hf.Istart<0
         then move(dest.tbdouble^[-hf.Istart],dest.tb^,dest.totSize);
    finally
      dest.restoreTemp;

      IPPSend;
    end;
  end

  else convolve1(src,hf,dest);
end;

var
  E_circonv:integer;
  E_circonv2:integer;


procedure proCirConv(var src,hf,dest: Tvector);
begin
  IPPStest;

  VerifierVecteurTemp(src);
  VerifierVecteur(hf);
  VerifierVecteurTemp(dest);

  if src.Icount<>Hf.Icount
    then sortieErreur(E_circonv);

  if src.Icount=0 then exit;

  if src.inf.temp and hf.inf.temp and (src.tpNum =G_single) and (hf.tpNum = G_single) then
  begin
    try
      dest.X0u:=src.X0u;
      dest.Dxu:=src.Dxu;
      src.ModifyTemp(src.totSize*2);
      move(Pbyte(src.tb)^,PtabOctet(src.tb)^[src.totSize],src.totSize);

      dest.initTemp1(src.Istart,src.Iend,G_single);
      dest.ModifyTemp(dest.totSize*3);
      ippsConv(src.tbS,src.Icount,hf.tbS,hf.Icount,dest.tbS);
    finally
      src.restoreTemp;
      dest.restoreTemp;
      IPPSend;
    end
  end
  else
  if src.inf.temp and hf.inf.temp and (src.tpNum = G_double) and (hf.tpNum = G_double) then
  begin
    try
      dest.X0u:=src.X0u;
      dest.Dxu:=src.Dxu;
      src.ModifyTemp(src.totSize*2);
      move(Pbyte(src.tb)^,PtabOctet(src.tb)^[src.totSize],src.totSize);

      dest.initTemp1(src.Istart,src.Iend,G_double);
      dest.ModifyTemp(dest.totSize*3);
      ippsConv(src.tbD,src.Icount,hf.tbD,hf.Icount,dest.tbD);

    finally
      src.restoreTemp;

      move(PtabOctet(dest.tb)^[dest.totSize],Pbyte(dest.tb)^,dest.totSize);
      dest.restoreTemp;

      IPPSend;
    end;
  end
  else sortieErreur(E_circonv2);


end;


procedure proConvolveGauss(var source,dest:Tvector;sig:float);
  var
    i:integer;
    i1,i2:longint;
    buf:array of single;
    l,isig,cte:integer;
    gmax:float;

  function f(I0:integer):float;
    var
      i,Imin,Imax:longint;
      m:float;
    begin
      if I0-cte<I1 then Imin:=I1 else Imin:=I0-cte;
      if I0+cte>I2 then Imax:=I2 else Imax:=I0+cte;
      m:=0;
      for i:=Imin to Imax do
        m:=m+source.data.getE(i)*buf[i-i0+Cte];
                                    {exp(-0.5*sqr((i-i0)/isig));}
      f:=m;
    end;

  function g(I0:longint):float;
    var
      i,Imin,Imax:longint;
      m:float;
    begin
      if I0-cte<I1 then Imin:=I1 else Imin:=I0-cte;
      if I0+cte>I2 then Imax:=I2 else Imax:=I0+cte;
      m:=0;
      for i:=Imin to Imax do
        m:=m+buf[i-i0+Cte];{ exp(-0.5*sqr((i-i0)/isig));}
      g:=m;
    end;


  begin
    IPPStest;

    verifierVecteur(source);
    verifierVecteurTemp(dest);

    isig:=source.invConvX(sig)-source.invConvX(0);

    ControleParametre(isig,1,8000);

    I1:=source.Istart;
    I2:=source.Iend;

    cte:=isig*2;
    setLength(buf,2*Cte+1);

    for i:=0 to Cte*2 do
        buf[i]:=exp(-0.5*sqr((i-Cte)/isig));

    gmax:=0;
    for i:=0 to Cte*2 do
      gmax:=gmax+buf[i];

    for i:=0 to Cte*2 do
      buf[i]:=buf[i]/gmax;

    ConvolveHFsingle(source,dest,@buf[0],-Cte,Cte);

    for i:=0 to Cte*2 do
      buf[i]:=buf[i]*gmax;

    for i:=I1 to I1+Cte*2 do
      dest.data.setE(i,f(i)/g(i));
    for i:=I2-Cte to I2 do
      dest.data.setE(i,f(i)/g(i));


    IPPSend;
  end;


procedure proVSample(var src:Tvector;xa1,xa2,dx:float;var dest:Tvector);
var
  i,n,i1,i2:integer;
  x,x1,x2,y1,y2:float;
  src1:Tvector;
begin
  verifierVecteur(src);
  verifierVecteurTemp(dest);
  if dx<=0 then sortieErreur('Vsample : dx must be positive');
  if xa1<src.Xstart then sortieErreur('Vsample : x1 out of range');
  if xa2>src.Xend then sortieErreur('Vsample : x2 out of range');

  if src=dest
    then src1:=Tvector(src.clone(true))
    else src1:=src;

  TRY
  n:=trunc((xa2-xa1)/dx)+1;

  dest.modify(dest.tpNum,0,n-1);

  dest.Dxu:=dx;

  if dx<src1.dxu then       // sur-échantillonnage
  begin
    dest.X0u:=xa1;

    for i:=0 to n-1 do
    with src1 do
    begin
      x:=dx*i+xa1;
      i1:=Istart+floor((x-Xstart)/dxu);
      i2:=i1+1;
      x1:=convx(i1);
      x2:=convx(i2);
      y1:=Yvalue[i1];
      if i2<=Iend
        then y2:=Yvalue[i2]
        else y2:=y1;

      dest.Yvalue[i]:=y1+(y2-y1)/(x2-x1)*(x-x1);

      if isComplex then
      begin
        y1:=ImValue[i1];
        if i2<=Iend
          then y2:=Imvalue[i2]
          else y2:=y1;

        dest.Imvalue[i]:=y1+(y2-y1)/(x2-x1)*(x-x1);
      end;
    end;
  end
  else                       //sous-échantillonnage
  begin
    Dest.X0u:=xA1+dx/2;      // modifié le 8-07-13

    if dest.isCpx then
      for i:=0 to n-1 do
        dest.CpxValue[i]:= src1.getCpxMean(xA1+i*dx,xA1+(i+1)*dx-src1.dxu)
    else
    for i:=0 to n-1 do
      dest[i]:=src1.getMean(xA1+i*dx,xA1+(i+1)*dx-src1.dxu);
  end;
  FINALLY
  if src=dest then src1.free;
  END;
end;


procedure proVSample_1(var src:Tvector;dx:float;var dest:Tvector);
begin
  proVSample(src,src.Xstart,src.Xend,dx,dest);
end;


Initialization
AffDebug('Initialization stmISPL1',0);
  installError(E_ISPL,'ISPL DLL not loaded');
  installError(E_dataTypeNotValid,'ISPL: Type not supported');
  installError(E_triangle1,'Triangle: period must be positive');
  installError(E_triangle2,'Triangle: Magnitude must be positive');

  installError(E_FirFreq,'FIR: frequency out of range');
  installError(E_FirTapsLen,'FIR: TapsLen out of range');
  installError(E_FirWinType,'FIR: WinType out of range');

  installError(E_circonv,'Circonv: src1 and src2 must have the same number of points');
  installError(E_circonv2,'Circonv: invalid type');
  installError(E_power2,'Nfft must be a power of 2 ');

end.
