-- Grid Lock Prototype for Connect The Dots
-- Copyright (c) 2019, Jericho Crosby <jericho.crosby227@gmail.com>

local gridlock = { }

function gridlock.Check(params)
    local params = params or { }

    local grid = params.grid
    local row,col = params.row, params.col

    local captured = {}
    
        
    local x, y = row, col -- current row & column
    local capture = { }
    
    -- TOP LEFT CORNER
    if (x == 1 and y == 1) then
        capture["Arrangement 1"] = {
            a = grid[x][y],
            b = grid[x][y + 1],
            c = grid[x + 1][y],
            d = grid[x + 1][y + 1]
        }
    -- TOP RIGHT CORNER
    elseif (x == 1 and y == #grid[y]) then
        capture["Arrangement 2"] = {
            a = grid[x][y],
            b = grid[x][y - 1],
            c = grid[x + 1][y],
            d = grid[x + 1][y - 1]
        }
    -- BOTTOM LEFT CORNER
    elseif (x == #grid and y == 1) then
        capture["Arrangement 3"] = {
            a = grid[x][y],
            b = grid[x][y + 1],
            c = grid[x - 1][y],
            d = grid[x - 1][y + 1]
        }
    -- BOTTOM RIGHT CORNER
    elseif (x == #grid and y == #grid[y]) then
        capture["Arrangement 4"] = {
            a = grid[x][y],
            b = grid[x][y - 1],
            c = grid[x - 1][y],
            d = grid[x - 1][y - 1]
        }
    elseif (y > 1 and y < #grid[x]) then
        if (x >= 1 and x < #grid) then
            capture["Arrangement 5"] = { -- Facing Right
                a = grid[x][y],
                b = grid[x][y + 1],
                c = grid[x + 1][y],
                d = grid[x + 1][y + 1]
            }
            capture["Arrangement 6"] = { -- Facing Left
                a = grid[x][y],
                b = grid[x][y - 1],
                c = grid[x + 1][y],
                d = grid[x + 1][y - 1]
            }
        elseif (x == #grid) then
            capture["Arrangement 7"] = {
                a = grid[x][y],
                b = grid[x][y + 1],
                c = grid[x - 1][y],
                d = grid[x - 1][y + 1]
            }
            capture["Arrangement 8"] = {
                a = grid[x][y],
                b = grid[x][y - 1],
                c = grid[x - 1][y],
                d = grid[x - 1][y - 1]
            }
        end
    end
    
    for k,_ in pairs(tab) do                
        if (k) and (#tab[k].a == 2 and #tab[k].b == 2 and #tab[k].c == 2 and #tab[k].d == 2) then
            return true, print(k)
        end
        return false
    end

end

return gridlock
