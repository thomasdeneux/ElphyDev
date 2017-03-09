unit XYZ3Dform;

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

  util1,stmdef,stmObj,stmXYZplot1, StdCtrls, Buttons, ComCtrls,
  ColorFrame1, ExtCtrls,
  debug0;

type
  TXYZplot3Dcom = class(TForm)
    EdsD0: TEditScroll;
    EdsThetaX: TEditScroll;
    EdsThetaZ: TEditScroll;
    EdsFov: TEditScroll;
    BinitD0: TBitBtn;
    GroupBox1: TGroupBox;
    enNum: TeditNum;
    Label1: TLabel;
    UpDown1: TUpDown;
    Panel1: TPanel;
    Label2: TLabel;
    cbMode: TcomboBoxV;
    ColFrame1: TColFrame;
    Label3: TLabel;
    enSymbSize: TeditNum;
    Lnbpts: TLabel;
    Label4: TLabel;
    enSymbSize2: TeditNum;
    EsTheta: TEditScroll;
    EsPhi: TEditScroll;
    cbScaling3D: TCheckBoxV;
    cbOrtho: TCheckBoxV;
    procedure BinitD0Click(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure enNumChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    UO0:TXYZplot;
    zmin0,zmax0:float;
    ydebScr,yFinScr:float;
    NumP:integer;

    procedure setPolyline;
  public
    { Déclarations publiques }
    procedure init(uo:TXYZplot);
    procedure Change;
    procedure change1(sender:Tobject);
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TXYZplot3Dcom.Change;
begin
  if assigned(uo0) then uo0.invalidate;
end;

procedure TXYZplot3Dcom.init(uo: TXYZplot);
begin
  uo0:=uo;
  with uo0,inf3D do
  begin
    if NumP>uo0.PolylineCount then NumP:=uo0.PolylineCount;
    if NumP<1 then NumP:=1;

    EdsD0.init(D0,T_single,D0/100,D0*100,3);            // D0*30
    EdsD0.sb.dxSmall:=D0/100;
    EdsD0.sb.dxLarge:=D0/10;

    EdsThetaX.init(ThetaD,T_single,-180,180,3);
    EdsThetaZ.init(PhiD,T_single,-180,180,3);
    EdsFov.init(fov,T_single,1,170,3);                 // 10 au lieu de 1

    EdsD0.onChange:=change;
    EdsThetaX.onChange:=change;
    EdsThetaZ.onChange:=change;
    EdsFov.onChange:=change;

    cbScaling3D.setVar(Scaling3D);
    cbScaling3D.OnClick:=change1;
    cbScaling3D.UpdateVarOnToggle:=true;

    cbOrtho.setVar(Fortho);
    cbOrtho.OnClick:=change1;
    cbOrtho.UpdateVarOnToggle:=true;

    zmin0:=uo0.zmin;
    zmax0:=uo0.zmax;

    EnNum.setVar(NumP,g_longint);

    setPolyline;
  end;

end;

procedure TXYZplot3Dcom.BinitD0Click(Sender: TObject);
begin
  UO0.initD0;
  with UO0 do edsD0.init(inf3D.D0,T_single,D0/100,D0*100,3);
  UO0.invalidate;
end;

procedure TXYZplot3Dcom.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  EnNum.UpdateVar;
  if (Button=BtNext) and (NumP<uo0.polylineCount) then inc(NumP)
  else
  if (Button=BtPrev) and (NumP>1) then dec(NumP);
  enNum.UpdateCtrl;
end;

procedure TXYZplot3Dcom.enNumChange(Sender: TObject);
begin
  setPolyline;
end;

procedure TXYZplot3Dcom.FormCreate(Sender: TObject);
begin
  NumP:=1;
end;

procedure TXYZplot3Dcom.setPolyline;
begin
  if (NumP>=1) and (NumP<=uo0.PolylineCount) then
  with uo0.polyLines[NumP-1] do
  begin
    cbMode.setString('Points|Lines|Solid Spheres|Wire Spheres|Solid Cubes|Wire Cubes|Solid Cones|Wire Cones');
    cbMode.setVar(rec.mode,g_byte,0);
    cbMode.UpdateVarOnChange:=true;
    cbMode.OnChange:=change1;

    ColFrame1.init(rec.color);
    ColFrame1.onChange:=change1;

    enSymbSize.setVar(rec.SymbolSize,g_double);
    enSymbSize.OnChange:=change1;
    enSymbSize.UpdateVarOnExit:=true;

    enSymbSize2.setVar(rec.SymbolSize2,g_double);
    enSymbSize2.OnChange:=change1;
    enSymbSize2.UpdateVarOnExit:=true;

    EsTheta.init(rec.Theta,T_single,-180,180,3);
    EsTheta.onChange:=change;
    EsPhi.init(rec.Phi,T_single,-180,180,3);
    EsPhi.onChange:=change;

    Lnbpts.Caption:=Istr(count)+' points';
  end;

end;

procedure TXYZplot3Dcom.change1(sender: Tobject);
begin
  change;
end;

Initialization
AffDebug('Initialization XYZ3Dform',0);
{$IFDEF FPC}
{$I XYZ3Dform.lrs}
{$ENDIF}
end.
