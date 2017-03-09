unit FuncProp;

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

  util1,Gdos,Ddosfich,formMenu,Dcurfit0,stmFunc1,debug0;

type
  TFunctionProp = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Bcompile: TButton;
    Bvalidate: TButton;
    Label3: TLabel;
    PanelResult: TPanel;
    Bsave: TButton;
    DrawGrid1: TDrawGrid;
    RB1: TRadioButton;
    RB2: TRadioButton;
    RB3: TRadioButton;
    RB4: TRadioButton;
    RB5: TRadioButton;
    RB6: TRadioButton;
    RB7: TRadioButton;
    RB8: TRadioButton;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    editNum1: TeditNum;
    editNum2: TeditNum;
    editNum3: TeditNum;
    Bnew: TButton;
    Bload: TButton;
    Bchoose: TButton;
    Label18: TLabel;
    editNum4: TeditNum;
    Label8: TLabel;
    editNum5: TeditNum;
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
    procedure BcompileClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  protected
    { Déclarations privées }
    owner0:Tfunction;

    flagC:boolean;
    RB:array[1..8] of TRadioButton;
    Ninit,xpos,ypos:integer;

    procedure CheckNumVar;virtual;
  public
    { Déclarations publiques }
    stGen,stFich:AnsiString;

    procedure setLabel;

    procedure initBox(func:Tfunction);

    function execution(func:Tfunction):boolean;
  end;

function FunctionProp: TFunctionProp;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FFunctionProp: TFunctionProp;

function FunctionProp: TFunctionProp;
begin
  if not assigned(FFunctionProp) then FFunctionProp:= TFunctionProp.create(nil);
  result:= FFunctionProp;
end;

procedure TFunctionProp.setLabel;
begin
  with owner0 do
  if numModel<=0
    then label1.caption:='Text:'
    else
      begin
        label1.caption:='Text (standard model '+Istr(numModel)+') :';
        numvar:=1;
      end;
end;

procedure TFunctionProp.initBox(func:Tfunction);
begin
  with func do
  begin
    flagC:=true;
    CheckNumVar;

    editNum1.setvar(x1f,t_extended);
    editNum2.setvar(x2f,t_extended);
    editNum3.setvar(i1f,t_longint);
    editNum4.setvar(i2f,t_longint);

    editNum5.setvar(xOrg,t_extended);

    memo1.text:=stTxt;
    setLabel;

    memo1.Enabled:=not FpgFunc;
    Bload.Enabled:=not FpgFunc;
    Bsave.Enabled:=not FpgFunc;
    Bchoose.Enabled:=not FpgFunc;
    Bnew.Enabled:=not FpgFunc;

    flagC:=false;
  end;
end;

function TFunctionProp.execution(func:Tfunction):boolean;
begin
  owner0:=func;
  initBox(func);

  
  showModal;
end;


procedure TFunctionProp.CheckNumVar;
var
  i,n:integer;
begin
  with owner0 do
  begin
    n:=numvar-drawGrid1.topRow;
    if (n>=1) and (n<=8) then RB[n].checked:=true
    else
    for i:=1 to 8 do RB[i].checked:=false;
  end;
end;


procedure TFunctionProp.drawgrid1SetEditText(Sender: TObject; ACol,
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

procedure TFunctionProp.drawgrid1DrawCell(Sender: TObject; Col,
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


procedure TFunctionProp.Bevaluateclick(Sender: TObject);
begin
   owner0.stTxt:=memo1.text;
   PanelResult.caption:=Estr(owner0.evaluate,3);
end;

procedure TFunctionProp.FormCreate(Sender: TObject);
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

procedure TFunctionProp.RB1Click(Sender: TObject);
begin
  owner0.numvar:=drawGrid1.topRow+TradioButton(sender).tag;
  if not FlagC then owner0.numModel:=0;
end;

procedure TFunctionProp.DrawGrid1TopLeftChanged(Sender: TObject);
begin
  checknumvar;
end;

const
  Header='DAC2 FUNCTION MODEL';

procedure TFunctionProp.BsaveClick(Sender: TObject);
var
  f:textFile;
  i:integer;
  st:AnsiString;
begin
  if SauverFichierStandard(stFich,'mdl') then
    with owner0 do
    begin
      BcompileClick(nil);
      try
      assignFile(f,stFich);
      rewrite(f);

      writeln(f,header);
      writeln(f,Istr(Nomvar.count));
      for i:=0 to Nomvar.Count-1 do
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

procedure TFunctionProp.LoadClick(Sender: TObject);
var
  f:textFile;

  st:AnsiString;
  i,n,code:integer;
  x:float;

begin
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
          if (code=0) and (n>0){ and (n<maxvar)} then
            begin
              nbvar:=n;
              for i:=1 to n do
                begin
                  readln(f,st);
                  val(st,x,code);
                  if code=0 then valeur[i]:=x;
                end;
            end;
        end;

      while not eof(f) do
      begin
        readln(f,st);
        memo1.lines.add(st);
      end;
      closeFile(f);
      BcompileClick(nil);
      except
      {$I-}closeFile(f);{$I+}
      end;
    end;
end;

procedure TFunctionProp.BchooseClick(Sender: TObject);
var
  list:TstringList;
  i,n:integer;
  lig,col:integer;
begin
  list:=TstringList.create;
  for i:=1 to maxModele do
    with modeleFit(i)^ do list.add(id);
  n:=ShowMenu1(self,'Standard functions',list,Ninit,xpos,ypos);

  if n>0 then
    with owner0 do
    begin
      memo1.clear;
      memo1.lines.add('RES='+modeleFit(n)^.id);
      stTxt:=memo1.text;
      numModel:=n;
      setLabel;

      owner0.compiler(lig,col);
      drawgrid1.invalidate;
    end;
  list.free;
end;

procedure TFunctionProp.BcompileClick(Sender: TObject);
var
  lig,col,i,pc:integer;
begin
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


procedure TFunctionProp.Memo1Change(Sender: TObject);
begin
  if FlagC then exit;
  owner0.numModel:=0;
  setLabel;
end;

Initialization
AffDebug('Initialization FuncProp',0);
{$IFDEF FPC}
{$I FuncProp.lrs}
{$ENDIF}
end.
