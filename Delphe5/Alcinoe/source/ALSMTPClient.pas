{*************************************************************
Author:       Stéphane Vander Clock (SVanderClock@Arkadia.com)

Contributor   François PIETTE (http://www.overbyte.be)
              Paul TOTH (tothpaul@free.fr - http://tothpaul.free.fr)

EMail:        http://www.arkadia.com
              SVanderClock@Arkadia.com

product:      TALSMTPClient
Version:      3.05

Description:  TALsmtpClient class implements the SMTP protocol (RFC-821)
              Support file attachement using MIME format (RFC-1521, RFC-2045)
              Support authentification (RFC-2104)

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

Link :        http://linuxgazette.net/issue45/stumpel.html
              http://www.overbyte.be
              http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winsock/winsock/socket_options.asp
              http://www.fehcom.de/qmail/smtpauth.html
              http://www.freesoft.org/CIE/RFC/821/
              http://www.expita.com/header1.html
              http://cr.yp.to/immhf.html

Please send all your feedback to SVanderClock@Arkadia.com
**************************************************************}
unit ALSMTPClient;

interface

uses windows,
     Classes,
     WinSock,
     ALMultiPartMixedParser;

type

    {-----------------------}
    TAlSmtpClientAuthType = (
                             AlsmtpClientAuthNone,
                             alsmtpClientAuthPlain,
                             AlsmtpClientAuthLogin,
                             AlsmtpClientAuthCramMD5,
                             AlsmtpClientAuthCramSha1,
                             AlsmtpClientAuthAutoSelect
                            );

    {------------------------------------------------------}
    TAlSmtpClientAuthTypeSet = set of TAlSmtpClientAuthType;

    {--------------------------------------}
    TALSMTPClientHeader = Class(Tpersistent)
    Private
      fSendTo: String;
      fSender: String;
      fMessageID: String;
      fbcc: String;
      fContentTransferEncoding: String;
      fComments: String;
      fMIMEVersion: String;
      fPriority: String;
      fReplyTo: String;
      fSubject: String;
      fFrom: String;
      fDate: String;
      fDispositionNotificationTo: String;
      fReferences: String;
      fcc: String;
      fContentType: String;
      FCustomHeaders: Tstrings;
      Function GetRawHeaderText: String;
      procedure SetRawHeaderText(const aRawHeaderText: string);
    protected
      procedure AssignTo(Dest: TPersistent); override;
    public
      constructor Create; virtual;
      destructor Destroy; override;
      procedure Clear;
    Published
      property From: String read fFrom write fFrom; {From: John Doe <jdoe@machine.example> - Author(s) or person(s) taking responsibility for the message 4.4.1; RFC 1123: 5.2.15-16, 5.3.7; RFC 1036: 2.1.1}
      property Sender: String read fSender write fSender; {Sender: Michael Jones <mjones@machine.example> - The person or agent submitting the message to the network, if other than shown by the From header RFC 822: 4.4.2; RFC 1123: 5.2.15-16, 5.3.7; RFC 1036: 2.1.1}
      property SendTo: String read fSendTo write fSendTo; {To: Mary Smith <mary@example.net> - Primary recipient(s) RFC 822: 4.5.1; RFC 1123: 5.2.15-16, 5.3.7;}
      property cc: String read fcc write fcc; {cc: <boss@nil.test>, "Giant; \"Big\" Box" <sysservices@example.net> - Secondary, informational recipient(s) RFC 822: 4.5.2; RFC 1123: 5.2.15-16, 5.3.7;}
      property bcc: String read fbcc write fbcc; {bcc: <boss@nil.test>, "Giant; \"Big\" Box" <sysservices@example.net> - Recipient(s) not to be disclosed to other recipients ("blind carbon copy") RFC 822: 4.5.3; RFC 1123: 5.2.15-16, 5.3.7;}
      property ReplyTo: String read fReplyTo write fReplyTo; {Reply-To: "Mary Smith: Personal Account" <smith@home.example> - Suggested E-mail address for replies RFC 822: 4.4.3; RFC 1036: 2.2.1}
      property Subject: String read fSubject write fSubject; {Subject: Saying Hello - Text that provides a summary, or indicates the nature, of the message RFC 822: 4.7.1; RFC 1036: 2.1.4}
      property MessageID: String read fMessageID write fMessageID; {Message-ID: <1234@local.machine.example> -	Unique ID for the message RFC 822: 4.6.1; RFC 1036: 2.1.5}
      property References: String read fReferences write fReferences; {References: <1234@local.machine.example> <3456@example.net> - In E-mail: reference to other related messages; in Usenet: reference to replied-to-articles RFC 822: 4.6.3; RFC 1036: 2.2.5}
      property Comments: String read fComments write fComments; {Comments: Authenticated sender is gboyd@netcom.com - Text comments added to the message RFC 822: 4.7.2}
      property Date: String read fDate write fDate; {Date: Fri, 21 Nov 1997 09:55:06 -0600 - The time when the message was written (or submitted) RFC 822: 5.1; RFC 1123: 5.2.14; RFC 1036: 2.1.2}
      property ContentType: String read fContentType write fContentType; {Content-Type: text/plain; charset="iso-8859-1" - Data type and format of content RFC 1049 (historic); RFC 1123: 5.2.13; RFC 2045: 5; RFC 1766: 4.1}
      property ContentTransferEncoding: String read fContentTransferEncoding write fContentTransferEncoding; {Content-Transfer-Encoding: 8bit - Coding method used in a MIME message body RFC 2045: 6;}
      property MIMEVersion: String read fMIMEVersion write fMIMEVersion; {MIME-Version: 1.0 - specifies the version of MIME that the message format complies with RFC 2045: 4}
      property Priority: String read fPriority write fPriority; {Priority: normal - Priority for message delivery ("normal" / "non-urgent" / "urgent") RFC 2156}
      property DispositionNotificationTo: String read fDispositionNotificationTo write fDispositionNotificationTo; {Disposition-Notification-To: boss@nil.test - Requests for notification when the message is received, and specifies the address for them RFC 2298}
      property CustomHeaders: Tstrings read FCustomHeaders;
      Property RawHeaderText: String read GetRawHeaderText write SetRawHeaderText;
    end;

    {----------------------------}
    TAlSmtpClient = class(TObject)
    Private
      FWSAData : TWSAData;
      Fconnected: Boolean;
      FSocketDescriptor: Integer;
      FAuthTypesSupported: TAlSmtpClientAuthTypeSet;
      Ftimeout: integer;
      procedure Settimeout(const Value: integer);
    protected
      procedure CheckError(Error: Boolean);
      Function SendCmd(aCmd:String; OkResponses: array of Word): String; virtual;
      Function GetResponse(OkResponses: array of Word): String;
      Function SocketWrite(Var Buffer; Count: Longint): Longint; Virtual;
      Function SocketRead(var Buffer; Count: Longint): Longint; Virtual;
    public
      constructor Create; virtual;
      destructor Destroy; override;
      Function Connect(aHost: String; APort: integer): String; virtual;
      Function Helo: String; virtual;
      Function Ehlo: String; virtual;
      Function Auth(AUserName, APassword: String; aAuthType: TalSmtpClientAuthType): String; virtual;
      Function Vrfy(aUserName: String): String; virtual;
      Function MailFrom(aFromName: String): String; virtual;
      Function RcptTo(aRcptNameLst: Tstrings): String; virtual;
      Function Data(aMailData: String): String; overload; virtual;
      Function Data(aHeader, aBody: String): String; overload; virtual;
      Function Data(aHeader:TALSMTPClientHeader; aBody: String): String; overload; virtual;
      Function DataMultipartMixed(aHeader: TALSMTPClientHeader; aInlineText, aInlineTextContentType: String; aAttachments: TALMultiPartMixedAttachments): String; virtual;
      Function Quit: String; virtual;
      Function Rset: String; virtual;
      procedure SendMail(aHost: String; APort: integer; aFromName: String; aRcptNameLst: Tstrings; AUserName, APassword: String; aAuthType: TalSmtpClientAuthType; aMailData: String); overload; virtual;
      procedure SendMail(aHost: String; APort: integer; aFromName: String; aRcptNameLst: Tstrings; AUserName, APassword: String; aAuthType: TalSmtpClientAuthType; aHeader, aBody: String); overload; virtual;
      procedure SendMailMultipartMixed(aHost: String; APort: integer; aFromName: String; aRcptNameLst: Tstrings; AUserName, APassword: String; aAuthType: TalSmtpClientAuthType; aHeader: TALSMTPClientHeader; aInlineText, aInlineTextContentType: String; aAttachments: TALMultiPartMixedAttachments); virtual;
      Procedure Disconnect; virtual;
      Function GetAuthTypeFromEhloResponse(EhloResponse: string): TAlSmtpClientAuthTypeSet; virtual;
      property Connected: Boolean read FConnected;
      Property Timeout: integer read Ftimeout write Settimeout default 60000;
    end;

{----------------------------------------------------------------------------------------}
function AlSMTPClientParseEmail(FriendlyEmail: String; var FriendlyName : String): String;
Function AlSMTPClientGenerateMessageID: String;

implementation

Uses SysUtils,
     AlFcnMime,
     AlFcnWinsock,
     AlFcnRfc,
     AlFcnMisc,
     AlFcnString;

{***************************************************************************}
{ FriendlyEmail                  FriendlyName   Result                      }
{ ----------------------------   ------------   --------------              }
{ myname <name@domain.com>       'myname'       name@domain.com             }
{ myname name@domain.com         'myname'       name@domain.com             }
{ "my name" <name@domain.com>    'my name'      name@domain.com             }
{ 'my name' <name@domain.com>    'my name'      name@domain.com             }
{ name@domain.com                empty          name@domain.com             }
{ <name@domain.com>              empty          name@domain.com             }
{ "name@domain.com"              empty          name@domain.com             }
function AlSMTPClientParseEmail(FriendlyEmail: String; var FriendlyName : String): String;
var I, J  : Integer;
    Flag  : Boolean;
    Delim : Char;
begin
  Result := '';
  FriendlyName := '';
  Flag := (ALCharPos('<', FriendlyEmail) > 0);
  { Skip spaces }
  I := 1;
  while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] = ' ') do Inc(I);
  if I > Length(FriendlyEmail) then Exit;
  { Check if quoted string }
  if FriendlyEmail[I] in ['"', ''''] then begin
    Delim := FriendlyEmail[I];
    { Skip opening quote }
    Inc(I);
    { Go to closing quote }
    J := I;
    while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] <> Delim) do Inc(I);
    FriendlyName := AlCopyStr(FriendlyEmail, J, I - J);
    Inc(I);
    if Flag then begin
      { Go to less-than sign }
      while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] <> '<') do Inc(I);
      Inc(I);
      J := I;
      while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] <> '>') do Inc(I);
      Result := AlCopyStr(FriendlyEmail, J, I - J);
    end
    else Result := Trim(AlCopyStr(FriendlyEmail, I, Length(FriendlyEmail)));
  end
  else begin
    if Flag then begin
      { Go to less-than sign }
      J := I;
      while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] <> '<') do Inc(I);
      FriendlyName := Trim(AlCopyStr(FriendlyEmail, J, I - J));
      Inc(I);
      { Go to greater-than sign }
      J := I;
      while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] <> '>') do Inc(I);
      Result := AlCopyStr(FriendlyEmail, J, I - J);
    end
    else begin
      { No <..>, goto next space }
      J := I;
      while (I <= Length(FriendlyEmail)) and (FriendlyEmail[I] <> ' ') do Inc(I);
      FriendlyName := Trim(AlCopyStr(FriendlyEmail, J, I - J));
      Result := Trim(AlCopyStr(FriendlyEmail, I + 1, Length(FriendlyEmail)));
    end;
  end;
  if (Result = '') and (AlCharPos('@', FriendlyName) > 0) then begin
    Result := FriendlyName;
    FriendlyName := '';
  end;
end;

{*********************************************}
Function AlSMTPClientGenerateMessageID: String;
Begin
  Result := AlStringReplace(ALMakeKeyStrByGUID,'-','',[rfReplaceAll]) + '@' + AlGetLocalHostName;
end;




/////////////////////////////////////////
////////// TALSMTPClientHeader //////////
/////////////////////////////////////////

{********************************************************}
procedure TALSMTPClientHeader.AssignTo(Dest: TPersistent);
begin
  if Dest is TALSMTPClientHeader then begin
    with Dest as TALSMTPClientHeader do begin
      fSendTo := self.fSendTo;
      fSender := self.fSender;
      fMessageID := self.fMessageID;
      fbcc := self.fbcc;
      fContentTransferEncoding := self.fContentTransferEncoding;
      fComments := self.fComments;
      fMIMEVersion := self.fMIMEVersion;
      fPriority := self.fPriority;
      fReplyTo := self.fReplyTo;
      fSubject := self.fSubject;
      fFrom := self.fFrom;
      fDate := self.fDate;
      fDispositionNotificationTo := self.fDispositionNotificationTo;
      fReferences := self.fReferences;
      fcc := self.fcc;
      fContentType := self.fContentType;
      FCustomHeaders.Assign(FCustomHeaders);
    end;
  end
  else inherited AssignTo(Dest);
end;

{**********************************}
procedure TALSMTPClientHeader.Clear;
begin
  fSendTo := '';
  fSender := '';
  fMessageID := '';
  fbcc := '';
  fContentTransferEncoding := '';
  fComments := '';
  fMIMEVersion := '';
  fPriority := '';
  fReplyTo := '';
  fSubject := '';
  fFrom := '';
  fDate := '';
  fDispositionNotificationTo := '';
  fReferences := '';
  fcc := '';
  fContentType := '';
  FCustomHeaders.Clear;
end;

{*************************************}
constructor TALSMTPClientHeader.Create;
begin
  inherited create;
  FCustomHeaders:= TstringList.create;
  FCustomHeaders.NameValueSeparator := ':';
  clear;
  fMessageID := 'AUTO';
  fMIMEVersion := '1.0';
  fDate := 'NOW';
  fContentType := 'text/plain';
end;

{*************************************}
destructor TALSMTPClientHeader.Destroy;
begin
  FCustomHeaders.free;
  inherited;
end;

{****************************************************}
function TALSMTPClientHeader.GetRawHeaderText: String;
Var i : integer;
    Str: String;
begin
  Result := '';
  If Trim(fFrom) <> '' then result := result + 'From: ' + trim(fFrom) + #13#10;
  If Trim(fSender) <> '' then result := result + 'Sender: ' + trim(fSender) + #13#10;
  If Trim(fSendTo) <> '' then result := result + 'To: ' + trim(fSendTo) + #13#10;
  If Trim(fcc) <> '' then result := result + 'cc: ' + trim(fcc) + #13#10;
  If Trim(fbcc) <> '' then result := result + 'bcc: ' + trim(fbcc) + #13#10;
  If Trim(fReplyTo) <> '' then result := result + 'Reply-To: ' + trim(fReplyTo) + #13#10;
  If Trim(fSubject) <> '' then result := result + 'Subject: ' + trim(fSubject) + #13#10;
  Str := fMessageID;
  If Trim(str) <> '' then begin
    If sametext(Str, 'AUTO') then Str := '<' + AlSMTPClientGenerateMessageID + '>';
    result := result + 'Message-ID: ' + trim(str) + #13#10;
  end;
  If Trim(fReferences) <> '' then result := result + 'References: ' + trim(fReferences) + #13#10;
  If Trim(fComments) <> '' then result := result + 'Comments: ' + trim(fComments) + #13#10;
  Str := fDate;
  If Trim(str) <> '' then begin
    If sametext(Str, 'NOW') then Str := ALDateTimeToRfc822Str(Now);
    result := result + 'Date: ' + trim(str) + #13#10;
  end;
  If Trim(fContentType) <> '' then result := result + 'Content-Type: ' + trim(fContentType) + #13#10;
  If Trim(fContentTransferEncoding) <> '' then result := result + 'Content-Transfer-Encoding: ' + trim(fContentTransferEncoding) + #13#10;
  If Trim(fMIMEVersion) <> '' then result := result + 'MIME-Version: ' + trim(fMIMEVersion) + #13#10;
  If Trim(fPriority) <> '' then result := result + 'Priority: ' + trim(fPriority) + #13#10;
  If Trim(fDispositionNotificationTo) <> '' then result := result + 'Disposition-Notification-To: ' + trim(fDispositionNotificationTo) + #13#10;
  For i := 0 to FCustomHeaders.count - 1 do
    if (trim(FCustomHeaders.names[i]) <> '') and (trim(FCustomHeaders.ValueFromIndex[i]) <> '') then
      result := result + FCustomHeaders.names[i] + ': ' + trim(FCustomHeaders.ValueFromIndex[i]) + #13#10;
end;

{***************************************************************************}
procedure TALSMTPClientHeader.SetRawHeaderText(const aRawHeaderText: string);
Var aRawHeaderLst: TstringList;

  {-------------------------------------}
  Function AlG001(aName: String): String;
  Var i: Integer;
      Str: String;
  Begin
    I := aRawHeaderLst.IndexOfName(aName);
    If I >= 0 then Begin
      result := Trim(aRawHeaderLst.ValueFromIndex[i]);
      aRawHeaderLst.Delete(i);
      While True do begin
        If i >= aRawHeaderLst.Count then break;
        str := aRawHeaderLst[i];
        If (str = '') or
           (not (str[1] in [' ',#9])) then break; //(1) an empty line or (2) a line that does not start with a space, a tab, or a field name followed by a colon
        Result := trim(result + ' ' + trim(str));
        aRawHeaderLst.Delete(i);
      end;
    end
    else result := '';
  end;

Var Str1, Str2: String;
    j: integer;
begin
  aRawHeaderLst := TstringList.create;
  try
    aRawHeaderLst.NameValueSeparator := ':';
    aRawHeaderLst.Text := aRawHeaderText;

    fFrom:= Alg001('From');
    fSender:= Alg001('Sender');
    fSendTo:= Alg001('To');
    fcc:= Alg001('cc');
    fbcc:= Alg001('bcc');
    fReplyTo:= Alg001('Reply-To');
    fSubject:= Alg001('Subject');
    fMessageID:= Alg001('Message-ID');
    fReferences:= Alg001('References');
    fComments:= Alg001('Comments');
    fDate:= Alg001('Date');
    fContentType:= Alg001('Content-Type');
    fContentTransferEncoding:= Alg001('Content-Transfer-Encoding');
    fMIMEVersion:= Alg001('MIME-Version');
    fPriority:= Alg001('Priority');
    fDispositionNotificationTo:= Alg001('Disposition-Notification-To');

    FCustomHeaders.clear;
    J := 0;
    while j <= aRawHeaderLst.count - 1 do begin
      Str1 := trim(aRawHeaderLst.Names[j]);
      If (trim(str1) <> '') and (not (str1[1] in [' ',#9])) then begin
        Str1 := trim(Str1) + ': ' + trim(aRawHeaderLst.ValueFromIndex[j]);
        inc(j);
        While True do begin
          If j >= aRawHeaderLst.Count then break;
          str2 := aRawHeaderLst[j];
          If (str2 = '') or
             (not (str2[1] in [' ',#9])) then break; //(1) an empty line or (2) a line that does not start with a space, a tab, or a field name followed by a colon
          Str1 := trim(Str1 + ' ' + trim(str2));
          inc(j);
        end;
        FCustomHeaders.Add(Str1);
      end
      else inc(j);
    end;

  finally
    aRawHeaderLst.Free;
  end;
end;




///////////////////////////////////
////////// TAlSmtpClient //////////
///////////////////////////////////

{*******************************}
constructor TAlSmtpClient.Create;
begin
  FWSAData.wVersion := 0;
  Fconnected:= False;
  FSocketDescriptor:= INVALID_SOCKET;
  FAuthTypesSupported:= [];
  Ftimeout:= 60000;
  Randomize;
end;

{*******************************}
destructor TAlSmtpClient.Destroy;
begin
  If Fconnected then Disconnect;
  inherited;
end;

{*************************************************}
procedure TAlSmtpClient.CheckError(Error: Boolean);
var ErrCode: Integer;
    S: string;
begin
  ErrCode := WSAGetLastError;
  if Error and (ErrCode <> 0) then begin
    Case ErrCode Of
      WSAEINTR: S := 'Interrupted function call';
      WSAEACCES: S := 'Permission denied';
      WSAEFAULT: S := 'Bad address';
      WSAEINVAL: S := 'Invalid argument';
      WSAEMFILE: S := 'Too many open files';
      WSAEWOULDBLOCK: S := 'Resource temporarily unavailable';
      WSAEINPROGRESS: S := 'Operation now in progress';
      WSAEALREADY: S := 'Operation already in progress';
      WSAENOTSOCK: S := 'Socket operation on nonsocket';
      WSAEDESTADDRREQ: S := 'Destination address required';
      WSAEMSGSIZE: S := 'Message too long';
      WSAEPROTOTYPE: S := 'Protocol wrong type for socket';
      WSAENOPROTOOPT: S := 'Bad protocol option';
      WSAEPROTONOSUPPORT: S := 'Protocol not supported';
      WSAESOCKTNOSUPPORT: S := 'Socket type not supported';
      WSAEOPNOTSUPP: S := 'Operation not supported';
      WSAEPFNOSUPPORT: S := 'Protocol family not supported';
      WSAEAFNOSUPPORT: S := 'Address family not supported by protocol family';
      WSAEADDRINUSE: S := 'Address already in use';
      WSAEADDRNOTAVAIL: S := 'Cannot assign requested address';
      WSAENETDOWN: S := 'Network is down';
      WSAENETUNREACH: S := 'Network is unreachable';
      WSAENETRESET: S := 'Network dropped connection on reset';
      WSAECONNABORTED: S := 'Software caused connection abort';
      WSAECONNRESET: S := 'Connection reset by peer';
      WSAENOBUFS: S := 'No buffer space available';
      WSAEISCONN: S := 'Socket is already connected';
      WSAENOTCONN: S := 'Socket is not connected';
      WSAESHUTDOWN: S := 'Cannot send after socket shutdown';
      WSAETIMEDOUT: S := 'Connection timed out';
      WSAECONNREFUSED: S := 'Connection refused';
      WSAEHOSTDOWN: S := 'Host is down';
      WSAEHOSTUNREACH: S := 'No route to host';
      WSAEPROCLIM: S := 'Too many processes';
      WSASYSNOTREADY: S := 'Network subsystem is unavailable';
      WSAVERNOTSUPPORTED: S := 'Winsock.dll version out of range';
      WSANOTINITIALISED: S := 'Successful WSAStartup not yet performed';
      WSAEDISCON: S := 'Graceful shutdown in progress';
      WSAHOST_NOT_FOUND: S := 'Host not found';
      WSATRY_AGAIN: S := 'Nonauthoritative host not found';
      WSANO_RECOVERY: S := 'This is a nonrecoverable error';
      WSANO_DATA: S := 'Valid name, no data record of requested type';
      else Begin
        SetLength(S, 256);
        FormatMessage(
                      FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_FROM_HMODULE,
                      Pointer(GetModuleHandle('wsock32.dll')),
                      ErrCode,
                      0,
                      PChar(S),
                      Length(S),
                      nil
                     );
        SetLength(S, StrLen(PChar(S)));
        while (Length(S) > 0) and (S[Length(S)] in [#10, #13]) do SetLength(S, Length(S) - 1);
      end;
    end;
    raise Exception.CreateFmt('%s (Error code:%s)', [S, inttostr(ErrCode)]);      { Do not localize }
  end;
end;

{********************************************************************}
Function TAlSmtpClient.Connect(aHost: String; APort: integer): String;

  {---------------------------------------------}
  procedure CallServer(Server:string; Port:word);
  var SockAddr:Sockaddr_in;
      IP: String;
  begin
    FSocketDescriptor:=Socket(AF_INET,SOCK_STREAM,IPPROTO_IP);
    CheckError(FSocketDescriptor=INVALID_SOCKET);
    FillChar(SockAddr,SizeOf(SockAddr),0);
    SockAddr.sin_family:=AF_INET;
    SockAddr.sin_port:=swap(Port);
    SockAddr.sin_addr.S_addr:=inet_addr(Pchar(Server));
    If SockAddr.sin_addr.S_addr = INADDR_NONE then begin
      checkError(ALHostToIP(Server, IP));
      SockAddr.sin_addr.S_addr:=inet_addr(Pchar(IP));
    end;
    CheckError(WinSock.Connect(FSocketDescriptor,SockAddr,SizeOf(SockAddr))=SOCKET_ERROR);
  end;

begin
  if FConnected then raise Exception.Create('SMTP component already connected');

  Try

    WSAStartup (MAKEWORD(2,2), FWSAData);
    CallServer(aHost,aPort);
    CheckError(setsockopt(FSocketDescriptor,SOL_SOCKET,SO_RCVTIMEO,PChar(@FTimeOut),SizeOf(Integer))=SOCKET_ERROR);
    CheckError(setsockopt(FSocketDescriptor,SOL_SOCKET,SO_SNDTIMEO,PChar(@FTimeOut),SizeOf(Integer))=SOCKET_ERROR);
    Result := GetResponse([220]);
    FAuthTypesSupported := [];
    Fconnected := True;

  Except
    Disconnect;
    raise;
  end;

end;

{*********************************}
procedure TAlSmtpClient.Disconnect;
begin
  If Fconnected then begin
    ShutDown(FSocketDescriptor,SD_BOTH);
    CloseSocket(FSocketDescriptor);
    FSocketDescriptor := INVALID_SOCKET;
    if FWSAData.wVersion = 2 then WSACleanup;
    FWSAData.wVersion := 0;
    Fconnected := False;
  end;
end;

{********************}
{EhloResponse is like:
 250-ec-is.net Hello your_name, ravi de vous rencontrer
 250-VRFY
 250-ETRN
 250-AUTH=LOGIN
 250-AUTH LOGIN CRAM-MD5
 250-8BITMIME
 250 SIZE 0}
Function TAlSmtpClient.GetAuthTypeFromEhloResponse(EhloResponse: string): TAlSmtpClientAuthTypeSet;
var k, J: Integer;
    Str1, Str2: String;
    Lst: TStringlist;
begin
  Result := [];
  Lst := TstringList.Create;
  Try
    Lst.Text := AlUpperCase(Trim(EhloResponse));
    For j := 0 to Lst.Count - 1 do begin
      Str1 := trim(Lst[J]);  //250-AUTH=LOGIN
      Delete(Str1, 1, 4); //AUTH=LOGIN
      Str2 := AlCopyStr(Str1, 1, 5); //AUTH=
      if (str2='AUTH ') or (Str2='AUTH=') then begin
        Str1 := AlCopyStr(Str1, 6, maxint); //LOGIN
        Str1 := AlStringReplace(Str1, '=', ' ', [rfReplaceAll]); //LOGIN
        while (str1 <> '') do begin
          K := AlCharPos(' ', Str1);
          if K <= 0 then begin
            Str2 := trim(Str1);
            Str1 := '';
          end
          else begin
            Str2 := Trim(AlCopyStr(Str1, 1, k - 1));
            Delete(Str1, 1, k);
          end;

          if Str2 = ('PLAIN') then result := result + [AlsmtpClientAuthPlain]
          else if Str2 = ('LOGIN') then result := result + [AlsmtpClientAuthLogin]
          else if Str2 = ('CRAM-MD5') then result := result + [AlsmtpClientAuthCramMD5]
          else if Str2 = ('CRAM-SHA1') then result := result + [AlsmtpClientAuthCramSHA1];

        end;
      end;
    end;
  finally
    Lst.free;
  end;
end;

{****************************************************************************************}
{This command is used to identify the sender-SMTP to the receiver-SMTP. The argument field
 contains the host name of the sender-SMTP. The receiver-SMTP identifies itself to the
 sender-SMTP in the connection greeting reply, and in the response to this command.
 This command and an OK reply to it confirm that both the sender-SMTP and the receiver-SMTP
 are in the initial state, that is, there is no transaction in progress and all state tables
 and buffers are cleared.}
Function TAlSmtpClient.Helo: String;
begin
  Result := SendCmd('HELO '+AlGetLocalHostName,[250]);
end;

{**********************************}
Function TAlSmtpClient.Ehlo: String;
begin
  result := SendCmd('EHLO '+AlGetLocalHostName,[250]);
  FAuthTypesSupported := GetAuthTypeFromEhloResponse(Result);
end;

{****************************************************************************}
{This command is used to initiate a mail transaction in which the mail data is
 delivered to one or more mailboxes. The argument field contains a reverse-path.
 The reverse-path consists of an optional list of hosts and the sender mailbox. When
 the list of hosts is present, it is a "reverse" source route and indicates that the
 mail was relayed through each host on the list (the first host in the list was the
 most recent relay). This list is used as a source route to return non-delivery notices
 to the sender. As each relay host adds itself to the beginning of the list, it must
 use its name as known in the IPCE to which it is relaying the mail rather than the IPCE
 from which the mail came (if they are different). In some types of error reporting
 messages (for example, undeliverable mail notifications) the reverse-path may be null.
 This command clears the reverse-path buffer, the forward-path buffer, and the mail data
 buffer; and inserts the reverse-path information from this command into the reverse-path buffer.}
Function TAlSmtpClient.MailFrom(aFromName: String): String;
begin
  aFromName := trim(aFromName);
  If aFromName = '' then raise Exception.Create('From name is empty');
  If AlPos(#13#10,aFromName) > 0 then raise Exception.Create('From name is invalid');
  Result := SendCmd('MAIL From:<'+aFromName+'>',[250]);
end;

{**************************************************************************************************}
Function TAlSmtpClient.Auth(AUserName, APassword: String; aAuthType: TalSmtpClientAuthType): String;

  {-----------------------------------}
  Function InternalDoAuthPlain: String;
  var aAuthPlain : String;
  begin
    If aUserName='' then raise Exception.Create('UserName is empty');
    If aPassword='' then raise Exception.Create('Password is empty');
    aAuthPlain := ALMimeBase64EncodeStringNoCRLF(aUserName + #0 + aUserName + #0 + aPassword);
    Result := SendCmd('AUTH PLAIN ' + aAuthPlain,[235]);
  end;

  {-----------------------------------}
  Function InternalDoAuthLogin: String;
  begin
    If aUserName='' then raise Exception.Create('UserName is empty');
    If aPassword='' then raise Exception.Create('Password is empty');
    SendCmd('AUTH LOGIN',[334]);
    SendCmd(ALMimeBase64EncodeStringNoCRLF(aUsername),[334]);
    Result := SendCmd(ALMimeBase64EncodeStringNoCRLF(aPassword),[235]);
  end;

var tmpAuthType: TAlSmtpClientAuthType;
begin

  if aAuthType = AlsmtpClientAuthAutoSelect then begin
    if AlsmtpClientAuthPlain in FAuthTypesSupported then tmpAuthType := AlsmtpClientAuthPlain
    else if AlsmtpClientAuthLogin in FAuthTypesSupported then tmpAuthType := AlsmtpClientAuthLogin
    else if AlsmtpClientAuthCramMD5 in FAuthTypesSupported then tmpAuthType := AlsmtpClientAuthCramMD5
    else if AlsmtpClientAuthCramSHA1 in FAuthTypesSupported then tmpAuthType := AlsmtpClientAuthCramSHA1
    else tmpAuthType := AlsmtpClientAuthNone
  end
  else tmpAuthType := aAuthType;

  case tmpAuthType of
    alsmtpClientAuthPlain : Result := InternalDoAuthPlain;
    alsmtpClientAuthLogin : result := InternalDoAuthLogin;
    alsmtpClientAuthCramMD5 : raise Exception.Create('CRAM-MD5 Authentication is not supported yet!');
    alsmtpClientAuthCramSHA1: raise Exception.Create('CRAM-SHA1 Authentication is not supported yet!');
    else raise exception.Create('No Authentication scheme found');
  end;

end;

{*************************************************************************}
{This command is used to identify an individual recipient of the mail data;
 multiple recipients are specified by multiple use of this command.}
Function TAlSmtpClient.RcptTo(aRcptNameLst: Tstrings): String;
Var i: integer;
    aRcptNameValue: String;
begin
  Result := '';
  if aRcptNameLst.Count <= 0 then raise Exception.Create('RcptName list is empty');
  For i := 0 to aRcptNameLst.Count - 1 do begin
    aRcptNameValue := trim(aRcptNameLst[i]);
    If (aRcptNameValue = '') or (AlPos(#13#10,aRcptNameValue) > 0) then raise Exception.Create('Bad entry in RcptName list');
    Result := Result + SendCmd('RCPT To:<'+aRcptNameValue+'>',[250, 251]) + #13#10;
  end;
  If result <> '' then delete(Result,Length(Result)-1,2);
end;

{********************************************************************************}
{The receiver treats the lines following the command as mail data from the sender.
 This command causes the mail data from this command to be appended to the mail data buffer.
 The mail data may contain any of the 128 ASCII character codes.
 The mail data is terminated by a line containing only a period, that is the character sequence "<CRLF>.<CRLF>".
 This is the end of mail data indication. The end of mail data indication requires that the receiver must now process
 the stored mail transaction information. This processing consumes the information in the reverse-path buffer,
 the forward-path buffer, and the mail data buffer, and on the completion of this command these buffers are cleared.
 If the processing is successful the receiver must send an OK reply. If the processing fails completely
 the receiver must send a failure reply. When the receiver-SMTP accepts a message either for relaying or for
 final delivery it inserts at the beginning of the mail data a time stamp line. The time stamp line indicates the
 identity of the host that sent the message, and the identity of the host that received the message (and is inserting this
 time stamp), and the date and time the message was received. Relayed messages will have multiple time stamp lines.
 When the receiver-SMTP makes the "final delivery" of a message it inserts at the beginning of the mail data a return path
 line. The return path line preserves the information in the <reverse-path> from the MAIL command. Here, final delivery
 means the message leaves the SMTP world. Normally, this would mean it has been delivered to the destination user, but
 in some cases it may be further processed and transmitted by another mail system.
 It is possible for the mailbox in the return path be different from the actual sender's mailbox, for example,
 if error responses are to be delivered a special error handling mailbox rather than the message senders.
 The preceding two paragraphs imply that the final mail data will begin with a return path line, followed
 by one or more time stamp lines. These lines will be followed by the mail data header and body [2].
 Special mention is needed of the response and further action required when the processing following the end of mail
 data indication is partially successful. This could arise if after accepting several recipients and the mail data,
 the receiver-SMTP finds that the mail data can be successfully delivered to some of the recipients, but it cannot
 be to others (for example, due to mailbox space allocation problems). In such a situation, the response to the DATA
 command must be an OK reply. But, the receiver-SMTP must compose and send an "undeliverable mail" notification
 message to the originator of the message. Either a single notification which lists all of the recipients that failed
 to get the message, or separate notification messages must be sent for each failed recipient. All undeliverable mail
 notification messages are sent using the MAIL command (even if they result from processing a SEND, SOML, or SAML command).}
Function TAlSmtpClient.Data(aMailData: String): String;
Var I : Integer;
begin
  SendCmd('DATA',[354]);

  i := 2;
  while i <= Length(aMailData) Do begin
    If (aMailData[i] = '.') and (aMailData[i-1] = #10) and (aMailData[i-2] = #13) then Insert('.',aMailData,i);
    inc(i);
  end;

  Result := SendCmd(aMailData + #13#10 + '.',[250]);

end;

{**********************************************************}
Function TAlSmtpClient.Data(aHeader, aBody: String): String;
begin
  result := Data(Trim(aHeader) + #13#10#13#10 + aBody);
end;

{******************************************************************************}
Function TAlSmtpClient.Data(aHeader:TALSMTPClientHeader; aBody: String): String;
begin
  result := Data(aHeader.GetRawHeaderText, aBody);
end;

{*********************************************************************}
Function TAlSmtpClient.DataMultipartMixed(aHeader: TALSMTPClientHeader;
                                          aInlineText, aInlineTextContentType: String;
                                          aAttachments: TALMultiPartMixedAttachments): String;
Var aMultipartMixedEncoder: TALMultipartMixedEncoder;
    Str: String;
begin
  aMultipartMixedEncoder := TALMultipartMixedEncoder.create;
  try
    aMultipartMixedEncoder.Encode(
                                  aInlineText,
                                  aInlineTextContentType,
                                  aAttachments
                                 );
    with aMultipartMixedEncoder do begin
      aHeader.ContentType := TAlMultiPartMixedStream(ContentStream).TopHeaderContentType;
      TAlMultiPartMixedStream(ContentStream).CloseBoundary;
      SetLength(Str,ContentStream.size);
      ContentStream.Position := 0;
      ContentStream.Read(str[1],ContentStream.Size);
    end;
    Result := Data(aHeader.GetRawHeaderText, Str);
  finally
    aMultipartMixedEncoder.free;
  end;
end;

{**************************************************************}
{This command specifies that the receiver must send an OK reply,
 and then close the transmission channel. The receiver should not
 close the transmission channel until it receives and replies to
 a QUIT command (even if there was an error). The sender should not
 close the transmission channel until it send a QUIT command and
 receives the reply (even if there was an error response to a previous
 command). If the connection is closed prematurely the receiver should
 act as if a RSET command had been received (canceling any pending
 transaction, but not undoing any previously completed transaction),
 the sender should act as if the command or transaction in progress had
 received a temporary error (4xx).}
Function TAlSmtpClient.Quit: String;
begin
  Result := SendCmd('QUIT',[221]);
  Disconnect;
end;

{**********************************}
{This command asks the receiver to confirm that the argument identifies a user.
 If it is a user name, the full name of the user (if known) and the fully
 specified mailbox are returned. This command has no effect on any of the
 reverse-path buffer, the forward-path buffer, or the mail data buffer.}
Function TAlSmtpClient.Vrfy(aUserName: String): String;
begin
  Result := SendCmd('VRFY ' + aUserName,[250]);
end;

{*************************************************************}
{This command specifies that the current mail transaction is to
 be aborted. Any stored sender, recipients, and mail data must be
 discarded, and all buffers and state tables cleared. The receiver
 must send an OK reply.}
Function TAlSmtpClient.Rset: String;
begin
  Result := SendCmd('RSET',[250]);
end;

{*********************************************}
procedure TAlSmtpClient.SendMail(aHost: String;
                                 APort: integer;
                                 aFromName: String;
                                 aRcptNameLst: Tstrings;
                                 AUserName, APassword: String;
                                 aAuthType: TalSmtpClientAuthType;
                                 aMailData: String);
begin
  If Fconnected then Disconnect;

  connect(aHost,APort);
  Try

    If aAuthType = AlsmtpClientAuthAutoSelect then ehlo
    else Helo;
    If aAuthType <> AlsmtpClientAuthNone then Auth(AUserName, APassword, aAuthType);
    mailFrom(aFromName);
    RcptTo(aRcptNameLst);
    Data(aMailData);
    Quit;

  Finally
    Disconnect;
  end;
end;

{*********************************************}
procedure TAlSmtpClient.SendMail(aHost: String;
                                 APort: integer;
                                 aFromName: String;
                                 aRcptNameLst: Tstrings;
                                 AUserName, APassword: String;
                                 aAuthType: TalSmtpClientAuthType;
                                 aHeader, aBody: String);
begin
  If Fconnected then Disconnect;

  connect(aHost,APort);
  Try

    If aAuthType = AlsmtpClientAuthAutoSelect then ehlo
    else Helo;
    If aAuthType <> AlsmtpClientAuthNone then Auth(AUserName, APassword, aAuthType);
    mailFrom(aFromName);
    RcptTo(aRcptNameLst);
    Data(aHeader, aBody);
    Quit;

  Finally
    Disconnect;
  end;
end;

{***********************************************************}
procedure TAlSmtpClient.SendMailMultipartMixed(aHost: String;
                                               APort: integer;
                                               aFromName: String;
                                               aRcptNameLst: Tstrings;
                                               AUserName, APassword: String;
                                               aAuthType: TalSmtpClientAuthType;
                                               aHeader: TALSMTPClientHeader;
                                               aInlineText, aInlineTextContentType: String;
                                               aAttachments: TALMultiPartMixedAttachments);
begin
  If Fconnected then Disconnect;

  connect(aHost,APort);
  Try

    If aAuthType = AlsmtpClientAuthAutoSelect then ehlo
    else Helo;
    If aAuthType <> AlsmtpClientAuthNone then Auth(AUserName, APassword, aAuthType);
    mailFrom(aFromName);
    RcptTo(aRcptNameLst);
    DataMultipartMixed(
                       aHeader,
                       aInlineText,
                       aInlineTextContentType,
                       aAttachments
                      );
    Quit;

  Finally
    Disconnect;
  end;
end;

{*******************************************************************************}
{commands consist of a command code followed by an argument field. Command codes
 are four alphabetic characters. Upper and lower case alphabetic characters are
 to be treated identically. Thus, any of the following may represent the mail command:
            MAIL    Mail    mail    MaIl    mAIl
 This also applies to any symbols representing parameter values, such as "TO" or "to"
 for the forward-path. Command codes and the argument fields are separated by one or
 more spaces. However, within the reverse-path and forward-path arguments case is
 important. In particular, in some hosts the user "smith" is different from the user
 "Smith". The argument field consists of a variable length character string ending
 with the character sequence <CRLF>. The receiver is to take no action until
 this sequence is received. Square brackets denote an optional argument field.
 If the option is not taken, the appropriate default is implied.
 The following are the SMTP commands:
            HELO <SP> <domain> <CRLF>
            MAIL <SP> FROM:<reverse-path> <CRLF>
            RCPT <SP> TO:<forward-path> <CRLF>
            DATA <CRLF>
            RSET <CRLF>
            SEND <SP> FROM:<reverse-path> <CRLF>
            SOML <SP> FROM:<reverse-path> <CRLF>
            SAML <SP> FROM:<reverse-path> <CRLF>
            VRFY <SP> <string> <CRLF>
            EXPN <SP> <string> <CRLF>
            HELP [<SP> <string>] <CRLF>
            NOOP <CRLF>
            QUIT <CRLF>
            TURN <CRLF>}
function TAlSmtpClient.SendCmd(aCmd: String; OkResponses: array of Word): String;
Var P: Pchar;
    L: Integer;
    ByteSent: integer;
begin
  If (length(aCmd) <= 1) or
     (aCmd[length(aCmd)] <> #10) or
     (aCmd[length(aCmd) - 1] <> #13)
  then aCmd := aCmd + #13#10;

  p:=@aCmd[1]; // pchar
  l:=length(aCmd);
  while l>0 do begin
    ByteSent:=SocketWrite(p^,l);
    if ByteSent<=0 then raise Exception.Create('Connection close gracefully!');
    inc(p,ByteSent);
    dec(l,ByteSent);
  end;

  Result := GetResponse(OkResponses);
end;

{*********************************************************************}
{An SMTP reply consists of a three digit number (transmitted as three
 alphanumeric characters) followed by some text. The number is intended
 for use by automata to determine what state to enter next; the text is
 meant for the human user. It is intended that the three digits contain
 enough encoded information that the sender-SMTP need not examine the
 text and may either discard it or pass it on to the user, as appropriate.
 In particular, the text may be receiver-dependent and context dependent,
 so there are likely to be varying texts for each reply code. Formally,
 a reply is defined to be the sequence:
 a three-digit code, <SP>, one line of text, and <CRLF>, or a multiline reply.
 Only the EXPN and HELP commands are expected to result in multiline replies
 in normal circumstances, however multiline replies are allowed for any
 command.}
function TAlSmtpClient.GetResponse(OkResponses: array of Word): String;

  {----------------------------------------------}
  function Internalstpblk(PValue : PChar) : PChar;
  begin
    Result := PValue;
    while Result^ in [' ', #9, #10, #13] do Inc(Result);
  end;

  {---------------------------------------------------------------------}
  function InternalGetInteger(Data: PChar; var Number : Integer) : PChar;
  var bSign : Boolean;
  begin
    Number := 0;
    Result := InternalStpBlk(Data);
    if (Result = nil) then Exit;
    { Remember the sign }
    if Result^ in ['-', '+'] then begin
      bSign := (Result^ = '-');
      Inc(Result);
    end
    else bSign  := FALSE;
    { Convert any number }
    while (Result^ <> #0) and (Result^ in ['0'..'9']) do begin
      Number := Number * 10 + ord(Result^) - ord('0');
      Inc(Result);
    end;
    { Correct for sign }
    if bSign then Number := -Number;
  end;

Var aBuffStr: String;
    aBuffStrLength: Integer;
    aResponse: String;
    aStatusCode: Integer;
    aGoodResponse: Boolean;
    ALst : TstringList;
    P: Pchar;
    i, j: integer;
begin
  Result := '';
  While true do begin

    {Read the response from the socket - end of the response is show by <CRLF>}
    aResponse := '';
    While True do begin
      Setlength(aBuffStr,512); //The maximum total length of a reply line including the reply code and the <CRLF> is 512 characters. (http://www.freesoft.org/CIE/RFC/821/24.htm)
      aBuffStrLength := SocketRead(aBuffStr[1], length(aBuffStr));
      aResponse := AResponse + AlCopyStr(aBuffStr,1,aBuffStrLength);
      If aResponse = '' then raise Exception.Create('Connection close gracefully!');
      If (aBuffStrLength > 1) and
         (aBuffStr[aBuffStrLength] = #10) and
         (aBuffStr[aBuffStrLength - 1] = #13) then Break;
    end;
    Result := Result + aResponse;

    {The format for multiline replies requires that every line, except the last,
     begin with the reply code, followed immediately by a hyphen, "-" (also known as minus),
     followed by text. The last line will begin with the reply code, followed immediately
     by <SP>, optionally some text, and <CRLF>.}
    ALst := TstringList.create;
    Try
      Alst.Text := aResponse;
      If Alst.count = 0 then raise exception.Create('Emtpy response');
      For j := 0 to Alst.count - 1 do begin
        aResponse := Alst[j];
        p := InternalGetInteger(@aResponse[1], aStatusCode);
        aGoodResponse := False;
        for I := 0 to High(OkResponses) do
          if OkResponses[I] = aStatusCode then begin
            aGoodResponse := True;
            Break;
          end;

        If not aGoodResponse then Raise Exception.Create(aResponse);
        if p^ <> '-' then Begin
          If J <> Alst.count - 1 then Raise Exception.Create(aResponse);
          Exit;
        end;
      end;
    Finally
      ALst.Free;
    end;

  end;
end;

{**********************************************************************}
Function TAlSmtpClient.SocketWrite(Var Buffer; Count: Longint): Longint;
begin
  Result := Send(FSocketDescriptor,Buffer,Count,0);
  CheckError(Result =  SOCKET_ERROR);
end;

{*********************************************************************}
function TAlSmtpClient.SocketRead(var Buffer; Count: Longint): Longint;
begin
  Result := Recv(FSocketDescriptor,Buffer,Count,0);
  CheckError(Result = SOCKET_ERROR);
end;

{*******************************************************}
procedure TAlSmtpClient.Settimeout(const Value: integer);
begin
  If Value <> Ftimeout then begin
    CheckError(setsockopt(FSocketDescriptor,SOL_SOCKET,SO_RCVTIMEO,PChar(@FTimeOut),SizeOf(Integer))=SOCKET_ERROR);
    CheckError(setsockopt(FSocketDescriptor,SOL_SOCKET,SO_SNDTIMEO,PChar(@FTimeOut),SizeOf(Integer))=SOCKET_ERROR);
    Ftimeout := Value;
  end;
end;

end.
