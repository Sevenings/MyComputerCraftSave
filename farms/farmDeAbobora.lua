-- Farm de Abóbora

tp = require "tuplus"

local itemName = "minecraft:pumpkin"

function refuelAtChest()
    local sucess = false
    turtle.turnRight()
    turtle.suck()
    for slot=1, 16 do
        turtle.select(slot)
        if turtle.refuel() then 
            sucess = true 
            break 
        end
    end
    turtle.turnLeft()
    return success
end


function stockCrop()
    turtle.turnRight()
    turtle.turnRight()
    while search(itemName) do
        turtle.drop()
    end
    turtle.turnLeft()
    turtle.turnLeft()
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


function positionate()
    forward()
    turnLeft()
    up()
    forward()
    forward()
    turnRight()
    tryDigDown()
    down()
end


function positionateBack()
    turnRight()
    up()
    forward()
    forward()
    turnLeft()
    down()
    back()
end


-- Harvest the crop
function harvestLayer(length)
    positionate()
    for i=1, length-1 do
        tryDig()
        forward()
    end
    for i=1, length-1 do
        back()
    end
    positionateBack()
end

function harvest(length, layers)
    for i=1, layers do
        harvestLayer(length)
        if i < layers then
            for j=1, 3 do
                up()
            end
        end
    end
end

-- Main program
local length = 15  -- Set the length of the farm
local layers = 4   -- Set the width of the farm
local sleepTime = 60*20  -- Set the sleeping time between harvests
local neededFuel = 2*layers*(length + 5)
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

    harvest(length, layers)
    walkTo(startingPosition)
    turnTo(startingFacing)
    stockCrop()
    sleep(sleepTime)
end
