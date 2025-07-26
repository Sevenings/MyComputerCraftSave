--[[
    Sevening_
    Turtle Plus eh um modulo para melhores funcoes de controle sobre as turtles.
]]

local tuplus = {}


-- Imports
local ioutils = require "ioutils"



-- Constantes
-- Enumeracao de Movimentos
local MOVIMENTO = {
    UP = 'u',
    DOWN = 'd',
    FORWARD = 'f',
    BACK = 'b',
    LEFT = 'l',
    RIGHT = 'r'
}


-- Adiciona um movimento a todos os caminhos ate entao registrados
tuplus.registrarMovimento = function(movimento)
    for _, caminho in pairs(Caminhos) do
        if caminho.gravando then
            table.insert(caminho.movimentos, movimento)
        end
    end
end




--Directional Functions
EAST = 0
SOUTH = 1
WEST = 2
NORTH = 3


tuplus.facingToString = function(direction)
    if direction == EAST then return "East"
    elseif direction == SOUTH then return "South"
    elseif direction == WEST then return "West"
    elseif direction == NORTH then return "North"
    end
end


-- Status getters e setters
local fileName = "status.config"
tuplus.getStatus = function()
    if not fs.exists(fileName) then
        fs.open(fileName, "w")
    end
    local file = io.open(fileName)
    local content = file:read("*all")
    local status = textutils.unserialize(content)
    if status == nil then status = {} end
    if status.position == nil then status.position = vector.new(0,0,0) end
    if status.facing == nil then status.facing = EAST end
    return status
end


tuplus.setStatus = function(newStatusTable)
    local file = io.open(fileName, "w")
    local content = textutils.serialize(newStatusTable)
    file:write(content)
    file:close()
end


-- Facing getter e setter
FACING = nil
tuplus.getFacing = function()
    if FACING then
        return FACING
    end
    local status = tuplus.getStatus()
    FACING = status.facing
    return FACING
end


tuplus.setFacing = function(direction)
    FACING = direction
end


tuplus.saveFacing = function()
    local status = tuplus.getStatus()
    assert(status.facing)
    status.facing = FACING
    setStatus(status)
end


-- Position getter e setter
POSITION = nil
tuplus.getPosition = function()
    if POSITION then
        return POSITION
    end
    local status = tuplus.getStatus()
    local posTable = status.position
    POSITION = vector.new(posTable.x, posTable.y, posTable.z)
    return POSITION
end


tuplus.setPosition = function(pos)
    POSITION = pos
end


tuplus.savePosition = function()
    local status = tuplus.getStatus()
    assert(status.position)
    status.position = POSITION
    setStatus(status)
end


-- Conversor Facing(String) to Facing(Number)
tuplus.facingToNum = function(facing)
    local facing = string.lower(facing)
    if facing == "w" then return WEST
    elseif facing == "s" then return SOUTH
    elseif facing == "e" then return EAST
    elseif facing == "n" then return NORTH
    else return false
    end
end


tuplus.facingToVector = function(facing)
	if facing == EAST then
		return vector.new(1, 0, 0)
	elseif facing == WEST then
		return vector.new(-1, 0, 0)
	elseif facing == SOUTH then
		return vector.new(0, 0, 1)
	elseif facing == NORTH then
		return vector.new(0, 0, -1)
	end
end


tuplus.vectorToFacing = function(vetor)
    if vetor:equals(vector.new(1, 0, 0)) then return EAST
    elseif vetor:equals(vector.new(-1, 0, 0)) then return WEST
    elseif vetor:equals(vector.new(0, 0, 1)) then return SOUTH
    elseif vetor:equals(vector.new(0, 0, -1)) then return NORTH
    end
end


--Orientation
--Facing orientation
tuplus.askForDirection = function()
    local facing = ioutils.askFor(facingToNum, "Set the direction: [n, s, e, w]", "Not a valid direction...")
    return facing
end


tuplus.gpsFindDirection = function()
    local pos_a = tuplus.gpsFindPosition()
    local tries = 0
    while turtle.detect() do
        tuplus.turnLeft()
        tries = tries + 1
        if tries > 3 then
            tryDig()
            break
        end
    end
    tuplus.forward()
    local pos_b = tuplus.gpsFindPosition()
    tuplus.back()
    local look_vector = pos_b - pos_a
    return tuplus.vectorToFacing(look_vector)
end


tuplus.orientateFacing = function(option)
    local modem = peripheral.find("modem")
    local facing_direction = 0
    if modem and gps.locate() and not (option == "manual") then
        facing_direction = tuplus.gpsFindDirection()
    else
        facing_direction = tuplus.askForDirection()
    end
    tuplus.setFacing(facing_direction)
