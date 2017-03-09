unit stmWt1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     util1,Dgraphic,varconf1,dtf0,debug0,
     stmdef,stmObj,stmVec1,IspGS1,stmISPL1,
     stmPg,stmError,Ncdef2,stmMat1;

type
  TWavelet=
    class(typeUO)
      wtState: TNSPWtState;
      Vtemp:Tvector;         {Templates décomposition et reconstruction}
      VD:array[1..32] of Tvector;    {Accès direct aux différents blocs}
      VA:Tvector;
      Fdouble:boolean;               {travail en double précision}

      DxInit,X0init:float;           {Paramètres d'échelle du vecteur décomposé}

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;

      function initialise(st:AnsiString):boolean;override;

      procedure setChildNames;override;
      procedure saveToStream(f:Tstream;Fdata:boolean);override;
      function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;
      procedure ProcessMessage(id:integer;source:typeUO;p:pointer);override;

      procedure decompose(vec:Tvector;level:integer);
      procedure reconstruct(vec:Tvector);


      property WtType:integer read wtState.WtType write wtState.WtType;
      property Par1:integer read wtState.Par1 write wtState.Par1;
      property Par2:integer read wtState.Par2 write wtState.Par2;
      property Level_dec:integer read wtState.level write wtState.level;
      property Len_dec:integer read wtState.len_dec;

      function Lini:integer;

      function Par1Par2Valid:boolean;
      procedure UpdateVD;

      function WtTypeString:AnsiString;
      procedure Scalogram(vec:Tvector;mat:Tmatrix;level:integer;Freconstruct:boolean);
    end;


procedure proTwavelet_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTwavelet_create_1(var pu:typeUO);pascal;
procedure proTwavelet_decompose(var vec:Tvector;level:integer;var pu:typeUO);pascal;
procedure proTwavelet_reconstruct(var vec:Tvector;var pu:typeUO);pascal;


function fonctionTwavelet_Vtemp(var pu:typeUO):Tvector;pascal;
function fonctionTwavelet_VD(i:integer;var pu:typeUO):Tvector;pascal;
function fonctionTwavelet_VA(var pu:typeUO):Tvector;pascal;

function fonctionTwavelet_Level(var pu:typeUO):integer;pascal;

function fonctionTwavelet_WtType(var pu:typeUO):integer;pascal;
procedure proTwavelet_WtType(w:integer;var pu:typeUO);pascal;

function fonctionTwavelet_Par1(var pu:typeUO):integer;pascal;
procedure proTwavelet_Par1(w:integer;var pu:typeUO);pascal;

function fonctionTwavelet_Par2(var pu:typeUO):integer;pascal;
procedure proTwavelet_Par2(w:integer;var pu:typeUO);pascal;

function fonctionTwavelet_WtTypeString(var pu:typeUO):AnsiString;pascal;

procedure proTWavelet_Scalogram(var vec:Tvector;var mat: Tmatrix;level:integer;
                                 Freconstruct:boolean;var pu:typeUO);pascal;

implementation

{ TWavelet }

constructor TWavelet.create;
var
  i:integer;
begin
  inherited;

  if initIspl then
    nspsWtInit(0,0, 8,7,WtState,NSP_Haar);

  Vtemp:=Tvector.create;
  Vtemp.initTemp1(0,1,G_single);
  AddTochildList(Vtemp);

  for i:=1 to 32 do
  begin
    VD[i]:=Tvector.create;
    AddTochildList(VD[i]);
  end;
  VA:=Tvector.create;
  AddTochildList(VA);

  ISPend;
end;

destructor TWavelet.destroy;
var
  i:integer;
begin
  Vtemp.free;
  for i:=1 to 32 do VD[i].Free;
  VA.free;

  inherited;
end;

function Twavelet.Lini: integer;
begin
  result:=wtState.tree[0];
end;

class function TWavelet.stmClassName: AnsiString;
begin
  result:='Wavelet';
end;

procedure TWavelet.setChildNames;
var
  i:integer;
begin
  with Vtemp do
  begin
    ident:=self.ident+'.Vtemp';
  end;

  for i:=1 to 32 do
  with VD[i] do
  begin
    ident:=self.ident+'.VD['+Istr(i)+']';
  end;

  with VA do
  begin
    ident:=self.ident+'.VA';
  end;

end;


procedure TWavelet.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;
  conf.setvarconf('WtState',WtState,sizeof(WtState));

end;

procedure TWavelet.saveToStream(f: Tstream; Fdata: boolean);
begin
  inherited saveToStream(f,Fdata);

  Vtemp.saveToStream(f,Fdata);
end;

function TWavelet.loadFromStream(f: Tstream; size: LongWord; Fdata: boolean): boolean;
begin
  result:=inherited loadFromStream(f,size,Fdata);

  if not result then exit;
  if f.position>=f.size then exit;

  if result then result:=Vtemp.loadAsChild(f,Fdata);
end;


function TWavelet.initialise(st: AnsiString): boolean;
begin
  result:=inherited initialise(st);
  setChildNames;
end;

procedure TWavelet.ProcessMessage(id: integer; source: typeUO; p: pointer);
begin
  inherited;
  case id of
    UOmsg_invalidateData:
      begin
        if source=Vtemp then UpdateVD;
      end;

  end;
end;


function MaxLevel(nbData:integer;var isP2:boolean):integer;
var
  level,nb:integer;
begin
  level:=0;
  nb:=1;
  repeat
    nb:=nb*2;
    inc(level);
  until (nb=nbData) or (nb>=2*nbdata);
  result:=level-1;
  isP2:=(nb=nbdata);
end;


function TWavelet.Par1Par2Valid: boolean;
begin
  case WtType of
    NSP_Haar:          result:=true;
    NSP_Daublet:       result:= (par1>=1) and (par1<=10);
    NSP_Symmlet:       result:= (par1>=1) and (par1<=7);

    NSP_Coiflet:       result:= (par1>=1) and (par1<=5);

    NSP_Vaidyanathan:  result:=true;

    NSP_BSpline,NSP_BSplineDual:
                       result:= (par1=1) and (par2 in [1,3,5])
                                OR
                                (par1=2) and (par2 in [2,4,6,8])
                                OR
                                (par1=3) and (par2 in [1,3,5,7,9]);

    NSP_LinSpline:      result:=true;
    NSP_QuadSpline:     result:=true;

    else result:=false;
  end;
end;

procedure TWavelet.UpdateVD;
var
  i,k:integer;
  data0:typedataS;
begin
  k:=len_dec;
  for i:=1 to level_dec do
  begin
    k:=k-wtState.tree[i];
    data0:=typeDataS.create(@Ptabsingle(Vtemp.tb)^[k],1,0,0,wtState.tree[i]-1);
    VD[i].initDat1ex(data0,G_single);
    VD[i].inf.readOnly:=false;
    if VD[i].Icount>1
      then VD[i].Dxu:=DxInit*Lini/(VD[i].Icount-1)
      else VD[i].Dxu:=1;
  end;

  for i:=level_dec+1 to 32 do
    VD[i].initTemp1(0,0,G_single);

  data0:=typeDataS.create(Vtemp.tb,1,0,0,k-1);
  VA.initDat1ex(data0,G_single);
  VA.inf.readOnly:=false;
  if VA.Icount>1
    then VA.Dxu:=DxInit*Lini/(VA.Icount-1)
    else VA.Dxu:=1;
end;


procedure TWavelet.decompose(vec: Tvector;level:integer);
var
  src:array of single;
  i:integer;
  isP2:boolean;
  len1,nbpt:integer;
  levmax:integer;

begin
  ISPtest;
  nbpt:=vec.Icount;
  if nbpt<2 then exit;

  setLength(src,nbpt);
  for i:=0 to nbpt-1 do
    src[i]:=vec.Yvalue[i+vec.Istart];

  DxInit:=vec.Dxu;
  X0init:=vec.X0u;

  levmax:=maxLevel(nbpt,isP2);
  if (level<=0) or (level>levmax)
    then level:=levmax;

  if isP2 then
  begin
    nspsWtInit(Par1, Par2, Levmax+1, Level, WtState, WtType);
    Len1:=Lini;
  end
  else nspsWtInitlen(par1,par2,nbpt,level,wtState,wtType,Len1);

  Vtemp.modify(g_single,0,Len1-1);
  Vtemp.Dxu :=nbpt*vec.Dxu/Len1;

  nspsWtDecompose(WtState,@Src[0], Vtemp.tb  );

  with Vtemp do
    copyDataFromVec(Vtemp,Istart,Iend,Istart);

  updateVD;

  ISPend;
end;


procedure TWavelet.reconstruct(vec: Tvector);
begin
  if (Lini<2) or (Vtemp.Icount<>len_dec) then exit;

  vec.modify(g_single,0,Lini-1);
  vec.Dxu:=DxInit;
  vec.X0u:=X0init;

  ISPtest;
  nspsWtReconstruct(WtState, Vtemp.tb, vec.tb);
  ISPend;
end;

function TWavelet.WtTypeString: AnsiString;
begin
  result:=' Haar |'+
          ' Daublet |'+
          ' Symmlet |'+
          ' Coiflet |'+
          ' Vaidyanathan |'+
          ' BSpline |'+
          ' BSplineDual |'+
          ' LinSpline |'+
          ' QuadSpline ';
end;

procedure TWavelet.Scalogram(vec:Tvector;mat: Tmatrix;level:integer;Freconstruct:boolean);
var
  i,j:integer;
  levmax:integer;
  VV:array of single;
  vec2:Tvector;
begin
  if not assigned(mat) then exit;
  if not assigned(vec) or (vec.Icount<2) then exit;

  decompose(vec,0);
  levmax:=level_dec;
  if (level<=0) or (level>levmax)
    then level:=levmax;

  mat.initTemp(0,Lini-1,1,level,g_single);
  mat.Dxu:=vec.Dxu;

  if Freconstruct then
  begin
    setLength(VV,Len_dec);
    move(Psingle(Vtemp.tb)^,VV[0],sizeof(single)*Len_dec);
    vec2:=Tvector.create;
    vec2.initTemp1(0,Lini-1,g_single);

    for j:=1 to level do
    begin
      move(VV[0],Psingle(Vtemp.tb)^,sizeof(single)*Len_dec);
      for i:=1 to Level do
        if i<>j then VD[i].fill(0);
      reconstruct(vec2);

      for i:=0 to Lini-1 do
        mat.Zvalue[i,j]:=Vec2.Yvalue[i];
    end;

    vec2.free;
  end
  else
  begin
    for j:=1 to level do
    begin
      decompose(vec,j);
      for i:=0 to Lini-1 do
        mat.Zvalue[i,j]:=VA.Yvalue[trunc(i/Lini*VA.Icount)];
    end;
  end;
end;


{************************** Méthodes STM ********************************}

var
  E_DetailIndex:integer;
  E_wtType:integer;
  E_Par1Par2:integer;

procedure proTwavelet_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,Twavelet);

  with Twavelet(pu) do
  begin
    setChildNames;
  end;
