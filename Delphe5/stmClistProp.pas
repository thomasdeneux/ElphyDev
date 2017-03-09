unit StmCListProp;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,

  ExtCtrls, StdCtrls,
  editcont,
  util1,stmObj,stmvec1,stmClist1, Buttons, Debug0 ;

type
  TClistProp = class(TForm)
    Label1: TLabel;
    BOK: TButton;
    Bcancel: TButton;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    Pselected: TPanel;
    PotherCursors: TPanel;
    GroupBox4: TGroupBox;
    Pcurrent: TPanel;
    PotherCaptions: TPanel;
    ColorDialog1: TColorDialog;
    Label4: TLabel;
    enMaxCursors: TeditNum;
    Label5: TLabel;
    enDeci: TeditNum;
    cbAutoZoom: TCheckBoxV;
    EditEvent: TEdit;
    Bevent: TBitBtn;
    EditDisplay: TEdit;
    Bdisplay: TBitBtn;
    EditZoom: TEdit;
    Bzoom: TBitBtn;
    procedure PselectedClick(Sender: TObject);
    procedure PotherCursorsClick(Sender: TObject);
    procedure PcurrentClick(Sender: TObject);
    procedure PotherCaptionsClick(Sender: TObject);
    procedure BeventClick(Sender: TObject);
    procedure BdisplayClick(Sender: TObject);
    procedure BzoomClick(Sender: TObject);
  private
    { Private declarations }
    uo:TcursorList;
    ev,disp,zoom: Tvector;
  public
    { Public declarations }

    function execution(w:TcursorList):boolean;
  end;

function ClistProp: TClistProp;

implementation

uses chooseOb;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FClistProp: TClistProp;

function ClistProp: TClistProp;
begin
  if not assigned(FClistProp) then FClistProp:= TClistProp.create(nil);
  result:= FClistProp;
end;


function TClistProp.execution(w:TcursorList):boolean;
var
  maxC:integer;
begin
  uo:=w;

  with uo do
  begin
    maxC:=maxCursor;
    caption:=uo.ident+' properties';

    ev  := Vevent;
    disp:= Vdisplay;
    zoom:=Vzoom;

    if ev<>nil
      then EditEvent.Text:=ev.ident
      else EditEvent.Text:='';
    if disp<>nil
      then EditDisplay.Text:=disp.ident
      else EditDisplay.Text:='';
    if zoom<>nil
      then EditZoom.Text:=zoom.ident
      else EditZoom.Text:='';

    Pselected.color:=color1;
    PotherCursors.color:=color2;
    Pcurrent.color:=Rcolor1;
    PotherCaptions.color:=Rcolor2;

    if color1=clBlack
      then Pselected.font.color:=clWhite
      else Pselected.font.color:=clBlack;

    if color2=clBlack
      then PotherCursors.font.color:=clWhite
      else PotherCursors.font.color:=clBlack;

    if Rcolor1=clBlack
      then Pcurrent.font.color:=clWhite
      else Pcurrent.font.color:=clBlack;

    if Rcolor2=clBlack
      then PotherCaptions.font.color:=clWhite
      else PotherCaptions.font.color:=clBlack;

    maxC:=maxCursor;
    enMaxCursors.setVar(maxC,t_longint);
    enMaxCursors.setMinMax(10,1000);

    enDeci.setVar(nbdeci,t_longint);
    cbAutoZoom.setvar(FautoZoom);

    result:=self.showModal=mrOK;
    if result then
      begin
        updateAllVar(self);

        Vevent:=ev;
        Vdisplay:=disp;
        Vzoom:=zoom;

        color1:=Pselected.color;
        color2:=PotherCursors.color;
        Rcolor1:=Pcurrent.color;
        Rcolor2:=PotherCaptions.color;

        MaxCursor:=maxC;
      end;
    end;

end;


procedure TClistProp.PselectedClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    color:=Pselected.color;
    if execute then
      begin
        Pselected.color:=color;
        if color=clBlack
          then Pselected.font.color:=clWhite
          else Pselected.font.color:=clBlack;
      end;
  end;
end;

procedure TClistProp.PotherCursorsClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    color:=PotherCursors.color;
    if execute then
      begin
        PotherCursors.color:=color;

        if color=clBlack
          then PotherCursors.font.color:=clWhite
          else PotherCursors.font.color:=clBlack;
      end;
  end;
end;

procedure TClistProp.PcurrentClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    color:=Pcurrent.color;
    if execute then
      begin
        Pcurrent.color:=color;
        if color=clBlack
          then Pcurrent.font.color:=clWhite
          else Pcurrent.font.color:=clBlack;
      end;

  end;
end;

procedure TClistProp.PotherCaptionsClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    color:=PotherCaptions.color;
    if execute then
      begin
        PotherCaptions.color:=color;

        if color=clBlack
          then PotherCaptions.font.color:=clWhite
          else PotherCaptions.font.color:=clBlack;
      end;
  end;
end;

procedure TClistProp.BeventClick(Sender: TObject);
begin
  chooseObject.caption:='Choose a vector';
  if chooseObject.execution(Tvector,typeUO(ev)) then
  begin
    if assigned(ev)
      then EditEvent.Text:= ev.ident
      else EditEvent.Text:='';
  end;
end;

procedure TClistProp.BdisplayClick(Sender: TObject);
begin
  chooseObject.caption:='Choose a vector';
  if chooseObject.execution(Tvector,typeUO(disp)) then
  begin
    if assigned(disp)
      then EditDisplay.Text:= disp.ident
      else EditDisplay.Text:='';
  end;
end;

procedure TClistProp.BzoomClick(Sender: TObject);
begin
  chooseObject.caption:='Choose a vector';
  if chooseObject.execution(Tvector,typeUO(zoom)) then
  begin
    if assigned(zoom)
      then EditZoom.Text:= zoom.ident
      else EditZoom.Text:='';
  end;
end;

Initialization
AffDebug('Initialization StmCListProp',0);
{$IFDEF FPC}
{$I StmCListProp.lrs}
{$ENDIF}
end.
