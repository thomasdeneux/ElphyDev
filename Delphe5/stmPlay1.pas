unit stmPlay1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,
     util1,Dgraphic,varconf1,
     stmDef,stmObj,stmdata0,stmVec1,Daffac1,multg1,
     wave1;

type
  TvectorList=
    class(Tlist)
    private
      owner:typeUO;
      FlistB:PPointerList;
      FsizeB:integer;



      function GetVec(Index: Integer): Tvector;
      procedure PutVec(Index: Integer; Item: Tvector);


    public
      constructor create(owner1:typeUO);
      property Items[Index: Integer]: Tvector read GetVec write PutVec; default;

      function Add(Item: Tvector): Integer;
      function Remove(Item: Tvector): Integer;
      procedure clear;override;

      procedure BuildInfo(stN:AnsiString;var conf:TblocConf;lecture:boolean);
      procedure RetablirReferences(list:Tlist);
      function processMessage(id:integer;source:typeUO;p:pointer):boolean;
    end;


  TplayerInfo=record
                P0,Pstart,Pend:float;
                Gm,Offm:single;
              end;

  TvectorPlayer=
    class(Tdata0)
    private
      Fplaying:boolean;
      wave:Twave;

      function getBplay:boolean;
      procedure setBplay(w:boolean);


      procedure setGm(w:single);

      procedure setVolume(w:longword);
      function getVolume: longWord;

    public
      info:TplayerInfo;
      VecList:Tvectorlist;

      property Bplay:boolean read getBplay write setBplay;
      property Gm:single read info.Gm write setGm;
      property Volume:longWord read getVolume write setVolume;

      procedure buildAcqContext;

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;

      procedure createForm;override;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;

      function initialise(st:AnsiString):boolean;override;
      procedure RetablirReferences(list:Tlist);override;
      procedure resetAll;override;
      procedure completeLoadInfo;override;


      procedure processMessage(id:integer;source:typeUO;p:pointer);
                            override;
      procedure verifyInfo;

      procedure PlayC;
      procedure StopC;
      procedure hideC;

      procedure DisplayTime(tt:integer);

      procedure ClearList;
      procedure AddToList(v:Tvector);
    end;

type
  TthreadAff=class(Tthread)
               VPlayer:TvectorPlayer;
               acqContext:TacqContext;
               ITcont0,ITcont1,ITcont2:integer;
               ITmax:integer;
               Fstop:boolean;
               TickCount0:integer;
               periodeMS:float;

               constructor create(vp:TvectorPlayer;acqCont:TacqContext;
                                  periode:float;I0,Imax:integer);
               procedure DisplayTime;
               function getTime:integer;
               procedure DoAffImmediat;

               procedure execute;override;
             end;

var
  threadAff:TthreadAff;

implementation

uses Fplayer1;

{ TvectorList }

constructor TvectorList.create(owner1: typeUO);
begin
  owner:=owner1;
  inherited create;
end;


function TvectorList.GetVec(Index: Integer): Tvector;
begin
  result:=get(index);
end;

procedure TvectorList.PutVec(Index: Integer; Item: Tvector);
begin
  put(index,item);
end;

function TvectorList.Add(Item: Tvector): Integer;
begin
  if assigned(item) and (indexof(item)<0) then
  begin
    result:= inherited add(item);
    owner.refObjet(item);
  end
  else result:=-1;

end;

function TvectorList.Remove(Item: Tvector): Integer;
begin
  if assigned(item) and (indexof(item)>=0) then
  begin
    result:= inherited remove(item);
    owner.derefObjet(typeUO(item));
  end
  else result:=-1;

end;


procedure TvectorList.clear;
var
  i:integer;
  p:typeUO;
begin
  for i:=0 to count-1 do
  begin
    p:=items[i];
    owner.derefObjet(p);
  end;
  inherited;
end;

procedure TvectorList.BuildInfo(stN:AnsiString;var conf: TblocConf; lecture: boolean);
begin
  if lecture
    then conf.SetDynConf(stN,FlistB,FsizeB)
  else
    begin
      FsizeB:=count*4;
      FlistB:=@list[0];
      conf.SetDynConf(stN,FlistB,FsizeB)
    end;
