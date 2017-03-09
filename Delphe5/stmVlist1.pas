unit Stmvlist1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,controls,graphics,menus,forms,
     util1,Dgraphic,varconf1,debug0,NcDef2,
     stmdef,stmObj,visu0,stmVec1,stmPopup,formRec0,stmError,
     stmVlist0,
     tpVector,VLcommand,propVlist;

type
  TVlistDF=
    class(TVlist0)

    public

      voie0:integer;
      count0:integer;
      dataValid0:boolean;
      displaySub:procedure (voie,numSeq:integer) of object;
      saveList: procedure(voie:integer;append:boolean) of object;

      getXlim:procedure (var visu1:TvisuInfo;voie:integer) of object;
      getYlim:procedure (var visu1:TvisuInfo;voie:integer) of object;

      getClone1:function (voie,numseq:integer):Tvector of object;

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;

      function count:integer;override;
      function dataValid:boolean;override;
      procedure displayTrace(num:integer);override;

      procedure cadrerX(sender:Tobject);override;
      procedure cadrerY(sender:Tobject);override;

      procedure autoscaleX;override;
      procedure autoscaleY;override;

      procedure SaveSelectionG(modeAppend:boolean);override;
      function getClone(i:integer):Tvector;override;

      function Xstart:float;override;
      function Xend:float;override;

    end;



implementation

constructor TVlistDF.create;
begin
  inherited create;
end;

destructor TVlistDF.destroy;
begin
  inherited destroy;
end;

class function TVlistDF.stmClassName:AnsiString;
begin
  result:='VectorList';
end;

function TVlistDF.count:integer;
begin
  result:=count0;
end;

function TVlistDF.dataValid:boolean;
begin
  result:=dataValid0;
end;

procedure TVlistDF.displayTrace(num:integer);
begin
  if assigned(displaySub) then displaySub(voie0,num);
end;


procedure TVlistDF.cadrerX(sender:Tobject);
begin
  if assigned(getXlim)
    then getXlim(visu0^,voie0);
end;

procedure TVlistDF.cadrerY(sender:Tobject);
begin
  if assigned(getYlim)
    then getYlim(visu0^,voie0);
end;

procedure TVlistDF.autoscaleX;
begin
  if assigned(getXlim)
    then getXlim(visu,voie0);
end;

procedure TVlistDF.autoscaleY;
begin
  if assigned(getYlim)
    then getYlim(visu,voie0);
end;

procedure TVlistDF.SaveSelectionG(modeAppend:boolean);
begin
  if assigned(saveList) then saveList(voie0,modeAppend);
end;

function TVlistDF.getClone(i:integer):Tvector;
begin
  if assigned(getClone1) then result:=getClone1(voie0,i);
end;

function TVlistDF.Xend: float;
var
  visu1:TvisuInfo;
begin
  visu1:=visu;
  if assigned(getXlim) then
  begin
    getXlim(visu1,1);
    result:=visu1.Xmax;
  end
  else result:=0;
end;


function TVlistDF.Xstart: float;
var
  visu1:TvisuInfo;
begin
  visu1:=visu;
  if assigned(getXlim) then
  begin
    getXlim(visu1,1);
    result:=visu1.Xmin;
  end
  else result:=0;
end;

Initialization
AffDebug('Initialization stmVlist1',0);

registerObject(TVlistDF,sys);

end.
