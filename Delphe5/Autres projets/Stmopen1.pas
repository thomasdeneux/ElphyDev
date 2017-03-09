unit stmOpen1;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, editcont,

  util1,Gdos,Dgraphic,DdosFich,StmDef,acqPar1,descStm;

type
  TAcqOpenFile = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    Lspace: TLabel;
    Label1: TLabel;
    ESname: TeditString;
    procedure BOKClick(Sender: TObject);
  private
    { Déclarations private }
  public
    { Déclarations public }
    function execution:boolean;
  end;

var
  AcqOpenFile: TAcqOpenFile;

implementation

{$R *.DFM}


function TAcqOpenFile.execution:boolean;
  var
    i,p:integer;
    ok:boolean;
    st:pathStr;
    exStDat:pathStr;
    espace:longint;
    stgen1:pathStr;
    oldSt:string;
  begin
    oldSt:=stDat;
    execution:=false;

    espace:=espaceDisque(stGenAcq);

    Lspace.caption:='Space available on disk: '+Estr(espace/1E6,6)+' Megabytes';
    cursor:=crHourGlass;
    ok:=verifierStGenAcq;
    cursor:=crDefault;
    if not ok then exit;

    stGen1:=stGenAcq;
    p:=pos('$',stGen1);
    if p>0 then
      begin
        delete(stGen1,p,1);
        insert(datePclamp,stGen1,p);
      end;
    st:=premierNomDisponible(stGen1+'.DAT');

    delete(st,length(st)-2,3);
    st:=st+'SM2';
    stDat:=st;

    ESname.setvar(stDat,sizeof(stDat)-1);

    if showModal=mrOK then
      begin
        tabStatEv.initAcq;
        execution:=true;
      end
    else stDat:=oldSt;
    panelNomDat.caption:=nomduFichier(stDat);
  end;




procedure TAcqOpenFile.BOKClick(Sender: TObject);
begin
  updateAllVar(self);
  if EcraserFichier(stDat) then
    begin
      modalResult:=mrOK;
    end;
end;

end.
