unit stmMemo1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,forms,controls,menus,stdCtrls,
     editcont,ComCtrls,

     util1,Gdos,DdosFich,Dgraphic,
     Dpalette,Ncdef2,formMenu,

     stmDef,stmObj,
     varconf1,stmPlot1,FMemo1,
     debug0,
     stmError,stmPg;

type
  TstmMemo=class(TPlot)
           private
              stf:AnsiString;            // sauvegarde uniquement
              descFont:TfontDescriptor;
              MyFont: Tfont;
              MyCaption: AnsiString;
              FPanelVisible: boolean;

              FlagChange:boolean;
              FextMemo:Tmemo;

              procedure setLine(i:integer;st:AnsiString);
              function getLine(i:integer):AnsiString;

              procedure onChangeD(sender:Tobject);
              procedure ChangeXD(sender:Tobject;bt:TUDBtnType);
              procedure ChangeYD(sender:Tobject;bt:TUDBtnType);

              procedure updateFormText;
              procedure setPanelVisible(w:boolean);
           public
              stList: TstringList;

              Xpos,Ypos:single;

              function TheList: Tstrings;
              procedure init(memo1:Tmemo);
              constructor create;override;


              destructor destroy;override;


              class function STMClassName:AnsiString;override;

              procedure display; override;
              function getTitle:AnsiString;override;

              procedure createForm;override;
              procedure invalidateForm;override;

              procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
                override;

              procedure completeLoadInfo;override;

              property lines[i:integer]:AnsiString read getLine write setLine ;

              procedure insertLine(i:integer;st:AnsiString);
              procedure deleteLine(i:integer);

              function withInside:boolean;override;

              procedure setEmbedded(v: boolean);override;
              function ActiveEmbedded(TheParent: TwinControl; x1, y1, w1,h1: integer): Trect;override;
              procedure UnActiveEmbedded;override;

              property PanelVisible:boolean read FpanelVisible write setPanelVisible;

              procedure Addline(st:AnsiString);
              procedure clear;override;

            end;


procedure proTmemo_create(stName:AnsiString;var pu:typeUO);pascal;
procedure proTmemo_create_1(var pu:typeUO);pascal;
procedure proTmemo_create_2(w: boolean;var pu:typeUO);pascal;

procedure proTmemo_lines(num:integer;st:AnsiString;var pu:typeUO);pascal;
function fonctionTmemo_lines(num:integer;var pu:typeUO):AnsiString;pascal;

function fonctionTmemo_font(var pu:typeUO):pointer;pascal;

procedure proTmemo_Insert(num:integer;st:AnsiString;var pu:typeUO);pascal;
procedure proTmemo_delete(num:integer;var pu:typeUO);pascal;

function fonctionTmemo_X(var pu:typeUO):float;pascal;
procedure proTmemo_X(x:float;var pu:typeUO);pascal;
function fonctionTmemo_Y(var pu:typeUO):float;pascal;
procedure proTmemo_Y(x:float;var pu:typeUO);pascal;

procedure proTmemo_addLine(st:AnsiString;var pu:typeUO);pascal;
procedure proTmemo_clear(var pu:typeUO);pascal;

function fonctionTmemo_count(var pu:typeUO):integer;pascal;
procedure proTmemo_count(n:integer;var pu:typeUO);pascal;

function fonctionTmemo_text(var pu:typeUO):AnsiString;pascal;
procedure proTmemo_text(x:AnsiString;var pu:typeUO);pascal;

function fonctionTmemo_LoadFromFile(stF:AnsiString;var pu:typeUO):boolean;pascal;
function fonctionTmemo_SaveToFile(stF:AnsiString;var pu:typeUO):boolean;pascal;

function fonctionTmemo_caption(var pu:typeUO):AnsiString;pascal;
procedure proTmemo_caption(x:AnsiString;var pu:typeUO);pascal;

function fonctionTmemo_PanelVisible(var pu:typeUO): Boolean;pascal;
procedure proTmemo_PanelVisible(x:boolean;var pu:typeUO);pascal;


implementation

procedure TstmMemo.init(memo1:Tmemo);
begin
  descFont.init;
  FExtMemo:=memo1;
  //if not assigned(FextMemo) then createForm;
  MyCaption:= ident;
end;

