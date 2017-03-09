unit RestClientTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  IdBaseComponent, IdComponent, ComCtrls,
  XMLIntf, XMLDoc,
  RestObject, util1;

type
  TRestForm = class(TForm)
    AddressMemo: TMemo;
    Panel1: TPanel;
    Get: TButton;
    ReceiveLog: TMemo;
    MemoClear: TButton;
    Button1: TButton;
    Button2: TButton;
    procedure AnalyseChild(child: IXMLnode);
    procedure ListerChildNodes(child: IXMLnode);

    procedure GetClick(Sender: TObject);
    procedure PutClick(Sender: TObject);
    procedure MemoClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure PostClick(Sender: TObject);
  private
    { Déclarations privées }
    indent: AnsiString;
  public
    { Déclarations publiques }
  end;

var
  RestForm: TRestForm;


procedure TestRest;

implementation

{$R *.dfm}

procedure TRestForm.AnalyseChild(child: IXMLnode);
var
  st: AnsiString;
  i:integer;
begin
  st:= Child.NodeName +' tp=' +Istr(ord(Child.NodeType))+' ';
  if Child.IsTextElement then st:=st+Child.Text+' ';
  for i:=0 to Child.AttributeNodes.count-1 do
    st:=st+ Child.AttributeNodes[i].NodeName+' = '+ Child.AttributeNodes[i].NodeValue+'  ';

  ReceiveLog.Lines.Add( indent+st);

  if Child.HasChildNodes and not(Child.IsTextElement) then ListerChildNodes(Child);

end;

procedure TRestForm.ListerChildNodes(child: IXMLnode);
var
  i:integer;
begin
  indent:= indent+'    ';
  for i:= 0 to child.ChildNodes.Count-1 do
  begin
    AnalyseChild(child.ChildNodes[i]);
  end;
  delete(indent,length(indent)-4,4);
end;


{
https://www.dbunic.cnrs-gif.fr/brainscales/preparations/preparation/2?   enlever 2 pour la liste
https://www.dbunic.cnrs-gif.fr/brainscales/devices/item/4?format=xml     xml par défaut, possible format=json
}

procedure TRestForm.GetClick(Sender: TObject);
var
  rest : TRestObject;
  XMLres : IXMLDocument;
  Child : IXMLNode;
  st:string;
begin
  // request
  rest := TRestObject.Create('www.dbunic.cnrs-gif.fr',443 , 'do', 'do' );
  XMLres := rest.doGet( AddressMemo.lines[0] ); // ex: https://www.dbunic.cnrs-gif.fr/brainscales/people/researcher/5?format=xml
  rest.Destroy;


  // compute with the XML
  ReceiveLog.Lines.Clear;
  ReceiveLog.lines.Add( 'GET ...' );

  indent:='';
  AnalyseChild(XMLres.DocumentElement);

  (*
  ReceiveLog.Lines.Clear;
  ReceiveLog.Lines.Assign(XMLres.XML);
  *)
end;




procedure TRestForm.PutClick(Sender: TObject);
var
  rest : TRestObject;
  Doc : IXMLDocument;
  rootnode, childnode : IXMLNode;
begin
  // PUT
  ReceiveLog.Lines.Clear;
  ReceiveLog.lines.Add( 'PUT ...' );
  ReceiveLog.lines.Add( 'To: '+AddressMemo.lines.GetText );

  Doc := NewXMLDocument;
  Doc.Encoding := 'UTF-8';
  rootnode := Doc.AddChild('object'); // add root node
  childnode := rootnode.AddChild('country');
  childnode.Text := 'France';
  childnode := rootnode.AddChild('phone');
  childnode.Text := '0987654321';
  childnode := rootnode.AddChild('postal_code');
  childnode.Text := '75000';
  childnode := rootnode.AddChild('resource_uri');
  childnode.Text := '/brainscales/people/researcher/5';
  childnode := rootnode.AddChild('state');
  childnode.Text := 'Ile-de-France';
  childnode := rootnode.AddChild('street_address');
  childnode.Text := 'rue des Cyrils';
  childnode := rootnode.AddChild('town');
  childnode.Text := 'cit';
  childnode := rootnode.AddChild('user');
  childnode.Text := '/brainscales/people/user/5';
  childnode := rootnode.AddChild('website');
  childnode.Text := 'http://unic.cnrs-gif.fr';
  childnode := rootnode.AddChild('notes');
  childnode.Text := 'tsgdhdhg test';

  rest := TRestObject.Create( 'www.dbunic.cnrs-gif.fr', 443, 'do', 'do' );
  rest.doPut( AddressMemo.lines.GetText, Doc );
  rest.Destroy;

  //Doc.SaveToFile('C:\Elphy\projects\restclient\text1.xml'); // DEBUG
