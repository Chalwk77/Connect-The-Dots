-- Grid Lock Prototype for Connect The Dots
-- Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>

local gridlock = { }

function gridlock.Check(params)
    local params = params or { }
    local capture = { }

    local grid = params.grid
    local x, y = params.row, params.col -- current row & column

    -- TOP LEFT CORNER
    if (x == 1 and y == 1) then
        capture["Arrangement 1"] = {
            a = grid[x][y],
            b = grid[x][y + 1],
            c = grid[x + 1][y],
            d = grid[x + 1][y + 1],
            coords = {x = (x), y = (y)}
        }
        -- TOP RIGHT CORNER
    elseif (x == 1 and y == #grid[x]) then
        capture["Arrangement 2"] = {
            a = grid[x][y],
            b = grid[x][y - 1],
            c = grid[x + 1][y],
            d = grid[x + 1][y - 1],
            coords = {x = (x), y = (y)}
        }
        -- BOTTOM LEFT CORNER
    elseif (x == #grid and y == 1) then
        capture["Arrangement 3"] = {
            a = grid[x][y],
            b = grid[x][y + 1],
            c = grid[x - 1][y],
            d = grid[x - 1][y + 1],
            coords = {x = (x), y = (y)}
        }
        -- BOTTOM RIGHT CORNER
    elseif (x == #grid and y == #grid[x]) then
        capture["Arrangement 4"] = {
            a = grid[x][y],
            b = grid[x][y - 1],
            c = grid[x - 1][y],
            d = grid[x - 1][y - 1],
            coords = {x = (x - 1), y = (y - 1)}
        }
    elseif (y > 1 and y < #grid[x]) then
        if (x >= 1 and x < #grid) then
            capture["Arrangement 5"] = { -- Facing Right
                a = grid[x][y],
                b = grid[x][y + 1],
                c = grid[x + 1][y],
                d = grid[x + 1][y + 1],
                coords = {x = (x - 1), y = (y - 1)}
            }
            capture["Arrangement 6"] = { -- Facing Left
                a = grid[x][y],
                b = grid[x][y - 1],
                c = grid[x + 1][y],
                d = grid[x + 1][y - 1],
                coords = {x = (x - 1), y = (y - 1)}
            }
        elseif (x == #grid) then
            capture["Arrangement 7"] = {
                a = grid[x][y],
                b = grid[x][y + 1],
                c = grid[x - 1][y],
                d = grid[x - 1][y + 1],
                coords = {x = (x - 1), y = (y - 1)}
            }
            capture["Arrangement 8"] = {
                a = grid[x][y],
                b = grid[x][y - 1],
                c = grid[x - 1][y],
                d = grid[x - 1][y - 1],
                coords = {x = (x - 1), y = (y - 1)}
            }
        end
    end

    local c = capture
    for k, _ in pairs(c) do
        if (k) and (#c[k].a == 2 and #c[k].b == 2 and #c[k].c == 2 and #c[k].d == 2) then
            return c[k].coords, print(k)
        end
        return false
    end

end

return gridlock
