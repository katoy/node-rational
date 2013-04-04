
util = require 'util'
dnode = require 'dnode'

arithmeticsR = require '../lib/arithmeticsR'

port = 5040
d = dnode.connect(port)

exps = [
  "1+2*3"
  "(1+2)*3"
  "end"
]

d.on "remote", (remote) ->

  evalExp = (exp) ->
    remote.parse exp, (res) ->
      if res is "end"
        d.end()
      else
        console.log "#{exp} -> #{res}"

  for exp in exps
    evalExp(exp)
