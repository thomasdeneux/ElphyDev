unit VeLicom1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

{Utilisée par VlistA1 }

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus,

  util1,Dgraphic,Velicom0, debug0,
  stmObj,stmvec1,chooseOb;

type
  TVlistCommandA = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Close1: TMenuItem;
    New1: TMenuItem;
    Options1: TMenuItem;
    ListBox1: TListBox;

    Panel1: TPanel;
    Splitter1: TSplitter;
    PaintBox1: TPaintBox;
    Splitter2: TSplitter;
    Edit1: TMenuItem;
    Addvector1: TMenuItem;
    Deletevector1: TMenuItem;
    procedure Load1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure ListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Addvector1Click(Sender: TObject);
    procedure Deletevector1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1EndDrag(Sender, Target: TObject; X, Y: Integer);
  private
    { Private declarations }
    lastAff:integer;
  public
    { Public declarations }

    UO:pointer;

    optionsG:^TVlistRecord;
  end;

var
  VlistCommandA: TVlistCommandA;

implementation

uses VlistA1;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TVlistCommandA.Load1Click(Sender: TObject);
begin
  ;
end;

procedure TVlistCommandA.Save1Click(Sender: TObject);
begin
  ;
end;

procedure TVlistCommandA.Clear1Click(Sender: TObject);
begin
  with TVlist(UO) do
  begin
    clear;
    invalidate;
  end;
end;

procedure TVlistCommandA.ListBox1Click(Sender: TObject);
begin
  if LastAff<>listBox1.itemIndex
    then paintBox1.invalidate;
end;

procedure TVlistCommandA.PaintBox1Paint(Sender: TObject);
begin
  LastAff:=listBox1.itemIndex;
  with paintBox1 do initGraphic(canvas,left,top,width,height);
  canvasGlb.font.assign(font);
  canvasGlb.brush.color:=panel1.color;
  clearWindow(panel1.color);

  TVlist(UO).DisplayGraph;
  doneGraphic;
end;

procedure TVlistCommandA.Options1Click(Sender: TObject);
begin
  if VlistOptions.execution(optionsG^) then
    begin
      DescToFont(OptionsG^.FontRec,panel1.font);
      panel1.color:=OptionsG^.color;
      invalidate;
    end;
end;


procedure TVlistCommandA.ListBox1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  accept:= (DraggedUO is Tvector) and not(DragUOsource=UO) ;
end;

procedure TVlistCommandA.ListBox1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  pu,p:typeUO;
  i:integer;
begin
   pu:=DraggedUO;
   resetDragUO;
   if not assigned(pu) then exit;

   p:=Tvector(pu.clone(true));

   with TVlist(uo) do
   begin
     AddClone(Tvector(p));
     invalidate;
   end
end;


procedure TVlistCommandA.ListBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  
  DragUOsource:=UO;
  with TVlist(UO) do
    DraggedUO:=Vectors[curPos];
  listBox1.beginDrag(false);
end;

procedure TVlistCommandA.Addvector1Click(Sender: TObject);
var
  ob:typeUO;
begin
  chooseObject.caption:='Choose a vector';
  if chooseObject.execution(Tvector,ob) then
    with TVlist(UO) do
    begin
      AddVector(Tvector(ob));
      invalidate;
    end;
end;

procedure TVlistCommandA.Deletevector1Click(Sender: TObject);
begin
  if (listBox1.ItemIndex>=0) and (listBox1.ItemIndex<listBox1.Count) then
    with TVlist(UO) do
    begin
      deleteVector(listBox1.ItemIndex+1);
      invalidate;
    end;
end;

procedure TVlistCommandA.FormCreate(Sender: TObject);
begin
  lastAff:=-1;
end;

procedure TVlistCommandA.ListBox1EndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  resetDragUO;
end;

Initialization
AffDebug('Initialization Velicom1',0);
{$IFDEF FPC}
{$I VeLicom1.lrs}
{$ENDIF}
end.
