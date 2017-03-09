unit Dtbedit1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids,Menus,clipbrd,
  ExtCtrls, StdCtrls, editcont,Printers,

  util1,Ddosfich, Ncdef2,
  saveSS,getColN,nbLigne1,
  stmdef,stmObj,
  debug0,
  printSS;

const
  champParDefaut=12;
  setSep=[';',',',#9];


type
  TArrayEditor = class(TForm)
    DrawGrid1: TDrawGrid;
    Panel1: TPanel;
    LigCol: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    Edit1: TMenuItem;
    Select1: TMenuItem;
    Copy1: TMenuItem;
    Clear2: TMenuItem;
    Options1: TMenuItem;
    Clear1: TMenuItem;
    Font1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Numberoflines1: TMenuItem;
    Properties1: TMenuItem;
    paste1: TMenuItem;
    UseKvalue1: TMenuItem;
    ImmediateRefresh: TMenuItem;
    Refresh1: TMenuItem;
    Lselect: TLabel;
    Print1: TMenuItem;
    procedure DrawGrid1DrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure DrawGrid1SetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: String);
    procedure DrawGrid1SelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure Load1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Select1Click(Sender: TObject);
    procedure DrawGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ClearAll1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Suppress1Click(Sender: TObject);
    procedure Insertlines1Click(Sender: TObject);
    procedure Insertcolumns1Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure paste1Click(Sender: TObject);
    procedure DrawGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DrawGrid1DblClick(Sender: TObject);
    procedure UseKvalue1Click(Sender: TObject);
    procedure ImmediateRefreshClick(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Print1Click(Sender: TObject);

  private
    flagEndDrag:boolean;
  public
    colStart,ligStart,colEnd,ligEnd,nbligE,nbcolE:integer;
    nbDeci0:PtabOctet;

    showD:procedure (num:integer) of object;
    propertiesD:procedure  of object;

    getTabValue: function (i,j:integer):float of object;
    setTabValue: procedure (i,j:integer;x:float) of object;

    setColName: procedure (i:integer;st:AnsiString) of object;
    getColName: function (i:integer):AnsiString of object;

    clearData: procedure of object;
    DragVector: function(col:integer):boolean of object;

    invalidateCellD: procedure (col,row:integer) of object;
    invalidateVectorD: procedure (col:integer) of object;
    invalidateAllD: procedure  of object;

    setKvalueD: procedure (b:boolean) of object;
    DblClickRow0: procedure (col,x,y:integer) of object;

    Fimmediate:^boolean;


    UseDecimale:boolean;

    stFich,stGen: AnsiString;
    stHis:ThistoryList;
    SaveSep:char;
    SaveName:boolean;

    l1p:longint;          { valeurs à proposer lors d'une }
    l2p:longint;          { sauvegarde }
    c1p:longint;
    c2p:longint;

    PrintName:boolean;
    PrintInter:integer;
    PrintField:integer;
    PrintDeci:integer;

    PrintFont:Tfont;

    tabModifie:boolean;    {inefficace actuellement}

    Srect0:TgridRect;
    selRow,selCol,selAll:boolean;

    ExtendMode:boolean;

    lineNames:TstringList;

    function getTab(i,j:integer):float;
    procedure setTab(i,j:integer;x:float);
    property tab[i,j:integer]:float read getTab write setTab;

    function getNomCol(i:integer):AnsiString;
    procedure setNomCol(i:integer;st:AnsiString);
    property NomCol[i:integer]:AnsiString read getNomCol write setNomCol;

    procedure installe(i1,j1,i2,j2:integer;deci:pointer);
    procedure Modifydata(i1,j1,i2,j2:integer);

    procedure InvalidateLine(n:integer);
    procedure InvalidateIntCell(i,j:integer);

    procedure invalidateVector(i:integer);
    procedure invalidateCell(i,j:integer);
    procedure invalidateAll;

    procedure Xproposer(l1,l2,c1,c2:integer);

    function XchargerEntete(var f:Text):boolean;virtual;

    function XchargerData(var f:text;
                          ChargerNom:boolean;l1,c1:integer;
                          var l,c:integer;CharSep:setChar):boolean;
    function Xcharger(st:AnsiString;
                      ChargerNom:boolean;l1,c1:integer;
                      var l,c:integer;CharSep:setChar):boolean;

    function charger:boolean;

    procedure XsauverEntete(var f:Text);virtual;
    procedure XsauverData(var f:text;sauverNom:boolean;charSep:char);

    procedure NonZeroCells(var Im,Jm:integer);
    procedure cadrageSS(sender:Tobject);
    procedure Xsauver(st:AnsiString;sauverNom:boolean;charSep:char);
    procedure Sauver;
    function raz:boolean;
    procedure raz1;
    procedure cadrer(var l1,l2,c1,c2:integer);
    procedure FillTab(l1,l2,c1,c2:integer;x:float);
    procedure copyTab(l1,l2,c1,c2,l0,c0:integer);

    procedure installeNom;
    procedure RecalculeDimCell(oldL:integer);

    procedure deselecter;

    function NombreDeLignesNonNulles(col:integer):integer;

    procedure AdjustFormSize;virtual;

    procedure Xprint;

    procedure StringToLine(buf:AnsiString;num:integer);
  end;



implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}



procedure TArrayEditor.FormCreate(Sender: TObject);
var
  i:integer;
  st:AnsiString;
begin
  stFich:='';
  stGen:='*.tab';
  stHis:=ThistoryList.create(5);

  SaveSep:=#9;
  SaveName:=true;

  l1p:=1;
  l2p:=1;
  c1p:=1;
  c2p:=1;

  tabModifie:=false;
  UseDecimale:=true;

  PrintInter:=2;
  PrintField:=12;
  PrintDeci:=3;

  PrintFont:=Tfont.create;
  with PrintFont do
  begin
    name:='Courier New';
    Size:=8;
    style:=[];
  end;
end;

procedure TArrayEditor.FormDestroy(Sender: TObject);
begin
  stHis.free;
  PrintFont.free;
end;


procedure TArrayEditor.setTab(i,j:integer;x:float);
begin
  setTabValue(i,j,x);
end;

function TArrayEditor.getTab(i,j:integer):float;
begin
  result:=getTabValue(i,j);;
end;

function TArrayEditor.getNomCol(i:integer):AnsiString;
begin
  if assigned(getColName)
    then result:=getColName(i)
    else result:='';
end;

procedure TArrayEditor.setNomCol(i:integer;st:AnsiString);
begin
  if assigned(setColName) then setColName(i,st);
  invalidateIntCell(i,ligStart-1);
  invalidateVector(i);
end;

procedure TArrayEditor.RecalculeDimCell(oldL:integer);
var
  i,j:integer;
  newL:integer;
begin
  with drawGrid1 do
  begin
    newL:=canvas.TextWidth('0');
    for i:=1 to colCount-1 do
      ColWidths[i]:=(ColWidths[i]-2)*newL div oldL+2;

    DefaultRowHeight:=canvas.TextHeight('0')+2;
    {ligCol.Caption:=Istr(newL)+'/'+Istr(oldL);}
  end;
end;

procedure TArrayEditor.DrawGrid1DrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
var
  st:AnsiString;
  l,k:integer;
begin
  if (col=0) and (row>0) then
  begin
    if assigned(LineNames) then
    begin
      row:=row+ligStart-1;
      if (row>=1) and (row<=lineNames.Count)
        then drawGrid1.canvas.TextOut(rect.left+1,rect.top+1,lineNames[row-1]);
    end
    else drawGrid1.canvas.TextOut(rect.left+1,rect.top+1,Istr(row+ligStart-1))
  end
  else
  if (col>0) and (row=0) then
    begin
      k:=col+colStart-1;
      st:=nomCol[k];
      if st=''then st:=Istr(k);
        {else st:=Istr(k)+':'+st;}
      drawGrid1.canvas.TextOut(rect.left+1,rect.top+1,st);
    end
  else
  if (col>0) and (row>0) then
    begin
      if ExtendMode and (row=drawgrid1.RowCount-1) then st:=''
      else
      if UseDecimale
        then st:=Estr(tab[col+colStart-1,row+ligStart-1],nbDeci0^[col-1])
        else st:=Istr(roundL(tab[col+colStart-1,row+ligStart-1]));
      l:=drawGrid1.canvas.TextWidth(st);
      drawGrid1.canvas.TextOut(rect.right-l-2,rect.top+1,st);
    end;
end;


procedure TArrayEditor.DrawGrid1SetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: String);
var
  x:float;
  code:integer;
