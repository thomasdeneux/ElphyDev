unit revmat1;

interface

uses classes,dialogs,controls,math,
     util1,Gdos,Dgraphic,dtf0,spk0,
     stmdef, stmObj,stmData0,stmvec1,stmmat1,varconf1,stmError,Ncdef2,debug0,
     revMprop;

type
  TrevMatrix=
    class(Tmatrix)
    private

      FDataVec:Tvector;    {vecteur d'événements détectés }
      FDataVecB:Tvector;   {image pour sauvegarde}

      Nx,Ny:integer;

      Zact:integer;
      t1,t2,dt:float;
      ipmin,ipmax:Integer;

      ip1,ip2:integer;

      Up:Tlist;
      PsthSize:integer;

      procedure setPsth(i,j,k,l:integer;x:integer);
      function getPsth(i,j,k,l:integer):integer;
      procedure incPsth(i,j,k,l:integer);

      procedure decode(code:integer;var x,y,z:integer);
      procedure clearUp;

      procedure setDataVec(v:Tvector);

    public
      stEvt:string;

      constructor create;override;
      destructor destroy;override;

      class function STMClassName:string;override;

      function initialise(st:string):boolean;override;
      procedure proprietes(sender:Tobject);override;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
        override;


      procedure RetablirReferences(list:Tlist);override;

      procedure processMessage(id:integer;source:typeUO;p:pointer);
                override;


      property psth[i,j,k,l:integer]:integer read getPsth write setPsth;
      function InitPsth:boolean;

      procedure CalculPsth;
      procedure calculeMat;
      procedure calculeTout;

      procedure scrollIPG1(x:float);
      procedure scrollIPG2(x:float);


      property DataVec:Tvector read FDataVec write setDataVec;
    end;

procedure proTrevMatrix_EvtFile(st:shortString;var pu:typeUO);pascal;
function fonctionTrevMatrix_EvtFile(var pu:typeUO):shortstring;pascal;

procedure proTrevMatrix_calculate(var pu:typeUO);pascal;
procedure proTrevMatrix_setDataVector(var source1:Tvector;var pu:typeUO);pascal;

implementation

constructor Trevmatrix.create;
begin
  inherited;
  up:=Tlist.create;

  Zact:=1;

  t1:=0;
  t2:=0.200;
  dt:=0.001;

  visu.inverseY:=true;
end;

destructor Trevmatrix.destroy;
begin
  clearUp;
  up.free;
  dereferenceObjet(typeUO(FdataVec));
  inherited;
end;


class function Trevmatrix.STMClassName:string;
begin
  result:='RevMat';
end;

function TrevMatrix.initialise(st:string):boolean;
begin
  result:=inherited initialise(st);
end;

procedure TrevMatrix.proprietes(sender:Tobject);
begin
  with revMatProp do
  begin
    calcul:=calculeTout;
    scrollIP1:=scrollIPG1;
    scrollIP2:=scrollIPG2;

    init(t1,t2,dt,ip1*dt,ip2*dt);
    showModal;
  end;
end;

procedure TrevMatrix.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);

  if lecture then
    begin
      conf.setvarConf('dataVec',FdataVecb,sizeof(FdataVecB));
    end
  else
    begin
      conf.setvarConf('dataVec',FdataVec,sizeof(FdataVec));
    end;

end;

procedure TrevMatrix.RetablirReferences(list:Tlist);
var
  i,j,page:integer;
  lu:Tlist;
  ppu:typeUO;
  p:pointer;
begin
  affdebug('TrevMat.RetablirReferences '+ident);
  for i:=0 to list.count-1 do
    begin
     p:=typeUO(list.items[i]).myAd;
     if p=FdataVecb then
       begin
         dataVec:=list.items[i];
         referenceObjet(p);
       end;
    end;
end;


procedure TrevMatrix.processMessage(id:integer;source:typeUO;p:pointer);
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
        if (dataVec=source) then
          begin
            dataVec:=nil;
            dereferenceObjet(source);
          end;
      end;
  end;
end;


procedure Trevmatrix.scrollIPG1(x:float);
begin
  ip1:=floor(x/dt);
  calculeMat;
  autoscaleZ;
  invalidate;
end;

procedure Trevmatrix.scrollIPG2(x:float);
begin
  ip2:=floor(x/dt);
  calculeMat;
  autoscaleZ;
  invalidate;
end;


procedure Trevmatrix.clearUp;
var
  i:integer;
begin
  for i:=0 to up.count-1 do freemem(up.items[i],PsthSize);
  Up.clear;
end;

function Trevmatrix.InitPsth:boolean;
var
  i:integer;
  p:pointer;
begin
  clearUp;

  result:=(nx>0) and (nx<100) and (ny>0) and (ny<100);
  if not result then exit;

  for i:=1 to nx*ny*2 do
    begin
      getmem(p,nx*ny*2*4);
      fillchar(p^,nx*ny*2*4,0);
      up.add(p);
    end;


