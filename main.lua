-----------------------------------------------------------------------------------------
-- main.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local http = require "socket.http"
local ltn12 = require("ltn12")
local current_build = system.getInfo("appVersionString")
require('modules.utility')
require('modules.show_dialog')
require('modules.rgb_color_library')
require('modules.debug')

local function networkListener(event)
    if (event.isError) then
        print('Network error:', event.response)
    else
        local data = event.response
        if (string.find(data, "Current App Version: %d%.%d.%d+")) then
            local replace = "Current App Version: %d%.%d.%d+"
            local google_play_version = string.gsub(string.match(data, replace), replace, string.match(string.match(data, replace), "%d%.%d.%d+"))
            local version = {current = current_build, latest_update = google_play_version}
            if version ~= nil and version.latest_update ~= nil then
                if (string.find(version.latest_update, "%d%.%d.%d+") == 1) then
                    if (version.current == version.latest_update) then
                        print_version("Version " .. version.current, 0, 0)
                    elseif (version.current ~= "" and version.current < version.latest_update) then
                        local function onTextClick( event )
                            if (event.phase == "began") then
                                showDialog("Download Latest Update", "Would you like to download the latest update?", 18, true)
                            end
                            return true
                        end
                        print_version("Version " .. version.latest_update .. " is available!", 0, 0)
                        application_version:addEventListener( "touch", onTextClick )
                    elseif (version.current == "" and system.getInfo("environment") == "simulator") then
                        print_version("Current version cannot be displayed in the simulator.", 0, 0, 8)
                        print_version("Current Version on Google Play: " .. version.latest_update, 0, 0 + 13, 8)
                    end
                end
            end
        else
            print('VELOCITY | Current Version could not be retrieved!')
        end
    end
end

function CheckForUpdates()
    local output = network.request("https://play.google.com/store/apps/details?id=com.gmail.crosby227.jericho.Velocity", "GET", networkListener)
end

function connectedToInternet()
    local bool = nil
    local check = require("socket").tcp()
    check:settimeout(10000)
    local result = check:connect("www.google.com", 80)
    if not (result == nil) then bool = true else bool = false end
    check:close()
    check = nil
    return bool
end

if (connectedToInternet() == true) then
    print("VELOCITY | Internet Connection Established")
    CheckForUpdates()
else
    print_version("VELOCITY | No Internet Connection", 0, 0)
end

-- =========== GLOBAL FUNCTIONS USED THROUGHOUT APP =========== --
init_loading_screen = function(scene_name, delay)
    timer.performWithDelay(0, function()
        scene_id = scene_name
        duration = delay
        composer.gotoScene('modules.loading', {effect = "crossFade", time = 0})
    end)
end


print_version = function(text, x_offset, y_offset, fontsize)
    if text then
        if y_offset ~= nil then y_offset = y_offset else y_offset = 0 end
        if x_offset ~= nil then x_offset = x_offset else x_offset = 0 end
        if fontsize ~= nil then fontsize = fontsize else fontsize = 10 end
        local height_from_bottom = -100
        local xPos = display.contentCenterX
        local yPos = display.contentCenterX + display.contentCenterY - height_from_bottom
        application_version = display.newText(text, display.viewableContentWidth / 2, display.viewableContentHeight / 2, native.systemFontBold, fontsize )
        application_version:setFillColor(1, 0.9, 0.5)
        application_version.x = xPos + x_offset
        application_version.y = yPos + y_offset - 35
        application_version.alpha = 0.50
    end
end

--composer.gotoScene( "scenes.menu" )
composer.gotoScene("scenes.loginScreen")
