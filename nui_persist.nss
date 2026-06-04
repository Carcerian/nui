#include "nui_api"
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::      _____                     _          _        
//::     / ___/__ ____________ ____(_)__ ____ ( )___    
//::    / /__/ _ `/ __/ __/ -_) __/ / _ `/ _ \|/(_-<    
//::    \___/\_,_/_/  \__/\__/_/ /_/\_,_/_//_/ /___/    
//::         _  ____  ______    ___   ___  ____         
//::        / |/ / / / /  _/   / _ | / _ \/  _/         
//::       /    / /_/ // /    / __ |/ ___// /           
//::      /_/|_/\____/___/   /_/ |_/_/  /___/           
//::                                                     
//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - Persistent Settings Manager
//:: nui_persist.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////
//::///////////////////////////////////////////////////////////////////////

/* ==================================================================== */
/*  PUBLIC NUI_* FUNCTION DECLARATIONS                                 */
/* ==================================================================== */


/*
    SYNOPSIS
        Unified persistence layer for NUI system settings. Supports both
        NWN:EE campaign database (SQLite) and optional MySQL backend.
        Choose backend at compile-time; provides identical interface for both.

    DEPENDENCIES
        nui_api.nss (compile-time flags only)

    VARIABLES
        VAR_PERSIST_BACKEND - "campaign" or "mysql" (set at top of file)
        VAR_PERSIST_DEBUG - 0/1 (enable debug output)
        PERSIST_TABLE_PREFIX - custom prefix for database tables

    USAGE
        1. Set PERSIST_BACKEND to "campaign" or "mysql" at compile time
        2. If "mysql", configure connection strings below
        3. Call NUI_PersistInit() once at module load
        4. Call NUI_PersistSave(oPC, key, value) to save
        5. Call NUI_PersistLoad(oPC, key) to load

    EXAMPLE (Campaign Database)
        const string PERSIST_BACKEND = "campaign";

        void OnModuleLoad() {
            NUI_PersistInit();  // Initialize (one time)
        }

        void OnBodyAdjustApply(object oPC) {
            float fHeadX = GetLocalFloat(oPC, "head_x");
            NUI_PersistSave(oPC, "body_head_x", fHeadX);
        }

        void OnCharLoad(object oPC) {
            float fHeadX = NUI_PersistLoadFloat(oPC, "body_head_x", 0.0);
            SetLocalFloat(oPC, "head_x", fHeadX);
        }

    EXAMPLE (MySQL Backend)
        const string PERSIST_BACKEND = "mysql";
        const string MYSQL_HOST = "localhost";
        const string MYSQL_USER = "nwn_user";
        const string MYSQL_PASS = "password";
        const string MYSQL_DB   = "nwn_server";

        void OnModuleLoad() {
            NUI_PersistInit();  // Initialize (connects to MySQL)
        }

        void OnBodyAdjustApply(object oPC) {
            float fHeadX = GetLocalFloat(oPC, "head_x");
            NUI_PersistSave(oPC, "body_head_x", fHeadX);  // Same call
        }

================================================================================
*/

//::///////////////////////////////////////////////////////////////////////
//:: CONFIGURATION - SET AT COMPILE TIME
//::///////////////////////////////////////////////////////////////////////

// Backend selection: "campaign" or "mysql"
const string PERSIST_BACKEND = "campaign";

// If using MySQL, set connection details here
const string MYSQL_HOST = "localhost";
const int MYSQL_PORT = 3306;
const string MYSQL_USER = "nwn_user";
const string MYSQL_PASS = "password";
const string MYSQL_DB = "nwn_server";

// Optional: Custom table prefix (e.g., "myserver_" for tables like myserver_nui_settings)
const string PERSIST_TABLE_PREFIX = "nui_";

// Debug flag
const int PERSIST_DEBUG = 0;

// Max string length for database values (MySQL: keep under 255 for VARCHAR)
const int PERSIST_MAX_STRING = 250;

// Database version (bump if schema changes)
const int PERSIST_SCHEMA_VERSION = 1;

