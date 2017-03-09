{*************************************************************
Author:       Stéphane Vander Clock (SVanderClock@Arkadia.com)
              Shiv R. Kumar (shiv@matlus.com)

EMail:        http://www.arkadia.com
              SVanderClock@Arkadia.com

product:      TALMultiPartFormDataFile
              TALMultiPartFormDataFiles
              TAlMultiPartFormDataStream
              TALMultipartFormDataDecoder
              TALMultipartFormDataEncoder

Version:      3.05

Description:  MultiPart Form Data function to encode or decode
              stream in multipart/form-data mime format. this format
              is use to send some file by HTTP request.

Legal issues: Copyright (C) 2005 by Stéphane Vander Clock

              This software is provided 'as-is', without any express
              or implied warranty.  In no event will the author be
              held liable for any  damages arising from the use of
              this software.

              Permission is granted to anyone to use this software
              for any purpose, including commercial applications,
              and to alter it and redistribute it freely, subject
              to the following restrictions:

              1. The origin of this software must not be
                 misrepresented, you must not claim that you wrote
                 the original software. If you use this software in
                 a product, an acknowledgment in the product
                 documentation would be appreciated but is not
                 required.

              2. Altered source versions must be plainly marked as
                 such, and must not be misrepresented as being the
                 original software.

              3. This notice may not be removed or altered from any
                 source distribution.

              4. You must register this software by sending a picture
                 postcard to the author. Use a nice stamp and mention
                 your name, street address, EMail address and any
                 comment you like to say.

Know bug :

History :

Link :        http://www.w3.org/TR/REC-html40/interact/forms.html#h-17.1
              http://www.ietf.org/rfc/rfc1867.txt
              http://www.ietf.org/rfc/rfc2388.txt
              http://www.w3.org/MarkUp/html-spec/html-spec_8.html

Please send all your feedback to SVanderClock@Arkadia.com
**************************************************************}
unit ALMultiPartFormDataParser;

interface

uses Classes,
     SysUtils,
     Contnrs,
     HTTPApp;

type

  {--------------------------------------------}
  EALClientConnectionDropped = class(Exception);

  {--Single multipart File Object---------}
  TALMultiPartFormDataFile = class(TObject)
  private
    FFieldName: string;
    FContentType: string;
    FFileName: string;
    FFileData: TStream;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(aFileName: string);
    procedure SaveToFile(SaveAsFile: string);
    procedure SaveToStream(Stream: TStream);
    property FieldName: string read FFieldName write FFieldName;
    property ContentType: string read FContentType write FContentType;
    property FileName: string read FFileName write FFileName;
    property FileData: TStream read FFileData;
  end;

  {--List Of multipart Objects-----------------}
  TALMultiPartFormDataFiles = class(TObjectList)
  private
  protected
    function GetItem(Index: Integer): TALMultiPartFormDataFile;
    procedure SetItem(Index: Integer; AObject: TALMultiPartFormDataFile);
  public
    function Add: TALMultiPartFormDataFile; overload;
    function Add(AObject: TALMultiPartFormDataFile): Integer; overload;
    function Remove(AObject: TALMultiPartFormDataFile): Integer;
    function IndexOf(AObject: TALMultiPartFormDataFile): Integer;
    procedure Insert(Index: Integer; AObject: TALMultiPartFormDataFile);
    property Items[Index: Integer]: TALMultiPartFormDataFile read GetItem write SetItem; default;
  end;

  {--TAlMultiPartFormDataStream-------------------}
  TAlMultiPartFormDataStream = class(TMemoryStream)
  private
    FBoundary: string;
    FRequestContentType: string;
    function GenerateUniqueBoundary: string;
  public
    procedure AddFormField(const FieldName, FieldValue: string);
    procedure AddFile(const FieldName, FileName, ContentType: string; FileData: TStream); overload;
    procedure AddFile(const FieldName, FileName, ContentType: string); overload;
    procedure CloseBoundary;
    constructor Create;
    property Boundary: string read FBoundary;
    property RequestContentType: string read FRequestContentType;
  end;

  {--TALMultipartFormDataDecoder-------------}
  TALMultipartFormDataDecoder = class(TObject)
  private
    FContentFiles: TALMultiPartFormDataFiles;
    FContentFields: TStrings;
    FRemoveDuplicateField: Boolean;
  public
    constructor	Create;
    destructor Destroy;override;
    procedure Decode(ContentStream: Tstream); overload;
    procedure Decode(Request: TWebRequest); overload;
    property ContentFiles: TALMultiPartFormDataFiles read FContentFiles;
    property ContentFields: TStrings read FContentFields;
    property RemoveDuplicateField: Boolean read FRemoveDuplicateField write FRemoveDuplicateField Default True;
  end;

  {--TALMultipartFormDataEncoder-------------}
  TALMultipartFormDataEncoder = class(TObject)
  private
    FContentStream: TStream;
  public
    constructor	Create;
    destructor Destroy; override;
    procedure Encode(ContentFields: TStrings; ContentFiles: TALMultiPartFormDataFiles);
    property ContentStream: TStream read FContentStream;
  end;

