--[[
    
    **********************************
    *          GlobalTurnIn          *
    **********************************

    Author: UcanPatates  

    **********************
    * Version  |  1.1.8  *
    **********************

    -> 1.1.8  : Fixed an oversight in the buying process so it will no longer attempt to buy the same item if you have one or more in your inventory. Also fixed the vendor sell issue for Alexandrian parts.
    -> 1.1.7  : Added buying Lens items from Sabina
    -> 1.1.6  : Added an option to teleport to the FC house for vendor selling.
    -> 1.1.5  : Added automatic Retainer sell (if your sell list was configured beforehand).
    -> 1.1.4  : Fixed unnecessary halving with the turn-in NPC.
    -> 1.1.3  : Added a check for the Automaton Plugin.
    -> 1.1.2  : Updated Automaton for merging stacks.
    -> 1.1.1  : Fixed a crash with GC town teleportation.
    -> 1.1.0  : Added configuration for empty inventory slots.
    -> 1.0.9  : Added the option to buy for the armory first to fill it up.
    -> 1.0.8  : Fixed an issue with Deltascape shops not opening correctly.
    -> 1.0.7  : Added the option to use tickets.
    -> 1.0.6  : Fix for faster buying with two different exchange items.
    -> 1.0.5  : Added Alexandrian Exchange.
    -> 1.0.4  : Added Omega Exchange.
    -> 1.0.3  : Added the ability to continue trying to buy items if it can't do so in one large stack.
    -> 1.0.2  : Fixed the MoveTo function and corrected SelectString without repeat (also fixed the version number issue).
    -> 1.0.1  : Cleaned up the code overall. Great job! -> Ice
    -> 1.0.0  : Looks like it's working! :D
    -> 0.0.1  : Initial testing.


    ***************
    * Description *
    ***************

    This script will Automaticly turn in your Deltascape , Gordian and Alexandrian parts.
    Here is a Tutorial to set up VendorTurnIn :https://discord.com/channels/1001823907193552978/1196163718216679514/1296741709958479945

    *********************
    *  Required Plugins *
    *********************

    -> SomethingNeedDoing (Expanded Edition) [Make sure to press the lua button when you import this] -> https://puni.sh/api/repository/croizat
    -> Teleporter | 1st Party Plugin
    -> Lifestream : https://raw.githubusercontent.com/NightmareXIV/MyDalamudPlugins/main/pluginmaster.json
    -> Deliveroo : https://plugins.carvel.li/
    -> vnavmesh : https://puni.sh/api/repository/veyn
    -> Pandora's Box : https://love.puni.sh/ment.json
    -> Automaton : https://puni.sh/api/repository/croizat (you will need to enable auto merge.)
    
    **************
    *  SETTINGS  *
    **************
]] 

UseTicket = false
-- do you want to use tickets to teleport.


