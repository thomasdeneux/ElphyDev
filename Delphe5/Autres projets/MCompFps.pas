unit MCompFps;

interface

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,

  util1;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    Declarations:TstringList;
  public
    { Public declarations }
    procedure compiler;
    procedure compilerLigne(st:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  declarations:=TstringList.Create;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  compiler;
end;

procedure Tform1.compilerLigne(st:string);
var
  stM,mot1,mot2,mot3:string;
  sep1:string;
  stS,st1,stTp:string;
const
  seps=['.','(',')',':',';'];

begin
  mot1:=sortirMot([],st);
  mot2:=sortirMot(seps,st);
  sep1:=sortirMot(seps,st);
  mot3:=sortirMot(seps,st);
  if mot1='' then exit;


  if Fmaj(mot1)='PROCEDURE' then
    begin
      stS:='Procedure '+'pro'+mot2+'_'+mot3;
      if st[1]='('
        then insert(';var pu:typeUO',st,pos(')',st))
        else st:='(var pu:typeUO);';
      stS:=stS+st;


      stS:=StringReplace(StS,'real','float',[rfReplaceAll, rfIgnoreCase]);
      stS:=StringReplace(StS,'string','shortString',[rfReplaceAll, rfIgnoreCase]);

      memo2.lines.add(stS);
      memo2.lines.add('begin');
      memo2.lines.add('end;');
      declarations.add(stS+'pascal;');
    end
  else
  if Fmaj(mot1)='FUNCTION' then
    begin
      stS:='Function '+'fonction'+mot2+'_'+mot3;
      if st[1]='('
        then insert(';var pu:typeUO',st,pos(')',st))
        else insert('(var pu:typeUO);',st,pos(':',st));
      stS:=stS+st;

      stS:=StringReplace(StS,'real','float',[rfReplaceAll, rfIgnoreCase]);
      stS:=StringReplace(StS,'string','shortString',[rfReplaceAll, rfIgnoreCase]);

      memo2.lines.add(stS);
      memo2.lines.add('begin');
      memo2.lines.add('end;');
      declarations.add(stS+'pascal;');
    end
  else
  if Fmaj(mot1)='PROPERTY' then
    begin
      stS:='Function '+'fonction'+mot2+'_'+mot3;
      st1:=st;
      if st[1]='('
        then insert(';var pu:typeUO',st,pos(')',st))
        else insert('(var pu:typeUO)',st,pos(':',st));
      stS:=stS+st;

      stS:=StringReplace(StS,'real','float',[rfReplaceAll, rfIgnoreCase]);
      stS:=StringReplace(StS,'string','shortString',[rfReplaceAll, rfIgnoreCase]);

      memo2.lines.add(stS);
      memo2.lines.add('begin');
      memo2.lines.add('end;');
      memo2.lines.add('');
      declarations.add(stS+'pascal;');

      stTp:=copy(st1,pos(':',st1)+1,100);
      delete(stTp,length(stTp),1);
      delete(st1,pos(':',st1),100);


      stS:='Procedure '+'pro'+mot2+'_'+mot3;
      if (st1<>'') and (st1[1]='(')
        then insert(';w:'+stTp+';var pu:typeUO',st1,pos(')',st1))
        else st1:=st1+'(w:'+stTp+';var pu:typeUO)';
      stS:=stS+st1+';';

      stS:=StringReplace(StS,'real','float',[rfReplaceAll, rfIgnoreCase]);
      stS:=StringReplace(StS,'string','shortString',[rfReplaceAll, rfIgnoreCase]);

      memo2.lines.add(stS);
      memo2.lines.add('begin');
      memo2.lines.add('end;');
      declarations.add(stS+'pascal;');
    end;


  memo2.lines.add('');

end;

procedure Tform1.compiler;
var
  i:integer;
begin
  declarations.clear;
  memo2.clear;
  for i:=0 to memo1.lines.count-1 do CompilerLigne(memo1.lines[i]);

  for i:=0 to declarations.count-1 do memo2.lines.add(declarations[i]);
  memo2.selectAll;
  memo2.copyToClipBoard;
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
  memo1.clear;
  memo1.PasteFromClipboard;
end;

end.

initialization
{$IFDEF FPC}
{$I MCompFps.lrs}
{$ENDIF}

