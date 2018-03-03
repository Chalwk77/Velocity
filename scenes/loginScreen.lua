local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local editing
local absolute_coordinates
local UIGroup
local users = {
    ["Chalwk77"] = {"vm315", "Jericho"},
    ["Kourtney91"] = {"admin", "Kourtney"},
    ["Kaitlyn97"] = {"admin", "Kaitlyn"}
}

function scene:create( event )
    display.setDefault( "background", 0.5 )
    local loginScreen = display.newGroup()
    local group = display.newGroup()
    UIGroup = display.newGroup()
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
    local background = display.newImage("images/backgrounds/background3.png" )
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

    local welcome_text = display.newImage("images/welcome.png")
    welcome_text.x = display.contentCenterX
    welcome_text.y = logo.y + 80
    welcome_text.alpha = 0
    welcome_text:scale(0.3, 0.4)
    group:insert(welcome_text)

    local alphaFrom = 0.25
    local alphaTo = 1
    local scaleFrom = 0.3
    local scaleTo = 0.4
    local animationTime = 450
    local function animation_start()
        local scaleUp = function()
            anim_trans = transition.to( welcome_text, { time = animationTime, alpha = alphaFrom, xScale = scaleFrom, yScale = scaleFrom, onComplete = animation_start } )
        end
        anim_trans = transition.to( welcome_text, { time = animationTime, alpha = alphaTo, xScale = scaleTo, yScale = scaleTo, onComplete = scaleUp } )
    end
    animation_start()

    local slide_up_delay = 200
    local function textListener( event )
        if system.getInfo("platformName") == "Android" then
            if (event.phase == "began") then
                original_coords = UIGroup.y
                transition.to( UIGroup, {time = slide_up_delay, y = -90})
            elseif (event.phase == "ended" or event.phase == "submitted") then
                if editing == false then
                    native.setKeyboardFocus(nil)
                    transition.to(UIGroup, {time = slide_up_delay, y = original_coords})
                elseif editing == true then
                    -- do nothing
                end
            end
        end
    end
    local function focusListener(event)
        if system.getInfo("platformName") == "Android" then
            if editing == true then
                original_coords = absolute_coordinates
                transition.to(UIGroup, {time = slide_up_delay, y = absolute_coordinates})
            end
        end
    end
    background:addEventListener( "touch", focusListener )

    local spacing = 30
    local seperator = 5

    -- username label
    local labelUsername = display.newText(loginScreen, "Username:", 0, 0, font, 18)
    labelUsername:setTextColor(180, 180, 180)
    labelUsername.x = _W * 0.5 - 85
    labelUsername.y = bottom_screen - 260
    loginScreen:insert(labelUsername)
    group:insert(labelUsername)
    UIGroup:insert(labelUsername)
    labelUsername:addEventListener( "userInput", textListener )

    -- username text field
    local frmUsername = native.newTextField(0, 0, _W * 0.8, 30)
    frmUsername:resizeHeightToFitFont()
    frmUsername.inputType = "default"
    frmUsername.font = native.newFont(font, 18)
    frmUsername.isEditable = true
    frmUsername.align = "left"
    frmUsername.x = _W * 0.5
    frmUsername.y = labelUsername.y + spacing
    frmUsername.text = ''
    frmUsername.placeholder = "Enter your username"
    loginScreen:insert(frmUsername)
    group:insert(frmUsername)
    UIGroup:insert(frmUsername)
    frmUsername:addEventListener( "userInput", textListener )

    -- password label
    local labelPassword = display.newText(loginScreen, "Password:", 0, 0, font, 18)
    labelPassword:setTextColor(180, 180, 180)
    labelPassword.x = _W * 0.5 - 85
    labelPassword.y = frmUsername.y + spacing + seperator
    loginScreen:insert(labelPassword)
    group:insert(labelPassword)
    UIGroup:insert( labelPassword )
    labelPassword:addEventListener( "userInput", textListener )

    -- password text field
    local frmPassword = native.newTextField(0, 0, _W * 0.8, 30)
    frmPassword:resizeHeightToFitFont()
    frmPassword.inputType = "default"
    frmPassword.font = native.newFont(font, 18)
    frmPassword.isEditable = true
    frmPassword.isSecure = true
    frmPassword.align = "left"
    frmPassword.x = _W * 0.5
    frmPassword.y = labelPassword.y + spacing
    frmPassword.text = ''
    frmPassword.placeholder = "Enter your Password"
    loginScreen:insert(frmPassword)
    group:insert(frmPassword)
    UIGroup:insert(frmPassword)
    absolute_coordinates = UIGroup.y
    frmPassword:addEventListener( "userInput", textListener )

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
        if (event.phase == "began") then
            editing = true
            labelReturnStatus.text = ''
        elseif(event.phase == "editing") then
        elseif(event.phase == "ended") then
            editing = false
        elseif(event.phase == "submitted") then
            if frmUsername.text ~= '' and frmPassword.text == '' then
                native.setKeyboardFocus(frmPassword)
            elseif frmUsername.text ~= '' and frmPassword.text ~= '' then
                handleInput()
            elseif frmUsername.text == '' and frmPassword.text == '' then
                handleInput()
            end
        end
    end
    frmUsername:addEventListener("userInput", frmUsername)

    function frmPassword:userInput(event)
        if (event.phase == "began") then
            editing = true
            labelReturnStatus.text = ''
        elseif(event.phase == "editing") then
        elseif(event.phase == "ended") then
            editing = false
        elseif(event.phase == "submitted") then
            if frmPassword.text ~= '' and frmUsername.text == '' then
                native.setKeyboardFocus(frmUsername)
            elseif frmUsername.text ~= '' and frmPassword.text ~= '' then
                handleInput()
            elseif frmUsername.text == '' and frmPassword.text == '' then
                handleInput()
            end
        end
    end
    frmPassword:addEventListener("userInput", frmPassword)

    local function loginCallback(event)
        local function showMenu()
            composer.gotoScene("scenes.menu", {effect = "slideFromLeft", time = 500})
            loginScreen:removeSelf()
        end
        group:removeSelf()
        UIGroup:removeSelf()
        labelReturnStatus.text = 'Welcome back ' .. first_name
        labelReturnStatus.size = 18
        labelReturnStatus.x = display.contentCenterX
        labelReturnStatus.y = display.contentCenterY
        labelReturnStatus:setTextColor(0, 255, 0)
        timer.performWithDelay(1000 * 2, showMenu)
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
        width = 261,
        height = 36,
        font = font,
        fontsize = 18,
        labelColor = {
            default = {0.8, 0.2, 0.1},
            over = {255, 255, 255}
        },
        defaultColor = {201, 107, 61, 0},
        overColor = {219, 146, 85},
        onRelease = login_button_handler
    })
    loginScreen:insert(login_button)
    group:insert(login_button)
    UIGroup:insert(login_button)
    login_button:addEventListener( "userInput", textListener )

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
        for k, v in pairs(users) do
            if (k == userid) and (password == users[k][1]) then
                first_name = users[k][2]
                loginCallback()
                break
            elseif (userid ~= '' and password ~= '') then
                labelReturnStatus.text = 'invalid username or password'
                labelReturnStatus:setTextColor(255, 0, 0)
            end
        end
        if (userid == '' and password == '') or (userid == '' and password ~= '') or (userid ~= '' and password == '') or (userid ~= '' and password ~= '') then
            frmPassword.text = ''
        end
    end
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    if (phase == "did") then
        if (user_logged_out ~= nil and user_logged_out == true) then
            scene:create()
        elseif (user_logged_out ~= nil and user_logged_out == false) then
            -- do nothing
        else
            -- do nothing
        end
    end
end

scene:addEventListener("hide", scene)
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
return scene
