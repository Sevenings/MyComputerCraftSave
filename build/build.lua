local tp = require("tuplus")

local DICT_INSTRUCOES = {
    -- Movimento
    ["f"] = tp.forward,
    ["b"] = tp.back,
    ["r"] = tp.turnRight,
    ["l"] = tp.turnLeft,
    ["u"] = tp.up,
    ["d"] = tp.down,

    -- Colocar Blocos
    ["p"] = tp.place,
    ["pU"] = tp.placeUp,
    ["pD"] = tp.placeDown,

    -- Selecionar Itens
    ["s"] = tp.search,
}

local function fazerInstrucao(instrucao)
    local funcao = DICT_INSTRUCOES[instrucao.nome]
    local parametros = instrucao.parametros
    funcao(table.unpack(parametros))
end

return {

    -- Cria uma instrução nova
    criarInstrucao = function (nome_instrucao, parametros)
        return {
            nome = nome_instrucao,
            parametros = parametros
        }
    end,

    -- Carrega um manual de instruções
    carregarManual = function (nome_arquivo)
        local file = io.open(nome_arquivo, "r")
        if not file then
            print("[Erro] Arquivo ".. nome_arquivo .."não existe")
            return
        end
        local content = file:read("a")
        local manual = textutils.unserializeJSON(content)
        file:close()
        return manual
    end,


    -- Executa o manual
    executarManual = function (manual)
        local instrucoes = manual.instrucoes
        for _, instrucao in ipairs(instrucoes) do
            fazerInstrucao(instrucao)
        end
    end,
}
