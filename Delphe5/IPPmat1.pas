unit IPPmat1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses math,
     util1,Dgraphic, listG,
     Ncdef2, stmdef,stmObj,stmvec1,stmMat1,stmKLmat,
     IPPI,IPPdefs,geometry1,
     stmMatBuffer1 ;


procedure proMFixedfilter(var src,dest:Tmatrix;mask:integer;tpF:integer);pascal;

procedure proMconv(var src1,src2,dest:Tmatrix);pascal;
procedure proMconv_1(var src1,src2,dest:Tmatrix;Fcomp:boolean);pascal;

procedure proMexpand(var src,dest:Tmatrix;IFactor,JFactor:integer;interpolation:integer;
                     FadjustScale:boolean);pascal;
procedure proMatProfile(var mat:Tmatrix;x0,y0,theta:float;var vec:Tvector);pascal;

procedure proMatSectorToVec(var mat:Tmatrix;xa,ya,theta,Dtheta:float;var vec:Tvector;mode:integer);pascal;

implementation

const
  maxFilter=16;

  F_PrewittHoriz      =1;
  F_PrewittVert       =2;
  F_ScharrHoriz       =3;
  F_ScharrVert        =4;
  F_SobelHoriz        =5;
  F_SobelVert         =6;
  F_SobelHorizSecond  =7;
  F_SobelVertSecond   =8;
  F_SobelCross        =9;
  F_RobertsDown       =10;
  F_RobertsUp         =11;
  F_Laplace           =12;
  F_Gauss             =13;
  F_Hipass            =14;
  F_Lowpass           =15;
  F_Sharpen           =16;

  filterName:array[1..maxFilter] of AnsiString=
      (
      'MPrewittHoriz',
      'MPrewittVert',
      'MScharrHoriz',
      'MScharrVert',
      'MSobelHoriz',
      'MSobelVert',
      'MSobelHorizSecond',
      'MSobelVertSecond',
      'MSobelCross',
      'MRobertsDown',
      'MRobertsUp',
      'MLaplace',
      'MGauss',
      'MHipass',
      'MLowpass',
      'MSharpen'
      );


procedure copyBorder(var src,dest:Tmatrix;nb:integer);
var
  i,j,k:integer;
begin
  with src do
  begin
    for k:=0 to nb-1 do
    for i:=Istart to Iend do
    begin
      dest[i,Jstart+k]:=src[i,Jstart+k];
      dest[i,Jend-k]:=src[i,Jend-k];
    end;

    for k:=0 to nb-1 do
    for j:=Jstart to Jend do
    begin
      dest[Istart+k,j]:=src[Istart+k,j];
      dest[Iend-k,j]:=src[Iend-k,j];
    end;
  end;
end;



procedure proMFixedfilter(var src,dest:Tmatrix;mask:integer;tpF:integer);
var
  i,j:integer;
  dstRoiSize: IppiSize;
  res:IPPstatus;
  dx,dy:integer;
  psrc,pdst:pointer;
  StepSrc,StepDst:integer;
