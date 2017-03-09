unit sysmask0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,
     util1,Dgraphic,stmDef,
     DXdrawsG;

type
  Tsysmask=class
             surface:TDirectDrawSurface;
             vide:boolean;
             changed:boolean;
             rectmax:Trect;
             constructor create;
             procedure clear;
             procedure Blt(rect:Trect);
             destructor destroy;override;
           end;

var
  sysmask:Tsysmask;


implementation

uses syspal32;

constructor Tsysmask.create;
begin
  (*
  surface:=DDscreen.createSingleSurface(SSwidth,SSheight);
  dd:=surface.surface.SetPalette ( DDscreen.PaletteOn ) ;
  if dd<>DD_OK then messageCentral('SysMask surface.setPalette failed: '+longToHexa(dd));

  surface.setColorKey(1,255); {1 est la couleur transparente }
  surface.clear(0);
  vide:=true;
  *)
end;

procedure Tsysmask.clear;
begin
(*
  with syspal.Vpal[0] do surface.clear(rgb(peRed,peGreen,peBlue));
    {couleur de fond partout. Le masque devient opaque}
  vide:=true;
*)
end;

procedure Tsysmask.Blt(rect:Trect);
begin
(*
  if (DDscreen=nil) or (DDscreen.ddraw=nil) then exit;

  if vide or isRectEmpty(rect) then exit;
  DDscreen.bltBackRect(surface,rect);
*)
end;

destructor Tsysmask.destroy;
begin
  (*surface.free;*)
end;

end.
