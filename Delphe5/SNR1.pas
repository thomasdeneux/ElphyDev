unit SNR1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,
     util1,Gdos,Dgraphic,
     stmdef,stmobj,
     NcDef2,stmpg,
     ippdefs17,ipps17,ipp17ex,
     stmvec1,stmMat1,
     VlistA1;


procedure proSNRanalysis(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma:TMatrix;zero:float);pascal;
procedure proSNRanalysis_1(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma:TMatrix;zero:float;SinglePrecision:boolean);pascal;

procedure proSNRanalysis_2(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma, MatModulusMoy:TMatrix;zero:float);pascal;
procedure proSNRanalysis_3(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma,MatModulusMoy:TMatrix;zero:float;SinglePrecision:boolean);pascal;

procedure proSNRanalysis_4(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma, MatModulusMoy,MatPhase,MatPhaseSigma:TMatrix;zero:float);pascal;
procedure proSNRanalysis_5(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma,MatModulusMoy,MatPhase,MatPhaseSigma:TMatrix;zero:float;SinglePrecision:boolean);pascal;


procedure proSNRanalysis2(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma, MatModulusMoy:TMatrix;zero:float);pascal;
procedure proSNRanalysis2_1(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma,MatModulusMoy:TMatrix;zero:float;SinglePrecision:boolean);pascal;


implementation


// Calcul en Double Précision
procedure SNRanalysisD(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma,MatModulusMoy,matPhase,matPhaseSigma:TMatrix;zero:float);
var
  i,j,k:integer;
  vecs:array of array of double;
  vecFil1,vecFil2: array of double;

  vecSum1,vecSum2,vecSumSqr1,vecSumSqr2,vecSumMod:array of double;
  vecTemp1,vecTemp2:array of double;
  vecTemp3,vecTemp4,phaseX,phaseY,vecSumPhaseX,vecSumPhaseY,vecOne: array of double;

  Nbvec,Nbpt,nbfq,nbptFil:integer;
  ind0:integer;
  Fphase:boolean;

  Buf: pointer;
  BufSize: integer;

Const
  Epsilon=1E-30;
