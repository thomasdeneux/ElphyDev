unit optifit3;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Dgraphic,
     IPPS17,IPPdefs17, IPP17ex,
     Ncdef2,stmPg,
     stmDef,stmObj,stmvec1,stmMat1,mathKernel0,stmKLmat,
     optiFit1;

type
  ToptiFitModel2=class(ToptifitTh0)
             PH1,PH2,PH3,PH4: Pointer;
             Cp,g0,Cte:float;
             C1,g1: float;

             {xdat1 : Tmat }
             xdat2:Tmat;
             {ylin1 : Tmat }
             ylin2:Tmat;
             ylin3,ylin4: Tmat;

             yinter,yinter1,yinter1abs:Tmat;
             ydum,ydum1:Tmat;

             Vg0,Vg01:Tmat;
             Vg1,Vg11:Tmat;

             constructor create;
             destructor destroy;override;

             procedure getYfit(pp:Tmat);override;
             procedure getJacobian(pp:Tmat);override;
             procedure controleVar(dd:Tmat);override;

             procedure InstallData(vecX1,vecX2,vecY,Vlin1,Vlin2,Vlin3,Vlin4,Vnonlin:Tvector;
                                   NbL:integer);
             procedure getData(vecFit,Vlin1,Vlin2,Vlin3,Vlin4,Vnonlin:Tvector);

             procedure NonlinFilter1(src,dest:Tmat;gg,cc,ct:float);
             procedure NonlinFilter2(src,dest:Tmat;gg,cc:float);
             procedure CalculDLin0(src1,src2:Tmat;nb,colJmat:integer);
             procedure CalculDlin1;

           end;

procedure proOptiModel2(var VInput1,Vinput2,VOutPut,Vseg,Vlin1,Vlin2,Vlin3,Vlin4,VnonLin,vecE,Vclamp: Tvector;
                       NblinA1:integer;var chi2:float;nbIt:integer);pascal;


implementation


{********************************  ToptiFitModel2  ****************************}




constructor ToptiFitModel2.create;
var
  i:integer;
begin
  inherited create;
  xdat2:=Tmat.create(g_double,1,1);

  ylin2:=Tmat.create(g_double,1,1);
  ylin3:=Tmat.create(g_double,1,1);
  ylin4:=Tmat.create(g_double,1,1);

  yinter:=Tmat.create(g_double,1,1);
  yinter1:=Tmat.create(g_double,1,1);
  yinter1abs:=Tmat.create(g_double,1,1);
  ydum:=Tmat.create(g_double,1,1);
  ydum1:=Tmat.create(g_double,1,1);
  Vg0:=Tmat.create(g_double,1,1);
  Vg01:=Tmat.create(g_double,1,1);
  Vg1:=Tmat.create(g_double,1,1);
  Vg11:=Tmat.create(g_double,1,1);

end;

destructor ToptiFitModel2.destroy;
var
  i:integer;
begin
  xdat2.free;

  ylin2.free;
  ylin3.free;
  ylin4.free;

  yinter.free;
  yinter1.free;
  yinter1abs.free;
  ydum.free;
  ydum1.free;
  Vg0.free;
  Vg01.free;
  Vg1.free;
  Vg11.free;

  inherited;
end;


procedure ToptiFitModel2.controleVar(dd: Tmat);
var
  n,i:integer;
begin
  n:=4*Nblin1;

  checkLimits(dd,n+1,0,100000);
  checkLimits(dd,n+2,0.1,5);

  checkLimits(dd,n+4,0,10000);
  checkLimits(dd,n+5,0.1,5);
end;


procedure ToptiFitModel2.getYfit(pp: Tmat);
var
  i,j:integer;
  w,w1:double;