implementation

uses AlFcnString,
     alFcnMime;

//////////////////////////////////////////////////////////////////
//////////  TALHTTPFile  /////////////////////////////////////////
//////////////////////////////////////////////////////////////////

{******************************************}
constructor TALMultiPartFormDataFile.Create;
begin
  inherited;
  FFileData := TMemoryStream.Create;
end;

{******************************************}
destructor TALMultiPartFormDataFile.Destroy;
begin
  FFileData.Free;
  inherited;
end;

{****************************************************************}
procedure TALMultiPartFormDataFile.LoadFromFile(aFileName: string);
begin
  TmemoryStream(FileData).LoadFromFile(aFileName);
  FileName := aFileName;
  ContentType := ALGetDefaultMIMEContentTypeFromExt(ExtractfileExt(aFileName));
end;

{****************************************************************}
procedure TALMultiPartFormDataFile.SaveToFile(SaveAsFile: string);
begin
  TMemoryStream(FFileData).SaveToFile(SaveAsFile);
end;

{***************************************************************}
procedure TALMultiPartFormDataFile.SaveToStream(Stream: TStream);
begin
  FileData.Position := 0;
  TMemoryStream(FFileData).SaveToStream(Stream);
  Stream.Position := 0;
end;




//////////////////////////////////////////////////////////////////
//////////  TALHTTPFiles  ////////////////////////////////////////
//////////////////////////////////////////////////////////////////

{*********************************************************************************}
function TALMultiPartFormDataFiles.Add(AObject: TALMultiPartFormDataFile): Integer;
begin
  Result := inherited Add(AObject);
end;

{***************************************************************}
function TALMultiPartFormDataFiles.Add: TALMultiPartFormDataFile;
begin
  Result := TALMultiPartFormDataFile.Create;
  Try
    add(result);
  except
    Result.Free;
    raise;
  end;
end;

{***********************************************************************************}
function TALMultiPartFormDataFiles.GetItem(Index: Integer): TALMultiPartFormDataFile;
begin
  Result := TALMultiPartFormDataFile(inherited Items[Index]);
end;

{*************************************************************************************}
function TALMultiPartFormDataFiles.IndexOf(AObject: TALMultiPartFormDataFile): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

{********************************************************************************************}
procedure TALMultiPartFormDataFiles.Insert(Index: Integer; AObject: TALMultiPartFormDataFile);
begin
  inherited Insert(Index, AObject);
end;

{************************************************************************************}
function TALMultiPartFormDataFiles.Remove(AObject: TALMultiPartFormDataFile): Integer;
begin
  Result := inherited Remove(AObject);
end;

{*********************************************************************************************}
procedure TALMultiPartFormDataFiles.SetItem(Index: Integer; AObject: TALMultiPartFormDataFile);
begin
  inherited Items[Index] := AObject;
end;




//////////////////////////////////////////////////////////////////
//////////  TALMultipartFormParser  //////////////////////////////
//////////////////////////////////////////////////////////////////

{*********************************************}
constructor TALMultipartFormDataDecoder.Create;
begin
  inherited;
  FContentFiles := TALMultiPartFormDataFiles.Create;
  FContentfiles.OwnsObjects := True;
  FContentFields := TStringList.Create;
  FRemoveDuplicateField := True;
end;

{*********************************************}
destructor TALMultipartFormDataDecoder.Destroy;
begin
  FContentFiles.Free;
  FContentFields.Free;
  inherited;
end;

{*******************************************************************}
procedure TALMultipartFormDataDecoder.Decode(ContentStream: Tstream);

const HeaderTerminator = #13#10#13#10;
      LnHeaderTerminator = Length(HeaderTerminator);

var ContentFile: TALMultiPartFormDataFile;
    BytesRead: Longint;
    HeaderInfoLn: Longint;
    HeaderInfo: string;
    FieldNameInHeader: string;
    ContentTypeInHeader: string;
    FileNameInHeader: string;
    HeaderDataTerminator: string;
    sBuffer: string;
    sValue: string;
    p:Integer;
    CanInsertFile : Boolean;