//::///////////////////////////////////////////////////////////////////////
//:: INTERNAL - DO NOT MODIFY
//::///////////////////////////////////////////////////////////////////////

// Table names (campaign DB uses these as variable keys)
const string PERSIST_TABLE_SETTINGS = PERSIST_TABLE_PREFIX + "settings";
const string PERSIST_TABLE_METADATA = PERSIST_TABLE_PREFIX + "metadata";

// Campaign DB keys (for storing player data when using campaign backend)
const string VAR_PERSIST_PREFIX = "nui_persist_";

//::///////////////////////////////////////////////////////////////////////
//:: FORWARD DECLARATIONS (required for NWScript compilation)
//::///////////////////////////////////////////////////////////////////////

// Initialization
void NUI_PersistInitCampaign();
void NUI_PersistInitMySQL();

// Save Functions
void NUI_PersistSaveCampaign(object oPC, string sKey, string sValue);
void NUI_PersistSaveMySQL(object oPC, string sKey, string sValue);

// Load Functions
string NUI_PersistLoadCampaign(object oPC, string sKey, string sDefault);
string NUI_PersistLoadMySQL(object oPC, string sKey, string sDefault);

// Delete Functions
void NUI_PersistDeleteCampaign(object oPC, string sKey);
void NUI_PersistDeleteMySQL(object oPC, string sKey);
void NUI_PersistDeleteAllCampaign(object oPC);
void NUI_PersistDeleteAllMySQL(object oPC);

//::///////////////////////////////////////////////////////////////////////
//:: DATABASE INITIALIZATION
//::///////////////////////////////////////////////////////////////////////

void NUI_PersistInit() {
    // For now, always use campaign database
    // MySQL support can be added later if needed
    NUI_PersistInitCampaign();
    
    // Future: MySQL support
    // if (PERSIST_BACKEND == "mysql") {
    //     NUI_PersistInitMySQL();
    // }
}

void NUI_PersistInitCampaign() {
    // Campaign database requires no initialization
    // It uses module/player local variables automatically
    if (PERSIST_DEBUG) {
        WriteTimestampedLogEntry("NUI: Persistence backend = CAMPAIGN DATABASE");
    }
}

void NUI_PersistInitMySQL() {
    // MySQL initialization: verify connection, create tables if needed
    // Implementation depends on available MySQL wrapper functions
    // For now, stub that assumes external SQL wrapper is available

    if (PERSIST_DEBUG) {
        WriteTimestampedLogEntry("NUI: Persistence backend = MYSQL (" +
                                MYSQL_HOST + ":" + IntToString(MYSQL_PORT) + ")");
    }

    // TODO: Call to MySQL connection wrapper
    // If your server has custom SQL functions, call them here
    // Example: SQL_Connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB);
}

//::///////////////////////////////////////////////////////////////////////
//:: SAVE FUNCTIONS (Unified Interface)
//::///////////////////////////////////////////////////////////////////////

void NUI_PersistSave(object oPC, string sKey, string sValue) {
    // Always use campaign database for now
    NUI_PersistSaveCampaign(oPC, sKey, sValue);
    
    // Future: Add MySQL support
    // if (PERSIST_BACKEND == "mysql") {
    //     NUI_PersistSaveMySQL(oPC, sKey, sValue);
    // }

    if (PERSIST_DEBUG) {
        WriteTimestampedLogEntry("NUI: Saved " + sKey + " for " +
                                GetName(oPC));
    }
}

void NUI_PersistSaveFloat(object oPC, string sKey, float fValue) {
    NUI_PersistSave(oPC, sKey, FloatToString(fValue));
}

void NUI_PersistSaveInt(object oPC, string sKey, int nValue) {
    NUI_PersistSave(oPC, sKey, IntToString(nValue));
}

void NUI_PersistSaveBool(object oPC, string sKey, int bValue) {
    NUI_PersistSave(oPC, sKey, (bValue ? "1" : "0"));
}

// CAMPAIGN DATABASE BACKEND

