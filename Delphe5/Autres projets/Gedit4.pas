unit Gedit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, Printers,
  ovcbase, ovcEdit,  ovcmru, ovcConst, ovcData,

  util1,Gdos,DdosFich,
  Efind1, Ereplace,
  procac2,chooseTopic1,
  stmDef;


var
  stTxtHistory:string;

type
  TgetNumProcHlp=function (st:string):integer of object;

  TrecSplit=record
              line:integer;
              st:string[60];
            end;

type
  Tedit4 = class(TForm)
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
    Delete1: TMenuItem;
    Search1: TMenuItem;
    Find1: TMenuItem;
    FindNext1: TMenuItem;
    Replace1: TMenuItem;
    Options1: TMenuItem;
    Font1: TMenuItem;
    Program1: TMenuItem;
    Build1: TMenuItem;
    Execute1: TMenuItem;
    Evaluate1: TMenuItem;
    Info1: TMenuItem;
    Sizes1: TMenuItem;
    Code2: TMenuItem;
    Symbols2: TMenuItem;
    Adlist1: TMenuItem;
    Ulist1: TMenuItem;
    Help1: TMenuItem;
    Editorhelp1: TMenuItem;
    Programhelp1: TMenuItem;
    OvcController1: TOvcController;
    PageControl1: TPageControl;
    OvcMenuMRU1: TOvcMenuMRU;
    Saveall1: TMenuItem;
    Close1: TMenuItem;
    Closeall1: TMenuItem;
    Compile1: TMenuItem;
    Primaryfile1: TMenuItem;
    Choose1: TMenuItem;
    Clear1: TMenuItem;
    RPopup: TPopupMenu;
    Help2: TMenuItem;
    Open1: TMenuItem;
    Evaluate2: TMenuItem;
    Openfileatcursor1: TMenuItem;
    Programreset1: TMenuItem;
    PrinterSetupDialog1: TPrinterSetupDialog;
    Setasprimaryfile1: TMenuItem;
    Printsetup2: TMenuItem;
    Font2: TMenuItem;
    Print2: TMenuItem;
    Lasterrormessage1: TMenuItem;
    CompiledFiles1: TMenuItem;
    Build2: TMenuItem;
    Splitprimaryfile1: TMenuItem;
    procedure New1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure save1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Closeall1Click(Sender: TObject);
    procedure Saveall1Click(Sender: TObject);
    procedure OvcMenuMRU1Click(Sender: TObject; const ItemText: String;
      var Action: TOvcMRUClickAction);
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
    procedure Open1Click(Sender: TObject);
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
  private
    { Déclarations privées }

    AidePG:string;
    PnumLine:array of TrecSplit;


    function getCaption(editor:TovcTextFileEditor):string;
    function CurrentEditor:TovcTextFileEditor;
    function getEditor(num:integer):TovcTextFileEditor;

    function selectPage(stf:string):boolean;
    function QuestionSave(editor:TovcTextFileEditor):boolean;
    procedure savePage(page:TtabSheet);

    procedure TraiterCtrlReturn;
    procedure Editor1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Editor1ShowStatus(Sender: TObject; LineNum,ColNum: Integer);

    procedure setFileNames(st:string);
    function getFileNames:string;



    procedure EditorMouseDown(Sender: TObject; Button: TMouseButton;
                              Shift: TShiftState; X, Y: Integer);

    procedure NewPage;

    function PrimarySplitted:boolean;

  public
    { Déclarations publiques }
    caption0:string;
    LastFile:string;

    tabProc:TtabDefProc;
    compilerPg:procedure(source:string;var error,lig,col:integer;
                         var stFile:string;Fbuild:boolean) of object;

    onShowG:   procedure of object;
    onHideG:   procedure of object;

    CodePg:    procedure of object;
    SymbolePg: procedure of object;
    AdListPg,UlistPg: procedure of object;
    InfoPg:    procedure of object;
    executePg: procedure of object;
    EvalPg:    procedure(st:string) of object;
    resetPg:   procedure of object;

    stPrimary:string;
    getPrimary:function:string of object;
    setPrimary:procedure (st:string) of object;
    clearPrimary:procedure of object;
    CompHistory:procedure of object;

    motFind,MotReplace:string;
    FindHis,ReplaceHis:string;
    Fcase,Fword,Fglobal,Fforward,FentireScope,Fprompt:boolean;

    TheFont:Tfont;
    PrintFont:Tfont;

    stLastError:string;

    function installFile(st:string;Fbis:boolean):boolean;

    property Editor[num:integer]:TovcTextFileEditor read getEditor;

    procedure ForcerPosition(lig,col:integer;stFile:string);
    procedure ForcerLigne(stFile:string;lig:integer;go:boolean);
    procedure installHelp(p:TtabDefProc;stHlp:string);

    property FileNames:string read getFileNames write setFileNames;
    procedure ResetError;
    function pageCount:integer;
    function currentFile:string;

    procedure LoadSplitPrimary;
    procedure savePrimaryFile;
  end;

