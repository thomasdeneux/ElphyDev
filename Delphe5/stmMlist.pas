unit stmMlist;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,controls,graphics,menus,forms,sysUtils,
     util1,Dgraphic,varconf1,debug0,NcDef2,
     stmdef,stmObj,visu0,stmDplot,stmVec1,stmMat1,stmPopup,formRec0,stmError,
     tpForm0,VLcommand,defForm,getMat0,
     MatLiCom0,MatLiCom1,
     MatCooD0,
     chooseOb,listG,
     stmPg,stmOdat2,
     stmDobj1, matlab_matrix,matlab_mat;

type
  TMatList=
    class(TdataObj)       // 4 septembre 2014 : on remplace TdataPlot par TdataObj

    protected
      Select:TlistG;     {tableau de booleens)}

      onSelect:Tpg2Event;

      Command:TmatlistCommandA;
      FormRecCom:Tformrec;

      degP:typeDegre; {theta fait double emploi avec visu.theta}

      FpalName:AnsiString;
      wf:TWFoptions;

      FonControl:boolean;

      FCpLine:integer;
      Fcompact: boolean;  // mis en place par cancompact au moment de saveToStream
                          // true si toutes les matrices ont la même structure
                          // dans ce cas, les data sont sauvées sous la forme d'un bloc unique

      procedure setTheta(x:single);
      procedure setAspectRatio(x:single);
      procedure setGamma(x:single);
      procedure setTwoCol(x:boolean);

      procedure setKeepRatio(w:boolean);override;

      procedure setPalColor(n:integer;x:integer);
      function getPalColor(n:integer):integer;

      procedure setDisplayMode(n:byte);
      procedure setPalName(st:AnsiString);


      function getSelected(num:integer):boolean;
      procedure setSelected(num:integer;w:boolean);

      procedure setXmin(x:double);override;
      procedure setXmax(x:double);override;
      procedure setYmin(x:double);override;
      procedure setYmax(x:double);override;
      procedure setZmin(x:double);override;
      procedure setZmax(x:double);override;

      procedure setUnitX(st:AnsiString);override;
      procedure setUnitY(st:AnsiString);override;

      procedure setDx(x:double);  override;
      procedure setX0(x:double);  override;
      procedure setDy(x:double);  override;
      procedure setY0(x:double);  override;


      procedure proprietes(sender:Tobject);override;

      function selectedCount:integer;

      procedure OnselectEvent(n:integer);

      function getMat(i:integer):Tmatrix; {i de 1 à count}

      function Mtitle(i:integer):AnsiString;     {i de 1 à count}

      procedure updateCommand;
      procedure createCommand;


      function ChooseCoo1:boolean;override;

      function getOnControl:boolean;override;
      procedure setOnControl(v:boolean);override;
      procedure setFlagOnControl(v:boolean);override;

      procedure Doncontrol(sender:Tobject);
      procedure AfficheC;override;
      function dialogForm:TclassGenForm;override;
      procedure installDialog(var form1:Tgenform;var newF:boolean);override;


    public
      nbmat0:integer;      {=count sert pour la sauvegarde}

      Foptions:TmatlistRecord;
      CommandForm:TVlistCommand;
      CommandRec:Tformrec;

      FirstIndex:integer;     {vaut toujours 1 actuellement}
      ligne1:integer;         {numéro première ligne }


      procedure setCpLine(w:smallint);override;
      function getCpLine: smallint;override;

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;
      procedure clear;override;

      property theta:single read degP.theta write setTheta;
      property Gamma:single read visu.gamma write setGamma;
      property TwoCol:boolean read visu.twoCol write setTwoCol;
      property PalColor[n:integer]:integer read getPalColor write setPalColor;
      property DisplayMode:byte read visu.modeMat write setDisplayMode;
      property PalName:AnsiString read FpalName write setPalName;

      function count:integer;
      property Mat[i:integer]:Tmatrix read getMat;  { i de 1 à count}

      property selected[num:integer]:boolean read getSelected write setSelected ;
      {selected utilise les indices réels de FirstIndex à FirstIndex+count-1
      }

      procedure Display;override;
      procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                              const order:integer=-1); override;


      procedure cadrerX(sender:Tobject);override;
      procedure cadrerY(sender:Tobject);override;
      procedure cadrerZ(sender:Tobject);override;
      procedure cadrerC(sender:Tobject);override;

      procedure autoscaleX;override;
      procedure autoscaleY;override;
      procedure autoscaleZ;override;
      procedure AutoScaleZsym;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      procedure completeLoadInfo;override;
      procedure saveData(f:Tstream);override;
      function loadData(f:Tstream):boolean;override;
      procedure saveToStream( f:Tstream;Fdata:boolean);override;
      function  loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;


      procedure resetAll;override;


      function MouseDownMG(numOrdre:integer;Irect:Trect;
               Shift: TShiftState; Xc,Yc,X, Y: Integer):boolean;override;

      function getPopUp:TpopupMenu;override;

      procedure showCommand(sender:Tobject);

      procedure initCommandForm;
      {initialise la scrollbar avec ligne1, count}

      procedure createCommandForm;

      {réponses aux événements de VListCommand}
      procedure setFirstLine(num:integer);

      procedure selectAllG;
      procedure unselectAllG;
      procedure SaveSelectionG(modeAppend:boolean);
      procedure CopySelectionG;

      procedure AddClone(p:Tmatrix);
      function getClone(i:integer):Tmatrix;

      procedure AddMatrix(m:Tmatrix);
      procedure InsertMatrix(n:integer;m:Tmatrix);
      procedure deleteMatrix(n:integer);


      procedure processMessage(id:integer;source:typeUO;p:pointer);override;

      function curPos:integer;    {Numéro sélectionné dans CommandForm, de 1 à count}
      procedure DisplayGraph;

      procedure getMinMaxI(var Vmin,Vmax:integer);
      procedure getMinMax(var Vmin,Vmax:float);

      procedure setChildNames;override;

      procedure saveToVectorArray(va:TvectorArray;tpN:typetypeG);
      function isVisual:boolean;override;

      function getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;override;
      procedure setMxArray(mxArray:MxArrayPtr;Const invertIndices:boolean=false);override;

      function canCompact: boolean;
      procedure Filter1( matF: Tmatrix; vecF: Tvector);
    end;


procedure proTmatList_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTmatList_create_1(var pu:typeUO);pascal;
procedure proTmatList_AddMatrix(var vec:TMatrix;var pu:typeUO);pascal;
procedure proTmatList_InsertMatrix(n:integer;var vec:TMatrix;var pu:typeUO);pascal;
procedure proTmatList_DeleteMatrix(num:integer;var pu:typeUO);pascal;
procedure proTmatList_Clear(var pu:typeUO);pascal;

