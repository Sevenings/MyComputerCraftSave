local tp = require("tuplus")

local INITIAL_DIRECTION = arg[1]
if INITIAL_DIRECTION == nil then
    INITIAL_DIRECTION = "forward"
end

local RETURN_START = arg[2]
if RETURN_START == nil then
    RETURN_START = false
end



local found_blocks = {}
local reference = nil
if INITIAL_DIRECTION == "forward" then
    _, reference = turtle.inspect()
elseif INITIAL_DIRECTION == "up" then
    _, reference = turtle.inspectUp()
elseif INITIAL_DIRECTION == "down" then
    _, reference = turtle.inspectDown()
end
print("Searching for "..reference.name)

function map(block_pos)
    for i,v in ipairs(found_blocks) do
        if block_pos:equals(v) then
            return
        end
    end
    table.insert(found_blocks, block_pos)
end

function mapBlockForward()
	local hasBlock, blockInfo = turtle.inspect()
	if blockInfo.name == reference.name then
		local block_pos = tp.getPosition() + tp.facingToVector(tp.getFacing())
		map(block_pos)
	end
end

function mapBlockUp()
	local hasBlock, blockInfo = turtle.inspectUp()
	if blockInfo.name == reference.name then
		local block_pos = tp.getPosition() + vector.new(0, 1, 0)
        map(block_pos)
	end
end

function mapBlockDown()
	local hasBlock, blockInfo = turtle.inspectDown()
	if blockInfo.name == reference.name then
		local block_pos = tp.getPosition() + vector.new(0, -1, 0)
        map(block_pos)
	end
end

function mapAround()
	for i=1, 4 do
		mapBlockForward()
		tp.turnRight()
	end
    mapBlockUp()
    mapBlockDown()
end

function show()
    for i,v in ipairs(found_blocks) do
        print(v:tostring())
    end
end


local initial_pos = nil
if RETURN_START then
    initial_pos = tp.getPosition()
end
mapAround()
while #found_blocks > 0 do
    table.sort(found_blocks, distanceToMe)
    tp.walkTo(found_blocks[#found_blocks])
    table.remove(found_blocks)
    mapAround()
end

if RETURN_START then
    tp.walkTo(initial_pos)
end

tp.savePosition()
