unit dacMstim3;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  
  {$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, multg0, Menus, StdCtrls, Buttons, ComCtrls, ExtCtrls,
  FrameTable1, editcont,

  util1, Dgraphic,

  stmdef,stmObj,
  acqDef2,acqInf2,stimInf2,
  stmvec1, stmError,
  Ncdef2,AcqBrd1,RTNeuronBrd,DemoBrd1,
  debug0,Dtrace1,

  stmPg,acqCom1,acqBuf1,
  FdefDac2,
  multg1,
  ChooseNrnName;

type
  TMultiGstim2 = class(TMultiGform)
    PanelBottom: TPanel;
    BOK: TButton;
    PageControl1: TPageControl;
    TabSheetGeneral: TTabSheet;
    Label2: TLabel;
    Label1: TLabel;
    Label13: TLabel;
    enIsi: TeditNum;
    GroupBox1: TGroupBox;
    LC1: TLabel;
    LC2: TLabel;
    LC3: TLabel;
    Bcheck: TButton;
    enNbChan: TeditNum;
    cbMaxChan: TcomboBoxV;
    cbSetByProg: TCheckBoxV;
    TabSheetChannels: TTabSheet;
    TabChannel: TTabControl;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label12: TLabel;
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
    enDevice: TeditNum;
    cbBitNum: TcomboBoxV;
    enPhysChannel: TeditNum;
    cbOutType: TcomboBoxV;
    TabSheetEdit: TTabSheet;
    TabEdit: TTabControl;
    EditTypeLabel: TLabel;
    PanelAna: TPanel;
    TableFrameAna: TTableFrame;
    PanelDigi: TPanel;
    TableFrameDigi: TTableFrame;
    PanelTrain: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    enPulseWidth: TeditNum;
    enPulsesPerBurst: TeditNum;
    enInterPulse: TeditNum;
    enBurstCount: TeditNum;
    enInterBurst: TeditNum;
    enDelay: TeditNum;
    Panel0: TPanel;
    Panel3: TPanel;
    Label9: TLabel;
    Pepisode: TPanel;
    Bupdate: TButton;
    Bprevious: TBitBtn;
    Bnext: TBitBtn;
    Panel1: TPanel;
    enBufferCount: TeditNum;
    Label10: TLabel;
    enBufferSize: TeditNum;
    Label17: TLabel;
    LC4: TLabel;
    Label18: TLabel;
    cbFillMode: TcomboBoxV;
    Label16: TLabel;
    enPulseAmp: TeditNum;
    LabelNrnSymbol: TLabel;
    esNrnSymbol: TeditString;
    BsymbolName: TButton;
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure TabChannelChange(Sender: TObject);
    procedure cbMaxChanChange(Sender: TObject);
    procedure TabEditChange(Sender: TObject);
    procedure cbFillModeChange(Sender: TObject);
    procedure TabEditMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure changeDisplay(Sender: TObject);
    procedure BcheckClick(Sender: TObject);
    procedure BsymbolNameClick(Sender: TObject);
    procedure changeBuffers(Sender: TObject);
  private
    { Déclarations privées }

    NumSeq:integer;
    maxChan0:integer;

    Lab:TlabelCell;
    cellCombo:TcomboBoxCell;
    cellNumSingle:TeditNumCell;
    cellNumWord:TeditNumCell;
    cellNumInteger:TeditNumCell;

    Lab1:TlabelCell;
    cellNumSingle1:TeditNumCell;
    cellNumWord1:TeditNumCell;

    FchangeBuffers:boolean;

    procedure InitGeneTab(first:boolean);
    procedure InitChannelsTab(first:boolean);
    procedure InitEditTab(first:boolean);

    procedure InitMaxChan;
    procedure SelectFillMode(n:integer);
    procedure SelectOutputMode;

    procedure checkDurations;
    function getCellAna(ACol, ARow: Integer):Tcell;
    function getCellDigi(ACol, ARow: Integer):Tcell;

    procedure UpdateDisplay;
    procedure ControleBuffers;
  public
    { Public declarations }
    procedure execution;
  end;

{
var
  Mstimulator: TMultiGstim2;
}
type
  TmultiGraphStim=class(Tmultigraph)
    constructor create;override;
    class function STMClassName:AnsiString;override;
    procedure completeLoadInfo;override;
    procedure show(sender:Tobject);override;
    procedure execution;
    function formG2:TMultiGstim2;
    function dragOverG(source:Tobject):boolean;override;
  end;

function Mstimulator:TmultiGraphStim;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}


procedure TmultiGStim2.execution;
begin
  if numseq<=0 then numSeq:=1;

  InitMaxChan;
  InitGeneTab(true);
  InitChannelsTab(true);
  InitEditTab(true);

  Pepisode.caption:=Istr(numSeq);
  checkDurations;

  paramStim.initStimBuffers(false);
  FchangeBuffers:=false;
  
  paramStim.BuildStim(NumSeq);

  showModal;

  updateAllvar(self);
