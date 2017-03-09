{-----------------------------------------------------------------------------
 Unit Name: frmVariables
 Author:    Kiriakos Vlahos
 Date:      09-Mar-2005
 Purpose:   Variables Window
 History:
-----------------------------------------------------------------------------}

unit frmVariables;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, ImgList,
  JvDockControlForm, JvComponent, Menus, VTHeaderPopup,
  VirtualTrees, frmIDEDockWin, TBX, TBXThemes, JvExExtCtrls, JvNetscapeSplitter,
  JvExControls, JvLinkLabel, TBXDkPanels, JvComponentBase, cPyBaseDebugger;

type
  TVariablesWindow = class(TIDEDockWindow)
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    VariablesTree: TVirtualStringTree;
    Splitter: TJvNetscapeSplitter;
    TBXPageScroller: TTBXPageScroller;
    HTMLLabel: TJvLinkLabel;
    procedure VariablesTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure FormCreate(Sender: TObject);
    procedure VariablesTreeInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure VariablesTreeGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VariablesTreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure VariablesTreePaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
  private
    { Private declarations }
    CurrentFrame : TBaseFrameInfo;
    CurrentFileName, CurrentFunctionName : string;
    GlobalsNameSpace, LocalsNameSpace : TBaseNameSpaceItem;
  protected
    procedure TBMThemeChange(var Message: TMessage); message TBM_THEMECHANGE;
  public
    { Public declarations }
    procedure ClearAll;
    procedure UpdateWindow;
  end;

var
  VariablesWindow: TVariablesWindow = nil;

implementation

uses frmPyIDEMain, frmCallStack, PythonEngine, VarPyth,
  dmCommands, uCommonFunctions, JclFileUtils, StringResources, frmPythonII,
  JvDockGlobals, cPyDebugger;

{$R *.dfm}
Type
  PPyObjRec = ^TPyObjRec;
  TPyObjRec = record
    NameSpaceItem : TBaseNameSpaceItem;
  end;

procedure TVariablesWindow.FormCreate(Sender: TObject);
begin
  inherited;
  // Let the tree know how much data space we need.
  VariablesTree.NodeDataSize := SizeOf(TPyObjRec);
  VariablesTree.OnAdvancedHeaderDraw :=
    CommandsDataModule.VirtualStringTreeAdvancedHeaderDraw;
  VariablesTree.OnHeaderDrawQueryElements :=
    CommandsDataModule.VirtualStringTreeDrawQueryElements;
  HTMLLabel.Color := clWindow;
  TBXPageScroller.Color := clWindow;
end;

procedure TVariablesWindow.VariablesTreeInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  Data, ParentData: PPyObjRec;
begin
  Data := VariablesTree.GetNodeData(Node);
  if VariablesTree.GetNodeLevel(Node) = 0 then begin
    Assert(Node.Index <= 1);
    if Assigned(CurrentFrame) then begin
      if Node.Index = 0 then begin
        Assert(Assigned(GlobalsNameSpace));
        Data.NameSpaceItem := GlobalsNameSpace;
        InitialStates := [ivsHasChildren];
      end else if Node.Index = 1 then begin
        Assert(Assigned(LocalsNameSpace));
        Data.NameSpaceItem := LocalsNameSpace;
        InitialStates := [ivsExpanded, ivsHasChildren];
      end;
    end else begin
      Assert(Node.Index = 0);
      Assert(Assigned(GlobalsNameSpace));
      Data.NameSpaceItem := GlobalsNameSpace;
      InitialStates := [ivsExpanded, ivsHasChildren];
    end;
    VariablesTree.ChildCount[Node] := Data.NameSpaceItem.ChildCount;
  end else begin
    ParentData := VariablesTree.GetNodeData(ParentNode);
    Data.NameSpaceItem := ParentData.NameSpaceItem.ChildNode[Node.Index];
    VariablesTree.ChildCount[Node] := Data.NameSpaceItem.ChildCount;
    if Data.NameSpaceItem.ChildCount > 0 then
      InitialStates := [ivsHasChildren]
    else
      InitialStates := [];
  end;
end;

procedure TVariablesWindow.VariablesTreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data : PPyObjRec;
begin
  Data := VariablesTree.GetNodeData(Node);
  if Assigned(Data) then
    if nsaChanged in Data.NameSpaceItem.Attributes then
      TargetCanvas.Font.Color := clRed
    else if nsaNew in Data.NameSpaceItem.Attributes then
      TargetCanvas.Font.Color := clBlue;
end;

