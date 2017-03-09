unit stimForm;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  defForm, StdCtrls,
  
  stmDef,stmObj, debug0;

type
  TstimulusForm = class(TGenForm)
    Label3: TLabel;
    CBvisual: TComboBox;
    procedure CBvisualChange(Sender: TObject);
    procedure CBvisualDropDown(Sender: TObject);
  protected
    { Déclarations privées }
    NoChange:boolean;
    obvis0:^typeUO;
    owner0:typeUO;
  public
    { Déclarations publiques }
    procedure initCBvisual(ownerUO:typeUO;var ob:typeUO);
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TstimulusForm.initCBvisual(ownerUO:typeUO;var ob:typeUO);
begin
  Nochange:=true;
  obvis0:=@ob;
  owner0:=ownerUO;
  with cbVisual do
  begin
    items.clear;
    if ob<>nil
      then items.addObject(ob.ident,ob)
      else items.addObject('',nil);
    itemIndex:=0;
  end;
  NoChange:=false;

end;


procedure TstimulusForm.CBvisualChange(Sender: TObject);
begin
  inherited;
  if noChange then exit;
  if assigned(obvis0) then
    begin
      owner0.derefobjet(obvis0^);
      with CBvisual do obvis0^:=typeUO(items.objects[itemIndex]);
      owner0.refObjet(obvis0^);
    end;
end;

procedure TstimulusForm.CBvisualDropDown(Sender: TObject);
var
  st:AnsiString;
  i:integer;
begin
  inherited;
  with CBvisual do
  begin
    if (itemIndex>=0) and (itemIndex<items.count)
      then st:=items[itemIndex]
      else st:='';
    items.clear;

    for i:=0 to syslist.count-1 do
      if (typeUO(syslist.items[i]) is stmTresizable) and
         (typeUO(syslist.items[i]).ident<>'') and
         ( not (typeUO(syslist.items[i]).classname='TRF') ) then
        items.addObject(typeUO(syslist.items[i]).ident,syslist.items[i]);
    items.add('  ');
    itemIndex:=items.indexof(st);
  end;
end;

Initialization
AffDebug('Initialization stimForm',0);
{$IFDEF FPC}
{$I stimForm.lrs}
{$ENDIF}
end.
