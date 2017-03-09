unit MFProp;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls,ExtCtrls,
  editcont,

  util1,Darbre0,Gdos,Ddosfich,formMenu,Dcur2fit,
  stmMF1,debug0;

type
  TMFuncProp = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Bvalidate: TButton;
    Bevaluate: TButton;
    Label3: TLabel;
    PanelResult: TPanel;
    Bsave: TButton;
    DrawGrid1: TDrawGrid;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    enXstart: TeditNum;
    enXend: TeditNum;
    enYstart: TeditNum;
    Bnew: TButton;
    Bload: TButton;
    Bchoose: TButton;
    Label18: TLabel;
    enYend: TeditNum;
    Label8: TLabel;
    enIstart: TeditNum;
    Label9: TLabel;
    enIend: TeditNum;
    Label19: TLabel;
    enJstart: TeditNum;
    Label20: TLabel;
    enJend: TeditNum;
    RB1: TCheckBoxV;
    RB2: TCheckBoxV;
    RB3: TCheckBoxV;
    RB4: TCheckBoxV;
    RB5: TCheckBoxV;
    RB6: TCheckBoxV;
    RB7: TCheckBoxV;
    RB8: TCheckBoxV;
    procedure drawgrid1SetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: string);
    procedure drawgrid1DrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure Bevaluateclick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RB1Click(Sender: TObject);
    procedure DrawGrid1TopLeftChanged(Sender: TObject);
    procedure BsaveClick(Sender: TObject);
    procedure LoadClick(Sender: TObject);
    procedure BchooseClick(Sender: TObject);
    procedure BvalidateClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  protected
    { Déclarations privées }
    owner0:TmatFunction;

    flagC:boolean;
    RB:array[1..8] of TcheckBoxV;
    Ninit,xpos,ypos:integer;

    FNum:array[1..20] of boolean;

    procedure updateVars;

  public
    { Déclarations publiques }
    stGen,stFich:AnsiString;

    procedure setLabel;

    procedure initBox( owner:TmatFunction);

    function execution(owner:TmatFunction):boolean;
  end;

function MFuncProp: TMFuncProp;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FMFuncProp: TMFuncProp;

function MFuncProp: TMFuncProp;
begin
  if not assigned(FMFuncProp) then FMFuncProp:= TMFuncProp.create(nil);
  result:= FMFuncProp;
end;

procedure TMFuncProp.setLabel;
var
  i:integer;
begin
  with owner0 do
  if numModel<=0
    then label1.caption:='Text:'
    else
      begin
        label1.caption:='Text (standard model '+Istr(numModel)+') :';
        numvar[1]:=1;
        numvar[2]:=2;
        fillchar(Fnum,sizeof(Fnum),0);
        Fnum[numvar[1]]:=true;
        Fnum[numvar[2]]:=true;
        for i:=1 to 8 do RB[i].setVar(Fnum[drawGrid1.topRow+i-1]);

      end;
end;

procedure TMFuncProp.initBox(owner:TmatFunction);
var
  i:integer;
begin
  owner0:=owner;

  flagC:=true;

  with owner0 do
  begin
    enXstart.setvar(x1f,t_extended);
    enXend.setvar(x2f,t_extended);
    enYstart.setvar(y1f,t_extended);
    enYend.setvar(y2f,t_extended);

    enIstart.setvar(i1f,t_longint);
    enIend.setvar(i2f,t_longint);
    enJstart.setvar(j1f,t_longint);
    enJend.setvar(j2f,t_longint);

    for i:=1 to 8 do RB[i].setVar(Fnum[drawGrid1.topRow+i-1]);

    memo1.text:=stTxt;
    setLabel;

    memo1.Enabled:=not FpgFunc;
    Bload.Enabled:=not FpgFunc;
    Bsave.Enabled:=not FpgFunc;
    Bchoose.Enabled:=not FpgFunc;
    Bnew.Enabled:=not FpgFunc;

  end;

  flagC:=false;
end;

function TMFuncProp.execution(owner:TmatFunction):boolean;
begin
   fillchar(Fnum,sizeof(Fnum),0);
   Fnum[owner.numvar[1]]:=true;
   Fnum[owner.numvar[2]]:=true;

   initBox(owner);
   showModal;

   updateVars;
end;

procedure TMFuncProp.updateVars;
var
  i,k:integer;
begin
  updateAllVar(self);

  with owner0 do
  begin
    sttxt:=memo1.text;
    k:=1;
    for i:=1 to 20 do
      begin
        if Fnum[i] and (k=1) then
          begin
            numvar[1]:=i;
            inc(k);
          end
        else
        if Fnum[i] and (k=2) then
          begin
            numvar[2]:=i;
            inc(k);
          end;
      end;
  end;
end;

procedure TMFuncProp.drawgrid1SetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: string);
var
  x:float;
  code:integer;
begin
  val(value,x,code);
  if (code=0) and (Acol<>0) then
    begin
      owner0.valeur[Arow+1]:=x;
    end;
