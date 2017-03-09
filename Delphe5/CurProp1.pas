unit CurProp1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, editcont, Buttons,

  util1,stmObj,stmDplot,stmDobj1,debug0, ChooseOb;

const
  maxCursorStyle=3;
  stStyles='X'+
           '|Y'+
           '|Index';

  stWinContent=
           'I'+
           '|J'+
           '|X(I)'+
           '|Y(I)'+
           '|I+J(I)'+
           '|I+X(I)'+
           '|I+Y(I)'+
           '|X(I)+Y(I)';

type
  TcursorStyle=(csX,csY,csIndex);
  TwinContent=(wcI,wcJ,wcX,wcY,wcIpJ,wcIpX,wcIpY,wcXpY);

  TCurRec=record
            p0:array[1..2] of float;{position en valeur réelle pour les styles X ou Y }
                                    {positions en indice pour les autres }
            dxC1,dxC2:float;        {incréments }
            dI1,dI2:integer;        {incréments entiers pour style Index}
            xminC,xmaxC:float;      {positions mini et maxi}
            visible:boolean;
            style:TcursorStyle;
            WinContent:TwinContent;
            color:integer;
            ObRef:TdataPlot;
            title:string[50];
            double:boolean;
            deci:integer;
            Wwidth:integer;
            TrackSource:boolean;
            ZoomVec:TdataPlot;
            CurLocked:boolean;
            capColor:integer;
            CRchild:boolean;        {non utilisé}
            showSB:boolean;
          end;
  PCurRec=^TCurRec;

type
  TCursorProp = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    enSmallInc: TeditNum;
    enDeci: TeditNum;
    Bcolor: TButton;
    Panel1: TPanel;
    BOK: TButton;
    Bcancel: TButton;
    ColorDialog1: TColorDialog;
    Label3: TLabel;
    Label4: TLabel;
    CBstyle: TcomboBoxV;
    CBdouble: TCheckBoxV;
    CBvisible: TCheckBoxV;
    Label5: TLabel;
    enXmin: TeditNum;
    Label6: TLabel;
    enXmax: TeditNum;
    Label7: TLabel;
    EStitle: TeditString;
    Label8: TLabel;
    enWidth: TeditNum;
    Label9: TLabel;
    enLargeInc: TeditNum;
    Label10: TLabel;
    cbWinContent: TcomboBoxV;
    cbTrackSource: TCheckBoxV;
    Label11: TLabel;
    cbShowScrollBar: TCheckBoxV;
    Esource: TEdit;
    Ezoom: TEdit;
    Bsource: TBitBtn;
    Bzoom: TBitBtn;
    procedure BcolorClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BsourceClick(Sender: TObject);
  private
    { Déclarations privées }
    Adcolor:Plongint;
    oldStyle:TcursorStyle;
    curRec0:PcurRec;
  public
    { Déclarations publiques }

    function execution(var curRec:TcurRec):boolean;
  end;


function CursorProp: TCursorProp;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FCursorProp: TCursorProp;

function CursorProp: TCursorProp;
begin
  if not assigned(FCursorProp) then FCursorProp:= TCursorProp.create(nil);
  result:= FCursorProp;
end;


function TCursorProp.execution(var curRec:TcurRec):boolean;
var
  list:Tlist;
  i:integer;
begin
  curRec0:=@curRec;
  with curRec do
  begin
    oldStyle:=style;
    esTitle.setVar(title,sizeof(title)-1);

    enXmin.setvar(xminC,T_extended);
    enXmax.setvar(xmaxC,T_extended);

    enSmallInc.setvar(dxC1,T_extended);
    enSmallInc.setMinMax(0,1E200);
    enSmallInc.decimal:=6;

    enLargeInc.setvar(dxC2,T_extended);
    enLargeInc.setMinMax(0,1E200);
    enLargeInc.decimal:=6;


    enDeci.setvar(deci,T_longint);
    endeci.setminMax(0,20);

    adColor:=@color;

    list:=getGlobalList(TDataObj,false);
    list.add(nil);

    if assigned(obref)
      then Esource.Text:=obref.ident
      else Esource.Text:='';
    Esource.ReadOnly:=true;

    if assigned(zoomvec)
      then Ezoom.Text:=zoomvec.ident
      else Ezoom.Text:='';
    Ezoom.ReadOnly:=true;

    with CBstyle do
    begin
      setString(stStyles);
      setvar(curRec.style,T_byte,0);
    end;

    with CBwinContent do
    begin
      setString(stWinContent);
      setvar(curRec.WinContent,T_byte,0);
    end;

    CBTrackSource.setvar(TrackSource);
    CBdouble.setvar(double);
    CBvisible.setvar(visible);
    CBshowScrollbar.setvar(showSB);

    enWidth.setvar(Wwidth,T_longint);
    enWidth.setMinMax(250,screen.width);

    result:=(showModal=mrOK);
    if result then
      begin
        updateAllVar(self);
      end;

    list.free;
  end;
end;

procedure TCursorProp.BcolorClick(Sender: TObject);
begin
  if assigned(Adcolor) then
    with colorDialog1 do
    begin
      color:=AdColor^;
      execute;
      AdColor^:=color;
      Panel1.color:=Adcolor^;
    end;
end;

procedure TCursorProp.FormActivate(Sender: TObject);
begin
  if assigned(Adcolor) then panel1.color:=AdColor^;
end;


procedure TCursorProp.BsourceClick(Sender: TObject);
begin
  chooseObject.caption:='Choose an object';
  if chooseObject.execution(TdataPlot,typeUO(curRec0^.obref)) then
    begin
      if assigned(curRec0) and assigned(curRec0^.obref)
        then Esource.text:=curRec0^.obref.ident
        else Esource.text:='';
    end;
end;

Initialization
AffDebug('Initialization CurProp1',0);
{$IFDEF FPC}
{$I CurProp1.lrs}
{$ENDIF}
end.
