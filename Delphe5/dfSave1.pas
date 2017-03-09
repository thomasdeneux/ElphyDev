unit dfSave1;

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

  util1,saveOptF, debug0;

type
  arrayOfBoolean=array of boolean;
type
  TDfSaveList = class(TForm)
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
    CheckBoxV13: TCheckBoxV;
    CheckBoxV14: TCheckBoxV;
    CheckBoxV15: TCheckBoxV;
    CheckBoxV16: TCheckBoxV;
    BsaveData: TButton;
    Boptions: TButton;
    Label6: TLabel;
    enXstart: TeditNum;
    Label7: TLabel;
    enXend: TeditNum;
    Bautoscale: TButton;
    Label1: TLabel;
    enXorg: TeditNum;
    cbCont: TCheckBoxV;
    procedure FormCreate(Sender: TObject);
    procedure BautoscaleClick(Sender: TObject);
    procedure BoptionsClick(Sender: TObject);
  private
    { Déclarations privées }
    cbV:array[1..16] of TCheckBoxV;
    XstartD,XendD:Pfloat;
    XminiD,XmaxiD:float;

    adFileBlock,adEpBlock:^integer;
    FileMin1,EpMin1:integer;
    adFileCopy,adEpCopy:^boolean;

  public
    { Déclarations publiques }
    function execution(voies:boolean;
                       titre:AnsiString;nbvoie:integer;var ch:arrayofBoolean;
                       var Xorg,xstart,Xend:float;mini,maxi:float;
                       var FileBlock,EpBlock:integer;FileMin,EpMin:integer;
                       var FileCopy,EpCopy:boolean;
                       var Fcont:boolean
                       ):integer;
  end;

function DfSaveList: TDfSaveList;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FDfSaveList: TDfSaveList;

function DfSaveList: TDfSaveList;
begin
  if not assigned(FDfSaveList) then FDfSaveList:= TDfSaveList.create(nil);
  result:= FDfSaveList;
end;

procedure TDfSaveList.FormCreate(Sender: TObject);
begin
  cbV[1]:=CheckBoxV1;
  cbV[2]:=CheckBoxV2;
  cbV[3]:=CheckBoxV3;
  cbV[4]:=CheckBoxV4;
  cbV[5]:=CheckBoxV5;
  cbV[6]:=CheckBoxV6;
  cbV[7]:=CheckBoxV7;
  cbV[8]:=CheckBoxV8;
  cbV[9]:=CheckBoxV9;
  cbV[10]:=CheckBoxV10;
  cbV[11]:=CheckBoxV11;
  cbV[12]:=CheckBoxV12;
  cbV[13]:=CheckBoxV13;
  cbV[14]:=CheckBoxV14;
  cbV[15]:=CheckBoxV15;
  cbV[16]:=CheckBoxV16;

end;

function TDfSaveList.execution(voies:boolean;
                       titre:AnsiString;nbvoie:integer;var ch:arrayofBoolean;
                       var Xorg,xstart,Xend:float;mini,maxi:float;
                       var FileBlock,EpBlock:integer;FileMin,EpMin:integer;
                       var FileCopy,EpCopy:boolean;
                       var Fcont:boolean
                       ):integer;
var
  i:integer;
begin
  if voies then
    for i:=1 to 16 do cbV[i].caption:='v'+Istr(i)
  else
    for i:=1 to 16 do cbV[i].caption:='ev'+Istr(i);

  caption:=titre;
  for i:=1 to 16 do
    begin
      if voies
        then cbv[i].enabled:=(i<=nbvoie)
        else cbv[i].enabled:=false;
      cbv[i].setvar(ch[i-1]);
    end;

  XstartD:=@Xstart;
  XendD:=@Xend;
  XminiD:=mini;
  XmaxiD:=maxi;

  enXstart.setVar(Xstart,t_extended);
  enXend.setVar(Xend,t_extended);

  enXorg.setVar(Xorg,t_extended);

  adFileBlock:=@FileBlock;
  adEpBlock:=@EpBlock;
  FileMin1:=FileMin;
  EpMin1:=EpMin;
  adFileCopy:=@FileCopy;
  adEpCopy:=@EpCopy;

  Boptions.enabled:=voies;
  enXorg.enabled:=voies;

  cbCont.setVar(Fcont);

  i:=showModal;
  if i<>0 then updateAllVar(self);
  case i of
    100:result:=1;
    101:result:=2;
    else result:=0;
  end;
end;

procedure TDfSaveList.BautoscaleClick(Sender: TObject);
begin
  XstartD^:=XminiD;
  XendD^:=XmaxiD;

  enXstart.updateCtrl;
  enXend.updateCtrl;

end;

procedure TDfSaveList.BoptionsClick(Sender: TObject);
begin
  saveDFOptions.execution(adFileBlock^,adEpBlock^,filemin1,epmin1,adfileCopy^,adEpCopy^);
end;

Initialization
AffDebug('Initialization dfSave1',0);
{$IFDEF FPC}
{$I dfSave1.lrs}
{$ENDIF}
end.