end;

procedure proTwavelet_create_1(var pu:typeUO);
begin
  proTwavelet_create('',pu);
end;

procedure proTwavelet_decompose(var vec:Tvector;level:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  with Twavelet(pu) do
  begin
    if not Par1Par2Valid then sortieErreur(E_Par1Par2);
    decompose(vec,level);
  end;
end;

procedure proTwavelet_reconstruct(var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  with Twavelet(pu) do
  begin
    if not Par1Par2Valid then sortieErreur(E_Par1Par2);
    reconstruct(vec);
  end;
end;

function fonctionTwavelet_Vtemp(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with Twavelet(pu) do result:=@Vtemp.myAd;
end;


function fonctionTwavelet_VD(i:integer;var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  if (i<1) or (i>32) then sortieErreur(E_DetailIndex);

  with Twavelet(pu) do result:=@VD[i].myAd;
end;

function fonctionTwavelet_VA(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);

  with Twavelet(pu) do result:=@VA.myAd;
end;

function fonctionTwavelet_Level(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Twavelet(pu) do result:=level_dec;
end;

function fonctionTwavelet_WtType(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Twavelet(pu) do result:=WtType;
end;

procedure proTwavelet_WtType(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (w<1) or (w>9) then sortieErreur(E_wtType);
  with Twavelet(pu) do WtType:=w;
end;

function fonctionTwavelet_Par1(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Twavelet(pu) do result:=Par1;
end;

procedure proTwavelet_Par1(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Twavelet(pu) do Par1:=w;
end;

function fonctionTwavelet_Par2(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Twavelet(pu) do result:=Par2;
end;

procedure proTwavelet_Par2(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Twavelet(pu) do Par2:=w;
end;

function fonctionTwavelet_WtTypeString(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with Twavelet(pu) do result:=WtTypeString;
end;

procedure proTWavelet_Scalogram(var vec:Tvector;var mat: Tmatrix;level:integer;
                                Freconstruct:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  verifierObjet(typeUO(mat));

  with Twavelet(pu) do
  begin
    if not Par1Par2Valid then sortieErreur(E_Par1Par2);
    Scalogram(vec, mat, level,Freconstruct);
  end;
end;



Initialization

AffDebug('Initialization stmWT1',0);
registerObject(Twavelet,data);

installError(E_DetailIndex,'Twavelet.VD : index out of range');
installError(E_WtType,'Twavelet.WtType : value out of range');
installError(E_Par1Par2,'Twavelet: invalid parameter set');

end.


