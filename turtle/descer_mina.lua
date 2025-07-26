local tp = require "tuplus"

local args = {...}

if #args < 1 then
    print("Usage: fazer_mina.lua <profundidade>")
    return
end

local profundidade = tonumber(args[1])

-- Verificar combustivel
if 2*profundidade > turtle.getFuelLevel() then
  print("Combustivel insuficiente para descer a mina.")
  return
end

-- Cavar mina 

for _ = 1, profundidade do
  tp.tryDig()
  tp.forward()
  tp.tryDigUp()
  tp.tryDigDown()
  tp.down()
  if not turtle.detectDown() then
    turtle.placeDown()
  end
end
