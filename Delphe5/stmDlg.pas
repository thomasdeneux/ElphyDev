unit stmDlg;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, messages,
     classes, graphics,forms, Controls, Buttons, DBctrls, ExtCtrls,
     util1,Dgraphic,stmdef,stmObj,Ncdef2,
     editcont,
     formDlg2,
     stmError,stmPg, debug0,
     stmData0,stmMemo1,
     {$IFNDEF WIN64}
     ZClasses,ZdbcIntfs,stmDatabase2,
     {$ENDIF}
     DBrecord1;

type
  Tdialog=class(Tdata0)
            {$IFNDEF WIN64}DBresultSet:TDBresultSet;{$ENDIF}
            FDBcurRow:integer;
            RowBuffer:TDBrecord;
            procedure setDBcurRow(y:integer);

            property DBcurRow:integer read FDBcurRow write setDBcurRow;

            function dlg:TdlgForm2;

            constructor create;override;
            destructor destroy;override;

            procedure createForm;override;
            procedure show(sender:Tobject);override;
            function showModal:integer;

            class function STMClassName:AnsiString;override;

            procedure setEmbedded(v:boolean);override;
            function ActiveEmbedded(TheParent:TwinControl; x1,y1,w1,h1:integer): Trect;override;
            procedure UnActiveEmbedded;override;
            procedure PaintImageTo(dc:hdc;x,y:integer);override;

            function getTitle:AnsiString;override;


            procedure processMessage(id:integer;source:typeUO;p:pointer);override;
            {$IFNDEF WIN64} procedure setResultSet(rs:TDBresultSet); {$ENDIF}
            procedure setE(w:float;data1:pointer);
            function getE(data1:pointer):float;

            procedure setEstring(w:float;data1:pointer);
            function getEstring(data1:pointer):float;


            procedure setI(w:integer;data1:pointer);
            function getI(data1:pointer):integer;

            procedure setSt(w:AnsiString;data1:pointer);
            function getSt(data1:pointer):AnsiString;

            procedure setB(w:boolean;data1:pointer);
            function getB(data1:pointer):boolean;

            procedure setDt(w:TdateTime;data1:pointer);
            function getDt(data1:pointer):TdateTime;



            function getDBInteger(titre:AnsiString;n,id,FieldNum:integer):integer;
            function getDBReal(titre:AnsiString;n,m,id,FieldNum:integer):integer;
            function getDBRealString(titre,suffix:AnsiString;n,m,id,FieldNum:integer):integer;
            function getDBString(titre:AnsiString;n,id,FieldNum:integer):integer;
            function getDBMemo(titre:AnsiString;n,Nline,flags,id,FieldNum:integer):integer;
            function getDBboolean(titre:AnsiString;id,FieldNum:integer):integer;

            function getDBdateTime(mode:integer; titre:AnsiString;n,id,FieldNum:integer ):integer;

            function getDBfield(nSt, n,m,id,FieldNum: integer): integer;

            function getDBStringList(titre,names,values:AnsiString;id,FieldNum:integer):integer;

            procedure StoreToRowBuffer(db:TDBrecord);


            function getWinWidth:integer;override;
            function getWinHeight:integer;override;

            procedure setExtControl(uo:typeUO);

            procedure DBgetValues(db:TDBrecord);
            procedure DBgetCheckedValues(db:TDBrecord);

            function getDBFieldNum(FieldName:AnsiString):integer;
          end;


procedure proTdialog_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTdialog_create_1(var pu:typeUO);pascal;


