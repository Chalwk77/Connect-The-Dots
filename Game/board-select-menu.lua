local board = { }
local backround
local buttons, title = { }, { }
local ww, wh = 0,0
local on_hover

local function centerText(str, strW, font)
    local ww, wh = love.graphics.getDimensions()
    return {
        w = ww / 2,
        h = wh / 2,
        strW = math.floor(strW / 2),
        fontH = math.floor(font:getHeight() / 2),
    }
end

function board.load(game)
    ww, wh = love.graphics.getDimensions()

    local function positionGraphic(image, X, Y)

        local width = math.floor(image:getWidth() / 2)
        local height = math.floor(image:getHeight() / 2)
        local posX = math.floor(ww / 2) - width
        local posY = math.floor(wh / 2) - height

        return {
            image = image,
            x = (posX + X),
            y = (posY + Y),
            width = imgW,
            height = imgH,
        }
    end

    -- Init Background:
    background = positionGraphic(game.images[1], 0, 0)

    -- Init Scene Title:
    title.font = game.fonts[1]
    title.text = "Select Board Size"
    title.color = {129 / 255, 100 / 255, 129 / 255, 1}

    on_hover1 = love.audio.newSource(game.sounds.on_hover)
    on_hover1:setVolume(.5)
    on_hover2 = love.audio.newSource(game.sounds.on_hover)
    on_hover2:setVolume(.5)

    local function newImageButton(image, size, x, y, width, height, fn)
        local imgW, imgH = image:getDimensions()
        return {
            image = image,
            size = size,
            x = x,
            y = y,
            width = imgW,
            height = imgH,
            fn = fn,
            now = false,
            last = false,
        }
    end

    local pos1 = positionGraphic(game.images[2], 0, 0)
    local pos2 = positionGraphic(game.images[3], 0, 0)
    local pos3 = positionGraphic(game.images[4], 0, 0)
    local pos4 = positionGraphic(game.images[5], 0, 0)

    local screenY = 350

    table.insert(buttons, newImageButton(
        game.images[2],
        "3x3",
        50,
        screenY,
        pos1.width,
        pos1.height,
        function()
            board_size = "3x3"
        end
    ))
    table.insert(buttons, newImageButton(
        game.images[3],
        "5x5",
        270,
        screenY,
        pos2.width,
        pos2.height,
        function()
            board_size = "5x5"
        end
    ))
    table.insert(buttons, newImageButton(
        game.images[4],
        "7x7",
        570,
        screenY,
        pos3.width,
        pos3.height,
        function()
            board_size = "7x7"
        end
    ))
    table.insert(buttons, newImageButton(
        game.images[5],
        "9x9",
        950,
        screenY,
        pos4.width,
        pos4.height,
        function()
            board_size = "9x9"
        end
    ))
end

function board.draw()

    -- Display background image and set background alpha:
    love.graphics.setColor(255/255,255/255,255/255,1)
    love.graphics.draw(background.image, background.x, background.y, 0)

    -- Display Scene Title:
    love.graphics.setFont(title.font)
    love.graphics.setColor(unpack(title.color))
    local strwidth = title.font:getWidth(title.text)
    local t = centerText(title, strwidth, title.font)
    love.graphics.print(title.text, t.w, t.h - 290, 0, 1, 1, t.strW, t.fontH)

    for _, button in ipairs(buttons) do
        button.last = button.now

        local bx = button.x
        local by = button.y

        local mx, my = love.mouse.getPosition()
        local hovering = (mx > bx) and (mx < bx + button.width) and (my > by) and (my < by + button.height)
        if (hovering) then
            love.graphics.setLineWidth(3)
            love.graphics.setColor(255/255, 255/255, 255/255, 1)
            love.graphics.rectangle("line", bx, by, button.width, button.height, 12,12)
        else
            love.graphics.setColor(255/255, 255/255, 255/255, 0.3)
        end

        love.graphics.draw(button.image, bx, by, 0)
        button.now = love.mouse.isDown(1)
        if (button.now and not button.last and hovering) then
            if not on_hover1:isPlaying() then
                on_hover1:play()
            elseif not on_hover2:isPlaying() then
                on_hover2:play()
            end
            button.fn()
        end
        love.graphics.print(button.size, bx, by - 100)
    end
end

return board