begin
  PH1:=pp.cell(1,1);
  PH2:=pp.cell(nblin1+1,1);
  PH3:=pp.cell(2*nblin1+1,1);
  PH4:=pp.cell(3*nblin1+1,1);

  g0:= pp[4*Nblin1+1,1];
  Cp:= pp[4*Nblin1+2,1];
  Cte:=pp[4*Nblin1+3,1];

  g1:= pp[4*Nblin1+4,1];
  C1:= pp[4*Nblin1+5,1];

  IPPStest;
  try
  TRY
  conv64f(xdat1.tbD,nbpt,Pdouble(pH1),Nblin1,ylin1.tbD);
  conv64f(xdat2.tbD,nbpt,Pdouble(pH2),Nblin1, ylin2.tbD);

  conv64f(xdat1.tbD,nbpt,Pdouble(pH3),Nblin1, ylin3.tbD);
  conv64f(xdat2.tbD,nbpt,Pdouble(pH4),Nblin1, ylin4.tbD);

  Add(ylin3,ylin4,yinter1);
  yinter1abs.copy(yinter1);
  absThresh(yinter1abs,1E-20);

  Add(ylin1,ylin2,yinter);                { ranger la somme  ylin1+ylin2 dans yinter }

  NonLinFilter2(yinter1abs,yinter,g1,c1); { retrancher ylin3 passé dans la non linéarité f2 }

  NonlinFilter1(yinter,yfit,g0,cp,cte);   { Non linéarité finale }

  FINALLY
  IPPSend;
  END;
  except
    yfit.EditModal;
    {messageCentral('Except');}
  end;
end;

procedure ToptiFitModel2.CalculDLin0(src1,src2:Tmat;nb,colJmat:integer);
var
  i:integer;
begin
  { Calcul de la colonne Lin = src1(t)*src21(t-i)  }
   for i:=1 to nb do
    ippsMul_64f(Pdouble(src1.cell(i,1)),Pdouble(src2.Cell(1,1)),Pdouble(Jmat.cell(i,colJmat+i-1)),nbpt-i+1 );
end;

procedure ToptiFitModel2.CalculDlin1;
var
  i,j:integer;
begin
  mul(Vg0,Vg1,ydum);
  mul(ydum,-1);                   {-Vg0 * Vg1 }

  for i:=1 to nblin1 do
  begin
    ydum1.fill(0);

    ippsMul_64f(Pdouble(ydum.cell(i,1)),Pdouble(xdat1.Cell(1,1)),Pdouble(ydum1.cell(i,1)),nbpt-i+1 );
    vecToJmat(ydum1,2*nblin1+i);

    ydum1.fill(0);
    ippsMul_64f(Pdouble(ydum.cell(i,1)),Pdouble(xdat2.Cell(1,1)),Pdouble(ydum1.cell(i,1)),nbpt-i+1 );
    vecToJmat(ydum1,3*nblin1+i);
  end;
end;

procedure ToptiFitModel2.getJacobian(pp: Tmat);
var
  i,j:integer;
  w:double;
begin
  Jmat.setSize(nbpt,nbpara);
  Jmat.clear;

  IPPStest;

  TRY

  getYfit(pp);

  NonlinFilter1(yinter,Vg0,g0*Cp,Cp-1,0);              {calcul Vg0}
  NonlinFilter1(yinter,Vg01,g0,Cp,0);                  {calcul Vg01}
  ydum.copy(yinter);
  ln1(ydum);
  mul(ydum,Vg01);

  NonlinFilter1(yinter1abs,Vg1,g1*C1,C1-1,0);             {calcul Vg1}
  with Vg1 do
  for j:=1 to RowCount do
    if yinter1[j,1]<0 then Zvalue[j,1]:=-Zvalue[j,1];

  NonlinFilter1(yinter1abs,Vg11,g1,C1,0);                 {calcul Vg11}
  ydum.copy(yinter1abs);
  ln1(ydum);
  mul(ydum,Vg11);

  calculDLin0(Vg0,xdat1,nblin1,1);
  calculDLin0(Vg0,xdat2,nblin1,nblin1+1);

  calculDLin1;

  NonlinFilter1(yinter,ydum,1,Cp,0);
  VecToJmat(ydum,4*nblin1+1);

  VecToJmat(Vg01,4*nblin1+2);

  ippsSet_64f(1, Pdouble(Jmat.cell(1,4*Nblin1+3)),nbpt);

  NonlinFilter1(yinter1abs,ydum,-1,C1,0);
  mul(Vg0,ydum);
  VecToJmat(ydum,4*nblin1+4);

  mul(Vg11,Vg0,ydum);
  mul(ydum,-1);
  VecToJmat(ydum,4*nblin1+5);

  FINALLY

  IPPSend;
  END;

  {Jmat.editModal;}