begin
  VerifierObjet(typeUO(src));
  VerifierObjet(typeUO(dest));

  if (mask<>33) and (mask<>55) then sortieErreur(filterName[tpF]+' : Invalid mask');

  IPPItest;

  if (src<>dest)
    then Mmodify(dest,src.tpNum,src.Istart,src.Iend,src.Jstart,src.Jend);

  McopyXYscale(src,dest);

  dx:=(mask div 10) div 2;             { dx et dy valent 1 ou 2 }
  dy:=(mask mod 10) div 2;
  copyBorder(src,dest,dx);

  Psrc:=Src.cell(src.Istart+dx,src.Jstart+dy);
  StepSrc:= src.stepIPP;
  Pdst:=dest.cell(src.Istart+dx,src.Jstart+dy);
  StepDst:= dest.stepIPP;


  with src do
  begin
    dstROIsize.width:=Icount-2*dx;
    dstROIsize.height:=Jcount-2*dy;
  end;

  res:=9999;
  case tpF of
    F_PrewittHoriz:
      case src.tpNum of
        G_smallint: res:=ippiFilterPrewittHoriz_16s_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize);
        G_single:  res:=ippiFilterPrewittHoriz_32f_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize);
      end;

    F_PrewittVert:
      case src.tpNum of
        G_smallint: res:=ippiFilterPrewittVert_16s_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize);
        G_single:  res:=ippiFilterPrewittVert_32f_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize);
      end;

    F_ScharrHoriz:
      case src.tpNum of
        G_single:  res:=ippiFilterScharrHoriz_32f_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize);
      end;

    F_ScharrVert:
      case src.tpNum of
        G_single:  res:=ippiFilterScharrVert_32f_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize);
      end;

    F_SobelVert:
      case src.tpNum of
        G_smallint: res:=ippiFilterSobelVert_16s_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize);
        G_single:  res:=ippiFilterSobelVertMask_32f_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize,IPPImaskSize(mask));
      end;

    F_SobelHoriz:
      case src.tpNum of
        G_smallint: res:=ippiFilterSobelHoriz_16s_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize);
        G_single:  res:=ippiFilterSobelHorizMask_32f_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize,IPPImaskSize(mask));
      end;

    F_SobelVertSecond:
      case src.tpNum of
        G_single:  res:=ippiFilterSobelVertSecond_32f_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize,IPPImaskSize(mask));
      end;

    F_SobelHorizSecond:
      case src.tpNum of
        G_single:  res:=ippiFilterSobelHorizSecond_32f_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize,IPPImaskSize(mask));
      end;

    F_SobelCross:
      case src.tpNum of
        G_single:  res:=ippiFilterSobelCross_32f_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize,IPPImaskSize(mask));
      end;

    F_RobertsDown:
      case src.tpNum of
        G_smallint: res:=ippiFilterRobertsDown_16s_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize);
        G_single:  res:=ippiFilterRobertsDown_32f_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize);
      end;

    F_RobertsUp:
      case src.tpNum of
        G_smallint: res:=ippiFilterRobertsUp_16s_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize);
        G_single:  res:=ippiFilterRobertsUp_32f_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize);
      end;

    F_Laplace:
      case src.tpNum of
        G_smallint: res:=ippiFilterLaplace_16s_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize,IPPImaskSize(mask));
        G_single:  res:=ippiFilterLaplace_32f_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize,IPPImaskSize(mask));
      end;

    F_gauss:
      case src.tpNum of
        G_smallint: res:=ippiFilterGauss_16s_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize,IPPImaskSize(mask));
        G_single:  res:=ippiFilterGauss_32f_C1R( psrc,stepSrc,pdst,stepdst,dstRoiSize,IPPImaskSize(mask));
      end;

    F_HiPass:
      case src.tpNum of
        G_smallint: res:=ippiFilterHiPass_16s_C1R(psrc,stepSrc,pdst,stepdst,dstRoiSize,IPPImaskSize(mask));
        G_single:  res:=ippiFilterHiPass_32f_C1R(psrc,stepSrc,pdst,stepdst,dstRoiSize,IPPImaskSize(mask));
      end;

    F_LowPass:
      case src.tpNum of
        G_smallint: res:=ippiFilterLowPass_16s_C1R(psrc,stepSrc,pdst,stepdst,dstRoiSize,IPPImaskSize(mask));
        G_single:  res:=ippiFilterLowPass_32f_C1R(psrc,stepSrc,pdst,stepdst,dstRoiSize,IPPImaskSize(mask));
      end;

    F_Sharpen:
        case src.tpNum of
          G_smallint:  res:=ippiFilterSharpen_16s_C1R(psrc,stepSrc,pdst,stepdst,dstRoiSize);
          G_single:   res:=ippiFilterSharpen_32f_C1R(psrc,stepSrc,pdst,stepdst,dstRoiSize);
        end;

  end;

  if res=9999 then sortieErreur(filterName[tpF]+' : type not supported')
  else
  if res=-33 then sortieErreur(filterName[tpF]+' : bad mask')
  else
  if res<>0 then  sortieErreur(filterName[tpF]+' : IPPI error='+Istr(res));

end;


procedure proMconv_1(var src1,src2,dest:Tmatrix;Fcomp:boolean);
var
  res:integer;
  Mbuf:TmatBuffer;
  di,dj:integer;
