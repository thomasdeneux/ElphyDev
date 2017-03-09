program ViewDac;

uses
  Forms,
  DacView1 in 'DacView1.pas' {DACview},
  stmSys0 in 'stmSys0.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDACview, DACview);
  Application.Run;
end.
