-- Grid Lock Prototype for Connect The Dots
-- Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>

local gridlock = { }

local function Check(pos)
    local pos = pos or { }
    if (pos.a == 1 and pos.b == 1 and pos.c == 1 and pos.d == 1) or
        (pos.a == 1 and pos.b == 1 and pos.c == 1 and pos.d == 2) or
        (pos.a == 1 and pos.b == 2 and pos.c == 1 and pos.d == 1) or
        (pos.a == 2 and pos.b == 1 and pos.c == 1 and pos.d == 1) or
        (pos.a == 1 and pos.b == 1 and pos.c == 2 and pos.d == 2) or
        (pos.a == 1 and pos.b == 2 and pos.c == 1 and pos.d == 2) or
        (pos.a == 1 and pos.b == 2 and pos.c == 2 and pos.d == 1) or
        (pos.a == 2 and pos.b == 1 and pos.c == 1 and pos.d == 2) or
        (pos.a == 2 and pos.b == 2 and pos.c == 1 and pos.d == 1) or
        (pos.a == 2 and pos.b == 1 and pos.c == 2 and pos.d == 1) or
        (pos.a == 2 and pos.b == 2 and pos.c == 2 and pos.d == 1) or
        (pos.a == 2 and pos.b == 2 and pos.c == 1 and pos.d == 2) or
        (pos.a == 2 and pos.b == 1 and pos.c == 2 and pos.d == 2) or
        (pos.a == 2 and pos.b == 2 and pos.c == 2 and pos.d == 2) or
        (pos.a == 1 and pos.b == 2 and pos.c == 2 and pos.d == 2) then
        print('match -> ' .. pos.id, 2+8)
        return true
    end
end

function gridlock.check(params)
    local params = params or { }

    local grid = params.grid
    local row,col = params.picked[2].x, params.picked[2].y

    local position = {}

    for x = 1, #grid do
        for y = 1, #grid[x] do

            if (col == 1) then
                if (row == 1) then
                    position["Top Left"] = {
                        a = grid[row][col],
                        b = grid[row][col + 1],
                        c = grid[row + 1][col],
                        d = grid[row + 1][col + 1],
                        id = "Top Left"
                    }
                elseif (row == #grid) then
                    position["Top Right"] = {
                        a = grid[row][col],
                        b = grid[row][col - 1],
                        c = grid[row + 1][col],
                        d = grid[row + 1][col - 1],
                        id = "Top Right"
                    }
                end
            elseif (col == #grid[x]) then
                if (row == 1) then
                    position["Bottom Left"] = {
                        a = grid[row][col],
                        b = grid[row][col + 1],
                        c = grid[row - 1][col],
                        d = grid[row - 1][col + 1],
                        id = "Bottom Left"
                    }
                elseif (row == #grid) then
                    position["Bottom Right"] = {
                        a = grid[row][col],
                        b = grid[row][col - 1],
                        c = grid[row - 1][col],
                        d = grid[row][col - 1],
                        id = "Bottom Right"
                    }
                end

            elseif (col > 1 and col < #grid[x]) then
                if (row == 1) then
                    position["alt 1"] = {
                        a = grid[row][col],
                        b = grid[row][col + 1],
                        c = grid[row + 1][col],
                        d = grid[row + 1][col + 1],
                        id = "alt 1"
                    }
                    position["alt 2"] = {
                        a = grid[row][col],
                        b = grid[row][col - 1],
                        c = grid[row + 1][col],
                        d = grid[row + 1][col - 1],
                        id = "alt 2"
                    }
                elseif (row == #grid) then
                    position["alt 3"] = {
                        a = grid[row][col],
                        b = grid[row][col + 1],
                        c = grid[row - 1][col],
                        d = grid[row - 1][col + 1],
                        id = "alt 3"
                    }
                    position["alt 4"] = {
                        a = grid[row][col],
                        b = grid[row][col - 1],
                        c = grid[row - 1][col],
                        d = grid[row - 1][col - 1],
                        id = "alt 4"
                    }
                else
                    position["Middle Class 1"] = {
                        a = grid[row][col],
                        b = grid[row][col + 1],
                        c = grid[row + 1][col],
                        d = grid[row + 1][col + 1],
                        id = "Middle Class 1"
                    }
                    position["Middle Class 2"] = {
                        a = grid[row][col],
                        b = grid[row][col - 1],
                        c = grid[row + 1][col],
                        d = grid[row + 1][col - 1],
                        id = "Middle Class 2"
                    }
                    position["Middle Class 3"] = {
                        a = grid[row][col],
                        b = grid[row][col + 1],
                        c = grid[row - 1][col],
                        d = grid[row - 1][col + 1],
                        id = "Middle Class 3"
                    }
                    position["Middle Class 4"] = {
                        a = grid[row][col],
                        b = grid[row][col - 1],
                        c = grid[row - 1][col],
                        d = grid[row][col - 1],
                        id = "Middle Class 4"
                    }
                end
            end
        end
    end

    for k, _ in pairs(position) do
        if (k) then
            local connection = Check(position[k])
            if (connection) then
                return true
            end
        end
    end
end

return gridlock
