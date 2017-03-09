{-----------------------------------------------------------------------------
 Unit Name: frmFileExplorer
 Author:    Kiriakos Vlahos
 Purpose:   File Explorer Window
 History:
-----------------------------------------------------------------------------}


unit frmFileExplorer; 

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, JvComponent, JvDockControlForm, VirtualTrees,
  VirtualExplorerTree, VirtualShellUtilities,  Menus, frmIDEDockWin,
  ActnList, VirtualShellHistory,  TBX, TB2Item, TB2Dock,
  TB2Toolbar, JvComponentBase;
                                                      
const
  WM_EXPLOREHERE = WM_USER + 1000;
                                                                      
type         
  TFileExplorerWindow = class(TIDEDockWindow)
    FileExplorerTree: TVirtualExplorerTree;
    VirtualShellHistory: TVirtualShellHistory;
    FileExplorerActions: TActionList;
    actGoForward: TAction;
    actGoBack: TAction;
    actGoUp: TAction;
    actRefresh: TAction;
    actEnableFilter: TAction;
    ExplorerDock: TTBXDock;
    ExplorerToolbar: TTBXToolbar;
    TBXItem3: TTBXItem;
    TBXItem5: TTBXItem;
    TBXSubmenuItem1: TTBXSubmenuItem;
    TBXItem6: TTBXItem;
    TBXItemBack: TTBXSubmenuItem;
    TBXItemForward: TTBXSubmenuItem;
    TBXSeparatorItem1: TTBXSeparatorItem;
    ExplorerPopUp: TTBXPopupMenu;
    Back1: TTBXItem;
    About1: TTBXItem;
    Up1: TTBXItem;
    N1: TTBXSeparatorItem;
    BrowsePath: TTBXSubmenuItem;
    Desktop: TTBXItem;
    MyComputer: TTBXItem;
    MyDocuments: TTBXItem;
    CurrentDirectory: TTBXItem;
    PythonPath1: TTBXItem;
    N2: TTBXSeparatorItem;
    EnableFilter: TTBXItem;
    ChangeFilter: TTBXItem;
    N3: TTBXSeparatorItem;
    Refresh1: TTBXItem;
    TBXPythonPath: TTBXSubmenuItem;
    ShellContextPopUp: TPopupMenu;
    TBSubmenuItem1: TTBXSubmenuItem;
    ExploreHere: TMenuItem;
    actSearchPath: TAction;
    SearchPath1: TMenuItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    TBXItem1: TTBXItem;
    ActiveScript: TTBXItem;
    actExploreHere: TAction;
    actManageFavourites: TAction;
    actAddToFavourites: TAction;
    TBXSeparatorItem3: TTBXSeparatorItem;
    mnFavourites: TTBXSubmenuItem;
    TBXItem2: TTBXItem;
    TBXItem7: TTBXItem;
    TBXSeparatorItem5: TTBXSeparatorItem;
    N4: TMenuItem;
    AddToFavourites1: TMenuItem;
    TBXSeparatorItem6: TTBXSeparatorItem;
    TBXSubmenuItem2: TTBXSubmenuItem;
    TBXSubmenuItem3: TTBXSubmenuItem;
    actNewFolder: TAction;
    TBXSeparatorItem4: TTBXSeparatorItem;
    TBXItem8: TTBXItem;
    N5: TMenuItem;
    CreateNewFolder1: TMenuItem;
    TBXItem10: TTBXItem;
    procedure VirtualShellHistoryChange(Sender: TBaseVirtualShellPersistent;
      ItemIndex: Integer; ChangeType: TVSHChangeType);
    procedure FileExplorerTreeKeyPress(Sender: TObject; var Key: Char);
    procedure ActiveScriptClick(Sender: TObject);
    procedure FileExplorerTreeEnumFolder(
      Sender: TCustomVirtualExplorerTree; Namespace: TNamespace;
      var AllowAsChild: Boolean);
    procedure DesktopClick(Sender: TObject);
    procedure MyComputerClick(Sender: TObject);
    procedure MyDocumentsClick(Sender: TObject);
    procedure CurrentDirectoryClick(Sender: TObject);
    procedure ChangeFilterClick(Sender: TObject);
    procedure FileExplorerTreeDblClick(Sender: TObject);
    procedure ExploreHereClick(Sender: TObject);
    procedure actGoBackExecute(Sender: TObject);
    procedure FileExplorerActionsUpdate(Action: TBasicAction;
      var Handled: Boolean);
    procedure actGoForwardExecute(Sender: TObject);
    procedure actGoUpExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actEnableFilterExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TBXItemBackPopup(Sender: TTBCustomItem;
      FromLink: Boolean);
    procedure TBXItemForwardPopup(Sender: TTBCustomItem;
      FromLink: Boolean);
    procedure BrowsePathPopup(Sender: TTBCustomItem; FromLink: Boolean);
    procedure actSearchPathExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actManageFavouritesExecute(Sender: TObject);
    procedure actAddToFavouritesExecute(Sender: TObject);
    procedure mnFavouritesPopup(Sender: TTBCustomItem; FromLink: Boolean);
    procedure actNewFolderExecute(Sender: TObject);
  private
    fFavourites: TStringList;
    { Private declarations }
    procedure PathItemClick(Sender: TObject);
    procedure WMExploreHere(var Message: TMessage); message WM_EXPLOREHERE;
    function GetExplorerPath: string;
    procedure SetExplorerPath(const Value: string);
  public
    { Public declarations }
    procedure UpdateWindow;
    property Favourites : TStringList read fFavourites;
    property ExplorerPath : string read GetExplorerPath write SetExplorerPath;
  end;

