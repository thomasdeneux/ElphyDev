unit stmVecU1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1, Ncdef2,
     stmDef,stmObj,stmError,stmVec1,
     mathKernel0,
     ippdefs17, ipps17, debug0;

procedure proVcopy(var src,dest:Tvector);pascal;
procedure proVcopy1(var src,dest:Tvector);pascal;
procedure proVextract(var src:Tvector;x1,x2:float;var dest:Tvector);pascal;
procedure proVextract1(var src:Tvector;x1,x2:float;var dest:Tvector);pascal;
procedure proVextract0(var src:Tvector;x1,x2,x0:float;var dest:Tvector);pascal;

procedure ProVmoveData(var source:Tvector;x1,x2:float;var dest:Tvector;xd:float);pascal;
procedure proVappend(var src:Tvector;x1,x2:float;var dest:Tvector);pascal;


procedure proVrealPart(var src,dest:Tvector);pascal;
procedure proVimPart(var src,dest:Tvector);pascal;
procedure proVmodulus(var src,dest:Tvector);pascal;
procedure proVphase(var src,dest:Tvector);pascal;
procedure proVpower(var src,dest:Tvector);pascal;
procedure proVinv(var src,dest:Tvector);pascal;
procedure proVChangeType(var src,dest:Tvector;tp:integer);pascal;
procedure proVconj(var src,dest:Tvector);pascal;

procedure proVabs(var src,dest:Tvector);pascal;

procedure proVadd(var src1,src2,dest:Tvector);pascal;
procedure proVadd_1(var src, dest:Tvector; xdest:float);pascal;

procedure proVsub(var src1,src2,dest:Tvector);pascal;
procedure proVmul(var src1,src2,dest:Tvector);pascal;
procedure proVmulconj(var src1,src2,dest:Tvector);pascal;
procedure proVdiv(var src1,src2,dest:Tvector);pascal;

procedure proVaddNum(var src:Tvector; num:TfloatComp);pascal;
procedure proVmulNum(var src:Tvector; num:TfloatComp);pascal;



function fonctionVdotProd(var src1,src2:Tvector):float;pascal;
function fonctionVdotProd1(var src1,src2:Tvector;x1,x2,x3:float):float;pascal;
procedure proCrossCorNorm(var src1,src2,dest:TVector; x1,x2,x1a,x2a:float);pascal;
procedure proCrosscorNorm1(var src1,src2,dest:TVector; x1a,x2a:float; Norm:integer);pascal;

procedure proDownSample(var src,dest:Tvector;nbi:integer);pascal;

procedure proNewSampling(var src,dest:Tvector;newDx:float);pascal;
procedure NewSampling(src,dest:Tvector;newDx:float);

procedure proNewSamplingGauss(var src,dest:Tvector;newDx:float);pascal;
procedure NewSamplingGauss(src,dest:Tvector;newDx:float);

procedure proVsqrt(var src,dest:Tvector);pascal;

procedure proVsubMean(var src:Tvector);pascal;

function fonctionVnorm(var src:Tvector):float;pascal;
function fonctionVnorm_1(var src:Tvector;norm:integer):float;pascal;

function fonctionVnormDiff(var src1,src2:Tvector):float;pascal;
function fonctionVnormDiff_1(var src1,src2:Tvector;norm:integer):float;pascal;

procedure proVRealToCpx(var src1,src2,dest:Tvector);pascal;
procedure proVCpxToReal(var src,dest1,dest2:Tvector);pascal;

procedure proVmedianFilter(var src,dest:Tvector;N:integer);pascal;

procedure proVflip(var src,dest:Tvector);pascal;
procedure proVflip_1(var srcdest:Tvector);pascal;

procedure RefuseSrcEqDest(src,dest:Tvector);

implementation

{Méthode générale
  - Verifier les vecteurs sources et dest
  - Accepter ou refuser les cas source=dest

  - Trouver le type destination tp et les bornes de dest i1 et i2
  - Appeler Vmodify(tp,i1,i2)
       Vmodify génère une erreur si la modif n'est pas possible

  - Appeler copyXscale (copie de x0u dxu et unitX)
         et copyYscale (copie de y0u dyu si type entier) éventuellement

  - Effectuer l'opération
      traiter d'abord les cas ISPL
      puis les autres.
}



procedure RefuseSrcEqDest(src,dest:Tvector);
begin
  if src=dest then sortieErreur('Destination cannot be equal to source');
end;

procedure proVcopy(var src,dest:Tvector);
begin
  VerifierVecteur(src);
  VerifierVecteur(dest);
  RefuseSrcEqDest(src,dest);
  VadjustIstartIendTpNum(src,dest);
  dest.copyDataFrom(src);
end;

procedure proVcopy1(var src,dest:Tvector);
begin
  VerifierVecteur(src);
  VerifierVecteur(dest);
  RefuseSrcEqDest(src,dest);
  VadjustIstartIend(src,dest);
  dest.copyDataFrom(src);
end;

procedure VextractSelf(var src:Tvector;i1,i2:integer);
begin
  verifierVecteurTemp(src);

  src.ModifyTemp1(i1,i2) ;
  src.X0u:=0;
  src.Istart:=0;
end;

procedure proVextract(var src:Tvector;x1,x2:float;var dest:Tvector);
var
  i1,i2:integer;
begin
  VerifierVecteur(src);
  VerifierVecteur(dest);

  i1:=src.invconvX(x1);
  i2:=src.invconvX(x2);

  if (i1<src.Istart) or (i1>src.Iend) or
     (i2<src.Istart) or (i2>src.Iend) or (i2<i1)
     then sortieErreur('Vextract : bound out of range');

  if src=dest then
  begin
    VextractSelf(src,i1,i2);
    exit;
  end;

  RefuseSrcEqDest(src,dest);

  dest.dxu:=src.dxu;
  dest.X0u:=0;
  dest.unitX:=src.unitX;

  VcopyYscale(src,dest);

  Vmodify(dest,src.tpnum,0,i2-i1);

  dest.copyDataFromVec(src,i1,i2,0);

end;

procedure proVextract0(var src:Tvector;x1,x2,x0:float;var dest:Tvector);
var
  i0,i1,i2:integer;
begin
  VerifierVecteur(src);
  VerifierVecteur(dest);
  RefuseSrcEqDest(src,dest);

  dest.dxu:=src.dxu;
  dest.X0u:=0;
  dest.unitX:=src.unitX;

  VcopyYscale(src,dest);

  i0:=src.invconvX(x0);
  i1:=src.invconvX(x1);
  i2:=src.invconvX(x2);

  if (i1<src.Istart) or (i1>src.Iend) or
     (i2<src.Istart) or (i2>src.Iend) or (i2<i1)
     then sortieErreur('Vextract : bound out of range');


  Vmodify(dest,src.tpnum,i1-i0,i2-i0);

  dest.copyDataFromVec(src,i1,i2,i1-i0);

end;

procedure proVextract1(var src:Tvector;x1,x2:float;var dest:Tvector);
var
  i1,i2:integer;
begin
  VerifierVecteur(src);
  VerifierVecteur(dest);
  RefuseSrcEqDest(src,dest);

  dest.dxu:=src.dxu;
  dest.X0u:=0;
  dest.unitX:=src.unitX;

  i1:=src.invconvX(x1);
  i2:=src.invconvX(x2);

  if (i1<src.Istart) or (i1>src.Iend) or
     (i2<src.Istart) or (i2>src.Iend) or (i2<i1)
     then sortieErreur('Vextract : bound out of range');

  Vmodify(dest,dest.tpnum,0,i2-i1);

  dest.copyDataFromVec(src,i1,i2,0);

end;


procedure ProVmoveData(var source:Tvector;x1,x2:float;var dest:Tvector;xd:float);
var
  i1,i2,id:integer;
begin
  verifierVecteur(source);
  verifierVecteur(dest);

  dest.controleReadOnly;

  if dest.dxu<>source.dxu
    then sortieErreur('Vmovedata : src and dest must have the same Dx property');

  i1:=source.invconvX(x1);
  i2:=source.invconvX(x2);
  id:=dest.invconvX(xd);

  dest.copyDataFromVec(source,i1,i2,id);
end;

procedure proVappend(var src:Tvector;x1,x2:float;var dest:Tvector);
var
  i1,i2,iD:integer;
begin
  VerifierVecteur(src);
  VerifierVecteurTemp(dest);

  i1:=src.invconvX(x1);
  i2:=src.invconvX(x2);
  iD:=dest.Iend+1;

  if dest.extendNoCOndition(iD+i2-i1)
    then dest.copyDataFromVec(src,i1,i2,iD);

end;


function tpNumReal(src,dest:Tvector):typetypeG;
begin
  case src.tpNum of
    G_byte..G_extended:     if dest.tpNum<src.tpNum
                              then result:=src.tpNum
                              else result:=dest.tpNum;
    G_singleComp : case dest.tpNum of
                     G_double:         result:=G_double;
                     G_extended:       result:=G_extended;
                     else              result:=G_single;
                   end;
    G_doubleComp:  if dest.tpNum=G_extended
                     then result:=G_extended
                     else result:=G_double;
    G_extComp:     result:=G_extended;
  end;
