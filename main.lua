-- List of whitelisted player names
local whitelist = {
["LOVEAURA_NESZZ"] = true,
["ISLANDMEPLS"] = true,
["gosubnowpls"] = true,
["LurewKai"] = true,
["BruhCash4Me"] = true,
["SubtoxivixYT"] = true,
["noaking1245"] = true,
["reenrop123"] = true,
["SaitamaDgold"] = true,
["M8_k3r"] = true,
["mohamrd5566"] = true,
["Smg_434"] = true,
["yunar55"] = true,
["expade1"] = true,
["1wpeiqr"] = true,
["Kenvang54"] = true,
["noobieeee121"] = true,
["catalinz44"] = true,
["antflixx1"] = true,
["Hunterkiller2425"] = true,
["David240710"] = true,
["mikey12th123"] = true,
["EJGAMINGGGXXXDYT"] = true,
["vincentthemazeoflege"] = true,
["KimberlyBranch5"] = true,
}

-- Function to check if a player is whitelisted
local function isWhitelisted(player)
    return whitelist[player.Name] == true
end

-- Function to handle player joining
game.Players.PlayerAdded:Connect(function(player)
    if not isWhitelisted(player) then
        player:Kick("You are not whitelisted please buy the script!")
    else
        print(player.Name .. " has joined the game.")
        -- Activate loadstring for whitelisted players

    end
end)

-- Check existing players
for _, player in ipairs(game.Players:GetPlayers()) do
    if not isWhitelisted(player) then
        player:Kick("You are not whitelisted please buy the script!")
    else
        -- Activate loadstring for  players
    loadstring(game:HttpGet("https://pastebin.com/raw/1sdNAmkM"))()
    end
end
