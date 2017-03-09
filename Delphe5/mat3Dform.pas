unit Mat3Dform;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EditScroll1,editcont,

  util1,stmdef,stmObj,stmMat1, StdCtrls, Buttons, debug0;

type
  TMat3Dcom = class(TForm)
    EdsD0: TEditScroll;
    EdsThetaX: TEditScroll;
    EdsThetaZ: TEditScroll;
    EdsFov: TEditScroll;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    enZmin: TeditNum;
    Label3: TLabel;
    enZmax: TeditNum;
    sbGain: TscrollbarV;
    sbOffset: TscrollbarV;
    Label1: TLabel;
    Label4: TLabel;
    Bapply: TButton;
    BcadrerX: TBitBtn;
    cbMode3D: TcomboBoxV;
    Label5: TLabel;
    procedure BapplyClick(Sender: TObject);
    procedure sbGainScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbOffsetScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure BcadrerXClick(Sender: TObject);
    procedure cbMode3DChange(Sender: TObject);
  private
    { Déclarations privées }
    UO0:Tmatrix;
    zmin0,zmax0:float;
    ydebScr,yFinScr:float;
  public
    { Déclarations publiques }
    procedure init(uo:Tmatrix);
    procedure Change;
    procedure installSbZminZmax;
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TMat3Dcom.Change;
begin
  if assigned(uo0) then uo0.invalidate;
end;

procedure TMat3Dcom.init(uo: Tmatrix);
begin
  uo0:=uo;
  with uo0,inf3D do
  begin
    EdsD0.init(D0,T_single,0,1000,3);
    EdsThetaX.init(thetaX,T_single,-180,180,3);
    EdsThetaZ.init(thetaZ,T_single,-180,180,3);
    EdsFov.init(fov,T_single,10,170,3);

    EdsD0.onChange:=change;
    EdsThetaX.onChange:=change;
    EdsThetaZ.onChange:=change;
    EdsFov.onChange:=change;

    zmin0:=uo0.zmin;
    zmax0:=uo0.zmax;

    enZmin.setVar(visu.zmin,t_double);
    enZmax.setVar(visu.zmax,t_double);

    
    cbMode3D.setString('None|Wires|Triangles with light|Triangles with light and colors'+
                       '|Polygones with edges'+
                       '|DX');
    cbMode3D.setVar(mode,t_byte,0);
  end;

  installSbZminZmax;


end;

procedure TMat3Dcom.BapplyClick(Sender: TObject);
begin
  enZmin.UpdateVar;
  enZmax.UpdateVar;
  uo0.invalidate;
end;


procedure TMat3Dcom.installSbZminZmax;
var
  yamp,delta:float;
  x1,y1:integer;
begin
  with uo0 do
  begin
    if abs(Zmin)<abs(Zmax) then yamp:=abs(Zmax) else yamp:=abs(Zmin);
    ydebScr:=-yamp*10;
    yfinScr:=yamp*10;
    delta:=Zmax-Zmin;

    SBoffset.setParams(Zmin,ydebScr,yFinScr);
    SBoffset.dxSmall:=(Zmax-Zmin)/100;
    SBoffset.dxLarge:=(Zmax-Zmin)/10;

    SBgain.setParams(ln(abs(Zmax-Zmin)/(yFinScr-ydebScr)),ln(1/1000000),ln(4));
    SBgain.dxSmall:=ln(sqrt(2));
    SBgain.dxLarge:=ln(2);
  end;
end;


procedure TMat3Dcom.sbGainScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
var
  y0,delta,k:float;
begin
  if not (scrollCode in [scLineUp,scLineDown,scPageUp,scPageDown]) then exit;

  with uo0 do
  begin
    if Zmin=Zmax then exit;

    y0:=(Zmax+Zmin)/2;
    delta:=(Zmax-Zmin)/2;

    case scrollcode of
      scLineUp: k:=1/sqrt(2);
      scLineDown: k:=sqrt(2);
      scPageUp:   k:=1/2;
      scPageDown:   k:=2;
    end;

    Zmin:=y0-k*delta;
    Zmax:=y0+k*delta;

    enZmin.updateCtrl;
    enZmax.updateCtrl;

    installSbZminZmax;

    invalidate;
    if cpEnabled and(cpx<>0) then messageCpx;
  end;
end;



procedure TMat3Dcom.sbOffsetScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
var
  delta:float;
begin
  if scrollCode<>scTrack then
  with uo0 do
  begin
    delta:=Zmax-Zmin;
    Zmin:=x;
    Zmax:=x+delta;

    enZmin.updateCtrl;
    enZmax.updateCtrl;

    invalidate;
    if cpEnabled and(cpx<>0) then messageCpx;

    installSbZminZmax;
  end;
end;

procedure TMat3Dcom.BcadrerXClick(Sender: TObject);
begin
  with uo0 do
  begin
    autoscaleZ;
    if Zmin=Zmax then
      begin
        Zmin:=0;
        Zmax:=100;
      end;

    enZmin.updateCtrl;
    enZmax.updateCtrl;

    invalidate;
    if cpEnabled and (cpy<>0) then messageCpy;
  end;

end;

procedure TMat3Dcom.cbMode3DChange(Sender: TObject);
var
  old:byte;
begin
  old:=uo0.inf3D.mode;
  cbMode3D.UpdateVar;
  if old<>uo0.inf3D.mode
    then uo0.invalidate;
end;

Initialization
AffDebug('Initialization Mat3Dform',0);
{$IFDEF FPC}
{$I Mat3Dform.lrs}
{$ENDIF}
end.
