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
//:: Carcerian NUI - Core Event Handler
//:: nui_api_handle.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.1
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 2, 2026 - Priority 1 Optimizations
//::///////////////////////////////////////////////////////////////////////
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Core NUI event handling system. Contains:
        - HandleNuiEvent() - Main event dispatcher
        - Button handler implementations (OK, Cancel, Yes, No, Back, Close, Custom)
        - Specialized handlers (Age Check)
        - Helper functions for parameter parsing and callbacks

        This is the shared foundation included by all event handler scripts.
        It contains both the event dispatcher AND the default button handler
        implementations, allowing any script to process NUI events.

        Included by:
          - nui_mod_event.nss (module OnNUIEvent script)
          - nui_handler.nss (standalone event processor)

    DEPENDENCIES
        nui_api.nss (for constants, logging, validation)

    USAGE
        #include "nui_api_handle"
        
        int result = HandleNuiEvent();

*/
//::///////////////////////////////////////////////////////////////////////

#include "nui_api"
#include "nui_validate"

/* ----------------------------------------------------------------------- */
/*  CONSTANTS                                                               */
/* ----------------------------------------------------------------------- */

const int NUI_CALLBACK_BEFORE = 1;
const int NUI_CALLBACK_AFTER = 2;

const int NUI_HANDLER_SUCCESS = 0;
const int NUI_HANDLER_VALIDATION_FAILED = 1;
const int NUI_HANDLER_CALLBACK_ERROR = 2;
const int NUI_HANDLER_PARAM_ERROR = 3;

/* ----------------------------------------------------------------------- */
/*  FORWARD DECLARATIONS - ALL HANDLERS                                    */
/* ----------------------------------------------------------------------- */

int HandleNuiEvent();
int HandleButtonOk(object oPC, string sAction, string sParam2, string sParam3, string sParam4);
int HandleButtonCancel(object oPC, string sAction, string sParam2, string sParam3, string sParam4);
int HandleButtonYes(object oPC, string sAction, string sParam2, string sParam3, string sParam4);
int HandleButtonNo(object oPC, string sAction, string sParam2, string sParam3, string sParam4);
int HandleButtonBack(object oPC, string sAction, string sParam2, string sParam3, string sParam4);
int HandleButtonClose(object oPC, string sAction, string sParam2, string sParam3, string sParam4);
int HandleCustomButton(object oPC, string sButtonName, string sAction, string sParam2, string sParam3, string sParam4);
int HandleAgeCheckYes(object oPC, string sParam2, string sParam3, string sParam4);
int HandleAgeCheckNo(object oPC, string sParam2, string sParam3, string sParam4);

int NUI_ParseIntParam(string sParam, int nDefault);
int ExecuteNUICallback(object oPC, int nTiming);

/* ----------------------------------------------------------------------- */
/*  HELPER FUNCTIONS - Parameter parsing and callbacks                     */
/* ----------------------------------------------------------------------- */

/*
    NUI_ParseIntParam()
    
    Parses integer value from parameter string formatted as "key=value"
    
    PARAMETERS:
      sParam: Parameter string (e.g., "age=18")
      nDefault: Default value if parsing fails
    
    RETURN:
      Parsed integer value, or nDefault if parsing fails
    
    EXAMPLE:
      int nAge = NUI_ParseIntParam("age=25", 18);
*/

int NUI_ParseIntParam(string sParam, int nDefault)
{
    if (sParam == "")
        return nDefault;
    
    int nPos = FindSubString(sParam, "=");
    if (nPos >= 0)
    {
        string sValue = GetSubString(sParam, nPos + 1, 10);
        int nValue = StringToInt(sValue);
        return (nValue != 0 || sValue == "0") ? nValue : nDefault;
    }
    
    return nDefault;
}

/*
    ExecuteNUICallback()
    
    Executes a callback script if timing matches and script is registered
    
    PARAMETERS:
      oPC: Player object
      nTiming: NUI_CALLBACK_BEFORE or NUI_CALLBACK_AFTER
    
    RETURN:
      NUI_HANDLER_SUCCESS (0) if executed or no callback
      NUI_HANDLER_CALLBACK_ERROR (2) if execution failed
*/

int ExecuteNUICallback(object oPC, int nTiming)
{
    string sCallback = GetLocalString(oPC, "nui_callback_script");
    int nStoredTiming = GetLocalInt(oPC, "nui_callback_timing");
    
    if (sCallback == "" || nStoredTiming != nTiming)
        return NUI_HANDLER_SUCCESS;
    
    // Validate callback script name length
    if (GetStringLength(sCallback) > 100)
    {
        NUI_Log(oPC, "ExecuteNUICallback: Script name too long", 2);
        return NUI_HANDLER_CALLBACK_ERROR;
    }
    
    ExecuteScript(sCallback, oPC);
    
    // Clean up after AFTER callback
    if (nTiming == NUI_CALLBACK_AFTER)
    {
        DeleteLocalString(oPC, "nui_callback_script");
        DeleteLocalInt(oPC, "nui_callback_timing");
        DeleteLocalString(oPC, "nui_callback_params");
    }
    
    return NUI_HANDLER_SUCCESS;
}