begin
  IPPItest;

  VerifierObjet(typeUO(src1));
  VerifierObjet(typeUO(src2));
  VerifierObjet(typeUO(dest));


  if (src2.Icount>src1.Icount) then sortieErreur('Mconv : src2.Icount must be lower than src1.Icount');
  if (src2.Jcount>src1.Jcount) then sortieErreur('Mconv : src2.Jcount must be lower than src1.Jcount');

  if (src1.tpNum<>G_single) or (src2.tpNum<>G_single)
    then sortieErreur('Mconv : bad src number types');

  Mmodify(dest,src1.tpNum,src1.Istart,src1.Iend,src1.Jstart,src1.Jend);

  McopyXYscale(src1,dest);

  if Fcomp then
  begin
    Mbuf:=TmatBuffer.create(g_single,0,src1.Icount+src2.Icount-2,0,src1.Jcount+src2.Jcount-2) ;

    try
    res:=ippiConvFull_32f_C1R( src1.tb,src1.stepIPP,src1.sizeIPP,
                               src2.tb,src2.stepIPP,src2.sizeIPP,
                               Mbuf.tb,Mbuf.stepIPP);

    di:=src2.Icount div 2;
    dj:=src2.Jcount div 2;

    ippicopy_32f_C1R(Mbuf.getP(di,dj),Mbuf.stepIPP,dest.tb,dest.stepIPP,dest.sizeIPP);

    finally
    Mbuf.Free;
    end;
  end
  else res:=ippiConvValid_32f_C1R( src1.tb,src1.stepIPP,src1.sizeIPP,
                                   src2.tb,src2.stepIPP,src2.sizeIPP,
                                   dest.cell(dest.Istart+src2.Icount div 2,dest.Jstart+src2.Jcount div 2),dest.stepIPP);

  IPPIend;
end;

procedure proMconv(var src1,src2,dest:Tmatrix);
begin
  proMconv_1(src1,src2,dest,false);
end;


procedure proMexpand(var src,dest:Tmatrix;IFactor,JFactor:integer;interpolation:integer;FadjustScale:boolean);
var
  res:integer;
  nbI,nbJ:integer;
  deltaI,deltaJ:integer;
  xfactor,yfactor:float;
begin
  IPPItest;

  VerifierObjet(typeUO(src));
  VerifierObjet(typeUO(dest));


  if (src.tpNum<>G_single) then sortieErreur('Mresize : bad src number type');
  if (Ifactor<=1) then sortieErreur('Mexpand : bad I factor');
  if (Jfactor<=1) then sortieErreur('Mexpand : bad J factor');

  { dimensions de Dest }
  nbI:=src.Icount*Ifactor;
  nbJ:=src.Jcount*Jfactor;

  { facteurs pour resize }
  deltaI:=Ifactor div 2;
  deltaJ:=Jfactor div 2;
  xfactor:=Ifactor -2*deltaI/src.Icount;
  yfactor:=Jfactor -2*deltaJ/src.Jcount;

  Mmodify(dest,src.tpNum,src.Istart,src.Istart+nbI-1,src.Jstart,src.Jstart+nbJ-1);

  case interpolation of
    0 : interpolation:=IPPI_inter_NN;
    1 : interpolation:=IPPI_inter_LINEAR;
    2 : interpolation:=IPPI_inter_CUBIC;
    3 : interpolation:=IPPI_inter_SUPer;
    else interpolation:=IPPI_inter_NN;
  end;


  if (src is Tmat) then swap(xfactor,yfactor);

  res:=ippiResize_32f_C1R(Src.tb,src.SizeIPP,src.StepIPP,src.RectIPP(0,0,src.Icount,src.Jcount),
                       Dest.cell(dest.Istart+deltaI,dest.Jstart+deltaJ),Dest.StepIPP,
                       dest.SizeIPP(dest.Icount-2*deltaI,dest.Jcount-2*deltaJ),
                       xFactor,yFactor,interpolation);

  if FadjustScale then
  begin
    dest.Dxu:=src.dxu/Ifactor;
    dest.Dyu:=src.dyu/Jfactor;

    dest.x0u:=src.Istart*(src.Dxu-dest.Dxu)+src.X0u;
    dest.y0u:=src.Jstart*(src.Dyu-dest.Dyu)+src.Y0u;

  end;

  IPPIend;
end;


function compare (Item1, Item2: Pointer): Integer;
const
  eps=1E-10;
begin

  if PRpoint(item1)^.x<PRpoint(item2)^.x-eps
    then result:=-1
  else
  if abs(PRpoint(item1)^.x-PRpoint(item2)^.x)<eps then
  begin
    if PRpoint(item1)^.y<PRpoint(item2)^.y-eps
      then result:=-1
    else
    if abs(PRpoint(item1)^.y-PRpoint(item2)^.y)<eps
      then result:=0
    else result:=1;
  end
  else result:=1;
end;

procedure MatProfile(mat:Tmatrix;x0,y0,theta:float;vec:Tvector);
var
  i,j:integer;
  a0:float;
  list:TlistG;
  pp:TRpoint;
  d1,d2:float;
  i1,i2:integer;
  i0,j0:integer;

function getI0(x:float):integer;
begin
  with mat do
  result:=floor((x-x0u)/Dxu);
