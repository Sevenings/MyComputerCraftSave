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
function tuplus.registrarMovimento(movimento)
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


function tuplus.facingToString(direction)
    if direction == EAST then return "East"
    elseif direction == SOUTH then return "South"
    elseif direction == WEST then return "West"
    elseif direction == NORTH then return "North"
    end
end


-- Status getters e setters
local fileName = "status.config"
function tuplus.getStatus()
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


function tuplus.setStatus(newStatusTable)
    local file = io.open(fileName, "w")
    local content = textutils.serialize(newStatusTable)
    file:write(content)
    file:close()
end


-- Facing getter e setter
FACING = nil
function tuplus.getFacing()
    if FACING then
        return FACING
    end
    local status = getStatus()
    FACING = status.facing
    return FACING
end


function tuplus.setFacing(direction)
    FACING = direction
end


function tuplus.saveFacing()
    local status = getStatus()
    assert(status.facing)
    status.facing = FACING
    setStatus(status)
end


-- Position getter e setter
POSITION = nil
function tuplus.getPosition()
    if POSITION then
        return POSITION
    end
    local status = getStatus()
    local posTable = status.position
    POSITION = vector.new(posTable.x, posTable.y, posTable.z)
    return POSITION
end


function tuplus.setPosition(pos)
    POSITION = pos
end


function tuplus.savePosition()
    local status = getStatus()
    assert(status.position)
    status.position = POSITION
    setStatus(status)
end


-- Conversor Facing(String) to Facing(Number)
function tuplus.facingToNum(facing)
    local facing = string.lower(facing)
    if facing == "w" then return WEST
    elseif facing == "s" then return SOUTH
    elseif facing == "e" then return EAST
    elseif facing == "n" then return NORTH
    else return false
    end
end


function tuplus.facingToVector(facing)
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


function tuplus.vectorToFacing(vetor)
    if vetor:equals(vector.new(1, 0, 0)) then return EAST
    elseif vetor:equals(vector.new(-1, 0, 0)) then return WEST
    elseif vetor:equals(vector.new(0, 0, 1)) then return SOUTH
    elseif vetor:equals(vector.new(0, 0, -1)) then return NORTH
    end
end


--Orientation
--Facing orientation
function tuplus.askForDirection()
    local facing = ioutils.askFor(facingToNum, "Set the direction: [n, s, e, w]", "Not a valid direction...")
    return facing
end


function tuplus.gpsFindDirection()
    local pos_a = gpsFindPosition()
    local tries = 0
    while turtle.detect() do
        turnLeft() 
        tries = tries + 1
        if tries > 3 then
            tryDig()
            break
        end
    end
    forward()
    local pos_b = gpsFindPosition()
    back()
    local look_vector = pos_b - pos_a
    return vectorToFacing(look_vector)
end


function tuplus.orientateFacing(option)
    local modem = peripheral.find("modem")
    local facing_direction = 0
    if modem and gps.locate() and not (option == "manual") then
        facing_direction = gpsFindDirection()
    else
        facing_direction = askForDirection()
    end
    setFacing(facing_direction)
end


--Position orientation
function tuplus.askForPosition()
    local x = ioutils.askFor(tonumber, "Set X:", "Not a number...")
    local y = ioutils.askFor(tonumber, "Set Y:", "Not a number...")
    local z = ioutils.askFor(tonumber, "Set Z:", "Not a number...")
    local position = vector.new(x, y, z)
    return position
end


function tuplus.gpsFindPosition()
    local x, y, z = gps.locate()
    return vector.new(x, y, z)
end


function tuplus.orientatePosition(option)
    local modem = peripheral.find("modem")
    local position = vector.new(0, 0, 0)
    if modem and gps.locate() and not (option == "manual") then
        position = gpsFindPosition()
    else
        position = askForPosition()
    end
    setPosition(position)
end


function tuplus.canGpsOrientate()
    local modem = peripheral.find("modem")
    if modem and gps.locate() then
        return true
    end
    return false
end


--To orientate
function tuplus.orientate(option)
    orientateFacing(option)
    orientatePosition(option)
end


function tuplus.facingDistance(dirInicial, dirFinal)    --Matemática circular :)
    return (dirFinal - dirInicial) % 4
end


-- Funções para rotacionar
function tuplus.turnRight()
    turtle.turnRight()
    local facing = getFacing()
    facing = facing + 1
    facing = facing%4     --Matemática circular :3
    setFacing(facing)
    registrarMovimento(MOVIMENTO.RIGHT)
