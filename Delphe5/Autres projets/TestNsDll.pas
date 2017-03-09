unit TestNsDll;

interface

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,

  util1, nsAPItypes, nsLib, DtbEdit2, NexFile1;


const
  entity_V1=0;


type
  TNeuroShareTest = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    BloadDLL: TButton;
    Bload: TButton;
    BClose: TButton;
    Bedit: TButton;
    BnexFile: TButton;
    procedure BloadDLLClick(Sender: TObject);
    procedure BloadClick(Sender: TObject);
    procedure BCloseClick(Sender: TObject);
    procedure BeditClick(Sender: TObject);
    procedure BnexFileClick(Sender: TObject);
  private
    { Déclarations privées }
    DLLok:boolean;
    LibraryInfo: ns_LIBRARYINFO;

    V1Editor: TTableEdit;
  public
    { Déclarations publiques }
    hFile:cardinal;
    FileInfo: ns_FILEINFO;
    entityInfo:ns_entityInfo;
    AnalogInfo: ns_ANALOGINFO;
    segmentInfo:ns_segmentInfo;
    NeuralInfo:ns_NeuralInfo;

    v1_count:integer;
    data:array of double;

    function getV1(i,j:integer):extended;
    procedure EditV1;
  end;

var
  NeuroShareTest: TNeuroShareTest;

implementation

{$R *.dfm}

procedure TNeuroShareTest.BloadDLLClick(Sender: TObject);
var
  res:integer;
begin
  if DLLok then exit;
  DLLok:=initNsLib;

  memo1.Lines.Add('DLL load= '+Bstr(DLLok));
  if not DLLOK then exit;

  res:=ns_GetLibraryInfo( LibraryInfo,sizeof(LibraryInfo));
  memo1.Lines.Add('ns_GetLibraryInfo= '+Istr(res));
end;

procedure TNeuroShareTest.BloadClick(Sender: TObject);
var
  st:string;
  i,res:integer;
  nbRead:longword;
  tt:double;
begin
//  st:='D:\Dexe5bis\data13.dat';
  st:='D:\dac2\luc\exp1_1.dat';

  res:= ns_OpenFile(Pchar(st), hFile);
  memo1.Lines.Add('ns_OpenFile= '+Istr(res)+'  Handle='+Istr(hFile));

  res:= ns_GetFileInfo( hFile,FileInfo, sizeof(FileInfo) );
  with fileInfo do
  begin
    memo1.Lines.Add('ns_getFileInfo= '+Istr(res));
    memo1.Lines.Add('EntityCount= '+Istr(dwEntityCount));
  end;

  for i:=1 to 6 do
    res:= ns_GetEntityInfo( hFile,i-1,EntityInfo, sizeof(EntityInfo) );

  (*
  with entityInfo do
  begin
    v1_count:=dwItemCount;
    memo1.Lines.Add('ENTITY INFO: Name= '+PcharToString(@szEntityLabel,32)+'   type= '+Istr(dwEntityType) +'  count='+Istr(dwItemCount));
  end;

  res:= ns_GetEntityInfo( hFile,2,EntityInfo, sizeof(EntityInfo) );
  with entityInfo do
    memo1.Lines.Add('ENTITY INFO: Name= '+PcharToString(@szEntityLabel,32)+'   type= '+Istr(dwEntityType) +'  count='+Istr(dwItemCount));

  res:= ns_GetEntityInfo( hFile,34,EntityInfo, sizeof(EntityInfo) );
  with entityInfo do
    memo1.Lines.Add('ENTITY INFO: Name= '+PcharToString(@szEntityLabel,32)+'   type= '+Istr(dwEntityType) +'  count='+Istr(dwItemCount));

  res:= ns_GetAnalogInfo( hFile, 0,AnalogInfo,sizeof(analogInfo) );
  with analogInfo do
    memo1.Lines.Add('ANALOG INFO id='+Istr(0)+' SampleRate= '+Estr(dSampleRate,3)+'  res='+Istr(res));

  res:= ns_GetNeuralInfo( hFile, 2,NeuralInfo,sizeof(NeuralInfo) );
  with NeuralInfo do
    memo1.Lines.Add('NEURAL INFO id='+Istr(2)+' SourceEntityID= '+Istr(dwSourceEntityID)+'  res='+Istr(res));


  res:= ns_GetSegmentInfo( hFile, 34,SegmentInfo,sizeof(SegmentInfo) );
  with SegmentInfo do
    memo1.Lines.Add('SEGMENT INFO id='+Istr(34)+' SourceCount= '+Istr(dwSourceCount)+'  res='+Istr(res));

  //setLength(data,v1_count);
  //res:= ns_GetAnalogData( hFile,  0,0, v1_count, nbRead, @data[0]);
  //with SegmentInfo do
  //  memo1.Lines.Add(' nbRead= '+Istr(nbRead)+'  res='+Istr(res));
  *)
  (*
  for i:=1 to 500 do
  begin
    res:= ns_GetAnalogInfo( hFile, 5,AnalogInfo,sizeof(analogInfo) );
    with analogInfo do
      memo1.Lines.Add('i='+Istr1(i,3)+'ANALOG INFO id=5 SampleRate= '+Estr(dSampleRate,3)+'  res='+Istr(res));
  end;
  *)

  setLength(data,1000000);

  res:= ns_GetEntityInfo( hFile,0,EntityInfo, sizeof(EntityInfo) );
  memo1.Lines.Add(' Nb= '+Istr(entityInfo.dwItemCount)+ '    res='+Istr(res) );

  res:= ns_GetNeuralData( hFile,  0,0, 451, @data[0]);
  memo1.Lines.Add(' t1= '+Estr(data[0],3)+' t1= '+Estr(data[1],3)+ '       res='+Istr(res) );


end;

procedure TNeuroShareTest.BCloseClick(Sender: TObject);
var
  res:integer;
begin
  res:= ns_CloseFile( hFile);
  memo1.Lines.Add('ns_CloseFile= '+Istr(res)+'  Handle='+Istr(hFile));
end;

procedure TNeuroShareTest.EditV1;
begin
  if not assigned(v1editor) then
  begin
    v1Editor:=TtableEdit.create(self);
    v1Editor.getTabValue:=getV1;
  end;

  v1Editor.installe(0,0,0,v1_count-1);
  v1Editor.show;
end;

function TNeuroShareTest.getV1(i, j: integer): extended;
begin
  result:=data[j];
end;

procedure TNeuroShareTest.BeditClick(Sender: TObject);
begin
  editV1
end;

procedure TNeuroShareTest.BnexFileClick(Sender: TObject);
const
  stf='D:\Dac2\data1.nex';
begin
  TestNexFile(stf);

end;

initialization
{$IFDEF FPC}
{$I TestNsDll.lrs}
{$ENDIF}
end.