begin
  IPPStest;

  nbfq:=tabFil.count;
  if nbfq<1 then sortieErreur('SNRanalysis : not enough frequencies');

  Fphase:= assigned(matPhase) and  assigned(matPhaseSigma);

  with Vlist do
  begin
    if count<2 then sortieErreur('SNRanalysis : not enough data vectors');
    Nbvec:=count;
    Nbpt:=vectors[1].Icount;
    setLength(vecs,nbvec,nbpt);

    for i:=0 to count-1 do
    with vectors[i+1] do
    begin
      if Icount<>nbpt then sortieErreur('SNRanalysis : data vectors must have the same length');
      for j:=Istart to Iend do
        vecs[i,j-Istart]:=Yvalue[j];
    end;
  end;

  with SNRmat do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  with MatModulus do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  with MatSigma do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  if assigned(MatModulusMoy) then
  with MatModulusMoy do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  if assigned(MatPhase) then
  with MatPhase do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  if assigned(MatPhaseSigma) then
  with MatPhaseSigma do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);


  setLength(vecSum1,nbpt);
  setLength(vecSum2,nbpt);
  setLength(vecSumSqr1,nbpt);
  setLength(vecSumSqr2,nbpt);
  setLength(vecSumMod,nbpt);

  setlength(vecTemp3,nbpt);
  setlength(vecTemp4,nbpt);
  setlength(vecSumPhaseX,nbpt);
  setlength(vecSumPhaseY,nbpt);
  setlength(PhaseX,nbpt);
  setlength(PhaseY,nbpt);

  setlength(vecOne,nbpt);
  ippsSet_64f(1,Pdouble(@vecOne[0]),nbpt);

  for i:=0 to nbfq-1 do
  begin                                                                                             { Pour chaque fréquence }
     ippsZero_64f(Pdouble(@vecSum1[0]),nbpt);
     ippsZero_64f(Pdouble(@vecSum2[0]),nbpt);
     ippsZero_64f(Pdouble(@vecSumSqr1[0]),nbpt);
     ippsZero_64f(Pdouble(@vecSumSqr2[0]),nbpt);
     ippsZero_64f(Pdouble(@vecSumMod[0]),nbpt);

     ippsZero_64f(Pdouble(@vecSumPhaseX[0]),nbpt);
     ippsZero_64f(Pdouble(@vecSumPhaseY[0]),nbpt);
                                                                                                    { Ranger les parties réelle et imag dans VecFil1 et VecFil2}
     with tabFil.vectors[i+1] do
     begin
       setLength(vecFil1,Icount);
       setLength(vecFil2,Icount);
       for j:=Istart to Iend do
       begin
         vecFil1[j-Istart]:=Yvalue[j];
         vecFil2[j-Istart]:=Imvalue[j];
       end;

       setLength(vecTemp1,nbpt+Icount);                             // vecTemp1 et vecTemp2 contiennent  nbpt+nbptFil points
       setLength(vecTemp2,nbpt+Icount);                             // La partie utile commence à l'indice ind0

       nbptFil:=Icount;
       ind0:=-Istart;
     end;

     ippsConvolveGetBufferSize(nbpt, nbptFil, _ipp64f, ippAlgAuto, @bufSize);
     Buf := ippsMalloc_8u( bufSize );

     for j:=0 to nbVec-1 do                                                                         { Balayer la liste de vecteurs }
     begin
         ippsConvolve_64f(Pdouble(@vecs[j,0]),nbpt,Pdouble(@vecFil1[0]),nbptFil,Pdouble(@vecTemp1[0]),ippAlgAuto,Buf);     { Convoluer vec avec Re(filtre) ==> vecTemp1 }
         ippsConvolve_64f(Pdouble(@vecs[j,0]),nbpt,Pdouble(@vecFil2[0]),nbptFil,Pdouble(@vecTemp2[0]),ippAlgAuto,Buf);     { Convoluer vec avec Im(filtre) ==> vecTemp2 }

         if Fphase then
         begin
           ippsPhase_64f(Pdouble(@vecTemp1[ind0]),Pdouble(@vecTemp2[ind0]),Pdouble(@vectemp3[0]), nbpt);                    { Phase actuelle }
           ippsPolarToCart_64f( Pdouble(@vecOne[0]), Pdouble(@vectemp3[0]),Pdouble(@PhaseX[0]),Pdouble(@PhaseY[0]), nbpt);  { Proj X et Y de la phase }

           ippsAdd_64f_I(Pdouble(@PhaseX[0]),Pdouble(@vecSumPhaseX[0]),nbpt);                          { Somme des proj X }
           ippsAdd_64f_I(Pdouble(@PhaseY[0]),Pdouble(@vecSumPhaseY[0]),nbpt);                          { Somme des proj Y }
         end;

         ippsAdd_64f_I(Pdouble(@vecTemp1[ind0]),Pdouble(@vecSum1[0]),nbpt);                               { Somme des Re dans VecSum1 }
         ippsSqr_64f_I(Pdouble(@vecTemp1[ind0]),nbpt);
         ippsAdd_64f_I(Pdouble(@vecTemp1[ind0]),Pdouble(@vecSumSqr1[0]),nbpt);                            { Somme des carrés des Re dans VecSumSqr1 }


         ippsAdd_64f_I(Pdouble(@vecTemp2[ind0]),Pdouble(@vecSum2[0]),nbpt);                               { Somme des Im dans VecSum2 }
         ippsSqr_64f_I(Pdouble(@vecTemp2[ind0]),nbpt);
         ippsAdd_64f_I(Pdouble(@vecTemp2[ind0]),Pdouble(@vecSumSqr2[0]),nbpt);                            { Somme des carrés des Im dans VecSumSqr2 }

         ippsAdd_64f_I(Pdouble(@vecTemp2[ind0]),Pdouble(@vecTemp1[ind0]),nbpt);                           { Somme du carré de conv1 et du carré de conv2 }
         ippsSqrt_64f_I(Pdouble(@vecTemp1[ind0]),nbpt);                                                   { prendre la racine ==> module de conv }
         ippsAdd_64f_I(Pdouble(@vecTemp1[ind0]),Pdouble(@vecSumMod[0]),nbpt);                             { somme des modules }
     end;
     // A ce stade, on dispose de vecSum1, vecSum2, vecSumSqr1, vecSumSqr2 et vecSumMod
     // et aussi VecSumPhaseX, vecSumPhaseY

     ippsFree(Buf);

     if Fphase then
     begin
       ippsPhase_64f(Pdouble(@vecSum1[0]),Pdouble(@vecSum2[0]),Pdouble(@vectemp3[0]), nbpt);             { Phase résultante }

       ippsMagnitude_64f(Pdouble(@vecSumPhaseX[0]),Pdouble(@vecSumPhaseY[0]),Pdouble(@vectemp4[0]), nbpt);
       ippsMulc_64f_I(1/nbvec, Pdouble(@vectemp4[0]), nbpt);
     end;

     ippsSqr_64f_I(Pdouble(@vecSum1[0]),nbpt);
     ippsSqr_64f_I(Pdouble(@vecSum2[0]),nbpt);
     ippsAdd_64f_I(Pdouble(@vecSum2[0]),Pdouble(@vecSum1[0]),nbpt);           { vecSum1 = (Sx)² + (Sy)² }
     ippsMulC_64f_I(1/nbvec,Pdouble(@vecSum1[0]),nbpt);                       { vecSum1 = ((Sx)² + (Sy)²)/N }

     ippsAdd_64f_I(Pdouble(@vecSumSqr2[0]),Pdouble(@vecSumSqr1[0]),nbpt);     { Sx2 + Sy2 }
     ippssub_64f_I(Pdouble(@vecSum1[0]),Pdouble(@vecSumSqr1[0]),nbpt);        { Sx2+Sy2- ((Sx)² + (Sy)²)/N   }
     ippsAbs_64f_I(Pdouble(@vecSumSqr1[0]),nbpt);                             { rendre positif à coup sûr }
     ippsMulC_64f_I(1/(nbvec-1),Pdouble(@vecSumSqr1[0]),nbpt);                { sigma² =  (((Sx)² + (Sy)²)/N  - (Sx2+Sy2)) /(N-1)   }
     ippsSqrt_64f_I(Pdouble(@vecSumSqr1[0]),nbpt);                            { sigma }


     ippsMulC_64f_I(1/nbvec,Pdouble(@vecSum1[0]),nbpt);                       { vecSum1 = ((Sx)² + (Sy)²)/(N*N)  }
     ippsSqrt_64f_I(Pdouble(@vecSum1[0]),nbpt);                               { vecSum1 = sqrt(((Sx)² + (Sy)²)/(N*N)) =  moy}
     ippsMulC_64f_I(1/Nbvec, Pdouble(@vecSumMod[0]),nbpt);                    { moyenne des modules }

     for k:=0 to nbpt-1 do
     begin
        with SNRmat do
        if vecSumSqr1[k]>Epsilon
          then Zvalue[Istart+k,Jstart+i]:= vecSum1[k]/vecSumSqr1[k]     { SNRmat contient le rapport  module du vecteur résultant moyen/ sigma }
          else Zvalue[k,i]:= zero;

        with MatModulus do Zvalue[Istart+k,Jstart+i] := vecSum1[k];     { MatModulus  contient le module du vecteur résultant moyen }
        with MatSigma do Zvalue[Istart+k,Jstart+i] := vecSumSqr1[k];    { MatSigma contient la standard deviation du module }

        if assigned(MatModulusMoy) then
        with MatModulusMoy do Zvalue[Istart+k,Jstart+i] := vecSumMod[k];         { MatModulusMoy contient la moyenne des modules }

        if Fphase then
        begin
          with MatPhase do Zvalue[Istart+k,Jstart+i] := vecTemp3[k];
          with MatPhaseSigma do Zvalue[Istart+k,Jstart+i] := 1-vecTemp4[k];
        end;
     end;
  end;

  IPPSend;
