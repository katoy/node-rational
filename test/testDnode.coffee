dnode = require 'dnode'
assert = require 'assert'
arithmeticsR = require '../lib/arithmeticsR'
util = require 'util'

PORT = 3000

service =
  evalStr: (str, callback) ->
    val = ""
    try
      val = arithmeticsR.parse(str).toRepeatString()
    catch ex
      val = ex.toString()
    callback? val

server = dnode(service)
server.listen(PORT)
console.log "start server port #{PORT}"

describe "object ref tests",  ->
  
  it "1", (done) ->
    client = dnode.connect(PORT)

    client.on "remote", (remote, conn) ->
      remote.evalStr "1", (res) ->
        assert.equal res, "1"
        done()
  
  it "expression", (done) ->
    exps = [
      ["1+2*3", "7"]
      ["(1+2)*3", "9"]
      ["10_2", "2"]
      ["20_16", "32"]
    ]

    client = dnode.connect(PORT)

    check_exp = (remote, exp, ans) ->
      remote.evalStr exp, (res) ->
        assert.equal ans, res, "exp=#{exp}"
  
    client.on "remote", (remote, conn) ->      
      for exp in exps
        check_exp(remote, exp[0], exp[1])
      done()
  