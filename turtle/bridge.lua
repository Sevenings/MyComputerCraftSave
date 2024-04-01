require "tuplus"

local length = arg[1]
if not length then
    length = 64
end

local fazerCorrimao = arg[2]
if not fazerCorrimao then
    fazerCorrimao = False
end

function buildCorrimao()
    turnLeft()
    place()
    turnRight()
    turnRight()
    place()
    turnLeft()
end

for i=1, length do
    tryDig()
    tryDigUp()
    placeDown()
    if fazerCorrimao then
        buildCorrimao()
    end
    forward()
end