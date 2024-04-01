--Cube economic
require "tuplus"

function trialDig()
    tryDig()
    tryDigUp()
    tryDigDown()
end

local dimension = vector.new(arg[1], arg[2], arg[3])

local quant_camadas = math.floor(dimension.y/3)
local resto_camadas = dimension.y%3

--Setup
tryDigUp()
up()

for y=1, quant_camadas do   --Cavar para cima
    for z=1, dimension.z do   --Cavar para a direita
        for x=1, dimension.x-1 do   --Cavar para frente
            trialDig()
            forward()
        end

        if z == dimension.z then
            tryDigUp()
            tryDigDown()
            break
        end

        if z%2 == 1 then    --Curva para direita
            turnRight()
            trialDig()
            forward()
            turnRight()
        else
            turnLeft()
            trialDig()
            forward()
            turnLeft()
        end
    end

    if dimension.z%2 == 1 then    --Ajeita a orientação
        turnLeft()
        turnLeft()
    else
        turnRight()
        for i=1, dimension.z-1 do
            forward()
        end
        turnRight()
    end 
    
    if y < quant_camadas then
        for i=1, 3 do
            tryDigUp()
            up()
        end
    end
end

if resto_camadas == 0 then
	return
end

for i=1, 2 do
    tryDigUp()
    up()
end

for z=1, dimension.z do   --Cavar para a direita
    for x=1, dimension.x-1 do   --Cavar para frente
        if resto_camadas == 2 then tryDigUp() end
        tryDig()
        forward()
    end

    if z == dimension.z then
        break
    end

    if z%2 == 1 then    --Curva para direita
        turnRight()
        tryDig()
        forward()
        turnRight()
    else
        turnLeft()
        tryDig()
        forward()
        turnLeft()
    end
end

if dimension.z%2 == 1 then    --Ajeita a orientação
    turnLeft()
    turnLeft()
else
    turnRight()
    for i=1, dimension.z-1 do
        forward()
    end
    turnRight()
end 