end;

procedure TvectorList.RetablirReferences(list: Tlist);
var
  i,j:integer;
  p:pointer;
begin
  if not assigned(FlistB) then exit;

  for i:=0 to list.count-1 do
    begin
     p:=typeUO(list.items[i]).myAd;
     for j:=0 to FsizeB div 4-1 do
     if FlistB^[j]=p then
         add(list.items[i]);
    end;

  FlistB:=nil;
  FsizeB:=0;
end;

function TvectorList.processMessage(id:integer;source:typeUO;p:pointer):boolean;
begin
  result:=false;

  case id of
    UOmsg_destroy:
        if remove(Tvector(source))>=0 then result:=true;
  end;
end;



{ TvectorPlayer }

constructor TvectorPlayer.create;
begin
  inherited;

  VecList:=TvectorList.create(self);

  with info do
  begin
    P0:=0;
    Pstart:=0;
    Pend:=0;

    Gm:=1;
    Offm:=0;
  end;

end;

destructor TvectorPlayer.destroy;
begin
  VecList.free;
  inherited;
end;


class function TvectorPlayer.stmClassName: AnsiString;
begin
  result:='VectorPlayer';
end;


procedure TvectorPlayer.BuildInfo(var conf: TblocConf; lecture,
  tout: boolean);
begin
  inherited;
  VecList.BuildInfo('VecList',conf,lecture);
end;

procedure TvectorPlayer.RetablirReferences(list: Tlist);
begin
  inherited;
  VecList.RetablirReferences(list);
end;


procedure TvectorPlayer.completeLoadInfo;
begin
  inherited;

end;


procedure TvectorPlayer.createForm;
begin
  form:=TfilePlayer.create(formStm);
  with TfilePlayer(form) do
  begin
    caption:=ident;
    installe(self);
  end;

end;

function TvectorPlayer.initialise(st: AnsiString): boolean;
begin

end;


procedure TvectorPlayer.processMessage(id: integer; source: typeUO;
  p: pointer);
begin
  inherited;

  case id of
    UOmsg_destroy:
      if vecList.IndexOf(source)>=0 then
      begin
        stopC;
        vecList.remove(Tvector(source));
       end;
    UOmsg_invalidateData:
      if vecList.IndexOf(source)>=0 then
      begin
        stopC;
        verifyInfo;
      end;
  end;

end;

procedure TvectorPlayer.resetAll;
begin
  inherited;

end;

procedure TvectorPlayer.verifyInfo;
var
  i:integer;
begin
  if VecList.count=0 then
  begin
    info.pstart:=0;
    info.pend:=100;
    info.p0:=0;
    exit;
  end;

  info.pstart:=-1E100;
  info.pend:=1E100;

  for i:=0 to VecList.count-1 do
  with vecList[i] do
  begin
    if Xstart>info.pstart then info.pstart:=Xstart;
    if Xend<info.pend then info.pend:=Xend;;
  end;

  with info do
  begin
    if p0<pstart then p0:=pstart;
    if p0>pend then p0:=pend;
  end;
end;

procedure TvectorPlayer.buildAcqContext;
var
  i,numF,numO:integer;
  rect1,rect2:Trect;
  uo:typeUO;
begin
  if vecList.count=0 then exit;

  AcqContext:=TacqContext.create;
  AcqContext.init(false);
  AcqContext.acqBM:=multigraph0.formG.getBM;
  AcqContext.acqPage:=multigraph0.formG.currentPage;

  AcqContext.AffTournant:=true;

  with multigraph0.formG.paintBox1 do initGraphic(canvas,left,top,width,height);
  for i:=0 to vecList.count-1 do
    begin
      rect1:=multigraph0.formG.getRect(vecList[i],numF,numO,uo);
      if numF>=0 then
      begin
        with rect1 do setWindow(left,top,right,bottom);
        with multigraph0.formG do
          rect2:=getUO(currentPage,numF,0,1).getInsideWindow;
        AcqContext.add(i,vecList[i],rect1,rect2,multigraph0.formG.curPageRec.BKcolorP,numO,false);
      end;
    end;

  doneGraphic;
end;

procedure TvectorPlayer.playC;
var
  I0:integer;
