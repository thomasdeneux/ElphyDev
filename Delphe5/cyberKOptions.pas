unit cyberKOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont;

type
  TCyberKOpt = class(TForm)
    Bcancel: TButton;
    BOK: TButton;
    GroupBox2: TGroupBox;
    Bbrowse: TButton;
    esCentralDir: TEdit;
    procedure BbrowseClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure execute(p:pointer);
  end;

function CyberKOpt: TCyberKOpt;

implementation

{$R *.dfm}

uses util1, Ddosfich, cyberKbrd2;

var
  FCyberKOpt: TCyberKOpt;

function CyberKOpt: TCyberKOpt;
begin
  if not assigned(FCyberKOpt) then FCyberKOpt:= TCyberKOpt.create(nil);
  result:= FCyberKOpt;
end;


{ TCyberKOpt }

procedure TCyberKOpt.execute(p:pointer);
begin
  with  TcyberK10interface(p) do
  begin
    esCentralDir.text:=CentralDir;
    if showModal=mrOK then
    begin
      CentralDir:= esCentralDir.text;
    end;
  end;
end;

procedure TCyberKOpt.BbrowseClick(Sender: TObject);
var
  st:AnsiString;
begin
  if GChooseDirectory('Choose a directory','',st)
    then esCentralDir.Text:=st;
end;

end.