end;

function tpNumMax(src,dest:Tvector):typetypeG;overload;
begin
  if src.tpNum>dest.tpNum
    then result:=src.tpNum
    else result:=dest.tpNum;
end;

function tpNumMax(src1,src2,dest:Tvector):typetypeG;overload;
begin
  if src1.tpNum>src2.tpNum
    then result:=src1.tpNum
    else result:=src2.tpNum;

  if dest.tpNum>result
    then result:=dest.tpNum;
end;



procedure proVrealPart(var src,dest:Tvector);
var
  i:integer;
  src1:Tvector;
begin
  VerifierVecteur(src);
  VerifierVecteur(dest);

  IPPStest;

  if src=dest
    then src1:=Tvector(src.clone(true))
    else src1:=src;
  TRY

  Vmodify(dest,tpNumReal(src,dest),src.Istart,src.Iend);
  VcopyXscale(src,dest);
  VcopyYscale(src,dest);

  {cas IPPS}
  if src1.inf.temp and ((src1.tpNum=G_singleComp) and (dest.tpNum=G_single) OR
                        (src1.tpNum=G_doubleComp) and (dest.tpNum=G_double) ) then
    case src1.tpnum of
      G_singleComp:  ippsReal_32fc(PsingleComp(src1.tb),Psingle(dest.tb),src1.Icount);
      G_doubleComp:  ippsReal_64fc(PdoubleComp(src1.tb),Pdouble(dest.tb),src1.Icount);
    end
  else
  {cas complexes non ISPL}
  if src1.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src1.Istart to src1.Iend do
        dest.Yvalue[i]:=src1.Yvalue[i];
      end
  {cas non complexes}
  else proVcopy1(src1,dest);


  FINALLY
  IPPSend;

  if src=dest then src1.free;
  END;
end;

procedure proVimPart(var src,dest:Tvector);
var
  i:integer;
  srcX:Tvector;
begin
  VerifierVecteur(src);
  VerifierVecteur(dest);

  IPPStest;

  if dest=src
    then srcX:=Tvector(src.clone(true))
    else srcX:=src;
  TRY

  Vmodify(dest,tpNumReal(src,dest),src.Istart,src.Iend);
  VcopyXscale(src,dest);

  {cas IPPS}
  if srcX.inf.temp and ((srcX.tpNum=G_singleComp) and (dest.tpNum=G_single) OR
                        (srcX.tpNum=G_doubleComp) and (dest.tpNum=G_double) ) then
    case srcX.tpnum of
      G_singleComp: IppsImag_32fc(PsingleComp(srcX.tb),Psingle(dest.tb),src.Icount);
      G_doubleComp: IppsImag_64fc(PdoubleComp(srcX.tb),Pdouble(dest.tb),src.Icount);
    end
  else
  {cas complexes non IPPS}
  if srcX.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
        dest.Yvalue[i]:=srcX.Imvalue[i];
      end
  {cas non complexes}
  else dest.fill(0);


  FINALLY
  IPPSend;
  if dest=src then srcX.Free;
  END;
end;


procedure proVconj(var src,dest:Tvector);
var
  i:integer;
begin
  VerifierVecteur(src);
  VerifierVecteur(dest);

  IPPStest;

  TRY

  if dest<>src then
  begin
    Vmodify(dest,src.tpNum,src.Istart,src.Iend);
    VcopyXscale(src,dest);
  end;

  {cas IPPS}
  if src.inf.temp and ((src.tpNum=G_singleComp) OR (src.tpNum=G_doubleComp)) then
    case src.tpnum of
      G_singleComp: if src=dest
                       then IppsConj_32fc_I(src.tbSC, src.Icount)
                       else IppsConj_32fc(src.tbSC, dest.tbSC,src.Icount);
      G_doubleComp: if src=dest
                       then IppsConj_64fc_I(src.tbDC, src.Icount)
                       else IppsConj_64fc(src.tbDC, dest.tbDC,src.Icount);
    end
  else
  {cas complexes non IPPS}
  if src.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
        dest.Imvalue[i]:=-src.Imvalue[i];
      end
  else proVcopy(src,dest);


  FINALLY
  IPPSend;
  END;
end;


procedure proVmodulus(var src,dest:Tvector);
var
  i:integer;
  srcX:Tvector;
begin
  VerifierVecteur(src);
  VerifierVecteur(dest);

  IPPStest;
  if dest=src
    then srcX:=Tvector(src.clone(true))
    else srcX:=src;

  TRY

  Vmodify(dest,tpNumReal(src,dest),src.Istart,src.Iend);
  VcopyXscale(src,dest);

  {cas ISPL}
  if srcX.inf.temp and (srcX.tpNum=G_single) and (dest.tpNum=G_single)
    then IppsAbs_32f(Psingle(srcX.tb),Psingle(dest.tb),src.Icount)
  else
  if srcX.inf.temp and (srcX.tpNum=G_double) and (dest.tpNum=G_double)
    then IppsAbs_64f(Pdouble(srcX.tb),Pdouble(dest.tb),src.Icount)
  else
  if srcX.inf.temp and (srcX.tpNum=G_singleComp) and (dest.tpNum=G_single)
    then IppsMagnitude_32fc(PsingleComp(srcX.tb),Psingle(dest.tb),src.Icount)
  else
  if srcX.inf.temp and (srcX.tpNum=G_doubleComp) and (dest.tpNum=G_double)
    then IppsMagnitude_64fc(PdoubleComp(srcX.tb),Pdouble(dest.tb),src.Icount)
  else

  {cas complexes non ISPL}
  if srcX.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
        dest.Yvalue[i]:=mdlCpx(srcX.cpxValue[i]);
      end
  {cas non complexes}
  else
    begin
      for i:=src.Istart to src.Iend do
        dest.Yvalue[i]:=abs(srcX.YValue[i]);
    end;

  FINALLY
  IPPSend;
  if dest=src then srcX.Free;
  END;
end;

procedure proVabs(var src,dest:Tvector);
begin
   proVmodulus(src,dest);
end;

procedure proVphase(var src,dest:Tvector);
var
  i:integer;
  srcX:Tvector;
begin
  VerifierVecteur(src);
  VerifierVecteur(dest);

  IPPStest;
  if dest=src
    then srcX:=Tvector(src.clone(true))
    else srcX:=src;

  TRY

  Vmodify(dest,tpNumReal(src,dest),src.Istart,src.Iend);
  VcopyXscale(src,dest);

  {cas ISPL}
  if srcX.inf.temp and (srcX.tpNum=G_singleComp) and (dest.tpNum=G_single)
    then ippsPhase_32fc(PsingleComp(srcX.tb),Psingle(dest.tb),src.Icount)
  else
  if srcX.inf.temp and (srcX.tpNum=G_doubleComp) and (dest.tpNum=G_double)
      then ippsPhase_64fc(PdoubleComp(srcX.tb),Pdouble(dest.tb),src.Icount)
  else
  {cas complexes non ISPL}
  if srcX.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
        dest.Yvalue[i]:=AngleCpx(srcX.cpxValue[i]);
      end
  {cas non complexes}
  else dest.fill(0);

  FINALLY
  IPPSend;
  if dest=src then srcX.Free;
  END;
end;


procedure proVpower(var src,dest:Tvector);
var
  i:integer;
  srcX:Tvector;
begin
  VerifierVecteur(src);
  VerifierVecteur(dest);

  IPPStest;
  if dest=src
    then srcX:=Tvector(src.clone(true))
    else srcX:=src;

  TRY

  Vmodify(dest,tpNumReal(src,dest),src.Istart,src.Iend);      // si src=dest, le tpNum de src n'est plus le même
  VcopyXscale(src,dest);                                      // il faut tester celui de srcX

  {cas ISPL}
  if srcX.inf.temp and (srcX.tpNum=G_single) and (dest.tpNum=G_single)
    then ippssqr_32f(Psingle(srcX.tb),Psingle(dest.tb),src.Icount)
  else
  if srcX.inf.temp and (srcX.tpNum=G_double) and (dest.tpNum=G_double)
    then ippssqr_64f(Pdouble(srcX.tb),Pdouble(dest.tb),src.Icount)
  else
  if srcX.inf.temp and (srcX.tpNum=G_singleComp) and (dest.tpNum=G_single)
    then ippspowerSpectr_32fc(PsingleComp(srcX.tb),Psingle(dest.tb),src.Icount)
  else
  if srcX.inf.temp and (srcX.tpNum=G_doubleComp) and (dest.tpNum=G_double)
    then ippsPowerSpectr_64fc(PdoubleComp(srcX.tb),Pdouble(dest.tb),src.Icount)
  else
  {cas complexes non ISPL}
  if srcX.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
      begin
        dest.Yvalue[i]:=mdlCpx2(srcX.cpxValue[i]);
        dest.ImValue[i]:=0;
      end;
    end
  {cas non complexes}
  else
    begin
      for i:=src.Istart to src.Iend do
        dest.Yvalue[i]:=sqr(srcX.YValue[i]);
    end;

  FINALLY
  IPPSend;
  if dest=src then srcX.Free;
  END;
