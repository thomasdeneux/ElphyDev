unit DacScale1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont;

type
  st10=string[10];

  TDacScale1Form = class(TForm)
    GroupBox1: TGroupBox;
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
    BOK: TButton;
    Bcancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure execution(var j1,j2:integer;var y1,y2:single;var uy:st10);
  end;

var
  DacScale1Form: TDacScale1Form;

implementation

{$R *.DFM}

procedure TDacScale1Form.execution(var j1,j2:integer;var y1,y2:single;var uy:st10);
begin
  esUnits.setvar(uY,sizeof(uY)-1);

  enJ1.setvar(j1,T_longint);
  enJ2.setvar(j2,T_longint);

  enY1.setvar(Y1,T_single);
  enY2.setvar(Y2,T_single);

  if showModal=mrOK then updateAllVar(self);
end;

end.
