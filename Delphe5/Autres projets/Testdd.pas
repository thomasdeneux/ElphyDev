unit TestDD;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus,StdCtrls, ExtCtrls, Buttons,

  util1,Dgraphic,DirectD0, DirectXGS,debug0,clock0,
  Gdos,DdosFich,formMenu,chrono0,Dpalette;


type
  TForm1 = class(TForm)
    TestButton: TButton;
    GroupBox1: TGroupBox;
    Width: TEdit;
    Label1: TLabel;
    Height: TEdit;
    Label2: TLabel;
    Depth: TEdit;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Count: TEdit;
    Size: TEdit;
    Button2: TButton;
    Label6: TLabel;
    Panel1: TPanel;
    PaintBox1: TPaintBox;
    Button1: TButton;
    ComboBox1: TComboBox;
    procedure TestButtonClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }

    procedure WMQueryNewPalette(var message:TWMQueryNewPalette);message WM_QueryNewPalette;
    procedure WMPALETTECHANGED (var message:TWMPALETTECHANGED );message WM_PALETTECHANGED ;

  public
    { Public declarations }
    procedure Test ( Sender: TObject; var Done: Boolean);
  end;

var
  Form1: TForm1;

const
 {DDscreen: TDDnormalWindow=nil;}
 DDscreen1: TDDscreen=nil;

 implementation



var
  ScreenWidth, ScreenHeight, ScreenDepth: Integer ;
  ObjectCount, ObjectSize: Integer ;
  Blocks: Array [ 0..4999 ] of record X, Y, Xv, Yv, Color, Size: Integer end ;
  Frames: Integer ;

  bm,bm1:TDDsurface;

  bmNorm:Tbitmap;

  timeNorm:float;
  nbNorm:integer;

{$R *.DFM}






procedure TForm1.TestButtonClick(Sender: TObject);
var
  Index: Integer ;
  Done: Boolean ;
  StartTime: TDateTime ;
  i:integer;
  logpal:TmaxLogPalette;
begin

  ScreenWidth := StrToInt ( Width.Text ) ;
  ScreenHeight := StrToInt ( Height.Text ) ;

  ScreenDepth := StrToInt ( Depth.Text ) ;
  ObjectCount := StrToInt ( Count.Text ) ;
  ObjectSize := StrToInt ( Size.Text ) ;
  if ObjectCount > 5000 then exit;
  if ObjectSize > 200 then exit;

  ScreenWidth := panel1.width;
  ScreenHeight := panel1.height;


  getLogPalStm(logpal);

  {DDScreen := TDDNormalWindow.Create (panel1.handle,@logpal) ;}
  DDscreen1:=TDDscreen.create(640,480,8,2);





  {bm:=DDscreen.createSingleSurface(30,30);}
  bm1:=DDscreen1.createSingleSurface(30,30);
  bmNorm:=Tbitmap.create;
  bmNorm.width:=100;
  bmNorm.height:=100;
  with bmNorm.canvas do
    begin
      for i:=15 downto 0 do
        begin
          pen.color:=    $01000000 OR (i);
          brush.color:=  $01000000 OR (i);
          ellipse(16-i,16-i,16+i,16+i);
        end;
    end;
 {
  with bm do
  begin

    clear(0);
    setColorKey(0,0);
    initCanvas;
    with canvas do
    begin
      selectDpaletteHandle(handle);
      for i:=15 downto 0 do
        begin
          pen.color:=    $01000000 OR (i);
          brush.color:=  $01000000 OR (i);
          ellipse(16-i,16-i,16+i,16+i);
        end;
    end;
    doneCanvas;
  end;
  }
  nbNorm:=0;
  timeNorm:=0;


  with bm1 do
  begin
    clear(0);
    setColorKey(0,0);
    initCanvas;
    with canvas do
    begin
      for i:=15 downto 0 do
        begin
          pen.color:=    rgb(0,i*16,0);
          brush.color:=  rgb(0,i*16,0);
          ellipse(16-i,16-i,16+i,16+i);
        end;
    end;
    doneCanvas;
  end;

  for Index := 0 to ObjectCount-1 do
  with Blocks [ Index ] do
  begin

    X := Random ( ScreenWidth - 100 ) + 50 ;
    Y := Random ( ScreenHeight - 100 ) + 50 ;
    Xv := Random ( 3 ) - 1 ;
    Yv := Random ( 3 ) - 1 ;

    Color := rgb(random(255),random(255),random(255));{10+random(235);}
    Size :=  ObjectSize  ;
  end ;


  {DDscreen.front.clear(0);}
  DDscreen1.front.clear(0);

  Frames := 0 ;
  StartTime := Now ;
  while True do
  begin
    Test ( self, Done ) ;
    if Now >= StartTime + ( 1 / 24 / 60 / 12 ) then Break ;
  end ;


  {bm1.free;}
  {bm.free;}
  bmNorm.free;

  {DDScreen.Free ;}
  {DDScreen := nil ;}

  DDscreen1.free;
  DDscreen1:=nil;

  ShowMessage ( Format ( 'Frames per second: %n', [ Frames / 10 ] ) ) ;
  messageCentral('Time='+Estr(timeNorm/nbNorm,3));
end;


procedure bltNormal(x,y:integer);
begin
{
  with DDscreen.back do
  begin
    initCanvas;
    initTimer2;
    canvas.draw(x,y,bmNorm);
    TimeNorm:=TimeNorm+getTimer2;
    inc(nbNorm);
    doneCanvas;
  end;
  }
end;

procedure bltDD(x,y:integer);
begin
  {
  initTimer2;
  DDscreen.blt(bm,x,y);
  TimeNorm:=TimeNorm+getTimer2;
  inc(nbNorm);
  }
end;


procedure TForm1.Test(Sender: TObject; var Done: Boolean);
var
  i:integer ;
  dd:integer;
begin
  Done := False ;
  Frames := Frames + 1 ;

  {DDscreen.back.clear(0);}
  DDscreen1.back.clear(0);

  for i:=0 to ObjectCount do
  with Blocks[i] do
  begin
    if (X+Xv+Size>ScreenWidth) or (X+Xv<0) then Xv := - Xv ;
    X := X + Xv ;
    if (Y+Yv+Size>ScreenHeight) or (Y+Yv<0) then Yv := - Yv ;
    Y := Y + Yv ;

    {BltDD(x,y);}
    {DDscreen.blt(bm,x,y);}
    DDscreen1.blt(bm1,x,y);
  end;

  {DDScreen.Flip(true) ;}
  DDScreen1.Flip(true) ;
end;



procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  i:integer;
  brushNew,brushOld:hbrush;
begin
  selectDpaletteHandle(paintbox1.canvas.handle);
  with paintbox1,canvas do
  begin
    for i:=0 to 19 do
      begin
        brush.color:=$01000000 OR (i);

        rectangle(width div 20*i,0,width div 20*(i+1),height);
      end;
  end;

end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  ;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  {DIcontrol.free;}
end;

procedure TForm1.WMQueryNewPalette(var message:TWMQueryNewPalette);
begin
  StmQueryNewPalette(self,paintbox1.canvas.handle,message);
end;

procedure TForm1.WMPALETTECHANGED (var message:TWMPALETTECHANGED );
begin
  StmPaletteChanged(self.handle,paintbox1.canvas.handle,message);
end;



end.

