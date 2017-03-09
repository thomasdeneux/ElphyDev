unit Dparac2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, ComCtrls, Grids, ExtCtrls, Buttons ,

  util1,Dutil1,Ddosfich, debug0,
  acqDef2,acqInf2,stimInf2,
  ITCbrd,

  acqBuf1,
  acqBrd1,
  stmdef,stmObj,procfile, chooseOb,stmDplot,stmdf0,
  ChooseNrnName,DemoBrd1,
  RTneuronBrd, CyberKbrd1, NIbrd1
  ;

type

  { TparamAcq }

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
    Lnbav: TLabel;
    cbModeAcq: TcomboBoxV;
    enNbvoie: TeditNum;
    enDuree: TeditNum;
    enPeriod: TeditNum;
    enDureeAv: TeditNum;
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
    TabSaverage: TTabSheet;
    GroupBox1: TGroupBox;
    cbGenAcq: TComboBox;
    Bbrowse: TButton;
    GroupBox2: TGroupBox;
    cbProcess: TCheckBoxV;
    GroupBox3: TGroupBox;
    lbClear: TListBox;
    BaddClear: TButton;
    BremoveClear: TButton;
    GroupBox7: TGroupBox;
    CbQmoy: TCheckBoxV;
    cbSaveMoy: TCheckBoxV;
    Label1: TLabel;
    enCadMoy: TeditNum;
    Label2: TLabel;
    TabSDisplay: TTabSheet;
    cbDisplay: TCheckBoxV;
    GroupBox8: TGroupBox;
    lbRefresh: TListBox;
    BaddRefresh: TButton;
    BremoveRefresh: TButton;
    cbImmediate: TCheckBoxV;
    cbHold: TCheckBoxV;
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
    GroupBox9: TGroupBox;
    Lfreq: TLabel;
    AggFreq: TLabel;
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
    enThreshold: TeditNum;
    enHys: TeditNum;
    cbRising: TCheckBoxV;
    cbSound: TCheckBoxV;
    Ldevice: TLabel;
    enDevice: TeditNum;
    LperiodPerChan: TLabel;
    LQnbpt: TLabel;
    Lisi: TLabel;
    enISI: TeditNum;
    EventPanel: TPanel;
    Label6: TLabel;
    Label12: TLabel;
    NotUsedPanel: TPanel;
    Label10: TLabel;
    TabScyberK: TTabSheet;
    GroupBox10: TGroupBox;
    Label13: TLabel;
    cbCybElec: TcomboBoxV;
    Label14: TLabel;
    cbCybUnits: TcomboBoxV;
    Label15: TLabel;
    enWaveLen: TeditNum;
    Label16: TLabel;
    enPretrig: TeditNum;
    GroupBox11: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    enCyberJru1: TeditNum;
    enCyberYru1: TeditNum;
    enCyberJru2: TeditNum;
    enCyberYru2: TeditNum;
    esCyberUnitY: TeditString;
    TabSChannelsNRN: TTabSheet;
    GroupBox12: TGroupBox;
    TabNumCacqNrn: TTabControl;
    Label23: TLabel;
    esAcqSymbol: TeditString;
    BacqSymbol: TButton;
    GroupBox13: TGroupBox;
    TabNumCtagNrn: TTabControl;
    Label24: TLabel;
    esTagSymbol: TeditString;
    BtagSymbol: TButton;
    cbRisingSlope: TCheckBoxV;
    LfileWarning: TLabel;
    TabSPhoton: TTabSheet;
    cbDisplayPhotons: TCheckBoxV;
    cbAcqPhoton: TcomboBoxV;
    Label11: TLabel;
    GBtcpip: TGroupBox;
    esIPaddress: TeditString;
    Label26: TLabel;
    Label27: TLabel;
    enPort: TeditNum;
    cbRawBuffer: TCheckBoxV;
    cbSwapBytes: TCheckBoxV;
    GroupBox14: TGroupBox;
    Label28: TLabel;
    enNX: TeditNum;
    Label29: TLabel;
    enNY: TeditNum;
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
    procedure cbFileFormatChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure BsymbolNameClick(Sender: TObject);
    procedure TabNumCacqNrnChange(Sender: TObject);
    procedure BtagSymbolClick(Sender: TObject);
    procedure TabNumCtagNrnChange(Sender: TObject);
    procedure cbAcqPhotonChange(Sender: TObject);
  private
    { Déclarations privées }
    FmodChan:boolean;
    acqPar0:TacqInfo;
    rec:PAcqRecInfo;

    NeuronBoard:boolean;
    NIboard:boolean;

    procedure setEnabledGen;
    procedure setEnabledTrig;
    procedure setEnabledChannels;
    procedure updateChannels;

    procedure checkDurations;
  public
    { Déclarations publiques }

    function execution(acqPar:TacqInfo):boolean;
  end;

