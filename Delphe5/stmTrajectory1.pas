unit stmTrajectory1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses Windows,classes,graphics,controls,forms, sysutils,

     util1,Dgraphic,Gdos,dtf0,listG,
     Ncdef2,defForm,
     Stmdef,stmObj,stmObv0,StmMvtX1,stmVSBM1,
     varconf1,
     debug0,
     stmPg,stmError,
     stmVec1,
     stmGraph2, syspal32;

type
  TSPoint=record
            x,y:single;
          end;
  PSpoint=^TSpoint;

  Ttrajectory=class(TonOff)
                points:TlistG;
                FBM:boolean;

                xp,yp,tp:float;

                dxRnd,dyRnd:integer;
                Frnd:boolean;
                FrameMod:integer;

                ParamValue: array [0..19] of TlistG;
                Param: TstringList;
                ParamType: array[0..19] of typeNombre;

                MaxFrame: integer;  { vaut -1 par défaut
                                      tend prend cette valeur dans initmvt si elle est >=0
                                    }

                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;

                procedure InitMvt; override;
                procedure calculeMvt; override;
                procedure doneMvt;override;

                function dialogForm:TclassGenForm;override;
                procedure installDialog(var form:Tgenform;var newF:boolean);
                            override;


                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;

                function getInfo:AnsiString;override;

                procedure clear;
                procedure addPoint(x,y:float);
                procedure setObvis(ob:typeUO);override;
                procedure setBMobject(ob:typeUO);

                procedure addXYT(x,y,t:float);
                procedure Add(Name: AnsiString;w:single);
                procedure AddVector(Name: AnsiString; vec:Tvector);
                procedure AddArray(Name: AnsiString; tb: TarrayOfSingle);


                procedure BrownianMvt(xinit,yinit,V0,sigma,tmax: float; contour: TXYplot);
                procedure ParticleFlow(xinit,yinit,V0,theta,tmax: float;  contour: TXYplot);

                procedure setVisiFlags(obOn:boolean);override;
              end;

procedure proTtrajectory_create(var pu:typeUO); pascal;
procedure proTtrajectory_create_1(name:AnsiString;var pu:typeUO); pascal;

procedure proTtrajectory_clear(var pu:typeUO);              pascal;
procedure proTtrajectory_addPoint(x,y:float;var pu:typeUO); pascal;
procedure proTtrajectory_addXYT(x, y, t: float;var pu:typeUO);pascal;
procedure proTtrajectory_setBMobject(var ob:TVSbitmap;var pu:typeUO); pascal;
procedure proTtrajectory_setRandom(Frnd1:boolean;dx1,dy1,frameMod1:integer;var pu:typeUO);pascal;

procedure proTtrajectory_Add(name:AnsiString; w: float;var pu:typeUO);pascal;
procedure proTtrajectory_AddVector(name:AnsiString; var vec:Tvector;var pu:typeUO);pascal;

procedure proTtrajectory_BrownianMvt(xinit, yinit, V0, sigma, tmax: float;var contour: TXYplot;var pu: typeUO);pascal;
procedure proTtrajectory_ParticleFlow(xinit, yinit, V0, theta, tmax: float; var contour: TXYplot; var pu: typeUO);pascal;

implementation



constructor Ttrajectory.create;
begin
  inherited create;
  points:=TlistG.create(sizeof(TSPoint));

  FrameMod:=1;
  Param:=TstringList.Create;
  MaxFrame:=-1;
end;

destructor Ttrajectory.destroy;
var
  i: integer;
begin
  points.Free;

  for i:=0 to param.Count-1 do ParamValue[i].Free;
  Param.Free;
  inherited destroy;
end;


class function Ttrajectory.STMClassName:AnsiString;
begin
  result:='Trajectory';
end;

procedure Ttrajectory.InitMvt;
begin
  inherited;  

  obvis.prepareS;
  if FBM and Frnd then
    TVSbitmap(obvis).initRandom(dxRnd,dyRnd);

  if maxFrame>=0 then tend:= maxFrame;
end;

procedure Ttrajectory.doneMvt;
begin
  inherited;
  if FBM and Frnd then
    TVSbitmap(obvis).doneRandom;
end;

procedure Ttrajectory.calculeMvt;
var
  i,t,t0:integer;
