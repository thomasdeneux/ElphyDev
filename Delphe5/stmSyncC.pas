unit stmSyncC;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,controls,graphics,menus,
     util1,Dgraphic,varconf1,debug0,
     stmdef,stmObj,visu0,stmDplot,stmVec1,stmPopup,formRec0,
     tpVector,VLcommand,stmVlist0,
     stmPg;

type
  TsyncList=
    class(TVList0)

    private
      FVsource:Tvector;
      FVevent:Tvector;

      procedure installSource(ref:Tvector);
      procedure installEvent(ref:Tvector);

    public
      VsourceB,VeventB:Tvector;


      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;
      procedure freeRef;override;

      property Vsource:Tvector read FVsource write installSource ;
      property Vevent:Tvector read FVevent write installEvent;

      function count:integer;override;
      function dataValid:boolean;override;
      procedure displayTrace(num:integer);override;
      procedure getLineWorld(num:integer;var x1,y1,x2,y2:float);override;

      procedure cadrerX(sender:Tobject);override;
      procedure cadrerY(sender:Tobject);override;


      procedure Proprietes(sender:Tobject);override;


      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;


      procedure RetablirReferences(list:Tlist);override;

      procedure processMessage(id:integer;source:typeUO;p:pointer);
                            override;

      function Xstart:float;override;
      function Xend:float;override;

    end;


procedure proTsyncList_create(name:AnsiString;var source,events:Tvector;var pu:typeUO);pascal;
procedure proTsyncList_create_1(var source,events:Tvector;var pu:typeUO);pascal;

implementation

uses propSyncC;

constructor TsyncList.create;
begin
  inherited create;
end;

destructor TsyncList.destroy;
begin
  Vsource:=nil;
  Vevent:=nil;

  inherited destroy;
end;

procedure TsyncList.freeRef;
begin
  inherited;
  Vsource:=nil;
  Vevent:=nil;
end;

class function TsyncList.stmClassName:AnsiString;
begin
  result:='SyncList';
end;

procedure TsyncList.installSource(ref:Tvector);
begin
  if ref=FVsource then exit;

  derefObjet(typeUO(FVsource));
  FVsource:=ref;
  refObjet(typeUO(FVsource));

  initForm;
  invalidate;
end;

procedure TsyncList.installEvent(ref:Tvector);
begin
  if ref=FVevent then exit;

  derefObjet(typeUO(FVevent));
  FVevent:=ref;
  refObjet(typeUO(FVevent));

  initForm;
  invalidate;

end;

function TsyncList.count:integer;
begin
  if assigned(Vevent) then result:=Vevent.Iend
                      else result:=0;
end;

function TsyncList.dataValid:boolean;
begin
  result:= assigned(Vsource) and assigned(Vevent)
           and (Vevent.Iend>=Vevent.Istart);

  if not result then exit;

  if ligne1<Vevent.Istart then ligne1:=Vevent.Istart;
  if ligne1>Vevent.Iend then ligne1:=Vevent.Iend;
end;

procedure TsyncList.displayTrace(num:integer);
var
  oldVisu:TvisuInfo;
  delta:float;
begin
  oldVisu:=Vsource.visu;

  delta:=Ymax-Ymin;

  Vsource.visu:=visu;
  Vsource.Xmin:=Vevent.Yvalue[num]+Xmin;
  Vsource.Xmax:=Vevent.Yvalue[num]+Xmax;

  Vsource.displayInside(nil,false,false,false);

  Vsource.visu:=oldVisu;

  {
  if (num=ligne1) and assigned(CommandForm)
    then CommandForm.setTexte('x='+Estr(Vevent.Yvalue[num],3));
  }
end;


procedure TsyncList.getLineWorld(num:integer;var x1,y1,x2,y2:float);
var
  delta:float;
begin
  x1:=0;
  x2:=0;
  y1:=0;
  y2:=0;

  if (num<1) or (num>count) then exit;

  num:=num-ligne1+1;

  if not assigned(Vevent) then exit;
  if not assigned(Vsource) then exit;

  delta:=Ymax-Ymin;

  x1:=Vevent.Yvalue[ligne1+num-1]+Xmin;
  x2:=Vevent.Yvalue[ligne1+num-1]+Xmax;
  y1:=Ymin-Delta*(nbligne-num) ;
  y2:=Ymax+Delta*(num-1) ;

end;

procedure TsyncList.cadrerX(sender:Tobject);
begin
  if assigned(Vsource) then visu0^.cadrerX(Vsource.data);
end;

procedure TsyncList.cadrerY(sender:Tobject);
begin
  if assigned(Vsource) then visu0^.cadrerY(Vsource.data);
end;



procedure TsyncList.proprietes(sender:Tobject);
begin
  if SyncCproperties.execution(self) then invalidate;
end;


procedure TsyncList.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);

  if lecture then
    begin
      conf.setvarConf('vecS',vSourceb,sizeof(vSourceb));
      conf.setvarConf('vecE',vEventb,sizeof(vEventb));
    end
  else
    begin
      conf.setvarConf('vecS',Fvsource,sizeof(Fvsource));
      conf.setvarConf('vecE',Fvevent,sizeof(Fvevent));
    end;

end;


procedure TsyncList.RetablirReferences(list:Tlist);
var
  i,j,page:integer;
  lu:Tlist;
  ppu:typeUO;
  p:pointer;
begin
  for i:=0 to list.count-1 do
    begin
      p:=typeUO(list.items[i]).myAd;
      if p=vsourceb
        then vSource:=list.items[i];

      if p=vEventb
        then vEvent:=list.items[i];
    end;
end;


procedure TsyncList.processMessage(id:integer;source:typeUO;p:pointer);
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_invalidate,UOmsg_invalidateData:
      begin
        if (vsource=source) or (vevent=source) then
          begin
            messageToRef(UOmsg_invalidate,nil);
            invalidateForm;
            initForm;
          end;
      end;


    UOmsg_destroy:
      begin
        if (vsource=source) or (vEvent=source) then
          begin
            if vSource=source
              then vSource:=nil;

            if vEvent=source
              then vEvent:=nil;

            messageToRef(UOmsg_invalidate,nil);
            invalidateForm;
          end;
      end;
  end;
end;

function TsyncList.Xstart: float;
begin
  if Vsource<>nil
    then result:= -Vsource.Xend
    else result:=0;
end;

function TsyncList.Xend: float;
begin
  if Vsource<>nil
    then result:=Vsource.Xend
    else result:=0;
end;

procedure proTsyncList_create(name:AnsiString;var source,events:Tvector;var pu:typeUO);
begin
  verifierObjet(typeUO(source));
  verifierObjet(typeUO(events));

  createPgObject(name,pu,TsyncList);

  with TsyncList(pu) do
  begin
    Vsource:=source;
    Vevent:=events;
  end;

end;

procedure proTsyncList_create_1(var source,events:Tvector;var pu:typeUO);
begin
  proTsyncList_create('',source,events,pu);
end;


Initialization
AffDebug('Initialization stmSyncC',0);

registerObject(Tsynclist,data);

end.
