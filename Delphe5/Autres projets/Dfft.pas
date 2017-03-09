unit Dfft;


INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses util1;


procedure libererFFT(NumPoints:integer);
function allouerFFT(NumPoints:integer):boolean;

procedure RealFFT(NumPoints : integer;
                  Inverse   : boolean;
                  XReal     : PtabFloat;
                  XImag     : PtabFloat;
              var Error     : byte);


{---------------------------------------------------------------------------}
{-                                                                         -}
{-    Input: NumPoints, Inverse, XReal, XImag,                             -}
{-    Output: XReal, XImag, Error                                          -}
{-                                                                         -}
{-    Purpose:  This procedure uses the complex Fourier transform          -}
{-              routine (FFT) to transform real data.  The real data       -}
{-              is in the vector XReal.  Appropriate shuffling of indices  -}
{-              changes the real vector into two vectors (representing     -}
{-              complex data) which are only half the size of the original -}
{-              vector.  Appropriate unshuffling at the end produces the   -}
{-              transform of the real data.                                -}
{-                                                                         -}
{-  User Defined Types:                                                    -}
{-         TNvector = array[0..TNArraySize] of real                        -}
{-      PtabFloat = ^TNvector                                            -}
{-                                                                         -}
{- Global Variables:  NumPoints   : integer     Number of data             -}
{-                                              points in X                -}
{-                    Inverse     : boolean     False => forward transform -}
{-                                              True ==> inverse transform -}
{-                    XReal,XImag : PtabFloat Data points                -}
{-                    Error       : byte        Indicates an error         -}
{-                                                                         -}
{-             Errors:  0: No Errors                                       -}
{-                      1: NumPoints < 2                                   -}
{-                      2: NumPoints not a power of two                    -}
{-                         (or 4 for radix-4 transforms)                   -}
{-                                                                         -}
{---------------------------------------------------------------------------}

procedure ComplexFFT(NumPoints : integer;
                      Inverse   : boolean;
                      XReal     : PtabFloat;
                      XImag     : PtabFloat;
                  var Error     : byte);



IMPLEMENTATION

const
  DummyReal: PtabFloat=nil;  { doit contenir NumPoints }
  DummyImag: PtabFloat=nil;  {  "            "         }
  SinTable : PtabFloat=nil;  { doit contenir NumPoints div 2 }
  CosTable : PtabFloat=nil;  {  "            "               }

procedure libererFFT(NumPoints:integer);
  begin
    if DummyReal<>nil then freemem(DummyReal,NumPoints*10);
    if DummyImag<>nil then freemem(DummyImag,NumPoints*10);
    if SinTable<>nil  then freemem(SinTable,NumPoints*5 );
    if CosTable<>nil  then freemem(CosTable,NumPoints*5);
    DummyReal:=nil;
    DummyImag:=nil;
    SinTable:=nil;
    CosTable:=nil;
  end;

function allouerFFT(NumPoints:integer):boolean;
  var
    ok:boolean;
  begin
    if NumPoints=0 then
      begin
        allouerFFT:=true;
        exit;
      end;
    if maxavail>NumPoints*10 then getmem(DummyReal,NumPoints*10);
    if maxavail>NumPoints*10 then getmem(DummyImag,NumPoints*10);
    if maxavail>NumPoints*5 then getmem(SinTable,NumPoints*5);
    if maxavail>NumPoints*5 then getmem(CosTable,NumPoints*5);
    ok:=(DummyReal<>nil) and (DummyImag<>nil)
         and (CosTable<>nil) and (SinTable<>nil);
    if not ok then libererFFT(NumPoints);
    allouerFFT:=ok;
  end;


procedure TestInput(NumPoints    : integer;
                 var NumberOfBits : byte;
                 var Error        : byte);
type
  ShortArray = array[1..16] of integer;

var
  Term : integer;

const
  PowersOfTwo : ShortArray = (2, 4, 8, 16, 32, 64, 128, 256,
                              512, 1024, 2048, 4096, 8192,16384,32768,65536);
begin
  Error := 2;            { Assume NumPoints not a power of two  }
  if NumPoints < 2 then
    Error := 1;     { NumPoints < 2  }
  Term := 1;
  while (Term <= 16) and (Error = 2) do
  begin
    if NumPoints = PowersOfTwo[Term] then
    begin
      NumberOfBits := Term;
      Error := 0;  { NumPoints is a power of two  }
    end;
    Term := Succ(Term);
  end;
end; { procedure TestInput }

procedure MakeSinCosTable(NumPoints : integer;
                       var SinTable  : PtabFloat;
                       var CosTable  : PtabFloat);
var
  RealFactor, ImagFactor : Float;
  Term : integer;
  TermMinus1 : integer;
  UpperLimit : integer;

