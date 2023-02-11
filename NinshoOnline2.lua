-- Ninsho Online 2
-- Variables
local Players           = game:GetService("Players")
local LocalPlayer       = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
-- Sort
local function Sort(Table)
    table.sort(Table, function(a,b)
        return a:lower() < b:lower()
    end)
    return Table
end
-- Repository
local Repository = "https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/"
-- Library | Themes | Saves
local Library      = loadstring(game:HttpGet(Repository .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(Repository .. "addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet(Repository .. "addons/SaveManager.lua"))()
-- Window
local Window = Library:CreateWindow({
    Title    = "Square Piece 2",
    Center   = true, 
    AutoShow = true,
})
-- Tabs
local Tabs = {
    ["Main"]        = Window:AddTab("Main"),
    ["UI Settings"] = Window:AddTab("UI Settings"),
}
-- Training
local Training = Tabs["Main"]:AddLeftGroupbox("Training")
-- Pushup Training
Training:AddToggle("Pushup Training", {
    Text = "Pushup Training",
    Default = false,
    Tooltip = "Automatically Does Pushup Training",
})
-- Block Training
Training:AddToggle("Block Training", {
    Text = "Block Training",
    Default = false,
    Tooltip = "Automatically Does Block Training",
})
-- Handsign Training
Training:AddToggle("Handsign Training", {
    Text = "Handsign Training",
    Default = false,
    Tooltip = "Automatically Does Handsign Training",
})
-- Meditation Training
Training:AddToggle("Meditation Training", {
    Text = "Meditation Training",
    Default = false,
    Tooltip = "Automatically Does Meditation Training",
})
-- Auto Training
Training:AddToggle("Auto Training", {
    Text = "Auto Training",
    Default = false,
    Tooltip = "Automatically Buys And Equips Selected Training",
})
-- Library functions
Library:OnUnload(function()
    print("Unloaded!")
    Library.Unloaded = true
end)
-- UI Settings
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton("Unload", function() Library:Unload() end)
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "LeftAlt", NoUI = true, Text = "Menu keybind" }) 
Library.ToggleKeybind = Options.MenuKeybind
-- Themes | Saves
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
-- Saves
SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({ "MenuKeybind" }) 
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:BuildConfigSection(Tabs["UI Settings"]) 
-- Themes
ThemeManager:ApplyToTab(Tabs["UI Settings"])
-- Pushup Training | Toggle
local Pushup; Toggles["Pushup Training"]:OnChanged(function()
	if Toggles["Pushup Training"].Value then
		for i, v in pairs(Toggles) do
			if v == Toggles["Pushup Training"] or v == Toggles["Auto Training"] then continue end
			if string.match(i, "Training") and v.Value then
				v:SetValue(false)
			end
		end
	end
end)
-- Block Training | Toggle
local Block; Toggles["Block Training"]:OnChanged(function()
	if Toggles["Block Training"].Value then
		for i, v in pairs(Toggles) do
			if v == Toggles["Block Training"] or v == Toggles["Auto Training"] then continue end
			if string.match(i, "Training") and v.Value then
				v:SetValue(false)
			end
		end
	end
end)
-- Handsign Training | Toggle
local Handsign; Toggles["Handsign Training"]:OnChanged(function()
	if Toggles["Handsign Training"].Value then
		for i, v in pairs(Toggles) do
			if v == Toggles["Handsign Training"] or v == Toggles["Auto Training"] then continue end
			if string.match(i, "Training") and v.Value then
				v:SetValue(false)
			end
		end
	end
	if Handsign == nil and Toggles["Handsign Training"].Value then
		Handsign = LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(Child)
			if Child.Name == "Click" and Child:IsA("Sound") then
				print("Click"); LocalPlayer.Character["Handsign Training"]:Activate()
			end
		end)
	elseif Handsign and not Toggles["Handsign Training"].Value then
		Handsign:Disconnect(); Handsign = nil
	end
end)
-- Meditation Training | Toggle
local Meditation; Toggles["Meditation Training"]:OnChanged(function()
	if Toggles["Meditation Training"].Value then
		for i, v in pairs(Toggles) do
			if v == Toggles["Meditation Training"] or v == Toggles["Auto Training"] then continue end
			if string.match(i, "Training") and v.Value then
				v:SetValue(false)
			end
		end
	end
	if Meditation == nil and Toggles["Meditation Training"].Value then
		Meditation = LocalPlayer.Character.HumanoidRootPart.ChildAdded:Connect(function(Child)
			if Child.Name == "Click" and Child:IsA("Sound") then
				print("Click"); LocalPlayer.Character["Meditation Training"]:Activate()
			end
		end)
	elseif Meditation and not Toggles["Meditation Training"].Value then
		Meditation:Disconnect(); Meditation = nil
	end
end)
-- Auto Train | Toggle
local Active; Toggles["Auto Training"]:OnChanged(function()
	task.spawn(function()
		while Toggles["Auto Training"].Value do task.wait()
			for i, v in pairs(Toggles) do
				if v ~= Toggles["Auto Training"] and string.match(i, "Training") and v.Value then
					if not LocalPlayer.Character:FindFirstChild(i) and not LocalPlayer.Backpack:FindFirstChild(i) then Active = false
						for i2, v2 in pairs(workspace.Shops:GetDescendants()) do
							if v2.Name == "Head" and string.match(v2.Parent.Name, i) then
								fireclickdetector(v2:FindFirstChildOfClass("ClickDetector"))
							end
						end
					elseif (LocalPlayer.Character:FindFirstChild(i) or LocalPlayer.Backpack:FindFirstChild(i)) and not Active then
						if LocalPlayer.Backpack:FindFirstChild(i) then LocalPlayer.Backpack:FindFirstChild(i).Parent = LocalPlayer.Character end
						task.wait(1) LocalPlayer.Character:FindFirstChild(i):Activate(); Active = true
					end
				end
			end
		end
	end)
end)
-- Refresh Players
function RefreshPlayers()
    local PlayerList = {}
    for i,v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            table.insert(PlayerList, v.Name)
        end
    end
    for i, v in pairs(Options) do
        if string.match(i, "PlayerDropdown") then
            v.Values = Sort(PlayerList)
	        v:SetValues()
            if typeof(v.Value) == "table" then
                for Selection,_ in pairs(v.Value) do
                    if table.find(PlayerList, Selection) then continue else
                        table.remove(v.Value, table.find(v.Value, Selection))
                        v:SetValue(v.Value)
                    end
                end
            elseif typeof(v.Value) == "string"then
                if table.find(PlayerList, v.Value) then
                    v:SetValue(v.Value)
                else
                    print(unpack(PlayerList))
                    v:SetValue(nil)
                end
            end
        end
    end
end
RefreshPlayers()
Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(RefreshPlayers)