function fonctionTmatlist_M(i:integer;var pu:typeUO):pointer;pascal;


function fonctionTmatList_count(var pu:typeUO):integer;pascal;
procedure proTmatList_Index(n:integer;var pu:typeUO);pascal;
function fonctionTmatList_Index(var pu:typeUO):integer;pascal;
procedure proTmatList_Selected(n:integer;x:boolean;var pu:typeUO);pascal;
function fonctionTmatList_Selected(n:integer;var pu:typeUO):boolean;pascal;
procedure proTmatList_OnSelect(p:integer;var pu:typeUO);pascal;
function fonctionTmatList_OnSelect(var pu:typeUO):integer;pascal;
procedure proTmatList_CpLine(p:integer;var pu:typeUO);pascal;
function fonctionTmatList_CpLine(var pu:typeUO):integer;pascal;

function fonctionTmatList_Zmin(var pu:typeUO):float;pascal;
procedure proTmatList_Zmin(x:float;var pu:typeUO);pascal;

function fonctionTmatList_Zmax(var pu:typeUO):float;pascal;
procedure proTmatList_Zmax(x:float;var pu:typeUO);pascal;


function fonctionTmatList_theta(var pu:typeUO):float;pascal;
procedure proTmatList_theta(x:float;var pu:typeUO);pascal;

function fonctionTmatList_AspectRatio(var pu:typeUO):float;pascal;
procedure proTmatList_AspectRatio(x:float;var pu:typeUO);pascal;

function fonctionTmatList_PixelRatio(var pu:typeUO):float;pascal;
procedure proTmatList_PixelRatio(x:float;var pu:typeUO);pascal;


function fonctionTmatList_gamma(var pu:typeUO):float;pascal;
procedure proTmatList_gamma(x:float;var pu:typeUO);pascal;

function fonctionTmatList_TwoColors(var pu:typeUO):boolean;pascal;
procedure proTmatList_TwoColors(x:boolean;var pu:typeUO);pascal;

function fonctionTmatList_PalColor(n:integer;var pu:typeUO):integer;pascal;
procedure proTmatList_PalColor(n:integer;x:integer;var pu:typeUO);pascal;

procedure proTmatList_PalName(x:AnsiString;var pu:typeUO);pascal;
function fonctionTmatList_PalName(var pu:typeUO):AnsiString;pascal;

procedure proTmatList_DisplayMode(x:integer;var pu:typeUO);pascal;
function fonctionTmatList_DisplayMode(var pu:typeUO):integer;pascal;

procedure proTmatList_getMinMaxI(var Vmin,Vmax:longint;var pu:typeUO);pascal;
procedure proTmatList_getMinMax(var Vmin,Vmax:float;var pu:typeUO);pascal;

procedure proTMatList_AutoscaleZ(var pu:typeUO);pascal;
procedure proTMatList_AutoscaleZsym(var pu:typeUO);pascal;

procedure ProTMatList_SaveToVectorArray(var va:TvectorArray;tpN:integer;var pu:typeUO);pascal;

procedure proTmatList_onControl(b:boolean;var pu:typeUO);pascal;
function fonctionTmatList_onControl(var pu:typeUO):boolean;pascal;

procedure proTmatList_setPosition(x,y,dx,dy,theta1:float;var pu:typeUO);pascal;
procedure proTmatlist_AutoscaleXYZ(var pu:typeUO);pascal;


function fonctionTmatList_CpxMode(var pu:typeUO):integer;pascal;
procedure proTmatList_CpxMode(x: integer;var pu:typeUO);pascal;

procedure proTmatlist_UsePosition(b:boolean;var pu:typeUO);pascal;
function fonctionTmatlist_UsePosition(var pu:typeUO):boolean;pascal;

procedure proTMatList_Filter1( var matF: Tmatrix; var vecF: Tvector; var pu:typeUO);pascal;

implementation

uses stmVS0, ippdefs17,ipps17, mathKernel0, MKL_dfti;

constructor TmatList.create;
begin
  inherited create;
  select:=TlistG.create(1);
  firstIndex:=1;
  ligne1:=1;

  visu.color:=longint(2) shl 16+1;
  keepRatio:=true;
end;


destructor TmatList.destroy;
begin
  clear;
  select.free;
  CommandForm.free;
  Command.Free;
  inherited destroy;
end;

class function TmatList.stmClassName:AnsiString;
begin
  result:='MatList';
end;

procedure Tmatlist.clear;
var
  i:integer;
begin
  for i:=0 to count-1 do
  begin
    Tmatrix(childList[i]).free;
  end;

  ClearChildList;
  if assigned(command) then
  with command do
  begin
    ListBox1.clear;
    paintBox1.invalidate;
  end;
end;


function TMatList.getMat(i:integer):Tmatrix;
begin
  if (i>=1) and (i<=count)
    then result:=Tmatrix(ChildList[i-1])
    else result:=nil;
end;


function TmatList.count:integer;
begin
  if assigned(childList)
    then result:=ChildList.count
    else result:=0;
end;


function TmatList.getSelected(num:integer):boolean;
var
  n:integer;
begin
  n:=num-FirstIndex;
  result:=(n>=0) and (n<select.count) and Pboolean(select[n])^;
end;


procedure TmatList.setSelected(num:integer;w:boolean);
var
  n:integer;
begin
  n:=num-FirstIndex;

  if n>=select.count then select.count:=n+1;
  Pboolean(select[n])^:=w;
end;



procedure TmatList.Display;
var
  m:Tmatrix;

  visu1:TvisuInfo;
  degP1:typeDegre;
  FpalName1:AnsiString;
  wf1:TWFoptions;

begin
  m:=mat[ligne1];
  if assigned(m) then
  begin
    visu1.init;
    visu1.assign(m.visu);
    degP1:=m.degP;
    FpalName1:=m.PalName;
    wf1:=m.wf;

    m.visu.assign(visu);
    m.degP:=degP;
    m.palname:=palName;

    m.display;

    m.visu.assign(visu1);
    m.degP:=degP1;
    m.palName:=FPalName1;
    m.wf:=wf1;
  end;
end;

procedure TmatList.displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                                 const order:integer=-1);
var
  m:Tmatrix;

  visu1:TvisuInfo;
  degP1:typeDegre;
  FpalName1:AnsiString;
  wf1:TWFoptions;

begin
  m:=mat[ligne1];
  if assigned(m) then
  begin
    visu1.init;
    visu1.assign(m.visu);
    degP1:=m.degP;
    FpalName1:=m.PalName;
    wf1:=m.wf;

    m.visu.assign(visu);
    m.DisplayInside(nil,extWorld,logX,logY);
    m.visu.assign(visu1);
    m.degP:=degP1;
    m.palName:=FPalName1;
    m.wf:=wf1;
  end;

