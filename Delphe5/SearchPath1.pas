unit SearchPath1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont, Buttons,
  util1, Ddosfich;

type
  TGetSearchPath = class(TForm)
    lbDir: TListBox;
    Badd: TButton;
    Bdelete: TButton;
    Bup: TBitBtn;
    Bdown: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    procedure BaddClick(Sender: TObject);
    procedure BdeleteClick(Sender: TObject);
    procedure BupClick(Sender: TObject);
    procedure BdownClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    searchPath: AnsiString;

    procedure Execute(var searchPath1:AnsiString);
  end;

function GetSearchPath: TGetSearchPath;


procedure AddToSearchPath(stDir0:AnsiString;var searchPath:AnsiString;Fbegin:boolean);

implementation

{$R *.dfm}

var
  GetSearchPath0: TGetSearchPath;


function GetSearchPath: TGetSearchPath;
begin
  if not assigned(GetSearchPath0) then GetSearchPath0:= TGetSearchPath.Create(nil);
  result:= GetSearchPath0;
end;

function DirInSearchPath(stDir0,searchPath:AnsiString):boolean;
var
  p,i:integer;
  stDir:string;
begin
  result:=false;
  stDir0:=Fmaj(stDir0);;
  repeat
    p:= pos(';',SearchPath);
    if p=0 then p:=length(SearchPath)+1;
    if p>=1 then
    begin
      stDir:= copy(SearchPath,1,p-1);
      if Fmaj(stDir)=stDir0 then
      begin
        result:=true;
        exit;
      end;
      delete(SearchPath,1,p);
    end;
  until SearchPath='';
end;

procedure AddToSearchPath(stDir0:AnsiString;var searchPath:AnsiString;Fbegin:boolean);
begin
  if not DirInSearchPath(stDir0,searchPath) then
    if Fbegin
      then SearchPath:= stDir0+';'+SearchPath
      else SearchPath:= SearchPath+';'+stDir0;
end;


procedure StringToListBox(st:AnsiString; lb:TlistBox);
var
  p:integer;
  stDir:string;
begin

  lb.Clear;
  repeat
    p:= pos(';',st);
    if p=0 then p:=length(st)+1;
    if p>=1 then
    begin
      stDir:= copy(st,1,p-1);
      if stDir<>'' then  lb.AddItem(stDir,nil);
      delete(st,1,p);
    end;
  until st='';
  lb.ItemIndex:=lb.Count-1;
end;

procedure ListBoxToString(lb:TlistBox; var st:AnsiString);
var
  i:integer;
begin
  st:='';
  for i:=0 to lb.items.count-1 do
  begin
    st:=st+lb.items[i];
    if i<lb.Items.Count-1 then st:=st+';';
  end;

end;


procedure TGetSearchPath.BaddClick(Sender: TObject);
var
  st,stFichier:AnsiString;
begin
  if GchooseDirectory('Choose a directory','',stFichier) then
  begin
    ListBoxToString(lbDir,st);
    AddToSearchPath(stFichier,st,false);
    StringToListBox(st,lbDir);
  end;
end;


procedure TGetSearchPath.Execute(var searchPath1: AnsiString);
begin
  StringToListBox(searchPath1,lbDir);

  if showModal= mrOK
    then ListBoxToString(lbDir,SearchPath1);
end;

procedure TGetSearchPath.BdeleteClick(Sender: TObject);
begin
  with lbDir do
  begin
    if ItemIndex>=0 then Items.Delete(ItemIndex);
  end;

end;

procedure TGetSearchPath.BupClick(Sender: TObject);
var
  n:integer;
begin
  n:=lbDir.ItemIndex;
  if n>0 then
    lbDir.items.Exchange(n,n-1);
end;


procedure TGetSearchPath.BdownClick(Sender: TObject);
var
  n:integer;
begin
  n:=lbDir.ItemIndex;
  if (n>=0) and (n<lbDir.count-1) then
    lbDir.items.Exchange(n,n+1);

end;


end.
