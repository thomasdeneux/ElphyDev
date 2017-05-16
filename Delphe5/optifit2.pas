unit optifit2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Dgraphic,
     IPPS17,IPPdefs17, ipp17ex,
     Ncdef2,stmPg,
     stmDef,stmObj,stmvec1,stmMat1,mathKernel0,stmKLmat,
     optiFit1;

type
  ToptiFitModel1=class(ToptifitTh0)
             PH1,PH2,PH3: Pointer;
             Cp,g0,Cte:float;
             C1,g1: array[1..4] of float;

             {xdat1 : Tmat }
             xdat2,xdat1m,xdat2m,xdat1H,xdat2H:Tmat;
             xdatU:array[1..4] of Tmat;
             {ylin1 : Tmat }
             ylin2:Tmat;
             ylin3:array[1..4] of Tmat;
             ylin3abs:array[1..4] of Tmat;

             yinter:Tmat;
             ydum,ydum1:Tmat;

             Vg0:Tmat;
             Vg1:array[1..4] of Tmat;

             Nblin2,Nblin3:integer;
             nbchan:integer;


             constructor create;
             destructor destroy;override;

             procedure getYfit(pp:Tmat);override;
             procedure getJacobian(pp:Tmat);override;
             procedure controleVar(dd:Tmat);override;

             procedure InstallData(vecX1,vecX2,vecY,Vlin1,Vlin2,Vlin3,Vnonlin:Tvector;
                                   Nbl1,NbL2,nbL3:integer);
             procedure getData(vecFit,Vlin1,Vlin2,Vlin3,Vnonlin:Tvector);

             procedure NonlinFilter1(src,dest:Tmat;gg,cc,ct:float);
             procedure NonlinFilter2(src,dest:Tmat;gg,cc:float);
             procedure CalculDLin0(src1,src2:Tmat;nb,colJmat:integer);
             procedure CalculDlin1;

           end;

procedure proOptiModel1(var VInput1,Vinput2,VOutPut,Vseg,Vlin1,Vlin2,Vlin3,VnonLin,vecE,Vclamp: Tvector;
                       NblinA1,NblinA2,nblinA3:integer;var chi2:float;nbIt:integer);pascal;


implementation


{********************************  ToptiFitModel1  ****************************}



procedure hilbert(src,dest:Tmat);
var
  status:integer;
  p1:array of single;
  i:integer;
begin
  IPPStest;

  setLength(p1,src.Icount*src.Jcount);

  for i:=1 to src.Icount do p1[i-1]:= src[i,1];

  Hilbert32f(@p1[0], length(p1));

  for i:=1 to src.Icount do dest[i,1]:=p1[i-1];

  IPPSend;
end;


constructor ToptiFitModel1.create;
var
  i:integer;
begin
  inherited create;
  xdat2:=Tmat.create(g_double,1,1);

  xdat1H:=Tmat.create(g_double,1,1);
  xdat2H:=Tmat.create(g_double,1,1);

  xdat1M:=Tmat.create(g_double,1,1);
  xdat2M:=Tmat.create(g_double,1,1);

  ylin2:=Tmat.create(g_double,1,1);
  for i:=1 to 4 do
  begin
    ylin3[i]:=Tmat.create(g_double,1,1);
    ylin3abs[i]:=Tmat.create(g_double,1,1);
  end;

  yinter:=Tmat.create(g_double,1,1);
  ydum:=Tmat.create(g_double,1,1);
  ydum1:=Tmat.create(g_double,1,1);

  vg0:=Tmat.create(g_double,1,1);
  for i:=1 to 4 do
    vg1[i]:=Tmat.create(g_double,1,1);

  xdatU[1]:=xdat1;
  xdatU[2]:=xdat1m;
  xdatU[3]:=xdat2H;
  xdatU[4]:=xdat2m;

  nbchan:=4;
end;

destructor ToptiFitModel1.destroy;
var
  i:integer;
