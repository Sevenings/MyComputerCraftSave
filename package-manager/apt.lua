-- Variaveis globais
local PATH_CATALOGO = '.catalogo_apt'
local REPOSITORIO = 'https://raw.githubusercontent.com/Sevenings/MyComputerCraftSave/main/'

-- Verifica se o arquivo de catálogo existe
local function catalogoExiste()
    return fs.exists(PATH_CATALOGO)
end


-- Salva um objeto de catalogo no arquivo de catalogo
local function setCatalogo(catalogo)
    local file = fs.open(PATH_CATALOGO, 'w')
    file.write(textutils.serialize(catalogo))
    file:close()
end


-- Retorna um objeto do catalogo
local function getCatalogo()
    local file = fs.open(PATH_CATALOGO, 'r')
    local catalogo = textutils.unserialize(file:readAll())
    file:close()
    return catalogo
end


-- Cria um novo arquivo de catalogo em branco
local function criarCatalogo()
    if catalogoExiste() then return end
    local catalogo_table = {}
    setCatalogo(catalogo_table)
end


-- Abre o arquivo de catalogo e adiciona um novo pacote ao catalogo
local function adicionarAoCatalogo(pacote)
    if not catalogoExiste() then return end
    local catalogo = getCatalogo()
    catalogo[pacote] = true
    setCatalogo(catalogo)
end


-- Abre o arquivo de catalogo e remove um pacote do catalogo
local function removerDoCatalogo(pacote)
    if not catalogoExiste() then return end
    local catalogo = getCatalogo()
    catalogo[pacote] = false
    setCatalogo(catalogo)
end


-- Verifica se pacote esta no catalogo
local function estaNoCatalogo(pacote)
    if not catalogoExiste() then return end
    local catalogo = getCatalogo()
    if catalogo[pacote] then
        return true
    end
    return false
end


-- Adiciona um novo pacote ao sistema
local function adicionarPacote(pacote)
    if not catalogoExiste() then return end
    if estaNoCatalogo(pacote) then
        print('Pacote já está presente')
        return
    end
    shell.run('wget', REPOSITORIO..pacote..'.lua', pacote..'.lua')
    adicionarAoCatalogo(pacote)
end


-- Remove um pacote já instalado do sistema
local function removerPacote(pacote)
    if not catalogoExiste() then return end
    if not estaNoCatalogo(pacote) then
        print('Pacote não encontrado')
        return
    end
    shell.run('rm', pacote..'.lua')
    removerDoCatalogo(pacote)
end


local function setup()
    if not catalogoExiste() then
        print("Arquivo de catalogo nao encontrado, criando catalogo...")
        criarCatalogo()
    end
end


-- Script 

setup()

local command = arg[1]

-- apt get <package>
if command == 'get' then
    local pacote = arg[2]
    adicionarPacote(pacote)

-- apt update
elseif command == 'update' then


-- apt remove <package>
elseif command == 'remove' then
    local pacote = arg[2]
    removerPacote(pacote)


-- apt list 
elseif command == 'list' then


-- apt search <package>
elseif command == 'search' then
    local pacote = arg[2]
    print(estaNoCatalogo(pacote))


-- help
else
    print('Help:')
    print('  - apt get <package>')
    print('  - apt update')
    print('  - apt remove <package>')
    print('  - apt list')
    print('  - apt search <package>')
end