begin
  val(value,x,code);
  if (code=0) and (Acol>0) and (Acol<=nbcolE) and (Arow>0) and (Arow<=nbligE) then
    begin
      if ExtendMode and (Arow=nbligE) then
        begin
          drawgrid1.RowCount:=drawgrid1.RowCount+1;
          inc(nbligE);
          inc(ligEnd);
          invalidateLine(ligEnd-1);
        end;
      tab[Acol+colStart-1,Arow+ligStart-1]:=x;
      invalidateCell(Acol+colStart-1,Arow+ligStart-1);
    end;
end;


procedure TArrayEditor.DrawGrid1SelectCell(Sender: TObject; Col,
  Row: Longint; var CanSelect: Boolean);
begin
  LigCol.caption:=Istr(col+colStart-1)+'/'+Istr(row+ligStart-1);
end;

procedure TArrayEditor.installe(i1,j1,i2,j2:integer;deci:pointer);
  begin
    nbDeci0:=deci;

    colStart:=i1;
    colEnd:=i2;
    ligStart:=j1;
    ligEnd:=j2;

    nbligE:=ligEnd-ligStart+1;
    nbcolE:=colEnd-colStart+1;

    drawGrid1.rowCount:=nbligE+1;
    drawGrid1.colCount:=nbcolE+1;

    with drawGrid1 do
    begin
      DefaultColWidth:=canvas.TextWidth('0')*champParDefaut+2;
      DefaultRowHeight:=canvas.TextHeight('0')+2;
      ColWidths[0]:=canvas.TextWidth('000000')+2;
    end;
    ligCol.Caption:=Istr(colStart)+'/'+Istr(ligStart);
  end;

