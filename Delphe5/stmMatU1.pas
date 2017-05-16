unit stmMatU1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Dgraphic,
     stmDef,stmObj,stmMat1,stmMlist,stmError,NcDef2,

     IPPS17, IPPI17,IPPdefs17,
     stmvec1,VlistA1,stmJP,stmPsth1,stmave1,
     mathKernel0,mkl_dfti;

procedure ProMcopy(var src,dest:Tmatrix);pascal;
procedure ProMcopy1(var src,dest:Tmatrix);pascal;
procedure ProMextract(var src:Tmatrix;x1,x2,y1,y2:float;var dest:Tmatrix);pascal;
procedure ProMextract1(var src:Tmatrix;x1,x2,y1,y2:float;var dest:Tmatrix);pascal;
procedure ProMmoveData(var src:Tmatrix;x1,x2,y1,y2:float;var dest:Tmatrix;xd,yd:float);pascal;


procedure ProMrealPart(var src,dest:Tmatrix);pascal;
procedure ProMimPart(var src,dest:Tmatrix);pascal;
procedure ProMmodulus(var src,dest:Tmatrix);pascal;
procedure ProMphase(var src,dest:Tmatrix);pascal;
procedure ProMpower(var src,dest:Tmatrix);pascal;
procedure ProMinv(var src,dest:Tmatrix);pascal;
procedure ProMChangeType(var src,dest:Tmatrix;tp:integer);pascal;

procedure ProMabs(var src,dest:Tmatrix);pascal;

procedure ProMadd(var src1,src2,dest:Tmatrix);pascal;
procedure ProMsub(var src1,src2,dest:Tmatrix);pascal;
procedure ProMmul(var src1,src2,dest:Tmatrix);pascal;
procedure ProMmulConj(var src1,src2,dest:Tmatrix);pascal;


procedure ProMdiv(var src1,src2,dest:Tmatrix);pascal;
procedure proMdiv1(var src1,src2,dest:Tmatrix;th:float;Vr:TfloatComp);pascal;

procedure ProMaddNum(var src:Tmatrix; num:TfloatComp);pascal;
procedure ProMmulNum(var src:Tmatrix; num:TfloatComp);pascal;

procedure ProMrotate90(var src,dest:Tmatrix;nb:integer);pascal;
procedure ProMtranspose(var src,dest:Tmatrix);pascal;


procedure proMsup(var src1,src2,dest:Tmatrix);pascal;
procedure proMsup1(var src1,src2,dest:Tmatrix);pascal;
procedure proMsup2(var src,dest,destLat:Tmatrix;tt:float);pascal;

procedure proMinter(var src1,src2,dest:Tmatrix;seuil:float);pascal;

procedure proJPcov(var src1,src2:TVlist;var Vdate:Tvector;var dest:Tmatrix;evt1,evt2:boolean;mode:integer);pascal;

function fonctionMdotProd(var src1,src2:Tmatrix):TfloatComp;pascal;
procedure proMDFT(var src,dest:Tmatrix;fwd:boolean);pascal;

procedure proMresizeImage(var src,dest:Tmatrix; Dxf,x0f,Dyf,y0f:float;mode:integer);pascal;
procedure proMremapImage(var src,dest,Xmap,Ymap:Tmatrix; mode:integer);pascal;

procedure proBuildXTmapFromMatList(var src:TmatList;var dest:Tmatrix;FY,Fnorm:boolean;Zth:float;AgTh:integer);pascal;

implementation

var
  E_srcEqDest:integer;


procedure RefuseSrcEqDest(src,dest:Tmatrix);
begin
  if src=dest then sortieErreur('Destination must be different from source');
end;



procedure ProMcopy(var src,dest:Tmatrix);
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);
  RefuseSrcEqDest(src,dest);
  MadjustIndexTpNum(src,dest);
  dest.copyDataFrom(src);
end;

procedure ProMcopy1(var src,dest:Tmatrix);
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);
  RefuseSrcEqDest(src,dest);
  MadjustIndex(src,dest);
  dest.copyDataFrom(src);
end;

procedure ProMextract(var src:Tmatrix;x1,x2,y1,y2:float;var dest:Tmatrix);
var
  i1,i2,j1,j2:integer;
  i,j:integer;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);
  RefuseSrcEqDest(src,dest);

  dest.dxu:=src.dxu;
  dest.X0u:=0;
  dest.unitX:=src.unitX;

  dest.dyu:=src.dyu;
  dest.Y0u:=0;
  dest.unitY:=src.unitY;

  McopyZscale(src,dest);

  i1:=src.invconvX(x1);
  i2:=src.invconvX(x2);
  j1:=src.invconvY(y1);
  j2:=src.invconvY(y2);

  Mmodify(dest,src.tpnum,0,i2-i1,0,j2-j1);

  if src.tpNum=g_single then
  begin
    ippitest;
    ippicopy_32f_C1R(src.getP(i1,j1),src.stepIPP,dest.tb,dest.stepIPP,dest.sizeIPP);
    ippiEnd;
  end
  else
  {
  if dest.tpNum<g_singleComp then
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      dest.Zvalue[i-i1,j-j1]:=src.Zvalue[i,j]
  else
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      dest.Cpxvalue[i-i1,j-j1]:=src.Cpxvalue[i,j];
  }

  for i:=i1 to i2 do
    move(src.getP(i,j1)^,dest.getP(i-i1,0)^,(j2-j1+1)*tailleTypeG[src.tpNum]);

end;


procedure ProMextract1(var src:Tmatrix;x1,x2,y1,y2:float;var dest:Tmatrix);
var
  i1,i2,j1,j2:integer;
  i,j:integer;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);
  RefuseSrcEqDest(src,dest);

  dest.dxu:=src.dxu;
  dest.X0u:=0;
  dest.unitX:=src.unitX;

  dest.dyu:=src.dyu;
  dest.Y0u:=0;
  dest.unitY:=src.unitY;

  McopyZscale(src,dest);

  i1:=src.invconvX(x1);
  i2:=src.invconvX(x2);
  j1:=src.invconvY(y1);
  j2:=src.invconvY(y2);

  Mmodify(dest,dest.tpnum,0,i2-i1,0,j2-j1);

  if dest.tpNum<g_singleComp then
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      dest.Zvalue[i-i1,j-j1]:=src.Zvalue[i,j]
  else
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      dest.Cpxvalue[i-i1,j-j1]:=src.Cpxvalue[i,j];
end;

procedure ProMmoveData(var src:Tmatrix;x1,x2,y1,y2:float;var dest:Tmatrix;xd,yd:float);
var
  i1,i2,j1,j2,id,jd:integer;
  i,j:integer;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);


  i1:=src.invconvX(x1);
  i2:=src.invconvX(x2);
  j1:=src.invconvY(y1);
  j2:=src.invconvY(y2);

  id:=dest.invconvX(xD);
  jd:=dest.invconvY(yD);


  if dest.tpNum<g_singleComp then
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      dest.Zvalue[iD+i-i1,jD+j-j1]:=src.Zvalue[i,j]
  else
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      dest.Cpxvalue[iD+i-i1,jD+j-j1]:=src.Cpxvalue[i,j];
end;



