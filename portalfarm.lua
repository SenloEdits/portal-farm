-- Function to safely invoke the server method
local function safeInvoke(callback)
    local success, err = pcall(callback)
    if not success then
        warn("Error invoking server method:", err)
    end
end

-- Function to place a unit
local function placeUnit(args)
    safeInvoke(function()
        game:GetService("ReplicatedStorage").endpoints.client_to_server.spawn_unit:InvokeServer(unpack(args))
    end)
end

-- Placement Arguments for Shadows
local shadowArgs = {
    {
        [1] = "379e12c208594f1",
        [2] = {
            ["Direction"] = Vector3.new(-0.19060203433036804, -0.7860865592956543, 0.5879955291748047),
            ["Origin"] = Vector3.new(-257.3133850097656, 24.16525650024414, -25.763639450073242)
        },
        [3] = 0
    },
    {
        [1] = "8e314e05044145f",
        [2] = {
            ["Direction"] = Vector3.new(-0.3704546093940735, -0.9139495491981506, 0.16570983827114105),
            ["Origin"] = Vector3.new(372.41595458984375, 94.63214874267578, -491.36285400390625)
        },
        [3] = 0
    },
    {
        [1] = "379e12c208594f1",
        [2] = {
            ["Direction"] = Vector3.new(-0.2330065369606018, -0.7252691388130188, 0.6478369235992432),
            ["Origin"] = Vector3.new(-252.78721618652344, 24.202848434448242, -27.870912551879883)
        },
        [3] = 0
    }
}

-- Upgrade Arguments for Shadows
local shadowUpgradeArgs = {
    { [1] = "379e12c208594f12" },
    { [1] = "379e12c208594f11" },
    { [1] = "379e12c208594f13" }
}

-- Function to place all shadows sequentially with a delay
local function placeShadows()
    for _, args in ipairs(shadowArgs) do
        placeUnit(args)
        task.wait(5) -- Wait 5 seconds between placements
    end
end

-- Function to upgrade shadows sequentially with a delay
local function upgradeShadows()
    for _, args in ipairs(shadowUpgradeArgs) do
        safeInvoke(function()
            game:GetService("ReplicatedStorage").endpoints.client_to_server.upgrade_unit_ingame:InvokeServer(unpack(args))
        end)
        task.wait(2) -- Wait 2 seconds between upgrades
    end
end

-- Vote Start Logic (Repeats every 3 seconds)
local function voteStartLoop()
    safeInvoke(function()
        game:GetService("ReplicatedStorage").endpoints.client_to_server.vote_start:InvokeServer()
    end)
end

-- Additional Task Logic (Repeats every 5 seconds)
local function additionalTask()
    safeInvoke(function()
        -- Custom logic to be executed
        local args = {
            [1] = "custom_task_data" -- Replace with the actual arguments for your logic
        }
        game:GetService("ReplicatedStorage").endpoints.client_to_server.custom_function:InvokeServer(unpack(args))
    end)
end

-- Main Execution
spawn(function()
    -- Loop the placement process 3 times
    for i = 1, 3 do
        placeShadows()
    end

    -- Start the upgrade process indefinitely
    while true do
        upgradeShadows()
        task.wait(5) -- Repeat the upgrade process indefinitely with a 5-second interval
    end
end)

-- Repeating Vote Start Execution Every 3 Seconds
spawn(function()
    while true do
        voteStartLoop()
        task.wait(3) -- Wait 3 seconds before repeating
    end
end)

-- Repeating Additional Task Execution Every 5 Seconds
spawn(function()
    while true do
        additionalTask()
        task.wait(5) -- Wait 5 seconds before repeating
    end
end)

