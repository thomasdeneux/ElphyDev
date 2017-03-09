unit DBrecord1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses  classes,
      util1,listG, stmdef,stmObj,NcDef2,stmPg,stmPopup,varconf1,
      memoForm,stmData0, debug0, doubleExt;


{ Rappel: avec TGvariant, le passage par valeur est interdit }
{
  DBrecord contient une stringList (fields) dont chaque nom est associé à un enregistrement TGvariant

  Les indices commencent à zéro

}

type
  TDBrecord=class(Tdata0)
            private
               stX:AnsiString;
               buf:PtabOctet;
               TotSize:integer;
               nbDeci:integer;
               Fupdate:boolean;
               Ffields:TstringList;
            public
               StId:AnsiString;
               Ferror:boolean;


               constructor create;override;
               destructor destroy;override;
               class function stmClassName:AnsiString;override;

               function fields: TstringList;virtual;

               procedure clearFields;
               function CheckField(name:AnsiString):integer;
               procedure AddField(name:AnsiString;tp:TGvariantType; const NoControl:boolean=false);

               procedure SetStringValue(name:AnsiString; value:string);
               procedure setIntegerValue(name:AnsiString; value:integer);
               procedure setFloatValue(name:AnsiString; value:Float);
               procedure setComplexValue(name:AnsiString; value:TFloatComp);
               procedure setBooleanValue(name:AnsiString; value:Boolean);

               procedure DeleteField(name:AnsiString);

               procedure AddItem(name: AnsiString; var gv: TGvariant; const NoControl:boolean=false);

               procedure setValue(name:AnsiString;var value:TGvariant);virtual;   // var est obligatoire
               function getValue(name:AnsiString):TGvariant;virtual;
               property value[name:AnsiString]:TGvariant read getValue;           // du coup, la prop est en lecture seule

               procedure setValue1(n:integer;var value:TGvariant);virtual;
               function getValue1(n:integer):TGvariant;virtual;
               property value1[n:integer]:TGvariant read getValue1;default;       // idem: impossible d'écrire write setValue1

               function Getvariant(n:integer): PGvariant;

               procedure setInteger(n:integer;value:integer);
               function getInteger(n:integer):integer;
               property Vinteger[n:integer]:integer read getInteger write setInteger;

               procedure setFloat(n:integer;value:Float);
               function getFloat(n:integer):Float;
               property VFloat[n:integer]:float read getFloat write setFloat;

               procedure setComplex(n:integer;value:TFloatComp);
               function getComplex(n:integer):TFloatComp;
               property Vcomplex[n:integer]:TfloatComp read getComplex write setComplex;

               procedure setString(n:integer;value:AnsiString);
               function getString(n:integer):AnsiString;
               property Vstring[n:integer]:AnsiString read getString write setString;

               procedure setBoolean(n:integer;value:Boolean);
               function getBoolean(n:integer):Boolean;
               property VBoolean[n:integer]:Boolean read getBoolean write setBoolean;

               procedure setFchecked(n:integer;value:Boolean);
               function getFchecked(n:integer):Boolean;
               property Fchecked[n:integer]:Boolean read getFchecked write setFchecked;


               procedure setDateTime(n:integer;value:TDateTime);
               function getDateTime(n:integer):TDateTime;
               property VDateTime[n:integer]:TDateTime read getDateTime write setDateTime;

               procedure assign(var db:TDBrecord);

               procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
               procedure CompleteLoadInfo;override;
               procedure CompleteSaveInfo;override;

               function count:integer;
               function getInfo:AnsiString;override;

               function getText(const nbDeci:integer=3):AnsiString;

               procedure createForm;override;
               procedure invalidate;override;
               procedure UpdateForm1;
            end;


procedure proTDBrecord_create(var pu:typeUO);pascal;

procedure proTDBrecord_ImplicitValue(st:AnsiString;var x:TGvariant;var pu:typeUO);pascal;
function fonctionTDBrecord_ImplicitValue(st:AnsiString;var pu:typeUO):TGvariant;pascal;

