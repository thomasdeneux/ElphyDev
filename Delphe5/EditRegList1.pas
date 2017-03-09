unit EditRegList1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, FrameTable1,

  util1,stmRegion1, ExtCtrls, debug0 ;

type
  TEditRegList = class(TForm)
    TableFrame1: TTableFrame;
    Panel1: TPanel;
    Bclose: TButton;
    BchangeColors: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BchangeColorsClick(Sender: TObject);
  private
    { Déclarations privées }
    labelCell:TlabeLCell;
    DeleteCell:TbuttonCell;
    ButtonCell:TbuttonCell;

    regionList:TregionList;

    procedure ChangeRegionColor(Acol,Arow:integer);
  public
    { Déclarations publiques }
    procedure Init(reg:TregionList);

    function getCell(ACol, ARow: Integer):Tcell;
    procedure OnModifyClick(Acol,Arow:integer);
    procedure OnDeleteClick(Acol,Arow:integer);

  end;

function EditRegList: TEditRegList;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FEditRegList: TEditRegList;

function EditRegList: TEditRegList;
begin
  if not assigned(FEditRegList) then FEditRegList:= TEditRegList.create(nil);
  result:= FEditRegList;
end;

procedure TEditRegList.Init(reg: TregionList);
begin
  regionList:=reg;
  tableFrame1.init(5,regionList.regList.count+1,1,1,getCell);
end;


function TEditRegList.getCell(ACol, ARow: Integer): Tcell;
begin
  result:=nil;
  if (Acol=0) or (Arow=0) then               { Les titres }
  begin
    result:=labelCell;
    if (Arow>0) and (Arow<tableFrame1.RowCount) then labelCell.st:='Region '+Istr(Arow)
    else
    if (Acol>0) then
    case Acol of
      1: labelCell.st:='Type';
      2: labelCell.st:='Region box';
      3: labelCell.st:='';
      4: labelCell.st:='';
    end
    else labelCell.st:='';
  end
  else
  if Acol=1 then                             { type de region }
  begin
    result:=labelCell;
    labelCell.st:=regionList.regList.region[Arow-1].regTypeName;
  end
  else                                       { extension de la région }
  if Acol=2 then
  with regionList.regList.region[Arow-1].regionBox do
  begin
    result:=labelCell;

    labelCell.st:=Estr(left,3)+','+Estr(top,3)+' / '+Estr(right-left,3)+','+Estr(bottom-top,3);
  end
  else
  if Acol=3 then                             { couleur de région }
  begin
    {
    result:=colorCell;
    colorCell.AdData:=@regionList.regList.region[Arow-1].color;
    colorCell.OnColorChanged:=ChangeRegionColor;
    }
    result:=ButtonCell;                      { bouton Modify }
    ButtonCell.UserOnClick:=OnModifyClick;
    ButtonCell.button.caption:='Modify';
  end
  else
  if Acol=4 then
  begin
    result:=DeleteCell;                      { bouton Delete }
    DeleteCell.UserOnClick:=OnDeleteClick;
    DeleteCell.button.caption:='Delete';
  end;
end;





procedure TEditRegList.OnModifyClick(Acol,Arow: integer);
begin
  with regionList.regList[Arow-1] do  {delete(Arow-1);}
  if edit('Region '+Istr(Arow-1),
           self.Left+tableFrame1.DrawGrid1.cellRect(Acol,Arow).left+10,
           self.Top+ tableFrame1.DrawGrid1.cellRect(Acol,Arow).Top+10)  then
  begin
    regionList.invalidateData;
    init(regionList);
    tableFrame1.invalidate;
  end;
end;

procedure TEditRegList.FormCreate(Sender: TObject);
begin
  labelCell:=TlabeLCell.create(tableFrame1);
  DeleteCell:=TbuttonCell.create(tableFrame1);
  ButtonCell:=TbuttonCell.create(tableFrame1);

  tableFrame1.init(5,20,1,1,getCell);

end;

procedure TEditRegList.ChangeRegionColor(Acol, Arow: integer);
begin
  regionList.invalidateData;
end;

procedure TEditRegList.BchangeColorsClick(Sender: TObject);
begin
  with tableFrame1.ColorDialog1 do
  begin
    color:=regionList.regList.Defcolor;
    if execute then
    begin
      regionList.SetColors(color);
      regionList.invalidateData;
      tableFrame1.invalidate;
    end;
  end;
end;

procedure TEditRegList.OnDeleteClick(Acol, Arow: integer);
begin
  with regionList.regList do delete(Arow-1);

  regionList.invalidateData;
  init(regionList);
  tableFrame1.invalidate;
end;

Initialization
AffDebug('Initialization EditRegList1',0);
{$IFDEF FPC}
{$I EditRegList1.lrs}
{$ENDIF}
end.
