program stm32;

uses
  Forms,
  DirectD0 in 'DirectD0.pas',
  syspal32 in 'syspal32.pas' {saisiePal32},
  BitmapEx in 'BitmapEx.pas',
  Mstm in 'Mstm.pas' {MainStm},
  Acqopen1 in 'Acqopen1.pas' {AcqOpenFile},
  Acqpar1 in 'Acqpar1.pas' {AcqParam},
  Getmat0 in 'Getmat0.pas' {getMatrix},
  Iniarr0 in 'Iniarr0.pas' {initTvectorArray},
  Inimat0 in 'Inimat0.pas' {initTmatrix},
  Inimulg0 in 'Inimulg0.pas' {initTmultigraph},
  Inspobj2 in 'inspObj2.pas' {InspectForm},
  Multg1 in 'Multg1.pas',
  Objname1 in 'Objname1.pas' {GetObjName},
  Optacq in 'Optacq.pas' {AcqOpt1},
  Dureepro in 'Dureepro.pas' {HisDuree},
  Stmsys in 'Stmsys.pas' {SysDialog},
  Trackcol in 'trackCol.pas' {getTrackColor},
  Matcood0 in 'Matcood0.pas' {MatCooD},
  Defform in 'defForm.pas' {DefaultForm},
  stimForm in 'stimForm.pas' {StimulusForm},
  geton0 in 'geton0.pas' {getOnOff1},
  Getdeg0 in 'Getdeg0.pas' {Degform},
  getrev1 in 'getrev1.pas' {getRevCor1},
  selrf1 in 'selrf1.pas' {FormSelectRF},
  DinputGS in 'dinputGS.pas',
  ExeOpt1 in 'ExeOpt1.pas' {ExecuteOptions},
  Zorder in 'Zorder.pas' {getZorder},
  actifstm in 'actifstm.pas' {getActiveStim},
  getPhasT in 'getPhasT.pas' {getPhaseTrans},
  getTr2 in 'getTr2.pas' {getTranslation2},
  iniRA0 in 'iniRA0.pas' {initRealArray},
  stmdf0 in 'stmdf0.pas',
  tdff0 in 'tdff0.pas' {dataFileForm},
  opVec1 in 'opVec1.pas' {OptionsVec1},
  opmulti1 in 'opMulti1.pas' {OptionsMultg1},
  Cood0 in 'cood0.pas' {CooD},
  Dtbedit1 in 'DtbEdit1.pas' {ArrayEditor},
  stmData0 in 'stmData0.pas',
  RArray1 in 'RArray1.pas',
  Inivect0 in 'Inivect0.pas' {initTvector},
  Getcoln in 'getColN.pas' {SaisieColParam},
  Savess in 'saveSS.pas' {SaveArray},
  Nbligne1 in 'nbLigne1.pas' {NumOfLines},
  Fcontrol in 'Fcontrol.pas' {FormControl},
  printMG0 in 'printMG0.pas' {PrintDlg},
  Tagbloc1 in 'tagBloc1.pas' {tagBlock},
  Formmenu in 'formMenu.pas' {MenuForm},
  Multg0 in 'multg0.pas' {MultiGform},
  mstm1 in 'mstm1.pas' {mainStm1};

{$R *.RES}

begin
  Application.CreateForm(TmainStm1, mainStm1);
  Application.CreateForm(TAcqOpenFile, AcqOpenFile);
  Application.CreateForm(TsaisiePal32, saisiePal32);
  Application.CreateForm(TAcqParam, AcqParam);
  Application.CreateForm(TinitTvectorArray, initTvectorArray);
  Application.CreateForm(TinitTmatrix, initTmatrix);
  Application.CreateForm(TinitTmultigraph, initTmultigraph);
  Application.CreateForm(TGetObjName, GetObjName);
  Application.CreateForm(TAcqOpt1, AcqOpt1);
  Application.CreateForm(THisDuree, HisDuree);
  Application.CreateForm(TSysDialog, SysDialog);
  Application.CreateForm(TgetTrackColor, getTrackColor);
  Application.CreateForm(TMatCooD, MatCooD);
  Application.CreateForm(TDefaultForm, DefaultForm);
  Application.CreateForm(TStimulusForm, StimulusForm);
  Application.CreateForm(TgetOnOff1, getOnOff1);
  Application.CreateForm(TgetRevCor1, getRevCor1);
  Application.CreateForm(TFormSelectRF, FormSelectRF);
  Application.CreateForm(TExecuteOptions, ExecuteOptions);
  Application.CreateForm(TgetZorder, getZorder);
  Application.CreateForm(TgetActiveStim, getActiveStim);
  Application.CreateForm(TgetPhaseTrans, getPhaseTrans);
  Application.CreateForm(TgetTranslation2, getTranslation2);
  Application.CreateForm(TinitRealArray, initRealArray);
  Application.CreateForm(TdataFileForm, dataFileForm);
  Application.CreateForm(TOptionsVec1, OptionsVec1);
  Application.CreateForm(TOptionsMultg1, OptionsMultg1);
  Application.CreateForm(TCooD, CooD);
  Application.CreateForm(TinitTvector, initTvector);
  Application.CreateForm(TSaisieColParam, SaisieColParam);
  Application.CreateForm(TSaveArray, SaveArray);
  Application.CreateForm(TNumOfLines, NumOfLines);
  Application.CreateForm(TPrintMgDialog, PrintMgDialog);
  Application.CreateForm(TtagBlock, tagBlock);
  Application.CreateForm(TMenuForm, MenuForm);
  Application.CreateForm(TMultiGform, MultiGform);
  Application.Run;
end.