end;


procedure proVinv(var src,dest:Tvector);
var
  i:integer;
  th:float;
const
  ThSingle=1E-35;
  ThDouble=1E-300;
begin
  VerifierVecteur(src);
  VerifierVecteur(dest);

  IPPStest;

  TRY

  if dest<>src then
  begin
    Vmodify(dest,tpNumMax(src,dest),src.Istart,src.Iend);
    VcopyXscale(src,dest);
  end;

  {cas ISPL}
  if src.inf.temp and (src.tpNum=G_single) and (dest.tpNum=G_single) then
    begin
      if src=dest
        then ippsThreshold_LTInv_32f_I(Psingle(src.tb),src.Icount,ThSingle)
        else ippsThreshold_LTInv_32f(Psingle(src.tb),Psingle(dest.tb),src.Icount,ThSingle);
    end
  else
  if src.inf.temp and (src.tpNum=G_double) and (dest.tpNum=G_double) then
    begin
      if src=dest
        then ippsThreshold_LTInv_64f_I(Pdouble(src.tb),src.Icount,ThDouble)
        else ippsThreshold_LTInv_64f(Pdouble(src.tb),Pdouble(dest.tb),src.Icount,ThDouble);
    end
  else
  if src.inf.temp and (src.tpNum=G_singleComp) and (dest.tpNum=G_singleComp) then
    begin
      if src=dest
        then ippsThreshold_LTInv_32fc_I(PsingleComp(src.tb),src.Icount,ThSIngle)
        else ippsThreshold_LTInv_32fc(PsingleComp(src.tb),PsingleComp(dest.tb),src.Icount,ThSingle);
    end
  else
  if src.inf.temp and (src.tpNum=G_doubleComp) and (dest.tpNum=G_doubleComp) then
    begin
      if src=dest
        then ippsThreshold_LTInv_64fc_I(PdoubleComp(src.tb),src.Icount,ThDouble)
        else ippsThreshold_LTInv_64fc(PdoubleComp(src.tb),PdoubleComp(dest.tb),src.Icount,ThDouble);
    end
  else
  {cas complexes non ISPL}
  if src.tpNum in [G_singleComp..G_extComp] then
    begin
      if src.tpNum > G_doubleComp
        then th:=thDouble
        else th:=thSingle;

      for i:=src.Istart to src.Iend do
      if mdlCpx(src.Cpxvalue[i])>th
        then dest.Cpxvalue[i]:=invCpx(src.cpxValue[i])
      else
      dest.Cpxvalue[i]:=cpxNumber(1/th,0);
    end
  {cas non complexes}
  else
    begin
      if src.tpNum > G_double
        then th:=thDouble
        else th:=thSingle;

      for i:=src.Istart to src.Iend do
      if abs(src.Yvalue[i])>th
        then dest.Yvalue[i]:=1/src.YValue[i]
      else
      if dest.Yvalue[i]>0 then dest.Yvalue[i]:=1/th
      else dest.Yvalue[i]:=-1/th;
    end;

  FINALLY
  IPPSend;
  END;
end;


procedure proVsqrt(var src,dest:Tvector);
var
  i:integer;
begin
  VerifierVecteur(src);
  VerifierVecteur(dest);

  IPPStest;

  TRY

  if dest<>src then
  begin
    Vmodify(dest,tpNumMax(src,dest),src.Istart,src.Iend);
    VcopyXscale(src,dest);
  end;

  {cas ISPL}
  if src.inf.temp and (src.tpNum=G_single) and (dest.tpNum=G_single) then
    begin
      if src=dest
        then ippsSqrt_32f_I(Psingle(src.tb),src.Icount)
        else ippsSqrt_32f(Psingle(src.tb),Psingle(dest.tb),src.Icount);
    end
  else
  if src.inf.temp and (src.tpNum=G_double) and (dest.tpNum=G_double) then
    begin
      if src=dest
        then ippsSqrt_64f_I(Pdouble(src.tb),src.Icount)
        else ippsSqrt_64f(Pdouble(src.tb),Pdouble(dest.tb),src.Icount);
    end
  else
  if src.inf.temp and (src.tpNum=G_singleComp) and (dest.tpNum=G_singleComp) then
    begin
      if src=dest
        then ippsSqrt_32fc_I(PsingleComp(src.tb),src.Icount)
        else ippsSqrt_32fc(PsingleComp(src.tb),PsingleComp(dest.tb),src.Icount);
    end
  else
  if src.inf.temp and (src.tpNum=G_doubleComp) and (dest.tpNum=G_doubleComp) then
    begin
      if src=dest
        then ippsSqrt_64fc_I(PdoubleComp(src.tb),src.Icount)
        else ippsSqrt_64fc(PdoubleComp(src.tb),PdoubleComp(dest.tb),src.Icount);
    end
  else
  {cas complexes non ISPL}
  if src.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
        dest.Cpxvalue[i]:=sqrtCpx(src.cpxValue[i]);
    end
  {cas non complexes}
  else
    begin
      for i:=src.Istart to src.Iend do
        dest.Yvalue[i]:=sqrt(src.YValue[i]);
    end;

  FINALLY
  IPPSend;
  END;
end;



procedure proVChangeType(var src,dest:Tvector;tp:integer);
var
  i:integer;
  tp1:typetypeG absolute tp;
  srcX:Tvector;
begin
  VerifierVecteur(src);
  VerifierVecteurTemp(dest);

  if dest=src
    then srcX:=Tvector(src.clone(true))
    else srcX:=src;

  try
  Vmodify(dest,tp1,src.Istart,src.Iend);

  VcopyXscale(srcX,dest);
  VcopyYscale(srcX,dest);
  dest.unitY:=srcX.unitY;

  dest.copyDataFromVec(srcX,srcX.Istart,srcX.Iend,srcX.Istart);

  finally
  if dest=src then srcX.Free;
  end;
end;


{ On ajoute num au vecteur
  Si src est réel et num complexe, seule la partie réelle de num est ajoutée.
}
procedure proVaddNum(var src:Tvector; num:TfloatComp);
var
  i:integer;
  tp:typetypeG;
  zs:TsingleComp;
  zd:TdoubleComp;

begin
  VerifierVecteurRW(src);

  IPPStest;

  TRY

  {cas ISPL}
  if src.inf.temp and (src.tpNum in [G_single,G_double,G_singleComp, G_doubleComp]) then
    case src.tpnum of
      G_single:       ippsAddc_32f_I(num.x,Psingle(src.tb),src.Icount);
      G_double:       ippsAddc_64f_I(num.x,Pdouble(src.tb),src.Icount);
      G_singleComp: begin
                      zs.x:=num.x;
                      zs.y:=num.y;
                      ippsAddc_32fc_I(zs,PsingleComp(src.tb),src.Icount);
                    end;
      G_doubleComp: begin
                      zd.x:=num.x;
                      zd.y:=num.y;
                      ippsAddc_64fc_I(zd,PdoubleComp(src.tb),src.Icount);
                    end;
    end
  else
  {cas complexes non ISPL}
  if src.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src.Istart to src.Iend do
        src.CpxValue[i]:=sumCpx(src.cpxValue[i],num);
    end
  {cas non complexes}
  else
    begin
      for i:=src.Istart to src.Iend do
        src.Yvalue[i]:=src.YValue[i]+num.x;
    end;

  FINALLY
  IPPSend;
  END;
end;

procedure proVmulNum(var src:Tvector; num:TfloatComp);
var
  i:integer;
  tp:typetypeG;
  zs:TsingleComp;
  zd:TdoubleComp;
begin
  VerifierVecteur(src);
  src.ControleReadOnly;

  IPPStest;

  TRY

  {cas ISPL}
  if src.inf.temp and  (src.tpNum in [G_single,G_double,G_singleComp, G_doubleComp]) then
    case src.tpnum of
      G_single:       ippsMulc_32f_I(num.x,Psingle(src.tb),src.Icount);
      G_double:       ippsMulC_64f_I(num.x,Pdouble(src.tb),src.Icount);
      G_singleComp: begin
                      zs.x:=num.x;
                      zs.y:=num.y;
                      ippsMulc_32fc_I(zs,PsingleComp(src.tb),src.Icount);
                    end;
      G_doubleComp: begin
                      zd.x:=num.x;
                      zd.y:=num.y;
                      ippsMulc_64fc_I(zd,PdoubleComp(src.tb),src.Icount);
                    end;
    end

  else
  {cas complexes non ISPL}
  if (src.tpNum in [G_singleComp..G_extComp]) then
    begin
      for i:=src.Istart to src.Iend do
        src.CpxValue[i]:=ProdCpx(src.cpxValue[i],num);
    end
  {cas non complexes}
  else
    begin
      for i:=src.Istart to src.Iend do
        src.Yvalue[i]:=src.YValue[i] * num.x;
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


