unit Formmenu;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,LCLtype,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,Menus,

  util1,debug0;

type
  TMenuForm = class(TForm)
    ListBox1: TListBox;
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations private }
    width0:integer;
  public
    { Déclarations public }
    adNinit:Pinteger;
    constructor create(Aowner:Tcomponent);
    procedure SetItems(st:AnsiString;var Ninit:Integer);
    procedure Adjust(h:integer);
    function showMenu(title,st:AnsiString;var Ninit:Integer):Integer;
    function showMenu1(title:AnsiString;list:TstringList;
                             var Ninit:Integer):Integer;

    procedure clear;
    procedure add(st:AnsiString);
    function choose(titre:AnsiString;h:integer;var Ninit:Integer):integer;
  end;

function menuForm: TmenuForm;


Function ShowMenu(owner:Tcomponent;
                  title,st:AnsiString;var Ninit,xpos,ypos:Integer):Integer;
Function ShowMenu1(owner:Tcomponent;
                  title:AnsiString;
                  list:Tstringlist;var Ninit,xpos,ypos:Integer):Integer;

type
  TprocShowPopUp=procedure (num:integer) of object;

procedure ShowPopUp(list:AnsiString;proc:TprocShowPopUp;x,y:integer);

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FmenuForm: TmenuForm;

function menuForm: TmenuForm;
begin
  if not assigned(FmenuForm) then FmenuForm:= TmenuForm.create(nil);
  result:= FmenuForm;
end;

constructor TMenuForm.create(Aowner:Tcomponent);
begin
  inherited create(Aowner);
  width0:=width;
end;

procedure TMenuForm.ListBox1Click(Sender: TObject);
var
  res:integer;
begin
  res:=TlistBox(sender).itemIndex+101;
  ModalResult:=res;
  if adNinit<>nil then
    if res>100 then adNinit^:=res-100;
end;

procedure TMenuForm.ListBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  res:integer;
begin
  res:=TlistBox(sender).itemIndex+101;
  case key of
    VK_escape:ModalResult:=2;
    VK_return:begin
                ModalResult:=res;
                if adNinit<>nil then
                  if res>100 then adNinit^:=res-100;
              end;
  end;
end;


procedure TMenuForm.SetItems(st:AnsiString;var Ninit:integer);
  var
    p:integer;
  begin
    ListBox1.items.clear;
    while st<>'' do
    begin
      p:=pos('|',st);
      if p=0 then p:=length(st)+1;
      ListBox1.items.add(copy(st,1,p-1));
      delete(st,1,p);
    end;
    if (Ninit>=1) and (Ninit<=listbox1.items.count)
      then listbox1.itemIndex:=Ninit-1;
    adNinit:=@Ninit;
  end;

procedure TMenuForm.Adjust(h:integer);
  var
    i,l,lmax,hmax:integer;
  begin
    lmax:=0;
    hmax:=0;
    canvas.font:=listBox1.font;
    with ListBox1,canvas do
    begin
      for i:=1 to items.Count do
        begin
          l:=textWidth(items[i-1]);
          if l>lmax then lmax:=l;
        end;
      hmax:=itemHeight*items.Count;
      canvas.font:=listBox1.font;
      if textWidth(caption)*2>lmax then lmax:=textWidth(caption)*2;
    end;

    lmax:= lmax+30;
    if lmax<width0+20 then ClientWidth:=width0+20
                      else ClientWidth:=lmax;
    {
    if h=0 then ClientHeight:=hmax
           else ClientHeight:=h;
    }
  end;

function TMenuForm.showMenu(title,st:AnsiString;var Ninit:Integer):Integer;
  var
    res:integer;
  begin
    caption:=title;
    setItems(st,Ninit);
    adjust(0);
    res:=showModal;
    if res>100 then res:=res-100
               else res:=0;
    showMenu:=res;
  end;

function TMenuForm.showMenu1(title:AnsiString;list:TstringList;
                             var Ninit:Integer):Integer;
  var
    res:integer;
  begin
    caption:=title;
    with listBox1 do
    begin
      items.assign(list);
      if (Ninit>=1) and (Ninit<=items.count) then itemIndex:=Ninit-1;
    end;
    adjust(0);
    res:=showModal;
    if res>100 then res:=res-100
               else res:=0;
    showMenu1:=res;
  end;


