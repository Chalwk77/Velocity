-----------------------------------------------------------------------------------------
-- main.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>

-- to do:
-- remove 'version update text' when transitioning between scenes

-----------------------------------------------------------------------------------------
local composer = require('composer')
local button = require( "widget" )
local http = require "socket.http"
local ltn12 = require("ltn12")
local build_version = system.getInfo( "appVersionString" )

display.setStatusBar(display.HiddenStatusBar)
system.setIdleTimer( false )
local function backKeyPressed( event )
    if event.keyName == "escape" or event.keyName == "back" then
        local platformName = system.getInfo( "platformName" )
        if (platformName == "Android") or (platformName == "WinPhone") or platformName == "Win" then
            native.showAlert("Confirm Exit", "Are you sure you want to exit?", {"Yes", "No"},
                function(event)
                    if (event.action == 'clicked' and event.index == 1) then
                        native.requestExit()
                    end
                end
            )
            return true
        end
    end
    return false
end

local exitButton = button.newButton({
    defaultFile = 'images/buttons/exit.png',
    overFile = 'images/buttons/exit-over.png',
    onRelease = function()
        native.showAlert('Confirm Exit', 'Are you sure you want to exit?', {'Yes', 'No'},
            function(event)
                if event.action == 'clicked' and event.index == 1 then
                    native.requestExit()
                end
            end
        )
    end
})

exitButton.x = display.contentCenterX + 135
exitButton.y = display.contentCenterY - display.contentCenterX - 80
exitButton.width = 64
exitButton.height = 64
exitButton:scale(0.6, 0.6)

function CheckForUpdates()
    local latest_version_url = "https://pastebin.com/raw/DG23Z1w3"
    local app_version = {version = build_version}
    local response = {}
    local a, b, c = http.request({url = latest_version_url, sink = ltn12.sink.table(response)})
    local latest_version = response[1]
    local height_from_bottom = -100
    if latest_version ~= nil then
        if (string.find(latest_version, "%d%.%d.%d+") == 1) then
            -- application is up to date
            if app_version.version == latest_version then
                application_version = display.newText( "Version " .. latest_version, display.viewableContentWidth / 2, display.viewableContentHeight / 2, native.systemFontBold, 10 )
                application_version:setFillColor(1, 0.9, 0.5)
                application_version.x = display.contentCenterX
                application_version.y = display.contentCenterX + display.contentCenterY - height_from_bottom
                application_version.alpha = 0.50
                -- an update is available
            elseif app_version.version < latest_version then
                local function onComplete( event )
                    if ( event.action == "clicked" ) then
                        local i = event.index
                        if ( i == 1 ) then
                            -- do nothing
                        elseif ( i == 2 ) then
                            -- opens google play app listing
                            system.openURL("https://play.google.com/store/apps/details?id=com.gmail.crosby227.jericho.Velocity")
                        end
                    end
                end
                local function onTextClick( event )
                    if ( event.phase == "began" ) then
                        local alert = native.showAlert( "Download Latest Update", "Would you like to download the latest update?", { "No", "Yes" }, onComplete )
                    end
                    return true
                end
                application_version = display.newText( "Version " .. latest_version .. " is available!", display.viewableContentWidth / 2, display.viewableContentHeight / 2, native.systemFontBold, 10 )
                application_version:setFillColor(1, 0.9, 0.5)
                application_version.x = display.contentCenterX
                application_version.y = display.contentCenterX + display.contentCenterY - height_from_bottom
                application_version.alpha = 0.50
                application_version:addEventListener( "touch", onTextClick )
                -- pastebin version is lower than the system version
            elseif app_version.version > latest_version then
                -- do nothing (version string will disappear)
            end
        end
    end
end
-- init check for updates
CheckForUpdates()

-- init back key listener
Runtime:addEventListener( "key", backKeyPressed )
-- init menu scene
composer.gotoScene( "scenes.menu" )