end;


//Calcul en Simple Précision
procedure SNRanalysisS(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma,MatModulusMoy,matPhase,matPhaseSigma:TMatrix;zero:float);
var
  i,j,k:integer;
  vecs:array of array of single;
  vecFil1,vecFil2: array of single;

  vecSum1,vecSum2,vecSumSqr1,vecSumSqr2,vecSumMod:array of single;
  vecTemp1,vecTemp2:array of single;
  vecTemp3,vecTemp4,phaseX,phaseY,vecSumPhaseX,vecSumPhaseY,vecOne: array of single;

  Nbvec,Nbpt,nbfq,nbptFil:integer;
  ind0:integer;
  Fphase:boolean;

  Buf: pointer;
  BufSize: integer;

Const
  Epsilon=1E-30;
begin
  IPPStest;

  nbfq:=tabFil.count;
  if nbfq<1 then sortieErreur('SNRanalysis : not enough frequencies');

  Fphase:= assigned(matPhase) and  assigned(matPhaseSigma);

  with Vlist do
  begin
    if count<2 then sortieErreur('SNRanalysis : not enough data vectors');
    Nbvec:=count;
    Nbpt:=vectors[1].Icount;
    setLength(vecs,nbvec,nbpt);

    for i:=0 to count-1 do
    with vectors[i+1] do
    begin
      if Icount<>nbpt then sortieErreur('SNRanalysis : data vectors must have the same length');
      for j:=Istart to Iend do
        vecs[i,j-Istart]:=Yvalue[j];
    end;
  end;

  with SNRmat do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  with MatModulus do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  with MatSigma do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  if assigned(MatModulusMoy) then
  with MatModulusMoy do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  if assigned(MatPhase) then
  with MatPhase do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  if assigned(MatPhaseSigma) then
  with MatPhaseSigma do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);


  setLength(vecSum1,nbpt);
  setLength(vecSum2,nbpt);
  setLength(vecSumSqr1,nbpt);
  setLength(vecSumSqr2,nbpt);
  setLength(vecSumMod,nbpt);

  setlength(vecTemp3,nbpt);
  setlength(vecTemp4,nbpt);
  setlength(vecSumPhaseX,nbpt);
  setlength(vecSumPhaseY,nbpt);
  setlength(PhaseX,nbpt);
  setlength(PhaseY,nbpt);

  setlength(vecOne,nbpt);
  ippsSet_32f(1,Psingle(@vecOne[0]),nbpt);

  for i:=0 to nbfq-1 do
  begin                                                                                             { Pour chaque fréquence }
     ippsZero_32f(Psingle(@vecSum1[0]),nbpt);
     ippsZero_32f(Psingle(@vecSum2[0]),nbpt);
     ippsZero_32f(Psingle(@vecSumSqr1[0]),nbpt);
     ippsZero_32f(Psingle(@vecSumSqr2[0]),nbpt);
     ippsZero_32f(Psingle(@vecSumMod[0]),nbpt);

     ippsZero_32f(Psingle(@vecSumPhaseX[0]),nbpt);
     ippsZero_32f(Psingle(@vecSumPhaseY[0]),nbpt);
                                                                                                    { Ranger les parties réelle et imag dans VecFil1 et VecFil2}
     with tabFil.vectors[i+1] do
     begin
       setLength(vecFil1,Icount);
       setLength(vecFil2,Icount);
       for j:=Istart to Iend do
       begin
         vecFil1[j-Istart]:=Yvalue[j];
         vecFil2[j-Istart]:=Imvalue[j];
       end;
       setLength(vecTemp1,nbpt+Icount);                    // vecTemp1 et vecTemp2 contiennent  nbpt+nbptFil points
       setLength(vecTemp2,nbpt+Icount);                    // La partie utile commence à l'indice ind0

       nbptFil:=Icount;
       ind0:=-Istart;
     end;

     ippsConvolveGetBufferSize(nbpt, nbptFil, _ipp32f, ippAlgAuto, @bufSize);
     Buf := ippsMalloc_8u( bufSize );

     for j:=0 to nbVec-1 do                                                                         { Balayer la liste de vecteurs }
     begin
         ippsConvolve_32f(Psingle(@vecs[j,0]),nbpt,Psingle(@vecFil1[0]),nbptFil,Psingle(@vecTemp1[0]), ippAlgAuto, Buf);     { Convoluer vec avec Re(filtre) ==> vecTemp1 }
         ippsConvolve_32f(Psingle(@vecs[j,0]),nbpt,Psingle(@vecFil2[0]),nbptFil,Psingle(@vecTemp2[0]), ippAlgAuto, Buf);     { Convoluer vec avec Im(filtre) ==> vecTemp2 }

         if Fphase then
         begin
           ippsPhase_32f(Psingle(@vecTemp1[ind0]),Psingle(@vecTemp2[ind0]),Psingle(@vectemp3[0]), nbpt);                    { Phase actuelle }
           ippsPolarToCart_32f( Psingle(@vecOne[0]), Psingle(@vectemp3[0]),Psingle(@PhaseX[0]),Psingle(@PhaseY[0]), nbpt);  { Proj X et Y de la phase }

           ippsAdd_32f_I(Psingle(@PhaseX[0]),Psingle(@vecSumPhaseX[0]),nbpt);                          { Somme des proj X }
           ippsAdd_32f_I(Psingle(@PhaseY[0]),Psingle(@vecSumPhaseY[0]),nbpt);                          { Somme des proj Y }
         end;

         ippsAdd_32f_I(Psingle(@vecTemp1[ind0]),Psingle(@vecSum1[0]),nbpt);                               { Somme des Re dans VecSum1 }
         ippsSqr_32f_I(Psingle(@vecTemp1[ind0]),nbpt);
         ippsAdd_32f_I(Psingle(@vecTemp1[ind0]),Psingle(@vecSumSqr1[0]),nbpt);                            { Somme des carrés des Re dans VecSumSqr1 }


         ippsAdd_32f_I(Psingle(@vecTemp2[ind0]),Psingle(@vecSum2[0]),nbpt);                               { Somme des Im dans VecSum2 }
         ippsSqr_32f_I(Psingle(@vecTemp2[ind0]),nbpt);
         ippsAdd_32f_I(Psingle(@vecTemp2[ind0]),Psingle(@vecSumSqr2[0]),nbpt);                            { Somme des carrés des Im dans VecSumSqr2 }

         ippsAdd_32f_I(Psingle(@vecTemp2[ind0]),Psingle(@vecTemp1[ind0]),nbpt);                           { Somme du carré de conv1 et du carré de conv2 }
         ippsSqrt_32f_I(Psingle(@vecTemp1[ind0]),nbpt);                                                   { prendre la racine ==> module de conv }
         ippsAdd_32f_I(Psingle(@vecTemp1[ind0]),Psingle(@vecSumMod[0]),nbpt);                             { somme des modules }
     end;
     // A ce stade, on dispose de vecSum1, vecSum2, vecSumSqr1, vecSumSqr2 et vecSumMod
     // et aussi VecSumPhaseX, vecSumPhaseY

     ippsFree(Buf);

     if Fphase then
     begin
       ippsPhase_32f(Psingle(@vecSum1[0]),Psingle(@vecSum2[0]),Psingle(@vectemp3[0]), nbpt);             { Phase résultante }

       ippsMagnitude_32f(Psingle(@vecSumPhaseX[0]),Psingle(@vecSumPhaseY[0]),Psingle(@vectemp4[0]), nbpt);
       ippsMulc_32f_I(1/nbvec, Psingle(@vectemp4[0]), nbpt);
     end;

     ippsSqr_32f_I(Psingle(@vecSum1[0]),nbpt);
     ippsSqr_32f_I(Psingle(@vecSum2[0]),nbpt);
     ippsAdd_32f_I(Psingle(@vecSum2[0]),Psingle(@vecSum1[0]),nbpt);           { vecSum1 = (Sx)² + (Sy)² }
     ippsMulC_32f_I(1/nbvec,Psingle(@vecSum1[0]),nbpt);                       { vecSum1 = ((Sx)² + (Sy)²)/N }

     ippsAdd_32f_I(Psingle(@vecSumSqr2[0]),Psingle(@vecSumSqr1[0]),nbpt);     { Sx2 + Sy2 }
     ippssub_32f_I(Psingle(@vecSum1[0]),Psingle(@vecSumSqr1[0]),nbpt);        { ((Sx)² + (Sy)²)/N  - (Sx2+Sy2) }
     ippsabs_32f_I(Psingle(@vecSumSqr1[0]),nbpt);                             { rendre le résultat positif à coup sûr }
     ippsMulC_32f_I(1/(nbvec-1),Psingle(@vecSumSqr1[0]),nbpt);                { sigma² =  (((Sx)² + (Sy)²)/N  - (Sx2+Sy2)) /(N-1)   }
     ippsSqrt_32f_I(Psingle(@vecSumSqr1[0]),nbpt);                            { sigma }


     ippsMulC_32f_I(1/nbvec,Psingle(@vecSum1[0]),nbpt);                       { vecSum1 = ((Sx)² + (Sy)²)/(N*N)  }
     ippsSqrt_32f_I(Psingle(@vecSum1[0]),nbpt);                               { vecSum1 = sqrt(((Sx)² + (Sy)²)/(N*N)) =  moy}
     ippsMulC_32f_I(1/Nbvec, Psingle(@vecSumMod[0]),nbpt);                    { moyenne des modules }

     for k:=0 to nbpt-1 do
     begin
        with SNRmat do
        if vecSumSqr1[k]>epsilon
          then Zvalue[Istart+k,Jstart+i]:= vecSum1[k]/vecSumSqr1[k]     { SNRmat contient le rapport  module du vecteur résultant moyen/ sigma }
          else Zvalue[k,i]:= zero;

        with MatModulus do Zvalue[Istart+k,Jstart+i] := vecSum1[k];     { MatModulus  contient le module du vecteur résultant moyen }
        with MatSigma do Zvalue[Istart+k,Jstart+i] := vecSumSqr1[k];    { MatSigma contient la standard deviation du module }

        if assigned(MatModulusMoy) then
        with MatModulusMoy do Zvalue[Istart+k,Jstart+i] := vecSumMod[k];         { MatModulusMoy contient la moyenne des modules }

        if Fphase then
        begin
          with MatPhase do Zvalue[Istart+k,Jstart+i] := vecTemp3[k];
          with MatPhaseSigma do Zvalue[Istart+k,Jstart+i] := 1-vecTemp4[k];
        end;
     end;
  end;

  IPPSend;
