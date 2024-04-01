tp = require("tuplus")

if #arg < 1 then
    return
end

local destiny = nil
if #arg == 3 then
    local x = tonumber(arg[1])
    local y = tonumber(arg[2])
    local z = tonumber(arg[3])
    destiny = vector.new(x, y, z)
end

tp.walkTo(destiny)

