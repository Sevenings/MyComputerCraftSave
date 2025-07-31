local rpc = {}

rpc.__version__ = "1.0"

---@class Comando
---@field metodo string
---@field parametros table

PROTOCOL = "miner"
TIMEOUT = 4


local function rpc_getProceduresList(api)
  return function ()
    local procedures = {}
    for k, _ in pairs(api) do
      table.insert(procedures, k)
    end
    return procedures
  end
end


---Função que hosteia um serviço de rpc. Escuta por chamadas remotas, executa localmente e devolve o resultado
---@param service string nome do serviço hospedado
---@param api table Tabela com os métodos aos quais o serviço irá responder
function rpc.host(service, api)
  -- Abrir o modem
  peripheral.find("modem", rednet.open)

  -- Hostear no serviço de nomes
  rednet.host(service, tostring(os.getComputerID()))
  print("Hosting: "..service)

  -- Adicionar uma certa função padrão na api
  api["__rpc.getProceduresList"] = rpc_getProceduresList(api)

  -- Escuta por mensagens da rednet
  while true do

    -- Recebe o comando
    local sender, comando = rednet.receive(service)
    if not comando then goto continue end
    print("Recebido: ", textutils.serialise(comando))


    -- Comando de terminal
    if comando.shell_command then
      print(comando.shell_command)
      local resultado = shell.run(comando.shell_command)
      rpc.responder(sender, resultado)
      goto continue

    -- Comando da API
    elseif comando.metodo then
      local metodo = api[comando.metodo]
      local args = comando.parametros or {}

      -- Comando não suportado
      if not metodo then
        rpc.responder(sender, "Erro: Comando nao suportado")
        goto continue
      end

      -- Executa comando
      local resultado = {metodo(table.unpack(args))}
      if #resultado == 1 then
        resultado = resultado[1]
      end
      rpc.responder(sender, resultado)
      goto continue
    end

    ::continue::
  end

end


function rpc.responder(id_sender, resultado)
  return rednet.send(id_sender, resultado, PROTOCOL)
end


---Função que realiza uma chamada de método remota em um outro computador hosteando um serviço de rpc
---@param id_dest number id do computador de destino
---@param metodo string Nome do método a ser chamado
---@return boolean recebida Se a mensagem foi recebida
---@return boolean|string|number|table|nil resultado
function rpc.call(id_dest, servico, metodo, ...)
  -- Monta o comando a ser enviado
  local parametros = {...}
  local comando = {metodo = metodo, parametros = parametros}

  -- Envia para o host
  rednet.send(id_dest, comando, servico)

  -- Aguarda por uma resposta
  local timeout = TIMEOUT -- segundos
  while timeout > 0 do
    local sender, resposta  = rednet.receive(servico, 1)
    if sender == id_dest then
      return true, resposta
    end
    timeout = timeout - 1
  end
  return false, nil
end


local function remoteCallFactory(id, servico, nome_metodo)
  return function (...)
    local args = {...}
    local success, resultado = rpc.call(id, servico, nome_metodo, table.unpack(args))
    return resultado
  end
end


---Função que se conecta a um host, pega os métodos e retorna um proxy local
---@param id number id do computador que deseja se conectar
---@param servico string nome do servico que deseja obter do computador
function rpc.Proxy(id, servico)

  -- Abrir o modem
  peripheral.find("modem", rednet.open)

  -- Buscar os métodos disponíveis
  local success, lista_metodos = rpc.call(id, servico, "__rpc.getProceduresList")
  if not success then
    error("Erro: Host não responde")
  end

  -- Criar o proxy
  local proxy = {}
  for _, nome_metodo in pairs(lista_metodos) do
    proxy[nome_metodo] = remoteCallFactory(id, servico, nome_metodo)
  end

  return proxy
end

return rpc
