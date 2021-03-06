PEG = require 'pegjs'
util = require 'util'
assert = require('chai').assert
arithmetics = require '../lib/arithmetics' 

###
# 走らせ方
#　========
# $ npm pegjs
# $ ./node_modules/.bin/pegjs arithmetics.pegjs
# $ mv arithmetics.js ../lib
# $ coffee expression.coffee
#
#   +, - : 加法、減俸  左結合
#   *, / : 乗法, 除法　左結合
#   ^    : べき乗　　　右結合
#  (, )  : 
#
#  web-browser 用の javascript が欲しければ、次のようにする。
# $ ./node_modules/.bin/pegjs arithmetics.pegjs#
#
###

exps = [
  # 数式,  評価値
  ["1",       1]
  ["12",     12]
  ["2+1",     3]
  ["1+2*3",   7]
  ["1-2*3",  -5]
  [" 1",      1]
  [" 1 + 2 ", 3]
  [" 1 + 2 * 3 ", 7]
  [" ( 1 + 2 ) * 3 ", 9]

  ["10-1", 9]
  ["10/2", 5]

  ["1+2-3", 0]
  ["12/2*3", 18]
  ["12/3*2",  8]
  ["12*2/3",  8]
  ["2*12/3",  8]

  ["-1",     -1]
  ["+1",      1]
  [" 1",      1]

  ["-1.2",   -1.2]
  ["+1.2",    1.2]
  [" 1.2",    1.2]
  [" .2",     0.2]

  ["(1.2)",    1.2]
  ["(+1.2)",    1.2]
  ["(-1.2)",    -1.2]
  ["-(+1.2)",    -1.2]
  ["-(-1.2)",    1.2]

  ["1.2 + 2.3",  3.5]
  ["1.2 + 2.1 * 10",  22.2]

  ["1 + +2",   3],
  ["1 + -2",  -1],
  ["1 * +2",   2],
  ["1 * -2",  -2],

  ["1/3",    0.3333333333333333]
  ["(10-1) * (10 + 1)",    99]

  ["2^3",       8]
  ["2^(2^3)",  256]
  ["2^2^3",    256]
  ["(2^2)^3",   64]
  ["9^0.5",      3]
  ["2^0.5",      1.4142135623730951]
  ["2^0.5+2",    3.4142135623730951]
  ["2^0.5*2",    2.8284271247461903]
  # ["(1+1/9) * 9", 10]

  ["12345679 * 9",    111111111]
  ["10000000000 ^ 10000000000", "Infinity"]
  ["-10000000000 ^ 10000000001", "-Infinity"]

  # 数式,  エラーメッセージ
  ["(",        'Expected "(", "+", "-", float or integer but end of input found.']
  ["*",        'Expected "(", "+", "-", float or integer but "*" found.']
  ["+",        'Expected "(" but end of input found.']
  ["()",       'Expected "(", "+", "-", float or integer but ")" found.']
  ["1+",       'Expected "(", "+", "-", float or integer but end of input found.']
  ["A",        'Expected "(", "+", "-", float or integer but "A" found.']
]

for exp in exps
  try
    # console.log "#{exp[0]} = #{arithmetics.parse(exp[0])}"  # evaluated value
    assert.equal(arithmetics.parse(exp[0]), exp[1])
  catch e
    # console.log "#{exp[0]}: #{e.message}"                   # syntax error
    assert.equal(e.message, exp[1], exp[0])
