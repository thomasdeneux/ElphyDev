unit DtbEdit2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, Menus, clipbrd,
  ExtCtrls, StdCtrls, editcont,Printers,

  util1,Ddosfich,NcDef2,
  saveSS,getColN,nbLigne1,
  debug0,
  printSS, FrameTable1;

const
  champParDefaut=12;
  setSep=[';',',',#9];


type
  TTableEdit = class(TForm)
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
    Properties1: TMenuItem;
    paste1: TMenuItem;
    UseKvalue1: TMenuItem;
    ImmediateRefresh: TMenuItem;
    Refresh1: TMenuItem;
    Lselect: TLabel;
    Print1: TMenuItem;
    TableFrame1: TTableFrame;
    procedure FormCreate(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure ClearAll1Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure UseKvalue1Click(Sender: TObject);
    procedure ImmediateRefreshClick(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Select1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure paste1Click(Sender: TObject);
    procedure Clear2Click(Sender: TObject);

  private
    Lab:TlabelCell;
    cellNum:TeditNumCell;

    function getCell(ACol, ARow: Integer):Tcell;
    function getE(Acol,Arow:integer):float;
    procedure setE(Acol,Arow:integer;x:float);

    procedure SelectCell(Col,Row: integer);

  public
    colStart,ligStart,colEnd,ligEnd,nbligE,nbcolE:integer;

    {Toutes ces variables peuvent être non affectées sauf getTabValue }
    showD:procedure (num:integer) of object;
    propertiesD:procedure  of object;

    getTabValue: function (i,j:integer):float of object;
    setTabValue: procedure (i,j:integer;x:float) of object;

    getDeciValue: function (j:integer):integer of object;
    setDeciValue: procedure (j:integer;x:integer) of object;


    getColName: function (i:integer):AnsiString of object;
    setColName: procedure (i:integer;st:AnsiString) of object;

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
    SaveSep: AnsiChar;
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


    selRow,selCol,selAll:boolean;

    ExtendMode:boolean;

    lineNames:TstringList;

    function getTab(i,j:integer):float;
    procedure setTab(i,j:integer;x:float);
    property tab[i,j:integer]:float read getTab write setTab;

    function getDeci(j:integer):integer;
    procedure setDeci(j:integer;x:integer);
    property deci0[j:integer]:integer read getDeci write setDeci;

    function getNomCol(i:integer):AnsiString;
    procedure setNomCol(i:integer;st:AnsiString);
    property NomCol[i:integer]:AnsiString read getNomCol write setNomCol;

    procedure installe(i1,j1,i2,j2:integer);
    procedure Modifydata(i1,j1,i2,j2:integer);


    procedure invalidateVector(i:integer);
    procedure invalidateCell(i,j:integer);
    procedure invalidateAll;

    procedure Xproposer(l1,l2,c1,c2:integer);

    function XchargerEntete(var f:Text):boolean;virtual;

    procedure XchargerData(var f:text;
                          ChargerNom:boolean;l1,c1:integer;
                          var l,c:integer;CharSep:setChar);
    function Xcharger(st:AnsiString;
                      ChargerNom:boolean;l1,c1:integer;
                      var l,c:integer;CharSep:setChar):boolean;

    function charger:boolean;

    procedure XsauverEntete(var f:Text);virtual;
    procedure XsauverData(var f:text;sauverNom:boolean;charSep:Ansichar);

    procedure NonZeroCells(var Im,Jm:integer);
    procedure cadrageSS(sender:Tobject);
    procedure Xsauver(st:AnsiString;sauverNom:boolean;charSep:AnsiChar);
    procedure Sauver;
    function raz:boolean;
    procedure raz1;
    procedure cadrer(var l1,l2,c1,c2:integer);
    procedure FillTab(l1,l2,c1,c2:integer;x:float);
    procedure copyTab(l1,l2,c1,c2,l0,c0:integer);

    procedure RecalculeDimCell(oldL:integer);

    procedure deselecter;

    function NombreDeLignesNonNulles(col:integer):integer;

    procedure AdjustFormSize;virtual;

    procedure Xprint;

    procedure StringToLine(buf:AnsiString;num:integer);
    procedure CellDblClick(rectCell:Trect;col1,row1:integer);

    procedure invalidate;override;
  end;



implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}



procedure TTableEdit.FormCreate(Sender: TObject);
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

  lab:=TlabelCell.create(tableFrame1);

  cellNum:=TeditNumCell.create(tableFrame1);
  cellNum.tpNum:=g_extended;

end;

procedure TTableEdit.FormDestroy(Sender: TObject);
begin
  stHis.free;
  PrintFont.free;
end;


procedure TTableEdit.setTab(i,j:integer;x:float);
begin
  if assigned(setTabValue) then setTabValue(i,j,x);
end;

function TTableEdit.getTab(i,j:integer):float;
begin
  result:=getTabValue(i,j);;
end;

procedure TTableEdit.setDeci(j:integer;x:integer);
begin
  if assigned(setDeciValue) then setDeciValue(j,x);
end;

function TTableEdit.getDeci(j:integer):integer;
begin
  if assigned(getDeciValue)
    then result:=getDeciValue(j)
    else result:=3;
end;


function TTableEdit.getNomCol(i:integer):AnsiString;
begin
  if assigned(getColName)
    then result:=getColName(i)
    else result:='';
end;

procedure TTableEdit.setNomCol(i:integer;st:AnsiString);
begin
  if assigned(setColName) then setColName(i,st);
  invalidateVector(i);
end;

procedure TTableEdit.RecalculeDimCell(oldL:integer);
var
  i,j:integer;
  newL:integer;
begin
  with tableFrame1.drawGrid1 do
  begin
    newL:=canvas.TextWidth('0');
    for i:=1 to colCount-1 do
      ColWidths[i]:=(ColWidths[i]-2)*newL div oldL+2;

    DefaultRowHeight:=canvas.TextHeight('0')+2;
    {ligCol.Caption:=Istr(newL)+'/'+Istr(oldL);}
  end;
end;

procedure TTableEdit.SelectCell(Col,Row: integer);
begin
  LigCol.caption:=Istr(col+colStart-1)+'/'+Istr(row+ligStart-1) ;
end;

function TTableEdit.getE(Acol,Arow:integer):float;
begin
  result:=tab[Acol+colStart-1,Arow+ligStart-1];
end;

procedure TTableEdit.setE(Acol,Arow:integer;x:float);
begin
  tab[Acol+colStart-1,Arow+ligStart-1]:=x;
end;

function TTableEdit.getCell(ACol, ARow: Integer): Tcell;
var
  k:integer;
begin
  result:=nil;

  if (Acol=0) and (Arow>0) then
  begin
    result:=lab;
    Arow:=Arow+ligStart-1;
    if assigned(LineNames) then
    begin
      if (Arow>=1) and (Arow<=lineNames.Count)
        then lab.st:=lineNames[Arow-1];
    end
    else lab.st:=Istr(Arow);
  end
  else
  if (Acol>0) and (Arow=0) then
  begin
    result:=lab;
    k:=Acol+colStart-1;
    lab.st:=nomCol[k];
    if lab.st='' then lab.st:=Istr(k);
  end
  else
  if (Acol>0) and (Arow>0) then
  begin
    result:=CellNum;
    CellNum.nbDeci:=deci0[ColStart+Acol-1];
    Cellnum.setExy:=setE;
    Cellnum.getExy:=getE;
  end;
end;



procedure TTableEdit.installe(i1,j1,i2,j2:integer);
  begin

    colStart:=i1;
    colEnd:=i2;
    ligStart:=j1;
    ligEnd:=j2;

    nbligE:=ligEnd-ligStart+1;
    nbcolE:=colEnd-colStart+1;

    tableFrame1.init(nbColE+1,nbligE+1,1,1,getCell);


    with tableFrame1.drawGrid1 do
    begin
    {$IFNDEF FPC}
      DefaultColWidth:=canvas.TextWidth('0')*champParDefaut+2;
      DefaultRowHeight:=canvas.TextHeight('0')+2;
      ColWidths[0]:=canvas.TextWidth('000000000')+2; // 9 caractères
    {$ENDIF}
    end;

    tableFrame1.onSelectCell:=selectCell;
    tableFrame1.OnDblClickCell:=CellDblClick;

    ligCol.Caption:=Istr(colStart)+'/'+Istr(ligStart);
    
  end;

procedure TTableEdit.Modifydata(i1,j1,i2,j2:integer);
  begin
    colStart:=i1;
    colEnd:=i2;
    ligStart:=j1;
    ligEnd:=j2;

    nbligE:=ligEnd-ligStart+1;
    nbcolE:=colEnd-colStart+1;

    tableFrame1.init(nbColE+1,nbligE+1,1,1,getCell);

    ligCol.Caption:=Istr(colStart)+'/'+Istr(ligStart);
    adjustFormSize;
  end;



procedure TTableEdit.invalidateVector(i:integer);
begin
  if assigned(Fimmediate) and Fimmediate^ and assigned(invalidateVectorD)
    then invalidateVectorD(i);
end;

procedure TTableEdit.invalidateCell(i,j:integer);
begin
  if assigned(Fimmediate) and Fimmediate^ and assigned(invalidateCellD)
    then invalidateCellD(i,j);
end;


procedure TTableEdit.invalidateAll;
begin
  tableFrame1.invalidate;
  if assigned(Fimmediate) and Fimmediate^ and assigned(invalidateAllD)
    then invalidateAllD;
end;


procedure TTableEdit.Xproposer(l1,l2,c1,c2:integer);
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



function TTableEdit.XchargerEntete(var f:text):boolean;
  begin
    XchargerEntete:=true;
  end;


procedure TTableEdit.XchargerData(var f:Text;
                                  ChargerNom:boolean;l1,c1:integer;
                                  var l,c:integer;CharSep:setChar);
  var
    pc,error:integer;
    x:float;
    tp:typeLexBase;
    NomExiste:boolean;
    stMot:AnsiString;
    i:integer;
    fin:boolean;
    buf:AnsiString;

  begin

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
      if not fin then readln(f,buf);
    end;

  end;




function TTableEdit.Xcharger(st:AnsiString;ChargerNom:boolean;l1,c1:integer;
                         var l,c:integer;CharSep:setChar):boolean;
  var
    f:TextFile;
  begin
    charSep:=charsep+[#9,';',' ',','];

    try
    assignFile(f,st);
    reset(f);

    XchargerEntete(f);
    XchargerData(f,ChargerNom,l1,c1,l,c,CharSep);
    closeFile(f);

    stfich:=st;
    invalidateAll;
    tabModifie:=true;
    Xproposer(ligStart,l,colStart,c);
    result:=true;
    except
    {$I-}CloseFile(f);{$I+}
    result:=false;
    end;
  end;

function TTableEdit.charger:boolean;
  const
    tbTypeF:string[5]='ASCII';
  var
    x1,x2,x:boolean;
    i,j,l,c:integer;
  begin
    charger:=false;
    if ChoixFichierStandard(stFich,stGen,stHis) then
      charger:=Xcharger(stFich,true,ligStart,colStart,l,c,setSep);
  end;


procedure TTableEdit.XsauverEntete(var f:text);
  begin
  end;

procedure TTableEdit.XsauverData(var f:Text;sauverNom:boolean;charSep:AnsiChar);
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
            st1:=chaineEtendu1(tab[j,i],champParDefaut,Deci0[j]);
            if j<>c2p then st1:=st1+stSep;
            if stSep<>'' then st1:=Fsupespace(st1);
            write(f,st1);
          end;
        writeln(f,'');
      end;
  end;

procedure TTableEdit.Xsauver(st:AnsiString;sauverNom:boolean;charSep:AnsiChar);
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

procedure TTableEdit.NonZeroCells(var Im,Jm:integer);
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


procedure TTableEdit.cadrageSS(sender:Tobject);
begin
  c1p:=colStart;
  l1p:=ligStart;

  NonZeroCells(c2p,l2p);
end;


procedure TTableEdit.sauver;
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

procedure TTableEdit.cadrer(var l1,l2,c1,c2:integer);
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

procedure TTableEdit.FillTab(l1,l2,c1,c2:integer;x:float);
  var
    i,j:integer;
  begin
    cadrer(l1,l2,c1,c2);
    for i:=c1 to c2 do
      for j:=l1 to l2 do
        tab[i,j]:=x;
  end;

procedure TTableEdit.copyTab(l1,l2,c1,c2,l0,c0:integer);
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


procedure TTableEdit.raz1;
var
  i:integer;
begin
  if assigned(cleardata) then clearData;
  tableFrame1.refresh;
end;

function TTableEdit.raz:boolean;
var
  i:integer;
begin
  if messageDlg('Clear all spreadsheet?',
                     mtConfirmation,[mbOk,mbCancel],0)=mrOK then
    begin
      raz1;
      result:=true;
      invalidateAll;
    end
  else result:=false;
end;

procedure TTableEdit.Load1Click(Sender: TObject);
begin
  if charger then tableFrame1.invalidate;
end;

procedure TTableEdit.Save1Click(Sender: TObject);
begin
  sauver;
end;


procedure TTableEdit.Font1Click(Sender: TObject);
var
  FontDialog:TfontDialog;
  oldL:integer;
begin
  oldL:=tableFrame1.drawGrid1.canvas.TextWidth('0');

  FontDialog:=TFontDialog.create(self);
  FontDialog.font.assign(tableFrame1.DrawGrid1.font);
  if FontDialog.execute then
    begin
      tableFrame1.DrawGrid1.font.assign(FontDialog.font);
      Update;
      recalculeDimCell(oldL);
    end;
  FontDialog.free;
end;


procedure TTableEdit.deselecter;
begin
end;


procedure TTableEdit.ClearAll1Click(Sender: TObject);
begin
  if Raz then tableFrame1.invalidate;
end;

function valeur(x:float):AnsiString;
var
  st:string[25];
begin
  str(x,st);
  supespace(st);
  result:=st;
end;


function TTableEdit.NombreDeLignesNonNulles(col:integer):integer;
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


procedure TTableEdit.Properties1Click(Sender: TObject);
begin
  if assigned(propertiesD) then propertiesD;
end;


procedure TTableEdit.AdjustFormSize;
var
  w,i:integer;
begin
  with TableFrame1.drawGrid1 do
  begin
    w:=0;
    for i:=0 to ColCount-1 do w:=w+ColWidths[i];
  end;

  if not visible and (w<Screen.Width-50)
    then clientWidth:=w+25;

  invalidate;
end;


procedure TTableEdit.UseKvalue1Click(Sender: TObject);
begin
  UseKvalue1.Checked:=not UseKvalue1.Checked;
  if assigned(setKvalueD) then
    begin
      setKvalueD(UseKvalue1.Checked);
      tableFrame1.invalidate;
    end;
end;

procedure TTableEdit.ImmediateRefreshClick(Sender: TObject);
begin
   if assigned(Fimmediate) then
     begin
       immediateRefresh.checked:=not immediateRefresh.checked;
       Fimmediate^:=immediateRefresh.checked;
     end;
end;

procedure TTableEdit.Options1Click(Sender: TObject);
begin
  if assigned(Fimmediate) then immediateRefresh.checked:=Fimmediate^;
end;

procedure TTableEdit.Refresh1Click(Sender: TObject);
begin
  if assigned(invalidateAllD) then invalidateAllD;
end;


procedure TTableEdit.XPrint;
var
  f: TextFile;
  i,j:integer;
  st:AnsiString;
  stSep:AnsiString;
begin
{$IFNDEF FPC}
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



procedure TTableEdit.Print1Click(Sender: TObject);
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

procedure TTableEdit.StringToLine(buf:AnsiString;num:integer);
var
  pc,error:integer;
  x:float;
  tp:typeLexBase;
  stMot:AnsiString;
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



procedure TTableEdit.Select1Click(Sender: TObject);
begin
  TableFrame1.selectGroup;
end;



procedure TTableEdit.Copy1Click(Sender: TObject);
var
  buf:ansiString;
  i,j,p:integer;
  nb:integer;

begin
  p:=0;
  with tableFrame1.drawGrid1.selection do
  begin
    nb:=(bottom-top+1)*(right-left+1);
    if nb>600000000 then exit;

    buf:='';

    for i:=top+ligStart-1 to bottom+ligStart-1 do
      begin
        for j:=left+colStart-1 to right+colStart-1-1 do
          buf:=buf+valeur(tab[j,i])+#9;

        buf:=buf+valeur(tab[right+colStart-1,i])+#13+#10;
      end;
    clipboard.AsText:=buf;
  end;
end;


procedure TTableEdit.paste1Click(Sender: TObject);
var
  stbuf:AnsiString;
  nb,cnt:integer;

  st:AnsiString;
  p,l,c:integer;
  x:float;
  code:integer;
  cmin,cmax,lmin,lmax:integer;
  row0,col0:integer;
  Srect0:TgridRect;

  procedure ranger;
  var
    l0,c0,l1,c1:integer;
  begin
    l0:=row0+l;
    c0:=col0+c;
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
  stBuf:=clipboard.AsText;

  col0:=tableFrame1.drawGrid1.col;
  row0:=tableFrame1.drawGrid1.row;

  cmin:=nbcolE;
  cmax:=0;
  lmin:=nbligE;
  lmax:=0;

  p:=0;
  l:=1;
  c:=1;
  st:='';

  while (p<length(stBuf)) and not ( (p mod 10000=0) and testEscape ) do
  begin
    inc(p);
    case stbuf[p] of
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
      if stbuf[p] <>#10 then st:=st+stbuf[p];
    end;
  end;

  TableFrame1.invalidate;
  SRect0.Top := lmin-ligStart;
  SRect0.Left := cmin-colStart;
  SRect0.Bottom := lmax-ligStart;
  SRect0.Right := cmax-colStart;
  TableFrame1.drawGrid1.Selection := SRect0;

end;


procedure TtableEdit.CellDblClick(rectCell:Trect;col1,row1:integer);
var
  st:AnsiString;
  res:integer;
  topD,leftD:integer;
  nbdeci:byte;
begin
  if (col1>0) and (row1=0) then
  begin
    leftD:=rectCell.left;
    topD:=rectCell.Top+25;
    if leftD+GetColParams.width>screen.DeskTopwidth
       then leftD:=screen.DeskTopwidth-GetColParams.width;

    if assigned(DblClickRow0) then
      begin
        DblClickRow0(col1,leftD,topD);
        refresh1Click(nil);
        exit;
      end;

    GetColParams.left:=leftD;
    GetColParams.top:=topD;
    GetColParams.Caption:= 'Column '+Istr(col1);

    st:=nomcol[col1+colStart-1];
    nbdeci:=deci0[col1+colStart-1];
    res:=GetColParams.execution(st,nbdeci);
    if res<>0 then
    begin
      case res of
        101:begin
              nomcol[col1+colStart-1]:=st;
              deci0[col1+colStart-1]:=nbdeci;
              tableFrame1.invalidate;
              invalidateVector(col1+colStart-1);
            end;
        102:if assigned(showD) then showD(col1+colStart-1);
      end;
      refresh1Click(nil);
    end;
  end;
end;

procedure TTableEdit.Clear2Click(Sender: TObject);
var
  i,j:integer;
begin
  with tableFrame1.drawGrid1.selection do
  begin
    for i:=top+ligStart-1 to bottom+ligStart-1 do
    for j:=left+colStart-1 to right+colStart-1 do
      tab[j,i]:=0;
  end;
  invalidateAll;
end;

procedure TTableEdit.invalidate;
begin
  inherited;
  if assigned(tableFrame1) then invalidateAll;
end;


Initialization
AffDebug('Initialization DtbEdit2',0);
{$IFDEF FPC}
{$I DtbEdit2.lrs}
{$ENDIF}
end.
