local modem = peripheral.find("modem", rednet.open)

function receiveMessage()
    local id, message = rednet.receive()
    local sender = message.sender
    local content = message.content
    return sender, content
end

while true do
    local sender_id, content = receiveMessage()
    local destination = content
    shell.run("walk", destination.x, destination.y, destination.z)
end