void NUI_PersistSaveCampaign(object oPC, string sKey, string sValue) {
    string sCDKey = GetPCPublicCDKey(oPC);
    string sPlayerName = GetName(oPC);
    string sVarName = VAR_PERSIST_PREFIX + sKey;

    // Store on player object (persists via save/load)
    SetLocalString(oPC, sVarName, sValue);

    // Also store in module database for cross-session access
    SetCampaignString(PERSIST_TABLE_SETTINGS, sCDKey + "_" + sPlayerName + "_" + sKey, sValue);
}

// MYSQL DATABASE BACKEND

void NUI_PersistSaveMySQL(object oPC, string sKey, string sValue) {
    string sCDKey = GetPCPublicCDKey(oPC);
    string sPlayerName = GetName(oPC);
    string sTableName = PERSIST_TABLE_SETTINGS;

    // MySQL query: INSERT OR UPDATE
    // Implementation depends on your SQL wrapper
    //
    // Pseudo-code:
    // sql_query = "INSERT INTO " + sTableName +
    //             " (cdkey, player_name, setting_key, value, timestamp)" +
    //             " VALUES ('" + sCDKey + "', '" + sPlayerName + "', '" + sKey + "', '" +
    //             SQLEscape(sValue) + "', NOW())" +
    //             " ON DUPLICATE KEY UPDATE value = '" + SQLEscape(sValue) + "', " +
    //             "timestamp = NOW();";
    // SQL_Execute(sql_query);

    // TODO: Implement MySQL INSERT/UPDATE via your SQL wrapper
}

//::///////////////////////////////////////////////////////////////////////
//:: LOAD FUNCTIONS (Unified Interface)
//::///////////////////////////////////////////////////////////////////////

string NUI_PersistLoad(object oPC, string sKey, string sDefault = "") {
    string sResult;

    // Always use campaign database for now
    sResult = NUI_PersistLoadCampaign(oPC, sKey, sDefault);
    
    // Future: Add MySQL support
    // if (PERSIST_BACKEND == "mysql") {
    //     sResult = NUI_PersistLoadMySQL(oPC, sKey, sDefault);
    // }

    if (PERSIST_DEBUG) {
        WriteTimestampedLogEntry("NUI: Loaded " + sKey + " for " +
                                GetName(oPC) + " = " + sResult);
    }

    return sResult;
}

float NUI_PersistLoadFloat(object oPC, string sKey, float fDefault = 0.0) {
    string sValue = NUI_PersistLoad(oPC, sKey, FloatToString(fDefault));
    return StringToFloat(sValue);
}

int NUI_PersistLoadInt(object oPC, string sKey, int nDefault = 0) {
    string sValue = NUI_PersistLoad(oPC, sKey, IntToString(nDefault));
    return StringToInt(sValue);
}

int NUI_PersistLoadBool(object oPC, string sKey, int bDefault = 0) {
    string sValue = NUI_PersistLoad(oPC, sKey, (bDefault ? "1" : "0"));
    return (sValue == "1" ? 1 : 0);
}

// CAMPAIGN DATABASE BACKEND

string NUI_PersistLoadCampaign(object oPC, string sKey, string sDefault) {
    string sCDKey = GetPCPublicCDKey(oPC);
    string sPlayerName = GetName(oPC);
    string sVarName = VAR_PERSIST_PREFIX + sKey;

    // Try to load from player object first (active session)
    string sValue = GetLocalString(oPC, sVarName);
    if (sValue != "") {
        return sValue;
    }

    // Fall back to campaign database (for cross-session persistence)
    sValue = GetCampaignString(PERSIST_TABLE_SETTINGS,
                              sCDKey + "_" + sPlayerName + "_" + sKey);
    if (sValue != "") {
        return sValue;
    }

    return sDefault;
}

// MYSQL DATABASE BACKEND