procedure proMrealPart(var src,dest:Tmatrix);
var
  i,j:integer;
  srcX:Tmatrix;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);

  IPPStest;

  if src=dest
    then srcX:=Tmatrix(src.clone(true))
    else srcX:=src;

  TRY

  Mmodify(dest,dest.tpNum,src.Istart,src.Iend,src.Jstart,src.Jend);
  McopyXYscale(src,dest);
  McopyZscale(src,dest);

  {cas ISPL}
  if src.inf.temp and ((src.tpNum=G_singleComp) and (dest.tpNum=G_single) OR
                       (src.tpNum=G_doubleComp) and (dest.tpNum=G_double) ) then
    case src.tpnum of
      G_singleComp: ippsReal_32fc(srcX.tbSC,dest.tbS,src.Kcount);
      G_doubleComp: ippsReal_64fc(srcX.tbDC,dest.tbD,src.Kcount);
    end
  else
  {cas complexes non ISPL}
  if src.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
      for j:=src.Jstart to src.Jend do
        dest.Zvalue[i,j]:=srcX.Zvalue[i,j];
    end
  {cas non complexes}
  else proMcopy1(srcX,dest);


  FINALLY
  if src=dest then srcX.Free;
  IPPSend;
  END;
end;

procedure proMimPart(var src,dest:Tmatrix);
var
  i,j:integer;
  srcX:Tmatrix;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);
  RefuseSrcEqDest(src,dest);

  IPPStest;

  if src=dest
    then srcX:=Tmatrix(src.clone(true))
    else srcX:=src;


  TRY

  Mmodify(dest,dest.tpNum,src.Istart,src.Iend,src.Jstart,src.Jend);
  McopyXYscale(src,dest);

  {cas ISPL}
  if src.inf.temp and ((src.tpNum=G_singleComp) and (dest.tpNum=G_single) OR
                       (src.tpNum=G_doubleComp) and (dest.tpNum=G_double) ) then
    case src.tpnum of
      G_singleComp: ippsImag_32fc(srcX.tbSC,dest.tbS,src.Kcount);
      G_doubleComp: ippsImag_64fc(srcX.tbDC,dest.tbD,src.Kcount);
    end
  else
  {cas complexes non ISPL}
  if src.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
      for j:=src.Jstart to src.Jend do
        dest.Zvalue[i,j]:=srcX.Imvalue[i,j];
      end
  {cas non complexes}
  else dest.clear;


  FINALLY
  IPPSend;
  if src=dest then srcX.free;
  END;
end;


procedure proMmodulus(var src,dest:Tmatrix);
var
  i,j:integer;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);
  IPPStest;

  TRY

  if dest<>src then
  begin
    Mmodify(dest,dest.tpNum,src.Istart,src.Iend,src.Jstart,src.Jend);
    McopyXYscale(src,dest);
  end;

  {cas ISPL}
  if src.inf.temp and (src.tpNum=G_single) and (dest.tpNum=G_single) then
    begin
      if src=dest
        then ippsAbs_32f_I(src.tbS,src.Kcount)
        else ippsAbs_32f(src.tbS,dest.tbS,src.Kcount);
    end
  else
  if src.inf.temp and (src.tpNum=G_double) and (dest.tpNum=G_double) then
    begin
      if src=dest
        then ippsAbs_64f_I(src.tbD,src.Kcount)
        else ippsAbs_64f(src.tbD,dest.tbD,src.Kcount);
    end
  else
  if src.inf.temp and (src.tpNum=G_singleComp) and (dest.tpNum=G_single)
    then ippsMagnitude_32fc(src.tbSC,dest.tbS,src.Kcount)
  else
  if src.inf.temp and (src.tpNum=G_doubleComp) and (dest.tpNum=G_double)
    then ippsMagnitude_64fc(src.tbDC,dest.tbD,src.Kcount)
  else

  {cas complexes non ISPL}
  if src.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
      for j:=src.Jstart to src.Jend do
        dest.Zvalue[i,j]:=mdlCpx(src.cpxValue[i,j]);
      end
  {cas non complexes}
  else
    begin
      for i:=src.Istart to src.Iend do
      for j:=src.Jstart to src.Jend do
        dest.Zvalue[i,j]:=abs(src.ZValue[i,j]);
    end;

  FINALLY
  IPPSend;

  END;
end;

procedure proMabs(var src,dest:Tmatrix);
begin
   proMmodulus(src,dest);
end;

procedure proMphase(var src,dest:Tmatrix);
var
  i,j:integer;
  srcX:Tmatrix;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);
  IPPStest;

  if src=dest
    then srcX:=Tmatrix(src.clone(true))
    else srcX:=src;

  TRY

  Mmodify(dest,dest.tpNum,src.Istart,src.Iend,src.Jstart,src.Jend);
  McopyXYscale(src,dest);

  {cas ISPL}
  if src.inf.temp and (src.tpNum=G_singleComp) and (dest.tpNum=G_single)
    then ippsPhase_32fc(srcX.tbSC,dest.tbS,src.Kcount)
  else
  if src.inf.temp and (src.tpNum=G_doubleComp) and (dest.tpNum=G_double)
      then ippsPhase_64fc(srcX.tbDC,dest.tbD,src.Kcount)
  else
  {cas complexes non ISPL}
  if src.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
      for j:=src.Jstart to src.Jend do
        dest.Zvalue[i,j]:=AngleCpx(srcX.cpxValue[i,j]);
      end
  {cas non complexes}
  else dest.clear;

  FINALLY
  IPPSend;
  if src=dest then srcX.free;
  END;
end;


procedure proMpower(var src,dest:Tmatrix);
var
  i,j:integer;
  srcX:Tmatrix;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);

  IPPStest;

  if src=dest
    then srcX:=Tmatrix(src.clone(true))
    else srcX:=src;

  TRY

  Mmodify(dest,dest.tpNum,src.Istart,src.Iend,src.Jstart,src.Jend);
  McopyXYscale(src,dest);

  {cas ISPL}
  if src.inf.temp and (src.tpNum=G_single) and (dest.tpNum=G_single)
    then ippsSqr_32f(srcX.tbS,dest.tbS,src.Kcount)
  else
  if src.inf.temp and (src.tpNum=G_double) and (dest.tpNum=G_double)
    then ippsSqr_64f(srcX.tbD,dest.tbD,src.Kcount)
  else
  if src.inf.temp and (src.tpNum=G_singleComp) and (dest.tpNum=G_single)
    then ippsPowerSpectr_32fc(srcX.tbSC,dest.tbS,src.Kcount)
  else
  if src.inf.temp and (src.tpNum=G_doubleComp) and (dest.tpNum=G_double)
    then ippsPowerSpectr_64fc(srcX.tbDC,dest.tbD,src.Kcount)
  else
  {cas complexes non ISPL}
  if src.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
      for j:=src.Jstart to src.Jend do
        dest.Zvalue[i,j]:=mdlCpx2(srcX.cpxValue[i,j]);
    end
  {cas non complexes}
  else
    begin
      for i:=src.Istart to src.Iend do
      for j:=src.Jstart to src.Jend do
        dest.Zvalue[i,j]:=sqr(srcX.ZValue[i,j]);
    end;

  FINALLY
  IPPSend;
  if src=dest then srcX.free;
  END;
end;


