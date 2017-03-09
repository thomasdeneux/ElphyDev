unit revMprop;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,math,
  StdCtrls, editcont,

  util1;

type
  TRevMatProp = class(TForm)
    Label1: TLabel;
    enT1: TeditNum;
    enT2: TeditNum;
    Label2: TLabel;
    Label3: TLabel;
    enDT: TeditNum;
    sbIP1: TscrollbarV;
    Lip1: TLabel;
    Lip2: TLabel;
    sbIP2: TscrollbarV;
    Bcalcul: TButton;
    procedure BcalculClick(Sender: TObject);
    procedure sbIP1ScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbIP2ScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    calcul:procedure of object;
    scrollIp1,scrollIp2:procedure (x:float) of object;

    procedure init(var t1,t2,dt:float;xp1,xp2:float);
  end;


implementation

{$R *.DFM}
procedure TRevMatProp.init(var t1,t2,dt:float;xp1,xp2:float);
begin
  enT1.setVar(t1,t_extended);
  enT2.setVar(t2,t_extended);
  enDT.setVar(dt,t_extended);

  sbIP1.setParams(xp1,t1,t2) ;
  sbIP1.dxSmall:=dt;
  sbIP1.dxLarge:=dt*10;

  sbIP2.setParams(xp2,t1,t2) ;
  sbIP2.dxSmall:=dt;
  sbIP2.dxLarge:=dt*10;

  Lip1.caption:=Estr(xp1,3);
  Lip2.caption:=Estr(xp2,3);
end;

procedure TRevMatProp.BcalculClick(Sender: TObject);
begin
  updateAllVar(self);
  calcul;
end;

procedure TRevMatProp.sbIP1ScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  updateAllvar(self);
  Lip1.caption:=Estr(x,3);
  scrollIP1(x);
end;

procedure TRevMatProp.sbIP2ScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  updateAllvar(self);
  Lip2.caption:=Estr(x,3);
  scrollIp2(x);
end;

end.
