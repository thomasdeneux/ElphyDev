unit stmPlayGrid1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,math,
     util1,Gdos,dtf0,Dgraphic,Dpalette,tbe0,
     stmDef,stmObj,stmobv0,varconf1,Ncdef2, Debug0,
     defForm,selRF1,editcont,
     syspal32, stmMvtX1,
     stmgrid3,
     stmvec1,stmMat1,stmOdat2,stmAve1,stmAveA1,stmPsth1,stmPstA1,
     stmPg,stmError,
     Rarray1,listG,
     matrix0,chrono0,
     Gnoise1,
     stmMlist;



type

  TplayGrid=class(TonOff)

              private
                values: array of array of array of byte;     // x,y,index

                GridCol: array of integer;
                
                nbLum:integer;
                LumMin,DeltaLum: float;

                grid:TgridEx;

                nx,ny:integer;
                IndexCount:integer;  // Longueur des vecteurs values

                index:integer;
                RFdeg:TypeDegre;

                AdjustObjectSize: boolean;

              public

                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;

                procedure setVisiFlags(obOn:boolean);override;

                procedure InitMvt; override;
                procedure initObvis;override;
                procedure calculeMvt; override;
                procedure doneMvt; override;

                procedure setObvis(uo:typeUO);override;

                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;

                procedure setChildNames;override;

                procedure setLums(nb:integer;lum1,lum2:float);
                function setRawValues(vv:TvectorArray): boolean;
                function setValues(vv:TvectorArray): boolean;


                function valid: boolean;override;
                

              end;


procedure proTplayGrid_create(var pu:typeUO);pascal;
procedure proTplayGrid_setLums(nb:integer; Lum1,Lum2:float;var pu:typeUO);pascal;
procedure proTplayGrid_setValues(var VV:TvectorArray;Fraw:boolean; var pu:typeUO);pascal;
function fonctionTplayGrid_Xcount(var pu:typeUO): integer;pascal;
function fonctionTplayGrid_Ycount(var pu:typeUO): integer;pascal;
procedure proTplayGrid_setRF(num:integer;var pu:typeUO);pascal;

procedure proTplayGrid_AdjustObjectSize(ww:boolean;var pu:typeUO); pascal;
function fonctionTplayGrid_AdjustObjectSize(var pu:typeUO):boolean; pascal;


implementation



{*********************   Méthodes de TplayGrid  *************************}

constructor TplayGrid.create;
var
  i,j:integer;
begin
  inherited create;

  timeMan.dtOn:=1;


  dureeC:=10;
  if assigned(rfSys[1])
    then RFDeg:=rfSys[1].deg
    else RFdeg:=degNul;

  grid:=TgridEx.create;
  grid.notpublished:=true;
  grid.Fchild:=true;

  timeMan.nbCycle:=1000;


end;


destructor TplayGrid.destroy;
begin
  grid.free;

  inherited destroy;
end;

procedure TplayGrid.setChildNames;
begin
end;


class function TplayGrid.STMClassName:AnsiString;
begin
  STMClassName:='PlayGrid';
end;


procedure TplayGrid.InitMvt;
var
  i,j:integer;
begin
  SortSyncPulse;
  index:=-1;

  grid.initGrille(RFdeg,nx,ny);
  with TimeMan do tend:=torg+dureeC*nbCycle;

  setLength(GridCol,nbLum);
  for i:=0 to nbLum-1 do
    GridCol[i]:= syspal.DX9color(LumMin+i*DeltaLum);


end;


procedure TplayGrid.initObvis;
begin
end;


procedure TplayGrid.calculeMvt;
var
  i,j:integer;
begin
  if (timeS>=0) and (timeS mod dureeC=0) then inc(Index);
  if index< IndexCount then
  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
     grid.GridCol[i,j]:=  GridCol[values[i,j,index]]
  else
   for i:=0 to nx-1 do
  for j:=0 to ny-1 do
     grid.GridCol[i,j]:=  devColBK;


end;

procedure TplayGrid.doneMvt;
var
  i,j:integer;
begin

end;

procedure TplayGrid.setVisiFlags(obOn:boolean);
begin
  grid.FlagOnScreen:=affStim and ObON;
  grid.FlagOnControl:=affControl and ObON;
end;