end;


(*
procedure SNRanalysisS(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma,MatModulusMoy:TMatrix;zero:float);
var
  i,j,k:integer;
  vecs:array of array of single;
  vecFil1,vecFil2: array of single;

  vecSum1,vecSum2,vecSumSqr1,vecSumSqr2,vecSumMod:array of single;
  vecTemp1,vecTemp2:array of single;

  Nbvec,Nbpt,nbfq,nbptFil:integer;
  ind0:integer;
begin

  IPPStest;

  nbfq:=tabFil.count;
  if nbfq<1 then sortieErreur('SNRanalysis : not enough frequencies');

  with Vlist do
  begin
    if count<2 then sortieErreur('SNRanalysis : not enough data vectors');
    Nbvec:=count;
    Nbpt:=vectors[1].Icount;
    setLength(vecs,nbvec,nbpt);

    for i:=0 to count-1 do
    with vectors[i+1] do
    begin
      if Icount<>nbpt then sortieErreur('SNRanalysis : data vectors must have the same length');
      for j:=Istart to Iend do
        vecs[i,j-Istart]:=Yvalue[j];
    end;
  end;

  with SNRmat do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  with MatModulus do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  with MatSigma do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  with MatModulusMoy do
  if (Icount<nbpt) or (Jcount<nbfq)
    then initTemp(Istart,Istart+nbpt-1,Jstart,Jstart+nbfq-1,tpNum);

  setLength(vecSum1,nbpt);
  setLength(vecSum2,nbpt);
  setLength(vecSumSqr1,nbpt);
  setLength(vecSumSqr2,nbpt);
  setLength(vecSumMod,nbpt);

  for i:=0 to nbfq-1 do
    begin
     ippsZero(Psingle(@vecSum1[0]),nbpt);
     ippsZero(Psingle(@vecSum2[0]),nbpt);
     ippsZero(Psingle(@vecSumSqr1[0]),nbpt);
     ippsZero(Psingle(@vecSumSqr2[0]),nbpt);
     ippsZero(Psingle(@vecSumMod[0]),nbpt);


     with tabFil.vectors[i+1] do
     begin
       setLength(vecFil1,Icount);
       setLength(vecFil2,Icount);
       for j:=Istart to Iend do
       begin
         vecFil1[j-Istart]:=Yvalue[j];
         vecFil2[j-Istart]:=Imvalue[j];
       end;
       setLength(vecTemp1,nbpt+Icount);
       setLength(vecTemp2,nbpt+Icount);

       nbptFil:=Icount;
       ind0:=-Istart;
     end;

     for j:=0 to nbVec-1 do
       begin
         ippsConv(Psingle(@vecs[j,0]),nbpt,Psingle(@vecFil1[0]),nbptFil,Psingle(@vecTemp1[0]));
         ippsAdd(Psingle(@vecTemp1[ind0]),Psingle(@vecSum1[0]),nbpt);
         ippsSqr(Psingle(@vecTemp1[ind0]),nbpt);
         ippsAdd(Psingle(@vecTemp1[ind0]),Psingle(@vecSumSqr1[0]),nbpt);

         ippsConv(Psingle(@vecs[j,0]),nbpt,Psingle(@vecFil2[0]),nbptFil,Psingle(@vecTemp2[0]));
         ippsAdd(Psingle(@vecTemp2[ind0]),Psingle(@vecSum2[0]),nbpt);
         ippsSqr(Psingle(@vecTemp2[ind0]),nbpt);
         ippsAdd(Psingle(@vecTemp2[ind0]),Psingle(@vecSumSqr2[0]),nbpt);

         ippsAdd(Psingle(@vecTemp2[ind0]),Psingle(@vecTemp1[ind0]),nbpt);
         ippsSqrt(Psingle(@vecTemp1[ind0]),nbpt);
         ippsAdd(Psingle(@vecTemp1[ind0]),Psingle(@vecSumMod[0]),nbpt);
      end;

     ippsSqr(Psingle(@vecSum1[0]),nbpt);
     ippsSqr(Psingle(@vecSum2[0]),nbpt);
     ippsAdd(Psingle(@vecSum2[0]),Psingle(@vecSum1[0]),nbpt);           { (Sx1)² + (Sx2)² }
     ippsMulC(1/nbvec,Psingle(@vecSum1[0]),nbpt);                       { id/N }

     ippsAdd(Psingle(@vecSumSqr2[0]),Psingle(@vecSumSqr1[0]),nbpt);     { Ssqrx1 + Ssqrx2 }
     ippssub(Psingle(@vecSum1[0]),Psingle(@vecSumSqr1[0]),nbpt);        { Ssqrx1 + Ssqrx2 }
     ippsMulC(1/(nbvec-1),Psingle(@vecSumSqr1[0]),nbpt);
     ippsSqrt(Psingle(@vecSumSqr1[0]),nbpt);                            {sigma}


     ippsMulC(1/nbvec,Psingle(@vecSum1[0]),nbpt);                       {  }
     ippsSqrt(Psingle(@vecSum1[0]),nbpt);                               {moy}
     ippsMulC(1/Nbvec, Psingle(@vecSumMod[0]),nbpt);                    {moyenne des modules}

     for k:=0 to nbpt-1 do
        begin
          with SNRmat do
          if vecSumSqr1[k]<>0
            then Zvalue[Istart+k,Jstart+i]:= vecSum1[k]/vecSumSqr1[k]
            else Zvalue[Istart+k,Jstart+i]:= zero;

          with MatModulus do Zvalue[Istart+k,Jstart+i] := vecSum1[k];
          with MatSigma do Zvalue[Istart+k,Jstart+i] := vecSumSqr1[k];
          if assigned(MatModulusMoy) then
          with MatModulusMoy do Zvalue[Istart+k,Jstart+i] := vecSumMod[k];
        end;
    end;

  IPPSend;
end;
*)

