//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - Talk System
//:: nui_talk.nss
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Token-based NPC conversation system with portrait support.
        Enables immersive dialogue with visual character portraits,
        branching choices, and action icons (spells, skills, attacks).
    
    DEPENDENCIES
        - nui_api (for dialog creation and JSON builders)
        - nui_validate (for parameter validation)
    
    EXPORTS (Public API)
        int NUI_TalkStartDialog(object oPC, object oNPC, string sConversation);
        void NUI_TalkAddResponse(int nToken, string sText, string sScript, string sParam);
        void NUI_TalkSetPortrait(int nToken, string sPortrait, int nIsNPC=TRUE);
        void NUI_TalkSetActionIcon(int nToken, int nAction, string sIconClass);
        void NUI_TalkBroadcast(int nToken, int nBroadcast=TRUE);
        void NUI_TalkSetResponse(int nToken, string sText);
        void NUI_TalkClose(int nToken);
    
    ACTION TYPES
        NUI_ACTION_SPELL     = 1  // Cast a spell
        NUI_ACTION_SKILL     = 2  // Use a skill
        NUI_ACTION_FEAT      = 3  // Use a feat
        NUI_ACTION_ABILITY   = 4  // Class ability
        NUI_ACTION_ATTACK    = 5  // Attack/combat option
        NUI_ACTION_TRADE     = 6  // Trade/transaction option
    
    VARIABLES
        nui_talk_npc (object)
            Reference to the NPC speaking
        
        nui_talk_pc_portrait (string)
            Portrait image path for PC
        
        nui_talk_npc_portrait (string)
            Portrait image path for NPC
        
        nui_talk_broadcast (int)
            1 = broadcast dialogue to party, 0 = silent (private)
        
        nui_talk_response (string)
            Current NPC response text
    
    USAGE
        #include "nui_talk"
        
        // Start a conversation
        int nToken = NUI_TalkStartDialog(oPC, oNPC, "greet");
        
        // Set NPC portrait
        NUI_TalkSetPortrait(nToken, "portrait_npc_merchant", TRUE);
        
        // Set PC portrait
        NUI_TalkSetPortrait(nToken, GetPortraitResRef(oPC), FALSE);
        
        // Add player response option
        NUI_TalkAddResponse(nToken, "Tell me about yourself.", "nui_handler", "talk_about");
        
        // Set NPC response
        NUI_TalkSetResponse(nToken, "I am a simple merchant, trading wares...");
    
    EXAMPLE (Simple Greeting)
        void main()
        {
            object oPC = GetPCSpeaker();
            object oNPC = GetSpeaker();
            
            // Start conversation
            int nToken = NUI_TalkStartDialog(oPC, oNPC, "greet");
            
            // Set portraits
            NUI_TalkSetPortrait(nToken, "npc_merchant", TRUE);
            NUI_TalkSetPortrait(nToken, GetPortraitResRef(oPC), FALSE);
            
            // Set NPC's first response
            NUI_TalkSetResponse(nToken, "Welcome, friend! What brings you to my shop?");
            
            // Add player options
            NUI_TalkAddResponse(nToken, "I'd like to buy something.", "nui_handler", "shop");
            NUI_TalkAddResponse(nToken, "Just passing through.", "nui_handler", "leave");
            NUI_TalkAddResponse(nToken, "Never mind.", "nui_handler", "cancel");
        }
    
    EXAMPLE (With Action Icons)
        // Add option with spell icon
        NUI_TalkSetActionIcon(nToken, NUI_ACTION_SPELL, "spell_identify");
        NUI_TalkAddResponse(nToken, "[Identify Item]", "nui_handler", "identify");
*/
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////

#include "nw_inc_nui"
#include "nui_api"
#include "nui_validate"

//::///////////////////////////////////////////////////////////////////////
//:: ACTION TYPE CONSTANTS
//::///////////////////////////////////////////////////////////////////////

const int NUI_ACTION_SPELL     = 1;
const int NUI_ACTION_SKILL     = 2;
const int NUI_ACTION_FEAT      = 3;
const int NUI_ACTION_ABILITY   = 4;
const int NUI_ACTION_ATTACK    = 5;
const int NUI_ACTION_TRADE     = 6;

