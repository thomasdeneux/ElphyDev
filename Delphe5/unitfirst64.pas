unit UnitFirst64;

{$mode delphi}{$H+}

interface

uses
  messages, forms, buttons,  StdCtrls, ComCtrls, Dialogs, LResources,
  util1, Gdos,Dgraphic,editcont;



type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    editNum1: TeditNum;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    tab:array of double;
    xxx:integer;
    mess: Tmessage;

  end;




var
  Form1: TForm1; 

implementation

{ TForm1 }

type
  Trecord1=record
             x,y:integer;
           end;

  Trecord2=record
             x1,x2,y1,y2:smallint;
           end;

var
  x:Trecord1;


procedure test;
begin
  messageCentral('Hello');
end;

var
  pp:procedure;

type
  Tprocedure1 = procedure(p1:intG);

procedure call1(pp:pointer; p1:intG);
begin
  Tprocedure1(pp)(p1);
end;

var
  varG:integer;

procedure call2(w1,w2:integer);assembler;
var
  nb1, nb2:integer;
asm
  mov nb1, w1
  mov nb2, w2

  lea  rbx, varG
  mov  [rbx], w1
end;



procedure proc0;
begin
  messageCentral('Hello');
end;

procedure proc1(n:integer);
begin
  messageCentral('n='+Istr(n));
end;

procedure proc2(n1,n2:integer);
begin
  messageCentral('n1='+Istr(n1)+'      n2='+Istr(n2));
end;

procedure proc3(n1,n2,n3:integer);
begin
  messageCentral('n1='+Istr(n1)+'      n2='+Istr(n2)+'       n3='+Istr(n3));
end;

procedure proc4(n1,n2,n3,n4:integer);
begin
  messageCentral('n1='+Istr(n1)+'      n2='+Istr(n2)+'       n3='+Istr(n3)+'    n4='+Istr(n4));
end;

procedure proc5(n1,n2,n3,n4,n5:integer);
begin
  messageCentral('n1='+Istr(n1)+'      n2='+Istr(n2)+'       n3='+Istr(n3)+'    n4='+Istr(n4)+'   n5='+Istr(n5));
end;


procedure proc6(n1,n2,n3,n4,n5,n6:integer);
begin
  messageCentral('n1='+Istr(n1)+'      n2='+Istr(n2)+'       n3='+Istr(n3)+
             '    n4='+Istr(n4)+'      n5='+Istr(n5)+'       n6='+Istr(n6));
end;



procedure procD1(w:double);
begin
  messageCentral('w= '+Estr(w,3));
end;

procedure procD2(w1,w2:double);
begin
  messageCentral('w1= '+Estr(w1,3)+'   w2= '+Estr(w2,3));
end;


procedure procD3(w1,w2,w3:double);
begin
  messageCentral('w1='+Estr(w1,3)+'      w2='+Estr(w2,3)+'       w3='+Estr(w3,3));
end;

procedure procD4(w1,w2,w3,w4:double);
begin
  messageCentral('w1='+Estr(w1,3)+'      w2='+Estr(w2,3)+'       w3='+Estr(w3,3)+'    w4='+Estr(w4,3));
end;

procedure procD5(w1,w2,w3,w4,w5:double);
begin
  messageCentral('w1='+Estr(w1,3)+'      w2='+Estr(w2,3)+'       w3='+Estr(w3,3)+'    w4='+Estr(w4,3)+'   w5='+Estr(w5,3));
end;


procedure procD6(w1,w2,w3,w4,w5,w6:double);
begin
  messageCentral('w1='+Estr(w1,3)+'      w2='+Estr(w2,3)+'       w3='+Estr(w3,3)+
             '    w4='+Estr(w4,3)+'      w5='+Estr(w5,3)+'       w6='+Estr(w6,3));
end;

procedure procD7(w1,w2,w3,w4,w5,w6,w7:double);
begin
  messageCentral('w1='+Estr(w1,3)+'      w2='+Estr(w2,3)+'       w3='+Estr(w3,3)+
             '    w4='+Estr(w4,3)+'      w5='+Estr(w5,3)+'       w6='+Estr(w6,3)+
             '    w7='+Estr(w7,3)
             );
end;


procedure procD8(w1,w2,w3,w4,w5,w6,w7,w8:double);
begin
  messageCentral('w1='+Estr(w1,3)+'      w2='+Estr(w2,3)+'       w3='+Estr(w3,3)+
             '    w4='+Estr(w4,3)+'      w5='+Estr(w5,3)+'       w6='+Estr(w6,3)+
             '    w7='+Estr(w7,3)+'      w8='+Estr(w8,3)
             );
end;


