unit stmBMplot1;


interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,extctrls,extDlgs,
     util1,Gdos,Ddosfich,Dgraphic,varconf1,tpVector,
     stmDef,stmObj,stmPlot1,stmDobj1,dibG,getBmp0,debug0,
     NcDef2,stmPG,
     {$IFNDEF FPC} jpeg,pngImage, {$ENDIF}
     regions1,stmRegion1;

type
  TrecBMplot=record
               FTransparentValue:double;
               FTransparent:boolean;
               FCoupledBinXY:boolean;
             end;

  TbitmapPlot=
    class(TdataObj)
    private
      dib:Tdib;
      stFileName:AnsiString;



      FRegionList:TregionList;


      procedure initInf;

      function getRegionList:TregionList;

      procedure SaveAsBMP(st:AnsiString);overload;
      procedure SaveAsBMP(st:AnsiString;x1,y1,x2,y2:integer);overload;

      procedure SaveAsJpeg(st:AnsiString;quality:integer);overload;
      procedure SaveAsJpeg(st:AnsiString;quality:integer;x1,y1,x2,y2:integer);overload;

      procedure SaveAsPNG(st:AnsiString);overload;
      procedure SaveAsPNG(st:AnsiString;x1,y1,x2,y2:integer);overload;

      procedure regEditLoad;
      procedure regEditSave;

    protected
      recBMplot:TrecBMplot;
      DisplayAsMatrix: boolean; 

      procedure GdispToWorld(Gdisp1,xdisp1,ydisp1:float);override;
      function getCoupledBinXY:boolean;override;
      procedure setCoupledBinXY(w:boolean);override;

      procedure SetChildNames;override;

    public
      Cpxy:smallint;


      property RegionList:TregionList read getRegionList;

      constructor create;override;
      destructor destroy;override;

      class function STMClassName:AnsiString;override;

      function initialise(st:AnsiString):boolean;override;

      procedure createForm;override;
      procedure invalidateForm;override;

      procedure paintFormBMP(sender:Tobject);


      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      procedure CompleteLoadInfo;override;

      function getInsideWindow:Trect;override;
      procedure Display;override;

      procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                              const order:integer=-1);override;
      procedure getWorldPriorities(var Fworld, FlogX, FlogY: boolean;var x1,y1,x2,y2:float);override;


      function ChooseCoo1:boolean;override;
      procedure invalidate;override;
      procedure invalidateData;override;

      procedure processMessage(id:integer;source:typeUO;p:pointer);override;
      procedure proprietes(sender:Tobject);override;


      procedure loadImage(st:AnsiString);virtual;
      procedure saveImage(st:AnsiString;format,quality:integer);overload;virtual;
      procedure saveImage(st:AnsiString;format,quality,x1,y1,x2,y2:integer);overload;virtual;

      property Transparent: boolean read recBMplot.Ftransparent Write recBMplot.Ftransparent;
      property TransparentValue: double read recBMplot.FtransparentValue write recBMplot.FtransparentValue;

    end;


procedure proTbitmapPlot_create(stName,stFile:AnsiString;var pu:typeUO);pascal;
procedure proTbitmapPlot_create_1(stFile:AnsiString;var pu:typeUO);pascal;
function fonctionTbitmapPlot_fileName(var pu:typeUO):AnsiString;pascal;
procedure proTbitmapPlot_load(st:AnsiString;var pu:typeUO);pascal;
procedure proTbitmapPlot_save(st:AnsiString;format,quality:integer;var pu:typeUO);pascal;
procedure proTbitmapPlot_save_1(st:AnsiString;format,quality,x1,y1,x2,y2:integer;var pu:typeUO);pascal;

procedure proTbitmapPlot_Gdisp(w:float;var pu:typeUO);pascal;
function fonctionTbitmapPlot_Gdisp(var pu:typeUO):float;pascal;

procedure proTbitmapPlot_Xdisp(w:float;var pu:typeUO);pascal;
function fonctionTbitmapPlot_Xdisp(var pu:typeUO):float;pascal;

procedure proTbitmapPlot_Ydisp(w:float;var pu:typeUO);pascal;
function fonctionTbitmapPlot_Ydisp(var pu:typeUO):float;pascal;


function fonctionTbitmapPlot_Transparent(var pu:typeUO):boolean;pascal;
procedure proTbitmapPlot_Transparent(w:boolean;var pu:typeUO);pascal;

function fonctionTbitmapPlot_TransparentValue(var pu:typeUO):float;pascal;
procedure proTbitmapPlot_TransparentValue(w:float;var pu:typeUO);pascal;


implementation

uses RegEditor1;