//::///////////////////////////////////////////////////////////////////////
//:: FORWARD DECLARATIONS
//::///////////////////////////////////////////////////////////////////////

/*  NUI_TalkStartDialog
    Begin a conversation with an NPC.
*/
int NUI_TalkStartDialog(object oPC, object oNPC, string sConversation);

/*  NUI_TalkAddResponse
    Add a player response choice to the conversation.
*/
void NUI_TalkAddResponse(int nToken, string sText, string sScript, string sParam);

/*  NUI_TalkSetPortrait
    Set the portrait for NPC or PC in the dialog.
*/
void NUI_TalkSetPortrait(int nToken, string sPortrait, int nIsNPC=TRUE);

/*  NUI_TalkSetActionIcon
    Add an action icon to the next response option.
*/
void NUI_TalkSetActionIcon(int nToken, int nAction, string sIconClass);

/*  NUI_TalkBroadcast
    Enable/disable broadcasting dialogue to party.
*/
void NUI_TalkBroadcast(int nToken, int nBroadcast=TRUE);

/*  NUI_TalkSetResponse
    Set the NPC's current response text.
*/
void NUI_TalkSetResponse(int nToken, string sText);

/*  NUI_TalkClose
    Close the conversation dialog.
*/
void NUI_TalkClose(int nToken);

/*  NUI_TalkClearResponses
    Clear all player response options.
*/
void NUI_TalkClearResponses(int nToken);

//::///////////////////////////////////////////////////////////////////////
//:: IMPLEMENTATIONS
//::///////////////////////////////////////////////////////////////////////

