unit testA;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls,
  util1,Dgraphic,dtf0,Dtrace1,visu0, cood0, Menus,acqBuf0;

type
  TAcq = class(TForm)
    PaintBox1: TPaintBox;
    MainMenu1: TMainMenu;
    Coordinates1: TMenuItem;
    Histogram1: TMenuItem;
    Durations1: TMenuItem;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Histogram1Click(Sender: TObject);
  private
    { Déclarations private }
    data:PDataI;
    data2:PdataL;
    dataCadrer:PdataE;

    procedure cadrerX(sender:Tobject);
    procedure cadrerY(sender:Tobject);
    function chooseCoo(var vv:TvisuInfo;dd:PdataE):boolean;
  public
    { Déclarations public }
    visu,visu2:TvisuInfo;
    visu0:^TvisuInfo;

  end;

var
  Acq: TAcq;

implementation

{$R *.DFM}

procedure TAcq.cadrerX(sender:Tobject);
  begin
    visu0^.cadrerX(dataCadrer);
  end;

procedure TAcq.cadrerY(sender:Tobject);
  begin
    visu0^.cadrerY(dataCadrer);
  end;


function TAcq.chooseCoo(var vv:TvisuInfo;dd:PdataE):boolean;
  var
    cooD:Tcood;
    chg:boolean;
  begin
    dataCadrer:=dd;
    cooD:=Tcood.create(self);
    new(visu0);

    visu0^:=vv;

    if cood.choose(visu0^,cadrerX,cadrerY) then
      begin
        chg:= not blocsEgaux(visu,visu0^,sizeof(visu));
        vv:=visu0^;
      end
    else chg:=false;
    cood.free;
    dispose(visu0);
    chooseCoo:=chg;
  end;

procedure TAcq.FormPaint(Sender: TObject);
var
  i:integer;
begin
  with paintBox1 do
  begin
    initGraphic(canvas,left,top,width,height);
    canvas.font.assign(font);
  end;

  with paintBox1 do setWindow(0,0,width-1,height-1);
  visu.displayTrace(data,0);
  doneGraphic;
end;

procedure TAcq.FormCreate(Sender: TObject);
begin
  visu.init;
  with visu do
  begin
    Xmax:=10000;
    Ymin:=-2500;
    Ymax:=2500;
    modeT:=DM_line;
    color:=clBlue;
  end;
end;

procedure TAcq.FormActivate(Sender: TObject);
begin
  if data=nil then
    begin
      new(data,init(mainBuf,1,0,0,nbpt0-1));
    end;
end;

procedure TAcq.Histogram1Click(Sender: TObject);
begin
   if chooseCoo(visu,data) then invalidate;
end;

end.
