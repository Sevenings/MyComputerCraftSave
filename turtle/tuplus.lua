--[[
    Sevening_
    Turtle Plus eh um modulo para melhores funcoes de controle sobre as turtles.
]]


local ioutils = require "ioutils"


-- Funções para salvar caminhos
Caminhos = {}


local MOVIMENTO = {
    UP = 'u',
    DOWN = 'd',
    FORWARD = 'f',
    BACK = 'b',
    LEFT = 'l',
    RIGHT = 'r'
}


local function getCaminho(nome)
    return Caminhos[nome]
end


local function comecarCaminho(nome)
    Caminhos[nome] = {ativo = true, movimentos = {}}
end


local function encerrarCaminho(nome)
    Caminhos[nome] = nil
end


local function ativarCaminho(nome)
    Caminhos[nome].ativo = true
end


local function desativarCaminho(nome)
    Caminhos[nome].ativo = false
end


local function registrarMovimento(movimento)
    for _, caminho in pairs(Caminhos) do
        if caminho.ativo then
            table.insert(caminho, movimento)
        end
    end
end



--Directional Functions
EAST = 0
SOUTH = 1
WEST = 2
NORTH = 3


local function facingToString(direction)
    if direction == EAST then return "East"
    elseif direction == SOUTH then return "South"
    elseif direction == WEST then return "West"
    elseif direction == NORTH then return "North"
    end
end


-- Status getters e setters
local fileName = "status.config"
local function getStatus()
    if not fs.exists(fileName) then
        fs.open(fileName, "w")
    end
    local file = io.open(fileName)
    local content = file:read("*all")
    local status = textutils.unserialize(content)
    if status == nil then status = {} end
    if status.position == nil then status.position = vector.new(0,0,0) end
    if status.facing == nil then status.facing = EAST end
    return status
end


local function setStatus(newStatusTable)
    local file = io.open(fileName, "w")
    local content = textutils.serialize(newStatusTable)
    file:write(content)
    file:close()
end


-- Facing getter e setter
FACING = nil
local function getFacing()
    if FACING then
        return FACING
    end
    local status = getStatus()
    FACING = status.facing
    return FACING
end


local function setFacing(direction)
    FACING = direction
end


local function saveFacing()
    local status = getStatus()
    assert(status.facing)
    status.facing = FACING
    setStatus(status)
end


-- Position getter e setter
POSITION = nil
local function getPosition()
    if POSITION then
        return POSITION
    end
    local status = getStatus()
    local posTable = status.position
    POSITION = vector.new(posTable.x, posTable.y, posTable.z)
    return POSITION
end


local function setPosition(pos)
    POSITION = pos
end


local function savePosition()
    local status = getStatus()
    assert(status.position)
    status.position = POSITION
    setStatus(status)
end


-- Conversor Facing(String) to Facing(Number)
local function facingToNum(facing)
    local facing = string.lower(facing)
    if facing == "w" then return WEST
    elseif facing == "s" then return SOUTH
    elseif facing == "e" then return EAST
    elseif facing == "n" then return NORTH
    else return false
    end
end


local function facingToVector(facing)
	if facing == EAST then
		return vector.new(1, 0, 0)
	elseif facing == WEST then
		return vector.new(-1, 0, 0)
	elseif facing == SOUTH then
		return vector.new(0, 0, 1)
	elseif facing == NORTH then
		return vector.new(0, 0, -1)
	end
end


local function vectorToFacing(vetor)
    if vetor:equals(vector.new(1, 0, 0)) then return EAST
    elseif vetor:equals(vector.new(-1, 0, 0)) then return WEST
    elseif vetor:equals(vector.new(0, 0, 1)) then return SOUTH
    elseif vetor:equals(vector.new(0, 0, -1)) then return NORTH
    end
end


--Orientation
--Facing orientation
local function askForDirection()
    local facing = ioutils.askFor(facingToNum, "Set the direction: [n, s, e, w]", "Not a valid direction...")
    return facing
end