end;

procedure Trevmatrix.setPsth(i,j,k,l:integer;x:integer);
begin
  Ptablong(up.items[i+nx*j+nx*ny*k])^[l]:=x;
end;

function Trevmatrix.getPsth(i,j,k,l:integer):integer;
begin
  result:=  Ptablong(up.items[i+nx*j+nx*ny*k])^[l];
end;

procedure Trevmatrix.incPsth(i,j,k,l:integer);
begin
  inc(Ptablong(up.items[i+nx*j+nx*ny*k])^[l]);
  {affdebug('incPsth '+Istr(i)+' '+Istr(j)+' '+Istr(k)+' '+Istr(l) );}
end;


procedure Trevmatrix.decode(code:integer;var x,y,z:integer);
const
  Nz=2;
begin
  code:=code-1;
  z:=code mod Nz;
  code:=(code-z) div nz;
  y:=code mod ny;
  x:=(code-y) div ny;
end;

procedure Trevmatrix.CalculPsth;
var
  i,j,i0,i1:longint;
  ev0:typeSP;
  ip:integer;

  dtmin,dtmax:double;
  date:double;

  x,y,w:integer;
  f:file;
  res:intG;
  ok:boolean;
  info:typeInfoSpk;
  EventIend:integer;
begin
  if dt<=0 then exit;

  ipmin:=floor(t1/dt);
  ipmax:=floor(t2/dt);
  psthSize:=(ipmax-ipmin+1)*4;


  dtmax:=(ipmax+1)*dt;
  dtmin:=ipmin*dt;


  assign(f,stEvt);
  Greset(f,1);
  info.charger(f,ok);
  if not ok then
    begin
      messageCentral('Error loading '+stEvt);
      Gclose(f);
      exit;
    end;

  Gseek(f,info.tailleInfo);

  Gblockread(f,ev0,sizeof(ev0),res);  {écarter l'événement zéro }

  Gblockread(f,ev0,sizeof(ev0),res);
  nx:=ev0.x div 2;

  Gblockread(f,ev0,sizeof(ev0),res);
  ny:=ev0.x div 2;

  Gblockread(f,ev0,sizeof(ev0),res);

  {messageCentral('nx='+Istr(nx)+' ny='+Istr(ny));}
  if not initPsth then exit;


  initTemp(1,nx,1,ny,g_longint);

  EventIend:=DataVec.Iend;

  i0:=-1;
  i1:=DataVec.Istart-1;

  while not Geof1(f) do
  begin
    Gblockread(f,ev0,sizeof(ev0),res);   {lire top synchro }

    if i1>=EventIend then
      begin
        Gclose(f);
        exit;
      end;

    repeat
      inc(i1);                         {incrémenter i1 jusqu'à l'obtention }
      date:=DataVec.Yvalue[i1];          {d'une date utile pour le psth }
    until (i1>=EventIend) or (date-ev0.date*info.deltaX>=dtmin);
    dec(i1);

    i:=i1+1;                           {accumuler les ev jusqu'à dépassement }
    date:=DataVec.Yvalue[i];             {la date maximale }
    decode(ev0.x div 2,x,y,w);
    while (i<EventIend) and (date<ev0.date*info.deltaX+dtmax) do
    begin
      date:=DataVec.Yvalue[i];
      ip:= truncL((date-ev0.date*info.deltaX)/dt);
      if (ip<=ipmax) then incPsth(x,y,w,ip-ipmin);
      inc(i);
    end;

  end;

  ip1:=ipmin;
  ip2:=ipmax;

  Gclose(f);

end;

procedure TrevMatrix.calculeMat;
var
  i,j,l:integer;
begin
  if not assigned(data) then exit;

  data^.raz;

  for l:=ip1 to ip2 do
    for i:=Istart to Iend do
      for j:=Jstart to Jend do
        data^.addI(i,j,psth[i-1,j-1,Zact-1,l-ipmin]);
end;

procedure TrevMatrix.calculeTout;
begin
  calculPsth;
  calculeMat;
end;

procedure TrevMatrix.setDataVec(v:Tvector);
begin
  dereferenceObjet(typeUO(FdataVec));
  FdataVec:=v;
  referenceObjet(typeUO(FdataVec));
end;

{ ************************** Méthodes STM *****************************}

procedure proTrevMatrix_EvtFile(st:shortString;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevMatrix(pu) do stEvt:=st;
end;

function fonctionTrevMatrix_EvtFile(var pu:typeUO):shortstring;
begin
  verifierObjet(typeUO(pu));
  with TrevMatrix(pu) do result:=stEvt;
end;

procedure proTrevMatrix_calculate(var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevMatrix(pu) do calculeTout;
end;

procedure proTrevMatrix_setDataVector(var source1:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(source1));

  with TrevMatrix(pu) do DataVec:=source1;
end;


end.
