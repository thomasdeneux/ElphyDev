unit StmEntropy1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses sysutils,math,
     util1,Dgraphic,
     stmdef,stmObj,stmvec1,stmMat1,VlistA1,stmMlist,
     ippDefs17, ipps17,
     stmISPL1,stmvecU1,ncdef2;


procedure proTotalEntropy(var src:TVlist;x1A,x2A:float;
                           dt1,dt2:float;ndt:integer;
                           dim1,dim2:integer;
                           dV:float;
                           var dest:Tmatrix);pascal;

procedure proNoiseEntropy(var src:TVlist;x1A,x2A:float;
                           dt1,dt2:float;ndt:integer;
                           dim1,dim2:integer;
                           dV:float;
                           var dest:Tmatrix);pascal;


procedure proInformation(var src:TVlist;x1A,x2A:float;
                           dt1,dt2:float;ndt:integer;
                           dim1,dim2:integer;
                           dV:float;
                           var dest:Tmatrix);pascal;

function fonctionSimpleEntropy(var vec:Tvector):float;pascal;


procedure proTotalEntropyMa(var src:TVlist;x1A,x2A:float;
                           dt1,dt2:float;ndt:integer;
                           dim1,dim2:integer;
                           dV:float;
                           var dest:Tmatrix);pascal;

procedure proNoiseEntropyMa(var src:TVlist;x1A,x2A:float;
                           dt1,dt2:float;ndt:integer;
                           dim1,dim2:integer;
                           dV:float;
                           var dest:Tmatrix);pascal;

implementation


function entropy1(src:PtabLong;nb:integer):double;
var
  i,w:integer;
  Idis:array of integer;
  dis,logdis:array of double;
  min,max,nbdis:integer;
begin
  result:=0;
  if nb<1 then exit;

  min:=src^[0];
  max:=min;
  for i:=1 to nb-1 do
  begin
    w:=src^[i];
    if w>max then max:=w
    else
    if w<min then min:=w;
  end;

  nbdis:=max-min+1;

  setLength(Idis,nbDis);
  setLength(dis,nbDis);
  setLength(logdis,nbDis);

  fillchar(Idis[0],nbDis*sizeof(integer),0);
  for i:=0 to nb-1 do
    inc(Idis[src^[i]-min]);

  ippsConvert_32s64f(Plongint(@Idis[0]), Pdouble(@dis[0]), nbDis);
  ippsMulC_64f_I(1/nb, Pdouble(@dis[0]), nbDis );
  ippsthreshold_LT_64f_I( Pdouble(@dis[0]), nbDis, 1E-20);
  ippsLn_64f(@dis[0],Pdouble(@logDis[0]),nbdis);

  ippsDotProd_64f(Pdouble(@dis[0]), Pdouble(@logDis[0]), nbDis,@result);
end;

function fonctionSimpleEntropy(var vec:Tvector):float;
begin

  verifierVecteurTemp(vec);

  IPPSTest;
  try
    if vec.tpNum=G_longint
      then result:=entropy1(vec.tb,vec.Icount)
      else sortieErreur('SimpleEntropy : vec type must be T_longint');
  finally
    IPPSEnd;
  end;
end;


type
  Tarray2=array of array of integer;      { [Nrep , Nt ] }

function TotalEntropy(src:Tarray2;Dim:integer;FMA:boolean):double;
var
  Nt,Nrep:integer;
  i,j,k,l:integer;
  nbmot,nbo:integer;
  w:double;
  done:array of array of boolean;
  p:pointer;
begin
  result:=0;
  Nrep:=length(src);
  if Nrep=0 then exit;

  Nt:=length(src[0]);

  nbmot:=nt-dim+1;
  if nbmot<1 then exit;

  setLength(done,Nrep,nbMot);
  for i:=0 to Nrep-1 do
    fillchar(done[i,0],nbmot,0);

  for i:=0 to Nrep-1 do
  for j:=0 to nbmot-1 do
  if not done[i,j] then
  begin
    done[i,j]:=true;
    nbo:=1;
    p:=@src[i,j];

    for l:=j+1 to nbmot-1 do
      if comparemem(p,@src[i,l],dim*4) then
      begin
        done[i,l]:=true;
        inc(nbo);
      end;

    for k:=i+1 to Nrep-1 do
    for l:=0 to nbmot-1 do
      if comparemem(p,@src[k,l],dim*4) then
      begin
        done[k,l]:=true;
        inc(nbo);
      end;

    w:=nbo/(nbmot*nrep);

    if FMA
      then result:=result+sqr(w)
      else result:=result-w*ln(w)/ln(2);
  end;

  if FMA then result:=-ln(result)/ln(2);
