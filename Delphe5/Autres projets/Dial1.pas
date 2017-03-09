unit dial1;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, editcont;

type
  TDial = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    CheckBoxV1: TCheckBoxV;
    CheckBoxV2: TCheckBoxV;
    editNum1: TeditNum;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dial: TDial;

implementation

{$R *.DFM}

procedure TDial.OKBtnClick(Sender: TObject);
begin
  updateAllVar(self);
end;

end.
