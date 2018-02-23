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
            local height_from_top = -10
            background.xScale = (0.40 * background.contentWidth) / background.contentWidth
            background.yScale = background.xScale + 0.1
            background.x = display.contentCenterX
            background.y = display.contentCenterY - display.contentCenterX - height_from_top
            background:scale(0.45, 0.5)
            -- create menu buttons
            local x, y = -1.75, 0
            local spacing = 100
            local height_from_bottom = 450
            local button_spacing = 1.7
            for i = 1, 2 do
                if (i == 1) then
                    button_W = 120
                    button_H = 120
                else
                    button_W = 164
                    button_H = 54
                end
                menu_buttons = widget.newButton (
                    {
                        defaultFile = 'images/buttons/button_' .. i .. '.png',
                        overFile = 'images/buttons/button_' .. i .. '_pressed.png',
                        width = button_W, height = button_H,
                        x = x * spacing + 250,
                        y = height_from_bottom + y * spacing,
                        onRelease = function()
                            if (i == 1) then
                                composer.gotoScene( "scenes.calander", {effect = "crossFade", time = 100})
                            elseif (i == 2) then
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
    if application_version.isVisible == false then application_version.isVisible = true end
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

--[[
local ip_address = {}
local port = {}
local DisplayInfo = system.openURL("https://www.gametracker.com/server_info/" .. ip_address .. ":" .. port)
]]