end;


procedure TmatList.cadrerX(sender:Tobject);
var
  x1,x2:float;
  i:integer;
begin
  if count<1 then exit;

  x1:=1E200;
  x2:=-1E200;

  for i:=1 to count do
  with Mat[i] do
  begin
    if Xstart<x1 then x1:=Xstart;
    if Xend>x2 then x2:=Xend;
  end;

  if (x1<>1E200) and (x2<>-1E200) then
  begin
    visu0^.Xmin:=x1;
    visu0^.Xmax:=x2+1;
  end;

  for i:=1 to count do
  with mat[i] do
  begin
    Xmin:=self.Xmin;
    Xmax:=self.Xmax;
  end;
end;

procedure TmatList.cadrerY(sender:Tobject);
var
  y1,y2:float;
  i:integer;
begin
  if count<1 then exit;

  y1:=1E200;
  y2:=-1E200;

  for i:=1 to count do
  with Mat[i] do
  begin
    if Ystart<y1 then y1:=Ystart;
    if Yend>y2 then y2:=Yend;
  end;

  if (y1<>1E200) and (y2<>-1E200) then
  begin
    visu0^.Ymin:=y1;
    visu0^.Ymax:=y2+1;
  end;

  for i:=1 to count do
  with mat[i] do
  begin
    Ymin:=self.Ymin;
    Ymax:=self.Ymax;
  end;
end;


procedure TmatList.cadrerZ(sender:Tobject);
var
  i:integer;
  z1,z2:float;
begin
  if count<1 then exit;

  z1:=1E200;
  z2:=-1E200;

  for i:=1 to count do
    Mat[i].getMinMax(z1,z2);

  if (z1<>1E200) and (z2<>-1E200) then
  begin
    visu0^.Zmin:=z1;
    visu0^.Zmax:=z2;
  end;

  for i:=1 to count do
  with mat[i] do
  begin
    Zmin:=self.Zmin;
    Zmax:=self.Zmax;
  end;
end;

procedure TmatList.cadrerC(sender:Tobject);
begin
end;

procedure TmatList.autoscaleX;
var
  i:integer;
  x1,x2:float;
begin
  if count<1 then exit;

  x1:=1E200;
  x2:=-1E200;

  for i:=1 to count do
  with Mat[i] do
  begin
    if Xstart<x1 then x1:=Xstart;
    if Xend>x2 then x2:=Xend;
  end;

  if (x1<>1E200) and (x2<>-1E200) then
  begin
    Xmin:=x1;
    Xmax:=x2+1;
  end;

  for i:=1 to count do
  with mat[i] do
  begin
    Xmin:=self.Xmin;
    Xmax:=self.Xmax;
  end;
end;

procedure TmatList.autoscaleY;
var
  i:integer;
  y1,y2:float;
begin
  if count<1 then exit;

  y1:=1E200;
  y2:=-1E200;

  for i:=1 to count do
  with Mat[i] do
  begin
    if Ystart<y1 then y1:=Ystart;
    if Yend>y2 then y2:=Yend;
  end;

  if (y1<>1E200) and (y2<>-1E200) then
  begin
    Ymin:=y1;
    Ymax:=y2+1;
  end;

  for i:=1 to count do
  with mat[i] do
  begin
    Ymin:=self.Ymin;
    Ymax:=self.Ymax;
  end;
end;

procedure TMatList.autoscaleZ;
var
  i:integer;
  z1,z2:float;
begin
  if count<1 then exit;

  z1:=1E200;
  z2:=-1E200;

  for i:=1 to count do
    Mat[i].getMinMax(z1,z2);

  if (z1<>1E200) and (z2<>-1E200) then
  begin
    Zmin:=z1;
    Zmax:=z2;
  end;

  for i:=1 to count do
  with mat[i] do
  begin
    Zmin:=self.Zmin;
    Zmax:=self.Zmax;
  end;
end;

procedure TmatList.AutoScaleZsym;
var
  i:integer;
  Vmin,Vmax:float;
begin
  Vmin:=1E20;
  Vmax:=-1E20;
  getMinMax(Vmin,Vmax);

  if abs(Vmin)<abs(Vmax) then
    begin
      Zmin:=-abs(Vmax);
      Zmax:=abs(Vmax);
    end
  else
    begin
      Zmin:=-abs(Vmin);
      Zmax:=abs(Vmin);
    end;

  for i:=1 to count do
  with mat[i] do
  begin
    Zmin:=self.Zmin;
    Zmax:=self.Zmax;
  end;
end;


function TmatList.ChooseCoo1:boolean;
var
  chg:boolean;
  title0:AnsiString;
  palName0:AnsiString;
  wf0:TwfOptions;
begin
  InitVisu0;
  title0:=title;
  palName0:=palName;
  wf0:=wf;

  if Matcood.choose(title0,visu0^,palName0,@wf,degP,cadrerX,cadrerY,cadrerZ,cadrerC) then
    begin
      chg:= not visu.compare(visu0^) or (title<>title0)
            or (palName0<>palName) or not compareMem(@wf,@wf0,sizeof(wf));
      visu.assign(visu0^);
      title:=title0;
      palName:=palName0;

    end
  else chg:=false;

  DoneVisu0;
  chooseCoo1:=chg;
end;



procedure TmatList.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);

  
  if not lecture then
  begin
    if assigned(Command) then FontToDesc(command.panel1.font,Foptions.FontRec);
    nbmat0:=count;
  end
  else Fcompact:=false;


  CommandRec.setForm(CommandForm);
  with conf do
  begin
    setvarconf('ComRec',CommandRec,sizeof(CommandRec));
    setvarconf('FormRec',FormRec,sizeof(FormRec));
    conf.setvarConf('FirstLine',ligne1,sizeof(ligne1));
    setvarconf('Count',nbmat0,sizeof(nbmat0));
    setvarconf('Fcompact',Fcompact,sizeof(Fcompact));

    setvarConf('DegP',degP,sizeof(degP));
    setStringConf('PalName',FPalName);
    setvarConf('WFopt',wf,sizeof(wf));
  end;

end;

procedure TmatList.completeLoadInfo;
begin
  inherited;

  if assigned(form) then form.caption:=ident;

  CommandRec.restoreFormXY(Tform(Commandform),createCommandForm);

  formRecCom.restoreForm(Tform(Command),createCommand);
  if assigned(command) then
  with Command do
  begin
    caption:=ident;
    DescToFont(Foptions.FontRec,Panel1.font);
    Panel1.color:=Foptions.color;
  end;
end;

function TmatList.loadFromStream(f: Tstream; size: LongWord;Fdata: boolean): boolean;
var
  st1,stID:AnsiString;
  LID:integer;
  posIni:LongWord;
  i,j:integer;

  mat:Tmatrix;
