unit stmBMP1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,graphics,extctrls,
     util1,Gdos,Dgraphic,varconf1,tpVector,
     stmDef,stmObj,stmPlot1,getBmp0,debug0,
     NcDef2,stmPG
     {$IFDEF FPC}
     ;
     {$ELSE}
     ,jpeg,pngImage;
     {$ENDIF}

type
  TimagePlot=
    class(TPlot)
      image:Timage;
      stFileName:AnsiString;
      FTile:boolean;
      Fstretch:boolean;
      FkeepRatio:boolean;

      constructor create;override;
      destructor destroy;override;

      class function STMClassName:AnsiString;override;

      function initialise(st:AnsiString):boolean;override;

      procedure display;override;

      procedure createForm;override;
      procedure invalidateForm;override;

      procedure paintFormBMP(sender:Tobject);


      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      procedure CompleteLoadInfo;override;

      procedure proprietes(sender:Tobject);override;
      procedure loadImage(st:AnsiString);
      procedure saveImage(st:AnsiString;format,quality:integer);

      procedure SaveAsBMP(st:AnsiString);
      procedure SaveAsJpeg(st:AnsiString;quality:integer);
      procedure SaveAsPNG(st:AnsiString);
    end;


procedure proTimage_create(stName,stFile:AnsiString;var pu:typeUO);pascal;
procedure proTimage_create_1(stFile:AnsiString;var pu:typeUO);pascal;
procedure proTimage_stretch(w:boolean;var pu:typeUO);pascal;
function fonctionTimage_stretch(var pu:typeUO):boolean;pascal;
procedure proTimage_Tile(w:boolean;var pu:typeUO);pascal;
function fonctionTimage_Tile(var pu:typeUO):boolean;pascal;
procedure proTimage_KeepAspectRatio(w:boolean;var pu:typeUO);pascal;
function fonctionTimage_KeepAspectRatio(var pu:typeUO):boolean;pascal;
function fonctionTimage_fileName(var pu:typeUO):AnsiString;pascal;
procedure proTimage_load(st:AnsiString;var pu:typeUO);pascal;
procedure proTimage_save(st:AnsiString;format,quality:integer;var pu:typeUO);pascal;



implementation

constructor TimagePlot.create;
begin
  inherited;
  image:=Timage.create(formstm);

  Fstretch:=true;
  FkeepRatio:=true;
end;

destructor TimagePlot.destroy;
begin
  image.free;
  inherited;
end;

class function TimagePlot.STMClassName:AnsiString;
begin
  result:='Image';
end;

procedure TimagePlot.loadImage(st:AnsiString);
begin
  if fichierExiste(st) then
    begin
      try
        image.picture.loadFromFile(st);
      except
        begin
          image.picture.graphic:=nil;
          st:='';
        end;
      end;
    end;

  stFileName:=st;
end;

procedure TimagePlot.saveImage(st: AnsiString; format, quality: integer);
begin
  case format of
    1:saveAsJpeg(st,quality);
    2:saveAsPNG(st);
    else saveAsBMP(st);
  end;
end;

procedure TimagePlot.SaveAsBMP(st:AnsiString);
var
  bmp:Tbitmap;
begin
  try
  try
    bmp := Tbitmap.Create;
    bmp.Assign(image);    //Convert data into png
    bmp.SaveToFile(st);
  finally
    bmp.free;
  end;
  except
    sortieErreur('Timage : unable to create '+st);
  end;
end;

procedure TimagePlot.SaveAsJpeg(st:AnsiString;quality:integer);
var
  jp:TjpegImage;
begin
  try
  try
    jp:=TjpegImage.create;
    jp.assign(image);
    jp.compressionQuality:=quality;
    jp.saveToFile(st);
  finally
    jp.free;
  end;
  except
    sortieErreur('Timage : unable to create '+st);
  end;
end;

procedure TimagePlot.SaveAsPNG(st:AnsiString);
{$IFDEF FPC}
type
  TpngObject= TportableNetworkGraphic;
{$ENDIF}
var
  hh:Thandle;
  png:TpngObject;
begin
  try
  try
    PNG := TPNGObject.Create;
    PNG.Assign(image);    //Convert data into png
    PNG.SaveToFile(st);
  finally
    PNG.free;
  end;
  except
    sortieErreur('Timage : unable to create '+st);
  end;
end;


