unit MtagProp1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,

  util1,Dgraphic,debug0,Mtag2;

type
  TMtagProperties = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    MemoTag: TMemo;
    VLBtag: TListBox;
    Bgo: TButton;
    procedure VLboxTagClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BgoClick(Sender: TObject);
    procedure VLBtagData(Control: TWinControl; Index: Integer;
      var Data: AnsiString);
    procedure VLBtagDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Déclarations privées }
    Mtag0:TMtagVector;
  public
    { Déclarations publiques }
    procedure init(MM:TMtagVector);
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}


procedure FillListBox(lb:TlistBox; nb:integer);
var
  i:integer;
begin
  with lb.items do
  begin
    beginUpdate;
    clear;
    for i:=1 to nb do add('');
    EndUpdate;
  end;
end;


procedure TMtagProperties.init(MM:TMtagVector);
begin

  Mtag0:=MM;

  if assigned(Mtag0)
    then fillListBox(VLbTag, length(Mtag0.Tags))
    else VLbTag.Items.Clear;

  VLbTag.itemIndex:=-1;
  memoTag.Text:='';

  if Mtag0<>nil then invalidate;
end;


procedure TMtagProperties.VLboxTagClick(Sender: TObject);
begin
  if assigned(Mtag0) then
  with Mtag0 do
  if (length(tags)>0) and (VLBtag.itemIndex>=0) then
    with tags[VLBtag.itemIndex] do
    memoTag.Text:=st;
end;

procedure TMtagProperties.FormCreate(Sender: TObject);
const
  tab:array[1..3] of integer=(30,50,80);
begin

  {
  VLBtag.SetTabStops(tab);
  VLBtag.UseTabStops:=true;
  }
  affdebug('TMtagProperties.FormCreate '+Istr(intG(self)),6);
end;



procedure TMtagProperties.BgoClick(Sender: TObject);
begin
  if assigned(Mtag0) and (VLBtag.itemIndex>=0) and (VLBtag.itemIndex<VLBtag.Count)
    then Mtag0.goToTag(VLBtag.itemIndex);
end;

procedure TMtagProperties.VLBtagData(Control: TWinControl; Index: Integer;
  var Data: AnsiString);

const
  sep='   ';
begin
  if assigned(Mtag0) and (length(Mtag0.tags)>0) and (Index<length(Mtag0.tags)) then
  with Mtag0,tags[index] do
  data:=Istr(Ep+1)+sep+Istr(code)+sep+
              Estr(SampleIndex*dxu+x0u,6)+sep+dateTimeToStr(Stime)
  else data:='';

end;

procedure TMtagProperties.VLBtagDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
const
  sep='   ';
var
  data:AnsiString;
begin
  if assigned(Mtag0) and (length(Mtag0.tags)>0) and (Index<length(Mtag0.tags)) then
  with Mtag0,tags[index] do
    data:=Istr(Ep+1)+sep+Istr(code)+sep+
              Estr(SampleIndex*dxu+x0u,6)+sep+dateTimeToStr(Stime)
  else data:='';


  with VLBTag.Canvas do
  begin
    FillRect(Rect);
      TextOut(Rect.Left + 4, Rect.Top, data);
  end;
end;

Initialization
AffDebug('Initialization MtagProp1',0);
{$IFDEF FPC}
{$I MtagProp1.lrs}
{$ENDIF}
end.
