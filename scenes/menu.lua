-----------------------------------------------------------------------------------------
-- menu.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( 'composer' )
local scene = composer.newScene()
local widget = require( "widget" )
require('scenes.debug')

function scene:create( event )
    -- stuff that only needs to be created ONCE goes here.
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        local function setUpDisplay(sceneGroup)
            -- draw menu background
            local background = display.newImage(sceneGroup, "images/backgrounds/menu_background.png")
            local height_from_top = -50
            background.xScale = (0.40 * background.contentWidth) / background.contentWidth
            background.yScale = background.xScale + 0.1
            background.x = display.contentCenterX
            background.y = display.contentCenterY - display.contentCenterX - height_from_top
            background:scale(0.50, 0.6)
            -- create menu buttons
            local x, y = -1.75, 0
            local spacing = 100
            local button_W = 164
            local button_H = 54
            local height_from_bottom = 450
            local button_spacing = 1.7
            for buttonID = 1, 2 do
                menu_buttons = widget.newButton (
                    {
                        defaultFile = 'images/buttons/button_' .. buttonID .. '.png',
                        overFile = 'images/buttons/button_' .. buttonID .. '_pressed.png',
                        width = button_W, height = button_H,
                        x = x * spacing + 250,
                        y = height_from_bottom + y * spacing,
                        onRelease = function()
                            if (buttonID == 1) then
                                -- to do:
                                -- input field requesting an ip address and port
                                local ip_address = {}
                                local port = {}
                                local DisplayInfo = system.openURL("https://www.gametracker.com/server_info/" .. ip_address .. ":" .. port)
                            elseif (buttonID == 2) then
                                composer.gotoScene( "scenes.about", {effect = "crossFade", time = 100})
                            end
                        end
                    }
                )
                menu_buttons:scale(0.8, 0.5)
                sceneGroup:insert(menu_buttons)
                sceneGroup:insert(background)
                x = x + button_spacing
            end
        end
        setUpDisplay(sceneGroup)
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
