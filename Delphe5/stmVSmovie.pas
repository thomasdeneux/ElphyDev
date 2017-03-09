unit stmVSmovie;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,graphics,
     util1,varconf1,Dgraphic, debug0,
     stmdef,stmObj,stmMvtX1, stmObv0, defForm,
     Ncdef2,stmPG;

type
  TVSframe=record
             x,y:single;
             ob:integer;
           end;

  TVSmovie=class(TonOff)
                obvisA:TUOlist;
                Frames:array of TVSframe;

                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;
                procedure freeRef;override;

                procedure InitMvt; override;
                procedure InitObvis;override;

                procedure calculeMvt; override;
                procedure doneMvt;override;

                function dialogForm:TclassGenForm;override;
                procedure installDialog(var form:Tgenform;var newF:boolean);
                            override;


                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;

                function getInfo:AnsiString;override;

                procedure clearVisualObjects;
                procedure addObvis(ob:typeUO);

                function valid:boolean;override;
                procedure processMessage(id: integer; source: typeUO; p: pointer);override;
                procedure RetablirReferences(list:Tlist);override;
                procedure ClearReferences;override;
                procedure AddToStimList(list:Tlist);override;

                function getFrame(i:longWord):integer;
                procedure AddFrame(x1,y1:single;num:integer);
                procedure ClearFrames;
                property Frame[i:longWord]:integer read getFrame;

                procedure AfficheC;override;
                function isVisual:boolean;override;
              end;


procedure proTVSmovie_create(var pu:typeUO);pascal;
procedure proTVSmovie_create_1(name:AnsiString;var pu:typeUO);pascal;

procedure proTVSmovie_AddVisualObject(var ob:typeUO;var pu:typeUO);pascal;
procedure proTVSmovie_AddFrame(x,y:float;num:integer;var pu:typeUO);pascal;
procedure proTVSmovie_ClearFrames(var pu:typeUO);pascal;
procedure proTVSmovie_ClearVisualObjects(var pu:typeUO);pascal;

procedure proTVSmovie_onScreen(b:boolean;var pu:typeUO);pascal;
function fonctionTVSmovie_onScreen(var pu:typeUO):boolean;pascal;
procedure proTVSmovie_onControl(b:boolean;var pu:typeUO);pascal;
function fonctionTVSmovie_onControl(var pu:typeUO):boolean;pascal;


implementation

{ TVSmovie }

constructor TVSmovie.create;
begin
  inherited;

  obvisA:=TUOlist.create;
end;

destructor TVSmovie.destroy;
var
  i:integer;
  w:typeUO;
begin
  clearVisualObjects;
  obvisA.free;
  inherited;
end;

procedure TVSmovie.freeRef;
begin
  inherited;
  clearVisualObjects;
end;

class function TVSmovie.STMClassName: AnsiString;
begin
  result:='VSmovie';
end;

function TVSmovie.dialogForm: TclassGenForm;
begin
  result:=inherited dialogForm;
end;


procedure TVSmovie.addObvis(ob: typeUO);
begin
  obvisA.Add(ob);
  refObjet(ob);
end;

procedure TVSmovie.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;

end;


procedure TVSmovie.clearVisualObjects;
var
  i:integer;
  w:typeUO;
begin
  for i:=0 to obvisA.count-1 do
  begin
    w:=obvisA[i];
    derefObjet(w);
  end;
end;

procedure TVSmovie.completeLoadInfo;
begin
  inherited;

end;

procedure TVSmovie.InitMvt;
begin
  inherited;
end;

procedure TVSmovie.InitObvis;
var
  i:integer;
begin
  for i:=0 to obvisA.Count-1 do
  with Tresizable(obvisA[i]) do prepareS;
end;

function TVSmovie.valid:boolean;
begin
  result:=length(Frames)>0;
end;

procedure TVSmovie.calculeMvt;
var
  tCycle,num:integer;
