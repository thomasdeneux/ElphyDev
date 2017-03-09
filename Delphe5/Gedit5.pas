unit Gedit5;


 {$IF CompilerVersion >=22}
 {$IFDEF WIN64}
   {$DEFINE VERANSI}
 {$ELSE}
   {$DEFINE VERSTRING}
 {$ENDIF}
 {$ELSE}
   {$DEFINE VERANSI}
 {$IFEND}


interface

uses
  Windows,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, Printers,

  util1,DdosFich,
  Efind1, Ereplace,
  procac2,chooseTopic1,
  stmDef, synedit,syneditTypes,synEditSearch, SynEditHighlighter,

  SynHighlighterElphy,

  ConfirmReplace, SynHighlighterPython,
  adpMRU, SynMemo,
  debug0, Buttons,
  SearchPath1;


var
  stTxtHistory:AnsiString;




Const
  BreakPointColor: integer = $FFFFFF;             // Blanc
  BreakPointBKColor: integer = $FF;               // sur fond rouge

  CompErrorColor: integer =  $C0C0C0;             // Gris
  CompErrorBKcolor: integer =$FF0000;             // sur fond Bleu

  ExeErrorColor: integer =   $FF0000;             // Bleu
  ExeErrorBKcolor: integer = $FF;                 // sur fond rouge

  StepColor: integer =   $000000;                 // Noir
  StepBKcolor: integer = $FFFF00;                 // sur fond xxx


  DefEdColors:array[1..8] of integer = ( 8388736, 0, 4210816, 16711680, 8388863, 0, 0, 0);
  DefEdBKColors:array[1..8] of integer =($FFFFFF, $FFFFFF, $FFFFFF, $FFFFFF, $FFFFFF, $FFFFFF, $FFFFFF, $FFFFFF );

  DefEdBold:array[1..8] of boolean = ( false, true, true, false, false, false, false, false );
  DefEdItalic:array[1..8] of boolean = ( true, false, false, false, false, false, false, false );
  DefEdUnderscore:array[1..8] of boolean = ( false, false, false, false, false, false, false, false );

var
  ErrorLine:integer;      // ligne indiquant une erreur EXE ou de compilation
  ErrorColor:integer;
  ErrorBKcolor:integer;

  StepLine:integer;
  
type
  TsynEditPlug=
    class(TsynEditPlugin)
    protected
      procedure AfterPaint(ACanvas: TCanvas; const AClip: TRect;
                   FirstLine, LastLine: integer);override;
      procedure LinesInserted(FirstLine, Count: integer);override;
      procedure LinesDeleted(FirstLine, Count: integer);override;
    public
      BreakPoints: Tlist;
      constructor Create(AOwner: TSynEdit);
      destructor Destroy; override;
      procedure ToggleBreakPoint(line: integer);
      procedure ClearBreakPoint;
      function HasBreakPoint(line:Integer):boolean;
    end;


  TsynEditX=class(TsynEdit)
            public
              plug:TsyneditPlug;
              fileName:AnsiString;
              dateF: integer;

              procedure LoadFromFile(st: AnsiString);
              procedure SaveToFile(st: AnsiString);
              function BreakPointCount:integer;
              function BreakPoint(n:integer):integer;
            end;


type
  TgetNumProcHlp=function (st:AnsiString):integer of object;

  TrecSplit=record
              line:integer;
              st:string[60];
            end;

