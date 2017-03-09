unit WordList1;

interface

uses classes,sysUtils,strUtils,
  util1,listG,Hlist0,Gdos,ALfcnString;

type
  PTlist=^Tlist;

  TIndexrec=record
              Istring:integer;
              Ipage:integer;
              nbPage:integer;
            end;

  TWordList=class
              PageList,TitleList:TstringList;
              Hlist:ThashList2;
              hasLists:boolean;

              stComp:string;
              dataComp:array of TIndexrec;
              pageComp:array of integer;

              constructor create;
              destructor destroy;override;
              procedure newPage(Name,Title:string);
              procedure AddString(st:string);
              procedure processWord(st:string);

              procedure saveToStream(f:Tstream);
              procedure loadFromStream(f:Tstream);

              procedure saveToFile(stF:string);
              procedure LoadFromFile(stF:string);


              procedure removeHTMLtags(var st:string);
              procedure ProcessHTML(stdir, stF,stExt:string);

              procedure compressTable;
              function getIrec(id:integer):integer;
              procedure getLists(stWord:string;Words:TstringList;topics:Tlist);
              function getWordList:TstringList;
            end;

implementation



{ TWordList }

constructor TWordList.create;
begin
  PageList:=TstringList.create;
  TitleList:=TstringList.create;
  Hlist:=ThashList2.create;
end;

destructor TWordList.destroy;
var
  i:integer;
begin
  PageList.free;
  TitleList.free;

  if HasLists then
  with Hlist do
  for i:=0 to count-1 do
    PTlist(data[i])^.free;

  Hlist.free;
end;

procedure TWordList.newPage(Name, Title: string);
begin
  pageList.Add(name);
  titleList.add(title);
end;

procedure TWordList.AddString(st: string);
var
  i,i1:integer;
  flag:boolean;