begin
  tCycle:=timeS mod dureeC;
  if tCycle<length(Frames) then
  with Frames[tCycle] do
  begin
    num:=ob;
    if (num>=0) and (num<obvisA.Count) then
      begin
        obvis:=Tresizable(obvisA[num]);
        obvis.deg.x:=x;
        obvis.deg.y:=y;
      end
    else obvis:=nil;
  end;
end;

procedure TVSmovie.doneMvt;
begin
  inherited;
  obvis:=nil;
end;

function TVSmovie.getInfo: AnsiString;
begin
  result:=inherited getInfo;
end;


procedure TVSmovie.installDialog(var form: Tgenform; var newF: boolean);
begin
  inherited;

end;


procedure TVSmovie.processMessage(id: integer; source: typeUO; p: pointer);
var
  i:integer;
begin

  case id of
    UOmsg_destroy:
      begin
        for i:=0 to obvisA.count-1 do
        if (obvisA[i]=source) then
          begin
            obvisA[i]:=nil;
            derefObjet(source);
          end;
        obvisA.Pack;
      end;
  end;

  inherited processMessage(id,source,p);
end;


function TVSmovie.getFrame(i: longword): integer;
begin
  if i<length(Frames)
    then result:=Frames[i].ob
    else result:=-1;
end;


procedure TVSmovie.AddFrame(x1,y1:single;num: integer);
begin
  setLength(Frames,length(Frames)+1);
  with Frames[high(Frames)] do
  begin
    x:=x1;
    y:=y1;
    ob:=num;
  end;
  DtON:=length(Frames);
end;

procedure TVSmovie.ClearFrames;
begin
  setLength(Frames,0);
  DtON:=0;
end;

procedure TVSmovie.AddToStimList(list: Tlist);
var
  i:integer;
begin
  if valid and active then
    begin
      list.add(self);
      for i:=0 to obvisA.count-1 do
       list.add(obvisA[i]);
    end;

end;

procedure TVSmovie.ClearReferences;
begin
  inherited;

end;

procedure TVSmovie.RetablirReferences(list: Tlist);
begin
  inherited;

end;


procedure TVSmovie.AfficheC;
var
  i:integer;
begin
  with canvasGlb do
  begin
    for i:=0 to high(Frames) do
    with Frames[i] do
    begin
      pixels[degToXC(x),degToYC(y)]:=clWhite;
    end;
  end;

end;

function TVSmovie.isVisual: boolean;
begin
  result:=true;
end;

{***************************** Méthodes STM de TVSmovie ********************}

procedure proTVSmovie_create(var pu:typeUO);
begin
  createPgObject('',pu,TVSmovie);
end;

procedure proTVSmovie_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TVSmovie);
end;

procedure proTVSmovie_AddVisualObject(var ob:typeUO;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(ob);

  TVSmovie(pu).AddObvis(ob);
end;

procedure proTVSmovie_AddFrame(x,y:float;num:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  {On accepte num out of range novembre 2008 : signifie pas d'affichage }
  TVSmovie(pu).AddFrame(x,y,num);
end;

procedure proTVSmovie_ClearFrames(var pu:typeUO);
begin
  verifierObjet(pu);

  TVSmovie(pu).ClearFrames;
end;


procedure proTVSmovie_ClearVisualObjects(var pu:typeUO);
begin
  verifierObjet(pu);

  TVSmovie(pu).ClearVisualObjects;
end;



procedure proTVSmovie_onScreen(b:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    pu.onscreen:=b;
  end;

function fonctionTVSmovie_onScreen(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    result:=pu.onScreen;
  end;

procedure proTVSmovie_onControl(b:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    pu.onControl:=b;
  end;

function fonctionTVSmovie_onControl(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    result:=pu.onControl;
  end;

Initialization
AffDebug('Initialization stmVSmovie',0);

  registerObject(TVSmovie,stim);


end.
