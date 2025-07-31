local preferences_filename = "preferences.config"


-- Cria um novo atributo com nome attributeName, caso não exista, no objeto object com o valor defaultValue
local function defAttribute(object, attributeName, defaultValue)
    if object[attributeName] == nil then
        object[attributeName] = defaultValue
    end
end




-- Definição de uma Preferencia Padrão.
-- Caso uma Preferencia ainda não tenha sido criada, ela será criada com essa forma
local function defPreferences(preference)
    -- DEFINA AQUI O FORMATO DO ARQUIVO DE PREFERENCIAS
    defAttribute(preference, "orientateOnStartup", false)
end




local function setPreferences(newPreferencesTable)
    local file = io.open(preferences_filename, "w")
    local content = textutils.serialize(newPreferencesTable)
    file:write(content)
    file:close()
end


local function getPreferences()
    local needSave = false

    if not fs.exists(preferences_filename) then
        fs.open(preferences_filename, "w")
    end
    local file = io.open(preferences_filename)
    local content = file:read("*all")
    local preferences = textutils.unserialize(content)
    if not preferences then
        preferences = {}
        needSave = true
    end

    defPreferences(preferences)

    if needSave then
        setPreferences(preferences)
    end

    return preferences
end


return {
    getPreferences = getPreferences,
    setPreferences = setPreferences,
}