procedure proMinv1(var src,dest:Tmatrix;th:float);
var
  i,j:integer;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);

  IPPStest;

  TRY

  Mmodify(dest,dest.tpNum,src.Istart,src.Iend,src.Jstart,src.Jend);
  McopyXYscale(src,dest);

  {cas ISPL}
  if src.inf.temp and (src.tpNum=G_single) and (dest.tpNum=G_single) then
    begin
      if src=dest
        then ippsThreshold_LTinv_32f_I(src.tbS,src.Kcount,th)
        else ippsThreshold_LTinv_32f(src.tbS,dest.tb,src.Kcount,th);
    end
  else
  if src.inf.temp and (src.tpNum=G_double) and (dest.tpNum=G_double) then
    begin
      if src=dest
        then ippsThreshold_LTinv_64f_I(src.tbD,src.Kcount,th)
        else ippsThreshold_LTinv_64f(src.tbD,dest.tbD,src.Kcount,th);
    end
  else
  if src.inf.temp and (src.tpNum=G_singleComp) and (dest.tpNum=G_singleComp) then
    begin
      if src=dest
        then ippsThreshold_LTinv_32fc_I(src.tbSC,src.Kcount,th)
        else ippsThreshold_LTinv_32fc(src.tbSC,dest.tbSC,src.Kcount,th);
    end
  else
  if src.inf.temp and (src.tpNum=G_doubleComp) and (dest.tpNum=G_doubleComp) then
    begin
      if src=dest
        then ippsThreshold_LTinv_64fc_I(src.tbDC,src.Kcount,th)
        else ippsThreshold_LTinv_64fc(src.tbDC,dest.tbDC,src.Kcount,th);
    end
  else
  {cas complexes non ISPL}
  if src.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
      for j:=src.Jstart to src.Jend do
        if mdlCpx(src.cpxValue[i,j])>=th then
          dest.Cpxvalue[i,j]:=invCpx(src.cpxValue[i,j]);
    end
  {cas non complexes}
  else
    begin
      for i:=src.Istart to src.Iend do
      for j:=src.Jstart to src.Jend do
        if abs(src.ZValue[i,j])>=th then
          dest.Zvalue[i,j]:=1/src.ZValue[i,j];
    end;

  FINALLY
  IPPSend;
  END;
end;

procedure proMinv(var src,dest:Tmatrix);
begin
  proMinv1(src,dest,0);
end;


procedure proMChangeType(var src,dest:Tmatrix;tp:integer);
var
  i:integer;
  tp1:typetypeG absolute tp;
  src1:Tmatrix;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);

  if dest=src
    then src1:=Tmatrix(src.clone(true))
    else src1:=src;

  try
    Mmodify(dest,tp1,src.Istart,src.Iend,src.Jstart,src.Jend);
    ProMcopy1(src1,dest);
  finally
    if dest=src then src1.Free;
  end;
end;


{ On ajoute num au vecteur
  Si src est réel et num complexe, seule la partie réelle de num est ajoutée.
}
procedure proMaddNum(var src:Tmatrix; num:TfloatComp);
var
  i,j:integer;
  tp:typetypeG;
  zs:TSingleComp;
  zd:TDoubleComp;
begin
  VerifierMatrice(src);

  IPPStest;

  TRY

  {cas ISPL}
  if (src.tpNum in [G_single,G_double,G_singleComp, G_doubleComp]) then
    case src.tpnum of
      G_single:       ippsAddC_32f_I(num.x,src.tbS,src.Kcount);
      G_double:       ippsAddC_64f_I(num.x,src.tbD,src.Kcount);
      G_singleComp: begin
                      zs.x:=num.x;
                      zs.y:=num.y;
                      ippsAddC_32fc_I(zs,src.tbSC,src.Kcount);
                    end;
      G_doubleComp: begin
                      zd.x:=num.x;
                      zd.y:=num.y;
                      ippsAddC_64fc_I(zd,src.tbDC,src.Kcount);
                    end;
    end
  else
  {cas complexes non ISPL}
  if src.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
      for j:=src.Jstart to src.Jend do
        src.CpxValue[i,j]:=sumCpx(src.cpxValue[i,j],num);
    end
  {cas non complexes}
  else
    begin
      for i:=src.Istart to src.Iend do
      for j:=src.Jstart to src.Jend do
        src.Zvalue[i,j]:=src.ZValue[i,j]+num.x;
    end;

  FINALLY
  IPPSend;
  END;
end;

procedure proMmulNum(var src:Tmatrix; num:TfloatComp);
var
  i,j:integer;
  tp:typetypeG;
  zs:TsingleComp;
  zd:TDoubleComp;
begin
  VerifierMatrice(src);

  IPPStest;

  TRY

  {cas ISPL}
  if (src.tpNum in [G_single,G_double,G_singleComp, G_doubleComp]) then
    case src.tpnum of
      G_single:       ippsMulC_32f_I(num.x,src.tbS,src.Kcount);
      G_double:       ippsMulC_64f_I(num.x,src.tbD,src.Kcount);
      G_singleComp: begin
                      zs.x:=num.x;
                      zs.y:=num.y;
                      ippsMulC_32fc_I(zs,src.tbSC,src.Kcount);
                    end;
      G_doubleComp: begin
                      zd.x:=num.x;
                      zd.y:=num.y;
                      ippsMulC_64fc_I(zd,src.tbDC,src.Kcount);
                    end;
    end
  else
  {cas complexes non ISPL}
  if src.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
      for j:=src.Jstart to src.Jend do
        src.CpxValue[i,j]:=ProdCpx(src.cpxValue[i,j],num);
    end
  {cas non complexes}
  else
    begin
      for i:=src.Istart to src.Iend do
      for j:=src.Jstart to src.Jend do
        src.Zvalue[i,j]:=src.ZValue[i,j] * num.x;
    end;

  FINALLY
  IPPSend;
  END;
end;

function MaxType(t1,t2:typetypeG): typetypeG;
begin
  if t1>t2
    then result:=t1
    else result:=t2;
end;


procedure verifierX(v1,v2:Tmatrix);
begin
  if not ((v1.IStart=v2.Istart) and
          (v1.Iend=v2.Iend) and
          (v1.dxu=v2.dxu) and
          (v1.x0u=v2.x0u) and
          (v1.JStart=v2.Jstart) and
          (v1.Jend=v2.Jend) and
          (v1.dyu=v2.dyu) and
          (v1.y0u=v2.y0u)
          )
    then sortieErreur('matrix must have the same dimensions');
end;

procedure proMadd(var src1,src2,dest:Tmatrix);
var
  i,j:integer;
begin
  VerifierMatrice(src1);
  VerifierMatrice(src2);
  VerifierMatrice(dest);

  VerifierX(src1,src2);

  IPPStest;

  TRY

  if (src1<>dest) and (src2<>dest)
    then Mmodify(dest,dest.tpNum,src1.Istart,src1.Iend,src1.Jstart,src1.Jend);

  McopyXYscale(src1,dest);

  {cas ISPL}
  if src1.inf.temp and (src1.tpNum=src2.tpNum) and (src1.tpNum=dest.tpNum)
     and (src1.tpNum in [G_single,G_double,G_singleComp, G_doubleComp]) then
  begin
    if (src1<>dest) and (src2<>dest) then
    case src1.tpNum of
      G_single:      ippsAdd_32f(src1.tbS,src2.tbS,dest.tbS,src1.Kcount);
      G_double:      ippsAdd_64f(src1.tbD,src2.tbD,dest.tbD,src1.Kcount);
      G_singleComp:  ippsAdd_32fc(src1.tbSC,src2.tbSC,dest.tbSC,src1.Kcount);
      G_doubleComp:  ippsAdd_64fc(src1.tbDC,src2.tbDC,dest.tbDC,src1.Kcount);
    end
    else
    if (src1=dest) then
    case src1.tpNum of
      G_single:      ippsAdd_32f_I(src2.tbS,dest.tbS,src1.Kcount);
      G_double:      ippsAdd_64f_I(src2.tbD,dest.tbD,src1.Kcount);
      G_singleComp:  ippsAdd_32fc_I(src2.tbSC,dest.tbSC,src1.Kcount);
      G_doubleComp:  ippsAdd_64fc_I(src2.tbDC,dest.tbDC,src1.Kcount);
    end
    else
    if (src2=dest) then
    case src1.tpNum of
      G_single:      ippsAdd_32f_I(src1.tbS,dest.tbS,src1.Kcount);
      G_double:      ippsAdd_64f_I(src1.tbD,dest.tbD,src1.Kcount);
      G_singleComp:  ippsAdd_32fc_I(src1.tbSC,dest.tbSC,src1.Kcount);
      G_doubleComp:  ippsAdd_64fc_I(src1.tbDC,dest.tbDC,src1.Kcount);
    end
  end
  else
  {cas complexes non ISPL}
  if dest.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src1.Istart to src1.Iend do
      for j:=src1.Jstart to src1.Jend do
        dest.Cpxvalue[i,j]:=sumCpx(src1.cpxValue[i,j],src2.cpxValue[i,j]) ;
    end
  {cas non complexes}
  else
    begin
      for i:=src1.Istart to src1.Iend do
      for j:=src1.Jstart to src1.Jend do
        dest.Zvalue[i,j]:=src1.ZValue[i,j] + src2.ZValue[i,j];
    end;

  FINALLY
  IPPSend;
  END;
