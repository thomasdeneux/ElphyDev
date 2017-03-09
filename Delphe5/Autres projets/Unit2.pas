unit Unit2;

interface

implementation


procedure curfit1(var a,b,c,d,e,f;
                  var Xpara;
                  var XParaCl;
                  var ChiSqr:float;
                  var reg1,reg2:float;
                  Nbpts:integer;
                  NbPara:integer;
                  fonc:typeFonction;
                  derivee:typeDerivee;
                  Mode:integer;
                  seuil:float;
                  Faff:TAffproc);

  const
    IteraMax=30;

  var
    x:typeData ABSOLUTE a;
    y:typeData ABSOLUTE b;
    yFit:typeData ABSOLUTE c;
    SigmaY:typeData ABSOLUTE e;
    SigmaA:typePara ABSOLUTE f;

    para:typePara absolute Xpara;
    ParaCl:TypeParaClamp absolute XparaCl;

    befor,first,fin,finB:boolean;
    Lambda,LambdaB:float;
    i,j,k,itera:integer;
    ChiSq1:float;
    Beta,BB,paraB:typePara;
    Alpha:typeMatrice;
    tablo:typeMatrice;
    petit:float;
    det:float;
    Nlib:integer;
    Deriv:typePara;

    cnt:longint;
    test:integer;
    diff:float;


  begin
    cnt:=0;
    Nlib:=NbPts-NbPara;
    if Nlib<=0 then exit;

    Lambda:=1.0E-5;
    befor:=false;
    first:=true;
    fin:=false;


    repeat                          { Boucle principale }

      chisq1:=0;
      for i:=1 to NbPts do                 { Calcul yfit = estimation pour para }
        begin
          yfit[i]:=fonc(x[i],para);
          diff:=y[i]-yfit[i];
          chisq1:=chisq1+ diff*diff;       { et Chi1 = chi carré }
        end;
      chisq1:=chisq1/(Nlib);

      fillchar(alpha,sizeof(alpha),0);     { Calcul de alpha et beta }
      fillchar(beta,sizeof(beta),0);

      for i:=1 to NbPts do
        begin                                               { pour chaque point: }
          deriveeGene(x[i],para,paraCl,deriv,nbPara,fonc);  {      dérivée par rapport aux params }

          for j:=1 to NbPara do
            begin
              beta[j]:=beta[j]+ (y[i]-yfit[i])*deriv[j];
              for k:=1 to j do
                alpha[j,k]:=alpha[j,k]+ deriv[j]*deriv[k];
            end;
        end;

      for j:=1 to NbPara do              { Compléter la matrice symétrique }
        begin
          for k:=1 to j do
            alpha[k,j]:=alpha[j,k];
          if abs(alpha[j,j])<epsilon then
            if alpha[j,j]>0 then alpha[j,j]:=epsilon
                            else alpha[j,j]:=-epsilon ;
        end;



      itera:=0;
      finB:=false;
      repeat
        if testclavier(test) and (test=27) then fin:=true;
        inc(cnt);
        if cnt>Fitcntmax then fin:=true;


        for j:=1 to nbPara do            { Evaluation de BB = nouveau jeu de params }
          begin
            for k:=1 to nbPara do
              tablo[j,k]:=alpha[j,k]/sqrt(abs(alpha[j,j]*alpha[k,k]));
            tablo[j,j]:=1.0+Lambda;
          end;
        MatInv(tablo,det,nbPara);
        for j:=1 to nbPara do             { Inverser la matrice     }
          begin
            BB[j]:=para[j];
            for k:=1 to nbPara do
              BB[j]:=BB[j]+beta[k]*tablo[j,k]/sqrt(abs(alpha[j,j]*alpha[k,k]));
          end;

        chisqr:=0;
        for i:=1 to NbPts do
          begin
            yfit[i]:=fonc(x[i],BB);    { Calcul du chi carré pour BB }
            diff:=y[i]-yfit[i];
            chisqr:=chisqr+ diff*diff;
          end;
        chisqr:=chisqr/(Nlib);

        if (Chisq1>=ChiSqr) then        { S'il est meilleur, on le garde }
          begin
            for j:=1 to Nbpara do
              begin
                paraB[j]:=para[j];
                para[j]:=BB[j];
                sigmaa[j]:=sqrt(abs(tablo[j,j]/alpha[j,j]));
              end;
            first:=false;
            LambdaB:=Lambda;
            Lambda:=Lambda*0.1;
            if (ChiSq1-ChiSqr)*seuil>Chisq1
              then FinB:=true
              else fin:=true;
          end
        else                           { Sinon on le rejette }
          begin
            Lambda:=Lambda*10;
            inc(Itera);
          end;

      until (itera>IteraMax) or FinB or Fin;

      if not (FinB or Fin) then
        begin
          if Befor or first then  fin:=true
          else
          begin
            For j:=1 to NbPara do para[j]:=paraB[j];
            Lambda:=LambdaB*10;
            Befor:=True;
          end;
        end;

    until Fin;       { Fin Boucle Principale }

    reg1:=coeffReg1(a,b,para,nbPts,fonc);
    reg2:=coeffRegSEB(a,b,para,nbPts,fonc);

  end; { of CurFit1 }




procedure OptiFit( y,yfit,para:Tmat);
  const
    IteraMax=30;

  var
    befor,first,fin,finB:boolean;
    Lambda,LambdaB:float;
    i,j,k,itera:integer;
    ChiSq1:float;
    Beta,BB,paraB:typePara;
    Alpha:typeMatrice;
    tablo:typeMatrice;
    Nlib:integer;

    cnt:longint;
    test:integer;
    diff:float;

  begin
    Nbpts:=y.rowCount;
    NbPara:=para.rowCount;
    Nlib:=NbPts-NbPara;
    if Nlib<=0 then exit;

    Lambda:=1.0E-5;
    befor:=false;
    first:=true;
    fin:=false;
    cnt:=0;

    repeat                          { Boucle principale }

      getFunction(yfit,para);                 { Calcul yfit = estimation pour para }
      Vsub(y,yfit,diff);                      { et Chisq1 = chi carré }
      chisq1:=Vmodulus(diff)/Nlib;

      getJacobian(para,Jmat);

      beta.prod1(Jmat,diff,transpose,normal);
      alpha.prod1(Jmat,Jmat,transpose,normal);

      with alpha do
      for j:=1 to rowCount do
      begin
        if abs(Zvalue[j,j])<epsilon then
          if Zvalue[j,j]>0 then Zvalue[j,j]:=epsilon
                           else Zvalue[j,j]:=-epsilon ;
      end;

      itera:=0;
      finB:=false;
      repeat
        if testEscape then fin:=true;
        inc(cnt);
        if cnt>Fitcntmax then fin:=true;

        Mcopy(alpha,tablo);
        with tablo do
        for j:=1 to rowCount do
        begin
          for k:=1 to colCount do
            tablo[j,k]:=alpha[j,k]/sqrt(abs(alpha[j,j]*alpha[k,k]));
          tablo[j,j]:=1.0+Lambda;
        end;


        tablo.solveChk(beta,BB);
        BB.add(para);

        getYfit(yfit,BB);                { Calcul du chi carré pour BB }
        Vsub(y,yfit,diff);
        chisqr:=Vmodulus(diff)/Nlib;

        if (Chisq1>=ChiSqr) then        { S'il est meilleur, on le garde }
          begin
            paraB.copy(para);
            para.copy(BB);

            first:=false;
            LambdaB:=Lambda;
            Lambda:=Lambda*0.1;
            if (ChiSq1-ChiSqr)*seuil>Chisq1
              then FinB:=true
              else fin:=true;
          end
        else                           { Sinon on le rejette }
          begin
            Lambda:=Lambda*10;
            inc(Itera);
          end;

      until (itera>IteraMax) or FinB or Fin;

      if not (FinB or Fin) then
        begin
          if Befor or first then  fin:=true
          else
          begin
            para.copy(paraB);
            Lambda:=LambdaB*10;
            Befor:=True;
          end;
        end;

    until Fin;       { Fin Boucle Principale }


  end;



end.