var
  edit4: Tedit4;

implementation

uses BrowserHlp1;

{$R *.dfm}

function Tedit4.getEditor(num:integer):TovcTextFileEditor;
begin
  if (num>=0) and (num<PageCount)
    then result:=TovcTextFileEditor(pageControl1.pages[num].components[0])
    else result:=nil;
end;

function Tedit4.CurrentEditor: TovcTextFileEditor;
begin
  if PageCount >0
    then result:=TovcTextFileEditor(pageControl1.activepage.components[0])
    else result:=nil;
end;

function Tedit4.getCaption(editor: TovcTextFileEditor): string;
var
  ext:string;
  st:string;
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

  ext:=extractFileExt(editor.fileName);
  if Fmaj(ext)='.PG2'
    then result:=nomDuFichier1(editor.fileName)
    else result:=nomDuFichier(editor.fileName);

  if result='' then result:='NoName';
end;

function Tedit4.pageCount:integer;
begin
  result:=pageControl1.PageCount;
end;

procedure Tedit4.NewPage;
var
  page:TtabSheet;
  editor:TovcTextFileEditor;
begin
  page:=TtabSheet.Create(pageControl1);
  page.ImageIndex:=-1;

  page.PageControl:=pageControl1;
  if pageCount>1
    then page.PageIndex:=pageControl1.activePageIndex+1;
  pageControl1.ActivePage:=page ;


  editor:=TovcTextFileEditor.create(page);
  with editor do
  begin
    parent:=page;
    Align:=AlClient;
    FixedFont.Name := TheFont.name;
    FixedFont.size:=TheFont.size;
    OnKeyDown:=Editor1KeyDown;
    OnShowStatus:=Editor1ShowStatus;
    OnMouseDown:=EditorMouseDown;
    AutoIndent:=true;
    UndoBufferSize:=32768;
    ScrollPastEnd:=true;
    Controller:=OvcController1;
    makeBackUp:=true;
    BackUpExt:='~PG2';
    tabType:=ttSmart;
    HideSelection:=false;
  end;
  page.Caption:=getCaption(editor);

end;

procedure Tedit4.New1Click(Sender: TObject);
begin
  newPage;
  SavePage(pageControl1.ActivePage);
end;

function Tedit4.selectPage(stf: string):boolean;
var
  i,k:integer;
begin
  result:=false;
  stF:=Fmaj(stF);
  with pageControl1 do
  for i:=0 to pageCount-1 do
    with TovcTextFileEditor(pages[i].components[0]) do
      if Fmaj(fileName)=stF then
        begin
          ActivepageIndex:=i;
          result:=true;
          break;
        end;

  if not result then NewPage;
end;

function Tedit4.installFile(st:string;Fbis:boolean):boolean;
begin
  result:= (st<>'') and fichierExiste(st);

  if result then
    if not Fbis
      then result:= not selectPage(st)
      else NewPage;

  if result then
    begin
      currentEditor.LoadFromFile(st);
      pageControl1.activepage.caption:=getCaption(currentEditor);
      lastFile:=st;
    end;
