unit stmCor1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,
     stmdef,stmobj,stmvec1,stmMat1,
     Ncdef2,stmPg;

procedure ProCrossCorre(var source1,source2,dest:Tvector;x1c,x2c,Xmin,Xmax:float);pascal;
procedure ProAutoCorre(var source,dest:Tvector;x1c,x2c,Xmin,Xmax:float);pascal;


procedure proProdMatrix(var m:Tmatrix;var v1,v2:Tvector);pascal;

implementation


procedure ProCrossCorre(var source1,source2,dest:Tvector;x1c,x2c,Xmin,Xmax:float);
var
  i,j,k:integer;
  i11,i12,i21,i22:integer;
  Nmin,Nmax:integer;
  u:float;
  nb:integer;
  tb:array of Longint;
  temp:array of single;
  w:single;
begin
  verifierObjet(typeUO(source1));
  verifierObjet(typeUO(source2));
  verifierObjet(typeUO(dest));

  i11:=source1.invConvX(x1c);
  i21:=source1.invConvX(x2c);
  source1.cadrageX(i11,i21);

  i12:=source2.invConvX(x1c);
  i22:=source2.invConvX(x2c);
  source2.cadrageX(i12,i22);

  Nmin:=roundL(Xmin/source1.Dxu);
  Nmax:=roundL(Xmax/source1.Dxu);

  if (dest.inf.Imin<>Nmin) or (dest.inf.Imax<>Nmax)
    then dest.initTemp1(Nmin,Nmax,dest.inf.tpNum)
    else dest.clear;

  dest.dxu:=source1.dxu;
  dest.x0u:=0;
  dest.unitX:=source1.unitX;

  setLength(temp,Nmax-Nmin+1);
  setLength(tb,Nmax-Nmin+1);
  fillchar(tb[0],(Nmax-Nmin+1)*4,0);
  fillchar(temp[0],(Nmax-Nmin+1)*4,0);

  source1.data.open;
  source2.data.open;

  try
  i:=i11;
  while (i<i21) and not testerFinPg do
  begin
    w:=source1.data.getE(i);
    for j:=Nmin to Nmax do
      begin
        k:=i-j;
        if (k>=i12) and (k<=i22) then
          begin
            temp[j-Nmin]:=temp[j-Nmin]+w*source2.data.getE(k);
            inc(tb[j-Nmin]);
          end;
      end;
    inc(i);
  end;
  if not finExeU^ then
    for j:=Nmin to Nmax do dest.data.setE(j,temp[j-Nmin]/tb[j-Nmin]);

  finally
  source1.data.close;
  source2.data.close;
  end;

end;


procedure ProAutoCorre(var source,dest:Tvector;x1c,x2c,Xmin,Xmax:float);
begin
  ProCrossCorre(source,source,dest,x1c,x2c,Xmin,Xmax);
end;


procedure proProdMatrix(var m:Tmatrix;var v1,v2:Tvector);
var
  i,j:integer;
begin
  verifierObjet(typeUO(m));
  verifierObjet(typeUO(v1));
  verifierObjet(typeUO(v2));

  if (m.inf.Imin<>v1.inf.Imin) or (m.inf.Imax<>v1.inf.Imax) or
     (m.inf.Jmin<>v2.inf.Imin) or (m.inf.Jmax<>v2.inf.Imax)
    then m.initTemp(v1.inf.Imin,v1.inf.Imax,v2.inf.Imin,v2.inf.Imax,m.inf.tpNum)
    else m.clear;

  for i:=v1.inf.Imin to v1.inf.Imax do
    for j:=v2.inf.Imin to v2.inf.Imax do
      m.data.setE(i,j,v1.data.getE(i)*v2.data.getE(j));
end;


end.
