// ============================================================================
// nui_tailor_persist.nss
// ============================================================================
// Persistent outfit and armor customization system
// Features: Save/load outfits, categorize by fashion type, gender filtering
// Used by tailor systems, appearance editors, and wardrobe managers
// ============================================================================
// VERSION: 1.0
// AUTHOR: Carcerian
// CREATED: 2026-06-02
// MODIFIED: 2026-06-02
// ============================================================================

#include "nw_inc_nui"

// Outfit storage constants
const string OUTFIT_STORAGE_PREFIX = "outfit:";
const string OUTFIT_DATA_SUFFIX = ":data";
const string OUTFIT_INDEX_SUFFIX = ":index";

// Clothing categories for fashion organization
const int OUTFIT_CATEGORY_CASUAL = 0;
const int OUTFIT_CATEGORY_FORMAL = 1;
const int OUTFIT_CATEGORY_COMBAT = 2;
const int OUTFIT_CATEGORY_ROBES = 3;
const int OUTFIT_CATEGORY_EXOTIC = 4;
const int OUTFIT_CATEGORY_CUSTOM = 5;

// Gender filtering for CEP content
const int OUTFIT_GENDER_MALE = 0;
const int OUTFIT_GENDER_FEMALE = 1;
const int OUTFIT_GENDER_BOTH = 2;

// ============================================================================
// OUTFIT STORAGE & PERSISTENCE
// ============================================================================

json NUI_TailorCreateOutfit(object oPC, string sOutfitName, int nCategory)
{
    json jOutfit = JsonObject();
    
    jOutfit = JsonObjectSet(jOutfit, "name", JsonString(sOutfitName));
    jOutfit = JsonObjectSet(jOutfit, "category", JsonInt(nCategory));
    jOutfit = JsonObjectSet(jOutfit, "created_time", JsonInt(1));
    jOutfit = JsonObjectSet(jOutfit, "last_modified", JsonInt(1));
    
    // Clothing items
    jOutfit = JsonObjectSet(jOutfit, "chest", JsonString(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC) != OBJECT_INVALID ? 
        GetResRef(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) : ""));
    jOutfit = JsonObjectSet(jOutfit, "legs", JsonString(GetItemInSlot(INVENTORY_SLOT_LEGS, oPC) != OBJECT_INVALID ? 
        GetResRef(GetItemInSlot(INVENTORY_SLOT_LEGS, oPC)) : ""));
    jOutfit = JsonObjectSet(jOutfit, "feet", JsonString(GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC) != OBJECT_INVALID ? 
        GetResRef(GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC)) : ""));
    jOutfit = JsonObjectSet(jOutfit, "hands", JsonString(GetItemInSlot(INVENTORY_SLOT_GLOVES, oPC) != OBJECT_INVALID ? 
        GetResRef(GetItemInSlot(INVENTORY_SLOT_GLOVES, oPC)) : ""));
    jOutfit = JsonObjectSet(jOutfit, "back", JsonString(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC) != OBJECT_INVALID ? 
        GetResRef(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC)) : ""));
    jOutfit = JsonObjectSet(jOutfit, "head", JsonString(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC) != OBJECT_INVALID ? 
        GetResRef(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC)) : ""));
    
    // Appearance data (if using body appearance editor)
    jOutfit = JsonObjectSet(jOutfit, "body_appearance", JsonInt(GetAppearanceType(oPC)));
    jOutfit = JsonObjectSet(jOutfit, "skin_color", JsonInt(GetColor(oPC, COLOR_CHANNEL_SKIN)));
    jOutfit = JsonObjectSet(jOutfit, "hair_color", JsonInt(GetColor(oPC, COLOR_CHANNEL_HAIR)));
    jOutfit = JsonObjectSet(jOutfit, "hair_type", JsonInt(GetColor(oPC, COLOR_CHANNEL_HEAD)));
    
    return jOutfit;
}


/* ==================================================================== */
/*  PUBLIC NUI_* FUNCTION DECLARATIONS                                 */
/* ==================================================================== */