end;

procedure TmultiGStim2.InitMaxChan;
var
  i:integer;
begin
  with tabChannel.tabs do
  begin
    clear;
    for i:=1 to paramStim.maxChan do add('V'+Istr(i)+' ');
  end;
  if tabChannel.tabIndex>paramStim.maxChan-1 then tabChannel.tabIndex:=paramStim.maxChan-1;

  with tabEdit.tabs do
  begin
    clear;
    for i:=1 to paramStim.maxChan do add('V'+Istr(i)+' ');
  end;
  if tabEdit.tabIndex>paramStim.maxChan-1 then tabEdit.tabIndex:=paramStim.maxChan-1;
end;


procedure TmultiGStim2.InitGeneTab(first:boolean);
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

  
  enBufferCount.setVar(paramstim.BufferCountU,t_longint);
  if AcqInf.continu then
  begin
    enBufferSize.setVar(paramstim.BufferSizeU,t_longint);
    enBufferSize.Enabled:=true;
  end
  else
  begin
    enBufferSize.Text:=Istr(Acqinf.Qnbpt);
    enBufferSize.Enabled:=false;
  end;
  
  cbSetByProg.setVar(paramStim.SetByProgU);
end;

procedure TmultiGStim2.InitChannelsTab(first:boolean);
var
  numA:integer;
  i:integer;
  NeuronBoard:boolean;
begin
  if first then
  begin

    if FlagRTneuron then
    begin
      cbOutType.setString('Analog|Digital single bit|Neuron variable');
      cbOutType.SetValues([0,1,4]);
    end
    else
    begin
      cbOutType.setString('Analog|Digital single bit');
      cbOutType.SetValues([0,1]);
    end;

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

    esNrnSymbol.setString(NrnName[numA]^,100);
  end;

  NeuronBoard:=(board is TRTNIinterface) or (board is TDemoInterface);
  esNrnSymbol.Visible:=NeuronBoard;
  LabelNrnSymbol.Visible:=NeuronBoard;
  BsymbolName.Visible:=NeuronBoard;
end;

procedure TmultiGStim2.InitEditTab(first:boolean);
var
  logCh:integer;
begin
  if not first then updateAllvar(self);

  logCh:=tabChannel.tabIndex+1;

  with paramStim.AutoFillInfo[logCh]^ do
  begin
    cbFillMode.setString('Analog segments |Pulses |Pulse Train' );
    cbFillMode.setvar(Fillmode,t_byte,0);

    enPulseAmp.setVar(PulseAmp,t_single);
    enPulseAmp.setMinMax(0,1E20);

    SelectFillMode(FillMode);
  end;


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
  
  selectOutputMode;
end;


procedure TmultiGStim2.FormCreate(Sender: TObject);
begin
  inherited;

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

  PageControl1.TabIndex:=0;
  PanelTrain.BevelOuter:=bvNone;
  PanelAna.BevelOuter:=bvNone;
  PanelDigi.BevelOuter:=bvNone;

end;




procedure TmultiGStim2.checkDurations;
begin
  with paramStim do
  begin
    LC1.caption:='Period per DAC='+Estr1(periodeParDac,10,3)+' ms';
    LC2.caption:='ISI='+Estr1(ISI,10,6)+' sec';
    LC3.caption:='';

    if AcqInf.continu and (BufferSizeU>0)
      then LC4.caption:='Pseudo-episode duration: '+Estr(EPsize*Dxu,6)+' sec'
      else LC4.Caption:='';
  end;
end;

procedure TmultiGStim2.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  updateAllVar(self);


  AllowChange:=true;
end;

procedure TmultiGStim2.PageControl1Change(Sender: TObject);
begin
  initChannelsTab(false);
  initEditTab(false);
end;


procedure TmultiGStim2.TabChannelChange(Sender: TObject);
begin
  updateAllvar(self);
  InitChannelsTab(false);
  tabEdit.TabIndex:=TabChannel.TabIndex;

end;

procedure TmultiGStim2.cbMaxChanChange(Sender: TObject);
begin
  cbMaxChan.UpdateVar;
  if maxChan0<>paramStim.maxChan then
  begin
    paramStim.InitChannelMax(maxChan0);
    InitChannelsTab(true);
    InitEditTab(true);
  end;
end;

function TmultiGStim2.getCellAna(ACol, ARow: Integer): Tcell;
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

function TmultiGStim2.getCellDigi(ACol, ARow: Integer): Tcell;
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


procedure TmultiGStim2.TabEditChange(Sender: TObject);
var
  logCh:integer;
