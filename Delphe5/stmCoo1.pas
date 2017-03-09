unit stmCoo1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,menus,sysutils,
     util1,Dgraphic,
     stmDef,stmObj,stmDplot,stmPopup,coodCoo;

type
  TstmCoo=class(TdataPlot)
          public
            constructor create;override;
            destructor destroy;override;

            class function STMClassName:AnsiString;override;

            function ChooseCoo1:boolean;override;

            procedure display; override;

            function getPopUp:TpopUpMenu;override;

            procedure getWorldPriorities(var Fworld,FlogX,FlogY:boolean;
                                var x1,y1,x2,y2:float);override;
          end;


implementation

constructor TstmCoo.create;
begin
  inherited;
  cpEnabled:=false;
end;

destructor TstmCoo.destroy;
begin
  inherited;
end;

class function TstmCoo.STMClassName:AnsiString;
begin
  result:='Coordinates';
end;


function TstmCoo.ChooseCoo1:boolean;
var
  chg:boolean;
  title0:AnsiString;
begin
  InitVisu0;

  title0:=title;

  if getcoodcoo.choose(visu0^) then
    begin
      chg:= not visu.compare(visu0^) or (title<>title0);
      visu.assign(visu0^);
      title:=title0;
    end
  else chg:=false;

  DoneVisu0;

  chooseCoo1:=chg;
end;


procedure TstmCoo.display;
begin
  with getInsideWindow do setWindow(left,top,right,bottom);
  visu.displayScale;
end;


function TstmCoo.getPopUp:TpopUpMenu;
begin
  with PopUps do
  begin
    PopupItem(pop_Tcoo,'Tcoo_Coordinates').onClick:=ChooseCoo;

    result:=pop_Tcoo;
  end;
end;


procedure TstmCoo.getWorldPriorities(var Fworld,FlogX,FlogY:boolean;
                            var x1,y1,x2,y2:float);
begin
  Fworld:=true;
  FlogX:=visu.modelogX;
  FlogY:=visu.modelogY;

  if visu.inverseX then
    begin
      x1:=visu.Xmax;
      x2:=visu.Xmin;
    end
  else
    begin
      x1:=visu.Xmin;
      x2:=visu.Xmax;
    end;

  if visu.inverseY then
    begin
      y1:=visu.Ymax;
      y2:=visu.Ymin;
    end
  else
    begin
      y1:=visu.Ymin;
      y2:=visu.Ymax;
    end;

end;


Initialization
AffDebug('Initialization stmCoo1',0);

registerObject(TstmCoo,data);

end.
