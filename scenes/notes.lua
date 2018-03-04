-----------------------------------------------------------------------------------------
-- notes.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")

local function setUpDisplay(group)
    -- create menu background
    local screenLeft = display.screenOriginX
    local screenWidth = display.viewableContentWidth - screenLeft * 2
    local screenTop = display.screenOriginY
    local screenHeight = display.viewableContentHeight - screenTop * 2
    background = display.newImage( group, "images/backgrounds/background1.png" )
    background.x = display.contentWidth * 0.5
    background.y = display.contentHeight * 0.5
    local scale = math.max( screenWidth / background.width, screenHeight / background.height )
    background:scale( scale, scale )
    group:insert(background)
    local x, y = -2, 0
    local spacing = 65
    local height = 300
    local back_button = widget.newButton (
        {
            defaultFile = 'images/buttons/back_button.png',
            overFile = 'images/buttons/back_button_pressed.png',
            x = x * spacing + display.contentCenterX,
            y = display.contentCenterX + y * spacing + height,
            onRelease = function()
                showUI(false)
                composer.gotoScene( "scenes.menu", {effect = "crossFade", time = 100})
            end
        }
    )
    back_button:scale(0.080, 0.080)
    group:insert(back_button)
end

function scene:create( event )
    local sceneGroup = self.view
    setUpDisplay(sceneGroup)
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then

    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- scene begin
    elseif ( phase == "did" ) then
        -- scene end
    end
end
---------------------------------------------------------------
-- scene listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
