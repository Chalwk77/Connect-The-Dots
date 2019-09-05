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

    love.graphics.setColor(47,79,79, 1)
    love.graphics.rectangle("fill", x + posX, y + posY, w, h)
end

function loadingState.load(game, finishCallback)
    print("Assets are loading...")
    math.randomseed(os.time())

    ------------------- Preload Static Images:
    loader.newImage(game.images, 1, 'Media/Images/board-select-bg.png')

    loader.newImage(game.images, 2, 'Media/Images/board-3x3.png')
    loader.newImage(game.images, 3, 'Media/Images/board-5x5.png')
    loader.newImage(game.images, 4, 'Media/Images/board-7x7.png')
    loader.newImage(game.images, 5, 'Media/Images/board-9x9.png')
    -- Back Button:
    loader.newImage(game.images, 6, 'Media/Images/return-92x90.png')
    -- Pause Button:
    loader.newImage(game.images, 7, 'Media/Images/pause-92-90.png')

    ------------------- Preload Audio Files:
    loader.newSoundData(game.sounds, 'error', 'Media/Sounds/error.wav')
    loader.newSoundData(game.sounds, 'button_click', 'Media/Sounds/button_click.mp3')
    loader.newSoundData(game.sounds, 'on_hover', 'Media/Sounds/hover.wav')

    ------------------- Preload Fonts:

    -- Menu Title:
    loader.newFont(game.fonts, 1, 'Assets/fonts/dotted_font.ttf', 104)
    -- Menu Buttons:
    loader.newFont(game.fonts, 2, 'Assets/fonts/arial.ttf', 42)
    loader.newFont(game.fonts, 3, 'Assets/fonts/arial.ttf', 12)
    -- Board Select Title:
    loader.newFont(game.fonts, 4, 'Assets/fonts/arial.ttf', 16)
    loader.newFont(game.fonts, 5, 'Assets/fonts/arial.ttf', 64)
    loader.newFont(game.fonts, 6, 'Assets/fonts/dotted_font.ttf', 84)
    loader.newFont(game.fonts, 7, 'Assets/fonts/dotted_font.ttf', 64)
    loader.newFont(game.fonts, 8, 'Assets/fonts/dotted_font.ttf', 42)
    -- Small Print (menu)
    loader.newFont(game.fonts, 9, 'Assets/fonts/arial.ttf', 12)
    -- Turn Text Font:
    loader.newFont(game.fonts, 10, 'Assets/fonts/arial.ttf', 16)


    loader.load(finishCallback, print)
end

function loadingState.draw()
    drawLoadingBar()
end

function loadingState.update(dt)
    loader.update()
end

return loadingState
