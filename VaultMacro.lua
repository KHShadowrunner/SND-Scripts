--[[
//////////////////////////////////////////////////////////////////////////////////////////////
//                                   WARNING                                                //
//////////////////////////////////////////////////////////////////////////////////////////////

This LUA script is for personal use. It is designed specifically for a specific setup and with a specific
BLU job list in mind. It will almost always not work unless configured explicitly as it expects. Even
then, it is prone to failing for one reason or another. You are almost entirely on your own if you wish to try
to use it. There are surely MUCH more optimal ways to do this. But this is mine. And it works for me.
--]]

import("System.Numerics")

function HasStatus(id)
    local statuses = Player.Status
    for i = 0, 29 do
        local status = statuses[i]
        if status and status.StatusId == id then
            return true
        end
    end
    return false
end

function MeshCheck()
    local was_ready = IPC.vnavmesh.IsReady()
    if not IPC.vnavmesh.IsReady() then
        while not IPC.vnavmesh.IsReady() do
            Dalamud.Log("[Debug]Building navmesh, currently at " .. Truncate1Dp(NavBuildProgress() * 100) .. "%")
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

-- Initialization
looptotal = 80

-- Start Macro
for i = 1, looptotal, 1 do

-- Get into the Instance
    Instances.DutyFinder.IsUnrestrictedParty = true
    Instances.DutyFinder.IsLevelSync = true
    Instances.DutyFinder:QueueDuty(34)
    yield("/waitaddon ContentsFinderConfirm")
    if Addons.GetAddon("ContentsFinderConfirm").Ready then yield("/click ContentsFinderConfirm Commence") end
    repeat
      yield("/wait 1")
    until Svc.ClientState.TerritoryType == 1066 and Addons.GetAddon("_Image").Ready

-- Check for Basic Instict and Cast It
    while not HasStatus(2498) do
        if Player.Entity and Player.Entity.IsCasting then
            yield('/wait 0.5')
        else
            yield("/hold CONTROL")
            yield('/send KEY_3')
            yield("/release CONTROL")
        end
    end
    yield('/wait 2')

-- Moving up to first pack
    WalkTo(-0.47,-299.982,56.104, 1)

-- Attack First Pack and recheck for Basic
    yield('/wait 0.5')

    yield('/send F11 <wait.0.5>')
    yield('/send 51 <wait.0.3>')
    yield('/send 49 <wait.2.5>')
    yield('/send 53 <wait.1>')
    yield('/target Vault Ostiary')
    yield('/send 52 <wait.1>')
    yield('/send 54 <wait.0.7>')

    while Svc.Condition[26] do
        yield('/send 50 <wait.2.5>')
    end

-- Sprint to Pack2
    yield('/hold CONTROL')
    yield('/send KEY_0 <wait.0.1>')
    yield('/release CONTROL')
    WalkTo(51.53,-299.98,-9.55,1)

-- Kill Pack 2 Ez
    yield('/send KEY_1 <wait.2>')
    yield('/send KEY_9 <wait.1>')
    yield('/send KEY_0 ')

-- Run to Pack 3
    WalkTo(-8.25,-299.99,-30.000,1)

-- Attack 3rd Pack
    yield('/wait 1')
    yield('/send KEY_1 <wait.2>')
    WalkTo(-11.01,-299.99,-30.000,1)
    yield('/wait 1')
    yield('/target Vault Deacon <wait.0.2>')
    yield('/send 70')
    yield('/wait 0.5')
    yield('/send KEY_7 <wait.4.5>')
    yield('/send KEY_7 <wait.2.5>')

    while Svc.Condition[26] do
        yield('/send 50 <wait.2.5>')
    end

-- Move to Final Pack
    WalkTo(-16.35,-300,-68.76,1)

-- Kill Last Pack
    yield('/wait 1')
    yield('/send KEY_1 <wait.2>')
    yield('/send KEY_8 <wait.0.8>')
    yield('/send KEY_8 <wait.0.8>')
    yield('/send KEY_8 <wait.0.8>')
    yield('/send KEY_8 <wait.0.8>')
    yield('/send RETURN')
    yield('/send KEY_3 <wait.1.5>')
    yield('/send KEY_5 <wait.1>')

    while Svc.Condition[26] do
        yield('/send 50 <wait.2.5>')
    end

-- Take us out
    yield('/wait 3')
    InstancedContent.LeaveCurrentContent()
    yield('/echo Loop: ' .. i)
    repeat
        yield('/wait 0.5')
    until not (Svc.ClientState.TerritoryType == 1066) and not Svc.Condition[34] and not Svc.Condition[56] and not Svc.Condition[45]
end

--If We Get Here, END IT
yield('/shutdown')
yield('/send TAB <wait.0.5>')
yield('/send TAB <wait.0.5>')
yield('/wait 1')
--yield('/send RETURN')
