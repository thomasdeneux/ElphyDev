unit NiRToptions;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, Buttons,
  util1, Ddosfich,AcqBrd1, debug0;

type
  TNiRTopt = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    GroupBox2: TGroupBox;
    Bexe: TBitBtn;
    EditExe: TEdit;
    GroupBox3: TGroupBox;
    Bbin: TBitBtn;
    EditBin: TEdit;
    GroupBox4: TGroupBox;
    Bhoc: TBitBtn;
    EditHoc: TEdit;
    GroupBox1: TGroupBox;
    enBus: TeditNum;
    Label1: TLabel;
    Label2: TLabel;
    enDevice: TeditNum;
    Label3: TLabel;
    cbAdcMode: TcomboBoxV;
    procedure BexeClick(Sender: TObject);
    procedure BbinClick(Sender: TObject);
    procedure BhocClick(Sender: TObject);
  private
    { Private declarations }
    p0:TacqInterface;
  public
    { Public declarations }
    procedure execution(p:pointer);
  end;

function NiRTopt: TNiRTopt;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
uses RTneuronBrd;

var
  FNiRTopt: TNiRTopt;

function NiRTopt: TNiRTopt;
begin
  if not assigned(FNiRTopt) then FNiRTopt:= TNiRTopt.create(nil);
  result:= FNiRTopt;
end;


procedure TNiRTopt.execution(p:pointer);
var
  i:integer;
begin
  p0:=p;

  if p0 is TRTNIinterface then
  begin
    EditExe.Text:=TRTNIinterface(p).stExeFile;
    EditBin.Text:=TRTNIinterface(p).stBinFile;
    EditHoc.Text:=TRTNIinterface(p).stHocFile;

    enBus.setVar(TRTNIinterface(p).NIbusNumber,g_longint);
    enDevice.setVar(TRTNIinterface(p).NIdeviceNumber,g_longint);

    cbAdcMode.setString(' Differential| Not Referenced Single Ended| Referenced Single Ended ');
    cbAdcMode.setVar(TRTNIinterface(p).RTparams^.AImode,t_longint,1 );

    if showModal=mrOK then
    begin
      updateAllVar(self);
      TRTNIinterface(p).stExeFile:=EditExe.Text;
      TRTNIinterface(p).stBinFile:=EditBin.Text;
      TRTNIinterface(p).stHocFile:=EditHoc.Text;
    end;
  end;
end;

procedure TNiRTopt.BexeClick(Sender: TObject);
begin
  EditExe.Text:= Gchoosefile('Choose the RTA file',EditExe.Text);
end;

procedure TNiRTopt.BbinClick(Sender: TObject);
begin
  EditBin.Text:= Gchoosefile('Choose the original Neuron EXE file',EditBin.Text);
end;

procedure TNiRTopt.BhocClick(Sender: TObject);
begin
  EditHoc.Text:= Gchoosefile('Choose the hoc file',EditHoc.Text);
end;

Initialization
AffDebug('Initialization NiRToptions',0);
{$IFDEF FPC}
{$I NiRToptions.lrs}
{$ENDIF}
end.
