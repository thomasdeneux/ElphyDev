unit ObjFileO;

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

  util1,Dgraphic,debug0;


type
  TObjectFileRecord=record
                      FdisplayInfo,FdisplayGraph:boolean;
                      FontRec:TfontDescriptor;
                      color:integer;
                    end;
type
  TObjectFileOptions = class(TForm)
    cbDisplayInfo: TCheckBoxV;
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
    FileRec0:TObjectFileRecord;
    font0:Tfont;
  public
    { Public declarations }
    function execution(var FileRec:TObjectFileRecord):boolean;
  end;


var
  ObjFileDefOptions: TObjectFileRecord;

function ObjectFileOptions: TObjectFileOptions;

implementation


{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FObjectFileOptions: TObjectFileOptions;

function ObjectFileOptions: TObjectFileOptions;
begin
  if not assigned(FObjectFileOptions) then FObjectFileOptions:= TObjectFileOptions.create(nil);
  result:= FObjectFileOptions;
end;

function TObjectFileOptions.execution(var FileRec:TObjectFileRecord):boolean;
begin
  fileRec0:=fileRec;
  font0:=Tfont.create;
  descToFont(fileRec0.fontRec,font0);

  with fileRec0 do
  begin
    cbDisplayInfo.setvar(FdisplayInfo);
    cbDisplayGraph.setvar(FdisplayGraph);
    Pcolor.color:=color;
    result:=(showModal=mrOK);

  end;

  if result then
    begin
      updateAllVar(self);
      fontToDesc(font0,fileRec0.fontRec);
      fileRec:=fileRec0;
      ObjFileDefOptions:=fileRec0;
    end;
end;

procedure TObjectFileOptions.BbkColorClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    color:=fileRec0.color;
    execute;
    fileRec0.color:=color;
    Pcolor.color:=color;
  end;
end;

procedure TObjectFileOptions.BfontClick(Sender: TObject);
begin
  with FontDialog1 do
  begin
    font:=font0;
    execute;
    font0:=font;
  end;
end;

Initialization
AffDebug('Initialization ObjFileO',0);
{$IFDEF FPC}
{$I ObjFileO.lrs}
{$ENDIF}

with ObjFileDefOptions do
begin
  FdisplayInfo:=true;
  FdisplayGraph:=true;
  color:=clwhite;

  FontRec.init;
end;

end.
