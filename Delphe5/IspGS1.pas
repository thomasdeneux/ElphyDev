unit IspGS1;

{ Actuellement (2013), stmWT1 est la seule unité utilisant IspGS1

  En effet, ISPL contenait des fonctions de calcul d'ondelettes
  Ces fonctions ont disparu de IPP ou MKL

  Donc stmWT1 est sans doute obsolète, sinon pour un but pédagogique.
}


(* IspGS1 est obtenue en concaténant tous les modules .int et .imp
   de la librairie Intel Signal Processing

   D'autre part, on charge dynamiquement la librairie au lieu de la lier
   statiquement.
   Il faut donc appeler initISPL avant d'utiliser une fonction.
   initISPL renvoie True si le chargement a été effectué.

   Nous avons aussi supprimé les types float et short introduits dans nsp.pas
   qui prêtent à confusion.
   Float est remplacé par single
   short est remplacé par smallint

   Gérard Sadoc Juin 2002
*)


(*
From:    nsp.h
Purpose: NSP Common Header file
*)



{$Z+,A+}  (*si un type énuméré est déclaré en mode $Z4 (= $Z+),
           il est stocké sous la forme d'un double mot non signé.
           En mode {$A8} ou {$A+}, les champs des types enregistrement déclarés
           sans le modificateur packed et les champs des structures classe
           sont alignés sur les frontières des quadruples mots.
          *)

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows, math,
     util1, NcDef2;


function InitIspl:boolean;
procedure freeISPL;

procedure ISPtest;
procedure ISPend;

type
  NSPStatus = Integer;

  {
  PSCplx = ^TSCplx;
  TSCplx = record
    Re : single;
    Im : single;
  end;

  PDCplx = ^TDCplx;
  TDCplx = record
    Re : Double;
    Im : Double;
  end;
  }
  PSCplx = PsingleComp;
  TSCplx = TsingleComp;

  PDCplx = PdoubleComp;
  TDCplx = TdoubleComp;


  PWCplx = ^TWCplx;
  TWCplx = record
    x : smallint;
    y : smallint;
  end;

  PICplx = ^TICplx;
  TICplx = record
    x : Integer;
    y : Integer;
  end;

const
  SCplxZero : TSCplx = (x: 0; y: 0);
  DCplxZero : TDCplx = (x: 0; y: 0);
  WCplxZero : TWCplx = (x: 0; y: 0);
  ICplxZero : TICplx = (x: 0; y: 0);

  SCplxOneZero : TSCplx = (x: 1; y: 0);
  DCplxOneZero : TDCplx = (x: 1; y: 0);

  WCplxOneOne : TWCplx = (x: 1; y: 1);
  ICplxOneOne : TICplx = (x: 1; y: 1);
  SCplxOneOne : TSCplx = (x: 1; y: 1);
  DCplxOneOne : TDCplx = (x: 1; y: 1);

const
  NSP_EPS  = 1.0e-12;
  NSP_PI   = 3.14159265358979324;
  NSP_2PI  = 6.28318530717958648;
  NSP_PI_2 = 1.57079632679489662;
  NSP_PI_4 = 0.785398163397448310;

function NSPsDegToRad(const Deg : single) : single;
function NSPdDegToRad(const Deg : Double) : Double;


const
  nspDLL = 'NSP.DLL';


(*
From:    nspalloc.h
Purpose: NSP 32 bytes aligned allocator/deallocator
*)

var

nspMalloc :function (Length : Integer) : Pointer; stdcall;

nspsMalloc:function (Length : Integer) : Psingle;  stdcall;
nspdMalloc:function (Length : Integer) : PDouble; stdcall;

nspcMalloc:function (Length : Integer) : PSCplx;  stdcall;
nspzMalloc:function (Length : Integer) : PDCplx;  stdcall;

nspwMalloc:function (Length : Integer) : Psmallint;  stdcall;
nspvMalloc:function (Length : Integer) : PWCplx;  stdcall;

nspFree:procedure (P      : Pointer);           stdcall;

{EOF}
(*
From:    nsparith.h
Purpose: NSP Scalar and Vector Arithmetics
*)

{-------------------------------------------------------------------------}
{   Miscellaneous Scalar Functions and Vector Functions                   }
{        Complex Add, Sub, Mpy, Div, Conj                                 }
{                                                                         }
{   These functions perform addition, subtraction, multiplication,        }
{   division, and conjugation on complex numbers a and b.                 }


function nspcAdd(A, B : TSCplx) : TSCplx; {stdcall;}
function nspcSub(A, B : TSCplx) : TSCplx; {stdcall;}
function nspcMpy(A, B : TSCplx) : TSCplx; {stdcall;}
function nspcDiv(A, B : TSCplx) : TSCplx; {stdcall;}
function nspcConj(A    : TSCplx) : TSCplx;{stdcall;}


var

nspcAddOut:procedure (A, B : TSCplx; var Val : TSCplx); stdcall;
nspcSubOut:procedure (A, B : TSCplx; var Val : TSCplx); stdcall;
nspcMpyOut:procedure (A, B : TSCplx; var Val : TSCplx); stdcall;
nspcDivOut:procedure (A, B : TSCplx; var Val : TSCplx); stdcall;
nspcConjOut:procedure (A    : TSCplx; var Val : TSCplx); stdcall;

{---- Additional Functions -----------------------------------------------}

function nspcSet(Re, Im : single) : TSCplx; stdcall;

var

nspcSetOut:procedure (Re, Im : single; var Val : TSCplx); stdcall;

{-------------------------------------------------------------------------}
{        Vector Initialization                                            }
{   These functions initialize vectors of length n.                       }
nspsbZero:procedure (Dst : Psingle; N : integer); stdcall;
nspcbZero:procedure (Dst : PSCplx; N : integer); stdcall;

nspsbSet:procedure (Val    : single; Dst : Psingle; N : integer); stdcall;
nspcbSet:procedure (Re, Im : single; Dst : PSCplx; N : integer); stdcall;

nspsbCopy:procedure (Src : Psingle; Dst : Psingle; N : integer); stdcall;
nspcbCopy:procedure (Src : PSCplx; Dst : PSCplx; N : integer); stdcall;

{-------------------------------------------------------------------------}
{        Vector Addition and multiplication                               }
{  These functions perform element-wise arithmetic on vectors of length n }

{ dst[i]=dst[i]+val;                                                      }
nspsbAdd1:procedure (Val : single;  Dst : Psingle; N : integer); stdcall;
nspcbAdd1:procedure (Val : TSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=dst[i]+src[i];                                                   }
nspsbAdd2:procedure (Src : Psingle; Dst : Psingle; N : integer); stdcall;
nspcbAdd2:procedure (Src : PSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=srcA[i]+srcB[i];                                                 }
nspsbAdd3:procedure (SrcA : Psingle; SrcB : Psingle; Dst : Psingle; N : integer); stdcall;
nspcbAdd3:procedure (SrcA : PSCplx; SrcB : PSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=dst[i]-val;                                                      }
nspsbSub1:procedure (Val : single;  Dst : Psingle; N : integer); stdcall;
nspcbSub1:procedure (Val : TSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=dst[i]-val[i];                                                   }
nspsbSub2:procedure (Val : Psingle; Dst : Psingle; N : integer); stdcall;
nspcbSub2:procedure (Val : PSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=src[i]-val[i];                                                   }
nspsbSub3:procedure (Src : Psingle; Val : Psingle; Dst : Psingle; N : integer); stdcall;
nspcbSub3:procedure (Src : PSCplx; Val : PSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=dst[i]*val;                                                      }
nspsbMpy1:procedure (Val : single;  Dst : Psingle; N : integer); stdcall;
nspcbMpy1:procedure (Val : TSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=dst[i]*src[i];                                                   }
nspsbMpy2:procedure (Src : Psingle; Dst : Psingle; N : integer); stdcall;
nspcbMpy2:procedure (Src : PSCplx; Dst : PSCplx; N : integer); stdcall;

{ dst[i]=srcA[i]*srcB[i];                                                 }
nspsbMpy3:procedure (SrcA : Psingle; SrcB : Psingle; Dst : Psingle; N : integer); stdcall;
nspcbMpy3:procedure (SrcA : PSCplx; SrcB : PSCplx; Dst : PSCplx; N : integer); stdcall;

{-------------------------------------------------------------------------}
{        Complex conjugates of scalars and vectors                        }

nspcbConj1      :procedure (Vec : PSCplx;               N : integer); stdcall;
nspcbConj2      :procedure (Src : PSCplx; Dst : PSCplx; N : integer); stdcall;
nspcbConjFlip2  :procedure (Src : PSCplx; Dst : PSCplx; N : integer); stdcall;
nspcbConjExtend1:procedure (Vec : PSCplx;               N : integer); stdcall;
nspcbConjExtend2:procedure (Src : PSCplx; Dst : PSCplx; N : integer); stdcall;

{-------------------------------------------------------------------------}
{   Miscellaneous Scalar Functions and Vector Functions                   }
{        Complex Add, Sub, Mpy, Div, Conj                                 }
{   These functions perform addition, subtraction, multiplication,        }
{   division, and conjugation on complex numbers a and b.                 }
{                                                                         }

var

nspzAdd:function (A, B : TDCplx) : TDCplx; stdcall;
nspzSub:function (A, B : TDCplx) : TDCplx; stdcall;
nspzMpy:function (A, B : TDCplx) : TDCplx; stdcall;
nspzDiv:function (A, B : TDCplx) : TDCplx; stdcall;
nspzConj:function (A    : TDCplx) : TDCplx; stdcall;

{---- Additional Functions -----------------------------------------------}

nspzSet:function (Re, Im : Double) : TDCplx; stdcall;

{-------------------------------------------------------------------------}
{        Vector Initialization                                            }
{   These functions initialize vectors of length n.                       }

nspdbZero:procedure (Dst : PDouble; N : Integer); stdcall;
nspzbZero:procedure (Dst : PDCplx;  N : Integer); stdcall;

nspdbSet:procedure (Val    : Double; Dst : PDouble; N : Integer); stdcall;
nspzbSet:procedure (Re, Im : Double; Dst : PDCplx;  N : Integer); stdcall;

nspdbCopy:procedure (Src, Dst : PDouble; N : Integer); stdcall;
nspzbCopy:procedure (Src, Dst : PDCplx;  N : Integer); stdcall;

{-------------------------------------------------------------------------}
{        Vector Addition and multiplication                               }
{   These functions perform element-wise arithmetic on vectors of length n}

{ dst[i]=dst[i]+val;                                                      }
nspdbAdd1:procedure (Val : Double; Dst : PDouble; N : Integer); stdcall;
nspzbAdd1:procedure (Val : TDCplx; Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=dst[i]+src[i];                                                   }
nspdbAdd2:procedure (Src, Dst : PDouble; N : Integer); stdcall;
nspzbAdd2:procedure (Src, Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=srcA[i]+srcB[i];                                                 }
nspdbAdd3:procedure (SrcA, SrcB, Dst : PDouble; N : Integer); stdcall;
nspzbAdd3:procedure (SrcA, SrcB, Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=dst[i]-val;                                                      }
nspdbSub1:procedure (Val : Double; Dst : PDouble; N : Integer); stdcall;
nspzbSub1:procedure (Val : TDCplx; Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=dst[i]-val[i];                                                   }
nspdbSub2:procedure (Val, Dst : PDouble; N : Integer); stdcall;
nspzbSub2:procedure (Val, Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=src[i]-val[i];                                                   }
nspdbSub3:procedure (Src, Val, Dst : PDouble; N : Integer); stdcall;
nspzbSub3:procedure (Src, Val, Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=dst[i]*val;                                                      }
nspdbMpy1:procedure (Val : Double; Dst : PDouble; N : Integer); stdcall;
nspzbMpy1:procedure (Val : TDCplx; Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=dst[i]*src[i];                                                   }
nspdbMpy2:procedure (Src, Dst : PDouble; N : Integer); stdcall;
nspzbMpy2:procedure (Src, Dst : PDCplx;  N : Integer); stdcall;

{ dst[i]=srcA[i]*srcB[i];                                                 }
nspdbMpy3:procedure (SrcA, SrcB, Dst : PDouble; N : Integer); stdcall;
nspzbMpy3:procedure (SrcA, SrcB, Dst : PDCplx;  N : Integer); stdcall;

{-------------------------------------------------------------------------}
{                                                                         }
{        Complex conjugates of scalars and vectors                        }
{                                                                         }

nspzbConj1:procedure (Vec      : PDCplx; N : Integer); stdcall;
nspzbConj2:procedure (Src, Dst : PDCplx; N : Integer); stdcall;
nspzbConjFlip2:procedure (Src, Dst : PDCplx; N : Integer); stdcall;
nspzbConjExtend1:procedure (Vec      : PDCplx; N : Integer); stdcall;
nspzbConjExtend2:procedure (Src, Dst : PDCplx; N : Integer); stdcall;

{-------------------------------------------------------------------------}
{   Miscellaneous Scalar Functions and Vector Functions                   }
{        Complex Add, Sub, Mpy, Div, Conj                                 }
{   These functions perform addition, subtraction, multiplication,        }
{   division, and conjugation on complex numbers a and b.                 }
{                                                                         }

var

nspvAdd:function (A, B        : TWCplx;
                 ScaleMode   : integer;
             var ScaleFactor : integer) : TWCplx; stdcall;
nspvSub:function (A, B        : TWCplx;
                 ScaleMode   : integer;
             var ScaleFactor : integer) : TWCplx; stdcall;
nspvMpy:function (A, B        : TWCplx;
                 ScaleMode   : integer;
             var ScaleFactor : integer) : TWCplx; stdcall;
nspvDiv:function (A, B        : TWCplx)  : TWCplx; stdcall;
nspvConj:function (A          : TWCplx)  : TWCplx; stdcall;

{---- Additional Functions -----------------------------------------------}

nspvSet:function (Re, Im : smallint) : TWCplx; stdcall;

{-------------------------------------------------------------------------}
{        Vector Initialization                                            }
{   These functions initialize vectors of length n.                       }

nspwbZero:procedure (Dst : Psmallint; N : integer); stdcall;
nspvbZero:procedure (Dst : PWCplx; N : integer); stdcall;

nspwbSet:procedure (Val    : smallint; Dst : Psmallint; N : integer); stdcall;
nspvbSet:procedure (Re, Im : smallint; Dst : PWCplx; N : integer); stdcall;

nspwbCopy:procedure (Src : Psmallint; Dst : Psmallint; N : integer); stdcall;
nspvbCopy:procedure (Src : PWCplx; Dst : PWCplx; N : integer); stdcall;

{-------------------------------------------------------------------------}
{        Vector Addition and multiplication                               }
{   These functions perform element-wise arithmetic on vectors of length n}

