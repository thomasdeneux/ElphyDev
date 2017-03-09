unit DBCache;

interface
    uses
        DBModels,
        DBManagers,
        DBQuerySets,
        DBObjects,
        stmDatabase2,
        ZDbcIntfs,
        Classes;

    var
        anTypeModel,anModel,ioModel,potModel,subpotModel_bool,subpotModel_int,subpotModel_float,subpotModel_str,inputModel,outputModel:TDBModel;
        anTypeManager,anManager,ioManager,potManager,subpotManager_bool,subpotManager_int,subpotManager_float,subpotManager_str,inputManager,outputManager:TDBManager;
        LAST_ANALYSES_CONSTRUCT,LAST_ANALYSES_SELECT,LAST_ANALYSES_WHERE:String;
        all_fields:TStringList;
        DBCONNECTION:TDBConnection;
    
implementation

initialization

end.
 