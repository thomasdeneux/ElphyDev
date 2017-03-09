unit PreCPL1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  precomp2, StdCtrls;

type
  TMain = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Mwriteln(st:string);
  end;

var
  Main: TMain;

implementation

{$R *.DFM}

procedure TMain.Mwriteln(st:string);
begin
  memo1.lines.add(st);
end;

procedure TMain.Button1Click(Sender: TObject);
begin
  writeln1:=Mwriteln;
  precompile(debugPath+'test.fps');
end;

end.
