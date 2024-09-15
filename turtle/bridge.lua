local tp = require "tuplus"

local length = arg[1]
if not length then
    length = 64
end

local fazerCorrimao = arg[2]
if not fazerCorrimao then
    fazerCorrimao = False
end

function buildCorrimao()
    tp.turnLeft()
    tp.place()
    tp.turnRight()
    tp.turnRight()
    tp.place()
    tp.turnLeft()
end

for i=1, length do
    tp.tryDig()
    tp.tryDigUp()
    tp.placeDown()
    if fazerCorrimao then
        buildCorrimao()
    end
    tp.forward()
end