constructor TbitmapPlot.create;
begin
  inherited;
  dib:=Tdib.create;
  Gdisp:=1;

  inverseY:=true;
  keepRatio:=true;
  echX:=false;
  echY:=false;
  FtickX:=false;
  FtickY:=false;
  CompletX:=false;
  completY:=false;
  TickExtX:=false;
  TickExtY:=false;


end;

destructor TbitmapPlot.destroy;
begin
  dib.free;
  inherited;
end;

class function TbitmapPlot.STMClassName:AnsiString;
begin
  result:='BitmapPlot';
end;

procedure TbitmapPlot.loadImage(st:AnsiString);
var
  image:Timage;
begin
  if fichierExiste(st) then
    begin
      try
      try
        image:=Timage.create(formStm);
        image.picture.loadFromFile(st);
        dib.initRgbDib(image.picture.Width,image.picture.Height);
        dib.canvas.Draw(0,0,image.Picture.Graphic);
      finally
        image.free;
        initInf;
      end;
      except
        st:='';
      end;
    end;

  stFileName:=st;
end;

procedure TbitmapPlot.saveImage(st: AnsiString; format, quality: integer);
begin
  case format of
    1:saveAsJpeg(st,quality);
    2:saveAsPNG(st);
    else saveAsBMP(st);
  end;
end;

procedure TbitmapPlot.saveImage(st: AnsiString; format, quality, x1, y1, x2, y2: integer);
begin
    case format of
    1:saveAsJpeg(st,quality, x1, y1, x2, y2);
    2:saveAsPNG(st, x1, y1, x2, y2);
    else saveAsBMP(st, x1, y1, x2, y2);
  end;
end;


procedure TbitmapPlot.SaveAsBMP(st:AnsiString);
begin
  try
    dib.SaveToFile(st);
  except
    sortieErreur('TbitmapPlot : unable to create '+st);
  end;
end;

procedure TbitmapPlot.SaveAsBMP(st: AnsiString; x1, y1, x2, y2: integer);
var
  dib1:Tdib;
begin
  dib1:=dib.extractDib(x1,y1,x2,y2);
  if not assigned(dib1) then exit;

  try
    dib1.SaveToFile(st);
  except
    sortieErreur('TbitmapPlot : unable to create '+st);
  end;
end;


procedure TbitmapPlot.SaveAsJpeg(st:AnsiString;quality:integer);
var
  jp:TjpegImage;
  bm0:Tbitmap;
begin
  try
  try
    bm0:=Tbitmap.create;
    begin
      bm0.height:=dib.Height;
      bm0.width:=dib.width;
      bm0.canvas.draw(0,0,dib);
    end;
    jp:=TjpegImage.create;
    jp.assign(bm0);
    jp.compressionQuality:=quality;
    jp.saveToFile(st);

  finally
    jp.free;
    bm0.Free;
  end;
  except
    sortieErreur('TbitmapPlot : unable to create '+st);
  end;
end;

procedure TbitmapPlot.SaveAsJpeg(st: AnsiString; quality, x1, y1, x2, y2: integer);
var
  dib1:Tdib;
  jp:TjpegImage;
  bm0:Tbitmap;
begin
  dib1:=dib.extractDib(x1,y1,x2,y2);
  if not assigned(dib1) then exit;

  TRY
  TRY
    bm0:=Tbitmap.create;
    begin
      bm0.height:=dib1.Height;
      bm0.width:=dib1.width;
      bm0.canvas.draw(0,0,dib1);
    end;
    jp:=TjpegImage.create;
    jp.assign(bm0);
    jp.compressionQuality:=quality;
    jp.saveToFile(st);

  FINALLY
  dib1.Free;
  bm0.free;
  jp.free;
  END;

  except
    sortieErreur('TbitmapPlot : unable to create '+st);
  end;
end;



procedure TbitmapPlot.SaveAsPNG(st:AnsiString);
{$IFDEF FPC}
type
  TpngObject = TPortableNetworkGraphic;
{$ENDIF}
var
  png:TpngObject;
begin
  try
  try
    PNG := TPNGObject.Create;
    PNG.Assign(dib);    //Convert data into png
    PNG.SaveToFile(st);
  finally
    PNG.free;
  end;
  except
    sortieErreur('TbitmapPlot : unable to create '+st);
  end;
end;

procedure TbitmapPlot.SaveAsPNG(st: AnsiString; x1, y1, x2, y2: integer);
{$IFDEF FPC}
type
  TpngObject = TPortableNetworkGraphic;
{$ENDIF}
var
  dib1:Tdib;
  png:TpngObject;