end;

procedure proMsub(var src1,src2,dest:Tmatrix);
var
  i,j:integer;
begin
  VerifierMatrice(src1);
  VerifierMatrice(src2);
  VerifierMatrice(dest);

  VerifierX(src1,src2);

  IPPStest;

  TRY

  if (src1<>dest) and (src2<>dest)
    then Mmodify(dest,dest.tpNum,src1.Istart,src1.Iend,src1.Jstart,src1.Jend);
  McopyXYscale(src1,dest);

  {cas ISPL}
   if src1.inf.temp and (src1.tpNum=src2.tpNum) and (src1.tpNum=dest.tpNum)
     and (src1.tpNum in [G_single,G_double,G_singleComp, G_doubleComp]) then
  begin
    if (src1<>dest) and (src2<>dest) then
    case src1.tpNum of
      G_single:      ippsSub_32f(src2.tbS,src1.tbS,dest.tbS,src1.Kcount);
      G_double:      ippsSub_64f(src2.tbD,src1.tbD,dest.tbD,src1.Kcount);
      G_singleComp:  ippsSub_32fc(src2.tbSC,src1.tbSC,dest.tbSC,src1.Kcount);
      G_doubleComp:  ippsSub_64fc(src2.tbDC,src1.tbDC,dest.tbDC,src1.Kcount);
    end
    else
    if (src1=dest) then
    case src1.tpNum of
      G_single:      ippsSub_32f_I(src2.tbS,dest.tbS,src1.Kcount);
      G_double:      ippsSub_64f_I(src2.tbD,dest.tbD,src1.Kcount);
      G_singleComp:  ippsSub_32fc_I(src2.tbSC,dest.tbSC,src1.Kcount);
      G_doubleComp:  ippsSub_64fc_I(src2.tbDC,dest.tbDC,src1.Kcount);
    end
    else
    if (src2=dest) then
    case src1.tpNum of
      G_single:      begin
                       ippsSub_32f_I(src1.tbS,dest.tbS,src1.Kcount);
                       ippsMulC_32f_I(-1,dest.tbS,src1.Kcount);
                     end;
      G_double:      begin
                       ippsSub_64f_I(src1.tbD,dest.tbD,src1.Kcount);
                       ippsMulC_64f_I(-1,dest.tbD,src1.Kcount);
                     end;
      G_singleComp:  begin
                       ippsSub_32fc_I(src1.tbSC,dest.tbSC,src1.Kcount);
                       ippsMulC_32fc_I(singleComp(-1,0),dest.tbSC,src1.Kcount);
                     end;
      G_doubleComp:  begin
                       ippsSub_64fc_I(src1.tbDC,dest.tbDC,src1.Kcount);
                       ippsMulC_64fc_I(doubleComp(-1,0),dest.tbDC,src1.Kcount);
                     end;
    end
  end
  else
  {cas complexes non ISPL}
  if src1.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src1.Istart to src1.Iend do
      for j:=src1.Jstart to src1.Jend do
        dest.Cpxvalue[i,j]:=DiffCpx(src1.cpxValue[i,j],src2.cpxValue[i,j]) ;
    end
  {cas non complexes}
  else
    begin
      for i:=src1.Istart to src1.Iend do
      for j:=src1.Jstart to src1.Jend do
        dest.Zvalue[i,j]:=src1.ZValue[i,j] - src2.ZValue[i,j];
    end;

  FINALLY
  IPPSend;
  END;
end;



procedure proMmul(var src1,src2,dest:Tmatrix);
var
  i,j:integer;
begin
  VerifierMatrice(src1);
  VerifierMatrice(src2);
  VerifierMatrice(dest);

  VerifierX(src1,src2);

  IPPStest;

  TRY

  if (src1<>dest) and (src2<>dest)
    then Mmodify(dest,dest.tpNum,src1.Istart,src1.Iend,src1.Jstart,src1.Jend);
  McopyXYscale(src1,dest);

  {cas ISPL}
   if src1.inf.temp and (src1.tpNum=src2.tpNum) and (src1.tpNum=dest.tpNum)
     and (src1.tpNum in [G_single,G_double,G_singleComp, G_doubleComp]) then
  begin
    if (src1<>dest) and (src2<>dest) then
    case src1.tpNum of
      G_single:      ippsMul_32f(src1.tbS,src2.tbS,dest.tbS,src1.Kcount);
      G_double:      ippsMul_64f(src1.tbD,src2.tbD,dest.tbD,src1.Kcount);
      G_singleComp:  ippsMul_32fc(src1.tbSC,src2.tbSC,dest.tbSC,src1.Kcount);
      G_doubleComp:  ippsMul_64fc(src1.tbDC,src2.tbDC,dest.tbDC,src1.Kcount);
    end
    else
    if (src1=dest) then
    case src1.tpNum of
      G_single:      ippsMul_32f_I(src2.tbS,dest.tbS,src1.Kcount);
      G_double:      ippsMul_64f_I(src2.tbD,dest.tbD,src1.Kcount);
      G_singleComp:  ippsMul_32fc_I(src2.tbSC,dest.tbSC,src1.Kcount);
      G_doubleComp:  ippsMul_64fc_I(src2.tbDC,dest.tbDC,src1.Kcount);
    end
    else
    if (src2=dest) then
    case src1.tpNum of
      G_single:      ippsMul_32f_I(src1.tbS,dest.tbS,src1.Kcount);
      G_double:      ippsMul_64f_I(src1.tbD,dest.tbD,src1.Kcount);
      G_singleComp:  ippsMul_32fc_I(src1.tbSC,dest.tbSC,src1.Kcount);
      G_doubleComp:  ippsMul_64fc_I(src1.tbDC,dest.tbDC,src1.Kcount);
    end
  end
  else
  {cas complexes non ISPL}
  if src1.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src1.Istart to src1.Iend do
      for j:=src1.Jstart to src1.Jend do
        dest.Cpxvalue[i,j]:=prodCpx(src1.cpxValue[i,j],src2.cpxValue[i,j]) ;
    end
  {cas non complexes}
  else
    begin
      for i:=src1.Istart to src1.Iend do
      for j:=src1.Jstart to src1.Jend do
        dest.Zvalue[i,j]:=src1.ZValue[i,j] * src2.ZValue[i,j];
    end;

  FINALLY
  IPPSend;
  END;