function TimagePlot.initialise(st:AnsiString):boolean;
var
  stName:AnsiString;
begin
  inherited initialise(st);
  if iniTimagePlot.execution('New ImagePlot: '+st,stName,Ftile,Fstretch,FkeepRatio) then
    begin
      loadImage(stName);
      initialise:=true;
    end
  else initialise:=false;
end;


procedure TimagePlot.display;
var
  x1,y1,x2,y2:integer;
  i,j,nbx,nby:integer;
  dx,dy:integer;
  ratio:float;
begin
  getWindowG(x1,y1,x2,y2);

  if Ftile then
    begin
      dx:=image.width;
      dy:=image.height;
      nbx:=(x2-x1+1) div dx +1;
      nby:=(y2-y1+1) div dy +1;

      for i:=0 to nbx-1 do
        for j:=0 to nby-1 do
          canvasGlb.draw(x1+dx*i,y1+dy*j,image.picture.graphic);
    end
  else
  if Fstretch then
    begin
      if FkeepRatio then
        begin
          if image.picture.width=0 then exit;
          ratio:=image.picture.height/image.picture.width;
          dx:=x2-x1;
          dy:=y2-y1;
          if dx*ratio<dy
            then dy:=roundL(dx*ratio)
            else dx:=roundL(dy/ratio);
          canvasGlb.stretchDraw(rect(x1,y1,x1+dx,y1+dy),image.picture.graphic);
        end
      else canvasGlb.stretchDraw(rect(x1,y1,x2,y2),image.picture.graphic);
    end
  else canvasGlb.draw(x1,y1,image.picture.graphic);
end;

procedure TimagePlot.createForm;
begin
  form:=Tpaint0.create(FormStm);
  with Tpaint0(form) do
  begin
    onPaint:=paintFormBMP;
    beginDragG:=GbeginDrag;
    Dproperties:=proprietes;
    caption:=ident;
  end;
end;

procedure TimagePlot.invalidateForm;
begin
  if assigned(form) then form.invalidate;
end;

procedure TimagePlot.paintFormBMP(sender:Tobject);
begin
  with Tpaint0(form).paintbox1 do
    initGraphic(canvas,left,top,width,height);
  display;
  doneGraphic;
end;


procedure TimagePlot.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);

  with conf do
  begin
    setStringConf('FileName',stFileName);
    setvarConf('PAVE',Ftile,sizeof(Ftile));
    setvarConf('STRETCH',Fstretch,sizeof(Fstretch));
    setvarConf('KeepRatio',FkeepRatio,sizeof(FkeepRatio));
  end;
end;

procedure TimagePlot.CompleteLoadInfo;
begin
  inherited;
  loadImage(stFileName);
end;

procedure TimagePlot.proprietes(sender:Tobject);
var
  stName:AnsiString;
begin
  stName:=stFileName;
  if iniTimagePlot.execution(Ident+' properties',stName,Ftile,Fstretch,FkeepRatio) then
    begin
      loadImage(stName);
      invalidate;
    end;
end;

{****************************** Méthodes stm *********************************}



procedure proTimage_create(stName,stFile:AnsiString;var pu:typeUO);
begin
  createPgObject(stname,pu,TimagePlot);
  if stFile<>'' then TimagePlot(pu).loadImage(stFile);
end;

procedure proTimage_create_1(stFile:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TimagePlot);
  if stFile<>'' then TimagePlot(pu).loadImage(stFile);
end;


procedure proTimage_stretch(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TimagePlot(pu).Fstretch:=w;
end;

function fonctionTimage_stretch(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TimagePlot(pu).Fstretch;
end;

procedure proTimage_Tile(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TimagePlot(pu).Ftile:=w;
end;

function fonctionTimage_Tile(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TimagePlot(pu).Ftile;
end;

procedure proTimage_KeepAspectRatio(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TimagePlot(pu).FkeepRatio:=w;
end;

function fonctionTimage_KeepAspectRatio(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TimagePlot(pu).FkeepRatio;
end;

function fonctionTimage_fileName(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TimagePlot(pu).stFileName;
end;


procedure proTimage_load(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TimagePlot(pu).loadImage(st);
end;

procedure proTimage_save(st:AnsiString;format,quality:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TimagePlot(pu).saveImage(st,format,quality);
end;




Initialization
AffDebug('Initialization stmBmp1',0);

registerObject(TimagePlot,data);

end.
