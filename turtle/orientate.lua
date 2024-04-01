tp = require("tuplus")

print("Orientation Protocol:")
print("Arguments: "..arg[1])

if arg[1] == "-m" then
    tp.orientate("manual")
else 
    if tp.canGpsOrientate() then
        print("GPS orientation available")
    else
        print("GPS orientation not available")
        print("Realizando orientação manual...")
        print("Going for manual orientation")
    end
    tp.orientate()
end

local position = tp.getPosition():tostring()
local facing = tp.facingToString(tp.getFacing())

print("Self Position: (".. position..")")
print("Self Facing: "..facing)

