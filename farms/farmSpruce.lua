local tp = require "tuplus"

LOG = "minecraft:spruce_log"
SAPLING = "minecraft:spruce_sapling"

-- Função para quebrar a árvore 2x2
function tree_capitate()
    local height = 0

    turtle.dig()
    tp.forward()

    -- Sobe quebrando os troncos da primeira coluna
    while turtle.detectUp() do
        turtle.dig()
        turtle.digUp()
        tp.up()
        height = height + 1
    end
    turtle.dig()

    -- Move para a esquerda (segunda coluna)
    tp.turnRight()
    turtle.dig()
    tp.forward()
    tp.turnLeft()

    -- Desce quebrando os troncos da segunda coluna
    for i = 1, height do
        turtle.dig() -- Quebra o tronco à frente
        turtle.digDown() -- Quebra o tronco abaixo (se houver)
        tp.down() -- Desce
    end
    turtle.dig()

    -- Volta posição inicial
    tp.back()
    tp.turnLeft()
    tp.forward()
    tp.turnRight()
end

-- Função para plantar uma muda de pinheiro
function plantar_saplings()
    tp.search(SAPLING) -- Seleciona o slot onde está a muda de pinheiro
    tp.up()
    tp.forward()
    for i = 1, 4 do
      turtle.placeDown()
      tp.forward()
      tp.turnRight()
    end
    tp.back()
    tp.down()
end

function guardar_itens()
    -- Guardar todas as madeiras
    while tp.search(LOG) do
        turtle.dropDown() -- Despeja os itens no baú
    end
end

-- Setup
if not turtle.detect() then
  tp.search(SAPLING)
  plantar_saplings()
end

-- Função principal
while true do
    local hasBlock, block = turtle.inspect()
    if block.name == LOG then
        tree_capitate()
        plantar_saplings()
        guardar_itens()
    end
    os.sleep(5) -- Espera 5 segundos antes de verificar novamente
end

