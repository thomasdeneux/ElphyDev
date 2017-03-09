unit testFrame1;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont;

type
  TFrameTest = class(TFrame)
    Lb: TLabel;
    ed: TeditNum;
    sb: TscrollbarV;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.dfm}

end.
