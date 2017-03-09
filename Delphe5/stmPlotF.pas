unit stmPlotF;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,forms,controls,menus,

     util1,Gdos,DdosFich,Dgraphic,

     stmDef,stmObj,
     varconf1,stmPlot1,
     debug0,
     stmError,stmPg,Ncdef2,
     PvidCom1,
     stmPopup,tpForm0;

type
  TplotVideo = class(TPlot)

               private
                  ImageList:Tlist;

                  function getplot(i,j:integer):Tplot;
                  function getPlotCount(i:integer):integer;
                  function getImageCount:integer;

               public

                  ImageIndex:integer;

                  CommandForm:TVideoCommand;

                  property Plot[i,j:integer]:Tplot read getPlot;
                  property PlotCount[i:integer]:integer read getPlotCount;
                  property ImageCount:integer read GetImageCount;


                  constructor create;override;
                  destructor destroy;override;
                  class function STMClassName:AnsiString;override;
                  procedure freeRef;override;

                  procedure ClearImageList;
                  procedure AddPlot(p:typeUO);
                  procedure AddPlot2(p:typeUO);
                  procedure setCurrentPlot(n:integer);
                  function removePlot(p:TypeUO):integer;

                  procedure display; override;
                  procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                                          const order:integer=-1); override;


                  procedure proprietes(sender:Tobject);override;
                  procedure createForm;override;

                  procedure showCommand(sender:Tobject);
                  procedure initCommandForm;
                  procedure createCommandForm;


                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
                    override;

                  procedure completeLoadInfo;override;

                  procedure RetablirReferences(list:Tlist);override;
                  procedure resetAll;override;

                  procedure processMessage(id:integer;source:typeUO;p:pointer);
                            override;

                  function getPopUp:TpopupMenu;override;
                end;

procedure proTplotVideo_create(st:AnsiString;var pu:typeUO);pascal;
procedure proTplotVideo_create_1(var pu:typeUO);pascal;
procedure proTplotVideo_addPlot(var plot, pu:typeUO);pascal;
procedure proTplotVideo_addPlot2(var plot, pu:typeUO);pascal;
procedure proTplotVideo_Clear(var pu:typeUO);pascal;

procedure proTplotVideo_imageIndex(n:integer;var pu:typeUO);pascal;
function fonctionTplotVideo_imageIndex(var pu:typeUO):integer;pascal;

function fonctionTplotVideo_imageCount(var pu:typeUO):integer;pascal;


implementation

var
  E_addPlot2:integer;
  E_imageIndex:integer;

constructor TplotVideo.create;
begin
  inherited create;
  ImageList:=Tlist.create;
end;

destructor TplotVideo.destroy;
begin
  CommandForm.free;
  commandForm:=nil;

  ClearImageList;

  ImageList.free;
  inherited destroy;
end;

procedure TplotVideo.freeRef;
begin
  inherited;
  ClearImageList;
end;

function TplotVideo.getplot(i,j:integer):Tplot;
var
  p:Tlist;
begin
  result:=nil;
  if (i>=0) and (i<ImageList.Count) then
    begin
      p:=ImageList[i];
      if (j>=0) and (j<p.count) then result:=p[j];
    end;
end;

function TplotVideo.getPlotCount(i:integer):integer;
begin
  if (i>=0) and (i<ImageList.Count)
    then result:=Tlist(ImageList[i]).count
    else result:=0;
end;

function TplotVideo.getImageCount:integer;
begin
  result:=ImageList.count;
end;

function TplotVideo.removePlot(p:typeUO):integer;
var
  i,j:integer;
begin
  result:=0;
  for i:=0 to ImageCount-1 do
    begin
      for j:=0 to PlotCount[i]-1 do
        if plot[i,j]=p then
          begin
            Tlist(imageList[i]).items[j]:=nil;
            derefObjet(p);
            inc(result);
          end;
      Tlist(imageList[i]).pack;
    end;

end;

procedure TplotVideo.ClearImageList;
var
  i,j:integer;
  pu:typeUO;
begin
  for i:=0 to ImageCount-1 do
    begin
      for j:=0 to PlotCount[i]-1 do
        begin
          pu:=Plot[i,j];
          derefObjet(pu);
        end;
      Tlist(imageList[i]).free;
    end;
  ImageList.clear;
end;

class function TplotVideo.STMClassName:AnsiString;
begin
  STMClassName:='PlotVideo';
end;

procedure TplotVideo.addPlot(p:typeUO);
var
  list:Tlist;
begin
  list:=Tlist.create;
  list.add(p);
  refObjet(p);
  ImageList.add(list);
end;

procedure TplotVideo.addPlot2(p:typeUO);
var
  n:integer;
begin
  n:=imageCount;
  if n=0 then exit;
  refObjet(p);
  Tlist(ImageList[n-1]).add(p);
end;


procedure TplotVideo.display;
var
  j:integer;
  rectI:Trect;
  n:integer;
