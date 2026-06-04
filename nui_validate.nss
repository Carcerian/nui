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
//:: Carcerian NUI - Validation Utilities
//:: nui_validate.nss
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
        Centralized parameter validation for NUI system. Provides
        validation functions for common input types and constraints.
        
        Reduces code duplication by centralizing validation logic
        used throughout subsystem APIs and handlers.

    DEPENDENCIES
        None

    USAGE
        #include "nui_validate"
        
        // Validate numeric range
        if (!NUI_ValidateRange(nValue, 0, 100)) return -1;
        
        // Validate string length
        if (!NUI_ValidateStringLength(sValue, 0, 256)) return -1;
        
        // Validate non-null object
        if (!NUI_ValidateObject(oPC)) return -1;
        
        // Validate array size
        if (!NUI_ValidateArraySize(jArray, 0, 10)) return -1;

    EXAMPLE (beginner)
        // Ensure age is valid before processing
        if (!NUI_ValidateRange(nAge, 0, 999)) {
            SendMessageToPC(oPC, "Invalid age value.");
            return -1;
        }

    EXAMPLE (intermediate)
        // Validate multiple parameters at once
        if (!NUI_ValidateObject(oPC)) return -1;
        if (!NUI_ValidateStringLength(sName, 1, 64)) return -1;
        if (!NUI_ValidateRange(nValue, -100, 100)) return -1;

    EXAMPLE (advanced)
        // Custom validation with error callback
        int ValidateUserInput(object oPC, string sInput) {
            if (!NUI_ValidateObject(oPC)) {
                WriteTimestampedLogEntry("NUI Validate: Invalid PC object");
                return FALSE;
            }
            if (!NUI_ValidateStringLength(sInput, 1, 256)) {
                SendMessageToPC(oPC, "Input too long (max 256 chars).");
                return FALSE;
            }
            return TRUE;
        }
*/
//::///////////////////////////////////////////////////////////////////////
//:: Author:  Carcerian
//:: Version: 1.0
//:: Created: June 2, 2026
//::///////////////////////////////////////////////////////////////////////

#include "nui_api_json"

/* ----------------------------------------------------------------------- */
/*  VALIDATION FUNCTIONS                                                   */
/*  Return TRUE if valid, FALSE if invalid                                 */
/* ----------------------------------------------------------------------- */

// Validate object is non-null and valid
int NUI_ValidateObject(object oObject);

// Validate numeric value is within range [min, max]
int NUI_ValidateRange(int nValue, int nMin, int nMax);

// Validate float value is within range [min, max]
int NUI_ValidateFloatRange(float fValue, float fMin, float fMax);

// Validate string length is within range [min, max]
int NUI_ValidateStringLength(string sValue, int nMin, int nMax);

// Validate array size is within range [min, max]
int NUI_ValidateArraySize(json jArray, int nMin, int nMax);

// Validate string is not empty
int NUI_ValidateStringNotEmpty(string sValue);

// Validate item material color value [0-175] (NWN:EE color palette)
int NUI_ValidateColorValue(int nColor);

// Validate RGB text color value [0-255] per channel
int NUI_ValidateRGBTextColor(int nRGBValue);

// Validate coordinate value (X, Y, Z) is reasonable
int NUI_ValidateCoordinate(float fCoord);

// Validate scale value is reasonable [0.1 - 10.0]
int NUI_ValidateScale(float fScale);

// Validate rotation value is in valid degree range [0-359]
int NUI_ValidateRotation(float fRotation);


/* ----------------------------------------------------------------------- */
/*  FUNCTION IMPLEMENTATIONS                                               */
/* ----------------------------------------------------------------------- */

int NUI_ValidateObject(object oObject)
{
    if (oObject == OBJECT_INVALID) return FALSE;
    if (!GetIsObjectValid(oObject)) return FALSE;
    return TRUE;
}

int NUI_ValidateRange(int nValue, int nMin, int nMax)
{
    if (nValue < nMin) return FALSE;
    if (nValue > nMax) return FALSE;
    return TRUE;
}

int NUI_ValidateFloatRange(float fValue, float fMin, float fMax)
{
    if (fValue < fMin) return FALSE;
    if (fValue > fMax) return FALSE;
    return TRUE;
}

int NUI_ValidateStringLength(string sValue, int nMin, int nMax)
{
    int nLen = GetStringLength(sValue);
    if (nLen < nMin) return FALSE;
    if (nLen > nMax) return FALSE;
    return TRUE;
}

int NUI_ValidateArraySize(json jArray, int nMin, int nMax)
{
    int nSize = GetJsonArraySize(jArray);
    if (nSize < nMin) return FALSE;
    if (nSize > nMax) return FALSE;
    return TRUE;
}

int NUI_ValidateStringNotEmpty(string sValue)
{
    return NUI_ValidateStringLength(sValue, 1, 999999);
}

// Item material colors use NWN:EE color palette (0-175)
int NUI_ValidateColorValue(int nColor)
{
    // Item material colors (armor, clothing, skin) use palette [0-175]
    // Based on NWN:EE color grid in supplemental NUI systems
    if (nColor < 0) return FALSE;
    if (nColor > 175) return FALSE;
    return TRUE;
}

// RGB text colors use standard 0-255 per channel
int NUI_ValidateRGBTextColor(int nRGBValue)
{
    // Text colors use standard RGB [0-255] per channel
    // Typically R, G, B values are 0-255 each
    if (nRGBValue < 0) return FALSE;
    if (nRGBValue > 255) return FALSE;
    return TRUE;
}

int NUI_ValidateCoordinate(float fCoord)
{
    // Allow reasonable world coordinates
    // Typical area is roughly [-100, 100] but allow wider range
    if (fCoord < -500.0) return FALSE;
    if (fCoord > 500.0) return FALSE;
    return TRUE;
}

int NUI_ValidateScale(float fScale)
{
    if (fScale < 0.1) return FALSE;
    if (fScale > 10.0) return FALSE;
    return TRUE;
}

int NUI_ValidateRotation(float fRotation)
{
    if (fRotation < 0.0) return FALSE;
    if (fRotation > 359.9) return FALSE;
    return TRUE;
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////

/* ======================================================================= */
/*  DIALOG TYPE MANAGEMENT                                                */
/* ======================================================================= */

// Get dialog type for PC (stored as local int on player)
int NUI_GetDialogType(object oPC)
{
    if (!GetIsPC(oPC)) return -1;
    return GetLocalInt(oPC, "NUI_DIALOG_TYPE");
}

// Set dialog type for PC (stored as local int on player)
void NUI_SetDialogType(object oPC, int nType)
{
    if (!GetIsPC(oPC)) return;
    SetLocalInt(oPC, "NUI_DIALOG_TYPE", nType);
}

// Set dialog token for PC (stored as local string on player)
void NUI_SetDialogToken(object oPC, string sToken)
{
    if (!GetIsPC(oPC)) return;
    SetLocalString(oPC, "NUI_DIALOG_TOKEN", sToken);
}

// Get dialog token for PC (stored as local string on player)
string NUI_GetDialogToken(object oPC)
{
    if (!GetIsPC(oPC)) return "";
    return GetLocalString(oPC, "NUI_DIALOG_TOKEN");
}
