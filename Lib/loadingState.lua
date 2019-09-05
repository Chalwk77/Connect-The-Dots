local loader = require 'Lib/love-loader'
local loadingState = {}

-- Game Variables:
local ww, wh = love.graphics.getDimensions()

local function drawLoadingBar()
    local separation = 30
    local w = ww - 2 * separation
    local h = 20
    local x, y = separation, wh - separation - h

    local posX, posY = 250, 180
    love.graphics.setColor(105, 105, 105, 1)
    love.graphics.rectangle("line", x + posX, y + posY, w, h)

    x, y = x + 3, y + 3
    w, h = w - 6, h - 7

    -- Increment Loadbar Percentage:
    if (loader.loadedCount > 0) then
        w = w * (loader.loadedCount / loader.resourceCount)

        local font = love.graphics.newFont("Assets/Fonts/arial.ttf", 20)
        love.graphics.setFont(font)

        local percent_complete = math.floor(100 * loader.loadedCount / loader.resourceCount)
        local width = love.graphics.getWidth()

        local percent = 0
        if (loader.resourceCount ~= 0) then
            percent = loader.loadedCount / loader.resourceCount
        end

        love.graphics.printf(("Loading ... %d%%"):format(percent * 100), 0, y + 150, width, "center")
    end
end

function loadingState.load(game, finishCallback)
    print("Assets are loading...")
    math.randomseed(os.time())

    -- Preload Static Images:
    loader.newImage(game.images, 1, 'Media/Images/board-select-bg.png')

    -- Preload Audio Files:
    loader.newSoundData(game.sounds, 'error', 'Media/Sounds/error.wav')
    loader.newSoundData(game.sounds, 'button_click', 'Media/Sounds/button_click.mp3')

    -- Preload Fonts:
    loader.newFont(game.fonts, 1, 'Assets/fonts/dotted_font.ttf', 84)
    loader.newFont(game.fonts, 2, 'Assets/fonts/arial.ttf', 32)
    loader.newFont(game.fonts, 3, 'Assets/fonts/arial.ttf', 12)

    loader.load(finishCallback, print)
end

function loadingState.draw()
    drawLoadingBar()
end

function loadingState.update(dt)
    loader.update()
end

return loadingState
