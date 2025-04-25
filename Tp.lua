local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local teleportPosition = Vector3.new(57, 3, -9000)
local delayTime = 0.1

local function enableNoclip()
    game:GetService("RunService").Stepped:Connect(function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    print("Noclip mode enabled.")
end

while true do
    humanoidRootPart.CFrame = CFrame.new(teleportPosition)
    wait(delayTime)

    -- Locate VampireCastle
    local vampireCastle = workspace:FindFirstChild("VampireCastle")
    if vampireCastle and vampireCastle.PrimaryPart then
        print("VampireCastle found at Z:", vampireCastle.PrimaryPart.Position.Z)

        -- Locate MaximGun near VampireCastle
        local closestGun = nil
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
                character:PivotTo(seat.CFrame)
                seat:Sit(humanoid)
                print("Seated on MaximGun.")
                enableNoclip()
                break -- Exit loop after sitting
            else
                warn("MaximGun seat not found.")
            end
        else
            warn("No MaximGun near VampireCastle.")
        end
    else
        warn("VampireCastle missing or invalid PrimaryPart.")
    end

    -- Fallback: Locate Chair
    local foundChair = nil
    for _, item in pairs(workspace.RuntimeItems:GetDescendants()) do
        if item.Name == "Chair" then
            local seat = item:FindFirstChild("Seat")
            if seat and seat.Position.Z >= -9500 and seat.Position.Z <= -9000 then
                foundChair = seat
                character:PivotTo(seat.CFrame)
                seat:Sit(humanoid)
                print("Fallback: Seated on Chair at Z:", seat.Position.Z)
                enableNoclip()
                break -- Exit loop after sitting
            end
        end
    end

    if foundChair then
        break -- Exit loop after finding the Chair
    else
        warn("No Chair found within range. Continuing teleport loop...")
    end
end
