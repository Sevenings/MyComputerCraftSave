--Cube economic
tp = require "tuplus"

local function trialDig()
    tp.tryDig()
    tp.tryDigUp()
    tp.tryDigDown()
end

local dimension = vector.new(arg[1], arg[2], arg[3])

local quant_camadas = math.floor(dimension.y/3)
local resto_camadas = dimension.y%3

--Setup
tp.tryDigUp()
tp.up()

for y=1, quant_camadas do   --Cavar para cima
    for z=1, dimension.z do   --Cavar para a direita
        for x=1, dimension.x-1 do   --Cavar para frente
            trialDig()
            tp.forward()
        end

        if z == dimension.z then
            tp.tryDigUp()
            tp.tryDigDown()
            break
        end

        if z%2 == 1 then    --Curva para direita
            tp.turnRight()
            trialDig()
            tp.forward()
            tp.turnRight()
        else
            tp.turnLeft()
            trialDig()
            tp.forward()
            tp.turnLeft()
        end
    end

    -- Se o z for ímpar ele está na diagonal oposta
    if dimension.z%2 == 1 then    --Ajeita a orientação
        tp.turnLeft()
        tp.turnLeft()
    else    -- Se o z for par ele está no lado oposto
        tp.turnRight()
        local aux = dimension.x
        dimension.x = dimension.z
        dimension.z = aux
    end 
    
    if y < quant_camadas then
        for i=1, 3 do
            tp.tryDigUp()
            tp.up()
        end
    end
end

if resto_camadas == 0 then
	return
end

for i=1, 2 do
    tp.tryDigUp()
    tp.up()
end

for z=1, dimension.z do   --Cavar para a direita
    for x=1, dimension.x-1 do   --Cavar para frente
        if resto_camadas == 2 then tp.tryDigUp() end
        tp.tryDig()
        tp.forward()
    end

    if z == dimension.z then
        break
    end

    if z%2 == 1 then    --Curva para direita
        tp.turnRight()
        tp.tryDig()
        tp.forward()
        tp.turnRight()
    else
        tp.turnLeft()
        tp.tryDig()
        tp.forward()
        tp.turnLeft()
    end
end

if dimension.z%2 == 1 then    --Ajeita a orientação
    tp.turnLeft()
    tp.turnLeft()
else
    tp.turnRight()
    for i=1, dimension.z-1 do
        tp.forward()
    end
    tp.turnRight()
end 
