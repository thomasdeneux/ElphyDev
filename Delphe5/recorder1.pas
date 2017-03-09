unit Recorder1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,
  StdCtrls,

  Menus, Buttons, ComCtrls,
  SynEditTypes,SynEdit,
  editcont,

  util1,Dgraphic, formrec0, debug0,

  acqDef2,acqInf2,stimInf2,
  acqBuf1,acqBrd1,
  Mtag2;



type
  TAcqCommandRec=
    record
      formRec:TformRec;
      ThVisible:boolean;
      ComVisible:boolean;
      AcqVisible:boolean;
    end;

type
  TAcqCommand = class(TForm)
    Pbottom: TPanel;
    Bstore: TButton;
    Pcomment: TPanel;
    Phistory: TPanel;
    Splitter1: TSplitter;
    Pintro: TPanel;
    Memo1: TMemo;
    Pthreshold: TPanel;
    TBUpper: TTrackBar;
    TBLower: TTrackBar;
    MainMenu1: TMainMenu;
    Panels1: TMenuItem;
    Thresholds1: TMenuItem;
    Comments1: TMenuItem;
    Btag1: TSpeedButton;
    Btag2: TSpeedButton;
    Btag4: TSpeedButton;
    Btag3: TSpeedButton;
    Btag5: TSpeedButton;
    Bclear: TButton;
    Ptime: TPanel;
    HisViewer: TSynEdit;
    cbRising: TCheckBoxV;
    PanelUpper: TPanel;
    Pupper: TPanel;
    PupperValue: TPanel;
    PanelLower: TPanel;
    Plower: TPanel;
    PlowerValue: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BstoreClick(Sender: TObject);
    procedure BrefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TBUpperChange(Sender: TObject);
    procedure TBLowerChange(Sender: TObject);
    procedure Thresholds1Click(Sender: TObject);
    procedure Buttons1Click(Sender: TObject);
    procedure Comments1Click(Sender: TObject);
    procedure BclearClick(Sender: TObject);
    procedure Btag1Click(Sender: TObject);
    procedure HisViewerSpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    procedure cbRisingClick(Sender: TObject);
  private
    { Déclarations privées }

    Btag:array[1..5] of TspeedButton;
    TagChoisi:integer;
    TagTime:TdateTime;
    sampIndex:integer;
    epAct:integer;

    procedure setVisibles;
  public
    { Déclarations publiques }
    Acqrec:TacqCommandRec;



    procedure initCfgInfo;
    procedure restoreForm;
    procedure InitAcq;
    procedure UpdateThresholds;
  end;

var
  AcqCommand: TAcqCommand;

implementation

uses wacq1,mdac,Daffac1,acqCom1;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}



{********************** Méthodes de TAcqCommand *******************************}

procedure TAcqCommand.FormCreate(Sender: TObject);
var
  i:integer;
begin
  with AcqRec do
  begin
    ThVisible:=true;
    AcqVisible:=true;
    ComVisible:=true;
  end;
  setVisibles;


  Btag[1]:=Btag1;
  Btag[2]:=Btag2;
  Btag[3]:=Btag3;
  Btag[4]:=Btag4;
  Btag[5]:=Btag5;


  for i:=1 to 5 do
    begin
      Btag[i].caption:=Istr(i);
      Btag[i].font.color:=clBlue;
      Btag[i].GroupIndex:=0;
      Btag[i].tag:=i;
    end;

end;

procedure TAcqCommand.FormDestroy(Sender: TObject);
begin
  ;
end;

procedure TAcqCommand.BrefreshClick(Sender: TObject);
begin
  if assigned(ThreadAff) then ThreadAff.FlagRefresh:=true;
end;




procedure TAcqCommand.FormShow(Sender: TObject);
var
  NiAnalog:boolean;
begin

  PupperValue.caption:=Estr(acqInf.seuilPlus,3);
  PlowerValue.caption:=Estr(acqInf.seuilMoins,3);

  TBlower.min:=board.getMinADC;
  TBlower.max:=board.getMaxADC;
  TBupper.min:=board.getMinADC;
  TBupper.max:=board.getMaxADC;

  TBlower.position:=acqInf.SeuilMoinsPts;
  TBupper.position:=acqInf.SeuilPlusPts;


  NiAnalog:= (acqInf.modeSynchro=MSanalogNI);

  PanelLower.Visible:= not NIanalog;
  TBlower.Visible:= not NIanalog;

  cbRising.Visible:= NIanalog;
  if NIanalog then
  begin
    Pupper.caption:='Threshold';
    cbRising.Left:=PanelLower.Left;
  end
  else Pupper.caption:='Upper Threshold';
  cbRising.Checked:=acqInf.NIRisingSlope;

end;

