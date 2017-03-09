unit MathKernel0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,math,
     util1,NcDef2,
     MKL_DFTI,
     {MKL_VSL , }
     debug0;

{  MKL 8.0

   mkl_lapack32.dll   contient les procédures Lapack 32 bits
   mkl_lapack64.dll   contient les procédures Lapack 64 bits

   mkl_def.dll        contient les procédures BLAS 32 et 64 bits
                      contient les procédures de MKL_DFTI

   Les dll semblent accepter les appels stdCall ou cdecl !

   Les dll libguide40.dll, mkl_p3.dll et mkl_p4.dll doivent être accessibles

   La convention MKL est que tous les paramètres sont transmis par référence. Ce qui donne des
   appels très lourds: il faut déclarer puis affecter puis transmettre chaque paramètre.

   Donc, on transforme les passages par références en passages par valeurs quand ils sont inutiles.
   Les routines initiales sont précédées du caractère _ .


   Transmission des paramètres. La bonne directive est "cdecl"
   En effet, nous avons essayé les autres directives. La seule autre directive
   qui semble marcher est "stdCall" mais, avec le test suivant:

         procedure test;
         var
           x1,x2:integer;
         begin
           asm
             mov x1,esp
           end;

          _dgemv(trans,m,n,alpha,a,lda,x,incx,beta,y,incy );

           asm
             mov x2,esp
           end;

           messageCentral(Istr(x1)+'   '+Istr(x2));
        end;

  on se rend compte que le contenu du registre ESP change avec une déclaration stdCall

}

{ Procédures de LaPack32 /LaPack64 }

{ ?getrf compute the LU factorization of a general matrix
  The routine forms the LU factorization of a general m by n matrix A as
   A = PLU
  where P is a permutation matrix, L is lower triangular with unit diagonal
  elements (lower trapezoidal if m > n) and U is upper triangular (upper
  trapezoidal if m < n). Usually A is square (m = n), and both L and U are
  triangular. The routine uses partial pivoting, with row interchanges.
}


{ Avec MKL 10.3 , on a construit une DLL appelée MKLdll.dll

}

var
  _sgetrf,_dgetrf,_cgetrf,_zgetrf:
    procedure(var m,n:integer;a:pointer;var lda:integer;ipiv:pointer;var info:integer);cdecl;

procedure sgetrf(m,n:integer;a:pointer;lda:integer;ipiv:pointer;var info:integer);
procedure dgetrf(m,n:integer;a:pointer;lda:integer;ipiv:pointer;var info:integer);
procedure cgetrf(m,n:integer;a:pointer;lda:integer;ipiv:pointer;var info:integer);
procedure zgetrf(m,n:integer;a:pointer;lda:integer;ipiv:pointer;var info:integer);

{**********************************************ESIN**********************************************************}
{ ?getri
Computes the inverse of an LU-factored general matrix.
}


var
  _sgetri,_dgetri,_cgetri,_zgetri:
    procedure(var n:integer;a:pointer;var lda:integer;ipiv:pointer;work:pointer;var lwork;var info:integer);cdecl;

procedure sgetri(n:integer;a:pointer;lda:integer;ipiv:pointer;work:pointer;var lwork, info:integer);
procedure dgetri(n:integer;a:pointer;lda:integer;ipiv:pointer;work:pointer;var lwork, info:integer);
procedure cgetri(n:integer;a:pointer;lda:integer;ipiv:pointer;work:pointer;var lwork, info:integer);
procedure zgetri(n:integer;a:pointer;lda:integer;ipiv:pointer;work:pointer;var lwork, info:integer);

{**********************************************/ESIN**********************************************************}

{ ?getrs solve a system of linear eq. with a LU factored square matrix, with multiple right hand sides
  This routine solves for X the following systems of linear equations:
    AX = B if trans='N',
    ATX = B if trans='T',
    AHX = B if trans='C' (for complex matrices only).
  Before calling this routine, you must call ?getrf to compute the LU factorization of A.
}
var
  _sgetrs,_dgetrs,_cgetrs,_zgetrs:
    procedure(var trans:char;var n, nrhs:integer;a:pointer;var lda:integer;ipiv:pointer;
                      b:pointer;var ldb, info:integer);cdecl;

procedure sgetrs(trans:char;n, nrhs:integer;a:pointer;lda:integer;ipiv:pointer;
                      b:pointer;ldb:integer;var info:integer);
procedure dgetrs(trans:char;n, nrhs:integer;a:pointer;lda:integer;ipiv:pointer;
                      b:pointer;ldb:integer;var info:integer);
procedure cgetrs(trans:char;n, nrhs:integer;a:pointer;lda:integer;ipiv:pointer;
                      b:pointer;ldb:integer;var info:integer);
procedure zgetrs(trans:char;n, nrhs:integer;a:pointer;lda:integer;ipiv:pointer;
                      b:pointer;ldb:integer;var info:integer);



{Use QR or LQ factorization to solve an over or under-determined system with full-rank matrix}
var
  _sgels,_dgels,_cgels,_zgels:
    procedure(var trans:char;var m,n,nrhs:integer; a:pointer;var lda:integer;b:pointer;var ldb:integer;
                   work:pointer;var lwork, info:integer);cdecl;

procedure sgels(trans:char; m,n,nrhs:integer; a:pointer; lda:integer;b:pointer; ldb:integer;
                   work:pointer;var lwork, info:integer);
procedure dgels(trans:char; m,n,nrhs:integer; a:pointer; lda:integer;b:pointer; ldb:integer;
                   work:pointer;var lwork, info:integer);
procedure cgels(trans:char; m,n,nrhs:integer; a:pointer; lda:integer;b:pointer; ldb:integer;
                   work:pointer;var lwork, info:integer);
procedure zgels(trans:char; m,n,nrhs:integer; a:pointer; lda:integer;b:pointer; ldb:integer;
                   work:pointer;var lwork, info:integer);



{compute QR factorization for general matrix}
var
  _sgeqrf,_dgeqrf,_cgeqrf,_zgeqrf:
    procedure(var m,n:integer;a:pointer;var lda:integer;tau:pointer;work:pointer;var lwork,info:integer);cdecl;

procedure sgeqrf(m,n:integer;a:pointer;lda:integer;tau:pointer;work:pointer;var lwork,info:integer);
procedure dgeqrf(m,n:integer;a:pointer;lda:integer;tau:pointer;work:pointer;var lwork,info:integer);
procedure cgeqrf(m,n:integer;a:pointer;lda:integer;tau:pointer;work:pointer;var lwork,info:integer);
procedure zgeqrf(m,n:integer;a:pointer;lda:integer;tau:pointer;work:pointer;var lwork,info:integer);

