local composer = require( "composer" )
local http = require "socket.http"
local ltn12 = require("ltn12")
local build_version = system.getInfo( "appVersionString" )

require('modules.show_dialog')

-- used to show|hide objects
ui_objects_group = display.newGroup()
hideUiObjects = function( bool )
    if (bool == true) then
        ui_objects_group.isVisible = false
    else
        ui_objects_group.isVisible = true
    end
end

function CheckForUpdates()
    local latest_version_url = "https://pastebin.com/raw/DG23Z1w3"
    local app_version = {version = build_version}
    local response = {}
    local a, b, c = http.request({url = latest_version_url, sink = ltn12.sink.table(response)})
    local latest_version = response[1]
    local height_from_bottom = -100
    if latest_version ~= nil then
        if (string.find(latest_version, "%d%.%d.%d+") == 1) then
            if app_version.version == latest_version then
                local application_version = display.newText( "Version " .. latest_version, display.viewableContentWidth / 2, display.viewableContentHeight / 2, native.systemFontBold, 10 )
                application_version:setFillColor(1, 0.9, 0.5)
                application_version.x = display.contentCenterX
                application_version.y = display.contentCenterX + display.contentCenterY - height_from_bottom
                application_version.alpha = 0.50
                ui_objects_group:insert(application_version)
            elseif app_version.version < latest_version then
                local function onTextClick( event )
                    if ( event.phase == "began" ) then
                        showDialog("Download Latest Update", "Would you like to download the latest update?", 18, true)
                    end
                    return true
                end
                local application_version = display.newText( "Version " .. latest_version .. " is available!", display.viewableContentWidth / 2, display.viewableContentHeight / 2, native.systemFontBold, 10 )
                application_version:setFillColor(1, 0.9, 0.5)
                application_version.x = display.contentCenterX
                application_version.y = display.contentCenterX + display.contentCenterY - height_from_bottom
                application_version.alpha = 0.50
                application_version:addEventListener( "touch", onTextClick )
                ui_objects_group:insert(application_version)
            elseif app_version.version > latest_version then
                -- do nothing
            end
        end
    end
end
-- init check for updates
CheckForUpdates()

composer.gotoScene( "scenes.menu" )
