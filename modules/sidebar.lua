-----------------------------------------------------------------------------------------
-- sidebar.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require('composer')
local widget = require("widget")
local sidebar = {}
local group = display.newGroup()
local button_group
local temp_group
local buttons

local xScreen = display.contentCenterX - display.actualContentWidth / 2
local wScreen = display.actualContentWidth
local yScreen = display.contentCenterY - display.actualContentHeight / 2
local hScreen = display.actualContentHeight

local topY = display.screenOriginY
local bottomY = display.contentHeight - display.screenOriginY
local leftX = display.screenOriginX
local rightX = display.contentWidth - display.screenOriginX
local screenW = (display.contentWidth - display.screenOriginX) - (display.screenOriginX)

-------------- [CREATE SIDEBAR] --------------
sidebar_buttons = { }
sidebar_buttons[1] = {"images/messages.png", 34, 34, "Messages", "scenes.messages", 13}
sidebar_buttons[2] = {"images/settings.png", 34, 34, "Settings", "scenes.settings", 13}
sidebar_buttons[3] = {"images/notes.png", 34, 34, "Notes", "scenes.notes", 13}
sidebar_buttons[4] = {"images/jobs.png", 34, 34, "Jobs", "scenes.jobs", 13}
sidebar_buttons[5] = {"images/help.png", 34, 34, "Help", "scenes.help", 13}
sidebar_buttons[6] = {"images/buttons/logout.png", 34, 34, "Logout", "scenes.loginScreen", 15}

function sidebar:new(params)
    button_group = display.newGroup()
    local background
    local logo
    local count = 0
    local bg_options = {
        type = "gradient",
        color1 = { 100 / 50, 20 / 255, 10 / 255, 0.1 },
        color2 = { 100 / 50, 245 / 100, 135 / 255, 0.5},
        border_color = {1, 0.1, 0.1, 0.3},
        border_effect = "composite.average",
        direction = "down",
        borderSize = 7
    }
    background = display.newRect(group, xScreen, wScreen, yScreen, hScreen)
    background.fill = bg_options
    -- bg position on screen
    background.x = display.contentCenterX - 88
    background.y = display.contentCenterY
    -- bg width and height
    background.width = 160
    background.height = hScreen + 5
    background.stroke = bg_options.border_color
    background.strokeWidth = bg_options.borderSize
    background.fill.effect = "filter.colorPolynomial"
    background.fill.effect.coefficients = 
    {
        0, 0, 1, 0, --red
        0, 0, 1, 0, --green
        0, 1, 0.5, 0, --blue
        0.5, 1, 0, 1 --alpha
    }
    logo = display.newImage(group, "images/sidebar_logo.png" )
    logo.x = background.x
    logo.y = background.y - 220
    logo:scale(0.2, 0.2)
    local function buttonCallback(event)
        local sceneID = event.target.id
        if sceneID == "scenes.loginScreen" then
            showDialog("CONFIRM EXIT", "Are you sure you want to exit?", 22)
        else
            sidebar:hide()
            hideUI(true)
            composer.gotoScene(sceneID, {effect = "crossFade", time = 200})
        end
    end
    for k, v in pairs(sidebar_buttons) do
        count = count + 1
        local spacing = 100
        button_id = sidebar_buttons[k][5]
        local button_image = display.newImage(group, sidebar_buttons[k][1])
        button_image.width = sidebar_buttons[k][2]
        button_image.height = sidebar_buttons[k][3]
        buttons = widget.newButton({
            id = button_id,
            left = 0,
            top = 0,
            label = sidebar_buttons[k][4],
            font = native.systemFontBold,
            labelColor = {default = {0.5, 0.1, 0.5}, over = {255, 255, 255}},
        onRelease = buttonCallback})
        buttons:setFillColor( 0, 0, 0, 0)
        buttons._view._hasAlphaFade = false
        buttons._view._label.size = sidebar_buttons[k][6]
        buttons.x = background.x + 110
        button_group.x = background.x - 160
        buttons.y = button_group.height + buttons.height + spacing
        if (button_id == "scenes.loginScreen") then
            buttons.x = buttons.x
            buttons.y = buttons.y + 25
            button_image:scale(1.3, 1.3)
        end
        button_image.x = buttons.x - 155
        button_image.y = button_image.y + buttons.y
        if count ~= #sidebar_buttons then draw_seperator(buttons.x, buttons.y) end
        button_group:insert(buttons)
        temp_group = button_group.x
        button_image.id = button_id
        button_image:addEventListener("touch", image_touch_listener)
    end
    group.y = 0
    group.x = 0
    local username_label = display.newText(group, "username", 0, 0, native.systemFont, 13)
    username_label:setTextColor(180, 180, 180)
    username_label.x = logo.x
    username_label.y = logo.y + 40
    local height_from_bottom = -15
    draw_seperator(username_label.x + 110, username_label.y + height_from_bottom, 255, 0, 255)
    sidebar:hide()
    -- set initial visibility to 'hidden'
    group.isVisible = false
    button_group.isVisible = false
    return group
end


function image_touch_listener(event)
    if (event.phase == "ended") then
        local sceneID = event.target.id
        if sceneID == "scenes.loginScreen" then
            showDialog("CONFIRM EXIT", "Are you sure you want to exit?", 22)
        else
            sidebar:hide()
            hideUI(true)
            composer.gotoScene(sceneID, {effect = "crossFade", time = 200})
        end
    end
end

function sidebar:show()
    sidebar_open = true
    group.isVisible = true
    button_group.isVisible = true
    transition.to(group, {time = 200, alpha = 1, x = 0, y = group.y})
    transition.to(button_group, {time = 200, alpha = 1, y = group.y, x = temp_group})
    timer.performWithDelay(0, background_listener)
end

function background_listener()
    bgListener = function(bool)
        if sidebar_open == true then
            sidebar:hide()
            showUI(false)
            menu_background:removeEventListener("tap", bgListener)
        else
            menu_background:removeEventListener("tap", bgListener)
        end
    end
    menu_background:addEventListener( "tap", bgListener)
end

function sidebar:hide()
    sidebar_open = false
    transition.to(group, {time = 200, alpha = 0, x = - group.width, y = group.y})
    transition.to(button_group, {time = 200, alpha = 0, x = - group.width})
end

function draw_seperator(x, y, r, g, b)
    local seperator = display.newLine(group, leftX + screenW / 3.3, bottomY, rightX - screenW / 3.3, bottomY)
    seperator.strokeWidth = 1
    if r ~= nil and g ~= nil and b ~= nil then
        seperator:setStrokeColor(r, g, b)
    else
        seperator:setStrokeColor(255, 255, 255)
    end
    seperator.x = x - 170
    seperator.y = y + 25
end

return sidebar
