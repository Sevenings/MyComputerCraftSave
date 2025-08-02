local rpc = require 'rpc'
local tp = require 'tuplus'

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
  ["turnTo"] = tp.turnTo,
  ["orientate"] = tp.orientate,
  ["distanceTo"] = tp.distanceTo,
  ["dig"] = turtle.dig,
  ["digUp"] = turtle.digUp,
  ["digDown"] = turtle.digDown,
  ["tryDig"] = tp.tryDig,
  ["tryDigUp"] = tp.tryDigUp,
  ["tryDigDown"] = tp.tryDigDown,
  ["shell"] = shell.run,
})

