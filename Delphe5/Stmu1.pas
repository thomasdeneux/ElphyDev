unit Stmu1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
uses Windows,MMsystem,
     Graphics,Dialogs,controls,forms,messages,
     util1,Dgraphic,Gdos,stmError,
     FormDlg2,FormMenu,
     editCont,
     Ncdef2,stmDef, debug0;


procedure proMessageCentral(st:AnsiString);pascal;
function FonctionQuestionCentrale(st:AnsiString):boolean;pascal;
procedure proInitSaisie;                    pascal;
procedure proSaisieText(titre:AnsiString); pascal;

procedure proSaisieInteger(titre:AnsiString;var x:Integer;tpX:smallint;n:smallInt);pascal;

procedure proSaisieLongint(titre:AnsiString;var x:longint;n:smallInt);pascal;
procedure proSaisieReal(titre:AnsiString;var x:float;tpX:smallint;n,m:smallInt);pascal;
procedure proSaisieBoolean(titre:AnsiString;var x:boolean);pascal;

procedure proSaisieScalaire(titre,Option:AnsiString;var x:Integer;tpX:smallint);pascal;

procedure proSaisieString(titre:AnsiString;var x:AnsiString;n:smallInt);pascal;
procedure proSaisieString_1(titre:AnsiString;var x:PgString;sz:integer;n:smallInt);pascal;


procedure proSaisieCommande(titre:AnsiString;var x:boolean);pascal;

procedure proSaisieCommande1(titre:AnsiString;w:integer);pascal;

procedure proSaisieCouleur(titre:AnsiString;var x:longint);pascal;
procedure prosaisieCaption(st:AnsiString);pascal;

function fonctionSaisie:integer;                    pascal;
function fonctionSaisie1(x0,y0:smallInt):integer;   pascal;
procedure resetSaisie;                              pascal;


function fonctionIstr(i:integer):AnsiString;pascal;
function fonctionIstr_1(i,n:integer):AnsiString;pascal;

function fonctionInt64str(i:int64):AnsiString;pascal;
function fonctionInt64str_1(i: int64; n:integer):AnsiString;pascal;

function fonctionHexaStr(i:integer):AnsiString;pascal;
function fonctionHexaStr_1(i,nb:integer):AnsiString;pascal;

function fonctionBstr(w:boolean):AnsiString;pascal;

function fonctionRstr(x:float;n,m:smallInt):AnsiString;pascal;
function fonctionRstr_1(x:float):AnsiString;pascal;

procedure proPause;                         pascal;
procedure ProHalt;                          pascal;

function FonctionClavier:smallInt;          pascal;

{
function FonctionChoixmenu
  (st:AnsiString;x0,y0:Integer;var Ninit:Integer):Integer;pascal;
function FonctionOuvrirmenu
  (st:AnsiString;x0,y0:Integer;var Ninit:Integer):Integer;pascal;
procedure proFermermenu;pascal;
}
procedure proStatusLineTxt(st:AnsiString); pascal;
function fonctionNewFileName(st:AnsiString):AnsiString;pascal;
procedure resetStmU1;

function FonctionRgb(x,y,z:Integer):longint;pascal;

function fonctionWinExec(stCmd:AnsiString;cmd:integer):integer;pascal;

function fonctionAllocatedMemory:int64;pascal;

function fonctionTimeGetTime:longint;pascal;
function fonctionGetStringOption(st:AnsiString;n:integer):AnsiString;pascal;

procedure proRotation(x1,y1:float;var x2,y2:float;x0,y0:float;angle:float);pascal;

procedure ProPlaySound(st:AnsiString; flags: longword);pascal;

implementation

var
  E_field:integer;
  E_positionSaisie:integer;
  E_deci:integer;
  E_string:integer;

const
  xTextAc1:smallInt=1;
  yTextAc1:smallInt=1;

procedure proMessageCentral(st:AnsiString);
  begin
    MessageCentral(st);
  end;

function FonctionQuestionCentrale(st:AnsiString):boolean;
begin
 {$IF CompilerVersion >=22}
  result:= windows.MessageBox(0,Pchar(st),'Elphy2',MB_ICONQUESTION or MB_YESNO or MB_taskMODAL or MB_TOPMOST)=IDYES;
 {$ELSE}
  result:= MessageDlg(st, mtConfirmation, [mbYes, mbNo], 0) = mrYes;
 {$IFEND}
