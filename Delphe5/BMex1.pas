unit BMex1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows, SysUtils, Classes, Graphics,forms, math,

     util1,Gdos,DibG,
     GL,GLU, Glut;


{ TbitmapEx est un DIB
  TbitmapEx maintient une liste de bitmaps (des TbitmapEx) qui permettent
  de sauver/restaurer des petits rectangles de sa surface.
  Il permet une sorte d'animation de sprites sur un fond complexe.

  saveRect(rr:Trect) sauve un rectangle
  restoreRects restaure tous les rectangles
  clearRects efface la liste de rectangles.

  Ces méthodes sont utilisées pour animer des curseurs sur Multigraph.

  On ajoute initGLpaint et doneGLpaint qui permettent d'utiliser openGL sur le bitmap.

}

type
  TbitmapEx=class(Tdib)
            public
              r0:Trect;
              rects:Tlist;
              FRC:hglrc;
              FpuMask: TFPUExceptionMask;

              constructor create;
              destructor destroy;override;

              procedure saveRect(rr:Trect);
              procedure restoreRects;
              procedure clearRects;

              function initGLpaint: boolean;
              procedure doneGLpaint;
            end;

implementation



{ TbitmapEx }


constructor TbitmapEx.create;
begin
  inherited;
  initRgbDib(10,10); 
  rects:=Tlist.Create;
end;

destructor TbitmapEx.destroy;
begin
  clearRects;
  rects.free;
  inherited;
end;

procedure TbitmapEx.clearRects;
var
  i:integer;
begin
  for i:=0 to rects.Count-1 do
    TbitmapEx(rects[i]).free;
  rects.clear;
end;


procedure TbitmapEx.restoreRects;
var
  i:integer;
  rr:Trect;
  res:integer;
  oldReg:HRGN;
begin
  for i:=0 to rects.count-1 do
  begin
    rr:=TbitmapEx(rects[i]).r0;

    {Draw ne marche pas si le clipping est ON . On conserve la région clippée }
    res:=getClipRgn(self.canvas.handle,oldReg);
    selectClipRgn(self.canvas.handle,0);
    self.canvas.Draw(rr.left,rr.top,TbitmapEx(self.rects[i]));
    if res>0 then selectClipRgn(self.canvas.handle,oldReg);

  end;


end;

procedure TbitmapEx.saveRect(rr: Trect);
var
  bm:TbitmapEx;
  i:integer;
  rA,rB,rI,rNew:Trect;
begin
  bm:=TbitmapEx.create;
  bm.Width:=rr.Right-rr.Left +1;
  bm.Height:=rr.Bottom-rr.Top +1;
  bm.r0:=rr;

{  bm.canvas.copyRect(rect(0,0,bm.Width,bm.Height),canvas,rr); }
  bm.copyDibRect(rect(0,0,bm.Width-1,bm.Height-1),self,rr);

  for i:=0 to rects.count-1 do
    if IntersectRect(ri, rr, TbitmapEx(rects[i]).r0) then
    begin
      rNew:=TbitmapEx(rects[i]).r0;
      rA.left:=rI.Left-rNew.Left;
      rA.right:=rI.right-rNew.Left;
      rA.top:=rI.top-rNew.top;
      rA.bottom:=rI.bottom-rNew.top;

      rB.left:=rI.Left-rr.Left;
      rB.right:=rI.right-rr.Left;
      rB.top:=rI.top-rr.top;
      rB.bottom:=rI.bottom-rr.top;

      bm.copyDibRect(rB,TbitmapEx(rects[i]),rA);
{      bm.canvas.copyRect(rB,TbitmapEx(rects[i]).canvas,rA); }
    end;

  rects.Add(bm);


end;


function TbitmapEx.initGLpaint:boolean;
var
  nPixelFormat: Integer;
  pfd: TPixelFormatDescriptor;

  FDC:hdc;

begin
  result:= {initOpenGL;} initGL and initGlu {$IFNDEF WIN64} and initGlut{$ENDIF} ;
  
  if not result then exit;

  gdiFlush;

  FDC :=Canvas.Handle;
  if FDC=0 then exit;

  FillChar(pfd, SizeOf(pfd), 0);
  with pfd do
  begin
    nSize        := SizeOf(TPixelFormatDescriptor);           // Size of this structure
    nVersion     := 1;                                        // Version number
    dwFlags      := PFD_DRAW_TO_Bitmap or
                    PFD_SUPPORT_OPENGL;                       // Flags
    iPixelType := PFD_TYPE_RGBA;                              // RGBA pixel values
    cColorBits   := bitCount;                                 // 24-bit color
    cDepthBits   := bitCount;      {garder 24 ?}              // 24-bit depth buffer
    cStencilBits := 8;                                        // Stencil buffer, too.
    iLayerType   := PFD_MAIN_PLANE;                           // Layer type
  end;

  nPixelFormat := ChoosePixelFormat(FDC, @pfd);
  SetPixelFormat(FDC, nPixelFormat, @pfd);

  FRC := wglCreateContext(FDC);
  if FRC=0 then exit;

  wglMakeCurrent(FDC, FRC);

  FPUmask:=GetExceptionMask;
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide,exOverflow, exUnderflow, exPrecision]);

end;

procedure TbitmapEx.doneGLpaint;
begin
  if not {initOpenGL} (initGL and initGlu) then exit;

  glFinish;
  wglMakeCurrent(0, 0);
  wglDeleteContext(FRC);
  SetExceptionMask(FPUmask);
end;


end.
