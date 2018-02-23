-----------------------------------------------------------------------------------------
-- main.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------

local composer = require('composer')
-- init menu scene
composer.gotoScene( "scenes.menu" )

local function backKeyPressed( event )
    if event.keyName == "back" then
        local platformName = system.getInfo( "platformName" )
        if (platformName == "Android") or (platformName == "WinPhone") then
            native.showAlert("Confirm Exit", "Are you sure you want to exit?", {"Yes", "No"},
                function(event)
                    if (event.action == 'clicked' and event.index == 1) then
                        native.requestExit()
                    end
            end)
            return true
        end
    end
    return false
end

-- init back key listener
Runtime:addEventListener( "key", backKeyPressed )
