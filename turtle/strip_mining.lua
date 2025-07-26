local tp = require 'tuplus'

profundidade = 5

local function digNext()
    tp.tryDig()
    tp.tryDigUp()
    tp.forward()
end


for i = 1, profundidade do
    digNext()
end
