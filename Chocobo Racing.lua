yield("/echo Starting")
racenum = 0
for loops = 20, 1, -1 do    
    
    yield("/wait 1")
    racenum = racenum+1
    yield("/echo Queueing for Race Number:"..racenum)

    zone = GetZoneID()

    if IsAddonVisible("JournalDetail")==false then yield("/dutyfinder") end
    yield("/waitaddon JournalDetail")
    yield("/pcall ContentsFinder true 1 9")
    yield("/pcall ContentsFinder true 12 1")
    yield("/pcall ContentsFinder true 3 15")
    yield("/pcall ContentsFinder true 12 0 <wait.1>")
    yield("/waitaddon ContentsFinderConfirm")
    if IsAddonVisible("ContentsFinderConfirm") then yield("/click ContentsFinderConfirm Commence") end

    repeat
        yield("/wait 1")
    zone = GetZoneID()
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
    until IsAddonVisible("RaceChocoboResult")==true
    yield("/release W")
    yield("/wait 9")
    yield("/pcall RaceChocoboResult true 1 1")
    repeat
        zone = GetZoneID()
        yield("/wait 1")
    until zone ~= 390
end