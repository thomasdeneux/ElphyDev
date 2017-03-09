unit saveOptF;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont,
  util1, debug0;

type
  TSaveDFOptions = class(TForm)
    Bok: TButton;
    Bcancel: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    enFileInfo: TeditNum;
    Label4: TLabel;
    LfileInfo: TLabel;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    LepInfo: TLabel;
    enEpInfo: TeditNum;
    cbCopyFileInfo: TCheckBoxV;
    cbCopyEpInfo: TCheckBoxV;
    procedure cbCopyEpInfoClick(Sender: TObject);
  private
    { Déclarations privées }
    adFileBlock,adEpBlock:^integer;
    FileMin1,EpMin1:integer;
  public
    { Déclarations publiques }
    function execution(var FileBlock,EpBlock:integer;FileMin,EpMin:integer;
                       var FileCopy,EpCopy:boolean):boolean;
  end;


function SaveDFOptions: TSaveDFOptions;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FSaveDFOptions: TSaveDFOptions;

function SaveDFOptions: TSaveDFOptions;
begin
  if not assigned(FSaveDFOptions) then FSaveDFOptions:= TSaveDFOptions.create(nil);
  result:= FSaveDFOptions;
end;

function TSaveDFOptions.execution(var FileBlock,EpBlock:integer;FileMin,EpMin:integer;
                                  var FileCopy,EpCopy:boolean):boolean;
begin

  adFileBlock:=@FileBlock;
  adEpBlock:=@EpBlock;

  FileMin1:=fileMin;
  EpMin1:=EpMin;

  enEpInfo.setVar(EpBlock,t_longint);
  enEpInfo.setMinMax(EpMin,65536);
  enFileInfo.setVar(FileBlock,t_longint);
  enFileInfo.setMinMax(FileMin,65536);

  LfileInfo.caption:=Istr(FileMin);
  LepInfo.caption:=Istr(EpMin);

  cbCopyFileInfo.setvar(FileCopy);
  cbCopyEpInfo.setvar(EpCopy);

  result:=(showModal=mrOK);
  if result then updateAllVar(self);
end;

procedure TSaveDFOptions.cbCopyEpInfoClick(Sender: TObject);
begin
  with TCheckBoxV(sender) do
  if checked then
    case tag of
      1:if adFileBlock^<fileMin1 then
          begin
            adFileBlock^:=fileMin1;
            enFileInfo.updateCtrl;
          end;
      2:if adEpBlock^<EpMin1 then
          begin
            adEpBlock^:=EpMin1;
            enEpInfo.updateCtrl;
          end;
    end;
end;

Initialization
AffDebug('Initialization saveOptF',0);
{$IFDEF FPC}
{$I saveOptF.lrs}
{$ENDIF}
end.