begin
  i:=1;
  flag:=false;
  while i<=length(st) do
  begin
    if st[i] in [#0..#32, '.',',',';',':','?','!','*','/','|','{','}','=','(',')','<','>','"','+','-','''','[',']','²' ] then
    begin
      if flag then
      begin
        processWord(copy(st,i1,i-i1));
        flag:=false;
      end;
    end
    else
    begin
      if not flag then
      begin
        i1:=i;
        flag:=true;
      end;
    end;
    inc(i);
  end;

  if flag then processWord(copy(st,i1,i-i1));
end;

procedure TWordList.processWord(st: string);
var
  p:PTlist;
begin
  if st='' then messageCentral('st=''''');
  
  p:=Hlist.getFirstObj(st);
  if not assigned(p) then
  begin
    Hlist.addString(st,4);
    p:=Hlist.lastData;
    p^:=Tlist.Create;
  end;
  p^.Add(pointer(pageList.Count-1));
end;

procedure TWordList.loadFromStream(f: Tstream);
var
  w:integer;
  st:string;
begin
  f.Read(w,sizeof(w));
  setLength(st,w);
  f.Read(st[1],w);
  pageList.Text:=st;

  f.Read(w,sizeof(w));
  setLength(st,w);
  f.Read(st[1],w);
  TitleList.Text:=st;

  f.Read(w,sizeof(w));
  setLength(stComp,w);
  f.Read(stComp[1],w);

  f.Read(w,sizeof(w));
  setLength(dataComp,w div sizeof(TindexRec));
  f.Read(dataComp[0],w);

  f.Read(w,sizeof(w));
  setLength(pageComp,w div sizeof(integer));
  f.Read(pageComp[0],w);

end;

procedure TWordList.saveToStream(f: Tstream);
var
  w:integer;
begin
  w:=length(pageList.text);
  f.Write(w,sizeof(w));
  f.write(pageList.text[1],w);

  w:=length(titleList.text);
  f.Write(w,sizeof(w));
  f.write(titleList.text[1],w);

  w:=length(stComp);
  f.Write(w,sizeof(w));
  f.write(stComp[1],w);

  w:=length(dataComp)*sizeof(TindexRec);
  f.Write(w,sizeof(w));
  f.write(dataComp[0],w);

  w:=length(pageComp)*sizeof(integer);
  f.Write(w,sizeof(w));
  f.write(pageComp[0],w);
end;

procedure TWordList.ProcessHTML(stDir,stF,stExt: string);
var
  f:TextFile;
  st,st1:string;
  k1,k2:integer;
begin
  try
  assignFile(f,stDir+stF+stExt);
  Reset(f);

  while not eof(f)  do
  begin
    readLn(f,st);

    k1:=pos('<title>',st);
    if k1>0 then
    begin
      k2:=pos('</title>',st);
      st1:=copy(st,k1+7,k2-k1-7);
      NewPage(stF,st1);
    end;

    removeHTMLtags(st);

    AddString(st);
  end;

  closeFile(f);
  except
  {$I-}closeFile(f);{$I+}
  end;

  HasLists:=true;

end;

procedure TWordList.removeHTMLtags(var st: string);
var
  i,k1,k2:integer;
begin
  k1:=pos('<',st);
  while k1>0 do
  begin
    k2:=pos('>',st);
    delete(st,k1,k2-k1+1);
    insert(' ',st,k1);
    k1:=pos('<',st);
  end;

  k1:=pos('&lt;',st);
  while k1>0 do
  begin
    delete(st,k1,4);
    insert('<',st,k1);
    k1:=pos('&lt;',st);
  end;

  k1:=pos('&gt;',st);
  while k1>0 do
  begin
    delete(st,k1,4);
    insert('>',st,k1);
    k1:=pos('&gt;',st);
  end;

  k1:=pos('&amp;',st);
  while k1>0 do
  begin
    delete(st,k1,5);
    insert('&',st,k1);
    k1:=pos('&amp;',st);
  end;

  k1:=pos('&quot;',st);
  while k1>0 do
  begin
    delete(st,k1,6);
    insert('"',st,k1);
    k1:=pos('&quot;',st);
  end;



end;

procedure TWordList.LoadFromFile(stF: string);
var
  f:TfileStream;
begin
  try
  f:=TfileStream.Create(stF,fmOpenRead) ;
  loadFromStream(f);
  finally
  f.free;
  end;
end;

procedure TWordList.saveToFile(stF: string);
var
  f:TfileStream;
begin
  try
  compressTable;
  f:=TfileStream.Create(stF,fmCreate) ;
  SaveToStream(f);
  finally
  f.free;
  end;
end;


procedure TWordList.compressTable;
var
  i,n:integer;
  IDstring,IDpage:integer;
  list:Tlist;
begin
  with Hlist do
  for i:=0 to count-1 do
  begin
    list:=PTlist(data[i])^;
    n:=list.count;

    IDstring:=length(stComp);
    IDpage:=length(pageComp);

    setLength(dataComp,length(dataComp)+1);

    dataComp[high(dataComp)].Istring:=IDstring;
    dataComp[high(dataComp)].Ipage:=IDpage;
    dataComp[high(dataComp)].nbpage:=n;

    stComp:=stComp+strings[i]+#0;

    setLength(pageComp,length(pageComp)+n);
    move(list.list^, pageComp[IDpage],n*4);
  end;


end;

procedure TWordList.getLists(stWord:string;Words:TstringList;topics:Tlist);
var
  i,id,Irec:integer;
  k1,k2:integer;
  stW:string;
begin
  id:=AlposExIgnoreCase(stWord,stComp,1);

  while id>0 do
  begin
    Irec:=getIrec(id);
    with dataComp[Irec] do
    begin
      for i:=0 to nbPage-1 do
        if topics.Indexof(pointer(pageComp[Ipage+i]))<0
          then topics.add(pointer(pageComp[Ipage+i]));
    end;

    k1:=id;
    k2:=id;
    while (k1>0) and (stComp[k1-1]<>#0) do dec(k1);
    while (k2<length(stComp)) and (stComp[k2+1]<>#0) do inc(k2);

    stW:=copy(stComp,k1,k2-k1+1);
    if words.IndexOf(stW)<0 then words.Add(stW);

    id:=AlposExIgnoreCase(stWord,stComp,id+1);
  end;
end;

function TWordList.getIrec(id: integer): integer;
var
  min,max:integer;
  d:longword;
begin
  min:=0;
  max:=high(dataComp);

  if id>=dataComp[max].Istring  then
    begin
      result:=max;
      exit;
    end;

  repeat
    result:=(max+min) div 2;
    d:= dataComp[result].Istring;
    if d<id then min:=result
    else
    if d>id then max:=result;
  until (max-min<=1) or (id=d);

  if id<>d then result:=min;
end;

function TWordList.getWordList: TstringList;
var
  i:integer;
  st:string;
  a:char;
begin
  result:=TstringList.Create;
  for i:=1 to length(stComp) do
  begin
    a:=stComp[i];
    if a=#0 then
    begin
      if st<>'' then result.add(st)
                else messageCentral('st=''''');
      st:='';
    end
    else st:=st+stComp[i];
  end;
  if st<>'' then result.add(st);
end;

end.
