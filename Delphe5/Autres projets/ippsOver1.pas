unit ippsOver1;

interface

uses util1,ippdefs,ipps;


(* /////////////////////////////////////////////////////////////////////////////
//                  Arithmetic functions;
///////////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////////////////////////////
//  Names:       ippsAdd, ippsSub, ippsMul
//
//  Purpose:    add, subtract and multiply operations upon every element of
//              the source vector
//  Arguments:
//    pSrc                 pointer to the source vector
//    pSrcDst              pointer to the source/destination vector
//    pSrc1                pointer to the first source vector
//    pSrc2                pointer to the second source vector
//    pDst                 pointer to the destination vector
//    len                  length of the vectors
//    scaleFactor          scale factor value
//  Return:
//    ippStsNullPtrErr     pointer(s) to the data is NULL
//    ippStsSizeErr        length of the vectors is less or equal zero
//    ippStsNoErr          otherwise
//  Note:
//    AddC(X,v,Y)    :  Y[n] = X[n] + v
//    MulC(X,v,Y)    :  Y[n] = X[n] * v
//    SubC(X,v,Y)    :  Y[n] = X[n] - v
//    SubCRev(X,v,Y) :  Y[n] = v - X[n]
//    Sub(X,Y)       :  Y[n] = Y[n] - X[n]
//    Sub(X,Y,Z)     :  Z[n] = Y[n] - X[n]
*)

  function ippsAddC(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
  function ippsSubC(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
  function ippsMulC(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
  function ippsAddC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsAddC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsSubC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsSubC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsSubCRev(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsSubCRev(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsMulC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsMulC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsAddC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsAddC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;
  function ippsSubC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsSubC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;
  function ippsSubCRev(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsSubCRev(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;
  function ippsMulC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsMulC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;

  function ippsMulC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMulC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp16s;len:longint):IppStatus;overload;


  function ippsAddC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubCRev(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMulC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAddC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMulC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAddC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMulC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubCRev(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubCRev(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAddC(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAddC(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubC(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubC(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubCRev(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubCRev(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMulC(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMulC(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;

  function ippsAddC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsAddC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsSubC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsSubC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsSubCRev(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsSubCRev(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsMulC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsMulC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsAddC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsAddC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
  function ippsSubC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsSubC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
  function ippsSubCRev(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsSubCRev(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
  function ippsMulC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsMulC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;

  function ippsAddC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubCRev(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMulC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAddC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAddC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubCRev(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubCRev(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMulC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMulC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAddC(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAddC(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubC(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubC(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubCRev(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSubCRev(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMulC(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMulC(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;

  function ippsAdd(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
  function ippsSub(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
  function ippsMul(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;overload;
  function ippsAdd(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsAdd(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsSub(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsSub(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsMul(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsMul(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsAdd(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsAdd(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;
  function ippsSub(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsSub(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;
  function ippsMul(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsMul(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;overload;


  function ippsAdd(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSub(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMul(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAdd(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAdd(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSub(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSub(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMul(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMul(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAdd(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAdd(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSub(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSub(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMul(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMul(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAdd(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp16u;len:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp16u;len:longint):IppStatus;overload;
  function ippsAdd(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
  function ippsSub(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;overload;
  function ippsAdd(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;overload;
  function ippsAdd(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;overload;
  function ippsAdd(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsSub(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsAdd(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsAdd(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsSub(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsSub(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;overload;
  function ippsAdd(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsAdd(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
  function ippsSub(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsSub(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;overload;

  function ippsAdd(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSub(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAdd(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAdd(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSub(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSub(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAdd(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsAdd(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSub(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsSub(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp16u;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;overload;


  function ippsMul(pSrc:PIpp32s;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;
  function ippsMul(pSrc1:PIpp32s;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;overload;


implementation

function ippsAddC(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsAddC_16s_I(val,pSrcDst,len);
end;

function ippsSubC(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsSubC_16s_I(val,pSrcDst,len);
end;

function ippsMulC(val:Ipp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsMulC_16s_I(val,pSrcDst,len);
end;

function ippsAddC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsAddC_32f_I(val,pSrcDst,len);
end;

function ippsAddC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsAddC_32fc_I(val,pSrcDst,len);
end;

function ippsSubC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSubC_32f_I(val,pSrcDst,len);
end;

function ippsSubC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSubC_32fc_I(val,pSrcDst,len);
end;

function ippsSubCRev(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSubCRev_32f_I(val,pSrcDst,len);
end;

function ippsSubCRev(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSubCRev_32fc_I(val,pSrcDst,len);
end;

function ippsMulC(val:Ipp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMulC_32f_I(val,pSrcDst,len);
end;

function ippsMulC(val:Ipp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsMulC_32fc_I(val,pSrcDst,len);
end;

function ippsAddC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsAddC_64f_I(val,pSrcDst,len);
end;

function ippsAddC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsAddC_64fc_I(val,pSrcDst,len);
end;

function ippsSubC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSubC_64f_I(val,pSrcDst,len);
end;

function ippsSubC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSubC_64fc_I(val,pSrcDst,len);
end;

function ippsSubCRev(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSubCRev_64f_I(val,pSrcDst,len);
end;

function ippsSubCRev(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSubCRev_64fc_I(val,pSrcDst,len);
end;

function ippsMulC(val:Ipp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsMulC_64f_I(val,pSrcDst,len);
end;

function ippsMulC(val:Ipp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsMulC_64fc_I(val,pSrcDst,len);
end;


function ippsMulC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_32f16s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsMulC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsMulC_Low_32f16s(pSrc,val,pDst,len);
end;



function ippsAddC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_8u_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_8u_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubCRev(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_8u_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsMulC(val:Ipp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_8u_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsAddC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_16s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_16s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsMulC(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_16s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsAddC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_16sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_16sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsMulC(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_16sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubCRev(val:Ipp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_16s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubCRev(val:Ipp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_16sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsAddC(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_32s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsAddC(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_32sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubC(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_32s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubC(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_32sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubCRev(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_32s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsSubCRev(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_32sc_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsMulC(val:Ipp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_32s_ISfs(val,pSrcDst,len,scaleFactor);
end;

function ippsMulC(val:Ipp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_32sc_ISfs(val,pSrcDst,len,scaleFactor);
end;


function ippsAddC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsAddC_32f(pSrc,val,pDst,len);
end;

function ippsAddC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsAddC_32fc(pSrc,val,pDst,len);
end;

function ippsSubC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSubC_32f(pSrc,val,pDst,len);
end;

function ippsSubC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSubC_32fc(pSrc,val,pDst,len);
end;

function ippsSubCRev(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSubCRev_32f(pSrc,val,pDst,len);
end;

function ippsSubCRev(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSubCRev_32fc(pSrc,val,pDst,len);
end;

function ippsMulC(pSrc:PIpp32f;val:Ipp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMulC_32f(pSrc,val,pDst,len);
end;

function ippsMulC(pSrc:PIpp32fc;val:Ipp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsMulC_32fc(pSrc,val,pDst,len);
end;

function ippsAddC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsAddC_64f(pSrc,val,pDst,len);
end;

function ippsAddC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsAddC_64fc(pSrc,val,pDst,len);
end;

function ippsSubC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSubC_64f(pSrc,val,pDst,len);
end;

function ippsSubC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSubC_64fc(pSrc,val,pDst,len);
end;

function ippsSubCRev(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSubCRev_64f(pSrc,val,pDst,len);
end;

function ippsSubCRev(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSubCRev_64fc(pSrc,val,pDst,len);
end;

function ippsMulC(pSrc:PIpp64f;val:Ipp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsMulC_64f(pSrc,val,pDst,len);
end;

function ippsMulC(pSrc:PIpp64fc;val:Ipp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsMulC_64fc(pSrc,val,pDst,len);
end;


function ippsAddC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_8u_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_8u_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubCRev(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_8u_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsMulC(pSrc:PIpp8u;val:Ipp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_8u_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsAddC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_16s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsAddC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_16sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_16s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_16sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubCRev(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_16s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubCRev(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_16sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsMulC(pSrc:PIpp16s;val:Ipp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_16s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsMulC(pSrc:PIpp16sc;val:Ipp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_16sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsAddC(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_32s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsAddC(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAddC_32sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubC(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_32s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubC(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubC_32sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubCRev(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_32s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsSubCRev(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSubCRev_32sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsMulC(pSrc:PIpp32s;val:Ipp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_32s_Sfs(pSrc,val,pDst,len,scaleFactor);
end;

function ippsMulC(pSrc:PIpp32sc;val:Ipp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMulC_32sc_Sfs(pSrc,val,pDst,len,scaleFactor);
end;


function ippsAdd(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsAdd_16s_I(pSrc,pSrcDst,len);
end;

function ippsSub(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsSub_16s_I(pSrc,pSrcDst,len);
end;

function ippsMul(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsMul_16s_I(pSrc,pSrcDst,len);
end;

function ippsAdd(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsAdd_32f_I(pSrc,pSrcDst,len);
end;

function ippsAdd(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsAdd_32fc_I(pSrc,pSrcDst,len);
end;

function ippsSub(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSub_32f_I(pSrc,pSrcDst,len);
end;

function ippsSub(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSub_32fc_I(pSrc,pSrcDst,len);
end;

function ippsMul(pSrc:PIpp32f;pSrcDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMul_32f_I(pSrc,pSrcDst,len);
end;

function ippsMul(pSrc:PIpp32fc;pSrcDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsMul_32fc_I(pSrc,pSrcDst,len);
end;

function ippsAdd(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsAdd_64f_I(pSrc,pSrcDst,len);
end;

function ippsAdd(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsAdd_64fc_I(pSrc,pSrcDst,len);
end;

function ippsSub(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSub_64f_I(pSrc,pSrcDst,len);
end;

function ippsSub(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSub_64fc_I(pSrc,pSrcDst,len);
end;

function ippsMul(pSrc:PIpp64f;pSrcDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsMul_64f_I(pSrc,pSrcDst,len);
end;

function ippsMul(pSrc:PIpp64fc;pSrcDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsMul_64fc_I(pSrc,pSrcDst,len);
end;



function ippsAdd(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_8u_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsSub(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_8u_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsMul(pSrc:PIpp8u;pSrcDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_8u_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsAdd(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_16s_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsAdd(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_16sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsSub(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_16s_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsSub(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_16sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsMul(pSrc:PIpp16s;pSrcDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_16s_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsMul(pSrc:PIpp16sc;pSrcDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_16sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsAdd(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_32s_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsAdd(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_32sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsSub(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_32s_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsSub(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_32sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsMul(pSrc:PIpp32s;pSrcDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_32s_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsMul(pSrc:PIpp32sc;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_32sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsAdd(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsAdd_8u16u(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsMul_8u16u(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsAdd_16s(pSrc1,pSrc2,pDst,len);
end;

function ippsSub(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsSub_16s(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint):IppStatus;
begin
  result:=ippsMul_16s(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp16u;pSrc2:PIpp16u;pDst:PIpp16u;len:longint):IppStatus;
begin
  result:=ippsAdd_16u(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp32u;pSrc2:PIpp32u;pDst:PIpp32u;len:longint):IppStatus;
begin
  result:=ippsAdd_32u(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsAdd_16s32f(pSrc1,pSrc2,pDst,len);
end;

function ippsSub(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSub_16s32f(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMul_16s32f(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsAdd_32f(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsAdd_32fc(pSrc1,pSrc2,pDst,len);
end;

function ippsSub(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsSub_32f(pSrc1,pSrc2,pDst,len);
end;

function ippsSub(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsSub_32fc(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp32f;pSrc2:PIpp32f;pDst:PIpp32f;len:longint):IppStatus;
begin
  result:=ippsMul_32f(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp32fc;pSrc2:PIpp32fc;pDst:PIpp32fc;len:longint):IppStatus;
begin
  result:=ippsMul_32fc(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsAdd_64f(pSrc1,pSrc2,pDst,len);
end;

function ippsAdd(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsAdd_64fc(pSrc1,pSrc2,pDst,len);
end;

function ippsSub(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsSub_64f(pSrc1,pSrc2,pDst,len);
end;

function ippsSub(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsSub_64fc(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp64f;pSrc2:PIpp64f;pDst:PIpp64f;len:longint):IppStatus;
begin
  result:=ippsMul_64f(pSrc1,pSrc2,pDst,len);
end;

function ippsMul(pSrc1:PIpp64fc;pSrc2:PIpp64fc;pDst:PIpp64fc;len:longint):IppStatus;
begin
  result:=ippsMul_64fc(pSrc1,pSrc2,pDst,len);
end;


function ippsAdd(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_8u_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsSub(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_8u_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp8u;pSrc2:PIpp8u;pDst:PIpp8u;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_8u_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsAdd(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_16s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsAdd(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_16sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsSub(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_16s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsSub(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_16sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_16s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp16sc;pSrc2:PIpp16sc;pDst:PIpp16sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_16sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp16s;pSrc2:PIpp16s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_16s32s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsAdd(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_32s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsAdd(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsAdd_32sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsSub(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_32s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsSub(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsSub_32sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp32s;pSrc2:PIpp32s;pDst:PIpp32s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_32s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp32sc;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_32sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp16u;pSrc2:PIpp16s;pDst:PIpp16s;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_16u16s_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;



function ippsMul(pSrc:PIpp32s;pSrcDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_32s32sc_ISfs(pSrc,pSrcDst,len,scaleFactor);
end;

function ippsMul(pSrc1:PIpp32s;pSrc2:PIpp32sc;pDst:PIpp32sc;len:longint;scaleFactor:longint):IppStatus;
begin
  result:=ippsMul_32s32sc_Sfs(pSrc1,pSrc2,pDst,len,scaleFactor);
end;


procedure test;
var
  p1,p2:Pointer;
begin
  ippsAdd(Pdouble(p1),Pdouble(p2),100);

end;

end.
