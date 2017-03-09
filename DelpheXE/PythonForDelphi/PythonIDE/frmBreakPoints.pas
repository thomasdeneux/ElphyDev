{-----------------------------------------------------------------------------
 Unit Name: frmBreakPoints
 Author:    Kiriakos Vlahos
 Purpose:   Breakpoints Window
 History:
-----------------------------------------------------------------------------}

unit frmBreakPoints;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvDockControlForm, JvComponent, frmIDEDockWin, ExtCtrls,
  Contnrs, TB2Item, Menus, TBX, TBXThemes, VirtualTrees, JvComponentBase;

type
  TBreakPointsWindow = class(TIDEDockWindow)
    TBXPopupMenu: TTBXPopupMenu;
    mnClear: TTBXItem;
    Breakpoints1: TTBXItem;
    BreakPointsView: TVirtualStringTree;
    mnSetCondition: TTBXItem;
    TBXSeparatorItem1: TTBXSeparatorItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    mnCopyToClipboard: TTBXItem;
    procedure TBXPopupMenuPopup(Sender: TObject);
    procedure mnCopyToClipboardClick(Sender: TObject);
    procedure mnSetConditionClick(Sender: TObject);
    procedure BreakPointsViewChecked(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure BreakPointLVDblClick(Sender: TObject);
    procedure mnClearClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BreakPointsViewInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure BreakPointsViewGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
  private
    { Private declarations }
    fBreakPointsList : TObjectList;
  protected
    procedure TBMThemeChange(var Message: TMessage); message TBM_THEMECHANGE;
  public
    { Public declarations }
    procedure UpdateWindow;
  end;

var
  BreakPointsWindow: TBreakPointsWindow;

implementation

uses frmPyIDEMain, uEditAppIntfs, dmCommands, uCommonFunctions, Clipbrd,
  JvDockGlobals;

{$R *.dfm}

Type
  TBreakPointInfo = class
    FileName : string;
    Line : integer;
    Disabled : Boolean;
    Condition : string;
  end;

  PBreakPointRec = ^TBreakPointRec;
  TBreakPointRec = record
    BreakPoint : TBreakPointInfo;
  end;

procedure TBreakPointsWindow.UpdateWindow;
Var
  i, j : integer;
  BL : TList;
  BreakPoint : TBreakPointInfo;
begin
  BreakPointsView.Clear;
  fBreakPointsList.Clear;
  for i := 0 to GI_EditorFactory.Count - 1 do begin
     BL := GI_EditorFactory.Editor[i].BreakPoints;
     for j := 0 to BL.Count -1 do begin
       BreakPoint := TBreakPointInfo.Create;
       BreakPoint.FileName := GI_EditorFactory.Editor[i].GetFileNameOrTitle;
       BreakPoint.Line := TBreakPoint(BL[j]).LineNo;
       BreakPoint.Disabled := TBreakPoint(BL[j]).Disabled;
       BreakPoint.Condition := TBreakPoint(BL[j]).Condition;
       fBreakPointsList.Add(BreakPoint);
     end;
  end;
  BreakPointsView.RootNodeCount := fBreakPointsList.Count;
end;

procedure TBreakPointsWindow.BreakPointLVDblClick(Sender: TObject);
Var
  Node : PVirtualNode;
  BreakPoint : TBreakPointInfo;
begin
  Node := BreakPointsView.GetFirstSelected();
  if Assigned(Node) then begin
    BreakPoint := PBreakPointRec(BreakPointsView.GetNodeData(Node))^.BreakPoint;

    if (BreakPoint.FileName ='') then Exit; // No FileName or LineNumber
    PyIDEMainForm.ShowFilePosition(BreakPoint.FileName, BreakPoint.Line, 1);
  end;
end;

procedure TBreakPointsWindow.mnClearClick(Sender: TObject);
Var
  Editor : IEditor;
  Node : PVirtualNode;
begin
  Node := BreakPointsView.GetFirstSelected();
  if Assigned(Node) then
    with PBreakPointRec(BreakPointsView.GetNodeData(Node))^.BreakPoint do begin
     if FileName = '' then Exit; // No FileName or LineNumber
     Editor := GI_EditorFactory.GetEditorByNameOrTitle(FileName);
     if Assigned(Editor) then
       PyIDEMainForm.PyDebugger.ToggleBreakpoint(Editor, Line);
    end;
end;

procedure TBreakPointsWindow.mnSetConditionClick(Sender: TObject);
Var
  Editor : IEditor;
  Node : PVirtualNode;
begin
  Node := BreakPointsView.GetFirstSelected();
  if Assigned(Node) then
    with PBreakPointRec(BreakPointsView.GetNodeData(Node))^.BreakPoint do begin
      if FileName = '' then Exit; // No FileName or LineNumber
      Editor := GI_EditorFactory.GetEditorByNameOrTitle(FileName);
      if Assigned(Editor) then begin
        if InputQuery('Edit Breakpoint Condition',
          'Enter Python expression:', Condition)
        then
          PyIDEMainForm.PyDebugger.SetBreakPoint(FileName, Line, Disabled, Condition);
      end;
    end;
end;

procedure TBreakPointsWindow.mnCopyToClipboardClick(Sender: TObject);
begin
  Clipboard.AsText := BreakPointsView.ContentToText(tstAll, #9);
end;

procedure TBreakPointsWindow.FormActivate(Sender: TObject);
begin
  inherited;
  if not HasFocus then begin
    FGPanelEnter(Self);
    PostMessage(BreakPointsView.Handle, WM_SETFOCUS, 0, 0);
  end;
end;

procedure TBreakPointsWindow.FormCreate(Sender: TObject);
begin
  inherited;
  fBreakPointsList := TObjectList.Create(True);  // Onwns objects
  // Let the tree know how much data space we need.
  BreakPointsView.NodeDataSize := SizeOf(TBreakPointRec);
  BreakPointsView.OnAdvancedHeaderDraw :=
    CommandsDataModule.VirtualStringTreeAdvancedHeaderDraw;
  BreakPointsView.OnHeaderDrawQueryElements :=
    CommandsDataModule.VirtualStringTreeDrawQueryElements;
end;

procedure TBreakPointsWindow.FormDestroy(Sender: TObject);
begin
  fBreakPointsList.Free;
  inherited;
end;

procedure TBreakPointsWindow.TBMThemeChange(var Message: TMessage);
begin
  inherited;
  if Message.WParam = TSC_VIEWCHANGE then begin
    BreakPointsView.Header.Invalidate(nil, True);
    BreakPointsView.Colors.HeaderHotColor :=
      CurrentTheme.GetItemTextColor(GetItemInfo('active'));
  end;
end;

procedure TBreakPointsWindow.BreakPointsViewInitNode(
  Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
begin
  Assert(BreakPointsView.GetNodeLevel(Node) = 0);
  Assert(Integer(Node.Index) < fBreakPointsList.Count);
  PBreakPointRec(BreakPointsView.GetNodeData(Node))^.BreakPoint :=
    fBreakPointsList[Node.Index] as TBreakPointInfo;
  Node.CheckType := ctCheckBox;
  if TBreakPointInfo(fBreakPointsList[Node.Index]).Disabled then
    Node.CheckState := csUnCheckedNormal
  else
    Node.CheckState := csCheckedNormal;
end;

procedure TBreakPointsWindow.BreakPointsViewGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: WideString);
begin
  Assert(BreakPointsView.GetNodeLevel(Node) = 0);
  Assert(Integer(Node.Index) < fBreakPointsList.Count);
  with PBreakPointRec(BreakPointsView.GetNodeData(Node))^.BreakPoint do
    case Column of
      0:  CellText := FileName;
      1:  if Line > 0
            then CellText := IntToStr(Line)
          else
            CellText := '';
      2:  CellText := Condition;
    end;
end;

procedure TBreakPointsWindow.BreakPointsViewChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  with PBreakPointRec(BreakPointsView.GetNodeData(Node))^.BreakPoint do begin
    if Node.CheckState = csCheckedNormal then
      Disabled := False
    else
      Disabled := True;
    PyIDEMainForm.PyDebugger.SetBreakPoint(FileName, Line, Disabled, Condition);
  end;

end;

procedure TBreakPointsWindow.TBXPopupMenuPopup(Sender: TObject);
begin
  mnClear.Enabled := Assigned(BreakPointsView.GetFirstSelected());
  mnSetCondition.Enabled := Assigned(BreakPointsView.GetFirstSelected());
  mnCopyToClipboard.Enabled := fBreakPointsList.Count > 0;
end;

end.


