unit Inivect0;

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
  util1,debug0,
  editCont,stmDobj1,stmVec1;

type
  TinitTvector = class(TForm)
    Bok: TButton;
    Bcancel: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    enStart: TeditNum;
    enEnd: TeditNum;
    cbType: TcomboBoxV;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    enDx: TeditNum;
    Label5: TLabel;
    enX0: TeditNum;
    Label6: TLabel;
    enDy: TeditNum;
    Label7: TLabel;
    enY0: TeditNum;
    cbReadOnly: TCheckBoxV;
    GBopt: TGroupBox;
    LabelOpt: TLabel;
    Label12: TLabel;
    esUnitX: TeditString;
    Label13: TLabel;
    esUnitY: TeditString;
    cbInHz: TCheckBoxV;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    h0,yBOK,hBOK,hGBox:integer;
  public
    { Public declarations }
    function execution(st:AnsiString;vec:Tvector;maxI:integer;stOpt:AnsiString):boolean;

    procedure SetOption(st:AnsiString);
  end;

function initTvector: TinitTvector;

implementation

uses stmPsth1;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FinitTvector: TinitTvector;

function initTvector: TinitTvector;
begin
  if not assigned(FinitTvector) then FinitTvector:= TinitTvector.create(nil);
  result:= FinitTvector;
end;



function TinitTvector.execution(st:AnsiString;vec:Tvector;maxI:integer;stOpt:AnsiString):boolean;
var
  tn:byte;
  inf1:TinfoDataObj;
  InHz1:boolean;
  t:typetypeG;
  stType:AnsiString;
  i:integer;
begin
  caption:=st;
  setOption(stOpt);

  inf1:=vec.inf;

  with inf1 do
  begin
    tn:=0;
    for t:=low(typetypeG) to high(typetypeG) do
    begin
      if t in typesVecteursSupportes then inc(tn);
      if tpNum=t then break;
    end;

    stType:='';
    for t:=low(typetypeG) to high(typetypeG) do
      if t in typesVecteursSupportes then stType:=stType+TypeNameG[t]+'|';
    delete(stType,length(stType),1);

    enStart.setvar(Imin,t_longint);

    enEnd.setvar(Imax,t_longint);
    if vec.flags.FmaxIndex then enEnd.setMinMax(Imin,maxI);

    cbType.setString(sttype);
    cbType.setvar(tn,t_byte,1);

    enDx.setvar(Dxu,t_double);
    enDx.decimal:=6;
    enX0.setvar(X0u,t_double);
    enX0.decimal:=6;
    enDy.setvar(Dyu,t_double);
    enDy.decimal:=6;
    enY0.setvar(Y0u,t_double);
    enY0.decimal:=6;

    enStart.enabled:=vec.flags.Findex;
    enEnd.enabled:=vec.flags.Findex or vec.flags.Fmaxindex;
    cbType.enabled:=vec.flags.Ftype;

    cbReadOnly.setvar(readOnly);

    esUnitX.setVar(vec.visu.ux,10);
    esUnitY.setVar(vec.visu.uy,10);

    {
    enDx.enabled:=temp and not readOnly;
    enX0.enabled:=temp and not readOnly;
    enDy.enabled:=temp and not readOnly;
    enY0.enabled:=temp and not readOnly;
    }
  end;

  if vec is Tpsth then
  begin
    cbInHz.visible:=true;
    InHz1:=Tpsth(vec).inHz;
    cbInHz.setVar(InHz1 );
  end
  else cbInHz.visible:=false;

  if (showModal=mrOK)  then
    begin
      updateAllVar(self);
      if not vec.inf.readOnly then
      with inf1 do
      begin
        i:=0;
        for t:=low(typetypeG) to high(typetypeG) do
        begin
          if t in typesVecteursSupportes then inc(i);
          if tn=i then break;
        end;
        tpNum:=t;

        if Imax<Imin-1 then Imax:=Imin-1;
        if dxu=0 then dxu:=1;
        if dyu=0 then dyu:=1;

        vec.inf:=inf1;
      end;
      if (vec is Tpsth) and (Tpsth(vec).InHz<>InHz1) then Tpsth(vec).setInHz(InHz1);
      execution:=true;
    end
  else execution:=false;
end;


procedure TinitTvector.FormCreate(Sender: TObject);
begin
  h0:=clientHeight;
  yBOK:=BOK.Top;
  hBOK:=BOK.Height;
  hGBox:=GBopt.Height;

  setOption('');
end;

procedure TinitTvector.SetOption(st: AnsiString);
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

Initialization
AffDebug('Initialization inivect0',0);
{$IFDEF FPC}
{$I Inivect0.lrs}
{$ENDIF}
end.
