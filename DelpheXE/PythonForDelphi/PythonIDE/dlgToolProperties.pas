{-----------------------------------------------------------------------------
 Unit Name: dlgToolProperties
 Author:    Kiriakos Vlahos
 Date:      04-Jun-2005
 Purpose:   Dialog for specifying command-line tool properties
 History:
-----------------------------------------------------------------------------}

unit dlgToolProperties;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cTools, ExtCtrls, StdCtrls, JvExStdCtrls, JvCheckBox, SynEdit,
  JvGroupBox, ComCtrls, JvExComCtrls, JvHotKey, Mask, JvExMask,
  JvSpin, Menus, ActnList, TBXDkPanels;

type
  TToolProperties = class(TForm)
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    FormatsPopup: TPopupMenu;
    Filename1: TMenuItem;
    Linenumber1: TMenuItem;
    Columnnumber1: TMenuItem;
    PageControl: TPageControl;
    tsProperties: TTabSheet;
    tsEnvironment: TTabSheet;
    JvGroupBox1: TJvGroupBox;
    Label1: TLabel;
    Label5: TLabel;
    Label14: TLabel;
    edDescription: TEdit;
    edName: TEdit;
    JvGroupBox2: TJvGroupBox;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    SynApplication: TSynEdit;
    SynParameters: TSynEdit;
    SynWorkDir: TSynEdit;
    btnAppDir: TButton;
    btnWorkDir: TButton;
    JvGroupBox4: TJvGroupBox;
    Label4: TLabel;
    Label8: TLabel;
    Label13: TLabel;
    hkShortCut: TJvHotKey;
    JvGroupBox3: TJvGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    cbCaptureOutput: TJvCheckBox;
    cbParseMessages: TJvCheckBox;
    edMessagesFormat: TEdit;
    btnStdFormats: TButton;
    JvGroupBox5: TJvGroupBox;
    Label9: TLabel;
    cbHideConsole: TJvCheckBox;
    cbWaitForTermination: TJvCheckBox;
    seTimeout: TJvSpinEdit;
    cbParseTraceback: TJvCheckBox;
    lvItems: TListView;
    JvGroupBox6: TJvGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    edEnvName: TEdit;
    ActionList: TActionList;
    actAddItem: TAction;
    actDeleteItem: TAction;
    actMoveUp: TAction;
    actMoveDown: TAction;
    actUpdateItem: TAction;
    edEnvValue: TEdit;
    cbUseCustomEnv: TJvCheckBox;
    btnHelp: TButton;
    TBXButton1: TTBXButton;
    TBXButton3: TTBXButton;
    TBXButton4: TTBXButton;
    TBXButton5: TTBXButton;
    TBXButton2: TTBXButton;
    cbStandardInput: TComboBox;
    cbStandardOutput: TComboBox;
    cbContext: TComboBox;
    cbSaveFiles: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure btnStdFormatsClick(Sender: TObject);
    procedure Filename1Click(Sender: TObject);
    procedure SynApplicationEnter(Sender: TObject);
    procedure SynParametersEnter(Sender: TObject);
    procedure SynWorkDirEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnWorkDirClick(Sender: TObject);
    procedure btnAppDirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actAddItemExecute(Sender: TObject);
    procedure actDeleteItemExecute(Sender: TObject);
    procedure actMoveUpExecute(Sender: TObject);
    procedure actMoveDownExecute(Sender: TObject);
    procedure actUpdateItemExecute(Sender: TObject);
    procedure lvItemsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    fEnvStrings : TStrings;
  public
    { Public declarations }
  end;

  function EditTool(Tool : TExternalTool) : Boolean;

implementation

uses dmCommands, JvBrowseFolder, JclSysInfo;

{$R *.dfm}

function EditTool(Tool : TExternalTool) : Boolean;
Var
  i : integer;