begin
  result:=inherited loadFromStream(f,size,false);
  if not result OR (f.position>=f.size) then exit;

  clear;

  if Fcompact and Fdata then
  begin
    result:=loadData(f);
    setChildNames;
    exit;
  end;


  stID:=ident;
  LID:=length(ident);
  posIni:=f.position;

  for i:=1 to nbmat0 do
  begin
    st1:=readHeader(f,size);

    if (st1=Tmatrix.STMClassName) then
    begin
      mat:=Tmatrix.create;
      with mat do
      begin
        result:=loadFromStream(f,size,Fdata);
        result:=result and Fchild;
        result:=result and (copy(ident,1,LID)=stID);
        if result
          then addClone(mat)
          else mat.Free;
      end;
      if not result then break;
    end;
  end;

  if not result then
    begin
      result:=false;
      f.Position:=posini;
    end;

  setChildNames;
  result:=true;
end;

function TMatList.canCompact: boolean;
var
  i:integer;
  tpNum1: typetypeG;
  i1,i2,j1,j2: integer;
  Dx1, x01, Dy1, y01: double;
begin
  result:= (count>0);
  if result then
  begin
    with mat[1] do
    begin
      tpNum1:= tpNum;
      i1:= Istart;
      i2:= Iend;
      j1:= Jstart;
      j2:= Jend;
      Dx1:= Dxu;
      x01:= x0u;
      Dy1:= Dyu;
      y01:= y0u;
    end;

    for i:=2 to count do
    with mat[i] do
    if (tpNum1<> tpNum) or (i1<> Istart) or (i2<>Iend) or (j1<> Jstart) or (j2<>Jend) or (Dx1<>Dxu) or(x01<>x0u) or (Dy1<>Dyu) or (y01<>y0u) then
    begin
      result:=false;
      exit;
    end;

    inf.tpNum:= tpNum1;
    Istart:= i1;
    Iend:= i2;
    Jstart:= j1;
    Jend:= j2;
    Dxu:=Dx1;
    x0u:=x01;
    Dyu:=Dy1;
    y0u:=y01;
  end;
end;

procedure Tmatlist.saveData(f:Tstream);
var
  i,sz:integer;
begin
  if not CanCompact then exit;

  sz:=(Iend-Istart+1)*(Jend-Jstart+1)*tailleTypeG[tpNum]*count;
  writeDataHeader(f,sz);
  for i:=1 to count do
  with mat[i] do
    if assigned(data) then data.SaveToStream(f);
end;

function TMatList.loadData(f: Tstream): boolean;
var
  i,size:integer;
  mat0:Tmatrix;
begin
  result:=readDataHeader(f,size);
  if result=false then exit;

  if size<>(Iend-Istart+1)*(Jend-Jstart+1)* tailleTypeG[tpNum]*nbMat0 then exit;

  mat0:=Tmatrix.create;
  mat0.initTemp(Istart,Iend,Jstart,Jend,tpNum);
  mat0.Dxu:=Dxu;
  mat0.x0u:=x0u;
  mat0.Dyu:=Dyu;
  mat0.y0u:=y0u;

  mat0.visu.assign(visu);
  for i:=1 to nbMat0 do
  begin
    with mat0 do
      if assigned(data) then data.loadFromStream(f);
    addMatrix(mat0);
  end;
  mat0.Free;
  modifiedData:=true;
end;




procedure TmatList.saveToStream(f: Tstream; Fdata: boolean);
var
  i:integer;
begin
{
  inherited saveToStream(f,Fdata);

  for i:=1 to count do
    mat[i].saveToStream(f,Fdata);
}
  Fcompact:=CanCompact;
  inherited saveToStream(f,false);

  if FCompact and Fdata then saveData(f)
  else
  for i:=1 to count do mat[i].saveToStream(f,Fdata);
end;


procedure TmatList.resetAll;
begin
  if assigned(form) then TPform(form).invalidate;
end;

procedure TmatList.OnselectEvent(n:integer);
begin
  with onSelect do
    if valid then pg.executerVlistSelect(ad,typeUO(self.MyAd),n);
end;


function TmatList.MouseDownMG(numOrdre:integer;Irect:Trect;
               Shift: TShiftState; Xc,Yc,X, Y: Integer):boolean;
begin

  result:=inherited MouseDownMG(numOrdre,Irect,Shift,Xc,Yc,X, Y);

end;


function TmatList.getPopUp:TpopupMenu;
begin
  with PopUps do
  begin
    PopUpItem(pop_TVList,'TVList_Coordinates').onclick:=ChooseCoo;
    PopupItem(pop_TVList,'TVList_ShowPlot').onclick:=self.Show;

    PopupItem(pop_TVList,'TVlist_ShowViewer').onclick:=ShowCommand;
    PopupItem(pop_TVList,'TVlist_ShowViewer').Caption:='Commands';

    PopupItem(pop_TVList,'TVList_Properties').onclick:=Proprietes;
    PopupItem(pop_TVList,'TVList_SaveObject').onclick:=SaveObjectToFile;
    PopupItem(pop_TVList,'TVList_Clone').onclick:=CreateClone;

    result:=pop_TVList;
  end;
end;

procedure TmatList.setFirstLine(num:integer);
begin
  if ligne1=num then exit;
  ligne1:=num;
  invalidate;
  if OnControl then invalidateControlScreen;
  if cpLine<>0 then messageCpLine;
end;


procedure TmatList.createCommandForm;
begin
  commandForm:=TVlistCommand.create(formStm);
  with commandForm do
  begin
    caption:=ident;
    initParams(ligne1,1,count);

    modifyIcur:=setFirstLine;
    selectAll:=selectAllG;
    unselectAll:=unselectAllG;
    SaveSelection:=SaveSelectionG;
    CopySelection:=CopySelectionG;
  end;
end;

procedure TmatList.initCommandForm;
begin
  if assigned(commandForm) then commandForm.initParams(ligne1,1,count);
end;

procedure TmatList.showCommand(sender:Tobject);
begin
  if not assigned(Commandform) then createCommandForm;
  if assigned(Commandform) then
    begin
      Commandform.caption:=ident;
      Commandform.show;
    end;
end;

procedure TmatList.selectAllG;
var
  i:integer;
begin
  for i:=1 to count do selected[i]:=true;

end;

procedure TmatList.unselectAllG;
var
  i:integer;
begin
  for i:=1 to count do selected[i]:=false;

end;


procedure TmatList.SaveSelectionG(modeAppend:boolean);
begin
end;



procedure TmatList.CopySelectionG;
var
  ob:TmatList;
  i:integer;
begin
  ChooseObject.caption:='Choose destination';
  if chooseObject.execution(TmatList,typeUO(ob)) then
      for i:=0 to count-1 do
        if selected[i] then ob.addClone(getClone(i));
