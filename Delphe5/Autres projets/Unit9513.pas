unit Unit9513;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont,

  util1, cbwgs520, Menus;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    enPulseWidth: TeditNum;
    enDelay: TeditNum;
    Label2: TLabel;
    enInterval: TeditNum;
    Label3: TLabel;
    enNumberOfPulses: TeditNum;
    Label4: TLabel;
    Lduration: TLabel;
    BGO: TButton;
    Bstop: TButton;
    MainMenu1: TMainMenu;
    Board1: TMenuItem;
    N01: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    N31: TMenuItem;
    N41: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure BGOClick(Sender: TObject);
    procedure BstopClick(Sender: TObject);
    procedure enPulseWidthExit(Sender: TObject);
    procedure N41Click(Sender: TObject);
  private
    { Déclarations privées }
    boardNum:integer;

    PulseW: float;
    Delay2:float;
    PulseInt:float;
    NbPulse:integer;

    TimeTot:float;
  public
    { Déclarations publiques }
    procedure UpdateDlg;
    procedure ProgOneTimer(num,gate, BasePeriod, Rep, Ld1, Hld1:integer);
    procedure ProgOneTimerB(num,gate, BasePeriod, Ld1:integer);
    procedure ProgCounters1(Lpulse, Delay2, Period, NbStim:real );
    procedure ProgStop;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


{ BasePeriod= 1, 10,100,1000 ou 10000 microsecondes
}
procedure  TForm1.ProgOneTimer(num,gate, BasePeriod, Rep, Ld1, Hld1:integer);
var
  freq:integer;
begin
  freq:=11;
  while BasePeriod>1 do
  begin
    BasePeriod:=BasePeriod div 10;
    inc(freq);
  end;

  cbC9513config(boardNum,num,gate,POSITIVEEDGE,freq,0,LOADANDHOLDREG, Rep,0,COUNTDOWN,TOGGLEONTC);
  cbCload(boardNum,100+num,Hld1);
  cbCload(boardNum,num,Ld1);
end;

procedure Tform1.ProgOneTimerB(num,gate, BasePeriod, Ld1:integer);
var
  freq:integer;
begin
  freq:=11;
  while BasePeriod>1 do
  begin
    BasePeriod:=BasePeriod div 10;
    inc(freq);
  end;

  cbC9513config(boardNum,num,gate,POSITIVEEDGE,freq,0,LOADREG, ONETIME,0,COUNTDOWN,TOGGLEONTC);
  cbCload(boardNum,num,Ld1);
end;

procedure Tform1.ProgCounters1(Lpulse, Delay2, Period, NbStim:real );   {en ms}
var
  ModeInf:boolean;
begin
  ModeInf:=(period*NbStim>=655350);

  cbDBitOut(boardNum,AUXPORT,0,0);

  cbC9513Init(boardNum,1, 0, 11, 0,0,0);

  ProgOneTimer(2,AHLgate,100,RECYCLE,round((period-Lpulse)*10),round(Lpulse*10));
  ProgOneTimer(1,AHLgate,10000,ONETIME,3, round(period*Nbstim*0.1));

  ProgOneTimer(5,AHLgate,100,RECYCLE,round((period-Lpulse)*10),round(Lpulse*10));
  if modeInf
    then ProgOneTimerB(4,AHLgate,10000,2)
    else ProgOneTimer(4,AHLgate,10000,ONETIME,2, round(period*Nbstim*0.1));
  ProgOneTimerB(3,AHLGate,100,100+round(delay2*10));

  cbDBitOut(boardNum,AUXPORT,0,1);
end;

procedure Tform1.ProgStop;   {en ms}
var
  i:integer;
begin
  cbDBitOut(boardNum,AUXPORT,0,0);
  cbC9513Init(boardNum,1, 0, 11, 0,0,0);

  for i:=1 to 5 do
    ProgOneTimer(i,AHLgate,100,ONETIME,2,1000);
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  if not initCBlib then
  begin
    messageCentral('MCC library not installed');
    halt;
  end;

  BoardNum:=0;

  pulseW:=1;
  Delay2:=0;
  PulseInt:=100;
  nbPulse:=10;

  enPulseWidth.setVar(PulseW,t_extended);
  enDelay.setVar(Delay2,g_extended);
  enInterval.setVar(PulseInt,g_extended);
  enNumberOfPulses.setvar(NbPulse,g_longint);
  Lduration.Caption:='';

end;

procedure TForm1.BGOClick(Sender: TObject);
begin
  updateDlg;
  ProgCounters1(pulseW,Delay2,pulseInt,nbPulse);
end;

procedure TForm1.BstopClick(Sender: TObject);
begin
  updateDlg;
  ProgStop;
end;

procedure TForm1.UpdateDlg;
begin
  updateAllVar(self);
  TimeTot:=PulseInt*NbPulse/1000;
  if TimeTot>655.350
    then Lduration.Caption:='Duration = Infinite'
    else Lduration.Caption:='Duration ='+Estr(TimeTot,3)+' seconds';

end;

procedure TForm1.enPulseWidthExit(Sender: TObject);
begin
  updateDlg;
end;

procedure TForm1.N41Click(Sender: TObject);
begin
  boardNum:=TmenuItem(sender).Tag-1;

  N01.Checked:= (boardNum=0);
  N11.Checked:= (boardNum=1);
  N21.Checked:= (boardNum=2);
  N31.Checked:= (boardNum=3);
  N41.Checked:= (boardNum=4);
end;

end.
