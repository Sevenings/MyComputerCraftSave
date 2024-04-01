sdcp = require "sdcp"

print("Controller:")
local id = nil
if #arg < 1 then
    write("Listenner ID: ")
    id = tonumber(read())
else 
    id = tonumber(arg[1])
end

sdcp.open()
while true do
    write("$ ")
    local command = read()
    sdcp.send(id, command)
end