constructor TstmMemo.create;
begin
  inherited;
  stList:=TstringList.create;
  MyFont:=Tfont.create;
  PanelVisible:=true;
end;


destructor TstmMemo.destroy;
begin
  inherited destroy;
  stList.free;
  MyFont.free;
end;

procedure TstmMemo.createForm;
begin
  form:=TstmMemoForm.create(formStm);

  flagChange:=true;
  with TstmMemoForm(form) do
  begin
    caption:=MyCaption;
    fontS:= MyFont;

    Panel1.Visible:= PanelVisible;

    memo1.text:=TheList.Text;
    memo1.Font.Assign(MyFont);
    memo1.onChange:=onChangeD;
    Bvalidate.OnClick:=onChangeD;

    enX.setVar(Xpos, t_single);
    enY.setVar(Ypos, t_single);

    UpDownX.onClick:=ChangeXD;
    UpDownY.onClick:=ChangeYD;

  end;
  flagChange:=false;
end;

procedure TstmMemo.invalidateForm;
begin
  if assigned(form) then TstmMemoForm(form).invalidate;
end;



class function TstmMemo.STMClassName:AnsiString;
begin
  STMClassName:='Memo';
end;


procedure TstmMemo.display;
var
  x1,y1,x2,y2:integer;
  oldFont:Tfont;
  oldColor,oldSize:integer;
  i,h:integer;
  xx,yy,x,y,x0,y0:integer;
  st:AnsiString;
begin
  getWindowG(x1,y1,x2,y2);

  xx:=x2-x1;
  yy:=y2-y1;

  oldFont:=canvasGlb.font;

  oldColor:=Myfont.color;
  oldSize:= Myfont.size;

  if PRprinting then
  begin
    oldColor:= Myfont.color;
    oldSize:=  Myfont.size;

    Myfont.size:=round(Myfont.size*PRfontMag);
    if PRmonochrome then Myfont.color:=clBlack;
  end;

  canvasGlb.font:= Myfont;

  with canvasGlb do
  begin
    if true{transparent} then
      begin
        {brush.style:=bsClear;}
        //windows.setBKmode(canvasGlb.handle,windows.transparent);
        {sans cette ligne, l'affichage fonctionne mais pas l'impression}
      end
      else
        begin
          brush.style:=bsSolid;
          brush.color:=clBlack{BKcolor};
        end;

    h:=canvasGlb.textHeight('M1y');
    i:=0;

    x0:=round(xx*Xpos/100);
    y0:=round(yy*Ypos/100);

    x:=1+x0;
    y:=1+y0;


    while (i<=TheList.count-1) and (y+h<yy) do
    begin
      st:=TheList[i];
      while (st<>'') and (canvasGlb.textWidth(st)>=xx) do system.delete(st,length(st),1);
      textOutG(1+x0,1+y0+i*h,st);
      inc(y,h);
      inc(i);
    end;

  end;

  if PRprinting then
    begin
      Myfont.color:=oldColor;
      Myfont.size:=oldSize;
    end;

  canvasGlb.font:=oldFont;
end;

procedure TstmMemo.onChangeD(sender:Tobject);
begin
  if FlagChange then exit;

  UpdateAllVar(TstmMemoForm(form));
  TheList.text:= TstmMemoForm(form).Memo1.Text;
  messageToRef(UOmsg_invalidate,nil);
end;

procedure TstmMemo.ChangeXD(sender:Tobject;bt:TUDBtnType);
begin
  if FlagChange then exit;

  if (bt=btNext) then
    begin
      Xpos:=Xpos+1;
      if Xpos>100 then Xpos:=100;
    end
  else
    begin
      Xpos:=Xpos-1;
      if Xpos<0 then Xpos:=0;
    end;

  TstmMemoForm(form).enX.updateCtrl;
  messageToRef(UOmsg_invalidate,nil);
end;

procedure TstmMemo.ChangeYD(sender:Tobject;bt:TUDBtnType);
begin
  if FlagChange then exit;

  if (bt=btNext) then
    begin
      Ypos:=Ypos+1;
      if Ypos>100 then Ypos:=100;
    end
  else
    begin
      Ypos:=Ypos-1;
      if Ypos<0 then Ypos:=0;
    end;

  TstmMemoForm(form).enY.updateCtrl;
  messageToRef(UOmsg_invalidate,nil);

