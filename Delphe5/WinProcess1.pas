unit WinProcess1;

interface

uses Windows, classes, sysutils, util1, stmDef, stmobj, stmPg, stmMemo1;

function fonctionCallProcess(cmdLine: Ansistring; var list: TstmMemo): integer;pascal;

implementation



function fonctionCallProcess(cmdLine: AnsiString; var list: TstmMemo): integer;
const
  g_hChildStd_IN_Rd: Thandle = 0;
  g_hChildStd_IN_Wr: Thandle = 0;
  g_hChildStd_OUT_Rd: Thandle = 0;
  g_hChildStd_OUT_Wr: Thandle = 0;

var
   saAttr: SECURITY_ATTRIBUTES ;

   ProcInfo: PROCESS_INFORMATION ;
   StartInfo: TSTARTUPINFO ;
   bSuccess: BOOL;

   dwRead, dwWritten: longword;
   chBuf:string;
   code: cardinal;
   tot: integer;
begin

   verifierObjet(typeUO(list));
// Set the bInheritHandle flag so pipe handles are inherited. 

   saAttr.nLength := sizeof(SECURITY_ATTRIBUTES);
   saAttr.bInheritHandle := TRUE;
   saAttr.lpSecurityDescriptor := Nil;

// Create a pipe for the child process's STDOUT. 
 
   if not CreatePipe(g_hChildStd_OUT_Rd, g_hChildStd_OUT_Wr, @saAttr, 0) then exit;

// Ensure the read handle to the pipe for STDOUT is not inherited.

   if not SetHandleInformation(g_hChildStd_OUT_Rd, HANDLE_FLAG_INHERIT, 0) then exit;

// Create a pipe for the child process's STDIN.
 
   if not CreatePipe(g_hChildStd_IN_Rd, g_hChildStd_IN_Wr, @saAttr, 0) then exit;

// Ensure the read handle to the pipe for STDIN is not inherited.

   if not SetHandleInformation(g_hChildStd_IN_Wr, HANDLE_FLAG_INHERIT, 0) then exit;

// Create the child process. 

  // Set up members of the PROCESS_INFORMATION structure.

   ZeroMemory( @ProcInfo, sizeof(PROCESS_INFORMATION) );

// Set up members of the STARTUPINFO structure.
// This structure specifies the STDIN and STDOUT handles for redirection.

   ZeroMemory( @StartInfo, sizeof(TSTARTUPINFO) );
   StartInfo.cb := sizeof(TSTARTUPINFO);
   StartInfo.hStdError := g_hChildStd_OUT_Wr;
   StartInfo.hStdOutput := g_hChildStd_OUT_Wr;
   StartInfo.hStdInput := g_hChildStd_IN_Rd;
   StartInfo.wShowWindow:= SW_HIDE;
   StartInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW	;

// Create the child process.

   bSuccess := CreateProcess(Nil,
      Pchar(Cmdline),     // command line
      nil,          // process security attributes
      nil,          // primary thread security attributes
      TRUE,          // handles are inherited
      0,             // creation flags
      nil,          // use parent's environment
      nil,          // use parent's current directory
      StartInfo,  // STARTUPINFO pointer
      ProcInfo);  // receives PROCESS_INFORMATION

   // If an error occurs, exit the application.
   if not bSuccess then Exit;

   closeHandle( g_hChildStd_IN_Rd);            // Deux lignes indispensables!
   closeHandle( g_hChildStd_OUT_Wr);           // sinon blocage

   tot:=0;
   repeat
     setlength(chBuf,10000);
     dwRead:=0;
     bSuccess := ReadFile( g_hChildStd_OUT_Rd, pointer(@chBuf[1])^, 10000, dwRead, nil);

     if bSuccess and (dwRead>0) then
     begin
       setLength(chBuf,dwRead);
       tot:= tot+dwRead;
       StatuslineTxt('Total ='+Istr(tot));
       list.Addline(chBuf);
       if testerFinPg then break;
     end
     else break;
   until false;

   GetExitCodeProcess(procInfo.hprocess,code);
   result:= code;

   CloseHandle(ProcInfo.hProcess);
   CloseHandle(ProcInfo.hThread);
end;

end.