procedure proTDBrecord_Value(col:integer;var x:TGvariant;var pu:typeUO);pascal;
function fonctionTDBrecord_Value(col:integer;var pu:typeUO):TGvariant;pascal;


procedure proTDBrecord_AddField(st:AnsiString;tp:integer;var pu:typeUO);pascal;
procedure proTDBrecord_DeleteField(st:AnsiString;var pu:typeUO);pascal;

procedure proTDBrecord_clear(var pu:typeUO);pascal;
function fonctionTDBrecord_FieldExists(st:AnsiString;var pu:typeUO):boolean;pascal;
function fonctionTDBrecord_FieldIndex(st:AnsiString;var pu:typeUO):integer;pascal;

function fonctionTDBrecord_count(var pu:typeUO):integer;pascal;
function fonctionTDBrecord_Vtype(n:integer;var pu:typeUO):integer;pascal;
function fonctionTDBrecord_Names(n:integer;var pu:typeUO):AnsiString;pascal;
function fonctionTDBrecord_ValString(n:integer;var pu:typeUO):AnsiString;pascal;


function fonctionTDBrecord_Text_1(nbDeci:integer;var pu:typeUO):AnsiString;pascal;
function fonctionTDBrecord_Text(var pu:typeUO):AnsiString; pascal;


implementation

{ TDBrecord }



function TDBrecord.fields: TstringList;
begin
  result:=Ffields;
end;

procedure TDBrecord.AddField(name: AnsiString; tp: TGvariantType; const NoControl:boolean=false);
var
  Pvariant:PGvariant;
begin
  Ferror:=( fields.IndexOf(name)>=0) and (NoControl=false);
  if Ferror then exit;

  new(Pvariant);
  fillchar(Pvariant^,sizeof(Pvariant^),0);
  Pvariant^.VType:=tp;
  fields.AddObject(name,Tobject(Pvariant));
  Fupdate:=true;
end;


procedure TDBrecord.AddItem(name: AnsiString; var gv: TGvariant; const NoControl:boolean=false);
var
  Pvariant:PGvariant;
begin
  Ferror:=( fields.IndexOf(name)>=0) and (NoControl=false);
  if Ferror then exit;

  new(Pvariant);
  fillchar(Pvariant^,sizeof(Pvariant^),0);
  CopyGvariant(gv,Pvariant^);

  fields.AddObject(name,Tobject(Pvariant));
  Fupdate:=true;
end;


procedure TDBrecord.DeleteField(name: AnsiString);
var
  i:integer;
begin
  i:=Ffields.IndexOf(name);
  if i>=0 then
  begin
    PGvariant(Ffields.Objects[i])^.VString:='';
    freemem(pointer(Ffields.Objects[i]));
    Ffields.Delete(i);
  end;
  Fupdate:=true;
end;

procedure TDBrecord.clearFields;
var
  i:integer;
begin
  for i:=0 to Ffields.Count-1 do
  begin
    PGvariant(Ffields.Objects[i])^.VString:='';
    freemem(pointer(Ffields.Objects[i]));
  end;
  Ffields.clear;
  Fupdate:=true;
end;

constructor TDBrecord.create;
begin
  inherited;
  Ffields:=Tstringlist.create;
  nbDeci:=3;
end;

destructor TDBrecord.destroy;
begin
  ClearFields;
  Ffields.free;
  inherited;
end;

class function TDBrecord.stmClassName: AnsiString;
begin
  result:='DBrecord';
end;

function TDBrecord.getValue(name: AnsiString): TGvariant;
var
  i:integer;
  st:AnsiString;
begin
  i:=fields.IndexOf(name);
  if i>=0 then copyGVariant(PGvariant(fields.Objects[i])^,result);
  FError:=(i<0);
end;

function TDBrecord.CheckField(name:AnsiString):integer;
var
  i:integer;
