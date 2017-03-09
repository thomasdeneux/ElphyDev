// "Surface3D" produces several perspective plots of a surface described
// mathematically as z = f(x,y) = x * y * (x^2 - y^2) / (x^2 + y^2).
// Hidden lines are not removed.

// Copyright (C) 1982, 1987, 1995, 1998 Earl F. Glynn, Overland Park, KS
// All Rights Reserved.  E-Mail Address:  EarlGlynn@att.net

unit ScreenSurface3D;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TSurface = class(TForm)
    ButtonDraw: TButton;
    ClearClear: TButton;
    Image: TImage;
    ButtonPrint: TButton;
    ButtonWriteBMP: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ClearClearClick(Sender: TObject);
    procedure ButtonDrawClick(Sender: TObject);
    procedure ButtonPrintClick(Sender: TObject);
    procedure ButtonWriteBMPClick(Sender: TObject);
  private
    PROCEDURE DrawSurface (Canvas:  TCanvas; RepaintNeeded:  BOOLEAN);
  public
  end;

var
  Surface: TSurface;

implementation
{$R *.DFM}

  USES
    Printers,
    GraphicsMathLibrary,
    GraphicsPrimitivesLibrary;


//***  TSurface.FormCreate  *****************************************

procedure TSurface.FormCreate(Sender: TObject);
  VAR
    BitMap:  TBitMap;
begin
  BitMap := TBitMap.Create;
  TRY
    BitMap.Width := Image.Width;
    BitMap.Height := Image.Height;
    Image.Picture.Graphic := BitMap;
  FINALLY
    Bitmap.Free
  END
end;


//***  TSurface.ClearButtonClick  ***********************************

procedure TSurface.ClearClearClick(Sender: TObject);
begin
  Image.Picture := NIL
end;


//***  DrawSurface  *************************************************

PROCEDURE TSurface.DrawSurface (Canvas:  TCanvas; RepaintNeeded:  BOOLEAN);
  CONST
    N      = 40;          {lines 0..N}
    xfirst = -2.0;
    xlast  =  2.0;
    yfirst = -2.0;
    ylast  =  2.0;

  VAR
    area     :  TPantoGraph;
    azimuth  :  DOUBLE;
    a        :  TMatrix;
    denom    :  DOUBLE;
    distance :  DOUBLE;
    elevation:  DOUBLE;
    loop     :  INTEGER;
    x,y      :  DOUBLE;
    xinc,yinc:  DOUBLE;
    xsq,ysq  :  DOUBLE;
    z        :  ARRAY[0..N,0..N] OF DOUBLE;


  PROCEDURE CreateSurfacePoints;
    VAR
      i,j      :  0..N;
  BEGIN
    xinc := (xlast-xfirst)/N;
    yinc := (ylast-yfirst)/N;

    FOR j := N DOWNTO 0 DO
    BEGIN
      y := yfirst + yinc*j;
      ysq := SQR(y);
      FOR i := 0 TO N DO
      BEGIN
        x := xfirst + xinc*i;
        xsq := SQR(x);
        denom := xsq+ysq;
        IF   defuzz(denom) = 0.0
        THEN z[i,j] := 0.0
        ELSE z[i,j] := x * y * (xsq-ysq) / denom;
      END;
      Application.ProcessMessages
    END
  END {CreateSurfacePoints};


  PROCEDURE DrawSurfaceLines;
   VAR
     i,j:  0..N;
     u  :  TVector;
  BEGIN
    FOR i := 0 TO N DO BEGIN
      x := xfirst + xinc*i;
      FOR j := 0 TO N DO BEGIN
        y := yfirst + yinc*j;
        u := Vector3D (x,y,z[i,j]);
        IF   j = 0
        THEN area.MoveTo (u)
        ELSE area.LineTo (u)
      END;
      IF   RepaintNeeded
      THEN Image.Repaint
    END;

    FOR j := 0 TO N DO
    BEGIN
      y := yfirst + yinc*j;
      FOR i := 0 TO N DO
      BEGIN
        x := xfirst + xinc*i;
        u := Vector3D(x,y,z[i,j]);
        IF   i = 0
        THEN area.MoveTo (u)
        ELSE area.LineTo (u)
      END;
       IF   RepaintNeeded
       THEN Image.Repaint
    END;
  END {DrawSurfaceLines};

BEGIN
  CreateSurfacePoints;
  area := TPantoGraph.Create(Canvas);

  area.WorldCoordinatesRange(0.0,1.0, 0.0,1.0);

  FOR loop := 0 TO 3 DO
  BEGIN
    CASE loop OF
      0:  BEGIN
            Canvas.Pen.Color := clRed;
            area.ViewPort (0.50,1.00, 0.50,1.00);   // upper right corner
            azimuth := ToRadians(45.0);
            elevation := ToRadians(30.0);
            distance := 15.0
          END;

      1:  BEGIN
            Canvas.Pen.Color := clGreen;
            area.ViewPort (0.00,0.50, 0.50,1.00);  // upper left corner
            azimuth := TORadians(45.0);
            elevation := ToRadians(30.0);
            distance := 5.0
          END;

      2:  BEGIN
            Canvas.Pen.Color := clBlue;
            area.ViewPort (0.00,0.50, 0.00,0.50);  // lower left corner
            azimuth := ToRadians(45.0);
            elevation := ToRadians(0.0);
            distance := 15.0
          END;

      3:  BEGIN
            Canvas.Pen.Color := clPurple;
            area.ViewPort (0.50,1.00, 0.00,0.50);  // lower right corner
            azimuth := ToRadians(45.0);
            elevation := ToRadians(90.0);
            distance := 15.0
          END;

      ELSE
        azimuth   := 0.0;
        elevation := 0.0;
        distance  := 0.0
    END;
    a := ViewTransformMatrix (coordSpherical, azimuth,elevation,distance,
                              4.0,4.0,10.0);
    area.SetTransform(a);

    DrawSurfaceLines

  END;

  area.Free
END;


//***  TSurface.DrawButtonClick  ************************************

procedure TSurface.ButtonDrawClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  TRY
    DrawSurface (Surface.Image.Canvas, TRUE)
  FINALLY
    Screen.Cursor := crDefault
  END
end;


//***  TSurface.PrintButtonClock  ***********************************

procedure TSurface.ButtonPrintClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  TRY
    Printer.Orientation := poLandscape;
    Printer.BeginDoc;
      DrawSurface (Printer.Canvas, FALSE);
    Printer.EndDoc;
    ShowMessage('Surface printed.');
  FINALLY
    Screen.Cursor := crDefault
  END
end;


//*******************************************************************

procedure TSurface.ButtonWriteBMPClick(Sender: TObject);
  VAR
    Bitmap:  TBitmap;
begin
  Screen.Cursor := crHourGlass;
  TRY
    Bitmap := TBitmap.Create;
    Bitmap.Width  := 1024;
    Bitmap.Height := 1024;
    Bitmap.PixelFormat := pf8bit;
    DrawSurface (Bitmap.Canvas, FALSE);
    Bitmap.SaveToFile('Surface.BMP');
    ShowMessage('Surface.BMP written to disk (1024-by-1024 pixels)')
  FINALLY
    Screen.Cursor := crDefault
  END
end;

end.
