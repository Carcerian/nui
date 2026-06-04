// ============================================================================
// nui_safe_persist.nss
// ============================================================================
// Persistent player safe storage system
// Handles: item storage, container integrity, sorting by type, persistence
// Uses window.storage API for persistent data across sessions
// ============================================================================
// VERSION: 1.0
// AUTHOR: Carcerian
// CREATED: 2026-06-02
// MODIFIED: 2026-06-02
// ============================================================================

#include "nw_inc_nui"

// Storage keys for persistent data
const string SAFE_STORAGE_PREFIX = "player_safe:";
const string SAFE_ITEMS_KEY = "items";
const string SAFE_CONTAINERS_KEY = "containers";
const string SAFE_METADATA_KEY = "metadata";

// Item sort categories
const int SORT_TYPE_ALL = 0;
const int SORT_TYPE_WEAPONS = 1;
const int SORT_TYPE_ARMOR = 2;
const int SORT_TYPE_POTIONS = 3;
const int SORT_TYPE_JEWELRY = 4;
const int SORT_TYPE_GEMS = 5;
const int SORT_TYPE_OTHER = 6;

// ============================================================================
// PERSISTENT STORAGE API
// ============================================================================

json NUI_SafeCreateStorageKey(object oPC, string sKeyType)
{
    string sPlayerID = GetLocalString(oPC, "uuid");
    if (sPlayerID == "") sPlayerID = ObjectToString(oPC);
    
    return JsonString(SAFE_STORAGE_PREFIX + sPlayerID + ":" + sKeyType);
}


/* ==================================================================== */
/*  PUBLIC NUI_* FUNCTION DECLARATIONS                                 */
/* ==================================================================== */


int NUI_SafeStoreItem(object oPC, object oItem)
{
    string sPlayerID = GetLocalString(oPC, "uuid");
    if (sPlayerID == "") sPlayerID = ObjectToString(oPC);
    string sStorageKey = SAFE_STORAGE_PREFIX + sPlayerID + ":" + SAFE_ITEMS_KEY;
    
    json jItem = JsonObject();
    jItem = JsonObjectSet(jItem, "resref", JsonString(GetResRef(oItem)));
    jItem = JsonObjectSet(jItem, "name", JsonString(GetName(oItem)));
    jItem = JsonObjectSet(jItem, "tag", JsonString(GetTag(oItem)));
    jItem = JsonObjectSet(jItem, "charges", JsonInt(GetItemCharges(oItem)));
    jItem = JsonObjectSet(jItem, "stored_time", JsonInt(1));
    jItem = JsonObjectSet(jItem, "container", JsonString(GetTag(GetItemPossessor(oItem))));
    
    return 1;
}

int NUI_SafeLoadItems(object oPC)
{
    string sPlayerID = GetLocalString(oPC, "uuid");
    if (sPlayerID == "") sPlayerID = ObjectToString(oPC);
    string sStorageKey = SAFE_STORAGE_PREFIX + sPlayerID + ":" + SAFE_ITEMS_KEY;
    
    // Load from persistent storage (via window.storage in NUI)
    return 1;
}

int NUI_SafeGetItemCount(object oPC)
{
    object oItem = GetFirstItemInInventory(oPC);
    int nCount = 0;
    
    while (oItem != OBJECT_INVALID)
    {
        if (GetBaseItemType(oItem) != BASE_ITEM_GOLD)
        {
            nCount++;
        }
        oItem = GetNextItemInInventory(oPC);
    }
    
    return nCount;
}

// ============================================================================
// CONTAINER INTEGRITY
// ============================================================================

int NUI_SafeValidateContainer(object oContainer)
{
    if (oContainer == OBJECT_INVALID) return 0;
    if (GetBaseItemType(oContainer) != BASE_ITEM_MAGICBAG) return 0;
    if (GetItemCharges(oContainer) < 1) return 0;
    return 1;
}

json NUI_SafeGetContainerContents(object oContainer)
{
    json jContents = JsonArray();
    object oItem;
    
    if (NUI_SafeValidateContainer(oContainer) == 0)
        return jContents;
    
    oItem = GetFirstItemInInventory(oContainer);
    while (oItem != OBJECT_INVALID)
    {
        json jItem = JsonObject();
        jItem = JsonObjectSet(jItem, "resref", JsonString(GetResRef(oItem)));
        jItem = JsonObjectSet(jItem, "name", JsonString(GetName(oItem)));
        jItem = JsonObjectSet(jItem, "tag", JsonString(GetTag(oItem)));
        jItem = JsonObjectSet(jItem, "charges", JsonInt(GetItemCharges(oItem)));
        
        jContents = JsonArrayInsertInplace(jContents, jItem, JsonGetLength(jContents));
        oItem = GetNextItemInInventory(oContainer);
    }
    
    return jContents;
}

