unit Dmoyac2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  util1,Gdos,Ncdef2, debug0,
  tagBloc1,editcont,
  stmDef,stmObj;


type
  TAverageBox = class(TForm)
    Btag: TButton;
    Buntag: TButton;
    Bclear: TButton;
    BtagBlock: TButton;
    Bsave: TButton;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    cbStdDev: TCheckBoxV;
    GroupBox2: TGroupBox;
    Bappend: TButton;
    procedure BtagClick(Sender: TObject);
    procedure BuntagClick(Sender: TObject);
    procedure BtagBlockClick(Sender: TObject);
    procedure BclearClick(Sender: TObject);
    procedure BsaveClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cbStdDevClick(Sender: TObject);
    procedure BappendClick(Sender: TObject);
  private
    { Déclarations private }
    owner0:typeUO;
  public
    { Déclarations public }
    debutBloc,finBloc,stepBloc:integer;
    DejaAff:boolean;

    procedure install(owner1:typeUO);
    procedure afficher;
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
uses stmdf0;


procedure TAverageBox.install(owner1:typeUO);
begin
  owner0:=owner1;
  caption:=TdataFile(owner0).ident+': averaging';
  cbStdDev.Checked:=TdataFile(owner0).FmoyStd;
  afficher;
end;


procedure TAverageBox.BtagClick(Sender: TObject);
begin
  TdataFile(owner0).Dtag;
  afficher;
end;

procedure TAverageBox.BuntagClick(Sender: TObject);
begin
  TdataFile(owner0).Duntag;
  afficher;
end;

procedure TAverageBox.BtagBlockClick(Sender: TObject);
begin
  if tagBlock.execution(debutBloc,finBloc,stepBloc,TdataFile(owner0).EpCount) then
    begin
      TdataFile(owner0).DtagBloc;
      afficher;
    end;
end;

procedure TAverageBox.BclearClick(Sender: TObject);
begin
  TdataFile(owner0).DclearMoy;
  afficher;
end;

procedure TAverageBox.afficher;
begin
  memo1.lines.clear;
  memo1.lines.add(TdataFile(owner0).DgetStTag);
end;

procedure TAverageBox.FormActivate(Sender: TObject);
begin
  if not dejaAff then
    begin
      dejaAff:=true;
      top:=formStm.top+formStm.height-height;
      left:=formStm.left+50;
    end;
  afficher;
end;

procedure TAverageBox.cbStdDevClick(Sender: TObject);
var
  old:boolean;
begin
  TdataFile(owner0).setMoyStd(cbStdDev.Checked);
  cbStdDev.Checked:=TdataFile(owner0).FMoyStd;
end;

procedure TAverageBox.BsaveClick(Sender: TObject);
begin
  TdataFile(owner0).saveAverage(false);
end;

procedure TAverageBox.BappendClick(Sender: TObject);
begin
  TdataFile(owner0).saveAverage(true);
end;


Initialization
AffDebug('Initialization Dmoyac2',0);
{$IFDEF FPC}
{$I Dmoyac2.lrs}
{$ENDIF}
end.
