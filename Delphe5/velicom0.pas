unit velicom0;

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
  TVlistRecord=record
                 FdisplayGraph:boolean;
                 FontRec:TfontDescriptor;
                 color:integer;
               end;

  TVlistOptions = class(TForm)
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
    Rec0:TVlistRecord;
    font0:Tfont;
  public
    { Public declarations }
    function execution(var Rec:TVlistRecord):boolean;
  end;

function VlistOptions: TVlistOptions;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FVlistOptions: TVlistOptions;

function VlistOptions: TVlistOptions;
begin
  if not assigned(FVlistOptions) then FVlistOptions:= TVlistOptions.create(nil);
  result:= FVlistOptions;
end;

function TVlistOptions.execution(var Rec:TVlistRecord):boolean;
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


procedure TVlistOptions.BbkColorClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    color:=Rec0.color;
    execute;
    Rec0.color:=color;
    Pcolor.color:=color;
  end;
end;

procedure TVlistOptions.BfontClick(Sender: TObject);
begin
  with FontDialog1 do
  begin
    font:=font0;
    execute;
    font0:=font;
  end;
end;

Initialization
AffDebug('Initialization velicom0',0);
{$IFDEF FPC}
{$I velicom0.lrs}
{$ENDIF}
end.
