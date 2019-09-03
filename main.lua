-- Connect The Dots (prototype version 1.0)
-- Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>
--===============================================================--
local picked, connected = {}, {}
local grid = {

    x = 120, -- Grid X Coordinate
    y = 70, -- Grid Y Coordinate

    spacing = 64, -- Spacing between dots

    radius = 5, -- Circle radius

    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 1
    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 2
    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 3
    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 4
    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 5
    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 6
    {0, 0, 0, 0, 0, 0, 0, 0}, -- Row 7
}

local click_count, title = nil, { }

local function reset()
    click_count = 0
    picked[1] = {x = 0, y = 0, color = {255 / 255, 255 / 255, 255 / 255, 1}}
    picked[2] = {x = 0, y = 0, color = {255 / 255, 255 / 255, 255 / 255, 1}}
end

local function centerText(str, strW, font)
    local ww,wh = love.graphics.getDimensions()
    return {
        w = ww/2,
        h = wh/2,
        strW = math.floor(strW/2),
        fontH = math.floor(font:getHeight()/2),
    }
end

function love.load()
    reset()
    title.font = love.graphics.newFont('Assets/fonts/dotted_font.ttf', 64)
    title.text = "Connect The Dots"
    title.color = {0 / 255, 100 / 255, 0 / 255, 1}
end

function love.draw()

    love.graphics.setFont(title.font)
    love.graphics.setColor(unpack(title.color))

    local strwidth = title.font:getWidth(title.text)
    local t = centerText(title, strwidth, title.font)
    love.graphics.print(title.text, t.w, t.h - 250, 0, 1, 1, t.strW, t.fontH)

    love.graphics.setLineWidth(5)
    love.graphics.setColor(255 / 255, 0 / 255, 0 / 255, 1)

    for y = 1, #grid do
        for x = 1, #grid[y] do

            local X = (x * grid.spacing) + (grid.x)
            local Y = (y * grid.spacing) + (grid.y)

            for k, v in ipairs(picked) do
                local dotX = picked[k].x
                local dotY = picked[k].y
                local color = picked[k].color
                if (dotX == X and dotY == Y) then
                    love.graphics.setColor(unpack(color))
                    love.graphics.circle('fill', X, Y, grid.radius * 2)
                end
            end

            local tab = connected
            for i = 1, #tab do
                if (tab[i]) then
                    love.graphics.setColor(unpack(tab[i].color))
                    love.graphics.line(tab[i].x1, tab[i].y1, tab[i].x2, tab[i].y2, 0, 0, 0, 0)
                end
            end
            love.graphics.setColor(255 / 255, 0 / 255, 0 / 255, 1)
            love.graphics.circle('line', X, Y, grid.radius)
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

function love.update()
    if (click_count == 2) then
        table.insert(connected, {
            x1 = picked[1].x,
            y1 = picked[1].y,
            x2 = picked[2].x,
            y2 = picked[2].y,
            color = {50 / 255, 255 / 255, 255 / 255, 1},
        })
        reset()
    end
end

function love.keypressed(key)
    if (key == 'escape') then
        love.event.push('quit')
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
    end
end
