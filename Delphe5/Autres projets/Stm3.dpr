program stm3;

uses
  Forms,
  descStm in 'descStm.pas',
  Multg1 in 'multg1.pas',
  Multg0 in 'multg0.pas' {MultiGform},
  mdac in 'mdac.pas' {MainDac},
  mstm3 in 'mstm3.pas' {MainStm3},
  printMG0 in 'printMG0.pas' {printMgDialog},
  opmulti1 in 'opMulti1.pas' {OptionsMultg1},
  Cood0 in 'cood0.pas' {CooD},
  opVec1 in 'opVec1.pas' {OptionsVec1},
  getEp0 in 'getEp0.pas' {ChooseEp},
  Objname1 in 'Objname1.pas' {GetObjName},
  Inivect0 in 'Inivect0.pas' {initTvector},
  Inimat0 in 'Inimat0.pas' {initTmatrix},
  iniRA0 in 'iniRA0.pas' {initRealArray},
  Inimulg0 in 'Inimulg0.pas' {initTmultigraph},
  Tagbloc1 in 'Tagbloc1.pas' {tagBlock},
  Getcoln in 'getColN.pas' {SaisieColParam},
  inigra0 in 'inigra0.pas' {initGraph},
  Nbligne1 in 'nbLigne1.pas' {NumOfLines},
  CurProp1 in 'CurProp1.pas' {CursorProp},
  Matcood0 in 'Matcood0.pas' {MatCooD},
  Colsat1 in 'colSat1.pas' {StmColSat},
  mg0Label in 'mg0Label.pas' {Multg0Labels},
  syslist0 in 'syslist0.pas' {Wsyslist},
  FuncProp in 'FuncProp.pas' {FunctionProp},
  fitProp in 'fitProp.pas' {FitProp1},
  ComExOpt in 'ComExOpt.pas' {CommandBoxOption},
  Formmenu in 'formMenu.pas' {MenuForm},
  syspal32 in 'syspal32.pas' {saisiePal32},
  ExeOpt1 in 'ExeOpt1.pas' {ExecuteOptions},
  Optacq in 'optAcq.pas' {AcqOpt1},
  Acqpar1 in 'acqPar1.pas' {AcqParam},
  Trackcol in 'trackCol.pas' {getTrackColor},
  Stmsys in 'stmSys.pas' {SysDialog},
  Dureepro in 'DureePro.pas' {HisDuree},
  Acqopen1 in 'AcqOpen1.pas' {AcqOpenFile},
  stmMseq0 in 'stmMseq0.pas',
  Defform in 'defForm.pas' {DefaultForm},
  getMseq1 in 'getMseq1.pas' {getMseq},
  selrf1 in 'selRF1.pas' {FormSelectRF},
  actifstm in 'actifstm.pas' {getActiveStim},
  geton0 in 'getOn0.pas' {getOnOff1},
  getTr2 in 'getTr2.pas' {getTranslation2},
  stmGrid0 in 'stmGrid0.pas',
  sysmask0 in 'sysmask0.pas',
  Zorder in 'Zorder.pas' {getZorder},
  Getdeg0 in 'Getdeg0.pas' {Degform},
  stmDlg in 'stmDlg.pas',
  FormDlg1 in 'FormDlg1.pas' {DlgForm1},
  getPhasT in 'getPhasT.pas' {getPhaseTrans},
  stimForm in 'stimForm.pas' {stimulusForm},
  stmMark0 in 'stmMark0.pas',
  getMark0 in 'getMark0.pas' {MarkForm},
  getGab1 in 'getGab1.pas' {getGabor1},
  Efind1 in 'Efind1.pas' {GEditFind},
  Ereplace in 'Ereplace.pas' {GEditReplace},
  evalvar1 in 'evalvar1.pas' {InspectVar},
  stmPopUp in 'stmPopUp.pas' {PopUps},
  MemoForm in 'MemoForm.pas' {ViewText},
  stmcooX1 in 'stmCooX1.pas' {FastCoo},
  ProcFile in 'ProcFile.pas' {ProcessFileForm},
  diviwin in 'diviwin.pas' {DivideWin};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainStm3, MainStm3);
  Application.CreateForm(TprintMgDialog, printMgDialog);
  Application.CreateForm(TOptionsMultg1, OptionsMultg1);
  Application.CreateForm(TCooD, CooD);
  Application.CreateForm(TOptionsVec1, OptionsVec1);
  Application.CreateForm(TChooseEp, ChooseEp);
  Application.CreateForm(TGetObjName, GetObjName);
  Application.CreateForm(TinitTvector, initTvector);
  Application.CreateForm(TinitTmatrix, initTmatrix);
  Application.CreateForm(TinitRealArray, initRealArray);
  Application.CreateForm(TinitTmultigraph, initTmultigraph);
  Application.CreateForm(TtagBlock, tagBlock);
  Application.CreateForm(TSaisieColParam, SaisieColParam);
  Application.CreateForm(TinitGraph, initGraph);
  Application.CreateForm(TNumOfLines, NumOfLines);
  Application.CreateForm(TCursorProp, CursorProp);
  Application.CreateForm(TMatCooD, MatCooD);
  Application.CreateForm(TStmColSat, StmColSat);
  Application.CreateForm(TMultg0Labels, Multg0Labels);
  Application.CreateForm(TWsyslist, Wsyslist);
  Application.CreateForm(TFunctionProp, FunctionProp);
  Application.CreateForm(TFitProp1, FitProp1);
  Application.CreateForm(TCommandBoxOption, CommandBoxOption);
  Application.CreateForm(TMenuForm, MenuForm);
  Application.CreateForm(TsaisiePal32, saisiePal32);
  Application.CreateForm(TExecuteOptions, ExecuteOptions);
  Application.CreateForm(TAcqOpt1, AcqOpt1);
  Application.CreateForm(TAcqParam, AcqParam);
  Application.CreateForm(TgetTrackColor, getTrackColor);
  Application.CreateForm(TSysDialog, SysDialog);
  Application.CreateForm(THisDuree, HisDuree);
  Application.CreateForm(TAcqOpenFile, AcqOpenFile);
  Application.CreateForm(TFormSelectRF, FormSelectRF);
  Application.CreateForm(TgetActiveStim, getActiveStim);
  Application.CreateForm(TgetOnOff1, getOnOff1);
  Application.CreateForm(TgetTranslation2, getTranslation2);
  Application.CreateForm(TgetZorder, getZorder);
  Application.CreateForm(TgetPhaseTrans, getPhaseTrans);
  Application.CreateForm(TstimulusForm, stimulusForm);
  Application.CreateForm(TMarkForm, MarkForm);
  Application.CreateForm(TgetGabor1, getGabor1);
  Application.CreateForm(TGEditFind, GEditFind);
  Application.CreateForm(TGEditReplace, GEditReplace);
  Application.CreateForm(TInspectVar, InspectVar);
  Application.CreateForm(TPopUps, PopUps);
  Application.CreateForm(TViewText, ViewText);
  Application.CreateForm(TFastCoo, FastCoo);
  Application.CreateForm(TProcessFileForm, ProcessFileForm);
  Application.CreateForm(TDivideWin, DivideWin);
  Application.Run;
end.