begin
  i:=fields.IndexOf(name);
  if (i<0) then
  begin
    addField(name,gvNull);
    i:=fields.Count-1;
  end;
  result:=i;
end;

procedure TDBrecord.setValue(name: AnsiString; var value: TGvariant);
var
  i:integer;
  p:PGvariant;
begin
  i:=CheckField(Name);

  p:=PGvariant(fields.Objects[i]);
  copyGvariant(value,PGvariant(fields.Objects[i])^);
  p^.Fchecked:=false;

  Fupdate:=true;
end;

procedure TDBrecord.SetStringValue(name: AnsiString; value: string);
var
  i:integer;
begin
  i:=CheckField(Name);
  setString(i,value);
end;

procedure TDBrecord.setBooleanValue(name: AnsiString; value: Boolean);
var
  i:integer;
begin
  i:=CheckField(Name);
  setBoolean(i,value);
end;


procedure TDBrecord.setComplexValue(name: AnsiString; value: TFloatComp);
var
  i:integer;
begin
  i:=CheckField(Name);
  setComplex(i,value);
end;

procedure TDBrecord.setFloatValue(name: AnsiString; value: Float);
var
  i:integer;
begin
  i:=CheckField(Name);
  setFloat(i,value);
end;

procedure TDBrecord.setIntegerValue(name: AnsiString; value: integer);
var
  i:integer;
begin
  i:=CheckField(Name);
  setInteger(i,value);
end;


function TDBrecord.getValue1(n: integer): TGvariant;
begin
  Ferror:=(n<0) or (n>=fields.Count);
  result.init;
  if not Ferror then copyGVariant(PGvariant(fields.Objects[n])^,result);
end;

function TDBrecord.Getvariant(n: integer): PGvariant;
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror
    then result:= PGvariant(fields.Objects[n])
    else result:=nil;
end;


procedure TDBrecord.setValue1(n: integer; var value: TGvariant);
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then
  begin
    copyGVariant(value,PGvariant(fields.Objects[n])^);
    PGvariant(fields.Objects[n])^.Fchecked:=false;
  end;
  Fupdate:=true;
end;



function TDBrecord.getBoolean(n: integer): Boolean;
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then result:=PGvariant(fields.Objects[n])^.VBoolean;
end;

function TDBrecord.getDateTime(n: integer): TDateTime;
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then result:=PGvariant(fields.Objects[n])^.VdateTime;

end;



function TDBrecord.getFloat(n: integer): Float;
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then result:=PGvariant(fields.Objects[n])^.Vfloat;
end;

function TDBrecord.getComplex(n: integer): TFloatComp;
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then result:=PGvariant(fields.Objects[n])^.Vcomplex;
end;

function TDBrecord.getInteger(n: integer): integer;
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then result:=PGvariant(fields.Objects[n])^.Vinteger;
end;

function TDBrecord.getString(n: integer): AnsiString;
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then result:=PGvariant(fields.Objects[n])^.Vstring;
end;

procedure TDBrecord.setBoolean(n: integer; value: Boolean);
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then
  with PGvariant(fields.Objects[n])^ do
  begin
    Vstring:='';
    Vtype:=gvBoolean;
    Vboolean:=value;
    Fchecked:=false;
  end;
end;

procedure TDBrecord.setDateTime(n: integer; value: TDateTime);
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then
  with PGvariant(fields.Objects[n])^ do
  begin
    Vstring:='';
    Vtype:=gvDateTime;
    VdateTime:=value;
    Fchecked:=false;
  end;
end;

procedure TDBrecord.setFloat(n: integer; value: Float);
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then
  with PGvariant(fields.Objects[n])^ do
  begin
    Vstring:='';
    Vtype:=gvFloat;
    Vfloat:=value;
    Fchecked:=false;
  end;
end;

procedure TDBrecord.setComplex(n: integer; value: TFloatComp);
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then
  with PGvariant(fields.Objects[n])^ do
  begin
    Vstring:='';
    Vtype:=gvComplex;
    VComplex:=value;
    Fchecked:=false;
  end;
