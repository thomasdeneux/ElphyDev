unit Colsat1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls,

  util1,Gdos, Dpalette, colorPan1,visu0, editcont, debug0;

type
  TStmColSat = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    PaintBox1: TPaintBox;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    BOK: TButton;
    Bcancel: TButton;
    GroupBox1: TGroupBox;
    cbPalName: TComboBox;
    GroupBox2: TGroupBox;
    Panel12: TPanel;
    sbNbCol: TScrollBar;
    Pnbcol: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    sbGamma: TScrollBar;
    Pgamma: TPanel;
    Panel18: TPanel;
    SelPan: TcolorPan;
    MarkPan: TcolorPan;
    cbFull2D: TCheckBoxV;
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure SBnbcolChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SBgammaChange(Sender: TObject);
    procedure cbPalNameChange(Sender: TObject);
  private
    { Déclarations private }
    nbCol:integer;
    p1,p2:byte;
    visu0:^TvisuInfo;
    procedure setCaption;

  public
    { Déclarations public }
    function execution(var degP1,degP2:byte;var palName:AnsiString;var visu1:TvisuInfo):boolean;
  end;

function StmColSat: TStmColSat;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FStmColSat: TStmColSat;

function StmColSat: TStmColSat;
begin
  if not assigned(FStmColSat) then FStmColSat:= TStmColSat.create(nil);
  result:= FStmColSat;
end;

procedure TStmColSat.FormCreate(Sender: TObject);
begin
  p1:=1;
  p2:=2;
  panel1.color:=rgb(255,0,0);
  panel2.color:=rgb(0,255,0);
  panel3.color:=rgb(0,0,255);
  panel4.color:=rgb(255,255,0);
  panel5.color:=rgb(0,255,255);
  panel6.color:=rgb(255,0,255);
  panel7.color:=rgb(255,255,255);

  panel21.color:=rgb(255,0,0);
  panel22.color:=rgb(0,255,0);
  panel23.color:=rgb(0,0,255);
  panel24.color:=rgb(255,255,0);
  panel25.color:=rgb(0,255,255);
  panel26.color:=rgb(255,0,255);
  panel27.color:=rgb(255,255,255);

  nbCol:=256;
  PnbCol.caption:=Istr(nbCol);
  SBnbCol.setParams(nbCol,1,256);
    
end;

procedure TStmColSat.setCaption;
  var
    i:integer;
  begin
    for i := 0 to ComponentCount -1 do
      if Components[i] is TPanel then
        with TPanel(Components[i]) do
          if (tag=P1) then caption:='+'
          else
          if (tag=P2+10) then caption:='-'
          else
          if tag<>0 then caption:='';
  end;

procedure TStmColSat.Panel1Click(Sender: TObject);
begin
  with Tpanel(sender) do
    if (tag>=1) and (tag<=7) then P1:=tag
    else
    if (tag>=11) and (tag<=17) then P2:=tag-10;
  setCaption;
  formPaint(self);
end;




procedure TStmColSat.FormPaint(Sender: TObject);
var
  i:integer;
  x1,x2:integer;
  dp:TDpalette;
  k:longint;
begin
  dp:=TDpalette.create;
  dp.setType(cbPalName.text);
  dp.setColors(P1,P2,false,paintbox1.canvas.handle);
  if assigned(visu0)
    then dp.setPalette(0,nbCol-1,visu0^.gamma);
  with paintBox1,canvas do
  begin
    for i:=0 to nbCol-1 do
      begin
        x1:=round(width/nbCol*i);
        x2:=round(width/nbCol*(i+1));

        k:=dp.ColorPal(i);
        brush.color:=k;

        {Un bug sur certaines couleurs fait qu'il est préférable de ne pas
         utiliser le stylo }
        pen.style:=psClear;

        rectangle(x1-1,0,x2+1,height);
      end;
  end;
end;

procedure TStmColSat.SBnbcolChange(Sender: TObject);
begin
  nbCol:=SBnbCol.position;
  PnbCol.caption:=Istr(nbCol);
  formPaint(self);
end;

procedure TStmColSat.FormActivate(Sender: TObject);
begin
  setCaption;
end;

procedure TStmColSat.SBgammaChange(Sender: TObject);
begin
  if assigned(visu0) then
  begin
    visu0^.gamma:=SBgamma.position/10;
    Pgamma.caption:=Estr(visu0^.gamma,2);
  end;  
  formPaint(self);
end;

function TStmColSat.execution(var degP1,degP2:byte;var palName:AnsiString;var visu1:TvisuInfo):boolean;
var
  sr: TSearchRec;
  st:AnsiString;

begin
  p1:=degP1;
  p2:=degP2;

  visu0:=@visu1;
  with cbPalName do
  begin
    clear;
    items.add('Monochrome');
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

  if assigned(visu0) then
  begin
    Pgamma.caption:=Estr(visu0^.gamma,2);
    SBgamma.setParams(round(visu0^.gamma*10),1,100);
    cbFull2D.setVar(visu0^.FullD2);
  end;

  SelPan.init(visu1.selectCol,true);
  MarkPan.init(visu1.MarkCol,true);


  if showModal=mrOK then
    begin
      degP1:=p1;
      degP2:=p2;
      palName:=cbPalName.text;
      execution:=true;
    end
  else execution:=false;
end;


procedure TStmColSat.cbPalNameChange(Sender: TObject);
begin
  formPaint(self);
end;

Initialization
AffDebug('Initialization colSat1',0);
{$IFDEF FPC}
{$I Colsat1.lrs}
{$ENDIF}
end.
