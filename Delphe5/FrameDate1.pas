unit FrameDate1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  util1, dateForm1, StdCtrls;

type
  TFrame1 = class(TFrame)
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
    ad: ^TdateTime;
  public
    { Déclarations publiques }
    procedure init(var TheDate: TdateTime);
    procedure reset(Adate:TdateTime);
  end;

implementation

{$R *.dfm}

procedure TFrame1.Button1Click(Sender: TObject);
begin
  if assigned(Ad) then
  begin
    getDateForm.Execute(ad^,1);
    Edit1.Text:=DateTimeToString(Ad^);
  end;  
end;

procedure TFrame1.init(var TheDate: TdateTime);
begin
  Ad:= @TheDate;
  Edit1.Text:=DateTimeToString(TheDate);
end;

procedure TFrame1.reset(Adate: TdateTime);
begin
  Ad:=nil;
  Edit1.Text:=DateTimeToString(ADate);
end;

end.