end;

procedure proMmulConj(var src1,src2,dest:Tmatrix);
var
  i,j:integer;
begin
  VerifierMatrice(src1);
  VerifierMatrice(src2);
  VerifierMatrice(dest);

  VerifierX(src1,src2);

  IPPStest;

  TRY

  if (src1<>dest) and (src2<>dest)
    then Mmodify(dest,dest.tpNum,src1.Istart,src1.Iend,src1.Jstart,src1.Jend);
  McopyXYscale(src1,dest);

  {cas ISPL}
   if src1.inf.temp and (src1.tpNum=src2.tpNum) and (src1.tpNum=dest.tpNum)
     and (src1<>dest) and (src2<>dest)
     and (src1.tpNum in [G_singleComp, G_doubleComp]) then
  begin
    case src1.tpNum of
      G_singleComp:  begin
                       ippsConj_32fc(Src2.tbSC,Dest.tbSC,src1.Kcount);
                       ippsMul_32fc_I(src1.tbSC,dest.tbSC,src1.Kcount);
                     end;
      G_doubleComp:  begin
                       ippsConj_64fc(Src2.tbDC,Dest.tbDC,src1.Kcount);
                       ippsMul_64fc_I(src1.tbDC,dest.tbDC,src1.Kcount);
                     end;
    end
  end
  else
  {cas ISPL}
  if src1.isComplex or src2.isComplex then
    begin
      for i:=src1.Istart to src1.Iend do
      for j:=src1.Jstart to src1.Jend do
        dest.Cpxvalue[i,j]:=ProdZ1conjZ2(src1.cpxValue[i,j],src2.cpxValue[i,j]) ;
    end
  {cas non complexes}
  else
    begin
      for i:=src1.Istart to src1.Iend do
      for j:=src1.Jstart to src1.Jend do
        dest.Zvalue[i,j]:=src1.ZValue[i,j] * src2.ZValue[i,j];
    end;

  FINALLY
  IPPSend;
  END;
end;



procedure proMdiv(var src1,src2,dest:Tmatrix);
var
  mat:Tmatrix;
begin
  verifierMatrice(src1);
  verifierMatrice(src2);
  verifierMatrice(dest);

  mat:=nil;
  try
  if (src1=dest) or (src2=dest)
    then mat:=Tmatrix(src2.clone(false))
    else mat:=dest;

  proMinv(src2,mat);
  proMmul(src1,mat,dest);

  finally
  if (src1=dest) or (src2=dest) then mat.free;
  end;
end;

procedure proMdiv1(var src1,src2,dest:Tmatrix;th:float;Vr:TfloatComp);
var
  mat:Tmatrix;
  i,j:integer;
  w1,w2:TfloatComp;
  z1,z2:float;
begin
  verifierMatrice(src1);
  verifierMatrice(src2);
  verifierMatrice(dest);

  if (src1<>dest) and (src2<>dest)
    then Mmodify(dest,dest.tpNum,src1.Istart,src1.Iend,src1.Jstart,src1.Jend);
  McopyXYscale(src1,dest);

  with dest do
  if dest.isComplex then
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
  begin
    w1:=src1.cpxValue[i,j];
    w2:=src2.cpxValue[i,j];
    if mdlCpx(w2)>=th
      then dest.CpxValue[i,j]:=divCpx(w1,w2)
      else dest.CpxValue[i,j]:=Vr;
  end
  else
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
  begin
    z1:=src1.ZValue[i,j];
    z2:=src2.ZValue[i,j];
    if abs(z2)>=th
      then dest.ZValue[i,j]:=z1/z2
      else dest.ZValue[i,j]:=Vr.x;
  end;

end;


procedure ProMrotate90(var src,dest:Tmatrix;nb:integer);
var
  i,j:integer;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);
  RefuseSrcEqDest(src,dest);

  if nb mod 2=0 then
  begin
    Mmodify(dest,src.tpNum,src.Istart,src.Iend,src.Jstart,src.Jend);
    McopyXYscale(src,dest);
  end
  else
  begin
    Mmodify(dest,src.tpNum,src.Jstart,src.Jend,src.Istart,src.Iend);

    dest.dxu:=src.dyu;
    dest.x0u:=src.y0u;
    dest.unitX:=src.unitY;

    dest.dyu:=src.dxu;
    dest.y0u:=src.x0u;
    dest.unitY:=src.unitX;
  end;

  nb:=nb mod 4;
  if nb<0 then nb:=nb+4;

  with dest do
  if tpNum<G_singleComp then
  case nb of
    0:  for i:=Istart to Iend do
        for j:=Jstart to Jend do
          Zvalue[i,j]:=src.ZValue[i,j];

    1:  for i:=Istart to Iend do
        for j:=Jstart to Jend do
          Zvalue[i,j]:=src.ZValue[Jend-j+Jstart,i];

    2:  for i:=Istart to Iend do
        for j:=Jstart to Jend do
          Zvalue[i,j]:=src.ZValue[Iend-i+Istart,Jend-j+Jstart];

    3:  for i:=Istart to Iend do
        for j:=Jstart to Jend do
          Zvalue[i,j]:=src.ZValue[j,Iend-i+Istart];
  end
  else
  case nb of
    0:  for i:=Istart to Iend do
        for j:=Jstart to Jend do
          CpxValue[i,j]:=src.CpxValue[i,j];

    1:  for i:=Istart to Iend do
        for j:=Jstart to Jend do
          CpxValue[i,j]:=src.CpxValue[Jend-j+Jstart,i];

    2:  for i:=Istart to Iend do
        for j:=Jstart to Jend do
          CpxValue[i,j]:=src.CpxValue[Iend-i+Istart,Jend-j+Jstart];

    3:  for i:=Istart to Iend do
        for j:=Jstart to Jend do
          CpxValue[i,j]:=src.CpxValue[j,Iend-i+Istart];
  end;

end;

procedure ProMtranspose(var src,dest:Tmatrix);
var
  i,j:integer;
  srcX:Tmatrix;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);

  if (src=dest) and src.isSquare then
  begin
    src.transposeM2;
    exit;
  end;

  if src=dest
    then srcX:=Tmatrix(src.clone(true))
    else srcX:=src;

  try
  Mmodify(dest,src.tpNum,src.Jstart,src.Jend,src.Istart,src.Iend);

  dest.dxu:=src.dyu;
  dest.x0u:=src.y0u;
  dest.unitX:=src.unitY;

  dest.dyu:=src.dxu;
  dest.y0u:=src.x0u;
  dest.unitY:=src.unitX;

  if src.tpNum<G_singleComp then
    with dest do
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
      Zvalue[i,j]:=srcX.Zvalue[j,i]

  else
    with dest do
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
      Cpxvalue[i,j]:=srcX.Cpxvalue[j,i];

  finally
    if src=dest then srcX.Free;
  end;

end;


procedure proMsup(var src1,src2,dest:Tmatrix);
var
  i,j:integer;
  y1,y2:float;
  z1,z2:TFloatComp;