begin
  if vecList.count=0 then
  begin
    Bplay:=false;
    exit;
  end;

  if Fplaying then
  begin
    Bplay:=true;
    exit;
  end;

  buildAcqContext;

  I0:=vecList[0].invconvx(info.P0);
  AcqContext.resetWindows1(I0);

  threadAff:=TthreadAff.create(self,acqContext,vecList[0].dxu*1000,I0,vecList[0].Iend);

  Fplaying:=true;
  Bplay:=true;

  with vecList[0] do
  begin
    wave:=Twave.create(data,round(1/dxu));
    wave.seek(invconvx(info.p0));
    wave.OnEnd:=stopC;

    {
    Pour un règlage automatique:
    Gm:=64000/(Ymax-Ymin);
    Offm:=-32000*(1+2*Ymin/(Ymax-Ymin));
    }
    wave.Gm:=Gm;

    wave.Play;
  end;
end;

procedure TvectorPlayer.StopC;
begin
  Bplay:=false;
  if not Fplaying then exit;

  ThreadAff.Terminate;
  repeat until ThreadAff.Terminated;
  ThreadAff.Free;
  ThreadAff:=nil;

  AcqContext.free;
  AcqContext:=nil;

  Fplaying:=false;

  wave.free;
end;

procedure TvectorPlayer.hideC;
var
  i:integer;
begin
  stopC;

  for i:=0 to vecList.Count-1 do
    vecList[i].invalidate;
end;


function TvectorPlayer.getBplay: boolean;
begin
  result:=TfilePlayer(form).SBplay.Down;
end;

procedure TvectorPlayer.setBplay(w: boolean);
begin
  TfilePlayer(form).SBplay.Down:=w;
  TfilePlayer(form).SBstop.Down:=not w;
end;


procedure TvectorPlayer.DisplayTime(tt:integer);
begin
  if vecList.count=0 then exit;

  info.P0:=vecList[0].convx(tt);
  with TfilePlayer(form) do
    enPosition.UpdateCtrl;
end;

procedure TvectorPlayer.ClearList;
begin
  if assigned(form) then stopC;
  vecList.clear;
end;


procedure TvectorPlayer.AddToList(v: Tvector);
begin
  vecList.add(v);
end;


procedure TvectorPlayer.setGm(w: single);
begin
  info.Gm:=w;
  if assigned(wave) then wave.Gm:=w;
end;


function TvectorPlayer.getVolume: longWord;
begin
  if assigned(wave)
    then result:=wave.Volume
    else result:=0;
end;

procedure TvectorPlayer.setVolume(w: longword);
begin
  if assigned(wave)
    then wave.Volume:=w;
end;


{ TthreadAff }

constructor TthreadAff.create(vp:TvectorPlayer;acqCont: TacqContext;periode:float;
                              I0,Imax:integer);
begin
  Vplayer:=vp;
  acqContext:=acqCont;
  periodeMS:=periode;
  ITcont0:=I0;
  ITcont1:=I0;
  ITmax:=Imax;
  TickCount0:=getTickCount;

  inherited create(false);
end;

procedure TthreadAff.DisplayTime;
begin
  vplayer.displayTime(ITcont2);
end;

function TthreadAff.getTime:integer;
begin
  result:=ITcont0+round((getTickCount-TickCount0)/periodeMS);
end;

procedure TthreadAff.DoAffImmediat;
begin
  {pushCriticalVar;}
  with AcqContext.AcqBM do initGraphic(canvas,0,0,width,height);
  with AcqContext do
  begin
    AfficherSegment(iTcont1,iTcont2-1);
  end;

  AcqContext.RefreshMGrects;

  {popCriticalVar;}
  doneGraphic;
end;

procedure TthreadAff.execute;
begin
  repeat
    iTcont2:=getTime;
    if ITcont2>=ITmax then
      begin
        ITcont2:=ITmax;
        Fstop:=true;
      end;
    if itcont2>itcont1 then
      begin
        synchronize(DoAffImmediat);
        iTcont1:=iTcont2;
      end;

    synchronize(DisplayTime);

    if not FStop
      then sleepEx(50,false)
      else terminate;
  until terminated or FStop;
end;

end.
