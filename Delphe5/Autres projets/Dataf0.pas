unit Dataf0;
                  { ne fait pas partie de DAC2 }

interface

uses winProcs, winTypes, classes, forms,
     graphics,
     util1,Gdos,dtf0,Spk0,Dtrace1,ficDefAc,Dgrad1,
     visu0,tpVector,cood0;


type
  { Tdata contient
           - un objet data0 (PdataE) qui décrit les données
           - un objet visu (TvisuInfo) qui contient les paramètres d'affichage
           - une forme qui permet de visualiser les données
             cette forme devrait contenir un menu permettant toutes les
             opérations de base sur une trace

    L'allocation et la libération de data0 ne sont pas pris en charge par Tdata
  }
  Tdata=class
          stIdent:string;
          data0:PdataE;
          visu:TvisuInfo;
          voieEv:integer;     { de 1 à 16 }
          form:Tform;
          visu0:^TvisuInfo;

          constructor create;
          procedure cadrerX(sender:Tobject);
          procedure cadrerY(sender:Tobject);
          function chooseCoo:boolean;
          procedure paintForm(sender:Tobject);
          procedure show(owner:Tcomponent);
        end;


{ TSeqDescriptor est utilisé par getSeqInfo (ci-dessous) et contient les
  paramètres décrivant une séquence d'un fichier de données }

  TSeqDescriptor=record
                   offsetS:longint;
                   nbptS:longint;
                   x0,dx0,y0,dy0:double;
                   tpS:typeTypeG;
                 end;

{ TfileDescriptor est l'objet permettant le chargement d'un fichier de données }
{ Il devrait exister un objet descendant de TfileDescriptor pour chaque type de
  fichier (Acquis1, ABF, Pclamp, etc...

  Un objet de ce type doit pouvoir donner toutes les info nécessaires à TdataFile
  pour créer correctement les objets data.
}
  TfileDescriptor=class
                    function init(st:string):boolean;virtual;abstract;
                    procedure getSeqInfo(num,voie:integer;
                              var desc:TSeqDescriptor);virtual;abstract;
                    function getEvtInfo(num:integer):PdataFileEv;virtual;
                    function nbvoie:integer;virtual;abstract;
                  end;

  TAC1Descriptor=class(TfileDescriptor)
                 private
                    stDat:pathStr;
                    stSP:pathStr;
                    offset:longint;
                    nbv:integer;
                    nbptSeq:longint;
                    Iru1,Iru2:longint;
                    xru1,xru2:double;
                    Jru1,Jru2:array[1..6] of longint;
                    Yru1,Yru2:array[1..6] of double;

                    x0u,dxu:double;
                    y0u,dyu:array[1..6] of double;
                    unitX:string[10];
                    unitY:array[1..6] of string[10];
                    tp:typeTypeG;
                    sampleSize:integer;

                    preseq:integer;
                    postSeq:integer;
                    EchelleSeq:boolean;

                    numSeqC:integer;
                    Fdat,Fevt:boolean;

                    statEv:TtabStatEv;
                    dataEv0:PdataFileEv;

                  public
                    destructor destroy;override;
                    function ControleEchelleX(i1,i2:longint;x1,x2:float;
                                        uX:string):boolean;
                    function ControleEchelleY(v:integer;j1,j2:longint;
                                        y1,y2:float;
                                        uy:string):boolean;

                    function initDF(st:string):boolean;
                    function initEVT(st:string):boolean;
                    function init(st:string):boolean;override;
                    procedure getSeqInfo(num,voie:integer;
                              var desc:TSeqDescriptor);override;
                    function getEvtInfo(num:integer):PdataFileEv;override;
                    function nbvoie:integer;override;
                  end;

{ TdataFile est L'OBJET permettant de charger un fichier de données et de le
  visualiser sous toutes ses formes.
}

  TdataFile=class
              channel:array[1..16] of Tdata;
              evt:    array[1..16] of Tdata;
              FileDesc:TfileDescriptor;

              constructor create;
              procedure installAcquis1File(st:string);

            end;

implementation


{****************** Méthodes de Tdata *********************************}

constructor Tdata.create;
begin
  visu.init;
end;

procedure Tdata.cadrerX(sender:Tobject);
  begin
    visu0^.cadrerX(data0);
  end;

procedure Tdata.cadrerY(sender:Tobject);
  begin
    visu0^.cadrerY(data0);
  end;


function Tdata.chooseCoo:boolean;
  var
    cooD:Tcood;
    chg:boolean;
  begin
    cooD:=Tcood.create(form);
    initVisu0;

    if cood.choose(visu0^,cadrerX,cadrerY) then
      begin
        chg:= not visu.compare(visu0^);
        visu.assign(visu0^);
      end
    else chg:=false;
    cood.free;

    DoneVisu0;

    chooseCoo:=chg;
  end;


procedure Tdata.paintForm(sender:Tobject);
begin
  if data0=nil then exit;

  with data0^ do
  begin
    if (indicemax<indicemin) then exit;

    with TpaintVector(form).paintBox1 do
    begin
      initGraphic(canvas,left,top,width,height);
      canvasGlb.font.assign(form.font);
      canvasGlb.brush.color:=form.color;
      clearWindow(form.color);
      visu.displayTrace(data0,voieEv-1);
    end;
  end;
end;

procedure Tdata.show(owner:Tcomponent);
begin
  if not assigned(form) then
    begin
      form:=TpaintVector.create(owner);
      with TpaintVector(form) do
      begin
        onPaint:=paintForm;
        coo:=ChooseCoo;
        caption:=stIdent;
      end;
    end;
  form.show;
end;


{****************** Méthodes de TfileDescriptor ******************************}

function TfileDescriptor.getEvtInfo(num:integer):PdataFileEv;
begin
  getEvtInfo:=nil;
end;

{****************** Méthodes de TAC1descriptor ******************************}

destructor TAC1Descriptor.destroy;
begin
  statEv.free;
  if dataEV0<>nil then dispose(dataEv0,done);
end;

function TAC1Descriptor.ControleEchelleX(i1,i2:longint;x1,x2:float;
                                         uX:string):boolean;
begin
  if (i1<>i2) and (x1<>x2) then
    begin
      Iru1:=i1;
      Iru2:=i2;
      Xru1:=x1;
      Xru2:=x2;
      unitx:=uX;
      Dxu:=(Xru2-Xru1)/(Iru2-Iru1);
      X0u:=Xru1-Iru1*Dxu;
      controleEchelleX:=true;
    end
  else controleEchelleX:=false;
end;

function TAC1Descriptor.ControleEchelleY(v:integer;j1,j2:longint;y1,y2:float;
                                         uy:string):boolean;
begin
  if (j1<>j2) and (y1<>y2)  then
    begin
      Jru1[v]:=J1;
      Jru2[v]:=J2;
      Yru1[v]:=y1;
      Yru2[v]:=y2;
      unitY[v]:=uY;
      Dyu[v]:=(Yru2[v]-Yru1[v])/(Jru2[v]-Jru1[v]);
      Y0u[v]:=Yru1[v]-Jru1[v]*Dyu[v];
      controleEchelleY:=true;
    end
  else controleEchelleY:=false;
end;


function TAC1Descriptor.initDF(st:string):boolean;
var
  info:typeInfoAC1;
  res:intG;
  i:integer;
  f:file;
begin
  if not fichierExiste(st) then
    begin
      messageCentral('Unable to find '+st);
      exit;
    end;
  assign(f,st);
  Greset(f,1);
  initDF:=false;

  fillchar(info,sizeof(info),0);

  Gblockread(f,info,sizeof(info),res);

  if (GIO<>0) or (info.id<>signatureAC1) then
    begin
      messageCentral(st+' is not an AC1 file');
      Gclose(f);
      exit;
    end;

  offset:=info.tailleInfo;
  nbv:=info.nbvoie;
  if (nbv<1) or (nbv>16) then
   begin
      Gclose(f);
      messageCentral('anomalous number of channels: '+Istr(nbv));
      exit;
    end;

  tp:=info.tpData;
  if byte(info.tpData)=0 then tp:=G_smallint;
  SampleSize:=tailleTypeG[tp];
  if not (tp in [G_smallint,G_single]) then
    begin
      messageCentral('Unrecognized number type '+Istr(byte(tp)));
      Gclose(f);
      exit;
    end;

  nbptSeq:=info.nbpt+longint(info.nbptEx)*32768;
  if info.continu then nbptSeq:=(GfileSize(f)-offset) div (nbv*sampleSize);

  with info do
  if not controleEchelleX(i1,i2,x1,x2,ux) then
    begin
      Gclose(f);
      messageCentral('Anomalous X-scale parameters' );
      exit;
    end;

  for i:=1 to nbV do
    with info do
    if not controleEchelleY(i,j1[i],j2[i],y1[i],y2[i],uy[i]) then
      begin
        Gclose(f);
        messageCentral('Anomalous Y-scale parameters '
          +Istr(i)+'/'+Istr(j1[i])+'/'+Istr(j2[i])+'/'+
                       Estr(y1[i],3)+'/'+Estr(j2[i],3)
          );
        exit;
      end;


  preseq:=info.preseqI;
  postSeq:=info.postSeqI;
  EchelleSeq:=info.EchelleSeqI;

  Gclose(f);
  initDF:=true;
end;

function TAC1Descriptor.initEvt(st:string):boolean;
begin
  initEvt:=false;
  if not fichierExiste(st) then exit;
  stSP:=st;

  statEV:=TtabStatEv.create;
  if not statEV.initFile(st)
    then statEv.free
    else initEvt:=true;
end;

function TAC1Descriptor.init(st:string):boolean;
  begin
    Fdat:=initDF(st);
    if Fdat
      then Fevt:=initEvt(nouvelleExtension(st,'.EVT'))
      else Fevt:=initEvt(st);
    init:=Fdat or Fevt;
  end;

procedure TAC1Descriptor.getSeqInfo(num,voie:integer;var desc:TSeqDescriptor);
var
  infoSeq:typeInfoSeqAC1;
  res:intG;
  f:file;
  i:integer;
begin
  with desc do
  begin
    nbptS:=nbptSeq;
    tpS:=tp;
    offsetS:=offset+(num-1)*(preseq+postSeq+nbptSeq*sampleSize*nbv);
    if echelleSeq and (num<>numSeqC) then
      begin
        assign(f,stDat);
        Greset(f,1);
        Gseek(f,offsetS);
        GBlockread(f,infoSeq,sizeof(infoSeq),res);
        with infoSeq do
        begin
          ControleEchelleX(i1,i2,x1,x2,uX);
          for i:=1 to nbv do
            ControleEchelleY(i,j1[i],j2[i],y1[i],y2[i],uY[i]);
        end;
        Gclose(f);
        numSeqC:=num;
      end;

    x0:=x0u;
    dx0:=dxu;
    y0:=y0u[voie];
    dy0:=dyu[voie];
    offsetS:=offsetS+preseq+sampleSize*(voie-1);
  end;
end;

function TAC1Descriptor.getEvtInfo(num:integer):PdataFileEv;
begin
  getEvtInfo:=nil;
  if Fevt then
    with statEv do
    begin
      if (num>=1) and (num<=count) then
        begin
          if dataEV0<>nil then dispose(dataEv0,done);
          with PrecEv(items[num-1])^ do
          begin
            new(PdataFileEV(dataEV0),init(stSP,debut+info,1,0,Spcount-1,true));
            dataEV0^.setConversionX(DeltaXSP,0);
            getEvtInfo:=dataEV0;
          end;
        end;
    end;
end;


function TAC1Descriptor.nbVoie:integer;
begin
  nbvoie:=nbv;
end;

constructor TdataFile.create;
var
  i:integer;
begin
  for i:=1 to 16 do
    begin
      channel[i]:=Tdata.create;
      evt[i]:=Tdata.create;
    end;
end;

procedure TdataFile.installAcquis1File(st:string);
var
  i:integer;
  desc:TseqDescriptor;
  pev:PdataFileEv;
begin
  FileDesc:=TAC1Descriptor.create;
  with fileDesc do
  begin
    if not init(st) then
      begin
        free;
        fileDesc:=nil;
        exit;
      end;

    for i:=1 to nbvoie do
      with channel[i] do
      begin
        getSeqInfo(1,i,desc);
        with desc do
        begin
          case TpS of
             G_smallint: new(PdataFileI(data0),
                          init(st,offsetS,nbvoie,0,nbptS-1,true));
             G_single:  new(PdataFileS(data0),
                          init(st,offsetS,nbvoie,0,nbptS-1,true));
          end;
          data0^.setConversionX(Dx0,X0);
          data0^.setConversionY(Dy0,Y0);
        end;
      end;

    pev:=getEvtInfo(1);
    if pev<>nil then
      begin
        for i:=1 to 16 do
          with evt[i] do
          begin
            data0:=pev;
            voieEv:=i;
            with visu do
            begin
              modeT:=14;
              Ymin:=-1;
              Ymax:=1;
            end;
          end;
      end;
  end;

end;

end.
