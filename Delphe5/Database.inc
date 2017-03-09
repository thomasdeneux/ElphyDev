            { Constants from JDBC ZEOSlib }
const
  { Constants from JDBC DatabaseMetadata }
  TypeSearchable           = 3;
  ProcedureReturnsResult   = 2;

Const
  {** Defines supported SQL types. }
  stUnknown                = 0;
  stBoolean                = 1;
  stByte                   = 2;
  stShort                  = 3;
  stInteger                = 4;
  stLong                   = 5;
  stFloat,                 = 6;
  stDouble                 = 7;
  stBigDecimal             = 8;
  stString                 = 9;
  stUnicodeString          = 10;
  stBytes                  = 11;
  stDate                   = 12;
  stTime,                  = 13;
  stTimestamp              = 14;
  stAsciiStream            = 15;
  stUnicodeStream          = 16;
  stBinaryStream           = 17;

  {** Defines a transaction isolation level. }
  tiNone                   = 0;
  tiReadUncommitted        = 1;
  tiReadCommitted,         = 2;
  tiRepeatableRead         = 3;
  tiSerializable           = 4;

  {** Defines a resultset fetch direction. }
  fdForward                = 0;
  fdReverse                = 1;
  fdUnknown                = 2;

  {** Defines a type of result set. }
  rtForwardOnly            = 0;
  rtScrollInsensitive      = 1;
  rtScrollSensitive        = 2;

  {** Defines a result set concurrency type. }
  rcReadOnly               = 0;
  rcUpdatable              = 1;

  {** Defines a nullable type for the column. }
  ntNoNulls                = 0;
  ntNullable               = 1;
  ntNullableUnknown        = 2;

  {** Defines a result type for the procedures. }
  prtUnknown               = 0;
  prtNoResult              = 1;
  prtReturnsResult         = 2;

  {** Defines a column type for the procedures. }
  pctUnknown               = 0;
  pctIn                    = 1;
  pctInOut                 = 2;
  pctOut                   = 3;
  pctReturn                = 4;
  pctResultSet             = 5;

  {** Defines a best row identifier. }
  brUnknown                = 0;
  brNotPseudo              = 1;
  brPseudo                 = 2;

  {** Defines a scope best row identifier. }
  sbrTemporary             = 0;
  sbrTransaction           = 1;
  sbrSession               = 2;

  {** Defines a version column. }
  vcUnknown                = 0;
  vcNotPseudo              = 1;
  vcPseudo                 = 2;

  {**  }
  ikCascade                = 0;
  ikRestrict               = 1;
  ikSetNull                = 2;
  ikNoAction               = 3;
  ikSetDefault             = 4;
  ikInitiallyDeferred      = 5;
  ikInitiallyImmediate     = 6;
  ikNotDeferrable          = 7;

  tiStatistic              = 0;
  tiClustered              = 1;
  tiHashed                 = 2;
  tiOther                  = 3;

  {** Defines a post update mode. }
  poColumnsAll             = 0;
  poColumnsChanged         = 1;

  {** Defines a locate mode. }
  loWhereAll               = 0;
  loWhereChanged           = 1;
  loWhereKeyOnly           = 2;

  
