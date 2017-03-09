unit Zorder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  util1,stmDef,stmObj,stmobv0,HKpaint0;

type
  TgetZorder = class(TForm)
    GroupBox1: TGroupBox;
    LBstim: TListBox;
    BOK: TButton;
    ActiveAll: TButton;
    unActiveAll: TButton;
    procedure LBstimDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure SendBack(Sender: TObject);
    procedure BringFront(Sender: TObject);
    procedure LBstimMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
    Xcoche1,Xcoche2:integer;
  public
    { Déclarations publiques }
    procedure execution;
  end;

var
  getZorder: TgetZorder;

implementation

{$R *.DFM}

procedure TgetZorder.execution;
var
  i,k:integer;
  st:string;
begin
  with LBstim do
  begin
    clear;
    for i:=0 to HKpaint.count-1 do items.add('x');
  end;
  showModal;
end;

procedure TgetZorder.LBstimDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  rect1:Trect;
begin
  Xcoche1:=rect.right-rect.left-26;
  Xcoche2:=rect.right-rect.left-13;


  rect1:=rect;
  dec(rect1.right,26);

  with TlistBox(control) do
  begin
    with canvas do
    begin
      if Tresizable(HKpaint.items[index]).onControl then
        begin
          if odSelected in state
            then font.color:=clWhite else font.color:=clBlack;
          font.style:=[fsBold];
        end
      else
        begin
          if odSelected in state
            then font.color:=clWhite else font.color:=clGray;
          font.style:=[];
        end;

      textRect(rect1,rect1.left,rect1.top,typeUO(HKpaint.items[index]).ident);

      font.color:=clBlack;

      rect1.left:=rect1.right;
      inc(rect1.right,13);
      if odSelected in state then pen.color:=clWhite else pen.color:=clBlack;
      with rect1 do
      begin
        rectangle(left,top,right,bottom);
        if TypeUO(HKpaint.items[index]).onControl then
          begin
            moveto(left,top);
            lineto(right,bottom);
            moveto(right,top);
            lineto(left,bottom);
          end;
      end;

      rect1.left:=rect1.right;
      inc(rect1.right,13);
      if odSelected in state then pen.color:=clWhite else pen.color:=clBlack;
      with rect1 do
      begin
        rectangle(left,top,right,bottom);
        if TypeUO(HKpaint.items[index]).onScreen then
          begin
            moveto(left,top);
            lineto(right,bottom);
            moveto(right,top);
            lineto(left,bottom);
          end;
      end;


    end;
  end;
end;

procedure TgetZorder.LBstimMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  n:integer;
begin
  with TlistBox(sender) do
  begin
    if x<Xcoche1 then exit;
    n:=itemAtPos(point(x,y),false);
    if n<0 then exit;

    if (x<Xcoche2) then
      begin
        TypeUO(HKpaint.items[n]).onControl:=
              not TypeUO(HKpaint.items[n]).onControl;
        HKpaintPaint;
      end
    else
      begin
        TypeUO(HKpaint.items[n]).onScreen:=
               not TypeUO(HKpaint.items[n]).onScreen;
        SwitchPage(false);
      end;
    invalidate;
  end;
end;


procedure TgetZorder.SendBack(Sender: TObject);
var
  i,j:integer;
begin
  with LBstim do
  begin
    for i:=0 to items.count-1 do
      if selected[i] then
        begin
          for j:=i-1 downto 0 do selected[j+1]:=selected[j];
          selected[0]:=true;
          HKpaint.move(i,0);
        end;
    invalidate;
    switchPage(false);
    HKpaintPaint;
  end;
end;

procedure TgetZorder.BringFront(Sender: TObject);
var
  i,j:integer;
begin
  with LBstim do
  begin
    for i:=items.count-1 downto 0 do
      if selected[i] then
        begin
          HKpaint.move(i,HKpaint.count-1);
          for j:=i+1 to HKpaint.count-1 do selected[j-1]:=selected[j];
          selected[HKpaint.count-1]:=true;
        end;
    invalidate;
    switchPage(false);
    HKpaintPaint;
  end;
end;




end.
