unit Npopup;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,menus,
util1;


{TpopupPg permet de créer
   - soit un menu popup.
   - soit une arborescence de TmenuItem

 Exemple:
   var
     popPg:TpopupPg;

   begin
     popPg.clear;
     PopPg.addObject('Rubrique 1',pointer(1));
     PopPg.addObject('Rubrique 2/variante 1',pointer(21));
     PopPg.addObject('Rubrique 2/variante 2',pointer(22));
     ....
     popPg.buildPopupMenu;
     popPg.executeD:=popExecute;
   end;

 Le slash permet d'introduire des sous-menus. Le numéro fourni sera transmis
 à executeD à l'exécution.

 Pour faire apparaitre le menu en position (x,y): popPg.show(x,y);

}
type
  TpopupPg=class(TStringlist)
           private
             owner:Tcomponent;
             popup0:TpopupMenu;

             procedure execute(sender:Tobject);
             function getItem(it0:TmenuItem;st:AnsiString):TmenuItem;
           public
             executeD:procedure (p:integer) of object;

             constructor create(theOwner:Tcomponent);
             destructor destroy;override;

             procedure buildMenu(item0:TmenuItem);
             procedure buildPopupMenu;

             procedure show(x,y:integer);
           end;

implementation

constructor TpopupPg.create(TheOwner:Tcomponent);
begin
  owner:=theOwner;
end;

destructor TpopupPg.destroy;
begin
  popup0.free;
  inherited destroy;
end;

function TpopupPg.getItem(it0:TmenuItem;st:AnsiString):TmenuItem;
var
  i:integer;
  st0,st1:AnsiString;
  it:TmenuItem;
begin
  st0:=Fmaj(st);
  if st<>'-' then
  for i:=0 to it0.count-1 do
    begin
      st1:=Fmaj(it0.items[i].caption);
      if st1=st0 then
        begin
          getItem:=it0.items[i];
          exit;
        end;
    end;
  it:=TmenuItem.create(it0);
  it.caption:=st;

  it0.add(it);
  getItem:=it;

end;



procedure TpopupPg.buildMenu(item0:TmenuItem);
var
  i,p:integer;
  st,st1:AnsiString;
  tag0:integer;
  it:TmenuItem;
begin
  for i:=0 to count-1 do
    begin
      st:=strings[i];
      tag0:=intG(objects[i]);

      it:=Item0;
      while st<>'' do
      begin
        p:=pos('/',st);
        if p<=0 then p:=length(st)+1;
        st1:=copy(st,1,p-1);
        system.delete(st,1,p);

        it:=getItem(it,st1);

        with it do
        begin
          Caption:=st1;
          tag:=tag0;
          if length(st)=0 then
            begin
              tag:=tag0;
              onClick:=execute;
            end;
        end;
      end;
    end;
end;

procedure TpopupPg.buildPopUpMenu;
begin
  popup0.free;
  popup0:=TpopupMenu.create(owner);

  buildmenu(popup0.Items);
end;

procedure TpopupPg.execute(sender:Tobject);
begin
  with TmenuItem(sender) do executeD(tag);
end;

procedure TpopupPg.show(x,y:integer);
begin
  if count>0 then popup0.popup(x,y);
end;


end.