end;

function PartialEntropy(src:Tarray2;Dim,col:integer;FMA:boolean):double;
var
  Nt,Nrep:integer;
  i,j,k,l:integer;
  nbo:integer;
  w:double;
  done:array of boolean;
  p:pointer;
begin
  result:=0;
  Nrep:=length(src);
  if Nrep=0 then exit;

  setLength(done,Nrep);
  for i:=0 to Nrep-1 do
    fillchar(done[0],Nrep,0);

  for i:=0 to Nrep-1 do
  if not done[i] then
  begin
    done[i]:=true;
    nbo:=1;
    p:=@src[i,col];

    for j:=i+1 to Nrep-1 do
      if comparemem(p,@src[j,col],dim*4) then
      begin
        done[j]:=true;
        inc(nbo);
      end;

    w:=nbo/Nrep;

    if FMA
      then result:=result+sqr(w)
      else result:=result-w*ln(w)/ln(2);
  end;

  if FMA then result:=-ln(result)/ln(2);
end;

function NoiseEntropy(src:Tarray2; dim:integer;FMA:boolean):double;
var
  i:integer;
  Nt:integer;
begin
  Nt:=length(src[0])-dim+1;
  result:=0;
  for i:=0 to Nt-1 do
    result:=result + PartialEntropy(src,dim,i,FMA);

  result:=result/Nt;
end;

function Information(src:Tarray2; dim:integer;FMA:boolean):double;
begin
  result:=TotalEntropy(src,dim,FMA) -NoiseEntropy(src,dim,FMA) ;
end;

procedure Info1(src:TVlist;x1A,x2A:float;
                           dt1,dt2:float;ndt:integer;
                           dim1,dim2:integer;
                           dV:float;
                           dest:Tmatrix;mode:integer;FMA:boolean);
var
  tb:Tarray2;
  Vdum0:Tvector;
  Vdum1,Vdum2:Tvector;
  i,t,f,dim:integer;
  w,mini:float;
  deltat:float;
  dt:float;
  i1,i2:integer;
begin
  IPPSTest;

  dest.initTemp(0,ndt-1,dim1,dim2,dest.tpNum);

  Vdum1:=Tvector.create;
  Vdum1.initTemp1(0,0,g_single);
  Vdum2:=Tvector.create;
  Vdum2.initTemp1(0,0,g_single);

  TRY
  mini:=1E100;
  with src do
  for f:=1 to count do
  begin
    with vectors[f] do
    begin
      i1:=data.invConvX(x1A);
      i2:=data.invConvX(x2A);
      cadrageX(i1,i2);
      w:=data.mini(i1,i2);
    end;
    if w<mini then mini:=w;
  end;

  if (dv<=0) then mini:=0;

  if ndt>1
    then deltaT:=(dt2-dt1)/(ndt-1)
    else deltaT:=0;

  for t:=0 to ndt-1 do
  begin
    dt:=dt1+t*deltaT;
    for f:=0 to src.count-1 do
    begin
      Vdum0:=src.vectors[f+1];
      proVextract(Vdum0,x1A,x2A,Vdum1);
      NewSampling(Vdum1,Vdum2,dt);

      if dv<=0 then ippsMulC_32f_I(trunc(dt/src.vectors[f+1].dxu), Vdum2.tbS, Vdum2.Icount );

      if f=0 then setLength(tb,src.count,Vdum2.Icount);

      ippsAddC_32f_I(-mini , Vdum2.tbS, Vdum2.Icount );
      if dV>0 then ippsMulC_32f_I(1/dV, Vdum2.tbS, Vdum2.Icount );

      if dV<0 then
      begin
        for i:=0 to Vdum2.Icount-1 do
        begin
          w:=Vdum2.Yvalue[i+Vdum2.Istart]/(-dv);
          if (w>0) and (w<=1)
            then tb[f,i]:=1
            else tb[f,i]:=ceil(w);
        end
      end
      else ippsConvert_32f32s_Sfs(Vdum2.tbS,@tb[f,0],Vdum2.Icount,ippRndNear,0);
    end;

    case mode of
      1: for dim:=dim1 to dim2 do
           dest[t,dim]:=TotalEntropy(tb,dim,FMA)/dt;

      2: for dim:=dim1 to dim2 do
           dest[t,dim]:=NoiseEntropy(tb,dim,FMA)/dt;

      3: for dim:=dim1 to dim2 do
           dest[t,dim]:=Information(tb,dim,FMA)/dt;
    end;
  end;

  FINALLY
  Vdum1.Free;
  Vdum2.free;
  IPPSend;
  END;
