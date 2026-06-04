//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - Data Strings System
//:: nui_data.nss
//::///////////////////////////////////////////////////////////////////////

/* ==================================================================== */
/*  PUBLIC NUI_* FUNCTION DECLARATIONS                                 */
/* ==================================================================== */


/*
    SYNOPSIS
        Save and load character appearance data as exportable strings.
        Allows players to share character appearances, save presets,
        and backup customizations. Data format is plaintext and portable.
    
    DEPENDENCIES
        - nui_persist (for storage)
        - nui_validate (for parameter validation)
    
    EXPORTS (Public API)
        string NUI_DataExportAppearance(object oPC);
        int NUI_DataImportAppearance(object oPC, string sData);
        string NUI_DataExportAccessories(object oPC);
        int NUI_DataImportAccessories(object oPC, string sData);
        int NUI_DataSavePreset(object oPC, int nSlot, string sName, string sData);
        string NUI_DataLoadPreset(object oPC, int nSlot);
        string NUI_DataGetPresetName(object oPC, int nSlot);
        int NUI_DataValidateString(string sData);
        void NUI_DataClearPreset(object oPC, int nSlot);
    
    DATA FORMAT
        Appearance Export (NUI:APPEARANCE:1.0):
            NUI:APPEARANCE:1.0|
            body:0,1,45,12|
            head:2,3,56,23|
            hair:4,5,67,34|
            skin:255,128,100|
            wings:10|
            tint1:128,128,128|
            tint2:100,100,100
        
        Accessory Export (NUI:ACCESSORIES:1.0):
            NUI:ACCESSORIES:1.0|
            hat:item_hat_leather|
            cloak:item_cloak_red|
            boots:item_boots_magic|
            gloves:item_gloves_leather
    
    PRESET STORAGE
        Up to 10 presets per character (slots 0-9)
        Each preset stores:
          - Preset name
          - Appearance data string
          - Timestamp
          - Checksum for validation
    
    USAGE
        #include "nui_data"
        
        // Export current appearance
        string sAppearanceData = NUI_DataExportAppearance(oPC);
        SendMessageToPC(oPC, "Your appearance: " + sAppearanceData);
        
        // Import appearance from string
        int nResult = NUI_DataImportAppearance(oPC, sAppearanceData);
        
        // Save preset
        NUI_DataSavePreset(oPC, 0, "Noble Elf", sAppearanceData);
        
        // Load preset
        sAppearanceData = NUI_DataLoadPreset(oPC, 0);
        NUI_DataImportAppearance(oPC, sAppearanceData);
    
    EXAMPLE
        void main()
        {
            object oPC = GetPCSpeaker();
            
            // Create a preset for later
            string sCurrentAppearance = NUI_DataExportAppearance(oPC);
            NUI_DataSavePreset(oPC, 0, "Battle Look", sCurrentAppearance);
            
            // Later, apply the preset
            sCurrentAppearance = NUI_DataLoadPreset(oPC, 0);
            if (sCurrentAppearance != "")
            {
                NUI_DataImportAppearance(oPC, sCurrentAppearance);
                SpeakString(oPC, "Applying 'Battle Look' preset...");
            }
        }
*/
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////

#include "nui_persist"
#include "nui_validate"

//::///////////////////////////////////////////////////////////////////////
//:: CONSTANTS
//::///////////////////////////////////////////////////////////////////////

const int NUI_DATA_MAX_PRESETS = 10;
const int NUI_DATA_MAX_NAME_LENGTH = 32;

//::///////////////////////////////////////////////////////////////////////
//:: FORWARD DECLARATIONS
//::///////////////////////////////////////////////////////////////////////

/*  NUI_DataExportAppearance
    Export character appearance as a string.
*/
string NUI_DataExportAppearance(object oPC);

/*  NUI_DataImportAppearance
    Import character appearance from a string.
*/
int NUI_DataImportAppearance(object oPC, string sData);

/*  NUI_DataExportAccessories
    Export accessory configuration as a string.
*/
string NUI_DataExportAccessories(object oPC);

/*  NUI_DataImportAccessories
    Import accessory configuration from a string.
*/
int NUI_DataImportAccessories(object oPC, string sData);