end;



procedure TstmMemo.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);

  stf:=TheList.text;
  fontToDesc(MyFont,descFont);
  conf.SetStringConf('ST',stf);
  conf.SetVarConf('Font',descFont,sizeof(descFont));
  conf.SetVarConf('Xpos',Xpos,sizeof(Xpos));
  conf.SetVarConf('Ypos',Ypos,sizeof(Ypos));
  conf.SetStringConf('MyCaption',MyCaption);
  conf.SetVarConf('PanelVisible', FPanelVisible,sizeof(FPanelVisible));
end;

procedure TstmMemo.completeLoadInfo;
begin
  inherited;
  FlagChange:=true;

  if not assigned(FextMemo) then
  begin
    recupForm;
    if assigned(form) then
      begin
        form.caption:=MyCaption;
        TstmMemoForm(form).Panel1.Visible:= PanelVisible;
        updateAllCtrl(form);
      end;
  end;

  DescToFont(descFont,Myfont);
  TheList.text:=stf;
  updateFormText;
  FlagChange:=false;
end;

procedure TstmMemo.setLine(i:integer;st:AnsiString);
var
  j:integer;
begin
  flagChange:=true;

  for j:=TheList.count+1 to i do TheList.add('');
  TheList[i-1]:=st;
  if assigned(form) then TstmMemoForm(form).Memo1.Lines[i-1]:=st;

  flagChange:=false;
end;

function TstmMemo.getLine(i:integer):AnsiString;
begin
  if i>TheList.count
    then result:=''
    else result:=TheList[i-1];
end;

procedure TstmMemo.insertLine(i:integer;st:AnsiString);
var
  j:integer;
begin
  flagChange:=true;

  for j:=TheList.count+1 to i do TheList.add('');
  TheList.insert(i-1,st);

  if assigned(form) then
  with TstmMemoForm(form).Memo1 do
  begin
    for j:=lines.count+1 to i do lines.add('');
    lines.insert(i-1,st);
  end;

  flagChange:=false;
end;

procedure TstmMemo.deleteLine(i:integer);
begin
  flagChange:=true;
  if i<=TheList.count then TheList.delete(i-1);

  if assigned(form) then
  with TstmMemoForm(form).Memo1 do
  begin
    if i<=lines.count then lines.delete(i-1);
  end;


  flagChange:=false;
end;

function TstmMemo.withInside:boolean;
begin
  result:=false;
end;

function TstmMemo.getTitle: AnsiString;
begin
  result:='';
end;

procedure TstmMemo.setEmbedded(v: boolean);
begin
  Fembedded:=v;
  if v and assigned(FextMemo) then exit;

  if not assigned(FextMemo) and not assigned(form) then createForm;
  Form.Visible:=false;
end;

function TstmMemo.ActiveEmbedded(TheParent: TwinControl; x1, y1, w1,h1: integer): Trect;
var
  w,h:integer;
begin
  if not assigned(form) or not embedded then result:=rect(0,0,0,0)
  else
  with TstmMemoForm(Form).Memo1 do
  begin
    Align:= AlNone;
    parent:=TheParent;

    if (w1>0) and (h1>0) then setBounds(x1,y1,w1,h1)
    else
    begin
      left:=x1;
      top:=y1;
    end;

    result:=rect(left,top,left+width,top+height);
  end;
end;

procedure TstmMemo.UnActiveEmbedded;
begin
  if assigned(form) then
  begin
    TstmMemoForm(Form).Memo1.Parent:=TstmMemoForm(Form);
    TstmMemoForm(Form).Memo1.align:=alClient;
  end;
end;

procedure TstmMemo.updateFormText;
begin
  if assigned(form) then
  with TstmMemoForm(form) do
  begin
    memo1.Font.Assign(MyFont);
    Memo1.Text:=TheList.Text;
  end;
end;

procedure TstmMemo.setPanelVisible(w: boolean);
begin
  FpanelVisible:=w;
  if assigned(form) then TstmMemoForm(form).Panel1.Visible:= FpanelVisible;
end;

procedure TstmMemo.Addline(st: AnsiString);
begin
  TheList.Add(st);
  if assigned(form) then TstmMemoForm(form).memo1.lines.add(st);
end;

procedure TstmMemo.clear;
begin
  TheList.Clear;
  if assigned(form) then TstmMemoForm(form).Memo1.clear;