end;

procedure ToptiFitModel2.InstallData(vecX1, vecX2, vecY, Vlin1,Vlin2,Vlin3,Vlin4,Vnonlin: Tvector;
                 NbL: integer);
var
  i:integer;
begin
  Nblin1:=NbL;
  NbNonLin1:=5;
  Nbpt:=vecX1.ICount;
  Nbpara:=4*Nblin1+NbNonLin1;

  setlength(Vclamp,nbpara);
  fillchar(Vclamp[0],nbpara,0);

  xdat1.setSize(g_double,nbPt,1);
  xdat2.setSize(g_double,nbPt,1);

  with vecX1 do
  for i:=Istart to Iend do
  begin
    xdat1[i-Istart+1,1]:=Yvalue[i];     { copier vecX1 dans xdat1 }
  end;

  with vecX2 do
  for i:=Istart to Iend do
    xdat2[i-Istart+1,1]:=Yvalue[i];     { copier vecX2 dans xdat2 }


  ydat.setSize(g_double,nbpt,1);        { copier vecY dans ydat }
  with vecY do
  for i:=Istart to Iend do
    ydat[i-Istart+1,1]:=Yvalue[i];


  ylin1.setSize(g_double,nbpt+Nblin1,1); { dimensionner ylin1 }
  ylin2.setSize(g_double,nbpt+nblin1,1); { dimensionner ylin2 }
  ylin3.setSize(g_double,nbpt+nblin1,1); { dimensionner ylin3 }
  ylin4.setSize(g_double,nbpt+nblin1,1); { dimensionner ylin4 }

  yinter.setSize(g_double,nbpt,1);       { dimensionner yinter }
  yinter1.setSize(g_double,nbpt,1);      { dimensionner yinter1 }
  yinter1abs.setSize(g_double,nbpt,1);   { dimensionner yinter1abs }



  ydum.setSize(g_double,nbpt,1);        { dimensionner ydum }
  ydum1.setSize(g_double,nbpt,1);       { dimensionner ydum }
  yfit.setSize(g_double,nbpt,1);        { dimensionner yfit }

  vg0.setSize(g_double,nbpt,1);         { dimensionner vg0 }
  vg01.setSize(g_double,nbpt,1);        { dimensionner vg0 }
  vg1.setSize(g_double,nbpt,1);         { dimensionner vg0 }
  vg11.setSize(g_double,nbpt,1);        { dimensionner vg0 }


  para.setSize(NbPara,1);               { dimensionner para }

  for i:=1 to Nblin1 do                  { copier Vlin dans para }
    para[i,1]:=Vlin1[Vlin1.Istart+i-1];

  for i:=1 to nblin1 do                 { copier Vlin2 dans para }
    para[Nblin1+i,1]:=Vlin2[Vlin2.Istart+i-1];

  for i:=1 to nblin1 do                 { copier Vlin3 dans para }
    para[2*Nblin1+i,1]:=Vlin3[Vlin3.Istart+i-1];

  for i:=1 to nblin1 do                 { copier Vlin4 dans para }
    para[3*Nblin1+i,1]:=Vlin4[Vlin4.Istart+i-1];


  for i:=1 to nbNonLin1 do              { copier Vnonlin dans para }
  para[4*Nblin1+i,1]:= Vnonlin[Vnonlin.Istart+i-1];
