local facing = 1
local position = vector.new(0, 0, 0)

local filename = "status.txt"
local file = io.open(filename, "w")

local content = textutils.serialize({facing = facing, position = position})

print(content)

file:write(content)
file:close()

