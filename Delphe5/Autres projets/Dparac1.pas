unit Dparac1;

interface
{$O-}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, ComCtrls, Grids, ExtCtrls,

  util1,Dutil1,Ddosfich,
  {$IFDEF AcqElphy2}acqDef2  {$ELSE}acqDef1 {$ENDIF}
  ,acqBuf1,
  acqBrd1,
  stmObj,procfile, chooseOb,stmDplot ;

type
  TparamAcq = class(TForm)
    Bok: TButton;
    Bcancel: TButton;
    PageControl1: TPageControl;
    TabSgeneral: TTabSheet;
    GroupBox4: TGroupBox;
    Label19: TLabel;
    Lnbvoie: TLabel;
    Lduree: TLabel;
    Lperiod: TLabel;
    Lnbpt: TLabel;
    Lnbav: TLabel;
    cbModeAcq: TcomboBoxV;
    enNbvoie: TeditNum;
    enDuree: TeditNum;
    enPeriod: TeditNum;
    enNbpt: TeditNum;
    enNbAv: TeditNum;
    TabStrigger: TTabSheet;
    GroupBox5: TGroupBox;
    Label25: TLabel;
    LvoieSync: TLabel;
    LseuilHaut: TLabel;
    LseuilBas: TLabel;
    LtestInt: TLabel;
    cbModeTrig: TcomboBoxV;
    enVoieSync: TeditNum;
    enSeuilHaut: TeditNum;
    enSeuilBas: TeditNum;
    enTestInt: TeditNum;
    TabSChannels: TTabSheet;
    TabNumC: TTabControl;
    GroupBox6: TGroupBox;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    enJ1: TeditNum;
    enY1: TeditNum;
    enJ2: TeditNum;
    enY2: TeditNum;
    esUnits: TeditString;
    Label31: TLabel;
    enVoiePhys: TeditNum;
    LabelRange: TLabel;
    cbGain: TcomboBoxV;
    TabSfiles: TTabSheet;
    TabSprocess: TTabSheet;
    GroupBox1: TGroupBox;
    cbGenAcq: TComboBox;
    Bbrowse: TButton;
    cbValidate: TCheckBoxV;
    cbClearEntireFile: TCheckBoxV;
    GroupBox2: TGroupBox;
    cbProcess: TCheckBoxV;
    GroupBox3: TGroupBox;
    lbClear: TListBox;
    BaddClear: TButton;
    BremoveClear: TButton;
    TabSDisplay: TTabSheet;
    cbDisplay: TCheckBoxV;
    GroupBox8: TGroupBox;
    lbRefresh: TListBox;
    BaddRefresh: TButton;
    BremoveRefresh: TButton;
    cbImmediate: TCheckBoxV;
    cbHold: TCheckBoxV;
    cbCycled: TCheckBoxV;
    cbStim: TCheckBoxV;
    LepCount: TLabel;
    enEpCount: TeditNum;
    Lmaxduration: TLabel;
    enMaxDuration: TeditNum;
    Label3: TLabel;
    enFileInfo: TeditNum;
    Label4: TLabel;
    enEpInfo: TeditNum;
    Label5: TLabel;
    enCommentSize: TeditNum;
    TabSheet1: TTabSheet;
    MemoComment: TMemo;
    Label6: TLabel;
    enDelay: TeditNum;
    GroupBox9: TGroupBox;
    Lfreq: TLabel;
    Lperiode: TLabel;
    Lduration: TLabel;
    Bcheck: TButton;
    Lpretrig: TLabel;
    Lwarning: TLabel;
    cbControlPanel: TCheckBoxV;
    cbTriggerPos: TCheckBoxV;
    Boptions: TButton;
    Label7: TLabel;
    enKS: TeditNum;
    Label8: TLabel;
    cbFileFormat: TcomboBoxV;
    Label9: TLabel;
    cbType: TcomboBoxV;
    cbSound: TCheckBoxV;
    EventPanel: TPanel;
    Label2: TLabel;
    enThreshold: TeditNum;
    Label12: TLabel;
    enHys: TeditNum;
    cbRising: TCheckBoxV;
    procedure cbModeAcqChange(Sender: TObject);
    procedure cbModeTrigChange(Sender: TObject);
    procedure TabNumCChange(Sender: TObject);
    procedure cbGenAcqEnter(Sender: TObject);
    procedure BbrowseClick(Sender: TObject);
    procedure BaddRefreshClick(Sender: TObject);
    procedure BremoveRefreshClick(Sender: TObject);
    procedure BaddClearClick(Sender: TObject);
    procedure BremoveClearClick(Sender: TObject);
    procedure BcheckClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BoptionsClick(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
  private
    { Déclarations privées }
    acqpar0:TacqRecord;
    AcqParF0:TacqRecordF;

    procedure setEnabledGen;
    procedure setEnabledTrig;
    procedure setEnableChannels;
    procedure updateChannels;

    procedure checkDurations;
  public
    { Déclarations publiques }

    function execution(var acqPar:TacqRecord;var AcqParF:TacqRecordF):boolean;
  end;

var
  paramAcq: TparamAcq;

implementation
{$R *.DFM}

procedure TparamAcq.setEnabledGen;
begin
  with acqPar0 do
  begin
    enDuree.enabled:=not continu;
    LDuree.enabled:=not continu;

    enPeriod.enabled:=continu;
    LPeriod.enabled:=continu;

    enMaxDuration.enabled:=continu;
    LmaxDuration.enabled:=continu;

    enNbpt.enabled:=not continu;
    Lnbpt.enabled:=not continu;

    enNbav.enabled:=not continu;
    Lnbav.enabled:=not continu;

    enEpCount.enabled:=not continu;
    LepCount.enabled:=not continu;

    cbSound.Enabled:=(DFformat=ElphyFormat1) and continu;
  end;
end;

procedure TparamAcq.setEnabledTrig;
var
  analog:boolean;
begin
  with acqPar0 do
  begin
    analog:=(modeSynchro=MSanalogAbs) or (modeSynchro=MSanalogDiff);

    enVoieSync.enabled:=analog;
    LvoieSync.enabled:=analog;

    enSeuilHaut.enabled:=analog;
    LseuilHaut.enabled:=analog;

    enSeuilBas.enabled:=analog;
    LseuilBas.enabled:=analog;

    enTestInt.enabled:=(modeSynchro=MSanalogDiff);
    LtestInt.enabled:=(modeSynchro=MSanalogDiff);

    enDelay.enabled:=(modeSynchro=MSinterne);
  end;
end;

procedure TparamAcq.setEnableChannels;
var
  Felphy:boolean;
  num:integer;
begin
  with acqPar0 do
  begin
    Felphy:=(acqPar0.DFformat=ElphyFormat1);

    enKS.enabled:=Felphy;
    cbType.enabled:=Felphy;
    enThreshold.enabled:=Felphy;
    enHys.enabled:=Felphy;
    cbRising.enabled:=Felphy;

    num:=tabNumC.tabIndex+1;
    EventPanel.Visible:=(ChannelType[num]=TI_AnaEvent);
  end;
end;

function getItemSt(st:string;num:integer):string;
var
  i,k:integer;
begin
  k:=0;
  while k<num do
  begin
    i:=pos('|',st);
    inc(k);
    if i>0
      then result:=copy(st,1,i-1)
      else result:=st;
    if (i=0) and (result='') then exit;
    delete(st,1,i);
  end;
end;

function nbItemSt(st:string):integer;
var
  i:integer;
begin
  result:=1;
  for i:=1 to length(st) do
    if st[i]='|' then inc(result);
end;

function addItemSt(st1,st:string):string;
var
  i:integer;
  stX,stM:string;

begin
  result:=st1;

  stM:=Fmaj(st1);

  for i:=1 to nbItemSt(st) do
    begin
      stX:=getItemSt(st,i);
      if Fmaj(stX)<>stM then result:=result+'|'+stX;
    end;
end;


function TparamAcq.execution(var acqPar:TacqRecord;var AcqParF:TacqRecordF):boolean;
var
  i:integer;
begin
  acqPar.controle;

  acqPar0:=acqPar;

  {Le compilateur delphi5 n'arrive pas à compiler acqParF0:=acqParF;  }
  acqParF0.stGenAcq:=acqParF.stGenAcq;
  acqParF0.stDat:=acqParF.stDat;
  acqParF0.stGenHis:=acqParF.stGenHis;

  with acqPar0 do
  begin

    cbModeAcq.setString('Episodes|Continuous');
    cbModeAcq.setvar(continu,T_byte,0);

    enEpCount.setvar(MaxEpCount,T_longint);
    enEpCount.setMinMax(0,maxEntierLong);

    enNbvoie.setvar(Qnbvoie,T_smallint);
    enNbvoie.setMinMax(0,16);

    enDuree.setvar(DureeSeqU,T_single);
    enDuree.setMinMax(0,1E7);

    enPeriod.setvar(PeriodeCont,T_single);
    enPeriod.setMinMax(0,1E7);

    enMaxDuration.setvar(MaxDuration,T_single);
    enMaxDuration.setMinMax(0,1E7);

    enNbpt.setvar(Qnbpt,T_longint);
    enNbpt.setMinMax(1,maxEntierLong);

    enNbAv.setvar(Qnbav,T_longint);
    enNbAv.setMinMax(0,maxEntierLong);

    cbStim.setvar(Fstim);
    cbSound.setvar(recSound);

    
    cbModeTrig.setString('Immediate|Keyboard|Analog absolute|Analog differential|'+
                         'Numerical (rising edge)|Numerical (falling edge)|Internal'
                        );
    cbModeTrig.setvar(modeSynchro,T_byte,0);

    enVoieSync.setvar(VoieSynchro,T_smallint);
    enVoieSync.setMinMax(1,Qnbvoie+1);

    enSeuilHaut.setvar(seuilPlus,T_single);
    enSeuilBas.setvar(seuilMoins,T_single);

    enTestInt.setvar(intervalTest,T_smallint);
    enTestInt.setMinMax(1,1000);

    cbProcess.setvar(Fprocess);



    cbDisplay.setvar(Fdisplay);
    cbImmediate.setvar(Fimmediate);
    cbHold.setvar(Fhold);
    cbCycled.setvar(Fcycled);


    with CBgenAcq,AcqParF do
    begin
      clear;
      for i:=1 to nbItemSt(stGenHis) do items.add(getItemSt(stGenHis,i));
      text:=stGenAcq;
    end;

    memoComment.text:=memoA.memo.text;

    cbValidate.setvar(FValidation);
    cbClearEntireFile.setvar(FeffaceTout);

    enFileInfo.setvar(FileInfoSize,T_longint);
    enFileInfo.setMinMax(0,1000000);

    enEpInfo.setvar(EpInfoSize,T_longint);
    enEpInfo.setMinMax(0,1000000);

    enCommentSize.setvar(MiniCommentSize,T_longint);
    enCommentSize.setMinMax(0,1000000);

    cbControlPanel.setVar(FcontrolPanel);
    cbTriggerPos.setVar(FtriggerPos);

    cbFileFormat.setString('Dac2|Elphy');
    cbFileFormat.setVar(DFformat,t_byte,0);


    updateChannels;

    setEnabledGen;
    setEnabledTrig;
    setEnableChannels;

    checkDurations;
  end;

  lbRefresh.clear;
  with ObjectsToRefresh do
  for i:=0 to count-1 do
    lbRefresh.items.addObject(typeUO(items[i]).ident,typeUO(items[i]));

  lbClear.clear;
  with ObjectsToClear do
  for i:=0 to count-1 do
    lbClear.items.addObject(typeUO(items[i]).ident,typeUO(items[i]));





  result:=(showModal=mrOK);
  if result then
    begin
      updateAllVar(self);
      acqPar:=acqpar0;

      with acqparF0 do
      begin
        stgenAcq:=cbGenAcq.text;
        stgenHis:=addItemSt(stGenAcq,stgenHis);
      end;

      acqParF.stGenAcq:=acqParF0.stGenAcq;
      acqParF.stDat:=acqParF0.stDat;
      acqParF.stGenHis:=acqParF0.stGenHis;
      memoA.memo.text:=memoComment.text;

      ObjectsToRefresh.clear;
      with lbRefresh do
      for i:=0 to items.count-1 do ObjectsToRefresh.add(items.objects[i]);

      ObjectsToClear.clear;
      with lbClear do
      for i:=0 to items.count-1 do ObjectsToClear.add(items.objects[i]);
    end;

end;

procedure TparamAcq.cbModeAcqChange(Sender: TObject);
begin
  updateAllVar(self);
  setEnabledGen;
  BcheckClick(sender);
end;

procedure TparamAcq.cbModeTrigChange(Sender: TObject);
begin
  cbModeTrig.updateVar;
  setEnabledTrig;
end;

procedure TparamAcq.updateChannels;
var
  num:integer;
begin
  with acqPar0 do
  begin
    num:=tabNumC.tabIndex+1;

    esUnits.setvar(unitY[num],sizeof(unitY[num])-1);

    enJ1.setvar(jru1[num],T_smallint);
    enJ2.setvar(jru2[num],T_smallint);

    enY1.setvar(Yru1[num],T_single);
    enY2.setvar(Yru2[num],T_single);


    if board.ChannelRange then
      begin
        if num<>1 then QvoieAcq[num]:=QvoieAcq[1]+num-1;
        enVoiePhys.enabled:=(num=1);
        enVoiePhys.setvar(QvoieAcq[num],T_byte)
      end
    else
      begin
        enVoiePhys.enabled:=true;
        enVoiePhys.setvar(QvoieAcq[num],T_byte);
      end;
    enVoiePhys.setMinMax(0,15);


    labelRange.caption:=board.GainLabel;
    cbGain.setString(board.RangeString);
    if board.MultiGain
      then cbGain.setvar(Qgain[num],T_byte,1)
      else cbGain.setvar(Qgain[1],T_byte,1);



    enKS.setvar(QKS[num],T_word);
    enKS.setMinMax(1,1000);

    enThreshold.setVar(EvtThreshold[num],T_single);
    enHys.setVar(EvtHysteresis[num],T_single);

    cbType.setString('Analog data|Event data');
    cbType.setVar(ChannelType[num],T_byte,0);

    cbRising.setVar(FRising[num]);
  end;
end;

procedure TparamAcq.TabNumCChange(Sender: TObject);
begin
  updateAllvar(self);
  updateChannels;
  setEnabledGen;
  setEnableChannels;
end;

procedure TparamAcq.cbGenAcqEnter(Sender: TObject);
begin
  with acqParF0 do
  begin
    stGenAcq:=cbGenAcq.text;
    if not verifierGen then messageCentral('Path not found');
  end;
end;

procedure TparamAcq.BbrowseClick(Sender: TObject);
var
  st:string;
  nb:integer;
begin
  st:=GsaveFile('Choose a generic file name',cbGenAcq.text,'dat');
  if st<>'' then
    begin
      st:=FsupespaceFin(st);
      nb:=length(extractFileExt(st));
      delete(st,length(st)-nb+1,nb);
      cbGenAcq.text:=st;
    end;
end;

function IndexOfGain(n:integer):integer;
begin
  case n of
    2: result:=1;
    4: result:=2;
    8: result:=3;
    else  result:=0;
  end;
end;

procedure TparamAcq.bAddClearClick(Sender: TObject);
var
  ob:typeUO;
begin
  ob:=nil;
  if chooseObject.execution(TypeUO,ob) then
    if assigned(ob) then
      with lbClear.Items do
      if indexofObject(ob)<0 then addObject(ob.ident,ob);
end;


procedure TparamAcq.BremoveClearClick(Sender: TObject);
begin
  with lbClear,Items do delete(itemIndex);
end;


procedure TparamAcq.BaddRefreshClick(Sender: TObject);
var
  ob:typeUO;
begin
  ob:=nil;
  if chooseObject.execution(TdataPlot,ob) then
    if assigned(ob) then
      with lbRefresh.Items do
      if indexofObject(ob)<0 then addObject(ob.ident,ob);
end;

procedure TparamAcq.BremoveRefreshClick(Sender: TObject);
begin
  with lbRefresh,Items do delete(itemIndex);
end;



procedure TparamAcq.BcheckClick(Sender: TObject);
begin
  updateAllVar(self);
  CheckDurations;
end;

procedure TparamAcq.checkDurations;
begin
  with acqPar0 do
  begin
    if not continu then
      begin
         Lduration.caption:='Duration: '+Estr1(dureeSeq,10,3)+' ms';

         if periodeParvoie<1000
           then Lfreq.caption:='Freq. per channel: '+Estr1(1/periodeParVoie,10,3)+' kHz'
           else Lfreq.caption:='Freq. per channel: '+Estr1(1000/periodeParVoie,10,3)+' Hz';
         Lperiode.caption:='Global period: '+Estr1(periodeUS,10,3)+' µs';

         if Qnbav<>0
           then Lpretrig.caption:='Pretrig.duration: '+Estr1(Qnbav*periodeParVoie,10,3)+' ms'
           else Lpretrig.caption:='';
         if PeriodOutOfRange
           then Lwarning.caption:='Period out of range'
           else Lwarning.caption:='';

      end
    else
      begin
        Lduration.caption:='';
        if periodeParVoie<0.001
          then Lfreq.caption:='Freq. per channel: '+Estr1(0.001/periodeParVoie,10,3)+' kHz'
          else Lfreq.caption:='Freq. per channel: '+Estr1(1/periodeParVoie,10,3)+' Hz';
        Lperiode.caption:='Global period: '+Estr1(periodeUS,10,3)+' µs';
        Lpretrig.caption:='';
        if PeriodOutOfRange
           then Lwarning.caption:='Period out of range'
           else Lwarning.caption:='';
      end;

  end;
end;

procedure TparamAcq.FormCreate(Sender: TObject);
begin
  pageControl1.activePage:=TabsGeneral;
end;

procedure TparamAcq.BoptionsClick(Sender: TObject);
begin
  if assigned(board) then board.getOptions;
end;

procedure TparamAcq.cbTypeChange(Sender: TObject);
begin
  cbType.UpdateVar;
  setEnableChannels;
end;

end.