begin
  RealFactor :=  Cos(2 * Pi / NumPoints);
  ImagFactor := -Sqrt(1 - Sqr(RealFactor));
  CosTable^[0] := 1;
  SinTable^[0] := 0;
  CosTable^[1] := RealFactor;
  SinTable^[1] := ImagFactor;
  UpperLimit := NumPoints shr 1 - 1;
  for Term := 2 to UpperLimit do
  begin
    TermMinus1 := Term - 1;
    CosTable^[Term] :=  CosTable^[TermMinus1] * RealFactor -
                        SinTable^[TermMinus1] * ImagFactor;
    SinTable^[Term] :=  CosTable^[TermMinus1] * ImagFactor +
                        SinTable^[TermMinus1] * RealFactor;
  end;
end; { procedure MakeSinCosTable }

procedure FFT(NumberOfBits : byte;
               NumPoints    : integer;
               Inverse      : boolean;
           var XReal        : PtabFloat;
           var XImag        : PtabFloat;
           var SinTable     : PtabFloat;
           var CosTable     : PtabFloat);

const
  RootTwoOverTwo = 0.707106781186548;

var
  Term : byte;
  CellSeparation : integer;
  NumberOfCells : integer;
  NumElementsInCell : integer;
  NumElInCellLess1 : integer;
  NumElInCellSHR1 : integer;
  NumElInCellSHR2 : integer;
  RealRootOfUnity, ImagRootOfUnity : Float;
  Element : integer;
  CellElements : integer;
  ElementInNextCell : integer;
  Index : integer;
  RealDummy, ImagDummy : Float;

procedure BitInvert(NumberOfBits : byte;
                    NumPoints    : integer;
                var XReal        : PtabFloat;
                var XImag        : PtabFloat);

{-----------------------------------------------------------}
{- Input: NumberOfBits, NumPoints                          -}
{- Output: XReal, XImag                                    -}
{-                                                         -}
{- This procedure bit inverts the order of data in the     -}
{- vector X.  Bit inversion reverses the order of the      -}
{- binary representation of the indices; thus 2 indices    -}
{- will be switched.  For example, if there are 16 points, -}
{- Index 7 (binary 0111) would be switched with Index 14   -}
{- (binary 1110).  It is necessary to bit invert the order -}
{- of the data so that the transformation comes out in the -}
{- correct order.                                          -}
{-----------------------------------------------------------}

var
  Term : integer;
  Invert : integer;
  Hold : Float;
  NumPointsDiv2, K : integer;

begin
  NumPointsDiv2 := NumPoints shr 1;
  Invert := 0;
  for Term := 0 to NumPoints - 2 do
  begin
    if Term < Invert then   { Switch these two indices  }
    begin
      Hold := XReal^[Invert];
      XReal^[Invert] := XReal^[Term];
      XReal^[Term] := Hold;
      Hold := XImag^[Invert];
      XImag^[Invert] := XImag^[Term];
      XImag^[Term] := Hold;
    end;
    K := NumPointsDiv2;
    while K <= Invert do
    begin
      Invert := Invert - K;
      K := K shr 1;
    end;
    Invert := Invert + K;
  end;
end; { procedure BitInvert }

