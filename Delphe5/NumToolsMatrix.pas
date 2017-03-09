unit NumToolsMatrix;

// N'est pas utilisée dans Elphy

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,dtf0,tbe0;


const
  TNNearlyZero = 1E-100;

type
  TNvector = typeDataB;
  TNmatrix = TdataTbB;

procedure Determinant(Data   : TNmatrix; var Det    : Float; var Error  : byte);

procedure Gaussian_Elimination(Coefficients : TNmatrix;
                               Constants    : TNvector;
                               Solution     : TNvector;
                           var Error        : byte);


procedure Gauss_Seidel(Finit:boolean;
                       Coefficients : TNmatrix;
                       Constants    : TNvector;
                       Tol          : Float;
                       MaxIter      : integer;
                   var Solution     : TNvector;
                   var Iter         : integer;
                   var Error        : byte);

procedure Inverse( Data   : TNmatrix;
                   Inv    : TNmatrix;
              var Error  : byte);

implementation


procedure Determinant(Data   : TNmatrix; var Det    : Float; var Error  : byte);
var
  Dimen : integer;

procedure Initial;
begin
  Error := 0;
  if Dimen < 1 then Error := 1
  else
  if Dimen = 1 then Det := Data[1, 1];
end;


function Deter(Dimen : integer; var Data  : TNmatrix) : Float;
{-------------------------------------------------------}
{- Input: Dimen, Data                                  -}
{- Output: Deter                                       -}
{-                                                     -}
{- Function returns the determinant of the Data matrix -}
{-------------------------------------------------------}

var
  PartialDeter, Multiplier : Float;
  Row, ReferenceRow : integer;
  DetEqualsZero : boolean;

procedure Pivot(Dimen         : integer;
                ReferenceRow  : integer;
            var Data          : TNmatrix;
            var PartialDeter  : Float;
            var DetEqualsZero : boolean);

