unit cursor1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, Buttons,

  util1, stmObj,CurProp1,stmCurs, ExtCtrls,debug0 ;

type
  TLineCursor = class(TForm)
    Label1: TLabel;
    BOK: TButton;
    Bcancel: TButton;
    Label2: TLabel;
    scrollbarV1: TscrollbarV;
    scrollbarV2: TscrollbarV;
    Bprop: TBitBtn;
    Ltitle: TLabel;
    Ldiff: TLabel;
    Bsearch1: TBitBtn;
    Bsearch2: TBitBtn;
    BackPanel: TPanel;
    procedure BpropClick(Sender: TObject);
    procedure scrollbarV1ScrollV(Sender: TObject; x: Extended;ScrollCode: TScrollCode);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Bsearch1Click(Sender: TObject);
    procedure Bsearch2Click(Sender: TObject);
  private
    { Déclarations privées }

    H0:integer;            { Top du premier label }
    DH:integer;            { intervalle entre 2 labels (en hauteur) }
    Hdlg:integer;
    Hcaption: integer;
  public
    { Déclarations publiques }
    OwnerC: TLcursor;

    centrer: procedure (num:integer) of object;

    Fmodale:boolean;


    procedure init(ShowProp:boolean);
    procedure initData;

    procedure UpdateCtrls(n:integer);
    procedure setEmbeddedParams(embed:boolean);
  end;


implementation