nspwbAdd1:procedure (Val         : smallint;
                    Dst         : Psmallint;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
nspvbAdd1:procedure (Val         : TWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

nspwbAdd2:procedure (Src         : Psmallint;
                    Dst         : Psmallint;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
nspvbAdd2:procedure (Src         : PWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

nspwbAdd3:procedure (SrcA        : Psmallint;
                    SrcB        : Psmallint;
                    Dst         : Psmallint;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
nspvbAdd3:procedure (SrcA        : PWCplx;
                    SrcB        : PWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

nspwbSub1:procedure (Val         : smallint;
                    Dst         : Psmallint;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
nspvbSub1:procedure (Val         : TWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

nspwbSub2:procedure (Val         : Psmallint;
                    Dst         : Psmallint;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
nspvbSub2:procedure (Val         : PWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

nspwbSub3:procedure (Src         : Psmallint;
                    Val         : Psmallint;
                    Dst         : Psmallint;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
nspvbSub3:procedure (Src         : PWCplx;
                    Val         : PWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

nspwbMpy1:procedure (Val         : smallint;
                    Dst         : Psmallint;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
nspvbMpy1:procedure (Val         : TWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

nspwbMpy2:procedure (Val         : Psmallint;
                    Dst         : Psmallint;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
nspvbMpy2:procedure (Val         : PWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

nspwbMpy3:procedure (SrcA        : Psmallint;
                    SrcB        : Psmallint;
                    Dst         : Psmallint;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;
nspvbMpy3:procedure (SrcA        : PWCplx;
                    SrcB        : PWCplx;
                    Dst         : PWCplx;
                    N           : integer;
                    ScaleMode   : integer;
                var ScaleFactor : integer); stdcall;

{-------------------------------------------------------------------------}
{        Complex conjugates of vectors                                    }

nspvbConj1:procedure (Vec : PWCplx;               N : integer); stdcall;
nspvbConj2:procedure (Src : PWCplx; Dst : PWCplx; N : integer); stdcall;
nspvbConjFlip2:procedure (Src : PWCplx; Dst : PWCplx; N : integer); stdcall;
nspvbConjExtend1:procedure (Vec : PWCplx;               N : integer); stdcall;
nspvbConjExtend2:procedure (Src : PWCplx; Dst : PWCplx; N : integer); stdcall;

{EOF}
(*
From:    nspatan.h
Purpose: Header file for function nspAtan
Author:  Turutin Y.
*)

nspsbArctan1:procedure (Vec      : Psingle;  Len : Integer); stdcall;
nspsbArctan2:procedure (Src, Dst : Psingle;  Len : Integer); stdcall;
nspdbArctan1:procedure (Vec      : PDouble; Len : Integer); stdcall;
nspdbArctan2:procedure (Src, Dst : PDouble; Len : Integer); stdcall;

{EOF}
(*
From:    nspcnv2d.h
Purpose: NSP 2D Filtering Functions
*)

{-------------------------------------------------------------------------}
{         Conv2D                                                          }
{                                                                         }
{ Perform finite, linear convolution of two two-dimensional signals.      }

nspsConv2D:procedure (X           : Psingle;  XCols : Integer; XRows : Integer;
                     H           : Psingle;  HCols : Integer; HRows : Integer;
                     Y           : Psingle);  stdcall;
nspdConv2D:procedure (X           : PDouble; XCols : Integer; XRows : Integer;
                     H           : PDouble; HCols : Integer; HRows : Integer;
                     Y           : PDouble); stdcall;
nspwConv2D:procedure (X           : Psmallint;  XCols : Integer; XRows : Integer;
                     H           : Psmallint;  HCols : Integer; HRows : Integer;
                     Y           : Psmallint;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer); stdcall;

{EOF}
(*
From:    nspconv.h
Purpose: NSP Convolution
*)

{-------------------------------------------------------------------------}
{         Conv                                                            }
{                                                                         }
{ Performs finite, linear convolution of two sequences.                   }

nspsConv:procedure (X          : Psingle;  XLen : Integer;
                   H           : Psingle;  HLen : Integer;
                   Y           : Psingle); stdcall;
nspcConv:procedure (X          : PSCplx;  XLen : Integer;
                   H           : PSCplx;  HLen : Integer;
                   Y           : PSCPlx); stdcall;


nspdConv:procedure (X          : PDouble; XLen : Integer;
                   H           : PDouble; HLen : Integer;
                   Y           : PDouble); stdcall;
nspzConv:procedure (X           : PDCplx;  XLen : Integer;
                   H           : PDCplx;  HLen : Integer;
                   Y           : PDCplx); stdcall;

nspwConv:procedure (X           : Psmallint;  XLen : Integer;
                   H           : Psmallint;  HLen : Integer;
                   Y           : Psmallint;
                   ScaleMode   : Integer;
               var ScaleFactor : Integer); stdcall;

{Quatre fonctions oubliées }
nspscConv:procedure (X         : Psingle;  XLen : Integer;
                   H           : PSCplx;  HLen : Integer;
                   Y           : PSCPlx); stdcall;
nspcsConv:procedure(X          : PSCplx;  XLen : Integer;
                   H           : PSingle;  HLen : Integer;
                   Y           : PSCPlx); stdcall;
nspzdConv:procedure (X         : PDCplx;  XLen : Integer;
                   H           : PDouble;  HLen : Integer;
                   Y           : PDCplx); stdcall;
nspdzConv:procedure (X         : PDouble;  XLen : Integer;
                   H           : PDCplx;  HLen : Integer;
                   Y           : PDCplx); stdcall;

{EOF}
(*
From:    nspcorr.h
Purpose: NSP Correlation
*)

type
  TNSPAutoCorrType = (NSP_Normal, NSP_Biased, NSP_UnBiased);

{------------------------------------------------------------------------}
{        AutoCorrelation                                                 }
{                                                                        }
{
  Normal:
  ~~~~~~~
  dst[n] = S ~src[k] * src[k+n],  0 <= n < nLags
                                  0 <= k < len

  Biased:
  ~~~~~~~
  dst[n] = K* S ~src[k] * src[k+n],  0 <= n < nLags
                                     0 <= k < len
                                     K = 1/len
  UnBiased:
  ~~~~~~~~~
  dst[n] = K* S ~src[k] * src[k+n],  0 <= n < nLags
                                     0 <= k < len
                                     K = 1/(len-n)

                                             | src[k], 0<=k<len
                                   src(k) = <
                                             | 0, otherwise
}

var

nspsAutoCorr:procedure (Src         : Psingle;  Len   : Integer;
                       Dst         : Psingle;  NLags : Integer;
                       CorrType    : TNSPAutoCorrType); stdcall;
nspcAutoCorr:procedure (Src         : PSCplx;  Len   : Integer;
                       Dst         : PSCplx;  NLags : Integer;
                       CorrType    : TNSPAutoCorrType); stdcall;
nspdAutoCorr:procedure (Src         : PDouble; Len   : Integer;
                       Dst         : PDouble; NLags : Integer;
                       CorrType    : TNSPAutoCorrType); stdcall;
nspzAutoCorr:procedure (Src         : PDCplx;  Len   : Integer;
                       Dst         : PDCplx;  NLags : Integer;
                       CorrType    : TNSPAutoCorrType); stdcall;
nspwAutoCorr:procedure (Src         : Psmallint;  Len   : Integer;
                       Dst         : Psmallint;  NLags : Integer;
                       CorrType    : TNSPAutoCorrType;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer); stdcall;
nspvAutoCorr:procedure (Src         : PWCplx;  Len   : Integer;
                       Dst         : PWCplx;  NLags : Integer;
                       CorrType    : TNSPAutoCorrType;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer); stdcall;

{------------------------------------------------------------------------}
{        CrossCorrelation                                                }
{
  dst[n] = S ~srcA[k] * srcB[k+n+loLag],  0 <= n <= hiLag-loLag
                                          0 <= k < lenA

                                                 | srcB[k], 0<=k<lenB
                                       srcB(k) = <
                                                 | 0, otherwise
  Number of result elements is hiLag-loLag+1.
  Estimate at lag of loLag in dst[0].
  Estimate at lag of hiLag in dst[hiLag-loLag].
}

nspsCrossCorr:procedure (SrcA        : Psingle;  LenA         : Integer;
                        SrcB        : Psingle;  LenB         : Integer;
                        Dst         : Psingle;  LoLag, HiLag : Integer); stdcall;
nspcCrossCorr:procedure (SrcA        : PSCplx;  LenA         : Integer;
                        SrcB        : PSCplx;  LenB         : Integer;
                        Dst         : PSCplx;  LoLag, HiLag : Integer); stdcall;
nspdCrossCorr:procedure (SrcA        : PDouble; LenA         : Integer;
                        SrcB        : PDouble; LenB         : Integer;
                        Dst         : PDouble; LoLag, HiLag : Integer); stdcall;
nspzCrossCorr:procedure (SrcA        : PDCplx;  LenA         : Integer;
                        SrcB        : PDCplx;  LenB         : Integer;
                        Dst         : PDCplx;  LoLag, HiLag : Integer); stdcall;
nspwCrossCorr:procedure (SrcA        : Psmallint;  LenA         : Integer;
                        SrcB        : Psmallint;  LenB         : Integer;
                        Dst         : Psmallint;  LoLag, HiLag : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer); stdcall;
nspvCrossCorr:procedure (SrcA        : PWCplx;  LenA         : Integer;
                        SrcB        : PWCplx;  LenB         : Integer;
                        Dst         : PWCplx;  LoLag,HiLag  : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer); stdcall;

{EOF}
(*
From:    nspcvrt.h
Purpose: Data Convertion Functions.
*)

{-------Flags to determine the transformation-----------------------------}

const
  NSP_Noflags   = $0000;     // Specifies an absence of all flags
  NSP_Round     = $0080;     // Specifies that floating-point values
                             // should be rounded to the nearest integer
  NSP_TruncZero = $0100;     // Specifies that floating-point values
                             // should be truncated toward zero
  NSP_TruncNeg  = $0200;     // Specifies that floating-point values
                             // should be truncated toward negative
                             // infinity
  NSP_TruncPos  = $0400;     // Specifies that floating-point values
                             // should be truncated toward positive
                             // infinity
  NSP_Unsigned  = $0800;     // Specifies that integer values are
                             // unsigned
  NSP_Clip      = $1000;     // Specifies that floating-point values
                             // outside the allowable integer range
                             // are saturated to maximum(minimum)
                             // integer value
  NSP_OvfErr    = $2000;     // Specifies that an overflow error should
                             // be signaled with a call to nspError()

{-------------------------------------------------------------------------}
{ Maximum possible phase value for smallint function, corresponds to NSP_PI  }

  NSP_CVRT_MAXPHASE = 16383;

{-------------------------------------------------------------------------}
{             bFloatToInt, bIntToFloat                                    }
{                                                                         }
{Vector floating-point to integer and integer to floating-point conversion}
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,d>bFloatToInt                                                   }
{ DESCRIPTION:                                                            }
{   Converts the single point data in the input array and stores           }
{   the results in the output array.                                      }
{ PARAMETERS:                                                             }
{   src       - an input array to be converted;                           }
{   dst       - an output array to store the result;                      }
{   len       - a length of the arrays;                                   }
{   wordSize  - specifies the size of an integer in bits,                 }
{                     and must be 8, 16 or 32;                            }
{   flags     - specifies the sort of the conversion and consists of the  }
{               bitwise-OR of flags, defined in the beginnig of this file }
{                                                                         }

var
nspsbFloatToInt:procedure (Src      : Psingle;  Dst   : Pointer; Len : Integer;
                          WordSize : Integer; Flags : Integer); stdcall;
nspdbFloatToInt:procedure (Src      : PDouble; Dst   : Pointer; Len : Integer;
                          WordSize : Integer; Flags : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<s,d>bIntToFloat                                                   }
{ DESCRIPTION:                                                            }
{   Converts the integer data in the input array and stores the results   }
{   in the output array                                                   }
{ PARAMETERS:                                                             }
{   src       - an input array to be converted;                           }
{   dst       - an output array to store the result;                      }
{   len       - a length of the arrays;                                   }
{   wordSize  - specifies the size of an integer in bits,                 }
{                     and must be 8, 16 or 32;                            }
{   flags     - specifies that integer values are unsigned or signed.     }
{                                                                         }

var
nspsbIntToFloat:procedure (Src      : Pointer; Dst   : Psingle;  Len : Integer;
                          WordSize : Integer; Flags : Integer); stdcall;
nspdbIntToFloat:procedure (Src      : Pointer; Dst   : PDouble; Len : Integer;
                          WordSize : Integer; Flags : Integer); stdcall;

{-------------------------------------------------------------------------}
{             bFloatToFix, bFixToFloat                                    }
{                                                                         }
{ Vector floating-point to fixed-point and                                }
{            fixed-point to floating-point conversion                     }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,d>bFloatToFix                                                   }
{ DESCRIPTION:                                                            }
{   Converts the floating-point data in the input array and stores        }
{   the results in the output array.                                      }
{ PARAMETERS:                                                             }
{   src       - an input array to be converted;                           }
{   dst       - an output array to store the result;                      }
{   len       - a length of the arrays;                                   }
{   wordSize  - specifies the size of an fix-point in bits,               }
{                     and must be 8, 16 or 32;                            }
{   fractBits - specifies the number of fractional bits                   }
{   flags     - specifies the sort of the conversion and consists of the  }
{               bitwise-OR of flags, defined in the beginnig of this file }
{                                                                         }

var
nspsbFloatToFix:procedure (Src       : Psingle;  Dst      : Pointer;
                          Len       : Integer; WordSize : Integer;
                          FractBits : Integer; Flags    : Integer); stdcall;
nspdbFloatToFix:procedure (Src       : PDouble; Dst      : Pointer;
                          Len       : Integer; WordSize : Integer;
                          FractBits : Integer; Flags    : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<s,d>bFixToFloat                                                   }
{ DESCRIPTION:                                                            }
{   Converts the fixed-point data in the input array and stores the       }
{       results in the output array                                       }
{ PARAMETERS:                                                             }
{   src       - an input array to be converted;                           }
{   dst       - an output array to store the result;                      }
{   len       - a length of the arrays;                                   }
{   wordSize  - specifies the size of an integer in bits,                 }
{                     and must be 8, 16 or 32;                            }
{   fractBits - specifies the number of fractional bits                   }
{   flags     - specifies that fixed-point values are unsigned or signed  }
{                                                                         }

nspsbFixToFloat:procedure (Src       : Pointer; Dst      : Psingle;
                          Len       : Integer; WordSize : Integer;
                          FractBits : Integer; Flags    : Integer); stdcall;
nspdbFixToFloat:procedure (Src       : Pointer; Dst      : PDouble;
                          Len       : Integer; WordSize : Integer;
                          FractBits : Integer; Flags    : Integer); stdcall;

{-------------------------------------------------------------------------}
{ bFloatToS31Fix, bFloatToS15Fix, bFloatToS7Fix, bFloatToS1516Fix,        }
{ bS31FixToFloat, bS15FixToFloat, bS7FixToFloat, bS1516FixToFloat         }
{ Vector floating-point to fixed-point of format S.31, S.15, S.7, S15.16  }
{                and fixed-point of format S.31, S.15, S.7, S15.16        }
{                to floating-point conversion                             }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,d>bFloatToS31Fix                                                }
{   nsp<s,d>bFloatToS15Fix                                                }
{   nsp<s,d>bFloatToS7Fix                                                 }
{   nsp<s,d>bFloatToS1516Fix                                              }
{ DESCRIPTION:                                                            }
{   Converts the floating-point data in the input array and stores        }
{   the results in the output array.                                      }
{   nsp?bFloatToS31Fix() to format of S.31 (a sign bit,31 fractional bits)}
{   nsp?bFloatToS15Fix() to format of S.15 (a sign bit,15 fractional bits)}
{   nsp?bFloatToS7Fix()  to format of S.7  (a sign bit,7  fractional bits)}
{   nsp?bFloatToS1516Fix() to format of S15.16                            }
{                    (a sign bit, 15 integer bits, 16 fractional bits)    }
{ PARAMETERS:                                                             }
{   src       - an input array to be converted;                           }
{   dst       - an output array to store the result;                      }
{   len       - a length of the arrays;                                   }
{   flags     - specifies the sort of the conversion and consists of the  }
{               bitwise-OR of flags, defined in the beginnig of this file }

var
nspsbFloatToS31Fix:procedure (Src : Psingle;   Dst   : PLongint;
                               Len : Integer;  Flags : Integer); stdcall;
nspsbFloatToS15Fix:procedure (Src : Psingle;   Dst   : Psmallint;
                               Len : Integer;  Flags : Integer); stdcall;
nspsbFloatToS7Fix:procedure (Src : Psingle;   Dst   : PByte;
                               Len : Integer;  Flags : Integer); stdcall;
nspsbFloatToS1516Fix:procedure (Src : Psingle;   Dst   : PLongint;
                               Len : Integer;  Flags : Integer); stdcall;

nspdbFloatToS31Fix:procedure (Src : PDouble;  Dst   : PLongint;
                               Len : Integer;  Flags : Integer); stdcall;
nspdbFloatToS15Fix:procedure (Src : PDouble;  Dst   : Psmallint;
                               Len : Integer;  Flags : Integer); stdcall;
nspdbFloatToS7Fix:procedure (Src : PDouble;  Dst   : PByte;
                               Len : Integer;  Flags : Integer); stdcall;
nspdbFloatToS1516Fix:procedure (Src : PDouble;  Dst   : PLongint;
                               Len : Integer;  Flags : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<s,d>bS31FixToFloat                                                }
{   nsp<s,d>bS15FixToFloat                                                }
{   nsp<s,d>bS7FixToFloat                                                 }
{   nsp<s,d>bS1516FixToFloat                                              }
{ DESCRIPTION:                                                            }
{   Converts the fixed-point data in the input array and stores the       }
{       results in the output array                                       }
{  nsp?bS31FixToFloat() from format of S.31(a sign bit,31 fractional bits)}
{  nsp?bS15FixToFloat() from format of S.15(a sign bit,15 fractional bits)}
{  nsp?bS7FixToFloat()  from format of S.7 (a sign bit,7  fractional bits)}
{  nsp?bS1516FixToFloat() from format of S15.16                           }
{                    (a sign bit, 15 integer bits, 16 fractional bits)    }
{ PARAMETERS:                                                             }
{   src       - an input array to be converted;                           }
{   dst       - an output array to store the result;                      }
{   len       - a length of the arrays;                                   }
{                                                                         }

nspsbS31FixToFloat:procedure (Src : PLongint; Dst : Psingle;
                               Len : Integer); stdcall;
nspsbS15FixToFloat:procedure (Src : Psmallint;   Dst : Psingle;
                               Len : Integer); stdcall;
nspsbS7FixToFloat:procedure (Src : PByte;    Dst : Psingle;
                               Len : Integer); stdcall;
nspsbS1516FixToFloat:procedure (Src : Plongint; Dst : Psingle;
                               Len : Integer); stdcall;

nspdbS31FixToFloat:procedure (Src : PLongint; Dst : PDouble;
                               Len : Integer); stdcall;
nspdbS15FixToFloat:procedure (Src : Psmallint;   Dst : PDouble;
                               Len : Integer); stdcall;
nspdbS7FixToFloat:procedure (Src : PByte;    Dst : PDouble;
                               Len : Integer); stdcall;
nspdbS1516FixToFloat:procedure (Src : Plongint; Dst : PDouble;
                               Len : Integer); stdcall;

{-------------------------------------------------------------------------}
{  bReal, bImag, bCplxTo2Real, b2RealToCplx                               }
{                                                                         }
{ Return the real and imaginary parts of complex vectors                  }
{ or construct complex vectors from real and imaginary components         }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<v,c,z>bReal                                                       }
{ DESCRIPTION:                                                            }
{   Return the real part of the coplex vector                             }
{ PARAMETERS:                                                             }
{   src       - an input complex vector                                   }
{   dst       - an output vector to store the real part;                  }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

var
nspcbReal:procedure (Src : PSCplx; Dst : Psingle;  Len : Integer); stdcall;
nspzbReal:procedure (Src : PDCplx; Dst : PDouble; Len : Integer); stdcall;
nspvbReal:procedure (Src : PWCplx; Dst : Psmallint;  Len : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<v,c,z>bImag                                                       }
{ DESCRIPTION:                                                            }
{   Return the imaginary part of the coplex vector                        }
{ PARAMETERS:                                                             }
{   src       - an input complex vector                                   }
{   dst       - an output vector to store the imaginary part;             }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

nspcbImag:procedure (Src : PSCplx; Dst : Psingle;  Len : Integer); stdcall;
nspzbImag:procedure (Src : PDCplx; Dst : PDouble; Len : Integer); stdcall;
nspvbImag:procedure (Src : PWCplx; Dst : Psmallint;  Len : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<v,c,z>bCplxTo2Real                                                }
{ DESCRIPTION:                                                            }
{   Return the real and imaginary parts of the coplex vector              }
{ PARAMETERS:                                                             }
{   src       - an input complex vector                                   }
{   dstReal   - an output vector to store the real part                   }
{   dstImag   - an output vector to store the imaginary part;             }
{   len       - a length of the arrays;                                   }
{                                                                         }

nspcbCplxTo2Real:procedure (Src : PSCplx; DstReal, DstImag : Psingle;
                           Len : Integer); stdcall;
nspzbCplxTo2Real:procedure (Src : PDCplx; DstReal, DstImag : PDouble;
                           Len : Integer); stdcall;
nspvbCplxTo2Real:procedure (Src : PWCplx; DstReal, DstImag : Psmallint;
                           Len : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<v,c,z>b2RealToCplx                                                }
{ DESCRIPTION:                                                            }
{   Construct complex vector from real and imaginary components           }
{ PARAMETERS:                                                             }
{   srcReal   - an input real component. May be NULL - a real part of the }
{               output will be zero;                                      }
{   srcImag   - an input imaginary component. May be NULL - an imaginary  }
{               part of the output will be zero;                          }
{   dst       - an output complex vector;                                 }
{   len       - a length of the arrays;                                   }
{                                                                         }

nspcb2RealToCplx:procedure (SrcReal, SrcImag : Psingle;  Dst : PSCplx;
                           Len              : Integer); stdcall;
nspzb2RealToCplx:procedure (SrcReal, SrcImag : PDouble; Dst : PDCplx;
                           Len              : Integer); stdcall;
nspvb2RealToCplx:procedure (SrcReal, SrcImag : Psmallint;  Dst : PWCplx;
                           Len              : Integer); stdcall;

{-------------------------------------------------------------------------}
{  bCartToPolar, brCartToPolar, bPolarToCart, brPolarToCart               }
{                                                                         }
{ Cartesian to polar and polar to cartesian coordinate conversions.       }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<v,c,z>bCartToPolar                                                }
{ DESCRIPTION:                                                            }
{   Convert cartesian coordinate to polar. Input data are formed as       }
{            a complex vector.                                            }
{ PARAMETERS:                                                             }
{   src       - an input complex vector;                                  }
{   mag       - an output vector to store the magnitude components;       }
{   phase     - an output vector to store the phase components (in rad)); }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

nspcbCartToPolar:procedure (Src : PSCplx; Mag, Phase : Psingle;
                           Len : Integer); stdcall;
nspzbCartToPolar:procedure (Src : PDCplx; Mag, Phase : PDouble;
                           Len : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<w,s,d>brCartToPolar                                               }
{ DESCRIPTION:                                                            }
{   Convert cartesian coordinate to polar. Input data are formed as       }
{            two different real vectors.                                  }
{ PARAMETERS:                                                             }
{   srcReal   - an input vector containing the coordinates X;             }
{   srcImag   - an input vector containing the coordinates Y;             }
{   mag       - an output vector to store the magnitude components;       }
{   phase     - an output vector to store the phase components (in rad)); }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

nspsbrCartToPolar:procedure (SrcReal : Psingle;  SrcImag : Psingle;
                            Mag     : Psingle;  Phase   : Psingle;
                            Len     : Integer); stdcall;
nspdbrCartToPolar:procedure (SrcReal : PDouble; SrcImag : PDouble;
                            Mag     : PDouble; Phase   : PDouble;
                            Len     : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<v,c,z>bPolarToCart                                                }
{ DESCRIPTION:                                                            }
{   Convert polar coordinate to cartesian. Output data are formed as      }
{            a complex vector.                                            }
{ PARAMETERS:                                                             }
{   mag       - an input vector containing the magnitude components;      }
{   phase     - an input vector containing the phase components(in rad)); }
{   dst       - an output complex vector to store the cartesian coords;   }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

nspcbPolarToCart:procedure (Mag : Psingle;  Phase : Psingle;
                           Dst : PSCplx;  Len   : Integer); stdcall;
nspzbPolarToCart:procedure (Mag : PDouble; Phase : PDouble;
                           Dst : PDCplx;  Len   : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<s,d>brPolarToCart                                                 }
{ DESCRIPTION:                                                            }
{   Convert polar coordinate to cartesian. Output data are formed as      }
{            two real vectors.                                            }
{ PARAMETERS:                                                             }
{   mag       - an input vector containing the magnitude components;      }
{   phase     - an input vector containing the phase components(in rad)); }
{   dstReal   - an output complex vector to store the coordinates X;      }
{   dstImag   - an output complex vector to store the coordinates Y;      }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

nspsbrPolarToCart:procedure (Mag     : Psingle;  Phase   : Psingle;
                            DstReal : Psingle;  DstImag : Psingle;
                            Len     : Integer); stdcall;
nspdbrPolarToCart:procedure (Mag     : PDouble; Phase   : PDouble;
                            DstReal : PDouble; DstImag : PDouble;
                            Len     : Integer); stdcall;

{-------------------------------------------------------------------------}
{  bPowerSpectr, brPowerSpectr, bMag, brMag, bPhase, brPhase              }
{                                                                         }
{ Compute the magnitude and phase of complex vector elements.             }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<v,c,z>bMag                                                        }
{ DESCRIPTION:                                                            }
{   Compute the magnitude of complex vector elements.                     }
{ PARAMETERS:                                                             }
{   src       - an input complex vector                                   }
{   mag       - an output vector to store the magnitude components;       }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

nspcbMag:procedure (Src         : PSCplx; Mag : Psingle;  Len : Integer); stdcall;
nspzbMag:procedure (Src         : PDCplx; Mag : PDouble; Len : Integer); stdcall;
nspvbMag:procedure (Src         : PWCplx; Mag : Psmallint;  Len : Integer;
                   ScaleMode   : Integer;
               var ScaleFactor : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<w,s,d>brMag                                                       }
{ DESCRIPTION:                                                            }
{   Compute the magnitude of complex data formed as two real vectors.     }
{ PARAMETERS:                                                             }
{   srcReal   - an input vector containing a real part of complex data    }
{   srcImag   - an input vector containing an imag. part of complex data  }
{   mag       - an output vector to store the magnitude components;       }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

nspsbrMag:procedure (SrcReal     : Psingle;  SrcImag : Psingle;
                    Mag         : Psingle;  Len     : Integer); stdcall;
nspdbrMag:procedure (SrcReal     : PDouble; SrcImag : PDouble;
                    Mag         : PDouble; Len     : Integer); stdcall;
nspwbrMag:procedure (SrcReal     : Psmallint;  SrcImag : Psmallint;
                    Mag         : Psmallint;  Len     : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<v,c,z>bPhase                                                      }
{ DESCRIPTION:                                                            }
{   Compute the phase (in radians) of complex vector elements.            }
{ PARAMETERS:                                                             }
{   src       - an input complex vector                                   }
{   phase     - an output vector to store the phase components;           }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }

nspcbPhase:procedure (Src : PSCplx; Phase : Psingle;  Len : Integer); stdcall;
nspzbPhase:procedure (Src : PDCplx; Phase : PDouble; Len : Integer); stdcall;
nspvbPhase:procedure (Src : PWCplx; Phase : Psmallint;  Len : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<w,s,d>brPhase                                                     }
{ DESCRIPTION:                                                            }
{   Compute the phase of complex data formed as two real vectors.         }
{ PARAMETERS:                                                             }
{   srcReal   - an input vector containing a real part of complex data    }
{   srcImag   - an input vector containing an imag. part of complex data  }
{   phase     - an output vector to store the magnitude components;       }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }

nspsbrPhase:procedure (SrcReal : Psingle;  SrcImag : Psingle;
                      Phase   : Psingle;  Len     : Integer); stdcall;
nspdbrPhase:procedure (SrcReal : PDouble; SrcImag : PDouble;
                      Phase   : PDouble; Len     : Integer); stdcall;
nspwbrPhase:procedure (SrcReal : Psmallint;  SrcImag : Psmallint;
                      Phase   : Psmallint;  Len     : Integer); stdcall;

{-------------------------------------------------------------------------}
{  bPowerSpectr, brPowerSpectr                                            }
{                                                                         }
{ Compute the power spectrum of complex vector.                           }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<v,c,z>bPowerSpectr                                                }
{ DESCRIPTION:                                                            }
{   Compute the power spectrum of complex vector.                         }
{ PARAMETERS:                                                             }
{   src       - an input complex vector                                   }
{   spectr    - an output vector to store the power spectrum components;  }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

nspcbPowerSpectr:procedure (Src         : PSCplx; Spectr : Psingle;
                           Len         : Integer); stdcall;
nspzbPowerSpectr:procedure (Src         : PDCplx; Spectr : PDouble;
                           Len         : Integer); stdcall;
nspvbPowerSpectr:procedure (Src         : PWCplx; Spectr : Psmallint;
                           Len         : Integer;
                           ScaleMode   : Integer;
                       var ScaleFactor : Integer); stdcall;

{ FUNCTION:                                                               }
{   nsp<w,s,d>brPowerSpectr                                               }
{ DESCRIPTION:                                                            }
{   Compute the power spectrum of complex data formed as two real vectors }
{ PARAMETERS:                                                             }
{   srcReal   - an input vector containing a real part of complex data    }
{   srcImag   - an input vector containing an imag. part of complex data  }
{   spectr    - an output vector to store the power spectrum components;  }
{   len       - a length of the arrays;                                   }
{ ERRORS:                                                                 }
{    1) Some of pointers to input or output data are NULL                 }
{    2) The length of the arrays is less or equal zero                    }
{  These errors are registered only if NSP_DEBUG is defined               }
{                                                                         }

nspsbrPowerSpectr:procedure (SrcReal     : Psingle;  SrcImag : Psingle;
                            Spectr      : Psingle;  Len     : Integer); stdcall;
nspdbrPowerSpectr:procedure (SrcReal     : PDouble; SrcImag : PDouble;
                            Spectr      : PDouble; Len     : Integer); stdcall;
nspwbrPowerSpectr:procedure (SrcReal     : Psmallint;  SrcImag : Psmallint;
                            Spectr      : Psmallint;  Len     : Integer;
                            ScaleMode   : Integer;
                        var ScaleFactor : Integer); stdcall;

{EOF}
(*
From:    nspdct.h
Purpose:
*)

const
  NSP_DCT_Forward = 1;
  NSP_DCT_Inverse = 2;
  NSP_DCT_Free    = 8;

var
nspsDct:procedure (Src, Dst : Psingle;  Len : Integer; Flags : Integer); stdcall;
nspdDct:procedure (Src, Dst : PDouble; Len : Integer; Flags : Integer); stdcall;
nspwDct:procedure (Src, Dst : Psmallint;  Len : Integer; Flags : Integer); stdcall;

{EOF}
(*
From:    nspdiv.h
Purpose: NSP Vector Arithmetics
*)

{-------------------------------------------------------------------------}
{                 Vector division functions                               }
{-------------------------------------------------------------------------}

{
  FUNCTION
    nsp?bDiv1

  DESCRIPTION
    Performs an element-wise division of elements
    of vectors and value.

       dst[i] /= val

  PARAMETERS
    val  value operand
    dst  Pointer to the input/output vector.
    n    The number of elements to be operated on.

  RETURN
    status
}
var

nspsbDiv1:function (Val : single;  Dst : Psingle;  N : Integer) : Integer; stdcall;
nspdbDiv1:function (Val : Double; Dst : PDouble; N : Integer) : Integer; stdcall;
nspwbDiv1:function (Val : smallint;  Dst : Psmallint;  N : Integer) : Integer; stdcall;
nspcbDiv1:function (Val : TSCplx; Dst : PSCplx;  N : Integer) : Integer; stdcall;
nspzbDiv1:function (Val : TDCplx; Dst : PDCplx;  N : Integer) : Integer; stdcall;
nspvbDiv1:function (Val : TWCplx; Dst : PWCplx;  N : Integer) : Integer; stdcall;

{
  FUNCTION
    nspsbDiv2

  DESCRIPTION
    Division the elements of two vectors and stores the results
    in the output array.

       dst[i] /= src[i]

  PARAMETERS
    src  Pointer to the vector to be Div
    dst  Pointer to the vector dst which stores the results
         of the Div operation src and dst.
    n    The number of elements to be operated on.

  RETURN
    status

}
nspsbDiv2:function (Src : Psingle;  Dst : Psingle;  N : Integer) : Integer; stdcall;
nspdbDiv2:function (Src : PDouble; Dst : PDouble; N : Integer) : Integer; stdcall;
nspwbDiv2:function (Src : Psmallint;  Dst : Psmallint;  N : Integer) : Integer; stdcall;
nspcbDiv2:function (Src : PSCplx;  Dst : PSCplx;  N : Integer) : Integer; stdcall;
nspzbDiv2:function (Src : PDCplx;  Dst : PDCplx;  N : Integer) : Integer; stdcall;
nspvbDiv2:function (Src : PWCplx;  Dst : PWCplx;  N : Integer) : Integer; stdcall;

{
  FUNCTION
    nspsbDiv3

  DESCRIPTION
    Performs an element-wise operation of elements
    of vectors and stores the results in a third.

       dst[i] = srcA[i] / srcB[i]

  PARAMETERS
    srcA Points to the first source vector
    srcB Pointers to the second source vector.
    dst  Pointer to the vector dst which stores the results
         of the Div operation srcA and srcB.
    n    The number of elements to be operated on.

  RETURN
    status
}

nspsbDiv3:function (SrcA, SrcB, Dst : Psingle;  N : Integer) : Integer; stdcall;
nspdbDiv3:function (SrcA, SrcB, Dst : PDouble; N : Integer) : Integer; stdcall;
nspwbDiv3:function (SrcA, SrcB, Dst : Psmallint;  N : Integer) : Integer; stdcall;
nspcbDiv3:function (SrcA, SrcB, Dst : PSCplx;  N : Integer) : Integer; stdcall;
nspzbDiv3:function (SrcA, SrcB, Dst : PDCplx;  N : Integer) : Integer; stdcall;
nspvbDiv3:function (SrcA, SrcB, Dst : PWCplx;  N : Integer) : Integer; stdcall;

{EOF}
(*
From:    nspdotp.h
Purpose: NSP Vector Product Functions
*)
var
nspsDotProd:function (SrcA, SrcB  : Psingle;  Len : Integer) : single;  stdcall;

function nspcDotProd(SrcA, SrcB  : PSCplx;  Len : Integer) : TSCplx; stdcall;

var
nspcDotProdOut:procedure (SrcA, SrcB : PSCplx; Len : Integer;
                     var Val : TSCplx); stdcall;
nspdDotProd:function (SrcA, SrcB  : PDouble; Len : Integer) : Double; stdcall;
nspzDotProd:function (SrcA, SrcB  : PDCplx;  Len : Integer) : TDCplx; stdcall;
nspwDotProd:function (SrcA, SrcB  : Psmallint;  Len : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer)                : smallint;  stdcall;
nspvDotProd:function (SrcA, SrcB  : PWCplx;  Len : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer)                : TWCplx; stdcall;

{ Extend Dot Prod functions }
nspwDotProdExt:function (SrcA, SrcB  : Psmallint; Len : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer) : Integer; stdcall;

function nspvDotProdExt(SrcA, SrcB  : PWCplx; Len : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer) : TICplx;  stdcall;

var
nspvDotProdExtOut: procedure (SrcA, SrcB  : PWCplx; Len : Integer;
                            ScaleMode   : Integer;
                        var ScaleFactor : Integer;
                        var Val         : TICplx); stdcall;

{EOF}
(*
From:    nsperror.h
Purpose: NSP Error Handling Module
*)

type
  PNSPLibVersion = ^TNSPLibVersion;
  TNSPLibVersion = record
    Major           : Integer;    // e.g. 4
    Minor           : Integer;    // e.g. 00
    Build           : Integer;    // e.g. 32
    Name            : Pansichar;      // e.g. "nspp6l.lib","nspm5.dll"
    Version         : Pansichar;      // e.g. "v4.00"
    InternalVersion : Pansichar;      // e.g. "[4.00.32, 17/03/98]"
    BuildDate       : Pansichar;      // e.g. "Mar 17 98"
    CallConv        : Pansichar;      // e.g. "DLL",..
  end;

{--- NSPErrStatus,NSPErrMode Values Definition ---}

//* common status code definitions */
const
  NSP_StsOk           =  0;         // everithing is ok
  NSP_StsBackTrace    = -1;         // pseudo error for back trace
  NSP_StsError        = -2;         // unknown /unspecified error
  NSP_StsInternal     = -3;         // internal error (bad state)
  NSP_StsNoMem        = -4;         // out of memory
  NSP_StsBadArg       = -5;         // function arg/param is bad
  NSP_StsBadFunc      = -6;         // unsupported function
  NSP_StsNoConv       = -7;         // iter. didn't converge
  NSP_StsAutoTrace    = -8;         // Tracing through nsptrace.h
  NSP_StsDivideByZero = -9;
  NSP_StsNullPtr      = -10;
  NSP_StsBadSizeValue = -11;
  NSP_StsBadPtr       = -12;
  NSP_StsBadStruct    = -13;
  NSP_StsBadLen       = -14;        // bad vector length

  NSP_ErrModeLeaf     = 0;          // Print error and exit program
  NSP_ErrModeParent   = 1;          // Print error and continue
  NSP_ErrModeSilent   = 2;          // Don't print and continue

//* custom status code definitions */
  //* nspsmpl */
  NSP_StsBadFact       = -50;        // Negative FactorRange
  //* nspfirg */
  NSP_StsBadFreq       = -51;        // bad frequency value
  NSP_StsBadRel        = -52;        // bad relation between frequency

type
  TNSPErrorCallBack = function(
    Status   : NSPStatus;
    FuncName : Pansichar;
    Context  : Pansichar;
    FileName : Pansichar;
    Line     : Integer) : Integer; stdcall;

{ Flags for scaleMode parameter of nsp?Func(...,scaleMode,scaleFactor)    }
const
  NSP_NO_SCALE    = $0000;        // ignore factor
  NSP_FIXED_SCALE = $0002;        // fixed factor value
  NSP_AUTO_SCALE  = $0004;        // detect factor value

  NSP_OVERFLOW    = $0000;        // wrapround
  NSP_SATURATE    = $0001;        // saturate

{--- Get Library Version -------------------------}
{ Returns pointer to NSP lib info structure       }
var
nspGetLibVersion :function:  PNSPLibVersion; stdcall;

{--- Get/Set ErrStatus ---------------------------}
nspGetErrStatus :function:  NSPStatus; stdcall;
nspSetErrStatus:procedure (Status : NSPStatus); stdcall;

{--- NspStdErrMode Declaration -------------------}
nspGetErrMode :function:  Integer; stdcall;
nspSetErrMode:procedure (Mode : Integer); stdcall;

{--- nspError,nspErrorStr Declaration ------------}
nspError:function (
  Status   : NSPStatus;
  Func     : Pansichar;
  Context  : Pansichar;
  FileName : Pansichar;
  Line     : integer) : NSPStatus; stdcall;
nspErrorStr:function (Status : NSPStatus) : Pansichar; stdcall;

{--- nspRedirectError Declaration ----------------}
nspNulDevReport:function (
  Status   : NSPStatus;
  FuncName : Pansichar;
  Context  : Pansichar;
  FileName : Pansichar;
  Line     : integer) : NSPStatus; stdcall;
nspStdErrReport:function (
  Status   : NSPStatus;
  FuncName : Pansichar;
  Context  : Pansichar;
  FileName : Pansichar;
  Line     : integer) : NSPStatus; stdcall;
nspGuiBoxReport:function (
  Status   : NSPStatus;
  FuncName : Pansichar;
  Context  : Pansichar;
  FileName : Pansichar;
  Line     : integer) : NSPStatus; stdcall;
nspRedirectError:function (
  nspErrorFunc : TNSPErrorCallBack) : TNSPErrorCallBack; stdcall;

{EOF}
(*
From:    nspfft.h
Purpose: NSP Fourier Transforms
*)

const
  NSP_Forw        =     1;
  NSP_Inv         =     2;
  NSP_Init        =     4;
  NSP_Free        =     8;
  NSP_NoScale     =    16;
  NSP_NoBitRev    =    32;
  NSP_InBitRev    =    64;
  NSP_OutBitRev   =   128;
  NSP_OutRCPack   =   256;
  NSP_OutRCPerm   =   512;
  NSP_InRCPack    =  1024;
  NSP_InRCPerm    =  4096;
  NSP_DoIntCore   =  8192;
  NSP_DoFloatCore = 16384;
  NSP_DoFastMMX   = 32768;

{------------------------------------------------------------------------}
{                                                                        }
{                                  Dft                                   }
{                                                                        }
{ Compute the forward  or inverse discrete Fourier transform  (DFT)      }
{ of a complex signal.                                                   }
{                                                                        }
{------------------------------------------------------------------------}
var

nspvDft:procedure (InSamps   : PWCplx;      OutSamps    : PWCplx;
                  Len       : Integer;     Flags       : Integer;
                  ScaleMode : Integer; var ScaleFactor : Integer); stdcall;
nspcDft:procedure (InSamps   : PSCplx;      OutSamps    : PSCplx;
                  Len       : Integer;     Flags       : Integer); stdcall;
nspzDft:procedure (InSamps   : PDCplx;      OutSamps    : PDCplx;
                  Len       : Integer;     Flags       : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                                  Fft                                   }
{                                                                        }
{ Compute  the forward  or inverse   fast Fourier  transform (FFT)       }
{ of a complex signal.                                                   }
{                                                                        }
{------------------------------------------------------------------------}

nspvFft:procedure (Samps       : PWCplx;
                     Order       : Integer;  Flags    : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer); stdcall;
nspcFft:procedure (Samps       : PSCplx;
                     Order       : Integer;  Flags    : Integer); stdcall;
nspzFft:procedure (Samps       : PDCplx;
                     Order       : Integer;  Flags    : Integer); stdcall;

nspvFftNip:procedure (InSamps     : PWCplx;   OutSamps : PWCplx;
                     Order       : Integer;  Flags    : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer); stdcall;
nspcFftNip:procedure (InSamps     : PSCplx;   OutSamps : PSCplx;
                     Order       : Integer;  Flags    : Integer); stdcall;
nspzFftNip:procedure (InSamps     : PDCplx;   OutSamps : PDCplx;
                     Order       : Integer;  Flags    : Integer); stdcall;

nspvrFft:procedure (ReSamps     : Psmallint;   ImSamps  : Psmallint;
                     Order       : Integer;  Flags    : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer); stdcall;
nspcrFft:procedure (ReSamps     : Psingle;   ImSamps  : Psingle;
                     Order       : Integer;  Flags    : Integer); stdcall;
nspzrFft:procedure (ReSamps     : PDouble;  ImSamps  : PDouble;
                     Order       : Integer;  Flags    : Integer); stdcall;

nspvrFftNip:procedure (ReInSamps   : Psmallint;   ImInSamps  : Psmallint;
                      ReOutSamps  : Psmallint;   ImOutSamps : Psmallint;
                      Order       : Integer;  Flags      : Integer;
                      ScaleMode   : Integer;
                  var ScaleFactor : Integer); stdcall;
nspcrFftNip:procedure (ReInSamps   : Psingle;   ImInSamps  : Psingle;
                      ReOutSamps  : Psingle;   ImOutSamps : Psingle;
                      Order       : Integer;  Flags      : Integer); stdcall;
nspzrFftNip:procedure (ReInSamps   : PDouble;  ImInSamps  : PDouble;
                      ReOutSamps  : PDouble;  ImOutSamps : PDouble;
                      Order       : Integer;  Flags      : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                         RealFftl, RealFftlNip                          }
{                                                                        }
{ Compute the  forward or inverse FFT  of a real signal  using RCPack or }
{ RCPerm format.                                                         }
{                                                                        }
{------------------------------------------------------------------------}

nspwRealFftl:procedure (Samps       : Psmallint;
                       Order       : Integer; Flags : Integer;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer); stdcall;
nspsRealFftl:procedure (Samps       : Psingle;
                       Order       : Integer; Flags : Integer); stdcall;
nspdRealFftl:procedure (Samps       : PDouble;
                       Order       : Integer; Flags : Integer); stdcall;

nspwRealFftlNip:procedure (InSamps     : Psmallint;   OutSamps : Psmallint;
                          Order       : Integer;  Flags    : Integer;
                          ScaleMode   : Integer;
                      var ScaleFactor : Integer); stdcall;
nspsRealFftlNip:procedure (InSamps     : Psingle;   OutSamps : Psingle;
                          Order       : Integer;  Flags    : Integer); stdcall;
nspdRealFftlNip:procedure (InSamps     : PDouble;  OutSamps : PDouble;
                          Order       : Integer;  Flags    : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                            CcsFftl, CcsFftlNip                         }
{                                                                        }
{ Compute the  forward or inverse  FFT of a  complex conjugate-symmetric }
{ (CCS) signal using RCPack or RCPerm format.                            }
{                                                                        }
{------------------------------------------------------------------------}

nspwCcsFftl:procedure (Samps       : Psmallint;
                         Order       : Integer;  Flags : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
nspsCcsFftl:procedure (Samps       : Psingle;
                         Order       : Integer;  Flags : Integer); stdcall;
nspdCcsFftl:procedure (Samps       : PDouble;
                         Order       : Integer;  Flags : Integer); stdcall;

nspwCcsFftlNip:procedure (InSamps     : Psmallint;   OutSamps : Psmallint;
                         Order       : Integer;  Flags : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
nspsCcsFftlNip:procedure (InSamps     : Psingle;   OutSamps : Psingle;
                         Order       : Integer;  Flags    : Integer); stdcall;
nspdCcsFftlNip:procedure (InSamps     : PDouble;  OutSamps : PDouble;
                         Order       : Integer;  Flags    : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                       MpyRCPack2, MpyRCPack3                           }
{                                                                        }
{ Multiply two vectors stored in RCPack format.                          }
{                                                                        }
{------------------------------------------------------------------------}

nspwMpyRCPack2:procedure (Src         : Psmallint;  Dst : Psmallint;
                         Order       : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
nspsMpyRCPack2:procedure (Src         : Psingle;  Dst : Psingle;
                         Order       : Integer); stdcall;
nspdMpyRCPack2:procedure (Src         : PDouble; Dst : PDouble;
                         Order       : Integer); stdcall;

nspwMpyRCPack3:procedure (SrcA        : Psmallint;   SrcB : Psmallint;  Dst : Psmallint;
                         Order       : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
nspsMpyRCPack3:procedure (SrcA        : Psingle;   SrcB : Psingle;  Dst : Psingle;
                         Order       : Integer); stdcall;
nspdMpyRCPack3:procedure (SrcA        : PDouble;  SrcB : PDouble; Dst : PDouble;
                         Order       : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                        MpyRCPerm2, MpyRCPerm3                          }
{                                                                        }
{ Multiply two vectors stored in RCPerm format.                          }
{                                                                        }
{------------------------------------------------------------------------}

nspwMpyRCPerm2:procedure (Src         : Psmallint;   Dst : Psmallint;
                         Order       : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
nspsMpyRCPerm2:procedure (Src         : Psingle;   Dst : Psingle;
                         Order       : Integer); stdcall;
nspdMpyRCPerm2:procedure (Src         : PDouble;  Dst : PDouble;
                         Order       : Integer); stdcall;

nspwMpyRCPerm3:procedure (SrcA        : Psmallint;   SrcB : Psmallint;  Dst : Psmallint;
                         Order       : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
nspsMpyRCPerm3:procedure (SrcA        : Psingle;   SrcB : Psingle;  Dst : Psingle;
                         Order       : Integer); stdcall;
nspdMpyRCPerm3:procedure (SrcA        : PDouble;  SrcB : PDouble; Dst : PDouble;
                         Order       : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                        RealFft,  RealFftNip                            }
{                                                                        }
{ Compute the forward or inverse FFT of a real signal.                   }
{                                                                        }
{------------------------------------------------------------------------}

nspwRealFft:procedure (Samps       : Psmallint;
                         Order       : Integer;  Flags : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
nspsRealFft:procedure (Samps       : Psingle;
                         Order       : Integer;  Flags : Integer); stdcall;
nspdRealFft:procedure (Samps       : PDouble;
                         Order       : Integer;  Flags : Integer); stdcall;

nspwRealFftNip:procedure (InSamps     : Psmallint;   OutSamps : PWCplx;
                         Order       : Integer;  Flags    : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
nspsRealFftNip:procedure (InSamps     : Psingle;   OutSamps : PSCplx;
                         Order       : Integer;  Flags    : Integer); stdcall;
nspdRealFftNip:procedure (InSamps     : PDouble;  OutSamps : PDCplx;
                         Order       : Integer;  Flags    : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                            CcsFft, CcsFftNip                           }
{                                                                        }
{ Compute the  forward or inverse  FFT of a  complex conjugate-symmetric }
{ (CCS) signal.                                                          }
{                                                                        }
{------------------------------------------------------------------------}

nspwCcsFft:procedure (Samps       : Psmallint;
                        Order       : Integer;  Flags : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer); stdcall;
nspsCcsFft:procedure (Samps       : Psingle;
                        Order       : Integer;  Flags : Integer); stdcall;
nspdCcsFft:procedure (Samps       : PDouble;
                        Order       : Integer;  Flags : Integer); stdcall;

nspwCcsFftNip:procedure (InSamps     : PWCplx;   OutSamps : Psmallint;
                        Order       : Integer;  Flags    : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer); stdcall;
nspsCcsFftNip:procedure (InSamps     : PSCplx;   OutSamps : Psingle;
                        Order       : Integer;  Flags    : Integer); stdcall;
nspdCcsFftNip:procedure (InSamps     : PDCplx;   OutSamps : PDouble;
                        Order       : Integer;  Flags    : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                    nsp?Real2Fft, nsp?Real2FftNip                       }
{                                                                        }
{ Compute the forward or inverse FFT of two real signals.                }
{                                                                        }
{------------------------------------------------------------------------}

nspwReal2Fft:procedure (XSamps      : Psmallint;   YSamps    : Psmallint;
                          Order       : Integer;  Flags     : Integer;
                          ScaleMode   : Integer;
                      var ScaleFactor : Integer); stdcall;
nspsReal2Fft:procedure (XSamps      : Psingle;   YSmaps    : Psingle;
                          Order       : integer;  Flags     : Integer); stdcall;
nspdReal2Fft:procedure (XSamps      : PDouble;  YSmaps    : PDouble;
                          Order       : integer;  Flags     : Integer); stdcall;

nspwReal2FftNip:procedure (XInSamps    : Psmallint;   XOutSamps : PWCplx;
                          YInSamps    : Psmallint;   YOutSamps : PWCplx;
                          Order       : Integer;  Flags     : Integer;
                          ScaleMode   : Integer;
                      var ScaleFactor : Integer); stdcall;
nspsReal2FftNip:procedure (XInSamps    : Psingle;   XOutSamps : PSCplx;
                          YInSamps    : Psingle;   YOutSamps : PSCplx;
                          Order       : Integer;  Flags     : Integer); stdcall;
nspdReal2FftNip:procedure (XInSamps    : PDouble;  XOutSamps : PDCplx;
                          YInSamps    : PDouble;  YOutSamps : PDCplx;
                          Order       : Integer;  Flags     : Integer); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                    nsp?Ccs2Fft, nsp?Ccs2FftNip                         }
{                                                                        }
{ Compute the forward or reverse  FFT of two complex conjugate-symmetric }
{ (CCS) signals.                                                         }
{                                                                        }
{------------------------------------------------------------------------}

nspwCcs2Fft:procedure (XSamps      : Psmallint;  YSamps     : Psmallint;
                         Order       : Integer;  Flags     : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
nspsCcs2Fft:procedure (XSamps      : Psingle;   YSamps    : Psingle;
                         Order       : Integer;  Flags     : Integer); stdcall;
nspdCcs2Fft:procedure (XSamps      : PDouble;  YSamps    : PDouble;
                         Order       : Integer;  Flags     : Integer); stdcall;

nspwCcs2FftNip:procedure (XInSamps    : PWCplx;   XOutSamps : Psmallint;
                         YInSamps    : PWCplx;   YOutSamps : Psmallint;
                         Order       : Integer;  Flags     : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer); stdcall;
nspsCcs2FftNip:procedure (XInSamps    : PSCplx;   XOutSamps : Psingle;
                         YInSamps    : PSCplx;   YOutSamps : Psingle;
                         Order       : Integer;  Flags     : Integer); stdcall;
nspdCcs2FftNip:procedure (XInSamps    : PDCplx;   XOutSamps : PDouble;
                         YInSamps    : PDCplx;   YOutSamps : PDouble;
                         Order       : Integer;  Flags     : Integer); stdcall;

{EOF}
(*
From:    nspfir2.h
Purpose: Filter2D
*)

nspsFilter2D:procedure (X           : Psingle;   XCols : Integer; XRows : Integer;
                       H           : Psingle;   HCols : Integer; HRows : Integer;
                       Y           : Psingle);  stdcall;
nspdFilter2D:procedure (X           : PDouble;  XCols : Integer; XRows : Integer;
                       H           : PDouble;  HCols : Integer; HRows : Integer;
                       Y           : PDouble); stdcall;
nspwFilter2D:procedure (X           : Psmallint;   XCols : Integer; XRows : Integer;
                       H           : Psingle;   HCols : Integer; HRows : Integer;
                       Y           : Psmallint;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer); stdcall;

{EOF}
(*
From:    nspfirg.h
Purpose: Declaration of FIR filters design functions and structures.
Author:  Michael S. Kulikov.

  FUNCTIONS:
      nspdFirLowpass   -
                 computes the lowpass FIR filter coefficients;

      nspdFirHighpass  -
                 computes the highpass FIR filter coefficients;

      nspdFirBandpass  -
                 computes the bandpass FIR filter coefficients;

      nspdFirBandstop  -
                 computes the bandstop FIR filter coefficients.

  ARGUMENTS:
      rLowFreq  -
                 low frequency (0 < rLowFreq < 0.5);

      rHighFreq -
                 high frequency (0 < rHighFreq < 0.5)
                 (the condition rLowFreq < rHighFreq must be true!);

      taps      -
                 pointer to the array which specifies
                 the filter coefficients;

      tapsLen   -
                 the number of taps in taps[] array (tapsLen>=5);

      winType   -
                 the NSP_WindowType switch variable,
                 which specifies the smoothing window type;

      doNormal  -
                 if doNormal=0 the functions calculates
                 non-normalized sequence of filter coefficients,
                 in other cases the sequence of coefficients
                 will be normalized.

  RETURN:
      value from  NSP_fStatus enum.

  ENUMS:
      NSP_WindowType -
                 NSP_WinRect         no smoothing (smoothing by
                                     rectangular window);
                 NSP_WinBartlett     smoothing by Bartlett window;
                 NSP_WinBlackmanOpt  smoothing by optimal
                                     Blackman window;
                 NSP_WinHamming      smoothing by Hamming window;
                 NSP_WinHann         smoothing by Hann window.

      Return    -
                NSP_StsOk            no error;
                NSP_StsNullPtr       the null pointer to taps[] array pass
                                     to function;
                NSP_StsBadLen        the length of coefficient is less five;
                NSP_StsBadFreq       the low or high frequency isn’t satisfy
                                     the condition 0 < rLowFreq < 0.5;
                NSP_StsBadRel        the high frequency is less low.

*)

type
  TNSP_WindowType = (
    NSP_WinRect,
    NSP_WinBartlett,
    NSP_WinBlackmanOpt,
    NSP_WinHamming,
    NSP_WinHann);

var

nspdFirLowpass:function (RFreq     : Double;
                         Taps      : PDouble;
                         TapsLen   : Integer;
                         WinType   : TNSP_WindowType;
                         DoNormal  : Integer) : Integer; stdcall;

nspdFirHighpass:function (RFreq     : Double;
                         Taps      : PDouble;
                         TapsLen   : Integer;
                         WinType   : TNSP_WindowType;
                         DoNormal  : Integer) : Integer; stdcall;

nspdFirBandpass:function (RLowFreq  : Double;
                         RHighFreq : Double;
                         Taps      : PDouble;
                         TapsLen   : Integer;
                         WinType   : TNSP_WindowType;
                         DoNormal  : Integer) : Integer; stdcall;

nspdFirBandstop:function (RLowFreq  : Double;
                         RHighFreq : Double;
                         Taps      : PDouble;
                         TapsLen   : Integer;
                         WinType   : TNSP_WindowType;
                         DoNormal  : Integer) : Integer; stdcall;

{EOF}
(*
From:    nspfirh.h
Purpose: NSP Finite Impulse Response high-level filter.
*)

{=== FIR high-level ======================================================}

type
  PFirSect = ^TFirSect;
  TFirSect = record
    Num : Integer;                 // section number
    Len : Integer;                 // section taps length in use
    XId : Integer;                 // section input data index
    TId : Integer;                 // section taps index
  end;

  PNSPFirState = ^TNSPFirState;
  TNSPFirState = record
    UpFactor    : Integer;         // up
    UpPhase     : Integer;         //   parameters
    DownFactor  : Integer;         // down
    DownPhase   : Integer;         //   parameters
    IsMultiRate : Integer;         // multi-rate mode flag
    IsInit      : Pointer;         // init flag

    TapsLen     : Integer;         // number of filter taps
    TapsBlk     : Integer;
    Taps        : Pointer;         // taps pointer in use

    DlylLen     : Integer;         // delay line length
    InpLen      : Integer;         // input buffer length
    UseInp      : Integer;         // input buffer length used
    Dlyl        : Pointer;         // extended dilter delay line
    DlylLimit   : Pointer;         // delay line buffer end pointer
    UseDlyl     : Pointer;         // delay line pointer in use

    Sect        : PFirSect;        // FIR sections

    TapsFactor  : Integer;         // taps scale factor
    UTapsLen    : Integer;         // number of filter taps (user def)
  end;

{-------------------------------------------------------------------------}
{ nsp?FirInit(), nsp?FirInitMr()                                          }
{ nspFirFree()                                                            }
{                                                                         }
{ Initialize a finite impulse response high-level (FIRH) filter           }

var
nspsFirInit:procedure (TapVals    : Psingle;  TapsLen   : Integer;
                         DlyVals    : Psingle;
                     var State      : TNSPFirState); stdcall;
nspcFirInit:procedure (TapVals    : PSCplx;  TapsLen   : Integer;
                         DlyVals    : PSCplx;
                     var State      : TNSPFirState); stdcall;
nspdFirInit:procedure (TapVals    : PDouble; TapsLen   : Integer;
                         DlyVals    : PDouble;
                     var State      : TNSPFirState); stdcall;
nspzFirInit:procedure (TapVals    : PDCplx;  TapsLen   : Integer;
                         DlyVals    : PDCplx;
                     var State      : TNSPFirState); stdcall;
nspwFirInit:procedure (TapVals    : Psingle;  TapsLen   : Integer;
                         DlyVals    : Psmallint;
                     var State      : TNSPFirState); stdcall;

nspsFirInitMr:procedure (TapVals    : Psingle;  TapsLen   : Integer;
                         DlyVals    : Psingle;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var State      : TNSPFirState); stdcall;
nspcFirInitMr:procedure (TapVals    : PSCplx;  TapsLen   : Integer;
                         DlyVals    : PSCplx;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var State      : TNSPFirState); stdcall;
nspdFirInitMr:procedure (TapVals    : PDouble; TapsLen   : Integer;
                         DlyVals    : PDouble;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var State      : TNSPFirState); stdcall;
nspzFirInitMr:procedure (TapVals    : PDCplx;  TapsLen   : Integer;
                         DlyVals    : PDCplx;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var State      : TNSPFirState); stdcall;
nspwFirInitMr:procedure (TapVals    : Psingle;  TapsLen   : Integer;
                         DlyVals    : Psmallint;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var State      : TNSPFirState); stdcall;

nspFirFree:procedure (var State      : TNSPFirState); stdcall;

{-------------------------------------------------------------------------}
{ nsp?Fir(), nsp?bFir()                                                   }
{                                                                         }
{ Dot and block product FIRH filtering                                    }

var

nspsFir:function (var State       : TNSPFirState; Samp : single)  : single;  stdcall;

function nspcFir(var State       : TNSPFirState; Samp : TSCplx) : TSCplx; stdcall;

var
nspcFirOut:procedure (var State : TNSPFirState;
                         Samp  : TSCplx;
                     var Val   : TSCplx); stdcall;

nspdFir:function (var State       : TNSPFirState; Samp : Double) : Double; stdcall;
nspzFir:function (var State       : TNSPFirState; Samp : TDCplx) : TDCplx; stdcall;

nspwFir:function (var State       : TNSPFirState; Samp : smallint;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer) : smallint; stdcall;

nspsbFir:procedure (var State       : TNSPFirState; InSamps  : Psingle;
                       OutSamps    : Psingle;       NumIters : Integer); stdcall;
nspcbFir:procedure (var State       : TNSPFirState; InSamps  : PSCplx;
                       OutSamps    : PSCplx;       NumIters : Integer); stdcall;

nspdbFir:procedure (var State       : TNSPFirState; InSamps  : PDouble;
                       OutSamps    : PDouble;      NumIters : Integer); stdcall;
nspzbFir:procedure (var State       : TNSPFirState; InSamps  : PDCplx;
                       OutSamps    : PDCplx;       NumIters : Integer); stdcall;

nspwbFir:procedure (var State       : TNSPFirState; InSamps  : Psmallint;
                       OutSamps    : Psmallint;       NumIters : Integer;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer); stdcall;

{-------------------------------------------------------------------------}
{ nsp?FirGetTaps(), nsp?FirSetTaps()                                      }
{                                                                         }
{ Utility functions to get and set the FIR taps coefficients              }

nspsFirGetTaps:procedure (const State : TNSPFirState; OutTaps : Psingle);  stdcall;
nspcFirGetTaps:procedure (const State : TNSPFirState; OutTaps : PSCplx);  stdcall;

nspdFirGetTaps:procedure (const State : TNSPFirState; OutTaps : PDouble); stdcall;
nspzFirGetTaps:procedure (const State : TNSPFirState; OutTaps : PDCplx);  stdcall;

nspwFirGetTaps:procedure (const State : TNSPFirState; OutTaps : Psingle);  stdcall;

nspsFirSetTaps:procedure (InTaps : Psingle;  var State : TNSPFirState); stdcall;
nspcFirSetTaps:procedure (InTaps : PSCplx;  var State : TNSPFirState); stdcall;

nspdFirSetTaps:procedure (InTaps : PDouble; var State : TNSPFirState); stdcall;
nspzFirSetTaps:procedure (InTaps : PDCplx;  var State : TNSPFirState); stdcall;

nspwFirSetTaps:procedure (InTaps : Psingle;  var State : TNSPFirState); stdcall;

{-------------------------------------------------------------------------}
{ nsp?FirGetDlyl(), nsp?FirSetDlyl()                                      }
{                                                                         }
{ Utility functions to get and set the FIR delay line contents            }

nspsFirGetDlyl:procedure (const State : TNSPFirState; OutDlyl : Psingle);  stdcall;
nspcFirGetDlyl:procedure (const State : TNSPFirState; OutDlyl : PSCplx);  stdcall;

nspdFirGetDlyl:procedure (const State : TNSPFirState; OutDlyl : PDouble); stdcall;
nspzFirGetDlyl:procedure (const State : TNSPFirState; OutDlyl : PDCplx);  stdcall;

nspwFirGetDlyl:procedure (const State : TNSPFirState; OutDlyl : Psmallint);  stdcall;

nspsFirSetDlyl:procedure (InDlyl : Psingle;  var State : TNSPFirState); stdcall;
nspcFirSetDlyl:procedure (InDlyl : PSCplx;  var State : TNSPFirState); stdcall;

nspdFirSetDlyl:procedure (InDlyl : PDouble; var State : TNSPFirState); stdcall;
nspzFirSetDlyl:procedure (InDlyl : PDCplx;  var State : TNSPFirState); stdcall;

nspwFirSetDlyl:procedure (InDlyl : Psmallint;  var State : TNSPFirState); stdcall;

{EOF}
(*
From:    nspfirl.h
Purpose: NSP Finite Impulse Response low level filter
*)

{--- FIR low level filter structure -------------------------------------}

type
  TFirLmsTapState = record
    Taps         : Pointer;
    Len          : Integer;
    UpFactor     : Integer;
    UpPhase      : Integer;
    DownFactor   : Integer;
    DownPhase    : Integer;
    IsMultiRate  : Integer;
    IsFilterMode : Integer;
  end;

  TFirLmsDlyState = record
    Dlyl         : Pointer;
    Len          : Integer;
    IsFilterMode : Integer;
  end;

{--- Finite impulse response filter -------------------------------------}

  TNSPFirTapState = record
    FirLmsTapState : TFirLmsTapState;
    TapsFactor     : Integer;
  end;

{--- Delay line of FIR low level filter ---------------------------------}

  TNSPFirDlyState = TFirLmsDlyState;

{------------------------------------------------------------------------}
{        FirlInit, FirlInitMr, FirlInitDlyl                              }
{                                                                        }
{ Low level functions for cyclic FIR filtering via a tapped delay line.  }

var
nspsFirlInit:procedure (Taps  : Psingle;  TapsLen : Integer;
                   var TapSt : TNSPFirTapState); stdcall;
nspdFirlInit:procedure (Taps  : PDouble; TapsLen : Integer;
                   var TapSt : TNSPFirTapState); stdcall;
nspcFirlInit:procedure (Taps  : PSCplx;  TapsLen : Integer;
                   var TapSt : TNSPFirTapState); stdcall;
nspzFirlInit:procedure (Taps  : PDCplx;  TapsLen : Integer;
                   var TapSt : TNSPFirTapState); stdcall;
nspwFirlInit:procedure (Taps  : Psingle;  TapsLen : Integer;
                   var TapSt : TNSPFirTapState); stdcall;

nspsFirlInitMr:procedure (Taps       : Psingle;  TapsLen   : Integer;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var TapSt      : TNSPFirTapState);    stdcall;
nspdFirlInitMr:procedure (Taps       : PDouble; TapsLen   : Integer;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var TapSt      : TNSPFirTapState);    stdcall;
nspcFirlInitMr:procedure (Taps       : PSCplx;  TapsLen   : Integer;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var TapSt      : TNSPFirTapState);    stdcall;
nspzFirlInitMr:procedure (Taps       : PDCplx;  TapsLen   : Integer;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var TapSt      : TNSPFirTapState);    stdcall;
nspwFirlInitMr:procedure (Taps       : Psingle;  TapsLen   : Integer;
                         UpFactor   : Integer; UpPhase   : Integer;
                         DownFactor : Integer; DownPhase : Integer;
                     var TapSt      : TNSPFirTapState);    stdcall;

nspsFirlInitDlyl:procedure (var TapSt : TNSPFirTapState; Dlyl : Psingle;
                           var DlySt : TNSPFirDlyState); stdcall;
nspcFirlInitDlyl:procedure (var TapSt : TNSPFirTapState; Dlyl : PSCplx;
                           var DlySt : TNSPFirDlyState); stdcall;
nspdFirlInitDlyl:procedure (var TapSt : TNSPFirTapState; Dlyl : PDouble;
                           var DlySt : TNSPFirDlyState); stdcall;
nspzFirlInitDlyl:procedure (var TapSt : TNSPFirTapState; Dlyl : PDCplx;
                           var DlySt : TNSPFirDlyState); stdcall;
nspwFirlInitDlyl:procedure (var TapSt : TNSPFirTapState; Dlyl : Psmallint;
                           var DlySt : TNSPFirDlyState); stdcall;

{------------------------------------------------------------------------}
{        Firl, bFirl                                                     }
{                                                                        }
{ Filter either a single sample or  block of samples through a low-level }
{ FIR filter.                                                            }

var

nspsFirl:function (var TapSt       : TNSPFirTapState;
                  var DlySt       : TNSPFirDlyState;
                      Samp        : single)   : single; stdcall;

function nspcFirl(var TapSt       : TNSPFirTapState;
                  var DlySt       : TNSPFirDlyState;
                      Samp        : TSCplx)  : TSCplx; stdcall;

var
nspcFirlOut:procedure (var TapSt   : TNSPFirTapState;
                      var DlySt   : TNSPFirDlyState;
                          Samp    : TSCplx;
                      var Val     : TSCplx); stdcall;

nspdFirl:function (var TapSt       : TNSPFirTapState;
                  var DlySt       : TNSPFirDlyState;
                      Samp        : Double)  : Double; stdcall;
nspzFirl:function (var TapSt       : TNSPFirTapState;
                  var DlySt       : TNSPFirDlyState;
                      Samp        : TDCplx)  : TDCplx; stdcall;
nspwFirl:function (var TapSt       : TNSPFirTapState;
                  var DlySt       : TNSPFirDlyState;
                      Samp        : smallint;
                      ScaleMode   : Integer;
                  var ScaleFactor : Integer) : smallint; stdcall;

nspsbFirl:procedure (var TapSt       : TNSPFirTapState;
                    var DlySt       : TNSPFirDlyState;
                        InSamps     : Psingle;  OutSamps  : Psingle;
                        NumIters    : Integer); stdcall;
nspcbFirl:procedure (var TapSt       : TNSPFirTapState;
                    var DlySt       : TNSPFirDlyState;
                        InSamps     : PSCplx;  OutSamps  : PSCplx;
                        NumIters    : Integer); stdcall;
nspdbFirl:procedure (var TapSt       : TNSPFirTapState;
                    var DlySt       : TNSPFirDlyState;
                        InSamps     : PDouble; OutSamps  : PDouble;
                        NumIters    : Integer); stdcall;
nspzbFirl:procedure (var TapSt       : TNSPFirTapState;
                    var DlySt       : TNSPFirDlyState;
                        InSamps     : PDCplx;  OutSamps  : PDCplx;
                        NumIters    : Integer); stdcall;
nspwbFirl:procedure (var TapSt       : TNSPFirTapState;
                    var DlySt       : TNSPFirDlyState;
                        InSamps     : Psmallint;  OutSamps  : Psmallint;
                        NumIters    : Integer; ScaleMode : Integer;
                    var ScaleFactor : Integer); stdcall;

{------------------------------------------------------------------------}
{        FirlGetTaps, FirlSetTaps                                        }
{                                                                        }
{ Utility functions to get and set the tap coefficients of low-level FIR }
{ filters.                                                               }

nspsFirlGetTaps:procedure (var TapSt : TNSPFirTapState; OutTaps : Psingle);  stdcall;
nspcFirlGetTaps:procedure (var TapSt : TNSPFirTapState; OutTaps : PSCplx);  stdcall;
nspdFirlGetTaps:procedure (var TapSt : TNSPFirTapState; OutTaps : PDouble); stdcall;
nspzFirlGetTaps:procedure (var TapSt : TNSPFirTapState; OutTaps : PDCplx);  stdcall;
nspwFirlGetTaps:procedure (var TapSt : TNSPFirTapState; OutTaps : Psingle);  stdcall;

nspsFirlSetTaps:procedure (InTaps : Psingle;  var TapSt : TNSPFirTapState); stdcall;
nspcFirlSetTaps:procedure (InTaps : PSCplx;  var TapSt : TNSPFirTapState); stdcall;
nspdFirlSetTaps:procedure (InTaps : PDouble; var TapSt : TNSPFirTapState); stdcall;
nspzFirlSetTaps:procedure (InTaps : PDCplx;  var TapSt : TNSPFirTapState); stdcall;
nspwFirlSetTaps:procedure (InTaps : Psingle;  var TapSt : TNSPFirTapState); stdcall;

{------------------------------------------------------------------------}
{        FirlGetDlyl, FirlSetDlyl                                        }
{                                                                        }
{ Utility functions to get and set  the delay line contents of low-level }
{ FIR filters.                                                           }

nspsFirlGetDlyl:procedure (var TapSt   : TNSPFirTapState;
                          var DlySt   : TNSPFirDlyState;
                              OutDlyl : Psingle);  stdcall;
nspcFirlGetDlyl:procedure (var TapSt   : TNSPFirTapState;
                          var DlySt   : TNSPFirDlyState;
                              OutDlyl : PSCplx);  stdcall;
nspdFirlGetDlyl:procedure (var TapSt   : TNSPFirTapState;
                          var DlySt   : TNSPFirDlyState;
                              OutDlyl : PDouble); stdcall;
nspzFirlGetDlyl:procedure (var TapSt   : TNSPFirTapState;
                          var DlySt   : TNSPFirDlyState;
                              OutDlyl : PDCplx);  stdcall;
nspwFirlGetDlyl:procedure (var TapSt   : TNSPFirTapState;
                          var DlySt   : TNSPFirDlyState;
                              OutDlyl : Psmallint);  stdcall;

nspsFirlSetDlyl:procedure (var TapSt   : TNSPFirTapState;
                              InDlyl  : Psingle;
                          var DlySt   : TNSPFirDlyState); stdcall;
nspcFirlSetDlyl:procedure (var TapSt   : TNSPFirTapState;
                              InDlyl  : PSCplx;
                          var DlySt   : TNSPFirDlyState); stdcall;
nspdFirlSetDlyl:procedure (var TapSt   : TNSPFirTapState;
                              InDlyl  : PDouble;
                          var DlySt   : TNSPFirDlyState); stdcall;
nspzFirlSetDlyl:procedure (var TapSt   : TNSPFirTapState;
                              InDlyl  : PDCplx;
                          var DlySt   : TNSPFirDlyState); stdcall;
nspwFirlSetDlyl:procedure (var TapSt   : TNSPFirTapState;
                              InDlyl  : Psmallint;
                          var DlySt   : TNSPFirDlyState); stdcall;

{EOF}
(*
From:    nspgrtzl.h, nspgrtzw.h
Purpose: NSP Single Frequency DFT (Goertzel)
*)

{ Single Frequency DFT structures.                                       }

type
  TNSPSGoertzState = record
    Freq    : single;
    CosV    : single;
    SinV    : single;
    CpcV    : single;
    Prev2Re : single;
    Prev2Im : single;
    Prev1Re : single;
    Prev1Im : single;
  end;

  TNSPCGoertzState = TNSPSGoertzState;
  TNSPWGoertzState = TNSPSGoertzState;
  TNSPVGoertzState = TNSPSGoertzState;

  TNSPDGoertzState = record
    Freq    : Double;
    CosV    : Double;
    SinV    : Double;
    CpcV    : Double;
    Prev2Re : Double;
    Prev2Im : Double;
    Prev1Re : Double;
    Prev1Im : Double;
  end;

  TNSPZGoertzState = TNSPDGoertzState;
{------------------------------------------------------------------------}
{        GoertzInit                                                      }
{                                                                        }
{ Initializes the coefficients and zeros the delay line.                 }

var

nspsGoertzInit:procedure (Freq : single;  var State : TNSPSGoertzState); stdcall;
nspcGoertzInit:procedure (Freq : single;  var State : TNSPCGoertzState); stdcall;
nspdGoertzInit:procedure (Freq : Double; var State : TNSPDGoertzState); stdcall;
nspzGoertzInit:procedure (Freq : Double; var State : TNSPZGoertzState); stdcall;
nspwGoertzInit:procedure (Freq : single;  var State : TNSPWGoertzState); stdcall;
nspvGoertzInit:procedure (Freq : single;  var State : TNSPVGoertzState); stdcall;

{------------------------------------------------------------------------}
{        GoertzReset                                                     }
{                                                                        }
{ Zeros the delay line.                                                  }

nspsGoertzReset:procedure (var State : TNSPSGoertzState); stdcall;
nspcGoertzReset:procedure (var State : TNSPCGoertzState); stdcall;
nspdGoertzReset:procedure (var State : TNSPDGoertzState); stdcall;
nspzGoertzReset:procedure (var State : TNSPZGoertzState); stdcall;
nspwGoertzReset:procedure (var State : TNSPWGoertzState); stdcall;
nspvGoertzReset:procedure (var State : TNSPVGoertzState); stdcall;

{------------------------------------------------------------------------}
{        Goertz                                                          }
{                                                                        }
{ Single Frequency DFT (Goertzel algorithm)                              }

function nspsGoertz (var State       : TNSPSGoertzState;
                         Sample      : single)   : TSCplx; stdcall;

function nspcGoertz(var State       : TNSPCGoertzState;
                         Sample      : TSCplx)  : TSCplx; stdcall;
var
nspdGoertz:function (var State       : TNSPDGoertzState;
                         Sample      : Double)  : TDCplx; stdcall;
nspzGoertz:function (var State       : TNSPZGoertzState;
                         Sample      : TDCplx)  : TDCplx; stdcall;
nspwGoertz:function (var State       : TNSPWGoertzState;
                         Sample      : smallint;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer) : TWCplx; stdcall;
nspvGoertz:function (var State       : TNSPVGoertzState;
                         Sample      : TWCplx;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer) : TWCplx; stdcall;

function nspsbGoertz (var State       : TNSPSGoertzState;
                         InSamps     : Psingle;
                         Len         : Integer) : TSCplx; stdcall;


function nspcbGoertz(var State       : TNSPCGoertzState;
                         InSamps     : PSCplx;
                         Len         : Integer) : TSCplx; stdcall;
var

nspdbGoertz:function (var State       : TNSPDGoertzState;
                         InSamps     : PDouble;
                         Len         : Integer) : TDCplx; stdcall;
nspzbGoertz:function (var State       : TNSPZGoertzState;
                         InSamps     : PDCplx;
                         Len         : Integer) : TDCplx; stdcall;
nspwbGoertz:function (var State       : TNSPWGoertzState;
                         InSamps     : Psmallint;
                         Len         : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer) : TWCplx; stdcall;
nspvbGoertz:function (var State       : TNSPVGoertzState;
                         InSamps     : PWCplx;
                         Len         : Integer;
                         ScaleMode   : Integer;
                     var ScaleFactor : Integer) : TWCplx; stdcall;

nspsGoertzOut:procedure (var State   : TNSPSGoertzState;
                             Sample  : single;
                         var Val     : TSCplx); stdcall;
nspcGoertzOut:procedure (var State   : TNSPCGoertzState;
                             Sample  : TSCplx;
                         var Val     : TSCplx); stdcall;
nspsbGoertzOut:procedure (var State   : TNSPSGoertzState;
                             InSamps : Psingle;
                             Len     : Integer;
                         var Val     : TSCplx); stdcall;
nspcbGoertzOut:procedure (var State   : TNSPCGoertzState;
                             InSamps : PSCplx;
                             Len     : Integer;
                         var Val     : TSCplx); stdcall;

{EOF}
(*
From:    nspiirl.h
Purpose: NSP Infinite Impulse Response Filtering.
*)

const
  MAX_IIR_FILTER = 1024;

{---- User tap type ------------------------------------------------------}

type
  TNSPIirType = (NSP_IirNull, NSP_IirDefault, NSP_IirUseTapsAsPtr);

{---- Implementation tap type of initialization --------------------------}

  TNSPIirInit = (NSP_IirInit, NSP_IirXInit, NSP_IirInitBq, NSP_IirXInitBq);

{---- IIR filter tap state structure -------------------------------------}

  TNSPIirTapState = record
    Order   : Integer;                 // order/number of biquads
    Taps    : Pointer;                 // pointer to taps
    IirType : TNSPIirType;             // user type
    IniType : TNSPIirInit;             // type of initialization
    TapsFactor : Integer;
  end;

{---- IIR filter delay line state structure ------------------------------}

  TNSPIirDlyState = record
    Dlyl : Pointer;                    // pointer to delay line
  end;

{---- IIR filter state structure -----------------------------------------}

  TNSPIirState = record
    TapSt : TNSPIirTapState;           // tap state structure
    DlySt : TNSPIirDlyState;           // delay line state structure
    Init  : Integer;                   // initialization flag
  end;

{-------------------------------------------------------------------------}
{         IirlInit, IirlInitBq, IirlInitDlyl                              }
{                                                                         }
{ Perform infinite impulse response filtering.                            }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<w,s,c,d,z>IirlInit                                                }
{ DESCRIPTION:                                                            }
{   Taps initialization of low-level arbitrary order IIR-filter with      }
{   transfer function expressed as the ratio of two polinomials of order  }
{   "order".                                                              }
{ PARAMETERS:                                                             }
{   iirType  - input, determines the filter structure to use, currently   }
{              must be NSP_IirDefault;                                    }
{   taps     - input/output, sets the array taps of filter with transfer  }
{              function                                                   }
{                   B0+B1/z+B2/z/z ... +Border/z**order                   }
{              H(z)=------------------------------------                  }
{                   A0+A1/z+A2/z/z ... +Aorder/z**order                   }
{              in following order:                                        }
{                  B0, B1, ... Border,A0, A1, ... Aorder.                 }
{              A0 must not be zero;                                       }
{   order    - input, sets polinomial order;                              }
{   tapStPtr - output, the pointer to the tap state structure.            }
{                                                                         }
{   gain - input, determines gain coefficient for filter output signal.   }
{          It have to be positive value .                                 }
{   InputRange - input, defines the bit range of input signal             }
{                (from 4 to 16 bit). This gives possibility for the       }
{                optimal taps recalculation from single to the internal    }
{                smallint whith a fixed point flavor when input signal       }
{                limitation is known.                                     }
{    When gain = 1.0 and InputRange =16 the result of nspwIirlInitGain is }
{    equal to nspwIirlInit.                                               }

var

nspwIirlInit:procedure (IirType : TNSPIirType; Taps : Psingle;
                       Order   : Integer;
                   var State   : TNSPIirTapState); stdcall;
nspsIirlInit:procedure (IirType : TNSPIirType; Taps : Psingle;
                       Order   : Integer;
                   var State   : TNSPIirTapState); stdcall;
nspcIirlInit:procedure (IirType : TNSPIirType; Taps : PSCplx;
                       Order   : Integer;
                   var State   : TNSPIirTapState); stdcall;
nspdIirlInit:procedure (IirType : TNSPIirType; Taps : PDouble;
                       Order   : Integer;
                   var State   : TNSPIirTapState); stdcall;
nspzIirlInit:procedure (IirType : TNSPIirType; Taps : PDCplx;
                       Order   : Integer;
                   var State   : TNSPIirTapState); stdcall;
nspwIirlInitGain:procedure (IirType    : TNSPIirType; Taps : Psingle;
                           Order      : Integer;
                       var State      : TNSPIirTapState;
                           Gain       : single;
                           InputRange : Integer); stdcall;

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<w,s,c,d,z>IirlInitBq                                              }
{ DESCRIPTION:                                                            }
{   Low-level IIR-filter iinitialization taps to reference a cascade of   }
{   biquads. Transfer function is a product of numQuads biquads.          }
{ PARAMETERS:                                                             }
{   iirType  - input, determines the filter structure to use, currently   }
{              must be NSP_IirDefault;                                    }
{   taps     - input/output, sets the array taps of filter                }
{              with the transfer function                                 }
{                   (B10+B11/z+B12/z**2)* ... *(BnQ0+BnQ1/z+BnQ2/z**2)    }
{              H(z)=--------------------------------------------------    }
{                   (A10+A11/z+A12/z**2)* ... *(AnQ0+AnQ1/z+AnQ2/z**2)    }
{              in following order:                                        }
{                   B10, B11, B12, A10, A11, A12, ... ,                   }
{                   BnQ0, BnQ1, BnQ2, AnQ0, AnQ1, AnQ2.                   }
{              All Bi0 and Ai0 must not be zero;                          }
{   numQuads - input, sets the number of biduads;                         }
{   tapStPtr - output, pointer to the tap state structure.                }
{                                                                         }

nspwIirlInitBq:procedure (IirType  : TNSPIirType; Taps : Psingle;
                         NumQuads : Integer;
                     var State    : TNSPIirTapState); stdcall;
nspsIirlInitBq:procedure (IirType  : TNSPIirType; Taps : Psingle;
                         NumQuads : Integer;
                     var State    : TNSPIirTapState); stdcall;
nspcIirlInitBq:procedure (IirType  : TNSPIirType; Taps : PSCplx;
                         NumQuads : Integer;
                     var State    : TNSPIirTapState); stdcall;
nspdIirlInitBq:procedure (IirType  : TNSPIirType; Taps : PDouble;
                         NumQuads : Integer;
                     var State    : TNSPIirTapState); stdcall;
nspzIirlInitBq:procedure (IirType  : TNSPIirType; Taps : PDCplx;
                         NumQuads : Integer;
                     var State    : TNSPIirTapState); stdcall;

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<w,s,c,d,z>IirlInitDlyl                                            }
{ DESCRIPTION:                                                            }
{   Initialization of delay array for low-level IIR-filter.               }
{ PARAMETERS:                                                             }
{   tapStPtr - input, the pointer to the tap state structure,             }
{              initializated previously by the function nsp?IirInit or    }
{              nsp?IirInitBq;                                             }
{   dlyl     - input/output, the delay line array. In this implementation }
{              the input array element values are ignored.                }
{   dlyStPtr - output, the pointer to the delay line state structure.     }
{                                                                         }

nspwIirlInitDlyl:procedure (TapState : TNSPIirTapState; Dlyl : PLongint;
                       var DlyState : TNSPIirDlyState); stdcall;
nspsIirlInitDlyl:procedure (TapState : TNSPIirTapState; Dlyl : Psingle;
                       var DlyState : TNSPIirDlyState); stdcall;
nspcIirlInitDlyl:procedure (TapState : TNSPIirTapState; Dlyl : PSCplx;
                       var DlyState : TNSPIirDlyState); stdcall;
nspdIirlInitDlyl:procedure (TapState : TNSPIirTapState; Dlyl : PDouble;
                       var DlyState : TNSPIirDlyState); stdcall;
nspzIirlInitDlyl:procedure (TapState : TNSPIirTapState; Dlyl : PDCplx;
                       var DlyState : TNSPIirDlyState); stdcall;

{-------------------------------------------------------------------------}
{         Iirl, bIirl                                                     }
{                                                                         }
{ Filter a signal through a low-level IIR filter.                         }
{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<w,s,c,d,z>Iirl                                                        }
{ DESCRIPTION:                                                            }
{   filters a single sample throuth a low-level IIR filter and returns    }
{   the result.                                                           }
{ PARAMETERS:                                                             }
{   tapStPtr - input, pointer to the tap state structure;                 }
{   dlyStPtr - input, pointer to the delay line state structure;          }
{   smp      - input, the sample value.                                   }
{ RETURNS:                                                                }
{   the filtering result.                                                 }
{                                                                         }

nspwIirl:function (const TapState    : TNSPIirTapState;
                  var   DlyState    : TNSPIirDlyState;
                        Samp        : smallint;
                        ScaleMode   : Integer;
                  var   ScaleFactor : Integer) : smallint;  stdcall;
nspsIirl:function (const TapState    : TNSPIirTapState;
                  var   DlyState    : TNSPIirDlyState;
                        Samp        : single)   : single;  stdcall;
function nspcIirl (const TapState    : TNSPIirTapState;
                  var   DlyState    : TNSPIirDlyState;
                        Samp        : TSCplx)  : TSCplx; stdcall;
var
nspdIirl:function (const TapState    : TNSPIirTapState;
                  var   DlyState    : TNSPIirDlyState;
                        Samp        : Double)  : Double; stdcall;
nspzIirl:function (const TapState    : TNSPIirTapState;
                  var   DlyState    : TNSPIirDlyState;
                        Samp        : TDCplx)  : TDCplx; stdcall;
nspcIirlOut:procedure (const TapState : TNSPIirTapState;
                      var   DlyState : TNSPIirDlyState;
                            Samp     : TSCplx;
                      var   Val      : TSCplx); stdcall;

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<w,s,c,d,z>bIirl                                                   }
{ DESCRIPTION:                                                            }
{   filters an input block of samples throuth a low-level IIR filter and  }
{   returns the result in output block.                                   }
{ PARAMETERS:                                                             }
{   tapStPtr - input, the pointer to the tap state structure;             }
{   dlyStPtr - input, the pointer to the delay line state structure;      }
{   inSamps  - input, the block of samples;                               }
{   outSamps - output, the block of filtered samples;                     }
{   numIters - input, the size of samples' block.                         }
{                                                                         }

nspwbIirl:procedure (const TapState    : TNSPIirTapState;
                    var   DlyState    : TNSPIirDlyState;
                          InSamps     : Psmallint;  OutSamps : Psmallint;
                          NumIters    : Integer;
                          ScaleMode   : Integer;
                    var   ScaleFactor : Integer); stdcall;
nspsbIirl:procedure (const TapState    : TNSPIirTapState;
                    var   DlyState    : TNSPIirDlyState;
                          InSamps     : Psingle;  OutSamps : Psingle;
                          NumIters    : Integer); stdcall;
nspcbIirl:procedure (const TapState    : TNSPIirTapState;
                    var   DlyState    : TNSPIirDlyState;
                          InSamps     : PSCplx;  OutSamps : PSCplx;
                          NumIters    : Integer); stdcall;
nspdbIirl:procedure (const TapState    : TNSPIirTapState;
                    var   DlyState    : TNSPIirDlyState;
                          InSamps     : PDouble; OutSamps : PDouble;
                          NumIters    : Integer); stdcall;
nspzbIirl:procedure (const TapState    : TNSPIirTapState;
                    var   DlyState    : TNSPIirDlyState;
                          InSamps     : PDCplx;  OutSamps : PDCplx;
                          NumIters    : Integer); stdcall;


(*
From:    nspiirh.h
Purpose: NSP Infinite Impulse Response Filtering.
*)

{-------------------------------------------------------------------------}
{         IirInit, IirInitBq, IirFree                                     }
{                                                                         }
{ These functions initialize an IIR filter and provide a higher-level     }
{ interface than the corresponding low-level IIR functions.               }
{                                                                         }

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,c,d,z,w>IirInit                                                     }
{ DESCRIPTION:                                                            }
{   These functions initialize an arbitrary order IIR filter.             }
{ PARAMETERS:                                                             }
{   iirType  - input, describes the filter structure to use, and currently}
{              must be NSP_IirDefault;                                    }
{   tapVals  - input, the 2*(order+1) length array specifies the filter   }
{              coefficients as discussed for the low-level IIR function   }
{              nsp?IirlInit());                                           }
{   order    - input, sets polinomial order;                              }
{   statePtr - output, the pointer to the IIR filter state structure.     }
{                                                                         }

nspsIirInit:procedure (IirType : TNSPIirType; TapVals : Psingle;
                      Order   : Integer;
                  var State   : TNSPIirState);         stdcall;
nspcIirInit:procedure (IirType : TNSPIirType; TapVals : PSCplx;
                      Order   : Integer;
                  var State   : TNSPIirState);         stdcall;
nspdIirInit:procedure (IirType : TNSPIirType; TapVals : PDouble;
                      Order   : Integer;
                  var State   : TNSPIirState);         stdcall;
nspzIirInit:procedure (IirType : TNSPIirType; TapVals : PDCplx;
                      Order   : Integer;
                  var State   : TNSPIirState);         stdcall;
nspwIirInit:procedure (IirType : TNSPIirType; TapVals : Psingle;
                      Order   : Integer;
                  var State   : TNSPIirState);         stdcall;
nspwIirInitGain:procedure (IirType    : TNSPIirType; TapVals : Psingle;
                          Order      : Integer;
                      var State      : TNSPIirState;
                          Gain       : single;
                          InputRange : Integer); stdcall;

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,c,d,z,w>IirInitBq                                                   }
{ DESCRIPTION:                                                            }
{   These functions initialize an IIR filter defined by a cascade of      }
{   biquads.                                                              }
{ PARAMETERS:                                                             }
{   iirType  - input, describes the filter structure to use, and currently}
{              must be NSP_IirDefault;                                    }
{   tapVals  - input, the 6*numQuads length array specifies the filter    }
{              coefficients as discussed for the low-level IIR function   }
{              nsp?IirlInitBq());                                         }
{   numQuads - input, sets the number of biduads;                         }
{   tapStPtr - output, pointer to the IIR state structure.                }
{                                                                         }

nspsIirInitBq:procedure (IirType  : TNSPIirType; TapVals : Psingle;
                        NumQuads : Integer;
                    var State    : TNSPIirState);         stdcall;
nspcIirInitBq:procedure (IirType  : TNSPIirType; TapVals : PSCplx;
                        NumQuads : Integer;
                    var State    : TNSPIirState);         stdcall;
nspdIirInitBq:procedure (IirType  : TNSPIirType; TapVals : PDouble;
                        NumQuads : Integer;
                    var State    : TNSPIirState);         stdcall;
nspzIirInitBq:procedure (IirType  : TNSPIirType; TapVals : PDCplx;
                        NumQuads : Integer;
                    var State    : TNSPIirState);         stdcall;
nspwIirInitBq:procedure (IirType  : TNSPIirType; TapVals : Psingle;
                        NumQuads : Integer;
                    var State    : TNSPIirState);         stdcall;

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nspIirFree                                                            }
{ DESCRIPTION:                                                            }
{   This function must be called after all filtering is done to free      }
{   dynamic memory associated with statePtr. After calling this function, }
{   statePtr should not be referenced again.                              }
{ PARAMETERS:                                                             }
{   statePtr - pointer to the IIR filter state structure.                 }
{                                                                         }

nspIirFree:procedure (var State : TNSPIirState); stdcall;

{-------------------------------------------------------------------------}
{         Iir, bIir                                                       }
{                                                                         }
{ Filter a signal through a IIR filter.                                   }
{                                                                         }

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,c,d,z,w>Iir                                                         }
{ DESCRIPTION:                                                            }
{   These functions filter a single sample samp through an IIR filter and }
{   return the result.                                                    }
{ PARAMETERS:                                                             }
{   statePtr - input, pointer to the IIR state structure;                 }
{   samp     - input, the sample value.                                   }
{ RETURNS:                                                                }
{   the filtering result.                                                 }
{                                                                         }

nspsIir:function (var State       : TNSPIirState;
                     Samp        : single)   : single;  stdcall;
function nspcIir (var State       : TNSPIirState;
                     Samp        : TSCplx)  : TSCplx; stdcall;

var
nspdIir:function (var State       : TNSPIirState;
                     Samp        : Double)  : Double; stdcall;
nspzIir:function (var State       : TNSPIirState;
                     Samp        : TDCplx)  : TDCplx; stdcall;
nspwIir:function (var State       : TNSPIirState;
                     Samp        : smallint;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer) : smallint;  stdcall;

nspcIirOut:procedure (var State : TNSPIirState;
                         Samp  : TSCplx;
                     var Val   : TSCplx); stdcall;

{-------------------------------------------------------------------------}
{ FUNCTION:                                                               }
{   nsp<s,c,d,z,w>bIir                                                        }
{ DESCRIPTION:                                                            }
{   These functions filter a block of numIters samples inSamps through an }
{   IIR filter and return the result in outSamps.                         }
{ PARAMETERS:                                                             }
{   statePtr - input, pointer to the IIR state structure;                 }
{   inSamps  - input, the pointer to block of numIters samples;           }
{   outSamps - output, the pointer to block of numIters filtered samples; }
{   numIters - input, the size of samples' block.                         }
{                                                                         }

nspsbIir:procedure (var State       : TNSPIirState;
                       InSamps     : Psingle;  OutSamps : Psingle;
                       NumIters    : Integer);          stdcall;
nspcbIir:procedure (var State       : TNSPIirState;
                       InSamps     : PSCplx;  OutSamps : PSCplx;
                       NumIters    : Integer);          stdcall;
nspdbIir:procedure (var State       : TNSPIirState;
                       InSamps     : PDouble; OutSamps : PDouble;
                       NumIters    : Integer);          stdcall;
nspzbIir:procedure (var State       : TNSPIirState;
                       InSamps     : PDCplx;  OutSamps : PDCplx;
                       NumIters    : Integer);          stdcall;
nspwbIir:procedure (var State       : TNSPIirState;
                       InSamps     : Psmallint;  OutSamps : Psmallint;
                       NumIters    : Integer;
                       ScaleMode   : Integer;
                   var ScaleFactor : Integer);          stdcall;

{EOF}

{EOF}
(*
From:    nsplaw.h
Purpose: Convert samples from 8-bit A-law and Mu-law encoded format
         to linear, or vice-versa.
Contents:
           nsp?bLinToALaw  -
                   Convert linear PCM samples to 8-bit A-law format.
           nsp?bALawToLin  -
                   Convert samples from 8-bit A-law encoded format
                   to linear PCM.
           nsp?bLinToMuLaw  -
                   Convert linear PCM samples to 8-bit Mu-law format.
           nsp?bMuLawToLin  -
                   Convert samples from 8-bit Mu-law encoded format
                   to linear PCM.
           nspMuLawToALaw  -
                   Converts samples from Mu-law encoded format
                   to A-law encoded format.
           nspALawToMuLaw  -
                   Converts samples from A-law encoded format
                   to Mu-law encoded format.
*)

nspwbLinToALaw:procedure (Src : Psmallint;  Dst : PUCHAR; Len : Integer); stdcall;
nspsbLinToALaw:procedure (Src : Psingle;  Dst : PUCHAR; Len : Integer); stdcall;
nspdbLinToALaw:procedure (Src : PDouble; Dst : PUCHAR; Len : Integer); stdcall;

nspwbALawToLin:procedure (Src : PUCHAR; Dst : Psmallint;  Len : Integer); stdcall;
nspsbALawToLin:procedure (Src : PUCHAR; Dst : Psingle;  Len : Integer); stdcall;
nspdbALawToLin:procedure (Src : PUCHAR; Dst : PDouble; Len : Integer); stdcall;

nspwbLinToMuLaw:procedure (Src : Psmallint;  Dst : PUCHAR; Len : Integer); stdcall;
nspsbLinToMuLaw:procedure (Src : Psingle;  Dst : PUCHAR; Len : Integer); stdcall;
nspdbLinToMuLaw:procedure (Src : PDouble; Dst : PUCHAR; Len : Integer); stdcall;

nspwbMuLawToLin:procedure (Src : PUCHAR; Dst : Psmallint;  Len : Integer); stdcall;
nspsbMuLawToLin:procedure (Src : PUCHAR; Dst : Psingle;  Len : Integer); stdcall;
nspdbMuLawToLin:procedure (Src : PUCHAR; Dst : PDouble; Len : Integer); stdcall;

nspMuLawToALaw:procedure (Src : PUCHAR; Dst : PUCHAR; Len : Integer); stdcall;
nspALawToMuLaw:procedure (Src : PUCHAR; Dst : PUCHAR; Len : Integer); stdcall;

{EOF}
(*
From:    nsplmsl.h
Purpose: NSP Adaptive FIR filter that uses the LMS algorithm.
*)

{--- LMS filter (method) type -------------------------------------------}

type
  TNSPLmsType = (NSP_LmsNull, NSP_LmsDefault);

{--- LMS low-level filter state structure -------------------------------}

  TNSPLmsTapState = record
    // FirLmsTapState;                    // Base filter state, see FIRL.H
    Taps         : Pointer;
    Len          : Integer;
    UpFactor     : Integer;
    UpPhase      : Integer;
    DownFactor   : Integer;
    DownPhase    : Integer;
    IsMultiRate  : Integer;
    IsFilterMode : Integer;
    // end FirLmsTapState;
    Leak         : single;                 // Leak value to range taps magn
    Step         : single;                 // Step-size to change taps magn
    ErrDly       : Integer;               // Delay of error signal
    LmsType      : TNSPLmsType;
  end;

{--- LMS low-level filter delay line ------------------------------------}

  TNSPLmsDlyState = record
    // FirLmsDlyState;
    Dlyl         : Pointer;
    Len          : Integer;
    IsFilterMode : Integer;
    // end FirLmsDlyState;
    AdaptB       : Integer;               // Is used in delay length definition
  end;

{------------------------------------------------------------------------}
{   LMSL of "integer" type uses Fixed Point representation of taps       }
{------------------------------------------------------------------------}

  FixedPoint = Integer;

  TNSPWLmsTapState = record
    // FirLmsTapState;                    // Base filter state, see FIRL.H
    Taps         : Pointer;
    Len          : Integer;
    UpFactor     : Integer;
    UpPhase      : Integer;
    DownFactor   : Integer;
    DownPhase    : Integer;
    IsMultiRate  : Integer;
    IsFilterMode : Integer;
    // end FirLmsTapState;
    Leak         : single;                 // Leak value to arrange taps magn
    Step         : record                 // Step size to change taps values
      case Integer of
        0: (F : single);
        1: (I : FixedPoint);
    end;
    ErrDly       : Integer;               // Delay of an error signal
    LmsType      : TNSPLmsType;
  end;

  TNSPWLmsDlyState = TNSPLmsDlyState;

{------------------------------------------------------------------------}
{ LmslInit, LmslInitMr, LmslInitDlyl                                     }
{                                                                        }
{ Initialize  an adaptive  FIR filter  that uses  the least  mean-square }
{ (LMS) algorithm.                                                       }

{--- Single-rate init ---------------------------------------------------}

var

nspsLmslInit:procedure (LmsType : TNSPLmsType; Taps   : Psingle;
                       TapsLen : Integer;     Step   : single;
                       Leak    : single;       ErrDly : Integer;
                   var TapSt   : TNSPLmsTapState);     stdcall;
nspdLmslInit:procedure (LmsType : TNSPLmsType; Taps   : PDouble;
                       TapsLen : Integer;     Step   : single;
                       Leak    : single;       ErrDly : Integer;
                   var TapSt   : TNSPLmsTapState);     stdcall;
nspcLmslInit:procedure (LmsType : TNSPLmsType; Taps   : PSCplx;
                       TapsLen : Integer;     Step   : single;
                       Leak    : single;       ErrDly : Integer;
                   var TapSt   : TNSPLmsTapState);     stdcall;
nspzLmslInit:procedure (LmsType : TNSPLmsType; Taps   : PDCplx;
                       TapsLen : Integer;     Step   : single;
                       Leak    : single;       ErrDly : Integer;
                   var TapSt   : TNSPLmsTapState);     stdcall;

{--- Multi-rate init ----------------------------------------------------}

nspsLmslInitMr:procedure (LmsType    : TNSPLmsType; Taps      : Psingle;
                         TapsLen    : Integer;     Step      : single;
                         Leak       : single;       ErrDly    : Integer;
                         DownFactor : Integer;     DownPhase : Integer;
                     var TapSt      : TNSPLmsTapState);        stdcall;
nspdLmslInitMr:procedure (LmsType    : TNSPLmsType; Taps      : PDouble;
                         TapsLen    : Integer;     Step      : single;
                         Leak       : single;       ErrDly    : Integer;
                         DownFactor : Integer;     DownPhase : Integer;
                     var TapSt      : TNSPLmsTapState);        stdcall;
nspcLmslInitMr:procedure (LmsType    : TNSPLmsType; Taps      : PSCplx;
                         TapsLen    : Integer;     Step      : single;
                         Leak       : single;       ErrDly    : Integer;
                         DownFactor : Integer;     DownPhase : Integer;
                     var TapSt      : TNSPLmsTapState);        stdcall;
nspzLmslInitMr:procedure (LmsType    : TNSPLmsType; Taps      : PDCplx;
                         TapsLen    : Integer;     Step      : single;
                         Leak       : single;       ErrDly    : Integer;
                         DownFactor : Integer;     DownPhase : Integer;
                     var TapSt      : TNSPLmsTapState);        stdcall;

{--- Delay line init ----------------------------------------------------}

nspsLmslInitDlyl:procedure (var TapSt : TNSPLmsTapState;
                               Dlyl  : Psingle; AdaptB :  Integer;
                           var DlySt : TNSPLmsDlyState); stdcall;
nspdLmslInitDlyl:procedure (var TapSt : TNSPLmsTapState;
                               Dlyl  : PDouble; AdaptB :  Integer;
                           var DlySt : TNSPLmsDlyState); stdcall;
nspcLmslInitDlyl:procedure (var TapSt : TNSPLmsTapState;
                               Dlyl  : PSCplx; AdaptB :  Integer;
                           var DlySt : TNSPLmsDlyState); stdcall;
nspzLmslInitDlyl:procedure (var TapSt : TNSPLmsTapState;
                               Dlyl  : PDCplx; AdaptB :  Integer;
                           var DlySt : TNSPLmsDlyState); stdcall;

{------------------------------------------------------------------------}
{ LmslGetStep, LmslSetStep, LmslGetLeak, LmslSetLeak                     }
{                                                                        }
{ Utility  functions  to  get  and  set  the  leak  and step values of a }
{ low-level LMS filter.                                                  }

nspsLmslGetStep:function (const TapSt : TNSPLmsTapState) : single; stdcall;
nspsLmslGetLeak:function (const TapSt : TNSPLmsTapState) : single; stdcall;

nspsLmslSetStep:procedure (Step : single; var TapSt : TNSPLmsTapState); stdcall;
nspsLmslSetLeak:procedure (Leak : single; var TapSt : TNSPLmsTapState); stdcall;

{------------------------------------------------------------------------}
{ Lmsl, bLmsl                                                            }
{                                                                        }
{ Filter samples through a low-level LMS filter.                         }

nspsLmsl:function (var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       Samp    : single;  Err : single)  : single;  stdcall;
function nspcLmsl(var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       Samp    : TSCplx; Err : TSCplx) : TSCplx; stdcall;
var
nspdLmsl:function (var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       Samp    : Double; Err : Double) : Double; stdcall;
nspzLmsl:function (var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       Samp    : TDCplx; Err : TDCplx) : TDCplx; stdcall;
nspcLmslOut:procedure (var TapSt : TNSPLmsTapState;
                      var DlySt : TNSPLmsDlyState;
                          Samp  : TSCplx; Err : TSCplx;
                      var Val   : TSCplx); stdcall;

nspsbLmsl:function (var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       InSamps : Psingle;  Err : single)  : single;  stdcall;
function nspcbLmsl(var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       InSamps : PSCplx;  Err : TSCplx) : TSCplx; stdcall;

var
nspdbLmsl:function (var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       InSamps : PDouble; Err : Double) : Double; stdcall;
nspzbLmsl:function (var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       InSamps : PDCplx;  Err : TDCplx) : TDCplx; stdcall;
nspcbLmslOut:procedure (var TapSt   : TNSPLmsTapState;
                       var DlySt   : TNSPLmsDlyState;
                           InSamps : PSCplx; Err : TSCplx;
                       var Val     : TSCplx); stdcall;

{------------------------------------------------------------------------}
{ LmslNa, bLmslNa                                                        }
{                                                                        }
{ Filter a signal using a LMS filter, but without adapting the filter.   }

nspsLmslNa:function (const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                Samp     : single)  : single;   stdcall;
function nspcLmslNa(const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                Samp     : TSCplx) : TSCplx;  stdcall;
var
nspdLmslNa:function (const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                Samp     : Double) : Double;  stdcall;
nspzLmslNa:function (const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                Samp     : TDCplx) : TDCplx;  stdcall;
nspcLmslNaOut:procedure (const TapSt      : TNSPLmsTapState;
                        var   DlySt      : TNSPLmsDlyState;
                              Samp       : TSCplx;
                        var   Val        : TSCplx);  stdcall;

nspsbLmslNa:procedure (const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                InSamps  : Psingle;  OutSamps : Psingle;
                                NumIters : Integer);          stdcall;
nspcbLmslNa:procedure (const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                InSamps  : PSCplx;  OutSamps : PSCplx;
                                NumIters : Integer);          stdcall;
nspdbLmslNa:procedure (const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                InSamps  : PDouble; OutSamps : PDouble;
                                NumIters : Integer);          stdcall;
nspzbLmslNa:procedure (const TapSt    : TNSPLmsTapState;
                          var   DlySt    : TNSPLmsDlyState;
                                InSamps  : PDCplx;  OutSamps : PDCplx;
                                NumIters : Integer);          stdcall;

nspsLmslGetTaps:procedure (const TapSt    : TNSPLmsTapState;
                                OutTaps  : Psingle);           stdcall;
nspcLmslGetTaps:procedure (const TapSt    : TNSPLmsTapState;
                                OutTaps  : PSCplx);           stdcall;
nspdLmslGetTaps:procedure (const TapSt    : TNSPLmsTapState;
                                OutTaps  : PDouble);          stdcall;
nspzLmslGetTaps:procedure (const TapSt    : TNSPLmsTapState;
                                OutTaps  : PDCplx);           stdcall;

nspsLmslSetTaps:procedure (InTaps   : Psingle;
                          var   TapSt    : TNSPLmsTapState);  stdcall;
nspcLmslSetTaps:procedure (InTaps   : PSCplx;
                          var   TapSt    : TNSPLmsTapState);  stdcall;
nspdLmslSetTaps:procedure (InTaps   : PDouble;
                          var   TapSt    : TNSPLmsTapState);  stdcall;
nspzLmslSetTaps:procedure (InTaps   : PDCplx;
                          var   TapSt    : TNSPLmsTapState);  stdcall;

nspsLmslGetDlyl:procedure (const TapSt    : TNSPLmsTapState;
                          const DlySt    : TNSPLmsDlyState;
                                OutDlyl  : Psingle);           stdcall;
nspcLmslGetDlyl:procedure (const TapSt    : TNSPLmsTapState;
                          const DlySt    : TNSPLmsDlyState;
                                OutDlyl  : PSCplx);           stdcall;
nspdLmslGetDlyl:procedure (const TapSt    : TNSPLmsTapState;
                          const DlySt    : TNSPLmsDlyState;
                                OutDlyl  : PDouble);          stdcall;
nspzLmslGetDlyl:procedure (const TapSt    : TNSPLmsTapState;
                          const DlySt    : TNSPLmsDlyState;
                                OutDlyl  : PDCplx);           stdcall;

nspsLmslSetDlyl:procedure (const TapSt   : TNSPLmsTapState;
                                InDlyl  : Psingle;
                          var   DlySt   : TNSPLmsDlyState); stdcall;
nspcLmslSetDlyl:procedure (const TapSt   : TNSPLmsTapState;
                                InDlyl  : PSCplx;
                          var   DlySt   : TNSPLmsDlyState); stdcall;
nspdLmslSetDlyl:procedure (const TapSt   : TNSPLmsTapState;
                                InDlyl  : PDouble;
                          var   DlySt   : TNSPLmsDlyState); stdcall;
nspzLmslSetDlyl:procedure (const TapSt   : TNSPLmsTapState;
                                InDlyl  : PDCplx;
                          var   DlySt   : TNSPLmsDlyState); stdcall;

{------------------------------------------------------------------------}
{   The wLmsl functions for data of smallint type.                          }
{   31-mar-97. New interface and new functions                           }
{      o leak is not used,                                               }
{      o adaptB is not used,                                             }
{      o filter taps are single in the function call,                     }
{      o step is single in the function call,                             }
{      o calculation are done with fixed point data.                     }
{------------------------------------------------------------------------}

{ Note that adaptB is not used }
nspwLmslInitDlyl:procedure (var   TapSt   : TNSPWLmsTapState;
                                 Dlyl    : Psmallint;
                           var   DlySt   : TNSPWLmsDlyState); stdcall;

nspwLmslSetDlyl:procedure (const TapSt   : TNSPWLmsTapState;
                                 InDlyl  : Psmallint;
                           var   DlySt   : TNSPWLmsDlyState); stdcall;

nspwLmslGetDlyl:procedure (const TapSt   : TNSPWLmsTapState;
                           const DlySt   : TNSPWLmsDlyState;
                                 OutDlyl : Psmallint);           stdcall;

{ Note that leak is not used and taps are single }
nspwLmslInit:procedure (LmsType : TNSPLmsType; Taps : Psingle;
                       TapsLen : Integer;     Step : single;
                       ErrDly  : Integer;
                   var TapSt   : TNSPWLmsTapState);  stdcall;



nspwLmslSetTaps:procedure (InTaps  : Psingle;
                          var   TapSt   : TNSPWLmsTapState); stdcall;

nspwLmslGetTaps:procedure (const TapSt   : TNSPWLmsTapState;
                                OutTaps : Psingle);           stdcall;

nspwLmsl:function (var   TapSt   : TNSPWLmsTapState;
                          var   DlySt   : TNSPWLmsDlyState;
                                Samp    : smallint;
                                Err     : smallint) : smallint;    stdcall;

{ Note that step is single }
nspwLmslGetStep:function  (const TapSt : TNSPWLmsTapState) : single; stdcall;
nspwLmslSetStep:procedure (Step  : single;
                          var   TapSt : TNSPWLmsTapState);         stdcall;

{EOF}
(*
From:    nsplmsh.h
Purpose: NSP Adaptive FIR filter that uses the LMS algorithm
*)

type
  TNSPLmsState = record
    TapState : TNSPLmsTapState;
    DlyState : TNSPLmsDlyState;
    Err      : record
      case Integer of
        0: (sVal : single);
        1: (dVal : Double);
        2: (cVal : TSCplx);
        3: (zVal : TDCplx);
    end;
  end;

{------------------------------------------------------------------------}

var

nspsLmsInit:procedure (LmsType    : TNSPLmsType; TapVals   : Psingle;
                        TapsLen    : Integer;     DlyVals   : Psingle;
                        Step       : single;       Leak      : single;
                        ErrDly     : Integer;
                    var State      : TNSPLmsState);           stdcall;
nspdLmsInit:procedure (LmsType    : TNSPLmsType; TapVals   : PDouble;
                        TapsLen    : Integer;     DlyVals   : PDouble;
                        Step       : single;       Leak      : single;
                        ErrDly     : Integer;
                    var State      : TNSPLmsState);           stdcall;
nspcLmsInit:procedure (LmsType    : TNSPLmsType; TapVals   : PSCplx;
                        TapsLen    : Integer;     DlyVals   : PSCplx;
                        Step       : single;       Leak      : single;
                        ErrDly     : Integer;
                    var State      : TNSPLmsState);           stdcall;
nspzLmsInit:procedure (LmsType    : TNSPLmsType; TapVals   : PDCplx;
                        TapsLen    : Integer;     DlyVals   : PDCplx;
                        Step       : single;       Leak      : single;
                        ErrDly     : Integer;
                    var State      : TNSPLmsState);           stdcall;

nspsLmsInitMr:procedure (LmsType    : TNSPLmsType; TapVals   : Psingle;
                        TapsLen    : Integer;     DlyVals   : Psingle;
                        Step       : single;       Leak      : single;
                        ErrDly     : Integer;
                        DownFactor : Integer;     DownPhase : Integer;
                    var State      : TNSPLmsState);           stdcall;
nspdLmsInitMr:procedure (LmsType    : TNSPLmsType; TapVals   : PDouble;
                        TapsLen    : Integer;     DlyVals   : PDouble;
                        Step       : single;       Leak      : single;
                        ErrDly     : Integer;
                        DownFactor : Integer;     DownPhase : Integer;
                    var State      : TNSPLmsState);           stdcall;
nspcLmsInitMr:procedure (LmsType    : TNSPLmsType; TapVals   : PSCplx;
                        TapsLen    : Integer;     DlyVals   : PSCplx;
                        Step       : single;       Leak      : single;
                        ErrDly     : Integer;
                        DownFactor : Integer;     DownPhase : Integer;
                    var State      : TNSPLmsState);           stdcall;
nspzLmsInitMr:procedure (LmsType    : TNSPLmsType; TapVals   : PDCplx;
                        TapsLen    : Integer;     DlyVals   : PDCplx;
                        Step       : single;       Leak      : single;
                        ErrDly     : Integer;
                        DownFactor : Integer;     DownPhase : Integer;
                    var State      : TNSPLmsState);           stdcall;

nspLmsFree:procedure (var State     : TNSPLmsState);           stdcall;

nspsLms:function (var State     : TNSPLmsState; Samp     : single;
                         Err       : single)  : single;         stdcall;
nspdLms:function (var State     : TNSPLmsState; Samp     : Double;
                         Err       : Double) : Double;        stdcall;
function nspcLms (var State     : TNSPLmsState; Samp     : TSCplx;
                         Err       : TSCplx) : TSCplx;        stdcall;
var
nspzLms:function (var State     : TNSPLmsState; Samp     : TDCplx;
                         Err       : TDCplx) : TDCplx;        stdcall;

nspsbLms:function (var State     : TNSPLmsState; InSamps  : Psingle;
                         Err       : single)  : single;         stdcall;
nspdbLms:function (var State     : TNSPLmsState; InSamps  : PDouble;
                         Err       : Double) : Double;        stdcall;
function nspcbLms(var State     : TNSPLmsState; InSamps  : PSCplx;
                         Err       : TSCplx) : TSCplx;        stdcall;

var
nspzbLms:function (var State     : TNSPLmsState; InSamps  : PDCplx;
                         Err       : TDCplx) : TDCplx;        stdcall;

nspsLmsGetTaps:procedure (const State    : TNSPLmsState;
                               OutTaps  : Psingle);  stdcall;
nspdLmsGetTaps:procedure (const State    : TNSPLmsState;
                               OutTaps  : PDouble); stdcall;
nspcLmsGetTaps:procedure (const State    : TNSPLmsState;
                               OutTaps  : PSCplx);  stdcall;
nspzLmsGetTaps:procedure (const State    : TNSPLmsState;
                               OutTaps  : PDCplx);  stdcall;

nspsLmsSetTaps:procedure (InTaps   : Psingle;
                         var   State    : TNSPLmsState); stdcall;
nspdLmsSetTaps:procedure (InTaps   : PDouble;
                         var   State    : TNSPLmsState); stdcall;
nspcLmsSetTaps:procedure (InTaps   : PSCplx;
                         var   State    : TNSPLmsState); stdcall;
nspzLmsSetTaps:procedure (InTaps   : PDCplx;
                         var   State    : TNSPLmsState); stdcall;

nspsLmsGetDlyl:procedure (const State    : TNSPLmsState;
                               OutDlyl  : Psingle);       stdcall;
nspdLmsGetDlyl:procedure (const State    : TNSPLmsState;
                               OutDlyl  : PDouble);      stdcall;
nspcLmsGetDlyl:procedure (const State    : TNSPLmsState;
                               OutDlyl  : PSCplx);       stdcall;
nspzLmsGetDlyl:procedure (const State    : TNSPLmsState;
                               OutDlyl  : PDCplx);       stdcall;

nspsLmsSetDlyl:procedure (InDlyl   : Psingle;
                         var   State    : TNSPLmsState); stdcall;
nspdLmsSetDlyl:procedure (InDlyl   : PDouble;
                         var   State    : TNSPLmsState); stdcall;
nspcLmsSetDlyl:procedure (InDlyl   : PSCplx;
                         var   State    : TNSPLmsState); stdcall;
nspzLmsSetDlyl:procedure (InDlyl   : PDCplx;
                         var   State    : TNSPLmsState); stdcall;

nspsLmsGetStep:function  (const State    : TNSPLmsState) : single; stdcall;
nspsLmsGetLeak:function  (const State    : TNSPLmsState) : single; stdcall;

nspsLmsSetStep:procedure (Step     : single;
                         var   State    : TNSPLmsState); stdcall;
nspsLmsSetLeak:procedure (Leak     : single;
                         var   State    : TNSPLmsState); stdcall;

nspsLmsDes:function (var   State    : TNSPLmsState; Samp : single;
                               Des      : single)  : single;     stdcall;
nspdLmsDes:function (var   State    : TNSPLmsState; Samp : Double;
                               Des      : Double) : Double;    stdcall;
function nspcLmsDes (var   State    : TNSPLmsState; Samp : TSCplx;
                               Des      : TSCplx) : TSCplx;    stdcall;
var
nspzLmsDes:function (var   State    : TNSPLmsState; Samp : TDCplx;
                               Des      : TDCplx) : TDCplx;    stdcall;

nspsbLmsDes:procedure (var   State    : TNSPLmsState; InSamps  : Psingle;
                               DesSamps : Psingle;       OutSamps : Psingle;
                               NumIters : Integer);                stdcall;
nspdbLmsDes:procedure (var   State    : TNSPLmsState; InSamps  : PDouble;
                               DesSamps : PDouble;      OutSamps : PDouble;
                               NumIters : Integer);                stdcall;
nspcbLmsDes:procedure (var   State    : TNSPLmsState; InSamps  : PSCplx;
                               DesSamps : PSCplx;       OutSamps : PSCplx;
                               NumIters : Integer);                stdcall;
nspzbLmsDes:procedure (var   State    : TNSPLmsState; InSamps  : PDCplx;
                               DesSamps : PDCplx;       OutSamps : PDCplx;
                               NumIters : Integer);                stdcall;

nspsLmsGetErrVal:function (const State : TNSPLmsState) : single;  stdcall;
nspdLmsGetErrVal:function (const State : TNSPLmsState) : Double; stdcall;
function nspcLmsGetErrVal(const State : TNSPLmsState) : TSCplx; stdcall;
var
nspzLmsGetErrVal:function (const State : TNSPLmsState) : TDCplx; stdcall;

nspsLmsSetErrVal:procedure (Err   : single;
                           var   State : TNSPLmsState); stdcall;
nspdLmsSetErrVal:procedure (Err   : Double;
                           var   State : TNSPLmsState); stdcall;
nspcLmsSetErrVal:procedure (Err   : TSCplx;
                           var   State : TNSPLmsState); stdcall;
nspzLmsSetErrVal:procedure (Err   : TDCplx;
                           var   State : TNSPLmsState); stdcall;

nspcLmsOut:procedure (var State : TNSPLmsState;
                          Samp  : TSCplx;
                          Err   : TSCplx;
                      var Val   : TSCplx); stdcall;
nspcbLmsOut:procedure (var State   : TNSPLmsState;
                          InSamps : PSCplx;
                          Err     : TSCplx;
                      var Val     : TSCplx); stdcall;
nspcLmsDesOut:procedure (var State : TNSPLmsState;
                            Samp  : TSCplx;
                            Des   : TSCplx;
                        var Val   : TSCplx); stdcall;
nspcLmsGetErrValOut:procedure (const State : TNSPLmsState;
                              var   Val   : TSCplx); stdcall;

{EOF}

(*
From:    nsplnexp.h
Purpose: Compute the natural log of vector elements
         Compute e to the power of vector elements

Contents:
         nsp?bLn1   -
                    Computes the natural log of each element
                    in the array in-place
         nsp?bLn2   -
                    Computes the natural log of each element
                    in the array and stores the results
                    in the another array
         nsp?bExp1  -
                    Computes e to the power of each element
                    in the array in-place
         nsp?bExp2  -
                    Computes e to the power of each element
                    in the array and stores the results
                    in the another array
*)

nspsbLn1:procedure (Vec         : Psingle; Len : Integer); stdcall;
nspsbLn2:procedure (Src         : Psingle; Dst : Psingle; Len : Integer); stdcall;
nspsbExp1:procedure (Vec         : Psingle; Len : Integer); stdcall;
nspsbExp2:procedure (Src         : Psingle; Dst : Psingle; Len : Integer); stdcall;

nspdbLn1:procedure (Vec         : PDouble; Len : Integer); stdcall;
nspdbLn2:procedure (Src         : PDouble; Dst : PDouble; Len : Integer); stdcall;
nspdbExp1:procedure (Vec         : PDouble; Len : Integer); stdcall;
nspdbExp2:procedure (Src         : PDouble; Dst : PDouble; Len : Integer); stdcall;

nspwbLn1:procedure (Vec         : Psmallint; Len : Integer); stdcall;
nspwbLn2:procedure (Src         : Psmallint; Dst : Psmallint; Len : Integer); stdcall;
nspwbExp1:procedure (Vec         : Psmallint; Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;
nspwbExp2:procedure (Src         : Psmallint; Dst : Psmallint; Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;

{***** decimal functions        ****}
nspsbLg1:procedure (Vec : Psingle;  Len : Integer ); stdcall;
nspsbLg2:procedure (Src : Psingle;  Dst : Psingle; Len : Integer); stdcall;
nspdbLg1:procedure (Vec : PDouble; Len : Integer); stdcall;
nspdbLg2:procedure (Src : PDouble; Dst : PDouble; Len : Integer); stdcall;

{***** complex decimal functions  **}
nspcbLg1:procedure (Vec : PSCplx;  Len : Integer); stdcall;
nspcbLg2:procedure (Src : PSCplx;  Dst : PSCplx; Len : Integer); stdcall;

{EOF}
(*
From:    nsplogic.h
Purpose: NSP Vector Shift and Logical Operations Header File.
*)

{-------------------------------------------------------}
{              Vector Logical Functions                 }
{-------------------------------------------------------}


{
 bShift: Left or right arithmetic shift the elements of the vector.

  Parameters:
        dst   Pointer to the vector dst which stores the results of the
              left shift  dst << nShift or right shift  dst >> nShift (L/R).
          n   The number of elements to be operated on.
      nShift  The number of position which vector elements to be shifted on.
}

nspwbShiftL:procedure (Dst : Psmallint; N : Integer; NShift : Integer); stdcall;
nspwbShiftR:procedure (Dst : Psmallint; N : Integer; NShift : Integer); stdcall;

{
  bAnd1 : ANDs the elements of a vector with a scalar.
  bAnd2 : ANDs the elements of two vectors.
  bAnd3 : ANDs the elements of two vectors and stores the result in
          a third vector.

  Parameters:
        dst   Pointer to the vector dst which stores the results
              of the AND operation src AND dst.
        src   Pointer to the vector to be bitwise ANDed with
              elements of dst.
        val   The value to be ANDed with each element of the vector
              dst.
 srcA, srcB   Pointers to the vectors whose elements are to be
          n   The number of elements to be operated on.
}

nspwbAnd1:procedure (Val : smallint;  Dst : Psmallint; N : Integer); stdcall;
nspwbAnd2:procedure (Src : Psmallint; Dst : Psmallint; N : Integer); stdcall;
nspwbAnd3:procedure (SrcA, SrcB, Dst   : Psmallint; N : Integer); stdcall;

{
  bXor1 : XORs the elements of a vector with a scalar.
  bXor2 : XORs the elements of two vectors.
  bXor3 : XORs the elements of two vectors and stores the result in
          a third vector.

  Parameters:
        dst   Pointer to the vector dst which stores the results
              of the XOR operation src XOR dst.
        src   Pointer to the vector to be bitwise XORed with
              elements of dst.
 srcA, srcB   Pointers to the vectors whose elements are to be
              bitwise XORed.
        val   The scalar which is XORed with each vector element.
          n   The number of elements to be operated on.
}

nspwbXor1:procedure (Val : smallint;  Dst : Psmallint; N : Integer); stdcall;
nspwbXor2:procedure (Src : Psmallint; Dst : Psmallint; N : Integer); stdcall;
nspwbXor3:procedure (SrcA, SrcB, Dst   : Psmallint; N : Integer); stdcall;

{
  bOr1  : ORs the elements of a vector with a scalar.
  bOr2  : ORs the elements of two vectors.
  bOr3  : ORs the elements of two vectors and stores the result in
          a third vector.

  Parameters:
        dst   Pointer to the vector dst which stores the results
              of the OR operation src OR dst.
        src   Pointer to the vector to be bitwise ORed with
              elements of dst.
        val   The scalar which is ORed with each vector element.
 srcA, srcB   Pointers to the vectors whose elements are to be
              bitwise ORed.
          n   The number of elements to be operated on.
}

nspwbOr1:procedure (Val : smallint;  Dst : Psmallint; N : Integer); stdcall;
nspwbOr2:procedure (Src : Psmallint; Dst : Psmallint; N : Integer); stdcall;
nspwbOr3:procedure (SrcA, SrcB, Dst   : Psmallint; N : Integer); stdcall;

{
  bNot : Performs a logical NOT of the elements of a vector

  Parameters:
        dst   Pointer to the vector dst which stores the results
              of the logical operation NOT dst.
          n   The number of elements to be operated on.
}

nspwbNot:procedure (Dst : Psmallint; N : Integer); stdcall;

{EOF}
(*
From:    nspmed.h
Purpose: NSP Median Filter
*)

nspsbMedianFilter1:procedure (InOut    : Psingle; Len : Integer;
                             MaskSize : Integer); stdcall;
nspdbMedianFilter1:procedure (InOut    : PDouble; Len : Integer;
                             MaskSize : Integer); stdcall;
nspwbMedianFilter1:procedure (InOut    : Psmallint; Len : Integer;
                             MaskSize : Integer); stdcall;

nspsbMedianFilter2:procedure (const pIn      : Psingle;  pOut : Psingle;
                                   Len      : Integer;
                                   MaskSize : Integer); stdcall;
nspdbMedianFilter2:procedure (const pIn      : PDouble; pOut : PDouble;
                                   Len      : Integer;
                                   MaskSize : Integer); stdcall;
nspwbMedianFilter2:procedure (const pIn      : Psmallint;  pOut : Psmallint;
                                   Len      : Integer;
                                   MaskSize : Integer); stdcall;
{EOF}
(*
From:    nspmisc.h
Purpose: NSP Miscellaneous Signal Processing Functions
*)

{------------------------------------------------------------------------}
{                                                                        }
{      BitRev, CalcBitRevTbl, GetBitRevTbl, FreeBitRevTbls               }
{                                                                        }
{ Obtain bit-reversed numbers, indices, and indexing tables.             }
{                                                                        }
{------------------------------------------------------------------------}

nspBitRev:function  (A   : Integer;  Order : Integer) : Integer;  stdcall;
nspGetBitRevTbl:function  (Order : Integer) : PInteger; stdcall;
nspCalcBitRevTbl :procedure (Tbl : PInteger; Order : Integer);            stdcall;
nspFreeBitRevTbls :procedure;  stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                     bBitRev1, bBitRev2                                 }
{                                                                        }
{ Permute a vector into binary bit-reversed order.                       }
{                                                                        }
{------------------------------------------------------------------------}

nspwbBitRev1:procedure (Vec   : Psmallint;  Order : Integer); stdcall;
nspvbBitRev1:procedure (Vec   : PWCplx;  Order : Integer); stdcall;
nspsbBitRev1:procedure (Vec   : Psingle;  Order : Integer); stdcall;
nspcbBitRev1:procedure (Vec   : PSCplx;  Order : Integer); stdcall;
nspdbBitRev1:procedure (Vec   : PDouble; Order : Integer); stdcall;
nspzbBitRev1:procedure (Vec   : PDCplx;  Order : Integer); stdcall;

nspwbBitRev2:procedure (Src   : Psmallint;  Dst   : Psmallint;
                       Order : Integer);                 stdcall;
nspvbBitRev2:procedure (Src   : PWCplx;  Dst   : PWCplx;
                       Order : Integer);                 stdcall;
nspsbBitRev2:procedure (Src   : Psingle;  Dst   : Psingle;
                       Order : Integer);                 stdcall;
nspcbBitRev2:procedure (Src   : PSCplx;  Dst   : PSCplx;
                       Order : Integer);                 stdcall;
nspdbBitRev2:procedure (Src   : PDouble; Dst   : PDouble;
                       Order : Integer);                 stdcall;
nspzbBitRev2:procedure (Src   : PDCplx;  Dst   : PDCplx;
                       Order : Integer);                 stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                  GetFftTwdTbl, GetDftTwdTbl, FreeTwdTbls               }
{                                                                        }
{ Compute and store twiddle factors for FFT and DFT computations.        }
{                                                                        }
{------------------------------------------------------------------------}

nspvCalcDftTwdTbl:procedure (Tbl : PWCplx; Len   : Integer); stdcall;
nspvCalcFftTwdTbl:procedure (Tbl : PWCplx; Order : Integer); stdcall;
nspcCalcDftTwdTbl:procedure (Tbl : PSCplx; Len   : Integer); stdcall;
nspcCalcFftTwdTbl:procedure (Tbl : PSCplx; Order : Integer); stdcall;
nspzCalcDftTwdTbl:procedure (Tbl : PDCplx; Len   : Integer); stdcall;
nspzCalcFftTwdTbl:procedure (Tbl : PDCplx; Order : Integer); stdcall;

nspvGetDftTwdTbl:function (Len   : Integer) : PWCplx; stdcall;
nspvGetFftTwdTbl:function (Order : Integer) : PWCplx; stdcall;
nspcGetDftTwdTbl:function (Len   : Integer) : PSCplx; stdcall;
nspcGetFftTwdTbl:function (Order : Integer) : PSCplx; stdcall;
nspzGetDftTwdTbl:function (Len   : Integer) : PDCplx; stdcall;
nspzGetFftTwdTbl:function (Order : Integer) : PDCplx; stdcall;

nspvFreeTwdTbls:procedure;  stdcall;
nspcFreeTwdTbls:procedure;  stdcall;
nspzFreeTwdTbls:procedure;  stdcall;

{EOF}
(*
From:    nspnorm.h
Purpose:
*)

const
  NSP_C         = $01;
  NSP_L1        = $02;
  NSP_L2        = $04;
  NSP_RELATIVE  = $08;
  NSP_SQR_L2    = $10;


// Functions: nsp?Norm
//  Compute the C, L1 or L2 norm of the input vectors’ difference ||a-b||
//  or of one vector ||a||.
//  Vector x[n]' norm definitions:
//  C  norm: ||x[n]|| = MAX(|x[i]|)
//  L1 norm: ||x[n]|| = SUMM(|x[i]|)
//  L2 norm: ||x[n]|| = SQRT(SUMM(x[i]*x[i]) )
//  SQR_L2 norm: ||x[n]|| = SUMM(x[i]*x[i])
//
// Parameters:
//  srcA    - pointer to the first input vector a[n], must not be NULL.
//  srcB    - pointer to the second input vector b[n].
//  len     - the number of elements in the input vectors.
//  flag    - specifies the norm type and the relative mode.
//          Possible values:
//          NSP_C  - C  norm,
//          NSP_L1 - L1 norm,
//          NSP_L2 - L2 norm,
//          NSP_SQR_L2 - SQR_L2 norm,
//          NSP_C |NSP_RELATIVE - C  norm and relative mode,
//          NSP_L1|NSP_RELATIVE - L1 norm and relative mode,
//          NSP_L2|NSP_RELATIVE - L2 norm and relative mode.
//          NSP_SQR_L2|NSP_RELATIVE - SQR_L2 norm and relative mode.
//
//  Returned value:
//          ||a-b||       if srcB != NULL && !(flag & NSP_RELATIVE)
//          ||a||         if srcB == NULL && !(flag & NSP_RELATIVE)
//          ||a-b||/||a|| if srcB != NULL && flag & NSP_RELATIVE
//          1             if srcB == NULL && flag & NSP_RELATIVE
//          FLT_MAX       if ||a|| < FLT_MIN && flag & NSP_RELATIVE

var

nspsNorm:function (SrcA : Psingle;  SrcB : Psingle;
                  Len  : Integer; Flag : Integer) : single;  stdcall;
nspcNorm:function (SrcA : PSCplx;  SrcB : PSCplx;
                  Len  : Integer; Flag : Integer) : single;  stdcall;
nspdNorm:function (SrcA : PDouble; SrcB : PDouble;
                  Len  : Integer; Flag : Integer) : Double; stdcall;
nspzNorm:function (SrcA : PDCplx;  SrcB : PDCplx;
                  Len  : Integer; Flag : Integer) : Double; stdcall;
nspwNorm:function (SrcA : Psmallint;  SrcB : Psmallint;
                  Len  : Integer; Flag : Integer) : single;  stdcall;
nspvNorm:function (SrcA : PWCplx;  SrcB : PWCplx;
                  Len  : Integer; Flag : Integer) : single;  stdcall;

// Functions: nspwNormExt, nspvNormExt
//  Compute the C, L1 or L2 norm of the input vectors’ difference ||a-b||
//  or of one vector ||a|| as nsp?Norm functions
//  and scales the single result to int result according to scale mode and
//  scale factor.
//
// Parameters:
//  srcA    pointer to the first input vector a[n], must not be NULL.
//  srcB    pointer to the second input vector b[n].
//  len     the number of elements in the input vectors.
//  flag    specifies the norm type and the relative mode.
//          Possible values:
//          NSP_C  - C  norm,
//          NSP_L1 - L1 norm,
//          NSP_L2 - L2 norm,
//          NSP_SQR_L2 - SQR_L2 norm,
//          NSP_C |NSP_RELATIVE - C  norm and relative mode,
//          NSP_L1|NSP_RELATIVE - L1 norm and relative mode,
//          NSP_L2|NSP_RELATIVE - L2 norm and relative mode.
//          NSP_SQR_L2|NSP_RELATIVE - SQR_L2 norm and relative mode.
//  scaleMode    scale mode for returned value.
//               Below VALUE is single, non-negative result of nsp?Norm.
//               scale(VALUE) will be compute according to scaleMode:
//          NSP_NO_SCALE              - scale(VALUE) = (int)(VALUE+0.5)
//          NSP_NO_SCALE|NSP_SATURATE - scale(VALUE) = VALUE+0.5 >= INT_MAX ?
//                                                     INT_MAX :
//                                                     (int)(VALUE+0.5)
//          NSP_FIXED_SCALE              - scale(VALUE) =
//                                         (int)(VALUE/(1<<*scaleFactor))
//          NSP_FIXED_SCALE|NSP_SATURATE - scale(VALUE) =
//                                         (VALUE/(1<<*scaleFactor) >= INT_MAX ?
//                                         INT_MAX :
//                                         (int)(VALUE/(1<<*scaleFactor))
//          NSP_AUTO_SCALE - scale(VALUE) = (int)(VALUE/(1<<*scaleFactor)) where
//                           VALUE/(1<<*scaleFactor) < INT_MAX
//  scaleFactor  pointer to scale factor for returned value (see above)
//
//  Returned value:
//          scale(||a-b||)       if srcB != NULL && !(flag & NSP_RELATIVE)
//          scale(||a||)         if srcB == NULL && !(flag & NSP_RELATIVE)
//          scale(||a-b||/||a||) if srcB != NULL && flag & NSP_RELATIVE
//          1                    if srcB == NULL && flag & NSP_RELATIVE
//          scale(FLT_MAX)       if ||a|| < FLT_MIN && flag & NSP_RELATIVE

nspwNormExt:function (SrcA        : Psmallint;  SrcB : Psmallint;
                     Len         : Integer; Flag : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer) : Integer; stdcall;
nspvNormExt:function (SrcA        : PWCplx;  SrcB : PWCplx;
                     Len         : Integer; Flag : Integer;
                     ScaleMode   : Integer;
                 var ScaleFactor : Integer) : Integer; stdcall;

// Function: nsp?bNormalize().
//  Subtract the offset constant from the elements of the input vector a[n]
//  and divides the result by factor.
//  Output vector b[n] has the elements:
//      b[i] = (a[i] - offset) / factor.
//
// Parameters:
//  src     pointer to the input vector a[n].
//  dst     pointer to the output vector b[n].
//  len     the number of elements in the input and output vectors.
//  offset  offset for each element a[i]
//  factor  factor for each element a[i]

nspsbNormalize:procedure (Src    : Psingle;  Dst    : Psingle;  Len : Integer;
                         Offset : single;   Factor : single);  stdcall;
nspcbNormalize:procedure (Src    : PSCplx;  Dst    : PSCplx;  Len : Integer;
                         Offset : TSCplx;  Factor : single);  stdcall;
nspdbNormalize:procedure (Src    : PDouble; Dst    : PDouble; Len : Integer;
                         Offset : Double;  Factor : Double); stdcall;
nspzbNormalize:procedure (Src    : PDCplx;  Dst    : PDCplx;  Len : Integer;
                         Offset : TDCplx;  Factor : Double); stdcall;
nspwbNormalize:procedure (Src    : Psmallint;  Dst    : Psmallint;  Len : Integer;
                         Offset : smallint;   Factor : single);  stdcall;
nspvbNormalize:procedure (Src    : PWCplx;  Dst    : PWCplx;  Len : Integer;
                         Offset : TWCplx;  Factor : single);  stdcall;

// Functions: nspsSum, nspdSum, nspcSum, nspzSum
//  Compute the sum of the input vectors’ elements.
//
// Parameters:
//  src   pointer to the input vector.
//  n     the number of elements in the input vector.
//
//  Returned value:  SUM (src[i])

nspsSum:function (Src : Psingle;  N : Integer) : single;  stdcall;
nspdSum:function (Src : PDouble; N : Integer) : Double; stdcall;
nspcSum:function (Src : PSCplx;  N : Integer; var Sum : TSCplx) : NSPStatus; stdcall;
nspzSum:function (Src : PDCplx;  N : Integer; var Sum : TDCplx) : NSPStatus; stdcall;

// Function: nspwSum
//  Computes the sum of the input vectors’ elements with scaling.
//
// Parameters:
//  src          pointer to the input vector.
//  n            the number of elements in the input vector.
//  scaleMode    scale mode for returned value.
//  scaleFactor  pointer to scale factor for returned value.
//
//  Returned value:  SCALE (SUM (src[i]))

nspwSum:function (Src         : Psmallint; N : Integer;
                 ScaleMode   : Integer;
             var ScaleFactor : Integer)  : Integer; stdcall;

{EOF}
(*
From: nsprand.h
*)

const
  XBUFLEN = 32;

type
  TNSPSRandUniState = record
    Low, Muler   : single;                  // Lower value and scale multiplier
    Seed2, Carry : UINT;                   // Variables of the algorithm
    Seed1        : array [0..2] of UINT;   // Variables of the algorithm
    QuickSeed    : Integer;
  end;

  TNSPDRandUniState = record
    Low, Muler   : Double;                 // Lower value and scale multiplier
    Seed2, Carry : UINT;                   // Variables of the algorithm
    Seed1        : array [0..2] of UINT;   // Variables of the algorithm
    QuickSeed    : Integer;
  end;

{
  A new state structure of the pseudo random numbers
  generator has two seed values (m_seed) now. Generator
  based on multiplication uses m_seed values. Generator
  based on subtraction uses d_seed and carry.
}

  TNSPWRandUniState = record
    Low, Muler   : single;
    Center, Pwr2 : Integer;
    M_Seed       : array [0..1] of UINT;
    D_Seed       : array [0..2] of UINT;
    Carry        : UINT;
    QuickSeed    : Integer;
    Current      : Integer;
    XBuf         : array [0..XBUFLEN-1] of smallint;
  end;

  TNSPCRandUniState = TNSPSRandUniState;
  TNSPZRandUniState = TNSPDRandUniState;
  TNSPVRandUniState = TNSPWRandUniState;

  TNSPSRandGausState = record
    Mean, StDev  : single;                  // Mean and standard deviation values
    ExtraValue   : single;                  // Value computed early
    UseExtra     : Integer;                // Flag to use extra value
    Seed2, Carry : UINT;                   // Variables of the algorithm
    Seed1        : array [0..2] of UINT;   // Variables of the algorithm
    QuickSeed    : Integer;
  end;

  TNSPDRandGausState = record
    Mean, StDev  : Double;                 // Mean and standard deviation values
    ExtraValue   : Double;                 // Value computed early
    UseExtra     : Integer;                // Flag to use extra value
    Seed2, Carry : UINT;                   // Variables of the algorithm
    Seed1        : array [0..2] of UINT;   // Variables of the algorithm
    QuickSeed    : Integer;
  end;

  TNSPWRandGausState = record
    UseExtra     : Integer;
    Seed2, Carry : UINT;
    Seed1        : array [0..2] of UINT;
    Mean, StDev  : smallint;
    ExtraValue   : smallint;
    QuickSeed    : Integer;
  end;

  TNSPCRandGausState = TNSPSRandGausState;
  TNSPZRandGausState = TNSPDRandGausState;
  TNSPVRandGausState = TNSPWRandGausState;

{-------------------------------------------------------------------------}
{
   Uniform distribution.
   Algorithm by G.Marsaglia and A.Zaman (Computers in Physics, vol.8,
   #1, 1994, 117) are used to build generator of uniformly distributed
   random numbers.
}

var

nspsRandUniInit:procedure (Seed, Low, High : single;
                      var State : TNSPSRandUniState); stdcall;
nspcRandUniInit:procedure (Seed, Low, High : single;
                      var State : TNSPCRandUniState); stdcall;
nspdRandUniInit:procedure (Seed, Low, High : Double;
                      var State : TNSPDRandUniState); stdcall;
nspzRandUniInit:procedure (Seed, Low, High : Double;
                      var State : TNSPZRandUniState); stdcall;
nspwRandUniInit:procedure (Seed : UINT; Low, High : smallint;
                      var State : TNSPWRandUniState); stdcall;
nspvRandUniInit:procedure (Seed : UINT; Low, High : smallint;
                      var State : TNSPVRandUniState); stdcall;

nspsRandUni:function  (var State : TNSPSRandUniState) : single;  stdcall;
function nspcRandUni (var State : TNSPCRandUniState) : TSCplx; stdcall;
var
nspdRandUni:function  (var State : TNSPDRandUniState) : Double; stdcall;
nspzRandUni:function  (var State : TNSPZRandUniState) : TDCplx; stdcall;
nspwRandUni:function  (var State : TNSPWRandUniState) : smallint;  stdcall;
nspvRandUni:function  (var State : TNSPVRandUniState) : TWCplx; stdcall;
nspcRandUniOut:procedure (var State : TNSPCRandUniState;
                         var Val   : TSCplx); stdcall;

nspsbRandUni:procedure (var State    : TNSPSRandUniState;
                           Samps    : Psingle;
                           SampsLen : Integer); stdcall;
nspcbRandUni:procedure (var State    : TNSPCRandUniState;
                           Samps    : PSCplx;
                           SampsLen : Integer); stdcall;
nspdbRandUni:procedure (var State    : TNSPDRandUniState;
                           Samps    : PDouble;
                           SampsLen : Integer); stdcall;
nspzbRandUni:procedure (var State    : TNSPZRandUniState;
                           Samps    : PDCplx;
                           SampsLen : Integer); stdcall;
nspwbRandUni:procedure (var State    : TNSPWRandUniState;
                           Samps    : Psmallint;
                           SampsLen : Integer); stdcall;
nspvbRandUni:procedure (var State    : TNSPVRandUniState;
                           Samps    : PWCplx;
                           SampsLen : Integer); stdcall;

{
   Normal distribution.
   Algorithm by G.Box and M.Muller and by G.Marsaglia (Reference:
   D.Knuth. The Art of Computer Programming. vol.2, 1969) are used
   to build generator of normally distributed random numbers.
}

nspsRandGausInit:procedure (Seed, Mean, StDev : single;
                       var State : TNSPSRandGausState); stdcall;
nspcRandGausInit:procedure (Seed, Mean, StDev : single;
                       var State : TNSPCRandGausState); stdcall;
nspdRandGausInit:procedure (Seed, Mean, StDev : Double;
                       var State : TNSPDRandGausState); stdcall;
nspzRandGausInit:procedure (Seed, Mean, StDev : Double;
                       var State : TNSPZRandGausState); stdcall;
nspwRandGausInit:procedure (Seed, Mean, StDev : smallint;
                       var State : TNSPWRandGausState); stdcall;
nspvRandGausInit:procedure (Seed, Mean, StDev : smallint;
                       var State : TNSPVRandGausState); stdcall;

nspsRandGaus:function (var State : TNSPSRandGausState) : single;  stdcall;
function nspcRandGaus(var State : TNSPCRandGausState) : TSCplx; stdcall;
var
nspdRandGaus:function (var State : TNSPDRandGausState) : Double; stdcall;
nspzRandGaus:function (var State : TNSPZRandGausState) : TDCplx; stdcall;
nspwRandGaus:function (var State : TNSPWRandGausState) : smallint;  stdcall;
nspvRandGaus:function (var State : TNSPVRandGausState) : TWCplx; stdcall;
nspcRandGausOut:procedure (var State : TNSPCRandGausState;
                          var Val   : TSCplx); stdcall;

nspsbRandGaus:procedure (var State    : TNSPSRandGausState;
                            Samps    : Psingle;
                            SampsLen : Integer); stdcall;
nspcbRandGaus:procedure (var State    : TNSPCRandGausState;
                            Samps    : PSCplx;
                            SampsLen : Integer); stdcall;
nspdbRandGaus:procedure (var State    : TNSPDRandGausState;
                            Samps    : PDouble;
                            SampsLen : Integer); stdcall;
nspzbRandGaus:procedure (var State    : TNSPZRandGausState;
                            Samps    : PDCplx;
                            SampsLen : Integer); stdcall;
nspwbRandGaus:procedure (var State    : TNSPWRandGausState;
                            Samps    : Psmallint;
                            SampsLen : Integer); stdcall;
nspvbRandGaus:procedure (var State    : TNSPVRandGausState;
                            Samps    : PWCplx;
                            SampsLen : Integer); stdcall;

{EOF}
(*
From: nsprsmpl.h
*)

type TNSPSampState = record
  NFactors    : Integer;
  NTaps       : Integer;
  SLen        : Integer;
  DLen        : Integer;
  IsSampInit  : Integer;
  FactorRange : Psingle;
  Freq        : Psingle;
  Taps        : Pointer;
  FirState    : TNSPFirState;
end;

var

nspsSampInit:function (var SampSt : TNSPSampState;
                          FactorRange : Psingle;
                          Freq        : Psingle;
                          NFactors    : Integer;
                          NTaps       : Integer) : NSPStatus; stdcall;
nspdSampInit:function (var SampSt : TNSPSampState;
                          FactorRange : Psingle;
                          Freq        : Psingle;
                          NFactors    : Integer;
                          NTaps       : Integer) : NSPStatus; stdcall;

nspsSamp:function (var SampSt : TNSPSampState;
                      Src    : Psingle; SrcLen : Integer;
                      Dst    : Psingle; DstLen : Integer) : NSPStatus; stdcall;
nspdSamp:function (var SampSt : TNSPSampState;
                      Src    : PDouble; SrcLen : Integer;
                      Dst    : PDouble; DstLen : Integer) : NSPStatus; stdcall;

nspSampFree:procedure (var SampSt : TNSPSampState); stdcall;

{EOF}
(*
From:    nspsampl.h
Purpose: Purpose: NSP sample
*)

{-------------------------------------------------------------------------}
{        UpSample                                                         }
{                                                                         }
{ Up-sample  a  signal, conceptually increasing  its  sampling rate by an }
{ integer factor and forming output parameters for next sampling;         }

nspsUpSample:procedure (Src    : Psingle;      SrcLen : Integer;
                       Dst    : Psingle;  var DstLen : Integer;
                       Factor : Integer; var Phase  : Integer); stdcall;
nspcUpSample:procedure (Src    : PSCplx;      SrcLen : Integer;
                       Dst    : PSCplx;  var DstLen : Integer;
                       Factor : Integer; var Phase  : Integer); stdcall;
nspdUpSample:procedure (Src    : PDouble;     SrcLen : Integer;
                       Dst    : PDouble; var DstLen : Integer;
                       Factor : Integer; var Phase  : Integer); stdcall;
nspzUpSample:procedure (Src    : PDCplx;      SrcLen : Integer;
                       Dst    : PDCplx;  var DstLen : Integer;
                       Factor : Integer; var Phase  : Integer); stdcall;
nspwUpSample:procedure (Src    : Psmallint;      SrcLen : Integer;
                       Dst    : Psmallint;  var DstLen : Integer;
                       Factor : Integer; var Phase  : Integer); stdcall;
nspvUpSample:procedure (Src    : PWCplx;      SrcLen : Integer;
                       Dst    : PWCplx;  var DstLen : Integer;
                       Factor : Integer; var Phase  : Integer); stdcall;

{-------------------------------------------------------------------------}
{        DownSample                                                       }
{                                                                         }
{ Down-sample a  signal, conceptually decreasing  its sample rate  by an  }
{ integer factor and forming output parameters for next sampling;         }

nspsDownSample:procedure (Src    : Psingle;      SrcLen : Integer;
                         Dst    : Psingle;  var DstLen : Integer;
                         Factor : Integer; var Phase  : Integer); stdcall;
nspcDownSample:procedure (Src    : PSCplx;      SrcLen : Integer;
                         Dst    : PSCplx;  var DstLen : Integer;
                         Factor : Integer; var Phase  : Integer); stdcall;
nspdDownSample:procedure (Src    : PDouble;     SrcLen : Integer;
                         Dst    : PDouble; var DstLen : Integer;
                         Factor : Integer; var Phase  : Integer); stdcall;
nspzDownSample:procedure (Src    : PDCplx;      SrcLen : Integer;
                         Dst    : PDCplx;  var DstLen : Integer;
                         Factor : Integer; var Phase  : Integer); stdcall;
nspwDownSample:procedure (Src    : Psmallint;      SrcLen : Integer;
                         Dst    : Psmallint;  var DstLen : Integer;
                         Factor : Integer; var Phase  : Integer); stdcall;
nspvDownSample:procedure (Src    : PWCplx;      SrcLen : Integer;
                         Dst    : PWCplx;  var DstLen : Integer;
                         Factor : Integer; var Phase  : Integer); stdcall;

{EOF}
(*
From:    nsptone.h
Purpose: NSP Tone Generator. Declarator
*)

{--- Tone structures -----------------------------------------------------}

type
  TNSPSToneState = record
    CosBase  : Double;
    CosCurr  : Double;
    CosPrev  : Double;
    Mag      : single;
    RFreq    : single;
    Phase    : single;
    IsInit   : array [0..3] of Char;
    Reserved : array [0..13] of single;
  end;

  TNSPCToneState = record
    CosBase  : Double;
    CosCurr  : TDCplx;
    CosPrev  : TDCplx;
    Mag      : single;
    RFreq    : single;
    Phase    : single;
    IsInit   : array [0..3] of Char;
    Reserved : array [0..9] of single;
  end;

  TNSPDToneState = record
    CosBase : Double;
    CosCurr : Double;
    CosPrev : Double;
    Mag     : Double;
    RFreq   : Double;
    Phase   : Double;
    IsInit  : array [0..3] of Char;
  end;

  TNSPZToneState = record
    CosBase : Double;
    CosCurr : TDCplx;
    CosPrev : TDCplx;
    Mag     : Double;
    RFreq   : Double;
    Phase   : Double;
    IsInit  : array [0..3] of Char;
  end;

  TNSPWToneState = record
    Dummy   : array [0..31] of Double;
  end;

  TNSPVToneState = record
    Dummy   : array [0..31] of Double;
  end;

{--- Initialization ------------------------------------------------------}

var

nspwToneInit:procedure (RFreq : single;  Phase : single;  Mag : smallint;
                   var State : TNSPWToneState); stdcall;
nspvToneInit:procedure (RFreq : single;  Phase : single;  Mag : smallint;
                   var State : TNSPVToneState); stdcall;
nspsToneInit:procedure (RFreq : single;  Phase : single;  Mag : single;
                   var State : TNSPSToneState); stdcall;
nspcToneInit:procedure (RFreq : single;  Phase : single;  Mag : single;
                   var State : TNSPCToneState); stdcall;
nspdToneInit:procedure (RFreq : Double; Phase : Double; Mag : Double;
                   var State : TNSPDToneState); stdcall;
nspzToneInit:procedure (RFreq : Double; Phase : Double; Mag : Double;
                   var State : TNSPZToneState); stdcall;

{--- Dot product tone functions ------------------------------------------}

nspwTone:function (var State : TNSPWToneState) : smallint;  stdcall;
nspvTone:function (var State : TNSPVToneState) : TWCplx; stdcall;
nspsTone:function (var State : TNSPSToneState) : single;  stdcall;
function nspcTone(var State : TNSPCToneState) : TSCplx; stdcall;

var
nspdTone:function (var State : TNSPDToneState) : Double; stdcall;
nspzTone:function (var State : TNSPZToneState) : TDCplx; stdcall;
nspcToneOut:procedure (var State : TNSPCToneState;
                      var Val   : TSCplx); stdcall;

{--- Array product tone functions ----------------------------------------}

nspwbTone:procedure (var State : TNSPWToneState;
                        Samps : Psmallint;  SampsLen : Integer); stdcall;
nspvbTone:procedure (var State : TNSPVToneState;
                        Samps : PWCplx;  SampsLen : Integer); stdcall;
nspsbTone:procedure (var State : TNSPSToneState;
                        Samps : Psingle;  SampsLen : Integer); stdcall;
nspcbTone:procedure (var State : TNSPCToneState;
                        Samps : PSCplx;  SampsLen : Integer); stdcall;
nspdbTone:procedure (var State : TNSPDToneState;
                        Samps : PDouble; SampsLen : Integer); stdcall;
nspzbTone:procedure (var State : TNSPZToneState;
                        Samps : PDCplx;  SampsLen : Integer); stdcall;

{EOF}
(*
From:     nsptrngl.h
Purpose:  Generating of signals with triangle wave form.
          Provides samples of a triangle of arbitrary frequency,
          phase, magnitude, and asymmetry.

          0 =< phase < 2PI,  -PI < asym < PI,
          mag > 0, 0 =< rfrec < 0.5

          asym = 0       => Triangle is symmetric (old version)
          asym = -PI+eps => Triangle with sheer back (0<eps)
          asym =  PI-eps => Triangle with sheer front-fore

          Like (cos) tone functions the triangle has period equal 2PI
          Triangle phase is given in radians.
*)

{--- Triangle structures -------------------------------------------------}

type
  TNSPWTrnglState = record
    Mag    : single;
    Step   : single;
    Step1  : single;
    Step2  : single;
    St12   : single;
    St21   : single;
    Shft1  : single;
    Shft2  : single;
    Delta1 : single;
    Delta2 : single;
    Last   : single;
  end;

  TNSPVTrnglState = record
    Mag    : single;
    Step   : TSCplx;
    Step1  : single;
    Step2  : single;
    St12   : single;
    St21   : single;
    Shft1  : single;
    Shft2  : single;
    Delta1 : single;
    Delta2 : single;
    Last   : TSCplx;
  end;

  TNSPSTrnglState = record
    Mag      : single;
    Step     : single;
    Step1    : single;
    Step2    : single;
    St12     : single;
    St21     : single;
    Shft1    : single;
    Shft2    : single;
    Delta1   : single;
    Delta2   : single;
    Last     : single;
    Reserved : array [0..17] of single;
  end;

  TNSPCTrnglState = record
    Mag    : single;
    Step   : TSCplx;
    Step1  : single;
    Step2  : single;
    St12   : single;
    St21   : single;
    Shft1  : single;
    Shft2  : single;
    Delta1 : single;
    Delta2 : single;
    Last   : TSCplx;
    Reserved : array [0..12] of single;
  end;

  TNSPDTrnglState = record
    Mag    : Double;
    Step   : Double;
    Step1  : Double;
    Step2  : Double;
    St12   : Double;
    St21   : Double;
    Shft1  : Double;
    Shft2  : Double;
    Delta1 : Double;
    Delta2 : Double;
    Last   : Double;
  end;

  TNSPZTrnglState = record
    Mag    : Double;
    Step   : TDCplx;
    Step1  : Double;
    Step2  : Double;
    St12   : Double;
    St21   : Double;
    Shft1  : Double;
    Shft2  : Double;
    Delta1 : Double;
    Delta2 : Double;
    Last   : TDCplx;
  end;

{--- Triangle initialization ---------------------------------------------}

var

nspwTrnglInit:procedure (RFrq  : single;  Phase : single;
                        Mag   : smallint;  Asym  : single;
                    var State : TNSPWTrnglState); stdcall;
nspvTrnglInit:procedure (RFrq  : single;  Phase : single;
                        Mag   : smallint;  Asym  : single;
                    var State : TNSPVTrnglState); stdcall;
nspsTrnglInit:procedure (RFrq  : single;  Phase : single;
                        Mag   : single;  Asym  : single;
                    var State : TNSPSTrnglState); stdcall;
nspcTrnglInit:procedure (RFrq  : single;  Phase : single;
                        Mag   : single;  Asym  : single;
                    var State : TNSPCTrnglState); stdcall;
nspdTrnglInit:procedure (RFrq  : Double; Phase : Double;
                        Mag   : Double; Asym  : Double;
                    var State : TNSPDTrnglState); stdcall;
nspzTrnglInit:procedure (RFrq  : Double; Phase : Double;
                        Mag   : Double; Asym  : Double;
                    var State : TNSPZTrnglState); stdcall;

{--- Single-Sample-Generating triangle functions -------------------------}

nspwTrngl:function (var State : TNSPWTrnglState) : smallint;  stdcall;
nspvTrngl:function (var State : TNSPVTrnglState) : TWCplx; stdcall;
nspsTrngl:function (var State : TNSPSTrnglState) : single;  stdcall;
function nspcTrngl(var State : TNSPCTrnglState) : TSCplx; stdcall;
var
nspdTrngl:function (var State : TNSPDTrnglState) : Double; stdcall;
nspzTrngl:function (var State : TNSPZTrnglState) : TDCplx; stdcall;
nspcTrnglOut:procedure (var State : TNSPCTrnglState;
                       var Val   : TSCplx); stdcall;

{--- Block-of-Samples-Generating triangle functions ----------------------}

nspwbTrngl:procedure (var State    : TNSPWTrnglState;
                         Samps    : Psmallint;
                         SampsLen : Integer); stdcall;
nspvbTrngl:procedure (var State    : TNSPVTrnglState;
                         Samps    : PWCplx;
                         SampsLen : Integer); stdcall;
nspsbTrngl:procedure (var State    : TNSPSTrnglState;
                         Samps    : Psingle;
                         SampsLen : Integer); stdcall;
nspcbTrngl:procedure (var State    : TNSPCTrnglState;
                         Samps    : PSCplx;
                         SampsLen : Integer); stdcall;
nspdbTrngl:procedure (var State    : TNSPDTrnglState;
                         Samps    : PDouble;
                         SampsLen : Integer); stdcall;
nspzbTrngl:procedure (var State    : TNSPZTrnglState;
                         Samps    : PDCplx;
                         SampsLen : Integer); stdcall;

{EOF}
(*
From:    nspvec.h
Purpose: NSP Vector Arithmetic and Algebraic Functions
*)

{ ------------------------------------------------------------------------}
const
  NSP_GT     = 1;
  NSP_LT     = 0;
  HUGE_VAL_S = 3.402823466e+38;

var

nspsbSqr1:procedure (Vec         : Psingle;  Len : Integer); stdcall;
nspcbSqr1:procedure (Vec         : PSCplx;  Len : Integer); stdcall;
nspdbSqr1:procedure (Vec         : PDouble; Len : Integer); stdcall;
nspzbSqr1:procedure (Vec         : PDCplx;  Len : Integer); stdcall;
nspwbSqr1:procedure (Vec         : Psmallint;  Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;
nspvbSqr1:procedure (Vec         : PWCplx;  Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;

nspsbSqr2:procedure (Src, Dst    : Psingle;  Len : Integer); stdcall;
nspcbSqr2:procedure (Src, Dst    : PSCplx;  Len : Integer); stdcall;
nspdbSqr2:procedure (Src, Dst    : PDouble; Len : Integer); stdcall;
nspzbSqr2:procedure (Src, Dst    : PDCplx;  Len : Integer); stdcall;
nspwbSqr2:procedure (Src, Dst    : Psmallint;  Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;
nspvbSqr2:procedure (Src, Dst    : PWCplx;  Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer); stdcall;

nspsbSqrt1:procedure (Vec        : Psingle;  Len : Integer); stdcall;
nspcbSqrt1:procedure (Vec        : PSCplx;  Len : Integer); stdcall;
nspdbSqrt1:procedure (Vec        : PDouble; Len : Integer); stdcall;
nspzbSqrt1:procedure (Vec        : PDCplx;  Len : Integer); stdcall;
nspwbSqrt1:procedure (Vec        : Psmallint;  Len : Integer); stdcall;
nspvbSqrt1:procedure (Vec        : PWCplx;  Len : Integer); stdcall;

nspsbSqrt2:procedure (Src, Dst   : Psingle;  Len : Integer); stdcall;
nspcbSqrt2:procedure (Src, Dst   : PSCplx;  Len : Integer); stdcall;
nspdbSqrt2:procedure (Src, Dst   : PDouble; Len : Integer); stdcall;
nspzbSqrt2:procedure (Src, Dst   : PDCplx;  Len : Integer); stdcall;
nspwbSqrt2:procedure (Src, Dst   : Psmallint;  Len : Integer); stdcall;
nspvbSqrt2:procedure (Src, Dst   : PWCplx;  Len : Integer); stdcall;

nspsbThresh1:procedure (Vec      : Psingle;  Len   : Integer;
                       Thresh   : single;   RelOp : Integer); stdcall;
nspcbThresh1:procedure (Vec      : PSCplx;  Len   : Integer;
                       Thresh   : single;   RelOp : Integer); stdcall;
nspdbThresh1:procedure (Vec      : PDouble; Len   : Integer;
                       Thresh   : Double;  RelOp : Integer); stdcall;
nspzbThresh1:procedure (Vec      : PDCplx;  Len   : Integer;
                       Thresh   : Double;  RelOp : Integer); stdcall;
nspwbThresh1:procedure (Vec      : Psmallint;  Len   : Integer;
                       Thresh   : smallint;   RelOp : Integer); stdcall;
nspvbThresh1:procedure (Vec      : PWCplx;  Len   : Integer;
                       Thresh   : smallint;   RelOp : Integer); stdcall;

nspsbThresh2:procedure (Src, Dst : Psingle;  Len   : Integer;
                       Thresh   : single;   RelOp : Integer); stdcall;
nspcbThresh2:procedure (Src, Dst : PSCplx;  Len   : Integer;
                       Thresh   : single;   RelOp : Integer); stdcall;
nspdbThresh2:procedure (Src, Dst : PDouble; Len   : Integer;
                       Thresh   : Double;  RelOp : Integer); stdcall;
nspzbThresh2:procedure (Src, Dst : PDCplx;  Len   : Integer;
                       Thresh   : Double;  RelOp : Integer); stdcall;
nspwbThresh2:procedure (Src, Dst : Psmallint;  Len   : Integer;
                       Thresh   : smallint;   RelOp : Integer); stdcall;
nspvbThresh2:procedure (Src, Dst : PWCplx;  Len   : Integer;
                       Thresh   : smallint;   RelOp : Integer); stdcall;

nspsbInvThresh1:procedure (Vec    : Psingle;  Len : Integer;
                          Thresh : single);  stdcall;
nspcbInvThresh1:procedure (Vec    : PSCplx;  Len : Integer;
                          Thresh : single);  stdcall;
nspdbInvThresh1:procedure (Vec    : PDouble; Len : Integer;
                          Thresh : Double); stdcall;
nspzbInvThresh1:procedure (Vec    : PDCplx;  Len : Integer;
                          Thresh : Double); stdcall;

nspsbInvThresh2:procedure (Src, Dst : Psingle;  Len : Integer;
                          Thresh   : single);  stdcall;
nspcbInvThresh2:procedure (Src, Dst : PSCplx;  Len : Integer;
                          Thresh   : single);  stdcall;
nspdbInvThresh2:procedure (Src, Dst : PDouble; Len : Integer;
                          Thresh   : Double); stdcall;
nspzbInvThresh2:procedure (Src, Dst : PDCplx;  Len : Integer;
                          Thresh   : Double); stdcall;

nspsbAbs1:procedure (Vec : Psingle;  Len : Integer); stdcall;
nspdbAbs1:procedure (Vec : PDouble; Len : Integer); stdcall;
nspwbAbs1:procedure (Vec : Psmallint;  Len : Integer); stdcall;

nspsbAbs2:procedure (Src, Dst : Psingle;  Len : Integer); stdcall;
nspdbAbs2:procedure (Src, Dst : PDouble; Len : Integer); stdcall;
nspwbAbs2:procedure (Src, Dst : Psmallint;  Len : Integer); stdcall;

nspsMax:function (Vec            : Psingle;  Len : Integer) : single;  stdcall;
nspdMax:function (Vec            : PDouble; Len : Integer) : Double; stdcall;
nspwMax:function (Vec            : Psmallint;  Len : Integer) : smallint;  stdcall;

nspsMin:function (Vec            : Psingle;  Len : Integer) : single;  stdcall;
nspdMin:function (Vec            : PDouble; Len : Integer) : Double; stdcall;
nspwMin:function (Vec            : Psmallint;  Len : Integer) : smallint;  stdcall;

nspsMaxExt:function (Vec         : Psingle;  Len : Integer;
                var Index       : Integer)     : single;             stdcall;
nspdMaxExt:function (Vec         : PDouble; Len : Integer;
                var Index       : Integer)     : Double;            stdcall;
nspwMaxExt:function (Vec         : Psmallint;  Len : Integer;
                var Index       : Integer)     : smallint;             stdcall;
nspsMinExt:function (Vec         : Psingle;  Len : Integer;
                var Index       : Integer)     : single;             stdcall;
nspdMinExt:function (Vec         : PDouble; Len : Integer;
                var Index       : Integer)     : Double;            stdcall;
nspwMinExt:function (Vec         : Psmallint;  Len : Integer;
                var Index       : Integer)     : smallint;             stdcall;

nspsMean:function (Vec           : Psingle;  Len : Integer) : single;  stdcall;
nspdMean:function (Vec           : PDouble; Len : Integer) : Double; stdcall;
nspwMean:function (Vec           : Psmallint;  Len : Integer) : smallint;  stdcall;
nspcMean:function (Vec : PSCplx; Len : Integer; var Mean : TSCplx) : NSPStatus; stdcall;
nspzMean:function (Vec : PDCplx; Len : Integer; var Mean : TDCplx) : NSPStatus; stdcall;
nspvMean:function (Vec : PWCplx; Len : Integer; var Mean : TWCplx) : NSPStatus; stdcall;

nspsStdDev:function (Vec         : Psingle;  Len : Integer) : single;  stdcall;
nspdStdDev:function (Vec         : PDouble; Len : Integer) : Double; stdcall;
nspwStdDev:function (Vec         : Psmallint;  Len : Integer;
                    ScaleMode   : Integer;
                var ScaleFactor : Integer) : smallint; stdcall;

{EOF}
(*
From:    nspwin.h
Purpose: NSP Windowing Functions. Declaration
*)

{------------------------------------------------------------------------}
{                                                                        }
{   Win                                                                  }
{                                                                        }
{ Multiply a vector by a windowing function.                             }
{                                                                        }

nspsWinBartlett:procedure (Vec : Psingle;  N : Integer); stdcall;
nspcWinBartlett:procedure (Vec : PSCplx;  N : Integer); stdcall;
nspdWinBartlett:procedure (Vec : PDouble; N : Integer); stdcall;
nspzWinBartlett:procedure (Vec : PDCplx;  N : Integer); stdcall;
nspwWinBartlett:procedure (Vec : Psmallint;  N : Integer); stdcall;
nspvWinBartlett:procedure (Vec : PWCplx;  N : Integer); stdcall;

nspsWinBartlett2:procedure (Src : Psingle; Dst  : Psingle;  N : Integer); stdcall;
nspcWinBartlett2:procedure (Src : PSCplx; Dst  : PSCplx;  N : Integer); stdcall;
nspdWinBartlett2:procedure (Src : PDouble; Dst : PDouble; N : Integer); stdcall;
nspzWinBartlett2:procedure (Src : PDCplx; Dst  : PDCplx;  N : Integer); stdcall;
nspwWinBartlett2:procedure (Src : Psmallint; Dst  : Psmallint;  N : Integer); stdcall;
nspvWinBartlett2:procedure (Src : PWCplx; Dst  : PWCplx;  N : Integer); stdcall;

nspsWinHann:procedure (Vec : Psingle;  N : Integer); stdcall;
nspcWinHann:procedure (Vec : PSCplx;  N : Integer); stdcall;
nspdWinHann:procedure (Vec : PDouble; N : Integer); stdcall;
nspzWinHann:procedure (Vec : PDCplx;  N : Integer); stdcall;
nspwWinHann:procedure (Vec : Psmallint;  N : Integer); stdcall;
nspvWinHann:procedure (Vec : PWCplx;  N : Integer); stdcall;

nspsWinHann2:procedure (Src : Psingle;  Dst : Psingle;  N : Integer); stdcall;
nspcWinHann2:procedure (Src : PSCplx;  Dst : PSCplx;  N : Integer); stdcall;
nspdWinHann2:procedure (Src : PDouble; Dst : PDouble; N : Integer); stdcall;
nspzWinHann2:procedure (Src : PDCplx;  Dst : PDCplx;  N : Integer); stdcall;
nspwWinHann2:procedure (Src : Psmallint;  Dst : Psmallint;  N : Integer); stdcall;
nspvWinHann2:procedure (Src : PWCplx;  Dst : PWCplx;  N : Integer); stdcall;

nspsWinHamming:procedure (Vec : Psingle;  N : Integer); stdcall;
nspcWinHamming:procedure (Vec : PSCplx;  N : Integer); stdcall;
nspdWinHamming:procedure (Vec : PDouble; N : Integer); stdcall;
nspzWinHamming:procedure (Vec : PDCplx;  N : Integer); stdcall;
nspwWinHamming:procedure (Vec : Psmallint;  N : Integer); stdcall;
nspvWinHamming:procedure (Vec : PWCplx;  N : Integer); stdcall;

nspsWinHamming2:procedure (Src : Psingle;  Dst : Psingle;  N : Integer); stdcall;
nspcWinHamming2:procedure (Src : PSCplx;  Dst : PSCplx;  N : Integer); stdcall;
nspdWinHamming2:procedure (Src : PDouble; Dst : PDouble; N : Integer); stdcall;
nspzWinHamming2:procedure (Src : PDCplx;  Dst : PDCplx;  N : Integer); stdcall;
nspwWinHamming2:procedure (Src : Psmallint;  Dst : Psmallint;  N : Integer); stdcall;
nspvWinHamming2:procedure (Src : PWCplx;  Dst : PWCplx;  N : Integer); stdcall;

nspsWinBlackman:procedure (Vec : Psingle;  N : Integer; Alpha : single);  stdcall;
nspcWinBlackman:procedure (Vec : PSCplx;  N : Integer; Alpha : single);  stdcall;
nspdWinBlackman:procedure (Vec : PDouble; N : Integer; Alpha : Double); stdcall;
nspzWinBlackman:procedure (Vec : PDCplx;  N : Integer; Alpha : Double); stdcall;
nspwWinBlackman:procedure (Vec : Psmallint;  N : Integer; Alpha : single);  stdcall;
nspvWinBlackman:procedure (Vec : PWCplx;  N : Integer; Alpha : single);  stdcall;

nspsWinBlackman2:procedure (Src : Psingle;  Dst : Psingle;  N : Integer; Alpha : single);  stdcall;
nspcWinBlackman2:procedure (Src : PSCplx;  Dst : PSCplx;  N : Integer; Alpha : single);  stdcall;
nspdWinBlackman2:procedure (Src : PDouble; Dst : PDouble; N : Integer; Alpha : Double); stdcall;
nspzWinBlackman2:procedure (Src : PDCplx;  Dst : PDCplx;  N : Integer; Alpha : Double); stdcall;
nspwWinBlackman2:procedure (Src : Psmallint;  Dst : Psmallint;  N : Integer; Alpha : single);  stdcall;
nspvWinBlackman2:procedure (Src : PWCplx;  Dst : PWCplx;  N : Integer; Alpha : single);  stdcall;

nspsWinBlackmanStd:procedure (Vec : Psingle;  N : Integer); stdcall;
nspcWinBlackmanStd:procedure (Vec : PSCplx;  N : Integer); stdcall;
nspdWinBlackmanStd:procedure (Vec : PDouble; N : Integer); stdcall;
nspzWinBlackmanStd:procedure (Vec : PDCplx;  N : Integer); stdcall;
nspwWinBlackmanStd:procedure (Vec : Psmallint;  N : Integer); stdcall;
nspvWinBlackmanStd:procedure (Vec : PWCplx;  N : Integer); stdcall;

nspsWinBlackmanStd2:procedure (Src : Psingle;  Dst : Psingle;  N : Integer); stdcall;
nspcWinBlackmanStd2:procedure (Src : PSCplx;  Dst : PSCplx;  N : Integer); stdcall;
nspdWinBlackmanStd2:procedure (Src : PDouble; Dst : PDouble; N : Integer); stdcall;
nspzWinBlackmanStd2:procedure (Src : PDCplx;  Dst : PDCplx;  N : Integer); stdcall;
nspwWinBlackmanStd2:procedure (Src : Psmallint;  Dst : Psmallint;  N : Integer); stdcall;
nspvWinBlackmanStd2:procedure (Src : PWCplx;  Dst : PWCplx;  N : Integer); stdcall;

nspsWinBlackmanOpt:procedure (Vec : Psingle;  N : Integer); stdcall;
nspcWinBlackmanOpt:procedure (Vec : PSCplx;  N : Integer); stdcall;
nspdWinBlackmanOpt:procedure (Vec : PDouble; N : Integer); stdcall;
nspzWinBlackmanOpt:procedure (Vec : PDCplx;  N : Integer); stdcall;
nspwWinBlackmanOpt:procedure (Vec : Psmallint;  N : Integer); stdcall;
nspvWinBlackmanOpt:procedure (Vec : PWCplx;  N : Integer); stdcall;

nspsWinBlackmanOpt2:procedure (Src : Psingle;  Dst : Psingle;  N : Integer); stdcall;
nspcWinBlackmanOpt2:procedure (Src : PSCplx;  Dst : PSCplx;  N : Integer); stdcall;
nspdWinBlackmanOpt2:procedure (Src : PDouble; Dst : PDouble; N : Integer); stdcall;
nspzWinBlackmanOpt2:procedure (Src : PDCplx;  Dst : PDCplx;  N : Integer); stdcall;
nspwWinBlackmanOpt2:procedure (Src : Psmallint;  Dst : Psmallint;  N : Integer); stdcall;
nspvWinBlackmanOpt2:procedure (Src : PWCplx;  Dst : PWCplx;  N : Integer); stdcall;

nspsWinKaiser:procedure (Vec : Psingle;  N : Integer; Beta : single);  stdcall;
nspcWinKaiser:procedure (Vec : PSCplx;  N : Integer; Beta : single);  stdcall;
nspdWinKaiser:procedure (Vec : PDouble; N : Integer; Beta : Double); stdcall;
nspzWinKaiser:procedure (Vec : PDCplx;  N : Integer; Beta : Double); stdcall;
nspwWinKaiser:procedure (Vec : Psmallint;  N : Integer; Beta : single);  stdcall;
nspvWinKaiser:procedure (Vec : PWCplx;  N : Integer; Beta : single);  stdcall;

nspsWinKaiser2:procedure (Src : Psingle;  Dst : Psingle;  N : Integer; Beta : single);  stdcall;
nspcWinKaiser2:procedure (Src : PSCplx;  Dst : PSCplx;  N : Integer; Beta : single);  stdcall;
nspdWinKaiser2:procedure (Src : PDouble; Dst : PDouble; N : Integer; Beta : Double); stdcall;
nspzWinKaiser2:procedure (Src : PDCplx;  Dst : PDCplx;  N : Integer; Beta : Double); stdcall;
nspwWinKaiser2:procedure (Src : Psmallint;  Dst : Psmallint;  N : Integer; Beta : single);  stdcall;
nspvWinKaiser2:procedure (Src : PWCplx;  Dst : PWCplx;  N : Integer; Beta : single);  stdcall;

{EOF}
(*
From:    nspwlt.h
Purpose: NSP wavelet transform.
*)

{-------------------------------------------------------------------------}
{ Structure for store all information needed to decompose and reconstruct }
{ of wavelet transform:                                                   }
{-------------------------------------------------------------------------}

type
  TIntArray4     = array [0..3] of Integer;
  TPtrArray4     = array [0..3] of Pointer;
  TPFloatArray4  = array [0..3] of Psingle;
  TPDoubleArray4 = array [0..3] of PDouble;

  TNSPWtState = record
    WtCore    : Integer;
    WtType    : Integer;
    WtOrtType : Integer;
    Par1      : Integer;
    Par2      : Integer;
    DataOrder : Integer;
    Level     : Integer;
    Len_Filt  : TIntArray4;
    Ofs_Filt  : TIntArray4;
    Tap_Filt  : TPtrArray4;
    Src_Pad   : Pointer;
    Len_Dec   : Integer;
    Tree      : array [0..32] of Integer;
  end;

{ wtCore  -  for calculation core (single, double or smallint) control       }

const
  NSP_WtCoreFloat  =  1;
  NSP_WtCoreDouble =  2;
  NSP_WtCoreShort  =  4;

{ wtType  -  the type of wavelet                                         }

  NSP_Haar         =  1;
  NSP_Daublet      =  2;
  NSP_Symmlet      =  3;
  NSP_Coiflet      =  4;
  NSP_Vaidyanathan =  5;
  NSP_BSpline      =  6;
  NSP_BSplineDual  =  7;
  NSP_LinSpline    =  8;
  NSP_QuadSpline   =  9;
  NSP_WtByFilter   = 10;

{ wtOrtType  -  the orthogonality type of wavelet for add. control       }

  NSP_WtOrtType    =  1;
  NSP_WtBiOrtType  =  2;
  NSP_WtOrtUnknown =  3;

{
  par1, par2   -  the parameters of wavelet,
                  dependent from the type of wavelet.
  NSP_Haar           par1 - dummy
                     par2 - dummy
  NSP_Daublet        par1 = 1,2,3,4,5,6,7,8,9,10.
                     par2 - dummy
  NSP_Symmlet        par1 = 1,2,3,4,5,6,7.
                     par2 - dummy
  NSP_Coiflet        par1 = 1,2,3,4,5.
                     par2 - dummy
  NSP_Vaidyanathan   par1 - dummy
                     par2 - dummy

  NSP_BSpline        B - spline,
  NSP_BSplineDual               (par1, par2) must be:
                     box -
                         (1, 1 ), (1, 3 ), (1, 5 );
                     lin. spline -
                         (2, 2 ), (2, 4 ), (2, 6 ), (2, 8 );
                     quad. spline -
                         (3, 1 ), (3, 3 ), (3, 5 ), (3, 7 ), (3, 9 ).

  NSP_LinSpline      (eq. case NSP_BSpline with par1=2, par2=2.)
                     par1 - dummy
                     par2 - dummy
  NSP_QuadSpline     (eq. case NSP_BSpline with par1=3, par2=3.)
                     par1 - dummy
                     par2 - dummy
}

{ dataOrder  -  the length of data  L = pow(2,dataOrder)                 }

{ level  -  determines the number of levels of decompositions we need.   }

{
  Filters
  len_filt[] - length
  ofs_filt[] - offset
  tap_filt[] - taps
               [ 0 ] - low  pass analysis  filter
               [ 1 ] - high pass analysis  filter
               [ 2 ] - low  pass synthesis filter
               [ 3 ] - high pass synthesis filter
  Must be
      2 <= len_filt[ i ] ,
      0 <= ofs_filt[ i ] < len_filt[ i ] ,
      i = 0, 1, 2, 3;
      len_filt[ 0 ] = len_filt[ 3 ] ,
      len_filt[ 1 ] = len_filt[ 2 ] .

  src_pad - working array
}

{------------------------------------------------------------------------}
{                                                                        }
{ Free own wavelet memory                                                }
{                                                                        }
{------------------------------------------------------------------------}

var

nspWtFree:procedure (var State : TNSPWtState); stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                The initialization of the wavelet transform.            }
{                                                                        }
{------------------------------------------------------------------------}

nspsWtInit:procedure (Par1      : Integer;     Par2   : Integer;
                     DataOrder : Integer;     Level  : Integer;
                 var State     : TNSPWtState; WtType : Integer); stdcall;
nspdWtInit:procedure (Par1      : Integer;     Par2   : Integer;
                     DataOrder : Integer;     Level  : Integer;
                 var State     : TNSPWtState; WtType : Integer); stdcall;
nspwWtInit:procedure (Par1      : Integer;     Par2   : Integer;
                     DataOrder : Integer;     Level  : Integer;
                 var State     : TNSPWtState; WtType : Integer); stdcall;

nspsWtInitLen:procedure (Par1    : Integer;     Par2   : Integer;
                        Len     : Integer;     Level  : Integer;
                    var State   : TNSPWtState; WtType : Integer;
                    var Len_Dec : Integer);                      stdcall;
nspdWtInitLen:procedure (Par1    : Integer;     Par2   : Integer;
                        Len     : Integer;     Level  : Integer;
                    var State   : TNSPWtState; WtType : Integer;
                    var Len_Dec : Integer);                      stdcall;
nspwWtInitLen:procedure (Par1    : Integer;     Par2   : Integer;
                        Len     : Integer;     Level  : Integer;
                    var State   : TNSPWtState; WtType : Integer;
                    var Len_Dec : Integer);                      stdcall;

nspsWtInitUserFilter:function (Tap_Filt : TPFloatArray4;
                              Len_Filt : TIntArray4;
                              Ofs_Filt : TIntArray4;
                              Len      : Integer;
                              Level    : Integer;
                          var State    : TNSPWtState;
                          var Len_Dec  : Integer) : NSPStatus; stdcall;

nspdWtInitUserFilter:function (Tap_Filt : TPDoubleArray4;
                              Len_Filt : TIntArray4;
                              Ofs_Filt : TIntArray4;
                              Len      : Integer;
                              Level    : Integer;
                          var State    : TNSPWtState;
                          var Len_Dec  : Integer) : NSPStatus; stdcall;

nspwWtInitUserFilter:function (Tap_Filt : TPFloatArray4;
                              Len_Filt : TIntArray4;
                              Ofs_Filt : TIntArray4;
                              Len      : Integer;
                              Level    : Integer;
                          var State    : TNSPWtState;
                          var Len_Dec  : Integer) : NSPStatus; stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                      Set all parameters of wavelet.                    }
{                                                                        }
{------------------------------------------------------------------------}

nspsWtSetState:procedure (var State     : TNSPWtState;    WtType : Integer;
                             Par1      : Integer;        Par2   : Integer;
                             DataOrder : Integer;        Level  : Integer;
                             fTaps     : TPFloatArray4;  fLen   : TIntArray4;
                             fOffset   : TIntArray4);             stdcall;
nspdWtSetState:procedure (var State     : TNSPWtState;    WtType : Integer;
                             Par1      : Integer;        Par2   : Integer;
                             DataOrder : Integer;        Level  : Integer;
                             fTaps     : TPDoubleArray4; fLen   : TIntArray4;
                             fOffset   : TIntArray4);             stdcall;
nspwWtSetState:procedure (var State     : TNSPWtState;    WtType : Integer;
                             Par1      : Integer;        Par2   : Integer;
                             DataOrder : Integer;        Level  : Integer;
                             fTaps     : TPFloatArray4;  fLen   : TIntArray4;
                             fOffset   : TIntArray4);             stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                      Get all parameters of wavelet.                    }
{                                                                        }
{------------------------------------------------------------------------}

nspsWtGetState:procedure (var State     : TNSPWtState;    var WtType : Integer;
                         var Par1      : Integer;        var Par2   : Integer;
                         var DataOrder : Integer;        var Level  : Integer;
                         var fTaps     : TPFloatArray4;  var fLen   : TIntArray4;
                         var fOffset   : TIntArray4);                 stdcall;
nspdWtGetState:procedure (var State     : TNSPWtState;    var WtType : Integer;
                         var Par1      : Integer;        var Par2   : Integer;
                         var DataOrder : Integer;        var Level  : Integer;
                         var fTaps     : TPDoubleArray4; var fLen   : TIntArray4;
                         var fOffset   : TIntArray4);                 stdcall;
nspwWtGetState:procedure (var State     : TNSPWtState;    var WtType : Integer;
                         var Par1      : Integer;        var Par2   : Integer;
                         var DataOrder : Integer;        var Level  : Integer;
                         var fTaps     : TPFloatArray4;  var fLen   : TIntArray4;
                         var fOffset   : TIntArray4);                 stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                          Wavelet decomposition.                        }
{                                                                        }
{------------------------------------------------------------------------}

nspsWtDecompose:procedure (var State : TNSPWtState;
                              Src   : Psingle;
                              Dst   : Psingle);  stdcall;
nspdWtDecompose:procedure (var State : TNSPWtState;
                              Src   : PDouble;
                              Dst   : PDouble); stdcall;
nspwWtDecompose:procedure (var State : TNSPWtState;
                              Src   : Psmallint;
                              Dst   : Psmallint);  stdcall;

{------------------------------------------------------------------------}
{                                                                        }
{                         Wavelet reconstruction.                        }
{                                                                        }
{------------------------------------------------------------------------}

nspsWtReconstruct:procedure (var State : TNSPWtState;
                                Src   : Psingle;
                                Dst   : Psingle);  stdcall;
nspdWtReconstruct:procedure (var State : TNSPWtState;
                                Src   : PDouble;
                                Dst   : PDouble); stdcall;
nspwWtReconstruct:procedure (var State : TNSPWtState;
                                Src   : Psmallint;
                                Dst   : Psmallint);  stdcall;

{EOF}

IMPLEMENTATION

procedure ISPtest;
begin
  if not initISPL
    then sortieErreur('ISPL not initialized');
end;

procedure ISPend;
var
  error:integer;
begin
  setPrecisionMode(pmExtended);
  error:= nspGetErrStatus;

  if error<>0 then sortieErreur('ISPL error '+crlf+ nspErrorStr(error));
end;



function NSPsDegToRad(const Deg : single) : single;
begin
  Result := Deg / 180.0 * NSP_PI;
end;

function NSPdDegToRad(const Deg : Double) : Double;
begin
  Result := Deg / 180.0 * NSP_PI;
end;



{EOF}

function nspcAdd(A, B : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcAddOut(A,B,Val);
  Result := Val;
end;

function nspcSub(A, B : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcSubOut(A,B,Val);
  Result := Val;
end;

function nspcMpy(A, B : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcMpyOut(A,B,Val);
  Result := Val;
end;

function nspcDiv(A, B : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcDivOut(A,B,Val);
  Result := Val;
end;

function nspcConj(A : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcConjOut(A,Val);
  Result := Val;
end;


function nspcSet(Re, Im : single) : TSCplx;
var
  Val : TSCplx;
begin
  nspcSetOut(Re,Im,Val);
  Result := Val;
end;



function nspcDotProd(SrcA, SrcB  : PSCplx; Len : Integer) : TSCplx;
var
  Val : TSCplx;
begin
  nspcDotProdOut(SrcA,SrcB,Len,Val);
  Result := Val;
end;


function nspvDotProdExt(SrcA, SrcB  : PWCplx; Len : Integer;
                        ScaleMode   : Integer;
                    var ScaleFactor : Integer) : TICplx;
var
  Val : TICplx;
begin
  nspvDotProdExtOut(SrcA,SrcB,Len,ScaleMode,ScaleFactor,Val);
  Result := Val;
end;


function nspcFir(var State : TNSPFirState; Samp : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcFirOut(State,Samp,Val);
  Result := Val;
end;


function nspcFirl(var TapSt : TNSPFirTapState;
                  var DlySt : TNSPFirDlyState;
                      Samp  : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcFirlOut(TapSt,DlySt,Samp,Val);
  Result := Val;
end;


function nspsGoertz(var State  : TNSPSGoertzState;
                        Sample : single) : TSCplx;
var
  Val : TSCplx;
begin
  nspsGoertzOut(State,Sample,Val);
  Result := Val;
end;

function nspcGoertz(var State  : TNSPCGoertzState;
                        Sample : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcGoertzOut(State,Sample,Val);
  Result := Val;
end;


function nspsbGoertz(var State   : TNSPSGoertzState;
                         InSamps : Psingle;
                         Len     : Integer) : TSCplx;
var
  Val : TSCplx;
begin
  nspsbGoertzOut(State,InSamps,Len,Val);
  Result := Val;
end;

function nspcbGoertz(var State   : TNSPCGoertzState;
                         InSamps : PSCplx;
                         Len     : Integer) : TSCplx;
var
  Val : TSCplx;
begin
  nspcbGoertzOut(State,InSamps,Len,Val);
  Result := Val;
end;

function nspcIir(var State       : TNSPIirState;
                     Samp        : TSCplx)  : TSCplx;
var
  Val : TSCplx;
begin
  nspcIirOut(State,Samp,Val);
  Result := Val;
end;


function nspcIirl(const TapState    : TNSPIirTapState;
                  var   DlyState    : TNSPIirDlyState;
                        Samp        : TSCplx)  : TSCplx;
var
  Val : TSCplx;
begin
  nspcIirlOut(TapState,DlyState,Samp,Val);
  Result := Val;
end;

function nspcLms(var State : TNSPLmsState; Samp : TSCplx;
                     Err   : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcLmsOut(State,Samp,Err,Val);
  Result := Val;
end;

function nspcbLms(var State : TNSPLmsState; InSamps  : PSCplx;
                      Err   : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcbLmsOut(State,InSamps,Err,Val);
  Result := Val;
end;

function nspcLmsDes(var State : TNSPLmsState; Samp : TSCplx;
                        Des   : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcLmsDesOut(State,Samp,Des,Val);
  Result := Val;
end;

function nspcLmsGetErrVal(const State : TNSPLmsState) : TSCplx;
var
  Val : TSCplx;
begin
  nspcLmsGetErrValOut(State,Val);
  Result := Val;
end;

function nspcLmsl(var TapSt : TNSPLmsTapState;
                  var DlySt : TNSPLmsDlyState;
                      Samp  : TSCplx; Err : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcLmslOut(TapSt,DlySt,Samp,Err,Val);
  Result := Val;
end;

function nspcbLmsl(var TapSt   : TNSPLmsTapState;
                   var DlySt   : TNSPLmsDlyState;
                       InSamps : PSCplx; Err : TSCplx) : TSCplx;
var
  Val : TSCplx;
begin
  nspcbLmslOut(TapSt,DlySt,InSamps,Err,Val);
  Result := Val;
end;

function nspcLmslNa(const TapSt : TNSPLmsTapState;
                    var   DlySt : TNSPLmsDlyState;
                          Samp  : TSCplx) : TSCplx; stdcall;
var
  Val : TSCplx;
begin
  nspcLmslNaOut(TapSt,DlySt,Samp,Val);
  Result := Val;
end;

function  nspcRandUni(var State : TNSPCRandUniState) : TSCplx;
var
  Val : TSCplx;
begin
  nspcRandUniOut(State,Val);
  Result := Val;
end;

function nspcRandGaus(var State : TNSPCRandGausState) : TSCplx;
var
  Val : TSCplx;
begin
  nspcRandGausOut(State,Val);
  Result := Val;
end;

function nspcTone(var State : TNSPCToneState) : TSCplx;
var
  Val : TSCplx;
begin
  nspcToneOut(State,Val);
  Result := Val;
end;

function nspcTrngl(var State : TNSPCTrnglState) : TSCplx;
var
  Val : TSCplx;
begin
  nspcTrnglOut(State,Val);
  Result := Val;
end;




var
  hh:integer;


function getProc(hh:Thandle;st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));
  if result=nil then messageCentral('ISPL:'+st+'=nil');
                 {else messageCentral(st+' OK');}
end;

function InitIspl:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary(NSPDLL);
  
  result:=(hh<>0);
  if not result then exit;

  nspMalloc:=getProc(hh,'nspMalloc');
  nspsMalloc:=getProc(hh,'nspsMalloc');
  nspdMalloc:=getProc(hh,'nspdMalloc');
  nspcMalloc:=getProc(hh,'nspcMalloc');
  nspzMalloc:=getProc(hh,'nspzMalloc');
  nspwMalloc:=getProc(hh,'nspwMalloc');
  nspvMalloc:=getProc(hh,'nspvMalloc');
  nspFree:=getProc(hh,'nspFree');
  nspcAddOut:=getProc(hh,'nspcAddOut');
  nspcSubOut:=getProc(hh,'nspcSubOut');
  nspcMpyOut:=getProc(hh,'nspcMpyOut');
  nspcDivOut:=getProc(hh,'nspcDivOut');
  nspcConjOut:=getProc(hh,'nspcConjOut');
  nspcSetOut:=getProc(hh,'nspcSetOut');
  nspsbZero:=getProc(hh,'nspsbZero');
  nspcbZero:=getProc(hh,'nspcbZero');
  nspsbSet:=getProc(hh,'nspsbSet');
  nspcbSet:=getProc(hh,'nspcbSet');
  nspsbCopy:=getProc(hh,'nspsbCopy');
  nspcbCopy:=getProc(hh,'nspcbCopy');
  nspsbAdd1:=getProc(hh,'nspsbAdd1');
  nspcbAdd1:=getProc(hh,'nspcbAdd1');
  nspsbAdd2:=getProc(hh,'nspsbAdd2');
  nspcbAdd2:=getProc(hh,'nspcbAdd2');
  nspsbAdd3:=getProc(hh,'nspsbAdd3');
  nspcbAdd3:=getProc(hh,'nspcbAdd3');
  nspsbSub1:=getProc(hh,'nspsbSub1');
  nspcbSub1:=getProc(hh,'nspcbSub1');
  nspsbSub2:=getProc(hh,'nspsbSub2');
  nspcbSub2:=getProc(hh,'nspcbSub2');
  nspsbSub3:=getProc(hh,'nspsbSub3');
  nspcbSub3:=getProc(hh,'nspcbSub3');
  nspsbMpy1:=getProc(hh,'nspsbMpy1');
  nspcbMpy1:=getProc(hh,'nspcbMpy1');
  nspsbMpy2:=getProc(hh,'nspsbMpy2');
  nspcbMpy2:=getProc(hh,'nspcbMpy2');
  nspsbMpy3:=getProc(hh,'nspsbMpy3');
  nspcbMpy3:=getProc(hh,'nspcbMpy3');
  nspcbConj1:=getProc(hh,'nspcbConj1');
  nspcbConj2:=getProc(hh,'nspcbConj2');
  nspcbConjFlip2:=getProc(hh,'nspcbConjFlip2');
  nspcbConjExtend1:=getProc(hh,'nspcbConjExtend1');
  nspcbConjExtend2:=getProc(hh,'nspcbConjExtend2');
  nspvAdd:=getProc(hh,'nspvAdd');
  nspvSub:=getProc(hh,'nspvSub');
  nspvMpy:=getProc(hh,'nspvMpy');
  nspvDiv:=getProc(hh,'nspvDiv');
  nspvConj:=getProc(hh,'nspvConj');
  nspvSet:=getProc(hh,'nspvSet');
  nspwbZero:=getProc(hh,'nspwbZero');
  nspvbZero:=getProc(hh,'nspvbZero');
  nspwbSet:=getProc(hh,'nspwbSet');
  nspvbSet:=getProc(hh,'nspvbSet');
  nspwbCopy:=getProc(hh,'nspwbCopy');
  nspvbCopy:=getProc(hh,'nspvbCopy');
  nspwbAdd1:=getProc(hh,'nspwbAdd1');
  nspvbAdd1:=getProc(hh,'nspvbAdd1');
  nspwbAdd2:=getProc(hh,'nspwbAdd2');
  nspvbAdd2:=getProc(hh,'nspvbAdd2');
  nspwbAdd3:=getProc(hh,'nspwbAdd3');
  nspvbAdd3:=getProc(hh,'nspvbAdd3');
  nspwbSub1:=getProc(hh,'nspwbSub1');
  nspvbSub1:=getProc(hh,'nspvbSub1');
  nspwbSub2:=getProc(hh,'nspwbSub2');
  nspvbSub2:=getProc(hh,'nspvbSub2');
  nspwbSub3:=getProc(hh,'nspwbSub3');
  nspvbSub3:=getProc(hh,'nspvbSub3');
  nspwbMpy1:=getProc(hh,'nspwbMpy1');
  nspvbMpy1:=getProc(hh,'nspvbMpy1');
  nspwbMpy2:=getProc(hh,'nspwbMpy2');
  nspvbMpy2:=getProc(hh,'nspvbMpy2');
  nspwbMpy3:=getProc(hh,'nspwbMpy3');
  nspvbMpy3:=getProc(hh,'nspvbMpy3');
  nspvbConj1:=getProc(hh,'nspvbConj1');
  nspvbConj2:=getProc(hh,'nspvbConj2');
  nspvbConjFlip2:=getProc(hh,'nspvbConjFlip2');
  nspvbConjExtend1:=getProc(hh,'nspvbConjExtend1');
  nspvbConjExtend2:=getProc(hh,'nspvbConjExtend2');
  nspzAdd:=getProc(hh,'nspzAdd');
  nspzSub:=getProc(hh,'nspzSub');
  nspzMpy:=getProc(hh,'nspzMpy');
  nspzDiv:=getProc(hh,'nspzDiv');
  nspzConj:=getProc(hh,'nspzConj');
  nspzSet:=getProc(hh,'nspzSet');
  nspdbZero:=getProc(hh,'nspdbZero');
  nspzbZero:=getProc(hh,'nspzbZero');
  nspdbSet:=getProc(hh,'nspdbSet');
  nspzbSet:=getProc(hh,'nspzbSet');
  nspdbCopy:=getProc(hh,'nspdbCopy');
  nspzbCopy:=getProc(hh,'nspzbCopy');
  nspdbAdd1:=getProc(hh,'nspdbAdd1');
  nspzbAdd1:=getProc(hh,'nspzbAdd1');
  nspdbAdd2:=getProc(hh,'nspdbAdd2');
  nspzbAdd2:=getProc(hh,'nspzbAdd2');
  nspdbAdd3:=getProc(hh,'nspdbAdd3');
  nspzbAdd3:=getProc(hh,'nspzbAdd3');
  nspdbSub1:=getProc(hh,'nspdbSub1');
  nspzbSub1:=getProc(hh,'nspzbSub1');
  nspdbSub2:=getProc(hh,'nspdbSub2');
  nspzbSub2:=getProc(hh,'nspzbSub2');
  nspdbSub3:=getProc(hh,'nspdbSub3');
  nspzbSub3:=getProc(hh,'nspzbSub3');
  nspdbMpy1:=getProc(hh,'nspdbMpy1');
  nspzbMpy1:=getProc(hh,'nspzbMpy1');
  nspdbMpy2:=getProc(hh,'nspdbMpy2');
  nspzbMpy2:=getProc(hh,'nspzbMpy2');
  nspdbMpy3:=getProc(hh,'nspdbMpy3');
  nspzbMpy3:=getProc(hh,'nspzbMpy3');
  nspzbConj1:=getProc(hh,'nspzbConj1');
  nspzbConj2:=getProc(hh,'nspzbConj2');
  nspzbConjFlip2:=getProc(hh,'nspzbConjFlip2');
  nspzbConjExtend1:=getProc(hh,'nspzbConjExtend1');
  nspzbConjExtend2:=getProc(hh,'nspzbConjExtend2');
  nspsbArctan1:=getProc(hh,'nspsbArctan1');
  nspsbArctan2:=getProc(hh,'nspsbArctan2');
  nspdbArctan1:=getProc(hh,'nspdbArctan1');
  nspdbArctan2:=getProc(hh,'nspdbArctan2');
  nspsConv2D:=getProc(hh,'nspsConv2D');
  nspdConv2D:=getProc(hh,'nspdConv2D');
  nspwConv2D:=getProc(hh,'nspwConv2D');
  nspsConv:=getProc(hh,'nspsConv');
  nspcConv:=getProc(hh,'nspcConv');

  nspscConv:=getProc(hh,'nspscConv');
  nspcsConv:=getProc(hh,'nspcsConv');
  nspdzConv:=getProc(hh,'nspdzConv');
  nspzdConv:=getProc(hh,'nspzdConv');

  nspdConv:=getProc(hh,'nspdConv');
  nspzConv:=getProc(hh,'nspzConv');
  nspwConv:=getProc(hh,'nspwConv');
  nspsAutoCorr:=getProc(hh,'nspsAutoCorr');
  nspcAutoCorr:=getProc(hh,'nspcAutoCorr');
  nspdAutoCorr:=getProc(hh,'nspdAutoCorr');
  nspzAutoCorr:=getProc(hh,'nspzAutoCorr');
  nspwAutoCorr:=getProc(hh,'nspwAutoCorr');
  nspvAutoCorr:=getProc(hh,'nspvAutoCorr');
  nspsCrossCorr:=getProc(hh,'nspsCrossCorr');
  nspcCrossCorr:=getProc(hh,'nspcCrossCorr');
  nspdCrossCorr:=getProc(hh,'nspdCrossCorr');
  nspzCrossCorr:=getProc(hh,'nspzCrossCorr');
  nspwCrossCorr:=getProc(hh,'nspwCrossCorr');
  nspvCrossCorr:=getProc(hh,'nspvCrossCorr');
  nspsbFloatToInt:=getProc(hh,'nspsbFloatToInt');
  nspdbFloatToInt:=getProc(hh,'nspdbFloatToInt');
  nspsbIntToFloat:=getProc(hh,'nspsbIntToFloat');
  nspdbIntToFloat:=getProc(hh,'nspdbIntToFloat');
  nspsbFloatToFix:=getProc(hh,'nspsbFloatToFix');
  nspdbFloatToFix:=getProc(hh,'nspdbFloatToFix');
  nspsbFixToFloat:=getProc(hh,'nspsbFixToFloat');
  nspdbFixToFloat:=getProc(hh,'nspdbFixToFloat');
  nspsbFloatToS31Fix:=getProc(hh,'nspsbFloatToS31Fix');
  nspsbFloatToS15Fix:=getProc(hh,'nspsbFloatToS15Fix');
  nspsbFloatToS7Fix:=getProc(hh,'nspsbFloatToS7Fix');
  nspsbFloatToS1516Fix:=getProc(hh,'nspsbFloatToS1516Fix');
  nspdbFloatToS31Fix:=getProc(hh,'nspdbFloatToS31Fix');
  nspdbFloatToS15Fix:=getProc(hh,'nspdbFloatToS15Fix');
  nspdbFloatToS7Fix:=getProc(hh,'nspdbFloatToS7Fix');
  nspdbFloatToS1516Fix:=getProc(hh,'nspdbFloatToS1516Fix');
  nspsbS31FixToFloat:=getProc(hh,'nspsbS31FixToFloat');
  nspsbS15FixToFloat:=getProc(hh,'nspsbS15FixToFloat');
  nspsbS7FixToFloat:=getProc(hh,'nspsbS7FixToFloat');
  nspsbS1516FixToFloat:=getProc(hh,'nspsbS1516FixToFloat');
  nspdbS31FixToFloat:=getProc(hh,'nspdbS31FixToFloat');
  nspdbS15FixToFloat:=getProc(hh,'nspdbS15FixToFloat');
  nspdbS7FixToFloat:=getProc(hh,'nspdbS7FixToFloat');
  nspdbS1516FixToFloat:=getProc(hh,'nspdbS1516FixToFloat');
  nspcbReal:=getProc(hh,'nspcbReal');
  nspzbReal:=getProc(hh,'nspzbReal');
  nspvbReal:=getProc(hh,'nspvbReal');
  nspcbImag:=getProc(hh,'nspcbImag');
  nspzbImag:=getProc(hh,'nspzbImag');
  nspvbImag:=getProc(hh,'nspvbImag');
  nspcbCplxTo2Real:=getProc(hh,'nspcbCplxTo2Real');
  nspzbCplxTo2Real:=getProc(hh,'nspzbCplxTo2Real');
  nspvbCplxTo2Real:=getProc(hh,'nspvbCplxTo2Real');
  nspcb2RealToCplx:=getProc(hh,'nspcb2RealToCplx');
  nspzb2RealToCplx:=getProc(hh,'nspzb2RealToCplx');
  nspvb2RealToCplx:=getProc(hh,'nspvb2RealToCplx');
  nspcbCartToPolar:=getProc(hh,'nspcbCartToPolar');
  nspzbCartToPolar:=getProc(hh,'nspzbCartToPolar');
  nspsbrCartToPolar:=getProc(hh,'nspsbrCartToPolar');
  nspdbrCartToPolar:=getProc(hh,'nspdbrCartToPolar');
  nspcbPolarToCart:=getProc(hh,'nspcbPolarToCart');
  nspzbPolarToCart:=getProc(hh,'nspzbPolarToCart');
  nspsbrPolarToCart:=getProc(hh,'nspsbrPolarToCart');
  nspdbrPolarToCart:=getProc(hh,'nspdbrPolarToCart');
  nspcbMag:=getProc(hh,'nspcbMag');
  nspzbMag:=getProc(hh,'nspzbMag');
  nspvbMag:=getProc(hh,'nspvbMag');
  nspsbrMag:=getProc(hh,'nspsbrMag');
  nspdbrMag:=getProc(hh,'nspdbrMag');
  nspwbrMag:=getProc(hh,'nspwbrMag');
  nspcbPhase:=getProc(hh,'nspcbPhase');
  nspzbPhase:=getProc(hh,'nspzbPhase');
  nspvbPhase:=getProc(hh,'nspvbPhase');
  nspsbrPhase:=getProc(hh,'nspsbrPhase');
  nspdbrPhase:=getProc(hh,'nspdbrPhase');
  nspwbrPhase:=getProc(hh,'nspwbrPhase');
  nspcbPowerSpectr:=getProc(hh,'nspcbPowerSpectr');
  nspzbPowerSpectr:=getProc(hh,'nspzbPowerSpectr');
  nspvbPowerSpectr:=getProc(hh,'nspvbPowerSpectr');
  nspsbrPowerSpectr:=getProc(hh,'nspsbrPowerSpectr');
  nspdbrPowerSpectr:=getProc(hh,'nspdbrPowerSpectr');
  nspwbrPowerSpectr:=getProc(hh,'nspwbrPowerSpectr');
  nspsDct:=getProc(hh,'nspsDct');
  nspdDct:=getProc(hh,'nspdDct');
  nspwDct:=getProc(hh,'nspwDct');
  nspsbDiv1:=getProc(hh,'nspsbDiv1');
  nspdbDiv1:=getProc(hh,'nspdbDiv1');
  nspwbDiv1:=getProc(hh,'nspwbDiv1');
  nspcbDiv1:=getProc(hh,'nspcbDiv1');
  nspzbDiv1:=getProc(hh,'nspzbDiv1');
  nspvbDiv1:=getProc(hh,'nspvbDiv1');
  nspsbDiv2:=getProc(hh,'nspsbDiv2');
  nspdbDiv2:=getProc(hh,'nspdbDiv2');
  nspwbDiv2:=getProc(hh,'nspwbDiv2');
  nspcbDiv2:=getProc(hh,'nspcbDiv2');
  nspzbDiv2:=getProc(hh,'nspzbDiv2');
  nspvbDiv2:=getProc(hh,'nspvbDiv2');
  nspsbDiv3:=getProc(hh,'nspsbDiv3');
  nspdbDiv3:=getProc(hh,'nspdbDiv3');
  nspwbDiv3:=getProc(hh,'nspwbDiv3');
  nspcbDiv3:=getProc(hh,'nspcbDiv3');
  nspzbDiv3:=getProc(hh,'nspzbDiv3');
  nspvbDiv3:=getProc(hh,'nspvbDiv3');
  nspsDotProd:=getProc(hh,'nspsDotProd');
  nspcDotProdOut:=getProc(hh,'nspcDotProdOut');
  nspdDotProd:=getProc(hh,'nspdDotProd');
  nspzDotProd:=getProc(hh,'nspzDotProd');
  nspwDotProd:=getProc(hh,'nspwDotProd');
  nspvDotProd:=getProc(hh,'nspvDotProd');
  nspwDotProdExt:=getProc(hh,'nspwDotProdExt');
  nspvDotProdExtOut:=getProc(hh,'nspvDotProdExtOut');
  nspGetLibVersion:=getProc(hh,'nspGetLibVersion');
  nspGetErrStatus:=getProc(hh,'nspGetErrStatus');
  nspSetErrStatus:=getProc(hh,'nspSetErrStatus');
  nspGetErrMode:=getProc(hh,'nspGetErrMode');
  nspSetErrMode:=getProc(hh,'nspSetErrMode');
  nspError:=getProc(hh,'nspError');
  nspErrorStr:=getProc(hh,'nspErrorStr');
  nspNulDevReport:=getProc(hh,'nspNulDevReport');
  nspStdErrReport:=getProc(hh,'nspStdErrReport');
  nspGuiBoxReport:=getProc(hh,'nspGuiBoxReport');
  nspRedirectError:=getProc(hh,'nspRedirectError');
  nspvDft:=getProc(hh,'nspvDft');
  nspcDft:=getProc(hh,'nspcDft');
  nspzDft:=getProc(hh,'nspzDft');
  nspvFft:=getProc(hh,'nspvFft');
  nspcFft:=getProc(hh,'nspcFft');
  nspzFft:=getProc(hh,'nspzFft');
  nspvFftNip:=getProc(hh,'nspvFftNip');
  nspcFftNip:=getProc(hh,'nspcFftNip');
  nspzFftNip:=getProc(hh,'nspzFftNip');
  nspvrFft:=getProc(hh,'nspvrFft');
  nspcrFft:=getProc(hh,'nspcrFft');
  nspzrFft:=getProc(hh,'nspzrFft');
  nspvrFftNip:=getProc(hh,'nspvrFftNip');
  nspcrFftNip:=getProc(hh,'nspcrFftNip');
  nspzrFftNip:=getProc(hh,'nspzrFftNip');
  nspwRealFftl:=getProc(hh,'nspwRealFftl');
  nspsRealFftl:=getProc(hh,'nspsRealFftl');
  nspdRealFftl:=getProc(hh,'nspdRealFftl');
  nspwRealFftlNip:=getProc(hh,'nspwRealFftlNip');
  nspsRealFftlNip:=getProc(hh,'nspsRealFftlNip');
  nspdRealFftlNip:=getProc(hh,'nspdRealFftlNip');
  nspwCcsFftl:=getProc(hh,'nspwCcsFftl');
  nspsCcsFftl:=getProc(hh,'nspsCcsFftl');
  nspdCcsFftl:=getProc(hh,'nspdCcsFftl');
  nspwCcsFftlNip:=getProc(hh,'nspwCcsFftlNip');
  nspsCcsFftlNip:=getProc(hh,'nspsCcsFftlNip');
  nspdCcsFftlNip:=getProc(hh,'nspdCcsFftlNip');
  nspwMpyRCPack2:=getProc(hh,'nspwMpyRCPack2');
  nspsMpyRCPack2:=getProc(hh,'nspsMpyRCPack2');
  nspdMpyRCPack2:=getProc(hh,'nspdMpyRCPack2');
  nspwMpyRCPack3:=getProc(hh,'nspwMpyRCPack3');
  nspsMpyRCPack3:=getProc(hh,'nspsMpyRCPack3');
  nspdMpyRCPack3:=getProc(hh,'nspdMpyRCPack3');
  nspwMpyRCPerm2:=getProc(hh,'nspwMpyRCPerm2');
  nspsMpyRCPerm2:=getProc(hh,'nspsMpyRCPerm2');
  nspdMpyRCPerm2:=getProc(hh,'nspdMpyRCPerm2');
  nspwMpyRCPerm3:=getProc(hh,'nspwMpyRCPerm3');
  nspsMpyRCPerm3:=getProc(hh,'nspsMpyRCPerm3');
  nspdMpyRCPerm3:=getProc(hh,'nspdMpyRCPerm3');
  nspwRealFft:=getProc(hh,'nspwRealFft');
  nspsRealFft:=getProc(hh,'nspsRealFft');
  nspdRealFft:=getProc(hh,'nspdRealFft');
  nspwRealFftNip:=getProc(hh,'nspwRealFftNip');
  nspsRealFftNip:=getProc(hh,'nspsRealFftNip');
  nspdRealFftNip:=getProc(hh,'nspdRealFftNip');
  nspwCcsFft:=getProc(hh,'nspwCcsFft');
  nspsCcsFft:=getProc(hh,'nspsCcsFft');
  nspdCcsFft:=getProc(hh,'nspdCcsFft');
  nspwCcsFftNip:=getProc(hh,'nspwCcsFftNip');
  nspsCcsFftNip:=getProc(hh,'nspsCcsFftNip');
  nspdCcsFftNip:=getProc(hh,'nspdCcsFftNip');
  nspwReal2Fft:=getProc(hh,'nspwReal2Fft');
  nspsReal2Fft:=getProc(hh,'nspsReal2Fft');
  nspdReal2Fft:=getProc(hh,'nspdReal2Fft');
  nspwReal2FftNip:=getProc(hh,'nspwReal2FftNip');
  nspsReal2FftNip:=getProc(hh,'nspsReal2FftNip');
  nspdReal2FftNip:=getProc(hh,'nspdReal2FftNip');
  nspwCcs2Fft:=getProc(hh,'nspwCcs2Fft');
  nspsCcs2Fft:=getProc(hh,'nspsCcs2Fft');
  nspdCcs2Fft:=getProc(hh,'nspdCcs2Fft');
  nspwCcs2FftNip:=getProc(hh,'nspwCcs2FftNip');
  nspsCcs2FftNip:=getProc(hh,'nspsCcs2FftNip');
  nspdCcs2FftNip:=getProc(hh,'nspdCcs2FftNip');
  nspsFilter2D:=getProc(hh,'nspsFilter2D');
  nspdFilter2D:=getProc(hh,'nspdFilter2D');
  nspwFilter2D:=getProc(hh,'nspwFilter2D');
  nspdFirLowpass:=getProc(hh,'nspdFirLowpass');
  nspdFirHighpass:=getProc(hh,'nspdFirHighpass');
  nspdFirBandpass:=getProc(hh,'nspdFirBandpass');
  nspdFirBandstop:=getProc(hh,'nspdFirBandstop');
  nspsFirInit:=getProc(hh,'nspsFirInit');
  nspcFirInit:=getProc(hh,'nspcFirInit');
  nspdFirInit:=getProc(hh,'nspdFirInit');
  nspzFirInit:=getProc(hh,'nspzFirInit');
  nspwFirInit:=getProc(hh,'nspwFirInit');
  nspsFirInitMr:=getProc(hh,'nspsFirInitMr');
  nspcFirInitMr:=getProc(hh,'nspcFirInitMr');
  nspdFirInitMr:=getProc(hh,'nspdFirInitMr');
  nspzFirInitMr:=getProc(hh,'nspzFirInitMr');
  nspwFirInitMr:=getProc(hh,'nspwFirInitMr');
  nspFirFree:=getProc(hh,'nspFirFree');
  nspsFir:=getProc(hh,'nspsFir');
  nspcFirOut:=getProc(hh,'nspcFirOut');
  nspdFir:=getProc(hh,'nspdFir');
  nspzFir:=getProc(hh,'nspzFir');
  nspwFir:=getProc(hh,'nspwFir');
  nspsbFir:=getProc(hh,'nspsbFir');
  nspcbFir:=getProc(hh,'nspcbFir');
  nspdbFir:=getProc(hh,'nspdbFir');
  nspzbFir:=getProc(hh,'nspzbFir');
  nspwbFir:=getProc(hh,'nspwbFir');
  nspsFirGetTaps:=getProc(hh,'nspsFirGetTaps');
  nspcFirGetTaps:=getProc(hh,'nspcFirGetTaps');
  nspdFirGetTaps:=getProc(hh,'nspdFirGetTaps');
  nspzFirGetTaps:=getProc(hh,'nspzFirGetTaps');
  nspwFirGetTaps:=getProc(hh,'nspwFirGetTaps');
  nspsFirSetTaps:=getProc(hh,'nspsFirSetTaps');
  nspcFirSetTaps:=getProc(hh,'nspcFirSetTaps');
  nspdFirSetTaps:=getProc(hh,'nspdFirSetTaps');
  nspzFirSetTaps:=getProc(hh,'nspzFirSetTaps');
  nspwFirSetTaps:=getProc(hh,'nspwFirSetTaps');
  nspsFirGetDlyl:=getProc(hh,'nspsFirGetDlyl');
  nspcFirGetDlyl:=getProc(hh,'nspcFirGetDlyl');
  nspdFirGetDlyl:=getProc(hh,'nspdFirGetDlyl');
  nspzFirGetDlyl:=getProc(hh,'nspzFirGetDlyl');
  nspwFirGetDlyl:=getProc(hh,'nspwFirGetDlyl');
  nspsFirSetDlyl:=getProc(hh,'nspsFirSetDlyl');
  nspcFirSetDlyl:=getProc(hh,'nspcFirSetDlyl');
  nspdFirSetDlyl:=getProc(hh,'nspdFirSetDlyl');
  nspzFirSetDlyl:=getProc(hh,'nspzFirSetDlyl');
  nspwFirSetDlyl:=getProc(hh,'nspwFirSetDlyl');
  nspsFirlInit:=getProc(hh,'nspsFirlInit');
  nspdFirlInit:=getProc(hh,'nspdFirlInit');
  nspcFirlInit:=getProc(hh,'nspcFirlInit');
  nspzFirlInit:=getProc(hh,'nspzFirlInit');
  nspwFirlInit:=getProc(hh,'nspwFirlInit');
  nspsFirlInitMr:=getProc(hh,'nspsFirlInitMr');
  nspdFirlInitMr:=getProc(hh,'nspdFirlInitMr');
  nspcFirlInitMr:=getProc(hh,'nspcFirlInitMr');
  nspzFirlInitMr:=getProc(hh,'nspzFirlInitMr');
  nspwFirlInitMr:=getProc(hh,'nspwFirlInitMr');
  nspsFirlInitDlyl:=getProc(hh,'nspsFirlInitDlyl');
  nspcFirlInitDlyl:=getProc(hh,'nspcFirlInitDlyl');
  nspdFirlInitDlyl:=getProc(hh,'nspdFirlInitDlyl');
  nspzFirlInitDlyl:=getProc(hh,'nspzFirlInitDlyl');
  nspwFirlInitDlyl:=getProc(hh,'nspwFirlInitDlyl');
  nspsFirl:=getProc(hh,'nspsFirl');
  nspcFirlOut:=getProc(hh,'nspcFirlOut');
  nspdFirl:=getProc(hh,'nspdFirl');
  nspzFirl:=getProc(hh,'nspzFirl');
  nspwFirl:=getProc(hh,'nspwFirl');
  nspsbFirl:=getProc(hh,'nspsbFirl');
  nspcbFirl:=getProc(hh,'nspcbFirl');
  nspdbFirl:=getProc(hh,'nspdbFirl');
  nspzbFirl:=getProc(hh,'nspzbFirl');
  nspwbFirl:=getProc(hh,'nspwbFirl');
  nspsFirlGetTaps:=getProc(hh,'nspsFirlGetTaps');
  nspcFirlGetTaps:=getProc(hh,'nspcFirlGetTaps');
  nspdFirlGetTaps:=getProc(hh,'nspdFirlGetTaps');
  nspzFirlGetTaps:=getProc(hh,'nspzFirlGetTaps');
  nspwFirlGetTaps:=getProc(hh,'nspwFirlGetTaps');
  nspsFirlSetTaps:=getProc(hh,'nspsFirlSetTaps');
  nspcFirlSetTaps:=getProc(hh,'nspcFirlSetTaps');
  nspdFirlSetTaps:=getProc(hh,'nspdFirlSetTaps');
  nspzFirlSetTaps:=getProc(hh,'nspzFirlSetTaps');
  nspwFirlSetTaps:=getProc(hh,'nspwFirlSetTaps');
  nspsFirlGetDlyl:=getProc(hh,'nspsFirlGetDlyl');
  nspcFirlGetDlyl:=getProc(hh,'nspcFirlGetDlyl');
  nspdFirlGetDlyl:=getProc(hh,'nspdFirlGetDlyl');
  nspzFirlGetDlyl:=getProc(hh,'nspzFirlGetDlyl');
  nspwFirlGetDlyl:=getProc(hh,'nspwFirlGetDlyl');
  nspsFirlSetDlyl:=getProc(hh,'nspsFirlSetDlyl');
  nspcFirlSetDlyl:=getProc(hh,'nspcFirlSetDlyl');
  nspdFirlSetDlyl:=getProc(hh,'nspdFirlSetDlyl');
  nspzFirlSetDlyl:=getProc(hh,'nspzFirlSetDlyl');
  nspwFirlSetDlyl:=getProc(hh,'nspwFirlSetDlyl');
  nspsGoertzInit:=getProc(hh,'nspsGoertzInit');
  nspcGoertzInit:=getProc(hh,'nspcGoertzInit');
  nspdGoertzInit:=getProc(hh,'nspdGoertzInit');
  nspzGoertzInit:=getProc(hh,'nspzGoertzInit');
  nspwGoertzInit:=getProc(hh,'nspwGoertzInit');
  nspvGoertzInit:=getProc(hh,'nspvGoertzInit');
  nspsGoertzReset:=getProc(hh,'nspsGoertzReset');
  nspcGoertzReset:=getProc(hh,'nspcGoertzReset');
  nspdGoertzReset:=getProc(hh,'nspdGoertzReset');
  nspzGoertzReset:=getProc(hh,'nspzGoertzReset');
  nspwGoertzReset:=getProc(hh,'nspwGoertzReset');
  nspvGoertzReset:=getProc(hh,'nspvGoertzReset');
  nspdGoertz:=getProc(hh,'nspdGoertz');
  nspzGoertz:=getProc(hh,'nspzGoertz');
  nspwGoertz:=getProc(hh,'nspwGoertz');
  nspvGoertz:=getProc(hh,'nspvGoertz');
  nspdbGoertz:=getProc(hh,'nspdbGoertz');
  nspzbGoertz:=getProc(hh,'nspzbGoertz');
  nspwbGoertz:=getProc(hh,'nspwbGoertz');
  nspvbGoertz:=getProc(hh,'nspvbGoertz');
  nspsGoertzOut:=getProc(hh,'nspsGoertzOut');
  nspcGoertzOut:=getProc(hh,'nspcGoertzOut');
  nspsbGoertzOut:=getProc(hh,'nspsbGoertzOut');
  nspcbGoertzOut:=getProc(hh,'nspcbGoertzOut');
  nspsIirInit:=getProc(hh,'nspsIirInit');
  nspcIirInit:=getProc(hh,'nspcIirInit');
  nspdIirInit:=getProc(hh,'nspdIirInit');
  nspzIirInit:=getProc(hh,'nspzIirInit');
  nspwIirInit:=getProc(hh,'nspwIirInit');
  nspwIirInitGain:=getProc(hh,'nspwIirInitGain');
  nspsIirInitBq:=getProc(hh,'nspsIirInitBq');
  nspcIirInitBq:=getProc(hh,'nspcIirInitBq');
  nspdIirInitBq:=getProc(hh,'nspdIirInitBq');
  nspzIirInitBq:=getProc(hh,'nspzIirInitBq');
  nspwIirInitBq:=getProc(hh,'nspwIirInitBq');
  nspIirFree:=getProc(hh,'nspIirFree');
  nspsIir:=getProc(hh,'nspsIir');
  nspdIir:=getProc(hh,'nspdIir');
  nspzIir:=getProc(hh,'nspzIir');
  nspwIir:=getProc(hh,'nspwIir');
  nspcIirOut:=getProc(hh,'nspcIirOut');
  nspsbIir:=getProc(hh,'nspsbIir');
  nspcbIir:=getProc(hh,'nspcbIir');
  nspdbIir:=getProc(hh,'nspdbIir');
  nspzbIir:=getProc(hh,'nspzbIir');
  nspwbIir:=getProc(hh,'nspwbIir');
  nspwIirlInit:=getProc(hh,'nspwIirlInit');
  nspsIirlInit:=getProc(hh,'nspsIirlInit');
  nspcIirlInit:=getProc(hh,'nspcIirlInit');
  nspdIirlInit:=getProc(hh,'nspdIirlInit');
  nspzIirlInit:=getProc(hh,'nspzIirlInit');
  nspwIirlInitGain:=getProc(hh,'nspwIirlInitGain');
  nspwIirlInitBq:=getProc(hh,'nspwIirlInitBq');
  nspsIirlInitBq:=getProc(hh,'nspsIirlInitBq');
  nspcIirlInitBq:=getProc(hh,'nspcIirlInitBq');
  nspdIirlInitBq:=getProc(hh,'nspdIirlInitBq');
  nspzIirlInitBq:=getProc(hh,'nspzIirlInitBq');
  nspwIirlInitDlyl:=getProc(hh,'nspwIirlInitDlyl');
  nspsIirlInitDlyl:=getProc(hh,'nspsIirlInitDlyl');
  nspcIirlInitDlyl:=getProc(hh,'nspcIirlInitDlyl');
  nspdIirlInitDlyl:=getProc(hh,'nspdIirlInitDlyl');
  nspzIirlInitDlyl:=getProc(hh,'nspzIirlInitDlyl');
  nspwIirl:=getProc(hh,'nspwIirl');
  nspsIirl:=getProc(hh,'nspsIirl');
  nspdIirl:=getProc(hh,'nspdIirl');
  nspzIirl:=getProc(hh,'nspzIirl');
  nspcIirlOut:=getProc(hh,'nspcIirlOut');
  nspwbIirl:=getProc(hh,'nspwbIirl');
  nspsbIirl:=getProc(hh,'nspsbIirl');
  nspcbIirl:=getProc(hh,'nspcbIirl');
  nspdbIirl:=getProc(hh,'nspdbIirl');
  nspzbIirl:=getProc(hh,'nspzbIirl');
  nspwbLinToALaw:=getProc(hh,'nspwbLinToALaw');
  nspsbLinToALaw:=getProc(hh,'nspsbLinToALaw');
  nspdbLinToALaw:=getProc(hh,'nspdbLinToALaw');
  nspwbALawToLin:=getProc(hh,'nspwbALawToLin');
  nspsbALawToLin:=getProc(hh,'nspsbALawToLin');
  nspdbALawToLin:=getProc(hh,'nspdbALawToLin');
  nspwbLinToMuLaw:=getProc(hh,'nspwbLinToMuLaw');
  nspsbLinToMuLaw:=getProc(hh,'nspsbLinToMuLaw');
  nspdbLinToMuLaw:=getProc(hh,'nspdbLinToMuLaw');
  nspwbMuLawToLin:=getProc(hh,'nspwbMuLawToLin');
  nspsbMuLawToLin:=getProc(hh,'nspsbMuLawToLin');
  nspdbMuLawToLin:=getProc(hh,'nspdbMuLawToLin');
  nspMuLawToALaw:=getProc(hh,'nspMuLawToALaw');
  nspALawToMuLaw:=getProc(hh,'nspALawToMuLaw');
  nspsLmsInit:=getProc(hh,'nspsLmsInit');
  nspdLmsInit:=getProc(hh,'nspdLmsInit');
  nspcLmsInit:=getProc(hh,'nspcLmsInit');
  nspzLmsInit:=getProc(hh,'nspzLmsInit');
  nspsLmsInitMr:=getProc(hh,'nspsLmsInitMr');
  nspdLmsInitMr:=getProc(hh,'nspdLmsInitMr');
  nspcLmsInitMr:=getProc(hh,'nspcLmsInitMr');
  nspzLmsInitMr:=getProc(hh,'nspzLmsInitMr');
  nspLmsFree:=getProc(hh,'nspLmsFree');
  nspsLms:=getProc(hh,'nspsLms');
  nspdLms:=getProc(hh,'nspdLms');
  nspzLms:=getProc(hh,'nspzLms');
  nspsbLms:=getProc(hh,'nspsbLms');
  nspdbLms:=getProc(hh,'nspdbLms');
  nspzbLms:=getProc(hh,'nspzbLms');
  nspsLmsGetTaps:=getProc(hh,'nspsLmsGetTaps');
  nspdLmsGetTaps:=getProc(hh,'nspdLmsGetTaps');
  nspcLmsGetTaps:=getProc(hh,'nspcLmsGetTaps');
  nspzLmsGetTaps:=getProc(hh,'nspzLmsGetTaps');
  nspsLmsSetTaps:=getProc(hh,'nspsLmsSetTaps');
  nspdLmsSetTaps:=getProc(hh,'nspdLmsSetTaps');
  nspcLmsSetTaps:=getProc(hh,'nspcLmsSetTaps');
  nspzLmsSetTaps:=getProc(hh,'nspzLmsSetTaps');
  nspsLmsGetDlyl:=getProc(hh,'nspsLmsGetDlyl');
  nspdLmsGetDlyl:=getProc(hh,'nspdLmsGetDlyl');
  nspcLmsGetDlyl:=getProc(hh,'nspcLmsGetDlyl');
  nspzLmsGetDlyl:=getProc(hh,'nspzLmsGetDlyl');
  nspsLmsSetDlyl:=getProc(hh,'nspsLmsSetDlyl');
  nspdLmsSetDlyl:=getProc(hh,'nspdLmsSetDlyl');
  nspcLmsSetDlyl:=getProc(hh,'nspcLmsSetDlyl');
  nspzLmsSetDlyl:=getProc(hh,'nspzLmsSetDlyl');
  nspsLmsGetStep:=getProc(hh,'nspsLmsGetStep');
  nspsLmsGetLeak:=getProc(hh,'nspsLmsGetLeak');
  nspsLmsSetStep:=getProc(hh,'nspsLmsSetStep');
  nspsLmsSetLeak:=getProc(hh,'nspsLmsSetLeak');
  nspsLmsDes:=getProc(hh,'nspsLmsDes');
  nspdLmsDes:=getProc(hh,'nspdLmsDes');
  nspzLmsDes:=getProc(hh,'nspzLmsDes');
  nspsbLmsDes:=getProc(hh,'nspsbLmsDes');
  nspdbLmsDes:=getProc(hh,'nspdbLmsDes');
  nspcbLmsDes:=getProc(hh,'nspcbLmsDes');
  nspzbLmsDes:=getProc(hh,'nspzbLmsDes');
  nspsLmsGetErrVal:=getProc(hh,'nspsLmsGetErrVal');
  nspdLmsGetErrVal:=getProc(hh,'nspdLmsGetErrVal');
  nspzLmsGetErrVal:=getProc(hh,'nspzLmsGetErrVal');
  nspsLmsSetErrVal:=getProc(hh,'nspsLmsSetErrVal');
  nspdLmsSetErrVal:=getProc(hh,'nspdLmsSetErrVal');
  nspcLmsSetErrVal:=getProc(hh,'nspcLmsSetErrVal');
  nspzLmsSetErrVal:=getProc(hh,'nspzLmsSetErrVal');
  nspcLmsOut:=getProc(hh,'nspcLmsOut');
  nspcbLmsOut:=getProc(hh,'nspcbLmsOut');
  nspcLmsDesOut:=getProc(hh,'nspcLmsDesOut');
  nspcLmsGetErrValOut:=getProc(hh,'nspcLmsGetErrValOut');
  nspsLmslInit:=getProc(hh,'nspsLmslInit');
  nspdLmslInit:=getProc(hh,'nspdLmslInit');
  nspcLmslInit:=getProc(hh,'nspcLmslInit');
  nspzLmslInit:=getProc(hh,'nspzLmslInit');
  nspsLmslInitMr:=getProc(hh,'nspsLmslInitMr');
  nspdLmslInitMr:=getProc(hh,'nspdLmslInitMr');
  nspcLmslInitMr:=getProc(hh,'nspcLmslInitMr');
  nspzLmslInitMr:=getProc(hh,'nspzLmslInitMr');
  nspsLmslInitDlyl:=getProc(hh,'nspsLmslInitDlyl');
  nspdLmslInitDlyl:=getProc(hh,'nspdLmslInitDlyl');
  nspcLmslInitDlyl:=getProc(hh,'nspcLmslInitDlyl');
  nspzLmslInitDlyl:=getProc(hh,'nspzLmslInitDlyl');
  nspsLmslGetStep:=getProc(hh,'nspsLmslGetStep');
  nspsLmslGetLeak:=getProc(hh,'nspsLmslGetLeak');
  nspsLmslSetStep:=getProc(hh,'nspsLmslSetStep');
  nspsLmslSetLeak:=getProc(hh,'nspsLmslSetLeak');
  nspsLmsl:=getProc(hh,'nspsLmsl');
  nspdLmsl:=getProc(hh,'nspdLmsl');
  nspzLmsl:=getProc(hh,'nspzLmsl');
  nspcLmslOut:=getProc(hh,'nspcLmslOut');
  nspsbLmsl:=getProc(hh,'nspsbLmsl');
  nspdbLmsl:=getProc(hh,'nspdbLmsl');
  nspzbLmsl:=getProc(hh,'nspzbLmsl');
  nspcbLmslOut:=getProc(hh,'nspcbLmslOut');
  nspsLmslNa:=getProc(hh,'nspsLmslNa');
  nspdLmslNa:=getProc(hh,'nspdLmslNa');
  nspzLmslNa:=getProc(hh,'nspzLmslNa');
  nspcLmslNaOut:=getProc(hh,'nspcLmslNaOut');
  nspsbLmslNa:=getProc(hh,'nspsbLmslNa');
  nspcbLmslNa:=getProc(hh,'nspcbLmslNa');
  nspdbLmslNa:=getProc(hh,'nspdbLmslNa');
  nspzbLmslNa:=getProc(hh,'nspzbLmslNa');
  nspsLmslGetTaps:=getProc(hh,'nspsLmslGetTaps');
  nspcLmslGetTaps:=getProc(hh,'nspcLmslGetTaps');
  nspdLmslGetTaps:=getProc(hh,'nspdLmslGetTaps');
  nspzLmslGetTaps:=getProc(hh,'nspzLmslGetTaps');
  nspsLmslSetTaps:=getProc(hh,'nspsLmslSetTaps');
  nspcLmslSetTaps:=getProc(hh,'nspcLmslSetTaps');
  nspdLmslSetTaps:=getProc(hh,'nspdLmslSetTaps');
  nspzLmslSetTaps:=getProc(hh,'nspzLmslSetTaps');
  nspsLmslGetDlyl:=getProc(hh,'nspsLmslGetDlyl');
  nspcLmslGetDlyl:=getProc(hh,'nspcLmslGetDlyl');
  nspdLmslGetDlyl:=getProc(hh,'nspdLmslGetDlyl');
  nspzLmslGetDlyl:=getProc(hh,'nspzLmslGetDlyl');
  nspsLmslSetDlyl:=getProc(hh,'nspsLmslSetDlyl');
  nspcLmslSetDlyl:=getProc(hh,'nspcLmslSetDlyl');
  nspdLmslSetDlyl:=getProc(hh,'nspdLmslSetDlyl');
  nspzLmslSetDlyl:=getProc(hh,'nspzLmslSetDlyl');
  nspwLmslInitDlyl:=getProc(hh,'nspwLmslInitDlyl');
  nspwLmslSetDlyl:=getProc(hh,'nspwLmslSetDlyl');
  nspwLmslGetDlyl:=getProc(hh,'nspwLmslGetDlyl');
  nspwLmslInit:=getProc(hh,'nspwLmslInit');
  nspwLmslSetTaps:=getProc(hh,'nspwLmslSetTaps');
  nspwLmslGetTaps:=getProc(hh,'nspwLmslGetTaps');
  nspwLmsl:=getProc(hh,'nspwLmsl');
  nspwLmslGetStep:=getProc(hh,'nspwLmslGetStep');
  nspwLmslSetStep:=getProc(hh,'nspwLmslSetStep');
  nspsbLn1:=getProc(hh,'nspsbLn1');
  nspsbLn2:=getProc(hh,'nspsbLn2');
  nspsbExp1:=getProc(hh,'nspsbExp1');
  nspsbExp2:=getProc(hh,'nspsbExp2');
  nspdbLn1:=getProc(hh,'nspdbLn1');
  nspdbLn2:=getProc(hh,'nspdbLn2');
  nspdbExp1:=getProc(hh,'nspdbExp1');
  nspdbExp2:=getProc(hh,'nspdbExp2');
  nspwbLn1:=getProc(hh,'nspwbLn1');
  nspwbLn2:=getProc(hh,'nspwbLn2');
  nspwbExp1:=getProc(hh,'nspwbExp1');
  nspwbExp2:=getProc(hh,'nspwbExp2');
  nspsbLg1:=getProc(hh,'nspsbLg1');
  nspsbLg2:=getProc(hh,'nspsbLg2');
  nspdbLg1:=getProc(hh,'nspdbLg1');
  nspdbLg2:=getProc(hh,'nspdbLg2');
  nspcbLg1:=getProc(hh,'nspcbLg1');
  nspcbLg2:=getProc(hh,'nspcbLg2');
  nspwbShiftL:=getProc(hh,'nspwbShiftL');
  nspwbShiftR:=getProc(hh,'nspwbShiftR');
  nspwbAnd1:=getProc(hh,'nspwbAnd1');
  nspwbAnd2:=getProc(hh,'nspwbAnd2');
  nspwbAnd3:=getProc(hh,'nspwbAnd3');
  nspwbXor1:=getProc(hh,'nspwbXor1');
  nspwbXor2:=getProc(hh,'nspwbXor2');
  nspwbXor3:=getProc(hh,'nspwbXor3');
  nspwbOr1:=getProc(hh,'nspwbOr1');
  nspwbOr2:=getProc(hh,'nspwbOr2');
  nspwbOr3:=getProc(hh,'nspwbOr3');
  nspwbNot:=getProc(hh,'nspwbNot');
  nspsbMedianFilter1:=getProc(hh,'nspsbMedianFilter1');
  nspdbMedianFilter1:=getProc(hh,'nspdbMedianFilter1');
  nspwbMedianFilter1:=getProc(hh,'nspwbMedianFilter1');
  nspsbMedianFilter2:=getProc(hh,'nspsbMedianFilter2');
  nspdbMedianFilter2:=getProc(hh,'nspdbMedianFilter2');
  nspwbMedianFilter2:=getProc(hh,'nspwbMedianFilter2');
  nspBitRev:=getProc(hh,'nspBitRev');
  nspGetBitRevTbl:=getProc(hh,'nspGetBitRevTbl');
  nspCalcBitRevTbl:=getProc(hh,'nspCalcBitRevTbl');
  nspFreeBitRevTbls:=getProc(hh,'nspFreeBitRevTbls');
  nspwbBitRev1:=getProc(hh,'nspwbBitRev1');
  nspvbBitRev1:=getProc(hh,'nspvbBitRev1');
  nspsbBitRev1:=getProc(hh,'nspsbBitRev1');
  nspcbBitRev1:=getProc(hh,'nspcbBitRev1');
  nspdbBitRev1:=getProc(hh,'nspdbBitRev1');
  nspzbBitRev1:=getProc(hh,'nspzbBitRev1');
  nspwbBitRev2:=getProc(hh,'nspwbBitRev2');
  nspvbBitRev2:=getProc(hh,'nspvbBitRev2');
  nspsbBitRev2:=getProc(hh,'nspsbBitRev2');
  nspcbBitRev2:=getProc(hh,'nspcbBitRev2');
  nspdbBitRev2:=getProc(hh,'nspdbBitRev2');
  nspzbBitRev2:=getProc(hh,'nspzbBitRev2');
  nspvCalcDftTwdTbl:=getProc(hh,'nspvCalcDftTwdTbl');
  nspvCalcFftTwdTbl:=getProc(hh,'nspvCalcFftTwdTbl');
  nspcCalcDftTwdTbl:=getProc(hh,'nspcCalcDftTwdTbl');
  nspcCalcFftTwdTbl:=getProc(hh,'nspcCalcFftTwdTbl');
  nspzCalcDftTwdTbl:=getProc(hh,'nspzCalcDftTwdTbl');
  nspzCalcFftTwdTbl:=getProc(hh,'nspzCalcFftTwdTbl');
  nspvGetDftTwdTbl:=getProc(hh,'nspvGetDftTwdTbl');
  nspvGetFftTwdTbl:=getProc(hh,'nspvGetFftTwdTbl');
  nspcGetDftTwdTbl:=getProc(hh,'nspcGetDftTwdTbl');
  nspcGetFftTwdTbl:=getProc(hh,'nspcGetFftTwdTbl');
  nspzGetDftTwdTbl:=getProc(hh,'nspzGetDftTwdTbl');
  nspzGetFftTwdTbl:=getProc(hh,'nspzGetFftTwdTbl');
  nspvFreeTwdTbls:=getProc(hh,'nspvFreeTwdTbls');
  nspcFreeTwdTbls:=getProc(hh,'nspcFreeTwdTbls');
  nspzFreeTwdTbls:=getProc(hh,'nspzFreeTwdTbls');
  nspsNorm:=getProc(hh,'nspsNorm');
  nspcNorm:=getProc(hh,'nspcNorm');
  nspdNorm:=getProc(hh,'nspdNorm');
  nspzNorm:=getProc(hh,'nspzNorm');
  nspwNorm:=getProc(hh,'nspwNorm');
  nspvNorm:=getProc(hh,'nspvNorm');
  nspwNormExt:=getProc(hh,'nspwNormExt');
  nspvNormExt:=getProc(hh,'nspvNormExt');
  nspsbNormalize:=getProc(hh,'nspsbNormalize');
  nspcbNormalize:=getProc(hh,'nspcbNormalize');
  nspdbNormalize:=getProc(hh,'nspdbNormalize');
  nspzbNormalize:=getProc(hh,'nspzbNormalize');
  nspwbNormalize:=getProc(hh,'nspwbNormalize');
  nspvbNormalize:=getProc(hh,'nspvbNormalize');
  nspsSum:=getProc(hh,'nspsSum');
  nspdSum:=getProc(hh,'nspdSum');
  nspcSum:=getProc(hh,'nspcSum');
  nspzSum:=getProc(hh,'nspzSum');
  nspwSum:=getProc(hh,'nspwSum');
  nspsRandUniInit:=getProc(hh,'nspsRandUniInit');
  nspcRandUniInit:=getProc(hh,'nspcRandUniInit');
  nspdRandUniInit:=getProc(hh,'nspdRandUniInit');
  nspzRandUniInit:=getProc(hh,'nspzRandUniInit');
  nspwRandUniInit:=getProc(hh,'nspwRandUniInit');
  nspvRandUniInit:=getProc(hh,'nspvRandUniInit');
  nspsRandUni:=getProc(hh,'nspsRandUni');
  nspdRandUni:=getProc(hh,'nspdRandUni');
  nspzRandUni:=getProc(hh,'nspzRandUni');
  nspwRandUni:=getProc(hh,'nspwRandUni');
  nspvRandUni:=getProc(hh,'nspvRandUni');
  nspcRandUniOut:=getProc(hh,'nspcRandUniOut');
  nspsbRandUni:=getProc(hh,'nspsbRandUni');
  nspcbRandUni:=getProc(hh,'nspcbRandUni');
  nspdbRandUni:=getProc(hh,'nspdbRandUni');
  nspzbRandUni:=getProc(hh,'nspzbRandUni');
  nspwbRandUni:=getProc(hh,'nspwbRandUni');
  nspvbRandUni:=getProc(hh,'nspvbRandUni');
  nspsRandGausInit:=getProc(hh,'nspsRandGausInit');
  nspcRandGausInit:=getProc(hh,'nspcRandGausInit');
  nspdRandGausInit:=getProc(hh,'nspdRandGausInit');
  nspzRandGausInit:=getProc(hh,'nspzRandGausInit');
  nspwRandGausInit:=getProc(hh,'nspwRandGausInit');
  nspvRandGausInit:=getProc(hh,'nspvRandGausInit');
  nspsRandGaus:=getProc(hh,'nspsRandGaus');
  nspdRandGaus:=getProc(hh,'nspdRandGaus');
  nspzRandGaus:=getProc(hh,'nspzRandGaus');
  nspwRandGaus:=getProc(hh,'nspwRandGaus');
  nspvRandGaus:=getProc(hh,'nspvRandGaus');
  nspcRandGausOut:=getProc(hh,'nspcRandGausOut');
  nspsbRandGaus:=getProc(hh,'nspsbRandGaus');
  nspcbRandGaus:=getProc(hh,'nspcbRandGaus');
  nspdbRandGaus:=getProc(hh,'nspdbRandGaus');
  nspzbRandGaus:=getProc(hh,'nspzbRandGaus');
  nspwbRandGaus:=getProc(hh,'nspwbRandGaus');
  nspvbRandGaus:=getProc(hh,'nspvbRandGaus');
  nspsSampInit:=getProc(hh,'nspsSampInit');
  nspdSampInit:=getProc(hh,'nspdSampInit');
  nspsSamp:=getProc(hh,'nspsSamp');
  nspdSamp:=getProc(hh,'nspdSamp');
  nspSampFree:=getProc(hh,'nspSampFree');
  nspsUpSample:=getProc(hh,'nspsUpSample');
  nspcUpSample:=getProc(hh,'nspcUpSample');
  nspdUpSample:=getProc(hh,'nspdUpSample');
  nspzUpSample:=getProc(hh,'nspzUpSample');
  nspwUpSample:=getProc(hh,'nspwUpSample');
  nspvUpSample:=getProc(hh,'nspvUpSample');
  nspsDownSample:=getProc(hh,'nspsDownSample');
  nspcDownSample:=getProc(hh,'nspcDownSample');
  nspdDownSample:=getProc(hh,'nspdDownSample');
  nspzDownSample:=getProc(hh,'nspzDownSample');
  nspwDownSample:=getProc(hh,'nspwDownSample');
  nspvDownSample:=getProc(hh,'nspvDownSample');
  nspwToneInit:=getProc(hh,'nspwToneInit');
  nspvToneInit:=getProc(hh,'nspvToneInit');
  nspsToneInit:=getProc(hh,'nspsToneInit');
  nspcToneInit:=getProc(hh,'nspcToneInit');
  nspdToneInit:=getProc(hh,'nspdToneInit');
  nspzToneInit:=getProc(hh,'nspzToneInit');
  nspwTone:=getProc(hh,'nspwTone');
  nspvTone:=getProc(hh,'nspvTone');
  nspsTone:=getProc(hh,'nspsTone');
  nspdTone:=getProc(hh,'nspdTone');
  nspzTone:=getProc(hh,'nspzTone');
  nspcToneOut:=getProc(hh,'nspcToneOut');
  nspwbTone:=getProc(hh,'nspwbTone');
  nspvbTone:=getProc(hh,'nspvbTone');
  nspsbTone:=getProc(hh,'nspsbTone');
  nspcbTone:=getProc(hh,'nspcbTone');
  nspdbTone:=getProc(hh,'nspdbTone');
  nspzbTone:=getProc(hh,'nspzbTone');
  nspwTrnglInit:=getProc(hh,'nspwTrnglInit');
  nspvTrnglInit:=getProc(hh,'nspvTrnglInit');
  nspsTrnglInit:=getProc(hh,'nspsTrnglInit');
  nspcTrnglInit:=getProc(hh,'nspcTrnglInit');
  nspdTrnglInit:=getProc(hh,'nspdTrnglInit');
  nspzTrnglInit:=getProc(hh,'nspzTrnglInit');
  nspwTrngl:=getProc(hh,'nspwTrngl');
  nspvTrngl:=getProc(hh,'nspvTrngl');
  nspsTrngl:=getProc(hh,'nspsTrngl');
  nspdTrngl:=getProc(hh,'nspdTrngl');
  nspzTrngl:=getProc(hh,'nspzTrngl');
  nspcTrnglOut:=getProc(hh,'nspcTrnglOut');
  nspwbTrngl:=getProc(hh,'nspwbTrngl');
  nspvbTrngl:=getProc(hh,'nspvbTrngl');
  nspsbTrngl:=getProc(hh,'nspsbTrngl');
  nspcbTrngl:=getProc(hh,'nspcbTrngl');
  nspdbTrngl:=getProc(hh,'nspdbTrngl');
  nspzbTrngl:=getProc(hh,'nspzbTrngl');
  nspsbSqr1:=getProc(hh,'nspsbSqr1');
  nspcbSqr1:=getProc(hh,'nspcbSqr1');
  nspdbSqr1:=getProc(hh,'nspdbSqr1');
  nspzbSqr1:=getProc(hh,'nspzbSqr1');
  nspwbSqr1:=getProc(hh,'nspwbSqr1');
  nspvbSqr1:=getProc(hh,'nspvbSqr1');
  nspsbSqr2:=getProc(hh,'nspsbSqr2');
  nspcbSqr2:=getProc(hh,'nspcbSqr2');
  nspdbSqr2:=getProc(hh,'nspdbSqr2');
  nspzbSqr2:=getProc(hh,'nspzbSqr2');
  nspwbSqr2:=getProc(hh,'nspwbSqr2');
  nspvbSqr2:=getProc(hh,'nspvbSqr2');
  nspsbSqrt1:=getProc(hh,'nspsbSqrt1');
  nspcbSqrt1:=getProc(hh,'nspcbSqrt1');
  nspdbSqrt1:=getProc(hh,'nspdbSqrt1');
  nspzbSqrt1:=getProc(hh,'nspzbSqrt1');
  nspwbSqrt1:=getProc(hh,'nspwbSqrt1');
  nspvbSqrt1:=getProc(hh,'nspvbSqrt1');
  nspsbSqrt2:=getProc(hh,'nspsbSqrt2');
  nspcbSqrt2:=getProc(hh,'nspcbSqrt2');
  nspdbSqrt2:=getProc(hh,'nspdbSqrt2');
  nspzbSqrt2:=getProc(hh,'nspzbSqrt2');
  nspwbSqrt2:=getProc(hh,'nspwbSqrt2');
  nspvbSqrt2:=getProc(hh,'nspvbSqrt2');
  nspsbThresh1:=getProc(hh,'nspsbThresh1');
  nspcbThresh1:=getProc(hh,'nspcbThresh1');
  nspdbThresh1:=getProc(hh,'nspdbThresh1');
  nspzbThresh1:=getProc(hh,'nspzbThresh1');
  nspwbThresh1:=getProc(hh,'nspwbThresh1');
  nspvbThresh1:=getProc(hh,'nspvbThresh1');
  nspsbThresh2:=getProc(hh,'nspsbThresh2');
  nspcbThresh2:=getProc(hh,'nspcbThresh2');
  nspdbThresh2:=getProc(hh,'nspdbThresh2');
  nspzbThresh2:=getProc(hh,'nspzbThresh2');
  nspwbThresh2:=getProc(hh,'nspwbThresh2');
  nspvbThresh2:=getProc(hh,'nspvbThresh2');
  nspsbInvThresh1:=getProc(hh,'nspsbInvThresh1');
  nspcbInvThresh1:=getProc(hh,'nspcbInvThresh1');
  nspdbInvThresh1:=getProc(hh,'nspdbInvThresh1');
  nspzbInvThresh1:=getProc(hh,'nspzbInvThresh1');
  nspsbInvThresh2:=getProc(hh,'nspsbInvThresh2');
  nspcbInvThresh2:=getProc(hh,'nspcbInvThresh2');
  nspdbInvThresh2:=getProc(hh,'nspdbInvThresh2');
  nspzbInvThresh2:=getProc(hh,'nspzbInvThresh2');
  nspsbAbs1:=getProc(hh,'nspsbAbs1');
  nspdbAbs1:=getProc(hh,'nspdbAbs1');
  nspwbAbs1:=getProc(hh,'nspwbAbs1');
  nspsbAbs2:=getProc(hh,'nspsbAbs2');
  nspdbAbs2:=getProc(hh,'nspdbAbs2');
  nspwbAbs2:=getProc(hh,'nspwbAbs2');
  nspsMax:=getProc(hh,'nspsMax');
  nspdMax:=getProc(hh,'nspdMax');
  nspwMax:=getProc(hh,'nspwMax');
  nspsMin:=getProc(hh,'nspsMin');
  nspdMin:=getProc(hh,'nspdMin');
  nspwMin:=getProc(hh,'nspwMin');
  nspsMaxExt:=getProc(hh,'nspsMaxExt');
  nspdMaxExt:=getProc(hh,'nspdMaxExt');
  nspwMaxExt:=getProc(hh,'nspwMaxExt');
  nspsMinExt:=getProc(hh,'nspsMinExt');
  nspdMinExt:=getProc(hh,'nspdMinExt');
  nspwMinExt:=getProc(hh,'nspwMinExt');
  nspsMean:=getProc(hh,'nspsMean');
  nspdMean:=getProc(hh,'nspdMean');
  nspwMean:=getProc(hh,'nspwMean');
  nspcMean:=getProc(hh,'nspcMean');
  nspzMean:=getProc(hh,'nspzMean');
  nspvMean:=getProc(hh,'nspvMean');
  nspsStdDev:=getProc(hh,'nspsStdDev');
  nspdStdDev:=getProc(hh,'nspdStdDev');
  nspwStdDev:=getProc(hh,'nspwStdDev');
  nspsWinBartlett:=getProc(hh,'nspsWinBartlett');
  nspcWinBartlett:=getProc(hh,'nspcWinBartlett');
  nspdWinBartlett:=getProc(hh,'nspdWinBartlett');
  nspzWinBartlett:=getProc(hh,'nspzWinBartlett');
  nspwWinBartlett:=getProc(hh,'nspwWinBartlett');
  nspvWinBartlett:=getProc(hh,'nspvWinBartlett');
  nspsWinBartlett2:=getProc(hh,'nspsWinBartlett2');
  nspcWinBartlett2:=getProc(hh,'nspcWinBartlett2');
  nspdWinBartlett2:=getProc(hh,'nspdWinBartlett2');
  nspzWinBartlett2:=getProc(hh,'nspzWinBartlett2');
  nspwWinBartlett2:=getProc(hh,'nspwWinBartlett2');
  nspvWinBartlett2:=getProc(hh,'nspvWinBartlett2');
  nspsWinHann:=getProc(hh,'nspsWinHann');
  nspcWinHann:=getProc(hh,'nspcWinHann');
  nspdWinHann:=getProc(hh,'nspdWinHann');
  nspzWinHann:=getProc(hh,'nspzWinHann');
  nspwWinHann:=getProc(hh,'nspwWinHann');
  nspvWinHann:=getProc(hh,'nspvWinHann');
  nspsWinHann2:=getProc(hh,'nspsWinHann2');
  nspcWinHann2:=getProc(hh,'nspcWinHann2');
  nspdWinHann2:=getProc(hh,'nspdWinHann2');
  nspzWinHann2:=getProc(hh,'nspzWinHann2');
  nspwWinHann2:=getProc(hh,'nspwWinHann2');
  nspvWinHann2:=getProc(hh,'nspvWinHann2');
  nspsWinHamming:=getProc(hh,'nspsWinHamming');
  nspcWinHamming:=getProc(hh,'nspcWinHamming');
  nspdWinHamming:=getProc(hh,'nspdWinHamming');
  nspzWinHamming:=getProc(hh,'nspzWinHamming');
  nspwWinHamming:=getProc(hh,'nspwWinHamming');
  nspvWinHamming:=getProc(hh,'nspvWinHamming');
  nspsWinHamming2:=getProc(hh,'nspsWinHamming2');
  nspcWinHamming2:=getProc(hh,'nspcWinHamming2');
  nspdWinHamming2:=getProc(hh,'nspdWinHamming2');
  nspzWinHamming2:=getProc(hh,'nspzWinHamming2');
  nspwWinHamming2:=getProc(hh,'nspwWinHamming2');
  nspvWinHamming2:=getProc(hh,'nspvWinHamming2');
  nspsWinBlackman:=getProc(hh,'nspsWinBlackman');
  nspcWinBlackman:=getProc(hh,'nspcWinBlackman');
  nspdWinBlackman:=getProc(hh,'nspdWinBlackman');
  nspzWinBlackman:=getProc(hh,'nspzWinBlackman');
  nspwWinBlackman:=getProc(hh,'nspwWinBlackman');
  nspvWinBlackman:=getProc(hh,'nspvWinBlackman');
  nspsWinBlackman2:=getProc(hh,'nspsWinBlackman2');
  nspcWinBlackman2:=getProc(hh,'nspcWinBlackman2');
  nspdWinBlackman2:=getProc(hh,'nspdWinBlackman2');
  nspzWinBlackman2:=getProc(hh,'nspzWinBlackman2');
  nspwWinBlackman2:=getProc(hh,'nspwWinBlackman2');
  nspvWinBlackman2:=getProc(hh,'nspvWinBlackman2');
  nspsWinBlackmanStd:=getProc(hh,'nspsWinBlackmanStd');
  nspcWinBlackmanStd:=getProc(hh,'nspcWinBlackmanStd');
  nspdWinBlackmanStd:=getProc(hh,'nspdWinBlackmanStd');
  nspzWinBlackmanStd:=getProc(hh,'nspzWinBlackmanStd');
  nspwWinBlackmanStd:=getProc(hh,'nspwWinBlackmanStd');
  nspvWinBlackmanStd:=getProc(hh,'nspvWinBlackmanStd');
  nspsWinBlackmanStd2:=getProc(hh,'nspsWinBlackmanStd2');
  nspcWinBlackmanStd2:=getProc(hh,'nspcWinBlackmanStd2');
  nspdWinBlackmanStd2:=getProc(hh,'nspdWinBlackmanStd2');
  nspzWinBlackmanStd2:=getProc(hh,'nspzWinBlackmanStd2');
  nspwWinBlackmanStd2:=getProc(hh,'nspwWinBlackmanStd2');
  nspvWinBlackmanStd2:=getProc(hh,'nspvWinBlackmanStd2');
  nspsWinBlackmanOpt:=getProc(hh,'nspsWinBlackmanOpt');
  nspcWinBlackmanOpt:=getProc(hh,'nspcWinBlackmanOpt');
  nspdWinBlackmanOpt:=getProc(hh,'nspdWinBlackmanOpt');
  nspzWinBlackmanOpt:=getProc(hh,'nspzWinBlackmanOpt');
  nspwWinBlackmanOpt:=getProc(hh,'nspwWinBlackmanOpt');
  nspvWinBlackmanOpt:=getProc(hh,'nspvWinBlackmanOpt');
  nspsWinBlackmanOpt2:=getProc(hh,'nspsWinBlackmanOpt2');
  nspcWinBlackmanOpt2:=getProc(hh,'nspcWinBlackmanOpt2');
  nspdWinBlackmanOpt2:=getProc(hh,'nspdWinBlackmanOpt2');
  nspzWinBlackmanOpt2:=getProc(hh,'nspzWinBlackmanOpt2');
  nspwWinBlackmanOpt2:=getProc(hh,'nspwWinBlackmanOpt2');
  nspvWinBlackmanOpt2:=getProc(hh,'nspvWinBlackmanOpt2');
  nspsWinKaiser:=getProc(hh,'nspsWinKaiser');
  nspcWinKaiser:=getProc(hh,'nspcWinKaiser');
  nspdWinKaiser:=getProc(hh,'nspdWinKaiser');
  nspzWinKaiser:=getProc(hh,'nspzWinKaiser');
  nspwWinKaiser:=getProc(hh,'nspwWinKaiser');
  nspvWinKaiser:=getProc(hh,'nspvWinKaiser');
  nspsWinKaiser2:=getProc(hh,'nspsWinKaiser2');
  nspcWinKaiser2:=getProc(hh,'nspcWinKaiser2');
  nspdWinKaiser2:=getProc(hh,'nspdWinKaiser2');
  nspzWinKaiser2:=getProc(hh,'nspzWinKaiser2');
  nspwWinKaiser2:=getProc(hh,'nspwWinKaiser2');
  nspvWinKaiser2:=getProc(hh,'nspvWinKaiser2');
  nspWtFree:=getProc(hh,'nspWtFree');
  nspsWtInit:=getProc(hh,'nspsWtInit');
  nspdWtInit:=getProc(hh,'nspdWtInit');
  nspwWtInit:=getProc(hh,'nspwWtInit');
  nspsWtInitLen:=getProc(hh,'nspsWtInitLen');
  nspdWtInitLen:=getProc(hh,'nspdWtInitLen');
  nspwWtInitLen:=getProc(hh,'nspwWtInitLen');
  nspsWtInitUserFilter:=getProc(hh,'nspsWtInitUserFilter');
  nspdWtInitUserFilter:=getProc(hh,'nspdWtInitUserFilter');
  nspwWtInitUserFilter:=getProc(hh,'nspwWtInitUserFilter');
  nspsWtSetState:=getProc(hh,'nspsWtSetState');
  nspdWtSetState:=getProc(hh,'nspdWtSetState');
  nspwWtSetState:=getProc(hh,'nspwWtSetState');
  nspsWtGetState:=getProc(hh,'nspsWtGetState');
  nspdWtGetState:=getProc(hh,'nspdWtGetState');
  nspwWtGetState:=getProc(hh,'nspwWtGetState');
  nspsWtDecompose:=getProc(hh,'nspsWtDecompose');
  nspdWtDecompose:=getProc(hh,'nspdWtDecompose');
  nspwWtDecompose:=getProc(hh,'nspwWtDecompose');
  nspsWtReconstruct:=getProc(hh,'nspsWtReconstruct');
  nspdWtReconstruct:=getProc(hh,'nspdWtReconstruct');
  nspwWtReconstruct:=getProc(hh,'nspwWtReconstruct');

  {if assigned(nspSetErrMode) then nspSetErrMode(1);}

end;

procedure freeISPL;
begin
  if hh<>0 then freeLibrary(hh);
  hh:=0;
end;

end.

