
tp = require "tuplus"

local itemName = "minecraft:carrot"

function isGrown()
    local inspected, item = turtle.inspectDown()
    if not inspected then return false end
    if item.state then
        local age = item.state.age
        if age == 7 then return true end
    end
    return false
end


function harvest()
    if isGrown() then
        turtle.digDown()
    end
    if not turtle.detectDown() then
        if search(itemName) then turtle.placeDown() end
    end
end


function refuelAtChest()
    local sucess = false
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.suck()
    for slot=1, 16 do
        turtle.select(slot)
        if turtle.refuel() then 
            sucess = true 
            break 
        end
    end
    turtle.turnRight()
    turtle.turnRight()
    return success
end


function stockCrop()
    turtle.turnLeft()
    while search(itemName) do
        turtle.drop()
    end
    turtle.turnRight()
end


function search(itemName)
    for slot=1, 16 do
        local item = turtle.getItemDetail(slot)
        if item then
            if item.name == itemName then 
                turtle.select(slot)
                return true 
            end
        end
    end
    return false
end


-- Harvest the crop
function harvestCrop(length, width)
  for i = 1, length do
    for j = 1, width do
      harvest() 
      if j < width then forward() end
    end
    if i < length then
      if i % 2 == 1 then
        turnRight()
        forward()
        turnRight()
      else
        turnLeft()
        forward()
        turnLeft()
      end
    end
  end
end

-- Main program
local length = 9  -- Set the length of the farm
local width = 9   -- Set the width of the farm
local sleepTime = 60*20  -- Set the sleeping time between harvests
local neededFuel = length*width + length + width
local startingPosition = getPosition()
local startingFacing = getFacing()

while true do
    while turtle.getFuelLevel() < neededFuel do
        print("Need fuel! "..turtle.getFuelLevel().."/"..neededFuel)
        print("Refueling...")
        if not refuelAtChest() then
            print("Need fuel! "..turtle.getFuelLevel().."/"..neededFuel)
            print("Please refuel!")
            print("Press ENTER when refueled...")
            read()
        end
    end
    print("Refueled! Ready to go!")

    harvestCrop(length, width)
    walkTo(startingPosition)
    turnTo(startingFacing)
    stockCrop()
    sleep(sleepTime)
end