end;

procedure TDBrecord.setInteger(n, value: integer);
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then
  with PGvariant(fields.Objects[n])^ do
  begin
    Vstring:='';
    Vtype:=gvInteger;
    Vinteger:=value;
    Fchecked:=false;
  end;
end;

procedure TDBrecord.setString(n: integer; value: AnsiString);
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then
  with PGvariant(fields.Objects[n])^ do
  begin
    Vtype:=gvString;
    Vstring:=value;
    Fchecked:=false;
  end;
end;

function TDBrecord.getFchecked(n: integer): Boolean;
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then result:=PGvariant(fields.Objects[n])^.Fchecked;
end;

procedure TDBrecord.setFchecked(n: integer; value: Boolean);
begin
  Ferror:=(n<0) or (n>=fields.Count);
  if not Ferror then
  PGvariant(fields.Objects[n])^.Fchecked:=value;
end;



procedure TDBrecord.assign(var db: TDBrecord);
var
  i:integer;
  Pvariant:PGvariant;
begin
  clearFields;
  fields.Text:=db.fields.Text;
  for i:=0 to db.fields.Count-1 do
  begin
    new(Pvariant);
    fillchar(Pvariant^,sizeof(Pvariant^),0);
    copyGVariant(PGvariant(db.fields.objects[i])^,Pvariant^);
    fields.Objects[i]:=pointer(Pvariant);
  end;
end;




procedure TDBrecord.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
var
  i,n,sz,len:integer;
  tpDum: TGvariantType;
begin
  inherited;
  if not lecture then
  begin
    stX:=fields.Text;
    TotSize:=0;
    for i:=0 to count-1 do
      TotSize:=TotSize+value1[i].UdiskSize +1 ;      {1 octet pour le type }

    getmem(buf,TotSize);
    n:=0;
    for i:=0 to count-1 do
    with value1[i] do
    begin
      {$IFDEF WIN64}
      if rec.Vtype =gvFloat then tpDum:=gvDouble
      else
      if rec.Vtype =gvComplex then tpDum:=gvDcomplex
      else
      tpDum:=rec.Vtype;
      {$ELSE}
      tpDum:=rec.Vtype;
      {$ENDIF}

      move(tpDum,buf^[n],1);
      inc(n);
      sz:=UdiskSize;
      case rec.Vtype of
        gvBoolean: move(rec.Vboolean, buf^[n],sz);
        gvInteger: move(rec.Vinteger, buf^[n],sz);
        {
        gvFloat:   doubleToExtended(rec.Vfloat,buf^[n]);
        gvComplex: begin
                     doubleToExtended(rec.Vcomplex.x,buf^[n]);
                     doubleToExtended(rec.Vcomplex.y,buf^[n+10]);
                   end;
        }
        gvFloat:   move(rec.Vfloat, buf^[n],sz);
        gvComplex: move(rec.Vcomplex, buf^[n],sz);

        gvString:  begin
                      len:=length(rec.VString);
                      move(len, buf^[n],4);
                      inc(n,4);
                      if len>0 then move(rec.Vstring[1], buf^[n],len);
                      sz:=sz-4;
                   end;
        gvDateTime:move(rec.VdateTime, buf^[n],sz);
      end;
      inc(n,sz);
    end;

  end;

  if lecture or (stID<>'') then  conf.setStringConf('stId',stId);
  conf.setStringConf('ST',stX);
  conf.setDynConf('BUF',buf,TotSize);
end;


function TDBrecord.count: integer;
begin
  result:=fields.Count;
end;

procedure TDBrecord.CompleteLoadInfo;
var
   i,len:integer;
   Gvariant:PGvariant;
   p:pointer;
   st:AnsiString;
   xa,ya:double;
   fcomp:TfloatComp;
