require "tuplus"

initial_pos = getPosition()

while not turtle.detectUp() do
    up()
end

savePosition()
shell.run("minamoGiri.lua up")
getPosition()

walkTo(initial_pos)
savePosition()