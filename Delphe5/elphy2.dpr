program Elphy2;



uses
  Forms,
  mdac in 'mdac.pas',
  EditScroll1 in 'EditScroll1.pas' {EditScroll: TFrame},
  ColorFrame1 in 'ColorFrame1.pas' {ColFrame: TFrame},
  DisplayUOFrame1 in 'DisplayUOFrame1.pas' {UODisplay: TFrame},
  DisplayFrame1 in 'DisplayFrame1.pas' {DispFrame: TFrame},
  TPform0 in 'TPform0.pas' {Pform},
  FrameTable1 in 'FrameTable1.pas' {TableFrame: TFrame},
  FuncProp in 'FuncProp.pas' {FunctionProp},
  Getdeg0 in 'Getdeg0.pas' {Degform},
  Defform in 'defForm.pas' {GenForm},
  stimForm in 'stimForm.pas' {stimulusForm},
  Multg0 in 'multg0.pas' {MultiGform},
  Dtbedit1 in 'DtbEdit1.pas' {ArrayEditor},
  Detform1 in 'Detform1.pas' {DetPanel},
  colorPan1 in 'colorPan1.pas' {colorPan: TFrame},
  DUlex5 in 'DUlex5.pas',
  cyberKsimBrd1 in 'cyberKsimBrd1.pas',
  MemManager1 in 'MemManager1.pas',
  DD1322brd in 'DD1322brd.pas',
  DBtable1 in 'DBtable1.pas',
  stmNI in 'stmNI.pas',
  TextFile1 in 'TextFile1.pas',
  regEditOptions in 'regEditOptions.pas' {RegOptions},
  DateForm1 in 'DateForm1.pas' {GetDateForm},
  FrameDate1 in 'FrameDate1.pas' {Frame1: TFrame},
  PCL0 in 'PCL0.pas',
  GLprintDlg in 'GLprintDlg.pas' {GlprintForm},
  VSSyncPrm in 'VSSyncPrm.pas' {GetVSsyncParam},
  ErrorForm1 in 'ErrorForm1.pas' {ErrorForm},
  stmBMcorrection1 in 'stmBMcorrection1.pas' {BMcorrection},
  CreateAVI1 in 'CreateAVI1.pas' {CreateAVIform},
  SerialCom1 in 'SerialCom1.pas',
  QueryString1 in 'QueryString1.pas' {QueryString},
  ElphyEpisode1 in 'ElphyEpisode1.pas',
  NrnDll1 in 'NrnDll1.pas',
  RTdef0 in 'RTdef0.pas',
  SimRTneuronBrd in 'SimRTneuronBrd.pas',
  Triangulation1 in 'Triangulation1.pas',
  Cuda1 in 'Cuda1.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainDac, MainDac);
  Application.Run;
end.