{********************************************************************************************************}

procedure proSNRanalysis(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma:TMatrix;zero:float);
var
  Mdum:Tmatrix;
begin
  verifierObjet(typeUO(Vlist));
  verifierObjet(typeUO(TabFil));
  verifierObjet(typeUO(SNRmat));
  verifierObjet(typeUO(MatModulus));
  verifierObjet(typeUO(MatSigma));

  Mdum:=nil;
  SNRanalysisD(Vlist,TabFil,SNRmat, MatModulus, MatSigma, Mdum,Mdum,Mdum,zero);
end;

procedure proSNRanalysis_1(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma:TMatrix;zero:float;SinglePrecision:boolean);
var
  Mdum:Tmatrix;
begin
  verifierObjet(typeUO(Vlist));
  verifierObjet(typeUO(TabFil));
  verifierObjet(typeUO(SNRmat));
  verifierObjet(typeUO(MatModulus));
  verifierObjet(typeUO(MatSigma));

  Mdum:=nil;

  if SinglePrecision
    then SNRanalysisS( Vlist,TabFil, SNRmat, MatModulus, MatSigma,Mdum,Mdum,Mdum,zero )
    else SNRanalysisD(Vlist,TabFil, SNRmat, MatModulus, MatSigma, Mdum,Mdum,Mdum,zero);
