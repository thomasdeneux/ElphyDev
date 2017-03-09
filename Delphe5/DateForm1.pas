unit DateForm1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Mask, dateUtils,

  util1, editcont, ExtCtrls;

type
  TGetDateForm = class(TForm)
    MonthCalendar1: TMonthCalendar;
    BOK: TButton;
    Bcancel: TButton;
    PanelTime: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    enHour: TeditNum;
    enMinute: TeditNum;
    enSecond: TeditNum;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    TopTime: integer;
    TopButton:integer;
    TopDate:integer;

    left0,top0:integer;
    Height0:integer;
  public
    { Déclarations publiques }
    function Execute(var Adate: TdateTime; mode:integer; const x0:integer=-1; const y0:integer=-1): boolean;
  end;

function GetDateForm: TGetDateForm;


implementation

{$R *.dfm}


var
  FGetDateForm: TGetDateForm;

function GetDateForm: TGetDateForm;
begin
  if not assigned(FGetDateForm) then FGetDateForm:=TGetDateForm.Create(nil);
  result:=FGetDateForm;
end;


{ TGetDateForm }

function TGetDateForm.Execute(var Adate: TdateTime; mode:integer; const x0:integer=-1; const y0:integer=-1): boolean;
var
  yy,mm,dd,hh,min,sec,ms: word;
begin
  if (x0>=0) and (x0<screen.DesktopWidth-width) and (y0>=0) and (y0<screen.DesktopHeight-height) then
  begin
    left:=x0;
    top:=y0;
  end
  else
  begin
    left:=left0;
    top:=top0;
  end;

  MonthCalendar1.Date:= Adate;

  decodeDateTime(Adate,yy,mm,dd,hh,min,sec,ms);
  enHour.setVar(hh,g_word);
  enHour.setMinMax(0,23);
  enMinute.setVar(min,g_word);
  enMinute.setMinMax(0,59);
  enSecond.setVar(sec,g_word);
  enSecond.setMinMax(0,59);


  case mode of
    1: begin               // Date Only
         caption:='Set Date';
         PanelTime.Visible:=false;
         BOK.Top:=TopButton-(TopButton-TopTime);
         Bcancel.Top:=BOK.Top;

         height:=Height0-(TopButton-TopTime);
       end;
    2: begin               // Time Only
         caption:='Set Time';

         MonthCalendar1.Visible:=false;

         PanelTime.top:= TopTime-(TopTime-TopDate);

         BOK.Top:=TopButton-(TopTime-TopDate);
         Bcancel.Top:=BOK.Top;

         height:=Height0-(TopTime-TopDate);
       end;
    3: begin
         caption:='Set Date And Time';
         MonthCalendar1.Visible:=true;
         PanelTime.Visible:=true;

         MonthCalendar1.top:=topDate;
         PanelTime.Top:=topTime;
         BOK.Top:=TopButton;
         Bcancel.Top:=BOK.Top;

         height:=Height0;
       end;
  end;

  result:= (showModal=mrOK);
  if result then
  begin
    updateAllVar(self);
    case mode of
      1: Adate:=MonthCalendar1.Date;
      2: begin
           Adate:= encodeTime(hh,min,sec,0);
         end;
      3: begin
           Adate:=MonthCalendar1.Date;
           decodeDate(Adate,yy,mm,dd);
           Adate:= encodeDateTime(yy,mm,dd,hh,min,sec,0);

         end;
    end;
  end;
end;

procedure TGetDateForm.FormCreate(Sender: TObject);
begin
  TopTime:= PanelTime.Top;
  TopButton:=    BOK.top;
  TopDate:=      MonthCalendar1.Top;
  Height0:=      height;
  left0:=left;
  top0:=top;
end;

end.