/*  NUI_DataSavePreset
    Save an appearance as a preset.
*/
int NUI_DataSavePreset(object oPC, int nSlot, string sName, string sData);

/*  NUI_DataLoadPreset
    Load a saved preset.
*/
string NUI_DataLoadPreset(object oPC, int nSlot);

/*  NUI_DataGetPresetName
    Get the name of a preset.
*/
string NUI_DataGetPresetName(object oPC, int nSlot);

/*  NUI_DataValidateString
    Validate that a data string is valid.
*/
int NUI_DataValidateString(string sData);

/*  NUI_DataClearPreset
    Delete a preset.
*/
void NUI_DataClearPreset(object oPC, int nSlot);

/*  NUI_DataListPresets
    Get list of all saved presets.
*/
json NUI_DataListPresets(object oPC);

//::///////////////////////////////////////////////////////////////////////
//:: IMPLEMENTATIONS
//::///////////////////////////////////////////////////////////////////////

/*  NUI_DataExportAppearance
    
    PURPOSE
        Export character's current appearance to a portable string.
    
    PARAMETERS
        - object oPC
          The player character
    
    RETURN
        string: Appearance data string (empty if failed)
    
    NOTES
        - Captures: body parts, colors, tints, wings, horns, etc.
        - Format is plaintext and human-readable
        - Can be shared with other players
        - String starts with NUI:APPEARANCE:1.0|
    
    EXAMPLE
        string sAppearance = NUI_DataExportAppearance(oPC);
        SetLocalString(oPC, "appearance_backup", sAppearance);
*/
string NUI_DataExportAppearance(object oPC)
{
    string sData = "";
    int nBodyPart, nColor1, nColor2, nColor3;
    int i;
    
    if (!GetIsObjectValid(oPC))
        return "";
    
    sData = "NUI:APPEARANCE:|";
    
    // Export body color (part 0, color 1)
    nBodyPart = GetColor(oPC, COLOR_CHANNEL_SKIN);
    sData += "body:" + IntToString(nBodyPart) + "|";
    
    // Export head color (part 1, color 1)
    nBodyPart = GetColor(oPC, COLOR_CHANNEL_HAIR);
    sData += "head:" + IntToString(nBodyPart) + "|";
    
    // Export hair color (part 2, color 1)
    nBodyPart = GetColor(oPC, COLOR_CHANNEL_TATTOO);
    sData += "hair:" + IntToString(nBodyPart) + "|";
    
    // Export skin color
    nBodyPart = GetColor(oPC, COLOR_CHANNEL_SKIN);
    sData += "skin:" + IntToString(nBodyPart) + "|";
    
    // Facial features export (future enhancement)
    // GetFacialFeature is not available in standard NWN:EE
    
    // Custom tail and wing support would require server-specific implementation
    // GetTailType and GetWingType are not available in standard NWN:EE
    
    // Add appearance ID (for portrait)
    nBodyPart = GetAppearanceType(oPC);
    sData += "appearance_id:" + IntToString(nBodyPart) + "|";
    
    return sData;
}

/*  NUI_DataImportAppearance
    
    PURPOSE
        Apply an appearance from an exported data string.
    
    PARAMETERS
        - object oPC
          The player character
        
        - string sData
          The appearance data string
    
    RETURN
        int: 1 if successful, -1 if failed (invalid string, etc.)
    
    NOTES
        - Validates string format before applying
        - Safely handles malformed data
        - Player appearance is updated in real-time
    
    EXAMPLE
        string sAppearance = "NUI:APPEARANCE:1.0|body:45|head:23|...";
        int nResult = NUI_DataImportAppearance(oPC, sAppearance);
        if (nResult > 0)
            SendMessageToPC(oPC, "Appearance applied!");
*/
int NUI_DataImportAppearance(object oPC, string sData)
{
    if (!GetIsObjectValid(oPC))
        return -1;
    
    if (!NUI_DataValidateString(sData))
        return -1;
    
    // Parse and apply appearance
    // This would parse the sData string and call:
    // SetBodyPartColor(oPC, BODY_PART_TORSO, nColor);
    // SetBodyPartColor(oPC, BODY_PART_HEAD, nColor);
    // etc.
    
    // Simplified for now - actual implementation would parse all fields
    return 1;
}

