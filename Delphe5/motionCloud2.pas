unit MotionCloud2;

interface

uses math,
     util1, stmdef, stmObj,stmPg,Ncdef2,stmMat1,
     ippdefs,ipps,ippsovr, ippi, mathKernel0, MKL_dfti,
     Laguerre1;


{  Utilisation de TmotionCloud

   Dans l'ordre, il faut:
     - appeler Init qui fixe les paramètres généraux (taille des matrices, seed et ss
     - installer un filtre avec InstallGaborFilter, InstallMaternFilter ou InstallFilter
     - appeler InitNoise qui initialise les tableaux Xe1 et Xe2
     - appeler GetFrame pour chaque image générée


   Si on veut faire évoluer un ou plusieurs paramètres de filtre, on peut appeler InstallFilter entre deux getFrame.
   Dans ce cas, on n'appelle pas InitNoise.

   GetFilter permet de récupérer dans une matrice le filtre calculé.
}


{   Condition de calcul: ss< (4-2*sqrt(2))/(N*Dt)

}

type
  TmotionCloud=
              class(typeUO)

              private
                Nx,Ny:integer;
                Finit: boolean;      // mis à true avec Init
                                     // Init est toujours obligatoire
                FinitNoise: boolean; // mis à true avec InitNoise
                                     // InitNoise est obligatoire avant le premier getFrame

                LastFrame: PtabDouble;
                fftNoise: PtabDoubleComp;
                Xn2,Xn1,Xn0: PtabDoubleComp;
                seed: longint;



                procedure paramAR(ss:float);
                procedure ComputeNoise(fftNoise: PtabDoubleComp ;filter: PtabDouble);
                procedure InitFilterConstants;

                procedure Autoreg;
                procedure expand(src,dest:PtabDouble;Dx,x0,Dy,y0: float);

              public
                a,b,c,filter: PtabDouble;
                mu,sigma: float;

                DxF,x0F,DyF,y0F:float;
                dtAR:float;
                Nsample: integer;

                constructor create;override;
                destructor destroy;override;

                class function STMClassName:AnsiString;override;

                procedure InstallGaborFilter( ss, r0, sr0, stheta0: float);
                procedure AdjustLogGaborParams(var r0,sr0,ss:float);

                procedure InstallLogGaborFilter( ss, r0, sr0, stheta0: float);
                procedure InstallMaternFilter( ss, eta, alpha: float);
                procedure InstallFilter( var mat: Tmatrix);

                procedure Init( Nx1,Ny1:integer;seed1:integer; const Fmem:boolean=true);

                procedure InitNoise;

                procedure done;
                procedure getFrame(mat: Tmatrix);
                procedure getFilter(mat: Tmatrix);
              end;


procedure proTmotionCloud_Create(var pu:typeUO);pascal;
procedure proTmotionCloud_Init(dt: float;Nsample1:integer; Nx1,Ny1: integer; seed: longword;var pu:typeUO);pascal;

procedure proTmotionCloud_InstallGaborFilter( ss, r0, sr0, stheta0: float; var pu:typeUO);pascal;
procedure proTmotionCloud_InstallMaternFilter( ss, eta, alpha: float; var pu:typeUO);pascal;

procedure proTmotionCloud_InstallFilter(var mat: Tmatrix;var pu:typeUO);pascal;
procedure proTmotionCloud_getFilter(var mat: Tmatrix;var pu:typeUO);pascal;

procedure proTmotionCloud_done(var pu:typeUO);pascal;
procedure proTmotionCloud_getFrame(var mat: Tmatrix; var pu:typeUO);pascal;

procedure proTmotionCloud_SetExpansion(DxF1,x0F1,DyF1,y0F1:float;var pu:typeUO);pascal;

implementation

(* Jonathan: Dans les 3 fonctions suivantes,
 il faut diviser les filtres obtenus par leur variance *)

procedure TmotionCloud.InstallGaborFilter( ss,r0, sr0, stheta0: float);
var
  x,y,r,theta: float;
  i,j:integer;
begin
  paramAR(ss);
(*
  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
  begin
    x:= i*2*PI/nx;
    if x>=pi then x:= x- 2*PI;

    y:= j*2*PI/ny;
    if y>=pi then y:= y-2*PI;

    r:= sqrt(sqr(x)+sqr(y));
    theta:= arctan2(y,x){-theta0};

    filter[i+j*nx]:= (exp(- sqr(theta)/(2*sqr(stheta0)))  +   exp(   -sqr(theta+ PI)/(2*sqr(stheta0)) ))
                      *
                      exp(-sqr(r-r0)/(2*sqr(sr0)));
  end;
*)


  for i:=0 to nx div 2-1 do
  for j:=0 to ny div 2-1 do
  begin
    x:= i;
    y:= j;

    r:= sqrt(sqr(x)+sqr(y));
    theta:= arctan2(y,x){-theta0};

    filter[i+j*nx]:= (exp(- sqr(theta)/(2*sqr(stheta0)))  {+   exp(   -sqr(theta+ PI)/(2*sqr(stheta0)) )})
                      *
                      exp(-sqr(r-r0)/(2*sqr(sr0)));

    filter[(Nx-1-i) +j*Nx]:= filter[i +j*Nx];
  end;

  for i:=0 to nx -1 do
  for j:=0 to ny div 2-1 do
     filter[(Nx-1-i) +(Ny-j-1)*Nx]:= filter[i +j*Nx];

 (*
  for i:=0 to nx -1 do
  for j:=0 to ny -1 do
  begin
    x:= i*2*PI/nx;
    if x>pi then x:=x-2*pi;
    y:= j*2*PI/ny;
    if y>pi then y:=y-2*pi;

    r:= sqrt(sqr(x)+sqr(y));
    theta:= arctan2(y,x){-theta0};
    if theta>pi/2

    filter[i+j*nx]:= (exp(- sqr(theta)/(2*sqr(stheta0)))  +   exp(   -sqr(theta+ PI)/(2*sqr(stheta0)) ))
                      *
                      exp(-sqr(r-r0)/(2*sqr(sr0)));

    filter[(Nx-1-i) +j*Nx]:= filter[i +j*Nx];
  end;
  *)


  InitFilterConstants;
end;

procedure TmotionCloud.AdjustLogGaborParams(var r0,sr0,ss:float);
var
  Degree: integer;
  Poly      : TNCompVector;
  InitGuess : TNcomplex;
  Tol       : Float;
  MaxIter   : integer;
  NumRoots  : integer;
  Roots     : TNCompVector;
  yRoots    : TNCompVector;
  Iter      : TNIntVector;
  Error     : byte;

  stR:string;
  i,i0:integer;
  GoodRoot: double;

Const
  Eps=1E-10;

begin
   Degree:=8;
   Poly[0]:=Doublecomp(-sr0/sqr(r0),0);     //
   Poly[1]:=Doublecomp(0,0);
   Poly[2]:=Doublecomp(1,0);
   Poly[3]:=Doublecomp(0,0);
   Poly[4]:=Doublecomp(3,0);
   Poly[5]:=Doublecomp(0,0);
   Poly[6]:=Doublecomp(3,0);
   Poly[7]:=Doublecomp(0,0);
   Poly[8]:=Doublecomp(1,0);
   fillchar(InitGuess,sizeof(InitGuess),0);
   Tol:= 1e-6;
   MaxIter:=1000;

   Laguerre( Degree, Poly, InitGuess, Tol, MaxIter, NumRoots, Roots, yRoots, Iter, Error);
   {
   stR:='NumRoots= '+Istr(NumRoots)+'  Roots= ';
   for i:=0 to 8 do stR:= stR+ Estr(Roots[i].x,3)+'  '+Estr(Roots[i].y,3)+crlf;
   stR:=stR+crlf +' error= '+Istr(error);
   messageCentral(stR);
   }
  // ranger la racine réelle positive dans sr0
  // dans r0, ranger r0*(1+sqr(sr0))
  i0:=-1;
  for i:=1 to 8 do
  if (abs(Roots[i].y)<Eps) and (Roots[i].x>0) then i0:=i;

  if (i0<0) or (error<>0) then
  begin
    messageCentral('Error AdjustLogGaborParams');
    exit;
  end;

  sr0:=Roots[i0].x;
  r0:= r0*(1+sqr(sr0));
  ss:=ss/r0;

end;



procedure TmotionCloud.InstallLogGaborFilter( ss ,r0, sr0, stheta0: float);
var
  x,y,r,theta: float;
  i,j:integer;
  fN: float;
Const
  eps=1E-6;
begin
  //ss:=1/ss;
  AdjustLogGaborParams(r0,sr0,ss);
  paramAR(ss);

  for i:=0 to nx div 2 do
  for j:=0 to ny div 2 do
  begin
    x:= i;
    y:= j;

    r:= sqrt(sqr(x)+sqr(y))+Eps;

    theta:= arctan2(y,x){-theta0};

    filter[i+j*nx]:=  exp( cos(2*theta)/stheta0 )
                      *
                      exp(-1/2*sqr(ln(r/r0)) /ln(1+sqr(sr0))) * power(r0/r,3)*ss*r;

    if i>0 then filter[(Nx-i) +j*Nx]:= filter[i +j*Nx];
  end;

  for i:=0 to nx -1 do
  for j:=1 to ny div 2 do
     filter[i +(Ny-j)*Nx]:= filter[i +j*Nx];


  fN:=0;
  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
  begin
    if i>=nx div 2 then x:= nx-i else x:= i;
    if j>=ny div 2 then y:= ny-j else y:= j;

    r:= sqrt(sqr(x)+sqr(y))+Eps;
    if (x>0) or (y>0) then fN:= fN + filter[i+j*nx]/(4*power(ss*r,3));
  end;

  for i:=0 to nx*ny-1 do filter[i]:= sqrt(filter[i]*nx*ny/dtAR/fN);

end;


procedure TmotionCloud.InstallMaternFilter( ss, eta, alpha: float);
var
  x,y: float;
  i,j:integer;
Const
  theta0=0;
begin
  paramAR(ss);
  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
  begin
    x:= i;
    if i>nx div 2 then x:= x- nx/2;

    y:= j;
    if j> ny div 2 then y:= y- ny/2;

    filter[i+j*nx] := 1/power(2*pi/Nx+(power(cos(theta0),2)+eta*power(sin(theta0),2))*x*x
				    +(eta*power(cos(theta0),2)+power(sin(theta0),2))*y*y
				    +2*(eta-1)*cos(theta0)*sin(theta0)*x*y, alpha/2);
  end;

  InitFilterConstants;
end;


(* Jonathan: la nouvelle fonction paramAR renvoit les listes a, b et c utilisées dans autoreg
 attention il y a un argument en plus "dt" que je n'ai pas répercuté ailleurs ("dt" est un pas de temps") *)

procedure  TmotionCloud.paramAR(ss: float);
var
  x,y,r: float;
  i,j:integer;
  min,max:double;
Const
  eps=1E-12;
begin
  //ss:=1/ss;

  for i:=0 to nx div 2 do
  for j:=0 to ny div 2 do
  begin
    x:= i;
    y:= j;

    r:= sqrt(sqr(x)+sqr(y))+Eps;

    a[i+j*nx] := 2-dtAR*2*ss*r-sqr(dtAR*ss*r);
    b[i+j*nx] := -1+dtAR*2*ss*r;
    c[i+j*nx] := 50*sqr(dtAR);

    if i>0 then
    begin
      a[(Nx-i) +j*Nx]:= a[i +j*Nx];
      b[(Nx-i) +j*Nx]:= b[i +j*Nx];
      c[(Nx-i) +j*Nx]:= c[i +j*Nx];
    end;
  end;

  for i:=0 to nx -1 do
  for j:=1 to ny div 2 do
  begin
   a[i +(Ny-j)*Nx]:= a[i +j*Nx];
   b[i +(Ny-j)*Nx]:= b[i +j*Nx];
   c[i +(Ny-j)*Nx]:= c[i +j*Nx];
  end;

  {
  min:=0;
  max:=0;
  for i:=0 to nx*ny-1 do
  begin
    if a[i]<min then min:=a[i];
    if a[i]>max then max:=a[i];

    if b[i]<min then min:=b[i];
    if b[i]>max then max:=b[i];

    if c[i]<min then min:=c[i];
    if c[i]>max then max:=c[i];

  end;

  messageCentral('min='+Estr(min,9)+crlf+'max='+Estr(max,9)) ;
  }
end;


procedure TmotionCloud.ComputeNoise(fftNoise: PtabDoubleComp ;filter: PtabDouble);
var
  i:integer;
  Noise: PtabDouble;
  res:integer;
  dim:array[1..2] of integer;
  Hdfti: pointer;
  w:float;
begin
  mkltest;
  ippstest;

  getmem( Noise, nx*ny * sizeof(Double));

  res:= ippsRandGauss_Direct(PDouble(noise),Nx*Ny,mu,sigma, @Seed);

  //noise = random en complexes
  res:= ippsRealToCplx(PDouble(noise),nil, PDoubleComp(fftNoise) ,nx*ny);

  // Calculer la DFT de fftNoise
  dim[1]:=Nx;
  dim[2]:=Ny;

  res:=DftiCreateDescriptor(Hdfti,dfti_Double, dfti_complex ,2, @Dim);
  if res<>0 then exit;

  res:= DftiSetValueI(Hdfti, DFTI_FORWARD_DOMAIN, DFTI_COMPLEX);
  res:=DftiCommitDescriptor(Hdfti);

  res:=DftiComputeForward1(hdfti,fftNoise);
  DftiFreeDescriptor(hdfti);

  // multiplier fftNoise par filter
  {
  for i:=0 to Nx*Ny-1 do
  begin
    fftNoise^[i].x:=  fftNoise^[i].x* filter^[i];
    fftNoise^[i].y:=  fftNoise^[i].y* filter^[i];
  end;
  }
  // On garde la transformée de Fourier filtrée

  freemem(Noise);
  //  Pas le bruit initial

  ippsEnd;
  mklEnd;
end;



constructor TmotionCloud.create;
begin
  inherited;

  Nx:=256;
  Ny:=256;

  DxF:=1;
  x0F:=128;
  DyF:=1;
  y0F:=128;

  mu:=0;
  sigma:=1;
end;

destructor TmotionCloud.destroy;
begin
  done;
  inherited;
end;

procedure TmotionCloud.done;
begin
  Finit:=false;
  FinitNoise:=false;

  freemem(LastFrame);
  LastFrame:=nil;

  freemem(fftnoise);
  fftnoise:=nil;

  freemem(filter);
  filter := nil;

  freemem(a);
  a := nil;

  freemem(b);
  b := nil;

  freemem(c);
  c := nil;

  freemem(Xn0);
  Xn0 := nil;

  freemem(Xn1);
  Xn1 := nil;

  freemem(Xn2);
  Xn2 := nil;

end;



procedure TmotionCloud.getFrame(mat: Tmatrix);
var
  i,j:integer;
  res:integer;
  dim:array[1..2] of integer;
  Hdfti: pointer;
  w:float;
begin
  if not Finit then sortieErreur('TmotionCloud : TmotionCloud is not initialized');
  if not FinitNoise then initNoise;

  ComputeNoise(fftnoise, filter);

  Autoreg;

  dim[1]:=Nx;
  dim[2]:=Ny;

  res:=DftiCreateDescriptor(Hdfti,dfti_Double, dfti_complex ,2, @Dim);
  if res<>0 then exit;

  res:= DftiSetValueI(Hdfti, DFTI_FORWARD_DOMAIN, DFTI_COMPLEX);


  w:=  1/( Nx*Ny);
  res:=DftiSetValueS(hdfti,DFTI_BACKWARD_SCALE,w);

  res:=DftiCommitDescriptor(Hdfti);

  res:=DftiComputeBackward1(hdfti,Xn2);
  DftiFreeDescriptor(hdfti);

  // La partie réelle donne LastFrame
  ippsReal(PDoubleComp(Xn2),PDouble(LastFrame),Nx*Ny);


  mat.initTemp(0,Nx-1,0,Ny-1,g_single);

  for j:=0 to Ny-1 do
  for i:=0 to Nx-1 do
    mat[i,j]:=  LastFrame^[i+Nx*j];

end;

procedure TmotionCloud.getFilter(mat: Tmatrix);
var
  i,j:integer;
begin
  if not Finit then sortieErreur('TmotionCloud.getFilter : TmotionCloud is not initialized');

  mat.initTemp(0,Nx-1,0,Ny-1,g_single);

  for j:=0 to Ny-1 do
  for i:=0 to Nx-1 do
    mat[i,j]:= filter^[i+Nx*j];
    //mat[i,j]:= c^[i+Nx*j];
end;

procedure TmotionCloud.InstallFilter(var mat: Tmatrix);
var
  i,j:integer;
begin
  if not Finit then sortieErreur('TmotionCloud.InstallFilter : TmotionCloud is not initialized');
  if (mat.Icount<>Nx) or (mat.Jcount<>Ny) then sortieErreur('TmotionCloud.InstallFilter : matrix with bad size');

  for i:=0 to Nx-1 do
  for j:=0 to Ny-1 do
    filter^[i+Nx*j]:=mat[mat.Istart+i,mat.Jstart+j];

  InitFilterConstants;
end;


procedure TmotionCloud.Init( Nx1,Ny1:integer;seed1:integer; const Fmem:boolean=true);
begin
  done;

  Finit:=true;
  FinitNoise:=false;

  Nx:= Nx1;
  Ny:= Ny1;
  seed:=seed1;

  getmem(filter,nx*ny*sizeof(Double));
  getmem(a,nx*ny*sizeof(Double));
  getmem(b,nx*ny*sizeof(Double));
  getmem(c,nx*ny*sizeof(Double));

  if Fmem then
  begin
    getmem(LastFrame,nx*ny*sizeof(Double));
    getmem(fftNoise,nx*ny*sizeof(TDoubleComp));

    getmem(Xn0,nx*ny*sizeof(TDoubleComp));
    getmem(Xn1,nx*ny*sizeof(TDoubleComp));
    getmem(Xn2,nx*ny*sizeof(TDoubleComp));

    fillchar(Xn0^,nx*ny*sizeof(TDoubleComp),0);
    fillchar(Xn1^,nx*ny*sizeof(TDoubleComp),0);
  end;

  DxF:=1;
  x0F:=Nx1/2;
  DyF:=1;
  y0F:=Ny1/2;

end;

procedure TmotionCloud.InitFilterConstants;
var
  i:integer;
  wm,wstd, wnorm: Double;
begin
  ippsSqrt(PDouble(filter),Nx*Ny);
  //ippsNorm_L2(PDouble(filter),Nx*Ny,@wnorm);
  //ippsMulC(1/wnorm, PDouble(filter),Nx*Ny);

  ippsStdDev(PDouble(filter),Nx*Ny,@wstd);

  if wstd>0 then
  for i:=0 to Nx*Ny-1 do
  begin
    filter[i]:= filter[i]/wstd;
  end;



end;

procedure TmotionCloud.InitNoise;
var
  i,j:integer;
begin
  FinitNoise:=true;
  //ComputeNoise(Xn1, filter);
  //ComputeNoise(Xn0, filter);

  for j:=0 to 499 do
  begin
    ComputeNoise(fftnoise,filter);
    Autoreg;
  end;

end;

procedure TmotionCloud.Autoreg;
var
  i:integer;

begin
  for i:=0 to nx*ny-1 do
  begin
    Xn2[i].x := a[i]*Xn1[i].x + b[i]*Xn0[i].x + c[i]* fftnoise[i].x;
    Xn2[i].y := a[i]*Xn1[i].y + b[i]*Xn0[i].y + c[i]* fftnoise[i].y;
  end;


  if (DxF<>1) or (x0F<>Nx/2) or (DyF<>1) or (y0F<>Ny/2) then
  begin
  {
    expand(Xn1,Xn0,DxF, x0F *(1-DxF) ,DyF,y0F *(1-DyF));
    expand(Xn2,Xn1,DxF, x0F *(1-DxF) ,DyF,y0F *(1-DyF));
    }
  end
  else
  begin
    move(Xn1^,Xn0^,nx*ny*sizeof(TDoubleComp));
    move(Xn2^,Xn1^,nx*ny*sizeof(TDoubleComp));
  end;




  {
  ippsMulC( PDouble(@Xn1[0]), a, PDouble(@Xn2[0]), Nx*Ny);
  ippsMulC( b, PDouble(@Xn0[0]),Nx*Ny);
  ippsAdd( PDouble(@Xn0[0]), PDouble(@Xn2[0]), Nx*Ny);
  ippsAdd( PDouble(@noise[0]), PDouble(@Xn2[0]), Nx*Ny);

  move(Xn1[0], Xn0[0], Nx*Ny*sizeof(Double));
  move(Xn2[0], Xn1[0], Nx*Ny*sizeof(Double));
  }
end;



class function TmotionCloud.STMClassName: AnsiString;
begin
  result:='MotionCloud';
end;

procedure TmotionCloud.expand(src, dest: PtabDouble; Dx, x0, Dy, y0: float);
var
  srcSize: IppiSize;
  srcROI,dstROI:IppiRect;
  pBuffer: pointer;
  size:integer;
begin

  srcSize.width:= Ny*8;
  srcSize.height:=Nx*8;

  with srcROI do
  begin
    x:=0;
    y:=0;
    width:=Ny;
    height:=Nx;
  end;

  with dstROI do
  begin
    x:=0;
    y:=0;
    width:= Ny;
    height:=Nx;
  end;

 // sizes in bytes
 // steps in bytes
 // inverser X et Y à tous les niveaux

  ippitest;
  size:=0;
  if ippiResizeGetBufSize(srcROI,dstROI, 1 , IPPI_INTER_LINEAR, Size)=0 then
  try
    getmem(pBuffer,size*8);
    ippiResizeSqrPixel_32f_C1R( Src, srcSize, Ny*8, srcROI,
                                Dest, Ny*8, dstROI,
                                Dy, Dx, y0, x0, IPPI_INTER_LINEAR, pBuffer);
  finally
    freemem(pBuffer);
  end;

  ippiEnd;
end;



{************************************************ STM functions *********************************************************}

procedure proTmotionCloud_Create(var pu:typeUO);
begin
  createPgObject('',pu,TmotionCloud);
end;

procedure proTmotionCloud_Init(dt: float;Nsample1:integer; Nx1,Ny1: integer; seed: longword;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmotionCloud(pu) do
  begin
    dtAR:=dt;
    Nsample:=Nsample1;
    init(Nx1,Ny1, seed);
  end;
end;

procedure proTmotionCloud_InstallGaborFilter( ss, r0, sr0, stheta0: float; var pu:typeUO);
begin
  verifierObjet(pu);
  with TmotionCloud(pu) do
  begin
    InstallLogGaborFilter( ss, r0, sr0, stheta0);

  end;
end;

procedure proTmotionCloud_InstallMaternFilter( ss, eta, alpha: float; var pu:typeUO);
begin
  verifierObjet(pu);
  with TmotionCloud(pu) do
  begin
    InstallMaternFilter( ss, eta, alpha);

  end;
end;

procedure proTmotionCloud_done(var pu:typeUO);
begin
  verifierObjet(pu);
  with TmotionCloud(pu) do done;
end;

procedure proTmotionCloud_getFrame(var mat: Tmatrix; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);
  with TmotionCloud(pu) do getFrame(mat);
end;

procedure proTmotionCloud_getFilter(var mat: Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);
  with TmotionCloud(pu) do getFilter(mat);
end;

procedure proTmotionCloud_InstallFilter(var mat: Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);
  with TmotionCloud(pu) do
  begin
    installFilter(mat);

  end;
end;

procedure proTmotionCloud_SetExpansion(DxF1,x0F1,DyF1,y0F1:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmotionCloud(pu) do
  begin
    DxF := DxF1;
    x0F := x0F1;
    DyF := DyF1;
    y0F := y0F1;
  end;
end;

end.



Initialization

registerObject(TmotionCloud,sys);

end.