begin
  tabChannel.TabIndex:= tabEdit.TabIndex;

  initEditTab(false);
  SelectOutputMode;
  tableFrameAna.invalidate;
  tableFrameDigi.invalidate;

end;

procedure TmultiGStim2.cbFillModeChange(Sender: TObject);
var
  logCh:integer;
begin
  cbFillMode.Updatevar;

  logCh:=tabChannel.tabIndex+1;
  SelectFillMode(paramStim.AutoFillInfo[logCh]^.FillMode);
end;

procedure TmultiGStim2.SelectFillMode(n:integer);
begin
  case n of
    0: begin
         PanelDigi.Visible:=false;
         PanelAna.Visible:=true;
       end;
    1: begin
         PanelAna.Visible:=false;
         PanelDigi.Visible:=true;
         PanelTrain.Visible:=false;
         TableFrameDigi.Visible:=true;
       end;
    2: begin
         PanelAna.Visible:=false;
         PanelDigi.Visible:=true;
         PanelTrain.Visible:=true;
         TableFrameDigi.Visible:=false;
       end;
  end;  
end;

procedure TmultiGStim2.SelectOutputMode;
var
  logCh:integer;
begin
{
  logCh:= tabChannel.TabIndex;

  PanelAna.Visible:= (paramstim.Channel[logCh+1].tpOut=to_analog);
  PanelDigi.Visible:= (paramstim.Channel[logCh+1].tpOut=to_digibit);

  if PanelAna.Visible then TableFrameAna.invalidate;
  if PanelDigi.Visible then TableFrameDigi.invalidate;
  }
end;


procedure TMultiGstim2.TabEditMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  {S'applique à TabEdit et TabChannel }

  if paramStim<>nil then
  with TtabControl(sender) do
  begin
    DraggedUO:=ParamStim.vector[tabIndex+1];
    if assigned(DraggedUO)  then
    begin
      DragUOsource:=Mstimulator;
      beginDrag(false);
    end;
  end;

end;



{**************************** Méthodes de TmultigraphStim ***************}

constructor TmultiGraphStim.create;
begin
  CreateOld;
  notPublished:=true;

  form:=TmultiGstim2.create(FormStm);
  installProcs;

  DlgList:=Tlist.Create;
end;

class function TmultiGraphStim.STMClassName:AnsiString;
begin
  STMclassName:='MGStim';
end;

procedure TmultiGraphStim.completeLoadInfo;
begin
  CheckOldIdent;
  {formG.color:=formG.BKcolorDef;}
  formG.setPoswin1(posWin,sizewin);


  dispose(poswin);
end;

procedure TmultiGraphStim.show;
begin
  formG2.execution;
end;

procedure TmultiGraphStim.execution;
begin
  formG2.execution;
end;


function TmultiGraphStim.formG2: TMultiGstim2;
begin
  result:=TMultiGstim2(form);
end;


function TmultiGraphStim.dragOverG(source: Tobject): boolean;
begin
  result:= assigned(DragUOsource)
            and
           ( (DragUOsource is TmultiGraphStim) )
            and
            assigned(draggedUO) and (draggedUO.plotable);

end;


function Mstimulator:TmultiGraphStim;
begin
  result:=DacMstim;
end;

procedure TMultiGstim2.changeDisplay(Sender: TObject);
{ S'applique à Bprevious , Bnext et Bupdate }
begin
  if (TbitBtn(sender)=Bprevious) and (NumSeq>1) then dec(NumSeq)
  else
  if (TbitBtn(sender)=Bnext) then inc(NumSeq);

  UpdateAllVar(self);
  ControleBuffers;

  paramStim.BuildStim(NumSeq);

  UpdateDisplay;
end;

procedure TMultiGstim2.UpdateDisplay;
begin
  Pepisode.Caption:=Istr(NumSeq);

  paramStim.RefreshVectors;
end;

procedure TMultiGstim2.BcheckClick(Sender: TObject);
begin
  UpdateAllVar(self);
  checkDurations;
end;

procedure TMultiGstim2.BsymbolNameClick(Sender: TObject);
var
  num:integer;
  st:AnsiString;

begin
  num:=tabChannel.tabIndex+1;

  st:=ChooseNrnSym.Execute(board);
  if st<>'' then
  with paramStim do
  begin
    nrnName[num]^:=st;
    esNrnSymbol.UpdateCtrl;
  end;

end;

procedure TMultiGstim2.changeBuffers(Sender: TObject);
begin
  FchangeBuffers:=true;
end;

procedure TMultiGstim2.ControleBuffers;
begin
  if FchangeBuffers then paramStim.initStimBuffers(false);
  FchangeBuffers:=false;
end;

Initialization
AffDebug('Initialization dacMstim3',0);

registerObject(TmultiGraphStim,sys);

{$IFDEF FPC}
{$I dacMstim3.lrs}
{$ENDIF}
end.
