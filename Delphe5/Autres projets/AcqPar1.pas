unit Acqpar1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, editcont,extCtrls,

  util1,Gdos,stmDef,stmObj,stmObv0;

type
  TTrackParams = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    Label2: TLabel;
    enChannel1: TeditNum;
    enPoint2: TeditNum;
    Label3: TLabel;
    Image1: TImage;
    CbtrackedObj: TComboBox;
    Label4: TLabel;
    Label1: TLabel;
    enPoint1: TeditNum;
    enChannel2: TeditNum;
    Label5: TLabel;
  private
    { Déclarations private }
  public
    { Déclarations public }
    procedure execution(var TrackOb:Tresizable;var chan1,chan2:integer);
  end;

var
  TrackParams: TTrackParams;



implementation

{$R *.DFM}

procedure TTrackParams.execution(var TrackOb:Tresizable;var chan1,chan2:integer);
begin

  enChannel1.setvar(chan1,t_smallInt);
  enChannel2.setvar(chan2,t_smallInt);

  enPoint1.setMinMax(0,9);
  enPoint1.setvar(TrackPoint[1],t_smallInt);

  enPoint2.setvar(TrackPoint[2],t_smallInt);
  enPoint2.setMinMax(0,9);

  InstalleComboBox(CBtrackedObj,trackOb,Tresizable);

  if showModal=mrOK then
    begin
      updateAllVar(self);

      with cbTrackedObj do
        if (itemIndex>=0) and (itemIndex<items.count-1)
          then TrackOb:=Tresizable(items.objects[itemIndex])
          else TrackOb:=nil;
    end;
end;



end.
