local LibChallengeInfo = LibStub:NewLibrary("LibChallengeInfo", 1)

if not LibChallengeInfo then
    return
end

function LibChallengeInfo:GetRating(unit)
    if not unit or not UnitIsPlayer(unit) then
        return nil
    end

    return C_PlayerInfo.GetPlayerMythicPlusRatingSummary(unit).currentSeasonScore
end

function LibChallengeInfo:GetChallengeTables(unit)
    if not unit or not UnitIsPlayer(unit) then
        return nil
    end

    local rating = C_PlayerInfo.GetPlayerMythicPlusRatingSummary(unit)
    local runs = {}

    local name, best, texture, bg, colorTable
    for _, r in ipairs(rating.runs) do
        best = r.bestRunLevel
        name, _, _, texture, bg = C_ChallengeMode.GetMapUIInfo(r.challengeModeID)
        --colorTable = C_ChallengeMode.GetSpecificDungeonScoreRarityColor(r.mapScore)
        --colorTable = C_ChallengeMode.GetDungeonScoreRarityColor(r.mapScore)
        colorTable = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor(r.mapScore)
        tinsert(runs, { name, best, texture, bg, colorTable })
    end
    return rating.currentSeasonScore, runs
end

local function getChallengeTableByName(runs, mapName)

    local name, best, texture, bg, colorTable
    for _, r in ipairs(runs) do
        name, _, texture, bg = C_ChallengeMode.GetMapUIInfo(r.challengeModeID)
        if name == mapName then
            best = r.bestRunLevel
            colorTable = C_ChallengeMode.GetSpecificDungeonScoreRarityColor(r.mapScore)
            return name, best, texture, bg, colorTable
        end
    end

end

local function getChallengeTableByID(runs, mapID)

    local name, best, texture, bg, colorTable
    for _, r in ipairs(runs) do
        if r.challengeModeID == mapID then
            best = r.bestRunLevel
            name, _, texture, bg = C_ChallengeMode.GetMapUIInfo(r.challengeModeID)
            colorTable = C_ChallengeMode.GetSpecificDungeonScoreRarityColor(r.mapScore)
            return name, best, texture, bg, colorTable
        end
    end

end

function LibChallengeInfo:GetChallengeInfo(unit, map)

    if not unit or not UnitIsPlayer(unit) or not map then
        return nil
    end

    if type(map) == 'number' then
        getChallengeTableByID(C_PlayerInfo.GetPlayerMythicPlusRatingSummary(unit), map)
    else
        getChallengeTableByName(C_PlayerInfo.GetPlayerMythicPlusRatingSummary(unit), map)
    end

end