procedure verifierX(v1,v2:Tvector);
begin
  if v1.IStart<>v2.Istart
    then sortieErreur('Source1 and Source2 must have the same Istart property');
  if v1.Iend<>v2.Iend
    then sortieErreur('Source1 and Source2 must have the same Iend property');
end;


{ Pour une opération à deux opérandes, dest doit avoir au moins le type max
  des deux opérandes.
  dest prend les propriétés Istart, Iend, Dxu et x0u de src1.
}
procedure Vmodify123(src1,src2,dest:Tvector);
var
  tpRes:typetypeG;
begin
  tpRes:=tpNumMax(src1,src2);

  if (src1<>dest) and (src2<>dest)
    then Vmodify(dest,tpNumMax(src1,src2,dest),src1.Istart,src1.Iend)
  else
  if dest.tpNum<>tpRes then proVchangeType(dest,dest,byte(tpRes));

  VcopyXscale(src1,dest);
end;

procedure proVadd(var src1,src2,dest:Tvector);
var
  i:integer;
begin
  VerifierVecteur(src1);
  VerifierVecteur(src2);
  VerifierVecteur(dest);

  VerifierX(src1,src2);

  IPPStest;

  TRY
  Vmodify123(src1,src2,dest);

  {cas ISPL}
  if src1.inf.temp and src2.inf.temp and (src1.tpNum=src2.tpNum) and (src1.tpNum=dest.tpNum)
     and (src1.tpNum in [G_single,G_double,G_singleComp, G_doubleComp]) then
  begin
    if (src1<>dest) and (src2<>dest) then
    case src1.tpNum of
      G_single:      ippsadd_32f(Psingle(src1.tb),Psingle(src2.tb),Psingle(dest.tb),src1.Icount);
      G_double:      ippsadd_64f(Pdouble(src1.tb),Pdouble(src2.tb),Pdouble(dest.tb),src1.Icount);
      G_singleComp:  ippsadd_32fc(PsingleComp(src1.tb),PsingleComp(src2.tb),PsingleComp(dest.tb),src1.Icount);
      G_doubleComp:  ippsadd_64fc(PdoubleComp(src1.tb),PdoubleComp(src2.tb),PdoubleComp(dest.tb),src1.Icount);
    end
    else
    if (src1=dest) then
    case src1.tpNum of
      G_single:      ippsadd_32f_I(Psingle(src2.tb),Psingle(dest.tb),src1.Icount);
      G_double:      ippsadd_64f_I(Pdouble(src2.tb),Pdouble(dest.tb),src1.Icount);
      G_singleComp:  ippsadd_32fc_I(PsingleComp(src2.tb),PsingleComp(dest.tb),src1.Icount);
      G_doubleComp:  ippsadd_64fc_I(PdoubleComp(src2.tb),PdoubleComp(dest.tb),src1.Icount);
    end
    else
    if (src2=dest) then
    case src1.tpNum of
      G_single:      ippsadd_32f_I(Psingle(src1.tb),Psingle(dest.tb),src1.Icount);
      G_double:      ippsadd_64f_I(Pdouble(src1.tb),Pdouble(dest.tb),src1.Icount);
      G_singleComp:  ippsadd_32fc_I(PsingleComp(src1.tb),PsingleComp(dest.tb),src1.Icount);
      G_doubleComp:  ippsadd_64fc_I(PdoubleComp(src1.tb),PdoubleComp(dest.tb),src1.Icount);
    end
  end
  else
  {cas complexes non ISPL}
  if dest.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src1.Istart to src1.Iend do
        dest.Cpxvalue[i]:=sumCpx(src1.cpxValue[i],src2.cpxValue[i]) ;
    end
  {cas non complexes}
  else
    begin
      for i:=src1.Istart to src1.Iend do
        dest.Yvalue[i]:=src1.YValue[i] + src2.YValue[i];
    end;

  FINALLY
  IPPSend;
  END;
end;

procedure proVadd_1(var src, dest:Tvector; xdest:float);
var
  i:integer;
  Idest,Ndest:integer;
begin
  VerifierVecteur(src);
  VerifierVecteurTemp(dest);

  if (xdest< dest.Xstart) or (xdest>dest.Xend) then sortieErreur('Vadd : parameter xdest out of range');

  Idest:=dest.invconvx(xdest);
  Ndest:=src.Icount;
  if Idest+Ndest-1>dest.Iend then Ndest:=dest.Iend-Idest+1;

  IPPStest;

  TRY

  {cas ISPL}
  if src.inf.temp  and (src.tpNum = dest.tpNum)  and (src.tpNum in [G_single,G_double,G_singleComp, G_doubleComp]) then
  begin
    case src.tpNum of
      G_single:      ippsadd_32f_I(Psingle(src.tb), Psingle(@PtabSingle(dest.tb)^[Idest]), Ndest);
      G_double:      ippsadd_64f_I(Pdouble(src.tb), Pdouble(@PtabSingle(dest.tb)^[Idest]), Ndest);
      G_singleComp:  ippsadd_32fc_I(PsingleComp(src.tb), PsingleComp(@PtabSingleComp(dest.tb)^[Idest]), Ndest);
      G_doubleComp:  ippsadd_64fc_I(PdoubleComp(src.tb), PdoubleComp(@PtabDoubleComp(dest.tb)^[Idest]), Ndest);
    end;
  end
  else
  {cas complexes non ISPL}
  if src.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:= 0 to Ndest-1 do
        dest.Cpxvalue[Idest+i]:=sumCpx(src.cpxValue[ src.Istart+i],dest.cpxValue[Idest+i]) ;
    end
  {cas non complexes}
  else
    begin
      for i:= 0 to Ndest-1 do
         dest.Yvalue[Idest+i]:= src.YValue[ src.Istart+i] + dest.YValue[Idest+i] ;
    end;

  FINALLY
  IPPSend;
  END;
end;


procedure proVsub(var src1,src2,dest:Tvector);
var
  i:integer;
begin
  VerifierVecteur(src1);
  VerifierVecteur(src2);
  VerifierVecteur(dest);

  VerifierX(src1,src2);

  IPPStest;

  TRY

  Vmodify123(src1,src2,dest);

  {cas IPP} { Attention IPP réalise opérande2 - opérande1 !!!}
   if src1.inf.temp and src2.inf.temp and (src1.tpNum=src2.tpNum) and (src1.tpNum=dest.tpNum)
     and (src1.tpNum in [G_single,G_double,G_singleComp, G_doubleComp]) then
  begin
    if (src1<>dest) and (src2<>dest) then
    case src1.tpNum of
      G_single:      ippsSub_32f(Psingle(src2.tb),Psingle(src1.tb),Psingle(dest.tb),src1.Icount);
      G_double:      ippsSub_64f(Pdouble(src2.tb),Pdouble(src1.tb),Pdouble(dest.tb),src1.Icount);
      G_singleComp:  ippsSub_32fc(PsingleComp(src2.tb),PsingleComp(src1.tb),PsingleComp(dest.tb),src1.Icount);
      G_doubleComp:  ippsSub_64fc(PdoubleComp(src2.tb),PdoubleComp(src1.tb),PdoubleComp(dest.tb),src1.Icount);
    end
    else
    if (src1=dest) then
    case src1.tpNum of
      G_single:      ippsSub_32f_I(Psingle(src2.tb),Psingle(dest.tb),src1.Icount);
      G_double:      ippsSub_64f_I(Pdouble(src2.tb),Pdouble(dest.tb),src1.Icount);
      G_singleComp:  ippsSub_32fc_I(PsingleComp(src2.tb),PsingleComp(dest.tb),src1.Icount);
      G_doubleComp:  ippsSub_64fc_I(PdoubleComp(src2.tb),PdoubleComp(dest.tb),src1.Icount);
    end
    else
    if (src2=dest) then
    case src1.tpNum of
      G_single:      begin
                       ippsSub_32f_I(Psingle(src1.tb),Psingle(dest.tb),src1.Icount);
                       ippsMulC_32f_I(-1,Psingle(dest.tb),dest.Icount);
                     end;
      G_double:      begin
                       ippsSub_64f_I(Pdouble(src1.tb),Pdouble(dest.tb),src1.Icount);
                       ippsMulC_64f_I(-1,Pdouble(dest.tb),dest.Icount);
                     end;
      G_singleComp:  begin
                       ippsSub_32fc_I(PsingleComp(src1.tb),PsingleComp(dest.tb),src1.Icount);
                       ippsMulC_32fc_I(singleComp(-1,0),PsingleComp(dest.tb),dest.Icount);
                     end;
      G_doubleComp:  begin
                       ippsSub_64fc_I(PdoubleComp(src1.tb),PdoubleComp(dest.tb),src1.Icount);
                       ippsMulC_64fc_I(doubleComp(-1,0),PdoubleComp(dest.tb),dest.Icount);
                     end;
    end
  end
  else
  {cas complexes non ISPL}
  if src1.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src1.Istart to src1.Iend do
        dest.Cpxvalue[i]:=DiffCpx(src1.cpxValue[i],src2.cpxValue[i]) ;
    end
  {cas non complexes}
  else
    begin
      for i:=src1.Istart to src1.Iend do
        dest.Yvalue[i]:=src1.YValue[i] - src2.YValue[i];
    end;

  FINALLY
  IPPSend;
  END;
