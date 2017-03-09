unit stmCPlot1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Dgraphic,
     stmdef,stmObj,debug0,
     stmGraph2,stmMat1,
     stmPg;


type
  TcontourPlot=class(TXYplot)
           private
              bH0,bV0:PtabBoolean;
              Imin,Imax,Jmin,Jmax,nbX,nbY:integer;
              Vmat0:Ptabdouble;
              Vmark:array of array of Boolean;

              currentLine:integer;
              PtCount:integer;
              niveau0:float;
              ax,bx,ay,by:float;
              d0:float;

              FselPix,FmarkPix,Fvalue:boolean;
              ExValue:float;

              i0mat, j0mat, dimat, djmat: float;

              FusePos: boolean;
              degP:typeDegre;         // Contient theta en radians

              procedure setBH(i,j:integer;b:boolean);
              procedure setBV(i,j:integer;b:boolean);
              function getBH(i,j:integer):boolean;
              function getBV(i,j:integer):boolean;

              procedure setVmat(i,j:integer;w:float);
              function getVmat(i,j:integer):float;

              function getTruePos(x,y:float):TRpoint;

              function convx(x:float):float;
              function convy(y:float):float;
              function invconvx(x:float):longint;
              function invconvy(y:float):longint;


              procedure fermer;

           public
              property BH[i,j:integer]:boolean read getBH write setBH;
              property BV[i,j:integer]:boolean read getBV write setBV;
              property Vmat[i,j:integer]:float read getVmat write setVmat;

              constructor create;override;
              destructor destroy;override;

              class function STMClassName:AnsiString;override;

              procedure stockerH(i,j:integer);
              procedure stockerV(i,j:integer);

              procedure traiterH(i,j:integer);
              procedure traiterV(i,j:integer);

              procedure calculVmat;
              procedure Calcul(mat:Tmatrix;niveau:float; UsePos:boolean);


              procedure setOptions(Fsel,Fmark,Fval:boolean;val:float);
            end;

procedure proTcontourPlot_create(stName:AnsiString;var pu:typeUO);pascal;
procedure proTcontourPlot_create_1(var pu:typeUO);pascal;
procedure proTcontourPlot_Calculate(var mat:Tmatrix; level:float;var pu:typeUO);pascal;
procedure proTcontourPlot_Calculate_1(var mat:Tmatrix; level:float; UsePos:boolean ;var pu:typeUO);pascal;

procedure proTcontourPlot_SetOptions(useSel,useMark,useValue:boolean;
                                     level:float;var pu:typeUO);pascal;

implementation

constructor TcontourPlot.create;
begin
  inherited;

end;

destructor TcontourPlot.destroy;
begin
  inherited destroy;
end;


class function TcontourPlot.STMClassName:AnsiString;
begin
  STMClassName:='ContourPlot';
end;

procedure TcontourPlot.setBH(i,j:integer;b:boolean);
begin
  BH0^[i +j*nbX]:=b;
end;

function TcontourPlot.getBH(i,j:integer):boolean;
begin
  result:=BH0^[i + j*nbX];
end;

procedure TcontourPlot.setBV(i,j:integer;b:boolean);
begin
  BV0^[i + j*nbX]:=b;
end;

function TcontourPlot.getBV(i,j:integer):boolean;
begin
  result:=BV0^[i + j*nbX];
end;

procedure TcontourPlot.setVmat(i,j:integer;w:float);
begin
  Vmat0^[i +j*nbX]:=w;
end;

function TcontourPlot.getVmat(i,j:integer):float;
begin
  result:=Vmat0^[i + j*nbX];
end;


procedure TcontourPlot.stockerH(i,j:integer);
var
  x,y,v1,v2:float;
begin
  v1:=Vmat[i,j];
  v2:=Vmat[i+1,j];
  if v2<>v1 then x:=i+(niveau0-v1)/(v2-v1) else x:=i;
  y:=j;

  with polyLines[CurrentLine] do
    with getTruePos(x,y) do addPoint(x,y);
  inc(ptCount);
  {affdebug('StockerH '+Istr(currentLine)+'   '+Istr(polyLines[CurrentLine].count)+
             '   '+Istr(i)+'   '+ Istr(j));}

end;

procedure TcontourPlot.stockerV(i,j:integer);
var
  x,y,v1,v2:float;
