unit Mtag2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,menus,classes,sysutils,graphics,
     util1,Dgraphic,dtf0,varconf1,
     stmdef,stmObj,stmPlot1,stmPopUp,
     debug0,Ncdef2,stmError,
     tpForm0;

type
  TTagRec=packed record
            SampleIndex:integer;
            Stime:TdateTime;
            code:byte;
            ep:integer;
            st:AnsiString;
            ObjOffs:longword;
          end;

  TtagRecArray=array of TtagRec;

  TMtagVector=
    class(Tplot)
      dfOwner:typeUO;

      tags:TtagRecArray;
      x0u,Dxu:float;

      SplitPos:integer;

      constructor create;override;
      destructor destroy;override;
      class function STMClassName:AnsiString;override;
      function getPopUp:TpopUpMenu;override;
      procedure Proprietes(sender:Tobject);override;
      {function getTitle:AnsiString;override;}

      procedure initdata(pp:TtagRecArray;x0,dx:float);

      procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                              const order:integer=-1); override;
      function MouseDownMG(numOrdre:integer;Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean; override;

      function MouseMoveMG(x,y:integer):boolean; override;
      procedure MouseUpMG(x,y:integer; mg:typeUO); override;

      procedure createForm;override;
      procedure invalidateForm;override;

      function getTime(i:integer):float;
      function getITime(i:integer):integer;
      function getCode(i:integer):integer;

      procedure GotoTag(num:integer);

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
                   override;
      procedure completeLoadInfo;override;
    end;

var
  MTagColors:array[0..15] of integer;

function fonctionTMtag_times(i:integer;var pu:typeUO):float;pascal;
function fonctionTMtag_Itimes(i:integer;var pu:typeUO):integer;pascal;
function fonctionTMtag_codes(i:integer;var pu:typeUO):float;pascal;

function fonctionTMtag_color(i:integer;var pu:typeUO):integer;pascal;

implementation

uses MtagProp1, stmdf0, descElphy1, DBrecord1;

{******************** Méthodes de TMTagVector *********************************}

constructor TMtagVector.create;
begin
  inherited create;
end;

destructor TMtagVector.destroy;
begin
  messageToRef(UOmsg_destroy,nil);
  tags:=nil;

  inherited;
end;

class function TMtagVector.STMClassName:AnsiString;
begin
  result:='MTagVector';
end;

function TMtagVector.getPopUp:TpopUpMenu;
begin
  with PopUps do
  begin
    PopupItem(pop_Tsymbs,'Tsymbs_Properties').onClick:=Proprietes;

    result:=pop_Tsymbs;
  end;
end;

procedure TMtagVector.Proprietes(sender:Tobject);
begin
  show(nil);
end;

procedure TMtagVector.createForm;
begin
  form:=TMtagProperties.create(formStm);
  TMtagProperties(form).init(self);
end;

procedure TMtagVector.invalidateForm;
begin
  if assigned(form) then TMtagProperties(form).invalidate;
end;


procedure TMtagVector.initdata(pp:TtagRecArray;x0,dx:float);
begin
  tags:=pp;

  x0u:=x0;
  dxu:=dx;

  if assigned(form) then
    TMtagProperties(form).init(self);

  invalidate;
end;


procedure TMtagVector.displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                                    const order:integer=-1);
var
  i:integer;
  x,x1,y1,x2,y2:float;
  i1,j1:integer;
begin
  getWorld(x1,y1,x2,y2);

  for i:=0 to high(tags) do
  with tags[i] do
  begin
    x:=Dxu*SampleIndex+x0u;
    if (x>=x1) and (x<=x2) then
      begin
        linever(x,MtagColors[code and 15],false);
        i1:=convwx(x);
        j1:=y2act-10;

        canvasGlb.brush.color:=MtagColors[code and 15];
        canvasGlb.brush.style:=bsSolid;
        canvasGlb.roundRect(i1-5,j1-3,i1+5,j1+3,4,4);
      end
    else
    if x>x2 then break;
  end;
end;

function TMtagVector.MouseDownMG(numOrdre: integer; Irect: Trect;
  Shift: TShiftState; Xc, Yc, X, Y: Integer): boolean;
var
  i:integer;
  x0,x1,y1,x2,y2:float;
  i1,j1,xi,yi:integer;

  rr:Trect;
  stHint:AnsiString;
  ff:Tstream;
  uo:typeUO;
