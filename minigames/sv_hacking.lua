util.AddNetworkString("OpenHackingMinigame")
util.AddNetworkString("HackingMinigameResult")

local activeMinigames = {}

function RunHackingMinigame(ply, callback)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    activeMinigames[ply] = callback

    net.Start("OpenHackingMinigame")
    net.Send(ply)
end

net.Receive("HackingMinigameResult", function(len, ply)
    local success = net.ReadBool()

    local callback = activeMinigames[ply]
    if callback then
        callback(success)
        activeMinigames[ply] = nil
    end
end)
