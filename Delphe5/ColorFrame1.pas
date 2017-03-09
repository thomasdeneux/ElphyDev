unit ColorFrame1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,
  debug0;

type
  TColFrame = class(TFrame)
    Button: TButton;
    Panel: TPanel;
    ColorDialog1: TColorDialog;
    procedure ButtonClick(Sender: TObject);
  private
    { Déclarations privées }
    adColor:^integer;
  public
    { Déclarations publiques }
    onChange: TnotifyEvent;
    
    procedure init(var color:integer);
    procedure reset(color:integer);

    
  end;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TColFrame.ButtonClick(Sender: TObject);
begin
    if assigned(adColor) then
    with colorDialog1 do
    begin
      color:=adcolor^;
      execute;
      adcolor^:=color;
      Panel.color:=color;

      if assigned(onChange) then onChange(self);
    end;
end;

procedure TColFrame.init(var color: integer);
begin
  adColor:=@color;
  Panel.Color:=color;
end;

procedure TColFrame.reset(color: integer);
begin
  AdColor:=nil;
  Panel.Color:=color;
end;

Initialization
AffDebug('Initialization ColorFrame1',0);
{$IFDEF FPC}
{$I ColorFrame1.lrs}
{$ENDIF}
end.
