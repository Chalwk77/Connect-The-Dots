local game = { }
game.state = "menu"

-- Game Tables:
local grid, picked, connected = { }, { }, { }
local title, buttons, bg = { }, { }, { }
local function initGrid(stage)
    grid = {

        x = 385, -- Grid X Coordinate
        y = 230, -- Grid Y Coordinate

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
    game.state = "playing"
end

-- Local Variables:
local click_count = nil
local currentPlayer = 1
local startPlayer = currentPlayer

local button_click
local button_height, button_font = 64, nil
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

local function StartGame()
    initGrid()
end

function game.load(game)
    local ww, wh = love.graphics.getDimensions()

    title.font = game.fonts[1]
    title.text = "Connect The Dots"
    title.color = {0 / 255, 100 / 255, 0 / 255, 1}
    title.credits = {
        font = game.fonts[3],
        text = {
            "Connect The Dots (Windows, Android, iOS)",
            "Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>"
        },
    }

    error_sound1 = love.audio.newSource(game.sounds.error)
    error_sound1:setVolume(.8)
    error_sound2 = love.audio.newSource(game.sounds.error)
    error_sound2:setVolume(.8)

    button_font = game.fonts[2]

    startPlayer = ( startPlayer + 1 ) % 2
    currentPlayer = startPlayer

    for y = 1, 50 do
        for x = 1, 50 do
            local X = (x * 32)
            local Y = (y * 32)
            table.insert(bg, {X, Y})
        end
    end

    ------------------ CREATE MENU BUTTONS ------------------
    local function newButton(text, fn)
        return {
            text = text,
            fn = fn,
            now = false,
            last = false,
        }
    end

    button_click = love.audio.newSource(game.sounds.button_click)
    table.insert(buttons, newButton(
        "Start",
        function()
            StartGame()
        end)
    )
    table.insert(buttons, newButton(
        "Exit",
        function()
            love.event.quit(0)
        end)
    )

    reset()
end

function game.draw(dt)

    -- Render Title regardless of gamemode.
    if (game.state == "menu" or game.state == "playing") then
        love.graphics.setFont(title.font)
        love.graphics.setColor(unpack(title.color))
        local strwidth = title.font:getWidth(title.text)
        local t = centerText(title, strwidth, title.font)
        love.graphics.print(title.text, t.w, t.h - 290, 0, 1, 1, t.strW, t.fontH)
    end

    if (game.state == "playing") then
        -- Screen Shake Animation:
        if (trans < shakeDuration) then
            local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
            local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
            love.graphics.translate(dx, dy)
        end

        if (currentPlayer == 0) then
            love.graphics.setColor(127 / 255, 255 / 255, 127 / 255)
        else
            love.graphics.setColor(127 / 255, 127 / 255, 255 / 255)
        end
        love.graphics.print("PLAYER " .. tostring(currentPlayer + 1 ) .. "'s TURN", 440, 230, 0, 0.4, 0.4)

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


                local MX, MY = love.mouse.getPosition()
                if intersecting(MX, MY, X, Y, 11, false) then
                    love.graphics.setLineWidth(grid.line_width + 1.5)
                    love.graphics.setColor(230 / 255, 230 / 255, 250 / 255, 1)
                else
                    love.graphics.setLineWidth(grid.line_width)
                    love.graphics.setColor(255 / 255, 0 / 255, 0 / 255, 1)
                end

                love.graphics.circle('line', X, Y, grid.radius)
            end
        end
    else

        -- Render dotted background:
        for k, v in ipairs(bg) do
            local X = bg[k][1]
            local Y = bg[k][2] - 100
            love.graphics.setLineWidth(3)
            love.graphics.setColor(255 / 255, 0 / 255, 0 / 255, 0.2)
            love.graphics.circle('line', X, Y, 2)
        end

        -- Render Start Menu:
        RenderMenuButtons()

        -- Display Copyright:
        local font = title.credits.font
        local text = title.credits.text

        love.graphics.setFont(font)
        love.graphics.setColor(192 / 255, 192 / 255, 192 / 255, 1)

        local height, spacing = 350, 20
        for i = 1,#text do
            local strwidth = font:getWidth(text[i])
            local t = centerText(text[i], strwidth, font)
            love.graphics.print(text[i], t.w, t.h + height, 0, 1, 1, t.strW, t.fontH)
            height = height + spacing
        end
    end
end

local timer = 0
function game.update(dt)

    -- Randomize Title Color every 1 second:
    if (game.state == "menu" or game.state == "playing") then
        timer = timer + dt
        if (timer >= 1) then
            timer = 0
            local r, g, b = love.math.random(0, 255), love.math.random(0, 255), love.math.random(0, 255)
            title.color = {r / 255, g / 255, b / 255}
        end
    end

    if (game.state == "playing") then

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
end

function love.mousepressed()
    if (game.state == "playing") then
        local point = intersecting(nil, nil, nil, nil, 11, true)

        if (point) then
            click_count = click_count + 1
        end

        if (point) and (picked[click_count]) then
            picked[click_count].x = point.x
            picked[click_count].y = point.y
            picked[click_count].color = {0 / 255, 255 / 255, 0 / 255, 1}
            if connectionError() then
                picked[2].x = 0
                picked[2].y = 0
                picked[2].color = {0 / 255, 255 / 255, 0 / 255, 1}
                click_count = click_count - 1
                table.remove(connected[#connected])
            end
        end
    end
end

function game.keypressed(key)
    if (key == 'escape') then
        love.event.push('quit')
    end
end

function connectionError()
    local t = connected
    local px1, px2, py1, py2 = picked[1].x, picked[2].x, picked[1].y, picked[2].y

    if (#t > 0) then
        for i = 1, #t do
            local X1, Y1, X2, Y2 = t[i].x1, t[i].y1, t[i].x2, t[i].y2

            -- Check if this move has already been occupied:
            if (px1 == X1 and py1 == Y1 and px2 == X2 and py2 == Y2) or
            (px1 == X2 and py1 == Y2 and px2 == X1 and py2 == Y1) or intersecting(px1, py1, px2, py2, 11, false) then
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

local function hovering(x1, y1, x2, y2, r)
    local x_diff = x1 - x2
    local y_diff = y1 - y2
    local dist = math.sqrt(x_diff ^ 2 + y_diff ^ 2)
    if (dist <= r) then
        return true
    end
    return false
end

function intersecting(x1, y1, x2, y2, radius, bool)
    for y = 1, #grid do
        for x = 1, #grid[y] do

            if (bool) then
                x2 = (x * grid.spacing) + (grid.x)
                y2 = (y * grid.spacing) + (grid.y)
                x1, y1 = love.mouse.getPosition()
            end

            local intersect = hovering(x1, y1, x2, y2, radius)
            if (intersect) and not (bool) then
                return true
            elseif (intersect) and (bool) then
                return {x = x2, y = y2}
            end
        end
    end
end

function RenderMenuButtons()

    local ww, wh = love.graphics.getDimensions()

    local button_width = ww * (1 / 3)
    local margin = 16
    local total_height = (button_height + margin) * #buttons
    local cursor_y = 0

    for _, button in ipairs(buttons) do
        button.last = button.now

        local bx = (ww * 0.5) - (button_width * 0.5)
        local by = (wh * 0.5) - (total_height * 0.5) + cursor_y

        local color = {30 / 255, 150 / 255, 150 / 255, 1}
        local mx, my = love.mouse.getPosition()

        local hovering = (mx > bx) and (mx < bx + button_width) and
        (my > by) and (my < by + button_height)

        if (hovering) then
            if (button.text == "Start") then
                color = { 0 / 255, 120 / 255, 0 / 255, 1 }
            elseif (button.text == "Exit") then
                color = { 255, 0 / 255, 0 / 255, 1 }
            end
        end

        button.now = love.mouse.isDown(1)
        if (button.now and not button.last and hovering) then
            if (button.text ~= "Exit") and not button_click:isPlaying() then
                button_click:play()
            end
            button.fn()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle("fill", bx, by, button_width, button_height, 64, 64)

        local textW = button_font:getWidth(button.text)
        local textH = button_font:getHeight(button.text)

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(button.text, button_font, (ww * 0.5) - textW * 0.5, by + textH * 0.5)
        cursor_y = cursor_y + (button_height + margin)
    end
end

return game
