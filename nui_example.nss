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
//:: Carcerian NUI - Popup Usage Examples
//:: nui_example.nss
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 3, 2026
//::///////////////////////////////////////////////////////////////////////

#include "nui_api"

//::///////////////////////////////////////////////////////////////////////
//:: POPUP EXAMPLES
//::///////////////////////////////////////////////////////////////////////
//:: This file demonstrates how to use the Carcerian NUI popup system
//:: Copy these patterns to use in your own scripts
//::///////////////////////////////////////////////////////////////////////

//::///////////////////////////////////////////////////////////////////////////
//:: Example 1: Simple Message Popup
//::///////////////////////////////////////////////////////////////////////////
//:: Display a quick message to the player
//:: - Centered on screen
//:: - OK button closes window
//:: - Non-collapsible
void Example_SimpleMessage(object oPC)
{
    string sTitle = "System Message";
    string sMessage = "This is a simple message popup.\n\nClick OK to close.";

    // Create message popup (uses defaults: centered, raised 15%, OK closes)
    int nToken = NUI_PopupMessage(oPC, sTitle, sMessage);

    if (nToken > 0) {
        WriteTimestampedLogEntry("NUI: Message popup created for " + GetName(oPC));
    }
}

//::///////////////////////////////////////////////////////////////////////////
//:: Example 2: Sign/Notice Board with AOE
//::///////////////////////////////////////////////////////////////////////////
//:: Display a large sign that closes when player moves away
//:: - Large size (625 x 312.5)
//:: - AOE integration - auto-closes on exit
//:: - Useful for quest boards, notices, etc.
void Example_Sign(object oPC, string sTitle, string sMessage)
{
    // Create sign with automatic AOE
    // When player exits the AOE radius, sign closes
    int nToken = NUI_PopupSign(oPC);

    if (nToken > 0) {
        WriteTimestampedLogEntry("NUI: Sign created at " + GetName(oPC) + " location");
    }
}

//::///////////////////////////////////////////////////////////////////////////
//:: Example 3: Error Message
//::///////////////////////////////////////////////////////////////////////////
//:: Display error to player with [ERROR] prefix
void Example_Error(object oPC, string sErrorMessage)
{
    string sTitle = "Error";

    // NUI_PopupError adds [ERROR] prefix automatically
    int nToken = NUI_PopupError(oPC, sTitle, sErrorMessage);

    if (nToken > 0) {
        WriteTimestampedLogEntry("NUI Error: " + sErrorMessage);
    }
}

//::///////////////////////////////////////////////////////////////////////////
//:: Example 4: Success Message
//::///////////////////////////////////////////////////////////////////////////
//:: Display success feedback to player
void Example_Success(object oPC, string sSuccessMessage)
{
    string sTitle = "Success";

    int nToken = NUI_PopupSuccess(oPC, sTitle, sSuccessMessage);

    if (nToken > 0) {
        WriteTimestampedLogEntry("NUI Success: " + sSuccessMessage);
    }
}

//::///////////////////////////////////////////////////////////////////////////
//:: Example 5: Warning Message
//::///////////////////////////////////////////////////////////////////////////
//:: Display warning to player
void Example_Warning(object oPC, string sWarningMessage)
{
    string sTitle = "Warning";

    int nToken = NUI_PopupWarning(oPC, sTitle, sWarningMessage);

    if (nToken > 0) {
        WriteTimestampedLogEntry("NUI Warning: " + sWarningMessage);
    }
}

//::///////////////////////////////////////////////////////////////////////////
//:: Example 6: Info Message
//::///////////////////////////////////////////////////////////////////////////
//:: Display informational message to player
void Example_Info(object oPC, string sInfoMessage)
{
    string sTitle = "Information";

    int nToken = NUI_PopupInfo(oPC, sTitle, sInfoMessage);

    if (nToken > 0) {
        WriteTimestampedLogEntry("NUI Info: " + sInfoMessage);
    }
}

//::///////////////////////////////////////////////////////////////////////////
//:: Example 7: Custom Dialog with NUI_DialogCreate
//::///////////////////////////////////////////////////////////////////////////
//:: Build custom dialog with full control over content and properties
void Example_CustomDialog(object oPC)
{
    // Create custom content
    json jContent = NuiLabel(JsonString("This is a custom dialog using NUI_DialogCreate"),
                            JsonInt(NUI_HALIGN_CENTER),
                            JsonInt(NUI_VALIGN_MIDDLE));

    // Window properties: closable only
    int nProps = NUI_PROP_CLOSABLE;

    // Create dialog
    // Parameters: oPC, title, content, nButtons, geometry, script, nProps, width, height, bAOE
    int nToken = NUI_DialogCreate(oPC, "Custom Dialog", jContent, 1, "", "nui_handler",
                                 nProps, 350.0f, 200.0f, FALSE);

    if (nToken > 0) {
        WriteTimestampedLogEntry("NUI: Custom dialog created for " + GetName(oPC));
    }
}