function fonctionTdialog_getInteger(titre:AnsiString;var x:integer;tpx:integer;n:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getInteger_1(titre:AnsiString;var x:integer;tpx:integer;n:integer;id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getIntegerA(titre:AnsiString;var x:integer;tpx:integer;n:integer;id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_getLongint
         (titre:AnsiString;var x:longint;n:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_getReal(titre:AnsiString;var x:real;tpx:integer;n,m:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getReal_1(titre:AnsiString;var x:real;tpx:integer;n,m:integer;id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getRealA(titre:AnsiString;var x:real;tpx:integer;n,m:integer;id:integer;var pu:typeUO):integer;pascal;


function fonctionTdialog_getString
         (titre:AnsiString;var x:AnsiString;n:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getString_1
         (titre:AnsiString;var x:Pgstring;sz:integer;n:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getString_2
         (titre:AnsiString;var x:AnsiString;n:integer;id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getString_3
         (titre:AnsiString;var x:Pgstring;sz:integer;n:integer;id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getStringA
         (titre:AnsiString;var x:AnsiString;n:integer;id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getStringA_1
         (titre:AnsiString;var x:Pgstring;sz:integer;n:integer;id:integer;var pu:typeUO):integer;pascal;


function fonctionTdialog_getBoolean
         (titre:AnsiString;var x:boolean;var pu:typeUO):integer;pascal;
function fonctionTdialog_getBoolean_1
         (titre:AnsiString;var x:boolean;id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_getBooleanA
         (titre:AnsiString;var x:boolean;id:integer;var pu:typeUO):integer;pascal;


function fonctionTdialog_getMemo
         (titre:AnsiString;var x:AnsiString;n,Nline,flags:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getMemo_1
         (titre:AnsiString;var x:AnsiString;n,Nline,flags:integer; id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_getDateTime
         (mode: integer;titre:AnsiString;var x:TdateTime;n:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_getDateTime_1
         (mode:integer;titre:AnsiString;var x:TdateTime;n,id: integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_getObject
         (titre:AnsiString;var x:TGvariant;n:integer;ClassId:AnsiString; var pu:typeUO):integer;pascal;
function fonctionTdialog_getObject_1
         (titre:AnsiString;var x:TGvariant;n:integer;ClassId:AnsiString;id:integer; var pu:typeUO):integer;pascal;



function fonctionTdialog_getStringList
         (titre,option:AnsiString;var x;tpx:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getStringList_1
         (titre,option,values:AnsiString;var x;tpx:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getStringList_2
         (titre,option:AnsiString;var x;tpx:integer; id: integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getStringList_3
         (titre,option,values:AnsiString;var x;tpx:integer; id: integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_getStringList1
         (titre:AnsiString;var option:typeUO; var x;tpx:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getStringList1_1
         (titre:AnsiString;var option:typeUO; var x;tpx:integer;id:integer;var pu:typeUO):integer;pascal;


function fonctionTdialog_getStringListA
         (titre,option:AnsiString;var x;tpx:integer;id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getStringList1A
         (titre:AnsiString;var option:typeUO; var x;tpx:integer;id:integer;var pu:typeUO):integer;pascal;



procedure proTdialog_ModifyStringList(AnId:integer; titre,option:AnsiString;var pu:typeUO);pascal;
procedure proTdialog_ModifyStringList_1(AnId:integer; titre,option,values:AnsiString;var pu:typeUO);pascal;


function fonctionTdialog_setText(titre:AnsiString;var pu:typeUO):integer;pascal;
function fonctionTdialog_setText_1(titre:AnsiString;id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_setText_2(titre:AnsiString;id:integer;
                                   FontName:AnsiString;FontSize,FontColor,FontStyle:integer;
                                   var pu:typeUO):integer;pascal;
function fonctionTdialog_setTextA(titre:AnsiString;id:integer;var pu:typeUO):integer;pascal;


procedure proTdialog_modifyText(id:integer;titre:AnsiString;var pu:typeUO);pascal;
procedure proTdialog_modifyText_1(id:integer;titre:AnsiString;
                               FontName:AnsiString;FontSize,FontColor,FontStyle:integer;
                               var pu:typeUO);pascal;
procedure proTdialog_modifyTextA(id:integer;titre:AnsiString;var pu:typeUO);pascal;

function fonctionTdialog_getColor(titre:AnsiString;var x:longint;var pu:typeUO):integer;pascal;
function fonctionTdialog_getColor_1(titre:AnsiString;var x:longint;id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getColorA(titre:AnsiString;var x:longint;id:integer;var pu:typeUO):integer;pascal;


function fonctionTdialog_getCommand
         (titre:AnsiString;mresult:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getCommand_1
         (titre:AnsiString;mresult:integer;id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getCommandA
         (titre:AnsiString;mresult:integer;id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_showModal(var pu:typeUO):integer;pascal;

procedure proTdialog_update(var pu:typeUO);pascal;
procedure proTdialog_update_1(num:integer; var pu:typeUO);pascal;

procedure proTdialog_updatevar(var pu:typeUO);pascal;
procedure proTdialog_updatevar_1(num:integer; var pu:typeUO);pascal;


procedure proTdialog_onChange(n:integer;w:integer;var pu:typeUO);pascal;
function fonctionTdialog_onChange(n:integer;var pu:typeUO):integer;pascal;

procedure proTdialog_onDragDrop(n:integer;w:integer;var pu:typeUO);pascal;
function fonctionTdialog_onDragDrop(n:integer;var pu:typeUO):integer;pascal;


procedure proTdialog_onEvent(w:integer;var pu:typeUO);pascal;
function fonctionTdialog_onEvent(var pu:typeUO):integer;pascal;

procedure proTdialog_setButtons(bb:integer;var pu:typeUO);pascal;

procedure proTdialog_AddScrollBar(min1,max1,dx1,dx2:float;var pu:typeUO);pascal;
procedure proTdialog_ModifyScrollBarA(num:integer;min1,max1,dx1,dx2:float;var pu:typeUO);pascal;

procedure proTdialog_AddCheckBox(var pu:typeUO);pascal;
procedure proTdialog_SetCheckBox(idNum:integer; var pu:typeUO);pascal;
procedure proTdialog_SetReadOnly(var pu:typeUO);pascal;

procedure proTdialog_AddText(nbCar:integer;var pu:typeUO);pascal;

procedure proTdialog_Checked(num:integer; w: boolean; var pu:typeUO);pascal;
function fonctionTdialog_Checked(num:integer; var pu:typeUO):boolean;pascal;
procedure proTdialog_CheckedA(id:integer; w: boolean; var pu:typeUO);pascal;
function fonctionTdialog_CheckedA(id:integer; var pu:typeUO):boolean;pascal;

procedure proTdialog_Enabled(num:integer; w: boolean; var pu:typeUO);pascal;
function fonctionTdialog_Enabled(num:integer; var pu:typeUO):boolean;pascal;
procedure proTdialog_EnabledA(id:integer; w: boolean; var pu:typeUO);pascal;
function fonctionTdialog_EnabledA(id:integer; var pu:typeUO):boolean;pascal;


procedure proTdialog_Caption(st:AnsiString;var pu:typeUO);pascal;
function fonctionTdialog_Caption(var pu:typeUO):AnsiString;pascal;

procedure proTdialog_close(var pu:typeUO);pascal;



function fonctionTdialog_setListBox
         (titre,options:AnsiString;nblig,nbcol,nbchar:integer;var x;sz:integer;tp:word; id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_setListBox_1
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol,nbchar:integer;var x: integer;
          id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_setListBox_2
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol,nbchar:integer;var x;sz:integer;tp:word;
          id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_setListBox_3
         (titre,options:AnsiString;nblig,nbcol:integer;var x;sz:integer;tp:word; id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_setListBox_4
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol:integer;var x: integer;
          id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_setListBox_5
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol:integer;var x;sz:integer;tp:word;
          id:integer;var pu:typeUO):integer;pascal;


function fonctionTdialog_setListBox1
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol:integer;var x;sz:integer;tp:word;
          id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_setCheckListBox
         (titre,options:AnsiString;nblig,nbcol,nbchar:integer;var x;sz:integer;tp:word; id:integer;var pu:typeUO):integer; pascal;

function fonctionTdialog_setCheckListBox_1
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol,nbchar:integer;var x;sz:integer;tp:word;
          id:integer;var pu:typeUO):integer; pascal;

function fonctionTdialog_setCheckListBox_2
         (titre,options:AnsiString;nblig,nbcol:integer;var x;sz:integer;tp:word; id:integer;var pu:typeUO):integer; pascal;
function fonctionTdialog_setCheckListBox_3
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol:integer;var x;sz:integer;tp:word;
          id:integer;var pu:typeUO):integer; pascal;



procedure proTdialog_dividePanel(num,nb:integer;vert:boolean;var pu:typeUO);pascal;
procedure proTdialog_dividePanel_1(stName:AnsiString;nb:integer;vert:boolean;var pu:typeUO);pascal;

procedure proTdialog_selectPanel(num:integer;var pu:typeUO);pascal;
procedure proTdialog_selectPanel_1(stName:AnsiString;var pu:typeUO);pascal;


procedure proTdialog_setPanelProp(Fborder: boolean;Fbevel:integer;var pu:typeUO);pascal;
procedure proTdialog_setPanelProp_1(Fborder: boolean;Fbevel:integer;Mleft,Mtop,Mright,Mbottom:integer ;var pu:typeUO);pascal;

procedure proTdialog_setLineSpacing(n:integer;var pu:typeUO);pascal;

procedure proTdialog_DispatchMessages(var pu:typeUO);pascal;

procedure proTdialog_SplitPanel(num:integer;st:AnsiString;var pu:typeUO);pascal;
procedure proTdialog_SplitPanel_1(stName:AnsiString;st:AnsiString;var pu:typeUO);pascal;
procedure proTdialog_SplitPanel_2(num:integer;nbTabs:integer;var pu:typeUO);pascal;
procedure proTdialog_SplitPanel_3(stName:AnsiString;nbTabs:integer;var pu:typeUO);pascal;

procedure proTdialog_SelectPanelTab(num:integer;value:integer;var pu:typeUO);pascal;
procedure proTdialog_SelectPanelTab_1(stName:AnsiString;value:integer;var pu:typeUO);pascal;

function fonctionTdialog_getDBInteger(titre:AnsiString;n,field:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBInteger_1(titre:AnsiString;n,field,id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBInteger_2(titre:AnsiString;n:integer;FieldName:AnsiString;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBInteger_3(titre:AnsiString;n:integer;fieldName:AnsiString;id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_getDBReal(titre:AnsiString;n,m,field:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBReal_1(titre:AnsiString;n,m,field,id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBReal_2(titre:AnsiString;n,m:integer;FieldName:AnsiString;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBReal_3(titre:AnsiString;n,m:integer;fieldName:AnsiString;id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_getDBRealString(titre,suffix:AnsiString;n,m,field:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBRealString_1(titre,suffix:AnsiString;n,m,field,id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBRealString_2(titre,suffix:AnsiString;n,m:integer;FieldName:AnsiString;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBRealString_3(titre,suffix:AnsiString;n,m:integer;fieldName:AnsiString;id:integer;var pu:typeUO):integer;pascal;


function fonctionTdialog_getDBString(titre:AnsiString;n,field:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBString_1(titre:AnsiString;n,field,id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBString_2(titre:AnsiString;n:integer;FieldName:AnsiString;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBString_3(titre:AnsiString;n:integer;fieldName:AnsiString;id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_getDBboolean(titre:AnsiString; field:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBboolean_1(titre:AnsiString; field,id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBboolean_2(titre:AnsiString; FieldName:AnsiString;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBboolean_3(titre:AnsiString; fieldName:AnsiString;id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_getDBMemo(titre:AnsiString;n,Nline,flags,field:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBMemo_1(titre:AnsiString;n,Nline,flags,field,id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBMemo_2(titre:AnsiString;n,Nline,flags:integer;FieldName:AnsiString;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBMemo_3(titre:AnsiString;n,Nline,flags:integer;fieldName:AnsiString;id:integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_getDBdateTime(mode:integer;titre:AnsiString;n,field:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBdateTime_1(mode:integer;titre:AnsiString;n,field,id:integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBdateTime_2(mode:integer;titre:AnsiString;n:integer;FieldName:AnsiString;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBdateTime_3(mode:integer;titre:AnsiString;n:integer;fieldName:AnsiString;id:integer;var pu:typeUO):integer;pascal;


function fonctionTdialog_getDBfield(nSt, n,m,Field: integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBfield_1(nSt, n,m,field,id: integer;var pu:typeUO):integer;pascal;

function fonctionTdialog_getDBStringList(titre,names,values: AnsiString; Field: integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBStringList_1(titre,names,values: AnsiString; Field, id: integer;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBStringList_2(titre,names,values: AnsiString; FieldName:AnsiString;var pu:typeUO):integer;pascal;
function fonctionTdialog_getDBStringList_3(titre,names,values: AnsiString; FieldName:AnsiString; id:integer;var pu:typeUO):integer;pascal;


procedure proTdialog_setDBResultSet(var rset,pu:typeUO);pascal;

procedure proTdialog_DBcurrentRow(n:integer;var pu:typeUO);pascal;
function  fonctionTdialog_DBcurrentRow(var pu:typeUO): integer;pascal;


procedure proTdialog_DBsetValues(var db: TDBrecord; var pu:typeUO);pascal;
procedure proTdialog_DBgetValues(var db: TDBrecord; var pu:typeUO);pascal;
procedure proTdialog_DBgetCheckedValues(var db: TDBrecord; var pu:typeUO);pascal;



function fonctionTdialog_font(var pu:typeUO):Tfont;pascal;
procedure proTdialog_setCursor(var pp:pointer;var pu:typeUO);pascal;


procedure proTdialog_LineHeight(n:integer; var pu:typeUO);pascal;
function fonctionTdialog_LineHeight(var pu:typeUO): integer;pascal;

procedure proDispatchMessages;pascal;

procedure proTdialog_AddGroupbox(st:AnsiString;var pu:typeUO);pascal;

implementation

uses stmCurs,cursor1;

var
  E_field:integer;
  E_positionSaisie:integer;
  E_deci:integer;
  E_string:integer;
  E_numControl:integer;
  E_poswin:integer;

constructor Tdialog.create;
begin
  inherited create;

  rowBuffer:=TDBrecord.create;
  rowBuffer.notPublished := True;
  rowBuffer.FChild := True;
  
  createForm;
  dlg.UOdlg:=self;
end;

destructor Tdialog.destroy;
begin
  {$IFNDEF WIN64}
  rowBuffer.Free;
  rowBuffer:=nil;
  
  derefObjet(typeUO(DBresultSet));
  {$ENDIF}
  dlg.derefObjects;

  inherited destroy;
end;

procedure Tdialog.createForm;
begin
  form:=TdlgForm2.create(formStm);
  dlg.formStyle:=fsStayOnTop;
  dlg.borderStyle:=bsSingle;
  {$IFDEF FPC}
  dlg.Color:=clSilver;
  dlg.DefaultMonitor:= dmMainForm;
  dlg.Position:= poMainFormCenter;
  {$ENDIF}
end;

procedure Tdialog.show(sender: Tobject);
begin
  if not Embedded then
  begin
    dlg.formStyle:=fsStayOnTop;
    dlg.borderStyle:=bsSingle;
    dlg.Show;
  end;
end;

function Tdialog.showModal:integer;
begin
  if not Embedded then
  begin
    dlg.formStyle:=fsStayOnTop;
    dlg.borderStyle:=bsDialog;
    result:=dlg.ShowModal;
  end
  else result:=0;
end;


function Tdialog.dlg:TdlgForm2;
begin
  result:=TdlgForm2(form);
end;

class function Tdialog.STMClassName:AnsiString;
begin
  result:='Dialog';
end;

function Tdialog.getTitle: AnsiString;
begin
  result:='';
end;


procedure Tdialog.processMessage(id: integer; source: typeUO; p: pointer);
begin
  inherited;

  case id of
    UOmsg_invalidateData:
      begin
        {$IFNDEF WIN64}
        if (DBresultset=source) then
          begin
            DBresultSet.loadRowBuffer(DBcurRow,RowBuffer);
            dlg.updateControls;
            messageToRef(UOmsg_invalidate,nil);

          end;
        {$ENDIF}
      end;


    UOmsg_destroy:
      begin
        {$IFNDEF WIN64}
        if (DBresultSet=source) then
        begin
          rowBuffer.clear;

          setResultSet(nil);
          messageToRef(UOmsg_invalidate,nil);
          dlg.updateControls;
        end
        else dlg.CheckObject(source);
        {$ENDIF}
      end;
  end;
end;

{$IFNDEF WIN64}
procedure Tdialog.setResultSet(rs: TDBresultSet);
begin
  if assigned(DBresultSet) then rowBuffer.clear;
  derefObjet(typeUO(DBresultSet));
  DBresultSet:=rs;
  refObjet(typeUO(DBresultSet));

  if assigned(DBresultset) and DBresultset.isOpen then
  with DBresultset do
  begin
    resultSet.First;
    FDBCurRow:=1;
    initRowBuffer(RowBuffer);
    DBresultSet.loadRowBuffer(DBcurRow,RowBuffer);

    dlg.updateControls;
  end;
end;
{$ENDIF}

function Tdialog.getE(data1: pointer): float;
var
  {$IFNDEF WIN64}Ztype:TZSQLtype; {$ENDIF}
  x:integer;
begin
  result:=0;
  {$IFNDEF WIN64}
  x:=intG(data1) and $FFFF;

  if assigned(DBresultSet) and DBresultSet.isOpen then
  begin
    Ztype:=DBresultSet.resultSet.GetMetadata.GetColumnType(x);

    case Ztype of
      stByte, stShort, stInteger, stLong:    result:=rowBuffer[x-1].VInteger;
      stFloat,stDouble,stBigDecimal:         result:=rowBuffer[x-1].Vfloat;
      else result:=0;
    end
  end;
  {$ENDIF}
end;

procedure Tdialog.setE(w: float; data1: pointer);
var
  {$IFNDEF WIN64}Ztype:TZSQLtype; {$ENDIF}
  x, NumV:integer;
begin
{$IFNDEF WIN64}
  if not assigned(DBresultset) or not DBresultset.isOpen then exit;

  x:=intG(data1) and $FFFF;
  NumV:=intG(data1) shr 16;
  Ztype:=DBresultSet.resultSet.GetMetadata.GetColumnType(x);

  case Ztype of
    stByte, stShort, stInteger, stLong:    rowBuffer.VInteger[x-1]:=round(w);
    stFloat,stDouble,stBigDecimal:         rowBuffer.Vfloat[x-1]:=w;
  end;
  rowBuffer.Fchecked[x-1]:=dlg.Checked[NumV+1];
{$ENDIF}
end;

function Tdialog.getEstring(data1: pointer): float;
var
  {$IFNDEF WIN64}Ztype:TZSQLtype; {$ENDIF}
  x,i: integer;
  st1:AnsiString;
  w:float;
  code:integer;
const
  digits=['0'..'9','.','+','-'];
begin
  result:=0;
  {$IFNDEF WIN64}
  x:=intG(data1) and $FFFF;

  if assigned(DBresultSet) and DBresultSet.isOpen then
  begin
    st1:=rowBuffer[x-1].Vstring;

    while (st1<>'') and (st1[1]=' ') do delete(st1,1,1);
    i:=1;
    while (i<=length(st1)) and (st1[i] in digits) do inc(i);

    st1:=copy(st1,1,i-1);
    val(st1,w,code);
    if code=0
      then result:=w
      else result:=0;
  end;
  {$ENDIF}
end;

procedure Tdialog.setEstring(w: float; data1: pointer);
var
  {$IFNDEF WIN64}Ztype:TZSQLtype; {$ENDIF}
  x, NumV:integer;
begin
{$IFNDEF WIN64}
  if not assigned(DBresultset) or not DBresultset.isOpen then exit;

  x:=intG(data1) and $FFFF;
  NumV:=intG(data1) shr 16;

  with dlg.ctrl[NumV+1]^ do
  rowBuffer.Vstring[x-1]:=Estr(w,Ndeci)+stSuffix;

  rowBuffer.Fchecked[x-1]:=dlg.Checked[NumV+1];
{$ENDIF}
end;



function Tdialog.getI(data1: pointer): integer;
var
  {$IFNDEF WIN64}Ztype:TZSQLtype; {$ENDIF}
  x:integer;
begin
  result:=0;
  {$IFNDEF WIN64}
  x:=intG(data1) and $FFFF;

  if assigned(DBresultSet) and DBresultSet.isOpen then
  begin
    Ztype:=DBresultSet.resultSet.GetMetadata.GetColumnType(x);

    case Ztype of
      stByte, stShort, stInteger, stLong:    result:=rowBuffer[x-1].VInteger;
      else result:=0;
    end
  end;
  {$ENDIF}
end;

procedure Tdialog.setI(w: integer; data1: pointer);
var
  {$IFNDEF WIN64}Ztype:TZSQLtype; {$ENDIF}
  x, NumV:integer;
begin
{$IFNDEF WIN64}
  if not assigned(DBresultset) or not DBresultset.isOpen then exit;

  x:=intG(data1) and $FFFF;
  NumV:=intG(data1) shr 16;
  Ztype:=DBresultSet.resultSet.GetMetadata.GetColumnType(x);

  case Ztype of
    stByte, stShort, stInteger, stLong:    rowBuffer.VInteger[x-1]:=w;
  end;
  rowBuffer.Fchecked[x-1]:=dlg.Checked[NumV+1];
{$ENDIF}
end;


procedure Tdialog.setSt(w:AnsiString;data1:pointer);
var
  x,NumV:integer;
begin
{$IFNDEF WIN64}
  if not assigned(DBresultset) or not DBresultset.isOpen then exit;

  x:=intG(data1) and $FFFF;
  NumV:=intG(data1) shr 16;
  rowBuffer.VString[x-1]:=w;
  rowBuffer.Fchecked[x-1]:=dlg.Checked[NumV+1];
{$ENDIF}
end;

function Tdialog.getSt(data1:pointer):AnsiString;
var
  x, NumV:integer;
begin
  result:='';
  {$IFNDEF WIN64}
  if not assigned(DBresultset) or not DBresultset.isOpen then exit;

  x:=intG(data1) and $FFFF;

  result:=rowBuffer[x-1].VString;

  {$ENDIF}
end;

procedure Tdialog.setB(w:boolean;data1:pointer);
var
  x,NumV:integer;
begin
{$IFNDEF WIN64}
  if not assigned(DBresultset) or not DBresultset.isOpen then exit;

  x:=intG(data1) and $FFFF;
  NumV:=intG(data1) shr 16;
  rowBuffer.VBoolean[x-1]:=w;
  rowBuffer.Fchecked[x-1]:=dlg.Checked[NumV+1];
{$ENDIF}
end;

function Tdialog.getB(data1:pointer):boolean;
var
  x, NumV:integer;
begin
  result:=false;
  {$IFNDEF WIN64}
  if not assigned(DBresultset) or not DBresultset.isOpen then exit;

  x:=intG(data1) and $FFFF;

  result:=rowBuffer[x-1].Vboolean;

  {$ENDIF}
end;


procedure Tdialog.setDt(w:TdateTime;data1:pointer);
var
  x,NumV:integer;
begin
{$IFNDEF WIN64}
  if not assigned(DBresultset) or not DBresultset.isOpen then exit;

  x:=intG(data1) and $FFFF;
  NumV:=intG(data1) shr 16;
  rowBuffer.VdateTime[x-1]:=w;
  rowBuffer.Fchecked[x-1]:=dlg.Checked[NumV+1];
{$ENDIF}
end;

function Tdialog.getDt(data1:pointer):TdateTime;
var
  x:integer;
begin
  double(result):=0;
  {$IFNDEF WIN64}
  if not assigned(DBresultset) or not DBresultset.isOpen then exit;

  x:=intG(data1) and $FFFF;
  result:=rowBuffer[x-1].VdateTime;
  {$ENDIF}
end;


function Tdialog.getDBInteger(titre: AnsiString; n,id,FieldNum: integer): integer;
begin
{$IFNDEF WIN64}{$ENDIF}
  Dlg.setNumProp(titre,g_longint,n,0,setE,getE,pointer(FieldNum  or (dlg.nbvar shl 16) ));

  if id<>0 then
    with Dlg do ctrl[nbvar].Number:=id;

  result:=dlg.nbVar;
{$IFNDEF WIN64}{$ENDIF}
end;

function Tdialog.getDBReal(titre: AnsiString; n,m,id,FieldNum: integer): integer;
begin
{$IFNDEF WIN64}
  Dlg.setNumProp(titre,g_extended,n,m,setE,getE,pointer(FieldNum  or (dlg.nbvar shl 16)));

  if id<>0 then
    with Dlg do ctrl[nbvar].Number:=id;

  result:=dlg.nbVar;
{$ENDIF}
end;

function Tdialog.getDBRealString(titre,suffix: AnsiString; n,m,id,FieldNum: integer): integer;
begin
{$IFNDEF WIN64}
  Dlg.setNumProp(titre,g_extended,n,m,setEstring,getEstring,pointer(FieldNum  or (dlg.nbvar shl 16)));

  with Dlg.ctrl[Dlg.nbvar]^ do
  begin
    stSuffix:=suffix;
    if id<>0 then Number:=id;
  end;

  result:=dlg.nbVar;
{$ENDIF}
end;


function Tdialog.getDBString(titre: AnsiString; n,id,FieldNum: integer): integer;
begin
{$IFNDEF WIN64}
  Dlg.setStringProp(titre,n,setSt,getSt,pointer(FieldNum  or (dlg.nbvar shl 16)));

  if id<>0 then
    with Dlg do ctrl[nbvar].Number:=id;

  result:=dlg.nbVar;
{$ENDIF}
end;

function Tdialog.getDBboolean(titre: AnsiString; id,FieldNum: integer): integer;
begin
{$IFNDEF WIN64}
  Dlg.setBooleanProp(titre,setB,getB,pointer(FieldNum  or (dlg.nbvar shl 16)));

  if id<>0 then
    with Dlg do ctrl[nbvar].Number:=id;

  result:=dlg.nbVar;
{$ENDIF}
end;

function Tdialog.getDBMemo(titre: AnsiString; n,Nline,flags,id,FieldNum: integer): integer;
begin
{$IFNDEF WIN64}
  Dlg.setMemoProp(titre,n,Nline,flags,setSt,getSt,pointer(FieldNum  or (dlg.nbvar shl 16)));

  if id<>0 then
    with Dlg do ctrl[nbvar].Number:=id;

  result:=dlg.nbVar;
{$ENDIF}
end;

function Tdialog.getDBdateTime(mode:integer;titre: AnsiString; n,id,FieldNum: integer): integer;
begin
{$IFNDEF WIN64}
  Dlg.setDateTimeProp(mode,titre,n,setDt,getDt,pointer(FieldNum  or (dlg.nbvar shl 16)));

  if id<>0 then
    with Dlg do ctrl[nbvar].Number:=id;

  result:=dlg.nbVar;
{$ENDIF}
end;



function Tdialog.getDBfield(nSt, n,m,id,FieldNum: integer): integer;
var
  Gtype: TGvariantType;
  p: pointer;
  title:AnsiString;
begin
{$IFNDEF WIN64}
  result:=-1;

  Gtype:=DBresultSet.GVtype[FieldNum-1];
  title:=DBresultset.NameList[FieldNum-1];

  p:=pointer(FieldNum  or (dlg.nbvar shl 16));

  case Gtype of
    gvInteger:     Dlg.setNumProp(title,g_longint,n,0,setE,getE,p);
    gvFloat:       Dlg.setNumProp(title,g_longint,n,m,setE,getE,p);
    gvString:      Dlg.setStringProp(title,nst,setSt,getSt,p);
    gvDateTime:    Dlg.setDateTimeProp(3,title,n,setDt,getDt,p);
    else exit;
  end;

  if id<>0 then
    with Dlg do ctrl[nbvar].Number:=id;

  result:=dlg.nbVar;
{$ENDIF}
end;

procedure Tdialog.setDBcurRow(y:integer);
begin
  {$IFNDEF WIN64}
  if assigned(DBresultset)  then
  with DBresultset do
  begin
    if y>rowCount then y:=rowCount;
    if y<1 then y:=1;

    if (rowCount<>0) and (y<>DBcurRow) then
    begin
      FDBcurRow:=y;
      LoadRowBuffer(DBcurRow,rowBuffer);
      dlg.updateControls;
    end;
  end;
  {$ENDIF}
end;

procedure Tdialog.StoreToRowBuffer(db:TDBrecord);
var
  i, NumCol:integer;
begin
  for i:=0 to db.count-1 do
  begin
    NumCol:=rowBuffer.fields.indexof(db.fields[i]);
    if (NumCol>=0) and (db[i].Vtype=rowBuffer[NumCol].Vtype)
      then copyGvariant(db.getVariant(i)^,rowBuffer.getVariant(NumCol)^);
  end;
  dlg.updateControls;
end;



function Tdialog.getWinHeight: integer;
begin
  dlg.installForm;
  result:=dlg.ClientHeight;
end;

function Tdialog.getWinWidth: integer;
begin
  dlg.installForm;
  result:=dlg.Width;
end;


procedure Tdialog.setExtControl(uo:typeUO);
begin
  Dlg.setExtControl(uo)
end;

function Tdialog.ActiveEmbedded(TheParent: TwinControl; x1, y1, w1, h1: integer): Trect;
begin
  with dlg.BackPanel do
  begin
    parent:=TheParent;
    setBounds(x1,y1,w1,h1);
    result:=rect(left,top,left+width-1,top+height-1);
    Affdebug('ActiveE '+Istr(x1)+' '+Istr(y1)+' / '+Istr(w1)+' '+Istr(h1),131);
  end;
end;

procedure Tdialog.UnActiveEmbedded;
begin
  dlg.BackPanel.Parent:=dlg;
  dlg.visible:=false;
  {dlg.installForm;}
end;

procedure Tdialog.PaintImageTo(dc:hdc;x,y:integer);
begin
  dlg.BackPanel.PaintTo(dc, x, y);
end;


procedure TDialog.DBgetCheckedValues(db: TDBrecord);
var
  i:integer;
begin
  dlg.UpdateVars;
  db.clearFields;
  for i:=0 to rowBuffer.count-1 do
  if rowBuffer.Fchecked[i] then
    db.AddItem(rowBuffer.Fields[i], rowBuffer.getVariant(i)^);
end;

procedure TDialog.DBgetValues(db: TDBrecord);
begin
  db.clearFields;
  db.assign(rowBuffer);
end;

function Tdialog.getDBStringList(titre,names,values: AnsiString; id, FieldNum: integer): integer;
var
  i,k,n,code:integer;
  vv:TarrayOfInteger;
  sst:TarrayOfString;
  st1:AnsiString;
  FlagString, ok: boolean;
begin
  result:=-1;

  FlagString:=(values='');

  if not FlagString then
  begin
    ok:=true;
    repeat
      k:=0;
      while (k<length(values)) and (values[k+1]<>'|') do inc(k);
      if k>0 then
      begin
        st1:=copy(values,1,k);
        setlength(sst,length(sst)+1);
        sst[high(sst)]:=st1;

        st1:=Fsupespace(st1);
        val(st1,n,code);
        if code<>0 then ok:=false;
        setlength(vv,length(vv)+1);
        vv[high(vv)]:=n;
        delete(values,1,k+1);
      end;
    until (length(values)=0);

    if ok
      then dlg.setEnumerated(titre,names,nil^,t_longint,setI,getI,pointer(FieldNum  or (dlg.nbvar shl 16)),vv)
      else dlg.setEnumerated(titre,names,nil^,t_longint,nil ,nil ,pointer(FieldNum  or (dlg.nbvar shl 16)),nil,sst,setSt, getSt);
  end
  else dlg.setEnumerated(titre,names,nil^,t_longint,nil,nil,pointer(FieldNum  or (dlg.nbvar shl 16)),nil,nil,setSt,getSt);

  if id<>0 then
    with Dlg do ctrl[nbvar].Number:=id;

  result:=dlg.nbVar;
end;



function Tdialog.getDBFieldNum(FieldName:AnsiString): integer;
begin
  result:=0;
  {$IFNDEF WIN64}
  if assigned(DBresultSet) then result:=DBresultSet.resultset.FindColumn(FieldName);
  if result=0 then sortieErreur('Invalid Field Name --> '+FieldName);
  {$ENDIF}
end;


{********************************** Méthodes STM *****************************************}

var
  E_DlgInstalled:integer;

procedure verifierDialogue(pu:typeUO);
begin
  verifierObjet(pu);

  if Tdialog(pu).dlg.CtrlInstalled then sortieErreur(E_DlgInstalled);
end;

procedure proTdialog_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,Tdialog);
end;

procedure proTdialog_create_1(var pu:typeUO);
begin
  proTdialog_create('', pu);
end;

function fonctionTdialog_getInteger
         (titre:AnsiString;var x:integer;tpx:integer;n:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getInteger_1(titre, x,tpx, n, 0, pu);
end;

function fonctionTdialog_getInteger_1
         (titre:AnsiString;var x:integer;tpx:integer;n:integer;id:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,20,E_field);
    Dlg.setNumVar(titre,x,nbToTT(tpx),n,0);

    result:=dlg.setId(id);
  end;
end;

function fonctionTdialog_getIntegerA
         (titre:AnsiString;var x:integer;tpx:integer;n:integer;id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getInteger_1(titre, x,tpx, n, id, pu);
end;


function fonctionTdialog_getLongint
         (titre:AnsiString;var x:longint;n:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  {$IFDEF FPC} titre:=AnsiToUtf8(titre); {$ENDIF}
  with Tdialog(pu) do
  begin
    controleParam(n,1,20,E_field);
    Dlg.setNumVar(titre,x,T_longInt,n,0);
    result:=dlg.nbvar;
  end;
end;

function fonctionTdialog_getReal
         (titre:AnsiString;var x:real;tpx:integer;n,m:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getReal_1(titre, x, tpx, n, m, 0, pu);
end;

function fonctionTdialog_getReal_1
         (titre:AnsiString;var x:real;tpx:integer;n,m:integer;id:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,23,E_field);
    controleParam(m,1,n-1,E_deci);
    Dlg.setNumVar(titre,x,nbToTT(tpx),n,m);

    result:=dlg.setId(id);
  end;
end;

function fonctionTdialog_getRealA
         (titre:AnsiString;var x:real;tpx:integer;n,m:integer;id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getReal_1(titre, x, tpx, n, m, id, pu);
end;


function fonctionTdialog_getString
         (titre:AnsiString;var x:AnsiString;n:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getString_2(titre, x, n, 0, pu);
end;

function fonctionTdialog_getString_1
         (titre:AnsiString;var x:Pgstring;sz:integer;n:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getString_3(titre, x, sz, n, 0, pu);
end;

function fonctionTdialog_getString_2
         (titre:AnsiString;var x:AnsiString;n:integer;id:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    if n<0 then n:=0;
    Dlg.setString(titre,x,n);
    result:= dlg.setId(id);
  end;
end;

function fonctionTdialog_getString_3
         (titre:AnsiString;var x:Pgstring;sz:integer;n:integer;id:integer;var pu:typeUO):integer;
var
  x1:shortString absolute x;

begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    ControleParam(n,1,255,e_string);
    Dlg.setShortString(titre,x1,sz-1,n);
    with Dlg do ctrl[nbvar].Number:=id;
    result:=dlg.setId(id);
  end;
end;

function fonctionTdialog_getStringA
         (titre:AnsiString;var x:AnsiString;n:integer;id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getString_2(titre, x, n, id, pu);
end;

function fonctionTdialog_getStringA_1
         (titre:AnsiString;var x:Pgstring;sz:integer;n:integer;id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getString_3(titre, x, sz, n, id, pu);
end;


function fonctionTdialog_getMemo(titre:AnsiString;var x:AnsiString;n,Nline,flags:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getMemo_1(titre, x, n, Nline, flags, 0, pu);
end;

function fonctionTdialog_getMemo_1(titre:AnsiString;var x:AnsiString;n,Nline,flags:integer; id:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);

  with Tdialog(pu) do
  begin
    if n<0 then n:=0;
    Dlg.setMemo(titre,x,n,Nline,flags);
    with Dlg do ctrl[nbvar].Number:=id;
    result:=dlg.setId(id);
  end;
end;


function fonctionTdialog_getDateTime(mode:integer;titre:AnsiString;var x:TdateTime;n:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getDateTime_1(mode,titre, x,n,0, pu);
end;

function fonctionTdialog_getDateTime_1(mode:integer;titre:AnsiString;var x:TdateTime;n,id: integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    ControleParam(n,1,255,e_string);
    Dlg.setDateTime(mode,titre,x,n);
    result:=dlg.setId(id);
  end;
end;


function fonctionTdialog_getBoolean(titre:AnsiString;var x:boolean;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getBoolean_1(titre, x, 0, pu);
end;

function fonctionTdialog_getBoolean_1(titre:AnsiString;var x:boolean;id:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    Dlg.setBoolean(titre,x);
    result:=dlg.setId(id);
  end;
end;

function fonctionTdialog_getBooleanA(titre:AnsiString;var x:boolean;id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getBoolean_1(titre, x, id, pu);
end;

function fonctionTdialog_getStringList(titre,option:AnsiString;var x;tpx:integer;var pu:typeUO):integer;
begin
  result:=fonctionTdialog_getStringList_2(titre,option, x, tpx, 0, pu);
end;

function fonctionTdialog_getStringList_1(titre,option,values:AnsiString;var x;tpx:integer; var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getStringList_3(titre,option,values, x,tpx,0, pu);
end;

function fonctionTdialog_getStringList_2(titre,option:AnsiString;var x;tpx:integer; id: integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);

  with Tdialog(pu) do
  begin
    Dlg.setEnumerated(titre,Option,x,nbtoTT(tpx));
    result:=dlg.setId(id);
  end;
end;


function fonctionTdialog_getStringList_3(titre,option,values:AnsiString;var x;tpx:integer;id: integer; var pu:typeUO):integer;
var
  FlagString: boolean;
  ok: boolean;
  k,n,code:integer;
  st1: AnsiString;
  vv: TarrayOfInteger;
begin
  verifierDialogue(pu);

  FlagString:=(values='');

  if not FlagString then
  begin
    ok:=true;
    repeat
      k:=0;
      while (k<length(values)) and (values[k+1]<>'|') do inc(k);
      if k>0 then
      begin
        st1:=copy(values,1,k);

        st1:=Fsupespace(st1);
        val(st1,n,code);
        if code<>0 then ok:=false;
        setlength(vv,length(vv)+1);
        vv[high(vv)]:=n;
        delete(values,1,k+1);
      end;
    until not ok or (length(values)=0);

    if ok
      then Tdialog(pu).dlg.setEnumerated(titre,Option,x,nbtoTT(tpx),nil ,nil ,nil,vv)
      else Tdialog(pu).Dlg.setEnumerated(titre,Option,x,nbtoTT(tpx));
  end
  else Tdialog(pu).Dlg.setEnumerated(titre,Option,x,nbtoTT(tpx));

  result:=Tdialog(pu).dlg.setId(id);
end;

function TextToBstring(st:AnsiString;var nb:integer):AnsiString;
var
  i,k:integer;
begin
  nb:=0;
  result:=st;
  for i:=1 to length(result) do
  if (result[i]=#10) or (result[i]=#13) then result[i]:=#0;

  k:=pos(#0#0,result);
  while k>0 do
  begin
    delete(result,k,1);
    k:=pos(#0#0,result);
  end;

  for i:=1 to length(result) do
  if (result[i]=#0)  then
  begin
    result[i]:='|';
    inc(nb);
  end;

  if (length(result)>0) and (result[length(result)]='|') then delete(result,length(result),1);
end;


function fonctionTdialog_getStringList1
         (titre:AnsiString;var option:typeUO; var x;tpx:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getStringList1_1(titre, option, x, tpx, 0, pu);
end;

function fonctionTdialog_getStringList1_1
         (titre:AnsiString;var option:typeUO; var x;tpx:integer;id:integer;var pu:typeUO):integer;
var
  stOp:AnsiString;
  nb:integer;
begin
  verifierDialogue(pu);
  verifierObjet(option);

  stOp:=TextToBstring( TstmMemo(option).stList.Text,nb);

  with Tdialog(pu) do
  begin
    Dlg.setEnumerated(titre,stOp,x,nbtoTT(tpx));
    result:=dlg.setId(id);
  end;
end;

function fonctionTdialog_getStringListA
         (titre,option:AnsiString;var x;tpx:integer;id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getStringList_2(titre, option, x, tpx, id, pu);
end;

function fonctionTdialog_getStringList1A
         (titre:AnsiString;var option:typeUO; var x;tpx:integer;id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getStringList1_1(titre, option, x, tpx, id, pu);
end;




procedure proTdialog_ModifyStringList(AnId:integer; titre,option:AnsiString;var pu:typeUO);
begin
  proTdialog_ModifyStringList_1(AnId, titre,option,'', pu);
end;

procedure proTdialog_ModifyStringList_1(AnId:integer; titre,option,values:AnsiString;var pu:typeUO);
var
  FlagString: boolean;
  ok: boolean;
  k,n,code:integer;
  st1: AnsiString;
  vv: TarrayOfInteger;
begin
  verifierObjet(pu);

  FlagString:=(values='');

  if not FlagString then
  begin
    ok:=true;
    repeat
      k:=0;
      while (k<length(values)) and (values[k+1]<>'|') do inc(k);
      if k>0 then
      begin
        st1:=copy(values,1,k);

        st1:=Fsupespace(st1);
        val(st1,n,code);
        if code<>0 then ok:=false;
        setlength(vv,length(vv)+1);
        vv[high(vv)]:=n;
        delete(values,1,k+1);
      end;
    until not ok or (length(values)=0);

    if ok
      then Tdialog(pu).dlg.ModifyEnumerated(AnId,titre,option,vv)
      else Tdialog(pu).Dlg.ModifyEnumerated(AnId,titre,Option);
  end
  else Tdialog(pu).Dlg.ModifyEnumerated(AnId,titre,Option);
end;





function fonctionTdialog_setText(titre:AnsiString;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_setText_2(titre,0,'',0,0,0,pu);
end;


function fonctionTdialog_setText_1(titre:AnsiString;id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_setText_2(titre,id,'',0,0,0,pu);
end;

function fonctionTdialog_setText_2(titre:AnsiString;id:integer;
                                   FontName:AnsiString;FontSize,FontColor,FontStyle:integer;
                                   var pu:typeUO):integer;pascal;
begin
  verifierDialogue(pu);

  with Tdialog(pu) do
  begin
    Dlg.setText(titre,FontName,FontSize,FontColor,FontStyle);
    result:=dlg.setId(id);
  end;
end;

function fonctionTdialog_setTextA(titre:AnsiString;id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_setText_2(titre,id,'',0,0,0,pu);

end;


procedure proTdialog_modifyText(id:integer;titre:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  Tdialog(pu).Dlg.modifyText(id,titre,'',0,0,0);
end;

procedure proTdialog_modifyText_1(id:integer;titre:AnsiString;
                               FontName:AnsiString;FontSize,FontColor,FontStyle:integer;
                               var pu:typeUO);
begin
  verifierObjet(pu);
  Tdialog(pu).Dlg.modifyText(id,titre,FontName,FontSize,FontColor,FontStyle);
end;

procedure proTdialog_modifyTextA(id:integer;titre:AnsiString;var pu:typeUO);
begin
  proTdialog_modifyText(id, titre, pu);
end;

function fonctionTdialog_getColor(titre:AnsiString;var x:longint;var pu:typeUO):integer;pascal;
begin
  result:= fonctionTdialog_getColor_1(titre, x, 0, pu);
end;

function fonctionTdialog_getColor_1(titre:AnsiString;var x:longint;id:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    Dlg.setColor(titre,x);
    result:=dlg.setId(id);
  end;
end;

function fonctionTdialog_getColorA(titre:AnsiString;var x:longint;id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getColor_1(titre, x, id, pu);
end;

function fonctionTdialog_getCommand(titre:AnsiString;mresult:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getCommand_1(titre,mresult,0,pu);
end;

function fonctionTdialog_getCommand_1(titre:AnsiString;mresult:integer;id:integer;var pu:typeUO):integer;
const
  x:boolean=false;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    Dlg.setCommand(titre,x,mresult);
    result:=dlg.setId(id);
  end;
end;

function fonctionTdialog_getCommandA
         (titre:AnsiString;mresult:integer;id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_getCommand_1(titre,mresult,id,pu);
end;

function fonctionTdialog_showModal(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tdialog(pu) do
  begin
    result:=showModal;
  end;
end;


procedure proTdialog_close(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu) do
  begin
    dlg.hide;
  end;
end;


procedure proTdialog_update(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu) do
  begin
    dlg.updateControls;
  end;
end;

procedure proTdialog_update_1(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu) do
  begin
    dlg.updateControl(num);
  end;
end;


procedure proTdialog_updatevar(var pu:typeUO);
begin
  verifierObjet(pu);
  Tdialog(pu).dlg.updateVars;
end;

procedure proTdialog_updatevar_1(num:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  Tdialog(pu).dlg.updateVar(num);
end;

procedure proTdialog_onChange(n:integer;w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,dlg.nbvar,E_numControl);
    dlg.ctrl[n].PgOnChange.setad(w);
  end;
end;

function fonctionTdialog_onChange(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,dlg.nbvar,E_numControl);
    result:=dlg.ctrl[n].PgOnChange.ad;
  end;
end;

procedure proTdialog_onDragDrop(n:integer;w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,dlg.nbvar,E_numControl);
    dlg.ctrl[n].PgOnDragDrop.setad(w);
  end;
end;

function fonctionTdialog_onDragDrop(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,dlg.nbvar,E_numControl);
    result:=dlg.ctrl[n].PgOnDragDrop.ad;
  end;
end;


procedure proTdialog_onEvent(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu) do
  begin
    dlg.PgOnEvent.setad(w);
  end;
end;

function fonctionTdialog_onEvent(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tdialog(pu) do
  begin
    result:=dlg.PgOnEvent.ad;
  end;
end;

procedure proTdialog_setButtons(bb:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu) do
  begin
    dlg.setButtons(bb);
  end;
end;

procedure proTdialog_AddScrollBar(min1,max1,dx1,dx2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    AddScrollBar(min1,max1,dx1,dx2);
  end;
end;

procedure proTdialog_ModifyScrollBarA(num:integer;min1,max1,dx1,dx2:float;var pu:typeUO);
var
  res:boolean;
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    res:=ModifyScrollBarA(num,min1,max1,dx1,dx2);
  end;
end;

procedure proTdialog_AddCheckBox(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    AddCheckBox;
  end;
end;

procedure proTdialog_SetCheckBox(idNum:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    setCheckBox(idNum);
  end;
end;


procedure proTdialog_SetReadOnly(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    SetReadOnly;
  end;
end;

procedure proTdialog_Checked(num:integer; w: boolean; var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    Checked[num]:=w;
  end;
end;

function fonctionTdialog_Checked(num:integer; var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    result:=Checked[num];
  end;
end;


procedure proTdialog_CheckedA(id:integer; w: boolean; var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    CheckedA[id]:=w;
  end;
end;

function fonctionTdialog_CheckedA(id:integer; var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    result:=CheckedA[id];
  end;
end;


procedure proTdialog_Enabled(num:integer; w: boolean; var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    Enabled[num]:=w;
  end;
end;

function fonctionTdialog_Enabled(num:integer; var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    result:=Enabled[num];
  end;
end;


procedure proTdialog_EnabledA(id:integer; w: boolean; var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    EnabledA[id]:=w;
  end;
end;

function fonctionTdialog_EnabledA(id:integer; var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    result:=EnabledA[id];
  end;
end;



procedure proTdialog_AddText(nbCar:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    AddText(nbcar);
  end;
end;

procedure proTdialog_Caption(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    caption:=st;
  end;
end;

function fonctionTdialog_Caption(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with Tdialog(pu).dlg do
  begin
    result:=caption;
  end;
end;





procedure Tdialog.setEmbedded(v: boolean);
begin
  Fembedded:=v;

  if v then dlg.InstallForm;
end;






function fonctionTdialog_setListBox
         (titre,options:AnsiString;nblig,nbcol,nbchar:integer;var x;sz:integer;tp:word; id:integer;var pu:typeUO):integer;
var
  stx:AnsiString;
  p,nb:integer;
begin
  verifierDialogue(pu);
  stx:=options;
  nb:=0;
  while stx<>'' do
  begin
    p:=pos('|',stx);
    if p=0 then p:=length(stx)+1;
    delete(stx,1,p);
    inc(nb);
  end;

  if nblig<1 then nblig:=1;
  if nblig>30 then nblig:=50;

  if nbcol<0 then nbcol:=0;
  if nbcol>30 then nbcol:=30;

  if (typeNombre(tp) in [nbByte,nbBoole]) then
  begin
    if sz<nb then sortieErreur('Tdialog.setListBox : invalid option number');
    Tdialog(pu).Dlg.setListBox(titre,options,nblig,nbcol,x,false,false,0,nbchar);
  end
  else
  if (typeNombre(tp)=nbLong)  then
  begin
    Tdialog(pu).Dlg.setListBox(titre,options,nblig,nbcol,x,true,false,1,nbchar);
  end
  else sortieErreur('Tdialog.setListBox : invalid data type');

  with Tdialog(pu) do
  begin
    with Dlg do ctrl[nbvar].Number:=id;
    result:=dlg.nbvar;
  end;

end;


function fonctionTdialog_setListBox_1
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol,nbchar:integer;var x: integer;
          id:integer;var pu:typeUO):integer;
var
  stOpt:AnsiString;
  nb:integer;
begin
  verifierDialogue(pu);

  verifierObjet(OptionMemo);
  stOpt:=TextToBstring( TstmMemo(optionMemo).stList.Text,nb);

  if nblig<1 then nblig:=1;
  if nblig>30 then nblig:=50;

  if nbcol<0 then nbcol:=0;
  if nbcol>30 then nbcol:=30;

  Tdialog(pu).Dlg.setListBox(titre,stOpt,nblig,nbcol,x,true,false,1,1);

  with Tdialog(pu) do
  begin
    with Dlg do ctrl[nbvar].Number:=id;
    result:=dlg.nbvar;
  end;
end;

function fonctionTdialog_setListBox_2
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol,nbchar:integer;var x;sz:integer;tp:word;
          id:integer;var pu:typeUO):integer;
var
  stOpt:AnsiString;
  nb:integer;
begin
  verifierDialogue(pu);

  verifierObjet(OptionMemo);
  stOpt:=TextToBstring( TstmMemo(optionMemo).stList.Text,nb);

  if nblig<1 then nblig:=1;
  if nblig>30 then nblig:=50;

  if nbcol<0 then nbcol:=0;
  if nbcol>30 then nbcol:=30;

  if (typeNombre(tp) in [nbByte,nbBoole]) then
  begin
    if sz<nb then sortieErreur('Tdialog.setListBox : invalid option number');
    Tdialog(pu).Dlg.setListBox(titre,stOpt,nblig,nbcol,x,false,false,0,nbchar);
  end
  else
  if (typeNombre(tp)=nbLong)  then
  begin
    Tdialog(pu).Dlg.setListBox(titre,stOpt,nblig,nbcol,x,true,false,1,nbchar);
  end
  else sortieErreur('Tdialog.setListBox : invalid data type');

  with Tdialog(pu) do
  begin
    with Dlg do ctrl[nbvar].Number:=id;
    result:=dlg.nbvar;
  end;
end;

function fonctionTdialog_setListBox1
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol:integer;var x;sz:integer;tp:word;
          id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_setListBox_2(titre,optionMemo,nblig,nbcol,1,x,sz,tp,id,pu);
end;

function fonctionTdialog_setListBox_3
         (titre,options:AnsiString;nblig,nbcol:integer;var x;sz:integer;tp:word; id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_setListBox(titre,options,nblig,nbcol,1, x,sz, tp, id, pu);
end;

function fonctionTdialog_setListBox_4
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol:integer;var x: integer;
          id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_setListBox_1(titre, optionMemo,nblig,nbcol,1, x, id, pu);
end;

function fonctionTdialog_setListBox_5
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol:integer;var x;sz:integer;tp:word;
          id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_setListBox_2(titre, optionMemo,nblig,nbcol,1, x, sz, tp, id, pu);
end;

function fonctionTdialog_setCheckListBox
         (titre,options:AnsiString;nblig,nbcol,nbchar:integer;var x;sz:integer;tp:word; id:integer;var pu:typeUO):integer;
var
  stx:AnsiString;
  p,nb:integer;
begin
  verifierDialogue(pu);
  stx:=options;
  nb:=0;
  while stx<>'' do
  begin
    p:=pos('|',stx);
    if p=0 then p:=length(stx)+1;
    delete(stx,1,p);
    inc(nb);
  end;

  if nblig<1 then nblig:=1;
  if nblig>30 then nblig:=50;

  if nbcol<0 then nbcol:=0;
  if nbcol>30 then nbcol:=30;

  if (typeNombre(tp) in [nbByte,nbBoole]) then
  begin
    if sz<nb then sortieErreur('Tdialog.setListBox : invalid option number');
    Tdialog(pu).Dlg.setListBox(titre,options,nblig,nbcol,x,false,true,0,nbchar);
  end
  else sortieErreur('Tdialog.setListBox : invalid data type');

  with Tdialog(pu) do
  begin
    with Dlg do ctrl[nbvar].Number:=id;
    result:=dlg.nbvar;
  end;

end;



function fonctionTdialog_setCheckListBox_1
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol,nbchar:integer;var x;sz:integer;tp:word;
          id:integer;var pu:typeUO):integer;
var
  stOpt:AnsiString;
  nb:integer;
begin
  verifierDialogue(pu);

  verifierObjet(OptionMemo);
  stOpt:=TextToBstring( TstmMemo(optionMemo).stList.Text,nb);

  if nblig<1 then nblig:=1;
  if nblig>50 then nblig:=50;

  if nbcol<0 then nbcol:=0;
  if nbcol>30 then nbcol:=30;

  if (typeNombre(tp) in [nbByte,nbBoole]) then
  begin
    if sz<nb then sortieErreur('Tdialog.setListBox : invalid option number');
    Tdialog(pu).Dlg.setListBox(titre,stOpt,nblig,nbcol,x,false,true,0,nbchar);
  end
  else sortieErreur('Tdialog.setListBox : invalid data type');

  with Tdialog(pu) do
  begin
    with Dlg do ctrl[nbvar].Number:=id;
    result:=dlg.nbvar;
  end;
end;

function fonctionTdialog_setCheckListBox_2
         (titre,options:AnsiString;nblig,nbcol:integer;var x;sz:integer;tp:word; id:integer;var pu:typeUO):integer;
begin
  result:= fonctionTdialog_setCheckListBox(titre,options,nblig,nbcol,1, x,sz,tp, id, pu);
end;

function fonctionTdialog_setCheckListBox_3
         (titre:AnsiString;var optionMemo:typeUO;nblig,nbcol:integer;var x;sz:integer;tp:word;
          id:integer;var pu:typeUO):integer; pascal;
begin
  result:= fonctionTdialog_setCheckListBox_1(titre,optionMemo,nblig,nbcol,1, x,sz,tp, id, pu);
end;









procedure proTdialog_dividePanel(num,nb:integer;vert:boolean;var pu:typeUO);
var
  mode:TpanelType;
begin
  verifierDialogue(pu);

  if (nb<=0) or (nb>100)
    then sortieErreur('Tdialog.dividePanel : invalid number of panels ');


  if vert then mode:=PTvert else mode:=PThor;
  with Tdialog(pu) do
  begin
    if not Dlg.DividePanel(mode,num,nb)
      then sortieErreur('Tdialog.dividePanel : invalid panel number');
  end;
end;

procedure proTdialog_dividePanel_1(stName:AnsiString;nb:integer;vert:boolean;var pu:typeUO);
var
  mode:TpanelType;
begin
  verifierDialogue(pu);

  if (nb<=0) or (nb>100)
    then sortieErreur('Tdialog.dividePanel : invalid number of panels ');


  if vert then mode:=PTvert else mode:=PThor;
  with Tdialog(pu) do
  begin
    if not Dlg.DividePanel(mode,stName,nb)
      then sortieErreur('Tdialog.dividePanel : invalid panel number');
  end;
end;

procedure proTdialog_AddGroupbox(st:AnsiString;var pu:typeUO);
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    if not Dlg.AddGroupBox(st) then
       sortieErreur('Tdialog.AddGroupBox error');
  end;
end;


procedure proTdialog_selectPanel(num:integer;var pu:typeUO);
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    if not Dlg.selectPanel(num)
      then sortieErreur('Tdialog.selectPanel : invalid panel number');
  end;
end;

procedure proTdialog_selectPanel_1(stName:AnsiString;var pu:typeUO);
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    if not Dlg.selectPanel(stName)
      then sortieErreur('Tdialog.selectPanel : invalid panel number');
  end;
end;


procedure proTdialog_setPanelProp(Fborder: boolean;Fbevel:integer;var pu:typeUO);
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    Dlg.setPanelProp(Fborder,Fbevel);
  end;
end;

procedure proTdialog_setPanelProp_1(Fborder: boolean;Fbevel:integer;Mleft,Mtop,Mright,Mbottom:integer ;var pu:typeUO);
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    Dlg.setPanelProp(Fborder,Fbevel,Mleft,Mtop,Mright,Mbottom);
  end;
end;

procedure proTdialog_setLineSpacing(n:integer;var pu:typeUO);
begin
  verifierDialogue(pu);
  if (n>=0) and (n<=100) then
    Tdialog(pu).Dlg.setLineSpacing(n);
end;


procedure proTdialog_DispatchMessages(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tdialog(pu) do
  begin
    Dlg.dispatchMsgs;
  end;
end;

procedure proDispatchMessages;
var
  msg:Tmsg;
  i:integer;
begin
  while peekMessage(Msg,0,0,0,pm_remove)  do
  begin
    if (msg.message=wm_keyup) and (msg.wparam=VK_Escape) and (getKeyState(vk_shift) and $8000<>0)
        then QuestionFinPg
    else
    begin
      translateMessage(msg);
      dispatchMessage(msg);
    end;
  end;
end;


procedure proTdialog_SplitPanel(num:integer;st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tdialog(pu) do
  begin
    if not Dlg.splitPanel(num,st,0)
      then sortieErreur('Tdialog.splitPanel : the panel is already splitted ');
  end;
end;

procedure proTdialog_SplitPanel_1(stName:AnsiString;st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tdialog(pu) do
  begin
    if not Dlg.splitPanel(stName,st,0)
      then sortieErreur('Tdialog.splitPanel : the panel is already splitted ');
  end;
end;

procedure proTdialog_SplitPanel_2(num:integer;nbTabs:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tdialog(pu) do
  begin
    if not Dlg.splitPanel(num,'',nbTabs)
      then sortieErreur('Tdialog.splitPanel : the panel is already splitted ');
  end;
end;

procedure proTdialog_SplitPanel_3(stName:AnsiString;nbTabs:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tdialog(pu) do
  begin
    if not Dlg.splitPanel(stName,'',nbTabs)
      then sortieErreur('Tdialog.splitPanel : the panel is already splitted ');
  end;
end;

procedure proTdialog_SelectPanelTab(num:integer;value:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tdialog(pu) do
  begin
    if not Dlg.SelectTab(num,value)
      then sortieErreur('Tdialog.SelectPanelTab : unable to select tab');
  end;
end;

procedure proTdialog_SelectPanelTab_1(stName:AnsiString;value:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tdialog(pu) do
  begin
    if not Dlg.SelectTab(stName,value)
      then sortieErreur('Tdialog.SelectPanelTab : unable to select tab');
  end;
end;



function fonctionTdialog_getDBInteger(titre:AnsiString;n,field:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,20,E_field);
    result:=getDBInteger(titre,n,0,field);
  end;
end;

function fonctionTdialog_getDBInteger_1(titre:AnsiString;n,field,id:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,20,E_field);
    result:=getDBInteger(titre,n,id,field);
  end;
end;

function fonctionTdialog_getDBInteger_2(titre:AnsiString;n:integer;FieldName:AnsiString;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBinteger : unable to find column number');

    result:=getDBInteger(titre,n,0,field);
  end;
  {$ENDIF}
end;

function fonctionTdialog_getDBInteger_3(titre:AnsiString;n:integer;fieldName:AnsiString;id:integer;var pu:typeUO):integer;
var
  field:integer;
begin
{$IFNDEF WIN64}
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBinteger : unable to find column number');

    result:=getDBInteger(titre,n,id,field);
  end;
{$ENDIF}
end;


function fonctionTdialog_getDBReal(titre:AnsiString;n,m,field:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,50,'Tdialog.getDBReal : invalid parameter');
    controleParam(m,0,20,'Tdialog.getDBReal : invalid number of decimal places');
    result:=getDBReal(titre,n,m,0,field);
  end;
end;

function fonctionTdialog_getDBReal_1(titre:AnsiString;n,m,field,id:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,50,'Tdialog.getDBReal : invalid parameter');
    controleParam(m,0,20,'Tdialog.getDBReal : invalid number of decimal places');

    result:=getDBReal(titre,n,m,id,field);
  end;
end;

function fonctionTdialog_getDBReal_2(titre:AnsiString;n,m:integer;FieldName:AnsiString;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    controleParam(n,1,50,'Tdialog.getDBReal : invalid parameter');
    controleParam(m,0,20,'Tdialog.getDBReal : invalid number of decimal places');

    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBReal : unable to find column number');

    result:=getDBReal(titre,n,m,0,field);
  end;
  {$ENDIF}
end;

function fonctionTdialog_getDBReal_3(titre:AnsiString;n,m:integer;fieldName:AnsiString;id:integer;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    controleParam(n,1,50,'Tdialog.getDBReal : invalid parameter');
    controleParam(m,0,20,'Tdialog.getDBReal : invalid number of decimal places');

    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBReal : unable to find column number');


    result:=getDBReal(titre,n,m,id,field);
  end;
  {$ENDIF}
end;

function fonctionTdialog_getDBRealString(titre,suffix:AnsiString;n,m,field:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,50,'Tdialog.getDBRealString : invalid parameter');
    controleParam(m,0,20,'Tdialog.getDBRealString : invalid number of decimal places');
    result:=getDBRealString(titre,suffix,n,m,0,field);
  end;
end;

function fonctionTdialog_getDBRealString_1(titre,suffix:AnsiString;n,m,field,id:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,50,'Tdialog.getDBRealString : invalid parameter');
    controleParam(m,0,20,'Tdialog.getDBRealString : invalid number of decimal places');

    result:=getDBRealString(titre,suffix,n,m,id,field);
  end;
end;

function fonctionTdialog_getDBRealString_2(titre,suffix:AnsiString;n,m:integer;FieldName:AnsiString;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    controleParam(n,1,50,'Tdialog.getDBRealString : invalid parameter');
    controleParam(m,0,20,'Tdialog.getDBRealString : invalid number of decimal places');

    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBRealString : unable to find column number');

    result:=getDBRealString(titre,suffix,n,m,0,field);
  end;
  {$ENDIF}
end;

function fonctionTdialog_getDBRealString_3(titre,suffix:AnsiString;n,m:integer;fieldName:AnsiString;id:integer;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    controleParam(n,1,50,'Tdialog.getDBRealString : invalid parameter');
    controleParam(m,0,20,'Tdialog.getDBRealString : invalid number of decimal places');

    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBRealString : unable to find column number');


    result:=getDBRealString(titre,suffix,n,m,id,field);
  end;
  {$ENDIF}
end;



function fonctionTdialog_getDBString(titre:AnsiString;n,field:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    if n<1 then sortieErreur('Field Width must be positive');
    result:=getDBString(titre,n,0,field);
  end;
end;

function fonctionTdialog_getDBString_1(titre:AnsiString;n,field,id:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    if n<1 then sortieErreur('Field Width must be positive');
    result:=getDBString(titre,n,id,field);
  end;
end;

function fonctionTdialog_getDBString_2(titre:AnsiString;n:integer;FieldName:AnsiString;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBstring : unable to find column number');

    if n<1 then sortieErreur('Field Width must be positive');
    result:=getDBString(titre,n,0,field);
  end;
  {$ENDIF}
end;

function fonctionTdialog_getDBString_3(titre:AnsiString;n:integer;fieldName:AnsiString;id:integer;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBstring : unable to find column number');

    if n<1 then sortieErreur('Field Width must be positive');
    result:=getDBString(titre,n,id,field);
  end;
  {$ENDIF}
end;

function fonctionTdialog_getDBBoolean(titre:AnsiString;field:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    result:=getDBBoolean(titre,0,field);
  end;
end;

function fonctionTdialog_getDBBoolean_1(titre:AnsiString;field,id:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    result:=getDBBoolean(titre,id,field);
  end;
end;

function fonctionTdialog_getDBBoolean_2(titre:AnsiString;FieldName:AnsiString;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBBoolean : unable to find column number');

    result:=getDBBoolean(titre,0,field);
  end;
  {$ENDIF}
end;

function fonctionTdialog_getDBBoolean_3(titre:AnsiString;fieldName:AnsiString;id:integer;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBBoolean : unable to find column number');

    result:=getDBBoolean(titre,id,field);
  end;
  {$ENDIF}
end;


function fonctionTdialog_getDBmemo(titre:AnsiString;n,Nline,flags,field:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    if n<1 then sortieErreur('Field Width must be positive');
    result:=getDBmemo(titre,n,Nline,flags,0,field);
  end;
end;

function fonctionTdialog_getDBmemo_1(titre:AnsiString;n,Nline,flags,field,id:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    if n<1 then sortieErreur('Field Width must be positive');
    result:=getDBmemo(titre,n,Nline,flags,id,field);
  end;
end;

function fonctionTdialog_getDBmemo_2(titre:AnsiString;n,Nline,flags:integer;FieldName:AnsiString;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBmemo : unable to find column number');

    if n<1 then sortieErreur('Field Width must be positive');
    result:=getDBmemo(titre,n,Nline,flags,0,field);
  end;
  {$ENDIF}
end;

function fonctionTdialog_getDBmemo_3(titre:AnsiString;n,Nline,flags:integer;fieldName:AnsiString;id:integer;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBmemo : unable to find column number');

    if n<1 then sortieErreur('Field Width must be positive');
    result:=getDBmemo(titre,n,Nline,flags,id,field);
  end;
  {$ENDIF}
end;



function fonctionTdialog_getDBdateTime(mode:integer;titre:AnsiString;n,field:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,50,E_field);
    result:=getDBdateTime(mode,titre,n,0,field);
  end;
end;

function fonctionTdialog_getDBdateTime_1(mode:integer;titre:AnsiString;n,field,id:integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,50,E_field);
    result:=getDBdateTime(mode,titre,n,id,field);
  end;
end;

function fonctionTdialog_getDBdateTime_2(mode:integer;titre:AnsiString;n:integer;FieldName:AnsiString;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBdateTime : unable to find column number');

    controleParam(n,1,20,E_field);
    result:=getDBdateTime(mode,titre,n,0,field);
  end;
  {$ENDIF}
end;

function fonctionTdialog_getDBdateTime_3(mode:integer;titre:AnsiString;n:integer;fieldName:AnsiString;id:integer;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBdateTime : unable to find column number');

    controleParam(n,1,20,E_field);
    result:=getDBdateTime(mode,titre,n,id,field);
  end;
  {$ENDIF}
end;


function fonctionTdialog_getDBStringList(titre,names,values: AnsiString; Field: integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    result:=getDBstringList(titre,names,values,0,field);
  end;
end;

function fonctionTdialog_getDBStringList_1(titre,names,values: AnsiString; Field, id: integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    result:=getDBstringList(titre,names,values,id,field);
  end;
end;

function fonctionTdialog_getDBStringList_2(titre,names,values: AnsiString; FieldName:AnsiString;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBstringList : unable to find column number');
    result:=getDBstringList(titre,names,values,0,field);
  end;
  {$ENDIF}
end;

function fonctionTdialog_getDBStringList_3(titre,names,values: AnsiString; FieldName:AnsiString; id:integer;var pu:typeUO):integer;
var
  field:integer;
begin
  verifierDialogue(pu);
  {$IFNDEF WIN64}
  with Tdialog(pu) do
  begin
    if assigned(DBresultset) and DBresultSet.isOpen
      then field:=getDBFieldNum(FieldName)
      else sortieErreur('TDialog.getDBstringList : unable to find column number');
    result:=getDBstringList(titre,names,values,id,field);
  end;
  {$ENDIF}
end;


function fonctionTdialog_getDBfield(nSt, n,m,Field: integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,50,E_field);
    result:=getDBfield(nSt,n,m,0,field);
  end;
end;

function fonctionTdialog_getDBfield_1(nSt, n,m,field,id: integer;var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    controleParam(n,1,50,E_field);
    result:=getDBfield(nSt,n,m,id,field);
  end;
end;


procedure proTdialog_setDBResultSet(var rset,pu:typeUO);
begin
  verifierObjet(pu);
  {$IFNDEF WIN64}
  Tdialog(pu).setResultSet(TDBresultSet(rset));
  {$ENDIF}
end;


function fonctionTdialog_getObject
         (titre:AnsiString;var x:TGvariant;n:integer;ClassId:AnsiString; var pu:typeUO):integer;
begin
  verifierDialogue(pu);
  with Tdialog(pu) do
  begin
    if n<0 then n:=0;
    Dlg.setObject(titre,x,n,classId);
    result:=dlg.nbvar;
  end;
end;

function fonctionTdialog_getObject_1
         (titre:AnsiString;var x:TGvariant;n:integer;ClassId:AnsiString;id:integer; var pu:typeUO):integer;
begin
  result:=fonctionTdialog_getObject(titre,x,n,ClassId,pu);
end;

function fonctionTdialog_font(var pu:typeUO):Tfont;
begin
  with Tdialog(pu).form do
  begin
    result:=Font;
  end;
end;

procedure proTdialog_setCursor(var pp:pointer;var pu:typeUO);
var
  curForm:TlineCursor;
begin
  verifierDialogue(pu);
  verifierObjet(typeUO(pp));

  Tdialog(pu).Dlg.setExtControl(pp);
end;


procedure proTdialog_DBcurrentRow(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tdialog(pu).DBcurRow:=n;
end;

function  fonctionTdialog_DBcurrentRow(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:=Tdialog(pu).DBcurRow;
end;


procedure proTdialog_DBsetValues(var db: TDBrecord; var pu:typeUO);pascal;
begin
  verifierObjet(pu);
  Tdialog(pu).storeToRowBuffer(db);
end;

procedure proTdialog_DBgetValues(var db: TDBrecord; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(db));
  Tdialog(pu).DBgetValues(db);
end;

procedure proTdialog_DBgetCheckedValues(var db: TDBrecord; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(db));
  Tdialog(pu).DBgetCheckedValues(db);
end;

procedure proTdialog_LineHeight(n:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  Tdialog(pu).Dlg.SetHline(n);
end;

function fonctionTdialog_LineHeight(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:=Tdialog(pu).Dlg.GetHline;
end;




Initialization
AffDebug('Initialization stmDlg',0);

installError(E_DlgInstalled,'Dialog box: Dialog already installed');
installError(E_field,'Dialog box: invalid field parameter');
installError(E_positionSaisie,'Dialog box: invalid position');
installError(E_deci,'Dialog box: invalid decimal places');
installError(E_string,'Dialog box: invalid String length');

installError(E_numControl,'Dialog box: invalid control number');
installError(E_poswin,'Dialog box: invalid position');

registerObject(Tdialog,sys);

end.
