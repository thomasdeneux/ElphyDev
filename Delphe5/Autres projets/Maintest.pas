unit mainTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,StdCtrls,

  util1,CyberK2, ExtCtrls,testDllC;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Timer1: TTimer;
    Panel1: TPanel;
    Bstart: TButton;
    Bstop: TButton;
    Button1: TButton;
    procedure BstartClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BstopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    IsON: boolean;
    pcnt0,pcnt:integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.BstartClick(Sender: TObject);
var
  result:integer;
begin
  //InitDLL;

  IsON:=InitCyberKdll;
  if not IsON then exit;

  result:=CBopen;
  IsON:=(result=0);
  if not IsON then exit;
  pcnt:=0;
  result:=cbMakePacketReadingBeginNow;
  IsON:=(result=0);
  if not IsON then exit;


end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  p:PcbPKT_GROUP;
  pb:PtabOctet;
  i:integer;
  st:string;
  pp:PtabOctet;

begin
  if not IsON then exit;

  repeat
    p:=PcbPKT_GROUP(cbGetNextPacketPtr);

    if assigned(p) and (p^.chid=151) { and ((p^.chid>=1) and (p^.chid<1000)) }{  and (p^.type1>=1) and (p^.type1<=10)) and (p^.type1<>255) }
    then
      with p^ do
      begin
        memo1.Lines.Add(Istr1(pcnt0,4)+':'+ Istr1(time,10)+' '+Istr1(chid,10)+' '+Istr1(dlen,10)+ ' '+Istr1(data[0],10));
        pB:=@p^.data;
        pp:=Ppointer(pB)^;

       { st:=Istr1(pcnt0,4)+':';
        for i:=0 to 31 do st:=st+Istr1(pB^[i],4);
        memo1.Lines.Add(st); }
      end;

    inc(pcnt) ;
    inc(pcnt0);
  until (p=nil) or (pcnt>100000);
  if pcnt>100000 then IsOn:=false;
  memo1.Invalidate;
end;

procedure TForm1.BstopClick(Sender: TObject);
begin
  if IsON then cbClose;
  IsON:=false;
end;

var
  cfgBuffer:PcbCFGBUFF;

procedure TForm1.FormCreate(Sender: TObject);
var
  freq,count,chancaps:longword;
  i,j,res:integer;
  name:array[0..1000] of char;
  userflags:longword;
  position:integer;
  st:string;
  procInfo: cbPROCINFO;
  bankInfo: cbBANKINFO;
  bank:integer;

  dinpcaps:longword;

  info: ^cbPKT_CHANINFO;

  label1:array[0..31] of char;
  length1:integer;
  period1:integer;
  list1:array[0..99] of integer;

  filter1,group1:longword;

begin
  InitCyberKdll;
  res:=CBopen;


  cfgBuffer:=cbGetCfgBuffer;

  with cfgBuffer^.chanInfo[0] do
  memo1.Lines.Add('ChanInfo[0]   DinpOpts='+longToHexa(DinpOpts) );

  with cfgBuffer^.chanInfo[150] do
  memo1.Lines.Add('ChanInfo[150]   DinpOpts='+longToHexa(DinpOpts) );

  res:=cbGetSystemClockFreq(@freq);
  memo1.Lines.Add('Freq='+Istr(freq)+'     res='+Istr(res));

  res:=cbGetChanCount( @count);
  memo1.Lines.Add('ChanCount='+Istr(count)+'     res='+Istr(res));

  for i:=1 to Count do
  begin
    fillchar(name,sizeof(name),0);
    res:= cbGetChanLabel( i, @name, @userflags, @position);
    res:=  cbGetChanCaps( i,  @chancaps );
    {st:=Pchar(@name);}
    if res=0 then
      memo1.Lines.Add('Res='+Istr(res)+'  Chan '+Istr1(i,3)+': '+Istr(chancaps));
  end;

  res:= cbGetProcInfo( 1, @procinfo );

  memo1.Lines.Add('Res='+Istr(res)+'  ChanCount '+Istr1(procInfo.chancount,3)+'  BankCount '+Istr1(procInfo.bankcount,3)+'  groupcount '+Istr1(procInfo.groupcount,3) );

  for bank:=1 to procInfo.bankcount do
  begin
    res:= cbGetBankInfo( 1, bank, @bankinfo );
    memo1.Lines.Add('Res='+Istr(res)+' '+Istr(bank)+':  ChanCount '+Istr(bankinfo.chanCount)+'  ChanBase '+Istr(bankinfo.chanBase) );
    memo1.Lines.Add(PcharToString(@bankInfo.ident,cbLEN_STR_IDENT) );
    memo1.Lines.Add(PcharToString(@bankInfo.label1,cbLEN_STR_LABEL) );

  end;
  
  memo1.Lines.Add('');

  for i:=1 to 156 do
  begin
    dinpcaps:=0;
    res:= cbGetDinpCaps( i, @dinpcaps );
    memo1.Lines.Add(Istr(i)+': Res='+Istr(res)+' DinpCaps='+longToHexa(DinpCaps) );
  end;

  memo1.Lines.Add('');

  for i:=1 to 156 do
  begin
    dinpcaps:=0;
    res:= cbGetDoutCaps( i, @dinpcaps );
    memo1.Lines.Add(Istr(i)+': Res='+Istr(res)+' DoutCaps='+longToHexa(DinpCaps) );
  end;
  for i:=153 to 156 do
  begin
    res:= cbSetDoutOptions( i, cbDOUT_MONITOR_UNIT_ALL or cbDOUT_VALUE , 0,0 );
    memo1.Lines.Add(' cbSetDoutpOptions = '+Istr(res));
  end;
  memo1.Lines.Add('');

  res:= cbSetDinpOptions( 151, cbDINP_16BIT + cbDINP_ANYBIT, 0 );
  memo1.Lines.Add('SetDinpOptions: Res='+Istr(res) );


  (*
  for i:=2 to 8 do
  begin
    res:= cbGetSampleGroupInfo(  1, i, @label1,  @period1,  @length1);

    memo1.Lines.Add(Istr(i)+': '+Pchar(@label1) +Istr1(period1,8)+Istr1(length1,8) );

    res:=cbGetSampleGroupList( 1, i, @length1, @list1 );
    if res=0 then
    begin
      st:='';
      for j:=0 to length1-1 do st:= st +Istr(list1[j])+' ';
    end;
    memo1.Lines.Add('list='+st);

  end;

  memo1.Lines.Add('');
  memo1.Lines.Add('cbGetAinpSampling');

  for i:=1 to 5 do
  begin
    res:=cbGetAinpSampling( i, @filter1, @group1);
    memo1.Lines.Add(Istr(i)+': '+Istr1(filter1,8)+Istr1(group1,8) );
  end;

  for i:=129 to 135 do
  begin
    res:=cbGetAinpSampling( i, @filter1, @group1);
    memo1.Lines.Add(Istr(i)+': '+Istr1(filter1,8)+Istr1(group1,8) );
  end;
  *)
  res:=cbClose;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  memo1.Clear;
  memo1.Invalidate;