end;

procedure proTotalEntropy(var src:TVlist;x1A,x2A:float;
                           dt1,dt2:float;ndt:integer;
                           dim1,dim2:integer;
                           dV:float;
                           var dest:Tmatrix);
begin
  verifierObjet(typeUO(src));
  verifierMatrice(dest);

  if (dt1>dt2) then sortieErreur('Information : dt1 must be lower than dt2');
  if ndt<1  then sortieErreur('Information : ndt must be positive');
  if dim1>dim2  then sortieErreur('Information : dim1 must be lower than dim2');

  info1(src, x1A,x2A,dt1,dt2,ndt, dim1,dim2, dV, dest,1,false);
end;

procedure proNoiseEntropy(var src:TVlist;x1A,x2A:float;
                           dt1,dt2:float;ndt:integer;
                           dim1,dim2:integer;
                           dV:float;
                           var dest:Tmatrix);
begin
  verifierObjet(typeUO(src));
  verifierMatrice(dest);

  if (dt1>dt2) then sortieErreur('Information : dt1 must be lower than dt2');
  if ndt<1  then sortieErreur('Information : ndt must be positive');
  if dim1>dim2  then sortieErreur('Information : dim1 must be lower than dim2');

  info1(src,x1A,x2A, dt1,dt2,ndt, dim1,dim2, dV, dest,2,false);
end;

procedure proInformation(var src:TVlist;x1A,x2A:float;
                           dt1,dt2:float;ndt:integer;
                           dim1,dim2:integer;
                           dV:float;
                           var dest:Tmatrix);
begin
  verifierObjet(typeUO(src));
  verifierMatrice(dest);

  if (dt1>dt2) then sortieErreur('Information : dt1 must be lower than dt2');
  if ndt<1  then sortieErreur('Information : ndt must be positive');
  if dim1>dim2  then sortieErreur('Information : dim1 must be lower than dim2');

  info1(src, x1A,x2A,dt1,dt2,ndt, dim1,dim2, dV, dest,3,false);
end;

procedure proTotalEntropyMa(var src:TVlist;x1A,x2A:float;
                           dt1,dt2:float;ndt:integer;
                           dim1,dim2:integer;
                           dV:float;
                           var dest:Tmatrix);
begin
  verifierObjet(typeUO(src));
  verifierMatrice(dest);

  if (dt1>dt2) then sortieErreur('Information : dt1 must be lower than dt2');
  if ndt<1  then sortieErreur('Information : ndt must be positive');
  if dim1>dim2  then sortieErreur('Information : dim1 must be lower than dim2');

  info1(src, x1A,x2A, dt1,dt2,ndt, dim1,dim2, dV, dest,1,true);
end;

procedure proNoiseEntropyMa(var src:TVlist;x1A,x2A:float;
                           dt1,dt2:float;ndt:integer;
                           dim1,dim2:integer;
                           dV:float;
                           var dest:Tmatrix);
begin
  verifierObjet(typeUO(src));
  verifierMatrice(dest);

  if (dt1>dt2) then sortieErreur('Information : dt1 must be lower than dt2');
  if ndt<1  then sortieErreur('Information : ndt must be positive');
  if dim1>dim2  then sortieErreur('Information : dim1 must be lower than dim2');

  info1(src,x1A,x2A, dt1,dt2,ndt, dim1,dim2, dV, dest,2,true);
end;


end.