begin
  xdat2.free;
  xdat1H.free;
  xdat2H.free;

  xdat1M.free;
  xdat2M.free;

  ylin2.free;
  for i:=1 to 4 do ylin3[i].free;
  for i:=1 to 4 do ylin3abs[i].free;

  yinter.free;
  ydum.free;
  ydum1.Free;

  vg0.free;
  for i:=1 to 4 do vg1[i].free;

  inherited;
end;


procedure ToptiFitModel1.controleVar(dd: Tmat);
var
  n,i:integer;
begin
  n:=Nblin1+nblin2+nblin3;

  checkLimits(dd,n+1,0,100000);
  checkLimits(dd,n+2,0.1,5);

  for i:=0 to nbchan-1 do
  begin
    checkLimits(dd,n+4+2*i,0,10000);
    checkLimits(dd,n+5+2*i,0.1,5);
  end;
end;


procedure ToptiFitModel1.getYfit(pp: Tmat);
var
  i,j:integer;
  w,w1:double;
begin
  PH1:=pp.cell(1,1);
  PH2:=pp.cell(nblin1+1,1);
  PH3:=pp.cell(nblin1+nblin2+1,1);

  g0:= pp[Nblin1+nblin2+nblin3+1,1];
  Cp:= pp[Nblin1+nblin2+nblin3+2,1];
  Cte:=pp[Nblin1+nblin2+nblin3+3,1];

  for i:=1 to nbchan do
  begin
    g1[i]:= pp[Nblin1+nblin2+nblin3+4+(i-1)*2,1];
    C1[i]:= pp[Nblin1+nblin2+nblin3+5+(i-1)*2,1];
  end;

  IPPStest;
  try
  TRY
        {Les résultats des filtres linéaires sont donnés par des convolutions }
  conv64f(xdat1.tbD,nbpt,Pdouble(pH1),Nblin1,ylin1.tbD);
  conv64f(xdat2.tbD,nbpt,Pdouble(pH2),Nblin2, ylin2.tbD);

  for i:= nbchan downto 1 do
  begin
    conv64f(xdatU[i].tbD,nbpt,Pdouble(pH3),Nblin3, ylin3[i].tbD);
    ylin3abs[i].copy(ylin3[i]);
    absThresh(ylin3abs[i],1E-20);
  end;

  Add(ylin1,ylin2,yinter);     { ranger la somme  ylin1+ylin2 dans yinter }

  for i:=nbchan downto 1  do
    NonLinFilter2(ylin3abs[i],yinter,g1[i],c1[i]); { retrancher ylin3 passé dans la non linéarité f2 }

  NonlinFilter1(yinter,yfit,g0,cp,cte);         { Non linéarité finale }

  FINALLY
  IPPSend;
  END;
  except
    yfit.EditModal;
    {messageCentral('Except');}
  end;
end;

procedure ToptiFitModel1.CalculDLin0(src1,src2:Tmat;nb,colJmat:integer);
var
  i:integer;
begin
  { Calcul de la colonne Lin = src1(t)*src21(t-i)  }
   for i:=1 to nb do
    ippsMul_64f(Pdouble(src1.cell(i,1)),Pdouble(src2.Cell(1,1)),Pdouble(Jmat.cell(i,colJmat+i-1)),nbpt-i+1 );
end;

procedure ToptiFitModel1.CalculDlin1;
var
  i,j:integer;
begin
  for i:=1 to nblin3 do
  begin
    ydum1.clear;

    for j:=nbchan downto 1 do
    begin
      ydum.clear;
      ippsMul_64f(Pdouble(Vg1[j].cell(i,1)),Pdouble(xdatU[j].Cell(1,1)),Pdouble(ydum.cell(i,1)),nbpt-i+1 );
      Add(ydum,ydum1);
    end;

    Mul(Vg0,ydum1);
    Mul(ydum1,-1);
    vecToJmat(ydum1,nblin1+nblin2+i);
  end;
end;

procedure ToptiFitModel1.getJacobian(pp: Tmat);
var
  i,j:integer;
  w:double;