{------------------------------------------------------------}
{- Input: Dimen, ReferenceRow, Data, PartialDeter           -}
{- Output: Data, PartialDeter, DetEqualsZero                -}
{-                                                          -}
{- This procedure searches the ReferenceRow column of the   -}
{- matrix Data for the first non-zero element below the     -}
{- diagonal. If it finds one, then the procedure switches   -}
{- rows so that the non-zero element is on the diagonal.    -}
{- Switching rows changes the determinant by a factor of    -}
{- -1; this change is returned in PartialDeter.             -}
{- If it doesn't find one, the matrix is singular and the   -}
{- Determinant is zero (DetEqualsZero = true is returned).  -}
{------------------------------------------------------------}

var
  NewRow : integer;

begin
  DetEqualsZero := true;
  NewRow := ReferenceRow;
  while DetEqualsZero and (NewRow < Dimen) do  { Try to find a row  }
                                               { with a non-zero    }
                                               { element in this    }
                                               { column             }
  begin
    NewRow := Succ(NewRow);
    if ABS(Data[NewRow, ReferenceRow]) > TNNearlyZero then
    begin
      Data.switchRows(NewRow,ReferenceRow);
      { Switch these two rows }
      DetEqualsZero := false;
      PartialDeter := -PartialDeter;  { Switching rows changes }
                                      { the determinant by a   }
                                      { factor of -1           }
    end;
  end;
end; { procedure Pivot }

begin  { function Deter }
  DetEqualsZero := false;
  PartialDeter := 1;
  ReferenceRow := 0;
  { Make the matrix upper triangular }
  while not(DetEqualsZero) and (ReferenceRow < Dimen - 1) do
  begin
    ReferenceRow := Succ(ReferenceRow);
    { If diagonal element is zero then switch rows }
    if ABS(Data[ReferenceRow, ReferenceRow]) < TNNearlyZero then
      Pivot(Dimen, ReferenceRow, Data, PartialDeter, DetEqualsZero);
    if not(DetEqualsZero) then
      for Row := ReferenceRow + 1 to Dimen do
        { Make the ReferenceRow element of this row zero }
        if ABS(Data[ReferenceRow,Row]) > TNNearlyZero then
        begin
          Multiplier := -Data[ReferenceRow,Row] /
                        Data[ReferenceRow, ReferenceRow];
          Data.multAdd(Multiplier, ReferenceRow, Row);
        end;
    { Multiply the diagonal Term into PartialDeter }
    PartialDeter := PartialDeter * Data[ReferenceRow, ReferenceRow];
  end;
  if DetEqualsZero then
    Deter := 0
  else
    Deter := PartialDeter * Data[Dimen, Dimen];
end; { function Deter }

begin { procedure Determinant }
  Dimen:=data.Imax;
  Initial;
  if Dimen > 1 then
    Det := Deter(Dimen, Data);
end; { procedure Determinant }




procedure Gaussian_Elimination(Coefficients : TNmatrix;
                               Constants    : TNvector;
                               Solution     : TNvector;
                           var Error        : byte);

var
  Dimen       : integer;
procedure Initial(Dimen        : integer;
              var Coefficients : TNmatrix;
              var Constants    : TNvector;
              var Solution     : TNvector;
              var Error        : byte);

{----------------------------------------------------------}
{- Input: Dimen, Coefficients, Constants                  -}
{- Output: Solution, Error                                -}
{-                                                        -}
{- This procedure test for errors in the value of Dimen.  -}
{- This procedure also finds the solution for the         -}
{- trivial case Dimen = 1.                                -}
{----------------------------------------------------------}

begin
  Error := 0;
  if Dimen < 1 then
    Error := 1
  else
    if Dimen = 1 then
      if ABS(Coefficients[1, 1]) < TNNearlyZero then
        Error := 2
      else
        Solution[1] := Constants[1] / Coefficients[1, 1];
end; { procedure Initial }


procedure UpperTriangular(Dimen        : integer;
                      var Coefficients : TNmatrix;
                      var Constants    : TNvector;
                      var Error        : byte);

{-----------------------------------------------------------------}
{- Input: Dimen, Coefficients, Constants                         -}
{- Output: Coefficients, Constants, Error                        -}
{-                                                               -}
{- This procedure makes the coefficient matrix upper triangular. -}
{- The operations which perform this are also performed on the   -}
{- Constants vector.                                             -}
{- If one of the main diagonal elements of the upper triangular  -}
{- matrix is zero, then the Coefficients matrix is singular and  -}
{- no solution exists (Error = 2 is returned).                   -}
{-----------------------------------------------------------------}

var
  Multiplier        : Float;
  Row, ReferenceRow : integer;

procedure Pivot(Dimen        : integer;
                ReferenceRow : integer;
            var Coefficients : TNmatrix;
            var Constants    : TNvector;
            var Error        : byte);

{--------------------------------------------------------------}
{- Input: Dimen, ReferenceRow, Coefficients                   -}
{- Output: Coefficients, Constants, Error                     -}
{-                                                            -}
{- This procedure searches the ReferenceRow column of the     -}
{- Coefficients matrix for the first non-zero element below   -}
{- the diagonal. If it finds one, then the procedure switches -}
{- rows so that the non-zero element is on the diagonal.      -}
{- It also switches the corresponding elements in the         -}
{- Constants vector. If it doesn't find one, the matrix is    -}
{- singular and no solution exists (Error = 2 is returned).   -}
{--------------------------------------------------------------}

var
  NewRow : integer;
  Dummy : Float;

begin
  Error := 2;          { No solution exists }
  NewRow := ReferenceRow;
  while (Error > 0) and (NewRow < Dimen) do    { Try to find a       }
                                               { row with a non-zero }
                                               { diagonal element    }
  begin
    NewRow := Succ(NewRow);
    if ABS(Coefficients[ ReferenceRow,NewRow]) > TNNearlyZero then
    begin
      Coefficients.switchRows(ReferenceRow,NewRow);
      { Switch these two rows }
      Dummy := Constants[NewRow];
      Constants[NewRow] := Constants[ReferenceRow];
      Constants[ReferenceRow] := Dummy;
      Error := 0;    { Solution may exist }
    end;
  end;
end; { procedure Pivot }

begin { procedure UpperTriangular }
  ReferenceRow := 0;
  while (Error = 0) and (ReferenceRow < Dimen - 1) do
  begin
    ReferenceRow := Succ(ReferenceRow);
    { Check to see if the main diagonal element is zero }
    if ABS(Coefficients[ReferenceRow, ReferenceRow]) < TNNearlyZero then
      Pivot(Dimen, ReferenceRow, Coefficients, Constants, Error);
    if Error = 0 then
      for Row := ReferenceRow + 1 to Dimen do
        { Make the ReferenceRow element of this row zero }
        if ABS(Coefficients[ReferenceRow,Row]) > TNNearlyZero then
        begin
          Multiplier := -Coefficients[ReferenceRow,Row] /
                         Coefficients[ReferenceRow,ReferenceRow];
          Coefficients.multAdd(Multiplier,ReferenceRow,Row);
          Constants[Row] := Constants[Row] +
                            Multiplier * Constants[ReferenceRow];
        end;
  end; { while }
  if ABS(Coefficients[Dimen, Dimen]) < TNNearlyZero then
    Error := 2;    { No solution }
end; { procedure UpperTriangular }

procedure BackwardsSub(Dimen        : integer;
                   var Coefficients : TNmatrix;
                   var Constants    : TNvector;
                   var Solution     : TNvector);

{----------------------------------------------------------------}
{- Input: Dimen, Coefficients, Constants                        -}
{- Output: Solution                                             -}
{-                                                              -}
{- This procedure applies backwards substitution to the upper   -}
{- triangular Coefficients matrix and Constants vector. The     -}
{- resulting vector is the solution to the set of equations and -}
{- is returned in the vector Solution.                          -}
{----------------------------------------------------------------}

var
  Term, Row : integer;
  Sum : Float;

begin
  Term := Dimen;
  while Term >= 1 do
  begin
    Sum := 0;
    for Row := Term + 1 to Dimen do
      Sum := Sum + Coefficients[Row,Term] * Solution[Row];
    Solution[Term] := (Constants[Term] - Sum) / Coefficients[Term, Term];
    Term := Pred(Term);
  end;
end; { procedure BackwardsSub }

begin { procedure Gaussian_Elimination }
  Dimen:=coefficients.Imax;
  Initial(Dimen, Coefficients, Constants, Solution, Error);
  if Dimen > 1 then
  begin
    UpperTriangular(Dimen, Coefficients, Constants, Error);
    if Error = 0 then
      BackwardsSub(Dimen, Coefficients, Constants, Solution);
  end;
end; { procedure Gaussian_Elimination }




procedure Gauss_Seidel(Finit:boolean;
                       Coefficients : TNmatrix;
                       Constants    : TNvector;
                       Tol          : Float;
                       MaxIter      : integer;
                   var Solution     : TNvector;
                   var Iter         : integer;
                   var Error        : byte);


var
  i:integer;
  Dimen:integer;
  Guess : TNvector;
  OldApprox, NewApprox : TNvector;


procedure TestForDiagDominance;
var
  Row, Column : integer;
  Sum : Float;

begin
  Row := 0;
  while (Row < Dimen) and (Error < 2) do
  begin
    Row := Succ(Row);
    Sum := 0;
    for Column := 1 to Dimen do
      if Column <> Row then
        Sum := Sum + ABS(Coefficients[ Column,Row]);
    if Sum > ABS(Coefficients[Row, Row]) then
      Error := 1;  { WARNING! convergence may not be }
                   { possible because matrix isn't   }
                   { diagonally dominant             }
    if ABS(Coefficients[Row, Row]) < TNNearlyZero then
      Error := 6;  { Singular matrix - can't be solved  }
                   { by the Gauss-Seidel method.        }
  end; { while }
end; { procedure TestForDiagDominance }

procedure MakeInitialGuess;
var
  Term : integer;
begin
  Guess.raz;
  for Term := 1 to Dimen do
    if ABS(Coefficients[Term, Term]) > TNNearlyZero then
      Guess[Term] := Constants[Term] / Coefficients[Term, Term];
end;

procedure TestForConvergence(Dimen     : integer;
                         var OldApprox : TNvector;
                         var NewApprox : TNvector;
                             Tol       : Float;
                         var Done      : boolean;
                         var Product   : Float;
                         var Error     : byte);

var
  Term : integer;
  PartProd : Float;

begin
  Done := true;
  PartProd := 0;
  for Term := 1 to Dimen do
  begin
    if ABS(OldApprox[Term] - NewApprox[Term]) > ABS(NewApprox[Term] * Tol) then
      Done := false;
    if (ABS(OldApprox[Term]) > TNNearlyZero) and (Error = 1) then
      { This is part of the divergence test }
      PartProd := PartProd + ABS(NewApprox[Term] / OldApprox[Term]);
  end;
  Product := Product * PartProd / Dimen;
  if Product > 1E20 then
    Error := 7   { Sequence is diverging }
end; { procedure TestForConvergence }

procedure Iterate;
var
  i:integer;
  Done : boolean;

  Term, Loop : integer;
  FirstSum, SecondSum, Product : Float;

begin { procedure Iterate }
  Product := 1;
  Done := false;
  Iter := 0;
  for i:=1 to Dimen do NewApprox[i] := Guess[i];
  for i:=1 to Dimen do OldApprox[i] := Guess[i];
  while (Iter < MaxIter) and not(Done) and (Error <= 1) do
  begin
    Iter := Succ(Iter);
    for Term := 1 to Dimen do
    begin
      FirstSum := 0;
      SecondSum := 0;
      for Loop := 1 to Term - 1 do
        FirstSum := FirstSum + Coefficients[Loop,term] * NewApprox[Loop];
      for Loop := Term + 1 to Dimen do
        SecondSum := SecondSum + Coefficients[Loop,term] * OldApprox[Loop];
      NewApprox[Term] := (Constants[Term] - FirstSum - SecondSum) /
                          Coefficients[Term, Term];
    end;
    TestForConvergence(Dimen, OldApprox, NewApprox, Tol, Done, Product, Error);
    for i:=1 to Dimen do OldApprox[i] := NewApprox[i];
     writeln(NewApprox[1]:10:3,NewApprox[2]:10:3,NewApprox[3]:10:3);
  end; { while }
  if (Iter < MaxIter) and (Error = 1) then
    Error := 0;  { The sequence converged, }
                 {  disregard the warning  }
  if (Iter >= MaxIter) and (Error = 1) then
    Error := 1;  { Matrix is not diagonally dominant; }
                 { convergence is probably impossible }
  if (Iter >= MaxIter) and (Error = 0) then
     Error := 2; { Convergence IS possible;   }
                 { more iterations are needed }
  for i:=1 to Dimen do Solution[i] := NewApprox[i];
end; { procedure Iterate }

begin  { procedure Gauss_Seidel }
  Dimen:=coefficients.Imax;
  Guess:=typeDataE.createTab(1,Dimen);
  OldApprox:=typeDataE.createTab(1,Dimen);
  NewApprox:=typeDataE.createTab(1,Dimen);

  Try
    for i:=1 to Dimen do Guess[i]:=solution[i];

    TestForDiagDominance;
    if Error < 2 then
    begin
      if Finit then MakeInitialGuess;
      Iterate;
    end;

  Finally
    Guess.free;
    OldApprox.free;
    NewApprox.free;
  end;
end; { procedure Gauss_Seidel }



procedure Inverse( Data   : TNmatrix;
                   Inv    : TNmatrix;
              var Error  : byte);
var
  Dimen:integer;

procedure Initial(Dimen : integer;
              var Data  : TNmatrix;
              var Inv   : TNmatrix;
              var Error : byte);

{--------------------------------------------------------}
{- Input: Dimen, Data                                   -}
{- Output: Inv, Error                                   -}
{-                                                      -}
{- This procedure test for errors in the value of Dimen -}
{--------------------------------------------------------}

var
  Row : integer;

begin
  Error := 0;
  if Dimen < 1 then
    Error := 1
  else
    begin
      { First make the inverse-to-be the identity matrix }
      Inv.raz;
      for Row := 1 to Dimen do
        Inv[Row, Row] := 1;
      if Dimen = 1 then
        if ABS(Data[1, 1]) < TNNearlyZero then
          Error := 2   { Singular matrix }
        else
          Inv[1, 1] := 1 / Data[1, 1];
    end;
end; { procedure Initial }


procedure Inver(Dimen : integer;
            var Data  : TNmatrix;
            var Inv   : TNmatrix;
            var Error : byte);

{----------------------------------------------------------}
{- Input: Dimen, Data                                     -}
{- Output: Inv, Error                                     -}
{-                                                        -}
{- This procedure computes the inverse of the matrix Data -}
{- and stores it in the matrix Inv.  If the matrix Data   -}
{- is singular, then Error = 2 is returned.               -}
{----------------------------------------------------------}

var
  Divisor, Multiplier : Float;
  Row, ReferenceRow : integer;

procedure Pivot(Dimen        : integer;
                ReferenceRow : integer;
            var Data         : TNmatrix;
            var Inv          : TNmatrix;
            var Error        : byte);

{-------------------------------------------------------------}
{- Input: Dimen, ReferenceRow, Data, Inv                     -}
{- Output: Data, Inv, Error                                  -}
{-                                                           -}
{- This procedure searches the ReferenceRow column of        -}
{- the Data matrix for the first non-zero element below      -}
{- the diagonal. If it finds one, then the procedure         -}
{- switches rows so that the non-zero element is on the      -}
{- diagonal. This same operation is applied to the Inv       -}
{- matrix. If no non-zero element exists in a column, the    -}
{- matrix is singular and no inverse exists.                 -}
{-------------------------------------------------------------}

var
  NewRow : integer;

begin
  Error := 2;  { No inverse exists }
  NewRow := ReferenceRow;
  while (Error > 0) and (NewRow < Dimen) do
  { Try to find a       }
  { row with a non-zero }
  { diagonal element    }
  begin
    NewRow := Succ(NewRow);
    if ABS(Data[ReferenceRow,referenceRow]) > TNNearlyZero then
    begin
      data.switchRows(NewRow,ReferenceRow);
      { Switch these two rows }
      Inv.switchRows(NewRow,ReferenceRow);
      Error := 0;
    end;
  end; { while }
end; { procedure Pivot }

begin { procedure Inver }
  { Make Data matrix upper triangular }
  ReferenceRow := 0;
  while (Error = 0) and (ReferenceRow < Dimen) do
  begin
    ReferenceRow := Succ(ReferenceRow);
    { Check to see if the diagonal element is zero }
    if ABS(Data[ReferenceRow, ReferenceRow]) < TNNearlyZero then
      Pivot(Dimen, ReferenceRow, Data, Inv, Error);
    if Error = 0 then
    begin
      Divisor := Data[ReferenceRow, ReferenceRow];
      Data.RowDiv(Divisor, ReferenceRow);
      Inv.RowDiv(Divisor, ReferenceRow);
      for Row := 1 to Dimen do
        { Make the ReferenceRow element of this row zero }
        if (Row <> ReferenceRow) and
           (ABS(Data[ReferenceRow,row]) > TNNearlyZero) then
        begin
          Multiplier := -Data[ReferenceRow,row] /
                         Data[ReferenceRow, ReferenceRow];
          data.multAdd(Multiplier, ReferenceRow, Row);
          inv.multAdd(Multiplier, ReferenceRow, Row);
        end;
    end;
  end;
end; { procedure Inver }

begin { procedure Inverse }
  Dimen:=data.Imax;
  Initial(Dimen, Data, Inv, Error);
  if Dimen > 1 then
    Inver(Dimen, Data, Inv, Error);
end; { procedure Inverse }


end. { Matrix }