end;


const
  DlgPg:TDlgForm2=nil;


procedure proInitSaisie;
  begin
    if assigned(DlgPg) then DlgPg.free;
    DlgPg:=TDlgForm2.create(formStm);
  end;

procedure proSaisieText(titre:AnsiString);
  begin
    if not assigned(DlgPg) then sortieErreur(E_menu);
    DlgPg.setText(titre,'',0,0,0);
  end;

procedure proSaisieInteger(titre:AnsiString;var x:Integer;tpX:smallint;n:smallInt);
  begin
    if not assigned(DlgPg) then sortieErreur(E_menu);
    controleParam(n,1,20,E_field);
    DlgPg.setNumVar(titre,x,NbToTT(tpX),n,0);
  end;

procedure proSaisieLongint(titre:AnsiString;var x:longint;n:smallInt);
  begin
    if not assigned(DlgPg) then sortieErreur(E_menu);
    controleParam(n,1,20,E_field);;
    DlgPg.setNumVar(titre,x,T_longInt,n,0);
  end;

procedure proSaisieReal(titre:AnsiString;var x:float;tpX:smallint;n,m:smallInt);
  begin
    if not assigned(DlgPg) then sortieErreur(E_menu);
    controleParam(n,1,23,E_field);
    controleParam(m,1,n-1,E_deci);
    DlgPg.setNumVar(titre,x,nbToTT(tpX),n,m);
  end;

procedure proSaisieBoolean(titre:AnsiString;var x:boolean);
  begin
    if not assigned(DlgPg) then sortieErreur(E_menu);
    DlgPg.setBoolean(titre,x);
  end;

procedure proSaisieScalaire(titre,Option:AnsiString;var x:Integer;tpX:smallint);
  begin
    if not assigned(DlgPg) then sortieErreur(E_menu);
    DlgPg.setEnumerated(titre,Option,x,nbtoTT(tpX));
  end;


procedure proSaisieString(titre:AnsiString;var x:AnsiString;n:smallInt);
begin
  if not assigned(DlgPg) then sortieErreur(E_menu);
  if n<0 then n:=0;;
  DlgPg.setString(titre,x,n);
end;


procedure proSaisieString_1(titre:AnsiString;var x:PgString;sz:integer;n:smallInt);
var
  x1:ShortString absolute x;
begin
  if not assigned(DlgPg) then sortieErreur(E_menu);
  ControleParam(n,1,255,e_string);
  DlgPg.setShortString(titre,x1,sz-1,n);
end;

procedure proSaisieCommande(titre:AnsiString;var x:boolean);
  begin
    if not assigned(DlgPg) then sortieErreur(E_menu);
    DlgPg.setCommand(titre,x,100);
  end;

procedure proSaisieCommande1(titre:AnsiString;w:integer);
begin
  if not assigned(DlgPg) then sortieErreur(E_menu);
  DlgPg.setCommand(titre,Pboolean(nil)^,w);
end;

procedure proSaisieCouleur(titre:AnsiString;var x:longint);
  begin
    if not assigned(DlgPg) then sortieErreur(E_menu);
    DlgPg.setColor(titre,x);
  end;

procedure prosaisieCaption(st:AnsiString);
begin
  if not assigned(DlgPg) then sortieErreur(E_menu);
  DlgPg.caption:=st;

end;

function fonctionSaisie:integer;
begin
  if not assigned(DlgPg) then sortieErreur(E_menu);
  TRY
    result:=DlgPg.showModal;
    if result<>mrCancel then updateAllVar(DlgPg);
  FINALLY
    DlgPg.free;
    DlgPg:=nil;
  END;
end;

function fonctionSaisie1(x0,y0:smallInt):integer;
var
  oldx,oldy:smallInt;