string NUI_PersistLoadMySQL(object oPC, string sKey, string sDefault) {
    string sCDKey = GetPCPublicCDKey(oPC);
    string sPlayerName = GetName(oPC);

    // MySQL query: SELECT
    // Pseudo-code:
    // sql_query = "SELECT value FROM " + PERSIST_TABLE_SETTINGS +
    //             " WHERE cdkey = '" + sCDKey + "' AND player_name = '" +
    //             sPlayerName + "' AND setting_key = '" + sKey + "';";
    // result = SQL_Query(sql_query);
    // if (result.rows > 0) return result[0].value;

    // TODO: Implement MySQL SELECT via your SQL wrapper
    // For now, return default
    return sDefault;
}

//::///////////////////////////////////////////////////////////////////////
//:: DELETE FUNCTIONS
//::///////////////////////////////////////////////////////////////////////

void NUI_PersistDelete(object oPC, string sKey) {
    // Always use campaign database for now
    NUI_PersistDeleteCampaign(oPC, sKey);
    
    // Future: Add MySQL support
    // if (PERSIST_BACKEND == "mysql") {
    //     NUI_PersistDeleteMySQL(oPC, sKey);
    // }

    if (PERSIST_DEBUG) {
        WriteTimestampedLogEntry("NUI: Deleted " + sKey + " for " +
                                GetName(oPC));
    }
}

void NUI_PersistDeleteCampaign(object oPC, string sKey) {
    string sCDKey = GetPCPublicCDKey(oPC);
    string sPlayerName = GetName(oPC);
    string sVarName = VAR_PERSIST_PREFIX + sKey;

    DeleteLocalString(oPC, sVarName);
    DeleteCampaignVariable(PERSIST_TABLE_SETTINGS,
                          sCDKey + "_" + sPlayerName + "_" + sKey);
}

void NUI_PersistDeleteMySQL(object oPC, string sKey) {
    string sCDKey = GetPCPublicCDKey(oPC);
    string sPlayerName = GetName(oPC);

    // MySQL query: DELETE
    // Pseudo-code:
    // sql_query = "DELETE FROM " + PERSIST_TABLE_SETTINGS +
    //             " WHERE cdkey = '" + sCDKey + "' AND player_name = '" +
    //             sPlayerName + "' AND setting_key = '" + sKey + "';";
    // SQL_Execute(sql_query);

    // TODO: Implement MySQL DELETE via your SQL wrapper
}

//::///////////////////////////////////////////////////////////////////////
//:: BULK OPERATIONS
//::///////////////////////////////////////////////////////////////////////

void NUI_PersistDeleteAll(object oPC) {
    // Delete all settings for a player
    // Always use campaign database for now
    NUI_PersistDeleteAllCampaign(oPC);
    
    // Future: Add MySQL support
    // if (PERSIST_BACKEND == "mysql") {
    //     NUI_PersistDeleteAllMySQL(oPC);
    // }

    if (PERSIST_DEBUG) {
        WriteTimestampedLogEntry("NUI: Deleted all settings for " +
                                GetName(oPC));
    }
}

void NUI_PersistDeleteAllCampaign(object oPC) {
    string sCDKey = GetPCPublicCDKey(oPC);
    string sPlayerName = GetName(oPC);

    // Clear campaign database entries for this player
    DeleteCampaignVariable(PERSIST_TABLE_SETTINGS,
                          sCDKey + "_" + sPlayerName + "_*");
}

void NUI_PersistDeleteAllMySQL(object oPC) {
    string sCDKey = GetPCPublicCDKey(oPC);
    string sPlayerName = GetName(oPC);

    // MySQL query: DELETE all for player
    // Pseudo-code:
    // sql_query = "DELETE FROM " + PERSIST_TABLE_SETTINGS +
    //             " WHERE cdkey = '" + sCDKey + "' AND player_name = '" +
    //             sPlayerName + "';";
    // SQL_Execute(sql_query);

    // TODO: Implement MySQL bulk delete via your SQL wrapper
}

//::///////////////////////////////////////////////////////////////////////
//:: UTILITY FUNCTIONS
//::///////////////////////////////////////////////////////////////////////

