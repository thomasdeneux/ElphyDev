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
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

implementation

{$R *.dfm}

end.
