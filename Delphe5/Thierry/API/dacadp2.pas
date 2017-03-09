unit dacadp2;

INTERFACE

uses util1,Gdos,
     NcDef2,adproc2,procac2;



var
  tabProc2:TtabDefProc;
  adresseProcedure:TtabAdresse;

procedure initAdressesProcedure(nb:Integer;var err:Integer);

IMPLEMENTATION

uses DacSys,

     standac1,txtac1,binac1,message2,
     stmDef,stmObj,
     stmU1,
     stmData0,stmPlot1, stmUplot,stmDplot, stmDobj1,
     stmVec1,stmPsth1,stmMat1,stmOdat2,
     stmJP,
     multG1,
     stmGraph,stmAc1,
     stmDf0,
     DrcSeq1,
     stmexe10,
     stmExe11,
     stmExeAc,
     stmExeFi,
     stmFpg,stmFevt,
     Rarray1,
     stmFunc1,
     stmFit1,
     stmDlg,
     stmcor1,
     stmCurs,
     stmAlpha2,
     revcor2,
     stmwav1,
     stmDet1,
     stmVlist0,
     stmSyncC,
     stmAve1,
     Dac2file,
     {$IFDEF AcqElphy2}
     StimInf2,
     {$ELSE}
     dacMStim,
     {$ENDIF}
     wacq1,
     stmVzoom,
     stmFFT,
     stmAveA1,
     Mtag2,
     stmUpal0,
     stmFont1,
     stmMemo1,
     stmGraph2,
     stmCplot1,
     stmPstA1,
     stmCorA1,
     stmMatA1,
     stmAvi1,
     stmPlotF,
     objFile1,
     stmPg,
     stmMf1,
     stmMfit1,

     stmVS0,
     stmObv0,
     stmstmX0,
     stmMvtX1,
     gratDX1,
     PhaseTR1,
     stmline0,

     filter1,
     stmMseq0,
     stmDN2,
     stmClist1,
     stmSymbs1,

     VlistA1,
     stmCpx1,
     stmIspl1,
     BinFile1,

     stmD3Dview1,stmSphere1,stmMat3D1,stmCube1,

     stmVecU1,
     stmVSBM1,stmTrajectory1,stmGrid2,

     stmGaborDense1, { Fichier Olivier Marre juin 2003  remplacé par ma version janvier 2004}
     stmWT1,
     stmMatU1,
     stmVSmovie,

     stmMaxTim,    { Fichiers Rodophe Héliot juillet 2003 }
     stmRecuit,
     stmrecuitObj,
     stmRtime1,

     stmRev1,stmDNter1,
     stmMlist,
     stmImaging,
     stmLqr0,
     stmAuxInt1,
     IPPmat1,
     stmKLmat,
     stmEntropy1,
     stmChk0,
     stmChkXY,
     stmChkXY1,
     stmGaborSparse1,

     stmMatAve1,
     stmVecMatLab,
     optiFit1,
     stmVecU2,
     optifit2,
     optifit3,
     stmOpti1,
     geometry1,
     stmMultiRev1,
     oiBlock1,
     stmOiSeq1,
     stmRegion1,

     DipTest1,
     stmMCC,
     stmBMP1,
     stmBMplot1,

     stmDataBase2,
     stmStatus1,
     stmTCPIP1,

     OIutils1,stmOIave1,
     DBrecord1,
     stmIntegrator1,stmDetector1,stmOnlineStat1,
     stmPython1,

     {$IFDEF AcqElphy2}RTneuronBrd,{$ENDIF}
     SimpleODE,
     stmNrnServer,
     stmDBgrid1,
     VSgraph0,

     stmArrowPlot1,
     MyUnit,
     DBModels,
     DBObjects,
     DBQuerySets,
     DBManagers,
     DBShortcuts,
     DBUnic;



{$I DAC2ii.adr}
{$I Dacver.pas}

const
{$IFDEF AcqElphy2}

  nomPRC0='DAC2II.PRC';
{$ELSE}
  
  nomPRC0='DAC2.PRC';
{$ENDIF}

procedure initPRC;
var
  error:integer;
begin
  tabProc2:=TtabDefProc.create;
  tabProc2.charger( AppDir +nomPrc0);
  if tabProc2.nbprc=0 then
    begin
      messageCentral('Unable to load '+nomPrc0);
      tabProc2.free;
      tabProc2:=nil;
      halt;
    end;

  if DacVersion<>tabProc2.version then
    begin
      messageCentral('PRC version mismatch');
      tabProc2.free;
      tabProc2:=nil;
      halt;
    end;

  adresseProcedure:=TtabAdresse.create;
  initAdressesProcedure(tabProc2.nbPrc+1,error);
  if error<>0 then messageCentral('Error init PRC');

  NumTransType:=tabProc2.nbPrc+1;                        { ajouter une fonction spéciale transtypage }
  AdresseProcedure.empile(@FonctionTransType);
end;

initialization

initPRC;

end.
