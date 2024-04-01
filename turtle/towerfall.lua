tp = require("tuplus")

local raio = 2

function activate()
    redstone.setOutput("front", true)
    sleep(0.2)
    redstone.setOutput("front", false)
end

local altura = 0
while turtle.detect() do
    tp.up()
    altura = altura + 1
end

for i=1, raio do
    tryDig()
    forward()
end

turtle.place()
activate()


for i=1, raio do
    back()
end

for i=1, altura do
    down()
end
