unit UnitTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont;

type
  TFtest = class(TForm)
    editNum1: TeditNum;
    editNum2: TeditNum;
    comboBoxV1: TcomboBoxV;
    Button1: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function execution(var x,y:extended;var n:integer):boolean;
  end;

var
  Ftest: TFtest;

implementation

{$R *.DFM}
function TFtest.execution(var x,y:extended;var n:integer):boolean;
begin
  editNum1.setvar(x,t_extended);
  editNum1.setminmax(0,1000);

  editNum2.setvar(y,t_extended);

  comboboxV1.setvar(n,t_longint,1);
  comboboxV1.setNumList(10,100,10);

  result:=(showModal=mrOK);
  if result then updateAllVar(self);
end;

end.