end;

procedure Tedit4.Load1Click(Sender: TObject);
var
  st:string;
begin
  st:=GchooseFile('Load a file',LastFile);
  if installFile(st,false) then
  begin
    OvcMenuMRU1.add(st);
    stTxtHistory:=OvcMenuMRU1.Items.Text;
    PageControl1Change(nil);
  end;
end;


procedure Tedit4.FormCreate(Sender: TObject);
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
end;

function Tedit4.QuestionSave(editor:TovcTextFileEditor):boolean;
var
  res:integer;
  st:string;
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
            if st<>'' then
              begin
                Editor.SaveToFile(st);
                Editor.FileName:=st;
              end;
          end;
        mrNo: result:=true;
      end;
    end;
end;


procedure Tedit4.Close1Click(Sender: TObject);
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

procedure Tedit4.Closeall1Click(Sender: TObject);
begin
  if primarySplitted then Splitprimaryfile1Click(nil);

  while (pageCount>0) and QuestionSave(currentEditor) do
    begin
      currentEditor.free;
      pageControl1.ActivePage.free;
      PageControl1Change(nil);
    end;
end;

procedure Tedit4.save1Click(Sender: TObject);
begin
  if (currentEditor.fileName<>'') and (CurrentEditor.fileName[1]='}') then
  begin
    savePrimaryFile;
    exit;
  end;

  if PageCount>0 then
  if nomDuFichier(CurrentEditor.fileName)='NONAME.PG2'
    then SaveAs1Click(Sender)
    else CurrentEditor.SaveToFile(CurrentEditor.fileName);
end;

procedure Tedit4.savePage(page:TtabSheet);
var
  st:string;
  res:integer;
  editor:TovcTextFileEditor;
begin
  if page=nil then exit;
  editor:=TovcTextFileEditor(page.components[0]);
  if (editor.fileName<>'') and (editor.fileName[1]='}') then exit;

  st:=GsaveFile('Save as',Editor.fileName,'PG2');
  if st<>'' then
    begin
      if fichierExiste(st) then
        begin
          res:= MessageDlg('File already exists. Overwrite?',
                mtConfirmation,[mbYes,mbNo],0);
          if res<>mrYes then exit;
        end;

      Editor.fileName:=st;
      Editor.SaveToFile(st);
      Page.Caption:=nomDuFichier1(st);
    end;
end;


procedure Tedit4.Saveas1Click(Sender: TObject);
begin
  if PageCount>0
    then SavePage(pageControl1.ActivePage);
end;




procedure Tedit4.Saveall1Click(Sender: TObject);
var
  i:integer;
begin
  if primarySplitted then savePrimaryFile;

  for i:=0 to PageCount-1 do
  begin
    if nomDuFichier(Editor[i].fileName)='NONAME.PG2' then
      SavePage(pageControl1.Pages[i])
    else
      with Editor[i] do
      begin
        if modified then SaveToFile(fileName);
      end;
  end;
end;


procedure Tedit4.OvcMenuMRU1Click(Sender: TObject; const ItemText: String;
  var Action: TOvcMRUClickAction);
begin
  if (itemText='') then exit;

  if not fichierExiste(itemText) then
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

procedure Tedit4.Editorhelp1Click(Sender: TObject);
begin
  Application.HelpFile:=trouverFichier('Gedit1.hlp','');
  Application.HelpCommand(Help_contents,0);
end;

procedure Tedit4.Programhelp1Click(Sender: TObject);
begin
  if not HTMLhelp then
  begin
    Application.HelpFile:=trouverFichier(AidePG,'');
    Application.HelpCommand(Help_contents,0);
  end
  else
  begin
    Hbrowser.show;
  end;
end;

procedure Tedit4.Help2Click(Sender: TObject);
var
  st:string;
  stList:TstringList;
  num:integer;
