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

-- Step 1: Teleport to the initial position
print("Teleporting to the initial location...")
humanoidRootPart.CFrame = CFrame.new(teleportPosition)
wait(delayTime)

-- Step 2: Locate VampireCastle
local vampireCastle = workspace:FindFirstChild("VampireCastle")
if vampireCastle and vampireCastle.PrimaryPart then
    print("VampireCastle found at Z:", vampireCastle.PrimaryPart.Position.Z)
else
    warn("VampireCastle missing or invalid PrimaryPart.")
end

-- Step 3: Locate MaximGun near VampireCastle
local closestGun = nil
if vampireCastle and vampireCastle.PrimaryPart then
    for _, item in pairs(workspace.RuntimeItems:GetDescendants()) do
        if item:IsA("Model") and item.Name == "MaximGun" then
            local dist = (item.PrimaryPart.Position - vampireCastle.PrimaryPart.Position).Magnitude
            if dist <= 500 then
                closestGun = item
                break
            end
        end
    end
end

-- Step 4: Teleport to MaximGun or fallback to Chair
local foundSeat = nil
if closestGun then
    local seat = closestGun:FindFirstChild("VehicleSeat")
    if seat then
        foundSeat = seat
        character:PivotTo(foundSeat.CFrame)
        seat:Sit(humanoid)
        print("Seated on MaximGun.")
        enableNoclip()
    else
        warn("MaximGun seat not found.")
    end
else
    warn("No MaximGun near VampireCastle. Searching for fallback Chair...")
    for _, item in pairs(workspace.RuntimeItems:GetDescendants()) do
        if item.Name == "Chair" then
            local seat = item:FindFirstChild("Seat")
            if seat and seat.Position.Z >= -9500 and seat.Position.Z <= -9000 then
                foundSeat = seat
                character:PivotTo(seat.CFrame)
                seat:Sit(humanoid)
                print("Fallback: Seated on Chair at Z:", seat.Position.Z)
                enableNoclip()
                break
            end
        end
    end
    if not foundSeat then
        warn("No Chair found within range.")
    end
end
