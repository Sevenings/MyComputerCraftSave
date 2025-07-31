local pretty = require 'cc.pretty'

-- Host 
MODEM = "top"
PROTOCOL = "miner"
TIMEOUT = 10

-- Encontra as turtles miners
local function encontrar_miners()
  local miners = {rednet.lookup("miner")}
  if not miners then error("Nenhum miner encontrado") end
  table.sort(miners)
  return miners
end

local function send_miner(id_dest, msg)
  rednet.send(id_dest, msg, PROTOCOL)
  local timeout = TIMEOUT -- segundos
  while timeout > 0 do
    local sender, message  = rednet.receive(PROTOCOL, 1)
    if sender == id_dest then
      return true, textutils.unserialise(message)
    end
    timeout = timeout - 1
  end
  return false
end

-- Abre a rednet
if not rednet.isOpen(MODEM) then
  rednet.open(MODEM)
end

-- Encontra miners disponíveis
local miners = encontrar_miners()
print("Miners encontrados: ", textutils.serialise(miners))

while true do

  -- Escolhe um miner
  print("Escolha um miner")
  local miner_id = tonumber(read())

  -- Escolhe a mensagem
  write("Tipo de mensagem: [c]omando, [s]hell: ")
  local tipo = read()
  if tipo == "c" then
    write("Comando: ")
    local comando = read()
    write("Args: ")
    local args = textutils.unserialise(read())
    msg = textutils.serialise({command=comando, args=args})
  elseif tipo == "s" then
    write("Shell: ")
    shell_command = read()
    msg = textutils.serialise({shell_command=shell_command})
  else
    error("Tipo de mensagem inválido. Use 'c' para comando ou 's' para shell.")
  end

  -- Envia a mensagem
  local success, result = send_miner(miner_id, msg)

  -- Mostra resultados
  if success and result then
    result = table.unpack(result.result)
    print(textutils.serialise(result))
  end
  if not success then
    print("Timeout")
  end

end
