unit optifit1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Dgraphic,
     IPPS,IPPdefs,IPPSovr,
     Ncdef2,stmPg,
     stmDef,stmObj,stmvec1,stmMat1,mathKernel0,stmKLmat;

type
  ToptiFitTh0=class
             cntmax:integer;
             seuil:float;
             Nblin1,NbNonLin1:integer;
             nbpt,nbpara:integer;

             xdat1:Tmat;       {vecteur colonne contenant les entrées M points}
             ydat:Tmat;        {vecteur colonne contenant les sorties M points}
             yfit:Tmat;        {vecteur colonne contenant l'estimation M points}

             para:Tmat;        {vecteur colonne contenant les paramètres P valeurs}
             Jmat:Tmat;        {Le jacobien  M lignes P colonnes}

             ylin1:Tmat;

             Vclamp:array of boolean;

             ChiSq1:double;
             IDatStart,IdatEnd:array of integer;

             constructor create;
             destructor destroy;override;

             procedure getYfit(pp:Tmat);virtual;
             procedure getJacobian(pp:Tmat);virtual;

             procedure checkLimits(dd:Tmat;n:integer;min,max:float);
             procedure controleVar(dd:Tmat);virtual;

             procedure InstallData(vecX,vecY,Vlin,Vnotlin:Tvector;NblinA1,NblNonLinA1:integer);
             procedure InstallSegs(Vseg:Tvector;i0:integer);
             procedure getData(vecFit,Vlin,Vnotlin:Tvector);
             function Chi2(vec:Tmat):double;

             procedure execute;


             procedure Add(src:Tmat;w:float);overload;
             procedure Add(src1,src2:Tmat);overload;
             procedure Add(src1,src2,dest:Tmat);overload;

             procedure Mul(src:Tmat;w:float);overload;
             procedure Mul(src1,src2:Tmat);overload;
             procedure Mul(src1,src2,dest:Tmat);overload;

             procedure Thresh1(src:Tmat;w:float;up:boolean);
             procedure AbsThresh(src:Tmat;w:float);
             procedure ln1(src:Tmat);
             procedure exp1(src:Tmat);
             procedure vecToJmat(src:Tmat;num:integer);
           end;

  ToptiFitTh1=class(ToptifitTh0)
             procedure getYfit(pp:Tmat);override;
             procedure getJacobian(pp:Tmat);override;
           end;

  ToptiFitPoly1=class(ToptifitTh0)
             procedure getYfit(pp:Tmat);override;
             procedure getJacobian(pp:Tmat);override;
           end;

  ToptiFitPower1=class(ToptifitTh0)
             procedure getYfit(pp:Tmat);override;
             procedure getJacobian(pp:Tmat);override;
             procedure controleVar(dd:Tmat);override;
           end;

  ToptiFitPower2=class(ToptifitTh0)

             xdat2:Tmat;
             ylin2:Tmat;

             Nblin2:integer;

             constructor create;
             destructor destroy;override;

             procedure getYfit(pp:Tmat);override;
             procedure getJacobian(pp:Tmat);override;
             procedure controleVar(dd:Tmat);override;

             procedure InstallData(vecX1,vecX2,vecY,Vlin1,Vlin2:Tvector;Nbl1,NbL2:integer;Cp,g0,Cte:float);
             procedure getData(vecFit,Vlin1,Vlin2:Tvector;var Cp,g0,Cte:float);

           end;



procedure proOptiTh0(var VInput,VOutPut,Vlin,VecE: Tvector;NblinA1: integer;var chi2:float;nbIt:integer);pascal;
procedure proOptiTh1(var VInput,VOutPut,Vlin,VecE: Tvector;NblinA1: integer;var th,chi2:float;nbIt:integer);pascal;
procedure proOptiPoly(var VInput,VOutPut,Vlin,Vnotlin,VecE: Tvector;NblinA1,nbNotlin1: integer;
                     var chi2:float;nbIt:integer);pascal;
procedure proOptiPower1(var VInput,VOutPut,Vlin,VecE: Tvector;NblinA1: integer;var Cp,chi2:float;nbIt:integer;clamp:integer);pascal;

procedure proOptiPower2(var VInput1,Vinput2,VOutPut,Vseg,Vlin1,Vlin2,VecE: Tvector;
                       NblinA1,NblinA2: integer;var Cp,g0,cte,chi2:float;nbIt,clamp:integer);pascal;


implementation


constructor ToptiFitTh0.create;
begin
   seuil:=1E15;
   cntmax:=1000;

   xdat1:=Tmat.create(g_double,1,1);
   ydat:=Tmat.create(g_double,1,1);
   yfit:=Tmat.create(g_double,1,1);
   para:=Tmat.create(g_double,1,1);
   Jmat:=Tmat.create(g_double,1,1);

   ylin1:=Tmat.create(g_double,1,1);

end;

destructor ToptiFitTh0.destroy;
begin
  xdat1.free;
  ydat.free;
  yfit.free;
  para.free;
  Jmat.free;

  ylin1.free;
  inherited;
end;

function ToptiFitTh0.Chi2(vec: Tmat): double;
var
  i,i1,i2:integer;
  dd:double;
begin
  if length(IdatStart)=0 then result:=sqr(vec.FrobNorm)
  else
  begin
    result:=0;
    for i:=0 to high(IdatStart) do
    begin
      i1:=IdatStart[i];
      i2:=IdatEnd[i];
      if (i1<=i2) and (i2<=nbpt) then
      begin
        ippsNorm_L2( Pdouble(@PtabDouble(vec.tb)^[i1]),i2-i1+1,@dd);
        result:=result+sqr(dd);
      end;
    end;
  end;
end;


procedure TOptiFitTh0.execute;
const
  lambda0=1E-5;
  Mlambda:float=10;
  IteraMax=25;
  epsilon=1E-300;
var
  Nlib:integer;
  befor,first,fin,finB:boolean;
  Lambda,LambdaB:float;
  i,j,k,itera:integer;
  chiSqr:float;

  Beta,BB,paraB:Tmat;
  Alpha:Tmat;
  tablo:Tmat;
  diff:Tmat;
  Vnorm:Tmat;

  cnt:longint;
  test:integer;
  w0:double;


begin
  Nbpt:=ydat.rowCount;
  Nbpara:=para.rowCount;;
  Nlib:=Nbpt-NbPara;
  if Nlib<=0 then exit;

  Lambda:=lambda0;
  befor:=false;
  first:=true;
  fin:=false;
  cnt:=0;

  Beta:=Tmat.create(g_double,Nbpara,1);
  BB:=Tmat.create(g_double,Nbpara,1);
  paraB:=Tmat.create(g_double,Nbpara,1);
  Alpha:=Tmat.create(g_double,Nbpara,Nbpara);
  tablo:=Tmat.create(g_double,Nbpara,Nbpara);
  diff:=Tmat.create(g_double,Nbpt,1);
  Vnorm:=Tmat.create(g_double,Nbpara,1);

  TRY
  repeat                          { Boucle principale }

    getYfit(para);                 { Calcul yfit = estimation pour para }

    diff.sub(ydat,yfit);                        { et Chisq1 = chi carré }
    chisq1:=chi2(diff)/Nlib;


    getJacobian(para);             { Calcul matrice jacobienne }

    for i:=1 to nbpara do
      if Vclamp[i-1] then ippsSet(1E10 ,Pdouble(Jmat.cell(1,i)),nbpt);


    beta.prod(Jmat,diff,transpose,normal);
    alpha.prod(Jmat,Jmat,transpose,normal);
    ippsMulC(1/nbpt,alpha.tbD,nbpara*nbpara);

    for i:=1 to nbpara do
     if abs(alpha[i,i])<epsilon then
       if alpha[i,i]>0 then alpha[i,i]:=epsilon
                       else alpha[i,i]:=-epsilon ;

    for i:=1 to nbPara do
      Vnorm[i,1]:=1/sqrt(abs(alpha[i,i]));

    for i:=1 to nbPara do
    begin
       for j:=1 to nbPara do
         alpha[i,j]:=alpha[i,j]*(Vnorm[i,1]*Vnorm[j,1]);
       alpha[i,i]:=1.0+Lambda;
       beta[i,1]:=beta[i,1]*Vnorm[i,1];
    end;

    itera:=0;
    finB:=false;
    repeat
      tablo.copy(alpha);
      with tablo do
      for j:=1 to rowCount do
        tablo[j,j]:=1.0+Lambda;

      tablo.solveChk(beta,BB);
      for i:=1 to nbPara do BB[i,1]:=BB[i,1]*Vnorm[i,1];

      controleVar(BB);
      BB.add(BB,para);

      getYfit(BB);                    { Calcul du chi carré pour BB }
      diff.sub(ydat,yfit);
      chisqr:=chi2(diff)/Nlib;

      
      if (ChiSqr<=Chisq1) then        { S'il est meilleur, on le garde }
        begin
          paraB.copy(para);
          para.copy(BB);

          first:=false;
          LambdaB:=Lambda;
          Lambda:=Lambda/Mlambda;
          if (ChiSq1-ChiSqr)*seuil>Chisq1
            then FinB:=true
            else fin:=true;

          chiSq1:=ChiSqr;
        end
      else                           { Sinon on le rejette }
        begin
          Lambda:=Lambda*Mlambda;
          inc(Itera);
        end;

      if testerFinPg then fin:=true;
    until (itera>IteraMax) or FinB or Fin;

    inc(cnt);
    if cnt>cntmax then fin:=true;

    if not (FinB or Fin) then
      begin
        if Befor or first then  fin:=true
        else
        begin
          para.copy(paraB);
          Lambda:=LambdaB*Mlambda;
          Befor:=True;
        end;
      end;
    {else lambda:=lambda0;}

  until Fin;       { Fin Boucle Principale }

  FINALLY
    Beta.free;
    BB.free;
    paraB.free;
    Alpha.free;
    tablo.free;
    diff.free;
    Vnorm.free;
  END;
end;





procedure ToptiFitTh0.getYfit(pp: Tmat);
var
  ydum:Tmat;
begin
  ydum:=Tmat.create(g_double,nbpt,1);

  IPPStest;

  TRY
  {Le résultat du filtre linéaire est donné par une convolution}
  ippsConv(xdat1.tbD,nbpt,pp.tbD,Nblin1,ylin1.tbD);

  yfit.extract(ylin1,1,nbpt,1,1);
  ippsThreshold_LT(yfit.tbD,nbpt,0);

  FINALLY
  IPPSend;
  ydum.Free;
  END;
end;

procedure ToptiFitTh0.getJacobian(pp: Tmat);
var
  i,j:integer;
begin
  Jmat.setSize(nbpt,nbpara);
  Jmat.clear;

  IPPStest;

  TRY
  { calculer le résultat du filtre linéaire ylin1 }
  ippsConv(xdat1.tbD,nbpt,pp.tbD,Nblin1,ylin1.tbD);

  { ensuite, on a dy/dhi(t) =xdat1[t-i]
    Il serait logique de considérer que la dérivée est nulle pour ylin1<0
    mais il se trouve que c'est moins efficace

    for i:=1 to Nblin1 do
    for j:=1 to nbpt-i+1 do
      if ylin1[i+j-1,1]>=0 then Jmat[i+j-1,i]:=xdat1[j,1];

    Donc, on préfère:
  }
  for i:=1 to Nblin1 do
    move(xdat1.Cell(1,1)^, Jmat.cell(i,i)^,(nbpt-i+1)*8 );
  FINALLY

  IPPSend;
  END;
end;

procedure ToptiFitTh0.InstallData(vecX,vecY,Vlin,Vnotlin: Tvector; NblinA1, NblNonLinA1: integer);
var
  i:integer;
begin
  Nblin1:=NblinA1;
  NbNonLin1:=NblNonLinA1;
  Nbpt:=vecX.ICount;
  Nbpara:=Nblin1+NbNonLin1;

  setlength(Vclamp,nbpara);
  fillchar(Vclamp[0],nbpara,0);

  xdat1.setSize(g_double,nbPt,1);        { copier vecX dans xdat1 }
  with vecX do
  for i:=Istart to Iend do
    xdat1[i-Istart+1,1]:=Yvalue[i];

  ydat.setSize(g_double,nbpt,1);        { copier vecY dans ydat }
  with vecY do
  for i:=Istart to Iend do
    ydat[i-Istart+1,1]:=Yvalue[i];

  yfit.setSize(g_double,nbpt,1);        { dimensionner yfit }
  ylin1.setSize(g_double,nbpt+Nblin1,1);  { dimensionner ylin1 }


  para.setSize(NbPara,1);               { dimensionner para }

  for i:=1 to Nblin1 do                  { copier Vlin dans para }
    para[i,1]:=Vlin[Vlin.Istart+i-1];

  if assigned(Vnotlin) then             { copier Vnotlin dans para }
  for i:=1 to NbNonLin1 do
    para[Nblin1+i,1]:=Vnotlin[Vnotlin.Istart+i-1];

end;

procedure ToptiFitTh0.InstallSegs(Vseg: Tvector;i0:integer); {transmettre i0=Istart des données}
var
  i:integer;
begin
  if not assigned(Vseg) then exit;

  setLength(IdatStart,Vseg.Icount div 2);
  setLength(IdatEnd,Vseg.Icount div 2);

  for i:=0 to Vseg.Icount div 2-1 do
  begin
    IdatStart[i]:=Vseg.Jvalue[Vseg.Istart+i*2]-i0+1;
    IdatEnd[i]:=Vseg.Jvalue[Vseg.Istart+i*2+1]-i0+1;
  end;
end;


procedure ToptiFitTh0.getData(vecFit,Vlin,Vnotlin:Tvector);
var
  i:integer;
begin
  vecFit.initTemp1(0,nbpt-1,vecFit.tpNum);
  with vecFit do
  for i:=Istart to Iend do
    Yvalue[i]:=yfit[i-Istart+1,1];

  for i:=1 to Nblin1 do
    Vlin[Vlin.Istart+i-1]:=para[i,1];

  if assigned(Vnotlin) then
  for i:=1 to NbNonLin1 do
    Vnotlin[Vnotlin.Istart+i-1]:=para[Nblin1+i,1];

end;


procedure ToptiFitTh0.checkLimits(dd:Tmat;n:integer;min,max:float);
begin
  if para[n,1]+dd[n,1]<min then dd[n,1]:=min-para[n,1];
  if para[n,1]+dd[n,1]>max then dd[n,1]:=max-para[n,1];
end;

procedure ToptiFitTh0.controleVar(dd: Tmat);
begin
end;

procedure ToptiFitTh0.Add(src: Tmat; w: float);
begin
  ippsAddC(w,src.tbD,nbpt);
end;

procedure ToptiFitTh0.Add(src1, src2: Tmat);
begin
  ippsAdd(src1.tbD,src2.tbD,nbpt);
end;

procedure ToptiFitTh0.Add(src1, src2, dest: Tmat);
begin
  ippsAdd(src1.tbD,src2.tbD,dest.tbD,nbpt);
end;



procedure ToptiFitTh0.Mul(src: Tmat; w: float);
begin
  ippsMulC(w,src.tbD,nbpt);
end;

procedure ToptiFitTh0.Mul(src1, src2: Tmat);
begin
  ippsMul(src1.tbD,src2.tbD,nbpt);
end;

procedure ToptiFitTh0.Mul(src1, src2, dest: Tmat);
begin
  ippsMul(src1.tbD,src2.tbD,dest.tbD,nbpt);
end;



procedure ToptiFitTh0.exp1(src: Tmat);
var
  i:integer;
begin
  for i:=1 to nbpt do src[i,1]:=exp(src[i,1]);
end;

procedure ToptiFitTh0.ln1(src: Tmat);
var
  i:integer;
begin
  Thresh1(src,1E-20,false);      { seuil +epsilon }
  for i:=1 to nbpt do src[i,1]:=ln(src[i,1]);
end;


procedure ToptiFitTh0.Thresh1(src: Tmat; w: float;up:boolean);
begin
  if up
    then ippsThreshold_GT(src.tbD,nbpt,w)
    else ippsThreshold_LT(src.tbD,nbpt,w);
end;

procedure ToptiFitTh0.AbsThresh(src:Tmat;w:float);
begin
  ippsAbs(src.tbD,nbpt);
  ippsThreshold_LT(src.tbD,nbpt,w);
end;

procedure ToptiFitTh0.vecToJmat(src:Tmat;num:integer);
begin
  move(src.tb^,Jmat.cell(1,num)^,nbpt*8);
end;

{****************************** ToptiFitTh1 ******************************************************}

procedure ToptiFitTh1.getYfit(pp: Tmat);
var
  ydum:Tmat;
begin
  ydum:=Tmat.create(g_double,nbpt,1);

  IPPStest;

  TRY
  {Le résultat du filtre linéaire est donné par une convolution}
  ippsConv(xdat1.tbD,nbpt,pp.tbD,Nblin1,ylin1.tbD);

  yfit.extract(ylin1,1,nbpt,1,1);
  ippsThreshold_LT(yfit.tbD,nbpt,pp[Nblin1+1,1]);

  FINALLY
  IPPSend;
  ydum.Free;
  END;
end;

procedure ToptiFitTh1.getJacobian(pp: Tmat);
var
  i,j:integer;
  th:double;
begin
  Jmat.setSize(nbpt,nbpara);
  Jmat.clear;

  IPPStest;

  TRY
  { calculer le résultat du filtre linéaire ylin1 }
  ippsConv(xdat1.tbD,nbpt,pp.tbD,Nblin1,ylin1.tbD);

  { ensuite, on a dy/dhi(t) =xdat1[t-i]
    Il serait logique de considérer que la dérivée est nulle pour ylin1<0
    mais il se trouve que c'est moins efficace

    for i:=1 to Nblin1 do
    for j:=1 to nbpt-i+1 do
      if ylin1[i+j-1,1]>=0 then Jmat[i+j-1,i]:=xdat1[j,1];

    Donc, on préfère:
  }
  for i:=1 to Nblin1 do
    move(xdat1.Cell(1,1)^, Jmat.cell(i,i)^,(nbpt-i+1)*8 );

  th:=pp[Nblin1+1,1];

  for i:=1 to Jmat.rowCount do
  if ylin1[i,1]>th
    then Jmat[i,Nblin1+1]:=0
    else Jmat[i,Nblin1+1]:=1;

  FINALLY

  IPPSend;
  END;
end;




{***************************************** ToptiFitPoly1 *****************************************}

procedure ToptiFitPoly1.getYfit(pp: Tmat);
var
  i,j:integer;
  w,w1:double;
  ydum,yp:Tmat;
begin
  ydum:=Tmat.create(g_double,nbpt,1);
  yp:=Tmat.create(g_double,nbpt,1);

  IPPStest;

  TRY
        {Le résultat du filtre linéaire est donné par une convolution}
  ippsConv(xdat1.tbD,nbpt,pp.tbD,Nblin1,ylin1.tbD);

        {On applique ensuite le polynome du filtre non-linéaire sur le résultat}

  yfit.extract(ylin1,1,nbpt,1,1); { ranger ylin1 dans yfit   (Attention: ylin1 est plus grand que yfit)  }
  yp.copy(yfit);                 { ranger ylin1 dans yp }

  for i:=1 to NbNonLin1 do        { le premier coeff est c2 }
  begin
    ippsMul(ylin1.tbD,yp.tbD,nbpt);               { yp = yp*ylin1}
    Ydum.copy(yp);                                { ydum = yp}
    ippsMulC(pp[Nblin1+i,1],ydum.tbD,nbpt);       { ydum = yp*c[i]}
    ippsMul(ydum.tbD,yfit.tbD,nbpt);              { yfit = yfit + ydum }
  end;



  FINALLY
  IPPSend;
  ydum.Free;
  yp.free;
  END;
end;


procedure ToptiFitPoly1.getJacobian(pp: Tmat);
var
  i,j:integer;
  w:double;
  ydum,yprim:Tmat;
begin
  Jmat.setSize(nbpt,nbpara);
  Jmat.clear;

  ydum:=Tmat.create(g_double,nbpt,1);
  yprim:=Tmat.create(g_double,nbpt,1);

  IPPStest;

  TRY
  {calculer le résultat du filtre linéaire ylin1 }
  ippsConv(xdat1.tbD,nbpt,pp.tbD,Nblin1,ylin1.tbD);


  {calculer les vecteurs non-lin égaux à ylin1 à la puissance q }

  move(ylin1.tb^,Jmat.cell(1,Nblin1+1)^,nbpt*8);  { ylin1 dans colonne 1 non lin }
  ippsMul(ylin1.tbD,Pdouble(Jmat.cell(1,Nblin1+1)),nbpt); { col1 = (ylin1)² }

  for i:=2 to NbNonLin1 do                       { puis les autres colonnes }
    ippsMul(Pdouble(Jmat.cell(1,Nblin1+i-1)), ylin1.tbD, Pdouble(Jmat.cell(1,Nblin1+i)),nbpt);


  { Calculer yprim = dérivee du polynome nonlin par rapport à yfit }

  yprim.copy(ylin1);
  ippsMulC(2*pp[Nblin1+1,1],yprim.tbD,nbpt);         { yprim = 2*c2*yprim }
  ippsAddC(1,yprim.tbD,nbpt);                        { yprim = 1 + 2*c2*ylin1 }

  for i:=2 to NbNonLin1 do
  begin
    move(Jmat.cell(1,Nblin1+i-1)^,ydum.tb^,nbpt*8);  { ydum = ylin1 exposant (i) }
    ippsMulC(pp[Nblin1+i,1],ydum.tbD,nbpt);          { ydum = ydum*c[i]}
    ippsMulC(i+1,ydum.tbD,nbpt);                     { ydum = ydum*(i+1)}
    ippsAdd(ydum.tbD,yprim.tbD,nbpt);                 { yprim = yprim + ydum }
  end;

  { Calcul de la colonne Lin = yprim(t)*xdat1(t-i)  }
  for i:=1 to Nblin1 do
    ippsMul(Pdouble(yprim.cell(i,1)),Pdouble(xdat1.Cell(1,1)),Pdouble(Jmat.cell(i,i)),nbpt-i+1 );

  (*
  for i:=1 to Nblin1 do
  for j:=i to nbpt do
    Jmat[j,i]:=(1+2*pp[Nblin1+1,1]*ylin1[j,1])*xdat1[j-i+1,1];

  for j:=1 to nbpt do
    Jmat[j,Nblin1+1]:=sqr(ylin1[j,1]);
  *)

  FINALLY

  ydum.Free;
  yprim.free;
  IPPSend;
  END;
end;



{******************************** ToptiFitPower1 ***********************************************}

procedure ToptiFitPower1.getYfit(pp: Tmat);
var
  i,j:integer;
  w,w1:double;
begin
  IPPStest;
  try
  TRY
        {Le résultat du filtre linéaire est donné par une convolution}
  ippsConv(xdat1.tbD,nbpt,pp.tbD,Nblin1,ylin1.tbD);

        {On applique ensuite le polynome du filtre non-linéaire sur le résultat}

  yfit.extract(ylin1,1,nbpt,1,1); { ranger ylin1 dans yfit   (Attention: ylin1 est plus grand que yfit)  }

  ippsThreshold_LT(yfit.tbD,nbpt,1E-20);        { seuil +epsilon }
  ippsLn(yfit.tbD,nbpt);                        { yfit = Log(yfit) }
  ippsMulC(pp[Nblin1+1,1],yfit.tbD,nbpt);       { yfit = cp * Log(yfit) }

  ippsThreshold_GT(yfit.tbD,nbpt,100);       { seuil +inf }
  ippsThreshold_LT(yfit.tbD,nbpt,-100);      { seuil -inf }

  ippsMulC(1,yfit.tbD,nbpt);

  for i:=1 to yfit.rowCount do yfit[i,1]:=exp(yfit[i,1]);

  {nspdbexp2(yfit.tb,yfit.tb,nbpt);}             { yfit=exp( cp*Log(yfit) ) }


  FINALLY
  IPPSend;
  END;
  except
    yfit.EditModal;
    {messageCentral('Except');}
  end;
end;


procedure ToptiFitPower1.getJacobian(pp: Tmat);
var
  i,j:integer;
  w:double;
  ydum,yprim:Tmat;
  cp:double;
begin
  Jmat.setSize(nbpt,nbpara);
  Jmat.clear;


  ydum:=Tmat.create(g_double,nbpt,1);
  yprim:=Tmat.create(g_double,nbpt,1);

  IPPStest;

  TRY
  {calculer le résultat du filtre linéaire ylin1 }
  ippsConv(xdat1.tbD,nbpt,pp.tbD,Nblin1,ylin1.tbD);

(*
   {Essai }

  cp:=para[Nblin1+1,1];
  for j:=1 to Nblin1 do
  for i:=1 to nbpt do
    if (i>=j) then
      if (ylin1[i,1]>1E-100)
        then Jmat[i,j]:=cp*exp(cp*ln(ylin1[i,1]))*xdat1[i-j+1,1]
        else Jmat[i,j]:=xdat1[i-j+1,1]*0.1;

  for i:=1 to nbpt do
    if (ylin1[i,1]>1E-100)
      then Jmat[i,Nblin1+1]:=ln(ylin1[i,1])*exp(cp*ln(ylin1[i,1]));

  {nspdbMpy1(1/(nbpt*1000) ,Jmat.cell(1,Nblin1+1),nbpt);}

  {fin essai}
*)

  {calculer le vecteur non-lin  }

  yprim.extract(ylin1,1,nbpt,1,1);                { ranger ylin1 dans yprim }
  ippsThreshold_LT(yprim.tbD,nbpt,1E-20);         { seuil +epsilon }
  ippsLn(yprim.tbD,nbpt);                         { yprim = Log(ylin1) }

  ydum.copy(yprim);
  ippsMulC(pp[Nblin1+1,1],ydum.tbD,nbpt);          { ydum = cp * Log(ylin1) }


  {nspdbexp1(ydum.tb,nbpt);  }                    { ydum=exp( cp*Log(ylin1) ) }
  for i:=1 to ydum.rowCount do ydum[i,1]:=exp(ydum[i,1]);

  ippsMul(yprim.tbD,ydum.tbD,nbpt);               { ydum:=Log(ylin1)*exp( cp*Log(ylin1) ) }

  move(ydum.tb^,Jmat.cell(1,Nblin1+1)^,nbpt*8);    { ydum dans colonne 1 non lin }


  { Calculer yprim = dérivee du polynome nonlin par rapport à yfit }
                                                    { yprim contient Log(ylin1) }
  ippsMulC(pp[Nblin1+1,1]-1 ,yprim.tbD,nbpt);       { yprim = (cp-1) * Log(ylin1) }
  {nspdbexp1(yprim.tb,nbpt);  }                     { yprim= exp( (cp-1)*Log(ylin1) ) }
  for i:=1 to yprim.rowCount do yprim[i,1]:=exp(yprim[i,1]);
  ippsMulC(pp[Nblin1+1,1] ,yprim.tbD,nbpt);         { yprim =cp * exp( (cp-1)*Log(ylin1) ) }


  { Calcul de la colonne Lin = yprim(t)*xdat1(t-i) }
  for i:=1 to Nblin1 do
    ippsMul(Pdouble(yprim.cell(i,1)),Pdouble(xdat1.Cell(1,1)),Pdouble(Jmat.cell(i,i)),nbpt-i+1 );


  FINALLY

  ydum.Free;
  yprim.free;
  IPPSend;
  END;

  {Jmat.editModal;}
end;

procedure ToptiFitPower1.controleVar(dd: Tmat);
begin
  {dd[Nblin1+1,1]:=dd[Nblin1+1,1]/1;}

  if para[Nblin1+1,1]+dd[Nblin1+1,1]<0.1 then dd[Nblin1+1,1]:=0.1-para[Nblin1+1,1];
  if para[Nblin1+1,1]+dd[Nblin1+1,1]>5 then dd[Nblin1+1,1]:=5-para[Nblin1+1,1];

end;


{*********************************** ToptifitPower2 ***************************************** }

constructor ToptiFitPower2.create;
begin
  inherited create;
  xdat2:=Tmat.create(g_double,1,1);
  ylin2:=Tmat.create(g_double,1,1);
end;

destructor ToptiFitPower2.destroy;
begin
  xdat2.free;
  ylin2.free;
  inherited;
end;


procedure ToptiFitPower2.getYfit(pp: Tmat);
var
  i,j:integer;
  w,w1:double;
  g0,Cte:double;
begin
  IPPStest;
  try
  TRY
        {Les résultats des filtres linéaires sont donnés par des convolutions }
  ippsConv(xdat1.tbD,nbpt,pp.tbD,Nblin1,ylin1.tbD);
  ippsConv(xdat2.tbD,nbpt,Pdouble(pp.cell(Nblin1+1,1)),Nblin2,ylin2.tbD);

  ippsAdd(ylin1.tbD,ylin2.tbD,yfit.tbD,nbpt); { ranger la somme  ylin1+ylin2 dans yfit }
        {On applique ensuite le polynome du filtre non-linéaire sur le résultat}


  ippsThreshold_LT(yfit.tbD,nbpt,1E-20);       { seuil +epsilon }
  ippsLn(yfit.tbD,nbpt);                        { yfit = Log(yfit) }
  ippsMulC(pp[Nblin1+nblin2+1,1],yfit.tbD,nbpt);{ yfit = cp * Log(yfit) }

  ippsThreshold_GT(yfit.tbD,nbpt,100);          { seuil +inf }
  ippsThreshold_LT(yfit.tbD,nbpt,-100);         { seuil -inf }

  ippsMulC(1,yfit.tbD,nbpt);

  g0:=para[Nblin1+nblin2+2,1];
  Cte:=para[Nblin1+nblin2+3,1];

  for i:=1 to yfit.rowCount do yfit[i,1]:=g0*exp(yfit[i,1])+cte;

  {nspdbexp2(yfit.tb,yfit.tb,nbpt);}             { yfit=exp( cp*Log(yfit) ) }


  FINALLY
  IPPSend;
  END;
  except
    yfit.EditModal;
    {messageCentral('Except');}
  end;
end;


procedure ToptiFitPower2.getJacobian(pp: Tmat);
var
  i,j:integer;
  w:double;
  ydum,yprim:Tmat;
  cp,g0,Cte:double;
begin
  Jmat.setSize(nbpt,nbpara);
  Jmat.clear;


  ydum:=Tmat.create(g_double,nbpt,1);
  yprim:=Tmat.create(g_double,nbpt,1);

  IPPStest;

  TRY
        {Calculer les résultats des filtres linéaires  }
  ippsConv(xdat1.tbD,nbpt,pp.tbD,Nblin1,ylin1.tbD);
  ippsConv(xdat2.tbD,nbpt,Pdouble(pp.cell(Nblin1+1,1)),Nblin2,ylin2.tbD);

  ippsAdd(ylin1.tbD,ylin2.tbD,yprim.tbD,nbpt);             { ranger la somme  ylin1+ylin2 dans yprim }


  {calculer le vecteur non-lin  }

  ippsThreshold_LT(yprim.tbD,nbpt,1E-20);                  { seuil +epsilon }
  ippsLn(yprim.tbD,nbpt);                                  { yprim = Log(ylin1) }

  ydum.copy(yprim);
  ippsMulC(pp[Nblin1+nblin2+1,1],ydum.tbD,nbpt);           { ydum = cp * Log(ylin1) }


  {nspdbexp1(ydum.tb,nbpt);  }                             { ydum=exp( cp*Log(ylin1) ) }
  for i:=1 to ydum.rowCount do ydum[i,1]:=exp(ydum[i,1]);
  move(ydum.tb^,Jmat.cell(1,Nblin1+nblin2+2)^,nbpt*8);     { ydum dans colonne 2 non lin }

  ippsMul(yprim.tbD,ydum.tbD,nbpt);                        { ydum:=Log(ylin1)*exp( cp*Log(ylin1) ) }

  g0:=pp[Nblin1+nblin2+2,1];
  Cte:=pp[Nblin1+nblin2+3,1];

  ippsMulC(g0,ydum.tbD,nbpt);                              { ydum:=g0*Log(ylin1)*exp( cp*Log(ylin1) ) }
  move(ydum.tb^,Jmat.cell(1,Nblin1+nblin2+1)^,nbpt*8);     { ydum dans colonne 1 non lin }


  { Calculer yprim = dérivee du polynome nonlin par rapport à yfit }
                                                          { yprim contient Log(ylin1) }
  ippsMulC(pp[Nblin1+nblin2+1,1]-1 ,yprim.tbD,nbpt);      { yprim = (cp-1) * Log(ylin1) }
  {nspdbexp1(yprim.tb,nbpt);  }                           { yprim= exp( (cp-1)*Log(ylin1) ) +Cte }
  for i:=1 to yprim.rowCount do yprim[i,1]:=g0*exp(yprim[i,1]);
  ippsMulC(pp[Nblin1+nblin2+1,1] ,yprim.tbD,nbpt);        { yprim =cp * exp( (cp-1)*Log(ylin1) ) }


  { Calcul de la colonne Lin = yprim(t)*xdat1(t-i)  }
  for i:=1 to Nblin1 do
    ippsMul(Pdouble(yprim.cell(i,1)),Pdouble(xdat1.Cell(1,1)),Pdouble(Jmat.cell(i,i)),nbpt-i+1 );

  for i:=1 to nbLin2 do
    ippsMul(Pdouble(yprim.cell(i,1)),Pdouble(xdat2.Cell(1,1)),Pdouble(Jmat.cell(i,Nblin1+i)),nbpt-i+1 );

  ippsSet(1, Pdouble(Jmat.cell(1,Nblin1+nblin2+3)),nbpt);

  FINALLY

  ydum.Free;
  yprim.free;
  IPPSend;
  END;

  {Jmat.editModal;}
end;

procedure ToptiFitPower2.controleVar(dd: Tmat);
begin
  {dd[Nblin1+1,1]:=dd[Nblin1+1,1]/1;}

  if para[Nblin1+nblin2+1,1]+dd[Nblin1+nblin2+1,1]<0.1 then dd[Nblin1+nblin2+1,1]:=0.1-para[Nblin1+nblin2+1,1];
  if para[Nblin1+nblin2+1,1]+dd[Nblin1+nblin2+1,1]>5 then dd[Nblin1+nblin2+1,1]:=5-para[Nblin1+nblin2+1,1];
end;


procedure ToptiFitPower2.InstallData(vecX1, vecX2, vecY, Vlin1,Vlin2: Tvector; Nbl1, Nbl2: integer; Cp,g0,Cte: float);
var
  i:integer;
begin
  Nblin1:=Nbl1;
  Nblin2:=Nbl2;
  NbNonLin1:=3;
  Nbpt:=vecX1.ICount;
  Nbpara:=Nblin1+nblin2+NbNonLin1;

  setlength(Vclamp,nbpara);
  fillchar(Vclamp[0],nbpara,0);

  xdat1.setSize(g_double,nbPt,1);        { copier vecX1 dans xdat1 }
  with vecX1 do
  for i:=Istart to Iend do
    xdat1[i-Istart+1,1]:=Yvalue[i];

  xdat2.setSize(g_double,nbPt,1);       { copier vecX2 dans xdat1 }
  with vecX2 do
  for i:=Istart to Iend do
    xdat2[i-Istart+1,1]:=Yvalue[i];

  ydat.setSize(g_double,nbpt,1);        { copier vecY dans ydat }
  with vecY do
  for i:=Istart to Iend do
    ydat[i-Istart+1,1]:=Yvalue[i];

  yfit.setSize(g_double,nbpt,1);        { dimensionner yfit }

  ylin1.setSize(g_double,nbpt+Nblin1,1);  { dimensionner ylin1 }
  ylin2.setSize(g_double,nbpt+nblin2,1); { dimensionner ylin2 }

  para.setSize(NbPara,1);               { dimensionner para }

  for i:=1 to Nblin1 do                  { copier Vlin dans para }
    para[i,1]:=Vlin1[Vlin1.Istart+i-1];

  for i:=1 to nblin2 do                 { copier Vlin2 dans para }
    para[Nblin1+i,1]:=Vlin2[Vlin2.Istart+i-1];


  para[Nblin1+nblin2+1,1]:=Cp;           { copier Cp dans para }
  para[Nblin1+nblin2+2,1]:=g0;           { copier g0 dans para }
  para[Nblin1+nblin2+3,1]:=Cte;          { copier Cte dans para }
end;



procedure ToptiFitPower2.getData(vecFit, Vlin1, Vlin2: Tvector; var Cp,g0,Cte: float);
var
  i:integer;
begin
  vecFit.initTemp1(0,nbpt-1,vecFit.tpNum);

  with vecFit do
  for i:=Istart to Iend do
    Yvalue[i]:=yfit[i-Istart+1,1];

  for i:=1 to Nblin1 do
    Vlin1[Vlin1.Istart+i-1]:=para[i,1];

  for i:=1 to nblin2 do
    Vlin2[Vlin2.Istart+i-1]:=para[Nblin1+i,1];

  Cp:=para[Nblin1+nblin2+1,1];
  g0:=para[Nblin1+nblin2+2,1];
  Cte:=para[Nblin1+nblin2+3,1];
end;



{*********************************** Procédures STM *****************************************}




procedure proOptiTh0(var VInput,VOutPut,Vlin,VecE: Tvector;NblinA1: integer;var chi2:float;nbIt:integer);
var
  opti:ToptiFitTh0;
begin
  verifierVecteur(VInput);
  verifierVecteur(VOutput);
  verifierVecteur(Vlin);
  verifierVecteur(vecE);

  if VInput.Icount<>VOutPut.Icount
    then sortieErreur('Opti : Vinput and Voutput must have the same size');

  opti:=ToptifitTh0.create;
  TRY
    if nbIt>0 then opti.cntmax:=nbIt;
    opti.InstallData(VInput,VoutPut,Vlin,nil,NblinA1, 0);
    opti.execute;
    opti.getData(vecE,Vlin,nil);
    chi2:=opti.chiSq1;
  FINALLY
    opti.free;
  END;
end;

procedure proOptiTh1(var VInput,VOutPut,Vlin,VecE: Tvector;NblinA1: integer;var th,chi2:float;nbIt:integer);
var
  opti:ToptiFitTh1;
  Vnonlin:Tvector;
begin
  verifierVecteur(VInput);
  verifierVecteur(VOutput);
  verifierVecteur(Vlin);
  verifierVecteur(vecE);

  if VInput.Icount<>VOutPut.Icount
    then sortieErreur('Opti : Vinput and Voutput must have the same size');


  Vnonlin:=Tvector.Create;
  Vnonlin.initTemp1(0,0,g_double);
  Vnonlin[0]:=th;
  opti:=ToptifitTh1.create;
  TRY
    if nbIt>0 then opti.cntmax:=nbIt;
    opti.InstallData(VInput,VoutPut,Vlin,Vnonlin,NblinA1, 1);
    opti.execute;
    opti.getData(vecE,Vlin,Vnonlin);
    chi2:=opti.chiSq1;
    th:=Vnonlin[0];
  FINALLY
    opti.free;
    Vnonlin.free;
  END;
end;

procedure proOptiPoly(var VInput,VOutPut,Vlin,Vnotlin,VecE: Tvector;NblinA1,nbNotlin1: integer;
                     var chi2:float;nbIt:integer);
var
  opti:ToptiFitPoly1;
begin
  verifierVecteur(VInput);
  verifierVecteur(VOutput);
  verifierVecteur(Vlin);
  verifierVecteur(Vnotlin);
  verifierVecteur(vecE);

  if VInput.Icount<>VOutPut.Icount
    then sortieErreur('Opti : Vinput and Voutput must have the same size');


  opti:=ToptifitPoly1.create;
  TRY
    if nbIt>0 then opti.cntmax:=nbIt;
    opti.InstallData(VInput,VoutPut,Vlin,Vnotlin,NblinA1,nbNotLin1);
    opti.execute;
    opti.getData(vecE,Vlin,Vnotlin);
    chi2:=opti.chiSq1;
  FINALLY
    opti.free;
  END;
end;

procedure proOptiPower1(var VInput,VOutPut,Vlin,VecE: Tvector;NblinA1: integer;var Cp,chi2:float;nbIt:integer;clamp:integer);
var
  opti:ToptiFitPower1;
  Vnonlin:Tvector;
  i:integer;
begin
  verifierVecteur(VInput);
  verifierVecteur(VOutput);
  verifierVecteur(Vlin);
  verifierVecteur(vecE);

  if VInput.Icount<>VOutPut.Icount
    then sortieErreur('Opti : Vinput and Voutput must have the same size');


  Vnonlin:=Tvector.Create;
  Vnonlin.initTemp1(0,0,g_double);
  Vnonlin[0]:=Cp;
  opti:=ToptifitPower1.create;
  TRY
    if nbIt>0 then opti.cntmax:=nbIt;
    opti.InstallData(VInput,VoutPut,Vlin,Vnonlin,NblinA1, 1);

    case clamp of
      1: for i:=1 to NblinA1 do opti.Vclamp[i-1]:=true;
      2: opti.Vclamp[NblinA1]:=true;
    end;

    opti.execute;
    opti.getData(vecE,Vlin,Vnonlin);
    chi2:=opti.chiSq1;
    Cp:=Vnonlin[0];
  FINALLY
    opti.free;
    Vnonlin.free;
  END;
end;

procedure proOptiPower2(var VInput1,Vinput2,VOutPut,Vseg,Vlin1,Vlin2,VecE: Tvector;
                       NblinA1,NblinA2: integer;var Cp,g0,Cte,chi2:float;nbIt,clamp:integer);
var
  opti:ToptiFitPower2;
  i:integer;
begin
  verifierVecteur(VInput1);
  verifierVecteur(VInput2);
  verifierVecteur(VOutput);
  verifierVecteur(Vlin1);
  verifierVecteur(Vlin2);
  verifierVecteur(vecE);


  if (VInput1.Icount<>VOutPut.Icount) or (VInput2.Icount<>VOutPut.Icount)
    then sortieErreur('Opti : Vinput and Voutput must have the same size');

  if assigned(Vseg) then
  with Vseg do
  begin
    if Icount mod 2<>0 then sortieErreur('Opti : Vseg.Icount is not even');
    for i:=Istart to Iend do
    begin
      if (Jvalue[i]<Vinput1.Istart) or (Vinput1.Jvalue[i]>Iend)
        then sortieErreur('Opti : invalid values in Vseg ');
    end;
  end;

  opti:=ToptifitPower2.create;
  TRY
    if nbIt>0 then opti.cntmax:=nbIt;
    opti.InstallData(VInput1,Vinput2,VoutPut,Vlin1,Vlin2,NblinA1,NblinA2,Cp,g0,Cte);

    if clamp and 1=1 then
      for i:=1 to NblinA1 do opti.Vclamp[i-1]:=true;
    if clamp and 2=2 then
      for i:=1 to nblinA2 do opti.Vclamp[NblinA1+i-1]:=true;
    if clamp and 4=4 then opti.Vclamp[NblinA1+nblinA2]:=true;
    if clamp and 8=8 then opti.Vclamp[NblinA1+nblinA2+1]:=true;
    if clamp and 16=16 then opti.Vclamp[NblinA1+nblinA2+2]:=true;

    opti.installSegs(Vseg,Vinput1.Istart);

    opti.execute;
    opti.getData(vecE,Vlin1,Vlin2,Cp,g0,Cte);
    chi2:=opti.chiSq1;
  FINALLY
    opti.free;
  END;
end;






end.