end


function tuplus.turnLeft()
    turtle.turnLeft()
    local facing = getFacing()
    facing = facing - 1
    facing = facing%4     --Matemática de relógio XD
    setFacing(facing)
    registrarMovimento(MOVIMENTO.LEFT)
end


function tuplus.turnTo(targetDirection)
    while getFacing() ~= targetDirection do
        if facingDistance(getFacing(), targetDirection) > 1 then
            turnLeft()
        else
            turnRight()
        end
    end
end


--Digging Functions
function tuplus.tryDig()
    while turtle.detect() do
        turtle.dig()
        sleep(0.1)
    end
end


function tuplus.tryDigUp()
    while turtle.detectUp() do
        turtle.digUp()
        sleep(0.1)
    end
end


function tuplus.tryDigDown()
    while turtle.detectDown() do
        turtle.digDown()
        sleep(0.1)
    end
end


--Moving functions
function tuplus.forward()
    local moved = turtle.forward()
    if moved then
      local position = getPosition()
      local facing = getFacing()
      setPosition(position + facingToVector(facing))
      registrarMovimento(MOVIMENTO.FORWARD)
    end
    return moved
end


function tuplus.back()
    local moved = turtle.back()
    if moved then
      local position = getPosition()
      local facing = getFacing()
      setPosition(position - facingToVector(facing))
      registrarMovimento(MOVIMENTO.BACK)
    end
    return moved
end


function tuplus.up()
  local moved = turtle.up()
  if moved then
    local position = getPosition()
		setPosition(position + vector.new(0, 1, 0))
    registrarMovimento(MOVIMENTO.UP)
	end
  return moved
end


function tuplus.down()
  local moved = turtle.down()
	if moved then
    local position = getPosition()
    setPosition(position + vector.new(0, -1, 0))
    registrarMovimento(MOVIMENTO.DOWN)
	end
  return moved
end


function tuplus.walkTo(destination)
    local x = destination.x
    local y = destination.y
    local z = destination.z

    if getPosition().x > x then
        turnTo(WEST)
    elseif getPosition().x < x then
        turnTo(EAST)
    end

    while getPosition().x ~= x do
        tryDig()
        forward()
    end

    if getPosition().z < z then
        turnTo(SOUTH)
    elseif getPosition().z > z then
        turnTo(NORTH)
    end

    while getPosition().z ~= z do
        tryDig()
        forward()
    end

    while getPosition().y ~= y do
        if getPosition().y < y then
            tryDigUp()
            up()
        elseif getPosition().y > y then
            tryDigDown()
            down()
        end
    end
end


function tuplus.upUntil()
    while up() do end
end


function tuplus.downUntil()
    while down() do end
end


function tuplus.forwardUntil()
    while forward() do end
end


function tuplus.backUntil()
    while back() do end
end


function tuplus.smoothWalkTo(destination)
    while not getPosition().equals(destination) do
        local deslocamento = destination - getPosition()
        while deslocamento:dot(facingToVector(getFacing())) <= 0 do
            turnLeft()
        end
        forward()
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
function tuplus.getCaminho(nome_caminho)
    return Caminhos[nome_caminho]
end


-- Retorna a lista de movimentos de um caminho
function tuplus.getMovimentos(nome_caminho)
    local caminho = getCaminho(nome_caminho)
    return caminho.movimentos
end


-- Altera o valor de um caminho
function tuplus.setCaminho(nome_caminho, caminho)
    Caminhos[nome_caminho] = caminho
end


-- Cria um caminho novo na lista de caminhos
-- Caminhos sao ativos por padrao
function tuplus.novoCaminho(nome)
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
function tuplus.deletarCaminho(nome_caminho)
    Caminhos[nome_caminho] = nil
end


-- Verifica se um caminho existe
function tuplus.existeCaminho(nome_caminho)
    return Caminhos[nome_caminho] ~= nil
end


-- Inicia a gravação de um caminho para poder ser atualizado
function tuplus.gravarCaminho(nome_caminho)
    if not existeCaminho(nome_caminho) then
        novoCaminho(nome_caminho)
    end
    Caminhos[nome_caminho].gravando = true
end


