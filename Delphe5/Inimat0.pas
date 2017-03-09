unit Inimat0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls,
  util1,editCont,stmDobj1,stmMat1,debug0;

type
  TinitTmatrix = class(TForm)
    Bok: TButton;
    Bcancel: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    enIStart: TeditNum;
    enIEnd: TeditNum;
    cbType: TcomboBoxV;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    enDx: TeditNum;
    enX0: TeditNum;
    enDy: TeditNum;
    enY0: TeditNum;
    enJstart: TeditNum;
    Label8: TLabel;
    enJend: TeditNum;
    Label9: TLabel;
    Label10: TLabel;
    enDz: TeditNum;
    Label11: TLabel;
    enZ0: TeditNum;
    esUnitX: TeditString;
    Label12: TLabel;
    Label13: TLabel;
    esUnitY: TeditString;
    GBopt: TGroupBox;
    LabelOpt: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    h0,yBOK,hBOK,hGBox:integer;

  public
    { Public declarations }
    function execution(st:AnsiString;mat:Tmatrix;stOpt:AnsiString):boolean;
    procedure SetOption(st:AnsiString);
  end;

function initTmatrix: TinitTmatrix;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FinitTmatrix: TinitTmatrix;

function initTmatrix: TinitTmatrix;
begin
  if not assigned(FinitTmatrix) then FinitTmatrix:= TinitTmatrix.create(nil);
  result:= FinitTmatrix;
end;

function TinitTmatrix.execution(st:AnsiString;mat:Tmatrix;stOpt:AnsiString):boolean;
var
  tn:byte;
  inf1:TinfoDataObj;
  t:typetypeG;
  stType:AnsiString;
  i:integer;
begin
  caption:=st;
  setOption(stOpt);

  inf1:=mat.inf;

  with inf1 do
  begin

    enIstart.setvar(imin,t_longint);
    enIend.setvar(imax,t_longint);
    enJstart.setvar(jmin,t_longint);
    enJend.setvar(jmax,t_longint);


    tn:=0;
    for t:=low(typetypeG) to high(typetypeG) do
    begin
      if Tmatrix.SupportType(t) then inc(tn);
      if tpNum=t then break;
    end;

    stType:='';
    for t:=low(typetypeG) to high(typetypeG) do
      if Tmatrix.SupportType(t) then stType:=stType+TypeNameG[t]+'|';
    delete(stType,length(stType),1);

    cbType.setString(stType);
    cbType.setvar(tn,t_byte,1);

    enDx.setvar(Dxu,t_double);
    enDx.decimal:=6;
    enX0.setvar(X0u,t_double);
    enX0.decimal:=6;
    enDy.setvar(Dyu,t_double);
    enDy.decimal:=6;
    enY0.setvar(Y0u,t_double);
    enY0.decimal:=6;

    enDz.setvar(Dzu,t_double);
    enDz.decimal:=6;
    enZ0.setvar(Z0u,t_double);
    enZ0.decimal:=6;

    enIStart.enabled:=temp;
    enIEnd.enabled:=temp;
    enJStart.enabled:=temp;
    enJEnd.enabled:=temp;
    cbType.enabled:=temp;

    enDx.enabled:=temp and not readOnly;
    enX0.enabled:=temp and not readOnly;
    enDy.enabled:=temp and not readOnly;
    enY0.enabled:=temp and not readOnly;
    enDz.enabled:=temp and not readOnly;
    enZ0.enabled:=temp and not readOnly;
  end;

  esUnitX.setVar(mat.visu.ux,10);
  esUnitY.setVar(mat.visu.uy,10);

  if showModal=mrOK then
    begin
      updateAllVar(self);
      with inf1 do
      begin
        i:=0;
        for t:=low(typetypeG) to high(typetypeG) do
        begin
          if Tmatrix.SupportType(t) then inc(i);
          if tn=i then break;
        end;
        tpNum:=t;

        if (Imin>Imax) or (dxu=0) or (dyu=0)
          then messageCentral('Invalid vector parameter')
          else mat.inf:=inf1;
      end;
      execution:=true;
    end
  else execution:=false;

end;


procedure TinitTmatrix.SetOption(st: AnsiString);
begin
  if st='' then
  begin
    GBopt.Visible:=false;
    BOK.Top:=yBOK-hGbox;
    Bcancel.Top:=yBOK-hGbox;
    clientHeight:=h0-hGbox;
  end
  else
  begin
    GBopt.Visible:=true;
    BOK.Top:=yBOK;
    Bcancel.Top:=yBOK;
    clientHeight:=h0;
  end;
  LabelOpt.Caption :=st;
end;

procedure TinitTmatrix.FormCreate(Sender: TObject);
begin
  h0:=clientHeight;
  yBOK:=BOK.Top;
  hBOK:=BOK.Height;
  hGBox:=GBopt.Height;

  setOption('');
end;

Initialization
AffDebug('Initialization Inimat0',0);
{$IFDEF FPC}
{$I Inimat0.lrs}
{$ENDIF}
end.

