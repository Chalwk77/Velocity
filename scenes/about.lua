-----------------------------------------------------------------------------------------
-- about.lua
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
    -- Help Scene background
    local background = display.newImageRect(group, "images/backgrounds/about_scene_background.png", display.contentWidth + 550, display.contentHeight + 1000)
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
    back_button:scale(0.3, 0.3)
    group:insert(back_button)
    local aboutText = [[
    Summary:

    * Create and view custom events in our in-app custom calander.
    * Create and personalize notes and share them with each other.
    * Notifications | Private Messaging | and more...

    Developed by Jericho crosby
    <jericho.crosby227@gmail.com>
    Source Code: https://github.com/Chalwk77/Velocity
    ]]
    local paragraphs = {}
    local paragraph
    local tmpString = aboutText
    -- Text Options
    local options = {
        text = "",
        width = display.contentWidth,
        fontSize = 8,
        font = native.systemFontBold,
        align = "left",
    }
    local yOffset = 10
    repeat
        local b, e = string.find(tmpString, "\r\n")
        if b then
            paragraph = string.sub(tmpString, 1, b - 1)
            tmpString = string.sub(tmpString, e + 1)
        else
            paragraph = tmpString
            tmpString = ""
        end
        options.text = paragraph
        paragraphs[#paragraphs + 1] = display.newText( options )
        paragraphs[#paragraphs].anchorX = 0
        paragraphs[#paragraphs].anchorY = 0
        paragraphs[#paragraphs].x = 10
        paragraphs[#paragraphs].y = yOffset
        paragraphs[#paragraphs]:setFillColor(color_table.RGB("white"), 1)
        paragraphs[#paragraphs].alpha = 1
        info = paragraphs[#paragraphs]
        yOffset = yOffset + paragraphs[#paragraphs].height
    until tmpString == nil or string.len( tmpString ) == 0
    group:insert(info)
    local copyright = display.newText( group, "© 2018, Velocity, Jericho Crosby <jericho.crosby227@gmail.com>", 0, 0, native.systemFontBold, 8 )
    local spacing = 100
    local xPos = screenLeft + 10
    local yPos = screenBottom - 10
    copyright.x = xPos + 120
    copyright.y = yPos
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
        if application_version ~= nil then application_version.isVisible = false end
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