end


--Position orientation
tuplus.askForPosition = function()
    local x = ioutils.askFor(tonumber, "Set X:", "Not a number...")
    local y = ioutils.askFor(tonumber, "Set Y:", "Not a number...")
    local z = ioutils.askFor(tonumber, "Set Z:", "Not a number...")
    local position = vector.new(x, y, z)
    return position
end


tuplus.gpsFindPosition = function()
    local x, y, z = gps.locate()
    return vector.new(x, y, z)
end


tuplus.orientatePosition = function(option)
    local modem = peripheral.find("modem")
    local position = vector.new(0, 0, 0)
    if modem and gps.locate() and not (option == "manual") then
        position = tuplus.gpsFindPosition()
    else
        position = tuplus.askForPosition()
    end
    tuplus.setPosition(position)
end


tuplus.canGpsOrientate = function()
    local modem = peripheral.find("modem")
    if modem and gps.locate() then
        return true
    end
    return false
end


--To orientate
tuplus.orientate = function(option)
    tuplus.orientateFacing(option)
    tuplus.orientatePosition(option)
end


tuplus.facingDistance = function(dirInicial, dirFinal)    --Matemática circular :)
    return (dirFinal - dirInicial) % 4
end


-- Funções para rotacionar
tuplus.turnRight = function()
    turtle.turnRight()
    local facing = tuplus.getFacing()
    facing = facing + 1
    facing = facing%4     --Matemática circular :3
    tuplus.setFacing(facing)
    tuplus.registrarMovimento(MOVIMENTO.RIGHT)
end


tuplus.turnLeft = function()
    turtle.turnLeft()
    local facing = tuplus.getFacing()
    facing = facing - 1
    facing = facing%4     --Matemática de relógio XD
    tuplus.setFacing(facing)
    tuplus.registrarMovimento(MOVIMENTO.LEFT)
end


tuplus.turnTo = function(targetDirection)
    while tuplus.getFacing() ~= targetDirection do
        if tuplus.facingDistance(tuplus.getFacing(), targetDirection) > 1 then
            tuplus.turnLeft()
        else
            tuplus.turnRight()
        end
    end
end


--Digging Functions
tuplus.tryDig = function()
    while turtle.detect() do
        turtle.dig()
        sleep(0.1)
    end
end


tuplus.tryDigUp = function()
    while turtle.detectUp() do
        turtle.digUp()
        sleep(0.1)
    end
end


tuplus.tryDigDown = function()
    while turtle.detectDown() do
        turtle.digDown()
        sleep(0.1)
    end
end


--Moving functions
tuplus.forward = function()
    local moved = turtle.forward()
    if moved then
      local position = tuplus.getPosition()
      local facing = tuplus.getFacing()
      tuplus.setPosition(position + tuplus.facingToVector(facing))
      tuplus.registrarMovimento(MOVIMENTO.FORWARD)
    end
    return moved
end


tuplus.back = function()
    local moved = turtle.back()
    if moved then
      local position = tuplus.getPosition()
      local facing = tuplus.getFacing()
      tuplus.setPosition(position - tuplus.facingToVector(facing))
      tuplus.registrarMovimento(MOVIMENTO.BACK)
    end
    return moved
end


tuplus.up = function()
  local moved = turtle.up()
  if moved then
    local position = tuplus.getPosition()
		tuplus.setPosition(position + vector.new(0, 1, 0))
    tuplus.registrarMovimento(MOVIMENTO.UP)
	end
  return moved
end


tuplus.down = function()
  local moved = turtle.down()
	if moved then
    local position = tuplus.getPosition()
    tuplus.setPosition(position + vector.new(0, -1, 0))
    tuplus.registrarMovimento(MOVIMENTO.DOWN)
	end
  return moved
end


tuplus.walkTo = function(destination)
    local x = destination.x
    local y = destination.y
    local z = destination.z

    if tuplus.getPosition().x > x then
        tuplus.turnTo(WEST)
    elseif tuplus.getPosition().x < x then
        tuplus.turnTo(EAST)
    end

    while tuplus.getPosition().x ~= x do
        tuplus.tryDig()
        tuplus.forward()
    end

    if tuplus.getPosition().z < z then
        tuplus.turnTo(SOUTH)
    elseif tuplus.getPosition().z > z then
        tuplus.turnTo(NORTH)
    end

    while tuplus.getPosition().z ~= z do
        tuplus.tryDig()
        tuplus.forward()
    end

    while tuplus.getPosition().y ~= y do
        if tuplus.getPosition().y < y then
            tuplus.tryDigUp()
            tuplus.up()
        elseif tuplus.getPosition().y > y then
            tuplus.tryDigDown()
            tuplus.down()
        end
    end
