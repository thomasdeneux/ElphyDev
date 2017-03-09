unit VlistForm1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TPform0, Menus, ExtCtrls, StdCtrls, editcont,

  util1,stmdef,stmObj, debug0;

type
  TVlistForm = class(TPform)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label1: TLabel;
    enDxAff: TeditNum;
    enDyAff: TeditNum;
    sbDx: TScrollBar;
    sbDy: TScrollBar;
    Panel4: TPanel;
    Pnum: TPanel;
    Panel8: TPanel;
    SBindex: TscrollbarV;
    Panel9: TPanel;
    cbHold: TCheckBoxV;
    BdisplayAll: TButton;
    Label2: TLabel;
    enNbLine: TeditNum;
    Label3: TLabel;
    cbVscale: TcomboBoxV;
    cbDisplaySel: TCheckBoxV;
    Bupdate: TButton;
    Save1: TMenuItem;
    NewFile1: TMenuItem;
    Append1: TMenuItem;
    Copyselection1: TMenuItem;
    Edit1: TMenuItem;
    SelectAll1: TMenuItem;
    UnselectAll1: TMenuItem;
    procedure FormPaint(Sender: TObject);
    procedure SBindexScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure cbHoldClick(Sender: TObject);
    procedure BdisplayAllClick(Sender: TObject);
    procedure enNbLineExit(Sender: TObject);
    procedure sbDxScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure sbDyScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure cbShowNumClick(Sender: TObject);
    procedure enDxAffExit(Sender: TObject);
    procedure cbVscaleChange(Sender: TObject);
    procedure BupdateClick(Sender: TObject);
    procedure NewFile1Click(Sender: TObject);
    procedure Append1Click(Sender: TObject);
    procedure Copyselection1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure UnselectAll1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function VlistForm: TVlistForm;

implementation

uses StmVlist0;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FVlistForm: TVlistForm;

function VlistForm: TVlistForm;
begin
  if not assigned(FVlistForm) then FVlistForm:= TVlistForm.create(nil);
  result:= FVlistForm;
end;


procedure TVlistForm.FormPaint(Sender: TObject);
begin
  inherited;
  if assigned(Uplot) then
  with TVlist0(Uplot) do Pnum.caption:=Istr(ligne1)+' / '+Istr(count);
end;

procedure TVlistForm.SBindexScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  if (scrollCode<>scPosition) and (scrollCode<>scTrack)
    then TVlist0(Uplot).setFirstLine(roundL(x));
end;

procedure TVlistForm.cbHoldClick(Sender: TObject);
begin
  if HoldMode then HoldFirst:=true;
  invalidate;
end;

procedure TVlistForm.BdisplayAllClick(Sender: TObject);
var
  i:integer;
  oldHold:boolean;
begin
  oldHold:=HoldMode;
  HoldMode:=true;
  HoldFirst:=true;


  with TVList0(Uplot) do
  for i:=1 to count do
  begin
    setFirstLine(i);
    self.Refresh;
  end;

  HoldMode:=oldHold;
end;


procedure TVlistForm.enNbLineExit(Sender: TObject);
var
  old:integer;
begin
  old:=TVList0(Uplot).nbligne;
  enNbLine.UpdateVar;
  with TVList0(Uplot) do
  if nbligne<>old then invalidate;
end;

procedure TVlistForm.sbDxScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
  with TVList0(Uplot) do
  begin
    Dxaff:=sbDx.position/10;
    enDxAff.updateCtrl;

    case scrollCode of
      scTrack:begin
                gridON:=true;
                messageToRef(UOmsg_displayGUI,nil);
              end;
      else
        begin
          gridON:=false;
          invalidate;
        end;
    end;
  end;
end;

procedure TVlistForm.sbDyScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
  with TVList0(Uplot) do
  begin
    Dyaff:=sbDy.position/10;
    enDyAff.updateCtrl;

    case scrollCode of
      scTrack:begin
                gridON:=true;
                messageToRef(UOmsg_displayGUI,nil);
              end;
      else
        begin
          gridON:=false;
          invalidate;
        end;
    end;
  end;
end;

procedure TVlistForm.cbShowNumClick(Sender: TObject);
begin
  TVList0(Uplot).invalidate;
end;

procedure TVlistForm.enDxAffExit(Sender: TObject);
begin
  with TVList0(Uplot) do
  begin
    enDxAff.updatevar;
    sbDx.position:=round(DxAff*10);
    enDyAff.updatevar;
    sbDy.position:=round(DyAff*10);
    invalidate;
  end;
end;

procedure TVlistForm.cbVscaleChange(Sender: TObject);
begin
  inherited;
  cbVscale.UpdateVar;
  TVList0(Uplot).invalidate;
end;

procedure TVlistForm.BupdateClick(Sender: TObject);
begin
  TVList0(Uplot).invalidate;
end;

procedure TVlistForm.NewFile1Click(Sender: TObject);
begin
  TVList0(Uplot).SaveSelectionG(false);

end;

procedure TVlistForm.Append1Click(Sender: TObject);
begin
  TVList0(Uplot).SaveSelectionG(true);

end;

procedure TVlistForm.Copyselection1Click(Sender: TObject);
begin
  TVList0(Uplot).CopySelectionG;

end;

procedure TVlistForm.SelectAll1Click(Sender: TObject);
begin
  TVList0(Uplot).selectAllG;

end;

procedure TVlistForm.UnselectAll1Click(Sender: TObject);
begin
  TVList0(Uplot).unselectAllG;

end;

Initialization
AffDebug('Initialization VlistForm1',0);
{$IFDEF FPC}
{$I VlistForm1.lrs}
{$ENDIF}
end.
