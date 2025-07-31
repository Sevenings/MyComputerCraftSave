local rpc = require 'rpc'

local miner = rpc.Proxy(7, "miner")
local miner2 = rpc.Proxy(6, "miner")
local miner2 = rpc.Proxy(6, "miner")

-- Chamadas de métodos remotos
miner.forward()
miner.back()
miner.turnLeft()
miner.forward()
miner.back()
miner.turnRight()
miner.turnRight()
miner.forward()
miner.back()

miner2.forward()
miner2.back()
miner2.turnLeft()
miner2.forward()
miner2.back()
miner2.turnRight()
miner2.turnRight()
miner2.forward()
miner2.back()

