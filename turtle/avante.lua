local length = arg[1]
if not length then
    length = 64
end

function tryDig()
    while turtle.detect() do
        turtle.dig()
        sleep(0.1)
    end
end

function tryDigUp()
    while turtle.detectUp() do
        turtle.digUp()
        sleep(0.1)
    end
end

function tryDigDown()
    while turtle.detectDown() do
        turtle.digDown()
        sleep(0.1)
    end
end


for i=1, length do
    tryDig()
    tryDigUp()
    turtle.forward()
end
