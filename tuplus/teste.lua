local bd = require("build")
local pprint = require("cc.pretty").pretty_print

local manual = bd.carregarManual("manual.json")
bd.executarManual(manual)

