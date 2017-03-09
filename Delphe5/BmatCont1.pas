unit BmatCont1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, editcont,

  util1, debug0,Gdos;

type
  TBuildContourForm = class(TForm)
    Bok: TButton;
    Bcancel: TButton;
    enNumber: TeditNum;
    Label1: TLabel;
    Label2: TLabel;
    enZmin: TeditNum;
    Label3: TLabel;
    enZmax: TeditNum;
    Button1: TButton;
    GroupBox1: TGroupBox;
    cbSel: TCheckBoxV;
    cbMark: TCheckBoxV;
    cbValue: TCheckBoxV;
    enValue: TeditNum;
    Bcolor: TButton;
    Pcolor: TPanel;
    ColorDialog1: TColorDialog;
    GroupBox2: TGroupBox;
    cbPalName: TComboBox;
    Label4: TLabel;
    enLineWidth: TeditNum;
    cbPolygons: TCheckBoxV;
    Label5: TLabel;
    enFirstLevel: TeditNum;
    cbPosition: TCheckBoxV;
    procedure Button1Click(Sender: TObject);
    procedure BcolorClick(Sender: TObject);
  private
    { Private declarations }
    adZmin,adZmax:Pfloat;
  public
    { Public declarations }
    PalName:AnsiString;

    getZminZmax:procedure(var Zmin, Zmax:float) of object;

    function execution(var nb:integer;var Zmin,Zmax:float;
                       var Fsel,Fmark,Fvalue:boolean;
                       var value:float;
                       var LineW:integer;
                       var Fpoly,FusePos:boolean;
                       var FirstLevel:float):boolean;
  end;

function BuildContourForm: TBuildContourForm;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FBuildContourForm: TBuildContourForm;

function BuildContourForm: TBuildContourForm;
begin
  if not assigned(FBuildContourForm) then FBuildContourForm:= TBuildContourForm.create(nil);
  result:= FBuildContourForm;
end;

function TBuildContourForm.execution(var nb:integer;var Zmin,Zmax:float;
                                     var Fsel,Fmark,Fvalue:boolean;
                                     var value:float;
                                     var LineW:integer;
                                     var Fpoly, FusePos:boolean;
                                     var FirstLevel:float):boolean;
var
  st:AnsiString;
  sr: TSearchRec;
begin
  adZmin:=@Zmin;
  adZmax:=@Zmax;

  enNumber.setVar(nb,t_longint);
  enNumber.setMinMax(1,10000);

  enZmin.setVar(Zmin,t_extended);
  enZmax.setVar(Zmax,t_extended);

  cbSel.setvar(Fsel);
  cbmark.setvar(Fmark);
  cbvalue.setvar(Fvalue);
  enValue.setVar(value,t_extended);

  enLineWidth.setVar(lineW,t_longint);
  cbPolygons.setVar(Fpoly);
  cbPosition.setvar(FusePos);

  enFirstLevel.setVar(FirstLevel,g_extended);

  with cbPalName do
  begin
    clear;
    items.add('None');
    itemIndex:=0;

    items.add('R');
    if palName='R' then itemIndex:=items.count-1;

    items.add('G');
    if palName='G' then itemIndex:=items.count-1;

    items.add('B');
    if palName='B' then itemIndex:=items.count-1;

    items.add('RG');
    if palName='RG' then itemIndex:=items.count-1;

    items.add('RB');
    if palName='RB' then itemIndex:=items.count-1;

    items.add('GB');
    if palName='GB' then itemIndex:=items.count-1;

    items.add('RGB');
    if palName='RGB' then itemIndex:=items.count-1;


    if FindFirst( AppData +'*.pl1', faAnyFile, sr) = 0 then
      begin
        repeat
          st:=copy(sr.Name,1,pos('.',sr.Name)-1);
          items.add(st);
          if Fmaj(st)=Fmaj(palName) then itemIndex:=items.count-1;
        until FindNext(sr)<>0;
        FindClose(sr);
      end;
  end;


  result:=(showModal=mrOK);
  if result then
  begin
    updateAllVar(self);
    palName:=cbPalName.Text ;
  end;

end;

procedure TBuildContourForm.Button1Click(Sender: TObject);
begin
  getZminZmax(adZmin^,adZmax^);
  enZmin.updateCtrl;
  enZmax.updateCtrl;
end;

procedure TBuildContourForm.BcolorClick(Sender: TObject);
begin
   with colorDialog1 do
  begin
    color:=PColor.color;
    execute;
    Pcolor.color:=color;
  end;

end;

Initialization
AffDebug('Initialization BmatCont1',0);
{$IFDEF FPC}
{$I BmatCont1.lrs}
{$ENDIF}
end.
