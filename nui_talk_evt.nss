//::///////////////////////////////////////////////////////////////////////
//:: Carcerian NUI - Talk Event Handler
//:: nui_talk_evt.nss
//::///////////////////////////////////////////////////////////////////////
/*
    SYNOPSIS
        Event handler for NUI talk dialog interactions.
        Routes dialogue choices to appropriate handlers.
    
    DEPENDENCIES
        - nui_api (for NUI constants)
        - nui_talk (for talk API functions)
        - nui_handler (for main event routing)
    
    EXPORTS
        void HandleTalkResponse();
        void HandleTalkBranch();
*/
//::///////////////////////////////////////////////////////////////////////
//:: AUTHOR:   Carcerian
//:: VERSION:  1.0
//:: CREATED:  June 5, 2026
//:: MODIFIED: June 5, 2026 - Initial implementation
//::///////////////////////////////////////////////////////////////////////

#include "nui_api"
#include "nui_talk"

//::///////////////////////////////////////////////////////////////////////
//:: EVENT HANDLERS
//::///////////////////////////////////////////////////////////////////////

/*  HandleTalkResponse
    
    PURPOSE
        Process player dialogue choice.
    
    NOTES
        - Called when player selects a response option
        - Routes to appropriate dialogue script
        - Updates conversation state
*/
void HandleTalkResponse()
{
    object oPC = GetLastUsedBy();
    object oNPC = GetLocalObject(oPC, "nui_talk_npc");
    int nToken = GetLocalInt(oPC, "nui_talk_token");
    int nResponseSelected = 0;  // Would be passed from dialog
    
    if (!GetIsObjectValid(oPC) || !GetIsObjectValid(oNPC))
        return;
    
    // Get selected response data
    string sResponseText = GetLocalString(oPC, "nui_talk_resp_" + IntToString(nResponseSelected));
    string sScript = GetLocalString(oPC, "nui_talk_script_" + IntToString(nResponseSelected));
    string sParam = GetLocalString(oPC, "nui_talk_param_" + IntToString(nResponseSelected));
    
    if (sScript != "")
    {
        // Call the appropriate handler script with parameter
        // This would execute: ExecuteScript(sScript, oPC) with sParam set
    }
    
    // Broadcast if enabled
    if (GetLocalInt(oPC, "nui_talk_broadcast") == 1)
    {
        SpeakString(oPC, sResponseText);
    }
}

/*  HandleTalkBranch
    
    PURPOSE
        Handle dialogue branching (internal state transitions).
    
    NOTES
        - Manages conversation flow
        - Updates NPC response text
        - Clears old responses and adds new ones
*/
void HandleTalkBranch()
{
    object oPC = GetLastUsedBy();
    object oNPC = GetLocalObject(oPC, "nui_talk_npc");
    int nToken = GetLocalInt(oPC, "nui_talk_token");
    
    if (!GetIsObjectValid(oPC) || !GetIsObjectValid(oNPC))
        return;
    
    // Get conversation state
    string sConversation = GetLocalString(oPC, "nui_talk_conversation");
    
    // Clear old responses
    NUI_TalkClearResponses(nToken);
    
    // Add new responses based on conversation state
    // This would populate new dialogue options
}

//::///////////////////////////////////////////////////////////////////////
//:: END OF FILE
//::///////////////////////////////////////////////////////////////////////
