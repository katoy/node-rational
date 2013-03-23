assert = require('chai').assert
path = require 'path'

libPath = if (process.env.TEST_COV) then 'lib-cov/arithmetidcsR' else  'lib/arithmeticsR'
libPath = path.join __dirname, '..', libPath
arithmeticsR = require libPath

Rational = require '../lib/Rational'
bignum = require 'bignum'

util = require 'util'

# 整数の最大値 9007199254740992
MAX_INT = Math.pow(2, 53)

# 整整の最小値 -9007199254740991
MIN_INT = 1 - MAX_INT

describe "整数", ->
  it "1", ->
    r = arithmeticsR.parse("1")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 1"
    assert.equal r.reduce().toRepeatString(), "1"

  it "0", ->
    r = arithmeticsR.parse("0")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "0, 1"
    assert.equal r.reduce().toRepeatString(), "0"

  it "-1", ->
    r = arithmeticsR.parse("-1")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-1, 1"
    assert.equal r.reduce().toRepeatString(), "-1"

  it "12345678901234567891234567890123456789", ->
    r = arithmeticsR.parse("12345678901234567891234567890123456789")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "12345678901234567891234567890123456789, 1"
    assert.equal r.reduce().toRepeatString(), "12345678901234567891234567890123456789"

  it "-12345678901234567891234567890123456789", ->
    r = arithmeticsR.parse("-12345678901234567891234567890123456789")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-12345678901234567891234567890123456789, 1"
    assert.equal r.reduce().toRepeatString(), "-12345678901234567891234567890123456789"

describe "小数", ->
  it "0.3 -> 3/10", ->
    r = arithmeticsR.parse("0.3")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "3, 10"
    assert.equal r.reduce().toRepeatString(), "0.3"

  it "0.0 -> 0/1", ->
    r = arithmeticsR.parse("0.0")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "0, 1"
    assert.equal r.reduce().toRepeatString(), "0"

  it "-0.3 -> -1/3", ->
    r = arithmeticsR.parse("-0.3")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-3, 10"
    assert.equal r.reduce().toRepeatString(), "-0.3"

  it "1.3 -> 13/10", ->
    r = arithmeticsR.parse("1.3")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "13, 10"
    assert.equal r.reduce().toRepeatString(), "1.3"

  it "1.2 -> 6/5", ->
    r = arithmeticsR.parse("1.2")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "6, 5"
    assert.equal r.reduce().toRepeatString(), "1.2"

  it "1.2345678901234567890123456789", ->
    r = arithmeticsR.parse("1.2345678901234567890123456789")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "12345678901234567890123456789, 10000000000000000000000000000"
    assert.equal r.reduce().toRepeatString(), "1.2345678901234567890123456789"

  it "-1.2345678901234567890123456789", ->
    r = arithmeticsR.parse("-1.2345678901234567890123456789")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-12345678901234567890123456789, 10000000000000000000000000000"
    assert.equal r.reduce().toRepeatString(), "-1.2345678901234567890123456789"

describe "循環小数", ->
  it "0.{3} -> 1/3", ->
    r = arithmeticsR.parse("0.{3}")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 3"
    assert.equal r.reduce().toRepeatString(), "0.{3}"

  it "0.{0}", ->
    r = arithmeticsR.parse("0.{0}")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "0, 1"
    assert.equal r.reduce().toRepeatString(), "0"

  it "-0.{3}", ->
    r = arithmeticsR.parse("-0.{3}")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-1, 3"
    assert.equal r.reduce().toRepeatString(), "-0.{3}"

  it "0.{12345678901}", ->
    r = arithmeticsR.parse("0.{12345678901}")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "12345678901, 99999999999"
    assert.equal r.reduce().toRepeatString(), "0.{12345678901}"

  it "-0.{12345678901}", ->
    r = arithmeticsR.parse("-0.{12345678901}")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-12345678901, 99999999999"
    assert.equal r.reduce().toRepeatString(), "-0.{12345678901}"

  it "0.{12} -> 4/33", ->
    r = arithmeticsR.parse("0.{12}")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "4, 33"
    assert.equal r.reduce().toRepeatString(), "0.{12}"

describe "加法,減法", ->
  it "0.{3} + 0.{6} = 1", ->
    r = arithmeticsR.parse("0.{3} + 0.{6}")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 1"
    assert.equal r.reduce().toRepeatString(), "1"

  it "0.3 + 0.6 = 0.9", ->
    r = arithmeticsR.parse("0.3 + 0.6")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "9, 10"
    assert.equal r.reduce().toRepeatString(), "0.9"

  it "0.{3} - 0.{6} = 1", ->
    r = arithmeticsR.parse("0.{3} - 0.{6}")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-1, 3"
    assert.equal r.reduce().toRepeatString(), "-0.{3}"

  it "0.3 - 0.6 = 0.9", ->
    r = arithmeticsR.parse("0.3 - 0.6")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "-3, 10"
    assert.equal r.reduce().toRepeatString(), "-0.3"

  it "1 + 2 + 3 + 4 - 5 - 5 = 0", ->
    r = arithmeticsR.parse("1 + 2 + 3 + 4 - 5 - 5")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "0, 1"
    assert.equal r.reduce().toRepeatString(), "0"

describe "載法, 除法", ->
  it "0.{3} * 3 -> 1", ->
    r = arithmeticsR.parse("0.{3} * 3")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 1"
    assert.equal r.reduce().toRepeatString(), "1"

  it "0.3 * 3 -> 0.9", ->
    r = arithmeticsR.parse("0.3 * 3")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "9, 10"
    assert.equal r.reduce().toRepeatString(), "0.9"

  it "0.{3} / 3 -> 0.{1}", ->
    r = arithmeticsR.parse("0.{3} / 3")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 9"
    assert.equal r.reduce().toRepeatString(), "0.{1}"

  it "0.3 / 3 -> 0.1", ->
    r = arithmeticsR.parse("0.3 / 3")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "1, 10"
    assert.equal r.reduce().toRepeatString(), "0.1"

  it "2 * 3 / 4 * 5 -> 7.5", ->
    r = arithmeticsR.parse("2 * 3 / 4 * 5")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "15, 2"
    assert.equal r.reduce().toRepeatString(), "7.5"

describe "演算の優先度", ->
  it "1 + 2 * 3 -> 7", ->
    r = arithmeticsR.parse("1 + 2 * 3")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "7, 1"
    assert.equal r.reduce().toRepeatString(), "7"

  it "(1 + 2) * 3 -> 9", ->
    r = arithmeticsR.parse("(1 + 2) * 3")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "9, 1"
    assert.equal r.reduce().toRepeatString(), "9"


describe "Space ", ->
  it "1+2*3 -> 7", ->
    r = arithmeticsR.parse("1+2*3")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "7, 1"
    assert.equal r.reduce().toRepeatString(), "7"

  it " 1 + 2 * 3 -> 7", ->
    r = arithmeticsR.parse(" 1 + 2 * 3 ")
    assert.equal "#{r.numerator()}, #{r.denominator()}", "7, 1"
    assert.equal r.reduce().toRepeatString(), "7"