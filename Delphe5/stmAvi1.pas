unit STMAVI1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,sysutils,
     util1, Gdos, Dgraphic,BMex1,debug0,
     stmDef, stmObj, stmVec1,
     VFW, DIBG, multg1,
     Ncdef2, stmError,stmPg,
     myAvi0 ;

     { myAvi0  utilise vfw.pas
       vfw utilise Iunk.pas
     }

type

  TaviBuilder=
            class(typeUO)
              fileName:AnsiString;
              Frate:integer;
              Fcount:integer;
              Fcompress:boolean;
              bm:Tdib;
              open:boolean;

              mg0:Tmultigraph;
              rect0:Trect;

              Savi:TsimpleAvi;
              NumColorTable:integer;
              userColorTable:TRGBquads;
              FtrueColor:boolean;

              constructor create;override;
              destructor destroy;override;

              class function STMClassName:AnsiString;override;

              procedure createFile(st:AnsiString);
              procedure setWindow(num:integer);
              procedure setWindowEx(x1,y1,x2,y2:integer);

              procedure buildBM(first:boolean);
              procedure save;
              procedure closeFile;
            end;


procedure proTaviBuilder_createFile(st:AnsiString;var pu:typeUO);pascal;
procedure proTaviBuilder_setWindow(num:integer;var pu:typeUO);    pascal;
procedure proTaviBuilder_setWindowEx(x1,y1,x2,y2:integer;var pu:typeUO);pascal;

procedure proTaviBuilder_save(var pu:typeUO);                     pascal;
procedure proTaviBuilder_closeFile(var pu:typeUO);                pascal;

procedure proTaviBuilder_rate(n:integer;var pu:typeUO);           pascal;
function fonctionTaviBuilder_rate(var pu:typeUO):integer;         pascal;

procedure proTaviBuilder_Compress(b:boolean;var pu:typeUO);       pascal;
function fonctionTaviBuilder_Compress(var pu:typeUO):boolean;     pascal;

procedure proTaviBuilder_setColorTable(num:integer;var pu:typeUO);    pascal;
procedure proTaviBuilder_setUserColorTable(var tb;sz:integer;tp:word;var pu:typeUO);pascal;

procedure proTaviBuilder_TrueColor(x:boolean;var pu:typeUO);           pascal;
function fonctionTaviBuilder_TrueColor(var pu:typeUO):boolean;         pascal;


implementation

var
  E_aviFileOpen:integer;
  E_AVIFileCreateStream:integer;
  E_AVIStreamSetFormat:integer;
  E_AVIStreamWrite:integer;


class function TaviBuilder.STMClassName:AnsiString;
  begin
    STMClassName:='AviBuilder';
  end;

constructor TaviBuilder.create;
begin
  mg0:=DacMultigraph;
  rect0:=mg0.formG.paintbox1.ClientRect;
  bm:=Tdib.create;

  Frate:=20;
  Fcompress:=true;
end;

destructor TaviBuilder.destroy;
begin
  if open then closeFile;
  bm.free;
end;


procedure TaviBuilder.createFile(st:AnsiString);
begin
  fileName:=st;
  open:=true;
end;

procedure TaviBuilder.buildBM(first:boolean);
var
  tableSize:integer;
begin
  if FtrueColor
    then tableSize:=24
    else tableSize:=8;

  if first then
    begin
      bm.setSize(rect0.right-rect0.left,rect0.bottom-rect0.top,TableSize);
      case NumColorTable of
        -1:bm.ColorTable:=UserColorTable;
        0: bm.ColorTable:=stdColorTable;
        1: bm.ColorTable:=GreyScaleColorTable;
        2: bm.ColorTable:=GreyScaleMixColorTable;
        else bm.ColorTable:=stdColorTable;
      end;
      bm.UpdatePalette;
    end;                                  


  bm.canvas.copyRect(rect(0,0,bm.width,bm.height),mg0.formG.getBM.Canvas,rect0);
  {if first then bm.SaveToFile('d:\delphe5\dumdum.bmp');

  }
  if Fcompress then bm.Compress;
end;

procedure TaviBuilder.save;
var
  res:integer;
  st:String[4];
begin
  if not open then exit;
  buildBM(Fcount=0);                                           
  if Fcount=0 then
    begin
      savi:=TsimpleAvi.create(fileName,bm,Frate);
    end;

  savi.save(bm);
  inc(Fcount);
end;

procedure TaviBuilder.closeFile;
begin
  if not open then exit;
  savi.free;
  open:=false;
end;

procedure TaviBuilder.setWindow(num:integer);
begin
  rect0:=mg0.formG.getCadre(num);
end;

procedure TaviBuilder.setWindowEx(x1,y1,x2,y2:integer);
begin
  if x1<0 then x1:=0;
  if y1<0 then y1:=0;
  if x2>=mg0.formG.PaintBox1.Width
    then x2:=mg0.formG.PaintBox1.Width-1;
  if y2>=mg0.formG.PaintBox1.height
    then y2:=mg0.formG.PaintBox1.height-1;

  rect0:=rect(x1,y1,x2,y2);
end;


procedure proTaviBuilder_createFile(st:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TaviBuilder);
  with TaviBuilder(pu) do createFile(st);
end;

procedure proTaviBuilder_setWindow(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do setWindow(num-1);
end;

procedure proTaviBuilder_setWindowEx(x1,y1,x2,y2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do setWindowEx(x1,y1,x2,y2);
end;

procedure proTaviBuilder_save(var pu:typeUO);
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do save;
end;

procedure proTaviBuilder_closeFile(var pu:typeUO);
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do closeFile;

  proTobject_free(pu);
end;

procedure proTaviBuilder_rate(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do Frate:=n;
end;

function fonctionTaviBuilder_rate(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do result:=Frate;
end;

procedure proTaviBuilder_Compress(b:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do Fcompress:=b;
end;

function fonctionTaviBuilder_Compress(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do result:=Fcompress;
end;

procedure proTaviBuilder_setColorTable(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do NumColorTable:=num;
end;

procedure proTaviBuilder_setUserColorTable(var tb;sz:integer;tp:word;var pu:typeUO);
var
  Entries: TPaletteEntries absolute tb;
begin
  verifierObjet(pu);
  if typeNombre(tp)<>nblong
    then sortieErreur('TaviBuilder.setUserColorTable : invalid table type');
  if sz<>1024 then sortieErreur('TaviBuilder.setUserColorTable : invalid table size');

  with TaviBuilder(pu) do
  begin
    NumColorTable:=-1;
    UserColorTable:=PaletteEntriesToRGBQuads(Entries);
  end;
end;

procedure proTaviBuilder_TrueColor(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do FtrueColor:=x;
end;

function fonctionTaviBuilder_TrueColor(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do result:=FtrueColor;
end;



Initialization
AffDebug('Initialization Stmavi1',0);
  installError(E_aviFileOpen,'TaviBuilder: unable to open file');
  installError(E_AVIFileCreateStream, 'TaviBuilder: CreateStream error');
  installError(E_AVIStreamSetFormat, 'TaviBuilder: StreamSetFormat error');
  installError(E_AVIStreamWrite, 'TaviBuilder: AVIStreamWrite error');

  registerObject(TaviBuilder,sys);

end.
