unit Matlab0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,util1,matlab_matrix, debug0;


type
  Tengine= pointer;
var
  engine:Tengine;
var
  {Execute matlab statement }
  engEvalString: function(engine: Tengine; st:Pansichar):integer;cdecl;


  {Start matlab process for single use. Not currently supported on UNIX. }
  engOpenSingleUse: function( startCmd:Pansichar;       { exec command string used to start matlab }
   			     reserved: pointer;     { reserved for future use, must be NULL }
    			     var retstatus:integer) { return status }
                             :integer;cdecl;


  {SetVisible, do nothing since this function is only for NT }
  engSetVisible: function( engine:Tengine;          { engine pointer }
                           newVal:bool):integer;cdecl;



  {GetVisible, do nothing since this function is only for NT }
  engGetVisible: function( engine: Tengine;         { engine pointer }
		           var bVal:bool):integer;cdecl;


  { Start matlab process }
  engOpen: function( startcmd :Pansichar)  { exec command string used to start matlab }
                   :Tengine;cdecl;



 { Close down matlab server }
  engClose: function(engine:Tengine):integer;cdecl; { engine pointer }


 { Get a variable with the specified name from MATLAB's workspace }
  engGetVariable: function (Engine: Tengine;	    { engine pointer }
	                    name:Pansichar)	            { name of variable to get }
	                   :MxArrayPtr;cdecl;


 { Put a variable into MATLAB's workspace with the specified name }
  engPutVariable: function(Engine:Tengine; var_name:Pansichar; ap:MxArrayPtr):integer;cdecl;


 { register a buffer to hold matlab text output }
  engOutputBuffer:function(Engine:Tengine;buffer:Pansichar; buflen:integer):integer;cdecl;



function initMatLab:boolean;
Procedure FreeMatLab;

procedure testMatLab;
procedure resetMatlabTested;

implementation





var
  Ftried, FOK:boolean;
  hmatlab:intG;

procedure resetMatlabTested;
begin
  Ftried:=false;
end;

function initMatLab:boolean;
begin
  if Ftried then
  begin
    result:=FOK;
    if FOK then
    begin
      engine:= engOpen(nil);
      initMatlabMatrix;
    end;

    exit;
  end;

  Ftried:=true;
  FOK:=false;
  result:=FOK;

  hMatLab:=loadMatlabDLL('libeng.dll');
  //messageCentral('hmatlab = '+int64str(hMatLab));

  if hMatLab=0 then exit;

  FOK:=true;
  result:=FOK;

  {LibEng}

  engEvalString:=getProc(hmatlab,'engEvalString');
  engOpenSingleUse:=getProc(hmatlab,'engOpenSingleUse');
  engSetVisible:=getProc(hmatlab,'engSetVisible');
  engGetVisible:=getProc(hmatlab,'engGetVisible');
  engOpen:=getProc(hmatlab,'engOpen');
  engClose:=getProc(hmatlab,'engClose');
  engGetVariable:=getProc(hmatlab,'engGetVariable');
  engPutVariable:=getProc(hmatlab,'engPutVariable');
  engOutputBuffer:=getProc(hmatlab,'engOutputBuffer');

  engine:= engOpen(nil);
  if engine=nil then
  begin
    messageCentral('Unable to create Matlab engine : engOpen = 0');
    freeMatlab;
  end
  else initMatlabMatrix;
end;

Procedure FreeMatLab;
begin
  if hmatlab<>0 then
  begin
    if (engine<>nil) then engClose(engine);
    freeLibrary(hMatlab);
  end;
  hMatLab:=0;
end;

var
  T:MxArrayPtr;

procedure testMatLab;
var
  p:PtabDouble;
  i:integer;
begin
   T := mxCreateDoubleMatrix(1, 10, mxREAL);
   p:=mxGetPr(T);
   for i:=0 to 9 do p^[i]:=i;

   engPutVariable(engine, 'T', T);

   engEvalString(engine, 'D = .5.*(-9.8).*T.^2;');

   engEvalString(engine, 'plot(T,D);');
   engEvalString(engine, 'title(''Position vs. Time for a falling object'');');
   engEvalString(engine, 'xlabel(''Time (seconds)'');');
   engEvalString(engine, 'ylabel(''Position (meters)'');');

   messageCentral('OK');
   mxDestroyArray(T);
   engEvalString(engine, 'close;');
end;

Initialization
AffDebug('Initialization Matlab0',0);

finalization
  freeMatLab;
end.