end;


procedure TmatList.proprietes(sender:Tobject);
begin
end;


procedure TmatList.AddClone(p:Tmatrix);
var
  i:integer;
begin
   p.ident:=Mtitle(count+1);
   p.notPublished:=false;
   p.Fchild:=true;
   with p do
   begin
     inf.readOnly:=false;
     Cpx:=0;
     Cpy:=0;
   end;

   AddToChildlist(p);

   if assigned(Command) then
     command.ListBox1.items.add(Mtitle(count));
end;

function TmatList.getClone(i:integer):Tmatrix;
var
  j:integer;
begin
  result:=Tmatrix(mat[i].clone(true));
  result.ident:=ident+'_';

  with result do
  begin
    Cpx:=0;
    Cpy:=0;
    CpZ:=0;
  end;

end;

procedure TmatList.AddMatrix(m: Tmatrix);
var
  p:Tmatrix;
begin
  if assigned(m)
    then p:=Tmatrix(m.clone(true));
  if assigned(p) then AddClone(p);
end;

procedure TmatList.deleteMatrix(n: integer);
begin
  if (n>=1) and (n<=count) then
  begin
    Tmatrix(childList[n-1]).free;
    childList.Delete(n-1);
    setChildNames;

    if assigned(command) then
    begin
      command.ListBox1.items.delete(n-1);
      updateCommand;
    end;
  end;
end;

procedure Tmatlist.InsertMatrix(n:integer;m:Tmatrix);
var
  p:Tmatrix;
begin
  if (n<1) or (n>count+1) then exit;
  if assigned(m)
    then p:=Tmatrix(m.clone(true));
  if assigned(p) then
  begin
    AddClone(p);
    with childList do Move(count-1,n-1);
  end;
  setChildNames;
end;



function TmatList.selectedCount:integer;
var
  i:integer;
begin
  result:=0;
  for i:=FirstIndex to FirstIndex+count-1 do
    if selected[i] then inc(result);
end;


procedure TmatList.processMessage(id: integer; source: typeUO; p: pointer);
begin
  inherited;

  case id of
    UOmsg_LineCoupling:
       if (TmatList(source).cpLine<>0) and (TmatList(source).cpLine=cpLine) and
          (TmatList(source).ligne1<>Ligne1) then
          begin
            Ligne1:=TmatList(source).Ligne1;
            invalidate;
          end;
  end;
end;


procedure TMatList.createCommand;
begin
  if assigned(command) then exit;

  Command:=TmatListCommandA.create(formStm);
  with Command do
  begin
    UO:=self;
    optionsG:=@Foptions;
  end;

  with Foptions do
  begin
    fontToDesc(Command.panel1.font,FontRec);
    color:=Command.panel1.color;
  end;

  Command.Caption:=ident;
  updateCommand;

end;

function TMatList.Mtitle(i: integer): AnsiString;
begin
  result:=Ident+'.'+'M'+Istr(i);
end;

procedure TMatList.updateCommand;
var
  i:integer;
  st:AnsiString;
begin
  if assigned(Command) then
  with command.ListBox1 do
  begin
    items.beginUpdate;
    clear;
    for i:=1 to self.count do
      items.add(Mtitle(i));
    items.endUpdate;
  end;
end;

procedure TMatList.DisplayGraph;    {Appelée seulement par command}
begin
  if assigned(Command) and
     Foptions.FdisplayGraph and assigned(Mat[Command.listBox1.itemIndex+1]) then
    begin
      Mat[curPos].display;
    end;
end;

function Tmatlist.curPos:integer;
begin
  if assigned(Command)
    then result:=Command.listBox1.itemIndex +1
    else result:=0;
end;

procedure TmatList.setTheta(x:single);
var
  i:integer;
begin
  degP.theta:=x;
  for i:=1 to count do mat[i].theta:=x;
end;

procedure TmatList.setAspectRatio(x:single);
var
  i:integer;
begin
  inherited aspectRatio:=x;
  for i:=1 to count do mat[i].aspectRatio:=x;
end;

procedure TmatList.setGamma(x:single);
var
  i:integer;
begin
  visu.gamma:=x;
  for i:=1 to count do mat[i].gamma:=x;
end;

procedure TmatList.setTwoCol(x:boolean);
var
  i:integer;
begin
  visu.twoCol:=x;
  for i:=1 to count do mat[i].twoCol:=x;
end;

procedure TmatList.setKeepRatio(w:boolean);
var
  i:integer;
begin
  inherited setKeepRatio(w);
  for i:=1 to count do mat[i].KeepRatio:=w;
end;


procedure TmatList.setPalColor(n:integer;x:integer);
var
  i:integer;
begin
  case n of
    1:TmatColor(visu.Color).col1:=x;
    2:TmatColor(visu.Color).col2:=x;
  end;
  for i:=1 to count do mat[i].PalColor[n]:=x;
end;

function TmatList.getPalColor(n:integer):integer;
begin
  case n of
    1:result:=TmatColor(visu.Color).col1;
    2:result:=TmatColor(visu.Color).col2;
  end;
end;

procedure TmatList.setDisplayMode(n:byte);
var
  i:integer;
begin
  visu.modeMat:=n;
  for i:=1 to count do mat[i].DisplayMode:=n;
end;

procedure TmatList.setPalName(st:AnsiString);
var
  i:integer;
begin
  FpalName:=st;
  for i:=1 to count do mat[i].PalName:=st;
end;



procedure TmatList.getMinMaxI(var Vmin,Vmax:integer);
var
  i:integer;
begin
  for i:=1 to count do mat[i].getMinMaxI(Vmin,Vmax);
end;

procedure TmatList.getMinMax(var Vmin,Vmax:float);
var
  i:integer;
begin
  for i:=1 to count do mat[i].getMinMax(Vmin,Vmax);
end;

procedure TmatList.setChildNames;
var
  i:integer;
begin
  for i:=1 to count do
    mat[i].ident:=ident+'.m'+Istr(i);

  if assigned(command)
    then command.Caption:=ident;
end;

procedure TMatList.saveToVectorArray(va: TvectorArray;tpN:typetypeG);
var
  i,j,k:integer;
begin
  if count<1 then exit;

  with mat[1] do
  va.initArray(Istart,Iend,Jstart,Jend);

  va.initVectors(1,count,tpN);

  for k:=1 to count do
  with mat[k] do
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
    va[i,j][k]:= Zvalue[i,j];

end;

procedure TMatList.AfficheC;
var
  m:Tmatrix;

  visu1:TvisuInfo;
  degP1:typeDegre;
  FpalName1:AnsiString;
  wf1:TWFoptions;

