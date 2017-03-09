unit MKL_VSL;

 N'est pas utilisée pour l'instant 


interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
uses windows,util1;

var
 vdRngCauchy:  function(method:integer; stream: pointer; N:integer; R:pointer; a, b:double):integer;cdecl;
 vsRngCauchy:  function(method:integer; stream: pointer; N:integer; R:pointer; a, b:single):integer;cdecl;

 vdRngUniform: function(method:integer; stream: pointer; N:integer; R:pointer; a, b:double):integer;cdecl;
 vsRngUniform: function(method:integer; stream: pointer; N:integer; R:pointer; a, b:single):integer;cdecl;

 vdRngGaussian:function(method:integer; stream: pointer; N:integer; R:pointer; a, b:double):integer;cdecl;
 vsRngGaussian:function(method:integer; stream: pointer; N:integer; R:pointer; a, b:single):integer;cdecl;

 vdRngExponential:function(method:integer; stream: pointer; N:integer; R:pointer; a, b:double):integer;cdecl;
 vsRngExponential:function(method:integer; stream: pointer; N:integer; R:pointer; a, b:single):integer;cdecl;

 vdRngLaplace: function(method:integer; stream: pointer; N:integer; R:pointer; a, b:double):integer;cdecl;
 vsRngLaplace: function(method:integer; stream: pointer; N:integer; R:pointer; a, b:single):integer;cdecl;

 vdRngWeibull: function(method:integer; stream: pointer; N:integer; R:pointer; a, b, c:double):integer;cdecl;
 vsRngWeibull: function(method:integer; stream: pointer; N:integer; R:pointer; a, b, c:single):integer;cdecl;

 vdRngRayleigh: function(method:integer; stream: pointer; N:integer; R:pointer; a, b:double):integer;cdecl;
 vsRngRayleigh: function(method:integer; stream: pointer; N:integer; R:pointer; a, b:single):integer;cdecl;

 vdRngLognormal:  function(method:integer; stream: pointer; N:integer; R:pointer; a, b, c, d:double):integer;cdecl;
 vsRngLognormal:  function(method:integer; stream: pointer; N:integer; R:pointer; a, b, c, d:single):integer;cdecl;

 vdRngGumbel:  function(method:integer; stream: pointer; N:integer; R:pointer; a, b:double):integer;cdecl;
 vsRngGumbel:  function(method:integer; stream: pointer; N:integer; R:pointer; a, b:single):integer;cdecl;


 viRngBernoulli: function(method:integer; stream: pointer; N:integer; R:pointer; a:double):integer;cdecl;
 viRngUniform:  function(method:integer; stream: pointer;N:integer; R:pointer; a,b:integer  ):integer;cdecl;
 viRngUniformBits:  function(method:integer; stream: pointer;N:integer; R:pointer):integer;cdecl;
 viRngGeometric:  function(method:integer; stream: pointer;N:integer; R:pointer;a: double  ):integer;cdecl;
 viRngBinomial:  function(method:integer; stream: pointer;N:integer; R:pointer;a: integer;b: double  ):integer;cdecl;
 viRngHypergeometric:  function(method:integer; stream: pointer;N:integer; R:pointer; a,b,c:integer ):integer;cdecl;
 viRngNegbinomial:  function(method:integer; stream: pointer;N:integer; R:pointer; a:double;b:double  ):integer;cdecl;
 viRngPoisson:  function(method:integer; stream: pointer;N:integer; R:pointer;a:double  ):integer;cdecl;
 viRngPoissonV:  function(method:integer; stream: pointer;N:integer; R:pointer):integer;cdecl;


