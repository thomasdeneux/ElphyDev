unit AcqProc0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,syncObjs,
     util1,stmDef,stmObj,
     debug0,
     acqDef2,acqInf2,stimInf2,
     AcqCom1,Ncdef2,Dgraphic,stmError,
     procFile,stmDobj1,stmPg,
     multG1,
     acqBrd1;


{le thread Process
  - remplit le buffer DAC
  - appelle le programme de traitement
}

type
  TUpdateDataFile=procedure (num:integer) of object;
  TsetDACvalues=procedure (n1,n2:integer) of object;

  TthreadProcess=
             class(Tthread)
               {nbpt1:integer;}  {260309}
               nbpt:integer;

               oldSeq:integer;

               numSeq:integer;
               maxCount:integer;

               UpdateDataFile:TUpdateDataFile;

               count:integer;
               ITcont1,ITcont2:integer;

               constructor create(updateDF:TUpdateDataFile);
               procedure DoProcess;
               procedure DoProcessCont;
               procedure execute;override;

             end;

  TthreadDelay=class(Tthread)
                 DT:integer;
                 procedure go(DT0:integer);
                 procedure execute;override;
               end;


var
  threadProcess:TthreadProcess;
  ThreadDelay:TthreadDelay;

  eventProcess:Tevent;

var
  E_overrun:integer;


implementation


constructor TthreadProcess.create(updateDF:TUpdateDataFile);
begin
  maxCount:=maxEntierLong;
  {nbpt1:=acqInf.nbvoieAcq*acqInf.Qnbpt;}
  nbpt:= acqInf.Qnbpt;  {260309}

  count:=0{MainBufIndex0};
  oldSeq:=Count div nbpt {nbpt1};           {260309}
  ITcont2:=count {div acqInf.nbvoieAcq };   {260309}


  updateDataFile:=updateDF;

  if AcqInf.Fstim then paramStim.initOutPutValues;

  ITcont1:=0;

  inherited create(true);
end;

procedure TthreadProcess.DoProcess;
var
  x:float;
  i:integer;
begin
  if errorExe=0 then
    begin
      Tpg2(dacPg).traitement1;
      if errorExe<>0 then FlagStop:=true;
    end;

  with ImList do
  begin
    for i:=0 to count-1 do
      if typeUO(items[i]) is TdataObj
        then TdataObj(items[i]).doImDisplay;
      if count>0 then updateAff;
  end;

  if acqInf.waitMode and not FlagStop then
    begin
      board.CanRestart;     {pour CBbrd}
      RestartEnabled:=true; {pour digidata 1322 et ITC }
    end
end;

procedure TthreadProcess.DoProcessCont;
var
  i:integer;
begin
  if errorExe=0 then
    begin
      {pushCriticalVar;}
      Tpg2(dacPg).traitementCont;
      {popCriticalVar;}
      if (errorExe<>0) or finExeU^ then FlagStop:=true;
    end;

  with ImList do
    for i:=0 to count-1 do
      if typeUO(items[i]) is TdataObj
        then TdataObj(items[i]).doImDisplay;

end;

procedure TthreadProcess.execute;
var
  Fin:boolean;
  cnt:integer;
  num:integer;
begin
  repeat
    count:=MainBufIndex;
    if count>maxCount then count:=maxCount;

    if AcqInf.Fstim then paramStim.setOutPutValues(cntStim);
    if acqInf.Fprocess or acqInf.Qmoy then
    if AcqInf.continu and Tpg2(dacPg).FtraitementCont then
      begin
        ITcont1:=ITcont2;
        ITcont2:=count {div acqInf.nbvoieAcq};   {260309}
        if ITcont2>ITcont1 then
          begin
            UpdateDataFile(ITcont2);
            if acqinf.Fprocess then synchronize(DoProcessCont);
          end;
      end
    else
      if Tpg2(dacPg).Ftraitement1 or acqInf.Qmoy then
      begin
        numSeq:=(Count+1) div nbpt{ nbpt1};     {260309}

        if (numseq-oldSeq>nbseq0) and (errorExe=0) then
          begin
            sendStmMessage('Process doesn''t follow acquisition '
                           +Istr(oldSeq)+' '+Istr(numSeq)+' '+Istr(nbseq0));
            FlagStop:=true;
          end
        else
        for num:=oldSeq+1 to numSeq do
        begin
          UpdateDataFile(num);
          affdebug('UpdateDataFile '+Istr(numSeq),0);
          if acqinf.Fprocess then synchronize(DoProcess);
          if errorExe<>0 then break;
        end;
        oldSeq:=numSeq;
      end;

    fin:=FlagStop2 and ((count>=maxCount) or (errorExe<>0)) or finExeU^;

    if flagStopPanic then fin:=true;
    if not fin
      then eventProcess.waitFor(10000)
      else terminate;
  until terminated;

  postMessage(formStm.handle,msg_EndAcq1,3,0);
end;


{ TthreadDelay }

procedure TthreadDelay.go(DT0:integer);
begin
  DT:=DT0;
  resume;
end;

procedure TthreadDelay.execute;
begin
  repeat
    Sleep(DT);
    eventProcess.SetEvent;
    suspend;
  until terminated;
end;

Initialization
AffDebug('Initialization acqProc0',0);

eventProcess:=Tevent.create(nil,false,false,'');
ThreadDelay:=TthreadDelay.create(true);

installError(E_overrun,'Unable to process data: acquisition too fast');

finalization

ThreadDelay.free;
eventProcess.free;


end.
