unit ComExOpt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TCommandBoxOption = class(TForm)
    CBmask: TCheckBox;
    BOK: TButton;
    Bcancel: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure execution(var HideBox:boolean);
  end;

var
  CommandBoxOption: TCommandBoxOption;

implementation

{$R *.DFM}
procedure TCommandBoxOption.execution(var HideBox:boolean);
begin
  CBmask.checked:=hideBox;

  if showModal=mrOK then hideBox:=CBmask.checked;
end;


end.