int NUI_TailorSaveOutfit(object oPC, string sOutfitName, int nCategory)
{
    string sPlayerID = GetLocalString(oPC, "uuid");
    if (sPlayerID == "") sPlayerID = ObjectToString(oPC);
    
    json jOutfit = NUI_TailorCreateOutfit(oPC, sOutfitName, nCategory);
    
    // Save individual outfit
    string sOutfitKey = OUTFIT_STORAGE_PREFIX + sPlayerID + ":" + sOutfitName + OUTFIT_DATA_SUFFIX;
    SetLocalJson(oPC, sOutfitKey, jOutfit);
    
    // Add to outfit index
    string sIndexKey = OUTFIT_STORAGE_PREFIX + sPlayerID + OUTFIT_INDEX_SUFFIX;
    json jIndex = GetLocalJson(oPC, sIndexKey);
    if (JsonGetType(jIndex) == JSON_TYPE_NULL)
        jIndex = JsonArray();
    
    json jIndexEntry = JsonObject();
    jIndexEntry = JsonObjectSet(jIndexEntry, "name", JsonString(sOutfitName));
    jIndexEntry = JsonObjectSet(jIndexEntry, "category", JsonInt(nCategory));
    jIndexEntry = JsonObjectSet(jIndexEntry, "saved_at", JsonInt(1));
    
    jIndex = JsonArrayInsertInplace(jIndex, jIndexEntry, JsonGetLength(jIndex));
    SetLocalJson(oPC, sIndexKey, jIndex);
    
    return 1;
}

json NUI_TailorLoadOutfit(object oPC, string sOutfitName)
{
    string sPlayerID = GetLocalString(oPC, "uuid");
    if (sPlayerID == "") sPlayerID = ObjectToString(oPC);
    
    string sOutfitKey = OUTFIT_STORAGE_PREFIX + sPlayerID + ":" + sOutfitName + OUTFIT_DATA_SUFFIX;
    json jOutfit = GetLocalJson(oPC, sOutfitKey);
    
    return jOutfit;
}

int NUI_TailorApplyOutfit(object oPC, string sOutfitName)
{
    json jOutfit = NUI_TailorLoadOutfit(oPC, sOutfitName);
    
    if (JsonGetType(jOutfit) == JSON_TYPE_NULL)
        return 0;
    
    // Apply clothing items
    string sChest = JsonGetString(JsonObjectGet(jOutfit, "chest"));
    string sLegs = JsonGetString(JsonObjectGet(jOutfit, "legs"));
    string sFeet = JsonGetString(JsonObjectGet(jOutfit, "feet"));
    string sHands = JsonGetString(JsonObjectGet(jOutfit, "hands"));
    string sBack = JsonGetString(JsonObjectGet(jOutfit, "back"));
    string sHead = JsonGetString(JsonObjectGet(jOutfit, "head"));
    
    // Remove current items
    object oItem;
    oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if (oItem != OBJECT_INVALID) DestroyObject(oItem);
    oItem = GetItemInSlot(INVENTORY_SLOT_LEGS, oPC);
    if (oItem != OBJECT_INVALID) DestroyObject(oItem);
    oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC);
    if (oItem != OBJECT_INVALID) DestroyObject(oItem);
    oItem = GetItemInSlot(INVENTORY_SLOT_GLOVES, oPC);
    if (oItem != OBJECT_INVALID) DestroyObject(oItem);
    oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
    if (oItem != OBJECT_INVALID) DestroyObject(oItem);
    oItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
    if (oItem != OBJECT_INVALID) DestroyObject(oItem);
    
    // Create and equip new items
    if (sChest != "") CreateItemOnObject(sChest, oPC);
    if (sLegs != "") CreateItemOnObject(sLegs, oPC);
    if (sFeet != "") CreateItemOnObject(sFeet, oPC);
    if (sHands != "") CreateItemOnObject(sHands, oPC);
    if (sBack != "") CreateItemOnObject(sBack, oPC);
    if (sHead != "") CreateItemOnObject(sHead, oPC);
    
    // Apply appearance if saved
    int nBodyAppearance = JsonGetInt(JsonObjectGet(jOutfit, "body_appearance"));
    // Note: SetAppearanceType not in standard NWN:EE - body type is determined by character class/race
    
    return 1;
}

