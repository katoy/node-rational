
#  このファイルを ./test/ 以下に置く。
#  mochh.opts も test/mocha.opt に置く。
#
#  てストの実行
# ==============　  
#  $ mocha test/test/testPillion.coffee 
#
assert = require 'assert'
util = require 'util'
net = require 'net'
burro = require 'burro'     # npm install burro
pillion = require 'pillion' # npm install pillion
arithmeticsR = require '../lib/arithmeticsR'

PORT = 3003

# -------------------
describe 'pillion', ->
  server = null
  client = null
  client_socket = null

  # ----- Helper -------
  create_server = (service) ->
    server = net.createServer(service)
    server.listen PORT   
    server
  
  create_client = ->
    client_socket = burro.wrap(net.connect(PORT))
    client = new pillion(client_socket)
    [client, client_socket]
  # -------------------

  before ->
    service = (socket) ->
      rpc = new pillion(burro.wrap(socket))
      rpc.provide 'parse', (str, callback) ->
        v = ""
        try
          v = arithmeticsR.parse(str).toRepeatString()
        catch ex
          v = ex.toString()
        callback? "#{v}"
    server = create_server(service)

  after -> 
    server.close() if server

  beforeEach ->
    [client, client_socket] = create_client()

  afterEach -> 
    client_socket.end() if client_socket
    client_socket = null

  it 'rpc("1") -> "1"', (done) ->
    client.callRemote 'parse', '1', (res) ->
      assert.equal res, "1"
      done()

  it 'expression', (done) ->
    exps = [
      ["1+2*3", "7"]
      ["(1+2)*3", "9"]
      ["10_2", "2"]
      ["20_16", "32"]
    ]

    check_exp = (exp, ans) ->
      client.callRemote 'parse', exp, (res) ->
        assert.equal res, ans
  
    for exp in exps
      check_exp(exp[0], exp[1])
    done()    
