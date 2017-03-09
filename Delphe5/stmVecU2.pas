unit stmVecU2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1, Ncdef2, IPPdefs, IPPS,
     stmVec1 ;

procedure proVHilbert(var src,dest:Tvector);pascal;

implementation

procedure proVHilbert(var src,dest:Tvector);
var
  status:integer;
  spec: PIppsHilbertSpec_32f32fc ;
  p1:array of single;
  p2:array of TSingleComp;
  i:integer;
begin
  verifierVecteur(src);
  verifierVecteurTemp(dest);
  VadjustIstartIend(src,dest);

  IPPStest;

  setLength(p1,src.Icount);
  setLength(p2,src.Icount);

  with src do
  for i:=Istart to Iend do p1[i-Istart]:= Yvalue[i];

  status := ippsHilbertInitAlloc_32f32fc(spec, src.Icount, ippAlgHintNone);
  try
  status := ippsHilbert_32f32fc(@p1[0], @p2[0], spec);
  finally
  ippsHilbertFree_32f32fc(spec);
  end;

  with dest do
  if tpNum<G_singleComp then
    for i:=Istart to Iend do Yvalue[i]:=p2[i-Istart].y
  else
    for i:=Istart to Iend do
    begin
      Yvalue[i]:=p2[i-Istart].x;
      Imvalue[i]:=p2[i-Istart].y;
    end;
  
  IPPSend;
end;


end.