end


tuplus.upUntil = function()
    while tuplus.up() do end
end


tuplus.downUntil = function()
    while tuplus.down() do end
end


tuplus.forwardUntil = function()
    while tuplus.forward() do end
end


tuplus.backUntil = function()
    while tuplus.back() do end
end


tuplus.smoothWalkTo = function(destination)
    while not tuplus.getPosition().equals(destination) do
        local deslocamento = destination - tuplus.getPosition()
        while deslocamento:dot(tuplus.facingToVector(tuplus.getFacing())) <= 0 do
            tuplus.turnLeft()
        end
        tuplus.forward()
    end
end


-- Funcoes de caminhos
Caminhos = {}


-- Dicionario movimento para funcao
local DICT_MOVIMENTO = {
    [MOVIMENTO.UP] = up,
    [MOVIMENTO.DOWN] = down,
    [MOVIMENTO.FORWARD] = forward,
    [MOVIMENTO.BACK] = back,
    [MOVIMENTO.LEFT] = turnLeft,
    [MOVIMENTO.RIGHT] = turnRight,
}


-- Dicionario movimento para funcao reverso
local DICT_MOVIMENTO_R = {
    [MOVIMENTO.UP] = down,
    [MOVIMENTO.DOWN] = up,
    [MOVIMENTO.FORWARD] = back,
    [MOVIMENTO.BACK] = forward,
    [MOVIMENTO.LEFT] = turnRight,
    [MOVIMENTO.RIGHT] = turnLeft,
}


-- Retorna o caminho com certo nome
tuplus.getCaminho = function(nome_caminho)
    return Caminhos[nome_caminho]
end


-- Retorna a lista de movimentos de um caminho
tuplus.getMovimentos = function(nome_caminho)
    local caminho = tuplus.getCaminho(nome_caminho)
    return caminho.movimentos
end


-- Altera o valor de um caminho
tuplus.setCaminho = function(nome_caminho, caminho)
    Caminhos[nome_caminho] = caminho
end


-- Cria um caminho novo na lista de caminhos
-- Caminhos sao ativos por padrao
tuplus.novoCaminho = function(nome)
    local caminho = {
        -- Lista de movimentos do caminho
        movimentos = {},

        -- Variável que define se estamos 
        -- gravando os movimentos realizados 
        -- neste caminho
        gravando = false,
    }

    Caminhos[nome] = caminho
    return caminho
end

-- Remove um caminho da lista de caminhos
tuplus.deletarCaminho = function(nome_caminho)
    Caminhos[nome_caminho] = nil
end


-- Verifica se um caminho existe
tuplus.existeCaminho = function(nome_caminho)
    return Caminhos[nome_caminho] ~= nil
end


-- Inicia a gravação de um caminho para poder ser atualizado
tuplus.gravarCaminho = function(nome_caminho)
    if not tuplus.existeCaminho(nome_caminho) then
        tuplus.novoCaminho(nome_caminho)
    end
    Caminhos[nome_caminho].gravando = true
end


-- Encerra a gravação de um caminho, para que nao possa ser alterado
tuplus.pararGravacaoCaminho = function(nome_caminho)
    if not tuplus.existeCaminho(nome_caminho) then
        return
    end
    Caminhos[nome_caminho].gravando = false
end


-- Percorre um caminho
tuplus.percorrerCaminho = function(nome_caminho)
    local caminho = tuplus.getCaminho(nome_caminho)
    for k, movimento in pairs(caminho.movimentos) do
        DICT_MOVIMENTO[movimento]()
    end
end


-- Percorre um caminho de tras para frente
tuplus.desfazerCaminho = function(nome_caminho)
    tuplus.pararGravacaoCaminho(nome_caminho)
    local caminho = tuplus.getCaminho(nome_caminho)
    local movimentos = caminho.movimentos
    for i = #movimentos, 1, -1 do
        local movimento = movimentos[i]
        DICT_MOVIMENTO_R[movimento]()
    end
end


-- Limpa o registro de um caminho sem deleta-lo
tuplus.limparCaminho = function(nome_caminho)
    Caminhos[nome_caminho].movimentos = {}
end

-- Calcula o tamanho de um caminho
tuplus.tamanhoCaminho = function(nome_caminho)
    local movimentos = tuplus.getMovimentos(nome_caminho)

    local dict_gastos = {
        [MOVIMENTO.UP] = 1,
        [MOVIMENTO.DOWN] = 1,
        [MOVIMENTO.FORWARD] = 1,
        [MOVIMENTO.BACK] = 1,
        [MOVIMENTO.LEFT] = 0,
        [MOVIMENTO.RIGHT] = 0
    }

    local tamanho = 0
    for _, m in pairs(movimentos) do
        tamanho = tamanho + dict_gastos[m]
    end
    return tamanho