begin
  t0:=timeS mod dureeC;

  if Param.count>0 then
  begin
    for i:=0 to Param.Count-1 do
    begin
      t:=t0;
      if t>=paramValue[i].count then t:=paramValue[i].count-1;
      case ParamType[i] of
        nbSingle: Psingle(param.Objects[i])^:=  Psingle(paramValue[i][t])^;
        nbBoole:  Pboolean(param.Objects[i])^:= Psingle(paramValue[i][t])^<>0 ;
      end;
    end;
    exit;
  end;

  t:=t0;
  if t>=points.count then t:=points.count-1;

  if t>=0 then
  begin
    if FBM then
      begin

        TVSbitmap(obvis).x0:=PSpoint(points[t])^.x;
        TVSbitmap(obvis).y0:=PSpoint(points[t])^.y;
        {TVSbitmap(obvis).randomizeRlist(0);}

        TVSbitmap(obvis).Fmix:=t mod FrameMod=0;
      end
    else
      begin
        obvis.deg.x:=PSpoint(points[t])^.x;
        obvis.deg.y:=PSpoint(points[t])^.y;
      end;
  end;
end;

function Ttrajectory.dialogForm:TclassGenForm;
begin
  dialogForm:=inherited dialogForm ;
end;

procedure Ttrajectory.installDialog(var form:Tgenform;var newF:boolean);
begin
  inherited;

end;

procedure Ttrajectory.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    inherited;
    with conf do
    begin

    end;
  end;

function Ttrajectory.getInfo:AnsiString;
begin
   result:=inherited getInfo+CRLF;

end;

procedure Ttrajectory.CompleteLoadInfo;
begin
  CheckOldIdent;
  majPos;
end;

procedure Ttrajectory.addPoint(x, y: float);
var
  pt:TSpoint;
begin
  pt.x:=x;
  pt.y:=y;
  points.Add(@pt);
end;

procedure Ttrajectory.clear;
var
  i:integer;
begin
  points.clear;
  xp:=0;
  yp:=0;
  tp:=0;

  for i:=0 to Param.Count-1 do ParamValue[i].Free;
  fillchar(ParamValue,sizeof(ParamValue),0);
  Param.Clear;

end;

procedure Ttrajectory.setBMobject(ob: typeUO);
begin
  setObvis(ob);
  FBM:=true;
end;

procedure Ttrajectory.setObvis(ob: typeUO);
begin
  inherited;
  FBM:=false;

  clear;
end;

procedure Ttrajectory.addXYT(x, y, t: float);
var
  i,i1,i2:integer;
  pp:TSpoint;
  ax,ay:float;
begin
  i1:=round(tp/Xframe)+1;
  i2:=round(t/Xframe);
  if i1-1<>points.count then exit;

  if (t<=tp) then exit;

  ax:=(x-xp)/(t-tp);
  ay:=(y-yp)/(t-tp);

  for i:=i1 to i2 do
    if i>=points.Count then
      begin
        pp.x:=ax*(i*Xframe-tp)+xp;
        pp.y:=ay*(i*Xframe-tp)+yp;
        points.Add(@pp);
      end;

  tp:=t;
  xp:=x;
  yp:=y;
end;



procedure Ttrajectory.Add(Name: AnsiString; w: single);
var
  ad: pointer;
  k: integer;
  tp: typeNombre;
begin
  Name:=UpperCase(Name);
  if assigned(obvis) then
  begin
    k:= param.IndexOf(name);
    if (k<0) and (param.Count<10) then
    begin
      ad:=obvis.getParamAd(name,tp);
      if ad=nil then exit;

      k:=param.AddObject(name,ad);
      ParamValue[k]:=TlistG.create(4);
      ParamType[k]:= tp;
    end;

    ParamValue[k].Add(@w);
  end;
end;

procedure Ttrajectory.AddVector(Name: AnsiString; vec: Tvector);
var
  ad: pointer;
  i,k: integer;
  w:single;
  tp: typeNombre;
begin
  Name:=UpperCase(Name);
  if assigned(obvis) then
  begin
    k:= param.IndexOf(name);
    if (k<0) and (param.Count<10) then
    begin
      ad:=obvis.getParamAd(name, tp);
      if ad=nil then exit;

      k:=param.AddObject(name,ad);
      ParamValue[k]:=TlistG.create(4);
      ParamType[k]:= tp;
    end;

    for i:=vec.Istart to vec.Iend do
    begin
      w:=vec[i];
      ParamValue[k].Add(@w);
    end;
  end
  else sortieErreur('Ttrajectory.AddVector : Visual Object is not assigned');
end;

procedure Ttrajectory.AddArray(Name: AnsiString; tb: TarrayOfSingle);
var
  ad: pointer;
  i,k: integer;
  tp: typeNombre;
