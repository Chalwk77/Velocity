-----------------------------------------------------------------------------------------
-- main.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local button = require( "widget" )
-- hide notification bar
display.setStatusBar(display.HiddenStatusBar)
-- Keeps the screen ON while idle.
system.setIdleTimer( false )

local composer = require('composer')
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

-- init back key listener
Runtime:addEventListener( "key", backKeyPressed )
-- init menu scene
composer.gotoScene( "scenes.menu" )
