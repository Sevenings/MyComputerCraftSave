local rpc = require 'rpc'
local tp = require 'tuplus'

SERVICE = "miner"

rpc.host("miner", {
  ["getPosition"] = tp.getPosition,
  ["getFacing"] = tp.getFacing,
  ["forward"] = tp.forward,
  ["back"] = tp.back,
  ["up"] = tp.up,
  ["down"] = tp.down,
  ["turnLeft"] = tp.turnLeft,
  ["turnRight"] = tp.turnRight,
  ["walkTo"] = tp.walkTo,
})

