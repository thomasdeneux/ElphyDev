unit Uavi1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,StdCtrls,

  jpeg,
  util1, VFW, DIBitmap, rle0;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    BMlist:Tlist;
    fileName:string;
  public
    { Public declarations }
    procedure test;
  end;

var
  Form1: TForm1;


implementation

{$R *.DFM}

procedure Tform1.test;
var
  i:integer;

  pfile: PAVIFile;
  asi: TAVIStreamInfo;
  ps: PAVIStream;
  nul: Longint;

  BmInfo: PBitmapInfoHeader;
  BmInfoSize: integer;
  BmBits: Pointer;
  BmSize: Dword;

const
  id:array[1..4] of char='RLE8';

begin
  AVIFileInit;

  if AVIFileOpen(pfile, PChar(FileName), OF_WRITE or OF_CREATE, @id)=AVIERR_OK then
    begin
      FillChar(asi,sizeof(asi),0);

      asi.fccType := streamtypeVIDEO;                 //  Now prepare the stream
      asi.fccHandler := 0;
      asi.dwScale := 1;
      asi.dwRate := 10;

      with Tbitmap(BMlist.Items[0]) do
      begin
        InternalGetDIBSizes(Handle,BmInfoSize,BmSize,256);
        BmInfo := AllocMem(BmInfoSize);
        BmBits := AllocMem(BmSize);
        InternalGetDIB(Handle,0,BmInfo^,BmBits^,256);

        CompressRLE(PbitmapInfo(bmInfo),BmInfoSize, bmBits, BmSize);
      end;

      asi.dwSuggestedBufferSize := BmInfo^.biSizeImage;
      asi.rcFrame.Right := BmInfo^.biWidth;
      asi.rcFrame.Bottom := BmInfo^.biHeight;

      if AVIFileCreateStream(pfile,ps,@asi)=AVIERR_OK then
        with Tbitmap(BMlist.Items[0]) do
        begin
          if AVIStreamSetFormat(ps,0,BmInfo,BmInfoSize)=AVIERR_OK then
          begin
            for i:=0 to BMlist.Count-1 do
              with Tbitmap(BMlist.Items[i]) do
              begin
                InternalGetDIBSizes(Handle,BmInfoSize,BmSize,256);
                reallocMem(BmInfo,BmInfoSize);
                reallocmem(BmBits,BmSize);
                InternalGetDIB(Handle,0,BmInfo^,BmBits^,256);

                CompressRLE(PbitmapInfo(bmInfo),BmInfoSize, bmBits, BmSize);
                if AVIStreamWrite(ps,i,1,BmBits,BmSize,AVIIF_KEYFRAME,@nul,@nul)<>AVIERR_OK then
                begin
                  raise Exception.Create('Could not add frame');
                  break;
                end;
              end;
          end;
        end;
        FreeMem(BmInfo);
        FreeMem(BmBits);
    end;

  AVIStreamRelease(ps);
  AVIFileRelease(pfile);

  AVIFileExit;
end;




procedure TForm1.Button1Click(Sender: TObject);
begin
  test;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
  bm:Tbitmap;
begin
  BMlist:=Tlist.create;
  fileName:='c:\dac2\test.avi';

  for i:=1 to 10 do
    begin
      bm:=Tbitmap.create;
      bm.loadFromFile('c:\dac2\bmtest'+Istr(i)+'.bmp');
      bmlist.add(bm);
    end;

end;

end.
