unit stmVecU2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1, Ncdef2, IPPdefs17, IPPS17, ipp17ex, stmVec1 ;

procedure proVHilbert(var src,dest:Tvector);pascal;

implementation

procedure proVHilbert(var src,dest:Tvector);
var
  status:integer;
  p1:array of single;
  i:integer;
begin
  verifierVecteur(src);
  verifierVecteurTemp(dest);
  VadjustIstartIend(src,dest);

  IPPStest;

  setLength(p1,src.Icount);

  with src do
  for i:=Istart to Iend do p1[i-Istart]:= Yvalue[i];  // copier src dans p1

  Hilbert32f(@p1[0], src.Icount);                     // p1 contient la transformée de Hilbert

  with dest do
  if tpNum<G_singleComp then                          // si dest est réel, on copie la transformée directement
    for i:=Istart to Iend do Yvalue[i]:=p1[i-Istart]
  else
    for i:=Istart to Iend do                          // si dest est complexe, on copie src dans la partie réelle
    begin                                             // et la transformée dans la partie imaginaire  
      Yvalue[i]:=   src[i];
      Imvalue[i]:=p1[i-Istart];
    end;

  IPPSend;
end;


end.
