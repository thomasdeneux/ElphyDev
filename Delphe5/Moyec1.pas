unit Moyec1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  EditCont;

type
  TmoyEc = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    comboBoxV1: TcomboBoxV;
    comboBoxV2: TcomboBoxV;
    comboBoxV3: TcomboBoxV;
    comboBoxV4: TcomboBoxV;
    comboBoxV5: TcomboBoxV;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations private }
  public
    { Déclarations public }
    function execution:boolean;
  end;

var
  moyEc: TmoyEc;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TmoyEc.Button1Click(Sender: TObject);
begin
  updateAllVar(self);
end;

function TmoyEc.execution:boolean;
  begin
    {
    with comboBoxV1 do
    begin
      setNumList(1,16,1);
      setvar(voieEc,t_smallInt,1);
    end;
    with comboBoxV2 do
    begin
      setNumList(0,12,1);
      setvar(memSup,t_smallInt,0);
    end;
    with comboBoxV3 do
    begin
      setNumList(0,12,1);
      setvar(memInf,t_smallInt,0);
    end;
    with comboBoxV4 do
    begin
      setNumList(0,12,1);
      setvar(memSigma,t_smallInt,0);
    end;
    with comboBoxV5 do
    begin
      setNumList(0,12,1);
      setvar(memCoeffVar,t_smallInt,0);
    end;
     }
    execution:=(showModal=mrOk);
  end;


Initialization
AffDebug('Initialization Moyec1',0);
  {$IFDEF FPC}
  {$I Moyec1.lrs}
  {$ENDIF}
end.
