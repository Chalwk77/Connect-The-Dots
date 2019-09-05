local board = { }
local backround

function board.load(game)
    local ww,wh = love.graphics.getDimensions()

    local function positionGraphic(image, X, Y)
        local x = math.floor(ww/2) - math.floor(image:getWidth()/2)
        local y = math.floor(wh/2) - math.floor(image:getHeight()/2)
        return {
            image = image,
            x = x,
            y = y,
        }
    end

    -- Init Background:
    background = positionGraphic(game.images[1], 250, 50)
end

function board.draw()
    love.graphics.draw(background.image, background.x, background.y, 0)
end

function board.update()

end

function board.select()

end

return board
