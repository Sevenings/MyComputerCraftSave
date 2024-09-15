local tp = require "tuplus"

initial_pos = tp.getPosition()

while not turtle.detectUp() do
    up()
end

tp.savePosition()
shell.run("minamoGiri.lua up")
tp.getPosition()

tp.walkTo(initial_pos)
tp.savePosition()
