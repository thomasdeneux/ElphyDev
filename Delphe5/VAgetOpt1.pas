unit VAgetOpt1;

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
  TVAGetOptions = class(TForm)
    cbOverlap: TCheckBoxV;
    Bok: TButton;
    Bcancel: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    enLeft: TeditNum;
    Label2: TLabel;
    enRight: TeditNum;
    Label3: TLabel;
    enTop: TeditNum;
    Label4: TLabel;
    enBottom: TeditNum;
    GroupBox2: TGroupBox;
    enDx: TLabel;
    enDeltaX: TeditNum;
    Label8: TLabel;
    enDeltaY: TeditNum;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    enIdispMin: TeditNum;
    Label6: TLabel;
    enIdispMax: TeditNum;
    Label7: TLabel;
    enJdispMin: TeditNum;
    Label9: TLabel;
    enJdispMax: TeditNum;
    GroupBox4: TGroupBox;
    Label10: TLabel;
    enDxInt: TeditNum;
    Label11: TLabel;
    enDyInt: TeditNum;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Imini,Imaxi,Jmini,Jmaxi:integer;
  end;

function VAGetOptions: TVAGetOptions;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FVAGetOptions: TVAGetOptions;

function VAGetOptions: TVAGetOptions;
begin
  if not assigned(FVAGetOptions) then FVAGetOptions:= TVAGetOptions.create(nil);
  result:= FVAGetOptions;
end;


procedure TVAGetOptions.Button1Click(Sender: TObject);
begin
  enIdispMin.setCtrlValue(Imini);
  enIdispMax.setCtrlValue(Imaxi);
end;

procedure TVAGetOptions.Button2Click(Sender: TObject);
begin
  enJdispMin.setCtrlValue(Jmini);
  enJdispMax.setCtrlValue(Jmaxi);

end;

Initialization
AffDebug('Initialization VAgetOpt1',0);
{$IFDEF FPC}
{$I VAgetOpt1.lrs}
{$ENDIF}
end.