begin
  if not HTMLhelp then
  begin
    if not assigned(tabProc) or (aidePg='') then exit;

    st:=Currenteditor.getCurrentWord;

    num:=tabProc.getNumProcHlp(st);

    Application.HelpFile:=trouverFichier(AidePG,'');
    if num>0 then Application.HelpCommand(Help_context,num)
             else Application.HelpCommand(Help_contents,0);
  end
  else
  begin
    st:=Currenteditor.getCurrentWord;

    stList:=TstringList.create;
    if TabProc.getHTMLhlp(st,stList) then
    begin
      st:=ChooseTopic.execution(stList);
      stList.free;

      Hbrowser.showTopic(st);
    end
    else stList.free;
  end;
end;

procedure Tedit4.installHelp(p:TtabDefProc;stHlp:string);
begin
  { installHelp est appelé dans stmPG }

  aidePg:=stHlp;
  tabProc:=p;

end;

procedure Tedit4.ForcerPosition(lig,col:integer;stFile:string);
var
  i:integer;
begin
  if not fichierExiste(stFile) then
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

  if (lig<1) or (lig>currentEditor.LineCount) then lig:=1;
  if col<1 then col:=1;

  show;
  CurrentEditor.SetCaretPosition(lig,col);
  CurrentEditor.SetFocus ;
end;

procedure Tedit4.ForcerLigne(stFile:string;lig:integer;go:boolean);
var
  i:integer;
begin
  if not fichierExiste(stFile) then
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

  if (lig<1) or (lig>CurrentEditor.LineCount) then lig:=1;

  with CurrentEditor do
  begin
    SetCaretPosition(lig,1);
    setMarkerAt(0,lig,1);
    showBookMarks:=true;
  end;

  if go then show;
end;

procedure Tedit4.TraiterCtrlReturn;
var
  i,n:integer;
  st:string;
