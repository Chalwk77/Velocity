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
local frame_group
local button_group

local xScreen = display.contentCenterX - display.actualContentWidth / 2
local wScreen = display.actualContentWidth
local yScreen = display.contentCenterY - display.actualContentHeight / 2
local hScreen = display.actualContentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

function scene:create(event)
    button_group = display.newGroup()
    frame_group = display.newGroup()
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
    frame_group:insert(logo)
    sidebar:new()
    ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function onButtonPress(event)
        -- transition.to(event.target, {time = 100, xScale = 0.6, yScale = 0.7})
    end
    local function onButtonRelease(event)
        -- transition.to(event.target, {time = 0, xScale = prevXScale, yScale = prevYScale})
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
        elseif sceneID == "logout" then
            showDialog("CONFIRM LOGOUT", "Are you sure you want to logout?", 22, "logout")
        else
            hideUI(true)
            composer.gotoScene(sceneID, options)
        end
    end
    buttons = {}
    local spacing = 50
    local b_width = 135
    local b_height = 34
    local b_fontsize = 40
    -- LABEL | scene | x,y | width | height | fontsize | fillcolor(default) | fillcolor(over) | strokecolor(default) | strokecolor(over)
    buttons[1] = {"MENU", "menu", centerX, centerX + centerY - 175, b_width, b_height, b_fontsize, "skyblue", "skyblue2", "lavenderblush", "crimson"}
    buttons[2] = {"JOBS", "scenes.jobs", centerX, centerX + centerY - 175 + (spacing), b_width, b_height, b_fontsize, "skyblue", "skyblue2", "lavenderblush", "crimson"}
    buttons[3] = {"CALENDAR", "scenes.calendar", centerX, centerX + centerY - 175 + (spacing * 2), b_width, b_height, b_fontsize, "skyblue", "skyblue2", "lavenderblush", "crimson"}
    buttons[4] = {"EXIT", "exit", centerX, centerX + centerY - 175 + (spacing * 3), b_width, b_height, b_fontsize, "skyblue", "skyblue2", "lavenderblush", "crimson"}
    buttons[5] = {"LOGOUT", "logout", centerX, centerX + centerY - 175 + (spacing * 4), b_width, b_height, b_fontsize, "skyblue", "skyblue2", "lavenderblush", "crimson"}
    for k, v in pairs(buttons) do
        menu_button = widget.newButton{
            label = buttons[k][1],
            id = buttons[k][2],
            labelColor = {default = {color_table.color("indigo")}, over = {color_table.color("white")}},
            shape = "roundedRect",
            width = 250,
            height = 50,
            cornerRadius = 20,
            labelYOffset = 0,
            fillColor = {default = {color_table.color(buttons[k][8])}, over = {color_table.color(buttons[k][9])}},
            strokeColor = {default = {color_table.color(buttons[k][10])}, over = {color_table.color(buttons[k][11])}},
            strokeWidth = 7,
        onPress = onButtonPress, onRelease = onButtonRelease}
        menu_button.x = buttons[k][3]
        menu_button.y = buttons[k][4]
        menu_button.width = buttons[k][5]
        menu_button.height = buttons[k][6]
        menu_button._view._label.size = buttons[k][7]
        -- prevXScale = menu_button.xScale
        -- prevYScale = menu_button.yScale
        button_group:insert(menu_button)
        absoluteX = button_group.x
        absoluteY = button_group.y
        if application_version ~= nil then button_group:insert(application_version) end
    end
    -- if first_name ~= nil and first_name ~= "ERROR" then
    --     LoadProfilePicture()
    -- end
    --========== [ CANVAS FRAME ] ==========--
    local topY = display.screenOriginY
    local bottomY = display.contentHeight - display.screenOriginY
    local leftX = display.screenOriginX
    local rightX = display.contentWidth - display.screenOriginX
    local screenW = rightX - leftX
    local screenH = bottomY - topY

    local stroke_width = 5
    local line_color = "purple"
    local offset = 55
    local top_Third = display.newLine(rightX, logo.y + offset, leftX, logo.y + offset)
    top_Third.strokeWidth = 1
    top_Third:setStrokeColor(color_table.color(line_color))

    local Y_top = display.newLine(leftX + screenW, topY, rightX - screenW, topY)
    Y_top.strokeWidth = stroke_width
    Y_top:setStrokeColor(color_table.color(line_color))

    local Y_Bottom = display.newLine(leftX + screenW, bottomY, rightX - screenW, bottomY)
    Y_Bottom.strokeWidth = stroke_width
    Y_Bottom:setStrokeColor(color_table.color(line_color))

    local X_right = display.newLine(leftX + screenW, topY, leftX + screenW, bottomY)
    X_right.strokeWidth = stroke_width
    X_right:setStrokeColor(color_table.color(line_color))

    local X_left = display.newLine(0, topY, 0, bottomY)
    X_left.strokeWidth = 5
    X_left:setStrokeColor(color_table.color(line_color))

    frame_group:insert(top_Third)
    frame_group:insert(Y_top)
    frame_group:insert(Y_Bottom)
    frame_group:insert(X_right)
    frame_group:insert(X_left)
