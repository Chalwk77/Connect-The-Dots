local loader = require 'Lib/love-loader'
local loadingState = {}

-- Game Variables:
local ww, wh = love.graphics.getDimensions()
local logo = { }

local function drawLoadingBar()
    local separation = 30
    local w = ww - 2*separation
    local h = 20
    local x,y = separation, wh - separation - h

    local posX, posY = 250, 180
    love.graphics.setColor(105,105,105, 1)
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

    -- love.graphics.setColor(47,79,79, 1)
    -- love.graphics.rectangle("fill", x + posX, y + posY, w, h)
    -- love.graphics.draw(logo.img, logo.x, logo.y, 0, logo.sx, logo.sy)
end

function loadingState.load(game, finishCallback)
    print("Assets are loading...")
    math.randomseed(os.time())

    -- logo.img = love.graphics.newImage("Media/Images/logo.png");
    -- logo.sx, logo.sy = 0.3, 0.3
    -- logo.x, logo.y = (ww/2) - 400, (wh/2) - 250

    -- Preload Static Images:
    -- loader.newImage(game.images, 1, 'Media/images/moon.png')

    -- Preload Audio Files:
    loader.newSoundData(game.sounds, 'error', 'Media/Sounds/error.wav')

    -- Preload Fonts:
    loader.newFont(game.fonts, 1, 'Assets/fonts/dotted_font.ttf', 84)

    loader.load(finishCallback, print)
end

function loadingState.draw()
    drawLoadingBar()
end

function loadingState.update(dt)
    loader.update()
end

return loadingState
