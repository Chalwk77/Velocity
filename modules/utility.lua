-----------------------------------------------------------------------------------------
-- utility.lua
-- (c) 2018, Velocity by Jericho Crosby <jericho.crosby227@gmail.com>
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
composer.effectList["slideFromLeft"] = {
    sceneAbove = true,
    concurrent = true,
    to = {
        xStart = display.contentWidth,
        yStart = 0,
        xEnd = 0,
        yEnd = 0,
        transition = easing.outQuad
    },
    from = {
        xStart = 0,
        yStart = 0,
        xEnd = -display.contentWidth * 0.3,
        yEnd = 0,
        transition = easing.outQuad
    }
}
composer.effectList["slideFromRight"] = {
    sceneAbove = false,
    concurrent = true,
    to = {
        xStart = -display.contentWidth * 0.3,
        yStart = 0,
        xEnd = 0,
        yEnd = 0,
        transition = easing.outQuad
    },
    from = {
        xStart = 0,
        yStart = 0,
        xEnd = display.contentWidth,
        yEnd = 0,
        transition = easing.outQuad
    }
}

draw_seperator = function(height, stroke)
    seperator_group = display.newGroup()
    if stroke then stroke = stroke else stroke = 0.8 end
    if height then height = height else height = - 15 end
    local n1 = (display.screenOriginX + display.contentWidth)
    local n2 = (display.contentHeight - display.screenOriginY)
    local n3 = (display.contentWidth - display.contentWidth - display.screenOriginX)
    new_seperator = display.newLine(n1, n2, n3, n2)
    new_seperator.strokeWidth = stroke
    new_seperator:setStrokeColor(255, 255, 255)
    new_seperator.y = new_seperator.y + height
    seperator_group:insert(new_seperator)
end
