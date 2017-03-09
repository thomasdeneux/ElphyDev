unit Unit1a; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs; 

type
  TForm1 = class(TForm)
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

Initialization
AffDebug('Initialization unit1a',0);
  {$I unit1a.lrs}

end.

