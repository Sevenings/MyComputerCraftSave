local tp = require('tuplus')

local function backup()
    print('Fazendo backup')

    -- Tenha certeza que o checkpoint ainda não existe
    if tp.getCaminho('checkpoint') then
        tp.deletarCaminho('checkpoint')
    end
    tp.comecarCaminho('checkpoint')
    -- Salva a posição atual

    -- Volta para o bau
    tp.desativarCaminho('bau')
    tp.desfazerCaminho('bau')

    -- Chegando lá, se o combustivel for pouco, reabastece
    if turtle.getFuelLevel() <= 16 then
        print('Reabastecendo')
        tp.refuelAll()
    end

    -- Esvazia inventario
    print('Esvaziando Inventario')
    tp.turnLeft()
    tp.esvaziarInventario()
    tp.turnRight()

    -- Volta
    print('Voltando ao checkpoint')
    tp.ativarCaminho('bau')
    tp.limparCaminho('bau')
    tp.desativarCaminho('checkpoint')
    tp.desfazerCaminho('checkpoint')
end


-- setup colocar o bau
tp.search('quark:oak_chest')
tp.turnLeft()
tp.tryDig()
tp.place()

tp.tryDigUp()
tp.up()
tp.tryDig()
tp.down()

tp.turnRight()
tp.tryDig()
tp.forward()
tp.turnLeft()

tp.tryDig()
tp.place()
tp.tryDigUp()
tp.up()
tp.tryDig()
tp.down()

tp.turnRight()

-- Salvar um caminho de volta para o bau
tp.comecarCaminho('bau')


-- Argumentos
local profundidade = tonumber(arg[1])
if not profundidade then
    profundidade = 64
end

-- Mineracao
local completo = false
local p = 0
while not completo do
    -- Cava para frente
    tp.tryDig()
    tp.tryDigUp()

    -- Verifica se deve fazer backup
    local cheio = tp.inventarioCheio()
    local combustivel = turtle.getFuelLevel()
    local caminho_bau = tp.tamanhoCaminho('bau')
    print(string.format('Estado (%d)', p))
    print(string.format('Inventario Cheio: %d', cheio))
    print(string.format('Combustivel: %d', combustivel))
    print(string.format('Caminho Bau: %d', caminho_bau))
    if cheio or caminho_bau + 16 >= combustivel then
        backup()
    end

    tp.forward()
    p = p + 1
    if p >= profundidade then
        completo = true
    end
end

-- Após chegar ao final, volte ao começo
print('Terminando viagem')
tp.desativarCaminho('bau')
tp.desfazerCaminho('bau')
