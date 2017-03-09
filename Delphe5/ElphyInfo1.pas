unit ElphyInfo1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls,

  util1,Gdos,DdosFich, debug0,
  Mtag2,
  stmdef, stmObj,descElphy1,ElphyFormat,objFile1;


type
  TElphyFileInfo = class(TForm)
    PageControl1: TPageControl;
    TabGeneral: TTabSheet;
    TabBlocks: TTabSheet;
    TabTags: TTabSheet;
    MemoGeneral: TMemo;
    Panel1: TPanel;
    MemoTag: TMemo;
    Panel2: TPanel;
    MemoBlocks: TMemo;
    Splitter1: TSplitter;
    VLboxBlocks: TListBox;
    VLboxTags: TListBox;
    Splitter2: TSplitter;
    BsaveBlocks: TButton;
    BOpenFile: TButton;
    EditFileName: TEdit;
    LnbBlocks: TLabel;
    Breload: TButton;
    BcloseData: TButton;
    procedure VLBoxBlocksClick(Sender: TObject);
    procedure VLboxTagClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BsaveBlocksClick(Sender: TObject);
    procedure BOpenFileClick(Sender: TObject);
    procedure VLboxBlocksDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure VLboxTagsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure BreloadClick(Sender: TObject);
    procedure BcloseDataClick(Sender: TObject);
  private
    { Déclarations privées }
    desc:TelphyDescriptor;
    TotTags:TtagRecArray;
    NumEp: array of integer;
    procedure DisplayBlockCount;
  public
    { Déclarations publiques }
    procedure init(p:TelphyDescriptor);
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  stF:AnsiString;
  nbBlock:integer;

{ TElphyFileInfo }

procedure FillListBox(lb:TlistBox; nb:integer);
var
  i:integer;
begin
  with lb.items do
  begin
    beginUpdate;
    clear;
    for i:=1 to nb do add('');
    EndUpdate;
  end;
end;

procedure TElphyFileInfo.init(p: TelphyDescriptor);
var
  i,j:integer;
  UO:TUserTagBlock;
  sz:integer;
begin
  desc:=p;

  FillListBox(VLBoxBlocks,  desc.objFile.stClasses.count);
  setLength(NumEp, desc.objFile.stClasses.count);

  j:=0;
  for i:=0 to desc.objFile.stClasses.count-1 do
  if desc.objFile.stClasses[i]=TseqBlock.STMClassName then
  begin
    inc(j);
    NumEp[i]:=j;
  end;

  with MemoGeneral do
  begin
    lines.add(desc.stDat);
    lines.Add('Format: ELPHY');
    lines.add(Udate(desc.DateD)+'  '+Utime(desc.DateD) );
    lines.Add('Episode count='+Istr(length(desc.seqs)));
    lines.Add('Block count='+Istr(desc.ObjFile.objCount ));
  end;

  with desc do
  for i:=0 to high(seqs) do
    with seqs[i] do
    for j:=0 to high(tags) do
      begin
        setLength(totTags,length(totTags)+1);
        totTags[high(totTags)]:=seqs[i].tags[j];
      end;

  FillListBox(VLboxTags,length(TotTags));

  DisplayBlockCount;
end;

procedure TElphyFileInfo.VLBoxBlocksClick(Sender: TObject);
var
  uo:typeUO;

  k,csize:integer;
  cIndex: int64;
begin
  uo:=nil;
  cindex:=0;
  cSize:=0;
  if assigned(desc.objFile.stClasses) and (VLBoxBlocks.ItemIndex>=0)
    and (VLBoxBlocks.ItemIndex<desc.objFile.stClasses.count) and assigned(desc.FileStream) then
    begin
      TRY
        k:=VLBoxBlocks.ItemIndex;
        with desc.objFile do
        begin
          cIndex:=BlockOffset[k];
          csize:= BlockSize[k];
//          if k<BlockCount-1
//            then cSize:=BlockOffset[k+1]-BlockOffset[k]
//            else cSize:=FfileSize-BlockOffset[k];
        end;

        desc.fileStream.Position:=cindex;
        UO:=readAndCreateUO(desc.fileStream,UO_main,false,false);
        if assigned(UO) then UO.clearReferences;
      EXCEPT

      END;
    end;

  if assigned(UO)
    then memoBlocks.Text:='Block '+Istr(VLBoxBlocks.ItemIndex)+ ': Offset='+Int64str(cindex)+'   Size='+Istr(cSize)+crlf+
                          uo.getInfo
    else memoBlocks.Text:='Block '+Istr(VLBoxBlocks.ItemIndex)+ ': Offset='+Int64str(cindex)+'   Size='+Istr(cSize)+crlf+ '?????';

  uo.Free;
end;

procedure TElphyFileInfo.VLboxTagClick(Sender: TObject);
begin
  if VLboxTags.itemIndex>=0 then
    with tottags[VLboxTags.itemIndex] do
    memoTag.Text:=st;
end;

procedure TElphyFileInfo.FormCreate(Sender: TObject);
const
  tab:array[1..3] of integer=(30,50,80);
begin
  {
  VLboxTags.SetTabStops(tab);
  VLboxTags.UseTabStops:=true;
  }
end;

