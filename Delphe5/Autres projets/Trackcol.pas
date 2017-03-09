unit Trackcol;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,

  Dgraphic,stmDef, StdCtrls, ExtCtrls, editcont, Dpalette;

type
  TgetTrackColor = class(TForm)
    GroupBox1: TGroupBox;
    pb1: TPaintBox;
    tr11: TPanel;
    tr12: TPanel;
    tr13: TPanel;
    tr14: TPanel;
    tr15: TPanel;
    tr16: TPanel;
    tr17: TPanel;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    ScrollBar3: TScrollBar;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    pb2: TPaintBox;
    Label3: TLabel;
    Label4: TLabel;
    tr21: TPanel;
    tr22: TPanel;
    tr23: TPanel;
    tr24: TPanel;
    tr25: TPanel;
    tr26: TPanel;
    tr27: TPanel;
    ScrollBar4: TScrollBar;
    ScrollBar5: TScrollBar;
    ScrollBar6: TScrollBar;
    Label5: TLabel;
    Label6: TLabel;
    Button1: TButton;
    LBdot1: TLabel;
    enDot1: TeditNum;
    Label7: TLabel;
    enDot2: TeditNum;
    Label8: TLabel;
    enDelta1: TeditNum;
    Label9: TLabel;
    enDelta2: TeditNum;
    Label10: TLabel;
    enDelay: TeditNum;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ScrollBar5Change(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar3Change(Sender: TObject);
    procedure tr11Click(Sender: TObject);
  private
    { Déclarations private }
    procedure WMQueryNewPalette(var message:TWMQueryNewPalette);message WM_QueryNewPalette;
    procedure WMPALETTECHANGED (var message:TWMPALETTECHANGED );message WM_PALETTECHANGED ;

    procedure setCaption;
  public
    { Déclarations public }
    procedure execution;
  end;

var
  getTrackColor: TgetTrackColor;

implementation

{$R *.DFM}

procedure TgetTrackColor.FormCreate(Sender: TObject);
begin
  tr11.color:=rgb(255,0,0);
  tr12.color:=rgb(0,255,0);
  tr13.color:=rgb(0,0,255);
  tr14.color:=rgb(255,255,0);
  tr15.color:=rgb(0,255,255);
  tr16.color:=rgb(255,0,255);
  tr17.color:=rgb(255,255,255);

  tr21.color:=rgb(255,0,0);
  tr22.color:=rgb(0,255,0);
  tr23.color:=rgb(0,0,255);
  tr24.color:=rgb(255,255,0);
  tr25.color:=rgb(0,255,255);
  tr26.color:=rgb(255,0,255);
  tr27.color:=rgb(255,255,255);

  ScrollBar1.setParams(trackColMin[1],-16,16);
  ScrollBar2.setParams(round(TrackColgamma[1]*10),1,100);
  ScrollBar3.setParams(trackColMax[1],1,16);

  ScrollBar4.setParams(trackColMin[2],-16,16);
  ScrollBar5.setParams(round(TrackColgamma[2]*10),1,100);
  ScrollBar6.setParams(trackColMax[2],1,16);

  enDot1.setvar(DotSize[1],T_smallInt);
  enDot1.setMinMax(0,10);

  enDot2.setvar(DotSize[2],T_smallInt);
  enDot2.setMinMax(0,10);

  enDelta1.setvar(TrackShift[1],T_smallInt);
  enDelta1.setMinMax(-10,10);

  enDelta2.setvar(TrackShift[2],T_smallInt);
  enDelta2.setMinMax(-10,10);

  enDelay.setvar(TrackDelay,T_smallInt);
  enDelay.setMinMax(0,20);

end;

procedure TgetTrackColor.setCaption;
  var
    i:integer;
  begin
    for i := 0 to ComponentCount -1 do
      if Components[i] is TPanel then
        with TPanel(Components[i]) do
          if (tag=trackColor[1]) or (tag-10=trackColor[2])
            then caption:='+'
          else
          if tag<>0 then caption:='';
  end;


procedure TgetTrackColor.FormPaint(Sender: TObject);
var
  i:integer;
  x1,x2:integer;
begin
  calculeTrackColor;
  with pb1,canvas do
  begin
    selectDpaletteHandle(handle);
    for i:=1 to 16 do
      begin
        x1:=round(width/16*(i-1));
        x2:=round(width/16*i);

        pen.style:=psClear;
        brush.color:=tabTrackColor[1,i];

        rectangle(x1,0,x2,height);
      end;
  end;

  with pb2,canvas do
  begin
    selectDpaletteHandle(handle);
    for i:=1 to 16 do
      begin
        x1:=round(width/16*(i-1));
        x2:=round(width/16*i);

        pen.style:=psClear;
        brush.color:=tabTrackColor[2,i];

        rectangle(x1,0,x2,height);
      end;
  end;
  setCaption;
end;

procedure TgetTrackColor.ScrollBar5Change(Sender: TObject);
begin
  with TscrollBar(sender) do
  begin
    TrackColGamma[tag]:=position/10;
    formPaint(self);
  end;
end;

procedure TgetTrackColor.ScrollBar1Change(Sender: TObject);
begin
  with TscrollBar(sender) do
  begin
    TrackColMin[tag]:=position;
    if trackColMin[tag]>trackColMax[tag]
      then trackColMin[tag]:=trackColMax[tag];
    formPaint(self);
  end;
end;

procedure TgetTrackColor.ScrollBar3Change(Sender: TObject);
begin
  with TscrollBar(sender) do
  begin
    TrackColMax[tag]:=position;
    if trackColMin[tag]>trackColMax[tag]
      then trackColMax[tag]:=trackColMin[tag];
    formPaint(self);
  end;
end;

procedure TgetTrackColor.execution;
begin
  showModal;
end;

procedure TgetTrackColor.tr11Click(Sender: TObject);
begin
  with Tpanel(sender) do
    if (tag>=1) and (tag<=7) then trackColor[1]:=tag
    else
    if (tag>=11) and (tag<=17) then trackColor[2]:=tag-10;
  formPaint(self);
  setCaption;
end;

procedure TgetTrackColor.WMQueryNewPalette(var message:TWMQueryNewPalette);
begin
  StmQueryNewPalette(self,pb1.canvas.handle,message);
  StmQueryNewPalette(self,pb2.canvas.handle,message);
end;

procedure TgetTrackColor.WMPALETTECHANGED (var message:TWMPALETTECHANGED );
begin
  StmPaletteChanged(self.handle,pb1.canvas.handle,message);
  StmPaletteChanged(self.handle,pb2.canvas.handle,message);
end;

end.
