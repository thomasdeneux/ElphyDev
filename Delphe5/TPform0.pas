unit TPform0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,

  ExtCtrls, Menus,
  printers, clipBrd,
  {$IFNDEF FPC}
  jpeg,
  {$ENDIF}
  editCont,
  util1,Gdos,DdosFich,Dgraphic,stmDef,stmObj,stmPopup,BMex1, debug0,
  opVec1, stmcooX1,
  printMG0,tbm0;

type
  TPform = class(TForm)
    MainMenu1: TMainMenu;
    PaintBox0: TPaintBox;
    File1: TMenuItem;
    PrintSave1: TMenuItem;
    Copytoclipboard1: TMenuItem;
    Options1: TMenuItem;
    procedure PaintBox0Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox0MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox0MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Options1Click(Sender: TObject);
    procedure PrintSave1Click(Sender: TObject);
    procedure Copytoclipboard1Click(Sender: TObject);
    procedure PaintBox0EndDrag(Sender, Target: TObject; X, Y: Integer);
  private
    { Private declarations }
    BMfen:TbitmapEx;
    Fvalid:boolean;


    pop:TpopUpMenu;
    Fcap:boolean;

    procedure resizeBM;
    procedure BMpaint(forcer:boolean);
    procedure DrawBM;

    procedure DrawPage;
    procedure copyTo(stf:AnsiString);
    procedure PositionnePrinter(var Pleft,Ptop,Pwidth,Pheight:integer);
    procedure imprimer;
    procedure HardCopy;
    procedure saveToFile;

    procedure SaveWindowBMPClick(sender:Tobject);
    procedure SaveWindowJPEGClick(sender:Tobject);

  public
    { Public declarations }
    Uplot:typeUO;
    beginDragG:function:boolean of object;
    onBMpaint:procedure of object;
    BeforeBMpaint:procedure of object;

    HoldMode,HoldFirst:boolean;

    procedure invalidate;override;
    procedure invalidate2;
    procedure processMessage(id:integer;source:typeUO;p:pointer);
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

uses stmPlot1, stmDplot,CopyClip0;

procedure TPform.resizeBM;
begin
  if (BMfen.width<>paintbox0.width) or (BMfen.height<>paintbox0.height) then
  begin
    BMfen.width:=paintbox0.width;
    BMfen.height:=paintbox0.height;

    Fvalid:=false;
  end;
end;

procedure TPform.BMpaint(forcer:boolean);
begin
  if not assigned(Uplot) then exit;

  if not Fvalid then
  with BMfen do
  begin
    initGraphic(BMfen);

    if assigned(BeforeBMpaint) then BeforeBMpaint;

    if not HoldMode or HoldFirst then
      begin
        clearWindow(color);
        Uplot.Display;
        HoldFirst:=false;
      end
    else
      begin
        with Uplot.getInsideWindow do setWindow(left,top,right,bottom);
        Uplot.displayInside(nil,false,false,false);
      end;

    if assigned(OnBMpaint) then onBMpaint;
    doneGraphic;
  end;

end;

procedure TPform.DrawBM;
begin
  paintbox0.canvas.draw(0,0,BMfen);
end;


procedure TPform.PaintBox0Paint(Sender: TObject);
begin
  resizeBM;

  BMfen.restoreRects;
  BMpaint(false);

  if assigned(Uplot) then
  begin
    initGraphic(BMfen);
    with Uplot.getInsideWindow do setWindow(left,top,right,bottom);
    BMfen.clearRects;
    Uplot.displayCursors(BMfen);
    doneGraphic;
  end;

  DrawBM;

  Fvalid:=true;
end;

procedure TPform.FormCreate(Sender: TObject);
begin
  BMfen:=TbitmapEx.create;
end;

procedure TPform.PaintBox0MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  mi,mj:TmenuItem;

  x1,y1,x2,y2:integer;
  Irect:Trect;
  uo:typeUO;
  flag:boolean;
  p,pPb0:Tpoint;

