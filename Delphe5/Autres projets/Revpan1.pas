unit revpan1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, ComCtrls, ExtCtrls, Grids,

  util1,Gdos,DdosFich,Dgraphic,
  stmObj,stmVec1, chooseOb, debug0 ;

const
  maxNbC=20;
type
  TRCAinfo=record
             dataVec:Tvector;
             stEvt:string[255];

             tmaxi,dt0:double;
             t,dt:double;

             Vc:array[1..maxNbC] of Tvector;

             minC,maxC,dxC0:array[1..maxNbC] of single;
             xC,dxC:array[1..maxNbC] of single;

             nbC:integer;
             numMain:integer;

             AutoScale:boolean;
             seuilZ:double;
             optiAvecSeuil:boolean;
           end;

  TRCAinfo1=record
              Nmoyen,Nsig:double;
              ZupRaw,ZupOpt:array[1..2] of double;
              nbPixelOpt:array[1..2] of integer;

            end;

type
  TrevPanel = class(TForm)
    pageControl1: TPageControl;
    Pgeneral: TTabSheet;
    Pcriteria: TTabSheet;
    Pdisplay: TTabSheet;
    esEvtFile: TeditString;
    Label1: TLabel;
    BevtFile: TButton;
    Label2: TLabel;
    Bcalculate: TButton;
    TabSheet1: TTabSheet;
    ListBox1: TListBox;
    editNum5: TeditNum;
    Badd: TButton;
    Bremove: TButton;
    Bdistri: TButton;
    Panel1: TPanel;
    cbDataVector: TcomboBoxV;
    PaintBox1: TPaintBox;
    cbAutoScale: TCheckBoxV;
    DrawGrid1: TDrawGrid;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    enT2: TeditNum;
    GroupBox3: TGroupBox;
    Lt: TLabel;
    sbT: TscrollbarV;
    Ldt: TLabel;
    sbDT: TscrollbarV;
    GroupBox4: TGroupBox;
    Lx: TLabel;
    Ldx: TLabel;
    sbX: TscrollbarV;
    sbDx: TscrollbarV;
    Label7: TLabel;
    enDt0: TeditNum;
    cbMainC: TcomboBoxV;
    Popti: TTabSheet;
    GroupBox2: TGroupBox;
    LNmoyen: TLabel;
    LdeltaN: TLabel;
    Button1: TButton;
    Label3: TLabel;
    enSeuil: TeditNum;
    cbUseTh: TCheckBoxV;
    LzupRaw: TLabel;
    LzupOpt: TLabel;
    BminMax: TButton;
    enXC: TeditNum;
    enDxC: TeditNum;
    LN1: TLabel;
    LN2: TLabel;
    procedure BcalculateClick(Sender: TObject);
    procedure BevtFileClick(Sender: TObject);
    procedure cbDataVectorDropDown(Sender: TObject);
    procedure sbTScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbDTScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure PdisplayEnter(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure BaddClick(Sender: TObject);
    procedure BremoveClick(Sender: TObject);
    procedure drawGrid1DrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGrid1SetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: string);
    procedure DrawGrid1GetEditText(Sender: TObject; ACol, ARow: Longint;
      var Value: string);
    procedure DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbXScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbDxScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure cbMainCChange(Sender: TObject);
    procedure pageControl1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbDataVectorChange(Sender: TObject);
    procedure cbMainCDropDown(Sender: TObject);
    procedure BdistriClick(Sender: TObject);
    procedure BminMaxClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure enXCEnter(Sender: TObject);
    procedure enDxCEnter(Sender: TObject);
  private
    { Déclarations privées }
    adInfo:^TRCAinfo;
    adInfo1:^TRCAinfo1;

    owner0:typeUO;
  public

    { Déclarations publiques }
    loadEvtFileP: procedure of object;
    CalculPsthP: procedure of object;
    CalculOptiP: procedure of object;
    AddCriterionP: procedure (ob:Tvector) of object;
    removeCriterionP: procedure(num:integer) of object;
    recalculeDistriP: procedure(num:integer) of object;
    cadrerCritereP: procedure(num:integer) of object;

    scrollTP,scrollDTP:procedure (x:float) of object;
    scrollXP,scrollDXP:procedure (x:float) of object;

    procedure initSB;
    procedure initSBC;
    procedure AffichePopti;

    procedure init(owner:typeUO;var Info:TRCAinfo;var resultat:TRCAinfo1);

    procedure setCaptions;
  end;

