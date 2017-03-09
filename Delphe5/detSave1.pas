unit detSave1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, editcont,

  util1,stmdef,stmObj,chooseOb,saveOpt1,debug0;

type
  TdetectSave = class(TForm)
    GroupBox1: TGroupBox;
    LBvectors: TListBox;
    Label6: TLabel;
    enXstart: TeditNum;
    Label7: TLabel;
    enXend: TeditNum;
    Bdefault: TButton;
    Bup: TBitBtn;
    Bdw: TBitBtn;
    Bsave: TButton;
    Boptions: TButton;
    Badd: TButton;
    Bremove: TButton;
    Lxorg: TLabel;
    enXorg: TeditNum;
    cbAppend: TCheckBoxV;
    cbContinu: TCheckBoxV;
    procedure BaddClick(Sender: TObject);
    procedure BremoveClick(Sender: TObject);
    procedure BupClick(Sender: TObject);
    procedure BdwClick(Sender: TObject);
    procedure BdefaultClick(Sender: TObject);
    procedure BoptionsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    XstartD,XendD:Pfloat;
    XminiD,XmaxiD:float;
    ch0:Tlist;
    adSaveRec:^TsaveRecord;

    height0,topButtons,hXorg,hAppend,hContinu:integer;
    tp0:TUOclass;
    withXorg:boolean;
    withAppend:boolean;
    withContinu:boolean;
  public
    { Déclarations publiques }
    procedure InstallXorg(var xorg:float);
    procedure InstallAppend(var Fappend:boolean);
    procedure InstallContinu(var Fcont:boolean);

    function Execution(tp:TUOclass;
                       titre:AnsiString;ch:Tlist;
                       var xstart,Xend:float;mini,maxi:float;
                       var saveRec:TsaveRecord):boolean;
  end;

function detectSave: TdetectSave;

implementation


{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FdetectSave: TdetectSave;

function detectSave: TdetectSave;
begin
  if not assigned(FdetectSave) then FdetectSave:= TdetectSave.create(nil);
  result:= FdetectSave;
end;

procedure TdetectSave.InstallXorg(var xorg:float);
begin
  enXorg.setVar(Xorg,t_extended);
  enXorg.decimal:=6;
  withXorg:=true;
end;

procedure TdetectSave.InstallAppend(var Fappend:boolean);
begin
  cbAppend.setvar(Fappend);
  withAppend:=true;
end;

procedure TdetectSave.InstallContinu(var Fcont:boolean);
begin
  cbContinu.setvar(Fcont);
  withContinu:=true;
end;

function TdetectSave.Execution(tp:TUOclass;
                       titre:AnsiString;ch:Tlist;
                       var xstart,Xend:float;mini,maxi:float;
                       var saveRec:TsaveRecord):boolean;
var
  i:integer;
begin
  Lxorg.visible:=withXorg;
  enXorg.visible:=withXorg;
  cbAppend.visible:=WithAppend;

  height:=height0;
  bSave.top:=topButtons;
  boptions.top:=topButtons;

  if not withXorg then
    begin
      height:=height-hXorg;
      bSave.top:=bSave.top-hXorg;
      boptions.top:=boptions.top-hXorg;
    end;

  if not withAppend then
    begin
      height:=height-happend;
      bSave.top:=bSave.top-happend;
      boptions.top:=boptions.top-happend;
    end;

  if not withContinu then
    begin
      height:=height-hContinu;
      bSave.top:=bSave.top-hContinu;
      boptions.top:=boptions.top-hContinu;
    end;


  caption:=titre;

  ch0:=ch;

  with LBvectors do
  begin
    clear;
    for i:=0 to ch.count-1 do items.add(typeUO(ch.items[i]).ident);
  end;

  XstartD:=@Xstart;
  XendD:=@Xend;
  XminiD:=mini;
  XmaxiD:=maxi;

  enXstart.setVar(Xstart,t_extended);
  enXstart.decimal:=6;
  enXend.setVar(Xend,t_extended);
  enXend.decimal:=6;

  adSaveRec:=@SaveRec;

  tp0:=tp;

  result:=(showModal=mrOK);
  if result then updateAllVar(self);

  withXorg:=false;
  withAppend:=false;
  withContinu:=false;
end;


procedure TdetectSave.BaddClick(Sender: TObject);
const
  ob:TypeUO=nil;
begin
  if LBvectors.items.count>=16 then exit;

  chooseObject.caption:='Choose a vector';
  if chooseObject.execution(tp0,ob) then
    begin
      ch0.add(ob);
      LBvectors.items.add(ob.ident);
    end;
end;

procedure TdetectSave.BremoveClick(Sender: TObject);
begin
  with LBvectors do
  begin
    if itemIndex>=0 then
      begin
        ch0.delete(itemIndex);
        ch0.pack;
        items.delete(itemIndex);
      end;
  end;
end;

procedure TdetectSave.BupClick(Sender: TObject);
begin
  with LBvectors do
  begin
    if itemIndex>0 then
      begin
        ch0.move(itemIndex,itemIndex-1);
        items.move(itemIndex,itemIndex-1);
        itemIndex:=itemIndex-1;
      end;
  end;
end;

procedure TdetectSave.BdwClick(Sender: TObject);
begin
  with LBvectors do
  begin
    if (itemIndex>=0) and (itemIndex<items.count-1) then
      begin
        ch0.move(itemIndex,itemIndex+1);
        items.move(itemIndex,itemIndex+1);
        itemIndex:=itemIndex+1;
      end;
  end;
end;

procedure TdetectSave.BdefaultClick(Sender: TObject);
begin
  XstartD^:=XminiD;
  XendD^:=XmaxiD;

  enXstart.updateCtrl;
  enXend.updateCtrl;
end;

procedure TdetectSave.BoptionsClick(Sender: TObject);
var
  i:integer;
begin
  with adsaveRec^ do
  begin
    stVecs:='';
    for i:=0 to LBvectors.items.count-1 do
      stVecs:=stVecs+LBvectors.items[i]+'|';
    if stVecs='' then exit;
    delete(stVecs,length(stVecs),1);

  end;
  saveOptions.execution(adSaveRec^);
end;

procedure TdetectSave.FormCreate(Sender: TObject);
begin
  height0:=height;
  topButtons:=bSave.top;
  hXorg:=(enXorg.top+enXorg.height) - (enXend.top+enXend.height);
  hAppend:=(cbAppend.top+cbAppend.height) - (enXorg.top+enXorg.height);
  hContinu:=hAppend;
end;

Initialization
AffDebug('Initialization detSave1',0);
{$IFDEF FPC}
{$I detSave1.lrs}
{$ENDIF}
end.
