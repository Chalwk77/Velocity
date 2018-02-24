-----------------------------------------------------------------------------------------
-- jobs.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local colors = require('modules.rgb_color_library')

local screenLeft = display.screenOriginX
local screenWidth = display.viewableContentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.viewableContentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight

local function switchScene(event, data)
    local sceneID = event.target.id
    local options = {effect = "crossFade", time = 100}
    composer.gotoScene( sceneID, options )
end

local function setUpDisplay(group)
    local background = display.newImageRect(group, "images/backgrounds/background1.png", display.contentWidth + 550, display.contentHeight + 1000)
    background.alpha = 1
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
                composer.gotoScene( "scenes.menu", {effect = "crossFade", time = 100})
            end
        }
    )
    back_button:scale(0.080, 0.080)
    group:insert(back_button)
    local copyright = display.newText( group, "... in development ...", 0, 0, native.systemFontBold, 8 )
    local spacing = 100
    local xPos = screenLeft + 10
    local yPos = screenBottom - 10
    copyright.x = display.contentCenterX
    copyright.y = display.contentCenterY
    copyright:setFillColor( color_table.RGB("white"), 1)
    copyright.alpha = 1
end

function scene:create( event )
    local sceneGroup = self.view
    setUpDisplay(sceneGroup)
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        if application_version ~= nil then
            application_version.isVisible = false
        end
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
