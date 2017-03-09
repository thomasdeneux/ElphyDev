unit XYPedit1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DtbEdit2, Menus, StdCtrls, ExtCtrls, Grids, editcont, ColorFrame1,
  DtbEdit1,debug0;

type
  TXYplotEditor = class(TArrayEditor)
    LeftPanel: TPanel;
    GroupBox1: TGroupBox;
    Lcount: TLabel;
    cbSelected: TcomboBoxV;
    Label2: TLabel;
    Bdelete: TButton;
    Binsert: TButton;
    Bcolor: TColFrame;
    Bcolor2: TColFrame;
    Label6: TLabel;
    cbStyle: TcomboBoxV;
    Label7: TLabel;
    cbSymbolSize: TcomboBoxV;
    Label8: TLabel;
    cbLineWidth: TcomboBoxV;
    procedure cbSelectedChange(Sender: TObject);
    procedure BdeleteClick(Sender: TObject);
    procedure BinsertClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    changePage,changeColor,DeletePolyline,insertPolyline:procedure of object;

    procedure adjustFormSize;override;
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
procedure TXYplotEditor.AdjustFormSize;
var
  w,h,dw,dh:integer;
begin
{
  with drawGrid1 do
  begin
    w:=gridWidth;
    h:=gridHeight+panel1.height;
  end;

  dw:=clientWidth-w-2;
  dh:=clientHeight-h-2;

  if (dw>0) or (dh>0) then setBounds(left,top,width,height-dh+20);
  drawgrid1.invalidate;}
end;


procedure TXYplotEditor.cbSelectedChange(Sender: TObject);
begin
  cbSelected.updateVar;
  ChangePage;

end;

procedure TXYplotEditor.BdeleteClick(Sender: TObject);
begin
  DeletePolyline;

end;

procedure TXYplotEditor.BinsertClick(Sender: TObject);
begin
  InsertPolyline;

end;

Initialization
AffDebug('Initialization XYPedit1',0);
{$IFDEF FPC}
{$I XYPedit1.lrs}
{$ENDIF}
end.
