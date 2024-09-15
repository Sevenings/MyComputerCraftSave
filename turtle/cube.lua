local tp = require "tuplus"

local dimension = vector.new(arg[1], arg[2], arg[3])

for y=1, dimension.y do   --Cavar para cima
    for z=1, dimension.z do   --Cavar para a direita
        for x=1, dimension.x-1 do   --Cavar para frente
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

    if y == dimension.y then break end

    tp.tryDigUp()
    tp.up()
end