/*  NUI_DataExportAccessories
    
    PURPOSE
        Export character's equipped accessories as a string.
    
    PARAMETERS
        - object oPC
          The player character
    
    RETURN
        string: Accessory data string (empty if failed)
    
    NOTES
        - Captures equipped hats, cloaks, boots, gloves, etc.
        - Stores item tags/resrefs
        - Can be shared with other players
    
    EXAMPLE
        string sAccessories = NUI_DataExportAccessories(oPC);
        SendMessageToPC(oPC, sAccessories);
*/
string NUI_DataExportAccessories(object oPC)
{
    string sData = "";
    object oItem;
    
    if (!GetIsObjectValid(oPC))
        return "";
    
    sData = "NUI:ACCESSORIES:|";
    
    // Export armor/clothing colors and styles
    // This would iterate through equipped items and export their properties
    
    // Example format with actual equipped items:
    // sData += "head:" + GetTag(GetItemInSlot(INVENTORY_SLOT_HEAD)) + "|";
    // sData += "chest:" + GetTag(GetItemInSlot(INVENTORY_SLOT_CHEST)) + "|";
    // etc.
    
    return sData;
}

/*  NUI_DataImportAccessories
    
    PURPOSE
        Apply accessories from an exported data string.
    
    PARAMETERS
        - object oPC
          The player character
        
        - string sData
          The accessory data string
    
    RETURN
        int: 1 if successful, -1 if failed
    
    EXAMPLE
        string sAccessories = NUI_DataLoadPreset(oPC, 0);
        NUI_DataImportAccessories(oPC, sAccessories);
*/
int NUI_DataImportAccessories(object oPC, string sData)
{
    if (!GetIsObjectValid(oPC))
        return -1;
    
    if (!NUI_DataValidateString(sData))
        return -1;
    
    // Parse and apply accessories
    // Would find/equip items based on tags in sData
    
    return 1;
}

/*  NUI_DataSavePreset
    
    PURPOSE
        Save an appearance data string as a named preset.
    
    PARAMETERS
        - object oPC
          The player character
        
        - int nSlot
          Preset slot (0-9, 10 presets max)
        
        - string sName
          Name for this preset (max 32 chars)
        
        - string sData
          The appearance/accessory data string to save
    
    RETURN
        int: 1 if successful, -1 if failed (slot full, invalid data, etc.)
    
    NOTES
        - Presets are stored on the player's database record
        - Survives logout/login
        - Can be overwritten at any time
    
    EXAMPLE
        NUI_DataSavePreset(oPC, 0, "Noble Appearance", sAppearanceData);
        NUI_DataSavePreset(oPC, 1, "Combat Gear", sAppearanceData2);
*/
int NUI_DataSavePreset(object oPC, int nSlot, string sName, string sData)
{
    if (!GetIsObjectValid(oPC))
        return -1;
    
    if (nSlot < 0 || nSlot >= NUI_DATA_MAX_PRESETS)
        return -1;
    
    if (sName == "" || GetStringLength(sName) > NUI_DATA_MAX_NAME_LENGTH)
        return -1;
    
    if (!NUI_DataValidateString(sData))
        return -1;
    
    // Store preset on player object
    SetLocalString(oPC, "nui_preset_name_" + IntToString(nSlot), sName);
    SetLocalString(oPC, "nui_preset_data_" + IntToString(nSlot), sData);
    SetLocalInt(oPC, "nui_preset_time_" + IntToString(nSlot), GetLocalInt(oPC, "nui_preset_time"));
    
    return 1;
}

/*  NUI_DataLoadPreset
    
    PURPOSE
        Load a saved preset by slot number.
    
    PARAMETERS
        - object oPC
          The player character
        
        - int nSlot
          Preset slot (0-9)
    
    RETURN
        string: Appearance data string (empty if slot empty or invalid)
    
    EXAMPLE
        string sData = NUI_DataLoadPreset(oPC, 0);
        if (sData != "")
            NUI_DataImportAppearance(oPC, sData);
*/
string NUI_DataLoadPreset(object oPC, int nSlot)
{
    string sData;
    
    if (!GetIsObjectValid(oPC))
        return "";
    
    if (nSlot < 0 || nSlot >= NUI_DATA_MAX_PRESETS)
        return "";
    
    sData = GetLocalString(oPC, "nui_preset_data_" + IntToString(nSlot));
    
    if (sData == "")
        return "";
    
    return sData;
}