begin
  Jmat.setSize(nbpt,nbpara);
  Jmat.clear;

  IPPStest;

  TRY

  getYfit(pp);

  NonlinFilter1(yinter,Vg0,g0*Cp,Cp-1,0);
  for i:=nbchan downto 1 do
  begin
    NonlinFilter1(ylin3abs[i],Vg1[i],g1[i]*C1[i],C1[i]-1,0);
    with Vg1[i] do
    for j:=1 to RowCount do
      if ylin3[i][j,1]<0 then Zvalue[j,1]:=-Zvalue[j,1];
  end;
  calculDLin0(Vg0,xdat1,nblin1,1);
  calculDLin0(Vg0,xdat2,nblin2,nblin1+1);

  calculDLin1;

  NonlinFilter1(yinter,ydum,1,Cp,0);
  VecToJmat(ydum,nblin1+nblin2+nblin3+1);

  Mul(ydum,g0);
  ydum1.copy(ydum);
  ln1(ydum1);
  mul(ydum,ydum1);
  VecToJmat(ydum1,nblin1+nblin2+nblin3+2);

  ippsSet_64f(1, Pdouble(Jmat.cell(1,Nblin1+nblin2+nblin3+3)),nbpt);

  for i:=nbchan downto 1 do
  begin
    NonlinFilter1(ylin3abs[i],ydum,-1,C1[i],0);
    mul(Vg0,ydum);
    VecToJmat(ydum,nblin1+nblin2+nblin3+4+(i-1)*2);

    NonlinFilter1(ylin3abs[i],ydum,-g1[i],C1[i],0);
    ydum1.copy(ylin3abs[i]);
    ln1(ydum1);
    mul(ydum,ydum1);
    mul(Vg0,ydum1);
    VecToJmat(ydum1,nblin1+nblin2+nblin3+5+(i-1)*2);
  end;

  FINALLY

  IPPSend;
  END;

  {Jmat.editModal;}
end;

procedure ToptiFitModel1.InstallData(vecX1, vecX2, vecY, Vlin1,Vlin2,Vlin3,Vnonlin: Tvector;
                 Nbl1, NbL2, nbL3: integer);
var
  i:integer;