-- Encerra a gravação de um caminho, para que nao possa ser alterado
function tuplus.pararGravacaoCaminho(nome_caminho)
    if not existeCaminho(nome_caminho) then
        return
    end
    Caminhos[nome_caminho].gravando = false
end


-- Percorre um caminho
function tuplus.percorrerCaminho(nome_caminho)
    local caminho = getCaminho(nome_caminho)
    for k, movimento in pairs(caminho.movimentos) do
        DICT_MOVIMENTO[movimento]()
    end
end


-- Percorre um caminho de tras para frente
function tuplus.desfazerCaminho(nome_caminho)
    pararGravacaoCaminho(nome_caminho)
    local caminho = getCaminho(nome_caminho)
    local movimentos = caminho.movimentos
    for i = #movimentos, 1, -1 do
        local movimento = movimentos[i]
        DICT_MOVIMENTO_R[movimento]()
    end
end


-- Limpa o registro de um caminho sem deleta-lo
function tuplus.limparCaminho(nome_caminho)
    Caminhos[nome_caminho].movimentos = {}
end

-- Calcula o tamanho de um caminho
function tuplus.tamanhoCaminho(nome_caminho)
    local movimentos = getMovimentos(nome_caminho)

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
function tuplus.salvarCaminho(nome_caminho, nome_arquivo)
    local caminho = getCaminho(nome_caminho)
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

function tuplus.carregarCaminho(nome_caminho, nome_arquivo)
    local file = io.open(nome_arquivo, "r")
    if not file then
        print("[Erro] Arquivo ".. nome_arquivo .."não existe")
        return
    end
    local content = file:read()
    file:close()
    local caminho_carregado = textutils.unserializeJSON(content)
    setCaminho(nome_caminho, caminho_carregado)
end


-- Funcoes de Inventario
function tuplus.search(itemName)
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


function tuplus.searchNotEmptySlot()
    for slot=1, 16 do
        if turtle.getItemCount(slot) > 0 then 
            turtle.select(slot)
            return true
        end
    end
    return false
end


-- Verifica se inventario esta cheio 
function tuplus.inventarioCheio()
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
function tuplus.esvaziarInventario()
    local selected_slot = turtle.getSelectedSlot()
    for s=1, 16 do
        turtle.select(s)
        turtle.drop()
    end
    turtle.select(selected_slot)
end


-- Inspeciona para ver se o bloco da frente eh o desejado
function tuplus.isBlock(block_name)
    local _, block = turtle.inspect()
    return block.name == block_name
end


-- Inspeciona para ver se o bloco de cima eh o desejado
function tuplus.isBlockUp(block_name)
    local _, block = turtle.inspectUp()
    return block.name == block_name
end


-- Inspeciona para ver se o bloco de baixo eh o desejado
function tuplus.isBlockDown(block_name)
    local _, block = turtle.inspectDown()
    return block.name == block_name
end


function tuplus.distanceToMe(final_pos)
    local diff_vector = final_pos - (getPosition() + vector.new(0.5, 0.5, 0.5))
    return diff_vector:length()
end


function tuplus.closestPos(pos_list)
    local menor_distancia = distanceToMe(pos_list[1])
    local closest = pos_list[1]
    for i,posicao in ipairs(pos_list) do
        if distanceToMe(posicao) < menor_distancia then
            menor_distancia = distanceToMe(posicao)
            closest = posicao
        end
    end
    return closest
end



-- Funcoes de construcao
function tuplus.place()
    canPlace, error = turtle.place()
    while not canPlace do
        if error == "Cannot place block here" then
            return turtle.place()
        end
        if not searchNotEmptySlot() then
            return turtle.place()
        end
        canPlace, error = turtle.place()
    end
    return true
end


function tuplus.placeDown()
    canPlace, error = turtle.placeDown()
    while not canPlace do
        if error == "Cannot place block here" then
            return turtle.placeDown()
        end
        if not searchNotEmptySlot() then
            return turtle.placeDown()
        end
        canPlace, error = turtle.placeDown()
    end
    return true
end


function tuplus.placeUp()
    canPlace, error = turtle.placeUp()
    while not canPlace do
        if error == "Cannot place block here" then 
            return turtle.placeUp()
        end
        if not searchNotEmptySlot() then
            return turtle.placeUp()
        end
        canPlace, error = turtle.placeUp()
    end
    return true
end


-- Funções de combustivel
function tuplus.refuelAll()
    shell.run('refuel', 'all')
end


return tuplus
