unit actifstm;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,LcLtype,
  {$ELSE}

  {$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  util1,stmDef,stmObj,stmStmX0, debug0;

type
  TgetActiveStim = class(TForm)
    GroupBox1: TGroupBox;
    LBstim: TListBox;
    BOK: TButton;
    ActiveAll: TButton;
    unActiveAll: TButton;
    procedure LBstimDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure LBstimMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ActiveAllClick(Sender: TObject);
    procedure unActiveAllClick(Sender: TObject);
  private
    { Déclarations privées }
    list:Tlist;
    Xcoche:integer;
  public
    { Déclarations publiques }
    procedure execution;
  end;

function getActiveStim: TgetActiveStim;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FgetActiveStim: TgetActiveStim;

function getActiveStim: TgetActiveStim;
begin
  if not assigned(FgetActiveStim) then FgetActiveStim:= TgetActiveStim.create(nil);
  result:= FgetActiveStim;
end;

procedure TgetActiveStim.execution;
var
  i,k:integer;
  st:AnsiString;
begin
  list:=getGlobalList(Tstim,false);
  with LBstim do
  begin
    clear;
    for i:=0 to list.count-1 do items.add('x');
  end;
  showModal;

  list.free;
end;

procedure TgetActiveStim.LBstimDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  rect1:Trect;
begin
  Xcoche:=rect.right-rect.left-13;

  rect1:=rect;
  dec(rect1.right,13);

  with TlistBox(control) do
  begin
    with canvas do
    begin
      if Tstim(list.items[index]).valid then
        begin
          {$IFDEF FPC}
          if TownerDrawStateType(odSelected) in state
          {$ELSE}
          if odSelected in state
          {$ENDIF}
            then font.color:=clWhite else font.color:=clBlack;
          font.style:=[fsBold];
        end
      else
        begin
          {$IFDEF FPC}
          if TownerDrawStateType(odSelected) in state
          {$ELSE}
          if odSelected in state
          {$ENDIF}
            then font.color:=clWhite else font.color:=clGray;
          font.style:=[];
        end;

      textRect(rect1,rect1.left,rect1.top,typeUO(list.items[index]).ident);

      font.color:=clBlack;

      rect1.left:=rect1.right;
      inc(rect1.right,13);
      {$IFDEF FPC}
      if TownerDrawStateType(odSelected) in state
      {$ELSE}
      if odSelected in state
      {$ENDIF}
        then pen.color:=clWhite else pen.color:=clBlack;

      with rect1 do
      begin
        rectangle(left,top,right,bottom);
        if Tstim(list.items[index]).active then
          begin
            moveto(left,top);
            lineto(right,bottom);
            moveto(right,top);
            lineto(left,bottom);
          end;
      end;
    end;
  end;
end;

procedure TgetActiveStim.LBstimMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  n:integer;
begin
  with TlistBox(sender) do
  begin
    if x<Xcoche then exit;
    n:=itemAtPos(point(x,y),false);
    if n>=0 then Tstim(list.items[n]).active:=not Tstim(list.items[n]).active;

    invalidate;
  end;
end;

procedure TgetActiveStim.ActiveAllClick(Sender: TObject);
var
  i:integer;
begin
  with LBstim do
  begin
    for i:=0 to items.count-1 do
      if selected[i]
        then Tstim(list.items[i]).active:=true;
    invalidate;
  end;
end;

procedure TgetActiveStim.unActiveAllClick(Sender: TObject);
var
  i:integer;
begin
  with LBstim do
  begin
    for i:=0 to items.count-1 do
      if selected[i]
        then Tstim(list.items[i]).active:=false;
    invalidate;
  end;
end;

Initialization
AffDebug('Initialization actifstm',0);
{$IFDEF FPC}
{$I actifstm.lrs}
{$ENDIF}
end.