var
  revPanel: TrevPanel;

implementation



{$R *.DFM}

procedure TrevPanel.init(owner:typeUO;var Info:TRCAinfo;var resultat:TRCAinfo1);
begin
  owner0:=owner;
  adinfo:=@info;
  adinfo1:=@resultat;

  with adinfo^ do
  begin
    cbDataVector.items.clear;
    if assigned(dataVec) then cbDataVector.items.add(DataVec.ident);
    cbDataVector.itemIndex:=0;

    esEvtFile.setvar(stEvt,128);

    installeComboBox(cbDataVector,dataVec);

    enT2.setVar(tmaxi,t_double);
    enT2.setMinMax(0,10000);

    endt0.setVar(dt0,t_double);

    cbAutoScale.setvar(autoscale);

    enSeuil.setvar(seuilZ,t_double);

    cbUseTh.setvar(OptiAvecSeuil);

    cbMainCDropDown(nil);
  end;

  with adInfo1^ do
  begin

  end;

  initSB;
  initSBC;

end;

procedure TrevPanel.initSB;
begin
  with adInfo^ do
  begin
    sbt.setParams(t,-tmaxi,tmaxi-dt) ;
    sbt.dxSmall:=dt0;
    sbt.dxLarge:=dt0*10;

    sbdt.setParams(dt,dt0,tmaxi) ;
    sbdt.dxSmall:=dt0;
    sbdt.dxLarge:=dt0*10;

    Lt.caption:='t='+Estr(t,3);
    Ldt.caption:='dt='+Estr(dt,3);
  end;

  with adinfo1^ do LZupRaw.caption:='Zup=  '+Estr(adinfo1^.ZupRaw[1]+adinfo1^.ZupRaw[2],6);
end;

procedure TrevPanel.initSBC;
begin
  with adInfo^ do
  begin
    if (nbC=0) or (numMain=0) or (numMain>nbC) then
      begin
        sbX.enabled:=false;
        sbDX.enabled:=false;
        enXC.enabled:=false;
        enDXC.enabled:=false;

        exit;
      end;

    sbX.enabled:=true;
    sbDX.enabled:=true;

    enXC.enabled:=true;
    enDXC.enabled:=true;
    enXC.setvar(Xc[numMain],t_single);
    enDXC.setvar(dXc[numMain],t_single);

    sbX.setParams(Xc[numMain],minC[numMain],maxC[numMain]) ;
    sbX.dxSmall:=dxC0[numMain];
    sbX.dxLarge:=dxC0[numMain]*10;

    sbdX.setParams(dXC[numMain], dxC0[numMain],maxC[numMain]-minC[numMain]);
    sbdX.dxSmall:=dxC0[numMain];
    sbdX.dxLarge:=dxC0[numMain]*10;

  end;
end;




procedure TrevPanel.BcalculateClick(Sender: TObject);
begin
  updateAllVar(self);
  CalculPsthP;
end;

procedure TrevPanel.BevtFileClick(Sender: TObject);
var
  stFichier,stgen:pathStr;
begin
  stFichier:=adinfo^.StEvt;
  stgen:='*.evt';
  if choixFichierStandard(stgen,stfichier,nil) then
    begin
      adinfo^.stEvt:=stFichier;
      esEvtFile.updateCtrl;
      loadEvtFileP;
    end;
end;

procedure TrevPanel.cbDataVectorDropDown(Sender: TObject);
begin
  with adInfo^ do installeComboBox(cbDataVector,dataVec);
end;

procedure TrevPanel.sbTScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  updateAllvar(self);
  Lt.caption:='t='+Estr(x,3);
  scrollTP(x);
  paintBox1.refresh;
end;