type
  Tedit5 = class(TForm)
    StatusBar1: TStatusBar;
    FontDialog1: TFontDialog;
    MainMenu2: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Load1: TMenuItem;
    save1: TMenuItem;
    Saveas1: TMenuItem;
    Print1: TMenuItem;
    Edit1: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    N2: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Cut1: TMenuItem;
    Search1: TMenuItem;
    Find1: TMenuItem;
    FindNext1: TMenuItem;
    Replace1: TMenuItem;
    Options1: TMenuItem;
    Font1: TMenuItem;
    Program1: TMenuItem;
    Build1: TMenuItem;
    Info1: TMenuItem;
    Sizes1: TMenuItem;
    Code2: TMenuItem;
    Symbols2: TMenuItem;
    Adlist1: TMenuItem;
    Ulist1: TMenuItem;
    Help1: TMenuItem;
    Editorhelp1: TMenuItem;
    Programhelp1: TMenuItem;
    PageControl1: TPageControl;
    Saveall1: TMenuItem;
    Close1: TMenuItem;
    Closeall1: TMenuItem;
    Compile1: TMenuItem;
    Primaryfile1: TMenuItem;
    Choose1: TMenuItem;
    Clear1: TMenuItem;
    RPopup: TPopupMenu;
    Help2: TMenuItem;
    Evaluate2: TMenuItem;
    Openfileatcursor1: TMenuItem;
    PrinterSetupDialog1: TPrinterSetupDialog;
    Setasprimaryfile1: TMenuItem;
    Printsetup2: TMenuItem;
    Font2: TMenuItem;
    Print2: TMenuItem;
    Lasterrormessage1: TMenuItem;
    CompiledFiles1: TMenuItem;
    Build2: TMenuItem;
    Splitprimaryfile1: TMenuItem;
    Colors1: TMenuItem;
    adpMRU1: TadpMRU;
    N1: TMenuItem;
    Evaluateselection1: TMenuItem;
    ShowCommands1: TMenuItem;
    Run1: TMenuItem;
    Execute2: TMenuItem;
    ProgramReset2: TMenuItem;
    Debug1: TMenuItem;
    StepOver1: TMenuItem;
    TraceInto1: TMenuItem;
    AddBreakPoint1: TMenuItem;
    ClearBreakPointlist1: TMenuItem;
    GutterMenu: TPopupMenu;
    AddBreakPoint2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    StopDebug1: TMenuItem;
    SpeedButton1: TSpeedButton;
    FindDeclaration1: TMenuItem;
    Directories1: TMenuItem;
    procedure New1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure save1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Closeall1Click(Sender: TObject);
    procedure Saveall1Click(Sender: TObject);

    procedure Editorhelp1Click(Sender: TObject);
    procedure Programhelp1Click(Sender: TObject);
    procedure Build1Click(Sender: TObject);
    procedure Execute1Click(Sender: TObject);
    procedure Evaluate1Click(Sender: TObject);
    procedure Sizes1Click(Sender: TObject);
    procedure Code2Click(Sender: TObject);
    procedure Symbols2Click(Sender: TObject);
    procedure Adlist1Click(Sender: TObject);
    procedure Ulist1Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Redo1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure FindNext1Click(Sender: TObject);
    procedure Replace1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Primaryfile1Click(Sender: TObject);
    procedure Program1Click(Sender: TObject);
    procedure Compile1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Help2Click(Sender: TObject);
    procedure Openfileatcursor1Click(Sender: TObject);
    procedure Programreset1Click(Sender: TObject);
    procedure Lasterrormessage1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Printsetup1Click(Sender: TObject);
    procedure Setasprimaryfile1Click(Sender: TObject);
    procedure Font2Click(Sender: TObject);
    procedure CompiledFiles1Click(Sender: TObject);
    procedure Build2Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Splitprimaryfile1Click(Sender: TObject);
    procedure SynEdit1ReplaceText(Sender: TObject; const ASearch,
      AReplace: String; Line, Column: Integer;
      var Action: TSynReplaceAction);
    procedure Colors1Click(Sender: TObject);
    procedure Evaluateselection1Click(Sender: TObject);
    procedure ShowCommands1Click(Sender: TObject);

    procedure Debug1Click(Sender: TObject);
    procedure StepOver1Click(Sender: TObject);
    procedure TraceInto1Click(Sender: TObject);
    procedure AddBreakPoint1Click(Sender: TObject);
    procedure ClearBreakPointlist1Click(Sender: TObject);
    procedure StopDebug1Click(Sender: TObject);

    procedure FormDeactivate(Sender: TObject);
    procedure FindDeclaration1Click(Sender: TObject);

    {$IF CompilerVersion>=22}
    procedure adpMRU1Click(Sender: TObject; const ItemText: AnsiString);    { AnsiString nécessaire pour XE }
    {$ELSE}
    procedure adpMRU1Click(Sender: TObject; const ItemText: String);
            { Mais delphi7 a besoin de String }
    {$IFEND}
    procedure FormActivate(Sender: TObject);
    procedure PageControl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PageControl1Exit(Sender: TObject);
    procedure Directories1Click(Sender: TObject);

  private
    { Déclarations privées }

    AidePG:AnsiString;
    PgChm:AnsiString;
    PnumLine:array of TrecSplit;

    HintW:ThintWindow;

    function getCaption(editor:TsynEditX):AnsiString;

    function getEditor(num:integer):TsynEditX;

    function selectPage(stf:AnsiString):boolean;
    function QuestionSave(editor:TsynEditX):boolean;
    procedure savePage(page:TtabSheet);

    procedure TraiterCtrlReturn;
    procedure Editor1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Editor1ShowStatus(Sender: TObject; Changes: TSynStatusChanges);

    procedure setFileNames(st:AnsiString);
    function getFileNames:AnsiString;



    procedure EditorMouseDown(Sender: TObject; Button: TMouseButton;
                              Shift: TShiftState; X, Y: Integer);

    procedure EditorMouseUp(Sender: TObject; Button: TMouseButton;
                              Shift: TShiftState; X, Y: Integer);

    procedure EditorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    procedure NewPage;

    function PrimarySplitted:boolean;

    procedure SpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    procedure EditorChange(Sender: TObject);
    procedure EditorExit(Sender: TObject);
    procedure EditorScroll(Sender: TObject; ScrollBar: TScrollBarKind);

    procedure SynEditorGutterClick(Sender: TObject; Button: TMouseButton;
                                   X, Y, Line: Integer; Mark: TSynEditMark);

  public
    { Déclarations publiques }
    caption0: AnsiString;
    StoppedString: AnsiString;
    LastFile: AnsiString;

    tabProc:TtabDefProc;
    compilerPg:procedure(source:AnsiString;var error:AnsiString;var lig,col:integer;
                         var stFile:AnsiString;Fbuild:boolean) of object;

    HintPG:    function (st:string):string of object;
    FindDecPg: procedure(st:string) of object;

    CodePg:    procedure of object;
    SymbolePg: procedure of object;
    AdListPg,UlistPg: procedure of object;
    InfoPg:    procedure of object;
    executePg: procedure of object;
    ToggleDebugMode: procedure  of Object;
    StepOver: procedure of object;
    TraceInto: procedure of object;
    StopDebugPg: procedure of object;
    AddBreakPoint:  procedure of object;
    ClearBreakPoint: procedure of object;

    EvalPg:    procedure(st:AnsiString) of object;
    resetPg:   procedure of object;
    DisplayErrors: procedure of object;
    ShowCommandPg: procedure of object;

    stPrimary:AnsiString;
    getPrimary:function:AnsiString of object;
    setPrimary:procedure (st:AnsiString) of object;
    clearPrimary:procedure of object;
    CompHistory:procedure of object;

    setUserShortcuts: procedure (w:boolean) of object;

    motFind,MotReplace:AnsiString;
    FindHis,ReplaceHis:AnsiString;
    Fcase,Fword,Fglobal,Fforward,FentireScope,Fprompt:boolean;

    TheFont:Tfont;
    PrintFont:Tfont;

    stLastError:AnsiString;

    SynElphySyn1: {$IF CompilerVersion>= 22}TsynPasSyn; {$ELSE} TSynElphySyn; {$IFEND}
    SynPythonSyn1: TSynPythonSyn;


    function installFile(st:AnsiString;Fbis:boolean):boolean;

    property Editor[num:integer]:TsynEditX read getEditor;                  // de 0 à pageCount-1

    procedure SetErrorColor(linetype:integer);
    procedure ForcerPosition(lig,col:integer;stFile:AnsiString; Const LineType:integer=1);
    procedure ForcerLigne(stFile:AnsiString;lig:integer;go:boolean; Const LineType:integer=1);
    // lineType=1 ==> Exe Error
    // lineType=2 ==> Compile Error
    // lineType=3 ==> DebugLine

    procedure installHelp(p:TtabDefProc;stCHM:AnsiString);

    property FileNames:AnsiString read getFileNames write setFileNames;
    procedure ResetError;
    procedure ResetStepLine;
    function pageCount:integer;
    function currentFile:AnsiString;

    procedure LoadSplitPrimary;
    procedure savePrimaryFile;

    procedure setHighLighterColors;

    procedure FindAword(AnEditor: TsynEdit);
    procedure FindNextWord(AnEditor:TsynEdit);
    procedure HelpOnAword(st:AnsiString);
    procedure ProgramHelp;
    procedure ModifyCaption(st:string);


    procedure ShowEditHint(x,y:integer;st:AnsiString);
    procedure HideEditHint;
    function CurrentEditor:TsynEditX;

    procedure CheckEditorFiles;

  end;

function SearchEditGlb:TsynEditSearch;

implementation

uses editorColors1,htmlHelp1;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

function TsynEditX.BreakPointCount:integer;
begin
  result:=plug.BreakPoints.Count;
end;

function TsynEditX.BreakPoint(n:integer):integer;
begin
  result:=intG(plug.BreakPoints[n]);
end;

procedure TsynEditX.LoadFromFile(st: AnsiString);
begin
  lines.LoadFromFile(st);
  fileName:= st;
  dateF:= fileAge(st);
end;

procedure TsynEditX.SaveToFile(st: AnsiString);
begin
  lines.SaveToFile(st);
  FileName:=st;
  Modified:=false;
  dateF:= fileAge(st);
end;

{ Tedit5 }
function Tedit5.getEditor(num:integer):TsynEditX;
begin
  if (num>=0) and (num<PageCount)
    then result:=TsynEditX(pageControl1.pages[num].components[0])
    else result:=nil;
end;

function Tedit5.CurrentEditor: TsynEditX;
begin
  if PageCount >0
    then result:=TsynEditX(pageControl1.activepage.components[0])
    else result:=nil;
end;

function Tedit5.getCaption(editor: TsynEditX): AnsiString;
var
  ext:AnsiString;
  st:AnsiString;
begin
  st:=editor.fileName;
  if (length(st)>0) and (st[1]='}') then
  begin
    delete(st,1,1);
    st:=FsupEspaceDebut(st);
    st:=FsupEspaceFin(st);
    delete(st,length(st),1);
    result:=st;
    exit;
  end;

  result:=extractFileName(editor.fileName);
  if Fmaj(extractFileExt(st))='.PG2' then
    delete(result,pos('.',result),20);

  if result='' then result:='NoName';
end;

function Tedit5.pageCount:integer;
begin
  result:=pageControl1.PageCount;
end;

var
  SearchEditX: TsynEditSearch;

function SearchEditGlb:TsynEditSearch;
begin
  if not assigned(SearchEditX) then SearchEditX:=TsynEditSearch.Create{$IFNDEF FPC} (formStm) {$ENDIF};
  result:=SearchEditX;
end;

procedure Tedit5.NewPage;
var
  page:TtabSheet;
  editor:TsynEditX;
