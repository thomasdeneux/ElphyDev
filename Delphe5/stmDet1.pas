unit stmDet1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,controls,graphics,menus,dialogs,
     util1,Gdos,Dgraphic,varconf1,debug0,Dtrace1,DdosFich,
     stmdef,stmObj,stmData0,visu0,stmDplot,stmVec1,stmPopup,formRec0,Ncdef2,
     VLcommand,stmVlist1,

     DetForm1,
     stmexe10,
     dac2File,detSave1,saveOpt1,
     stmPg,
     stmVzoom;

const
  maxVaux=3;

type
  Tdetect=
    class(Tdata0)
      info:TinfoDetect;

      Vsource:Tvector;  {vecteur extérieur}

      Vevent:Tvector;   {vecteur appartenant à Tdetect}
      Vaux:array[1..maxVAux] of Tvector;
      Vlist:TVListDF;{vecteur appartenant à Tdetect}
      Vzoom:TimageVector;

      VsourceB:Tvector;

      VecToSave:Tlist;
      XstartSave,XendSave:float;
      stSave:AnsiString;
      saveRec:TsaveRecord;

      OnDetect:Tpg2Event;

      winList:TsearchWin;

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;
      procedure freeRef;override;

      procedure createForm;override;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;

      function initialise(st:AnsiString):boolean;override;
      procedure RetablirReferences(list:Tlist);override;
      procedure resetAll;override;

      procedure setChildNames;override;
      procedure saveToStream(f:Tstream;Fdata:boolean);override;
      function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;

      procedure processMessage(id:integer;source:typeUO;p:pointer);override;

      procedure execute;virtual;

      procedure displaySubG(voie,num:integer);
      procedure saveListAsDataFile(voie:integer;modeAppend:boolean);
      procedure saveListAsText;
      procedure saveListG(voie:integer;Modeappend:boolean);

      procedure getXlimits(var visu1:TvisuInfo;voie:integer);
      procedure getYlimits(var visu1:TvisuInfo;voie:integer);

      procedure installVlist;

      procedure on10000;

      procedure installSource(v:Tvector);
      function nbDetect:integer;

      procedure changeCursors(num:integer);virtual;

    end;



procedure proTDetect_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTDetect_create_1(var pu:typeUO);pascal;
procedure proTdetect_installSource(var v:Tvector;var pu:typeUO);pascal;
procedure proTdetect_Xstart(w:float;var pu:typeUO);pascal;
function fonctionTdetect_Xstart(var pu:typeUO):float;pascal;
procedure proTdetect_Xend(w:float;var pu:typeUO);pascal;
function fonctionTdetect_Xend(var pu:typeUO):float;pascal;
procedure proTdetect_Mode(w:smallint;var pu:typeUO);pascal;
function fonctionTdetect_Mode(var pu:typeUO):smallint;pascal;

procedure proTdetect_Height(w:float;var pu:typeUO);pascal;
function fonctionTdetect_Height(var pu:typeUO):float;pascal;

procedure proTdetect_Length(w:float;var pu:typeUO);pascal;
function fonctionTdetect_Length(var pu:typeUO):float;pascal;

procedure proTdetect_InhibLength(w:float;var pu:typeUO);pascal;
function fonctionTdetect_InhibLength(var pu:typeUO):float;pascal;

procedure proTdetect_Option1(w:boolean;var pu:typeUO);pascal;
function fonctionTdetect_Option1(var pu:typeUO):boolean;pascal;

procedure proTdetect_Execute(var pu:typeUO);pascal;
function fonctionTdetect_Vevent(var pu:typeUO):Tvector;pascal;
function fonctionTdetect_Vaux(i:smallint;var pu:typeUO):Tvector;pascal;
procedure proTdetect_Vaux(i:smallint;var v,pu:typeUO);pascal;

function fonctionTdetect_Count(var pu:typeUO):integer;pascal;

procedure proTdetect_OnDetect(p:integer;var pu:typeUO);pascal;
function fonctionTdetect_OnDetect(var pu:typeUO):integer;pascal;

implementation

constructor Tdetect.create;
var
  i:integer;
begin
  inherited create;

  with info do
  begin
    stepOption:=true;
  end;

  Vevent:=Tvector.create;
  AddTochildList(Vevent);
  with Vevent do
  begin
    notPublished:=true;
    Fchild:=true;

    visu.modeT:=DM_evt1;
    visu.Ymin:=-100;
    visu.color:=clBlue;
    visu.tailleT:=15;

    initEventList(g_longint,1);
  end;

  for i:=1 to maxVaux do
    begin
      Vaux[i]:=Tvector.create;
      AddTochildList(Vaux[i]);
      with Vaux[i] do
      begin
        notPublished:=true;
        Fchild:=true;
      end;
    end;

  Vlist:=TVlistDF.create;
  AddTochildList(Vlist);
  with Vlist do
  begin
    notPublished:=true;
    Fchild:=true;
  end;

  Vzoom:=TimageVector.create;
  AddTochildList(Vzoom);

  VecToSave:=Tlist.create;

  saveRec.init;
