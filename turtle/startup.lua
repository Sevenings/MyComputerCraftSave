tp = require("tuplus")

tp.orientate()
local pos = tp.getPosition()
local fac = tp.getFacing()
print("Self Position: " .. pos:tostring())
print("Self Facing: " .. tp.facingToString(fac))
