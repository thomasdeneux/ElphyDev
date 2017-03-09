unit stmFifoError;

interface

uses classes, sysUtils,
     util1, stmDef,
     debug0,ErrorForm1;


Const
  MaxError=20;
type
  TFifoError=class
             private
               strings: TStringList;
               ad: Tlist;
               line: Tlist;
               stF: TStringList;
               FifoIn:integer;
             public
               constructor create;
               destructor destroy;override;
               function Put(st:AnsiString;aderror:integer;ErrorLine:integer;stFile:string):integer;
               function get(i:integer;var stFile:string; var ErrorLine,AdError: integer): AnsiString;
               function getLine(i:integer;var stFile:string; var ErrorLine,AdError: integer): AnsiString;
               procedure DisplayHistory;
               procedure ClearMessages;
             end;

var
  FifoError:TFifoError;

  GenericExeError:AnsiString;



implementation



constructor TfifoError.create;
begin
  strings:=TstringList.Create;
  stF:=TstringList.Create;
  line:=Tlist.Create;
  ad:= Tlist.Create;
end;

destructor TfifoError.destroy;
begin
  strings.Free;
  stF.Free;
  line.Free;
  ad.Free;
end;


function TfifoError.Put(st:AnsiString;aderror:integer;ErrorLine:integer;stFile:string):integer;
begin
  strings.AddObject(st,pointer(FifoIn));
  ad.Add(pointer( adError));
  line.Add( pointer(ErrorLine));
  stF.Add(stFile);

  result:=FifoIn;
  inc(FifoIn);

  ErrorForm.SetLineCount(Strings.Count);
end;

function TfifoError.getLine(i:integer;var stFile:string; var ErrorLine,AdError: integer ): AnsiString;
begin

  if (i<0) or (i>=strings.Count) then
  begin
    result:='';
    stFile:='';
    ErrorLine:=0;
    AdError:=0;
  end
  else
  begin
    result:=strings[i];
    AdError:= intG(Ad[i]);
    ErrorLine:= intG(line[i]);
    stFile:= stF[i];
    if not fileExists(stFile) then stFile:= FindFileInPathList(stFile,Pg2SearchPath);
  end;
end;

function TfifoError.get(i:integer;var stFile:string; var ErrorLine,AdError: integer ): AnsiString;
begin
  i:=strings.IndexOfObject(pointer(i));
  result:= getLine(i,stFile, errorLine, AdError);
end;

procedure TFifoError.DisplayHistory;
begin
  errorForm.show;
end;

procedure TfifoError.ClearMessages;
begin
  strings.Clear;
  stF.Clear;
  line.Clear;
  ad.Clear;

  ErrorForm.SetLineCount(Strings.Count);
end;


Initialization
AffDebug('Initialization stmFifoError',0);

FifoError:=TFifoError.create;

finalization

FifoError.free;

end.