MaxItem = false 
-- do you want your maximize the inventory you have and buy one of a single item? 
-- true = buy one single item to fill up the inventory
-- false = buy 1 of each item (Technically safer, but if you're already farming A4N... >.>

MaxArmory = false
MaxArmoryFreeSlot = 2
-- do you want to fill your armory, MaxItem should be true to use this option.
-- how many empty slots you want.

VendorTurnIn = false
TeleportToFC = false
-- If you DON'T want FC points, and wanna stay off the marketboard
-- use this to sell to your retainer, you'll lose some gil profit in the end, but you'll also stay more off the radar..

--[[

**************
*  Start of  * 
*   Script   *
**************

]]

-- ItemBuyAmounts
HelmBuyAmount = 2
ChestBuyAmount = 4
HandsBuyAmount = 2
LegsBuyAmount = 4
FeetBuyAmount = 2
AccessoryBuyAmount = 1

ItemIdArmoryTable =
{
 -- ArmoryHead = 3201
 -- Deltascape
    [19437] = 3201,
    [19443] = 3201,
    [19449] = 3201,
    [19461] = 3201,
    [19455] = 3201,
    [19467] = 3201,
    [19473] = 3201,
 -- Sigmascape
    [21583] = 3201,
    [21577] = 3201,
    [21571] = 3201,
    [21589] = 3201,
    [21595] = 3201,
    [21601] = 3201,
    [21607] = 3201,
 -- Alphascape
    [23656] = 3201,
    [23650] = 3201,
    [23644] = 3201,
    [23662] = 3201,
    [23668] = 3201,
    [23674] = 3201,
    [23680] = 3201,
 -- Gordian
    [11450] = 3201,
    [11449] = 3201,
    [11448] = 3201,
    [11451] = 3201,
    [11452] = 3201,
    [11453] = 3201,
    [11454] = 3201,
 -- MIDAN
    [14514] = 3201,
    [14513] = 3201,
    [14512] = 3201,
    [14516] = 3201,
    [14515] = 3201,
    [14518] = 3201,
    [14517] = 3201,
 -- Alexandiran
    [16439] = 3201,
    [16433] = 3201,
    [16415] = 3201,
    [16409] = 3201,
    [16403] = 3201,
    [16421] = 3201,
    [16427] = 3201,
-- Edengate
    [11450] = 3201,
    [11449] = 3201,
    [11448] = 3201,
    [11451] = 3201,
    [11452] = 3201,
    [11453] = 3201,
    [11454] = 3201,
 -- Edenverse
    [14514] = 3201,
    [14513] = 3201,
    [14512] = 3201,
    [14516] = 3201,
    [14515] = 3201,
    [14518] = 3201,
    [14517] = 3201,
 -- Edenpromise
    [16439] = 3201,
    [16433] = 3201,
    [16415] = 3201,
    [16409] = 3201,
    [16403] = 3201,
    [16421] = 3201,
    [16427] = 3201,

 -- ArmoryBody = 3202
 -- Deltascape
    [19474] = 3202,
    [19468] = 3202,
    [19462] = 3202,
    [19456] = 3202,
    [19438] = 3202,
    [19444] = 3202,
    [19450] = 3202,
 -- Sigmascape
    [21572] = 3202,
    [21578] = 3202,
    [21584] = 3202,
    [21596] = 3202,
    [21590] = 3202,
    [21608] = 3202,
    [21602] = 3202,
 -- Alphascape
    [23657] = 3202,
    [23651] = 3202,
    [23645] = 3202,
    [23663] = 3202,
    [23669] = 3202,
    [23675] = 3202,
    [23681] = 3202,
 -- Gordian
    [11461] = 3202,
    [11460] = 3202,
    [11459] = 3202,
    [11458] = 3202,
    [11455] = 3202,
    [11456] = 3202,
    [11457] = 3202,
 -- MIDAN
    [14519] = 3202,
    [14520] = 3202,
    [14521] = 3202,
    [14523] = 3202,
    [14522] = 3202,
    [14525] = 3202,
    [14524] = 3202,
 -- Alexandrian
    [16440] = 3202,
    [16434] = 3202,
    [16428] = 3202,
    [16422] = 3202,
    [16404] = 3202,
    [16410] = 3202,
    [16416] = 3202,
-- Edengate
    [11450] = 3202,
    [11449] = 3202,
    [11448] = 3202,
    [11451] = 3202,
    [11452] = 3202,
    [11453] = 3202,
    [11454] = 3202,
 -- Edenverse
    [14514] = 3202,
    [14513] = 3202,
    [14512] = 3202,
    [14516] = 3202,
    [14515] = 3202,
    [14518] = 3202,
    [14517] = 3202,
 -- Edenpromise
    [16439] = 3202,
    [16433] = 3202,
    [16415] = 3202,
    [16409] = 3202,
    [16403] = 3202,
    [16421] = 3202,
    [16427] = 3202,

 --ArmoryHands = 3203
 -- Deltascape
    [19475] = 3203,
    [19469] = 3203,
    [19463] = 3203,
    [19457] = 3203,
    [19439] = 3203,
    [19445] = 3203,
    [19451] = 3203,
 -- Sigmascape
    [21585] = 3203,
    [21579] = 3203,
    [21573] = 3203,
    [21591] = 3203,
    [21597] = 3203,
    [21603] = 3203,
    [21609] = 3203,
 -- Alphascape
    [23658] = 3203,
    [23652] = 3203,
    [23646] = 3203,
    [23664] = 3203,
    [23670] = 3203,
    [23676] = 3203,
    [23682] = 3203,
 -- Gordian
    [11468] = 3203,
    [11467] = 3203,
    [11466] = 3203,
    [11465] = 3203,
    [11462] = 3203,
    [11463] = 3203,
    [11464] = 3203,
 -- MIDAN
    [14526] = 3203,
    [14527] = 3203,
    [14528] = 3203,
    [14530] = 3203,
    [14529] = 3203,
    [14531] = 3203,
    [14532] = 3203,
 -- Alexandrian
    [16441] = 3203,
    [16435] = 3203,
    [16429] = 3203,
    [16423] = 3203,
    [16405] = 3203,
    [16411] = 3203,
    [16417] = 3203,
-- Edengate
    [11450] = 3203,
    [11449] = 3203,
    [11448] = 3203,
    [11451] = 3203,
    [11452] = 3203,
    [11453] = 3203,
    [11454] = 3203,
 -- Edenverse
    [14514] = 3203,
    [14513] = 3203,
    [14512] = 3203,
    [14516] = 3203,
    [14515] = 3203,
    [14518] = 3203,
    [14517] = 3203,
 -- Edenpromise
    [16439] = 3203,
    [16433] = 3203,
    [16415] = 3203,
    [16409] = 3203,
    [16403] = 3203,
    [16421] = 3203,
    [16427] = 3203,

 --ArmoryLegs = 3205
 -- Deltascape
    [19476] = 3205,
    [19470] = 3205,
    [19464] = 3205,
    [19458] = 3205,
    [19440] = 3205,
    [19446] = 3205,
    [19452] = 3205,
 -- Sigmascape
    [21586] = 3205,
    [21580] = 3205,
    [21574] = 3205,
    [21592] = 3205,
    [21598] = 3205,
    [21604] = 3205,
    [21610] = 3205,
 -- Alphascape
    [23659] = 3205,
    [23653] = 3205,
    [23647] = 3205,
    [23665] = 3205,
    [23671] = 3205,
    [23677] = 3205,
    [23683] = 3205,
 -- Gordian
    [11482] = 3205,
    [11481] = 3205,
    [11480] = 3205,
    [11479] = 3205,
    [11476] = 3205,
    [11477] = 3205,
    [11478] = 3205,
 -- MIDAN
    [14540] = 3205,
    [14541] = 3205,
    [14542] = 3205,
    [14543] = 3205,
    [14544] = 3205,
    [14546] = 3205,
    [14545] = 3205,
 -- Alexandrian
    [16442] = 3205,
    [16436] = 3205,
    [16430] = 3205,
    [16424] = 3205,
    [16406] = 3205,
    [16412] = 3205,
    [16418] = 3205,
-- Edengate
    [11450] = 3205,
    [11449] = 3205,
    [11448] = 3205,
    [11451] = 3205,
    [11452] = 3205,
    [11453] = 3205,
    [11454] = 3205,
 -- Edenverse
    [14514] = 3205,
    [14513] = 3205,
    [14512] = 3205,
    [14516] = 3205,
    [14515] = 3205,
    [14518] = 3205,
    [14517] = 3205,
 -- Edenpromise
    [16439] = 3205,
    [16433] = 3205,
    [16415] = 3205,
    [16409] = 3205,
    [16403] = 3205,
    [16421] = 3205,
    [16427] = 3205,
    
 --ArmoryFeets = 3206
 -- Deltascape
    [19477] = 3206,
    [19471] = 3206,
    [19465] = 3206,
    [19459] = 3206,
    [19441] = 3206,
    [19447] = 3206,
    [19453] = 3206,
 -- Sigmascape
    [21587] = 3206,
    [21581] = 3206,
    [21575] = 3206,
    [21593] = 3206,
    [21599] = 3206,
    [21605] = 3206,
    [21611] = 3206,
 -- Alphascape
    [23660] = 3206,
    [23654] = 3206,
    [23648] = 3206,
    [23666] = 3206,
    [23672] = 3206,
    [23678] = 3206,
    [23684] = 3206,
 -- Gordian
    [11489] = 3206,
    [11488] = 3206,
    [11487] = 3206,
    [11486] = 3206,
    [11483] = 3206,
    [11484] = 3206,
    [11485] = 3206,
 -- MIDAN
    [14547] = 3206,
    [14548] = 3206,
    [14549] = 3206,
    [14550] = 3206,
    [14551] = 3206,
    [14552] = 3206,
    [14553] = 3206,
 -- Alexandrian
    [16443] = 3206,
    [16437] = 3206,
    [16431] = 3206,
    [16425] = 3206,
    [16407] = 3206,
    [16413] = 3206,
    [16419] = 3206,
-- Edengate
    [11450] = 3206,
    [11449] = 3206,
    [11448] = 3206,
    [11451] = 3206,
    [11452] = 3206,
    [11453] = 3206,
    [11454] = 3206,
 -- Edenverse
    [14514] = 3206,
    [14513] = 3206,
    [14512] = 3206,
    [14516] = 3206,
    [14515] = 3206,
    [14518] = 3206,
    [14517] = 3206,
 -- Edenpromise
    [16439] = 3206,
    [16433] = 3206,
    [16415] = 3206,
    [16409] = 3206,
    [16403] = 3206,
    [16421] = 3206,
    [16427] = 3206,

 -- ArmoryEar = 3207
 -- Deltascape
    [19479] = 3207,
    [19480] = 3207,
    [19481] = 3207,
    [19483] = 3207,
    [19482] = 3207,
 -- Sigmascape
    [21614] = 3207,
    [21613] = 3207,
    [21615] = 3207,
    [21616] = 3207,
    [21617] = 3207,
 -- Alphascape
    [23687] = 3207,
    [23686] = 3207,
    [23688] = 3207,
    [23689] = 3207,
    [23690] = 3207,
 -- Gordian
    [11490] = 3207,
    [11491] = 3207,
    [11492] = 3207,
    [11494] = 3207,
    [11493] = 3207,
 -- MIDAN
    [14554] = 3207,
    [14555] = 3207,
    [14556] = 3207,
    [14558] = 3207,
    [14557] = 3207,
 -- Alexandrian
    [16449] = 3207,
    [16448] = 3207,
    [16447] = 3207,
    [16445] = 3207,
    [16446] = 3207,
-- Edengate
    [27061] = 3207,
    [27060] = 3207,
    [27059] = 3207,
    [27058] = 3207,
    [27057] = 3207,
 -- Edenverse
    [29163] = 3207,
    [29162] = 3207,
    [29161] = 3207,
    [29160] = 3207,
    [29159] = 3207,
 -- Edenpromise
    [32398] = 3207,
    [32399] = 3207,
    [32400] = 3207,
    [32401] = 3207,
    [32402] = 3207,

 --ArmoryNeck = 3208
 -- Deltascape
    [19484] = 3208,
    [19485] = 3208,
    [19486] = 3208,
    [19488] = 3208,
    [19487] = 3208,
 -- Sigmascape
    [21618] = 3208,
    [21619] = 3208,
    [21620] = 3208,
    [21621] = 3208,
    [21622] = 3208,
 -- Alphascape
    [23691] = 3208,
    [23692] = 3208,
    [23693] = 3208,
    [23694] = 3208,
    [23695] = 3208,
 -- Gordian
    [11495] = 3208,
    [11496] = 3208,
    [11497] = 3208,
    [11499] = 3208,
    [11498] = 3208,
 -- MIDAN
    [14559] = 3208,
    [14560] = 3208,
    [14561] = 3208,
    [14563] = 3208,
    [14562] = 3208,
 -- Alexandrian
    [16450] = 3208,
    [16451] = 3208,
    [16452] = 3208,
    [16454] = 3208,
    [16453] = 3208,
-- Edengate
    [27066] = 3208,
    [27065] = 3208,
    [27064] = 3208,
    [27063] = 3208,
    [27062] = 3208,
 -- Edenverse
    [29164] = 3208,
    [29165] = 3208,
    [29166] = 3208,
    [29167] = 3208,
    [29168] = 3208,
 -- Edenpromise
    [32403] = 3208,
    [32404] = 3208,
    [32405] = 3208,
    [32406] = 3208,
    [32407] = 3208,

 --ArmoryWrist = 3209
 -- Deltascape
    [19489] = 3209,
    [19490] = 3209,
    [19491] = 3209,
    [19493] = 3209,
    [19492] = 3209,
 -- Sigmascape
    [21623] = 3209,
    [21624] = 3209,
    [21625] = 3209,
    [21626] = 3209,
    [21627] = 3209,
    [21607] = 3209,
 -- Alphascape
    [23696] = 3209,
    [23697] = 3209,
    [23698] = 3209,
    [23699] = 3209,
    [23700] = 3209,
 -- Gordian
    [11500] = 3209,
    [11501] = 3209,
    [11502] = 3209,
    [11504] = 3209,
    [11503] = 3209,
 -- MIDAN
    [14564] = 3209,
    [14565] = 3209,
    [14566] = 3209,
    [14568] = 3209,
    [14567] = 3209,
 -- Alexandrian
    [16459] = 3209,
    [16458] = 3209,
    [16457] = 3209,
    [16455] = 3209,
    [16456] = 3209,
-- Edengate
    [27071] = 3209,
    [27070] = 3209,
    [27069] = 3209,
    [27068] = 3209,
    [27067] = 3209,
 -- Edenverse
    [29169] = 3209,
    [29170] = 3209,
    [29171] = 3209,
    [29172] = 3209,
    [29173] = 3209,
 -- Edenpromise
    [32408] = 3209,
    [32409] = 3209,
    [32410] = 3209,
    [32411] = 3209,
    [32412] = 3209,

 --ArmoryRings = 3300
 -- Deltascape
    [19494] = 3300,
    [19495] = 3300,
    [19496] = 3300,
    [19498] = 3300,
    [19497] = 3300,
 -- Sigmascape
    [21628] = 3300,
    [21629] = 3300,
    [21630] = 3300,
    [21631] = 3300,
    [21632] = 3300,
 -- Alphascape
    [23701] = 3300,
    [23702] = 3300,
    [23703] = 3300,
    [23704] = 3300,
    [23705] = 3300,
 -- Gordian
    [11509] = 3300,
    [11508] = 3300,
    [11507] = 3300,
    [11505] = 3300,
    [11506] = 3300,
 -- MIDAN
    [14569] = 3300,
    [14570] = 3300,
    [14571] = 3300,
    [14573] = 3300,
    [14572] = 3300,
 -- Alexandrian
    [16464] = 3300,
    [16463] = 3300,
    [16462] = 3300,
    [16460] = 3300,
    [16461] = 3300,
-- Edengate
    [27073] = 3300,
    [27072] = 3300,
    [27074] = 3300,
    [27075] = 3300,
    [27076] = 3300,
 -- Edenverse
    [29175] = 3300,
    [29174] = 3300,
    [29176] = 3300,
    [29177] = 3300,
    [29178] = 3300,
 -- Edenpromise
    [32414] = 3300,
    [32413] = 3300,
    [32415] = 3300,
    [32416] = 3300,
    [32417] = 3300,
}

------------------------------------------------------------------------------
-- Deltascape item ids / tables
DeltascapeLensID = 19111
DeltascapeShaftID = 19112
DeltascapeCrankID = 19113
DeltascapeSpringID = 19114
DeltascapePedalID = 19115
DeltascapeBoltID = 19117

DeltascapeLensCount = GetItemCount(DeltascapeLensID)
DeltascapeShaftCount = GetItemCount(DeltascapeShaftID)
DeltascapeCrankCount = GetItemCount(DeltascapeCrankID)
DeltascapeSpringCount = GetItemCount(DeltascapeSpringID)
DeltascapePedalCount = GetItemCount(DeltascapePedalID)
DeltascapeBoltCount = GetItemCount(DeltascapeBoltID)

-- Sigmascape item ids / tables
SigmascapeLensID = 21774
SigmascapeShaftID = 21775
SigmascapeCrankID = 21776
SigmascapeSpringID = 21777
SigmascapePedalID = 21778
SigmascapeBoltID = 21780

SigmascapeLensCount = GetItemCount(SigmascapeLensID)
SigmascapeShaftCount = GetItemCount(SigmascapeShaftID)
SigmascapeCrankCount = GetItemCount(SigmascapeCrankID)
SigmascapeSpringCount = GetItemCount(SigmascapeSpringID)
SigmascapePedalCount = GetItemCount(SigmascapePedalID)
SigmascapeBoltCount = GetItemCount(SigmascapeBoltID)

-- Alphascape item ids / tables
AlphascapeLensID = 23963
AlphascapeShaftID = 23964
AlphascapeCrankID = 23965
AlphascapeSpringID = 23966
AlphascapePedalID = 23967
AlphascapeBoltID = 23969

AlphascapeLensCount = GetItemCount(AlphascapeLensID)
AlphascapeShaftCount = GetItemCount(AlphascapeShaftID)
AlphascapeCrankCount = GetItemCount(AlphascapeCrankID)
AlphascapeSpringCount = GetItemCount(AlphascapeSpringID)
AlphascapePedalCount = GetItemCount(AlphascapePedalID)
AlphascapeBoltCount = GetItemCount(AlphascapeBoltID)
------------------------------------------------------------------------------

GelfradusTable =
{
    -----------DELTASCAPE--------------------------
{0, DeltascapeBoltID, AccessoryBuyAmount, 19495, 22,0},
{0, DeltascapeBoltID, AccessoryBuyAmount, 19494, 21,0},
{0, DeltascapeBoltID, AccessoryBuyAmount, 19490, 20,0},
{0, DeltascapeBoltID, AccessoryBuyAmount, 19489, 19,0},
{0, DeltascapeBoltID, AccessoryBuyAmount, 19485, 18,0},
{0, DeltascapeBoltID, AccessoryBuyAmount, 19484, 17,0},
{0, DeltascapeBoltID, AccessoryBuyAmount, 19480, 16,0},
{0, DeltascapeBoltID, AccessoryBuyAmount, 19479, 15,0},
{0, DeltascapePedalID, FeetBuyAmount, 19453, 14,0},
{0, DeltascapePedalID, FeetBuyAmount, 19447, 13,0},
{0, DeltascapePedalID, FeetBuyAmount, 19441, 12,0},
{0, DeltascapeSpringID, LegsBuyAmount, 19452, 11,0},
{0, DeltascapeSpringID, LegsBuyAmount, 19446, 10,0},
{0, DeltascapeSpringID, LegsBuyAmount, 19440, 9,0},
{0, DeltascapeCrankID, HandsBuyAmount, 19451, 8,0},
{0, DeltascapeCrankID, HandsBuyAmount, 19445, 7,0},
{0, DeltascapeCrankID, HandsBuyAmount, 19439, 6,0},
{0, DeltascapeShaftID, ChestBuyAmount, 19450, 5,0},
{0, DeltascapeShaftID, ChestBuyAmount, 19444, 4,0},
{0, DeltascapeShaftID, ChestBuyAmount, 19438, 3,0},
{0 ,DeltascapeLensID,HelmBuyAmount,19449,2,0},
{0 ,DeltascapeLensID,HelmBuyAmount,19443,1,0},
{0 ,DeltascapeLensID,HelmBuyAmount,19437,0,0},
-- shop 2/dow2 
{1, DeltascapeBoltID, AccessoryBuyAmount, 19496, 13,0},
{1, DeltascapeBoltID, AccessoryBuyAmount, 19491, 12,0},
{1, DeltascapeBoltID, AccessoryBuyAmount, 19486, 11,0},
{1, DeltascapeBoltID, AccessoryBuyAmount, 19481, 10,0},
{1, DeltascapePedalID, FeetBuyAmount, 19459, 9,0},
{1, DeltascapePedalID, FeetBuyAmount, 19465, 8,0},
{1, DeltascapeSpringID, LegsBuyAmount, 19458, 7,0},
{1, DeltascapeSpringID, LegsBuyAmount, 19464, 6,0},
{1, DeltascapeCrankID, HandsBuyAmount, 19457, 5,0},
{1, DeltascapeCrankID, HandsBuyAmount, 19463, 4,0},
{1, DeltascapeShaftID, ChestBuyAmount, 19456, 3,0},
{1, DeltascapeShaftID, ChestBuyAmount, 19462, 2,0},
{1, DeltascapeLensID, HelmBuyAmount, 19455, 1,0},
{1, DeltascapeLensID, HelmBuyAmount, 19461, 0,0},
-- shop 3/dom 
{2, DeltascapeBoltID, AccessoryBuyAmount, 19497, 17,0},
{2, DeltascapeBoltID, AccessoryBuyAmount, 19498, 16,0},
{2, DeltascapeBoltID, AccessoryBuyAmount, 19492, 15,0},
{2, DeltascapeBoltID, AccessoryBuyAmount, 19493, 14,0},
{2, DeltascapeBoltID, AccessoryBuyAmount, 19487, 13,0},
{2, DeltascapeBoltID, AccessoryBuyAmount, 19488, 12,0},
{2, DeltascapeBoltID, AccessoryBuyAmount, 19482, 11,0},
{2, DeltascapeBoltID, AccessoryBuyAmount, 19483, 10,0},
{2, DeltascapePedalID, FeetBuyAmount, 19471, 9,0},
{2, DeltascapePedalID, FeetBuyAmount, 19477, 8,0},
{2, DeltascapeSpringID, LegsBuyAmount, 19470, 7,0},
{2, DeltascapeSpringID, LegsBuyAmount, 19476, 6,0},
{2, DeltascapeCrankID, HandsBuyAmount, 19469, 5,0},
{2, DeltascapeCrankID, HandsBuyAmount, 19475, 4,0},
{2, DeltascapeShaftID, ChestBuyAmount, 19468, 3,0},
{2, DeltascapeShaftID, ChestBuyAmount, 19474, 2,0},
{2, DeltascapeLensID, HelmBuyAmount, 19467, 1,0},
{2, DeltascapeLensID, HelmBuyAmount, 19473, 0,0},

    -----------SigmaSCAPE--------------------------
{0, SigmascapeBoltID, AccessoryBuyAmount, 21629, 22,2},
{0, SigmascapeBoltID, AccessoryBuyAmount, 21628, 21,2},
{0, SigmascapeBoltID, AccessoryBuyAmount, 21624, 20,2},
{0, SigmascapeBoltID, AccessoryBuyAmount, 21623, 19,2},
{0, SigmascapeBoltID, AccessoryBuyAmount, 21619, 18,2},
{0, SigmascapeBoltID, AccessoryBuyAmount, 21618, 17,2},
{0, SigmascapeBoltID, AccessoryBuyAmount, 21614, 16,2},
{0, SigmascapeBoltID, AccessoryBuyAmount, 21613, 15,2},
{0, SigmascapePedalID, FeetBuyAmount, 21587, 14,2},
{0, SigmascapePedalID, FeetBuyAmount, 21581, 13,2},
{0, SigmascapePedalID, FeetBuyAmount, 21575, 12,2},
{0, SigmascapeSpringID, LegsBuyAmount, 21586, 11,2},
{0, SigmascapeSpringID, LegsBuyAmount, 21580, 10,2},
{0, SigmascapeSpringID, LegsBuyAmount, 21574, 9,2},
{0, SigmascapeCrankID, HandsBuyAmount, 21585, 8,2},
{0, SigmascapeCrankID, HandsBuyAmount, 21579, 7,2},
{0, SigmascapeCrankID, HandsBuyAmount, 21573, 6,2},
{0, SigmascapeShaftID, ChestBuyAmount, 21584, 5,2},
{0, SigmascapeShaftID, ChestBuyAmount, 21578, 4,2},
{0, SigmascapeShaftID, ChestBuyAmount, 21572, 3,2},
{0, SigmascapeLensID,HelmBuyAmount,21583,2,2},
{0, SigmascapeLensID,HelmBuyAmount,21577,1,2},
{0, SigmascapeLensID,HelmBuyAmount,21571,0,2},
-- shop 2/dow2 
{1, SigmascapeBoltID, AccessoryBuyAmount, 21630, 13,2},
{1, SigmascapeBoltID, AccessoryBuyAmount, 21625, 12,2},
{1, SigmascapeBoltID, AccessoryBuyAmount, 21620, 11,2},
{1, SigmascapeBoltID, AccessoryBuyAmount, 21615, 10,2},
{1, SigmascapePedalID, FeetBuyAmount, 21593, 9,2},
{1, SigmascapePedalID, FeetBuyAmount, 21599, 8,2},
{1, SigmascapeSpringID, LegsBuyAmount, 21592, 7,2},
{1, SigmascapeSpringID, LegsBuyAmount, 21598, 6,2},
{1, SigmascapeCrankID, HandsBuyAmount, 21591, 5,2},
{1, SigmascapeCrankID, HandsBuyAmount, 21597, 4,2},
{1, SigmascapeShaftID, ChestBuyAmount, 21590, 3,2},
{1, SigmascapeShaftID, ChestBuyAmount, 21596, 2,2},
{1, SigmascapeLensID, HelmBuyAmount, 21589, 1,2},
{1, SigmascapeLensID, HelmBuyAmount, 21595, 0,2},
-- shop 3/dom 
{2, SigmascapeBoltID, AccessoryBuyAmount, 21631, 17,2},
{2, SigmascapeBoltID, AccessoryBuyAmount, 21632, 16,2},
{2, SigmascapeBoltID, AccessoryBuyAmount, 21626, 15,2},
{2, SigmascapeBoltID, AccessoryBuyAmount, 21627, 14,2},
{2, SigmascapeBoltID, AccessoryBuyAmount, 21621, 13,2},
{2, SigmascapeBoltID, AccessoryBuyAmount, 21622, 12,2},
{2, SigmascapeBoltID, AccessoryBuyAmount, 21616, 11,2},
{2, SigmascapeBoltID, AccessoryBuyAmount, 21617, 10,2},
{2, SigmascapePedalID, FeetBuyAmount, 21605, 9,2},
{2, SigmascapePedalID, FeetBuyAmount, 21611, 8,2},
{2, SigmascapeSpringID, LegsBuyAmount, 21604, 7,2},
{2, SigmascapeSpringID, LegsBuyAmount, 21610, 6,2},
{2, SigmascapeCrankID, HandsBuyAmount, 21603, 5,2},
{2, SigmascapeCrankID, HandsBuyAmount, 21609, 4,2},
{2, SigmascapeShaftID, ChestBuyAmount, 21602, 3,2},
{2, SigmascapeShaftID, ChestBuyAmount, 21608, 2,2},
{2, SigmascapeLensID, HelmBuyAmount, 21601, 1,2},
{2, SigmascapeLensID, HelmBuyAmount, 21607, 0,2},

-----------ALPHASCAPE--------------------------
{0, AlphascapeBoltID, AccessoryBuyAmount, 23702, 22,4},
{0, AlphascapeBoltID, AccessoryBuyAmount, 23701, 21,4},
{0, AlphascapeBoltID, AccessoryBuyAmount, 23697, 20,4},
{0, AlphascapeBoltID, AccessoryBuyAmount, 23696, 19,4},
{0, AlphascapeBoltID, AccessoryBuyAmount, 23692, 18,4},
{0, AlphascapeBoltID, AccessoryBuyAmount, 23691, 17,4},
{0, AlphascapeBoltID, AccessoryBuyAmount, 23687, 16,4},
{0, AlphascapeBoltID, AccessoryBuyAmount, 23686, 15,4},
{0, AlphascapePedalID, FeetBuyAmount, 23660, 14,4},
{0, AlphascapePedalID, FeetBuyAmount, 23654, 13,4},
{0, AlphascapePedalID, FeetBuyAmount, 23648, 12,4},
{0, AlphascapeSpringID, LegsBuyAmount, 23659, 11,4},
{0, AlphascapeSpringID, LegsBuyAmount, 23653, 10,4},
{0, AlphascapeSpringID, LegsBuyAmount, 23647, 9,4},
{0, AlphascapeCrankID, HandsBuyAmount, 23658, 8,4},
{0, AlphascapeCrankID, HandsBuyAmount, 23652, 7,4},
{0, AlphascapeCrankID, HandsBuyAmount, 23646, 6,4},
{0, AlphascapeShaftID, ChestBuyAmount, 23657, 5,4},
{0, AlphascapeShaftID, ChestBuyAmount, 23651, 4,4},
{0, AlphascapeShaftID, ChestBuyAmount, 23645, 3,4},
{0, AlphascapeLensID,HelmBuyAmount,23656,2,4},
{0, AlphascapeLensID,HelmBuyAmount,23650,1,4},
{0, AlphascapeLensID,HelmBuyAmount,23644,0,4},
-- shop 2/dow2 
{1, AlphascapeBoltID, AccessoryBuyAmount, 23703, 13,4},
{1, AlphascapeBoltID, AccessoryBuyAmount, 23698, 12,4},
{1, AlphascapeBoltID, AccessoryBuyAmount, 23693, 11,4},
{1, AlphascapeBoltID, AccessoryBuyAmount, 23688, 10,4},
{1, AlphascapePedalID, FeetBuyAmount, 23666, 9,4},
{1, AlphascapePedalID, FeetBuyAmount, 23672, 8,4},
{1, AlphascapeSpringID, LegsBuyAmount, 23665, 7,4},
{1, AlphascapeSpringID, LegsBuyAmount, 23671, 6,4},
{1, AlphascapeCrankID, HandsBuyAmount, 23664, 5,4},
{1, AlphascapeCrankID, HandsBuyAmount, 23670, 4,4},
{1, AlphascapeShaftID, ChestBuyAmount, 23663, 3,4},
{1, AlphascapeShaftID, ChestBuyAmount, 23669, 2,4},
{1, AlphascapeLensID, HelmBuyAmount, 23662, 1,4},
{1, AlphascapeLensID, HelmBuyAmount, 23668, 0,4},
-- shop 3/dom 
{2, AlphascapeBoltID, AccessoryBuyAmount, 23704, 17,4},
{2, AlphascapeBoltID, AccessoryBuyAmount, 23705, 16,4},
{2, AlphascapeBoltID, AccessoryBuyAmount, 23699, 15,4},
{2, AlphascapeBoltID, AccessoryBuyAmount, 23700, 14,4},
{2, AlphascapeBoltID, AccessoryBuyAmount, 23694, 13,4},
{2, AlphascapeBoltID, AccessoryBuyAmount, 23695, 12,4},
{2, AlphascapeBoltID, AccessoryBuyAmount, 23689, 11,4},
{2, AlphascapeBoltID, AccessoryBuyAmount, 23690, 10,4},
{2, AlphascapePedalID, FeetBuyAmount, 23678, 9,4},
{2, AlphascapePedalID, FeetBuyAmount, 23684, 8,4},
{2, AlphascapeSpringID, LegsBuyAmount, 23677, 7,4},
{2, AlphascapeSpringID, LegsBuyAmount, 23683, 6,4},
{2, AlphascapeCrankID, HandsBuyAmount, 23676, 5,4},
{2, AlphascapeCrankID, HandsBuyAmount, 23682, 4,4},
{2, AlphascapeShaftID, ChestBuyAmount, 23675, 3,4},
{2, AlphascapeShaftID, ChestBuyAmount, 23681, 2,4},
{2, AlphascapeLensID, HelmBuyAmount, 23674, 1,4},
{2, AlphascapeLensID, HelmBuyAmount, 23680, 0,4},
}
-------------------------------------------------------------------------------- tarnished gordian item ids / tablolar ve idler
GordianLensID = 12674
GordianShaftID = 12675
GordianCrankID = 12676
GordianSpringID = 12677
GordianPedalID = 12678
GordianBoltID = 12680

-- initialize item counts
GordianLensCount = GetItemCount(GordianLensID)
GordianShaftCount = GetItemCount(GordianShaftID)
GordianCrankCount = GetItemCount(GordianCrankID)
GordianSpringCount = GetItemCount(GordianSpringID)
GordianPedalCount = GetItemCount(GordianPedalID)
GordianBoltCount = GetItemCount(GordianBoltID)

-------------------------------------------------------------------------------- tarnished midan item ids / tablolar ve idler
MidanLensID = 14301
MidanShaftID = 14302
MidanCrankID = 14303
MidanSpringID = 14304
MidanPedalID = 14305
MidanBoltID = 14307

-- initialize item counts
MidanLensCount = GetItemCount(MidanLensID)
MidanShaftCount = GetItemCount(MidanShaftID)
MidanCrankCount = GetItemCount(MidanCrankID)
MidanSpringCount = GetItemCount(MidanSpringID)
MidanPedalCount = GetItemCount(MidanPedalID)
MidanBoltCount = GetItemCount(MidanBoltID)
--------------------------------------------------------------------------------Alexandrian part ids 

AlexandrianLensID = 16546
AlexandrianShaftID = 16547
AlexandrianCrankID = 16548
AlexandrianSpringID = 16549
AlexandrianPedalID = 16550
AlexandrianBoltID = 16552

-- initialize item counts
AlexandrianLensCount = GetItemCount(AlexandrianLensID)
AlexandrianShaftCount = GetItemCount(AlexandrianShaftID)
AlexandrianCrankCount = GetItemCount(AlexandrianCrankID)
AlexandrianSpringCount = GetItemCount(AlexandrianSpringID)
AlexandrianPedalCount = GetItemCount(AlexandrianPedalID)
AlexandrianBoltCount = GetItemCount(AlexandrianBoltID)

------------------------------------------------------------------------------

SabinaTable = 
{
----------------------------   GORDIAN   --------------------------------------------
-- shop 1/dow1
{0, GordianBoltID, AccessoryBuyAmount, 11506, 22,0},
{0, GordianBoltID, AccessoryBuyAmount, 11505, 21,0},
{0, GordianBoltID, AccessoryBuyAmount, 11501, 20,0},
{0, GordianBoltID, AccessoryBuyAmount, 11500, 19,0},
{0, GordianBoltID, AccessoryBuyAmount, 11496, 18,0},
{0, GordianBoltID, AccessoryBuyAmount, 11495, 17,0},
{0, GordianBoltID, AccessoryBuyAmount, 11491, 16,0},
{0, GordianBoltID, AccessoryBuyAmount, 11490, 15,0},
{0, GordianPedalID, FeetBuyAmount, 11485, 14,0},
{0, GordianPedalID, FeetBuyAmount, 11484, 13,0},
{0, GordianPedalID, FeetBuyAmount, 11483, 12,0},
{0, GordianSpringID, LegsBuyAmount, 11478, 11,0},
{0, GordianSpringID, LegsBuyAmount, 11477, 10,0},
{0, GordianSpringID, LegsBuyAmount, 11476, 9,0},
{0, GordianCrankID, HandsBuyAmount, 11464, 8,0},
{0, GordianCrankID, HandsBuyAmount, 11463, 7,0},
{0, GordianCrankID, HandsBuyAmount, 11462, 6,0},
{0, GordianShaftID, ChestBuyAmount, 11457, 5,0},
{0, GordianShaftID, ChestBuyAmount, 11456, 4,0},
{0, GordianShaftID, ChestBuyAmount, 11455, 3,0},
{0, GordianLensID, HelmBuyAmount, 11450, 2,0},
{0, GordianLensID, HelmBuyAmount, 11449, 1,0},
{0, GordianLensID, HelmBuyAmount, 11448, 0,0},
-- shop 2/dow2 
{1, GordianBoltID, AccessoryBuyAmount, 11507, 13,0},
{1, GordianBoltID, AccessoryBuyAmount, 11502, 12,0},
{1, GordianBoltID, AccessoryBuyAmount, 11497, 11,0},
{1, GordianBoltID, AccessoryBuyAmount, 11492, 10,0},
{1, GordianPedalID, FeetBuyAmount, 11486, 9,0},
{1, GordianPedalID, FeetBuyAmount, 11487, 8,0},
{1, GordianSpringID, LegsBuyAmount, 11479, 7,0},
{1, GordianSpringID, LegsBuyAmount, 11480, 6,0},
{1, GordianCrankID, HandsBuyAmount, 11465, 5,0},
{1, GordianCrankID, HandsBuyAmount, 11466, 4,0},
{1, GordianShaftID, ChestBuyAmount, 11458, 3,0},
{1, GordianShaftID, ChestBuyAmount, 11459, 2,0},
{1, GordianLensID, HelmBuyAmount, 11451, 1,0},
{1, GordianLensID, HelmBuyAmount, 11452, 0,0},
-- shop 3/dom 
{2, GordianBoltID, AccessoryBuyAmount, 11508, 17,0},
{2, GordianBoltID, AccessoryBuyAmount, 11509, 16,0},
{2, GordianBoltID, AccessoryBuyAmount, 11503, 15,0},
{2, GordianBoltID, AccessoryBuyAmount, 11504, 14,0},
{2, GordianBoltID, AccessoryBuyAmount, 11498, 13,0},
{2, GordianBoltID, AccessoryBuyAmount, 11499, 12,0},
{2, GordianBoltID, AccessoryBuyAmount, 11493, 11,0},
{2, GordianBoltID, AccessoryBuyAmount, 11494, 10,0},
{2, GordianPedalID, FeetBuyAmount, 11488, 9,0},
{2, GordianPedalID, FeetBuyAmount, 11489, 8,0},
{2, GordianSpringID, LegsBuyAmount, 11481, 7,0},
{2, GordianSpringID, LegsBuyAmount, 11482, 6,0},
{2, GordianCrankID, HandsBuyAmount, 11467, 5,0},
{2, GordianCrankID, HandsBuyAmount, 11468, 4,0},
{2, GordianShaftID, ChestBuyAmount, 11460, 3,0},
{2, GordianShaftID, ChestBuyAmount, 11461, 2,0},
{2, GordianLensID, HelmBuyAmount, 11453, 1,0},
{2, GordianLensID, HelmBuyAmount, 11454, 0,0},
----------------------------   MIDAN   -------------------------------------------------
-- Shop 1 / DOW1
{0, MidanBoltID, AccessoryBuyAmount, 14570, 22,2},
{0, MidanBoltID, AccessoryBuyAmount, 14569, 21,2},
{0, MidanBoltID, AccessoryBuyAmount, 14565, 20,2},
{0, MidanBoltID, AccessoryBuyAmount, 14564, 19,2},
{0, MidanBoltID, AccessoryBuyAmount, 14560, 18,2},
{0, MidanBoltID, AccessoryBuyAmount, 14559, 17,2},
{0, MidanBoltID, AccessoryBuyAmount, 14555, 16,2},
{0, MidanBoltID, AccessoryBuyAmount, 14554, 15,2},
{0, MidanPedalID, FeetBuyAmount, 14549, 14,2},
{0, MidanPedalID, FeetBuyAmount, 14548, 13,2},
{0, MidanPedalID, FeetBuyAmount, 14547, 12,2},
{0, MidanSpringID, LegsBuyAmount, 14542, 11,2},
{0, MidanSpringID, LegsBuyAmount, 14541, 10,2},
{0, MidanSpringID, LegsBuyAmount, 14540, 9,2},
{0, MidanCrankID, HandsBuyAmount, 14528, 8,2},
{0, MidanCrankID, HandsBuyAmount, 14527, 7,2},
{0, MidanCrankID, HandsBuyAmount, 14526, 6,2},
{0, MidanShaftID, ChestBuyAmount, 14521, 5,2},
{0, MidanShaftID, ChestBuyAmount, 14520, 4,2},
{0, MidanShaftID, ChestBuyAmount, 14519, 3,2},
{0, MidanLensID,HelmBuyAmount,14514,2,2},
{0, MidanLensID,HelmBuyAmount,14513,1,2},
{0, MidanLensID,HelmBuyAmount,14512,0,2},
-- shop 2/dow2 
{1, MidanBoltID, AccessoryBuyAmount, 14571, 13,2},
{1, MidanBoltID, AccessoryBuyAmount, 14566, 12,2},
{1, MidanBoltID, AccessoryBuyAmount, 14561, 11,2},
{1, MidanBoltID, AccessoryBuyAmount, 14556, 10,2},
{1, MidanPedalID, FeetBuyAmount, 14550, 9,2},
{1, MidanPedalID, FeetBuyAmount, 14551, 8,2},
{1, MidanSpringID, LegsBuyAmount, 14543, 7,2},
{1, MidanSpringID, LegsBuyAmount, 14544, 6,2},
{1, MidanCrankID, HandsBuyAmount, 14529, 5,2},
{1, MidanCrankID, HandsBuyAmount, 14530, 4,2},
{1, MidanShaftID, ChestBuyAmount, 14522, 3,2},
{1, MidanShaftID, ChestBuyAmount, 14523, 2,2},
{1, MidanLensID, HelmBuyAmount, 14515, 1,2},
{1, MidanLensID, HelmBuyAmount, 14516, 0,2},
-- shop 3/dom 
{2, MidanBoltID, AccessoryBuyAmount, 14572, 17,2},
{2, MidanBoltID, AccessoryBuyAmount, 14573, 16,2},
{2, MidanBoltID, AccessoryBuyAmount, 14567, 15,2},
{2, MidanBoltID, AccessoryBuyAmount, 14568, 14,2},
{2, MidanBoltID, AccessoryBuyAmount, 14562, 13,2},
{2, MidanBoltID, AccessoryBuyAmount, 14563, 12,2},
{2, MidanBoltID, AccessoryBuyAmount, 14557, 11,2},
{2, MidanBoltID, AccessoryBuyAmount, 14558, 10,2},
{2, MidanPedalID, FeetBuyAmount, 14552, 9,2},
{2, MidanPedalID, FeetBuyAmount, 14553, 8,2},
{2, MidanSpringID, LegsBuyAmount, 14545, 7,2},
{2, MidanSpringID, LegsBuyAmount, 14546, 6,2},
{2, MidanCrankID, HandsBuyAmount, 14531, 5,2},
{2, MidanCrankID, HandsBuyAmount, 14532, 4,2},
{2, MidanShaftID, ChestBuyAmount, 14524, 3,2},
{2, MidanShaftID, ChestBuyAmount, 14525, 2,2},
{2, MidanLensID, HelmBuyAmount, 14517, 1,2},
{2, MidanLensID, HelmBuyAmount, 14518, 0,2},
    
----------------------------   Alexandrian   --------------------------------------------
{0, AlexandrianBoltID, AccessoryBuyAmount, 16461, 22,4},
{0, AlexandrianBoltID, AccessoryBuyAmount, 16460, 21,4},
{0, AlexandrianBoltID, AccessoryBuyAmount, 16456, 20,4},
{0, AlexandrianBoltID, AccessoryBuyAmount, 16455, 19,4},
{0, AlexandrianBoltID, AccessoryBuyAmount, 16451, 18,4},
{0, AlexandrianBoltID, AccessoryBuyAmount, 16450, 17,4},
{0, AlexandrianBoltID, AccessoryBuyAmount, 16446, 16,4},
{0, AlexandrianBoltID, AccessoryBuyAmount, 16445, 15,4},
{0, AlexandrianPedalID, FeetBuyAmount, 16419, 14,4},
{0, AlexandrianPedalID, FeetBuyAmount, 16413, 13,4},
{0, AlexandrianPedalID, FeetBuyAmount, 16407, 12,4},
{0, AlexandrianSpringID, LegsBuyAmount, 16418, 11,4},
{0, AlexandrianSpringID, LegsBuyAmount, 16412, 10,4},
{0, AlexandrianSpringID, LegsBuyAmount, 16406, 9,4},
{0, AlexandrianCrankID, HandsBuyAmount, 16417, 8,4},
{0, AlexandrianCrankID, HandsBuyAmount, 16411, 7,4},
{0, AlexandrianCrankID, HandsBuyAmount, 16405, 6,4},
{0, AlexandrianShaftID, ChestBuyAmount, 16416, 5,4},
{0, AlexandrianShaftID, ChestBuyAmount, 16410, 4,4},
{0, AlexandrianShaftID, ChestBuyAmount, 16404, 3,4},
{0, AlexandrianLensID,HelmBuyAmount,16415,2,4},
{0, AlexandrianLensID,HelmBuyAmount,16409,1,4},
{0, AlexandrianLensID,HelmBuyAmount,16403,0,4},
-- shop 2/dow2 
{1, AlexandrianBoltID, AccessoryBuyAmount, 16462, 13,4},
{1, AlexandrianBoltID, AccessoryBuyAmount, 16457, 12,4},
{1, AlexandrianBoltID, AccessoryBuyAmount, 16452, 11,4},
{1, AlexandrianBoltID, AccessoryBuyAmount, 16447, 10,4},
{1, AlexandrianPedalID, FeetBuyAmount, 16425, 9,4},
{1, AlexandrianPedalID, FeetBuyAmount, 16431, 8,4},
{1, AlexandrianSpringID, LegsBuyAmount, 16424, 7,4},
{1, AlexandrianSpringID, LegsBuyAmount, 16430, 6,4},
{1, AlexandrianCrankID, HandsBuyAmount, 16423, 5,4},
{1, AlexandrianCrankID, HandsBuyAmount, 16429, 4,4},
{1, AlexandrianShaftID, ChestBuyAmount, 16422, 3,4},
{1, AlexandrianShaftID, ChestBuyAmount, 16428, 2,4},
{1, AlexandrianLensID, HelmBuyAmount, 16421, 1,4},
{1, AlexandrianLensID, HelmBuyAmount, 16427, 0,4},
-- shop 3/dom 
{2, AlexandrianBoltID, AccessoryBuyAmount, 16463, 17,4},
{2, AlexandrianBoltID, AccessoryBuyAmount, 16464, 16,4},
{2, AlexandrianBoltID, AccessoryBuyAmount, 16458, 15,4},
{2, AlexandrianBoltID, AccessoryBuyAmount, 16459, 14,4},
{2, AlexandrianBoltID, AccessoryBuyAmount, 16453, 13,4},
{2, AlexandrianBoltID, AccessoryBuyAmount, 16454, 12,4},
{2, AlexandrianBoltID, AccessoryBuyAmount, 16448, 11,4},
{2, AlexandrianBoltID, AccessoryBuyAmount, 16449, 10,4},
{2, AlexandrianPedalID, FeetBuyAmount, 16437, 9,4},
{2, AlexandrianPedalID, FeetBuyAmount, 16443, 8,4},
{2, AlexandrianSpringID, LegsBuyAmount, 16436, 7,4},
{2, AlexandrianSpringID, LegsBuyAmount, 16442, 6,4},
{2, AlexandrianCrankID, HandsBuyAmount, 16435, 5,4},
{2, AlexandrianCrankID, HandsBuyAmount, 16441, 4,4},
{2, AlexandrianShaftID, ChestBuyAmount, 16434, 3,4},
{2, AlexandrianShaftID, ChestBuyAmount, 16440, 2,4},
{2, AlexandrianLensID, HelmBuyAmount, 16433, 1,4},
{2, AlexandrianLensID, HelmBuyAmount, 16439, 0,4},
}

-------------------------------------------------------------------------------- early antiquity item ids /
EarlyHelmID = 27393
EarlyArmorID = 27394
EarlyGauntletID = 27395
EarlyChaussesID = 27396
EarlyGreavesID = 27397
EarlyAccessoryID = 27399

-- initialize item counts
EarlyHelmCount = GetItemCount(EarlyHelmID)
EarlyArmorCount = GetItemCount(EarlyArmorID)
EarlyGauntletCount = GetItemCount(EarlyGauntletID)
EarlyChaussesCount = GetItemCount(EarlyChaussesID)
EarlyGreavesCount = GetItemCount(EarlyGreavesID)
EarlyAccessoryCount = GetItemCount(EarlyAccessoryID)

-------------------------------------------------------------------------------- golden antiquity item ids
GoldenHelmID = 29020
GoldenArmorID = 29021
GoldenGauntletID = 29022
GoldenChaussesID = 29023
GoldenGreavesID = 29024
GoldenAccessoryID = 29026

-- initialize item counts
GoldenHelmCount = GetItemCount(GoldenHelmID)
GoldenArmorCount = GetItemCount(GoldenArmorID)
GoldenGauntletCount = GetItemCount(GoldenGauntletID)
GoldenChaussesCount = GetItemCount(GoldenChaussesID)
GoldenGreavesCount = GetItemCount(GoldenGreavesID)
GoldenAccessoryCount = GetItemCount(GoldenAccessoryID)
--------------------------------------------------------------------------------lost antiquity item ids 

LostHelmID = 32133
LostArmorID = 32134
LostGauntletID = 32135
LostChaussesID = 32136
LostGreavesID = 32137
LostAccessoryID = 32139

-- initialize item counts
LostHelmCount = GetItemCount(LostHelmID)
LostArmorCount = GetItemCount(LostArmorID)
LostGauntletCount = GetItemCount(LostGauntletID)
LostChaussesCount = GetItemCount(LostChaussesID)
LostGreavesCount = GetItemCount(LostGreavesID)
LostAccessoryCount = GetItemCount(LostAccessoryID)

------------------------------------------------------------------------------

YhalTable =
{
----------------------------   EDENGATE   --------------------------------------------
-- shop 1/dow1
{0, EarlyAccessoryID, AccessoryBuyAmount, 27073, 22,0},
{0, EarlyAccessoryID, AccessoryBuyAmount, 27072, 21,0},
{0, EarlyAccessoryID, AccessoryBuyAmount, 27068, 20,0},
{0, EarlyAccessoryID, AccessoryBuyAmount, 27067, 19,0},
{0, EarlyAccessoryID, AccessoryBuyAmount, 27063, 18,0},
{0, EarlyAccessoryID, AccessoryBuyAmount, 27062, 17,0},
{0, EarlyAccessoryID, AccessoryBuyAmount, 27058, 16,0},
{0, EarlyAccessoryID, AccessoryBuyAmount, 27057, 15,0},
{0, EarlyGreavesID, FeetBuyAmount, 27031, 14,0},
{0, EarlyGreavesID, FeetBuyAmount, 27025, 13,0},
{0, EarlyGreavesID, FeetBuyAmount, 27019, 12,0},
{0, EarlyChaussesID, LegsBuyAmount, 27030, 11,0},
{0, EarlyChaussesID, LegsBuyAmount, 27024, 10,0},
{0, EarlyChaussesID, LegsBuyAmount, 27018, 9,0},
{0, EarlyGauntletID, HandsBuyAmount, 27029, 8,0},
{0, EarlyGauntletID, HandsBuyAmount, 27023, 7,0},
{0, EarlyGauntletID, HandsBuyAmount, 27017, 6,0},
{0, EarlyArmorID, ChestBuyAmount, 27028, 5,0},
{0, EarlyArmorID, ChestBuyAmount, 27022, 4,0},
{0, EarlyArmorID, ChestBuyAmount, 27016, 3,0},
{0, EarlyHelmID, HelmBuyAmount, 27027, 2,0},
{0, EarlyHelmID, HelmBuyAmount, 27021, 1,0},
{0, EarlyHelmID, HelmBuyAmount, 27015, 0,0},
-- shop 2/dow2 
{1, EarlyAccessoryID, AccessoryBuyAmount, 27074, 13,0},
{1, EarlyAccessoryID, AccessoryBuyAmount, 27069, 12,0},
{1, EarlyAccessoryID, AccessoryBuyAmount, 27064, 11,0},
{1, EarlyAccessoryID, AccessoryBuyAmount, 27059, 10,0},
{1, EarlyGreavesID, FeetBuyAmount, 27037, 9,0},
{1, EarlyGreavesID, FeetBuyAmount, 27043, 8,0},
{1, EarlyChaussesID, LegsBuyAmount, 27036, 7,0},
{1, EarlyChaussesID, LegsBuyAmount, 27042, 6,0},
{1, EarlyGauntletID, HandsBuyAmount, 27035, 5,0},
{1, EarlyGauntletID, HandsBuyAmount, 27041, 4,0},
{1, EarlyArmorID, ChestBuyAmount, 27034, 3,0},
{1, EarlyArmorID, ChestBuyAmount, 27040, 2,0},
{1, EarlyHelmID, HelmBuyAmount, 27033, 1,0},
{1, EarlyHelmID, HelmBuyAmount, 27039, 0,0},
-- shop 3/dom 
{2, EarlyAccessoryID, AccessoryBuyAmount, 27075, 17,0},
{2, EarlyAccessoryID, AccessoryBuyAmount, 27076, 16,0},
{2, EarlyAccessoryID, AccessoryBuyAmount, 27070, 15,0},
{2, EarlyAccessoryID, AccessoryBuyAmount, 27071, 14,0},
{2, EarlyAccessoryID, AccessoryBuyAmount, 27065, 13,0},
{2, EarlyAccessoryID, AccessoryBuyAmount, 27066, 12,0},
{2, EarlyAccessoryID, AccessoryBuyAmount, 27060, 11,0},
{2, EarlyAccessoryID, AccessoryBuyAmount, 27061, 10,0},
{2, EarlyGreavesID, FeetBuyAmount, 27049, 9,0},
{2, EarlyGreavesID, FeetBuyAmount, 27055, 8,0},
{2, EarlyChaussesID, LegsBuyAmount, 27048, 7,0},
{2, EarlyChaussesID, LegsBuyAmount, 27054, 6,0},
{2, EarlyGauntletID, HandsBuyAmount, 27047, 5,0},
{2, EarlyGauntletID, HandsBuyAmount, 27053, 4,0},
{2, EarlyArmorID, ChestBuyAmount, 27046, 3,0},
{2, EarlyArmorID, ChestBuyAmount, 27052, 2,0},
{2, EarlyHelmID, HelmBuyAmount, 27045, 1,0},
{2, EarlyHelmID, HelmBuyAmount, 27051, 0,0},
----------------------------   EDENVERSE   -------------------------------------------------
-- Shop 1 / DOW1
{0, GoldenAccessoryID, AccessoryBuyAmount, 29175, 22,2},
{0, GoldenAccessoryID, AccessoryBuyAmount, 29174, 21,2},
{0, GoldenAccessoryID, AccessoryBuyAmount, 29170, 20,2},
{0, GoldenAccessoryID, AccessoryBuyAmount, 29169, 19,2},
{0, GoldenAccessoryID, AccessoryBuyAmount, 29165, 18,2},
{0, GoldenAccessoryID, AccessoryBuyAmount, 29164, 17,2},
{0, GoldenAccessoryID, AccessoryBuyAmount, 29160, 16,2},
{0, GoldenAccessoryID, AccessoryBuyAmount, 29159, 15,2},
{0, GoldenGreavesID, FeetBuyAmount, 29133, 14,2},
{0, GoldenGreavesID, FeetBuyAmount, 29127, 13,2},
{0, GoldenGreavesID, FeetBuyAmount, 29121, 12,2},
{0, GoldenChaussesID, LegsBuyAmount, 29132, 11,2},
{0, GoldenChaussesID, LegsBuyAmount, 29126, 10,2},
{0, GoldenChaussesID, LegsBuyAmount, 29120, 9,2},
{0, GoldenGaountletID, HandsBuyAmount, 29131, 8,2},
{0, GoldenGaountletID, HandsBuyAmount, 29125, 7,2},
{0, GoldenGaountletID, HandsBuyAmount, 29119, 6,2},
{0, GoldenArmorID, ChestBuyAmount, 29130, 5,2},
{0, GoldenArmorID, ChestBuyAmount, 29124, 4,2},
{0, GoldenArmorID, ChestBuyAmount, 29118, 3,2},
{0, GoldenHelmID,HelmBuyAmount,29129,2,2},
{0, GoldenHelmID,HelmBuyAmount,29123,1,2},
{0, GoldenHelmID,HelmBuyAmount,29117,0,2},
-- shop 2/dow2 
{1, GoldenAccessoryID, AccessoryBuyAmount, 29176, 13,2},
{1, GoldenAccessoryID, AccessoryBuyAmount, 29171, 12,2},
{1, GoldenAccessoryID, AccessoryBuyAmount, 29166, 11,2},
{1, GoldenAccessoryID, AccessoryBuyAmount, 29161, 10,2},
{1, GoldenGreavesID, FeetBuyAmount, 29139, 9,2},
{1, GoldenGreavesID, FeetBuyAmount, 29145, 8,2},
{1, GoldenChaussesID, LegsBuyAmount, 29138, 7,2},
{1, GoldenChaussesID, LegsBuyAmount, 29144, 6,2},
{1, GoldenGaountletID, HandsBuyAmount, 29137, 5,2},
{1, GoldenGaountletID, HandsBuyAmount, 29143, 4,2},
{1, GoldenArmorID, ChestBuyAmount, 29136, 3,2},
{1, GoldenArmorID, ChestBuyAmount, 29142, 2,2},
{1, GoldenHelmID, HelmBuyAmount, 29135, 1,2},
{1, GoldenHelmID, HelmBuyAmount, 29141, 0,2},
-- shop 3/dom 
{2, GoldenAccessoryID, AccessoryBuyAmount, 29177, 17,2},
{2, GoldenAccessoryID, AccessoryBuyAmount, 29178, 16,2},
{2, GoldenAccessoryID, AccessoryBuyAmount, 29172, 15,2},
{2, GoldenAccessoryID, AccessoryBuyAmount, 29173, 14,2},
{2, GoldenAccessoryID, AccessoryBuyAmount, 291567, 13,2},
{2, GoldenAccessoryID, AccessoryBuyAmount, 29168, 12,2},
{2, GoldenAccessoryID, AccessoryBuyAmount, 29162, 11,2},
{2, GoldenAccessoryID, AccessoryBuyAmount, 29163, 10,2},
{2, GoldenGreavesID, FeetBuyAmount, 29151, 9,2},
{2, GoldenGreavesID, FeetBuyAmount, 29157, 8,2},
{2, GoldenChaussesID, LegsBuyAmount, 29150, 7,2},
{2, GoldenChaussesID, LegsBuyAmount, 29156, 6,2},
{2, GoldenGaountletID, HandsBuyAmount, 29149, 5,2},
{2, GoldenGaountletID, HandsBuyAmount, 29155, 4,2},
{2, GoldenArmorID, ChestBuyAmount, 29148, 3,2},
{2, GoldenArmorID, ChestBuyAmount, 29154, 2,2},
{2, GoldenHelmID, HelmBuyAmount, 29147, 1,2},
{2, GoldenHelmID, HelmBuyAmount, 29153, 0,2},
    
----------------------------   EDENPROMISE   --------------------------------------------
{0, LostAccessoryID, AccessoryBuyAmount, 32414, 22,4},
{0, LostAccessoryID, AccessoryBuyAmount, 32413, 21,4},
{0, LostAccessoryID, AccessoryBuyAmount, 32409, 20,4},
{0, LostAccessoryID, AccessoryBuyAmount, 32408, 19,4},
{0, LostAccessoryID, AccessoryBuyAmount, 32404, 18,4},
{0, LostAccessoryID, AccessoryBuyAmount, 32403, 17,4},
{0, LostAccessoryID, AccessoryBuyAmount, 32399, 16,4},
{0, LostAccessoryID, AccessoryBuyAmount, 32398, 15,4},
{0, LostGreavesID, FeetBuyAmount, 32372, 14,4},
{0, LostGreavesID, FeetBuyAmount, 32366, 13,4},
{0, LostGreavesID, FeetBuyAmount, 32360, 12,4},
{0, LostChaussesID, LegsBuyAmount, 32371, 11,4},
{0, LostChaussesID, LegsBuyAmount, 32365, 10,4},
{0, LostChaussesID, LegsBuyAmount, 32359, 9,4},
{0, LostGauntletID, HandsBuyAmount, 32370, 8,4},
{0, LostGauntletID, HandsBuyAmount, 32364, 7,4},
{0, LostGauntletID, HandsBuyAmount, 32358, 6,4},
{0, LostArmorID, ChestBuyAmount, 32369, 5,4},
{0, LostArmorID, ChestBuyAmount, 32363, 4,4},
{0, LostArmorID, ChestBuyAmount, 32357, 3,4},
{0, LostHelmID,HelmBuyAmount,32368,2,4},
{0, LostHelmID,HelmBuyAmount,32362,1,4},
{0, LostHelmID,HelmBuyAmount,32356,0,4},
-- shop 2/dow2 
{1, LostAccessoryID, AccessoryBuyAmount, 32415, 13,4},
{1, LostAccessoryID, AccessoryBuyAmount, 32410, 12,4},
{1, LostAccessoryID, AccessoryBuyAmount, 32405, 11,4},
{1, LostAccessoryID, AccessoryBuyAmount, 32400, 10,4},
{1, LostGreavesID, FeetBuyAmount, 32378, 9,4},
{1, LostGreavesID, FeetBuyAmount, 32384, 8,4},
{1, LostChaussesID, LegsBuyAmount, 32377, 7,4},
{1, LostChaussesID, LegsBuyAmount, 32383, 6,4},
{1, LostGauntletID, HandsBuyAmount, 32376, 5,4},
{1, LostGauntletID, HandsBuyAmount, 32382, 4,4},
{1, LostArmorID, ChestBuyAmount, 32375, 3,4},
{1, LostArmorID, ChestBuyAmount, 32381, 2,4},
{1, LostHelmID, HelmBuyAmount, 32374, 1,4},
{1, LostHelmID, HelmBuyAmount, 32380, 0,4},
-- shop 3/dom 
{2, LostAccessoryID, AccessoryBuyAmount, 32416, 17,4},
{2, LostAccessoryID, AccessoryBuyAmount, 32417, 16,4},
{2, LostAccessoryID, AccessoryBuyAmount, 32411, 15,4},
{2, LostAccessoryID, AccessoryBuyAmount, 32412, 14,4},
{2, LostAccessoryID, AccessoryBuyAmount, 32406, 13,4},
{2, LostAccessoryID, AccessoryBuyAmount, 32407, 12,4},
{2, LostAccessoryID, AccessoryBuyAmount, 32401, 11,4},
{2, LostAccessoryID, AccessoryBuyAmount, 32402, 10,4},
{2, LostGreavesID, FeetBuyAmount, 32390, 9,4},
{2, LostGreavesID, FeetBuyAmount, 32396, 8,4},
{2, LostChaussesID, LegsBuyAmount, 32389, 7,4},
{2, LostChaussesID, LegsBuyAmount, 32395, 6,4},
{2, LostGauntletID, HandsBuyAmount, 32388, 5,4},
{2, LostGauntletID, HandsBuyAmount, 32394, 4,4},
{2, LostArmorID, ChestBuyAmount, 32387, 3,4},
{2, LostArmorID, ChestBuyAmount, 32393, 2,4},
{2, LostHelmID, HelmBuyAmount, 32386, 1,4},
{2, LostHelmID, HelmBuyAmount, 32392, 0,4},
}

--------------------------------------------------------------Asphodelos item ids
AsphodelosHelmID = 35817
AsphodelosArmorID = 35818
AsphodelosGauntletID = 35819
AsphodelosChaussesID = 35820
AsphodelosGreavesID = 35821
AsphodelosAccessoryID = 35823

-- initialize item counts
AsphodelosHelmCount = GetItemCount(AsphodelosHelmID)
AsphodelosArmorCount = GetItemCount(AsphodelosArmorID)
AsphodelosGauntletCount = GetItemCount(AsphodelosGauntletID)
AsphodelosChaussesCount = GetItemCount(AsphodelosChaussesID)
AsphodelosGreavesCount = GetItemCount(AsphodelosGreavesID)
AsphodelosAccessoryCount = GetItemCount(AsphodelosAccessoryID)

--------------------------------------------------------------Abyssos item ids
AbyssosHelmID = 38375
AbyssosArmorID = 38376
AbyssosGauntletID = 38377
AbyssosChaussesID = 38378
AbyssosGreavesID = 38379
AbyssosAccessoryID = 38381

-- initialize item counts
AbyssosHelmCount = GetItemCount(AbyssosHelmID)
AbyssosArmorCount = GetItemCount(AbyssosArmorID)
AbyssosGauntletCount = GetItemCount(AbyssosGauntletID)
AbyssosChaussesCount = GetItemCount(AbyssosChaussesID)
AbyssosGreavesCount = GetItemCount(AbyssosGreavesID)
AbyssosAccessoryCount = GetItemCount(AbyssosAccessoryID)

--------------------------------------------------------------Anabaseios item ids
AnabaseiosHelmID = 40297
AnabaseiosArmorID = 40298
AnabaseiosGauntletID = 40299
AnabaseiosChaussesID = 40300
AnabaseiosGreavesID = 40301
AnabaseiosAccessoryID = 40303

-- initialize item counts
AnabaseiosHelmCount = GetItemCount(AnabaseiosHelmID)
AnabaseiosArmorCount = GetItemCount(AnabaseiosArmorID)
AnabaseiosGauntletCount = GetItemCount(AnabaseiosGauntletID)
AnabaseiosChaussesCount = GetItemCount(AnabaseiosChaussesID)
AnabaseiosGreavesCount = GetItemCount(AnabaseiosGreavesID)
AnabaseiosAccessoryCount = GetItemCount(AnabaseiosAccessoryID)

-------------------------------------------------------------
DjoleTable = 
{
--------------------- Name 1 --------------------------------
{0, AsphodelosHelmID, HelmBuyAmount, 34965, 0,0},
{0, AsphodelosArmorID, ChestBuyAmount, 34966, 3,0},
{0, AsphodelosGauntletID, HandsBuyAmount, 34967, 6,0},
{0, AsphodelosChaussesID, LegsBuyAmount, 34968, 9,0},
{0, AsphodelosGreavesID, FeetBuyAmount, 34969, 12,0},
{0, AsphodelosHelmID, HelmBuyAmount, 34971, 1,0},
{0, AsphodelosArmorID, ChestBuyAmount, 34972, 4,0},
{0, AsphodelosGauntletID, HandsBuyAmount, 34973, 7,0},
{0, AsphodelosChaussesID, LegsBuyAmount, 34974, 10,0},
{0, AsphodelosGreavesID, FeetBuyAmount, 34975, 13,0},
{0, AsphodelosHelmID, HelmBuyAmount, 34977, 2,0},
{0, AsphodelosArmorID, ChestBuyAmount, 34978, 5,0},
{0, AsphodelosGauntletID, HandsBuyAmount, 34979, 8,0},
{0, AsphodelosChaussesID, LegsBuyAmount, 34980, 11,0},
{0, AsphodelosGreavesID, FeetBuyAmount, 34981, 14,0},
{1, AsphodelosHelmID, HelmBuyAmount, 34983, 1,0},
{1, AsphodelosArmorID, ChestBuyAmount, 34984, 3,0},
{1, AsphodelosGauntletID, HandsBuyAmount, 34985, 5,0},
{1, AsphodelosChaussesID, LegsBuyAmount, 34986, 7,0},
{1, AsphodelosGreavesID, FeetBuyAmount, 34987, 9,0},
{1, AsphodelosHelmID, HelmBuyAmount, 34989, 0,0},
{1, AsphodelosArmorID, ChestBuyAmount, 34990, 2,0},
{1, AsphodelosGauntletID, HandsBuyAmount, 34991, 4,0},
{1, AsphodelosChaussesID, LegsBuyAmount, 34992, 6,0},
{1, AsphodelosGreavesID, FeetBuyAmount, 34993, 8,0},
{2, AsphodelosHelmID, HelmBuyAmount, 34995, 1,0},
{2, AsphodelosArmorID, ChestBuyAmount, 34996, 3,0},
{2, AsphodelosGauntletID, HandsBuyAmount, 34997, 5,0},
{2, AsphodelosChaussesID, LegsBuyAmount, 34998, 7,0},
{2, AsphodelosGreavesID, FeetBuyAmount, 34999, 9,0},
{2, AsphodelosHelmID, HelmBuyAmount, 35001, 0,0},
{2, AsphodelosArmorID, ChestBuyAmount, 35002, 2,0},
{2, AsphodelosGauntletID, HandsBuyAmount, 35003, 4,0},
{2, AsphodelosChaussesID, LegsBuyAmount, 35004, 6,0},
{2, AsphodelosGreavesID, FeetBuyAmount, 35005, 8,0},
{0, AsphodelosAccessoryID, AccessoryBuyAmount, 35007, 15,0},
{0, AsphodelosAccessoryID, AccessoryBuyAmount, 35008, 16,0},
{1, AsphodelosAccessoryID, AccessoryBuyAmount, 35009, 10,0},
{2, AsphodelosAccessoryID, AccessoryBuyAmount, 35010, 11,0},
{2, AsphodelosAccessoryID, AccessoryBuyAmount, 35011, 10,0},
{0, AsphodelosAccessoryID, AccessoryBuyAmount, 35012, 17,0},
{0, AsphodelosAccessoryID, AccessoryBuyAmount, 35013, 18,0},
{1, AsphodelosAccessoryID, AccessoryBuyAmount, 35014, 11,0},
{2, AsphodelosAccessoryID, AccessoryBuyAmount, 35015, 13,0},
{2, AsphodelosAccessoryID, AccessoryBuyAmount, 35016, 12,0},
{0, AsphodelosAccessoryID, AccessoryBuyAmount, 35017, 19,0},
{0, AsphodelosAccessoryID, AccessoryBuyAmount, 35018, 20,0},
{1, AsphodelosAccessoryID, AccessoryBuyAmount, 35019, 12,0},
{2, AsphodelosAccessoryID, AccessoryBuyAmount, 35020, 15,0},
{2, AsphodelosAccessoryID, AccessoryBuyAmount, 35021, 14,0},
{0, AsphodelosAccessoryID, AccessoryBuyAmount, 35022, 21,0},
{0, AsphodelosAccessoryID, AccessoryBuyAmount, 35023, 22,0},
{1, AsphodelosAccessoryID, AccessoryBuyAmount, 35024, 13,0},
{2, AsphodelosAccessoryID, AccessoryBuyAmount, 35025, 17,0},
{2, AsphodelosAccessoryID, AccessoryBuyAmount, 35026, 16,0},

--------------------- Name 2 --------------------------------
{0, AbyssosHelmID, HelmBuyAmount, 37876, 0,0},
{0, AbyssosArmorID, ChestBuyAmount, 37877, 3,0},
{0, AbyssosGauntletID, HandsBuyAmount, 37878, 6,0},
{0, AbyssosChaussesID, LegsBuyAmount, 37879, 9,0},
{0, AbyssosGreavesID, FeetBuyAmount, 37880, 12,0},
{0, AbyssosHelmID, HelmBuyAmount, 37882, 1,0},
{0, AbyssosArmorID, ChestBuyAmount, 37883, 4,0},
{0, AbyssosGauntletID, HandsBuyAmount, 37884, 7,0},
{0, AbyssosChaussesID, LegsBuyAmount, 37885, 10,0},
{0, AbyssosGreavesID, FeetBuyAmount, 37886, 13,0},
{0, AbyssosHelmID, HelmBuyAmount, 37888, 2,0},
{0, AbyssosArmorID, ChestBuyAmount, 37889, 5,0},
{0, AbyssosGauntletID, HandsBuyAmount, 37890, 8,0},
{0, AbyssosChaussesID, LegsBuyAmount, 37891, 11,0},
{0, AbyssosGreavesID, FeetBuyAmount, 37892, 14,0},
{1, AbyssosHelmID, HelmBuyAmount, 37894, 1,0},
{1, AbyssosArmorID, ChestBuyAmount, 37895, 3,0},
{1, AbyssosGauntletID, HandsBuyAmount, 37896, 5,0},
{1, AbyssosChaussesID, LegsBuyAmount, 37897, 7,0},
{1, AbyssosGreavesID, FeetBuyAmount, 37898, 9,0},
{1, AbyssosHelmID, HelmBuyAmount, 37900, 0,0},
{1, AbyssosArmorID, ChestBuyAmount, 37901, 2,0},
{1, AbyssosGauntletID, HandsBuyAmount, 37902, 4,0},
{1, AbyssosChaussesID, LegsBuyAmount, 37903, 6,0},
{1, AbyssosGreavesID, FeetBuyAmount, 37904, 8,0},
{2, AbyssosHelmID, HelmBuyAmount, 37906, 1,0},
{2, AbyssosArmorID, ChestBuyAmount, 37907, 3,0},
{2, AbyssosGauntletID, HandsBuyAmount, 37908, 5,0},
{2, AbyssosChaussesID, LegsBuyAmount, 37909, 7,0},
{2, AbyssosGreavesID, FeetBuyAmount, 37910, 9,0},
{2, AbyssosHelmID, HelmBuyAmount, 37912, 0,0},
{2, AbyssosArmorID, ChestBuyAmount, 37913, 2,0},
{2, AbyssosGauntletID, HandsBuyAmount, 37914, 4,0},
{2, AbyssosChaussesID, LegsBuyAmount, 37915, 6,0},
{2, AbyssosGreavesID, FeetBuyAmount, 37916, 8,0},
{0, AbyssosAccessoryID, AccessoryBuyAmount, 37918, 15,0},
{0, AbyssosAccessoryID, AccessoryBuyAmount, 37919, 16,0},
{1, AbyssosAccessoryID, AccessoryBuyAmount, 37920, 10,0},
{2, AbyssosAccessoryID, AccessoryBuyAmount, 37921, 11,0},
{2, AbyssosAccessoryID, AccessoryBuyAmount, 37922, 10,0},
{0, AbyssosAccessoryID, AccessoryBuyAmount, 37923, 17,0},
{0, AbyssosAccessoryID, AccessoryBuyAmount, 37924, 18,0},
{1, AbyssosAccessoryID, AccessoryBuyAmount, 37925, 11,0},
{2, AbyssosAccessoryID, AccessoryBuyAmount, 37926, 13,0},
{2, AbyssosAccessoryID, AccessoryBuyAmount, 37927, 12,0},
{0, AbyssosAccessoryID, AccessoryBuyAmount, 37928, 19,0},
{0, AbyssosAccessoryID, AccessoryBuyAmount, 37929, 20,0},
{1, AbyssosAccessoryID, AccessoryBuyAmount, 37930, 12,0},
{2, AbyssosAccessoryID, AccessoryBuyAmount, 37931, 15,0},
{2, AbyssosAccessoryID, AccessoryBuyAmount, 37932, 14,0},
{0, AbyssosAccessoryID, AccessoryBuyAmount, 37933, 21,0},
{0, AbyssosAccessoryID, AccessoryBuyAmount, 37934, 22,0},
{1, AbyssosAccessoryID, AccessoryBuyAmount, 37935, 13,0},
{2, AbyssosAccessoryID, AccessoryBuyAmount, 37936, 17,0},
{2, AbyssosAccessoryID, AccessoryBuyAmount, 37937, 16,0},

--------------------- Name 3 --------------------------------
{0, AnabaseiosHelmID, HelmBuyAmount, 39960, 0,0},
{0, AnabaseiosArmorID, ChestBuyAmount, 39961, 3,0},
{0, AnabaseiosGauntletID, HandsBuyAmount, 39962, 6,0},
{0, AnabaseiosChaussesID, LegsBuyAmount, 39963, 9,0},
{0, AnabaseiosGreavesID, FeetBuyAmount, 39964, 12,0},
{0, AnabaseiosHelmID, HelmBuyAmount, 39966, 1,0},
{0, AnabaseiosArmorID, ChestBuyAmount, 39967, 4,0},
{0, AnabaseiosGauntletID, HandsBuyAmount, 39968, 7,0},
{0, AnabaseiosChaussesID, LegsBuyAmount, 39969, 10,0},
{0, AnabaseiosGreavesID, FeetBuyAmount, 39970, 13,0},
{0, AnabaseiosHelmID, HelmBuyAmount, 39972, 2,0},
{0, AnabaseiosArmorID, ChestBuyAmount, 39973, 5,0},
{0, AnabaseiosGauntletID, HandsBuyAmount, 39974, 8,0},
{0, AnabaseiosChaussesID, LegsBuyAmount, 39975, 11,0},
{0, AnabaseiosGreavesID, FeetBuyAmount, 39976, 14,0},
{1, AnabaseiosHelmID, HelmBuyAmount, 39978, 1,0},
{1, AnabaseiosArmorID, ChestBuyAmount, 39979, 3,0},
{1, AnabaseiosGauntletID, HandsBuyAmount, 39980, 5,0},
{1, AnabaseiosChaussesID, LegsBuyAmount, 39981, 7,0},
{1, AnabaseiosGreavesID, FeetBuyAmount, 39982, 9,0},
{1, AnabaseiosHelmID, HelmBuyAmount, 39984, 0,0},
{1, AnabaseiosArmorID, ChestBuyAmount, 39985, 2,0},
{1, AnabaseiosGauntletID, HandsBuyAmount, 39986, 4,0},
{1, AnabaseiosChaussesID, LegsBuyAmount, 39987, 6,0},
{1, AnabaseiosGreavesID, FeetBuyAmount, 39988, 8,0},
{2, AnabaseiosHelmID, HelmBuyAmount, 39990, 1,0},
{2, AnabaseiosArmorID, ChestBuyAmount, 39991, 3,0},
{2, AnabaseiosGauntletID, HandsBuyAmount, 39992, 5,0},
{2, AnabaseiosChaussesID, LegsBuyAmount, 39993, 7,0},
{2, AnabaseiosGreavesID, FeetBuyAmount, 39994, 9,0},
{2, AnabaseiosHelmID, HelmBuyAmount, 39996, 0,0},
{2, AnabaseiosArmorID, ChestBuyAmount, 39997, 2,0},
{2, AnabaseiosGauntletID, HandsBuyAmount, 39998, 4,0},
{2, AnabaseiosChaussesID, LegsBuyAmount, 39999, 6,0},
{2, AnabaseiosGreavesID, FeetBuyAmount, 40000, 8,0},
{0, AnabaseiosAccessoryID, AccessoryBuyAmount, 40002, 15,0},
{0, AnabaseiosAccessoryID, AccessoryBuyAmount, 40003, 16,0},
{1, AnabaseiosAccessoryID, AccessoryBuyAmount, 40004, 10,0},
{2, AnabaseiosAccessoryID, AccessoryBuyAmount, 40005, 11,0},
{2, AnabaseiosAccessoryID, AccessoryBuyAmount, 40006, 10,0},
{0, AnabaseiosAccessoryID, AccessoryBuyAmount, 40007, 17,0},
{0, AnabaseiosAccessoryID, AccessoryBuyAmount, 40008, 18,0},
{1, AnabaseiosAccessoryID, AccessoryBuyAmount, 40009, 11,0},
{2, AnabaseiosAccessoryID, AccessoryBuyAmount, 40010, 13,0},
{2, AnabaseiosAccessoryID, AccessoryBuyAmount, 40011, 12,0},
{0, AnabaseiosAccessoryID, AccessoryBuyAmount, 40012, 19,0},
{0, AnabaseiosAccessoryID, AccessoryBuyAmount, 40013, 20,0},
{1, AnabaseiosAccessoryID, AccessoryBuyAmount, 40014, 12,0},
{2, AnabaseiosAccessoryID, AccessoryBuyAmount, 40015, 15,0},
{2, AnabaseiosAccessoryID, AccessoryBuyAmount, 40016, 14,0},
{0, AnabaseiosAccessoryID, AccessoryBuyAmount, 40017, 21,0},
{0, AnabaseiosAccessoryID, AccessoryBuyAmount, 40018, 22,0},
{1, AnabaseiosAccessoryID, AccessoryBuyAmount, 40019, 13,0},
{2, AnabaseiosAccessoryID, AccessoryBuyAmount, 40020, 17,0},
{2, AnabaseiosAccessoryID, AccessoryBuyAmount, 40021, 16,0},
}

-- Fonksyonlar / Functions

PandoraSetFeatureState("Auto-select Turn-ins", true) 
PandoraSetFeatureConfigState("Auto-select Turn-ins", "AutoConfirm", true)

function PlayerTest()
    repeat
        yield("/wait 0.1")
    until IsPlayerAvailable()
end

function ZoneTransition()
    repeat 
        yield("/wait 0.5")
    until not IsPlayerAvailable()
    repeat 
        yield("/wait 0.5")
    until IsPlayerAvailable()
end

function Truncate1Dp(num)
    return truncate and ("%.1f"):format(num) or num
end

function MeshCheck()
    local was_ready = NavIsReady()
    if not NavIsReady() then
        while not NavIsReady() do
            LogInfo("[Debug]Building navmesh, currently at " .. Truncate1Dp(NavBuildProgress() * 100) .. "%")
            yield("/wait 1")
            local was_ready = NavIsReady()
            if was_ready then
                LogInfo("[Debug]Navmesh ready!")
            end
        end
    else
        LogInfo("[Debug]Navmesh ready!")
    end
end

function WalkTo(valuex, valuey, valuez, stopdistance)
    MeshCheck()
    PathfindAndMoveTo(valuex, valuey, valuez, false)
    while ((PathIsRunning() or PathfindInProgress()) and GetDistanceToPoint(valuex, valuey, valuez) > stopdistance) do
        yield("/wait 0.3")
    end
    PathStop()
    LogInfo("[WalkTo] Completed")
end

function TeleportToIdlishire()
    if IsInZone(478) then
        LogInfo("[Debug]Tried Teleporting but already at zone: 478(Idlishire)")
    else
        while GetZoneID() ~= 478 do
            yield("/wait 0.14")
            if GetCharacterCondition(27) then
                yield("/wait 2")
            else
                yield("/tp Idyllshire")
                yield("/wait 2") 
            end
        end
    end
    PlayerTest()
end

function TeleportToRhalgr()
    if IsInZone(635) then
        LogInfo("[Debug]Tried Teleporting but already at zone: 635(Rhalgr)")
    else
        while GetZoneID() ~= 635 do
            yield("/wait 0.13")
            if GetCharacterCondition(27) then
                yield("/wait 2")
            else
                yield("/tp Rhalgr")
                yield("/wait 2") 
            end
        end
    end
    PlayerTest()
end

function TeleportToEulmore()
    if IsInZone(820) then
        LogInfo("[Debug]Tried Teleporting but already at zone: 820(Eulmore)")
    else
        while GetZoneID() ~= 820 do
            yield("/wait 0.13")
            if GetCharacterCondition(27) then
                yield("/wait 2")
            else
                yield("/tp Eulmore")
                yield("/wait 2") 
            end
        end
    end
    PlayerTest()
end

function TeleportGC()
    while GetZoneID() == 478 or GetZoneID() == 635 do
        yield("/wait 0.15")
        if GetCharacterCondition(27) then
            yield("/wait 2")
        else
            if UseTicket then
                TeleportToGCTown(UseTicket)
                else
                if GetPlayerGC() == 1 then
                    yield("/tp Limsa")
                elseif GetPlayerGC() == 2 then
                    yield("/tp Gridania")
                elseif GetPlayerGC() == 3 then
                    yield("/tp Ul")
                end
                yield("/wait 2")
            end
        end
    end
    PlayerTest()
end

function IsThereTradeItem() 
    TotalExchangeItem = 0 
    for _, entry in ipairs(SabinaTable) do
        local itemID = entry[4]
        local count = GetItemCount(itemID)
        TotalExchangeItem = TotalExchangeItem + count
    end
    for _, entry in ipairs(GelfradusTable) do
        local itemID = entry[4]
        local count = GetItemCount(itemID)
        TotalExchangeItem = TotalExchangeItem + count
    end
        for _, entry in ipairs(YhalTable) do
        local itemID = entry[4]
        local count = GetItemCount(itemID)
        TotalExchangeItem = TotalExchangeItem + count
    end


 ----------------------------   GORDIAN   --------------------------------------------

    GordianLensCount = GetItemCount(GordianLensID)
    GordianShaftCount = GetItemCount(GordianShaftID)
    GordianCrankCount = GetItemCount(GordianCrankID)
    GordianSpringCount = GetItemCount(GordianSpringID)
    GordianPedalCount = GetItemCount(GordianPedalID)
    GordianBoltCount = GetItemCount(GordianBoltID)

    GordianTurnInCount = math.floor(GordianLensCount / HelmBuyAmount) +
    math.floor(GordianShaftCount / ChestBuyAmount) +
    math.floor(GordianCrankCount / HandsBuyAmount) +
    math.floor(GordianSpringCount / LegsBuyAmount) +
    math.floor(GordianPedalCount / FeetBuyAmount) +
    math.floor(GordianBoltCount / AccessoryBuyAmount)

 ----------------------------   MIDAN   --------------------------------------------

    MidanLensCount = GetItemCount(MidanLensID)
    MidanShaftCount = GetItemCount(MidanShaftID)
    MidanCrankCount = GetItemCount(MidanCrankID)
    MidanSpringCount = GetItemCount(MidanSpringID)
    MidanPedalCount = GetItemCount(MidanPedalID)
    MidanBoltCount = GetItemCount(MidanBoltID)

    MidanTurnInCount = math.floor(MidanLensCount / HelmBuyAmount) +
    math.floor(MidanShaftCount / ChestBuyAmount) +
    math.floor(MidanCrankCount / HandsBuyAmount) +
    math.floor(MidanSpringCount / LegsBuyAmount) +
    math.floor(MidanPedalCount / FeetBuyAmount) +
    math.floor(MidanBoltCount / AccessoryBuyAmount)

 ----------------------------   Alexandrian   --------------------------------------------

    AlexandrianLensCount = GetItemCount(AlexandrianLensID)
    AlexandrianShaftCount = GetItemCount(AlexandrianShaftID)
    AlexandrianCrankCount = GetItemCount(AlexandrianCrankID)
    AlexandrianSpringCount = GetItemCount(AlexandrianSpringID)
    AlexandrianPedalCount = GetItemCount(AlexandrianPedalID)
    AlexandrianBoltCount = GetItemCount(AlexandrianBoltID)

    AlexandrianTurnInCount = math.floor(AlexandrianLensCount / HelmBuyAmount) +
    math.floor(AlexandrianShaftCount / ChestBuyAmount) +
    math.floor(AlexandrianCrankCount / HandsBuyAmount) +
    math.floor(AlexandrianSpringCount / LegsBuyAmount) +
    math.floor(AlexandrianPedalCount / FeetBuyAmount) +
    math.floor(AlexandrianBoltCount / AccessoryBuyAmount)

 ------------------------------  Deltascape  ----------------------------------------------

    DeltascapeLensCount = GetItemCount(DeltascapeLensID)
    DeltascapeShaftCount = GetItemCount(DeltascapeShaftID)
    DeltascapeCrankCount = GetItemCount(DeltascapeCrankID)
    DeltascapeSpringCount = GetItemCount(DeltascapeSpringID)
    DeltascapePedalCount = GetItemCount(DeltascapePedalID)
    DeltascapeBoltCount = GetItemCount(DeltascapeBoltID)

    DeltascapeTurnInCount = math.floor(DeltascapeLensCount / HelmBuyAmount) +
    math.floor(DeltascapeShaftCount / ChestBuyAmount) +
    math.floor(DeltascapeCrankCount / HandsBuyAmount) +
    math.floor(DeltascapeSpringCount / LegsBuyAmount) +
    math.floor(DeltascapePedalCount / FeetBuyAmount) +
    math.floor(DeltascapeBoltCount / AccessoryBuyAmount)

------------------------------  Sigmascape  ----------------------------------------------

    SigmascapeLensCount = GetItemCount(SigmascapeLensID)
    SigmascapeShaftCount = GetItemCount(SigmascapeShaftID)
    SigmascapeCrankCount = GetItemCount(SigmascapeCrankID)
    SigmascapeSpringCount = GetItemCount(SigmascapeSpringID)
    SigmascapePedalCount = GetItemCount(SigmascapePedalID)
    SigmascapeBoltCount = GetItemCount(SigmascapeBoltID)

    SigmascapeTurnInCount = math.floor(SigmascapeLensCount / HelmBuyAmount) +
    math.floor(SigmascapeShaftCount / ChestBuyAmount) +
    math.floor(SigmascapeCrankCount / HandsBuyAmount) +
    math.floor(SigmascapeSpringCount / LegsBuyAmount) +
    math.floor(SigmascapePedalCount / FeetBuyAmount) +
    math.floor(SigmascapeBoltCount / AccessoryBuyAmount)

------------------------------  Alphascape  ----------------------------------------------

    AlphascapeLensCount = GetItemCount(AlphascapeLensID)
    AlphascapeShaftCount = GetItemCount(AlphascapeShaftID)
    AlphascapeCrankCount = GetItemCount(AlphascapeCrankID)
    AlphascapeSpringCount = GetItemCount(AlphascapeSpringID)
    AlphascapePedalCount = GetItemCount(AlphascapePedalID)
    AlphascapeBoltCount = GetItemCount(AlphascapeBoltID)

    AlphascapeTurnInCount = math.floor(AlphascapeLensCount / HelmBuyAmount) +
    math.floor(AlphascapeShaftCount / ChestBuyAmount) +
    math.floor(AlphascapeCrankCount / HandsBuyAmount) +
    math.floor(AlphascapeSpringCount / LegsBuyAmount) +
    math.floor(AlphascapePedalCount / FeetBuyAmount) +
    math.floor(AlphascapeBoltCount / AccessoryBuyAmount)

    ------------------------------  Edengate  ----------------------------------------------

    EarlyHelmCount = GetItemCount(EarlyHelmID)
    EarlyArmorCount = GetItemCount(EarlyArmorID)
    EarlyGauntletCount = GetItemCount(EarlyGauntletID)
    EarlyChaussesCount = GetItemCount(EarlyChaussesID)
    EarlyGreavesCount = GetItemCount(EarlyGreavesID)
    EarlyAccessoryCount = GetItemCount(EarlyAccessoryID)

    EdengateTurnInCount = math.floor(EarlyHelmCount / HelmBuyAmount) +
    math.floor(EarlyArmorCount / ChestBuyAmount) +
    math.floor(EarlyGauntletCount / HandsBuyAmount) +
    math.floor(EarlyChaussesCount / LegsBuyAmount) +
    math.floor(EarlyGreavesCount / FeetBuyAmount) +
    math.floor(EarlyAccessoryCount / AccessoryBuyAmount)

        ------------------------------  Edenverse  ----------------------------------------------

    GoldenHelmCount = GetItemCount(GoldenHelmID)
    GoldenArmorCount = GetItemCount(GoldenArmorID)
    GoldenGauntletCount = GetItemCount(GoldenGauntletID)
    GoldenChaussesCount = GetItemCount(GoldenChaussesID)
    GoldenGreavesCount = GetItemCount(GoldenGreavesID)
    GoldenAccessoryCount = GetItemCount(GoldenAccessoryID)

    EdenverseTurnInCount = math.floor(GoldenHelmCount / HelmBuyAmount) +
    math.floor(GoldenArmorCount / ChestBuyAmount) +
    math.floor(GoldenGauntletCount / HandsBuyAmount) +
    math.floor(GoldenChaussesCount / LegsBuyAmount) +
    math.floor(GoldenGreavesCount / FeetBuyAmount) +
    math.floor(GoldenAccessoryCount / AccessoryBuyAmount)

        ------------------------------  Edenpromise  ----------------------------------------------

    LostHelmCount = GetItemCount(LostHelmID)
    LostArmorCount = GetItemCount(LostArmorID)
    LostGauntletCount = GetItemCount(LostGauntletID)
    LostChaussesCount = GetItemCount(LostChaussesID)
    LostGreavesCount = GetItemCount(LostGreavesID)
    LostAccessoryCount = GetItemCount(LostAccessoryID)

    EdenpromiseTurnInCount = math.floor(LostHelmCount / HelmBuyAmount) +
    math.floor(LostArmorCount / ChestBuyAmount) +
    math.floor(LostGauntletCount / HandsBuyAmount) +
    math.floor(LostChaussesCount / LegsBuyAmount) +
    math.floor(LostGreavesCount / FeetBuyAmount) +
    math.floor(LostAccessoryCount / AccessoryBuyAmount)


    if TotalExchangeItem > 0 then
        return true
    end
    
    if GordianTurnInCount < 1 and MidanTurnInCount < 1 and AlexandrianTurnInCount < 1 and DeltascapeTurnInCount < 1 and SigmascapeTurnInCount < 1 and AlphascapeTurnInCount < 1 and EdengateTurnInCount < 1 and EdenverseTurnInCount < 1 and EdenpromiseTurnInCount < 1 then
        return false
    else
        return true
    end
end

function GetOUT()
    repeat
        yield("/wait 0.1")
        if IsAddonVisible("SelectYesno") then
            yield("/pcall SelectYesno true 0")
        end
        if IsAddonVisible("SelectIconString") then
            yield("/pcall SelectIconString true -1")
        end
        if IsAddonVisible("SelectString") then
            yield("/pcall SelectString true -1")
        end
        if IsAddonVisible("ShopExchangeItem") then
            yield("/pcall ShopExchangeItem true -1")
        end
        if IsAddonVisible("RetainerList") then
            yield("/pcall RetainerList true -1")
        end
        if IsAddonVisible("InventoryRetainer") then
            yield("/pcall InventoryRetainer true -1")
        end
    until IsPlayerAvailable()
end

function FcAndSell()
    local WhereToComeBack = GetZoneID()
    yield("/li fc")
    while WhereToComeBack == GetZoneID() do
        yield("/wait 2")
    end
    PlayerTest()
    local YardId = GetZoneID()
    while YardId == GetZoneID() do
        if GetCharacterCondition(45) then
            yield("/wait 1")
        else
            if GetTargetName() ~= "Entrance" then
                yield("/target Entrance")
            elseif IsAddonVisible("SelectYesno") then
                yield("/pcall SelectYesno true 0")
            elseif GetDistanceToTarget() > 4  then
                local X = GetTargetRawXPos()
                local Y = GetTargetRawYPos()
                local Z = GetTargetRawZPos()
                WalkTo(X,Y,Z,4)
            else
                yield("/interact")
            end
        end
        yield("/wait 0.5")
    end
    PlayerTest()
    SummoningBellSell()
end

function WhichArmoryItem(ItemToBuy)
    local ArmoryId = ItemIdArmoryTable[ItemToBuy]
    return ArmoryId
end

function TurnIn(TableName,MaxArmoryValue)
    if HasPlugin("Automaton") then
        yield("/inventory")
        yield("/wait 0.1")
        yield("/inventory")
        yield("/wait 0.1")
        yield("/inventory")
    end
    local lastShopType = nil
    local LastIconShopType = nil
    local NpcName = "Sabina"
    if TableName == SabinaTable then
        NpcName = "Sabina"
    elseif TableName == GelfradusTable then
        NpcName = "Gelfradus"
    elseif TableName == YhalTable then
        npcName = "Yhal Yal"
    end
        

    local function OpenShopMenu(SelectIconString,SelectString,Npc)
        while IsAddonVisible("ShopExchangeItem") do
            yield("/pcall ShopExchangeItem true -1")
            yield("/wait 0.1")
        end
        while not IsAddonVisible("ShopExchangeItem") do
            yield("/wait 0.11")
            if GetTargetName() ~= Npc then
                yield("/target "..Npc)
            elseif IsAddonVisible("SelectIconString") then
                yield("/pcall SelectIconString true "..SelectIconString)
            elseif IsAddonVisible("SelectString") then
                yield("/pcall SelectString true " .. SelectString)
            else
                yield("/interact")
            end
        end
        yield("/wait 0.1")
        LogInfo("[ShopMenu]Should open SelectString "..SelectString)
        LogInfo("[ShopMenu]Should open SelectIconString "..SelectIconString)
    end

    local function Exchange(ItemID, List, Amount)
        local ItemCount = GetItemCount(ItemID)
        local ExpectedItemCount
        local brakepoint = 0
        if MaxArmory then
            ExpectedItemCount = ItemCount + Amount
        else
            if MaxItem then
                ExpectedItemCount = ItemCount + math.max(1, math.floor(Amount / 2))
            else
                ExpectedItemCount = ItemCount + Amount
            end
        end


        while true do
            yield("/wait 0.12")
            ItemCount = GetItemCount(ItemID)

            if IsAddonVisible("SelectYesno") then
                yield("/pcall SelectYesno true 0")
            elseif IsAddonVisible("Request") then
                yield("/wait 0.3")
            elseif IsAddonVisible("ShopExchangeItemDialog") then
                yield("/pcall ShopExchangeItemDialog true 0")
            elseif ItemCount >= ExpectedItemCount or ItemCount > 1 or brakepoint > 10 then 
                break
            elseif IsAddonVisible("ShopExchangeItem") then
                yield("/pcall ShopExchangeItem true 0 " .. List .. " " .. Amount)
                yield("/wait 0.6")
            end
            if MaxItem and ItemCount == GetItemCount(ItemID) and brakepoint > 5 then
                local newAmount = math.max(1, math.floor(Amount / 2))
                Amount = newAmount
                ExpectedItemCount = ItemCount + Amount
                if IsAddonVisible("Request") then
                    yield("/pcall Request true -1")
                end
                LogInfo("[Exchange] Adjusting amount to " .. Amount .. " for item ID " .. ItemID)
            end
            brakepoint = brakepoint + 1
        end
        yield("/wait 0.1") 
        LogInfo("[Exchange] Finished exchange for item ID " .. ItemID)
    end
    

    for i = 1, #TableName do
        local entry = TableName[i]
        local shopType = entry[1]
        local itemType = entry[2]
        local itemTypeBuy = entry[3]
        local gearItem = entry[4]
        local pcallValue = entry[5]
        local iconShopType = entry[6]
        local ItemAmount = GetItemCount(itemType)
        local GearAmount = GetItemCount(gearItem)
        local CanExchange = math.floor(ItemAmount / itemTypeBuy)
        local SlotINV = GetInventoryFreeSlotCount()
        local ArmoryType = WhichArmoryItem(gearItem)
        local SlotArmoryINV = GetFreeSlotsInContainer(ArmoryType)
        if MaxArmory then
            SlotINV = SlotINV - MaxArmoryFreeSlot
        end

        if CanExchange > 0 and GearAmount < 1 and SlotINV > 0 then
            LogInfo("Exchange start ...................")
            LogInfo("SlotINV: "..SlotINV)
            LogInfo("SlotArmoryINV: "..SlotArmoryINV)
            LogInfo("CanExchange: "..CanExchange)
            LogInfo("GearAmount: "..GearAmount)
            if shopType ~= lastShopType then
                OpenShopMenu(iconShopType,shopType,NpcName)
                lastShopType = shopType
            end
            if MaxArmoryValue then
                if SlotArmoryINV == 0 then
                else
                    if CanExchange < SlotArmoryINV then
                        Exchange(gearItem, pcallValue, CanExchange)
                    else
                        Exchange(gearItem, pcallValue, SlotArmoryINV)
                    end
                end
            else
                if MaxItem then
                    if CanExchange < SlotINV then
                        Exchange(gearItem, pcallValue, CanExchange)
                    else
                        Exchange(gearItem, pcallValue, SlotINV)
                    end
                else
                    Exchange(gearItem, pcallValue, 1)
                end
            end    
            if LastIconShopType ~= nil and iconShopType ~= LastIconShopType then
                GetOUT()
            end
            iconShopType = LastIconShopType
            LogInfo("Exchange END ...................")
        end
    end
    yield("/wait 0.1")
    GetOUT()
end

function DeliverooEnable()
    if DeliverooIsTurnInRunning() == false then
        yield("/wait 1")
        yield("/deliveroo enable")
    end
end

function GcDelivero()
    while DeliverooIsTurnInRunning() == false do
        yield("/wait 0.1")
        if IsInZone(129) then -- Limsa Lower
            LogInfo("[IdyllshireTurnin] Currently in Limsa Lower!")
            yield("/target Aetheryte")
            yield("/wait 0.1")
            AetheryteX = GetTargetRawXPos()
            AetheryteY = GetTargetRawYPos()
            AetheryteZ = GetTargetRawZPos()
            WalkTo(AetheryteX, AetheryteY, AetheryteZ, 7)
            yield("/li The Aftcastle")
            LogInfo("[IdyllshireTurnin] Heading to the Aftcastle")
            ZoneTransition()
        elseif IsInZone(128) then -- Limsa Upper
            LogInfo("[IdyllshireTurnin] Heading to the Limsa Upper GC")
            WalkTo(93.9, 40.175 , 75.409, 1)
            LogInfo("[IdyllshireTurnin] Limsa Upper GC has been reached!")
            DeliverooEnable()
        elseif IsInZone(130) then -- Ul'dah's GC
            LogInfo("[IdyllshireTurnin] Heading to Ul'Dah's GC")
            WalkTo(-142.361,4.1,-106.919, 1) 
            LogInfo("[IdyllshireTurnin] Ul'Dah's GC has been reached!")
            DeliverooEnable()
        elseif IsInZone(132) then -- Grdiania's GC
            LogInfo("[IdyllshireTurnin] Heading to Gridania's GC")
            WalkTo(-67.757, -0.501, -8.393, 1) 
            LogInfo("[IdyllshireTurnin] Gridania's GC has been reached!")
            DeliverooEnable()
        end
    end

    while DeliverooIsTurnInRunning() do
        yield("/wait 2")
    end
end

function MountUp()
    if IsInZone(478) or IsInZone(635) then
        while GetCharacterCondition(4, false) do
            yield("/wait 0.1")
            if GetCharacterCondition(27) then
                yield("/wait 2")
            else
                yield('/gaction "mount roulette"')
            end
        end
    else
        LogInfo("[Debug]Tried Mounting up but not at zone: 478(Idlishire)")
    end
end

function SummoningBellSell()
    yield("/ays itemsell")
    while TotalExchangeItem > 0 do
        yield("/wait 1")
        IsThereTradeItem()
    end
    PlayerTest()
end

-- Main code that runs it all

LogInfo("Script has started")

if MaxItem == false and MaxArmory then
    MaxArmory = false
    LogInfo("Wrong Option reverting MaxArmory.")
end
if MaxArmory then
    if IsAddonReady("ConfigCharacter") then
    else
    yield("/characterconfig")
    end

    while not IsAddonReady("ConfigCharacter") do
        yield("/wait 0.9")
    end
    yield("/pcall ConfigCharacter true 10 0 20")
    yield("/wait 0.1")
    yield("/pcall ConfigCharaItem true 18 298 1")
    yield("/pcall ConfigCharacter true 0")
    yield("/pcall ConfigCharacter true -1")
else
    if IsAddonReady("ConfigCharacter") then
    else
    yield("/characterconfig")
    end

    while not IsAddonReady("ConfigCharacter") do
        yield("/wait 0.9")
    end
    yield("/pcall ConfigCharacter true 10 0 20")
    yield("/wait 0.1")
    yield("/pcall ConfigCharaItem true 18 298 0")
    yield("/pcall ConfigCharacter true 0")
    yield("/pcall ConfigCharacter true -1")
end

while IsThereTradeItem() do
    yield("/wait 0.1")
    if (GordianTurnInCount >= 1 or AlexandrianTurnInCount >= 1 or MidanTurnInCount >= 1) and GetInventoryFreeSlotCount() ~= 0 then
        TeleportToIdlishire()
        local DistanceToSabina = GetDistanceToPoint(-19.0, 211.0, -35.9)
        if DistanceToSabina > 2 then
            MountUp()
            WalkTo(-19.0, 211.0, -35.9, 1)
        end
        if MaxArmory then
            TurnIn(SabinaTable,true)
        end
        TurnIn(SabinaTable,false)
    elseif (DeltascapeTurnInCount >= 1 or SigmascapeTurnInCount >= 1 or AlphascapeTurnInCount >= 1) and GetInventoryFreeSlotCount() ~= 0 then
        TeleportToRhalgr()
        local DistanceToYhal = GetDistanceToPoint(125.0,0.7,40.8)
        if DistanceToGelfradus > 2 then
            MountUp()
            WalkTo(125.0,0.7,40.8, 1)
        end
        if MaxArmory then
            TurnIn(GelfradusTable,true)
        end
        TurnIn(GelfradusTable,false)
    elseif (EdengateTurnInCount >= 1 or EdenverseTurnInCount >= 1 or EdenpromiseTurnInCount >= 1) and GetInventoryFreeSlotCount() ~= 0 then
        TeleportToEulmore()
        local DistanceToYhal = GetDistanceToPoint(-55.854,84.194,14.951)
        if DistanceToYhal > 2 then
            MountUp()
            WalkTo(-55.854,84.194,14.951, 1)
        end
        if MaxArmory then
            TurnIn(YhalTable,true)
        end
        TurnIn(YhalTable,false)
    end
        
    if TotalExchangeItem > 0 then
        if VendorTurnIn then
            if TeleportToFC then
                FcAndSell()
            else
                MountUp()
                if IsInZone(478) then
                    WalkTo(-1.6, 206.5, 50.1, 1)
                elseif IsInZone(635) then
                    WalkTo(-55.6,0.0,51.4, 1)
                elseif IsInZone(820) then
                    WalkTo(6.766,82.134,30.170, 1)
                end
                SummoningBellSell()
            end
        else
            TeleportGC()
            GcDelivero()
        end
    end
end

yield("TurnIn Finished.")
LogInfo("Script has completed it's use")
