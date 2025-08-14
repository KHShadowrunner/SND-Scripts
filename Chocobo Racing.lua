--[=====[
[[SND Metadata]]
author: 'Still Working On It'
version: 1.0.0
description: Chocobo Racing Runs x20 for Challenge Log Entries
configs:
  NumberOfRacesToRun:
    description: The number of races you want to run.
    type: interger
    minimum: 1
    required: true

[[End Metadata]]
--]=====]
totalruns  = Config.Get("NumberOfRacesToRun")
yield("/echo Starting")
racenum = 0
for loops = totalruns, 0, -1 do    
    
    yield("/wait 1")
    racenum = racenum+1
    yield("/echo Queueing for Race Number:"..racenum)

    zone = Svc.ClientState.TerritoryType 

    if not Addons.GetAddon("JournalDetail").Ready then yield("/dutyfinder") end
    yield("/waitaddon JournalDetail")
    yield("/pcall ContentsFinder true 1 9")
    yield("/pcall ContentsFinder true 12 1")
    yield("/pcall ContentsFinder true 3 15")
    yield("/pcall ContentsFinder true 12 0 <wait.1>")
    yield("/waitaddon ContentsFinderConfirm")
    if Addons.GetAddon("ContentsFinderConfirm").Ready then yield("/click ContentsFinderConfirm Commence") end

    repeat
        yield("/wait 1")
    zone = Svc.ClientState.TerritoryType 
    until zone == 390
    yield("/wait 7")
    yield("/hold A")
    yield("/wait 10")
    yield("/release A")
    yield("/wait 1")
    yield("/hold D")
    yield("/wait 1")
    yield("/release D")
    yield("/wait 35")
    yield("/hold A")
    yield("/wait 5")
    yield("/release A")
    yield("/hold W")
    yield("/wait 10")
    repeat
        yield("/hold W")
        yield("/send KEY_1")
        yield("/send KEY_2")
        yield("/wait 2")
    until Addons.GetAddon("RaceChocoboResult").Ready
    yield("/release W")
    yield("/wait 9")
    yield("/pcall RaceChocoboResult true 1 1")
    repeat
        zone = Svc.ClientState.TerritoryType
        yield("/wait 1")
    until zone ~= 390
end
yield("/echo Chocobo Racing Complete.")
