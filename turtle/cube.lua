require "tuplus"

local dimension = vector.new(arg[1], arg[2], arg[3])

for y=1, dimension.y do   --Cavar para cima
    for z=1, dimension.z do   --Cavar para a direita
        for x=1, dimension.x-1 do   --Cavar para frente
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
            turtle.turnLeft()
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

    if y == dimension.y then break end

    tryDigUp()
    up()
end
