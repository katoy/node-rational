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

describe "constructor (int)", ->
  it "Rational(1,1) = [1,1]", ->
    r = new Rational(1,1)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 1"
    assert.equal r.toString(), "1/1"
    assert.equal r.toStringN(10), "1/1"
    assert.equal r.toStringN(2), "1/1"
    assert.equal r.toStringN(8), "1/1"
    assert.equal r.toStringN(16), "1/1"

    assert.equal r.toStringN(), "1/1"

  it "Rational(12,1) = [12,1]", ->
    r = new Rational(12,1)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "12, 1"
    assert.equal r.toString(), "12/1"
    assert.equal r.toStringN(10), "12_10/1"
    assert.equal r.toStringN(2), "1100_2/1"
    assert.equal r.toStringN(8), "14_8/1"
    assert.equal r.toStringN(16), "C_16/1"

    assert.equal r.toStringN(), "12_10/1"

  it "Rational(12,13) = [12,13]", ->
    r = new Rational(12,13)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "12, 13"
    assert.equal r.toString(), "12/13"
    assert.equal r.toStringN(10), "12_10/13_10"
    assert.equal r.toStringN(2), "1100_2/1101_2"
    assert.equal r.toStringN(8), "14_8/15_8"
    assert.equal r.toStringN(16), "C_16/D_16"

    assert.equal r.toStringN(), "12_10/13_10"

  it "Rational(-12,13) = [-12,13]", ->
    r = new Rational(-12,13)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-12, 13"
    assert.equal r.toString(), "-12/13"
    assert.equal r.toStringN(10), "-12_10/13_10"
    assert.equal r.toStringN(2), "-1100_2/1101_2"
    assert.equal r.toStringN(8), "-14_8/15_8"
    assert.equal r.toStringN(16), "-C_16/D_16"

    assert.equal r.toStringN(), "-12_10/13_10"
