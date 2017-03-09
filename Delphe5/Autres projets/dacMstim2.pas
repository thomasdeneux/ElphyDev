unit dacMstim2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ComCtrls, ExtCtrls, StdCtrls, Buttons,

  util1,  editcont, Dgraphic,

  stmdef,stmObj,
  acqDef2,acqInf2,stimInf2,
  stmvec1, DacScale1,stmError,
  Ncdef2,AcqBrd1,debug0,Dtrace1,

  stmPg,acqCom1,acqBuf1,
  FdefDac2, FrameTable1,
  Multg0,Multg1;





                            
type
  TMstimulator = class(TForm)
    PageControl1: TPageControl;
    TabSheetChannels: TTabSheet;
    Panel0: TPanel;
    Panel3: TPanel;
    Pepisode: TPanel;
    Label9: TLabel;
    Bupdate: TButton;
    Label10: TLabel;
    Bprevious: TBitBtn;
    Bnext: TBitBtn;
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    TabSheetGeneral: TTabSheet;
    Label2: TLabel;
    enIsi: TeditNum;
    GroupBox1: TGroupBox;
    LC1: TLabel;
    LC2: TLabel;
    LC3: TLabel;
    Bcheck: TButton;
    Label1: TLabel;
    enNbChan: TeditNum;
    TabSheetEdit: TTabSheet;
    TabChannel: TTabControl;
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
    Label5: TLabel;
    enDevice: TeditNum;
    cbBitNum: TcomboBoxV;
    Label6: TLabel;
    enPhysChannel: TeditNum;
    Label8: TLabel;
    Label12: TLabel;
    cbOutType: TcomboBoxV;
    Label13: TLabel;
    cbMaxChan: TcomboBoxV;
    TabEdit: TTabControl;
    PanelAna: TPanel;
    TableFrameAna: TTableFrame;
    PanelDigi: TPanel;
    TableFrameDigi: TTableFrame;
    PanelTrain: TPanel;
    enPulseWidth: TeditNum;
    Label3: TLabel;
    Label4: TLabel;
    enPulsesPerBurst: TeditNum;
    Label7: TLabel;
    enInterPulse: TeditNum;
    Label11: TLabel;
    enBurstCount: TeditNum;
    Label14: TLabel;
    enInterBurst: TeditNum;
    Label15: TLabel;
    enDelay: TeditNum;
    Label16: TLabel;
    cbDigiMode: TcomboBoxV;
    EditTypeLabel: TLabel;
    cbSetByProg: TCheckBoxV;
    PanelBottom: TPanel;
    BOK: TButton;
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure BupdateClick(Sender: TObject);
    procedure BcooClick(Sender: TObject);
    procedure BpreviousClick(Sender: TObject);
    procedure BnextClick(Sender: TObject);
    procedure FormOnEnter(Sender: TObject);
    procedure cbDisplayedClick(Sender: TObject);
    procedure enStimDurationExit(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure TabChannelChange(Sender: TObject);
    procedure cbMaxChanChange(Sender: TObject);
    procedure TabEditChange(Sender: TObject);
    procedure cbDigiModeChange(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { Private declarations }
    numSeq:integer;
    numSeqU:integer;

    maxChan0:integer;

    Lab:TlabelCell;
    cellCombo:TcomboBoxCell;
    cellNumSingle:TeditNumCell;
    cellNumWord:TeditNumCell;
    cellNumInteger:TeditNumCell;

    Lab1:TlabelCell;
    cellNumSingle1:TeditNumCell;
    cellNumWord1:TeditNumCell;

    procedure InitGeneTab(first:boolean);
    procedure InitChannelsTab(first:boolean);
    procedure InitEditTab(first:boolean);

    procedure InitMaxChan;
    procedure SelectDigiMode;
    procedure SelectOutputMode;

    procedure checkDurations;
    function getCellAna(ACol, ARow: Integer):Tcell;
    function getCellDigi(ACol, ARow: Integer):Tcell;

  public
    { Public declarations }
    procedure execution;
  end;


var
  Mstimulator: TMstimulator;




implementation


{$R *.DFM}


{************************* Méthodes de TStimDialog ***************************}


procedure TMstimulator.InitGeneTab(first:boolean);
var
  numA:integer;
begin
  if not first then updateAllvar(self);

  enIsi.setvar(acqInf.getRecInfo^.IsiSec,t_single);

  enNbChan.setVar(paramStim.ChannelCount,t_longint);
  enNbChan.setMinMax(0,paramStim.maxChan );

  maxChan0:=paramStim.maxChan;
  cbMaxChan.setNumVar(maxChan0,g_longint);
  cbMaxChan.SetNumList(minPossibleChannels,maxPossibleChannels,8);

  cbSetByProg.setVar(paramStim.SetByProgU);
end;

procedure TMstimulator.execution;
begin
  numSeq:=numSeqU;
  if numseq<=0 then numSeq:=1;

  InitMaxChan;
  InitGeneTab(true);
  InitChannelsTab(true);
  InitEditTab(true);

  Pepisode.caption:=Istr(numSeq);
  checkDurations;

  showModal;

  updateAllvar(self);
  numSeqU:=numSeq;
end;


procedure TMstimulator.InitMaxChan;
var
  i:integer;
begin
  with tabChannel.tabs do
  begin
    clear;
    for i:=1 to paramStim.maxChan do add('S'+Istr(i)+' ');
  end;
  if tabChannel.tabIndex>paramStim.maxChan-1 then tabChannel.tabIndex:=paramStim.maxChan-1;

  with tabEdit.tabs do
  begin
    clear;
    for i:=1 to paramStim.maxChan do add('S'+Istr(i)+' ');
  end;
  if tabEdit.tabIndex>paramStim.maxChan-1 then tabEdit.tabIndex:=paramStim.maxChan-1;
end;

procedure TMstimulator.InitChannelsTab(first:boolean);
var
  numA:integer;
  i:integer;
begin
  if first then
  begin
    cbOutType.setString('Analog|Digital single bit|Digital 16 bits');
    cbBitNum.SetNumList(0,15,1);
  end;

  if not first then updateAllvar(self);

  numA:=tabChannel.tabIndex+1;

  with paramStim,channel[numA]^ do
  begin
    cbOutType.setvar(tpOut,t_byte,0);

    enDevice.setvar(Device,t_byte);
    if assigned(board) then
      enDevice.setminmax(0,board.deviceCount-1 );

    enPhysChannel.setvar(PhysNum,t_byte);
    enPhysChannel.setminmax(0,maxChan-1);

    cbBitNum.setVar(bitNum,t_byte,0);

    esUnits.setvar(unitY,sizeof(unitY)-1);

    enJ1.setvar(jru1,T_smallint);
    enJ2.setvar(jru2,T_smallint);

    enY1.setvar(Yru1,T_single);
    enY2.setvar(Yru2,T_single);

  end;
end;

procedure TMstimulator.InitEditTab(first:boolean);
var
  logCh:integer;
begin
  if not first then updateAllvar(self);

  logCh:=tabChannel.tabIndex+1;

  with paramStim.AutoFillInfo[logCh]^ do
    cbDigiMode.setvar(digimode,t_byte,0);

  with paramStim.AutoFillInfo[logCh]^.train do
  begin
    enPulseWidth.setvar(largeurPulse,t_single);
    enPulseWidth.setMinMax(0,1E20);

    enInterPulse.setvar(cadencePulse,t_single);
    enInterPulse.setMinMax(0,1E20);

    enInterBurst.setvar(cadenceSalve,t_single);
    enInterBurst.setMinMax(0,1E20);

    enPulsesPerBurst.setvar(NbPulse,t_longint);
    enPulsesPerBurst.setMinMax(0,maxEntierLong);

    enBurstCount.setvar(NbSalve,t_longint);
    enBurstCount.setMinMax(0,maxEntierLong);

    enDelay.setvar(DelaiTrain,t_single);
    enDelay.setMinMax(0,1E20);
  end;

  with paramStim.Channel[logCh]^ do
  begin
    case tpOut of
      TO_analog :EditTypeLabel.Caption:='Analog output '+Istr(PhysNum)+' Device '+Istr(Device);
      TO_digiBit:EditTypeLabel.Caption:='Digital output '+Istr(PhysNum)+' Bit '+Istr(BitNum)+' Device '+Istr(Device);
      TO_digi8:  EditTypeLabel.Caption:='Digital output '+Istr(PhysNum)+' Device '+Istr(Device)+ '8 bits mode';
      TO_digi16: EditTypeLabel.Caption:='Digital output '+Istr(PhysNum)+' Device '+Istr(Device)+ '16 bits mode';
    end;
  end;
  SelectDigiMode;
  selectOutputMode;
end;


procedure TMstimulator.FormCreate(Sender: TObject);
begin
  numSeq:=1;

  lab:=TlabelCell.create(tableFrameAna);

  cellCombo:=TcomboBoxCell.create(tableFrameAna);
  cellCombo.tpNum:=g_byte;
  cellCombo.setOptions('Step|Ramp');
  cellCombo.CB.Style:=csDropDownList;

  cellNumSingle:=TeditNumCell.create(tableFrameAna);
  cellNumSingle.tpNum:=g_single;

  cellNumWord:=TeditNumCell.create(tableFrameAna);
  cellNumWord.tpNum:=g_word;
  cellNumWord.nbDeci:=0;

  cellNumInteger:=TeditNumCell.create(tableFrameAna);
  cellNumInteger.tpNum:=g_longint;
  cellNumInteger.nbDeci:=0;

  with tableFrameAna do
  begin
    init(10,20,1,1,getCellAna);
    drawGrid1.colWidths[0]:=20;
    drawGrid1.colWidths[6]:=40;
    drawGrid1.colWidths[7]:=40;
  end;

  lab1:=TlabelCell.create(tableFrameDigi);
  cellNumSingle1:=TeditNumCell.create(tableFrameDigi);
  cellNumSingle1.tpNum:=g_single;

  cellNumWord1:=TeditNumCell.create(tableFrameDigi);
  cellNumWord1.tpNum:=g_word;
  cellNumWord1.nbDeci:=0;

  with tableFrameDigi do
  begin
    init(7,20,1,1,getCellDigi);
    drawGrid1.colWidths[0]:=20;

  end;

  PanelTrain.BevelOuter:=bvNone;
  PanelAna.BevelOuter:=bvNone;
  PanelDigi.BevelOuter:=bvNone;

end;


procedure TMstimulator.PaintBox1Paint(Sender: TObject);
var
  Finside:boolean;
  i:integer;
begin
  with paintbox1 do initGraphic(canvas,left,top,width,height);

  Finside:=false;

  doneGraphic;
end;

procedure TMstimulator.BupdateClick(Sender: TObject);
begin
  updateAllVar(self);
end;

procedure TMstimulator.BcooClick(Sender: TObject);
var
  i,numA:integer;
begin
end;

procedure TMstimulator.BnextClick(Sender: TObject);
begin
  with paramStim do
  begin
    inc(numSeq);
    updateAllVar(self);
    Pepisode.caption:=Istr(numSeq);
  end;
end;

procedure TMstimulator.BpreviousClick(Sender: TObject);
begin
  with paramStim do
  begin
    if numSeq>1 then
      begin
        dec(numSeq);
        updateAllVar(self);
        Pepisode.caption:=Istr(numSeq);
      end;
  end;
end;




procedure TMstimulator.FormOnEnter(Sender: TObject);
begin
  updateAllVar(self);
end;

procedure TMstimulator.cbDisplayedClick(Sender: TObject);
begin
  updateAllVar(self);
end;

procedure TMstimulator.enStimDurationExit(Sender: TObject);
begin
  updateAllVar(self);
  checkDurations;
end;

procedure TMstimulator.checkDurations;
begin
  with paramStim do
  begin
    LC1.caption:='Period per DAC='+Estr1(periodeParDac,10,3)+' ms';
    LC2.caption:='ISI='+Estr1(ISI,10,6)+' sec';
    LC3.caption:='';
  end;
end;

procedure TMstimulator.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  updateAllVar(self);


  AllowChange:=true;
end;

procedure TMstimulator.PageControl1Change(Sender: TObject);
begin
  initChannelsTab(false);
  initEditTab(false);
end;


procedure TMstimulator.TabChannelChange(Sender: TObject);
begin
  updateAllvar(self);
  InitChannelsTab(false);
  tabEdit.TabIndex:=TabChannel.TabIndex;

end;

procedure TMstimulator.cbMaxChanChange(Sender: TObject);
begin
  cbMaxChan.UpdateVar;
  if maxChan0<>paramStim.maxChan then
  begin
    paramStim.InitChannelMax(maxChan0);
    InitChannelsTab(true);
    InitEditTab(true);
  end;
end;

function TMstimulator.getCellAna(ACol, ARow: Integer): Tcell;
var
  logCh:integer;
begin
  logCh:= tabEdit.TabIndex;

  result:=nil;
  if (Acol=0) or (Arow=0) then
  begin
    result:=lab;
    if (Arow=0) and (Acol=0) then lab.st:=''
    else
    if (Arow>0) and (Arow<tableFrameAna.RowCount) then lab.st:=Istr(Arow)
    else
    if (Acol>0) then
    case Acol of
      1: lab.st:='Mode';
      2: lab.st:='Duration(ms)';
      3: lab.st:='Amplitude('+ paramStim.channel[logCh+1].unitY+')';
      4: lab.st:='Amplitude inc.';
      5: lab.st:='Duration inc.';
      6: lab.st:='Rep1';
      7: lab.st:='Rep2';
      8: lab.st:='Vstart';
      9: lab.st:='Vend';
    end;
  end
  else
  if Acol=1 then
  begin
    result:=cellCombo;
    cellCombo.AdData:=@paramStim.AutoFillInfo[logCh+1]^.ana[Arow].mode;
  end
  else
  if Acol in [2..5,8,9] then
  begin
    result:=CellNumSingle;
    case Acol of
      2:CellNumSingle.AdData:=@paramStim.AutoFillInfo[logCh+1]^.ana[Arow].duree;
      3:CellNumSingle.AdData:=@paramStim.AutoFillInfo[logCh+1]^.ana[Arow].Amp;
      4:CellNumSingle.AdData:=@paramStim.AutoFillInfo[logCh+1]^.ana[Arow].IncAmp;
      5:CellNumSingle.AdData:=@paramStim.AutoFillInfo[logCh+1]^.ana[Arow].IncDuree;
      8:CellNumSingle.AdData:=@paramStim.AutoFillInfo[logCh+1]^.ana[Arow].Vinit;
      9:CellNumSingle.AdData:=@paramStim.AutoFillInfo[logCh+1]^.ana[Arow].Vfinale;
    end;
  end
  else
  if Acol in [6,7] then
  begin
    result:=CellNumWord;
    case Acol of
      6:CellNumWord.AdData:=@paramStim.AutoFillInfo[logCh+1]^.ana[Arow].Rep1;
      7:CellNumWord.AdData:=@paramStim.AutoFillInfo[logCh+1]^.ana[Arow].Rep2;
    end;
  end;
end;

function TMstimulator.getCellDigi(ACol, ARow: Integer): Tcell;
var
  logCh:integer;
begin
  logCh:= tabEdit.TabIndex;

  result:=nil;
  if (Acol=0) or (Arow=0) then
  begin
    result:=lab1;
    if (Arow=0) and (Acol=0) then lab1.st:=''
    else
    if (Arow>0) and (Arow<tableFrameDigi.RowCount) then lab1.st:=Istr(Arow)
    else
    if (Acol>0) then
    case Acol of
      1: lab1.st:='Time';
      2: lab1.st:='Duration(ms)';
      3: lab1.st:='Time inc.';
      4: lab1.st:='Duration inc.';
      5: lab1.st:='Rep1';
      6: lab1.st:='Rep2';
    end;
  end
  else
  if Acol in [1..4] then
  begin
    result:=CellNumSingle1;
    case Acol of
      1:CellNumSingle1.AdData:=@paramStim.AutoFillInfo[logCh+1]^.pulse[Arow].date;
      2:CellNumSingle1.AdData:=@paramStim.AutoFillInfo[logCh+1]^.pulse[Arow].duree;
      3:CellNumSingle1.AdData:=@paramStim.AutoFillInfo[logCh+1]^.pulse[Arow].IncDate;
      4:CellNumSingle1.AdData:=@paramStim.AutoFillInfo[logCh+1]^.pulse[Arow].IncDuree;
    end;
  end
  else
  if Acol in [5,6] then
  begin
    result:=CellNumWord1;
    case Acol of
      5:CellNumWord1.AdData:=@paramStim.AutoFillInfo[logCh+1]^.pulse[Arow].Rep1;
      6:CellNumWord1.AdData:=@paramStim.AutoFillInfo[logCh+1]^.pulse[Arow].Rep2;
    end;
  end;
end;


procedure TMstimulator.TabEditChange(Sender: TObject);
var
  logCh:integer;
begin
  tabChannel.TabIndex:= tabEdit.TabIndex;

  initEditTab(false);
  SelectOutputMode;
end;

procedure TMstimulator.cbDigiModeChange(Sender: TObject);
begin
  SelectDigiMode;
end;

procedure TMstimulator.SelectDigiMode;
begin
  case cbDigiMode.itemIndex of
    0: begin
         PanelTrain.Visible:=false;
         TableFrameDigi.Visible:=true;
       end;
    1: begin
         PanelTrain.Visible:=true;
         TableFrameDigi.Visible:=false;
       end;
  end;

end;

procedure TMstimulator.SelectOutputMode;
var
  logCh:integer;
begin
  logCh:= tabChannel.TabIndex;

  PanelAna.Visible:= (paramstim.Channel[logCh+1].tpOut=to_analog);
  PanelDigi.Visible:= (paramstim.Channel[logCh+1].tpOut=to_digibit);

  if PanelAna.Visible then TableFrameAna.invalidate;
  if PanelDigi.Visible then TableFrameDigi.invalidate;
end;


end.