/* ----------------------------------------------------------------------- */
/*  CORE NUI EVENT DISPATCHER - Main entry point                           */
/* ----------------------------------------------------------------------- */

/*
    HandleNuiEvent()
    
    DESCRIPTION:
    Universal event dispatcher for NUI dialogs. This is the main entry point
    that receives all NUI click events and routes them to appropriate handlers.
    
    Called by:
      - nui_mod_event.nss (Module OnNUIEvent script)
      - nui_handler.nss (Custom event handler script)
    
    BUTTON NAMING CONVENTION:
    Standard button element names:
      - "btn_ok"  OK button
      - "btn_cancel"  Cancel button
      - "btn_yes"  Yes button
      - "btn_no"  No button
      - "btn_back"  Back button
      - "btn_close"  Close button
      - "btn_custom_*"  Custom buttons (server-defined)
    
    PARAMETERS:
    - Event data retrieved via NuiGetEvent*() functions
    
    RETURN:
    - int: 1 if event handled, 0 if unhandled
*/

int HandleNuiEvent()
{
    object oPC = NuiGetEventPlayer();
    string sEvent = NuiGetEventType();
    string sElement = NuiGetEventElement();
    
    // Only process click events in default handler
    if (sEvent != "click")
        return 0;
    
    if (!GetIsPC(oPC))
        return 0;
    
    // Get script parameters (if any were set)
    string sAction = GetScriptParam("action");     // Parameter 1: Action/Mode
    string sParam2 = GetScriptParam("param2");     // Parameter 2: Custom param
    string sParam3 = GetScriptParam("param3");     // Parameter 3: Custom param
    string sParam4 = GetScriptParam("param4");     // Parameter 4: Custom param
    
    // ===== STANDARD BUTTON HANDLING =====
    
    // Sign Close Button - respond to mouseup only
    if (sElement == "sign_close_button" && sEvent == "mouseup")
    {
        int nToken = NuiGetEventWindow();
        if (nToken > 0) {
            NuiDestroy(oPC, nToken);
        }
        return 1;
    }
    
    // Message OK Button - respond to mouseup only
    if (sElement == "message_ok_button" && sEvent == "mouseup")
    {
        int nToken = GetLocalInt(oPC, "NUI_MESSAGE_TOKEN");
        if (nToken > 0) {
            NuiDestroy(oPC, nToken);
            DeleteLocalInt(oPC, "NUI_MESSAGE_TOKEN");
        }
        return 1;
    }
    
    // OK Button - check if this is a message window (mouseup only)
    if (sElement == "btn_ok" && sEvent == "mouseup")
    {
        int nToken = GetLocalInt(oPC, "NUI_MESSAGE_TOKEN");
        if (nToken > 0) {
            NuiDestroy(oPC, nToken);
            DeleteLocalInt(oPC, "NUI_MESSAGE_TOKEN");
            return 1;
        }
        HandleButtonOk(oPC, sAction, sParam2, sParam3, sParam4);
        return 1;
    }
    
    // Cancel Button
    if (sElement == "btn_cancel")
    {
        HandleButtonCancel(oPC, sAction, sParam2, sParam3, sParam4);
        return 1;
    }
    
    // Yes Button
    if (sElement == "btn_yes")
    {
        HandleButtonYes(oPC, sAction, sParam2, sParam3, sParam4);
        return 1;
    }
    
    // No Button
    if (sElement == "btn_no")
    {
        HandleButtonNo(oPC, sAction, sParam2, sParam3, sParam4);
        return 1;
    }
    
    // Back Button
    if (sElement == "btn_back")
    {
        HandleButtonBack(oPC, sAction, sParam2, sParam3, sParam4);
        return 1;
    }
    
    // Close Button
    if (sElement == "btn_close")
    {
        HandleButtonClose(oPC, sAction, sParam2, sParam3, sParam4);
        return 1;
    }
    
    // Custom buttons: prefix "btn_"
    if (GetSubString(sElement, 0, 4) == "btn_")
    {
        string sButtonName = GetSubString(sElement, 4, GetStringLength(sElement));
        HandleCustomButton(oPC, sButtonName, sAction, sParam2, sParam3, sParam4);
        return 1;
    }
    
    return 0;
}

//::///////////////////////////////////////////////////////////////////////
//:: BUTTON HANDLERS - Process specific button clicks
//::///////////////////////////////////////////////////////////////////////

