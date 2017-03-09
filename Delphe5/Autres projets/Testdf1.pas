unit Testdf1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,

  dataF0, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations private }
  public
    { Déclarations public }
    
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
var
  df:TdataFile;

procedure TForm1.Button1Click(Sender: TObject);
begin
  df.channel[1].show(self);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  df.evt[1].show(self);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  df:=TdataFile.create;
  df.installAcquis1File('c:\data\fred\top061\0698cr2.dat');
end;

end.
