{*********************************************************}
{                                                         }
{                 Zeos Database Objects                   }
{           Database Connectivity Interfaces              }
{                                                         }
{        Originally written by Sergey Seroukhov           }
{                                                         }
{*********************************************************}

{@********************************************************}
{    Copyright (c) 1999-2006 Zeos Development Group       }
{                                                         }
{ License Agreement:                                      }
{                                                         }
{ This library is distributed in the hope that it will be }
{ useful, but WITHOUT ANY WARRANTY; without even the      }
{ implied warranty of MERCHANTABILITY or FITNESS FOR      }
{ A PARTICULAR PURPOSE.  See the GNU Lesser General       }
{ Public License for more details.                        }
{                                                         }
{ The source code of the ZEOS Libraries and packages are  }
{ distributed under the Library GNU General Public        }
{ License (see the file COPYING / COPYING.ZEOS)           }
{ with the following  modification:                       }
{ As a special exception, the copyright holders of this   }
{ library give you permission to link this library with   }
{ independent modules to produce an executable,           }
{ regardless of the license terms of these independent    }
{ modules, and to copy and distribute the resulting       }
{ executable under terms of your choice, provided that    }
{ you also meet, for each linked independent module,      }
{ the terms and conditions of the license of that module. }
{ An independent module is a module which is not derived  }
{ from or based on this library. If you modify this       }
{ library, you may extend this exception to your version  }
{ of the library, but you are not obligated to do so.     }
{ If you do not wish to do so, delete this exception      }
{ statement from your version.                            }
{                                                         }
{                                                         }
{ The project web site is located on:                     }
{   http://zeos.firmos.at  (FORUM)                        }
{   http://zeosbugs.firmos.at (BUGTRACKER)                }
{   svn://zeos.firmos.at/zeos/trunk (SVN Repository)      }
{                                                         }
{   http://www.sourceforge.net/projects/zeoslib.          }
{   http://www.zeoslib.sourceforge.net                    }
{                                                         }
{                                                         }
{                                                         }
{                                 Zeos Development Group. }
{********************************************************@}

unit ZDbcIntfs;

interface

{$I ZDbc.inc}

uses
{$IFNDEF VER130BELOW}
  Types,
{$ENDIF}
  Classes, SysUtils, ZClasses, ZCollections, ZSysUtils, ZCompatibility,
  ZTokenizer, ZSelectSchema, ZGenericSqlAnalyser, ZDbcLogging, ZVariant;

const
  { Constants from JDBC DatabaseMetadata }
  TypeSearchable           = 3;
  ProcedureReturnsResult   = 2;

// Exceptions
type

  {** Abstract SQL exception. }
  EZSQLThrowable = class(Exception)
  private
    FErrorCode: Integer;
    FStatusCode: AnsiString;
  public
    constructor Create(const Msg: AnsiString);
    constructor CreateWithCode(const ErrorCode: Integer; const Msg: AnsiString);
    constructor CreateWithStatus(const StatusCode: AnsiString; const Msg: AnsiString);
    constructor CreateClone(const E:EZSQLThrowable);

    property ErrorCode: Integer read FErrorCode;
    property StatusCode: AnsiString read FStatuscode; // The "AnsiString" Errocode // FirmOS
  end;

  {** Generic SQL exception. }
  EZSQLException = class(EZSQLThrowable);

  {** Generic SQL warning. }
  EZSQLWarning = class(EZSQLThrowable);

// Data types
type
  {** Defines supported SQL types. }
  TZSQLType = (stUnknown, stBoolean, stByte, stShort, stInteger, stLong, stFloat,
    stDouble, stBigDecimal, stString, stUnicodeString, stBytes, stDate, stTime,
    stTimestamp, stAsciiStream, stUnicodeStream, stBinaryStream);

  {** Defines a transaction isolation level. }
  TZTransactIsolationLevel = (tiNone, tiReadUncommitted, tiReadCommitted,
    tiRepeatableRead, tiSerializable);

  {** Defines a resultset fetch direction. }
  TZFetchDirection = (fdForward, fdReverse, fdUnknown);

  {** Defines a type of result set. }
  TZResultSetType = (rtForwardOnly, rtScrollInsensitive, rtScrollSensitive);

  {** Defines a result set concurrency type. }
  TZResultSetConcurrency = (rcReadOnly, rcUpdatable);

  {** Defines a nullable type for the column. }
  TZColumnNullableType = (ntNoNulls, ntNullable, ntNullableUnknown);

  {** Defines a result type for the procedures. }
  TZProcedureResultType = (prtUnknown, prtNoResult, prtReturnsResult);

  {** Defines a column type for the procedures. }
  TZProcedureColumnType = (pctUnknown, pctIn, pctInOut, pctOut, pctReturn,
    pctResultSet);

  {** Defines a best row identifier. }
  TZBestRowIdentifier = (brUnknown, brNotPseudo, brPseudo);

  {** Defines a scope best row identifier. }
  TZScopeBestRowIdentifier = (sbrTemporary, sbrTransaction, sbrSession);

  {** Defines a version column. }
  TZVersionColumn = (vcUnknown, vcNotPseudo, vcPseudo);

  {**  }
  TZImportedKey = (ikCascade, ikRestrict, ikSetNull, ikNoAction, ikSetDefault,
    ikInitiallyDeferred, ikInitiallyImmediate, ikNotDeferrable);

  TZTableIndex = (tiStatistic, tiClustered, tiHashed, tiOther);

  {** Defines a post update mode. }
  TZPostUpdatesMode = (poColumnsAll, poColumnsChanged);

  {** Defines a locate mode. }
  TZLocateUpdatesMode = (loWhereAll, loWhereChanged, loWhereKeyOnly);

// Interfaces
type

  // Forward declarations
  IZDriverManager = interface;
  IZDriver = interface;
  IZConnection = interface;
  IZDatabaseMetadata = interface;
  IZStatement = interface;
  IZPreparedStatement = interface;
  IZCallableStatement = interface;
  IZResultSet = interface;
  IZResultSetMetadata = interface;
  IZBlob = interface;
  IZNotification = interface;
  IZSequence = interface;

  {** Driver Manager interface. }
  IZDriverManager = interface(IZInterface)
    ['{8874B9AA-068A-4C0C-AE75-9DB1EA9E3720}']

    function GetConnection(const Url: AnsiString): IZConnection;
    function GetConnectionWithParams(const Url: AnsiString; Info: TStrings): IZConnection;
    function GetConnectionWithLogin(const Url: AnsiString; const User: AnsiString;
      const Password: AnsiString): IZConnection;

    function GetDriver(const Url: AnsiString): IZDriver;
    function GetClientVersion(const Url: AnsiString): Integer;
    procedure RegisterDriver(Driver: IZDriver);
    procedure DeregisterDriver(Driver: IZDriver);

    function GetDrivers: IZCollection;

    function GetLoginTimeout: Integer;
    procedure SetLoginTimeout(Seconds: Integer);

    procedure AddLoggingListener(Listener: IZLoggingListener);
    procedure RemoveLoggingListener(Listener: IZLoggingListener);

    procedure LogMessage(Category: TZLoggingCategory; const Protocol: AnsiString;
      const Msg: AnsiString);
    procedure LogError(Category: TZLoggingCategory; const Protocol: AnsiString;
      const Msg: AnsiString; ErrorCode: Integer; const Error: AnsiString);
  end;

  {** Database Driver interface. }
  IZDriver = interface(IZInterface)
    ['{2157710E-FBD8-417C-8541-753B585332E2}']

    function GetSupportedProtocols: TStringDynArray;
    function Connect(const Url: AnsiString; Info: TStrings): IZConnection;
    function GetClientVersion(const Url: AnsiString): Integer;
    function AcceptsURL(const Url: AnsiString): Boolean;

    function GetPropertyInfo(const Url: AnsiString; Info: TStrings): TStrings;
    function GetMajorVersion: Integer;
    function GetMinorVersion: Integer;
    function GetSubVersion: Integer;
    function GetTokenizer: IZTokenizer;
    function GetStatementAnalyser: IZStatementAnalyser;
  end;

  {** Database Connection interface. }
  IZConnection = interface(IZInterface)
    ['{8EEBBD1A-56D1-4EC0-B3BD-42B60591457F}']

    function CreateStatement: IZStatement;
    function PrepareStatement(const SQL: AnsiString): IZPreparedStatement;
    function PrepareCall(const SQL: AnsiString): IZCallableStatement;

    function CreateStatementWithParams(Info: TStrings): IZStatement;
    function PrepareStatementWithParams(const SQL: AnsiString; Info: TStrings):
      IZPreparedStatement;
    function PrepareCallWithParams(const SQL: AnsiString; Info: TStrings):
      IZCallableStatement;

    function CreateNotification(const Event: AnsiString): IZNotification;
    function CreateSequence(const Sequence: AnsiString; BlockSize: Integer): IZSequence;

    function NativeSQL(const SQL: AnsiString): AnsiString;

    procedure SetAutoCommit(Value: Boolean);
    function GetAutoCommit: Boolean;

    procedure Commit;
    procedure Rollback;

    //2Phase Commit Support initially for PostgresSQL (firmos) 21022006
    procedure PrepareTransaction(const transactionid: AnsiString);
    procedure CommitPrepared(const transactionid: AnsiString);
    procedure RollbackPrepared(const transactionid: AnsiString);


    //Ping Server Support (firmos) 27032006

    function PingServer: Integer;
    function EscapeString(Value : AnsiString) : AnsiString;


    procedure Open;
    procedure Close;
    function IsClosed: Boolean;

    function GetDriver: IZDriver;
    function GetMetadata: IZDatabaseMetadata;
    function GetParameters: TStrings;
    function GetClientVersion: Integer;
    function GetHostVersion: Integer;

    procedure SetReadOnly(Value: Boolean);
    function IsReadOnly: Boolean;

    procedure SetCatalog(const Value: AnsiString);
    function GetCatalog: AnsiString;

    procedure SetTransactionIsolation(Value: TZTransactIsolationLevel);
    function GetTransactionIsolation: TZTransactIsolationLevel;

    function GetWarnings: EZSQLWarning;
    procedure ClearWarnings;
  end;

  {** Database metadata interface. }
  IZDatabaseMetadata = interface(IZInterface)
    ['{FE331C2D-0664-464E-A981-B4F65B85D1A8}']

    function AllProceduresAreCallable: Boolean;
    function AllTablesAreSelectable: Boolean;
    function GetURL: AnsiString;
    function GetUserName: AnsiString;
    function IsReadOnly: Boolean;
    function NullsAreSortedHigh: Boolean;
    function NullsAreSortedLow: Boolean;
    function NullsAreSortedAtStart: Boolean;
    function NullsAreSortedAtEnd: Boolean;
    function GetDatabaseProductName: AnsiString;
    function GetDatabaseProductVersion: AnsiString;
    function GetDriverName: AnsiString;
    function GetDriverVersion: AnsiString;
    function GetDriverMajorVersion: Integer;
    function GetDriverMinorVersion: Integer;
    function UsesLocalFiles: Boolean;
    function UsesLocalFilePerTable: Boolean;
    function SupportsMixedCaseIdentifiers: Boolean;
    function StoresUpperCaseIdentifiers: Boolean;
    function StoresLowerCaseIdentifiers: Boolean;
    function StoresMixedCaseIdentifiers: Boolean;
    function SupportsMixedCaseQuotedIdentifiers: Boolean;
    function StoresUpperCaseQuotedIdentifiers: Boolean;
    function StoresLowerCaseQuotedIdentifiers: Boolean;
    function StoresMixedCaseQuotedIdentifiers: Boolean;
    function GetIdentifierQuoteString: AnsiString;
    function GetSQLKeywords: AnsiString;
    function GetNumericFunctions: AnsiString;
    function GetStringFunctions: AnsiString;
    function GetSystemFunctions: AnsiString;
    function GetTimeDateFunctions: AnsiString;
    function GetSearchStringEscape: AnsiString;
    function GetExtraNameCharacters: AnsiString;

    function SupportsAlterTableWithAddColumn: Boolean;
    function SupportsAlterTableWithDropColumn: Boolean;
    function SupportsColumnAliasing: Boolean;
    function NullPlusNonNullIsNull: Boolean;
    function SupportsConvert: Boolean;
    function SupportsConvertForTypes(FromType: TZSQLType; ToType: TZSQLType):
      Boolean;
    function SupportsTableCorrelationNames: Boolean;
    function SupportsDifferentTableCorrelationNames: Boolean;
    function SupportsExpressionsInOrderBy: Boolean;
    function SupportsOrderByUnrelated: Boolean;
    function SupportsGroupBy: Boolean;
    function SupportsGroupByUnrelated: Boolean;
    function SupportsGroupByBeyondSelect: Boolean;
    function SupportsLikeEscapeClause: Boolean;
    function SupportsMultipleResultSets: Boolean;
    function SupportsMultipleTransactions: Boolean;
    function SupportsNonNullableColumns: Boolean;
    function SupportsMinimumSQLGrammar: Boolean;
    function SupportsCoreSQLGrammar: Boolean;
    function SupportsExtendedSQLGrammar: Boolean;
    function SupportsANSI92EntryLevelSQL: Boolean;
    function SupportsANSI92IntermediateSQL: Boolean;
    function SupportsANSI92FullSQL: Boolean;
    function SupportsIntegrityEnhancementFacility: Boolean;
    function SupportsOuterJoins: Boolean;
    function SupportsFullOuterJoins: Boolean;
    function SupportsLimitedOuterJoins: Boolean;
    function GetSchemaTerm: AnsiString;
    function GetProcedureTerm: AnsiString;
    function GetCatalogTerm: AnsiString;
    function IsCatalogAtStart: Boolean;
    function GetCatalogSeparator: AnsiString;
    function SupportsSchemasInDataManipulation: Boolean;
    function SupportsSchemasInProcedureCalls: Boolean;
    function SupportsSchemasInTableDefinitions: Boolean;
    function SupportsSchemasInIndexDefinitions: Boolean;
    function SupportsSchemasInPrivilegeDefinitions: Boolean;
    function SupportsCatalogsInDataManipulation: Boolean;
    function SupportsCatalogsInProcedureCalls: Boolean;
    function SupportsCatalogsInTableDefinitions: Boolean;
    function SupportsCatalogsInIndexDefinitions: Boolean;
    function SupportsCatalogsInPrivilegeDefinitions: Boolean;
    function SupportsPositionedDelete: Boolean;
    function SupportsPositionedUpdate: Boolean;
    function SupportsSelectForUpdate: Boolean;
    function SupportsStoredProcedures: Boolean;
    function SupportsSubqueriesInComparisons: Boolean;
    function SupportsSubqueriesInExists: Boolean;
    function SupportsSubqueriesInIns: Boolean;
    function SupportsSubqueriesInQuantifieds: Boolean;
    function SupportsCorrelatedSubqueries: Boolean;
    function SupportsUnion: Boolean;
    function SupportsUnionAll: Boolean;
    function SupportsOpenCursorsAcrossCommit: Boolean;
    function SupportsOpenCursorsAcrossRollback: Boolean;
    function SupportsOpenStatementsAcrossCommit: Boolean;
    function SupportsOpenStatementsAcrossRollback: Boolean;

    function GetMaxBinaryLiteralLength: Integer;
    function GetMaxCharLiteralLength: Integer;
    function GetMaxColumnNameLength: Integer;
    function GetMaxColumnsInGroupBy: Integer;
    function GetMaxColumnsInIndex: Integer;
    function GetMaxColumnsInOrderBy: Integer;
    function GetMaxColumnsInSelect: Integer;
    function GetMaxColumnsInTable: Integer;
    function GetMaxConnections: Integer;
    function GetMaxCursorNameLength: Integer;
    function GetMaxIndexLength: Integer;
    function GetMaxSchemaNameLength: Integer;
    function GetMaxProcedureNameLength: Integer;
    function GetMaxCatalogNameLength: Integer;
    function GetMaxRowSize: Integer;
    function DoesMaxRowSizeIncludeBlobs: Boolean;
    function GetMaxStatementLength: Integer;
    function GetMaxStatements: Integer;
    function GetMaxTableNameLength: Integer;
    function GetMaxTablesInSelect: Integer;
    function GetMaxUserNameLength: Integer;

    function GetDefaultTransactionIsolation: TZTransactIsolationLevel;
    function SupportsTransactions: Boolean;
    function SupportsTransactionIsolationLevel(Level: TZTransactIsolationLevel):
      Boolean;
    function SupportsDataDefinitionAndDataManipulationTransactions: Boolean;
    function SupportsDataManipulationTransactionsOnly: Boolean;
    function DataDefinitionCausesTransactionCommit: Boolean;
    function DataDefinitionIgnoredInTransactions: Boolean;

    function GetProcedures(const Catalog: AnsiString; const SchemaPattern: AnsiString;
      const ProcedureNamePattern: AnsiString): IZResultSet;
    function GetProcedureColumns(const Catalog: AnsiString; const SchemaPattern: AnsiString;
      const ProcedureNamePattern: AnsiString; const ColumnNamePattern: AnsiString): IZResultSet;

    function GetTables(const Catalog: AnsiString; const SchemaPattern: AnsiString;
      const TableNamePattern: AnsiString; const Types: TStringDynArray): IZResultSet;
    function GetSchemas: IZResultSet;
    function GetCatalogs: IZResultSet;
    function GetTableTypes: IZResultSet;
    function GetColumns(const Catalog: AnsiString; const SchemaPattern: AnsiString;
      const TableNamePattern: AnsiString; const ColumnNamePattern: AnsiString): IZResultSet;
    function GetColumnPrivileges(const Catalog: AnsiString; const Schema: AnsiString;
      const Table: AnsiString; const ColumnNamePattern: AnsiString): IZResultSet;

    function GetTablePrivileges(const Catalog: AnsiString; const SchemaPattern: AnsiString;
      const TableNamePattern: AnsiString): IZResultSet;
    function GetBestRowIdentifier(const Catalog: AnsiString; const Schema: AnsiString;
      const Table: AnsiString; Scope: Integer; Nullable: Boolean): IZResultSet;
    function GetVersionColumns(const Catalog: AnsiString; const Schema: AnsiString;
      const Table: AnsiString): IZResultSet;

    function GetPrimaryKeys(const Catalog: AnsiString; const Schema: AnsiString;
      const Table: AnsiString): IZResultSet;
    function GetImportedKeys(const Catalog: AnsiString; const Schema: AnsiString;
      const Table: AnsiString): IZResultSet;
    function GetExportedKeys(const Catalog: AnsiString; const Schema: AnsiString;
      const Table: AnsiString): IZResultSet;
    function GetCrossReference(const PrimaryCatalog: AnsiString; const PrimarySchema: AnsiString;
      const PrimaryTable: AnsiString; const ForeignCatalog: AnsiString; const ForeignSchema: AnsiString;
      const ForeignTable: AnsiString): IZResultSet;

    function GetTypeInfo: IZResultSet;

    function GetIndexInfo(const Catalog: AnsiString; const Schema: AnsiString; const Table: AnsiString;
      Unique: Boolean; Approximate: Boolean): IZResultSet;

    function GetSequences(const Catalog: AnsiString; const SchemaPattern: AnsiString;
      const SequenceNamePattern: AnsiString): IZResultSet;

    function SupportsResultSetType(_Type: TZResultSetType): Boolean;
    function SupportsResultSetConcurrency(_Type: TZResultSetType;
      Concurrency: TZResultSetConcurrency): Boolean;
    function SupportsBatchUpdates: Boolean;

    function GetUDTs(const Catalog: AnsiString; const SchemaPattern: AnsiString;
      const TypeNamePattern: AnsiString; const Types: TIntegerDynArray): IZResultSet;

    function GetConnection: IZConnection;
    function GetIdentifierConvertor: IZIdentifierConvertor;

    procedure ClearCache;overload;
	procedure ClearCache(const Key: AnsiString);overload;

    function AddEscapeCharToWildcards(const Pattern:AnsiString): AnsiString;
	end;

  {** Generic SQL statement interface. }
  IZStatement = interface(IZInterface)
    ['{22CEFA7E-6A6D-48EC-BB9B-EE66056E90F1}']

    function ExecuteQuery(const SQL: AnsiString): IZResultSet;
    function ExecuteUpdate(const SQL: AnsiString): Integer;
    procedure Close;

    function GetMaxFieldSize: Integer;
    procedure SetMaxFieldSize(Value: Integer);
    function GetMaxRows: Integer;
    procedure SetMaxRows(Value: Integer);
    procedure SetEscapeProcessing(Value: Boolean);
    function GetQueryTimeout: Integer;
    procedure SetQueryTimeout(Value: Integer);
    procedure Cancel;
    procedure SetCursorName(const Value: AnsiString);

    function Execute(const SQL: AnsiString): Boolean;
    function GetResultSet: IZResultSet;
    function GetUpdateCount: Integer;
    function GetMoreResults: Boolean;

    procedure SetFetchDirection(Value: TZFetchDirection);
    function GetFetchDirection: TZFetchDirection;
    procedure SetFetchSize(Value: Integer);
    function GetFetchSize: Integer;

    procedure SetResultSetConcurrency(Value: TZResultSetConcurrency);
    function GetResultSetConcurrency: TZResultSetConcurrency;
    procedure SetResultSetType(Value: TZResultSetType);
    function GetResultSetType: TZResultSetType;

    procedure SetPostUpdates(Value: TZPostUpdatesMode);
    function GetPostUpdates: TZPostUpdatesMode;
    procedure SetLocateUpdates(Value: TZLocateUpdatesMode);
    function GetLocateUpdates: TZLocateUpdatesMode;

    procedure AddBatch(const SQL: AnsiString);
    procedure ClearBatch;
    function ExecuteBatch: TIntegerDynArray;

    function GetConnection: IZConnection;
    function GetParameters: TStrings;

    function GetWarnings: EZSQLWarning;
    procedure ClearWarnings;
  end;

  {** Prepared SQL statement interface. }
  IZPreparedStatement = interface(IZStatement)
    ['{990B8477-AF11-4090-8821-5B7AFEA9DD70}']

    function ExecuteQueryPrepared: IZResultSet;
    function ExecuteUpdatePrepared: Integer;
    function ExecuteUpdatePreparedGS(keys:AnsiString): Integer;
    function ExecutePrepared: Boolean;

    procedure SetDefaultValue(ParameterIndex: Integer; const Value: AnsiString);

    procedure SetNull(ParameterIndex: Integer; SQLType: TZSQLType);
    procedure SetBoolean(ParameterIndex: Integer; Value: Boolean);
    procedure SetByte(ParameterIndex: Integer; Value: ShortInt);
    procedure SetShort(ParameterIndex: Integer; Value: SmallInt);
    procedure SetInt(ParameterIndex: Integer; Value: Integer);
    procedure SetLong(ParameterIndex: Integer; Value: Int64);
    procedure SetFloat(ParameterIndex: Integer; Value: Single);
    procedure SetDouble(ParameterIndex: Integer; Value: Double);
    procedure SetBigDecimal(ParameterIndex: Integer; Value: Extended);
    procedure SetPChar(ParameterIndex: Integer; Value: PAnsiChar);
    procedure SetString(ParameterIndex: Integer; const Value: AnsiString);
    procedure SetUnicodeString(ParameterIndex: Integer; const Value: WideString);
    procedure SetBytes(ParameterIndex: Integer; const Value: TByteDynArray);
    procedure SetDate(ParameterIndex: Integer; Value: TDateTime);
    procedure SetTime(ParameterIndex: Integer; Value: TDateTime);
    procedure SetTimestamp(ParameterIndex: Integer; Value: TDateTime);
    procedure SetAsciiStream(ParameterIndex: Integer; Value: TStream);
    procedure SetUnicodeStream(ParameterIndex: Integer; Value: TStream);
    procedure SetBinaryStream(ParameterIndex: Integer; Value: TStream);
    procedure SetBlob(ParameterIndex: Integer; SQLType: TZSQLType;
      Value: IZBlob);
    procedure SetValue(ParameterIndex: Integer; const Value: TZVariant);

    procedure ClearParameters;

    procedure AddBatchPrepared;
    function GetMetadata: IZResultSetMetadata;
  end;

  {** Callable SQL statement interface. }
  IZCallableStatement = interface(IZPreparedStatement)
    ['{E6FA6C18-C764-4C05-8FCB-0582BDD1EF40}']

    procedure RegisterOutParameter(ParameterIndex: Integer; SQLType: Integer);
    function WasNull: Boolean;

    function IsNull(ParameterIndex: Integer): Boolean;
    function GetPChar(ParameterIndex: Integer): PAnsiChar;
    function GetString(ParameterIndex: Integer): AnsiString;
    function GetUnicodeString(ParameterIndex: Integer): WideString;
    function GetBoolean(ParameterIndex: Integer): Boolean;
    function GetByte(ParameterIndex: Integer): ShortInt;
    function GetShort(ParameterIndex: Integer): SmallInt;
    function GetInt(ParameterIndex: Integer): Integer;
    function GetLong(ParameterIndex: Integer): Int64;
    function GetFloat(ParameterIndex: Integer): Single;
    function GetDouble(ParameterIndex: Integer): Double;
    function GetBigDecimal(ParameterIndex: Integer): Extended;
    function GetBytes(ParameterIndex: Integer): TByteDynArray;
    function GetDate(ParameterIndex: Integer): TDateTime;
    function GetTime(ParameterIndex: Integer): TDateTime;
    function GetTimestamp(ParameterIndex: Integer): TDateTime;
    function GetValue(ParameterIndex: Integer): TZVariant;
  end;

  {** Rows returned by SQL query. }
  IZResultSet = interface(IZInterface)
    ['{8F4C4D10-2425-409E-96A9-7142007CC1B2}']

    function Next: Boolean;
    procedure Close;
    function WasNull: Boolean;

    //======================================================================
    // Methods for accessing results by column index
    //======================================================================

    function IsNull(ColumnIndex: Integer): Boolean;
    function GetPChar(ColumnIndex: Integer): PAnsiChar;
    function GetString(ColumnIndex: Integer): AnsiString;
    function GetUnicodeString(ColumnIndex: Integer): WideString;
    function GetBoolean(ColumnIndex: Integer): Boolean;
    function GetByte(ColumnIndex: Integer): ShortInt;
    function GetShort(ColumnIndex: Integer): SmallInt;
    function GetInt(ColumnIndex: Integer): Integer;
    function GetLong(ColumnIndex: Integer): Int64;
    function GetFloat(ColumnIndex: Integer): Single;
    function GetDouble(ColumnIndex: Integer): Double;
    function GetBigDecimal(ColumnIndex: Integer): Extended;
    function GetBytes(ColumnIndex: Integer): TByteDynArray;
    function GetDate(ColumnIndex: Integer): TDateTime;
    function GetTime(ColumnIndex: Integer): TDateTime;
    function GetTimestamp(ColumnIndex: Integer): TDateTime;
    function GetAsciiStream(ColumnIndex: Integer): TStream;
    function GetUnicodeStream(ColumnIndex: Integer): TStream;
    function GetBinaryStream(ColumnIndex: Integer): TStream;
    function GetBlob(ColumnIndex: Integer): IZBlob;
    function GetValue(ColumnIndex: Integer): TZVariant;

    //======================================================================
    // Methods for accessing results by column name
    //======================================================================

    function IsNullByName(const ColumnName: AnsiString): Boolean;
    function GetPCharByName(const ColumnName: AnsiString): PAnsiChar;
    function GetStringByName(const ColumnName: AnsiString): AnsiString;
    function GetUnicodeStringByName(const ColumnName: AnsiString): WideString;
    function GetBooleanByName(const ColumnName: AnsiString): Boolean;
    function GetByteByName(const ColumnName: AnsiString): ShortInt;
    function GetShortByName(const ColumnName: AnsiString): SmallInt;
    function GetIntByName(const ColumnName: AnsiString): Integer;
    function GetLongByName(const ColumnName: AnsiString): Int64;
    function GetFloatByName(const ColumnName: AnsiString): Single;
    function GetDoubleByName(const ColumnName: AnsiString): Double;
    function GetBigDecimalByName(const ColumnName: AnsiString): Extended;
    function GetBytesByName(const ColumnName: AnsiString): TByteDynArray;
    function GetDateByName(const ColumnName: AnsiString): TDateTime;
    function GetTimeByName(const ColumnName: AnsiString): TDateTime;
    function GetTimestampByName(const ColumnName: AnsiString): TDateTime;
    function GetAsciiStreamByName(const ColumnName: AnsiString): TStream;
    function GetUnicodeStreamByName(const ColumnName: AnsiString): TStream;
    function GetBinaryStreamByName(const ColumnName: AnsiString): TStream;
    function GetBlobByName(const ColumnName: AnsiString): IZBlob;
    function GetValueByName(const ColumnName: AnsiString): TZVariant;

    //=====================================================================
    // Advanced features:
    //=====================================================================

    function GetWarnings: EZSQLWarning;
    procedure ClearWarnings;

    function GetCursorName: AnsiString;
    function GetMetadata: IZResultSetMetadata;
    function FindColumn(const ColumnName: AnsiString): Integer;
    
    //---------------------------------------------------------------------
    // Traversal/Positioning
    //---------------------------------------------------------------------

    function IsBeforeFirst: Boolean;
    function IsAfterLast: Boolean;
    function IsFirst: Boolean;
    function IsLast: Boolean;
    procedure BeforeFirst;
    procedure AfterLast;
    function First: Boolean;
    function Last: Boolean;
    function GetRow: Integer;
    function MoveAbsolute(Row: Integer): Boolean;
    function MoveRelative(Rows: Integer): Boolean;
    function Previous: Boolean;

    //---------------------------------------------------------------------
    // Properties
    //---------------------------------------------------------------------

    procedure SetFetchDirection(Value: TZFetchDirection);
    function GetFetchDirection: TZFetchDirection;

    procedure SetFetchSize(Value: Integer);
    function GetFetchSize: Integer;

    function GetType: TZResultSetType;
    function GetConcurrency: TZResultSetConcurrency;

    function GetPostUpdates: TZPostUpdatesMode;
    function GetLocateUpdates: TZLocateUpdatesMode;

    //---------------------------------------------------------------------
    // Updates
    //---------------------------------------------------------------------

    function RowUpdated: Boolean;
    function RowInserted: Boolean;
    function RowDeleted: Boolean;

    procedure UpdateNull(ColumnIndex: Integer);
    procedure UpdateBoolean(ColumnIndex: Integer; Value: Boolean);
    procedure UpdateByte(ColumnIndex: Integer; Value: ShortInt);
    procedure UpdateShort(ColumnIndex: Integer; Value: SmallInt);
    procedure UpdateInt(ColumnIndex: Integer; Value: Integer);
    procedure UpdateLong(ColumnIndex: Integer; Value: Int64);
    procedure UpdateFloat(ColumnIndex: Integer; Value: Single);
    procedure UpdateDouble(ColumnIndex: Integer; Value: Double);
    procedure UpdateBigDecimal(ColumnIndex: Integer; Value: Extended);
    procedure UpdatePChar(ColumnIndex: Integer; Value: PAnsiChar);
    procedure UpdateString(ColumnIndex: Integer; const Value: AnsiString);
    procedure UpdateUnicodeString(ColumnIndex: Integer; const Value: WideString);
    procedure UpdateBytes(ColumnIndex: Integer; const Value: TByteDynArray);
    procedure UpdateDate(ColumnIndex: Integer; Value: TDateTime);
    procedure UpdateTime(ColumnIndex: Integer; Value: TDateTime);
    procedure UpdateTimestamp(ColumnIndex: Integer; Value: TDateTime);
    procedure UpdateAsciiStream(ColumnIndex: Integer; Value: TStream);
    procedure UpdateUnicodeStream(ColumnIndex: Integer; Value: TStream);
    procedure UpdateBinaryStream(ColumnIndex: Integer; Value: TStream);
    procedure UpdateValue(ColumnIndex: Integer; const Value: TZVariant);

    //======================================================================
    // Methods for accessing results by column name
    //======================================================================

    procedure UpdateNullByName(const ColumnName: AnsiString);
    procedure UpdateBooleanByName(const ColumnName: AnsiString; Value: Boolean);
    procedure UpdateByteByName(const ColumnName: AnsiString; Value: ShortInt);
    procedure UpdateShortByName(const ColumnName: AnsiString; Value: SmallInt);
    procedure UpdateIntByName(const ColumnName: AnsiString; Value: Integer);
    procedure UpdateLongByName(const ColumnName: AnsiString; Value: Int64);
    procedure UpdateFloatByName(const ColumnName: AnsiString; Value: Single);
    procedure UpdateDoubleByName(const ColumnName: AnsiString; Value: Double);
    procedure UpdateBigDecimalByName(const ColumnName: AnsiString; Value: Extended);
    procedure UpdatePCharByName(const ColumnName: AnsiString; Value: PAnsiChar);
    procedure UpdateStringByName(const ColumnName: AnsiString; const Value: AnsiString);
    procedure UpdateUnicodeStringByName(const ColumnName: AnsiString; const Value: WideString);
    procedure UpdateBytesByName(const ColumnName: AnsiString; const Value: TByteDynArray);
    procedure UpdateDateByName(const ColumnName: AnsiString; Value: TDateTime);
    procedure UpdateTimeByName(const ColumnName: AnsiString; Value: TDateTime);
    procedure UpdateTimestampByName(const ColumnName: AnsiString; Value: TDateTime);
    procedure UpdateAsciiStreamByName(const ColumnName: AnsiString; Value: TStream);
    procedure UpdateUnicodeStreamByName(const ColumnName: AnsiString; Value: TStream);
    procedure UpdateBinaryStreamByName(const ColumnName: AnsiString; Value: TStream);
    procedure UpdateValueByName(const ColumnName: AnsiString; const Value: TZVariant);

    procedure InsertRow;
    procedure UpdateRow;
    procedure UpdateRowGS(keys: AnsiString);
    procedure DeleteRow;
    procedure RefreshRow;
    procedure CancelRowUpdates;
    procedure MoveToInsertRow;
    procedure MoveToCurrentRow;
//    procedure MoveToSearchRow;

//    function Search(CaseInsensitive, PartialKey: Boolean): Boolean;
//    function Compare(Row: Integer; CaseInsensitive, PartialKey: Boolean):
//      Boolean;

    function CompareRows(Row1, Row2: Integer; const ColumnIndices: TIntegerDynArray;
      const ColumnDirs: TBooleanDynArray): Integer;

    function GetStatement: IZStatement;
  end;

  {** ResultSet metadata interface. }
  IZResultSetMetadata = interface(IZInterface)
    ['{47CA2144-2EA7-42C4-8444-F5154369B2D7}']

    function GetColumnCount: Integer;
    function IsAutoIncrement(Column: Integer): Boolean;
    function IsCaseSensitive(Column: Integer): Boolean;
    function IsSearchable(Column: Integer): Boolean;
    function IsCurrency(Column: Integer): Boolean;
    function IsNullable(Column: Integer): TZColumnNullableType;

    function IsSigned(Column: Integer): Boolean;
    function GetColumnDisplaySize(Column: Integer): Integer;
    function GetColumnLabel(Column: Integer): AnsiString;
    function GetColumnName(Column: Integer): AnsiString;
    function GetSchemaName(Column: Integer): AnsiString;
    function GetPrecision(Column: Integer): Integer;
    function GetScale(Column: Integer): Integer;
    function GetTableName(Column: Integer): AnsiString;
    function GetCatalogName(Column: Integer): AnsiString;
    function GetColumnType(Column: Integer): TZSQLType;
    function GetColumnTypeName(Column: Integer): AnsiString;
    function IsReadOnly(Column: Integer): Boolean;
    function IsWritable(Column: Integer): Boolean;
    function IsDefinitelyWritable(Column: Integer): Boolean;
    function GetDefaultValue(Column: Integer): AnsiString;
    function HasDefaultValue(Column: Integer): Boolean;
  end;

  {** External or internal blob wrapper object. }
  IZBlob = interface(IZInterface)
    ['{47D209F1-D065-49DD-A156-EFD1E523F6BF}']

    function IsEmpty: Boolean;
    function IsUpdated: Boolean;
    function Length: LongInt;

    function GetString: AnsiString;
    procedure SetString(const Value: AnsiString);
    function GetUnicodeString: WideString;
    procedure SetUnicodeString(const Value: WideString);
    function GetBytes: TByteDynArray;
    procedure SetBytes(const Value: TByteDynArray);
    function GetStream: TStream;
    procedure SetStream(Value: TStream);

    procedure Clear;
    function Clone: IZBlob;
  end;

  {** Database notification interface. }
  IZNotification = interface(IZInterface)
    ['{BF785C71-EBE9-4145-8DAE-40674E45EF6F}']

    function GetEvent: AnsiString;
    procedure Listen;
    procedure Unlisten;
    procedure DoNotify;
    function CheckEvents: AnsiString;

    function GetConnection: IZConnection;
  end;

  {** Database sequence generator interface. }
  IZSequence = interface(IZInterface)
    ['{A9A54FE5-0DBE-492F-8DA6-04AC5FCE779C}']
    function  GetName: AnsiString;
    function  GetBlockSize: Integer;
    procedure SetName(const Value: AnsiString);
    procedure SetBlockSize(const Value: Integer);
    function  GetCurrentValue: Int64;
    function  GetNextValue: Int64;
    function  GetCurrentValueSQL: AnsiString;
    function  GetNextValueSQL: AnsiString;
    function  GetConnection: IZConnection;
  end;

var
  {** The common driver manager object. }
  DriverManager: IZDriverManager;

implementation

uses ZMessages;

type
  {** Driver Manager interface. }
  TZDriverManager = class(TInterfacedObject, IZDriverManager)
  private
    FDrivers: IZCollection;
    FLoginTimeout: Integer;
    FLoggingListeners: IZCollection;
  public
    constructor Create;
    destructor Destroy; override;

    function GetConnection(const Url: AnsiString): IZConnection;
    function GetConnectionWithParams(const Url: AnsiString; Info: TStrings): IZConnection;
    function GetConnectionWithLogin(const Url: AnsiString; const User: AnsiString;
      const Password: AnsiString): IZConnection;

    function GetDriver(const Url: AnsiString): IZDriver;
    procedure RegisterDriver(Driver: IZDriver);
    procedure DeregisterDriver(Driver: IZDriver);

    function GetDrivers: IZCollection;

    function GetClientVersion(const Url: AnsiString): Integer;

    function GetLoginTimeout: Integer;
    procedure SetLoginTimeout(Value: Integer);

    procedure AddLoggingListener(Listener: IZLoggingListener);
    procedure RemoveLoggingListener(Listener: IZLoggingListener);

    procedure LogMessage(Category: TZLoggingCategory; const Protocol: AnsiString;
      const Msg: AnsiString);
    procedure LogError(Category: TZLoggingCategory; const Protocol: AnsiString;
      const Msg: AnsiString; ErrorCode: Integer; const Error: AnsiString);
  end;

{ TZDriverManager }

{**
  Constructs this object with default properties.
}
constructor TZDriverManager.Create;
begin
  FDrivers := TZCollection.Create;
  FLoginTimeout := 0;
  FLoggingListeners := TZCollection.Create;
end;

{**
  Destroys this object and cleanups the memory.
}
destructor TZDriverManager.Destroy;
begin
  FDrivers := nil;
  FLoggingListeners := nil;
  inherited Destroy;
end;

{**
  Gets a collection of registered drivers.
  @return an unmodifiable collection with registered drivers.
}
function TZDriverManager.GetDrivers: IZCollection;
begin
  Result := TZUnmodifiableCollection.Create(FDrivers);
end;

{**
  Gets a login timeout value.
  @return a login timeout.
}
function TZDriverManager.GetLoginTimeout: Integer;
begin
  Result := FLoginTimeout;
end;

{**
  Sets a new login timeout value.
  @param Seconds a new login timeout in seconds.
}
procedure TZDriverManager.SetLoginTimeout(Value: Integer);
begin
  FLoginTimeout := Value;
end;

{**
  Registers a driver for specific database.
  @param Driver a driver to be registered.
}
procedure TZDriverManager.RegisterDriver(Driver: IZDriver);
begin
  if not FDrivers.Contains(Driver) then
    FDrivers.Add(Driver);
end;

{**
  Unregisters a driver for specific database.
  @param Driver a driver to be unregistered.
}
procedure TZDriverManager.DeregisterDriver(Driver: IZDriver);
begin
  FDrivers.Remove(Driver);
end;

{**
  Gets a driver which accepts the specified url.
  @param Url a database connection url.
  @return a found driver or <code>null</code> otherwise.
}
function TZDriverManager.GetDriver(const Url: AnsiString): IZDriver;
var
  I: Integer;
  Current: IZDriver;
begin
  Result := nil;
  for I := 0 to FDrivers.Count - 1 do
  begin
    Current := FDrivers[I] as IZDriver;
    if Current.AcceptsURL(Url) then
    begin
      Result := Current;
      Break;
    end;
  end;
end;

{**
  Locates a required driver and opens a connection to the specified database.
  @param Url a database connection Url.
  @param Info an extra connection parameters.
  @return an opened connection.
}
function TZDriverManager.GetConnectionWithParams(const Url: AnsiString; Info: TStrings):
  IZConnection;
var
  Driver: IZDriver;
begin
  Driver := GetDriver(Url);
  if Driver = nil then
    raise EZSQLException.Create(SDriverWasNotFound);
  Result := Driver.Connect(Url, Info);
end;

{**
  Locates a required driver and returns the client library version number.
  @param Url a database connection Url.
  @return client library version number.
}
function TZDriverManager.GetClientVersion(const Url: AnsiString): Integer;
var
  Driver: IZDriver;
begin
  Driver := GetDriver(Url);
  if Driver = nil then
    raise EZSQLException.Create(SDriverWasNotFound);
  Result := Driver.GetClientVersion(Url);
end;

{**
  Locates a required driver and opens a connection to the specified database.
  @param Url a database connection Url.
  @param User a user's name.
  @param Password a user's password.
  @return an opened connection.
}
function TZDriverManager.GetConnectionWithLogin(const Url: AnsiString; const User: AnsiString;
  const Password: AnsiString): IZConnection;
var
  Info: TStrings;
begin
  Info := TStringList.Create;
  try
    Info.Add('username=' + User);
    Info.Add('password=' + Password);
    Result := GetConnectionWithParams(Url, Info);
  finally
    Info.Free;
  end;
end;

{**
  Locates a required driver and opens a connection to the specified database.
  @param Url a database connection Url.
  @return an opened connection.
}
function TZDriverManager.GetConnection(const Url: AnsiString): IZConnection;
begin
  Result := GetConnectionWithParams(Url, nil);
end;

{**
  Adds a logging listener to log SQL events.
  @param Listener a logging interface to be added.
}
procedure TZDriverManager.AddLoggingListener(Listener: IZLoggingListener);
begin
  FLoggingListeners.Add(Listener);
end;

{**
  Removes a logging listener from the list.
  @param Listener a logging interface to be removed.
}
procedure TZDriverManager.RemoveLoggingListener(Listener: IZLoggingListener);
begin
  FLoggingListeners.Remove(Listener);
end;

{**
  Logs a message about event with error result code.
  @param Category a category of the message.
  @param Protocol a name of the protocol.
  @param Msg a description message.
  @param ErrorCode an error code.
  @param Error an error message.
}
procedure TZDriverManager.LogError(Category: TZLoggingCategory;
  const Protocol: AnsiString; const Msg: AnsiString; ErrorCode: Integer; const Error: AnsiString);
var
  I: Integer;
  Listener: IZLoggingListener;
  Event: TZLoggingEvent;
begin
  if FLoggingListeners.Count = 0 then Exit;
  Event := TZLoggingEvent.Create(Category, Protocol, Msg, ErrorCode, Error);
  try
    for I := 0 to FLoggingListeners.Count - 1 do
    begin
      Listener := FLoggingListeners[I] as IZLoggingListener;
      try
        Listener.LogEvent(Event);
      except
      end;
    end;
  finally
    Event.Destroy;
  end;
end;

{**
  Logs a message about event with normal result code.
  @param Category a category of the message.
  @param Protocol a name of the protocol.
  @param Msg a description message.
}
procedure TZDriverManager.LogMessage(Category: TZLoggingCategory;
  const Protocol: AnsiString; const Msg: AnsiString);
begin
  if FLoggingListeners.Count = 0 then Exit;
  LogError(Category, Protocol, Msg, 0, '');
end;

{ EZSQLThrowable }

{**
  Creates an exception with message AnsiString.
  @param Msg a error description.
}
constructor EZSQLThrowable.CreateClone(const E: EZSQLThrowable);
begin
  inherited Create(E.Message);
  FErrorCode:=E.ErrorCode;
  FStatusCode:=E.Statuscode;
end;

constructor EZSQLThrowable.Create(const Msg: AnsiString);
begin
  inherited Create(Msg);
  FErrorCode := -1;
end;

{**
  Creates an exception with message AnsiString.
  @param Msg a error description.
  @param ErrorCode a native server error code.
}
constructor EZSQLThrowable.CreateWithCode(const ErrorCode: Integer;
  const Msg: AnsiString);
begin
  inherited Create(Msg);
  FErrorCode := ErrorCode;
end;

constructor EZSQLThrowable.CreateWithStatus(const StatusCode, Msg: AnsiString);
begin
  inherited Create(Msg);
  FStatusCode := StatusCode;
end;

initialization
  DriverManager := TZDriverManager.Create;
finalization
  DriverManager := nil;
end.

