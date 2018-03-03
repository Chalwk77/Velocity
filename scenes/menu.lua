-----------------------------------------------------------------------------------------
-- menu.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget = require("widget")
local uiLib = require("plugin.braintonik-dialog")
local sidebar = require("modules.sidebar")
local scene = composer.newScene()
local logo
local background
local onMouseEvent
local line_logo_group

function scene:create( event )
    line_logo_group = display.newGroup()
    scene.menu = 0
    local group = display.newGroup()
    self.view:insert( group )

    local xScreen = display.contentCenterX - display.actualContentWidth / 2
    local wScreen = display.actualContentWidth
    local yScreen = display.contentCenterY - display.actualContentHeight / 2
    local hScreen = display.actualContentHeight

    -- create menu background
    background = display.newImage( group, "images/backgrounds/background1.png" )
    background.x = display.contentWidth * 0.5
    background.y = display.contentHeight * 0.5
    local scale = math.max( wScreen / background.width, hScreen / background.height )
    background:scale( scale, scale )
    group:insert(background)

    -- create logo
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

    -- create logo
    logo_line = display.newLine(leftX + screenW + 35, bottomY, rightX - screenW + 35, bottomY)
    logo_line.x = screenW
    logo_line.y = logo.y + 55
    logo_line.strokeWidth = 1
    logo_line:setStrokeColor(0.3, 0.1, 0.2, 1)
    logo_line.alpha = 1
    line_logo_group:insert(logo_line)
    -------------- [CREATE SIDEBAR] --------------
    sidebar_buttons = { }
    sidebar_buttons[1] = {"images/messages.png", 34, 34, "Messages", "scenes.messages", 13}
    sidebar_buttons[2] = {"images/settings.png", 34, 34, "Settings", "scenes.settings", 13}
    sidebar_buttons[3] = {"images/notes.png", 34, 34, "Notes", "scenes.notes", 13}
    sidebar_buttons[4] = {"images/jobs.png", 34, 34, "Jobs", "scenes.jobs", 13}
    sidebar_buttons[5] = {"images/help.png", 34, 34, "Help", "scenes.help", 13}
    sidebar_buttons[6] = {"images/buttons/logout.png", 100, 34, "", "scenes.loginScreen", 13}
    local _W = display.contentWidth
    local temp_group = display.newGroup()
    local data = {}
    data.icon = {}
    data.iconWidth = {}
    data.iconHeight = {}
    data.label = {}
    data.scene = {}
    data.bg = "background.png"
    for k, v in pairs(sidebar_buttons) do
        table.insert(data.iconWidth, sidebar_buttons[k][2])
        table.insert(data.iconHeight, sidebar_buttons[k][3])
    end
    temp_group:insert(sidebar:new(data))
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    menu_buttons = { }
    menu_buttons[1] = { "MENU"}
    menu_buttons[2] = { "JOBS", "scenes.jobs"}
    menu_buttons[3] = { "CALANDER", "scenes.calendar"}
    menu_buttons[4] = { "EXIT"}

    local function createUIButton( parentGroup, name, x, y, w, h )
        local function buttonCallback(button_name)
            if button_name == "MENU" then
                sidebar:show()
            elseif button_name == "EXIT" then
                showDialog("CONFIRM EXIT", "Are you sure you want to exit?", 22)
            else
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
    group:insert(line_logo_group)
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
        logo_line.isVisible = true
        logo.isVisible = true
        line_logo_group.alpha = 1
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- do nothing
    elseif ( phase == "did" ) then
        logo_line.isVisible = false
        logo.isVisible = false
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

function OnError(Message)
    print(debug.traceback())
end

return scene
