local tp = require("tuplus")

local pprint = require("cc.pretty").pretty_print

tp.iniciarGravacaoCaminho("quadrado")
tp.iniciarGravacaoCaminho("lado")

tp.forward()
tp.forward()
tp.forward()
tp.forward()
tp.turnRight()

tp.pararGravacaoCaminho("lado")

tp.percorrerCaminho("lado")
tp.percorrerCaminho("lado")
tp.percorrerCaminho("lado")

tp.pararGravacaoCaminho("quadrado")

tp.salvarCaminho("quadrado", "quadrado.path")
