tp = require("tuplus")

if tp.canGpsOrientate() then
    tp.orientate()
else
    tp.orientate("manual")
end
local pos = tp.getPosition()
local fac = tp.getFacing()
print("Self Position: " .. pos:tostring())
print("Self Facing: " .. tp.facingToString(fac))
