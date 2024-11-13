
local function safeLoadScript(url)
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)

    if success then
        local scriptContent = result
        local func, err = loadstring(scriptContent)
        if func then
            pcall(func)
        else
            
        end
    else
        
    end
end

local scriptUrl = "https://raw.githubusercontent.com/LyriaRobloxScripts/Mystery-Mall/refs/heads/main/Food%20Esp.lua"
safeLoadScript(scriptUrl)

local function handleItems()
    if getgenv().FoodItems then
        
    else
        
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    handleItems()
end)

local itemNames = {
    "Taco", "Chicken Leg", "Poison Cake", "Cake", "Sandwich", "Chocolate Milk", 
    "Medkit", "Strange Drink", "Bloxy Cola", "Hot Dog", "Cherry Pie", 
    "Chocolate Bunny", "Ice Cream", "Pizza", "Energy Bar", "Health Potion"
}

local itemsFolder = game:GetService("Workspace"):FindFirstChild("Items")
local createdESP = {}

local function removeAllESP()
    for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:IsA("BillboardGui") and gui.Name == "ItemESP" then
            gui:Destroy()
        end
    end

    for _, part in ipairs(game:GetService("Workspace"):GetChildren()) do
        if part:IsA("BasePart") and part:FindFirstChild("ItemHighlight") then
            part.ItemHighlight:Destroy()
        end
    end

    createdESP = {}
end

local function createESP(item)
    if not table.find(itemNames, item.Name) then return end
    if createdESP[item.Name] then return end
    
    local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true)
    if not part then return end

    local billboardGui = Instance.new("BillboardGui", game:GetService("CoreGui"))
    billboardGui.Name = "ItemESP"
    billboardGui.AlwaysOnTop = true
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.Adornee = part

    local textLabel = Instance.new("TextLabel", billboardGui)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = item.Name
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.SourceSansBold

    local highlight = Instance.new("Highlight")
    highlight.Name = "ItemHighlight"
    highlight.Parent = part
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineTransparency = 0.5
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    createdESP[item.Name] = true
end

local function handleItems()
    if not getgenv().FoodItems then
        removeAllESP()
    else
        if itemsFolder then
            for _, item in ipairs(itemsFolder:GetChildren()) do
                if table.find(itemNames, item.Name) then
                    createESP(item)
                end
            end

            itemsFolder.ChildAdded:Connect(function(child)
                if table.find(itemNames, child.Name) then
                    createESP(child)
                end
            end)
        end
    end
end

task.spawn(function()
    local lastFoodItemsState = getgenv().FoodItems

    while true do
        if getgenv().FoodItems ~= lastFoodItemsState then
            lastFoodItemsState = getgenv().FoodItems
            handleItems()
        end
        task.wait(0.1)
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    handleItems()
end)

handleItems()
