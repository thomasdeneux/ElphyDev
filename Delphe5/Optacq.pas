unit Optacq;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, editcont,
  stmDef;

type
  TAcqOpt1 = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    GroupBox1: TGroupBox;
    ac4: TCheckBox;
    ac2: TCheckBox;
    ac3: TCheckBox;
    ac1: TCheckBox;
    ac5: TCheckBox;
    ac6: TCheckBox;
    ac7: TCheckBox;
    ac8: TCheckBox;
    ac9: TCheckBox;
    ac10: TCheckBox;
    ac11: TCheckBox;
    ac12: TCheckBox;
    ac13: TCheckBox;
    ac14: TCheckBox;
    ac15: TCheckBox;
    ac16: TCheckBox;
    Label1: TLabel;
    enPoint1: TeditNum;
    enPoint2: TeditNum;
    Label2: TLabel;
  private
    { Déclarations private }
  public
    { Déclarations public }
    procedure execution;
  end;

var
  AcqOpt1: TAcqOpt1;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TacqOpt1.execution;
var
  i:integer;
begin
  for i:=0 to ComponentCount-1 do
    if (components[i] is TcheckBox) then
      with TcheckBox(components[i]) do
        if tag<>0 then checked:=(TrackMask and (word(1) shl (tag-1))<>0);

  enPoint1.setvar(TrackingPoint[1],t_smallInt);
  enPoint1.setMinMax(0,9);

  enPoint2.setvar(TrackingPoint[2],t_smallInt);
  enPoint2.setMinMax(0,9);



  if showModal=mrOK then
    begin
      updateAllVar(self);
      TrackMask:=0;
      for i:=0 to ComponentCount-1 do
        if (components[i] is TcheckBox) then
          with TcheckBox(components[i]) do
            if (tag<>0) and checked
              then trackmask:=trackMask or (word(1) shl (tag-1));


    end;

end;

Initialization
AffDebug('Initialization Optacq',0);
{$IFDEF FPC}
{$I Optacq.lrs}
{$ENDIF}
end.
