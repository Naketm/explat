local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local speed = 16
local power = 50
local FallDamage = true

task.spawn(function()
    while task.wait(0.1) do
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = speed
            hum.JumpPower = power
            hum.UseJumpPower = true
        end
    end
end)

local namecall
namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and FallDamage == false then
        if method == "FireServer" and self.Name == "Event" and args[1] == "FallDamage" then
            args[2].OriginalDamage = 0
            args[2].Range = 0
            args[2].Damage = 0
        end
    end

    return namecall(self, ...)
end))

local function getPlayerNames()
    local names = {}
    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local function teleportToPlayer(targetName)
    local targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer then return end

    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end

    local targetPos
    pcall(function()
        if targetPlayer.Character then
            targetPos = targetPlayer.Character:GetPivot().Position
        end
    end)

    if targetPos then
        LocalPlayer:RequestStreamAroundAsync(targetPos)
        
        task.wait(0.05) 
        
        myHrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
        
        myHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    else
        Rayfield:Notify({
            Title = "fail",
            Content = "nil probz",
            Duration = 3
        })
    end
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "miau meow meooww miau",
   Icon = 0, 
   LoadingTitle = "jax's little playground",
   LoadingSubtitle = "by jax!",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "JaxHub", 
      FileName = "MainConfig"
   },
   KeySystem = true,
   KeySettings = {
      Title = "jax's key stuff",
      Subtitle = "Key System",
      Note = "Key is: jax", 
      FileName = "Key", 
      SaveKey = true,
      GrabKeyFromSite = false, 
      Key = {"jax"} 
   }
})

local Tab = Window:CreateTab("Miscellaneous")

local Toggle = Tab:CreateToggle({
   Name = "Fall Damage",
   CurrentValue = true,
   Flag = "FallDamageToggle",
   Callback = function(Value)
       FallDamage = Value
   end,
})

local SliderSpeed = Tab:CreateSlider({
   Name = "WalkSpeed",
   Range = {0, 100},
   Increment = 5,
   Suffix = " speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
       speed = Value
   end,
})

local SliderJump = Tab:CreateSlider({
   Name = "JumpPower",
   Range = {0, 250},
   Increment = 10,
   Suffix = " power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
       power = Value
   end,
})

local Dropdown = Tab:CreateDropdown({
    Name = "Teleport To",
    Options = getPlayerNames(),
    CurrentOption = {""},
    MultipleOptions = false,
    Flag = "TeleportDropdown",
    Callback = function(Options)
        teleportToPlayer(Options[1])
    end,
})

Tab:CreateButton({
   Name = "Refresh Player List",
   Callback = function()
       Dropdown:Refresh(getPlayerNames(), true)
   end,
})
