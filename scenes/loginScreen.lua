local composer = require( "composer" )
local scene = composer.newScene()
local mime = require("mime")
local json = require("json")
local widget = require("widget")

function scene:create( event )
    local loginScreen = display.newGroup()
    local group = display.newGroup()

    local _W = display.viewableContentWidth
    local _H = display.viewableContentHeight

    local bottom_screen = display.screenOriginY + display.viewableContentHeight - display.screenOriginY

    local font = system.nativeFont
    local userid = nil
    local password = nil
    local URL = nil

    local xScreen = display.contentCenterX - display.actualContentWidth / 2
    local wScreen = display.actualContentWidth
    local yScreen = display.contentCenterY - display.actualContentHeight / 2
    local hScreen = display.actualContentHeight

    -- create menu background
    background = display.newImage("images/backgrounds/background3.png" )
    background.x = display.contentWidth * 0.5
    background.y = display.contentHeight * 0.5
    local scale = math.max( wScreen / background.width, hScreen / background.height )
    background:scale( scale, scale )
    loginScreen:insert(background)

    local logo = display.newImage("images/logo.png")
    logo.x = display.contentCenterX
    logo.y = display.contentCenterY - 230
    logo:scale(0.25, 0.25)
    group:insert(logo)

    local labelHeadline = display.newText(loginScreen, "Please login to continue", 0, 0, native.systemFontBold, 18)
    labelHeadline.x = _W * 0.5
    labelHeadline.y = 70
    loginScreen:insert(labelHeadline)
    group:insert(labelHeadline)

    local spacing = 30
    local seperator = 5

    -- username label
    local labelUsername = display.newText(loginScreen, "Username:", 0, 0, font, 18)
    labelUsername:setTextColor(180, 180, 180)
    labelUsername.x = _W * 0.5 - 85
    labelUsername.y = bottom_screen - 260
    loginScreen:insert(labelUsername)
    group:insert(labelUsername)
    -- username text field
    local frmUsername = native.newTextField(0, 0, _W * 0.8, 30)
    frmUsername.inputType = "default"
    frmUsername.font = native.newFont(font, 18)
    frmUsername.isEditable = true
    frmUsername.align = "left"
    frmUsername.x = _W * 0.5
    frmUsername.y = labelUsername.y + spacing
    frmUsername.text = ''
    loginScreen:insert(frmUsername)
    group:insert(frmUsername)

    -- password label
    local labelPassword = display.newText(loginScreen, "Password:", 0, 0, font, 18)
    labelPassword:setTextColor(180, 180, 180)
    labelPassword.x = _W * 0.5 - 85
    labelPassword.y = frmUsername.y + spacing + seperator
    loginScreen:insert(labelPassword)
    group:insert(labelPassword)
    -- password text field
    local frmPassword = native.newTextField(0, 0, _W * 0.8, 30)
    frmPassword.inputType = "default"
    frmPassword.font = native.newFont(font, 18)
    frmPassword.isEditable = true
    frmPassword.isSecure = true
    frmPassword.align = "left"
    frmPassword.x = _W * 0.5
    frmPassword.y = labelPassword.y + spacing
    frmPassword.text = ''
    loginScreen:insert(frmPassword)
    group:insert(frmPassword)

    local labelReturnStatus = display.newText(loginScreen, "", 0, 0, font, 14)
    labelReturnStatus.x = _W * 0.5 - 5
    labelReturnStatus.y = bottom_screen - 50
    loginScreen:insert(labelReturnStatus)

    local copyright = display.newText("© 2018, Velocity, Jericho Crosby <jericho.crosby227@gmail.com>", 0, 0, native.systemFontBold, 9 )
    copyright.x = display.contentCenterX
    copyright.y = display.screenOriginY + display.viewableContentHeight - display.screenOriginY + 15
    copyright:setFillColor( color_table.RGB("white"), 1)
    copyright.alpha = 1
    loginScreen:insert(copyright)
    group:insert(copyright)

    function frmUsername:userInput(event)
        if(event.phase == "began") then
            event.target.text = ''
        elseif(event.phase == "editing") then
        elseif(event.phase == "ended") then
        elseif(event.phase == "submitted") then
            btnOnReleaseHandler()
        end
    end
    frmUsername:addEventListener("userInput", frmUsername)

    function frmPassword:userInput(event)
        if(event.phase == "began") then
            event.target.text = ''
        elseif(event.phase == "editing") then
        elseif(event.phase == "ended") then
        elseif(event.phase == "submitted") then
            btnOnReleaseHandler()
        end
    end
    frmPassword:addEventListener("userInput", frmPassword)

    local function loginCallback(event)
        -----------temporary--------------------------------------
        local function showMenu()
            composer.gotoScene("scenes.menu", {effect = "slideFromLeft", time = 300})
            loginScreen:removeSelf()
        end
        group:removeSelf()
        local welcome_message = display.newText(loginScreen, "WELCOME BACK", 0, 0, font, 16)
        welcome_message.x = display.contentCenterX
        welcome_message.y = display.contentCenterY
        welcome_message:setTextColor(0, 255, 0)
        timer.performWithDelay(1000 * 2, showMenu)
        -----------temporary--------------------------------------
        if ( event.isError ) then
            print( "Network error!");
        else
            local data = json.decode(event.response)
            if data.result == 200 then
                labelReturnStatus.text = "Welcome back "..data.firstname:gsub("^%l", string.upper)
                timer.performWithDelay(1000 * 2, showMenu)
            else
                labelReturnStatus.text = "Please try again"
            end
        end
        return true;
    end

    function background:tap(event)
        native.setKeyboardFocus(nil)
    end
    background:addEventListener("tap", background)

    local function login_button_handler(event)
        handleInput()
    end

    local login_button = widget.newButton({
        id = "Login Button",
        left = 30,
        top = frmPassword.y + 30,
        label = "Login",
        width = 256,
        height = 36,
        font = font,
        fontsize = 18,
        labelColor = {
            default = {0.8, 0.2, 0.1},
            over = {255, 255, 255}
        },
        defaultColor = {201, 107, 61},
        overColor = {219, 146, 85},
        onRelease = login_button_handler
    })
    loginScreen:insert(login_button)
    group:insert(login_button)

    function handleInput()
        local userid = frmUsername.text
        local password = frmPassword.text
        if (userid == '' and password == '') then
            labelReturnStatus.text = 'A username and password is required!'
        elseif (userid == '' and password ~= '') then
            labelReturnStatus.text = 'A username is required!'
        elseif (userid ~= '' and password == '') then
            labelReturnStatus.text = 'A password is required!'
        end
        labelReturnStatus:setTextColor(255, 0, 0)
        local URL = "http://external.com/json.php?userid=" .. mime.b64(userid) .. "&password=" .. mime.b64(password);
        network.request( URL, "GET", loginCallback )
        return
    end
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    if (phase == "did") then
        if (frmPassword.isVisible ~= nil and frmPassword.isVisible == false) and (frmUsername.isVisible ~= nil and frmUsername.isVisible == false) then
            frmPassword.isVisible = true
            frmUsername.isVisible = true
        end
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
return scene