var
  FileExplorerWindow: TFileExplorerWindow;

implementation

uses frmPyIDEMain, uEditAppIntfs, dmCommands, VarPyth, SHlObj,
  cFindInFiles, frmFindResults, VirtualPIDLTools, JvDockGlobals,
  dlgDirectoryList, StringResources, VirtualWideStrings;

{$R *.dfm}

procedure TFileExplorerWindow.UpdateWindow;
begin
end;

procedure TFileExplorerWindow.FileExplorerTreeEnumFolder(
  Sender: TCustomVirtualExplorerTree; Namespace: TNamespace;
  var AllowAsChild: Boolean);
Var
  FileExt: WideString;
Begin
  FileExt := UpperCase(ExtractFileExt(Namespace.NameParseAddress));
  if not Namespace.Folder  { Don't filter folders }
    and actEnableFilter.Checked
    and (Pos(FileExt, UpperCase(CommandsDataModule.PyIDEOptions.FileExplorerFilter)) = 0) then
      AllowAsChild := False
   else
      AllowAsChild := True;
end;

procedure TFileExplorerWindow.DesktopClick(Sender: TObject);
begin
  FileExplorerTree.RootFolder := rfDeskTop;
end;

procedure TFileExplorerWindow.MyComputerClick(Sender: TObject);
begin
  FileExplorerTree.RootFolder := rfDrives;
end;

procedure TFileExplorerWindow.MyDocumentsClick(Sender: TObject);
begin
  FileExplorerTree.RootFolder := rfPersonal;
end;

procedure TFileExplorerWindow.CurrentDirectoryClick(Sender: TObject);
begin
  FileExplorerTree.RootFolderCustomPath := GetCurrentDir;
end;

procedure TFileExplorerWindow.ActiveScriptClick(Sender: TObject);
var
  Editor : IEditor;
  FileName : string;
begin
  Editor := PyIDEMainForm.GetActiveEditor;
  if Assigned(Editor) then begin
    FileName := Editor.FileName;
    if FileName <> '' then
      FileExplorerTree.RootFolderCustomPath := ExtractFileDir(FileName);
  end;
end;

procedure TFileExplorerWindow.ChangeFilterClick(Sender: TObject);
begin
  CommandsDataModule.PyIDEOptions.FileExplorerFilter :=
    InputBox('File Explorer Filter', 'Enter Filter:',
    CommandsDataModule.PyIDEOptions.FileExplorerFilter);
  FileExplorerTree.RefreshTree;
end;

procedure TFileExplorerWindow.PathItemClick(Sender: TObject);
begin
  if Sender is TTBCustomItem then
    FileExplorerTree.RootFolderCustomPath := TTBCustomItem(Sender).Caption;
end;

procedure TFileExplorerWindow.FileExplorerTreeDblClick(Sender: TObject);
Var
  NameSpace : TNameSpace;
  NameSpaceArray : TNameSpaceArray;
begin
  NameSpaceArray := FileExplorerTree.SelectedToNamespaceArray;
  if Length(NameSpaceArray) > 0 then begin
    NameSpace := NameSpaceArray[Low(NameSpaceArray)];
    if not NameSpace.Folder and NameSpace.FileSystem  then
      PyIDEMainForm.DoOpenFile(NameSpace.NameForParsing);
  end;
end;

procedure TFileExplorerWindow.ExploreHereClick(Sender: TObject);
Var
  NameSpaceArray : TNameSpaceArray;
begin
  NameSpaceArray := FileExplorerTree.SelectedToNamespaceArray;
  if (Length(NameSpaceArray) > 0) and
    NameSpaceArray[Low(NameSpaceArray)].Folder
  then begin
    PostMessage(Handle, WM_EXPLOREHERE, 0,
      Integer(NameSpaceArray[Low(NameSpaceArray)].AbsolutePIDL));
  end;
end;

procedure TFileExplorerWindow.actSearchPathExecute(Sender: TObject);
Var
  NameSpaceArray : TNameSpaceArray;
begin
  NameSpaceArray := FileExplorerTree.SelectedToNamespaceArray;
  if (Length(NameSpaceArray) > 0) and
    NameSpaceArray[Low(NameSpaceArray)].Folder
  then begin
    AddMRUString(NameSpaceArray[Low(NameSpaceArray)].NameForParsing,
       FindInFilesExpert.DirList, True);
    FindInFilesExpert.GrepSearch := 2;  //Directory
    if Assigned(FindResultsWindow) then
      FindResultsWindow.Execute(False)
  end;
end;

procedure TFileExplorerWindow.WMExploreHere(var Message: TMessage);
Var
  PIDL: PItemIDList;
begin
  PIDL := PItemIDList(Message.LParam);
  if Assigned(PIDL) then begin
    FileExplorerTree.RootFolderCustomPIDL := PIDL;
    //VirtualShellHistory.Clear;
  end;
end;

function TFileExplorerWindow.GetExplorerPath: string;
begin
  With FileExplorerTree.RootFolderNamespace do
  if IsDesktop or IsMyComputer or not FileSystem then
    Result := ''
  else
    Result := NameForParsing;
end;

procedure TFileExplorerWindow.mnFavouritesPopup(Sender: TTBCustomItem;
  FromLink: Boolean);
var
  i : integer;
  Item : TTBXItem;
begin
  while mnFavourites.Count > 3 do
    mnFavourites.Items[0].Free;
  if fFavourites.Count = 0 then begin
    Item := TTBXItem.Create(mnFavourites);
    Item.Caption := SEmptyList;
    mnFavourites.Insert(0, Item);
  end else
    for i := 0 to fFavourites.Count - 1  do begin
      Item := TTBXItem.Create(mnFavourites);
      Item.Caption := fFavourites[i];
      Item.OnClick := PathItemClick;
      mnFavourites.Insert(0, Item);
    end;
end;

procedure TFileExplorerWindow.SetExplorerPath(const Value: string);
begin
  try
    FileExplorerTree.RootFolderCustomPath := Value;
  except
    FileExplorerTree.RootFolder := rfDrives;
  end;
  //VirtualShellHistory.Clear;
end;

procedure TFileExplorerWindow.actGoBackExecute(Sender: TObject);
begin
  VirtualShellHistory.Back;
end;

procedure TFileExplorerWindow.actGoForwardExecute(Sender: TObject);
begin
  VirtualShellHistory.Next;
end;

procedure TFileExplorerWindow.actGoUpExecute(Sender: TObject);
Var
  PIDL: PItemIDList;
begin
  if FileExplorerTree.RootFolderNamespace.IsDesktop then Exit;  // No parent!

  PIDL := PIDLMgr.CopyPIDL(FileExplorerTree.RootFolderNamespace.AbsolutePIDL);
  try
    PIDLMgr.StripLastID(PIDL);
    FileExplorerTree.RootFolderCustomPIDL := PIDL;
  finally
    PIDLMgr.FreePIDL(PIDL);
  end;
end;

procedure TFileExplorerWindow.actAddToFavouritesExecute(Sender: TObject);
Var
  NameSpaceArray : TNameSpaceArray;
  Path : string;
begin
  NameSpaceArray := FileExplorerTree.SelectedToNamespaceArray;
  if (Length(NameSpaceArray) > 0) and
    NameSpaceArray[Low(NameSpaceArray)].Folder
  then begin
    Path := NameSpaceArray[Low(NameSpaceArray)].NameForParsing;
    if fFavourites.IndexOf(Path) < 0 then begin
      fFavourites.Add(Path);
      // Todo update Favourites Menu
    end;
  end;
end;

procedure TFileExplorerWindow.actEnableFilterExecute(Sender: TObject);
begin
  FileExplorerTree.RefreshTree;
end;

procedure TFileExplorerWindow.actManageFavouritesExecute(Sender: TObject);
begin
  EditFolderList(fFavourites, 'File Explorer Favourites');
end;

procedure TFileExplorerWindow.actNewFolderExecute(Sender: TObject);
Var
  NameSpaceArray : TNameSpaceArray;
  Node : PVirtualNode;
  TargetPath : string;
begin
  NameSpaceArray := FileExplorerTree.SelectedToNamespaceArray;
  if (Length(NameSpaceArray) > 0) and
    NameSpaceArray[Low(NameSpaceArray)].Folder
  then begin
    TargetPath := NameSpaceArray[Low(NameSpaceArray)].NameForParsing +
      PathDelim + SNewFolder;
    TargetPath := UniqueDirName(TargetPath);
    CreateDirectory(PChar(TargetPath), nil);
    SHChangeNotify(SHCNE_MKDIR, SHCNF_PATH, PChar(TargetPath), nil);
    FileExplorerTree.RefreshNode(FileExplorerTree.GetFirstSelected);
    Node := FileExplorerTree.FindNode(TargetPath);
    if Assigned(Node) then begin
      FileExplorerTree.ClearSelection;
      FileExplorerTree.FocusedNode := Node;
      FileExplorerTree.EditNode(Node, -1);
    end;
  end;
end;

procedure TFileExplorerWindow.actRefreshExecute(Sender: TObject);
begin
  FileExplorerTree.RefreshTree(True);
end;

procedure TFileExplorerWindow.FileExplorerActionsUpdate(
  Action: TBasicAction; var Handled: Boolean);
Var
  NameSpaceArray : TNameSpaceArray;
begin
  NameSpaceArray := FileExplorerTree.SelectedToNamespaceArray;
  actSearchPath.Enabled :=  (Length(NameSpaceArray) > 0) and
    NameSpaceArray[Low(NameSpaceArray)].Folder;
  actAddToFavourites.Enabled := actSearchPath.Enabled;
  actNewFolder.Enabled := actSearchPath.Enabled;
  actExploreHere.Enabled := actSearchPath.Enabled;

  actGoBack.Enabled := VirtualShellHistory.ItemIndex > 0;
  actGoForward.Enabled := VirtualShellHistory.ItemIndex < VirtualShellHistory.Count-1;
end;

procedure TFileExplorerWindow.FormActivate(Sender: TObject);
begin
  inherited;
  if not HasFocus then begin
    FGPanelEnter(Self);
    PostMessage(FileExplorerTree.Handle, WM_SETFOCUS, 0, 0);
  end;
end;

procedure TFileExplorerWindow.FormCreate(Sender: TObject);
begin
  inherited;
  fFavourites := TStringList.Create;
  fFavourites.Duplicates := dupIgnore;
  fFavourites.Sorted := True;
end;

procedure TFileExplorerWindow.FormDestroy(Sender: TObject);
begin
  inherited;
  fFavourites.Free;
end;

procedure TFileExplorerWindow.TBXItemBackPopup(Sender: TTBCustomItem;
  FromLink: Boolean);
begin
  VirtualShellHistory.FillPopupMenu_TB2000(TBXItemBack, TTBXItem, fpdNewestToOldest);
end;

procedure TFileExplorerWindow.TBXItemForwardPopup(Sender: TTBCustomItem;
  FromLink: Boolean);
begin
  VirtualShellHistory.FillPopupMenu_TB2000(TBXItemForward, TTBXItem, fpdOldestToNewest);
end;

procedure TFileExplorerWindow.BrowsePathPopup(Sender: TTBCustomItem;
  FromLink: Boolean);
var
  i : integer;
  Item : TTBXItem;
begin
  TBXPythonPath.Clear;
  for i := 0 to Len(SysModule.path) - 1  do begin
    Item := TTBXItem.Create(TBXPythonPath);
    Item.Caption := SysModule.path.GetItem(i);
    Item.OnClick := PathItemClick;
    TBXPythonPath.Add(Item);
  end;
end;

procedure TFileExplorerWindow.FileExplorerTreeKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = Char(VK_Return) then
    FileExplorerTreeDblClick(Sender);
end;

procedure TFileExplorerWindow.VirtualShellHistoryChange(
  Sender: TBaseVirtualShellPersistent; ItemIndex: Integer;
  ChangeType: TVSHChangeType);
begin
  if not Assigned(VirtualShellHistory.VirtualExplorerTree) then exit;
  if ChangeType = hctSelected then begin
      if not ILIsParent(FileExplorerTree.RootFolderNamespace.AbsolutePIDL,
        VirtualShellHistory.Items[ItemIndex].AbsolutePIDL, False) then begin
         VirtualShellHistory.VirtualExplorerTree := nil;
         FileExplorerTree.RootFolderCustomPIDL :=
           VirtualShellHistory.Items[ItemIndex].AbsolutePIDL;
         VirtualShellHistory.VirtualExplorerTree := FileExplorerTree;
      end;
  end;
end;

end.

