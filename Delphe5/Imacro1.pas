unit Imacro1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,controls,sysutils,menus,
     util1,Gdos,varconf1,stmdef,stmObj,stmPg,Npopup, debug0;

const
  maxMacro=20;


type

  TmacroManager=
    class(typeUO)
      Files:TstringList;
      Titles:TstringList;
      pgs:Tlist;
      FileDates:array of integer;

      PgNames:array of TpopupPg;

      stF1:AnsiString; {utilisé par BuildInfo}
      stT1:AnsiString;
      stDir:AnsiString;

      numMacro:integer;
      MenuItemMacro:TmenuItem;

      constructor create;override;
      destructor destroy;override;

      class function STMClassName:AnsiString;override;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      procedure completeLoadInfo;override;
      procedure processMessage(id:integer;source:typeUO;p:pointer);override;

      procedure clear;
      procedure add(stFile,stTitle:AnsiString);
      function count:integer;
      procedure InstallMacros(MacFiles,MacTitles:Tstrings);

      procedure Menu;
      procedure ExecuteMacro(sender:Tobject);
      procedure ExecuteMacMenu(p:integer);

      procedure initPgNames;
      procedure installToolsMenu(menuItem:TmenuItem);

      function extractTitle(stf:AnsiString):AnsiString;
      procedure GetToolFiles(GenericName:AnsiString;files,titles:TstringList);
    end;


implementation

uses MacMan1;

constructor TmacroManager.create;
begin
  inherited;

  Files:=TstringList.create;
  Titles:=TstringList.create;
  pgs:=Tlist.create;
  NotPublished:=true;
  FsingleLoad:=true;
end;

destructor TmacroManager.destroy;
begin
  clear;

  Files.free;
  Titles.free;
  pgs.free;
  inherited;
end;

class function TmacroManager.STMClassName:AnsiString;
begin
  result:='MacroManager';
end;

procedure TmacroManager.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
var
  i:integer;
begin
  inherited;
  if not lecture then
  begin
    stF1:=Files.text;
    stT1:=Titles.Text;
  end;

  conf.SetStringConf('Files',stF1);
  conf.SetStringConf('Titles',stT1);
  conf.SetStringConf('stDir',stDir);
end;

procedure TmacroManager.completeLoadInfo;
var
  i:integer;
begin
  inherited;
  Files.Text:=stF1;
  Titles.Text:=stT1;
  if stDir='' then stDir:=AppDir+'ElphyTools';

  pgs.clear;
  for i:=0 to Files.count-1 do pgs.Add(nil);
  setLength(fileDates,Files.Count);
  initPgNames;
end;


procedure TmacroManager.processMessage(id:integer;source:typeUO;p:pointer);
begin
  case id of
    UOmsg_destroy:
      begin
      end;
  end;
end;

procedure TmacroManager.add(stFile,stTitle:AnsiString);
begin
  Files.Add(stFile);
  Titles.Add(stTitle);
  pgs.add(nil);
end;

procedure TmacroManager.Menu;
var
  i:integer;
begin
  MacroManagerDialog.execute(self);
end;

procedure TmacroManager.clear;
var
  i:integer;
begin
  Files.Clear;
  Titles.Clear;

  for i:=0 to pgs.Count-1 do TPG2(pgs[i]).Free;
  pgs.Clear;
end;


function TmacroManager.count: integer;
begin
  result:=Files.count;
end;


procedure TmacroManager.InstallMacros(MacFiles, MacTitles: Tstrings);
var
  i,k:integer;
  Files1,Titles1:TstringList;
  pgs1:Tlist;
  fileDates1:array of integer;

