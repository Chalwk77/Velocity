-----------------------------------------------------------------------------------------
-- menu.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
--
-----------------------------------------------------------------------------------------
local composer = require( 'composer' )
local scene = composer.newScene()
local widget = require( "widget" )
require('scenes.debug')

function scene:create( event )
    local sceneGroup = self.view
    local function setUpDisplay(sceneGroup)
        -- draw menu background
        local background = display.newImage(sceneGroup, "images/backgrounds/menu_background.png")
        background.xScale = (0.5 * background.contentWidth) / background.contentWidth
        background.yScale = background.xScale
        background.x = display.contentCenterX
        background.y = display.contentCenterY - display.contentCenterX
        background:scale(0.4, 0.4)
        -- create menu buttons
        local x, y = -1.75, 0
        local spacing = 100
        for buttonID = 1, 2 do
            local buttons = widget.newButton ({
                defaultFile = 'images/buttons/button_' .. buttonID .. '.png',
                overFile = 'images/buttons/button_' .. buttonID .. '_pressed.png',
                width = 164, height = 54,
                x = x * spacing + 250,
                y = 450 + y * spacing,
                onRelease = function()
                    if (buttonID == 1) then
                        -- gotoScene 1
                    elseif (buttonID == 2) then
                        -- gotoScene 2
                    end
                end
            })
            buttons:scale(0.8, 0.5)
            sceneGroup:insert(buttons)
            local button_spacing = 1.7
            x = x + button_spacing
        end
    end
    setUpDisplay(sceneGroup)
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- scene begin
    elseif ( phase == "did" ) then
        -- scene end
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