{Multiplies a real matrix by the matrix Q of the QR factorization (?geqrf) }
var
  _sormqr,_dormqr:
    procedure(var side,trans:char;var m,n,k:integer; a:pointer;var lda:integer;
              tau:pointer;
              c:pointer;var ldc:integer; work:pointer;var lwork,info:integer);cdecl;

procedure sormqr(side,trans:char; m,n,k:integer; a:pointer;lda:integer;
              tau:pointer;
              c:pointer; ldc:integer; work:pointer;var lwork,info:integer);
procedure dormqr(side,trans:char; m,n,k:integer; a:pointer;lda:integer;
              tau:pointer;
              c:pointer; ldc:integer; work:pointer;var lwork,info:integer);



{ Compute Cholesky factorization of a matrix }
var
  _spotrf,_dpotrf,_cpotrf,_zpotrf:
    procedure(var uplo:char;var n:integer; a:pointer;var  lda:integer;var info:integer );cdecl;

procedure spotrf(uplo:char; n:integer; a:pointer; lda:integer;var info:integer );
procedure dpotrf(uplo:char; n:integer; a:pointer; lda:integer;var info:integer );
procedure cpotrf(uplo:char; n:integer; a:pointer; lda:integer;var info:integer );
procedure zpotrf(uplo:char; n:integer; a:pointer; lda:integer;var info:integer );


{ Solve linear system using Cholesky factorization }
var
  _spotrs,_dpotrs,_cpotrs,_zpotrs:
    procedure (var uplo:char;var n,nrhs:integer; a:pointer;var lda:integer;
                   b:pointer;var ldb, info:integer);cdecl;

procedure spotrs(uplo:char;n,nrhs:integer; a:pointer;lda:integer;
                   b:pointer; ldb:integer;var info:integer);
procedure dpotrs(uplo:char;n,nrhs:integer; a:pointer;lda:integer;
                   b:pointer; ldb:integer;var info:integer);
procedure cpotrs(uplo:char;n,nrhs:integer; a:pointer;lda:integer;
                   b:pointer; ldb:integer;var info:integer);
procedure zpotrs(uplo:char;n,nrhs:integer; a:pointer;lda:integer;
                   b:pointer; ldb:integer;var info:integer);


{ ?gebrd Reduces a general matrix to bidiagonal form. }
var
  _sgebrd ,  _dgebrd,  _cgebrd, _zgebrd :
    procedure( var m, n:integer; a:pointer;var lda:integer;
               d, e, tauq, taup, work:pointer;var lwork,info:integer );cdecl;

procedure sgebrd(m,n:integer; a:pointer;lda:integer;
                 d,e,tauq,taup,work:pointer;lwork:integer;var info:integer );
procedure dgebrd(m,n:integer; a:pointer;lda:integer;
                 d,e,tauq,taup,work:pointer;lwork:integer;var info:integer );
procedure cgebrd(m,n:integer; a:pointer;lda:integer;
                 d,e,tauq,taup,work:pointer;lwork:integer;var info:integer );
procedure zgebrd(m,n:integer; a:pointer;lda:integer;
                 d,e,tauq,taup,work:pointer;lwork:integer;var info:integer );


{ ?orgbr Generates the real orthogonal matrix Q or PT determined by ?gebrd. }
var
  _sorgbr, _dorgbr: procedure(var vect:char;var m,n,k:integer;
                              a:pointer;var lda:integer; tau,work:pointer;var lwork, info:integer );cdecl;

procedure sorgbr(vect:char;m,n,k:integer;
                 a:pointer;lda:integer; tau,work:pointer; lwork:integer;var info:integer );
procedure dorgbr(vect:char;m,n,k:integer;
                 a:pointer;lda:integer; tau,work:pointer; lwork:integer;var info:integer );

{ ?bdsqr Computes the singular value decomposition of a general matrix that has been reduced to bidiagonal form. }
var
  _sbdsqr,_dbdsqr,_cbdsqr,_zbdsqr:
    procedure(var uplo:char; var n, ncvt, nru, ncc:integer;
              d, e, vt:pointer;var ldvt:integer; u:pointer; var ldu:integer;
              c:pointer;var ldc:integer; work:pointer;var info:integer);cdecl;

procedure sbdsqr(uplo:char; n, ncvt, nru, ncc:integer;
              d, e, vt:pointer;ldvt:integer; u:pointer; ldu:integer;
              c:pointer;ldc:integer;work:pointer;var info:integer);
procedure dbdsqr(uplo:char; n, ncvt, nru, ncc:integer;
              d, e, vt:pointer;ldvt:integer; u:pointer; ldu:integer;
              c:pointer;ldc:integer;work:pointer;var info:integer);
procedure cbdsqr(uplo:char; n, ncvt, nru, ncc:integer;
              d, e, vt:pointer;ldvt:integer; u:pointer; ldu:integer;
              c:pointer;ldc:integer;work:pointer;var info:integer);
procedure zbdsqr(uplo:char; n, ncvt, nru, ncc:integer;
              d, e, vt:pointer;ldvt:integer; u:pointer; ldu:integer;
              c:pointer;ldc:integer;work:pointer;var info:integer);




{Procédures de BLAS }
  {
  The ?gemm routines perform a matrix-matrix operation with general matrices.
  The operation is defined as
      c := alpha*op(a)*op(b) + beta*c
  where:
      op(x) is one of op(x) = x or op(x) = x' or op(x) = conjg(x'),
      alpha and beta are scalars
      a, b and c are matrices:
      op(a) is an m by k matrix
      op(b) is a k by n matrix
      c is an m by n matrix.
  }
var
  _sgeMM:
    procedure(var transa,transb:char;var m,n,k:integer;var alpha:single;
                   a:pointer;var lda:integer;
                   b:pointer;var ldb:integer;
                   var beta:single;c:pointer;var ldc:integer);cdecl;
  _dgeMM:
    procedure(var transa,transb:char;var m,n,k:integer;var alpha:double;
                   a:pointer;var lda:integer;
                   b:pointer;var ldb:integer;
                   var beta:double;c:pointer;var ldc:integer);cdecl;
  _cgeMM:
    procedure(var transa,transb:char;var m,n,k:integer;var alpha:TsingleComp;
                   a:pointer;var lda:integer;
                   b:pointer;var ldb:integer;
                   var beta:TsingleComp;c:pointer;var ldc:integer);cdecl;
  _zgeMM:
    procedure(var transa,transb:char;var m,n,k:integer;var alpha:TdoubleComp;
                   a:pointer;var lda:integer;
                   b:pointer;var ldb:integer;
                   var beta:TdoubleComp;c:pointer;var ldc:integer);cdecl;