{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TlineCursor.init(ShowProp:boolean);
var
  D:float;
  i,i1,i2:integer;
  y:integer;
begin
  
  with OwnerC.rec do
  begin
    if Fmodale then
      begin
        caption:=title;
        Ltitle.caption:='';
      end
    else Ltitle.caption:=title;

    Ltitle.visible:=Ltitle.caption<>'';
    label2.visible:=double;
    ScrollbarV2.visible:=double;
    Ldiff.visible:=double;
    BOK.visible:=Fmodale;
    Bcancel.visible:=Fmodale;

    ownerC.initParams;

    with scrollBarV1 do
    begin
      setParams(p0[1],xminC,xmaxC);
      dxSmall:=dxC1;
      dxLarge:=dxC2;
    end;

    label1.caption:=ownerC.getCaption(1);

    if double then
      begin
        with scrollBarV2 do
        begin
          setParams(p0[2],xminC,xmaxC);
          dxSmall:=dxC1;
          dxLarge:=dxC2;
        end;
        label2.caption:=ownerC.getCaption(2);
        Ldiff.caption:=ownerC.getCaption(3);
     end;

    y:=H0;
    if Ltitle.visible then
      begin
        Ltitle.top:=y;
        inc(y,DH);
      end;

    Label1.top:=y;
    scrollBarV1.top:=y;
    Bprop.top:=y;
    Bsearch1.top:=y;
    inc(y,DH);

    if Label2.visible then
      begin
        Label2.top:=y;
        scrollBarV2.top:=y;
        Bsearch2.top:=y;
        inc(y,DH);
      end;

    if Ldiff.visible then
      begin
        Ldiff.top:=y;
        inc(y,DH);
      end;

    if BOK.visible then
      begin
        BOK.top:=y;
        Bcancel.top:=y;
        inc(y,BOK.height+4);
      end;

    ClientHeight:= y;
    ClientWidth:=Wwidth;

    Bprop.Visible:= ShowProp;
    Bprop.left:=width-Bprop.width-8;
    scrollBarV1.left:=ClientWidth- Bprop.width * ord(ShowProp)-scrollBarV1.width-15;
    scrollBarV2.left:=scrollBarV1.left;

    Bsearch1.left:=scrollBarV1.left-BSearch1.width-5;
    Bsearch2.Visible:=double and showSB;
    Bsearch2.left:=Bsearch1.left;

    scrollBarV1.visible:=showSB;
    scrollBarV2.visible:=double and showSB;
    if not showSB then
      begin
        Bprop.left:=scrollBarV1.left;
        ClientWidth:=ClientWidth-scrollBarV1.width;
      end;

    if BorderStyle=bsDialog
      then Hdlg:=ClientHeight-Hcaption
      else Hdlg:=ClientHeight;

    backPanel.ClientHeight;
    backPanel.Width:=ClientWidth;

  end;
end;

procedure TlineCursor.initData;
begin
  with OwnerC.rec do
  begin
    ownerC.initParams;

    scrollBarV1.setParams(p0[1],xminC,xmaxC);
    label1.caption:=ownerC.getCaption(1);
    if double then
      begin
        scrollBarV2.setParams(p0[2],xminC,xmaxC);
        label2.caption:=ownerC.getCaption(2);
        Ldiff.caption:=ownerC.getCaption(3);
     end;
   end;
end;


procedure TLineCursor.BpropClick(Sender: TObject);
var
  rec0:TcurRec;
  NewObref:boolean;
begin
  rec0:=OwnerC.rec;

  cursorProp.CBstyle.enabled:= not Fmodale;
  cursorProp.Bsource.enabled:= not Fmodale;
  cursorProp.CBdouble.enabled:= not Fmodale;
  cursorProp.CBvisible.enabled:= not Fmodale;

  if cursorProp.execution(rec0) then
    begin
      NewObref:=OwnerC.rec.ObRef<>rec0.obref;
      if newObRef then ownerC.changeObRef(rec0.obref);

      if OwnerC.rec.ZoomVec<>rec0.zoomVec then ownerC.changeZoomVec(rec0.zoomVec);

      OwnerC.rec:=rec0;
      init(true);
      ownerC.Finvalidate2;
    end;
end;



procedure TLineCursor.scrollbarV1ScrollV(Sender: TObject; x: Extended;ScrollCode: TScrollCode);
var
  num:integer;
begin
  num:=TscrollbarV(sender).tag;

  if assigned(ownerC) and (scrollCode<>scEndScroll) then ownerC.Fmodify(num,x);
  if num=1
    then label1.caption:=ownerC.getCaption(1)
    else label2.caption:=ownerC.getCaption(2);

  if OwnerC.rec.double then Ldiff.caption:=ownerC.getCaption(3);
end;

procedure TLineCursor.FormShow(Sender: TObject);
begin
  init(Bprop.Visible);
end;

procedure TLineCursor.FormCreate(Sender: TObject);
begin
  H0:=Ltitle.top;
  DH:=Label1.top-H0;
  Hcaption:=Height-ClientHeight;
end;

procedure TLineCursor.UpdateCtrls(n:integer);
begin
  if n=1 then
    begin
      with scrollBarV1,OwnerC do
      begin
        setParams(rec.p0[1],rec.xminC,rec.xmaxC);
      end;

      label1.caption:=ownerC.getCaption(1);
      exit;
    end;

  if (n=2) and OwnerC.rec.double then
    begin
      with scrollBarV2,OwnerC do
      begin
        setParams(rec.p0[2],rec.xminC,rec.xmaxC);
      end;
      label2.caption:=ownerC.getCaption(2);
    end;

  if OwnerC.rec.double then Ldiff.caption:=ownerC.getCaption(3);
end;

procedure TLineCursor.Bsearch1Click(Sender: TObject);
begin
  ownerC.Centrer(1);
end;

procedure TLineCursor.Bsearch2Click(Sender: TObject);
begin
  ownerC.centrer(2);
end;

procedure TLineCursor.setEmbeddedParams(embed: boolean);
begin
  if embed then
  begin
     BackPanel.BevelOuter:=BvRaised;
     BorderStyle:=BsNone;
  end
  else
  begin
    BackPanel.BevelOuter:=BvNOne;
    BorderStyle:=BsDialog;
  end;
  ClientHeight:=Hdlg;
  BackPanel.Height:=Hdlg;
end;

Initialization
AffDebug('Initialization cursor1',0);
{$IFDEF FPC}
{$I cursor1.lrs}
{$ENDIF}
end.