end;



procedure proVmul(var src1,src2,dest:Tvector);
var
  i:integer;
begin
  VerifierVecteur(src1);
  VerifierVecteur(src2);
  VerifierVecteur(dest);

  VerifierX(src1,src2);

  IPPStest;

  TRY
  Vmodify123(src1,src2,dest);

  {cas ISPL}
  if src1.inf.temp and src2.inf.temp and (src1.tpNum=src2.tpNum) and (src1.tpNum=dest.tpNum)
     and (src1.tpNum in [G_single,G_double,G_singleComp, G_doubleComp]) then
  begin
    if (src1<>dest) and (src2<>dest) then
    case src1.tpNum of
      G_single:      ippsmul_32f(Psingle(src1.tb),Psingle(src2.tb),Psingle(dest.tb),src1.Icount);
      G_double:      ippsmul_64f(Pdouble(src1.tb),Pdouble(src2.tb),Pdouble(dest.tb),src1.Icount);
      G_singleComp:  ippsmul_32fc(PsingleComp(src1.tb),PsingleComp(src2.tb),PsingleComp(dest.tb),src1.Icount);
      G_doubleComp:  ippsmul_64fc(PdoubleComp(src1.tb),PdoubleComp(src2.tb),PdoubleComp(dest.tb),src1.Icount);
    end
    else
    if (src1=dest) then
    case src1.tpNum of
      G_single:      ippsmul_32f_I(Psingle(src2.tb),Psingle(dest.tb),src1.Icount);
      G_double:      ippsmul_64f_I(Pdouble(src2.tb),Pdouble(dest.tb),src1.Icount);
      G_singleComp:  ippsmul_32fc_I(PsingleComp(src2.tb),PsingleComp(dest.tb),src1.Icount);
      G_doubleComp:  ippsmul_64fc_I(PdoubleComp(src2.tb),PdoubleComp(dest.tb),src1.Icount);
    end
    else
    if (src2=dest) then
    case src1.tpNum of
      G_single:      ippsmul_32f_I(Psingle(src1.tb),Psingle(dest.tb),src1.Icount);
      G_double:      ippsmul_64f_I(Pdouble(src1.tb),Pdouble(dest.tb),src1.Icount);
      G_singleComp:  ippsmul_32fc_I(PsingleComp(src1.tb),PsingleComp(dest.tb),src1.Icount);
      G_doubleComp:  ippsmul_64fc_I(PdoubleComp(src1.tb),PdoubleComp(dest.tb),src1.Icount);
    end
  end

  else
  {cas complexes non ISPL}
  if src1.tpNum in [G_singleComp..G_extComp] then
    begin
      for i:=src1.Istart to src1.Iend do
        dest.Cpxvalue[i]:=prodCpx(src1.cpxValue[i],src2.cpxValue[i]) ;
    end
  {cas non complexes}
  else
    begin
      for i:=src1.Istart to src1.Iend do
        dest.Yvalue[i]:=src1.YValue[i] * src2.YValue[i];
    end;

  FINALLY
  IPPSend;
  END;
end;

procedure proVmulConj(var src1,src2,dest:Tvector);
var
  i:integer;
begin
  VerifierVecteur(src1);
  VerifierVecteur(src2);
  VerifierVecteur(dest);

  VerifierX(src1,src2);

  IPPStest;

  TRY

  Vmodify123(src1,src2,dest);

  {cas ISPL}
   if src1.inf.temp and (src1.tpNum=src2.tpNum) and (src1.tpNum=dest.tpNum)
     and (src1<>dest) and (src2<>dest)
     and (src1.tpNum in [G_singleComp, G_doubleComp]) then
  begin
    case src1.tpNum of
      G_singleComp:  begin
                       ippsConj_32fc(Src2.tbSC,Dest.tbSC,src1.Icount);
                       ippsmul_32fc_I(src1.tbSC,dest.tbSC,src1.icount);
                     end;
      G_doubleComp:  begin
                       ippsConj_64fc(Src2.tbDC,Dest.tbDC,src1.icount);
                       ippsmul_64fc_I(src1.tbDC,dest.tbDC,src1.icount);
                     end;
    end
  end
  else
  {cas ISPL}
  if src1.isComplex or src2.isComplex then
    begin
      for i:=src1.Istart to src1.Iend do
        dest.Cpxvalue[i]:=ProdZ1conjZ2(src1.cpxValue[i],src2.cpxValue[i]) ;
    end
  {cas non complexes}
  else
    begin
      for i:=src1.Istart to src1.Iend do
        dest.Yvalue[i]:=src1.YValue[i] * src2.YValue[i];
    end;

  FINALLY
  IPPSend;
  END;
end;


procedure proVdiv(var src1,src2,dest:Tvector);
var
  srcX:Tvector;
begin
 if dest=src1
    then srcX:=Tvector(src1.clone(true))
    else srcX:=src1;
  TRY
    proVinv(src2,dest);
    proVmul(dest,srcX,dest);
  FINALLY
    if dest=src1 then srcX.Free;
  END;
end;


function fonctionVdotProd(var src1,src2:Tvector):float;
var
  i,di:integer;
  wsingle:single;
  wdouble:double;
  wsingleComp:TsingleComp;
  wdoubleComp:TdoubleComp;

begin
  VerifierVecteur(src1);
  VerifierVecteur(src2);
  if src1.isComplex or src2.isComplex then sortieErreur('VdotProd : Source cannot be complex');

  if (src1.Icount<>src2.Icount)
    then sortieErreur('VdotProd: src1 and src2 must have the same Icount properties');

  if src1.inf.temp and src2.inf.temp and (src1.tpNum=src2.tpNum) and
    (src1.tpNum in [g_single,g_double{,G_singleComp,G_doubleComp}]) then
  begin
    IPPStest;
    try
    case src1.tpNum of
      g_single:     begin
                      ippsDotProd_32f64f(Psingle(Src1.tb), Psingle(Src2.tb), src1.Icount, @wdouble );
                      result:=wdouble;
                    end;
      g_double:     begin
                      ippsDotProd_64f(Pdouble(Src1.tb), Pdouble(Src2.tb), src1.Icount,Pdouble(@wdouble));
                      result:=wdouble;
                    end;
     {
      g_singleComp: begin
                      ippsDotProd(PsingleComp(Src1.tb), PsingleComp(Src2.tb), src1.Icount,PsingleComp(@wsingleComp));
                      result:=wsingleComp;
                    end;
      g_doubleComp: begin
                      ippsDotProd(PdoubleComp(Src1.tb), PdoubleComp(Src2.tb), src1.Icount,PdoubleComp(@wdoubleComp));
                      result:=wdoubleComp;
                    end;
      }
    end;
    finally
    IPPSend;
    end;
  end
  else
  begin
    result:=0;
    di:=src2.Istart-src1.Istart;
    for i:=src1.Istart to src1.Iend do
      result:=result + src1.Yvalue[i]*src2.Yvalue[i+di];
  end;

end;

function fonctionVdotProd1(var src1,src2:Tvector;x1,x2,x3:float):float;
var
  i,i1,i2,i3:integer;
  wsingle:single;
  wdouble:double;
begin
  VerifierVecteur(src1);
  VerifierVecteur(src2);

  if src1.isComplex or src2.isComplex then sortieErreur('VdotProd1 : Source cannot be complex');
  i1:=src1.invconvX(x1);
  i2:=src1.invconvX(x2);
  i3:=src2.invconvX(x3);

  if (i1<src1.Istart) or (i1>i2) or (i2>src1.Iend) or
     (i3<src2.Istart) or (i3>i3+i2-i1) or (i3+i2-i1>src2.Iend)
    then sortieErreur('VdotProd1: bad parameters');


  if src1.inf.temp and src2.inf.temp and (src1.tpNum=src2.tpNum) and
    (src1.tpNum in [g_single,g_double{,g_singleComp,g_doubleComp}]) then
  begin
    IPPStest;
    case src1.tpNum of
      g_single: begin
                  ippsDotProd_32f64f(Psingle(@Src1.tbSingle^[i1]), Psingle(@Src2.tbSingle^[i2]), i2-i1+1, @wdouble);
                  result:=wdouble;
                end;

      g_double: begin
                  ippsDotProd_64f(Pdouble(@Src1.tbDouble^[i1]), Pdouble(@Src2.tbDouble^[i2]), i2-i1+1,Pdouble(@wdouble));
                  result:=wdouble;
                end;
    end;
    IPPSend;
  end
  else
  begin
    result:=0;
    for i:=i1 to i2 do
      result:=result + src1.Yvalue[i]*src2.Yvalue[i3+ i-i1];
  end;