int NUI_TailorRenameOutfit(object oPC, string sOldName, string sNewName)
{
    string sPlayerID = GetLocalString(oPC, "uuid");
    if (sPlayerID == "") sPlayerID = ObjectToString(oPC);
    
    // Load outfit with old name
    json jOutfit = NUI_TailorLoadOutfit(oPC, sOldName);
    if (JsonGetType(jOutfit) == JSON_TYPE_NULL)
        return 0;
    
    // Update outfit name
    jOutfit = JsonObjectSet(jOutfit, "name", JsonString(sNewName));
    jOutfit = JsonObjectSet(jOutfit, "last_modified", JsonInt(1));
    
    // Save with new key
    string sNewKey = OUTFIT_STORAGE_PREFIX + sPlayerID + ":" + sNewName + OUTFIT_DATA_SUFFIX;
    SetLocalJson(oPC, sNewKey, jOutfit);
    
    // Delete old key
    string sOldKey = OUTFIT_STORAGE_PREFIX + sPlayerID + ":" + sOldName + OUTFIT_DATA_SUFFIX;
    SetLocalJson(oPC, sOldKey, JsonNull());
    
    // Update index
    string sIndexKey = OUTFIT_STORAGE_PREFIX + sPlayerID + OUTFIT_INDEX_SUFFIX;
    json jIndex = GetLocalJson(oPC, sIndexKey);
    
    int nLength = JsonGetLength(jIndex);
    int i = 0;
    while (i < nLength)
    {
        json jEntry = JsonArrayGet(jIndex, i);
        if (JsonGetString(JsonObjectGet(jEntry, "name")) == sOldName)
        {
            jEntry = JsonObjectSet(jEntry, "name", JsonString(sNewName));
            jIndex = JsonArraySet(jIndex, i, jEntry);
            i = nLength; // Break equivalent
        }
        else
        {
            i++;
        }
    }
    
    SetLocalJson(oPC, sIndexKey, jIndex);
    
    return 1;
}

int NUI_TailorDeleteOutfit(object oPC, string sOutfitName)
{
    string sPlayerID = GetLocalString(oPC, "uuid");
    if (sPlayerID == "") sPlayerID = ObjectToString(oPC);
    
    string sOutfitKey = OUTFIT_STORAGE_PREFIX + sPlayerID + ":" + sOutfitName + OUTFIT_DATA_SUFFIX;
    SetLocalJson(oPC, sOutfitKey, JsonNull());
    
    // Remove from index
    string sIndexKey = OUTFIT_STORAGE_PREFIX + sPlayerID + OUTFIT_INDEX_SUFFIX;
    json jIndex = GetLocalJson(oPC, sIndexKey);
    
    int nLength = JsonGetLength(jIndex);
    int i = 0;
    while (i < nLength)
    {
        json jEntry = JsonArrayGet(jIndex, i);
        if (JsonGetString(JsonObjectGet(jEntry, "name")) == sOutfitName)
        {
            // Rebuild array without this element
            json jNewIndex = JsonArray();
            int j = 0;
            while (j < nLength)
            {
                if (j != i)
                    jNewIndex = JsonArrayInsertInplace(jNewIndex, JsonArrayGet(jIndex, j), JsonGetLength(jNewIndex));
                j++;
            }
            jIndex = jNewIndex;
            i = nLength; // Break equivalent
        }
        else
        {
            i++;
        }
    }
    
    SetLocalJson(oPC, sIndexKey, jIndex);
    
    return 1;
}

