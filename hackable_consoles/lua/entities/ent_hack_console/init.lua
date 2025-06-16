AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_lab/workspace004.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

    self:SetColor(Color(255, 0, 0))
    self:SetNWBool("IsHacked", false)
    self.LinkedProps = {}
end

function ENT:Think()
    local isHacked = self:GetNWBool("IsHacked", false)
    self:SetColor(isHacked and Color(0, 255, 0) or Color(255, 0, 0))

    self:NextThink(CurTime() + 0.5)
    return true
end

function ENT:LinkProp(prop)
    if not self.LinkedProps then self.LinkedProps = {} end
    table.insert(self.LinkedProps, prop)
end