end;

function getJ0(y:float):integer;
begin
  with mat do
  result:=floor((y-y0u)/Dyu);
end;


begin
  try
    a0:=tan(theta);
  except
    a0:=1E100;
  end;

  if abs(a0)>1E18 then a0:=1E100;

  list:=TlistG.create(sizeof(TRpoint));
  try
  with mat do
  begin
    for i:=Istart to Iend+1 do
    begin
      pp.x:=convx(i);
      pp.y:=a0*(pp.x-x0)+y0;
      if (pp.y>=Ystart) and (pp.y<=Yend+dyu)
        then list.Add(@pp);
    end;

    if a0<>0 then
    for j:=Jstart to Jend+1 do
    begin
      pp.y:=convy(j);
      pp.x:=(pp.y-y0)/a0 +x0 ;
      if (pp.x>=Xstart) and (pp.x<=Xend+dxu)
        then list.Add(@pp);
    end;

    list.Sort(compare);
  end;

  with list do
  for i:=1 to count-1 do
  begin
    if abs(cos(theta))>0.5 then
    begin
      d1:=(PRpoint(items[i-1]).x-x0)/cos(theta);
      d2:=(PRpoint(items[i]).x-x0) /cos(theta);
    end
    else
    begin
      d1:=(PRpoint(items[i-1]).y-y0)/sin(theta);
      d2:=(PRpoint(items[i]).y-y0)/sin(theta);
    end;

    i0:=getI0((PRpoint(items[i-1]).x + PRpoint(items[i]).x)/2);
    j0:=getJ0((PRpoint(items[i-1]).y + PRpoint(items[i]).y)/2);

    if (i0>=mat.Istart) and (i0<=mat.Iend) and (j0>=mat.Jstart) and (j0<=mat.Jend) then
    with vec do
    begin
      i1:=invconvx(d1);
      i2:=invconvx(d2);
      if i1>i2 then swap(i1,i2);

      if i1<Istart then i1:=Istart;
      if i2>Iend then i2:=Iend;
      fill1(mat[i0,j0],i1,i2);
    end
  end;

  finally
    list.free;
  end;
end;

procedure proMatProfile(var mat:Tmatrix;x0,y0,theta:float;var vec:Tvector);
begin
  verifierMatrice(mat);
  verifierVecteur(vec);
  MatProfile(mat,x0,y0,theta,vec);
end;

procedure matSectorToVec(mat:Tmatrix;xa,ya,xb,yb,Dtheta:float;vec:Tvector;mode:integer);
var
  i,j:integer;
  x,y,d,dmax:float;
  nb:array of integer;
  ind,indmax,indvec:integer;
  deltaL:float;
begin
  deltaL:=vec.Dxu;

  with mat do
  begin
    dmax:=sqrt(sqr(Xstart-xa)+sqr(Ystart-ya));
    d:=sqrt(sqr(Xend-xa)+sqr(Ystart-ya));
    if d>dmax then dmax:=d;
    d:=sqrt(sqr(Xend-xa)+sqr(Yend-ya));
    if d>dmax then dmax:=d;
    d:=sqrt(sqr(Xstart-xa)+sqr(Yend-ya));
    if d>dmax then dmax:=d;

    indmax:=round(dmax/deltaL)+1;
    setLength(nb,indmax);
    fillchar(nb[0],sizeof(integer)*indmax,0);
  end;

  vec.modify(vec.tpNum,0,indmax+1);
  vec.X0u:=0;

  with mat do
  begin
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
    begin
      x:=convx(i);
      y:=convy(j);
      
      if PointInSector(xa,ya,xb,yb,Dtheta,x,y) then
      begin
        d:=sqrt(sqr(x-xa)+sqr(y-ya));
        ind:=floor(d/deltaL);
        inc(nb[ind]);
        vec.Yvalue[ind]:=vec.Yvalue[ind]+Zvalue[i,j];
      end;
    end;
  end;

  if mode=1 then
  with vec do
  for i:=0 to indmax do
    if nb[i]>0 then vec[i]:=vec[i]/nb[i];
end;

procedure proMatSectorToVec(var mat:Tmatrix;xa,ya,theta,Dtheta:float;var vec:Tvector;mode:integer);
var
  xb,yb:float;
begin
  verifierMatrice(mat);
  verifierVecteur(vec);

  xb:=xa+cos(theta);
  yb:=ya+sin(theta);

  MatSectorToVec(mat,xa,ya,xb,yb,Dtheta,vec,mode);
end;



end.