begin
  Result := False;
  if not Assigned(Tool) then Exit;
  with TToolProperties.Create(Application) do
  try
    with Tool do begin
      edName.Text := Caption;
      edDescription.Text := Description;
      SynApplication.Text := ApplicationName;
      SynParameters.Text := Parameters;
      SynWorkDir.Text := WorkingDirectory;
      cbContext.ItemIndex := Integer(Context);
      hkShortCut.HotKey := ShortCut;
      cbSaveFiles.ItemIndex := Integer(SaveFiles);
      cbStandardInput.ItemIndex := Integer(ProcessInput);
      cbStandardOutput.ItemIndex := Integer(ProcessOutput);
      cbCaptureOutput.Checked := CaptureOutput;
      seTimeOut.Value := TimeOut;
      cbWaitForTermination.Checked := WaitForTerminate;
      cbHideConsole.Checked := ConsoleHidden;
      cbParseMessages.Checked := ParseMessages;
      cbParseTraceback.Checked := ParseTraceback;
      edMessagesFormat.Text := MessagesFormat;
      cbUseCustomEnv.Checked := UseCustomEnvironment;
      if UseCustomEnvironment then
        fEnvStrings.Assign(Environment)
      else
        GetEnvironmentVars(fEnvStrings);
    end;
    Result := (ShowModal = mrOK) and (edName.Text <> '');
    if Result then with Tool do begin
      Caption := edName.Text;
      Description := edDescription.Text;
      ApplicationName := SynApplication.Text;
      Parameters := SynParameters.Text;
      WorkingDirectory := SynWorkDir.Text;
      Context := TToolContext(cbContext.ItemIndex);
      ShortCut := hkShortCut.HotKey;
      SaveFiles := TSaveFiles(cbSaveFiles.ItemIndex);
      ProcessInput := TProcessStdInputOption(cbStandardInput.ItemIndex);
      ProcessOutput := TProcessStdOutputOption(cbStandardOutput.ItemIndex);
      CaptureOutput := cbCaptureOutput.Checked;
      TimeOut := Trunc(seTimeOut.Value);
      WaitForTerminate := cbWaitForTermination.Checked;
      ConsoleHidden := cbHideConsole.Checked;
      ParseMessages := cbParseMessages.Checked;
      ParseTraceback := cbParseTraceback.Checked;
      MessagesFormat := edMessagesFormat.Text;
      UseCustomEnvironment := cbUseCustomEnv.Checked;
      Environment.Clear;
      if UseCustomEnvironment then begin
        for i := 0 to lvItems.Items.Count - 1 do
          Environment.Add(lvItems.Items[i].Caption + '=' + lvItems.Items[i].SubItems[0]);
      end;
    end;
    cbParseMessages.LinkedControls.Clear;  // workaround to JVCL bug in JvCheckBox
  finally
    Release;
  end;
end;

procedure TToolProperties.btnStdFormatsClick(Sender: TObject);
var
  p: TPoint;
begin
  p:= btnStdFormats.ClientToScreen(Point(btnStdFormats.Width, 0));
  FormatsPopup.Popup(p.x, p.y);
end;

procedure TToolProperties.Filename1Click(Sender: TObject);
begin
  case (Sender as TMenuItem).Tag of
    0: edMessagesFormat.SelText := GrepFileNameParam;
    1: edMessagesFormat.SelText := GrepLineNumberParam;
    2: edMessagesFormat.SelText := GrepColumnNumberParam;
  end;
  edMessagesFormat.SetFocus;
end;

procedure TToolProperties.SynApplicationEnter(Sender: TObject);
begin
  CommandsDataModule.ParameterCompletion.Editor := SynApplication;
  CommandsDataModule.ModifierCompletion.Editor := SynApplication;
end;

procedure TToolProperties.SynParametersEnter(Sender: TObject);
begin
  CommandsDataModule.ParameterCompletion.Editor := SynParameters;
  CommandsDataModule.ModifierCompletion.Editor := SynParameters;
end;

procedure TToolProperties.SynWorkDirEnter(Sender: TObject);
begin
  CommandsDataModule.ParameterCompletion.Editor := SynWorkDir;
  CommandsDataModule.ModifierCompletion.Editor := SynWorkDir;
end;

procedure TToolProperties.FormCreate(Sender: TObject);
begin
  fEnvStrings := TStringList.Create;
end;

procedure TToolProperties.FormDestroy(Sender: TObject);
begin
  fEnvStrings.Free;
  CommandsDataModule.ParameterCompletion.Editor := nil;
  CommandsDataModule.ModifierCompletion.Editor := nil;
end;

procedure TToolProperties.btnWorkDirClick(Sender: TObject);
var
  S: string;
begin
  S := '';
  if BrowseDirectory(S, 'Select working directory:', 0) then begin
    SynWorkDir.SelText := S;
    SynWorkDir.SetFocus;
  end;
