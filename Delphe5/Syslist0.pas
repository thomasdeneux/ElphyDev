unit syslist0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls,

  util1,Dgraphic,editCont,formMenu,
  stmDef,stmObj,objName1,defForm,debug0;

type
  TWsyslist = class(TForm)
    ListBox1: TListBox;
  private
    { Déclarations private }

  public
    { Déclarations public }
    procedure Execution;
  end;

var
  Wsyslist:TWsyslist;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TWsyslist.execution;
var
  i:integer;
begin
  with ListBox1 do
  begin
    clear;
    for i:=0 to syslist.count-1 do
        items.addObject(TypeUO(syslist.items[i]).ident,sysList.items[i]);
  end;
  showModal;
end;


Initialization
AffDebug('Initialization Syslist0',0);
{$IFDEF FPC}
{$I syslist0.lrs}
{$ENDIF}
end.