end;


procedure proSNRanalysis_2(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma, MatModulusMoy:TMatrix;zero:float);
var
  Mdum:Tmatrix;
begin
  verifierObjet(typeUO(Vlist));
  verifierObjet(typeUO(TabFil));
  verifierObjet(typeUO(SNRmat));
  verifierObjet(typeUO(MatModulus));
  verifierObjet(typeUO(MatSigma));
  verifierObjet(typeUO(MatModulusMoy));

  Mdum:=nil;
  SNRanalysisD(Vlist,TabFil,SNRmat, MatModulus, MatSigma, MatModulusMoy,Mdum,Mdum,zero);
end;


procedure proSNRanalysis_3(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma,MatModulusMoy:TMatrix;zero:float;SinglePrecision:boolean);
var
  Mdum:Tmatrix;
begin
  verifierObjet(typeUO(Vlist));
  verifierObjet(typeUO(TabFil));
  verifierObjet(typeUO(SNRmat));
  verifierObjet(typeUO(MatModulus));
  verifierObjet(typeUO(MatSigma));
  verifierObjet(typeUO(MatModulusMoy));

  Mdum:=nil;
  if SinglePrecision
    then SNRanalysisS(Vlist,TabFil, SNRmat, MatModulus, MatSigma, MatModulusMoy,Mdum,Mdum, zero)
    else SNRanalysisD(Vlist,TabFil, SNRmat, MatModulus, MatSigma, MatModulusMoy,Mdum,Mdum, zero);
