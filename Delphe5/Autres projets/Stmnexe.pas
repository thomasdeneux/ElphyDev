{Non utilisé par Elphy}
unit stmNexe;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows,sysutils,
     util1,
     Ncdef2,Nexe0,Dgraphic,debug0,
     stmObj;

procedure executerProg(p:ptUlex;objetExe:Pexe);

procedure executerProcedureExterne(pprog:pointer;objetExe:Pexe);

IMPLEMENTATION


function allouerSS(t:word):boolean;
  begin
    if maxAvail<t then
      begin
        taillePile:=0;
        StackSegment:=nil;
        allouerSS:=false;
      end
    else
      begin
        taillePile:=t;
        getmem(StackSegment,taillePile);
        regSS:=seg(StackSegment^);
        regSP:=taillePile-16;
        allouerSS:=true;
      end;
  end;

procedure libererSS;
  begin
    if taillePile<>0 then freemem(StackSegment,taillePile);
    taillePile:=0;
    StackSegment:=nil;
  end;


procedure executerProg(p:ptUlex;objetExe:Pexe);
  const
    PileOK:boolean=false;
  var
    E: Exception;
    d:longint;

  begin
    errorEXE:=0;
    finExeU:=false;
    finExe:=false;

    if (pg=nil) or (p=nil) then exit;

    if not pileOK then
      begin
        if not allouerSS(taillePile0) then       { Installer segment de pile }
        begin
          errorEXE:=E_allocationPile;
          exit;
        end;
        pileOK:=true;
      end;

    exeON:=true;
    errorOut:=0;

    ObjetExe^.ExecuterAvant;

    try
      affdebug('executerProg0');
      executerProg0(p,objetExe);
    except
      on E:exception do
        begin
          if errorOut=0 then ErrorExe:=1 else errorExe:=errorOut;
          errorEXEMsg:= E.Message;
          AdresseErreurEXE:=objetExe^.getPlex;
          affdebug('EXCEPT executerProg');
        end;
      else
        begin
          if errorOut=0 then ErrorExe:=1 else errorExe:=errorOut;
          errorEXEMsg:='ZUT'{ E.Message};
          AdresseErreurEXE:=objetExe^.getPlex;
          affdebug('EXCEPT executerProg');
        end;
    end;

    exeON:=false;

    if errorEXE<>0 then ObjetExe^.ExecuterApresErreur;

    ObjetExe^.ExecuterApres;
  end;


procedure executerProcedureExterne(pprog:pointer;objetExe:Pexe);
begin
  if not exeON
    then executerProg(pprog,objetExe)
    else executerExtProc(pprog);
end;


end.
