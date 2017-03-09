
unit DrawMeta;

{--- make a drawable metafile ---}

{     Grahame Marsh Jan 1996     }

interface

uses Graphics, Forms, WinProcs;

type

  TDrawMetaFile = class(TMetaFile)
  private
    FCanvas : TCanvas;
    FDrawing : boolean;
    procedure SetDrawing (State : boolean);

  protected
    property Drawing : boolean read FDrawing write SetDrawing;

  public
    constructor Create (aWidth, aHeight : integer);
    destructor Destroy; override;
    procedure Open;
    procedure Close;

  published
    property Canvas : TCanvas read FCanvas write FCanvas;
  end;


  implementation

{ create our drawing metafile, take the drawing width and height to those }
{ given in the parameters, set the inch property to that found in         }
{ screens.pixelsperinch and finally open for drawing                      }

constructor TDrawMetafile.Create (aWidth, aHeight : integer);
begin
  inherited Create;
  Inch := Screen.PixelsPerInch;
  Width := aWidth;
  Height := aHeight;
  Open;
end;

{ before destroying the metafile ensure that it is closed, this means     }
{ that any canvas is destroyed                                            }

destructor TDrawMetafile.Destroy;
begin
  Close;
  inherited Destroy;
end;

{ The key method: puts the metafile into draw and use modes depending  on }
{ the boolean parameter. When true the metafile goes into draw mode by    }
{ putting a CreateMetafile device context into a Canvas handle property   }
{ the canvas can now be drawn on. When false the metafile goes into use   }
{ mode by putting the handle returned from the CloseMetafile call into    }
{ the metafile's handle property. Note that the width, height and inch    }
{ properties are preserved over this assignment. Finally the canvas is    }
{ freed.                                                                  }

procedure TDrawMetafile.SetDrawing (State : boolean);
var
  KeepInch,
  KeepWidth,
  KeepHeight : integer;
begin
  if State <> FDrawing then
    begin
      FDrawing := State;
      if Drawing then
        begin
          FCanvas := TCanvas.Create;
          FCanvas.Handle := CreateMetafile(nil);
        end
      else
        begin
          KeepWidth := Width;
          KeepHeight := Height;
          KeepInch := Inch;
          Handle := CloseMetafile(FCanvas.Handle);
          Width := KeepWidth;
          Height := KeepHeight;
          Inch := KeepInch;
          FCanvas.Free;
        end;
    end;
end;

procedure TDrawMetafile.Open;
begin
  Drawing := true
end;

procedure TDrawMetafile.Close;
begin
  Drawing := false
end;


end.





