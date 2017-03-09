unit PvidCom1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, ExtCtrls,

  util1, debug0;

type
  TVideoCommand = class(TForm)
    Pframe: TPanel;
    sbCurrent: TscrollbarV;
    procedure sbCurrentScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
  private
    { Private declarations }
  public
    { Public declarations }
    modifyIcur: procedure(i:integer) of object;
    procedure initParams(I,Imin,Imax:integer);
  end;

function VideoCommand: TVideoCommand;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FVideoCommand: TVideoCommand;

function VideoCommand: TVideoCommand;
begin
  if not assigned(FVideoCommand) then FVideoCommand:= TVideoCommand.create(nil);
  result:= FVideoCommand;
end;
procedure TVideoCommand.initParams(I,Imin,Imax:integer);
begin
  sbCurrent.setParams(I,Imin,Imax);
  Pframe.caption:=Istr(roundL(I));
end;


procedure TVideoCommand.sbCurrentScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  Pframe.caption:=Istr(roundL(x));

  if (scrollCode<>scPosition)
    then ModifyIcur(roundL(x));
end;

Initialization
AffDebug('Initialization PvidCom1',0);
{$IFDEF FPC}
{$I PvidCom1.lrs}
{$ENDIF}
end.
