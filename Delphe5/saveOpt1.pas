unit saveOpt1;

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

  util1,Dutil1,debug0;


type
  TsaveRecord=
            object
              Xauto:boolean;  { si vrai, on prend les paramètres dx et ux des vecteurs }
              Dx:float;      { (supposés égaux) sinon on prend ceux-ci }
              ux:AnsiString;

              tpAuto:boolean; { si vrai, on prend le type de donnée des vecteurs (égaux)}
              tp:typetypeG;   { sinon on prend celui-ci }

              FileBlock,EpBlock:integer;

              stVecs:AnsiString;  {liste des vecteurs à sauver}
              Yauto:array[1..16] of boolean;{ si vrai, on prend les params Y des vecteurs}
              Dy:array[1..16] of float;  { (supposés égaux) sinon on prend ceux-ci }
              y0:array[1..16] of float;
              uy:array[1..16] of AnsiString;

              curY:integer;

              procedure init;
              procedure CopyTo(var rec:TsaveRecord);
            end;

type
  TSaveOptions = class(TForm)
    Bok: TButton;
    Bcancel: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    enFileInfo: TeditNum;
    Label4: TLabel;
    enEpInfo: TeditNum;
    GroupBox2: TGroupBox;
    Dx: TLabel;
    enDx: TeditNum;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    cbType: TcomboBoxV;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    enDy: TeditNum;
    Label5: TLabel;
    cbVecY: TcomboBoxV;
    Label6: TLabel;
    enY0: TeditNum;
    Label7: TLabel;
    Label8: TLabel;
    esUnitX: TeditString;
    esUnitY: TeditString;
    cbAutoX: TCheckBoxV;
    cbAutoTp: TCheckBoxV;
    cbAutoY: TCheckBoxV;
    procedure cbAutoXClick(Sender: TObject);
    procedure cbAutoYClick(Sender: TObject);
  private
    { Déclarations privées }
    rec0:TsaveRecord;
  public
    { Déclarations publiques }
    function execution(var rec:TsaveRecord):boolean;
    procedure setParamY;
    procedure setEnabled;
  end;

function SaveOptions: TSaveOptions;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FSaveOptions: TSaveOptions;

function SaveOptions: TSaveOptions;
begin
  if not assigned(FSaveOptions) then FSaveOptions:= TSaveOptions.create(nil);
  result:= FSaveOptions;
end;


procedure TsaveRecord.init;
var
  i:integer;
begin
  Xauto:=true;
  Dx:=1;
  ux:='';

  tpAuto:=true;
  tp:=G_single;

  FileBlock:=0;
  EpBlock:=0;

  stVecs:='';
  for i:=1 to 16 do
    begin
     Yauto[i]:=true;
     Dy[i]:=1;
     y0[i]:=0;
     uy[i]:='';
    end;
end;

procedure TsaveRecord.CopyTo(var rec:TsaveRecord);
var
  i:integer;
begin
  rec.Xauto:=Xauto;
  rec.Dx:=dx;
  rec.ux:=ux;

  rec.tpAuto:=tpAuto;
  rec.tp:=tp;

  rec.FileBlock:=FileBlock;
  rec.EpBlock:=EpBlock;

  rec.stVecs:=stVecs;

  for i:=1 to 16 do
    begin
      rec.Yauto:=Yauto;
      rec.Dy:=Dy;
      rec.y0:=y0;
      rec.uy:=uy;
    end;

  rec.curY:=curY;
end;

procedure TSaveOptions.setParamY;
begin
  with rec0 do
  begin
    cbAutoY.setvar(Yauto[curY]);
    enDy.setvar(Dy[curY],T_extended);
    enDy.decimal:=6;
    eny0.setvar(Y0[curY],T_extended);
    eny0.decimal:=6;
    esUnitY.setString(uy[curY],20);

    cbAutoY.setvar(Yauto[curY]);
    enDy.enabled:=not Yauto[curY];
    eny0.enabled:=not Yauto[curY];
    esUnitY.enabled:=not Yauto[curY];
  end;
end;

procedure TSaveOptions.setEnabled;
begin
  with rec0 do
  begin
    enDx.enabled:=not Xauto;
    esUnitX.enabled:=not Xauto;

    cbType.enabled:=not TpAuto;
  end;
end;


function TSaveOptions.execution(var rec:TsaveRecord):boolean;
var
  i,nb:integer;
  tp1:integer;
begin

  rec.copyTo(rec0);
  with rec0 do
  begin
    cbAutoX.setvar(Xauto);
    enDx.setvar(Dx,T_extended);
    enDx.decimal:=6;
    esUnitX.setString(ux,20);


    case tp of
      G_smallint:  tp1:=0;
      g_longint:  tp1:=1;
      g_single:   tp1:=2;
    end;

    cbAutoTp.setvar(TpAuto);
    cbType.setString('integer|longint|single');
    cbType.setvar(tp1,t_byte,0);

    enEpInfo.setVar(EpBlock,t_longint);
    enEpInfo.setMinMax(0,65536);
    enFileInfo.setVar(FileBlock,t_longint);
    enFileInfo.setMinMax(0,65536);

    setEnabled;

    with cbVecY do
    begin
      clear;
      nb:=nbItemSt(stVecs);
      for i:=1 to nb do items.add(getItemSt(stVecs,i));
      if (curY<=0) or (curY>nb) then curY:=1;
      if nb>0 then itemIndex:=curY-1 else itemIndex:=-1;
    end;

    setParamY;

  end;
  result:=(showModal=mrOK);
  if result then
    begin
      updateAllVar(self);

      case tp1 of
        0: rec0.tp:=G_smallint;
        1: rec0.tp:=g_longint;
        2: rec0.tp:=g_single;
      end;

      rec0.copyTo(rec);
    end;

end;

procedure TSaveOptions.cbAutoXClick(Sender: TObject);
begin
  updateAllVar(self);
  setEnabled;
end;

procedure TSaveOptions.cbAutoYClick(Sender: TObject);
begin
  updateAllVar(self);
  setParamY;

end;

Initialization
AffDebug('Initialization saveOpt1',0);
{$IFDEF FPC}
{$I saveOpt1.lrs}
{$ENDIF}
end.
