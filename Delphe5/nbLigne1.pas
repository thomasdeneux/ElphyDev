unit Nbligne1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, editcont,
  util1, debug0;

type
  typeFoncCompter=function(n:integer):integer of object;

  TNumOfLines = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    editNum1: TeditNum;
    editNum2: TeditNum;
    editNum3: TeditNum;
    editNum4: TeditNum;
    editNum5: TeditNum;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ScrollBar1: TScrollBar;
    procedure ScrollBar1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations private }
  public
    { Déclarations public }
    ind0:integer;
    nbl:PtabLong1;
    nbMax:longint;
    Vmax:longint;
    compter:typeFoncCompter;
    tb0:pointer;
    procedure setVars;
    function execution(var ind;nbInd,maxLigne:integer;
                       cpt:typeFoncCompter):boolean;
  end;

function NumOfLines: TNumOfLines;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FNumOfLines: TNumOfLines;

function NumOfLines: TNumOfLines;
begin
  if not assigned(FNumOfLines) then FNumOfLines:= TNumOfLines.create(nil);
  result:= FNumOfLines;
end;

procedure TNumOfLines.setVars;
begin
  Label1.caption:='Column '+Istr(ind0);
  Label2.caption:='Column '+Istr(ind0+1);
  Label3.caption:='Column '+Istr(ind0+2);
  Label4.caption:='Column '+Istr(ind0+3);
  Label5.caption:='Column '+Istr(ind0+4);

  editNum1.setvar(nbl^[ind0],  T_longint);
  editNum2.setvar(nbl^[ind0+1],T_longint);
  editNum3.setvar(nbl^[ind0+2],T_longint);
  editNum4.setvar(nbl^[ind0+3],T_longint);
  editNum5.setvar(nbl^[ind0+4],T_longint);

  editNum1.setMinMax(0,Vmax);
  editNum2.setMinMax(0,Vmax);
  editNum3.setMinMax(0,Vmax);
  editNum4.setMinMax(0,Vmax);
  editNum5.setMinMax(0,Vmax);

end;

function TNumOfLines.execution(var ind;nbInd,maxLigne:integer;
                               cpt:typeFoncCompter):boolean;
begin
  nbl:=@ind;
  nbmax:=nbInd;
  Vmax:=maxLigne;

  compter:=cpt;

  scrollBar1.setParams(ind0,1,nbmax-5+1);

  ind0:=1;

  setVars;

  if showModal=mrOk then
    begin
      upDateAllVar(self);

    end;
end;

procedure TNumOfLines.ScrollBar1Change(Sender: TObject);
begin
  ind0:=ScrollBar1.position;
  updateAllVar(self);
  setVars;
end;

procedure TNumOfLines.Button1Click(Sender: TObject);
var
  num:integer;
begin
  screen.cursor:=crHourGlass;
  num:=ind0+Tbutton(sender).tag-1;
  nbl^[num]:=compter(num);
  case Tbutton(sender).tag of
    1: editnum1.updateCtrl;
    2: editnum2.updateCtrl;
    3: editnum3.updateCtrl;
    4: editnum4.updateCtrl;
    5: editnum5.updateCtrl;
  end;
  screen.cursor:=crDefault;
end;

Initialization
AffDebug('Initialization nbLigne1',0);
{$IFDEF FPC}
{$I Nbligne1.lrs}
{$ENDIF}
end.