end;

procedure TMFuncProp.drawgrid1DrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
var
  st:AnsiString;
  l:integer;
begin
  if (col=0) then
    drawgrid1.canvas.TextOut(rect.left+1,rect.top+1,owner0.nomvar[row+1] )
  else
    begin
      st:=Estr(owner0.valeur[row+1],3);
      l:=drawgrid1.canvas.TextWidth(st);
      drawgrid1.canvas.TextOut(rect.right-l-2,rect.top+1,st);
    end;

end;


procedure TMFuncProp.Bevaluateclick(Sender: TObject);
begin
  owner0.sttxt:=memo1.text;
  PanelResult.caption:=Estr(owner0.evaluate,3);
end;

procedure TMFuncProp.FormCreate(Sender: TObject);
begin
  RB[1]:=RB1;
  RB[2]:=RB2;
  RB[3]:=RB3;
  RB[4]:=RB4;
  RB[5]:=RB5;
  RB[6]:=RB6;
  RB[7]:=RB7;
  RB[8]:=RB8;

  stgen:='*.mdl';
end;

procedure TMFuncProp.RB1Click(Sender: TObject);
var
  i:integer;
begin
  if not FlagC then owner0.numModel:=0;
end;

procedure TMFuncProp.DrawGrid1TopLeftChanged(Sender: TObject);
var
  i:integer;
begin
  for i:=1 to 8 do RB[i].setVar(Fnum[drawGrid1.topRow+i-1]);
end;

const
  Header='DAC2 FUNCTION MODEL';

procedure TMFuncProp.BsaveClick(Sender: TObject);
var
  f:textFile;
  i:integer;
  st:AnsiString;
begin
  if owner0.FpgFunc then exit;

  if SauverFichierStandard(stFich,'mdl') then
    with owner0 do
    begin
      BvalidateClick(nil);
      try
      assignFile(f,stFich);
      rewrite(f);

      writeln(f,header);
      writeln(f,Istr(nbvar));
      for i:=1 to nbvar do
        begin
          str(valeur[i],st);
          writeln(f,st);
        end;
      for i:=0 to memo1.lines.count-1 do
        writeln(f,memo1.lines.strings[i]);
      closeFile(f);
      except
      {$I-}closeFile(f);{$I+}
      end;
    end;
end;

procedure TMFuncProp.LoadClick(Sender: TObject);
var
  f:textFile;

  st:AnsiString;
  i,n,code:integer;
  x:float;

begin
  if owner0.FpgFunc then exit;

  if choixFichierStandard(stGen,stFich,nil) then
    with owner0 do
    begin
      try
      assignFile(f,stFich);
      reset(f);
      memo1.clear;

      readln(f,st);
      if st=header then
        begin
          readln(f,st);
          val(st,n,code);
          if (code=0) and (n>0) and (n<maxvar) then
            begin
              nbvar:=n;
              for i:=1 to n do
                begin
                  readln(f,st);
                  val(st,x,code);
                  if code=0 then owner0.valeur[i]:=x;
                end;
            end;
        end;

      while not eof(f) do
      begin
        readln(f,st);
        memo1.lines.add(st);
      end;
      closeFile(f);
      BvalidateClick(nil);

      except
      {$I-}closeFile(f);{$I+}
      end;
    end;
end;

procedure TMFuncProp.BchooseClick(Sender: TObject);
var
  list:TstringList;
  i,n:integer;
  lig,col:integer;
begin
  list:=TstringList.create;
  for i:=1 to maxModele do
    with modeleFit(i) do list.add(id);
  n:=ShowMenu1(self,'Standard functions',list,Ninit,xpos,ypos);

  if n>0 then
    begin
      memo1.clear;
      memo1.lines.add('RES='+modeleFit(n).id);
      owner0.sttxt:=memo1.text;
      owner0.numModel:=n;
      setLabel;

      owner0.compiler1(lig,col);
      drawgrid1.invalidate;

    end;
  list.free;
end;

procedure TMFuncProp.BvalidateClick(Sender: TObject);
var
  lig,col,i,pc:integer;
begin
  updateVars;

  with owner0 do
  begin
    stTxt:=memo1.text;
    if not FpgFunc then
      begin
        if not compiler(lig,col) then
          begin
            messageCentral('Error in expression');

            pc:=0;
            for i:=0 to lig-1 do
              if i<memo1.lines.count then inc(pc,length(memo1.lines.strings[i])+2);
            pc:=pc+col;
            memo1.selStart:=pc-1;
          end
        else drawgrid1.invalidate;
      end
    else invalidate;
  end;
end;


procedure TMFuncProp.Memo1Change(Sender: TObject);
begin
  if FlagC then exit;
  owner0.numModel:=0;
  setLabel;

end;

Initialization
AffDebug('Initialization MFProp',0);
{$IFDEF FPC}
{$I MFProp.lrs}
{$ENDIF}
end.