procedure TrevPanel.sbDTScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  updateAllvar(self);
  Ldt.caption:='dt='+Estr(x,6);
  scrollDTP(x);

  with adinfo^ do
  begin
    sbt.setParams(t,-tmaxi,tmaxi-dt) ;
  end;
  paintBox1.refresh;

  LZupRaw.caption:='Zup=  '+Estr(adinfo1^.ZupRaw[1]+adinfo1^.ZupRaw[2],6);
end;

procedure TrevPanel.PdisplayEnter(Sender: TObject);
begin
  initSB;
  initSBC;
end;

procedure TrevPanel.PaintBox1Paint(Sender: TObject);
var
  hei,len:integer;
begin
  if not assigned(adinfo) then exit;


  with paintbox1 do initGraphic(canvas,left,top,width,height);

  len:=paintbox1.width-20;
  hei:=6;

  with paintbox1.canvas do
  begin
    pen.color:=clBlack;
    brush.color:=clGreen;
    rectangle(10,10,10+len,10+hei);

    brush.color:=clRed;

    with adinfo^ do
    rectangle(10+roundL((t+tmaxi)/(2*tmaxi)*len),10,
              10+roundL((t+dt+tmaxi)/(2*tmaxi)*len),10+hei);
  end;

end;

procedure TrevPanel.BaddClick(Sender: TObject);
const
  ob:TypeUO=nil;

begin
  if adInfo^.nbC>=maxNbc then exit;

  if chooseObject.execution(Tvector,ob) then
    begin
      if not assigned(ob) then exit;
      affdebug('TrevPanel.BaddClick '+ob.ident);

      AddCriterionP(Tvector(ob));
    end;

end;

procedure TrevPanel.BremoveClick(Sender: TObject);
begin
  with adInfo^,drawGrid1 do
  begin
    if (nbC=0) or (row>nbC) then exit;

    removeCriterionP(row);
  end;
end;

procedure TrevPanel.drawGrid1DrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
var
  st:string;
  x:integer;
begin
  with adInfo^ do
  begin
    st:='';

    case col of
      0:  if (row>=1) and (row<=nbC) then st:=vc[row].ident;
      1:  if row=0 then st:='min'
          else
          if row<=nbC then st:=Estr(minC[row],6);
      2:  if row=0 then st:='max'
          else
          if row<=nbC then st:=Estr(maxC[row],6);
      3:  if row=0 then st:='dx0'
          else
          if row<=nbC then st:=Estr(dxC0[row],6);
    end;

    if (row=0) or (col=0)
      then x:=rect.left+1
      else x:=rect.right-drawGrid1.canvas.TextWidth(st)-2;

    drawGrid1.canvas.TextOut(x,rect.top+1,st);
  end;
end;

procedure TrevPanel.DrawGrid1SetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: string);
var
  x:float;
  code:integer;
begin
  with drawGrid1,adInfo^ do
  begin
    val(value,x,code);
    if (code=0) and (Acol<>0) and (Arow<>0) and (arow<=nbC) then
      begin
        if acol=1 then minC[row]:=x
        else
        if acol=2 then maxC[row]:=x
        else
        if acol=3 then dxC0[row]:=x;
      end;
  end;
end;

procedure TrevPanel.DrawGrid1GetEditText(Sender: TObject; ACol,
  ARow: Longint; var Value: string);
begin
  if Acol=4 then drawGrid1.options:=drawGrid1.options-[goEditing]
            else drawGrid1.options:=drawGrid1.options+[goEditing];
end;

procedure TrevPanel.DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  row1,col1:longint;
  p:Tpoint;
begin
  drawGrid1.mousetoCell(x,y,col1,row1);
  {messageCentral('col1='+Istr(col1)+'   row1='+Istr(row1));}

  if col1=4 then drawGrid1.options:=drawGrid1.options-[goEditing]
            else drawGrid1.options:=drawGrid1.options+[goEditing];

  if (col1=4) and (row1<=adInfo^.nbC) then
    begin
      if adInfo^.NumMain=row1
        then  adInfo^.NumMain:=0
        else  adInfo^.NumMain:=row1;

      drawGrid1.invalidate;
      initSBC;
    end;