//::///////////////////////////////////////////////////////////////////////////
//:: Example 8: Dialog with AOE Integration
//::///////////////////////////////////////////////////////////////////////////
//:: Create dialog that auto-closes when player exits AOE
void Example_DialogWithAOE(object oPC)
{
    // Create custom content
    json jContent = NuiLabel(JsonString("This dialog closes when you exit the area"),
                            JsonInt(NUI_HALIGN_CENTER),
                            JsonInt(NUI_VALIGN_MIDDLE));

    // Window properties: closable only
    int nProps = NUI_PROP_CLOSABLE;

    // Create dialog WITH AOE (last parameter = TRUE)
    int nToken = NUI_DialogCreate(oPC, "Area Dialog", jContent, 1, "", "nui_handler",
                                 nProps, 350.0f, 200.0f, NUI_AOE_CLOSE);

    if (nToken > 0) {
        WriteTimestampedLogEntry("NUI: AOE dialog created for " + GetName(oPC));
    }
}

//::///////////////////////////////////////////////////////////////////////////
//:: Example 9: Using Different Property Flags
//::///////////////////////////////////////////////////////////////////////////
//:: Show various window property combinations
void Example_WindowProperties(object oPC)
{
    json jContent = NuiLabel(JsonString("Window with custom properties"),
                            JsonInt(NUI_HALIGN_CENTER),
                            JsonInt(NUI_VALIGN_MIDDLE));

    // Example 1: Bare window (no properties)
    int nToken1 = NUI_DialogCreate(oPC, "Bare Window", jContent, 1, "", "nui_handler",
                                  NUI_PROP_NONE, 300.0f, 150.0f, FALSE);

    // Example 2: Closable and transparent
    int nToken2 = NUI_DialogCreate(oPC, "Closable Window", jContent, 1, "", "nui_handler",
                                  NUI_PROP_CLOSABLE_TRANSPARENT, 300.0f, 150.0f, FALSE);

    // Example 3: All properties enabled
    int nToken3 = NUI_DialogCreate(oPC, "Full Featured", jContent, 1, "", "nui_handler",
                                  NUI_PROP_ALL, 300.0f, 150.0f, FALSE);

    // Example 4: Custom combination (resizable + closable)
    int nCustomProps = NUI_PROP_RESIZABLE | NUI_PROP_CLOSABLE;
    int nToken4 = NUI_DialogCreate(oPC, "Resizable Window", jContent, 1, "", "nui_handler",
                                  nCustomProps, 300.0f, 150.0f, FALSE);
}

//::///////////////////////////////////////////////////////////////////////////
//:: Example 10: Positioning Messages
//::///////////////////////////////////////////////////////////////////////////
//:: Create messages at custom positions
void Example_CustomPosition(object oPC)
{
    string sTitle = "Positioned Message";
    string sMessage = "This message is positioned at X=100, Y=150";

    // NUI_PopupMessage parameters:
    // oPC, sTitle, sMessage, fX, fY, fWidth, fHeight, sScript

    // Position at screen coordinates (100, 150)
    int nToken = NUI_PopupMessage(oPC, sTitle, sMessage,
                                 100.0f,      // fX position
                                 150.0f,      // fY position (raised 15% from 200)
                                 312.5f,      // fWidth
                                 156.25f,     // fHeight
                                 "nui_handler"); // sScript
}

//::///////////////////////////////////////////////////////////////////////////
//:: MAIN ENTRY POINT - Test all examples
//::///////////////////////////////////////////////////////////////////////////
void main()
{
    object oPC = GetFirstPC();

    if (!GetIsPC(oPC)) return;

    // Uncomment examples to test:

    // Example_SimpleMessage(oPC);
    // Example_Sign(oPC, "Notice Board", "Welcome to the server!");
    // Example_Error(oPC, "Something went wrong");
    // Example_Success(oPC, "Quest completed successfully!");
    // Example_Warning(oPC, "Be careful in this area");
    // Example_Info(oPC, "This is informational");
    // Example_CustomDialog(oPC);
    // Example_DialogWithAOE(oPC);
    // Example_WindowProperties(oPC);
    // Example_CustomPosition(oPC);
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
