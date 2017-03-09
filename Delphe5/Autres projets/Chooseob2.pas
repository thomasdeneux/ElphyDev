unit Chooseob2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  util1,stmDef,stmObj, ComCtrls;

type
  TChooseObject2 = class(TForm)
    GroupBox1: TGroupBox;
    Bok: TButton;
    Bcancel: TButton;
    LbUO: TListBox;
  private
    { Déclarations privées }
    tuo1:TUOclass;
  public
    { Déclarations publiques }
    function execution(TUO:TUOclass;var ob:typeUO):boolean;
  end;

var
  ChooseObject2: TChooseObject2;

implementation

{$R *.DFM}

function TChooseObject2.execution(TUO:TUOclass;var ob:typeUO):boolean;
var
  i:integer;
  ob1:typeUO;

begin
  tuo1:=tuo;

  with LBUO do
  begin
    items.clear;
    items.BeginUpDate;
    for i:=0 to syslist.count-1 do
      begin
        ob1:=TypeUO(syslist.items[i]);

        if (ob1 is tuo) and not ob1.notPublished
           then items.addObject(ob1.ident,ob1);
      end;
    items.EndUpDate;


    result:= (showModal=mrOK);

    if result and (lbUO.itemIndex>=0)
      then ob:=typeUO(lbUO.items.objects[lbUO.ItemIndex]);
  end;
end;

end.
