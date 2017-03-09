unit stmDBgrid1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses  windows, classes, forms,grids, Controls, FrameTable1,
      util1,stmdef,stmObj,stmData0,EdResultSet2,stmDataBase2,Ncdef2,stmPG,
      DBtable1;

type
  TstmDBgrid= class(TDBtable)
              private
                DBresultSet:TDBresultSet;

              protected

                procedure setFirstColVisible(w:boolean);override;
                function getFirstColVisible:boolean;override;
                procedure setFirstRowVisible(w:boolean);override;
                function getFirstRowVisible:boolean;override;

                procedure setButton0(w:boolean);override;
                function getButton0:boolean;override;

                procedure setButtonsVisible(w:boolean);override;
                function getButtonsVisible:boolean;override;

                procedure setColumnWidths(n:integer;w:integer);override;
                function getColumnWidths(n:integer):integer;override;

                procedure setColumnVisible(n:integer;w:boolean);override;
                function getColumnVisible(n:integer):boolean;override;

                function getTableFrame:TTableFrame;override;

                procedure setRowCount(n:integer);override;
                function getRowCount:integer;override;

                function colCount:integer;override;

              public
                constructor create;override;
                destructor destroy;override;

                procedure createForm;override;
                procedure show(sender:Tobject);override;

                class function STMClassName:AnsiString;override;

                function NumColGrid(numColSet:integer):integer;

                procedure processMessage(id:integer;source:typeUO;p:pointer);override;
                procedure setResultSet(rs:TDBresultSet);


                function ActiveEmbedded(TheParent:TwinControl; x1,y1,w1,h1:integer): Trect;override;
                procedure UnActiveEmbedded;override;


                procedure InitForm;override;
                procedure invalidatedata;override;

                function GridForm: TEditResultSet2;
              end;

procedure proTDBgrid_create(var src:TDBresultSet;var pu:typeUO);pascal;

implementation

{ TstmDBgrid }

constructor TstmDBgrid.create;
begin
  inherited;
  createForm;
end;

destructor TstmDBgrid.destroy;
begin
  if assigned(Form) then GridForm.Destroying:=true;
  setResultSet(nil);
  inherited;
end;

class function TstmDBgrid.STMClassName: AnsiString;
begin
  result:='DBgrid';
end;

procedure TstmDBgrid.createForm;
begin
  form:=TEditResultSet2.create(formStm);
  form.formStyle:=fsStayOnTop;
  form.borderStyle:=bsSingle;

  GridForm.OnSelectCell0:=OnSelectCell;
  GridForm.OnDblClickCell0:=OnDblClickCell;

  GridForm.ButtonCell.UserOnClick:=OnClickButton;
  GridForm.tableFrame1.GetGridColor:=GetGridColor;
end;


function TstmDBgrid.NumColGrid(numColSet:integer):integer;
begin
  result:=numColSet-1;
  if FirstColVisible then inc(result);
  if button0 then inc(result);
end;

procedure TstmDBgrid.processMessage(id: integer; source: typeUO;
  p: pointer);
begin
  inherited;

  case id of
    UOmsg_invalidateData:
      begin
        if (DBresultset=source) then
          begin
            setResultSet(DBresultSet);
            messageToRef(UOmsg_invalidate,nil);
            Form.invalidate;
          end;
      end;


    UOmsg_destroy:
      begin
        if (DBresultSet=source) then
        begin
          setResultSet(nil);
          messageToRef(UOmsg_invalidate,nil);
          Form.Invalidate;
        end;
      end;
  end;
end;


procedure TstmDBgrid.setResultSet(rs: TDBresultSet);
var
  i,nmax:integer;
begin
  DerefObjet(typeUO(DBresultSet));
  DBresultSet:=rs;
  refObjet(DBresultSet);

  InitForm;
end;

procedure TstmDBgrid.show(sender: Tobject);
begin
  if not Embedded then
  begin
    Form.formStyle:=fsStayOnTop;
    Form.borderStyle:=bsSingle;
    Form.Show;
  end;
end;

procedure TstmDBgrid.setFirstColVisible(w: boolean);
begin
  with GridForm do FirstColVisible:=w;
  InitForm;
end;

function TstmDBgrid.getFirstColVisible: boolean;
begin
  result:=GridForm.FirstColVisible;
end;

procedure TstmDBgrid.setFirstRowVisible(w: boolean);
begin
  GridForm.FirstRowVisible:= w;
  InitForm;
end;

function TstmDBgrid.getFirstRowVisible: boolean;
begin
  result:=GridForm.FirstRowVisible;
end;

function TstmDBgrid.getButton0: boolean;
begin
  result:=GridForm.Fbutton0;
end;

procedure TstmDBgrid.setButton0(w: boolean);
begin
  GridForm.Fbutton0:=w;
end;

function TstmDBgrid.getColumnWidths(n: integer): integer;
begin
  result:=GridForm.ColumnWidths[n];
end;

procedure TstmDBgrid.setColumnWidths(n, w: integer);
begin
  GridForm.ColumnWidths[n]:=w;
end;

function TstmDBgrid.getColumnVisible(n: integer): boolean;
begin
  result:=not GridForm.ColHidden[n];
end;

procedure TstmDBgrid.setColumnVisible(n:integer; w: boolean);
begin
  GridForm.ColHidden[n]:= not w;
end;



function TstmDBgrid.getTableFrame: TTableFrame;
begin
  result:=GridForm.TableFrame1;
end;

function TstmDBgrid.GridForm: TEditResultSet2;
begin
  result:= TEditResultSet2(Form);
end;

procedure TstmDBgrid.setButtonsVisible(w: boolean);
begin
  GridForm.Panel1.visible:=w;
end;

function TstmDBgrid.getButtonsVisible: boolean;
begin
  result:=GridForm.Panel1.visible;
end;


function TstmDBgrid.ActiveEmbedded(TheParent:TwinControl; x1,y1,w1,h1:integer): Trect;
begin
  if Not gridForm.Destroying then
  with GridForm.BackPanel do
  begin
    parent:=TheParent;
    align:=alNone;
    setBounds(x1,y1,w1,h1);
    result:=rect(left,top,left+width-1,top+height-1);
  end;
end;

procedure TstmDBgrid.UnActiveEmbedded;
begin
  GridForm.BackPanel.Parent:= GridForm;
  GridForm.BackPanel.align:=alClient;
end;


procedure TstmDBgrid.InitForm;
begin
  if assigned(DBresultSet) and DBresultSet.isOpen
    then GridForm.init(DBresultSet)
    else GridForm.init(nil);

  removeMarks;
end;


procedure TstmDBgrid.invalidatedata;
begin
  initform;
  inherited;

end;

function TstmDBgrid.getRowCount: integer;
begin
  with GridForm do
  begin
    result:= tableFrame1.DrawGrid1.RowCount;
    if FirstRowVisible then dec(result);
  end;
end;

function TstmDBgrid.ColCount: integer;
begin
  if assigned(DBresultset)
    then result:= DBresultSet.colCount
    else result:=0;
end;

procedure TstmDBgrid.setRowCount(n: integer);
begin


end;



{******************************** Méthodes stm *******************************}

procedure proTDBgrid_create(var src:TDBresultSet;var pu:typeUO);
begin
  createPgObject('',pu,TstmDBgrid);
  if assigned(pu)
    then TstmDBgrid(pu).setResultSet(src);
end;




end.
