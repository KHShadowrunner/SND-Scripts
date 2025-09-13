--[[

********************************************************************************
*                 Lord of Verminion Weekly: Version x1.6.0                     *
********************************************************************************

 - Is it safe to use the script?
 - Nothing safe when you use automation. It has risk.

Description: Runs (and fails) "Master Battle Extreme" duty 5 times for the weekly 
challenge log that gives MGP. You must have "Master Battles for Lord of Verminion" 
unlocked in your duty finder for this to work.

********************************************************************************
*                               Required Plugins                               *
********************************************************************************

Plugins that are needed for it to work:

    -> Something Need Doing [Expanded Edition]: Main Plugin for everything to work
    -> Pandora (for /pcall - cuz /callback risks breaking)
    -> TextAdvance (because cutscenes are looooong)

********************************************************************************
*                               Configuration                                  *
********************************************************************************
]]

--[=====[
[[SND Metadata]]
author: 'Still Working On It'
version: 1.0.0
description: Lord of Verminion x 5 for Challenge Log Entries
configs:
  VerminionRuns:
    default: 5
    description: The number of runs of Verminion
    min: 1

[[End Metadata]]
--]=====]

local need_to_play = Config.Get("VerminionRuns")

--[[
********************************************************************************
*                        Global Constants & Services                           *
********************************************************************************
]]

for i=need_to_play, 1, -1 do
    if not Addons.GetAddon("ContentsFinder").Ready then yield("/dutyfinder") end
    yield("/waitaddon ContentsFinder")
    nodeDetails = Addons.GetAddon("ContentsFinder"):GetNode(1, 52, 61006, 2, 4, 2)
    while nodeDetails.IsVisible == false do
        yield("/pcall ContentsFinder true 12 1")
        yield("/pcall ContentsFinder true 3 7")
    end

    yield("/pcall ContentsFinder true 12 0 <wait.1>")
    if Addons.GetAddon("ContentsFinderConfirm").Ready then yield("/click ContentsFinderConfirm Commence") end

    while not Addons.GetAddon("LovmResult").Ready do
        yield("/wait 1")
    end

    yield("/pcall LovmResult false -2")
    yield("/pcall LovmResult true -1")
    repeat
        zone = Svc.ClientState.TerritoryType
        yield("/wait 1")
    until zone ~= 506
end    