end;


procedure proSNRanalysis_4(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma, MatModulusMoy,MatPhase,MatPhaseSigma:TMatrix;zero:float);
begin
  verifierObjet(typeUO(Vlist));
  verifierObjet(typeUO(TabFil));
  verifierObjet(typeUO(SNRmat));
  verifierObjet(typeUO(MatModulus));
  verifierObjet(typeUO(MatSigma));
  // on accepte MatModulusMoy,MatPhase ou MatPhaseSigma =nil

  SNRanalysisD(Vlist,TabFil, SNRmat, MatModulus, MatSigma, MatModulusMoy,MatPhase,MatPhaseSigma, zero);
end;


procedure proSNRanalysis_5(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma,MatModulusMoy,MatPhase,MatPhaseSigma:TMatrix;zero:float;SinglePrecision:boolean);
begin
  verifierObjet(typeUO(Vlist));
  verifierObjet(typeUO(TabFil));
  verifierObjet(typeUO(SNRmat));
  verifierObjet(typeUO(MatModulus));
  verifierObjet(typeUO(MatSigma));
  // on accepte MatModulusMoy,MatPhase ou MatPhaseSigma =nil

  if SinglePrecision
    then SNRanalysisS(Vlist,TabFil, SNRmat, MatModulus, MatSigma, MatModulusMoy,MatPhase,MatPhaseSigma, zero)
    else SNRanalysisD(Vlist,TabFil, SNRmat, MatModulus, MatSigma, MatModulusMoy,MatPhase,MatPhaseSigma, zero);
