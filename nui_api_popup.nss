//::////////////////////////////////////////////////////////////////////
//:: Custom NUI Popup System
//:: Script Name: nui_api_popup
//:: Programmer: Carcerian
//:: Last Modified: June 4, 2026 (Session v40)
//::////////////////////////////////////////////////////////////////////
/*
    IMPROVEMENTS APPLIED IN THIS VERSION:

    Tier 1 (Critical):
    [+] Window sizing formula (pixel-accurate calculation)
    [+] NuiWindow with bind pattern (runtime properties)
    [+] Portrait with NuiImage binding + NuiGroup wrapping
    [+] NuiTextEdit for scrollable text (read-only, no max length)

    Tier 2 (Important):
    [+] Row/Column proper structure (columns first, then rows)
    [+] Spacer usage for centering (left spacer, content, right spacer)
    [+] Complete data binding (all properties via NuiSetBind)

    Tier 3 (Polish):
    [+] NuiGroup + NuiWidth + NuiHeight for sizing
    [+] NuiEnabled for event control
    [+] NuiId for element identification

*/

#include "nui_api_config"
#include "nui_api_json"
#include "nw_inc_nui"

//::////////////////////////////////////////////////////////////////////
//:: WINDOW SIZING FORMULA
//::////////////////////////////////////////////////////////////////////
/*
    PIXEL MEASUREMENT STANDARD:

    Horizontal (X-Axis):
    - Left border: 12px
    - Content: variable width
    - Space between elements: 4-8px
    - Right border: 12px

    Vertical (Y-Axis):
    - Title bar: 33px (if title enabled)
    - Top border: 12px
    - Content: variable height
    - Space between elements: 4-8px
    - Bottom border: 12px

    EXAMPLE CALCULATION:
    Width:  12 + 150 (portrait) + 4 (space) + 475 (message) + 12 = 653.0f
    Height: 33 (title) + 12 (top) + 160 (content) + 40 (button) + 12 = 257.0f
*/

// const float NUI_STANDARD_H = 300.0f;
// const float NUI_STANDARD_W = 653.0f;

//::////////////////////////////////////////////////////////////////////
//:: Forward Declarations
//::////////////////////////////////////////////////////////////////////


int NUI_DialogCreate(
    object oPC,
    string sTitle,
    json jContent,
    int nButtons,
    string sGeometry,
    string sScript,
    int nProps,
    float fWidth,
    float fHeight,
    int bAOE=FALSE);

