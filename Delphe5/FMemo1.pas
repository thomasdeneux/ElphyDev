unit FMemo1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, editcont, ExtCtrls, ComCtrls,
  debug0;

type
  TstmMemoForm = class(TForm)
    MainMenu1: TMainMenu;
    FOnt1: TMenuItem;
    Options1: TMenuItem;
    FontDialog1: TFontDialog;
    Memo1: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    enX: TeditNum;
    enY: TeditNum;
    Label2: TLabel;
    Bvalidate: TButton;
    UpDownX: TUpDown;
    UpDownY: TUpDown;
    procedure FOnt1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    fontS:Tfont;
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TstmMemoForm.FOnt1Click(Sender: TObject);
begin
  if assigned(fontS) then
  with FontDialog1 do
  begin
    font.assign(FontS);
    execute;
    FontS.assign(font);
    memo1.font.Assign(font);
  end;
end;

Initialization
AffDebug('Initialization FMemo1',0);
{$IFDEF FPC}
{$I FMemo1.lrs}
{$ENDIF}
end.
