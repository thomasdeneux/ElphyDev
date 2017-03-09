unit ProcFile;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont,

  util1,Dgraphic,stmdef,stmObj,stmdf0,Ncdef2,chooseOb,stmDPlot,stmDobj1, debug0,
  Buttons;




type
  TProcessFileForm = class(TForm)
    Bexecute: TButton;
    Bclose: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    enFirst: TeditNum;
    Label2: TLabel;
    enLast: TeditNum;
    Label3: TLabel;
    cbDF: TcomboBoxV;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    cbInit: TcomboBoxV;
    Label6: TLabel;
    cbProcess: TcomboBoxV;
    Label7: TLabel;
    cbEnd: TcomboBoxV;
    GroupBox3: TGroupBox;
    cbInitValid: TCheckBoxV;
    cbProcessValid: TCheckBoxV;
    cbEndValid: TCheckBoxV;
    Badd: TButton;
    Bremove: TButton;
    lbRefresh: TListBox;
    GroupBox4: TGroupBox;
    bAddClear: TButton;
    BremoveClear: TButton;
    lbClear: TListBox;
    cbUpdate: TCheckBoxV;
    Bautoscale: TBitBtn;
    cbPause: TCheckBoxV;
    Label4: TLabel;
    enDelay: TeditNum;
    procedure FormCreate(Sender: TObject);
    procedure BaddClick(Sender: TObject);
    procedure BremoveClick(Sender: TObject);
    procedure bAddClearClick(Sender: TObject);
    procedure BremoveClearClick(Sender: TObject);
    procedure BautoscaleClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    seq1,seq2:integer;
    DFname:AnsiString;
    InitName,ProcessName,EndName:AnsiString;

    Fupdate:boolean;

    DF:TdataFile;
    Plex:array[0..2] of integer;

    Finit,Fprocess,Fend:boolean;
    Fpause:boolean;
    Fdelay:integer;

    procedure execution;
    procedure ListsToLB;
    procedure LBtoLists;
    procedure DoExec;

  end;

var
  ProcessFileForm: TProcessFileForm;

  stObjectsToRefresh:AnsiString;
  stObjectsToClear:AnsiString;

  ObjectsToRefresh:Tlist;
  ObjectsToClear:Tlist;
  ImList:Tlist;

procedure DecodeObjectList(st:AnsiString;list:Tlist);
procedure EncodeObjectList(list:Tlist;var st:AnsiString);



implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
uses stmPg;

procedure TProcessFileForm.Doexec;
var
  i,j,iseq:integer;
begin
            {appeler clear pour tous les objets de ObjectsToClear }
  if Fupdate then
  with ObjectsToClear do
  for i:=0 to count-1 do
    with TypeUO(items[i]) do
    begin
      clear;
      invalidate;
    end;
            {invalider tous les objets de ObjectsToClear et
             mettre FimmDisplay à true pour les vecteurs tableau
            }

  if Fupdate then
    begin
      ImList.clear;
      with ObjectsToRefresh do
      for i:=0 to count-1 do
        if typeUO(items[i]) is TdataObj then
          with TdataObj(items[i]) do
          begin
            if flags.FmaxIndex or Fexpand then
              begin
                FimDisplay:=true;
                ImList.add(items[i]);
              end;
            invalidate;
          end;
    end;

  TPG2(dacPg).finExeUpg2:=false;
            { exécuter InitTraitement }
  if Finit then TPG2(dacPg).traitement0;

  if Fupdate then
    begin
      updateAff;
    end;
            { Boucle principale }
  iSeq:=seq1;
  finExeU^:=false;
  while (iseq<=seq2) and not finExeU^ do
  begin
            { Exécuter Traitement }
    if dF.setEpNum(iseq) and Fprocess then TPG2(dacPg).traitement1;

    if Fupdate then
      begin
        with ImList do
        for i:=0 to count-1 do
          if typeUO(items[i]) is TdataObj
            then TdataObj(items[i]).doImDisplay;

        updateAff;
      end;
    inc(iseq);
    if Fpause then MessageDlgPos('Click OK to continue', mtInformation, [mbOK], 0,
                                  screen.width div 2-100,screen.Height-150)
    else
    if Fdelay>0 then sleep(Fdelay);
  end;
           { Exécuter FinTraitement }
  if Fend then TPG2(dacPg).traitement2;

           { Remettre le flag FimDisplay à false pour tous les objets }
  if Fupdate then
  with ObjectsToRefresh do
  for i:=0 to count-1 do
    if typeUO(items[i]) is TdataObj then TdataObj(items[i]).FimDisplay:=false;

end;

procedure TProcessFileForm.execution;
var
  i,j:integer;
  st:AnsiString;
