unit ViewListG1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ovcViewr;

type
  TgetALine=function (n:integer):string of object;

  TovcListGViewer=
    class(TovcBaseViewer)
    private
      function GetLinePtr(LineNum : LongInt; var Len : integer) : PAnsiChar;override;
    public
      getALine:TgetALine;

      
    end;

type
  TListGViewer = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    Viewer:TovcListGViewer;
  public
    { Déclarations publiques }
    procedure setData(f:TgetAline;nb:integer);
  end;


implementation

{$R *.dfm}

{ TovcListGViewer }


function TovcListGViewer.GetLinePtr(LineNum: Integer;
  var Len: integer): PAnsiChar;
var
  st:string;
begin
  if not assigned(getAline) then
    begin
      len:=0;
      st:=#0;
    end
  else
    begin
      st:=getAline(lineNum);
      len:=length(st);
      if len=0 then st:=#0;
    end;

  result:=@st[1]
end;

procedure TListGViewer.FormCreate(Sender: TObject);
begin
  Viewer:=TovcListGViewer.create(self);
  with Viewer do
  begin
    Parent:=self;
    align:=alClient;
    Fixedfont.Name :='Courier New';
    Fixedfont.size:=10;
    Fixedfont.Style :=[];
  end;

end;

procedure TListGViewer.setData(f: TgetAline; nb: integer);
begin
  viewer.getAline:=f;
  viewer.LineCount := nb;
  invalidate;
end;

end.