begin
  initCommandForm;

  if assigned(Plot[imageIndex,0]) then Plot[imageIndex,0].display;

  n:=PlotCount[imageIndex];
  if n=1 then exit;

  rectI:=Plot[imageIndex,0].getInsideWindow;
  for j:=1 to n-1 do
    begin
      with rectI do setWindow(left,top,right,bottom);
      if assigned(Plot[imageIndex,j])
        then Plot[imageIndex,j].displayInside(nil,false,false,false);
    end;
end;

procedure TplotVideo.displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);
var
  j:integer;
begin
  initCommandForm;

  for j:=0 to PlotCount[imageIndex]-1 do
      if assigned(Plot[imageIndex,j]) then
        Plot[imageIndex,j].displayInside(firstUO,extWorld,logX,logY);
end;

procedure TplotVideo.proprietes;
begin
end;

procedure TplotVideo.createForm;
begin
  inherited createForm;
end;


procedure TplotVideo.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
end;

procedure TplotVideo.completeLoadInfo;
begin
  CheckOldIdent;
end;

procedure TplotVideo.RetablirReferences(list:Tlist);
var
  i:integer;
  p:pointer;
begin
  for i:=0 to list.count-1 do
    begin
      p:=typeUO(list.items[i]).myAd;
    end;
end;

procedure TplotVideo.resetAll;
begin
  invalidateForm;
end;

procedure TplotVideo.processMessage(id:integer;source:typeUO;p:pointer);
var
  i:integer;
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_invalidate,UOmsg_invalidateData:
      begin
        for i:=0 to PlotCount[ImageIndex]-1 do
          if Plot[imageIndex,i]=source then
            begin
              messageToRef(UOmsg_invalidate,nil);
              invalidateForm;
              exit;
            end;
      end;


    UOmsg_destroy:
      begin
        removePlot(source);
      end;


  end;
end;

procedure TPlotVideo.setCurrentPlot(n:integer);
begin
  if (n>=1) and (n<=ImageList.count)
    then ImageIndex:=n-1;
  invalidate;
end;

procedure TPlotVideo.createCommandForm;
begin
  commandForm:=TVideoCommand.create(formStm);
  with commandForm do
  begin
    caption:=ident;

    modifyIcur:=setCurrentPlot;
  end;
end;

procedure TPlotVideo.initCommandForm;
begin
  if assigned(commandForm) then commandForm.initParams(ImageIndex+1,1,ImageList.count);
end;

procedure TPlotVideo.showCommand(sender:Tobject);
begin
  if not assigned(Commandform) then createCommandForm;
  if assigned(Commandform) then
    begin
      initCommandForm;
      Commandform.caption:=ident;
      Commandform.show;
    end;
end;

function TplotVideo.getPopUp:TpopupMenu;
begin
  with PopUps do
  begin
    PopUpItem(pop_TVlist0,'TVlist0_Coordinates').onclick:=ChooseCoo;
    PopupItem(pop_TVlist0,'TVlist0_ShowPlot').onclick:=self.Show;
    PopupItem(pop_TVlist0,'TVlist0_ShowCommands').onclick:=ShowCommand;

    PopupItem(pop_TVlist0,'TVlist0_Properties').onclick:=Proprietes;

    result:=pop_TVlist0;
  end;
end;


{************************ Méthodes STM **************************************}

procedure proTplotVideo_create(st:AnsiString;var pu:typeUO);
begin
  createPgObject(st,pu,TplotVideo);
end;

procedure proTplotVideo_create_1(var pu:typeUO);
begin
  createPgObject('',pu,TplotVideo);
end;

procedure proTplotVideo_addPlot(var plot, pu:typeUO);
begin
  verifierObjet(plot);
  verifierObjet(pu);

  TplotVideo(pu).addPlot(plot);
end;

procedure proTplotVideo_addPlot2(var plot, pu:typeUO);
begin
  verifierObjet(plot);
  verifierObjet(pu);

  if TplotVideo(pu).imageCount=0 then sortieErreur(E_addPlot2);
  TplotVideo(pu).addPlot2(plot);
end;


procedure proTplotVideo_Clear(var pu:typeUO);
begin
  verifierObjet(pu);

  TplotVideo(pu).ClearImageList;
  TplotVideo(pu).invalidate;
end;

procedure proTplotVideo_imageIndex(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  if (n<1) or (n>TplotVideo(pu).ImageCount)
    then sortieErreur(E_imageIndex);

  TplotVideo(pu).imageIndex:=n-1;
  TplotVideo(pu).invalidate;
end;

function fonctionTplotVideo_imageIndex(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TplotVideo(pu).imageIndex+1;
end;

function fonctionTplotVideo_imageCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TplotVideo(pu).imageCount;
end;


Initialization
AffDebug('Initialization stmPlotF',0);

installError(E_addPlot2,'TplotVideo: You must call AddPlot before addPlot2');
installError(E_imageIndex,'TplotVideo: ImageIndex out of range');

end.
