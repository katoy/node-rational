assert = require('chai').assert
path = require 'path'

libPath = if (process.env.TEST_COV) then 'lib-cov/Rational' else  'lib/Rational'  
libPath = path.join __dirname, '..', libPath
Rational = require libPath

util = require 'util'

# 整数の最大値 9007199254740992
MAX_INT = Math.pow(2, 53)

# 整整の最小値 -9007199254740991
MIN_INT = 1 - MAX_INT

describe "parseFloat", ->
  it "0 -> 0/1", ->
    r = Rational.parseFloat(0)
    assert.equal r.toString(), "0/1"

  it "1 -> 1/1", ->
    r = Rational.parseFloat(1)
    assert.equal r.toString(), "1/1"

  it "-1 -> -1/1", ->
    r = Rational.parseFloat(-1)
    assert.equal r.toString(), "-1/1"

  it "10 -> 10/1", ->
    r = Rational.parseFloat(10)
    assert.equal r.toString(), "10/1"

  it "-10 -> -10/1", ->
    r = Rational.parseFloat(-10)
    assert.equal r.toString(), "-10/1"

  it "0.1 -> 1/10", ->
    r = Rational.parseFloat(0.1)
    assert.equal r.toString(), "1/10"

  it "-0.1 -> -1/10", ->
    r = Rational.parseFloat(-0.1)
    assert.equal r.toString(), "-1/10"

  it "1.23456789 -> 123456789/100000000", ->
    r = Rational.parseFloat(1.23456789)
    assert.equal r.toString(), "123456789/100000000"

  it "123456789 -> 123456789/1", ->
    r = Rational.parseFloat(123456789)
    assert.equal r.toString(), "123456789/1"

  it "0.0000001 -> 1/10000000", ->
    r = Rational.parseFloat(0.0000001)
    assert.equal r.toString(), "1/10000000"