begin

  {read the data from the contentstream}
  ContentStream.Position := 0;
  SetLength(sBuffer, ContentStream.Size);
  ContentStream.Read(Pointer(sBuffer)^, ContentStream.Size);


  {Extract of the field}
  while Length(sBuffer) <> 0 do begin
    BytesRead := ALPos(HeaderTerminator, sBuffer) -1;
    if BytesRead = -1 then Break;
    HeaderInfo := ALLowerCase(Copy(sBuffer, 1, BytesRead));
    HeaderInfoLn := Length(HeaderInfo);
    Delete(sBuffer, 1, BytesRead + LnHeaderTerminator);

    FieldNameInHeader := '';
    ContentTypeInHeader := '';
    FileNameInHeader := '';

    {FieldNameInHeader}
    if (ALPos('name="', HeaderInfo) > 0) then begin
      FieldNameInHeader := Copy(HeaderInfo, ALPos('name="', HeaderInfo) + 6, HeaderInfoLn);
      Delete(FieldNameInHeader, ALPos('"', FieldNameInHeader), Length(FieldNameInHeader));
    end;

    {ContentTypeInHeader}
    if (ALPos('content-type:', HeaderInfo) > 0) then begin
      ContentTypeInHeader := trim(Copy(HeaderInfo, ALPos('content-type: ', HeaderInfo) + 13, HeaderInfoLn));
      P := ALpos(#13#10, ContentTypeInHeader);
      If P > 0 then Begin
        Delete(ContentTypeInHeader, P, Length(ContentTypeInHeader));
        ContentTypeInHeader := Trim(ContentTypeInHeader);
      end;
    end;

    {FileNameInHeader}
    if (ALPos('filename="', HeaderInfo) > 0) then begin
      FileNameInHeader := Copy(HeaderInfo, ALPos('filename="', HeaderInfo) + 10, HeaderInfoLn);
      Delete(FileNameInHeader, ALpos('"', FileNameInHeader), Length(FileNameInHeader));
      FileNameInHeader := ExtractFileName(FileNameInHeader);
    end;

    {Set the HeaderDataTermininator if required}
    if (HeaderDataTerminator = '') then
      HeaderDataTerminator := #13#10 + Copy(HeaderInfo, 1, ALPos(#13#10, HeaderInfo) -1);

    {Extract the data and put it in sBuffer}
    BytesRead := ALPos(HeaderDataTerminator, sBuffer) -1;
    sValue := Copy(sBuffer, 1, BytesRead);
    Delete(sBuffer, 1, BytesRead + Length(HeaderDataTerminator));


    {additional file
     Sometime, with some client browser or HTTP server, some field are duplicated!
     if the property IgnoreDuplicatedField is set to true then we need to remove
     duplicated field}
    if (ContentTypeInHeader <> '') then begin
      If (sValue <> '') then begin

        CanInsertFile := True;
        IF FRemoveDuplicateField then
          For P := 0 to ContentFiles.Count - 1 do
            With Contentfiles[P] do
              If sametext(FieldName,FieldNameInHeader) then begin
                CanInsertFile := False;
                {More bigger the file is, more lucky
                 we are the it contain the full data}
                If FileData.Size < length(Svalue) then begin
                  TmemoryStream(FileData).clear;
                  FileData.Write(Pointer(sValue)^, Length(sValue));
                  FileData.Position := 0;
                  ContentType := ContentTypeInHeader;
                  FieldName := FieldNameInHeader;
                  FileName := FileNameInHeader;
                end;
                Break;
              end;

        If CanInsertFile then begin
          ContentFile := TALMultiPartFormDataFile.Create;
          with ContentFile do begin
            FileData.Write(Pointer(sValue)^, Length(sValue));
            FileData.Position := 0;
            ContentType := ContentTypeInHeader;
            FieldName := FieldNameInHeader;
            FileName := FileNameInHeader;
            ContentFiles.Add(ContentFile);
          end;
        end;

      end;
    end

    {Then this must be additional fields of the form}
    else Begin
      P := contentFields.IndexOfName(FieldNameInHeader);
      If (not FRemoveDuplicateField) or (P=-1) then ContentFields.Add(FieldNameInHeader + '=' + sValue)
      Else If length(ContentFields.ValueFromIndex[P])<length(Svalue) then ContentFields.ValueFromIndex[P] := Svalue;
    end;
  end;

end;

{******************************************************************}
procedure TALMultipartFormDataDecoder.Decode(Request : TWebRequest);
var ContentStream: TMemoryStream;
    TotalBytes: LongInt;
    BytesRead: Longint;
    ChunkSize: Longint;
    Buffer: array of Byte;
begin

  {Full Extract of the request}
  ContentStream := TMemoryStream.Create;
  try
    BytesRead := Length(Request.Content);
    ContentStream.Write(Request.Content[1], BytesRead);
    TotalBytes := Request.ContentLength;
    if BytesRead < TotalBytes then begin
      SetLength(Buffer, TotalBytes);
      repeat
        ChunkSize := Request.ReadClient(Buffer[0], TotalBytes - BytesRead);
        if ChunkSize <= 0 then Break;
        ContentStream.Write(Buffer[0], ChunkSize);
        Inc(BytesRead, ChunkSize);
      until (TotalBytes = BytesRead);
    end;
    if Request.ContentLength - BytesRead > 0 then
      raise EALClientConnectionDropped.Create('Client Dropped Connection.'#13#10 +
        'Total Bytes indicated by Header: ' + IntToStr(TotalBytes) + #13#10 +
        'Total Bytes Read: ' + IntToStr(BytesRead));

    {parse the request now}
    Decode(ContentStream);
  finally
    ContentStream.Free;
  end;

end;




///////////////////////////////////////////////////////////////////////////////////////
////////// TAlMultiPartFormDataStream /////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

{********************************************}
constructor TAlMultiPartFormDataStream.Create;
begin
  inherited;
  FBoundary := GenerateUniqueBoundary;
  FRequestContentType := 'multipart/form-data; boundary=' + FBoundary;
end;

{***********************************************************}
procedure TAlMultiPartFormDataStream.AddFile(const FieldName,
                                                   FileName,
                                                   ContentType: string;
                                              FileData: TStream);
var sFormFieldInfo: string;
    Buffer: PChar;
    iSize: Int64;
begin
  If Position > 0 then sFormFieldInfo := #13#10
  else sFormFieldInfo := '';

  iSize := FileData.Size;
  sFormFieldInfo := sFormFieldInfo + Format(
                                            '--' + Boundary + #13#10 +
                                            'Content-Disposition: form-data; name="%s"; filename="%s"' + #13#10 +
                                            'Content-Type: %s' + #13#10 +
                                            #13#10,
                                            [FieldName,FileName,ContentType]
                                           );

  Write(Pointer(sFormFieldInfo)^, Length(sFormFieldInfo));
  FileData.Position := 0;
  GetMem(Buffer, iSize);
  try
    FileData.Read(Buffer^, iSize);
    Write(Buffer^, iSize);
  finally
    FreeMem(Buffer, iSize);
  end;
end;

{***********************************************************}
procedure TAlMultiPartFormDataStream.AddFile(const FieldName,
                                                   FileName,
                                                   ContentType: string);
var FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    AddFile(FieldName, FileName, ContentType, FileStream);
  finally
    FileStream.Free;
  end;
end;

{*************************************************************************************}
procedure TAlMultiPartFormDataStream.AddFormField(const FieldName, FieldValue: string);
var sFormFieldInfo: string;
begin
  If Position > 0 then sFormFieldInfo := #13#10
  else sFormFieldInfo := '';

  sFormFieldInfo := sFormFieldInfo + Format(
                                            '--' + Boundary + #13#10 +
                                            'Content-Disposition: form-data; name="%s"' + #13#10 +
                                            #13#10 +
                                            FieldValue,
                                            [FieldName]
                                           );

  Write(Pointer(sFormFieldInfo)^, Length(sFormFieldInfo));
end;

{*****************************************************************}
function TAlMultiPartFormDataStream.GenerateUniqueBoundary: string;
begin
  Result := '---------------------------' + FormatDateTime('mmddyyhhnnsszzz', Now);
end;

{*************************************************}
procedure TAlMultiPartFormDataStream.CloseBoundary;
var sFormFieldInfo: string;
begin
  sFormFieldInfo := #13#10 +
                    '--' + Boundary + '--' + #13#10;
  Write(Pointer(sFormFieldInfo)^, Length(sFormFieldInfo));
end;




///////////////////////////////////////////////////////////////////////////////////////
////////// TALMultipartFormDataEncoder ////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

{*********************************************}
constructor TALMultipartFormDataEncoder.Create;
begin
  FContentStream := TAlMultiPartFormDataStream.Create;
end;

{*********************************************}
destructor TALMultipartFormDataEncoder.Destroy;
begin
  FContentStream.Free;
  inherited;
end;

{*************************************************************************************************************}
procedure TALMultipartFormDataEncoder.Encode(ContentFields: TStrings; ContentFiles: TALMultiPartFormDataFiles);
Var i: Integer;
begin
  with TAlMultiPartFormDataStream(FcontentStream) do begin
    Clear;
    If assigned(ContentFiles) then
      For i := 0 to ContentFiles.Count - 1 do
        With ContentFiles[i] do
          AddFile(
                  FieldName,
                  FileName,
                  ContentType,
                  FileData
                 );

    If assigned(ContentFields) then
      With ContentFields do
        For i := 0 to Count - 1 do
          AddFormField(Names[i],ValueFromIndex[i]);
  end;
end;

end.