json NUI_TailorGetOutfitList(object oPC)
{
    string sPlayerID = GetLocalString(oPC, "uuid");
    if (sPlayerID == "") sPlayerID = ObjectToString(oPC);
    
    string sIndexKey = OUTFIT_STORAGE_PREFIX + sPlayerID + OUTFIT_INDEX_SUFFIX;
    json jIndex = GetLocalJson(oPC, sIndexKey);
    
    if (JsonGetType(jIndex) == JSON_TYPE_NULL)
        return JsonArray();
    
    return jIndex;
}

json NUI_TailorGetOutfitsByCategory(object oPC, int nCategory)
{
    json jAllOutfits = NUI_TailorGetOutfitList(oPC);
    json jFiltered = JsonArray();
    
    int nLength = JsonGetLength(jAllOutfits);
    int i = 0;
    while (i < nLength)
    {
        json jOutfit = JsonArrayGet(jAllOutfits, i);
        if (JsonGetInt(JsonObjectGet(jOutfit, "category")) == nCategory)
            jFiltered = JsonArrayInsertInplace(jFiltered, jOutfit, JsonGetLength(jFiltered));
        i++;
    }
    
    return jFiltered;
}

// ============================================================================
// ARMOR APPEARANCE PERSISTENCE
// ============================================================================

json NUI_ArmorCreateSavestate(object oPC, string sArmorName)
{
    json jArmor = JsonObject();
    
    jArmor = JsonObjectSet(jArmor, "name", JsonString(sArmorName));
    jArmor = JsonObjectSet(jArmor, "saved_time", JsonInt(1));
    
    // Armor items
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if (oArmor != OBJECT_INVALID)
    {
        jArmor = JsonObjectSet(jArmor, "armor_resref", JsonString(GetResRef(oArmor)));
        jArmor = JsonObjectSet(jArmor, "armor_name", JsonString(GetName(oArmor)));
        jArmor = JsonObjectSet(jArmor, "armor_color1", JsonInt(GetColor(oArmor, COLOR_CHANNEL_SKIN)));
        jArmor = JsonObjectSet(jArmor, "armor_color2", JsonInt(GetColor(oArmor, COLOR_CHANNEL_HAIR)));
    }
    
    // Body appearance
    jArmor = JsonObjectSet(jArmor, "body_appearance", JsonInt(GetAppearanceType(oPC)));
    jArmor = JsonObjectSet(jArmor, "skin_color", JsonInt(GetColor(oPC, COLOR_CHANNEL_SKIN)));
    jArmor = JsonObjectSet(jArmor, "hair_color", JsonInt(GetColor(oPC, COLOR_CHANNEL_HAIR)));
    
    return jArmor;
}

int NUI_ArmorSaveAppearance(object oPC, string sArmorName)
{
    string sPlayerID = GetLocalString(oPC, "uuid");
    if (sPlayerID == "") sPlayerID = ObjectToString(oPC);
    
    json jArmor = NUI_ArmorCreateSavestate(oPC, sArmorName);
    string sKey = "armor_appearance:" + sPlayerID + ":" + sArmorName;
    
    SetLocalJson(oPC, sKey, jArmor);
    
    return 1;
}

json NUI_ArmorLoadAppearance(object oPC, string sArmorName)
{
    string sPlayerID = GetLocalString(oPC, "uuid");
    if (sPlayerID == "") sPlayerID = ObjectToString(oPC);
    
    string sKey = "armor_appearance:" + sPlayerID + ":" + sArmorName;
    return GetLocalJson(oPC, sKey);
}

int NUI_ArmorApplyAppearance(object oPC, string sArmorName)
{
    json jArmor = NUI_ArmorLoadAppearance(oPC, sArmorName);
    
    if (JsonGetType(jArmor) == JSON_TYPE_NULL)
        return 0;
    
    // Apply body appearance
    int nBodyAppearance = JsonGetInt(JsonObjectGet(jArmor, "body_appearance"));
    // Note: SetAppearanceType not in standard NWN:EE - body type is determined by character class/race
    
    // Apply colors
    int nSkinColor = JsonGetInt(JsonObjectGet(jArmor, "skin_color"));
    int nHairColor = JsonGetInt(JsonObjectGet(jArmor, "hair_color"));
    
    if (nSkinColor >= 0)
        SetColor(oPC, COLOR_CHANNEL_SKIN, nSkinColor);
    if (nHairColor >= 0)
        SetColor(oPC, COLOR_CHANNEL_HAIR, nHairColor);
    
    return 1;
}

