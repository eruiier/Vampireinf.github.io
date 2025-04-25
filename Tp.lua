local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local teleportPosition = Vector3.new(57, 3, -9000)
local delayTime = 0.1
local isTeleporting = true

local function enableNoclip()
    game:GetService("RunService").Stepped:Connect(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end)
    end)
    print("Noclip mode enabled.")
end

enableNoclip()

-- Teleport loop
spawn(function()
    while isTeleporting do
        if humanoid.Sit then
            print("Character is sitting. Teleporting stopped.")
            isTeleporting = false
            break
        end

        humanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(delayTime)
    end
end)

-- Locate VampireCastle
local vampireCastle = workspace:FindFirstChild("VampireCastle")
if vampireCastle and vampireCastle.PrimaryPart then
    print("VampireCastle at Z:", vampireCastle.PrimaryPart.Position.Z)

    -- Locate MaximGun and teleport
    local closestGun
    for _, item in pairs(workspace.RuntimeItems:GetDescendants()) do
        if item:IsA("Model") and item.Name == "MaximGun" then
            local dist = (item.PrimaryPart.Position - vampireCastle.PrimaryPart.Position).Magnitude
            if dist <= 500 then
                closestGun = item
                break
            end
        end
    end

    if closestGun then
        local seat = closestGun:FindFirstChild("VehicleSeat")
        if seat then
            -- Teleport to MaximGun
            character:PivotTo(seat.CFrame)
            seat:Sit(humanoid)
            print("Seated on MaximGun.")
        else
            warn("No VehicleSeat on MaximGun.")
        end
    else
        warn("No MaximGun near VampireCastle.")
    end
else
    warn("VampireCastle missing or invalid PrimaryPart.")
end
