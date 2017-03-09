{-----------------------------------------------------------------------------
 Unit Name: cPythonSourceScanner
 Author:    Kiriakos Vlahos
 Date:      14-Jun-2005
 Purpose:   Class for Scanning and analysing Python code
            Does not check correctness
            Code draws from Bicycle Repair Man and Boa Constructor
 History:
-----------------------------------------------------------------------------}
unit cPythonSourceScanner;

interface

uses SysUtils,
     Classes,
     Contnrs,
     SynRegExpr;

Type
  TParsedModule = class;

  TCodePos = record
    LineNo : integer;
    CharOffset : integer;
  end;

  TBaseCodeElement = class
    // abstract base class
  private
    fParent : TBaseCodeElement;
  protected
    fIsProxy : boolean;
    fCodePos : TCodePos;
    function GetCodeHint : string; virtual; abstract;
  public
    Name : string;
    function GetRoot : TBaseCodeElement;
    function GetModule : TParsedModule;
    function GetModuleSource : string;
    property CodePos : TCodePos read fCodePos;
    property Parent : TBaseCodeElement read fParent write fParent;
    property IsProxy : boolean read fIsProxy;  // true if derived from live Python object
    property CodeHint : string read GetCodeHint;
  end;

  TCodeBlock = record
    StartLine : integer;
    EndLine : integer;
  end;

  TModuleImport = class(TBaseCodeElement)
  private
    fRealName : String; // used if name is an alias
    function GetRealName: string;
  protected
    function GetCodeHint : string; override;
  public
    CodeBlock : TCodeBlock;
    ImportAll : Boolean;
    ImportedNames : TObjectList;
    property RealName : string read GetRealName;
    constructor Create(AName : string; CB : TCodeBlock);
    destructor Destroy; override;
  end;

  TVariableAttribute = (vaBuiltIn, vaClassAttribute, vaCall, vaArgument,
                        vaStarArgument, vaStarStarArgument, vaArgumentWithDefault,
                        vaImported);
  TVariableAttributes = set of TVariableAttribute;

  TVariable = class(TBaseCodeElement)
    // The parent can be TParsedModule, TParsedClass, TParsedFunction or TModuleImport
  private
    // only used if Parent is TModuleImport and Name is an alias
    fRealName : String;
    function GetRealName: string;
  protected
    function GetCodeHint : string; override;
  public
    ObjType : string;
    DefaultValue : string;
    Attributes : TVariableAttributes;
    property RealName : string read GetRealName;
  end;

  TCodeElement = class(TBaseCodeElement)
  private
    fCodeBlock : TCodeBlock;
    fDocString : string;
    fIndent : integer;
    fChildren : TObjectList;
    fDocStringExtracted : boolean;
    function GetChildCount: integer;
    function GetChildren(i : integer): TCodeElement;
    procedure ExtractDocString;
  protected
    function GetDocString: string; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddChild(CE : TCodeElement);
    procedure GetSortedClasses(SortedClasses : TObjectList);
    procedure GetSortedFunctions(SortedFunctions : TObjectList);
    procedure GetNameSpace(SList : TStringList); virtual;
    function GetScopeForLine(LineNo : integer) : TCodeElement;
    function GetChildByName(ChildName : string): TCodeElement;
    property CodeBlock : TCodeBlock read fCodeBlock;
    property Indent : integer read fIndent;
    property ChildCount : integer read GetChildCount;
    property Children[i : integer] : TCodeElement read GetChildren;
    property DocString : string read GetDocString;
  end;

  TParsedModule = class(TCodeElement)
  private
    fImportedModules : TObjectList;
    fGlobals : TObjectList;
    fSource : string;
    fFileName : string;
    fMaskedSource : string;
    fAllExportsVar : string;
    function GetIsPackage: boolean;
  protected
    function GetAllExportsVar: string; virtual;
    function GetCodeHint : string; override;
    procedure GetNameSpaceInternal(SList, ImportedModuleCache : TStringList);
public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure GetNameSpace(SList : TStringList); override;
    procedure GetSortedImports(ImportsList : TObjectList);
    procedure GetUniqueSortedGlobals(GlobalsList : TObjectList);
    property ImportedModules : TObjectList read fImportedModules;
    property Globals : TObjectList read fGlobals;
    property Source : string read fSource;
    property FileName : string read fFileName write fFileName;
    property MaskedSource : string read fMaskedSource;
    property IsPackage : boolean read GetIsPackage;
    property AllExportsVar : string read GetAllExportsVar;
  end;

  TParsedFunction = class(TCodeElement)
  private
    fArguments : TObjectList;
    fLocals : TObjectList;
  protected
    function GetCodeHint : string; override;
  public
    constructor Create;
    destructor Destroy; override;
    function ArgumentsString : string; virtual;
    procedure GetNameSpace(SList : TStringList); override;
    property Arguments : TObjectList read fArguments;
    property Locals : TObjectList read fLocals;
  end;

  TParsedClass = class(TCodeElement)
  private
    fSuperClasses : TStringList;
    fAttributes : TObjectList;
    procedure GetNameSpaceImpl(SList: TStringList; BaseClassResolver : TStringList);
    function GetConstructorImpl(BaseClassResolver : TStringList) : TParsedFunction;
  protected
    function GetCodeHint : string; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetNameSpace(SList : TStringList); override;
    procedure GetUniqueSortedAttibutes(AttributesList: TObjectList);
    function GetConstructor : TParsedFunction; virtual;
    property SuperClasses : TStringList read fSuperClasses;
    property Attributes : TObjectList read fAttributes;
  end;

  TScannerProgressEvent = procedure(CharNo, NoOfChars : integer; var Stop : Boolean) of object;

  TPythonScanner = class
  private
    fOnScannerProgress : TScannerProgressEvent;
    fCodeRE : TRegExpr;
    fBlankLineRE : TRegExpr;
    fEscapedQuotesRE : TRegExpr;
    fStringsAndCommentsRE : TRegExpr;
    fLineContinueRE : TRegExpr;
    fImportRE : TRegExpr;
    fFromImportRE : TRegExpr;
    fClassAttributeRE : TRegExpr;
    fVarRE : TRegExpr;
    fAliasRE : TRegExpr;
    fListRE : TRegExpr;