function foncD(w1,w2,w3,w4,w5,w6:double): double;
begin
  result:=w1+w2+w3+w4+w5+w6;
end;





type
  Tparam1=record
            IsReal: int64;
          case integer of
            1:(i:int64);
            2:(d:double);
          end;

  Tparam64 = array[1..100] of Tparam1;
  Pparam64=  ^Tparam64;

function CallAsm(ad:pointer;nb:int64;var param:Tparam64): pointer;assembler;
var
  ad1:pointer;
  nb1:int64;
  param0, param1:pointer;
  stackInc: int64;
  cnt1: int64;
asm
{$IFDEF WIN64}
       mov ad1,  ad       // ad
       mov nb1, nb        // nb
       mov param1,param   // param
       mov param0,param   // param

       mov  rax, nb1
       add  rax, 1        // un mot de plus (?)
       test eax, 1        // si impair, ajouter 1
       jz   @@0
       inc  rax
  @@0: shl  rax,3         // multiplier par 8

       mov  StackInc, rax

       sub  rsp, StackInc // On retranche un multiple de 16
                          // La pile est dÃ©jÃ  alignÃ©e aprÃ¨s le prologue
       cmp  nb1,0
       jz   @@1

       mov rbx,param1
       cmp [rbx],0       // Test type de Param1
       jnz  @@p1a
       add param1,8
       mov rbx, param1
       mov rcx, [rbx]     // param1 dans rcx
       jmp @@p1b
  @@p1a:
       add param1,8
       mov rbx, param1
       movd xmm0, [rbx]   // param1 dans xmm0
  @@p1b:

       dec  nb1
       add  param1,8

       cmp  nb1,0
       jz   @@1

       mov rbx,param1
       cmp [rbx],0        // Test type de Param2
       jnz  @@p2a
       add param1,8
       mov rbx, param1
       mov rdx, [rbx]     // param2 dans rdx
       jmp  @@p2b
  @@p2a:
       add param1,8
       mov rbx, param1
       movd xmm1, [rbx]   // param2 dans xmm1
  @@p2b:

       dec  nb1
       add  param1,8

       cmp  nb1,0
       jz   @@1

       mov rbx,param1
       cmp [rbx],0        // Test type de Param3
       jnz  @@p3a
       add param1,8
       mov rbx, param1
       mov r8, [rbx]      // param3 dans r8
       jmp  @@p3b
  @@p3a:
       add param1,8
       mov rbx, param1
       movd xmm2, [rbx]   // param3 dans xmm2
  @@p3b:

       dec  nb1
       add  param1,8

       cmp  nb1,0
       jz   @@1

       mov rbx,param1
       cmp [rbx],0        // Test type de Param4
       jnz  @@p4a
       add param1,8
       mov rbx, param1
       mov r9, [rbx]      // param4 dans r9
       jmp  @@p4b
  @@p4a:
       add param1,8
       mov rbx, param1
       movd xmm3, [rbx]   // param4 dans xmm3
  @@p4b:

       dec  nb1
       add  param1,16     // 16 pour sauter le type de param

       mov  cnt1,20h      // les autres params sont dans la pile

  @@2: cmp  nb1,0
       jz   @@1

       mov  rbx,param1
       mov  rax,[rbx]
       mov  rbx,cnt1

       mov  rsp[rbx], eax        // mov rsp[rbx],rax ne marche pas !!!!
       shr  rax,32
       mov  rsp[rbx+4], eax

       dec  nb1
       add  cnt1, 8
       add  param1,16
       jmp  @@2

  @@1:
       call ad1
       mov  rbx, stackInc       // remettre la pile dans le bon état
       add  rsp, rbx

       mov  rbx,param0
       movsd [rbx+8], xmm0
{$ENDIF}
end;


function ProcSin(w:double):double;
begin
  result:=w*w;
end;

procedure  ProcSt(st:AnsiString);
begin
  messageCentral(st);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  pp:Tparam64;
  i:integer;
  st:AnsiString;
  w:double;
begin

  fillchar(pp,sizeof(pp),0);
  (*
  pp[1].IsReal:= 1;
  pp[1].d:= pi/6;
  pp[2].IsReal:= 0;

  w:=(pi+32)/78;
  CallAsm(@ProcSin,1,pp);
  w:=pp[1].d;
  messageCentral(Estr(w,3));
  *)

  st:='Hello';
  pp[1].IsReal:= 1;
  pp[1].i:= intG(st);
  pp[2].IsReal:= 0;

  w:=(pi+32)/78;
  CallAsm(@ProcSt,1,pp);

end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  xxx:=517;

  with editnum1 do
  begin
    setvar(xxx,G_longint);
  end;
end;

initialization
  {$I unitfirst64.lrs}

end.

