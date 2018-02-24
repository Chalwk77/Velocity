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
function scene:create( event )
    scene.menu = 0

    local xScreen = display.contentCenterX - display.actualContentWidth / 2
    local wScreen = display.actualContentWidth
    local yScreen = display.contentCenterY - display.actualContentHeight / 2
    local hScreen = display.actualContentHeight

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

    local buttonNameTable = {
        ["MENU"] = "nil",
        ["JOBS"] = "scenes.jobs",
        ["CALANDER"] = "scenes.calendar",
        ["EXIT"] = "nil"
    }

    local function createUIButton( parentGroup, name, x, y, w, h )
        local function buttonCallback( button_id )
            if button_id == "MENU" then
                scene:showSlidingMenu()
            elseif button_id == "EXIT" then
                showDialog()
            else
                composer.gotoScene( buttonNameTable[button_id] )
            end
        end
        local options = {
            id = name,
            group = parentGroup,
            callBack = buttonCallback,
            x = x,
            y = y + 200,
            w = w,
            h = h,
            align = "center",
            alignLeftRightMargin = 20,
            spaceBetweenIconAndText = 50,
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
        uiLib.newUIButton( options )
    end

    local height_from_bottom = 150
    local wButton = 140
    local xButton = xScreen + wScreen / 2 - wButton / 2
    local yButton = yScreen + height_from_bottom
    local hButton = 44
    for key, value in pairs(buttonNameTable) do
        createUIButton( group, key, xButton, yButton, wButton, hButton )
        yButton = yButton + hButton + 10
    end
    function scene:showSlidingMenu()
        local function callBack( itemId )
            if itemId ~= nil then
                logo.isVisible = false
                composer.gotoScene( itemId, {effect = "crossFade", time = 100} )
            end
        end
        local slidingMenuTable = {
            {
                appearsFrom = "left",
                wDialog = 150,
                bkGradient = {
                    type = "gradient",
                    color1 = { 23 / 255, 172 / 255, 254 / 255, 0.2 },
                    color2 = { 102 / 255, 244 / 255, 134 / 255 },
                    direction = "down",
                },
                buttonHandler = callBack,
                borderSize = 4,

                itemListTextMarginPadding = 44,
                itemListIconMarginPadding = 10,
                itemListJustify = "left",
                itemListcenterSpacing = 5,
                itemListFont = native.systemFont,
                itemListFontSize = 12,

                itemList = { { iconFilename = "images/sidebar_logo.png", iconWidth = 96, iconHeight = 96, name = "USERNAME | ERROR", height = 142, justify = "center" },
                    { separator = true, height = 1, color = {1, 1, 1, 0.5}, width = 120, justify = "center" },
                    { iconFilename = "images/messages.png", iconWidth = 24, iconHeight = 24, name = "Messages", height = 50, id = "scenes.messages"},
                    { iconFilename = "images/settings.png", iconWidth = 24, iconHeight = 24, name = "Settings", height = 50, id = "scenes.settings"},
                    { iconFilename = "images/notes.png", iconWidth = 24, iconHeight = 24, name = "Notes", height = 50, id = "scenes.notes"},
                    { iconFilename = "images/jobs.png", iconWidth = 24, iconHeight = 24, name = "Jobs", height = 50, id = "scenes.jobs"},
                    { iconFilename = "images/help.png", iconWidth = 24, iconHeight = 24, name = "Help", height = 50, id = "scenes.help"},

                },
                xScreen = xScreen,
                yScreen = yScreen,
                wScreen = wScreen,
                hScreen = hScreen,
            },
        }
        local sidebar = uiLib.displaySlidingDialog(slidingMenuTable[1])
        display.remove(group)
        Runtime:addEventListener( "mouse", onMouseEvent )
    end
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        if logo ~= nil and logo.isVisible == false then
            logo.isVisible = true
        end
    end
end

onMouseEvent = function(event)
    if event.isPrimaryButtonDown then
        scene:create()
        Runtime:removeEventListener( "mouse", onMouseEvent )
    end
end

function showDialog( event )
    local xScreen = display.contentCenterX - display.actualContentWidth / 2
    local wScreen = display.actualContentWidth
    local yScreen = display.contentCenterY - display.actualContentHeight / 2
    local hScreen = display.actualContentHeight
    local dialog_group = display.newGroup()
    local background = display.newImage( dialog_group, "assets/bkImg.jpg" )
    background.x = display.contentWidth * 0.5
    background.y = display.contentHeight * 0.5
    local scale = math.max( wScreen / background.width, hScreen / background.height )
    background:scale( scale, scale )
    local options = uiLib.applyOptionsFromTemplate( "rectGreyBlue" )
    uiLib.addTransition( options, "TopToBottom" )
    uiLib.addBackgroundOptions( options, true )
    local function callBack( id )
        if id == "YES" then
            native.requestExit()
        elseif id == "NO" then
            background.isVisible = false
        end
    end
    options.titleString = "Confirm Exit"
    options.textString = "Are you sure you want to exit?"
    options.buttonHandler = callBack
    options.buttonName = { "YES", "NO"}
    options.xScreen = xScreen
    options.yScreen = yScreen
    options.wScreen = wScreen
    options.hScreen = hScreen
    uiLib.displayPopupDialog( options )
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "showdialog", scene )
return scene