end;

procedure TrevPanel.sbXScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
var
  dx0:float;
begin
  updateAllvar(self);
  scrollXP(x);
  enXc.updateCtrl;
  setCaptions;

end;

procedure TrevPanel.sbDxScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  updateAllvar(self);
  scrollDxP(x);
  enDxC.updateCtrl;
  setCaptions;
end;

procedure TrevPanel.cbMainCChange(Sender: TObject);
begin
  adInfo^.NumMain:=cbMainC.itemIndex;
  initSBC;
end;

procedure TrevPanel.pageControl1Change(Sender: TObject);
begin
  if pageControl1.ActivePage=Pdisplay then initSBC
  else
  if pageControl1.ActivePage=Popti then AffichePopti;
end;

procedure TrevPanel.AffichePopti;
begin
  LNmoyen.caption:='N=    '+Estr(adinfo1^.Nmoyen,3);
  LdeltaN.caption:='dN= +-'+Estr(adinfo1^.Nsig,3);
  LZupOpt.caption:='Zup=  '+Estr(adinfo1^.ZupOpt[1]+adinfo1^.ZupOpt[2],6);
end;

procedure TrevPanel.Button1Click(Sender: TObject);
begin
  updateAllVar(self);
  calculOptiP;
  AffichePopti;
end;

procedure TrevPanel.cbDataVectorChange(Sender: TObject);
begin
  with adInfo^ do
  begin
    owner0.derefObjet(typeUO(dataVec));
    with CBdataVector do
    if (itemIndex>=0) and (itemIndex<items.count-1) then
      begin
        dataVec:=Tvector(typeUO(items.objects[itemIndex]).
                    realObject(items.strings[itemIndex]));
        owner0.refObjet(typeUO(dataVec));
      end
    else dataVec:=nil;
  end;
end;

procedure TrevPanel.cbMainCDropDown(Sender: TObject);
var
  i:integer;
begin
  with adInfo^ do
  begin
    cbMainC.clear;
    cbMainC.items.add('');
    for i:=1 to nbc do
      if assigned(vc[i]) then cbMainC.items.add(vc[i].ident);

    if numMain>nbc then numMain:=0;
    cbMainC.itemIndex:=numMain;
  end;
end;

procedure TrevPanel.BdistriClick(Sender: TObject);
var
  nc:integer;
begin
  nc:=drawGrid1.row;
  if nc<=adInfo^.nbc then recalculeDistriP(nc);
end;

procedure TrevPanel.BminMaxClick(Sender: TObject);
var
  nc:integer;
begin
  nc:=drawGrid1.row;
  cadrerCritereP(nc);
  drawGrid1.invalidate;
end;

const
  colW=85;

procedure TrevPanel.FormResize(Sender: TObject);
begin
 {
  with drawGrid1 do
  begin
    colWidths[1]:=colW;
    colWidths[2]:=colW;
    colWidths[3]:=colW;

    colWidths[0]:=clientwidth-colW*3-3;
  end;}
end;

procedure TrevPanel.FormCreate(Sender: TObject);
begin
  with drawGrid1 do
  begin
    colWidths[1]:=colW;
    colWidths[2]:=colW;
    colWidths[3]:=colW;

    colWidths[0]:=clientwidth-colW*3-3;
  end;
end;

procedure TrevPanel.enXCEnter(Sender: TObject);
begin
  with adinfo^ do
  begin
    if (numMain<=0) or (numMain>nbC) then exit;

    updateAllVar(self);
    initSBC;
    scrollXP(xc[numMain]);

  end;
end;

procedure TrevPanel.enDxCEnter(Sender: TObject);
begin
  with adinfo^ do
  begin
    if (numMain<=0) or (numMain>nbC) then exit;

    updateAllVar(self);
    initSBC;
    scrollDXP(dxc[numMain]);
  end;
end;

procedure TrevPanel.setCaptions;
begin
  with adInfo1^ do
  begin
    LN1.caption:='N1='+Istr(nbPixelOpt[1]);
    LN2.caption:='N2='+Istr(nbPixelOpt[2]);
  end;
end;

end.
