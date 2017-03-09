unit DBCache;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
    uses
        DBModels,
        DBManagers,
        DBQuerySets,
        DBObjects,
        stmDatabase2,
        ZDbcIntfs,
        Classes,
        debug0;

    var
        anTypeModel,anModel,ioModel,potModel,subpotModel_bool,subpotModel_int,subpotModel_float,subpotModel_str,inputModel,outputModel:TDBModel;
        anTypeManager,anManager,ioManager,potManager,subpotManager_bool,subpotManager_int,subpotManager_float,subpotManager_str,inputManager,outputManager:TDBManager;
        LAST_ANALYSES_CONSTRUCT,LAST_ANALYSES_SELECT,LAST_ANALYSES_WHERE:String;
        all_fields:TStringList;
        DBCONNECTION:TDBConnection;
    
implementation

Initialization
AffDebug('Initialization DBCache',0);

end.
 