procedure sgeMM(transa,transb:char; m,n,k:integer; alpha:single;
                   a:pointer; lda:integer;
                   b:pointer; ldb:integer;
                   beta:single;c:pointer; ldc:integer);
procedure dgeMM(transa,transb:char;m,n,k:integer;alpha:double;
                   a:pointer; lda:integer;
                   b:pointer; ldb:integer;
                   beta:double;c:pointer; ldc:integer);
procedure cgeMM(transa,transb:char; m,n,k:integer; alpha:TsingleComp;
                   a:pointer; lda:integer;
                   b:pointer; ldb:integer;
                   beta:TsingleComp;c:pointer; ldc:integer);
procedure zgeMM(transa,transb:char; m,n,k:integer; alpha:TdoubleComp;
                   a:pointer; lda:integer;
                   b:pointer; ldb:integer;
                   beta:TdoubleComp;c:pointer; ldc:integer);


{ ?SCAL = Multiply a vector by a number}
var
  _sSCAL,_cSCAL: procedure (var n:integer;var a:single;x:pointer;var incx:integer);cdecl;
  _dSCAL,_zSCAL: procedure (var n:integer;var a:double;x:pointer;var incx:integer);cdecl;
  _csSCAL: procedure (var n:integer;var a:TsingleComp;x:pointer;var incx:integer);cdecl;
  _zdSCAL: procedure (var n:integer;var a:TdoubleComp;x:pointer;var incx:integer);cdecl;

procedure sSCAL(n:integer; a:single;x:pointer; incx:integer);
procedure cSCAL(n:integer; a:single;x:pointer; incx:integer);
procedure dSCAL(n:integer; a:double;x:pointer; incx:integer);
procedure zSCAL(n:integer; a:double;x:pointer; incx:integer);

procedure csSCAL(n:integer; a:TsingleComp;x:pointer; incx:integer);
procedure zdSCAL(n:integer; a:TdoubleComp;x:pointer; incx:integer);



{ ?trSM = Solve a matrix equation: one matrix operand is triangular}
var
  _strSM: procedure(var side,uplo,transa,diag:char;
                   var m,n:integer;
                   var alpha:single;a:pointer;var lda:integer; b:pointer;var ldb:integer);cdecl;
  _dtrSM: procedure(var side,uplo,transa,diag:char;
                   var m,n:integer;
                   var alpha:double;a:pointer;var lda:integer; b:pointer;var ldb:integer);cdecl;
  _ctrSM: procedure(var side,uplo,transa,diag:char;
                   var m,n:integer;
                   var alpha:TsingleComp;a:pointer;var lda:integer; b:pointer;var ldb:integer);cdecl;
  _ztrSM: procedure(var side,uplo,transa,diag:char;
                   var m,n:integer;
                   var alpha:TdoubleComp;a:pointer;var lda:integer; b:pointer;var ldb:integer);cdecl;

  procedure strSM(side,uplo,transa,diag:char;
                  m,n:integer;
                  alpha:single;a:pointer; lda:integer; b:pointer; ldb:integer);
  procedure dtrSM(side,uplo,transa,diag:char;
                  m,n:integer;
                  alpha:double;a:pointer; lda:integer; b:pointer; ldb:integer);
  procedure ctrSM(side,uplo,transa,diag:char;
                  m,n:integer;
                  alpha:TsingleComp;a:pointer; lda:integer; b:pointer; ldb:integer);
  procedure ztrSM(side,uplo,transa,diag:char;
                  m,n:integer;
                  alpha:TdoubleComp;a:pointer; lda:integer; b:pointer; ldb:integer);


{  ?ger  performs a rank-1 update of a general matrix.

  The ?ger routines perform a matrix-vector operation defined as
    a := alpha*x*y' + a,
  where:
    alpha is a scalar
    x is an m-element vector
    y is an n-element vector
    a is an m by n matrix.
}
var
  _sger: procedure(var m, n:integer; var alpha:single;
                   x:pointer;var incx:integer; y:pointer;var incy:integer;
                   a:pointer;var lda:integer);cdecl;
  _dger: procedure(var m, n:integer; var alpha:double;
                   x:pointer;var incx:integer; y:pointer;var incy:integer;
                   a:pointer;var lda:integer);cdecl;

  procedure sger(m, n:integer; alpha:single;
                 x:pointer; incx:integer; y:pointer; incy:integer;
                 a:pointer; lda:integer);
  procedure dger(m, n:integer; alpha:double;
                 x:pointer; incx:integer; y:pointer; incy:integer;
                 a:pointer; lda:integer);


{ ?syr performs a rank-1 update of a symmetric matrix.

  The ?syr routines perform a matrix-vector operation defined as
    a := alpha*x*x' + a,
  where:
    alpha is a real scalar
    x is an n-element vector
    a is an n by n symmetric matrix.
}
var
  _ssyr: procedure( var uplo:char;var n:integer;var alpha:single;
                   x:pointer;var incx:integer;
                   a:pointer;var lda:integer);cdecl;
  _dsyr: procedure( var uplo:char;var n:integer;var alpha:double;
                   x:pointer;var incx:integer;
                   a:pointer;var lda:integer);cdecl;

  procedure ssyr( uplo:char; n:integer; alpha:single;
                  x:pointer; incx:integer;
                  a:pointer; lda:integer);
  procedure dsyr( uplo:char; n:integer; alpha:double;
                  x:pointer; incx:integer;
                  a:pointer; lda:integer);

{ ?syrk  Performs a rank-n update of a symmetric matrix.

The ?syrk routines perform a matrix-matrix operation using symmetric matrices. The operation is
defined as
c := alpha*a*a' + beta*c,
or
c := alpha*a'*a + beta*c,
where:
alpha and beta are scalars
c is an n by n symmetric matrix
a is an n by k matrix in the first case and a k by n matrix in the second case.
}
var
  _ssyrk: procedure(var uplo,trans:char;var n, k:integer;var alpha:single;
          a:pointer;var lda:integer;
          var beta:single;
          c: pointer;var ldc: integer);cdecl;
  _dsyrk: procedure(var uplo,trans:char;var n, k:integer;var alpha:double;
          a:pointer;var lda:integer;
          var beta:double;
          c: pointer;var ldc: integer);cdecl;
  _csyrk: procedure(var uplo,trans:char;var n, k:integer;var alpha:TsingleComp;
          a:pointer;var lda:integer;
          var beta:TsingleComp;
          c: pointer;var ldc: integer);cdecl;
  _zsyrk: procedure(var uplo,trans:char;var n, k:integer;var alpha:TdoubleComp;
          a:pointer;var lda:integer;
          var beta:TdoubleComp;
          c: pointer;var ldc: integer);cdecl;