begin
  page:=TtabSheet.Create(pageControl1);
  page.ImageIndex:=-1;

  page.PageControl:=pageControl1;
  if pageCount>1
    then page.PageIndex:=pageControl1.activePageIndex+1;
  pageControl1.ActivePage:=page ;


  editor:=TsynEditX.create(page);
  with editor do
  begin
    parent:=page;
    Align:=AlClient;
    Font.assign(TheFont);
    OnKeyDown:=Editor1KeyDown;
    OnStatusChange:=Editor1ShowStatus;
    OnMouseDown:=EditorMouseDown;
    OnMouseUp:= EditorMouseUp;
    OnMouseMove:= EditorMouseMove;

    OnSpecialLineColors:=SpecialLineColors;
    Options:=Options+[eoAutoIndent,
                      eoScrollPastEof,
                      eoSmartTabs
                      ];

    HighLighter:=SynElphySyn1;

    OnReplaceText:= SynEdit1ReplaceText;
    OnSpecialLineColors:=SpecialLineColors;
    onChange:=EditorChange;
    onExit:= EditorExit;
    onScroll:= EditorScroll;

    tabWidth:=2;
    ErrorLine:=-1;
    StepLine:=-1;

    plug:=TsynEditPlug.Create(editor);
    OnGutterClick:=SynEditorGutterClick;
    // Ne pas détruire plug. Il devient la propriété de editor.


  end;


  editor.SearchEngine:=SearchEditGlb;

  page.Caption:=getCaption(editor);

end;

procedure Tedit5.New1Click(Sender: TObject);
begin
  newPage;
  SavePage(pageControl1.ActivePage);
end;

function Tedit5.selectPage(stf: AnsiString):boolean;
var
  i,k:integer;
begin
  result:=false;
  stF:=Fmaj(stF);
  with pageControl1 do
  for i:=0 to pageCount-1 do
    with TsynEditX(pages[i].components[0]) do
      if Fmaj(fileName)=stF then
        begin
          ActivepageIndex:=i;
          result:=true;
          break;
        end;

  if not result then NewPage;
end;

function Tedit5.installFile(st:AnsiString;Fbis:boolean):boolean;
begin
  result:= (st<>'') and fileExists(st);

  if result then
    if not Fbis
      then result:= not selectPage(st)
      else NewPage;

  if result then
    begin
      if Fmaj(extractFileExt(st))='.PY'
        then currentEditor.Highlighter:=synPythonSyn1
        else currentEditor.Highlighter:=SynElphySyn1;

      currentEditor.LoadFromFile(st);
      pageControl1.activepage.caption:=getCaption(currentEditor);

      //pageControl1.activepage.hint:= st;              ne marche pas!
      //pageControl1.activepage.ShowHint:=true;

      lastFile:=st;
    end;
end;

procedure Tedit5.Load1Click(Sender: TObject);
var
  st:AnsiString;
begin
  st:=GchooseFile('Load a file',LastFile);
  if installFile(st,false) then
  begin
    adpMRU1.addItem(st);
    stTxtHistory:=adpMRU1.Text;
    PageControl1Change(nil);
  end;
end;


procedure Tedit5.FormCreate(Sender: TObject);
begin
  lastFile:='*.pg2';

  Fglobal:=true;
  Fprompt:=true;
  Fforward:=true;
  FentireScope:=true;

  TheFont:=Tfont.create;
  TheFont.Name:='Courier New';
  TheFont.Size:=10;

  PrintFont:=Tfont.create;
  PrintFont.Name:='Courier New';
  PrintFont.Size:=10;

  Close1.ShortCut := ShortCut(VK_F3, [ssAlt]);
 {$IF CompilerVersion>=22}
  SynElphySyn1:=TSynPasSyn.Create(self);
 {$ELSE}
  SynElphySyn1:=TSynElphySyn.Create(self);
 {$IFEND}
  SynPythonSyn1:=TSynPythonSyn.Create(self);
end;

function Tedit5.QuestionSave(editor:TsynEditX):boolean;
var
  res:integer;
  st:AnsiString;
begin
  result:=true;
  if Editor.modified then
    begin
      res:= MessageDlg('Save changes to '+extractFileName(Editor.fileName),
        mtConfirmation,[mbYes,mbNo,mbCancel],0);
      case res of
        mrCancel: result:=false;
        mrYes:
          begin
            st:=GsaveFile('Save',Editor.FileName,'PG2');
            if st<>'' then Editor.SaveToFile(st);
          end;
        mrNo: result:=true;
      end;
    end;
end;


procedure Tedit5.Close1Click(Sender: TObject);
var
  num:integer;
begin
  if (currentEditor.fileName='') or (currentEditor.FileName[1]='}') then exit;

  if (pageCount>0) and QuestionSave(currentEditor) then
    begin
      num:=pageControl1.activePageIndex;
      currentEditor.free;
      pageControl1.ActivePage.free;
      if num>0 then pageControl1.activePageIndex:=num-1;
      PageControl1Change(nil);
    end;
end;

procedure Tedit5.Closeall1Click(Sender: TObject);
begin
  if primarySplitted then Splitprimaryfile1Click(nil);

  while (pageCount>0) and QuestionSave(currentEditor) do
    begin
      currentEditor.free;
      pageControl1.ActivePage.free;
      PageControl1Change(nil);
    end;
end;

procedure Tedit5.save1Click(Sender: TObject);
begin
  if (currentEditor.fileName<>'') and (CurrentEditor.fileName[1]='}') then
  begin
    savePrimaryFile;
    exit;
  end;

  if PageCount>0 then
  if ExtractFileName(CurrentEditor.fileName)='NONAME.PG2'
    then SaveAs1Click(Sender)
    else CurrentEditor.SaveToFile(CurrentEditor.fileName);

  CurrentEditor.Modified:=false;
end;

procedure Tedit5.savePage(page:TtabSheet);
var
  st:AnsiString;
  res:integer;
  editor:TsynEditX;
begin
  if page=nil then exit;
  editor:=TsynEditX(page.components[0]);
  if (editor.fileName<>'') and (editor.fileName[1]='}') then exit;

  st:=GsaveFile('Save as',Editor.fileName,'PG2');
  if st<>'' then
    begin
      if fileExists(st) then
        begin
          res:= MessageDlg('File already exists. Overwrite?',
                mtConfirmation,[mbYes,mbNo],0);
          if res<>mrYes then exit;
        end;

      Editor.SaveToFile(st);
      Page.Caption:=getCaption(editor);
    end;
end;


procedure Tedit5.Saveas1Click(Sender: TObject);
begin
  if PageCount>0
    then SavePage(pageControl1.ActivePage);
end;




procedure Tedit5.Saveall1Click(Sender: TObject);
var
  i:integer;
begin
  if primarySplitted then savePrimaryFile;

  for i:=0 to PageCount-1 do
  begin
    if extractFileName(Editor[i].fileName)='NONAME.PG2' then
      SavePage(pageControl1.Pages[i])
    else
      with Editor[i] do
      begin
        if modified then SaveToFile(fileName);
      end;
  end;
end;


procedure Tedit5.Editorhelp1Click(Sender: TObject);
begin
  Application.HelpFile:=AppDir+'Gedit1.hlp';
  Application.HelpCommand(Help_contents,0);
end;

procedure Tedit5.ProgramHelp;
begin
  HTMLhelp(0,PAnsichar(PgChm),HH_DISPLAY_TOPIC,0);
end;


procedure Tedit5.Programhelp1Click(Sender: TObject);
begin
  ProgramHelp;
end;

function FID(st:AnsiString):AnsiString;
var
  i:integer;
