unit clock0;

{Version Delphi}

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,util1,debug0;



{ 2012

  On oublie le timer2 et windows 98 !!!
}



procedure initTimer2;
function getTimer2:float;


IMPLEMENTATION

var

  w0:integer;

procedure initTimer2;
begin
   W0:=getTickCount;
end;


function getTimer2:float;
begin
  result:=(getTickCount-w0)*1000;
end;


Initialization
AffDebug('Initialization clock0',0);



end.