end


-- Salva os movimentos de um caminho em um nome_arquivo
-- para que possam ser carregaos eventualmente
tuplus.salvarCaminho = function(nome_caminho, nome_arquivo)
    local caminho = tuplus.getCaminho(nome_caminho)
    local conteudo = textutils.serializeJSON(caminho)
    local file = io.open(nome_arquivo, "w")
    if file then
        file:write(conteudo)
        file:flush()
        file:close()
    else
        print("[Erro] Arquivo ".. nome_arquivo.. " não pode ser criado")
    end
end

tuplus.carregarCaminho = function(nome_caminho, nome_arquivo)
    local file = io.open(nome_arquivo, "r")
    if not file then
        print("[Erro] Arquivo ".. nome_arquivo .."não existe")
        return
    end
    local content = file:read()
    file:close()
    local caminho_carregado = textutils.unserializeJSON(content)
    tuplus.setCaminho(nome_caminho, caminho_carregado)
end


-- Funcoes de Inventario
tuplus.search = function(itemName)
    for slot=1, 16 do
        local item = turtle.getItemDetail(slot)
        if item then
            if item.name == itemName then
                turtle.select(slot)
                return true
            end
        end
    end
    return false
end


tuplus.searchNotEmptySlot = function()
    for slot=1, 16 do
        if turtle.getItemCount(slot) > 0 then 
            turtle.select(slot)
            return true
        end
    end
    return false
end


-- Verifica se inventario esta cheio 
tuplus.inventarioCheio = function()
    local selected_slot = turtle.getSelectedSlot()
    for s=16, 1, -1 do
        turtle.select(s)
        if turtle.getItemCount() == 0 then
            turtle.select(selected_slot)
            return false
        end
    end
    turtle.select(selected_slot)
    return true
end


-- Esvazia o inventario dropando todos os itens
tuplus.esvaziarInventario = function()
    local selected_slot = turtle.getSelectedSlot()
    for s=1, 16 do
        turtle.select(s)
        turtle.drop()
    end
    turtle.select(selected_slot)
end


-- Inspeciona para ver se o bloco da frente eh o desejado
tuplus.isBlock = function(block_name)
    local _, block = turtle.inspect()
    return block.name == block_name
end


-- Inspeciona para ver se o bloco de cima eh o desejado
tuplus.isBlockUp = function(block_name)
    local _, block = turtle.inspectUp()
    return block.name == block_name
end


-- Inspeciona para ver se o bloco de baixo eh o desejado
tuplus.isBlockDown = function(block_name)
    local _, block = turtle.inspectDown()
    return block.name == block_name
end


tuplus.distanceToMe = function(final_pos)
    local diff_vector = final_pos - (tuplus.getPosition() + vector.new(0.5, 0.5, 0.5))
    return diff_vector:length()
end


tuplus.closestPos = function(pos_list)
    local menor_distancia = tuplus.distanceToMe(pos_list[1])
    local closest = pos_list[1]
    for i,posicao in ipairs(pos_list) do
        if tuplus.distanceToMe(posicao) < menor_distancia then
            menor_distancia = tuplus.distanceToMe(posicao)
            closest = posicao
        end
    end
    return closest
end



-- Funcoes de construcao
tuplus.place = function()
    canPlace, error = turtle.place()
    while not canPlace do
        if error == "Cannot place block here" then
            return turtle.place()
        end
        if not tuplus.searchNotEmptySlot() then
            return turtle.place()
        end
        canPlace, error = turtle.place()
    end
    return true
end


tuplus.placeDown = function()
    canPlace, error = turtle.placeDown()
    while not canPlace do
        if error == "Cannot place block here" then
            return turtle.placeDown()
        end
        if not tuplus.searchNotEmptySlot() then
            return turtle.placeDown()
        end
        canPlace, error = turtle.placeDown()
    end
    return true
end


tuplus.placeUp = function()
    canPlace, error = turtle.placeUp()
    while not canPlace do
        if error == "Cannot place block here" then
            return turtle.placeUp()
        end
        if not tuplus.searchNotEmptySlot() then
            return turtle.placeUp()
        end
        canPlace, error = turtle.placeUp()
    end
    return true
end


-- Funções de combustivel
tuplus.refuelAll = function()
    shell.run('refuel', 'all')
end


return tuplus