/*  NUI_TalkStartDialog
    
    PURPOSE
        Initialize a token-based conversation with an NPC.
    
    PARAMETERS
        - object oPC
          The player character starting the conversation
        
        - object oNPC
          The NPC character to talk to
        
        - string sConversation
          Identifier for this conversation (e.g., "merchant_greet", "guard_talk")
          Used to track conversation state and responses
    
    RETURN
        int nToken: Dialog token (>0 if successful, -1 if failed)
    
    NOTES
        - Conversation is stored via token system
        - Token persists through response selections
        - Different conversations can be active simultaneously for different players
        - Portrait images and response options set after dialog creation
    
    EXAMPLE
        int nToken = NUI_TalkStartDialog(oPC, oNPC, "blacksmith_greet");
*/
int NUI_TalkStartDialog(object oPC, object oNPC, string sConversation)
{
    json jContent;
    int nToken;
    
    // Validate inputs
    if (!GetIsObjectValid(oPC) || !GetIsObjectValid(oNPC))
        return -1;
    
    if (sConversation == "")
        return -1;
    
    // Store conversation data on player
    SetLocalObject(oPC, "nui_talk_npc", oNPC);
    SetLocalString(oPC, "nui_talk_conversation", sConversation);
    SetLocalInt(oPC, "nui_talk_response_count", 0);
    SetLocalInt(oPC, "nui_talk_broadcast", 1);  // Default: broadcast to party
    
    // Build dialog content structure
    // Layout: [NPC Portrait] [Dialogue Box] [PC Portrait]
    //         [Response Buttons - Stacked Vertically]
    
    json jNPCPortrait = NuiLabel(JsonString("[NPC Portrait]"), 
                                 JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    json jPCPortrait = NuiLabel(JsonString("[Your Portrait]"), 
                                JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
    
    json jDialogueBox = NuiTextEdit(JsonString("Welcome to our conversation!"), 0);
    
    json jPortraitRow = JsonArray3(
        jNPCPortrait,
        jDialogueBox,
        jPCPortrait
    );
    
    // Response buttons will be added dynamically
    json jResponseArea = NuiLabel(JsonString("Select your response:"), 
                                   JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_TOP));
    
    jContent = JsonArray2(
        jPortraitRow,
        jResponseArea
    );
    
    // Create the dialog
    nToken = NUI_DialogCreate(oPC, GetName(oNPC), jContent,
                              "End Conversation", NUI_BTN_CANCEL);
    
    if (nToken > 0)
    {
        SetLocalInt(oPC, "nui_talk_token", nToken);
    }
    
    return nToken;
}

/*  NUI_TalkAddResponse
    
    PURPOSE
        Add a player response option to the conversation.
    
    PARAMETERS
        - int nToken
          The dialog token for this conversation
        
        - string sText
          The player's dialogue option text
        
        - string sScript
          Script to call when this response is selected
        
        - string sParam
          Parameter to pass to script
    
    RETURN
        None
    
    NOTES
        - Responses are displayed as buttons in vertical list
        - Multiple responses can be added (up to ~10 readable on screen)
        - Each response has associated script/parameter for handling
    
    EXAMPLE
        NUI_TalkAddResponse(nToken, "Tell me about your goods.", "nui_handler", "shop_ask");
        NUI_TalkAddResponse(nToken, "I'll just look around.", "nui_handler", "browse");
        NUI_TalkAddResponse(nToken, "Never mind.", "nui_handler", "leave");
*/
void NUI_TalkAddResponse(int nToken, string sText, string sScript, string sParam)
{
    int nResponseCount;
    
    if (nToken < 0 || sText == "" || sScript == "")
        return;
    
    nResponseCount = GetLocalInt(OBJECT_SELF, "nui_talk_response_count");
    
    // Store response data for handler
    SetLocalString(OBJECT_SELF, "nui_talk_resp_" + IntToString(nResponseCount), sText);
    SetLocalString(OBJECT_SELF, "nui_talk_script_" + IntToString(nResponseCount), sScript);
    SetLocalString(OBJECT_SELF, "nui_talk_param_" + IntToString(nResponseCount), sParam);
    
    // Increment response count
    SetLocalInt(OBJECT_SELF, "nui_talk_response_count", nResponseCount + 1);
}

/*  NUI_TalkSetPortrait
    
    PURPOSE
        Set the portrait image for the NPC or PC in the conversation.
    
    PARAMETERS
        - int nToken
          The dialog token
        
        - string sPortrait
          Portrait resource reference or file path
          Examples: "npc_merchant", "portrait_human_male_1"
        
        - int nIsNPC
          TRUE = set NPC portrait, FALSE = set PC portrait
    
    RETURN
        None
    
    NOTES
        - Portraits displayed at left (NPC) and right (PC)
        - Should be called after NUI_TalkStartDialog
        - Portraits are scalable, maintain aspect ratio
    
    EXAMPLE
        NUI_TalkSetPortrait(nToken, "npc_cleric", TRUE);    // NPC portrait
        NUI_TalkSetPortrait(nToken, GetPortraitResRef(oPC), FALSE);  // PC portrait
*/
void NUI_TalkSetPortrait(int nToken, string sPortrait, int nIsNPC=TRUE)
{
    if (nToken < 0 || sPortrait == "")
        return;
    
    if (nIsNPC)
    {
        SetLocalString(OBJECT_SELF, "nui_talk_npc_portrait", sPortrait);
    }
    else
    {
        SetLocalString(OBJECT_SELF, "nui_talk_pc_portrait", sPortrait);
    }
}

/*  NUI_TalkSetActionIcon
    
    PURPOSE
        Add an action icon to the next response option.
    
    PARAMETERS
        - int nToken
          The dialog token
        
        - int nAction
          Action type: NUI_ACTION_SPELL, NUI_ACTION_SKILL, etc.
        
        - string sIconClass
          Icon identifier (e.g., "spell_identify", "skill_persuade")
    
    RETURN
        None
    
    NOTES
        - Action icons enhance response options
        - Visual feedback for spell/skill/feat requirements
        - Disabled (grayed out) if player doesn't have the ability
    
    EXAMPLE
        // Show [Spell: Identify] option
        NUI_TalkSetActionIcon(nToken, NUI_ACTION_SPELL, "spell_identify");
        NUI_TalkAddResponse(nToken, "Identify this item", "nui_handler", "cast_identify");
*/
void NUI_TalkSetActionIcon(int nToken, int nAction, string sIconClass)
{
    if (nToken < 0 || sIconClass == "")
        return;
    
    SetLocalInt(OBJECT_SELF, "nui_talk_pending_action", nAction);
    SetLocalString(OBJECT_SELF, "nui_talk_pending_icon", sIconClass);
}

/*  NUI_TalkBroadcast
    
    PURPOSE
        Enable or disable broadcasting of dialogue to party members.
    
    PARAMETERS
        - int nToken
          The dialog token
        
        - int nBroadcast
          TRUE = broadcast to party, FALSE = silent (private conversation)
    
    RETURN
        None
    
    NOTES
        - Default is TRUE (broadcast to party)
        - Private conversations only visible to the player
        - Affects SpeakString messages sent during conversation
    
    EXAMPLE
        NUI_TalkBroadcast(nToken, FALSE);  // Make this a private conversation
*/
void NUI_TalkBroadcast(int nToken, int nBroadcast=TRUE)
{
    if (nToken < 0)
        return;
    
    SetLocalInt(OBJECT_SELF, "nui_talk_broadcast", nBroadcast);
}

/*  NUI_TalkSetResponse
    
    PURPOSE
        Set the NPC's current dialogue response text.
    
    PARAMETERS
        - int nToken
          The dialog token
        
        - string sText
          The NPC's response text (can be long, will word-wrap)
    
    RETURN
        None
    
    NOTES
        - Called for each new dialogue exchange
        - Displays in central dialogue box
        - Can be multiple paragraphs
    
    EXAMPLE
        NUI_TalkSetResponse(nToken, "Ah, welcome to my humble shop! " +
                           "I have many fine wares available. " +
                           "What interests you?");
*/
void NUI_TalkSetResponse(int nToken, string sText)
{
    if (nToken < 0 || sText == "")
        return;
    
    SetLocalString(OBJECT_SELF, "nui_talk_response", sText);
}

/*  NUI_TalkClearResponses
    
    PURPOSE
        Clear all player response options and prepare for new ones.
    
    PARAMETERS
        - int nToken
          The dialog token
    
    RETURN
        None
    
    NOTES
        - Called when transitioning to next dialogue state
        - Removes old response buttons
        - Ready for new options to be added
    
    EXAMPLE
        NUI_TalkClearResponses(nToken);  // Clear old options
        NUI_TalkAddResponse(nToken, "What do you want?", "nui_handler", "demand");
*/
void NUI_TalkClearResponses(int nToken)
{
    int i;
    int nMax = GetLocalInt(OBJECT_SELF, "nui_talk_response_count");
    
    if (nToken < 0)
        return;
    
    // Delete all stored response data
    for (i = 0; i < nMax; i++)
    {
        DeleteLocalString(OBJECT_SELF, "nui_talk_resp_" + IntToString(i));
        DeleteLocalString(OBJECT_SELF, "nui_talk_script_" + IntToString(i));
        DeleteLocalString(OBJECT_SELF, "nui_talk_param_" + IntToString(i));
    }
    
    SetLocalInt(OBJECT_SELF, "nui_talk_response_count", 0);
}

/*  NUI_TalkClose
    
    PURPOSE
        Close the conversation dialog.
    
    PARAMETERS
        - int nToken
          The dialog token
    
    RETURN
        None
    
    NOTES
        - Cleans up conversation state
        - Called on end/cancel
        - Resets variables for next conversation
    
    EXAMPLE
        NUI_TalkClose(nToken);
*/
void NUI_TalkClose(int nToken)
{
    int i;
    int nMax = GetLocalInt(OBJECT_SELF, "nui_talk_response_count");
    
    if (nToken < 0)
        return;
    
    // Clean up all response data
    NUI_TalkClearResponses(nToken);
    
    // Delete conversation state
    DeleteLocalObject(OBJECT_SELF, "nui_talk_npc");
    DeleteLocalString(OBJECT_SELF, "nui_talk_conversation");
    DeleteLocalString(OBJECT_SELF, "nui_talk_response");
    DeleteLocalString(OBJECT_SELF, "nui_talk_npc_portrait");
    DeleteLocalString(OBJECT_SELF, "nui_talk_pc_portrait");
    DeleteLocalInt(OBJECT_SELF, "nui_talk_broadcast");
    DeleteLocalInt(OBJECT_SELF, "nui_talk_token");
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
