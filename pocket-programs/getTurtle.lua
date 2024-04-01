rednet.open("back")

local offset = vector.new(0, -2, 0)

local x, y, z = gps.locate()
local myPosition = vector.new(x-0.5, y, z-0.5):round() + offset

local message = {
    sender = os.computerID(),
    destination = 1,
    content = myPosition
}

function sendMessage(message)
    rednet.send(7, message)
end

print(myPosition:tostring())
sendMessage(message)

rednet.close()