procedure TArrayEditor.Modifydata(i1,j1,i2,j2:integer);
  begin
    colStart:=i1;
    colEnd:=i2;
    ligStart:=j1;
    ligEnd:=j2;

    nbligE:=ligEnd-ligStart+1;
    nbcolE:=colEnd-colStart+1;

    drawGrid1.rowCount:=nbligE+1;
    drawGrid1.colCount:=nbcolE+1;

    drawGrid1.leftCol:=1;
    drawGrid1.topRow:=1;

    ligCol.Caption:=Istr(colStart)+'/'+Istr(ligStart);
    adjustFormSize;
  end;


procedure TArrayEditor.InvalidateLine(n:integer);
  var
    j:integer;
  begin
    for j:=drawGrid1.leftCol to drawGrid1.leftCol+drawGrid1.visibleColCount-1 do
      invalidateIntCell(n,j);
  end;

procedure TArrayEditor.InvalidateIntCell(i,j:integer);
  var
    rect:Trect;
  begin
    i:=i-colStart+1;
    j:=j-ligStart+1;
    rect:=drawGrid1.CellRect(i,j);
    invalidateRect(drawgrid1.handle,@rect,true);
  end;

procedure TArrayEditor.invalidateVector(i:integer);
begin
  if assigned(Fimmediate) and Fimmediate^ and assigned(invalidateVectorD)
    then invalidateVectorD(i);
end;

procedure TArrayEditor.invalidateCell(i,j:integer);
begin
  if assigned(Fimmediate) and Fimmediate^ and assigned(invalidateCellD)
    then invalidateCellD(i,j);
end;


procedure TArrayEditor.invalidateAll;
begin
  if assigned(Fimmediate) and Fimmediate^ and assigned(invalidateAllD)
    then invalidateAllD;
end;


procedure TarrayEditor.Xproposer(l1,l2,c1,c2:integer);
  begin
    l1p:=l1;
    l2p:=l2;
    c1p:=c1;
    c2p:=c2;
    if (l1<ligStart) or (l1>ligEnd) then l1p:=ligStart;
    if (l2<l1) or (l2>ligEnd) then l2p:=ligEnd;
    if (c1<colStart) or (c1>colEnd) then c1p:=colStart;
    if (c2<c1) or (c2>colEnd) then c2p:=colEnd;
  end;



function TarrayEditor.XchargerEntete(var f:text):boolean;
  begin
    XchargerEntete:=true;
  end;


