unit Dureepro;                   ...

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, Menus,
  util1,Dgraphic,dtf0,Dtrace1,Dprocess, visu0, cood0;

type
  THisDuree = class(TForm)
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
    data:typeDataI;
    data2:typedataL;
    dataCadrer:typedataE;

    procedure cadrerX(sender:Tobject);
    procedure cadrerY(sender:Tobject);
    function chooseCoo(var vv:TvisuInfo;dd:typedataE):boolean;
  public
    { Déclarations public }
    visu,visu2:TvisuInfo;
    visu0:^TvisuInfo;

  end;

var
  HisDuree: THisDuree;

implementation

{$R *.DFM}

procedure THisDuree.cadrerX(sender:Tobject);
  begin
    visu0^.cadrerX(dataCadrer);
  end;

procedure THisDuree.cadrerY(sender:Tobject);
  begin
    visu0^.cadrerY(dataCadrer);
  end;


function ThisDuree.chooseCoo(var vv:TvisuInfo;dd:typedataE):boolean;
  var
    cooD:Tcood;
    chg:boolean;
    title:string;
  begin
    dataCadrer:=dd;
    cooD:=Tcood.create(self);
    new(visu0);

    visu0^:=vv;

    if cood.choose(title,visu0^,cadrerX,cadrerY) then
      begin
        chg:= not compareMem(@visu,visu0,sizeof(visu));
        vv:=visu0^;
      end
    else chg:=false;
    cood.free;
    dispose(visu0);
    chooseCoo:=chg;
  end;

procedure THisDuree.FormPaint(Sender: TObject);
var
  max,i,tot:integer;
  h,l:integer;
  n,n1,n2,n3:integer;
begin

  max:=0;
  tot:=0;
  n1:=0;
  n2:=0;
  n3:=0;
  for i:=0 to 59 do
    begin
      n:=HisProcess^[i];
      tot:=tot+n;
      if n>max then max:=n;
      if i<25 then inc(n1,n)
      else
      if i<42 then inc(n2,n)
      else inc(n3,n);
    end;
  if max=0 then max:=1;

  with paintBox1 do
  begin
    initGraphic(canvas,left,top,width,height);
    canvas.font.assign(font);
  end;

  with paintBox1 do setWindow(0,0,width-1,height div 2-1);
  visu.displayTrace(data,nil,0);

  with paintBox1 do setWindow(0,height div 2,width-1,height-1);
  visu2.displayTrace(data2,nil,0);

  mainWindow;
  with paintBox1 do
  begin
    canvas.font.assign(font);
    h:=canvas.textHeight('1');
    l:=canvas.textWidth('0');
    {
    canvas.textOut(width-l*10,5,'max='+Istr(max));
    canvas.textOut(width-l*10,5+h,'tot='+Istr(tot));

    canvas.textOut(width-l*10,5+2*h,'n1='+Istr(n1));
    canvas.textOut(width-l*10,5+3*h,'n2='+Istr(n2));
    canvas.textOut(width-l*10,5+4*h,'n3='+Istr(n3));
    }
  end;
  doneGraphic;

end;

procedure THisDuree.FormCreate(Sender: TObject);
begin
  visu.init;
  with visu do
  begin
    Xmin:=-200;
    Xmax:=200;
    Ymax:=5;
    modeT:=DM_histo0;
    color:=clRed;
  end;

  visu2.init;
  with visu2 do
  begin
    Xmax:=300;
    Ymax:=150;
    modeT:=DM_histo0;
    color:=clGreen;
  end;

end;

procedure THisDuree.FormActivate(Sender: TObject);
begin
  if data=nil then
    begin
      data:=typeDataI.create(@HisProcess^[0],1,0,-300,300);
      data.setConversionX(1,0);
    end;
  if data2=nil then data2:=typeDataL.create(valPr,1,0,0,3000);
end;

procedure THisDuree.Histogram1Click(Sender: TObject);
begin
  case TmenuItem(sender).tag of
    1: if chooseCoo(visu,data) then invalidate;
    2: if chooseCoo(visu2,data2) then invalidate;
  end;
end;

end.