begin
  st:=FsupEspaceFin(st);
  st:=FsupEspaceDebut(st);
  st:=Fmaj(st);
  for i:=1 to length(st) do
    case st[i] of
     ' ','''','.',':':  st[i]:='_';
     'é','è','ê':   st[i]:='E';
     'ç':           st[i]:='C';
     'à','â':       st[i]:='A';
     'ù','û':       st[i]:='U';
     'î':           st[i]:='I';
     'ô':           st[i]:='O';
    end;
  result:=st;
end;


procedure Tedit5.HelpOnAword(st:AnsiString);
var
  stList:TstringList;
begin
  stList:=TstringList.create;
  if TabProc.getHTMLhlp(st,stList) then
  begin
    stList.Sort;
    st:=ChooseTopic.execution(stList);
    stList.free;

    if st<>'' then
      HTMLhelp(0,PAnsichar(PgChm+'::/'+FID(st)+'.html' ),HH_DISPLAY_TOPIC,0);
  end
  else stList.free;
end;

procedure Tedit5.Help2Click(Sender: TObject);
begin
  HelpOnAWord(CurrentEditor.WordAtCursor);
end;

procedure Tedit5.installHelp(p:TtabDefProc;stCHM:AnsiString);
begin
  { installHelp est appelé dans stmPG }

  tabProc:=p;
  PgChm:= stCHM;  { =extractFilePath(paramStr(0))+'elphy.chm' }
end;

procedure Tedit5.SetErrorColor(linetype:integer);
begin
  case LineType of
    1:  begin
          ErrorColor:=   CompErrorColor;
          ErrorBKcolor:= CompErrorBKColor;
        end;
    2:  begin
          ErrorColor:=   ExeErrorColor;;
          ErrorBKcolor:= ExeErrorBKColor;
        end;
  end;
end;

procedure Tedit5.ForcerPosition(lig,col:integer;stFile:AnsiString; Const LineType:integer=1);
var
  i:integer;
begin
  if not FileExists(stFile) then
  begin
    messageCentral('Unable to load '+stFile);
    exit;
  end;

  if PrimarySplitted then
  begin
    i:=-1;
    repeat
      inc(i);
    until (i>high(PnumLine)) or (PnumLine[i].line>lig);

    stFile:=PnumLine[i-1].st;
    lig:=lig-PnumLine[i-1].line-1;
  end;

  if not selectPage(stFile) then
    begin
      currentEditor.LoadFromFile(stFile);
      pageControl1.activepage.caption:=getCaption(currentEditor);
    end;

  if (lig<1) or (lig>currentEditor.Lines.Count) then lig:=1;
  if col<1 then col:=1;

  show;

  with currentEditor do
  begin
    CaretXY:=BufferCoord(col,lig);

    if lineType=3 then
    begin
      invalidateLine(StepLine);
      invalidateGutterLine(StepLine);
      StepLine:=lig;
    end
    else
    begin
      setErrorColor(lineType);
      ErrorLine:=lig;
    end;

    invalidateLine(lig);
    invalidateGutterLine(StepLine);
    SetFocus ;
  end;
end;

procedure Tedit5.ForcerLigne(stFile:AnsiString;lig:integer;go:boolean; Const LineType:integer=1);
var
  i:integer;
begin
  if not FileExists(stFile) then
  begin
    messageCentral('Unable to load '+stFile);
    exit;
  end;

  if PrimarySplitted then
  begin
    i:=-1;
    repeat
      inc(i);
    until (i>high(PnumLine)) or (PnumLine[i].line>lig);

    stFile:=PnumLine[i-1].st;
    lig:=lig-PnumLine[i-1].line-1;
  end;


  if not selectPage(stFile) then
    begin
      currentEditor.LoadFromFile(stFile);
      pageControl1.activepage.caption:=getCaption(currentEditor);
    end;

  if (lig<1) or (lig>CurrentEditor.Lines.Count) then lig:=1;

  with currentEditor do
  begin
    CaretXY:=BufferCoord(1,lig);

    case lineType of
      1,2:begin
            setErrorColor(lineType);
            ErrorLine:=lig;
          end;
      3:  begin
            invalidateLine(StepLine);
            invalidateGutterLine(StepLine);
            StepLine:=lig;
          end;
    end;

    invalidateLine(lig);
    invalidateGutterLine(StepLine);
  end;

  if go then
  begin
    show;
    CurrentEditor.SetFocus ;
  end;
end;

procedure Tedit5.TraiterCtrlReturn;
var
  i,i1,i2,n:integer;
  st:AnsiString;
const
  letters=['A'..'Z','a'..'z','0'..'9','_','.','\','/',':'];
begin
  st:=CurrentEditor.Lines[CurrentEditor.caretY-1];
  i:=CurrentEditor.caretX;

  if (i>=1) and (i<=length(st)) and (st[i] in letters) then
  begin
    i1:=i;
    while (i1>1) and (st[i1-1] in letters) do dec(i1);

    i2:=i;
    while (i2<length(st)) and (st[i2+1] in letters+['.','\','/',':']) do inc(i2);
    st:=copy(st,i1,i2-i1+1);
  end
  else exit;

  if pos('.',st)<=0  then st:=st+'.pg2';
  if (pos(':',st)<=0) and (pos('\',st)<=0)
    then st:=extractFilePath(CurrentEditor.fileName)+st;

  if not FileExists(st) then st:=FindFileInPathList(st, Pg2SearchPath);
  if (st<>'') and not selectPage(st) then
    begin
      currentEditor.LoadFromFile(st);
      pageControl1.activepage.caption:=getCaption(currentEditor);
    end;

end;

procedure Tedit5.Editor1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_F1:     if shift=[ssCtrl] then Help2Click(nil);
    VK_return: if shift=[ssCtrl] then TraiterCtrlReturn;
    VK_F4:     if shift=[ssCtrl] then EvalPg(currentEditor.WordAtCursor);
    VK_F8:     StepOver1Click(self);
    VK_F7:     TraceInto1Click(self);
    VK_F9:     if shift=[] then Compile1Click(self)
               else
               if shift=[ssCtrl] then Execute1Click(self);
  end;
end;

procedure Tedit5.Editor1ShowStatus(Sender: TObject;Changes: TSynStatusChanges);
var
  p:TbufferCoord;
begin
  if [scCaretX,scCaretY]*Changes<>[] then
  begin
    p:=TsynEdit(sender).CaretXY;
    StatusBar1.Panels[0].Text := IntToStr(P.line) + ':' + IntToStr(p.char);
  end;

  if scModified in Changes then
  begin
    if CurrentEditor.Modified
      then StatusBar1.Panels[1].Text := 'Modified'
      else StatusBar1.Panels[1].Text := '';
  end;

  if scInsertMode in Changes then
  begin
    if CurrentEditor.InsertMode
      then StatusBar1.Panels[2].Text := 'Insert'
      else StatusBar1.Panels[2].Text := 'Overwrite';
  end;
end;



procedure Tedit5.Build1Click(Sender: TObject);
var
  error:AnsiString;
  lig,col:integer;
  stFile:AnsiString;
begin
  if testDebugMode then exit;

  if not assigned(compilerPg) then exit;

  compilerPg(stPrimary,error,lig,col,stFile,false);
  if error<>'' then forcerPosition(Lig,col,stFile)
  else
  if sender<>nil then messageCentral('Compile successfull');
end;

procedure Tedit5.Build2Click(Sender: TObject);
var
  error:AnsiString;
  lig,col:integer;
  stFile:AnsiString;
begin
  if testDebugMode then exit;
  if not assigned(compilerPg) then exit;

  compilerPg(stPrimary,error,lig,col,stFile,true);
  if error<>'' then forcerPosition(Lig,col,stFile)
  else
  if sender<>nil then messageCentral('Compile successfull');
end;

procedure Tedit5.Compile1Click(Sender: TObject);
var
  error: AnsiString;
  lig,col:integer;
  stFile:AnsiString;
begin
  if testDebugMode then exit;
  if not assigned(compilerPg) or (currentFile='') then exit;

  compilerPg(currentFile,error,lig,col,stFile,false);
  if error<>'' then forcerPosition(Lig,col,stFile)
  else

  if sender<>nil then messageCentral('Compile successfull');
end;


procedure Tedit5.Execute1Click(Sender: TObject);
begin
  if assigned(executePg) then executePg;
end;

procedure Tedit5.Evaluate1Click(Sender: TObject);
begin
  if assigned(EvalPg) then EvalPg(currentEditor.WordAtCursor);
end;

procedure Tedit5.Evaluateselection1Click(Sender: TObject);
begin
  if assigned(EvalPg) then EvalPg(currentEditor.SelText);
end;


procedure Tedit5.Sizes1Click(Sender: TObject);
begin
  if assigned(InfoPg) then infoPg;
end;

procedure Tedit5.Code2Click(Sender: TObject);
begin
  if assigned(codePg) then CodePg;
end;

procedure Tedit5.Symbols2Click(Sender: TObject);
begin
  if assigned(SymbolePg) then SymbolePg;
end;

procedure Tedit5.Adlist1Click(Sender: TObject);
begin
  if assigned(AdlistPg) then AdlistPg;
end;

procedure Tedit5.Ulist1Click(Sender: TObject);
begin
  if assigned(UlistPg) then UlistPg;
end;

procedure Tedit5.Font1Click(Sender: TObject);
var
  i:integer;
begin
  FontDialog1.Font.Assign(TheFont);
  if FontDialog1.Execute then
  begin
    TheFont.assign(FontDialog1.Font);
    for i:=0 to pageCount-1 do
      Editor[i].Font.Assign(FontDialog1.Font);
  end;
end;

procedure Tedit5.Undo1Click(Sender: TObject);
begin
  CurrentEditor.Undo;
end;

procedure Tedit5.Redo1Click(Sender: TObject);
begin
  CurrentEditor.Redo;
end;

procedure Tedit5.Copy1Click(Sender: TObject);
begin
  CurrentEditor.CopyToClipBoard;
end;

procedure Tedit5.Paste1Click(Sender: TObject);
begin
  CurrentEditor.PasteFromClipBoard;
end;

procedure Tedit5.Cut1Click(Sender: TObject);
begin
  CurrentEditor.CutToClipBoard;
end;

procedure Tedit5.Delete1Click(Sender: TObject);
begin
  //CurrentEditor.ProcessCommand(ccDel, 0);
end;


procedure Tedit5.FindAword(AnEditor: TsynEdit);
var
  OptionSet : TSynSearchOptions;
  st: AnsiString;
begin
  st:= AnEditor.SelText;
  if st='' then st:= AnEditor.WordAtCursor;
  MotFind:=GEditfind.execution(st ,FindHis, Fcase,Fword,Fglobal,Fforward,FentireScope);
  if motFind<>'' then
    begin
      OptionSet := [];
      if not Fforward then OptionSet := OptionSet + [ssoBackwards];
      if FentireScope then OptionSet := OptionSet + [ssoEntireScope];
      if Fcase then OptionSet := OptionSet + [ssoMatchCase];
      if Fword then OptionSet := OptionSet + [ssoWholeWord];
      if not Fglobal then OptionSet := OptionSet + [ssoSelectedOnly];

      if AnEditor.SearchReplace(motFind,'', OptionSet)=0 then
        MessageDlg('Search AnsiString ''' + motFind +
          ''' not found', mtInformation, [mbOk], 0);
  end;

  AnEditor.SetFocus;
end;

procedure Tedit5.Find1Click(Sender: TObject);
begin
  FindAword(CurrentEditor);
end;


procedure Tedit5.FindNextWord(AnEditor:TsynEdit);
var
  OptionSet : TSynSearchOptions;
begin
  if motFind<>'' then
    begin
      OptionSet := [];
      if not Fforward then OptionSet := OptionSet + [ssoBackwards];
      if Fcase then OptionSet := OptionSet + [ssoMatchCase];
      if Fword then OptionSet := OptionSet + [ssoWholeWord];
      if not Fglobal then OptionSet := OptionSet + [ssoSelectedOnly];

      if AnEditor.SearchReplace(motFind,'', OptionSet)=0 then
        MessageDlg('Search AnsiString ''' + motFind +
          ''' not found', mtInformation, [mbOk], 0);
  end;
  AnEditor.SetFocus;
end;

procedure Tedit5.FindNext1Click(Sender: TObject);
begin
  FindNextWord(CurrentEditor);
end;

procedure Tedit5.Replace1Click(Sender: TObject);
var
  OptionSet : TSynSearchOptions;
  Count : LongInt;
  Code : Word;
  Aborted : boolean;
begin
  motFind:=CurrentEditor.WordAtCursor;
  code:=GEditreplace.execution(motFind,FindHis,
                              MotReplace,ReplaceHis,
                              Fcase,Fword,Fglobal,Fforward,FentireScope,Fprompt);


  if (code=mrCancel) or (MotFind='') then exit;


  if Fprompt then OptionSet := [ssoPrompt] else OptionSet := [];
  if code=100 { Replace all}
    then OptionSet := OptionSet + [ssoReplaceAll]
    else OptionSet := OptionSet + [ssoReplace];

  if not Fforward then OptionSet := OptionSet + [ssoBackwards];
  if Fcase then OptionSet := OptionSet + [ssoMatchCase];
  if Fword then OptionSet := OptionSet + [ssoWholeWord];
  if not Fglobal then OptionSet := OptionSet + [ssoSelectedOnly];
  if FentireScope then OptionSet := OptionSet + [ssoEntireScope];

  Count := CurrentEditor.SearchReplace(motFind, motReplace, OptionSet);

  currentEditor.SetFocus;
end;

procedure Tedit5.FormDestroy(Sender: TObject);
begin
  closeAll1Click(self);

  theFont.Free;
  PrintFont.Free;
end;


procedure Tedit5.setFileNames(st:AnsiString);
var
  list:TstringList;
  i,j:integer;
  mark:array of boolean;
begin
  list:=TstringList.create;
  list.Text:=st;
  for i:=0 to list.count-1 do
  begin
    installFile(list[i],true);
    list[i]:=Fmaj(list[i]);
  end;

  list.clear;
  for i:=0 to pageCount-1 do list.add(Fmaj(editor[i].FileName));
  setLength(mark,list.Count);
  fillchar(mark[0],list.Count,0);

  for i:=0 to list.Count-1 do
  begin
    st:=list[i];
    if not mark[i] then
    begin
      for j:=i+1 to list.count-1 do
        if (list[j]=st) then
          begin
            (*editor[j].attach(editor[i]);*)
            mark[j]:=true;
          end;
      mark[i]:=true;
    end;
  end;

  list.free;

  PageControl1Change(nil);
end;

function Tedit5.getFileNames:AnsiString;
var
  i:integer;
begin
  result:='';
  if primarySplitted then result:=stPrimary+CRLF;

  for i:=0 to pageCount-1 do
  if (Editor[i].fileName<>'') and (editor[i].fileName[1]<>'}')
    then result:=result+editor[i].fileName+CRLF;

  if length(result)>2 then delete(result,length(result)-1,2);
end;

procedure Tedit5.ResetError;
var
  i,n:integer;
begin
  n:=ErrorLine;
  ErrorLine:=-1;

  for i:=0 to pageCount-1 do
    editor[i].invalidateLine(n);

  stLastError:='';
end;

procedure Tedit5.ResetStepLine;
var
  i,n:integer;
begin
  n:=StepLine;
  StepLine:=-1;

  for i:=0 to pageCount-1 do
    with editor[i] do
    begin
      invalidateLine(n);
      invalidateGutterLine(n);
    end;  

end;


function Tedit5.currentFile: AnsiString;
begin
  if pageCount>0
    then result:=CurrentEditor.FileName
    else result:='';
end;

procedure Tedit5.Primaryfile1Click(Sender: TObject);
begin
  if assigned(getPrimary) then stPrimary:=getPrimary;
end;

procedure Tedit5.Program1Click(Sender: TObject);
var
  st:AnsiString;
begin
  st:=extractFileName(stPrimary);
  delete(st,pos('.',st),20);
  Build1.Caption := 'Compile '+st;
  Build1.Enabled:=(stPrimary<>'');

  Build2.Caption := 'Build '+st;
  Build2.Enabled:=(stPrimary<>'');
end;


procedure Tedit5.Clear1Click(Sender: TObject);
begin
  if assigned(ClearPrimary) then
    begin
      clearPrimary;
      stPrimary:='';
    end;
end;

procedure Tedit5.EditorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ;  // 
end;

procedure Tedit5.EditorMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pp:Tpoint;
  st:string;
begin
  if button=mbRight then
    begin
      HideEditHint;
      pp:=currentEditor.ClientToScreen(classes.point(x,y));
      Rpopup.Popup(pp.x,pp.y);
    end
  else
  if assigned(HintPg) and (ssCtrl in Shift) then
  begin
     st:=HintPg(CurrentEditor.WordAtCursor);
     pp:=currentEditor.ClientToScreen(classes.point(x,y));

     if st<>'' then showEditHint(pp.X,pp.Y,st);
  end
  else HideEditHint;

  with TsynEditX(sender) do
  begin
    if ErrorLine>=0 then
    begin
      invalidateLine(ErrorLine);
      ErrorLine:=-1;
    end;
  end;
end;

procedure Tedit5.EditorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  HideStmHint;
end;


procedure Tedit5.Openfileatcursor1Click(Sender: TObject);
begin
  TraiterCtrlReturn;
end;

procedure Tedit5.Programreset1Click(Sender: TObject);
begin
  if Assigned(resetPg) then resetPg;
end;

procedure Tedit5.Lasterrormessage1Click(Sender: TObject);
begin
  if assigned(DisplayErrors) then DisplayErrors;

end;

procedure Tedit5.Print1Click(Sender: TObject);
var
  f: TextFile;
  i:integer;
begin
  AssignPrn(f);
  Rewrite(f);

  printer.canvas.Font.Assign(PrintFont);

  with CurrentEditor do
  begin
    for i:=1 to Lines.Count do
      Writeln(f,lines[i-1]);
  end;

  CloseFile(f);


end;

procedure Tedit5.Printsetup1Click(Sender: TObject);
begin
  PrinterSetupDialog1.execute;
end;

procedure Tedit5.Setasprimaryfile1Click(Sender: TObject);
var
  stf:AnsiString;
begin
  stF:=currentEditor.fileName;
  if assigned(setPrimary) and assigned(getPrimary)
     and (stF<>'NONAME.PG2') then
    begin
      if primarySplitted then Splitprimaryfile1Click(nil);

      setPrimary(stF);
      stPrimary:=stF;
    end;
end;

procedure Tedit5.Font2Click(Sender: TObject);
begin
  FontDialog1.Font.Assign(PrintFont);
  if FontDialog1.Execute then
  begin
    PrintFont.assign(FontDialog1.Font);
  end;
end;

procedure Tedit5.CompiledFiles1Click(Sender: TObject);
begin
  if assigned(CompHistory) then CompHistory;
end;


procedure Tedit5.PageControl1Change(Sender: TObject);
begin
  Caption:=Caption0;
  if pageCount>0
    then caption:=caption+': '+ getCaption(currentEditor)+StoppedString;
end;

procedure Tedit5.ModifyCaption(st:string);
begin
  StoppedString:=st;
  PageControl1Change(self);
end;

procedure Tedit5.Splitprimaryfile1Click(Sender: TObject);
var
  i:integer;
begin
  if stPrimary='' then exit;
  savePrimaryFile;

  Splitprimaryfile1.Checked:=not Splitprimaryfile1.Checked;


  if Splitprimaryfile1.checked then
  begin
    for i:=pageCount-1 downto 0 do
      if Editor[i].fileName=stPrimary then
      begin
        if editor[i].SearchReplace('$EDIT','',[ssoEntireScope,ssoWholeWord] )=0 then
        begin
          Splitprimaryfile1.checked:=false;
          exit;
        end;

        editor[i].SaveToFile(stPrimary);
        Editor[i].free;
        pageControl1.Pages[i].free;
        if (i>0) and (pageControl1.activePageIndex=i)
          then pageControl1.activePageIndex:=i-1;
        PageControl1Change(nil);
        break;
      end;

    LoadSplitPrimary;
  end
  else
  begin
    pageControl1.visible:=false;
    for i:=pageCount-1 downto 0 do
      if (Editor[i].fileName<>'') and (Editor[i].fileName[1]='}') then
      begin
        Editor[i].free;
        pageControl1.Pages[i].free;
        if (i>0) and (pageControl1.activePageIndex=i)
          then pageControl1.activePageIndex:=i-1;
        PageControl1Change(nil);
      end;
    pageControl1.visible:=true;
    installFile(stPrimary,false);
  end;

end;

procedure Tedit5.LoadSplitPrimary;
var
  f:textFile;
  st:AnsiString;
  cnt:integer;
  Fedit:boolean;
begin
  pageControl1.visible:=false;
  cnt:=0;
  assignFile(f,stPrimary);
  try
  reset(f);
  while not eof(f) do
  begin
    readln(f,st);

    inc(cnt);
    Fedit:=(Fmaj(copy(st,1,6))='{$EDIT');
    if (cnt=1) or Fedit then
    begin
      if currentEditor<>nil then currentEditor.Update;
      newPage;
      if Fedit then
      begin
        delete(st,1,6);
        currentEditor.fileName:='}'+st;
      end
      else currentEditor.fileName:='}'+'Main';
      pageControl1.activepage.ImageIndex:=0;
      pageControl1.activepage.caption:=getCaption(currentEditor);
    end;
    if not Fedit then
    begin
      currentEditor.Lines.Add(st);
    end;
  end;
  closeFile(f);
  except
  closeFile(f);
  end;

  pageControl1.visible:=true;
  currentEditor.update;
end;

procedure Tedit5.savePrimaryFile;
var
  i,j,cnt:integer;
  len:word;
  f:textFile;
  st:AnsiString;
  numLine:integer;
begin
  if not PrimarySplitted then
  begin
    for i:=0 to pageCount-1 do
      if Editor[i].fileName=stPrimary then
      begin
        editor[i].SaveToFile(stPrimary);
        Editor[i].Modified:=false;
      end;
  end
  else
  begin
    cnt:=0;
    numLine:=0;
    try
    for i:=0 to pageCount-1 do
      with Editor[i] do
      if (fileName<>'') and (fileName[1]='}') then
      begin
        inc(cnt);
        setLength(PnumLine,cnt);
        PnumLine[cnt-1].line:=numLine;
        PnumLine[cnt-1].st:=fileName;

        if cnt=1 then
        begin
          assignFile(f,stPrimary);
          rewrite(f);
        end;

        st:=fileName;
        delete(st,1,1);
        Writeln(f,'{$EDIT'+st);
        inc(numLine);
        for j:=1 to Lines.Count do
        begin
          Writeln(f,Lines[j-1]);
          inc(numLine);
        end;

        modified:=false;
      end;
    closeFile(f);
    except
    closeFile(f);
    end;
  end;
  {L'ordre des fichiers est correct parce qu'on ne peut pas changer la position des pages }

end;

function Tedit5.PrimarySplitted: boolean;
begin
  result:=Splitprimaryfile1.checked;
end;

procedure Tedit5.SynEdit1ReplaceText(Sender: TObject; const ASearch,
  AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
var
  APos: TPoint;
  EditRect: TRect;
  ed:TsynEdit;
begin
  ed:=currentEditor;
  if ASearch = AReplace then Action := raSkip
  else
  begin
    APos := ed.ClientToScreen(ed.RowColumnToPixels(ed.BufferToDisplayPos(BufferCoord(Column, Line) ) ) );
    EditRect := ClientRect;
    EditRect.TopLeft := ClientToScreen(EditRect.TopLeft);
    EditRect.BottomRight := ClientToScreen(EditRect.BottomRight);

    ConfirmReplaceDialog.PrepareShow(EditRect, APos.X, APos.Y, APos.Y + ed.LineHeight, ASearch);
    case ConfirmReplaceDialog.ShowModal of
      mrYes: Action := raReplace;
      mrYesToAll: Action := raReplaceAll;
      mrNo: Action := raSkip;
      else Action := raCancel;
    end;
  end;
end;


procedure Tedit5.Colors1Click(Sender: TObject);
var
  i:integer;
begin
  if GetEditorColors.execute(self) then setHighLighterColors;
end;

procedure Tedit5.setHighLighterColors;
begin
  with SynElphySyn1.CommentAttribute do
  begin
    Foreground:=DefEdColors[1];
    Background:=DefEdBKColors[1];
    Style:=[];
    if DefEdBold[1] then style:=style+[fsBold];
    if DefEdItalic[1] then style:=style+[fsItalic];
    if DefEdUnderScore[1] then style:=style+[fsUnderline];
  end;

  with SynElphySyn1.KeywordAttribute do
  begin
    Foreground:=DefEdColors[2];
    Background:=DefEdBKColors[2];
    Style:=[];
    if DefEdBold[2] then style:=style+[fsBold];
    if DefEdItalic[2] then style:=style+[fsItalic];
    if DefEdUnderScore[2] then style:=style+[fsUnderline];
  end;

  with SynElphySyn1.StringAttribute do
  begin
    Foreground:=DefEdColors[3];
    Background:=DefEdBKColors[3];
    Style:=[];
    if DefEdBold[3] then style:=style+[fsBold];
    if DefEdItalic[3] then style:=style+[fsItalic];
    if DefEdUnderScore[3] then style:=style+[fsUnderline];
  end;

  with SynElphySyn1.NumberAttri do
  begin
    Foreground:=DefEdColors[4];
    Background:=DefEdBKColors[4];
    Style:=[];
    if DefEdBold[4] then style:=style+[fsBold];
    if DefEdItalic[4] then style:=style+[fsItalic];
    if DefEdUnderScore[4] then style:=style+[fsUnderline];
  end;

  with SynElphySyn1.FloatAttri do
  begin
    Foreground:=DefEdColors[4];
    Background:=DefEdBKColors[4];
    Style:=[];
    if DefEdBold[4] then style:=style+[fsBold];
    if DefEdItalic[4] then style:=style+[fsItalic];
    if DefEdUnderScore[4] then style:=style+[fsUnderline];
  end;

  with SynElphySyn1.HexAttri do
  begin
    Foreground:=DefEdColors[4];
    Background:=DefEdBKColors[4];
    Style:=[];
    if DefEdBold[4] then style:=style+[fsBold];
    if DefEdItalic[4] then style:=style+[fsItalic];
    if DefEdUnderScore[4] then style:=style+[fsUnderline];
  end;


  with SynElphySyn1.DirectiveAttri do
  begin
    Foreground:=DefEdColors[5];
    Background:=DefEdBKColors[5];
    Style:=[];
    if DefEdBold[5] then style:=style+[fsBold];
    if DefEdItalic[5] then style:=style+[fsItalic];
    if DefEdUnderScore[5] then style:=style+[fsUnderline];
  end;

  with SynElphySyn1.IdentifierAttri do
  begin
    Foreground:=DefEdColors[6];
    Background:=DefEdBKColors[6];

    Style:=[];
    if DefEdBold[6] then style:=style+[fsBold];
    if DefEdItalic[6] then style:=style+[fsItalic];
    if DefEdUnderScore[6] then style:=style+[fsUnderline];
  end;

  with SynElphySyn1.SymbolAttri do
  begin
    Foreground:=DefEdColors[7];
    Background:=DefEdBKColors[7];

    Style:=[];
    if DefEdBold[7] then style:=style+[fsBold];
    if DefEdItalic[7] then style:=style+[fsItalic];
    if DefEdUnderScore[7] then style:=style+[fsUnderline];
  end;

  with SynElphySyn1.SpaceAttri do
  begin
    Foreground:=DefEdColors[8];
    Background:=DefEdBKColors[8];

    Style:=[];
    if DefEdBold[8] then style:=style+[fsBold];
    if DefEdItalic[8] then style:=style+[fsItalic];
    if DefEdUnderScore[8] then style:=style+[fsUnderline];
  end;

end;


procedure Tedit5.SpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: Graphics.TColor);
{ Confusion sur Tcolor si on laisse la déclaration
}
var
  Fbreak: boolean;
begin
  with TsynEditX(sender) do
  begin
    Fbreak:= plug.BreakPoints.IndexOf(pointer(line))>=0;
    Special:=(line=ErrorLine) or (line=StepLine) or Fbreak;

    if (line=ErrorLine) then
    begin
      FG:=ErrorColor;
      BG:=ErrorBKcolor;
    end
    else
    if (line=StepLine) then
    begin
      FG:=StepColor;
      BG:=StepBKcolor;
    end
    else
    if Fbreak then
    begin
      FG:= BreakPointColor;
      BG:= BreakPointBKColor;
    end;


  end;
end;

procedure Tedit5.EditorChange(Sender: TObject);
begin
  with TsynEditX(sender) do
  begin
    if ErrorLine>=0 then
    begin
      invalidateLine(ErrorLine);
      ErrorLine:=-1;
    end;
  end;
  HideEditHint;
end;

procedure Tedit5.EditorExit(Sender: TObject);
begin
  HideEditHint;
end;

procedure Tedit5.EditorScroll(Sender: TObject; ScrollBar: TScrollBarKind);
begin
  HideEditHint;
end;

procedure Tedit5.adpMRU1Click(Sender: TObject;  {$IF CompilerVersion >=22} const ItemText: AnsiString{$ELSE} const ItemText: String {$IFEND} );
begin
  if (ItemText='') then exit;

  if not FileExists(itemText) then
  begin
    messageCentral('Unable to load '+itemText);
    exit;
  end;

  if not selectPage(itemText) then
    begin
      currentEditor.LoadFromFile(itemText);
      pageControl1.activepage.caption:=getCaption(currentEditor);
      PageControl1Change(nil);
      lastFile:=itemText;
    end;
end;

procedure Tedit5.ShowCommands1Click(Sender: TObject);
begin
  if assigned(ShowCommandPg) then ShowCommandPg;
end;


procedure Tedit5.Debug1Click(Sender: TObject);
begin
  ToggleDebugMode;
end;

procedure Tedit5.StepOver1Click(Sender: TObject);
begin
  if assigned(StepOver) then StepOver;
end;

procedure Tedit5.TraceInto1Click(Sender: TObject);
begin
  if assigned(TraceInto) then TraceInto;
end;

procedure Tedit5.StopDebug1Click(Sender: TObject);
begin
  if assigned(StopDebugPg) then StopDebugPg;
end;


procedure Tedit5.AddBreakPoint1Click(Sender: TObject);
begin
  if CurrentEditor=nil then exit;

  with CurrentEditor do
  begin
    plug.ToggleBreakPoint(caretY);
    invalidateLine(caretY);
    InvalidateGutterLine(caretY);
  end;

  if assigned(AddBreakPoint) then AddBreakPoint;
end;

procedure Tedit5.ClearBreakPointlist1Click(Sender: TObject);
var
  i:integer;
begin
  if CurrentEditor=nil then exit;
  with CurrentEditor.plug.BreakPoints do
  begin
    for i:=0 to count-1 do
    begin
      CurrentEditor.invalidateLine(intG(items[i]));
      CurrentEditor.InvalidateGutterLine(intG(items[i]));
    end;
    clear;
  end;
  if assigned(ClearBreakPoint) then ClearBreakPoint;
end;

procedure Tedit5.SynEditorGutterClick(Sender: TObject; Button: TMouseButton;
                                   X, Y, Line: Integer; Mark: TSynEditMark);
var
  pp: Tpoint;
begin
  pp:=currentEditor.ClientToScreen(classes.point(x,y));
  if currentEditor.plug.HasBreakPoint(CurrentEditor.RowToLine(line))
    then AddBreakPoint2.Caption:='Clear BreakPoint'
    else AddBreakPoint2.Caption:='Add BreakPoint';
  GutterMenu.Popup(pp.x,pp.y);
end;

procedure Tedit5.ShowEditHint(x,y:integer;st:AnsiString);
var
  rr:Trect;
  h:integer;
begin
  if not assigned(hintW)
    then hintW:=ThintWindow.create(formStm);

  rr:=hintW.CalcHintRect(800,st,nil);
  h:=rr.Bottom-rr.top;
  rr:=rect(rr.Left+x,rr.Top+y-h,rr.Right+x,rr.Bottom+y-h);
  if rr.top<0 then
  begin
    rr.Bottom:=rr.Bottom-rr.top+10;
    rr.Top:=10;
  end;

  if rr.right>screen.DeskTopWidth then
  begin
    rr.left := rr.left-(rr.right-screen.DeskTopWidth)-10;
    rr.right:=screen.DeskTopWidth-10;
  end;

  hintW.activateHint(rr,st);
end;

procedure Tedit5.HideEditHint;
begin
  if assigned(HintW)
    then hintW.releaseHandle;
end;


procedure Tedit5.CheckEditorFiles;
var
  i:integer;
begin
  if ExitingElphy then exit;

  for i:=0 to PageCount-1 do
  with editor[i] do
  if fileExists(fileName) and  (dateF<>fileAge(fileName)) then
  begin
    if MessageDlg(ExtractfileName(fileName)+' has changed. Reload ?',mtConfirmation, [mbYes,mbNo],0)=mrYes
      then loadFromFile(fileName);
  end;
end;



{  TsynEditPlug }

procedure TsynEditPlug.AfterPaint(ACanvas: TCanvas; const AClip: TRect;FirstLine, LastLine: integer);
var
  LH, X, Y: integer;
  PolyArrow:array[0..6] of Tpoint;
  x1,y1:integer;
begin
  with TsynEditX(editor) do
  begin
    FirstLine := RowToLine(FirstLine);
    LastLine :=  RowToLine(LastLine);
    X := 14;
    LH := LineHeight;

    while FirstLine <= LastLine do
    begin
      Y := (LH - 10) div 2
           + LH * (LineToRow(FirstLine) - TopLine);

      if (Firstline=StepLine)  then
      with Acanvas do
      begin
        pen.Color:=clBlue;
        pen.Style:= psSolid;
        brush.Color:=clBlue;
        brush.Style:= bsSolid;

        x1:=X-6;
        y1:=Y+5;

        PolyArrow[0]:=point(X1,Y1-2);
        PolyArrow[1]:=point(X1+10,Y1-2);
        PolyArrow[2]:=point(X1+10,Y1-5);
        PolyArrow[3]:=point(X1+15,Y1);
        PolyArrow[4]:=point(X1+10,Y1+5);
        PolyArrow[5]:=point(X1+10,Y1+2);
        PolyArrow[6]:=point(X1,Y1+2);

        polygon(PolyArrow);
      end
      else
      if HasBreakPoint(FirstLine) then
      with Acanvas do
      begin
        pen.Color:=clRed;
        pen.Style:= psSolid;
        brush.Color:=clRed;
        brush.Style:= bsSolid;
        Ellipse(X,Y,X+10,Y+10);
      end;
      Inc(FirstLine);
    end;
  end;
end;

procedure TsynEditPlug.LinesInserted(FirstLine, Count: integer);
var
  i:integer;
begin
  for i:=0 to BreakPoints.Count-1 do
    if FirstLine<=intG(BreakPoints[i]) then BreakPoints[i]:= pointer(intG(BreakPoints[i]) + count);
end;

procedure TsynEditPlug.LinesDeleted(FirstLine, Count: integer);
var
  i:integer;
begin
  for i:=0 to BreakPoints.Count-1 do
    if (intG(BreakPoints[i])>=FirstLine) and (intG(BreakPoints[i])<FirstLine+count)  then BreakPoints[i]:=nil
    else
    if intG(BreakPoints[i])>=FirstLine+count then BreakPoints[i]:= pointer(intG(BreakPoints[i]) - count);

  BreakPoints.Pack;
end;

constructor TsynEditPlug.Create(AOwner: TSynEdit);
begin
  inherited create(TcustomSynEdit(Aowner));
  BreakPoints:= Tlist.create;
end;

destructor TsynEditPlug.Destroy;
begin
  BreakPoints.Free;
  inherited;
end;

procedure TsynEditPlug.ToggleBreakPoint(line: integer);
var
  n:integer;
begin
  with BreakPoints do
  begin
    n:= indexof(pointer(line));
    if n<0 then Add(pointer(line)) else delete(n);
  end;
end;

procedure TsynEditPlug.ClearBreakPoint;
var
  i:integer;
begin
  BreakPoints.Clear;
end;

function TsynEditPlug.HasBreakPoint(line:Integer):boolean;
begin
   result:= BreakPoints.IndexOf(pointer(line))>=0;
end;

procedure Tedit5.FormDeactivate(Sender: TObject);
begin
   HideEditHint;
   if assigned(setUserShortcuts) then setUserShortcuts(true);
end;

procedure Tedit5.FindDeclaration1Click(Sender: TObject);
begin
  if assigned(FindDecPg) then FindDecPg(CurrentEditor.WordAtCursor);
end;

procedure Tedit5.FormActivate(Sender: TObject);
begin
  if assigned(setUserShortcuts) then setUserShortcuts(false);
end;


procedure Tedit5.PageControl1MouseDown(Sender: TObject;  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  n: integer;
  stHint:string;
  p:Tpoint;
begin
  if (button=mbRight) then
  begin
    n:= pageControl1.IndexOfTabAt(X, Y);
    if (n>=0) then
    begin
      stHint:= Editor[n].fileName;
      p:=pageControl1.clientToScreen(point(x,y));
      ShowStmHint(p.x,p.y,stHint);
    end
    else HideStmHint;
  end;
end;

procedure Tedit5.PageControl1Exit(Sender: TObject);
begin
  HideStmHint;
end;

procedure Tedit5.Directories1Click(Sender: TObject);
begin
  GetSearchPath.Execute(Pg2SearchPath);
end;

Initialization
AffDebug('Initialization Gedit5',0);

  {$IFDEF FPC}
  {$I Gedit5.lrs}
  {$ENDIF}
end.
