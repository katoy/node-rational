assert = require('chai').assert
path = require 'path'

libPath = if (process.env.TEST_COV) then 'lib-cov/Rational' else  'lib/Rational'  
libPath = path.join __dirname, '..', libPath
Rational = require libPath
# bignum = require 'bignum'

util = require 'util'

# 整数の最大値 9007199254740992
MAX_INT = Math.pow(2, 53)

# 整整の最小値 -9007199254740991
MIN_INT = 1 - MAX_INT

describe "getBigIntegerBaseN(str, int)", ->
  it '("1", 10) -> [1,1]', ->
    r = new Rational(Rational.getBigIntegerBaseN("1", 10))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 1"

  it '("1",2) -> [1,1]', ->
    r = new Rational(Rational.getBigIntegerBaseN("1", 2))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 1"

  it '("10",2) -> [2,1]', ->
    r = new Rational(Rational.getBigIntegerBaseN("10", 2))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "2, 1"

  it '("F",16) -> [F,16]', ->
    r = new Rational(Rational.getBigIntegerBaseN("F", 16))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "15, 1"

  it '("FF",16) -> [FF,255]', ->
    r = new Rational(Rational.getBigIntegerBaseN("FF", 16))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "255, 1"

  it '("1",1) -> error', ->
    try
      r = new Rational(Rational.getBigIntegerBaseN("1", 1))
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.getBigIntegerBaseN: base <= 1"

  it '("1",37) -> error', ->
    try
      r = new Rational(Rational.getBigIntegerBaseN("1", 37))
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.getBigIntegerBaseN: base >= 36"

  it '("A",10) -> error', ->
    try
      r = new Rational(Rational.getBigIntegerBaseN("A", 10))
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.getBigIntegerBaseN: 'A' is not in ['0' .. '9']"

  it '("G",16) -> error', ->
    try
      r = new Rational(Rational.getBigIntegerBaseN("G", 16))
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.getBigIntegerBaseN: 'G' is not in ['0' .. 'F']"

  it '("-1",10) -> error', ->
    try
      r = new Rational(Rational.getBigIntegerBaseN("-1", 10))
      assert.ok(false)
    catch ex
      assert.equal ex.toString(), "#--- Rational.getBigIntegerBaseN: '-' is not in ['0' .. '9']"

describe "getBigIntegerBaseN(str, str)", ->
  it '("1","10") -> [1,1]', ->
    r = new Rational(Rational.getBigIntegerBaseN("1", "10"))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 1"

  it '("1","2") -> [1,1]', ->
    r = new Rational(Rational.getBigIntegerBaseN("1", "2"))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 1"

  it '("10","2") -> [2,1]', ->
    r = new Rational(Rational.getBigIntegerBaseN("10", "2"))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "2, 1"

  it '("F","16") -> [F,16]', ->
    r = new Rational(Rational.getBigIntegerBaseN("F", "16"))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "15, 1"

