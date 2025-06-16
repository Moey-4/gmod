include("shared.lua")

local propMap = {}

net.Receive("hacktool_sync_props", function()
    local console = net.ReadEntity()
    local count = net.ReadUInt(8)
    propMap[console] = {}

    for i = 1, count do
        local prop = net.ReadEntity()
        if IsValid(prop) then
            table.insert(propMap[console], prop)
        end
    end
end)

net.Receive("hacktool_open_menu", function()
    local console = net.ReadEntity()
    if not IsValid(console) then return end

    local props = propMap[console] or {}
    local frame = vgui.Create("DFrame")
    frame:SetTitle("Console Controls")
    frame:SetSize(320, 400)
    frame:Center()
    frame:MakePopup()

    local y = 35

    if #props == 0 then
        local lbl = vgui.Create("DLabel", frame)
        lbl:SetText("No props linked to this console.")
        lbl:SetPos(10, y)
        lbl:SizeToContents()
        return
    end

    for _, prop in ipairs(props) do
        if not IsValid(prop) then continue end
        local btn = vgui.Create("DButton", frame)
        btn:SetText("Toggle: " .. tostring(prop:GetModel()))
        btn:SetPos(10, y)
        btn:SetSize(300, 30)
        btn.DoClick = function()
            net.Start("hacktool_toggle_prop")
            net.WriteEntity(console)
            net.WriteEntity(prop)
            net.SendToServer()
        end
        y = y + 35
    end
end)
