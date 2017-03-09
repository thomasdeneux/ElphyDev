unit ClistForm1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, ExtCtrls,

  stmdef,stmObj,stmClist1,stmvec1, Buttons, ComCtrls, Debug0;

type
  TClistForm = class(TForm)
    SBindex: TscrollbarV;
    Panel1: TPanel;
    Panel2: TPanel;
    Pvalue: TPanel;
    Panel4: TPanel;
    Pindex: TPanel;
    Badd: TButton;
    Bdelete: TButton;
    GroupBox1: TGroupBox;
    CBselect: TCheckBoxV;
    cbLocked: TCheckBoxV;
    BselectAll: TButton;
    BunselectAll: TButton;
    Bextra: TBitBtn;
    cbShowCursors: TCheckBoxV;
    Panel3: TPanel;
    Panel5: TPanel;
    Pcount: TPanel;
    procedure FormShow(Sender: TObject);
    procedure cbLockedClick(Sender: TObject);
    procedure BdeleteClick(Sender: TObject);
    procedure BaddEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure BaddMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BaddStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure cbShowCursorsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BextraClick(Sender: TObject);
    procedure BselectAllClick(Sender: TObject);
    procedure BunselectAllClick(Sender: TObject);
  private
    { Private declarations }
    uo:TCursorList;
    height0,height1:integer;
  public
    { Public declarations }
    procedure install(ww:TCursorList);
  end;


implementation


{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
procedure TClistForm.install(ww:TCursorList);
begin
  uo:=ww;
end;


procedure TClistForm.FormShow(Sender: TObject);
begin
  if assigned(uo) then uo.updateForm;
end;

procedure TClistForm.cbLockedClick(Sender: TObject);
begin
  uo.LockedCursors:=true;
end;

procedure TClistForm.BdeleteClick(Sender: TObject);
begin
  uo.deleteCursor;
end;

procedure TClistForm.BaddEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  if assigned(specialDrag) then Tvector(specialDrag).FondragDrop:=nil;
  specialDrag:=nil;
end;

procedure TClistForm.BaddMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (uo=nil) or (uo.Vdisplay=nil) or (uo.Vevent=nil) then exit;

  with Badd do
  begin

    beginDrag(false);
  end;

end;

procedure TClistForm.BaddStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
   if (uo=nil) or (uo.Vdisplay=nil) or (uo.Vevent=nil) then exit;

  specialDrag:=uo.Vdisplay;

  Tvector(specialDrag).FondragDrop:=uo.DnDAdd;
  DragUOsource:=uo;
  DraggedUO:=uo;

end;

procedure TClistForm.cbShowCursorsClick(Sender: TObject);
begin
  cbShowCursors.updateVar;
  uo.invalidate;
end;

procedure TClistForm.FormCreate(Sender: TObject);
begin
  {
  height0:=clientheight;
  height1:=Bextra.top+30;
  clientheight:=height1;
  }
end;

procedure TClistForm.BextraClick(Sender: TObject);
begin

{  if clientHeight=height0
    then clientHeight:=height1
    else clientHeight:=height0;
}
  uo.proprietes(self);
end;

procedure TClistForm.BselectAllClick(Sender: TObject);
begin
  uo.selectAll;
end;

procedure TClistForm.BunselectAllClick(Sender: TObject);
begin
  uo.unselectAll;
end;

Initialization
AffDebug('Initialization ClistForm1',0);
{$IFDEF FPC}
{$I ClistForm1.lrs}
{$ENDIF}
end.
