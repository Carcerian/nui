#include "nui_api_popup"

void main()
{
    object oPC = GetLastUsedBy();
    string sTag = GetTag(OBJECT_SELF);
    int iTest = StringToInt(sTag);
    switch (iTest)
    {
        case 1:
        {
            NUI_PopupMessage(oPC, "A Message", "A Message for you!");
            return;
        }
        case 2:
        {
            NUI_PopupSign(oPC);
            return;
        }
        default: {SendMessageToPC(oPC, "Test "+ sTag + " not found."); return;}
    }
}
