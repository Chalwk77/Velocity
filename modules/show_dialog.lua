local uiLib = require "plugin.braintonik-dialog"
function showDialog(title, string, font_size, bool)
    local xScreen = display.contentCenterX - display.actualContentWidth / 2
    local wScreen = display.actualContentWidth
    local yScreen = display.contentCenterY - display.actualContentHeight / 2
    local hScreen = display.actualContentHeight
    local dialog_group = display.newGroup()
    local background = display.newImage( dialog_group, "images/backgrounds/background2.jpg" )
    background.x = display.contentWidth * 0.5
    background.y = display.contentHeight * 0.5
    local scale = math.max( wScreen / background.width, hScreen / background.height )
    background:scale( scale, scale )
    local options = uiLib.applyOptionsFromTemplate( "rectGreyBlue" )
    uiLib.addTransition( options, "TopToBottom" )
    uiLib.addBackgroundOptions( options, true )
    local function callBack(id)
        if id == "YES" then
            native.requestExit()
        elseif id == "NO" then
            background.isVisible = false
        end
    end
    local function updatePrompt(id)
        if id == "YES" then
            system.openURL("https://play.google.com/store/apps/details?id=com.gmail.crosby227.jericho.Velocity")
            background.isVisible = false
        elseif id == "NO" then
            background.isVisible = false
        end
    end
    options.alpha = 1
    options.titleFontSize = font_size
    options.titleColor = {0.9, 0.1, 0.1, options.alpha}
    options.titleString = title
    options.textString = string
    if (bool == false) then
        options.buttonHandler = callBack
    elseif (bool == true) then
        options.buttonHandler = updatePrompt
    else
        options.buttonHandler = callBack
    end
    options.buttonName = { "YES", "NO"}
    options.xScreen = xScreen
    options.yScreen = yScreen
    options.wScreen = wScreen
    options.hScreen = hScreen
    uiLib.displayPopupDialog( options )
    bool = nil
end
