-----------------------------------------------------------------------------------------
-- calendar.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local uiLib = require "plugin.braintonik-dialog"
local widget = require("widget")
local display_group = display.newGroup()
local back_button
local new_calendar
local roster_text
local stop_animation = nil

function scene:show( event )
    if ( event.phase == "will" ) then
        stop_animation = false
        local xScreen = display.contentCenterX - display.actualContentWidth / 2
        local wScreen = display.actualContentWidth
        local yScreen = display.contentCenterY - display.actualContentHeight / 2
        local hScreen = display.actualContentHeight + 100
        display.remove( scene.calendarGroup )
        scene.calendarGroup = display.newGroup()
        self.view:insert( scene.calendarGroup )
        local background = display.newImage(scene.calendarGroup, "images/backgrounds/background2.jpg")
        background.x = display.contentWidth * 0.5
        background.y = display.contentHeight * 0.5
        local scale = math.max( wScreen / background.width, hScreen / background.height )
        background:scale( scale, scale )
        local onClickDate
        local function onCalendarButton(event)
            stop_animation = true
            composer.gotoScene("scenes.menu")
        end
        local bool = 0
        local height = -20
        local calendarTable = {
            {
                group = scene.calendarGroup,
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
                yScreen = yScreen + height,
                wScreen = wScreen,
                hScreen = hScreen,
            },
        }
        uiLib.addTransition( calendarTable[1], "RightToLeft" )
        onClickDate = function()
            if bool == 0 then
                bool = bool + 1
                new_calendar = uiLib.displayCalendarDialog(calendarTable[1])
            elseif (bool == 2) then
                stop_animation = true
                composer.gotoScene("scenes.menu")
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
                    bool = bool + 1
                    onClickDate()
                end
            }
        )
        back_button:scale(0.070, 0.070)
        roster_text = display.newText("ROSTER", 0, 0, native.systemFontBold, 32)
        roster_text.x = display.contentCenterX
        roster_text.y = display.contentCenterY - 200
        roster_text.alpha = 0
        from_xyScale = 0.5
        to_xyScale = 1
        roster_text:scale(from_xyScale, from_xyScale)
        self.view:insert(roster_text)
        local function animation_start( )
            local scaleUp = function( )
                if not stop_animation then
                    anim_trans = transition.to( roster_text, { time = 700, alpha = 0.25, xScale = from_xyScale, yScale = from_xyScale, onComplete = animation_start } )
                end
            end
            anim_trans = transition.to( roster_text, { time = 700, alpha = 1, xScale = to_xyScale, yScale = to_xyScale, onComplete = scaleUp } )
        end
        animation_start( )
    end
end

function scene:hide(event)
    if (event.phase == "will") then
        back_button:removeSelf()
        roster_text:removeSelf()
    end
end

scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
