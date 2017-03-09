unit Fplayer1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, ComCtrls, StdCtrls, editcont,

  util1,stmdef,stmObj,stmPlay1,debug0;

type
  TFilePlayer = class(TForm)
    Panel1: TPanel;
    SBplay: TSpeedButton;
    SBstop: TSpeedButton;
    SBmute: TSpeedButton;
    TBvolume: TTrackBar;
    Panel2: TPanel;
    Pposition: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Pgain: TPanel;
    UDgain: TUpDown;
    Panel10: TPanel;
    Panel11: TPanel;
    Poffset: TPanel;
    UDoffset: TUpDown;
    Panel4: TPanel;
    SBposition: TscrollbarV;
    enPosition: TeditNum;
    procedure SBpositionScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure SBplayClick(Sender: TObject);
    procedure SBstopClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure UDgainClick(Sender: TObject; Button: TUDBtnType);
    procedure TBvolumeChange(Sender: TObject);
  private
    { Déclarations privées }
    owner0:TvectorPlayer;
  public
    { Déclarations publiques }

    procedure installe(UOowner:TvectorPlayer);
    procedure setControls;
  end;

function FilePlayer: TFilePlayer;

implementation


{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FFilePlayer: TFilePlayer;

function FilePlayer: TFilePlayer;
begin
  if not assigned(FFilePlayer) then FFilePlayer:= TFilePlayer.create(nil);
  result:= FFilePlayer;
end;

{ TFilePlayer }

procedure TFilePlayer.setControls;
begin
  owner0.VerifyInfo;

  with owner0.info do
    sbPosition.setParams(p0,pstart,pend);
  sbPosition.dxSmall:=0.1;
  sbPosition.dxLarge:=1;

  enPosition.setVar(owner0.info.p0,t_extended);

  Pgain.Caption:=Estr(owner0.Gm,3);

  TBvolume.Position:=owner0.Volume;
end;

procedure TFilePlayer.installe(UOowner: TvectorPlayer);
begin
  owner0:=UOowner;
  setControls;
end;

procedure TFilePlayer.SBpositionScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  owner0.info.P0:=x;
  enposition.UpdateCtrl;
end;

procedure TFilePlayer.SBplayClick(Sender: TObject);
begin
  owner0.PlayC;
end;

procedure TFilePlayer.SBstopClick(Sender: TObject);
begin
  owner0.stopC;
end;

procedure TFilePlayer.FormHide(Sender: TObject);
begin
  owner0.hideC;
end;

procedure TFilePlayer.UDgainClick(Sender: TObject; Button: TUDBtnType);
begin
  if button=btNext
    then owner0.Gm:=owner0.Gm*10
    else owner0.Gm:=owner0.Gm/10;

  Pgain.Caption:=Estr(owner0.Gm,3);
end;

procedure TFilePlayer.TBvolumeChange(Sender: TObject);
var
  w:longword;
begin
  w:=TBvolume.Position;
  owner0.Volume:=w+w shl 16;
end;

Initialization
AffDebug('Initialization Fplayer1',0);
{$IFDEF FPC}
{$I Fplayer1.lrs}
{$ENDIF}
end.