begin
  if not assigned(DlgPg) then sortieErreur(E_menu);
  controleParam(x0,0,screen.width-1,E_positionSaisie);
  controleParam(y0,0,screen.height-1,E_positionSaisie);

  oldx:=FormDlgLeft;
  oldy:=FormDlgTop;
  FormDlgLeft:=x0;
  FormDlgTop:=y0;

  TRY
    result:=DlgPg.showModal;
    if result<>mrCancel then updateAllVar(DlgPg);
  FINALLY
    DlgPg.free;
    DlgPg:=nil;
  END;

  FormDlgLeft:=oldx;
  FormDlgTop:=oldy;

end;

procedure resetSaisie;
  begin
    if assigned(DlgPg) then DlgPg.free;
  end;


function fonctionIstr(i:integer):AnsiString;
begin
  result:=Istr(i);
end;

function fonctionIstr_1(i,n:integer):AnsiString;
begin
  result:=Istr1(i,n);
end;

function fonctionHexaStr(i:integer):AnsiString;
begin
  result:=Hexa(i);
end;

function fonctionHexaStr_1(i,nb:integer):AnsiString;
begin
  result:=Hexa(i,nb);
end;


function fonctionInt64str(i:int64):AnsiString;
begin
  result:=Int64str(i);
end;

function fonctionInt64str_1(i:int64; n:integer):AnsiString;
begin
  result:=Int64str1(i,n);
end;



function fonctionBstr(w:boolean):AnsiString;
  begin
    if w
      then result:='TRUE'
      else result:='FALSE';
  end;

function fonctionRstr(x:float;n,m:smallInt):AnsiString;
  begin
    fonctionRstr:=Estr1(x,n,m);
  end;

function fonctionRstr_1(x:float):AnsiString;
begin
  result:=Estr1(x,0,0);
end;



procedure proPause;
  begin
    MessageDlgPos('Click OK to continue', mtInformation, [mbOK], 0,
                  screen.width div 2-100,screen.Height-150);
  end;



procedure ProHalt;
  begin
    finExe:=true;
  end;


function FonctionClavier:smallInt;
  var
    msg:Tmsg;
  begin
    repeat until peekMessage(msg,getFocus,wm_keyDown,wm_keyDown,pm_remove);
    FonctionClavier:=msg.wparam;
  end;


procedure proStatusLineTxt(st:AnsiString);
  begin
    statusLine.caption:=st;
    statusLine.update;
  end;

procedure resetStmU1;
  begin
    if assigned(DlgPg) then DlgPg.free;
    DlgPg:=nil;
  end;


function fonctionNewFileName(st:AnsiString):AnsiString;
  begin
    fonctionNewFileName:=premierNomDisponible(st);
  end;

function FonctionRgb(x,y,z:integer):longint;
  begin
    FonctionRgb:=rgb(x,y,z);
  end;

function fonctionWinExec(stCmd:AnsiString;cmd:integer):integer;
begin
  stCmd:=stCmd+' ';
  result:=winExec(@stCmd[1],cmd);
end;

function fonctionAllocatedMemory:int64;
begin
  result:=getHeapStatus.totalAllocated;
end;

function fonctionTimeGetTime:longint;
begin
  result:=TimeGetTime;
end;

function fonctionGetStringOption(st:AnsiString;n:integer):AnsiString;
var
  k:integer;
begin
  dec(n);
  while (n>0) and (st<>'') do
  begin
    k:=pos('|',st);
    if k=0 then k:=length(st);
    delete(st,1,k);
    dec(n);
  end;

  k:=pos('|',st);
  if k=0 then k:=length(st)+1;

  result:=copy(st,1,k-1);
end;

procedure proRotation(x1,y1:float;var x2,y2:float;x0,y0:float;angle:float);
var
  sin0,cos0:float;
  dx,dy:float;
begin
  dx:=x1-x0;
  dy:=y1-y0;

  sin0:=sin(angle);
  cos0:=cos(angle);
  x2:=dx*cos0-dy*sin0+x0;
  y2:=dx*sin0+dy*cos0+y0;
end;

procedure ProPlaySound(st:AnsiString; flags: longword);
begin
  PlaySound(Pchar(st),0, flags);
end;



Initialization
AffDebug('Initialization stmU1',0);

installError(E_field,'Dialog box: invalid field parameter');
installError(E_positionSaisie,'Dialog box: invalid position');
installError(E_deci,'Dialog box: invalid decimal places');
installError(E_string,'Dialog box: invalid string length');


end.