procedure TMenuForm.clear;
  begin
    ListBox1.items.clear;
  end;

procedure TMenuForm.add(st:AnsiString);
  begin
    ListBox1.items.add(st);
  end;

function TMenuForm.choose(titre:AnsiString;h:integer;var Ninit:integer):integer;
  var
    res:integer;
  begin
    caption:=titre;
    adNinit:=@Ninit;
    adjust(h);

    if (Ninit>=1) and (Ninit<=listbox1.items.count)
      then listbox1.itemIndex:=Ninit-1;

    res:=showModal;
    if res>100 then res:=res-100
               else res:=0;
    choose:=res;
  end;



Function ShowMenu(owner:Tcomponent;
                  title,st:AnsiString;var Ninit,xpos,ypos:Integer):Integer;
  var
    res:integer;
  begin
    {menuFM:=TmenuForm.create(owner);}
    with menuForm do
    begin
      if Xpos<>0 then left:=Xpos;
      if Ypos<>0 then top:=Ypos;
      res:=showMenu(title,st,Ninit);
      Xpos:=left;
      Ypos:=top;
      {free;}
    end;
    showMenu:=res;
  end;

Function ShowMenu1(owner:Tcomponent;
                  title:AnsiString;
                  list:Tstringlist;var Ninit,xpos,ypos:Integer):Integer;
  var
    res:integer;
  begin
    {menuFM:=TmenuForm.create(owner);}
    with menuForm do
    begin
      if Xpos<0 then Xpos:=10;
      if Xpos>screen.desktopWidth-width-10 then Xpos:=screen.desktopWidth-width-10;
      if Ypos<0 then Ypos:=10;
      if Ypos>screen.desktopHeight-height-10 then Ypos:=screen.desktopHeight-Height-10;
      left:=Xpos;
      top:=Ypos;
      res:=showMenu1(title,list,Ninit);
      {free;}
    end;
    showMenu1:=res;
  end;

type
  Tpop=class
         Pop0:TpopUpMenu;
         menu:array[1..20] of TmenuItem;
         nbMenu:integer;
         OnClickUser:procedure (num:integer) of object;
         constructor create;
         destructor destroy;override;
         procedure add(st:AnsiString);
         procedure onClickB(sender:Tobject);
         procedure show(x,y:integer);
       end;

constructor Tpop.create;
begin
  pop0:=TpopUpMenu.create(nil);
end;

destructor Tpop.destroy;
var
  i:integer;
begin
  for i:=1 to nbMenu do menu[i].free;
  pop0.free;
  inherited destroy;
end;

procedure Tpop.onClickB(sender:Tobject);
begin
  onClickUser(TmenuItem(sender).tag);
end;

procedure Tpop.add(st:AnsiString);
begin
  if nbMenu>=20 then exit;
  inc(nbmenu);
  menu[nbMenu]:=TmenuItem.create(nil);
  with menu[nbMenu] do
  begin
    if st[length(st)]='*' then
      begin
        caption:=copy(st,1,length(st)-1);
        checked:=true;
      end
    else caption:=st;
    onClick:=OnClickB;
    tag:=nbMenu;
  end;
  pop0.items.add(menu[nbMenu]);
end;

procedure Tpop.show(x,y:integer);
begin
  pop0.popup(x,y);
end;

var
  pop:Tpop;

procedure ShowPopUp(list:AnsiString;proc:TprocShowPopUp;x,y:integer);
var
  p:integer;
begin
  if assigned(pop) then pop.free;

  pop:=Tpop.create;

  while list<>'' do
  begin
    p:=pos('|',list);
    if p=0 then p:=length(list)+1;
    pop.add(copy(list,1,p-1));
    delete(list,1,p);
  end;
  pop.onClickUser:=proc;
  pop.show(x,y);
end;


Initialization
AffDebug('Initialization formMenu',0);
{$IFDEF FPC}
{$I Formmenu.lrs}
{$ENDIF}
end.