end;



// versions obsolètes
procedure proSNRanalysis2(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma, MatModulusMoy:TMatrix;zero:float);
begin
  proSNRanalysis_2( Vlist,TabFil, SNRmat, MatModulus, MatSigma, MatModulusMoy, zero);
end;

procedure proSNRanalysis2_1(var Vlist,TabFil:TVlist;var SNRmat, MatModulus, MatSigma,MatModulusMoy:TMatrix;zero:float;SinglePrecision:boolean);
begin
  proSNRanalysis_3(Vlist, TabFil, SNRmat, MatModulus, MatSigma,MatModulusMoy, zero, SinglePrecision);
end;


procedure KStest(var Vlist1, Vlist2: TVlist; var vecD, VecP: Tvector);
var
  N1, N2: integer;
  i,j:integer;
  I1,I2:integer;
begin
  verifierObjet(typeUO(Vlist1));
  verifierObjet(typeUO(Vlist2));
  verifierVecteurTemp(vecD);
  verifierVecteurTemp(vecP);

  N1:=Vlist1.count;
  N2:=Vlist2.count;
  if (N1<2) then sortieErreur('KStest : not enough vectors in Vlist1');
  if (N2<2) then sortieErreur('KStest : not enough vectors in Vlist2');

  I1:=Vlist1[1].Istart;
  I2:=Vlist1[1].Iend;

  for i:= 1 to N1 do
    if (Vlist1[i].Istart<>I1) or (Vlist1[i].Iend<>I2)
      then sortieErreur('KStest : vectors have different Istart/Iend properties');

  for i:= 1 to N2 do
    if (Vlist2[i].Istart<>I1) or (Vlist2[i].Iend<>I2)
      then sortieErreur('KStest : vectors have different Istart/Iend properties');

  vecD.modify(g_single,I1,I2);
  vecP.modify(g_single,I1,I2);

end;


end.
