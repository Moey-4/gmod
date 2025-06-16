SWEP.PrintName = "Hacktool"
SWEP.Author = "YourName"
SWEP.Instructions = "Right click to hack, E+R on hacked console to control"
SWEP.Category = "Hackable Consoles"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Base = "weapon_base"

SWEP.ViewModel = "models/swcw_items/sw_datapad_v.mdl"
SWEP.WorldModel = "models/swcw_items/sw_datapad.mdl"

SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.ClipSize = -1
SWEP.Primary.Ammo = "none"

SWEP.Secondary = SWEP.Primary

function SWEP:Initialize()
    self:SetHoldType("pistol")
end
