AddCSLuaFile()

util.AddNetworkString("hacktool_open_menu")
util.AddNetworkString("hacktool_toggle_prop")
util.AddNetworkString("hacktool_sync_props")

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    local tr = ply:GetEyeTrace()
    if not IsValid(tr.Entity) or tr.Entity:GetClass() ~= "ent_hack_console" then return end

    local console = tr.Entity
    local minigame = ents.Create("logic_case")
    if IsValid(minigame) then
        minigame:SetPos(console:GetPos())
        minigame:Spawn()
        minigame:Activate()
        SafeRemoveEntityDelayed(minigame, 1)

        timer.Simple(2, function()
            if IsValid(console) then
                console:SetNWBool("IsHacked", true)
                ply:ChatPrint("Console hacked successfully!")
            end
        end)
    end
end

function SWEP:Think()
    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    if ply:KeyPressed(IN_USE) and ply:KeyDown(IN_RELOAD) then
        local tr = ply:GetEyeTrace()
        local ent = tr.Entity
        if IsValid(ent) and ent:GetClass() == "ent_hack_console" and ent:GetNWBool("IsHacked", false) then
            net.Start("hacktool_open_menu")
            net.WriteEntity(ent)
            net.Send(ply)

            net.Start("hacktool_sync_props")
            net.WriteEntity(ent)
            net.WriteUInt(#(ent.LinkedProps or {}), 8)
            for _, prop in ipairs(ent.LinkedProps or {}) do
                net.WriteEntity(prop)
            end
            net.Send(ply)
        end
    end
end

net.Receive("hacktool_toggle_prop", function(len, ply)
    local console = net.ReadEntity()
    local prop = net.ReadEntity()
    if not IsValid(console) or not IsValid(prop) then return end
    if not (console:GetNWBool("IsHacked", false) and table.HasValue(console.LinkedProps or {}, prop)) then return end

    local noDraw = not prop:GetNoDraw()
    prop:SetNoDraw(noDraw)
    prop:SetMaterial(noDraw and "models/effects/vol_light001" or "")
    prop:SetCollisionGroup(noDraw and COLLISION_GROUP_IN_VEHICLE or COLLISION_GROUP_NONE)
end)