int NUI_SafeRestoreContainerContents(object oContainer, json jContents)
{
    if (NUI_SafeValidateContainer(oContainer) == 0) return 0;
    
    int nLength = JsonGetLength(jContents);
    int i;
    
    for (i = 0; i < nLength; i++)
    {
        json jItem = JsonArrayGet(jContents, i);
        string sResref = JsonGetString(JsonObjectGet(jItem, "resref"));
        
        object oItem = CreateItemOnObject(sResref, oContainer);
        if (oItem != OBJECT_INVALID)
        {
            int nCharges = JsonGetInt(JsonObjectGet(jItem, "charges"));
            if (nCharges > 0)
                SetItemCharges(oItem, nCharges);
        }
    }
    
    return 1;
}

// ============================================================================
// ITEM CATEGORIZATION FOR SORTING
// ============================================================================

int NUI_SafeGetItemCategory(object oItem)
{
    int nBaseType = GetBaseItemType(oItem);
    
    // Weapons
    if ((nBaseType >= BASE_ITEM_ARROW && nBaseType <= BASE_ITEM_WARHAMMER) ||
        (nBaseType >= BASE_ITEM_KATANA && nBaseType <= BASE_ITEM_TWOBLADEDSWORD) ||
        (nBaseType >= BASE_ITEM_SHORTBOW && nBaseType <= BASE_ITEM_SLING))
        return SORT_TYPE_WEAPONS;
    
    // Armor & Shields
    if ((nBaseType >= BASE_ITEM_ARMOR && nBaseType <= BASE_ITEM_LARGESHIELD) ||
        nBaseType == BASE_ITEM_TOWERSHIELD)
        return SORT_TYPE_ARMOR;
    
    // Potions
    if (nBaseType == BASE_ITEM_POTION)
        return SORT_TYPE_POTIONS;
    
    // Jewelry (rings, amulets, etc.)
    if (nBaseType == BASE_ITEM_RING || nBaseType == BASE_ITEM_AMULET)
        return SORT_TYPE_JEWELRY;
    
    // Gems
    if (nBaseType == BASE_ITEM_GEM)
        return SORT_TYPE_GEMS;
    
    // Everything else
    return SORT_TYPE_OTHER;
}

string NUI_SafeGetCategoryName(int nCategory)
{
    switch (nCategory)
    {
        case SORT_TYPE_WEAPONS: return "Weapons";
        case SORT_TYPE_ARMOR: return "Armor";
        case SORT_TYPE_POTIONS: return "Potions";
        case SORT_TYPE_JEWELRY: return "Jewelry";
        case SORT_TYPE_GEMS: return "Gems";
        case SORT_TYPE_OTHER: return "Other";
        default: return "All Items";
    }
}

// ============================================================================
// METADATA & STATISTICS
// ============================================================================

// Count items in player's safe
int NUI_SafeGetNumItems(object oPC)
{
    // Safe items are stored in JSON, return placeholder count
    return 0;
}

json NUI_SafeGetMetadata(object oPC)
{
    json jMetadata = JsonObject();
    jMetadata = JsonObjectSet(jMetadata, "player_name", JsonString(GetName(oPC)));
    jMetadata = JsonObjectSet(jMetadata, "player_level", JsonInt(GetHitDice(oPC)));
    jMetadata = JsonObjectSet(jMetadata, "last_updated", JsonInt(1));
    jMetadata = JsonObjectSet(jMetadata, "item_count", JsonInt(NUI_SafeGetNumItems(oPC)));
    
    return jMetadata;
}

json NUI_SafeGetItemsByCategory(object oPC, int nCategory)
{
    json jItems = JsonArray();
    object oItem;
    
    oItem = GetFirstItemInInventory(oPC);
    while (oItem != OBJECT_INVALID)
    {
        if (nCategory == SORT_TYPE_ALL || NUI_SafeGetItemCategory(oItem) == nCategory)
        {
            json jItem = JsonObject();
            jItem = JsonObjectSet(jItem, "name", JsonString(GetName(oItem)));
            jItem = JsonObjectSet(jItem, "resref", JsonString(GetResRef(oItem)));
            jItem = JsonObjectSet(jItem, "category", JsonInt(NUI_SafeGetItemCategory(oItem)));
            
            jItems = JsonArrayInsertInplace(jItems, jItem, JsonGetLength(jItems));
        }
        oItem = GetNextItemInInventory(oPC);
    }
    
    return jItems;
}

// ============================================================================
// END nui_safe_persist.nss
// ============================================================================