begin
  st:=CurrentEditor.getCurrentWord;
  if pos('.',st)<=0  then st:=st+'.pg2';
  if (pos(':',st)<=0) and (pos('\',st)<=0)
    then st:=extractFilePath(CurrentEditor.fileName)+st;

  if (st<>'') and fichierExiste(st) and not selectPage(st) then
    begin
      currentEditor.LoadFromFile(st);
      pageControl1.activepage.caption:=getCaption(currentEditor);
    end;

end;

procedure Tedit4.Editor1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_F1) and (shift=[ssCtrl]) then Help2Click(nil)
  else
  if (key=VK_return) and (shift=[ssCtrl]) then TraiterCtrlReturn;
end;

procedure Tedit4.Editor1ShowStatus(Sender: TObject; LineNum,
  ColNum: Integer);
begin
  StatusBar1.Panels[0].Text := IntToStr(LineNum) + ':' + IntToStr(ColNum);
  if CurrentEditor.Modified then
    StatusBar1.Panels[1].Text := 'Modified'
  else
    StatusBar1.Panels[1].Text := '';
  if CurrentEditor.InsertMode then
    StatusBar1.Panels[2].Text := 'Insert'
  else
    StatusBar1.Panels[2].Text := 'Overwrite';
end;



procedure Tedit4.Build1Click(Sender: TObject);
var
  error,lig,col:integer;
  stFile:string;
begin
  if not assigned(compilerPg) then exit;

  compilerPg(stPrimary,error,lig,col,stFile,false);
  if error>0 then forcerPosition(Lig,col,stFile)
  else
  if sender<>nil then messageCentral('Compile successfull');
end;

procedure Tedit4.Build2Click(Sender: TObject);
var
  error,lig,col:integer;
  stFile:string;
begin
  if not assigned(compilerPg) then exit;

  compilerPg(stPrimary,error,lig,col,stFile,true);
  if error>0 then forcerPosition(Lig,col,stFile)
  else
  if sender<>nil then messageCentral('Compile successfull');
end;

procedure Tedit4.Compile1Click(Sender: TObject);
var
  error,lig,col:integer;
  stFile:string;
begin
  if not assigned(compilerPg) or (currentFile='') then exit;

  compilerPg(currentFile,error,lig,col,stFile,false);
  if error>0 then forcerPosition(Lig,col,stFile)
  else

  if sender<>nil then messageCentral('Compile successfull');
end;


procedure Tedit4.Execute1Click(Sender: TObject);
begin
  if assigned(executePg) then executePg;
end;

procedure Tedit4.Evaluate1Click(Sender: TObject);
begin
  if assigned(EvalPg) then EvalPg(currentEditor.getCurrentWord);
end;

procedure Tedit4.Sizes1Click(Sender: TObject);
begin
  if assigned(InfoPg) then infoPg;
end;

procedure Tedit4.Code2Click(Sender: TObject);
begin
  if assigned(codePg) then CodePg;
end;

procedure Tedit4.Symbols2Click(Sender: TObject);
begin
  if assigned(SymbolePg) then SymbolePg;
end;

procedure Tedit4.Adlist1Click(Sender: TObject);
begin
  if assigned(AdlistPg) then AdlistPg;
end;

procedure Tedit4.Ulist1Click(Sender: TObject);
begin
  if assigned(UlistPg) then UlistPg;
end;

procedure Tedit4.Font1Click(Sender: TObject);
var
  i:integer;
begin
  FontDialog1.Font.Assign(TheFont);
  if FontDialog1.Execute then
  begin
    TheFont.assign(FontDialog1.Font);
    for i:=0 to pageCount-1 do
      Editor[i].FixedFont.Assign(FontDialog1.Font);
  end;
end;

procedure Tedit4.Undo1Click(Sender: TObject);
begin
  CurrentEditor.Undo;
end;

procedure Tedit4.Redo1Click(Sender: TObject);
begin
  CurrentEditor.Redo;
end;

procedure Tedit4.Copy1Click(Sender: TObject);
begin
  CurrentEditor.CopyToClipBoard;
end;

procedure Tedit4.Paste1Click(Sender: TObject);
begin
  CurrentEditor.PasteFromClipBoard;
end;

procedure Tedit4.Cut1Click(Sender: TObject);
begin
  CurrentEditor.CutToClipBoard;
end;

procedure Tedit4.Delete1Click(Sender: TObject);
begin
  CurrentEditor.ProcessCommand(ccDel, 0);
end;

procedure Tedit4.Find1Click(Sender: TObject);
var
  OptionSet : TSearchOptionSet;
begin
  MotFind:=GEditfind.execution(CurrentEditor.GetCurrentWord ,FindHis,
                          Fcase,Fword,Fglobal,Fforward,FentireScope);
  if motFind<>'' then
    begin
      OptionSet := [];
      if not Fforward then OptionSet := OptionSet + [soBackward];
      if FentireScope then OptionSet := OptionSet + [soGlobal];
      if Fcase then OptionSet := OptionSet + [soMatchCase];
      if Fword then OptionSet := OptionSet + [soWholeWord];
      if not Fglobal then OptionSet := OptionSet + [soSelText];

      if not CurrentEditor.Search(motFind, OptionSet) then
        MessageDlg('Search string ''' + motFind +
          ''' not found', mtInformation, [mbOk], 0);
  end;

  currentEditor.SetFocus;
end;

procedure Tedit4.FindNext1Click(Sender: TObject);
var
  OptionSet : TSearchOptionSet;
begin
  if motFind<>'' then
    begin
      OptionSet := [];
      if not Fforward then OptionSet := OptionSet + [soBackward];
      if Fcase then OptionSet := OptionSet + [soMatchCase];
      if Fword then OptionSet := OptionSet + [soWholeWord];
      if not Fglobal then OptionSet := OptionSet + [soSelText];

      if not CurrentEditor.Search(motFind, OptionSet) then
        MessageDlg('Search string ''' + motFind +
          ''' not found', mtInformation, [mbOk], 0);
  end;
  currentEditor.SetFocus;
end;


procedure Tedit4.Replace1Click(Sender: TObject);
var
  OptionSet : TSearchOptionSet;
  Count : LongInt;
  Code : Word;
  Aborted : boolean;
begin
  motFind:=CurrentEditor.GetCurrentWord;
  code:=GEditreplace.execution(motFind,FindHis,
                              MotReplace,ReplaceHis,
                              Fcase,Fword,Fglobal,Fforward,FentireScope,Fprompt);


  if (code=mrCancel) or (MotFind='') then exit;


  OptionSet := [];
  if not Fprompt
    then OptionSet := OptionSet + [soReplaceAll]
    else OptionSet := OptionSet + [soReplace];

  if not Fforward then OptionSet := OptionSet + [soBackward];
  if Fcase then OptionSet := OptionSet + [soMatchCase];
  if Fword then OptionSet := OptionSet + [soWholeWord];
  if not Fglobal then OptionSet := OptionSet + [soSelText];
  if FentireScope then OptionSet := OptionSet + [soGlobal];

  Count := CurrentEditor.Replace(motFind, motReplace, OptionSet);
  while (Count <> -1) and CurrentEditor.HasSelection do
  begin
    Code := MessageDlg('Replace this occurrence?',mtConfirmation,
                       [mbYes, mbNo, mbCancel], 0);
    if Code = mrYes then
      Count := CurrentEditor.Replace(motFind, motReplace, OptionSet);
    if Code = mrNo then
      begin
        OptionSet:=OptionSet-[soGlobal];
        CurrentEditor.Deselect(not (soBackward in OptionSet));
        Count := CurrentEditor.Replace(motFind, motReplace, OptionSet);
      end;
    if Code = mrCancel then
      begin
        Aborted := True;
        CurrentEditor.Deselect(not (soBackward in OptionSet));
        Count := -1;
      end;
  end;

  if (Count = -1) and not Aborted then
      MessageDlg('Search string ''' + motFind +''' not found', mtInformation, [mbOk], 0);

  currentEditor.SetFocus;
end;

procedure Tedit4.FormDestroy(Sender: TObject);
begin
  closeAll1Click(self);

  theFont.Free;
  PrintFont.Free;
end;


procedure Tedit4.setFileNames(st:string);
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
            editor[j].attach(editor[i]);
            mark[j]:=true;
          end;
      mark[i]:=true;
    end;
  end;

  list.free;

  PageControl1Change(nil);
end;

function Tedit4.getFileNames:string;
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

procedure Tedit4.ResetError;
var
  i:integer;
begin

  for i:=0 to pageCount-1 do
    editor[i].setMarkerAt(0,0,0);
  stLastError:='';

end;



function Tedit4.currentFile: string;
begin
  if pageCount>0
    then result:=CurrentEditor.FileName
    else result:='';
end;

procedure Tedit4.Primaryfile1Click(Sender: TObject);
begin
  if assigned(getPrimary) then stPrimary:=getPrimary;
end;

procedure Tedit4.Program1Click(Sender: TObject);
begin
  Build1.Caption := 'Compile '+nomDuFichier1(stPrimary);
  Build1.Enabled:=(stPrimary<>'');

  Build2.Caption := 'Build '+nomDuFichier1(stPrimary);
  Build2.Enabled:=(stPrimary<>'');
end;


procedure Tedit4.Clear1Click(Sender: TObject);
begin
  if assigned(ClearPrimary) then
    begin
      clearPrimary;
      stPrimary:='';
    end;
end;

procedure Tedit4.EditorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pp:Tpoint;
begin
  if ssRight in Shift then
    begin
      pp:=currentEditor.ClientToScreen(classes.point(x,y));
      Rpopup.Popup(pp.x,pp.y);
    end;
end;


procedure Tedit4.Open1Click(Sender: TObject);
var
  editor:TovcTextFileEditor;
begin
  if (currentEditor.fileName<>'') and (currentEditor.FileName[1]='}') then exit;
  editor:=currentEditor;

  NewPage;

  currentEditor.LoadFromFile(editor.fileName);
  CurrentEditor.Attach(editor);
  pageControl1.activepage.caption:=getCaption(currentEditor);

end;



procedure Tedit4.Openfileatcursor1Click(Sender: TObject);
begin
  TraiterCtrlReturn;
end;

procedure Tedit4.Programreset1Click(Sender: TObject);
begin
  if Assigned(resetPg) then resetPg;
end;

procedure Tedit4.Lasterrormessage1Click(Sender: TObject);
var
  stCap:string;
begin
  stCap:='Last error message';
  if stLastError<>'' then
    application.messageBox(@stLastError[1],@stCap[1],mb_IconInformation or mb_ok);
end;

procedure Tedit4.Print1Click(Sender: TObject);
var
  f: TextFile;
  i:integer;
begin
  AssignPrn(f);
  Rewrite(f);

  printer.canvas.Font.Assign(PrintFont);

  with CurrentEditor do
  begin
    for i:=1 to LineCount do
      Writeln(f,lines[i]);
  end;

  CloseFile(f);


end;

procedure Tedit4.Printsetup1Click(Sender: TObject);
begin
  PrinterSetupDialog1.execute;
end;

procedure Tedit4.Setasprimaryfile1Click(Sender: TObject);
var
  stf:string;
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

procedure Tedit4.Font2Click(Sender: TObject);
begin
  FontDialog1.Font.Assign(PrintFont);
  if FontDialog1.Execute then
  begin
    PrintFont.assign(FontDialog1.Font);
  end;
end;

procedure Tedit4.CompiledFiles1Click(Sender: TObject);
begin
  if assigned(CompHistory) then CompHistory;
end;


procedure Tedit4.PageControl1Change(Sender: TObject);
begin
  Caption:=Caption0;
  if pageCount>0
    then caption:=caption+': '+ getCaption(currentEditor);
end;

procedure Tedit4.Splitprimaryfile1Click(Sender: TObject);
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
        if not editor[i].Search('$EDIT',[soGlobal,soWholeWord] ) then
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

procedure Tedit4.LoadSplitPrimary;
var
  f:textFile;
  st:string;
  cnt:integer;
  Fedit:boolean;
begin
  pageControl1.visible:=false;
  cnt:=0;
  assignFile(f,stPrimary);
  GresetT(f);
  while not Geof(f) do
  begin
    GreadlnT(f,st);
    inc(cnt);
    Fedit:=(Fmaj(copy(st,1,6))='{$EDIT');
    if (cnt=1) or Fedit then
    begin
      if currentEditor<>nil then currentEditor.ResetScrollBars(True);
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
      st:=st+#0;
      currentEditor.AppendPara(@st[1]);
    end;
  end;
  GcloseT(f);
  pageControl1.visible:=true;
  currentEditor.ResetScrollBars(True);
end;

procedure Tedit4.savePrimaryFile;
var
  i,j,cnt:integer;
  len:word;
  f:textFile;
  st:string;
  numLine:integer;
begin
  if not PrimarySplitted then
  begin
    for i:=0 to pageCount-1 do
      if Editor[i].fileName=stPrimary then
        editor[i].SaveToFile(stPrimary);
  end
  else
  begin
    cnt:=0;
    numLine:=0;
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
          GrewriteT(f);
        end;

        st:=fileName;
        delete(st,1,1);
        GWritelnT(f,'{$EDIT'+st);
        inc(numLine);
        for j:=1 to ParaCount do
        begin
          GWritelnT(f,getPara(j,len));
          inc(numLine);
        end;

        modified:=false;
      end;
    GcloseT(f);
  end;
  {L'ordre des fichiers est correct parce qu'on ne peut pas changer la position des pages }

end;

function Tedit4.PrimarySplitted: boolean;
begin
  result:=Splitprimaryfile1.checked;
end;

end.