begin
  enFirst.setvar(seq1,t_longint);
  enFirst.setMinMax(1,maxEntierLong);
  enLast.setvar(seq2,t_longint);
  enLast.setMinMax(1,maxEntierLong);

  cbInitValid.setVar(Finit);
  cbProcessValid.setVar(Fprocess);
  cbEndValid.setVar(Fend);

  cbUpdate.setvar(Fupdate);
  cbPause.setVar(Fpause);
  enDelay.setVar(Fdelay,t_longint);
  enDelay.setMinMax(0,10000);

  with getGlobalList(TdataFile,false) do
  begin
    cbDF.clear;
    for i:=0 to count-1 do
      begin
        st:=typeUO(items[i]).ident;
        cbDF.items.add(st);
        if st=DFname then cbDF.itemIndex:=i;
      end;

    if cbDF.itemIndex<0 then cbDF.itemIndex:=0;
    free;
  end;

  cbInit.clear;
  cbInit.items.add('InitProcess');
  with Tpg2(dacPg).PlexProgram do
  for i:=0 to count-1 do
    begin
      cbInit.items.add(strings[i]);
      if InitName=strings[i] then cbInit.itemIndex:=i;
    end;
  if cbInit.itemIndex<0 then cbInit.itemIndex:=0;

  cbProcess.clear;
  cbProcess.items.add('Process');
  with Tpg2(dacPg).PlexProgram do
  for i:=0 to count-1 do
    begin
      cbProcess.items.add(strings[i]);
      if ProcessName=strings[i] then cbProcess.itemIndex:=i;
    end;
  if cbProcess.itemIndex<0 then cbProcess.itemIndex:=0;

  cbEnd.clear;
  cbEnd.items.add('EndProcess');
  with Tpg2(dacPg).PlexProgram do
  for i:=0 to count-1 do
    begin
      cbEnd.items.add(strings[i]);
      if EndName=strings[i] then cbEnd.itemIndex:=i;
    end;
  if cbEnd.itemIndex<0 then cbEnd.itemIndex:=0;

  ListsToLB;

  if showModal=mrOK then
    begin
      updateAllVar(self);

      LBtoLists;

      DFname:=cbDF.text;
      typeUO(DF):=getGlobalObject(DFname);

      if seq1<1 then seq1:=1;
      if (seq2>DF.EpCount) or (seq2<seq1) then seq2:=DF.EpCount;

      InitName:=cbInit.text;
      i:=cbInit.itemIndex;
      if i=0 then Plex[0]:=Tpg2(dacPg).PlexInit
             else Plex[0]:=intG(Tpg2(dacPg).PlexProgram.objects[i-1]);

      ProcessName:=cbProcess.text;
      i:=cbProcess.itemIndex;
      if i=0 then Plex[1]:=Tpg2(dacPg).PlexTrait
             else Plex[1]:=intG(Tpg2(dacPg).PlexProgram.objects[i-1]);

      EndName:=cbEnd.text;
      i:=cbEnd.itemIndex;
      if i=0 then Plex[2]:=Tpg2(dacPg).PlexFin
             else Plex[2]:=intG(Tpg2(dacPg).PlexProgram.objects[i-1]);

      DoExec;

    end
  else LBtoLists;
end;

procedure TProcessFileForm.ListsToLB;
var
  i:integer;
begin
  lbRefresh.clear;
  with ObjectsToRefresh do
  for i:=0 to count-1 do
    lbRefresh.items.addObject(typeUO(items[i]).ident,typeUO(items[i]));

  lbClear.clear;
  with ObjectsToClear do
  for i:=0 to count-1 do
    lbClear.items.addObject(typeUO(items[i]).ident,typeUO(items[i]));

end;

procedure TProcessFileForm.LBtoLists;
var
  i:integer;
begin
  ObjectsToRefresh.clear;
  with lbRefresh do
  for i:=0 to items.count-1 do ObjectsToRefresh.add(items.objects[i]);

  ObjectsToClear.clear;
  with lbClear do
  for i:=0 to items.count-1 do ObjectsToClear.add(items.objects[i]);
end;

procedure TProcessFileForm.FormCreate(Sender: TObject);
begin
  Finit:=true;
  Fprocess:=true;
  Fend:=true;
end;

procedure TProcessFileForm.BaddClick(Sender: TObject);
var
  ob:typeUO;
begin
  ob:=nil;
  if chooseObject.execution(TdataPlot,ob) then
    if assigned(ob) then
      with lbRefresh.Items do
      if indexofObject(ob)<0 then addObject(ob.ident,ob);
end;

procedure TProcessFileForm.BremoveClick(Sender: TObject);
begin
  with lbRefresh,Items do delete(itemIndex);
end;

procedure TProcessFileForm.bAddClearClick(Sender: TObject);
var
  ob:typeUO;
begin
  ob:=nil;
  if chooseObject.execution(TypeUO,ob) then
    if assigned(ob) then
      with lbClear.Items do
      if indexofObject(ob)<0 then addObject(ob.ident,ob);
end;


procedure TProcessFileForm.BremoveClearClick(Sender: TObject);
begin
  with lbClear,Items do delete(itemIndex);
end;


procedure DecodeObjectList(st:AnsiString;list:Tlist);
var
  st1:AnsiString;
  k:integer;
  p:typeUO;
begin
  list.clear;
  while st<>'' do
  begin
    k:=pos('|',st);
    if k<=0 then exit;

    st1:=copy(st,1,k-1);
    delete(st,1,k);
    if st1<>'' then
      begin
        p:=syslist.ObjectByName(st1);
        if p<>nil then list.add(p);
      end;
  end;
end;

procedure EncodeObjectList(list:Tlist;var st:AnsiString);
var
  i:integer;
begin
  st:='';

  with list do
  for i:=0 to count-1 do st:=st+typeUo(items[i]).ident+'|';
end;


procedure TProcessFileForm.BautoscaleClick(Sender: TObject);
begin
  DFname:=cbDF.text;
  typeUO(DF):=getGlobalObject(DFname);

  seq1:=1;
  seq2:=DF.EpCount;

  enFirst.updateCtrl;
  enLast.updateCtrl;

end;

Initialization
AffDebug('Initialization ProcFile',0);

ObjectsToRefresh:=Tlist.create;
ObjectsToClear:=Tlist.create;
ImList:=Tlist.create;


{$IFDEF FPC}
{$I ProcFile.lrs}
{$ENDIF}
end.