end;

function TstmMemo.TheList: Tstrings;
begin
  if assigned(FextMemo)
    then result:= FextMemo.Lines
    else result:= stList;
end;

{************************* Méthodes STM de Tmemo ***************************}

var
  E_line:integer;

procedure proTmemo_create(stName:AnsiString;var pu:typeUO);
begin
  createPgObject(stname,pu,TstmMemo);
  TstmMemo(pu).init(nil);
end;

procedure proTmemo_create_1(var pu:typeUO);
begin
  proTmemo_create('',pu);
end;

procedure proTmemo_create_2(w: boolean;var pu:typeUO);
begin
  proTmemo_create('',pu);
  TstmMemo(pu).PanelVisible:= w;
end;

procedure proTmemo_addLine(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TstmMemo(pu) do addline(st);
end;

procedure proTmemo_clear(var pu:typeUO);
begin
  verifierObjet(pu);
  TstmMemo(pu).clear;
end;

function fonctionTmemo_count(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TstmMemo(pu).TheList.Count;
end;

procedure proTmemo_count(n:integer;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  if n<0 then sortieErreur('Tmemo.count must be positive');
  with TstmMemo(pu).TheList do
  begin
    if n>count then
      for i:=count+1 to n do add('')
    else
      for i:=n+1 to count do delete(i-1);
  end;
  TstmMemo(pu).updateFormText;
end;

procedure proTmemo_lines(num:integer;st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(num,1,10000,E_line);
  TstmMemo(pu).lines[num]:=st;
end;

function fonctionTmemo_lines(num:integer;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  controleParam(num,1,10000,E_line);
  result:=TstmMemo(pu).lines[num];
end;


function fonctionTmemo_font(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TstmMemo(pu) do
  begin
    result:=Myfont;
  end;
end;

procedure proTmemo_Insert(num:integer;st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TstmMemo(pu) do
  begin
    controleParam(num,1,10000,E_line);
    insertLine(num,st);
  end;
end;

procedure proTmemo_delete(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TstmMemo(pu) do
  begin
    controleParam(num,1,10000,E_line);
    deleteLine(num);
  end;
end;

function fonctionTmemo_X(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TstmMemo(pu) do
  begin
    result:=Xpos;
  end;
end;

procedure proTmemo_X(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TstmMemo(pu) do
  begin
    Xpos:=x;
    if assigned(form) then TstmMemoForm(form).enX.UpdateCtrl;
  end;
end;

function fonctionTmemo_Y(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TstmMemo(pu) do
  begin
    result:=Ypos;
  end;
end;

procedure proTmemo_Y(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TstmMemo(pu) do
  begin
    Ypos:=x;
    if assigned(form) then TstmMemoForm(form).enY.UpdateCtrl;
  end;
end;

function fonctionTmemo_text(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TstmMemo(pu).TheList.Text;
end;

procedure proTmemo_text(x:AnsiString;var pu:typeUO);pascal;
begin
  verifierObjet(pu);
  TstmMemo(pu).TheList.Text:=x;
  TstmMemo(pu).updateFormText;
end;

function fonctionTmemo_LoadFromFile(stF:AnsiString;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  try
    if stF<>'' then
    begin
      TstmMemo(pu).TheList.LoadFromFile(stF);
      TstmMemo(pu).updateFormText;
    end;
    result:=true;
  except
    result:=false;
  end;
end;


function fonctionTmemo_SaveToFile(stF:AnsiString;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  try
    if stF<>'' then TstmMemo(pu).TheList.SaveToFile(stF);
    result:=true;
  except
    result:=false;
  end;
end;

function fonctionTmemo_caption(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TstmMemo(pu).MyCaption;
end;

procedure proTmemo_caption(x:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TstmMemo(pu).MyCaption:= x;
end;

function fonctionTmemo_PanelVisible(var pu:typeUO): Boolean;
begin
  verifierObjet(pu);
  result:= TstmMemo(pu).PanelVisible;
end;

procedure proTmemo_PanelVisible(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TstmMemo(pu).PanelVisible:= x;
end;







Initialization
  AffDebug('Initialization stmMemo1',0);

  installError(E_line,'Tmemo: line number out of range');

  registerObject(TstmMemo,data);

end.