begin
  m:=mat[ligne1];
  if assigned(m) then
  begin
    visu1.init;
    visu1.assign(m.visu);
    degP1:=m.degP;
    FpalName1:=m.PalName;
    wf1:=m.wf;

    m.visu.assign(visu);                                                                              
    m.degP:=degP;
    m.palname:=palName;

    m.afficheC;

    m.visu.assign(visu1);
    m.degP:=degP1;
    m.palName:=FPalName1;
    m.wf:=wf1;
  end;
end;


procedure TMatList.Doncontrol(sender: Tobject);
begin
  if not assigned(DXcontrol) then exit;
  onControl:=not onControl;
end;

function TMatList.getOnControl: boolean;
begin
  result:=FonControl;
end;

procedure TMatList.installDialog(var form1: Tgenform; var newF: boolean);
begin
  installForm(form1,newF);

  with TgetMatrix(Form1) do
  begin
    onshowD:=self.show;
    onControlD:=setOnControl;
    VonControl:=onControl;
    CbOnControl.setVar(VonControl);
  end;
end;

function Tmatlist.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetMatrix;
end;

procedure TMatList.setFlagOnControl(v: boolean);
begin
  FonControl:=v;
end;

procedure TMatList.setOnControl(v: boolean);
begin
  FonControl:=v;
  if v then bringToFront;
  inherited;
end;

function TMatList.isVisual: boolean;
begin
   result:=true;
end;

function TMatList.getCpLine: smallint;
begin
  result:=FcpLine;
end;

procedure TMatList.setCpLine(w: smallint);
begin
  inherited;
  FcpLine:=w;
end;

function TmatList.getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;
var
  complexity:mxComplexity;
  classID:mxClassID;
  t:pointer;
  i,j,k:integer;
  tpDest:typetypeG;
  dims:array[1..3] of integer;
  Nx,Ny,Nframe:integer;
  i1,j1:integer;
  tpMat1: typetypeG;
begin
  result:=nil;
  if not testMatlabMat then exit;
  if not testMatlabMatrix then exit;

  Nframe:=Count;
  if Nframe>0 then
  begin
    Nx:= mat[1].Icount;
    Ny:= mat[1].Jcount;
    i1:= mat[1].Istart;
    j1:= mat[1].Jstart;
    tpMat1:= mat[1].tpNum;
    if (Nx=0) or (Ny=0)
      then  sortieErreur('TmatList : cannot convert matList to matlab structure');

    for i:=2 to count do
    begin
      if (mat[i].Icount<>Nx) or (mat[i].Jcount<>Ny) or (mat[i].Istart<>i1) or (mat[i].Jstart<>j1)
        then sortieErreur('TmatList : cannot convert matList to matlab structure');
      if mat[i].tpNum > tpMat1 then tpMat1:= mat[i].tpNum;
    end;
  end
  else sortieErreur('TmatList : cannot convert matList to matlab structure');

  if tpMat1= g_extended then tpMat1:= g_double
  else
  if tpMat1= g_extComp then tpMat1:= g_doubleComp;

  if tpDest0=G_none
    then tpDest:=tpMat1
    else tpDest:=tpDest0;

  if not (tpDest in MatlabTypes) then
  begin
    sortieErreur('MxArray: invalid type');
    exit;
  end;

  classId:=TpNumToClassId(tpDest);
  complexity:=tpNumToComplexity(tpDest);

  dims[1]:= Ny;
  dims[2]:= Nx;
  dims[3]:= Nframe;

  result:=mxCreateNumericArray(3,@dims,classID,complexity);
  if result=nil then
  begin
    sortieErreur('Tmatlist to MxArray : error 1');
    exit;
  end;

  t:= mxGetPr(result);
  if t=nil then
  begin
    sortieErreur('Tmatlist to MxArray : error 2');
    exit;
  end;

  case tpDest of
    G_byte:         for k:=0 to Nframe-1 do
                    with mat[k+1] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabOctet(t)^[j+Ny*i +Nx*Ny*k ]:=Kvalue[i+i1,j+j1];

    G_short:        for k:=0 to Nframe-1 do
                    with mat[k+1] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabShort(t)^[j+Ny*i +Nx*Ny*k ]:=Kvalue[i+i1,j+j1];

    G_smallint:     for k:=0 to Nframe-1 do
                    with mat[k+1] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabEntier(t)^[j+Ny*i +Nx*Ny*k ]:=Kvalue[i+i1,j+j1];

    G_word:         for k:=0 to Nframe-1 do
                    with mat[k+1] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabWord(t)^[j+Ny*i +Nx*Ny*k ]:= Kvalue[i+i1,j+j1];

    G_longint:      for k:=0 to Nframe-1 do
                    with mat[k+1] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabLong(t)^[j+Ny*i +Nx*Ny*k ]:= Kvalue[i+i1,j+j1];

    G_single,
    G_singleComp:   for k:=0 to Nframe-1 do
                    with mat[k+1] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabSingle(t)^[j+Ny*i +Nx*Ny*k ]:= Zvalue[i+i1,j+j1];
    G_double,
    G_doubleComp,
    G_real,
    G_extended:     for k:=0 to Nframe-1 do
                    with mat[k+1] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabDouble(t)^[j+Ny*i +Nx*Ny*k ]:= Zvalue[i+i1,j+j1];
  end;


  t:= mxGetPi(result);
  if (complexity=mxComplex) and assigned(t) then
  case tpDest of
    G_singleComp:   for k:=0 to Nframe-1 do
                    with mat[k+1] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabSingle(t)^[j+Ny*i +Nx*Ny*k ]:= Imvalue[i+i1,j+j1];
    G_doubleComp,
    G_extended:     for k:=0 to Nframe-1 do
                    with mat[k+1] do
                    for i:=0 to Nx-1 do
                    for j:=0 to Ny-1 do
                      PtabDouble(t)^[j+Ny*i +Nx*Ny*k ]:= Imvalue[i+i1,j+j1];
  end;



end;


procedure TMatList.setMxArray(mxArray: MxArrayPtr;Const invertIndices:boolean=false);
var
  classID:mxClassID;
  isComp:boolean;
  t:pointer;
  tp:typetypeG;
  Ndim,nx,ny,nz:integer;
  pNb:PtabLong1;

  i,j,k:integer;
  mm:Tmatrix;


var
  getV: TUgetV;

