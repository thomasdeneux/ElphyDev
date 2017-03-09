unit stmRestObject;

interface

uses classes,XMLIntf, XMLDoc,
     util1, RestObject,
     stmdef,stmObj,NcDef2,stmPg,
     DBtable1;

type
  TrestClient = class(typeUO)
                private
                  DbRowMax: array of integer;
                public
                  rest: TrestObject;
                  XMLres : IXMLDocument;
                  constructor create;override;
                  destructor destroy;override;
                  class function stmClassName:AnsiString;override;
                  procedure Init(host:AnsiString; port:Integer; username,password : AnsiString );
                  procedure Get(st: AnsiString);
                  procedure GetToDB(st: AnsiString;db: TDBtable);

                  procedure getFieldNode(stRoot:AnsiString;stl: TstringList;child: IXMLnode);
                  procedure getFieldList(stRoot:AnsiString;stl: TstringList;child: IXMLnode);
                  procedure getFields(stl: TstringList);

                  procedure getDBNode(stRoot:AnsiString;db: TDBtable;child: IXMLnode);
                  procedure getDBList(stRoot:AnsiString;db: TDBtable;child: IXMLnode);
                end;


procedure proTrestClient_create(host: AnsiString; port: Integer; username, password: AnsiString;var pu:typeUO);pascal;
procedure proTrestClient_Get(st: AnsiString;var db: TDBtable;var pu:typeUO);pascal;

implementation

{ TrestClient }

constructor TrestClient.create;
begin
  inherited;
end;

destructor TrestClient.destroy;
begin
  rest.Free;
  XMLres:=nil;

  inherited;
end;
(*
procedure TrestClient.FillDBtable(db: TDBtable);
var
  stL: TstringList;
  i,n,nbMax: integer;
  st:string;
begin

  stL:= TstringList.create;
  getFields(stL);

  nbMax:=0;
  for i:=0 to stL.count-1 do
  begin
    st:=stL[i];
    n:=intG(stL.Objects[i]);
    if n>nbMax then nbMax:=n;
    while pos('.',st)>0 do delete(st,1,pos('.',st));
    db.addField(st,gvstring);
  end;
  db.RowCount:=nbMax;

  getDBNode('',DB, XMLres.DocumentElement);
  DB.initform;
end;
*)

procedure TrestClient.Get(st: AnsiString);
begin
  XMLres := rest.doGet(st);
end;

procedure TrestClient.GetToDB(st: AnsiString;db: TDBtable);
begin
  db.XMLinfo.XML:= rest.doGet(st);
  if rest.ErrorString<>'' then sortieErreur(rest.ErrorString);
  db.XMLinfo.AnalyseXML;
end;


procedure TrestClient.Init(host: AnsiString; port: Integer; username, password: AnsiString);
begin
  rest:= TrestObject.Create(host, port, username, password);
end;

procedure TRestClient.getFieldNode(stRoot:AnsiString;stl: TstringList;child: IXMLnode);
var
  k:integer;
begin
  if stRoot<>''
    then stRoot:= stRoot+'.'+ Child.NodeName
    else stRoot:= Child.NodeName;

  if Child.HasChildNodes and not(Child.IsTextElement)
    then getFieldList(stRoot,stl, Child)
    else
    begin
      k:= stL.IndexOf(stRoot);
      if k<0 then stL.Addobject( stRoot,pointer(0))
             else stL.Objects[k]:=pointer(intG(stL.Objects[k])+1);

    end;
end;

procedure TRestClient.getFieldList(stRoot:AnsiString;stl: TstringList;child: IXMLnode);
var
  i:integer;
begin
  for i:= 0 to child.ChildNodes.Count-1 do
    getFieldNode(stRoot,stl,child.ChildNodes[i]);
end;

procedure TRestClient.getFields(stl: TstringList);
begin
  getFieldNode('',stl, XMLres.DocumentElement);
end;

procedure TRestClient.getDBNode(stRoot:AnsiString;db:TDBtable;child: IXMLnode);
var
  k:integer;
  st:AnsiString;
begin
  if stRoot<>''
    then stRoot:= stRoot+'.'+ Child.NodeName
    else stRoot:= Child.NodeName;

  if Child.HasChildNodes and not(Child.IsTextElement)
    then getDBList(stRoot,db, Child)
    else
    begin
      k:= db.Fields.IndexOf(stRoot);
      if k<0 then
      begin
        db.addField(stRoot,gvString);
        setlength(DbRowMax,db.fields.Count);
        k:= high(DbRowMax);
        DbRowMax[k]:=0;
      end
      else inc(DbRowMax[k]);

      if db.RowCount<=DbRowMax[k] then db.RowCount:= DbRowMax[k]+1;

      if Child.IsTextElement then db.Vstring[k,DbRowMax[k]] := Child.Text;
    end;
end;

procedure TRestClient.getDBList(stRoot:AnsiString;db:TDBtable;child: IXMLnode);
var
  i:integer;
begin
  for i:= 0 to child.ChildNodes.Count-1 do
    getDBNode(stRoot,db,child.ChildNodes[i]);
end;



class function TrestClient.stmClassName: AnsiString;
begin
  result:= 'RestClient';
end;

procedure proTrestClient_create(host: AnsiString; port: Integer; username, password: AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TrestClient);
  TrestClient(pu).Init(host, port, username, password);

end;

procedure proTrestClient_Get(st: AnsiString;var db: TDBtable;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(db));
  TrestClient(pu).GetToDB(st,db);
end;


end.
