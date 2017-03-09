unit test0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,ExtCtrls,
  util1,RTcom1, Menus, DisplayFrame1;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Bstart: TButton;
    Bstop: TButton;
    Memo1: TMemo;
    DispFrame1: TDispFrame;
    Bcoo: TButton;
    Bclear: TButton;
    Brefresh: TButton;
    Lstat: TLabel;
    Lstatus: TLabel;
    Bflag: TButton;
    procedure BstartClick(Sender: TObject);
    procedure BstopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BcooClick(Sender: TObject);
    procedure BrefreshClick(Sender: TObject);
    procedure BclearClick(Sender: TObject);
    procedure BflagClick(Sender: TObject);
  private
    { Déclarations privées }

  public
    { Déclarations publiques }
    ButtonFlag:boolean;

  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}



procedure TForm1.BstartClick(Sender: TObject);
begin
  StartWinEmul;
end;

procedure TForm1.BstopClick(Sender: TObject);
begin
  StopWinEmul;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  StopWinEmul;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   DispFrame1.InstallArray(@stat,G_longint,1,200);
end;

procedure TForm1.BcooClick(Sender: TObject);
begin
  DispFrame1.Coo;
end;

procedure TForm1.BrefreshClick(Sender: TObject);
begin
  Lstat.Caption:='Nstat='+Istr(Nstat);
  invalidate;

end;

procedure TForm1.BclearClick(Sender: TObject);
begin
  fillchar(stat,sizeof(stat),0);
  Nstat:=0;
  Lstat.Caption:='Nstat='+Istr(Nstat);
  invalidate;
end;

procedure TForm1.BflagClick(Sender: TObject);
begin
  PostTest;
  {
  ButtonFlag:=not ButtonFlag;
  Bflag.Caption:=Bstr(ButtonFlag);
  }
end;

end.
