unit showPal1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  Dgraphic;

type
  TFshowPal = class(TForm)
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    palette:hpalette;

    procedure WMQueryNewPalette(var message:TWMQueryNewPalette);message WM_QueryNewPalette;
    procedure WMPALETTECHANGED (var message:TWMPALETTECHANGED );message WM_PALETTECHANGED ;
  end;

var
  FshowPal: TFshowPal;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
type
  TMaxLogPalette=
       record
         palVersion:word;
         palNumEntries:word;
         palPalEntry:array[0..255] of TpaletteEntry;
       end;


  FUNCTION GetDesktopPalette:  hPalette;
     VAR
      LogicalPalette     :  TMaxLogPalette;
      ScreenDeviceContext:  hDC;
      ReturnCode         :  INTEGER;
  BEGIN
    LogicalPalette.palVersion    := $300;
    LogicalPalette.palNumEntries := 256;

    ScreenDeviceContext := GetDC(0);
    TRY
      // Get all 256 entries
      ReturnCode :=  GetSystemPaletteEntries(ScreenDeviceContext,
                                             0, 255, LogicalPalette.palPalEntry)
    FINALLY
      ReleaseDC(0, ScreenDeviceContext)
    END;

    IF   ReturnCode >0
    THEN RESULT := CreatePalette(pLogPalette(@LogicalPalette)^)
    ELSE RESULT := 0
  END {GetDesktopPalette};


procedure TFshowPal.FormPaint(Sender: TObject);
 VAR
    BrushNew  :  hBrush;
    BrushOld  :  hBrush;
    ColorIndex:  INTEGER;
    Column    :  INTEGER;
    GridHeight:  INTEGER;
    GridWidth :  INTEGER;
    Row       :  INTEGER;
begin
  GridHeight := {paintbox1.}clientHeight DIV 16;
  GridWidth  := {paintbox1.}clientWidth  DIV 16;

  SelectPalette(Canvas.Handle, Palette, FALSE);

  with canvas do
  FOR ColorIndex := 0 TO 255 DO
  BEGIN
    Row    := ColorIndex DIV 16;
    Column := ColorIndex MOD 16;
    Brush.color := $01000000 OR ColorIndex;
    Rectangle(      GridWidth*Column,     GridHeight*Row,
                    GridWidth*(Column+1), GridHeight*(Row+1));
  END;
end;

procedure TFshowPal.WMQueryNewPalette(var message:TWMQueryNewPalette);
var
  returnCode:integer;
begin

  {if palette<>0 then deleteObject(palette);
  palette:=GetDesktopPalette;
  }
  SelectPalette(Canvas.Handle, Palette, FALSE);
  returnCode:=RealizePalette(Canvas.Handle);

  IF   ReturnCode > 0 THEN Invalidate;

  Message.Result := ReturnCode;
end;

procedure TFshowPal.WMPALETTECHANGED (var message:TWMPALETTECHANGED );
   VAR
      DeviceContext:  hDC;
      oldPalette      :  hPalette;
  BEGIN

    IF  Message.PalChg = Handle
    THEN BEGIN
      Message.Result := 0
    END
    ELSE BEGIN
      DeviceContext := Canvas.Handle;
      oldPalette := SelectPalette(DeviceContext, Palette, TRUE);
      RealizePalette(DeviceContext);
      UpdateColors(DeviceContext);
      SelectPalette(DeviceContext, oldPalette, FALSE);

      Message.Result := 1;
    END

  END; {WMPaletteChanged}


procedure TFshowPal.FormResize(Sender: TObject);
begin
  invalidate;
end;

Initialization
AffDebug('Initialization Showpal1',0);
{$IFDEF FPC}
{$I showPal1.lrs}
{$ENDIF}
end.
