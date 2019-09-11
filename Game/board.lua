-- Grid Setup Utility for Connect The Dots.
-- Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>

function SetBoard(size)
    local grid = { }
    if (size == "3x3") then
        grid = {
            x = 550,
            y = 230,
            spacing = 64,
            radius = 5,
            line_width = 2,
            turn_text = {550 + 60, 230 + 20},
            {0, 0, 0},
            {0, 0, 0},
            {0, 0, 0},
        }
    elseif (size == "5x5") then
        grid = {
            x = 485,
            y = 230,
            spacing = 64,
            radius = 5,
            line_width = 2,
            turn_text = {485 + 60, 230 + 20},
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0}
        }
    elseif (size == "7x7") then
        grid = {
            x = 420,
            y = 230,
            spacing = 64,
            radius = 5,
            line_width = 2,
            turn_text = {420 + 60, 230 + 20},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0}
        }
    elseif (size == "9x9") then
        grid = {
            x = 360,
            y = 150,
            spacing = 64,
            radius = 5,
            line_width = 2,
            turn_text = {360 + 60, 150 + 20},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0}
        }
    end
    return grid
end