begin
  VerifierMatrice(src1);
  VerifierMatrice(src2);
  VerifierMatrice(dest);

  VerifierX(src1,src2);

  if (src1<>dest) and (src2<>dest)
    then Mmodify(dest,dest.tpNum,src1.Istart,src1.Iend,src1.Jstart,src1.Jend);
  McopyXYscale(src1,dest);

  for i:=src1.Istart to src1.Iend do
  for j:=src1.Jstart to src1.Jend do
  begin
    y1:=src1.ZValue[i,j];
    y2:=src2.ZValue[i,j];
    if y1>y2
      then dest.Zvalue[i,j]:=y1
      else dest.Zvalue[i,j]:=y2;
  end;
end;


procedure proMsup1(var src1,src2,dest:Tmatrix);
var
  i,j:integer;
  y1,y2:float;
  z1,z2:TFloatComp;
begin
  VerifierMatrice(src1);
  VerifierMatrice(src2);
  VerifierMatrice(dest);

  VerifierX(src1,src2);

  if (src1<>dest) and (src2<>dest)
    then Mmodify(dest,dest.tpNum,src1.Istart,src1.Iend,src1.Jstart,src1.Jend);
  McopyXYscale(src1,dest);

  for i:=src1.Istart to src1.Iend do
  for j:=src1.Jstart to src1.Jend do
  begin
    y1:=src1.ZValue[i,j];
    y2:=src2.ZValue[i,j];
    if y1>y2
      then dest.Zvalue[i,j]:=y1
      else dest.Zvalue[i,j]:=-y2;
  end;
end;

procedure proMsup2(var src,dest,destLat:Tmatrix;tt:float);
var
  i,j:integer;
  y1,y2:float;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);
  VerifierMatrice(destLat);

  RefuseSrcEqDest(src,dest);
  RefuseSrcEqDest(src,destLat);
  VerifierX(src,dest);
  VerifierX(src,destLat);

  for i:=src.Istart to src.Iend do
  for j:=src.Jstart to src.Jend do
  begin
    y1:=src.ZValue[i,j];
    y2:=dest.ZValue[i,j];
    if y1>y2 then
    begin
      dest.Zvalue[i,j]:=y1;
      destLat.Zvalue[i,j]:=tt;
    end;
  end;
end;

procedure proMinter(var src1,src2,dest:Tmatrix;seuil:float);
var
  i,j:integer;
  y1,y2:float;
  z1,z2:TFloatComp;
begin
  VerifierMatrice(src1);
  VerifierMatrice(src2);
  VerifierMatrice(dest);

  VerifierX(src1,src2);

  if (src1<>dest) and (src2<>dest)
    then Mmodify(dest,dest.tpNum,src1.Istart,src1.Iend,src1.Jstart,src1.Jend);
  McopyXYscale(src1,dest);

  for i:=src1.Istart to src1.Iend do
  for j:=src1.Jstart to src1.Jend do
  begin
    y1:=src1.ZValue[i,j];
    y2:=src2.ZValue[i,j];
    if (y1>=seuil) and (y2>=seuil)
      then dest.Zvalue[i,j]:=1
      else dest.Zvalue[i,j]:=0;
  end;
end;

procedure JPevt(src1,src2:TVlist;Vdate:Tvector;dest:Tmatrix; mode:integer);
var
  jp:Tjpsth;
  pst1,pst2:Tpsth;
  pstc1,pstc2:Tpsth;
  i,j:integer;
  nbs:integer;
  w:float;
begin
  jp:=Tjpsth.create;
  with dest do
  begin
    jp.initTemp(Istart,Iend,Jstart,Jend,g_longint);
    jp.Dxu:=Dxu;
    jp.Dyu:=Dyu;
  end;

  pst1:=Tpsth.create;
  pst1.initTemp(dest.Istart,dest.Iend,g_longint,dest.dxu);

  pst2:=Tpsth.create;
  pst2.initTemp(dest.Jstart,dest.Jend,g_longint,dest.dxu);

  if mode=3 then
  begin
    pstc1:=Tpsth.create;
    pstc1.initTemp(dest.Istart,dest.Iend,g_longint,dest.dxu);

    pstc2:=Tpsth.create;
    pstc2.initTemp(dest.Jstart,dest.Jend,g_longint,dest.dxu);
  end;

  nbs:=src1.count;

  try
    for i:=1 to nbs do
    begin
      jp.addex(src1.Vectors[i],src2.Vectors[i],Vdate[i]);
      pst1.addex(src1.Vectors[i],Vdate[i]);
      pst2.addex(src2.Vectors[i],Vdate[i]);

      if mode=3 then
      begin
        pstc1.AddSqrEx(src1.Vectors[i],Vdate[i]);
        pstc2.AddSqrEx(src2.Vectors[i],Vdate[i]);
      end;
    end;

    with dest do
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
      Zvalue[i,j]:=jp[i,j]/nbs;

    if mode>1 then
    with dest do
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
      Zvalue[i,j]:=Zvalue[i,j]-pst1[i]*pst2[j]/nbs/nbs;

    if mode=3 then
    with dest do
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
    begin
      w:=sqrt( (pstc1[i]/nbs-sqr(pst1[i]/nbs))*(pstc2[j]/nbs-sqr(pst2[j]/nbs)) );
      if w>0 then Zvalue[i,j]:=Zvalue[i,j]/w;
    end;

  finally
    jp.Free;
    pst1.free;
    pst2.free;

    if mode=3 then
    begin
      pstc1.Free;
      pstc2.free;
    end;
  end;
end;

procedure JPcont(src1,src2:TVlist;Vdate:Tvector;dest:Tmatrix;mode:integer);
var
  pst1,pst2:Taverage;
  i,j:integer;
  i0:integer;
  mm:Tmatrix;
  nbs:integer;
  w:float;
  ps1,ps2:PtabSingle;
  pd1,pd2:array of double;
begin
  pst1:=Taverage.create;
  pst1.initTemp1(dest.Istart,dest.Iend,g_double);
  pst1.dxu:=src1.Vectors[1].dxu;
  if mode=3 then pst1.stdOn:=true;

  pst2:=Taverage.create;
  pst2.initTemp1(dest.Istart,dest.Iend,g_double);
  pst2.dxu:=src1.Vectors[1].dxu;
  if mode=3 then pst2.stdOn:=true;

  nbs:=src1.count;

  mm:=Tmatrix.create;
  with dest do
  begin
    mm.initTemp(Istart,Iend,Jstart,Jend,g_double);
    mm.Dxu:=Dxu;
    mm.Dyu:=Dyu;
  end;

  setLength(pd1,dest.Icount);
  setLength(pd2,dest.Icount);

  try
    for i:=1 to nbs do
    begin
      pst1.addex1(src1.Vectors[i],Vdate[i]);
      pst2.addex1(src2.Vectors[i],Vdate[i]);

      with src1.Vectors[i] do
      begin
        i0:=invconvx(Vdate[i]);
        if (i0<Istart) or (i0+dest.Icount-1>Iend) then sortieErreur('JPcov : bad date');
      end;

      ps1:=src1.Vectors[i].data.getP(i0);
      for j:=0 to dest.Icount-1 do
        pd1[j]:=ps1^[j];

      ps2:=src2.Vectors[i].data.getP(i0);
      for j:=0 to dest.Icount-1 do
        pd2[j]:=ps2^[j];

      dger(dest.Icount,dest.Jcount,1,
           @pd1[0],1,
           @pd2[0],1,
           mm.tb,dest.Icount);

    end;

    with dest do
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
      Zvalue[i,j]:=mm[j,i]/nbs;

    if mode>1 then
    with dest do
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
      Zvalue[i,j]:=Zvalue[i,j] -pst1[i]*pst2[j];

    if mode=3 then
    with dest do
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
    begin
      w:=sqrt( (pst1.Sqrs[i]/nbs-sqr(pst1[i]))*(pst2.Sqrs[j]/nbs-sqr(pst2[j])) );
      if w>0 then Zvalue[i,j]:=Zvalue[i,j]/w;
    end;

  finally
    mm.Free;
    pst1.free;
    pst2.free;
  end;
