unit Matlicom1;

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

  util1,Dgraphic,Velicom0,
  stmObj,stmMat1,chooseOb, debug0;

type
  TMatlistCommandA = class(TForm)
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

    optionsG:^TVListRecord;
  end;

var
  MatlistCommandA: TMatlistCommandA;

implementation

uses stmMlist;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TMatlistCommandA.Load1Click(Sender: TObject);
begin
  ;
end;

procedure TMatlistCommandA.Save1Click(Sender: TObject);
begin
  ;
end;

procedure TMatlistCommandA.Clear1Click(Sender: TObject);
begin
  with TmatList(UO) do
  begin
    clear;
    invalidate;
  end;
end;

procedure TMatlistCommandA.ListBox1Click(Sender: TObject);
begin
  if LastAff<>listBox1.itemIndex
    then paintBox1.invalidate;
end;

procedure TMatlistCommandA.PaintBox1Paint(Sender: TObject);
begin
  LastAff:=listBox1.itemIndex;
  with paintBox1 do initGraphic(canvas,left,top,width,height);
  canvasGlb.font.assign(font);
  canvasGlb.brush.color:=panel1.color;
  clearWindow(panel1.color);

  TmatList(UO).DisplayGraph;
  doneGraphic;
end;

procedure TMatlistCommandA.Options1Click(Sender: TObject);
begin
  if VlistOptions.execution(optionsG^) then
    begin
      DescToFont(OptionsG^.FontRec,panel1.font);
      panel1.color:=OptionsG^.color;
      invalidate;
    end;
end;


procedure TMatlistCommandA.ListBox1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  accept:= (DraggedUO is Tmatrix) and not(DragUOsource=UO) ;
end;

procedure TMatlistCommandA.ListBox1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  pu,p:typeUO;
  i:integer;
begin
   pu:=DraggedUO;
   resetDragUO;
   if not assigned(pu) then exit;

   p:=Tmatrix(pu.clone(true));

   with TmatList(uo) do
   begin
     AddClone(Tmatrix(p));
     invalidate;
   end
end;


procedure TMatlistCommandA.ListBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  
  DragUOsource:=UO;
  with TmatList(UO) do
    DraggedUO:=mat[curPos];
  listBox1.beginDrag(false);
end;

procedure TMatlistCommandA.Addvector1Click(Sender: TObject);
var
  ob:typeUO;
begin
  chooseObject.caption:='Choose a vector';
  if chooseObject.execution(Tmatrix,ob) then
    with TmatList(UO) do
    begin
      AddMatrix(Tmatrix(ob));
      invalidate;
    end;
end;

procedure TMatlistCommandA.Deletevector1Click(Sender: TObject);
begin
  if (listBox1.ItemIndex>=0) and (listBox1.ItemIndex<listBox1.Count) then
    with TmatList(UO) do
    begin
      deleteMatrix(listBox1.ItemIndex+1);
      invalidate;
    end;
end;

procedure TMatlistCommandA.FormCreate(Sender: TObject);
begin
  lastAff:=-1;
end;

procedure TMatlistCommandA.ListBox1EndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  resetDragUO;
end;

Initialization
AffDebug('Initialization Matlicom1',0);
{$IFDEF FPC}
{$I Matlicom1.lrs}
{$ENDIF}
end.
