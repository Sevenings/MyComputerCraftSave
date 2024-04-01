local PROTOCOL_NAME = "sdcp"
local TIMEOUT_TIME = 1
local CONFIRMATION_MESSAGE = "oi bb"


local function open()
    peripheral.find("modem", rednet.open)
    return rednet.isOpen()
end


local function host()
    local computer_name = os.computerLabel()
    rednet.host(PROTOCOL_NAME, computer_name)
    while true do
        print("Waiting for message...")
        local id, message = rednet.receive(PROTOCOL_NAME)
        print("Received a message from "..id.." to "..message.destination)
        print("Received Message:")
        print(message)
        rednet.send(message.destination, message, PROTOCOL_NAME)
        print("Sent message to "..message.destination)
    end
end


function createMessage(destination, content)
    local message = {
        destination = destination,  
        sender = os.computerID(),
        content = content
    }
    return message
end


local function send(destination, content)
    --Se encontrar host, envia a mensagem por ele
    --senão, tenta enviar diretamente
    local message = createMessage(destination, content)
    local hostId = rednet.lookup(PROTOCOL_NAME)
    if hostId then  
        if type(host) == "table" then
            hostId = hostId[1]
        end
        rednet.send(hostId, message, PROTOCOL_NAME) 
    else    
        rednet.send(destination, message, PROTOCOL_NAME) 
    end
    return receiveConfirmation(destination)
end


function receiveConfirmation(destination)
    if rednet.receive(PROTOCOL_NAME, TIMEOUT_TIME) then
        return true
    end
    return false
end


local function receive(timeout)
    local id, message = rednet.receive(PROTOCOL_NAME, timeout)
    local sender = message.sender
    confirm(sender)
    return message
end


function confirm(sender)
    local confirmation_message =  createMessage(CONFIRMATION_MESSAGE)
    rednet.send(sender, confirmation_message, PROTOCOL_NAME)
end

return {
    open = open,
    host = host,
    send = send,
    receive = receive
}
