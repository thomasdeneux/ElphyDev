unit HelpSearch1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont,

  util1,BrowserTest1,WordList1;

type
  THelpSearch = class(TForm)
    lbWords: TlistBoxV;
    lbTopics: TlistBoxV;
    Label1: TLabel;
    Bclear: TButton;
    Boptions: TButton;
    Label2: TLabel;
    BOK: TButton;
    Bcancel: TButton;
    esWords: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure esWordsChange(Sender: TObject);
    procedure lbWordsClick(Sender: TObject);
    procedure BclearClick(Sender: TObject);
    procedure lbTopicsDblClick(Sender: TObject);
  private
    { Déclarations privées }
    wordList:TwordList;
    lastText:string;

    procedure reset;
  public
    { Déclarations publiques }
    procedure Init(stF:string);
    function execution:string;
  end;

var
  HelpSearch: THelpSearch;

implementation

{$R *.dfm}

{ THelpSearch }

procedure THelpSearch.reset;
var
  stList:TstringList;
begin
  stList:=wordList.getWordList;
  lbWords.items.Text:=stList.Text;
  stList.Free;

  lbTopics.items.text:=wordList.TitleList.text;
end;


procedure THelpSearch.Init(stF:string);
begin
  wordList.LoadFromFile(stF);

  reset;
end;

procedure THelpSearch.FormCreate(Sender: TObject);
begin
  wordList:=TwordList.create;
end;

procedure THelpSearch.FormDestroy(Sender: TObject);
begin
  wordList.free;
end;

procedure THelpSearch.esWordsChange(Sender: TObject);
var
  st:string;

  i,nb:integer;
  list:Tlist;
  Wlist:TstringList;
begin
  st:=esWords.text;
  if st<>lastText then
  with wordList do
  begin
    if length(st)<2 then reset
    else
    begin
      lbTopics.items.beginUpdate;
      lbTopics.Items.Clear;

      lbWords.Items.beginUpdate;
      lbWords.Items.Clear;

      list:=Tlist.create;
      Wlist:=TstringList.Create;

      getLists(st,Wlist,list);

      lbWords.items.assign(Wlist);

      with list do
        for i:=0 to count-1 do
          lbTopics.Items.Add(titleList[integer(items[i])]);

      lbTopics.items.endUpdate;
      lbWords.Items.endUpdate;

      list.Free;
      Wlist.free;
    end;
    lastText:=st;
  end;
end;

function THelpSearch.execution: string;
var
  n:integer;
  st:string;
begin
  if (showModal=mrOK) and (lbTopics.itemIndex>=0) then
  begin
    st:=lbTopics.items[lbTopics.itemIndex];
    with wordList do
    begin
      n:=TitleList.IndexOf(st);
      result:= PageList[n];
    end;
  end
  else result:='';
end;

procedure THelpSearch.lbWordsClick(Sender: TObject);
begin
  esWords.Text:=lbWords.Items[lbWords.itemIndex];
end;

procedure THelpSearch.BclearClick(Sender: TObject);
begin
  esWords.Text:='';
end;

procedure THelpSearch.lbTopicsDblClick(Sender: TObject);
begin
  modalResult:=mrOK;
end;


end.
