unit DipTest1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses util1,
     stmObj,stmVec1;

function fonctionDipTest(var src:Tvector):float;pascal;
procedure proDistriFunction(var src,dest:Tvector);pascal;

implementation

type
  ArrayOfSingle=array of single;

function DipTest(src:ArrayOfSingle):float;
var
  i,j:integer;
  gcm,lcm:array of boolean;
  gcmValue,lcmValue:array of single;
  xL,xU:integer;
  xL0,xU0:integer;
  FIN:boolean;
  maxG,maxL:single;
  imaxG,imaxL:integer;
  w:single;
  dd:single;                                                          


procedure computeGCM;
var
  i:integer;     { point en cours de test }
  j:integer;     { points suivants }
  x0:integer;    { dernier point rangé }
  lastI:integer;
  slope:float;
begin
  fillchar(gcm[0],length(gcm),0);

  i:=xL;
  gcm[i]:=true;
  x0:=i;
  inc(i);
  while i<xU do
  begin
    gcm[i]:=true;
    for j:=i+1 to xU do
      if (src[j]-src[i])/(j-i)<(src[i]-src[x0])/(i-x0) then
      begin
        gcm[i]:=false;
        i:=j-1;
        break;
      end;
    if gcm[i] then x0:=i;
    inc(i);
  end;
  gcm[xU]:=true;

  for i:=xL to xU do
  if gcm[i] then
  begin
    gcmValue[i]:=src[i];
    lastI:=i;
    j:=i+1;
    while (j<xU) and not gcm[j] do inc(j);
    if j<=xU then slope:=(src[j]-src[i])/(j-i)
             else slope:=0;
  end
  else gcmValue[i]:=src[lastI]+slope*(i-lastI);

end;

procedure computeLCM;
var
  i:integer;     { point en cours de test }
  j:integer;     { points suivants }
  x0:integer;    { dernier point rangé }
  lastI:integer;
  slope:float;
begin
  fillchar(lcm[0],length(lcm),0);

  i:=xL;
  lcm[i]:=true;
  x0:=i;
  inc(i);
  while i<xU do
  begin
    lcm[i]:=true;
    for j:=i+1 to xU do
      if (src[j]-src[i])/(j-i)>(src[i]-src[x0])/(i-x0) then
      begin
        lcm[i]:=false;
        i:=j-1;
        break;
      end;
    if lcm[i] then x0:=i;
    inc(i);
  end;
  lcm[xU]:=true;

  for i:=xL to xU do
  if lcm[i] then
  begin
    lcmValue[i]:=src[i];
    lastI:=i;
    j:=i+1;
    while (j<xU) and not lcm[j] do inc(j);
    if j<=xU then slope:=(src[j]-src[i])/(j-i)
             else slope:=0;
  end
  else lcmValue[i]:=src[lastI]+slope*(i-lastI);

end;


begin
  setLength(gcm,length(src));
  setLength(lcm,length(src));
  setLength(gcmValue,length(src));
  setLength(lcmValue,length(src));

  xL:=0;
  xU:=high(src);
  result:=0;

  repeat
    ComputeGCM;
    ComputeLCM;

    maxG:=0;
    maxL:=0;
    for i:=xL to xU do
    begin
      if gcm[i] then
        begin
          w:=abs(gcmValue[i]-lcmValue[i]);
          if w>maxG then
          begin
            maxG:=w;
            imaxG:=i;
          end;
        end;

      if lcm[i] then
        begin
          w:=abs(gcmValue[i]-lcmValue[i]);
          if w>maxL then
          begin
            maxL:=w;
            imaxL:=i;
          end;
        end;
    end;

    if maxG>maxL then
    begin
      xL0:=imaxG;
      xU0:=imaxG;
      while not lcm[xU0] do inc(xU0);
      dd:=maxG;
    end
    else
    begin
      xL0:=imaxL;
      xU0:=imaxL;
      while not gcm[xL0] do dec(xL0);
      dd:=maxL;
    end;

    if dd<=result then
    begin
      FIN:=true;
    end
    else
    begin
      maxG:=0;
      for i:=xL to xL0 do
      begin
        w:=abs(GCMvalue[i]-src[i]);
        if w>maxG then maxG:=w;
      end;

      if maxG>result then result:=maxG;

      maxL:=0;
      for i:=xU0 to xU do
      begin
        w:=abs(LCMvalue[i]-src[i]);
        if w>maxL then maxL:=w;
      end;

      if maxL>result then result:=maxL;
      FIN:=false;

      xU:=xU0;
      xL:=xL0;

    end;

  until FIN;


end;

function fonctionDipTest(var src:Tvector):float;
var
  tbSrc:arrayOfSingle;
  i:integer;
begin
  verifierVecteur(src);
  setLength(tbSrc,src.Icount);
  for i:=src.Istart to src.Iend do
    tbSrc[i-src.Istart]:=src.Yvalue[i];

  result:=DipTest(tbSrc);
end;


procedure proDistriFunction(var src,dest:Tvector);
var
  tot:float;
  tp:typetypeG;
  i:integer;
begin
  verifierVecteur(src);
  verifierVecteurTemp(dest);

  if dest.tpNum in [G_single..G_extended]
    then tp:=dest.tpNum
    else tp:=G_single;
  dest.initTemp1(src.Istart,src.Iend,tp);
  dest.X0u:=src.X0u;
  dest.Dxu:=src.Dxu;

  tot:=0;
  with src do
  for i:=Istart to Iend do
  begin
    tot:=tot+Yvalue[i];
    dest.Yvalue[i]:=tot;
  end;

  if tot<>0 then
  with dest do
  for i:=Istart to Iend do
    Yvalue[i]:=Yvalue[i]/tot;

end;


end.