end;

destructor Tdetect.destroy;
var
  i:integer;
begin
  derefObjet(typeUO(Vsource));

  Vevent.free;

  for i:=1 to maxVaux do Vaux[i].free;

  Vlist.free;
  VecToSave.free;

  Vzoom.Free;

  inherited destroy;
end;

class function Tdetect.stmClassName:AnsiString;
begin
  result:='Detect';
end;

procedure Tdetect.freeRef;
begin
  inherited;

  installSource(nil);
end;


procedure Tdetect.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  if lecture then
    begin
      conf.setvarConf('source',VsourceB,sizeof(VsourceB));
    end
  else
    begin
      conf.setvarConf('source',Vsource,sizeof(Vsource));
    end;

  conf.setvarconf('info',info,sizeof(info));
end;


procedure Tdetect.resetAll;
begin
  Vzoom.installSource(Vsource);
end;


procedure Tdetect.setChildNames;
var
  i:integer;
begin
  with Vevent do
  begin
    ident:=self.ident+'.Vevent';
    notPublished:=true;
    Fchild:=true;
  end;

  with Vlist do
  begin
    ident:=self.ident+'.Vlist';
    notPublished:=true;
    Fchild:=true;
  end;

  with Vzoom do
  begin
    ident:=self.ident+'.Vzoom';
    notPublished:=true;
    Fchild:=true;
  end;


  for i:=1 to maxVaux do
    with Vaux[i] do
    begin
      ident:=self.ident+'.Vaux'+Istr(i);
      notPublished:=true;
      Fchild:=true;
    end;

end;

function Tdetect.initialise(st:AnsiString):boolean;
begin
  result:=inherited initialise(st);
  setChildNames;
end;

procedure Tdetect.saveToStream(f:Tstream;Fdata:boolean);
var
  i:integer;
begin
  inherited saveToStream(f,Fdata);

  VEvent.saveToStream(f,Fdata);
  Vlist.saveToStream(f,Fdata);
  for i:=1 to maxVaux do Vaux[i].saveToStream(f,Fdata);
  Vzoom.saveToStream(f,Fdata);
end;

function Tdetect.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
var
  i:integer;
begin
  result:=inherited loadFromStream(f,size,Fdata);

  if not result then exit;

  if f.position>=f.size then exit;

  if result then result:=Vevent.loadAsChild(f,Fdata);
  if result then result:=Vlist.loadAsChild(f,Fdata);

  for i:=1 to maxVaux do
    if result then result:=Vaux[i].loadAsChild(f,Fdata);

  if result then result:=Vzoom.loadAsChild(f,Fdata);

  if not Fdata then
  begin
    if assigned(Vsource)
      then Vevent.initEventList(g_longint,Vsource.dxu)
      else Vevent.initEventList(g_longint,1);
    for i:=1 to maxVaux do Vaux[i].initList(g_single);
  end;
  
  setChildNames;
end;


procedure Tdetect.RetablirReferences(list:Tlist);
var
  i:integer;
  p:pointer;
begin
  for i:=0 to list.count-1 do
    begin
     p:=typeUO(list.items[i]).myAd;
     if p=VsourceB then
       begin
         Vsource:=list.items[i];
         refObjet(Vsource);
       end;
    end;
end;

procedure Tdetect.processMessage(id:integer;source:typeUO;p:pointer);
begin
  if assigned(form) and (Vzoom=source)
    then TdetPanel(form).processMessage(id,source,p);

  case id of
    UOmsg_destroy:
      begin
        if Vsource=source then
          begin
            Vsource:=nil;
            derefObjet(source);
          end;
      end;

  end;
end;

procedure Tdetect.createForm;
begin
  form:=TDetPanel.create(formStm);
  with TdetPanel(form) do
  begin
    caption:=ident;

    executeD:=execute;
    nbDetectionD:=nbDetect;
    installe(self,info,Vsource,Vzoom);
    Uplot:=Vzoom;
  end;
end;

procedure Tdetect.on10000;
const
  cnt:integer=0;
begin
  if assigned(form) then
    with TdetPanel(form) do
    begin
      PnbDet.caption:='N='+Istr(Vevent.Iend);
      PnbDet.refresh;

      inc(cnt);
      if cnt mod 5=0 then
        begin
          if shapeExe.brush.color=clLime
            then shapeExe.brush.color:=clBtnFace
            else shapeExe.brush.color:=clLime;
          shapeExe.Refresh;
        end;
    end;
