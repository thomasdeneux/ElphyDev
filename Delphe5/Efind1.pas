unit Efind1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont,

  util1,debug0;

type
  TGEditFind = class(TForm)
    Label1: TLabel;
    CBtext: TComboBox;
    GroupBox1: TGroupBox;
    CBcase: TCheckBoxV;
    CBwholeWord: TCheckBoxV;
    GroupBox2: TGroupBox;
    RBglobal: TRadioButton;
    RBselected: TRadioButton;
    GroupBox3: TGroupBox;
    RBforward: TRadioButton;
    RBbackward: TRadioButton;
    GroupBox4: TGroupBox;
    RBfromCursor: TRadioButton;
    RBentireScope: TRadioButton;
    Bok: TButton;
    Bcancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function execution(stName:AnsiString;var stHis:AnsiString;
                        var Fcase,Fword,Fglobal,Fforward,FentireScope:boolean):AnsiString;
  end;


function GEditFind: TGEditFind;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FGEditFind: TGEditFind;

function GEditFind: TGEditFind;
begin
  if not assigned(FGEditFind) then FGEditFind:= TGEditFind.create(nil);
  result:= FGEditFind;
end;

function TGEditFind.execution(stName:AnsiString;var stHis:AnsiString;
                 var Fcase,Fword,Fglobal,Fforward,FentireScope:boolean):AnsiString;
var
  st1,st:AnsiString;
  k:integer;
  exist:boolean;
begin
  with CBtext do
  begin
    st:=stHis;
    items.clear;
    while st<>'' do
    begin
      k:=pos('|',st);
      if k>0 then
        begin
          items.add(copy(st,1,k-1));
          delete(st,1,k);
        end
      else
        begin
          items.add(st);
          st:='';
        end;
    end;
    text:=stName;
  end;

  CBcase.setvar(Fcase);
  CBwholeWord.setvar(Fword);

  RBglobal.checked:=Fglobal;
  RBselected.checked:=not Fglobal;

  RBforward.checked:=Fforward;
  RBbackward.checked:=not Fforward;

  RBEntireScope.checked:=FentireScope;
  RBfromCursor.checked:=not FentireScope;

  result:='';

  if showModal=mrOK then
    begin
      updateAllVar(self);

      Fglobal:=RBglobal.checked;
      Fforward:=RBforward.checked;
      FentireScope:=RBEntireScope.checked;

      st1:=CBtext.text;

      k:=pos(st1,stHis);

      exist:=(k>0) and
             ( (k=1) or (stHis[k-1]='|') )
             and
             ( (k+length(st1)-1=length(stHis)) or (stHis[k+length(st1)]='|') );

      if not exist then
        begin
          if stHis<>''
            then stHis:=st1+'|'+stHis
            else stHis:=st1;
        end;

      result:=st1;
    end;
end;

procedure TGEditFind.FormShow(Sender: TObject);
begin
  cbtext.SetFocus;
end;

procedure TGEditFind.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssAlt in Shift then
    case key of
      ord('T'),ord('t'): CBtext.SetFocus;
      
    end;
end;

Initialization
AffDebug('Initialization Efind1',0);
{$IFDEF FPC}
{$I Efind1.lrs}
{$ENDIF}
end.
