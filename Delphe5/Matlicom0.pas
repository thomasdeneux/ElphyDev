unit Matlicom0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, editcont,
  util1,Dgraphic, debug0;

type
  TmatListRecord=record
                 FdisplayGraph:boolean;
                 FontRec:TfontDescriptor;
                 color:integer;
               end;

  TMatlistOptions = class(TForm)
    cbDisplayGraph: TCheckBoxV;
    BbkColor: TButton;
    Pcolor: TPanel;
    Bfont: TButton;
    BOK: TButton;
    Bcancel: TButton;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    procedure BbkColorClick(Sender: TObject);
    procedure BfontClick(Sender: TObject);
  private
    { Private declarations }
    Rec0:TMatlistRecord;
    font0:Tfont;
  public
    { Public declarations }
    function execution(var Rec:TmatlistRecord):boolean;
  end;

var
  MatlistOptions: TMatlistOptions;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

function TMatlistOptions.execution(var Rec:TmatlistRecord):boolean;
begin
  Rec0:=Rec;
  font0:=Tfont.create;
  descToFont(Rec0.fontRec,font0);

  with Rec0 do
  begin
    cbDisplayGraph.setvar(FdisplayGraph);
    Pcolor.color:=color;
    result:=(showModal=mrOK);
  end;

  if result then
    begin
      updateAllVar(self);
      fontToDesc(font0,Rec0.fontRec);
      Rec:=Rec0;
    end;
end;


procedure TMatlistOptions.BbkColorClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    color:=Rec0.color;
    execute;
    Rec0.color:=color;
    Pcolor.color:=color;
  end;
end;

procedure TMatlistOptions.BfontClick(Sender: TObject);
begin
  with FontDialog1 do
  begin
    font:=font0;
    execute;
    font0:=font;
  end;
end;

Initialization
AffDebug('Initialization Matlicom0',0);
{$IFDEF FPC}
{$I Matlicom0.lrs}
{$ENDIF}
end.
