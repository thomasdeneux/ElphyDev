unit stmWindet1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     util1,Dgraphic,varconf1,
     stmdef,stmObj,stmDet1,stmWinCur,detForm1,WdetForm1,
     stmexe10,stmvec1;

type
  TwinDetect=
    class(Tdetect)
      winCur:array[1..10] of Twincur;
      Xinit,Yinit:array[1..10] of float;

      AbsCur:boolean;
      refPos:float;

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;

      procedure setChildNames;override;
      procedure createForm;override;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;

      procedure RetablirReferences(list:Tlist);override;
      procedure resetAll;override;
      procedure completeLoadInfo;override;

      procedure saveToStream(f:Tstream;Fdata:boolean);override;
      function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;
      procedure processMessage(id:integer;source:typeUO;p:pointer);
                            override;

      procedure changeCursors(num: integer);override;
      procedure cadrerCurseurs;

      Procedure BuildWinList;
      procedure execute;override;
    end;

implementation

{ TwinDetect }

constructor TwinDetect.create;
var
  i:integer;
begin
  inherited;

  for i:=1 to 10 do
    begin
      winCur[i]:=TwinCur.create;
      addTochildList(winCur[i]);
      with winCur[i] do
      begin
        notPublished:=true;
        visible:=(i=1);
        ObRef:=Vzoom;
        position[0]:=Rpoint(i*2,10);
      end;

    end;
end;

destructor TwinDetect.destroy;
var
  i:integer;
begin
  inherited;

  for i:=1 to 10 do
  begin
    winCur[i].free;
    winCur[i]:=nil;
  end;

end;


procedure TwinDetect.BuildInfo(var conf: TblocConf; lecture,
  tout: boolean);
begin
  inherited;

  conf.setvarConf('ABS',AbsCur,sizeof(AbsCur));
  conf.setvarConf('Xinit',Xinit,sizeof(Xinit));
  conf.setvarConf('Yinit',Yinit,sizeof(Yinit));
  conf.setvarConf('RefPos',RefPos,sizeof(RefPos));

end;

procedure TwinDetect.completeLoadInfo;
begin
  inherited;

end;


procedure TwinDetect.createForm;
begin
  form:=TWinDetPanel.create(formStm);
  with TWindetPanel(form) do
  begin
    caption:=ident;

    executeD:=execute;
    nbDetectionD:=nbDetect;
    installe(self,info,Vsource,Vzoom);
    Uplot:=Vzoom;
  end;

end;


procedure TwinDetect.resetAll;
var
  i:integer;
begin
  inherited;

  for i:=1 to 10 do
    begin
      winCur[i].ObRef:=Vzoom;
    end;
end;

procedure TwinDetect.RetablirReferences(list: Tlist);
begin
  inherited;

end;

class function TwinDetect.stmClassName: AnsiString;
begin
  result:='WinDetect';
end;


function TwinDetect.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
var
  i:integer;
begin
  result:= inherited loadFromStream(f,size,Fdata);

  for i:=1 to 10 do
    if result then result:=winCur[i].loadAsChild(f,Fdata);
end;


procedure TwinDetect.saveToStream(f:Tstream;Fdata:boolean);
var
  i:integer;
begin
  inherited;
  for i:=1 to 10 do winCur[i].saveToStream(f,Fdata);
end;

procedure TwinDetect.processMessage(id: integer; source: typeUO;
  p: pointer);
begin
  inherited;
end;


procedure TwinDetect.setChildNames;
var
  i:integer;
begin
  inherited;
  for i:=1 to 10 do
    with winCur[i] do
    begin
      ident:=self.ident+'.Cursor'+Istr(i);
      {notPublished:=true;}
      Fchild:=true;
    end;
end;

procedure TwinDetect.changeCursors(num: integer);
var
  i:integer;
  p:TWposition;
  x0,yref,delta:float;
begin
  if (num<Vevent.Istart) or (num>Vevent.Iend) then exit;

  x0:=Vevent.Yvalue[num];
  if not absCur then
    yref:=Vsource.Rvalue[x0+refpos];

  for i:=1 to 10 do
    with wincur[i] do
    begin
       p:=Wposition;
       p.x:=x0+Xinit[i];
       if absCur
         then p.y:=Yinit[i]
         else p.y:=yref+Yinit[i];
       Wposition:=p;
    end;

  if not absCur then
  with Vzoom do
  begin
    delta:=(Ymax-Ymin)/2;
    Ymin:=yref-delta;
    Ymax:=yref+delta;
  end;
end;

procedure TwinDetect.BuildWinList;
var
  i,cnt:integer;

begin
  cnt:=0;
  for i:=1 to 10 do
    if wincur[i].visible then inc(cnt);
  setLength(winList,cnt);

  cnt:=0;
  for i:=1 to 10 do
    if wincur[i].visible then
      with wincur[i],winList[cnt] do
      begin
        isAbs:=AbsCur;
        index:=roundL(Xinit[i]/Vsource.dxu);
        y1:=Yinit[i];
        y2:=Yinit[i]+Wposition.h;
        iref:=roundL(refPos/Vsource.Dxu);

        inc(cnt);
      end;
end;

procedure TwinDetect.execute;
var
  i:integer;
  xc:float;
begin
  if not assigned(Vsource) then exit;

  xc:=(Vzoom.Xmin+Vzoom.Xmax)/2;
  for i:=1 to 10 do
    with wincur[i] do
    begin
      Xinit[i]:=position[0].x-xc;
      if AbsCur
        then Yinit[i]:=position[0].y
        else Yinit[i]:=position[0].y-Vsource.Rvalue[xc+refpos];
    end;
  BuildWinList;

  inherited;

end;

procedure TwinDetect.cadrerCurseurs;
var
  i:integer;
  p:TRpoint;
begin
  for i:=1 to 10 do
    with wincur[i] do
    begin
      p:=position[0];
      p.x:=(Vzoom.Xmin+Vzoom.Xmax)/2+Xinit[i];
      position[0]:=p;
    end;
end;

Initialization
AffDebug('Initialization stmWindet1',0);

registerObject(TWinDetect,data);


end.