end;

procedure ToptiFitModel2.getData(vecFit, Vlin1, Vlin2, Vlin3,Vlin4, Vnonlin: Tvector);
var
  i:integer;
begin
  vecFit.initTemp1(0,nbpt-1,vecFit.tpNum);

  with vecFit do
  for i:=Istart to Iend do
    Yvalue[i]:=yfit[i-Istart+1,1];

  for i:=1 to Nblin1 do
    Vlin1[Vlin1.Istart+i-1]:=para[i,1];

  for i:=1 to nblin1 do
    Vlin2[Vlin2.Istart+i-1]:=para[Nblin1+i,1];

  for i:=1 to nblin1 do
    Vlin3[Vlin3.Istart+i-1]:=para[2*Nblin1+i,1];

  for i:=1 to nblin1 do
    Vlin4[Vlin4.Istart+i-1]:=para[3*Nblin1+i,1];

  for i:=1 to nbNonLin1 do
    Vnonlin[Vnonlin.Istart+i-1]:=para[4*Nblin1+i,1];
end;

procedure ToptiFitModel2.NonlinFilter1(src,dest:Tmat;gg,cc,ct:float);
var
  i:integer;
begin
  dest.copy(src);
  Ln1(dest);                      { yfit = Log(yfit) }
  Mul(dest,CC);                   { yfit = cc * Log(yfit) }

  Thresh1(dest,100,true);         { seuil +inf }
  Thresh1(dest,-100,false);       { seuil -inf }

  for i:=1 to nbpt do dest[i,1]:=gg*exp(dest[i,1])+ct;
end;


procedure ToptiFitModel2.NonlinFilter2(src,dest:Tmat;gg,cc:float);
var
  i:integer;
begin
  ydum.copy(src);
  Ln1(ydum);                      { yfit = Log(yfit) }
  Mul(ydum,Cc);                   { yfit = cp * Log(yfit) }

  Thresh1(ydum,100,true);         { seuil +inf }
  Thresh1(ydum,-100,false);       { seuil -inf }

  for i:=1 to nbpt do dest[i,1]:=dest[i,1] - gg*exp(ydum[i,1]);
end;


procedure proOptiModel2(var VInput1,Vinput2,VOutPut,Vseg,Vlin1,Vlin2,Vlin3,Vlin4,VnonLin,vecE,Vclamp: Tvector;
                       NblinA1:integer;var chi2:float;nbIt:integer);
var
  opti:ToptiFitModel2;
  i:integer;
begin
  verifierVecteur(VInput1);
  verifierVecteur(VInput2);
  verifierVecteur(VOutput);
  verifierVecteur(Vlin1);
  verifierVecteur(Vlin2);
  verifierVecteur(Vlin3);
  verifierVecteur(Vlin4);

  verifierVecteur(Vnonlin);

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

  if assigned(Vclamp) then
  if Vclamp.Icount<4*nblinA1+5
    then sortieErreur('OPTI : invalid Vclamp size');

  opti:=ToptiFitModel2.create;
  TRY
    if nbIt>0 then opti.cntmax:=nbIt;

    opti.InstallData(VInput1,Vinput2,VoutPut,Vlin1,Vlin2,Vlin3,Vlin4,Vnonlin,NblinA1);

    if assigned(Vclamp) then
      with Vclamp do
      for i:=0 to high(opti.Vclamp) do opti.Vclamp[i]:=(Yvalue[Istart+i]<>0);

    opti.installSegs(Vseg,Vinput1.Istart);

    opti.execute;
    opti.getData(vecE,Vlin1,Vlin2,Vlin3,Vlin4,Vnonlin);

    chi2:=opti.chiSq1;
  FINALLY
    opti.free;
  END;
end;


end.
