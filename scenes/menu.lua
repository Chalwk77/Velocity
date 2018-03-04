-----------------------------------------------------------------------------------------
-- menu.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require("widget")
local sidebar = require("modules.sidebar")
local scene = composer.newScene()
local logo
local background
local onMouseEvent
local line_logo_group
local button_group

local xScreen = display.contentCenterX - display.actualContentWidth / 2
local wScreen = display.actualContentWidth
local yScreen = display.contentCenterY - display.actualContentHeight / 2
local hScreen = display.actualContentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

function scene:create( event )
    button_group = display.newGroup()
    line_logo_group = display.newGroup()
    scene.menu = 0
    local group = display.newGroup()
    self.view:insert(group)

    -------------- [MENU BACKGROUND] --------------
    menu_background = display.newImage(group, "images/backgrounds/background1.png")
    menu_background.x = display.contentWidth * 0.5
    menu_background.y = display.contentHeight * 0.5
    local scale = math.max( wScreen / menu_background.width, hScreen / menu_background.height )
    menu_background:scale( scale, scale )
    group:insert(menu_background)

    -------------- [MENU LOGO] --------------
    logo = display.newImage("images/logo.png")
    logo.x = display.contentCenterX + - 3
    logo.y = display.contentCenterY - 200
    logo:scale(0.40, 0.40)
    group:insert(logo)
    line_logo_group:insert(logo)

    local bottomY = display.contentHeight - display.screenOriginY
    local leftX = display.screenOriginX
    local rightX = display.contentWidth - display.screenOriginX
    local screenW = rightX - leftX

    -------------- [LOGO LINE] --------------
    logo_line = display.newLine(leftX + screenW + 35, bottomY, rightX - screenW + 35, bottomY)
    logo_line.x = screenW
    logo_line.y = logo.y + 55
    logo_line.strokeWidth = 1
    logo_line:setStrokeColor(0.3, 0.1, 0.2, 1)
    logo_line.alpha = 1
    line_logo_group:insert(logo_line)
    group:insert(line_logo_group)
    sidebar:new()
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function buttonCallback(event)
        local sceneID = event.target.id
        local options = {effect = "crossFade", time = 200, params = {title = event.target.id}}
        if sceneID == "exit" then
            showDialog("CONFIRM EXIT", "Are you sure you want to exit?", 22)
        elseif sceneID == "menu" then
            if (sidebar_open == true) then
                sidebar:hide()
                showUI(false)
            else
                sidebar:show()
                hideUI(false)
            end
        else
            hideUI(true)
            composer.gotoScene( sceneID, options )
        end
    end
    buttons = {}
    local spacing = 50
    local b_width = 135
    local b_height = 34
    local b_fontsize = 45
    buttons[1] = {"MENU", "menu", centerX, centerX + centerY - 175, b_width, b_height, b_fontsize}
    buttons[2] = {"JOBS", "scenes.jobs", centerX, centerX + centerY - 175 + (spacing), b_width, b_height, b_fontsize}
    buttons[3] = {"CALENDAR", "scenes.calendar", centerX, centerX + centerY - 175 + (spacing * 2), b_width, b_height, b_fontsize}
    buttons[4] = {"EXIT", "exit", centerX, centerX + centerY - 175 + (spacing * 3), b_width, b_height, b_fontsize}
    for k, v in pairs(buttons) do
        menu_button = widget.newButton{
            label = buttons[k][1],
            id = buttons[k][2],
            emboss = false,
            shape = "roundedRect",
            width = 250,
            height = 50,
            cornerRadius = 20,
            labelYOffset = 0,
            fillColor = {default = {color_table.RGB("darkpurple")}, over = {color_table.RGB("violet")}},
            strokeColor = {default = {color_table.RGB("white")}, over = {color_table.RGB("purple")}},
            strokeWidth = 7,
            labelColor = {default = {color_table.RGB("indigo")}, over = {color_table.RGB("white")}},
        onRelease = buttonCallback}
        menu_button.x = buttons[k][3]
        menu_button.y = buttons[k][4]
        menu_button.width = buttons[k][5]
        menu_button.height = buttons[k][6]
        menu_button._view._label.size = buttons[k][7]
        button_group:insert(menu_button)
    end
end

hideUI = function(bool)
    local transparency = 0.050
    if bool == false then
        transition.to(line_logo_group, {time = 300, alpha = transparency})
        transition.to(button_group, {time = 300, alpha = transparency})
    elseif bool == true then
        transition.to(line_logo_group, {time = 300, alpha = 0})
        transition.to(button_group, {time = 300, alpha = 0})
    elseif bool == nil then
        transition.to(line_logo_group, {time = 300, alpha = transparency})
        transition.to(button_group, {time = 300, alpha = transparency})
    end
end

showUI = function(bool)
    local transparency = 1
    if bool == false then
        transition.to(line_logo_group, {time = 300, alpha = transparency})
        transition.to(button_group, {time = 300, alpha = transparency})
    elseif bool == true then
        transition.to(line_logo_group, {time = 300, alpha = 0})
        transition.to(button_group, {time = 300, alpha = 0})
    elseif bool == nil then
        transition.to(line_logo_group, {time = 300, alpha = transparency})
        transition.to(button_group, {time = 300, alpha = transparency})
    end
    menu_background:removeEventListener("tap", bgListener)
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
