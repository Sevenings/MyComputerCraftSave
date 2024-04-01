tp = require("tuplus")

print(arg[1])

if arg[1] == "-m" then
    orientate("manual")
else 
    orientate()
end

local position = getPosition():tostring()
local facing = facingToString(getFacing())

print("Self Position: (".. position..")")
print("Self Facing: "..facing)