begin
  v1:=Vmat[i,j];
  v2:=Vmat[i,j+1];
  if v2<>v1 then y:=j+(niveau0-v1)/(v2-v1) else y:=j;
  x:=i;

  with polyLines[CurrentLine] do
    with getTruePos(x,y) do addPoint(x,y);
  inc(ptCount);

  {affdebug('StockerV '+Istr(currentLine)+'   '+Istr(polyLines[CurrentLine].count)+
             '   '+Istr(i)+'   '+ Istr(j));}
end;


procedure TcontourPlot.traiterV(i,j:integer);
var
  nb:integer;
begin
  if (i<0) or (i>nbX-1) or (j<0) or (j>nbY-2) or not BV[i,j] then exit;

  stockerV(i,j);
  BV[i,j]:=false;

  nb:=PtCount;

  traiterV(i-1,j);
  traiterV(i+1,j);

  traiterH(i-1,j);
  traiterH(i,j);
  traiterH(i-1,j+1);
  traiterH(i,j+1);

  if (PtCount=nb) and  (polyLines[CurrentLine].count>0) then
    begin
      fermer;
      addPolyLine;
      inc(currentLine);
    end;
end;



procedure TcontourPlot.traiterH(i,j:integer);
var
  nb:integer;
begin
  if (i<0) or (i>nbX-2) or (j<0) or (j>nbY-1) or not BH[i,j] then exit;

  stockerH(i,j);
  BH[i,j]:=false;

  nb:=PtCount;

  traiterH(i,j-1);
  traiterH(i,j+1);

  traiterV(i,j-1);
  traiterV(i,j);
  traiterV(i+1,j-1);
  traiterV(i+1,j);

  if (PtCount=nb) and  (polyLines[CurrentLine].count>0) then
    begin
      fermer;
      addPolyLine;
      inc(currentLine);
    end;
end;

procedure TcontourPlot.fermer;
var
  d:float;
begin
  with polyLines[currentLine] do
  if count>0 then
  begin
    d:=sqr(Xvalue[count-1]-Xvalue[0])+sqr(Yvalue[count-1]-Yvalue[0]);

    if d<=d0 then
      begin
        addPoint(Xvalue[0],Yvalue[0]);
        {affdebug('AJOUTE                              ===>'+Estr(d,3));}
      end;
  end;
end;

procedure TcontourPlot.CalculVmat;
var
  i,j:integer;                                                                    
begin
  for i:=0 to nbX-2 do
    for j:=0 to nbY-1 do
      BH[i,j]:= not Vmark[i,j] and not Vmark[i+1,j]
                and
                ( (Vmat[i,j]<niveau0) and (Vmat[i+1,j]>=niveau0)
                   OR
                  (Vmat[i,j]>=niveau0) and (Vmat[i+1,j]<niveau0)
                );


  for i:=0 to nbX-1 do
    for j:=0 to nbY-2 do
      BV[i,j]:= not Vmark[i,j] and not Vmark[i,j+1]
                and
                ( (Vmat[i,j]<niveau0) and (Vmat[i,j+1]>=niveau0)
                  OR
                  (Vmat[i,j]>=niveau0) and (Vmat[i,j+1]<niveau0)
                );

  d0:=(sqr(convx(1)-convx(0))+sqr(convy(1)-convy(0)));

  if (PolyLineCount=0) or (polyLines[PolyLineCount-1].count>0)
    then addPolyLine;
  currentLine:=PolyLineCount-1;

  for i:=0 to nbX-2 do
    for j:=0 to nbY-1 do
      if BH[i,j] then
        begin
          if polyLines[CurrentLine].count>0 then
            begin
              addPolyLine;
              inc(currentLine);
            end;

          traiterH(i,j);

          fermer;
        end;

  for i:=0 to nbX-1 do
    for j:=0 to nbY-2 do
      if BV[i,j] then
        begin
          if polyLines[CurrentLine].count>0 then
            begin
              addPolyLine;
              inc(currentLine);
            end;

          traiterV(i,j);

          fermer;
        end;

  if (polylineCount>0) and (polyLines[polylineCount-1].count=0)
   then DeletePolyline(polylineCount-1);
end;


procedure TcontourPlot.Calcul(mat:Tmatrix;niveau:float; UsePos:boolean);
var
  i,j:integer;
  w:float;
