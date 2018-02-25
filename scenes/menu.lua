-----------------------------------------------------------------------------------------
-- menu.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local uiLib = require "plugin.braintonik-dialog"
local scene = composer.newScene()
local logo
local background
local onMouseEvent
local onTouch
local sidebar_group
local logo_line
require('scenes.debug')

function scene:create( event )
    scene.menu = 0
    local group = display.newGroup()
    self.view:insert( group )
    local xScreen = display.contentCenterX - display.actualContentWidth / 2
    local wScreen = display.actualContentWidth
    local yScreen = display.contentCenterY - display.actualContentHeight / 2
    local hScreen = display.actualContentHeight

    background = display.newImage( group, "images/backgrounds/background1.png" )
    background.x = display.contentWidth * 0.5
    background.y = display.contentHeight * 0.5
    local scale = math.max( wScreen / background.width, hScreen / background.height )
    background:scale( scale, scale )
    group:insert(background)

    logo = display.newImage("images/logo.png")
    logo.x = display.contentCenterX + - 3
    logo.y = display.contentCenterY - 200
    logo:scale(0.40, 0.40)
    group:insert(logo)
    ui_objects_group:insert(logo)

    menu_buttons = { }
    menu_buttons[1] = { "MENU"}
    menu_buttons[2] = { "JOBS", "scenes.jobs"}
    menu_buttons[3] = { "CALANDER", "scenes.calendar"}
    menu_buttons[4] = { "EXIT"}

    local function createUIButton( parentGroup, name, x, y, w, h )
        local function buttonCallback(button_name)
            if button_name == "MENU" then
                scene:showSlidingMenu()
            elseif button_name == "EXIT" then
                showDialog("CONFIRM EXIT", "Are you sure you want to exit?")
            else
                hideUiObjects(true)
                for k, v in pairs(menu_buttons) do
                    if string.find(menu_buttons[k][1], button_name) then
                        composer.gotoScene(menu_buttons[k][2])
                    end
                end
            end
        end
        local options = {
            id = name,
            group = parentGroup,
            callBack = buttonCallback,
            x = x,
            y = y + 150,
            w = w,
            h = h,
            align = "center",
            alignLeftRightMargin = 20,
            spaceBetweenIconAndText = 10,
            shapeBkGradientColor = {
                type = "gradient",
                color1 = { 0.3, 0.8, 0.9 },
                color2 = { 0.9, 0.9, 0.9 },
                direction = "up"
            },
            shape = "roundedRect",
            shapeCornerRadius = 22,
            shapeBorder = 5,
            shapeBorderColor = { 0.4, 0.4, 0.4 },
            shapeBkSelColor = { 38 / 255, 160 / 255, 218 / 255, 1 },
            shapeSelBorderColor = { 1, 1, 1, 1 },
            shadowTable = {
                width = 6,
                gradientColor = {
                    type = "gradient",
                    color1 = { 0.7, 0.7, 0.7 },
                    color2 = {0.9, 0.9, 0.9 },
                    direction = "down"
                },
            },
            textTable = {
                text = name,
                fontSize = 14,
                fontType = native.systemFontBold,
                color = { 0.3, 0.3, 0.3 },
                selectedColor = { 0.9, 0.9, 1, 1 },
            },
        }
        screen_contents = parentGroup
        local buttons = uiLib.newUIButton( options )
    end

    local height_from_bottom = 120
    local wButton = 120
    local xButton = xScreen + wScreen / 2 - wButton / 2
    local yButton = yScreen + height_from_bottom
    local hButton = 40
    local spacing = 10

    for k, v in pairs(menu_buttons) do
        createUIButton(group, v[1], xButton, yButton, wButton, hButton)
        yButton = yButton + hButton + spacing
    end

    function scene:showSlidingMenu()
        sidebar_group = display.newGroup()
        self.view:insert( sidebar_group )
        local function callBack( itemId )
            if itemId ~= nil then
                hideUiObjects(true)
                composer.gotoScene( itemId, {effect = "crossFade", time = 100} )
            end
        end
        local slidingMenuTable = {
            {
                appearsFrom = "left",
                wDialog = 150,
                parent = sidebar_group,
                bkGradient = {
                    type = "gradient",
                    color1 = { 100 / 50, 20 / 255, 10 / 255, 0.1 },
                    color2 = { 100 / 50, 245 / 100, 135 / 255, 0.5},
                    direction = "down",
                },
                buttonHandler = callBack,
                borderSize = 7,

                itemListTextMarginPadding = 44,
                itemListIconMarginPadding = 10,
                itemListJustify = "left",
                itemListcenterSpacing = 5,
                itemListFont = native.systemFont,
                itemListFontSize = 12,

                itemList = {
                    { iconFilename = "images/sidebar_logo.png", iconWidth = 96, iconHeight = 96, name = "USERNAME | ERROR", height = 142, justify = "center" },
                    { separator = true, height = 1, color = {0.7, 0.7, 0.7, 1}, width = 120, justify = "center" },
                    { iconFilename = "images/messages.png", iconWidth = 24, iconHeight = 24, name = "Messages", height = 50, id = "scenes.messages"},
                    { separator = true, height = 1, color = {0.7, 0.7, 0.7, 1}, width = 120, justify = "center" },
                    { iconFilename = "images/settings.png", iconWidth = 24, iconHeight = 24, name = "Settings", height = 50, id = "scenes.settings"},
                    { separator = true, height = 1, color = {0.7, 0.7, 0.7, 1}, width = 120, justify = "center" },
                    { iconFilename = "images/notes.png", iconWidth = 24, iconHeight = 24, name = "Notes", height = 50, id = "scenes.notes"},
                    { separator = true, height = 1, color = {0.7, 0.7, 0.7, 1}, width = 120, justify = "center" },
                    { iconFilename = "images/jobs.png", iconWidth = 24, iconHeight = 24, name = "Jobs", height = 50, id = "scenes.jobs"},
                    { separator = true, height = 1, color = {0.7, 0.7, 0.7, 1}, width = 120, justify = "center" },
                    { iconFilename = "images/help.png", iconWidth = 24, iconHeight = 24, name = "Help", height = 50, id = "scenes.help"},

                },
                xScreen = xScreen,
                yScreen = yScreen,
                wScreen = wScreen,
                hScreen = hScreen,
            },
        }
        local sidebar = uiLib.displaySlidingDialog(slidingMenuTable[1])
        local fade = transition.to(logo, { time = 300, alpha = 0.1})

        local logo_line_fade = transition.to(logo_line, { time = 300, alpha = 0})

        local platformName = system.getInfo("platformName")
        if platformName == "Win" then
            Runtime:addEventListener( "mouse", onMouseEvent )
        elseif (platformName == "Android") or (platformName == "WinPhone") then
            Runtime:addEventListener( "touch", onTouch )
        end
    end
end

onMouseEvent = function(event)
    if event.isPrimaryButtonDown then
        local fade = transition.to(logo, { time = 300, alpha = 1})
        local fade2 = transition.to(sidebar_group, { time = 350, alpha = 0})
        Runtime:removeEventListener( "mouse", onMouseEvent )
    end
end

onTouch = function( event )
    local fade = transition.to(logo, { time = 300, alpha = 1})
    Runtime:removeEventListener( "touch", onTouch )
end

function scene:show( event )
    local phase = event.phase
    if ( phase == "will" ) then
        local bottomY = display.contentHeight - display.screenOriginY
        local leftX = display.screenOriginX
        local rightX = display.contentWidth - display.screenOriginX
        local screenW = rightX - leftX
        logo_line = display.newLine(leftX + screenW + 35, bottomY, rightX - screenW + 35, bottomY)
        logo_line.x = screenW
        logo_line.y = logo.y + 55
        logo_line.strokeWidth = 1
        logo_line:setStrokeColor(0.3, 0.1, 0.2, 1)
        logo_line.alpha = 1
        ui_objects_group:insert(logo_line)
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
return scene
