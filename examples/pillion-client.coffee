net = require 'net'
burro = require 'burro'
pillion = require 'pillion'

port = 3000
socket = burro.wrap(net.connect(port))
rpc = new pillion(socket)

evalExp = (exp) ->
    rpc.callRemote "eval", exp, (res) ->
      if res is "end"
        socket.end()
      else
        console.log "[#{exp}] -> [#{res}]"

exps = [
  "1 + 2 * 3",
  "(1 + 2) * 3",
  "1/2 + 1/3",
  "1/11_2",
  "end"
]

for exp in exps
  evalExp(exp)

