{*************************************************************
Author:       Stéphane Vander Clock (SVanderClock@Arkadia.com)

EMail:        http://www.arkadia.com
              SVanderClock@Arkadia.com

product:      TALMultiPartMixedAttachment
              TALMultiPartMixedAttachments
              TAlMultiPartMixedStream
              TALMultipartMixedEncoder

Version:      3.05

Description:  MultiPart Mixed function to encode stream for Email Body
              in mime multipart/mixed format. the best way to add some
              Attachments to any email content.

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

Link :        http://msdn.microsoft.com/library/default.asp?url=/library/en-us/cdosys/html/7a18a98b-3a18-45b2-83a9-28a8f4099970.asp
              http://www.ietf.org/rfc/rfc2646.txt

Please send all your feedback to SVanderClock@Arkadia.com
**************************************************************}
unit ALMultiPartMixedParser;

interface

uses Classes,
     SysUtils,
     Contnrs,
     HTTPApp;

type

  {-Single multipart attachment Object-------}
  TALMultiPartMixedAttachment = class(TObject)
  private
    FContentType: string;
    FFileName: string;
    FFileData: TStream;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(aFileName: string);
    procedure SaveToFile(SaveAsFile: string);
    procedure SaveToStream(Stream: TStream);
    property ContentType: string read FContentType write FContentType;
    property FileName: string read FFileName write FFileName;
    property FileData: TStream read FFileData;
  end;

  {--List Of multipart Objects--------------------}
  TALMultiPartMixedAttachments = class(TObjectList)
  private
  protected
    function GetItem(Index: Integer): TALMultiPartMixedAttachment;
    procedure SetItem(Index: Integer; AObject: TALMultiPartMixedAttachment);
  public
    Function Add: TALMultiPartMixedAttachment; overload;
    function Add(AObject: TALMultiPartMixedAttachment): Integer; overload;
    function Remove(AObject: TALMultiPartMixedAttachment): Integer;
    function IndexOf(AObject: TALMultiPartMixedAttachment): Integer;
    procedure Insert(Index: Integer; AObject: TALMultiPartMixedAttachment);
    property Items[Index: Integer]: TALMultiPartMixedAttachment read GetItem write SetItem; default;
  end;

  {--TAlMultiPartMixedStream-------------------}
  TAlMultiPartMixedStream = class(TMemoryStream)
  private
    FBoundary: string;
    FTopHeaderContentType: string;
    function GenerateUniqueBoundary: string;
  public
    procedure AddInlineText(const ContentType, Text: string);
    procedure AddAttachment(const FileName, ContentType: string; FileData: TStream); overload;
    procedure AddAttachment(const FileName, ContentType: string); overload;
    procedure CloseBoundary;
    constructor Create;
    property Boundary: string read FBoundary;
    property TopHeaderContentType: string read FTopHeaderContentType;
  end;

  {--TALMultipartMixedEncoder-------------}
  TALMultipartMixedEncoder = class(TObject)
  private
    FContentStream: TStream;
  public
    constructor	Create;
    destructor Destroy; override;
    procedure Encode(InlineText, InlineTextContentType: String; Attachments: TALMultiPartMixedAttachments);
    property ContentStream: TStream read FContentStream;
  end;

implementation

uses AlFcnString,
     AlFcnMime;

//////////////////////////////////////////////////////////////////
//////////  TALMultiPartMixedAttachment //////////////////////////
//////////////////////////////////////////////////////////////////

{*********************************************}
constructor TALMultiPartMixedAttachment.Create;
begin
  inherited;
  FFileData := TMemoryStream.Create;
end;

{*********************************************}
destructor TALMultiPartMixedAttachment.Destroy;
begin
  FFileData.Free;
  inherited;
end;

{*******************************************************************}
procedure TALMultiPartMixedAttachment.LoadFromFile(aFileName: string);
begin
  TmemoryStream(FileData).LoadFromFile(aFileName);
  FileName := aFileName;
  ContentType := ALGetDefaultMIMEContentTypeFromExt(ExtractfileExt(aFileName));
end;

{******************************************************************}
procedure TALMultiPartMixedAttachment.SaveToFile(SaveAsFile: string);
begin
  TMemoryStream(FFileData).SaveToFile(SaveAsFile);
end;

{******************************************************************}
procedure TALMultiPartMixedAttachment.SaveToStream(Stream: TStream);
begin
  FileData.Position := 0;
  TMemoryStream(FFileData).SaveToStream(Stream);
  Stream.Position := 0;
end;




//////////////////////////////////////////////////////////////////
//////////  TALMultiPartMixedAttachments  ////////////////////////
//////////////////////////////////////////////////////////////////

{***************************************************************************************}
function TALMultiPartMixedAttachments.Add(AObject: TALMultiPartMixedAttachment): Integer;
begin
  Result := inherited Add(AObject);
end;

{*********************************************************************}
function TALMultiPartMixedAttachments.Add: TALMultiPartMixedAttachment;
begin
  Result := TALMultiPartMixedAttachment.Create;
  Try
    add(result);
  except
    Result.Free;
    raise;
  end;