local function gpsFindDirection()
    local pos_a = gpsFindPosition()
    local tries = 0
    while turtle.detect() do
        turnLeft() 
        tries = tries + 1
        if tries > 3 then
            tryDig()
            break
        end
    end
    forward()
    local pos_b = gpsFindPosition()
    back()
    local look_vector = pos_b - pos_a
    return vectorToFacing(look_vector)
end


local function orientateFacing(option)
    local modem = peripheral.find("modem")
    local facing_direction = 0
    if modem and gps.locate() and not (option == "manual") then
        facing_direction = gpsFindDirection()
    else
        facing_direction = askForDirection()
    end
    setFacing(facing_direction)
end


--Position orientation
local function askForPosition()
    local x = ioutils.askFor(tonumber, "Set X:", "Not a number...")
    local y = ioutils.askFor(tonumber, "Set Y:", "Not a number...")
    local z = ioutils.askFor(tonumber, "Set Z:", "Not a number...")
    local position = vector.new(x, y, z)
    return position
end


local function gpsFindPosition()
    local x, y, z = gps.locate()
    return vector.new(x, y, z)
end


local function orientatePosition(option)
    local modem = peripheral.find("modem")
    local position = vector.new(0, 0, 0)
    if modem and gps.locate() and not (option == "manual") then
        position = gpsFindPosition()
    else
        position = askForPosition()
    end
    setPosition(position)
end


local function canGpsOrientate()
    local modem = peripheral.find("modem")
    if modem and gps.locate() then
        return true
    end
    return false
end


--To orientate
local function orientate(option)
    orientateFacing(option)
    orientatePosition(option)
end


local function facingDistance(dirInicial, dirFinal)    --Matemática circular :)
    return (dirFinal - dirInicial) % 4
end


-- Funções para rotacionar
local function turnRight() 
    turtle.turnRight()
    local facing = getFacing()
    facing = facing + 1
    facing = facing%4     --Matemática circular :3
    setFacing(facing)
    registrarMovimento(MOVIMENTO.RIGHT)
end


local function turnLeft()
    turtle.turnLeft()
    local facing = getFacing()
    facing = facing - 1
    facing = facing%4     --Matemática de relógio XD
    setFacing(facing)
    registrarMovimento(MOVIMENTO.LEFT)
end


local function turnTo(targetDirection)
    while getFacing() ~= targetDirection do
        if facingDistance(getFacing(), targetDirection) > 1 then
            turnLeft()
        else 
            turnRight()
        end
    end
end


--Digging Functions
local function tryDig()
    while turtle.detect() do
        turtle.dig()
        sleep(0.1)
    end
end


local function tryDigUp()
    while turtle.detectUp() do
        turtle.digUp()
        sleep(0.1)
    end
end


local function tryDigDown()
    while turtle.detectDown() do
        turtle.digDown()
        sleep(0.1)
    end
end


--Moving functions
local function forward()
    local moved = turtle.forward()
	if moved then
        local position = getPosition()
        local facing = getFacing()
		setPosition(position + facingToVector(facing))
        registrarMovimento(MOVIMENTO.FORWARD)
	end
    return moved
end


local function back()
    local moved = turtle.back()
    if moved then
        local position = getPosition()
        local facing = getFacing()
		setPosition(position - facingToVector(facing))
        registrarMovimento(MOVIMENTO.BACK)
	end
    return moved
end
	

local function up()
    local moved = turtle.up()
	if moved then
        local position = getPosition()
		setPosition(position + vector.new(0, 1, 0))
        registrarMovimento(MOVIMENTO.UP)
	end
    return moved
end


local function down()
    local moved = turtle.down()
	if moved then
        local position = getPosition()
		setPosition(position + vector.new(0, -1, 0))
        registrarMovimento(MOVIMENTO.DOWN)
	end
    return moved
end


local function walkTo(destination)
    local x = destination.x
    local y = destination.y
    local z = destination.z

    if getPosition().x > x then
        turnTo(WEST)
    elseif getPosition().x < x then
        turnTo(EAST)
    end

    while getPosition().x ~= x do
        tryDig()
        forward()
    end
    
    if getPosition().z < z then
        turnTo(SOUTH)
    elseif getPosition().z > z then
        turnTo(NORTH)
    end

    while getPosition().z ~= z do
        tryDig()
        forward()
    end

    while getPosition().y ~= y do
        if getPosition().y < y then
            tryDigUp()
            up()
        elseif getPosition().y > y then
            tryDigDown()
            down()
        end
    end