begin
  FusePos:= UsePos and mat.degP.Fuse and (mat.degP.dx<>0) and (mat.degP.dy<>0);
  degP:=mat.degP;
  degP.theta:=degP.theta*pi/180;

  with mat do
  begin
    I0mat:=(Istart+Iend+1)/2;
    J0mat:=(Jstart+Jend+1)/2;
    DImat:= Iend-Istart+1;
    DJmat:= Jend-Jstart+1;

    if visu.modeMat<>0 then w:=3 else w:=1;

    if not FusePos then
    begin
      ax:=Dxu/w;
      bx:=X0u+(Istart+0.5/w)*Dxu;

      ay:=Dyu/w;
      by:=Y0u+(Jstart+0.5/w)*Dyu;
    end
    else
    begin
      ax:=1/w;
      bx:=Istart+0.5/w;

      ay:=1/w;
      by:=Jstart+0.5/w;
    end;

    nbX:=Iend-Istart+1;
    nbY:=Jend-Jstart+1;
    if visu.modeMat<>0 then
      begin
        nbX:=nbX*3;
        nbY:=nbY*3;
      end;

    getmem(Vmat0,nbX*nbY*sizeof(double));
    setLength(Vmark,nbX,nbY);

    for i:=Istart to Istart+nbX-1 do
      for j:=Jstart to Jstart+nbY-1 do
        begin
          Vmat[i-Istart,j-Jstart]:=getSmoothVal(i,j);
          Vmark[i-Istart,j-Jstart]:=
            FSelPix and getSmoothSel(i,j)
            OR
            FMarkPix and getSmoothMark(i,j)
            OR
            Fvalue and (getSmoothVal(i,j)=ExValue);
        end;
  end;

  getmem(BH0,nbX*nbY);
  getmem(BV0,nbX*nbY);
  fillchar(BH0^,nbX*nbY,0);
  fillchar(BV0^,nbX*nbY,0);

  niveau0:=niveau;
  ptCount:=0;

  calculVmat;

  FselPix:=false;
  FmarkPix:=false;
  Fvalue:=false;

  freemem(BH0,nbX*nbY);
  freemem(BV0,nbX*nbY);
  freemem(Vmat0,nbX*nbY*sizeof(double));

end;

function TcontourPlot.convx(x:float):float;
begin
  result:=ax*x+bx;
end;

function TcontourPlot.convy(y:float):float;
begin
  result:=ay*y+by;
end;

function TcontourPlot.invconvx(x:float):longint;
begin
  result:=roundL((x-bx)/ax);
end;

function TcontourPlot.invconvy(y:float):longint;
begin
  result:=roundL((y-by)/ay);
end;

procedure TcontourPlot.setOptions(Fsel,Fmark,Fval:boolean;val:float);
begin
  FselPix:=Fsel;
  FmarkPix:=Fmark;
  Fvalue:=Fval;
  ExValue:=val;
end;

function TcontourPlot.getTruePos(x, y: float): TRpoint;
var
  xa,ya: float;
begin

  if FusePos then
  begin
    result.x:=convx(x);
    result.y:=convy(y);

    xa:=(result.x-i0mat)*degP.dx/DImat;
    ya:=(result.y-j0mat)*degP.dy/DJmat;

    result.x:= xa*cos(degP.theta) - ya*sin(degP.theta) + degP.x;
    result.y:= xa*sin(degP.theta) + ya*cos(degP.theta) + degP.y;
  end
  else
  begin
    result.x:=convx(x);
    result.y:=convy(y);
  end;
end;


{******************* Méthodes STM *********************************************}

procedure proTcontourPlot_create(stName:AnsiString;var pu:typeUO);
begin
  createPgObject(stname,pu,TcontourPlot);
end;

procedure proTcontourPlot_create_1(var pu:typeUO);
begin
  createPgObject('',pu,TcontourPlot);
end;

procedure proTcontourPlot_Calculate(var mat:Tmatrix; level:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));
  TcontourPlot(pu).calcul(mat,level,false);
end;

procedure proTcontourPlot_Calculate_1(var mat:Tmatrix; level:float; UsePos:boolean ;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));
  TcontourPlot(pu).calcul(mat,level,UsePos);
end;



procedure proTcontourPlot_SetOptions(useSel,useMark,useValue:boolean;
                                     level:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TcontourPlot(pu).setOptions(useSel,useMark,useValue,level);
end;


Initialization
AffDebug('Initialization stmCPlot1',0);

registerObject(TcontourPlot,data);

end.
