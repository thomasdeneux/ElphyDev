(*
   RestObject

   Simple class to interact with a RESTful Web Service
   Given a domain, port and user credentials, it is able to retrieve from and post to an address XML strings.

   Example
   In your class or unit, declare that:
   uses RestObject;

   Then, among your variable declaration:
   var rest : TRestObject;

   You can now create the object, with the credentials:
   rest := TRestObject.Create( 'www.dbunic.cnrs-gif.fr', 443, 'do', 'do' );

   Then address a GET request to the Web Service:
   XMLres := rest.getXML( 'https://www.dbunic.cnrs-gif.fr/brainscales/people/researcher/5?format=xml' );

   Once received the XML, you want to destroy the object to free:
   rest.Destroy;

   And operate the XML:
   ReceiveLog.lines.Add( XMLres.DocumentElement.NodeName );
*)

unit RestObject;

interface

uses
  Windows, SysUtils, Dialogs, Classes, EncdDecd,
  util1,
  IdHTTP, IdException, IdStack, IdHeaderList,
  IdAuthentication, IdSSLOpenSSL, IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSLHeaders,
  XMLIntf, XMLDoc;

  //IdSSLOpenSSL requires additional dll:
  // ssleay32.dll
  // libeay32.dll
  // vsinit.dll


(* ---------------- START Object --------------- *)
type
  TRestObject = class( TObject )
    host : String;
    port : String;
    username : String;
    password : String;

    ErrorString: AnsiString;
  private
    http : TIdHttp;
    SSLhandler : TIdSSLIOHandlerSocketOpenSSL;
    Response : String;
    function getXMLstring( getUrl:String ) : String;

  public
    // init communications
    constructor Create( host:String; port:Integer; username,password : String );
    destructor Destroy(); Override;
    function doGet( getUrl:String ) : IXMLDocument;
    procedure doPost( postURL:String; doc:IXMLDocument );
    procedure doPut( putURL:String; doc:IXMLDocument );
    procedure doDelete( deleteUrl:String );
  end;


implementation


// Methods
constructor TRestObject.Create( host:String; port:Integer; username,password : String );
begin
  // create objects
  http := TIDHttp.Create;
  SSLhandler := TIdSSLIOHandlerSocketOpenSSL.Create;
  SSLhandler.SSLOptions.Method := sslvSSLv23;
  SSLhandler.Host := host; // domain
  SSLhandler.Port := port; // HTTPS
  // population
  http.IOHandler := SSLhandler;
  http.HandleRedirects := True;
  // auth
  http.Request.BasicAuthentication := True;
  http.Request.Username := username;
  http.Request.Password := password;
  // additional
  http.Request.Host := 'Indy 10';
  http.Request.Accept := 'text/xml';
  http.Request.ContentType := 'application/xml';
  http.ReadTimeout := 10000;
  http.ConnectTimeout := 10000;
  //http.Request.Connection := 'close';
  //http.Request.ContentEncoding := 'UTF-8';
  //http.HTTPOptions := [];

  //LoadLibrary( 'libeay32.dll' );
  //LoadLibrary( 'ssleay32.dll' );
  //LoadLibrary( 'vsinit.dll' );
end;



destructor TRestObject.Destroy();
begin
  http.Disconnect; // otherwise: EIdConnClosedGracefully (the connection has been closed in agreement)
  http.Free;
  SSLhandler.Free;
  // remove dll
  //FreeLibrary( GetModuleHandle('libeay32.dll') );
  //FreeLibrary( GetModuleHandle('ssleay32.dll') );
end;



// utility functions

function TRestObject.getXMLstring( getUrl:String ) : String;
begin
  try
    ErrorString:='';
    Response := http.Get( getUrl );
  except
    on E: EIdConnClosedGracefully do
      ;
    on E: EIdHTTPProtocolException do
      ErrorString := 'Protocol Exception (HTTP status '+ IntToStr(E.ErrorCode) +'): ' + E.Message;
    on E: EIdSocketError do
      ErrorString := 'Socket Error ('+ IntToStr(E.LastError) +'): ' + E.Message;
    on E: EIdException do
      ErrorString := 'Exception (class '+ E.ClassName +'): ' + E.Message;
  end;
  Result := Response;
end;


// PUBLIC