end;


procedure TRestForm.PostClick(Sender: TObject);
var
  rest : TRestObject;
  Doc : IXMLDocument;
  rootnode, childnode : IXMLNode;
begin
  // REMEMBER: you can send POST (complete XML) not to a detail but to an object
  // not to ...scales/people/researcher/5?format=xml
  // but to ...scales/people/researcher/
  // BUT REMEMBER: you can PUT or PATCH to a detail
  // not to ...scales/people/researcher/5?format=xml

  // TRY PUT
  ReceiveLog.Lines.Clear;
  ReceiveLog.lines.Add( 'POST ...' );
  ReceiveLog.lines.Add( 'To: '+AddressMemo.lines.GetText );

  Doc := NewXMLDocument;
  Doc.Encoding := 'UTF-8';
  rootnode := Doc.AddChild('object'); // add root node
  //childnode := rootnode.AddChild('id');
  //childnode.Text := '34';
  childnode := rootnode.AddChild('country');
  childnode.Text := 'Test';
  childnode := rootnode.AddChild('phone');
  childnode.Text := '0987654321';
  childnode := rootnode.AddChild('postal_code');
  childnode.Text := '00000';
  //childnode := rootnode.AddChild('resource_uri');
  //childnode.Text := '/brainscales/people/researcher/100';
  childnode := rootnode.AddChild('state');
  childnode.Text := 'Test';
  childnode := rootnode.AddChild('street_address');
  childnode.Text := 'rue des tests';
  childnode := rootnode.AddChild('town');
  childnode.Text := 'testonia';
  childnode := rootnode.AddChild('user');
  childnode.Text := '/brainscales/people/user/6';
  childnode := rootnode.AddChild('website');
  childnode.Text := 'http://test.ts';
  childnode := rootnode.AddChild('notes');
  childnode.Text := 'tetest';

  rest := TRestObject.Create( 'www.dbunic.cnrs-gif.fr', 443, 'do', 'do' );
  rest.doPost( AddressMemo.lines.GetText, Doc );
  rest.Destroy;
end;


procedure TRestForm.DeleteClick(Sender: TObject);
var
  rest : TRestObject;
begin
  // TRY PUT
  ReceiveLog.Lines.Clear;
  ReceiveLog.lines.Add( 'DELETE ...' );
  ReceiveLog.lines.Add( 'To: '+AddressMemo.lines.GetText );

  rest := TRestObject.Create( 'www.dbunic.cnrs-gif.fr', 443, 'do', 'do' );
  rest.doDelete( AddressMemo.lines.GetText );
  rest.Destroy;
end;


procedure TRestForm.MemoClearClick(Sender: TObject);
begin
  ReceiveLog.lines.clear;
end;



procedure TRestForm.FormCreate(Sender: TObject);
begin
  AddressMemo.Lines.Clear;
  AddressMemo.Lines.Add('https://www.dbunic.cnrs-gif.fr/brainscales/people/researcher/?format=xml');
  //  AddressMemo.Lines.Add('http://157.136.240.232/app/#/queue?format=xml');
end;

procedure TestRest;
begin
  if not assigned(RestForm) then restForm:= TrestForm.Create(nil);
  restForm.show;
end;

// end TForm1 obj


end.



