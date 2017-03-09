unit BitmapEx;

INTERFACE
uses
  wintypes, winprocs,Messages, SysUtils, Classes, Graphics;

type
  TBitmapEx=class(Tbitmap)
            public
              bitmapInfoHeader:TbitmapInfoHeader;
              constructor create(width0,height0:integer);
              procedure setLine(var tb;ligne:integer);
              procedure getLine(var tb;ligne:integer);
              procedure clear;
            end;

implementation

function WidthBytes(I: Longint): Longint;
begin
  Result := ((I + 31) div 32) * 4;
end;

procedure InitializeBitmapInfoHeader(Bitmap: HBITMAP; var BI: TBitmapInfoHeader;
  Colors: Integer);
  {Identique à la procédure de Borland.graphics mais biBitCount ne prend pas la
   valeur 24 quand elle vaut 16 ou 32 }
var
  BM: Wintypes.TBitmap;
  k:integer;
begin
  GetObject(Bitmap, SizeOf(BM), @BM);
  with BI do
  begin
    biSize := SizeOf(BI);
    biWidth := BM.bmWidth;
    biHeight := -BM.bmHeight;
    if Colors <> 0 then
      case Colors of
        2: biBitCount := 1;
        16: biBitCount := 4;
        256: biBitCount := 8;
      end
    else biBitCount := BM.bmBitsPixel * BM.bmPlanes;
    biPlanes := 1;
    biXPelsPerMeter := 0;
    biYPelsPerMeter := 0;
    biClrUsed := 0;
    biClrImportant := 0;
    biCompression := BI_RGB;
    k:=biBitCount;
    if k in [16, 32] then k := 24;
    biSizeImage := -WidthBytes(biWidth * k) * biHeight;
  end;
end;

constructor TBitmapEx.create(width0,height0:integer);
var
  tagBM:wintypes.TBitmap;
  dd:integer;
begin
  inherited create;

  width:=width0;
  height:=height0;

  InitializeBitmapInfoHeader(handle,BitmapInfoHeader,0);
end;


procedure TBitmapEx.setLine(var tb;ligne:integer);
var
  rr:integer;
  Focus: HWND;
  DC: HDC;
begin
  if bitmapInfoHeader.biBitCount<>24 then exit;
  Focus := GetFocus;
  DC := GetDC(Focus);

  try
  rr:=SetDIBits( dc,	        { handle of device context }
                 handle,        { handle of bitmap         }
                 ligne,         { starting scan line       }
                 1,             { number of scan lines     }
                 @tb,	        { array of bitmap bits     }
                 TbitmapInfo(pointer(@bitmapInfoHeader)^),
                                { address of structure with bitmap data}
                 DIB_RGB_COLORS	{ type of color indices to use}
       );

  finally
  ReleaseDC(Focus, DC);
  end;
end;


procedure TBitmapEx.getLine(var tb;ligne:integer);
var
  rr:integer;
  Focus: HWND;
  DC: HDC;
begin
  if bitmapInfoHeader.biBitCount<>24 then exit;

  Focus := GetFocus;
  DC := GetDC(Focus);

  try
  rr:=getDIBits( dc,	        { handle of device context }
                 handle,        { handle of bitmap         }
                 ligne,         { starting scan line       }
                 1,             { number of scan lines     }
                 @tb,	        { array of bitmap bits     }
                 TbitmapInfo(pointer(@bitmapInfoHeader)^),
                                { address of structure with bitmap data}
                 DIB_RGB_COLORS	{ type of color indices to use}
       );

  finally
  ReleaseDC(Focus, DC);
  end;
end;

procedure TbitmapEx.clear;
begin
  with canvas do
  begin
    pen.color:=0;
    brush.color:=0;
    rectangle(0,0,width,height);
  end;
end;

end.