end;


procedure JPmixte(src1,src2:TVlist;Vdate:Tvector;dest:Tmatrix;mode:integer);
var
  pst0:Tpsth;
  pst1,pst2:Taverage;
  i,j:integer;
  i0:integer;
  mm:Tmatrix;
  nbs:integer;
  w,w1,w2:float;

  ps:PtabSingle;
  pd:array of double;
begin
  pst0:=Tpsth.create;
  pst0.initTemp(dest.Istart,dest.Iend,g_double,dest.dxu);

  pst1:=Taverage.create;
  pst1.initTemp1(dest.Istart,dest.Iend,g_double);
  pst1.dxu:=dest.dxu;
  if mode=3 then pst1.stdOn:=true;

  pst2:=Taverage.create;
  pst2.initTemp1(dest.Jstart,dest.Jend,g_double);
  pst2.dxu:=dest.dxu;
  if mode=3 then pst2.stdOn:=true;

  nbs:=src1.count;

  mm:=Tmatrix.create;
  with dest do
  begin
    mm.initTemp(Istart,Iend,Jstart,Jend,g_double);
  end;

  setLength(pd,dest.Icount);

  try
    for i:=1 to nbs do
    begin
      pst0.clear;
      pst0.addex(src1.Vectors[i],Vdate[i]);

      pst1.add1(pst0);
      pst2.addex1(src2.Vectors[i],Vdate[i]);

      i0:=src2.Vectors[i].invconvx(Vdate[i]);

      ps:=src2.Vectors[i].data.getP(i0);
      if assigned(ps) then
      begin
        for j:=0 to dest.Icount-1 do
          pd[j]:=ps^[j];

        dger(dest.Icount,dest.Jcount,1,
             pst0.tb,1,
             @pd[0],1,
             mm.tb,pst0.Icount);
      end;
    end;

    with dest do
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
      Zvalue[i,j]:=mm[j,i]/nbs;

    if mode>1 then
    with dest do
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
      Zvalue[i,j]:=Zvalue[i,j] -pst1[i]*pst2[j];

    IPPSend;
    if mode=3 then
    with dest do
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
    begin
      try
        w1:=(pst1.Sqrs[i]/nbs-sqr(pst1[i]));
        w2:=(pst2.Sqrs[j]/nbs-sqr(pst2[j])) ;
        w:=w1*w2 ;
        w:=sqrt(w);
      except
      w:=0;
      end;
      if w>0 then Zvalue[i,j]:=Zvalue[i,j]/w;
    end;

  finally
    mm.Free;
    pst0.free;
    pst1.free;
    pst2.free;
  end;
end;

procedure proJPcov(var src1,src2:TVlist;var Vdate:Tvector;var dest:Tmatrix;evt1,evt2:boolean;mode:integer);
var
  i:integer;
begin
  verifierObjet(typeUO(src1));
  verifierObjet(typeUO(src2));
  verifierVecteur(Vdate);
  verifierMatrice(dest);

  if (src1.count<1) or (src2.count<>src1.count)
    then sortieErreur('JPcov : invalid vector count');
  if (Vdate.Icount<src1.Count)
    then sortieErreur('JPcov : Vdate has not enough values ');


  with src1 do
  for i:=2 to count do
  begin
    if not evt1 and ((vectors[i].Istart<>vectors[1].Istart) or
                     (vectors[i].Iend<>vectors[1].Iend) or
                     (vectors[i].tpnum<>g_single) )
         then sortieErreur('JPcov : bad vector in src1 ');
  end;

  with src2 do
  for i:=2 to count do
  begin
    if not evt2 and ((vectors[i].Istart<>vectors[1].Istart) or
                     (vectors[i].Iend<>vectors[1].Iend) or
                     (vectors[i].tpnum<>g_single) )
         then sortieErreur('JPcov : bad vector in src2 ');
  end;

  if (mode<1) or (mode>3) then sortieErreur('JPcov : invalid mode');

  if evt1 and evt2 then JPevt(src1,src2,Vdate,dest,mode)
  else
  if not evt1 and not evt2 then JPcont(src1,src2,Vdate,dest,mode)
  else
  if evt1 and not evt2 then JPmixte(src1,src2,Vdate,dest,mode)
  else
  begin
    JPmixte(src2,src1,Vdate,dest,mode);
    dest.TransposeM2;
  end;

end;


function fonctionMdotProd(var src1,src2:Tmatrix):TfloatComp;
var
  i,j:integer;
  ss:single;
  dd:double;
  sc: TsingleComp;
  dc:TdoubleComp;
begin
  verifierObjet(typeUO(src1));
  verifierObjet(typeUO(src2));

  VerifierX(src1,src2);
  IPPStest;

  TRY

  {cas ISPL}
  if src1.inf.temp and (src1.tpNum=src2.tpNum) and (src1.tpNum in [G_single,G_double,G_singleComp, G_doubleComp]) then
    case src1.tpNum of
      G_single:      begin
                        ippsDotProd_32f64f(Src1.tbS, Src2.tbS, src1.Icount,Pdouble(@dd));
                        result.x:=dd;
                        result.y:=0;
                     end;
      G_double:      begin
                        ippsDotProd_64f(Src1.tbD, Src2.tbD, src1.Icount,Pdouble(@dd));
                        result.x:=dd;
                        result.y:=0;
                     end;

      G_singleComp:  begin
                        ippsDotProd_32fc64fc(Src1.tbSC, Src2.tbSC, src1.Icount,PdoubleComp(@dc));
                        result.x:=dc.x;
                        result.y:=dc.y;
                     end;
      G_doubleComp:  begin
                        ippsDotProd_64fc(Src1.tbDC, Src2.tbDC, src1.Icount,PdoubleComp(@dc));
                        result.x:=dc.x;
                        result.y:=dc.y;
                     end;

    end

  else
  with src1 do
  begin
    result:=floatComp(0,0);
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
    begin
      result.x:=result.x+Zvalue[i,j]*src2.Zvalue[i,j];
      result.y:=result.x+Imvalue[i,j]*src2.Imvalue[i,j];
    end;
  end;

  finally
    IPPSend;
  end;
end;

procedure proMDFT(var src,dest:Tmatrix;fwd:boolean);
var
  i,j:integer;
  tpDest:typetypeG;
  dim:array[1..2] of integer;
  Hdfti:pointer;
  res:integer;
  precision,forward_domain,dimension:integer;
  cfg:integer;
  w: double;
  tab:array[1..10] of integer;
