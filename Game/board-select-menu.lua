local board = { }
local backround
local buttons = { }

function board.load(game)
    local ww,wh = love.graphics.getDimensions()

    local function positionGraphic(image, X, Y)

        local posX = math.floor(ww/2) - math.floor(image:getWidth()/2)
        local posY = math.floor(wh/2) - math.floor(image:getHeight()/2)
        return {
            image = image,
            x = (posX + X),
            y = (posY + Y),
        }
    end

    -- Init Background:
    background = positionGraphic(game.images[1], 0, 0)


    local function newImageButton(image, size, fn)
        return {
            image = image,
            size = size,
            fn = fn,
            now = false,
            last = false,
        }
    end

    table.insert(buttons, newImageButton(game.images[2], "3x3", function() board_size = "3x3"end))
    table.insert(buttons, newImageButton(game.images[3], "5x5", function() board_size = "5x5"end))
    table.insert(buttons, newImageButton(game.images[4], "7x7", function() board_size = "7x7"end))
    table.insert(buttons, newImageButton(game.images[5], "9x9", function() board_size = "9x9"end))
end

function board.draw()
    love.graphics.draw(background.image, background.x, background.y, 0)

    local ww, wh = love.graphics.getDimensions()
    local spaces = 50
    local spacing = (spaces) * #buttons

    for _, button in ipairs(buttons) do
        button.last = button.now

        local bx = (ww * 0.5) - (button_width * 0.5)
        local by = (wh * 0.5)

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


        local curveX, curveY = 32,32
        if not (hovering) then
            print('hovering!')
        else
            curveX, curveY = curveX + 45, curveY  + 45
            text_color = {0/255, 255/255, 0/255, 1}
            love.graphics.setColor(255/255, 255/255, 255/255, 1)
        end

        love.graphics.draw(buttons.image, bx, by, 0)

        local textW = button_font:getWidth(button.text)
        local textH = button_font:getHeight(button.text) - 10

        love.graphics.setColor(unpack(text_color))
        love.graphics.print(button.text, button_font, (ww * 0.5) - textW * 0.5, by + textH * 0.5)
        cursor_y = cursor_y + (button_height + margin)
    end
end

function board.update()

end

function board.select()

end

return board