function TarrayEditor.XchargerData(var f:Text;
                                  ChargerNom:boolean;l1,c1:integer;
                                  var l,c:integer;CharSep:setChar):boolean;
  var
    pc,error:integer;
    x:float;
    tp:typeLexBase;
    NomExiste:boolean;
    stMot:Ansistring;
    i:integer;
    fin:boolean;
    buf:AnsiString;

  begin
    result:=false;

    readln(f,buf);

    NomExiste:=false;
    for i:=1 to length(buf) do
       if (buf[i] in ['A'..'D','F'..'Z','a'..'d','f'..'z','"']) then
         nomExiste:=true;

    if chargerNom and NomExiste and (c1<=colEnd) then
      begin
        pc:=0;

        c:=c1;
        repeat
          lireUlexBase(buf,pc,stMot,tp,x,error,charSep);
          if (tp in [motB,chaineB]) and (stMot<>'') and (c<=nbcolE)
            then nomCol[c]:=stMot;
          inc(c);
        until (tp=finB) or (error<>0) or (c>colEnd);
        {messageCentral('finB='+Bstr(tp=finB)+' c='+Istr(c));}
        readln(f,buf);
      end;

    l:=l1-1;

    fin:=false;
    while (l<ligEnd) and not fin  do
    begin
      inc(l);
      pc:=0;
      c:=c1;

      repeat
        lireUlexBase(buf,pc,stMot,tp,x,error,charSep);

        if (c<=colEnd) then
          begin
            if tp=nombreB then tab[c,l]:=x
            else
            if tp<>finB then tab[c,l]:=0;
            {affdebug('Xcharger finB='+Bstr(tp=finB)+' c='+Istr(c)+' l='+Istr(l)+' x='+Estr(x,3));}
          end;
        inc(c);

      until (tp=finB) or (error<>0) or (c>colEnd);
      if c>colEnd then c:=colEnd;
       {affdebug('Xcharger finB='+Bstr(tp=finB)+' c='+Istr(c)+' error='+Istr(error));}
      fin:=eof(f);
      if not fin  then readln(f,buf);
    end;

  end;