procedure TVariablesWindow.VariablesTreeGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data : PPyObjRec;
begin
  if (Column = 0) and (Kind in [ikNormal, ikSelected]) then begin
    Data := VariablesTree.GetNodeData(Node);
    with GetPythonEngine do begin
      if Data.NameSpaceItem.IsDict then begin
        if vsExpanded in Node.States then
          ImageIndex := 9
        else
          ImageIndex := 10;
      end else if Data.NameSpaceItem.IsModule then
        ImageIndex := 18
      else if Data.NameSpaceItem.IsMethod then
        ImageIndex := 11
      else if Data.NameSpaceItem.IsFunction then
        ImageIndex := 14
      else if Data.NameSpaceItem.Has__dict__ then begin
        if (Data.NameSpaceItem.ChildCount > 0) and
           (vsExpanded in Node.States)
        then
          ImageIndex := 12
        else
          ImageIndex := 13;
      end else
        ImageIndex := 1
    end
  end else
    ImageIndex := -1;
end;

procedure TVariablesWindow.VariablesTreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data : PPyObjRec;
begin
  Data := VariablesTree.GetNodeData(Node);
  CellText := '';
  case Column of
    0 : CellText := Data.NameSpaceItem.Name;
    1 : with GetPythonEngine do
          CellText := Data.NameSpaceItem.ObjectType;
    2 : begin
          try
            CellText := Data.NameSpaceItem.Value;
          except
            CellText := '';
          end;
        end;
  end;
end;

Type
   // to help us access protected methods
   TCrackedVirtualStringTree = class(TVirtualStringTree)
   end;

procedure TVariablesWindow.UpdateWindow;

  procedure ReinitNode(Node: PVirtualNode; Recursive: Boolean); forward;

  procedure ReinitChildren(Node: PVirtualNode; Recursive: Boolean);

  // Forces all child nodes of Node to be reinitialized.
  // If Recursive is True then also the grandchildren are reinitialized.
  // Modified version to reinitialize only when the node is already initialized

  var
    Run: PVirtualNode;

  begin
    if Assigned(Node) then
    begin
      TCrackedVirtualStringTree(VariablesTree).InitChildren(Node);
      Run := Node.FirstChild;
    end
    else
    begin
      TCrackedVirtualStringTree(VariablesTree).InitChildren(VariablesTree.RootNode);
      Run := VariablesTree.RootNode.FirstChild;
    end;

    while Assigned(Run) do
    begin
      if vsInitialized in Run.States then
        ReinitNode(Run, Recursive);
      Run := Run.NextSibling;
    end;
  end;

  //----------------------------------------------------------------------------------------------------------------------

  procedure ReinitNode(Node: PVirtualNode; Recursive: Boolean);

  // Forces the given node and all its children (if recursive is True) to be initialized again without
  // modifying any data in the nodes nor deleting children (unless the application requests a different amount).

  begin
    if Assigned(Node) and (Node <> VariablesTree.RootNode) then
    begin
      // Remove dynamic styles.
      Node.States := Node.States - [vsChecking, vsCutOrCopy, vsDeleting, vsHeightMeasured];
      TCrackedVirtualStringTree(VariablesTree).InitNode(Node);
    end;

    if Recursive then
      ReinitChildren(Node, True);
  end;

Var
  SameFrame : boolean;
  RootNodeCount : Cardinal;
  OldGlobalsNameSpace, OldLocalsNamespace : TBaseNameSpaceItem;
