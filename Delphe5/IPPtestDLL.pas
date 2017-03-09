unit IPPtestDLL;

interface
uses windows,classes,sysutils,graphics,
     util1;



var
  AddC_G: function ( src:pointer;  val:single; dst:pointer;len:integer):integer;cdecl;



function InitIPPtestDLL:boolean;



implementation



var
  hh: intG;


function InitIPPtestDLL:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary('IPPlib.dll');
  result:=(hh<>0);

  if not result then exit;

  AddC_G:= getProc(hh,'AddC');
end;


end.
