unit DNkernel1;

interface

uses  windows,classes,
      util1,Cuda1,ipps, chrono0;

type
  TpstwArray = array of PtabSingle; // chaque pointeur pointe sur un pstw

  TthreadedMulti=
             class
               Ncycle,Ncode,Npstw:integer;  // paramètres communs
               Vt,Vcode:PtabLong;
               Vcount1, Vcount2: PtabLong;

               Vsource: array of PtabSingle;
               Pstw: array of TpstwArray;

               constructor create(NcycleA, NcodeA, NpstwA:integer; VtA,VcodeA,Vc1,Vc2:pointer);
               procedure AddPstw(Vs:PtabSingle;Pstw1: TpstwArray);
               procedure Calculate;
             end;


procedure TestCalculatePstw;

implementation


type


  TthreadK = class(Tthread)
               Ncycle,Ncode,Npstw:integer;
               Ipstw1,Ipstw2:integer;

               Vsource: PtabSingle;
               Pstw: TpstwArray;
               Vt,Vcode:PtabLong;
               Vcount1,Vcount2:PtabLong;

               constructor create(NcycleA,NcodeA,NpstwA,Ipstw1A,Ipstw2A:integer;
                                  sourceA,VtA,VcodeA:pointer;pstwA: TpstwArray;
                                  Vc1,Vc2: PtabLong);
               procedure execute;override;
             end;




constructor TthreadK.create(NcycleA, NcodeA, NpstwA, Ipstw1A, Ipstw2A:integer;
                            sourceA,VtA,VcodeA:pointer;pstwA: TpstwArray;
                            Vc1,Vc2: PtabLong);
begin
  Ncycle:= NcycleA;
  Ncode:= NcodeA;
  Npstw:= NpstwA;
  Ipstw1:= Ipstw1A;
  Ipstw2:= Ipstw2A;

  Vsource:=sourceA;
  pstw:= pstwA;
  Vt:= VtA;
  Vcode:= VcodeA;

  Vcount1:=Vc1;
  Vcount2:=Vc2;

  inherited create(false);
end;


procedure ippGAdd_32f_I( p1,p2:Psingle; N:integer);
var
  pfin: Psingle;
  i:integer;
begin
  pfin:=pointer(intG(p1)+N*sizeof(single));
  repeat
    p2^:=p1^+p2^;
    inc(intG(p1),4);
    inc(intG(p2),4);
  until p1=pfin;
end;


procedure TthreadK.execute;
var
  i:integer;
  t,z,code:integer;
  p: Psingle;
begin
  for i:=0 to Ncode*3-1 do
    ippsMulC_32f_I(Vcount1[i],@pstw[i][Ipstw1],Ipstw2-Ipstw1+1);


  for i:= 0 to Ncycle-1 do
  begin
    t := Vt^[i];
    for code := 0 to Ncode-1 do
    begin
      z := Vcode^[i*Ncode+code];
      p:=@Pstw[z][Ipstw1];
      //ippGAdd_32f_I(Psingle(@Vsource[t]),p,Npstw);
      ippsAdd_32f_I(Psingle(@Vsource[t]),p,Ipstw2-Ipstw1+1);
    end;
  end;

  for i:=0 to Ncode*3-1 do
    if Vcount2[i]>0 then ippsMulC_32f_I(1/Vcount2[i],@pstw[i][Ipstw1],Ipstw2-Ipstw1+1);

  terminate;
end;


procedure PartialPstw(Ncycle, Ncode, Npstw, Ipstw1, Ipstw2:integer; Vsource,pstw:PtabSingle;Vt,Vcode:PtabLong);
var
  i:integer;
  t,z,code:integer;
  p: Psingle;
begin
  for i:= 0 to Ncycle-1 do
  begin
    t := Vt^[i];
    for code := 0 to Ncode-1 do
    begin
      z := Vcode^[i*Ncode+code];
      p:=@Pstw[ z*Npstw +Ipstw1];
      //ippGAdd_32f_I(Psingle(@Vsource[t]),p,Npstw);
      ippsAdd_32f_I(Psingle(@Vsource[t]),p,Ipstw2-Ipstw1+1);
    end;
  end;
end;


procedure NotThreadedPstw(NcycleA,NcodeA,NpstwA:integer; sourceA,pstwA,VtA,VcodeA:pointer);
const
  Nmax=16;
var
  i:integer;
  i1,i2:integer;
begin
  for i:=1 to Nmax do
  begin
    i1:=NpstwA div Nmax*(i-1);
    i2:=NpstwA div Nmax *i-1;
    if i2>=NpstwA then i2:=NpstwA-1;

    PartialPstw(NcycleA,NcodeA,NpstwA,I1,I2, sourceA,pstwA,VtA,VcodeA);
  end;

end;



procedure ThreadedPstw(NcycleA,NcodeA,NpstwA:integer; sourceA,VtA,VcodeA:pointer;pstwA:TpstwArray;Vcount1,Vcount2:PtabLong);
const
  Nmax=16;
var
  threadK: array[1..Nmax] of TthreadK;
  i:integer;
  i1,i2:integer;
  ok:boolean;
begin
  for i:=1 to Nmax do
  begin
    i1:=NpstwA div Nmax*(i-1);
    i2:=NpstwA div Nmax *i-1;
    if i2>=NpstwA then i2:=NpstwA-1;

    ThreadK[i]:= TthreadK.create(NcycleA,NcodeA,NpstwA,I1,I2, sourceA,VtA,VcodeA,PstwA,Vcount1,Vcount2);
  end;

  repeat
    ok:= true;
    for i:=1 to Nmax do
    if not ThreadK[i].Terminated then ok:=false;
    if not ok then sleep(10);
  until ok;

  for i:=1 to Nmax do ThreadK[i].Free;
