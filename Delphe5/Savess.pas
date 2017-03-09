unit Savess;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, editcont, ExtCtrls,
  util1,debug0;

type
  TSaveArray = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    FirstCol: TeditNum;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LastCol: TeditNum;
    FirstRow: TeditNum;
    LastRow: TeditNum;
    Search: TButton;
    Label5: TLabel;
    comboSep: TcomboBoxV;
    CheckBoxV1: TCheckBoxV;
    procedure SearchClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    cadrerSS:TnotifyEvent;
  end;

var
  SaveArray: TSaveArray;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TSaveArray.SearchClick(Sender: TObject);
begin
  if assigned(cadrerSS) then
    begin
      cadrerSS(sender);
      FirstCol.updateCtrl;
      LastCol.updateCtrl;
      FirstRow.updateCtrl;
      LastRow.updateCtrl;
    end;
end;

procedure TSaveArray.OKBtnClick(Sender: TObject);
begin
  updateAllVar(self);
end;

Initialization
AffDebug('Initialization Savess',0);
{$IFDEF FPC}
{$I Savess.lrs}
{$ENDIF}
end.
