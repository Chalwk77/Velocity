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

local function switchScene(event)
    local scene_id = ""
    if event.target.id == 1 then
        scene_id = "scenes.about"
    elseif event.target.id == 2 then
        scene_id = "scenes.about"
    elseif event.target.id == 3 then
        scene_id = "scenes.about"
    elseif event.target.id == 4 then
        scene_id = "scenes.about"
    elseif event.target.id == 5 then
        scene_id = "scenes.about"
    end
    composer.gotoScene( scene_id, {effect = "crossFade", time = 100} )
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        local function setUpDisplay(sceneGroup)
            -- draw menu background
            local background = display.newImage(sceneGroup, "images/backgrounds/menu_background.png")
            background.x = display.contentCenterX + - 3
            background.y = display.contentCenterY
            background.width = display.contentWidth - display.screenOriginX - 15
            background.height = display.contentHeight - display.screenOriginY + 25
            background:scale(1.50, 1)
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
            local x, y = -2, 0
            local spacing = 65
            local height = 300
            for buttonID = 1, 5 do
                local buttons = widget.newButton ({
                    label = buttonID,
                    id = buttonID,
                    labelColor = {default = {color_table.RGB("black")}, over = {color_table.RGB("green")}},
                    font = native.systemFontBold,
                    fontSize = 10,
                    labelYOffset = 0,
                    defaultFile = 'images/buttons/menu_button.png',
                    overFile = 'images/buttons/menu_button_pressed.png',
                    width = 64, height = 64,
                    x = x * spacing + display.contentCenterX,
                    y = display.contentCenterX + y * spacing + height,
                    onRelease = switchScene
                })
                buttons:scale(0.8, 0.9)
                sceneGroup:insert(buttons)
                x = x + 1
                if x == 3 then
                    x = -2
                    y = y + 1
                end
            end
        end
        setUpDisplay(sceneGroup)
    elseif ( phase == "did" ) then
        -- scene end
    end
    if application_version ~= nil then if application_version.isVisible == true then application_version.isVisible = false end end
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
