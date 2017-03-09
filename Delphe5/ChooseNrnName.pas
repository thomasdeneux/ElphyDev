unit ChooseNrnName;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows, 
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,

  util1, AcqBrd1, debug0;

type
  TChooseNrnSym = class(TForm)
    Bsection: TButton;
    Bobjvar: TButton;
    Bvar: TButton;
    Btemplate: TButton;
    Bok: TButton;
    Bcancel: TButton;
    TreeView1: TTreeView;
    procedure BsectionClick(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
  private
    { Déclarations privées }
    cat:integer;
    stList:array[1..4] of TstringList;

    Button:array[1..4] of Tbutton;

    SelNode:TtreeNode;
    procedure FillBox;
    function execute0:AnsiString;

  public

    { Déclarations publiques }
    function Execute(board:TacqInterface):AnsiString;overload;
    function Execute(st1,st2,st3,st4:TstringList):AnsiString;overload;


  end;

function ChooseNrnSym: TChooseNrnSym;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FChooseNrnSym: TChooseNrnSym;

function ChooseNrnSym: TChooseNrnSym;
begin
  if not assigned(FChooseNrnSym) then FChooseNrnSym:= TChooseNrnSym.create(nil);
  result:= FChooseNrnSym;
end;

{ TChooseNrnSym }

function TChooseNrnSym.Execute0: AnsiString;
var
  st:AnsiString;
  i:integer;
begin
  Button[1]:=Bsection;
  Button[2]:=Bobjvar;
  Button[3]:=Bvar;
  Button[4]:=Btemplate;


  if cat=0 then cat:=3;
  SelNode:=nil;
  FillBox;

  result:='';
  if (showModal=mrOK) and (SelNode<>nil) then
  begin
    st:=SelNode.Text;
    if (st<>'') and (st[length(st)]='.') then exit;
    while SelNode.Parent<>nil do
    begin
      SelNode:=SelNode.Parent;
      st:=SelNode.Text+st;
    end;
    result:=st;
  end;

end;

function TChooseNrnSym.Execute(board:TAcqInterface): AnsiString;
var
  st:AnsiString;
  i:integer;
begin
  try
  stList[1]:=board.getNrnSymbolNames(304);
  stList[2]:=board.getNrnSymbolNames(320);
  stList[3]:=board.getNrnSymbolNames(263);
  stList[4]:=board.getNrnSymbolNames(321);

  result:=execute0;

  finally
  for i:=1 to 4 do stList[i].Free;
  end;
end;

function TChooseNrnSym.Execute(st1,st2,st3,st4:TstringList):AnsiString;
begin
  stList[1]:=st1;
  stList[2]:=st2;
  stList[3]:=st3;
  stList[4]:=st4;

  result:=execute0;
end;

procedure TChooseNrnSym.FillBox;
var
  i,NumS:integer;

procedure Fill1(rac:TTreeNode;nb:integer);
var
  i,N:integer;
  st:AnsiString;
  Anode:TTreeNode;
begin
  for i:=0 to nb-1 do
  begin
    st:=stList[cat].strings[NumS];
    N:=intG(stList[cat].Objects[NumS]);
    inc(NumS);
    Anode:=TreeView1.Items.AddChild(rac,st);
    if (st<>'') and (st[length(st)]='.') and (N>0) then Fill1(Anode,N);
  end;
end;

begin
  TreeView1.Items.Clear;

  NumS:=1;
  if stList[cat].count>0 then Fill1(nil,intG(stList[cat].Objects[0]));

  for i:=1 to 4 do
  with button[i] do
  if i=cat
    then font.Style:=[fsBold]
    else font.style:=[];
end;

procedure TChooseNrnSym.BsectionClick(Sender: TObject);
begin
  cat:=Tbutton(sender).Tag;
  FillBox;
end;

procedure TChooseNrnSym.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  SelNode:=Node;
end;

Initialization
AffDebug('Initialization ChooseNrnName',0);
{$IFDEF FPC}
{$I ChooseNrnName.lrs}
{$ENDIF}
end.