/*
    HandleButtonOk()
    
    Called when OK button is clicked.
    Default action: Close dialog and send confirmation message.
    
    Server can override by passing custom action in sAction parameter.
    
    RETURN:
      NUI_HANDLER_SUCCESS (0) on success
      NUI_HANDLER_VALIDATION_FAILED (1) if validation failed
      NUI_HANDLER_CALLBACK_ERROR (2) if callback failed
*/

int HandleButtonOk(object oPC, string sAction, string sParam2, string sParam3, string sParam4)
{
    if (!GetIsPC(oPC))
        return NUI_HANDLER_VALIDATION_FAILED;
    
    // Execute BEFORE callback
    int nResult = ExecuteNUICallback(oPC, NUI_CALLBACK_BEFORE);
    if (nResult != NUI_HANDLER_SUCCESS)
        return nResult;
    
    // Check for custom action
    if (sAction != "")
    {
        SendMessageToPC(oPC, "OK: " + sAction);
    }
    else
    {
        SendMessageToPC(oPC, "Dialog confirmed.");
    }
    
    // Execute AFTER callback
    return ExecuteNUICallback(oPC, NUI_CALLBACK_AFTER);
}

/*
    HandleButtonCancel()
    
    Called when Cancel button is clicked.
    Default action: Close dialog without action.
    
    Server can pass custom action in sAction parameter.
    
    RETURN:
      NUI_HANDLER_SUCCESS (0) on success
      NUI_HANDLER_VALIDATION_FAILED (1) if validation failed
      NUI_HANDLER_CALLBACK_ERROR (2) if callback failed
*/

int HandleButtonCancel(object oPC, string sAction, string sParam2, string sParam3, string sParam4)
{
    if (!GetIsPC(oPC))
        return NUI_HANDLER_VALIDATION_FAILED;
    
    // Execute BEFORE callback
    int nResult = ExecuteNUICallback(oPC, NUI_CALLBACK_BEFORE);
    if (nResult != NUI_HANDLER_SUCCESS)
        return nResult;
    
    if (sAction != "")
    {
        SendMessageToPC(oPC, "Cancelled: " + sAction);
    }
    else
    {
        SendMessageToPC(oPC, "Dialog cancelled.");
    }
    
    // Execute AFTER callback
    return ExecuteNUICallback(oPC, NUI_CALLBACK_AFTER);
}

/*
    HandleButtonYes()
    
    Called when Yes button is clicked.
    Typically used for confirmation dialogs.
    
    Common actions passed via sAction:
      - "age_check" - Age verification (yes = confirmed 18+)
      - "confirm_action" - Confirm an action
      - "agree_terms" - Agree to terms
    
    RETURN:
      NUI_HANDLER_SUCCESS (0) on success
      Error code if handler failed
*/

int HandleButtonYes(object oPC, string sAction, string sParam2, string sParam3, string sParam4)
{
    if (!GetIsPC(oPC))
        return NUI_HANDLER_VALIDATION_FAILED;
    
    // Age verification example
    if (sAction == "age_check")
    {
        return HandleAgeCheckYes(oPC, sParam2, sParam3, sParam4);
    }
    
    // Generic yes handler
    SendMessageToPC(oPC, "You confirmed: Yes");
    return NUI_HANDLER_SUCCESS;
}

/*
    HandleButtonNo()
    
    Called when No button is clicked.
    Typically used for confirmation dialogs.
    
    Common actions:
      - "age_check" - Age verification (no = denied)
      - "confirm_action" - Reject action
      - "agree_terms" - Reject terms
    
    RETURN:
      NUI_HANDLER_SUCCESS (0) on success
      Error code if handler failed
*/

int HandleButtonNo(object oPC, string sAction, string sParam2, string sParam3, string sParam4)
{
    if (!GetIsPC(oPC))
        return NUI_HANDLER_VALIDATION_FAILED;
    
    // Age verification example
    if (sAction == "age_check")
    {
        return HandleAgeCheckNo(oPC, sParam2, sParam3, sParam4);
    }
    
    // Generic no handler
    SendMessageToPC(oPC, "You declined: No");
    return NUI_HANDLER_SUCCESS;
}

/*
    HandleButtonBack()
    
    Called when Back button is clicked.
    Typically returns to previous menu/dialog.
    
    RETURN:
      NUI_HANDLER_SUCCESS (0) always
*/

int HandleButtonBack(object oPC, string sAction, string sParam2, string sParam3, string sParam4)
{
    if (!GetIsPC(oPC))
        return NUI_HANDLER_VALIDATION_FAILED;
    
    SendMessageToPC(oPC, "Going back...");
    return NUI_HANDLER_SUCCESS;
}

/*
    HandleButtonClose()
    
    Called when Close (X) button is clicked.
    Closes dialog without further action.
    
    RETURN:
      NUI_HANDLER_SUCCESS (0) always
*/