begin
  dib1:=dib.extractDib(x1,y1,x2,y2);
  if not assigned(dib1) then exit;

  try
  try
    PNG := TPNGObject.Create;
    PNG.Assign(dib1);    //Convert data into png
    PNG.SaveToFile(st);
  finally
    PNG.free;
  end;
  except
    sortieErreur('TbitmapPlot : unable to create '+st);
  end;
end;




function TbitmapPlot.initialise(st:AnsiString):boolean;
begin
  inherited initialise(st);


end;


procedure TbitmapPlot.display;
var
  dib1:Tdib;
  x1e,y1e,x2e,y2e:float;
  x1,y1,x2,y2:integer;
  rectS:Trect;

  i,j,ii:integer;
  p,p1:PtabOctet;

  bcount:integer;
begin
  with dib do
  if (width=0) or (height=0) or (bitCount=0) then exit;

  GdispToWorld(Gdisp,xdisp,ydisp);

  x1e:=Xmin;
  y1e:=Ymin;
  x2e:=Xmax;
  y2e:=Ymax;

  rectS:=rect(round(X1e),round(Y1e),round(X2e)-1,round(Y2e)-1);

  bCount:=dib.bitCount div 8;
  if bCount=0 then bCount:=1;

  TRY
  dib1:=Tdib.Create;
  with Dib1 do
  begin
      with rectS do setSize(right-left+1,bottom-top+1,dib.bitCount);
      fill(0);

      x1:=0;
      y1:=0;
      x2:=width-1;
      y2:=height-1;

      if rectS.Left+x1<0 then x1:=-rectS.Left;
      if rectS.Left+x2>=Icount then x2:=Icount-1-rectS.Left;

      if rectS.top+y1<0 then y1:=-rectS.top;
      if rectS.top+y2>=Jcount then y2:=Jcount-1-rectS.top;

      for j:=y1 to y2 do
      begin
        if inverseY
          then p:=scanline[j]
          else p:=scanline[height-1-j];

        if not inverseX then
        begin
          p1:=dib.scanline[rectS.top+j];
          p1:=@p1[(rectS.left+x1)*Bcount];
          move(p1^,p^[x1*Bcount],Bcount*(x2-x1+1));
        end
        else
        for i:=x1 to x2 do
        begin
          p1:=dib.scanline[rectS.top+j];
          p1:=@p1[(rectS.left+i)*Bcount];

          move(p1^, p^[(width-1-i)*Bcount],Bcount);
        end;
      end;
  end;

  canvasGlb.stretchDraw(rect(x1act,y1act,x2act+1,y2act+1),Dib1);

  FINALLY
  dib1.Free;
  END;
end;



procedure TbitmapPlot.displayInside(FirstUO: typeUO; extWorld,
  logX, logY: boolean; const order:integer=-1);
begin
  inherited;

end;

function TbitmapPlot.getInsideWindow: Trect;
var
  old:boolean;
begin
  with result do getWindowG(left,top,right,bottom);
  {
  old:=visu.keepRatio;
  visu.keepRatio:=false;
  result:=inherited getInsideWindow;
  visu.keepRatio:=old;
  }
end;

procedure TbitmapPlot.getWorldPriorities(var Fworld, FlogX, FlogY: boolean;
  var x1, y1, x2, y2: float);
begin
  GdispToWorld(Gdisp,xdisp,ydisp);
  x1:=Xmin;
  x2:=Xmax;
  y1:=Ymin;
  y2:=Ymax;
end;


procedure TbitmapPlot.createForm;
begin
  form:=TregEditor.create(formstm);
  with TregEditor(form) do
  begin
    install(self,self,self.RegionList);
    caption:=ident;
    loadBK:=regEditLoad;
    saveBK:=regEditSave;

  end;
end;

procedure TbitmapPlot.invalidateForm;
begin
  if assigned(form) then form.invalidate;
end;

procedure TbitmapPlot.paintFormBMP(sender:Tobject);
begin
  with Tpaint0(form).paintbox1 do
    initGraphic(canvas,left,top,width,height);
  display;
  doneGraphic;
end;


procedure TbitmapPlot.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);

  with conf do
  begin
    setStringConf('FileName',stFileName);
    setvarConf('rec',recBMplot,sizeof(recBMplot));
  end;
end;

procedure TbitmapPlot.CompleteLoadInfo;
begin
  inherited;
  loadImage(stFileName);
end;

procedure TbitmapPlot.proprietes(sender:Tobject);
var
  dialog:TopenPictureDialog;
begin
  dialog:=TopenPictureDialog.create(formStm);
  with Dialog do
  begin
    initialDir:=cheminDuFichier(stFileName);


    if execute then
    begin
      loadImage(fileName);
      stFileName:=fileName;
      invalidate;
    end;
    free;
  end;