procedure ssyrk (uplo,trans:char;n, k:integer;alpha:single;
          a:pointer;lda:integer;
          beta:single;
          c: pointer; ldc: integer);
procedure dsyrk (uplo,trans:char;n, k:integer;alpha:double;
          a:pointer;lda:integer;
          beta:double;
          c: pointer; ldc: integer);
procedure csyrk (uplo,trans:char;n, k:integer;alpha:TsingleComp;
          a:pointer;lda:integer;
          beta:TsingleComp;
          c: pointer; ldc: integer);
procedure zsyrk (uplo,trans:char;n, k:integer;alpha:TdoubleComp;
          a:pointer;lda:integer;
          beta:TdoubleComp;
          c: pointer; ldc: integer);



{ ?gemv computes a matrix-vector product using a general matrix
  The ?gemv routines perform a matrix-vector operation defined as
    y := alpha*a*x + beta*y,
}
var
  _sgemv: procedure(var trans: char;var m, n:integer; var alpha:single;
                    a:pointer;var lda:integer; x:pointer;var incx:integer;
                    var beta:single;y:pointer; var incy:integer );cdecl;
  _dgemv: procedure(var trans: char;var m, n:integer; var alpha:double;
                    a:pointer;var lda:integer; x:pointer;var incx:integer;
                    var beta:double;y:pointer; var incy:integer );stdCall;
  _cgemv: procedure(var trans: char;var m, n:integer; var alpha:TsingleComp;
                    a:pointer;var lda:integer; x:pointer;var incx:integer;
                    var beta:TsingleComp;y:pointer; var incy:integer );cdecl;
  _zgemv: procedure(var trans: char;var m, n:integer; var alpha:TdoubleComp;
                    a:pointer;var lda:integer; x:pointer;var incx:integer;
                    var beta:TdoubleComp;y:pointer; var incy:integer );cdecl;


procedure sgemv(trans: char; m, n:integer;alpha:single;
                    a:pointer;lda:integer; x:pointer;incx:integer;
                    beta:single;y:pointer; incy:integer );
procedure dgemv(trans: char; m, n:integer;alpha:double;
                    a:pointer;lda:integer; x:pointer;incx:integer;
                    beta:double;y:pointer; incy:integer );
procedure cgemv(trans: char; m, n:integer;alpha:TsingleComp;
                    a:pointer;lda:integer; x:pointer;incx:integer;
                    beta:TsingleComp;y:pointer; incy:integer );
procedure zgemv(trans: char; m, n:integer;alpha:TdoubleComp;
                    a:pointer;lda:integer; x:pointer;incx:integer;
                    beta:TdoubleComp;y:pointer; incy:integer );


{
 ?syev
 Computes all eigenvalues and, optionally, eigenvectors of a real symmetric matrix.
}
var
  _ssyev,_dsyev: procedure(var job,uplo:char;var n:integer;a:pointer;var lda:integer;w:pointer;
                             work:pointer;var lwork:integer;var info:integer);cdecl;


procedure ssyev(job,uplo:char;n:integer;a:pointer;lda:integer;w:pointer;
                 work:pointer;lwork:integer;info:integer);
procedure dsyev(job,uplo:char;n:integer;a:pointer;lda:integer;w:pointer;
                 work:pointer;lwork:integer;info:integer);

{ ?syevd
  Computes all eigenvalues and (optionally) all eigenvectors of a real
  symmetric matrix using divide and conquer algorithm.
}
var
  _ssyevd,_dsyevd: procedure(var job,uplo:char;var n:integer;a:pointer;var lda:integer;w:pointer;
                             work:pointer;var lwork:integer;
                             iwork:pointer;var liwork:integer;var info:integer);cdecl;
{
type
  TMKLVersion= record
                  MajorVersion : integer;
                  MinorVersion : integer;
                  UpdateVersion : integer;
                  stProductStatus: Pansichar;
                  stBuild: Pansichar;
                  stProcessor: Pansichar;
                  stPlatform: Pansichar;
               end;

var
  mkl_get_version: procedure( var Version:TMKLVersion );cdecl;
}
procedure ssyevd(job,uplo:char;n:integer;a:pointer;lda:integer;w:pointer;
                 work:pointer;lwork:integer;
                 iwork:pointer;liwork:integer;info:integer);
procedure dsyevd(job,uplo:char;n:integer;a:pointer;lda:integer;w:pointer;
                 work:pointer;lwork:integer;
                 iwork:pointer;liwork:integer;info:integer);



var
  _vsAdd: procedure(  N:integer; pA, pB, pY: Psingle);cdecl;
  _vdAdd: procedure(  N:integer; pA, pB, pY: Pdouble);cdecl;


procedure vsAdd( N:integer; pA, pB, pY: Psingle);
procedure vdAdd( N:integer; pA, pB, pY: Pdouble);



function InitMKLib:boolean;
Procedure FreeMKL;

procedure MKLtest;
procedure MKLend;

implementation


procedure MKLtest;
begin
  if not initMKlib
    then sortieErreur('Math Kernel Library not initialized' );

{$IFNDEF WIN64}
 asm      {Réinitialise le FPU: met tous les registres à zéro ! }
   Finit
 end;

{$ELSE}
  ClearExceptions;
  Reset8087CW;
{$ENDIF}

end;

procedure MKLend;
begin
  setPrecisionMode(pmExtended);
end;



function getProc(hh:Thandle;st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));
  if result=nil then messageCentral(st+'=nil');
               {else messageCentral(st+' OK'); }
end;


var
  Ftried, FOK:boolean;
  hLapack32, hLapack64:intG;
  hBlas:intG;

