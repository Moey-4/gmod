-- Optional: UI for linked props control menu if you want

util.AddNetworkString("hacktool_open_menu")
util.AddNetworkString("hacktool_toggle_prop")
util.AddNetworkString("hacktool_sync_props")

local currentConsole = nil
local linkedProps = {}

net.Receive("hacktool_open_menu", function()
    currentConsole = net.ReadEntity()
    if not IsValid(currentConsole) then return end

    local frame = vgui.Create("DFrame")
    frame:SetSize(350, 400)
    frame:Center()
    frame:SetTitle("Linked Props Control")
    frame:MakePopup()

    local propList = vgui.Create("DListView", frame)
    propList:Dock(FILL)
    propList:AddColumn("Prop Entity")

    for _, prop in ipairs(linkedProps) do
        if IsValid(prop) then
            local line = propList:AddLine(tostring(prop))
            line.propEntity = prop
        end
    end

    propList.OnRowSelected = function(lst, index, pnl)
        local prop = pnl.propEntity
        if not IsValid(prop) then return end

        local toggleBtn = vgui.Create("DButton")
        toggleBtn:SetText("Toggle Prop Visibility")
        toggleBtn.DoClick = function()
            net.Start("hacktool_toggle_prop")
            net.WriteEntity(currentConsole)
            net.WriteEntity(prop)
            net.SendToServer()
            frame:Close()
        end
        toggleBtn:DoModal()
    end
end)

net.Receive("hacktool_sync_props", function()
    currentConsole = net.ReadEntity()
    local count = net.ReadUInt(8)
    linkedProps = {}
    for i = 1, count do
        local prop = net.ReadEntity()
        if IsValid(prop) then
            table.insert(linkedProps, prop)
        end
    end
end)