begin
  inherited;

  Clearfields;
  fields.Text:=stX;
  stX:='';
  p:=buf;

  for i:=0 to count-1 do
  begin
    new(Gvariant);
    Gvariant^.init;
    fields.Objects[i]:=pointer(Gvariant);

    case TGVariantType(p^) of
      gvBoolean: begin
                   inc(intG(p));
                   Vboolean[i]:=Pboolean(p)^;
                   inc(intG(p));
                 end;
      gvInteger: begin
                   inc(intG(p));
                   Vinteger[i]:=Pint64(p)^;
                   inc(intG(p),8);
                 end;
      {$IFDEF WIN64}
      gvFloat:   begin                                    // extended venant de la 32 bits
                   inc(intG(p));
                   Vfloat[i]:=ExtendedToDouble(p^);
                   inc(intG(p),10);
                 end;
      gvComplex: begin
                   inc(intG(p));
                   xa:= ExtendedToDouble(p^);
                   inc(intG(p),10);
                   ya:= ExtendedToDouble(p^);
                   inc(intG(p),10);
                   Vcomplex[i]:=FloatComp(xa,ya);
                 end;
      gvDouble:  begin
                   inc(intG(p));
                   Vfloat[i]:=Pdouble(p)^;
                   inc(intG(p),8);
                 end;
      gvDComplex:begin
                   inc(intG(p));
                   Vcomplex[i] :=PfloatComp(p)^;
                   inc(intG(p),16);
                 end;

      {$ELSE}
      gvFloat:   begin
                   inc(intG(p));
                   Vfloat[i]:=Pfloat(p)^;
                   inc(intG(p),10);
                 end;
      gvComplex: begin
                   inc(intG(p));
                   Vcomplex[i]:=PfloatComp(p)^;
                   inc(intG(p),20);
                 end;

      gvDouble:  begin
                   inc(intG(p));
                   Vfloat[i]:=Pdouble(p)^;
                   inc(intG(p),8);
                 end;
      gvDComplex:begin
                   inc(intG(p));

                   fcomp.x:= PDoubleComp(p)^.x;
                   fcomp.y:= PDoubleComp(p)^.y;

                   Vcomplex[i] := fcomp;
                   inc(intG(p),16);
                 end;

      {$ENDIF}


      gvString:  begin
                   inc(intG(p));
                   len:=Plongint(p)^;
                   inc(intG(p),4);
                   setLength(st,len);
                   move(Pansistring(p)^,st[1],len);
                   inc(intG(p),len);
                   Vstring[i]:=st;
                 end;

      gvDateTime:begin
                   inc(intG(p));
                   VdateTime[i]:=PdateTime(p)^;
                   inc(intG(p),sizeof(TdateTime));
                 end;
    end;
  end;

  freemem(buf);
  buf:=nil;
  totSize:=0;
end;

procedure TDBrecord.CompleteSaveInfo;
begin
  freemem(buf);
  buf:=nil;
  totSize:=0;
  stX:='';
end;

function TDBrecord.getInfo: AnsiString;
var
  i:integer;
begin
  result:=inherited getInfo+crlf;
  for i:=0 to count-1 do
    result:=result+CRLF+fields[i]+'='+value1[i].getValString;
end;

function TDBrecord.getText(const nbDeci:integer=3):AnsiString;
var
  i:integer;
begin
  result:='';
  for i:=0 to count-1 do
  begin
    if result<>'' then result:=result+crlf;
    result:=result+fields[i]+' = '+value1[i].getValString(nbDeci);
  end;
end;


procedure TDBrecord.createForm;
begin
  form:=TviewText.Create(formStm);
  with TviewText(form) do
  begin
    Caption:=ident;
    OnShowWin:= UpdateForm1;
  end;
end;


procedure TDBrecord.invalidate;
begin
  if assigned(form) then TviewText(form).Memo1.Text:=getText(NbDeci);
  invalidateForm;
end;

procedure TDBrecord.UpdateForm1;
begin
    Fupdate:=false;
    invalidate;
end;


{ Méthodes stm de TDBrecord }

procedure proTDBrecord_create(var pu:typeUO);
begin
  createPgObject('',pu,TDBrecord);
end;

