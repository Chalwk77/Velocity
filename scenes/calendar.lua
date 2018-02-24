-----------------------------------------------------------------------------------------
-- calander.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local uiLib = require "plugin.braintonik-dialog"
local scene = composer.newScene()

function scene:show( event )
    if ( event.phase == "will" ) then

        local xScreen = display.contentCenterX - display.actualContentWidth / 2
        local wScreen = display.actualContentWidth
        local yScreen = display.contentCenterY - display.actualContentHeight / 2
        local hScreen = display.actualContentHeight + 100

        display.remove( scene.myGroup )
        scene.myGroup = display.newGroup()
        self.view:insert( scene.myGroup )

        local bkImgObj = display.newImage( scene.myGroup, "images/backgrounds/background2.jpg" )
        bkImgObj.x = display.contentWidth * 0.5
        bkImgObj.y = display.contentHeight * 0.5
        local scale = math.max( wScreen / bkImgObj.width, hScreen / bkImgObj.height )
        bkImgObj:scale( scale, scale )

        local onClickDate
        local function onCalendarButton()
            onClickDate()
        end
        scene.calendarExample = 0

        local calendarTable = {
            {
                group = scene.myGroup,
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
            scene.calendarExample = scene.calendarExample + 1
            if scene.calendarExample > #calendarTable then
                composer.gotoScene( "scenes.menu" )
            else
                uiLib.displayCalendarDialog( calendarTable[scene.calendarExample] )
            end
        end

        onClickDate()

    end
end

scene:addEventListener( "show", scene )

return scene
