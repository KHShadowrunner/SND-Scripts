--[[

********************************************************************************
*                 Triple Triad Challenge Script: Version x1.6.0                *
********************************************************************************

 - Is it safe to use the script?
 - Nothing safe when you use automation. It has risk.

Description: Enters the Battle Hall duty for the weekly 
challenge log that gives MGP. You must have the Saucy Plugin 
installed and have "Enable Triad Module" enabled, recommendations are to have 
Open Saucy When Challenging an NPC checked as well as Automatically choose your
deck with the best win chance. You must manually set Play X Amount of Times.

********************************************************************************
*                               Required Plugins                               *
********************************************************************************

Plugins that are needed for it to work:

    -> Something Need Doing [Expanded Edition]: Main Plugin for everything to work
    -> Saucy (To actually do Triple Triad)
    -> Pandora (for /pcall - cuz /callback risks breaking)
    -> TextAdvance (because cutscenes are looooong)

********************************************************************************
*                               Configuration                                  *
********************************************************************************
]]

import("System.Numerics")

function WalkTo(valuex, valuey, valuez, stopdistance)
    MeshCheck()
    local dest = Vector3(valuex, valuey, valuez)
    IPC.vnavmesh.PathfindAndMoveTo(dest, false)
    while ((IPC.vnavmesh.IsRunning() or IPC.vnavmesh.PathfindInProgress()) and Vector3.Distance(Entity.Player.Position, dest) > stopdistance) do
        yield("/wait 0.3")
    end
    IPC.vnavmesh.Stop()
    Dalamud.Log("[WalkTo] Completed")
end

function MeshCheck()
    local was_ready = IPC.vnavmesh.IsReady()
    if not IPC.vnavmesh.IsReady() then
        while not IPC.vnavmesh.IsReady() do
            Dalamud.Log("[Debug]Building navmesh, currently at " .. Truncate1Dp(IPC.vnavmesh.BuildProgress() * 100) .. "%")
            yield("/wait 1")
            local was_ready = IPC.vnavmesh.IsReady()
            if was_ready then
                Dalamud.Log("[Debug]Navmesh ready!")
            end
        end
    else
        Dalamud.Log("[Debug]Navmesh ready!")
    end
end

if not Addons.GetAddon("ContentsFinder").Ready then yield("/dutyfinder") end
yield("/waitaddon ContentsFinder")
nodeDetails = Addons.GetAddon("ContentsFinder"):GetNode(1, 52, 6, 2, 4, 2)
while nodeDetails.IsVisible == false do
    yield("/pcall ContentsFinder true 12 1")
    yield("/pcall ContentsFinder true 3 1")
end
yield("/pcall ContentsFinder true 12 0 <wait.1>")
if Addons.GetAddon("ContentsFinderConfirm").Ready then yield("/click ContentsFinderConfirm Commence") end
repeat
    zone = Svc.ClientState.TerritoryType
    yield("/wait 1")
until zone == 579
WalkTo(8.87, -1.03, -6.38,1)
repeat
    yield("/target Prideful Stag")
    yield("/wait 0.5")
until Entity.Target.Name == "Prideful Stag"
repeat
    yield("/interact")
    yield("/wait 0.5")
until Addons.GetAddon("SelectIconString").Ready
yield("/pcall SelectIconString true 0")
yield("/waitaddon TripleTriadRequest")
repeat
    yield("/wait 1")
until not Player.IsBusy
yield("/dutyfinder")
yield("/waitaddon ContentsFinderMenu")
yield("/callback ContentsFinderMenu true 0")
yield("/waitaddon SelectYesno")
yield("/callback SelectYesno true 0")




