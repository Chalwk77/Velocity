-----------------------------------------------------------------------------------------
-- debug.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local show_fps = false

showFPS = function()

    local prevTime = 0
    local curTime = 0
    local dt = 0
    local fps = 50
    local mem = 0

    local xPos = display.contentCenterX
    local yPos = display.contentCenterX + display.contentCenterY - 90

    local underlay = display.newRect(0, 0, 300, 20, 12)
    underlay.x = xPos
    underlay.y = yPos
    underlay:setFillColor(0, 0, 0, 128)

    local displayInfo = display.newText("FPS: " .. fps .. " - Memory: ".. mem .. "mb", 0, 0, native.systemFontBold, 15 )
    displayInfo.x = xPos
    displayInfo.y = yPos
    displayInfo:setFillColor(255, 0, 0, 1)
    displayInfo.alpha = 1

    local function updateText()
        curTime = system.getTimer()
        dt = curTime - prevTime
        prevTime = curTime
        fps = math.floor(1000 / dt)
        mem = system.getInfo("textureMemoryUsed") / 1000000
        if fps > 60 then fps = 60 end
        displayInfo.text = "FPS: " .. fps .. " - Memory: ".. string.sub(mem, 1, string.len(mem) - 4) .. "mb"
        underlay:toFront()
        displayInfo:toFront()
    end

    Runtime:addEventListener("enterFrame", updateText)
end


debug = function(debug_text, height)
    if debug_text ~= nil then
        if height ~= nil then height = height else height = 80 end
        debug_message = display.newText(tostring(debug_text), 0, 0, native.systemFontBold, 15 )
        debug_message.x = display.contentCenterX
        debug_message.y = display.contentCenterY - height
        debug_message:setFillColor(255, 0, 0, 1)
        debug_message.alpha = 1
        print("Debug: " .. tostring(debug_text))
    end
end

if (show_fps == true) then showFPS() end
