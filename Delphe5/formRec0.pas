unit formRec0;

{ TformRec est un enregistrement destiné à sauver les paramètres d'une fiche
  sur le disque (position, dimensions, état).

  SetForm range les paramètres d'une fiche dans TformRec.
  RestoreForm crée la fiche en appelant createForm et donne à cette fiche
  les paramètres de TformRec.
  RestoreFormXY fait la même chose mais ignore les paramètres width et height.
  Si la fiche est déjà créée à la restitution, on peut passer createForm=nil

  Le mécanisme de restitution fonctionne mal si la fiche est créée dans l'état
  maximisé.
  }

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,forms,
     util1,Dgraphic,debug0;

type
  TprocedureOfObject=procedure of object;
  Tformrec=object
             exist:boolean;
             visible:boolean;
             left,top,width,height:smallInt;
             wState:byte;
             procedure controle;
             procedure setForm(form:Tform);
             procedure restoreForm(var form:Tform;createForm:TprocedureOfObject);
             procedure restoreFormXY(var form:Tform;createForm:TprocedureOfObject);
             procedure restoreHiddenForm(var form:Tform;createForm:TprocedureOfObject);
             function info:string;
           end;

Implementation

procedure TformRec.controle;
begin
  if (width<20) or (width>screen.desktopwidth-20)
    then width:=screen.deskTopwidth div 2;
  if (height<20) or (height>screen.deskTopHeight-20)
    then height:=screen.deskTopHeight div 2;

  if (top<0) or (top>screen.deskTopHeight-20)
    then top:=20;
  if (left+width<0) or (left>screen.deskTopWidth-20)
    then left:=20;
end;

function Tformrec.info: string;
begin
  result:= Bstr(exist)+','+Bstr(visible)+','
           +Istr(left)+','+Istr(top)+','+Istr(width)+','+Istr(height)+','
           +Istr(wState);

end;

procedure TformRec.restoreForm(var form:Tform;createForm:TprocedureOfObject);
begin
  if not assigned(form) and not assigned(createForm) then exit;

  if exist then
    begin
      if not assigned(form) and assigned(createForm) then createForm;
      if not assigned(form) then exit;

      controle;

      {$IFDEF FPC}
      form.setBounds(left,top,width-8,height-34);  { Correction empirique pour FPC }
      {$ELSE}
      form.setBounds(left,top,width,height);
      {$ENDIF}
      form.windowState:=TwindowState(wstate);
      if visible then form.show else form.hide;
    end;
end;

procedure TformRec.restoreHiddenForm(var form:Tform;createForm:TprocedureOfObject);
begin
  if not assigned(form) and not assigned(createForm) then exit;

  if exist then
    begin
      if not assigned(form) and assigned(createForm) then createForm;
      if not assigned(form) then exit;

      controle;

      {$IFDEF FPC}
      form.setBounds(left,top,width-8,height-34);
      {$ELSE}
      form.setBounds(left,top,width,height);
      {$ENDIF}

      form.windowState:=TwindowState(wstate);
      form.hide;
    end;
end;


procedure TformRec.restoreFormXY(var form:Tform;createForm:TprocedureOfObject);
begin
  if not assigned(form) and not assigned(createForm) then
    begin
      exit;
    end;
  if exist then
    begin
      if assigned(createForm) then createForm;
      if not assigned(form) then exit;

      controle;
      form.top:=top;
      form.left:=left;
      form.windowState:=TwindowState(wstate);
      if visible then form.show else form.hide;
    end;
end;

procedure TformRec.setForm(form:Tform);
var
  r:Trect;
begin
  exist:=assigned(form);
  if exist then
    begin
      wstate:=byte(form.windowState);
      visible:=form.visible;

      r:=getNormalPosition(form.handle);
      left:=r.left;
      top:=r.top;
      width:=r.right-r.left;
      height:=r.bottom-r.top;
    end;
end;

end.
