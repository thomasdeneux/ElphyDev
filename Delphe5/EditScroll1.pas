unit EditScroll1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont,

  util1,debug0;

type
  TEditScroll = class(TFrame)
    Lb: TLabel;
    en: TeditNum;
    sb: TscrollbarV;
    procedure sbScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure enKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure enExit(Sender: TObject);
  private
    { Déclarations privées }
    Fupdate:boolean;
  public
    { Déclarations publiques }
    onChange:procedure of object;
    procedure init(var x;tp:TnumType;min,max:float;deci:integer);
  end;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TEditScroll.init(var x;tp:TnumType;min,max:float;deci:integer);
var
  w:float;
begin
  Fupdate:=true;

  en.setVar(x,tp);
  en.setMinMax(min,max);
  en.Decimal:=deci;

  w:=en.FloatValue;
  sb.setParams(w,min,max);

  Fupdate:=false;
end;

procedure TEditScroll.sbScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  en.FloatValue:=x;

  if assigned(onChange) then onChange;
end;

procedure TEditScroll.enKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_return then
  begin
    en.updatevar;
    sb.setParams(en.FloatValue,en.Min,en.Max);
    if assigned(onChange) then onChange;
  end;
end;

procedure TEditScroll.enExit(Sender: TObject);
begin
  if Fupdate then exit;

  en.updatevar;
  sb.setParams(en.FloatValue,en.Min,en.Max);

  if assigned(onChange) then onChange;
end;

Initialization
AffDebug('Initialization EditScroll1',0);
{$IFDEF FPC}
{$I EditScroll1.lrs}
{$ENDIF}
end.