begin { procedure FFT }
  { The data must be entered in bit inverted order }
  { for the transform to come out in proper order  }
  BitInvert(NumberOfBits, NumPoints, XReal, XImag);

  if Inverse then
    { Conjugate the input  }
    for Element := 0 to NumPoints - 1 do
      XImag^[Element] := -XImag^[Element];

  NumberOfCells := NumPoints;
  CellSeparation := 1;
  for Term := 1 to NumberOfBits do
  begin
    { NumberOfCells halves; equals 2^(NumberOfBits - Term)  }
    NumberOfCells := NumberOfCells shr 1;
    { NumElementsInCell doubles; equals 2^(Term-1)  }
    NumElementsInCell := CellSeparation;
    { CellSeparation doubles; equals 2^Term  }
    CellSeparation := CellSeparation SHL 1;
    NumElInCellLess1 := NumElementsInCell - 1;
    NumElInCellSHR1 := NumElementsInCell shr 1;
    NumElInCellSHR2 := NumElInCellSHR1 shr 1;

    { Special case: RootOfUnity = EXP(-i 0)  }
    Element := 0;
    while Element < NumPoints do
    begin
      { Combine the X[Element] with the element in  }
      { the identical location in the next cell     }
      ElementInNextCell := Element + NumElementsInCell;
      RealDummy := XReal^[ElementInNextCell];
      ImagDummy := XImag^[ElementInNextCell];
      XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
      XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
      XReal^[Element] := XReal^[Element] + RealDummy;
      XImag^[Element] := XImag^[Element] + ImagDummy;
      Element := Element + CellSeparation;
    end;

    for CellElements := 1 to NumElInCellSHR2 - 1 do
    begin
      Index := CellElements * NumberOfCells;
      RealRootOfUnity := CosTable^[Index];
      ImagRootOfUnity := SinTable^[Index];
      Element := CellElements;

      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy := XReal^[ElementInNextCell] * RealRootOfUnity -
                     XImag^[ElementInNextCell] * ImagRootOfUnity;
        ImagDummy := XReal^[ElementInNextCell] * ImagRootOfUnity +
                     XImag^[ElementInNextCell] * RealRootOfUnity;
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;

    { Special case: RootOfUnity = EXP(-i PI/4)  }
    if Term > 2 then
    begin
      Element := NumElInCellSHR2;
      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy := RootTwoOverTwo * (XReal^[ElementInNextCell] +
                     XImag^[ElementInNextCell]);
        ImagDummy := RootTwoOverTwo * (XImag^[ElementInNextCell] -
                     XReal^[ElementInNextCell]);
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;

    for CellElements := NumElInCellSHR2 + 1 to NumElInCellSHR1 - 1 do
    begin
      Index := CellElements * NumberOfCells;
      RealRootOfUnity := CosTable^[Index];
      ImagRootOfUnity := SinTable^[Index];
      Element := CellElements;
      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy := XReal^[ElementInNextCell] * RealRootOfUnity -
                     XImag^[ElementInNextCell] * ImagRootOfUnity;
        ImagDummy := XReal^[ElementInNextCell] * ImagRootOfUnity +
                     XImag^[ElementInNextCell] * RealRootOfUnity;
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;

    { Special case: RootOfUnity = EXP(-i PI/2)  }
    if Term > 1 then
    begin
      Element := NumElInCellSHR1;
      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy :=  XImag^[ElementInNextCell];
        ImagDummy := -XReal^[ElementInNextCell];
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;

    for CellElements := NumElInCellSHR1 + 1 to
                        NumElementsInCell - NumElInCellSHR2 - 1 do
    begin
      Index := CellElements * NumberOfCells;
      RealRootOfUnity := CosTable^[Index];
      ImagRootOfUnity := SinTable^[Index];
      Element := CellElements;
      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy := XReal^[ElementInNextCell] * RealRootOfUnity -
                     XImag^[ElementInNextCell] * ImagRootOfUnity;
        ImagDummy := XReal^[ElementInNextCell] * ImagRootOfUnity +
                     XImag^[ElementInNextCell] * RealRootOfUnity;
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;

    { Special case: RootOfUnity = EXP(-i 3PI/4)  }
    if Term > 2 then
    begin
      Element := NumElementsInCell - NumElInCellSHR2;
      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy := -RootTwoOverTwo * (XReal^[ElementInNextCell] -
                                        XImag^[ElementInNextCell]);
        ImagDummy := -RootTwoOverTwo * (XReal^[ElementInNextCell] +
                                        XImag^[ElementInNextCell]);
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;

    for CellElements := NumElementsInCell - NumElInCellSHR2 + 1 to
                                            NumElInCellLess1 do
    begin
      Index := CellElements * NumberOfCells;
      RealRootOfUnity := CosTable^[Index];
      ImagRootOfUnity := SinTable^[Index];
      Element := CellElements;
      while Element < NumPoints do
      begin
        { Combine the X[Element] with the element in  }
        { the identical location in the next cell     }
        ElementInNextCell := Element + NumElementsInCell;
        RealDummy := XReal^[ElementInNextCell] * RealRootOfUnity -
                     XImag^[ElementInNextCell] * ImagRootOfUnity;
        ImagDummy := XReal^[ElementInNextCell] * ImagRootOfUnity +
                     XImag^[ElementInNextCell] * RealRootOfUnity;
        XReal^[ElementInNextCell] := XReal^[Element] - RealDummy;
        XImag^[ElementInNextCell] := XImag^[Element] - ImagDummy;
        XReal^[Element] := XReal^[Element] + RealDummy;
        XImag^[Element] := XImag^[Element] + ImagDummy;
        Element := Element + CellSeparation;
      end;
    end;
  end;

  {----------------------------------------------------}
  {-  Divide all the values of the transformation     -}
  {-  by the square root of NumPoints. If taking the  -}
  {-  inverse, conjugate the output.                  -}
  {----------------------------------------------------}
  {
  if Inverse then
    ImagDummy := -1/Sqrt(NumPoints)
  else
    ImagDummy :=  1/Sqrt(NumPoints);
  RealDummy := ABS(ImagDummy);
  }
  if Inverse then
    ImagDummy := -1/NumPoints
  else
    ImagDummy :=  1;
  RealDummy := ABS(ImagDummy);

  for Element := 0 to NumPoints - 1 do
  begin
    XReal^[Element] := XReal^[Element] * RealDummy;
    XImag^[Element] := XImag^[Element] * ImagDummy;
  end;