end;


procedure TbitmapPlot.processMessage(id: integer; source: typeUO; p: pointer);
begin
  inherited;

  case id of
    uomsg_invalidate,uomsg_invalidatedata:
      if source=regionList then invalidateForm;
  end;
end;

procedure TbitmapPlot.GdispToWorld(Gdisp1, xdisp1, ydisp1: float);
begin
  if DisplayAsMatrix then exit;

  Gdisp:=Gdisp1;
  xDisp:=xDisp1;
  yDisp:=yDisp1;

  inherited;
end;


{****************************** Méthodes stm *********************************}



procedure proTbitmapPlot_create(stName,stFile:AnsiString;var pu:typeUO);
begin
  createPgObject(stname,pu,TbitmapPlot);
  if stFile<>'' then TbitmapPlot(pu).loadImage(stFile);
end;

procedure proTbitmapPlot_create_1(stFile:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TbitmapPlot);
  if stFile<>'' then TbitmapPlot(pu).loadImage(stFile);
end;


function fonctionTbitmapPlot_fileName(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TbitmapPlot(pu).stFileName;
end;


procedure proTbitmapPlot_load(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TbitmapPlot(pu).loadImage(st);
end;

procedure proTbitmapPlot_save(st:AnsiString;format,quality:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TbitmapPlot(pu).saveImage(st,format,quality);
end;

procedure proTbitmapPlot_save_1(st:AnsiString;format,quality,x1,y1,x2,y2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TbitmapPlot(pu).saveImage(st,format,quality,x1,y1,x2,y2);
end;




function TbitmapPlot.ChooseCoo1:boolean;
begin
  {result:=OIcood.choose(self);}
end;


function TbitmapPlot.getRegionList:TregionList;
begin
  if not assigned(FregionList) then
  begin
    FregionList:=TregionList.create;
    FregionList.ident:=ident+'.regions';
    addToChildList(FregionList);
  end;
  result:=FregionList;
end;

procedure TbitmapPlot.invalidate;
begin
  inherited;
  if assigned(FRegionList)
    then FRegionList.invalidate;

end;

procedure TbitmapPlot.invalidateData;
begin
  inherited;

  if assigned(FRegionList)
    then FRegionList.invalidate;
end;


procedure proTbitmapPlot_Gdisp(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TbitmapPlot(pu) do
  begin
    if (w<=0) or (w>1000) then sortieErreur('TbitmapPlot : Gdisp out of range');
    Gdisp:=w;
    invalidateForm;
  end;
end;

function fonctionTbitmapPlot_Gdisp(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TbitmapPlot(pu) do
  begin
    result:=Gdisp;
  end;
end;


procedure proTbitmapPlot_Xdisp(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TbitmapPlot(pu) do
  begin
    Xdisp:=w;
    invalidateForm;
  end;
end;

function fonctionTbitmapPlot_Xdisp(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TbitmapPlot(pu) do
  begin
    result:=Xdisp;
  end;
end;


procedure proTbitmapPlot_Ydisp(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TbitmapPlot(pu) do
  begin
    Ydisp:=w;
    invalidateForm;
  end;
end;

function fonctionTbitmapPlot_Ydisp(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TbitmapPlot(pu) do
  begin
    result:=Ydisp;
  end;
end;






procedure TbitmapPlot.initInf;
begin
  with inf do
  begin
    Defaults;
    imin:=0;
    imax:=dib.Width-1;
    jmin:=0;
    jmax:=dib.height-1;
  end;
end;


procedure TbitmapPlot.regEditLoad;
begin
  Proprietes(self);
end;

procedure TbitmapPlot.regEditSave;
begin

end;

function TbitmapPlot.getCoupledBinXY: boolean;
begin
  result:=recBMplot.FCoupledBinXY;
end;

procedure TbitmapPlot.setCoupledBinXY(w: boolean);
begin
  recBMplot.FCoupledBinXY:=w;
end;

procedure TbitmapPlot.SetChildNames;
begin
  inherited;
  if assigned(FregionList) then FregionList.ident:=ident+'.regions';
end;


{***************************************** Méthodes STM ******************************}

function fonctionTbitmapPlot_Transparent(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TbitmapPlot(pu).Transparent;
end;

procedure proTbitmapPlot_Transparent(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TbitmapPlot(pu) do transparent:=w;
end;

function fonctionTbitmapPlot_TransparentValue(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TbitmapPlot(pu).TransparentValue;
end;

procedure proTbitmapPlot_TransparentValue(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TbitmapPlot(pu) do transparentValue:=w;
end;



Initialization
AffDebug('Initialization stmBMplot1',0);

registerObject(TbitmapPlot,data);

end.
