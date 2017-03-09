unit fontEx0;

{Utilisé par MultG0 }

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses graphics;

type
  TfontDesc=
    record
      Name:string[32];
      height:smallInt;
      Size:smallInt;
      Color:Tcolor;
      style:Tfontstyles;
    end;

  TfontEx=class
          private
            Ffont:Tfont;
            function getFont:Tfont;
            procedure setFont(f:Tfont);
            procedure fontToDesc;
            procedure DescToFont;
          public
            desc:TfontDesc;
            property font:Tfont read getFont write setfont;
            constructor create;
            destructor destroy;override;
            procedure FreeFont;
          end;


  { Tfont2 est utilisé par stmDplot : il faut mettre à jour visu.fontdesc après
    toute modif par PG d'une propriété de font
    Les méthodes stm appellent updateDesc après chaque modification de Tfont
   }
  TprocedureOfObject=procedure of object;

  Tfont2=class(Tfont)
         public
           FupdateDesc:procedure of object;
           procedure updateDesc;
           constructor create(p:TprocedureOfObject);
         end;


implementation


procedure TfontEx.DescToFont;
  begin
    Ffont.height:=desc.height;
    Ffont.name:=desc.name ;
    Ffont.size:=desc.size;
    Ffont.color:=desc.color;
    Ffont.style:=desc.style;
  end;

procedure TfontEx.FontToDesc;
  begin
    fillchar(desc,sizeof(desc),0);
    desc.height:=Ffont.height;
    desc.name:=Ffont.name ;
    desc.size:=Ffont.size;
    desc.color:=Ffont.color;
    desc.style:=Ffont.style;
  end;

function TfontEx.getFont:Tfont;
begin
  if Ffont=nil then Ffont:=Tfont.create;
  descToFont;
  getFont:=FFont;
end;

procedure TfontEx.setFont(f:Tfont);
begin
  if assigned(f) then Ffont:=f;
  FontToDesc;
end;


constructor TfontEx.create;
begin
  inherited create;
  with desc do
  begin
    Name:='MS Sans Serif';
    height:=-11;
    Size:=8;
  end;
end;

destructor TfontEx.destroy;
begin
  Ffont.free;
  inherited destroy;
end;

procedure TfontEx.FreeFont;
begin
  Ffont.free;
  Ffont:=nil;
end;

{ Tfont2 }

constructor Tfont2.create(p: TprocedureOfObject);
begin
  inherited create;
  FupdateDesc:=p;
end;

procedure Tfont2.updateDesc;
begin
  if assigned(FupdateDesc) then FupdateDesc;
end;

end.
