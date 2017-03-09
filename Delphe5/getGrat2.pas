unit getGrat2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Getdeg0, StdCtrls, editcont,

  util1,stmdef, Debug0;

type
  TgetGrating2 = class(TDegform)
    cbCircle: TCheckBox;
    Label5: TLabel;
    enOrient: TeditNum;
    Label6: TLabel;
    enContrast: TeditNum;
    Label7: TLabel;
    enPeriod: TeditNum;
    Label8: TLabel;
    enPhase: TeditNum;
    sbOrient: TscrollbarV;
    sbContrast: TscrollbarV;
    sbPeriod: TscrollbarV;
    sbPhase: TscrollbarV;
    procedure cbCircleClick(Sender: TObject);
    procedure sbOrientScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure enOrientExit(Sender: TObject);
  private
    Pcontrast,Pperiode,Pphase,Porientation:Psingle;
  public
    { Déclarations publiques }
    Fupdate1:boolean;
    circleD: procedure (v:boolean) of object;

    procedure setGratingParams(var contrast,periode,phase,orientation:single;
          Fellipse:boolean );
  end;

var
  getGrating2: TgetGrating2;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TgetGrating2.setGratingParams(var contrast,periode,phase,orientation:single;
          Fellipse:boolean );
begin
  Fupdate1:=true;

  Pcontrast:=@contrast;
  Pperiode:=@periode;
  Pphase:=@phase;
  Porientation:=@orientation;

  enContrast.setVar(contrast,T_single);
  enContrast.setMinMax(0,1);
  enContrast.tag:=101;

  enPhase.setVar(Phase,T_single);
  enPhase.setMinMax(0,0);
  enPhase.tag:=102;

  enPeriod.setVar(Periode,T_single);
  enPeriod.setMinMax(0,10000);
  enPeriod.Decimal:=2;
  enPeriod.tag:=103;

  enOrient.setVar(orientation,T_single);
  enOrient.setMinMax(0,0);
  enOrient.tag:=104;

  sbContrast.setParams(contrast,0.01,1);
  sbContrast.dxSmall:=0.01;
  sbContrast.dxLarge:=0.1;
  sbContrast.tag:=101;

  sbPhase.setParams(phase,-360,360);
  sbPhase.tag:=102;

  sbPeriod.setParams(periode,Ddegmin,DegXmax);
  sbPeriod.dxSmall:=0.01;
  sbPeriod.dxLarge:=0.1;

  sbPeriod.tag:=103;

  sbOrient.setParams(orientation,-360,360);
  sbOrient.tag:=104;

  cbCircle.checked:=Fellipse;

  Fupdate1:=false;
end;



procedure TgetGrating2.cbCircleClick(Sender: TObject);
begin
  if assigned(circleD) then circleD(cbCircle.checked);

end;

procedure TgetGrating2.sbOrientScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  case TscrollbarV(sender).tag of
    101: begin
           Pcontrast^:=x;
           enContrast.updateCtrl;
         end;
    102: begin
           Pphase^:=x;
           enPhase.updateCtrl;
         end;
    103: begin
           Pperiode^:=x;
           enPeriod.updateCtrl;
         end;
    104: begin
           Porientation^:=x;
           enOrient.updateCtrl;
         end;
  end;

  majPos;
end;

procedure TgetGrating2.enOrientExit(Sender: TObject);
begin
  if Fupdate1 then exit;

  TeditNum(sender).updatevar;
  case TeditNum(sender).tag of
    101: sbContrast.setParams(Pcontrast^,0.01,1);
    102: sbPhase.setParams(Pphase^,-360,360);
    103: sbPeriod.setParams(Pperiode^,DDegMin,DegXmax);
    104: sbOrient.setParams(Porientation^,-360,360);
  end;

  majPos;
end;

Initialization
AffDebug('Initialization getGrat2',0);
{$IFDEF FPC}
{$I getGrat2.lrs}
{$ENDIF}
end.
