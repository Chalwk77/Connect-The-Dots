-- Image Button Utility for Connect The Dots.
-- Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>

local imageButton = { }
local buttons = { }

function imageButton.load(game)
    local function newImageButton(image, id, x, y, show, alpha, fn)
        local imageWidth, imageHeight = image:getDimensions()
        return {
            image = image,
            id = id,
            x = x,
            y = y,
            width = imageWidth,
            height = imageHeight,
            show = show,
            alpha = alpha,
            fn = fn,
            now = false,
            last = false,
        }
    end

    -- Back Button:
    table.insert(buttons, newImageButton(
        game.images[6],
        "return",
        10,
        10,
        false, -- Default Visibility
        0.3, -- Default Alpha
        function()
            imageButton.hide("return")
        end
    ))

end

function imageButton.draw()
    for _, button in ipairs(buttons) do
        if (button.show) then
            button.last = button.now

            local bx = button.x
            local by = button.y

            -- Returns Mouse X,Y world coordinates:
            local mx, my = love.mouse.getPosition()

            -- Returns True if the mouse is hovering over a button image:
            local hovering = (mx > bx) and (mx < bx + button.width) and (my > by) and (my < by + button.height)

            -- Draw rectangle around image:
            if (hovering) then
                love.graphics.setLineWidth(3)
                love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
                love.graphics.rectangle("line", bx, by, button.width, button.height, 12, 12)
            else
                -- Set default button color & alpha.
                love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, button.alpha)
            end

            -- Draw Button Image:
            love.graphics.draw(button.image, bx, by, 0)

            -- Check if button has been clicked -> Execute button function.
            button.now = love.mouse.isDown(1)
            if (button.now and not button.last and hovering) then
                button.fn()
            end
        end
    end
end

function imageButton.show(id)
    for key, button in ipairs(buttons) do
        if (button.id == id) then
            button.show = true
        end
    end
end

function imageButton.hide(id)
    for key, button in ipairs(buttons) do
        if (button.id == id) then
            button.show = false
        end
    end
end

function imageButton.update(dt)

end

return imageButton