begin
  if not Assigned(CallStackWindow) then begin   // Should not happen!
     ClearAll;
     Exit;
  end;

  // Get the selected frame
  CurrentFrame := CallStackWindow.GetSelectedStackFrame;

  SameFrame := (not Assigned(CurrentFrame) and
                (CurrentFileName = '') and
                (CurrentFunctionName = '')) or
               (Assigned(CurrentFrame) and
                (CurrentFileName = CurrentFrame.FileName) and
                (CurrentFunctionName = CurrentFrame.FunctionName));

  OldGlobalsNameSpace := GlobalsNameSpace;
  OldLocalsNamespace := LocalsNameSpace;
  GlobalsNameSpace := nil;
  LocalsNameSpace := nil;

  // Turn off Animation to speed things up
  VariablesTree.TreeOptions.AnimationOptions :=
    VariablesTree.TreeOptions.AnimationOptions - [toAnimatedToggle];

  if Assigned(CurrentFrame) then begin
    CurrentFileName := CurrentFrame.FileName;
    CurrentFunctionName := CurrentFrame.FunctionName;
    // Set the initial number of nodes.
    GlobalsNameSpace := PyIDEMainForm.PyDebugger.GetFrameGlobals(CurrentFrame);
    LocalsNameSpace := PyIDEMainForm.PyDebugger.GetFrameLocals(CurrentFrame);
    if Assigned(GlobalsNameSpace) and Assigned(LocalsNameSpace) then
      RootNodeCount := 2
    else
      RootNodeCount := 0;
  end else begin
    CurrentFileName := '';
    CurrentFunctionName := '';
    GlobalsNameSpace := TNameSpaceItem.Create('globals', VarPythonEval('globals()'));
    RootNodeCount := 1;
  end;

  if SameFrame and (RootNodeCount = VariablesTree.RootNodeCount) then begin
    if Assigned(GlobalsNameSpace) and Assigned(OldGlobalsNameSpace) then
      GlobalsNameSpace.CompareToOldItem(OldGlobalsNameSpace);
    if Assigned(LocalsNameSpace) and Assigned(OldLocalsNameSpace) then
      LocalsNameSpace.CompareToOldItem(OldLocalsNameSpace);
    VariablesTree.BeginUpdate;
    try
      ReinitChildren(VariablesTree.RootNode, True);
      VariablesTree.InvalidateToBottom(VariablesTree.GetFirstVisible);
    finally
      VariablesTree.EndUpdate;
    end;
  end else begin
    VariablesTree.Clear;
    VariablesTree.RootNodeCount := RootNodeCount;
  end;
  FreeAndNil(OldGlobalsNameSpace);
  FreeAndNil(OldLocalsNameSpace);


  VariablesTree.TreeOptions.AnimationOptions :=
    VariablesTree.TreeOptions.AnimationOptions + [toAnimatedToggle];
  VariablesTreeChange(VariablesTree, nil);
end;

procedure TVariablesWindow.ClearAll;
begin
  CurrentFrame := nil;
  VariablesTree.Clear;
  FreeAndNil(GlobalsNameSpace);
  FreeAndNil(LocalsNameSpace);
end;

procedure TVariablesWindow.FormActivate(Sender: TObject);
begin
  inherited;
  if not HasFocus then begin
    FGPanelEnter(Self);
    PostMessage(VariablesTree.Handle, WM_SETFOCUS, 0, 0);
  end;
end;

procedure TVariablesWindow.TBMThemeChange(var Message: TMessage);
begin
  inherited;
  if Message.WParam = TSC_VIEWCHANGE then begin
    VariablesTree.Header.Invalidate(nil, True);
    VariablesTree.Colors.HeaderHotColor :=
      CurrentTheme.GetItemTextColor(GetItemInfo('active'));
    FGPanel.Color := CurrentTheme.GetItemColor(GetItemInfo('inactive'));
    Splitter.ButtonColor :=
      CurrentTheme.GetItemColor(GetItemInfo('inactive'));
    Splitter.ButtonHighlightColor :=
      CurrentTheme.GetItemColor(GetItemInfo('active'));
  end;
end;

procedure TVariablesWindow.FormDestroy(Sender: TObject);
begin
  VariablesWindow := nil;
  ClearAll;
  inherited;
end;

procedure TVariablesWindow.VariablesTreeChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
Var
  FunctionName,
  ModuleName,
  NameSpace,
  ObjectName,
  ObjectType,
  ObjectValue,
  DocString : string;
  LineNo : integer;
  Data : PPyObjRec;
begin
  // Get the selected frame
  if Assigned(CurrentFrame) then begin
    FunctionName := CurrentFrame.FunctionName;
    ModuleName := PathRemoveExtension(ExtractFileName(CurrentFrame.FileName));
    LineNo := CurrentFrame.Line;
    NameSpace := Format(SNamespaceFormat, [FunctionName, ModuleName, LineNo]);
  end else
    NameSpace := 'Interpreter globals';

  if Assigned(Node) and (vsSelected in Node.States) then begin
    Data := VariablesTree.GetNodeData(Node);
    ObjectName := Data.NameSpaceItem.Name;
    ObjectType := Data.NameSpaceItem.ObjectType;
    ObjectValue := HTMLSafe(Data.NameSpaceItem.Value);
    DocString :=  HTMLSafe(Data.NameSpaceItem.DocString);

    HTMLLabel.Caption := Format(SVariablesDocSelected,
      [NameSpace, ObjectName, ObjectType, ObjectValue, Docstring]);
  end else
    HTMLLabel.Caption := Format(SVariablesDocNotSelected, [NameSpace]);
end;

end.


