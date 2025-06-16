TOOL.Category = "Hackable Consoles"
TOOL.Name = "#Console Linker"
TOOL.Command = nil
TOOL.ConfigName = ""

if CLIENT then
    language.Add("tool.console_linker.name", "Console Linker")
    language.Add("tool.console_linker.desc", "Link hackable consoles to props")
    language.Add("tool.console_linker.0", "Left click a console to select. Left click props to link. Reload to clear selection.")
end

-- Store selected console per player
TOOL.SelectedConsole = TOOL.SelectedConsole or {}

function TOOL:LeftClick(trace)
    if CLIENT then return true end

    local ply = self:GetOwner()
    local ent = trace.Entity

    if not IsValid(ent) then return false end

    -- Debugging (optional)
    print("[Console Linker] Clicked entity:", ent, "Class:", ent:GetClass())

    -- Select a console
    if ent:GetClass() == "ent_hack_console" then
        self.SelectedConsole[ply] = ent
        ply:ChatPrint("[Console Linker] Selected console: " .. tostring(ent))
        return true
    end

    -- Link a prop to the selected console
    local console = self.SelectedConsole[ply]
    if IsValid(console) and ent:GetClass() ~= "ent_hack_console" then
        console.LinkedProps = console.LinkedProps or {}

        if not table.HasValue(console.LinkedProps, ent) then
            table.insert(console.LinkedProps, ent)
            ply:ChatPrint("[Console Linker] Linked prop to console.")
        else
            ply:ChatPrint("[Console Linker] This prop is already linked.")
        end

        return true
    end

    return false
end

function TOOL:Reload(trace)
    if CLIENT then return true end

    local ply = self:GetOwner()
    self.SelectedConsole[ply] = nil
    ply:ChatPrint("[Console Linker] Cleared selected console.")
    return true
end

function TOOL.BuildCPanel(panel)
    panel:AddControl("Header", {
        Description = "Link hackable consoles to props. Left click a console, then left click props to link. Reload to clear selection."
    })
    panel:Button("Spawn Hackable Console", "console_linker_spawn_console")
end

if SERVER then
    concommand.Add("console_linker_spawn_console", function(ply)
        if not IsValid(ply) then return end

        local ent = ents.Create("ent_hack_console")
        if not IsValid(ent) then return end

        local tr = ply:GetEyeTrace()
        ent:SetPos(tr.HitPos + tr.HitNormal * 16)
        ent:Spawn()
        ent:Activate()

        ply:ChatPrint("[Console Linker] Spawned a hackable console.")
    end)
end
