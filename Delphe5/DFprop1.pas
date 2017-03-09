unit DFprop1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont,
  stmdf0,descac1, ExtCtrls, debug0;

type
  TDataFileProp = class(TForm)
    Label2: TLabel;
    Bok: TButton;
    Bcancel: TButton;
    cbChan: TcomboBoxV;
    GroupBox1: TGroupBox;
    CheckBoxV1: TCheckBoxV;
    CheckBoxV2: TCheckBoxV;
    CheckBoxV3: TCheckBoxV;
    CheckBoxV4: TCheckBoxV;
    CheckBoxV5: TCheckBoxV;
    CheckBoxV6: TCheckBoxV;
    CheckBoxV7: TCheckBoxV;
    CheckBoxV8: TCheckBoxV;
    CheckBoxV9: TCheckBoxV;
    CheckBoxV10: TCheckBoxV;
    CheckBoxV11: TCheckBoxV;
    CheckBoxV12: TCheckBoxV;
    Label1: TLabel;
    cbSPK: TcomboBoxV;
    Label3: TLabel;
    cbNbUnit: TcomboBoxV;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    enSpkTable: TeditNum;
    Label5: TLabel;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    enPCLfilter: TeditNum;
    cbPhoton: TCheckBoxV;
    CheckBoxV13: TCheckBoxV;
  private
    { Déclarations privées }
    df:TdataFile;
    cb:array[0..12] of TcheckboxV;
  public
    { Déclarations publiques }
    procedure Execution(p:TdataFile;var nb,nbSPK, nbUnit:integer);
  end;

function DataFileProp: TDataFileProp;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FDataFileProp: TDataFileProp;

function DataFileProp: TDataFileProp;
begin
  if not assigned(FDataFileProp) then FDataFileProp:= TDataFileProp.create(nil);
  result:= FDataFileProp;
end;



{ TDataFileProp }

procedure TDataFileProp.Execution(p:TdataFile;var nb,nbSPK, nbUnit:integer);
var
  i:integer;
begin
  df:=p;

  cb[0]:=CheckBoxV1;
  cb[1]:=CheckBoxV2;
  cb[2]:=CheckBoxV3;
  cb[3]:=CheckBoxV4;
  cb[4]:=CheckBoxV5;
  cb[5]:=CheckBoxV6;
  cb[6]:=CheckBoxV7;
  cb[7]:=CheckBoxV8;
  cb[8]:=CheckBoxV9;
  cb[9]:=CheckBoxV10;
  cb[10]:=CheckBoxV11;
  cb[11]:=CheckBoxV12;
  cb[12]:=CheckBoxV13;

  caption:=df.ident+' properties';
  cbChan.SetNumList(8,256,8);
  cbChan.setNumVar(nb,t_longint);

  cbSPK.SetNumList(0,256,32);
  cbSPK.setNumVar(nbSpk,t_longint);

  cbNbUnit.SetNumList(1,10,1);
  cbNbUnit.setvar(nbUnit,t_longint,2);

  enSpkTable.setVar(df.spkTableNum,t_longint);

  cbPhoton.setVar(df.HasPCL);
  enPCLfilter.setVar(df.NumPCLfilter,t_longint);

  for i:=0 to 12 do
  begin
    cb[i].Caption:=Tdesc[i].FileTypeName;
    cb[i].setVar(TestedFiles[i]);
  end;

  if showModal=mrOK then updateAllvar(self);
end;

Initialization
AffDebug('Initialization DFprop1',0);
{$IFDEF FPC}
{$I DFprop1.lrs}
{$ENDIF}
end.