begin
  Name:=UpperCase(Name);
  if assigned(obvis) then
  begin
    k:= param.IndexOf(name);
    if (k<0) and (param.Count<10) then
    begin
      ad:=obvis.getParamAd(name,tp);
      if ad=nil then exit;

      k:=param.AddObject(name,ad);
      ParamValue[k]:=TlistG.create(4);
      ParamType[k]:= tp;
    end;

    for i:=0 to high(tb) do
      ParamValue[k].Add(@tb[i]);
  end;
end;

procedure Ttrajectory.BrownianMvt(xinit, yinit, V0, sigma, tmax: float; contour: TXYplot);
var
  i:integer;
  xp, yp, xN, yN, deltaX, deltaY, d: float;
  NumFrame, nb: integer;
  nbFrame: integer;
  tbX, tbY: TarrayOfSingle;
  ind: integer;

  bm: Tbitmap;
  poly: array of Tpoint;
  hrgn: Thandle;
  pt: Tpoint;
  flag: boolean;
  rgnRect: Trect;
  cnt: integer;

procedure store(x,y:single);
begin
  if ind<nbFrame then
  begin
    tbX[ind]:=x;
    tbY[ind]:=y;
    inc(ind);
  end;
end;

begin
  clear;
  ind:=0;

  if assigned(contour) and (contour.PolylineCount>0) and (contour.polyLines[0].Count>2) then
  with contour.polylines[0] do
  begin

    setlength(poly,count);
    for i:=0 to count-1 do
    begin
      poly[i].X:=round(Xvalue[i]*10);
      poly[i].Y:=round(Yvalue[i]*10);
    end;

    hrgn:=createPolygonRgn(poly[0],length(poly), Alternate);
  end
  else hrgn:=0;


  nbFrame:=round(tmax/Xframe);
  DtON:=nbFrame;
  DtOff:=0;

  setlength(tbX,nbFrame);
  setlength(tbY,nbFrame);

  xp:= xinit;
  yp:= yinit;

  cnt:=0;
  if (hrgn<>0) and not ptInRegion(hrgn, round(xP*10), round(yP*10)) then
  begin
    getRgnBox(hrgn,rgnRect);
    repeat
      xp:=rgnRect.left+random(rgnRect.right-rgnRect.left);
      yp:=rgnRect.top+random(rgnRect.bottom-rgnRect.top);
      inc(cnt);
    until ptInRegion(hrgn, round(xP), round(yP)) or (cnt>20);

    xp:=xp/10;
    yp:=yp/10;
  end;

  store(xp,yp);

  NumFrame:=0;
  repeat
    xN:=xp+gauss(0,sigma);
    yN:=yp+gauss(0,sigma);

    flag:= (hrgn=0) or ptInRegion(hrgn, round(xN*10), round(yN*10));

    d:=sqrt(sqr(xp-xN)+sqr(yp-yN));
    nb:= round( d/V0/Xframe );

    if nb>0 then
    begin
      deltaX:=(xN-xP)/nb;
      deltaY:=(yN-yP)/nb;
    end;

    for i:= 0 to nb-1 do
    begin
      if not flag and not ptInRegion(hrgn, round(xp*10), round(yp*10)) then
      begin
        repeat
          xp:=xp-deltaX;
          yp:=yp-deltaY;
        until not ptInRegion(hrgn, round(xp*10), round(yp*10));
      end;
      store(xp, yp);
      xp:= xp+deltaX;
      yp:= yp+deltaY;
    end;
    NumFrame:=NumFrame+i;

  until NumFrame>=nbFrame;

  deleteObject(hrgn);

  addArray('X',tbX);
  addArray('Y',tbY);

end;

procedure Ttrajectory.ParticleFlow(xinit, yinit, V0, theta, tmax: float; contour: TXYplot);
var
  i:integer;
  xp, yp, deltaX, deltaY: float;
  nb, ind: integer;
  tbX, tbY: TarrayOfSingle;

  bm: Tbitmap;
  poly: array of Tpoint;
  hrgn: Thandle;
  rgnRect: Trect;
  cnt: integer;

procedure store(x,y:single);
begin
  if ind>=length(tbX) then
  begin
    setLength(tbX,length(tbX)+100);
    setLength(tbY,length(tbY)+100);
  end;

  tbX[ind]:=x;
  tbY[ind]:=y;
  inc(ind);
end;

