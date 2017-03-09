unit Iniarr0;

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
  util1,editCont, debug0;

type
  TinitTvectorArray = class(TForm)
    Bok: TButton;
    Bcancel: TButton;
    Lname: TLabel;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    en1: TeditNum;
    Label7: TLabel;
    en2: TeditNum;
    Label8: TLabel;
    en3: TeditNum;
    Label9: TLabel;
    en4: TeditNum;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    en5: TeditNum;
    Label3: TLabel;
    en6: TeditNum;
    Label1: TLabel;
    CB1: TcomboBoxV;
  private
    { Private declarations }
  public
    { Public declarations }
    function execution(st:AnsiString;var i1,i2,j1,j2,n1,n2:longint;
                       var tNombre:typetypeG):boolean;

  end;

function initTvectorArray: TinitTvectorArray;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FinitTvectorArray: TinitTvectorArray;

function initTvectorArray: TinitTvectorArray;
begin
  if not assigned(FinitTvectorArray) then FinitTvectorArray:= TinitTvectorArray.create(nil);
  result:= FinitTvectorArray;
end;

function TinitTvectorArray.execution(st:AnsiString;var i1,i2,j1,j2,n1,n2:longint;
                       var tNombre:typetypeG):boolean;
var
  tn:byte;
begin
  case tNombre of
    G_smallint:  tn:=1;
    G_longint:  tn:=2;
    G_single:   tn:=3;
    G_extended: tn:=4;
    else        tn:=1;
  end;

  Lname.caption:=st;
  en1.setvar(i1,t_longint);
  en2.setvar(i2,t_longint);
  en3.setvar(j1,t_longint);
  en4.setvar(j2,t_longint);
  en5.setvar(n1,t_longint);
  en6.setvar(n2,t_longint);

  cb1.setString('Integer|longint|single|extended');
  cb1.setvar(tn,t_byte,1);

  if showModal=mrOK then
    begin
      updateAllVar(self);
      case tn of
        1:tNombre:=G_smallint;
        2:tNombre:=G_longint;
        3:tNombre:=G_single;
        4:tNombre:=G_extended;
      end;
      execution:=true;
    end
  else execution:=false;
end;


Initialization
AffDebug('Initialization iniarr0',0);
{$IFDEF FPC}
{$I Iniarr0.lrs}
{$ENDIF}
end.