end;

{*****************************************************************************************}
function TALMultiPartMixedAttachments.GetItem(Index: Integer): TALMultiPartMixedAttachment;
begin
  Result := TALMultiPartMixedAttachment(inherited Items[Index]);
end;

{*******************************************************************************************}
function TALMultiPartMixedAttachments.IndexOf(AObject: TALMultiPartMixedAttachment): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

{**************************************************************************************************}
procedure TALMultiPartMixedAttachments.Insert(Index: Integer; AObject: TALMultiPartMixedAttachment);
begin
  inherited Insert(Index, AObject);
end;

{******************************************************************************************}
function TALMultiPartMixedAttachments.Remove(AObject: TALMultiPartMixedAttachment): Integer;
begin
  Result := inherited Remove(AObject);
end;

{***************************************************************************************************}
procedure TALMultiPartMixedAttachments.SetItem(Index: Integer; AObject: TALMultiPartMixedAttachment);
begin
  inherited Items[Index] := AObject;
end;




///////////////////////////////////////////////////////////////////////////////////////
////////// TAlMultiPartMixedStream ////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

{*****************************************}
constructor TAlMultiPartMixedStream.Create;
begin
  inherited;
  FBoundary := GenerateUniqueBoundary;
  FTopHeaderContentType := 'multipart/mixed; boundary="' + FBoundary + '"';
end;

{**********************************************************************************}
procedure TAlMultiPartMixedStream.AddAttachment(const FileName, ContentType: string;
                                                FileData: TStream);
var sFormFieldInfo: string;
    Buffer: String;
    iSize: Int64;
begin
  If Position > 0 then sFormFieldInfo := #13#10
  else sFormFieldInfo := #13#10 +
                        'This is a multi-part message in MIME format.'+ #13#10 +
                         #13#10;

  iSize := FileData.Size;
  sFormFieldInfo := sFormFieldInfo + Format(
                                            '--' + Boundary + #13#10 +
                                            'Content-Type: %s; name="%s"' + #13#10 +
                                            'Content-Transfer-Encoding: base64' + #13#10 +
                                            'Content-Disposition: attachment; filename="%s"' + #13#10 +
                                            #13#10,
                                            [ContentType, ExtractFileName(FileName), ExtractFileName(FileName)]
                                           );

  Write(Pointer(sFormFieldInfo)^, Length(sFormFieldInfo));
  FileData.Position := 0;
  SetLength(Buffer, iSize);
  FileData.Read(Buffer[1], iSize);
  Buffer := ALMimeBase64EncodeString(Buffer) + #13#10;
  Write(Buffer[1], length(Buffer));
end;

{***********************************************************************************}
procedure TAlMultiPartMixedStream.AddAttachment(const FileName, ContentType: string);
var FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    AddAttachment(FileName, ContentType, FileStream);
  finally
    FileStream.Free;
  end;
end;

{*******************************************************************************}
procedure TAlMultiPartMixedStream.AddInlineText(const ContentType, Text: string);
var sFormFieldInfo: string;
begin
  If Position > 0 then sFormFieldInfo := #13#10
  else sFormFieldInfo := #13#10 +
                        'This is a multi-part message in MIME format.' + #13#10 +
                        #13#10;

  sFormFieldInfo := sFormFieldInfo + Format(
                                            '--' + Boundary + #13#10 +
                                            'Content-Type: %s' + #13#10 +
                                            #13#10 +
                                            Text,
                                            [ContentType]
                                           );

  Write(Pointer(sFormFieldInfo)^, Length(sFormFieldInfo));
end;

{**************************************************************}
function TAlMultiPartMixedStream.GenerateUniqueBoundary: string;
begin
  Result := '---------------------------' + FormatDateTime('mmddyyhhnnsszzz', Now);
end;

{**********************************************}
procedure TAlMultiPartMixedStream.CloseBoundary;
var sFormFieldInfo: string;
begin
  sFormFieldInfo := #13#10 +
                    '--' + Boundary + '--' + #13#10;
  Write(Pointer(sFormFieldInfo)^, Length(sFormFieldInfo));
end;




////////////////////////////////////////////////////////////////////////////////////
////////// TALMultipartMixedEncoder ////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

{******************************************}
constructor TALMultipartMixedEncoder.Create;
begin
  FContentStream := TAlMultiPartMixedStream.Create;
end;

{******************************************}
destructor TALMultipartMixedEncoder.Destroy;
begin
  FContentStream.Free;
  inherited;
end;

{***************************************************}
procedure TALMultipartMixedEncoder.Encode(InlineText,
                                          InlineTextContentType: String;
                                          Attachments: TALMultiPartMixedAttachments);
Var i: Integer;
begin
  with TAlMultiPartMixedStream(FcontentStream) do begin
    Clear;
    AddInlineText(InlineTextContentType, InlineText);

    If assigned(Attachments) then
      For i := 0 to Attachments.Count - 1 do
        With Attachments[i] do
          AddAttachment(
                        FileName,
                        ContentType,
                        FileData
                       );
  end;
end;

end.
