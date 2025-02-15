-- Função para quebrar a árvore 2x2
function treeCapitate()
    local height = 0

    turtle.dig()
    turtle.forward()

    -- Sobe quebrando os troncos da primeira coluna
    while turtle.detectUp() do
        turtle.dig() -- Quebra o tronco à frente
        turtle.digUp() -- Quebra o tronco acima
        turtle.up() -- Sobe
        height = height + 1
    end

    -- Move para a esquerda (segunda coluna)
    turtle.turnLeft() -- Vira para a esquerda
    turtle.dig() -- Move de volta para a primeira coluna
    turtle.forward() -- Move para a frente (segunda coluna)
    turtle.turnRight() -- Volta a olhar para a direção original

    -- Desce quebrando os troncos da segunda coluna
    for i = 1, height do
        turtle.dig() -- Quebra o tronco à frente
        turtle.digDown() -- Quebra o tronco abaixo (se houver)
        turtle.down() -- Desce
    end

    -- Volta para a posição inicial
    turtle.turnRight() -- Vira para a direita
    turtle.forward() -- Move de volta para a primeira coluna
    turtle.turnLeft() -- Volta a olhar para a direção original

    turtle.back()
end

-- Função para plantar uma muda de pinheiro
function plantSapling()
    turtle.select(1) -- Seleciona o slot onde está a muda de pinheiro
    turtle.place() -- Planta a muda
end

-- Função principal
while true do
    local hasBlock, block = turtle.inspect()
    if block.name == "minecraft:spruce_log" then
        treeCapitate()
        turtle.place()
    end
    os.sleep(5) -- Espera 5 segundos antes de verificar novamente
end