procedure TAcqCommand.TBUpperChange(Sender: TObject);
begin
  AcqInf.seuilPlusPts:=TBupper.position;
  PupperValue.caption:=Estr(acqInf.seuilPlus,3);

end;

procedure TAcqCommand.TBLowerChange(Sender: TObject);
begin
  AcqInf.seuilMoinsPts:=TBlower.position;
  PlowerValue.caption:=Estr(acqInf.seuilMoins,3);
end;

procedure TAcqCommand.Thresholds1Click(Sender: TObject);
begin
  with AcqRec do
  begin
    ThVisible:=not ThVisible;
    setVisibles;
  end;
end;

procedure TAcqCommand.Buttons1Click(Sender: TObject);
begin
  with AcqRec do
  begin
    AcqVisible:=not AcqVisible;
    setVisibles;
  end;
end;

procedure TAcqCommand.Comments1Click(Sender: TObject);
begin
  with AcqRec do
  begin
    ComVisible:=not ComVisible;
    setVisibles;
  end;
end;

procedure TAcqCommand.initCfgInfo;
begin
  AcqRec.formrec.setForm(self);
end;

procedure TAcqCommand.restoreForm;
begin
  setVisibles;
  AcqRec.formrec.restoreForm(Tform(self),nil);
end;

procedure TAcqCommand.setVisibles;
var
  NIanalog:boolean;
begin
  with AcqRec do
  begin
    Pthreshold.Visible:=ThVisible;
    thresholds1.Checked:=ThVisible;

    Pcomment.Visible:=ComVisible;
    Pbottom.Visible:=ComVisible;
    comments1.Checked:=ComVisible;


  end;
end;

procedure TAcqCommand.BclearClick(Sender: TObject);
var
  i:integer;
begin
  memo1.clear;
  for i:=1 to 5 do
    begin
      Btag[i].Down:=false;
      Btag[i].update;
    end;
  Ptime.caption:='';
end;

procedure TAcqCommand.Btag1Click(Sender: TObject);
var
  i:integer;
begin
  tagTime:=now;
  TagChoisi:=Tbutton(sender).tag ;

  i:=board.getSampleIndex;              {260309 getSampleIndex retourne un nb de points par voie}
  if acqInf.continu then
  begin
    SampIndex:=i;
    epAct:=1;
  end
  else
  begin
    SampIndex:=i mod acqInf.Qnbpt;        { Qnbpt1; }
    epAct:=i div acqInf.Qnbpt;            { Qnbpt1; }
  end;
  
  Ptime.caption:=Istr(tagChoisi)+':'+dateTimeToStr(tagTime);
end;

procedure TAcqCommand.BstoreClick(Sender: TObject);
var
  i,col:integer;
begin

  if tagChoisi=0 then
    begin
      i:=board.getSampleIndex;
      if acqInf.continu then
      begin
        SampIndex:=i;
        epAct:=1;
      end
      else
      begin
        SampIndex:=i mod acqInf.Qnbpt;        { Qnbpt1; }
        epAct:=i div acqInf.Qnbpt;            { Qnbpt1; }
      end;

      tagTime:=now;
      col:=clBlack;
    end
  else
    col:=MtagColors[tagChoisi];


  HisViewer.Lines.AddObject('---------------------------------------------------',pointer(Col));
  HisViewer.Lines.AddObject(Istr(tagChoisi)+':'+dateTimeToStr(tagTime),pointer(Col));

  with memo1 do
  for i:=0 to lines.count-1 do
    HisViewer.Lines.AddObject(lines[i],pointer(clBlack));

  with HisViewer do
  begin
    CaretX:=0;
    CaretY:=lines.Count-1;
  end;

  acquisition.insertUtag(tagChoisi,SampIndex,epAct,tagTime,memo1.Text);

  memo1.clear;

  HisViewer.Invalidate;

  for i:=1 to 5 do
    begin
      Btag[i].Down:=false;
      Btag[i].update;
    end;
  Ptime.caption:='';
  tagChoisi:=0;
end;



procedure TAcqCommand.InitAcq;
begin
  {$IFDEF FPC}
  HisViewer.clearAll;
  {$ELSE}
  HisViewer.clear;
  {$ENDIF}
end;


procedure TAcqCommand.HisViewerSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
begin
  special:=true;
  FG:=intG(HisViewer.Lines.Objects[Line]);
  BG:=clWhite;
end;

procedure TAcqCommand.UpdateThresholds;
begin
  formShow(self);
end;

procedure TAcqCommand.cbRisingClick(Sender: TObject);
begin
  AcqInf.NIRisingSlope:=cbRising.Checked;
end;

Initialization
AffDebug('Initialization Recorder1',0);
{$IFDEF FPC}
{$I Recorder1.lrs}
{$ENDIF}
end.
