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

describe "toStringN, toRepeatStringN", ->
  it "1/2", ->
    r = new Rational(1,2)
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 2"
    assert.equal r.toString(), "1/2"
    assert.equal r.toRepeatStringN(10), "0.5_10"
    assert.equal r.toRepeatStringN(10, false), "0.5"
    assert.equal r.toRepeatStringN(10, true), "0.5_10"

    assert.equal r.toRepeatStringN(2), "0.1_2"
    assert.equal r.toRepeatStringN(2, false), "0.1"
    assert.equal r.toRepeatStringN(2, false), "0.1"

    assert.equal r.toRepeatStringN(3), "0.{1}_3"
    assert.equal r.toRepeatStringN(3, false), "0.{1}"
    assert.equal r.toRepeatStringN(3, true), "0.{1}_3"

    assert.equal r.toRepeatStringN(8), "0.4_8"
    assert.equal r.toRepeatStringN(8, false), "0.4"
    assert.equal r.toRepeatStringN(8, true), "0.4_8"

    assert.equal r.toRepeatStringN(16), "0.8_16"
    assert.equal r.toRepeatStringN(16, false), "0.8"
    assert.equal r.toRepeatStringN(16, true), "0.8_16"

    assert.equal r.toRepeatStringN(36), "0.I_36"
    assert.equal r.toRepeatStringN(36, false), "0.I"
    assert.equal r.toRepeatStringN(36, true), "0.I_36"
