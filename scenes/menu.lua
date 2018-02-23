-----------------------------------------------------------------------------------------
-- menu.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
--
-----------------------------------------------------------------------------------------
local composer = require( 'composer' )
local scene = composer.newScene()

function scene:create( event )
    local sceneGroup = self.view
    local function setUpDisplay(group)
        local background = display.newImage(group, "images/menu_background.png")
        background.xScale = (0.5 * background.contentWidth) / background.contentWidth
        background.yScale = background.xScale
        background.x = display.contentCenterX
        background.y = display.contentCenterY
        background:scale(0.4, 0.4)
    end
    setUpDisplay(sceneGroup)
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- scene begin
    elseif ( phase == "did" ) then
        -- scene end
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- scene begin
    elseif ( phase == "did" ) then
        -- scene end
    end
end

---------------------------------------------------------------
-- scene listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
