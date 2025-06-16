if SERVER then
    include("minigames/sv_hacking.lua")
    AddCSLuaFile("minigames/cl_hacking.lua")
    AddCSLuaFile("minigames/cl_menu.lua")
else
    include("minigames/cl_hacking.lua")
    include("minigames/cl_menu.lua")
end