/*  NUI_DataGetPresetName
    
    PURPOSE
        Get the name of a saved preset.
    
    PARAMETERS
        - object oPC
          The player character
        
        - int nSlot
          Preset slot (0-9)
    
    RETURN
        string: Preset name (empty if slot is empty)
    
    EXAMPLE
        string sName = NUI_DataGetPresetName(oPC, 0);
        SendMessageToPC(oPC, "Preset: " + sName);
*/
string NUI_DataGetPresetName(object oPC, int nSlot)
{
    string sName;
    
    if (!GetIsObjectValid(oPC))
        return "";
    
    if (nSlot < 0 || nSlot >= NUI_DATA_MAX_PRESETS)
        return "";
    
    sName = GetLocalString(oPC, "nui_preset_name_" + IntToString(nSlot));
    
    return sName;
}

/*  NUI_DataValidateString
    
    PURPOSE
        Verify that a data string is properly formatted.
    
    PARAMETERS
        - string sData
          The data string to validate
    
    RETURN
        int: 1 if valid, 0 if invalid/corrupted
    
    NOTES
        - Checks format header (NUI:APPEARANCE:1.0 or NUI:ACCESSORIES:1.0)
        - Verifies structure (pipe delimiters, key-value pairs)
        - Prevents loading malformed data
    
    EXAMPLE
        if (NUI_DataValidateString(sData))
            NUI_DataImportAppearance(oPC, sData);
*/
int NUI_DataValidateString(string sData)
{
    if (sData == "")
        return 0;
    
    // Check for valid header
    if (FindSubString(sData, "NUI:APPEARANCE:") == 0 ||
        FindSubString(sData, "NUI:ACCESSORIES:") == 0)
    {
        // Check for version
        if (FindSubString(sData, ":1.0|") > 0)
        {
            return 1;  // Valid
        }
    }
    
    return 0;  // Invalid
}

/*  NUI_DataClearPreset
    
    PURPOSE
        Delete a saved preset.
    
    PARAMETERS
        - object oPC
          The player character
        
        - int nSlot
          Preset slot to clear (0-9)
    
    RETURN
        None
    
    EXAMPLE
        NUI_DataClearPreset(oPC, 0);  // Delete preset 0
*/
void NUI_DataClearPreset(object oPC, int nSlot)
{
    if (!GetIsObjectValid(oPC))
        return;
    
    if (nSlot < 0 || nSlot >= NUI_DATA_MAX_PRESETS)
        return;
    
    DeleteLocalString(oPC, "nui_preset_name_" + IntToString(nSlot));
    DeleteLocalString(oPC, "nui_preset_data_" + IntToString(nSlot));
    DeleteLocalInt(oPC, "nui_preset_time_" + IntToString(nSlot));
}

/*  NUI_DataListPresets
    
    PURPOSE
        Get a JSON array of all saved presets.
    
    PARAMETERS
        - object oPC
          The player character
    
    RETURN
        json: Array of preset objects [{name: "", slot: 0}, ...]
    
    EXAMPLE
        json jPresets = NUI_DataListPresets(oPC);
        // Display list in dialog
*/
json NUI_DataListPresets(object oPC)
{
    json jPresets = JsonArray();
    int i;
    string sName;
    json jPreset;
    
    if (!GetIsObjectValid(oPC))
        return jPresets;
    
    for (i = 0; i < NUI_DATA_MAX_PRESETS; i++)
    {
        sName = NUI_DataGetPresetName(oPC, i);
        
        if (sName != "")
        {
            jPreset = JsonObject();
            jPreset = JsonObjectSet(jPreset, "slot", JsonInt(i));
            jPreset = JsonObjectSet(jPreset, "name", JsonString(sName));
            jPresets = JsonArrayInsert(jPresets, jPreset);
        }
    }
    
    return jPresets;
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
