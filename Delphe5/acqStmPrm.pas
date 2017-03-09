unit AcqstmPrm;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  Windows,

  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, editcont, Buttons,

  stmdef,stmObj,stmObv0,
  {$IFDEF DX11}FXctrlDX11,{$ELSE} FxCtrlDX9 , {$ENDIF}
  stmVS0, debug0;

type
  TAcqstimParam = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    enPeriod: TeditNum;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    enChannel1: TeditNum;
    Label5: TLabel;
    enChannel2: TeditNum;
    Label3: TLabel;
    enSeuilP1: TeditNum;
    enSeuilP2: TeditNum;
    Label4: TLabel;
    Label6: TLabel;
    GroupBox3: TGroupBox;
    Image1: TImage;
    Label7: TLabel;
    enPos1: TeditNum;
    enPos2: TeditNum;
    Label8: TLabel;
    Label9: TLabel;
    enSize1: TeditNum;
    enSize2: TeditNum;
    Label10: TLabel;
    enShift1: TeditNum;
    enShift2: TeditNum;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    CbtrackedObj: TComboBox;
    BOK: TButton;
    Bcancel: TButton;
    Label14: TLabel;
    enDelay: TeditNum;
    Bcol1: TBitBtn;
    Pcol1: TPanel;
    Pcol2: TPanel;
    Bcol2: TBitBtn;
    ColorDialog1: TColorDialog;
    cbDisplay: TCheckBoxV;
    cbMode1: TcomboBoxV;
    cbMode2: TcomboBoxV;
    GroupBox4: TGroupBox;
    Label15: TLabel;
    cbSynchro: TcomboBoxV;
    Label16: TLabel;
    cbControl: TcomboBoxV;
    Label17: TLabel;
    cbTriggerMode: TcomboBoxV;
    procedure Bcol1Click(Sender: TObject);
    procedure Bcol2Click(Sender: TObject);
  private
    { Private declarations }
    fx0:pointer;
  public
    { Public declarations }
    function execution(fx:pointer):boolean;
  end;

function AcqstimParam: TAcqstimParam;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FAcqstimParam: TAcqstimParam;

function AcqstimParam: TAcqstimParam;
begin
  if not assigned(FAcqstimParam) then FAcqstimParam:= TAcqstimParam.create(nil);
  result:= FAcqstimParam;
end;

procedure TAcqstimParam.Bcol1Click(Sender: TObject);
begin
  with colorDialog1 do
  begin
    color:=Pcol1.color;
    if execute then Pcol1.color:=color;
  end;
end;

procedure TAcqstimParam.Bcol2Click(Sender: TObject);
begin
  with colorDialog1 do
  begin
    color:=Pcol2.color;
    if execute then Pcol2.color:=color;
  end;
end;

function TAcqstimParam.execution(fx:pointer):boolean;
var
  obv:Tresizable;
begin
  fx0:=fx;
  with TFxControl(Fx0) do
  begin
    enPeriod.setvar(Tbase,t_extended);
    enPeriod.setminmax(0.001,1000);

    cbTriggerMode.setString('Digital  |Immediate ');
    cbTriggerMode.setVar(VSnotrigger,t_byte,0);

    cbSynchro.setString('Vtag1|Vtag2|v1|v2|v3|v4|v5|v6|v7|v8|v9|v10|v11|v12|v13|v14|v15|v16');
    cbSynchro.setVar(VSSyncInput,t_byte,0);

    cbControl.setString('Vtag1|Vtag2|v1|v2|v3|v4|v5|v6|v7|v8|v9|v10|v11|v12|v13|v14|v15|v16');
    cbControl.setVar(VSControlInput,t_byte,0);

    enChannel1.setvar(TrackChannel[1],t_longint);
    enChannel1.setminmax(0,15);
    enChannel2.setvar(TrackChannel[2],t_longint);
    enChannel2.setminmax(0,15);

    enSeuilP1.setvar(TrackSeuilP[1],t_extended);
    enSeuilP2.setvar(TrackSeuilP[2],t_extended);

    cbMode1.setString('Rising edge|Falling edge');
    cbMode1.setvar(TrackMode[1],t_byte,0);
    cbMode2.setString('Rising edge|Falling edge');
    cbMode2.setvar(TrackMode[2],t_byte,0);


    enPos1.setvar(TrackPoint[1],t_smallint);
    enPos1.setminmax(0,9);
    enPos2.setvar(TrackPoint[2],t_smallint);
    enPos2.setminmax(0,9);

    Pcol1.color:=TrackColor[1];
    Pcol2.color:=TrackColor[2];

    enSize1.setvar(DotSize[1],t_smallint);
    enSize1.setminmax(0,50);
    enSize2.setvar(DotSize[2],t_smallint);
    enSize2.setminmax(0,50);

    enShift1.setvar(TrackShift[1],t_smallint);
    enShift1.setminmax(-500,500);
    enShift2.setvar(TrackShift[2],t_smallint);
    enShift2.setminmax(-500,500);

    InstalleComboBox(CBtrackedObj,trackObvis,Tresizable);

    enDelay.setvar(TrackDelay,t_extended);
    enDelay.setminmax(-500,500);

    cbDisplay.setVar(FdisplayData);




    result:=(self.showModal=mrOK);

    if result then
      begin
        updateAllVar(self);
        with cbTrackedObj do
        if (itemIndex>=0) and (itemIndex<items.count-1)
          then Obv:=Tresizable(items.objects[itemIndex])
          else Obv:=nil;
        visualStim.setTrackObvis(obv);

        TrackColor[1]:=Pcol1.color;
        TrackColor[2]:=Pcol2.color;
      end;
  end;
end;

Initialization
AffDebug('Initialization AcqstmPrm',0);
{$IFDEF FPC}
{$I AcqStmPrm.lrs}
{$ENDIF}


end.