// DELETE
// Detete requires a full address to a detail (without format specification):
// https://www.dbunic.cnrs-gif.fr/brainscales/people/researcher/12
procedure TRestObject.doDelete( deleteUrl:String );
begin
  // check address for a detail (although tastypie is checking it as well)
  try
    http.Delete( deleteURL );
    ShowMessage( http.ResponseText );
  except
    on E: EIdConnClosedGracefully do
      ;
    on E: EIdHTTPProtocolException do
      ShowMessage('Protocol Exception (HTTP status '+ IntToStr(E.ErrorCode) +'): ' + E.Message);
    on E: EIdSocketError do
      ShowMessage('Socket Error ('+ IntToStr(E.LastError) +'): ' + E.Message);
    on E: EIdException do
      ShowMessage('Exception (class '+ E.ClassName +'): ' + E.Message);
  end;
end;


// POST
// Post to server should be sent only to base address (the list) not to details
procedure TRestObject.doPost( postURL:String; doc:IXMLDocument );
var
  data : TStringStream;
  xmlString : String;
  xmlPayloadStart : Integer;
begin
  xmlString := doc.XML.Text;
  // remove xml header
  xmlPayloadStart := Pos('<object', doc.XML.Text);
  if( xmlPayloadStart > 0 ) then
  begin
    xmlString := copy( doc.XML.Text, xmlPayloadStart, length(doc.XML.Text)-xmlPayloadStart );
  end;
  ShowMessage(xmlString);
  data := TStringStream.Create( xmlString );
  try
    data.Position := 0;
    http.Post( postURL, data );
  except
    on E: EIdConnClosedGracefully do
      ;
    on E: EIdHTTPProtocolException do
      ShowMessage('Protocol Exception (HTTP status '+ IntToStr(E.ErrorCode) +'): ' + E.Message);
    on E: EIdSocketError do
      ShowMessage('Socket Error ('+ IntToStr(E.LastError) +'): ' + E.Message);
    on E: EIdException do
      ShowMessage('Exception (class '+ E.ClassName +'): ' + E.Message);
  end;
  ShowMessage( http.ResponseText );
  data.Free;
end;



// PUT
// Put requires a full resource detail address
procedure TRestObject.doPut( putURL:String; doc:IXMLDocument );
var
  data : TStringStream;
  xmlString : String;
  xmlPayloadStart : Integer;
begin
  xmlString := doc.XML.Text;
  // remove xml header
  xmlPayloadStart := Pos('<object', doc.XML.Text);
  if( xmlPayloadStart > 0 ) then
  begin
    xmlString := copy( doc.XML.Text, xmlPayloadStart, length(doc.XML.Text)-xmlPayloadStart );
  end;
  ShowMessage(xmlString);
  data := TStringStream.Create( xmlString );
  try
    data.Position := 0;
    http.Put( putURL, data );
  except
    on E: EIdConnClosedGracefully do
      ;
    on E: EIdHTTPProtocolException do
      ShowMessage('Protocol Exception (HTTP status '+ IntToStr(E.ErrorCode) +'): ' + E.Message);
    on E: EIdSocketError do
      ShowMessage('Socket Error ('+ IntToStr(E.LastError) +'): ' + E.Message);
    on E: EIdException do
      ShowMessage('Exception (class '+ E.ClassName +'): ' + E.Message);
  end;
  ShowMessage( http.ResponseText );
  data.Free;
end;


// GET
// Get works both for detail resource and list
function TRestObject.doGet( getUrl:String ) : IXMLDocument;
var
  res, XMLstring : String;
  //rest : TRestObject;
  XMLstart : Integer;
  XMLres : IXMLDocument;
begin
  res := getXMLstring( getUrl );
  // parse
  // continue only if XML is present (search for '<?xml')
  XMLstart := Pos( res, '<?xml' );
  if( XMLstart >= 0 ) then
  begin
    // remove all Indy specific headers
    XMLstring := copy( res, XMLstart, length(res)-XMLstart );
    //ReceiveLog.lines.Add( XMLstring );
    XMLres := LoadXMLData( XMLstring );
  end
  else
  begin
    XMLres:=nil;
    ErrorString:= 'Internal Error SSL: '+WhichFailedToLoad+ crlf+' Try reloading the resource.' ;
  end;
  // return
  
  Result := XMLres;
end;



(* ---------------- END Object --------------- *)
end.
