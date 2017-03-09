unit SlistView1;

interface

uses classes,ovcViewR,ovcBordr,
     util1;

{ TStringListViewer se comporte comme un mémo en mode ReadOnly.
  Son intérêt est d'affecter des couleurs pour chaque ligne de texte.
}

type
  TStringListViewer=
    class(TovcBaseViewer)
    private
      list:TstringList;
      Colors:Tlist;

      function GetLinePtr(LineNum : LongInt; var Len : integer) : PAnsiChar;override;
      function getLineColor(line:integer):integer;
    public
      property Borders;
      property BorderStyle;
      property Caret;
      property ExpandTabs;
      property FixedFont;
      property HighlightColors;
      property MarginColor;
      property ScrollBars;
      property ShowBookmarks;
      property ShowCaret;
      property TabSize;
    {events}
      property OnShowStatus;
      property OnTopLineChanged;
      property OnUserCommand;


      constructor create(owner:Tcomponent);
      destructor destroy;override;
      procedure AddLine(st:string;col:integer);
      procedure Clear;

    end;


implementation

{ TStringListViewer }

procedure TStringListViewer.AddLine(st: string; col: integer);
begin
  list.add(st);
  colors.Add(pointer(col));
  lineCount:=List.count;
end;

constructor TStringListViewer.create(owner: Tcomponent);
begin
  list:=TstringList.Create;
  Colors:=Tlist.create;
  getUserColor:=getLineColor;
  inherited;
end;

destructor TStringListViewer.destroy;
begin
  inherited;
  list.free;
  colors.free;
end;

function TStringListViewer.GetLinePtr(LineNum: Integer;
  var Len: integer): PAnsiChar;
const
  st:string='';
begin
  if (lineNum>=0) and (lineNum<list.count)
    then st:=list[lineNum]
    else st:='';

  len:=length(st);
  if len=0 then st:=#0;
  result:=@st[1];
end;

function TStringListViewer.getLineColor(line: integer): integer;
begin
  if (line>=0) and (line<list.count)
    then result:=integer(colors[line])
    else result:=0;
end;

procedure TStringListViewer.Clear;
begin
  list.clear;
  colors.clear;
  lineCount:=0;
end;

end.
