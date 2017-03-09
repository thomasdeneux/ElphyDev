unit stmDobj1;


INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses windows,sysUtils,
     classes,graphics,forms,controls,

     util1,Gdos,DdosFich,Dgraphic,Dgrad1,dtf0,Dtrace1,
     Dpalette,Ncdef2,formMenu,

     cood0,
     stmDef,stmObj,
     stmPlot1, stmDPlot,
     visu0,
     varconf1,
     debug0,

     tpVector,
     objFile1,stmError,stmPg,binFile1,
     ipps,ippsovr,
     matlab_matrix,
     matlab_Mat,

     MemManager1,
     heap0;


{ A partir de TDataplot, on construit TdataObj en ajoutant le bloc Inf

  TdataObj est le type de base pour tous les objets data: Tvector, Tpsth,
  Tmatrix, etc...

}



type
{ TInfoDataObj regroupe toutes les infos de définition d'un objet data.
  En pratique, il sert surtout à la sauvegarde

  16-9-99: On modifie les structures de base. On sort visu de TInfoDataObj, ce
  qui pose problème pour les anciennes configurations.

  On sort aussi temp et readOnly de TInfoDataObj.
}

  ToldInfoDataObj=
               record
                 tpNum:typeTypeG;
                 imin,imax,jmin,jmax:longint;
                 x0u,dxu,y0u,dyu,z0u,dzu:double;

                 visu:TOldVisuInfo;    { info visu  éjectées}

                 temp:boolean;
                 readOnly:boolean;
               end;


  TInfoDataObj=
                object
                 tpNum:typeTypeG;             {ces données font double emploi  }
                 imin,imax,jmin,jmax:longint; {avec le contenu des objets data }
                 x0u,dxu,y0u,dyu,z0u,dzu:double;{en écriture, on doit modifier }
                                    { à la fois ces valeurs et les objets data }

                 temp:boolean;      { temp=true signifie que les données appartiennent à l'objet
                                      Pour les vecteurs et matrices,cela signifie que tbTemp
                                      est alloué mais pour TbitmapPlot et TOIseq, temp vaut toujours true
                                      et tbTemp=nil.
                                    }

                 readOnly:boolean;  {un objet associé à un fichier de données
                                     est par défaut protégé en écriture: readonly=true }

                 procedure controle;
                 function dataSize:integer;
                 function info:AnsiString;
                 procedure Defaults;
                end;

  TdataObjFlags=record
                  FmaxIndex:boolean;  {si vrai, l'indice max peut être modifié }
                  Findex:boolean;     {si vrai, Imin et Imax peuvent être modifiés }
                  Ftype:boolean;      {si vrai, le type peut être modifié}
                end;
                {Actuellement, FmaxIndex est vrai uniquement pour les vecteurs de RealArray}

  TmodifyMaxIndex=function (uo:typeUO;var w:integer):boolean of object;


  TDataObj= class(TdataPlot)
             protected
                 tbTemp:pointer;
                 FAlign32Bytes:boolean;
                 TempSize:integer;
                 MemHandle: PmemRec;

                 FtotSize: int64;  // taille du buffer pointé par tbTemp
                                   // ne peut être modifié que par les méthodes du type initTemp
                                   // la limite théorique est 2 GB en 32 bits et 4 GB en 64 bits

                 function AllocMemory(size:int64): boolean;
                 procedure FreeMemory;
                 function ReallocMemory(oldSize,size:int64;Fzero:boolean): boolean;
                 procedure MemManagerEvent;virtual;

                 procedure setDx(x:double);  virtual;
                 procedure setX0(x:double);  virtual;

                 procedure setDy(x:double);  virtual;
                 procedure setY0(x:double);  virtual;

                 procedure setDz(x:double);  virtual;
                 procedure setZ0(x:double);  virtual;

                 procedure setIstart(w:integer);override;
                 procedure setIend(w:integer);override;
                 procedure setJstart(w:integer);override;
                 procedure setJend(w:integer);override;


                 procedure ExtendTemp(TotalSize: int64);

            public
                 oldInf:^ToldinfoDataObj; {sert pour loadInfo}
                 inf:TinfoDataObj;
                 Flags:TdataObjFlags;

                 Fexpand:boolean;
                 FimDisplay:boolean;

                 property totSize:int64 read FtotSize;

                 function tb:pointer;virtual;
                 function tbD:Pdouble;   {  =tb simplifie l'écriture pour IPPS }
                 function tbS:Psingle;   {  =tb id }
                 function tbSC:PsingleComp;   {  =tb id }
                 function tbDC:PdoubleComp;   {  =tb id }

                 function getReadOnly:boolean;override;
                 procedure setReadOnly(v:boolean);override;


                 property Dxu:double read inf.Dxu write setDx;
                 property X0u:double read inf.X0u write setX0;

                 property Dyu:double read inf.Dyu write setDy;
                 property Y0u:double read inf.Y0u write setY0;

                 property Dzu:double read inf.Dzu write setDz;
                 property Z0u:double read inf.Z0u write setZ0;

                 property tpNum:typetypeG read inf.tpNum;

                 constructor create;override;
                 destructor destroy;override;

                 procedure initTemp0(tnombre:typeTypeG;totalSize:int64;Fzero:boolean);
                 procedure freeTemp0;

                 procedure MemoryErrorMessage(Const st: string='');
                 procedure clear;override;

                 function convx(i:longint):float;
                 function invconvx(x:float):longint;
                 function convy(i:longint):float;
                 function invconvy(x:float):longint;
                 function convz(i:longint):float;
                 function invconvz(x:float):longint;

                 function convxR(i:float):float;
                 function invconvxR(x:float):float;
                 function convyR(i:float):float;
                 function invconvyR(x:float):float;
                 function convzR(i:float):float;
                 function invconvzR(x:float):float;

                 function Xstart:float;  override;
                 function Xend:float;    override;
                 function getIstart:integer;override;
                 function getIend:integer;  override;

                 function Ystart:float;  override;
                 function Yend:float;    override;
                 function getJstart:longint;override;
                 function getJend:longint;  override;


                 procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
                   override;
                 procedure completeLoadInfo;override;

                 procedure copyDataFrom(p:typeUO);override;

                 procedure DoImDisplay;virtual;

                 function isComplex:boolean;
                 function isModified:boolean;override;

                 class Function SupportType(tp:typetypeG):boolean;virtual;
                 class Function reverseTemp:boolean;virtual;
                 Function ManagedMem: boolean;virtual;

                 procedure GdispToWorld(Gdisp,xdisp,ydisp:float);override;
                 procedure WorldToGdisp(var Gdisp,xdisp,ydisp:float);override;

                 procedure setGdisp(GI,xI,yI:float);virtual;
                 procedure getGdisp(var GI,xI,yI:float);virtual;

                 procedure setAspectRatio(w:single);override;
                 function getAspectRatio:single;override;

              end;

function TpNumToClassId(tpNum:typetypeG):mxClassId;
function TpNumToComplexity(tpNum:typetypeG):mxComplexity;
function ClassIdToTpNum(classId:mxClassId;Iscomplex:boolean):typetypeG;

{***************** Déclarations STM pour TdataObj ****************************}

procedure proTdataObject_clear(var pu:typeUO);pascal;

procedure proTdataObject_Dx(x:float;var pu:typeUO);pascal;
function fonctionTdataObject_Dx(var pu:typeUO):float;pascal;
procedure proTdataObject_x0(x:float;var pu:typeUO);pascal;
function fonctionTdataObject_x0(var pu:typeUO):float;pascal;
procedure proTdataObject_Dy(x:float;var pu:typeUO);pascal;
function fonctionTdataObject_Dy(var pu:typeUO):float;pascal;
procedure proTdataObject_y0(x:float;var pu:typeUO);pascal;
function fonctionTdataObject_y0(var pu:typeUO):float;pascal;

procedure proTdataObject_FreadOnly(w:boolean;var pu:typeUO);pascal;
function fonctionTdataObject_FreadOnly(var pu:typeUO):boolean;pascal;

procedure proTdataObject_Fexpand(w:boolean;var pu:typeUO);pascal;
function fonctionTdataObject_Fexpand(var pu:typeUO):boolean;pascal;

procedure proTdataObject_FimDisplay(w:boolean;var pu:typeUO);pascal;
function fonctionTdataObject_FimDisplay(var pu:typeUO):boolean;pascal;


function FonctionTdataObject_convX(i:longint;var pu:typeUO):float;pascal;
function FonctionTdataObject_invconvX(x:float;var pu:typeUO):longint;pascal;
function FonctionTdataObject_convY(i:longint;var pu:typeUO):float;pascal;
function FonctionTdataObject_invconvY(x:float;var pu:typeUO):longint;pascal;
function FonctionTdataObject_Xstart(var pu:typeUO):float;pascal;
function FonctionTdataObject_Xend(var pu:typeUO):float;pascal;

function FonctionTdataObject_Istart(var pu:typeUO):longint;pascal;
procedure proTdataObject_Istart(n:integer;var pu:typeUO);pascal;

function FonctionTdataObject_Iend(var pu:typeUO):longint;pascal;
procedure proTdataObject_Iend(n:integer;var pu:typeUO);pascal;

function FonctionTdataObject_Icount(var pu:typeUO):longint;pascal;
procedure proTdataObject_Icount(n:integer;var pu:typeUO);pascal;

function fonctionTdataObject_NumType(var pu:typeUO):smallint;pascal;


procedure proReAfficherTrace(var pu:typeUO);pascal;
procedure proReafficher(var pu:typeUO);pascal;
procedure proModifierAffichage(modifGrad:boolean);pascal;


IMPLEMENTATION

uses ProcFile;

{****************** Méthodes de TinfoDataObj *****************************}
(*
                 tpNum:typeTypeG;             {ces données font double emploi  }
                 imin,imax,jmin,jmax:longint; {avec le contenu des objets data }
                 x0u,dxu,y0u,dyu,z0u,dzu:double;{en écriture, on doit modifier }
                                    { à la fois ces valeurs et les objets data }
                 temp:boolean;      { temp=true lorsque le tableau ou le fichier
                 temporaire a été alloué par initTemp0. Pratiquement, temp est true
                 pour les vecteurs indépendants (mémoires) et false pour les
                 vecteurs associés à une autre structure (TdataFile ou TrealArray)
                 }

                 readOnly:boolean;  {un objet associé à un fichier de données
                 est par défaut protégé en écriture: readonly=true }
*)
procedure TInfoDataObj.controle;
const
  epsilon=1E-20;
begin
  if (tpNum<low(typetypeG)) or (tpNum>high(typetypeG)) then
    begin
      tpNum:=G_smallint;
    end;

  if abs(Dxu)<Epsilon then
    begin
      Dxu:=1;
      x0u:=0;
    end;

  if abs(Dyu)<Epsilon then
    begin
      Dyu:=1;
      y0u:=0;
    end;

  if abs(Dyu)<Epsilon then
    begin
      Dzu:=1;
      z0u:=0;
    end;

  if Imax<Imin-1 then Imax:=Imin-1;
end;

function TInfoDataObj.dataSize:integer;
begin
  result:=tailleTypeG[tpNum]*(Imax-Imin+1)*(Jmax-Jmin+1);
end;

function TInfoDataObj.info:AnsiString;
begin
  result:='NumType= '+TypeNameG[tpNum]+crlf+
          'Istart= ' +Istr(imin)+crlf+
          'Iend= '+Istr(imax)+crlf+
          'Dx= '+ Estr(dxu,6)+crlf+
          'x0= '+ Estr(x0u,6)+crlf+
          'Dy= '+ Estr(dyu,6)+crlf+
          'y0= '+ Estr(y0u,6)+crlf+
          'Temp= '+ Bstr(temp)+crlf+
          'ReadOnly= '+Bstr(readOnly);
end;

procedure TInfoDataObj.Defaults;
begin
  Imax:=99;
  jmax:=99;

  dxu:=1;
  dyu:=1;

  tpNum:=G_smallint;
  temp:=true;

  dxu:=1;
  dyu:=1;
  dzu:=1;
end;

{****************** Méthodes de TDataObj *****************************}

var
  infModel:TinfoDataObj;

constructor TDataObj.create;
begin
  ippsTest;
  
  inherited create;

  inf.Defaults;

  with flags do
  begin
    FmaxIndex:=false;
    Findex:=true;
    Ftype:=true;
  end;
end;

destructor TDataObj.destroy;
  begin
    if inf.temp and (tb<>nil) then freeMemory;
    inherited destroy;
  end;

function TDataObj.tb:pointer;
begin
  if assigned(MemHandle)
    then result:=MemHandle^.p
    else result:=tbTemp;
end;

function TDataObj.tbD:Pdouble;   {  =tb simplifie l'écriture pour IPPS }
begin
  result:=tb;
end;

function TDataObj.tbS:Psingle;   {  =tb id }
begin
  result:=tb;
end;

function TDataObj.tbSC:PsingleComp; {  =tb id }
begin
  result:=tb;
end;

function TDataObj.tbDC:PdoubleComp; {  =tb id }
begin
  result:=tb;
end;

procedure TDataObj.MemManagerEvent;
begin

end;

procedure TDataObj.MemoryErrorMessage(Const st:string='');
var
  st1:string;
begin
  if st<>'' then st1:=crlf+st else st1:='';
  if ExeON then sortieErreur('Memory error'+st1)
  else  messageCentral('Unable to allocate memory for '+ident+st1);
end;

procedure TDataObj.initTemp0(tnombre:typeTypeG;TotalSize:int64;Fzero:boolean);
begin
  if inf.temp then freeMemory;

  FtotSize:=totalSize;

  if AllocMemory(TotalSize) then
  begin
    if Fzero and (totalSize<>0) then
      if ippsZero(Pointer(tb),totalSize)<>0 then {messageCentral('ICI')};
  end
  else MemoryErrorMessage('Unable to allocate sz='+Istr(totalSize)+' for '+ident);

  inf.temp:=true;
  inf.tpNum:=tnombre;
end;

procedure TdataObj.freeTemp0;
begin
  freeMemory;
  tbTemp:=nil;
  inf.temp:=false;
  FtotSize:=0;
end;

function TDataObj.getReadOnly: boolean;
begin
  result:=inf.readOnly;
end;

procedure TDataObj.setReadOnly(v: boolean);
begin
  inf.readOnly:=v;
end;


procedure TDataObj.ExtendTemp(TotalSize: int64);
begin
  if not inf.temp or (totalSize<=totSize) then exit;

  if ReallocMemory(totSize,totalSize,true) then FtotSize:=TotalSize
  else MemoryErrorMessage('ExtendTemp in '+ident);
end;


procedure TdataObj.clear;
  begin
  end;


function TdataObj.convx(i:longint):float;
begin
  convx:=inf.dxu*i+inf.x0u;
end;

function TdataObj.invconvx(x:float):longint;
begin
  invconvx:=roundL((x-inf.x0u)/inf.dxu);
end;

function TdataObj.convy(i:longint):float;
begin
  convy:=inf.dyu*i+inf.y0u;
end;

function TdataObj.invconvy(x:float):longint;
begin
  invconvy:=roundL((x-inf.y0u)/inf.dyu);
end;

function TdataObj.convz(i:longint):float;
begin
  convz:=inf.dzu*i+inf.z0u
end;

function TdataObj.invconvz(x:float):longint;
begin
  invconvZ:=roundL((x-inf.z0u)/inf.dzu);
end;


function TdataObj.convxR(i:float):float;
begin
  result:=inf.dxu*i+inf.x0u;
end;

function TdataObj.invconvxR(x:float):float;
begin
  result:=(x-inf.x0u)/inf.dxu;
end;

function TdataObj.convyR(i:float):float;
begin
  result:=inf.dyu*i+inf.y0u;
end;

function TdataObj.invconvyR(x:float):float;
begin
  result:=(x-inf.y0u)/inf.dyu;
end;

function TdataObj.convzR(i:float):float;
begin
  result:=inf.dzu*i+inf.z0u
end;

function TdataObj.invconvzR(x:float):float;
begin
  result:=(x-inf.z0u)/inf.dzu;
end;



procedure TDataObj.setDx(x:double);
  begin
    inf.Dxu:=x;
    ModifiedData:=true;
  end;

procedure TDataObj.setX0(x:double);
  begin
    inf.X0u:=x;
    ModifiedData:=true;
  end;

procedure TDataObj.setDy(x:double);
  begin
    inf.Dyu:=x;
    ModifiedData:=true;
  end;

procedure TDataObj.setY0(x:double);
  begin
    inf.Y0u:=x;
    ModifiedData:=true;
  end;

procedure TDataObj.setDz(x:double);
  begin
    inf.Dzu:=x;
    ModifiedData:=true;
  end;

procedure TDataObj.setZ0(x:double);
  begin
    inf.Z0u:=x;
    ModifiedData:=true;
  end;

function TDataObj.Xstart:float;
  begin
    Xstart:=convX(inf.Imin);
  end;

function TDataObj.Xend:float;
  begin
    Xend:=convX(inf.Imax);
  end;

function TDataObj.getIstart:integer;
begin
  result:=inf.Imin;
end;

function TDataObj.getIend:integer;
begin
  result:=inf.Imax;
end;

function TDataObj.Ystart:float;
begin
  result:=convY(inf.Jmin);
end;

function TDataObj.Yend:float;
begin
  result:=convY(inf.Jmax);
end;

function TDataObj.getJstart:longint;
begin
  result:=inf.Jmin;
end;

function TDataObj.getJend:longint;
begin
  result:=inf.Jmax;
end;


procedure TDataObj.setIend(w: integer);
begin
  inf.imax:=w;
end;

procedure TDataObj.setIstart(w: integer);
begin
  inf.imin:=w;
end;

procedure TDataObj.setJend(w: integer);
begin
  inf.jmax:=w;
end;

procedure TDataObj.setJstart(w: integer);
begin
  inf.jmin:=w;
end;

procedure TdataObj.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);

  if lecture then
    begin
      new(oldInf);
      fillChar(oldInf^,sizeof(oldInf^),0);
    end;

  with conf do
  begin
    if lecture then setvarconf('INF',oldinf^,sizeof(oldinf^));
    setvarconf('OBJINF',inf,sizeof(inf));
    setvarconf('TotSize',FtotSize ,sizeof(FtotSize));
  end;
end;

procedure TdataObj.completeLoadInfo;
begin
  inherited completeLoadInfo;

  if (oldInf^.imin<>0) or (oldInf^.imax<>0) then
    with inf do
    begin
      tpNum:=oldInf^.tpNum;
      imin:=oldInf^.imin;
      imax:=oldInf^.imax;
      jmin:=oldInf^.jmin;
      jmax:=oldInf^.jmax;
      x0u:=oldInf^.x0u;
      dxu:=oldInf^.dxu;
      y0u:=oldInf^.y0u;
      dyu:=oldInf^.dyu;
      z0u:=oldInf^.z0u;
      dzu:=oldInf^.dzu;

      temp:=oldInf^.temp;
      readOnly:=oldInf^.readOnly;

      visu.transferOldVisu(oldInf^.visu);
    end;

    dispose(oldInf);
    oldInf:=nil;
end;

procedure TdataObj.copyDataFrom(p:typeUO);
var
  i:integer;
begin
  if not (p is TdataObj) then exit;

  if TdataObj(p).inf.temp and inf.temp and  (TdataObj(p).totSize= totSize) then
    move(TdataObj(p).tb^,tb^,totSize);
end;


class function TDataObj.reverseTemp: boolean;
begin
  result:=false;
end;



procedure TDataObj.DoImDisplay;
begin

end;

function TDataObj.isComplex: boolean;
begin
  result:= (tpNum>=g_singleComp) and (tpNum<=g_ExtComp);
end;

function TDataObj.isModified: boolean;
begin
  result:={not compareMem(@inf,@infModel,sizeof(inf)) or} inherited isModified;
end;

class function TDataObj.SupportType(tp: typetypeG): boolean;
begin
  result:=false;
end;

function TDataObj.ManagedMem: boolean;
begin
  result:=false;
end;


function TDataObj.AllocMemory(size: int64): boolean;
var
  p:pointer;
begin
  tbTemp:=nil;
  memHandle:=nil;

  if (size=0) then
  begin
    result:=true;
    exit;
  end;

  if size>=Maxmem then
  begin
    result:=false;
    exit;
  end;

  if Falign32Bytes then
  begin
    tbTemp:=IppsMalloc(Size);   { Falign32Bytes n'est utilisé que par Toptimizer }
    result:= (tbTemp<>nil);
    if not result then
    begin
      result:= getMemG(p,Size);
      tbTemp:=p;
      if result then Falign32Bytes:=false;
    end
  end
  else
  if ManagedMem then
  begin
    MemHandle:=memManager.AllocBlock(size);
    if assigned(MemHandle) then
    begin
      tbTemp:= MemHandle^.p;
      MemHandle^.pf:=MemManagerEvent;
      result:=true;
    end
    else
    begin
      result := getMemG(p,Size);
      tbTemp:=p;
    end;
  end
  else
  begin
    result:= getMemG(p,Size);
    tbTemp:=p;
  end
end;

procedure TDataObj.FreeMemory;
begin
  if Falign32Bytes  then
  begin
    if tbTemp<>nil then ippsFree(tbTemp)
  end
  else
  if assigned(MemHandle) then MemManager.freeBlock(MemHandle)
  else freemem(tbTemp);
  tbTemp:=nil;
  MemHandle:=nil;
end;

function TDataObj.ReallocMemory(oldSize,size: int64;Fzero:boolean): boolean;
var
  p1:pointer;

begin
  if size>=Maxmem then
  begin
    result:=false;
    exit;
  end;


  if Falign32Bytes then
  begin
    p1:=tbTemp;

    if size=0 then                    // size=0 , on libère tbtemp
    begin
      ippsFree(p1);
      tbTemp:=nil;
      exit;
      result:=true;
    end
    else
    if oldSize=0 then                // size>0 et oldsize=0, on alloue directement tbtemp
    begin
      tbTemp:=IppsMalloc(Size);
      result:=(tbTemp<>nil);
      if result and Fzero
        then ippsZero(Pointer(tb),Size);
    end
    else
    if size=oldsize then
    begin
      result:=true;
      exit;
    end
    else
    begin                           // size>0 et oldsize>0, on alloue un nouveau bloc et on copie les data
      tbTemp:=IppsMalloc(Size);

      if (tbTemp<>nil) then
      begin
        if size>=oldSize
          then move(p1^,tbTemp^,OldSize)
          else move(p1^,tbTemp^,Size);

        if Fzero and (Size>Oldsize)
          then ippsZero(pointer(@PtabOctet(tb)^[Oldsize]),Size-Oldsize);
        result:=true;
      end
      else
      begin
        result:= ReallocmemG(tbTemp,size);
        if result then
        begin
          if Fzero and (Size>Oldsize) then ippsZero(Ppointer(@PtabOctet(tb)^[Oldsize]),Size-Oldsize);
          Falign32Bytes:= false;
        end;
      end;
      ippsFree(p1);
    end
  end
  else
  if assigned(MemHandle) then
    result:= MemManager.ReallocBlock(MemHandle,size,Fzero)
  else
  begin
    result:= ReallocmemG(tbTemp,size);
    if result and Fzero and (Size>Oldsize)
      then ippsZero(Ppointer(@PtabOctet(tb)^[Oldsize]),Size-Oldsize);
  end;
end;


procedure TDataObj.getGdisp(var GI, xI, yI: float);
begin
end;

procedure TDataObj.setGdisp(GI, xI, yI: float);
begin
  Gdisp:=GI;
  Xdisp:=xI;
  Ydisp:=yI;
  GdispToWorld(GI,xI,yI);
end;

function TDataObj.getAspectRatio: single;
begin
  if (Dxu<>0) and (Icount<>0)
    then result:=Dyu/Dxu*Jcount/Icount
    else result:=1;
end;

procedure TDataObj.setAspectRatio(w: single);
begin
  if Jcount<>0 then Dyu:=w*Dxu*Icount/Jcount;
end;



{ GdispToWorld se base sur la fenêtre courante
  on calcule Xmin, Xmax,Ymin,Ymax à partir de Gdisp,xdisp,ydisp
  Ceci n'est qu'approximatif car le vrai affichage va recalculer la fenêtre
  d'affichage pour tenir compte du rapport d'aspect et des arrondis.

}

procedure TdataObj.GdispToWorld(Gdisp,xdisp,ydisp:float);
var
  h,w: float;             {dimensions de la fenêtre en pixels }
  Dimx,DimY:float;        {dimensions de l'objet en coordonnées réelles}
  Gm:float;               {facteur de gain optimal: quand l'objet utilise au mieux la fenêtre }
  Gtot:float;
  x00,y00:float;

  i1,i2,j1,j2:integer;    {fenêtre d'affichage}
  x1,x2,y1,y2: float;

begin
  if Xstart<Xend then
  begin
    x1:=convx(Istart);
    x2:=convx(Iend+1);
  end
  else
  begin
    x1:=convx(Iend);
    x2:=convx(Istart-1);
  end;

  if Ystart<Yend then
  begin
    y1:=convy(Jstart);
    y2:=convy(Jend+1);
  end
  else
  begin
    y1:=convy(Jend);
    y2:=convy(Jstart-1);
  end;

  DimX:=abs(Icount*Dxu);
  Dimy:=abs(Jcount*Dyu);

  if (dimX=0) or (dimY=0) then exit;

  x00:=(x1+x2)/2+xDisp;
  y00:=(y1+y2)/2+yDisp;

  getWindowG(i1,j1,i2,j2);
  w:=i2-i1;
  h:=j2-j1;


  if Dimy/Dimx>h/w
    then Gm:=H/DimY
    else Gm:=W/DimX;

  Gtot:=GDisp*Gm;
  if Gtot<0.0001 then Gtot:=0.0001;

  {
  xmin:=convx(invconvx(x00- W/2/Gtot));
  xmax:=convx(invconvx(x00+ W/2/Gtot));

  ymin:=convy(invconvy(y00- H/2/Gtot));
  ymax:=convy(invconvy(y00+ H/2/Gtot));
  }
  xmin:=x00- W/2/Gtot;
  xmax:=x00+ W/2/Gtot;

  ymin:=y00- H/2/Gtot;
  ymax:=y00+ H/2/Gtot;
end;


procedure TdataObj.WorldToGdisp(var Gdisp,xdisp,ydisp:float);
var
  h,w: float;             {dimensions de la fenêtre en pixels }
  Dimx,DimY:float;        {dimensions de l'objets en pixels }
  Gm:float;               {facteur de gain optimal: quand l'objet utilise au mieux la fenêtre }
  Gtot:float;             {facteur de gain total actuel}

  i1,i2,j1,j2:integer;    {fenêtre d'affichage}
  Xend1,Yend1:float;

begin
  Xend1:=convx(Iend+1);
  Yend1:=convy(Jend+1);

  DimX:=abs(Xend1-Xstart);
  Dimy:=abs(Yend1-Ystart);

  getWindowG(i1,j1,i2,j2);
  w:=i2-i1;
  h:=j2-j1;

  if Dimy/Dimx>h/w
    then Gm:=H/DimY
    else Gm:=W/DimX;


  Gtot:=w/(Xmax-Xmin);
  Gdisp:=Gtot/Gm;
  Xdisp:=Xmin+W/2/Gtot-(Xstart+Xend1)/2;
  Ydisp:=Ymin+H/2/Gtot-(Ystart+Yend1)/2;
end;


function TpNumToClassId(tpNum:typetypeG):mxClassId;
begin
  case tpNum of
    G_byte:                  result:=mxUINT8_CLASS;
    G_short:                 result:=mxINT8_CLASS;
    G_smallint:              result:=mxINT16_CLASS;
    G_word:                  result:=mxUINT16_CLASS;
    G_longint:               result:=mxINT32_CLASS;
    G_single,G_singleComp:   result:=mxSingle_CLASS;

    G_double,G_doubleComp,
    G_real,G_extended:       result:=mxDouble_CLASS;
    else                     result:=mxUNKNOWN_CLASS;
  end;
end;

function ClassIdToTpNum(classId:mxClassId;Iscomplex:boolean):typetypeG;
begin
  case classID of
    mxUINT8_CLASS:           if not isComplex
                                then result:=G_byte
                                else result:=G_singleComp;
    mxINT8_CLASS:            if not isComplex
                                then result:= G_short
                                else result:=G_singleComp;
    mxINT16_CLASS:           if not isComplex
                                then result:=G_smallint
                                else result:=G_singleComp;
    mxUINT16_CLASS:          if not isComplex
                                then result:=G_word
                                else result:=G_singleComp;
    mxINT32_CLASS:           if not isComplex
                                then result:=G_longint
                                else result:=G_singleComp;
    mxUINT32_CLASS:          if not isComplex
                                then result:=G_longint
                                else result:=G_singleComp;
    mxSingle_CLASS:          if not isComplex
                                then result:=G_single
                                else result:=G_singleComp;
    mxDouble_CLASS:          if not isComplex
                                then result:= G_double
                                else result:=G_doubleComp;
    else                     result:=g_none;
  end;
end;


function TpNumToComplexity(tpNum:typetypeG):mxComplexity;
begin
  if (tpNum>=G_singleComp)
    then result:=mxComplex
    else result:=mxReal;
end;



{***************** Méthodes STM pour TdataObject ****************************}


procedure proTdataObject_clear(var pu:typeUO);
  begin
    verifierObjet(pu);
    TdataObj(pu).clear;
  end;


procedure proTdataObject_Dx(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    if x=0 then sortieErreur(E_parametre);
    TdataObj(pu).setDx(x);
  end;

function fonctionTdataObject_Dx(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTdataObject_Dx:=TdataObj(pu).Dxu;
  end;

procedure proTdataObject_x0(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TdataObj(pu).setX0(x);
  end;

function fonctionTdataObject_x0(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTdataObject_x0:=TdataObj(pu).X0u;
  end;

procedure proTdataObject_Dy(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    if x=0 then sortieErreur(E_parametre);
    TdataObj(pu).setDy(x);
  end;

function fonctionTdataObject_Dy(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTdataObject_Dy:=TdataObj(pu).Dyu;
  end;

procedure proTdataObject_y0(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TdataObj(pu).setY0(x);
  end;

function fonctionTdataObject_y0(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTdataObject_y0:=TdataObj(pu).Y0u;
  end;

procedure proTdataObject_FreadOnly(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataObj(pu).inf.readOnly:=w;
end;

function fonctionTdataObject_FreadOnly(var pu:typeUO):boolean;pascal;
begin
  verifierObjet(pu);
  result:=TdataObj(pu).inf.readOnly;
end;

procedure proTdataObject_Fexpand(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TdataObj(pu) do
  if inf.temp then Fexpand:=w;
end;

function fonctionTdataObject_Fexpand(var pu:typeUO):boolean;pascal;
begin
  verifierObjet(pu);
  result:=TdataObj(pu).Fexpand;
end;

procedure proTdataObject_FimDisplay(w:boolean;var pu:typeUO);
begin
  if ProcessPhase in [Phase_Init,Phase_init0] then
    begin
      verifierObjet(pu);
      with TdataObj(pu) do
      if inf.temp then
        begin
          FimDisplay:=w;
          ImList.add(pu);
        end;
    end;
end;

function fonctionTdataObject_FimDisplay(var pu:typeUO):boolean;pascal;
begin
  verifierObjet(pu);
  result:=TdataObj(pu).FimDisplay;
end;

function FonctionTdataObject_convX(i:longint;var pu:typeUO):float;
  begin
    verifierObjet(pu);
    FonctionTdataObject_convX:=TdataObj(pu).convX(i);
  end;

function FonctionTdataObject_invconvX(x:float;var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    FonctionTdataObject_invconvX:= TdataObj(pu).invconvX(x);
  end;

function FonctionTdataObject_convY(i:longint;var pu:typeUO):float;
  begin
    verifierObjet(pu);
    FonctionTdataObject_convY:= TdataObj(pu).convY(i);
  end;

function FonctionTdataObject_invconvY(x:float;var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    FonctionTdataObject_invconvY:= TdataObj(pu).invconvY(x);
  end;

function FonctionTdataObject_Xstart(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    FonctionTdataObject_Xstart:= TdataObj(pu).Xstart;
  end;

function FonctionTdataObject_Xend(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    FonctionTdataObject_Xend:= TdataObj(pu).Xend;
  end;

function FonctionTdataObject_Istart(var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    FonctionTdataObject_Istart:= TdataObj(pu).Istart;
  end;

procedure proTdataObject_Istart(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataObj(pu).Istart:=n;
end;


function FonctionTdataObject_Iend(var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    FonctionTdataObject_Iend:= TdataObj(pu).Iend;
  end;

procedure proTdataObject_Iend(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataObj(pu).Iend:=n;
end;


function FonctionTdataObject_Icount(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  FonctionTdataObject_Icount:= TdataObj(pu).Icount;
end;

procedure proTdataObject_Icount(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TdataObj(pu).setIcount(n);
end;


function fonctionTdataObject_NumType(var pu:typeUO):smallint;
  begin
    verifierObjet(pu);
    result:= ord(TdataObj(pu).inf.Tpnum);
  end;

procedure proReAfficherTrace(var pu:typeUO);
begin
  proTplot_refresh(pu);
end;

procedure proReafficher(var pu:typeUO);
begin
  proTplot_refresh(pu);
end;

procedure proModifierAffichage(modifGrad:boolean);
begin
end;





Initialization
AffDebug('Initialization stmDobj1',0);

infModel.defaults;

end.