begin
  result:=false;

  getWorld(x1,y1,x2,y2);

  {coo du clic dans le rectangle intérieur}
  xi:=x+x1act-Irect.left;
  yi:=y+y1act-Irect.top;

  with Irect do setWindow(left,top,right,bottom);
  setWorld(x1,y1,x2,y2);

  for i:=0 to high(tags) do
  with tags[i] do
  begin
    x0:=Dxu*SampleIndex+x0u;
    if (x0>=x1) and (x0<=x2) then
      begin
        i1:=convwx(x0)-x1act;
        j1:=y2act-10-y1act;
        rr:=Rect(i1-5,j1-3,i1+5,j1+3);
        if ptInRect(rr,classes.point(xi,yi)) then
          begin
            result:=true;
            stHint:='t='+Estr(sampleIndex*dxu+x0u,3)+crlf+
                    DateTimeToStr(Stime)+crlf+
                    st;
            if ObjOffs<>0 then
            begin
              ff:=TelphyDescriptor(TdataFile(dfOwner).FileDesc).FileStream;
              if assigned(ff) then
              begin
                ff.Position:=ObjOffs;
                uo:= readAndCreateUO(ff,UO_temp,false,true);
                if uo is TdbRecord then stHint:=stHint+crlf+TdbRecord(uo).getText(6);
                uo.Free;
              end;
            end;
            ShowStmHint(xc+x,yc+y,stHint);
            exit;
          end;

      end
    else
    if x0>x2 then break;
  end;
end;

function TMtagVector.MouseMoveMG(x, y: integer): boolean;
begin

end;

procedure TMtagVector.MouseUpMG(x, y: integer; mg:typeUO);
begin
  HideStmHint;

end;

procedure TMtagVector.GotoTag(num: integer);
begin
  TdataFile(dfOwner).trackPosition(tags[num].ep+1,tags[num].SampleIndex*Dxu+x0u);
end;


function TMtagVector.getTime(i:integer):float;
begin
  if (i>=0) and (i<length(tags))
    then result:=Dxu*tags[i].sampleIndex
    else result:=-1;
end;

function TMtagVector.getITime(i:integer):integer;
begin
  if (i>=0) and (i<length(tags))
    then result:=tags[i].sampleIndex
    else result:=-1;
end;

function TMtagVector.getCode(i:integer):integer;
begin
  if (i>=0) and (i<length(tags))
    then result:=tags[i].code
    else result:=-1;
end;

{************************** Méthodes Stm **********************************}

const
  E_index=4001;

function fonctionTMtag_times(i:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TMtagVector(pu) do
  begin
    if (i<1) or (i>length(tags)) then sortieErreur(E_index);
    result:=getTime(i-1);
  end;
end;

function fonctionTMtag_Itimes(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TMtagVector(pu) do
  begin
    if (i<1) or (i>length(tags)) then sortieErreur(E_index);
    result:=getITime(i-1);
  end;
end;


function fonctionTMtag_codes(i:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TMtagVector(pu) do
  begin
    if (i<1) or (i>length(tags)) then sortieErreur(E_index);
    result:=getCode(i-1);
  end;
end;

function fonctionTMtag_color(i:integer;var pu:typeUO):integer;
begin
  result:=MTagColors[i and 15];
end;


procedure TMtagVector.BuildInfo(var conf: TblocConf; lecture,
  tout: boolean);
begin
  if assigned(form) then
    SplitPos:=TMtagProperties(form).VlbTag.Width;

  inherited;
  conf.setvarConf('Split',SplitPos,sizeof(splitPos));

end;

procedure TMtagVector.completeLoadInfo;
begin
  inherited;

  if assigned(form) and (SplitPos>200) and (SplitPos<form.Width-10) then
    TMtagProperties(form).VlbTag.Width:=SplitPos;

end;

Initialization
AffDebug('Initialization Mtag2',0);

  MTagColors[0]:=rgb(  0, 0  ,255);
  MTagColors[1]:=rgb(  0, 255,  0);
  MTagColors[2]:=rgb(255, 0  ,  0);
  MTagColors[3]:=rgb( 0 ,255 ,192);

  MTagColors[4]:=rgb(255,  0 ,255);
  MTagColors[5]:=rgb(192,192 ,  0);
  MTagColors[6]:=rgb(192,  0 ,192);
  MTagColors[7]:=rgb(128,  0 ,   0);

  MTagColors[8]:=rgb (  0 ,128,  0);
  MTagColors[9]:=rgb(  0,   0,128);
  MTagColors[10]:=rgb(  0, 128,128);
  MTagColors[11]:=rgb(128,   0,128);

  MTagColors[12]:=rgb(128, 128,  0);
  MTagColors[13]:=rgb(128, 128, 128);
  MTagColors[14]:=rgb( 64,  64,  64);
  MTagColors[15]:=rgb( 64, 128,  64);

  registerObject(TMtagVector,sys);

end.