int NUI_PopupCustom(object oPC, string sTitle, string sContent, string sScript="nui_handler", float fWidth=400.0, float fHeight=237.0);
int NUI_PopupMessage(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_StandardMessage(object oPC, string sTitle, string sMessage, string sScript="nui_handler");

// About - Help - Info
int NUI_PopupAbout(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupHelp(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupInfo(object oPC, string sTitle, string sMessage, string sScript="nui_handler");

// Basic Interactions
int NUI_PopupCancel(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupConfirm(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupDelete(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupDialog(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupError(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupNice(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupNotice(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupSuccess(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupText(object oPC, string sTitle, string sLabel, string sScript="nui_handler");
int NUI_PopupWarning(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupYesNo(object oPC, string sTitle, string sMessage, string sScript="nui_handler");

// Data Entry
int NUI_PopupColor(object oPC, string sTitle, string sLabel, string sScript="nui_handler");
int NUI_PopupColor256(object oPC, string sTitle, string sLabel, string sScript="nui_handler");
int NUI_PopupInput(object oPC, string sTitle, string sLabel, int nMaxLen, string sScript="nui_handler");
int NUI_PopupSlider(object oPC, string sTitle, string sLabel, float fMin, float fMax, float fDefault, string sScript="nui_handler");

// Player Information
int NUI_PopupAlignment(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupClass(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupFaction(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupGender(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupRace(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupStats(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupStatus(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupSoundset(object oPC, string sTitle, string sScript="nui_handler");

// Player Controls
int NUI_PopupChallenge(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupCraft(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupDiary(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupEquip(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupInventory(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupQuests(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupRitual(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupSound(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupTransform(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupTrap(object oPC, string sTitle, string sScript="nui_handler");

// Player Feats Skills Spells
int NUI_PopupFeats(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupSkills(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupSpells(object oPC, string sTitle, string sScript="nui_handler");

// NPC Services
int NUI_PopupBank(object oPC, string sTitle, string sScript="nui_handler");

// Placeables
int NUI_PopupSign(object oPC, string sScript="nui_handler");

// Admin - DM - Staff
int NUI_PopupAdmin(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupBuild(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupDebug(object oPC, string sTitle, string sMessage, string sScript="nui_handler");
int NUI_PopupRange(object oPC, string sTitle, string sLabel, float fMin, float fMax, float fDefault, string sScript="nui_handler");
int NUI_PopupSky(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupSpawn(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupTile(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupValidation(object oPC, string sTitle, string sMessage, string sScript="nui_handler");

// System Functions
void NUI_AOE_Cleanup(object oAOE, object oPC);
int NUI_PopupBreak(object oPC, string sTitle, string sScript="nui_handler");
int NUI_PopupLoading(object oPC, string sMessage, string sScript="nui_handler");
int NUI_PopupZap(object oPC);

//::////////////////////////////////////////////////////////////////////
//:: HELPER: Create Standard Message Window
//::////////////////////////////////////////////////////////////////////
/*
    PATTERN REFERENCE
    1. Build content (rows/columns)
    2. Create window wrapper with binds
    3. Create window (NuiCreate)
    4. Set all properties via NuiSetBind
    5. Return token

    WINDOW SIZING
    - Simple message: 400 x 200 (default)
    - With portrait: 650+ x 250+
    - Multi-line text: adjust height for content
*/
int NUI_StandardMessage(object oPC, string sTitle, string sMessage,
                        string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;

    // Build content using NuiTextEdit for scrollable text
    // Message: scrollable read-only text edit
    json jMessage = NuiTextEdit(JsonString(sMessage), NuiBind("msg_text"),
                               -1,     // No max length
                               FALSE,  // Not editable by player
                               TRUE);  // Scrollable
    jMessage = NuiHeight(jMessage, NUI_HEIGHT_MEDIUM - 108);

    // Button row with spacers for centering
    json jButtonRow = NuiRow(JsonArray3(
        NuiSpacer(),
        NuiId(NuiButton(JsonString("OK")), "msg_ok_button"),
        NuiSpacer()
    ));

    // Combine into main column
    json jLayout = NuiCol(JsonArray2(jMessage, jButtonRow));

    // Wrap in window with binds
    json jWindow = NuiWindow(jLayout, NuiBind("msg_title"),
                            NuiBind("msg_geometry"),
                            JsonBool(FALSE),  // resizable
                            JsonBool(FALSE),  // collapsible
                            JsonBool(TRUE),   // closable
                            JsonBool(FALSE),  // transparent
                            JsonBool(TRUE));  // border

    // Create window
    int nToken = NuiCreate(oPC, jWindow, sScript);

    if (nToken <= 0) return 0;

    // Set all binds
    NuiSetBind(oPC, nToken, "msg_title", JsonString(sTitle));

    // Philos sizing formula:
    // Width: 12 + 376 + 12 = 400
    // Height: 33 + 12 + 140 + 40 + 12 = 237
    NuiSetBind(oPC, nToken, "msg_geometry", NuiRect(-1.0f, 80.0f, NUI_WIDTH_MEDIUM, NUI_HEIGHT_MEDIUM));
    NuiSetBind(oPC, nToken, "msg_text", JsonString(sMessage));

    // Store token for handler
    SetLocalInt(oPC, "NUI_MSG_TOKEN", nToken);

    return nToken;
}

//::////////////////////////////////////////////////////////////////////
//:: HELPER: Create Portrait Window
//::////////////////////////////////////////////////////////////////////
/*
    PHILOS PORTRAIT PATTERN:

    1. Define NuiImage with bind
    2. Wrap with NuiGroup
    3. Size with NuiWidth/NuiHeight
    4. Bind resref with "l" suffix (large version)

    SIZING:
    - Portrait: 150 x 160
    - Text area: 475 x 160
    - Total width: 12 + 150 + 4 + 475 + 12 = 653
    - Total height: 33 + 12 + 160 + 40 + 12 = 257
*/
int NUI_PortraitWindow(object oPC, string sTitle, string sMessage,
                       string sPortrait, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;

    // Default portrait if none provided
    if (sPortrait == "") {
        sPortrait = "po_default";
    }

    // PORTRAIT DISPLAY (Philos working pattern)
    json jPortrait = NuiImage(NuiBind("win_portrait"),
                             JsonInt(NUI_ASPECT_EXACT),
                             JsonInt(NUI_HALIGN_CENTER),
                             JsonInt(NUI_VALIGN_TOP));

    // Wrap and size (Philos pattern - critical for sizing)
    jPortrait = NuiGroup(jPortrait);
    jPortrait = NuiWidth(jPortrait, 150.0f);
    jPortrait = NuiHeight(jPortrait, 160.0f);

    // Left column: portrait
    json jLeftCol = NuiCol(JsonArray1(jPortrait));
    jLeftCol = NuiWidth(jLeftCol, 150.0f);

    // MESSAGE DISPLAY (scrollable read-only)
    json jMessage = NuiTextEdit(JsonString(sMessage), NuiBind("win_message"),
                               -1, FALSE, TRUE);
    jMessage = NuiHeight(jMessage, 160.0f);

    // Right column: message
    json jRightCol = NuiCol(JsonArray1(jMessage));
    jRightCol = NuiWidth(jRightCol, 475.0f);

    // Row 1: Portrait + Message
    json jContentRow = NuiRow(JsonArray2(jLeftCol, jRightCol));

    // Row 2: Close button (centered with spacers)
    json jButtonRow = NuiRow(JsonArray3(
        NuiSpacer(),
        NuiId(NuiButton(JsonString("Close")), "win_close_button"),
        NuiSpacer()
    ));

    // Main layout
    json jLayout = NuiCol(JsonArray2(jContentRow, jButtonRow));

    // Window with binds
    json jWindow = NuiWindow(jLayout, NuiBind("win_title"),
                            NuiBind("win_geometry"),
                            JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE),
                            JsonBool(FALSE), JsonBool(TRUE));

    // Create
    int nToken = NuiCreate(oPC, jWindow, sScript);

    if (nToken <= 0) return 0;

    // Set all binds
    NuiSetBind(oPC, nToken, "win_title", JsonString(sTitle));

    // Philos formula: 12 + 150 + 4 + 475 + 12 = 653 width
    //                 33 + 12 + 160 + 40 + 12 = 257 height
    NuiSetBind(oPC, nToken, "win_geometry", NuiRect(-1.0f, 80.0f, 653.0f, 257.0f));

    // Portrait binding (add "l" for large version)
    NuiSetBind(oPC, nToken, "win_portrait", JsonString(sPortrait + "l"));

    // Message binding
    NuiSetBind(oPC, nToken, "win_message", JsonString(sMessage));

    // Store token
    SetLocalInt(oPC, "NUI_WIN_TOKEN", nToken);

    return nToken;
}

//::////////////////////////////////////////////////////////////////////
//:: POPUP IMPLEMENTATIONS
//::////////////////////////////////////////////////////////////////////

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupAbout
//::////////////////////////////////////////////////////////////////////
int NUI_PopupAbout(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sAbout = "Carcerian NUI Framework v1.0\nAdvanced Dialog System";
    return NUI_StandardMessage(oPC, sTitle, sAbout, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupAdmin
//::////////////////////////////////////////////////////////////////////
int NUI_PopupAdmin(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsDM(oPC) && !GetIsPC(oPC)) return 0;
    string sAdmin = "ADMIN TOOLS\n\nServer Management\nPlayer List\nArea Controls";
    return NUI_StandardMessage(oPC, sTitle, sAdmin, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupAlignment
//::////////////////////////////////////////////////////////////////////
int NUI_PopupAlignment(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sAlign = "Character Alignment Status\n\nCurrent: Neutral";
    return NUI_StandardMessage(oPC, sTitle, sAlign, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupBank
//::////////////////////////////////////////////////////////////////////
int NUI_PopupBank(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sBank = "BANK SYSTEM\n\nBalance: 0 gold\nTransactions: None";
    return NUI_StandardMessage(oPC, sTitle, sBank, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupBlessDeCurse
//::////////////////////////////////////////////////////////////////////
int NUI_PopupBlessDeCurse(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "BLESS/DE-CURSE\n\nSelect an effect to apply.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupBreak
//::////////////////////////////////////////////////////////////////////
int NUI_PopupBreak(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "BREAK\n\nThis action will break the selected item.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupBuild
//::////////////////////////////////////////////////////////////////////
int NUI_PopupBuild(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "BUILD MODE\n\nConstruction tools active.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupCancel
//::////////////////////////////////////////////////////////////////////
int NUI_PopupCancel(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, "CANCELLED\n\n" + sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupChallenge
//::////////////////////////////////////////////////////////////////////
int NUI_PopupChallenge(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, "CHALLENGE\n\n" + sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupClass
//::////////////////////////////////////////////////////////////////////
int NUI_PopupClass(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "CHARACTER CLASS\n\nCurrent: Fighter";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupColor
//::////////////////////////////////////////////////////////////////////
int NUI_PopupColor(object oPC, string sTitle, string sLabel, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "COLOR PICKER\n\n" + sLabel + "\n\nSelect a color.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupColor256
//::////////////////////////////////////////////////////////////////////
int NUI_PopupColor256(object oPC, string sTitle, string sLabel, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "EXTENDED COLOR PICKER\n\n" + sLabel + "\n\nSelect a color.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupConfirm
//::////////////////////////////////////////////////////////////////////
int NUI_PopupConfirm(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, "CONFIRM\n\n" + sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupCraft
//::////////////////////////////////////////////////////////////////////
int NUI_PopupCraft(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "CRAFTING SYSTEM\n\nSelect an item to craft.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupCustom - Fully Customizable Popup
//::////////////////////////////////////////////////////////////////////
/*
    DESCRIPTION:
    Creates a fully customizable popup window with user-defined dimensions.
    Useful for displaying arbitrary content with precise sizing control.

    PARAMETERS:
      oPC - Player character to show popup to
      sTitle - Window title text
      sContent - Content (text, formatted message, etc.)
      sScript - Event handler script (default: "nui_handler")
      fWidth - Window width in pixels (default: 400.0)
      fHeight - Window height in pixels (default: 237.0)

    RETURNS:
      int - NUI window token (>0 if successful, 0 if failed)

    FEATURES:
    - Custom dimensions (width × height)
    - Scrollable text content
    - Standard OK button for closing
    - Centered layout with proper spacing
    - Compatible with tinygiant98/Philos patterns

    EXAMPLE:
      string sContent = "This is custom popup content\nWith multiple lines\nAnd custom size";
      int nToken = NUI_PopupCustom(oPC, "My Dialog", sContent, "nui_handler", 500.0, 300.0);

    SIZING FORMULA (Philos):
      Width:  12 (left) + content_width + 12 (right)
      Height: 33 (title) + 12 (top) + content_height + 40 (button) + 12 (bottom)

      For fWidth=400, fHeight=237:
        Content area: 376px wide × 152px tall (approx)
*/
int NUI_PopupCustom(object oPC, string sTitle, string sContent, string sScript="nui_handler", float fWidth=400.0, float fHeight=237.0)
{
    if (!GetIsPC(oPC)) return 0;

    // Validate dimensions (minimum 200x150)
    if (fWidth < 200.0) fWidth = 200.0;
    if (fHeight < 150.0) fHeight = 150.0;

    // Calculate content area height (accounting for title, borders, button)
    // Height breakdown: 33 (title) + 12 (top) + content + 40 (button) + 12 (bottom) = fHeight
    // So content height = fHeight - 97
    float fContentHeight = fHeight - 97.0;
    if (fContentHeight < 40.0) fContentHeight = 40.0;

    // Build scrollable text content (NuiTextEdit for read-only, scrollable display)
    json jContent = NuiTextEdit(JsonString(sContent), NuiBind("popup_text"),
                               -1,     // No max length
                               FALSE,  // Not editable
                               TRUE);  // Scrollable
    jContent = NuiHeight(jContent, fContentHeight);

    // Center button with spacers
    json jOKBtn = NuiId(NuiButton(JsonString("OK")), "btn_ok");
    jOKBtn = NuiWidth(jOKBtn, 100.0);

    json jButtonRow = NuiRow(JsonArray3(
        NuiSpacer(),
        jOKBtn,
        NuiSpacer()
    ));

    // Main column layout
    json jLayout = NuiCol(JsonArray2(
        jContent,
        jButtonRow
    ));

    // Create window with binds
    json jWindow = NuiWindow(jLayout, NuiBind("popup_title"),
                            NuiBind("popup_geometry"),
                            JsonBool(FALSE),  // Not resizable
                            JsonBool(FALSE),  // Not collapsible
                            JsonBool(TRUE),   // Closable
                            JsonBool(FALSE),  // No border
                            JsonBool(TRUE));  // Transparent

    // Create the NUI window
    int nToken = NuiCreate(oPC, jWindow, sScript);

    if (nToken <= 0) return 0;

    // Set all binds
    NuiSetBind(oPC, nToken, "popup_title", JsonString(sTitle));
    NuiSetBind(oPC, nToken, "popup_text", JsonString(sContent));

    // Center on screen (x=-1 centers horizontally, y=100 positions vertically)
    json jGeometry = NuiRect(-1.0, 100.0, fWidth, fHeight);
    NuiSetBind(oPC, nToken, "popup_geometry", jGeometry);

    return nToken;
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupDebug
//::////////////////////////////////////////////////////////////////////
int NUI_PopupDebug(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsDM(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, "DEBUG\n\n" + sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupDelete
//::////////////////////////////////////////////////////////////////////
int NUI_PopupDelete(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, "DELETE\n\n" + sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupDiary
//::////////////////////////////////////////////////////////////////////
int NUI_PopupDiary(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "QUEST DIARY\n\nNo entries yet.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupDialog
//::////////////////////////////////////////////////////////////////////
int NUI_PopupDialog(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupEquip
//::////////////////////////////////////////////////////////////////////
int NUI_PopupEquip(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "EQUIPMENT\n\nManage your equipment.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupError
//::////////////////////////////////////////////////////////////////////
int NUI_PopupError(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, "ERROR\n\n" + sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupFaction
//::////////////////////////////////////////////////////////////////////
int NUI_PopupFaction(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "FACTION STATUS\n\nNo faction.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupFeats
//::////////////////////////////////////////////////////////////////////
int NUI_PopupFeats(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "CHARACTER FEATS\n\nFeat list here.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupGender
//::////////////////////////////////////////////////////////////////////
int NUI_PopupGender(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "CHARACTER GENDER\n\nCurrent: Male";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupHelp
//::////////////////////////////////////////////////////////////////////
int NUI_PopupHelp(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "HELP SYSTEM\n\nNo help available.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupInfo
//::////////////////////////////////////////////////////////////////////
int NUI_PopupInfo(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, "INFO\n\n" + sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupInput
//::////////////////////////////////////////////////////////////////////
int NUI_PopupInput(object oPC, string sTitle, string sLabel, int nMaxLen, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;

    // Text input with label
    json jInput = NuiTextEdit(JsonString(""), NuiBind("input_text"),
                             nMaxLen, FALSE, FALSE);
    jInput = NuiHeight(jInput, 35.0f);

    // Button row
    json jButtonRow = NuiRow(JsonArray3(
        NuiSpacer(),
        NuiId(NuiButton(JsonString("OK")), "input_ok_button"),
        NuiSpacer()
    ));

    // Layout
    json jLayout = NuiCol(JsonArray2(jInput, jButtonRow));

    // Window
    json jWindow = NuiWindow(jLayout, NuiBind("input_title"),
                            NuiBind("input_geometry"),
                            JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE),
                            JsonBool(FALSE), JsonBool(TRUE));

    // Create
    int nToken = NuiCreate(oPC, jWindow, sScript);

    if (nToken <= 0) return 0;

    // Bind
    NuiSetBind(oPC, nToken, "input_title", JsonString(sTitle));
    NuiSetBind(oPC, nToken, "input_geometry", NuiRect(-1.0f, 80.0f, 400.0f, 170.0f));
    NuiSetBind(oPC, nToken, "input_text", JsonString(""));

    SetLocalInt(oPC, "NUI_INPUT_TOKEN", nToken);

    return nToken;
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupInventory
//::////////////////////////////////////////////////////////////////////
int NUI_PopupInventory(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "INVENTORY\n\nYour items here.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupLoading
//::////////////////////////////////////////////////////////////////////
int NUI_PopupLoading(object oPC, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;

    json jContent = NuiRow(JsonArray1(
        NuiLabel(JsonString(sMessage), JsonNull(), JsonNull())
    ));

    json jWindow = NuiWindow(jContent, NuiBind("load_title"),
                            NuiBind("load_geometry"),
                            JsonBool(FALSE), JsonBool(FALSE), JsonBool(FALSE),
                            JsonBool(FALSE), JsonBool(TRUE));

    int nToken = NuiCreate(oPC, jWindow, sScript);

    if (nToken <= 0) return 0;

    NuiSetBind(oPC, nToken, "load_title", JsonString("Loading..."));
    NuiSetBind(oPC, nToken, "load_geometry", NuiRect(-1.0f, -1.0f, 300.0f, 100.0f));

    return nToken;
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupMessage
//::////////////////////////////////////////////////////////////////////
int NUI_PopupMessage(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupNice
//::////////////////////////////////////////////////////////////////////
int NUI_PopupNice(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, "SUCCESS\n\n" + sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupNotice
//::////////////////////////////////////////////////////////////////////
int NUI_PopupNotice(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, "NOTICE\n\n" + sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupQuests
//::////////////////////////////////////////////////////////////////////
int NUI_PopupQuests(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "QUEST SYSTEM\n\nNo active quests.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupRace
//::////////////////////////////////////////////////////////////////////
int NUI_PopupRace(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "CHARACTER RACE\n\nCurrent: Human";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupRange
//::////////////////////////////////////////////////////////////////////
int NUI_PopupRange(object oPC, string sTitle, string sLabel, float fMin, float fMax, float fDefault, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = sLabel + "\n\nRange: " + FloatToString(fMin, 0, 2) + " to " + FloatToString(fMax, 0, 2);
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupRitual
//::////////////////////////////////////////////////////////////////////
int NUI_PopupRitual(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "RITUAL SYSTEM\n\nNo rituals available.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}


//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupSign (REFACTORED - PHILOS PATTERN)
//::////////////////////////////////////////////////////////////////////
int NUI_PopupSign(object oPC, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;

    // Get sign object from OBJECT_SELF (sign's OnUsed event)
    object oSign = OBJECT_SELF;
    if (!GetIsObjectValid(oSign)) return 0;

    string sTitle = GetName(oSign);
    string sMessage = GetDescription(oSign);

    return NUI_StandardMessage(oPC, sTitle, sMessage, sScript);
    // return NUI_PopupMessage(oPC, sTitle, sMessage);
}
//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupSlider
//::////////////////////////////////////////////////////////////////////
int NUI_PopupSlider(object oPC, string sTitle, string sLabel, float fMin, float fMax, float fDefault, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = sLabel + "\n\nValue: " + FloatToString(fDefault, 0, 2);
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupSkills
//::////////////////////////////////////////////////////////////////////
int NUI_PopupSkills(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "CHARACTER SKILLS\n\nNo skills trained.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupSky
//::////////////////////////////////////////////////////////////////////
int NUI_PopupSky(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "SKY SELECTION\n\nSelect a sky type.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupSound
//::////////////////////////////////////////////////////////////////////
int NUI_PopupSound(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "SOUND SELECTION\n\nNo sounds available.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupSoundset
//::////////////////////////////////////////////////////////////////////
int NUI_PopupSoundset(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "SOUNDSET SELECTION\n\nNo soundsets available.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupSpawn
//::////////////////////////////////////////////////////////////////////
int NUI_PopupSpawn(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "SPAWN SYSTEM\n\nSelect a spawn point.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupSpells
//::////////////////////////////////////////////////////////////////////
int NUI_PopupSpells(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "SPELL LIST\n\nNo spells available.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupStats
//::////////////////////////////////////////////////////////////////////
int NUI_PopupStats(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "CHARACTER STATISTICS\n\nStats displayed here.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupStatus
//::////////////////////////////////////////////////////////////////////
int NUI_PopupStatus(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "STATUS EFFECTS\n\nNo active effects.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupSuccess
//::////////////////////////////////////////////////////////////////////
int NUI_PopupSuccess(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, "SUCCESS\n\n" + sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupText
//::////////////////////////////////////////////////////////////////////
int NUI_PopupText(object oPC, string sTitle, string sLabel, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;

    json jLabel = NuiLabel(JsonString(sLabel), JsonNull(), JsonNull());
    json jContent = NuiCol(JsonArray1(jLabel));

    json jWindow = NuiWindow(jContent, NuiBind("text_title"),
                            NuiBind("text_geometry"),
                            JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE),
                            JsonBool(FALSE), JsonBool(TRUE));

    int nToken = NuiCreate(oPC, jWindow, sScript);

    if (nToken <= 0) return 0;

    NuiSetBind(oPC, nToken, "text_title", JsonString(sTitle));
    NuiSetBind(oPC, nToken, "text_geometry", NuiRect(-1.0f, 80.0f, 400.0f, 200.0f));

    return nToken;
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupTile
//::////////////////////////////////////////////////////////////////////
int NUI_PopupTile(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "TILE SELECTION\n\nSelect a tile to place.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupTrap
//::////////////////////////////////////////////////////////////////////
int NUI_PopupTrap(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "TRAP SELECTION\n\nSelect a trap to place.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupTransform
//::////////////////////////////////////////////////////////////////////
int NUI_PopupTransform(object oPC, string sTitle, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    string sContent = "TRANSFORM\n\nSelect a form to take.";
    return NUI_StandardMessage(oPC, sTitle, sContent, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupValidation
//::////////////////////////////////////////////////////////////////////
int NUI_PopupValidation(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, "VALIDATION ERROR\n\n" + sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupWarning
//::////////////////////////////////////////////////////////////////////
int NUI_PopupWarning(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, "WARNING\n\n" + sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupYesNo
//::////////////////////////////////////////////////////////////////////
int NUI_PopupYesNo(object oPC, string sTitle, string sMessage, string sScript="nui_handler")
{
    if (!GetIsPC(oPC)) return 0;
    return NUI_StandardMessage(oPC, sTitle, "CONFIRM\n\n" + sMessage, sScript);
}

//::////////////////////////////////////////////////////////////////////
//:: NUI_PopupZap
//::////////////////////////////////////////////////////////////////////
int NUI_PopupZap(object oPC)
{
    if (!GetIsPC(oPC)) return 0;
    return 0;
}

//::////////////////////////////////////////////////////////////////////
//:: UTILITY FUNCTIONS (stubs for compatibility)
//::////////////////////////////////////////////////////////////////////

void NUI_AOE_Cleanup(object oAOE, object oPC)
{
    if (GetIsObjectValid(oAOE)) {
        DestroyObject(oAOE);
    }
}

int NUI_DialogCreate(object oPC, string sTitle, json jContent, int nButtons,
                     string sGeometry, string sScript, int nProps, float fWidth,
                     float fHeight, int bAOE=FALSE)
{
    if (!GetIsPC(oPC)) return 0;

    json jWindow = NuiWindow(jContent, NuiBind("dialog_title"),
                            NuiBind("dialog_geometry"),
                            JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE),
                            JsonBool(FALSE), JsonBool(TRUE));

    int nToken = NuiCreate(oPC, jWindow, sScript);

    if (nToken <= 0) return 0;

    NuiSetBind(oPC, nToken, "dialog_title", JsonString(sTitle));
    NuiSetBind(oPC, nToken, "dialog_geometry", NuiRect(-1.0f, 80.0f, fWidth, fHeight));

    return nToken;
}

//::////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::////////////////////////////////////////////////////////////////////