function TarrayEditor.Xcharger(st:AnsiString;ChargerNom:boolean;l1,c1:integer;
                         var l,c:integer;CharSep:setChar):boolean;
  var
    f:TextFile;
    ok:boolean;
    j:integer;
  begin
    charSep:=charsep+[#9,';',' ',','];

    try
    assignFile(f,st);
    reset(f);

    XchargerEntete(f);
    XchargerData(f,ChargerNom,l1,c1,l,c,CharSep);
    closeFile(f);

    stfich:=st;
    installeNom;
    invalidateAll;
    tabModifie:=true;
    Xproposer(ligStart,l,colStart,c);
    result:=true;

    except
    {$I-}closeFile(f); {$I+}
    result:=false;
    end;
  end;

function TarrayEditor.charger:boolean;
  const
    tbTypeF:String[5]='ASCII';
  var
    x1,x2,x:boolean;
    i,j,l,c:integer;
  begin
    result:=false;
    if ChoixFichierStandard(stFich,stGen,stHis) then
      result:=Xcharger(stFich,true,ligStart,colStart,l,c,setSep);
  end;


procedure TarrayEditor.XsauverEntete(var f:text);
  begin
  end;

procedure TarrayEditor.XsauverData(var f:Text;sauverNom:boolean;charSep:char);
  var
    i,j:integer;
    stSep:string[1];
    st1:AnsiString;
  begin
    if charSep=' ' then stSep:=''
                   else stSep:=charSep;

    if sauverNom then
      begin
        for i:=c1p to c2p-1 do write(f,'"'+nomCol[i]+'"'+stSep);
        writeln(f,'"'+nomCol[c2p]+'"');
      end;
    for i:=l1p to l2p do
      begin
        for j:=c1p to c2p do
          begin
            st1:=chaineEtendu1(tab[j,i],champParDefaut,nbDeci0^[j-colStart]);
            if j<>c2p then st1:=st1+stSep;
            if stSep<>'' then st1:=Fsupespace(st1);
            write(f,st1);
          end;
        writeln(f,'');
      end;
  end;

procedure TarrayEditor.Xsauver(st:AnsiString;sauverNom:boolean;charSep:char);
var
  f:TextFile;
begin
  try
    assignFile(f,st);
    rewrite(f);

    XsauverEntete(f);
    XsauverData(f,sauverNom,charSep);

    closeFile(f);

  except
    sortieErreur('Error writing '+st);
    messageCentral('Error writing '+st);
  end;
end;

procedure TarrayEditor.NonZeroCells(var Im,Jm:integer);
var
  i,j:longint;
  x:float;
begin
  Im:=minEntierLong;
  Jm:=minEntierLong;
  for j:=ligStart to ligEnd do
    for i:=colStart to colEnd do
      begin
        x:=tab[i,j];
        if x<>0 then
          begin
            if i>Im then Im:=i;
            if j>Jm then Jm:=j;
          end;
      end;
end;


procedure TarrayEditor.cadrageSS(sender:Tobject);
begin
  c1p:=colStart;
  l1p:=ligStart;

  NonZeroCells(c2p,l2p);
end;


procedure TarrayEditor.sauver;
  var
    Vsep:byte;
  begin
    case SaveSep of
      ' ': Vsep:=1;
      #9 : Vsep:=2;
      ';': Vsep:=3;
      ',': Vsep:=4;
      else Vsep:=2;
    end;

    if SauverFichierStandard(stFich,'') then
      if ecraserFichier(stFich) then
        begin
          saveArray:=TsaveArray.create(self);
          with saveArray do
          begin
            FirstCol.setvar(c1p,T_longint);
            FirstCol.setMinMax(colStart,colEnd);

            LastCol.setvar(c2p,T_longint);
            LastCol.setMinMax(colStart,colEnd);

            FirstRow.setvar(l1p,T_longint);
            FirstRow.setMinMax(ligStart,ligEnd);

            LastRow.setvar(l2p,T_longint);
            LastRow.setMinMax(ligStart,ligEnd);

            comboSep.setVar(Vsep,T_byte,1);
            CheckBoxV1.setvar(SaveName);

            cadrerSS:=cadrageSS;

            if showModal=mrOk then
              begin
                case Vsep of
                  1: SaveSep:=' ';
                  2: SaveSep:=#9;
                  3: SAveSep:=';';
                  4: SAveSep:=',';
                end;

                Xsauver(stFich,SaveName,SaveSep);
              end;
          end;
          saveArray.free;
        end;
  end;

procedure TarrayEditor.cadrer(var l1,l2,c1,c2:integer);
  begin
    if l1<ligStart then l1:=ligStart
    else
    if l1>ligEnd then l1:=ligEnd;
    if l2<ligStart then l2:=ligStart
    else
    if l2>ligEnd then l2:=ligEnd;

    if c1<colStart then c1:=colStart
    else
    if c1>colEnd then c1:=colEnd;
    if c2<colStart then c2:=colStart
    else
    if c2>colEnd then c2:=colEnd;

  end;

procedure TarrayEditor.FillTab(l1,l2,c1,c2:integer;x:float);
  var
    i,j:integer;
  begin
    cadrer(l1,l2,c1,c2);
    for i:=c1 to c2 do
      for j:=l1 to l2 do
        tab[i,j]:=x;
  end;

procedure TarrayEditor.copyTab(l1,l2,c1,c2,l0,c0:integer);
  var
    i,j,nl,nc:integer;
  begin
    cadrer(l1,l2,c1,c2);
    if (c0<1) or (c0>nbcolE) or
       (l0<1) or (l0>nbligE) then exit;

    nc:=c2-c1+1;
    if nc>nbcolE-c0+1 then nc:=nbcolE-c0+1;
    nl:=l2-l1+1;
    if nl>nbligE-l0+1 then nl:=nbligE-l0+1;

    for i:=0 to nc-1 do
      begin
        for j:=0 to nl-1 do
          tab[c0+i,l0+j]:=tab[c1+i,l1+j];
      end;

     invalidateAll;
  end;


procedure TarrayEditor.raz1;
var
  i:integer;
begin
  if assigned(cleardata) then clearData;
  drawGrid1.refresh;
end;

function TarrayEditor.raz:boolean;
var
  i:integer;
begin
  if messageDlg('Clear all spreadsheet?',
                     mtConfirmation,[mbOk,mbCancel],0)=mrOK then
    begin
      raz1;
      raz:=true;
      invalidateAll;
    end
  else raz:=false;
end;

procedure TarrayEditor.InstalleNom;
  var
    stf:AnsiString;
  begin
    Caption:='Array editor: '+stFich;
  end;

procedure TArrayEditor.Load1Click(Sender: TObject);
begin
  if charger then drawGrid1.invalidate;
end;

procedure TArrayEditor.Save1Click(Sender: TObject);
begin
  sauver;
end;


procedure TArrayEditor.Font1Click(Sender: TObject);
var
  FontDialog:TfontDialog;
  oldL:integer;
begin
  oldL:=drawGrid1.canvas.TextWidth('0');

  FontDialog:=TFontDialog.create(self);
  FontDialog.font.assign(DrawGrid1.font);
  if FontDialog.execute then
    begin
      DrawGrid1.font.assign(FontDialog.font);
      Update;
      recalculeDimCell(oldL);
    end;
  FontDialog.free;
end;


procedure TArrayEditor.DrawGrid1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not (goEditing in drawGrid1.options) then
    begin
      drawGrid1.options:=drawGrid1.options+[goEditing];
      selRow:=false;
      selCol:=false;
      selAll:=false;
      Lselect.caption:='';
    end;

end;

procedure TArrayEditor.DrawGrid1DblClick(Sender: TObject);
var
  row1,col1:longint;
  rect:Trect;
  p,p1,p2,pgrid:Tpoint;
  st:Ansistring;
  res:integer;
begin
  p:=mouse.cursorPos;
  pgrid:=drawgrid1.ScreenToClient(p);

  drawGrid1.mouseToCell(pgrid.x,pgrid.y,col1,row1);

  if (col1>0) and (row1=0) then
    begin

      rect:=drawGrid1.cellRect(col1,row1);

      p1.x:=rect.left;
      p1.y:=rect.top;
      p1:=clientToScreen(p1);

      p2.x:=rect.right;
      p2.y:=rect.bottom;
      p2:=clientToScreen(p2);

      {messageCentral(Istr(p.x)+' '+Istr(p1.x)+' '+Istr(p2.x) );}

      if (p.x<p1.x+5) or (p.x>p2.x-5) then exit;

      inc(p1.y,25);

      if p1.x+GetColParams.width>screen.desktopwidth
        then p1.x:=screen.desktopwidth-GetColParams.width;

      if assigned(DblClickRow0) then
        begin
          DblClickRow0(col1,p1.x,p1.y);
          FlagEndDrag:=true;
          exit;
        end;

      GetColParams.top:=p1.y;
      GetColParams.left:=p1.x;

      st:=nomcol[col1+colStart-1];
      res:=GetColParams.execution(st,nbDeci0^[col1-1]);
      if res<>0 then
        case res of
          101:begin
                nomcol[col1+colStart-1]:=st;
                drawGrid1.invalidate;
                invalidateVector(col1+colStart-1);
              end;
          102:if assigned(showD) then showD(col1+colStart-1);
        end;
    end;

  FlagEndDrag:=true;
end;


procedure TArrayEditor.Select1Click(Sender: TObject);
begin
  drawGrid1.options:=drawGrid1.options-[goEditing];
  Lselect.caption:='Select';
end;

procedure TArrayEditor.DrawGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  row1,col1:longint;
begin
  if not (goEditing in drawGrid1.options) then
    begin
      drawGrid1.mouseToCell(x,y,col1,row1);
      if (col1=0) and (row1>0) then
        begin
          selRow:=true;

          SRect0.Top := row1;
          SRect0.Left := 1;
          SRect0.Bottom := row1;
          SRect0.Right := drawGrid1.colCount-1;
          drawGrid1.Selection := SRect0;
        end
      else
      if (row1=0) and (col1>0) then
        begin
          selCol:=true;

          SRect0.Top := 1;
          SRect0.Left := col1;
          SRect0.Bottom := drawGrid1.rowCount-1;
          SRect0.Right := col1;
          drawGrid1.Selection := SRect0;
        end
      else
      if (row1=0) and (col1=0) then
        begin
          selAll:=true;

          SRect0.Top := 1;
          SRect0.Left := 1;
          SRect0.Bottom := drawGrid1.rowCount-1;
          SRect0.Right := drawGrid1.colCount-1;
          drawGrid1.Selection := SRect0;
        end;
    end
  else
  if not FlagEndDrag then
    begin
      drawGrid1.mouseToCell(x,y,col1,row1);
      if (row1=0) and (col1>0) and assigned(DragVector) then
        begin
          if DragVector(col1-colStart+1)
            then drawgrid1.beginDrag(false);
        end;

    end
  else FlagEndDrag:=false;

end;

procedure TArrayEditor.DrawGrid1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  row1,col1:longint;
  SRect: TGridRect;
begin
  drawGrid1.mouseToCell(x,y,col1,row1);

  if selRow then
    begin
      if col1<>0 then
        begin
          Deselecter;
          selRow:=false;
          exit;
        end;
      if row1<SRect0.Top then Srect0.top:= row1;
      SRect0.Left := 1;
      if row1>SRect0.Bottom then Srect0.bottom:= row1;
      SRect0.Right := drawGrid1.colCount-1;
      drawGrid1.Selection := SRect0;
    end
  else
  if selCol then
    begin
      if row1<>0 then
        begin
          Deselecter;
          selCol:=false;
          exit;
        end;
      if col1>SRect0.right then Srect0.right:= col1;
      SRect0.top := 1;
      if col1<SRect0.left then Srect0.left:= col1;
      SRect0.bottom := drawGrid1.rowCount-1;
      drawGrid1.Selection := SRect0;
    end;

end;

procedure TarrayEditor.deselecter;
begin
  fillChar(Srect0,sizeof(Srect0),0);
  drawGrid1.selection:=Srect0;
end;


procedure TArrayEditor.Clear1Click(Sender: TObject);
begin
  with {sel0}drawGrid1.selection do
  fillTab(top+ligStart-1,bottom+ligStart-1,left+colStart-1,right+colStart-1,0);
  drawGrid1.invalidate;
end;

procedure TArrayEditor.ClearAll1Click(Sender: TObject);
begin
  if Raz then drawGrid1.invalidate;
end;

function valeur(x:float):AnsiString;
var
  st:string[25];
begin
  str(x,st);
  supespace(st);
  result:=st;
end;


procedure TArrayEditor.Copy1Click(Sender: TObject);
var
  buf:String;
  i,j:integer;
begin
  buf:='';
  with drawGrid1.selection do
  begin
    for i:=top+ligStart-1 to bottom+ligStart-1 do
      begin
        for j:=left+colStart-1 to right+colStart-1-1 do buf:=buf+valeur(tab[j,i])+#9;
        buf :=buf+valeur(tab[right+colStart-1,i])+#13+#10;
      end;
    clipboard.setTextBuf(pchar(buf));
  end;
end;


procedure TArrayEditor.Suppress1Click(Sender: TObject);
var
  i,n:integer;
begin
  with drawGrid1.selection do
  begin
    if (top=1) and (bottom=drawGrid1.rowCount-1) then
      begin
        {supprimerColonnes(left,right-left+1);}
        n:=right-left+1;
        invalidateAll;
      end
    else
    if (left=1) and (right=drawGrid1.ColCount-1) then
      begin
        {supprimerLignes(top,bottom-top+1);}
        invalidateAll;
      end
    else exit;

    drawGrid1.invalidate;
  end;
end;

procedure TArrayEditor.Insertlines1Click(Sender: TObject);
begin
  if not (goEditing in drawGrid1.options) then exit;

  {insererLignes(drawGrid1.selection.top,1);}
  drawGrid1.invalidate;
end;

procedure TArrayEditor.Insertcolumns1Click(Sender: TObject);
begin
  if not (goEditing in drawGrid1.options) then exit;

  {insererColonnes(drawGrid1.selection.left,1);}
  drawGrid1.invalidate;
end;


function TArrayEditor.NombreDeLignesNonNulles(col:integer):integer;
var
  i:integer;
begin
  result:=0;
  {
  with getvec(col) do
  begin
    i:=nbligE;
    while (i>=Istart) and (Yvalue[i]=0) do dec(i);
  end;
  result:=i;
  }
end;


procedure TArrayEditor.Properties1Click(Sender: TObject);
begin
  if assigned(propertiesD) then propertiesD;
end;


procedure TArrayEditor.paste1Click(Sender: TObject);
var
  w:integer;
  buf:ptabChar;
  st:AnsiString;
  p,l,c:integer;
  x:float;
  code:integer;
  cmin,cmax,lmin,lmax:integer;

  procedure ranger;
  var
    l0,c0,l1,c1:integer;
  begin
    l0:=drawGrid1.row+l;
    c0:=drawGrid1.col+c;
    l1:=l0-ligStart;
    c1:=c0-colStart;
    if (l1>=ligStart) and (l1<=ligEnd) and (c1>=colStart) and (c1<=colEnd) then
      begin
        tab[c1,l1]:=x;
        if c0<cmin then cmin:=c0;
        if c0>cmax then cmax:=c0;
        if l0<lmin then lmin:=l0;
        if l0>lmax then lmax:=l0;
      end;
  end;

begin
  with clipboard do
  begin
    if not hasFormat(cf_text) then exit;
    w:=10000;
    getmem(buf,w+1);
    fillchar(buf^,w+1,0);
    clipBoard.getTextBuf(pchar(buf),w);
  end;

  cmin:=nbcolE;
  cmax:=0;
  lmin:=nbligE;
  lmax:=0;

  p:=-1;
  l:=1;
  c:=1;
  st:='';

  while p<w do
  begin
    inc(p);
    case buf^[p] of
      #13: begin
             val(st,x,code);
             if code=0 then ranger;
             inc(l);
             c:=1;
             st:='';
           end;
      #9:  begin
             val(st,x,code);
             if code=0 then ranger;
             inc(c);
             st:='';
           end;

      else
      if buf^[p] <>#10 then st:=st+buf^[p];
    end;
  end;
  drawGrid1.invalidate;
  SRect0.Top := lmin;
  SRect0.Left := cmin;
  SRect0.Bottom := lmax;
  SRect0.Right := cmax;
  drawGrid1.Selection := SRect0;
end;


procedure TArrayEditor.DrawGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift=[ssCtrl] then
    case key of
      ord('C'): copy1Click(self);
      ord('V'): paste1Click(self);
    end;
end;

procedure TArrayEditor.AdjustFormSize;
var
  w,h,dw,dh:integer;
begin
  with drawGrid1 do
  begin
    w:=gridWidth;
    h:=gridHeight+panel1.height;
  end;

  dw:=clientWidth-w-2;
  dh:=clientHeight-h-2;

  if (dw>0) or (dh>0) then setBounds(left,top,width-dw+20,height-dh+20);
  {En mettant les dimensions exactes, les scrollbars apparaissent quand même.
    Génant}
  drawgrid1.invalidate;
end;


procedure TArrayEditor.UseKvalue1Click(Sender: TObject);
begin
  UseKvalue1.Checked:=not UseKvalue1.Checked;
  if assigned(setKvalueD) then
    begin
      setKvalueD(UseKvalue1.Checked);
      drawGrid1.invalidate;
    end;
end;

procedure TArrayEditor.ImmediateRefreshClick(Sender: TObject);
begin
   if assigned(Fimmediate) then
     begin
       immediateRefresh.checked:=not immediateRefresh.checked;
       Fimmediate^:=immediateRefresh.checked;
     end;
end;

procedure TArrayEditor.Options1Click(Sender: TObject);
begin
  if assigned(Fimmediate) then immediateRefresh.checked:=Fimmediate^;
end;

procedure TArrayEditor.Refresh1Click(Sender: TObject);
begin
  if assigned(invalidateAllD) then invalidateAllD;
end;


procedure TArrayEditor.XPrint;
var
  f: TextFile;
  i,j:integer;
  st:AnsiString;
  stSep:AnsiString;
begin
{$IFNDEF FPC }
  AssignPrn(f);
  Rewrite(f);

  printer.canvas.Font.Assign(PrintFont);

  stSep:='';
  for i:=1 to PrintInter do stSep:=stSep+' ';

  if PrintName then
    begin
      st:='';
      for j:=c1p to c2p do
      begin
        st:=st+Jgauche(nomCol[j],PrintField);
        if j<>c2p then st:=st+stSep;
      end;
      writeln(f,st);
    end;

  for i:=l1p to l2p do
    begin
      st:='';
      for j:=c1p to c2p do
        begin
          st:=st+chaineEtendu(tab[j,i],PrintField,PrintDeci);
          if j<>c2p then st:=st+stSep;
        end;
      writeln(f,st);
    end;

  CloseFile(f);

{$ENDIF}
end;



procedure TArrayEditor.Print1Click(Sender: TObject);
var
  PrintArray:TPrintArray;
begin
  PrintArray:=TPrintArray.create(self);
  Try
  with PrintArray do
  begin
    FirstCol.setvar(c1p,T_longint);
    FirstCol.setMinMax(colStart,colEnd);

    LastCol.setvar(c2p,T_longint);
    LastCol.setMinMax(colStart,colEnd);

    FirstRow.setvar(l1p,T_longint);
    FirstRow.setMinMax(ligStart,ligEnd);

    LastRow.setvar(l2p,T_longint);
    LastRow.setMinMax(ligStart,ligEnd);

    enInterval.setVar(PrintInter,T_longint);
    enField.setVar(PrintField,T_longint);
    enDeci.setVar(PrintDeci,T_longint);

    CbNames.setvar(PrintName);

    cadrerSS:=cadrageSS;
    adFont:=@PrintFont;

    if showModal=mrOk then XPrint;

  end;
  Finally
  PrintArray.free;
  end;
end;

procedure TarrayEditor.StringToLine(buf:AnsiString;num:integer);
var
  pc,error:integer;
  x:float;
  tp:typeLexBase;
  stMot:Ansistring;
  c:integer;
  charSep:setChar;
begin
  charSep:=[#9,';',' ',','];
  pc:=0;
  c:=1;

  repeat
    lireUlexBase(buf,pc,stMot,tp,x,error,charSep);

    if (c<=colEnd) then
      begin
        if tp=nombreB then tab[c,num]:=x
        else
        if tp<>finB then tab[c,num]:=0;
      end;
    inc(c);

  until (tp=finB) or (error<>0) or (c>colEnd);
end;



Initialization
AffDebug('Initialization DtbEdit1',0);
{$IFDEF FPC}
{$I Dtbedit1.lrs}
{$ENDIF}
end.