end;



{ Calcule la quantité (E(xy)-E(x)E(y)) / (sigmaX*sigmaY)  }

function DotProdNormS(tb1,tb2:PtabSingle;Nb:integer):float;
var
  moy1,moy2:float;
  crossC,auto1,auto2:float;
  wsingle:single;
begin
  if nb=0 then
  begin
    result:=0;
    exit;
  end;

  ippsMean_32f(Psingle(@tb1[0]),nb,Psingle(@wsingle),ippAlgHintNone);
  moy1:=wsingle;
  ippsMean_32f(Psingle(@tb2[0]),nb,Psingle(@wsingle),ippAlgHintNone);
  moy2:=wsingle;

  ippsDotProd_32f(Psingle(@tb1[0]),Psingle(@tb2[0]),nb,Psingle(@wsingle));

  crossC:=wsingle/nb  - moy1*moy2;

  ippsStdDev_32f(Psingle(@tb1[0]),nb,Psingle(@wsingle),ippAlgHintNone);
  auto1:=wsingle ;

  ippsStdDev_32f(Psingle(@tb2[0]),nb,Psingle(@wsingle),ippAlgHintNone);
  auto2:=wsingle ;

  if (auto1<>0) and (auto2<>0)
    then result:=crossC/(auto1*auto2)*nb/(nb-1)        {stdev contient une division par n-1 au lieu de n }
    else result:=0;
end;

function DotProdNormD(tb1,tb2:PtabDouble;Nb:integer):float;
var
  moy1,moy2:float;
  crossC,auto1,auto2:float;
  wdouble:double;
begin
  if nb=0 then
  begin
    result:=0;
    exit;
  end;

  ippsMean_64f(Pdouble(@tb1[0]),nb,Pdouble(@wdouble));
  moy1:=wdouble;
  ippsMean_64f(Pdouble(@tb2[0]),nb,Pdouble(@wdouble));
  moy2:=wdouble;

  ippsDotProd_64f(Pdouble(@tb1[0]),Pdouble(@tb2[0]),nb,Pdouble(@wdouble));

  crossC:=wdouble/nb  - moy1*moy2;

  ippsStdDev_64f(Pdouble(@tb1[0]),nb,Pdouble(@wdouble));
  auto1:=wdouble;

  ippsStdDev_64f(Pdouble(@tb2[0]),nb,Pdouble(@wdouble));
  auto2:=wdouble;

  if (auto1<>0) and (auto2<>0)
    then result:=crossC/(auto1*auto2)*nb/(nb-1)
    else result:=0;
end;




procedure proCrossCorNorm(var src1,src2,dest:TVector; x1,x2,x1a,x2a:float);
var
  i1,i2,i1a,i2a:integer;
  i1deb,i1fin,i2deb,i2fin:integer;
  i:integer;
  nb:integer;
  Ftype:integer;
begin
  verifierVecteurTemp(src1);
  verifierVecteurTemp(src2);
  verifierVecteurTemp(dest);

  RefuseSrcEqDest(src1,dest);
  RefuseSrcEqDest(src2,dest);

  Ftype:=0;
  if (src1.tpNum=g_single) and (src2.tpNum=g_single) then Ftype:=1;
  if (src1.tpNum=g_double) and (src2.tpNum=g_double) then Ftype:=2;
  {
  if (src1.tpNum=g_singleComp) and (src2.tpNum=g_singleComp) then Ftype:=3;
  if (src1.tpNum=g_doubleComp) and (src2.tpNum=g_doubleComp) then Ftype:=4;
  if (src1.tpNum=g_single) and (src2.tpNum=g_singleComp) then Ftype:=5;
  if (src1.tpNum=g_singleComp) and (src2.tpNum=g_single) then Ftype:=6;
  if (src1.tpNum=g_double) and (src2.tpNum=g_doubleComp) then Ftype:=7;
  if (src1.tpNum=g_doubleComp) and (src2.tpNum=g_double) then Ftype:=8;
  }
  if Ftype=0 then sortieErreur('CrossCorNorm: bad data type');

  if (src1.Istart<>src2.Istart) or (src1.Iend<>src2.Iend) or
     (src1.dxu<>src2.dxu) or (src1.x0u<>src2.x0u)
    then sortieErreur('CrossCorNorm: src1 and src2 must have same X parameters');

  i1:=src1.invconvx(x1);
  i2:=src1.invconvx(x2);
  if (i1<src1.Istart) or (i2<i1) or (i2>src1.Iend)
    then sortieErreur('CrossCorNorm: x1 or x2 out of range');

  i1a:=round(x1a/src1.dxu);
  i2a:=round(x2a/src1.dxu);
  if (i2a<i1a)
    then sortieErreur('CrossCorNorm: x1a or x2a out of range');

  dest.initTemp1(i1a,i2a,g_double);
  dest.Dxu:=src1.dxu;
  dest.X0u:=0;
  dest.unitX:=src1.unitX;

  IPPStest;

  try
  for i:=i1a to i2a do
  begin
    i1deb:=i1;
    i1fin:=i2;
    i2deb:=i1+i;
    i2fin:=i2+i;


    if (i2deb<src2.Istart) then
    begin
      i1deb:=i1deb+src2.Istart-i2deb;
      i2deb:=src2.Istart;
    end;

    if (i2fin>src2.Iend) then
    begin
      i1fin:=i1fin-(i2fin-src2.Iend);
      i2fin:=src2.Iend;
    end;

    if (i1deb<i1fin) and (i2deb<i2fin) then
    case Ftype of
      1: dest.Yvalue[i]:=dotProdNormS(@src1.tbSingle^[i1deb],@src2.tbSingle^[i2deb],i1fin-i1deb+1);
      2: dest.Yvalue[i]:=dotProdNormD(@src1.tbDouble^[i1deb],@src2.tbDouble^[i2deb],i1fin-i1deb+1);

      else dest.Yvalue[i]:=0;
    end;
  end;

  finally
  IPPSend;
  end;
end;

procedure proCrosscorNorm1(var src1,src2,dest:TVector; x1a,x2a:float; Norm:integer);
var
  i1,i2,i1a,i2a:integer;
  i1deb,i1fin,i2deb,i2fin:integer;
  i:integer;
  nb:integer;
  Ftype:integer;
  Buffer:pointer;
  BufferSize: integer;
begin
  verifierVecteurTemp(src1);
  verifierVecteurTemp(src2);
  verifierVecteurTemp(dest);

  RefuseSrcEqDest(src1,dest);
  RefuseSrcEqDest(src2,dest);

  Ftype:=0;
  if (src1.tpNum=g_single) and (src2.tpNum=g_single) then Ftype:=1;
  if (src1.tpNum=g_double) and (src2.tpNum=g_double) then Ftype:=2;

  if (src1.tpNum=g_singleComp) and (src2.tpNum=g_singleComp) then Ftype:=3;
  if (src1.tpNum=g_doubleComp) and (src2.tpNum=g_doubleComp) then Ftype:=4;
  {
  if (src1.tpNum=g_single) and (src2.tpNum=g_singleComp) then Ftype:=5;
  if (src1.tpNum=g_singleComp) and (src2.tpNum=g_single) then Ftype:=6;
  if (src1.tpNum=g_double) and (src2.tpNum=g_doubleComp) then Ftype:=7;
  if (src1.tpNum=g_doubleComp) and (src2.tpNum=g_double) then Ftype:=8;
  }
  if Ftype=0 then sortieErreur('CrossCorNorm1: bad data type');

  if (src1.Istart<>src2.Istart) or (src1.Iend<>src2.Iend) or
     (src1.dxu<>src2.dxu) or (src1.x0u<>src2.x0u)
    then sortieErreur('CrossCorNorm: src1 and src2 must have same X parameters');


  i1a:=round(x1a/src1.dxu);
  i2a:=round(x2a/src1.dxu);
  if (i2a<i1a)
    then sortieErreur('CrossCorNorm: x1a or x2a out of range');

  dest.initTemp1(i1a,i2a,src1.tpNum);
  dest.Dxu:=src1.dxu;
  dest.X0u:=0;
  dest.unitX:=src1.unitX;

  IPPStest;

  ippsCrossCorrNormGetBufferSize(src1.Icount, src2.Icount, dest.Icount, i1a, src1.IppType, $100*Norm, @BufferSize);
  Buffer:= ippsMalloc(BufferSize);

  case Ftype of
    1:  ippsCrossCorrNorm_32f (Src1.tb, src1.Icount, Src2.tb, src2.Icount, Dest.tb, Dest.Icount, i1a, $100*Norm,  Buffer);
    2:  ippsCrossCorrNorm_64f (Src1.tb, src1.Icount, Src2.tb, src2.Icount, Dest.tb, Dest.Icount, i1a, $100*Norm,  Buffer);
    3:  ippsCrossCorrNorm_32fc (Src1.tb, src1.Icount, Src2.tb, src2.Icount, Dest.tb, Dest.Icount, i1a, $100*Norm, Buffer);
    4:  ippsCrossCorrNorm_64fc (Src1.tb, src1.Icount, Src2.tb, src2.Icount, Dest.tb, Dest.Icount, i1a, $100*Norm, Buffer);
  end;

  ippsFree(Buffer);
