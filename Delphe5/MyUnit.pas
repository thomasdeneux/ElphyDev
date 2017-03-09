unit MyUnit;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses stmvec1;

procedure proTestTruc(x,y:extended;var w:extended);pascal;

procedure proFillVec(var vec:Tvector; w:extended);pascal;

implementation

procedure proTestTruc(x,y:extended;var w:extended);
begin
  w:=x+y;
end;

procedure proFillVec(var vec:Tvector; w:extended);
begin
  verifierVecteur(vec);

  vec.fill(w);
end;

end.
