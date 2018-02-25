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