end;


procedure TestCalculatePstw1(mode:integer);
var
  mm:integer;
  Nx,Ny:integer;
  Vsource: array of Single;
  Vt: array of integer;
  Vcode:array of integer;
  Vcount1,Vcount2: array of integer;

  PstwX:array of single;
  Pstw: TpstwArray;

  Npoint:integer;    // Number of samples in source
  Ncode: integer;    // Number of codes in one frame = Nx*Ny
  Ncycle:integer;    // Number of frames = number of topSyncs
  Npstw: integer;    // Number of samples in one pstw


  i,i1,x,y,k:integer;
  res:integer;

  idx,code,z,t:integer;
  p: Psingle;

begin

  Nx:=15;
  Ny:=15;


  Ncode:= 225;
  Ncycle:=2250;
  Npstw:= 10000;
  Npoint:=62000+Npstw;


  setLength(Vsource,Npoint);
  for i:=0 to high(Vsource) do Vsource[i]:= i;


  setlength(Vt,Ncycle);            //  tops synchro
  for i:=0 to Ncycle-1 do Vt[i]:=1000+25*i;
  setlength(Vcode, Ncode*Ncycle);
  for i:=0 to high(Vcode) do Vcode[i]:= i mod (3*Nx*Ny);   //  codes = z +  x* Nstate + y*Nstate*Nx

  setLength(PstwX,Npstw*Ncode*3);      //
  fillchar(PstwX[0],length(pstwX)*4,0);
  setLength(Pstw,Ncode*3);
  for i:=0 to Ncode*3-1 do Pstw[i]:=@PstwX[Npstw*i];

  setLength(Vcount1,Ncode*3);
  fillchar(Vcount1[0],length(Vcount1)*4,0);

  setLength(Vcount2,Ncode*3);
  for i:=0 to high(Vcount2) do Vcount2[i]:=100;


  initChrono;

  case mode of
    1: begin
         if not InitCudaLib2 then exit;
         res:= DNpstw(@Vsource[0], Npoint, @Vt[0], Ncode, @Vcode[0], Ncycle, @PstwX[0], Npstw);
         if res<>0 then messageCentral('CUDA DNpstw='+Istr(res));
       end;

    2: begin
         for idx:=0 to Npstw-1 do
         begin
           for i:= 0 to Ncycle-1 do
           begin
             t := Vt[i];
             for code := 0 to Ncode-1 do
             begin
               z := Vcode[i*Ncode+code];
               p:=@PstwX[ z*Npstw + idx];
               p^:=p^+ Vsource[ t+idx];
             end;
           end;
         end;
       end;

    3: for mm:=1 to 10 do
       begin
         IPPStest;
         for i:= 0 to Ncycle-1 do
         begin
           t := Vt[i];
           for code := 0 to Ncode-1 do
           begin
             z := Vcode[i*Ncode+code];
             p:=@PstwX[ z*Npstw ];
             ippsAdd_32f_I(Psingle(@Vsource[t]),p,Npstw);
           end;
         end;
         IPPSEnd;
       end;

    4: for mm:=1 to 10 do
       begin
         IPPStest;
         ThreadedPstw(Ncycle,Ncode,Npstw, @Vsource[0],@Vt[0], @Vcode[0],pstw,@Vcount1[0],@Vcount2[0]);
         IPPSEnd;
       end;

    5: for mm:=1 to 1000000 do
       begin
         IPPStest;
         ippsAdd_32f_I(Psingle(@Vsource[0]),Psingle(@Vsource[0]),Npoint);
         //move(Vsource[0],Vsource[1],(Npoint-1)*4);
         IPPSEnd;
       end;

  end;
  messageCentral(chrono);


end;

procedure TestCalculatePstw;
begin
  //TestCalculatePstw1(3);
  TestCalculatePstw1(4);
end;






{ TthreadedMulti }

procedure TthreadedMulti.AddPstw(Vs:PtabSingle;Pstw1: TpstwArray);
begin
  setLength(Vsource,length(Vsource)+1);
  Vsource[high(Vsource)]:= Vs;

  setLength(Pstw,length(Pstw)+1);
  Pstw[high(Pstw)]:= Pstw1;

end;

procedure TthreadedMulti.Calculate;
var
  threadK: array of TthreadK;
  i:integer;
  ok:boolean;
begin
  setlength(threadK,length(Vsource));

  for i:=0 to high(ThreadK) do
    ThreadK[i]:= TthreadK.create(Ncycle,Ncode,Npstw,0,Npstw-1, Vsource[i], Vt, Vcode, Pstw[i],Vcount1,Vcount2);

  repeat
    ok:= true;
    for i:=0 to high(ThreadK) do
    if not ThreadK[i].Terminated then ok:=false;
    if not ok then sleep(10);
  until ok;

  for i:=0 to high(ThreadK) do ThreadK[i].Free;
end;


constructor TthreadedMulti.create(NcycleA, NcodeA, NpstwA: integer; VtA, VcodeA,Vc1,Vc2: pointer);
begin
  Ncycle:= NcycleA;
  Ncode:=  NcodeA;
  Npstw:=  NpstwA;

  Vt:= VtA;
  Vcode:= VcodeA;

  Vcount1:=Vc1;
  Vcount2:=Vc2;
end;

end.
