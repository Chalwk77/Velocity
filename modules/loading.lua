local composer = require('composer')
local scene = composer.newScene()
function scene:create()
    local group = self.view
    local xScreen = display.contentCenterX - display.actualContentWidth / 2
    local wScreen = display.actualContentWidth
    local yScreen = display.contentCenterY - display.actualContentHeight / 2
    local hScreen = display.actualContentHeight

    local background = display.newImage("images/backgrounds/background3.png" )
    background.x = display.contentWidth * 0.5
    background.y = display.contentHeight * 0.5
    local scale = math.max( wScreen / background.width, hScreen / background.height )
    background:scale( scale, scale )
    group:insert(background)

    local label = display.newText({
        parent = group,
        text = 'please wait...',
        x = display.contentCenterX,
        y = display.contentCenterY + 100,
        font = native.systemFontBold,
        fontSize = 24
    })
    group:insert(label)

    local loading_icon = display.newGroup()
    loading_icon.x, loading_icon.y = display.contentCenterX, display.contentCenterY
    group:insert(loading_icon)
    loading_icon:scale(0.5, 0.5)
    for i = 0, 2 do
        local loading = display.newImageRect(loading_icon, 'images/loading/loading.png', 64, 64)
        loading.x = xScreen
        loading.y = yScreen
        loading.anchorX = display.contentCenterX * 0.5
        loading.anchorY = display.contentCenterY * 0.5
        loading.rotation = 120 * i
        transition.to(loading, {time = 1500, rotation = 360, delta = true, iterations = -1})
    end
end

function scene:show(event)
    if event.phase == 'will' then
    elseif event.phase == 'did' then
        timer.performWithDelay(duration, function()
            composer.gotoScene(scene_id, {effect = "crossFade", time = 100})
        end)
    end
end

scene:addEventListener('create')
scene:addEventListener('show')

return scene
