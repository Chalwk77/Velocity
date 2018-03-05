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
require('scenes.debug')

local function networkListener(event)
    if (event.isError) then
        print('Network error:', event.response)
    else
        local data = event.response
        if (string.find(data, "Current App Version: %d%.%d.%d+")) then
            local replace = "Current App Version: %d%.%d.%d+"
            local google_play_version = string.gsub(string.match(data, replace), replace, string.match(string.match(data, replace), "%d%.%d.%d+"))
            local version = {current = current_build, updated = google_play_version}
            local height_from_bottom = -100
            if version ~= nil and version.updated ~= nil then
                if (string.find(version.updated, "%d%.%d.%d+") == 1) then
                    if (version.current == version.updated) then
                        application_version = display.newText( "Version " .. version.current, display.viewableContentWidth / 2, display.viewableContentHeight / 2, native.systemFontBold, 10 )
                        application_version:setFillColor(1, 0.9, 0.5)
                        application_version.x = display.contentCenterX
                        application_version.y = display.contentCenterX + display.contentCenterY - height_from_bottom
                        application_version.alpha = 0.50
                        application_version.isVisible = false
                    elseif (version.current < version.updated) then
                        local function onTextClick( event )
                            if ( event.phase == "began" ) then
                                showDialog("Download Latest Update", "Would you like to download the latest update?", 18, true)
                            end
                            return true
                        end
                        application_version = display.newText( "Version " .. version.updated .. " is available!", display.viewableContentWidth / 2, display.viewableContentHeight / 2, native.systemFontBold, 10 )
                        application_version:setFillColor(1, 0.9, 0.5)
                        application_version.x = display.contentCenterX
                        application_version.y = display.contentCenterX + display.contentCenterY - height_from_bottom
                        application_version.alpha = 0.50
                        application_version:addEventListener( "touch", onTextClick )
                        application_version.isVisible = false
                    end
                    print("Google Play App Version: " .. google_play_version)
                end
            end
        else
            print('Current Version could not be found!')
        end
    end
    print("Google Play App Version: " .. google_play_version)
end

function CheckForUpdates()
    local data = network.request("https://play.google.com/store/apps/details?id=com.gmail.crosby227.jericho.Velocity", "POST", networkListener)
end
CheckForUpdates()

init_loading_screen = function(scene_name, delay)
    timer.performWithDelay(0, function()
        scene_id = scene_name
        duration = delay
        composer.gotoScene('modules.loading', {effect = "crossFade", time = 0})
    end)
end

--composer.gotoScene( "scenes.menu" )
composer.gotoScene( "scenes.loginScreen" )
