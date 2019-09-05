-- Image Button Utility for Connect The Dots.
-- Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>

local imageButton = { }
local buttons = { }

function imageButton.new(Image, ID, X, Y, Alpha, Function)
    local imageWidth, imageHeight = Image:getDimensions()

    local function Add(a, b, c, d, e, f)
        local imageWidth, imageHeight = Image:getDimensions()
        return {
            image = a,
            id = b,
            x = c,
            y = d,
            width = imageWidth,
            height = imageHeight,
            alpha = e,
            fn = f,
            show = false,
            now = false,
            last = false,
        }
    end

    table.insert(buttons, Add(Image, ID, X, Y, Alpha, Function))
end

function imageButton.draw()
    for k, button in ipairs(buttons) do

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
                print(button.id)
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
