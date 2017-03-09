unit dacMstim;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ComCtrls, ExtCtrls, StdCtrls, Buttons,

  util1,  editcont, Dgraphic,

  stmObj,
  {$IFDEF AcqElphy2}acqDef2 {$ELSE}AcqDef1 {$ENDIF}
  ,stmvec1, DacScale1,stmError,
  Ncdef2,AcqBrd1,debug0,Dtrace1,

  stmPg,acqCom1,acqBuf1,
  FdefDac2;






type
  TMstimulator = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabAna: TTabControl;
    DGana: TDrawGrid;
    cbTemp: TComboBox;
    Bscale: TButton;
    TabDigi: TTabControl;
    Label1: TLabel;
    cbDigiMode: TcomboBoxV;
    PageDigi: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    dgDigi: TDrawGrid;
    Label3: TLabel;
    enPulseWidth: TeditNum;
    enInterPulse: TeditNum;
    Label4: TLabel;
    Label5: TLabel;
    enInterBurst: TeditNum;
    Label6: TLabel;
    enPulsesPerBurst: TeditNum;
    Label7: TLabel;
    enBurstCount: TeditNum;
    Label8: TLabel;
    enDelay: TeditNum;
    Panel0: TPanel;
    cbActive: TCheckBoxV;
    Bcoo: TButton;
    Panel3: TPanel;
    Pepisode: TPanel;
    Label9: TLabel;
    Bupdate: TButton;
    Label10: TLabel;
    Bprevious: TBitBtn;
    Bnext: TBitBtn;
    PaintBox1: TPaintBox;
    cbDisplayed: TCheckBoxV;
    cbDispDigi: TCheckBoxV;
    cbDigiActive: TCheckBoxV;
    Panel1: TPanel;
    TabSheet5: TTabSheet;
    cbProgram: TCheckBoxV;
    Label2: TLabel;
    enIsi: TeditNum;
    GroupBox1: TGroupBox;
    LC1: TLabel;
    LC2: TLabel;
    LC3: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure DGanaDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DGanaSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure cbTempChange(Sender: TObject);
    procedure cbTempExit(Sender: TObject);
    procedure TabAnaChange(Sender: TObject);
    procedure DGdigiDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure dgDigiMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dgDigiSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure TabDigiChange(Sender: TObject);
    procedure cbDigiModeChange(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure BupdateClick(Sender: TObject);
    procedure BcooClick(Sender: TObject);
    procedure BpreviousClick(Sender: TObject);
    procedure BnextClick(Sender: TObject);
    procedure FormOnEnter(Sender: TObject);
    procedure cbDisplayedClick(Sender: TObject);
    procedure BscaleClick(Sender: TObject);
    procedure enStimDurationExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DGanaTopLeftChanged(Sender: TObject);
    procedure DGanaSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
    rectI:Trect;
    numSeq:integer;
    numSeqU:integer;

    vecA:array[0..1] of Tvector;
    vecD:array[0..15] of Tvector;

    PA: array[0..1] of PtabEntier;
    PD: array[0..15] of PtabEntier;

    buildDacEp:array[0..1] of Tpg2Event;
    buildDigiEp:array[0..15] of Tpg2Event;

    oldStimCount:integer;

    procedure initAnaVar(first:boolean);
    procedure initDigiVar(first:boolean);

    procedure setVectors;
    procedure initVectors;
    procedure doneVectors;
    procedure invalidateRect1(rect:Trect);
    procedure invalidateGraph;
    procedure invalidateGraphInside;

    procedure adjustDacVector(num:integer;FillZero:boolean);
    procedure buildDac(num:integer);

    procedure adjustDigiVector(num:integer;FillZero:boolean);
    procedure buildDigi(num:integer);

    procedure checkDurations;
  public
    { Public declarations }
    numseq0:integer;
    procedure execution;

    procedure Install(numSeqInit:integer);
    procedure Reset;

    procedure BuildPgStim;
    procedure setValues(n1,n2:integer);
    procedure initOutPutValues;
    procedure setOutPutValues(cnt:integer);


    procedure resetVectors;
    procedure setDacVectorParams(num:integer;vec:Tvector);
    procedure setDigiVectorParams(vec:Tvector);

    procedure setDacVector(num:integer;vec:Tvector);
    procedure setDigiVector(num:integer;vec:Tvector);

    procedure setCbTemp(ACol,ARow:integer);
  end;

var
  Mstimulator: TMstimulator;




procedure proTstimulator_buildDac(num,w:integer;var pu:PparamStim);pascal;
function fonctionTstimulator_buildDac(num:integer;var pu:PparamStim):integer;pascal;

procedure proTstimulator_buildDigi(num,w:integer;var pu:PparamStim);pascal;
function fonctionTstimulator_buildDigi(num:integer;var pu:PparamStim):integer;pascal;

procedure proTstimulator_outDac(num:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_inDIO(var pu:PparamStim):integer;pascal;

function fonctionTstimulator_Dy(num:integer;var pu:PparamStim):float;pascal;
procedure proTstimulator_Dy(num:integer;w:float;var pu:PparamStim);pascal;

function fonctionTstimulator_Y0(num:integer;var pu:PparamStim):float;pascal;
procedure proTstimulator_Y0(num:integer;w:float;var pu:PparamStim);pascal;

function fonctionTstimulator_unitY(num:integer;var pu:PparamStim):String;pascal;
procedure proTstimulator_unitY(num:integer;w:String;var pu:PparamStim);pascal;

procedure proTstimulator_setScale(num:integer;j1,j2:integer;y1,y2:float;var pu:PparamStim);pascal;


procedure proTstimulator_ActiveDigi(w:boolean;var pu:PparamStim);pascal;
function fonctionTstimulator_ActiveDigi(var pu:PparamStim):boolean;pascal;

procedure proTstimulator_ActiveDAC(w:smallint;var pu:PparamStim);pascal;
function fonctionTstimulator_ActiveDAC(var pu:PparamStim):smallint;pascal;

procedure proTstimulator_SetByProg(w:boolean;var pu:PparamStim);pascal;
function fonctionTstimulator_SetByProg(var pu:PparamStim):boolean;pascal;

procedure proTstimulator_AnaSegMode(num,seg:integer;w:integer;var pu:PparamStim);pascal;
function fonctionTstimulator_AnaSegMode(num,seg:integer;var pu:PparamStim):integer;pascal;

procedure proTstimulator_AnaSegDu(num,seg:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_AnaSegDu(num,seg:integer;var pu:PparamStim):float;pascal;

procedure proTstimulator_AnaSegAmp(num,seg:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_AnaSegAmp(num,seg:integer;var pu:PparamStim):float;pascal;

procedure proTstimulator_AnaSegDuInc(num,seg:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_AnaSegDuInc(num,seg:integer;var pu:PparamStim):float;pascal;

procedure proTstimulator_AnaSegAmpInc(num,seg:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_AnaSegAmpInc(num,seg:integer;var pu:PparamStim):float;pascal;

procedure proTstimulator_AnaSegVstart(num,seg:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_AnaSegVstart(num,seg:integer;var pu:PparamStim):float;pascal;

procedure proTstimulator_AnaSegVend(num,seg:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_AnaSegVend(num,seg:integer;var pu:PparamStim):float;pascal;

procedure proTstimulator_AnaSegRep1(num,seg:integer;w:integer;var pu:PparamStim);pascal;
function fonctionTstimulator_AnaSegRep1(num,seg:integer;var pu:PparamStim):integer;pascal;

procedure proTstimulator_AnaSegRep2(num,seg:integer;w:integer;var pu:PparamStim);pascal;
function fonctionTstimulator_AnaSegRep2(num,seg:integer;var pu:PparamStim):integer;pascal;

procedure proTstimulator_DigiMode(num:integer;w:integer;var pu:PparamStim);pascal;
function fonctionTstimulator_DigiMode(num:integer;var pu:PparamStim):integer;pascal;

procedure proTstimulator_DigiPulseTime(num,numP:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_DigiPulseTime(num,numP:integer;var pu:PparamStim):float;pascal;

procedure proTstimulator_DigiPulseDu(num,numP:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_DigiPulseDu(num,numP:integer;var pu:PparamStim):float;pascal;

procedure proTstimulator_DigiPulseTimeInc(num,numP:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_DigiPulseTimeInc(num,numP:integer;var pu:PparamStim):float;pascal;

procedure proTstimulator_DigiPulseDuInc(num,numP:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_DigiPulseDuInc(num,numP:integer;var pu:PparamStim):float;pascal;

procedure proTstimulator_DigiPulseRep1(num,numP:integer;w:integer;var pu:PparamStim);pascal;
function fonctionTstimulator_DigiPulseRep1(num,numP:integer;var pu:PparamStim):integer;pascal;

procedure proTstimulator_DigiPulseRep2(num,numP:integer;w:integer;var pu:PparamStim);pascal;
function fonctionTstimulator_DigiPulseRep2(num,numP:integer;var pu:PparamStim):integer;pascal;

procedure proTstimulator_DigiTrainPulseWidth(num:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_DigiTrainPulseWidth(num:integer;var pu:PparamStim):float;pascal;

procedure proTstimulator_DigiTrainPulseInt(num:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_DigiTrainPulseInt(num:integer;var pu:PparamStim):float;pascal;

procedure proTstimulator_DigiTrainBurstInt(num:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_DigiTrainBurstInt(num:integer;var pu:PparamStim):float;pascal;

procedure proTstimulator_DigiTrainPulseCount(num:integer;w:integer;var pu:PparamStim);pascal;
function fonctionTstimulator_DigiTrainPulseCount(num:integer;var pu:PparamStim):integer;pascal;

procedure proTstimulator_DigiTrainBurstCount(num:integer;w:integer;var pu:PparamStim);pascal;
function fonctionTstimulator_DigiTrainBurstCount(num:integer;var pu:PparamStim):integer;pascal;

procedure proTstimulator_DigiTrainDelay(num:integer;w:float;var pu:PparamStim);pascal;
function fonctionTstimulator_DigiTrainDelay(num:integer;var pu:PparamStim):float;pascal;



procedure proTstimulator_clearBuffers(var pu:PparamStim);pascal;
procedure proTstimulator_setDacVectorParams(num:integer;var vec:Tvector;var pu:PparamStim);
          pascal;
procedure proTstimulator_setDigiVectorParams(var vec:Tvector;var pu:PparamStim);
          pascal;
procedure proTstimulator_setDigiVector(num:integer;var vec:Tvector;var pu:PparamStim);
          pascal;
procedure proTstimulator_setDacVector(num:integer;var vec:Tvector;var pu:PparamStim);
          pascal;

procedure proTstimulator_outDio(w:integer;var pu:PparamStim);pascal;

procedure proTstimulator_SingleSeq(w:boolean;var pu:PparamStim);pascal;
function fonctionTstimulator_SingleSeq(var pu:PparamStim):boolean;pascal;


implementation


const
  periodeLimite=0.010;


{$R *.DFM}


{************************* Méthodes de TStimDialog ***************************}


procedure TMstimulator.execution;
begin
  numSeq:=numSeqU;
  if numseq<=0 then numSeq:=1;

  with paramStim do
  begin
    enIsi.setvar(acqInf.IsiSec,t_single);
  end;

  initAnaVar(true);
  initDigiVar(true);

  initVectors;
  setVectors;

  Pepisode.caption:=Istr(numSeq);
  checkDurations;

  showModal;

  updateAllvar(self);
  doneVectors;
  numSeqU:=numSeq;
end;

procedure TMstimulator.FormCreate(Sender: TObject);
var
  i:integer;
const
  colw1=70;
  colw2=90;

begin

  with DGana do
  begin
    colWidths[1]:=50;

    for i:=2 to 5 do colWidths[i]:=colW1;
    colwidths[6]:=colW1 div 2;
    colwidths[7]:=colW1 div 2;
    colwidths[8]:=60;
    colWidths[9]:=colW1;

    colWidths[0]:=clientwidth-colW1*6-50-60-8;
  end;


  with DGdigi do
  begin
    for i:=1 to 4 do colWidths[i]:=colW2;
    for i:=5 to 6 do colWidths[i]:=colW2 div 2;
    colWidths[0]:=clientwidth-colW2*5-8;
  end;


  numSeq:=1;

  for i:=0 to 1 do
    begin
      vecA[i]:=Tvector.create;
      with vecA[i] do
      begin
        notPublished:=true;
        ident:='_Dac'+Istr(i);
        title:='DAC'+Istr(i);
        tagUO:=i;
      end;
    end;

  for i:=0 to 15 do
    begin
      vecD[i]:=Tvector.create;
      with vecD[i] do
      begin
        notPublished:=true;
        ident:='_DIO'+Istr(i);
        tagUO:=i;
      end;
    end;
end;

procedure TMstimulator.FormDestroy(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to 1 do vecA[i].free;

  for i:=0 to 15 do vecD[i].free;
end;


procedure TMstimulator.initAnaVar(first:boolean);
var
  numA:integer;
begin
  if not first then updateAllvar(self);

  numA:=tabAna.tabIndex;

  with paramStim do
  begin
    with sAna[numA] do cbActive.setvar(active);
    cbActive.visible:=(numA=1);

    cbDigiActive.setvar(DigiActive);
    cbProgram.setvar(setByProgU);
  end;

  with DisplayParamStim do cbDisplayed.setvar(DispAna[numA]);
end;

procedure TMstimulator.initDigiVar(first:boolean);
var
  numDigi:integer;
begin
  if not first then updateAllvar(self);

  numDigi:=tabDigi.tabIndex;
  with paramStim.snum[tabDigi.tabIndex] do
  begin
    cbDigiMode.setvar(mode,t_byte,0);

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

  with DisplayParamStim do cbDispDigi.setvar(DispDigi);

  cbDigiModeChange(self);
end;

procedure TMstimulator.DGanaDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  st:string;
  x:integer;
  numA:integer;
begin
  numA:=tabAna.tabIndex;

  with paramStim,sana[numA] do
  begin

    st:='';

    case acol of
      0:  if arow>=1 then st:=Istr(arow);

      1:  if arow=0 then st:='Mode'
          else
          if seg[arow].mode=0 then st:='Step'
                              else st:='Ramp';

      2:  if arow=0 then st:='Duration(ms)'
          else st:=Estr(seg[arow].duree,3);

      3:  if arow=0 then st:='Amplitude('+unitY+')'
          else st:=Estr(seg[arow].amp,3);

      4:  if arow=0 then st:='Amplitude inc.'
          else st:=Estr(seg[arow].incAmp,3);

      5:  if arow=0 then st:='Duration inc.'
          else st:=Estr(seg[arow].incDuree,3);

      6:  if arow=0 then st:='Rep1'
          else st:=Istr(seg[arow].rep1);
      7:  if arow=0 then st:='Rep2'
          else st:=Istr(seg[arow].rep2);


      8:  if arow=0 then st:='Vstart'
          else st:=Estr(seg[arow].Vinit,3);

      9:  if arow=0 then st:='Vend'
          else st:=Estr(seg[arow].Vfinale,3);


    end;

    if (arow=0) or (acol=0)
      then x:=rect.left+1
      else x:=rect.right-DGana.canvas.TextWidth(st)-2;

    dgAna.canvas.TextOut(x,rect.top+1,st);
  end;

  if (arow=Dgana.Row) and (acol=dgAna.Col) then setCbTemp(Acol,Arow);
end;

procedure TMstimulator.DGanaSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  x:float;
  code,numA:integer;
begin
  numA:=tabAna.tabIndex;

  with dGana,paramStim,sana[numA] do
  begin
    val(value,x,code);
    if (code=0) and (Acol>1) and (Arow>0) then
      case acol of
        2: seg[arow].duree:=x;
        3: seg[arow].amp:=x;
        4: seg[arow].incamp:=x;
        5: seg[arow].incDuree:=x;
        6: seg[arow].rep1:=roundL(x);
        7: seg[arow].rep2:=roundL(x);
        8: seg[arow].Vinit:=x;
        9: seg[arow].Vfinale:=x;
      end;
  end;
end;

procedure TMstimulator.setCbTemp(ACol,ARow:integer);
var
  r:Trect;
begin
  r:=dgAna.cellRect(Acol,Arow);
  if not isRectEmpty(r) and (Acol=1) and (Arow>0) then
    with cbTemp do
    begin
      left:=r.left+dgana.left;
      top:=r.top+dgana.top;
      width:=dgAna.colWidths[Acol]+20;
      height:=dgAna.RowHeights[Arow];

      itemIndex:=paramStim.sana[tabAna.tabIndex].seg[Arow].mode;
      visible:=true;
    end
  else cbTemp.Visible:=false;
end;

procedure TMstimulator.DGanaSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (Acol>1) and (Arow>0)
    then dgAna.options:=dgAna.options+[goEditing]
    else dgAna.options:=dgAna.options-[goEditing];

  setCbTemp(Acol,Arow);
end;


procedure TMstimulator.DGanaTopLeftChanged(Sender: TObject);
begin
  cbTemp.Visible:=false;
end;

procedure TMstimulator.cbTempChange(Sender: TObject);
begin
  with dgana do
    paramStim.sana[tabAna.tabIndex].seg[row].mode:=cbTemp.itemIndex;
end;

procedure TMstimulator.cbTempExit(Sender: TObject);
begin
  cbTemp.visible:=false;
end;

procedure TMstimulator.TabAnaChange(Sender: TObject);
begin
  initAnaVar(false);
  dgAna.invalidate;
  cbTemp.visible:=false;
end;

procedure TMstimulator.DGdigiDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  st:string;
  x:integer;
  numA:integer;
begin

  numA:=tabDigi.tabIndex;

  with paramStim,snum[numA] do
  begin
    st:='';

    case acol of
      0:  if arow>=1 then st:=Istr(arow);

      1:  if arow=0 then st:='Time'
          else st:=Estr(pulse[arow].date,3);

      2:  if arow=0 then st:='Duration(ms)'
          else st:=Estr(pulse[arow].duree,3);

      3:  if arow=0 then st:='Time inc.'
          else st:=Estr(pulse[arow].incDate,3);

      4:  if arow=0 then st:='Duration inc.'
          else st:=Estr(pulse[arow].incDuree,3);

      5:  if arow=0 then st:='Rep1'
          else st:=Istr(pulse[arow].rep1);
      6:  if arow=0 then st:='Rep2'
          else st:=Istr(pulse[arow].rep2);

    end;

    if (arow=0) or (acol=0)
      then x:=rect.left+1
      else x:=rect.right-DGdigi.canvas.TextWidth(st)-2;

    dgDigi.canvas.TextOut(x,rect.top+1,st);
  end;

end;

procedure TMstimulator.dgDigiMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  row1,col1:integer;
  p:Tpoint;
begin
  dgDigi.mousetoCell(x,y,col1,row1);

  if (col1>0) and (row1>0)
    then dgDigi.options:=dgDigi.options+[goEditing]
    else dgDigi.options:=dgDigi.options-[goEditing];

end;

procedure TMstimulator.dgDigiSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  x:float;
  code,numA:integer;
begin
  numA:=tabDigi.tabIndex;

  with dGdigi,paramStim,snum[numA] do
  begin
    val(value,x,code);
    if (code=0) and (Acol>0) and (Arow>0) then
      case acol of
        1: pulse[arow].date:=x;
        2: pulse[arow].duree:=x;
        3: pulse[arow].incDate:=x;
        4: pulse[arow].incDuree:=x;
        5: pulse[arow].rep1:=roundL(x);
        6: pulse[arow].rep2:=roundL(x);

      end;
  end;
end;


procedure TMstimulator.TabDigiChange(Sender: TObject);
begin
  dgDigi.invalidate;
  initDigiVar(false);
end;

procedure TMstimulator.cbDigiModeChange(Sender: TObject);
begin
  pageDigi.activePageIndex:=cbDigiMode.itemIndex;
end;



procedure TMStimulator.adjustDacVector(num:integer;FillZero:boolean);
var
  nb1:integer;
begin
  if AcqInf.Fstim
    then nb1:=paramStim.nbpt
    else nb1:=100;

  with vecA[num] do
  begin
    if (data=nil) or (Istart<>0) or (Iend<>nb1-1) or (tpNum<>G_smallint)
      then initTemp1(0,nb1-1,G_smallint)
      else
      if fillZero then fill(0);

    PA[num]:=vecA[num].tb;

    dxu:=paramStim.dxu;
    x0u:=paramStim.x0u;

    dyu:=paramStim.dyu(num);
    y0u:=paramStim.y0u(num);

    unitX:=paramstim.unitX;
    unitY:=paramStim.sana[num].unitY;

    {messageCentral('DAC '+Estr(dyu,3)+' '+Estr(y0u,3) );}
  end;
end;

procedure TMStimulator.buildDac(num:integer);
var
  t,amp0:float;
  i,rep01,rep02:integer;
  numS:integer;
begin
  if not assigned(vecA[num]) then exit;

  numS:=numSeq-1;

  if not paramStim.sana[num].active then exit;

  adjustDacVector(num,true);

  with paramStim.sana[num] do
  begin
    t:=0;
    i:=1;
    while (i<=20) and (t<=vecA[num].Xend) and (seg[i].duree<>0) do
    with seg[i] do
    begin
      if rep1=0 then rep01:=maxEntierLong
                else rep01:=rep1;
      if rep2<=0 then rep02:=1
                 else rep02:=rep2;
      if mode=0 then
        begin
          amp0:=amp+((numS div rep02) mod rep01)*incAmp;
          vecA[num].Vmoveto(t,amp0);
          t:=t+duree+((numS div rep02) mod rep01)*incduree;
          vecA[num].VlineTo(t,amp0);
        end
      else
        begin
          vecA[num].Vmoveto(t,Vinit);
          t:=t+duree;
          vecA[num].Vlineto(t,Vfinale);
        end;

      inc(i);
    end;

  end;
end;

procedure TMStimulator.adjustDigiVector(num:integer;FillZero:boolean);
var
  nb:integer;
begin
  with vecD[num] do
  begin
    if (board.dacFormat=dacF1322) then
      begin
        Nb:=paramStim.nbpt;
        dxu:=paramStim.periodeGlobaleStim*paramStim.ActiveChannels;
        {x0u:=paramStim.x0u;}
      end
    else
      begin
        Nb:=paramStim.nbpt1;
        dxu:=paramStim.periodeGlobaleStim;
        x0u:=paramStim.x0u;
      end;

    if not AcqInf.Fstim or not paramStim.DigiActive then nb:=100;

    if (data=nil) or (Istart<>0) or (Iend<>nb-1) or (tpNum<>G_smallint)
      then initTemp1(0,nb-1,G_smallint)
      else
      if fillZero then fill(0);

    PD[num]:=vecD[num].tb;

    dyu:=1;
    y0u:=0;

    unitX:=paramstim.unitX;
    unitY:='';
  end;

end;

procedure TMStimulator.buildDigi(num:integer);
var
  t,amp0:float;
  i,rep01,rep02:integer;
  numP,numS,numseq1:integer;
  delta:float;
begin
  numSeq1:=numSeq-1;
  if not assigned(vecD[num]) then exit;
  if not paramStim.digiActive then exit;

  adjustDigiVector(num,true);

  with paramStim.snum[num] do
  begin
    if mode=0 then
      begin
        for i:=1 to 20 do
          with pulse[i] do
          begin
            if rep1=0 then rep01:=maxEntierLong
                      else rep01:=rep1;
            if rep2<=0 then rep02:=1
                       else rep02:=rep2;


            t:=date+((numSeq1 div rep02) mod rep01)*incdate;
            vecD[num].Vmoveto(t,1);
            delta:=duree+((numSeq1 div rep02) mod rep01)*incduree;
            t:=t+delta;
            if delta<>0 then vecD[num].VlineTo(t-vecD[num].dxu,1);
          end
      end
    else
      begin
        for numP:=1 to nbPulse do
          for numS:=1 to nbSalve do
            begin
              t:=delaiTrain+(numS-1)*cadenceSalve+(numP-1)*cadencePulse;
              vecD[num].Vmoveto(t,1);
              vecD[num].Vlineto(t+largeurPulse-vecD[num].dxu,1);
            end;
      end;

  end;
end;



procedure TMstimulator.setVectors;
var
  i:integer;
begin
  with paramStim do
  begin
    for i:=0 to 1 do buildDac(i);
    for i:=0 to 15 do buildDigi(i);
  end;
end;

procedure TMstimulator.initVectors;
var
  i:integer;
  nbDac:integer;      {nombre de DAC déduit de ActiveDac}
  nbpt1:integer;      {nombre de points total d'une séquence}

begin
  nbpt1:=paramStim.nbpt1;
  nbDac:=paramStim.ActiveChannels;

  with paramStim do
  begin
    for i:=0 to 1 do
      with vecA[i] do
      begin
        title:='DAC'+Istr(i);
        tagUO:=i;

        modeT:=DM_histo2;
        colorT:=DisplayParamStim.colorAna[i];
        Xmin:=DisplayParamStim.Xmin;
        Xmax:=DisplayParamStim.Xmax;
        Ymin:=DisplayParamStim.Ymin[i];
        Ymax:=DisplayParamStim.Ymax[i];

        x0u:=0;
        dxu:=paramStim.dxu;
        dyu:=paramStim.dyu(i);
        y0u:=paramStim.y0u(i);
        unitX:='ms';
        unitY:=sana[i].unitY;
      end;

    for i:=0 to 15 do
      with vecD[i] do
      begin
        tagUO:=i;

        modeT:=DM_histo2;
        colorT:=clred; {DisplayParamStim.colorDigi[i];}
        Xmin:=DisplayParamStim.Xmin;
        Xmax:=DisplayParamStim.Xmax;
        Ymin:=-1-2*i;
        Ymax:=30-2*i;

        x0u:=0;
        dxu:=paramstim.periodeGlobaleStim;
        dyu:=1;
        y0u:=0;

        unitX:='ms';
        unitY:='';

      end;
  end;

end;

procedure TMstimulator.doneVectors;
var
  i:integer;
begin
  for i:=0 to 1 do
    with vecA[i] do
    begin
      DisplayParamStim.colorAna[i]:=colorT;
      DisplayParamStim.Xmin:=Xmin;
      DisplayParamStim.Xmax:=Xmax;
      DisplayParamStim.Ymin[i]:=Ymin;
      DisplayParamStim.Ymax[i]:=Ymax;
    end;
end;

procedure TMstimulator.PaintBox1Paint(Sender: TObject);
var
  Finside:boolean;
  i:integer;
begin
  with paintbox1 do initGraphic(canvas,left,top,width,height);

  Finside:=false;

  for i:=0 to 1 do
    if DisplayParamStim.dispAna[i] then
    begin
      if not Finside and assigned(vecA[i]) then
        begin
          rectI:=vecA[i].getInsideWindow;

          with vecA[i] do
          begin
            if abs(invConvx(Xmax)-invConvx(Xmin))>3*(x2act-x1act)
              then modeT:=DM_line
              else modeT:=DM_histo2;
          end;

          vecA[i].display;
          Finside:=true;
        end
      else
      if assigned(vecA[i]) then
        begin
          with rectI do setWindow(left,top,right,bottom);

          with vecA[i] do
          begin
            if abs(invConvx(Xmax)-invConvx(Xmin))>3*(x2act-x1act)
              then modeT:=DM_line
              else modeT:=DM_histo2;
          end;

          vecA[i].displayInside(nil,false,false,false,false,0,0);
        end;
    end;

  for i:=0 to 3 do
    if DisplayParamStim.dispDigi then
    begin
      if not Finside and assigned(vecD[i]) then
        begin
          rectI:=vecD[i].getInsideWindow;

          with vecD[i] do
          begin
            if abs(invConvx(Xmax)-invConvx(Xmin))>3*(x2act-x1act)
              then modeT:=DM_line
              else modeT:=DM_histo2;
          end;

          vecD[i].display;
          Finside:=true;
        end
      else
      if assigned(vecD[i]) then
        begin
          with rectI do setWindow(left,top,right,bottom);
          with vecD[i] do
          begin
            if abs(invConvx(Xmax)-invConvx(Xmin))>3*(x2act-x1act)
              then modeT:=DM_line
              else modeT:=DM_histo2;
          end;

          vecD[i].displayInside(nil,false,false,false,false,0,0);
        end;
    end;

  doneGraphic;
end;

procedure TMstimulator.BupdateClick(Sender: TObject);
begin
  updateAllVar(self);
  setVectors;
  invalidateGraphInside;
end;

procedure TMstimulator.BcooClick(Sender: TObject);
var
  i,numA:integer;
begin
  numA:=tabAna.tabIndex;
  if vecA[numA].chooseCoo1 then
    begin
      vecA[1-numA].Xmin:=vecA[numA].Xmin;
      vecA[1-numA].Xmax:=vecA[numA].Xmax;

      for i:=0 to 15 do
        begin
          vecD[i].Xmin:=vecA[numA].Xmin;
          vecD[i].Xmax:=vecA[numA].Xmax;
        end;

      invalidateGraph;
    end;
end;

procedure TMstimulator.BnextClick(Sender: TObject);
begin
  with paramStim do
  begin
    inc(numSeq);
    updateAllVar(self);
    setVectors;
    invalidateGraphInside;
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
        setVectors;
        invalidateGraphInside;
        Pepisode.caption:=Istr(numSeq);
      end;
  end;
end;

procedure TMstimulator.invalidateRect1(rect:Trect);
begin
  with rect do
  begin
    inc(left,paintbox1.left);
    inc(right,paintbox1.left+1);
    inc(top,paintbox1.top);
    inc(bottom,paintbox1.top+1);
    windows.invalidateRect(handle,@rect,true);
  end;
end;

procedure TMstimulator.invalidateGraph;
begin
  with paintbox1 do invalidateRect1(rect(left,top,left+width,top+height));
end;

procedure TMstimulator.invalidateGraphInside;
begin
  invalidateRect1(rectI);
end;


procedure TMstimulator.FormOnEnter(Sender: TObject);
begin
  updateAllVar(self);
  setVectors;
  invalidateGraph;
end;

procedure TMstimulator.cbDisplayedClick(Sender: TObject);
begin
  updateAllVar(self);
  setVectors;
  invalidateGraph;
end;

procedure TMstimulator.BscaleClick(Sender: TObject);
var
  numA:integer;
begin
  numA:=tabAna.tabIndex;
  with paramStim,sana[numA] do
    DacScale1Form.execution(jru1,jru2,yru1,yru2,unitY);
end;


procedure TMstimulator.install(numSeqInit:integer);
var
  i:integer;
begin
  initVectors;

  for i:=0 to 1 do adjustDacVector(i,true);

  for i:=0 to 15 do adjustDigiVector(i,true);

  numSeq0:=numSeqInit;
  numSeq:=-1;
end;


procedure TMstimulator.BuildPgStim;
var
  i:integer;
begin
  if finexeU then exit;

  for i:=0 to 1 do
    if BuildDacEp[i].valid then
      begin
        if not AcqInf.continu then adjustDacVector(i,false);
        with BuildDacEp[i] do
          pg.executerBuildEp(ad,Numseq,typeUO(VecA[i]));
      end;

  for i:=0 to 15 do
    if BuildDigiEp[i].valid then
      begin
        if not AcqInf.continu then adjustDigiVector(i,false);
        with BuildDigiEp[i] do
         pg.executerBuildEp(ad,Numseq,typeUO(vecD[i]));
      end;
end;

procedure TMstimulator.setValues(n1,n2:integer);
var
  i,j,k,seq:integer;
  jA,numA:integer;
  y:smallint;

  nbDac:integer;      {nombre de DAC déduit de ActiveDac}
  nbpt1:integer;      {nombre de points total d'une séquence}

begin
  if finExeU then exit;


  nbpt1:=paramStim.nbpt1;
  nbDac:=paramStim.ActiveChannels;

  for i:=n1 to n2 do
    begin
      seq:=i div nbpt1 +1;
      if not AcqInf.continu then seq:=seq+numseq0;
      if (seq<>NumSeq) then
        begin
          if AcqInf.continu then
            begin
              for j:=0 to 1 do
                with VecA[j] do x0u:=Dxu*(nbpt1 div nbdac)*(seq-1);

              for j:=0 to 15 do
                with vecD[j] do x0u:=Dxu*(nbpt1 div nbdac)*(seq-1);
            end;

          affDebug('DAc Seq='+Istr(seq)+' '+Estr(VecA[0].x0u,3)+' '+'i='+Istr(i),0 );

          NumSeq:=seq;
          if paramStim.setByProg
            then BuildPgStim
            else setVectors;

        end;

      j:=i mod nbpt1;
      jA:=j div nbdac;
      numA:=j mod nbdac;

      if board.dacFormat=dacFdigi1200 then
      begin
        y:=PA[numA]^[jA ] shl 4;

        if paramStim.digiActive then
        for k:=0 to 15 do
          y:=y+ ord(PD[k]^[j]<>0) shl k;
      end
      else
      if (board.dacFormat=dacF1322) and (numA=nbdac-1) and paramStim.digiActive then
        begin
          y:=0;
          for k:=0 to 15 do
            y:=y+ ord(PD[k]^[jA]<>0) shl k;
        end
      else y:=PA[numA]^[jA ];

      mainDACbuf^[i mod nbptDAC]:=y;
    end;
end;

procedure TMstimulator.resetVectors;
begin
  adjustMainDac;
  fillchar(mainDACbuf^,nbptDac,0);
end;

procedure TMstimulator.setDacVector(num:integer;vec:Tvector);
var
  i,j:integer;
  nbpt:integer;

  nbDac:integer;      {nombre de DAC déduit de ActiveDac}
  nbpt1:integer;      {nombre de points total d'une séquence}

begin
  baseIndex:=0;
  nbpt1:=paramStim.nbpt1;
  nbDac:=paramStim.ActiveChannels;

  if nbpt1>nbptDac then exit;

  nbpt:=nbpt1 div nbdac;
  for i:=0 to nbpt-1 do
    begin
      j:=i*nbdac+num;

      if board.dacFormat=dacFdigi1200
        then mainDACbuf^[j]:=mainDACbuf^[j] or Vec.Jvalue[i] shl 4
        else mainDACbuf^[j]:=Vec.Jvalue[i];

    end;
  
end;

procedure TMstimulator.setDigiVector(num:integer;vec:Tvector);
var
  i,j:integer;
  nbpt:integer;

  nbDac:integer;      {nombre de DAC déduit de ActiveDac}
  nbpt1:integer;      {nombre de points total d'une séquence}


begin
  nbpt1:=paramStim.nbpt1;
  nbDac:=paramStim.ActiveChannels;
  nbpt:=nbpt1 div nbdac;

  if board.dacFormat=dacF1322 then
    for i:=0 to nbpt-1 do
      begin
        j:=i*nbdac+nbdac-1;
        mainDACbuf^[j]:=mainDACbuf^[j] or (ord(Vec.Jvalue[i]<>0) shl num);
      end
  else
  if board.dacFormat=dacFdigi1200 then
    for i:=0 to nbpt1-1 do
      begin
        j:=i div nbdac;
        mainDACbuf^[i]:=mainDACbuf^[i] or (ord(Vec.Jvalue[i]<>0) shl num);
      end;

  baseIndex:=0;
end;

procedure TMstimulator.setDacVectorParams(num:integer;vec:Tvector);
begin
  with vec do
  begin
    if (data=nil) or (Istart<>0) or (Iend<>paramStim.nbpt-1) or (tpNum<>G_smallint)
      then initTemp1(0,paramStim.nbpt-1,G_smallint);

    dxu:=paramStim.dxu;
    x0u:=paramStim.x0u;

    dyu:=paramStim.dyu(num);
    y0u:=paramStim.y0u(num);

    unitX:=paramstim.unitX;
    unitY:=paramStim.sana[num].unitY;
  end;
end;

procedure TMstimulator.setDigiVectorParams(vec:Tvector);
begin
  with vec do
  begin
    if (data=nil) or (Istart<>0) or (Iend<>paramStim.nbpt-1) or (tpNum<>G_smallint)
      then initTemp1(0,paramStim.nbpt-1,G_smallint);

    dxu:=paramStim.dxu;
    x0u:=paramStim.x0u;

    dyu:=1;
    y0u:=0;

    unitX:=paramstim.unitX;
    unitY:='';
  end;
end;


procedure TMstimulator.reset;
var
  i:integer;
begin
  doneVectors;
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

procedure TMstimulator.initOutPutValues;
begin
  if acqInf.Fstim and not acqInf.stepStim and not StimSingleSeq
    then setvalues(0,nbptDAC-1);

  oldStimCount:=nbptDac-1;

  //saveMainDac;
end;

procedure TMstimulator.setOutPutValues(cnt: integer);
begin
  if acqInf.Fstim and not acqInf.stepStim and not StimSingleSeq then
  begin
    cnt:=nbptDac+cnt-200;
    if cnt>oldStimCount then
    begin
      setvalues(oldStimCount+1,Cnt);

      oldStimCount:=Cnt;
    end;
  end;
end;


{**************************** Méthodes Stm ******************************}

var
  E_numDac:integer;
  E_numDigi:integer;
  E_dy:integer;
  E_scaleStim:integer;

  E_period:integer;
  E_duration:integer;

  E_readOnly:integer;
  E_objetInexistant:integer;

  E_segDac:integer;
  E_modeDac:integer;
  E_pulseDigi:integer;


{ le paramètre objet transmis est soit @paramStim, soit @stimInfo de Tdatafile
  paramStim est en lecture-écriture alors que stiminfo est en lecture seule
  pour les propriétés.
}
procedure controleReadOnlyP(pu:pointer);
begin
  if pu<>@paramStim then sortieErreur(E_readOnly);
end;

procedure verifierObjetP(var pu:PparamStim);
begin
  if not assigned(pu) then sortieErreur(E_objetInexistant);
end;

procedure proTstimulator_buildDac(num,w:integer;var pu:PparamStim);
begin
  controleReadOnlyP(pu);

  controleParam(num,0,1,E_NumDac);
  Mstimulator.BuildDacEp[num].setAd(w);
  paramStim.setByProgP:=true;
end;

function fonctionTstimulator_buildDac(num:integer;var pu:PparamStim):integer;
begin
  controleParam(num,0,1,E_NumDac);
  result:=Mstimulator.BuildDacEp[num].ad;
end;

procedure proTstimulator_buildDigi(num,w:integer;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,15,E_NumDigi);
  Mstimulator.BuildDigiEp[num].setAd(w);
  paramStim.setByProgP:=true;
end;

function fonctionTstimulator_buildDigi(num:integer;var pu:PparamStim):integer;
begin
  controleParam(num,0,15,E_NumDigi);
  result:=Mstimulator.BuildDigiEp[num].ad;
end;

procedure proTstimulator_outDac(num:integer;w:float;var pu:PparamStim);
var
  j:integer;
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_NumDac);

  with paramStim do
  begin
    j:=roundI((w-Y0u(num))/Dyu(num));
  end;
  board.outDac(num,j);
end;

function fonctionTstimulator_inDIO(var pu:PparamStim):integer;
begin
  controleReadOnlyP(pu);

  result:=board.inDIO;
end;

function fonctionTstimulator_Dy(num:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,1,E_NumDac);
  result:=pu^.Dyu(num);
end;


procedure proTstimulator_Dy(num:integer;w:float;var pu:PparamStim);
var
  y0:float;
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(w,1E-20,maxFloat,E_Dy);

  with paramStim,sana[num] do
  begin
    y0:=Y0u(num);

    jru1:=0;
    jru2:=2048;
    Yru1:=y0;
    Yru2:=2048*w+y0;
  end;
end;

function fonctionTstimulator_Y0(num:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,1,E_NumDac);
  result:=paramStim.Y0u(num);
end;


procedure proTstimulator_Y0(num:integer;w:float;var pu:PparamStim);
var
  Dy0:float;
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_numDac);

  with paramStim,sana[num] do
  begin
    Dy0:=DYu(num);

    jru1:=0;
    jru2:=2048;
    Yru1:=w;
    Yru2:=2048*Dy0+w;
  end;
end;

function fonctionTstimulator_unitY(num:integer;var pu:PparamStim):String;
begin
  verifierObjetP(pu);
  controleParam(num,0,1,E_NumDac);
  result:=pu^.sana[num].unitY;
end;


procedure proTstimulator_unitY(num:integer;w:String;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_numDac);

  paramStim.sana[num].unitY:=w;
end;

procedure proTstimulator_setScale(num:integer;j1,j2:integer;y1,y2:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_numDac);

  if (j1=j2) then sortieErreur(E_scaleStim);

  with paramStim.sana[num] do
  begin
    jru1:=j1;
    jru2:=j2;
    Yru1:=y1;
    Yru2:=y2;
  end;
end;


procedure proTstimulator_ActiveDigi(w:boolean;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  paramStim.digiActive:=w;
end;

function fonctionTstimulator_ActiveDigi(var pu:PparamStim):boolean;
begin
  verifierObjetP(pu);
  result:=pu^.digiActive;
end;


procedure proTstimulator_ActiveDAC(w:smallint;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(w,1,2,E_numDac);
  paramStim.sana[1].Active:=(w=2);
end;

function fonctionTstimulator_ActiveDAC(var pu:PparamStim):smallint;
begin
  verifierObjetP(pu);
  result:=ord(paramStim.sana[1].Active)+1;
end;


procedure proTstimulator_SetByProg(w:boolean;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  paramStim.setByProgU:=w;
end;

function fonctionTstimulator_SetByProg(var pu:PparamStim):boolean;
begin
  verifierObjetP(pu);
  result:=pu^.setByProgU;
end;

procedure proTstimulator_AnaSegMode(num,seg:integer;w:integer;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);
  controleParam(w,0,1,E_modeDac);

  paramStim.sana[num].seg[seg].mode :=w;
end;

function fonctionTstimulator_AnaSegMode(num,seg:integer;var pu:PparamStim):integer;
begin
  verifierObjetP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  result:=pu^.sana[num].seg[seg].mode;
end;

procedure proTstimulator_AnaSegDu(num,seg:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  paramStim.sana[num].seg[seg].duree :=w;
end;

function fonctionTstimulator_AnaSegDu(num,seg:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  result:=pu^.sana[num].seg[seg].duree;
end;

procedure proTstimulator_AnaSegAmp(num,seg:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  paramStim.sana[num].seg[seg].Amp :=w;
end;

function fonctionTstimulator_AnaSegAmp(num,seg:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  result:=pu^.sana[num].seg[seg].Amp;
end;

procedure proTstimulator_AnaSegDuInc(num,seg:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  paramStim.sana[num].seg[seg].IncDuree :=w;
end;

function fonctionTstimulator_AnaSegDuInc(num,seg:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  result:=pu^.sana[num].seg[seg].IncDuree;
end;

procedure proTstimulator_AnaSegAmpInc(num,seg:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  paramStim.sana[num].seg[seg].IncAmp :=w;
end;

function fonctionTstimulator_AnaSegAmpInc(num,seg:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  result:=pu^.sana[num].seg[seg].IncAmp;
end;

procedure proTstimulator_AnaSegVstart(num,seg:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  paramStim.sana[num].seg[seg].Vinit :=w;
end;

function fonctionTstimulator_AnaSegVstart(num,seg:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  result:=pu^.sana[num].seg[seg].Vinit;
end;

procedure proTstimulator_AnaSegVend(num,seg:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  paramStim.sana[num].seg[seg].Vfinale :=w;
end;

function fonctionTstimulator_AnaSegVend(num,seg:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  result:=pu^.sana[num].seg[seg].Vfinale;
end;

procedure proTstimulator_AnaSegRep1(num,seg:integer;w:integer;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  paramStim.sana[num].seg[seg].rep1 :=w;
end;

function fonctionTstimulator_AnaSegRep1(num,seg:integer;var pu:PparamStim):integer;
begin
  verifierObjetP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  result:=pu^.sana[num].seg[seg].rep1;
end;

procedure proTstimulator_AnaSegRep2(num,seg:integer;w:integer;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  paramStim.sana[num].seg[seg].rep2 :=w;
end;

function fonctionTstimulator_AnaSegRep2(num,seg:integer;var pu:PparamStim):integer;
begin
  verifierObjetP(pu);
  controleParam(num,0,1,E_numDac);
  controleParam(seg,1,20,E_segDac);

  result:=pu^.sana[num].seg[seg].rep2;
end;

procedure proTstimulator_DigiMode(num:integer;w:integer;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,7,E_numDigi);

  paramStim.snum[num].mode :=w;
end;

function fonctionTstimulator_DigiMode(num:integer;var pu:PparamStim):integer;
begin
  verifierObjetP(pu);
  controleParam(num,0,7,E_numDigi);

  result:=pu^.snum[num].mode;
end;

procedure proTstimulator_DigiPulseTime(num,numP:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,7,E_numDigi);
  controleParam(numP,1,20,E_PulseDigi);

  paramStim.snum[num].pulse[numP].date :=w;
end;

function fonctionTstimulator_DigiPulseTime(num,numP:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,7,E_numDigi);
  controleParam(numP,1,20,E_PulseDigi);

  result:=pu^.snum[num].pulse[numP].date;
end;

procedure proTstimulator_DigiPulseDu(num,numP:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,7,E_numDigi);
  controleParam(numP,1,20,E_PulseDigi);

  paramStim.snum[num].pulse[numP].duree :=w;
end;

function fonctionTstimulator_DigiPulseDu(num,numP:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,7,E_numDigi);
  controleParam(numP,1,20,E_PulseDigi);

  result:=pu^.snum[num].pulse[numP].duree;
end;

procedure proTstimulator_DigiPulseTimeInc(num,numP:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,7,E_numDigi);
  controleParam(numP,1,20,E_PulseDigi);

  paramStim.snum[num].pulse[numP].incdate :=w;
end;

function fonctionTstimulator_DigiPulseTimeInc(num,numP:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,7,E_numDigi);
  controleParam(numP,1,20,E_PulseDigi);

  result:=pu^.snum[num].pulse[numP].incdate;
end;

procedure proTstimulator_DigiPulseDuInc(num,numP:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,7,E_numDigi);
  controleParam(numP,1,20,E_PulseDigi);

  paramStim.snum[num].pulse[numP].IncDuree :=w;
end;

function fonctionTstimulator_DigiPulseDuInc(num,numP:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,7,E_numDigi);
  controleParam(numP,1,20,E_PulseDigi);

  result:=pu^.snum[num].pulse[numP].IncDuree;
end;

procedure proTstimulator_DigiPulseRep1(num,numP:integer;w:integer;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,7,E_numDigi);
  controleParam(numP,1,20,E_PulseDigi);

  paramStim.snum[num].pulse[numP].Rep1 :=w;
end;

function fonctionTstimulator_DigiPulseRep1(num,numP:integer;var pu:PparamStim):integer;
begin
  verifierObjetP(pu);
  controleParam(num,0,7,E_numDigi);
  controleParam(numP,1,20,E_PulseDigi);

  result:=pu^.snum[num].pulse[numP].Rep1;
end;

procedure proTstimulator_DigiPulseRep2(num,numP:integer;w:integer;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,7,E_numDigi);
  controleParam(numP,1,20,E_PulseDigi);

  paramStim.snum[num].pulse[numP].Rep2 :=w;
end;

function fonctionTstimulator_DigiPulseRep2(num,numP:integer;var pu:PparamStim):integer;
begin
  verifierObjetP(pu);
  controleParam(num,0,7,E_numDigi);
  controleParam(numP,1,20,E_PulseDigi);

  result:=pu^.snum[num].pulse[numP].Rep2;
end;

procedure proTstimulator_DigiTrainPulseWidth(num:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,7,E_numDigi);

  paramStim.snum[num].largeurPulse :=w;
end;

function fonctionTstimulator_DigiTrainPulseWidth(num:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,7,E_numDigi);

  result:=pu^.snum[num].largeurPulse;
end;

procedure proTstimulator_DigiTrainPulseInt(num:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,7,E_numDigi);

  paramStim.snum[num].CadencePulse :=w;
end;

function fonctionTstimulator_DigiTrainPulseInt(num:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,7,E_numDigi);

  result:=pu^.snum[num].CadencePulse;
end;

procedure proTstimulator_DigiTrainBurstInt(num:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,7,E_numDigi);

  paramStim.snum[num].CadenceSalve :=w;
end;

function fonctionTstimulator_DigiTrainBurstInt(num:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,7,E_numDigi);

  result:=pu^.snum[num].CadenceSalve;
end;

procedure proTstimulator_DigiTrainPulseCount(num:integer;w:integer;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,7,E_numDigi);

  paramStim.snum[num].nbPulse :=w;
end;

function fonctionTstimulator_DigiTrainPulseCount(num:integer;var pu:PparamStim):integer;
begin
  verifierObjetP(pu);
  controleParam(num,0,7,E_numDigi);

  result:=pu^.snum[num].nbPulse;
end;

procedure proTstimulator_DigiTrainBurstCount(num:integer;w:integer;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,7,E_numDigi);

  paramStim.snum[num].nbSalve :=w;
end;

function fonctionTstimulator_DigiTrainBurstCount(num:integer;var pu:PparamStim):integer;
begin
  verifierObjetP(pu);
  controleParam(num,0,7,E_numDigi);

  result:=pu^.snum[num].nbSalve;
end;

procedure proTstimulator_DigiTrainDelay(num:integer;w:float;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  controleParam(num,0,7,E_numDigi);

  paramStim.snum[num].delaiTrain :=w;
end;

function fonctionTstimulator_DigiTrainDelay(num:integer;var pu:PparamStim):float;
begin
  verifierObjetP(pu);
  controleParam(num,0,7,E_numDigi);

  result:=pu^.snum[num].delaiTrain;
end;





procedure proTstimulator_clearBuffers(var pu:PparamStim);
begin
  controleReadOnlyP(pu);

  Mstimulator.resetvectors;
  acqInf.stepStim:=true;
end;

procedure proTstimulator_setDacVectorParams(num:integer;var vec:Tvector;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  verifierVecteur(vec);
  controleParam(num,0,1,E_numDac);

  Mstimulator.setDacVectorParams(num,vec);
end;

procedure proTstimulator_setDigiVectorParams(var vec:Tvector;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  verifierVecteur(vec);

  Mstimulator.setDigiVectorParams(vec);
end;

procedure proTstimulator_setDigiVector(num:integer;var vec:Tvector;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  verifierVecteur(vec);
  controleParam(num,0,7,E_numDigi);

  Mstimulator.setDigiVector(num,vec);
  acqInf.stepStim:=true;
end;

procedure proTstimulator_setDacVector(num:integer;var vec:Tvector;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  verifierVecteur(vec);
  controleParam(num,0,1,E_numDac);

  Mstimulator.setDacVector(num,vec);
  acqInf.stepStim:=true;
end;


procedure proTstimulator_outDio(w:integer;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  board.outDio(w);
end;

procedure proTstimulator_SingleSeq(w:boolean;var pu:PparamStim);
begin
  controleReadOnlyP(pu);
  StimSingleSeq :=w;
end;

function fonctionTstimulator_SingleSeq(var pu:PparamStim):boolean;
begin
  verifierObjetP(pu);
  result:=StimSingleSeq;
end;





initialization


installError(E_NumDac, 'Tstimulator: invalid DAC channel number ');
installError(E_NumDigi, 'Tstimulator: invalid digital channel number ');
installError(E_Dy, 'Tstimulator: Dy must be strictly positive ');
installError(E_scaleStim, 'Tstimulator.setScale: invalid parameter ');

installError(E_duration, 'Tstimulator: duration out of range ');
installError(E_period, 'Tstimulator: period out of range ');

installError(E_readOnly, 'Tstimulator: cannot modify this object ');


paramStim.init;

DisplayParamStim.init;


end.
