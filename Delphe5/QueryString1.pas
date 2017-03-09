unit QueryString1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TQueryString = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function GetAString(st:Ansistring): AnsiString;

implementation

{$R *.dfm}

var
  QueryString0: TQueryString;


function GetAString(st:AnsiString): AnsiString;
begin
  QueryString0:=TQueryString.create(nil);
  with QueryString0 do
  begin
    Edit1.Text:= st;
    if showModal=mrOK
      then result:=Edit1.Text
      else result:='';
  end;
  QueryString0.Free;
end;


end.
