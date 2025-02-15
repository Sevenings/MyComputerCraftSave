
local function askFor(condition, inputMsg, errorMsg, sleepTime)
    if not sleepTime then
        sleepTime = 0.5
    end

    local conditionResult = false
    while not conditionResult do
        print(inputMsg)
        local input = read()
        conditionResult = condition(input)
        if not conditionResult then
            print(errorMsg)
            sleep(sleepTime)
        end
    end
    return conditionResult
end


return {
    askFor = askFor,
}