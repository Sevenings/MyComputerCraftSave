local tp = require 'tuplus'

local args = {...}
local profundidade = tonumber(args[1]) or 64

local function digNext()
    tp.tryDig()
    tp.tryDigDown()
    tp.tryDigUp()
    tp.forward()
end


-- Aguardando sinal
while not redstone.getInput("left") do
    sleep(0.1)
end

-- Main
tp.tryDigUp()
tp.up()
for _ = 1, profundidade do
    digNext()
end
