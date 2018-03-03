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
    local centerX = display.contentCenterX
    local centerY = display.contentCenterY

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
    sidebar:new()
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local function buttonCallback(event)
        local sceneID = event.target.id
        local options = {effect = "crossFade", time = 200, params = {title = event.target.id}}
        if sceneID == "exit" then
            showDialog("CONFIRM EXIT", "Are you sure you want to exit?", 22)
        elseif sceneID == "menu" then
            sidebar:show()
        else
            composer.gotoScene( sceneID, options )
        end
    end

    menu_buttons = {}
    --                 label, id, x,y, width, height, label-size
    local spacing = 50
    menu_buttons[1] = {"MENU", "menu", centerX, centerX + centerY - 175, 100, 25, 45}
    menu_buttons[2] = {"JOBS", "scenes.jobs", centerX, centerX + centerY - 175 + spacing, 100, 25, 45}
    menu_buttons[3] = {"CALENDER", "scenes.calender", centerX, centerX + centerY - 175 + spacing + spacing, 100, 25, 45}
    menu_buttons[4] = {"EXIT", "exit", centerX, centerX + centerY - 175 + spacing + spacing + spacing, 100, 25, 45}
    for k, v in pairs(menu_buttons) do
        local new_button = widget.newButton ({
            label = menu_buttons[k][1],
            id = menu_buttons[k][2],
            labelColor = {default = {10 / 255, 110 / 255, 0 / 255}, over = {50 / 255, 180 / 255, 255 / 255}},
            onRelease = buttonCallback
        })
        new_button.x = menu_buttons[k][3]
        new_button.y = menu_buttons[k][4]
        new_button.width = menu_buttons[k][5]
        new_button.height = menu_buttons[k][6]
        new_button._view._label.size = menu_buttons[k][7]
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
