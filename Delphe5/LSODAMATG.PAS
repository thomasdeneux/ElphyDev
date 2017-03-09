unit LSODAMATG;

{ Routines painfully converted from 'C' BLAS routines }
{ H M Sauro, December 1996 }

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses stmVec1, stmKLMat;

procedure LUfactor (a : TMat; pivots : TVector);
procedure LUsolve (a: TMat; pivots : TVector; b : TVector);

implementation

{ Factor matrix into L and U by Gaussian elimination such that L*U = a }
procedure LUfactor (a : TMat; pivots : TVector);
var n, i, k, p : integer; t, big : double;
begin
  n := a.rowCount;
  for k := 1 to n - 1 do
      begin
      { Find the largest element along row k, as we move down rows start
      the search further in to the right each time we come around the k for loop }
      big := 0;
      for p := k to n do  { Start searching at kth entry in from beginning of row }
          begin
          if abs(a[k,p]) > big then begin big := abs(a[k,p]); pivots[k] := p; end;
          end;

      { If the pivot is not at the current row then swap }
      if pivots[k] <> k then
         begin
         t := a[k, pivots.Jvalue[k]];
         a[k, pivots.Jvalue[k]] := a[k,k];
         a[k,k] := t;
         end;

      { Compute multiplers }
      t := -1.0/a[k,k];
      for p := k+1 to n do a[k,p] := a[k,p] * t;

      { Eliminate the columns }
      for i := k + 1 to n do
          begin
          t := a[i, pivots.Jvalue[k]];
          if (pivots[k] <> k) then
             begin
             a[i,pivots.Jvalue[k]] := a[i,k];
             a[i,k] := t;
             end;
          { Form t*a[k] + a[i] }
          for p := k+1 to n do
              a[i,p] := t*a[k,p] + a[i,p];
          end;
      end;
  pivots[n] := n;
end;


{ Solve linear system a*x = b, where a has been factored by LUfactor }
{ Solution returned in b. TVectori is just a vector of integer types. }
{ Variable pivots is supplied by LUfactor }
procedure LUsolve (a: TMat; pivots : TVector; b : TVector);
var n, j, k, p : integer; t : double;
begin
  n := a.rowCount;
  { Compute b[k] = (b[k] - sum_(j=1)^(k-1) a[k,j]*b[j])/a[k,k] and solve Lz = b }
  b[1] := b[1]/A[1,1];  { compute z1 }
  for k := 2 to n do    { then z2.... }
      begin
      t := 0.0;
      for j := 1 to k - 1 do t := t + A[k,j]*b[j];
      b[k] := (b[k] - t) / A[k,k];
      end;
  { now solve Ux = z }
  for k := n - 1 downto 1 do
      begin
      t := 0.0;
      for p := k+1 to n do t := t + A[k, p]*b[p];
      b[k] := b[k] + t;
      j := pivots.Jvalue[k];
      if j <> k then
         begin
         t := b[j];
         b[j] := b[k];
         b[k] := t;
         end;
      end;
end;


end.