int HandleButtonClose(object oPC, string sAction, string sParam2, string sParam3, string sParam4)
{
    if (!GetIsPC(oPC))
        return NUI_HANDLER_VALIDATION_FAILED;
    
    SendMessageToPC(oPC, "Dialog closed.");
    return NUI_HANDLER_SUCCESS;
}

/*
    HandleCustomButton()
    
    Called for any button with "btn_" prefix not in standard set.
    
    sButtonName: Button name without "btn_" prefix
    Examples:
      - btn_apply  sButtonName = "apply"
      - btn_settings  sButtonName = "settings"
      - btn_help  sButtonName = "help"
    
    RETURN:
      NUI_HANDLER_SUCCESS (0) always
*/

int HandleCustomButton(object oPC, string sButtonName, string sAction, string sParam2, string sParam3, string sParam4)
{
    if (!GetIsPC(oPC))
        return NUI_HANDLER_VALIDATION_FAILED;
    
    SendMessageToPC(oPC, "Custom button pressed: " + sButtonName);
    return NUI_HANDLER_SUCCESS;
}

//::///////////////////////////////////////////////////////////////////////
//:: SPECIALIZED HANDLERS - Action-specific processing
//::///////////////////////////////////////////////////////////////////////

/*
    HandleAgeCheckYes()
    
    Player confirmed they are 18 years or older.
    
    Parameters:
      sParam2: min_age (e.g., "min_age=18")
      sParam3: reward_xp (e.g., "reward=3000")
      sParam4: other options (e.g., "boot_on_fail=true")
    
    Actions:
      1. Verify age confirmed
      2. Grant reward if set
      3. Mark as verified
    
    RETURN:
      NUI_HANDLER_SUCCESS (0) on success
      NUI_HANDLER_VALIDATION_FAILED (1) if validation failed
      NUI_HANDLER_PARAM_ERROR (3) if parameter parsing failed
*/

int HandleAgeCheckYes(object oPC, string sParam2, string sParam3, string sParam4)
{
    // Validate PC object
    if (!NUI_ValidateObject(oPC))
    {
        NUI_Log(oPC, "HandleAgeCheckYes: Invalid PC object", 3);
        return NUI_HANDLER_VALIDATION_FAILED;
    }
    
    // Parse parameters with validation using helper function
    int nMinAge = NUI_ParseIntParam(sParam2, 18);
    int nReward = NUI_ParseIntParam(sParam3, 0);
    
    // Validate age is reasonable (0-150)
    if (!NUI_ValidateRange(nMinAge, 0, 150))
    {
        NUI_Log(oPC, "HandleAgeCheckYes: Invalid age value: " + IntToString(nMinAge), 2);
        return NUI_HANDLER_PARAM_ERROR;
    }
    
    // Validate reward is reasonable (0-1000000 XP)
    if (!NUI_ValidateRange(nReward, 0, 1000000))
    {
        NUI_Log(oPC, "HandleAgeCheckYes: Invalid reward value: " + IntToString(nReward), 2);
        return NUI_HANDLER_PARAM_ERROR;
    }
    
    // Grant reward
    if (nReward > 0)
    {
        GiveXPToCreature(oPC, nReward);
        SendMessageToPC(oPC, "Age verified! You received " + IntToString(nReward) + " XP!");
        WriteTimestampedLogEntry("[NUI] Age gate: Player granted " + IntToString(nReward) + " XP");
    }
    else
    {
        SendMessageToPC(oPC, "Age verified. Access granted.");
        WriteTimestampedLogEntry("[NUI] Age gate: Player verified");
    }
    
    // Mark as verified
    SetLocalInt(oPC, "nui_age_verified_18plus", 1);
    SetLocalInt(oPC, "nui_age_verified_at", 1);
    
    return NUI_HANDLER_SUCCESS;
}

/*
    HandleAgeCheckNo()
    
    Player indicated they are NOT 18 years or older.
    
    Parameters:
      sParam4: boot_on_fail (e.g., "boot_on_fail=true")
    
    Actions:
      1. Deny access
      2. Boot if specified
      3. Log incident
    
    RETURN:
      NUI_HANDLER_SUCCESS (0) always
*/

int HandleAgeCheckNo(object oPC, string sParam2, string sParam3, string sParam4)
{
    SendMessageToPC(oPC, 
        "You must be 18 or older to access this content. " +
        "You will be disconnected in 3 seconds.");
    
    // Check if boot is specified
    if (sParam4 == "boot_on_fail=true" || sParam4 == "true")
    {
        DelayCommand(3.0, BootPC(oPC));
        WriteTimestampedLogEntry("NUI: " + GetName(oPC) + " failed age check - booting.");
    }
    
    return NUI_HANDLER_SUCCESS;
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