end;

procedure Tdetect.execute;
var
  i:integer;
begin
  if not assigned(Vsource) then exit;

  Vevent.initEventList(g_longint,Vsource.dxu);

  for i:=1 to maxVaux do Vaux[i].initList(g_single);

  every10000:=on10000;

  if assigned(form) then TdetPanel(form).shapeExe.visible:=true;

  with info do
  begin
    case mode of
      MDmax:     SearchExtrema(Vsource,Vevent,xStartD,xEndD,h,linhib,true,false,
                 Vaux[1],Vaux[2],Vaux[3],WinList);
      MDmin:     SearchExtrema(Vsource,Vevent,xStartD,xEndD,h,linhib,false,true,
                 Vaux[1],Vaux[2],Vaux[3],WinList);
      MDminmax:  SearchExtrema(Vsource,Vevent,xStartD,xEndD,h,linhib,true,true,
                 Vaux[1],Vaux[2],Vaux[3],WinList);

      MDstepUp:   searchSteps(Vsource,Vevent,xStartD,xEndD,h,l,linhib,true,false,
                  Vaux[1],Vaux[2],Vaux[3],StepOption,WinList);
      MDstepDw:   searchSteps(Vsource,Vevent,xStartD,xEndD,h,l,linhib,false,true,
                  Vaux[1],Vaux[2],Vaux[3],StepOption,WinList);
      MDstepUpDw: searchSteps(Vsource,Vevent,xStartD,xEndD,h,l,linhib,true,true,
                  Vaux[1],Vaux[2],Vaux[3],StepOption,WinList);

      MDcrossUp:  searchCrossings(Vsource,Vevent,xStartD,xEndD,h,linhib,true,false,WinList);
      MDcrossDw:  searchCrossings(Vsource,Vevent,xStartD,xEndD,h,linhib,false,true,WinList);
      MDcrossUpDw:searchCrossings(Vsource,Vevent,xStartD,xEndD,h,linhib,true,true,WinList);

      MDslopeUp:  searchSlopes(Vsource,Vevent,xStartD,xEndD,h,l,linhib,true,false,WinList);
      MDslopeDw:  searchSlopes(Vsource,Vevent,xStartD,xEndD,h,l,linhib,false,true,WinList);
      MDslopeUpDw:searchSlopes(Vsource,Vevent,xStartD,xEndD,h,l,linhib,true,true,WinList);
    end;
  end;

  Vevent.invalidate;
  installVlist;
  for i:=1 to maxVaux do Vaux[i].invalidate;

  on10000;
  if assigned(form) then TdetPanel(form).shapeExe.visible:=false;

  with onDetect do
    if valid then pg.executerProcedure1(ad,tagUO);

end;

procedure Tdetect.displaySubG(voie,num:integer);
var
  oldVisu1:TvisuInfo;
  delta:float;
begin
  with Vlist do
  begin
    oldVisu1:=Vzoom.visu;

    delta:=Ymax-Ymin;

    Vzoom.visu:=visu;
    Vzoom.Xmin:=Vevent.Yvalue[num]+Xmin;
    Vzoom.Xmax:=Vevent.Yvalue[num]+Xmax;

    Vzoom.displayInside(nil,false,false,false);

    Vzoom.visu:=oldVisu1;

    {
    if (num=ligne1) and assigned(CommandForm)
      then CommandForm.setTexte('x='+Estr(Vevent.Yvalue[num],3));
    }
  end;
end;

procedure Tdetect.saveListAsDataFile(voie:integer;modeAppend:boolean);
var
  ac1:Tdac2file;
  i,j:integer;
begin
  ac1:=Tdac2File.create;

  ac1.channelCount:=VecToSave.count;

  ac1.Xorg:=XstartSave;
  for i:=0 to VecToSave.count-1 do
    ac1.setChannel(i+1,Tvector(VecToSave.items[i]),XstartSave,XendSave);


  if modeAppend then
    begin
      ac1.append(stSave);
      if ac1.error<>0 then
        begin
          messageCentral('Error opening '+stSave);
          ac1.free;
          exit;
        end;
    end
  else
    begin
      ac1.createFile(stSave);
      if ac1.error<>0 then
        begin
          messageCentral('Error creating '+stSave);
          ac1.free;
          exit;
        end;
    end;

  with Vlist do
  begin
    for i:=1 to count do
      if selected[i] then
        begin
          for j:=0 to VecToSave.count-1 do
            ac1.setChannel(j+1,Tvector(VecToSave.items[j]),
                           Vevent.Yvalue[i]+XstartSave,Vevent.Yvalue[i]+XendSave);

          ac1.save;
          if ac1.error<>0 then
            begin
              messageCentral('Error saving '+stSave);
              ac1.free;
              exit;
            end;

        end;
  end;

  ac1.close;
  ac1.free;
