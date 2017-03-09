unit MotionCloud1;


interface

uses windows,classes,sysutils,graphics,
     util1,
     stmObj,stmPg,stmError,Ncdef2,debug0,
     stmMat1;



var
  MCInit: procedure ( ss, rf, tf, rs, ts, eta, alpha: single; y,x:integer; seed: longword; ty:integer);cdecl;
  MCDone: procedure;cdecl;
  MCgetFrame: function : pointer;cdecl;



function InitMCDLL:boolean;


type
  TmotionCloud=
              class(typeUO)

              private
                Nx,Ny:integer;
                Finit: boolean;
              public
                constructor create;override;
                destructor destroy;override;

                class function STMClassName:AnsiString;override;

                procedure Init( ss, rf, tf, rs, ts, eta, alpha: single; Nx1,Ny1:integer; seed: longword; ty:integer);
                procedure done;
                procedure getFrame(mat: Tmatrix);
              end;


procedure proTmotionCloud_Create(var pu:typeUO);pascal;
procedure proTmotionCloud_Init(ss, rf, tf, rs, ts, eta, alpha: single; Nx1,Ny1: integer; seed: longword; Fty: boolean;var pu:typeUO);pascal;
procedure proTmotionCloud_done(var pu:typeUO);pascal;
procedure proTmotionCloud_getFrame(var mat: Tmatrix; var pu:typeUO);pascal;


implementation

var
  hh: intG;


function InitMCDLL:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary('MotionCloud.dll');
  result:=(hh<>0);

  if not result then exit;

  MCInit:= getProc(hh,'Init');
  MCDone:= getProc(hh,'done');
  MCgetFrame:= getProc(hh,'Get_next_frame');
end;



{ TmotionCloud }

constructor TmotionCloud.create;
begin
  inherited;
  if not initMCdll then sortieErreur('TmotionCloud : unable to initialize MCdll');
end;

destructor TmotionCloud.destroy;
begin
  FreeLibrary(hh);
  hh:=0;
  inherited;
end;

procedure TmotionCloud.done;
begin
  // MCDone;                  vaut nil
  Finit:=false;
end;

procedure TmotionCloud.getFrame(mat: Tmatrix);
var
  p,tbS: PtabSingle;
  i,j:integer;

begin
  if not initMCdll then sortieErreur('TmotionCloud : MCdll not initialized');
  if not Finit then sortieErreur('TmotionCloud : TmotionCloud not initialized');

  p:= MCgetFrame;

  mat.initTemp(0,Nx-1,0,Ny-1,g_single);
  tbS:=mat.tb;

  for j:=0 to Ny-1 do
  for i:=0 to Nx-1 do
    tbS^[j+Ny*i]:= p^[i+Nx*j];
    
    {mat[i,j]:=p^[i+Nx*j];}

end;

procedure TmotionCloud.Init(ss, rf, tf, rs, ts, eta, alpha: single; Nx1,Ny1: integer; seed: longword; ty: integer);
begin
  if not initMCdll then sortieErreur('TmotionCloud : MCdll not initialized');
  Finit:=true;
  MCinit(ss, rf, tf, rs, ts, eta, alpha, Ny1, Nx1, seed, ty);

  Nx:= Nx1;
  Ny:= Ny1;
end;

class function TmotionCloud.STMClassName: AnsiString;
begin
  result:='MotionCloud';
end;


procedure proTmotionCloud_Create(var pu:typeUO);
begin
  createPgObject('',pu,TmotionCloud);
end;

procedure proTmotionCloud_Init(ss, rf, tf, rs, ts, eta, alpha: single; Nx1,Ny1: integer; seed: longword; Fty: boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmotionCloud(pu) do
    init(ss, rf, tf, rs, ts, eta, alpha, Nx1,Ny1, seed, ord(Fty));
end;

procedure proTmotionCloud_done(var pu:typeUO);
begin
  verifierObjet(pu);
  with TmotionCloud(pu) do done;
end;

procedure proTmotionCloud_getFrame(var mat: Tmatrix; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);
  with TmotionCloud(pu) do getFrame(mat);
end;




end.



Initialization

registerObject(TmotionCloud,sys);

end.
