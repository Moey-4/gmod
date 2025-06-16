AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Hackable Console"
ENT.Author = "Moey-4"
ENT.Spawnable = true

function ENT:Initialize()
    self:SetModel("models/props_lab/reciever01b.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetNWBool("IsHacked", false)
    self.LinkedProps = self.LinkedProps or {}

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end
end

function ENT:Use(activator, caller)
    if not activator:IsPlayer() then return end
    if self:GetNWBool("IsHacked", false) then
        activator:ChatPrint("Console already hacked.")
    else
        activator:ChatPrint("This console needs to be hacked.")
    end
end

function ENT:LinkProp(prop)
    if not IsValid(prop) then return end
    self.LinkedProps = self.LinkedProps or {}
    if not table.HasValue(self.LinkedProps, prop) then
        table.insert(self.LinkedProps, prop)
    end
end

function ENT:UnlinkProp(prop)
    if not IsValid(prop) then return end
    self.LinkedProps = self.LinkedProps or {}
    for i, v in ipairs(self.LinkedProps) do
        if v == prop then
            table.remove(self.LinkedProps, i)
            break
        end
    end
end