end;

end.



   0: 521977560          0          2
   1: 521977560          0          3
   2: 521977560          0          4
   3: 521977563          0          4
   5: 521977566          0          4
   6: 521977569          0          4
   7: 521977572          0          4
   8: 521977575          0          3
   9: 521977575          0          4
  10: 521977578          0          4
  11: 521977581          0          4
  12: 521977584          0          4
  13: 521977587          0          4

  14: 521977590          0          2
  15: 521977590          0          3
  16: 521977590          0          4
  17: 521977593          0          4
  18: 521977596          0          4
  19: 521977599          0          4
  20: 521977602          0          4
  21: 521977605          0          3
  22: 521977605          0          4
  23: 521977608          0          4
  25: 521977611          0          4
  26: 521977614          0          4
  27: 521977617          0          4

  28: 521977620          0          2
  29: 521977620          0          3
  30: 521977620          0          4
  31: 521977623          0          4
  32: 521977626          0          4
  33: 521977629          0          4
  34: 521977632          0          4
  35: 521977635          0          3
  36: 521977635          0          4
  37: 521977638          0          4
  38: 521977641          0          4
  39: 521977644          0          4
  40: 521977647          0          4

  41: 521977650          0          2
  42: 521977650          0          3
  43: 521977650          0          4
  45: 521977653          0          4
  46: 521977656          0          4
  47: 521977659          0          4
  48: 521977662          0          4
  49: 521977665          0          3
  50: 521977665          0          4
  51: 521977668          0          4
  52: 521977671          0          4
  53: 521977674          0          4
  55: 521977677          0          4

  56: 521977680          0          2
  57: 521977680          0          3
  58: 521977680          0          4
  59: 521977683          0          4
  60: 521977686          0          4
  61: 521977689          0          4
  62: 521977692          0          4
  63: 521977695          0          3
  64: 521977695          0          4
  65: 521977698          0          4
  66: 521977701          0          4
  67: 521977704          0          4
  68: 521977707          0          4
  69: 521977710          0          2
  70: 521977710          0          3
  71: 521977710          0          4
  72: 521977713          0          4
  73: 521977716          0          4
  74: 521977719          0          4
  76: 521977722          0          4
  77: 521977725          0          3
  78: 521977725          0          4
  79: 521977728          0          4
  80: 521977731          0          4
  81: 521977734          0          4
  82: 521977737          0          4
  83: 521977740          0          2
  84: 521977740          0          3
  85: 521977740          0          4
  86: 521977743          0          4
  87: 521977746          0          4
  88: 521977749          0          4
  89: 521977752          0          4
  90: 521977755          0          3
  91: 521977755          0          4
  92: 521977758          0          4
  93: 521977761          0          4
  94: 521977764          0          4