function InitMKLib:boolean;
begin
  if Ftried then
  begin
    result:=FOK;
    exit;
  end;

  Ftried:=true;
  FOK:=false;
  result:=FOK;

  hLapack32:=GloadLibrary(AppDir+'MKL\'+'mkldll.dll');
  // hLapack32:=GloadLibrary('D:\VSprojects\mkldll\debug\mkldll.dll');

  hLapack64:=hLapack32;
  hBlas:=hLapack32;

  {$IFNDEF WIN64}
  if hLapack32=0 then
  begin

    hLapack32:=GloadLibrary('mkl_lapack32.dll');
    if hLapack32=0 then exit;

    hLapack64:=GloadLibrary('mkl_lapack64.dll');
    if hLapack64=0 then
    begin
      freeLibrary(hLapack32);
      hLapack32:=0;
      exit;
    end;

    hBlas:=GloadLibrary('mkl_def.dll');
    if hBlas=0 then
    begin
      freeLibrary(hLapack32);
      hLapack32:=0;
      freeLibrary(hLapack64);
      hLapack64:=0;
      exit;
    end;
  end;
  {$ENDIF}
  if hLapack32=0 then exit;

  FOK:=true;
  result:=FOK;

  {Lapack32}

  _sgetrf:=getProc(hLapack32,'sgetrf');
  _cgetrf:=getProc(hLapack32,'cgetrf');

  _sgetrs:=getProc(hLapack32,'sgetrs');
  _cgetrs:=getProc(hLapack32,'cgetrs');

  _sgels:=getProc(hLapack32,'sgels');
  _cgels:=getProc(hLapack32,'cgels');

  _sgeqrf:=getProc(hLapack32,'sgeqrf');
  _cgeqrf:=getProc(hLapack32,'cgeqrf');

  _sormqr:=getProc(hLapack32,'sormqr');

  _spotrf:=getProc(hLapack32,'spotrf');
  _cpotrf:=getProc(hLapack32,'cpotrf');
  _spotrs:=getProc(hLapack32,'spotrs');
  _cpotrs:=getProc(hLapack32,'cpotrs');

  _ssyev:=getProc(hLapack32,'ssyev');
  _ssyevd:=getProc(hLapack32,'ssyevd');

   {**********************************ESIN****************************************}
  _sgetri:=getProc(hLapack32,'sgetri');
  _cgetri:=getProc(hLapack32,'cgetri');

   {**********************************/ESIN***************************************}


  {Lapack64}
  _dgetrf:=getProc(hLapack64,'dgetrf');
  _zgetrf:=getProc(hLapack64,'zgetrf');

  _dgetrs:=getProc(hLapack64,'dgetrs');
  _zgetrs:=getProc(hLapack64,'zgetrs');

  _dgels:=getProc(hLapack64,'dgels');
  _zgels:=getProc(hLapack64,'zgels');

  _dgeqrf:=getProc(hLapack64,'dgeqrf');
  _zgeqrf:=getProc(hLapack64,'zgeqrf');

  _dormqr:=getProc(hLapack64,'dormqr');

  _dpotrf:=getProc(hLapack64,'dpotrf');
  _zpotrf:=getProc(hLapack64,'zpotrf');
  _dpotrs:=getProc(hLapack64,'dpotrs');
  _zpotrs:=getProc(hLapack64,'zpotrs');

  _dsyev:=getProc(hLapack64,'dsyev');
  _dsyevd:=getProc(hLapack64,'dsyevd');

  _sgebrd:=getProc(hLapack32,'sgebrd');
  _dgebrd:=getProc(hLapack64,'dgebrd');
  _cgebrd:=getProc(hLapack32,'cgebrd');
  _zgebrd:=getProc(hLapack64,'zgebrd');

  _sorgbr:=getProc(hLapack32,'sorgbr');
  _dorgbr:=getProc(hLapack64,'dorgbr');

  _sbdsqr:=getProc(hLapack32,'sbdsqr');
  _dbdsqr:=getProc(hLapack64,'dbdsqr');

  {**********************************ESIN****************************************}
  _dgetri:=getProc(hLapack64,'dgetri');
  _zgetri:=getProc(hLapack64,'zgetri');

  {**********************************/ESIN***************************************}


  {BLAS}
  _sgemm:=getProc(hBlas,'sgemm');

  _dgemm:=getProc(hBlas,'dgemm');

  _cgemm:=getProc(hBlas,'cgemm');
  _zgemm:=getProc(hBlas,'zgemm');

  _sscal:=getProc(hBlas,'sscal');
  _dscal:=getProc(hBlas,'dscal');
  _cscal:=getProc(hBlas,'cscal');
  _zscal:=getProc(hBlas,'zscal');
  _csscal:=getProc(hBlas,'csscal');
  _zdscal:=getProc(hBlas,'zdscal');

  _strsm:=getProc(hBlas,'strsm');
  _dtrsm:=getProc(hBlas,'dtrsm');
  _ctrsm:=getProc(hBlas,'ctrsm');
  _ztrsm:=getProc(hBlas,'ztrsm');

  _sger:=getProc(hBlas,'sger');
  _dger:=getProc(hBlas,'dger');
  _ssyr:=getProc(hBlas,'ssyr');
  _dsyr:=getProc(hBlas,'dsyr');

  _ssyrk:=getProc(hBlas,'ssyrk');
  _dsyrk:=getProc(hBlas,'dsyrk');
  _csyrk:=getProc(hBlas,'csyrk');
  _zsyrk:=getProc(hBlas,'zsyrk');

  _sgemv:=getProc(hBlas,'sgemv');
  _dgemv:=getProc(hBlas,'dgemv');
  _cgemv:=getProc(hBlas,'cgemv');
  _zgemv:=getProc(hBlas,'zgemv');

  initDFTI(hBlas);
  {initVSL; }

  _vsAdd:=getProc(hBlas,'vsAdd');
  _vdAdd:=getProc(hBlas,'vdAdd');


end;

Procedure FreeMKL;
begin
  if hLapack32<>0 then freeLibrary(hLapack32);
  {$IFNDEF WIN64}
  if hLapack64<>0 then freeLibrary(hLapack64);
  if hBlas<>0 then freeLibrary(hBlas);
  {$ENDIF}

  hLapack32:=0;
  hLapack64:=0;
  hBlas:=0;
  Ftried:=false;
  FOK:=false;
end;


procedure sgetrf(m,n:integer;a:pointer;lda:integer;ipiv:pointer;var info:integer);
begin
  MKLtest;
  _sgetrf(m,n,a,lda,ipiv,info);
  MKLend;
end;

procedure dgetrf(m,n:integer;a:pointer;lda:integer;ipiv:pointer;var info:integer);
begin
  MKLtest;
  _dgetrf(m,n,a,lda,ipiv,info);
  MKLend;
end;

procedure cgetrf(m,n:integer;a:pointer;lda:integer;ipiv:pointer;var info:integer);
begin
  MKLtest;
  _cgetrf(m,n,a,lda,ipiv,info);
  MKLend;
end;

procedure zgetrf(m,n:integer;a:pointer;lda:integer;ipiv:pointer;var info:integer);
begin
  MKLtest;
  _zgetrf(m,n,a,lda,ipiv,info);
  MKLend;
end;

{*******************************ESIN*******************************}
procedure sgetri(n:integer;a:pointer;lda:integer;ipiv:pointer;work:pointer;var lwork, info:integer);

begin
  MKLtest;
  _sgetri(n,a,lda,ipiv,work,lwork,info);
  MKLend;
end;

procedure dgetri(n:integer;a:pointer;lda:integer;ipiv:pointer;work:pointer;var lwork, info:integer);
begin
  MKLtest;
  _dgetri(n,a,lda,ipiv,work,lwork,info);
  MKLend;
end;

procedure cgetri(n:integer;a:pointer;lda:integer;ipiv:pointer;work:pointer;var lwork, info:integer);
begin
  MKLtest;
  _cgetri(n,a,lda,ipiv,work,lwork,info);
  MKLend;
end;

procedure zgetri(n:integer;a:pointer;lda:integer;ipiv:pointer;work:pointer;var lwork, info:integer);
begin
  MKLtest;
  _zgetri(n,a,lda,ipiv,work,lwork,info);
  MKLend;
end;
{*******************************/ESIN*******************************}



procedure sgetrs(trans:char;n, nrhs:integer;a:pointer;lda:integer;ipiv:pointer;
                      b:pointer;ldb:integer;var info:integer);
begin
  MKLtest;
  _sgetrs(trans,n, nrhs,a,lda,ipiv,b,ldb,info);
  MKLend;
end;

procedure dgetrs(trans:char;n, nrhs:integer;a:pointer;lda:integer;ipiv:pointer;
                      b:pointer;ldb:integer;var info:integer);
begin
  MKLtest;
  _dgetrs(trans,n, nrhs,a,lda,ipiv,b,ldb,info);
  MKLend;
end;

procedure cgetrs(trans:char;n, nrhs:integer;a:pointer;lda:integer;ipiv:pointer;
                      b:pointer;ldb:integer;var info:integer);
begin
  MKLtest;
  _cgetrs(trans,n, nrhs,a,lda,ipiv,b,ldb,info);
  MKLend;
end;

procedure zgetrs(trans:char;n, nrhs:integer;a:pointer;lda:integer;ipiv:pointer;
                      b:pointer;ldb:integer;var info:integer);
begin
  MKLtest;
  _zgetrs(trans,n, nrhs,a,lda,ipiv,b,ldb,info);
  MKLend;
end;

procedure sgels(trans:char; m,n,nrhs:integer; a:pointer; lda:integer;b:pointer; ldb:integer;
                   work:pointer;var lwork, info:integer);
begin
  MKLtest;
  _sgels(trans,m,n,nrhs, a, lda,b,ldb,work,lwork, info);
  MKLend;
end;

procedure dgels(trans:char; m,n,nrhs:integer; a:pointer; lda:integer;b:pointer; ldb:integer;
                   work:pointer;var lwork, info:integer);
begin
  MKLtest;
  _dgels(trans,m,n,nrhs, a, lda,b,ldb,work,lwork, info);
  MKLend;
end;

procedure cgels(trans:char; m,n,nrhs:integer; a:pointer; lda:integer;b:pointer; ldb:integer;
                   work:pointer;var lwork, info:integer);
begin
  MKLtest;
  _cgels(trans,m,n,nrhs, a, lda,b,ldb,work,lwork, info);
  MKLend;
end;

procedure zgels(trans:char; m,n,nrhs:integer; a:pointer; lda:integer;b:pointer; ldb:integer;
                   work:pointer;var lwork, info:integer);
begin
  MKLtest;
  _zgels(trans,m,n,nrhs, a, lda,b,ldb,work,lwork, info);
  MKLend;
end;

procedure sgeqrf(m,n:integer;a:pointer;lda:integer;tau:pointer;work:pointer;var lwork,info:integer);
begin
  MKLtest;
  _sgeqrf(m,n,a,lda,tau,work,lwork,info);
  MKLend;
end;

procedure dgeqrf(m,n:integer;a:pointer;lda:integer;tau:pointer;work:pointer;var lwork,info:integer);
begin
  MKLtest;
  _dgeqrf(m,n,a,lda,tau,work,lwork,info);
  MKLend;
end;

procedure cgeqrf(m,n:integer;a:pointer;lda:integer;tau:pointer;work:pointer;var lwork,info:integer);
begin
  MKLtest;
  _cgeqrf(m,n,a,lda,tau,work,lwork,info);
  MKLend;
end;

procedure zgeqrf(m,n:integer;a:pointer;lda:integer;tau:pointer;work:pointer;var lwork,info:integer);
begin
  MKLtest;
  _zgeqrf(m,n,a,lda,tau,work,lwork,info);
  MKLend;
end;

procedure sormqr(side,trans:char; m,n,k:integer; a:pointer;lda:integer;
              tau:pointer;
              c:pointer; ldc:integer; work:pointer;var lwork,info:integer);
begin
  MKLtest;
  _sormqr(side,trans, m,n,k, a,lda,tau,c, ldc, work,lwork,info);
  MKLend;
end;

procedure dormqr(side,trans:char; m,n,k:integer; a:pointer;lda:integer;
              tau:pointer;
              c:pointer; ldc:integer; work:pointer;var lwork,info:integer);
begin
  MKLtest;
  _dormqr(side,trans,m,n,k,a,lda,tau,c,ldc,work,lwork,info);
  MKLend;
end;


procedure spotrf(uplo:char; n:integer; a:pointer; lda:integer;var info:integer );
begin
  MKLtest;
  _spotrf(uplo,n,a,lda,info);
  MKLend;
end;

procedure dpotrf(uplo:char; n:integer; a:pointer; lda:integer;var info:integer );
begin
  MKLtest;
  _dpotrf(uplo,n,a,lda,info);
  MKLend;
end;

procedure cpotrf(uplo:char; n:integer; a:pointer; lda:integer;var info:integer );
begin
  MKLtest;
  _cpotrf(uplo,n,a,lda,info);
  MKLend;
end;

procedure zpotrf(uplo:char; n:integer; a:pointer; lda:integer;var info:integer );
begin
  MKLtest;
  _zpotrf(uplo,n,a,lda,info);
  MKLend;
end;


procedure spotrs(uplo:char;n,nrhs:integer; a:pointer;lda:integer;
                   b:pointer; ldb:integer;var info:integer);
begin
  MKLtest;
  _spotrs(uplo,n,nrhs,a,lda,b,ldb,info);
  MKLend;
end;

procedure dpotrs(uplo:char;n,nrhs:integer; a:pointer;lda:integer;
                   b:pointer; ldb:integer;var info:integer);
begin
  MKLtest;
  _dpotrs(uplo,n,nrhs,a,lda,b,ldb,info);
  MKLend;
end;

procedure cpotrs(uplo:char;n,nrhs:integer; a:pointer;lda:integer;
                   b:pointer; ldb:integer;var info:integer);
begin
  MKLtest;
  _cpotrs(uplo,n,nrhs,a,lda,b,ldb,info);
  MKLend;
end;

procedure zpotrs(uplo:char;n,nrhs:integer; a:pointer;lda:integer;
                   b:pointer; ldb:integer;var info:integer);
begin
  MKLtest;
  _zpotrs(uplo,n,nrhs,a,lda,b,ldb,info);
  MKLend;
end;


                { ?gebrd   }
procedure sgebrd(m,n:integer; a:pointer;lda:integer;
                 d,e,tauq,taup,work:pointer;lwork:integer;var info:integer );
begin
  MKLtest;

  MKLend;
  _sgebrd(m,n,a,lda,d,e,tauq,taup,work,lwork,info );
end;

procedure dgebrd(m,n:integer; a:pointer;lda:integer;
                 d,e,tauq,taup,work:pointer;lwork:integer;var info:integer );
begin
  MKLtest;

  MKLend;
  _dgebrd(m,n,a,lda,d,e,tauq,taup,work,lwork,info );
end;


procedure cgebrd(m,n:integer; a:pointer;lda:integer;
                 d,e,tauq,taup,work:pointer;lwork:integer;var info:integer );
begin
  MKLtest;

  MKLend;
  _cgebrd(m,n,a,lda,d,e,tauq,taup,work,lwork,info );
end;


procedure zgebrd(m,n:integer; a:pointer;lda:integer;
                 d,e,tauq,taup,work:pointer;lwork:integer;var info:integer );
begin
  MKLtest;
  _zgebrd(m,n,a,lda,d,e,tauq,taup,work,lwork,info );
  MKLend;
end;

                { ?orgbr   }
procedure sorgbr(vect:char;m,n,k:integer;
                 a:pointer;lda:integer; tau,work:pointer; lwork:integer;var info:integer );
begin
  MKLtest;
  _sorgbr(vect,m,n,k, a,lda,tau,work,lwork,info);
  MKLend;
end;

procedure dorgbr(vect:char;m,n,k:integer;
                 a:pointer;lda:integer; tau,work:pointer; lwork:integer;var info:integer );
begin
  MKLtest;
  _dorgbr(vect,m,n,k, a,lda,tau,work,lwork,info);
  MKLend;
end;


                { ?bdsqr }
procedure sbdsqr(uplo:char; n, ncvt, nru, ncc:integer;
              d, e, vt:pointer;ldvt:integer; u:pointer; ldu:integer;
              c:pointer;ldc:integer;work:pointer;var info:integer);
begin
  MKLtest;
  _sbdsqr(uplo,n,ncvt,nru,ncc,d,e,vt,ldvt,u,ldu,c,ldc,work,info);
  MKLend;
end;

procedure dbdsqr(uplo:char; n, ncvt, nru, ncc:integer;
              d, e, vt:pointer;ldvt:integer; u:pointer; ldu:integer;
              c:pointer;ldc:integer;work:pointer;var info:integer);
begin
  MKLtest;
  _dbdsqr(uplo,n,ncvt,nru,ncc,d,e,vt,ldvt,u,ldu,c,ldc,work,info);
  MKLend;
end;


procedure cbdsqr(uplo:char; n, ncvt, nru, ncc:integer;
              d, e, vt:pointer;ldvt:integer; u:pointer; ldu:integer;
              c:pointer;ldc:integer;work:pointer;var info:integer);
begin
  MKLtest;
  _cbdsqr(uplo,n,ncvt,nru,ncc,d,e,vt,ldvt,u,ldu,c,ldc,work,info);
  MKLend;
end;


procedure zbdsqr(uplo:char; n, ncvt, nru, ncc:integer;
              d, e, vt:pointer;ldvt:integer; u:pointer; ldu:integer;
              c:pointer;ldc:integer;work:pointer;var info:integer);
begin
  MKLtest;
  _zbdsqr(uplo,n,ncvt,nru,ncc,d,e,vt,ldvt,u,ldu,c,ldc,work,info);
  MKLend;
end;











{***********************************  BLAS routines ******************************** }

procedure sgeMM(transa,transb:char; m,n,k:integer; alpha:single;
                   a:pointer; lda:integer;
                   b:pointer; ldb:integer;
                   beta:single;c:pointer; ldc:integer);
begin
  MKLtest;
  _sgeMM(transa,transb,m,n,k,alpha,a,lda,b,ldb,beta,c,ldc);
  MKLend;
end;

procedure dgeMM(transa,transb:char;m,n,k:integer;alpha:double;
                   a:pointer; lda:integer;
                   b:pointer; ldb:integer;
                   beta:double;c:pointer; ldc:integer);
begin
  MKLtest;
  _dgeMM(transa,transb,m,n,k,alpha,a,lda,b,ldb,beta,c,ldc);
  MKLend;
end;

procedure cgeMM(transa,transb:char; m,n,k:integer; alpha:TsingleComp;
                   a:pointer; lda:integer;
                   b:pointer; ldb:integer;
                   beta:TsingleComp;c:pointer; ldc:integer);
begin
  MKLtest;
  _cgeMM(transa,transb,m,n,k,alpha,a,lda,b,ldb,beta,c,ldc);
  MKLend;
end;

procedure zgeMM(transa,transb:char; m,n,k:integer; alpha:TdoubleComp;
                   a:pointer; lda:integer;
                   b:pointer; ldb:integer;
                   beta:TdoubleComp;c:pointer; ldc:integer);
begin
  MKLtest;
  _zgeMM(transa,transb,m,n,k,alpha,a,lda,b,ldb,beta,c,ldc);
  MKLend;
end;

procedure sSCAL(n:integer; a:single;x:pointer; incx:integer);
begin
  MKLtest;
  _sSCAL(n,a,x,incx);
  MKLend;
end;

procedure cSCAL(n:integer; a:single;x:pointer; incx:integer);
begin
  MKLtest;
  _cSCAL(n,a,x,incx);
  MKLend;
end;

procedure dSCAL(n:integer; a:double;x:pointer; incx:integer);
begin
  MKLtest;
  _dSCAL(n,a,x,incx);
  MKLend;
end;

procedure zSCAL(n:integer; a:double;x:pointer; incx:integer);
begin
  MKLtest;
  _zSCAL(n,a,x,incx);
  MKLend;
end;

procedure csSCAL(n:integer; a:TsingleComp;x:pointer; incx:integer);
begin
  MKLtest;
  _csSCAL(n,a,x,incx);
  MKLend;
end;

procedure zdSCAL(n:integer; a:TdoubleComp;x:pointer; incx:integer);
begin
  MKLtest;
  _zdSCAL(n,a,x,incx);
  MKLend;
end;


procedure strSM(side,uplo,transa,diag:char;
                m,n:integer;
                alpha:single;a:pointer; lda:integer; b:pointer; ldb:integer);
begin
  MKLtest;
  _strSM(side,uplo,transa,diag,m,n,alpha,a,lda,b,ldb);
  MKLend;
end;

procedure dtrSM(side,uplo,transa,diag:char;
                m,n:integer;
                alpha:double;a:pointer; lda:integer; b:pointer; ldb:integer);
begin
  MKLtest;
  _dtrSM(side,uplo,transa,diag,m,n,alpha,a,lda,b,ldb);
  MKLend;
end;

procedure ctrSM(side,uplo,transa,diag:char;
                m,n:integer;
                alpha:TsingleComp;a:pointer; lda:integer; b:pointer; ldb:integer);
begin
  MKLtest;
  _ctrSM(side,uplo,transa,diag,m,n,alpha,a,lda,b,ldb);
  MKLend;
end;

procedure ztrSM(side,uplo,transa,diag:char;
                m,n:integer;
                alpha:TdoubleComp;a:pointer; lda:integer; b:pointer; ldb:integer);
begin
  MKLtest;
  _ztrSM(side,uplo,transa,diag,m,n,alpha,a,lda,b,ldb);
  MKLend;
end;


procedure sger(m, n:integer; alpha:single;
               x:pointer; incx:integer; y:pointer; incy:integer;
               a:pointer; lda:integer);
begin
  MKLtest;
  _sger(m,n,alpha,x,incx,y,incy,a,lda);
  MKLend;
end;

procedure dger(m, n:integer; alpha:double;
               x:pointer; incx:integer; y:pointer; incy:integer;
               a:pointer; lda:integer);
begin
  MKLtest;
  _dger(m,n,alpha,x,incx,y,incy,a,lda);
  MKLend;
end;

procedure ssyr( uplo:char; n:integer; alpha:single;
                x:pointer; incx:integer;
                a:pointer; lda:integer);
begin
  MKLtest;
  _ssyr( uplo,n,alpha,x,incx,a,lda);
  MKLend;
end;

procedure dsyr( uplo:char; n:integer; alpha:double;
                x:pointer; incx:integer;
                a:pointer; lda:integer);
begin
  MKLtest;
  _dsyr( uplo,n,alpha,x,incx,a,lda);
  MKLend;
end;


procedure ssyrk (uplo,trans:char;n, k:integer;alpha:single;
          a:pointer;lda:integer;
          beta:single;
          c: pointer; ldc: integer);
begin
  MKLtest;
  _ssyrk (uplo,trans,n, k,alpha, a,lda, beta, c,ldc);
  MKLend;
end;

procedure dsyrk (uplo,trans:char;n, k:integer;alpha:double;
          a:pointer;lda:integer;
          beta:double;
          c: pointer; ldc: integer);
begin
  MKLtest;
  _dsyrk (uplo,trans,n, k,alpha, a,lda, beta, c,ldc);
  MKLend;
end;

procedure csyrk (uplo,trans:char;n, k:integer;alpha:TsingleComp;
          a:pointer;lda:integer;
          beta:TsingleComp;
          c: pointer; ldc: integer);
begin
  MKLtest;
  _csyrk (uplo,trans,n, k,alpha, a,lda, beta, c,ldc);
  MKLend;
end;

procedure zsyrk (uplo,trans:char;n, k:integer;alpha:TdoubleComp;
          a:pointer;lda:integer;
          beta:TdoubleComp;
          c: pointer; ldc: integer);
begin
  MKLtest;
  _zsyrk (uplo,trans,n, k,alpha, a,lda, beta, c,ldc);
  MKLend;
end;

procedure sgemv(trans: char; m, n:integer;alpha:single;
                    a:pointer;lda:integer; x:pointer;incx:integer;
                    beta:single;y:pointer; incy:integer );
begin
  MKLtest;
  _sgemv(trans,m,n,alpha,a,lda,x,incx,beta,y,incy );
  MKLend;
end;

procedure dgemv(trans: char; m, n:integer;alpha:double;
                    a:pointer;lda:integer; x:pointer;incx:integer;
                    beta:double;y:pointer; incy:integer );
begin
  MKLtest;
  _dgemv(trans,m,n,alpha,a,lda,x,incx,beta,y,incy );
  MKLend;
end;

procedure cgemv(trans: char; m, n:integer;alpha:TsingleComp;
                    a:pointer;lda:integer; x:pointer;incx:integer;
                    beta:TsingleComp;y:pointer; incy:integer );
begin
  MKLtest;
  _cgemv(trans,m,n,alpha,a,lda,x,incx,beta,y,incy );
  MKLend;
end;

procedure zgemv(trans: char; m, n:integer;alpha:TdoubleComp;
                    a:pointer;lda:integer; x:pointer;incx:integer;
                    beta:TdoubleComp;y:pointer; incy:integer );
begin
  MKLtest;
  _zgemv(trans,m,n,alpha,a,lda,x,incx,beta,y,incy );
  MKLend;
end;


procedure ssyev(job,uplo:char;n:integer;a:pointer;lda:integer;w:pointer;
                 work:pointer;lwork:integer;info:integer);
begin
  MKLtest;
  _ssyev(job,uplo,n,a,lda,w,work,lwork,info);
  MKLend;
end;

procedure dsyev(job,uplo:char;n:integer;a:pointer;lda:integer;w:pointer;
                 work:pointer;lwork:integer;info:integer);
begin
  MKLtest;
  _dsyev(job,uplo,n,a,lda,w,work,lwork,info);
  MKLend;
end;


procedure ssyevd(job,uplo:char;n:integer;a:pointer;lda:integer;w:pointer;
                 work:pointer;lwork:integer;
                 iwork:pointer;liwork:integer;info:integer);
begin
  MKLtest;
  _ssyevd(job,uplo,n,a,lda,w,work,lwork,iwork,liwork,info);
  MKLend;
end;

procedure dsyevd(job,uplo:char;n:integer;a:pointer;lda:integer;w:pointer;
                 work:pointer;lwork:integer;
                 iwork:pointer;liwork:integer;info:integer);
begin
  MKLtest;
  _dsyevd(job,uplo,n,a,lda,w,work,lwork,iwork,liwork,info);
  MKLend;
end;

procedure vsAdd( N:integer; pA, pB, pY: Psingle);
begin
  MKLtest;
  _vsAdd(N,pA,pB,pY);
  MKLend;
end;

procedure vdAdd( N:integer; pA, pB, pY: Pdouble);
begin
  MKLtest;
  _vdAdd(N,pA,pB,pY);
  MKLend;
end;



Initialization
AffDebug('Initialization MathKernel0',0);

finalization

freeMKL;
end.