end;



procedure proDownSample(var src,dest:Tvector;nbi:integer);
var
  nb,i,j:integer;
  z:float;
  tp:typetypeG;
  srcX:Tvector;
begin
  VerifierVecteur(src);
  VerifierVecteurTemp(dest);

  if nbi<1 then exit;

  if dest=src
    then srcX:=Tvector(src.clone(true))
    else srcX:=src;

  TRY
  nb:=src.Icount div nbi;

  tp:=srcX.tpNum;
  if tp<g_single then tp:=g_single;
  dest.initTemp1(srcX.Istart,srcX.Istart+nb-1,tp);
  if nb=0 then exit;

  dest.dxu:=srcX.dxu*nbi;
  dest.X0u:=srcX.X0u;
  dest.unitX:=srcX.unitX;

  VcopyYscale(src,dest);

  with srcX do
  for i:=0 to nb-1 do
  begin
    z:=0;
    for j:=0 to nbi-1 do
      z:=z+Yvalue[Istart+i*nbi+j];
    dest.Yvalue[Istart+i]:=z/nbi;
  end;

  if srcX.isComplex then
  with srcX do
  for i:=0 to nb-1 do
  begin
    z:=0;
    for j:=0 to nbi-1 do
      z:=z+Imvalue[Istart+i*nbi+j];
    dest.Imvalue[Istart+i]:=z/nbi;
  end;

  FINALLY
  if dest=src then srcX.Free;
  END;
end;

procedure NewSampling(src,dest:Tvector;newDx:float);
var
  di,i1:integer;
  x,y:float;
  tp:typetypeG;
begin

  tp:=src.tpNum;
  if tp<g_single then tp:=g_single;
  if newDx<=0 then
  begin
    dest.initTemp1(src.Istart,src.Iend,tp);
    exit;
  end
  else dest.initTemp1(src.Istart,src.Istart-1,tp);

  dest.dxu:=newDx;
  dest.X0u:=src.X0u +newDx/2;
  dest.unitX:=src.unitX;


  with src do
  begin
    di:=trunc(newDx/dxu)-1;
    if di<0 then di:=0;
    x:=Xstart;
    repeat
      i1:=invconvx(x);
      if i1+di>Iend then break;
      y:=data.moyenne(i1,i1+di);
      dest.addToList(y);
      x:=x+newDx;
    until false;
  end;
end;


procedure proNewSampling(var src,dest:Tvector;newDx:float);
var
  srcX:Tvector;
begin
  VerifierVecteur(src);
  VerifierVecteurTemp(dest);

  if dest=src
    then srcX:=Tvector(src.clone(true))
    else srcX:=src;

  try
  NewSampling(srcX,dest,newDx);
  finally
  if dest=src then srcX.free;
  end;
end;

procedure NewSamplingGauss(src,dest:Tvector;newDx:float);
var
  i,di,i1:integer;
  y:double;
  x,s:float;
  tp:typetypeG;
  tbA,tbB:array of double;

begin
  IPPStest;

  tp:=src.tpNum;
  if tp<g_single then tp:=g_single;
  if newDx<=0 then
  begin
    dest.initTemp1(src.Istart,src.Iend,tp);
    exit;
  end;

  dest.initTemp1(src.Istart,src.Istart-1,tp);
  dest.dxu:=newDx;
  dest.X0u:=src.X0u +newDx/2;
  dest.unitX:=src.unitX;


  with src do
  begin
    if data=nil then exit;

    di:=round(newDx/dxu/2)-1;
    if di<1 then di:=1;

    setLength(tbA,2*di+1);
    setLength(tbB,2*di+1);

    s:=0;
    for i:=-di to di do
    begin
      tbB[i+di]:=exp(-sqr(i/di));
      s:=s+tbB[i+di];
    end;

    for i:=-di to di do
      tbB[i+di]:=tbB[i+di]/s;


    x:=Xstart;
    repeat
      i1:=invconvx(x)+di;
      if i1+di>Iend then break;
      for i:=i1-di to i1+di do tbA[i-i1+di]:=data.getE(i);

      ippsDotProd_64f(Pdouble(@tbA[0]),Pdouble(@tbB[0]),2*di+1,@y);

      dest.addToList(y);
      x:=x+newDx;
    until x>Xend;
  end;

  IPPSend;
end;


procedure proNewSamplingGauss(var src,dest:Tvector;newDx:float);
var
  srcX:Tvector;
begin
  VerifierVecteur(src);
  VerifierVecteurTemp(dest);

  if dest=src
    then srcX:=Tvector(src.clone(true))
    else srcX:=src;

  try
  NewSamplingGauss(srcX,dest,newDx);
  finally
  if dest=src then srcX.Free;
  end;
end;


procedure proRndUniform(var src:Tvector;Vmin,Vmax:float;seed:integer);
begin
  VerifierVecteur(src);

  {
  testMKL;

  vslNewStreamEx( stream, brng, n, params )

  endMKL;
  }
end;

procedure proVsubMean(var src:Tvector);
var
  w:TfloatComp;
begin
  VerifierVecteurRW(src);
  w.x:=-src.data.moyenne(src.Istart,src.Iend);
  w.y:=-src.data.moyenneImag(src.Istart,src.Iend);
  proVaddNum(src,w );
end;

function fonctionVnorm(var src:Tvector):float;
begin
  result:=fonctionVnorm_1(src,2);
end;

function fonctionVnorm_1(var src:Tvector;norm:integer):float;
var
  ws:single;
  wd:double;
  i:integer;
begin
  verifierVecteur(src);

  if src.inf.temp and (src.tpNum in[g_single,g_double]) then
  case src.tpNum of
    g_single: begin
                case norm of
                  0: ippsNorm_inf_32f(src.tbS,src.Icount,@ws);
                  1: ippsNorm_L1_32f(src.tbS,src.Icount,@ws);
                  2: ippsNorm_L2_32f(src.tbS,src.Icount,@ws);
                end;
                result:=ws;
              end;
    g_double: begin
                case norm of
                  0: ippsNorm_inf_64f(src.tbD,src.Icount,@wd);
                  1: ippsNorm_L1_64f(src.tbD,src.Icount,@wd);
                  2: ippsNorm_L2_64f(src.tbD,src.Icount,@wd);
                end;
                result:=wd;
              end;
  end
  else
  begin
    result:=0;
    with src do
    case norm of
      0: for i:=Istart to Iend do
           if mdl[i]>result then result:=mdl[i];
      1: for i:=Istart to Iend do
           result:=result+mdl[i];
      2: for i:=Istart to Iend do
           result:=result+sqr(mdl[i]);
    end;
  end;
end;


function fonctionVnormDiff(var src1,src2:Tvector):float;
begin
  result:=fonctionVnormDiff_1(src1,src2,2);
end;

function fonctionVnormDiff_1(var src1,src2:Tvector;norm:integer):float;
var
  ws:single;
  wd:double;
  i:integer;
  Vdum:Tvector;
begin
  verifierVecteur(src1);
  verifierVecteur(src2);

  if src1.Icount<>src2.Icount then sortieErreur('VnormDiff : vectors have different sizes');

  if src1.inf.temp and  src2.inf.temp and (src1.tpNum=src2.tpNum) and (src1.tpNum in[g_single,g_double]) then
  case src1.tpNum of
    g_single: begin
                case norm of
                  0: ippsNormDiff_inf_32f(src1.tbS,src2.tbS,src1.Icount,@ws);
                  1: ippsNormDiff_L1_32f(src1.tbS,src2.tbS,src1.Icount,@ws);
                  2: ippsNormDiff_L2_32f(src1.tbS,src2.tbS,src1.Icount,@ws);
                end;
                result:=ws;
              end;
    g_double: begin
                case norm of
                  0: ippsNormDiff_inf_64f(src1.tbD,src2.tbD,src1.Icount,@wd);
                  1: ippsNormDiff_L1_64f(src1.tbD,src2.tbD,src1.Icount,@wd);
                  2: ippsNormDiff_L2_64f(src1.tbD,src2.tbD,src1.Icount,@wd);
                end;
                result:=wd;
              end;
    g_singleComp:
              begin
                case norm of
                  0: ippsNormDiff_inf_32fc32f(src1.tbSC,src2.tbSC,src1.Icount,@ws);
                  1: ippsNormDiff_L1_32fc64f(src1.tbSC,src2.tbSC,src1.Icount,@wd);
                  2: ippsNormDiff_L2_32fc64f(src1.tbSC,src2.tbSC,src1.Icount,@wd);
                end;
                if norm=0 then result:= ws else result:= wd;
              end;
    g_doubleComp:
              begin
                case norm of
                  0: ippsNormDiff_inf_64fc64f(src1.tbDC,src2.tbDC,src1.Icount,@wd);
                  1: ippsNormDiff_L1_64fc64f(src1.tbDC,src2.tbDC,src1.Icount,@wd);
                  2: ippsNormDiff_L2_64fc64f(src1.tbDC,src2.tbDC,src1.Icount,@wd);
                end;
                result:=wd;
              end;


  end
  else
  begin
    Vdum:=Tvector.create(g_double,0,0);
    try
    proVsub(src1,src2,Vdum);
    result:=fonctionVnorm_1(Vdum,norm);
    finally
    Vdum.free;
    end;
  end;
