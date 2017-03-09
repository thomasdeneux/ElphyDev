unit PrintSS;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, editcont, ExtCtrls, Dialogs,
  debug0;

type
  TPrintArray = class(TForm)
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
    cbNames: TCheckBoxV;
    Label5: TLabel;
    enInterval: TeditNum;
    BOK: TButton;
    Bcancel: TButton;
    Label6: TLabel;
    enField: TeditNum;
    Label7: TLabel;
    enDeci: TeditNum;
    Bfont: TButton;
    FontDialog1: TFontDialog;
    procedure SearchClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure BfontClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    cadrerSS:TnotifyEvent;
    adFont:^Tfont;
  end;

var
  PrintArray: TPrintArray;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TPrintArray.SearchClick(Sender: TObject);
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

procedure TPrintArray.OKBtnClick(Sender: TObject);
begin
  updateAllVar(self);
end;

procedure TPrintArray.BfontClick(Sender: TObject);
begin
  if not assigned(adFont) then exit;
  FontDialog1.Font.Assign(adFont^);
  if FontDialog1.Execute then
  begin
    adFont^.assign(FontDialog1.Font);
  end;
end;

Initialization
AffDebug('Initialization PrintSS',0);
{$IFDEF FPC}
{$I PrintSS.lrs}
{$ENDIF}
end.
