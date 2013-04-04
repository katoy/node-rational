

# alichmeticsR の機能を sever として提供し、client から利用する例；
#   $ coffee pillion-server.coffee
#   $ coffee pillion-client.coffee

net = require 'net'
util = require 'util'
burro = require 'burro'
pillion = require 'pillion'
arithmeticsR = require '../lib/arithmeticsR'

port = 3000

service = (socket) ->
  rpc = new pillion(burro.wrap(socket))

  rpc.provide 'eval', (str, cb) ->
    val = ""
    try
      val = if str is "end" then "end" else arithmeticsR.parse(str) 
    catch ex
      val = "#{ex.toString()}"

    util.log "#--- #{str} -> #{val}"
    cb? "#{val}"
  
server = net.createServer(service)
server.listen port
console.log "start port #{port}"
