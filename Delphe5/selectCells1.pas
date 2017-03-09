unit selectCells1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, editcont,
  debug0;

type
  TSelectCells = class(TForm)
    Label1: TLabel;
    enFirstCol: TeditNum;
    Label2: TLabel;
    enLastCol: TeditNum;
    Label3: TLabel;
    enFirstRow: TeditNum;
    Label4: TLabel;
    enLastRow: TeditNum;
    BfirstCol: TBitBtn;
    BlastCol: TBitBtn;
    BfirstRow: TBitBtn;
    BlastRow: TBitBtn;
    BOK: TButton;
    Bcancel: TButton;
    procedure BfirstColClick(Sender: TObject);
  private
    { Déclarations privées }
    colmin,colmax,RowMin,RowMax:integer;
    Fminmax:boolean;
  public
    { Déclarations publiques }

    procedure setMinMax(colmin1,colmax1,RowMin1,RowMax1:integer);
    function execution(var col1,col2,line1,line2:integer):boolean;
  end;

function SelectCells: TSelectCells;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FSelectCells: TSelectCells;

function SelectCells: TSelectCells;
begin
  if not assigned(FSelectCells) then FSelectCells:= TSelectCells.create(nil);
  result:= FSelectCells;
end;

{ TSelectCells }

function TSelectCells.execution(var col1, col2, line1, line2: integer): boolean;
begin
  enFirstCol.setVar(col1,t_longint);
  if colmin<=colmax then enFirstCol.setMinMax(colmin,colmax);

  enLastCol.setVar(col2,t_longint);
  if colmin<=colmax then enLastCol.setMinMax(colmin,colmax);

  enFirstRow.setVar(line1,t_longint);
  if Rowmin<=Rowmax then enFirstRow.setMinMax(RowMin,RowMax);

  enLastRow.setVar(line2,t_longint);
  if Rowmin<=Rowmax then enLastRow.setMinMax(RowMin,RowMax);

  result:= (showModal=mrOK);
  if result then updateAllvar(self);

end;

procedure TSelectCells.setMinMax(colmin1, colmax1, RowMin1, RowMax1: integer);
begin
  colMin:=colMin1;
  colMax:=colMax1;
  RowMin:=RowMin1;
  RowMax:=RowMax1;

  Fminmax:=true;
end;

procedure TSelectCells.BfirstColClick(Sender: TObject);
begin
  if Fminmax then
  case Tbutton(sender).tag of
    1: enFirstCol.setCtrlValue(colMin);
    2: enLastCol.setCtrlValue(colMax);
    3: enFirstRow.setCtrlValue(rowMin);
    4: enLastRow.setCtrlValue(rowMax);
  end;
end;

Initialization
AffDebug('Initialization selectCells1',0);
{$IFDEF FPC}
{$I selectCells1.lrs}
{$ENDIF}
end.
