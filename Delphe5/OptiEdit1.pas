unit OptiEdit1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrameTable1,
  util1,Dgraphic,stmOpti1, Menus, StdCtrls, ExtCtrls, editcont,
  debug0;

type
  TOptiForm = class(TForm)
    TableFrame1: TTableFrame;
    Panel1: TPanel;
    Bcalc: TButton;
    Bone: TButton;
    Bopt: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Pchi2: TPanel;
    enNgrad: TeditNum;
    Label2: TLabel;
    Label3: TLabel;
    enMaxIt: TeditNum;
    procedure FormCreate(Sender: TObject);
    procedure BcalcClick(Sender: TObject);
    procedure BoneClick(Sender: TObject);
    procedure BoptClick(Sender: TObject);
  private
    { Déclarations privées }
    cellCb:TcheckBoxCell;
    Lab:TlabelCell;
    cellCombo:TcomboBoxCell;
    cellNum:TeditNumCell;

    opti:Toptimizer;

    function getCell(ACol, ARow: Integer):Tcell;
  public
    { Déclarations publiques }
    procedure Init(opti1:Toptimizer);
    procedure invalidate;override;

  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

function TOptiForm.getCell(ACol, ARow: Integer):Tcell;
begin
  result:=nil;
  if (Acol=0) or (Arow=0) then
  begin
    result:=lab;
    if (Arow>0) and (Arow<=opti.paraNames.count) then lab.st:=opti.ParaNames[Arow-1]
    else
    if (Acol>0) then
    case Acol of
      0: lab.st:='';
      1: lab.st:='Param';
      2: lab.st:='Clamp';
      3: lab.st:='Min';
      4: lab.st:='Max';
    end;
  end
  else
  if Acol=2 then
  begin
    result:=cellCB;
    cellCB.AdData:=@opti.Vclamp[Arow-1];
  end
  else
  begin
    result:=cellNum;
    cellNum.AdData:=nil;
    cellNum.getExy:=nil;
    cellNum.setExy:=nil;

    case Acol of
      1: cellNum.AdData:=opti.para.getP(Arow);
      3: cellNum.AdData:=opti.paraMin.getP(Arow);
      4: cellNum.AdData:=opti.paraMax.GetP(Arow);
    end;
  end;
end;

procedure TOptiForm.FormCreate(Sender: TObject);
begin
  lab:=TlabelCell.create(tableFrame1);

  cellCb:=TcheckBoxCell.create(tableFrame1);

  cellNum:=TeditNumCell.create(tableFrame1);
  cellNum.tpNum:=g_double;

end;

procedure TOptiForm.Init(opti1: Toptimizer);
var
  wmax,i,w:integer;
begin
  opti:=opti1;

  with tableFrame1 do
  begin
    init(5,opti.para.Icount,1,1,getCell);

    drawGrid1.ColWidths[2]:=40;
  end;

  with opti do
  begin
    wmax:=0;
    with paraNames do
    for i:=0 to count-1 do
    begin
      w:=tableFrame1.drawGrid1.canvas.TextWidth(strings[i])+20;
      if w>wmax then wmax:=w;
    end;

    tableFrame1.drawGrid1.ColWidths[0]:=wmax;
  end;

  ClientWidth:=tableFrame1.SumOfWidths+25;

  caption:=opti.ident;

  enMaxIt.setVar(opti.cntMax,g_longint);
  enMaxIt.setMinMax(1,maxEntierLong);
  enMaxIt.UpdateVarOnExit:=true;

  enNgrad.setVar(opti.modHis,g_longint);
  enNgrad.setMinMax(0,maxEntierLong);
  enNgrad.UpdateVarOnExit:=true;

  Pchi2.Caption:=Estr(opti.Chi2,9);
end;

procedure TOptiForm.BcalcClick(Sender: TObject);
begin
  opti.CalculateOutputs(sender);
end;

procedure TOptiForm.BoneClick(Sender: TObject);
var
  old:integer;
begin
  if not opti.initOpti then exit;

  old:=opti.cntmax;
  opti.cntmax:=1;
  try
  opti.Optimize;
  finally
  opti.cntmax:=old;
  opti.calculateOutPuts(nil);
  end;
end;


procedure TOptiForm.BoptClick(Sender: TObject);
var
  old:integer;
  msg:Tmsg;
  cnt:integer;
begin
  if Bopt.caption='Stop' then
  begin
    opti.finDemandee:=true;
    exit;
  end;

  if not opti.initOpti then exit;

  old:=opti.cntmax;
  cnt:=0;
  opti.cntmax:=1;
  try
    Bopt.Caption:='Stop';
    repeat
      opti.Optimize;
      opti.invalidateVectors;
      updateAff;
      while peekMessage(msg,Bopt.handle,0,0,pm_remove) do
      begin
        translateMessage(msg);
        dispatchMessage(msg);
      end;
      inc(cnt);
    until (cnt>=old) or opti.finDemandee;
  finally
  opti.cntmax:=old;
  opti.calculateOutPuts(nil);
  Bopt.caption:='Optimize';
  end;
end;


procedure TOptiForm.invalidate;
begin
  inherited;
  if assigned(opti) then
  begin
    tableFrame1.DrawGrid1.Invalidate;
    Pchi2.Caption:=Estr(opti.Chi2,9);
    updateAllCtrl(self);
  end;
end;


Initialization
AffDebug('Initialization OptiEdit1',0);
{$IFDEF FPC}
{$I OptiEdit1.lrs}
{$ENDIF}
end.