begin
  if not assigned(mxArray) then exit;

  classID:=mxGetClassID(mxArray);
  isComp:= mxIsComplex(mxArray);
  tp:=classIDtoTpNum(classID,isComp);

  case classID of
    mxInt8_class:   getV:= UgetShort;
    mxUInt8_class:  getV:= UgetByte;
    mxInt16_class:  getV:= UgetSmallInt;
    mxUInt16_class: getV:= Ugetword;
    mxInt32_class:  getV:= Ugetlong;
    mxUInt32_class: getV:= Ugetlongword;
    mxsingle_class: getV:= UgetSingle;
    mxDouble_class: getV:= UgetDouble;
  end;


  Ndim:=mxgetNumberOfDimensions(mxArray);
  pNb:=mxgetDimensions(mxArray);

  if Ndim<2 then exit;

  nx:=pNb^[1];
  ny:=pNb^[2];
  if Ndim>=3
    then nz:=pNb^[3]
    else nz:=1;

  t:= mxGetPr(mxArray);

  if assigned(t) and (Nx>0) and (Ny>0) and (nz>0) then
  begin
    if InvertIndices then
    begin
      mm:= Tmatrix.create;
      mm.initTemp(1,Nz,1,Ny,tp);
      try
        for i:=0 to Nx-1 do
        begin
          with mm do
          for j:=0 to Ny-1 do
          for k:=0 to Nz-1 do
             Zvalue[1+j,1+k]:=  getV(t,i+Nx*j +Nx*Ny*k);
          AddMatrix(mm);
        end;
      finally
        mm.Free;
      end;
    end
    else
    begin
      mm:= Tmatrix.create;
      mm.initTemp(1,Nx,1,Ny,tp);
      try
        for k:=0 to Nz-1 do
        begin
          with mm do
          for i:=0 to Nx-1 do
          for j:=0 to Ny-1 do
             Zvalue[1+i,1+j]:=  getV(t,i+Nx*j +Nx*Ny*k);
          AddMatrix(mm);
        end;
      finally
        mm.Free;
      end;
    end;
  end;

end;


procedure TmatList.setDx(x:double);
var
  i:integer;
begin
  inherited setDx(x);
  for i:=1 to count do mat[i].Dxu:=x;
end;

procedure TmatList.setX0(x:double);
var
  i:integer;
begin
  inherited setx0(x);
  for i:=1 to count do mat[i].x0u:=x;
end;

procedure TmatList.setDy(x:double);
var
  i:integer;
begin
  inherited setDy(x);
  for i:=1 to count do mat[i].Dyu:=x;
end;

procedure TmatList.setY0(x:double);
var
  i:integer;
begin
  inherited setY0(x);
  for i:=1 to count do mat[i].Y0u:=x;
end;

procedure TmatList.setXmin(x:double);
var
  i:integer;
begin
  inherited setXmin(x);
  for i:=1 to count do mat[i].Xmin:=x;
end;

procedure TmatList.setXmax(x:double);
var
  i:integer;
begin
  inherited setXmax(x);
  for i:=1 to count do mat[i].Xmax:=x;
end;

procedure TmatList.setYmin(x:double);
var
  i:integer;
begin
  inherited setYmin(x);
  for i:=1 to count do mat[i].Ymin:=x;
end;

procedure TmatList.setYmax(x:double);
var
  i:integer;
begin
  inherited setYmax(x);
  for i:=1 to count do mat[i].Ymax:=x;
end;

procedure TmatList.setZmin(x:double);
var
  i:integer;
begin
  inherited setZmin(x);
  for i:=1 to count do mat[i].Zmin:=x;
end;

procedure TmatList.setZmax(x:double);
var
  i:integer;
begin
  inherited setZmax(x);
  for i:=1 to count do mat[i].Zmax:=x;
end;

procedure TMatList.setUnitX(st: AnsiString);
var
  i:integer;
begin
  inherited;
  for i:=1 to count do mat[i].unitX:=st;
end;

procedure TMatList.setUnitY(st: AnsiString);
var
  i:integer;
begin
  inherited;
  for i:=1 to count do mat[i].unitY:=st;
end;

procedure TMatList.Filter1( matF: Tmatrix; vecF: Tvector);
var
  i,j,k,n:integer;
  i0,j0,k0: integer;
  i0F,j0F,k0F: integer;
  Nx,Ny:integer;
  seed: longword;
  res:integer;
  Vdum: Pdouble;
  dim: array[1..3] of integer;
  Hdfti: pointer;
  w:double;
  p0: Double;

begin
  if not canCompact then exit;

  mkltest;
  ippstest;
  Vdum:=nil;

  try

  Nx:=mat[1].Icount;
  Ny:=mat[1].Jcount;

  getmem(Vdum,Nx*Ny*count*sizeof(double)*2);
  fillchar(Vdum^, Nx*Ny*count*sizeof(double)*2, 0);

  k0:=1;
  i0:=mat[1].Istart;
  j0:=mat[1].Jstart;

  // On convertit en complexes
  for i:=0 to Nx-1 do
  for j:=0 to Ny-1 do
  for k:=0 to Count-1 do
  begin
    n:= i + Nx*j +Nx*Ny*k;
    Ptabdouble(Vdum)^[2*n] := mat[k+k0][i+I0,j+j0];
  end;

  // Calculer la DFT inverse de Vdum
  dim[1]:=Nx;
  dim[2]:=Ny;
  dim[3]:=count;

  res:=DftiCreateDescriptor(Hdfti,dfti_Double, dfti_complex ,3, @Dim);
  if res<>0 then exit;

  res:= DftiSetValueI(Hdfti, DFTI_FORWARD_DOMAIN, DFTI_COMPLEX);
  res:=DftiCommitDescriptor(Hdfti);

  res:=DftiComputeForward1(hdfti,Vdum);
  DftiFreeDescriptor(hdfti);


  // multiplier Vdum par le filtre.
  k0F:=vecF.Istart;
  i0F:=matF.Istart;
  j0F:=matF.Jstart;

  for i:=0 to Nx-1 do
  for j:=0 to Ny-1 do
  for k:=0 to Count-1 do
  begin
    p0:= MatF[i+i0F,j+j0F]*vecF[k+k0F];
    n:= i + Nx*j +Nx*Ny*k;
    Ptabdouble(Vdum)^[2*n]:=   Ptabdouble(Vdum)^[2*n]  * p0;
    Ptabdouble(Vdum)^[2*n+1]:= Ptabdouble(Vdum)^[2*n+1]* p0;
  end;

  res:=DftiCreateDescriptor(Hdfti,dfti_double, dfti_complex ,3, @Dim);
  if res<>0 then exit;

  res:= DftiSetValueI(Hdfti, DFTI_FORWARD_DOMAIN, DFTI_COMPLEX);

  w:=  1/( Nx*Ny*count);
  res:=DftiSetValueS(hdfti,DFTI_BACKWARD_SCALE,w);

  res:=DftiCommitDescriptor(Hdfti);

  res:=DftiComputeBackward1(hdfti,Vdum);
  DftiFreeDescriptor(hdfti);


  for i:=0 to Nx-1 do
  for j:=0 to Ny-1 do
  for k:=0 to Count-1 do
  begin
    n:= i + Nx*j +Nx*Ny*k;
    mat[k+k0][i+I0,j+j0]:= Ptabdouble(Vdum)^[2*n];
  end;

  finally
  freemem(Vdum);
  mklend;
  ippsend;
  end;
