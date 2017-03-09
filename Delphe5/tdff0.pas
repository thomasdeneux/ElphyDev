unit tdff0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Buttons, ExtCtrls,

  util1, debug0;

type
  TdataFileForm = class(TForm)
    PanelName: TPanel;
    Panel2: TPanel;
    Bnext: TBitBtn;
    Bprevious: TBitBtn;
    PanelSeq: TPanel;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Load1: TMenuItem;
    NextFile1: TMenuItem;
    Previousfile1: TMenuItem;
    Informations1: TMenuItem;
    Averaging1: TMenuItem;
    procedure Load1Click(Sender: TObject);
    procedure NextFileClick(Sender: TObject);
    procedure Previousfile1Click(Sender: TObject);
    procedure Informations1Click(Sender: TObject);
    procedure BpreviousClick(Sender: TObject);
    procedure BnextClick(Sender: TObject);
    procedure Channels1Click(Sender: TObject);
    procedure Averaging1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    loadD,nextFileD,prevFileD,infoD:procedure of object;
    channelD:procedure of object;
    AveragingD:procedure of object;

    prevSeqD,nextSeqD:procedure of object;

    procedure AffNumSeq0(num:integer);
    procedure AffNomDat0(st:AnsiString);
  end;

var
  dataFileForm: TdataFileForm;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TdataFileForm.Load1Click(Sender: TObject);
begin
  if assigned(LoadD) then loadD;
end;

procedure TdataFileForm.NextFileClick(Sender: TObject);
begin
  if assigned(NextFileD) then nextFileD;
end;

procedure TdataFileForm.Previousfile1Click(Sender: TObject);
begin
  if assigned(prevFileD) then prevFileD;
end;

procedure TdataFileForm.Informations1Click(Sender: TObject);
begin
  if assigned(infoD) then infoD;
end;


procedure TdataFileForm.BpreviousClick(Sender: TObject);
begin
  if assigned(prevSeqD) then prevSeqD;
end;

procedure TdataFileForm.BnextClick(Sender: TObject);
begin
  if assigned(nextSeqD) then nextSeqD;
end;

procedure TdataFileForm.Channels1Click(Sender: TObject);
begin
  if assigned(ChannelD) then channelD;
end;

procedure TdataFileForm.Averaging1Click(Sender: TObject);
begin
  if assigned(AveragingD) then AveragingD;
end;

procedure TdataFileForm.AffNumSeq0(num:integer);
begin
  panelSeq.caption:=Istr(num);
  panelSeq.update;
end;

procedure TdataFileForm.AffNomDat0(st:AnsiString);
begin
  panelName.caption:=st;
end;

Initialization
AffDebug('Initialization tdff0',0);
{$IFDEF FPC}
{$I tdff0.lrs}
{$ENDIF}
end.
