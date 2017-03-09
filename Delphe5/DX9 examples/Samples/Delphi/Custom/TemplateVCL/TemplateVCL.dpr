(*----------------------------------------------------------------------------*
 *                                                                            *
 *  Template application - Direct3D9 in VCL                                   *
 *                                                                            *
 *  This template provides simple VCL Delphi application that renders D3D     *
 *  objects in VCL TPanel in windowed mode and can also run render D3D (in    *
 *  special window) then running in fullscreen mode.                          *
 *  Template even allows to move/rotate 'The Teapot' with mouse.              *
 *                                                                            *
 *  Template was written to provide compact starting point then creating      *
 *  Direct3D applications with Delphi (using VCL library)                     *
 *                                                                            *
 *  Copyright (c) 2005 by Alexey Barkovoy                                     *
 *  E-Mail: clootie@clootie.ru                                                *
 *                                                                            *
 *  Modified: 29-Aug-2005                                                     *
 *                                                                            *
 *  Latest version can be downloaded from:                                    *
 *     http://www.clootie.ru                                                *
 *----------------------------------------------------------------------------*)

program TemplateVCL;

{$R 'Manifest.res' 'Manifest.rc'}

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  RenderUnit in 'RenderUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
