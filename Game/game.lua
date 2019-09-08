local game = { }
local GridModule = require('Game/board')
local board = require('Game/board-select-menu')
local imageButton = require('Game/image-button')

-- Game Tables:
local picked, connected = { }, { }
local title, buttons, bg = { }, { }, { }
local grid

local function startGame(size)
    grid = SetBoard(size)
    gamestate = "playing"
end

-- Local Variables:
local click_count = nil
local currentPlayer = 1
local startPlayer = currentPlayer

local button_click
local button_height, button_font = 100, nil
local trans, shakeDuration, shakeMagnitude = 0, - 1, 0

local smallPrintFont, aboutMsg

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

    -- Set initial game state:
    gamestate = "menu"

    title.font = game.fonts[1]
    title.text = "Connect The Dots"
    title.color = {0 / 255, 100 / 255, 0 / 255, 1}

    error_sound1 = love.audio.newSource(game.sounds.error)
    error_sound1:setVolume(.5)
    error_sound2 = love.audio.newSource(game.sounds.error)
    error_sound2:setVolume(.5)

    button_font = game.fonts[2]
    smallPrintFont = game.fonts[9]
    turnTextFont = game.fonts[10]

    aboutMsg = {
        {"Connect The Dots for Windows PC", 355},
        {"Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>", 370},
    }

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
        "Start Game",
        function()

            -- Player clicked "Start Game" without specifying board size.
            if (board_size == nil) then
                board_size = "3x3"
            end

            -- Create Pause Button:
            imageButton.new(
                game.images[7],
                'pause',
                10,
                10,
                0.3,
                function()
                    -- sidebar.show()
                    imageButton.hide("pause")

                    -- TEMP:
                    gamestate = "menu"
                end
            )
            imageButton.show('pause')
            ---------------------------------------------------

            -- Start Game:
            startGame(board_size)
        end)
    )
    table.insert(buttons, newButton(
        "Select Board",
        function()
            board.load(game)

            -- Create Back Button:
            imageButton.new(
                game.images[6],
                'return',
                10,
                10,
                0.3,
                function()
                    gamestate = "menu"
                    imageButton.hide("return")
                end
            )
            imageButton.show('return')
            ---------------------------------------------------
            -- Go To Scene:
            gamestate = "board-selection"
        end)
    )
    table.insert(buttons, newButton(
        "Settings",
        function()
            -- TO DO:
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

    if (gamestate == "playing" or gamestate == "menu") then
        love.graphics.setFont(title.font)
        love.graphics.setColor(unpack(title.color))
        local strwidth = title.font:getWidth(title.text)
        local t = centerText(title, strwidth, title.font)
        love.graphics.print(title.text, t.w, t.h - 290, 0, 1, 1, t.strW, t.fontH)
    end

    if (gamestate == "playing") then

        imageButton.draw()

        -- Screen Shake Animation:
        if (trans < shakeDuration) then
            local dx = love.math.random(-shakeMagnitude, shakeMagnitude)
            local dy = love.math.random(-shakeMagnitude, shakeMagnitude)
            love.graphics.translate(dx, dy)
        end

        --
        if (currentPlayer == 0) then
            love.graphics.setColor(127 / 255, 255 / 255, 127 / 255, 1)
        else
            love.graphics.setColor(127 / 255, 127 / 255, 255 / 255, 1)
        end

        love.graphics.setFont(turnTextFont)
        local x,y = grid.turn_text[1], grid.turn_text[2]
        love.graphics.print("PLAYER " .. tostring(currentPlayer + 1 ) .. "'s TURN", x, y, 0)
        --


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
                for i = 1, #t do
                    if (t[i]) then
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
    elseif (gamestate == "menu") then
        for k, v in ipairs(bg) do
            local X = bg[k][1]
            local Y = bg[k][2] - 100
            love.graphics.setLineWidth(3)
            love.graphics.setColor(255 / 255, 0 / 255, 0 / 255, 0.1)
            love.graphics.circle('line', X, Y, 5)
        end

        -- About Message:
        love.graphics.setFont(smallPrintFont)
        love.graphics.setColor(255/255, 255/255, 255/255, 1)

        for i = 1,#aboutMsg do

            local text = aboutMsg[i][1]
            local height = aboutMsg[i][2]

            local strwidth = smallPrintFont:getWidth(text)
            local t = centerText(text, strwidth, smallPrintFont)
            love.graphics.print(text, t.w, t.h + height, 0, 1, 1, t.strW, t.fontH)
        end


        RenderMenuButtons()
    elseif (gamestate == "board-selection") then
        board.draw()
        imageButton.draw()
    end
end

local timer = 0

function game.update(dt)

    -- Render Title regardless of game mode:
    if (gamestate == "playing" or gamestate == "menu") then
        timer = timer + dt
        if (timer >= 1) then
            timer = 0
            local r, g, b = love.math.random(0, 255), love.math.random(0, 255), love.math.random(0, 255)
            title.color = {r / 255, g / 255, b / 255}
        end
    end

    if (gamestate == "board-selection") then
        board.update(dt)
        imageButton.update(dt)
    end

    if (gamestate == "playing") then

        imageButton.update(dt)

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

function love.mousepressed(x, y, button, isTouch)
    board.mousepressed(x, y, button, isTouch)

    if (gamestate == "playing") then

        local point = intersecting(nil, nil, nil, nil, 11, true)

        if (point) then
            click_count = click_count + 1
        end

        if (point) and (picked[click_count]) then
            picked[click_count].x = point.x
            picked[click_count].y = point.y

            picked[click_count].row = point.row
            picked[click_count].col = point.col

            picked[click_count].color = {0 / 255, 255 / 255, 0 / 255, 1}
            if connectionError() then
                picked[2].x = 0
                picked[2].y = 0
                picked[2].color = {0 / 255, 255 / 255, 0 / 255, 1}
                picked[2].row = 0
                picked[2].col = 0
                click_count = click_count - 1
                if (#connected > 0) then
                    table.remove(connected[#connected])
                end
            end
        end
    end
end

function game.keypressed(key)
    if (key == 'escape') then
        love.event.push('quit')
    end
end

function fillSquare()
    local t = connected

    -- ROWS:
    for x = 1, #grid do
        -- COLS:
        for y = 1, #grid[x] do

            for i = 1, #t do
                if (t[i]) then

                end
            end

        end
    end
end

function connectionError()
    local t = connected
    local px1, px2, py1, py2 = picked[1].x, picked[2].x, picked[1].y, picked[2].y

    local pRow1, pCol1 = picked[1].row, picked[1].col
    local pRow2, pCol2 = picked[2].row, picked[2].col

    -- Check if move was diagional:
    local isDiagional = function()
        if (pRow1 ~= nil and pRow2 ~= nil and pCol1 ~= nil and pCol2 ~= nil) then
            if (pRow1 ~= pRow2) and (pCol1 ~= pCol2) then
                return true
            end
        end
    end

    -- Check if DotA == DotB:
    local isSelf = function()
        if (pRow1 == pRow2) and (pCol1 == pCol2) then
            return true
        end
    end

    -- Check if Point2 is too far Horizontally or Vertically.
    local tooFar = function()
        if (pRow1 ~= nil and pRow2 ~= nil and pCol1 ~= nil and pCol2 ~= nil) then
            if (pRow1 == pRow2) then
                if (pCol1 > (pCol2 + 1)) or (pCol1 < (pCol2 - 1)) then
                    return true
                end
            elseif (pCol1 == pCol2) then
                if (pRow1 > (pRow2 + 1)) or (pRow1 < (pRow2 - 1)) then
                    return true
                end
            end
        end
    end

    local function alertPlayer()
        cameraShake(0.6, 2.5)
        if not error_sound1:isPlaying() then
            error_sound1:play()
        elseif not error_sound2:isPlaying() then
            error_sound2:play()
        end
    end

    if isDiagional() or tooFar() or isSelf() then
        alertPlayer()
        return true
    end

    if (#t > 0) then
        for i = 1, #t do
            local X1, Y1, X2, Y2 = t[i].x1, t[i].y1, t[i].x2, t[i].y2
            local case1 = (px1 == X1 and py1 == Y1 and px2 == X2 and py2 == Y2)
            local case2 = (px1 == X2 and py1 == Y2 and px2 == X1 and py2 == Y1)
            if (case1) or (case2) then
                alertPlayer()
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
                return {x = x2, y = y2, row = y, col = x}
            end
        end
    end
end

function RenderMenuButtons()

    local ww, wh = love.graphics.getDimensions()

    local button_width = ww * (1 / 3)
    local margin = 24
    local total_height = (button_height + margin) * #buttons - 150
    local cursor_y = 0

    for _, button in ipairs(buttons) do
        button.last = button.now

        local bx = (ww * 0.5) - (button_width * 0.5)
        local by = (wh * 0.5) - (total_height * 0.5) + cursor_y

        local mx, my = love.mouse.getPosition()

        local hovering = (mx > bx) and (mx < bx + button_width) and
        (my > by) and (my < by + button_height)

        button.now = love.mouse.isDown(1)
        if (button.now and not button.last and hovering) then
            if (button.text ~= "Exit") and not button_click:isPlaying() then
                button_click:play()
            end
            button.fn()
        end

        local button_color = {}
        if (button.text == "Start Game") then
            button_color = { 255 / 255, 69 / 255, 0 / 255, 1 }
        elseif (button.text == "Select Board") then
            button_color = { 255 / 255, 215 / 255, 0 / 255, 1 }
        elseif (button.text == "Settings") then
            button_color = { 0 / 255, 128 / 255, 128 / 255, 1 }
        elseif (button.text == "Exit") then
            button_color = { 255 / 255, 0 / 255, 0 / 255, 1 }
        end

        local text_color = {255/255, 255/255, 255/255, 1}

        local curveX, curveY = 32,32
        local curveX2, curveY2 = 32,32
        if not (hovering) then
            love.graphics.setLineWidth(5)
            love.graphics.setColor(unpack(button_color))
        else
            love.graphics.setLineWidth(5)
            curveX, curveY = curveX + 45, curveY  + 45
            curveX2, curveY2 = curveX2 + 400, curveY2 + 400
            text_color = {0/255, 255/255, 0/255, 1}
            love.graphics.setColor(255/255, 255/255, 255/255, 1)
        end

        local xOff, yOff = 30, 30
        local textW = button_font:getWidth(button.text)
        local textH = button_font:getHeight(button.text)

        love.graphics.rectangle("line", bx, by, button_width, button_height, curveX, curveY)
        love.graphics.setColor(255/255, 255/255, 255/255, 0.1)
        love.graphics.rectangle("fill", bx + xOff/2 , by + yOff/2, button_width - xOff, button_height - xOff, curveX2, curveY2)

        -- Draw Dots between buttons ----------------------------------
        love.graphics.setColor(255/255, 255/255, 255/255, 1)
        love.graphics.setLineWidth(10)
        local x,y = 0,0
        local dotW, dotH = 225, 112
        if (button.text == "Start Game") then
            x, y = bx + dotW, by + dotH
            love.graphics.rectangle("line", x, y, 1, 1, 100, 100)
        elseif (button.text == "Select Board") then
            x, y = bx + dotW, by + dotH
            love.graphics.rectangle("line", x, y, 1, 1, 100, 100)
        elseif (button.text == "Settings") then
            x, y = bx + dotW, by + dotH
            love.graphics.rectangle("line", x, y, 1, 1, 100, 100)
        end
        ----------------------------------------------------------------

        love.graphics.setColor(unpack(text_color))
        love.graphics.print(button.text, button_font, (ww * 0.5) - textW * 0.5, by + textH * 0.5)
        cursor_y = cursor_y + (button_height + margin)
    end
end

return game
