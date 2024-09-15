local tp = require('tuplus')

local function backup()
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
        tp.refuelAll()
    end

    -- Esvazia inventario
    tp.esvaziarInventario()

    -- Volta
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
    if tp.inventarioCheio() or tp.tamanhoCaminho('bau') + 16 >= turtle.getFuelLevel() then
        backup()
    end

    tp.forward()
    p = p + 1
    if p >= profundidade then
        completo = true
    end
end

-- Após chegar ao final, volte ao começo
tp.desativarCaminho('bau')
tp.desfazerCaminho('bau')