//    function StringAndCommentsReplaceFunc(ARegExpr : TRegExpr): string;
  protected
    procedure DoScannerProgress(CharNo, NoOfChars : integer; var Stop : Boolean);
  public
    property OnScannerProgress : TScannerProgressEvent
      read fOnScannerProgress write fOnScannerProgress;

    constructor Create;
    destructor Destroy; override;
    function ScanModule(Source : string; Module : TParsedModule) : boolean;
  end;

  function CodeBlock(StartLine, EndLine : integer) : TCodeBlock;
  function GetExpressionType(Expr : string; Var IsBuiltIn : boolean) : string;

implementation

uses uCommonFunctions, JclStrings, JclFileUtils, cRefactoring, VarPyth,
  StringResources, JclSysUtils, Math;

Const
  IdentRE = '[A-Za-z_][A-Za-z0-9_]*';
  DottedIdentRE = '[A-Za-z_][A-Za-z0-9_.]*';

  NoOfImplicitContinuationBraces = 3;
  ImplicitContinuationBraces : array[0..NoOfImplicitContinuationBraces-1] of
    array [0..1] of Char = (('(', ')'), ('[', ']'), ('{', '}'));

Type
  ImplicitContinuationBracesCount = array [0..NoOfImplicitContinuationBraces-1] of integer;

Var
  DocStringRE : TRegExpr;


procedure HangingBraces(S : string; OpenBrace, CloseBrace : Char; var Count : integer);
var
  I: Integer;
begin
  for I := 1 to Length(S) do
    if S[I] = OpenBrace then
      Inc(Count)
    else if S[I] = CloseBrace then
      Dec(Count);
end;

function HaveImplicitContinuation(S : string;
  var CountArray : ImplicitContinuationBracesCount; InitCount : boolean = false) : boolean;
Var
  i : integer;
begin
  if InitCount then
    for i := 0 to NoOfImplicitContinuationBraces - 1 do
      CountArray[i] := 0;
  for i := 0 to NoOfImplicitContinuationBraces - 1 do
    HangingBraces(S, ImplicitContinuationBraces[i][0],
      ImplicitContinuationBraces[i][1], CountArray[i]);
  Result := False;
  for i := 0 to NoOfImplicitContinuationBraces - 1 do
    // Code would be incorrect if Count < 0 but we ignore it
    if CountArray[i] > 0 then begin
      Result := True;
      break;
    end;
end;
{ Code Ellement }

constructor TCodeElement.Create;
begin
  inherited;
  fParent := nil;
  fChildren := nil;
end;

destructor TCodeElement.Destroy;
begin
  FreeAndNil(fChildren);
  inherited;
end;

procedure TCodeElement.AddChild(CE : TCodeElement);
begin
  if fChildren = nil then
    fChildren := TObjectList.Create(True);

  CE.fParent := Self;
  fChildren.Add(CE);
end;

function TCodeElement.GetChildCount: integer;
begin
  if Assigned(fChildren) then
    Result := fChildren.Count
  else
    Result := 0;
end;

function TCodeElement.GetChildren(i : integer): TCodeElement;
begin
  if Assigned(fChildren) then begin
    Result := TCodeElement(fChildren[i]);
    Assert(Result is TCodeElement);
    Assert(Assigned(Result));
  end else
    Result := nil;
end;

function TCodeElement.GetChildByName(ChildName: string): TCodeElement;
var
  i : integer;
  CE : TCodeElement;
begin
  Result := nil;
  if not Assigned(fChildren) then Exit;
  for i := 0 to fChildren.Count - 1 do begin
    CE := GetChildren(i);
    if CE.Name = ChildName then begin
      Result := CE;
      Exit;
    end;
  end;
end;

function CompareCodeElements(Item1, Item2: Pointer): Integer;
begin
  Result := CompareStr(TCodeElement(Item1).Name, TCodeElement(Item2).Name);
end;

procedure TCodeElement.GetSortedClasses(SortedClasses: TObjectList);
Var
  i : integer;
begin
  if not Assigned(fChildren) then Exit;
  for i := 0 to Self.fChildren.Count - 1 do
    if fChildren[i] is TParsedClass then
      SortedClasses.Add(fChildren[i]);
  SortedClasses.Sort(CompareCodeElements);
end;

procedure TCodeElement.GetSortedFunctions(SortedFunctions: TObjectList);
Var
  i : integer;
begin
  if not Assigned(fChildren) then Exit;
  for i := 0 to Self.fChildren.Count - 1 do
    if fChildren[i] is TParsedFunction then
      SortedFunctions.Add(fChildren[i]);
  SortedFunctions.Sort(CompareCodeElements);
end;

procedure TCodeElement.GetNameSpace(SList: TStringList);
Var
  i : integer;
begin
  //  Add from Children
  if Assigned(fChildren) then
    for i := 0 to fChildren.Count - 1 do
      SList.AddObject(TCodeElement(fChildren[i]).Name, fChildren[i]);
end;

function TCodeElement.GetScopeForLine(LineNo: integer): TCodeElement;
Var
  i : integer;
  CE : TCodeElement;
begin
  if (LineNo >= fCodeBlock.StartLine) and (LineNo <= fCodeBlock.EndLine) then begin
    Result := Self;
    //  try to see whether the line belongs to a child
    if not Assigned(fChildren) then Exit;
    for i := 0 to fChildren.Count - 1 do begin
      CE := Children[i];
      if LineNo < CE.CodeBlock.StartLine then
        break
      else if LineNo > CE.CodeBlock.EndLine then
        continue
      else begin
        // recursive call
        Result := CE.GetScopeForLine(LineNo);
        break;
      end;
    end;
  end else
    Result := nil;
end;

procedure TCodeElement.ExtractDocString;
var
  ModuleSource, DocStringSource : string;
  CB : TCodeBlock;
begin
  fDocStringExtracted := True;
  fDocString := '';

  CB := fCodeBlock;
  Inc(CB.StartLine);
  if Assigned(fChildren) and (fChildren.Count > 0) then
    CB.EndLine := Pred(Children[0].CodeBlock.StartLine);
  if CB.StartLine > CB.EndLine then Exit;

  ModuleSource := GetModuleSource;
  if ModuleSource = '' then Exit;

  DocStringSource := GetLineRange(ModuleSource, CB.StartLine, CB.EndLine);
  if DocStringSource = '' then Exit;

  if DocStringRE.Exec(DocStringSource) then begin
    if DocStringRE.MatchPos[1] >= 0 then
      fDocString := DocStringRE.Match[1]
    else
      fDocString := DocStringRE.Match[2];

    fDocString := FormatDocString(fDocString);
  end;
end;

