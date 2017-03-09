unit doubleExt;

interface

function ExtendedToDouble( var w): double;
procedure DoubleToExtended( dd: double; var w);

implementation

uses math;
(*

float64 C_IOHandler::readFloat80(IColl<uint8> buffer, uint32 *ref_offset)
{
    uint32 &offset = *ref_offset;

    //80 bit floating point value according to the IEEE-754 specification and the Standard Apple Numeric Environment specification:
    //1 bit sign, 15 bit exponent, 1 bit normalization indication, 63 bit mantissa

    float64 sign;
    if ((buffer[offset] & 0x80) == 0x00)
        sign = 1;
    else
        sign = -1;
    uint32 exponent = (((uint32)buffer[offset] & 0x7F) << 8) | (uint32)buffer[offset + 1];
    uint64 mantissa = readUInt64BE(buffer, offset + 2);

    //If the highest bit of the mantissa is set, then this is a normalized number.
    float64 normalizeCorrection;
    if ((mantissa & 0x8000000000000000) != 0x00)
        normalizeCorrection = 1;
    else
        normalizeCorrection = 0;
    mantissa &= 0x7FFFFFFFFFFFFFFF;

    offset += 10;

    //value = (-1) ^ s * (normalizeCorrection + m / 2 ^ 63) * 2 ^ (e - 16383)
    return (sign * (normalizeCorrection + (float64)mantissa / ((uint64)1 << 63)) * g_Math->toPower(2, (int32)exponent - 16383));
}
*)


function ExtendedToDouble( var w): double;
var
  buffer: array[0..9] of byte absolute w;
  sign:double;
  exponent: longint;
  mantissa: int64;
  normalizeCorrection: double;
  i:integer;
begin
  //80 bit floating point value according to the IEEE-754 specification and the Standard Apple Numeric Environment specification:
  //1 bit sign, 15 bit exponent, 1 bit normalization indication, 63 bit mantissa

  if buffer[9] and  $80 = 0
    then sign := 1
    else sign := -1;

  exponent := (buffer[9] and $7F) shl 8 or buffer[8];

  move(buffer[0], mantissa, 8);

  //If the highest bit of the mantissa is set, then this is a normalized number.
  if mantissa and $8000000000000000 <> 0
    then normalizeCorrection := 1
    else normalizeCorrection := 0;

  mantissa:= mantissa and $7FFFFFFFFFFFFFFF;

  //Avec XE Win64, le débordement n'est pas accepté
  exponent:=exponent-16383;
  if exponent<-1000 then exponent:=-1000
  else
  if exponent >1000 then exponent:=1000;

  //value = (-1) ^ s * (normalizeCorrection + m / 2 ^ 63) * 2 ^ (e - 16383)
  result:= sign * (normalizeCorrection +  mantissa/2/ (int64(1) shl 62)) * Power(2.0, exponent);
end;

procedure DoubleToExtended( dd: double; var w);
var
  buffer: array[0..7] of byte absolute dd;
  sign:byte;
  exponent: longint;
  mantissa: int64;
  normalizeCorrection: byte;

  bufferW: array[0..9] of byte absolute w;

  maxE: double;
  mantissaR: double;
begin
  fillchar(bufferW,sizeof(bufferW),0);
  if dd=0 then exit;                         // ajouté le 28-04-16

  sign:= buffer[7] and $80;

  exponent := (buffer[7] and $7F) shl 4  or buffer[6] shr 4;

  normalizeCorrection := $80;

  maxE:=2.0* (int64(1) shl 62);

  if exponent=0 then exponent:=1023;
  exponent:=exponent-1023 +16383;

  mantissaR:=(abs(dd)/power(2,exponent-16383) -1)*maxE;
  mantissa:= round(mantissaR);

  move(mantissa,bufferW[0],8);

  bufferW[7]:=bufferW[7] and $7F or  NormalizeCorrection;

  move(exponent,bufferW[8],2);

  bufferW[9]:=bufferW[9] and $7F or Sign;

end;


end.