begin
  clear;
  ind:=0;

  if assigned(contour) and (contour.PolylineCount>0) and (contour.polyLines[0].Count>2) then
  with contour.polylines[0] do
  begin
    setlength(poly,count);
    for i:=0 to count-1 do
    begin
      poly[i].X:=round(Xvalue[i]*10);
      poly[i].Y:=round(Yvalue[i]*10);
    end;

    hrgn:=createPolygonRgn(poly[0],length(poly), Alternate);
  end
  else hrgn:=0;



  cnt:=0;
  if (hrgn<>0) and not ptInRegion(hrgn, round(xinit*10), round(yinit*10)) then
  begin
    getRgnBox(hrgn,rgnRect);
    repeat
      xinit:=rgnRect.left+random(rgnRect.right-rgnRect.left);
      yinit:=rgnRect.top+random(rgnRect.bottom-rgnRect.top);
      inc(cnt);
    until ptInRegion(hrgn, round(xinit), round(yinit)) or (cnt>100);

    xinit:=xinit/10;
    yinit:=yinit/10;
  end;

  xp:= xinit;
  yp:= yinit;

  deltaX:=V0*Xframe*cos(theta*pi/180);
  deltaY:=V0*Xframe*sin(theta*pi/180);

  Nb:=0;
  repeat
    store(xp,yp);
    xp:=xp+deltaX;
    yp:=yp+deltaY;
    inc(nb);
  until not ptInRegion(hrgn, round(xP*10), round(yP*10));

  repeat
    xp:= xp-deltaX;
    yp:= yp-deltaY;
  until not ptInRegion(hrgn, round(xP*10), round(yP*10));
  xp:=xp+deltaX;
  yp:=yp+deltaY;

  while abs(xp-xinit)>0.001 do
  begin
    store(xp,yp);
    xp:=xp+deltaX;
    yp:=yp+deltaY;
    inc(nb);
  end; 

  maxFrame:=round(tmax/Xframe);
  DtON:=nb;
  DtOff:=0;

  deleteObject(hrgn);

  setLength(tbX,nb);
  setLength(tbY,nb);

  addArray('X',tbX);
  addArray('Y',tbY);

end;




{***********************************************************************************}
                           { Méthodes STM }

procedure proTtrajectory_create(var pu:typeUO);
begin
  createPgObject('',pu,Ttrajectory);
end;

procedure proTtrajectory_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,Ttrajectory);
end;

procedure proTtrajectory_clear(var pu:typeUO);
begin
  verifierObjet(pu);
  Ttrajectory(pu).clear;
end;

procedure proTtrajectory_addPoint(x,y:float;var pu:typeUO);
begin
  verifierObjet(pu);
  Ttrajectory(pu).addPoint(x,y);
end;

procedure proTtrajectory_addXYT(x, y, t: float;var pu:typeUO);
begin
  verifierObjet(pu);
  Ttrajectory(pu).addXYT(x,y,t);
end;


procedure proTtrajectory_setBMobject(var ob:TVSbitmap;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(ob));
  Ttrajectory(pu).setBMobject(ob);
end;

var
  E_rnd1:integer;
  E_rnd2:integer;

procedure proTtrajectory_setRandom(Frnd1:boolean;dx1,dy1,frameMod1:integer;var pu:typeUO);
begin
  controleParam(dx1,1,2000,E_rnd1);
  controleParam(dy1,1,2000,E_rnd1);
  controleParam(frameMod1,1,2000,E_rnd1);

  verifierObjet(pu);
  with Ttrajectory(pu) do
  begin
    Frnd:=Frnd1;
    dxRnd:=dx1;
    dyRnd:=dy1;
    frameMod:=frameMod1;
  end;
end;


procedure proTtrajectory_Add(name:AnsiString; w: float;var pu:typeUO);
begin
  verifierObjet(pu);
  Ttrajectory(pu).Add(Name,w);
end;

procedure proTtrajectory_AddVector(name:AnsiString; var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));
  Ttrajectory(pu).AddVector(Name,vec);
end;

procedure proTtrajectory_BrownianMvt(xinit, yinit, V0, sigma, tmax: float;var contour: TXYplot;var pu: typeUO);
begin
  verifierObjet(pu);
  with Ttrajectory(pu) do BrownianMvt(xinit, yinit, V0, sigma, tmax, contour);
end;

procedure proTtrajectory_ParticleFlow(xinit, yinit, V0, theta, tmax: float; var contour: TXYplot; var pu: typeUO);
begin
  verifierObjet(pu);
  with Ttrajectory(pu) do ParticleFlow(xinit, yinit, V0, theta, tmax, contour);
end;


procedure Ttrajectory.setVisiFlags(obOn: boolean);
begin
  if param.IndexOf('ONSCREEN')<0  then inherited setVisiFlags(obON)
  else
  if assigned(obvis) and not ObON then obvis.FlagOnScreen:=false;
  // on force à Off au delà du DtON;

end;


begin
  registerObject(Ttrajectory,stim);

  installError(E_rnd1,'Ttrajectory.setRandom : parameter out of range');

end.