begin
  if not assigned(Uplot) then exit;

  FastCoo.reset;

  p:=paintBox0.clientToScreen(point(x,y));
  Ppb0:=paintBox0.clientToScreen(point(0,0));

  case button of
    mbleft:
        begin
          with paintBox0 do initGraphic(canvas,left,top,width,height);
          Irect:=Uplot.getInsideWindow;
          getWindowG(x1,y1,x2,y2);

          Fcap:=false;
          if Uplot.MouseDownMG(0,Irect, Shift,Ppb0.x,Ppb0.y, x,y) then
            begin
              Fcap:=true;
              doneGraphic;
              exit;
            end;

          if assigned(beginDragG) and beginDragG then paintBox0.beginDrag(false);
          doneGraphic;
        end;
    mbRight:
      begin

        with paintBox0 do initGraphic(canvas,left,top,width,height);
        Irect:=Uplot.getInsideWindow;
        getWindowG(x1,y1,x2,y2);
        {La fenêtre courante est le cadre. Irect contient le rectangle intérieur}

        flag:=Uplot.MouseRightMG(self,0,Irect, Shift, Ppb0.x,Ppb0.y, x,y,uo);
        setWindow(x1,y1,x2,y2);
        doneGraphic;

        if flag then
          begin
            if uo<>nil then
              begin
                if assigned(pop) then pop.free;
                pop:=TpopUpMenu.create(nil);

                mi:=TmenuItem.create(pop);

                mi.caption:=uo.ident; {item avec nom de l'objet}

                CopyPopup(mi,uo.getPopup);
                pop.items.add(mi);



                {for i:=0 to mi.count-1 do
                  if mi.items[i].caption='Show' then mi.items[i].visible:=false;}

                pop.popup(x,y);
              end;

            exit;
          end;


        if assigned(pop) then pop.free;
        pop:=TpopUpMenu.create(nil);

        mi:=TmenuItem.create(pop);

        mi.caption:=UPlot.ident; {item avec nom de l'objet}

        CopyPopup(mi,Uplot.getPopup);
        {for i:=0 to mi.count-1 do
          if mi.items[i].caption='Show' then mi.items[i].visible:=false;}


        pop.items.add(mi);

        mi:=TmenuItem.create(pop);            { Window }
        mi.caption:='Window';

        mj:=TmenuItem.create(mi);             { Window. save as BMP}
        mj.caption:='Save as BMP';
        mj.onClick:=SaveWindowBMPClick;
        mi.add(mj);

        mj:=TmenuItem.create(mi);             { Window. save as Jpeg}
        mj.caption:='Save as JPEG';
        mj.onClick:=SaveWindowJPEGClick;
        mi.add(mj);

        pop.items.add(mi);



        pop.popup(p.x,p.y);


      end;
  end;


end;

procedure TPform.invalidate;
begin
  Fvalid:=false;
  invalidateRect(handle,nil,false);
  {le invalidate de Delphi doit appeler invalidateRect(handle,nil,true), ce qui
   efface d'abord la fenêtre avant de réafficher }
end;

procedure TPform.invalidate2;
begin
  invalidateRect(handle,nil,false);
end;


procedure TPform.FormDestroy(Sender: TObject);
begin
  BMfen.free;
  pop.free;
end;

procedure TPform.PaintBox0MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if not assigned(Uplot) then exit;

  if not (shift=[ssLeft]) then exit;
  if not Fcap then exit;

  with paintBox0 do initGraphic(canvas,left,top,width,height);
  if not Uplot.mouseMoveMG(x,y) then Fcap:=false else paintBox0.update;
  doneGraphic;

end;

procedure TPform.PaintBox0MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  hideStmHint;
  if not assigned(Uplot) then exit;

  if Fcap or Uplot.HasMgClickEvent then
  begin
    with paintBox0 do initGraphic(canvas,left,top,width,height);
    Uplot.mouseUpMG(x,y,nil);
    doneGraphic;
  end;
  Fcap:=false;

end;

procedure TPform.Options1Click(Sender: TObject);
var
  BKcolor:Tcolor;
begin
  BKcolor:=color;
  with optionsVec1 do
  begin
    Adcolor:=@BKColor;
  end;
  if optionsVec1.showModal=mrOK then
    begin
      updateAllVar(optionsVec1);
      color:=BKcolor;
      invalidate;
    end;

end;


procedure TPform.DrawPage;
begin
  if not assigned(Uplot) then exit;
  with Canvas do
  begin
    Uplot.Display;

    with Uplot.getInsideWindow do setWindow(left,top,right,bottom);
    Uplot.displayCursors(nil);

  end;
end;

procedure TPform.copyTo(stf:AnsiString);
{$IFDEF FPC}
begin
end;
{$ELSE}
var
  meta:TMetaFile;
  metaCanvas:TMetafileCanvas;
  w,h:integer;
begin
  Meta:= TMetafile.Create;
  try
    w:=printer.pageWidth;
    h:=roundL (w*BMfen.height/BMfen.width);
    meta.width:=w;
    meta.height:=h;
    metaCanvas:=TMetafileCanvas.Create(Meta, printer.handle);

    PRprinting:=true;
    PRfactor:=w/paintbox0.width;
    if PRautoSymb then PRsymbMag:=PRfactor;

    if (PRsymbMag<1) or (PRsymbMag>20) then PRsymbMag:=1;

    if PRautoFont then PRfontmag:=PRfactor;
    if (PRfontMag<0.2) or (PRfontMag>50) then PRfontMag:=1;

    {messageCentral(Istr(printer.pageWidth)+' '+Istr(printer.pageHeight)
                   +' '+Estr(PRfontMag,3)
                     );}

  except
    w:=BMfen.width;
    h:=BMfen.height;
    meta.width:=w;
    meta.height:=h;
    metaCanvas:=TMetafileCanvas.Create(Meta, paintbox0.canvas.handle);
    PRprinting:=false;

  end;

  try
    initGraphic(metaCanvas,0,0,w,h);
    canvasGlb.font:=self.font;
    drawPage;
  finally
    metaCanvas.Free;
    PRprinting:=false;
    doneGraphic;
  end;


  meta.enhanced:=true;

  if stf='' then clipboard.assign(meta) else meta.saveToFile(stF);
  meta.free;
end;
{$ENDIF}

procedure TPform.PositionnePrinter(var Pleft,Ptop,Pwidth,Pheight:integer);
var
  delta,dh:integer;
begin
  with printer,canvas do
  begin
    font.name:='Times New Roman';
    font.size:=10;
    font.style:=[fsBold];

    delta:=printer.PageWidth div 60;
    Ptop:=delta;
    Pleft:=delta;

    dh:=0;
    if PRprintName then dh:=1;
    if PrintComment<>'' then inc(dh);
    if PRprintName or (PrintComment<>'') then inc(dh);
    dh:=dh*textHeight('Un');

    Pwidth:=printer.PageWidth-delta*2;

    PRfactor:=Pwidth/paintbox0.width;

    if PRkeepAspectRatio or PRdraft then
      begin
        Pheight:=round(Pwidth*(paintbox0.height/paintbox0.width));
        if Pheight>printer.PageHeight-delta*2-dh then
          begin
            Pheight:=printer.PageHeight-delta*2-dh;
            Pwidth:=round(Pheight*(paintbox0.width/paintbox0.height));
          end;
      end
    else Pheight:=printer.PageHeight-delta*2-dh;

    if PRprintName then
      begin
        textOut(Pleft,Ptop,dateToStr(date)+'    '+getDataFileName);
        Ptop:=Ptop+textHeight('Un');
      end;
    font.style:=[];
    if PrintComment<>'' then
      begin
        textOut(Pleft,Ptop,PrintComment);
        Ptop:=Ptop+textHeight('Un');
      end;
    if PRprintName or (PrintComment<>'') then Ptop:=Ptop+textHeight('Un');
  end;
end;

procedure TPform.imprimer;
var
  colBK:Tcolor;
  Ptop,Pleft,Pwidth,Pheight:integer;
begin
  if PRWhiteBackGnd or PRmonochrome
    then colBK:=clwhite
    else colBK:=self.color;

  if PRLandscape
    then printer.orientation:=poLandscape
    else printer.orientation:=poPortrait;

  printer.beginDoc;
  positionnePrinter(Pleft,Ptop,Pwidth,Pheight);

  PRprinting:=true;

  with printer do initGraphic(canvas,0,0,printer.PageWidth,printer.PageHeight);
  with canvasGlb do
  begin
    pen.style:=psSolid;
    pen.mode:=pmCopy;
  end;

  if PRautoSymb then PRsymbMag:=PRfactor;
  if (PRsymbMag<1) or (PRsymbMag>20) then PRsymbMag:=1;

  if PRautoFont then PRFontMAg:=1;
  if (PRfontMag<0.2) or (PRfontMag>50) then PRfontMag:=1;

  canvasGlb.font.assign(font);

  {canvasGlb.font.size:=round(canvasGlb.font.size*PRfontMag);}

  canvasGlb.brush.color:=colBK;

  setWindow(Pleft,Ptop,Pleft+Pwidth,Ptop+Pheight);
  if colBK<>clWhite then clearWindow(self.color);
  drawPage;

  printer.endDoc;
  PRprinting:=false;
  doneGraphic;
end;


procedure TPform.HardCopy;
var
  i,j:integer;
  c:Tcolor;
  bm:TbitmapEx;
  stB:AnsiString;
  Ptop,Pleft,Pwidth,Pheight:integer;
begin
  screen.cursor:=crHourGlass;

  if PRmonochrome or PRwhiteBackGnd then
    begin
      bm:=TbitmapEx.create;
      bm.width:=bmFen.width;
      bm.height:=bmFen.height;

      with bmfen do
      begin
        if PRmonochrome then
          begin
            for i:=0 to width-1 do
              for j:=0 to height-1 do
                begin
                  c:=canvas.pixels[i,j];
                  if c=self.color then bm.canvas.pixels[i,j]:=clWhite
                                  else bm.canvas.pixels[i,j]:=clBlack;
                end;
          end
        else
          begin
            for i:=0 to width-1 do
              for j:=0 to height-1 do
                begin
                  c:=canvas.pixels[i,j];
                  if c=self.color then bm.canvas.pixels[i,j]:=clWhite
                               else bm.canvas.pixels[i,j]:=c;
                end;
          end
      end;
    end
  else bm:=bmfen;
  stB:=getTmpName('bmp');
  bm.saveToFile(stB);


  if PRLandscape
    then printer.orientation:=poLandscape
    else printer.orientation:=poPortrait;
  printer.beginDoc;
  positionnePrinter(Pleft,Ptop,Pwidth,Pheight);

  with printer do
    displayBitmap(stB,canvas,Pleft,Ptop,Pleft+Pwidth,Ptop+Pheight);

  printer.endDoc;

  if PRmonochrome or PRwhiteBackGnd then bm.free;
  effacerFichier(stB);
  screen.cursor:=crDefault;
end;

procedure TPform.saveToFile;
var
  ext:AnsiString;
begin
  if PRdraft then ext:='BMP' else ext:='EMF';

  if PRfileName='' then PRfileName:='*';
  PRfileName:=nouvelleExtension(PRfileName,ext);

//  messageCentral(PRfileName);

  if sauverFichierStandard(PRfileName,ext) then
    if PRdraft then BmFen.saveToFile(PRfileName)
    else copyto(PRfileName);
end;


procedure TPform.PrintSave1Click(Sender: TObject);
begin
  case printMgDialog.execution of
    mrOK: if PRdraft then hardcopy else imprimer;
    101:  SaveToFile;
  end;
end;



procedure TPform.Copytoclipboard1Click(Sender: TObject);
begin
  if CopyClip.execution then
    begin
      if PRdraft
        then clipBoard.assign(BMfen)
        else copyto('');
    end;
end;

procedure TPform.processMessage(id:integer;source:typeUO;p:pointer);
begin
  case id of
    UOmsg_invalidate,UOmsg_invalidateData,UOmsg_cursor:
      begin
        if Uplot=source then invalidate;
      end;
  end;
end;

procedure TPform.SaveWindowBMPClick(sender:Tobject);
const
  stF:AnsiString='';
var
  st:AnsiString;
begin
  st:= GsaveFile('Save Window as BMP',stF,'BMP');
  if st<>'' then
    begin
      bmFen.SaveToFile(st);
      stF:=st;
    end;
end;

procedure TPform.SaveWindowJPEGClick(sender:Tobject);
const
  stF:AnsiString='';
var
  st:AnsiString;
  jp:TjpegImage;
begin
  st:= GsaveFile('Save Window as JPEG',stF,'JPG');
  if st<>'' then
    begin
      try
        jp:=TjpegImage.create;
        jp.assign(bmfen);
        jp.compressionQuality:=100;
        jp.saveToFile(st);
      finally
        jp.free;
      end;

      stF:=st;
    end;
end;


procedure TPform.PaintBox0EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  resetDragUO;
end;

Initialization
AffDebug('Initialization TPform0',0);
{$IFDEF FPC}
{$I TPform0.lrs}
{$ENDIF}
end.
