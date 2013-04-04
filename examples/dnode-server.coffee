
util = require 'util'
dnode = require 'dnode'
arithmeticsR = require '../lib/arithmeticsR'
Rational = require '../lib/Rational'

port = 5040

service =
  parse: (expStr, callback) ->
    
    val = ""
    try      
      val = if expStr is "end" then "end" else arithmeticsR.parse("#{expStr}").toString()
    catch ex
      val = ex.toString()

    util.log "#--- prre: #{expStr} -> #{val}"
    callback? val

server = dnode(service)
server.listen port
console.log "start port #{port}"
