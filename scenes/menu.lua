-----------------------------------------------------------------------------------------
-- menu.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( 'composer' )
local colors = require('modules.rgb_color_library')
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
            background.x = display.contentCenterX
            background.y = display.contentCenterY
            background.width = display.contentWidth - display.screenOriginX - 25
            background.height = display.contentHeight - display.screenOriginY + 25
            background:scale(1.5, 1)
            sceneGroup:insert(background)

            -- create top|bottom frames
            local shade = 1
            local topY = display.screenOriginY
            local bottomY = display.contentHeight - display.screenOriginY

            local leftX = display.screenOriginX
            local rightX = display.contentWidth - display.screenOriginX

            local screenW = rightX - leftX
            local screenH = bottomY - topY

            local bottom_frame = display.newLine(leftX + screenW, bottomY, rightX - screenW, bottomY)
            bottom_frame.strokeWidth = screenH / 27
            bottom_frame.alpha = shade
            bottom_frame:setStrokeColor(color_table.RGB("blue"))
            sceneGroup:insert(bottom_frame)

            local top_frame = display.newLine(leftX + screenW, topY, rightX - screenW, topY)
            top_frame.strokeWidth = screenH / 27
            top_frame.alpha = shade
            top_frame:setStrokeColor(color_table.RGB("blue"))
            sceneGroup:insert(top_frame)

            -- create menu buttons
            local x, y = -1.75, 0
            local spacing = 100
            local height_from_bottom = 450
            local button_spacing = 1.07
            for i = 1, 3 do
                if (i == 1) then
                    button_W = 120
                    button_H = 120
                elseif (i == 2) then
                    button_W = 164
                    button_H = 54
                elseif (i == 3) then
                    button_W = 120
                    button_H = 120
                end
                menu_buttons = widget.newButton (
                    {
                        defaultFile = 'images/buttons/button_' .. i .. '.png',
                        overFile = 'images/buttons/button_' .. i .. '_pressed.png',
                        width = button_W, height = button_H,
                        x = x * spacing + 230,
                        y = height_from_bottom + y * spacing,
                        onRelease = function()
                            if (i == 1) then
                                composer.gotoScene( "scenes.calander", {effect = "crossFade", time = 100})
                            elseif (i == 2) then
                                composer.gotoScene( "scenes.about", {effect = "crossFade", time = 100})
                            elseif (i == 3) then
                                composer.gotoScene( "scenes.notes", {effect = "crossFade", time = 100})
                            end
                        end
                    }
                )
                menu_buttons:scale(0.7, 0.5)
                sceneGroup:insert(menu_buttons)
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