end;

procedure TToolProperties.btnAppDirClick(Sender: TObject);
begin
  with CommandsDataModule.dlgFileOpen do begin
    Title := 'Select application or file to execute';
    Filter := 'Executable Files (*.exe;*.bat;*.cmd)|*.exe;*.bat;*.cmd|All files|*.*|';
    if Execute then begin
      SynApplication.SelText := FileName;
      SynApplication.SetFocus;
    end;
  end;
end;

procedure TToolProperties.actAddItemExecute(Sender: TObject);
Var
  Item : TListItem;
  i : Integer;
begin
  if edEnvName.Text <> '' then begin
    for i := 0 to lvItems.Items.Count - 1 do
      if CompareText(lvItems.Items[i].Caption, EdEnvName.Text) = 0 then begin
        Item := lvItems.Items[i];
        Item.Caption := EdEnvName.Text;
        Item.SubItems[0] := EdEnvValue.Text;
        Item.Selected := True;
        Exit;
      end;

    with lvItems.Items.Add() do begin
      Caption := edEnvName.Text;
      SubItems.Add(edEnvValue.Text);
    end;
  end;end;

procedure TToolProperties.actDeleteItemExecute(Sender: TObject);
begin
  if lvItems.ItemIndex >= 0 then
    lvItems.Items.Delete(lvItems.ItemIndex);
end;

procedure TToolProperties.actMoveUpExecute(Sender: TObject);
Var
  Name, Value : string;
  Index : integer;
begin
  if lvItems.ItemIndex > 0 then begin
    Index := lvItems.ItemIndex;
    Name := lvItems.Items[Index].Caption;
    Value := lvItems.Items[Index].SubItems[0];
    lvItems.Items.Delete(Index);

    with lvItems.Items.Insert(Index - 1) do begin
      Caption := Name;
      SubItems.Add(Value);
      Selected := True;
    end;
  end;
end;

procedure TToolProperties.actMoveDownExecute(Sender: TObject);
Var
  Name, Value : string;
  Index : integer;
begin
  if lvItems.ItemIndex < lvItems.Items.Count - 1 then begin
    Index := lvItems.ItemIndex;
    Name := lvItems.Items[Index].Caption;
    Value := lvItems.Items[Index].SubItems[0];
    lvItems.Items.Delete(Index);

    with lvItems.Items.Insert(Index + 1) do begin
      Caption := Name;
      SubItems.Add(Value);
      Selected := True;
    end;
  end;
end;

procedure TToolProperties.actUpdateItemExecute(Sender: TObject);
Var
  i : integer;
begin
  if (edEnvName.Text <> '') and (lvItems.ItemIndex >= 0) then begin
    for i := 0 to lvItems.Items.Count - 1 do
      if (CompareText(lvItems.Items[i].Caption, edEnvName.Text) = 0) and
         (i <> lvItems.ItemIndex) then
      begin
        MessageDlg('Another item has the same name', mtError, [mbOK], 0);
        Exit;
      end;
    with lvItems.Items[lvItems.ItemIndex] do begin
      Caption := EdEnvName.Text;
      SubItems[0] := EdEnvValue.Text;
    end;
  end;
end;

procedure TToolProperties.lvItemsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
 if Item.Selected then begin
    edEnvName.Text := Item.Caption;
    edEnvValue.Text := Item.SubItems[0];
  end;
end;

procedure TToolProperties.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  actDeleteItem.Enabled := lvItems.ItemIndex >= 0;
  actMoveUp.Enabled := lvItems.ItemIndex >= 1;
  actMoveDown.Enabled := (lvItems.ItemIndex >= 0) and
                         (lvItems.ItemIndex < lvItems.Items.Count - 1);
  actAddItem.Enabled := edName.Text <> '';
  actUpdateItem.Enabled := (edName.Text <> '') and (lvItems.ItemIndex >= 0);
  Handled := True;
end;

procedure TToolProperties.btnHelpClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

procedure TToolProperties.FormShow(Sender: TObject);
Var
  i : integer;
begin
  lvItems.Clear;
  for i := 0 to fEnvStrings.Count - 1 do
    if fEnvStrings.Names[i] <> '' then
      with lvItems.Items.Add() do begin
        Caption := fEnvStrings.Names[i];
        SubItems.Add(fEnvStrings.Values[Caption]);
      end;
end;

end.

