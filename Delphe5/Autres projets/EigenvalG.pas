unit EigenvalG;


{ EigenvalG est construite à partir de Eigenval, Eigen1.inc et Eigen2.inc

  Dans la version originale, les tableaux étaient statiques et indexés à partir de 1
  Pour utiliser les tableaux dynamiques, on considère que l'indice 0 n'est jamais utilisé.
  
}


interface

type
  FloatEG = Double; { 8 byte real, requires 8087 math chip }

const
  TNNearlyZero = 1E-015;


type
  TNvector    = array of FloatEG;
  TNmatrix    = array of TNvector;
  TNIntVector = array of integer;

procedure Power(Dimen       : integer;
            var Mat         : TNmatrix;
            var GuessVector : TNvector;
                MaxIter     : integer;
                Tolerance   : FloatEG;
            var Eigenvalue  : FloatEG;
            var Eigenvector : TNvector;
            var Iter        : integer;
            var Error       : byte);

{----------------------------------------------------------------------------}
{-                                                                          -}
{-              Input:  Dimen, Mat, GuessVector, MaxIter, Tolerance         -}
{-             Output:  Eigenvalue, Eigenvector, Iter, Error                -}
{-                                                                          -}
{-            Purpose:  The power method approximates the dominant          -}
{-                      eigenvalue of a matrix.  The dominant               -}
{-                      eigenvalue is the eigenvalue of largest             -}
{-                      absolute magnitude. Given a square matrix Mat       -}
{-                      and an arbitrary vector OldApprox, the vector       -}
{-                      NewApprox is constructed by the matrix              -}
{-                      operation NewApprox = Mat - OldApprox .             -}
{-                      NewApprox is divided by its largest element         -}
{-                      ApproxEigenval, thereby normalizing                 -}
{-                      NewApprox. If NewApprox is the same as              -}
{-                      OldApprox then ApproxEigenval is the dominant       -}
{-                      eigenvalue and NewApprox is the associated          -}
{-                      eigenvector of the matrix Mat. If NewApprox         -}
{-                      is not the same as OldApprox then OldApprox         -}
{-                      is set equal to NewApprox and the operation         -}
{-                      repeats until a solution is reached. Aitken's       -}
{-                      delta-squared acceleration is used to speed         -}
{-                      the convergence from linear to quadratic.           -}
{-                                                                          -}
{- User-defined Types:  TNvector = array[1..TNArraySize] of real;           -}
{-                      TNmatrix = array[1..TNArraySize] of TNvector;       -}
{-                                                                          -}
{-   Global Variables:  Dimen       : integer;  Dimension of the matrix     -}
{-                      Mat         : TNmatrix; The matrix                  -}
{-                      GuessVector : TNvector; An initial guess of an      -}
{-                                              eigenvector                 -}
{-                      MaxIter     : integer;  Max. number of iterations   -}
{-                      Tolerance   : real;     Tolerance in answer         -}
{-                      Eigenvalue  : real;     Eigenvalue of the matrix    -}
{-                      Eigenvector : TNvector  Eigenvector of the matrix   -}
{-                      Iter        : integer;  Number of iterations        -}
{-                      Error       : byte;     Flags if something goes     -}
{-                                              wrong                       -}
{-             Errors:  0: No Errors                                        -}
{-                      1: Dimen < 2                                        -}
{-                      2: Tolerance <= 0                                   -}
{-                      3: MaxIter < 1                                      -}
{-                      4: Iter >= MaxIter                                  -}
{-                                                                          -}
{----------------------------------------------------------------------------}

procedure InversePower(Dimen       : integer;
                       Mat         : TNmatrix;
                   var GuessVector : TNvector;
                       ClosestVal  : FloatEG;
                       MaxIter     : integer;
                       Tolerance   : FloatEG;
                   var Eigenvalue  : FloatEG;
                   var Eigenvector : TNvector;
                   var Iter        : integer;
                   var Error       : byte);

{----------------------------------------------------------------------------}
{-                                                                          -}
{-          Input:  Dimen, Mat, GuessVector, ClosestVal, MaxIter, Tolerance -}
{-         Output:  Eigenvalue, Eigenvector, Iter, Error                    -}
{-                                                                          -}
{-            Purpose:  Whereas the power method converges onto the         -}
{-                      dominant eigenvalue of a matrix (see                -}
{-                      POWER.INC), the inverse power method                -}
{-                      converges onto the eigenvalue closest to a          -}
{-                      user-supplied value.  The user supplies a           -}
{-                      square matrix Mat, an initial approximation         -}
{-                      ClosestVal to the eigenvalue and an initial         -}
{-                      vector OldApprox.  The linear system                -}
{-                      (Mat - ClosestVal - I)OldApprox = NewApprox is      -}
{-                      solved via LU decomposition (see                    -}
{-                      DECMP-LU.INC\SOLVE-LU.INC).  The vector             -}
{-                      NewApprox is divided by its largest element         -}
{-                      ApproxEigenval (thereby normalizing the             -}
{-                      vector).  If NewApprox is identical to              -}
{-                      OldApprox then (1/ApproxEigenval + ClosestVal)      -}
{-                      is the eigenvalue of A closest to ClosestVal        -}
{-                      and OldApprox is the associated eigenvector.        -}
{-                      If NewApprox is not identical to OldApprox          -}
{-                      then OldApprox is set equal to NewApprox and        -}
{-                      the process repeats until a solution is             -}
{-                      reached.                                            -}
{-                                                                          -}
{- User-defined Types:  TNvector = array[1..TNArraySize] of real;           -}
{-                      TNmatrix = array[1..TNArraySize] of TNvector;       -}
{-                                                                          -}
{-   Global Variables:  Dimen       : integer;  Dimension of the matrix     -}
{-                      Mat         : TNmatrix; The matrix                  -}
{-                      GuessVector : TNvector; Initial guess of an         -}
{-                                              Eigenvector                 -}
{-                      ClosestVal  : real;     Converge to eigenvalue      -}
{-                                              Closest to this             -}
{-                      MaxIter     : integer;  Max. number of iterations   -}
{-                      Tolerance   : real;     Tolerance in answer         -}
{-                      Eigenvalue  : real;     Eigenvalue of the matrix    -}
{-                      Eigenvector : TNvector  Eigenvector of the matrix   -}
{-                      Iter        : integer;  Number of iterations        -}
{-                      Error       : byte;     Flags if something goes     -}
{-                                              wrong                       -}
{-             Errors:  0: No Errors                                        -}
{-                      1: Dimen < 2                                        -}
{-                      2: Tolerance <= 0                                   -}
{-                      3: MaxIter < 1                                      -}
{-                      4: Iter >= MaxIter                                  -}
{-                      5: eigenvalue/eigenvector not calculated            -}
{-                         See note below.                                  -}
{-                                                                          -}
{-               Note:  If the matrix Mat - EigenValue-I, where I           -}
{-                      is the identity matrix, is singular, then           -}
{-                      the inverse power method may not be used            -}
{-                      to approximate an eigenvalue and eigenvector        -}
{-                      of Mat and Error = 5 will be returned.              -}
{-                                                                          -}
{----------------------------------------------------------------------------}

procedure Wielandt(Dimen        : integer;
                   Mat          : TNmatrix;
               var GuessVector  : TNvector;
                   MaxEigens    : integer;
                   MaxIter      : integer;
                   Tolerance    : FloatEG;
               var NumEigens    : integer;
               var Eigenvalues  : TNvector;
               var Eigenvectors : TNmatrix;
               var Iter         : TNIntVector;
               var Error        : byte);

{----------------------------------------------------------------------------}
{-                                                                          -}
{-        Input: Dimen, Mat, GuessVector, MaxEigens, MaxIter, Tolerance     -}
{-       Output: NumEigens, Eigenvalues, Eigenvectors, Iter, Error          -}
{-                                                                          -}
{-            Purpose:  This procedure attempts to approximate some (or     -}
{-                      all, depending on MaxEigens)  of the                -}
{-                      eigenvectors and eigenvalues of a matrix.  The      -}
{-                      power method is used in conjunction with Wielandt's -}
{-                      deflation.                                          -}
{-                                                                          -}
{- User-defined Types:  TNvector = array[1..RowSize] of real;               -}
{-                      TNmatrix = array[1..ColumnSize] of TNvector;        -}
{-                      TNIntVector = array[1..RowSize] of integer;         -}
{-                                                                          -}
{-   Global Variables:  Dimen        : integer;  Dimension of the matrix    -}
{-                      Mat          : TNmatrix; The matrix                 -}
{-                      GuessVector  : TNvector; An initial guess of an     -}
{-                                               eigenvector                -}
{-                      MaxEigens    : integer;  Maximum number of eigens   -}
{-                                               to find                    -}
{-                      MaxIter      : integer;  Max. number of iterations  -}
{-                      Tolerance    : real;     Tolerance in answer        -}
{-                      NumEigens    : integer;  Number of eigenvalues      -}
{-                                               calculated                 -}
{-                      Eigenvalues  : TNvector; Eigenvalues of the matrix  -}
{-                      Eigenvectors : TNmatrix  Eigenvectors of the matrix -}
{-                      Iter         : TNInTVector; Number of iterations    -}
{-                      Error        : byte;     Flags if something goes    -}
{-                                               wrong                      -}
{-             Errors:  0: No Errors                                        -}
{-                      1: Dimen < 2                                        -}
{-                      2: Tolerance <= 0                                   -}
{-                      3: MaxIter < 1                                      -}
{-                      4: MaxEigens < 1                                    -}
{-                      5: Iter >= MaxIter                                  -}
{-                      6: Last two roots aren't real                       -}
{-                                                                          -}
{----------------------------------------------------------------------------}

procedure Jacobi(Dimen        : integer;
                 Mat          : TNmatrix;
                 MaxIter      : integer;
                 Tolerance    : FloatEG;
             var Eigenvalues  : TNvector;
             var Eigenvectors : TNmatrix;
             var Iter         : integer;
             var Error        : byte);

{----------------------------------------------------------------------------}
{-                                                                          -}
{-     Input: Dimen, Mat, MaxIter, Tolerance                                -}
{-    Output: Eigenvalues, Eigenvector, Iter, Error                         -}
{-                                                                          -}
{-   Purpose: The eigensystem of a symmetric matrix can be                  -}
{-            computed much more simply than the                            -}
{-            eigensystem of an arbitrary matrix.  The                      -}
{-            cyclic Jacobi method is an iterative                          -}
{-            technique for approximating the complete                      -}
{-            eigensystem of a symmetric matrix to a given                  -}
{-            tolerance. The method consists of multiplying                 -}
{-            the matrix, Mat, by a series of rotation                      -}
{-            matrices, r@-[i].  The rotation matrices are                  -}
{-            chosen so that the elements of the upper                      -}
{-            triangular part of Mat are systematically                     -}
{-            annihilated.  That is, r@-[1] is chosen so                    -}
{-            that Mat[1, 1] is identically zero; r@-[2] is                 -}
{-            chosen so that Mat[1, 2] is identically zero;                 -}
{-            etc.  Since each operation will probably                      -}
{-            change the value of elements annihilated in                   -}
{-            previous operations, the method is iterative.                 -}
{-            Eventually, the matrix will be diagonal. The                  -}
{-            eigenvalues will be the elements along the                    -}
{-            diagonal of the matrix and the eigenvectors                   -}
{-            will be the rows of the matrix created by the                 -}
{-            product of all the rotation matrices r@-[i].                  -}
{-                                                                          -}
{-            The user inputs the matrix, tolerance and maximum             -}
{-            number of iterations. The procedure returns the               -}
{-            eigenvalues and eigenvectors (or error code) of the           -}
{-            matrix.                                                       -}
{-                                                                          -}
{-   User-Defined Types: TNvector = array[1..TNArraySize] of real;          -}
{-                       TNmatrix = array[1..TNArraySize] of TNvector;      -}
{-                                                                          -}
{-   Global Variables:  Dimen        : integer   Dimension of square matrix -}
{-                      Mat          : TNmatrix  Square matrix              -}
{-                      MaxIter      : integer   Maximum number of          -}
{-                                               Iterations                 -}
{-                      Tolerance    : real      Tolerance in answer        -}
{-                      Eigenvalues  : TNvector  Eigenvalues of Mat         -}
{-                      Eigenvectors : TNmatrix  Eigenvectors of Mat        -}
{-                      Iter         : integer   Number of iterations       -}
{-                      Error        : byte      Error code                 -}
{-                                                                          -}
{-             Errors:  0: No error                                         -}
{-                      1: Dimen < 1                                        -}
{-                      2: Tolerance < TNNearlyZero                         -}
{-                      3: MaxIter < 1                                      -}
{-                      4: Mat not symmetric                                -}
{-                      5: Iter > MaxIter                                   -}
{-                                                                          -}
{----------------------------------------------------------------------------}

procedure initTNmatrix(var mat:TNmatrix;n:integer);
procedure initTNvector(var vec:TNvector;n:integer);
procedure initTNintVector(var vec:TNintVector;n:integer);


procedure ZeroTNmatrix(var mat:TNmatrix);
procedure zeroTNvector(var vec:TNvector);
procedure zeroTNintVector(var vec:TNintvector);


implementation

procedure initTNmatrix(var mat:TNmatrix;n:integer);
var
  i:integer;
begin
  setLength(mat,n+1);
  for i:=1 to n do
  begin
    setLength(mat[i],n+1);
    fillchar(mat[i][0],sizeof(floatEG)*(n+1),0);
  end;
end;

procedure initTNvector(var vec:TNvector;n:integer);
begin
  setLength(vec,n+1);
  fillchar(vec[0],sizeof(floatEG)*(n+1),0);
end;

procedure initTNINTvector(var vec:TNintVector;n:integer);
begin
  setLength(vec,n+1);
  fillchar(vec[0],sizeof(integer)*(n+1),0);
end;


procedure ZeroTNmatrix(var mat:TNmatrix);
var
  i:integer;
begin
  for i:=1 to high(mat) do
  begin
    fillchar(mat[i][0],sizeof(floatEG)*length(mat),0);
  end;
end;

procedure zeroTNvector(var vec:TNvector);
begin
  fillchar(vec[0],sizeof(floatEG)*length(vec),0);
end;

procedure zeroTNintVector(var vec:TNintVector);
begin
  fillchar(vec[0],sizeof(integer)*length(vec),0);
end;

procedure CopyTNvector(var src,dest:TNvector);
begin
  setLength(dest,length(src));
  move(src[0],dest[0],length(src)*sizeof(floatEG));
end;


{----------------------------------------------------------------------------}
{-                                                                          -}
{-     Turbo Pascal Numerical Methods Toolbox                               -}
{-     Copyright (c) 1986, 87 by Borland International, Inc.                -}
{-                                                                          -}
{----------------------------------------------------------------------------}

procedure Power{(Dimen      : integer;
            var Mat         : TNmatrix;
            var GuessVector : TNvector;
                MaxIter     : integer;
                Tolerance   : FloatEG;
            var Eigenvalue  : FloatEG;
            var Eigenvector : TNvector;
            var Iter        : integer;
            var Error       : byte)};

type
  TNThreeMatrix = array[0..2] of TNvector;

var
  OldApprox, NewApprox : TNvector;     { Iteration variables }
  ApproxEigenval : FloatEG;               { Iteration variables }
  AitkenVector : TNThreeMatrix;
  Remainder : integer;
  Found : boolean;
  Index : integer;
  Denom : FloatEG;

procedure TestDataAndInitialize(Dimen          : integer;
                            var Mat            : TNmatrix;
                            var GuessVector    : TNvector;
                                Tolerance      : FloatEG;
                                MaxIter        : integer;
                            var Eigenvalue     : FloatEG;
                            var Eigenvector    : TNvector;
                            var Found          : boolean;
                            var Iter           : integer;
                            var OldApprox      : TNvector;
                            var AitkenVector   : TNThreeMatrix;
                            var ApproxEigenval : FloatEG;
                            var Error          : byte);

{---------------------------------------------------------}
{- Input: Dimen, Mat, GuessVector, Tolerance, MaxIter    -}
{- Output: GuessVector, Eigenvalue, Eigenvector          -}
{-         Found, Error                                  -}
{-                                                       -}
{- This procedure tests the input data for errors        -}
{- If all the elements of the GuessVector are zero, then -}
{- they are all replaced by ones.                        -}
{- If the dimension of the matrix is one, then the       -}
{- eigenvalue is equal to the matrix.                    -}
{---------------------------------------------------------}

var
  Term : integer;
  Sum : FloatEG;
  i:integer;
begin
  Error := 0;
  Sum := 0;
  for Term := 1 to Dimen do
    Sum := Sum + Sqr(GuessVector[Term]);
  if Sum < TNNearlyZero then { The GuessVector is the zero vector }
    for Term := 1 to Dimen do
      GuessVector[Term] := 1;
  if Dimen < 1 then
    Error := 1;
  if Tolerance <= 0 then
    Error := 2;
  if MaxIter < 1 then
    Error := 3;
  if Error = 0 then
  begin
    Iter := 0;
    {OldApprox := GuessVector;}
    copyTNvector(GuessVector,OldApprox);
    for i:=0 to 2 do ZeroTNvector(AitkenVector[i]);
    ApproxEigenval := 0;
    Found := false;
  end;
  if Dimen = 1 then
  begin
    Eigenvalue := Mat[1, 1];
    Eigenvector[1] := 1;
    Found := true;
  end;
end; { procedure TestDataAndInitialize }

procedure FindLargest(Dimen   : integer;
                  var Vec     : TNvector;
                  var Largest : FloatEG);

{---------------------------------------}
{- Input: Dimen, Vec                   -}
{- Output: Largest                     -}
{-                                     -}
{- This procedure searches Vec for the -}
{- element of largest absolute value.  -}
{---------------------------------------}

var
  Term : integer;

begin
  Largest := Vec[Dimen];
  for Term := Dimen - 1 downto 1 do
    if ABS(Vec[Term]) > ABS(Largest) then
      Largest := Vec[Term];
end; { procedure FindLargest }

procedure Div_Vec_Const(Dimen   : integer;
                    var Vec     : TNvector;
                        Divisor : FloatEG);

{----------------------------------------------}
{- Input: Dimen, Vec, Divisor                 -}
{- Output: Vec                                -}
{-                                            -}
{- This procedure divides each element        -}
{- of the vector Vec by the constant Divisor. -}
{----------------------------------------------}

var
  Term : integer;

begin
  for Term := 1 to Dimen do
    Vec[Term] := Vec[Term] / Divisor;
end; { procedure Div_Vec_Const }

procedure Mult_Mat_Vec(Dimen  : integer;
                   var Mat    : TNmatrix;
                   var Vec    : TNvector;
                   var Result : TNvector);

{----------------------------------------}
{- Input: Dimen, Mat, Vec               -}
{- Output: Result                       -}
{-                                      -}
{- Multiply a vector by a square matrix -}
{----------------------------------------}

var
  Row, Column : integer;
  Entry : FloatEG;

begin
  for Row := 1 to Dimen do
  begin
    Entry := 0;
    for Column := 1 to Dimen do
      Entry := Entry + Mat[Row, Column] * Vec[Column];
    Result[Row] := Entry;
  end;
end; { procedure Mult_Mat_Vec }


procedure TestForConvergence(Dimen     : integer;
                         var OldApprox : TNvector;
                         var NewApprox : TNvector;
                             Tolerance : FloatEG;
                         var Found     : boolean);

{-----------------------------------------------------------------}
{- Input: Dimen, OldApprox, NewApprox, Tolerance,                -}
{- Output: Found                                                 -}
{-                                                               -}
{- This procedure determines if the iterations have converged.   -}
{- on a solution.  If the absolute difference in EACH element of -}
{- the eigenvector between the last two iterations (i.e. between -}
{- OldApprox and NewApprox) is less than Tolerance, then         -}
{- convergence has occurred and Found = true.  Otherwise,        -}
{- Found = false.                                                -}
{-----------------------------------------------------------------}

var
  Index : integer;

begin
  Index := 0;
  Found := true;
  while (Found = true) and (Index < Dimen) do
  begin
    Index := Succ(Index);
    if ABS(OldApprox[Index] - NewApprox[Index]) > Tolerance then
      Found := false;
  end; { while }
end; { procedure TestForConvergence }

begin { procedure Power }
  TestDataAndInitialize(Dimen, Mat, GuessVector, Tolerance, MaxIter,
                        Eigenvalue, Eigenvector, Found, Iter,
                        OldApprox, AitkenVector, ApproxEigenval, Error);
  if (Error = 0) and (Found = false) then
  begin
    FindLargest(Dimen, OldApprox, ApproxEigenval);
    Div_Vec_Const(Dimen, OldApprox, ApproxEigenval);
    while (Iter < MaxIter) and not Found do
    begin
      Iter := Succ(Iter);
      Remainder := Iter MOD 3;
      if Remainder = 0 then  { Use Aitken's acceleration algorithm to  }
                             { generate the next iterate approximation }
      begin
        {OldApprox := AitkenVector[0];}
        copyTNvector(AitkenVector[0],oldApprox);

        for Index := 1 to Dimen do
        begin
          Denom := AitkenVector[2, Index] -
                   2 * AitkenVector[1, Index] + AitkenVector[0, Index];
          if ABS(Denom) > TNNearlyZero then
            OldApprox[Index] := AitkenVector[0, Index] -
            Sqr(AitkenVector[1, Index] - AitkenVector[0, Index]) / Denom;
        end;
      end;
      { Use the power method to generate }
      { the next iterate approximation   }
      Mult_Mat_Vec(Dimen, Mat, OldApprox, NewApprox);
      FindLargest(Dimen, NewApprox, ApproxEigenval);
      if ABS(ApproxEigenval) < TNNearlyZero then
        begin
          ApproxEigenval := 0;
          Found := true;
        end
      else
        begin
          Div_Vec_Const(Dimen, NewApprox, ApproxEigenval);
          TestForConvergence(Dimen, OldApprox, NewApprox, Tolerance, Found);
          {OldApprox := NewApprox;}
          copyTNvector(NewApprox,oldApprox);
        end;
      {AitkenVector[Remainder] := NewApprox;}
      copyTNvector(NewApprox,AitkenVector[Remainder]);
    end; { while }
    {Eigenvector := OldApprox;}
    copyTNvector(oldApprox,EigenVector);

    Eigenvalue := ApproxEigenval;

    if Iter >= MaxIter then
      Error := 4;
  end;
end; { procedure Power }

procedure InversePower{(Dimen      : integer;
                       Mat         : TNmatrix;
                   var GuessVector : TNvector;
                       ClosestVal  : FloatEG;
                       MaxIter     : integer;
                       Tolerance   : FloatEG;
                   var Eigenvalue  : FloatEG;
                   var Eigenvector : TNvector;
                   var Iter        : integer;
                   var Error       : byte)};

var
  OldApprox, NewApprox : TNvector;     { Iteration variables }
  ApproxEigenval : FloatEG;               { Iteration variables }
  Found : boolean;

procedure TestDataAndInitialize(Dimen          : integer;
                            var Mat            : TNmatrix;
                            var GuessVector    : TNvector;
                                Tolerance      : FloatEG;
                                MaxIter        : integer;
                            var Eigenvalue     : FloatEG;
                            var Eigenvector    : TNvector;
                            var Found          : boolean;
                            var Iter           : integer;
                            var OldApprox      : TNvector;
                            var ClosestVal     : FloatEG;
                            var ApproxEigenval : FloatEG;
                            var Error          : byte);

{--------------------------------------------------------}
{- Input: Dimen, Mat, GuessVector, Tolerance, MaxIter   -}
{- Output: Guess, Eigenvalue, Eigenvector, Found,       -}
{-         Iter, OldApprox, ClosestVal, ApproxEigenval, -}
{-         Error                                        -}
{-                                                      -}
{- This procedure tests the input data for errors       -}
{- If all the elements of the GuessVector are           -}
{- zero, then they are all replaced by ones.            -}
{- If the dimension of the matrix is one, then the      -}
{- eigenvalue equals the matrix.                        -}
{--------------------------------------------------------}

var
  Term : integer;
  Sum : FloatEG;

begin
  Error := 0;
  Sum := 0;
  for Term := 1 to Dimen do
    Sum := Sum + Sqr(GuessVector[Term]);
  if Sum < TNNearlyZero then { The GuessVector is the zero vector }
    for Term := 1 to Dimen do
      GuessVector[Term] := 1;
  if Dimen < 1 then
    Error := 1;
  if Tolerance <= 0 then
    Error := 2;
  if MaxIter < 1 then
    Error := 3;
  Found := false;
  if Dimen = 1 then
  begin
    Eigenvalue := Mat[1, 1];
    Eigenvector[1] := 1;
    Found := true;
  end;
  if Error = 0 then
  begin
    Iter := 0;
    {OldApprox := GuessVector;}
    copyTNvector(GuessVector,OldApprox);
    { Subtract ClosestVal from the main diagonal of Mat }
    for Term := 1 to Dimen do
      Mat[Term, Term] := Mat[Term, Term] - ClosestVal;
    ApproxEigenval := 0;
  end;
end; { procedure TestDataAndInitialize }

procedure FindLargest(Dimen   : integer;
                  var Vec     : TNvector;
                  var Largest : FloatEG);

{---------------------------------------}
{- Input: Dimen, Vec                   -}
{- Output: Largest                     -}
{-                                     -}
{- This procedure searches Vec for the -}
{- element of largest absolute value.  -}
{---------------------------------------}

var
  Term : integer;

begin
  Largest := Vec[Dimen];
  for Term := Dimen - 1 downto 1 do
    if ABS(Vec[Term]) > ABS(Largest) then
      Largest := Vec[Term];
end; { procedure FindLargest }

procedure Div_Vec_Const(Dimen   : integer;
                    var Vec     : TNvector;
                        Divisor : FloatEG);

{----------------------------------------------}
{- Input: Dimen, Vec, Divisor                 -}
{- Output: Vec                                -}
{-                                            -}
{- This procedure divides each element        -}
{- of the vector Vec by the constant Divisor. -}
{----------------------------------------------}

var
  Term : integer;

begin
  for Term := 1 to Dimen do
    Vec[Term] := Vec[Term] / Divisor;
end; { procedure Div_Vec_Const }

procedure GetNewApprox(Dimen     : integer;
                   var Mat       : TNmatrix;
                   var OldApprox : TNvector;
                   var NewApprox : TNvector;
                       Iter      : integer;
                   var Error     : byte);

{---------------------------------------------}
{- Input: Dimen, Mat, OldApprox, Iter        -}
{- Output: NewApprox, Error                  -}
{-                                           -}
{- This procedure uses Gaussian elimination  -}
{- with partial pivoting to solve the linear -}
{- system:                                   -}
{-   Mat - NewApprox = OldApprox             -}
{- If no unique solution exists, then        -}
{- Error = 5 is returned.                    -}
{---------------------------------------------}

var
  Decomp: TNmatrix;
  Permute : TNmatrix;

{----------------------------------------------------------------------------}

procedure Decompose(Dimen        : integer;
                    Coefficients : TNmatrix;
                var Decomp       : TNmatrix;
                var Permute      : TNmatrix;
                var Error        : byte);

{----------------------------------------------------------------------------}
{-                                                                          -}
{-                Input: Dimen, Coefficients                                -}
{-               Output: Decomp, Permute, Error                             -}
{-                                                                          -}
{-             Purpose : Decompose a square matrix into an upper            -}
{-                       triangular and lower triangular matrix such that   -}
{-                       the product of the two triangular matrices is      -}
{-                       the original matrix. This procedure also returns   -}
{-                       a permutation matrix which records the             -}
{-                       permutations resulting from partial pivoting.      -}
{-                                                                          -}
{-  User-defined Types : TNvector = array[1..TNArraySize] of real           -}
{-                       TNmatrix = array[1..TNArraySize] of TNvector       -}
{-                                                                          -}
{-    Global Variables : Dimen        : integer;  Dimen of the coefficients -}
{-                                                matrix                    -}
{-                       Coefficients : TNmatrix; Coefficients matrix       -}
{-                       Decomp       : TNmatrix; Decomposition of          -}
{-                                                coefficients matrix       -}
{-                       Permute      : TNmatrix; Record of partial         -}
{-                                                pivoting                  -}
{-                       Error        : integer;  Flags if something goes   -}
{-                                                wrong.                    -}
{-                                                                          -}
{-              Errors : 0: No errors;                                      -}
{-                       1: Dimen < 1                                       -}
{-                       2: No decomposition possible; singular matrix      -}
{-                                                                          -}
{----------------------------------------------------------------------------}

procedure TestInput(Dimen : integer;
                var Error : byte);

{---------------------------------------}
{- Input: Dimen                        -}
{- Output: Error                       -}
{-                                     -}
{- This procedure checks to see if the -}
{- value of Dimen is greater than 1.   -}
{---------------------------------------}

begin
  Error := 0;
  if Dimen < 1 then
    Error := 1;
end; { procedure TestInput }

function RowColumnMult(Row    : integer;
                   var Lower  : TNmatrix;
                       Column : integer;
                   var Upper  : TNmatrix) : FloatEG;

{----------------------------------------------------}
{- Input: Row, Lower, Column, Upper                 -}
{- Function return: dot product of row Row of Lower -}
{-                  and column Column of Upper      -}
{----------------------------------------------------}

var
  Term : integer;
  Sum : FloatEG;

begin
  Sum := 0;
  for Term := 1 to Row - 1 do
    Sum := Sum + Lower[Row, Term] * Upper[Term, Column];
  RowColumnMult := Sum;
end; { function RowColumnMult }


procedure Pivot(Dimen        : integer;
                ReferenceRow : integer;
            var Coefficients : TNmatrix;
            var Lower        : TNmatrix;
            var Upper        : TNmatrix;
            var Permute      : TNmatrix;
            var Error        : byte);

{----------------------------------------------------------------}
{- Input: Dimen, ReferenceRow, Coefficients,                    -}
{-        Lower, Upper, Permute                                 -}
{- Output: Coefficients, Lower, Permute, Error                  -}
{-                                                              -}
{- This procedure searches the ReferenceRow column of the       -}
{- Coefficients matrix for the element in the Row below the     -}
{- main diagonal which produces the largest value of            -}
{-                                                              -}
{-         Coefficients[Row, ReferenceRow] -                    -}
{-                                                              -}
{-          SUM K=1 TO ReferenceRow - 1 of                      -}
{-                  Upper[Row, k] - Lower[k, ReferenceRow]      -}
{-                                                              -}
{- If it finds one, then the procedure switches                 -}
{- rows so that this element is on the main diagonal. The       -}
{- procedure also switches the corresponding elements in the    -}
{- Permute matrix and the Lower matrix. If the largest value of -}
{- the above expression is zero, then the matrix is singular    -}
{- and no solution exists (Error = 2 is returned).              -}
{----------------------------------------------------------------}

var
  PivotRow, Row : integer;
  ColumnMax, TestMax : FloatEG;

procedure EROswitch(var Row1 : TNvector;
                    var Row2 : TNvector);

{-------------------------------------------------}
{- Input: Row1, Row2                             -}
{- Output: Row1, Row2                            -}
{-                                               -}
{- Elementary row operation - switching two rows -}
{-------------------------------------------------}

var
  DummyRow : TNvector;

begin
  DummyRow := Row1;
  Row1 := Row2;
  Row2 := DummyRow;
end; { procedure EROswitch }

begin { procedure Pivot }
  { First, find the row with the largest TestMax }
  PivotRow := ReferenceRow;
  ColumnMax := ABS(Coefficients[ReferenceRow, ReferenceRow] -
               RowColumnMult(ReferenceRow, Lower, ReferenceRow, Upper));
  for Row := ReferenceRow + 1 to Dimen do
  begin
    TestMax := ABS(Coefficients[Row, ReferenceRow] -
               RowColumnMult(Row, Lower, ReferenceRow, Upper));
    if TestMax > ColumnMax then
    begin
      PivotRow := Row;
      ColumnMax := TestMax;
    end;
  end;
  if PivotRow <> ReferenceRow then
    { Second, switch these two rows }
    begin
      EROswitch(Coefficients[PivotRow], Coefficients[ReferenceRow]);
      EROswitch(Lower[PivotRow], Lower[ReferenceRow]);
      EROswitch(Permute[PivotRow], Permute[ReferenceRow]);
    end
  else { If ColumnMax is zero, no solution exists }
    if ColumnMax < TNNearlyZero then
      Error := 2;     { No solution exists }
end; { procedure Pivot }

procedure LU_Decompose(Dimen        : integer;
                   var Coefficients : TNmatrix;
                   var Decomp       : TNmatrix;
                   var Permute      : TNmatrix;
                   var Error        : byte);

{---------------------------------------------------------}
{- Input: Dimen, Coefficients                            -}
{- Output: Decomp, Permute, Error                        -}
{-                                                       -}
{- This procedure decomposes the Coefficients matrix     -}
{- into two triangular matrices, a lower and an upper    -}
{- one.  The lower and upper matrices are combined       -}
{- into one matrix, Decomp.  The permutation matrix,     -}
{- Permute, records the effects of partial pivoting.     -}
{---------------------------------------------------------}

var
  Upper, Lower : TNmatrix;
  Term, Index : integer;

procedure Initialize(Dimen   : integer;
                 var Lower   : TNmatrix;
                 var Upper   : TNmatrix;
                 var Permute : TNmatrix);

{---------------------------------------------------}
{- Output: Dimen, Lower, Upper, Permute            -}
{-                                                 -}
{- This procedure initializes the above variables. -}
{- Lower and Upper are initialized to the zero     -}
{- matrix and Diag is initialized to the identity  -}
{- matrix.                                         -}
{---------------------------------------------------}

var
  Diag : integer;

begin
  ZeroTNmatrix(Upper);
  ZeroTNmatrix(Lower);
  ZeroTNmatrix(Permute);
  for Diag := 1 to Dimen do
    Permute[Diag, Diag] := 1;
end; { procedure Permute }

begin
  Initialize(Dimen, Lower, Upper, Permute);
  { Perform partial pivoting on row 1 }
  Pivot(Dimen, 1, Coefficients, Lower, Upper, Permute, Error);
  if Error = 0 then
  begin
    Lower[1, 1] := 1;
    Upper[1, 1] := Coefficients[1, 1];
    for Term := 1 to Dimen do
    begin
      Lower[Term, 1] := Coefficients[Term, 1] / Upper[1, 1];
      Upper[1, Term] := Coefficients[1, Term] / Lower[1, 1];
    end;
  end;
  Term := 1;
  while (Error = 0) and (Term < Dimen - 1) do
  begin
    Term := Succ(Term);
    { Perform partial pivoting on row Term }
    Pivot(Dimen, Term, Coefficients, Lower, Upper, Permute, Error);
    Lower[Term, Term] := 1;
    Upper[Term, Term] := Coefficients[Term, Term] -
                         RowColumnMult(Term, Lower, Term, Upper);
    if ABS(Upper[Term, Term]) < TNNearlyZero then
      Error := 2   { No solutions }
    else
      for Index := Term + 1 to Dimen do
      begin
        Upper[Term, Index] := Coefficients[Term, Index] -
                              RowColumnMult(Term, Lower, Index, Upper);
        Lower[Index, Term] := (Coefficients[Index, Term] -
                              RowColumnMult(Index, Lower,Term, Upper)) /
                              Upper[Term, Term];
      end
  end; { while }
  Lower[Dimen, Dimen] := 1;
  Upper[Dimen, Dimen] := Coefficients[Dimen, Dimen] -
                         RowColumnMult(Dimen, Lower, Dimen, Upper);
  if ABS(Upper[Dimen, Dimen]) < TNNearlyZero then
    Error := 2;
  { Combine the upper and lower triangular matrices into one }
  Decomp := Upper;

  for Term := 2 to Dimen do
    for Index := 1 to Term - 1 do
      Decomp[Term, Index] := Lower[Term, Index];
end; { procedure LU_Decompose }

begin  { procedure Decompose }
  TestInput(Dimen, Error);
  if Error = 0 then
    if Dimen = 1 then
      begin
        Decomp := Coefficients;
        Permute[1, 1] := 1;
      end
    else
      LU_Decompose(Dimen, Coefficients, Decomp, Permute, Error);
end; { procedure Decompose }

procedure Solve_LU_Decomposition(Dimen     : integer;
                             var Decomp    : TNmatrix;
                                 Constants : TNvector;
                             var Permute   : TNmatrix;
                             var Solution  : TNvector;
                             var Error     : byte);

{----------------------------------------------------------------------------}
{-                                                                          -}
{-                Input: Dimen, Decomp, Constants, Permute                  -}
{-               Output: Solution, Error                                    -}
{-                                                                          -}
{-             Purpose : Calculate the solution of a linear set of          -}
{-                       equations using an LU decomposed matrix, a         -}
{-                       permutation matrix and backwards substitution.     -}
{-                                                                          -}
{-  User_defined Types : TNvector = array[1..TNArraySize] of real           -}
{-                       TNmatrix = array[1..TNArraySize] of TNvector       -}
{-                                                                          -}
{-    Global Variables : Dimen     : integer;   Dimen of the square         -}
{-                                              matrix                      -}
{-                       Decomp    : TNmatrix;  Decomposition of            -}
{-                                              the matrix                  -}
{-                       Constants : TNvector;  Constants of each equation  -}
{-                       Permute   : TNmatrix;  Permutation matrix from     -}
{-                                              partial pivoting            -}
{-                       Solution  : TNvector;  Unique solution to the      -}
{-                                              set of equations            -}
{-                       Error     : integer;   Flags if something goes     -}
{-                                              wrong.                      -}
{-                                                                          -}
{-              Errors : 0: No errors;                                      -}
{-                       1: Dimen < 1                                       -}
{-                                                                          -}
{----------------------------------------------------------------------------}

procedure Initial(Dimen    : integer;
              var Solution : TNvector;
              var Error    : byte);

{----------------------------------------------------}
{- Input: Dimen                                     -}
{- Output: Solution, Error                          -}
{-                                                  -}
{- This procedure initializes the Solution vector.  -}
{- It also checks to see if the value of Dimen is   -}
{- greater than 1.                                  -}
{----------------------------------------------------}

begin
  Error := 0;
  ZeroTNvector(Solution);
  if Dimen < 1 then
    Error := 1;
end; { procedure Initial }

procedure FindSolution(Dimen     : integer;
                   var Decomp    : TNmatrix;
                   var Constants : TNvector;
                   var Solution  : TNvector);

{---------------------------------------------------------------}
{- Input: Dimen, Decomp, Constants                             -}
{- Output: Solution                                            -}
{-                                                             -}
{- The Decom matrix contains a lower and upper triangular      -}
{- matrix.                                                     -}
{- This procedure performs a two step backwards substitution   -}
{- to compute the solution to the system of equations.  First, -}
{- backwards substitution is applied to the lower triangular   -}
{- matrix and Constants vector yielding PartialSolution.  Then -}
{- backwards substitution is applied to the Upper matrix and   -}
{- the PartialSolution vector yielding Solution.               -}
{---------------------------------------------------------------}

var
  PartialSolution : TNvector;
  Term, Index : integer;
  Sum : FloatEG;

begin { procedure FindSolution }
  { First solve the lower triangular matrix }
  PartialSolution[1] := Constants[1];
  for Term := 2 to Dimen do
  begin
    Sum := 0;
    for Index := 1 to Term - 1 do
      if Term = Index then
        Sum := Sum + PartialSolution[Index]
      else
        Sum := Sum + Decomp[Term, Index] * PartialSolution[Index];
    PartialSolution[Term] := Constants[Term] - Sum;
  end;
  { Then solve the upper triangular matrix }
  Solution[Dimen] := PartialSolution[Dimen]/Decomp[Dimen, Dimen];
  for Term := Dimen - 1 downto 1 do
  begin
    Sum := 0;
    for Index := Term + 1 to Dimen do
      Sum := Sum + Decomp[Term, Index] * Solution[Index];
    Solution[Term] := (PartialSolution[Term] - Sum) / Decomp[Term, Term];
  end;
end; { procedure FindSolution }

procedure PermuteConstants(Dimen     : integer;
                       var Permute   : TNmatrix;
                       var Constants : TNvector);

var
  Row, Column : integer;
  Entry : FloatEG;
  TempConstants : TNvector;

begin
  for Row := 1 to Dimen do
  begin
    Entry := 0;
    for Column := 1 to Dimen do
      Entry := Entry + Permute[Row, Column] * Constants[Column];
    TempConstants[Row] := Entry;
  end;  {FOR Row}
  Constants := TempConstants;
end; { procedure PermuteConstants }

begin { procedure Solve_LU_Decompostion }
  Initial(Dimen, Solution, Error);
  if Error = 0 then
    PermuteConstants(Dimen, Permute, Constants);
  FindSolution(Dimen, Decomp, Constants, Solution);
end; { procedure Solve_LU_Decomposition }

{----------------------------------------------------------------------------}

begin { procedure GetNewApprox }
  if Iter = 1 then
  begin
    Decompose(Dimen, Mat, Decomp, Permute, Error);
    if Error = 2 then { Returned from Decompose - matrix is singular }
      Error := 5;     { eigenvalue/eigenvector can't   }
                      { be calculated with this method }
  end;
  if Error = 0 then
    Solve_LU_Decomposition(Dimen, Decomp, OldApprox, Permute, NewApprox, Error);
end; { procedure GetNewApprox }

procedure TestForConvergence(Dimen     : integer;
                         var OldApprox : TNvector;
                         var NewApprox : TNvector;
                             Tolerance : FloatEG;
                         var Found     : boolean);

{-----------------------------------------------------------------}
{- Input: Dimen, OldApprox, NewApprox, Tolerance,                -}
{- Output: Found                                                 -}
{-                                                               -}
{- This procedure determines if the iterations have converged    -}
{- on a solution.  If the absolute difference in each element of -}
{- the eigenvector between the last two iterations (i.e. between -}
{- OldApprox and NewApprox) is less than Tolerance, then         -}
{- convergence has occurred and Found = true.  Otherwise,        -}
{- Found = false.                                                -}
{-----------------------------------------------------------------}

var
  Index : integer;
  Difference : FloatEG;

begin
  Index := 0;
  Found := true;
  while (Found = true) and (Index < Dimen) do
  begin
    Index := Succ(Index);
    if (ABS(OldApprox[Index]) > TNNearlyZero) and
       (ABS(NewApprox[Index]) > TNNearlyZero) then
      begin
        Difference := ABS(OldApprox[Index] - NewApprox[Index]);
        if Difference > Tolerance then
          Found := false;
      end;
  end; { while }
end; { procedure TestForConvergence }

begin  { procedure InversePower }
  TestDataAndInitialize(Dimen, Mat, GuessVector, Tolerance, MaxIter,
                        Eigenvalue, Eigenvector, Found, Iter, OldApprox,
                        ClosestVal, ApproxEigenval, Error);

  if (Error = 0) and (Found = false) then
  begin
    FindLargest(Dimen, OldApprox, ApproxEigenval);
    Div_Vec_Const(Dimen, OldApprox, ApproxEigenval);
    while (Iter < MaxIter) and not Found and (Error = 0) do
    begin
      Iter := Succ(Iter);
      GetNewApprox(Dimen, Mat, OldApprox, NewApprox, Iter, Error);
      if Error = 0 then
      begin
        FindLargest(Dimen, NewApprox, ApproxEigenval);
        Div_Vec_Const(Dimen, NewApprox, ApproxEigenval);
        TestForConvergence(Dimen, OldApprox, NewApprox, Tolerance, Found);
        {OldApprox := NewApprox;}
        copyTNvector(NewApprox,oldApprox);
      end;
    end; { while }
    if Error = 5 then { Eigenvalue/vector not calculated }
      Eigenvalue := ClosestVal
    else
      begin
        {Eigenvector := OldApprox;}
        copyTNvector(OldApprox, EigenVector);
        Eigenvalue := 1 / ApproxEigenval + ClosestVal;
      end;
    if Iter >= MaxIter then
      Error := 4;
  end;
end; { procedure InversePower }


{----------------------------------------------------------------------------}
{-                                                                          -}
{-     Turbo Pascal Numerical Methods Toolbox                               -}
{-     Copyright (c) 1986, 87 by Borland International, Inc.                -}
{-                                                                          -}
{----------------------------------------------------------------------------}

procedure Wielandt{(Dimen       : integer;
                   Mat          : TNmatrix;
               var GuessVector  : TNvector;
                   MaxEigens    : integer;
                   MaxIter      : integer;
                   Tolerance    : FloatEG;
               var NumEigens    : integer;
               var Eigenvalues  : TNvector;
               var Eigenvectors : TNmatrix;
               var Iter         : TNIntVector;
               var Error        : byte)};

type
  LevelData = record
                Size : integer;
                ZeroPlace : integer;
                X : TNvector;
                QuasiEVecs : TNmatrix;
              end;

  Ptr = ^ QueueItem;

  QueueItem = record
                Info : LevelData;
                Next : Ptr;
              end;

  Queue = record
            Front : Ptr;
            Back : Ptr;
          end;

var
  TransformInfo : Queue;
  Data : LevelData;

procedure InitializeQueue(var TransformInfo : Queue);
begin
  TransformInfo.Front := nil;
  TransformInfo.Back := nil;
end; { procedure InitializeQueue }

procedure InsertQueue(var Data          : LevelData;
                      var TransformInfo : Queue);

{----------------------------------}
{- Input: Data, TransformInfo     -}
{- Output: TransformInfo          -}
{-                                -}
{- Insert Data onto back of Queue -}
{----------------------------------}

var
  NewNode : Ptr;

begin
  New(NewNode);
  NewNode^.Info := Data;
  NewNode^.Next := nil;
  if TransformInfo.Back = nil then
    TransformInfo.Front := NewNode
  else
    TransformInfo.Back^.Next := NewNode;
  TransformInfo.Back := NewNode;
end; { procedure InsertQueue }

procedure RemoveQueue(var Data          : LevelData;
                      var TransformInfo : Queue);

{---------------------------------}
{- Input: TransformInfo          -}
{- Output: Data, TransformInfo   -}
{-                               -}
{- Remove Data from the front    -}
{- of the queue.                 -}
{---------------------------------}

var
  OldNode : Ptr;

begin
  OldNode := TransformInfo.Front;
  TransformInfo.Front := OldNode^.Next;
  Data := OldNode^.Info;
  if TransformInfo.Front = nil then
    TransformInfo.Back := nil;
  Dispose(OldNode);
end; { procedure RemoveQueue }

procedure FindLargest(Dimen : integer;
                  var Vec   : TNvector;
                  var Posit : integer);

{---------------------------------------}
{- Input: Dimen, Vec                   -}
{- Output: Posit                       -}
{-                                     -}
{- This procedure searches Vec for the -}
{- element of largest absolute value.  -}
{- The position of the largest element -}
{- is returned.                        -}
{---------------------------------------}

var
  Term : integer;
  Largest : FloatEG;

begin
  Largest := Vec[1];
  Posit := 1;
  for Term := 2 to Dimen do
    if ABS(Vec[Term]) > ABS(Largest) then
    begin
      Largest := Vec[Term];
      Posit := Term;
    end;
end; { procedure FindLargest }

procedure DivVecConst(Dimen   : integer;
                      Divisor : FloatEG;
                  var Vec     : TNvector;
                  var Result  : TNvector);

{-----------------------------------}
{- Input: Dimen, Divisor, Vec      -}
{- Output: Result                  -}
{-                                 -}
{- Divide a vector by a constant   -}
{-----------------------------------}

var
  Term : integer;

begin
  for Term := 1 to Dimen do
    Result[Term] := Vec[Term] / Divisor;
end; { procedure DivVecConst }

procedure CrossProduct(Dimen  : integer;
                   var Vec1   : TNvector;
                   var Vec2   : TNvector;
                   var Result : TNmatrix);

{------------------------------------------}
{- Input: Dimen, Vec1, Vec2               -}
{- Output: Result                         -}
{-                                        -}
{- Multiply two vectors to yield a matrix -}
{------------------------------------------}

var
  Row, Column : integer;

begin
  for Row := 1 to Dimen do
    for Column := 1 to Dimen do
      Result[Row, Column] := Vec1[Row] * Vec2[Column];
end; { procedure  CrossProduct }

function DotProduct(Dimen : integer;
                var Vec1  : TNvector;
                var Vec2  : TNvector) : FloatEG;

{--------------------------------------------}
{- Input: Dimen, Vec1, Vec2                 -}
{- Output: DotProduct                       -}
{-                                          -}
{- Calculate the dot product of two vectors -}
{--------------------------------------------}

var
  Row : integer;

begin
  Result := 0;
  for Row := 1 to Dimen do
    Result := Result + Vec1[Row] * Vec2[Row];
end; { procedure DotProduct }

{-----------------------------------------------------------------------}

procedure Power(Dimen       : integer;
            var Mat         : TNmatrix;
            var GuessVector : TNvector;
                MaxIter     : integer;
                Tolerance   : FloatEG;
            var Eigenvalue  : FloatEG;
            var Eigenvector : TNvector;
            var Iter        : integer;
            var Error       : byte);

{----------------------------------------------------------------------------}
{-                                                                          -}
{-              Input:  Dimen, Mat, GuessVector, MaxIter, Tolerance         -}
{-             Output:  Eigenvalue, Eigenvector, Iter, Error                -}
{-                                                                          -}
{-            Purpose:  The power method approximates the dominant          -}
{-                      eigenvalue of a matrix.  The dominant               -}
{-                      eigenvalue is the eigenvalue of largest             -}
{-                      absolute magnitude. Given a square matrix Mat       -}
{-                      and an arbitrary vector OldApprox, the vector       -}
{-                      NewApprox is constructed by the matrix              -}
{-                      operation NewApprox = Mat - OldApprox .             -}
{-                      NewApprox is divided by its largest element         -}
{-                      ApproxEigenval, thereby normalizing                 -}
{-                      NewApprox. If NewApprox is the same as              -}
{-                      OldApprox then ApproxEigenval is the dominant       -}
{-                      eigenvalue and NewApprox is the associated          -}
{-                      eigenvector of the matrix Mat. If NewApprox         -}
{-                      is not the same as OldApprox then OldApprox         -}
{-                      is set equal to NewApprox and the operation         -}
{-                      repeats until a solution is reached. Aitken's       -}
{-                      delta-squared acceleration is used to speed         -}
{-                      the convergence from linear to quadratic.           -}
{-                                                                          -}
{- User-defined Types:  TNvector = array[1..TNArraySize] of real;           -}
{-                      TNmatrix = array[1..TNArraySize] of TNvector;       -}
{-                                                                          -}
{-   Global Variables:  Dimen       : integer;  Dimension of the matrix     -}
{-                      Mat         : TNmatrix; The matrix                  -}
{-                      GuessVector : TNvector; An initial guess of an      -}
{-                                              eigenvector                 -}
{-                      MaxIter     : integer;  Max. number of iterations   -}
{-                      Tolerance   : real;     Tolerance in answer         -}
{-                      Eigenvalue  : real;     Eigenvalue of the matrix    -}
{-                      Eigenvector : TNvector; Eigenvector of the matrix   -}
{-                      Iter        : integer;  Number of iterations        -}
{-                      Error       : byte;     Flags if something goes     -}
{-                                              wrong                       -}
{-             Errors:  0: No Errors                                        -}
{-                      1: Dimen < 2                                        -}
{-                      2: Tolerance <= 0                                   -}
{-                      3: MaxIter < 1                                      -}
{-                      4: Iter >= MaxIter                                  -}
{-                                                                          -}
{----------------------------------------------------------------------------}

type
  TNThreeMatrix = array of TNvector;

var
  OldApprox, NewApprox : TNvector;     { Iteration variables }
  ApproxEigenval : FloatEG;               { Iteration variables }
  AitkenVector : TNThreeMatrix;
  Remainder : integer;
  Found : boolean;
  Index : integer;
  Denom : FloatEG;

procedure Initialize(var GuessVector    : TNvector;
                     var Iter           : integer;
                     var OldApprox      : TNvector;
                     var AitkenVector   : TNThreeMatrix;
                     var ApproxEigenval : FloatEG;
                     var Found          : boolean);

{----------------------------------------------------------}
{- Input: GuessVector                                     -}
{- Output: Iter, OldApprox, AitkenVector, ApproxEigenval  -}
{-         Found                                          -}
{-                                                        -}
{- This procedure initializes the variables.  OldApprox   -}
{- is initialized to be the user's input GuessVector.     -}
{----------------------------------------------------------}
var
  i:integer;

begin
  Iter := 0;
  {OldApprox := GuessVector;}
  copyTNvector(GuessVector,OldApprox);
  for i:=0 to 2 do ZeroTNvector(AitkenVector[i]);
  ApproxEigenval := 0;
  Found := false;
end; { procedure Initialize }

procedure TestData(Dimen       : integer;
               var Mat         : TNmatrix;
               var GuessVector : TNvector;
                   Tolerance   : FloatEG;
                   MaxIter     : integer;
               var Eigenvalue  : FloatEG;
               var Eigenvector : TNvector;
               var Found       : boolean;
               var Error       : byte);

{---------------------------------------------------------}
{- Input: Dimen, Mat, GuessVector, Tolerance, MaxIter    -}
{- Output: GuessVector, Eigenvalue, Eigenvector          -}
{-         Found, Error                                  -}
{-                                                       -}
{- This procedure tests the input data for errors        -}
{- If all the elements of the GuessVector are zero, then -}
{- they are all replaced by ones.                        -}
{- If the dimension of the matrix is one, then the       -}
{- eigenvalue is equal to the matrix.                    -}
{---------------------------------------------------------}

var
  Term : integer;
  Sum : FloatEG;

begin
  Error := 0;
  Sum := 0;
  for Term := 1 to Dimen do
    Sum := Sum + Sqr(GuessVector[Term]);
  if Sum < TNNearlyZero then { the GuessVector is the zero vector }
    for Term := 1 to Dimen do
      GuessVector[Term] := 1;
  if Dimen < 1 then
    Error := 1;
  if Tolerance <= 0 then
    Error := 2;
  if MaxIter < 1 then
    Error := 3;
  if Dimen = 1 then
  begin
    Eigenvalue := Mat[1, 1];
    Eigenvector := GuessVector;
    Found := true;
  end;
end; { procedure TestData }

procedure FindLargest(Dimen   : integer;
                  var Vec     : TNvector;
                  var Largest : FloatEG);

{---------------------------------------}
{- Input: Dimen, Vec                   -}
{- Output: Largest                     -}
{-                                     -}
{- This procedure searches Vec for the -}
{- element of largest absolute value.  -}
{---------------------------------------}

var
  Term : integer;

begin
  Largest := Vec[Dimen];
  for Term := Dimen - 1 downto 1 do
    if ABS(Vec[Term]) > ABS(Largest) then
      Largest := Vec[Term];
end; { procedure FindLargest }

procedure Div_Vec_Const(Dimen   : integer;
                    var Vec     : TNvector;
                        Divisor : FloatEG);

{----------------------------------------------}
{- Input: Dimen, Vec, Divisor                 -}
{- Output: Vec                                -}
{-                                            -}
{- This procedure divides each element        -}
{- of the vector Vec by the constant Divisor. -}
{----------------------------------------------}

var
  Term : integer;

begin
  for Term := 1 to Dimen do
    Vec[Term] := Vec[Term] / Divisor;
end; { procedure Div_Vec_Const }

procedure Mult_Mat_Vec(Dimen  : integer;
                   var Mat    : TNmatrix;
                   var Vec    : TNvector;
                   var Result : TNvector);

{----------------------------------------}
{- Input: Dimen, Mat, Vec               -}
{- Output: Result                       -}
{-                                      -}
{- Multiply a vector by a square matrix -}
{----------------------------------------}

var
  Row, Column : integer;
  Entry : FloatEG;

begin
  for Row := 1 to Dimen do
  begin
    Entry := 0;
    for Column := 1 to Dimen do
      Entry := Entry + Mat[Row, Column] * Vec[Column];
    Result[Row] := Entry;
  end;
end; { procedure Mult_Mat_Vec }


procedure TestForConvergence(Dimen     : integer;
                         var OldApprox : TNvector;
                         var NewApprox : TNvector;
                             Tolerance : FloatEG;
                         var Found     : boolean);

{-----------------------------------------------------------------}
{- Input: Dimen, OldApprox, NewApprox, Tolerance,                -}
{- Output: Found                                                 -}
{-                                                               -}
{- This procedure determines if the iterations have converged.   -}
{- on a solution.  If the absolute difference in EACH element of -}
{- the eigenvector between the last two iterations (i.e. between -}
{- OldApprox and NewApprox) is less than Tolerance, then         -}
{- convergence has occurred and Found = true.  Otherwise,        -}
{- Found = false.                                                -}
{-----------------------------------------------------------------}

var
  Index : integer;

begin
  Index := 0;
  Found := true;
  while (Found = true) and (Index < Dimen) do
  begin
    Index := Succ(Index);
    if ABS(OldApprox[Index] - NewApprox[Index]) > Tolerance then
      Found := false;
  end;
end; { procedure TestForConvergence }

begin  { procedure Power }
  Initialize(GuessVector, Iter, OldApprox, AitkenVector,
             ApproxEigenval, Found);
  TestData(Dimen, Mat, GuessVector, Tolerance, MaxIter,
           Eigenvalue, Eigenvector, Found, Error);
  if (Error = 0) and (Found = false) then
  begin
    FindLargest(Dimen, OldApprox, ApproxEigenval);
    Div_Vec_Const(Dimen, OldApprox, ApproxEigenval);
    while (Iter < MaxIter) and not Found do
    begin
      Iter := Succ(Iter);
      Remainder := Iter MOD 3;
      if Remainder = 0 then { Use Aitken's acceleration algorithm to  }
                            { generate the next iterate approximation }
      begin
        {OldApprox := AitkenVector[0];}
        copyTNvector(AitkenVector[0],oldApprox);
        for Index := 1 to Dimen do
        begin
          Denom := AitkenVector[2, Index] - 2 * AitkenVector[1, Index] +
                   AitkenVector[0, Index];
          if ABS(Denom) > TNNearlyZero then
            OldApprox[Index] := AitkenVector[0, Index] -
                                Sqr(AitkenVector[1, Index] -
                                AitkenVector[0, Index]) / Denom;
        end;
      end;
      { Use the power method to generate }
      { the next iterate approximation   }
      Mult_Mat_Vec(Dimen, Mat, OldApprox, NewApprox);
      FindLargest(Dimen, NewApprox, ApproxEigenval);
      if ABS(ApproxEigenval) < TNNearlyZero then
        begin
          ApproxEigenval := 0;
          Found := true;
        end
      else
        begin
          Div_Vec_Const(Dimen, NewApprox, ApproxEigenval);
          TestForConvergence(Dimen, OldApprox, NewApprox, Tolerance, Found);
          {OldApprox := NewApprox;}
          copyTNvector(NewApprox,oldApprox);
        end;
      {AitkenVector[Remainder] := NewApprox;}
      copyTNvector(NewApprox,AitkenVector[Remainder]);
    end; { while }
    {Eigenvector := OldApprox;}
    copyTNvector(OldApprox,eigenVector);
    Eigenvalue := ApproxEigenval;
    if Iter >= MaxIter then
      Error := 4;
  end;
end; { procedure Power }
{-----------------------------------------------------------------------}

procedure TestDataAndInitialize(Dimen         : integer;
                            var Mat           : TNmatrix;
                            var GuessVector   : TNvector;
                                Tolerance     : FloatEG;
                                MaxEigens     : integer;
                                MaxIter       : integer;
                            var NumEigens     : integer;
                            var Eigenvalue    : TNvector;
                            var Eigenvector   : TNmatrix;
                            var TransformInfo : Queue;
                            var Iter          : TNIntVector;
                            var Data          : LevelData;
                            var Error         : byte);

{--------------------------------------------------}
{- Input: Dimen, GuessVector, Tolerance,          -}
{-        MaxEigens, MaxIter                      -}
{- Output: GuessVector, NumEigens, Eigenvalue,    -}
{-         Eigenvector, TransformInfo, Iter,      -}
{-         Data, Error                            -}
{-                                                -}
{- This procedure initializes variable and tests  -}
{- the input data for errors.                     -}
{- If all the elements of the GuessVector are     -}
{- zero, then they are all replaced by ones.      -}
{- If the dimension of the matrix is one, then    -}
{- the eigenvalue is equal to the matrix.         -}
{--------------------------------------------------}

var
  Term : integer;
  Sum : FloatEG;

begin
  Error := 0;
  Sum := 0;
  for Term := 1 to Dimen do
    Sum := Sum + Sqr(GuessVector[Term]);
  if Sum < TNNearlyZero then  { The GuessVector is the zero vector  }
                              { change all the elements to one.     }
    for Term := 1 to Dimen do
      GuessVector[Term] := 1;
  if Tolerance <= 0 then
    Error := 2;
  if MaxIter < 1 then
    Error := 3;
  if (MaxEigens < 1) or (MaxEigens > Dimen) then
    Error := 4;
  if Dimen < 1 then
    Error := 1;
  if Error = 0 then
  begin
    InitializeQueue(TransformInfo);
    ZeroTNintVector(Iter);
    FillChar(Data, SizeOf(Data), 0);
    NumEigens := 0;
  end;
  if Dimen = 1 then
  begin
    Eigenvalue[1] := Mat[1, 1];
    Eigenvector[1, 1] := 1;
    NumEigens := 1;
  end;
end; { procedure TestDataAndInitialize }

procedure ConstructX(Size        : integer;
                 var Mat         : TNmatrix;
                 var Eigenvector : TNvector;
                 var ZeroPlace   : integer;
                 var X           : TNvector);

{---------------------------------------------------------}
{- Input: Size, Mat, Eigenvector                         -}
{- Output: ZeroPlace, X                                  -}
{-                                                       -}
{- This procedure creates the vector X.  The formula is: -}
{-   X := Mat[ZeroPlace]/Eigenvector[ZeroPlace]          -}
{- where ZeroPlace is the Index of the largest element   -}
{- in Eigenvector.                                       -}
{---------------------------------------------------------}

begin
  { ZeroPlace is the position of the largest element. }
  FindLargest(Size, Eigenvector, ZeroPlace);
  DivVecConst(Size, Eigenvector[ZeroPlace], Mat[ZeroPlace], X);
end; { procedure ConstructX }

procedure MakeMatrix(Size        : integer;
                 var Mat         : TNmatrix;
                 var Eigenvector : TNvector;
                     ZeroPlace   : integer;
                 var X           : TNvector);

{-----------------------------------------------------------}
{- Input: Size, Mat, Eigenvector, ZeroPlace, X             -}
{- Output: Mat                                             -}
{-                                                         -}
{- This procedure changes the matrix Mat.  The formula is  -}
{-    Mat := Mat - (Eigenvector # X)                       -}
{- where the # represents a cross product.                 -}
{- Then the ZeroPlace row and column are deleted from the  -}
{- matrix.                                                 -}
{-----------------------------------------------------------}

var
  Row, Column : integer;
  TempMatrix : TNmatrix;

begin
  CrossProduct(Size, Eigenvector, X, TempMatrix);
  for Row := 1 to ZeroPlace - 1 do
    for Column := 1 to ZeroPlace - 1 do
      Mat[Row, Column] := Mat[Row, Column] - TempMatrix[Row, Column];
  for Row := 1 to ZeroPlace - 1 do
    for Column := ZeroPlace to Size - 1 do
      Mat[Row, Column] := Mat[Row, Column + 1] - TempMatrix[Row, Column + 1];
  for Row := ZeroPlace to Size - 1 do
    for Column := 1 to ZeroPlace - 1 do
      Mat[Row, Column] := Mat[Row + 1, Column] - TempMatrix[Row + 1, Column];
  for Row := ZeroPlace to Size - 1 do
    for Column := ZeroPlace to Size - 1 do
      Mat[Row, Column] := Mat[Row + 1, Column + 1]
                          - TempMatrix[Row + 1, Column + 1];
end; { procedure MakeMatrix }

procedure InsertZero(Size        : integer;
                 var Eigenvector : TNvector;
                     ZeroPlace   : integer;
                 var TempVector  : TNvector);

{----------------------------------------------------}
{- Input: Size, Eigenvector, ZeroPlace              -}
{- Output: TempVector                               -}
{-                                                  -}
{- This procedure inserts a zero into the ZeroPlace -}
{- element of Eigenvector.  The resulting vector is -}
{- returned in TempVector.                          -}
{----------------------------------------------------}

var
  Index : integer;

begin
  TempVector := Eigenvector;
  for Index := Size - 1 downto ZeroPlace do
    TempVector[Index + 1] := Eigenvector[Index];
  TempVector[ZeroPlace] := 0;
end; { procedure InsertZero }

procedure MakeNewVec(Size         : integer;
                     Eigenval1    : FloatEG;
                     Eigenval2    : FloatEG;
                 var TempVec      : TNvector;
                 var X            : TNvector;
                 var OldQuasiEVec : TNvector;
                 var NewQuasiEVec : TNvector);

{---------------------------------------------------------------}
{- Input: Size, Eigenval1, Eigenval2, TempVec, X, OldQuasiEVec -}
{- Output: NewQuasiEVec                                        -}
{-                                                             -}
{- This procedure transforms the TempVec into NewQuasiEVec.    -}
{- The formula is:                                             -}
{-   NewQuasiEVec = (Eigenval1 - Eigenval2) - TempVec          -}
{-                  + X,TempVec - OldQuasiEVec                 -}
{- where X,TempVec is the dot product of X and TempVec.        -}
{---------------------------------------------------------------}

var
  Difference, Multiplier : FloatEG;
  Index : integer;

begin
  Difference := Eigenval1 - Eigenval2;
  Multiplier := DotProduct(Size, X, TempVec);
  for Index := 1 to Size do
    NewQuasiEVec[Index] := Difference * TempVec[Index]
                           + Multiplier * OldQuasiEVec[Index];
end; { procedure MakeNewVec }

procedure TransformThroughLevels(NumEigens     : integer;
                             var Data          : LevelData;
                             var TransformInfo : Queue;
                             var Eigenvalues   : TNvector);
var
  Index : integer;             { A counter }
  Data1, Data2 : LevelData;    { Data1 is data from a level one }
                               { higher than Data2.  Information }
                               { from Data2 is transformed for Data1 }
  TempVec : TNvector;          { A temporary vector used in calculations }

begin
  Data2 := Data;
  for Index := NumEigens - 1 downto 1 do
  begin
    RemoveQueue(Data1, TransformInfo);
    InsertZero(Data1.Size, Data2.QuasiEVecs[NumEigens],
               Data1.ZeroPlace, TempVec);
    MakeNewVec(Data1.Size, Eigenvalues[NumEigens], Eigenvalues[Index],
               TempVec, Data1.X, Data1.QuasiEVecs[Index],
               Data1.QuasiEVecs[NumEigens]);
    InsertQueue(Data2, TransformInfo);
    Data2 := Data1;
  end;
  InsertQueue(Data2, TransformInfo);
end; { procedure TransformThroughLevels }

procedure FindLastTwoEigens(Dimen         : integer;
                        var NumEigens     : integer;
                        var Mat           : TNmatrix;
                        var Eigenvalues   : TNvector;
                        var Data          : LevelData;
                        var TransformInfo : Queue;
                        var Error         : byte);

{--------------------------------------------------------------------}
{- Input: Dimen, NumEigens, Mat, Eigenvalues                        -}
{- Output: NumEigens, Data, TransformInfo                           -}
{-                                                                  -}
{- This procedure approximates the last eigenvalue/vector.  The     -}
{- matrix Mat will be a two by two.  The last eigenvalue will       -}
{- be the trace of the matrix Mat minus the second to last          -}
{- eigenvalue (since the sum of the eigenvalues of a matrix is      -}
{- the trace). The first element of the eigenvector is arbitrarily  -}
{- made 1 (eigenvectors are only defined to a multiplicative        -}
{- constant) and the second element is simply computed.  This       -}
{- eigenvector of Mat is then transformed to an eigenvector of the  -}
{- original matrix through the procedure TransformThroughLevels.    -}
{--------------------------------------------------------------------}

var
  A, B, C : FloatEG;
  Root1, Root2 : FloatEG;

procedure QuadraticFormula(A     : FloatEG;
                           B     : FloatEG;
                           C     : FloatEG;
                       var Root1 : FloatEG;
                       var Root2 : FloatEG;
                       var Error : byte);

var
  Discrim : FloatEG;

begin
  Discrim := Sqr(B) - 4*A*C;
  if Discrim < -TNNearlyZero then
    Error := 6       { No real roots }
  else
    if ABS(Discrim) < TNNearlyZero then  { Identical roots }
      begin
        Root1 := -B / (2 * A);
        Root2 := Root1;
      end
    else
      begin
        Root1 := (-B - Sqrt(Discrim)) / (2 * A);
        Root2 := -B / A - Root1;
      end;
end; { procedure QuadraticFactor }

begin  { procedure FindLastTwoEigens }
  if (ABS(Mat[1, 2]) < TNNearlyZero) or (ABS(Mat[2, 1]) < TNNearlyZero) then
    { zero on the off diagonal }
    with Data do
    begin
      NumEigens := Dimen - 1;
      Size := 2;
      if (ABS(Mat[1, 2]) < TNNearlyZero) and
         (ABS(Mat[2, 1]) < TNNearlyZero) then
        { Zero's on both off diagonals; distinct }
        { eigenvectors; possibly distinct eigenvalues }
        begin
          Eigenvalues[NumEigens] := Mat[2, 2];
          QuasiEVecs[NumEigens, 1] := 0;
          QuasiEVecs[NumEigens, 2] := 1;
          Eigenvalues[NumEigens + 1] := Mat[1, 1];
          QuasiEVecs[NumEigens + 1, 1] := 1;
          QuasiEVecs[NumEigens + 1, 2] := 0;
        end
      else
        { Only one zero on off diagonal }
        if ABS(Mat[1, 2]) < TNNearlyZero then
          begin
            Eigenvalues[NumEigens] := Mat[2, 2];
            QuasiEVecs[NumEigens, 1] := 0;
            QuasiEVecs[NumEigens, 2] := 1;
            Eigenvalues[NumEigens + 1] := Mat[1, 1];
            if ABS(Mat[1, 1] - Mat[2, 2]) < TNNearlyZero then
              { Degenerate eigenvalues/vectors }
              QuasiEVecs[NumEigens + 1] := QuasiEVecs[NumEigens]
            else
              { Distinct eigenvalues/vectors }
              begin
                QuasiEVecs[NumEigens + 1, 1] := 1;
                QuasiEVecs[NumEigens + 1, 2] := Mat[2, 1] /
                                                (Mat[1, 1] - Mat[2, 2]);
              end;
          end
        else
          { ABS(Mat[2, 1]) < TNNearlyZero }
          begin
            Eigenvalues[NumEigens] := Mat[1, 1];
            QuasiEVecs[NumEigens, 1] := 1;
            QuasiEVecs[NumEigens, 2] := 0;
            Eigenvalues[NumEigens + 1] := Mat[2, 2];
            if ABS(Mat[1, 1] - Mat[2, 2]) < TNNearlyZero then
              { Degenerate eigenvalues/vectors }
              QuasiEVecs[NumEigens + 1] := QuasiEVecs[NumEigens]
            else
              { Distinct eigenvalues/vectors }
              begin
                QuasiEVecs[NumEigens + 1, 2] := 1;
                QuasiEVecs[NumEigens + 1, 1] := Mat[1, 2] / (Mat[2, 2] - Mat[1, 1]);
              end;
          end;
      ConstructX(Size, Mat, QuasiEVecs[NumEigens], ZeroPlace, X);
      TransformThroughLevels(NumEigens, Data, TransformInfo, Eigenvalues);
      NumEigens := Dimen;
      TransformThroughLevels(NumEigens, Data, TransformInfo, Eigenvalues);
    end
  else   { no zero's on the off diagonal }
    begin
      A := 1;
      B := -(Mat[1, 1] + Mat[2, 2]);
      C := Mat[1, 1] * Mat[2, 2] - Mat[1, 2] * Mat[2, 1];
      QuadraticFormula(A, B, C, Root1, Root2, Error);
      if Error = 0 then
      with Data do
      begin
        NumEigens := Dimen - 1;
        Size := 2;
        Eigenvalues[NumEigens] := Root1;
        QuasiEVecs[NumEigens, 1] := 1;
        QuasiEVecs[NumEigens, 2] := (Eigenvalues[NumEigens]
                                    - Mat[1, 1]) / Mat[1, 2];
        Eigenvalues[NumEigens + 1] := Root2;
        QuasiEVecs[NumEigens + 1, 1] := 1;
        QuasiEVecs[NumEigens + 1, 2] := (Eigenvalues[NumEigens + 1]
                                        - Mat[1, 1]) / Mat[1, 2];
        ConstructX(Size, Mat, QuasiEVecs[NumEigens], ZeroPlace, X);
        TransformThroughLevels(NumEigens, Data, TransformInfo, Eigenvalues);
        NumEigens := Dimen;
        TransformThroughLevels(NumEigens, Data, TransformInfo, Eigenvalues);
      end; { with }
    end;
end; { procedure FindLastTwoEigens }

procedure NormalizeEigenvectors(Dimen         : integer;
                                NumEigens     : integer;
                            var TransformInfo : Queue;
                            var Eigenvectors  : TNmatrix);

{--------------------------------------------------------}
{- Input: Dimen, NumEigens, TransformInfo, Eigenvectors -}
{- Output: Eigenvectors                                 -}
{-                                                      -}
{- This procedure normalizes the eigenvectors so that   -}
{- the element of largest absolute value equals 1.      -}
{--------------------------------------------------------}

var
  Index : integer;
  Data : LevelData;
  Posit : integer;

begin
  { The eigenvectors are the }
  { QuasiEVecs of the last Data }
  { removed from the queue. }
  for Index := 1 to NumEigens do
    RemoveQueue(Data, TransformInfo);
  Eigenvectors := Data.QuasiEVecs;
  for Index := 1 to NumEigens do
  begin
    FindLargest(Dimen, Eigenvectors[Index], Posit);
    if ABS(Eigenvectors[Index, Posit]) > TNNearlyZero then
      DivVecConst(Dimen, Eigenvectors[Index, Posit],
                  Eigenvectors[Index], Eigenvectors[Index]);
  end;
end; { procedure NormalizeEigenvectors }

begin { procedure Wielandt }
  TestDataAndInitialize(Dimen, Mat, GuessVector, Tolerance,
                        MaxEigens, MaxIter, NumEigens, Eigenvalues,
                        Eigenvectors, TransformInfo, Iter, Data, Error);
  if (Error = 0) and (Dimen > 1) then
  begin
    with Data do
    while (NumEigens < Dimen - 2) and (NumEigens < MaxEigens) and (Error = 0) do
    begin
      NumEigens := Succ(NumEigens);
      Size := Dimen - (NumEigens - 1);
      Power(Size, Mat, GuessVector, MaxIter,Tolerance, Eigenvalues[NumEigens],
            QuasiEVecs[NumEigens], Iter[NumEigens], Error);
      ConstructX(Size, Mat, QuasiEVecs[NumEigens], ZeroPlace, X);
      if Size > 2 then
        MakeMatrix(Size, Mat, QuasiEVecs[NumEigens], ZeroPlace, X);
      TransformThroughLevels(NumEigens, Data, TransformInfo, Eigenvalues);
    end; { while }
    if Error > 0 then
      Error := 5     { The Error returned from Power means an }
                     { eigen wasn't calculated, but the Error }
                     { code may not be 5.                     }
    else
      if (NumEigens = Dimen - 2) and (NumEigens < MaxEigens) then
        { Then NumEigens = Dimen - 2 and the      }
        { last two eigenvectors can be calculated }
        FindLastTwoEigens(Dimen, NumEigens, Mat, Eigenvalues,
                          Data, TransformInfo, Error);
    NormalizeEigenvectors(Dimen, NumEigens, TransformInfo, Eigenvectors);
  end
end; { procedure Wielandt }

procedure Jacobi{(Dimen       : integer;
                 Mat          : TNmatrix;
                 MaxIter      : integer;
                 Tolerance    : FloatEG;
             var Eigenvalues  : TNvector;
             var Eigenvectors : TNmatrix;
             var Iter         : integer;
             var Error        : byte)};

var
  Row, Column, Diag : integer;
  SinTheta, CosTheta : FloatEG;
  SumSquareDiag : FloatEG;
  Done : boolean;

procedure TestData(Dimen     : integer;
               var Mat       : TNmatrix;
                   MaxIter   : integer;
                   Tolerance : FloatEG;
               var Error     : byte);

{---------------------------------------------------}
{- Input: Dimen, Mat, MaxIter, Tolerance           -}
{- Output: Error                                   -}
{-                                                 -}
{- This procedure tests the input data for errors. -}
{---------------------------------------------------}

var
  Row, Column : integer;

begin
  Error := 0;
  if Dimen < 1 then
    Error := 1;
  if Tolerance <= TNNearlyZero then
    Error := 2;
  if MaxIter < 1 then
    Error := 3;
  if Error = 0 then
    for Row := 1 to Dimen - 1 do
      for Column := Row + 1 to Dimen do
        if ABS(Mat[Row, Column] - Mat[Column, Row]) > TNNearlyZero then
          Error := 4;  { Matrix not symmetric }
end; { procedure TestData }

procedure Initialize(Dimen        : integer;
                 var Iter         : integer;
                 var Eigenvectors : TNmatrix);

{--------------------------------------------}
{- Input: Dimen                             -}
{- Output: Iter, Eigenvectors               -}
{-                                          -}
{- This procedure initializes Iter to zero  -}
{- and Eigenvectors to the identity matrix. -}
{--------------------------------------------}

var
  Diag : integer;

begin
  Iter := 0;
  ZeroTNmatrix(Eigenvectors);
  for Diag := 1 to Dimen do
    Eigenvectors[Diag, Diag] := 1;
end; { procedure Initialize }

procedure CalculateRotation(RowRow   : FloatEG;
                            RowCol   : FloatEG;
                            ColCol   : FloatEG;
                        var SinTheta : FloatEG;
                        var CosTheta : FloatEG);


{-----------------------------------------------------------}
{- Input: RowRow, RowCol, ColCol                           -}
{- Output: SinTheta, CosTheta                              -}
{-                                                         -}
{- This procedure calculates the sine and cosine of the    -}
{- angle Theta through which to rotate the matrix Mat.     -}
{- Given the tangent of 2-Theta, the tangent of Theta can  -}
{- be calculated with the quadratic formula.  The cosine   -}
{- and sine are easily calculable from the tangent. The    -}
{- rotation must be such that the Row, Column element is   -}
{- zero. RowRow is the Row,Row element; RowCol is the      -}
{- Row,Column element; ColCol is the Column,Column element -}
{- of Mat.                                                 -}
{-----------------------------------------------------------}

var
  TangentTwoTheta, TangentTheta, Dummy : FloatEG;

begin
  if ABS(RowRow - ColCol) > TNNearlyZero then
    begin
      TangentTwoTheta := (RowRow - ColCol) / (2 * RowCol);
      Dummy := Sqrt(Sqr(TangentTwoTheta) + 1);
      if TangentTwoTheta < 0 then  { Choose the root nearer to zero }
        TangentTheta := -TangentTwoTheta - Dummy
      else
        TangentTheta := -TangentTwoTheta + Dummy;
      CosTheta := 1 / Sqrt(1 + Sqr(TangentTheta));
      SinTheta := CosTheta * TangentTheta;
    end
  else
    begin
      CosTheta := Sqrt(1/2);
      if RowCol < 0 then
        SinTheta := -Sqrt(1/2)
      else
        SinTheta := Sqrt(1/2);
    end;
end; { procedure CalculateRotation }

procedure RotateMatrix(Dimen    : integer;
                       SinTheta : FloatEG;
                       CosTheta : FloatEG;
                       Row      : integer;
                       Col      : integer;
                   var Mat      : TNmatrix);

{--------------------------------------------------------------}
{- Input: Dimen, SinTheta, CosTheta, Row, Col                 -}
{- Output: Mat                                                -}
{-                                                            -}
{- This procedure rotates the matrix Mat through an angle     -}
{- Theta.  The rotation matrix is the identity matrix execept -}
{- for the Row,Row; Row,Col; Col,Col; and Col,Row elements.   -}
{- The rotation will make the Row,Col element of Mat          -}
{- to be zero.                                                -}
{--------------------------------------------------------------}

var
  CosSqr, SinSqr, SinCos : FloatEG;
  MatRowRow, MatColCol, MatRowCol, MatRowIndex, MatColIndex : FloatEG;

  Index : integer;

begin
  CosSqr := Sqr(CosTheta);
  SinSqr := Sqr(SinTheta);
  SinCos := SinTheta * CosTheta;
  MatRowRow := Mat[Row, Row] * CosSqr + 2 * Mat[Row, Col] * SinCos +
               Mat[Col, Col] * SinSqr;
  MatColCol := Mat[Row, Row] * SinSqr - 2 * Mat[Row, Col] * SinCos +
               Mat[Col, Col] * CosSqr;
  MatRowCol := (Mat[Col, Col] - Mat[Row, Row]) * SinCos +
               Mat[Row, Col] * (CosSqr - SinSqr);

  for Index := 1 to Dimen do
    if not(Index in [Row, Col]) then
    begin
      MatRowIndex := Mat[Row, Index] * CosTheta +
                     Mat[Col, Index] * SinTheta;
      MatColIndex := -Mat[Row, Index] * SinTheta +
                      Mat[Col, Index] * CosTheta;
      Mat[Row, Index] := MatRowIndex;
      Mat[Index, Row] := MatRowIndex;
      Mat[Col, Index] := MatColIndex;
      Mat[Index, Col] := MatColIndex;
    end;
  Mat[Row, Row] := MatRowRow;
  Mat[Col, Col] := MatColCol;
  Mat[Row, Col] := MatRowCol;
  Mat[Col, Row] := MatRowCol;
end; { procedure RotateMatrix }

procedure RotateEigenvectors(Dimen        : integer;
                             SinTheta     : FloatEG;
                             CosTheta     : FloatEG;
                             Row          : integer;
                             Col          : integer;
                         var Eigenvectors : TNmatrix);

{--------------------------------------------------------------}
{- Input: Dimen, SinTheta, CosTheta, Row, Col                 -}
{- Output: Eigenvectors                                       -}
{-                                                            -}
{- This procedure rotates the Eigenvectors matrix through an  -}
{- angle Theta.  The rotation matrix is the identity matrix   -}
{- except for the Row,Row; Row,Col; Col,Col; and Col,Row      -}
{- elements.  The Eigenvectors matrix will be the product of  -}
{- all the rotation matrices which operate on Mat.            -}
{--------------------------------------------------------------}

var
  EigenvectorsRowIndex, EigenvectorsColIndex : FloatEG;

  Index : integer;

begin
  { Transform eigenvector matrix }
  for Index := 1 to  Dimen do
  begin
    EigenvectorsRowIndex := CosTheta * Eigenvectors[Row, Index] +
                            SinTheta * Eigenvectors[Col, Index];
    EigenvectorsColIndex := -SinTheta * Eigenvectors[Row, Index] +
                             CosTheta * Eigenvectors[Col, Index];
    Eigenvectors[Row, Index] := EigenvectorsRowIndex;
    Eigenvectors[Col, Index] := EigenvectorsColIndex;
  end;
end; { procedure RotateEigenvectors }

procedure NormalizeEigenvectors(Dimen        : integer;
                            var Eigenvectors : TNmatrix);

{---------------------------------------------------}
{- Input: Dimen, Eigenvectors                      -}
{- Output: Eigenvectors                            -}
{-                                                 -}
{- This procedure normalizes the eigenvectors so   -}
{- that the largest element in each vector is one. -}
{---------------------------------------------------}

var
  Row : integer;
  Largest : FloatEG;

procedure FindLargest(Dimen       : integer;
                  var Eigenvector : TNvector;
                  var Largest     : FloatEG);

{---------------------------------------}
{- Input: Dimen, Eigenvectors          -}
{- Output: Largest                     -}
{-                                     -}
{- This procedure returns the value of -}
{- the largest element of the vector.  -}
{---------------------------------------}

var
  Term : integer;

begin
  Largest := Eigenvector[1];
  for Term := 2 to Dimen do
    if ABS(Eigenvector[Term]) > ABS(Largest) then
      Largest := Eigenvector[Term];
end; { procedure FindLargest }

procedure DivVecConst(Dimen       : integer;
                  var ChangingRow : TNvector;
                      Divisor     : FloatEG);

{--------------------------------------------------------}
{- Input: Dimen, ChangingRow                            -}
{- Output: Divisor                                      -}
{-                                                      -}
{- elementary row operation - dividing by a constant    -}
{--------------------------------------------------------}

var
  Term : integer;

begin
  for Term := 1 to Dimen do
    ChangingRow[Term] := ChangingRow[Term] / Divisor;
end; { procedure DivVecConst }

begin { procedure NormalizeEigenvectors }
  for Row := 1 to Dimen do
  begin
    FindLargest(Dimen, Eigenvectors[Row], Largest);
    DivVecConst(Dimen, Eigenvectors[Row], Largest);
  end;
end; { procedure NormalizeEigenvectors }

begin { procedure Jacobi }
  TestData(Dimen, Mat, MaxIter, Tolerance, Error);
  if Error = 0 then
  begin
    Initialize(Dimen, Iter, Eigenvectors);
    repeat
      Iter := Succ(Iter);
      SumSquareDiag := 0;
      for Diag := 1 to Dimen do
        SumSquareDiag := SumSquareDiag + Sqr(Mat[Diag, Diag]);
      Done := true;
      for Row := 1 to Dimen - 1  do
        for Column := Row + 1 to Dimen do
          if ABS(Mat[Row, Column]) > Tolerance * SumSquareDiag then
          begin
            Done := false;
            CalculateRotation(Mat[Row, Row], Mat[Row, Column],
                              Mat[Column, Column], SinTheta, CosTheta);
            RotateMatrix(Dimen, SinTheta, CosTheta, Row, Column, Mat);
            RotateEigenvectors(Dimen, SinTheta, CosTheta, Row, Column,
                               Eigenvectors);
          end;
    until Done or (Iter > MaxIter);
    for Diag := 1 to Dimen do
      Eigenvalues[Diag] := Mat[Diag, Diag];
    NormalizeEigenvectors(Dimen, Eigenvectors);
    if Iter > MaxIter then
      Error := 5
  end;
end; { procedure Jacobi }


end.