int NUI_PersistExists(object oPC, string sKey) {
    string sValue = NUI_PersistLoad(oPC, sKey, "");
    return (sValue != "" ? 1 : 0);
}

int NUI_PersistKeyExists(object oPC, string sKey) {
    // Alias for NUI_PersistExists
    return NUI_PersistExists(oPC, sKey);
}

void NUI_PersistDebug(int bEnable) {
    // Runtime debug toggle (if compiled with PERSIST_DEBUG = 1)
    if (bEnable) {
        WriteTimestampedLogEntry("NUI: Persistence debug enabled");
    }
}

//::///////////////////////////////////////////////////////////////////////
//:: INTEGRATION EXAMPLES
//::///////////////////////////////////////////////////////////////////////

/*
EXAMPLE 1: Save Body Adjustment Settings

    void SaveBodyAdjustment(object oPC) {
        float fHeadX = GetLocalFloat(oPC, VAR_HEAD_X);
        float fHeadY = GetLocalFloat(oPC, VAR_HEAD_Y);
        float fHeadZ = GetLocalFloat(oPC, VAR_HEAD_Z);
        float fHeadScale = GetLocalFloat(oPC, VAR_HEAD_SCALE);

        NUI_PersistSaveFloat(oPC, "body_head_x", fHeadX);
        NUI_PersistSaveFloat(oPC, "body_head_y", fHeadY);
        NUI_PersistSaveFloat(oPC, "body_head_z", fHeadZ);
        NUI_PersistSaveFloat(oPC, "body_head_scale", fHeadScale);

        SendMessageToPC(oPC, "Body adjustments saved!");
    }

EXAMPLE 2: Load Body Adjustment Settings on Character Join

    void LoadBodyAdjustment(object oPC) {
        float fHeadX = NUI_PersistLoadFloat(oPC, "body_head_x", 0.0);
        float fHeadY = NUI_PersistLoadFloat(oPC, "body_head_y", 0.0);
        float fHeadZ = NUI_PersistLoadFloat(oPC, "body_head_z", 0.0);
        float fHeadScale = NUI_PersistLoadFloat(oPC, "body_head_scale", 1.0);

        SetLocalFloat(oPC, VAR_HEAD_X, fHeadX);
        SetLocalFloat(oPC, VAR_HEAD_Y, fHeadY);
        SetLocalFloat(oPC, VAR_HEAD_Z, fHeadZ);
        SetLocalFloat(oPC, VAR_HEAD_SCALE, fHeadScale);

        // Apply adjustments
        ApplyBodyAdjustments(oPC);
    }

EXAMPLE 3: Save Crafting Preferences

    void SaveCraftingPrefs(object oPC) {
        int nLastCategory = GetLocalInt(oPC, VAR_CRAFT_LAST_CAT);
        int nLastRecipe = GetLocalInt(oPC, VAR_CRAFT_LAST_RECIPE);

        NUI_PersistSaveInt(oPC, "craft_last_category", nLastCategory);
        NUI_PersistSaveInt(oPC, "craft_last_recipe", nLastRecipe);
    }

EXAMPLE 4: Load Custom Tailoring Colors

    void LoadTailoringColors(object oPC) {
        string sArmorColor = NUI_PersistLoad(oPC, "ct_armor_color", "default");
        string sWeaponColor = NUI_PersistLoad(oPC, "ct_weapon_color", "default");

        SetLocalString(oPC, VAR_ARMOR_COLOR, sArmorColor);
        SetLocalString(oPC, VAR_WEAPON_COLOR, sWeaponColor);
    }

EXAMPLE 5: Check if Player Has Settings

    void OnCharacterJoin(object oPC) {
        if (NUI_PersistExists(oPC, "body_head_x")) {
            LoadBodyAdjustment(oPC);
        } else {
            // New player, use defaults
            InitializeDefaults(oPC);
        }
    }

*/

//::///////////////////////////////////////////////////////////////////////
//:: END OF PERSISTENCE MODULE
//::///////////////////////////////////////////////////////////////////////