end;

procedure proVCpxToReal(var src,dest1,dest2:Tvector);
var
  i:integer;
begin
  VerifierVecteur(src);
  VerifierVecteur(dest1);
  VerifierVecteur(dest2);

  IPPStest;

  TRY

  if (dest1=src) or (dest2=src) then sortieErreur('VCpxToReal : src cannot be equal to dest');

  Vmodify(dest1,tpNumReal(src,dest1),src.Istart,src.Iend);
  VcopyXscale(src,dest1);
  Vmodify(dest2,tpNumReal(src,dest2),src.Istart,src.Iend);
  VcopyXscale(src,dest2);


  {cas IPPS}
  if src.inf.temp and ((src.tpNum=G_singleComp) OR (src.tpNum=G_doubleComp)) then
    case src.tpnum of
      G_singleComp:  IppsCplxToReal_32fc(src.tbSC,dest1.tbS,dest2.tbS,src.Icount);
      G_doubleComp:  IppsCplxToReal_64fc(src.tbDC,dest1.tbD,dest2.tbD,src.Icount);
    end
  else
  {cas complexes ou réels non IPPS}
  begin
    for i:=src.Istart to src.Iend do
    begin
      dest1.Yvalue[i]:=src.Yvalue[i];
      dest2.Yvalue[i]:=src.Imvalue[i];
    end;
  end;

  FINALLY
  IPPSend;
  END;
end;

procedure proVRealToCpx(var src1,src2,dest:Tvector);
var
  i:integer;
  tp1:typetypeG;
begin
  VerifierVecteur(src1);
  VerifierVecteur(src2);
  VerifierVecteur(dest);

  IPPStest;

  TRY

  if (dest=src1) or (dest=src2) then sortieErreur('VRealToCpx : src cannot be equal to dest');
  if (src1.Istart<>src2.Istart) or (src1.Iend<>src2.Iend)
    then sortieErreur('VRealToCpx : src1 and src2 must have the same Istart and Iend properties');
  if (src1.tpNum>=G_singleComp) or (src2.tpNum>=G_singleComp)
    then sortieErreur('VRealToCpx : src1 and src2 cannot be complex');

  if (src1.tpNum>=g_extended) or (src1.tpNum>=g_extended) then tp1:=g_extComp
  else
  if (src1.tpNum>=g_Double) or (src1.tpNum>=g_Double) then tp1:=g_doubleComp
  else tp1:=g_singleComp;

  Vmodify(dest,tp1,src1.Istart,src1.Iend);
  VcopyXscale(src1,dest);

  {cas IPPS}
  if src1.inf.temp and (src1.tpNum=G_single) and src2.inf.temp and (src2.tpNum=G_single)
    then IppsRealToCplx_32f(src1.tbS,src2.tbS,dest.tbSC,src1.Icount)
  else
  if src1.inf.temp and (src1.tpNum=G_double) and src2.inf.temp and (src2.tpNum=G_double)
    then IppsRealToCplx_64f(src1.tbD,src2.tbD,dest.tbDC,src1.Icount)
  else
  {cas complexes ou réels non IPPS}
  begin
    for i:=src1.Istart to src1.Iend do
    begin
      dest.Yvalue[i]:=src1.Yvalue[i];
      dest.Imvalue[i]:=src2.Yvalue[i];
    end;
  end;

  FINALLY
  IPPSend;
  END;
end;


procedure proVmedianFilter(var src,dest:Tvector;N:integer);
var
  i:integer;
  status:integer;
  buffer: pointer;
  bufferSize: integer;
begin

  VerifierVecteurTemp(src);
  VerifierVecteurTemp(dest);
  dest.ControleReadOnly;

  if not (src.tpNum in [G_smallint, G_longint, G_single, G_double])
    then sortieErreur('VmedianFilter : unsupported number type');

  if N<=0 then N:=1;
  IPPStest;

  TRY

  Vmodify(dest,src.tpNum,src.Istart,src.Iend);
  VcopyXscale(src,dest);
  VcopyYscale(src,dest);

  {cas IPPS}

  case src.tpNum of
    G_smallint:  ippsFilterMedianGetBufferSize (N, _ipp16s, @BufferSize);
    G_longint:  ippsFilterMedianGetBufferSize (N, _ipp32s, @BufferSize);
    G_single:  ippsFilterMedianGetBufferSize (N, _ipp32f, @BufferSize);
    G_double:  ippsFilterMedianGetBufferSize (N, _ipp64f, @BufferSize);
    else bufferSize:=0;
  end;
  if bufferSize>0 then buffer:= ippsMalloc(BufferSize) else buffer:=nil;

  if (src=dest) then
    case src.tpnum of
      G_smallint : status:= ippsFilterMedian_16s_I(Src.tb, Src.Icount, N, nil,nil,buffer);
      G_longint :  status:= ippsFilterMedian_32s_I(Src.tb, Src.Icount, N, nil,nil,buffer);
      G_single :   status:= ippsFilterMedian_32f_I(Src.tb, Src.Icount, N, nil,nil,buffer);
      G_double :   status:= ippsFilterMedian_64f_I(Src.tb, Src.Icount, N, nil,nil,buffer);
    end
  else
    case src.tpnum of
      G_smallint : status:= ippsFilterMedian_16s(Src.tb,dest.tb, Src.Icount, N, nil,nil,buffer);
      G_longint :  status:= ippsFilterMedian_32s(Src.tb,dest.tb, Src.Icount, N, nil,nil,buffer);
      G_single :   status:= ippsFilterMedian_32f(Src.tb,dest.tb, Src.Icount, N, nil,nil,buffer);
      G_double :   status:= ippsFilterMedian_64f(Src.tb,dest.tb, Src.Icount, N, nil,nil,buffer);
    end

  FINALLY
  if buffer<>nil then ippsFree(buffer);
  IPPSend;

  END;
end;

procedure proVflip(var src,dest:Tvector);
var
  status:integer;
  i:integer;
  w: float;
begin
  verifierVecteur(src);
  verifierVecteurTemp(dest);

  if src=dest then
  with src do
  begin
    case tpnum of
      G_byte,G_short:      status:= ippsFlip_8u_I( tb, Icount);
      G_smallint,G_word :  status:= ippsFlip_16u_I(tb, Icount);
      G_longint, G_single: status:= ippsFlip_32f_I(tb, Icount);
      G_double:            status:= ippsFlip_64f_I(tb, Icount);
      else
      begin
        for i:=0 to Icount div 2 do
        begin
          w:= src[Istart+i];
          src[Istart+i]:=src[Iend-i];
          src[Iend-i]:= w;
        end;
        if isComplex then
        for i:=0 to Icount div 2 do
        begin
          w:= src.ImValue[Istart+i];
          src.ImValue[Istart+i]:=src.ImValue[Iend-i];
          src.ImValue[Iend-i]:= w;
        end;
      end;
    end;
  end
  else
  with src do
  begin
    dest.modify(tpNum,Istart,Iend);
    case tpnum of
      G_byte,G_short:      status:= ippsFlip_8u( tb, dest.tb, Icount);
      G_smallint,G_word :  status:= ippsFlip_16u(tb, dest.tb, Icount);
      G_longint, G_single: status:= ippsFlip_32f(tb, dest.tb, Icount);
      G_double:            status:= ippsFlip_64f(tb, dest.tb, Icount);
      else
      begin
        for i:=0 to Icount-1 do dest[Istart+i]:=src[Iend-i];
        if isComplex then
        for i:=0 to Icount-1 do
          dest.ImValue[Istart+i]:=src.ImValue[Iend-i];
      end;
    end;
  end
end;

procedure proVflip_1(var srcdest:Tvector);
begin
  proVflip( srcdest, srcdest);
end;


Initialization
AffDebug('Initialization stmVecU1',0);

end.
