// "Surface3D" produces several perspective plots of a surface described
// mathematically as z = f(x,y) = x * y * (x^2 - y^2) / (x^2 + y^2).
// Hidden lines are not removed.

// Copyright (C) 1982, 1987, 1995, 1998 Earl F. Glynn, Overland Park, KS
// All Rights Reserved.  E-Mail Address:  EarlGlynn@att.net

program Surface3D;

uses
  Forms,
  ScreenSurface3D in 'ScreenSurface3D.pas' {Surface},
  GraphicsMathLibrary in 'GraphicsMathLibrary.PAS',
  GraphicsPrimitivesLibrary in 'GraphicsPrimitivesLibrary.PAS';

{$R *.RES}

begin
  Application.CreateForm(TSurface, Surface);
  Application.Run;
end.
