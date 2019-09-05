local board = { }
local backround
local buttons = { }
local ww, wh = 0,0

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

    table.insert(buttons, newImageButton(
        game.images[2],
        "3x3",
        100,
        100,
        pos1.width,
        pos1.height,
        function()
            board_size = "3x3"
        end
    ))
    table.insert(buttons, newImageButton(
        game.images[3],
        "5x5",
        250,
        100,
        pos2.width,
        pos2.height,
        function()
            board_size = "5x5"
        end
    ))
    table.insert(buttons, newImageButton(
        game.images[4],
        "7x7",
        700,
        100,
        pos3.width,
        pos3.height,
        function()
            board_size = "7x7"
        end
    ))
    table.insert(buttons, newImageButton(
        game.images[5],
        "9x9",
        900,
        100,
        pos4.width,
        pos4.height,
        function()
            board_size = "9x9"
        end
    ))
end

function board.draw()
    love.graphics.draw(background.image, background.x, background.y, 0)

    for _, button in ipairs(buttons) do
        button.last = button.now

        local bx = button.x
        local by = button.y

        local mx, my = love.mouse.getPosition()

        local hovering = (mx > bx) and (mx < bx + button.width) and (my > by) and (my < by + button.height)
        if (hovering) then
            love.graphics.setLineWidth(3)
            love.graphics.setColor(255/255, 255/255, 0/255, 1)
            love.graphics.rectangle("line", bx, by, button.width, button.height)
        else
            love.graphics.setColor(255/255, 255/255, 255/255, 0.5)
        end

        love.graphics.draw(button.image, bx, by, 0)
        button.now = love.mouse.isDown(1)
        if (button.now and not button.last and hovering) then
            button.fn()
        end
    end
end

return board