procedure proTDBrecord_ImplicitValue(st:AnsiString;var x:TGvariant;var pu:typeUO);
begin
  verifierObjet(pu);

  TDBrecord(pu).setvalue(st,x);

  if TDBrecord(pu).Ferror
    then sortieErreur('TDBrecord.ImplicitValue : unable to create field '+st);

end;

function fonctionTDBrecord_ImplicitValue(st:AnsiString;var pu:typeUO):TGvariant;
begin
  verifierObjet(pu);
  result:=TDBrecord(pu).value[st];
  if TDBrecord(pu).Ferror then sortieErreur('TDBrecord.ImplicitValue : field does not exist');
end;


procedure proTDBrecord_Value(col:integer;var x:TGvariant;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBrecord(pu).setvalue1(col-1,x);
  if TDBrecord(pu).Ferror then sortieErreur('TDBrecord.Value : field does not exist');
end;


function fonctionTDBrecord_Value(col:integer;var pu:typeUO):TGvariant;
begin
  verifierObjet(pu);
  result:=TDBrecord(pu).value1[col-1];
  if TDBrecord(pu).Ferror then sortieErreur('TDBrecord.Value : field does not exist');
end;


procedure proTDBrecord_AddField(st:AnsiString;tp:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (tp<intG(low(TGvariantType))) or (tp>intG(high(TGvariantType)))
    then sortieErreur('TDBrecord.AddField : invalid type');

  TDBrecord(pu).AddField(st,TGvariantType(tp));
  if TDBrecord(pu).Ferror then sortieErreur('TDBrecord.AddField : field already exists');
end;

procedure proTDBrecord_DeleteField(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBrecord(pu).DeleteField(st);
  if TDBrecord(pu).Ferror then sortieErreur('TDBrecord.DeleteField : field does not exist');
end;

procedure proTDBrecord_clear(var pu:typeUO);
begin
  verifierObjet(pu);
  TDBrecord(pu).clearFields;
end;

function fonctionTDBrecord_FieldExists(st:AnsiString;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TDBrecord(pu) do
  result:= Fields.IndexOf(st)>=0;
end;

function fonctionTDBrecord_FieldIndex(st:AnsiString;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDBrecord(pu) do
  result:= Fields.IndexOf(st) +1;
end;

function fonctionTDBrecord_count(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDBrecord(pu) do
  result:= Fields.count;
end;

function fonctionTDBrecord_Vtype(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDBrecord(pu) do
  if (n>=1) and (n<=fields.count)
    then result:= ord(value1[n-1].Vtype)
    else sortieErreur('TDBrecord.Vtype : index out of range');
end;


function fonctionTDBrecord_Names(n:integer;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TDBrecord(pu) do
  if (n>=1) and (n<=fields.count)
    then result:= Fields[n-1]
    else sortieErreur('TDBrecord.Names : index out of range');
end;

function fonctionTDBrecord_ValString(n:integer;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TDBrecord(pu) do
  if (n>=1) and (n<=fields.count)
    then result:= value1[n-1].getValString
    else sortieErreur('TDBrecord.ValString : index out of range');
end;

procedure proTDBrecord_Checked(n:integer;w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  TDBrecord(pu).Fchecked[n-1]:=w;
  if TDBrecord(pu).Ferror then sortieErreur('TDBrecord.Checked : field does not exist');
end;

function fonctionTDBrecord_Checked(n:integer;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TDBrecord(pu).Fchecked[n-1];
  if TDBrecord(pu).Ferror then sortieErreur('TDBrecord.checked : field does not exist');
end;

function fonctionTDBrecord_Text_1(nbDeci:integer;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TDBrecord(pu) do
    result:= getText(nbdeci);
end;

function fonctionTDBrecord_Text(var pu:typeUO):AnsiString;
begin
  result:= fonctionTDBrecord_Text_1(3, pu);
end;

Initialization
AffDebug('Initialization DBrecord1',0);

registerObject(TDBrecord,sys);


end.