function paramAcq: TparamAcq;


implementation

uses recorder1;
{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FparamAcq: TparamAcq;

function paramAcq: TparamAcq;
begin
  if not assigned(FparamAcq) then FparamAcq:= TparamAcq.create(nil);
  result:= FparamAcq;
end;

procedure TparamAcq.setEnabledGen;
begin
  with acqPar0 do
  begin
    enDuree.enabled:=not continu;
    LDuree.enabled:=not continu;

    enMaxDuration.enabled:=continu;
    LmaxDuration.enabled:=continu;

    enDureeAv.enabled:=not continu;
    Lnbav.enabled:=not continu;

    enEpCount.enabled:=not continu;
    LepCount.enabled:=not continu;

    cbSound.Enabled:=(DFformat=ElphyFormat1) and continu;
  end;
end;

procedure TparamAcq.setEnabledTrig;
var
  analog,analogNI:boolean;
begin
  with acqPar0 do
  begin
    analog:=modeSynchro in[MSanalogAbs, MSanalogDiff];
    analogNI:= modeSynchro =MSanalogNI;


    enVoieSync.enabled:=analog or analogNI or (modeSynchro in [MSnumPlus,MSnumMoins])
                        and  (board is TITCinterface);
    LvoieSync.enabled:=enVoieSync.enabled;

    enSeuilHaut.enabled:=analog or analogNI;
    LseuilHaut.enabled:=analog or analogNI;

    enSeuilBas.enabled:=analog;
    LseuilBas.enabled:=analog;

    enTestInt.enabled:=(modeSynchro=MSanalogDiff);
    LtestInt.enabled:=(modeSynchro=MSanalogDiff);

    enISI.enabled:=(modeSynchro=MSinterne);
    LISI.enabled:=(modeSynchro=MSinterne);

    cbRisingSlope.Enabled:=analogNI;

    if analogNI
      then LseuilHaut.Caption:='NI threshold'
      else LseuilHaut.Caption:='Upper threshold';

  end;
end;

procedure TparamAcq.setEnabledChannels;
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

    enDevice.Enabled:=(board.deviceCount>1);
    Ldevice.Enabled :=(board.deviceCount>1);

    num:=tabNumC.tabIndex+1;



    EventPanel.Visible:=(ChannelType[num]=TI_anaEvent);

    NotUsedPanel.Visible:=(ChannelType[num]=TI_Neuron) and  not NeuronBoard
                          or (ChannelType[num] in [TI_Digi8,TI_digi16,TI_digiBit,TI_digiEvent]) ;


  end;
end;

function getItemSt(st:AnsiString;num:integer):AnsiString;
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

function nbItemSt(st:AnsiString):integer;
var
  i:integer;
begin
  result:=1;
  for i:=1 to length(st) do
    if st[i]='|' then inc(result);
end;

function addItemSt(st1,st:AnsiString):AnsiString;
var
  i:integer;
  stX,stM:AnsiString;

begin
  result:=st1;

  stM:=Fmaj(st1);

  for i:=1 to nbItemSt(st) do
    begin
      stX:=getItemSt(st,i);
      if Fmaj(stX)<>stM then result:=result+'|'+stX;
    end;
end;


function TparamAcq.execution(acqPar:TacqInfo):boolean;
var
  i:integer;
  st:AnsiString;
begin
  acqPar.controle;

  acqPar0:=TacqInfo.create;
  acqPar0.assign(acqPar) ;
  rec:=acqPar0.getRecInfo;

  NeuronBoard:=(board is TRTNIinterface) {or (board is TDemoInterface)};
  NIboard:= (board is TNIboard);

  resetvar(self);
  with acqPar0 do
  begin

    cbModeAcq.setString('Episodes|Continuous');
    cbModeAcq.setvar(rec.continu,T_byte,0);

    enEpCount.setvar(rec.MaxEpCount,T_longint);
    enEpCount.setMinMax(0,maxEntierLong);

    enNbvoie.setvar(rec.Qnbvoie,T_smallint);
    enNbvoie.setMinMax(0,1000);

    enDuree.setvar(rec.DureeSeqU,T_double);
    enDuree.setMinMax(0,1E7);


    enPeriod.setvar(rec.PeriodeCont,T_double);
    enPeriod.setMinMax(0,1E7);
    enPeriod.Enabled:=not board.FixedPeriod;

    enMaxDuration.setvar(rec.MaxDuration,T_single);
    enMaxDuration.setMinMax(0,1E7);

    enDureeAv.setvar(rec.DureePreTrigU,T_double);
    enDureeAv.setMinMax(0,1E10);

    cbStim.setvar(rec.Fstim);
    cbSound.setvar(rec.recSound);

    cbModeTrig.setString( TrigString);
    cbModeTrig.setvar(rec.modeSynchro,T_byte,0);

    enVoieSync.setvar(rec.VoieSynchro,T_smallint);
    enVoieSync.setMinMax(0,1000);

    enSeuilHaut.setvar(rec.seuilPlus,T_single);
    enSeuilBas.setvar(rec.seuilMoins,T_single);

    enTestInt.setvar(rec.intervalTest,T_smallint);
    enTestInt.setMinMax(1,1000);

    enISI.setVar(rec.ISIsec,T_single);
    enISI.setMinMax(0,1000000);

    cbRisingSlope.setVar(rec.NIRisingSlope);

    cbProcess.setvar(rec.Fprocess);

    cbQmoy.setVar(rec.Qmoy);
    cbSaveMoy.setvar(rec.FFmoy);
    enCadMoy.setvar(rec.cadmoy,t_longint);

    cbDisplay.setvar(rec.Fdisplay);
    cbImmediate.setvar(rec.Fimmediate);
    cbHold.setvar(rec.Fhold);


    with CBgenAcq,AcqPar do
    begin
      clear;
      for i:=1 to nbItemSt(stGenHis) do items.add(getItemSt(stGenHis,i));
      text:=stGenAcq;
    end;

    memoComment.text:=memoA.stList.text;


    enFileInfo.setvar(rec.FileInfoSize,T_longint);
    enFileInfo.setMinMax(0,1000000);

    enEpInfo.setvar(rec.EpInfoSize,T_longint);
    enEpInfo.setMinMax(0,1000000);

    enCommentSize.setvar(rec.MiniCommentSize,T_longint);
    enCommentSize.setMinMax(0,1000000);

    cbControlPanel.setVar(rec.FcontrolPanel);
    cbTriggerPos.setVar(rec.FtriggerPos);


    cbFileFormat.setString('Dac2|Elphy');
    cbFileFormat.setVar(rec.DFformat,t_byte,0);
    cbFileFormat.Enabled:=not board.ElphyFormatOnly;

    if not (board is TcyberKinterface) then tabScyberK.TabVisible:=false; 
    if board is TcyberKinterface then
    begin
      cbCybElec.setString('0 |32 | 64 | 96 | 128');
      cbCybElec.setValues([0,32,64,96,128]);
      cbCybElec.setVar(rec.CyberElecCount,g_word,0);

      cbCybUnits.SetNumList(1,6,1);
      cbCybUnits.setVar(rec.CyberUnitCount,g_word,2);

      enWaveLen.setVar(rec.CyberWavelen,g_word);
      enWaveLen.setMinMax(16,128);

      enPretrig.setVar(rec.PretrigWave,g_word);
      enPretrig.setMinMax(0,128);

      esCyberUnitY.setvar(rec.CyberunitY,sizeof(rec.CyberunitY)-1);

      enCyberJru1.setvar(rec.Cyberjru1,T_smallint);
      enCyberJru2.setvar(rec.Cyberjru2,T_smallint);

      enCyberYru1.setvar(rec.CyberYru1,T_single);
      enCyberYru2.setvar(rec.CyberYru2,T_single);

    end;

    TabSchannels.TabVisible:= not NeuronBoard ;
    TabSchannelsNrn.TabVisible:= NeuronBoard ;

    TabSPhoton.TabVisible:= NIboard ;
    If NIboard then
    begin
      cbAcqPhoton.setString('None  |NI system |TCPIP   ' );
      cbAcqPhoton.setVar(rec.AcqPhotons,g_byte,0);
      cbDisplayPhotons.setVar(rec.DispPhotons);

      esIPaddress.setVar(rec.IPaddress,20);
      enPort.setVar(rec.TCPIPport,g_longint);
      cbRawBuffer.setVar(rec.TCPIPrawBuffer);
      cbSwapBytes.setvar(rec.TCPIPswapBytes);

      enNX.setVar(rec.PCLnx,g_longint);
      enNY.setVar(rec.PCLny,g_longint);
    end;
    
    GBtcpip.Visible:= (cbAcqPhoton.ItemIndex=2);


    if NeuronBoard then TabSchannelsNrn.PageIndex:=2;

    updateChannels;

    setEnabledGen;
    setEnabledTrig;
    setEnabledChannels;

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
      acqPar.assign(acqpar0);

      with acqpar do
      begin
        stgenAcq:=cbGenAcq.text;
        stgenHis:=addItemSt(stGenAcq,stgenHis);
      end;

      memoA.stList.text:=memoComment.text;

      ObjectsToRefresh.clear;
      with lbRefresh do
      for i:=0 to items.count-1 do ObjectsToRefresh.add(items.objects[i]);

      ObjectsToClear.clear;
      with lbClear do
      for i:=0 to items.count-1 do ObjectsToClear.add(items.objects[i]);

      AcqCommand.UpdateThresholds;

      AcqInf.InstallTCPIPServer;
    end;

  acqPar0.Free;

  {
  st:='';
  with acqPar do
  for i:=1 to Qnbvoie do st:=st+Istr(ord(channelType[i]))+' ';
  messageCentral(st);
  }
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
  num,i:integer;
  st:AnsiString;
begin
  if not NeuronBoard then
  with acqPar0 do
  begin
    num:=tabNumC.tabIndex;

    with channels[num] do
    begin
      esUnits.setvar(unitY,sizeof(unitY)-1);

      enJ1.setvar(jru1,T_smallint);
      enJ2.setvar(jru2,T_smallint);

      enY1.setvar(Yru1,T_single);
      enY2.setvar(Yru2,T_single);

      enDevice.enabled:=true;
      enDevice.setvar(Qdevice,T_byte);

      if board.ChannelRange then
        begin
          if num<>0 then QvoieAcq:=channels[0].QvoieAcq+num;
          enVoiePhys.enabled:=(num=0);
          enVoiePhys.setvar(QvoieAcq,T_byte)
        end
      else
        begin
          enVoiePhys.enabled:=true;
          enVoiePhys.setvar(QvoieAcq,T_byte);
        end;
      enVoiePhys.setMinMax(0,255);           { modif pour cyberK }


      labelRange.caption:=board.GainLabel;

      cbGain.setString(board.RangeString);
      if board.MultiGain
        then cbGain.setvar(Qgain,T_byte,1)
        else cbGain.setvar(channels[0].Qgain,T_byte,1);

      enKS.setvar(QKS,T_word);
      enKS.setMinMax(1,1000);

      enThreshold.setVar(EvtThreshold,T_single);
      enHys.setVar(EvtHysteresis,T_single);

      {  TinputType=(TI_analog, TI_anaEvent, TI_Digi8, TI_digi16, TI_digiBit, TI_digiEvent, TI_Neuron );     }
      {  Numbers       0          1             2         3         4            5             6             }
      {  Title      Analog      Event Analog Digi8     Digi16     DigiBit     Event Digital Neuron output    }



      if board is TcyberKinterface then
      begin
        cbType.setString('Analog');
        cbType.setValues([0]);
      end
      else
      if board is TNIboard then
      begin
        cbType.setString('Analog |Analog Event| Digital Event');
        cbType.setValues([0,1,5]);
      end
      else
      if FlagRTNeuron then
      begin
        cbType.setString('Neuron variable ');
        cbType.SetValues([6]);
      end
      else
      begin
        cbType.setString('Analog |Analog Event');
        cbType.setValues([0, 1]);
      end;

      cbType.setVar(ChannelType,T_byte,0);

      cbRising.setVar(FRising);

      with paramstim do
      begin
        st:='None';
        for i:=1 to maxchan do st:=st+'|'+Istr(i);
      end;
    end;
  end
  else
  with AcqPar0 do
  begin
    num:=tabNumCacqNrn.tabIndex;
    esAcqSymbol.setString(NrnAcqName[num],100);

    num:=tabNumCtagNrn.tabIndex;
    esTagSymbol.setString(NrnTagName[num+1],100);
  end;
end;

procedure TparamAcq.TabNumCChange(Sender: TObject);
begin
  if FmodChan then exit;

  updateAllvar(self);
  updateChannels;
  setEnabledGen;
  setEnabledChannels;
end;

procedure TparamAcq.TabNumCacqNrnChange(Sender: TObject);
begin
  if FmodChan then exit;

  updateAllvar(self);
  updateChannels;
  setEnabledChannels;
end;

procedure TparamAcq.TabNumCtagNrnChange(Sender: TObject);
begin
  if FmodChan then exit;

  updateAllvar(self);
  updateChannels;
end;

procedure TparamAcq.cbGenAcqEnter(Sender: TObject);
begin
  with acqPar0 do
  begin
    stGenAcq:=cbGenAcq.text;
    {$IFDEF FPC}
    if not verifierGen
      then LFileWarning.Caption:='Path Not Found'
      else LFileWarning.Caption:='';
    {$ELSE}
    if not verifierGen then messageCentral('Path not found');
    {$ENDIF}
  end;
end;

procedure TparamAcq.BbrowseClick(Sender: TObject);
var
  st:AnsiString;
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
    LperiodPerChan.Caption:='Period per channel : '+Estr(periodeParVoieMS,3)+' ms';
    if periodeParVoieMS<1
          then Lfreq.caption:='Freq. per channel: '+Estr(1/periodeParVoieMS,3)+' kHz'
          else Lfreq.caption:='Freq. per channel: '+Estr(1000/periodeParVoieMS,3)+' Hz';

    if periodeUS>0.01 then AggFreq.caption:='Aggregate frequency '+Estr(1000/periodeUS,3)+' kHz';

    if not continu then
    begin
       Lduration.caption:='Duration: '+Estr(dureeSeq,3)+' ms';
       LQnbpt.caption:='Samples per channel : '+Istr(Qnbpt);

       if Qnbav<>0
         then Lpretrig.caption:='Pretrig.samples:  '+Istr(Qnbav)
         else Lpretrig.caption:='';
    end;

    if PeriodOutOfRange
      then Lwarning.caption:='Period out of range'
      else Lwarning.caption:='';
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

procedure TparamAcq.cbFileFormatChange(Sender: TObject);
begin
  updateAllvar(self);
  setEnabledChannels;

  with acqPar0 do
  cbSound.Enabled:=(DFformat=ElphyFormat1) and continu;
end;

procedure TparamAcq.FormShow(Sender: TObject);
var
  i:integer;
begin
  if not NeuronBoard and (tabNumC.Tabs.count<>datafile0.maxChan) then
  begin
    FmodChan:=true;
    with tabNumC.tabs do
    begin
      clear;
      for i:=1 to datafile0.maxChan do add(Istr(i));
      if tabNumC.tabIndex>=count then tabNumC.tabIndex:=0;
    end;

    updateChannels;
    setEnabledGen;
    FmodChan:=false;
  end;

  if NeuronBoard and (tabNumCacqNrn.Tabs.count<>datafile0.maxChan) then
  begin
    FmodChan:=true;
    with tabNumCacqNrn.tabs do
    begin
      clear;
      for i:=1 to datafile0.maxChan do add(Istr(i));
      if tabNumCacqNrn.tabIndex>=count then tabNumC.tabIndex:=0;
    end;

    updateChannels;
    setEnabledGen;
    FmodChan:=false;
  end;

end;

procedure TparamAcq.cbTypeChange(Sender: TObject);
begin
  cbType.UpdateVar;
  setEnabledChannels;
end;

procedure TparamAcq.BsymbolNameClick(Sender: TObject);
var
  num:integer;
  st:AnsiString;

begin
  with acqPar0 do
  begin
    num:=tabNumCacqNrn.tabIndex;

    st:=ChooseNrnSym.Execute(board);
    if st<>'' then
    begin
      nrnAcqName[num]:=st;
      esAcqSymbol.UpdateCtrl;
    end;
  end;

end;

procedure TparamAcq.BtagSymbolClick(Sender: TObject);
var
  num:integer;
  st:AnsiString;

begin
  with acqPar0 do
  begin
    num:=tabNumCtagNrn.tabIndex;

    st:=ChooseNrnSym.Execute(board);
    if st<>'' then
    begin
      nrnTagName[num+1]:=st;
      esTagSymbol.UpdateCtrl;
    end;
  end;



end;


procedure TparamAcq.cbAcqPhotonChange(Sender: TObject);
begin
  GBtcpip.Visible:= (cbAcqPhoton.ItemIndex=2);
end;

Initialization
AffDebug('Initialization Dparac2',0);
{$IFDEF FPC}
{$I Dparac2.lrs}
{$ENDIF}
end.
