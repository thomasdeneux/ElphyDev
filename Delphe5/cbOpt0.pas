unit cbOpt0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont,
  util1, debug0;

type
  TCBoptions = class(TForm)
    cbSingleIO: TcomboBoxV;
    Label1: TLabel;
    BOK: TButton;
    Bcancel: TButton;
    cbUseDma: TCheckBoxV;
    Label8: TLabel;
    cbAdcBits: TcomboBoxV;
    Label9: TLabel;
    cbDacBits: TcomboBoxV;
    Bdefaults: TButton;
    Label2: TLabel;
    cbAdcBufferSize: TcomboBoxV;
    Label3: TLabel;
    enPacketSize: TeditNum;
    procedure BdefaultsClick(Sender: TObject);
  private
    { Private declarations }
    CBboard:pointer;
  public
    { Public declarations }

    procedure execution(Aboard:pointer);


  end;

function CBoptions: TCBoptions;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

uses CBbrd1;

var
  FCBoptions: TCBoptions;

function CBoptions: TCBoptions;
begin
  if not assigned(FCBoptions) then FCBoptions:= TCBoptions.create(nil);
  result:= FCBoptions;
end;


procedure TCBoptions.execution(Aboard:pointer);
var
  st:AnsiString;
  i:integer;
begin
  CBboard:=Aboard;


  with TcbInterFace(CBboard) do
  begin
    caption:=cbName+' options';

    cbSingleIO.setString('0|1000|5000|10000|20000');
    cbSingleIO.setNumvar(seuilSingleIO,t_single);

    cbuseDma.setVar(CBdma);

    cbAdcBits.SetNumList(8,16,1);
    cbAdcBits.setVar(cbAdcBitCount,g_longint,8);

    cbDacBits.SetNumList(8,16,1);
    cbDacBits.setVar(cbDacBitCount,g_longint,8);

    st:='64K x 1';
    for i:=2 to 20 do st:=st+'|64K x '+Istr(i);
    cbAdcBufferSize.SetString(st);
    cbAdcBufferSize.SetVar(cbBufferSize,t_byte,1);

    enPacketSize.setVar(cbPacketSize,g_longint);
    enPacketSize.setMinMax(1,100000);
  end;
  if showModal=mrOK then updateAllvar(self);

end;


procedure TCBoptions.BdefaultsClick(Sender: TObject);
begin
  with TcbInterFace(CBboard) do InitKnownBoard(CBname);
  updateAllCtrl(self);
end;

Initialization
AffDebug('Initialization cbOpt0',0);
{$IFDEF FPC}
{$I cbOpt0.lrs}
{$ENDIF}
end.