// ============================================================================
// CEP CLOTHING SYSTEM - GENDER FILTERING
// ============================================================================

// Store PC gender preference for filtering
int NUI_SetPCGender(object oPC, int nGender)
{
    if (nGender < OUTFIT_GENDER_MALE || nGender > OUTFIT_GENDER_BOTH)
        return 0;
    
    SetLocalInt(oPC, "outfit_gender_preference", nGender);
    return 1;
}

int NUI_GetPCGender(object oPC)
{
    return GetLocalInt(oPC, "outfit_gender_preference");
}

string NUI_GetGenderName(int nGender)
{
    switch (nGender)
    {
        case OUTFIT_GENDER_MALE: return "Male";
        case OUTFIT_GENDER_FEMALE: return "Female";
        case OUTFIT_GENDER_BOTH: return "Unisex";
        default: return "Unknown";
    }
}

// Clothing item metadata for CEP
json NUI_CreateClothingItem(string sResref, string sName, int nGender, int nCategory)
{
    json jClothing = JsonObject();
    
    jClothing = JsonObjectSet(jClothing, "resref", JsonString(sResref));
    jClothing = JsonObjectSet(jClothing, "name", JsonString(sName));
    jClothing = JsonObjectSet(jClothing, "gender", JsonInt(nGender));
    jClothing = JsonObjectSet(jClothing, "category", JsonInt(nCategory));
    
    return jClothing;
}

json NUI_FilterClothingByGender(json jClothingList, int nGenderFilter)
{
    json jFiltered = JsonArray();
    
    int nLength = JsonGetLength(jClothingList);
    int i = 0;
    while (i < nLength)
    {
        json jItem = JsonArrayGet(jClothingList, i);
        int nGender = JsonGetInt(JsonObjectGet(jItem, "gender"));
        
        // Include if: unisex (BOTH), or matches filter
        if (nGender == OUTFIT_GENDER_BOTH || nGender == nGenderFilter)
            jFiltered = JsonArrayInsertInplace(jFiltered, jItem, JsonGetLength(jFiltered));
        i++;
    }
    
    return jFiltered;
}

json NUI_FilterClothingByCategory(json jClothingList, int nCategory)
{
    json jFiltered = JsonArray();
    
    int nLength = JsonGetLength(jClothingList);
    int i = 0;
    while (i < nLength)
    {
        json jItem = JsonArrayGet(jClothingList, i);
        if (JsonGetInt(JsonObjectGet(jItem, "category")) == nCategory)
            jFiltered = JsonArrayInsertInplace(jFiltered, jItem, JsonGetLength(jFiltered));
        i++;
    }
    
    return jFiltered;
}

json NUI_FilterClothingByGenderAndCategory(json jClothingList, int nGender, int nCategory)
{
    json jByGender = NUI_FilterClothingByGender(jClothingList, nGender);
    return NUI_FilterClothingByCategory(jByGender, nCategory);
}

string NUI_GetCategoryName(int nCategory)
{
    switch (nCategory)
    {
        case OUTFIT_CATEGORY_CASUAL: return "Casual";
        case OUTFIT_CATEGORY_FORMAL: return "Formal";
        case OUTFIT_CATEGORY_COMBAT: return "Combat";
        case OUTFIT_CATEGORY_ROBES: return "Robes";
        case OUTFIT_CATEGORY_EXOTIC: return "Exotic";
        case OUTFIT_CATEGORY_CUSTOM: return "Custom";
        default: return "Other";
    }
}

// ============================================================================
// END nui_tailor_persist.nss
// ============================================================================
