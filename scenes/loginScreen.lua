local mime = require("mime")
local json = require("json")
local widget = require("widget")
local composer = require( "composer" )
local scene = composer.newScene()
function scene:create( event )
    local _W = display.viewableContentWidth
    local _H = display.viewableContentHeight

    local font = system.nativeFont
    local userid = nil
    local password = nil
    local URL = nil

    local xScreen = display.contentCenterX - display.actualContentWidth / 2
    local wScreen = display.actualContentWidth
    local yScreen = display.contentCenterY - display.actualContentHeight / 2
    local hScreen = display.actualContentHeight

    -- create menu background
    background = display.newImage("images/backgrounds/background1.png" )
    background.x = display.contentWidth * 0.5
    background.y = display.contentHeight * 0.5
    local scale = math.max( wScreen / background.width, hScreen / background.height )
    background:scale( scale, scale )

    local loginScreen = display.newGroup()
    local group = display.newGroup()
    loginScreen:insert(background)

    local labelHeadline = display.newText(loginScreen, "Please login to continue", 0, 0, native.systemFontBold, 18)
    labelHeadline.x = _W * 0.5
    labelHeadline.y = 70
    loginScreen:insert(labelHeadline)
    group:insert(labelHeadline)

    local labelUsername = display.newText(loginScreen, "Username", 0, 0, font, 18)
    labelUsername:setTextColor(180, 180, 180)
    labelUsername.x = _W * 0.5 - 85
    labelUsername.y = 110
    loginScreen:insert(labelUsername)
    group:insert(labelUsername)

    local labelPassword = display.newText(loginScreen, "Password", 0, 0, font, 18)
    labelPassword:setTextColor(180, 180, 180)
    labelPassword.x = _W * 0.5 - 85
    labelPassword.y = 175
    loginScreen:insert(labelPassword)
    group:insert(labelPassword)

    local labelReturnStatus = display.newText(loginScreen, "", 0, 0, font, 14)
    labelReturnStatus.x = _W * 0.5 - 5
    labelReturnStatus.y = 310
    loginScreen:insert(labelReturnStatus)

    local frmUsername = native.newTextField(0, 0, _W * 0.8, 30)
    frmUsername.inputType = "default"
    frmUsername.font = native.newFont(font, 18)
    frmUsername.isEditable = true
    frmUsername.align = "left"
    frmUsername.x = _W * 0.5
    frmUsername.y = 135
    frmUsername.text = ''
    loginScreen:insert(frmUsername)
    group:insert(frmUsername)

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

    local frmPassword = native.newTextField(0, 0, _W * 0.8, 30)
    frmPassword.inputType = "default"
    frmPassword.font = native.newFont(font, 18)
    frmPassword.isEditable = true
    frmPassword.isSecure = true
    frmPassword.align = "left"
    frmPassword.x = _W * 0.5
    frmPassword.y = 200
    frmPassword.text = ''
    loginScreen:insert(frmPassword)
    group:insert(frmPassword)

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
            composer.gotoScene("scenes.menu")
            loginScreen:removeSelf()
        end
        group:removeSelf()
        local labelReturnStatus = display.newText(loginScreen, "", 0, 0, font, 14)
        labelReturnStatus.text = "WELCOME BACK"
        labelReturnStatus.x = display.contentCenterX
        labelReturnStatus.y = display.contentCenterY
        labelReturnStatus:setTextColor(0, 255, 0)
        timer.performWithDelay(1000 * 3, showMenu)
        -----------temporary--------------------------------------


        if ( event.isError ) then
            print( "Network error!");
        else
            local data = json.decode(event.response)
            if data.result == 200 then
                labelReturnStatus.text = "Welcome back "..data.firstname:gsub("^%l", string.upper)
                timer.performWithDelay(5000, composer.gotoScene( "scenes.menu" ))
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

    local function btnOnPressHandler(event)

    end

    local function btnOnDragHandler(event)

    end

    local function btnOnReleaseHandler(event)
        handleInput()
    end

    local login_button = widget.newButton({
        id = "Login Button",
        left = 30,
        top = 230,
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
        onPress = btnOnPressHandler,
        onDrag = btnOnDragHandler,
        onRelease = btnOnReleaseHandler
    })
    loginScreen:insert(login_button)
    group:insert(login_button)

    function handleInput()
        local userid = frmUsername.text
        local password = frmPassword.text
        if (userid == '' or password == '') then
            labelReturnStatus:setTextColor(255, 0, 0)
            labelReturnStatus.text = 'A username or password is required!'
            return
        end
        local URL = "http://external.com/json.php?userid=" .. mime.b64(userid) .. "&password=" .. mime.b64(password);
        network.request( URL, "GET", loginCallback )
        print("sending network request...")
    end
end
scene:addEventListener( "create", scene )
return scene
