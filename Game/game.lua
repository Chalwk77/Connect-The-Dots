local game = { }
game.state = "menu"

-- Game Tables:
local picked, connected = {}, {}
local title = { }
local grid = {

    x = 385, -- Grid X Coordinate
    y = 270, -- Grid Y Coordinate

    spacing = 64, -- Spacing between dots

    radius = 10, -- Circle radius
    line_width = 5,

    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 1
    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 2
    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 3
    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 4
    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 5
    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 6
    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 7
}

-- Local Variables:
local click_count = nil
local currentPlayer = 1
local startPlayer = currentPlayer

-- Screen Shake Animation:
local trans, shakeDuration, shakeMagnitude = 0, - 1, 0

-- Local Functions:
local function reset()
    click_count = 0
    picked[1] = {x = 0, y = 0, color = {255 / 255, 255 / 255, 255 / 255, 1}}
    picked[2] = {x = 0, y = 0, color = {255 / 255, 255 / 255, 255 / 255, 1}}
end

local function centerText(str, strW, font)
    local ww, wh = love.graphics.getDimensions()
    return {
        w = ww / 2,
        h = wh / 2,
        strW = math.floor(strW / 2),
        fontH = math.floor(font:getHeight() / 2),
    }
end

-- Screen Shake Animation
local function cameraShake(duration, magnitude)
    trans, shakeDuration, shakeMagnitude = 0, duration or 1, magnitude or 5
end

------------------------------------------------------------------------------------------------------------

function game.load(game)
    local ww, wh = love.graphics.getDimensions()

    local title_font = game.fonts[1]

    title.font = game.fonts[1]
    title.text = "Connect The Dots"
    title.color = {0 / 255, 100 / 255, 0 / 255, 1}

    error_sound1 = love.audio.newSource(game.sounds.error)
    error_sound1:setVolume(.5)
    error_sound2 = love.audio.newSource(game.sounds.error)
    error_sound2:setVolume(.5)

    startPlayer = ( startPlayer + 1 ) % 2
    currentPlayer = startPlayer

    reset()
end

function game.draw(dt)

    -- Screen Shake Animation:
    if (trans < shakeDuration) then
        local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
        local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
        love.graphics.translate(dx, dy)
    end

    love.graphics.setFont(title.font)
    love.graphics.setColor(unpack(title.color))

    local strwidth = title.font:getWidth(title.text)
    local t = centerText(title, strwidth, title.font)
    love.graphics.print(title.text, t.w, t.h - 250, 0, 1, 1, t.strW, t.fontH)

    if (currentPlayer == 0) then
        love.graphics.setColor(127 / 255, 255 / 255, 127 / 255)
    else
        love.graphics.setColor(127 / 255, 127 / 255, 255 / 255)
    end
    love.graphics.print("PLAYER " .. tostring(currentPlayer + 1 ) .. "'s TURN", 440, 270, 0, 0.4, 0.4)

    love.graphics.setLineWidth(grid.line_width)
    love.graphics.setColor(255 / 255, 0 / 255, 0 / 255, 1)

    for y = 1, #grid do
        for x = 1, #grid[y] do

            local X = (x * grid.spacing) + (grid.x)
            local Y = (y * grid.spacing) + (grid.y)

            for k, _ in ipairs(picked) do
                local px, py = picked[k].x, picked[k].y
                local color = picked[k].color
                if (px == X and py == Y) then
                    love.graphics.setColor(unpack(color))
                    love.graphics.circle('fill', X, Y, grid.radius)
                end
            end

            local t = connected
            for i = 1, #connected do
                if (connected[i]) then
                    love.graphics.setLineWidth(1)
                    love.graphics.setColor(unpack(t[i].color))
                    love.graphics.line(t[i].x1, t[i].y1, t[i].x2, t[i].y2, 0, 0, 0, 0)
                end
            end

            love.graphics.setLineWidth(grid.line_width)
            love.graphics.setColor(255 / 255, 0 / 255, 0 / 255, 1)
            love.graphics.circle('line', X, Y, grid.radius)
        end
    end
end

function game.update(dt)
    if (click_count == 2) then
        currentPlayer = (currentPlayer + 1) % 2
        table.insert(connected, {
            x1 = picked[1].x,
            y1 = picked[1].y,
            x2 = picked[2].x,
            y2 = picked[2].y,
            color = {50 / 255, 255 / 255, 255 / 255, 1},
        })
        reset()
    end

    -- Screen Shake Animation:
    if (trans < shakeDuration) then
        trans = trans + dt
    end
end

function love.mousepressed()
    local point = HoverCheck()

    if (point) then
        click_count = click_count + 1
    end

    if (point) and (picked[click_count]) then
        picked[click_count].x = point.x
        picked[click_count].y = point.y
        picked[click_count].color = {0 / 255, 255 / 255, 0 / 255, 1}
        if alreadyConnected() then
            picked[2].x = 0
            picked[2].y = 0
            picked[2].color = {0 / 255, 255 / 255, 0 / 255, 1}
            click_count = click_count - 1
            table.remove(connected[#connected])
        end
    end
end

function game.keypressed(key)
    if (key == 'escape') then
        love.event.push('quit')
    end
end

function alreadyConnected()
    local t = connected
    local px1, px2, py1, py2 = picked[1].x, picked[2].x, picked[1].y, picked[2].y

    if (#t > 0) then
        for i = 1, #t do
            local X1, Y1, X2, Y2 = t[i].x1, t[i].y1, t[i].x2, t[i].y2
            if (px1 == X1 and py1 == Y1 and px2 == X2 and py2 == Y2) or
            (px1 == X2 and py1 == Y2 and px2 == X1 and py2 == Y1) then
                cameraShake(0.6, 2.5)
                if not error_sound1:isPlaying() then
                    error_sound1:play()
                elseif not error_sound2:isPlaying() then
                    error_sound2:play()
                end
                return true
            end
        end
    end
end

function HoverCheck()
    for y = 1, #grid do
        for x = 1, #grid[y] do

            local X = (x * grid.spacing) + (grid.x)
            local Y = (y * grid.spacing) + (grid.y)

            local function hovering(mx, my, x, y, r)
                if (mx - x) ^ 2 + (my - y) ^ 2 <= r then
                    return true
                end
            end

            local MouseX, MouseY = love.mouse.getPosition()
            local isHovering = hovering(MouseX, MouseY, X, Y, 100)

            if (isHovering) then
                return {x = X, y = Y}
            end
        end
    end
end

return game
