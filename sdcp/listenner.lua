sdcp = require "sdcp"

sdcp.open()
while true do
    local message = sdcp.receive()
    shell.run(message.content)
end