end; { procedure FFT }




procedure RealFFT(NumPoints : integer;
                   Inverse   : boolean;
                   XReal     : PtabFloat;
                   XImag     : PtabFloat;
               var Error     : byte);
var
  NumberOfBits : byte;                { Number of bits necessary to     }
                                      { represent the number of points  }

procedure MakeRealDataComplex(NumPoints : integer;
                          var XReal     : PtabFloat;
                          var XImag     : PtabFloat);
var
  Index, NewIndex : integer;

begin

  for Index := 0 to NumPoints - 1 do
  begin
    NewIndex := Index shl 1;
    DummyReal^[Index] := XReal^[NewIndex];
    DummyImag^[Index] := XReal^[NewIndex + 1];
  end;

  move(dummyReal^,Xreal^,numPoints*sizeof(float));
  move(dummyImag^,Ximag^,numPoints*sizeof(float));
end;

procedure UnscrambleComplexOutput(NumPoints : integer;
                              var SinTable  : PtabFloat;
                              var CosTable  : PtabFloat;
                              var XReal     : PtabFloat;
                              var XImag     : PtabFloat);
var
  PiOverNumPoints : Float;
  Index : integer;
  indexSHR1 : integer;
  NumPointsMinusIndex : integer;
  SymmetricIndex : integer;
  Multiplier : Float;
  Factor : Float;
  CosFactor, SinFactor : Float;
  RealSum, ImagSum, RealDif, ImagDif : Float;
  NumPointsSHL1 : integer;

begin
  move(Xreal^,DummyReal^,2*numPoints*sizeof(float));
  move(XImag^,DummyImag^,2*numPoints*sizeof(float));

  PiOverNumPoints := Pi / NumPoints;
  NumPointsSHL1 := NumPoints shl 1;
  DummyReal^[0] := (XReal^[0] + XImag^[0]) / Sqrt(2);
  DummyImag^[0] := 0;
  DummyReal^[NumPoints] := (XReal^[0] - XImag^[0]) / Sqrt(2);
  DummyImag^[NumPoints] := 0;
  for Index := 1 to NumPoints - 1 do
  begin
    Multiplier := 0.5 / Sqrt(2);
    Factor := PiOverNumPoints * Index;
    NumPointsMinusIndex := NumPoints - Index;
    SymmetricIndex := NumPointsSHL1 - Index;
    if Odd(Index) then
      begin
        CosFactor :=  Cos(Factor);
        SinFactor := -Sin(Factor);
      end
    else
      begin
        indexSHR1 := Index shr 1;
        CosFactor := CosTable^[indexSHR1];
        SinFactor := SinTable^[indexSHR1];
      end;

    RealSum := XReal^[Index] + XReal^[NumPointsMinusIndex];
    ImagSum := XImag^[Index] + XImag^[NumPointsMinusIndex];
    RealDif := XReal^[Index] - XReal^[NumPointsMinusIndex];
    ImagDif := XImag^[Index] - XImag^[NumPointsMinusIndex];

    DummyReal^[Index] := Multiplier * (RealSum + CosFactor * ImagSum
                         + SinFactor * RealDif);
    DummyImag^[Index] := Multiplier * (ImagDif + SinFactor * ImagSum
                         - CosFactor * RealDif);
    DummyReal^[SymmetricIndex] :=  DummyReal^[Index];
    DummyImag^[SymmetricIndex] := -DummyImag^[Index];
  end;  { for }

  move(DummyReal^,XReal^,2*numPoints*sizeof(float));
  move(DummyImag^,XImag^,2*numPoints*sizeof(float));
end;

begin { procedure RealFFT }
  NumPoints := NumPoints shr 1;

  TestInput(NumPoints, NumberOfBits, Error);

  if Error = 0 then
  begin
    MakeRealDataComplex(NumPoints, XReal, XImag);
    MakeSinCosTable(NumPoints, SinTable, CosTable);
    FFT(NumberOfBits, NumPoints, Inverse, XReal, XImag, SinTable, CosTable);
    UnscrambleComplexOutput(NumPoints, SinTable, CosTable, XReal, XImag);
  end;
end; { procedure RealFFT }


procedure ComplexFFT(NumPoints : integer;
                      Inverse   : boolean;
                      XReal     : PtabFloat;
                      XImag     : PtabFloat;
                  var Error     : byte);

var
  NumberOfBits : byte;                   { Number of bits to represent the  }
                                         { number of data points.           }

begin { procedure ComplexFFT }

  TestInput(NumPoints, NumberOfBits, Error);

  if Error = 0 then
  begin
    MakeSinCosTable(NumPoints, SinTable, CosTable);
    FFT(NumberOfBits, NumPoints, Inverse, XReal, XImag, SinTable, CosTable);
  end;
end; { procedure ComplexFFT }

end.