function TCodeElement.GetDocString: string;
begin
  if not fDocStringExtracted then
    ExtractDocString;
  Result := fDocString;
end;

{ TPythonScanner }

constructor TPythonScanner.Create;
  function CompiledRegExpr(Expr : string): TRegExpr;
  begin
    Result := TRegExpr.Create;
    Result.Expression := Expr;
    Result.Compile;
  end;
begin
  inherited;
  fCodeRE := CompiledRegExpr('^([ \t]*)(class|def)[ \t]+(\w+)[ \t]*(\(.*\))?');
  fBlankLineRE := CompiledRegExpr('^[ \t]*($|#)');
  fEscapedQuotesRE := CompiledRegExpr('(\\\\|\\\"|\\\'')');
  fStringsAndCommentsRE :=
    CompiledRegExpr('(?sm)(\"\"\".*?\"\"\"|''''''.*?''''''|\"[^\"]*\"|\''[^\'']*\''|#.*?\n)');
  fLineContinueRE := CompiledRegExpr('\\[ \t]*(#.*)?$');
  fImportRE := CompiledRegExpr('^[ \t]*import[ \t]*([^#;]+)');
  fFromImportRE :=
    CompiledRegExpr(Format('^[ \t]*from[ \t]+(%s)[ \t]+import[ \t]+([^#;]+)', [DottedIdentRE]));
  fClassAttributeRE :=
    CompiledRegExpr(Format('^[ \t]*self\.(%s)[ \t]*(=)[ \t]*((%s)(\(?))?',
      [IdentRE, DottedIdentRE]));
  fVarRE :=
    CompiledRegExpr(Format('^[ \t]*(%s)[ \t]*(=)[ \t]*((%s)(\(?))?',
      [IdentRE, DottedIdentRE]));
  fAliasRE :=
    CompiledRegExpr(Format('^[ \t]*(%s)([ \t]+as[ \t]+(%s))?',
      [DottedIdentRE, IdentRE]));
  fListRE :=
    CompiledRegExpr('\[(.*)\]');
end;

destructor TPythonScanner.Destroy;
begin
  fCodeRE.Free;
  fBlankLineRE.Free;
  fEscapedQuotesRE.Free;
  fStringsAndCommentsRE.Free;
  fLineContinueRE.Free;
  fImportRE.Free;
  fFromImportRE.Free;
  fClassAttributeRE.Free;
  fVarRE.Free;
  fAliasRE.Free;
  fListRE.Free;
  inherited;
end;

procedure TPythonScanner.DoScannerProgress(CharNo, NoOfChars : integer;
  var Stop: Boolean);
begin
  if Assigned(fOnScannerProgress) then
    fOnScannerProgress(CharNo, NoOfChars, Stop);
end;

function TPythonScanner.ScanModule(Source: string; Module : TParsedModule): boolean;
// Parses the Python Source code and adds code elements as children of Module

Var
  UseModifiedSource : boolean;

  procedure GetLine(var P : PChar; var Line : string; var LineNo : integer);
  Var
    Start : PChar;
  begin
    Inc(LineNo);
    Start := P;
    while not (P^ in [#0, #10, #13]) do Inc(P);
    if UseModifiedSource then
      SetString(Line, Start, P - Start)
    else
      Line := GetNthLine(Source, LineNo);
    if P^ = #13 then Inc(P);
    if P^ = #10 then Inc(P);
  end;

  procedure CharOffsetToCodePos(CharOffset, FirstLine : integer; LineStarts : TList;
    var CodePos: TCodePos);
  var
    i : integer;
  begin
    CodePos.LineNo := FirstLine;
    CodePos.CharOffset := CharOffset;
    for i := LineStarts.Count - 1 downto 0 do begin
      if Integer(LineStarts[i]) <= CharOffset then begin
        CodePos.CharOffset := CharOffset - Integer(LineStarts[i]) + 1;
        CodePos.LineNo := FirstLine + i + 1;
        break;
      end;
    end;
  end;

  function ProcessLineContinuation(var P : PChar; var Line : string;
    var LineNo: integer; LineStarts : TList): boolean;
  // Process continuation lines
  var
    ExplicitContinuation, ImplicitContinuation : boolean;
    CountArray : ImplicitContinuationBracesCount;
    NewLine : string;
  begin
    LineStarts.Clear;
    ExplicitContinuation := fLineContinueRE.Exec(Line);
    ImplicitContinuation := HaveImplicitContinuation(Line, CountArray, True);
    Result := ExplicitContinuation or ImplicitContinuation;
    while (ExplicitContinuation or ImplicitContinuation) and (P^ <> #0) do begin
      if ExplicitContinuation then
        // Drop the continuation char
        Line := Copy(Line, 1, fLineContinueRE.MatchPos[0] - 1);
      LineStarts.Add(Pointer(Length(Line)+2));
      GetLine(P, NewLine, LineNo);
      if ExplicitContinuation and (Trim(NewLine)='') then break;
      Line := Line + ' ' + NewLine;
      ExplicitContinuation := fLineContinueRE.Exec(Line);
      ImplicitContinuation := not ExplicitContinuation  and
        HaveImplicitContinuation(Line, CountArray, True);
    end;
  end;

  function GetActiveClass(CodeElement : TBaseCodeElement) : TParsedClass;
  begin
    while Assigned(CodeElement) and (CodeElement.ClassType <> TParsedClass) do
      CodeElement := CodeElement.Parent;
    Result := TParsedClass(CodeElement);
  end;

  function ReplaceQuotedChars(const Source : string): string;
  //  replace quoted \ ' " with **
  Var
    pRes, pSource : PChar;
  begin
    Result := Source;
    if Length(Source) = 0 then Exit;
    UniqueString(Result);
    pRes := PChar(Result);
    pSource := PChar(Source);
    while pSource^ <> #0 do begin
      if (pSource^ = '\') then begin
        Inc(pSource);
        if pSource^ in ['\', '''', '"'] then begin
          pRes^ := '*';
          Inc(pRes);
          pRes^ := '*';
        end else
          Inc(pRes);
      end;
      inc(pSource);
      inc(pRes);
    end;
  end;

  function MaskStringsAndComments(const Source : string): string;
  // Replace all chars in strings and comments with *
  Type
    TParseState = (psNormal, psInTripleSingleQuote, psInTripleDoubleQuote,
    psInSingleString, psInDoubleString, psInComment);
  Var
    pRes, pSource : PChar;
    ParseState : TParseState;
  begin
    Result := Source;
    if Length(Source) = 0 then Exit;
    UniqueString(Result);
    pRes := PChar(Result);
    pSource := PChar(Source);
    ParseState := psNormal;
    while pSource^ <> #0 do begin
      case pSource^ of
        '"' :
           case ParseState of
             psNormal :
               if StrIsLeft(psource + 1, '""') then begin
                 ParseState := psInTripleDoubleQuote;
                 Inc(pRes,2);
                 Inc(pSource, 2);
               end else
                 ParseState := psInDoubleString;
             psInTripleSingleQuote,
             psInSingleString,
             psInComment :
               pRes^ := '*';
             psInTripleDoubleQuote :
               if StrIsLeft(psource + 1, '""') then begin
                 ParseState := psNormal;
                 Inc(pRes,2);
                 Inc(pSource, 2);
               end else
                 pRes^ := '*';
             psInDoubleString :
               ParseState := psNormal;
           end;
        '''':
           case ParseState of
             psNormal :
               if StrIsLeft(psource + 1, '''''') then begin
                 ParseState := psInTripleSingleQuote;
                 Inc(pRes, 2);
                 Inc(pSource, 2);
               end else
                 ParseState := psInSingleString;
             psInTripleDoubleQuote,
             psInDoubleString,
             psInComment :
               pRes^ := '*';
             psInTripleSingleQuote :
               if StrIsLeft(psource + 1, '''''') then begin
                 ParseState := psNormal;
                 Inc(pRes, 2);
                 Inc(pSource, 2);
               end else
                 pRes^ := '*';
             psInSingleString :
               ParseState := psNormal;
           end;
        '#' :
          if ParseState = psNormal then
            ParseState := psInComment
          else
            pRes^ := '*';
        #10, #13:
          begin
            if ParseState in [psInSingleString, psInDoubleString, psInComment] then
              ParseState := psNormal;
          end;
        ' ', #9 : {do nothing};
      else
        if ParseState <> psNormal then
          pRes^ := '*';
      end;
      inc(pSource);
      inc(pRes);
    end;
  end;

var
  P : PChar;
  LineNo, Indent, Index, CharOffset, CharOffset2, LastLength : integer;
  CodeStart : integer;
  Line, Token, S : string;
  Stop : Boolean;
  CodeElement, LastCodeElement, Parent : TCodeElement;
  ModuleImport : TModuleImport;
  Variable : TVariable;
  Klass : TParsedClass;
  IsBuiltInType : Boolean;
  SafeGuard: ISafeGuard;
  LineStarts: TList;
begin
  LineStarts := TList(Guard(TList.Create, SafeGuard));
  UseModifiedSource := True;

  Module.Clear;
  Module.fSource := Source;
  Module.fCodeBlock.StartLine := 1;
  Module.fIndent := -1;  // so that everything is a child of the module

  // Change \" \' and \\ into ** so that text searches
  // for " and ' won't hit escaped ones
  //Module.fMaskedSource := fEscapedQuotesRE.Replace(Source, '**', False);
  Module.fMaskedSource := ReplaceQuotedChars(Source);

// Replace all chars in strings and comments with *
// This ensures that text searches don't mistake comments for keywords, and that all
// matches are in the same line/comment as the original
//  Module.fMaskedSource := fStringsAndCommentsRE.ReplaceEx(Module.fMaskedSource,
//    StringAndCommentsReplaceFunc);
  Module.fMaskedSource := MaskStringsAndComments(Module.fMaskedSource);

  P := PChar(Module.fMaskedSource);
  LineNo := 0;
  Stop := False;

  LastCodeElement := Module;
  while not Stop and (P^ <> #0) do begin
    GetLine(P, Line, LineNo);
    if (Length(Line) = 0) or fBlankLineRE.Exec(Line) then begin
      // skip blank lines and comment lines
    end else if fCodeRE.Exec(Line) then begin
      // found class or function definition
      CodeStart := LineNo;
      // Process continuation lines
      if ProcessLineContinuation(P, Line, LineNo, LineStarts) then
        fCodeRE.Exec(Line);  // reparse

      S := StrReplaceChars(fCodeRE.Match[4], ['(', ')'], ' ');
      if fCodeRE.Match[2] = 'class' then begin
        // class definition
        CodeElement := TParsedClass.Create;
        TParsedClass(CodeElement).fSuperClasses.CommaText := S;
      end else begin
        // function or method definition
        CodeElement := TParsedFunction.Create;
        CharOffset := fCodeRE.MatchPos[4];
        LastLength := Length(S);
        Token := StrToken(S, ',');
        CharOffset2 := CalcIndent(Token);
        Token := Trim(Token);
        While Token <> '' do begin
          Variable := TVariable.Create;
          Variable.Parent := CodeElement;
          if StrIsLeft(PChar(Token), '**') then begin
            Variable.Name := Copy(Token, 3, Length(Token) -2);
            Include(Variable.Attributes, vaStarStarArgument);
          end else if Token[1] = '*' then begin
            Variable.Name := Copy(Token, 2, Length(Token) - 1);
            Include(Variable.Attributes, vaStarArgument);
          end else begin
            Index := CharPos(Token, '=');
            if Index > 0 then begin
              Variable.Name := Trim(Copy(Token, 1, Index - 1));
              Variable.DefaultValue := Trim(Copy(Token, Index + 1, Length(Token) - Index));
              Include(Variable.Attributes, vaArgumentWithDefault);
            end else begin
              Variable.Name := Token;
              Include(Variable.Attributes, vaArgument);
            end;
          end;
          CharOffsetToCodePos(CharOffset + CharOffset2, CodeStart, LineStarts, Variable.fCodePos);
          TParsedFunction(CodeElement).fArguments.Add(Variable);

          Inc(CharOffset,  LastLength - Length(S));
          LastLength := Length(S);
          Token := StrToken(S, ',');
          CharOffset2 := CalcIndent(Token);
          Token := Trim(Token);
        end;
      end;
      CodeElement.Name := fCodeRE.Match[3];
      CodeElement.fCodePos.LineNo := CodeStart;
      CodeElement.fCodePos.CharOffset := fCodeRe.MatchPos[3];

      CodeElement.fIndent := CalcIndent(fCodeRE.Match[1]);
      CodeElement.fCodeBlock.StartLine := CodeStart;

      // Decide where to insert CodeElement
      if CodeElement.Indent > LastCodeElement.Indent then
        LastCodeElement.AddChild(CodeElement)
      else begin
        LastCodeElement.fCodeBlock.EndLine := Pred(CodeStart);
        Parent := LastCodeElement.Parent as TCodeElement;
        while Assigned(Parent) do begin
          // Note that Module.Indent = -1
          if Parent.Indent < CodeElement.Indent then begin
            Parent.AddChild(CodeElement);
            break;
          end else
            Parent.fCodeBlock.EndLine := Pred(CodeStart);
          Parent := Parent.Parent as TCodeElement;
        end;
      end;
      LastCodeElement := CodeElement;
    end else begin
      // Close Functions and Classes based on indentation
      Indent := CalcIndent(Line);
      while Assigned(LastCodeElement) and (LastCodeElement.Indent >= Indent) do begin
        // Note that Module.Indent = -1
        LastCodeElement.fCodeBlock.EndLine := Pred(LineNo);
        LastCodeElement := LastCodeElement.Parent as TCodeElement;
      end;
      // search for imports
      if fImportRE.Exec(Line) then begin
        // Import statement
        CodeStart := LineNo;
        if ProcessLineContinuation(P, Line, LineNo, LineStarts) then
          fImportRE.Exec(Line);  // reparse
        S := fImportRE.Match[1];
        CharOffset := fImportRE.MatchPos[1];
        LastLength := Length(S);
        Token := StrToken(S, ',');
        While Token <> '' do begin
          if fAliasRE.Exec(Token) then begin
            if fAliasRE.Match[3] <> '' then begin
              Token := fAliasRE.Match[3];
              CharOffset2 := fAliasRE.MatchPos[3] - 1;
            end else begin
              Token := fAliasRE.Match[1];
              CharOffset2 := fAliasRE.MatchPos[1] - 1;
            end;
            ModuleImport := TModuleImport.Create(Token, CodeBlock(CodeStart, LineNo));
            CharOffsetToCodePos(CharOffset + CharOffset2, CodeStart, LineStarts, ModuleImport.fCodePos);
            ModuleImport.Parent := Module;
            if fAliasRE.Match[3] <> '' then
              ModuleImport.fRealName := fAliasRE.Match[1];
            Module.fImportedModules.Add(ModuleImport);
          end;
          Inc(CharOffset,  LastLength - Length(S));
          LastLength := Length(S);
          Token := StrToken(S, ',');
        end;
      end else if fFromImportRE.Exec(Line) then begin
        // From Import statement
        CodeStart := LineNo;
        if ProcessLineContinuation(P, Line, LineNo, LineStarts) then
          fFromImportRE.Exec(Line);  // reparse
        ModuleImport := TModuleImport.Create(fFromImportRE.Match[1],
          CodeBlock(CodeStart, LineNo));
        ModuleImport.fCodePos.LineNo := CodeStart;
        ModuleImport.fCodePos.CharOffset := fFromImportRE.MatchPos[1];
        S := fFromImportRE.Match[2];
        if Trim(S) = '*' then
          ModuleImport.ImportAll := True
        else begin
          ModuleImport.ImportedNames := TObjectList.Create(True);
          CharOffset := fFromImportRE.MatchPos[2];
          if Pos('(', S) > 0 then begin
            Inc(CharOffset);
            S := StrRemoveChars(S, ['(',')']); //from module import (a,b,c) form
          end;
          LastLength := Length(S);
          Token := StrToken(S, ',');
          While Token <> '' do begin
            if fAliasRE.Exec(Token) then begin
              if fAliasRE.Match[3] <> '' then begin
                Token := fAliasRE.Match[3];
                CharOffset2 := fAliasRE.MatchPos[3] - 1;
              end else begin
                Token := fAliasRE.Match[1];
                CharOffset2 := fAliasRE.MatchPos[1] - 1;
              end;
              Variable := TVariable.Create;
              Variable.Name := Token;
              CharOffsetToCodePos(CharOffset + CharOffset2, CodeStart, LineStarts, Variable.fCodePos);
              Variable.Parent := ModuleImport;
              Include(Variable.Attributes, vaImported);
              if fAliasRE.Match[3] <> '' then
                Variable.fRealName := fAliasRE.Match[1];
              ModuleImport.ImportedNames.Add(Variable);
            end;
            Inc(CharOffset,  LastLength - Length(S));
            LastLength := Length(S);
            Token := StrToken(S, ',');
          end;
        end;
        ModuleImport.Parent := Module;
        Module.fImportedModules.Add(ModuleImport);
      end else if fClassAttributeRE.Exec(Line) then begin
        // search for class attributes
        Klass := GetActiveClass(LastCodeElement);
        if Assigned(Klass) then begin
          Variable := TVariable.Create;
          Variable.Name := fClassAttributeRE.Match[1];
          Variable.Parent := Klass;
          Variable.fCodePos.LineNo := LineNo;
          Variable.fCodePos.CharOffset := fClassAttributeRE.MatchPos[1];
          if fClassAttributeRE.Match[4] <> '' then begin
            Variable.ObjType := fClassAttributeRE.Match[4];
            if fClassAttributeRE.Match[5] = '(' then
              Include(Variable.Attributes, vaCall);
          end else begin
            S := Copy(Line, fClassAttributeRE.MatchPos[2]+1, MaxInt);
            Variable.ObjType := GetExpressionType(S, IsBuiltInType);
            if IsBuiltInType then
              Include(Variable.Attributes, vaBuiltIn)
            else
              Variable.ObjType := '';  // not a dotted name so we can't do much with it
          end;
          Klass.fAttributes.Add(Variable);
        end;
      end else if fVarRE.Exec(Line) then begin
        // search for local/global variables
        Variable := TVariable.Create;
        Variable.Name := fVarRE.Match[1];
        Variable.Parent := LastCodeElement;
        Variable.fCodePos.LineNo := LineNo;
        Variable.fCodePos.CharOffset := fVarRE.MatchPos[1];
        if fVarRE.Match[4] <> '' then begin
          Variable.ObjType := fVarRE.Match[4];
          if fVarRE.Match[5] = '(' then
              Include(Variable.Attributes, vaCall);
        end else begin
          S := Copy(Line, fVarRE.MatchPos[2]+1, MaxInt);
          Variable.ObjType := GetExpressionType(S, IsBuiltInType);
          if IsBuiltInType then
            Include(Variable.Attributes, vaBuiltIn)
          else
            Variable.ObjType := '';  // not a dotted name so we can't do much with it
        end;
        if LastCodeElement.ClassType = TParsedFunction then
          TParsedFunction(LastCodeElement).Locals.Add(Variable)
        else if LastCodeElement.ClassType = TParsedClass then begin
          Include(Variable.Attributes, vaClassAttribute);
          TParsedClass(LastCodeElement).Attributes.Add(Variable)
        end else begin
          Module.Globals.Add(Variable);
          if Variable.Name = '__all__' then begin
            Line := GetNthLine(Source, LineNo);
            UseModifiedSource := False;
            ProcessLineContinuation(P, Line, LineNo, LineStarts);
            if fListRE.Exec(Line) then
              Module.fAllExportsVar := fListRE.Match[1];
            UseModifiedSource := True;
          end;
        end;
      end;
    end;
    DoScannerProgress(P - PChar(Module.fMaskedSource), Length(Module.fMaskedSource), Stop);
  end;
  // Account for blank line in the end;
  if Length(Module.fMaskedSource) > 0 then begin
    Dec(P);
    if P^ in [#10, #13] then
      Inc(LineNo);
  end;
  while Assigned(LastCodeElement) do begin
    LastCodeElement.fCodeBlock.EndLine := Max(LineNo, LastCodeElement.fCodeBlock.StartLine);
    LastCodeElement := LastCodeElement.Parent as TCodeElement;
  end;

  Result := not Stop;
end;

//function TPythonScanner.StringAndCommentsReplaceFunc(
//  ARegExpr: TRegExpr): string;
//Var
//  i : integer;
//begin
//  Result := ARegExpr.Match[0];
//  if StrIsLeft(PChar(Result), '"""') or StrIsLeft(PChar(Result), '''''''') then begin
//    for i := 4 to Length(Result) - 3 do
//      if not (Result[i] in [#9, #10, #13, #32]) then
//        Result[i] := '*';
//  end else if (Result[1] = '''') or (Result[1] = '"') then begin
//    Result := Result[1] + StringOfChar('*', Length(Result)-2) + Result[1];
//  end else if Result [1] = '#' then
//    Result := sLineBreak;
//end;

{ TParsedModule }

constructor TParsedModule.Create;
begin
   inherited;
   fImportedModules := TObjectList.Create(True);
   fGlobals := TObjectList.Create(True);
   fCodePos.LineNo := 1;
   fCodePos.CharOffset := 1;
end;

procedure TParsedModule.Clear;
begin
  fSource := '';
  fMaskedSource := '';
  if Assigned(fChildren) then
    fChildren.Clear;
  fImportedModules.Clear;
  fGlobals.Clear;
  inherited;
end;

destructor TParsedModule.Destroy;
begin
  fImportedModules.Free;
  fGlobals.Free;
  inherited;
end;

function CompareVariables(Item1, Item2: Pointer): Integer;
begin
  Result := CompareStr(TVariable(Item1).Name, TVariable(Item2).Name);
end;

procedure TParsedModule.GetUniqueSortedGlobals(GlobalsList: TObjectList);
Var
  i, j : integer;
  HasName : boolean;
begin
  for i := 0 to fGlobals.Count - 1 do begin
    HasName := False;
    for j := 0 to GlobalsList.Count - 1 do
      if (TVariable(fGlobals[i]).Name = TVariable(GlobalsList[j]).Name) then begin
        HasName := True;
        break;
      end;
    if not HasName then
      GlobalsList.Add(fGlobals[i]);
  end;
  GlobalsList.Sort(CompareVariables);
end;

function CompareImports(Item1, Item2: Pointer): Integer;
begin
  Result := CompareStr(TModuleImport(Item1).Name, TModuleImport(Item2).Name);
end;

procedure TParsedModule.GetSortedImports(ImportsList: TObjectList);
Var
  i : integer;
begin
  for i := 0 to ImportedModules.Count - 1 do
    ImportsList.Add(ImportedModules[i]);
  ImportsList.Sort(CompareImports);
end;

procedure TParsedModule.GetNameSpace(SList: TStringList);
{
   GetNameSpaceInternal takes care of cyclic imports
}
var
  ImportedModuleCache : TStringList;
begin
  ImportedModuleCache := TStringList.Create;
  try
    GetNameSpaceInternal(SList, ImportedModuleCache);
  finally
    ImportedModuleCache.Free;
  end;
end;

procedure TParsedModule.GetNameSpaceInternal(SList, ImportedModuleCache : TStringList);
var
  CurrentCount: Integer;
  j: Integer;
  Index: Integer;
  Path: string;
  PackageRootName: string;
  i: Integer;
  PythonPathAdder: IInterface;
  ModuleImport: TModuleImport;
  ParsedModule: TParsedModule;
begin
  if ImportedModuleCache.IndexOf(FileName) >= 0 then
    Exit;  //  Called from a circular input

  ImportedModuleCache.Add(FileName);

  inherited GetNameSpace(SList);

  //  Add from Globals
  for i := 0 to fGlobals.Count - 1 do
    SList.AddObject(TVariable(fGlobals[i]).Name, fGlobals[i]);
  //  Add from imported modules
  Path := ExtractFileDir(Self.fFileName);
  if Length(Path) > 1 then
  begin
    // Add the path of the executed file to the Python path
    PythonPathAdder := AddPathToPythonPath(Path);
  end;
  for i := 0 to fImportedModules.Count - 1 do
  begin
    ModuleImport := TModuleImport(fImportedModules[i]);
    // imported names
    if ModuleImport.ImportAll then
    begin
      // from "module import *" imports
      ParsedModule := PyScripterRefactor.GetParsedModule(ModuleImport.Name, None);
      //  Deal with modules imported themselves (yes it can happen!)
      if not Assigned(ParsedModule) or (ParsedModule = Self) then
        break;
      CurrentCount := SList.Count;
      ParsedModule.GetNameSpaceInternal(SList, ImportedModuleCache);
      // Now filter out added names for private and accounting for __all__
      if not (ParsedModule is TModuleProxy) then
        for j := Slist.Count - 1 downto CurrentCount do
        begin
          if (StrIsLeft(PChar(SList[j]), '__') and not StrIsRight(Pchar(SList[j]), '__')) or ((ParsedModule.AllExportsVar <> '') and (Pos(SList[j], ParsedModule.AllExportsVar) = 0)) then
            SList.Delete(j);
        end;
    end
    else if Assigned(ModuleImport.ImportedNames) then
      for j := 0 to ModuleImport.ImportedNames.Count - 1 do
        SList.AddObject(TVariable(ModuleImport.ImportedNames[j]).Name, ModuleImport.ImportedNames[j]);
    // imported modules
    Index := CharPos(ModuleImport.Name, '.');
    if Index = 0 then
      SList.AddObject(ModuleImport.Name, ModuleImport)
    else if Index > 0 then
    begin
      // we have a package import add implicit import name
      PackageRootName := Copy(ModuleImport.Name, 1, Index - 1);
      if SList.IndexOf(PackageRootName) < 0 then
      begin
        ParsedModule := PyScripterRefactor.GetParsedModule(PackageRootName, None);
        if Assigned(ParsedModule) then
          SList.AddObject(PackageRootName, ParsedModule);
      end;
    end;
  end;
  { TODO2 : If it is a Package, then add sub-modules and packages }
end;

function TParsedModule.GetIsPackage: boolean;
begin
  Result := PathRemoveExtension(ExtractFileName(fFileName)) = '__init__';
end;

function TParsedModule.GetAllExportsVar: string;
begin
  Result := fAllExportsVar;
end;

function TParsedModule.GetCodeHint: string;
begin
  if IsPackage then
    Result := Format(SParsedPackageCodeHint, [FileName, Name])
  else
    Result := Format(SParsedModuleCodeHint, [FileName, Name]);
end;

{ TModuleImport }

constructor TModuleImport.Create(AName : string; CB : TCodeBlock);
begin
  inherited Create;
  Name := AName;
  CodeBlock := CB;
  ImportAll := False;
  ImportedNames := nil;
end;

destructor TModuleImport.Destroy;
begin
  FreeAndNil(ImportedNames);
  inherited;
end;

function TModuleImport.GetCodeHint: string;
begin
  Result := Format(SModuleImportCodeHint, [RealName]);
end;

function TModuleImport.GetRealName: string;
begin
  if fRealName <> '' then
    Result := fRealName
  else
    Result := Name;
end;

{ TParsedFunction }

function TParsedFunction.ArgumentsString: string;
  function FormatArgument(Variable : TVariable) : string;
  begin
    if vaStarArgument in Variable.Attributes then
      Result := '*' + Variable.Name
    else if vaStarStarArgument in Variable.Attributes then
      Result := '**' + Variable.Name
    else if vaArgumentWithDefault in Variable.Attributes then
      Result := Format('%s=%s', [Variable.Name, Variable.DefaultValue])
    else
      Result := Variable.Name;
  end;

Var
  i : integer;
begin
  Result:= '';
  if fArguments.Count > 0 then begin
    Result := FormatArgument(TVariable(fArguments[0]));
    for i := 1 to fArguments.Count - 1 do
      Result := Result + ', ' + FormatArgument(TVariable(Arguments[i]));
  end;
end;

constructor TParsedFunction.Create;
begin
  inherited;
  fLocals := TObjectList.Create(True);
  fArguments := TObjectList.Create(True);
end;

destructor TParsedFunction.Destroy;
begin
  FreeAndNil(fLocals);
  FreeAndNil(fArguments);
  inherited;
end;

function TParsedFunction.GetCodeHint: string;
Var
  Module : TParsedModule;
  DefinedIn : string;
begin
  Module := GetModule;
  if Module is TModuleProxy then
    DefinedIn := Format(SDefinedInModuleCodeHint, [Module.Name])
  else
    DefinedIn := Format(SFilePosInfoCodeHint,
      [Module.FileName, fCodePos.LineNo, fCodePos.CharOffset,
       Module.Name, fCodePos.LineNo]);

  if Parent is TParsedClass then
    Result := Format(SParsedMethodCodeHint,
      [Parent.Name, Name, ArgumentsString, DefinedIn])
  else
    Result := Format(SParsedFunctionCodeHint,
      [Name, ArgumentsString, DefinedIn])
end;

procedure TParsedFunction.GetNameSpace(SList: TStringList);
Var
  i : integer;
begin
  inherited;
  // Add Locals
  for i := 0 to fLocals.Count - 1 do
    SList.AddObject(TVariable(fLocals[i]).Name, fLocals[i]);
  // Add arguments
  for i := 0 to fArguments.Count - 1 do
    SList.AddObject(TVariable(fArguments[i]).Name, fArguments[i]);
end;

{ TParsedClass }

constructor TParsedClass.Create;
begin
  inherited;
  fSuperClasses := TStringList.Create;
  fSuperClasses.CaseSensitive := True;
  fAttributes := TObjectList.Create(True);
end;

destructor TParsedClass.Destroy;
begin
  FreeAndNil(fSuperClasses);
  FreeAndNil(fAttributes);
  inherited;
end;

function TParsedClass.GetCodeHint: string;
Var
  Module : TParsedModule;
  DefinedIn : string;
begin
  Module := GetModule;
  if Module is TModuleProxy then
    DefinedIn := Format(SDefinedInModuleCodeHint, [Module.Name])
  else
    DefinedIn := Format(SFilePosInfoCodeHint,
      [Module.FileName, fCodePos.LineNo, fCodePos.CharOffset,
       Module.Name, fCodePos.LineNo]);

  Result := Format(SParsedClassCodeHint,
    [Name, DefinedIn]);
  if fSuperClasses.Count > 0 then
    Result := Result + Format(SInheritsFromCodeHint, [fSuperClasses.CommaText]);
end;

function TParsedClass.GetConstructor: TParsedFunction;
var
  BaseClassResolver : TStringList;
begin
  BaseClassResolver := TStringList.Create;
  BaseClassResolver.CaseSensitive := True;
  try
    Result := GetConstructorImpl(BaseClassResolver);
  finally
    BaseClassResolver.Free;
  end;
end;

function TParsedClass.GetConstructorImpl(
  BaseClassResolver: TStringList): TParsedFunction;
var
  Module : TParsedModule;
  S, ErrMsg: string;
  CE : TCodeElement;
  i : integer;
  BaseClass : TBaseCodeElement;
begin
  Result := nil;
  Module := GetModule;
  S  := Module.Name + '.' + Parent.Name + '.' + Name;
  if BaseClassResolver.IndexOf(S) < 0 then begin
    BaseClassResolver.Add(S);
    try
      for i := 0 to ChildCount - 1 do begin
        CE := Children[i];
        if (CE.Name = '__init__') and (CE is TParsedFunction) then
          Result := TParsedFunction(CE);
      end;

      if not Assigned(Result) then begin
        // search superclasses
        for i := 0 to fSuperClasses.Count - 1 do begin
          BaseClass := PyScripterRefactor.FindDottedDefinition(fSuperClasses[i],
            Module, self.Parent as TCodeElement, ErrMsg);
          if not (Assigned(BaseClass) and (BaseClass is TParsedClass)) then continue;
          // we have found BaseClass
          Result := TParsedClass(BaseClass).GetConstructor;
          if Assigned(Result) then break;
        end;
      end;
    finally
      BaseClassResolver.Delete(BaseClassResolver.IndexOf(S));
    end;
  end;
end;

procedure TParsedClass.GetNameSpace(SList: TStringList);
var
  BaseClassResolver : TStringList;
begin
  BaseClassResolver := TStringList.Create;
  BaseClassResolver.CaseSensitive := True;
  try
    GetNameSpaceImpl(SList, BaseClassResolver);
  finally
    BaseClassResolver.Free;
  end;
end;

procedure TParsedClass.GetNameSpaceImpl(SList: TStringList;
      BaseClassResolver : TStringList);
Var
  i : integer;
  Module : TParsedModule;
  ErrMsg: string;
  BaseClass : TBaseCodeElement;
  S : string;
begin
  Module := GetModule;
  S  := Module.Name + '.' + Parent.Name + '.' + Name;
  if BaseClassResolver.IndexOf(S) < 0 then begin
    BaseClassResolver.Add(S);
    try
      inherited GetNameSpace(SList);
      // Add attributes
      for i := 0 to fAttributes.Count - 1 do
        SList.AddObject(TVariable(fAttributes[i]).Name, fAttributes[i]);
      if fSuperClasses.Count > 0 then begin
        for i := 0 to fSuperClasses.Count - 1 do begin
          BaseClass := PyScripterRefactor.FindDottedDefinition(fSuperClasses[i],
            Module, self.Parent as TCodeElement, ErrMsg);
          if not (Assigned(BaseClass) and (BaseClass is TParsedClass)) then continue;
          // we have found BaseClass
          TParsedClass(BaseClass).GetNameSpaceImpl(SList, BaseClassResolver);
        end;
      end;
    finally
      BaseClassResolver.Delete(BaseClassResolver.IndexOf(S));
    end;
  end;
end;

procedure TParsedClass.GetUniqueSortedAttibutes(AttributesList: TObjectList);
Var
  i, j : integer;
  HasName : boolean;
begin
  for i := 0 to fAttributes.Count - 1 do begin
    HasName := False;
    for j := 0 to AttributesList.Count - 1 do
      if TVariable(fAttributes[i]).Name = TVariable(AttributesList[j]).Name then begin
        HasName := True;
        break;
      end;
    if not HasName then
      AttributesList.Add(fAttributes[i]);
  end;
  AttributesList.Sort(CompareVariables);
end;

function CodeBlock(StartLine, EndLine : integer) : TCodeBlock;
begin
  Result.StartLine := StartLine;
  Result.EndLine := EndLine;
end;

function GetExpressionType(Expr : string; Var IsBuiltIn : boolean) : string;
Var
  i :  integer;
begin
  Expr := Trim(Expr);
  if Expr = '' then begin
    Result := '';
    IsBuiltIn := False;
  end else begin
    IsBuiltIn := True;
    case Expr[1] of
      '"','''' : Result := 'str';
      '0'..'9', '+', '-' :
        begin
          Result := 'int';
          for i := 2 to Length(Expr) - 1 do begin
            if Expr[i] = '.' then begin
              Result := 'float';
              break;
            end else if not (Expr[i] in ['0'..'9', '+', '-']) then
              break;
          end;
        end;
      '{' : Result := 'dict';
      '[': Result := 'list';
    else
      if (Expr[1] = '(') and (CharPos(Expr, ',') <> 0) then
        Result := 'tuple'  // speculative
      else begin
        IsBuiltIn := False;
        Result := Expr;
      end;
    end;
  end;
end;

{ TBaseCodeElement }

function TBaseCodeElement.GetModule: TParsedModule;
begin
  Result := GetRoot as TParsedModule;
end;

function TBaseCodeElement.GetModuleSource: string;
var
  ParsedModule : TParsedModule;
begin
  ParsedModule := GetModule;
  if Assigned(ParsedModule) then
    Result := ParsedModule.Source
  else
    Result := '';
end;

function TBaseCodeElement.GetRoot: TBaseCodeElement;
begin
  Result := self;
  while Assigned(Result.fParent) do
    Result := Result.fParent;
end;


{ TVariable }

function TVariable.GetCodeHint: string;
Var
  Module : TParsedModule;
  Fmt, ErrMsg, DefinedIn : string;
  CE : TCodeElement;
begin
  Module := GetModule;
  if Module is TModuleProxy then
    DefinedIn := Format(SDefinedInModuleCodeHint, [Module.Name])
  else
    DefinedIn := Format(SFilePosInfoCodeHint,
      [Module.FileName, fCodePos.LineNo, fCodePos.CharOffset,
       Module.Name, fCodePos.LineNo]);

  if Parent is TParsedFunction then begin
    if [vaArgument, vaStarArgument, vaStarStarArgument, vaArgumentWithDefault] *
      Attributes <> []
    then
      Fmt := SFunctionParameterCodeHint
    else
      Fmt := SLocalVariableCodeHint;
  end else if Parent is TParsedClass then begin
    if vaClassAttribute in Attributes then
      Fmt := SClassVariableCodeHint
    else
      Fmt := SInstanceVariableCodeHint;
  end else if Parent is TParsedModule then begin
    Fmt := SGlobalVariableCodeHint;
  end else if Parent is TModuleImport then begin
    Fmt := SImportedVariableCodeHint;
  end else
    Fmt := '';
  Result := Format(Fmt,
    [Name, Parent.Name, DefinedIn]);

  CE := PyScripterRefactor.GetType(Self, ErrMsg);
  if Assigned(CE) then
    Result := Result + Format(SVariableTypeCodeHint, [CE.Name]);
end;

function TVariable.GetRealName: string;
begin
  if fRealName <> '' then
    Result := fRealName
  else
    Result := Name;
end;

initialization
  DocStringRE := TRegExpr.Create;
  DocStringRE.Expression := '(?sm)\"\"\"(.*?)\"\"\"|''''''(.*?)''''''';
  DocStringRE.Compile;
finalization
  FreeAndNil(DocStringRE);
end.

