local tp = require 'tuplus'

tp.iniciarGravacaoCaminho('bau')

tp.forward()
tp.forward()

sleep(1)

tp.desfazerCaminho('bau')