//*******************************************************************************
//************************* sevrice functions ************************************
//*******************************************************************************/

 vslNewStream:  function(var stream: pointer; brng:integer; seed:integer  ):integer;cdecl;
 vslNewStreamEx:  function(var stream: pointer; brng:integer; n:integer; params:pointer):integer;cdecl;
 vslDeleteStream:  function(var stream: pointer):integer;cdecl;
 vslCopyStream:  function(var stream1: pointer;var  stream2: pointer):integer;cdecl;
 vslCopyStreamState:  function(stream1: pointer; stream2: pointer):integer;cdecl;
 vslLeapfrogStream:  function(stream: pointer; k:integer; Nstream: integer  ):integer;cdecl;
 vslSkipAheadStream:  function(stream: pointer;nskip: integer  ):integer;cdecl;

 vslGetNumRegBrngs:  function(p:pointer):integer;cdecl;
 vslGetStreamStateBrng:  function(stream: pointer):integer;cdecl;

 // vslRegisterBrng:  function(const VSLBRngProperties* properties):integer;cdecl;
 // vslGetBrngProperties:  function(integer  ; VSLBRngProperties* properties):integer;cdecl;


function InitVSL:boolean;

implementation

var
  hlib:intG;



function InitVSL:boolean;
begin
  hLib:=GloadLibrary('mkl_Vml_def.dll');
  if hlib=0 then exit;

  vdRngCauchy:=getProc(hlib,'_dRngCauchy');
  vsRngCauchy:=getProc(hlib,'_sRngCauchy');
  vdRngUniform:=getProc(hlib,'_dRngUniform');
  vsRngUniform:=getProc(hlib,'_sRngUniform');
  vdRngGaussian:=getProc(hlib,'_dRngGaussian');
  vsRngGaussian:=getProc(hlib,'_sRngGaussian');
  vdRngExponential:=getProc(hlib,'_dRngExponential');
  vsRngExponential:=getProc(hlib,'_sRngExponential');
  vdRngLaplace:=getProc(hlib,'_dRngLaplace');
  vsRngLaplace:=getProc(hlib,'_sRngLaplace');
  vdRngWeibull:=getProc(hlib,'_dRngWeibull');
  vsRngWeibull:=getProc(hlib,'_sRngWeibull');
  vdRngRayleigh:=getProc(hlib,'_dRngRayleigh');
  vsRngRayleigh:=getProc(hlib,'_sRngRayleigh');
  vdRngLognormal:=getProc(hlib,'_dRngLognormal');
  vsRngLognormal:=getProc(hlib,'_sRngLognormal');
  vdRngGumbel:=getProc(hlib,'_dRngGumbel');
  vsRngGumbel:=getProc(hlib,'_sRngGumbel');
  viRngBernoulli:=getProc(hlib,'_iRngBernoulli');
  viRngUniform:=getProc(hlib,'_iRngUniform');
  viRngUniformBits:=getProc(hlib,'_iRngUniformBits');
  viRngGeometric:=getProc(hlib,'_iRngGeometric');
  viRngBinomial:=getProc(hlib,'_iRngBinomial');
  viRngHypergeometric:=getProc(hlib,'_iRngHypergeometric');
  viRngNegbinomial:=getProc(hlib,'_iRngNegbinomial');
  viRngPoisson:=getProc(hlib,'_iRngPoisson');
  //  viRngPoissonV:=getProc(hlib,'_iRngPoissonV');
  //  vslNewStream:=getProc(hlib,'__vslNewStream');
  vslNewStreamEx:=getProc(hlib,'__vslNewStreamEx');
  vslDeleteStream:=getProc(hlib,'__vslDeleteStream');
  vslCopyStream:=getProc(hlib,'__vslCopyStream');
  vslCopyStreamState:=getProc(hlib,'__vslCopyStreamState');
  vslLeapfrogStream:=getProc(hlib,'__vslLeapfrogStream');
  vslSkipAheadStream:=getProc(hlib,'__vslSkipAheadStream');
  vslGetNumRegBrngs:=getProc(hlib,'__vslGetNumRegBrngs');
  vslGetStreamStateBrng:=getProc(hlib,'__vslGetStreamStateBrng');
end;


end.
