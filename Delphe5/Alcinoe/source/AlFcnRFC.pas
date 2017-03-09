{*************************************************************
Author:       Stéphane Vander Clock (SVanderClock@Arkadia.com)
www:          http://www.arkadia.com
EMail:        SVanderClock@Arkadia.com

product:      Common RFC functions
Version:      3.05

Description:  Common functions to work with RFC standards. especialy
              to convert RFC date time string to TDateTime.

Legal issues: Copyright (C) 1999-2005 by Arkadia Software Engineering

              This software is provided 'as-is', without any express
              or implied warranty.  In no event will the author be
              held liable for any  damages arising from the use of
              this software.

              Permission is granted to anyone to use this software
              for any purpose, including commercial applications,
              and to alter it and redistribute it freely, subject
              to the following restrictions:

              1. The origin of this software must not be
                 misrepresented, you must not claim that you wrote
                 the original software. If you use this software in
                 a product, an acknowledgment in the product
                 documentation would be appreciated but is not
                 required.

              2. Altered source versions must be plainly marked as
                 such, and must not be misrepresented as being the
                 original software.

              3. This notice may not be removed or altered from any
                 source distribution.

              4. You must register this software by sending a picture
                 postcard to the author. Use a nice stamp and mention
                 your name, street address, EMail address and any
                 comment you like to say.

Know bug :

History :

Link :        http://www.rfc.net/

Please send all your feedback to SVanderClock@Arkadia.com
**************************************************************}
unit AlFcnRFC;

interface

uses Windows,
     Classes;

function ALGmtDateTimeToRfc822Str(const aValue: TDateTime): String;
function ALDateTimeToRfc822Str(const aValue: TDateTime): String;
Function ALTryRfc822StrToGMTDateTime(const S: string; out Value: TDateTime): Boolean;
function ALRfc822StrToGMTDateTime(const s: String): TDateTime;

const
  CAlRfc822DaysOfWeek: array[1..7] of string = (
                                                'Sun',
                                                'Mon',
                                                'Tue',
                                                'Wed',
                                                'Thu',
                                                'Fri',
                                                'Sat'
                                               );

  CALRfc822MonthNames: array[1..12] of string = (
                                                 'Jan',
                                                 'Feb',
                                                 'Mar',
                                                 'Apr',
                                                 'May',
                                                 'Jun',
                                                 'Jul',
                                                 'Aug',
                                                 'Sep',
                                                 'Oct',
                                                 'Nov',
                                                 'Dec'
                                                );

implementation

Uses SYsUtils,
     SysConst,
     AlFcnString;

{*********************************************************************}
{aValue is a GMT TDateTime - result is "Sun, 06 Nov 1994 08:49:37 GMT"}
function  ALGMTDateTimeToRfc822Str(const aValue: TDateTime): String;
var aDay, aMonth, aYear: Word;
begin
  DecodeDate(
             aValue,
             aYear,
             aMonth,
             aDay
            );

  Result := Format(
                   '%s, %.2d %s %.4d %s %s',
                   [
                    CAlRfc822DaysOfWeek[DayOfWeek(aValue)],
                    aDay,
                    CAlRfc822MonthNames[aMonth],
                    aYear,
                    FormatDateTime('hh":"nn":"ss', aValue),
                    'GMT'
                   ]
                  );
end;

{***********************************************************************}
{aValue is a Local TDateTime - result is "Sun, 06 Nov 1994 08:49:37 GMT"}
function ALDateTimeToRfc822Str(const aValue: TDateTime): String;

  {--------------------------------------------}
  function InternalCalcTimeZoneBias : TDateTime;
  const Time_Zone_ID_DayLight = 2;
  var TZI: TTimeZoneInformation;
      TZIResult: Integer;
      aBias : Integer;
  begin
    TZIResult := GetTimeZoneInformation(TZI);
    if TZIResult = -1 then Result := 0
    else begin
      if TZIResult = Time_Zone_ID_DayLight then aBias := TZI.Bias + TZI.DayLightBias
      else aBias := TZI.Bias + TZI.StandardBias;
      Result := EncodeTime(Abs(aBias) div 60, Abs(aBias) mod 60, 0, 0);
      if aBias < 0 then Result := -Result;
    end;
  end;

begin
  Result := ALGMTDateTimeToRfc822Str(aValue + InternalCalcTimeZoneBias);
end;

{************************************************************}
{Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
 the function allow also date like "Sun, 06-Nov-1994 08:49:37 GMT"
 to be compatible with cookies field (http://wp.netscape.com/newsref/std/cookie_spec.html)}
Function  ALTryRfc822StrToGMTDateTime(const S: string; out Value: TDateTime): Boolean;
Var P: Integer;
    ADateStr : String;
    aLst: TstringList;
    aMonthLabel: String;
    aFormatSettings: TformatSettings;

    {----------------------------------------------------------}
    Function MonthWithLeadingChar(const AMonth: String): String;
    Begin
      If Length(AMonth) = 1 then result := '0' + AMonth
      else result := aMonth;
    end;

Begin
  ADateStr := S; //'Wdy, DD-Mon-YYYY HH:MM:SS GMT'
  P := AlPos(', ',ADateStr);
  If P > 0 then delete(ADateStr,1,P + 1) //'DD-Mon-YYYY HH:MM:SS GMT'
  else Begin
    Result := False;
    Exit;
  end;
  ADateStr := trim(
                   AlStringReplace(
                                   ADateStr,
                                   ' GMT',
                                   '',
                                   [RfIgnoreCase]
                                  )
                  ); //'DD-Mon-YYYY HH:MM:SS'

  ADateStr := AlStringReplace(ADateStr, '-', ' ',[RfReplaceall]); //'DD Mon YYYY HH:MM:SS'
  While Alpos('  ',ADateStr) > 0 do ADateStr := AlStringReplace(ADateStr,'  ',' ',[RfReplaceAll]); //'DD Mon YYYY HH:MM:SS'
  Alst := TstringList.create;
  Try
    Alst.Text :=  AlStringReplace(ADateStr,' ',#13#10,[RfReplaceall]);
    If Alst.Count <> 4 then begin
      Result := False;
      Exit;
    end;
    aMonthLabel := trim(Alst[1]);
    P := 1;
    While (p <= 12) and (not sameText(CAlRfc822MonthNames[P],aMonthLabel)) do inc(P);
    If P > 12 then begin
      Result := False;
      Exit;
    end;
    ADateStr := trim(Alst[0]) + '/' + MonthWithLeadingChar(inttostr(P))  + '/' + trim(Alst[2]) + ' ' + trim(Alst[3]); //'DD/MM/YYYY HH:MM:SS'
    GetLocaleFormatSettings(GetSystemDefaultLCID,aFormatSettings);
    aFormatSettings.DateSeparator := '/';
    aFormatSettings.TimeSeparator := ':';
    aFormatSettings.ShortDateFormat := 'dd/mm/yyyy';
    aFormatSettings.ShortTimeFormat := 'hh:nn:zz';
    Result := TryStrToDateTime(ADateStr,Value,AformatSettings);
  finally
    aLst.free;
  end;
end;

{*************************************************************}
{Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
 the function allow also date like "Sun, 06-Nov-1994 08:49:37 GMT"
 to be compatible with cookies field (http://wp.netscape.com/newsref/std/cookie_spec.html)}
function  ALRfc822StrToGMTDateTime(const s: String): TDateTime;
Begin
  if not ALTryRfc822StrToGMTDateTime(S, Result) then
    raise EConvertError.CreateResFmt(@SInvalidDateTime, [S]);
end;

end.