procedure TplayGrid.buildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    inherited;
    with conf do
    begin
      if tout then setvarConf('OBVIS',intG(obvis),sizeof(intG));
    end;
  end;

procedure TplayGrid.CompleteLoadInfo;
begin
  CheckOldIdent;
  majPos;
end;


procedure TplayGrid.setObvis(uo: typeUO);
begin
  inherited;
end;

procedure TplayGrid.setLums(nb: integer; lum1, lum2: float);
var
  i:integer;
begin
  nbLum:=nb;
  LumMin:=lum1;
  DeltaLum:=(lum2-lum1)/nb;
end;

function TplayGrid.setRawValues(vv: TvectorArray): boolean;
var
  i,j,k: integer;

function Ilum(x:float):integer;
begin
  result:=round((x-LumMin)/DeltaLum) ;
  if result<0 then result:=0
  else
  if result>nbLum-1 then result:=nbLum-1;
end;

begin
  try
    nx:=vv.imax-vv.imin+1;
    ny:=vv.jmax-vv.jmin+1;

    IndexCount:=vv[vv.imin,vv.jmin].Icount;
    CycleCount:=IndexCount+1;

    setLength(values,nx,ny,IndexCount);

    for i:=0 to nx-1 do
    for j:=0 to ny-1 do
    for k:=0 to IndexCount-1 do
      values[i,j,k]:=Ilum(vv[vv.imin+i,vv.jmin+j][vv.Istart+k]);

    result:=true;

  except
    setLength(values,0,0,0);
    IndexCount:=-1;
    result:=false;
  end;

end;

function TplayGrid.setValues(vv: TvectorArray): boolean;
var
  i,j,k: integer;

function Ilum(x:float):integer;
begin
  result:=round((x-LumMin)/DeltaLum) ;
  if result<0 then result:=0
  else
  if result>nbLum-1 then result:=nbLum-1;
end;

begin
  try
    nx:=vv.imax-vv.imin+1;
    ny:=vv.jmax-vv.jmin+1;

    with vv[vv.imin,vv.jmin] do
    begin
      IndexCount:=floor((Xend-Xstart)/(DtON*Tfreq/1000));

    end;
    CycleCount:=IndexCount+1;

    setLength(values,nx,ny,IndexCount);

    for i:=0 to nx-1 do
    for j:=0 to ny-1 do
    for k:=0 to IndexCount-1 do
      values[i,j,k]:=Ilum(vv[vv.imin+i,vv.jmin+j].Rvalue[vv.Xstart+k*DtON*Tfreq/1000]);

    result:=true;

  except
    setLength(values,0,0,0);
    IndexCount:=-1;
    result:=false;
  end;

end;

function TplayGrid.valid: boolean;
begin
  result:=true;
end;


{*************************** Méthodes STM ************************************}


procedure proTplayGrid_create(var pu:typeUO);
begin
  createPgObject('',pu,TplayGrid);
end;

procedure proTplayGrid_setLums(nb:integer; Lum1,Lum2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  if (nb<2) or (nb>255) then sortieErreur('TplayGrid.setLums : invalid number of luminances');
  if (lum1<0) or (lum2<=lum1) or (lum2>10000) then sortieErreur('TplayGrid.setLums : invalid luminance');

  TplayGrid(pu).setLums(nb,lum1,lum2);
end;

procedure proTplayGrid_setValues(var VV:TvectorArray;Fraw:boolean; var pu:typeUO);
var
  ok: boolean;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(VV));

  if Fraw
    then ok:= TplayGrid(pu).setRawValues(VV)
    else ok:= TplayGrid(pu).setValues(VV);

  if not ok then sortieErreur('TplayGrid.setValues : unable to build grids ');
end;

function fonctionTplayGrid_Xcount(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:=TplayGrid(pu).nx;
end;

function fonctionTplayGrid_Ycount(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:=TplayGrid(pu).ny;
end;

procedure proTplayGrid_setRF(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(num,1,5);
  TplayGrid(pu).RFdeg:=RFsys[num].deg;
end;

procedure proTplayGrid_AdjustObjectSize(ww:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TplayGrid(pu).AdjustObjectSize:=ww;
end;

function fonctionTplayGrid_AdjustObjectSize(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TplayGrid(pu).AdjustObjectSize;
end;




Initialization
AffDebug('Initialization stmPlayGrid',0);

registerObject(TplayGrid,stim);


end.
