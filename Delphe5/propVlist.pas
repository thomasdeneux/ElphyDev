unit propVlist;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont,

  stmObj,stmVlist0, debug0;

type
  TVlistProperties = class(TForm)
    Label5: TLabel;
    ENnbLigne: TeditNum;
    BOK: TButton;
    Bcancel: TButton;
    Label2: TLabel;
    enMtop: TeditNum;
    Label3: TLabel;
    enMbottom: TeditNum;
    cbShowNum: TCheckBoxV;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    enDxAff: TeditNum;
    Label1: TLabel;
    enDyAff: TeditNum;
    cbSelect: TCheckBoxV;
    sbDx: TScrollBar;
    sbDy: TScrollBar;
    procedure sbDxScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure sbDyScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
  protected
    { Déclarations privées }
    uo:TVlist0;
  public
    { Déclarations publiques }
    procedure install(w:TVlist0);virtual;
    function execution(w:TVlist0):boolean;virtual;
  end;

function VlistProperties: TVlistProperties;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FVlistProperties: TVlistProperties;

function VlistProperties: TVlistProperties;
begin
  if not assigned(FVlistProperties) then FVlistProperties:= TVlistProperties.create(nil);
  result:= FVlistProperties;
end;
procedure TVlistProperties.install(w:TVlist0);
begin
  uo:=w;

  with uo do
  begin
    caption:=ident+' properties';
    ENnbLigne.setVar(nbligne,T_longint);

    enDxAff.setVar(dxAff,t_single);
    enDxAff.setMinMax(-100,100);

    enDyAff.setVar(dyAff,t_single);
    enDyAff.setMinMax(-100,100);

    enMtop.setVar(Mtop,t_single);
    enMtop.setMinMax(0,100);

    enMbottom.setVar(Mbottom,t_single);
    enMbottom.setMinMax(0,100);

    cbShowNum.setVar(FVscale);
    cbSelect.setVar(affselect);

    sbDx.position:=round(Dxaff*10);
    sbDy.position:=round(Dyaff*10);
  end;
end;

function TVlistProperties.execution(w:TVlist0):boolean;
begin
  install(w);
  result:=showModal=mrOK;
  if result then updateAllVar(self);
end;


procedure TVlistProperties.sbDxScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  with uo do
  begin
    Dxaff:=sbDx.position/10;
    enDxAff.updateCtrl;

    case scrollCode of
      scTrack:begin
                gridON:=true;
                messageToRef(UOmsg_displayGUI,nil);
              end;
      else
        begin
          gridON:=false;
          invalidate;
        end;
    end;

  end;
end;

procedure TVlistProperties.sbDyScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  with uo do
  begin
    Dyaff:=sbDy.position/10;
    enDyAff.updateCtrl;

    case scrollCode of
      scTrack:begin
                gridON:=true;
                messageToRef(UOmsg_displayGUI,nil);
              end;
      else
        begin
          gridON:=false;
          invalidate;
        end;
    end;

  end;
end;

Initialization
AffDebug('Initialization propVlist',0);
{$IFDEF FPC}
{$I propVlist.lrs}
{$ENDIF}
end.