end;

procedure Tdetect.saveListAsText;
begin
end;

procedure Tdetect.saveListG(voie:integer;Modeappend:boolean);
var
  res:boolean;
begin
  if not assigned(Vsource) then exit;

  if VecToSave.count=0 then VecToSave.add(Vsource);

  if not DetectSave.execution(Tvector,ident+' Save',VectoSave,
                             XstartSave,XendSave,Vlist.Xmin,Vlist.Xmax,saveRec)
    then exit;

  if not sauverFichierStandard(stSave,'DAT') then exit;

  if not modeAppend and fichierExiste(stSave) then
    if MessageDlg('File already exists. Continue ?',mtConfirmation,[mbYes,mbNo],0)<>mrYes
      then exit;

  saveListAsDataFile(voie,modeAppend);


end;

procedure Tdetect.getXlimits(var visu1:TvisuInfo;voie:integer);
begin
  visu1.cadrerX(Vsource.data);
end;

procedure Tdetect.getYlimits(var visu1:TvisuInfo;voie:integer);
begin
  visu1.cadrerY(Vsource.data);
end;


procedure Tdetect.installVlist;
begin
  with Vlist do
  begin
    dataValid0:=assigned(Vzoom.Vsource) and (Vevent.Iend>=Vevent.Istart);

    if dataValid0 then
      begin
        count0:=Vevent.Iend;
        if ligne1>count0 then ligne1:=1;
      end;
    displaySub:=displaySubG;
    saveList:=saveListG;

    getXlim:=getXlimits;
    getYlim:=getYlimits;

    initForm;
    invalidate;
  end;

end;

procedure Tdetect.installSource(v:Tvector);
begin
  derefObjet(typeUO(Vsource));
  Vsource:=v;
  refObjet(typeUO(Vsource));

  if assigned(Vsource) then
  begin
    info.XstartD:=Vsource.Xstart;
    info.XendD:=Vsource.Xend;
  end;
  Vzoom.installSource(Vsource);
  if assigned(form) then
    with TdetPanel(form) do installe(self,info,Vsource,Vzoom);
end;

function Tdetect.nbDetect:integer;
begin
  result:=Vevent.Iend;
end;

procedure Tdetect.changeCursors(num: integer);
begin

end;



{************************** Méthodes STM ********************************}

procedure proTDetect_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,Tdetect);

  with TDetect(pu) do
  begin
    setChildNames;
  end;
end;

procedure proTDetect_create_1(var pu:typeUO);
begin
  proTDetect_create('', pu);
end;

procedure proTdetect_installSource(var v:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  with Tdetect(pu) do installSource(v);
end;

procedure proTdetect_Xstart(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdetect(pu) do info.XstartD:=w;
end;

function fonctionTdetect_Xstart(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tdetect(pu) do result:=info.XstartD;
end;

procedure proTdetect_Xend(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdetect(pu) do info.XendD:=w;
end;

function fonctionTdetect_Xend(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tdetect(pu) do result:=info.XendD;
end;

procedure proTdetect_Mode(w:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdetect(pu) do info.Mode:=TmodeDetect(w);
end;

function fonctionTdetect_Mode(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  with Tdetect(pu) do result:=ord(info.Mode);
end;

procedure proTdetect_Height(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdetect(pu) do info.h:=w;
end;

function fonctionTdetect_Height(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tdetect(pu) do result:=info.h;
end;

procedure proTdetect_Length(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdetect(pu) do info.l:=w;
end;

function fonctionTdetect_Length(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tdetect(pu) do result:=info.l;
end;

procedure proTdetect_InhibLength(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdetect(pu) do info.linhib:=w;
end;

function fonctionTdetect_InhibLength(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tdetect(pu) do result:=info.linhib;
end;

procedure proTdetect_Option1(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdetect(pu) do info.stepOption:=w;
end;

function fonctionTdetect_Option1(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tdetect(pu) do result:=info.stepOption;
end;


procedure proTdetect_Execute(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdetect(pu) do execute;
end;

function fonctionTdetect_Vevent(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with Tdetect(pu) do result:=@Vevent.myAd;
end;

function fonctionTdetect_Vaux(i:smallint;var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with Tdetect(pu) do result:=@Vaux[i].myad;
end;

procedure proTdetect_Vaux(i:smallint;var v,pu:typeUO);
begin
end;

function fonctionTdetect_Count(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tdetect(pu) do result:=nbDetect;
end;

procedure proTdetect_OnDetect(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdetect(pu).onDetect do setAd(p);
end;

function fonctionTdetect_OnDetect(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tdetect(pu).OnDetect.ad;
end;


Initialization
AffDebug('Initialization stmDet1',0);

registerObject(Tdetect,data);

end.

