unit descStk1;


interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,forms,sysUtils,
     util1,Gdos,dtf0,descac1,debug0,
     stmdef,stmObj,OIblock1,stmOIseq1,
     dataGeneFile,
     tiff0;



type
  TStkDescriptor=
     class(TfileDescriptor)
       private
         stkFile:TstkFile;
         OIseqs:TOIseqMeta;

         function getFileStream: TStream;
       public
          stDat:AnsiString;

          constructor create;override;
          destructor destroy;override;

          function init(st:AnsiString):boolean;override;

          procedure displayInfo;override;

          property  FileStream:TStream read getfileStream;
          procedure FreeFileStream;override;

          function getOIseq(n:integer;Const Finit:boolean=true):TOIseq;override;
          function OIseqCount:integer;override;

          class function FileTypeName:AnsiString;override;
        end;


implementation


{****************** Méthodes de TstkDescriptor ******************************}

constructor TstkDescriptor.create;
begin
  inherited;
  stkFile:=TstkFile.create;
  OIseqs:=TOIseqMeta.Create;
  OIseqs.notPublished:=true;
end;

destructor TstkDescriptor.destroy;
begin
  stkFile.free;
  OIseqs.Free;
  inherited;
end;


function TstkDescriptor.init(st:AnsiString):boolean;
begin
  result:=stkFile.init(st);
  if result
    then OIseqs.initFile(getfileStream,stkFile);
end;


procedure TstkDescriptor.displayInfo;
begin
end;



function TstkDescriptor.OIseqCount: integer;
begin
  result:=1;
end;

function TstkDescriptor.getFileStream: TStream;
begin
  if assigned(stkFile)
    then result:=stkFile.fileStream
    else result:=nil;
end;


function TstkDescriptor.getOIseq(n: integer;Const Finit:boolean=true): TOIseq;
begin
  if n=0
    then result:=OIseqs
    else result:=nil;
end;


procedure TstkDescriptor.FreeFileStream;
begin
  stkFile.FreeFileStream;
end;

class function TStkDescriptor.FileTypeName: AnsiString;
begin
  result:='STK';
end;

end.
