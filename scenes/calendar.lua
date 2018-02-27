-----------------------------------------------------------------------------------------
-- calander.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local uiLib = require "plugin.braintonik-dialog"
local widget = require("widget")
function scene:show( event )
    local back_button
    local new_calander
    if ( event.phase == "will" ) then
        local xScreen = display.contentCenterX - display.actualContentWidth / 2
        local wScreen = display.actualContentWidth
        local yScreen = display.contentCenterY - display.actualContentHeight / 2
        local hScreen = display.actualContentHeight + 100
        display.remove( scene.calanderGroup )
        scene.calanderGroup = display.newGroup()
        self.view:insert( scene.calanderGroup )
        local background = display.newImage( scene.calanderGroup, "images/backgrounds/background2.jpg" )
        background.x = display.contentWidth * 0.5
        background.y = display.contentHeight * 0.5
        local scale = math.max( wScreen / background.width, hScreen / background.height )
        background:scale( scale, scale )

        local onClickDate
        local function onCalendarButton()
            onClickDate()
        end
        scene.calander = 0
        local calendarTable = {
            {
                group = scene.calanderGroup,
                hDialog = 310,
                nextPreviousFont = native.systemFontBold,
                overideBkInput = true,
                colorStyle = "grey",
                shadowColor = {0, 0, 0, 0.3 },
                shadowSize = 5,
                monthNumberFont = native.systemFont,
                weekDayFont = native.systemFont,
                dateNumberFont = native.systemFont,
                selectDays = "2017-05-18,2017-05-02,2017-4-19,2017-4-20,2017-4-21",
                buttonHandler = onCalendarButton,
                xScreen = xScreen,
                yScreen = yScreen,
                wScreen = wScreen,
                hScreen = hScreen,
            },
        }
        uiLib.addTransition( calendarTable[1], "RightToLeft" )
        onClickDate = function()
            scene.calander = scene.calander + 1
            if scene.calander > #calendarTable then
                composer.gotoScene("scenes.menu")
            else
                uiLib.displayCalendarDialog(calendarTable[1])
            end
        end
        onClickDate()
        local x, y = -2, 0
        local spacing = 65
        local height = 300
        back_button = widget.newButton (
            {
                defaultFile = 'images/buttons/back_button.png',
                overFile = 'images/buttons/back_button_pressed.png',
                x = x * spacing + display.contentCenterX,
                y = display.contentCenterX + y * spacing + height,
                onRelease = function()
                    back_button:removeSelf()
                    composer.gotoScene( "scenes.menu", {effect = "crossFade", time = 100})
                end
            }
        )
        back_button:scale(0.070, 0.070)
    end
end
scene:addEventListener( "show", scene )

return scene
