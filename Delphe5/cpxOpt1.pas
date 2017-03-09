unit cpxOpt1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,

  util1,stmObj,visu0, StdCtrls, editcont, debug0;

type
  TCpxOpt = class(TForm)
    Bok: TButton;
    Bcancel: TButton;
    Label2: TLabel;
    enCmin: TeditNum;
    Label12: TLabel;
    enCmax: TeditNum;
    Bautoscale: TButton;
    Label8: TLabel;
    enGamma: TeditNum;
    procedure BautoscaleClick(Sender: TObject);
  private
    { Déclarations privées }
    visu0:^TvisuInfo;
    cadrerC:TnotifyEvent;
  public
    { Déclarations publiques }
    function execution(var visu1:TvisuInfo;cadrerC1:TnotifyEvent):boolean;
  end;


function CpxOpt: TCpxOpt;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

{ TCpxOpt }

var
  FCpxOpt: TCpxOpt;

function CpxOpt: TCpxOpt;
begin
  if not assigned (FCpxOpt) then FcpxOpt:=TCpxOpt.Create(nil);
  result:=FCpxOpt;
end;

function TCpxOpt.execution(var visu1: TvisuInfo;cadrerC1:TnotifyEvent): boolean;
begin
  visu0:=@visu1;
  cadrerC:=cadrerC1;

  with visu0^ do
  begin
    enCmin.setvar(Cmin,T_double);
    enCmax.setvar(Cmax,T_double);
    enGamma.setvar(gammaC,T_single);
  end;
  if showModal=mrOK then updateAllVar(self);

  FCpxOpt.free;
  FcpxOpt:=nil;
end;

procedure TCpxOpt.BautoscaleClick(Sender: TObject);
begin
  if assigned(cadrerC) then
    begin
      cadrerC(sender);
      enCmin.updateCtrl;
      enCmax.updateCtrl;
    end;
end;

Initialization
AffDebug('Initialization cpxOpt1',0);
{$IFDEF FPC}
{$I cpxOpt1.lrs}
{$ENDIF}
end.