end


local function upUntil()
    while up() do end
end


local function downUntil()
    while down() do end
end


local function forwardUntil()
    while forward() do end
end


local function backUntil()
    while back() do end
end


local function smoothWalkTo(destination)
    while not getPosition().equals(destination) do
        local deslocamento = destination - getPosition()
        while deslocamento:dot(facingToVector(getFacing())) <= 0 do
            turnLeft()
        end
        forward()
    end
end


local function search(itemName)
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


local function searchNotEmptySlot()
    for slot=1, 16 do
        if turtle.getItemCount(slot) > 0 then 
            turtle.select(slot)
            return true
        end
    end
    return false
end


local function distanceToMe(final_pos)
    local diff_vector = final_pos - (getPosition() + vector.new(0.5, 0.5, 0.5))
    return diff_vector:length()
end


local function closestPos(pos_list)
    local menor_distancia = distanceToMe(pos_list[1])
    local closest = pos_list[1]
    for i,posicao in ipairs(pos_list) do
        if distanceToMe(posicao) < menor_distancia then
            menor_distancia = distanceToMe(posicao)
            closest = posicao
        end
    end
    return closest
end


local function place()
    canPlace, error = turtle.place()
    while not canPlace do
        if error == "Cannot place block here" then 
            return turtle.place() 
        end
        if not searchNotEmptySlot() then
            return turtle.place()
        end
        canPlace, error = turtle.place()
    end
    return true
end


local function placeDown()
    canPlace, error = turtle.placeDown()
    while not canPlace do
        if error == "Cannot place block here" then 
            return turtle.placeDown() 
        end
        if not searchNotEmptySlot() then
            return turtle.placeDown()
        end
        canPlace, error = turtle.placeDown()
    end
    return true
end


local function placeUp()
    canPlace, error = turtle.placeUp()
    while not canPlace do
        if error == "Cannot place block here" then 
            return turtle.placeUp()
        end
        if not searchNotEmptySlot() then
            return turtle.placeUp()
        end
        canPlace, error = turtle.placeUp()
    end
    return true
end


return {
    getCaminho = getCaminho,
    comecarCaminho = comecarCaminho,
    encerrarCaminho = encerrarCaminho,
    ativarCaminho = ativarCaminho,
    desativarCaminho = desativarCaminho,
    registrarMovimento = registrarMovimento,

    facingToString = facingToString,
    getFacing = getFacing,
    setFacing = setFacing,
    saveFacing = saveFacing,

    getPosition = getPosition,
    setPosition = setPosition,
    savePosition = savePosition,

    facingToNum = facingToNum,
    facingToVector = facingToVector,
    vectorToFacing = vectorToFacing,

    askForDirection = askForDirection,
    gpsFindDirection = gpsFindDirection,
    orientateFacing = orientateFacing,

    askForPosition = askForPosition,
    gpsFindPosition = gpsFindPosition,
    orientatePosition = orientatePosition,
    orientate = orientate,
    canGpsOrientate = canGpsOrientate,

    facingDistance = facingDistance,
    turnRight = turnRight,
    turnLeft = turnLeft,
    turnTo = turnTo,

    tryDig = tryDig,
    tryDigUp = tryDigUp,
    tryDigDown = tryDigDown,

    forward = forward,
    back = back,
    up = up,
    down = down,
    walkTo = walkTo,

    upUntil = upUntil,
    downUntil = downUntil,
    forwardUntil = forwardUntil,
    backUntil = backUntil,

    smoothWalkTo = smoothWalkTo,

    search = search,
    searchNotEmptySlot = searchNotEmptySlot,

    distanceToMe = distanceToMe,
    closestPos = closestPos,

    place = place,
    placeDown = placeDown,
    placeUp = placeUp,
}