begin
  Nblin1:=Nbl1;
  Nblin2:=Nbl2;
  Nblin3:=nbL3;
  NbNonLin1:=3+nbchan*2;
  Nbpt:=vecX1.ICount;
  Nbpara:=Nblin1+nblin2+nbLin3+NbNonLin1;

  setlength(Vclamp,nbpara);
  fillchar(Vclamp[0],nbpara,0);

  xdat1.setSize(g_double,nbPt,1);
  xdat2.setSize(g_double,nbPt,1);
  xdat1m.setSize(g_double,nbPt,1);
  xdat2m.setSize(g_double,nbPt,1);
  xdat1H.setSize(g_double,nbPt,1);
  xdat2H.setSize(g_double,nbPt,1);

  with vecX1 do
  for i:=Istart to Iend do
  begin
    xdat1[i-Istart+1,1]:=Yvalue[i];     { copier vecX1 dans xdat1 }
    xdat1m[i-Istart+1,1]:=Yvalue[i];   { et -vecX1 dans xdat1m }
  end;
  Hilbert(xdat1,xdat1H);                {Transformée de Hilbert de xdat1 dans xdat1H}

  with vecX2 do
  for i:=Istart to Iend do
    xdat2[i-Istart+1,1]:=Yvalue[i];     { copier vecX2 dans xdat2 }
  Hilbert(xdat2,xdat2H);                {Transformée de Hilbert de xdat2 dans xdat2H}

  with vecX2 do
  for i:=Istart to Iend do              { et l'opposé de la transformée de Hilbert  dans xdat2H }
    xdat2m[i-Istart+1,1]:=-xdat2H[i-Istart+1,1];


  ydat.setSize(g_double,nbpt,1);        { copier vecY dans ydat }
  with vecY do
  for i:=Istart to Iend do
    ydat[i-Istart+1,1]:=Yvalue[i];

  (*
  with vecX1 do
  for i:=Istart to Iend do
  begin
    xdat1m[i-Istart+1,1]:=abs(Yvalue[i])+abs(vecX2.Yvalue[i]);   { et -vecX1 dans xdat1m }
  end;
  *)

  ylin1.setSize(g_double,nbpt+Nblin1,1); { dimensionner ylin1 }
  ylin2.setSize(g_double,nbpt+nblin2,1); { dimensionner ylin2 }
  for i:=1 to 4 do
  begin
    ylin3[i].setSize(g_double,nbpt+nblin3,1); { dimensionner ylin3 }
    ylin3abs[i].setSize(g_double,nbpt+nblin3,1); { dimensionner ylin3abs }
  end;  


  yinter.setSize(g_double,nbpt,1);      { dimensionner yinter }
  ydum.setSize(g_double,nbpt,1);        { dimensionner ydum }
  ydum1.setSize(g_double,nbpt,1);       { dimensionner ydum }
  yfit.setSize(g_double,nbpt,1);        { dimensionner yfit }

  vg0.setSize(g_double,nbpt,1);         { dimensionner vg0 }
  for i:=1 to 4 do
    vg1[i].setSize(g_double,nbpt,1);    { dimensionner vg1 }


  para.setSize(NbPara,1);               { dimensionner para }

  for i:=1 to Nblin1 do                  { copier Vlin dans para }
    para[i,1]:=Vlin1[Vlin1.Istart+i-1];

  for i:=1 to nblin2 do                 { copier Vlin2 dans para }
    para[Nblin1+i,1]:=Vlin2[Vlin2.Istart+i-1];

  for i:=1 to nblin3 do                 { copier Vlin3 dans para }
    para[Nblin1+nblin2+i,1]:=Vlin3[Vlin3.Istart+i-1];

  for i:=1 to nbNonLin1 do              { copier Vnonlin dans para }
  para[Nblin1+nblin2+nblin3+i,1]:= Vnonlin[Vnonlin.Istart+i-1];
end;

procedure ToptiFitModel1.getData(vecFit, Vlin1, Vlin2, Vlin3, Vnonlin: Tvector);
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

  for i:=1 to nblin3 do
    Vlin3[Vlin3.Istart+i-1]:=para[Nblin1+nblin2+i,1];

  for i:=1 to nbNonLin1 do
    Vnonlin[Vnonlin.Istart+i-1]:=para[Nblin1+nblin2+nblin3+i,1];
end;

procedure ToptiFitModel1.NonlinFilter1(src,dest:Tmat;gg,cc,ct:float);
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


procedure ToptiFitModel1.NonlinFilter2(src,dest:Tmat;gg,cc:float);
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


procedure proOptiModel1(var VInput1,Vinput2,VOutPut,Vseg,Vlin1,Vlin2,Vlin3,VnonLin,vecE,Vclamp: Tvector;
                       NblinA1,NblinA2,nblinA3:integer;var chi2:float;nbIt:integer);
var
  opti:ToptiFitModel1;
  i:integer;
begin
  verifierVecteur(VInput1);
  verifierVecteur(VInput2);
  verifierVecteur(VOutput);
  verifierVecteur(Vlin1);
  verifierVecteur(Vlin2);
  verifierVecteur(Vlin3);
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
  if Vclamp.Icount<nblinA1+nblinA2+nblinA3+11
    then sortieErreur('OPTI : invalid Vclamp size');

  opti:=ToptiFitModel1.create;
  TRY
    if nbIt>0 then opti.cntmax:=nbIt;

    opti.InstallData(VInput1,Vinput2,VoutPut,Vlin1,Vlin2,Vlin3,Vnonlin,NblinA1,NblinA2,NblinA3);

    if assigned(Vclamp) then
      with Vclamp do
      for i:=0 to high(opti.Vclamp) do opti.Vclamp[i]:=(Yvalue[Istart+i]<>0);

    opti.installSegs(Vseg,Vinput1.Istart);

    opti.execute;
    opti.getData(vecE,Vlin1,Vlin2,Vlin3,Vnonlin);

    chi2:=opti.chiSq1;
  FINALLY
    opti.free;
  END;
end;


end.