end

hideUI = function(bool)
    local transparency = 0.050
    if bool == false then
        transition.to(frame_group, {time = 300, alpha = transparency})
        transition.to(button_group, {time = 300, alpha = transparency, x = button_group.x, y = button_group.y + hScreen})
    elseif bool == true then
        transition.to(frame_group, {time = 300, alpha = 0})
        transition.to(button_group, {time = 300, alpha = 0})
    elseif bool == nil then
        transition.to(frame_group, {time = 300, alpha = transparency})
        transition.to(button_group, {time = 300, alpha = transparency})
    end
end

showUI = function(bool)
    local transparency = 1
    if bool == false then
        transition.to(frame_group, {time = 300, alpha = transparency})
        transition.to(button_group, {time = 200, alpha = transparency, x = absoluteX, y = absoluteY})
    elseif bool == true then
        transition.to(frame_group, {time = 300, alpha = 0})
        transition.to(button_group, {time = 300, alpha = 0})
    elseif bool == nil then
        transition.to(frame_group, {time = 300, alpha = transparency})
        transition.to(button_group, {time = 300, alpha = transparency})
    end
    menu_background:removeEventListener("tap", bgListener)
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
        if application_version ~= nil then application_version.isVisible = true end
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    end
end

function LoadProfilePicture(user)
    function extractImageName(url)
        local function searchChar(url, index, char)
            local startOfFilename = string.find( url, char, index)
            if startOfFilename ~= nil then
                return searchChar(url, startOfFilename + 1, char)
            else
                return index
            end
        end
        local startOfFilename = searchChar(url, 1, "/")
        local returnData
        if startOfFilename == nil then
            returnData = nil
        else
            returnData = string.sub(url, startOfFilename)
        end
        return returnData
    end
    function doesFileExist(fname, path)
        local results = false
        local filePath = system.pathForFile(fname, path)
        if filePath then
            filePath = io.open(filePath, "r")
        end
        if filePath then
            filePath:close()
            results = true
        else
            print("File does not exist -> " .. fname)
        end
        return results
    end
    local url = "http://i.imgur.com/o0GnlFX.jpg"
    local imgFilename = extractImageName(url)
    if imgFilename == nil then return end
    local function networkListener(event)
        if (event.isError) then
            print ("ERROR RESPONSE: ", event.response.filename)
        else
            print ("RESPONSE: ", event.response.filename)
        end
    end
    if doesFileExist(imgFilename, system.TemporaryDirectory) then
        -- print("Picture file exist! " .. imgFilename)
        local profile_picture = display.newImageRect(imgFilename, system.TemporaryDirectory, 0, 0)
        profile_picture.width = 74
        profile_picture.height = 74
        local height_from_top = 50
        profile_picture.x = display.contentCenterX - 10
        profile_picture.y = display.contentCenterY - display.actualContentHeight / 2 + height_from_top
        profile_picture:scale(1.2, 1.2)
        sidebar_button_group:insert(profile_picture)
    else
        local tmpID = network.download(url, "GET", networkListener, imgFilename, system.TemporaryDirectory)
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