end;



                      { Méthodes STM }



procedure proTmatList_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,Tmatlist);
end;

procedure proTmatList_create_1(var pu:typeUO);
begin
  proTmatList_create('', pu);
end;

procedure proTmatList_AddMatrix(var vec:TMatrix;var pu:typeUO);
begin
  verifierObjet(typeUO(vec));
  verifierObjet(pu);

  Tmatlist(pu).addMatrix(vec);
end;

procedure proTmatList_InsertMatrix(n:integer;var vec:TMatrix;var pu:typeUO);
begin
  verifierObjet(typeUO(vec));
  verifierObjet(pu);

  Tmatlist(pu).insertMatrix(n,vec);
end;


procedure proTmatList_DeleteMatrix(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  Tmatlist(pu).deleteMatrix(num);
end;

procedure proTmatList_Clear(var pu:typeUO);
begin
  verifierObjet(pu);

  Tmatlist(pu).clear;
end;

function fonctionTmatlist_M(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tmatlist(pu) do
  begin
    ControleParam(i,1,count,'TmatList.M : index out of range');
    result:=@Mat[i].myAd;
  end;
end;



function fonctionTmatList_count(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmatList(pu) do result:=count;
end;

procedure proTmatList_Index(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with TmatList(pu) do
  begin
    controleParam(n,1,count,'TmatList.Index : index out of range');
    setFirstLine(n);
  end;
end;

function fonctionTmatList_Index(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmatList(pu) do result:=ligne1;
end;



procedure proTmatList_Selected(n:integer;x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  with TmatList(pu) do
  begin
    controleParam(n,1,count,'TmatList.Selected : index out of range');
    selected[n]:=x;
  end;
end;

function fonctionTmatList_Selected(n:integer;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TmatList(pu) do
  begin
    controleParam(n,1,count,'TmatList.Selected : index out of range');
    result:=selected[n];
  end;
end;

procedure proTmatList_OnSelect(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmatList(pu).onSelect do setAd(p);
end;

function fonctionTmatList_OnSelect(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TmatList(pu).OnSelect.ad;
end;


procedure proTmatList_CpLine(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).CpLine:=p;
end;

function fonctionTmatList_CpLine(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TmatList(pu).CpLine;
end;


function fonctionTmatList_Zmin(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TmatList(pu).Zmin;
end;

procedure proTmatList_Zmin(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).Zmin:=x;
end;

function fonctionTmatList_Zmax(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TmatList(pu).Zmax;
end;

procedure proTmatList_Zmax(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).Zmax:=x;
end;


function fonctionTmatList_theta(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TmatList(pu).theta;
end;

procedure proTmatList_theta(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).theta:=x;
end;


function fonctionTmatList_CpxMode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TmatList(pu).CpxMode;
end;

procedure proTmatList_CpxMode(x: integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).CpxMode:=x;
end;

function fonctionTmatList_AspectRatio(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TmatList(pu).AspectRatio;
end;

procedure proTmatList_AspectRatio(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).AspectRatio:=x;
end;

function fonctionTmatList_PixelRatio(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TmatList(pu).PixelRatio;
end;

procedure proTmatList_PixelRatio(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).PixelRatio:=x;
end;


function fonctionTmatList_gamma(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TmatList(pu).gamma;
end;

procedure proTmatList_gamma(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).gamma:=x;
end;

function fonctionTmatList_TwoColors(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TmatList(pu).TwoCol;
end;

procedure proTmatList_TwoColors(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).TwoCol:=x;
end;

function fonctionTmatList_PalColor(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  controleParametre(n,1,2);
  result:=TmatList(pu).PalColor[n];
end;

procedure proTmatList_PalColor(n:integer;x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(n,1,2);
  TmatList(pu).PalColor[n]:=  x;
end;

procedure proTmatList_DisplayMode(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).DisplayMode:=x;
end;

function fonctionTmatList_DisplayMode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TmatList(pu).DisplayMode;
end;

procedure proTmatList_PalName(x:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).PalName:=x;
end;

function fonctionTmatList_PalName(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TmatList(pu).PalName;
end;

procedure proTmatList_getMinMaxI(var Vmin,Vmax:longint;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).getMinMaxI(Vmin,Vmax);
end;

procedure proTmatList_getMinMax(var Vmin,Vmax:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).getMinMax(Vmin,Vmax);
end;

procedure proTMatList_AutoscaleZ(var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).autoscaleZ;
end;

procedure proTMatList_AutoscaleZsym(var pu:typeUO);
begin
  verifierObjet(pu);
  TmatList(pu).autoscaleZsym;
end;

procedure ProTMatList_SaveToVectorArray(var va:TvectorArray;tpN:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(va));

  TmatList(pu).saveToVectorArray(va,typetypeG(tpN));
end;



procedure proTmatlist_onControl(b:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    pu.onControl:=b;
  end;

function fonctionTmatlist_onControl(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    result:=pu.onControl;
  end;

procedure proTmatlist_setPosition(x,y,dx,dy,theta1:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatlist(pu) do
  begin
    degP.x:=x;
    degP.y:=y;
    degP.dx:=dx;
    degP.dy:=dy;
    degP.theta:=theta1;
    degP.Fuse:=true;
  end;
end;

procedure proTmatlist_AutoscaleXYZ(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmatlist(pu) do
  begin
    autoscaleX;
    autoscaleY;
    autoScaleZ;
    if (cpx<>0) then messageCpx;
    if (cpy<>0) then messageCpy;
    if (cpy<>0) then messageCpz;
  end;
end;

procedure proTmatlist_UsePosition(b:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  Tmatlist(pu).degP.Fuse:=b;
end;

function fonctionTmatlist_UsePosition(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:= Tmatlist(pu).degP.Fuse;
end;

procedure proTMatList_Filter1( var matF: Tmatrix; var vecF: Tvector; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(matF);
  verifierVecteur(vecF);

  with Tmatlist(pu) do
  begin
    if not canCompact then sortieErreur('Tmatlist.Filter1 : data cannot be filtered');
    if vecF.Icount<>count then sortieErreur('Tmatlist.Filter1 : vecF has a bad number of values');

    if (matF.Icount<> mat[1].Icount) or (matF.Jcount<> mat[1].Jcount)  then sortieErreur('Tmatlist.Filter1 : matF has a bad dimension');

    Filter1(matF,vecF);
  end;


end;




Initialization
AffDebug('Initialization stmMlist',0);

registerObject(Tmatlist,data);



end.

