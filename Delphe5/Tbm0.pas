unit tbm0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, classes, graphics, printers,sysutils,
     util1,Dgraphic;

{Dans l'objet Tbitmap de borland, l'impression ne fonctionne pas sur toutes les
imprimantes. Il y a problème lorsque l'imprimante ne supporte pas le mode
RC_stretchDib, la routine Bitmap.draw essaie alors d'utiliser StretchDIBits mais
la structure bitmapInfo ne doit pas être bien initialisée.

La procedure DisplayBitmap ci-dessous charge un fichier BMP de nom st et
l'affiche dans un canvas dans le rectangle (x1,y1,x2,y2).

Au lieu d'appeler Bitmap.draw ou Bitmap.stretchdraw pour imprimer, on peut
donc sauver le bitmap puis appeler DisplayBitmap:

bm.savetoFile('bmp.bmp');
DisplayBitmap('bmp.bmp',canvas,x1,y1,x2,y2);
effacerFichier('bmp.bmp');

}

procedure DisplayBitmap(st:AnsiString;canvas:Tcanvas;x1,y1,x2,y2:integer);

implementation

{afficheInfo n'est pas utilisé}
procedure afficheInfo(var info:windows.TbitmapInfoHeader);
begin
  with info do
  messageCentral(
    'biSize='+Istr(biSize)+#9+
    'biWidth='+Istr(biWidth)+#9+
    'biHeight='+Istr(biHeight)+#9+
    'biPlanes='+Istr(biPlanes)+#9+
    'biBitCount='+Istr(biBitCount)+#9+
    'biCompression='+Istr(biCompression)+#9+
    'biSizeImage='+Istr(biSizeImage)+#9+
    'biXPelsPerMeter='+Istr(biXPelsPerMeter)+#9+
    'biYPelsPerMeter='+Istr(biYPelsPerMeter)+#9+
    'biClrUsed='+Istr(biClrUsed)+#9+
    'biClrImportant='+Istr(biClrImportant)
    );
end;

procedure DisplayBitmap(st:AnsiString;canvas:Tcanvas;x1,y1,x2,y2:integer);
var
  header:windows.TbitmapFileHeader;
  info:windows.PbitmapInfo;
  f:TfileStream;
  res:intg;
  data:pointer;
  totSize,nbcol:integer;
begin

  f:=nil;
  TRY
  f:=TfileStream.create(st,fmOpenRead);

  totSize:=f.Size;
  f.read(header,sizeof(header));
  if (header.bftype<>$4D42) then
  begin
    f.free;
    exit;
  end;

  getmem(info,totSize-sizeof(header));
  f.read(info^,totSize-sizeof(header));
  f.free;
  f:=nil;

  with info^.bmiHeader do
  begin
    if biSize=sizeof(TbitmapCoreHeader) then
      begin
        if biBitCount<>24 then nbCol:=1 shl biBitCount else nbcol:=0;
      end
    else
      begin
        if biSize>=36 then nbcol:=biClrUsed else nbcol:=0;
        if nbcol=0 then
          begin
            if biBitCount<>24 then nbCol:=1 shl biBitCount else nbcol:=0;
          end;
      end;
  end;

  data:=pointer(info);
  inc(intG(data),info^.bmiHeader.biSize+nbcol*sizeof(TrgbQuad));


  setStretchBltMode(Canvas.Handle,ColorOnColor);
  StretchDIBits(Canvas.Handle,
          x1,y1,x2-x1,y2-y1,
          0, 0, info^.bmiHeader.biwidth,info^.bmiHeader.biHeight,
          data, info^,
          DIB_RGB_COLORS, srcCopy);

  freemem(info);

  Except
  f.free;
  freemem(info);
  end;
  
end;



end.
