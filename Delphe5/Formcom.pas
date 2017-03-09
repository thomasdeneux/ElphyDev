unit Formcom;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  util1;

type
  typeCommandP=procedure(num:integer) of object;

  TCommandForm = class(TForm)
    ListBox1: TListBox;
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations private }
    executeD:typeCommandP;
    width0:integer;
  public
    { Déclarations public }
    procedure Adjust(h:integer);
    procedure installe(list:TstringList;command:typeCommandP);
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TCommandForm.ListBox1Click(Sender: TObject);
begin
  if assigned(executeD)
    then executeD(TlistBox(sender).itemIndex+1);
end;

procedure TCommandForm.ListBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  res:integer;
begin
  res:=TlistBox(sender).itemIndex;
  case key of
    {VK_escape:close;}
    VK_return: if assigned(executeD)
                 then executeD(TlistBox(sender).itemIndex+1);
  end;
end;


procedure TCommandForm.Adjust(h:integer);
  var
    i,l,lmax,hmax:integer;
  begin
    lmax:=0;
    hmax:=0;
    canvas.font:=listBox1.font;
    with ListBox1,canvas do
    begin
      for i:=1 to items.Count do
        begin
          l:=textWidth(items[i-1]);
          if l>lmax then lmax:=l;
        end;
      hmax:=itemHeight*items.Count;
    end;
    if lmax>width0 then clientWidth:=lmax
                   else ClientWidth:=width0;
    if h=0 then ClientHeight:=hmax
           else ClientHeight:=h;
  end;

procedure TCommandForm.Installe(list:TstringList;command:typeCommandP);
  begin
    listBox1.items.assign(list);
    executeD:=command;
    adjust(0);
  end;


procedure TCommandForm.FormCreate(Sender: TObject);
begin
  width0:=width;
end;

Initialization
AffDebug('Initialization Formcom',0);
{$IFDEF FPC}
{$I Formcom.lrs}
{$ENDIF}
end.
