unit NIoptions;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont,AcqBrd1,
  debug0;

type
  TNIOpt = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    GroupBox1: TGroupBox;
    cb7: TCheckBox;
    cb6: TCheckBox;
    cb4: TCheckBox;
    cb5: TCheckBox;
    cb3: TCheckBox;
    cb2: TCheckBox;
    cb0: TCheckBox;
    cb1: TCheckBox;
    Label3: TLabel;
    cbUseTags: TCheckBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    cbTerminalConfig: TcomboBoxV;
    Label2: TLabel;
  private
    { Private declarations }
    p0:TacqInterface;
    cb:array[0..7] of TcheckBox;
  public
    { Public declarations }
    procedure execution(p:pointer);
  end;

function NIOpt: TNIOpt;

implementation

uses util1, NiBrd1, RTneuronBrd, NiDaqmx0;
{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FNIOpt: TNIOpt;

function NIOpt: TNIOpt;
begin
  if not assigned(FNIOpt) then FNIOpt:= TNIOpt.create(nil);
  result:= FNIOpt;
end;


procedure TNIOpt.execution(p:pointer);
var
  i:integer;
  NumTC:integer;
begin
  cb[0]:=cb0;
  cb[1]:=cb1;
  cb[2]:=cb2;
  cb[3]:=cb3;
  cb[4]:=cb4;
  cb[5]:=cb5;
  cb[6]:=cb6;
  cb[7]:=cb7;

  p0:=p;


  if p0 is TNIboard then
  with TNIboard(p0) do
  begin
    case SingleDiff of
      DAQmx_Val_NRSE  :      NumTC:=1;
      DAQmx_Val_Diff  :      NumTC:=2;
      DAQmx_Val_PseudoDiff:  NumTC:=3;
      else                   NumTC:=0;
    end;

    cbTerminalConfig.setVar(NumTC,g_longint,0);

    for i:=0 to 7 do cb[i].checked:=DigInputs[i];
    cbUseTags.Checked:=FuseTagStart;

    if showModal=mrOK then
    begin
      updateAllVar(self);
      case NumTC of
        1: SingleDiff:= DAQmx_Val_NRSE;
        2: SingleDiff:= DAQmx_Val_Diff;
        3: SingleDiff:= DAQmx_Val_PseudoDiff;
        else SingleDiff:= DAQmx_Val_RSE;
      end;

      for i:=0 to 7 do  DigInputs[i]:=cb[i].checked;
      FuseTagStart:=cbUseTags.Checked;
    end;
  end;
end;

Initialization
AffDebug('Initialization NIoptions',0);
{$IFDEF FPC}
{$I NIoptions.lrs}
{$ENDIF}
end.