begin
  VerifierMatrice(src);
  VerifierMatrice(dest);
  RefuseSrcEqDest(src,dest);

  MKLtest;

  if src.tpNum in [g_double,g_extended,g_doubleComp,g_extComp]
    then tpDest:=g_doubleComp
    else tpDest:=g_singleComp;

  TRY

  Mmodify(dest,tpdest,src.Istart,src.Iend,src.Jstart,src.Jend);
  McopyXYscale(src,dest);

  with src do
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
    dest.Zvalue[i,j]:=Zvalue[i,j];

  if src.isComplex then
  with src do
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
    dest.Imvalue[i,j]:=Imvalue[i,j]
  else
  with src do
  for i:=Istart to Iend do             // else ajouté septembre 2015
  for j:=Jstart to Jend do             // pb si calculs successifs
    dest.Imvalue[i,j]:= 0;

  dim[1]:=src.Jcount;
  dim[2]:=src.Icount;

  if tpdest=G_singleComp
    then precision:=dfti_single
    else precision:=dfti_double;

  forward_domain:=dfti_complex;
  dimension:=2;

  res:=DftiCreateDescriptor(Hdfti,precision,forward_domain,dimension,@Dim);
  if res<>0 then exit;

  // fillchar(tab,sizeof(tab),1);
  // res:=DftiGetValue(Hdfti,DFTI_LENGTHS,@tab);
  // messageCentral(Istr(tab[1])+'  '+Istr(tab[2])+'  '+Istr(tab[3])+'  ');
  if res<>0 then exit;

  res:= DftiSetValueI(Hdfti, DFTI_FORWARD_DOMAIN, DFTI_COMPLEX);

  if fwd then
  begin
    res:=DftiCommitDescriptor(Hdfti);
    if res<>0 then exit;
    res:=DftiComputeForward1(hdfti,dest.tb);
    if res<>0 then exit;
  end
  else
  begin
    w:=  1/(src.Icount*src.Jcount);

    if precision=dfti_double
      then res:=DftiSetValueD(hdfti,DFTI_BACKWARD_SCALE,w)
      else res:=DftiSetValueS(hdfti,DFTI_BACKWARD_SCALE,w);

    res:=DftiCommitDescriptor(Hdfti);

    //w:=111;
    //res:=DftiGetValue(hdfti,DFTI_BACKWARD_SCALE, @w);
    //messageCentral('w='+Estr(w,6));

    res:=DftiComputeBackward1(hdfti,dest.tb);
  end;

  DftiFreeDescriptor(hdfti);

  FINALLY
  MKLend;
  END;

end;


procedure proMresizeImage(var src,dest:Tmatrix; Dxf,x0f,Dyf,y0f:float; mode:integer);
var
  srcSize: IppiSize;
  srcROI,dstROI:IppiRect;
  pBuffer: pointer;
  size:integer;
begin
(*
  VerifierMatrice(src);
  VerifierMatrice(dest);
  RefuseSrcEqDest(src,dest);

  if (src.tpNum<>g_single) or (dest.tpNum<>g_single) then exit;

  srcSize.width:= src.Jcount*4;
  srcSize.height:=src.Icount*4;

  with srcROI do
  begin
    x:=0;
    y:=0;
    width:=src.Jcount;
    height:=src.Icount;
  end;

  with dstROI do
  begin
    x:=0;
    y:=0;
    width:=dest.Jcount;
    height:=dest.Icount;
  end;

 // sizes in bytes
 // steps in bytes
 // inverser X et Y à tous les niveaux

  ippitest;
  size:=0;
  if ippiResizeGetBufSize(srcROI,dstROI, 1 , {IPPI_INTER_LINEAR} mode, Size)=0 then
  try
    getmem(pBuffer,size*4);
    ippiResizeSqrPixel_32f_C1R( Src.tb, srcSize, src.Jcount*4, srcROI,
                                Dest.tb, dest.Jcount*4, dstROI,
                                Dyf, Dxf, y0f, x0f, {IPPI_INTER_LINEAR} mode, pBuffer);
  finally
    freemem(pBuffer);
  end;

  ippiEnd;
  *)
end;

procedure proMremapImage(var src,dest,Xmap,Ymap:Tmatrix; mode:integer);
var
  srcSize, dstSize: IppiSize;
  srcROI,dstROI:IppiRect;
  pBuffer: pointer;
  size:integer;
begin
(*
  VerifierMatrice(src);
  VerifierMatrice(dest);
  VerifierMatrice(Xmap);
  VerifierMatrice(Ymap);

  RefuseSrcEqDest(src,dest);

  if (src.tpNum<>g_single) or (dest.tpNum<>g_single) or (Xmap.tpNum<>g_single) or (Ymap.tpNum<>g_single)
    then sortieErreur('MremapImage : only single-type matrix are supported');

  if (dest.Istart<>Xmap.Istart) or (dest.Iend<>Xmap.Iend) or (dest.Jstart<>Xmap.Jstart) or (dest.Jend<>Xmap.Jend)
    then sortieErreur('MremapImage : Xmap bounds differ from src bounds');

  if (dest.Istart<>Ymap.Istart) or (dest.Iend<>Ymap.Iend) or (dest.Jstart<>Ymap.Jstart) or (dest.Jend<>Ymap.Jend)
    then sortieErreur('MremapImage : Ymap bounds differ from src bounds');

  srcSize.width:= src.Jcount;
  srcSize.height:=src.Icount;

  dstSize.width:= dest.Jcount;
  dstSize.height:=dest.Icount;

  with srcROI do
  begin
    x:=0;
    y:=0;
    width:=src.Jcount;
    height:=src.Icount;
  end;

  with dstROI do
  begin
    x:=0;
    y:=0;
    width:=dest.Jcount;
    height:=dest.Icount;
  end;

 // sizes in bytes
 // steps in bytes
 // inverser X et Y à tous les niveaux

  ippitest;
  size:=0;

  ippiRemap_32f_C1R( Src.tb, srcSize, src.Jcount*4, srcROI,
                     yMap.tb, xmap.Jcount*4,
                     xMap.tb, ymap.Jcount*4,
                     Dest.tb, dest.Jcount*4, dstsize,
                     mode);

  ippiEnd;
  *)
end;

procedure proBuildXTmapFromMatList(var src:TmatList;var dest:Tmatrix;FY,Fnorm:boolean;Zth:float;AgTh:integer);
var
  i,j,n:integer;
  w:double;
  min1,max1,min2,max2: float;
  Mdum:Tmatrix;
begin
  verifierObjet(typeUO(src));
  verifierObjet(typeUO(dest));
  if src.count<1 then exit;

  Mdum:= Tmatrix.create;
  TRY
  with src.mat[1] do Mdum.initTemp(Istart,Iend,Jstart,Jend, g_single);

  if FY
    then dest.modify(dest.tpNum,0,src.Mat[1].Istart,src.count-1,src.Mat[1].Iend)
    else dest.modify(dest.tpNum,0,src.Mat[1].Jstart,src.count-1,src.Mat[1].Jend);


  for n:=1 to src.count do
  begin
    Mdum.copyDataFrom(src.Mat[n]);
    if (Zth>0) and (AgTh>0) then Mdum.BuildCnxMap(ZTh,1,AgTh,true);
    
    with Mdum do
    if FY then
      for i:=Istart to Iend do       {Somme des colonnes }
      begin
        w:=0;
        for j:=Jstart to Jend do
          w:=w+Zvalue[i,j];
        dest.Zvalue[n-1,i]:=w;
      end
    else
      for j:=Jstart to Jend do       {Somme des lignes }
      begin
        w:=0;
        for i:=Istart to Iend do
          w:=w+Zvalue[i,j];
        dest.Zvalue[n-1,j]:=w;
      end;

  end;
  if Fnorm then
  begin
    min1:= 1E20;
    max1:=-1E20;
    src.getMinMax(min1,max1);
    min2:= 1E20;
    max2:=-1E20;
    dest.getMinMax(min2,max2);
    if abs(min1) > max1 then max1:= abs(min1);
    if abs(min2) > max2 then max2:= abs(min2);
    if max2>0 then w:=max1/max2;

    dest.mulnum(w);
  end;

  finally
  Mdum.Free;
  end;
end;

end.
