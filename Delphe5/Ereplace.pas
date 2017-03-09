unit Ereplace;

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
  TGEditReplace = class(TForm)
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
    Label2: TLabel;
    CBnew: TComboBox;
    CBprompt: TCheckBoxV;
    Ball: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function execution(var stName:AnsiString;var stHis:AnsiString;
                       var stNew:AnsiString;var stHisNew:AnsiString;
                       var Fcase,Fword,Fglobal,Fforward,FentireScope,
                       Fprompt:boolean):integer;
  end;

function GEditReplace: TGEditReplace;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FGEditReplace: TGEditReplace;

function GEditReplace: TGEditReplace;
begin
  if not assigned(FGEditReplace) then FGEditReplace:= TGEditReplace.create(nil);
  result:= FGEditReplace;
end;

function TGeditReplace.execution(var stName:AnsiString;var stHis:AnsiString;
                       var stNew:AnsiString;var stHisNew:AnsiString;
                       var Fcase,Fword,Fglobal,Fforward,FentireScope,
                       Fprompt:boolean):integer;
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

  with CBnew do
  begin
    st:=stHisNew;
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
    text:=stNew;
  end;


  CBcase.setvar(Fcase);
  CBwholeWord.setvar(Fword);
  CBprompt.setvar(Fprompt);

  RBglobal.checked:=Fglobal;
  RBselected.checked:=not Fglobal;

  RBforward.checked:=Fforward;
  RBbackward.checked:=not Fforward;

  RBEntireScope.checked:=FentireScope;
  RBfromCursor.checked:=not FentireScope;

  result:=showModal;
  if result<>mrCancel then
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
          if stHis<>'' then stHis:=stHis+'|';
          stHis:=stHis+st1;
        end;

      st1:=CBnew.text;

      k:=pos(st1,stHisNew);

      exist:=(k>0) and
             ( (k=1) or (stHisNew[k-1]='|') )
             and
             ( (k+length(st1)-1=length(stHisNew)) or (stHisNew[k+length(st1)]='|') );

      if not exist then
        begin
          if stHisNew<>'' then stHisNew:=stHisNew+'|';
          stHisNew:=stHisNew+st1;
        end;

      stName:=CBtext.text;
      stNew:=CBnew.text;
    end;
end;

procedure TGEditReplace.FormShow(Sender: TObject);
begin
  cbText.SetFocus;
end;

procedure TGEditReplace.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssAlt in Shift then
    case key of
      ord('T'),ord('t'): CBtext.SetFocus;
      ord('N'),ord('n'): CBNew.SetFocus;
    end;
end;

Initialization
AffDebug('Initialization Ereplace',0);
{$IFDEF FPC}
{$I Ereplace.lrs}
{$ENDIF}
end.