begin
  Files1:=TstringList.create;
  Files1.Assign(Files);
  Titles1:=TstringList.create;
  Titles1.Assign(Titles);
  pgs1:=Tlist.create;
  pgs1.Assign(pgs);

  setlength(fileDates1,Files.count);
  move(FileDates[0],FileDates1[0],sizeof(integer)*length(FileDates));

  setlength(fileDates,MacFiles.count);
  fillchar(fileDates[0],sizeof(integer)*length(FileDates),0);

  Files.clear;
  Titles.clear;
  pgs.clear;

  try

  for i:=0 to MacFiles.Count-1 do
  if Titles.IndexOf(MacTitles[i])<0 then
  begin
    Files.add(MacFiles[i]);             {On copie FileName et Title}
    Titles.add(MacTitles[i]);

    k:= Files1.IndexOf(MacFiles[i]);
    if k>=0 then                        {Si FileName existait déjà avec la même date}
    begin                               {on garde l'objet TPG2 }
      if fileDates1[k]=fileAge(Files[i]) then
      begin
        pgs.add(pgs1[k]);
        FileDates[i]:=FileDates1[k];
      end
      else
      begin
        pgs.Add(nil);                   {mais si la date est différente, on détruit l'objet}
        Tpg2(pgs1[k]).free;
      end;

      pgs1[k]:=nil;                     {on range nil dans la liste copiée}
    end
    else pgs.add(nil);
  end;
                                        {On détruit les objets qui restent}
  for i:=0 to pgs1.Count-1 do Tpg2(pgs1[i]).Free;

  finally
  Files1.Free;
  Titles1.free;
  pgs1.free;
  end;
end;

procedure TmacroManager.initPgNames;
var
  i:integer;
  ok:boolean;
begin
  for i:=0 to high(PgNames) do pgNames[i].Free;
  setLength(pgNames,Files.Count);

  for i:=0 to high(PgNames) do pgNames[i]:=TpopupPg.create(formStm);

  for i:=0 to Files.count-1 do
  begin
    if pgs[i]<>nil then pgNames[i].assign(Tpg2(pgs[i]).PlexProgram)
    else
    begin
      pgs[i]:=Tpg2.create;
      Tpg2(pgs[i]).Fsystem:=true;
      ok:= Tpg2(pgs[i]).loadPgNames(Files[i]);
      if not ok then ok:=Tpg2(pgs[i]).LoadAndInstallPrimary(Files[i]);
      if ok
        then pgNames[i].assign(Tpg2(pgs[i]).PlexProgram)
        else pgNames[i].clear;
      Tpg2(pgs[i]).free;
      pgs[i]:=nil;
    end;

    pgNames[i].executeD:=executeMacMenu;
  end;
end;

procedure TmacroManager.installToolsMenu(menuItem: TmenuItem);
var
  i:integer;
  m:TmenuItem;
begin
  initPgNames;

  for i:=0 to count-1 do
  begin
    m:=TmenuItem.create(menuItem);
    m.caption:=Titles[i];
    m.tag:=i;
    m.OnClick:=executeMacro;

    PgNames[i].buildMenu(m);

    menuItem.add(m);
  end;

end;

{ Appelé quand on clique sur le nom du Tool
}
procedure TmacroManager.executeMacro(sender:Tobject);
begin
  NumMacro:=TmenuItem(sender).tag;
  MenuItemMacro:=TmenuItem(sender);

end;

{ Appelé quand on clique sur une rubrique du menu
  NumMacro vient d'être affecté
}
procedure TmacroManager.ExecuteMacMenu(p: integer);
var
  OK,loadOK:boolean;
begin
  OK:=true;
  if not fichierExiste(Files[numMacro]) then
  begin
    messageCentral('Unable to find '+Files[numMacro]);
    exit;
  end;

  if pgs[numMacro]=nil then
  begin
    pgs[numMacro]:=Tpg2.create;
    Tpg2(pgs[numMacro]).ident:='Tool'+Istr(numMacro);
    Tpg2(pgs[numMacro]).Fsystem:=true;
    LoadOK:=Tpg2(pgs[numMacro]).LoadAndInstallPrimary(Files[numMacro]);
    fileDates[numMacro]:=FileAge(Files[numMacro]);
    OK:=LoadOK and (Tpg2(pgs[numMacro]).PlexProgram.IndexOfObject(pointer(p))>=0)
    { on considère que le pg est valide si p est une adresse valide }
  end
  else
  if fileDates[numMacro]<>FileAge(Files[numMacro]) then
  begin
    LoadOK:= Tpg2(pgs[numMacro]).LoadAndInstallPrimary(Files[numMacro]);
    fileDates[numMacro]:=FileAge(Files[numMacro]);
    OK:=false;
  end;

  if OK then Tpg2(pgs[numMacro]).MenuExecute(p)
  else
  if LoadOK then messageCentral('Tool Program has been reloaded')
  else messageCentral('Unable to load Tool Program');
end;

{ Read the first line of a text file
  if the line is a TOOL directive, the function returns the title.
}
function TmacroManager.extractTitle(stf:AnsiString):AnsiString;
var
  f:textFile;
  st:AnsiString;
begin
  result:='';

  if not fileExists(stf) then exit;

  try
  AssignFile(f,stf);
  reset(f);
  readln(f,st);
  close(f);

  st:=FSupespaceDebut(st);
  st:=FSupespaceFin(st);

  if Fmaj(copy(st,1,12))= '{$ELPHYTOOL ' then
  begin
    delete(st,1,12);
    if (length(st)>0) and (st[length(st)]='}') then
    begin
      delete(st,length(st),1);
      st:=FSupespaceFin(st);
      result:=st;
    end;
  end;

  except
  {$I-}close(f); {$I+}
  end;

end;

{ Lit tous les fichiers correspondant à GenericName (ex: 'AppData\*.PG2')
  et les range dans files et titles.
}
procedure TmacroManager.GetToolFiles(GenericName:AnsiString;files,titles:TstringList);
var
  sr:TsearchRec;
  stf,stTitle:AnsiString;
begin
  if FindFirst(GenericName, faArchive, sr) = 0 then
  begin
    repeat
      if (sr.Attr and faArchive) <> 0 then
      begin
        stTitle:=extractTitle(extractFilePath(genericName)+sr.Name);
        if stTitle<>'' then
        begin
          files.add(extractFilePath(genericName)+sr.Name);
          titles.add(stTitle);
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;



Initialization
AffDebug('Initialization Imacro1',0);

registerObject(TmacroManager,sys);

end.