procedure TElphyFileInfo.BsaveBlocksClick(Sender: TObject);
var
  f:TfileStream;
  i,j:integer;

  nbV:array[0..32] of integer;
  TheSize:integer;
begin
  if (VLboxBlocks.SelCount>0) and (stf<>'') then
  begin
    f:=TfileStream.Create(stF,fmOpenReadWrite);
    f.Position:=f.Size;

    for i:=0 to VLboxBlocks.Count-1 do
    if VLboxBlocks.Selected[i] then
    with desc.ObjFile do
    begin
      fileStream.Position:=BlockOffset[i];
      f.CopyFrom(FileStream,BlockSize[i]);

      f.position:=f.size-BlockSize[i];        // Ecrire la bonne taille
      TheSize:=BlockSize[i];
      f.write(TheSize,4);
      f.position:=f.size;
      {
      if stClasses[i]='RSPK' then
      begin
        // Une correction pour Vincent 30 aout 2011

        fileStream.Position:=BlockOffset[i] +24;
        fileStream.read(nbV,33*4);

        for j:=1 to 32 do
          nbV[j]:= nbV[j] mod 10000;

        f.position:=f.size-BlockSize[i]+24;
        f.write(nbV,33*4);
        f.position:=f.size;
      end
      else
      if stClasses[i]='RspkWave' then
      begin
        // Une correction pour Vincent 30 aout 2011

        fileStream.Position:=BlockOffset[i] +32;
        fileStream.read(nbV,33*4);

        for j:=1 to 32 do
          nbV[j]:= nbV[j] mod 10000;

        f.position:=f.size-BlockSize[i]+32;
        f.write(nbV,33*4);
        f.position:=f.size;
      end;
      }
    end;

    nbBlock:=nbBlock+VLboxBlocks.SelCount;
    f.Free;
  end;
  VLboxBlocks.ClearSelection;
  DisplayBlockCount;
end;

procedure TElphyFileInfo.DisplayBlockCount;
begin
  LnbBlocks.Caption:='Block Count='+Istr(nbBlock);
end;

procedure TElphyFileInfo.BOpenFileClick(Sender: TObject);
var
  FnewFile:boolean;
  f:TfileStream;
  header: THeaderObjectFile;
  sz:longword;
  st:AnsiString;
  res:integer;
begin
  st:=GsaveFile('Destination',stF,'.dat');
  if st<>'' then
  begin
    if FileExists(st) then
    begin
      res:= MessageDlg('File already exists. Overwrite?', mtConfirmation, mbYesNoCancel, 0);
      if res=mrCancel then exit;

      FnewFile:=(res=mrYes);
      if FnewFile then
        if MessageDlg('DataFile '+extractFileName(st)+' will be erased then recreated. Continue? ', mtConfirmation, [mbYes,mbNo], 0)=mrNo then exit;
    end
    else FnewFile:=true;
    stF:=st;

    if FnewFile then
    begin
      try
      f:=TfileStream.Create(stF,fmCreate);
      header.init;
      f.Write(header,sizeof(header));
      f.Free;

      nbBlock:=0;

      except
      stf:='';
      messageCentral('Unable to create file '+stf);
      f.free;
      end;
    end
    else
    begin
      nbBlock:=0;
      f:=TfileStream.create(stf,fmOpenRead);
      header.id:='';
      f.Read(header,sizeof(THeaderObjectFile));
      if (header.id=ObjectFileId) then
      begin
        while f.position<f.size  do
        begin
          inc(nbBlock);
          f.Read(sz,4);
          f.Position:=f.Position+sz-4;
        end;
        if f.position<>f.Size then
        begin
          messageCentral('Error reading '+stF);
          nbBlock:=0;
        end;

        messageCentral('Blocks will be added at the end of '+extractFileName(stF));
      end
      else messageCentral(stf+' is not an object file');
      f.Free;
    end;

    EditFileName.Text:=stF;
    DisplayBlockCount;
  end;
end;

procedure TElphyFileInfo.VLboxBlocksDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  st:string;

begin
  with VLboxBlocks.Canvas do
  begin
    FillRect(Rect);
    if desc.objFile.stClasses[index]=TseqBlock.STMClassName
      then st:= desc.objFile.stClasses[index]+'   Num='+ Istr(NumEp[index])
      else st:= desc.objFile.stClasses[index];

    TextOut(Rect.Left + 4, Rect.Top, st);
  end;
end;

procedure TElphyFileInfo.VLboxTagsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
const
  sep='   ';
begin
  with VLboxTags.Canvas do
  begin
    FillRect(Rect);
    with tottags[index] do
      TextOut(Rect.Left + 4, Rect.Top, Istr(Ep+1)+sep+Istr(code)+sep+Istr(SampleIndex)+sep+dateTimeToStr(Stime));
  end;
end;

procedure TElphyFileInfo.BreloadClick(Sender: TObject);
begin
  FlookForObj:=true;
  PostMessage(formStm.handle,msg_ReloadFile,0,0);
end;

procedure TElphyFileInfo.BcloseDataClick(Sender: TObject);
begin
  PostMessage(formStm.handle,msg_CloseLastDataBlock,0,0);
end;

Initialization
AffDebug('Initialization ElphyInfo1',0);
{$IFDEF FPC}
{$I ElphyInfo1.lrs}
{$ENDIF}
end.
