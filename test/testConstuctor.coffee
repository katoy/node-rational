assert = require('chai').assert
path = require 'path'

libPath = if (process.env.TEST_COV) then 'lib-cov/Rational' else  'lib/Rational'  
libPath = path.join __dirname, '..', libPath
Rational = require libPath
bignum = require 'bignum'

util = require 'util'

# 整数の最大値 9007199254740992
MAX_INT = Math.pow(2, 53)

# 整整の最小値 -9007199254740991
MIN_INT = 1 - MAX_INT

describe "constructor (int)", ->
  it "Rational(1,1) = [1,1]", ->
    r = new Rational(1,1)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 1"
    assert.equal r.toString(), "1/1"
    assert.equal r.reduce().toString(), "1/1"

  it "Rational(1,-1) = [-1,1]", ->
    r = new Rational(1,-1)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-1, 1"
    assert.equal r.toString(), "-1/1"
    assert.equal r.reduce().toString(), "-1/1"

  it "Rational(-1,1) = [-1,1]", ->
    r = new Rational(-1,1)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-1, 1"
    assert.equal r.toString(), "-1/1"
    assert.equal r.reduce().toString(), "-1/1"

  it "Rational(-1,-1) = [1,1]", ->
    r = new Rational(-1,-1)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 1"
    assert.equal r.toString(), "1/1"
    assert.equal r.reduce().toString(), "1/1"

  it "Rational(0,-1) = [0,1]", ->
    r = new Rational(0,-1)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "0, 1"
    assert.equal r.toString(), "0/1"
    assert.equal r.reduce().toString(), "0/1"

  #it "Rational(1,0) -> error", ->
  #  assert.throw(new Rational(1, 0), "")
 
  it "Rational(2) = [2,1]", ->
    r = new Rational(2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "2, 1"
    assert.equal r.toString(), "2/1"

  it "Rational(0) = [0,1]", ->
    r = new Rational(0)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "0, 1"
    assert.equal r.toString(), "0/1"

  it "Rational(-1) = [-1,1]", ->
    r = new Rational(-1)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-1, 1"
    assert.equal r.toString(), "-1/1"

  it "Rational(10,10) = [10,10]", ->
    r = new Rational(10,10)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 1"
    assert.equal r.toString(), "10/10"

  it "Rational(MAX_INT) = [9007199254740992,1]", ->
    r = new Rational(MAX_INT)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "9007199254740992, 1"
    assert.equal r.toString(), "9007199254740992/1"

  it "Rational(MIN_INT) = [-9007199254740991,1]", ->
    r = new Rational(MIN_INT)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-9007199254740991, 1"
    assert.equal r.toString(), "-9007199254740991/1"

  it "Rational(10,30) = [10,30]", ->
    r = new Rational(10,30)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 3"
    assert.equal r.toString(), "10/30"

describe "constructor (str)", ->
  it "Rational('1','1') = [1,1]", ->
    r = new Rational('1','1')
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 1"
    assert.equal r.toString(), "1/1"
    assert.equal r.reduce().toString(), "1/1"

  it "Rational('1','-1') = [-1,1]", ->
    r = new Rational(1,-1)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-1, 1"
    assert.equal r.toString(), "-1/1"
    assert.equal r.reduce().toString(), "-1/1"

  it "Rational(MAX_INT) = [9007199254740992,1]", ->
    r = new Rational('9007199254740992')
    assert.equal "#{r.numerator()}, #{r.denominator()}", "9007199254740992, 1"
    assert.equal r.toString(), "9007199254740992/1"

  it "Rational(MAX_INT+1) = [9007199254740993,1]", ->
    r = new Rational('9007199254740993')
    assert.equal "#{r.numerator()}, #{r.denominator()}", "9007199254740993, 1"
    assert.equal r.toString(), "9007199254740993/1"

  it "Rational(MIN_INT) = [-9007199254740991,1]", ->
    r = new Rational('-9007199254740991')
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-9007199254740991, 1"
    assert.equal r.toString(), "-9007199254740991/1"

  it "Rational(MIN_INT-1) = [-9007199254740992,1]", ->
    r = new Rational('-9007199254740992')
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-9007199254740992, 1"
    assert.equal r.toString(), "-9007199254740992/1"

  it "Rational('10','30') = [10,30]", ->
    r = new Rational(10,30)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 3"
    assert.equal r.toString(), "10/30"

describe "constructor (bignum)", ->
  it "Rational(bignum(1), bignum(1)) = [1,1]", ->
    r = new Rational(bignum(1), bignum(1))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 1"
    assert.equal r.toString(), "1/1"
    assert.equal r.reduce().toString(), "1/1"

  it "Rational(bignum(1), bignum(-1)) = [-1,1]", ->
    r = new Rational(bignum(1), bignum(-1))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-1, 1"
    assert.equal r.toString(), "-1/1"
    assert.equal r.reduce().toString(), "-1/1"

  it "Rational(bignum(MAX_INT)) = [9007199254740992,1]", ->
    r = new Rational(bignum('9007199254740992'))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "9007199254740992, 1"
    assert.equal r.toString(), "9007199254740992/1"

  it "Rational(bignum(MAX_INT+1)) = [9007199254740993,1]", ->
    r = new Rational(bignum('9007199254740993'))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "9007199254740993, 1"
    assert.equal r.toString(), "9007199254740993/1"

  it "Rational(bignum(MIN_INT)) = [-9007199254740991,1]", ->
    r = new Rational(bignum('-9007199254740991'))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-9007199254740991, 1"
    assert.equal r.toString(), "-9007199254740991/1"

  it "Rational(bignum(MIN_INT-1)) = [-9007199254740992,1]", ->
    r = new Rational(bignum('-9007199254740992'))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-9007199254740992, 1"
    assert.equal r.toString(), "-9007199254740992/1"

  it "Rational(bignum('10'), bignum('30')) = [10,30]", ->
    r = new Rational(bignum(10), bignum(30))
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 3"
    assert.equal r.toString(), "10/30"

describe "constructor(x, 0)", ->
  it "Rational(1,0) -> error", ->
    try
      new Rational(1, 0)
      assert.true(false)
    catch e
      assert.equal(e.toString(), '#--- Rational.constructor: d == 0')

  it "Rational(0,0) -> error", ->
    try
      new Rational(0, 0)
      assert.true(false)
    catch e
      assert.equal(e.toString(), '#--- Rational.constructor: d == 0')

describe "constructor()", ->
  it "Rational() -> error", ->
    try
      new Rational()
      assert.true(false)
    catch e
      assert.equal(e.toString(), '#--- Rational.constructor: n == undefined')
