unit strt_new;
   {
   Function sinh(x:real):real;
   Function cosh(x:real):real;
   Function tanh(x:real):real;
   procedure proInvMat(var W,Winv: Tmat);
   }
   
interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
uses util1,SysUtils,Dialogs,stmKLmat,stmVec1,stmMat1,MathKernel0,stmDef;

  function FonctionSinh(x: float):float;pascal;
  function FonctionCosh(x: float):float;pascal;
  function FonctionTanh(x: float):float;pascal;
  procedure proInvMat(var W,Winv: Tmat);pascal;


implementation
  function FonctionSinh(x: float):float;
    begin
      result:=(exp(x)-exp(-x))/2;
    end;

  function FonctionCosh(x: float):float;
    begin
      result:=(exp(x)+exp(-x))/2;
    end;

  function FonctionTanh(x: float):float;
    begin
        result:=(exp(x)-exp(-x))/(exp(x)+exp(-x));
    end;


  procedure proInvMat(var W,Winv: Tmat);
    var
      info : integer;
      Wtemp : Tmat;
      W_piv : Tvector;
      work:pointer;
      lwork:integer;
    begin
      Wtemp := Tmat.create(G_single,W.Istart,W.Iend);
      Wtemp.copy(W);
      W_piv := Tvector.create(G_single,W.Istart,W.Iend);

      try
        sgetrf(Wtemp.Iend, Wtemp.Jend, Wtemp.tb, W.RowCount, W_piv.tb, info);

        if (info <> 0) then ShowMessage ('Matrix can''t be factorized')
          else
            begin
              lWork:=64*W.Iend;
              getmem(work,lwork*tailleTypeG[W.tpNum]);
              sgetri(W.Iend, Wtemp.tb , W.RowCount, W_piv.tb, work, lwork, info);
              if info <0 then ShowMessage (IntToStr(info)+'th param has an illegal value');
              if info >0 then ShowMessage (IntToStr(info)+'th diagonal element of the factor U is zero, U is singular, and inversion could not be completed.');
            end;

        Winv.copy(Wtemp);
        finally
        freemem(work);

        Wtemp.free;
        W_piv.free;
      end;  {try}
    end;

end.


