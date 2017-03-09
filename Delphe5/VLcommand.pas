unit VLcommand;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, ExtCtrls,

  util1, Menus, debug0;

type
  TVlistCommand = class(TForm)
    Panel2: TPanel;
    Label1: TLabel;
    PanelSeq: TPanel;
    sbCurrent: TscrollbarV;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    Saveselection1: TMenuItem;
    Selectall1: TMenuItem;
    Unselectall1: TMenuItem;
    Ptexte: TPanel;
    Newfile1: TMenuItem;
    Apend1: TMenuItem;
    Copyselection1: TMenuItem;
    procedure sbCurrentScrollV(Sender: TObject; x: Extended;ScrollCode: TScrollCode);
    procedure Selectall1Click(Sender: TObject);
    procedure Unselectall1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Newfile1Click(Sender: TObject);
    procedure Append1Click(Sender: TObject);
    procedure Copyselection1Click(Sender: TObject);
  private
    { Déclarations privées }
    h0,Htext:integer;
  public
    { Déclarations publiques }
    modifyIcur: procedure(i:integer) of object;
    SelectAll:procedure of object;
    unSelectAll:procedure of object;
    SaveSelection:procedure (append:boolean) of object;          
    copySelection:procedure of object;

    procedure initParams(I,Imin,Imax:integer);
    procedure setTexte(st:AnsiString);
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TVlistCommand.initParams(I,Imin,Imax:integer);
begin
  sbCurrent.setParams(I,Imin,Imax);
  panelSeq.caption:=Istr(roundL(I));
end;

procedure TVlistCommand.sbCurrentScrollV(Sender: TObject; x: Extended;ScrollCode: TScrollCode);
begin
  panelSeq.caption:=Istr(roundL(x));

  if (scrollCode<>scPosition) and (scrollCode<>scTrack)
    then ModifyIcur(roundL(x));
end;

procedure TVlistCommand.Selectall1Click(Sender: TObject);
begin
  selectAll;
end;

procedure TVlistCommand.Unselectall1Click(Sender: TObject);
begin
  unselectAll;
end;


procedure TVlistCommand.FormCreate(Sender: TObject);
begin
  htext:=Ptexte.height;
  h0:=height;

  setTexte('');
end;

procedure TVlistCommand.setTexte(st:AnsiString);
begin
  Ptexte.caption:=st;
  if st='' then height:=h0-htext
           else height:=h0;
end;


procedure TVlistCommand.Newfile1Click(Sender: TObject);
begin
  SaveSelection(false);
end;

procedure TVlistCommand.Append1Click(Sender: TObject);
begin
  SaveSelection(true);
end;

procedure TVlistCommand.Copyselection1Click(Sender: TObject);
begin
  copySelection;
end;

Initialization
AffDebug('Initialization VLcommand',0);
{$IFDEF FPC}
{$I VLcommand.lrs}
{$ENDIF}
end.
